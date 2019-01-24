/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2019-02-20
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L99
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldrh	r8, [r3]
	cmp	r8, r0
	bls	.L86
	ldr	r3, .L99+4
	movs	r5, #6
	muls	r5, r0, r5
	ldr	r4, [r3]
	movw	r3, #65535
	adds	r1, r4, r5
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r5]	@ movhi
	ldr	r3, .L99+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L87
.L98:
	str	r1, [r3]
.L86:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L87:
	ldr	r3, .L99+12
	ldrh	r6, [r1, #4]
	ldr	r10, [r3]
	ldrh	r3, [r10, r0, lsl #1]
	cbz	r6, .L94
	muls	r6, r3, r6
.L88:
	sub	r2, ip, r4
	movs	r7, #0
	asrs	r3, r2, #1
	ldr	r2, .L99+16
	muls	r2, r3, r2
	mov	r3, ip
	uxth	r2, r2
.L92:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r8, r7
	bcc	.L86
	cmp	r2, r0
	beq	.L86
	ldrh	lr, [r3, #4]
	cmp	lr, #0
	beq	.L90
	ldrh	fp, [r10, r2, lsl #1]
	mul	lr, lr, fp
	cmp	r6, lr
	bls	.L90
	ldrh	lr, [r3]
	movw	fp, #65535
	cmp	lr, fp
	bne	.L91
	strh	r2, [r1, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	ldr	r3, .L99+20
	b	.L98
.L94:
	mov	r6, #-1
	b	.L88
.L91:
	movs	r3, #6
	mov	r2, lr
	mla	r3, r3, lr, r4
	b	.L92
.L90:
	strh	r2, [r4, r5]	@ movhi
	cmp	r3, ip
	ldrh	r2, [r3, #2]
	strh	r2, [r1, #2]	@ movhi
	bne	.L93
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L99+8
	b	.L98
.L93:
	ldrh	r1, [r3, #2]
	movs	r2, #6
	muls	r2, r1, r2
	strh	r0, [r4, r2]	@ movhi
	strh	r0, [r3, #2]	@ movhi
	b	.L86
.L100:
	.align	2
.L99:
	.word	.LANCHOR5
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR42
	.word	-1431655765
	.word	.LANCHOR43
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
	ldr	r2, .L103
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L103+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L101
	movs	r2, #214
	ldr	r1, .L103+8
	ldr	r0, .L103+12
	pop	{r3, lr}
	b	printf
.L101:
	pop	{r3, pc}
.L104:
	.align	2
.L103:
	.word	.LANCHOR44
	.word	.LANCHOR5
	.word	.LANCHOR45
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
	beq	.L106
	ldr	r3, .L112
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L112+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L107
	str	r5, [r3]
.L106:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L107:
	ldr	r3, .L112+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L112+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L110:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L108
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L109
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L106
.L109:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L110
.L108:
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
	b	.L106
.L113:
	.align	2
.L112:
	.word	.LANCHOR40
	.word	.LANCHOR46
	.word	.LANCHOR47
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
	ldr	r2, .L116
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L116+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L114
	movs	r2, #207
	ldr	r1, .L116+8
	ldr	r0, .L116+12
	pop	{r3, lr}
	b	printf
.L114:
	pop	{r3, pc}
.L117:
	.align	2
.L116:
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
	ldr	r5, .L124
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L119
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L119
	mov	r2, #372
	ldr	r1, .L124+4
	ldr	r0, .L124+8
	bl	printf
.L119:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L120
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
.L122:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L120:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L123
	cmp	r1, r3
	beq	.L122
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L122
.L123:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L122
.L125:
	.align	2
.L124:
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
	cbz	r3, .L132
	ldr	r2, .L133
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L128:
	cbnz	r1, .L129
.L131:
	ldr	r4, .L133+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L129:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L131
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L128
.L132:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L134:
	.align	2
.L133:
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
	ldr	r3, .L142
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L141
	ldr	r2, .L142+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L138:
	cbz	r0, .L139
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L140
.L141:
	movw	r0, #65535
	pop	{r4, pc}
.L140:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L138
.L139:
	ldr	r0, .L142+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L143:
	.align	2
.L142:
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
	ldr	r3, .L155
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L146
	ldr	r3, .L155+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L146
	ldr	r3, .L155+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L146
	ldr	r7, .L155+12
	movs	r6, #6
	ldr	r3, .L155+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L146
	ldr	r3, .L155+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L153
	muls	r5, r2, r5
.L148:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L149
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L149
	movw	r2, #463
	ldr	r1, .L155+24
	ldr	r0, .L155+28
	bl	printf
.L149:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L150
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L146
.L150:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L155+32
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L154
	muls	r3, r0, r3
.L151:
	cmp	r5, r3
	bcs	.L146
	ldr	r5, .L155+36
	mov	r1, r4
	ldr	r0, .L155+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L152
	mov	r2, #474
	ldr	r1, .L155+24
	ldr	r0, .L155+28
	bl	printf
.L152:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L146:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L153:
	mov	r5, #-1
	b	.L148
.L154:
	mov	r3, #-1
	b	.L151
.L156:
	.align	2
.L155:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR42
	.word	.LANCHOR54
	.word	.LC1
	.word	-1431655765
	.word	.LANCHOR44
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
	ldr	r3, .L167
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L167+4
	ldr	r3, [r3]
.L158:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L160
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L161:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L163
	cmp	r4, r2
	bcc	.L159
	ldr	r1, .L167+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L164:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L166
	cmp	r4, r2
	bcc	.L159
	movw	r2, #789
	ldr	r1, .L167+12
	ldr	r0, .L167+16
	bl	printf
	b	.L159
.L160:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L158
.L159:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L163:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L162
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L162:
	adds	r1, r1, #1
	b	.L161
.L166:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L165
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L165:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L164
.L168:
	.align	2
.L167:
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
	ldr	r2, .L179
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L170
	cbnz	r0, .L170
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L170:
	movs	r3, #0
	ldr	r0, .L179+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L179+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L179+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L171:
	cmp	r1, r4
	bne	.L173
	cbz	r3, .L169
	str	r0, [r2]
.L169:
	pop	{r4, r5, r6, pc}
.L173:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L171
.L180:
	.align	2
.L179:
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
	cbz	r1, .L182
	b	ftl_set_blk_mode.part.6
.L182:
	ldr	r2, .L183
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L184:
	.align	2
.L183:
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
	ldr	r3, .L186
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L187:
	.align	2
.L186:
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
	ldr	r3, .L195
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L189:
	cmp	r2, r4
	bcc	.L191
	ldr	r3, .L195+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L192:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L194
	pop	{r4, r5, r6, pc}
.L191:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L189
.L194:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L192
.L196:
	.align	2
.L195:
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
	cbz	r3, .L197
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L197
	ldrb	r2, [r0, #6]	@ zero_extendqisi2
	movs	r5, #0
	adds	r2, r2, #8
	ldrh	r1, [r0, r2, lsl #1]
	ldr	r2, .L203
	ldrh	r4, [r2]
	mov	r2, r3
.L200:
	cmp	r1, r2
	beq	.L202
.L197:
	pop	{r4, r5, pc}
.L202:
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
	b	.L200
.L204:
	.align	2
.L203:
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
	bcc	.L206
	movw	r2, #2148
	ldr	r1, .L211+4
	ldr	r0, .L211+8
	bl	printf
.L206:
	ldr	r3, .L211+12
	add	r6, r4, #16
	ldr	r10, .L211+24
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L207:
	uxth	r3, r5
	ldrh	r1, [r4]
	cmp	r8, r3
	bhi	.L209
	ldr	r2, .L211+16
	movs	r0, #0
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L211+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	movw	r3, #10000
	cmp	r2, r3
	itt	hi
	movhi	r3, #1
	strbhi	r3, [r4, #9]
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L209:
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L208
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L208:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L207
.L212:
	.align	2
.L211:
	.word	.LANCHOR5
	.word	.LANCHOR60
	.word	.LC1
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR47
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
	.word	.LANCHOR46
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LANCHOR47
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
	.word	.LANCHOR46
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LANCHOR47
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
	movw	r2, #2781
	ldr	r1, .L255
	ldr	r0, .L255+4
	bl	printf
.L241:
	ldr	r6, .L255+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bne	.L242
	movw	r2, #2782
	ldr	r1, .L255
	ldr	r0, .L255+4
	bl	printf
.L242:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L243
	movw	r2, #2783
	ldr	r1, .L255
	ldr	r0, .L255+4
	bl	printf
.L243:
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	movs	r3, #0
	strb	r3, [r4, #10]
	movw	r5, #65535
	adds	r2, r2, #8
	ldrh	r0, [r4, r2, lsl #1]
	ldr	r2, .L255+12
	ldrh	r1, [r2]
	mov	r2, r3
.L244:
	cmp	r0, r5
	beq	.L246
	ldrh	r5, [r4, #2]
	ldrh	r6, [r6]
	cmp	r5, r6
	bcs	.L250
	ldrh	r2, [r4, #4]
	orr	r5, r5, r0, lsl #10
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r0, #65535
	subs	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r4, #4]	@ movhi
.L249:
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
	beq	.L249
	strb	r3, [r4, #6]
	ldrh	r3, [r4, #2]
	cmp	r3, r6
	bne	.L240
	cbz	r2, .L240
	movw	r2, #2806
	ldr	r1, .L255
	ldr	r0, .L255+4
	bl	printf
.L240:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, pc}
.L246:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
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
.L250:
	movw	r5, #65535
	b	.L240
.L256:
	.align	2
.L255:
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
	ldr	r1, .L262
	mov	fp, #1
	ldr	r2, .L262+4
	ldr	r5, [r1]
	ldr	r1, .L262+8
	str	r3, [r2]
	ldr	r2, .L262+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L262+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L262+20
	ldr	r10, [r1]
	ldr	r1, .L262+24
	ldrh	r7, [r1]
	ldr	r1, .L262+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L258:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #20
	add	lr, r1, r6
	bne	.L259
	ldr	r3, .L262+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L262+8
	ldr	r4, [r3]
	ldr	r3, .L262+20
	ldr	ip, [r3]
.L260:
	cmp	r2, r0
	bcc	.L261
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L259:
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
	b	.L258
.L261:
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
	b	.L260
.L263:
	.align	2
.L262:
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
	ldr	r3, .L271
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #20
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L271+4
	ldr	r5, [r3]
.L265:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L264
	mla	r8, fp, r3, r0
	movs	r2, #0
.L266:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L267
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L266
	str	lr, [r10, #8]
.L267:
	adds	r4, r4, #1
	b	.L265
.L264:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L272:
	.align	2
.L271:
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
	ldr	r3, .L280
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #20
	ldr	r4, [r3]
	ldr	r3, .L280+4
	ldr	r5, [r3]
.L274:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L278
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L278:
	mov	r10, #0
.L275:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L276
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L275
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L276:
	adds	r2, r2, #1
	b	.L274
.L281:
	.align	2
.L280:
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
	ldr	r3, .L287
	ldr	r2, .L287+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L283:
	cmp	r3, r2
	bne	.L285
	movs	r0, #0
	bx	lr
.L285:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L283
	movs	r0, #1
	bx	lr
.L288:
	.align	2
.L287:
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
	ldr	r4, .L293
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L293+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L290:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L292
	bne	.L291
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L291
.L292:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L290
.L291:
	ldr	r2, .L293+8
	movs	r0, #12
	ldr	r1, .L293+12
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
.L294:
	.align	2
.L293:
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
	ldr	r4, .L298
	ldrh	r5, [r4]
	cmp	r5, r0
	beq	.L296
	ldr	r3, .L298+4
	ldrh	r1, [r3]
	cmp	r0, r1
	beq	.L296
	movw	r2, #65535
	cmp	r5, r2
	bne	.L297
	strh	r0, [r4]	@ movhi
.L296:
	movs	r0, #0
	pop	{r4, r5, pc}
.L297:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3]	@ movhi
	b	.L296
.L299:
	.align	2
.L298:
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
	ldr	r2, .L304
	movs	r1, #0
	ldr	r5, .L304+4
	ldrh	r3, [r2]
.L301:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L303
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L304+4
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L302
.L303:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L301
.L302:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L305:
	.align	2
.L304:
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
	ldr	r3, .L312
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L307
	ldr	r2, .L312+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L307
	ldr	r4, .L312+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L312+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L307:
	movs	r0, #0
	pop	{r4, pc}
.L313:
	.align	2
.L312:
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
.L317:
	cmp	r4, r10
	bcc	.L323
	ldr	r0, .L326
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L323:
	cbnz	r5, .L318
	mov	r2, r6
	mov	r1, fp
	ldr	r0, .L326+4
	bl	printf
.L318:
	cmp	r8, #4
	bne	.L319
	ldr	r1, [r7, r4, lsl #2]
.L325:
	ldr	r0, .L326+8
.L324:
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L322
	movs	r5, #0
	ldr	r0, .L326
	bl	printf
.L322:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L317
.L319:
	cmp	r8, #2
	bne	.L321
	ldrh	r1, [r7, r4, lsl #1]
	b	.L325
.L321:
	ldrb	r1, [r7, r4]	@ zero_extendqisi2
	ldr	r0, .L326+12
	b	.L324
.L327:
	.align	2
.L326:
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
	ldr	r6, .L344
	add	r8, r0, #4
	movs	r7, #0
	ldr	fp, .L344+20
	ldrh	r10, [r6, #12]
	str	r2, [sp]
	lsl	r3, r10, #3
	str	r3, [sp, #4]
.L329:
	ldr	r3, [sp]
	cmp	r7, r3
	beq	.L343
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r8]
	bl	l2p_addr_tran.isra.0
	ldr	r5, [sp, #8]
	cbnz	r5, .L330
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bls	.L330
	ldr	r6, .L344+4
	ldr	r7, .L344+8
.L331:
	ldr	r3, [sp]
	adds	r4, r4, #20
	cmp	r5, r3
	bne	.L332
.L343:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L332:
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
	ldr	r0, .L344+12
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L344+16
	bl	rknand_print_hex
	b	.L331
.L330:
	ldr	r2, [fp, #4]
	uxtb	r0, r5
	ldr	r1, [sp, #12]
	blx	r2
	cbnz	r0, .L333
	str	r0, [r8, #-4]
.L334:
	ldrh	r2, [r6, #14]
	cmp	r2, #4
	bne	.L336
	ldr	r1, [sp, #12]
	ldr	r2, [fp, #4]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	add	r1, r1, r10
	blx	r2
	cbz	r0, .L336
	mov	r2, #-1
	str	r2, [r8, #-4]
.L336:
	adds	r7, r7, #1
	add	r8, r8, #20
	b	.L329
.L333:
	mov	r2, #-1
	str	r2, [r8, #-4]
	b	.L334
.L345:
	.align	2
.L344:
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
	bhi	.L346
	ldr	r4, .L355
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L346
	cbz	r1, .L348
	bl	P2V_block_in_plane
	ldr	r3, .L355+4
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L355+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L355+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L348:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L346:
	pop	{r4, r5, r6, pc}
.L356:
	.align	2
.L355:
	.word	.LANCHOR38
	.word	.LANCHOR79
	.word	.LANCHOR47
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
	ldr	r4, .L362
	ldrh	r2, [r4, #6]
	cbz	r2, .L361
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
	ldr	r3, .L362+4
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r2, .L362+8
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L358:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L359
	ldrh	r2, [r4, #6]
	mov	r1, r5
	ldr	r0, .L362+12
	bl	printf
.L360:
	b	.L360
.L361:
	movw	r5, #65535
	b	.L358
.L359:
	mov	r0, r5
	pop	{r3, r4, r5, pc}
.L363:
	.align	2
.L362:
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
.L365:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L368
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L365
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L366
	ldr	r3, .L372
	ldr	r0, .L372+4
	ldrh	r2, [r3, #6]
	bl	printf
.L367:
	b	.L367
.L366:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L368:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L370
	movw	r2, #578
	ldr	r1, .L372+8
	ldr	r0, .L372+12
	bl	printf
.L370:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L373:
	.align	2
.L372:
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
	ldr	r3, .L380
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L380+4
	movs	r6, #12
	str	r4, [r3]
	ldr	r3, .L380+8
	ldr	r5, .L380+12
	ldr	r10, .L380+292
	str	r4, [r3]
	ldr	r3, .L380+16
	ldrh	r0, [r5]
	ldr	r8, .L380+296
	str	r4, [r3]
	ldr	r3, .L380+20
	lsls	r0, r0, #1
	ldr	fp, .L380+300
	str	r4, [r3]
	ldr	r3, .L380+24
	str	r4, [r3]
	ldr	r3, .L380+28
	str	r4, [r3]
	ldr	r3, .L380+32
	str	r4, [r3]
	ldr	r3, .L380+36
	str	r4, [r3]
	ldr	r3, .L380+40
	str	r4, [r3]
	ldr	r3, .L380+44
	str	r4, [r3]
	ldr	r3, .L380+48
	str	r4, [r3]
	ldr	r3, .L380+52
	str	r4, [r3]
	ldr	r3, .L380+56
	str	r4, [r3]
	ldr	r3, .L380+60
	str	r4, [r3]
	ldr	r3, .L380+64
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L380+68
	str	r4, [r2]
	ldr	r2, .L380+72
	str	r4, [r2]
	ldr	r2, .L380+76
	str	r4, [r2]
	ldr	r2, .L380+80
	strh	r3, [r2]	@ movhi
	ldr	r2, .L380+84
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L380+88
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L380+92
	strh	r2, [r3]	@ movhi
	ldr	r3, .L380+96
	strh	r4, [r3]	@ movhi
	ldr	r3, .L380+100
	strh	r4, [r3]	@ movhi
	ldr	r3, .L380+104
	strh	r4, [r3]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L380+108
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #20
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L380+112
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L380+116
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+120
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L380+124
	ldr	r7, .L380+128
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+132
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+136
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L380+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+144
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+148
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L380+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+160
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L380+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+172
	str	r0, [r3]
	ldr	r3, .L380+176
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L380+180
	ldrh	r5, [r10]
	ldr	r10, .L380+304
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L380+184
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L380+188
	bl	ftl_malloc
	ldr	r3, .L380+192
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L380+308
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L380+196
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L380+200
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L380+204
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L380+208
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L380+212
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L380+216
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L380+220
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L380+224
	ldr	r8, .L380+312
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L380+228
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L380+232
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L380+236
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L380+316
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L380+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L380+244
	ldr	r4, .L380+248
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L380+252
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L380+256
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L380+260
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L380+264
	bl	ftl_malloc
	ldr	r3, .L380+268
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L380+272
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L380+276
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L380+280
	str	r0, [r3]
	ldr	r3, .L380+284
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
	ldr	r3, .L380+288
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	mov	r0, r1
	b	.L381
.L382:
	.align	2
.L380:
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
	.word	.LANCHOR47
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
.L381:
.L376:
	cmp	r2, r6
	bcc	.L377
	add	r3, r3, r2, lsl #2
	ldr	r2, .L383
	movs	r1, #0
	adds	r3, r3, #24
.L378:
	cmp	r3, r2
	bne	.L379
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L377:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L376
.L379:
	str	r1, [r3, #4]!
	b	.L378
.L384:
	.align	2
.L383:
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
	ldr	r3, .L391
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L391+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L391+12
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L388:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L385
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L387
	movs	r2, #74
	mov	r1, r8
	ldr	r0, .L391+8
	bl	printf
.L387:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L388
.L385:
	pop	{r4, r5, r6, r7, r8, pc}
.L392:
	.align	2
.L391:
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
	ldr	r0, .L394
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L395:
	.align	2
.L394:
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
	ldr	r3, .L397
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
.L398:
	.align	2
.L397:
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
.L400:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L404
	ldr	r3, .L419
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L405:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L409
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L404:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L401:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L403
	adds	r3, r3, #1
	b	.L400
.L403:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L402
	cbz	r1, .L402
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L402:
	adds	r2, r2, #1
	b	.L401
.L409:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L406
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L407
.L408:
	adds	r6, r6, #1
	b	.L405
.L406:
	cmp	r3, #0
	bne	.L408
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L408
.L410:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L408
.L407:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L410
	b	.L408
.L420:
	.align	2
.L419:
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
	ldr	r5, .L424
	ldr	r4, .L424+4
	ldr	r2, [r5]
	ldr	r7, .L424+8
	ldr	r6, .L424+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L424+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L424+16
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
.L422:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L423
	ldr	r3, .L424+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L424+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L424+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L424+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L424+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L424+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L423:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L422
.L425:
	.align	2
.L424:
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
	ldr	r3, .L427
	movs	r4, #0
	mov	r1, r4
	ldr	r5, .L427+4
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L427+8
	str	r4, [r3]
	ldr	r3, .L427+12
	str	r4, [r3]
	ldr	r3, .L427+16
	str	r2, [r3]
	ldr	r3, .L427+20
	strh	r4, [r3]	@ movhi
	ldr	r3, .L427+24
	ldrh	r2, [r3]
	ldr	r3, .L427+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L427+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L427+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L427+40
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L427+44
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L428:
	.align	2
.L427:
	.word	.LANCHOR131
	.word	.LANCHOR6
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR134
	.word	.LANCHOR35
	.word	.LANCHOR27
	.word	.LANCHOR36
	.word	.LANCHOR47
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
	ldr	r3, .L440
	movs	r1, #0
	movs	r4, #0
	ldr	r6, .L440+4
	mov	r8, r4
	ldrh	r3, [r3]
	mov	r5, r4
	ldr	r0, [r6]
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L440+8
	ldr	r2, .L440+12
	str	r4, [r3]
	ldr	r3, .L440+16
	strh	r4, [r2]	@ movhi
	str	r2, [sp, #4]
	str	r4, [r3]
	ldr	r3, .L440+20
	str	r4, [r3]
	ldr	r3, .L440+24
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L430:
	ldr	r3, .L440+28
	uxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bcs	.L437
	ldr	r3, .L440+32
	ldrh	r2, [r3]
	ldr	r3, .L440+36
	ldrh	r3, [r3]
	str	r3, [sp]
	movs	r3, #0
	mov	r6, r3
	b	.L438
.L432:
	str	r2, [sp, #12]
	mov	r1, r7
	ldr	r2, .L440+40
	str	r3, [sp, #8]
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	cbnz	r0, .L431
	ldr	r1, [sp]
	add	r6, r6, r1
	uxth	r6, r6
.L431:
	adds	r3, r3, #1
.L438:
	uxth	r1, r3
	cmp	r2, r1
	bhi	.L432
	uxth	r3, r4
	cbz	r6, .L433
	mov	r1, r6
	str	r3, [sp]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp]
	uxth	r6, r0
.L434:
	ldr	r1, [r10]
	movs	r2, #6
	mla	r2, r2, r3, r1
	strh	r6, [r2, #4]	@ movhi
	ldr	r2, .L440+44
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L435
	ldr	r2, .L440+48
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L435
	ldr	r2, .L440+52
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L435
	ldr	r2, .L440+56
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cbnz	r3, .L436
	add	r8, r8, #1
	mov	r0, r7
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L435:
	adds	r4, r4, #1
	b	.L430
.L433:
	ldr	r2, .L440+56
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r3, lsl #1]	@ movhi
	b	.L434
.L436:
	adds	r5, r5, #1
	mov	r0, r7
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L435
.L437:
	ldr	r2, [sp, #4]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r5, r3
	ble	.L439
	movw	r2, #2210
	ldr	r1, .L440+60
	ldr	r0, .L440+64
	bl	printf
.L439:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L441:
	.align	2
.L440:
	.word	.LANCHOR6
	.word	.LANCHOR40
	.word	.LANCHOR46
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR43
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
	ldr	r2, .L443
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L443+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L443+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L443+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L443+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L444:
	.align	2
.L443:
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
	ldr	r3, .L452
	mov	r1, r5
	mov	r0, r4
	ldr	r3, [r3]
	blx	r3
	uxth	r0, r0
	cmp	r0, #50
	bls	.L446
	mov	r2, #256
	movs	r1, #255
	mov	r0, r4
	bl	ftl_memset
	movs	r0, #0
.L446:
	ldr	r3, .L452+4
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L451
	add	r1, r4, r0, lsl #1
	mov	r3, r4
.L448:
	cmp	r3, r1
	bne	.L449
.L451:
	pop	{r3, r4, r5, pc}
.L449:
	ldrh	r2, [r3]
	lsrs	r2, r2, #1
	strh	r2, [r3], #2	@ movhi
	b	.L448
.L453:
	.align	2
.L452:
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
	ldr	r3, .L495
	mov	r4, r0
	mov	r10, #0
	ldrh	r2, [r3, #12]
	str	r3, [sp, #4]
	str	r2, [sp]
.L456:
	cmp	r10, fp
	bne	.L470
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L470:
	ldr	r3, [r4, #8]
	cbz	r3, .L457
	ldr	r3, [r4, #12]
	cbnz	r3, .L458
.L457:
	movs	r2, #90
	ldr	r1, .L495+4
	ldr	r0, .L495+8
	bl	printf
.L458:
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r4, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r0, [sp, #8]
	cmp	r0, #3
	bls	.L459
	mov	r3, #-1
	str	r3, [r4]
.L460:
	add	r10, r10, #1
	adds	r4, r4, #20
	b	.L456
.L459:
	ldr	r5, [r4, #8]
	uxtb	r0, r0
	ldr	r8, .L495+32
	ldr	r7, .L495+12
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
	bne	.L463
	ldr	r0, [sp]
	add	r2, r5, #2048
	ldr	r3, [r4, #12]
	ldr	r1, [sp, #12]
	ldr	r7, [r7, #12]
	adds	r3, r3, #8
	add	r1, r1, r0
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	blx	r7
	adds	r1, r0, #1
	beq	.L464
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #12]
	adds	r2, r2, #1
	bne	.L465
	ldr	r2, [r3, #8]
	adds	r2, r2, #1
	bne	.L465
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L465
.L464:
	mov	r3, #-1
	str	r3, [r4]
.L465:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L466
	cmp	r0, #256
	it	eq
	streq	r0, [r4]
.L466:
	ldr	r3, [r4]
	adds	r2, r3, #1
	beq	.L467
	cmp	r3, #256
	bne	.L463
.L467:
	ldr	r1, [r4, #4]
	ldr	r2, [sp, #12]
	ldr	r0, .L495+16
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L469
	movs	r3, #4
	ldr	r0, .L495+20
	mov	r2, r3
	bl	rknand_print_hex
.L469:
	ldr	r1, [r4, #12]
	cbz	r1, .L463
	movs	r3, #4
	ldr	r0, .L495+24
	mov	r2, r3
	bl	rknand_print_hex
.L463:
	ldr	r3, [r8]
	cmp	r5, r3
	bne	.L460
	ldr	r0, [r4, #8]
	cmp	r5, r0
	beq	.L460
	ldr	r3, .L495+28
	mov	r1, r5
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
	b	.L460
.L496:
	.align	2
.L495:
	.word	.LANCHOR0
	.word	.LANCHOR137
	.word	.LC1
	.word	.LANCHOR78
	.word	.LC11
	.word	.LC12
	.word	.LC13
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
	ldr	r3, .L507
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L507+4
	ldr	r3, [r3]
	ldr	r7, .L507+8
	ldr	r10, .L507+20
	str	r3, [r5, #8]
	ldr	r3, .L507+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L498:
	ldr	r3, .L507+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L503
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L503:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L507+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L499:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L501
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L500
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L500
	strh	r4, [r7]	@ movhi
.L501:
	adds	r6, r6, #1
	b	.L498
.L500:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L499
.L508:
	.align	2
.L507:
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
	ldreq	r3, .L521
	sub	sp, sp, #88
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L521+4
	mov	r6, r1
	add	r0, sp, #4
	movs	r1, #1
	ldrh	r5, [r3]
	ldr	r3, .L521+8
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
	bne	.L512
	mov	r8, #0
.L513:
	cmp	r8, r5
	ble	.L516
.L512:
	mov	r0, r5
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L516:
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
	bne	.L514
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	bne	.L514
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L514
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L513
.L514:
	adds	r4, r4, #1
	sxth	r8, r4
	b	.L513
.L522:
	.align	2
.L521:
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
	ldr	r5, .L604
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L604+4
	ldr	r2, [r5]
	ldr	r6, .L604+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L604+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L604+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L604+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L604+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L604+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #16
	movs	r1, #255
	ldr	r0, .L604+32
	bl	ftl_memset
	ldr	r3, .L604+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L524:
	ldr	r3, .L604+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L565
	ldr	r3, .L604+44
	movs	r5, #0
	ldr	r1, .L604+48
	mov	fp, r5
	movs	r7, #20
	ldrh	r8, [r3]
	ldr	r3, .L604+52
	ldr	r2, [r1]
	ldr	r1, .L604+56
	ldr	r6, [r3]
	ldr	r3, .L604+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L604+64
	b	.L566
.L526:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L525
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
.L525:
	adds	r5, r5, #1
.L566:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L526
	cmp	fp, #0
	bne	.L527
.L564:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L524
.L527:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L528:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L564
	ldr	r3, .L604+52
	mov	r8, #20
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L531
	mov	r10, #16
.L533:
	ldr	r3, .L604+52
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
	ldr	r3, .L604+52
	ldr	r3, [r3]
	bne	.L530
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L604+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	bne	.L531
.L532:
	movs	r1, #1
	b	.L603
.L530:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L531
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L533
	b	.L532
.L531:
	ldr	r3, .L604+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L534
	cmp	r2, r3
	bhi	.L535
.L534:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L604+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L535:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L537
	bhi	.L538
	movw	r3, #61574
	cmp	r2, r3
	beq	.L539
.L536:
	adds	r7, r7, #1
	b	.L528
.L538:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L540
	movw	r3, #65535
	cmp	r2, r3
	bne	.L536
	movs	r1, #0
.L603:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L536
.L540:
	ldr	r3, .L604+8
	ldrh	r2, [r3]
	ldr	r3, .L604
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L542
	movw	r2, #1225
	ldr	r1, .L604+72
	ldr	r0, .L604+76
	bl	printf
.L542:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L604+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L543:
	cmp	r3, r10
	bgt	.L549
	cmp	r3, #0
	bge	.L581
	b	.L536
.L549:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L544
	ldr	r2, [ip]
	cbnz	r2, .L545
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L604+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L545:
	ldr	r2, .L604+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L546:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L547
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L536
	ldr	r2, .L604+8
	ldrh	r0, [r2]
	ldr	r2, .L604
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L536
.L581:
	ldr	r2, .L604+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L604+20
.L601:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L536
.L547:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L546
.L544:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L543
.L605:
	.align	2
.L604:
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
.L539:
	ldr	r8, .L606+12
	ldr	r10, .L606+20
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L552
	movw	r2, #1266
	ldr	r1, .L606
	ldr	r0, .L606+4
	bl	printf
.L552:
	ldr	r2, .L606+8
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L553:
	cmp	r3, r10
	ble	.L558
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L554
	ldr	r2, [r0]
	cbnz	r2, .L555
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L606+12
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L555:
	ldr	r2, .L606+16
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L556:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L557
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L558:
	cmp	r3, #0
	blt	.L536
	ldr	r2, .L606+20
	ldr	ip, .L606+12
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L536
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L606+16
	b	.L601
.L557:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L556
.L554:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L553
.L537:
	ldr	r8, .L606+40
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L560
.L602:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L536
.L560:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L561
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L561:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L562
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L602
.L562:
	strh	r5, [r8, #4]	@ movhi
	b	.L536
.L565:
	ldr	r3, .L606+24
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L567
.L570:
	ldr	r3, .L606+16
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L568
.L569:
	ldr	r3, .L606+28
	ldrh	r2, [r3]
	ldr	r3, .L606+32
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L600
	movw	r2, #1391
	ldr	r1, .L606
	ldr	r0, .L606+4
	bl	printf
.L600:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L567:
	ldr	r1, .L606+28
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L570
	ldr	r5, .L606+32
	ldr	r0, [r5]
.L571:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L570
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L571
	ldr	r3, .L606+36
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L572:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L570
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L572
.L568:
	ldr	r3, .L606+12
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L569
	ldr	r5, .L606+20
	ldrh	r1, [r5]
.L577:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L569
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L577
	ldr	r2, .L606+8
	movs	r0, #0
	ldr	r2, [r2]
.L578:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L569
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L578
.L607:
	.align	2
.L606:
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
	ldr	r8, .L637+40
	ldr	r4, .L637
	ldr	r3, [r8]
	ldr	r7, .L637+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L637+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L609:
	ldrh	r3, [r7]
	subs	r3, r3, #15
	cmp	r3, r5
	bgt	.L612
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L610
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L610:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L611
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L611
	ldr	r3, .L637+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L612:
	ldr	r5, .L637+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L626
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L616
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L637
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L616
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L616
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L616
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L616:
	ldr	r10, .L637
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L618:
	cmp	r7, #0
	bge	.L621
	movs	r2, #251
	ldr	r1, .L637+16
	ldr	r0, .L637+20
	bl	printf
.L620:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L623
	ldr	r3, .L637+24
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L623
	ldr	r3, .L637+28
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L623
	cmp	r0, r3
	bcs	.L623
	bl	FtlSysBlkNumInit
.L623:
	ldr	r6, .L637+32
	movs	r5, #0
	ldr	r7, .L637+36
	ldr	r8, .L637+44
.L624:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L625
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L611:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L609
.L621:
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
	beq	.L619
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L620
.L619:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L618
.L625:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L624
.L626:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L638:
	.align	2
.L637:
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
	ldr	r3, .L680
	mov	r8, #0
	ldr	fp, .L680+52
	str	r2, [sp, #8]
	ldrh	r3, [r3, #12]
	str	r3, [sp]
	lsls	r3, r3, #3
	str	r3, [sp, #4]
.L640:
	cmp	r8, r10
	bne	.L653
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L672
	ldr	r6, .L680+4
	movs	r5, #0
.L655:
	cmp	r8, r5
	beq	.L672
	ldr	r7, .L680+8
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
	bne	.L656
	ldr	r1, [r4, #4]
	ldr	r0, .L680+12
	bl	printf
	str	r10, [r4]
.L656:
	ldr	r10, [sp, #28]
	cmp	r10, #256
	bne	.L657
	ldr	r1, [r4, #4]
	ldr	r0, .L680+16
	bl	printf
	str	r10, [r4]
.L657:
	ldr	r3, [r4, #12]
	cbz	r3, .L658
	ldr	r2, [r3]
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L658
	ldr	r1, [r4, #4]
	ldr	r0, .L680+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L658:
	ldr	r3, [r4, #8]
	cbz	r3, .L659
	ldr	r2, [r3]
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L659
	ldr	r1, [r4, #4]
	ldr	r0, .L680+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L659:
	adds	r5, r5, #1
	adds	r4, r4, #20
	b	.L655
.L653:
	ldr	r3, [r5, #8]
	cbz	r3, .L641
	ldr	r3, [r5, #12]
	cbnz	r3, .L642
.L641:
	movs	r2, #142
	ldr	r1, .L680+28
	ldr	r0, .L680+32
	bl	printf
.L642:
	add	r2, sp, #20
	add	r1, sp, #24
	ldr	r0, [r5, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r6, [sp, #20]
	cmp	r6, #3
	bls	.L643
.L679:
	mov	r3, #-1
	str	r3, [r5]
	b	.L644
.L643:
	cbnz	r6, .L645
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #4]
	cmp	r2, r3
	bls	.L645
	ldr	r5, .L680+28
	ldr	r7, .L680+36
	b	.L678
.L647:
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
	ldr	r0, .L680+40
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L680+44
	bl	rknand_print_hex
.L678:
	cmp	r6, r10
	add	r4, r4, #20
	bne	.L647
.L672:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L645:
	ldr	r1, [r5, #8]
	lsls	r3, r1, #26
	beq	.L661
	ldr	r3, .L680+4
	ldr	r6, [r3]
	cmp	r1, r6
	beq	.L648
	ldr	r3, .L680+48
	mov	r0, r6
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
.L648:
	ldr	r3, [r5, #12]
	mov	r2, r6
	ldr	r1, [sp, #24]
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	ldr	r7, [fp, #8]
	blx	r7
	cbnz	r0, .L649
	str	r0, [r5]
.L650:
	ldr	r3, .L680
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L644
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
	bne	.L679
.L644:
	add	r8, r8, #1
	adds	r5, r5, #20
	b	.L640
.L661:
	mov	r6, r1
	b	.L648
.L649:
	mov	r3, #-1
	str	r3, [r5]
	b	.L650
.L681:
	.align	2
.L680:
	.word	.LANCHOR0
	.word	.LANCHOR111
	.word	.LANCHOR113
	.word	.LC14
	.word	.LC15
	.word	.LC16
	.word	.LC17
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
	ldr	r3, .L725
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r7, .L725+4
	mov	r8, #0
	mov	r6, r1
	mov	r5, r8
	str	r0, [r3]
	mov	r4, r8
	ldr	r3, .L725+8
	mov	fp, #20
	ldr	r10, [r7]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L725+12
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L725+16
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L725+20
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L683:
	ldr	r3, [sp, #12]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L687
	cmp	r5, #0
	beq	.L682
	mov	r0, r10
	mov	r8, #0
	mov	r10, #20
	mov	r2, r5
	movs	r1, #0
	bl	FlashEraseBlocks
.L690:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L692
	cmp	r6, #0
	beq	.L708
	ldr	r3, .L725+24
	mov	r10, #1
	ldrh	r3, [r3]
	str	r3, [sp, #8]
.L693:
	movs	r7, #0
.L702:
	ldr	r3, .L725+8
	mov	r8, #0
	mov	r5, r8
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L725+4
	ldr	fp, [r3]
	ldr	r3, .L725+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L725+12
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L725+20
	ldrh	r3, [r3]
	str	r3, [sp, #28]
.L694:
	ldr	r3, [sp, #16]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L697
	cbz	r5, .L682
	mov	r0, fp
	ldr	fp, .L725+4
	movs	r3, #1
	mov	r2, r10
	mov	r1, r5
	mov	r8, #0
	bl	FlashProgPages
	movs	r3, #20
.L699:
	uxth	r2, r8
	cmp	r5, r2
	bhi	.L701
	adds	r7, r7, #1
	ldr	r2, [sp, #8]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L702
	ldr	r8, .L725+4
	movs	r7, #0
	mov	fp, #20
.L703:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L705
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L706
	cbz	r6, .L682
.L706:
	ldr	r3, .L725+4
	mov	r2, r5
	mov	r1, r10
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L682:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L687:
	mul	r2, fp, r8
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r10, r2]
	ldr	r3, .L725+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #8]
	cbz	r6, .L684
	bl	IsBlkInVendorPart
	cbnz	r0, .L685
.L684:
	ldr	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L686
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
.L685:
	add	r8, r8, #1
	b	.L683
.L686:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L685
.L692:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L691
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L691:
	add	r8, r8, #1
	b	.L690
.L708:
	movs	r3, #2
	mov	r10, r6
	str	r3, [sp, #8]
	b	.L693
.L697:
	movs	r3, #20
	ldr	r1, [sp, #4]
	mul	r2, r3, r8
	movs	r3, #0
	str	r3, [fp, r2]
	ldr	r3, .L725+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #12]
	cbz	r6, .L695
	bl	IsBlkInVendorPart
	cbnz	r0, .L696
.L695:
	ldr	r0, [sp, #12]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L696
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
.L696:
	add	r8, r8, #1
	b	.L694
.L701:
	mul	r2, r3, r8
	ldr	r1, [fp]
	adds	r0, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L700
	ldr	r0, [r0, #4]
	adds	r4, r4, #1
	str	r3, [sp, #12]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #12]
.L700:
	add	r8, r8, #1
	b	.L699
.L705:
	cbz	r6, .L704
	mul	r3, fp, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L704
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L704:
	adds	r7, r7, #1
	b	.L703
.L726:
	.align	2
.L725:
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
	bls	.L730
	ldr	r4, .L732
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
	cbnz	r3, .L731
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
.L729:
	movs	r2, #1
	movs	r1, #0
	add	r0, sp, #4
	str	r5, [sp, #8]
	bl	FlashEraseBlocks
.L727:
	mov	r0, r4
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, pc}
.L731:
	mov	r4, #-1
	b	.L729
.L730:
	movs	r4, #0
	b	.L727
.L733:
	.align	2
.L732:
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
	movs	r1, #0
	ldr	r7, .L748
	movs	r4, #0
	ldr	r5, .L748+4
	ldr	r3, [r7]
	ldr	fp, .L748+52
	ldr	r6, .L748+8
	str	r3, [r5, #12]
	ldr	r3, .L748+12
	ldr	r0, [fp]
	ldr	r8, .L748+56
	ldrh	r2, [r3]
	str	r0, [r5, #8]
	bl	ftl_memset
	str	r7, [sp, #12]
	ldr	r7, .L748+16
.L735:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L736
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L748+20
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
	ldr	r3, .L748+24
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
	ldr	r3, .L748+28
	ldr	r3, [r3]
	strh	r3, [r6, #14]	@ movhi
.L737:
	ldr	r3, [fp]
	ldrh	r2, [r4, #2]
	ldrh	r1, [r4]
	str	r3, [r5, #8]
	ldr	r3, [sp, #12]
	ldrh	r0, [r6, #10]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	movs	r3, #0
	str	r3, [r5]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L748+32
	bl	printf
	ldr	r3, .L748+36
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L738
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
	ldr	r2, .L748+40
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L738:
	movs	r3, #1
	ldr	r0, .L748+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r2, r3, #1
	bne	.L739
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L748+44
	bl	printf
	cmp	r7, #3
	bls	.L737
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L748+48
	bl	printf
.L741:
	b	.L741
.L736:
	ldrh	r2, [r8]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L735
.L739:
	add	r8, r8, #1
	cmp	r8, #1
	beq	.L737
	cmp	r3, #256
	beq	.L737
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L749:
	.align	2
.L748:
	.word	.LANCHOR114
	.word	.LANCHOR138
	.word	.LANCHOR37+24
	.word	.LANCHOR23
	.word	.LANCHOR10
	.word	.LANCHOR37
	.word	.LANCHOR2
	.word	.LANCHOR143
	.word	.LC18
	.word	.LANCHOR20
	.word	.LANCHOR79
	.word	.LC19
	.word	.LC20
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
.L751:
	ldr	r3, .L790
	ldr	r8, .L790+68
	ldrh	r3, [r3]
	ldr	r10, .L790+72
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L752
	mov	r2, #2656
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L752:
	ldr	r3, .L790+12
	cmp	r4, r3
	bne	.L778
	ldr	r3, .L790
	ldr	r2, .L790+16
	ldrh	r3, [r3]
	ldr	r2, [r2]
	lsrs	r1, r3, #1
	muls	r2, r3, r2
	adds	r1, r1, #1
	add	r1, r1, r2, lsr #2
	uxth	r1, r1
	cbz	r1, .L753
	subs	r1, r1, #1
	uxth	r1, r1
.L753:
	ldr	r0, .L790+20
	bl	List_pop_index_node
	ldr	r3, .L790
	mov	r5, r0
	uxth	r7, r0
	ldrh	r3, [r3]
	cbnz	r3, .L754
	movw	r2, #2665
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L754:
	ldr	r3, .L790
	ldr	r2, .L790
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r10]
	cmp	r3, r7
	bls	.L751
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L790+24
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L751
	strh	r7, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L756
	ldr	r3, .L790+24
	movw	r2, #65535
	mov	r0, r7
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L790
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L751
	movw	r2, #2679
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
	b	.L751
.L778:
	movs	r1, #0
	b	.L753
.L756:
	ldr	r3, .L790
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L758
	movw	r2, #2682
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L758:
	ldr	r3, .L790+28
	add	lr, r4, #16
	ldr	r2, .L790+32
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #20
	mov	r3, ip
	mla	r0, r2, r0, ip
.L759:
	cmp	r0, r3
	bne	.L761
	cbnz	r6, .L762
	movw	r2, #2693
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L762:
	ldr	r3, .L790+36
	ldrh	r3, [r3]
	cmp	r3, r7
	bne	.L763
	movw	r2, #2695
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L763:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L790+40
	ldr	fp, .L790+76
	ldr	r8, .L790+80
	ldr	r1, [r3]
	cmp	r2, #0
	bne	.L764
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L765
	ldr	r0, .L790+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L788:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r2, [fp]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [fp]
	bl	ftl_set_blk_mode
.L789:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldr	r3, [r3]
	ldrh	r1, [r3, r5, lsl #1]
	ldr	r3, .L790+48
	ldr	r2, [r3]
	cmp	r1, r2
	it	hi
	strhi	r1, [r3]
	ldr	r3, .L790+44
	ldrh	r1, [r10]
	ldrh	r2, [r3]
	ldr	r3, [r8]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L790+52
	ldr	ip, .L790+84
	str	r0, [r3]
	ldr	r3, .L790+56
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r2, #20
	ldr	r3, .L790+28
	ldr	r0, [r3]
	adds	r3, r0, #4
	mla	r2, r2, r6, r0
	adds	r2, r2, #24
.L769:
	adds	r3, r3, #20
	cmp	r2, r3
	bne	.L770
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r8, #0
	bl	FlashEraseBlocks
	mov	r10, r8
	movs	r3, #20
.L771:
	uxth	r2, r8
	cmp	r6, r2
	bhi	.L773
	cmp	r10, #0
	beq	.L774
	mov	r0, r7
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L774:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L775
	ldr	r3, .L790+24
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L751
.L761:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L760
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L760:
	adds	r3, r3, #20
	b	.L759
.L765:
	movs	r2, #2
	b	.L788
.L764:
	ldrh	r2, [r1, r5, lsl #1]
	mov	r0, r7
	str	r3, [sp, #4]
	adds	r2, r2, #1
	strh	r2, [r1, r5, lsl #1]	@ movhi
	ldr	r2, [r8]
	adds	r2, r2, #1
	str	r2, [r8]
	bl	ftl_set_blk_mode.part.6
	b	.L789
.L770:
	ldr	r1, [r3, #-20]
	and	r1, r1, ip
	str	r1, [r3, #-20]
	b	.L769
.L773:
	ldr	r1, .L790+28
	mul	r2, r3, r8
	ldr	r1, [r1]
	ldr	fp, [r1, r2]
	adds	r0, r1, r2
	cmp	fp, #-1
	bne	.L772
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
.L772:
	add	r8, r8, #1
	b	.L771
.L775:
	ldr	r3, .L790+60
	ldr	r1, .L790+64
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
	ldr	r2, .L790+24
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L776
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L777
.L776:
	movw	r2, #2748
	ldr	r1, .L790+4
	ldr	r0, .L790+8
	bl	printf
.L777:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L791:
	.align	2
.L790:
	.word	.LANCHOR48
	.word	.LANCHOR144
	.word	.LC1
	.word	.LANCHOR53
	.word	.LANCHOR95
	.word	.LANCHOR46
	.word	.LANCHOR42
	.word	.LANCHOR79
	.word	.LANCHOR3
	.word	.LANCHOR145
	.word	.LANCHOR47
	.word	.LANCHOR14
	.word	.LANCHOR92
	.word	.LANCHOR143
	.word	.LANCHOR118
	.word	.LANCHOR19
	.word	.LANCHOR82
	.word	.LANCHOR44
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
	ldr	r4, .L804
	ldrh	r3, [r4]
	cbz	r3, .L793
	ldr	r8, .L804+12
	movs	r7, #0
.L794:
	ldr	r3, .L804+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L800
	bl	FtlGcReFreshBadBlk
.L793:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L800:
	ldr	r2, .L804+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L795:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L799
	adds	r7, r7, #1
	b	.L794
.L799:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L796
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L797:
	cmp	r5, r2
	bcc	.L798
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L796:
	add	fp, fp, #1
	b	.L795
.L798:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L797
.L805:
	.align	2
.L804:
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
	ldr	r3, .L818
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L807
	ldr	r3, .L818+4
	ldrh	r2, [r3]
	cmp	r2, r0
	itt	eq
	movweq	r2, #65535
	strheq	r2, [r3]	@ movhi
	ldr	r3, .L818+8
	ldrh	r2, [r3]
	cmp	r2, r0
	itt	eq
	movweq	r2, #65535
	strheq	r2, [r3]	@ movhi
	ldr	r3, .L818+12
	ldrh	r2, [r3]
	cmp	r2, r0
	bne	.L810
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L811:
	ldr	r5, .L818+16
	mov	r1, r4
	ldr	r0, .L818+20
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L813
	movw	r2, #2824
	ldr	r1, .L818+24
	ldr	r0, .L818+28
	bl	printf
.L813:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L818+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L818+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L817
	movw	r2, #2827
	ldr	r1, .L818+24
	ldr	r0, .L818+28
	bl	printf
.L817:
	movs	r0, #1
	pop	{r3, r4, r5, pc}
.L810:
	ldr	r3, .L818+40
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L816
	ldr	r3, .L818+44
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L816
	ldr	r3, .L818+48
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L811
.L816:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L807:
	bl	List_update_data_list
	b	.L816
.L819:
	.align	2
.L818:
	.word	.LANCHOR42
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR145
	.word	.LANCHOR44
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
	beq	.L821
	ldr	r5, .L829
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L822
	mov	r1, r0
	ldr	r0, .L829+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L823
.L827:
	movs	r5, #0
.L820:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L823:
	movw	r2, #2842
.L828:
	ldr	r1, .L829+8
	ldr	r0, .L829+12
	bl	printf
	b	.L820
.L822:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L821:
	ldr	r6, .L829+16
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L825
	strh	r4, [r6]	@ movhi
	b	.L827
.L825:
	cmp	r4, r0
	beq	.L827
	bl	update_vpc_list
	ldr	r3, .L829+20
	adds	r5, r0, #0
	ldr	r2, .L829+24
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L829+28
	muls	r3, r2, r3
	ldr	r2, .L829
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L820
	cmp	r4, r1
	beq	.L820
	movw	r2, #2858
	b	.L828
.L830:
	.align	2
.L829:
	.word	.LANCHOR42
	.word	.LC21
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
	ldr	r2, .L844
	movs	r6, #0
	mov	r4, r0
	str	r3, [sp, #20]
	ldr	r3, .L844+4
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r8, .L844+16
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
.L837:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L833
.L834:
	ldr	r3, .L844+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L844+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L833:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L834
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
	bne	.L837
	b	.L834
.L845:
	.align	2
.L844:
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
	ldr	r7, .L865
	bl	FtlBbtMemInit
	sub	r8, r7, #18
	bl	FtlLoadFactoryBbt
.L847:
	ldr	r3, .L865+4
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L853
	ldr	r5, .L865+8
	movs	r4, #0
.L854:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L855
	ldr	r4, .L865+12
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L856:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L860
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L857
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L858
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L857:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L856
.L853:
	ldr	r3, .L865+16
	ldr	r5, .L865+20
	ldrh	r2, [r8, #2]!
	ldr	r4, .L865+24
	ldr	r0, [r3]
	movw	r3, #65535
	ldr	r10, [r5]
	cmp	r2, r3
	mov	fp, r4
	ldr	r3, .L865+28
	str	r0, [r4, #8]
	str	r10, [r4, #12]
	beq	.L848
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
.L849:
	uxth	r0, r5
	adds	r6, r6, #1
	adds	r7, r7, #4
	bl	FtlBbmMapBadBlock
	b	.L847
.L848:
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
.L850:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r6, r4
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L851
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r4, [r8]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L865+16
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
	ldr	r3, .L865+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	ldr	r0, .L865+24
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L865+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	bne	.L849
	uxth	r0, r5
	bl	FtlBbmMapBadBlock
	b	.L850
.L851:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L850
.L855:
	bl	FtlBbmMapBadBlock
	b	.L854
.L858:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L859
	strh	r5, [r4]	@ movhi
	b	.L857
.L859:
	strh	r5, [r4, #4]	@ movhi
.L860:
	ldr	r3, .L865+36
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
.L866:
	.align	2
.L865:
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
	ldr	r3, .L871
	add	r1, r1, r0
	push	{r4, lr}
.L869:
	cmp	r0, r1
	bne	.L870
	mov	r0, r3
	pop	{r4, pc}
.L870:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L869
.L872:
	.align	2
.L871:
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
	bne	.L874
	ldrh	r3, [r0, #8]
	cbz	r3, .L875
	movw	r2, #641
	ldr	r1, .L883
	ldr	r0, .L883+4
	bl	printf
.L875:
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
.L876:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L874:
	ldrh	r7, [r5, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r6, .L883+8
	ldr	r10, .L883+24
	ldr	r8, [r0, #24]
	orr	r3, r3, r7, lsl #10
	ldr	r0, [r10]
	str	r3, [r6, #4]
	ldr	r3, .L883+12
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
	ldr	r3, .L883+16
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	movs	r3, #0
	ldr	r1, [r10]
	mov	r2, r3
.L877:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L879
	ldr	r3, .L883+20
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r2, #1
	str	r0, [r5, #12]
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L883+8
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L876
.L879:
	ldr	r0, [r8, r3, lsl #2]
	cmp	r7, r0, lsr #10
	bne	.L878
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	lr, r1, r2, lsl #3
	ldr	r0, [r8, r3, lsl #2]
	str	r0, [lr, #4]
.L878:
	adds	r3, r3, #1
	b	.L877
.L884:
	.align	2
.L883:
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
	ldr	r8, .L909+32
	mov	r7, r1
	movs	r6, #0
	str	r2, [sp]
	mov	fp, r8
.L886:
	ldr	r2, .L909
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L887
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L888
.L887:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L888:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L889
	mov	r2, #700
	ldr	r1, .L909+4
	ldr	r0, .L909+8
	bl	printf
.L889:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L890
	movw	r2, #701
	ldr	r1, .L909+4
	ldr	r0, .L909+8
	bl	printf
.L890:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L909+12
	ldrh	r3, [r3, r2, lsl #1]
	ldrh	r2, [r4, #2]
	str	r3, [sp, #4]
	orr	r2, r2, r3, lsl #10
	ldr	r3, [sp]
	str	r2, [r5, #4]
	ldr	r2, .L909+16
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
	ldr	r3, .L909+20
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
	bne	.L891
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L909+24
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L893
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L909+28
	bl	printf
.L894:
	b	.L894
.L893:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L886
.L908:
	b	.L908
.L891:
	cmp	r2, #1
	beq	.L897
	cmp	r1, #256
	beq	.L897
	ldr	r0, [r4, #36]
	cbz	r0, .L898
.L897:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L886
.L898:
	ldr	r2, [r5, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r7, lsl #2]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L910:
	.align	2
.L909:
	.word	.LANCHOR88
	.word	.LANCHOR149
	.word	.LC1
	.word	.LANCHOR138
	.word	.LANCHOR114
	.word	.LANCHOR23
	.word	.LC22
	.word	.LC23
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
	ldr	r3, .L918
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r10, r1
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, r0
	bcs	.L912
	movw	r2, #485
	ldr	r1, .L918+4
	ldr	r0, .L918+8
	bl	printf
.L912:
	ldr	fp, .L918+48
	movs	r4, #12
	ldr	r7, .L918+12
	ldr	r3, [fp]
	ldr	r8, [r3, r5, lsl #2]
	cmp	r8, #0
	bne	.L913
	mul	r4, r4, r10
	ldr	r2, [r7]
	movs	r1, #255
	adds	r0, r2, r4
	ldr	r2, .L918+16
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r7]
	adds	r1, r2, r4
	strh	r5, [r2, r4]	@ movhi
	str	r8, [r1, #4]
.L914:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L913:
	mul	r4, r4, r10
	ldr	r2, [r7]
	ldr	r6, .L918+20
	add	r2, r2, r4
	mov	r0, r6
	ldr	r2, [r2, #8]
	str	r8, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L918+24
	ldr	r2, [r2]
	str	r2, [r6, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r10, [r6, #12]
	ldrh	r2, [r10, #8]
	cmp	r2, r5
	beq	.L915
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L918+28
	bl	printf
	movs	r3, #4
	ldr	r1, [r6, #12]
	mov	r2, r3
	ldr	r0, .L918+32
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L918+36
	ldrh	r3, [r3]
	bl	rknand_print_hex
.L916:
	ldrh	r3, [r10, #8]
	cmp	r3, r5
	beq	.L917
	mov	r2, #508
	ldr	r1, .L918+4
	ldr	r0, .L918+8
	bl	printf
.L917:
	ldr	r3, [r7]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r5, [r3, r4]	@ movhi
	b	.L914
.L915:
	ldr	r2, [r6]
	cmp	r2, #256
	bne	.L916
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L918+40
	bl	printf
	ldr	r3, [r7]
	mov	r1, r5
	ldr	r0, .L918+44
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L916
.L919:
	.align	2
.L918:
	.word	.LANCHOR32
	.word	.LANCHOR150
	.word	.LC1
	.word	.LANCHOR55
	.word	.LANCHOR23
	.word	.LANCHOR138
	.word	.LANCHOR114
	.word	.LC24
	.word	.LC13
	.word	.LC25
	.word	.LC26
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
	blt	.L921
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L921
	ldr	r3, [r4, #32]
	cbnz	r3, .L921
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L936
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L922
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L922:
	ldr	r5, .L936+4
	movs	r6, #0
.L923:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L930
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L921:
	ldr	r3, .L936
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L931
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L931:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L930:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L924
	ldr	r3, .L936+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L936+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L936+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L925
	movw	r2, #611
	ldr	r1, .L936+16
	ldr	r0, .L936+20
	bl	printf
.L925:
	ldr	r2, [r5]
	adds	r2, r2, #1
	bne	.L926
.L928:
	ldr	r2, [sp, #4]
	movs	r3, #0
	str	r3, [r2]
.L927:
	b	.L927
.L926:
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	bne	.L928
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	bne	.L928
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L924:
	adds	r6, r6, #1
	b	.L923
.L937:
	.align	2
.L936:
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
	ldr	r5, .L939
	muls	r4, r0, r4
	ldr	r0, .L939+4
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
.L940:
	.align	2
.L939:
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
	ldr	r5, .L945
	ldr	r6, .L945+4
.L942:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L944
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L944:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L943
	bl	flush_l2p_region
.L943:
	adds	r4, r4, #1
	b	.L942
.L946:
	.align	2
.L945:
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
	ldr	r4, .L960
	mov	r10, r0
	mov	r5, r1
	ldr	r3, .L960+4
	ldr	r2, [r4]
	ldrh	fp, [r3]
	cmp	r0, r2
	bcc	.L948
	movw	r2, #813
	ldr	r1, .L960+8
	ldr	r0, .L960+12
	bl	printf
.L948:
	ldr	r3, [r4]
	cmp	r10, r3
	bcs	.L949
	ldr	r3, .L960+16
	add	fp, fp, #7
	lsr	r6, r10, fp
	movs	r2, #0
	ldrh	r1, [r3]
	uxth	r6, r6
	ldr	r3, .L960+20
	ldr	r0, [r3]
	mov	r8, r3
	movs	r3, #12
.L950:
	uxth	r4, r2
	cmp	r4, r1
	bcc	.L955
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
	beq	.L956
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L956
	bl	flush_l2p_region
.L956:
	mov	r1, r4
	mov	r0, r6
	bl	load_l2p_region
	b	.L952
.L949:
	mov	r0, #-1
	cbnz	r7, .L947
	str	r0, [r5]
.L947:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L955:
	adds	r2, r2, #1
	mla	ip, r3, r2, r0
	ldrh	ip, [ip, #-12]
	cmp	ip, r6
	bne	.L950
.L952:
	movs	r0, #1
	ldr	r2, [r8]
	lsl	r0, r0, fp
	movs	r3, #12
	subs	r0, r0, #1
	and	r0, r0, r10
	uxth	r0, r0
	mla	r3, r3, r4, r2
	cbnz	r7, .L953
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r0, lsl #2]
	str	r3, [r5]
.L954:
	ldr	r2, [r8]
	movs	r3, #12
	mla	r4, r3, r4, r2
	ldr	r3, [r4, #4]
	adds	r2, r3, #1
	beq	.L958
	adds	r3, r3, #1
	str	r3, [r4, #4]
.L958:
	movs	r0, #0
	b	.L947
.L953:
	ldr	r1, [r5]
	ldr	r2, [r3, #8]
	str	r1, [r2, r0, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L960+24
	strh	r6, [r3]	@ movhi
	b	.L954
.L961:
	.align	2
.L960:
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
	ldr	r5, .L972
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cbnz	r3, .L963
	ldr	r2, .L972+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L964
	ldr	r2, .L972+8
	movw	lr, #65535
	ldr	ip, .L972+24
	ldr	r0, .L972+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L965:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L964
	cmp	r4, r7
	bne	.L966
	mov	r1, r4
	ldr	r0, .L972+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L967
	movw	r2, #1733
	ldr	r1, .L972+16
	ldr	r0, .L972+20
	bl	printf
.L967:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L963:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L964
.L966:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L965
.L964:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L973:
	.align	2
.L972:
	.word	.LANCHOR42
	.word	.LANCHOR46
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
	beq	.L1106
	ldrh	r3, [r0, #2]
	str	r3, [sp, #4]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #20]
	ldr	r3, .L1115
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L977
	strh	r3, [r0, #4]	@ movhi
.L1113:
	strb	r3, [r8, #6]
.L1106:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L977:
	ldrh	r0, [r0, #16]
.L978:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L979
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L980
	ldr	r3, .L1115+4
	movs	r2, #0
	mov	r5, r2
	movw	fp, #65535
	mov	r10, #20
	ldrh	ip, [r3]
	ldr	r3, .L1115+8
	ldr	r0, [r3]
	ldr	r3, .L1115+12
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1115+16
	ldrh	r7, [r3]
	ldr	r3, .L1115+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1115+24
	ldrh	lr, [r3]
	add	r3, r8, #16
	str	r3, [sp, #16]
	str	r3, [sp]
.L981:
	uxth	r3, r2
	cmp	ip, r3
	bhi	.L985
	movs	r2, #0
	mov	r1, r5
	bl	FlashReadPages
	ldr	r2, .L1115+28
	uxth	r1, r4
	movw	fp, #65535
	str	r1, [sp, #12]
	ldr	r3, [r2]
	subs	r3, r3, #1
	str	r3, [sp]
	ldr	r3, .L1115+8
	ldr	r10, [r3]
	movs	r3, #0
	mov	r7, r10
.L986:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L991
	bne	.L989
	adds	r3, r4, #1
	uxth	r3, r3
	str	r3, [sp, #8]
.L1107:
	ldr	r0, [r10, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldr	r3, .L1115
	mov	r10, r0
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L993
	ldrh	r3, [sp, #8]
	strh	r3, [r8, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r8, #6]
	strh	r3, [r8, #4]	@ movhi
.L993:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	cmp	r3, r2
	bne	.L994
	ldr	r3, [sp, #20]
	cmp	r10, r3
	bne	.L994
	ldr	r1, [sp, #8]
	mov	r2, r10
.L1114:
	mov	r0, r8
	bl	ftl_sb_update_avl_pages
	b	.L1106
.L979:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r8, r1, lsl #1]
	b	.L978
.L980:
	ldr	r3, [sp, #4]
	cbz	r3, .L982
	mov	r2, #1800
	ldr	r1, .L1115+32
	ldr	r0, .L1115+36
	bl	printf
.L982:
	ldr	r3, [sp, #20]
	cbz	r3, .L983
	cmp	r5, r3
	beq	.L983
	movw	r2, #1801
	ldr	r1, .L1115+32
	ldr	r0, .L1115+36
	bl	printf
.L983:
	movs	r3, #0
	strh	r3, [r8, #2]	@ movhi
	b	.L1113
.L985:
	ldr	r1, [sp]
	ldrh	r3, [r1], #2
	cmp	r3, fp
	str	r1, [sp]
	beq	.L984
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
.L984:
	adds	r2, r2, #1
	b	.L981
.L991:
	ldr	r1, [r7]
	cbnz	r1, .L987
	ldr	r1, [r7, #12]
	ldr	r6, [r1, #4]
	str	r1, [sp, #8]
	adds	r1, r6, #1
	beq	.L988
	ldr	r1, [r2]
	mov	r0, r6
	bl	ftl_cmp_data_ver
	cbz	r0, .L988
	adds	r6, r6, #1
	str	r6, [r2]
.L988:
	ldr	r1, [sp, #8]
	ldr	r1, [r1]
	adds	r1, r1, #1
	bne	.L990
.L989:
	uxth	r2, r4
	uxth	r3, r3
	str	r2, [sp, #8]
	movs	r2, #20
	mla	r10, r2, r3, r10
	b	.L1107
.L987:
	ldr	fp, [sp, #12]
.L990:
	adds	r3, r3, #1
	adds	r7, r7, #20
	b	.L986
.L994:
	movw	r3, #65535
	cmp	fp, r3
	bne	.L995
	ldrb	r3, [r8, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L996
.L995:
	ldr	r3, .L1115+40
	uxth	r6, r4
	uxth	r4, r4
	ldr	r7, .L1115+8
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
.L999:
	cmp	r4, r6
	bhi	.L1009
	ldr	r3, .L1115+4
	movw	lr, #65535
	ldr	r0, [r7]
	mov	ip, #20
	ldrh	fp, [r3]
	ldr	r3, [sp, #16]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r5, r3
	b	.L1010
.L1001:
	ldr	r1, [sp, #12]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #12]
	beq	.L1000
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L1000:
	adds	r3, r3, #1
.L1010:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L1001
	mov	r1, r5
	movs	r2, #0
	bl	FlashReadPages
	ldr	r3, .L1115+40
	movs	r1, #20
	movs	r0, #0
	movw	ip, #65535
	ldr	r2, [r3]
	ldr	r3, [r7]
	mla	r5, r1, r5, r3
.L1002:
	cmp	r5, r3
	bne	.L1007
	cbz	r0, .L1008
	ldr	r3, .L1115+40
	str	r2, [r3]
.L1008:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L999
.L1116:
	.align	2
.L1115:
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
.L1007:
	ldr	r1, [r3]
	cmp	r1, #0
	beq	.L1003
	cbz	r0, .L996
.L1108:
	ldr	r3, .L1117
	str	r2, [r3]
.L996:
	ldr	fp, [sp, #4]
	movs	r2, #1
	ldr	r6, .L1117+4
	ldr	r3, .L1117+8
	strh	r2, [r3]	@ movhi
.L1011:
	ldr	r3, .L1117+12
	movw	lr, #65535
	ldr	r0, [r6]
	movs	r7, #20
	ldr	r1, [sp, #16]
	ldrh	r4, [r3]
	movs	r3, #0
	str	r3, [sp, #12]
.L1012:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L1014
	movs	r2, #0
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1112:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1043
	ldr	r3, .L1117+16
	add	fp, fp, #1
	uxth	fp, fp
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L1011
	ldr	r2, .L1117+12
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r8, #2]	@ movhi
	strh	r3, [r8, #4]	@ movhi
	ldrh	r2, [r2]
.L1044:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L1106
	ldr	r1, [sp, #16]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #16]
	add	r1, r3, #1
	bne	.L1113
	mov	r3, r1
	b	.L1044
.L1003:
	ldr	r1, [r3, #12]
	ldrh	lr, [r1]
	cmp	lr, ip
	beq	.L1006
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	itt	ne
	movne	r2, r1
	movne	r0, #1
.L1006:
	adds	r3, r3, #20
	b	.L1002
.L1009:
	mov	r2, #-1
	b	.L1108
.L1014:
	ldrh	r2, [r1], #2
	cmp	r2, lr
	beq	.L1013
	ldr	r5, [sp, #12]
	orr	r2, fp, r2, lsl #10
	mla	ip, r7, r5, r0
	str	r2, [ip, #4]
	mov	r2, r5
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1013:
	adds	r3, r3, #1
	b	.L1012
.L1043:
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
	bcc	.L1016
	ldr	r3, [sp, #28]
	bne	.L1017
	ldr	r2, [sp, #20]
	cmp	r2, r0
	bhi	.L1016
.L1017:
	ldr	r2, [sp, #8]
	cmp	fp, r2
	bne	.L1018
	cmp	r10, r0
	beq	.L1019
.L1018:
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1020
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1021
	ldrh	r0, [r8]
.L1109:
	bl	decrement_vpc_count
	b	.L1016
.L1021:
	ldr	r2, [r3, #4]
	str	r2, [sp]
	adds	r2, r2, #1
	beq	.L1022
	ldr	r2, .L1117+20
	ldr	r0, [sp]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1022
	ldr	r1, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
.L1022:
	ldr	r4, [r3, #8]
	add	r1, sp, #40
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #36]
	bl	log2phys
	ldr	r3, .L1117
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L1023
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1023
	ldr	r3, [sp, #36]
	adds	r7, r3, #1
	beq	.L1024
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
	bne	.L1025
.L1026:
	mov	r3, #-1
	str	r3, [sp, #36]
.L1033:
	ldr	r7, [sp, #36]
	adds	r0, r7, #1
	beq	.L1016
.L1047:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1117+24
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1039
	movw	r2, #2057
	ldr	r1, .L1117+28
	ldr	r0, .L1117+32
	bl	printf
.L1039:
	ldr	r3, .L1117+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L1040
	mov	r0, r4
	b	.L1109
.L1024:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bne	.L1016
	movs	r2, #1
	add	r1, sp, #36
	mov	r0, r4
	bl	log2phys
.L1016:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1112
.L1025:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L1026
	ldr	r0, .L1117
	ldr	r1, [r7, #4]
	ldr	r0, [r0]
	str	r1, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1026
	ldr	r1, [sp, #40]
	ldr	r0, [sp, #44]
	cmp	r1, r0
	bne	.L1028
.L1031:
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L1026
.L1028:
	ldr	r0, [sp, #36]
	cmp	r1, r0
	beq	.L1026
	adds	r0, r1, #1
	beq	.L1029
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L1030:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1031
	ldr	r3, [r7, #4]
	ldr	r2, .L1117
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1031
	mov	r1, r3
	ldr	r0, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1026
	b	.L1031
.L1029:
	str	r1, [r2, r5]
	b	.L1030
.L1023:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	beq	.L1033
	ldr	r1, [sp, #36]
	adds	r7, r1, #1
	beq	.L1035
	ldr	r3, .L1117+40
	ldr	r3, [r3]
	cmp	r3, r1, lsr #10
	bhi	.L1035
	ldr	r0, .L1117+44
.L1111:
	bl	printf
	b	.L1016
.L1118:
	.align	2
.L1117:
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
	.word	.LANCHOR8
	.word	.LC27
.L1035:
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #40]
	adds	r5, r7, #1
	beq	.L1033
	ldr	r3, [sp, #36]
	cmp	r7, r3
	beq	.L1047
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1119
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1038
	ldr	r3, .L1119+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1038
	ldr	r3, .L1119+8
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1033
.L1038:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L1033
	ldr	r1, [r5, #4]
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L1033
	movs	r2, #1
	add	r1, sp, #40
	mov	r0, r4
	bl	log2phys
	b	.L1033
.L1040:
	mov	r1, r4
	ldr	r0, .L1119+12
	b	.L1111
.L1020:
	ldr	r3, .L1119+16
	ldr	r3, [r3]
	cmp	r3, #31
	bhi	.L1041
	ldr	r2, .L1119+20
	str	r4, [r2, r3, lsl #2]
	adds	r3, r3, #1
	ldr	r2, .L1119+16
	str	r3, [r2]
.L1041:
	ldrh	r0, [r8]
	bl	decrement_vpc_count
	ldr	r3, .L1119+24
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L1042
	ldr	r2, [sp]
.L1110:
	str	r2, [r3]
	b	.L1016
.L1042:
	ldr	r1, [sp]
	cmp	r1, r2
	bcs	.L1016
	mov	r2, r1
	b	.L1110
.L1019:
	strb	r10, [r8, #6]
	mov	r2, r10
	strh	fp, [r8, #2]	@ movhi
	mov	r1, fp
	b	.L1114
.L1120:
	.align	2
.L1119:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LC28
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
	ldr	r6, .L1145
	ldr	r5, .L1145+4
	ldr	r1, .L1145+8
	ldr	r0, .L1145+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L1145+4
	bl	ftl_memset
.L1122:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L1124
	ldr	r10, .L1145+48
	movs	r4, #0
	ldr	r7, .L1145+16
	mov	r6, r4
.L1125:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L1127
	ldr	r3, .L1145+20
	ldr	r4, [r3]
	cbz	r4, .L1128
	ldr	r3, .L1145+24
	mov	r8, #0
	ldr	r5, .L1145+28
	ldr	r10, .L1145+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L1145+4
	subs	r4, r4, r3
	ldr	r3, .L1145+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L1129:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L1128
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1130
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L1145+36
	bl	printf
.L1130:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L1129
.L1128:
	cbz	r6, .L1121
	movw	r2, #2383
	ldr	r1, .L1145+8
	ldr	r0, .L1145+40
	bl	printf
.L1121:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1124:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1123
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L1123:
	adds	r4, r4, #1
	b	.L1122
.L1127:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L1145+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L1126
	mov	r1, r5
	ldr	r0, .L1145+44
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L1126
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L1126:
	adds	r4, r4, #1
	b	.L1125
.L1146:
	.align	2
.L1145:
	.word	.LANCHOR152
	.word	check_vpc_table
	.word	.LANCHOR159
	.word	.LC29
	.word	.LANCHOR42
	.word	.LANCHOR46
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LC31
	.word	.LC1
	.word	.LC30
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
	ldr	r7, .L1161
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L1161+24
	ldr	r0, .L1161+4
	bl	printf
.L1148:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L1154
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1154:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L1149
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L1149:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L1151
	ldr	r4, .L1161+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L1161+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L1161+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L1152
	adds	r3, r3, #1
	beq	.L1152
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L1151
.L1152:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L1161+20
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
.L1151:
	adds	r5, r5, #1
	b	.L1148
.L1162:
	.align	2
.L1161:
	.word	.LANCHOR152
	.word	.LC32
	.word	.LANCHOR138
	.word	.LANCHOR106
	.word	.LANCHOR114
	.word	.LC34
	.word	.LC33
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
	ldr	r3, .L1195
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	mov	r4, r0
	ldrh	r5, [r3]
	str	r3, [sp, #20]
	cmp	r5, r2
	beq	.L1185
	cbnz	r5, .L1164
.L1165:
	bl	FtlGcPageVarInit
	b	.L1166
.L1185:
	movs	r5, #0
.L1164:
	ldr	r3, .L1195+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L1165
.L1166:
	ldr	fp, .L1195+56
.L1182:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1167
.L1184:
	ldr	r3, .L1195+8
	movs	r2, #0
	ldr	r0, [fp]
	mov	r10, r2
	movw	lr, #65535
	mov	r8, #20
	ldrh	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1195+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1195+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1195+20
	ldr	r7, [r3]
	ldr	r3, .L1195+24
	ldrh	ip, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L1168:
	ldr	r1, [sp, #8]
	uxth	r3, r2
	cmp	r1, r3
	bhi	.L1170
	mov	r8, #0
	movs	r2, #0
	mov	r1, r10
	bl	FlashReadPages
.L1171:
	uxth	r3, r8
	cmp	r10, r3
	bhi	.L1183
	ldr	r3, .L1195+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L1184
.L1167:
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
.L1170:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, lr
	str	r1, [sp, #4]
	beq	.L1169
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
.L1169:
	adds	r2, r2, #1
	b	.L1168
.L1183:
	movs	r3, #20
	ldr	r2, [fp]
	mul	r3, r3, r8
	adds	r1, r2, r3
	ldr	r6, [r2, r3]
	ldr	r0, [r1, #4]
	ldr	r7, [r1, #12]
	str	r0, [sp, #4]
	cmp	r6, #0
	bne	.L1172
	ldrh	r1, [r7]
	movw	r2, #65535
	cmp	r1, r2
	beq	.L1193
	ldr	r2, .L1195+28
	ldr	r0, [r7, #8]
	ldr	r2, [r2]
	cmp	r0, r2
	bls	.L1174
.L1193:
	ldr	r3, .L1195+32
	movs	r1, #0
	ldrh	r2, [r4]
	movs	r5, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	ldr	r2, .L1195+36
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	strh	r3, [r2]	@ movhi
	bl	FtlGcPageVarInit
	b	.L1182
.L1174:
	mov	r2, r6
	add	r1, sp, #24
	str	r3, [sp, #8]
	bl	log2phys
	ldr	r2, [r7, #12]
	ldr	r1, [sp, #24]
	ldr	r3, [sp, #8]
	cmp	r2, r1
	beq	.L1176
.L1178:
	ldr	r2, [r7, #8]
.L1194:
	ldr	r1, [sp, #4]
	add	r8, r8, #1
	ldr	r0, [r7, #12]
	bl	FtlGcUpdatePage
	b	.L1171
.L1176:
	str	r3, [sp, #8]
	adds	r3, r2, #1
	beq	.L1178
	str	r2, [sp, #32]
	movs	r1, #1
	ldr	r2, .L1195+40
	add	r0, sp, #28
	ldr	r2, [r2]
	str	r2, [sp, #36]
	ldr	r2, .L1195+44
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L1195+48
	ldr	r1, [fp]
	ldr	r3, [sp, #8]
	ldrh	r2, [r2]
	ldr	r0, [sp, #36]
	add	ip, r3, r1
	lsls	r2, r2, #7
.L1179:
	cmp	r6, r2
	beq	.L1178
	ldr	r1, [ip, #8]
	ldr	r3, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r3
	beq	.L1180
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L1195+52
	bl	printf
	b	.L1193
.L1180:
	adds	r6, r6, #1
	b	.L1179
.L1172:
	mov	r2, #-1
	b	.L1194
.L1196:
	.align	2
.L1195:
	.word	.LANCHOR160
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR64
	.word	.LANCHOR23
	.word	.LANCHOR65
	.word	.LANCHOR24
	.word	.LANCHOR152
	.word	.LANCHOR42
	.word	.LANCHOR145
	.word	.LANCHOR110
	.word	.LANCHOR115
	.word	.LANCHOR12
	.word	.LC35
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
	ldr	r3, .L1209
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #104
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1205
	ldr	r3, .L1209+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L1199:
	cbnz	r5, .L1204
.L1197:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1204:
	ldr	r3, .L1209+8
	mov	r0, r7
	ldr	r10, .L1209+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L1209+12
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
	cbz	r2, .L1201
	cmp	r4, r3
	beq	.L1201
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
.L1202:
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
	ldr	r0, .L1209+16
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
	b	.L1199
.L1201:
	ldr	r3, .L1209+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1202
.L1205:
	mov	r8, #-1
	b	.L1197
.L1210:
	.align	2
.L1209:
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
	ldr	r2, .L1213
	ldr	r3, .L1213+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L1211
	ldr	r3, .L1213+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L1213+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L1213+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L1213+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L1213+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L1213+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L1213+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L1213+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L1213+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L1213+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L1213+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L1213+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L1213+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	b	FtlVendorPartWrite
.L1211:
	bx	lr
.L1214:
	.align	2
.L1213:
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
	ldr	r2, .L1220
	push	{r3, lr}
	ldrh	r3, [r2]
	cmp	r3, #31
	itett	ls
	addls	r3, r3, #1
	movhi	r3, #32
	strhls	r3, [r2]	@ movhi
	movls	r3, #1
	ldr	r2, .L1220+4
	cbnz	r0, .L1217
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L1218
.L1217:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1220+8
	str	r3, [r2]
	ldr	r3, .L1220+12
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
.L1218:
	movs	r0, #0
	pop	{r3, pc}
.L1221:
	.align	2
.L1220:
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
	ldr	r3, .L1233
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #104
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1232
	ldr	r3, .L1233+4
	mov	r8, #0
	ldr	fp, .L1233+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L1225:
	cbnz	r6, .L1231
.L1223:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1231:
	ldr	r3, .L1233+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L1233+12
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
	beq	.L1227
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
	ldr	r2, .L1233+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L1229
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L1233+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L1233+24
	bl	FtlMapWritePage
.L1229:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L1230:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L1225
.L1227:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L1230
.L1232:
	mov	r8, #-1
	b	.L1223
.L1234:
	.align	2
.L1233:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR123
	.word	.LANCHOR12
	.word	.LANCHOR138
	.word	.LC36
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
	ldr	r4, .L1237
	ldr	r5, .L1237+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L1237+8
	cmp	r2, r3
	beq	.L1236
	ldr	r1, .L1237+12
	ldr	r0, .L1237+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L1236:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1238:
	.align	2
.L1237:
	.word	.LANCHOR118
	.word	.LANCHOR116
	.word	1112818501
	.word	.LC37
	.word	.LC38
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
	ldr	r4, .L1242
	movs	r0, #0
	ldr	r5, .L1242+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L1240
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L1240:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r3, .L1242+8
	bne	.L1241
	ldr	r1, [r4, #88]
	ldr	r2, .L1242+12
	str	r1, [r2]
	ldr	r1, [r4, #92]
	ldr	r2, .L1242+16
	str	r1, [r2]
	ldr	r1, [r4, #8]
	ldr	r2, .L1242+20
	str	r1, [r2]
	ldr	r1, [r4, #12]
	ldr	r2, .L1242+24
	str	r1, [r2]
	ldr	r1, [r4, #16]
	ldr	r2, .L1242+28
	str	r1, [r2]
	ldr	r1, [r4, #20]
	ldr	r2, .L1242+32
	str	r1, [r2]
	ldr	r2, [r4, #28]
	ldr	r1, [r4, #32]
	str	r2, [r3]
	ldr	r2, .L1242+36
	str	r1, [r2]
	ldr	r1, [r4, #36]
	ldr	r2, .L1242+40
	str	r1, [r2]
	ldr	r1, [r4, #40]
	ldr	r2, .L1242+44
	str	r1, [r2]
	ldr	r1, [r4, #44]
	ldr	r2, .L1242+48
	str	r1, [r2]
	ldr	r1, [r4, #48]
	ldr	r2, .L1242+52
	str	r1, [r2]
.L1241:
	ldr	r1, .L1242+56
	ldr	r2, .L1242+60
	ldr	r3, [r3]
	ldr	r0, [r1]
	ldrh	r2, [r2]
	ldr	r1, .L1242+64
	mla	r0, r0, r2, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1242+68
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L1243:
	.align	2
.L1242:
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
	.word	.LANCHOR143
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
	beq	.L1245
	movs	r3, #0
	ldr	r5, .L1257
	str	r3, [r0, #36]
	ldr	r3, .L1257+4
	ldrh	r6, [r0, #6]
	mov	r7, r5
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	str	r3, [r5, #8]
	ldr	r3, .L1257+8
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L1247
	ldr	r2, .L1257+12
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L1247
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1247
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
	beq	.L1247
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L1247
	ldr	r2, [r5, #8]
.L1256:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L1247:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L1248
	movs	r2, #1
	ldr	r0, .L1257
	mov	r1, r2
	bl	FlashReadPages
.L1249:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L1256
.L1248:
	ldr	r3, .L1257+16
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1249
.L1245:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1258:
	.align	2
.L1257:
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
	ldr	r5, .L1274
	ldr	r3, .L1274+4
	ldr	fp, .L1274+76
	ldr	r6, .L1274+8
	ldr	r7, [r3]
	ldr	r0, [fp]
	ldrh	r3, [r5]
	str	r7, [r6, #12]
	str	r0, [r6, #8]
	strh	r3, [r7, #2]	@ movhi
	movw	r3, #61604
	ldr	r4, .L1274+12
	strh	r3, [r7]	@ movhi
	ldr	r2, .L1274+16
	ldr	r3, [r5, #8]
	ldr	ip, .L1274+80
	str	r10, [r7, #8]
	str	r3, [r7, #4]
	stm	r4, {r2, ip}
	ldrh	r2, [r5, #6]
	str	r10, [r7, #12]
	ldr	r8, .L1274+84
	strh	r2, [r4, #8]	@ movhi
	ldr	r2, .L1274+20
	ldr	r3, .L1274+24
	ldrh	r2, [r2]
	strb	r2, [r4, #10]
	ldr	r2, .L1274+28
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #14]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #11]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1274+32
	strh	r1, [r4, #16]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #18]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #12]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1274+36
	strh	r1, [r4, #20]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #22]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #13]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1274+40
	strh	r1, [r4, #24]	@ movhi
	movs	r1, #255
	ldr	r2, [r2]
	str	r2, [r4, #32]
	ldr	r2, [r8]
	str	r2, [r4, #40]
	ldr	r2, .L1274+44
	ldr	r2, [r2]
	str	r2, [r4, #36]
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r4
	ldr	r4, .L1274+48
	movs	r2, #48
	ldr	r0, [r6, #8]
	bl	ftl_memcpy
	ldrh	r2, [r4]
	ldr	r0, [r6, #8]
	ldr	r1, .L1274+52
	lsls	r2, r2, #1
	adds	r0, r0, #48
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldrh	r0, [r4]
	ldr	r1, .L1274+56
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
	ldr	r10, .L1274+4
	bl	FtlUpdateVaildLpn
	movw	r3, #65535
	str	r3, [sp]
	ldr	r3, .L1274+24
	str	r3, [sp, #4]
.L1260:
	ldr	r3, [fp]
	ldrh	r1, [r5, #2]
	ldrh	r2, [r5]
	str	r3, [r6, #8]
	ldr	r3, [r10]
	str	r3, [r6, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r6, #4]
	ldr	r3, .L1274+60
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1261
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
.L1261:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r3, #1
	str	r0, [r7, #12]
	mov	r2, r3
	mov	r1, r3
	ldr	r0, .L1274+8
	bl	FlashProgPages
	ldrh	r3, [r5, #2]
	ldr	r2, [r6]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r5, #2]	@ movhi
	bne	.L1262
	cmp	r3, #1
	bne	.L1263
	movw	r2, #1138
	ldr	r1, .L1274+64
	ldr	r0, .L1274+68
	bl	printf
.L1263:
	ldrh	r3, [r5, #2]
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1274+60
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r5, #2]	@ movhi
	cmp	r4, #3
	bls	.L1260
	mov	r2, r4
	ldr	r1, [r6, #4]
	ldr	r0, .L1274+72
	bl	printf
.L1266:
	b	.L1266
.L1262:
	cmp	r3, #1
	beq	.L1260
	cmp	r2, #256
	beq	.L1260
	ldr	r2, [sp]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1267
	movs	r1, #1
	mov	r0, r2
	bl	FtlFreeSysBlkQueueIn
.L1267:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1275:
	.align	2
.L1274:
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
	.word	.LC39
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
	ldr	r3, .L1279
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L1278
	bl	FtlSysFlush
.L1278:
	movs	r0, #0
	pop	{r3, pc}
.L1280:
	.align	2
.L1279:
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
	ldr	r3, .L1296
	adds	r2, r0, r1
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r7, r0
	mov	r5, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1289
	cmp	r1, #31
	bhi	.L1283
.L1288:
	movs	r0, #0
.L1281:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1283:
	ldr	r8, .L1296+12
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r6, r0
	subs	r7, r7, r3
	uxth	r7, r7
	cbz	r7, .L1284
	subs	r4, r4, r7
	adds	r6, r6, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L1284:
	ldr	r4, .L1296+4
	mov	r3, #-1
	ldr	r7, .L1296+8
	str	r3, [sp, #4]
.L1285:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L1287
	ldr	r3, .L1296+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L1288
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1288
.L1287:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r6
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L1286
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
.L1286:
	ldrh	r3, [r8]
	adds	r6, r6, #1
	subs	r5, r5, r3
	b	.L1285
.L1289:
	mov	r0, #-1
	b	.L1281
.L1297:
	.align	2
.L1296:
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
	ldr	r3, .L1308
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r0]
	ldrh	r3, [r3]
	cmp	r3, r4
	bcs	.L1299
	movw	r2, #2755
	ldr	r1, .L1308+4
	ldr	r0, .L1308+8
	bl	printf
.L1299:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1300
	ldr	r3, .L1308+12
	mov	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbz	r3, .L1301
	bl	INSERT_DATA_LIST
.L1300:
	ldr	r5, .L1308+16
	movw	r2, #65535
	movs	r3, #1
	strb	r3, [r6, #8]
	ldrh	r0, [r5]
	cmp	r0, r2
	beq	.L1302
	cmp	r4, r0
	bne	.L1303
	ldr	r3, .L1308+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1304
.L1303:
	bl	update_vpc_list
.L1304:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1302:
	mov	r0, r6
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1301:
	bl	INSERT_FREE_LIST
	b	.L1300
.L1309:
	.align	2
.L1308:
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r10, .L1329+20
	mov	r5, r3
	movs	r2, #0
	mov	r4, r0
	ldr	fp, .L1329
	mov	r8, r1
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	bl	FlashProgPages
.L1311:
	cmp	r6, r8
	bne	.L1318
	ldr	r3, .L1329
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1310
	movw	r2, #997
	ldr	r1, .L1329+4
	ldr	r0, .L1329+8
	bl	printf
.L1310:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1313:
	ldr	r1, [r4, #4]
	mov	r0, r10
	bl	printf
	ldr	r0, [r4, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1312
	mov	r0, r5
	bl	allocate_new_data_superblock
.L1312:
	mov	r0, r5
	bl	get_new_active_ppa
	movs	r2, #0
	str	r0, [r4, #4]
	str	r0, [sp, #12]
	movs	r1, #1
	ldrb	r3, [r5, #9]	@ zero_extendqisi2
	mov	r0, r4
	bl	FlashProgPages
.L1318:
	ldr	r2, [r4]
	adds	r3, r2, #1
	beq	.L1313
	cmp	r2, #256
	beq	.L1313
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [fp]
	cmp	r2, r3
	bcc	.L1314
	movw	r2, #982
	ldr	r1, .L1329+4
	ldr	r0, .L1329+8
	bl	printf
.L1314:
	ldr	r3, [r4, #4]
	add	r1, sp, #16
	movs	r2, #1
	ldr	r0, [r4, #16]
	str	r3, [r1, #-4]!
	bl	log2phys
	ldr	r3, [r4, #12]
	ldr	r3, [r3, #12]
	ubfx	r0, r3, #10, #16
	str	r3, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r3, [sp, #4]
	mov	r7, r0
	adds	r3, r3, #1
	beq	.L1315
	ldr	r3, .L1329+12
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1316
	mov	r1, r0
	ldr	r0, .L1329+16
	bl	printf
.L1316:
	mov	r0, r7
	bl	decrement_vpc_count
.L1315:
	adds	r6, r6, #1
	adds	r4, r4, #20
	b	.L1311
.L1330:
	.align	2
.L1329:
	.word	.LANCHOR3
	.word	.LANCHOR169
	.word	.LC1
	.word	.LANCHOR42
	.word	.LC41
	.word	.LC40
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
	ldr	r4, .L1346
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1332
	ldr	r3, .L1346+4
	mov	r0, r4
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
.L1332:
	ldr	r3, .L1346+8
	movs	r2, #0
	str	r2, [r3]
	movw	r3, #65535
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1334
	ldr	r6, .L1346+4
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldr	r5, .L1346+12
	ldrh	r2, [r6]
	ldrh	r1, [r5]
	muls	r2, r0, r2
	cmp	r1, r2
	beq	.L1335
	movs	r2, #164
	ldr	r1, .L1346+16
	ldr	r0, .L1346+20
	bl	printf
.L1335:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L1346+24
	ldrh	r0, [r4]
	ldr	fp, .L1346+56
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	mov	r10, r2
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L1346+28
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L1336:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1340
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r0, [r4]
	ldr	r3, [r10]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L1341
	bl	INSERT_DATA_LIST
.L1342:
	ldr	r2, .L1346+32
	movs	r3, #0
	movw	r6, #65535
	strh	r3, [r5]	@ movhi
	strh	r6, [r4]	@ movhi
	strh	r3, [r2]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1346+36
	strh	r6, [r3]	@ movhi
	ldr	r3, .L1346+40
	ldrh	r2, [r3]
	ldr	r3, .L1346+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ittt	gt
	ldrgt	r3, .L1346+48
	movgt	r2, #20
	strhgt	r2, [r3]	@ movhi
.L1334:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1340:
	uxth	r3, r6
	mov	r8, #12
	ldr	r2, [fp]
	mul	r8, r8, r3
	ldr	r3, .L1346+52
	ldr	r3, [r3]
	add	r7, r3, r8
	ldr	r0, [r7, #8]
	cmp	r0, r2
	bcc	.L1337
.L1344:
	ldrh	r0, [r4]
	b	.L1345
.L1337:
	movs	r2, #0
	add	r1, sp, #12
	str	r3, [sp, #4]
	bl	log2phys
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #12]
	ldr	r0, [r3, r8]
	cmp	r0, r2
	bne	.L1339
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r8, r0
	adds	r1, r7, #4
	ldr	r0, [r7, #8]
	bl	log2phys
	mov	r0, r8
.L1345:
	bl	decrement_vpc_count
	b	.L1338
.L1339:
	ldr	r3, [r7, #4]
	cmp	r2, r3
	bne	.L1344
.L1338:
	adds	r6, r6, #1
	b	.L1336
.L1341:
	bl	INSERT_FREE_LIST
	b	.L1342
.L1347:
	.align	2
.L1346:
	.word	.LANCHOR53
	.word	.LANCHOR19
	.word	.LANCHOR133
	.word	.LANCHOR70
	.word	.LANCHOR170
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR84
	.word	.LANCHOR69
	.word	.LANCHOR145
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
	ldr	r4, .L1350
	ldr	r5, .L1350+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1348
	ldr	r0, .L1350+8
	bl	FtlMapBlkWriteDump_data
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1350+12
	movs	r2, #0
	str	r2, [r3]
.L1348:
	pop	{r3, r4, r5, pc}
.L1351:
	.align	2
.L1350:
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
	ldr	r5, .L1353
	ldr	r3, .L1353+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1353+8
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
.L1354:
	.align	2
.L1353:
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
	ldr	r4, .L1363
	movs	r6, #0
	movs	r7, #20
	mov	r2, r3
	ldr	r5, .L1363+4
	ldr	r1, [r4]
	ldr	r0, [r5]
	bl	FlashProgPages
.L1356:
	ldr	r1, [r4]
	uxth	r3, r6
	cmp	r1, r3
	bhi	.L1359
	ldr	r0, [r5]
	bl	FtlGcBufFree
	ldr	r3, .L1363+8
	movs	r0, #0
	str	r0, [r4]
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1355
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	movs	r0, #1
.L1355:
	pop	{r3, r4, r5, r6, r7, pc}
.L1359:
	muls	r3, r7, r3
	ldr	r2, [r5]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	ldr	r0, [r1, #12]
	ldr	r1, [r1, #4]
	adds	r3, r2, #1
	it	ne
	ldrne	r2, [r0, #8]
	ldr	r0, [r0, #12]
	bl	FtlGcUpdatePage
	b	.L1356
.L1364:
	.align	2
.L1363:
	.word	.LANCHOR62
	.word	.LANCHOR104
	.word	.LANCHOR53
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
	ldr	r4, .L1368
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1366
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1367
.L1366:
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1368
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1368+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L1368+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1367:
	ldr	r0, .L1368
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1369:
	.align	2
.L1368:
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
	ldr	r3, .L1460
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	str	r0, [sp, #28]
	ldr	r0, [r3]
	cmp	r0, #0
	bne	.L1427
	ldr	r3, .L1460+4
	ldrh	r3, [r3]
	cmp	r3, #47
	bls	.L1370
	ldr	r3, .L1460+8
	movw	r4, #65535
	ldrh	r0, [r3]
	cmp	r0, r4
	beq	.L1372
	ldr	r1, .L1460+12
	ldrh	r2, [r1]
	cmp	r2, r4
	itt	eq
	strheq	r0, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
.L1372:
	ldr	r3, [sp, #28]
	cmp	r3, #0
	bne	.L1429
	ldr	r3, .L1460+16
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L1430
	ldr	r2, .L1460+20
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L1375
	lsrs	r4, r4, #5
.L1374:
	ldr	r2, .L1460+24
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1378
	ldr	r3, .L1460+28
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1379
	ldr	r0, .L1460+12
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L1379
	ldr	r3, .L1460+32
	ldrh	r0, [r3]
	cbnz	r0, .L1380
	ldr	r3, .L1460+36
	ldr	r4, .L1460+40
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L1381
.L1380:
	ldr	r3, .L1460+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1382:
	ldr	r3, .L1460+48
	movs	r2, #0
	str	r2, [r3]
.L1370:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1375:
	cmp	r3, #12
	bls	.L1376
	lsrs	r4, r4, #4
	b	.L1374
.L1376:
	cmp	r3, #8
	bls	.L1374
	lsrs	r4, r4, #2
	b	.L1374
.L1430:
	movs	r4, #1
	b	.L1374
.L1381:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L1382
.L1379:
	ldr	r3, .L1460+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1378:
	ldr	r3, .L1460+52
	ldrh	r3, [r3]
	cbz	r3, .L1373
	adds	r4, r4, #32
	uxth	r4, r4
.L1373:
	ldr	r5, .L1460+56
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L1385
	ldr	r3, .L1460+12
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1386
	ldr	r0, .L1460+60
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L1387
	strh	r2, [r3]	@ movhi
.L1387:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L1386:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L1385
	bl	IsBlkInGcList
	cbz	r0, .L1389
	strh	r6, [r5]	@ movhi
.L1389:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1385
	ldr	r0, .L1460+56
	bl	make_superblock
	ldr	r2, .L1460+64
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1460+60
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1460+68
	strh	r2, [r3]	@ movhi
.L1385:
	ldr	r2, .L1460+72
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1390
	ldr	r2, .L1460+76
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1390
	ldr	r2, .L1460+28
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1391
.L1390:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1391:
	ldr	r5, .L1460+56
	mov	r6, r5
.L1426:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1392
	ldr	fp, .L1460+88
	movs	r2, #0
	ldr	r3, .L1460+48
	mov	r8, fp
	str	r2, [r3]
.L1393:
	ldrh	r7, [fp]
	mov	r0, r7
	bl	List_get_gc_head_node
	uxth	r3, r0
	movw	r1, #65535
	cmp	r3, r1
	strh	r3, [r6]	@ movhi
	bne	.L1394
	movs	r3, #0
	movs	r0, #8
	strh	r3, [fp]	@ movhi
	b	.L1370
.L1429:
	movs	r4, #1
	b	.L1373
.L1394:
	str	r0, [sp, #16]
	mov	r0, r3
	str	r3, [sp, #12]
	adds	r7, r7, #1
	bl	IsBlkInGcList
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #16]
	cbz	r0, .L1395
	strh	r7, [fp]	@ movhi
	b	.L1393
.L1395:
	uxth	r0, r2
	ldr	r2, .L1460+20
	ldr	r10, .L1460+60
	uxth	r7, r7
	ldrh	lr, [r2]
	ldr	r2, .L1460+80
	ldr	r1, [r10]
	strh	r7, [fp]	@ movhi
	ldrh	r2, [r2]
	ldrh	ip, [r1, r0, lsl #1]
	mul	r2, r2, lr
	cmp	ip, r2, asr #1
	bgt	.L1397
	cmp	r7, #48
	bls	.L1398
	cmp	ip, #8
	bls	.L1398
	ldr	r7, .L1460+84
	ldrh	r7, [r7]
	cmp	r7, #35
	bhi	.L1398
.L1397:
	movs	r7, #0
	strh	r7, [r8]	@ movhi
.L1398:
	ldrh	r1, [r1, r0, lsl #1]
	cmp	r2, r1
	bgt	.L1399
	ldrh	r2, [r8]
	cmp	r2, #3
	bhi	.L1399
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r8]	@ movhi
.L1459:
	ldr	r3, .L1460+32
	ldrh	r0, [r3]
	b	.L1370
.L1399:
	cbnz	r1, .L1400
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r8]
	adds	r3, r3, #1
	strh	r3, [r8]	@ movhi
	b	.L1393
.L1461:
	.align	2
.L1460:
	.word	.LANCHOR94
	.word	.LANCHOR44
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
	.word	.LANCHOR145
	.word	.LANCHOR42
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR3
	.word	.LANCHOR69
	.word	.LANCHOR102
.L1400:
	movs	r2, #0
	strb	r2, [r6, #8]
	ldr	r2, .L1462
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1401
	movw	r2, #717
	ldr	r1, .L1462+4
	ldr	r0, .L1462+8
	bl	printf
.L1401:
	ldr	r3, .L1462+12
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1402
	movw	r2, #718
	ldr	r1, .L1462+4
	ldr	r0, .L1462+8
	bl	printf
.L1402:
	ldr	r3, .L1462+16
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1403
	movw	r2, #719
	ldr	r1, .L1462+4
	ldr	r0, .L1462+8
	bl	printf
.L1403:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L1462+20
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r10]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L1462+24
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L1392:
	ldr	r3, .L1462+28
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L1462+32
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, [sp, #28]
	cbz	r3, .L1404
	ldr	r3, .L1462+36
	ldr	r2, [sp, #16]
	ldrh	r1, [r6]
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L1462+40
	ldr	r2, [r2]
	ldrh	r2, [r2, r1, lsl #1]
	subs	r3, r3, r2
	it	mi
	addmi	r3, r3, #3
	add	r4, r4, r3, asr #2
	uxth	r4, r4
.L1404:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #16]
	ldr	fp, .L1462+64
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #24]
.L1407:
	ldrh	r3, [sp, #24]
	cmp	r4, r3
	bls	.L1415
	ldr	r3, .L1462+36
	movw	r10, #65535
	ldrh	r1, [r5, #2]
	mov	ip, #20
	ldr	r0, [fp]
	ldrh	lr, [r3]
	ldr	r3, [sp, #24]
	ldr	r7, .L1462+44
	adds	r3, r1, r3
	str	r3, [sp, #20]
	movs	r3, #0
	str	r3, [sp, #12]
	b	.L1416
.L1409:
	ldrh	r2, [r7, #2]!
	cmp	r2, r10
	beq	.L1408
	ldr	r1, [sp, #12]
	mla	r8, ip, r1, r0
	ldr	r1, [sp, #20]
	orr	r2, r1, r2, lsl #10
	str	r2, [r8, #4]
	ldr	r2, [sp, #12]
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1408:
	adds	r3, r3, #1
.L1416:
	uxth	r2, r3
	cmp	lr, r2
	bhi	.L1409
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1458:
	str	r3, [sp, #20]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #20]
	cmp	r2, r3
	bhi	.L1414
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	str	r3, [sp, #24]
	b	.L1407
.L1414:
	ldr	r3, [sp, #20]
	movs	r7, #20
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L1411
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L1411
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L1412
	movw	r2, #753
	ldr	r1, .L1462+4
	ldr	r0, .L1462+8
	bl	printf
.L1412:
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #40]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	cmp	r2, r3
	bne	.L1411
	ldr	r2, .L1462+20
	ldr	r10, .L1462+60
	ldr	r1, .L1462+48
	ldrh	r3, [r2]
	str	r1, [sp, #36]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, [r1]
	movs	r1, #20
	ldr	r3, [r10]
	mla	r3, r1, r3, r2
	ldr	r2, [r0, #16]
	str	r2, [r3, #16]
	str	r3, [sp, #32]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #32]
	ldr	r1, [sp, #36]
	str	r0, [r3, #4]
	ldr	r2, [r1]
	movs	r1, #20
	ldr	r3, [r10]
	ldr	r0, [fp]
	mla	r2, r1, r3, r2
	add	r0, r0, r7
	ldr	r7, .L1462+16
	ldr	r1, [r0, #8]
	adds	r3, r3, #1
	str	r1, [r2, #8]
	ldr	r1, [r0, #12]
	str	r1, [r2, #12]
	movs	r1, #1
	ldr	r2, [sp, #40]
	str	r2, [r8, #12]
	ldrh	r2, [r7]
	strh	r2, [r8, #2]	@ movhi
	ldr	r2, .L1462+52
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L1413
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1411
.L1413:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1411
	ldr	r3, .L1462+28
	movs	r2, #0
	movw	r1, #65535
	str	r2, [r3]
	ldr	r3, .L1462+56
	strh	r1, [r3]	@ movhi
	strh	r2, [r3, #2]	@ movhi
	b	.L1459
.L1411:
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1458
.L1415:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #16]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L1417
	ldr	r3, .L1462+60
	ldr	r3, [r3]
	cbz	r3, .L1418
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1418
	ldr	r3, .L1462+28
	movs	r2, #0
	str	r2, [r3]
	b	.L1459
.L1463:
	.align	2
.L1462:
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
	.word	.LANCHOR145+14
	.word	.LANCHOR104
	.word	.LANCHOR83
	.word	.LANCHOR145
	.word	.LANCHOR62
	.word	.LANCHOR66
.L1418:
	ldr	r3, .L1464
	ldrh	r4, [r3]
	cmp	r4, #0
	bne	.L1419
	ldr	r8, .L1464+28
	ldrh	r1, [r5]
	ldr	r3, [r8]
	ldrh	r3, [r3, r1, lsl #1]
	cmp	r3, #0
	beq	.L1419
	ldr	r0, .L1464+4
	ldr	r10, .L1464+32
	ldrh	r2, [r5, #2]
	ldrh	r0, [r0]
	str	r3, [sp]
	mov	r3, r4
	str	r0, [sp, #4]
	ldr	r0, .L1464+8
	bl	printf
.L1420:
	ldr	r3, [r10]
	cmp	r4, r3
	bcs	.L1422
	movs	r2, #0
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #44]
	adds	r3, r7, #1
	beq	.L1421
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5]
	cmp	r3, r0
	bne	.L1421
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L1464+12
	bl	printf
.L1422:
	ldr	r3, [r10]
	cmp	r4, r3
	bcc	.L1419
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1419:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1417:
	ldr	r3, .L1464+16
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, .L1464+20
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L1425
	ldr	r3, .L1464+24
	ldrh	r4, [r3]
	b	.L1426
.L1421:
	adds	r4, r4, #1
	b	.L1420
.L1425:
	adds	r0, r0, #1
	b	.L1370
.L1427:
	movs	r0, #0
	b	.L1370
.L1465:
	.align	2
.L1464:
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LC42
	.word	.LC43
	.word	.LANCHOR94
	.word	.LANCHOR48
	.word	.LANCHOR19
	.word	.LANCHOR42
	.word	.LANCHOR152
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
	bne	.L1467
	mov	r2, r3
	ldr	r1, [sp, #24]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #4]
.L1466:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1467:
	ldr	r3, [sp, #24]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L1499
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1488
	ldr	r3, .L1499+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L1489
	ldr	r3, .L1499+8
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
	ldr	r2, .L1499+12
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
	ldr	r2, .L1499+16
	str	r7, [sp, #4]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1469:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1486
	ldr	r3, .L1499+20
	ldrh	r3, [r3]
	cbnz	r3, .L1487
	ldr	r3, .L1499+24
	ldrh	r3, [r3]
	cmp	r3, #31
	bhi	.L1466
.L1487:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	b	.L1466
.L1486:
	movs	r2, #0
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #52]
	adds	r0, r3, #1
	bne	.L1470
	ldr	fp, .L1499+8
	mov	r10, #0
.L1471:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L1473
.L1474:
	ldr	r3, [sp, #8]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1478
	ldr	r3, .L1499+28
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L1469
.L1478:
	cmp	r5, #0
	beq	.L1469
	ldr	r3, .L1499+32
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
.L1485:
	movs	r3, #20
	mul	fp, r3, r10
	ldr	r3, .L1499+32
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	add	r2, r2, fp
	ldr	r1, [r2, #16]
	cmp	r3, r1
	bne	.L1480
	ldr	r1, [r2, #8]
	ldr	r2, .L1499+36
	ldr	r2, [r2]
	cmp	r1, r2
	bne	.L1481
	ldr	r3, [sp, #36]
	mov	r0, r8
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L1498:
	bl	ftl_memcpy
.L1481:
	ldr	r3, .L1499+32
	ldr	r3, [r3]
	add	r2, r3, fp
	ldr	r3, [r3, fp]
	ldr	r0, [r2, #12]
	ldr	r1, [r2, #16]
	ldr	r0, [r0, #8]
	cmp	r1, r0
	itttt	ne
	ldrne	r0, .L1499+40
	ldrne	r1, [r0, #72]
	addne	r1, r1, #1
	strne	r1, [r0, #72]
	adds	r1, r3, #1
	bne	.L1483
	ldr	r1, .L1499+40
	str	r3, [sp, #4]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1484:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L1485
	movs	r5, #0
	b	.L1469
.L1473:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L1472
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L1472
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r8, r0, lsl #9
	bl	ftl_memset
.L1472:
	add	r10, r10, #1
	b	.L1471
.L1470:
	ldr	r2, .L1499+32
	mov	r10, #20
	ldr	r2, [r2]
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L1499+8
	bne	.L1475
	ldr	r2, .L1499+36
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
	bne	.L1476
	str	r8, [r10, #8]
.L1476:
	ldr	r3, .L1499+44
	ldr	r2, .L1499+48
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L1474
.L1475:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L1477
	ldr	r2, .L1499+52
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r7, r1, r3
	cmp	r2, r7
	bne	.L1476
.L1497:
	subs	r3, r3, r6
	add	r3, r8, r3, lsl #9
	str	r3, [r10, #8]
	b	.L1476
.L1477:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L1497
.L1480:
	ldr	r3, [sp, #20]
	cmp	r3, r1
	bne	.L1481
	ldr	r3, .L1499+52
	ldr	r1, [r2, #8]
	ldr	r2, [r3]
	cmp	r1, r2
	bne	.L1481
	ldr	r2, .L1499+8
	ldr	r3, [sp, #20]
	ldrh	r0, [r2]
	ldr	r2, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r8, r0, lsl #9
	b	.L1498
.L1483:
	cmp	r3, #256
	bne	.L1484
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1484
.L1488:
	mov	r3, #-1
.L1489:
	str	r3, [sp, #4]
	b	.L1466
.L1500:
	.align	2
.L1499:
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
	mov	fp, r1
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bne	.L1503
	mov	r2, r3
	ldr	r1, [sp, #20]
	add	r0, fp, #256
	bl	FtlVendorPartWrite
.L1502:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1503:
	ldr	r3, [sp, #20]
	adds	r4, r1, r3
	ldr	r3, .L1547
	ldr	r3, [r3]
	cmp	r4, r3
	bhi	.L1536
	ldr	r3, .L1547+4
	ldr	r0, [r3]
	adds	r1, r0, #1
	beq	.L1502
	ldr	r3, .L1547+8
	mov	r2, #2048
	mov	r0, fp
	ldr	r7, .L1547+12
	str	r2, [r3]
	ldr	r3, .L1547+16
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
	ldr	r2, .L1547+20
	str	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r3, [r2]
	str	r0, [sp, #28]
	add	r3, r3, r1
	ldr	r1, [sp, #8]
	str	r3, [r2]
	ldr	r2, .L1547+24
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1505:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1531
	ldr	r5, .L1547+28
	mov	r0, r3
	ldr	r1, [sp, #32]
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r5]
	cmp	r2, #5
	bls	.L1532
.L1534:
	movs	r0, #0
	b	.L1502
.L1531:
	ldr	r4, .L1547+32
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1506
	movw	r2, #1038
	ldr	r1, .L1547+36
	ldr	r0, .L1547+40
	bl	printf
.L1506:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1507
	mov	r0, r7
	bl	allocate_new_data_superblock
.L1507:
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
	bcc	.L1508
	movw	r2, #1071
	ldr	r1, .L1547+36
	ldr	r0, .L1547+40
	bl	printf
.L1508:
	ldr	r8, .L1547+44
	movs	r3, #0
	str	r3, [sp, #4]
.L1509:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #44]
	cmp	r3, r2
	bne	.L1529
.L1510:
	ldr	r0, .L1547+44
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #4]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bls	.L1530
	movw	r2, #1149
	ldr	r1, .L1547+36
	ldr	r0, .L1547+40
	bl	printf
.L1530:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	subs	r3, r3, r2
	str	r3, [sp, #8]
	b	.L1505
.L1529:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L1510
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r5
	movs	r6, #20
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r2, .L1547+48
	ldr	r1, [sp, #4]
	ldr	r3, [sp, #4]
	ldrh	r2, [r2]
	muls	r6, r3, r6
	ldr	r3, [r8]
	muls	r1, r2, r1
	add	r3, r3, r6
	str	r0, [r3, #4]
	bic	r1, r1, #3
	str	r5, [r3, #16]
	str	r1, [sp, #36]
	ldr	r1, .L1547+52
	ldr	r0, [sp, #36]
	ldr	r1, [r1]
	add	r10, r1, r0
	str	r1, [sp, #40]
	str	r10, [r3, #12]
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
	ldr	r3, [sp, #12]
	ldr	r2, .L1547+16
	cmp	r5, r3
	beq	.L1511
	ldr	r3, [sp, #28]
	cmp	r5, r3
	bne	.L1542
	ldrh	r2, [r2]
	ldr	r3, [sp, #20]
	smulbb	r2, r2, r5
	add	r4, fp, r3
	movs	r3, #0
	str	r3, [sp, #24]
	subs	r4, r4, r2
	uxth	r4, r4
	b	.L1514
.L1511:
	ldrh	r4, [r2]
	mov	r0, fp
	mov	r1, r4
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #20]
	subs	r4, r4, r1
	str	r1, [sp, #24]
	cmp	r4, r3
	it	cs
	movcs	r4, r3
.L1514:
	ldr	r3, .L1547+16
	ldrh	r3, [r3]
	cmp	r4, r3
	ldr	r3, [sp, #12]
	bne	.L1515
	cmp	r5, r3
	ldr	r3, [r8]
	add	r6, r6, r3
	bne	.L1516
	ldr	r3, [sp, #16]
.L1544:
	str	r3, [r6, #8]
	b	.L1517
.L1516:
	muls	r4, r5, r4
	ldr	r3, [sp, #16]
	sub	r4, r4, fp
	add	r4, r3, r4, lsl #9
	str	r4, [r6, #8]
.L1517:
	ldr	r3, .L1547+32
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1526
	movw	r2, #1140
	ldr	r1, .L1547+36
	ldr	r0, .L1547+40
	bl	printf
.L1526:
	ldr	r2, [sp, #40]
	movw	r3, #61589
	ldr	r1, [sp, #36]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L1547+56
	str	r5, [r10, #8]
	adds	r5, r5, #1
	ldr	r3, [r2]
	str	r3, [r10, #4]
	adds	r3, r3, #1
	adds	r1, r3, #1
	it	eq
	moveq	r3, #0
	str	r3, [r2]
	ldr	r3, [sp, #48]
	str	r3, [r10, #12]
	ldrh	r3, [r7]
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	str	r3, [sp, #4]
	b	.L1509
.L1515:
	cmp	r5, r3
	ldr	r3, [r8]
	ite	eq
	ldreq	r2, .L1547+60
	ldrne	r2, .L1547+64
	add	r3, r3, r6
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r3, [sp, #48]
	adds	r2, r3, #1
	beq	.L1520
	str	r3, [sp, #56]
	movs	r1, #1
	ldr	r3, [r8]
	add	r0, sp, #52
	str	r5, [sp, #68]
	add	r3, r3, r6
	ldr	r2, [r3, #8]
	ldr	r3, [r3, #12]
	str	r2, [sp, #60]
	movs	r2, #0
	str	r3, [sp, #64]
	bl	FlashReadPages
	ldr	r3, [sp, #52]
	adds	r0, r3, #1
	bne	.L1521
	ldr	r1, .L1547+68
	ldr	r0, .L1547+72
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
	mov	r2, r5
	ldr	r1, [r10, #8]
	bl	printf
.L1524:
	ldr	r3, [sp, #12]
	lsls	r2, r4, #9
	cmp	r5, r3
	bne	.L1525
	ldr	r3, [r8]
	ldr	r1, [sp, #16]
	add	r6, r6, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r6, #8]
	add	r0, r0, r3, lsl #9
.L1545:
	bl	ftl_memcpy
	b	.L1517
.L1521:
	ldr	r1, [r10, #8]
	cmp	r5, r1
	beq	.L1523
	ldr	r2, .L1547+68
	ldr	r0, .L1547+76
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r5
	bl	printf
.L1523:
	ldr	r3, [r10, #8]
	cmp	r5, r3
	beq	.L1524
	movw	r2, #1125
	ldr	r1, .L1547+36
	ldr	r0, .L1547+40
	bl	printf
	b	.L1524
.L1520:
	ldr	r3, [r8]
	movs	r1, #0
	ldr	r2, .L1547+80
	add	r3, r3, r6
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L1524
.L1548:
	.align	2
.L1547:
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
	.word	.LC44
	.word	.LC45
	.word	.LANCHOR23
.L1525:
	ldr	r3, .L1549
	ldrh	r1, [r3]
	ldr	r3, [r8]
	muls	r1, r5, r1
	add	r6, r6, r3
	ldr	r3, [sp, #16]
	ldr	r0, [r6, #8]
	sub	r1, r1, fp
	add	r1, r3, r1, lsl #9
	b	.L1545
.L1542:
	ldr	r3, [r8]
	add	r6, r6, r3
	ldrh	r3, [r2]
	ldr	r2, [sp, #16]
	muls	r3, r5, r3
	sub	r3, r3, fp
	add	r3, r2, r3, lsl #9
	b	.L1544
.L1532:
	ldr	r6, .L1549+4
	mov	r4, #256
	ldr	r7, .L1549+8
.L1535:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1533
	ldrh	r2, [r7]
	cmp	r2, r3
	bne	.L1533
	movs	r0, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L1533:
	ldr	r2, .L1549+12
	movs	r3, #128
	movs	r1, #1
	mov	r0, r1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1549+16
	strh	r3, [r2]	@ movhi
	bl	rk_ftl_garbage_collect
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	ldrh	r3, [r5]
	cmp	r3, #2
	bhi	.L1534
	subs	r4, r4, #1
	bne	.L1535
	b	.L1534
.L1536:
	mov	r0, #-1
	b	.L1502
.L1550:
	.align	2
.L1549:
	.word	.LANCHOR12
	.word	.LANCHOR145
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
	ldr	r8, .L1582+144
	sub	sp, sp, #24
	ldr	r7, .L1582
	ldr	r3, [r8]
	ldr	r4, .L1582+4
	ldr	fp, .L1582+148
	ldrh	r2, [r7]
	ldr	r5, .L1582+8
	str	r3, [r4, #8]
	ldr	r6, .L1582+12
	ldr	r3, [fp]
	lsls	r2, r2, #1
	ldr	r0, [r5]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r5, [sp, #16]
	cmp	r0, r3
	bne	.L1553
.L1564:
	mov	r0, #-1
.L1552:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1553:
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	ldrsh	r10, [r6]
	sxth	r5, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L1555:
	cmp	r5, #0
	bge	.L1561
	movw	r2, #1465
	ldr	r1, .L1582+16
	ldr	r0, .L1582+20
	bl	printf
	b	.L1560
.L1561:
	orr	r3, r5, r10, lsl #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L1582+4
	str	r3, [r4, #4]
	ldr	r3, [r8]
	str	r3, [r4, #8]
	bl	FlashReadPages
	ldr	r3, [r4, #12]
	ldr	r3, [r3, #12]
	str	r3, [sp, #20]
	cbz	r3, .L1556
	ldr	r2, [r4]
	adds	r2, r2, #1
	beq	.L1556
	ldr	r2, .L1582+24
	ldr	r0, [r4, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	beq	.L1556
	str	r0, [sp, #8]
	mov	r2, r10
	str	r3, [sp, #4]
	ldrh	r3, [r6, #4]
	ldr	r1, .L1582+16
	ldr	r0, .L1582+28
	str	r3, [sp]
	mov	r3, r5
	bl	printf
	cbnz	r5, .L1557
	ldrh	r3, [r6, #4]
	cmp	r10, r3
	beq	.L1557
	sxth	r10, r3
	ldr	r3, .L1582+32
	ldrh	r5, [r3]
.L1559:
	subs	r5, r5, #1
	sxth	r5, r5
	b	.L1555
.L1557:
	mov	r3, #-1
	str	r3, [r4]
.L1556:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1559
	ldr	r3, [r8]
	ldr	r2, .L1582+36
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1559
	ldr	r3, [fp]
	ldrh	r2, [r3]
	movw	r3, #61604
	cmp	r2, r3
	bne	.L1559
.L1560:
	ldr	r2, .L1582+24
	ldrh	r3, [r7]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L1563
	movw	r2, #1467
	ldr	r1, .L1582+16
	ldr	r0, .L1582+20
	bl	printf
.L1563:
	ldr	r5, .L1582+40
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
	ldr	r3, .L1582+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r2, [r5]
	ldr	r3, .L1582+36
	cmp	r2, r3
	bne	.L1564
	ldr	r3, .L1582+48
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r5, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L1564
	ldr	r3, .L1582+52
	ldr	r2, .L1582+56
	str	r5, [r3]
	ldr	r3, .L1582+60
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L1582+64
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L1582+68
	str	r3, [r2]
	ldr	r3, .L1582+72
	ldr	r6, [r3]
	ldr	r3, .L1582+76
	ldrh	r0, [r3, #6]
	ldr	r3, .L1582+80
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L1582+84
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L1565
	movw	r2, #1489
	ldr	r1, .L1582+16
	ldr	r0, .L1582+20
	bl	printf
.L1565:
	ldrh	r2, [r4, #16]
	ldr	r3, .L1582+88
	ldrh	ip, [r4, #14]
	ldr	r7, .L1582+92
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L1582+96
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
	ldr	r2, .L1582+100
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L1582+104
	str	r3, [r5]
	ldr	r5, .L1582+108
	str	r3, [r5]
	ldr	r5, .L1582+112
	str	r3, [r5]
	ldr	r5, .L1582+116
	str	r3, [r5]
	ldr	r5, .L1582+120
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L1582+124
	str	r3, [r5]
	ldr	r5, .L1582+128
	str	r3, [r5]
	ldr	r5, .L1582+132
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L1582+136
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L1582+140
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L1568
	ldr	r0, .L1582+88
	bl	make_superblock
.L1568:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1569
	ldr	r0, .L1582+96
	bl	make_superblock
.L1569:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1570
	ldr	r0, .L1582+100
	bl	make_superblock
.L1570:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1571
	ldr	r0, .L1582+92
	bl	make_superblock
.L1571:
	movs	r0, #0
	b	.L1552
.L1583:
	.align	2
.L1582:
	.word	.LANCHOR5
	.word	.LANCHOR138
	.word	.LANCHOR42
	.word	.LANCHOR139
	.word	.LANCHOR178
	.word	.LC1
	.word	.LANCHOR23
	.word	.LC46
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
	.word	.LANCHOR145
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
	ldr	r6, .L1625
	str	r3, [sp, #24]
	ldrh	r3, [r0, #6]
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	ldr	r0, [sp, #8]
	str	r3, [sp, #16]
	ldr	r3, [sp, #12]
	lsls	r2, r3, #2
	bl	ftl_memset
	ldr	r3, .L1625+4
	str	r7, [r4, #32]
	str	r7, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #20]
	str	r2, [r6, #8]
	ldr	r2, .L1625+8
	ldr	fp, [r2]
	movw	r2, #65535
	str	fp, [r6, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L1585:
	ldr	r3, [sp, #16]
	sxth	r5, r7
	cmp	r5, r3
	bge	.L1604
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r5, r3
	bne	.L1586
	movs	r1, #1
	ldrh	r0, [r8, r5, lsl #1]
	bl	FtlGetLastWrittenPage
	sxth	r3, r0
	ldr	r6, .L1625
	add	r10, r8, r5, lsl #1
	strh	r7, [r4]	@ movhi
	str	r3, [sp, #16]
	movs	r7, #0
	ldr	r3, [sp, #24]
	adds	r0, r0, #1
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r4, #28]
.L1587:
	ldr	r3, [sp, #16]
	sxth	r8, r7
	cmp	r8, r3
	ble	.L1590
.L1604:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L1625+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1592
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1592:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1590:
	ldrh	r2, [r10]
	ldr	r0, .L1625
	orr	r2, r8, r2, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #20]
	cbz	r2, .L1588
	ldr	r1, [r6]
	adds	r1, r1, #1
	beq	.L1588
	ldr	r3, .L1625+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	ldr	r2, [sp, #20]
	cmp	r2, r0
	beq	.L1588
	str	r0, [sp, #4]
	mov	r3, r8
	str	r2, [sp]
	mov	r2, r5
	ldr	r1, .L1625+20
	ldr	r0, .L1625+24
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1588:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1589
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1589
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1589:
	adds	r7, r7, #1
	b	.L1587
.L1586:
	ldr	r3, [sp, #20]
	ldr	r10, .L1625+12
	ldrh	r2, [r8, r5, lsl #1]
	ldr	r3, [r3]
	ldr	r0, .L1625
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
	beq	.L1606
	ldrh	r2, [fp]
	ldrh	r3, [r4, #4]
	cmp	r2, r3
	bne	.L1606
	ldrh	r2, [fp, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L1594
.L1606:
	mov	r10, #0
.L1595:
	ldr	r2, .L1625+12
	sxth	r3, r10
	ldrh	r2, [r2]
	cmp	r3, r2
	bge	.L1602
	ldr	r2, [sp, #28]
	ldr	r0, .L1625
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
	cbz	r2, .L1599
	ldr	r1, [r6]
	adds	r1, r1, #1
	beq	.L1599
	ldr	r1, .L1625+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #32]
	cmp	r2, r0
	beq	.L1599
	str	r0, [sp, #4]
	str	r2, [sp]
	mov	r2, r5
	ldr	r3, [sp, #36]
	ldr	r1, .L1625+20
	ldr	r0, .L1625+28
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1599:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1600
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1600
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1600:
	add	r10, r10, #1
	b	.L1595
.L1594:
	ldr	r3, [sp, #20]
	movs	r1, #0
	ldrh	r2, [r10]
	ldr	r0, [r3]
	add	lr, r2, #-1
.L1596:
	sxth	r3, r1
	cmp	r3, lr
	blt	.L1598
.L1602:
	adds	r7, r7, #1
	b	.L1585
.L1598:
	lsls	r5, r3, #3
	ldr	r3, [r0, r3, lsl #3]
	ldr	r2, [sp, #12]
	uxth	ip, r3
	cmp	r2, ip
	bls	.L1597
	add	r5, r5, r0
	ldr	r2, [sp, #8]
	ldr	r5, [r5, #4]
	str	r5, [r2, ip, lsl #2]
.L1597:
	adds	r1, r1, #1
	b	.L1596
.L1626:
	.align	2
.L1625:
	.word	.LANCHOR138
	.word	.LANCHOR106
	.word	.LANCHOR114
	.word	.LANCHOR20
	.word	.LANCHOR23
	.word	.LANCHOR180
	.word	.LC47
	.word	.LC48
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
	ldr	r3, .L1628
	ldr	r0, .L1628+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L1628+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L1628+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L1628+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L1628+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L1628+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L1628+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1629:
	.align	2
.L1628:
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
	ldr	r0, .L1631
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1632:
	.align	2
.L1631:
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
	ldr	r4, .L1646
	strh	r3, [r4]	@ movhi
	ldr	r3, .L1646+4
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1646+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1634
.L1636:
	mov	r6, #-1
.L1633:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L1634:
	bl	FtlLoadSysInfo
	mov	r6, r0
	cmp	r0, #0
	bne	.L1636
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1646+12
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L1646+16
	ldr	r2, [r3]
	mov	r3, r6
.L1637:
	cmp	r3, r1
	bge	.L1642
	mla	r5, r0, r3, r2
	ldr	r5, [r5, #4]
	cmp	r5, #0
	bge	.L1638
.L1642:
	ldr	r0, .L1646+20
	cmp	r3, r1
	ldr	r2, [r0]
	add	r2, r2, #32
	str	r2, [r0]
	bge	.L1644
.L1639:
	ldr	r5, .L1646+24
	ldr	r4, .L1646+28
	mov	r0, r5
	bl	FtlSuperblockPowerLostFix
	mov	r0, r4
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1646+32
	ldrh	r1, [r5]
	ldrh	r0, [r5, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L1646+36
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
	ldr	r2, .L1646+40
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1645:
	bl	FtlVpcTblFlush
	b	.L1633
.L1638:
	adds	r3, r3, #1
	b	.L1637
.L1644:
	ldrh	r3, [r4]
	cmp	r3, #0
	bne	.L1639
	bl	l2p_flush
	b	.L1645
.L1647:
	.align	2
.L1646:
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
	ldr	r2, .L1672
	ldr	r6, .L1672+4
	str	r3, [r2]
	ldr	r5, .L1672+8
	ldr	r2, .L1672+12
	ldrh	r0, [r6]
	str	r3, [r5]
	str	r3, [r2]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1649
	bl	FtlMakeBbt
.L1649:
	ldr	r3, .L1672+16
	ldr	r2, .L1672+20
	ldr	ip, .L1672+104
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L1672+24
	str	r3, [sp, #4]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L1650:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L1651
	ldr	r3, .L1672+28
	movs	r7, #0
	ldr	r10, .L1672+108
	ldrh	r4, [r3]
	mov	r8, r3
	mov	fp, r10
.L1652:
	ldrh	r3, [r10]
	cmp	r3, r4
	bhi	.L1653
	ldr	r4, .L1672+32
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L1654
.L1658:
	movs	r6, #0
	mov	r7, r6
.L1655:
	ldrh	r3, [r8]
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bhi	.L1659
	ldrh	r2, [fp]
	ldr	r3, .L1672+36
	ldrh	r4, [r4]
	ldr	r6, .L1672+40
	str	r2, [r3]
	ldr	r3, .L1672+44
	mov	r1, r4
	ldr	r2, [r3]
	mov	r0, r2
	str	r2, [sp, #12]
	bl	__aeabi_uidiv
	ubfx	r10, r0, #5, #16
	mov	r3, r0
	str	r0, [r6]
	add	r1, r10, #36
	ldr	r0, .L1672+48
	strh	r1, [r0]	@ movhi
	movs	r1, #24
	muls	r1, r4, r1
	str	r0, [sp]
	cmp	r7, r1
	ble	.L1660
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
.L1660:
	ldr	r2, .L1672+52
	ldrh	r2, [r2]
	cbz	r2, .L1662
	ldr	r1, .L1672+48
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
.L1662:
	ldr	r3, [sp]
	ldr	r7, .L1672+56
	ldr	r10, .L1672+112
	ldrh	r2, [r3]
	ldr	r3, [r6]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L1672+60
	ldrh	r3, [r3]
	str	r4, [r7]
	muls	r4, r3, r4
	ldr	r3, [sp, #4]
	ldrh	r3, [r3]
	str	r4, [r6]
	ldr	r6, .L1672+64
	muls	r4, r3, r4
	ldr	r3, .L1672+68
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [fp]
	movs	r1, #0
	ldr	r0, [r10]
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L1672+72
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r6, #6]
	str	r3, [r2]
	ldr	r2, .L1672+76
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
	ldr	r3, .L1672+80
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L1664:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	cmp	r3, #0
	bne	.L1665
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r6]
	adds	r3, r3, #1
	strh	r3, [r6]	@ movhi
	b	.L1664
.L1651:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L1650
.L1653:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L1652
.L1654:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L1672+84
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L1656:
	ldrh	r3, [fp]
	cmp	r3, r6
	bls	.L1658
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L1656
.L1659:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r7, r7, r0
	uxth	r7, r7
	b	.L1655
.L1665:
	ldr	r3, [r5]
	ldrh	r1, [r6, #4]
	ldr	r4, .L1672+88
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
.L1666:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L1667
	ldr	r3, [r8]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L1666
.L1667:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1672+92
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1672+96
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
	cbnz	r0, .L1668
	ldr	r3, .L1672+100
	movs	r2, #1
	str	r2, [r3]
.L1668:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1673:
	.align	2
.L1672:
	.word	.LANCHOR83
	.word	.LANCHOR4
	.word	.LANCHOR82
	.word	.LANCHOR143
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
	.word	.LANCHOR145
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
	ldr	r4, .L1686
	movs	r6, #0
	ldr	r1, .L1686+4
	ldr	r0, .L1686+8
	str	r3, [r4]
	bl	printf
	ldr	r0, .L1686+12
	bl	FtlConstantsInit
	ldr	r5, .L1686+16
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1686+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
.L1675:
	bl	FtlLoadBbt
	cbz	r0, .L1676
.L1685:
	ldr	r3, [r5]
	cmp	r3, #1
	bne	.L1675
	str	r6, [r5]
	bl	ftl_low_format
	b	.L1675
.L1676:
	bl	FtlSysBlkInit
	cmp	r0, #0
	bne	.L1685
	movs	r3, #1
	str	r3, [r4]
	pop	{r4, r5, r6, pc}
.L1687:
	.align	2
.L1686:
	.word	.LANCHOR166
	.word	.LC49
	.word	.LC38
	.word	.LANCHOR0
	.word	.LANCHOR181
	.word	.LANCHOR4
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
	ldr	r5, .L1758
	bls	.L1689
	cmp	r0, #576
	bcc	.L1690
.L1689:
	ldr	r3, [r5]
	cbnz	r3, .L1691
.L1757:
	movs	r4, #0
	b	.L1688
.L1691:
	ldr	r3, .L1758+4
	ldr	r3, [r3]
	ldr	r2, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1758+8
	cmp	r2, r3
	bne	.L1693
	ldr	r3, .L1758+12
	movs	r2, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [sp, #12]
	add	r0, r3, #262144
	movw	r3, #65535
.L1697:
	ldr	r4, [r0, #-4]
	cbnz	r4, .L1694
	ldr	r4, [sp, #12]
	subs	r3, r3, #1
	ldr	r4, [r4, r2, lsl #2]
	adds	r2, r2, #1
	cmp	r2, #4096
	it	hi
	movhi	r2, #0
	cmp	r3, #4096
	str	r4, [r0, #-4]!
	bne	.L1697
	mov	r3, #512
	b	.L1754
.L1694:
	adds	r3, r3, #127
	lsrs	r3, r3, #7
.L1754:
	str	r3, [sp, #16]
	lsls	r1, r1, #2
	ldr	r3, [sp, #16]
	uxth	r1, r1
	ldr	r4, .L1758+16
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
.L1719:
	ldr	r3, .L1758+20
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	memset
	ldr	r3, .L1758+12
	ldrh	r6, [r3, #10]
	ldr	r3, [r4, #16]
	mul	fp, r10, r6
	cmp	r3, #0
	beq	.L1727
	ldr	r3, [r4, #20]
	cmp	r3, #0
	ite	eq
	moveq	r3, #6
	movne	r3, #9
.L1755:
	str	r3, [sp, #28]
	mov	r1, fp
	ldr	r3, .L1758+16
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
	ldr	r3, [sp, #24]
	cmp	r3, #1
	beq	.L1699
	ldr	r3, .L1758+16
	add	r1, r6, fp
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
.L1699:
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1729
	ldr	r3, .L1758+20
	mov	r2, #1024
	movs	r1, #0
	ldr	r5, [r3]
	mov	r0, r5
	bl	ftl_memset
	movs	r2, #4
	ldr	r3, .L1758+24
	strb	r2, [r5, #17]
	movs	r1, #12
	ldr	r2, .L1758+12
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
.L1700:
	ldr	r3, [sp, #24]
	mov	r8, fp
	muls	r3, r6, r3
	movs	r6, #0
	str	r3, [sp, #40]
	ldr	r3, [sp, #12]
	str	r3, [sp, #32]
.L1701:
	ldr	r3, [sp, #40]
	cmp	r6, r3
	beq	.L1708
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
	bne	.L1704
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1704
	ldr	r3, [r4, #16]
	movs	r0, #70
	blx	r3
	add	r3, sp, #48
	mov	r2, r5
	mov	r1, fp
	mov	r0, r6
	ldr	r7, [r4, #8]
	blx	r7
	ldr	r2, .L1758+12
	str	r0, [sp, #44]
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r2, [sp, #44]
	adds	r2, r2, #1
	bne	.L1705
.L1708:
	ldr	r3, .L1758+20
	ldr	r2, [r4, #16]
	ldr	r6, [r3]
	ldr	r3, .L1758+12
	ldrb	r3, [r3, #14]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L1758+12
	ldrh	r3, [r3, #10]
	mul	r8, r10, r3
	cmp	r2, #0
	bne	.L1706
	mov	fp, #6
.L1707:
	ldr	r2, [sp, #24]
	movs	r5, #0
	muls	r3, r2, r3
	str	r3, [sp, #32]
.L1710:
	ldr	r3, [sp, #32]
	cmp	r5, r3
	beq	.L1714
	cmp	r5, #0
	bne	.L1711
	cmp	fp, #9
	bne	.L1711
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
	ldr	r2, .L1758+12
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r3, [r6]
	ldr	r2, .L1758+24
	cmp	r3, r2
	beq	.L1712
.L1714:
	ldr	r3, .L1758+20
	movs	r5, #0
	ldr	r1, [sp, #12]
	ldr	r0, [r3]
.L1713:
	mov	r8, r1
	ldr	r2, [r0, r5, lsl #2]
	ldr	r3, [r8]
	lsls	r6, r5, #2
	adds	r1, r1, #4
	cmp	r2, r3
	beq	.L1716
	mov	r2, #512
	movs	r1, #0
	bl	memset
	ldr	r3, .L1758+20
	mov	r1, r10
	ldr	r0, .L1758+28
	ldr	r2, [r3]
	str	r5, [sp]
	ldr	r3, [r8]
	ldr	r2, [r2, r6]
	bl	printf
	ldr	r3, .L1758+12
	movs	r0, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [r4, #4]
	mul	r1, r10, r1
	blx	r3
.L1717:
	ldr	r3, [sp, #24]
	add	r10, r10, r3
	cmp	r10, #15
	bls	.L1719
	ldr	r3, [sp, #20]
	cbnz	r3, .L1720
.L1693:
	mov	r3, #-1
	str	r3, [sp, #16]
.L1720:
	ldr	r3, .L1758
	movs	r2, #0
	ldr	r4, [sp, #16]
	str	r2, [r3]
	ldr	r3, .L1758+4
	ldr	r0, [r3]
	bl	free
	ldr	r3, .L1758+20
	ldr	r0, [r3]
	bl	free
.L1688:
	mov	r0, r4
	add	sp, sp, #112
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1727:
	movs	r3, #6
	b	.L1755
.L1729:
	movs	r5, #0
	b	.L1700
.L1704:
	add	r3, sp, #48
	ldr	r2, [sp, #32]
	mov	r1, r8
	movs	r0, #0
	ldr	r7, [r4, #8]
	blx	r7
	adds	r0, r0, #1
	beq	.L1708
	ldr	r3, [sp, #32]
	add	r3, r3, #2048
	str	r3, [sp, #32]
.L1705:
	adds	r6, r6, #1
	add	r8, r8, #1
	b	.L1701
.L1706:
	ldr	r2, [r4, #20]
	cmp	r2, #0
	ite	eq
	moveq	fp, #6
	movne	fp, #9
	b	.L1707
.L1711:
	add	r3, sp, #48
	mov	r2, r6
	add	r1, r8, r5
	movs	r0, #0
	ldr	r7, [r4, #12]
	blx	r7
	adds	r0, r0, #1
	beq	.L1714
	ldr	r2, [sp, #52]
	movw	r3, #61424
	cmp	r2, r3
	bne	.L1714
	add	r6, r6, #2048
.L1712:
	adds	r5, r5, #1
	b	.L1710
.L1759:
	.align	2
.L1758:
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	-52655045
	.word	.LANCHOR0
	.word	.LANCHOR78
	.word	.LANCHOR184
	.word	1179535694
	.word	.LC50
.L1716:
	ldr	r3, [sp, #36]
	adds	r5, r5, #1
	cmp	r5, r3
	bne	.L1713
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #20]
	bls	.L1717
	b	.L1720
.L1690:
	cmp	r0, #64
	bne	.L1721
	ldr	fp, .L1760+4
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [fp]
	mov	r0, #262144
	bl	ftl_malloc
	ldr	r3, .L1760
	str	r0, [r3]
	ldr	r3, [fp]
	cbz	r3, .L1722
	cbz	r0, .L1722
	movs	r2, #1
	movs	r1, #0
	str	r2, [r5]
	mov	r0, r3
	mov	r2, #262144
	bl	ftl_memset
.L1721:
	ldr	r3, [r5]
	cmp	r3, #0
	beq	.L1757
	ldr	r3, .L1760+4
	cmp	r4, #63
	iteee	hi
	ldrhi	r5, .L1760+8
	rsbls	r4, r4, #64
	subls	r6, r6, r4
	addls	r7, r7, r4, lsl #9
	ldr	r1, [r3]
	mov	r2, #262144
	it	hi
	addhi	r5, r5, r4
	ldr	r0, .L1760+12
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
	b	.L1757
.L1722:
	ldr	r1, .L1760+16
	ldr	r0, .L1760+20
	bl	printf
	b	.L1721
.L1761:
	.align	2
.L1760:
	.word	.LANCHOR184
	.word	.LANCHOR183
	.word	8388544
	.word	.LC52
	.word	.LANCHOR185
	.word	.LC51
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
	.set	.LANCHOR145,. + 0
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
	.set	.LANCHOR44,. + 0
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
	.set	.LANCHOR143,. + 0
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
	.set	.LANCHOR43,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR47,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR46,. + 0
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
.LC14:
	.ascii	"prog read error: = %x\012\000"
.LC15:
	.ascii	"prog read REFRESH: = %x\012\000"
.LC16:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC17:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FlashReadPages.str1.1,"aMS",%progbits,1
.LC11:
	.ascii	"FlashReadPages %x %x error_ecc_bits %d\012\000"
.LC12:
	.ascii	"data:\000"
.LC13:
	.ascii	"spare:\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC19:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC20:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC9:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC35:
	.ascii	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC37:
	.ascii	"no ect\000"
.LC38:
	.ascii	"%s\012\000"
	.section	.rodata.FtlLoadSysInfo.str1.1,"aMS",%progbits,1
.LC46:
	.ascii	"%s hash error this.id =%x page =%x pre_id =%x hash "
	.ascii	"=%x hash_r =%x\012\000"
	.section	.rodata.FtlMapTblRecovery.str1.1,"aMS",%progbits,1
.LC47:
	.ascii	"%s last blk_id =%x page =%x hash error hash =%x has"
	.ascii	"h_r =%x\012\000"
.LC48:
	.ascii	"%s scan blk_id =%x page =%x hash error hash =%x has"
	.ascii	"h_r =%x\012\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC22:
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC23:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"FtlProgPages error %x = %d\012\000"
.LC41:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC27:
	.ascii	"data prev_ppa = %x error...................\012\000"
.LC28:
	.ascii	"spuer block %x vpn is 0\012 \000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"FtlWrite: ecc error:%x %x %x\012\000"
.LC45:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.FtlWriteToIDB.str1.1,"aMS",%progbits,1
.LC50:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC51:
	.ascii	"%s idb buffer alloc fail\012\000"
.LC52:
	.ascii	"%p %x %p %x\012\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.__func__.10006,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.10006, %object
	.size	__func__.10006, 23
__func__.10006:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.__func__.10278,"a",%progbits
	.set	.LANCHOR137,. + 0
	.type	__func__.10278, %object
	.size	__func__.10278, 15
__func__.10278:
	.ascii	"FlashReadPages\000"
	.section	.rodata.__func__.10297,"a",%progbits
	.set	.LANCHOR142,. + 0
	.type	__func__.10297, %object
	.size	__func__.10297, 15
__func__.10297:
	.ascii	"FlashProgPages\000"
	.section	.rodata.__func__.10321,"a",%progbits
	.set	.LANCHOR77,. + 0
	.type	__func__.10321, %object
	.size	__func__.10321, 17
__func__.10321:
	.ascii	"FlashEraseBlocks\000"
	.section	.rodata.__func__.10436,"a",%progbits
	.set	.LANCHOR185,. + 0
	.type	__func__.10436, %object
	.size	__func__.10436, 14
__func__.10436:
	.ascii	"FtlWriteToIDB\000"
	.section	.rodata.__func__.8930,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.8930, %object
	.size	__func__.8930, 13
__func__.8930:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.8958,"a",%progbits
	.set	.LANCHOR177,. + 0
	.type	__func__.8958, %object
	.size	__func__.8958, 9
__func__.8958:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.9033,"a",%progbits
	.set	.LANCHOR128,. + 0
	.type	__func__.9033, %object
	.size	__func__.9033, 14
__func__.9033:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.9068,"a",%progbits
	.set	.LANCHOR141,. + 0
	.type	__func__.9068, %object
	.size	__func__.9068, 11
__func__.9068:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.9183,"a",%progbits
	.set	.LANCHOR49,. + 0
	.type	__func__.9183, %object
	.size	__func__.9183, 17
__func__.9183:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.9188,"a",%progbits
	.set	.LANCHOR45,. + 0
	.type	__func__.9188, %object
	.size	__func__.9188, 17
__func__.9188:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.9219,"a",%progbits
	.set	.LANCHOR50,. + 0
	.type	__func__.9219, %object
	.size	__func__.9219, 17
__func__.9219:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.9251,"a",%progbits
	.set	.LANCHOR54,. + 0
	.type	__func__.9251, %object
	.size	__func__.9251, 22
__func__.9251:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.9260,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.9260, %object
	.size	__func__.9260, 16
__func__.9260:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.9293,"a",%progbits
	.set	.LANCHOR81,. + 0
	.type	__func__.9293, %object
	.size	__func__.9293, 26
__func__.9293:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.9304,"a",%progbits
	.set	.LANCHOR151,. + 0
	.type	__func__.9304, %object
	.size	__func__.9304, 15
__func__.9304:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.9319,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.9319, %object
	.size	__func__.9319, 31
__func__.9319:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.9333,"a",%progbits
	.set	.LANCHOR149,. + 0
	.type	__func__.9333, %object
	.size	__func__.9333, 16
__func__.9333:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.9358,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.9358, %object
	.size	__func__.9358, 22
__func__.9358:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.9375,"a",%progbits
	.set	.LANCHOR153,. + 0
	.type	__func__.9375, %object
	.size	__func__.9375, 9
__func__.9375:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.9439,"a",%progbits
	.set	.LANCHOR165,. + 0
	.type	__func__.9439, %object
	.size	__func__.9439, 15
__func__.9439:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.9461,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.9461, %object
	.size	__func__.9461, 14
__func__.9461:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.9517,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.9517, %object
	.size	__func__.9517, 15
__func__.9517:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.9539,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.9539, %object
	.size	__func__.9539, 18
__func__.9539:
	.ascii	"FtlMapTblRecovery\000"
	.section	.rodata.__func__.9585,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.9585, %object
	.size	__func__.9585, 16
__func__.9585:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.9619,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.9619, %object
	.size	__func__.9619, 22
__func__.9619:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.9676,"a",%progbits
	.set	.LANCHOR60,. + 0
	.type	__func__.9676, %object
	.size	__func__.9676, 16
__func__.9676:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.9697,"a",%progbits
	.set	.LANCHOR136,. + 0
	.type	__func__.9697, %object
	.size	__func__.9697, 18
__func__.9697:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.9724,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.9724, %object
	.size	__func__.9724, 14
__func__.9724:
	.ascii	"ftl_check_vpc\000"
	.section	.rodata.__func__.9789,"a",%progbits
	.set	.LANCHOR144,. + 0
	.type	__func__.9789, %object
	.size	__func__.9789, 25
__func__.9789:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.9810,"a",%progbits
	.set	.LANCHOR168,. + 0
	.type	__func__.9810, %object
	.size	__func__.9810, 29
__func__.9810:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.9817,"a",%progbits
	.set	.LANCHOR61,. + 0
	.type	__func__.9817, %object
	.size	__func__.9817, 19
__func__.9817:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.9830,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.9830, %object
	.size	__func__.9830, 16
__func__.9830:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.9837,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.9837, %object
	.size	__func__.9837, 20
__func__.9837:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.9907,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.9907, %object
	.size	__func__.9907, 19
__func__.9907:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC21:
	.ascii	"decrement_vpc_count %x = %d\012\000"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",%progbits,1
.LC29:
	.ascii	"...%s enter...\012\000"
.LC30:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC31:
	.ascii	"free blk vpc error %x = %x  %x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC10:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",%progbits,1
.LC32:
	.ascii	"ftl_scan_all_data = %x\012\000"
.LC33:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC34:
	.ascii	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC24:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC25:
	.ascii	"map_ppn:\000"
.LC26:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"g_gc_superblock_free %x %x %x %x %x\012\000"
.LC43:
	.ascii	"lpa=%x, ppa=%x\012\000"
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
.LC49:
	.ascii	"SFTL version: 5.0.50 20190215\000"
	.hidden	free
