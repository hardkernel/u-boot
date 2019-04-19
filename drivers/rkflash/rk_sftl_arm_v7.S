/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2019-04-19
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
	ldr	r2, .L26
	ldrh	r5, [r0, #2]
	ldrh	r7, [r3, #14]
	strh	r4, [r2]	@ movhi
	ldr	r2, .L26+4
	ldrh	ip, [r0, #4]
	cmp	r7, #4
	ldr	r0, .L26+8
	strh	r5, [r2]	@ movhi
	ldr	r1, .L26+12
	ldrh	r2, [r3, #6]
	ldr	r6, .L26+16
	strh	ip, [r0]	@ movhi
	strh	r2, [r1]	@ movhi
	strh	r7, [r6]	@ movhi
	bne	.L16
	lsrs	r2, r2, #1
	strh	r2, [r1]	@ movhi
	movs	r2, #8
	strh	r2, [r6]	@ movhi
.L17:
	ldr	r7, .L26+20
	movs	r2, #0
.L18:
	strb	r2, [r2, r7]
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L18
	ldr	r2, .L26+24
	cmp	r4, #1
	mov	r7, #5
	ldrh	r0, [r0]
	mov	ip, #0
	str	r3, [sp, #4]
	strh	r7, [r2]	@ movhi
	it	eq
	strheq	r4, [r2]	@ movhi
	mov	r4, #640
	ldr	r2, .L26+28
	smulbb	r5, r5, r0
	ldr	r7, .L26+32
	strh	r4, [r2]	@ movhi
	uxth	r5, r5
	ldrh	r4, [r1]
	ldr	r2, .L26+36
	strh	ip, [r7]	@ movhi
	ldr	r7, .L26+40
	smulbb	r0, r0, r4
	strh	r5, [r2]	@ movhi
	ldr	r2, .L26+44
	uxth	r0, r0
	strh	r0, [r2]	@ movhi
	bl	Ftl_log2
	ldr	r3, [sp, #4]
	ldr	r2, .L26+48
	ldrh	fp, [r6]
	ldrh	r8, [r3, #12]
	strh	r0, [r2]	@ movhi
	ldr	r2, .L26+52
	mov	r0, fp
	strh	r8, [r7]	@ movhi
	smulbb	r1, r5, r8
	ldr	r6, .L26+56
	strh	r8, [r2]	@ movhi
	ldr	r2, .L26+60
	strh	r1, [r2]	@ movhi
	bl	Ftl_log2
	lsl	r2, fp, #9
	ldr	r1, .L26+64
	ldr	r3, [sp, #4]
	mov	r10, r0
	uxth	r2, r2
	strh	r0, [r6]	@ movhi
	mov	r0, #5120
	strh	r2, [r1]	@ movhi
	lsrs	r2, r2, #8
	ldr	r1, .L26+68
	strh	r2, [r1]	@ movhi
	mul	r1, r8, fp
	ldrh	r2, [r3, #20]
	ldr	r3, .L26+72
	strh	r2, [r3]	@ movhi
	mul	r3, r4, r5
	ldr	r2, .L26+76
	lsls	r4, r4, #6
	str	r3, [r2]
	mul	r3, fp, r3
	ldr	r2, .L26+80
	mul	r3, r8, r3
	ldr	r8, .L26+116
	asrs	r3, r3, #11
	str	r3, [r2]
	bl	__aeabi_idiv
	uxth	r0, r0
	ldr	r2, .L26+84
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
	ldr	r10, .L26+120
	adds	r3, r3, #2
	ldrh	r0, [r8]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L26+88
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r5, r4
	adds	r4, r4, #8
	str	r3, [r10]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L26+92
	cmp	r5, #1
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #0
	ldr	r3, .L26+96
	str	r2, [r3]
	ldr	r3, .L26+100
	ldr	r2, [r3]
	ldrh	r3, [r7]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r6]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L26+104
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L26+108
	strh	r2, [r3]	@ movhi
	ldr	r3, .L26+112
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
.L16:
	cmp	r7, #8
	bne	.L17
	cmp	ip, #1
	itttt	eq
	lsreq	r2, r2, #1
	strheq	r2, [r1]	@ movhi
	moveq	r2, #2
	strheq	r2, [r0]	@ movhi
	b	.L17
.L27:
	.align	2
.L26:
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
	.word	.LANCHOR19
	.word	.LANCHOR17
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
	ldr	r3, .L35
	ldrh	r3, [r3]
	cbz	r3, .L34
	ldr	r3, .L35+4
	ldr	r2, .L35+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L30:
	cmp	r3, r2
	bne	.L31
.L34:
	movs	r0, #0
	bx	lr
.L31:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L30
	movs	r0, #1
	bx	lr
.L36:
	.align	2
.L35:
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
	ldr	r3, .L39
	ldr	r0, [r3]
	bx	lr
.L40:
	.align	2
.L39:
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
	ldr	r3, .L42
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L42+4
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
	ldr	r0, .L42+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L43:
	.align	2
.L42:
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
	ldr	r3, .L45
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L45+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L46:
	.align	2
.L45:
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
	ldr	r3, .L49
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L49+4
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
.L50:
	.align	2
.L49:
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
	ldr	r3, .L52
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L52+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L53:
	.align	2
.L52:
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
	ldr	r3, .L55
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L55+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L56:
	.align	2
.L55:
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
	bls	.L58
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L58:
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
	ldr	r3, .L61
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L62:
	.align	2
.L61:
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
	ldr	r3, .L64
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L65:
	.align	2
.L64:
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
	ldr	r3, .L75
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L66
	ldr	r2, .L75+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L68:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L69
	cbz	r5, .L66
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L66:
	pop	{r4, r5, r6, pc}
.L69:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L68
.L76:
	.align	2
.L75:
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
	ldr	r3, .L83
	push	{r4, r5, lr}
	ldrh	r4, [r3, #6]
	cmp	r4, #1024
	beq	.L81
	ldrh	r5, [r3, #2]
	movs	r1, #0
.L79:
	cmp	r1, r4
	bcc	.L80
.L81:
	movs	r0, #0
	pop	{r4, r5, pc}
.L80:
	adds	r2, r1, r5
	ubfx	r2, r2, #0, #10
	adds	r2, r2, #4
	ldrh	r2, [r3, r2, lsl #1]
	cmp	r2, r0
	beq	.L82
	adds	r1, r1, #1
	b	.L79
.L82:
	movs	r0, #1
	pop	{r4, r5, pc}
.L84:
	.align	2
.L83:
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
	ldr	r3, .L100
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldrh	r8, [r3]
	cmp	r8, r0
	bls	.L87
	ldr	r3, .L100+4
	movs	r5, #6
	muls	r5, r0, r5
	ldr	r4, [r3]
	movw	r3, #65535
	adds	r1, r4, r5
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r5]	@ movhi
	ldr	r3, .L100+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L88
.L99:
	str	r1, [r3]
.L87:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L88:
	ldr	r3, .L100+12
	ldrh	r6, [r1, #4]
	ldr	r10, [r3]
	ldrh	r3, [r10, r0, lsl #1]
	cbz	r6, .L95
	muls	r6, r3, r6
.L89:
	sub	r2, ip, r4
	movs	r7, #0
	asrs	r3, r2, #1
	ldr	r2, .L100+16
	muls	r2, r3, r2
	mov	r3, ip
	uxth	r2, r2
.L93:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r8, r7
	bcc	.L87
	cmp	r2, r0
	beq	.L87
	ldrh	lr, [r3, #4]
	cmp	lr, #0
	beq	.L91
	ldrh	fp, [r10, r2, lsl #1]
	mul	lr, lr, fp
	cmp	r6, lr
	bls	.L91
	ldrh	lr, [r3]
	movw	fp, #65535
	cmp	lr, fp
	bne	.L92
	strh	r2, [r1, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	ldr	r3, .L100+20
	b	.L99
.L95:
	mov	r6, #-1
	b	.L89
.L92:
	movs	r3, #6
	mov	r2, lr
	mla	r3, r3, lr, r4
	b	.L93
.L91:
	strh	r2, [r4, r5]	@ movhi
	cmp	r3, ip
	ldrh	r2, [r3, #2]
	strh	r2, [r1, #2]	@ movhi
	bne	.L94
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L100+8
	b	.L99
.L94:
	ldrh	r1, [r3, #2]
	movs	r2, #6
	muls	r2, r1, r2
	strh	r0, [r4, r2]	@ movhi
	strh	r0, [r3, #2]	@ movhi
	b	.L87
.L101:
	.align	2
.L100:
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
	ldr	r3, .L212
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L207
	movw	r2, #2148
	ldr	r1, .L212+4
	ldr	r0, .L212+8
	bl	printf
.L207:
	ldr	r3, .L212+12
	add	r6, r4, #16
	ldr	r10, .L212+24
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L208:
	uxth	r3, r5
	ldrh	r1, [r4]
	cmp	r8, r3
	bhi	.L210
	ldr	r2, .L212+16
	movs	r0, #0
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L212+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	movw	r3, #10000
	cmp	r2, r3
	itt	hi
	movhi	r3, #1
	strbhi	r3, [r4, #9]
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L210:
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
.L213:
	.align	2
.L212:
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
	ldr	r3, .L220
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L220+12
	ldrh	r7, [r3]
	ldr	r3, .L220+4
	ldrh	r8, [r3]
.L215:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L217
	cbz	r4, .L219
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L218:
	ldr	r3, .L220+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L217:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L216
	add	r4, r4, r8
	uxth	r4, r4
.L216:
	adds	r5, r5, #1
	b	.L215
.L219:
	mov	r0, r4
	b	.L218
.L221:
	.align	2
.L220:
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
	ldr	r3, .L225
	ldr	r0, [r3]
	cbz	r0, .L223
	ldr	r3, .L225+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L225+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L225+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L223:
	bx	lr
.L226:
	.align	2
.L225:
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
	ldr	r3, .L235
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L233
	ldr	r2, .L235+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L235+8
	ldr	r1, [r2]
	ldr	r2, .L235+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L230:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L232
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L234
.L232:
	ldr	r2, .L235+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L234:
	mov	r3, r4
	b	.L230
.L233:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L236:
	.align	2
.L235:
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
	beq	.L238
	ldr	r2, .L239
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L238:
	movs	r0, #0
	pop	{r3, pc}
.L240:
	.align	2
.L239:
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
	bne	.L242
	movw	r2, #2781
	ldr	r1, .L256
	ldr	r0, .L256+4
	bl	printf
.L242:
	ldr	r6, .L256+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bne	.L243
	movw	r2, #2782
	ldr	r1, .L256
	ldr	r0, .L256+4
	bl	printf
.L243:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L244
	movw	r2, #2783
	ldr	r1, .L256
	ldr	r0, .L256+4
	bl	printf
.L244:
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	movs	r3, #0
	strb	r3, [r4, #10]
	movw	r5, #65535
	adds	r2, r2, #8
	ldrh	r0, [r4, r2, lsl #1]
	ldr	r2, .L256+12
	ldrh	r1, [r2]
	mov	r2, r3
.L245:
	cmp	r0, r5
	beq	.L247
	ldrh	r5, [r4, #2]
	ldrh	r6, [r6]
	cmp	r5, r6
	bcs	.L251
	ldrh	r2, [r4, #4]
	orr	r5, r5, r0, lsl #10
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r0, #65535
	subs	r2, r2, #1
	uxth	r2, r2
	strh	r2, [r4, #4]	@ movhi
.L250:
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
	beq	.L250
	strb	r3, [r4, #6]
	ldrh	r3, [r4, #2]
	cmp	r3, r6
	bne	.L241
	cbz	r2, .L241
	movw	r2, #2806
	ldr	r1, .L256
	ldr	r0, .L256+4
	bl	printf
.L241:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, pc}
.L247:
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
	b	.L245
.L251:
	movw	r5, #65535
	b	.L241
.L257:
	.align	2
.L256:
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
	ldr	r1, .L263
	mov	fp, #1
	ldr	r2, .L263+4
	ldr	r5, [r1]
	ldr	r1, .L263+8
	str	r3, [r2]
	ldr	r2, .L263+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L263+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L263+20
	ldr	r10, [r1]
	ldr	r1, .L263+24
	ldrh	r7, [r1]
	ldr	r1, .L263+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L259:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #20
	add	lr, r1, r6
	bne	.L260
	ldr	r3, .L263+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L263+8
	ldr	r4, [r3]
	ldr	r3, .L263+20
	ldr	ip, [r3]
.L261:
	cmp	r2, r0
	bcc	.L262
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L260:
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
	b	.L259
.L262:
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
	b	.L261
.L264:
	.align	2
.L263:
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
	ldr	r3, .L272
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #20
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L272+4
	ldr	r5, [r3]
.L266:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L265
	mla	r8, fp, r3, r0
	movs	r2, #0
.L267:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L268
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L267
	str	lr, [r10, #8]
.L268:
	adds	r4, r4, #1
	b	.L266
.L265:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L273:
	.align	2
.L272:
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
	ldr	r3, .L281
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #20
	ldr	r4, [r3]
	ldr	r3, .L281+4
	ldr	r5, [r3]
.L275:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L279
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L279:
	mov	r10, #0
.L276:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L277
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L276
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L277:
	adds	r2, r2, #1
	b	.L275
.L282:
	.align	2
.L281:
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
	ldr	r3, .L288
	ldr	r2, .L288+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L284:
	cmp	r3, r2
	bne	.L286
	movs	r0, #0
	bx	lr
.L286:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L284
	movs	r0, #1
	bx	lr
.L289:
	.align	2
.L288:
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
	ldr	r4, .L294
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L294+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L291:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L293
	bne	.L292
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L292
.L293:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L291
.L292:
	ldr	r2, .L294+8
	movs	r0, #12
	ldr	r1, .L294+12
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
.L295:
	.align	2
.L294:
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
	ldr	r4, .L299
	ldrh	r5, [r4]
	cmp	r5, r0
	beq	.L297
	ldr	r3, .L299+4
	ldrh	r1, [r3]
	cmp	r0, r1
	beq	.L297
	movw	r2, #65535
	cmp	r5, r2
	bne	.L298
	strh	r0, [r4]	@ movhi
.L297:
	movs	r0, #0
	pop	{r4, r5, pc}
.L298:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3]	@ movhi
	b	.L297
.L300:
	.align	2
.L299:
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
	ldr	r2, .L305
	movs	r1, #0
	ldr	r5, .L305+4
	ldrh	r3, [r2]
.L302:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L304
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L305+4
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L303
.L304:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L302
.L303:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L306:
	.align	2
.L305:
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
	ldr	r3, .L313
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L308
	ldr	r2, .L313+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L308
	ldr	r4, .L313+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L313+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L308:
	movs	r0, #0
	pop	{r4, pc}
.L314:
	.align	2
.L313:
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
.L318:
	cmp	r4, r10
	bcc	.L324
	ldr	r0, .L327
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L324:
	cbnz	r5, .L319
	mov	r2, r6
	mov	r1, fp
	ldr	r0, .L327+4
	bl	printf
.L319:
	cmp	r8, #4
	bne	.L320
	ldr	r1, [r7, r4, lsl #2]
.L326:
	ldr	r0, .L327+8
.L325:
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L323
	movs	r5, #0
	ldr	r0, .L327
	bl	printf
.L323:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L318
.L320:
	cmp	r8, #2
	bne	.L322
	ldrh	r1, [r7, r4, lsl #1]
	b	.L326
.L322:
	ldrb	r1, [r7, r4]	@ zero_extendqisi2
	ldr	r0, .L327+12
	b	.L325
.L328:
	.align	2
.L327:
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
	ldr	r6, .L345
	add	r8, r0, #4
	movs	r7, #0
	ldr	fp, .L345+20
	ldrh	r10, [r6, #12]
	str	r2, [sp]
	lsl	r3, r10, #3
	str	r3, [sp, #4]
.L330:
	ldr	r3, [sp]
	cmp	r7, r3
	beq	.L344
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r8]
	bl	l2p_addr_tran.isra.0
	ldr	r5, [sp, #8]
	cbnz	r5, .L331
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bls	.L331
	ldr	r6, .L345+4
	ldr	r7, .L345+8
.L332:
	ldr	r3, [sp]
	adds	r4, r4, #20
	cmp	r5, r3
	bne	.L333
.L344:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L333:
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
	ldr	r0, .L345+12
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L345+16
	bl	rknand_print_hex
	b	.L332
.L331:
	ldr	r2, [fp, #4]
	uxtb	r0, r5
	ldr	r1, [sp, #12]
	blx	r2
	cbnz	r0, .L334
	str	r0, [r8, #-4]
.L335:
	ldrh	r2, [r6, #14]
	cmp	r2, #4
	bne	.L337
	ldr	r1, [sp, #12]
	ldr	r2, [fp, #4]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	add	r1, r1, r10
	blx	r2
	cbz	r0, .L337
	mov	r2, #-1
	str	r2, [r8, #-4]
.L337:
	adds	r7, r7, #1
	add	r8, r8, #20
	b	.L330
.L334:
	mov	r2, #-1
	str	r2, [r8, #-4]
	b	.L335
.L346:
	.align	2
.L345:
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
	bhi	.L347
	ldr	r4, .L356
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L347
	cbz	r1, .L349
	bl	P2V_block_in_plane
	ldr	r3, .L356+4
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L356+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L356+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L349:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L347:
	pop	{r4, r5, r6, pc}
.L357:
	.align	2
.L356:
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
	ldr	r4, .L363
	ldrh	r2, [r4, #6]
	cbz	r2, .L362
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
	ldr	r3, .L363+4
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r2, .L363+8
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L359:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L360
	ldrh	r2, [r4, #6]
	mov	r1, r5
	ldr	r0, .L363+12
	bl	printf
.L361:
	b	.L361
.L362:
	movw	r5, #65535
	b	.L359
.L360:
	mov	r0, r5
	pop	{r3, r4, r5, pc}
.L364:
	.align	2
.L363:
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
.L366:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L369
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L366
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L367
	ldr	r3, .L373
	ldr	r0, .L373+4
	ldrh	r2, [r3, #6]
	bl	printf
.L368:
	b	.L368
.L367:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L369:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L371
	movw	r2, #578
	ldr	r1, .L373+8
	ldr	r0, .L373+12
	bl	printf
.L371:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L374:
	.align	2
.L373:
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
	ldr	r3, .L381
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L381+4
	movs	r6, #12
	str	r4, [r3]
	ldr	r3, .L381+8
	ldr	r5, .L381+12
	ldr	r10, .L381+292
	str	r4, [r3]
	ldr	r3, .L381+16
	ldrh	r0, [r5]
	ldr	r8, .L381+296
	str	r4, [r3]
	ldr	r3, .L381+20
	lsls	r0, r0, #1
	ldr	fp, .L381+300
	str	r4, [r3]
	ldr	r3, .L381+24
	str	r4, [r3]
	ldr	r3, .L381+28
	str	r4, [r3]
	ldr	r3, .L381+32
	str	r4, [r3]
	ldr	r3, .L381+36
	str	r4, [r3]
	ldr	r3, .L381+40
	str	r4, [r3]
	ldr	r3, .L381+44
	str	r4, [r3]
	ldr	r3, .L381+48
	str	r4, [r3]
	ldr	r3, .L381+52
	str	r4, [r3]
	ldr	r3, .L381+56
	str	r4, [r3]
	ldr	r3, .L381+60
	str	r4, [r3]
	ldr	r3, .L381+64
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L381+68
	str	r4, [r2]
	ldr	r2, .L381+72
	str	r4, [r2]
	ldr	r2, .L381+76
	str	r4, [r2]
	ldr	r2, .L381+80
	strh	r3, [r2]	@ movhi
	ldr	r2, .L381+84
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L381+88
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L381+92
	strh	r2, [r3]	@ movhi
	ldr	r3, .L381+96
	strh	r4, [r3]	@ movhi
	ldr	r3, .L381+100
	strh	r4, [r3]	@ movhi
	ldr	r3, .L381+104
	strh	r4, [r3]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L381+108
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #20
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L381+112
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L381+116
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+120
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L381+124
	ldr	r7, .L381+128
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+132
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+136
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L381+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+144
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+148
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L381+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+160
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L381+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+172
	str	r0, [r3]
	ldr	r3, .L381+176
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L381+180
	ldrh	r5, [r10]
	ldr	r10, .L381+304
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L381+184
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L381+188
	bl	ftl_malloc
	ldr	r3, .L381+192
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L381+308
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L381+196
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L381+200
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L381+204
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L381+208
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L381+212
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L381+216
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L381+220
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L381+224
	ldr	r8, .L381+312
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L381+228
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L381+232
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L381+236
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L381+316
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L381+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L381+244
	ldr	r4, .L381+248
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L381+252
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L381+256
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L381+260
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L381+264
	bl	ftl_malloc
	ldr	r3, .L381+268
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L381+272
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L381+276
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L381+280
	str	r0, [r3]
	ldr	r3, .L381+284
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
	ldr	r3, .L381+288
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	mov	r0, r1
	b	.L382
.L383:
	.align	2
.L381:
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
.L382:
.L377:
	cmp	r2, r6
	bcc	.L378
	add	r3, r3, r2, lsl #2
	ldr	r2, .L384
	movs	r1, #0
	adds	r3, r3, #24
.L379:
	cmp	r3, r2
	bne	.L380
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L378:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L377
.L380:
	str	r1, [r3, #4]!
	b	.L379
.L385:
	.align	2
.L384:
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
	ldr	r3, .L392
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L392+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L392+12
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L389:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L386
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L388
	movs	r2, #74
	mov	r1, r8
	ldr	r0, .L392+8
	bl	printf
.L388:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L389
.L386:
	pop	{r4, r5, r6, r7, r8, pc}
.L393:
	.align	2
.L392:
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
	ldr	r0, .L395
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L396:
	.align	2
.L395:
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
	ldr	r3, .L398
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
.L399:
	.align	2
.L398:
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
.L401:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L405
	ldr	r3, .L420
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L406:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L410
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L405:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L402:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L404
	adds	r3, r3, #1
	b	.L401
.L404:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L403
	cbz	r1, .L403
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L403:
	adds	r2, r2, #1
	b	.L402
.L410:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L407
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L408
.L409:
	adds	r6, r6, #1
	b	.L406
.L407:
	cmp	r3, #0
	bne	.L409
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L409
.L411:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L409
.L408:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L411
	b	.L409
.L421:
	.align	2
.L420:
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
	ldr	r5, .L425
	ldr	r4, .L425+4
	ldr	r2, [r5]
	ldr	r7, .L425+8
	ldr	r6, .L425+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L425+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L425+16
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
.L423:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L424
	ldr	r3, .L425+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L425+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L425+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L425+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L425+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L425+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L424:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L423
.L426:
	.align	2
.L425:
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
	ldr	r3, .L428
	movs	r4, #0
	mov	r1, r4
	ldr	r5, .L428+4
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L428+8
	str	r4, [r3]
	ldr	r3, .L428+12
	str	r4, [r3]
	ldr	r3, .L428+16
	str	r2, [r3]
	ldr	r3, .L428+20
	strh	r4, [r3]	@ movhi
	ldr	r3, .L428+24
	ldrh	r2, [r3]
	ldr	r3, .L428+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L428+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L428+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L428+40
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L428+44
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L429:
	.align	2
.L428:
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
	ldr	r3, .L441
	movs	r1, #0
	movs	r4, #0
	ldr	r6, .L441+4
	mov	r8, r4
	ldrh	r3, [r3]
	mov	r5, r4
	ldr	r0, [r6]
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L441+8
	ldr	r2, .L441+12
	str	r4, [r3]
	ldr	r3, .L441+16
	strh	r4, [r2]	@ movhi
	str	r2, [sp, #4]
	str	r4, [r3]
	ldr	r3, .L441+20
	str	r4, [r3]
	ldr	r3, .L441+24
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L431:
	ldr	r3, .L441+28
	uxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bcs	.L438
	ldr	r3, .L441+32
	ldrh	r2, [r3]
	ldr	r3, .L441+36
	ldrh	r3, [r3]
	str	r3, [sp]
	movs	r3, #0
	mov	r6, r3
	b	.L439
.L433:
	str	r2, [sp, #12]
	mov	r1, r7
	ldr	r2, .L441+40
	str	r3, [sp, #8]
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	cbnz	r0, .L432
	ldr	r1, [sp]
	add	r6, r6, r1
	uxth	r6, r6
.L432:
	adds	r3, r3, #1
.L439:
	uxth	r1, r3
	cmp	r2, r1
	bhi	.L433
	uxth	r3, r4
	cbz	r6, .L434
	mov	r1, r6
	str	r3, [sp]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp]
	uxth	r6, r0
.L435:
	ldr	r1, [r10]
	movs	r2, #6
	mla	r2, r2, r3, r1
	strh	r6, [r2, #4]	@ movhi
	ldr	r2, .L441+44
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L436
	ldr	r2, .L441+48
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L436
	ldr	r2, .L441+52
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L436
	ldr	r2, .L441+56
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cbnz	r3, .L437
	add	r8, r8, #1
	mov	r0, r7
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L436:
	adds	r4, r4, #1
	b	.L431
.L434:
	ldr	r2, .L441+56
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r3, lsl #1]	@ movhi
	b	.L435
.L437:
	adds	r5, r5, #1
	mov	r0, r7
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L436
.L438:
	ldr	r2, [sp, #4]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r5, r3
	ble	.L440
	movw	r2, #2210
	ldr	r1, .L441+60
	ldr	r0, .L441+64
	bl	printf
.L440:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L442:
	.align	2
.L441:
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
	ldr	r2, .L444
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L444+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L444+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L444+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L444+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L445:
	.align	2
.L444:
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
	ldr	r3, .L453
	mov	r1, r5
	mov	r0, r4
	ldr	r3, [r3]
	blx	r3
	uxth	r0, r0
	cmp	r0, #50
	bls	.L447
	mov	r2, #256
	movs	r1, #255
	mov	r0, r4
	bl	ftl_memset
	movs	r0, #0
.L447:
	ldr	r3, .L453+4
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L452
	add	r1, r4, r0, lsl #1
	mov	r3, r4
.L449:
	cmp	r3, r1
	bne	.L450
.L452:
	pop	{r3, r4, r5, pc}
.L450:
	ldrh	r2, [r3]
	lsrs	r2, r2, #1
	strh	r2, [r3], #2	@ movhi
	b	.L449
.L454:
	.align	2
.L453:
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
	ldr	r3, .L496
	mov	r4, r0
	mov	r10, #0
	ldrh	r2, [r3, #12]
	str	r3, [sp, #4]
	str	r2, [sp]
.L457:
	cmp	r10, fp
	bne	.L471
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L471:
	ldr	r3, [r4, #8]
	cbz	r3, .L458
	ldr	r3, [r4, #12]
	cbnz	r3, .L459
.L458:
	movs	r2, #90
	ldr	r1, .L496+4
	ldr	r0, .L496+8
	bl	printf
.L459:
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r4, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r0, [sp, #8]
	cmp	r0, #3
	bls	.L460
	mov	r3, #-1
	str	r3, [r4]
.L461:
	add	r10, r10, #1
	adds	r4, r4, #20
	b	.L457
.L460:
	ldr	r5, [r4, #8]
	uxtb	r0, r0
	ldr	r8, .L496+32
	ldr	r7, .L496+12
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
	bne	.L464
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
	beq	.L465
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #12]
	adds	r2, r2, #1
	bne	.L466
	ldr	r2, [r3, #8]
	adds	r2, r2, #1
	bne	.L466
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L466
.L465:
	mov	r3, #-1
	str	r3, [r4]
.L466:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L467
	cmp	r0, #256
	it	eq
	streq	r0, [r4]
.L467:
	ldr	r3, [r4]
	adds	r2, r3, #1
	beq	.L468
	cmp	r3, #256
	bne	.L464
.L468:
	ldr	r1, [r4, #4]
	ldr	r2, [sp, #12]
	ldr	r0, .L496+16
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L470
	movs	r3, #4
	ldr	r0, .L496+20
	mov	r2, r3
	bl	rknand_print_hex
.L470:
	ldr	r1, [r4, #12]
	cbz	r1, .L464
	movs	r3, #4
	ldr	r0, .L496+24
	mov	r2, r3
	bl	rknand_print_hex
.L464:
	ldr	r3, [r8]
	cmp	r5, r3
	bne	.L461
	ldr	r0, [r4, #8]
	cmp	r5, r0
	beq	.L461
	ldr	r3, .L496+28
	mov	r1, r5
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
	b	.L461
.L497:
	.align	2
.L496:
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
	ldr	r3, .L508
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L508+4
	ldr	r3, [r3]
	ldr	r7, .L508+8
	ldr	r10, .L508+20
	str	r3, [r5, #8]
	ldr	r3, .L508+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L499:
	ldr	r3, .L508+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L504
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L504:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L508+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L500:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L502
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L501
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L501
	strh	r4, [r7]	@ movhi
.L502:
	adds	r6, r6, #1
	b	.L499
.L501:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L500
.L509:
	.align	2
.L508:
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
	ldreq	r3, .L522
	sub	sp, sp, #88
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L522+4
	mov	r6, r1
	add	r0, sp, #4
	movs	r1, #1
	ldrh	r5, [r3]
	ldr	r3, .L522+8
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
	bne	.L513
	mov	r8, #0
.L514:
	cmp	r8, r5
	ble	.L517
.L513:
	mov	r0, r5
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L517:
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
	bne	.L515
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	bne	.L515
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L515
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L514
.L515:
	adds	r4, r4, #1
	sxth	r8, r4
	b	.L514
.L523:
	.align	2
.L522:
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
	ldr	r5, .L605
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L605+4
	ldr	r2, [r5]
	ldr	r6, .L605+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L605+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L605+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L605+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L605+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L605+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #16
	movs	r1, #255
	ldr	r0, .L605+32
	bl	ftl_memset
	ldr	r3, .L605+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L525:
	ldr	r3, .L605+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L566
	ldr	r3, .L605+44
	movs	r5, #0
	ldr	r1, .L605+48
	mov	fp, r5
	movs	r7, #20
	ldrh	r8, [r3]
	ldr	r3, .L605+52
	ldr	r2, [r1]
	ldr	r1, .L605+56
	ldr	r6, [r3]
	ldr	r3, .L605+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L605+64
	b	.L567
.L527:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L526
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
.L526:
	adds	r5, r5, #1
.L567:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L527
	cmp	fp, #0
	bne	.L528
.L565:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L525
.L528:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L529:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L565
	ldr	r3, .L605+52
	mov	r8, #20
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L532
	mov	r10, #16
.L534:
	ldr	r3, .L605+52
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
	ldr	r3, .L605+52
	ldr	r3, [r3]
	bne	.L531
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L605+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	bne	.L532
.L533:
	movs	r1, #1
	b	.L604
.L531:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L532
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L534
	b	.L533
.L532:
	ldr	r3, .L605+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L535
	cmp	r2, r3
	bhi	.L536
.L535:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L605+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L536:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L538
	bhi	.L539
	movw	r3, #61574
	cmp	r2, r3
	beq	.L540
.L537:
	adds	r7, r7, #1
	b	.L529
.L539:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L541
	movw	r3, #65535
	cmp	r2, r3
	bne	.L537
	movs	r1, #0
.L604:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L537
.L541:
	ldr	r3, .L605+8
	ldrh	r2, [r3]
	ldr	r3, .L605
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L543
	movw	r2, #1225
	ldr	r1, .L605+72
	ldr	r0, .L605+76
	bl	printf
.L543:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L605+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L544:
	cmp	r3, r10
	bgt	.L550
	cmp	r3, #0
	bge	.L582
	b	.L537
.L550:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L545
	ldr	r2, [ip]
	cbnz	r2, .L546
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L605+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L546:
	ldr	r2, .L605+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L547:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L548
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L537
	ldr	r2, .L605+8
	ldrh	r0, [r2]
	ldr	r2, .L605
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L537
.L582:
	ldr	r2, .L605+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L605+20
.L602:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L537
.L548:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L547
.L545:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L544
.L606:
	.align	2
.L605:
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
.L540:
	ldr	r8, .L607+12
	ldr	r10, .L607+20
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L553
	movw	r2, #1266
	ldr	r1, .L607
	ldr	r0, .L607+4
	bl	printf
.L553:
	ldr	r2, .L607+8
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L554:
	cmp	r3, r10
	ble	.L559
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L555
	ldr	r2, [r0]
	cbnz	r2, .L556
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L607+12
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L556:
	ldr	r2, .L607+16
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L557:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L558
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L559:
	cmp	r3, #0
	blt	.L537
	ldr	r2, .L607+20
	ldr	ip, .L607+12
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L537
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L607+16
	b	.L602
.L558:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L557
.L555:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L554
.L538:
	ldr	r8, .L607+40
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L561
.L603:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L537
.L561:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L562
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L562:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L563
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L603
.L563:
	strh	r5, [r8, #4]	@ movhi
	b	.L537
.L566:
	ldr	r3, .L607+24
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L568
.L571:
	ldr	r3, .L607+16
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L569
.L570:
	ldr	r3, .L607+28
	ldrh	r2, [r3]
	ldr	r3, .L607+32
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L601
	movw	r2, #1391
	ldr	r1, .L607
	ldr	r0, .L607+4
	bl	printf
.L601:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L568:
	ldr	r1, .L607+28
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L571
	ldr	r5, .L607+32
	ldr	r0, [r5]
.L572:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L571
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L572
	ldr	r3, .L607+36
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L573:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L571
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L573
.L569:
	ldr	r3, .L607+12
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L570
	ldr	r5, .L607+20
	ldrh	r1, [r5]
.L578:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L570
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L578
	ldr	r2, .L607+8
	movs	r0, #0
	ldr	r2, [r2]
.L579:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L570
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L579
.L608:
	.align	2
.L607:
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
	ldr	r8, .L638+40
	ldr	r4, .L638
	ldr	r3, [r8]
	ldr	r7, .L638+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L638+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L610:
	ldrh	r3, [r7]
	subs	r3, r3, #15
	cmp	r3, r5
	bgt	.L613
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L611
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L611:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L612
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L612
	ldr	r3, .L638+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L613:
	ldr	r5, .L638+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L627
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L617
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L638
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L617
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L617
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L617
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L617:
	ldr	r10, .L638
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L619:
	cmp	r7, #0
	bge	.L622
	movs	r2, #251
	ldr	r1, .L638+16
	ldr	r0, .L638+20
	bl	printf
.L621:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L624
	ldr	r3, .L638+24
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L624
	ldr	r3, .L638+28
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L624
	cmp	r0, r3
	bcs	.L624
	bl	FtlSysBlkNumInit
.L624:
	ldr	r6, .L638+32
	movs	r5, #0
	ldr	r7, .L638+36
	ldr	r8, .L638+44
.L625:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L626
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L612:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L610
.L622:
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
	beq	.L620
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L621
.L620:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L619
.L626:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L625
.L627:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L639:
	.align	2
.L638:
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
	ldr	r3, .L681
	mov	r8, #0
	ldr	fp, .L681+52
	str	r2, [sp, #8]
	ldrh	r3, [r3, #12]
	str	r3, [sp]
	lsls	r3, r3, #3
	str	r3, [sp, #4]
.L641:
	cmp	r8, r10
	bne	.L654
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L673
	ldr	r6, .L681+4
	movs	r5, #0
.L656:
	cmp	r8, r5
	beq	.L673
	ldr	r7, .L681+8
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
	bne	.L657
	ldr	r1, [r4, #4]
	ldr	r0, .L681+12
	bl	printf
	str	r10, [r4]
.L657:
	ldr	r10, [sp, #28]
	cmp	r10, #256
	bne	.L658
	ldr	r1, [r4, #4]
	ldr	r0, .L681+16
	bl	printf
	str	r10, [r4]
.L658:
	ldr	r3, [r4, #12]
	cbz	r3, .L659
	ldr	r2, [r3]
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L659
	ldr	r1, [r4, #4]
	ldr	r0, .L681+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L659:
	ldr	r3, [r4, #8]
	cbz	r3, .L660
	ldr	r2, [r3]
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L660
	ldr	r1, [r4, #4]
	ldr	r0, .L681+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L660:
	adds	r5, r5, #1
	adds	r4, r4, #20
	b	.L656
.L654:
	ldr	r3, [r5, #8]
	cbz	r3, .L642
	ldr	r3, [r5, #12]
	cbnz	r3, .L643
.L642:
	movs	r2, #142
	ldr	r1, .L681+28
	ldr	r0, .L681+32
	bl	printf
.L643:
	add	r2, sp, #20
	add	r1, sp, #24
	ldr	r0, [r5, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r6, [sp, #20]
	cmp	r6, #3
	bls	.L644
.L680:
	mov	r3, #-1
	str	r3, [r5]
	b	.L645
.L644:
	cbnz	r6, .L646
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #4]
	cmp	r2, r3
	bls	.L646
	ldr	r5, .L681+28
	ldr	r7, .L681+36
	b	.L679
.L648:
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
	ldr	r0, .L681+40
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L681+44
	bl	rknand_print_hex
.L679:
	cmp	r6, r10
	add	r4, r4, #20
	bne	.L648
.L673:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L646:
	ldr	r1, [r5, #8]
	lsls	r3, r1, #26
	beq	.L662
	ldr	r3, .L681+4
	ldr	r6, [r3]
	cmp	r1, r6
	beq	.L649
	ldr	r3, .L681+48
	mov	r0, r6
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
.L649:
	ldr	r3, [r5, #12]
	mov	r2, r6
	ldr	r1, [sp, #24]
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	ldr	r7, [fp, #8]
	blx	r7
	cbnz	r0, .L650
	str	r0, [r5]
.L651:
	ldr	r3, .L681
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L645
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
	bne	.L680
.L645:
	add	r8, r8, #1
	adds	r5, r5, #20
	b	.L641
.L662:
	mov	r6, r1
	b	.L649
.L650:
	mov	r3, #-1
	str	r3, [r5]
	b	.L651
.L682:
	.align	2
.L681:
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
	ldr	r3, .L726
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r7, .L726+4
	mov	r8, #0
	mov	r6, r1
	mov	r5, r8
	str	r0, [r3]
	mov	r4, r8
	ldr	r3, .L726+8
	mov	fp, #20
	ldr	r10, [r7]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L726+12
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L726+16
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L726+20
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L684:
	ldr	r3, [sp, #12]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L688
	cmp	r5, #0
	beq	.L683
	mov	r0, r10
	mov	r8, #0
	mov	r10, #20
	mov	r2, r5
	movs	r1, #0
	bl	FlashEraseBlocks
.L691:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L693
	cmp	r6, #0
	beq	.L709
	ldr	r3, .L726+24
	mov	r10, #1
	ldrh	r3, [r3]
	str	r3, [sp, #8]
.L694:
	movs	r7, #0
.L703:
	ldr	r3, .L726+8
	mov	r8, #0
	mov	r5, r8
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L726+4
	ldr	fp, [r3]
	ldr	r3, .L726+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L726+12
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L726+20
	ldrh	r3, [r3]
	str	r3, [sp, #28]
.L695:
	ldr	r3, [sp, #16]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L698
	cbz	r5, .L683
	mov	r0, fp
	ldr	fp, .L726+4
	movs	r3, #1
	mov	r2, r10
	mov	r1, r5
	mov	r8, #0
	bl	FlashProgPages
	movs	r3, #20
.L700:
	uxth	r2, r8
	cmp	r5, r2
	bhi	.L702
	adds	r7, r7, #1
	ldr	r2, [sp, #8]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L703
	ldr	r8, .L726+4
	movs	r7, #0
	mov	fp, #20
.L704:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L706
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L707
	cbz	r6, .L683
.L707:
	ldr	r3, .L726+4
	mov	r2, r5
	mov	r1, r10
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L683:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L688:
	mul	r2, fp, r8
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r10, r2]
	ldr	r3, .L726+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #8]
	cbz	r6, .L685
	bl	IsBlkInVendorPart
	cbnz	r0, .L686
.L685:
	ldr	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L687
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
.L686:
	add	r8, r8, #1
	b	.L684
.L687:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L686
.L693:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L692
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L692:
	add	r8, r8, #1
	b	.L691
.L709:
	movs	r3, #2
	mov	r10, r6
	str	r3, [sp, #8]
	b	.L694
.L698:
	movs	r3, #20
	ldr	r1, [sp, #4]
	mul	r2, r3, r8
	movs	r3, #0
	str	r3, [fp, r2]
	ldr	r3, .L726+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #12]
	cbz	r6, .L696
	bl	IsBlkInVendorPart
	cbnz	r0, .L697
.L696:
	ldr	r0, [sp, #12]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L697
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
.L697:
	add	r8, r8, #1
	b	.L695
.L702:
	mul	r2, r3, r8
	ldr	r1, [fp]
	adds	r0, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L701
	ldr	r0, [r0, #4]
	adds	r4, r4, #1
	str	r3, [sp, #12]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #12]
.L701:
	add	r8, r8, #1
	b	.L700
.L706:
	cbz	r6, .L705
	mul	r3, fp, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L705
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L705:
	adds	r7, r7, #1
	b	.L704
.L727:
	.align	2
.L726:
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
	bls	.L731
	ldr	r4, .L733
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
	cbnz	r3, .L732
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
.L730:
	movs	r2, #1
	movs	r1, #0
	add	r0, sp, #4
	str	r5, [sp, #8]
	bl	FlashEraseBlocks
.L728:
	mov	r0, r4
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, pc}
.L732:
	mov	r4, #-1
	b	.L730
.L731:
	movs	r4, #0
	b	.L728
.L734:
	.align	2
.L733:
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
	ldr	r7, .L749
	movs	r4, #0
	ldr	r5, .L749+4
	ldr	r3, [r7]
	ldr	fp, .L749+52
	ldr	r6, .L749+8
	str	r3, [r5, #12]
	ldr	r3, .L749+12
	ldr	r0, [fp]
	ldr	r8, .L749+56
	ldrh	r2, [r3]
	str	r0, [r5, #8]
	bl	ftl_memset
	str	r7, [sp, #12]
	ldr	r7, .L749+16
.L736:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L737
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L749+20
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
	ldr	r3, .L749+24
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
	ldr	r3, .L749+28
	ldr	r3, [r3]
	strh	r3, [r6, #14]	@ movhi
.L738:
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
	ldr	r0, .L749+32
	bl	printf
	ldr	r3, .L749+36
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L739
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
	ldr	r2, .L749+40
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L739:
	movs	r3, #1
	ldr	r0, .L749+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r2, r3, #1
	bne	.L740
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L749+44
	bl	printf
	cmp	r7, #3
	bls	.L738
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L749+48
	bl	printf
.L742:
	b	.L742
.L737:
	ldrh	r2, [r8]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L736
.L740:
	add	r8, r8, #1
	cmp	r8, #1
	beq	.L738
	cmp	r3, #256
	beq	.L738
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L750:
	.align	2
.L749:
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
.L752:
	ldr	r3, .L791
	ldr	r8, .L791+68
	ldrh	r3, [r3]
	ldr	r10, .L791+72
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L753
	mov	r2, #2656
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L753:
	ldr	r3, .L791+12
	cmp	r4, r3
	bne	.L779
	ldr	r3, .L791
	ldr	r2, .L791+16
	ldrh	r3, [r3]
	ldr	r2, [r2]
	lsrs	r1, r3, #1
	muls	r2, r3, r2
	adds	r1, r1, #1
	add	r1, r1, r2, lsr #2
	uxth	r1, r1
	cbz	r1, .L754
	subs	r1, r1, #1
	uxth	r1, r1
.L754:
	ldr	r0, .L791+20
	bl	List_pop_index_node
	ldr	r3, .L791
	mov	r5, r0
	uxth	r7, r0
	ldrh	r3, [r3]
	cbnz	r3, .L755
	movw	r2, #2665
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L755:
	ldr	r3, .L791
	ldr	r2, .L791
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r10]
	cmp	r3, r7
	bls	.L752
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L791+24
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L752
	strh	r7, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L757
	ldr	r3, .L791+24
	movw	r2, #65535
	mov	r0, r7
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L791
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L752
	movw	r2, #2679
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
	b	.L752
.L779:
	movs	r1, #0
	b	.L754
.L757:
	ldr	r3, .L791
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L759
	movw	r2, #2682
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L759:
	ldr	r3, .L791+28
	add	lr, r4, #16
	ldr	r2, .L791+32
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #20
	mov	r3, ip
	mla	r0, r2, r0, ip
.L760:
	cmp	r0, r3
	bne	.L762
	cbnz	r6, .L763
	movw	r2, #2693
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L763:
	ldr	r3, .L791+36
	ldrh	r3, [r3]
	cmp	r3, r7
	bne	.L764
	movw	r2, #2695
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L764:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L791+40
	ldr	fp, .L791+76
	ldr	r8, .L791+80
	ldr	r1, [r3]
	cmp	r2, #0
	bne	.L765
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L766
	ldr	r0, .L791+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L789:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r2, [fp]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [fp]
	bl	ftl_set_blk_mode
.L790:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldr	r3, [r3]
	ldrh	r1, [r3, r5, lsl #1]
	ldr	r3, .L791+48
	ldr	r2, [r3]
	cmp	r1, r2
	it	hi
	strhi	r1, [r3]
	ldr	r3, .L791+44
	ldrh	r1, [r10]
	ldrh	r2, [r3]
	ldr	r3, [r8]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L791+52
	ldr	ip, .L791+84
	str	r0, [r3]
	ldr	r3, .L791+56
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r2, #20
	ldr	r3, .L791+28
	ldr	r0, [r3]
	adds	r3, r0, #4
	mla	r2, r2, r6, r0
	adds	r2, r2, #24
.L770:
	adds	r3, r3, #20
	cmp	r2, r3
	bne	.L771
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r8, #0
	bl	FlashEraseBlocks
	mov	r10, r8
	movs	r3, #20
.L772:
	uxth	r2, r8
	cmp	r6, r2
	bhi	.L774
	cmp	r10, #0
	beq	.L775
	mov	r0, r7
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L775:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L776
	ldr	r3, .L791+24
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L752
.L762:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L761
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L761:
	adds	r3, r3, #20
	b	.L760
.L766:
	movs	r2, #2
	b	.L789
.L765:
	ldrh	r2, [r1, r5, lsl #1]
	mov	r0, r7
	str	r3, [sp, #4]
	adds	r2, r2, #1
	strh	r2, [r1, r5, lsl #1]	@ movhi
	ldr	r2, [r8]
	adds	r2, r2, #1
	str	r2, [r8]
	bl	ftl_set_blk_mode.part.6
	b	.L790
.L771:
	ldr	r1, [r3, #-20]
	and	r1, r1, ip
	str	r1, [r3, #-20]
	b	.L770
.L774:
	ldr	r1, .L791+28
	mul	r2, r3, r8
	ldr	r1, [r1]
	ldr	fp, [r1, r2]
	adds	r0, r1, r2
	cmp	fp, #-1
	bne	.L773
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
.L773:
	add	r8, r8, #1
	b	.L772
.L776:
	ldr	r3, .L791+60
	ldr	r1, .L791+64
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
	ldr	r2, .L791+24
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L777
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L778
.L777:
	movw	r2, #2748
	ldr	r1, .L791+4
	ldr	r0, .L791+8
	bl	printf
.L778:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L792:
	.align	2
.L791:
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
	ldr	r4, .L805
	ldrh	r3, [r4]
	cbz	r3, .L794
	ldr	r8, .L805+12
	movs	r7, #0
.L795:
	ldr	r3, .L805+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L801
	bl	FtlGcReFreshBadBlk
.L794:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L801:
	ldr	r2, .L805+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L796:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L800
	adds	r7, r7, #1
	b	.L795
.L800:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L797
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L798:
	cmp	r5, r2
	bcc	.L799
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L797:
	add	fp, fp, #1
	b	.L796
.L799:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L798
.L806:
	.align	2
.L805:
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
	ldr	r3, .L819
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L808
	ldr	r3, .L819+4
	ldrh	r2, [r3]
	cmp	r2, r0
	itt	eq
	movweq	r2, #65535
	strheq	r2, [r3]	@ movhi
	ldr	r3, .L819+8
	ldrh	r2, [r3]
	cmp	r2, r0
	itt	eq
	movweq	r2, #65535
	strheq	r2, [r3]	@ movhi
	ldr	r3, .L819+12
	ldrh	r2, [r3]
	cmp	r2, r0
	bne	.L811
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L812:
	ldr	r5, .L819+16
	mov	r1, r4
	ldr	r0, .L819+20
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L814
	movw	r2, #2824
	ldr	r1, .L819+24
	ldr	r0, .L819+28
	bl	printf
.L814:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L819+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L819+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L818
	movw	r2, #2827
	ldr	r1, .L819+24
	ldr	r0, .L819+28
	bl	printf
.L818:
	movs	r0, #1
	pop	{r3, r4, r5, pc}
.L811:
	ldr	r3, .L819+40
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L817
	ldr	r3, .L819+44
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L817
	ldr	r3, .L819+48
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L812
.L817:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L808:
	bl	List_update_data_list
	b	.L817
.L820:
	.align	2
.L819:
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
	beq	.L822
	ldr	r5, .L830
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L823
	mov	r1, r0
	ldr	r0, .L830+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L824
.L828:
	movs	r5, #0
.L821:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L824:
	movw	r2, #2842
.L829:
	ldr	r1, .L830+8
	ldr	r0, .L830+12
	bl	printf
	b	.L821
.L823:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L822:
	ldr	r6, .L830+16
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L826
	strh	r4, [r6]	@ movhi
	b	.L828
.L826:
	cmp	r4, r0
	beq	.L828
	bl	update_vpc_list
	ldr	r3, .L830+20
	adds	r5, r0, #0
	ldr	r2, .L830+24
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L830+28
	muls	r3, r2, r3
	ldr	r2, .L830
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L821
	cmp	r4, r1
	beq	.L821
	movw	r2, #2858
	b	.L829
.L831:
	.align	2
.L830:
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
	ldr	r2, .L845
	movs	r6, #0
	mov	r4, r0
	str	r3, [sp, #20]
	ldr	r3, .L845+4
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r8, .L845+16
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
.L838:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L834
.L835:
	ldr	r3, .L845+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L845+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L834:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L835
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
	bne	.L838
	b	.L835
.L846:
	.align	2
.L845:
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
	ldr	r7, .L866
	bl	FtlBbtMemInit
	sub	r8, r7, #18
	bl	FtlLoadFactoryBbt
.L848:
	ldr	r3, .L866+4
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L854
	ldr	r5, .L866+8
	movs	r4, #0
.L855:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L856
	ldr	r4, .L866+12
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L857:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L861
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L858
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L859
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L858:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L857
.L854:
	ldr	r3, .L866+16
	ldr	r5, .L866+20
	ldrh	r2, [r8, #2]!
	ldr	r4, .L866+24
	ldr	r0, [r3]
	movw	r3, #65535
	ldr	r10, [r5]
	cmp	r2, r3
	mov	fp, r4
	ldr	r3, .L866+28
	str	r0, [r4, #8]
	str	r10, [r4, #12]
	beq	.L849
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
.L850:
	uxth	r0, r5
	adds	r6, r6, #1
	adds	r7, r7, #4
	bl	FtlBbmMapBadBlock
	b	.L848
.L849:
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
.L851:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r6, r4
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L852
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r4, [r8]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L866+16
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
	ldr	r3, .L866+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	ldr	r0, .L866+24
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L866+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	bne	.L850
	uxth	r0, r5
	bl	FtlBbmMapBadBlock
	b	.L851
.L852:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L851
.L856:
	bl	FtlBbmMapBadBlock
	b	.L855
.L859:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L860
	strh	r5, [r4]	@ movhi
	b	.L858
.L860:
	strh	r5, [r4, #4]	@ movhi
.L861:
	ldr	r3, .L866+36
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
.L867:
	.align	2
.L866:
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
	ldr	r3, .L872
	add	r1, r1, r0
	push	{r4, lr}
.L870:
	cmp	r0, r1
	bne	.L871
	mov	r0, r3
	pop	{r4, pc}
.L871:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L870
.L873:
	.align	2
.L872:
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
	bne	.L875
	ldrh	r3, [r0, #8]
	cbz	r3, .L876
	movw	r2, #641
	ldr	r1, .L884
	ldr	r0, .L884+4
	bl	printf
.L876:
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
.L877:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L875:
	ldrh	r7, [r5, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r6, .L884+8
	ldr	r10, .L884+24
	ldr	r8, [r0, #24]
	orr	r3, r3, r7, lsl #10
	ldr	r0, [r10]
	str	r3, [r6, #4]
	ldr	r3, .L884+12
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
	ldr	r3, .L884+16
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	movs	r3, #0
	ldr	r1, [r10]
	mov	r2, r3
.L878:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L880
	ldr	r3, .L884+20
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r2, #1
	str	r0, [r5, #12]
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L884+8
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L877
.L880:
	ldr	r0, [r8, r3, lsl #2]
	cmp	r7, r0, lsr #10
	bne	.L879
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	lr, r1, r2, lsl #3
	ldr	r0, [r8, r3, lsl #2]
	str	r0, [lr, #4]
.L879:
	adds	r3, r3, #1
	b	.L878
.L885:
	.align	2
.L884:
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
	ldr	r8, .L910+32
	mov	r7, r1
	movs	r6, #0
	str	r2, [sp]
	mov	fp, r8
.L887:
	ldr	r2, .L910
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L888
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L889
.L888:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L889:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L890
	mov	r2, #700
	ldr	r1, .L910+4
	ldr	r0, .L910+8
	bl	printf
.L890:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L891
	movw	r2, #701
	ldr	r1, .L910+4
	ldr	r0, .L910+8
	bl	printf
.L891:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L910+12
	ldrh	r3, [r3, r2, lsl #1]
	ldrh	r2, [r4, #2]
	str	r3, [sp, #4]
	orr	r2, r2, r3, lsl #10
	ldr	r3, [sp]
	str	r2, [r5, #4]
	ldr	r2, .L910+16
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
	ldr	r3, .L910+20
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
	bne	.L892
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L910+24
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L894
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L910+28
	bl	printf
.L895:
	b	.L895
.L894:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L887
.L909:
	b	.L909
.L892:
	cmp	r2, #1
	beq	.L898
	cmp	r1, #256
	beq	.L898
	ldr	r0, [r4, #36]
	cbz	r0, .L899
.L898:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L887
.L899:
	ldr	r2, [r5, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r7, lsl #2]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L911:
	.align	2
.L910:
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
	ldr	r3, .L919
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r10, r1
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, r0
	bcs	.L913
	movw	r2, #485
	ldr	r1, .L919+4
	ldr	r0, .L919+8
	bl	printf
.L913:
	ldr	fp, .L919+48
	movs	r4, #12
	ldr	r7, .L919+12
	ldr	r3, [fp]
	ldr	r8, [r3, r5, lsl #2]
	cmp	r8, #0
	bne	.L914
	mul	r4, r4, r10
	ldr	r2, [r7]
	movs	r1, #255
	adds	r0, r2, r4
	ldr	r2, .L919+16
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r7]
	adds	r1, r2, r4
	strh	r5, [r2, r4]	@ movhi
	str	r8, [r1, #4]
.L915:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L914:
	mul	r4, r4, r10
	ldr	r2, [r7]
	ldr	r6, .L919+20
	add	r2, r2, r4
	mov	r0, r6
	ldr	r2, [r2, #8]
	str	r8, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L919+24
	ldr	r2, [r2]
	str	r2, [r6, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r10, [r6, #12]
	ldrh	r2, [r10, #8]
	cmp	r2, r5
	beq	.L916
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L919+28
	bl	printf
	movs	r3, #4
	ldr	r1, [r6, #12]
	mov	r2, r3
	ldr	r0, .L919+32
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L919+36
	ldrh	r3, [r3]
	bl	rknand_print_hex
.L917:
	ldrh	r3, [r10, #8]
	cmp	r3, r5
	beq	.L918
	mov	r2, #508
	ldr	r1, .L919+4
	ldr	r0, .L919+8
	bl	printf
.L918:
	ldr	r3, [r7]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r5, [r3, r4]	@ movhi
	b	.L915
.L916:
	ldr	r2, [r6]
	cmp	r2, #256
	bne	.L917
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L919+40
	bl	printf
	ldr	r3, [r7]
	mov	r1, r5
	ldr	r0, .L919+44
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L917
.L920:
	.align	2
.L919:
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
	blt	.L922
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L922
	ldr	r3, [r4, #32]
	cbnz	r3, .L922
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L937
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L923
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L923:
	ldr	r5, .L937+4
	movs	r6, #0
.L924:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L931
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L922:
	ldr	r3, .L937
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L932
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L932:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L931:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L925
	ldr	r3, .L937+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L937+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L937+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L926
	movw	r2, #611
	ldr	r1, .L937+16
	ldr	r0, .L937+20
	bl	printf
.L926:
	ldr	r2, [r5]
	adds	r2, r2, #1
	bne	.L927
.L929:
	ldr	r2, [sp, #4]
	movs	r3, #0
	str	r3, [r2]
.L928:
	b	.L928
.L927:
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	bne	.L929
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	bne	.L929
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L925:
	adds	r6, r6, #1
	b	.L924
.L938:
	.align	2
.L937:
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
	ldr	r5, .L940
	muls	r4, r0, r4
	ldr	r0, .L940+4
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
.L941:
	.align	2
.L940:
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
	ldr	r5, .L946
	ldr	r6, .L946+4
.L943:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L945
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L945:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L944
	bl	flush_l2p_region
.L944:
	adds	r4, r4, #1
	b	.L943
.L947:
	.align	2
.L946:
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
	ldr	r4, .L961
	mov	r10, r0
	mov	r5, r1
	ldr	r3, .L961+4
	ldr	r2, [r4]
	ldrh	fp, [r3]
	cmp	r0, r2
	bcc	.L949
	movw	r2, #813
	ldr	r1, .L961+8
	ldr	r0, .L961+12
	bl	printf
.L949:
	ldr	r3, [r4]
	cmp	r10, r3
	bcs	.L950
	ldr	r3, .L961+16
	add	fp, fp, #7
	lsr	r6, r10, fp
	movs	r2, #0
	ldrh	r1, [r3]
	uxth	r6, r6
	ldr	r3, .L961+20
	ldr	r0, [r3]
	mov	r8, r3
	movs	r3, #12
.L951:
	uxth	r4, r2
	cmp	r4, r1
	bcc	.L956
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
	beq	.L957
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L957
	bl	flush_l2p_region
.L957:
	mov	r1, r4
	mov	r0, r6
	bl	load_l2p_region
	b	.L953
.L950:
	mov	r0, #-1
	cbnz	r7, .L948
	str	r0, [r5]
.L948:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L956:
	adds	r2, r2, #1
	mla	ip, r3, r2, r0
	ldrh	ip, [ip, #-12]
	cmp	ip, r6
	bne	.L951
.L953:
	movs	r0, #1
	ldr	r2, [r8]
	lsl	r0, r0, fp
	movs	r3, #12
	subs	r0, r0, #1
	and	r0, r0, r10
	uxth	r0, r0
	mla	r3, r3, r4, r2
	cbnz	r7, .L954
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r0, lsl #2]
	str	r3, [r5]
.L955:
	ldr	r2, [r8]
	movs	r3, #12
	mla	r4, r3, r4, r2
	ldr	r3, [r4, #4]
	adds	r2, r3, #1
	beq	.L959
	adds	r3, r3, #1
	str	r3, [r4, #4]
.L959:
	movs	r0, #0
	b	.L948
.L954:
	ldr	r1, [r5]
	ldr	r2, [r3, #8]
	str	r1, [r2, r0, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L961+24
	strh	r6, [r3]	@ movhi
	b	.L955
.L962:
	.align	2
.L961:
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
	ldr	r5, .L973
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cbnz	r3, .L964
	ldr	r2, .L973+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L965
	ldr	r2, .L973+8
	movw	lr, #65535
	ldr	ip, .L973+24
	ldr	r0, .L973+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L966:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L965
	cmp	r4, r7
	bne	.L967
	mov	r1, r4
	ldr	r0, .L973+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L968
	movw	r2, #1733
	ldr	r1, .L973+16
	ldr	r0, .L973+20
	bl	printf
.L968:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L964:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L965
.L967:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L966
.L965:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L974:
	.align	2
.L973:
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
	beq	.L1107
	ldrh	r3, [r0, #2]
	str	r3, [sp, #4]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #20]
	ldr	r3, .L1116
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L978
	strh	r3, [r0, #4]	@ movhi
.L1114:
	strb	r3, [r8, #6]
.L1107:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L978:
	ldrh	r0, [r0, #16]
.L979:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L980
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L981
	ldr	r3, .L1116+4
	movs	r2, #0
	mov	r5, r2
	movw	fp, #65535
	mov	r10, #20
	ldrh	ip, [r3]
	ldr	r3, .L1116+8
	ldr	r0, [r3]
	ldr	r3, .L1116+12
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1116+16
	ldrh	r7, [r3]
	ldr	r3, .L1116+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1116+24
	ldrh	lr, [r3]
	add	r3, r8, #16
	str	r3, [sp, #16]
	str	r3, [sp]
.L982:
	uxth	r3, r2
	cmp	ip, r3
	bhi	.L986
	movs	r2, #0
	mov	r1, r5
	bl	FlashReadPages
	ldr	r2, .L1116+28
	uxth	r1, r4
	movw	fp, #65535
	str	r1, [sp, #12]
	ldr	r3, [r2]
	subs	r3, r3, #1
	str	r3, [sp]
	ldr	r3, .L1116+8
	ldr	r10, [r3]
	movs	r3, #0
	mov	r7, r10
.L987:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L992
	bne	.L990
	adds	r3, r4, #1
	uxth	r3, r3
	str	r3, [sp, #8]
.L1108:
	ldr	r0, [r10, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldr	r3, .L1116
	mov	r10, r0
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L994
	ldrh	r3, [sp, #8]
	strh	r3, [r8, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r8, #6]
	strh	r3, [r8, #4]	@ movhi
.L994:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	cmp	r3, r2
	bne	.L995
	ldr	r3, [sp, #20]
	cmp	r10, r3
	bne	.L995
	ldr	r1, [sp, #8]
	mov	r2, r10
.L1115:
	mov	r0, r8
	bl	ftl_sb_update_avl_pages
	b	.L1107
.L980:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r8, r1, lsl #1]
	b	.L979
.L981:
	ldr	r3, [sp, #4]
	cbz	r3, .L983
	mov	r2, #1800
	ldr	r1, .L1116+32
	ldr	r0, .L1116+36
	bl	printf
.L983:
	ldr	r3, [sp, #20]
	cbz	r3, .L984
	cmp	r5, r3
	beq	.L984
	movw	r2, #1801
	ldr	r1, .L1116+32
	ldr	r0, .L1116+36
	bl	printf
.L984:
	movs	r3, #0
	strh	r3, [r8, #2]	@ movhi
	b	.L1114
.L986:
	ldr	r1, [sp]
	ldrh	r3, [r1], #2
	cmp	r3, fp
	str	r1, [sp]
	beq	.L985
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
.L985:
	adds	r2, r2, #1
	b	.L982
.L992:
	ldr	r1, [r7]
	cbnz	r1, .L988
	ldr	r1, [r7, #12]
	ldr	r6, [r1, #4]
	str	r1, [sp, #8]
	adds	r1, r6, #1
	beq	.L989
	ldr	r1, [r2]
	mov	r0, r6
	bl	ftl_cmp_data_ver
	cbz	r0, .L989
	adds	r6, r6, #1
	str	r6, [r2]
.L989:
	ldr	r1, [sp, #8]
	ldr	r1, [r1]
	adds	r1, r1, #1
	bne	.L991
.L990:
	uxth	r2, r4
	uxth	r3, r3
	str	r2, [sp, #8]
	movs	r2, #20
	mla	r10, r2, r3, r10
	b	.L1108
.L988:
	ldr	fp, [sp, #12]
.L991:
	adds	r3, r3, #1
	adds	r7, r7, #20
	b	.L987
.L995:
	movw	r3, #65535
	cmp	fp, r3
	bne	.L996
	ldrb	r3, [r8, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L997
.L996:
	ldr	r3, .L1116+40
	uxth	r6, r4
	uxth	r4, r4
	ldr	r7, .L1116+8
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
.L1000:
	cmp	r4, r6
	bhi	.L1010
	ldr	r3, .L1116+4
	movw	lr, #65535
	ldr	r0, [r7]
	mov	ip, #20
	ldrh	fp, [r3]
	ldr	r3, [sp, #16]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r5, r3
	b	.L1011
.L1002:
	ldr	r1, [sp, #12]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #12]
	beq	.L1001
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L1001:
	adds	r3, r3, #1
.L1011:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L1002
	mov	r1, r5
	movs	r2, #0
	bl	FlashReadPages
	ldr	r3, .L1116+40
	movs	r1, #20
	movs	r0, #0
	movw	ip, #65535
	ldr	r2, [r3]
	ldr	r3, [r7]
	mla	r5, r1, r5, r3
.L1003:
	cmp	r5, r3
	bne	.L1008
	cbz	r0, .L1009
	ldr	r3, .L1116+40
	str	r2, [r3]
.L1009:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1000
.L1117:
	.align	2
.L1116:
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
.L1008:
	ldr	r1, [r3]
	cmp	r1, #0
	beq	.L1004
	cbz	r0, .L997
.L1109:
	ldr	r3, .L1118
	str	r2, [r3]
.L997:
	ldr	fp, [sp, #4]
	movs	r2, #1
	ldr	r6, .L1118+4
	ldr	r3, .L1118+8
	strh	r2, [r3]	@ movhi
.L1012:
	ldr	r3, .L1118+12
	movw	lr, #65535
	ldr	r0, [r6]
	movs	r7, #20
	ldr	r1, [sp, #16]
	ldrh	r4, [r3]
	movs	r3, #0
	str	r3, [sp, #12]
.L1013:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L1015
	movs	r2, #0
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1113:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1044
	ldr	r3, .L1118+16
	add	fp, fp, #1
	uxth	fp, fp
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L1012
	ldr	r2, .L1118+12
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r8, #2]	@ movhi
	strh	r3, [r8, #4]	@ movhi
	ldrh	r2, [r2]
.L1045:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L1107
	ldr	r1, [sp, #16]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #16]
	add	r1, r3, #1
	bne	.L1114
	mov	r3, r1
	b	.L1045
.L1004:
	ldr	r1, [r3, #12]
	ldrh	lr, [r1]
	cmp	lr, ip
	beq	.L1007
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	itt	ne
	movne	r2, r1
	movne	r0, #1
.L1007:
	adds	r3, r3, #20
	b	.L1003
.L1010:
	mov	r2, #-1
	b	.L1109
.L1015:
	ldrh	r2, [r1], #2
	cmp	r2, lr
	beq	.L1014
	ldr	r5, [sp, #12]
	orr	r2, fp, r2, lsl #10
	mla	ip, r7, r5, r0
	str	r2, [ip, #4]
	mov	r2, r5
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1014:
	adds	r3, r3, #1
	b	.L1013
.L1044:
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
	bcc	.L1017
	ldr	r3, [sp, #28]
	bne	.L1018
	ldr	r2, [sp, #20]
	cmp	r2, r0
	bhi	.L1017
.L1018:
	ldr	r2, [sp, #8]
	cmp	fp, r2
	bne	.L1019
	cmp	r10, r0
	beq	.L1020
.L1019:
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1021
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1022
	ldrh	r0, [r8]
.L1110:
	bl	decrement_vpc_count
	b	.L1017
.L1022:
	ldr	r2, [r3, #4]
	str	r2, [sp]
	adds	r2, r2, #1
	beq	.L1023
	ldr	r2, .L1118+20
	ldr	r0, [sp]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1023
	ldr	r1, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
.L1023:
	ldr	r4, [r3, #8]
	add	r1, sp, #40
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #36]
	bl	log2phys
	ldr	r3, .L1118
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L1024
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1024
	ldr	r3, [sp, #36]
	adds	r7, r3, #1
	beq	.L1025
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
	bne	.L1026
.L1027:
	mov	r3, #-1
	str	r3, [sp, #36]
.L1034:
	ldr	r7, [sp, #36]
	adds	r0, r7, #1
	beq	.L1017
.L1048:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1118+24
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1040
	movw	r2, #2057
	ldr	r1, .L1118+28
	ldr	r0, .L1118+32
	bl	printf
.L1040:
	ldr	r3, .L1118+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L1041
	mov	r0, r4
	b	.L1110
.L1025:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bne	.L1017
	movs	r2, #1
	add	r1, sp, #36
	mov	r0, r4
	bl	log2phys
.L1017:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1113
.L1026:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L1027
	ldr	r0, .L1118
	ldr	r1, [r7, #4]
	ldr	r0, [r0]
	str	r1, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1027
	ldr	r1, [sp, #40]
	ldr	r0, [sp, #44]
	cmp	r1, r0
	bne	.L1029
.L1032:
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L1027
.L1029:
	ldr	r0, [sp, #36]
	cmp	r1, r0
	beq	.L1027
	adds	r0, r1, #1
	beq	.L1030
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L1031:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1032
	ldr	r3, [r7, #4]
	ldr	r2, .L1118
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1032
	mov	r1, r3
	ldr	r0, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1027
	b	.L1032
.L1030:
	str	r1, [r2, r5]
	b	.L1031
.L1024:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	beq	.L1034
	ldr	r1, [sp, #36]
	adds	r7, r1, #1
	beq	.L1036
	ldr	r3, .L1118+40
	ldr	r3, [r3]
	cmp	r3, r1, lsr #10
	bhi	.L1036
	ldr	r0, .L1118+44
.L1112:
	bl	printf
	b	.L1017
.L1119:
	.align	2
.L1118:
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
.L1036:
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #40]
	adds	r5, r7, #1
	beq	.L1034
	ldr	r3, [sp, #36]
	cmp	r7, r3
	beq	.L1048
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1120
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1039
	ldr	r3, .L1120+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1039
	ldr	r3, .L1120+8
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1034
.L1039:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L1034
	ldr	r1, [r5, #4]
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L1034
	movs	r2, #1
	add	r1, sp, #40
	mov	r0, r4
	bl	log2phys
	b	.L1034
.L1041:
	mov	r1, r4
	ldr	r0, .L1120+12
	b	.L1112
.L1021:
	ldr	r3, .L1120+16
	ldr	r3, [r3]
	cmp	r3, #31
	bhi	.L1042
	ldr	r2, .L1120+20
	str	r4, [r2, r3, lsl #2]
	adds	r3, r3, #1
	ldr	r2, .L1120+16
	str	r3, [r2]
.L1042:
	ldrh	r0, [r8]
	bl	decrement_vpc_count
	ldr	r3, .L1120+24
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L1043
	ldr	r2, [sp]
.L1111:
	str	r2, [r3]
	b	.L1017
.L1043:
	ldr	r1, [sp]
	cmp	r1, r2
	bcs	.L1017
	mov	r2, r1
	b	.L1111
.L1020:
	strb	r10, [r8, #6]
	mov	r2, r10
	strh	fp, [r8, #2]	@ movhi
	mov	r1, fp
	b	.L1115
.L1121:
	.align	2
.L1120:
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
	ldr	r6, .L1146
	ldr	r5, .L1146+4
	ldr	r1, .L1146+8
	ldr	r0, .L1146+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L1146+4
	bl	ftl_memset
.L1123:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L1125
	ldr	r10, .L1146+48
	movs	r4, #0
	ldr	r7, .L1146+16
	mov	r6, r4
.L1126:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L1128
	ldr	r3, .L1146+20
	ldr	r4, [r3]
	cbz	r4, .L1129
	ldr	r3, .L1146+24
	mov	r8, #0
	ldr	r5, .L1146+28
	ldr	r10, .L1146+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L1146+4
	subs	r4, r4, r3
	ldr	r3, .L1146+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L1130:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L1129
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1131
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L1146+36
	bl	printf
.L1131:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L1130
.L1129:
	cbz	r6, .L1122
	movw	r2, #2383
	ldr	r1, .L1146+8
	ldr	r0, .L1146+40
	bl	printf
.L1122:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1125:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1124
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L1124:
	adds	r4, r4, #1
	b	.L1123
.L1128:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L1146+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L1127
	mov	r1, r5
	ldr	r0, .L1146+44
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L1127
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L1127:
	adds	r4, r4, #1
	b	.L1126
.L1147:
	.align	2
.L1146:
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
	ldr	r7, .L1162
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L1162+24
	ldr	r0, .L1162+4
	bl	printf
.L1149:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L1155
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1155:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L1150
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L1150:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L1152
	ldr	r4, .L1162+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L1162+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L1162+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L1153
	adds	r3, r3, #1
	beq	.L1153
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L1152
.L1153:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L1162+20
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
.L1152:
	adds	r5, r5, #1
	b	.L1149
.L1163:
	.align	2
.L1162:
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
	ldr	r3, .L1196
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	mov	r4, r0
	ldrh	r5, [r3]
	str	r3, [sp, #20]
	cmp	r5, r2
	beq	.L1186
	cbnz	r5, .L1165
.L1166:
	bl	FtlGcPageVarInit
	b	.L1167
.L1186:
	movs	r5, #0
.L1165:
	ldr	r3, .L1196+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L1166
.L1167:
	ldr	fp, .L1196+56
.L1183:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1168
.L1185:
	ldr	r3, .L1196+8
	movs	r2, #0
	ldr	r0, [fp]
	mov	r10, r2
	movw	lr, #65535
	mov	r8, #20
	ldrh	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1196+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1196+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1196+20
	ldr	r7, [r3]
	ldr	r3, .L1196+24
	ldrh	ip, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L1169:
	ldr	r1, [sp, #8]
	uxth	r3, r2
	cmp	r1, r3
	bhi	.L1171
	mov	r8, #0
	movs	r2, #0
	mov	r1, r10
	bl	FlashReadPages
.L1172:
	uxth	r3, r8
	cmp	r10, r3
	bhi	.L1184
	ldr	r3, .L1196+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L1185
.L1168:
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
.L1171:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, lr
	str	r1, [sp, #4]
	beq	.L1170
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
.L1170:
	adds	r2, r2, #1
	b	.L1169
.L1184:
	movs	r3, #20
	ldr	r2, [fp]
	mul	r3, r3, r8
	adds	r1, r2, r3
	ldr	r6, [r2, r3]
	ldr	r0, [r1, #4]
	ldr	r7, [r1, #12]
	str	r0, [sp, #4]
	cmp	r6, #0
	bne	.L1173
	ldrh	r1, [r7]
	movw	r2, #65535
	cmp	r1, r2
	beq	.L1194
	ldr	r2, .L1196+28
	ldr	r0, [r7, #8]
	ldr	r2, [r2]
	cmp	r0, r2
	bls	.L1175
.L1194:
	ldr	r3, .L1196+32
	movs	r1, #0
	ldrh	r2, [r4]
	movs	r5, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	ldr	r2, .L1196+36
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	strh	r3, [r2]	@ movhi
	bl	FtlGcPageVarInit
	b	.L1183
.L1175:
	mov	r2, r6
	add	r1, sp, #24
	str	r3, [sp, #8]
	bl	log2phys
	ldr	r2, [r7, #12]
	ldr	r1, [sp, #24]
	ldr	r3, [sp, #8]
	cmp	r2, r1
	beq	.L1177
.L1179:
	ldr	r2, [r7, #8]
.L1195:
	ldr	r1, [sp, #4]
	add	r8, r8, #1
	ldr	r0, [r7, #12]
	bl	FtlGcUpdatePage
	b	.L1172
.L1177:
	str	r3, [sp, #8]
	adds	r3, r2, #1
	beq	.L1179
	str	r2, [sp, #32]
	movs	r1, #1
	ldr	r2, .L1196+40
	add	r0, sp, #28
	ldr	r2, [r2]
	str	r2, [sp, #36]
	ldr	r2, .L1196+44
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L1196+48
	ldr	r1, [fp]
	ldr	r3, [sp, #8]
	ldrh	r2, [r2]
	ldr	r0, [sp, #36]
	add	ip, r3, r1
	lsls	r2, r2, #7
.L1180:
	cmp	r6, r2
	beq	.L1179
	ldr	r1, [ip, #8]
	ldr	r3, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r3
	beq	.L1181
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L1196+52
	bl	printf
	b	.L1194
.L1181:
	adds	r6, r6, #1
	b	.L1180
.L1173:
	mov	r2, #-1
	b	.L1195
.L1197:
	.align	2
.L1196:
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
	ldr	r3, .L1210
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #104
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1206
	ldr	r3, .L1210+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L1200:
	cbnz	r5, .L1205
.L1198:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1205:
	ldr	r3, .L1210+8
	mov	r0, r7
	ldr	r10, .L1210+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L1210+12
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
	cbz	r2, .L1202
	cmp	r4, r3
	beq	.L1202
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
.L1203:
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
	ldr	r0, .L1210+16
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
	b	.L1200
.L1202:
	ldr	r3, .L1210+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1203
.L1206:
	mov	r8, #-1
	b	.L1198
.L1211:
	.align	2
.L1210:
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
	ldr	r2, .L1214
	ldr	r3, .L1214+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L1212
	ldr	r3, .L1214+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L1214+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L1214+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L1214+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L1214+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L1214+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L1214+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L1214+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L1214+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L1214+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L1214+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L1214+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L1214+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	b	FtlVendorPartWrite
.L1212:
	bx	lr
.L1215:
	.align	2
.L1214:
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
	ldr	r2, .L1221
	push	{r3, lr}
	ldrh	r3, [r2]
	cmp	r3, #31
	itett	ls
	addls	r3, r3, #1
	movhi	r3, #32
	strhls	r3, [r2]	@ movhi
	movls	r3, #1
	ldr	r2, .L1221+4
	cbnz	r0, .L1218
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L1219
.L1218:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1221+8
	str	r3, [r2]
	ldr	r3, .L1221+12
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
.L1219:
	movs	r0, #0
	pop	{r3, pc}
.L1222:
	.align	2
.L1221:
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
	ldr	r3, .L1234
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #104
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1233
	ldr	r3, .L1234+4
	mov	r8, #0
	ldr	fp, .L1234+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L1226:
	cbnz	r6, .L1232
.L1224:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1232:
	ldr	r3, .L1234+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L1234+12
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
	beq	.L1228
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
	ldr	r2, .L1234+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L1230
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L1234+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L1234+24
	bl	FtlMapWritePage
.L1230:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L1231:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L1226
.L1228:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L1231
.L1233:
	mov	r8, #-1
	b	.L1224
.L1235:
	.align	2
.L1234:
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
	ldr	r4, .L1238
	ldr	r5, .L1238+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L1238+8
	cmp	r2, r3
	beq	.L1237
	ldr	r1, .L1238+12
	ldr	r0, .L1238+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L1237:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1239:
	.align	2
.L1238:
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
	ldr	r4, .L1243
	movs	r0, #0
	ldr	r5, .L1243+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L1241
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L1241:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r3, .L1243+8
	bne	.L1242
	ldr	r1, [r4, #88]
	ldr	r2, .L1243+12
	str	r1, [r2]
	ldr	r1, [r4, #92]
	ldr	r2, .L1243+16
	str	r1, [r2]
	ldr	r1, [r4, #8]
	ldr	r2, .L1243+20
	str	r1, [r2]
	ldr	r1, [r4, #12]
	ldr	r2, .L1243+24
	str	r1, [r2]
	ldr	r1, [r4, #16]
	ldr	r2, .L1243+28
	str	r1, [r2]
	ldr	r1, [r4, #20]
	ldr	r2, .L1243+32
	str	r1, [r2]
	ldr	r2, [r4, #28]
	ldr	r1, [r4, #32]
	str	r2, [r3]
	ldr	r2, .L1243+36
	str	r1, [r2]
	ldr	r1, [r4, #36]
	ldr	r2, .L1243+40
	str	r1, [r2]
	ldr	r1, [r4, #40]
	ldr	r2, .L1243+44
	str	r1, [r2]
	ldr	r1, [r4, #44]
	ldr	r2, .L1243+48
	str	r1, [r2]
	ldr	r1, [r4, #48]
	ldr	r2, .L1243+52
	str	r1, [r2]
.L1242:
	ldr	r1, .L1243+56
	ldr	r2, .L1243+60
	ldr	r3, [r3]
	ldr	r0, [r1]
	ldrh	r2, [r2]
	ldr	r1, .L1243+64
	mla	r0, r0, r2, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1243+68
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L1244:
	.align	2
.L1243:
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
	beq	.L1246
	movs	r3, #0
	ldr	r5, .L1258
	str	r3, [r0, #36]
	ldr	r3, .L1258+4
	ldrh	r6, [r0, #6]
	mov	r7, r5
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	str	r3, [r5, #8]
	ldr	r3, .L1258+8
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L1248
	ldr	r2, .L1258+12
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L1248
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1248
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
	beq	.L1248
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L1248
	ldr	r2, [r5, #8]
.L1257:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L1248:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L1249
	movs	r2, #1
	ldr	r0, .L1258
	mov	r1, r2
	bl	FlashReadPages
.L1250:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L1257
.L1249:
	ldr	r3, .L1258+16
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1250
.L1246:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1259:
	.align	2
.L1258:
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
	ldr	r5, .L1275
	ldr	r3, .L1275+4
	ldr	fp, .L1275+76
	ldr	r6, .L1275+8
	ldr	r7, [r3]
	ldr	r0, [fp]
	ldrh	r3, [r5]
	str	r7, [r6, #12]
	str	r0, [r6, #8]
	strh	r3, [r7, #2]	@ movhi
	movw	r3, #61604
	ldr	r4, .L1275+12
	strh	r3, [r7]	@ movhi
	ldr	r2, .L1275+16
	ldr	r3, [r5, #8]
	ldr	ip, .L1275+80
	str	r10, [r7, #8]
	str	r3, [r7, #4]
	stm	r4, {r2, ip}
	ldrh	r2, [r5, #6]
	str	r10, [r7, #12]
	ldr	r8, .L1275+84
	strh	r2, [r4, #8]	@ movhi
	ldr	r2, .L1275+20
	ldr	r3, .L1275+24
	ldrh	r2, [r2]
	strb	r2, [r4, #10]
	ldr	r2, .L1275+28
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #14]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #11]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1275+32
	strh	r1, [r4, #16]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #18]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #12]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1275+36
	strh	r1, [r4, #20]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #22]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #13]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1275+40
	strh	r1, [r4, #24]	@ movhi
	movs	r1, #255
	ldr	r2, [r2]
	str	r2, [r4, #32]
	ldr	r2, [r8]
	str	r2, [r4, #40]
	ldr	r2, .L1275+44
	ldr	r2, [r2]
	str	r2, [r4, #36]
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r4
	ldr	r4, .L1275+48
	movs	r2, #48
	ldr	r0, [r6, #8]
	bl	ftl_memcpy
	ldrh	r2, [r4]
	ldr	r0, [r6, #8]
	ldr	r1, .L1275+52
	lsls	r2, r2, #1
	adds	r0, r0, #48
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldrh	r0, [r4]
	ldr	r1, .L1275+56
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
	ldr	r10, .L1275+4
	bl	FtlUpdateVaildLpn
	movw	r3, #65535
	str	r3, [sp]
	ldr	r3, .L1275+24
	str	r3, [sp, #4]
.L1261:
	ldr	r3, [fp]
	ldrh	r1, [r5, #2]
	ldrh	r2, [r5]
	str	r3, [r6, #8]
	ldr	r3, [r10]
	str	r3, [r6, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r6, #4]
	ldr	r3, .L1275+60
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1262
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
.L1262:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r3, #1
	str	r0, [r7, #12]
	mov	r2, r3
	mov	r1, r3
	ldr	r0, .L1275+8
	bl	FlashProgPages
	ldrh	r3, [r5, #2]
	ldr	r2, [r6]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r5, #2]	@ movhi
	bne	.L1263
	cmp	r3, #1
	bne	.L1264
	movw	r2, #1138
	ldr	r1, .L1275+64
	ldr	r0, .L1275+68
	bl	printf
.L1264:
	ldrh	r3, [r5, #2]
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1275+60
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r5, #2]	@ movhi
	cmp	r4, #3
	bls	.L1261
	mov	r2, r4
	ldr	r1, [r6, #4]
	ldr	r0, .L1275+72
	bl	printf
.L1267:
	b	.L1267
.L1263:
	cmp	r3, #1
	beq	.L1261
	cmp	r2, #256
	beq	.L1261
	ldr	r2, [sp]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1268
	movs	r1, #1
	mov	r0, r2
	bl	FtlFreeSysBlkQueueIn
.L1268:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1276:
	.align	2
.L1275:
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
	ldr	r3, .L1280
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L1279
	bl	FtlSysFlush
.L1279:
	movs	r0, #0
	pop	{r3, pc}
.L1281:
	.align	2
.L1280:
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
	ldr	r3, .L1297
	adds	r2, r0, r1
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r7, r0
	mov	r5, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1290
	cmp	r1, #31
	bhi	.L1284
.L1289:
	movs	r0, #0
.L1282:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1284:
	ldr	r8, .L1297+12
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r6, r0
	subs	r7, r7, r3
	uxth	r7, r7
	cbz	r7, .L1285
	subs	r4, r4, r7
	adds	r6, r6, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L1285:
	ldr	r4, .L1297+4
	mov	r3, #-1
	ldr	r7, .L1297+8
	str	r3, [sp, #4]
.L1286:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L1288
	ldr	r3, .L1297+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L1289
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1289
.L1288:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r6
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L1287
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
.L1287:
	ldrh	r3, [r8]
	adds	r6, r6, #1
	subs	r5, r5, r3
	b	.L1286
.L1290:
	mov	r0, #-1
	b	.L1282
.L1298:
	.align	2
.L1297:
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
	ldr	r3, .L1309
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r0]
	ldrh	r3, [r3]
	cmp	r3, r4
	bcs	.L1300
	movw	r2, #2755
	ldr	r1, .L1309+4
	ldr	r0, .L1309+8
	bl	printf
.L1300:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1301
	ldr	r3, .L1309+12
	mov	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbz	r3, .L1302
	bl	INSERT_DATA_LIST
.L1301:
	ldr	r5, .L1309+16
	movw	r2, #65535
	movs	r3, #1
	strb	r3, [r6, #8]
	ldrh	r0, [r5]
	cmp	r0, r2
	beq	.L1303
	cmp	r4, r0
	bne	.L1304
	ldr	r3, .L1309+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1305
.L1304:
	bl	update_vpc_list
.L1305:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1303:
	mov	r0, r6
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1302:
	bl	INSERT_FREE_LIST
	b	.L1301
.L1310:
	.align	2
.L1309:
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
	ldr	r10, .L1330+20
	mov	r5, r3
	movs	r2, #0
	mov	r4, r0
	ldr	fp, .L1330
	mov	r8, r1
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	bl	FlashProgPages
.L1312:
	cmp	r6, r8
	bne	.L1319
	ldr	r3, .L1330
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1311
	mov	r2, #1000
	ldr	r1, .L1330+4
	ldr	r0, .L1330+8
	bl	printf
.L1311:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1314:
	ldr	r1, [r4, #4]
	mov	r0, r10
	bl	printf
	ldr	r0, [r4, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1313
	mov	r0, r5
	bl	allocate_new_data_superblock
.L1313:
	mov	r0, r5
	bl	get_new_active_ppa
	movs	r2, #0
	str	r0, [r4, #4]
	str	r0, [sp, #12]
	movs	r1, #1
	ldrb	r3, [r5, #9]	@ zero_extendqisi2
	mov	r0, r4
	bl	FlashProgPages
.L1319:
	ldr	r2, [r4]
	adds	r3, r2, #1
	beq	.L1314
	cmp	r2, #256
	beq	.L1314
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [fp]
	cmp	r2, r3
	bcc	.L1315
	movw	r2, #985
	ldr	r1, .L1330+4
	ldr	r0, .L1330+8
	bl	printf
.L1315:
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
	beq	.L1316
	ldr	r3, .L1330+12
	ldr	r3, [r3]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1317
	mov	r1, r0
	ldr	r0, .L1330+16
	bl	printf
.L1317:
	mov	r0, r7
	bl	decrement_vpc_count
.L1316:
	adds	r6, r6, #1
	adds	r4, r4, #20
	b	.L1312
.L1331:
	.align	2
.L1330:
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
	ldr	r4, .L1347
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1333
	ldr	r3, .L1347+4
	mov	r0, r4
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
.L1333:
	ldr	r3, .L1347+8
	movs	r2, #0
	str	r2, [r3]
	movw	r3, #65535
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1335
	ldr	r6, .L1347+4
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldr	r5, .L1347+12
	ldrh	r2, [r6]
	ldrh	r1, [r5]
	muls	r2, r0, r2
	cmp	r1, r2
	beq	.L1336
	movs	r2, #164
	ldr	r1, .L1347+16
	ldr	r0, .L1347+20
	bl	printf
.L1336:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L1347+24
	ldrh	r0, [r4]
	ldr	fp, .L1347+56
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	mov	r10, r2
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L1347+28
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L1337:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1341
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r0, [r4]
	ldr	r3, [r10]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L1342
	bl	INSERT_DATA_LIST
.L1343:
	ldr	r2, .L1347+32
	movs	r3, #0
	movw	r6, #65535
	strh	r3, [r5]	@ movhi
	strh	r6, [r4]	@ movhi
	strh	r3, [r2]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1347+36
	strh	r6, [r3]	@ movhi
	ldr	r3, .L1347+40
	ldrh	r2, [r3]
	ldr	r3, .L1347+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ittt	gt
	ldrgt	r3, .L1347+48
	movgt	r2, #20
	strhgt	r2, [r3]	@ movhi
.L1335:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1341:
	uxth	r3, r6
	mov	r8, #12
	ldr	r2, [fp]
	mul	r8, r8, r3
	ldr	r3, .L1347+52
	ldr	r3, [r3]
	add	r7, r3, r8
	ldr	r0, [r7, #8]
	cmp	r0, r2
	bcc	.L1338
.L1345:
	ldrh	r0, [r4]
	b	.L1346
.L1338:
	movs	r2, #0
	add	r1, sp, #12
	str	r3, [sp, #4]
	bl	log2phys
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #12]
	ldr	r0, [r3, r8]
	cmp	r0, r2
	bne	.L1340
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r8, r0
	adds	r1, r7, #4
	ldr	r0, [r7, #8]
	bl	log2phys
	mov	r0, r8
.L1346:
	bl	decrement_vpc_count
	b	.L1339
.L1340:
	ldr	r3, [r7, #4]
	cmp	r2, r3
	bne	.L1345
.L1339:
	adds	r6, r6, #1
	b	.L1337
.L1342:
	bl	INSERT_FREE_LIST
	b	.L1343
.L1348:
	.align	2
.L1347:
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
	ldr	r4, .L1351
	ldr	r5, .L1351+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1349
	ldr	r0, .L1351+8
	bl	FtlMapBlkWriteDump_data
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1351+12
	movs	r2, #0
	str	r2, [r3]
.L1349:
	pop	{r3, r4, r5, pc}
.L1352:
	.align	2
.L1351:
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
	ldr	r5, .L1354
	ldr	r3, .L1354+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1354+8
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
.L1355:
	.align	2
.L1354:
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
	ldr	r4, .L1364
	movs	r6, #0
	movs	r7, #20
	mov	r2, r3
	ldr	r5, .L1364+4
	ldr	r1, [r4]
	ldr	r0, [r5]
	bl	FlashProgPages
.L1357:
	ldr	r1, [r4]
	uxth	r3, r6
	cmp	r1, r3
	bhi	.L1360
	ldr	r0, [r5]
	bl	FtlGcBufFree
	ldr	r3, .L1364+8
	movs	r0, #0
	str	r0, [r4]
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1356
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	movs	r0, #1
.L1356:
	pop	{r3, r4, r5, r6, r7, pc}
.L1360:
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
	b	.L1357
.L1365:
	.align	2
.L1364:
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
	ldr	r4, .L1369
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1367
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1368
.L1367:
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1369
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1369+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L1369+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1368:
	ldr	r0, .L1369
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1370:
	.align	2
.L1369:
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
	ldr	r3, .L1461
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	str	r0, [sp, #28]
	ldr	r0, [r3]
	cmp	r0, #0
	bne	.L1428
	ldr	r3, .L1461+4
	ldrh	r3, [r3]
	cmp	r3, #47
	bls	.L1371
	ldr	r3, .L1461+8
	movw	r4, #65535
	ldrh	r0, [r3]
	cmp	r0, r4
	beq	.L1373
	ldr	r1, .L1461+12
	ldrh	r2, [r1]
	cmp	r2, r4
	itt	eq
	strheq	r0, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
.L1373:
	ldr	r3, [sp, #28]
	cmp	r3, #0
	bne	.L1430
	ldr	r3, .L1461+16
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L1431
	ldr	r2, .L1461+20
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L1376
	lsrs	r4, r4, #5
.L1375:
	ldr	r2, .L1461+24
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1379
	ldr	r3, .L1461+28
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1380
	ldr	r0, .L1461+12
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L1380
	ldr	r3, .L1461+32
	ldrh	r0, [r3]
	cbnz	r0, .L1381
	ldr	r3, .L1461+36
	ldr	r4, .L1461+40
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L1382
.L1381:
	ldr	r3, .L1461+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1383:
	ldr	r3, .L1461+48
	movs	r2, #0
	str	r2, [r3]
.L1371:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1376:
	cmp	r3, #12
	bls	.L1377
	lsrs	r4, r4, #4
	b	.L1375
.L1377:
	cmp	r3, #8
	bls	.L1375
	lsrs	r4, r4, #2
	b	.L1375
.L1431:
	movs	r4, #1
	b	.L1375
.L1382:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L1383
.L1380:
	ldr	r3, .L1461+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1379:
	ldr	r3, .L1461+52
	ldrh	r3, [r3]
	cbz	r3, .L1374
	adds	r4, r4, #32
	uxth	r4, r4
.L1374:
	ldr	r5, .L1461+56
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L1386
	ldr	r3, .L1461+12
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1387
	ldr	r0, .L1461+60
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L1388
	strh	r2, [r3]	@ movhi
.L1388:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L1387:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L1386
	bl	IsBlkInGcList
	cbz	r0, .L1390
	strh	r6, [r5]	@ movhi
.L1390:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1386
	ldr	r0, .L1461+56
	bl	make_superblock
	ldr	r2, .L1461+64
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1461+60
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1461+68
	strh	r2, [r3]	@ movhi
.L1386:
	ldr	r2, .L1461+72
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1391
	ldr	r2, .L1461+76
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1391
	ldr	r2, .L1461+28
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1392
.L1391:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1392:
	ldr	r5, .L1461+56
	mov	r6, r5
.L1427:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1393
	ldr	fp, .L1461+88
	movs	r2, #0
	ldr	r3, .L1461+48
	mov	r8, fp
	str	r2, [r3]
.L1394:
	ldrh	r7, [fp]
	mov	r0, r7
	bl	List_get_gc_head_node
	uxth	r3, r0
	movw	r1, #65535
	cmp	r3, r1
	strh	r3, [r6]	@ movhi
	bne	.L1395
	movs	r3, #0
	movs	r0, #8
	strh	r3, [fp]	@ movhi
	b	.L1371
.L1430:
	movs	r4, #1
	b	.L1374
.L1395:
	str	r0, [sp, #16]
	mov	r0, r3
	str	r3, [sp, #12]
	adds	r7, r7, #1
	bl	IsBlkInGcList
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #16]
	cbz	r0, .L1396
	strh	r7, [fp]	@ movhi
	b	.L1394
.L1396:
	uxth	r0, r2
	ldr	r2, .L1461+20
	ldr	r10, .L1461+60
	uxth	r7, r7
	ldrh	lr, [r2]
	ldr	r2, .L1461+80
	ldr	r1, [r10]
	strh	r7, [fp]	@ movhi
	ldrh	r2, [r2]
	ldrh	ip, [r1, r0, lsl #1]
	mul	r2, r2, lr
	cmp	ip, r2, asr #1
	bgt	.L1398
	cmp	r7, #48
	bls	.L1399
	cmp	ip, #8
	bls	.L1399
	ldr	r7, .L1461+84
	ldrh	r7, [r7]
	cmp	r7, #35
	bhi	.L1399
.L1398:
	movs	r7, #0
	strh	r7, [r8]	@ movhi
.L1399:
	ldrh	r1, [r1, r0, lsl #1]
	cmp	r2, r1
	bgt	.L1400
	ldrh	r2, [r8]
	cmp	r2, #3
	bhi	.L1400
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r8]	@ movhi
.L1460:
	ldr	r3, .L1461+32
	ldrh	r0, [r3]
	b	.L1371
.L1400:
	cbnz	r1, .L1401
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r8]
	adds	r3, r3, #1
	strh	r3, [r8]	@ movhi
	b	.L1394
.L1462:
	.align	2
.L1461:
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
.L1401:
	movs	r2, #0
	strb	r2, [r6, #8]
	ldr	r2, .L1463
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1402
	movw	r2, #717
	ldr	r1, .L1463+4
	ldr	r0, .L1463+8
	bl	printf
.L1402:
	ldr	r3, .L1463+12
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1403
	movw	r2, #718
	ldr	r1, .L1463+4
	ldr	r0, .L1463+8
	bl	printf
.L1403:
	ldr	r3, .L1463+16
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1404
	movw	r2, #719
	ldr	r1, .L1463+4
	ldr	r0, .L1463+8
	bl	printf
.L1404:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L1463+20
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r10]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L1463+24
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L1393:
	ldr	r3, .L1463+28
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L1463+32
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, [sp, #28]
	cbz	r3, .L1405
	ldr	r3, .L1463+36
	ldr	r2, [sp, #16]
	ldrh	r1, [r6]
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L1463+40
	ldr	r2, [r2]
	ldrh	r2, [r2, r1, lsl #1]
	subs	r3, r3, r2
	it	mi
	addmi	r3, r3, #3
	add	r4, r4, r3, asr #2
	uxth	r4, r4
.L1405:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #16]
	ldr	fp, .L1463+64
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #24]
.L1408:
	ldrh	r3, [sp, #24]
	cmp	r4, r3
	bls	.L1416
	ldr	r3, .L1463+36
	movw	r10, #65535
	ldrh	r1, [r5, #2]
	mov	ip, #20
	ldr	r0, [fp]
	ldrh	lr, [r3]
	ldr	r3, [sp, #24]
	ldr	r7, .L1463+44
	adds	r3, r1, r3
	str	r3, [sp, #20]
	movs	r3, #0
	str	r3, [sp, #12]
	b	.L1417
.L1410:
	ldrh	r2, [r7, #2]!
	cmp	r2, r10
	beq	.L1409
	ldr	r1, [sp, #12]
	mla	r8, ip, r1, r0
	ldr	r1, [sp, #20]
	orr	r2, r1, r2, lsl #10
	str	r2, [r8, #4]
	ldr	r2, [sp, #12]
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1409:
	adds	r3, r3, #1
.L1417:
	uxth	r2, r3
	cmp	lr, r2
	bhi	.L1410
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1459:
	str	r3, [sp, #20]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #20]
	cmp	r2, r3
	bhi	.L1415
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	str	r3, [sp, #24]
	b	.L1408
.L1415:
	ldr	r3, [sp, #20]
	movs	r7, #20
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L1412
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L1412
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L1413
	movw	r2, #753
	ldr	r1, .L1463+4
	ldr	r0, .L1463+8
	bl	printf
.L1413:
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #40]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	cmp	r2, r3
	bne	.L1412
	ldr	r2, .L1463+20
	ldr	r10, .L1463+60
	ldr	r1, .L1463+48
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
	ldr	r7, .L1463+16
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
	ldr	r2, .L1463+52
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L1414
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1412
.L1414:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1412
	ldr	r3, .L1463+28
	movs	r2, #0
	movw	r1, #65535
	str	r2, [r3]
	ldr	r3, .L1463+56
	strh	r1, [r3]	@ movhi
	strh	r2, [r3, #2]	@ movhi
	b	.L1460
.L1412:
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1459
.L1416:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #16]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L1418
	ldr	r3, .L1463+60
	ldr	r3, [r3]
	cbz	r3, .L1419
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1419
	ldr	r3, .L1463+28
	movs	r2, #0
	str	r2, [r3]
	b	.L1460
.L1464:
	.align	2
.L1463:
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
.L1419:
	ldr	r3, .L1465
	ldrh	r4, [r3]
	cmp	r4, #0
	bne	.L1420
	ldr	r8, .L1465+28
	ldrh	r1, [r5]
	ldr	r3, [r8]
	ldrh	r3, [r3, r1, lsl #1]
	cmp	r3, #0
	beq	.L1420
	ldr	r0, .L1465+4
	ldr	r10, .L1465+32
	ldrh	r2, [r5, #2]
	ldrh	r0, [r0]
	str	r3, [sp]
	mov	r3, r4
	str	r0, [sp, #4]
	ldr	r0, .L1465+8
	bl	printf
.L1421:
	ldr	r3, [r10]
	cmp	r4, r3
	bcs	.L1423
	movs	r2, #0
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #44]
	adds	r3, r7, #1
	beq	.L1422
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5]
	cmp	r3, r0
	bne	.L1422
	mov	r2, r7
	mov	r1, r4
	ldr	r0, .L1465+12
	bl	printf
.L1423:
	ldr	r3, [r10]
	cmp	r4, r3
	bcc	.L1420
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1420:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1418:
	ldr	r3, .L1465+16
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, .L1465+20
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L1426
	ldr	r3, .L1465+24
	ldrh	r4, [r3]
	b	.L1427
.L1422:
	adds	r4, r4, #1
	b	.L1421
.L1426:
	adds	r0, r0, #1
	b	.L1371
.L1428:
	movs	r0, #0
	b	.L1371
.L1466:
	.align	2
.L1465:
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
	bne	.L1468
	mov	r2, r3
	ldr	r1, [sp, #24]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #4]
.L1467:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1468:
	ldr	r3, [sp, #24]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L1500
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1489
	ldr	r3, .L1500+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L1490
	ldr	r3, .L1500+8
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
	ldr	r2, .L1500+12
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
	ldr	r2, .L1500+16
	str	r7, [sp, #4]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1470:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1487
	ldr	r3, .L1500+20
	ldrh	r3, [r3]
	cbnz	r3, .L1488
	ldr	r3, .L1500+24
	ldrh	r3, [r3]
	cmp	r3, #31
	bhi	.L1467
.L1488:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	b	.L1467
.L1487:
	movs	r2, #0
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #52]
	adds	r0, r3, #1
	bne	.L1471
	ldr	fp, .L1500+8
	mov	r10, #0
.L1472:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L1474
.L1475:
	ldr	r3, [sp, #8]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1479
	ldr	r3, .L1500+28
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L1470
.L1479:
	cmp	r5, #0
	beq	.L1470
	ldr	r3, .L1500+32
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
.L1486:
	movs	r3, #20
	mul	fp, r3, r10
	ldr	r3, .L1500+32
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	add	r2, r2, fp
	ldr	r1, [r2, #16]
	cmp	r3, r1
	bne	.L1481
	ldr	r1, [r2, #8]
	ldr	r2, .L1500+36
	ldr	r2, [r2]
	cmp	r1, r2
	bne	.L1482
	ldr	r3, [sp, #36]
	mov	r0, r8
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L1499:
	bl	ftl_memcpy
.L1482:
	ldr	r3, .L1500+32
	ldr	r3, [r3]
	add	r2, r3, fp
	ldr	r3, [r3, fp]
	ldr	r0, [r2, #12]
	ldr	r1, [r2, #16]
	ldr	r0, [r0, #8]
	cmp	r1, r0
	itttt	ne
	ldrne	r0, .L1500+40
	ldrne	r1, [r0, #72]
	addne	r1, r1, #1
	strne	r1, [r0, #72]
	adds	r1, r3, #1
	bne	.L1484
	ldr	r1, .L1500+40
	str	r3, [sp, #4]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1485:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L1486
	movs	r5, #0
	b	.L1470
.L1474:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L1473
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L1473
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r8, r0, lsl #9
	bl	ftl_memset
.L1473:
	add	r10, r10, #1
	b	.L1472
.L1471:
	ldr	r2, .L1500+32
	mov	r10, #20
	ldr	r2, [r2]
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L1500+8
	bne	.L1476
	ldr	r2, .L1500+36
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
	bne	.L1477
	str	r8, [r10, #8]
.L1477:
	ldr	r3, .L1500+44
	ldr	r2, .L1500+48
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L1475
.L1476:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L1478
	ldr	r2, .L1500+52
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r7, r1, r3
	cmp	r2, r7
	bne	.L1477
.L1498:
	subs	r3, r3, r6
	add	r3, r8, r3, lsl #9
	str	r3, [r10, #8]
	b	.L1477
.L1478:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L1498
.L1481:
	ldr	r3, [sp, #20]
	cmp	r3, r1
	bne	.L1482
	ldr	r3, .L1500+52
	ldr	r1, [r2, #8]
	ldr	r2, [r3]
	cmp	r1, r2
	bne	.L1482
	ldr	r2, .L1500+8
	ldr	r3, [sp, #20]
	ldrh	r0, [r2]
	ldr	r2, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r8, r0, lsl #9
	b	.L1499
.L1484:
	cmp	r3, #256
	bne	.L1485
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1485
.L1489:
	mov	r3, #-1
.L1490:
	str	r3, [sp, #4]
	b	.L1467
.L1501:
	.align	2
.L1500:
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
	bne	.L1504
	mov	r2, r3
	ldr	r1, [sp, #20]
	add	r0, fp, #256
	bl	FtlVendorPartWrite
.L1503:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1504:
	ldr	r3, [sp, #20]
	adds	r4, r1, r3
	ldr	r3, .L1548
	ldr	r3, [r3]
	cmp	r4, r3
	bhi	.L1537
	ldr	r3, .L1548+4
	ldr	r0, [r3]
	adds	r1, r0, #1
	beq	.L1503
	ldr	r3, .L1548+8
	mov	r2, #2048
	mov	r0, fp
	ldr	r7, .L1548+12
	str	r2, [r3]
	ldr	r3, .L1548+16
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
	ldr	r2, .L1548+20
	str	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r3, [r2]
	str	r0, [sp, #28]
	add	r3, r3, r1
	ldr	r1, [sp, #8]
	str	r3, [r2]
	ldr	r2, .L1548+24
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1506:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1532
	ldr	r5, .L1548+28
	mov	r0, r3
	ldr	r1, [sp, #32]
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r5]
	cmp	r2, #5
	bls	.L1533
.L1535:
	movs	r0, #0
	b	.L1503
.L1532:
	ldr	r4, .L1548+32
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1507
	movw	r2, #1041
	ldr	r1, .L1548+36
	ldr	r0, .L1548+40
	bl	printf
.L1507:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1508
	mov	r0, r7
	bl	allocate_new_data_superblock
.L1508:
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
	bcc	.L1509
	movw	r2, #1074
	ldr	r1, .L1548+36
	ldr	r0, .L1548+40
	bl	printf
.L1509:
	ldr	r8, .L1548+44
	movs	r3, #0
	str	r3, [sp, #4]
.L1510:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #44]
	cmp	r3, r2
	bne	.L1530
.L1511:
	ldr	r0, .L1548+44
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #4]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bls	.L1531
	mov	r2, #1152
	ldr	r1, .L1548+36
	ldr	r0, .L1548+40
	bl	printf
.L1531:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	subs	r3, r3, r2
	str	r3, [sp, #8]
	b	.L1506
.L1530:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L1511
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r5
	movs	r6, #20
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r2, .L1548+48
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
	ldr	r1, .L1548+52
	ldr	r0, [sp, #36]
	ldr	r1, [r1]
	add	r10, r1, r0
	str	r1, [sp, #40]
	str	r10, [r3, #12]
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
	ldr	r3, [sp, #12]
	ldr	r2, .L1548+16
	cmp	r5, r3
	beq	.L1512
	ldr	r3, [sp, #28]
	cmp	r5, r3
	bne	.L1543
	ldrh	r2, [r2]
	ldr	r3, [sp, #20]
	smulbb	r2, r2, r5
	add	r4, fp, r3
	movs	r3, #0
	str	r3, [sp, #24]
	subs	r4, r4, r2
	uxth	r4, r4
	b	.L1515
.L1512:
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
.L1515:
	ldr	r3, .L1548+16
	ldrh	r3, [r3]
	cmp	r4, r3
	ldr	r3, [sp, #12]
	bne	.L1516
	cmp	r5, r3
	ldr	r3, [r8]
	add	r6, r6, r3
	bne	.L1517
	ldr	r3, [sp, #16]
.L1545:
	str	r3, [r6, #8]
	b	.L1518
.L1517:
	muls	r4, r5, r4
	ldr	r3, [sp, #16]
	sub	r4, r4, fp
	add	r4, r3, r4, lsl #9
	str	r4, [r6, #8]
.L1518:
	ldr	r3, .L1548+32
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1527
	movw	r2, #1143
	ldr	r1, .L1548+36
	ldr	r0, .L1548+40
	bl	printf
.L1527:
	ldr	r2, [sp, #40]
	movw	r3, #61589
	ldr	r1, [sp, #36]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L1548+56
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
	b	.L1510
.L1516:
	cmp	r5, r3
	ldr	r3, [r8]
	ite	eq
	ldreq	r2, .L1548+60
	ldrne	r2, .L1548+64
	add	r3, r3, r6
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r3, [sp, #48]
	adds	r2, r3, #1
	beq	.L1521
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
	bne	.L1522
	ldr	r1, .L1548+68
	ldr	r0, .L1548+72
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
	mov	r2, r5
	ldr	r1, [r10, #8]
	bl	printf
.L1525:
	ldr	r3, [sp, #12]
	lsls	r2, r4, #9
	cmp	r5, r3
	bne	.L1526
	ldr	r3, [r8]
	ldr	r1, [sp, #16]
	add	r6, r6, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r6, #8]
	add	r0, r0, r3, lsl #9
.L1546:
	bl	ftl_memcpy
	b	.L1518
.L1522:
	ldr	r1, [r10, #8]
	cmp	r5, r1
	beq	.L1524
	ldr	r2, .L1548+68
	ldr	r0, .L1548+76
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r5
	bl	printf
.L1524:
	ldr	r3, [r10, #8]
	cmp	r5, r3
	beq	.L1525
	mov	r2, #1128
	ldr	r1, .L1548+36
	ldr	r0, .L1548+40
	bl	printf
	b	.L1525
.L1521:
	ldr	r3, [r8]
	movs	r1, #0
	ldr	r2, .L1548+80
	add	r3, r3, r6
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L1525
.L1549:
	.align	2
.L1548:
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
.L1526:
	ldr	r3, .L1550
	ldrh	r1, [r3]
	ldr	r3, [r8]
	muls	r1, r5, r1
	add	r6, r6, r3
	ldr	r3, [sp, #16]
	ldr	r0, [r6, #8]
	sub	r1, r1, fp
	add	r1, r3, r1, lsl #9
	b	.L1546
.L1543:
	ldr	r3, [r8]
	add	r6, r6, r3
	ldrh	r3, [r2]
	ldr	r2, [sp, #16]
	muls	r3, r5, r3
	sub	r3, r3, fp
	add	r3, r2, r3, lsl #9
	b	.L1545
.L1533:
	ldr	r6, .L1550+4
	mov	r4, #256
	ldr	r7, .L1550+8
.L1536:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1534
	ldrh	r2, [r7]
	cmp	r2, r3
	bne	.L1534
	movs	r0, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L1534:
	ldr	r2, .L1550+12
	movs	r3, #128
	movs	r1, #1
	mov	r0, r1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1550+16
	strh	r3, [r2]	@ movhi
	bl	rk_ftl_garbage_collect
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	ldrh	r3, [r5]
	cmp	r3, #2
	bhi	.L1535
	subs	r4, r4, #1
	bne	.L1536
	b	.L1535
.L1537:
	mov	r0, #-1
	b	.L1503
.L1551:
	.align	2
.L1550:
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
	ldr	r8, .L1583+144
	sub	sp, sp, #24
	ldr	r7, .L1583
	ldr	r3, [r8]
	ldr	r4, .L1583+4
	ldr	fp, .L1583+148
	ldrh	r2, [r7]
	ldr	r5, .L1583+8
	str	r3, [r4, #8]
	ldr	r6, .L1583+12
	ldr	r3, [fp]
	lsls	r2, r2, #1
	ldr	r0, [r5]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r5, [sp, #16]
	cmp	r0, r3
	bne	.L1554
.L1565:
	mov	r0, #-1
.L1553:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1554:
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	ldrsh	r10, [r6]
	sxth	r5, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L1556:
	cmp	r5, #0
	bge	.L1562
	movw	r2, #1465
	ldr	r1, .L1583+16
	ldr	r0, .L1583+20
	bl	printf
	b	.L1561
.L1562:
	orr	r3, r5, r10, lsl #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L1583+4
	str	r3, [r4, #4]
	ldr	r3, [r8]
	str	r3, [r4, #8]
	bl	FlashReadPages
	ldr	r3, [r4, #12]
	ldr	r3, [r3, #12]
	str	r3, [sp, #20]
	cbz	r3, .L1557
	ldr	r2, [r4]
	adds	r2, r2, #1
	beq	.L1557
	ldr	r2, .L1583+24
	ldr	r0, [r4, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	beq	.L1557
	str	r0, [sp, #8]
	mov	r2, r10
	str	r3, [sp, #4]
	ldrh	r3, [r6, #4]
	ldr	r1, .L1583+16
	ldr	r0, .L1583+28
	str	r3, [sp]
	mov	r3, r5
	bl	printf
	cbnz	r5, .L1558
	ldrh	r3, [r6, #4]
	cmp	r10, r3
	beq	.L1558
	sxth	r10, r3
	ldr	r3, .L1583+32
	ldrh	r5, [r3]
.L1560:
	subs	r5, r5, #1
	sxth	r5, r5
	b	.L1556
.L1558:
	mov	r3, #-1
	str	r3, [r4]
.L1557:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1560
	ldr	r3, [r8]
	ldr	r2, .L1583+36
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1560
	ldr	r3, [fp]
	ldrh	r2, [r3]
	movw	r3, #61604
	cmp	r2, r3
	bne	.L1560
.L1561:
	ldr	r2, .L1583+24
	ldrh	r3, [r7]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L1564
	movw	r2, #1467
	ldr	r1, .L1583+16
	ldr	r0, .L1583+20
	bl	printf
.L1564:
	ldr	r5, .L1583+40
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
	ldr	r3, .L1583+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r2, [r5]
	ldr	r3, .L1583+36
	cmp	r2, r3
	bne	.L1565
	ldr	r3, .L1583+48
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r5, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L1565
	ldr	r3, .L1583+52
	ldr	r2, .L1583+56
	str	r5, [r3]
	ldr	r3, .L1583+60
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L1583+64
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L1583+68
	str	r3, [r2]
	ldr	r3, .L1583+72
	ldr	r6, [r3]
	ldr	r3, .L1583+76
	ldrh	r0, [r3, #6]
	ldr	r3, .L1583+80
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L1583+84
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L1566
	movw	r2, #1489
	ldr	r1, .L1583+16
	ldr	r0, .L1583+20
	bl	printf
.L1566:
	ldrh	r2, [r4, #16]
	ldr	r3, .L1583+88
	ldrh	ip, [r4, #14]
	ldr	r7, .L1583+92
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L1583+96
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
	ldr	r2, .L1583+100
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L1583+104
	str	r3, [r5]
	ldr	r5, .L1583+108
	str	r3, [r5]
	ldr	r5, .L1583+112
	str	r3, [r5]
	ldr	r5, .L1583+116
	str	r3, [r5]
	ldr	r5, .L1583+120
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L1583+124
	str	r3, [r5]
	ldr	r5, .L1583+128
	str	r3, [r5]
	ldr	r5, .L1583+132
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L1583+136
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L1583+140
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L1569
	ldr	r0, .L1583+88
	bl	make_superblock
.L1569:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1570
	ldr	r0, .L1583+96
	bl	make_superblock
.L1570:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1571
	ldr	r0, .L1583+100
	bl	make_superblock
.L1571:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1572
	ldr	r0, .L1583+92
	bl	make_superblock
.L1572:
	movs	r0, #0
	b	.L1553
.L1584:
	.align	2
.L1583:
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
	ldr	r6, .L1626
	str	r3, [sp, #24]
	ldrh	r3, [r0, #6]
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	ldr	r0, [sp, #8]
	str	r3, [sp, #16]
	ldr	r3, [sp, #12]
	lsls	r2, r3, #2
	bl	ftl_memset
	ldr	r3, .L1626+4
	str	r7, [r4, #32]
	str	r7, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #20]
	str	r2, [r6, #8]
	ldr	r2, .L1626+8
	ldr	fp, [r2]
	movw	r2, #65535
	str	fp, [r6, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L1586:
	ldr	r3, [sp, #16]
	sxth	r5, r7
	cmp	r5, r3
	bge	.L1605
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r5, r3
	bne	.L1587
	movs	r1, #1
	ldrh	r0, [r8, r5, lsl #1]
	bl	FtlGetLastWrittenPage
	sxth	r3, r0
	ldr	r6, .L1626
	add	r10, r8, r5, lsl #1
	strh	r7, [r4]	@ movhi
	str	r3, [sp, #16]
	movs	r7, #0
	ldr	r3, [sp, #24]
	adds	r0, r0, #1
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r4, #28]
.L1588:
	ldr	r3, [sp, #16]
	sxth	r8, r7
	cmp	r8, r3
	ble	.L1591
.L1605:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L1626+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1593
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1593:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1591:
	ldrh	r2, [r10]
	ldr	r0, .L1626
	orr	r2, r8, r2, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #20]
	cbz	r2, .L1589
	ldr	r1, [r6]
	adds	r1, r1, #1
	beq	.L1589
	ldr	r3, .L1626+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	ldr	r2, [sp, #20]
	cmp	r2, r0
	beq	.L1589
	str	r0, [sp, #4]
	mov	r3, r8
	str	r2, [sp]
	mov	r2, r5
	ldr	r1, .L1626+20
	ldr	r0, .L1626+24
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1589:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1590
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1590
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1590:
	adds	r7, r7, #1
	b	.L1588
.L1587:
	ldr	r3, [sp, #20]
	ldr	r10, .L1626+12
	ldrh	r2, [r8, r5, lsl #1]
	ldr	r3, [r3]
	ldr	r0, .L1626
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
	beq	.L1607
	ldrh	r2, [fp]
	ldrh	r3, [r4, #4]
	cmp	r2, r3
	bne	.L1607
	ldrh	r2, [fp, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L1595
.L1607:
	mov	r10, #0
.L1596:
	ldr	r2, .L1626+12
	sxth	r3, r10
	ldrh	r2, [r2]
	cmp	r3, r2
	bge	.L1603
	ldr	r2, [sp, #28]
	ldr	r0, .L1626
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
	cbz	r2, .L1600
	ldr	r1, [r6]
	adds	r1, r1, #1
	beq	.L1600
	ldr	r1, .L1626+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #32]
	cmp	r2, r0
	beq	.L1600
	str	r0, [sp, #4]
	str	r2, [sp]
	mov	r2, r5
	ldr	r3, [sp, #36]
	ldr	r1, .L1626+20
	ldr	r0, .L1626+28
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1600:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1601
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1601
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1601:
	add	r10, r10, #1
	b	.L1596
.L1595:
	ldr	r3, [sp, #20]
	movs	r1, #0
	ldrh	r2, [r10]
	ldr	r0, [r3]
	add	lr, r2, #-1
.L1597:
	sxth	r3, r1
	cmp	r3, lr
	blt	.L1599
.L1603:
	adds	r7, r7, #1
	b	.L1586
.L1599:
	lsls	r5, r3, #3
	ldr	r3, [r0, r3, lsl #3]
	ldr	r2, [sp, #12]
	uxth	ip, r3
	cmp	r2, ip
	bls	.L1598
	add	r5, r5, r0
	ldr	r2, [sp, #8]
	ldr	r5, [r5, #4]
	str	r5, [r2, ip, lsl #2]
.L1598:
	adds	r1, r1, #1
	b	.L1597
.L1627:
	.align	2
.L1626:
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
	ldr	r3, .L1629
	ldr	r0, .L1629+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L1629+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L1629+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L1629+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L1629+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L1629+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L1629+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1630:
	.align	2
.L1629:
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
	ldr	r0, .L1632
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1633:
	.align	2
.L1632:
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
	ldr	r4, .L1647
	strh	r3, [r4]	@ movhi
	ldr	r3, .L1647+4
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1647+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1635
.L1637:
	mov	r6, #-1
.L1634:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L1635:
	bl	FtlLoadSysInfo
	mov	r6, r0
	cmp	r0, #0
	bne	.L1637
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1647+12
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L1647+16
	ldr	r2, [r3]
	mov	r3, r6
.L1638:
	cmp	r3, r1
	bge	.L1643
	mla	r5, r0, r3, r2
	ldr	r5, [r5, #4]
	cmp	r5, #0
	bge	.L1639
.L1643:
	ldr	r0, .L1647+20
	cmp	r3, r1
	ldr	r2, [r0]
	add	r2, r2, #32
	str	r2, [r0]
	bge	.L1645
.L1640:
	ldr	r5, .L1647+24
	ldr	r4, .L1647+28
	mov	r0, r5
	bl	FtlSuperblockPowerLostFix
	mov	r0, r4
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1647+32
	ldrh	r1, [r5]
	ldrh	r0, [r5, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L1647+36
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
	ldr	r2, .L1647+40
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1646:
	bl	FtlVpcTblFlush
	b	.L1634
.L1639:
	adds	r3, r3, #1
	b	.L1638
.L1645:
	ldrh	r3, [r4]
	cmp	r3, #0
	bne	.L1640
	bl	l2p_flush
	b	.L1646
.L1648:
	.align	2
.L1647:
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
	ldr	r2, .L1673
	ldr	r6, .L1673+4
	str	r3, [r2]
	ldr	r5, .L1673+8
	ldr	r2, .L1673+12
	ldrh	r0, [r6]
	str	r3, [r5]
	str	r3, [r2]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1650
	bl	FtlMakeBbt
.L1650:
	ldr	r3, .L1673+16
	ldr	r2, .L1673+20
	ldr	ip, .L1673+104
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L1673+24
	str	r3, [sp, #4]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L1651:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L1652
	ldr	r3, .L1673+28
	movs	r7, #0
	ldr	r10, .L1673+108
	ldrh	r4, [r3]
	mov	r8, r3
	mov	fp, r10
.L1653:
	ldrh	r3, [r10]
	cmp	r3, r4
	bhi	.L1654
	ldr	r4, .L1673+32
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L1655
.L1659:
	movs	r6, #0
	mov	r7, r6
.L1656:
	ldrh	r3, [r8]
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bhi	.L1660
	ldrh	r2, [fp]
	ldr	r3, .L1673+36
	ldrh	r4, [r4]
	ldr	r6, .L1673+40
	str	r2, [r3]
	ldr	r3, .L1673+44
	mov	r1, r4
	ldr	r2, [r3]
	mov	r0, r2
	str	r2, [sp, #12]
	bl	__aeabi_uidiv
	ubfx	r10, r0, #5, #16
	mov	r3, r0
	str	r0, [r6]
	add	r1, r10, #36
	ldr	r0, .L1673+48
	strh	r1, [r0]	@ movhi
	movs	r1, #24
	muls	r1, r4, r1
	str	r0, [sp]
	cmp	r7, r1
	ble	.L1661
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
.L1661:
	ldr	r2, .L1673+52
	ldrh	r2, [r2]
	cbz	r2, .L1663
	ldr	r1, .L1673+48
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
.L1663:
	ldr	r3, [sp]
	ldr	r7, .L1673+56
	ldr	r10, .L1673+112
	ldrh	r2, [r3]
	ldr	r3, [r6]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L1673+60
	ldrh	r3, [r3]
	str	r4, [r7]
	muls	r4, r3, r4
	ldr	r3, [sp, #4]
	ldrh	r3, [r3]
	str	r4, [r6]
	ldr	r6, .L1673+64
	muls	r4, r3, r4
	ldr	r3, .L1673+68
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [fp]
	movs	r1, #0
	ldr	r0, [r10]
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L1673+72
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r6, #6]
	str	r3, [r2]
	ldr	r2, .L1673+76
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
	ldr	r3, .L1673+80
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L1665:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	cmp	r3, #0
	bne	.L1666
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r6]
	adds	r3, r3, #1
	strh	r3, [r6]	@ movhi
	b	.L1665
.L1652:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L1651
.L1654:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L1653
.L1655:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L1673+84
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L1657:
	ldrh	r3, [fp]
	cmp	r3, r6
	bls	.L1659
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L1657
.L1660:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r7, r7, r0
	uxth	r7, r7
	b	.L1656
.L1666:
	ldr	r3, [r5]
	ldrh	r1, [r6, #4]
	ldr	r4, .L1673+88
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
.L1667:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L1668
	ldr	r3, [r8]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L1667
.L1668:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1673+92
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1673+96
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
	cbnz	r0, .L1669
	ldr	r3, .L1673+100
	movs	r2, #1
	str	r2, [r3]
.L1669:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1674:
	.align	2
.L1673:
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
	ldr	r4, .L1687
	movs	r6, #0
	ldr	r1, .L1687+4
	ldr	r0, .L1687+8
	str	r3, [r4]
	bl	printf
	ldr	r0, .L1687+12
	bl	FtlConstantsInit
	ldr	r5, .L1687+16
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1687+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
.L1676:
	bl	FtlLoadBbt
	cbz	r0, .L1677
.L1686:
	ldr	r3, [r5]
	cmp	r3, #1
	bne	.L1676
	str	r6, [r5]
	bl	ftl_low_format
	b	.L1676
.L1677:
	bl	FtlSysBlkInit
	cmp	r0, #0
	bne	.L1686
	movs	r3, #1
	str	r3, [r4]
	pop	{r4, r5, r6, pc}
.L1688:
	.align	2
.L1687:
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
	ldr	r5, .L1759
	bls	.L1690
	cmp	r0, #576
	bcc	.L1691
.L1690:
	ldr	r3, [r5]
	cbnz	r3, .L1692
.L1758:
	movs	r4, #0
	b	.L1689
.L1692:
	ldr	r3, .L1759+4
	ldr	r3, [r3]
	ldr	r2, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1759+8
	cmp	r2, r3
	bne	.L1694
	ldr	r3, .L1759+12
	movs	r2, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [sp, #12]
	add	r0, r3, #262144
	movw	r3, #65535
.L1698:
	ldr	r4, [r0, #-4]
	cbnz	r4, .L1695
	ldr	r4, [sp, #12]
	subs	r3, r3, #1
	ldr	r4, [r4, r2, lsl #2]
	adds	r2, r2, #1
	cmp	r2, #4096
	it	hi
	movhi	r2, #0
	cmp	r3, #4096
	str	r4, [r0, #-4]!
	bne	.L1698
	mov	r3, #512
	b	.L1755
.L1695:
	adds	r3, r3, #127
	lsrs	r3, r3, #7
.L1755:
	str	r3, [sp, #16]
	lsls	r1, r1, #2
	ldr	r3, [sp, #16]
	uxth	r1, r1
	ldr	r4, .L1759+16
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
.L1720:
	ldr	r3, .L1759+20
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	memset
	ldr	r3, .L1759+12
	ldrh	r6, [r3, #10]
	ldr	r3, [r4, #16]
	mul	fp, r10, r6
	cmp	r3, #0
	beq	.L1728
	ldr	r3, [r4, #20]
	cmp	r3, #0
	ite	eq
	moveq	r3, #6
	movne	r3, #9
.L1756:
	str	r3, [sp, #28]
	mov	r1, fp
	ldr	r3, .L1759+16
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
	ldr	r3, [sp, #24]
	cmp	r3, #1
	beq	.L1700
	ldr	r3, .L1759+16
	add	r1, r6, fp
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
.L1700:
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1730
	ldr	r3, .L1759+20
	mov	r2, #1024
	movs	r1, #0
	ldr	r5, [r3]
	mov	r0, r5
	bl	ftl_memset
	movs	r2, #4
	ldr	r3, .L1759+24
	strb	r2, [r5, #17]
	movs	r1, #12
	ldr	r2, .L1759+12
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
.L1701:
	ldr	r3, [sp, #24]
	mov	r8, fp
	muls	r3, r6, r3
	movs	r6, #0
	str	r3, [sp, #40]
	ldr	r3, [sp, #12]
	str	r3, [sp, #32]
.L1702:
	ldr	r3, [sp, #40]
	cmp	r6, r3
	beq	.L1709
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
	bne	.L1705
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1705
	ldr	r3, [r4, #16]
	movs	r0, #70
	blx	r3
	add	r3, sp, #48
	mov	r2, r5
	mov	r1, fp
	mov	r0, r6
	ldr	r7, [r4, #8]
	blx	r7
	ldr	r2, .L1759+12
	str	r0, [sp, #44]
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r2, [sp, #44]
	adds	r2, r2, #1
	bne	.L1706
.L1709:
	ldr	r3, .L1759+20
	ldr	r2, [r4, #16]
	ldr	r6, [r3]
	ldr	r3, .L1759+12
	ldrb	r3, [r3, #14]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L1759+12
	ldrh	r3, [r3, #10]
	mul	r8, r10, r3
	cmp	r2, #0
	bne	.L1707
	mov	fp, #6
.L1708:
	ldr	r2, [sp, #24]
	movs	r5, #0
	muls	r3, r2, r3
	str	r3, [sp, #32]
.L1711:
	ldr	r3, [sp, #32]
	cmp	r5, r3
	beq	.L1715
	cmp	r5, #0
	bne	.L1712
	cmp	fp, #9
	bne	.L1712
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
	ldr	r2, .L1759+12
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r3, [r6]
	ldr	r2, .L1759+24
	cmp	r3, r2
	beq	.L1713
.L1715:
	ldr	r3, .L1759+20
	movs	r5, #0
	ldr	r1, [sp, #12]
	ldr	r0, [r3]
.L1714:
	mov	r8, r1
	ldr	r2, [r0, r5, lsl #2]
	ldr	r3, [r8]
	lsls	r6, r5, #2
	adds	r1, r1, #4
	cmp	r2, r3
	beq	.L1717
	mov	r2, #512
	movs	r1, #0
	bl	memset
	ldr	r3, .L1759+20
	mov	r1, r10
	ldr	r0, .L1759+28
	ldr	r2, [r3]
	str	r5, [sp]
	ldr	r3, [r8]
	ldr	r2, [r2, r6]
	bl	printf
	ldr	r3, .L1759+12
	movs	r0, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [r4, #4]
	mul	r1, r10, r1
	blx	r3
.L1718:
	ldr	r3, [sp, #24]
	add	r10, r10, r3
	cmp	r10, #15
	bls	.L1720
	ldr	r3, [sp, #20]
	cbnz	r3, .L1721
.L1694:
	mov	r3, #-1
	str	r3, [sp, #16]
.L1721:
	ldr	r3, .L1759
	movs	r2, #0
	ldr	r4, [sp, #16]
	str	r2, [r3]
	ldr	r3, .L1759+4
	ldr	r0, [r3]
	bl	free
	ldr	r3, .L1759+20
	ldr	r0, [r3]
	bl	free
.L1689:
	mov	r0, r4
	add	sp, sp, #112
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1728:
	movs	r3, #6
	b	.L1756
.L1730:
	movs	r5, #0
	b	.L1701
.L1705:
	add	r3, sp, #48
	ldr	r2, [sp, #32]
	mov	r1, r8
	movs	r0, #0
	ldr	r7, [r4, #8]
	blx	r7
	adds	r0, r0, #1
	beq	.L1709
	ldr	r3, [sp, #32]
	add	r3, r3, #2048
	str	r3, [sp, #32]
.L1706:
	adds	r6, r6, #1
	add	r8, r8, #1
	b	.L1702
.L1707:
	ldr	r2, [r4, #20]
	cmp	r2, #0
	ite	eq
	moveq	fp, #6
	movne	fp, #9
	b	.L1708
.L1712:
	add	r3, sp, #48
	mov	r2, r6
	add	r1, r8, r5
	movs	r0, #0
	ldr	r7, [r4, #12]
	blx	r7
	adds	r0, r0, #1
	beq	.L1715
	ldr	r2, [sp, #52]
	movw	r3, #61424
	cmp	r2, r3
	bne	.L1715
	add	r6, r6, #2048
.L1713:
	adds	r5, r5, #1
	b	.L1711
.L1760:
	.align	2
.L1759:
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	-52655045
	.word	.LANCHOR0
	.word	.LANCHOR78
	.word	.LANCHOR184
	.word	1179535694
	.word	.LC50
.L1717:
	ldr	r3, [sp, #36]
	adds	r5, r5, #1
	cmp	r5, r3
	bne	.L1714
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #20]
	bls	.L1718
	b	.L1721
.L1691:
	cmp	r0, #64
	bne	.L1722
	ldr	fp, .L1761+4
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [fp]
	mov	r0, #262144
	bl	ftl_malloc
	ldr	r3, .L1761
	str	r0, [r3]
	ldr	r3, [fp]
	cbz	r3, .L1723
	cbz	r0, .L1723
	movs	r2, #1
	movs	r1, #0
	str	r2, [r5]
	mov	r0, r3
	mov	r2, #262144
	bl	ftl_memset
.L1722:
	ldr	r3, [r5]
	cmp	r3, #0
	beq	.L1758
	ldr	r3, .L1761+4
	cmp	r4, #63
	iteee	hi
	ldrhi	r5, .L1761+8
	rsbls	r4, r4, #64
	subls	r6, r6, r4
	addls	r7, r7, r4, lsl #9
	ldr	r1, [r3]
	mov	r2, #262144
	it	hi
	addhi	r5, r5, r4
	ldr	r0, .L1761+12
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
	b	.L1758
.L1723:
	ldr	r1, .L1761+16
	ldr	r0, .L1761+20
	bl	printf
	b	.L1722
.L1762:
	.align	2
.L1761:
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
	.section	.rodata.__func__.10001,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.10001, %object
	.size	__func__.10001, 23
__func__.10001:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.__func__.10273,"a",%progbits
	.set	.LANCHOR137,. + 0
	.type	__func__.10273, %object
	.size	__func__.10273, 15
__func__.10273:
	.ascii	"FlashReadPages\000"
	.section	.rodata.__func__.10292,"a",%progbits
	.set	.LANCHOR142,. + 0
	.type	__func__.10292, %object
	.size	__func__.10292, 15
__func__.10292:
	.ascii	"FlashProgPages\000"
	.section	.rodata.__func__.10316,"a",%progbits
	.set	.LANCHOR77,. + 0
	.type	__func__.10316, %object
	.size	__func__.10316, 17
__func__.10316:
	.ascii	"FlashEraseBlocks\000"
	.section	.rodata.__func__.10431,"a",%progbits
	.set	.LANCHOR185,. + 0
	.type	__func__.10431, %object
	.size	__func__.10431, 14
__func__.10431:
	.ascii	"FtlWriteToIDB\000"
	.section	.rodata.__func__.8925,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.8925, %object
	.size	__func__.8925, 13
__func__.8925:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.8953,"a",%progbits
	.set	.LANCHOR177,. + 0
	.type	__func__.8953, %object
	.size	__func__.8953, 9
__func__.8953:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.9028,"a",%progbits
	.set	.LANCHOR128,. + 0
	.type	__func__.9028, %object
	.size	__func__.9028, 14
__func__.9028:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.9063,"a",%progbits
	.set	.LANCHOR141,. + 0
	.type	__func__.9063, %object
	.size	__func__.9063, 11
__func__.9063:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.9178,"a",%progbits
	.set	.LANCHOR49,. + 0
	.type	__func__.9178, %object
	.size	__func__.9178, 17
__func__.9178:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.9183,"a",%progbits
	.set	.LANCHOR45,. + 0
	.type	__func__.9183, %object
	.size	__func__.9183, 17
__func__.9183:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.9214,"a",%progbits
	.set	.LANCHOR50,. + 0
	.type	__func__.9214, %object
	.size	__func__.9214, 17
__func__.9214:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.9246,"a",%progbits
	.set	.LANCHOR54,. + 0
	.type	__func__.9246, %object
	.size	__func__.9246, 22
__func__.9246:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.9255,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.9255, %object
	.size	__func__.9255, 16
__func__.9255:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.9288,"a",%progbits
	.set	.LANCHOR81,. + 0
	.type	__func__.9288, %object
	.size	__func__.9288, 26
__func__.9288:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.9299,"a",%progbits
	.set	.LANCHOR151,. + 0
	.type	__func__.9299, %object
	.size	__func__.9299, 15
__func__.9299:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.9314,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.9314, %object
	.size	__func__.9314, 31
__func__.9314:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.9328,"a",%progbits
	.set	.LANCHOR149,. + 0
	.type	__func__.9328, %object
	.size	__func__.9328, 16
__func__.9328:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.9353,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.9353, %object
	.size	__func__.9353, 22
__func__.9353:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.9370,"a",%progbits
	.set	.LANCHOR153,. + 0
	.type	__func__.9370, %object
	.size	__func__.9370, 9
__func__.9370:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.9434,"a",%progbits
	.set	.LANCHOR165,. + 0
	.type	__func__.9434, %object
	.size	__func__.9434, 15
__func__.9434:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.9456,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.9456, %object
	.size	__func__.9456, 14
__func__.9456:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.9512,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.9512, %object
	.size	__func__.9512, 15
__func__.9512:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.9534,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.9534, %object
	.size	__func__.9534, 18
__func__.9534:
	.ascii	"FtlMapTblRecovery\000"
	.section	.rodata.__func__.9580,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.9580, %object
	.size	__func__.9580, 16
__func__.9580:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.9614,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.9614, %object
	.size	__func__.9614, 22
__func__.9614:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.9671,"a",%progbits
	.set	.LANCHOR60,. + 0
	.type	__func__.9671, %object
	.size	__func__.9671, 16
__func__.9671:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.9692,"a",%progbits
	.set	.LANCHOR136,. + 0
	.type	__func__.9692, %object
	.size	__func__.9692, 18
__func__.9692:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.9719,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.9719, %object
	.size	__func__.9719, 14
__func__.9719:
	.ascii	"ftl_check_vpc\000"
	.section	.rodata.__func__.9784,"a",%progbits
	.set	.LANCHOR144,. + 0
	.type	__func__.9784, %object
	.size	__func__.9784, 25
__func__.9784:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.9805,"a",%progbits
	.set	.LANCHOR168,. + 0
	.type	__func__.9805, %object
	.size	__func__.9805, 29
__func__.9805:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.9812,"a",%progbits
	.set	.LANCHOR61,. + 0
	.type	__func__.9812, %object
	.size	__func__.9812, 19
__func__.9812:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.9825,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.9825, %object
	.size	__func__.9825, 16
__func__.9825:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.9832,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.9832, %object
	.size	__func__.9832, 20
__func__.9832:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.9902,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.9902, %object
	.size	__func__.9902, 19
__func__.9902:
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
