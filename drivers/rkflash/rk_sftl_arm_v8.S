/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 * date: 2018-08-02
 */
	.arch armv8-a+nosimd
	.file	"rk_sftl.c"
	.section	.text.l2p_addr_tran.isra.0,"ax",@progbits
	.align	2
	.type	l2p_addr_tran.isra.0, %function
l2p_addr_tran.isra.0:
	adrp	x4, .LANCHOR0
	add	x4, x4, :lo12:.LANCHOR0
	ldrh	w3, [x4, 8]
	ldrh	w6, [x4, 10]
	ldrh	w4, [x4, 14]
	cmp	w4, 4
	bne	.L2
	lsr	w3, w3, 1
	ubfiz	w6, w6, 1, 15
.L2:
	lsr	w5, w0, 10
	and	w0, w0, 1023
	and	w4, w5, 65535
	and	w5, w5, 65535
	udiv	w4, w4, w3
	msub	w3, w3, w4, w5
	madd	w3, w3, w6, w0
	mov	w0, 0
	str	w3, [x1]
	str	w4, [x2]
	ret
	.size	l2p_addr_tran.isra.0, .-l2p_addr_tran.isra.0
	.section	.text.ftl_set_blk_mode.part.6,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.6, %function
ftl_set_blk_mode.part.6:
	and	w0, w0, 65535
	adrp	x2, .LANCHOR1
	ubfx	x1, x0, 5, 11
	ldr	x3, [x2, #:lo12:.LANCHOR1]
	lsl	x1, x1, 2
	mov	w2, 1
	lsl	w2, w2, w0
	ldr	w0, [x3, x1]
	orr	w0, w0, w2
	str	w0, [x3, x1]
	ret
	.size	ftl_set_blk_mode.part.6, .-ftl_set_blk_mode.part.6
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
	mov	w2, 1
	mov	w1, 0
.L5:
	cmp	w2, w0
	bls	.L6
	sub	w0, w1, #1
	ret
.L6:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L5
	.size	Ftl_log2, .-Ftl_log2
	.section	.text.FtlPrintInfo,"ax",@progbits
	.align	2
	.global	FtlPrintInfo
	.type	FtlPrintInfo, %function
FtlPrintInfo:
	ret
	.size	FtlPrintInfo, .-FtlPrintInfo
	.section	.text.FtlSysBlkNumInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkNumInit
	.type	FtlSysBlkNumInit, %function
FtlSysBlkNumInit:
	and	w0, w0, 65535
	mov	w1, 24
	cmp	w0, 24
	adrp	x2, .LANCHOR4
	csel	w0, w0, w1, cs
	adrp	x1, .LANCHOR2
	and	w0, w0, 65535
	str	w0, [x1, #:lo12:.LANCHOR2]
	adrp	x1, .LANCHOR3
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	mul	w1, w1, w0
	str	w1, [x2, #:lo12:.LANCHOR4]
	adrp	x2, .LANCHOR6
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	sub	w0, w2, w0
	adrp	x2, .LANCHOR5
	strh	w0, [x2, #:lo12:.LANCHOR5]
	adrp	x0, .LANCHOR8
	ldr	w0, [x0, #:lo12:.LANCHOR8]
	sub	w1, w0, w1
	adrp	x0, .LANCHOR7
	str	w1, [x0, #:lo12:.LANCHOR7]
	mov	w0, 0
	ret
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.section	.text.FtlConstantsInit,"ax",@progbits
	.align	2
	.global	FtlConstantsInit
	.type	FtlConstantsInit, %function
FtlConstantsInit:
	stp	x29, x30, [sp, -16]!
	mov	x5, x0
	adrp	x1, .LANCHOR11
	add	x29, sp, 0
	ldrh	w2, [x0]
	adrp	x0, .LANCHOR9
	ldrh	w4, [x5, 2]
	strh	w2, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LANCHOR10
	strh	w4, [x0, #:lo12:.LANCHOR10]
	ldrh	w0, [x5, 4]
	strh	w0, [x1, #:lo12:.LANCHOR11]
	ldrh	w1, [x5, 14]
	cmp	w1, 4
	bne	.L10
	ldrh	w1, [x5, 6]
	adrp	x3, .LANCHOR6
	lsr	w1, w1, 1
	strh	w1, [x3, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR12
	mov	w3, 8
	strh	w3, [x1, #:lo12:.LANCHOR12]
.L10:
	adrp	x3, .LANCHOR13
	add	x3, x3, :lo12:.LANCHOR13
	mov	x1, 0
.L11:
	strb	w1, [x1, x3]
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L11
	adrp	x1, .LANCHOR14
	mov	w3, 5
	cmp	w2, 1
	strh	w3, [x1, #:lo12:.LANCHOR14]
	adrp	x3, .LANCHOR15
	strh	wzr, [x3, #:lo12:.LANCHOR15]
	bne	.L12
	strh	w2, [x1, #:lo12:.LANCHOR14]
.L12:
	adrp	x1, .LANCHOR16
	mov	w2, 640
	mul	w4, w4, w0
	strh	w2, [x1, #:lo12:.LANCHOR16]
	adrp	x1, .LANCHOR3
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR3]
	adrp	x1, .LANCHOR6
	ldrh	w3, [x1, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR17
	mul	w0, w0, w3
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR17]
	bl	Ftl_log2
	ldrh	w7, [x5, 12]
	adrp	x1, .LANCHOR18
	adrp	x8, .LANCHOR19
	strh	w0, [x1, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR20
	mul	w1, w4, w7
	strh	w7, [x8, #:lo12:.LANCHOR19]
	strh	w7, [x0, #:lo12:.LANCHOR20]
	adrp	x0, .LANCHOR21
	strh	w1, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LANCHOR12
	ldrh	w6, [x0, #:lo12:.LANCHOR12]
	mov	w0, w6
	bl	Ftl_log2
	and	w1, w0, 65535
	adrp	x2, .LANCHOR22
	adrp	x10, .LANCHOR23
	ldrh	w5, [x5, 20]
	strh	w0, [x2, #:lo12:.LANCHOR22]
	ubfiz	w0, w6, 9, 7
	strh	w0, [x10, #:lo12:.LANCHOR23]
	adrp	x10, .LANCHOR24
	ubfx	w0, w0, 8, 8
	strh	w0, [x10, #:lo12:.LANCHOR24]
	adrp	x0, .LANCHOR25
	strh	w5, [x0, #:lo12:.LANCHOR25]
	mul	w0, w4, w3
	adrp	x5, .LANCHOR8
	str	w0, [x5, #:lo12:.LANCHOR8]
	adrp	x5, .LANCHOR26
	mul	w0, w0, w6
	mul	w6, w6, w7
	mul	w0, w0, w7
	mov	x7, x2
	asr	w0, w0, 11
	str	w0, [x5, #:lo12:.LANCHOR26]
	mov	w0, 5120
	adrp	x5, .LANCHOR27
	sdiv	w0, w0, w6
	and	w0, w0, 65535
	cmp	w0, 4
	bls	.L13
.L19:
	strh	w0, [x5, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR28
	mov	w0, 640
	lsl	w3, w3, 6
	asr	w0, w0, w1
	add	w0, w0, 2
	add	w1, w1, 9
	strh	w0, [x2, #:lo12:.LANCHOR28]
	adrp	x0, .LANCHOR29
	cmp	w4, 1
	asr	w3, w3, w1
	adrp	x1, .LANCHOR30
	strh	w3, [x0, #:lo12:.LANCHOR29]
	and	w3, w3, 65535
	adrp	x6, .LANCHOR2
	mul	w0, w3, w4
	add	w3, w3, 8
	str	w0, [x1, #:lo12:.LANCHOR30]
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	beq	.L15
.L20:
	str	w3, [x6, #:lo12:.LANCHOR2]
	ldrh	w0, [x6, #:lo12:.LANCHOR2]
	bl	FtlSysBlkNumInit
	ldr	w1, [x6, #:lo12:.LANCHOR2]
	adrp	x0, .LANCHOR31
	ldp	x29, x30, [sp], 16
	str	w1, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LANCHOR7
	ldrh	w1, [x8, #:lo12:.LANCHOR19]
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	lsl	w0, w0, 2
	mul	w0, w0, w1
	ldrh	w1, [x7, #:lo12:.LANCHOR22]
	add	w1, w1, 9
	lsr	w0, w0, w1
	adrp	x1, .LANCHOR32
	add	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR32]
	adrp	x0, .LANCHOR33
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR34
	str	wzr, [x0, #:lo12:.LANCHOR34]
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	add	w0, w0, 3
	strh	w0, [x5, #:lo12:.LANCHOR27]
	ldr	w0, [x4, #:lo12:.LANCHOR30]
	add	w0, w0, 3
	str	w0, [x4, #:lo12:.LANCHOR30]
	mov	w0, 0
	ret
.L13:
	mov	w0, 4
	b	.L19
.L15:
	add	w3, w3, 4
	b	.L20
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	adrp	x1, .LANCHOR35
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L25
	adrp	x1, .LANCHOR27
	ldrh	w2, [x1, #:lo12:.LANCHOR27]
	adrp	x1, .LANCHOR36
	ldr	x3, [x1, #:lo12:.LANCHOR36]
	mov	x1, 0
.L23:
	cmp	w2, w1, uxth
	bhi	.L24
.L25:
	mov	w0, 0
	ret
.L24:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L23
	mov	w0, 1
	ret
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlCacheWriteBack,"ax",@progbits
	.align	2
	.global	FtlCacheWriteBack
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
	mov	w0, 0
	ret
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.sftl_get_density,"ax",@progbits
	.align	2
	.global	sftl_get_density
	.type	sftl_get_density, %function
sftl_get_density:
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	ret
	.size	sftl_get_density, .-sftl_get_density
	.section	.text.FtlBbmMapBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmMapBadBlock
	.type	FtlBbmMapBadBlock, %function
FtlBbmMapBadBlock:
	stp	x29, x30, [sp, -32]!
	and	w1, w0, 65535
	adrp	x0, .LANCHOR17
	mov	w4, 1
	add	x29, sp, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR37
	add	x19, x19, :lo12:.LANCHOR37
	udiv	w3, w1, w0
	and	w2, w3, 65535
	msub	w3, w3, w0, w1
	add	x0, x19, x2, uxth 3
	and	w3, w3, 65535
	ldr	x0, [x0, 32]
	ubfx	x5, x3, 5, 11
	lsl	x5, x5, 2
	lsl	w4, w4, w3
	ldr	w6, [x0, x5]
	orr	w4, w4, w6
	str	w4, [x0, x5]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrh	w0, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 6]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlBbmMapBadBlock, .-FtlBbmMapBadBlock
	.section	.text.FtlBbmIsBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmIsBadBlock
	.type	FtlBbmIsBadBlock, %function
FtlBbmIsBadBlock:
	adrp	x1, .LANCHOR17
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR17]
	udiv	w2, w0, w1
	msub	w0, w2, w1, w0
	adrp	x1, .LANCHOR37
	add	x1, x1, :lo12:.LANCHOR37
	add	x2, x1, x2, uxth 3
	and	w0, w0, 65535
	ubfx	x3, x0, 5, 11
	ldr	x1, [x2, 32]
	ldr	w1, [x1, x3, lsl 2]
	lsr	w0, w1, w0
	and	w0, w0, 1
	ret
	.size	FtlBbmIsBadBlock, .-FtlBbmIsBadBlock
	.section	.text.FtlBbtInfoPrint,"ax",@progbits
	.align	2
	.global	FtlBbtInfoPrint
	.type	FtlBbtInfoPrint, %function
FtlBbtInfoPrint:
	ret
	.size	FtlBbtInfoPrint, .-FtlBbtInfoPrint
	.section	.text.FtlBbtCalcTotleCnt,"ax",@progbits
	.align	2
	.global	FtlBbtCalcTotleCnt
	.type	FtlBbtCalcTotleCnt, %function
FtlBbtCalcTotleCnt:
	adrp	x0, .LANCHOR17
	mov	w4, 0
	mov	w5, 0
	ldrh	w6, [x0, #:lo12:.LANCHOR17]
	adrp	x0, .LANCHOR10
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	mul	w6, w6, w0
	cmp	w4, w6
	blt	.L43
	mov	w0, w5
	ret
.L43:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L36:
	mov	w0, w4
	bl	FtlBbmIsBadBlock
	cbz	w0, .L35
	add	w5, w5, 1
	and	w5, w5, 65535
.L35:
	add	w4, w4, 1
	and	w4, w4, 65535
	cmp	w4, w6
	blt	.L36
	mov	w0, w5
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlBbtCalcTotleCnt, .-FtlBbtCalcTotleCnt
	.section	.text.V2P_block,"ax",@progbits
	.align	2
	.global	V2P_block
	.type	V2P_block, %function
V2P_block:
	adrp	x2, .LANCHOR11
	and	w0, w0, 65535
	adrp	x4, .LANCHOR17
	and	w1, w1, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR11]
	ldrh	w4, [x4, #:lo12:.LANCHOR17]
	udiv	w3, w0, w2
	msub	w0, w3, w2, w0
	madd	w2, w2, w1, w0
	madd	w0, w3, w4, w2
	ret
	.size	V2P_block, .-V2P_block
	.section	.text.P2V_plane,"ax",@progbits
	.align	2
	.global	P2V_plane
	.type	P2V_plane, %function
P2V_plane:
	and	w3, w0, 65535
	adrp	x0, .LANCHOR11
	ldrh	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LANCHOR17
	ldrh	w2, [x0, #:lo12:.LANCHOR17]
	udiv	w0, w3, w1
	udiv	w2, w3, w2
	msub	w0, w0, w1, w3
	madd	w0, w1, w2, w0
	ret
	.size	P2V_plane, .-P2V_plane
	.section	.text.P2V_block_in_plane,"ax",@progbits
	.align	2
	.global	P2V_block_in_plane
	.type	P2V_block_in_plane, %function
P2V_block_in_plane:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR17
	ldrh	w1, [x0, #:lo12:.LANCHOR17]
	udiv	w0, w2, w1
	msub	w0, w0, w1, w2
	adrp	x1, .LANCHOR11
	ldrh	w1, [x1, #:lo12:.LANCHOR11]
	and	w0, w0, 65535
	udiv	w0, w0, w1
	ret
	.size	P2V_block_in_plane, .-P2V_block_in_plane
	.section	.text.ftl_cmp_data_ver,"ax",@progbits
	.align	2
	.global	ftl_cmp_data_ver
	.type	ftl_cmp_data_ver, %function
ftl_cmp_data_ver:
	cmp	w0, w1
	mov	w2, -2147483648
	bls	.L48
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L48:
	sub	w1, w1, w0
	cmp	w1, w2
	cset	w0, hi
	ret
	.size	ftl_cmp_data_ver, .-ftl_cmp_data_ver
	.section	.text.FtlFreeSysBlkQueueEmpty,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueEmpty
	.type	FtlFreeSysBlkQueueEmpty, %function
FtlFreeSysBlkQueueEmpty:
	adrp	x0, .LANCHOR38+6
	ldrh	w0, [x0, #:lo12:.LANCHOR38+6]
	cmp	w0, 0
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueFull
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	adrp	x0, .LANCHOR38+6
	ldrh	w0, [x0, #:lo12:.LANCHOR38+6]
	cmp	w0, 1024
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
	.section	.text.FtlFreeSysBLkSort,"ax",@progbits
	.align	2
	.global	FtlFreeSysBLkSort
	.type	FtlFreeSysBLkSort, %function
FtlFreeSysBLkSort:
	adrp	x0, .LANCHOR38
	add	x1, x0, :lo12:.LANCHOR38
	ldrh	w2, [x1, 6]
	cbz	w2, .L52
	adrp	x2, .LANCHOR39+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR39+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L54:
	cmp	w5, w4
	bgt	.L55
	cbz	w6, .L52
	add	x0, x0, :lo12:.LANCHOR38
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.L52:
	ret
.L55:
	add	x6, x1, x3, sxtw 1
	add	w4, w4, 1
	add	w3, w3, 1
	and	w4, w4, 65535
	and	w3, w3, 1023
	ldrh	w7, [x6, 8]
	add	x6, x1, x2, sxtw 1
	strh	w7, [x6, 8]
	mov	w6, 1
	add	w2, w2, w6
	and	w2, w2, 1023
	b	.L54
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.IsInFreeQueue,"ax",@progbits
	.align	2
	.global	IsInFreeQueue
	.type	IsInFreeQueue, %function
IsInFreeQueue:
	adrp	x1, .LANCHOR38
	add	x1, x1, :lo12:.LANCHOR38
	and	w0, w0, 65535
	ldrh	w4, [x1, 6]
	cmp	w4, 1024
	beq	.L65
	ldrh	w5, [x1, 2]
	mov	w3, 0
.L63:
	cmp	w3, w4
	bcc	.L64
.L65:
	mov	w0, 0
	ret
.L64:
	add	w2, w3, w5
	ubfiz	x2, x2, 1, 10
	add	x2, x1, x2
	ldrh	w2, [x2, 8]
	cmp	w2, w0
	beq	.L66
	add	w3, w3, 1
	b	.L63
.L66:
	mov	w0, 1
	ret
	.size	IsInFreeQueue, .-IsInFreeQueue
	.section	.text.insert_data_list,"ax",@progbits
	.align	2
	.global	insert_data_list
	.type	insert_data_list, %function
insert_data_list:
	adrp	x1, .LANCHOR5
	and	w0, w0, 65535
	ldrh	w14, [x1, #:lo12:.LANCHOR5]
	cmp	w14, w0
	bls	.L83
	adrp	x1, .LANCHOR40
	mov	w3, 6
	ldr	x6, [x1, #:lo12:.LANCHOR40]
	umull	x13, w0, w3
	mov	w1, -1
	add	x5, x6, x13
	strh	w1, [x5, 2]
	strh	w1, [x6, x13]
	adrp	x1, .LANCHOR41
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR41]
	cbnz	x12, .L70
	str	x5, [x1, #:lo12:.LANCHOR41]
.L83:
	mov	w0, 0
	ret
.L70:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR42
	ubfiz	x2, x0, 1, 16
	mov	x4, -6148914691236517206
	add	x29, sp, 0
	ldr	x16, [x1, #:lo12:.LANCHOR42]
	movk	x4, 0xaaab, lsl 0
	ldrh	w1, [x5, 4]
	mov	w8, -1
	mov	w11, w8
	stp	x19, x20, [sp, 16]
	cmp	w1, 0
	mov	w20, 65535
	ldrh	w7, [x16, x2]
	mul	w7, w7, w1
	sub	x1, x12, x6
	asr	x1, x1, 1
	csel	w7, w7, w8, ne
	mov	w8, w3
	mul	x1, x1, x4
	adrp	x4, .LANCHOR43
	ldr	x17, [x4, #:lo12:.LANCHOR43]
	and	w1, w1, 65535
	mov	x4, x12
	add	x10, x17, x2
	mov	w2, 0
.L78:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L69
	cmp	w1, w0
	beq	.L69
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L74
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L76
.L75:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L79
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR41]
	b	.L69
.L74:
	bcc	.L75
.L76:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L77
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR44
	str	x5, [x0, #:lo12:.LANCHOR44]
.L69:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L77:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L78
.L79:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L69
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_data_list
	adrp	x1, .LANCHOR45
	ldrh	w0, [x1, #:lo12:.LANCHOR45]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR45]
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L85
	ldp	x29, x30, [sp], 16
	mov	w2, 221
	adrp	x1, .LANCHOR46
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC1
	b	printf
.L85:
	ldp	x29, x30, [sp], 16
	ret
	.size	INSERT_DATA_LIST, .-INSERT_DATA_LIST
	.section	.text.insert_free_list,"ax",@progbits
	.align	2
	.global	insert_free_list
	.type	insert_free_list, %function
insert_free_list:
	and	w0, w0, 65535
	mov	w7, 65535
	cmp	w0, w7
	beq	.L89
	adrp	x1, .LANCHOR40
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR40]
	umull	x8, w0, w6
	mov	w1, -1
	add	x4, x3, x8
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	adrp	x1, .LANCHOR47
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR47]
	cbnz	x5, .L90
	str	x4, [x1, #:lo12:.LANCHOR47]
.L89:
	mov	w0, 0
	ret
.L90:
	adrp	x1, .LANCHOR43
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR43]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.L93:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L91
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L92
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L89
.L92:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L93
.L91:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L94
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR47]
	b	.L89
.L94:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L89
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_free_list
	adrp	x1, .LANCHOR48
	ldrh	w0, [x1, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR48]
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L95
	ldp	x29, x30, [sp], 16
	mov	w2, 214
	adrp	x1, .LANCHOR49
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC1
	b	printf
.L95:
	ldp	x29, x30, [sp], 16
	ret
	.size	INSERT_FREE_LIST, .-INSERT_FREE_LIST
	.section	.text.List_remove_node,"ax",@progbits
	.align	2
	.global	List_remove_node
	.type	List_remove_node, %function
List_remove_node:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR40
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	mov	w0, 6
	str	x23, [sp, 48]
	ldr	x23, [x20, #:lo12:.LANCHOR40]
	umull	x21, w1, w0
	mov	w0, 65535
	add	x19, x23, x21
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bne	.L99
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L99
	adrp	x1, .LANCHOR50
	adrp	x0, .LC1
	mov	w2, 379
	add	x1, x1, :lo12:.LANCHOR50
	add	x0, x0, :lo12:.LC1
	bl	printf
.L99:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L100
	cmp	w0, w1
	bne	.L101
	str	xzr, [x22]
.L102:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L101:
	ldr	x1, [x20, #:lo12:.LANCHOR40]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L102
.L100:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L103
	cmp	w1, w0
	beq	.L102
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	strh	w2, [x0, x1]
	b	.L102
.L103:
	ldr	x2, [x20, #:lo12:.LANCHOR40]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L102
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L111
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR40
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR40]
.L107:
	cbnz	w1, .L108
.L110:
	sub	x19, x2, x19
	mov	x2, -6148914691236517206
	asr	x19, x19, 1
	movk	x2, 0xaaab, lsl 0
	mul	x19, x19, x2
	and	w19, w19, 65535
	mov	w1, w19
	bl	List_remove_node
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L108:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L110
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L107
.L111:
	mov	w0, 65535
	ret
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_pop_head_node,"ax",@progbits
	.align	2
	.global	List_pop_head_node
	.type	List_pop_head_node, %function
List_pop_head_node:
	mov	w1, 0
	b	List_pop_index_node
	.size	List_pop_head_node, .-List_pop_head_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR41
	ldr	x1, [x0, #:lo12:.LANCHOR41]
	cbz	x1, .L122
	adrp	x0, .LANCHOR40
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR40]
	mov	w0, 65535
.L119:
	cbz	w2, .L120
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L121
	ret
.L121:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L119
.L122:
	mov	w0, 65535
	ret
.L120:
	sub	x0, x1, x3
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	and	w0, w0, 65535
	ret
	.size	List_get_gc_head_node, .-List_get_gc_head_node
	.section	.text.List_update_data_list,"ax",@progbits
	.align	2
	.global	List_update_data_list
	.type	List_update_data_list, %function
List_update_data_list:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	adrp	x0, .LANCHOR51
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	stp	x25, x26, [sp, 64]
	cmp	w0, w19
	beq	.L125
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L125
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L125
	adrp	x0, .LANCHOR40
	mov	w21, 6
	adrp	x24, .LANCHOR41
	mov	x26, x0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR40]
	ldr	x1, [x24, #:lo12:.LANCHOR41]
	add	x22, x23, x21
	cmp	x22, x1
	beq	.L125
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	mov	x25, x1
	ldr	x2, [x1, #:lo12:.LANCHOR42]
	mov	w1, 65535
	ldrh	w20, [x2, x0]
	ldrh	w0, [x22, 4]
	cmp	w0, 0
	mul	w20, w20, w0
	ldrh	w0, [x22, 2]
	csinv	w20, w20, wzr, ne
	cmp	w0, w1
	bne	.L128
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L128
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 470
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.L128:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L129
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L125
.L129:
	mov	w1, 6
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	umull	x0, w0, w1
	asr	x1, x0, 1
	mul	x1, x1, x2
	ldr	x2, [x25, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1, lsl 1]
	ldr	x2, [x26, #:lo12:.LANCHOR40]
	add	x0, x2, x0
	ldrh	w2, [x0, 4]
	cmp	w2, 0
	mul	w0, w1, w2
	csinv	w0, w0, wzr, ne
	cmp	w20, w0
	bcs	.L125
	adrp	x20, .LANCHOR45
	mov	w1, w19
	add	x0, x24, :lo12:.LANCHOR41
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L131
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 481
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.L131:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L125:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR33
	mov	x1, 0
	mov	w3, 65535
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR55
	str	x19, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR55]
.L136:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L138
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L139:
	cmp	w1, w2
	bne	.L141
	cmp	w19, w2
	bcc	.L137
	adrp	x1, .LANCHOR56
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR56]
	mov	w1, 0
.L142:
	cmp	w1, w2
	bne	.L144
	cmp	w19, w1
	bcc	.L137
	mov	w2, 784
	adrp	x1, .LANCHOR57
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR57
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L137
.L138:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L136
.L137:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L141:
	ldr	w4, [x3]
	tbnz	w4, #31, .L140
	cmp	w5, w4
	bls	.L140
	mov	w5, w4
	mov	w19, w1
.L140:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L139
.L144:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L143
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L143:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L142
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	adrp	x2, .LANCHOR58
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR58]
	cmp	w1, 4
	bhi	.L147
	cbnz	w0, .L147
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR58]
	ret
.L147:
	adrp	x1, .LANCHOR5
	adrp	x0, .LANCHOR59
	strh	wzr, [x3, #:lo12:.LANCHOR58]
	mov	w2, 0
	ldrh	w5, [x1, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR42
	str	wzr, [x0, #:lo12:.LANCHOR59]
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR42]
	mov	w7, 65535
	mov	x1, 0
.L148:
	cmp	w5, w1, uxth
	bhi	.L150
	cbz	w3, .L146
	str	w2, [x0, #:lo12:.LANCHOR59]
.L146:
	ret
.L150:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L149
	add	w2, w2, w4
	mov	w3, 1
.L149:
	add	x1, x1, 1
	b	.L148
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L157
	b	ftl_set_blk_mode.part.6
.L157:
	adrp	x1, .LANCHOR1
	ubfx	x2, x0, 5, 11
	lsl	x2, x2, 2
	ldr	x3, [x1, #:lo12:.LANCHOR1]
	mov	w1, 1
	lsl	w0, w1, w0
	ldr	w1, [x3, x2]
	bic	w0, w1, w0
	str	w0, [x3, x2]
	ret
	.size	ftl_set_blk_mode, .-ftl_set_blk_mode
	.section	.text.ftl_get_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_get_blk_mode
	.type	ftl_get_blk_mode, %function
ftl_get_blk_mode:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR1
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	ubfx	x2, x1, 5, 11
	ldr	w0, [x0, x2, lsl 2]
	lsr	w0, w0, w1
	and	w0, w0, 1
	ret
	.size	ftl_get_blk_mode, .-ftl_get_blk_mode
	.section	.text.ftl_sb_update_avl_pages,"ax",@progbits
	.align	2
	.global	ftl_sb_update_avl_pages
	.type	ftl_sb_update_avl_pages, %function
ftl_sb_update_avl_pages:
	and	w2, w2, 65535
	and	w6, w1, 65535
	ubfiz	x4, x2, 1, 16
	adrp	x1, .LANCHOR3
	add	x4, x4, 16
	strh	wzr, [x0, 4]
	add	x4, x0, x4
	ldrh	w3, [x1, #:lo12:.LANCHOR3]
	mov	w1, 65535
.L160:
	cmp	w2, w3
	bcc	.L162
	adrp	x1, .LANCHOR19
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	add	x3, x0, x3
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	sub	w1, w1, w6
.L163:
	cmp	x2, x3
	bne	.L165
	ret
.L162:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L161
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L161:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L160
.L165:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L164
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L164:
	add	x2, x2, 2
	b	.L163
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	ldrh	w1, [x0, 4]
	cbz	w1, .L166
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L166
	ldrb	w2, [x0, 6]
	add	x2, x2, 8
	ldrh	w3, [x0, x2, lsl 1]
	adrp	x2, .LANCHOR3
	ldrh	w4, [x2, #:lo12:.LANCHOR3]
	mov	w2, w1
.L169:
	cmp	w3, w2
	beq	.L171
.L166:
	ret
.L171:
	ldrb	w1, [x0, 6]
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x0, 6]
	cmp	w1, w4
	bne	.L170
	ldrh	w1, [x0, 2]
	strb	wzr, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 2]
.L170:
	ldrb	w1, [x0, 6]
	add	x1, x1, 8
	ldrh	w3, [x0, x1, lsl 1]
	b	.L169
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.make_superblock,"ax",@progbits
	.align	2
	.global	make_superblock
	.type	make_superblock, %function
make_superblock:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldrh	w1, [x0]
	str	x19, [sp, 16]
	mov	x19, x0
	adrp	x0, .LANCHOR5
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcc	.L173
	adrp	x1, .LANCHOR60
	adrp	x0, .LC1
	mov	w2, 2097
	add	x1, x1, :lo12:.LANCHOR60
	add	x0, x0, :lo12:.LC1
	bl	printf
.L173:
	adrp	x0, .LANCHOR3
	adrp	x7, .LANCHOR13
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR13
	ldrh	w8, [x0, #:lo12:.LANCHOR3]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L174:
	cmp	w8, w5, uxth
	bhi	.L176
	adrp	x1, .LANCHOR19
	ldrb	w0, [x19, 7]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	mov	w0, 1
	strb	w0, [x19, 9]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L176:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L175
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L175:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L174
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",@progbits
	.align	2
	.global	update_multiplier_value
	.type	update_multiplier_value, %function
update_multiplier_value:
	and	w6, w0, 65535
	adrp	x0, .LANCHOR3
	mov	x7, 0
	adrp	x8, .LANCHOR13
	ldrh	w10, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR19
	mov	w5, 0
	add	x8, x8, :lo12:.LANCHOR13
	ldrh	w11, [x0, #:lo12:.LANCHOR19]
	cmp	w10, w7, uxth
	bhi	.L190
	cbz	w5, .L188
	mov	w0, 32768
	sdiv	w5, w0, w5
.L189:
	adrp	x0, .LANCHOR40
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L183:
	mov	w5, 0
	b	.L182
.L188:
	mov	w5, 0
	b	.L189
.L190:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L181:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L180
	add	w5, w5, w11
	and	w5, w5, 65535
.L180:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L181
	cbz	w5, .L183
	mov	w0, 32768
	sdiv	w5, w0, w5
.L182:
	adrp	x0, .LANCHOR40
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ldp	x29, x30, [sp], 16
	ret
	.size	update_multiplier_value, .-update_multiplier_value
	.section	.text.GetFreeBlockMinEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMinEraseCount
	.type	GetFreeBlockMinEraseCount, %function
GetFreeBlockMinEraseCount:
	adrp	x0, .LANCHOR47
	ldr	x0, [x0, #:lo12:.LANCHOR47]
	cbz	x0, .L193
	adrp	x1, .LANCHOR40
	ldr	x1, [x1, #:lo12:.LANCHOR40]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR43
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
	ret
.L193:
	mov	w0, 0
	ret
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMaxEraseCount
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	adrp	x1, .LANCHOR47
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR47]
	cbz	x1, .L201
	adrp	x2, .LANCHOR48
	mov	w3, 7
	mov	w5, 6
	mov	w6, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR48]
	mul	w2, w2, w3
	asr	w2, w2, 3
	cmp	w0, w2
	csel	w0, w2, w0, gt
	adrp	x2, .LANCHOR40
	ldr	x3, [x2, #:lo12:.LANCHOR40]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	w2, 0
	and	w1, w1, 65535
.L197:
	cmp	w0, w2
	beq	.L200
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L198
.L200:
	adrp	x0, .LANCHOR43
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x0, x1]
	ret
.L198:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L197
.L201:
	mov	w0, 0
	ret
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.FtlPrintInfo2buf,"ax",@progbits
	.align	2
	.global	FtlPrintInfo2buf
	.type	FtlPrintInfo2buf, %function
FtlPrintInfo2buf:
	stp	x29, x30, [sp, -96]!
	adrp	x1, .LC2
	add	x1, x1, :lo12:.LC2
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR37
	stp	x21, x22, [sp, 32]
	mov	x21, x0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR48
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR39
	str	x27, [sp, 80]
	bl	sprintf
	add	x20, x21, x0, sxtw
	adrp	x0, .LANCHOR26
	adrp	x1, .LC3
	add	x1, x1, :lo12:.LC3
	ldr	w2, [x0, #:lo12:.LANCHOR26]
	mov	x0, x20
	add	x22, x22, :lo12:.LANCHOR39
	adrp	x24, .LANCHOR51
	adrp	x25, .LANCHOR80
	bl	sprintf
	add	x20, x20, x0, sxtw
	mov	x0, x20
	adrp	x1, .LC4
	add	x1, x1, :lo12:.LC4
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR61
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	ldr	w2, [x0, #:lo12:.LANCHOR61]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR59
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	ldr	w2, [x0, #:lo12:.LANCHOR59]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR62
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR63
	adrp	x1, .LC8
	add	x1, x1, :lo12:.LC8
	ldr	w2, [x0, #:lo12:.LANCHOR63]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR64
	adrp	x1, .LC9
	add	x1, x1, :lo12:.LC9
	ldr	w2, [x0, #:lo12:.LANCHOR64]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR65
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	ldr	w2, [x0, #:lo12:.LANCHOR65]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR66
	adrp	x1, .LC11
	add	x1, x1, :lo12:.LC11
	ldr	w2, [x0, #:lo12:.LANCHOR66]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR67
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	ldr	w2, [x0, #:lo12:.LANCHOR67]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR68
	adrp	x1, .LC13
	add	x1, x1, :lo12:.LC13
	ldr	w2, [x0, #:lo12:.LANCHOR68]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR69
	adrp	x1, .LC14
	add	x1, x1, :lo12:.LC14
	ldr	w2, [x0, #:lo12:.LANCHOR69]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR70
	adrp	x1, .LC15
	add	x1, x1, :lo12:.LC15
	ldr	w2, [x0, #:lo12:.LANCHOR70]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR71
	adrp	x1, .LC16
	add	x1, x1, :lo12:.LC16
	ldr	w2, [x0, #:lo12:.LANCHOR71]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	add	x0, x19, :lo12:.LANCHOR37
	adrp	x1, .LC17
	add	x1, x1, :lo12:.LC17
	ldrh	w2, [x0, 6]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x23, #:lo12:.LANCHOR48]
	mov	x0, x20
	adrp	x1, .LC18
	add	x1, x1, :lo12:.LC18
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR72
	adrp	x1, .LC19
	add	x1, x1, :lo12:.LC19
	ldr	w2, [x0, #:lo12:.LANCHOR72]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR73
	adrp	x1, .LC20
	add	x1, x1, :lo12:.LC20
	ldr	w2, [x0, #:lo12:.LANCHOR73]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR74
	adrp	x1, .LC21
	add	x1, x1, :lo12:.LC21
	ldr	w2, [x0, #:lo12:.LANCHOR74]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR75
	adrp	x1, .LC22
	add	x1, x1, :lo12:.LC22
	ldr	w2, [x0, #:lo12:.LANCHOR75]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR76
	adrp	x1, .LC23
	add	x1, x1, :lo12:.LC23
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR77
	adrp	x1, .LC24
	add	x1, x1, :lo12:.LC24
	ldr	w2, [x0, #:lo12:.LANCHOR77]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x22, 30]
	mov	x0, x20
	adrp	x1, .LC25
	add	x1, x1, :lo12:.LC25
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x22, 28]
	mov	x0, x20
	adrp	x1, .LC26
	add	x1, x1, :lo12:.LC26
	adrp	x22, .LANCHOR42
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR34
	adrp	x1, .LC27
	add	x1, x1, :lo12:.LC27
	ldr	w2, [x0, #:lo12:.LANCHOR34]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR31
	adrp	x1, .LC28
	add	x1, x1, :lo12:.LC28
	ldr	w2, [x0, #:lo12:.LANCHOR31]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR2
	adrp	x1, .LC29
	add	x1, x1, :lo12:.LC29
	ldr	w2, [x0, #:lo12:.LANCHOR2]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR38+6
	adrp	x1, .LC30
	add	x1, x1, :lo12:.LC30
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR5
	adrp	x1, .LC31
	add	x1, x1, :lo12:.LC31
	ldrh	w2, [x0, #:lo12:.LANCHOR5]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR78
	adrp	x1, .LC32
	add	x1, x1, :lo12:.LC32
	ldrh	w2, [x0, #:lo12:.LANCHOR78]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR7
	adrp	x1, .LC33
	add	x1, x1, :lo12:.LC33
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR79
	adrp	x1, .LC34
	add	x1, x1, :lo12:.LC34
	ldrh	w2, [x0, #:lo12:.LANCHOR79]
	mov	x0, x20
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, #:lo12:.LANCHOR37]
	add	x19, x24, :lo12:.LANCHOR51
	mov	x0, x20
	adrp	x1, .LC35
	add	x1, x1, :lo12:.LC35
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC37
	add	x1, x1, :lo12:.LC37
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x24, #:lo12:.LANCHOR51]
	mov	x0, x20
	adrp	x1, .LC38
	add	x1, x1, :lo12:.LC38
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC39
	add	x1, x1, :lo12:.LC39
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC40
	add	x1, x1, :lo12:.LC40
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w1, [x24, #:lo12:.LANCHOR51]
	adrp	x24, .LANCHOR52
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	add	x19, x24, :lo12:.LANCHOR52
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC41
	add	x1, x1, :lo12:.LC41
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC42
	add	x1, x1, :lo12:.LC42
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC43
	add	x1, x1, :lo12:.LC43
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x24, #:lo12:.LANCHOR52]
	mov	x0, x20
	adrp	x1, .LC44
	add	x1, x1, :lo12:.LC44
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC45
	add	x1, x1, :lo12:.LC45
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC46
	add	x1, x1, :lo12:.LC46
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w1, [x24, #:lo12:.LANCHOR52]
	adrp	x24, .LANCHOR53
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	add	x19, x24, :lo12:.LANCHOR53
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC47
	add	x1, x1, :lo12:.LC47
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC48
	add	x1, x1, :lo12:.LC48
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC49
	add	x1, x1, :lo12:.LC49
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x24, #:lo12:.LANCHOR53]
	mov	x0, x20
	adrp	x1, .LC50
	add	x1, x1, :lo12:.LC50
	adrp	x24, .LANCHOR81
	add	x24, x24, :lo12:.LANCHOR81
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC51
	add	x1, x1, :lo12:.LC51
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 4]
	add	x19, x25, :lo12:.LANCHOR80
	mov	x0, x20
	adrp	x1, .LC52
	add	x1, x1, :lo12:.LC52
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC53
	add	x1, x1, :lo12:.LC53
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC54
	add	x1, x1, :lo12:.LC54
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x25, #:lo12:.LANCHOR80]
	mov	x0, x20
	adrp	x1, .LC55
	add	x1, x1, :lo12:.LC55
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC56
	add	x1, x1, :lo12:.LC56
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC57
	add	x1, x1, :lo12:.LC57
	bl	sprintf
	add	x20, x20, x0, sxtw
	ldp	w4, w2, [x24, 76]
	adrp	x1, .LC58
	ldr	w3, [x24, 84]
	add	x1, x1, :lo12:.LC58
	mov	x0, x20
	bl	sprintf
	add	x19, x20, x0, sxtw
	ldr	w2, [x24, 72]
	mov	x0, x19
	adrp	x1, .LC59
	add	x1, x1, :lo12:.LC59
	bl	sprintf
	add	x19, x19, x0, sxtw
	ldr	w2, [x24, 96]
	mov	x0, x19
	adrp	x1, .LC60
	add	x1, x1, :lo12:.LC60
	bl	sprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR82
	adrp	x1, .LC61
	add	x1, x1, :lo12:.LC61
	ldrh	w2, [x0, #:lo12:.LANCHOR82]
	mov	x0, x19
	bl	sprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR83
	adrp	x1, .LC62
	add	x1, x1, :lo12:.LC62
	ldrh	w2, [x0, #:lo12:.LANCHOR83]
	mov	x0, x19
	bl	sprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR84
	adrp	x1, .LC63
	add	x1, x1, :lo12:.LC63
	ldr	w2, [x0, #:lo12:.LANCHOR84]
	mov	x0, x19
	bl	sprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR85
	adrp	x1, .LC64
	add	x1, x1, :lo12:.LC64
	ldrh	w2, [x0, #:lo12:.LANCHOR85]
	mov	x0, x19
	bl	sprintf
	add	x19, x19, x0, sxtw
	bl	GetFreeBlockMinEraseCount
	and	w2, w0, 65535
	adrp	x1, .LC65
	mov	x0, x19
	add	x1, x1, :lo12:.LC65
	bl	sprintf
	add	x19, x19, x0, sxtw
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	bl	GetFreeBlockMaxEraseCount
	and	w2, w0, 65535
	adrp	x1, .LC66
	mov	x0, x19
	add	x1, x1, :lo12:.LC66
	bl	sprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmp	w0, 1
	beq	.L203
.L208:
	sub	w0, w19, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L203:
	ldrh	w0, [x25, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L205
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	ldrh	w2, [x1, x0]
	mov	x0, x19
	adrp	x1, .LC67
	add	x1, x1, :lo12:.LC67
	bl	sprintf
	add	x19, x19, x0, sxtw
.L205:
	mov	w0, 0
	adrp	x24, .LC68
	bl	List_get_gc_head_node
	add	x24, x24, :lo12:.LC68
	and	w3, w0, 65535
	mov	w23, 0
	mov	w27, 65535
	adrp	x20, .LANCHOR40
	mov	w26, 6
.L207:
	cmp	w3, w27
	beq	.L206
	adrp	x0, .LANCHOR43
	umull	x25, w3, w26
	ldr	x2, [x22, #:lo12:.LANCHOR42]
	ubfiz	x1, x3, 1, 16
	ldr	x4, [x0, #:lo12:.LANCHOR43]
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	add	x0, x0, x25
	ldrh	w6, [x4, x1]
	ldrh	w4, [x2, x1]
	mov	w2, w23
	ldrh	w5, [x0, 4]
	mov	x1, x24
	mov	x0, x19
	add	w23, w23, 1
	bl	sprintf
	add	x19, x19, x0, sxtw
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	cmp	w23, 16
	ldrh	w3, [x0, x25]
	bne	.L207
.L206:
	adrp	x0, .LANCHOR47
	adrp	x23, .LC69
	add	x23, x23, :lo12:.LC69
	mov	w22, 0
	ldr	x3, [x0, #:lo12:.LANCHOR47]
	mov	w25, 65535
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	mov	w26, 6
	adrp	x27, .LANCHOR43
	sub	x3, x3, x0
	mov	x0, -6148914691236517206
	asr	x3, x3, 1
	movk	x0, 0xaaab, lsl 0
	mul	x3, x3, x0
	and	w3, w3, 65535
.L209:
	cmp	w3, w25
	beq	.L208
	umull	x24, w3, w26
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	ldr	x2, [x27, #:lo12:.LANCHOR43]
	ubfiz	x1, x3, 1, 16
	add	x0, x0, x24
	ldrh	w5, [x2, x1]
	mov	w2, w22
	ldrh	w4, [x0, 4]
	mov	x1, x23
	mov	x0, x19
	add	w22, w22, 1
	bl	sprintf
	add	x19, x19, x0, sxtw
	cmp	w22, 4
	beq	.L208
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	ldrh	w3, [x0, x24]
	b	.L209
	.size	FtlPrintInfo2buf, .-FtlPrintInfo2buf
	.section	.text.rknand_proc_ftlread,"ax",@progbits
	.align	2
	.global	rknand_proc_ftlread
	.type	rknand_proc_ftlread, %function
rknand_proc_ftlread:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LC70
	adrp	x1, .LC71
	add	x2, x2, :lo12:.LC70
	add	x29, sp, 0
	add	x1, x1, :lo12:.LC71
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	bl	sprintf
	add	x19, x20, x0, sxtw
	mov	x0, x19
	bl	FtlPrintInfo2buf
	add	x0, x19, x0, sxtw
	sub	w0, w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rknand_proc_ftlread, .-rknand_proc_ftlread
	.section	.text.GetSwlReplaceBlock,"ax",@progbits
	.align	2
	.global	GetSwlReplaceBlock
	.type	GetSwlReplaceBlock, %function
GetSwlReplaceBlock:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR74
	adrp	x8, .LANCHOR77
	add	x29, sp, 0
	str	x19, [sp, 16]
	ldr	w3, [x2, #:lo12:.LANCHOR74]
	ldr	w7, [x8, #:lo12:.LANCHOR77]
	cmp	w3, w7
	bcs	.L218
	adrp	x1, .LANCHOR5
	adrp	x0, .LANCHOR72
	mov	w5, 0
	mov	w4, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR43
	str	wzr, [x0, #:lo12:.LANCHOR72]
	ldr	x6, [x1, #:lo12:.LANCHOR43]
	mov	x1, 0
.L219:
	cmp	w3, w1
	bhi	.L220
	cbz	w5, .L221
	str	w4, [x0, #:lo12:.LANCHOR72]
.L221:
	ldr	w1, [x0, #:lo12:.LANCHOR72]
	udiv	w3, w1, w3
	str	w3, [x2, #:lo12:.LANCHOR74]
	adrp	x3, .LANCHOR73
	ldr	w3, [x3, #:lo12:.LANCHOR73]
	sub	w1, w1, w3
	adrp	x3, .LANCHOR14
	ldrh	w3, [x3, #:lo12:.LANCHOR14]
	udiv	w1, w1, w3
	str	w1, [x0, #:lo12:.LANCHOR72]
.L222:
	ldr	w10, [x2, #:lo12:.LANCHOR74]
	add	w0, w7, 256
	cmp	w0, w10
	bls	.L227
	adrp	x1, .LANCHOR76
	add	w0, w7, 768
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cmp	w0, w1
	bls	.L227
.L229:
	mov	w19, 65535
.L228:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L220:
	ldrh	w5, [x6, x1, lsl 1]
	add	x1, x1, 1
	add	w4, w4, w5
	mov	w5, 1
	b	.L219
.L218:
	adrp	x1, .LANCHOR76
	ldr	w0, [x1, #:lo12:.LANCHOR76]
	cmp	w3, w0
	bls	.L222
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR43
	adrp	x1, .LANCHOR5
	add	x1, x1, :lo12:.LANCHOR5
	ldr	x4, [x0, #:lo12:.LANCHOR43]
	mov	w0, 0
.L224:
	ldrh	w3, [x1]
	cmp	w0, w3
	bcs	.L222
	ubfiz	x5, x0, 1, 32
	add	w0, w0, 1
	ldrh	w3, [x4, x5]
	add	w3, w3, 1
	strh	w3, [x4, x5]
	b	.L224
.L227:
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w0, lsl 1
	lsr	w0, w0, 2
	bl	GetFreeBlockMaxEraseCount
	and	w6, w0, 65535
	add	w0, w7, 64
	cmp	w6, w0
	bcc	.L229
	adrp	x0, .LANCHOR41
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	cbz	x0, .L229
	adrp	x1, .LANCHOR5
	mov	w3, 65535
	mov	x14, -6148914691236517206
	mov	w2, w3
	ldrh	w13, [x1, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR40
	mov	w12, w3
	movk	x14, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR43
	mov	w15, 6
	ldr	x4, [x1, #:lo12:.LANCHOR43]
	mov	w1, 0
.L230:
	ldrh	w5, [x0]
	cmp	w5, w12
	bne	.L233
	mov	w19, w2
.L232:
	mov	w0, 65535
	cmp	w19, w0
	beq	.L229
	ubfiz	x2, x19, 1, 32
	ldrh	w5, [x4, x2]
	cmp	w7, w5
	bcs	.L234
	bl	GetFreeBlockMinEraseCount
	cmp	w7, w0, uxth
	bcs	.L234
	str	w3, [x8, #:lo12:.LANCHOR77]
.L234:
	cmp	w10, w5
	bls	.L229
	add	w0, w5, 128
	cmp	w6, w0
	ble	.L229
	add	w0, w5, 256
	adrp	x1, .LANCHOR76
	cmp	w10, w0
	bhi	.L235
	ldr	w3, [x1, #:lo12:.LANCHOR76]
	add	w0, w5, 768
	cmp	w0, w3
	bcs	.L229
.L235:
	adrp	x0, .LANCHOR42
	ldr	w3, [x1, #:lo12:.LANCHOR76]
	mov	w1, w19
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w4, [x0, x2]
	mov	w2, w10
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
	adrp	x0, .LANCHOR87
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR87]
	b	.L228
.L233:
	add	w1, w1, 1
	and	w1, w1, 65535
	cmp	w1, w13
	bhi	.L229
	ldrh	w16, [x0, 4]
	cbz	w16, .L231
	sub	x0, x0, x11
	asr	x0, x0, 1
	mul	x0, x0, x14
	and	w19, w0, 65535
	and	x0, x0, 65535
	ldrh	w0, [x4, x0, lsl 1]
	cmp	w7, w0
	bcs	.L232
	cmp	w3, w0
	bls	.L231
	mov	w3, w0
	mov	w2, w19
.L231:
	umaddl	x0, w5, w15, x11
	b	.L230
	.size	GetSwlReplaceBlock, .-GetSwlReplaceBlock
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L249
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	strh	wzr, [x2, x1]
	bl	INSERT_FREE_LIST
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L249:
	mov	w0, 0
	ret
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.get_new_active_ppa,"ax",@progbits
	.align	2
	.global	get_new_active_ppa
	.type	get_new_active_ppa, %function
get_new_active_ppa:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0]
	mov	w0, 65535
	str	x21, [sp, 32]
	cmp	w1, w0
	bne	.L253
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2710
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L253:
	adrp	x20, .LANCHOR19
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bne	.L254
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2711
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L254:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L255
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2712
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L255:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR3
	strb	wzr, [x19, 10]
	add	x0, x0, 8
	ldrh	w2, [x1, #:lo12:.LANCHOR3]
	mov	w1, 65535
	ldrh	w0, [x19, x0, lsl 1]
.L256:
	cmp	w0, w1
	beq	.L258
	ldrh	w21, [x19, 2]
	mov	w3, 65535
	ldrh	w1, [x19, 4]
	orr	w21, w21, w0, lsl 10
	ldrb	w0, [x19, 6]
	sub	w1, w1, #1
	and	w1, w1, 65535
	strh	w1, [x19, 4]
.L260:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w2, w0
	bne	.L259
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L259:
	add	x4, x19, x0, sxtw 1
	ldrh	w4, [x4, 16]
	cmp	w4, w3
	beq	.L260
	strb	w0, [x19, 6]
	ldrh	w2, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w2, w0
	bne	.L252
	cbz	w1, .L252
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2733
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L252:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L258:
	ldrb	w0, [x19, 6]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w0, w2
	bne	.L257
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L257:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L256
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlGcBufInit,"ax",@progbits
	.align	2
	.global	FtlGcBufInit
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	adrp	x1, .LANCHOR90
	adrp	x0, .LANCHOR89
	adrp	x7, .LANCHOR91
	adrp	x6, .LANCHOR92
	ldr	x5, [x1, #:lo12:.LANCHOR90]
	adrp	x1, .LANCHOR23
	str	wzr, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR3
	ldrh	w10, [x1, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR24
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	w8, 24
	ldrh	w11, [x1, #:lo12:.LANCHOR24]
	adrp	x1, .LANCHOR93
	ldr	x14, [x7, #:lo12:.LANCHOR91]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR93]
	mov	w2, 0
	ldr	x15, [x6, #:lo12:.LANCHOR92]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	mov	w1, 0
	mov	w16, 1
.L268:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L269
	adrp	x1, .LANCHOR94
	ldr	x7, [x7, #:lo12:.LANCHOR91]
	ldr	x6, [x6, #:lo12:.LANCHOR92]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR94]
.L270:
	cmp	w0, w4
	bcc	.L271
	ret
.L269:
	asr	w2, w2, 2
	asr	w1, w1, 2
	add	x2, x14, x2, sxtw 2
	add	x1, x15, x1, sxtw 2
	str	w16, [x3, 16]
	stp	x2, x1, [x3]
	add	x3, x3, 24
	stp	x2, x1, [x4]
	add	x4, x4, 32
	mov	w1, w12
	mov	w2, w13
	b	.L268
.L271:
	umull	x3, w0, w8
	mul	w1, w10, w0
	add	x2, x5, x3
	asr	w1, w1, 2
	add	x1, x7, x1, sxtw 2
	str	wzr, [x2, 16]
	str	x1, [x5, x3]
	mul	w1, w11, w0
	add	w0, w0, 1
	and	w0, w0, 65535
	asr	w1, w1, 2
	add	x1, x6, x1, sxtw 2
	str	x1, [x2, 8]
	b	.L270
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",@progbits
	.align	2
	.global	FtlGcBufFree
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	adrp	x2, .LANCHOR94
	mov	w3, 0
	mov	w8, 24
	ldr	w7, [x2, #:lo12:.LANCHOR94]
	adrp	x2, .LANCHOR90
	ldr	x5, [x2, #:lo12:.LANCHOR90]
.L273:
	cmp	w3, w1
	bcs	.L272
	ubfiz	x4, x3, 5, 16
	mov	w2, 0
	add	x4, x0, x4
	b	.L278
.L274:
	add	w2, w2, 1
	and	w2, w2, 65535
.L278:
	cmp	w2, w7
	bcs	.L275
	umull	x6, w2, w8
	add	x10, x5, x6
	ldr	x11, [x5, x6]
	ldr	x6, [x4, 8]
	cmp	x11, x6
	bne	.L274
	str	wzr, [x10, 16]
.L275:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L273
.L272:
	ret
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",@progbits
	.align	2
	.global	FtlGcBufAlloc
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	adrp	x2, .LANCHOR94
	mov	w3, 0
	mov	w7, 24
	mov	w8, 1
	ldr	w5, [x2, #:lo12:.LANCHOR94]
	adrp	x2, .LANCHOR90
	ldr	x6, [x2, #:lo12:.LANCHOR90]
.L280:
	cmp	w3, w1
	bcs	.L279
	mov	w2, 0
	b	.L285
.L281:
	add	w2, w2, 1
	and	w2, w2, 65535
.L285:
	cmp	w2, w5
	bcs	.L282
	umaddl	x4, w2, w7, x6
	ldr	w10, [x4, 16]
	cbnz	w10, .L281
	ubfiz	x2, x3, 5, 16
	ldr	x10, [x4]
	add	x2, x0, x2
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x10, x4, [x2, 8]
.L282:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L280
.L279:
	ret
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",@progbits
	.align	2
	.global	IsBlkInGcList
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	adrp	x1, .LANCHOR95
	and	w0, w0, 65535
	ldrh	w2, [x1, #:lo12:.LANCHOR95]
	adrp	x1, .LANCHOR96
	ldr	x3, [x1, #:lo12:.LANCHOR96]
	mov	x1, 0
.L287:
	cmp	w2, w1, uxth
	bhi	.L289
	mov	w0, 0
	ret
.L289:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L287
	mov	w0, 1
	ret
	.size	IsBlkInGcList, .-IsBlkInGcList
	.section	.text.FtlGcUpdatePage,"ax",@progbits
	.align	2
	.global	FtlGcUpdatePage
	.type	FtlGcUpdatePage, %function
FtlGcUpdatePage:
	mov	w6, w0
	mov	w10, w1
	mov	w8, w2
	stp	x29, x30, [sp, -16]!
	lsr	w0, w0, 10
	add	x29, sp, 0
	bl	P2V_block_in_plane
	and	w7, w0, 65535
	adrp	x4, .LANCHOR95
	adrp	x2, .LANCHOR96
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR95]
	ldr	x5, [x2, #:lo12:.LANCHOR96]
.L292:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L294
	bne	.L293
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR95]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR95]
	b	.L293
.L294:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L292
.L293:
	adrp	x4, .LANCHOR97
	adrp	x1, .LANCHOR98
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR97]
	ldr	x5, [x1, #:lo12:.LANCHOR98]
	umull	x3, w0, w3
	add	w0, w0, 1
	add	x7, x5, x3
	stp	w10, w8, [x7, 4]
	str	w6, [x5, x3]
	strh	w0, [x4, #:lo12:.LANCHOR97]
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	and	w19, w0, 65535
	mov	w1, w19
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	adrp	x3, .LANCHOR99
	ldrh	w4, [x3, #:lo12:.LANCHOR99]
	cmp	w19, w4
	beq	.L297
	adrp	x0, .LANCHOR100
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w19, w2
	beq	.L297
	mov	w1, 65535
	cmp	w4, w1
	bne	.L298
	strh	w19, [x3, #:lo12:.LANCHOR99]
.L297:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L298:
	cmp	w2, w1
	bne	.L297
	strh	w19, [x0, #:lo12:.LANCHOR100]
	b	.L297
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",@progbits
	.align	2
	.global	FtlGcMarkBadPhyBlk
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	adrp	x19, .LANCHOR101
	str	x21, [sp, 32]
	mov	w0, w20
	bl	P2V_block_in_plane
	ldrh	w1, [x19, #:lo12:.LANCHOR101]
	mov	w2, w20
	mov	w21, w0
	adrp	x0, .LC74
	add	x0, x0, :lo12:.LC74
	bl	printf
	mov	w0, w21
	bl	FtlGcRefreshBlock
	ldrh	w0, [x19, #:lo12:.LANCHOR101]
	adrp	x2, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR102
	mov	x1, 0
.L301:
	cmp	w0, w1, uxth
	bhi	.L303
	cmp	w0, 15
	bhi	.L302
	add	w1, w0, 1
	strh	w1, [x19, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR102
	add	x1, x1, :lo12:.LANCHOR102
	strh	w20, [x1, w0, sxtw 1]
	b	.L302
.L303:
	add	x1, x1, 1
	add	x3, x2, x1, lsl 1
	ldrh	w3, [x3, -2]
	cmp	w3, w20
	bne	.L301
.L302:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L312
	adrp	x1, .LANCHOR99
	ldrh	w2, [x1, #:lo12:.LANCHOR99]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L312
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR103
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	cmp	w1, w0
	bcc	.L307
	strh	wzr, [x19, #:lo12:.LANCHOR103]
.L307:
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	adrp	x0, .LANCHOR102
	add	x0, x0, :lo12:.LANCHOR102
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	w0, [x19, #:lo12:.LANCHOR103]
	add	w0, w0, 1
	strh	w0, [x19, #:lo12:.LANCHOR103]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L312:
	mov	w0, 0
	ret
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.ftl_malloc,"ax",@progbits
	.align	2
	.global	ftl_malloc
	.type	ftl_malloc, %function
ftl_malloc:
	mov	w1, 0
	sxtw	x0, w0
	b	kmalloc
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.ftl_free,"ax",@progbits
	.align	2
	.global	ftl_free
	.type	ftl_free, %function
ftl_free:
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.rknand_print_hex,"ax",@progbits
	.align	2
	.global	rknand_print_hex
	.type	rknand_print_hex, %function
rknand_print_hex:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x22, x1
	stp	x23, x24, [sp, 48]
	adrp	x24, .LC75
	stp	x25, x26, [sp, 64]
	mov	w23, w2
	stp	x27, x28, [sp, 80]
	adrp	x25, .LC77
	mov	x28, x0
	mov	w27, w3
	add	x24, x24, :lo12:.LC75
	add	x25, x25, :lo12:.LC77
	stp	x19, x20, [sp, 16]
	mov	w21, 0
	mov	x19, 0
	mov	w20, 0
	adrp	x26, .LC76
.L318:
	cmp	w27, w19
	bhi	.L324
	ldp	x19, x20, [sp, 16]
	adrp	x0, .LC78
	ldp	x21, x22, [sp, 32]
	add	x0, x0, :lo12:.LC78
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L324:
	cbnz	w20, .L319
	mov	w2, w21
	mov	x1, x28
	mov	x0, x24
	bl	printf
.L319:
	cmp	w23, 4
	bne	.L320
	ldr	w1, [x22, x19, lsl 2]
.L327:
	add	x0, x26, :lo12:.LC76
.L326:
	bl	printf
	add	w20, w20, 1
	cmp	w20, 15
	bls	.L323
	mov	w20, 0
	adrp	x0, .LC78
	add	x0, x0, :lo12:.LC78
	bl	printf
.L323:
	add	x19, x19, 1
	add	w21, w21, w23
	b	.L318
.L320:
	cmp	w23, 2
	bne	.L322
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L327
.L322:
	ldrb	w1, [x22, x19]
	mov	x0, x25
	b	.L326
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.FlashReadPages,"ax",@progbits
	.align	2
	.global	FlashReadPages
	.type	FlashReadPages, %function
FlashReadPages:
	stp	x29, x30, [sp, -96]!
	adrp	x2, .LANCHOR0
	add	x3, x2, :lo12:.LANCHOR0
	ubfiz	x1, x1, 5, 32
	add	x29, sp, 0
	str	x25, [sp, 64]
	ldrh	w25, [x3, 12]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR104
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC1
	stp	x19, x20, [sp, 16]
	add	x24, x0, x1
	mov	x19, x0
	mov	x23, x2
	add	x21, x21, :lo12:.LANCHOR104
	add	x22, x22, :lo12:.LC1
.L329:
	cmp	x19, x24
	bne	.L336
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L336:
	ldr	x0, [x19, 8]
	cbz	x0, .L330
	ldr	x0, [x19, 16]
	cbnz	x0, .L331
.L330:
	mov	w2, 96
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L331:
	ldr	w0, [x19, 4]
	adrp	x20, .LANCHOR105
	add	x20, x20, :lo12:.LANCHOR105
	add	x2, x29, 88
	add	x1, x29, 92
	bl	l2p_addr_tran.isra.0
	ldrb	w0, [x29, 88]
	ldr	w1, [x29, 92]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x20, 24]
	blr	x4
	str	w0, [x19]
	add	x0, x23, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L333
	ldrb	w0, [x29, 88]
	ldr	x4, [x20, 24]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 92]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w25, w1
	blr	x4
	cmn	w0, #1
	beq	.L334
	ldr	x0, [x19, 16]
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L333
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L333
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L333
.L334:
	mov	w0, -1
	str	w0, [x19]
.L333:
	add	x19, x19, 32
	b	.L329
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR107
	adrp	x0, .LANCHOR106
	add	x1, x0, :lo12:.LANCHOR106
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR107]
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR17
	stp	x27, x28, [sp, 80]
	add	x28, x26, :lo12:.LANCHOR17
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR37
	stp	x23, x24, [sp, 48]
	add	x20, x20, :lo12:.LANCHOR37
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR108
	adrp	x23, .LANCHOR10
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR108]
	add	x23, x23, :lo12:.LANCHOR10
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L348:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L353
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L353:
	ldrh	w19, [x26, #:lo12:.LANCHOR17]
	add	x24, x22, :lo12:.LANCHOR106
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L349:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L351
	madd	w0, w0, w21, w19
	mov	w2, 1
	str	w3, [x29, 108]
	mov	w1, w2
	lsl	w0, w0, 10
	str	w0, [x24, 4]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	ldr	w3, [x29, 108]
	cmn	w0, #1
	beq	.L350
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L350
	strh	w19, [x20]
.L351:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L348
.L350:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L349
	.size	FtlLoadFactoryBbt, .-FtlLoadFactoryBbt
	.section	.text.FtlGetLastWrittenPage,"ax",@progbits
	.align	2
	.global	FtlGetLastWrittenPage
	.type	FtlGetLastWrittenPage, %function
FtlGetLastWrittenPage:
	stp	x29, x30, [sp, -160]!
	cmp	w1, 1
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	bne	.L359
	adrp	x1, .LANCHOR20
	ldrh	w19, [x1, #:lo12:.LANCHOR20]
.L360:
	sub	w19, w19, #1
	adrp	x1, ftl_temp_buf
	sxth	w19, w19
	add	x1, x1, :lo12:ftl_temp_buf
	lsl	w21, w0, 10
	str	x1, [x29, 72]
	orr	w0, w19, w21
	add	x1, x29, 96
	str	w0, [x29, 68]
	mov	w2, w23
	str	x1, [x29, 80]
	add	x0, x29, 64
	mov	w1, 1
	bl	FlashReadPages
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L361
	mov	w22, 0
	mov	w24, 2
.L362:
	cmp	w22, w19
	ble	.L365
.L361:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 160
	ret
.L359:
	adrp	x1, .LANCHOR19
	ldrh	w19, [x1, #:lo12:.LANCHOR19]
	b	.L360
.L365:
	add	w20, w22, w19
	mov	w2, w23
	mov	w1, 1
	sdiv	w20, w20, w24
	sxth	w0, w20
	orr	w0, w0, w21
	str	w0, [x29, 68]
	add	x0, x29, 64
	bl	FlashReadPages
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L363
	ldr	w0, [x29, 100]
	cmn	w0, #1
	bne	.L363
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L362
.L363:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L362
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FlashProgPages,"ax",@progbits
	.align	2
	.global	FlashProgPages
	.type	FlashProgPages, %function
FlashProgPages:
	stp	x29, x30, [sp, -144]!
	ubfiz	x1, x1, 5, 32
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w2
	mov	w26, w3
	adrp	x2, .LANCHOR0
	add	x3, x2, :lo12:.LANCHOR0
	stp	x27, x28, [sp, 80]
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	ldrh	w27, [x3, 12]
	adrp	x21, .LANCHOR109
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR105
	add	x24, x0, x1
	mov	x23, x2
	add	x21, x21, :lo12:.LANCHOR109
	add	x28, x22, :lo12:.LANCHOR105
.L368:
	cmp	x19, x24
	bne	.L376
	cbnz	w26, .L377
.L395:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L376:
	ldr	x0, [x19, 8]
	cbz	x0, .L369
	ldr	x0, [x19, 16]
	cbnz	x0, .L370
.L369:
	adrp	x0, .LC1
	mov	w2, 126
	mov	x1, x21
	add	x0, x0, :lo12:.LC1
	bl	printf
.L370:
	ldr	w0, [x19, 4]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
	add	x0, x22, :lo12:.LANCHOR105
	ldr	w1, [x29, 108]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x0, 16]
	ldrb	w0, [x29, 104]
	blr	x4
	cbnz	w0, .L371
	str	wzr, [x19]
.L372:
	add	x0, x23, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L374
	ldrb	w0, [x29, 104]
	ldr	x4, [x28, 16]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 108]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w27, w1
	blr	x4
	cbz	w0, .L374
	mov	w0, -1
	str	w0, [x19]
.L374:
	add	x19, x19, 32
	b	.L368
.L371:
	mov	w0, -1
	str	w0, [x19]
	b	.L372
.L381:
	str	wzr, [x22]
	mov	w2, w25
	str	wzr, [x24]
	mov	w1, 1
	stp	x22, x24, [x29, 120]
	ldr	w0, [x20, 4]
	str	w0, [x29, 116]
	add	x0, x29, 112
	bl	FlashReadPages
	ldr	w26, [x29, 112]
	cmn	w26, #1
	bne	.L378
	ldr	w1, [x20, 4]
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
	str	w26, [x20]
.L378:
	ldr	x0, [x20, 16]
	cbz	x0, .L379
	ldr	w3, [x23, #:lo12:.LANCHOR110]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L379
	ldr	w1, [x20, 4]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
	mov	w0, -1
	str	w0, [x20]
.L379:
	ldr	x0, [x20, 8]
	cbz	x0, .L380
	ldr	w3, [x21, #:lo12:check_buf]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L380
	ldr	w1, [x20, 4]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	printf
	mov	w0, -1
	str	w0, [x20]
.L380:
	add	x20, x20, 32
.L396:
	cmp	x20, x19
	bne	.L381
	b	.L395
.L377:
	adrp	x21, check_buf
	adrp	x23, .LANCHOR110
	add	x22, x21, :lo12:check_buf
	add	x24, x23, :lo12:.LANCHOR110
	b	.L396
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FlashEraseBlocks,"ax",@progbits
	.align	2
	.global	FlashEraseBlocks
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR0
	add	x3, x1, :lo12:.LANCHOR0
	ubfiz	x2, x2, 5, 32
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	add	x2, x2, 4
	ldrh	w23, [x3, 12]
	stp	x19, x20, [sp, 16]
	add	x19, x0, 4
	stp	x21, x22, [sp, 32]
	mov	x20, x1
	adrp	x21, .LANCHOR105
	add	x22, x0, x2
	add	x24, x21, :lo12:.LANCHOR105
.L399:
	cmp	x19, x22
	bne	.L405
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L405:
	ldr	w0, [x19]
	add	x2, x29, 72
	add	x1, x29, 76
	bl	l2p_addr_tran.isra.0
	add	x0, x21, :lo12:.LANCHOR105
	ldr	w1, [x29, 76]
	ldr	x2, [x0, 8]
	ldrb	w0, [x29, 72]
	blr	x2
	cbnz	w0, .L400
	str	wzr, [x19, -4]
.L401:
	add	x0, x20, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L403
	ldrb	w0, [x29, 72]
	ldr	x2, [x24, 8]
	ldr	w1, [x29, 76]
	add	w1, w23, w1
	blr	x2
	cbz	w0, .L403
	mov	w0, -1
	str	w0, [x19, -4]
.L403:
	add	x19, x19, 32
	b	.L399
.L400:
	mov	w0, -1
	str	w0, [x19, -4]
	b	.L401
	.size	FlashEraseBlocks, .-FlashEraseBlocks
	.section	.text.FtlFreeSysBlkQueueIn,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueIn
	.type	FtlFreeSysBlkQueueIn, %function
FtlFreeSysBlkQueueIn:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	str	x21, [sp, 32]
	sub	w2, w20, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcc	.L410
	adrp	x0, .LANCHOR38
	add	x2, x0, :lo12:.LANCHOR38
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L410
	and	w1, w1, 65535
	cbz	w1, .L412
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w21, w0, 65535
	adrp	x0, .LANCHOR111
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR43
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR75
	ldr	w0, [x1, #:lo12:.LANCHOR75]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR75]
.L412:
	add	x0, x19, :lo12:.LANCHOR38
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	strh	w20, [x2, 8]
.L410:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlLowFormatEraseBlock,"ax",@progbits
	.align	2
	.global	FtlLowFormatEraseBlock
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	stp	x29, x30, [sp, -144]!
	adrp	x7, .LANCHOR13
	add	x7, x7, :lo12:.LANCHOR13
	mov	x5, 0
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w0, 65535
	adrp	x0, .LANCHOR112
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w23, w1, 255
	str	w24, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR114
	adrp	x1, .LANCHOR113
	adrp	x20, .LANCHOR3
	adrp	x21, .LANCHOR111
	ldr	x11, [x0, #:lo12:.LANCHOR114]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x20, #:lo12:.LANCHOR3]
	ldr	x6, [x21, #:lo12:.LANCHOR111]
	mov	w22, 0
	ldr	x10, [x1, #:lo12:.LANCHOR113]
	mov	w19, 0
	ldrh	w12, [x0, #:lo12:.LANCHOR24]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	stp	x0, x1, [x29, 120]
.L421:
	cmp	w8, w5, uxth
	bhi	.L425
	cbz	w22, .L420
	mov	w2, w22
	ubfiz	x22, x22, 5, 16
	mov	x25, 0
	mov	w1, 0
	mov	x0, x6
	bl	FlashEraseBlocks
.L429:
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L428
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L428:
	add	x25, x25, 32
	cmp	x25, x22
	bne	.L429
	cbz	w23, .L442
	adrp	x0, .LANCHOR20
	mov	w25, 1
	ldrh	w26, [x0, #:lo12:.LANCHOR20]
	lsr	w28, w26, 2
.L430:
	add	x0, x20, :lo12:.LANCHOR3
	adrp	x27, .LANCHOR13
	str	x0, [x29, 136]
	mov	w22, 0
	add	x0, x27, :lo12:.LANCHOR13
	str	x0, [x29, 112]
.L438:
	ldr	x0, [x29, 136]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR111]
	mov	w20, 0
	ldrh	w7, [x0]
	adrp	x0, .LANCHOR115
	ldr	x8, [x0, #:lo12:.LANCHOR115]
	ldr	x0, [x29, 128]
	ldr	x10, [x0, #:lo12:.LANCHOR113]
	ldr	x0, [x29, 120]
	ldrh	w11, [x0, #:lo12:.LANCHOR24]
.L431:
	cmp	w7, w5, uxth
	bhi	.L434
	cbz	w20, .L420
	mov	w1, w20
	mov	w3, 1
	mov	w2, w25
	mov	x0, x6
	bl	FlashProgPages
	mov	x27, 0
	ubfiz	x1, x20, 5, 16
.L437:
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x3, x0, x27
	ldr	w0, [x0, x27]
	cbz	w0, .L436
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	str	x1, [x29, 104]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldr	x1, [x29, 104]
.L436:
	add	x27, x27, 32
	cmp	x1, x27
	bne	.L437
	add	w22, w22, w28
	and	w22, w22, 65535
	cmp	w26, w22
	bhi	.L438
	mov	x22, 0
.L440:
	cbz	w23, .L439
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cbnz	w0, .L439
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.L439:
	add	x22, x22, 32
	cmp	x22, x27
	bne	.L440
	cmp	w24, 63
	ccmp	w23, 0, 0, hi
	beq	.L420
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	mov	w2, w20
	mov	w1, w25
	bl	FlashEraseBlocks
.L420:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L425:
	lsl	x0, x5, 5
	mov	w1, w24
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w23, .L422
	bl	IsBlkInVendorPart
	cbnz	w0, .L423
.L422:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L424
	ubfiz	x0, x22, 5, 16
	mul	w1, w22, w12
	add	x0, x6, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	lsl	w13, w13, 10
	asr	w1, w1, 2
	add	x1, x11, x1, sxtw 2
	str	w13, [x0, 4]
	stp	x10, x1, [x0, 8]
.L423:
	add	x5, x5, 1
	b	.L421
.L424:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L423
.L442:
	mov	w25, 0
	mov	w28, 6
	mov	w26, 1
	b	.L430
.L434:
	lsl	x0, x5, 5
	mov	w1, w24
	str	wzr, [x6, x0]
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w12, w0, 65535
	mov	w13, w12
	cbz	w23, .L432
	bl	IsBlkInVendorPart
	cbnz	w0, .L433
.L432:
	mov	w0, w13
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L433
	ubfiz	x0, x20, 5, 16
	mul	w1, w20, w11
	add	x0, x6, x0
	add	w20, w20, 1
	and	w20, w20, 65535
	add	w12, w22, w12, lsl 10
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	str	w12, [x0, 4]
	stp	x8, x1, [x0, 8]
.L433:
	add	x5, x5, 1
	b	.L431
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR38
	stp	x21, x22, [sp, 32]
	add	x19, x19, :lo12:.LANCHOR38
	adrp	x21, .LANCHOR75
	str	x23, [sp, 48]
	add	x21, x21, :lo12:.LANCHOR75
	adrp	x23, .LC83
	add	x23, x23, :lo12:.LC83
.L464:
	ldrh	w1, [x19, 6]
	cbz	w1, .L465
	ldrh	w0, [x19, 2]
	sub	w1, w1, #1
	strh	w1, [x19, 6]
	add	x2, x19, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x19, 2]
	ldrh	w20, [x2, 8]
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w22, w0, 65535
	adrp	x0, .LANCHOR111
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR43
	ubfiz	x0, x22, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	ldr	w0, [x21]
	sub	w1, w20, #1
	add	w0, w0, 1
	str	w0, [x21]
	mov	w0, 65533
	cmp	w0, w1, uxth
	bcc	.L466
	mov	w0, w20
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L465:
	adrp	x0, .LC82
	mov	w1, 0
	add	x0, x0, :lo12:.LC82
	bl	printf
.L468:
	b	.L468
.L466:
	ldrh	w2, [x19, 6]
	mov	w1, w20
	mov	x0, x23
	bl	printf
	b	.L464
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",@progbits
	.align	2
	.global	ftl_map_blk_alloc_new_blk
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0, 10]
	mov	w20, 0
	ldr	x0, [x0, 16]
	str	x21, [sp, 32]
.L472:
	cmp	w20, w1
	beq	.L476
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L473
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L474
	adrp	x0, .LANCHOR38+6
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	adrp	x0, .LC84
	add	x0, x0, :lo12:.LC84
	bl	printf
.L475:
	b	.L475
.L474:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L476:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L478
	adrp	x1, .LANCHOR116
	adrp	x0, .LC1
	mov	w2, 581
	add	x1, x1, :lo12:.LANCHOR116
	add	x0, x0, :lo12:.LC1
	bl	printf
.L478:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L473:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L472
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.ftl_memset,"ax",@progbits
	.align	2
	.global	ftl_memset
	.type	ftl_memset, %function
ftl_memset:
	uxtw	x2, w2
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.FtlMemInit,"ax",@progbits
	.align	2
	.global	FtlMemInit
	.type	FtlMemInit, %function
FtlMemInit:
	stp	x29, x30, [sp, -208]!
	adrp	x0, .LANCHOR70
	mov	w1, 65535
	add	x29, sp, 0
	str	wzr, [x0, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR71
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR21
	str	wzr, [x0, #:lo12:.LANCHOR71]
	adrp	x0, .LANCHOR67
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR3
	str	wzr, [x0, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR64
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR23
	str	wzr, [x0, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR63
	stp	x25, x26, [sp, 64]
	adrp	x24, .LANCHOR108
	str	wzr, [x0, #:lo12:.LANCHOR63]
	adrp	x0, .LANCHOR65
	stp	x27, x28, [sp, 80]
	adrp	x23, .LANCHOR114
	str	wzr, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR66
	adrp	x25, .LANCHOR42
	adrp	x27, .LANCHOR129
	str	wzr, [x0, #:lo12:.LANCHOR66]
	adrp	x0, .LANCHOR62
	adrp	x26, .LANCHOR130
	str	wzr, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR72
	str	wzr, [x0, #:lo12:.LANCHOR72]
	adrp	x0, .LANCHOR73
	str	wzr, [x0, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR75
	str	wzr, [x0, #:lo12:.LANCHOR75]
	adrp	x0, .LANCHOR76
	str	wzr, [x0, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR77
	str	wzr, [x0, #:lo12:.LANCHOR77]
	adrp	x0, .LANCHOR117
	str	wzr, [x0, #:lo12:.LANCHOR117]
	adrp	x0, .LANCHOR87
	str	wzr, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR118
	str	w1, [x0, #:lo12:.LANCHOR118]
	adrp	x0, .LANCHOR119
	adrp	x1, .LANCHOR99
	str	wzr, [x0, #:lo12:.LANCHOR119]
	adrp	x0, .LANCHOR84
	str	wzr, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR112
	str	wzr, [x0, #:lo12:.LANCHOR112]
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR99]
	adrp	x1, .LANCHOR100
	strh	w0, [x1, #:lo12:.LANCHOR100]
	adrp	x0, .LANCHOR82
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR82]
	adrp	x0, .LANCHOR83
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR85
	strh	wzr, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR101
	strh	wzr, [x0, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR103
	strh	wzr, [x0, #:lo12:.LANCHOR103]
	ldrh	w0, [x19, #:lo12:.LANCHOR21]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR96
	str	x0, [x1, #:lo12:.LANCHOR96]
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR21]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x22, #:lo12:.LANCHOR3]
	adrp	x3, .LANCHOR98
	str	x3, [x29, 104]
	lsl	w20, w19, 5
	lsl	w19, w19, 7
	str	x0, [x3, #:lo12:.LANCHOR98]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x15, .LANCHOR120
	str	x15, [x29, 112]
	str	x0, [x15, #:lo12:.LANCHOR120]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x11, .LANCHOR121
	str	x11, [x29, 120]
	str	x0, [x11, #:lo12:.LANCHOR121]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x14, .LANCHOR122
	str	x14, [x29, 128]
	str	x0, [x14, #:lo12:.LANCHOR122]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x13, .LANCHOR111
	str	x13, [x29, 136]
	str	x0, [x13, #:lo12:.LANCHOR111]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR94
	adrp	x12, .LANCHOR93
	ldrh	w19, [x21, #:lo12:.LANCHOR23]
	str	x12, [x29, 144]
	str	x0, [x12, #:lo12:.LANCHOR93]
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR94]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x10, .LANCHOR107
	str	x10, [x29, 152]
	str	x0, [x10, #:lo12:.LANCHOR107]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x8, .LANCHOR123
	str	x8, [x29, 160]
	str	x0, [x8, #:lo12:.LANCHOR123]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x7, .LANCHOR124
	str	x7, [x29, 168]
	str	x0, [x7, #:lo12:.LANCHOR124]
	ldr	w0, [x20, #:lo12:.LANCHOR94]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x6, .LANCHOR91
	str	x6, [x29, 176]
	str	x0, [x6, #:lo12:.LANCHOR91]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x5, .LANCHOR115
	str	x5, [x29, 184]
	str	x0, [x5, #:lo12:.LANCHOR115]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x19, .LANCHOR24
	adrp	x4, .LANCHOR113
	ldr	w2, [x20, #:lo12:.LANCHOR94]
	str	x4, [x29, 192]
	str	x0, [x4, #:lo12:.LANCHOR113]
	mov	w0, 24
	mul	w0, w2, w0
	bl	ftl_malloc
	ldrh	w28, [x19, #:lo12:.LANCHOR24]
	adrp	x1, .LANCHOR90
	str	x0, [x1, #:lo12:.LANCHOR90]
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	adrp	x22, .LANCHOR92
	mul	w28, w28, w0
	mov	w0, w28
	bl	ftl_malloc
	str	x0, [x24, #:lo12:.LANCHOR108]
	lsl	w0, w28, 2
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR114]
	ldrh	w1, [x19, #:lo12:.LANCHOR24]
	adrp	x28, .LANCHOR125
	ldr	w0, [x20, #:lo12:.LANCHOR94]
	adrp	x20, .LANCHOR6
	mul	w0, w1, w0
	bl	ftl_malloc
	str	x0, [x22, #:lo12:.LANCHOR92]
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x28, #:lo12:.LANCHOR125]
	and	w0, w0, 65534
	bl	ftl_malloc
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	ldrh	w0, [x28, #:lo12:.LANCHOR125]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x28, #:lo12:.LANCHOR125]
	lsl	w0, w0, 9
	bl	ftl_malloc
	adrp	x1, .LANCHOR127
	ldrh	w28, [x20, #:lo12:.LANCHOR6]
	str	x0, [x1, #:lo12:.LANCHOR127]
	adrp	x1, .LANCHOR43
	lsl	w28, w28, 1
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR43]
	mov	w0, w28
	bl	ftl_malloc
	adrp	x1, .LANCHOR128
	str	x0, [x1, #:lo12:.LANCHOR128]
	mov	w0, w28
	adrp	x28, .LANCHOR30
	bl	ftl_malloc
	str	x0, [x25, #:lo12:.LANCHOR42]
	ldr	w1, [x28, #:lo12:.LANCHOR30]
	lsl	w19, w1, 1
	mov	w0, w19
	bl	ftl_malloc
	str	x0, [x27, #:lo12:.LANCHOR129]
	mov	w0, w19
	bl	ftl_malloc
	str	x0, [x26, #:lo12:.LANCHOR130]
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	adrp	x19, .LANCHOR27
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR1
	str	x0, [x1, #:lo12:.LANCHOR1]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x2, .LANCHOR36
	str	x0, [x2, #:lo12:.LANCHOR36]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x2, .LANCHOR131
	str	x0, [x2, #:lo12:.LANCHOR131]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	adrp	x19, .LANCHOR43
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR132
	str	x0, [x1, #:lo12:.LANCHOR132]
	adrp	x1, .LANCHOR28
	str	x1, [x29, 200]
	ldrh	w0, [x1, #:lo12:.LANCHOR28]
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldr	x1, [x29, 200]
	adrp	x2, .LANCHOR133
	str	x0, [x2, #:lo12:.LANCHOR133]
	ldrh	w2, [x1, #:lo12:.LANCHOR28]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR32
	ldrh	w0, [x0, #:lo12:.LANCHOR32]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR134
	str	x0, [x1, #:lo12:.LANCHOR134]
	ldr	w0, [x28, #:lo12:.LANCHOR30]
	adrp	x28, .LANCHOR33
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR135
	str	x0, [x1, #:lo12:.LANCHOR135]
	ldrh	w0, [x28, #:lo12:.LANCHOR33]
	lsl	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR55
	str	x0, [x1, #:lo12:.LANCHOR55]
	ldrh	w1, [x28, #:lo12:.LANCHOR33]
	ldrh	w0, [x21, #:lo12:.LANCHOR23]
	adrp	x21, .LANCHOR10
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR136
	str	x0, [x1, #:lo12:.LANCHOR136]
	mov	w0, 6
	ldrh	w1, [x20, #:lo12:.LANCHOR6]
	adrp	x20, .LANCHOR137
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR40
	str	x0, [x1, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR17
	ldrh	w1, [x21, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x20, #:lo12:.LANCHOR137]
	mul	w0, w1, w0
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldp	x3, x15, [x29, 104]
	adrp	x1, .LANCHOR37
	ldrh	w20, [x20, #:lo12:.LANCHOR137]
	add	x2, x1, :lo12:.LANCHOR37
	ldp	x11, x14, [x29, 120]
	mov	w30, w20
	ldp	x13, x12, [x29, 136]
	mov	x16, x3
	ldp	x10, x8, [x29, 152]
	str	x0, [x2, 32]
	ldp	x7, x6, [x29, 168]
	adrp	x17, .LANCHOR96
	ldp	x5, x4, [x29, 184]
	adrp	x3, .LANCHOR90
	ldrh	w28, [x21, #:lo12:.LANCHOR10]
	add	x21, x2, 40
	mov	x0, 1
	str	x19, [x29, 200]
.L482:
	cmp	w0, w28
	bcc	.L483
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR37
	mov	x19, 0
.L484:
	add	x19, x19, 1
	cmp	x19, x2
	bne	.L485
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	cbnz	x0, .L486
.L488:
	adrp	x1, .LANCHOR138
	adrp	x0, .LC85
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC85
	bl	printf
	mov	w0, -1
.L481:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L483:
	ldr	x19, [x2, 32]
	add	w0, w0, 1
	add	x19, x19, x30, uxtw 2
	add	w30, w30, w20
	str	x19, [x21], 8
	b	.L482
.L485:
	add	x20, x0, x19
	add	x20, x1, x20, lsl 3
	str	xzr, [x20, 24]
	b	.L484
.L486:
	ldr	x0, [x26, #:lo12:.LANCHOR130]
	cbz	x0, .L488
	adrp	x0, .LANCHOR134
	ldr	x0, [x0, #:lo12:.LANCHOR134]
	cbz	x0, .L488
	adrp	x0, .LANCHOR135
	ldr	x0, [x0, #:lo12:.LANCHOR135]
	cbz	x0, .L488
	adrp	x0, .LANCHOR55
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	cbz	x0, .L488
	adrp	x0, .LANCHOR136
	ldr	x0, [x0, #:lo12:.LANCHOR136]
	cbz	x0, .L488
	adrp	x0, .LANCHOR40
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	cbz	x0, .L488
	adrp	x0, .LANCHOR37+32
	ldr	x0, [x0, #:lo12:.LANCHOR37+32]
	cbz	x0, .L488
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	cbz	x0, .L488
	ldr	x0, [x17, #:lo12:.LANCHOR96]
	cbz	x0, .L488
	ldr	x0, [x16, #:lo12:.LANCHOR98]
	cbz	x0, .L488
	ldr	x0, [x15, #:lo12:.LANCHOR120]
	cbz	x0, .L488
	ldr	x0, [x14, #:lo12:.LANCHOR122]
	cbz	x0, .L488
	ldr	x0, [x13, #:lo12:.LANCHOR111]
	cbz	x0, .L488
	ldr	x0, [x12, #:lo12:.LANCHOR93]
	cbz	x0, .L488
	ldr	x0, [x11, #:lo12:.LANCHOR121]
	cbz	x0, .L488
	ldr	x0, [x10, #:lo12:.LANCHOR107]
	cbz	x0, .L488
	ldr	x0, [x8, #:lo12:.LANCHOR123]
	cbz	x0, .L488
	ldr	x0, [x7, #:lo12:.LANCHOR124]
	cbz	x0, .L488
	ldr	x0, [x6, #:lo12:.LANCHOR91]
	cbz	x0, .L488
	ldr	x0, [x5, #:lo12:.LANCHOR115]
	cbz	x0, .L488
	ldr	x0, [x4, #:lo12:.LANCHOR113]
	cbz	x0, .L488
	ldr	x0, [x3, #:lo12:.LANCHOR90]
	cbz	x0, .L488
	ldr	x0, [x24, #:lo12:.LANCHOR108]
	cbz	x0, .L488
	ldr	x0, [x23, #:lo12:.LANCHOR114]
	cbz	x0, .L488
	ldr	x0, [x22, #:lo12:.LANCHOR92]
	cbz	x0, .L488
	ldr	x0, [x29, 200]
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	cbz	x0, .L488
	adrp	x0, .LANCHOR126
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	cbz	x0, .L488
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	cbz	x0, .L488
	adrp	x0, .LANCHOR131
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	cbz	x0, .L488
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	cbz	x0, .L488
	adrp	x0, .LANCHOR133
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	cbz	x0, .L488
	mov	w0, 0
	b	.L481
	.size	FtlMemInit, .-FtlMemInit
	.section	.text.FtlBbt2Bitmap,"ax",@progbits
	.align	2
	.global	FtlBbt2Bitmap
	.type	FtlBbt2Bitmap, %function
FtlBbt2Bitmap:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	adrp	x0, .LANCHOR137
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR17
	adrp	x23, .LANCHOR139
	ldrh	w2, [x0, #:lo12:.LANCHOR137]
	add	x21, x21, :lo12:.LANCHOR17
	add	x23, x23, :lo12:.LANCHOR139
	stp	x19, x20, [sp, 16]
	mov	w24, 65535
	mov	x19, 0
	mov	x20, x1
	lsl	w2, w2, 2
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
.L586:
	ldrh	w0, [x22, x19]
	cmp	w0, w24
	beq	.L583
	ldrh	w1, [x21]
	cmp	w1, w0
	bhi	.L585
	adrp	x0, .LC1
	mov	w2, 74
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.L585:
	ldrh	w2, [x22, x19]
	mov	w1, 1
	add	x19, x19, 2
	cmp	x19, 1024
	ubfx	x0, x2, 5, 11
	lsl	w2, w1, w2
	lsl	x0, x0, 2
	ldr	w1, [x20, x0]
	orr	w1, w1, w2
	str	w1, [x20, x0]
	bne	.L586
.L583:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	FtlBbt2Bitmap, .-FtlBbt2Bitmap
	.section	.text.FtlBbtMemInit,"ax",@progbits
	.align	2
	.global	FtlBbtMemInit
	.type	FtlBbtMemInit, %function
FtlBbtMemInit:
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	mov	w2, -1
	add	x0, x0, 12
	strh	w2, [x1, #:lo12:.LANCHOR37]
	mov	w2, 16
	strh	wzr, [x0, -6]
	mov	w1, 255
	b	ftl_memset
	.size	FtlBbtMemInit, .-FtlBbtMemInit
	.section	.text.FtlFreeSysBlkQueueInit,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueInit
	.type	FtlFreeSysBlkQueueInit, %function
FtlFreeSysBlkQueueInit:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR38
	add	x3, x1, :lo12:.LANCHOR38
	mov	w2, 2048
	add	x29, sp, 0
	strh	w0, [x1, #:lo12:.LANCHOR38]
	mov	w1, 0
	strh	wzr, [x3, 2]
	add	x0, x3, 8
	strh	wzr, [x3, 4]
	strh	wzr, [x3, 6]
	bl	ftl_memset
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.global	load_l2p_region
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR32
	stp	x19, x20, [sp, 16]
	and	x19, x1, 65535
	stp	x21, x22, [sp, 32]
	and	w21, w0, 65535
	stp	x25, x26, [sp, 64]
	ldrh	w0, [x23, #:lo12:.LANCHOR32]
	cmp	w0, w21
	bcs	.L594
	adrp	x1, .LANCHOR140
	adrp	x0, .LC1
	mov	w2, 492
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.L594:
	adrp	x26, .LANCHOR134
	ubfiz	x0, x21, 2, 16
	adrp	x22, .LANCHOR55
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	ldr	w24, [x1, x0]
	cbnz	w24, .L595
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
	adrp	x1, .LANCHOR23
	add	x0, x0, x19
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	strh	w21, [x0, x19]
	str	wzr, [x1, 4]
.L596:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L595:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
	adrp	x20, .LANCHOR106
	add	x20, x20, :lo12:.LANCHOR106
	add	x0, x0, x19
	mov	w2, 1
	mov	w1, w2
	str	w24, [x20, 4]
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	str	x0, [x20, 16]
	mov	x0, x20
	bl	FlashReadPages
	ldr	x25, [x20, 16]
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L597
	mov	w2, w24
	mov	w1, w21
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	bl	printf
	ldr	x1, [x20, 16]
	mov	w3, 4
	adrp	x0, .LC87
	mov	w2, w3
	add	x0, x0, :lo12:.LC87
	bl	rknand_print_hex
	ldrh	w3, [x23, #:lo12:.LANCHOR32]
	adrp	x0, .LC88
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	mov	w2, 4
	add	x0, x0, :lo12:.LC88
	bl	rknand_print_hex
.L597:
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L598
	adrp	x1, .LANCHOR140
	adrp	x0, .LC1
	mov	w2, 513
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.L598:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	strh	w21, [x0, x19]
	b	.L596
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.ftl_free_no_use_map_blk,"ax",@progbits
	.align	2
	.global	ftl_free_no_use_map_blk
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
	stp	x29, x30, [sp, -80]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w2, [x0, 10]
	stp	x21, x22, [sp, 32]
	ldp	x21, x20, [x0, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	lsl	w2, w2, 1
	ldr	x23, [x0, 16]
	mov	x0, x21
	bl	ftl_memset
	mov	w0, 0
.L601:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L605
	ldrh	w26, [x21]
	adrp	x24, .LANCHOR20
	add	x24, x24, :lo12:.LANCHOR20
	mov	w25, 0
	mov	w20, 0
.L606:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L610
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L605:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L602:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L604
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L601
.L604:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x23, x3]
	cmp	w4, w2
	bne	.L603
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L603:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L602
.L610:
	ldrh	w0, [x19]
	uxtw	x22, w20
	cmp	w0, w20
	bne	.L607
	ldrh	w0, [x24]
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bcs	.L607
	strh	w0, [x21, x22, lsl 1]
.L607:
	lsl	x22, x22, 1
	ldrh	w0, [x21, x22]
	cmp	w26, w0
	bls	.L608
	mov	w25, w20
	mov	w26, w0
.L608:
	cbnz	w0, .L609
	ldrh	w0, [x23, x22]
	cbz	w0, .L609
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x23, x22]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
.L609:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L606
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	stp	x29, x30, [sp, -64]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x20, [x0, 16]
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0]
	str	x23, [sp, 48]
	cmp	w0, w1
	bne	.L616
	ldrh	w0, [x19, 8]
	cbz	w0, .L617
	adrp	x1, .LANCHOR141
	adrp	x0, .LC1
	mov	w2, 641
	add	x1, x1, :lo12:.LANCHOR141
	add	x0, x0, :lo12:.LC1
	bl	printf
.L617:
	ldrh	w0, [x19, 8]
	add	w0, w0, 1
	strh	w0, [x19, 8]
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x20]
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	strh	wzr, [x19]
	str	w0, [x19, 48]
.L618:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L616:
	ubfiz	x0, x0, 1, 16
	adrp	x1, .LANCHOR108
	adrp	x23, .LANCHOR107
	ldr	x22, [x19, 40]
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	ldrh	w21, [x20, x0]
	adrp	x20, .LANCHOR106
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR106
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x1, [x2, 16]
	str	x0, [x2, 8]
	ldr	w2, [x19, 48]
	str	w2, [x1, 4]
	mov	w2, -1291
	strh	w2, [x1, 8]
	ldrh	w2, [x19, 4]
	strh	w2, [x1]
	strh	w21, [x1, 2]
	adrp	x1, .LANCHOR20
	ldrh	w2, [x1, #:lo12:.LANCHOR20]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
	ldrh	w4, [x19, 6]
	mov	x1, 0
	ldr	x3, [x23, #:lo12:.LANCHOR107]
	mov	w2, 0
.L619:
	cmp	w4, w1, uxth
	bhi	.L621
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x20, :lo12:.LANCHOR106
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L618
.L621:
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L620
	add	w2, w2, 1
	and	w2, w2, 65535
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L620:
	add	x1, x1, 1
	b	.L619
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",@progbits
	.align	2
	.global	FtlMapWritePage
	.type	FtlMapWritePage, %function
FtlMapWritePage:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR66
	stp	x25, x26, [sp, 64]
	adrp	x24, .LANCHOR142
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR20
	stp	x19, x20, [sp, 16]
	mov	w25, w1
	mov	x19, x0
	mov	x27, x2
	add	x23, x23, :lo12:.LANCHOR66
	add	x24, x24, :lo12:.LANCHOR142
	add	x28, x26, :lo12:.LANCHOR20
	stp	x21, x22, [sp, 32]
	mov	w22, 0
.L627:
	ldr	w0, [x23]
	ldrh	w1, [x19, 2]
	add	w0, w0, 1
	str	w0, [x23]
	ldrh	w0, [x26, #:lo12:.LANCHOR20]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L628
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L629
.L628:
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.L629:
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L630
	adrp	x0, .LC1
	mov	w2, 699
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L630:
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L631
	adrp	x0, .LC1
	mov	w2, 700
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L631:
	ldrh	w1, [x19]
	adrp	x21, .LANCHOR106
	ldr	x0, [x19, 16]
	add	x20, x21, :lo12:.LANCHOR106
	mov	w2, 16
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x19, 2]
	str	w3, [x29, 108]
	str	x27, [x20, 8]
	orr	w0, w0, w3, lsl 10
	str	w0, [x20, 4]
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	str	x0, [x20, 16]
	bl	ftl_memset
	ldr	x0, [x20, 16]
	ldr	w1, [x19, 48]
	ldr	w3, [x29, 108]
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	strh	w1, [x0]
	strh	w3, [x0, 2]
	mov	w3, 1
	strh	w25, [x0, 8]
	mov	w1, w3
	mov	w2, w3
	mov	x0, x20
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	ldr	w1, [x21, #:lo12:.LANCHOR106]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L632
	ldr	w1, [x20, 4]
	adrp	x0, .LC89
	add	x0, x0, :lo12:.LC89
	add	w22, w22, 1
	and	w22, w22, 65535
	bl	printf
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L633
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L633:
	cmp	w22, 3
	bls	.L634
	add	x21, x21, :lo12:.LANCHOR106
	adrp	x0, .LC90
	mov	w2, w22
	add	x0, x0, :lo12:.LC90
	ldr	w1, [x21, 4]
	bl	printf
.L635:
	b	.L635
.L634:
	ldr	w0, [x19, 52]
	cbz	w0, .L627
.L644:
	b	.L644
.L632:
	cmp	w0, 1
	beq	.L627
	ldr	x0, [x19, 40]
	ldr	w1, [x20, 4]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	str	w1, [x0, w25, uxtw 2]
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 112
	ret
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.ftl_map_blk_gc,"ax",@progbits
	.align	2
	.global	ftl_map_blk_gc
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR20
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	x20, [x0, 16]
	ldr	x24, [x0, 40]
	bl	ftl_free_no_use_map_blk
	ldrh	w1, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w1, #4
	cmp	w2, w1
	blt	.L647
	ubfiz	x0, x0, 1, 16
	ldrh	w21, [x20, x0]
	cbz	w21, .L647
	ldr	w1, [x19, 52]
	cbnz	w1, .L647
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L648
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L648:
	adrp	x25, .LANCHOR106
	adrp	x22, .LANCHOR143
	add	x26, x25, :lo12:.LANCHOR106
	add	x22, x22, :lo12:.LANCHOR143
	mov	w20, 0
.L649:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L653
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L647:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L654
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L654:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L653:
	ubfiz	x27, x20, 2, 16
	ldr	w1, [x24, x27]
	cmp	w21, w1, lsr 10
	bne	.L650
	adrp	x2, .LANCHOR123
	add	x0, x25, :lo12:.LANCHOR106
	ldr	x2, [x2, #:lo12:.LANCHOR123]
	str	x2, [x0, 8]
	adrp	x2, .LANCHOR108
	str	w1, [x0, 4]
	ldr	x28, [x2, #:lo12:.LANCHOR108]
	mov	w2, 1
	str	x28, [x0, 16]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x28, 8]
	cmp	w0, w20
	beq	.L651
	adrp	x0, .LC1
	mov	w2, 613
	mov	x1, x22
	add	x0, x0, :lo12:.LC1
	bl	printf
.L651:
	ldr	w0, [x26]
	cmn	w0, #1
	bne	.L652
	str	wzr, [x24, x27]
.L650:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L649
.L652:
	ldr	x2, [x26, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
	b	.L650
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR55
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapWritePage
	ldr	x0, [x20, #:lo12:.LANCHOR55]
	add	x0, x0, x19
	ldp	x19, x20, [sp, 16]
	ldr	w1, [x0, 4]
	and	w1, w1, 2147483647
	str	w1, [x0, 4]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.log2phys,"ax",@progbits
	.align	2
	.global	log2phys
	.type	log2phys, %function
log2phys:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x1
	adrp	x1, .LANCHOR22
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w24, w2
	ldrh	w19, [x1, #:lo12:.LANCHOR22]
	str	x25, [sp, 64]
	add	w1, w19, 7
	mov	x19, 1
	lsr	w22, w0, w1
	and	w22, w22, 65535
	lsl	x19, x19, x1
	adrp	x1, .LANCHOR61
	sub	w19, w19, #1
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	and	w19, w19, w0
	and	x19, x19, 65535
	cmp	w0, w1
	bcc	.L662
	adrp	x1, .LANCHOR145
	adrp	x0, .LC1
	mov	w2, 808
	add	x1, x1, :lo12:.LANCHOR145
	add	x0, x0, :lo12:.LC1
	bl	printf
.L662:
	adrp	x21, .LANCHOR55
	adrp	x0, .LANCHOR33
	ldr	x2, [x21, #:lo12:.LANCHOR55]
	ldrh	w1, [x0, #:lo12:.LANCHOR33]
	mov	x0, 0
.L663:
	and	x20, x0, 65535
	cmp	w20, w1
	bcc	.L668
	bl	select_l2p_ram_region
	and	x20, x0, 65535
	ldr	x2, [x21, #:lo12:.LANCHOR55]
	ubfiz	x1, x20, 4, 16
	mov	w25, w0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L669
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L669
	bl	flush_l2p_region
.L669:
	mov	w1, w25
	mov	w0, w22
	bl	load_l2p_region
	b	.L664
.L668:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L663
.L664:
	ldr	x0, [x21, #:lo12:.LANCHOR55]
	add	x0, x0, x20, lsl 4
	cbnz	w24, .L665
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x19, lsl 2]
	str	w0, [x23]
.L666:
	ldr	x0, [x21, #:lo12:.LANCHOR55]
	add	x20, x0, x20, lsl 4
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L671
	add	w0, w0, 1
	str	w0, [x20, 4]
.L671:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L665:
	ldr	x1, [x0, 8]
	ldr	w2, [x23]
	str	w2, [x1, x19, lsl 2]
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	adrp	x0, .LANCHOR56
	strh	w22, [x0, #:lo12:.LANCHOR56]
	b	.L666
	.size	log2phys, .-log2phys
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR42
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	lsr	w0, w1, 10
	str	x23, [sp, 48]
	bl	P2V_block_in_plane
	ldr	x2, [x22, #:lo12:.LANCHOR42]
	and	w3, w0, 65535
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L677
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L678
	adrp	x2, .LANCHOR40
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	adrp	x23, .LANCHOR48
	ldr	x2, [x2, #:lo12:.LANCHOR40]
	mov	w6, 65535
	ldrh	w4, [x23, #:lo12:.LANCHOR48]
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	mov	w5, 6
	and	w19, w19, 65535
.L679:
	cmp	w1, w4
	beq	.L678
	cmp	w19, w3
	bne	.L680
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cbnz	w0, .L681
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 1688
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.L681:
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR48]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L678:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L680:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L678
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L679
.L677:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L678
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	sub	sp, sp, #96
	adrp	x0, .LC91
	mov	w1, 0
	add	x0, x0, :lo12:.LC91
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR106
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR61
	add	x22, x20, :lo12:.LANCHOR106
	add	x21, x21, :lo12:.LANCHOR61
	str	x23, [sp, 64]
	bl	printf
.L688:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L694
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L694:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L689
	ldr	w2, [x29, 76]
	adrp	x0, .LC92
	mov	w1, w19
	add	x0, x0, :lo12:.LC92
	bl	printf
.L689:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L691
	add	x0, x20, :lo12:.LANCHOR106
	str	wzr, [x20, #:lo12:.LANCHOR106]
	mov	w2, 0
	str	w1, [x0, 4]
	adrp	x1, .LANCHOR107
	str	w19, [x0, 24]
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	str	x1, [x0, 8]
	adrp	x1, .LANCHOR108
	ldr	x23, [x1, #:lo12:.LANCHOR108]
	mov	w1, 1
	str	x23, [x0, 16]
	bl	FlashReadPages
	ldr	w0, [x20, #:lo12:.LANCHOR106]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L692
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L691
.L692:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC93
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC93
	mov	w1, w19
	bl	printf
.L691:
	add	w19, w19, 1
	b	.L688
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.FtlReadRefresh,"ax",@progbits
	.align	2
	.global	FtlReadRefresh
	.type	FtlReadRefresh, %function
FtlReadRefresh:
	adrp	x1, .LANCHOR81
	add	x0, x1, :lo12:.LANCHOR81
	ldr	w2, [x0, 80]
	cbz	w2, .L697
	adrp	x1, .LANCHOR61
	ldr	w3, [x0, 84]
	ldr	w2, [x1, #:lo12:.LANCHOR61]
	cmp	w3, w2
	bcs	.L698
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	add	x20, x1, :lo12:.LANCHOR61
	str	x21, [sp, 32]
	mov	w21, 2048
.L703:
	ldr	w0, [x19, 84]
	ldr	w1, [x20]
	cmp	w0, w1
	bcs	.L700
	add	x1, x29, 60
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x19, 84]
	ldr	w1, [x29, 60]
	add	w0, w0, 1
	str	w0, [x19, 84]
	cmn	w1, #1
	beq	.L701
	str	w0, [x29, 88]
	adrp	x0, ftl_temp_buf
	add	x0, x0, :lo12:ftl_temp_buf
	str	x0, [x29, 72]
	add	x0, x29, 96
	str	x0, [x29, 80]
	add	x0, x29, 160
	str	w1, [x29, 68]
	mov	w2, 0
	mov	w1, 1
	str	wzr, [x0, -96]!
	bl	FlashReadPages
	ldr	w0, [x29, 64]
	cmp	w0, 256
	bne	.L700
	ldr	w0, [x29, 60]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
.L700:
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 160
	ret
.L701:
	subs	w21, w21, #1
	bne	.L703
	b	.L700
.L698:
	adrp	x1, .LANCHOR62
	str	wzr, [x0, 84]
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	stp	w1, wzr, [x0, 76]
.L707:
	mov	w0, 0
	ret
.L697:
	ldr	w4, [x0, 76]
	adrp	x0, .LANCHOR62
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	add	w0, w2, 1048576
	cmp	w4, w0
	bhi	.L706
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	lsr	w3, w0, 10
	mov	w0, 33554432
	asr	w0, w0, w3
	add	w0, w0, w4
	cmp	w2, w0
	bhi	.L706
	adrp	x0, .LANCHOR39+28
	ldrb	w0, [x0, #:lo12:.LANCHOR39+28]
	cbnz	w0, .L707
.L706:
	add	x0, x1, :lo12:.LANCHOR81
	mov	w1, 1
	str	wzr, [x0, 84]
	stp	w2, w1, [x0, 76]
	b	.L707
	.size	FtlReadRefresh, .-FtlReadRefresh
	.section	.text.FtlMapBlkWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDump_data
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
	ldr	w1, [x0, 56]
	cbz	w1, .L713
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR106
	adrp	x2, .LANCHOR108
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x0, 6]
	adrp	x0, .LANCHOR123
	ldr	x2, [x2, #:lo12:.LANCHOR108]
	ldr	x3, [x0, #:lo12:.LANCHOR123]
	add	x0, x1, :lo12:.LANCHOR106
	sub	w20, w20, #1
	ldr	x4, [x19, 40]
	and	w20, w20, 65535
	str	x21, [sp, 32]
	stp	x3, x2, [x0, 8]
	ubfiz	x2, x20, 2, 16
	str	wzr, [x19, 56]
	mov	x21, x1
	ldr	w2, [x4, x2]
	str	w2, [x0, 4]
	cbz	w2, .L715
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L716:
	add	x1, x21, :lo12:.LANCHOR106
	mov	x0, x19
	ldr	x21, [sp, 32]
	ldr	x2, [x1, 8]
	mov	w1, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	FtlMapWritePage
.L715:
	adrp	x0, .LANCHOR23
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR23]
	mov	x0, x3
	bl	ftl_memset
	b	.L716
.L713:
	ret
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
	.section	.text.FtlScanSysBlk,"ax",@progbits
	.align	2
	.global	FtlScanSysBlk
	.type	FtlScanSysBlk, %function
FtlScanSysBlk:
	stp	x29, x30, [sp, -176]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR135
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR30
	ldr	x0, [x25, #:lo12:.LANCHOR135]
	adrp	x22, .LANCHOR132
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR147
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR35
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR129
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR147]
	strh	wzr, [x23, #:lo12:.LANCHOR35]
	bl	ftl_memset
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	adrp	x19, .LANCHOR27
	adrp	x28, .LANCHOR36
	adrp	x24, .LANCHOR79
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR132]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldr	x0, [x28, #:lo12:.LANCHOR36]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 12
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR79
	bl	ftl_memset
	adrp	x0, .LANCHOR5
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR70
	add	x0, x0, :lo12:.LANCHOR70
	str	x0, [x29, 112]
.L721:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L761
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR120
	adrp	x6, .LANCHOR13
	mov	x5, 0
	ldrh	w12, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR91
	ldr	x7, [x25, #:lo12:.LANCHOR120]
	mov	w22, 0
	ldr	x11, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LANCHOR92
	add	x6, x6, :lo12:.LANCHOR13
	ldr	x10, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x0, #:lo12:.LANCHOR24]
	b	.L762
.L723:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L722
	ubfiz	x0, x22, 5, 16
	mul	w1, w22, w8
	add	x0, x7, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	lsl	w4, w4, 10
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	str	w4, [x0, 4]
	stp	x11, x1, [x0, 8]
.L722:
	add	x5, x5, 1
.L762:
	cmp	w12, w5, uxth
	bhi	.L723
	cbnz	w22, .L724
.L760:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L721
.L724:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR148
	add	x0, x0, :lo12:.LANCHOR148
	str	x0, [x29, 136]
.L759:
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L727
	mov	w5, 16
	mov	w7, 65535
.L729:
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x6, x25, :lo12:.LANCHOR120
	mov	w2, 1
	str	w7, [x29, 100]
	add	x0, x0, x22
	str	x6, [x29, 104]
	str	w5, [x29, 168]
	ldr	w1, [x0, 4]
	add	w1, w1, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x27]
	ldr	w7, [x29, 100]
	ldr	w5, [x29, 168]
	cmp	w0, w7
	ldr	x6, [x29, 104]
	bne	.L726
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	bne	.L727
.L728:
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L732
.L726:
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L727
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L729
	b	.L728
.L727:
	adrp	x0, .LANCHOR70
	ldr	w1, [x0, #:lo12:.LANCHOR70]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L730
	cmp	w1, w0
	bhi	.L731
.L730:
	cmn	w0, #1
	beq	.L731
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L731:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L733
	bhi	.L734
	mov	w0, 61574
	cmp	w1, w0
	beq	.L735
.L732:
	ldr	x0, [x29, 128]
	add	x22, x22, 32
	cmp	x0, x22
	bne	.L759
	b	.L760
.L734:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L736
	mov	w0, 65535
	cmp	w1, w0
	beq	.L728
	b	.L732
.L736:
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L738
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1211
	add	x0, x0, :lo12:.LC1
	bl	printf
.L738:
	ldr	w6, [x21, #:lo12:.LANCHOR30]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR135]
	sxth	w2, w2
.L739:
	cmp	w0, w2
	bgt	.L745
	tbz	w0, #31, .L779
	b	.L732
.L745:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L740
	ldr	w2, [x5]
	cbnz	w2, .L741
	cmp	w6, w1
	beq	.L741
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
.L741:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L742:
	cmp	w1, w0
	bne	.L743
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L732
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L732
.L779:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L797:
	strh	w26, [x1, x0, lsl 1]
	b	.L732
.L743:
	sxtw	x2, w1
	add	w1, w1, 1
	lsl	x7, x2, 2
	lsl	x2, x2, 1
	add	x11, x5, x7
	sxth	w1, w1
	ldr	w11, [x11, 4]
	str	w11, [x5, x7]
	add	x7, x6, x2
	ldrh	w7, [x7, 2]
	strh	w7, [x6, x2]
	b	.L742
.L740:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L739
.L735:
	ldrh	w1, [x23, #:lo12:.LANCHOR35]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	cmp	w1, w0
	bls	.L748
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1252
	add	x0, x0, :lo12:.LC1
	bl	printf
.L748:
	ldrh	w6, [x19, #:lo12:.LANCHOR27]
	ldrh	w2, [x23, #:lo12:.LANCHOR35]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
.L749:
	cmp	w0, w5
	ble	.L754
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L750
	ldr	w5, [x1]
	cbnz	w5, .L751
	cmp	w6, w2
	beq	.L751
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR35]
.L751:
	ldr	x6, [x28, #:lo12:.LANCHOR36]
	mov	w2, 0
.L752:
	cmp	w2, w0
	bne	.L753
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L754:
	tbnz	w0, #31, .L732
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	ldrh	w5, [x23, #:lo12:.LANCHOR35]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L732
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR35]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	b	.L797
.L753:
	sxtw	x5, w2
	add	w2, w2, 1
	lsl	x8, x5, 2
	lsl	x5, x5, 1
	add	x11, x1, x8
	sxth	w2, w2
	ldr	w11, [x11, 4]
	str	w11, [x1, x8]
	add	x8, x6, x5
	ldrh	w8, [x8, 2]
	strh	w8, [x6, x5]
	b	.L752
.L750:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L749
.L733:
	ldrh	w5, [x24, #:lo12:.LANCHOR79]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR79
	cmp	w5, w1
	bne	.L756
	strh	w26, [x24, #:lo12:.LANCHOR79]
	str	w0, [x2, 8]
	b	.L732
.L756:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L757
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L757:
	add	x0, x24, :lo12:.LANCHOR79
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L758
	ldrh	w2, [x24, #:lo12:.LANCHOR79]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR79]
	str	w1, [x0, 8]
	b	.L732
.L758:
	strh	w26, [x0, 4]
	b	.L732
.L761:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L763
.L766:
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	ldrh	w0, [x1]
	cbz	w0, .L764
.L765:
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L795
	adrp	x1, .LANCHOR148
	adrp	x0, .LC1
	mov	w2, 1377
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC1
	bl	printf
.L795:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L763:
	ldrh	w0, [x20, #:lo12:.LANCHOR147]
	cbz	w0, .L766
	ldr	w1, [x21, #:lo12:.LANCHOR30]
	mov	w0, 0
.L767:
	cmp	w0, w1
	bcs	.L766
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L768
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR30
	ldr	x4, [x1, #:lo12:.LANCHOR135]
	mov	w1, w0
.L769:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L766
	sxtw	x6, w1
	sub	w3, w1, w0
	lsl	x5, x6, 1
	sxtw	x3, w3
	add	w1, w1, 1
	ldr	w6, [x4, x6, lsl 2]
	sxth	w1, w1
	ldrh	w8, [x2, x5]
	strh	w8, [x2, x3, lsl 1]
	str	w6, [x4, x3, lsl 2]
	strh	wzr, [x2, x5]
	b	.L769
.L768:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L767
.L764:
	ldrh	w0, [x23, #:lo12:.LANCHOR35]
	cbz	w0, .L765
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	mov	w0, 0
.L774:
	mov	w6, w0
	cmp	w0, w2
	bge	.L765
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L775
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR27
	ldr	x3, [x2, #:lo12:.LANCHOR132]
.L776:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L765
	sxtw	x5, w0
	sub	w2, w0, w6
	lsl	x4, x5, 1
	sxtw	x2, w2
	add	w0, w0, 1
	ldr	w5, [x3, x5, lsl 2]
	sxth	w0, w0
	ldrh	w7, [x1, x4]
	strh	w7, [x1, x2, lsl 1]
	str	w5, [x3, x2, lsl 2]
	strh	wzr, [x1, x4]
	b	.L776
.L775:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L774
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	stp	x29, x30, [sp, -144]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR106
	ldrh	w23, [x0, 6]
	adrp	x24, .LANCHOR20
	stp	x21, x22, [sp, 32]
	ldr	x21, [x0, 40]
	ldr	x22, [x0, 16]
	lsl	w2, w23, 2
	ldr	x0, [x0, 24]
	str	x0, [x29, 128]
	ldrh	w0, [x19, 8]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	mov	w27, 0
	str	w0, [x29, 140]
	mov	x0, x21
	bl	ftl_memset
	str	x20, [x29, 120]
	adrp	x7, .LANCHOR107
	add	x3, x20, :lo12:.LANCHOR106
	mov	x26, x7
	mov	x20, x3
	ldr	x0, [x7, #:lo12:.LANCHOR107]
	str	x0, [x3, 8]
	adrp	x0, .LANCHOR108
	stp	wzr, wzr, [x19, 48]
	ldr	x25, [x0, #:lo12:.LANCHOR108]
	mov	w0, -1
	str	x25, [x3, 16]
	strh	w0, [x19]
	strh	w0, [x19, 2]
	mov	w0, 1
	str	w0, [x19, 56]
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	str	w0, [x29, 136]
	add	x0, x24, :lo12:.LANCHOR20
	str	x0, [x29, 112]
.L799:
	ldr	w0, [x29, 140]
	cmp	w27, w0
	bge	.L816
	ldr	w0, [x29, 136]
	sxtw	x28, w27
	cmp	w27, w0
	bne	.L800
	lsl	x0, x28, 1
	mov	w1, 1
	add	x24, x22, x0
	ldrh	w0, [x22, x0]
	mov	w22, 0
	bl	FtlGetLastWrittenPage
	sxth	w26, w0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	x0, [x29, 128]
	strh	w27, [x19]
	ldr	w0, [x0, x28, lsl 2]
	str	w0, [x19, 48]
	ldr	x0, [x29, 120]
	add	x20, x0, :lo12:.LANCHOR106
.L801:
	cmp	w22, w26
	ble	.L803
.L816:
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR20
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bne	.L805
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L805:
	mov	x0, x19
	bl	ftl_map_blk_gc
	mov	x0, x19
	bl	ftl_map_blk_gc
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L803:
	ldrh	w0, [x24]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L802
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L802
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L802
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L802:
	add	w22, w22, 1
	sxth	w22, w22
	b	.L801
.L800:
	ldr	x0, [x26, #:lo12:.LANCHOR107]
	mov	w2, 1
	str	x0, [x20, 8]
	lsl	x0, x28, 1
	ldrh	w1, [x24, #:lo12:.LANCHOR20]
	add	x28, x22, x0
	ldrh	w0, [x22, x0]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	mov	w1, w2
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L818
	ldrh	w1, [x25]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L818
	ldrh	w1, [x25, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L807
.L818:
	mov	w5, 0
.L808:
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L814
	ldrh	w0, [x28]
	mov	w2, 1
	str	w5, [x29, 108]
	mov	w1, w2
	orr	w0, w5, w0, lsl 10
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	ldr	w5, [x29, 108]
	cmn	w0, #1
	beq	.L812
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L812
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L812
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L812:
	add	w5, w5, 1
	sxth	w5, w5
	b	.L808
.L807:
	ldrh	w5, [x24, #:lo12:.LANCHOR20]
	mov	w0, 0
	ldr	x10, [x26, #:lo12:.LANCHOR107]
	sub	w5, w5, #1
.L809:
	cmp	w0, w5
	blt	.L811
.L814:
	add	w4, w27, 1
	sxth	w27, w4
	b	.L799
.L811:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
	cmp	w23, w1
	bls	.L810
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x10, x2, lsl 2]
	str	w2, [x21, x1]
.L810:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L809
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR27
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR27]
	strh	w1, [x0, 10]
	mov	w1, -3962
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR35
	ldrh	w1, [x1, #:lo12:.LANCHOR35]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR28
	ldrh	w1, [x1, #:lo12:.LANCHOR28]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR36
	ldr	x1, [x1, #:lo12:.LANCHOR36]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR132
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	str	x1, [x0, 24]
	adrp	x1, .LANCHOR131
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR133
	ldr	x1, [x1, #:lo12:.LANCHOR133]
	str	x1, [x0, 40]
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.FtlL2PDataInit,"ax",@progbits
	.align	2
	.global	FtlL2PDataInit
	.type	FtlL2PDataInit, %function
FtlL2PDataInit:
	stp	x29, x30, [sp, -64]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR130
	adrp	x20, .LANCHOR30
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR130]
	adrp	x22, .LANCHOR23
	ldr	w2, [x20, #:lo12:.LANCHOR30]
	adrp	x21, .LANCHOR33
	str	x23, [sp, 48]
	adrp	x23, .LANCHOR136
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR33]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR23]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR136]
	bl	ftl_memset
	adrp	x0, .LANCHOR55
	ldrh	w3, [x21, #:lo12:.LANCHOR33]
	ldr	x6, [x23, #:lo12:.LANCHOR136]
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR23]
	add	x3, x0, x3, lsl 4
.L829:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L830
	adrp	x1, .LANCHOR144
	add	x0, x1, :lo12:.LANCHOR144
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR144]
	ldr	w1, [x20, #:lo12:.LANCHOR30]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR147
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR147]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR32
	ldrh	w1, [x1, #:lo12:.LANCHOR32]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR129
	ldr	x1, [x1, #:lo12:.LANCHOR129]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR135
	ldr	x1, [x1, #:lo12:.LANCHOR135]
	str	x1, [x0, 24]
	ldr	x1, [x19, #:lo12:.LANCHOR130]
	ldp	x19, x20, [sp, 16]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR134
	ldr	x1, [x1, #:lo12:.LANCHOR134]
	str	x1, [x0, 40]
	ldp	x29, x30, [sp], 64
	ret
.L830:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L829
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlLoadMapInfo,"ax",@progbits
	.align	2
	.global	FtlLoadMapInfo
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlL2PDataInit
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR150
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR151
	mov	w1, -1
	str	x19, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR152
	adrp	x19, .LANCHOR6
	str	wzr, [x0, #:lo12:.LANCHOR152]
	adrp	x0, .LANCHOR153
	str	w1, [x0, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR35
	mov	w1, 0
	strh	wzr, [x0, #:lo12:.LANCHOR35]
	adrp	x0, .LANCHOR27
	ldrh	w2, [x0, #:lo12:.LANCHOR27]
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR43
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR126
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR39
	add	x0, x0, :lo12:.LANCHOR39
	bl	ftl_memset
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlVariablesInit, .-FtlVariablesInit
	.section	.text.SupperBlkListInit,"ax",@progbits
	.align	2
	.global	SupperBlkListInit
	.type	SupperBlkListInit, %function
SupperBlkListInit:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR6
	mov	w1, 0
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	mov	w0, 6
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR40
	stp	x19, x20, [sp, 16]
	adrp	x23, .LANCHOR45
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR48
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR5
	str	x27, [sp, 80]
	adrp	x26, .LANCHOR13
	add	x25, x25, :lo12:.LANCHOR5
	add	x26, x26, :lo12:.LANCHOR13
	bl	ftl_memset
	mov	w21, 0
	adrp	x0, .LANCHOR47
	mov	w20, 0
	mov	w19, 0
	strh	wzr, [x23, #:lo12:.LANCHOR45]
	str	xzr, [x0, #:lo12:.LANCHOR47]
	adrp	x0, .LANCHOR41
	strh	wzr, [x22, #:lo12:.LANCHOR48]
	adrp	x27, .LANCHOR3
	str	xzr, [x0, #:lo12:.LANCHOR41]
	adrp	x0, .LANCHOR44
	str	xzr, [x0, #:lo12:.LANCHOR44]
.L837:
	ldrh	w0, [x25]
	cmp	w19, w0
	bcs	.L843
	adrp	x0, .LANCHOR19
	ldrh	w8, [x27, #:lo12:.LANCHOR3]
	mov	x6, 0
	mov	w5, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR19]
	b	.L844
.L839:
	ldrb	w0, [x26, x6]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L838
	add	w5, w5, w7
	and	w5, w5, 65535
.L838:
	add	x6, x6, 1
.L844:
	cmp	w8, w6, uxth
	bhi	.L839
	cbz	w5, .L846
	mov	w0, 32768
	sdiv	w5, w0, w5
.L840:
	ldr	x1, [x24, #:lo12:.LANCHOR40]
	mov	w0, 6
	umaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L841
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L841
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L841
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbnz	w0, .L842
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L841:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L837
.L846:
	mov	w5, 0
	b	.L840
.L842:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L841
.L843:
	strh	w20, [x23, #:lo12:.LANCHOR45]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR48]
	cmp	w20, w0
	ble	.L845
	adrp	x1, .LANCHOR154
	adrp	x0, .LC1
	mov	w2, 2154
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC1
	bl	printf
.L845:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	SupperBlkListInit, .-SupperBlkListInit
	.section	.text.ftl_check_vpc,"ax",@progbits
	.align	2
	.global	ftl_check_vpc
	.type	ftl_check_vpc, %function
ftl_check_vpc:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR61
	add	x23, x23, :lo12:.LANCHOR61
	stp	x21, x22, [sp, 32]
	mov	w22, 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR155
	stp	x27, x28, [sp, 80]
	add	x1, x21, :lo12:.LANCHOR155
	adrp	x20, check_vpc_table
	bl	printf
	add	x19, x20, :lo12:check_vpc_table
	mov	w2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
.L849:
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L851
	adrp	x22, .LANCHOR5
	adrp	x24, .LC95
	add	x22, x22, :lo12:.LANCHOR5
	add	x26, x20, :lo12:check_vpc_table
	add	x24, x24, :lo12:.LC95
	mov	w23, 0
	mov	w19, 0
	adrp	x25, .LANCHOR42
.L852:
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L854
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L855
	adrp	x0, .LANCHOR48
	adrp	x25, .LC96
	add	x20, x20, :lo12:check_vpc_table
	add	x25, x25, :lo12:.LC96
	ldrh	w26, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR40
	mov	x24, x0
	mov	w22, 0
	ldr	x1, [x0, #:lo12:.LANCHOR40]
	adrp	x27, .LANCHOR42
	mov	w28, 6
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.L856:
	cmp	w22, w26
	bne	.L858
.L855:
	cbz	w23, .L848
	adrp	x0, .LC1
	mov	w2, 2321
	add	x1, x21, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	bl	printf
.L848:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L851:
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L850
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L850:
	add	w22, w22, 1
	b	.L849
.L854:
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L853
	mov	w1, w19
	mov	x0, x24
	bl	printf
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L853
	ldrh	w1, [x26, x27, lsl 1]
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.L853:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L852
.L858:
	ldr	x1, [x27, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L857
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w23, 1
	mov	w1, w19
	mov	x0, x25
	bl	printf
.L857:
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	umull	x19, w19, w28
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L855
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L856
	.size	ftl_check_vpc, .-ftl_check_vpc
	.section	.text.FtlGcPageVarInit,"ax",@progbits
	.align	2
	.global	FtlGcPageVarInit
	.type	FtlGcPageVarInit, %function
FtlGcPageVarInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR95
	mov	w1, 255
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR97
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR21
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR96
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	ldr	x0, [x0, #:lo12:.LANCHOR96]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR98
	ldr	x0, [x0, #:lo12:.LANCHOR98]
	bl	ftl_memset
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	FtlGcBufInit
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR156
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	stp	x27, x28, [sp, 80]
	mov	w0, 65535
	ldrh	w19, [x21, #:lo12:.LANCHOR156]
	mov	w28, w1
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w19, w0
	beq	.L892
	cbnz	w19, .L876
.L877:
	bl	FtlGcPageVarInit
	b	.L878
.L892:
	mov	w19, 0
.L876:
	adrp	x0, .LANCHOR19
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w28
	beq	.L877
.L878:
	adrp	x27, .LANCHOR23
	add	x27, x27, :lo12:.LANCHOR23
	mov	w22, 0
	mov	w23, 65535
.L886:
	ldrh	w0, [x20]
	strb	wzr, [x20, 8]
	cmp	w0, w23
	beq	.L893
	adrp	x25, .LANCHOR24
	adrp	x26, .LANCHOR3
	add	x25, x25, :lo12:.LANCHOR24
	add	x26, x26, :lo12:.LANCHOR3
.L889:
	adrp	x1, .LANCHOR91
	adrp	x24, .LANCHOR120
	ldrh	w7, [x27]
	add	x5, x20, 16
	ldr	x6, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR92
	ldr	x0, [x24, #:lo12:.LANCHOR120]
	mov	w3, 0
	ldr	x8, [x1, #:lo12:.LANCHOR92]
	ldrh	w1, [x26]
	ldrh	w10, [x25]
	add	x1, x1, 8
	add	x1, x20, x1, lsl 1
.L880:
	cmp	x1, x5
	bne	.L882
	mov	w1, w3
	str	w3, [x29, 108]
	mov	w2, 0
	bl	FlashReadPages
	ldr	w3, [x29, 108]
	mov	x11, 0
	ubfiz	x12, x3, 5, 16
.L883:
	cmp	x11, x12
	bne	.L887
	add	w19, w19, 1
	add	w22, w22, 1
	and	w19, w19, 65535
	cmp	w28, w22
	adrp	x1, .LANCHOR19
	bls	.L888
.L890:
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bhi	.L889
.L893:
	mov	w2, 0
	b	.L879
.L882:
	ldrh	w4, [x5]
	cmp	w4, w23
	beq	.L881
	ubfiz	x2, x3, 5, 16
	orr	w4, w19, w4, lsl 10
	add	x2, x0, x2
	str	w4, [x2, 4]
	mul	w4, w3, w7
	asr	w4, w4, 2
	add	x4, x6, x4, sxtw 2
	str	x4, [x2, 8]
	mul	w4, w3, w10
	add	w3, w3, 1
	and	w3, w3, 65535
	asr	w4, w4, 2
	add	x4, x8, x4, sxtw 2
	str	x4, [x2, 16]
.L881:
	add	x5, x5, 2
	b	.L880
.L887:
	ldr	x6, [x24, #:lo12:.LANCHOR120]
	add	x5, x6, x11
	ldr	w4, [x5, 4]
	lsr	w0, w4, 10
	bl	P2V_plane
	and	w2, w0, 65535
	ldr	w0, [x6, x11]
	cbnz	w0, .L884
	ldr	x0, [x5, 16]
	add	x11, x11, 32
	ldrh	w1, [x0]
	cmp	w1, w23
	bne	.L885
	adrp	x0, .LANCHOR152
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR152]
.L879:
	strh	w19, [x20, 2]
	mov	w0, -1
	strb	w2, [x20, 6]
	mov	w1, w19
	strh	w0, [x21, #:lo12:.LANCHOR156]
	mov	x0, x20
	bl	ftl_sb_update_avl_pages
	b	.L891
.L885:
	ldp	w2, w0, [x0, 8]
	mov	w1, w4
	bl	FtlGcUpdatePage
	b	.L883
.L884:
	adrp	x0, .LANCHOR42
	ldrh	w1, [x20]
	mov	w19, 0
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x20]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x20]
	bl	FtlGcPageVarInit
	b	.L886
.L888:
	ldrh	w0, [x21, #:lo12:.LANCHOR156]
	cmp	w0, w23
	beq	.L890
	add	w0, w0, w22
	strh	w0, [x21, #:lo12:.LANCHOR156]
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bls	.L890
.L891:
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FlashTestBlk,"ax",@progbits
	.align	2
	.global	FlashTestBlk
	.type	FlashTestBlk, %function
FlashTestBlk:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	cmp	w19, 11
	bls	.L901
	add	x0, x29, 64
	mov	w2, 32
	mov	w1, 165
	adrp	x20, ftl_temp_buf
	add	x20, x20, :lo12:ftl_temp_buf
	stp	x20, x0, [x29, 40]
	bl	ftl_memset
	lsl	w19, w19, 10
	mov	w2, 8
	mov	w1, 90
	mov	x0, x20
	bl	ftl_memset
	mov	w2, 1
	str	w19, [x29, 36]
	mov	w1, w2
	add	x0, x29, 32
	bl	FlashEraseBlocks
	mov	w3, 1
	add	x0, x29, 32
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldr	w0, [x29, 32]
	mov	w2, 1
	mov	w1, 0
	cmp	w0, 0
	add	x0, x29, 32
	csetm	w19, ne
	bl	FlashEraseBlocks
.L899:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 128
	ret
.L901:
	mov	w19, 0
	b	.L899
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FlashGetBadBlockList,"ax",@progbits
	.align	2
	.global	FlashGetBadBlockList
	.type	FlashGetBadBlockList, %function
FlashGetBadBlockList:
	stp	x29, x30, [sp, -32]!
	mov	w2, 256
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w20, w1
	mov	w1, 255
	bl	ftl_memset
	adrp	x0, .LANCHOR105
	mov	w1, w20
	ldr	x2, [x0, #:lo12:.LANCHOR105]
	mov	x0, x19
	blr	x2
	and	w0, w0, 65535
	cmp	w0, 50
	bls	.L904
	mov	w2, 256
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	mov	w0, 0
.L904:
	adrp	x1, .LANCHOR0+14
	ldrh	w1, [x1, #:lo12:.LANCHOR0+14]
	cmp	w1, 4
	bne	.L908
	mov	x1, 0
.L906:
	cmp	w0, w1, uxth
	bhi	.L907
.L908:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L907:
	ldrh	w2, [x19, x1, lsl 1]
	lsr	w2, w2, 1
	strh	w2, [x19, x1, lsl 1]
	add	x1, x1, 1
	b	.L906
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.ftl_memcpy,"ax",@progbits
	.align	2
	.global	ftl_memcpy
	.type	ftl_memcpy, %function
ftl_memcpy:
	uxtw	x2, w2
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR108
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR106
	stp	x21, x22, [sp, 32]
	add	x20, x19, :lo12:.LANCHOR106
	adrp	x22, .LANCHOR107
	ldr	x1, [x23, #:lo12:.LANCHOR108]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR37
	str	x27, [sp, 80]
	add	x25, x21, :lo12:.LANCHOR37
	ldr	x0, [x22, #:lo12:.LANCHOR107]
	adrp	x26, .LANCHOR10
	stp	x0, x1, [x20, 8]
	adrp	x1, .LANCHOR23
	adrp	x27, .LANCHOR137
	add	x25, x25, 32
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w24, 0
	add	x26, x26, :lo12:.LANCHOR10
	add	x27, x27, :lo12:.LANCHOR137
	mov	w1, 0
	bl	ftl_memset
.L912:
	ldrh	w0, [x26]
	cmp	w24, w0
	blt	.L913
	add	x19, x19, :lo12:.LANCHOR106
	add	x20, x21, :lo12:.LANCHOR37
	mov	w2, 16
	mov	w1, 255
	adrp	x24, .LC97
	adrp	x26, .LANCHOR20
	ldr	x27, [x19, 16]
	add	x24, x24, :lo12:.LC97
	add	x26, x26, :lo12:.LANCHOR20
	mov	w25, 0
	mov	x0, x27
	bl	ftl_memset
	mov	w0, -3887
	strh	w0, [x27]
	ldr	w0, [x20, 8]
	str	w0, [x27, 4]
	ldrh	w0, [x21, #:lo12:.LANCHOR37]
	mov	w21, 0
	strh	w0, [x27, 2]
	ldrh	w0, [x20, 4]
	strh	w0, [x27, 8]
	ldrh	w0, [x20, 6]
	strh	w0, [x27, 10]
	adrp	x0, .LANCHOR2
	ldr	w0, [x0, #:lo12:.LANCHOR2]
	strh	w0, [x27, 12]
.L914:
	ldrh	w4, [x27, 10]
	ldrh	w1, [x20]
	ldrh	w2, [x20, 2]
	ldrh	w3, [x20, 4]
	ldr	x0, [x22, #:lo12:.LANCHOR107]
	str	x0, [x19, 8]
	ldr	x0, [x23, #:lo12:.LANCHOR108]
	str	x0, [x19, 16]
	orr	w0, w2, w1, lsl 10
	str	wzr, [x19]
	str	w0, [x19, 4]
	mov	x0, x24
	bl	printf
	mov	w3, 1
	mov	x0, x19
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x26]
	ldrh	w1, [x20, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L915
	ldr	w0, [x20, 8]
	mov	w2, 1
	ldrh	w1, [x20, 4]
	add	w0, w0, 1
	str	w0, [x20, 8]
	str	w0, [x27, 4]
	ldrh	w0, [x20]
	strh	w0, [x27, 8]
	strh	w0, [x20, 4]
	adrp	x0, .LANCHOR111
	strh	w1, [x20]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	w1, [x19, 4]
	strh	wzr, [x20, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	mov	w3, 1
	mov	x0, x19
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.L915:
	ldrh	w0, [x20, 2]
	add	w0, w0, 1
	strh	w0, [x20, 2]
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L916
	ldr	w1, [x19, 4]
	add	w21, w21, 1
	adrp	x0, .LC98
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC98
	bl	printf
	cmp	w21, 3
	bls	.L914
	ldr	w1, [x19, 4]
	adrp	x0, .LC99
	mov	w2, w21
	add	x0, x0, :lo12:.LC99
	bl	printf
.L918:
	b	.L918
.L913:
	ldrh	w2, [x27]
	ldr	x1, [x25], 8
	ldr	x0, [x20, 8]
	mul	w3, w24, w2
	lsl	w2, w2, 2
	add	w24, w24, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L912
.L919:
	mov	w25, 1
	b	.L914
.L916:
	cbz	w25, .L919
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x27, x28, [sp, 80]
	adrp	x28, .LANCHOR48
	stp	x23, x24, [sp, 48]
	add	x23, x28, :lo12:.LANCHOR48
	stp	x19, x20, [sp, 16]
	adrp	x27, .LANCHOR45
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	add	x0, x27, :lo12:.LANCHOR45
	stp	x25, x26, [sp, 64]
	str	x0, [x29, 104]
.L922:
	ldr	x1, [x29, 104]
	adrp	x24, .LANCHOR5
	ldrh	w0, [x28, #:lo12:.LANCHOR48]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L923
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2588
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L923:
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	cmp	x19, x0
	bne	.L948
	adrp	x1, .LANCHOR87
	ldrh	w0, [x23]
	ldr	w1, [x1, #:lo12:.LANCHOR87]
	mul	w1, w0, w1
	lsr	w0, w0, 1
	add	w0, w0, 1
	add	w1, w0, w1, lsr 2
	ands	w1, w1, 65535
	beq	.L924
	sub	w1, w1, #1
	and	w1, w1, 65535
.L924:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_pop_index_node
	and	w20, w0, 65535
	ldrh	w0, [x23]
	cbnz	w0, .L925
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2597
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L925:
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	strh	w20, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L926
	adrp	x1, .LANCHOR42
	ubfiz	x0, x20, 1, 16
	mov	w2, -1
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w2, [x1, x0]
	mov	w0, w20
	bl	INSERT_DATA_LIST
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L922
	mov	w2, 2608
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L922
.L948:
	mov	w1, 0
	b	.L924
.L926:
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L928
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2611
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L928:
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR111
	add	x26, x19, 16
	mov	w21, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	x4, x26
	ldr	x3, [x25, #:lo12:.LANCHOR111]
	mov	w6, 65535
	ubfiz	x0, x0, 5, 16
	add	x1, x3, 8
	add	x0, x0, 8
	add	x0, x3, x0
.L929:
	cmp	x0, x1
	bne	.L931
	cbnz	w21, .L932
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2622
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L932:
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w20
	bne	.L933
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2624
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L933:
	ldrb	w0, [x19, 8]
	uxtw	x22, w20
	adrp	x6, .LANCHOR43
	adrp	x7, .LANCHOR14
	adrp	x5, .LANCHOR72
	adrp	x4, .LANCHOR73
	cbnz	w0, .L934
	ldr	x2, [x6, #:lo12:.LANCHOR43]
	lsl	x1, x22, 1
	ldrh	w0, [x2, x1]
	cbz	w0, .L935
	ldrh	w3, [x7, #:lo12:.LANCHOR14]
	add	w0, w0, w3
.L959:
	strh	w0, [x2, x1]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR72]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR72]
	mov	w0, w20
	bl	ftl_set_blk_mode
.L937:
	ldr	x0, [x6, #:lo12:.LANCHOR43]
	lsl	x22, x22, 1
	ldrh	w1, [x0, x22]
	adrp	x0, .LANCHOR76
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	cmp	w1, w2
	bls	.L938
	str	w1, [x0, #:lo12:.LANCHOR76]
.L938:
	ldr	w2, [x5, #:lo12:.LANCHOR72]
	ldr	w1, [x4, #:lo12:.LANCHOR73]
	ldrh	w0, [x7, #:lo12:.LANCHOR14]
	madd	w0, w0, w2, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR74
	str	w0, [x1, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR127
	ldr	x1, [x0, #:lo12:.LANCHOR127]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR111]
	ubfiz	x1, x21, 5, 16
	add	x1, x1, 4
	add	x2, x0, 4
	add	x1, x0, x1
.L939:
	cmp	x1, x2
	bne	.L940
	ldrb	w1, [x19, 8]
	mov	w2, w21
	mov	x24, 0
	bl	FlashEraseBlocks
	mov	w1, 0
.L941:
	cmp	w21, w24, uxth
	bhi	.L943
	cbz	w1, .L944
	mov	w0, w20
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L944:
	ldrb	w0, [x19, 7]
	adrp	x2, .LANCHOR42
	cbnz	w0, .L945
	ldr	x0, [x2, #:lo12:.LANCHOR42]
	mov	w1, -1
	strh	w1, [x0, x22]
	mov	w0, w20
	bl	INSERT_DATA_LIST
	b	.L922
.L931:
	ldrh	w2, [x4]
	stp	xzr, xzr, [x1]
	cmp	w2, w6
	beq	.L930
	ubfiz	x5, x21, 5, 16
	add	w21, w21, 1
	add	x5, x3, x5
	and	w21, w21, 65535
	lsl	w2, w2, 10
	str	w2, [x5, 4]
.L930:
	add	x1, x1, 32
	add	x4, x4, 2
	b	.L929
.L935:
	mov	w0, 2
	b	.L959
.L934:
	ldr	x2, [x6, #:lo12:.LANCHOR43]
	lsl	x0, x22, 1
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	ldr	w0, [x4, #:lo12:.LANCHOR73]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR73]
	mov	w0, w20
	bl	ftl_set_blk_mode.part.6
	b	.L937
.L940:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 32
	b	.L939
.L943:
	ldr	x2, [x25, #:lo12:.LANCHOR111]
	lsl	x0, x24, 5
	add	x3, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L942
	add	w1, w1, 1
	ldr	w0, [x3, 4]
	stp	w2, w1, [x29, 96]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldp	w2, w1, [x29, 96]
	strh	w2, [x26]
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
.L942:
	add	x24, x24, 1
	add	x26, x26, 2
	b	.L941
.L945:
	adrp	x1, .LANCHOR19
	adrp	x3, .LANCHOR70
	strb	wzr, [x19, 6]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	strh	wzr, [x19, 2]
	strh	w20, [x19]
	mul	w0, w0, w1
	ldr	w1, [x3, #:lo12:.LANCHOR70]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x3, #:lo12:.LANCHOR70]
	ldr	x1, [x2, #:lo12:.LANCHOR42]
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	strh	w0, [x1, x22]
	ldrh	w0, [x19, 4]
	cbz	w0, .L946
	ldrb	w0, [x19, 7]
	cbnz	w0, .L947
.L946:
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2677
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.L947:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	allocate_data_superblock, .-allocate_data_superblock
	.section	.text.FtlGcFreeBadSuperBlk,"ax",@progbits
	.align	2
	.global	FtlGcFreeBadSuperBlk
	.type	FtlGcFreeBadSuperBlk, %function
FtlGcFreeBadSuperBlk:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR101
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR101]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	cbz	w0, .L961
	adrp	x23, .LANCHOR102
	add	x24, x23, :lo12:.LANCHOR102
	mov	w19, 0
.L962:
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w0, w19
	bhi	.L968
	bl	FtlGcReFreshBadBlk
.L961:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L968:
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR101
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L963:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L967
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L962
.L967:
	add	x0, x23, :lo12:.LANCHOR102
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L964
	mov	w1, w26
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	bl	printf
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L965:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L966
	sub	w1, w1, #1
	strh	w1, [x22]
.L964:
	and	w20, w27, 65535
	b	.L963
.L966:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L965
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR42
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
	ldrh	w0, [x1, x0]
	cbnz	w0, .L974
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w19
	bne	.L975
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR80]
.L976:
	adrp	x20, .LANCHOR45
	mov	w1, w19
	adrp	x0, .LANCHOR41
	add	x0, x0, :lo12:.LANCHOR41
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L978
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2747
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.L978:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	mov	w0, w19
	bl	free_data_superblock
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
	adrp	x0, .LANCHOR48
	ldrh	w1, [x20, #:lo12:.LANCHOR45]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w1
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L982
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2750
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.L982:
	mov	w0, 1
	b	.L973
.L975:
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L981
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L981
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bne	.L976
.L981:
	mov	w0, 0
.L973:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L974:
	mov	w0, w19
	bl	List_update_data_list
	b	.L981
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",@progbits
	.align	2
	.global	decrement_vpc_count
	.type	decrement_vpc_count, %function
decrement_vpc_count:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	str	x21, [sp, 32]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L985
	adrp	x21, .LANCHOR42
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L986
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x0, x20]
	cbz	w0, .L987
.L992:
	mov	w20, 0
.L984:
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L987:
	mov	w2, 2765
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L992
.L986:
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L985:
	adrp	x21, .LANCHOR150
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR150]
	cmp	w0, w1
	bne	.L989
	strh	w19, [x21, #:lo12:.LANCHOR150]
	b	.L992
.L989:
	cmp	w19, w0
	beq	.L992
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR41
	strh	w19, [x21, #:lo12:.LANCHOR150]
	cset	w20, ne
	ldr	x1, [x1, #:lo12:.LANCHOR40]
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	and	x2, x0, 65535
	ldrh	w1, [x1, x2, lsl 1]
	cbnz	w1, .L984
	cmp	w19, w0, uxth
	beq	.L984
	mov	w2, 2781
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L984
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlWriteDump_data
	.type	FtlWriteDump_data, %function
FtlWriteDump_data:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR51
	add	x0, x19, :lo12:.LANCHOR51
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w2, [x0, 4]
	str	x25, [sp, 64]
	cbz	w2, .L994
	ldrb	w1, [x0, 8]
	cbnz	w1, .L994
	adrp	x3, .LANCHOR19
	ldrb	w1, [x0, 7]
	ldrh	w3, [x3, #:lo12:.LANCHOR19]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L994
	ldrb	w0, [x0, 10]
	cbnz	w0, .L993
	adrp	x0, .LANCHOR61
	mov	w2, 0
	add	x1, x29, 92
	ldr	w21, [x0, #:lo12:.LANCHOR61]
	adrp	x0, .LANCHOR3
	sub	w21, w21, #1
	ldrh	w25, [x0, #:lo12:.LANCHOR3]
	mov	w0, w21
	bl	log2phys
	adrp	x2, .LANCHOR108
	adrp	x0, .LANCHOR107
	ldr	w1, [x29, 92]
	ldr	x20, [x2, #:lo12:.LANCHOR108]
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	cmn	w1, #1
	str	w1, [x29, 100]
	stp	x0, x20, [x29, 104]
	str	w21, [x29, 120]
	str	wzr, [x20, 4]
	beq	.L996
	mov	w2, 0
	mov	w1, 1
	add	x0, x29, 96
	bl	FlashReadPages
.L997:
	adrp	x23, .LANCHOR71
	lsl	w25, w25, 2
	add	x22, x19, :lo12:.LANCHOR51
	add	x23, x23, :lo12:.LANCHOR71
	mov	w0, -3947
	mov	w24, 0
	strh	w0, [x20]
.L998:
	cmp	w25, w24
	bne	.L1002
.L999:
	add	x19, x19, :lo12:.LANCHOR51
	mov	w0, 1
	strb	w0, [x19, 10]
.L993:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L996:
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
	b	.L997
.L1002:
	ldrh	w0, [x22, 4]
	cbz	w0, .L999
	ldr	w0, [x29, 100]
	add	w24, w24, 1
	stp	w21, w0, [x20, 8]
	ldrh	w0, [x22]
	strh	w0, [x20, 2]
	mov	x0, x22
	bl	get_new_active_ppa
	str	w0, [x29, 100]
	ldr	w0, [x23]
	mov	w3, 0
	str	w0, [x20, 4]
	mov	w2, 0
	add	w0, w0, 1
	mov	w1, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x23]
	add	x0, x29, 96
	bl	FlashProgPages
	ldrh	w0, [x22]
	bl	decrement_vpc_count
	b	.L998
.L994:
	add	x19, x19, :lo12:.LANCHOR51
	strb	wzr, [x19, 10]
	b	.L993
	.size	FtlWriteDump_data, .-FtlWriteDump_data
	.section	.text.l2p_flush,"ax",@progbits
	.align	2
	.global	l2p_flush
	.type	l2p_flush, %function
l2p_flush:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR33
	add	x20, x20, :lo12:.LANCHOR33
	str	x21, [sp, 32]
	mov	w19, 0
	adrp	x21, .LANCHOR55
	bl	FtlWriteDump_data
.L1012:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1014
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1014:
	ldr	x1, [x21, #:lo12:.LANCHOR55]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1013
	mov	w0, w19
	bl	flush_l2p_region
.L1013:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1012
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlRecoverySuperblock,"ax",@progbits
	.align	2
	.global	FtlRecoverySuperblock
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	stp	x29, x30, [sp, -192]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, w1
	stp	x27, x28, [sp, 80]
	beq	.L1140
	ldrb	w0, [x19, 6]
	str	w0, [x29, 164]
	adrp	x0, .LANCHOR19
	ldrh	w26, [x19, 2]
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR19]
	cmp	w2, w26
	bne	.L1019
	strh	wzr, [x19, 4]
.L1146:
	strb	wzr, [x19, 6]
.L1140:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1019:
	ldrh	w0, [x19, 16]
	mov	w20, 0
.L1020:
	cmp	w0, w1
	beq	.L1021
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	mov	w23, w0
	cmn	w0, #1
	beq	.L1022
	adrp	x1, .LANCHOR91
	adrp	x2, .LANCHOR3
	adrp	x20, .LANCHOR120
	add	x4, x19, 16
	ldr	x5, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR23
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	mov	w22, 0
	ldrh	w6, [x1, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR92
	mov	w10, 65535
	str	x2, [x29, 152]
	ldr	x7, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR24
	ldrh	w8, [x1, #:lo12:.LANCHOR24]
	add	x1, x19, 16
	str	x1, [x29, 168]
	ldrh	w1, [x2, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1023:
	cmp	x4, x1
	bne	.L1027
	mov	w2, 0
	mov	w1, w22
	bl	FlashReadPages
	adrp	x0, .LANCHOR71
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	and	w10, w23, 65535
	add	x7, x0, :lo12:.LANCHOR71
	ldr	w21, [x0, #:lo12:.LANCHOR71]
	mov	x11, x4
	mov	w6, 65535
	mov	w3, 0
	sub	w21, w21, #1
	str	x0, [x29, 144]
.L1028:
	cmp	w22, w3
	bne	.L1033
	add	w22, w23, 1
	ldr	w0, [x4, 4]
	and	w22, w22, 65535
.L1142:
	lsr	w0, w0, 10
	bl	P2V_plane
	and	w27, w0, 65535
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w22
	bne	.L1035
	strh	w22, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L1035:
	ldr	w0, [x29, 164]
	cmp	w22, w26
	cset	w1, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w1, w0
	beq	.L1036
.L1147:
	mov	w2, w27
	mov	w1, w22
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L1140
.L1021:
	add	w20, w20, 1
	and	w20, w20, 65535
	add	x0, x19, x20, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L1020
.L1022:
	cbz	w26, .L1024
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	mov	w2, 1755
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1024:
	ldr	w0, [x29, 164]
	cmp	w0, 0
	ccmp	w20, w0, 4, ne
	beq	.L1025
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	mov	w2, 1756
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1025:
	strh	wzr, [x19, 2]
	b	.L1146
.L1027:
	ldrh	w3, [x4]
	cmp	w3, w10
	beq	.L1026
	ubfiz	x2, x22, 5, 16
	orr	w3, w23, w3, lsl 10
	add	x2, x0, x2
	str	w3, [x2, 4]
	mul	w3, w22, w6
	asr	w3, w3, 2
	add	x3, x5, x3, sxtw 2
	str	x3, [x2, 8]
	mul	w3, w22, w8
	add	w22, w22, 1
	and	w22, w22, 65535
	asr	w3, w3, 2
	add	x3, x7, x3, sxtw 2
	str	x3, [x2, 16]
.L1026:
	add	x4, x4, 2
	b	.L1023
.L1033:
	ldr	w0, [x11]
	cbnz	w0, .L1029
	ldr	x8, [x11, 16]
	ldr	w5, [x8, 4]
	cmn	w5, #1
	beq	.L1030
	ldr	w1, [x7]
	mov	w0, w5
	bl	ftl_cmp_data_ver
	cbz	w0, .L1030
	add	w5, w5, 1
	str	w5, [x7]
.L1030:
	ldr	w0, [x8]
	cmn	w0, #1
	bne	.L1032
	ubfiz	x3, x3, 5, 16
	and	w22, w23, 65535
	add	x3, x4, x3
	ldr	w0, [x3, 4]
	b	.L1142
.L1029:
	mov	w6, w10
.L1032:
	add	w3, w3, 1
	add	x11, x11, 32
	and	w3, w3, 65535
	b	.L1028
.L1036:
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1037
	ldrb	w0, [x19, 8]
	cbnz	w0, .L1038
.L1037:
	adrp	x25, .LANCHOR153
	and	w28, w23, 65535
	ldr	w0, [x25, #:lo12:.LANCHOR153]
	cmn	w0, #1
	bne	.L1039
	str	w21, [x25, #:lo12:.LANCHOR153]
.L1039:
	add	w0, w26, 7
	cmp	w0, w23, uxth
	bge	.L1089
	sub	w24, w28, #7
	and	w24, w24, 65535
.L1040:
	ldr	x0, [x29, 152]
	mov	w3, 65535
	mov	w5, 1
	add	x4, x0, :lo12:.LANCHOR3
.L1041:
	cmp	w24, w28
	bhi	.L1051
	ldrh	w1, [x4]
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	add	x1, x1, 8
	ldr	x2, [x29, 168]
	add	x1, x19, x1, lsl 1
	b	.L1052
.L1089:
	mov	w24, w26
	b	.L1040
.L1043:
	ldrh	w6, [x2]
	cmp	w6, w3
	beq	.L1042
	ubfiz	x7, x23, 5, 16
	add	w23, w23, 1
	add	x7, x0, x7
	and	w23, w23, 65535
	orr	w6, w24, w6, lsl 10
	str	w6, [x7, 4]
.L1042:
	add	x2, x2, 2
.L1052:
	cmp	x2, x1
	bne	.L1043
	mov	w1, w23
	mov	w2, 0
	str	w5, [x29, 112]
	ubfiz	x23, x23, 5, 16
	str	w3, [x29, 120]
	add	x23, x23, 16
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x2, [x20, #:lo12:.LANCHOR120]
	ldr	w1, [x25, #:lo12:.LANCHOR153]
	ldr	w5, [x29, 112]
	add	x0, x2, 16
	ldr	w3, [x29, 120]
	add	x23, x2, x23
	ldr	x4, [x29, 136]
	mov	w2, 0
.L1044:
	cmp	x23, x0
	bne	.L1049
	cbz	w2, .L1050
	str	w1, [x25, #:lo12:.LANCHOR153]
.L1050:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L1041
.L1049:
	ldr	w6, [x0, -16]
	cbz	w6, .L1045
	cbz	w2, .L1038
	str	w1, [x25, #:lo12:.LANCHOR153]
.L1038:
	mov	w1, 1
	adrp	x0, .LANCHOR161
	mov	w23, w26
	adrp	x28, .LANCHOR153
	strh	w1, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
	add	x0, x28, :lo12:.LANCHOR153
	str	x0, [x29, 104]
.L1053:
	ldr	x1, [x29, 152]
	mov	w24, 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	mov	w5, 65535
	ldr	x2, [x29, 168]
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1054:
	cmp	x1, x2
	bne	.L1056
	mov	w2, 0
	mov	w1, w24
	bl	FlashReadPages
	mov	x25, 0
	ubfiz	x0, x24, 5, 16
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR162
	add	x0, x0, :lo12:.LANCHOR162
	str	x0, [x29, 120]
.L1057:
	ldr	x0, [x29, 112]
	cmp	x25, x0
	bne	.L1083
	ldr	x0, [x29, 128]
	add	w23, w23, 1
	and	w23, w23, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w23
	bne	.L1053
	ldr	x0, [x29, 152]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.L1084:
	cmp	w0, w1
	beq	.L1140
	ldr	x4, [x29, 168]
	ldrh	w3, [x4], 2
	str	x4, [x29, 168]
	cmp	w3, w2
	beq	.L1085
	strb	w0, [x19, 6]
	b	.L1140
.L1045:
	ldr	x6, [x0]
	ldrh	w7, [x6]
	cmp	w7, w3
	beq	.L1048
	ldr	w6, [x6, 4]
	cmn	w6, #1
	csel	w1, w1, w6, eq
	csel	w2, w2, w5, eq
.L1048:
	add	x0, x0, 32
	b	.L1044
.L1051:
	mov	w0, -1
	str	w0, [x25, #:lo12:.LANCHOR153]
	b	.L1038
.L1056:
	ldrh	w3, [x2]
	cmp	w3, w5
	beq	.L1055
	ubfiz	x4, x24, 5, 16
	add	w24, w24, 1
	add	x4, x0, x4
	and	w24, w24, 65535
	orr	w3, w23, w3, lsl 10
	str	w3, [x4, 4]
.L1055:
	add	x2, x2, 2
	b	.L1054
.L1083:
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 188]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L1058
	ldr	w1, [x29, 164]
	ccmp	w1, w0, 0, eq
	bhi	.L1058
	cmp	w23, w22
	ccmp	w27, w0, 0, eq
	beq	.L1059
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L1060
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L1061
.L1067:
	ldrh	w0, [x19]
.L1145:
	bl	decrement_vpc_count
.L1058:
	add	x25, x25, 32
	b	.L1057
.L1061:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L1062
	ldr	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR71]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L1062
	ldr	x1, [x29, 144]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR71]
.L1062:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 184
	str	w0, [x29, 180]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR153]
	cmn	w1, #1
	beq	.L1063
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L1063
	ldr	w1, [x29, 180]
	cmn	w1, #1
	beq	.L1064
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	mov	w2, 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	str	w1, [x0, 4]
	mov	w1, 1
	str	x3, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	x3, [x29, 136]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1065
.L1066:
	mov	w0, -1
	str	w0, [x29, 180]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.L1074:
	ldr	w3, [x29, 180]
	cmn	w3, #1
	beq	.L1058
.L1088:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR5
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w24
	bhi	.L1079
	mov	w2, 2006
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	str	w24, [x29, 136]
	bl	printf
	ldr	w3, [x29, 136]
.L1079:
	adrp	x1, .LANCHOR42
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1080
	mov	w0, w3
	b	.L1145
.L1064:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	bne	.L1067
	mov	w2, 1
	add	x1, x29, 180
	mov	w0, w24
	bl	log2phys
	b	.L1067
.L1065:
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L1066
	ldr	w0, [x3, 4]
	str	w0, [x29, 136]
	str	x3, [x29, 96]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR153]
	bl	ftl_cmp_data_ver
	cbz	w0, .L1066
	ldp	w0, w1, [x29, 184]
	ldr	x3, [x29, 96]
	cmp	w0, w1
	ldr	w1, [x29, 180]
	bne	.L1069
.L1143:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L1066
.L1069:
	cmp	w0, w1
	beq	.L1066
	cmn	w0, #1
	beq	.L1070
	ldr	x3, [x4, 16]
	mov	w2, 0
	str	w0, [x4, 4]
	mov	w1, 1
	str	x3, [x29, 96]
	mov	x0, x4
	bl	FlashReadPages
	ldr	x3, [x29, 96]
.L1071:
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L1072
	ldr	x0, [x29, 104]
	ldr	w3, [x3, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L1072
	ldr	w0, [x29, 136]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L1066
.L1072:
	ldr	w1, [x29, 180]
	b	.L1143
.L1070:
	str	w0, [x4]
	b	.L1071
.L1063:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	beq	.L1074
	mov	w2, 1
	add	x1, x29, 188
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 184]
	cmn	w3, #1
	beq	.L1074
	ldr	w0, [x29, 180]
	cmp	w3, w0
	beq	.L1088
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR51
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, w0
	beq	.L1078
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	beq	.L1078
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1074
.L1078:
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1074
	ldr	x4, [x29, 136]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L1074
	mov	w2, 1
	add	x1, x29, 184
	mov	w0, w24
	bl	log2phys
	b	.L1074
.L1080:
	mov	w1, w24
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	bl	printf
	b	.L1058
.L1060:
	ldr	x0, [x29, 120]
	ldr	w0, [x0]
	cmp	w0, 31
	bhi	.L1081
	adrp	x1, .LANCHOR163
	add	x1, x1, :lo12:.LANCHOR163
	str	w5, [x1, w0, uxtw 2]
	add	w0, w0, 1
	ldr	x1, [x29, 120]
	str	w0, [x1]
.L1081:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR153]
	cmn	w0, #1
	bne	.L1082
.L1144:
	str	w21, [x28, #:lo12:.LANCHOR153]
	b	.L1058
.L1082:
	cmp	w21, w0
	bcs	.L1058
	b	.L1144
.L1085:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L1084
.L1059:
	strb	w27, [x19, 6]
	strh	w22, [x19, 2]
	b	.L1147
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR108
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w0, -1
	ldr	x20, [x1, #:lo12:.LANCHOR108]
	str	w0, [x29, 72]
	adrp	x0, .LANCHOR107
	stp	x21, x22, [sp, 32]
	mov	w1, -3
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	adrp	x21, .LANCHOR71
	str	x20, [x29, 64]
	add	x21, x21, :lo12:.LANCHOR71
	str	x0, [x29, 56]
	mov	w22, 7
	str	w1, [x20, 8]
	mov	w1, -2
	str	w1, [x20, 12]
	ldrh	w1, [x19]
	strh	w1, [x20, 2]
	strh	wzr, [x20]
	mov	w1, 61589
	str	w1, [x0]
	mov	w1, 22136
	movk	w1, 0x1234, lsl 16
	str	w1, [x0, 4]
.L1149:
	subs	w22, w22, #1
	beq	.L1151
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1150
.L1151:
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR42
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR19
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	strh	w0, [x19, 2]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
	ret
.L1150:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 52]
	cmn	w0, #1
	beq	.L1151
	ldr	w0, [x21]
	mov	w3, 0
	str	w0, [x20, 4]
	mov	w2, 0
	add	w0, w0, 1
	mov	w1, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x21]
	add	x0, x29, 48
	bl	FlashProgPages
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1149
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR107
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR17
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR106
	add	x20, x22, :lo12:.LANCHOR106
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x25, [sp, 64]
	mov	w25, 61649
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR108
	ldr	x21, [x0, #:lo12:.LANCHOR108]
	str	x21, [x20, 16]
	bl	FtlBbtMemInit
	ldrh	w19, [x24, #:lo12:.LANCHOR17]
	add	x24, x24, :lo12:.LANCHOR17
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1161:
	ldrh	w0, [x24]
	sub	w0, w0, #15
	cmp	w0, w19
	bgt	.L1164
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1162
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L1162:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1163
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1163
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	strh	w19, [x1, #:lo12:.LANCHOR37]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1164:
	adrp	x19, .LANCHOR37
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR37
	ldrh	w1, [x19, #:lo12:.LANCHOR37]
	cmp	w1, w0
	beq	.L1178
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1168
	add	x0, x22, :lo12:.LANCHOR106
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR106]
	cmn	w0, #1
	beq	.L1168
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1168
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1168
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR37]
	strh	w0, [x20, 4]
.L1168:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	add	x24, x19, :lo12:.LANCHOR37
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR106
.L1170:
	tbz	w20, #31, .L1173
	adrp	x1, .LANCHOR164
	adrp	x0, .LC1
	mov	w2, 254
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1172:
	add	x0, x19, :lo12:.LANCHOR37
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1175
	adrp	x1, .LANCHOR2
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	cmp	w0, w2
	beq	.L1175
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1175
	cmp	w0, w1
	bcs	.L1175
	bl	FtlSysBlkNumInit
.L1175:
	add	x19, x19, :lo12:.LANCHOR37
	adrp	x21, .LANCHOR10
	adrp	x23, .LANCHOR137
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR10
	add	x23, x23, :lo12:.LANCHOR137
	add	x22, x22, :lo12:.LANCHOR106
	mov	w20, 0
.L1176:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1177
	mov	w0, 0
.L1160:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1163:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1161
.L1173:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x0, [x24, 8]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L1171
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1172
.L1171:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L1170
.L1177:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L1176
.L1178:
	mov	w0, -1
	b	.L1160
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.FtlMakeBbt,"ax",@progbits
	.align	2
	.global	FtlMakeBbt
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w22, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR37
	stp	x23, x24, [sp, 48]
	add	x21, x20, :lo12:.LANCHOR37
	stp	x25, x26, [sp, 64]
	add	x24, x21, 32
	stp	x27, x28, [sp, 80]
	bl	FtlBbtMemInit
	bl	FtlLoadFactoryBbt
	adrp	x28, .LANCHOR106
	add	x21, x21, 12
	add	x25, x28, :lo12:.LANCHOR106
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	str	x0, [x29, 120]
.L1191:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L1197
	adrp	x21, .LANCHOR25
	add	x21, x21, :lo12:.LANCHOR25
	mov	w19, 0
.L1198:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L1199
	add	x21, x20, :lo12:.LANCHOR37
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1200:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1204
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L1201
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L1202
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L1201:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1200
.L1197:
	adrp	x2, .LANCHOR108
	adrp	x0, .LANCHOR107
	add	x19, x28, :lo12:.LANCHOR106
	ldrh	w1, [x21]
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR108]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR17
	str	x2, [x29, 112]
	beq	.L1192
	ldrh	w4, [x23, #:lo12:.LANCHOR17]
	mov	w2, 1
	madd	w27, w4, w22, w1
	mov	w1, w2
	lsl	w0, w27, 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldr	x1, [x19, 8]
	ldr	x0, [x24]
	ldrh	w2, [x23, #:lo12:.LANCHOR17]
	add	w2, w2, 7
	lsr	w2, w2, 3
	bl	ftl_memcpy
.L1193:
	mov	w0, w27
	add	w22, w22, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x21, x21, 2
	b	.L1191
.L1192:
	mov	w1, w22
	bl	FlashGetBadBlockList
	ldr	x0, [x19, 8]
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
	ldrh	w19, [x23, #:lo12:.LANCHOR17]
	add	x23, x23, :lo12:.LANCHOR17
	adrp	x0, .LANCHOR137
	sub	w19, w19, #1
	add	x0, x0, :lo12:.LANCHOR137
	and	w19, w19, 65535
	str	x0, [x29, 104]
.L1194:
	ldrh	w0, [x23]
	madd	w0, w22, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L1195
	ldr	x0, [x29, 112]
	mov	w2, 16
	strh	w19, [x21]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	bl	ftl_memset
	adrp	x0, .LANCHOR107
	mov	w2, 4096
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	bl	ftl_memset
	mov	w0, -3872
	strh	w0, [x26]
	ldrh	w4, [x23]
	ldrh	w0, [x21]
	strh	w0, [x26, 2]
	ldr	x1, [x24]
	str	wzr, [x26, 4]
	madd	w27, w4, w22, w0
	lsl	w0, w27, 10
	str	w0, [x25, 4]
	ldr	x0, [x29, 104]
	ldrh	w2, [x0]
	ldr	x0, [x25, 8]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	mov	w2, 1
	mov	x0, x25
	mov	w1, w2
	bl	FlashEraseBlocks
	mov	w3, 1
	mov	x0, x25
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldr	w0, [x25]
	cmn	w0, #1
	bne	.L1193
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L1194
.L1195:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1194
.L1199:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L1198
.L1202:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L1203
	strh	w19, [x21]
	b	.L1201
.L1203:
	strh	w19, [x21, 4]
.L1204:
	adrp	x0, .LANCHOR111
	add	x19, x20, :lo12:.LANCHOR37
	ldrh	w1, [x20, #:lo12:.LANCHOR37]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	wzr, [x19, 8]
	lsl	w1, w1, 10
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	lsl	w1, w1, 10
	str	w1, [x0, 36]
	mov	w1, 1
	bl	FlashEraseBlocks
	ldrh	w0, [x20, #:lo12:.LANCHOR37]
	bl	FtlBbmMapBadBlock
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	strh	wzr, [x19, 2]
	ldr	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	ldrh	w0, [x20, #:lo12:.LANCHOR37]
	strh	w0, [x19, 4]
	strh	w1, [x20, #:lo12:.LANCHOR37]
	bl	FtlBbmTblFlush
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.FtlVendorPartWrite,"ax",@progbits
	.align	2
	.global	FtlVendorPartWrite
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	stp	x29, x30, [sp, -208]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x27, x28, [sp, 80]
	add	w1, w0, w1
	mov	w28, w0
	adrp	x0, .LANCHOR16
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w1, w0
	bhi	.L1218
	adrp	x0, .LANCHOR22
	adrp	x25, .LANCHOR12
	adrp	x26, .LANCHOR23
	mov	x24, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR22]
	add	x25, x25, :lo12:.LANCHOR12
	add	x26, x26, :lo12:.LANCHOR23
	mov	w23, 0
	lsr	w21, w28, w21
.L1212:
	cbnz	w20, .L1217
.L1210:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1217:
	ldrh	w1, [x25]
	adrp	x0, .LANCHOR133
	adrp	x27, .LANCHOR124
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	udiv	w22, w28, w1
	ldr	w2, [x0, w21, uxtw 2]
	and	w0, w20, 65535
	msub	w22, w22, w1, w28
	sub	w19, w1, w22
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	cbz	w2, .L1214
	cmp	w19, w1
	beq	.L1214
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	add	x0, x29, 144
	str	w2, [x29, 116]
	mov	w2, 1
	str	x0, [x29, 128]
	mov	w1, w2
	add	x0, x29, 112
	bl	FlashReadPages
.L1215:
	lsl	w4, w19, 9
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	lsl	w22, w22, 7
	mov	w2, w4
	mov	x1, x24
	str	w4, [x29, 108]
	add	x0, x0, x22, sxtw 2
	bl	ftl_memcpy
	ldr	x2, [x27, #:lo12:.LANCHOR124]
	mov	w1, w21
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	sub	w20, w20, w19
	add	w28, w28, w19
	add	w21, w21, 1
	bl	FtlMapWritePage
	cmn	w0, #1
	ldr	w4, [x29, 108]
	csinv	w23, w23, wzr, ne
	add	x24, x24, x4, sxtw
	b	.L1212
.L1214:
	ldrh	w2, [x26]
	mov	w1, 0
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	bl	ftl_memset
	b	.L1215
.L1218:
	mov	w23, -1
	b	.L1210
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	adrp	x0, .LANCHOR81
	add	x2, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, #:lo12:.LANCHOR81]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1223
	mov	w0, 68
	mov	w1, 1
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	str	w0, [x2, 88]
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	str	w0, [x2, 92]
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	str	w0, [x2, 8]
	adrp	x0, .LANCHOR64
	ldr	w0, [x0, #:lo12:.LANCHOR64]
	str	w0, [x2, 12]
	adrp	x0, .LANCHOR62
	ldr	w0, [x0, #:lo12:.LANCHOR62]
	str	w0, [x2, 16]
	adrp	x0, .LANCHOR66
	ldr	w0, [x0, #:lo12:.LANCHOR66]
	str	w0, [x2, 20]
	adrp	x0, .LANCHOR73
	ldr	w0, [x0, #:lo12:.LANCHOR73]
	str	w0, [x2, 28]
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	str	w0, [x2, 32]
	adrp	x0, .LANCHOR63
	ldr	w0, [x0, #:lo12:.LANCHOR63]
	str	w0, [x2, 36]
	adrp	x0, .LANCHOR65
	ldr	w0, [x0, #:lo12:.LANCHOR65]
	str	w0, [x2, 40]
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	str	w0, [x2, 44]
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	str	w0, [x2, 48]
	mov	w0, 0
	b	FtlVendorPartWrite
.L1223:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x2, .LANCHOR165
	ldrh	w1, [x2, #:lo12:.LANCHOR165]
	cmp	w1, 31
	bhi	.L1229
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR165]
	mov	w1, 1
.L1226:
	adrp	x2, .LANCHOR127
	cbnz	w0, .L1227
	ldr	x0, [x2, #:lo12:.LANCHOR127]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1231
.L1227:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR127]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	mov	w0, 17221
	str	wzr, [x2, 4]
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	adrp	x0, .LANCHOR125
	ldrh	w1, [x0, #:lo12:.LANCHOR125]
	lsl	w0, w1, 9
	str	w0, [x2, 12]
	ldr	w0, [x2, 8]
	add	w0, w0, 1
	str	w0, [x2, 8]
	mov	w0, 64
	bl	FtlVendorPartWrite
	bl	Ftl_save_ext_data
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1229:
	mov	w1, 32
	b	.L1226
.L1231:
	mov	w0, 0
	ret
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.sftl_vendor_write,"ax",@progbits
	.align	2
	.global	sftl_vendor_write
	.type	sftl_vendor_write, %function
sftl_vendor_write:
	add	w0, w0, 256
	b	FtlVendorPartWrite
	.size	sftl_vendor_write, .-sftl_vendor_write
	.section	.text.FtlVendorPartRead,"ax",@progbits
	.align	2
	.global	FtlVendorPartRead
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	stp	x29, x30, [sp, -208]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	add	w1, w0, w1
	mov	w21, w0
	adrp	x0, .LANCHOR16
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1242
	adrp	x0, .LANCHOR22
	adrp	x24, .LANCHOR12
	mov	x23, x2
	add	x24, x24, :lo12:.LANCHOR12
	ldrh	w3, [x0, #:lo12:.LANCHOR22]
	mov	w22, 0
	adrp	x25, .LANCHOR133
	lsr	w26, w21, w3
.L1236:
	cbnz	w20, .L1241
.L1234:
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1241:
	ldrh	w19, [x24]
	ldr	x0, [x25, #:lo12:.LANCHOR133]
	udiv	w27, w21, w19
	ldr	w1, [x0, w26, uxtw 2]
	and	w0, w20, 65535
	msub	w27, w27, w19, w21
	sub	w19, w19, w27
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	lsl	w28, w19, 9
	cbz	w1, .L1238
	adrp	x4, .LANCHOR124
	mov	w2, 1
	str	x4, [x29, 104]
	lsl	w27, w27, 7
	ldr	x0, [x4, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	add	x0, x29, 144
	str	w1, [x29, 116]
	mov	w1, w2
	str	x0, [x29, 128]
	add	x0, x29, 112
	bl	FlashReadPages
	ldr	x4, [x29, 104]
	mov	w2, w28
	ldr	w0, [x29, 112]
	cmn	w0, #1
	mov	x0, x23
	ldr	x1, [x4, #:lo12:.LANCHOR124]
	csinv	w22, w22, wzr, ne
	add	x1, x1, x27, sxtw 2
	bl	ftl_memcpy
.L1240:
	add	w26, w26, 1
	sub	w20, w20, w19
	add	w21, w21, w19
	add	x23, x23, x28, sxtw
	b	.L1236
.L1238:
	mov	w2, w28
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
	b	.L1240
.L1242:
	mov	w22, -1
	b	.L1234
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.FtlLoadEctTbl,"ax",@progbits
	.align	2
	.global	FtlLoadEctTbl
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
	stp	x29, x30, [sp, -32]!
	mov	w0, 64
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR127
	adrp	x20, .LANCHOR125
	ldr	x2, [x19, #:lo12:.LANCHOR127]
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	bl	FtlVendorPartRead
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1245
	adrp	x1, .LC103
	adrp	x0, .LC71
	add	x1, x1, :lo12:.LC103
	add	x0, x0, :lo12:.LC71
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR125]
	lsl	w2, w2, 9
	bl	ftl_memset
.L1245:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.Ftl_load_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_load_ext_data
	.type	Ftl_load_ext_data, %function
Ftl_load_ext_data:
	stp	x29, x30, [sp, -48]!
	mov	w1, 1
	mov	w0, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR81
	str	x21, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR81
	mov	x2, x21
	bl	FtlVendorPartRead
	ldr	w0, [x19, #:lo12:.LANCHOR81]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1248
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR81]
.L1248:
	ldr	w1, [x19, #:lo12:.LANCHOR81]
	add	x0, x19, :lo12:.LANCHOR81
	cmp	w1, w20
	adrp	x1, .LANCHOR73
	bne	.L1249
	adrp	x2, .LANCHOR68
	ldr	w3, [x0, 88]
	str	w3, [x2, #:lo12:.LANCHOR68]
	adrp	x2, .LANCHOR69
	ldr	w3, [x0, 92]
	str	w3, [x2, #:lo12:.LANCHOR69]
	adrp	x2, .LANCHOR67
	ldr	w3, [x0, 8]
	str	w3, [x2, #:lo12:.LANCHOR67]
	adrp	x2, .LANCHOR64
	ldr	w3, [x0, 12]
	str	w3, [x2, #:lo12:.LANCHOR64]
	adrp	x2, .LANCHOR62
	ldr	w3, [x0, 16]
	str	w3, [x2, #:lo12:.LANCHOR62]
	adrp	x2, .LANCHOR66
	ldr	w3, [x0, 20]
	str	w3, [x2, #:lo12:.LANCHOR66]
	ldp	w2, w3, [x0, 28]
	str	w2, [x1, #:lo12:.LANCHOR73]
	adrp	x2, .LANCHOR75
	str	w3, [x2, #:lo12:.LANCHOR75]
	adrp	x2, .LANCHOR63
	ldr	w3, [x0, 36]
	str	w3, [x2, #:lo12:.LANCHOR63]
	adrp	x2, .LANCHOR65
	ldr	w3, [x0, 40]
	str	w3, [x2, #:lo12:.LANCHOR65]
	adrp	x2, .LANCHOR76
	ldr	w3, [x0, 44]
	str	w3, [x2, #:lo12:.LANCHOR76]
	ldr	w2, [x0, 48]
	adrp	x0, .LANCHOR77
	str	w2, [x0, #:lo12:.LANCHOR77]
.L1249:
	adrp	x0, .LANCHOR14
	adrp	x2, .LANCHOR72
	ldr	w1, [x1, #:lo12:.LANCHOR73]
	ldrh	w0, [x0, #:lo12:.LANCHOR14]
	ldr	w2, [x2, #:lo12:.LANCHOR72]
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR5
	ldp	x29, x30, [sp], 48
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR74
	str	w0, [x1, #:lo12:.LANCHOR74]
	ret
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.sftl_vendor_read,"ax",@progbits
	.align	2
	.global	sftl_vendor_read
	.type	sftl_vendor_read, %function
sftl_vendor_read:
	add	w0, w0, 256
	b	FtlVendorPartRead
	.size	sftl_vendor_read, .-sftl_vendor_read
	.section	.text.FtlVpcTblFlush,"ax",@progbits
	.align	2
	.global	FtlVpcTblFlush
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR79
	mov	w2, 19539
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR108
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR106
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR107
	stp	x27, x28, [sp, 80]
	add	x28, x22, :lo12:.LANCHOR106
	ldr	x21, [x25, #:lo12:.LANCHOR108]
	movk	w2, 0x4654, lsl 16
	stp	x19, x20, [sp, 16]
	add	x19, x1, :lo12:.LANCHOR79
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	adrp	x23, .LANCHOR70
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	adrp	x27, .LANCHOR20
	stp	x0, x21, [x28, 8]
	mov	w26, 65535
	strh	w1, [x21, 2]
	mov	w1, -3932
	strh	w1, [x21]
	ldr	w1, [x19, 8]
	stp	w1, wzr, [x21, 4]
	adrp	x1, .LANCHOR39
	add	x20, x1, :lo12:.LANCHOR39
	str	wzr, [x21, 12]
	str	w2, [x1, #:lo12:.LANCHOR39]
	mov	w1, 68
	movk	w1, 0x5000, lsl 16
	str	w1, [x20, 4]
	ldrh	w1, [x19, 6]
	adrp	x2, .LANCHOR51
	strh	w1, [x20, 8]
	adrp	x1, .LANCHOR10
	ldrh	w1, [x1, #:lo12:.LANCHOR10]
	strb	w1, [x20, 10]
	add	x1, x2, :lo12:.LANCHOR51
	ldrh	w2, [x2, #:lo12:.LANCHOR51]
	strh	w2, [x20, 14]
	ldrh	w2, [x1, 2]
	ldrb	w3, [x1, 6]
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 16]
	adrp	x2, .LANCHOR52
	add	x1, x2, :lo12:.LANCHOR52
	ldrh	w2, [x2, #:lo12:.LANCHOR52]
	ldrb	w3, [x1, 6]
	strh	w2, [x20, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 20]
	adrp	x2, .LANCHOR53
	add	x1, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	ldrb	w3, [x1, 6]
	strh	w2, [x20, 22]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 13]
	adrp	x1, .LANCHOR72
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	str	w1, [x20, 32]
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	str	w1, [x20, 40]
	adrp	x1, .LANCHOR71
	ldr	w1, [x1, #:lo12:.LANCHOR71]
	str	w1, [x20, 36]
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x28, 8]
	mov	x1, x20
	mov	w2, 48
	adrp	x20, .LANCHOR5
	bl	ftl_memcpy
	adrp	x1, .LANCHOR42
	ldrh	w2, [x20, #:lo12:.LANCHOR5]
	ldr	x0, [x28, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
	ldrh	w0, [x20, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR1
	ldr	x3, [x28, 8]
	mov	w20, 0
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	w2, w2, 4
	add	x0, x0, 48
	and	x0, x0, -4
	add	x0, x3, x0
	bl	ftl_memcpy
	mov	w0, 0
	bl	FtlUpdateVaildLpn
	add	x0, x27, :lo12:.LANCHOR20
	str	x0, [x29, 104]
.L1253:
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	mov	w3, 1
	str	x0, [x28, 8]
	mov	w2, w3
	ldr	x0, [x25, #:lo12:.LANCHOR108]
	ldrh	w1, [x19, 2]
	str	x0, [x28, 16]
	ldrh	w0, [x19]
	orr	w0, w1, w0, lsl 10
	mov	w1, w3
	str	w0, [x28, 4]
	mov	x0, x28
	bl	FlashProgPages
	ldrh	w0, [x27, #:lo12:.LANCHOR20]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1254
	ldrh	w0, [x19]
	ldrh	w26, [x19, 4]
	strh	wzr, [x19, 2]
	strh	w0, [x19, 4]
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x19]
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	mov	w3, 1
	str	w1, [x19, 8]
	add	w2, w1, 1
	str	w2, [x23, #:lo12:.LANCHOR70]
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	strh	w0, [x21, 2]
	mov	w2, w3
	str	w1, [x21, 4]
	mov	x0, x28
	mov	w1, w3
	bl	FlashProgPages
.L1254:
	ldrh	w0, [x19, 2]
	ldr	w1, [x28]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L1255
	cmp	w0, 1
	bne	.L1256
	adrp	x1, .LANCHOR166
	adrp	x0, .LC1
	mov	w2, 1124
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1256:
	ldrh	w0, [x19, 2]
	cmp	w0, 1
	bne	.L1257
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1257:
	add	w20, w20, 1
	and	w20, w20, 65535
	cmp	w20, 3
	bls	.L1253
	add	x22, x22, :lo12:.LANCHOR106
	adrp	x0, .LC104
	mov	w2, w20
	add	x0, x0, :lo12:.LC104
	ldr	w1, [x22, 4]
	bl	printf
.L1259:
	b	.L1259
.L1255:
	cmp	w0, 1
	beq	.L1253
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1260
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.L1260:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSysFlush,"ax",@progbits
	.align	2
	.global	FtlSysFlush
	.type	FtlSysFlush, %function
FtlSysFlush:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	l2p_flush
	mov	w0, 1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.sftl_deinit,"ax",@progbits
	.align	2
	.global	sftl_deinit
	.type	sftl_deinit, %function
sftl_deinit:
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmp	w0, 1
	bne	.L1270
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1270:
	mov	w0, 0
	ret
	.size	sftl_deinit, .-sftl_deinit
	.section	.text.FtlDiscard,"ax",@progbits
	.align	2
	.global	FtlDiscard
	.type	FtlDiscard, %function
FtlDiscard:
	stp	x29, x30, [sp, -80]!
	add	w2, w0, w1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	adrp	x1, .LANCHOR34
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	ldr	w1, [x1, #:lo12:.LANCHOR34]
	cmp	w2, w1
	bhi	.L1281
	cmp	w19, 31
	bhi	.L1275
.L1289:
	mov	w0, 0
.L1273:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1275:
	adrp	x21, .LANCHOR12
	ldrh	w1, [x21, #:lo12:.LANCHOR12]
	udiv	w20, w0, w1
	msub	w0, w1, w20, w0
	ands	w0, w0, 65535
	beq	.L1276
	sub	w1, w1, w0
	add	w20, w20, 1
	cmp	w1, w19
	csel	w1, w1, w19, ls
	sub	w19, w19, w1, uxth
.L1276:
	adrp	x22, .LANCHOR167
	adrp	x23, .LANCHOR63
	add	x22, x22, :lo12:.LANCHOR167
	add	x23, x23, :lo12:.LANCHOR63
	mov	w0, -1
	str	w0, [x29, 76]
.L1277:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	cmp	w19, w0
	bcs	.L1279
	adrp	x0, .LANCHOR167
	ldr	w1, [x0, #:lo12:.LANCHOR167]
	cmp	w1, 32
	bls	.L1289
	str	wzr, [x0, #:lo12:.LANCHOR167]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1289
.L1279:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w20
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1278
	ldr	w0, [x22]
	mov	w2, 1
	add	x1, x29, 76
	add	w0, w0, 1
	str	w0, [x22]
	ldr	w0, [x23]
	add	w0, w0, 1
	str	w0, [x23]
	mov	w0, w20
	bl	log2phys
	ldr	w0, [x29, 72]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
.L1278:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L1277
.L1281:
	mov	w0, -1
	b	.L1273
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.FtlVpcCheckAndModify,"ax",@progbits
	.align	2
	.global	FtlVpcCheckAndModify
	.type	FtlVpcCheckAndModify, %function
FtlVpcCheckAndModify:
	stp	x29, x30, [sp, -96]!
	adrp	x1, .LANCHOR168
	adrp	x0, .LC94
	add	x1, x1, :lo12:.LANCHOR168
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC94
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR128
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR61
	str	x25, [sp, 64]
	bl	printf
	adrp	x0, .LANCHOR6
	mov	w19, 0
	add	x21, x21, :lo12:.LANCHOR61
	mov	w1, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	lsl	w2, w2, 1
	bl	ftl_memset
.L1291:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L1293
	adrp	x22, .LANCHOR5
	adrp	x23, .LC105
	add	x22, x22, :lo12:.LANCHOR5
	add	x23, x23, :lo12:.LC105
	mov	w19, 0
	adrp	x25, .LANCHOR42
	mov	w24, 65535
.L1294:
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L1298
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1293:
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w19
	bl	log2phys
	ldr	w0, [x29, 92]
	cmn	w0, #1
	beq	.L1292
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldr	x2, [x20, #:lo12:.LANCHOR128]
	ubfiz	x0, x0, 1, 16
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
.L1292:
	add	w19, w19, 1
	b	.L1291
.L1298:
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x21, x19, 1, 16
	ldrh	w2, [x0, x21]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w3, [x0, x21]
	cmp	w2, w3
	beq	.L1296
	cmp	w2, w24
	beq	.L1296
	mov	w1, w19
	mov	x0, x23
	bl	printf
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L1296
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L1296
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L1296
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w1, [x0, x21]
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	strh	w1, [x0, x21]
	mov	w0, w19
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1296:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1294
	.size	FtlVpcCheckAndModify, .-FtlVpcCheckAndModify
	.section	.text.allocate_new_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_new_data_superblock
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrh	w19, [x0]
	str	x21, [sp, 32]
	mov	x21, x0
	adrp	x0, .LANCHOR5
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w19
	bcs	.L1304
	adrp	x1, .LANCHOR169
	adrp	x0, .LC1
	mov	w2, 2684
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1304:
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1305
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1306
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L1305:
	adrp	x1, .LANCHOR150
	mov	w0, 1
	strb	w0, [x21, 8]
	mov	w2, 65535
	ldrh	w0, [x1, #:lo12:.LANCHOR150]
	mov	x20, x1
	cmp	w0, w2
	beq	.L1307
	cmp	w19, w0
	bne	.L1308
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1309
.L1308:
	bl	update_vpc_list
.L1309:
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR150]
.L1307:
	mov	x0, x21
	bl	allocate_data_superblock
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	ldr	x21, [sp, 32]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1306:
	mov	w0, w19
	bl	INSERT_FREE_LIST
	b	.L1305
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlProgPages,"ax",@progbits
	.align	2
	.global	FtlProgPages
	.type	FtlProgPages, %function
FtlProgPages:
	stp	x29, x30, [sp, -96]!
	mov	w2, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x3
	stp	x23, x24, [sp, 48]
	add	x20, x0, 4
	stp	x21, x22, [sp, 32]
	mov	w21, w1
	str	x25, [sp, 64]
	ubfiz	x21, x21, 5, 32
	add	x21, x21, 4
	adrp	x24, .LANCHOR19
	ldrb	w3, [x3, 9]
	adrp	x23, .LANCHOR81
	add	x21, x0, x21
	add	x24, x24, :lo12:.LANCHOR19
	add	x23, x23, :lo12:.LANCHOR81
	bl	FlashProgPages
.L1315:
	cmp	x20, x21
	beq	.L1322
	sub	x22, x20, #4
	adrp	x25, .LANCHOR42
	b	.L1323
.L1318:
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x19]
	cmp	w1, w0, uxth
	bne	.L1316
	ldr	x2, [x25, #:lo12:.LANCHOR42]
	ubfiz	x1, x1, 1, 16
	ldrh	w3, [x19, 4]
	ldrh	w0, [x2, x1]
	sub	w0, w0, w3
	strh	w0, [x2, x1]
	strb	wzr, [x19, 6]
	ldrh	w0, [x24]
	strh	w0, [x19, 2]
	strh	wzr, [x19, 4]
.L1316:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1317
	mov	x0, x19
	bl	allocate_new_data_superblock
.L1317:
	ldr	w0, [x23, 96]
	add	w0, w0, 1
	str	w0, [x23, 96]
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	FtlGcMarkBadPhyBlk
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x20]
	mov	w2, 0
	str	w0, [x29, 92]
	mov	w1, 1
	ldrb	w3, [x19, 9]
	mov	x0, x22
	bl	FlashProgPages
.L1323:
	ldr	w0, [x20, -4]
	cmn	w0, #1
	beq	.L1318
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1319
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 933
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1319:
	add	x1, x29, 96
	ldr	w0, [x22, 4]
	mov	w2, 1
	str	w0, [x1, -4]!
	ldr	w0, [x22, 24]
	bl	log2phys
	ldr	x0, [x22, 16]
	ldr	w3, [x0, 12]
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	mov	w22, w1
	cmn	w3, #1
	beq	.L1320
	adrp	x2, .LANCHOR42
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1321
	adrp	x0, .LC106
	mov	w2, 0
	add	x0, x0, :lo12:.LC106
	bl	printf
.L1321:
	mov	w0, w22
	bl	decrement_vpc_count
.L1320:
	add	x20, x20, 32
	b	.L1315
.L1322:
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1314
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 948
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1314:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	stp	x29, x30, [sp, -112]!
	mov	w2, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR19
	ldrh	w20, [x19, #:lo12:.LANCHOR53]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w20, w2
	str	x27, [sp, 80]
	ldrh	w1, [x21, #:lo12:.LANCHOR19]
	bne	.L1330
.L1340:
	adrp	x0, .LANCHOR152
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65535
	str	wzr, [x0, #:lo12:.LANCHOR152]
	cmp	w2, w1
	add	x0, x19, :lo12:.LANCHOR53
	bne	.L1353
.L1356:
	mov	w0, 0
.L1329:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1330:
	cbz	w0, .L1333
	adrp	x0, .LANCHOR156
	ldrh	w3, [x0, #:lo12:.LANCHOR156]
	cmp	w3, w2
	beq	.L1334
.L1335:
	mov	w1, 2
.L1333:
	add	x0, x19, :lo12:.LANCHOR53
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L1336
	adrp	x0, .LANCHOR43
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L1337
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L1337:
	adrp	x0, .LANCHOR152
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	cbnz	w1, .L1338
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1338:
	str	wzr, [x19, #:lo12:.LANCHOR152]
.L1349:
	mov	w0, 1
	b	.L1329
.L1334:
	strh	wzr, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 17
	bhi	.L1335
	b	.L1333
.L1336:
	adrp	x0, .LANCHOR156
	ldrh	w1, [x0, #:lo12:.LANCHOR156]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1349
	b	.L1340
.L1353:
	ldrb	w0, [x0, 7]
	adrp	x20, .LANCHOR97
	ldrh	w2, [x21, #:lo12:.LANCHOR19]
	ldrh	w1, [x20, #:lo12:.LANCHOR97]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1341
	adrp	x1, .LANCHOR171
	adrp	x0, .LC1
	mov	w2, 162
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1341:
	add	x0, x19, :lo12:.LANCHOR53
	adrp	x23, .LANCHOR42
	ldrh	w3, [x21, #:lo12:.LANCHOR19]
	adrp	x25, .LANCHOR61
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	adrp	x26, .LANCHOR171
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR61
	ldr	x1, [x23, #:lo12:.LANCHOR42]
	add	x26, x26, :lo12:.LANCHOR171
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR67
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	ldr	w2, [x1, #:lo12:.LANCHOR67]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR67]
.L1342:
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	cmp	w0, w21
	bhi	.L1346
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L1347
	bl	INSERT_DATA_LIST
.L1348:
	adrp	x0, .LANCHOR95
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR97]
	strh	w21, [x19, #:lo12:.LANCHOR53]
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR48
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L1356
	adrp	x0, .LANCHOR80
	mov	w1, 20
	strh	w21, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR82
	strh	w1, [x0, #:lo12:.LANCHOR82]
	b	.L1356
.L1346:
	adrp	x0, .LANCHOR98
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR98]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L1343
	adrp	x0, .LC1
	mov	w2, 168
	mov	x1, x26
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1343:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L1344
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L1355:
	bl	decrement_vpc_count
.L1345:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L1342
.L1344:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L1345
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	b	.L1355
.L1347:
	bl	INSERT_FREE_LIST
	b	.L1348
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.FtlGcPageRecovery,"ax",@progbits
	.align	2
	.global	FtlGcPageRecovery
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR19
	adrp	x19, .LANCHOR53
	add	x19, x19, :lo12:.LANCHOR53
	ldrh	w1, [x20, #:lo12:.LANCHOR19]
	mov	x0, x19
	bl	FtlGcScanTempBlk
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bcc	.L1357
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR152
	str	wzr, [x0, #:lo12:.LANCHOR152]
.L1357:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
	.section	.text.FtlPowerLostRecovery,"ax",@progbits
	.align	2
	.global	FtlPowerLostRecovery
	.type	FtlPowerLostRecovery, %function
FtlPowerLostRecovery:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR162
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR51
	add	x19, x19, :lo12:.LANCHOR51
	str	wzr, [x0, #:lo12:.LANCHOR162]
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	adrp	x19, .LANCHOR52
	bl	FtlSlcSuperblockCheck
	add	x19, x19, :lo12:.LANCHOR52
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	bl	FtlSlcSuperblockCheck
	bl	FtlGcPageRecovery
	mov	w0, -1
	bl	decrement_vpc_count
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
	.section	.text.Ftl_gc_temp_data_write_back,"ax",@progbits
	.align	2
	.global	Ftl_gc_temp_data_write_back
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	stp	x29, x30, [sp, -32]!
	mov	w3, 0
	mov	w2, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR89
	adrp	x20, .LANCHOR121
	ldr	w1, [x19, #:lo12:.LANCHOR89]
	add	x19, x19, :lo12:.LANCHOR89
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FlashProgPages
	mov	w11, 0
.L1363:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L1366
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR53+4
	ldrh	w0, [x0, #:lo12:.LANCHOR53+4]
	cbnz	w0, .L1367
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L1369
.L1366:
	ldr	x2, [x20, #:lo12:.LANCHOR121]
	ubfiz	x0, x11, 5, 16
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1364
	adrp	x0, .LANCHOR53
	adrp	x3, .LANCHOR42
	ldrh	w4, [x0, #:lo12:.LANCHOR53]
	ldr	x3, [x3, #:lo12:.LANCHOR42]
	strh	wzr, [x3, x4, lsl 1]
	strh	w2, [x0, #:lo12:.LANCHOR53]
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L1369:
	mov	w0, 1
.L1362:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1364:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L1363
.L1367:
	mov	w0, 0
	b	.L1362
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.Ftl_get_new_temp_ppa,"ax",@progbits
	.align	2
	.global	Ftl_get_new_temp_ppa
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR53
	mov	w2, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR53]
	cmp	w3, w2
	beq	.L1371
	add	x1, x0, :lo12:.LANCHOR53
	ldrh	w0, [x1, 4]
	cbnz	w0, .L1372
.L1371:
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	add	x0, x19, :lo12:.LANCHOR53
	strb	wzr, [x0, 8]
	bl	allocate_data_superblock
	adrp	x0, .LANCHOR95
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR97
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1372:
	add	x0, x19, :lo12:.LANCHOR53
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	get_new_active_ppa
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	stp	x29, x30, [sp, -192]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR117
	stp	x19, x20, [sp, 16]
	ldr	w1, [x22, #:lo12:.LANCHOR117]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L1446
	adrp	x1, .LANCHOR45
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	cmp	w1, 47
	bls	.L1446
	mov	w24, w0
	adrp	x0, .LANCHOR156
	ldrh	w1, [x0, #:lo12:.LANCHOR156]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1376
.L1379:
	adrp	x0, .LANCHOR100
	mov	w3, 65535
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w2, w3
	bne	.L1377
.L1378:
	adrp	x2, .LANCHOR84
	adrp	x19, .LANCHOR80
	mov	w20, 65535
	ldr	w1, [x2, #:lo12:.LANCHOR84]
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	add	w1, w1, 1
	add	w1, w1, w24, lsl 7
	str	w1, [x2, #:lo12:.LANCHOR84]
	cmp	w0, w20
	bne	.L1380
	adrp	x3, .LANCHOR53
	ldrh	w20, [x3, #:lo12:.LANCHOR53]
	cmp	w20, w0
	bne	.L1449
	adrp	x0, .LANCHOR99
	ldrh	w21, [x0, #:lo12:.LANCHOR99]
	cmp	w21, w20
	bne	.L1380
	adrp	x23, .LANCHOR48
	mov	w3, 1024
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cmp	w0, 24
	mov	w0, 5120
	csel	w0, w0, w3, cc
	cmp	w1, w0
	bls	.L1452
	adrp	x0, .LANCHOR172
	str	wzr, [x2, #:lo12:.LANCHOR84]
	strh	wzr, [x0, #:lo12:.LANCHOR172]
	bl	GetSwlReplaceBlock
	and	w20, w0, 65535
	cmp	w20, w21
	bne	.L1453
	adrp	x5, .LANCHOR83
	ldrh	w1, [x23, #:lo12:.LANCHOR48]
	ldrh	w0, [x5, #:lo12:.LANCHOR83]
	cmp	w1, w0
	bcs	.L1383
	mov	w0, 64
	bl	List_get_gc_head_node
	and	w0, w0, 65535
	cmp	w0, w20
	beq	.L1385
	adrp	x1, .LANCHOR42
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cmp	w0, 7
	bhi	.L1386
	mov	w0, 0
	bl	List_get_gc_head_node
	and	w21, w0, 65535
	mov	w0, 128
	strh	w0, [x5, #:lo12:.LANCHOR83]
	cmp	w21, w20
	bne	.L1382
.L1385:
	bl	FtlGcReFreshBadBlk
.L1380:
	cmp	w24, 0
	mov	w0, 65535
	ccmp	w20, w0, 0, eq
	bne	.L1388
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 24
	bhi	.L1454
	adrp	x1, .LANCHOR19
	cmp	w0, 16
	ldrh	w21, [x1, #:lo12:.LANCHOR19]
	bls	.L1390
	lsr	w21, w21, 5
.L1389:
	adrp	x2, .LANCHOR82
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR82]
	cmp	w1, w0
	bcs	.L1393
	adrp	x0, .LANCHOR53
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bne	.L1394
	adrp	x1, .LANCHOR99
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	cmp	w1, w0
	bne	.L1394
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	cbnz	w0, .L1395
	adrp	x1, .LANCHOR61
	adrp	x4, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	ldr	w4, [x4, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L1396
.L1395:
	adrp	x1, .LANCHOR78
	ldrh	w1, [x1, #:lo12:.LANCHOR78]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR82]
.L1397:
	adrp	x1, .LANCHOR87
	str	wzr, [x1, #:lo12:.LANCHOR87]
.L1374:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1376:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	beq	.L1379
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	cbz	w0, .L1379
	mov	w0, 1
	b	.L1374
.L1377:
	adrp	x1, .LANCHOR99
	ldrh	w4, [x1, #:lo12:.LANCHOR99]
	cmp	w4, w3
	bne	.L1378
	strh	w2, [x1, #:lo12:.LANCHOR99]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR100]
	b	.L1378
.L1386:
	mov	w0, 64
.L1478:
	strh	w0, [x5, #:lo12:.LANCHOR83]
	b	.L1385
.L1383:
	mov	w0, 80
	b	.L1478
.L1453:
	mov	w21, w20
.L1382:
	adrp	x1, .LANCHOR43
	ubfiz	x0, x21, 1, 32
	adrp	x3, .LANCHOR82
	mov	w20, w21
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	adrp	x1, .LANCHOR42
	ldrh	w5, [x3, #:lo12:.LANCHOR82]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w4, [x2, x0]
	ldrh	w2, [x23, #:lo12:.LANCHOR48]
	ldrh	w3, [x1, x0]
	mov	w1, w21
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	bl	printf
	b	.L1385
.L1449:
	mov	w20, w0
	b	.L1380
.L1452:
	mov	w20, w21
	b	.L1380
.L1390:
	cmp	w0, 12
	bls	.L1391
	lsr	w21, w21, 4
	b	.L1389
.L1391:
	cmp	w0, 8
	bls	.L1389
	lsr	w21, w21, 2
	b	.L1389
.L1454:
	mov	w21, 1
	b	.L1389
.L1396:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR82]
	b	.L1397
.L1394:
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR82]
.L1393:
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L1455
	add	w21, w21, 32
	and	w21, w21, 65535
.L1455:
	mov	w20, 65535
.L1399:
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1408
	cmp	w20, w0
	beq	.L1409
	strh	w20, [x19, #:lo12:.LANCHOR80]
.L1410:
	add	x0, x19, :lo12:.LANCHOR80
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w1
	beq	.L1408
	bl	IsBlkInGcList
	cbz	w0, .L1413
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1413:
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	add	x23, x19, :lo12:.LANCHOR80
	cmp	w1, w0
	beq	.L1408
	mov	x0, x23
	bl	make_superblock
	adrp	x0, .LANCHOR173
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	strh	wzr, [x23, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR42
	strb	wzr, [x23, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	strh	w1, [x0, #:lo12:.LANCHOR174]
.L1408:
	adrp	x0, .LANCHOR51
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR51]
	cmp	w2, w1
	beq	.L1414
	adrp	x0, .LANCHOR52
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w2, w1
	beq	.L1414
	adrp	x24, .LANCHOR85
	add	x0, x24, :lo12:.LANCHOR85
	str	x0, [x29, 160]
.L1415:
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1416
	adrp	x0, .LANCHOR87
	adrp	x25, .LANCHOR19
	add	x25, x25, :lo12:.LANCHOR19
	str	wzr, [x0, #:lo12:.LANCHOR87]
.L1417:
	ldrh	w5, [x24, #:lo12:.LANCHOR85]
	add	x7, x24, :lo12:.LANCHOR85
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1418
	strh	wzr, [x7]
	mov	w0, 8
	b	.L1374
.L1388:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1458
	adrp	x0, .LANCHOR99
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	cmp	w0, w1
	bne	.L1458
	cmp	w20, w0
	bne	.L1458
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w20
	beq	.L1400
.L1458:
	mov	w21, 1
	b	.L1399
.L1400:
	adrp	x0, .LANCHOR87
	adrp	x21, .LANCHOR48
	adrp	x23, .LANCHOR172
	str	wzr, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR82
	ldrh	w6, [x21, #:lo12:.LANCHOR48]
	mov	x2, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR82]
	cmp	w1, w6
	ldrh	w1, [x23, #:lo12:.LANCHOR172]
	bcs	.L1401
	cbnz	w1, .L1402
	adrp	x1, .LANCHOR61
	adrp	x3, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	ldr	w3, [x3, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w3, w1, lsr 2
	bcs	.L1403
.L1402:
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR82]
.L1479:
	bl	FtlReadRefresh
	ldrh	w0, [x23, #:lo12:.LANCHOR172]
	b	.L1374
.L1403:
	mov	w1, 18
	strh	w1, [x0, #:lo12:.LANCHOR82]
	b	.L1479
.L1401:
	cbnz	w1, .L1458
	adrp	x1, .LANCHOR78
	ldrh	w5, [x1, #:lo12:.LANCHOR78]
	add	w1, w5, w5, lsl 1
	asr	w1, w1, 2
	strh	w1, [x0, #:lo12:.LANCHOR82]
	mov	w0, 0
	bl	List_get_gc_head_node
	ubfiz	x0, x0, 1, 16
	adrp	x1, .LANCHOR42
	adrp	x2, .LANCHOR3
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w2, [x2, #:lo12:.LANCHOR3]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR20
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	mul	w0, w0, w2
	cmp	w1, w0, asr 1
	ble	.L1406
	sub	w5, w5, #1
	cmp	w6, w5
	bge	.L1479
.L1406:
	cbnz	w1, .L1458
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x21, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	b	.L1374
.L1409:
	adrp	x0, .LANCHOR99
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	cmp	w1, w20
	beq	.L1410
	adrp	x2, .LANCHOR42
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L1411
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
.L1411:
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	strh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
	b	.L1410
.L1414:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1480:
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	b	.L1374
.L1418:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L1419
	strh	w5, [x24, #:lo12:.LANCHOR85]
	b	.L1417
.L1419:
	adrp	x23, .LANCHOR42
	adrp	x4, .LANCHOR3
	ldrh	w0, [x25]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR3]
	strh	w5, [x24, #:lo12:.LANCHOR85]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L1421
	cmp	w5, 48
	bls	.L1422
	cmp	w3, 8
	bls	.L1422
	adrp	x3, .LANCHOR95
	ldrh	w3, [x3, #:lo12:.LANCHOR95]
	cmp	w3, 35
	bhi	.L1422
.L1421:
	ldr	x3, [x29, 160]
	strh	wzr, [x3]
.L1422:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L1423
	mov	w0, 65535
	cmp	w20, w0
	bne	.L1423
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR85
	strh	wzr, [x0, #:lo12:.LANCHOR85]
	b	.L1480
.L1423:
	cbnz	w1, .L1424
	mov	w0, -1
	bl	decrement_vpc_count
	ldr	x0, [x29, 160]
	ldr	x1, [x29, 160]
	ldrh	w0, [x0]
	add	w0, w0, 1
	strh	w0, [x1]
	b	.L1417
.L1424:
	add	x0, x19, :lo12:.LANCHOR80
	strb	wzr, [x0, 8]
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w6
	bne	.L1425
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 658
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1425:
	ldr	x0, [x29, 128]
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1426
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 659
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1426:
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1427
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 660
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1427:
	add	x25, x19, :lo12:.LANCHOR80
	mov	x0, x25
	bl	make_superblock
	adrp	x0, .LANCHOR173
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	strh	wzr, [x25, 2]
	strh	w1, [x0, #:lo12:.LANCHOR174]
	strb	wzr, [x25, 6]
.L1416:
	bl	FtlReadRefresh
	adrp	x1, .LANCHOR19
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR117]
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	str	w0, [x29, 172]
	add	x0, x19, :lo12:.LANCHOR80
	str	x1, [x29, 120]
	ldr	w3, [x29, 172]
	ldrh	w0, [x0, 2]
	add	w2, w0, w21
	cmp	w2, w3
	ble	.L1428
	sub	w21, w3, w0
	and	w21, w21, 65535
.L1428:
	adrp	x0, .LANCHOR173
	mov	w27, 0
	add	x0, x0, :lo12:.LANCHOR173
	str	x0, [x29, 152]
.L1429:
	cmp	w21, w27, uxth
	bls	.L1437
	add	x1, x19, :lo12:.LANCHOR80
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR93
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR3]
	mov	w23, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	mov	w6, 65535
	add	w4, w4, w27
	b	.L1438
.L1431:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L1430
	ubfiz	x5, x23, 5, 16
	add	w23, w23, 1
	add	x5, x0, x5
	and	w23, w23, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x5, 4]
.L1430:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L1438:
	cmp	w2, w7
	bne	.L1431
	add	x1, x19, :lo12:.LANCHOR80
	adrp	x26, .LANCHOR89
	add	x26, x26, :lo12:.LANCHOR89
	ldrb	w2, [x1, 8]
	mov	w1, w23
	bl	FlashReadPages
	ubfiz	x0, x23, 5, 16
	mov	x23, 0
	str	x0, [x29, 144]
.L1432:
	ldr	x0, [x29, 144]
	cmp	x0, x23
	bne	.L1436
	add	w27, w27, 1
	b	.L1429
.L1436:
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	add	x1, x0, x23
	ldr	w0, [x0, x23]
	cmn	w0, #1
	beq	.L1433
	ldr	x28, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x28]
	cmp	w1, w0
	bne	.L1433
	ldr	w4, [x28, 8]
	cmn	w4, #1
	bne	.L1434
	str	w4, [x29, 112]
	mov	w2, 696
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
	ldr	w4, [x29, 112]
.L1434:
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	ldr	w1, [x29, 188]
	add	x0, x0, x23
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bne	.L1433
	ldr	x1, [x29, 152]
	adrp	x4, .LANCHOR121
	ldr	x2, [x29, 152]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	ldr	w1, [x26]
	add	x1, x2, x1, lsl 5
	stp	x4, x1, [x29, 104]
	str	w0, [x1, 24]
	bl	Ftl_get_new_temp_ppa
	ldp	x4, x1, [x29, 104]
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	str	w0, [x1, 4]
	ldr	w1, [x26]
	ubfiz	x0, x1, 5, 32
	add	w1, w1, 1
	add	x2, x2, x0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	add	x0, x0, x23
	ldr	x4, [x0, 8]
	str	x4, [x2, 8]
	ldr	x4, [x0, 16]
	str	x4, [x2, 16]
	ldr	w2, [x29, 188]
	str	w2, [x28, 12]
	adrp	x2, .LANCHOR53
	add	x11, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	strh	w2, [x28, 2]
	adrp	x2, .LANCHOR71
	str	w1, [x26]
	mov	w1, 1
	ldr	w2, [x2, #:lo12:.LANCHOR71]
	str	w2, [x28, 4]
	bl	FtlGcBufAlloc
	ldrb	w1, [x11, 7]
	ldr	w0, [x26]
	cmp	w1, w0
	beq	.L1435
	ldrh	w0, [x11, 4]
	cbnz	w0, .L1433
.L1435:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L1433
.L1481:
	str	wzr, [x22, #:lo12:.LANCHOR117]
	b	.L1480
.L1433:
	add	x23, x23, 32
	b	.L1432
.L1437:
	add	x1, x19, :lo12:.LANCHOR80
	ldrh	w0, [x1, 2]
	add	w21, w21, w0
	ldr	w0, [x29, 172]
	and	w21, w21, 65535
	strh	w21, [x1, 2]
	cmp	w0, w21
	bls	.L1439
	adrp	x0, .LANCHOR173
	ldrh	w1, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR174
	ldrh	w0, [x0, #:lo12:.LANCHOR174]
	cmp	w1, w0
	bne	.L1440
.L1439:
	adrp	x0, .LANCHOR89
	ldr	w0, [x0, #:lo12:.LANCHOR89]
	cbz	w0, .L1441
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L1481
.L1441:
	adrp	x0, .LANCHOR173
	ldrh	w0, [x0, #:lo12:.LANCHOR173]
	cbnz	w0, .L1442
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L1442
	strh	wzr, [x1, x0]
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1442:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1440:
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1443
	ldr	x0, [x29, 120]
	ldrh	w21, [x0, #:lo12:.LANCHOR19]
	b	.L1415
.L1443:
	adrp	x1, .LANCHOR172
	str	wzr, [x22, #:lo12:.LANCHOR117]
	ldrh	w1, [x1, #:lo12:.LANCHOR172]
	cmp	w1, 0
	csinc	w0, w1, w0, ne
	b	.L1374
.L1446:
	mov	w0, 0
	b	.L1374
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.sftl_gc,"ax",@progbits
	.align	2
	.global	sftl_gc
	.type	sftl_gc, %function
sftl_gc:
	mov	w1, 1
	mov	w0, w1
	b	rk_ftl_garbage_collect
	.size	sftl_gc, .-sftl_gc
	.section	.text.FtlRead,"ax",@progbits
	.align	2
	.global	FtlRead
	.type	FtlRead, %function
FtlRead:
	stp	x29, x30, [sp, -176]!
	and	w0, w0, 255
	cmp	w0, 16
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	stp	x27, x28, [sp, 80]
	mov	w27, w2
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	bne	.L1484
	mov	x2, x3
	mov	w1, w27
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L1483:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1484:
	add	w0, w1, w2
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR34
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1504
	adrp	x0, .LANCHOR86
	ldr	w21, [x0, #:lo12:.LANCHOR86]
	cmn	w21, #1
	beq	.L1483
	adrp	x22, .LANCHOR12
	sub	w24, w1, #1
	adrp	x1, .LANCHOR62
	mov	w25, 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	mov	w21, 0
	adrp	x28, .LANCHOR120
	stp	wzr, wzr, [x29, 144]
	udiv	w26, w19, w0
	udiv	w24, w24, w0
	mov	w20, w26
	sub	w0, w24, w26
	add	w0, w0, 1
	stp	wzr, w0, [x29, 152]
	ldr	w0, [x1, #:lo12:.LANCHOR62]
	ldr	w2, [x29, 156]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	str	x0, [x29, 128]
.L1486:
	ldr	w0, [x29, 156]
	cbnz	w0, .L1502
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbnz	w0, .L1503
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 31
	bhi	.L1483
.L1503:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L1483
.L1502:
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1487
	add	x5, x22, :lo12:.LANCHOR12
	mov	w4, 0
.L1488:
	ldrh	w0, [x5]
	cmp	w4, w0
	bcc	.L1490
.L1491:
	ldr	w0, [x29, 156]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 156]
	beq	.L1495
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w25, w0, lsl 2
	bne	.L1486
.L1495:
	cbz	w25, .L1486
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	mov	w1, w25
	mov	w2, 0
	bl	FlashReadPages
	ldr	w0, [x29, 144]
	lsl	w0, w0, 9
	str	w0, [x29, 136]
	ldr	w0, [x29, 152]
	lsl	w0, w0, 9
	str	x0, [x29, 120]
	ldr	w0, [x29, 148]
	lsl	w0, w0, 9
	str	w0, [x29, 112]
	ubfiz	x0, x25, 5, 32
	mov	x25, 0
	str	x0, [x29, 104]
	add	x0, x22, :lo12:.LANCHOR12
	str	x0, [x29, 96]
.L1501:
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	add	x0, x0, x25
	ldr	w1, [x0, 24]
	cmp	w26, w1
	bne	.L1497
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR115
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	cmp	x1, x0
	bne	.L1498
	ldr	x0, [x29, 120]
	ldr	w2, [x29, 112]
	add	x1, x1, x0
	mov	x0, x23
.L1515:
	bl	ftl_memcpy
.L1498:
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1499
	ldr	x1, [x29, 128]
	mov	w21, w0
	ldr	x2, [x29, 128]
	ldr	w1, [x1, 72]
	add	w1, w1, 1
	str	w1, [x2, 72]
.L1500:
	ldr	x0, [x29, 104]
	add	x25, x25, 32
	cmp	x0, x25
	bne	.L1501
	mov	w25, 0
	b	.L1486
.L1490:
	madd	w0, w20, w0, w4
	cmp	w19, w0
	bhi	.L1489
	ldr	w1, [x29, 140]
	cmp	w1, w0
	bls	.L1489
	sub	w0, w0, w19
	str	x5, [x29, 112]
	lsl	w0, w0, 9
	str	w4, [x29, 120]
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	w4, [x29, 120]
	ldr	x5, [x29, 112]
.L1489:
	add	w4, w4, 1
	b	.L1488
.L1487:
	ldr	x2, [x28, #:lo12:.LANCHOR120]
	ubfiz	x0, x25, 5, 32
	cmp	w20, w26
	add	x0, x2, x0
	str	w1, [x0, 4]
	bne	.L1492
	adrp	x1, .LANCHOR115
	ldr	x1, [x1, #:lo12:.LANCHOR115]
	str	x1, [x0, 8]
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 152]
	sub	w2, w1, w2
	cmp	w27, w2
	csel	w2, w27, w2, ls
	str	w2, [x29, 148]
	cmp	w1, w2
	bne	.L1493
	str	x23, [x0, 8]
.L1493:
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR114
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR24]
	ldr	x2, [x2, #:lo12:.LANCHOR114]
	mul	w1, w1, w25
	add	w25, w25, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L1491
.L1492:
	cmp	w20, w24
	bne	.L1494
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	adrp	x1, .LANCHOR113
	ldr	w3, [x29, 140]
	ldr	x1, [x1, #:lo12:.LANCHOR113]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 144]
	cmp	w2, w3
	bne	.L1493
.L1514:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L1493
.L1494:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	mul	w1, w1, w20
	b	.L1514
.L1497:
	cmp	w24, w1
	bne	.L1498
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR113
	ldr	x0, [x0, #:lo12:.LANCHOR113]
	cmp	x1, x0
	bne	.L1498
	ldr	x0, [x29, 96]
	ldr	w2, [x29, 136]
	ldrh	w0, [x0]
	mul	w0, w0, w24
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L1515
.L1499:
	cmp	w0, 256
	bne	.L1500
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1500
.L1504:
	mov	w21, -1
	b	.L1483
	.size	FtlRead, .-FtlRead
	.section	.text.sftl_read,"ax",@progbits
	.align	2
	.global	sftl_read
	.type	sftl_read, %function
sftl_read:
	mov	x3, x2
	mov	w2, w1
	mov	w1, w0
	mov	w0, 0
	b	FtlRead
	.size	sftl_read, .-sftl_read
	.section	.text.FtlWrite,"ax",@progbits
	.align	2
	.global	FtlWrite
	.type	FtlWrite, %function
FtlWrite:
	stp	x29, x30, [sp, -240]!
	and	w0, w0, 255
	cmp	w0, 16
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, w1
	stp	x25, x26, [sp, 64]
	mov	x26, x3
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	str	w2, [x29, 176]
	bne	.L1518
	add	w0, w1, 256
	ldr	w1, [x29, 176]
	mov	x2, x3
	bl	FtlVendorPartWrite
.L1517:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1518:
	ldr	w0, [x29, 176]
	add	w0, w1, w0
	str	w0, [x29, 168]
	adrp	x0, .LANCHOR34
	ldr	w1, [x29, 168]
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1553
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmn	w0, #1
	beq	.L1517
	adrp	x0, .LANCHOR176
	mov	w1, 2048
	adrp	x22, .LANCHOR12
	str	w1, [x0, #:lo12:.LANCHOR176]
	ldr	w1, [x29, 168]
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	sub	w1, w1, #1
	udiv	w25, w21, w0
	udiv	w0, w1, w0
	adrp	x1, .LANCHOR64
	str	w0, [x29, 156]
	sub	w0, w0, w25
	add	w24, w0, 1
	str	w0, [x29, 152]
	ldr	w0, [x1, #:lo12:.LANCHOR64]
	add	w0, w0, w24
	str	w0, [x1, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR177
	str	x0, [x29, 160]
	ldr	w1, [x0, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	cbz	w1, .L1520
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1520
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L1520:
	mov	w20, w25
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	str	x0, [x29, 96]
.L1521:
	cbnz	w24, .L1549
	ldr	w1, [x29, 152]
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR48
	mov	x22, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	cmp	w1, 15
	bls	.L1550
.L1552:
	mov	w0, 0
	b	.L1517
.L1549:
	adrp	x0, .LANCHOR3
	ldrb	w2, [x19, 6]
	str	x0, [x29, 120]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	cmp	w2, w1
	bcc	.L1522
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 988
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1522:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1523
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	cmp	x19, x0
	bne	.L1524
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1525
	bl	allocate_new_data_superblock
	ldr	x0, [x29, 160]
	str	wzr, [x0, #:lo12:.LANCHOR177]
.L1525:
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	mov	x0, x19
	bl	allocate_new_data_superblock
	ldr	x0, [x29, 160]
	ldr	w0, [x0, #:lo12:.LANCHOR177]
	cmp	w0, 0
	ldr	x0, [x29, 96]
	csel	x19, x0, x19, ne
.L1526:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1523
	mov	x0, x19
	bl	allocate_new_data_superblock
.L1523:
	ldrh	w0, [x19, 4]
	ldrb	w1, [x19, 7]
	cmp	w0, w24
	csel	w0, w0, w24, ls
	lsl	w1, w1, 2
	cmp	w1, w0
	csel	w0, w1, w0, ls
	str	w0, [x29, 148]
	ldr	x0, [x29, 120]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1527
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1021
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1527:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	str	xzr, [x29, 184]
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	str	x0, [x29, 104]
.L1528:
	ldr	w1, [x29, 148]
	adrp	x28, .LANCHOR122
	ldr	w23, [x29, 184]
	cmp	w23, w1
	bcc	.L1547
	mov	x23, x1
.L1529:
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	mov	x3, x19
	mov	w2, 0
	mov	w1, w23
	bl	FtlProgPages
	cmp	w24, w23
	bcs	.L1548
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1098
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1548:
	sub	w24, w24, w23
	b	.L1521
.L1524:
	ldr	x1, [x29, 160]
	str	wzr, [x1, #:lo12:.LANCHOR177]
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1558
	mov	x0, x19
	bl	allocate_new_data_superblock
	b	.L1526
.L1558:
	mov	x19, x0
	b	.L1523
.L1547:
	ldrh	w0, [x19, 4]
	cbz	w0, .L1529
	add	x1, x29, 204
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	mov	x0, x19
	bl	get_new_active_ppa
	ldr	x1, [x29, 184]
	lsl	x27, x1, 5
	ldr	x1, [x28, #:lo12:.LANCHOR122]
	add	x1, x1, x27
	str	w0, [x1, 4]
	ldr	x0, [x29, 112]
	str	w20, [x1, 24]
	ldrh	w2, [x0]
	mul	w23, w23, w2
	and	x0, x23, 4294967292
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR114
	ldr	x3, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR114]
	str	x0, [x29, 128]
	add	x23, x0, x3
	str	x23, [x1, 16]
	mov	x0, x23
	mov	w1, 0
	bl	ftl_memset
	ldr	w0, [x29, 156]
	cmp	w20, w25
	ccmp	w20, w0, 4, ne
	bne	.L1530
	cmp	w20, w25
	bne	.L1531
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 172]
	sub	w2, w2, w0
	ldr	w0, [x29, 176]
	cmp	w2, w0
	csel	w0, w2, w0, ls
	str	w0, [x29, 180]
.L1532:
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	ldr	w1, [x29, 180]
	cmp	w1, w0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	bne	.L1533
	add	x3, x0, x27
	cmp	w20, w25
	bne	.L1534
	str	x26, [x3, 8]
.L1535:
	ldr	x0, [x29, 120]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1544
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1089
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1544:
	ldp	x1, x2, [x29, 128]
	mov	w0, -3947
	strh	w0, [x1, x2]
	adrp	x1, .LANCHOR71
	ldr	w0, [x1, #:lo12:.LANCHOR71]
	stp	w0, w20, [x23, 4]
	add	w20, w20, 1
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR71]
	ldr	w0, [x29, 204]
	str	w0, [x23, 12]
	ldrh	w0, [x19]
	strh	w0, [x23, 2]
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
	b	.L1528
.L1531:
	ldr	w0, [x29, 168]
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	str	wzr, [x29, 172]
	msub	w2, w20, w2, w0
	and	w0, w2, 65535
	str	w0, [x29, 180]
	b	.L1532
.L1534:
	ldr	w0, [x29, 180]
.L1565:
	mul	w0, w0, w20
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x26, x0
	str	x0, [x3, 8]
	b	.L1535
.L1533:
	add	x0, x0, x27
	cmp	w20, w25
	bne	.L1536
	adrp	x1, .LANCHOR115
	ldr	x1, [x1, #:lo12:.LANCHOR115]
.L1564:
	str	x1, [x0, 8]
	ldr	w0, [x29, 204]
	cmn	w0, #1
	beq	.L1538
	str	w0, [x29, 212]
	mov	w2, 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	str	w20, [x29, 232]
	add	x0, x0, x27
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 216]
	mov	w1, 1
	add	x0, x29, 208
	bl	FlashReadPages
	ldr	w0, [x29, 208]
	cmn	w0, #1
	bne	.L1539
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L1542:
	ldr	w0, [x29, 180]
	cmp	w20, w25
	lsl	w2, w0, 9
	bne	.L1543
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	mov	x1, x26
	add	x3, x0, x27
	ldr	w0, [x29, 172]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L1566:
	bl	ftl_memcpy
	b	.L1535
.L1536:
	adrp	x1, .LANCHOR113
	ldr	x1, [x1, #:lo12:.LANCHOR113]
	b	.L1564
.L1539:
	ldr	w1, [x23, 8]
	cmp	w20, w1
	beq	.L1541
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC108
	mov	w2, w20
	add	x0, x0, :lo12:.LC108
	bl	printf
.L1541:
	ldr	w0, [x23, 8]
	cmp	w20, w0
	beq	.L1542
	mov	w2, 1074
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1542
.L1538:
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	ldr	x1, [x29, 104]
	add	x0, x0, x27
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L1542
.L1543:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x3, x0, x27
	mul	w1, w1, w20
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x26, x1
	b	.L1566
.L1530:
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x3, x0, x27
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	b	.L1565
.L1550:
	adrp	x21, .LANCHOR99
	adrp	x20, .LANCHOR83
	adrp	x19, .LANCHOR82
	add	x21, x21, :lo12:.LANCHOR99
	add	x20, x20, :lo12:.LANCHOR83
	add	x19, x19, :lo12:.LANCHOR82
.L1562:
	adrp	x0, .LANCHOR80
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w1
	bne	.L1551
	ldrh	w1, [x21]
	cmp	w1, w0
	bne	.L1551
	mov	w0, 0
	bl	List_get_gc_head_node
	bl	FtlGcRefreshBlock
.L1551:
	mov	w0, 128
	mov	w1, 1
	strh	w0, [x20]
	strh	w0, [x19]
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	ldrh	w0, [x22, #:lo12:.LANCHOR48]
	cmp	w0, 8
	bls	.L1562
	b	.L1552
.L1553:
	mov	w0, -1
	b	.L1517
	.size	FtlWrite, .-FtlWrite
	.section	.text.sftl_write,"ax",@progbits
	.align	2
	.global	sftl_write
	.type	sftl_write, %function
sftl_write:
	stp	x29, x30, [sp, -240]!
	add	w4, w0, w1
	sub	w5, w4, #1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	cmp	w5, 63
	stp	x21, x22, [sp, 32]
	mov	w20, w0
	stp	x23, x24, [sp, 48]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR179
	bls	.L1568
	cmp	w0, 576
	bls	.L1569
.L1568:
	ldr	w0, [x25, #:lo12:.LANCHOR179]
	cbz	w0, .L1570
	adrp	x2, .LANCHOR0
	add	x1, x2, :lo12:.LANCHOR0
	mov	w21, 512
	adrp	x3, idb_buf
	mov	x4, -49148
	stp	x3, x2, [x29, 144]
	ldrh	w0, [x1, 14]
	add	x2, x3, :lo12:idb_buf
	ldrh	w1, [x1, 10]
	mov	x7, 262140
	str	w0, [x29, 172]
	and	w0, w0, 255
	mov	w5, 4097
	movk	x4, 0xfffc, lsl 16
	mul	w0, w0, w1
	mov	x1, 0
	and	w0, w0, 65535
	str	w0, [x29, 168]
	udiv	w21, w21, w0
	mov	w0, 0
.L1574:
	add	x3, x1, x7
	ldr	w6, [x3, x2]
	cbz	w6, .L1571
.L1575:
	ldr	w0, [x29, 168]
	mov	w19, 0
	mov	w26, 0
	mul	w0, w0, w21
	stp	w0, wzr, [x29, 160]
	adrp	x0, .LANCHOR105
	add	x23, x0, :lo12:.LANCHOR105
.L1572:
	adrp	x5, gp_flash_check_buf
	mov	x2, 512
	mov	w1, 0
	add	x0, x5, :lo12:gp_flash_check_buf
	str	x5, [x29, 136]
	bl	memset
	ldr	x0, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR0
	ldrh	w3, [x0, 14]
	ldrh	w2, [x0, 10]
	adrp	x0, .LANCHOR105
	and	w27, w3, 255
	add	x4, x0, :lo12:.LANCHOR105
	str	w3, [x29, 120]
	mov	w0, 0
	udiv	w1, w19, w3
	str	x4, [x29, 112]
	mul	w2, w27, w2
	ldr	x6, [x4, 8]
	str	w27, [x29, 128]
	and	w28, w2, 65535
	blr	x6
	cmp	w28, 511
	ldr	w3, [x29, 120]
	ldr	x4, [x29, 112]
	bhi	.L1576
	add	w1, w28, w19
	ldr	x4, [x4, 8]
	mov	w0, 0
	udiv	w1, w1, w3
	blr	x4
.L1576:
	udiv	w5, w19, w28
	ldr	x0, [x29, 144]
	mov	w4, 0
	mov	w7, 61424
	add	x8, x0, :lo12:idb_buf
	msub	w5, w5, w28, w19
	sub	w6, w19, w5
.L1577:
	cmp	w4, 511
	bls	.L1578
	ldr	x0, [x29, 152]
	mov	w27, 0
	add	x0, x0, :lo12:.LANCHOR0
	ldrh	w4, [x0, 14]
	ldrh	w5, [x0, 10]
	and	w28, w4, 255
	mov	w4, w28
	mul	w5, w28, w5
	and	w0, w5, 65535
	udiv	w5, w19, w0
	msub	w5, w5, w0, w19
	and	w1, w5, 65535
	sub	w6, w19, w5
	sdiv	w0, w1, w28
	msub	w0, w0, w28, w1
	ldr	x1, [x29, 136]
	and	w0, w0, 65535
	add	x8, x1, :lo12:gp_flash_check_buf
.L1579:
	cmp	w27, 511
	bhi	.L1583
	add	w1, w5, w27
	sub	w7, w4, w0
	add	w0, w0, w6
	ldr	x10, [x23, 24]
	and	w7, w7, 65535
	ubfiz	x2, x27, 9, 16
	udiv	w1, w1, w28
	add	x2, x8, x2
	stp	w4, w7, [x29, 104]
	add	x3, x29, 176
	str	w5, [x29, 112]
	str	w6, [x29, 120]
	and	w1, w1, 65535
	str	x8, [x29, 128]
	madd	w1, w1, w28, w0
	mov	w0, 0
	udiv	w1, w1, w28
	blr	x10
	cmn	w0, #1
	ldp	w4, w7, [x29, 104]
	ldr	w5, [x29, 112]
	ldr	w6, [x29, 120]
	ldr	x8, [x29, 128]
	bne	.L1580
.L1583:
	ldr	x0, [x29, 144]
	mov	x27, 0
	add	x1, x0, :lo12:idb_buf
	ldr	x0, [x29, 136]
	add	x28, x0, :lo12:gp_flash_check_buf
.L1581:
	lsl	x0, x27, 2
	add	x3, x0, x1
	ldr	w2, [x0, x28]
	ldr	w0, [x0, x1]
	cmp	w2, w0
	beq	.L1584
	mov	x2, 512
	mov	w1, 0
	str	x3, [x29, 128]
	mov	x0, x28
	str	w27, [x29, 136]
	bl	memset
	ldr	w5, [x29, 136]
	mov	w4, w27
	ldr	x3, [x29, 128]
	mov	w1, w19
	adrp	x0, .LC109
	add	x0, x0, :lo12:.LC109
	ldr	w2, [x28, w5, uxtw 2]
	ldr	w3, [x3]
	bl	printf
	ldr	w0, [x29, 172]
	ldr	x2, [x23, 8]
	udiv	w1, w19, w0
	mov	w0, 0
	blr	x2
	cmp	w21, 1
	bls	.L1585
	ldr	w0, [x29, 168]
	ldr	x2, [x23, 8]
	add	w1, w0, w19
	ldr	w0, [x29, 172]
	udiv	w1, w1, w0
	mov	w0, 0
	blr	x2
.L1585:
	ldr	w0, [x29, 160]
	add	w26, w26, w21
	cmp	w26, 15
	add	w19, w19, w0
	bls	.L1572
.L1590:
	str	wzr, [x25, #:lo12:.LANCHOR179]
.L1570:
	mov	x3, x24
	mov	w2, w22
	mov	w1, w20
	mov	w0, 0
	bl	FtlWrite
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1571:
	ldr	w6, [x2, w0, uxtw 2]
	add	w0, w0, 1
	str	w6, [x3, x2]
	cmp	w0, w5
	sub	x1, x1, #4
	csel	w0, w0, wzr, cc
	cmp	x1, x4
	bne	.L1574
	b	.L1575
.L1578:
	add	w0, w5, w4
	ldr	x10, [x23, 16]
	ubfiz	x2, x4, 9, 16
	stp	w5, w7, [x29, 100]
	add	x2, x8, x2
	stp	w4, w6, [x29, 108]
	udiv	w0, w0, w27
	str	x8, [x29, 120]
	add	x3, x29, 176
	and	w0, w0, 65535
	mul	w1, w0, w27
	stp	w1, w7, [x29, 176]
	udiv	w1, w6, w27
	add	w1, w1, w0
	mov	w0, 0
	blr	x10
	ldp	w4, w6, [x29, 108]
	ldr	w0, [x29, 128]
	ldp	w5, w7, [x29, 100]
	add	w4, w0, w4
	and	w4, w4, 65535
	ldr	x8, [x29, 120]
	b	.L1577
.L1580:
	add	w27, w7, w27
	mov	w0, 0
	and	w27, w27, 65535
	b	.L1579
.L1584:
	add	x27, x27, 1
	cmp	x27, 65536
	bne	.L1581
	ldr	w0, [x29, 164]
	add	w0, w0, 1
	str	w0, [x29, 164]
	cmp	w0, 5
	bls	.L1585
	b	.L1590
.L1569:
	cmp	w0, 63
	adrp	x3, idb_buf
	bhi	.L1587
	mov	w1, 64
	sub	w1, w1, w0
	sub	w2, w22, w1
	ubfiz	x1, x1, 9, 25
	add	x1, x24, x1
	add	x0, x3, :lo12:idb_buf
.L1588:
	mov	w3, 1
	str	w3, [x25, #:lo12:.LANCHOR179]
	cmp	w5, 576
	bls	.L1589
	sub	w2, w2, w4
	sub	w2, w2, #447
.L1589:
	lsl	w2, w2, 9
	bl	memcpy
	b	.L1570
.L1587:
	lsl	w0, w0, 7
	add	x3, x3, :lo12:idb_buf
	sub	w0, w0, #8192
	mov	x1, x2
	add	x0, x3, x0, lsl 2
	mov	w2, w22
	b	.L1588
	.size	sftl_write, .-sftl_write
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	stp	x29, x30, [sp, -96]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR106
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR107
	stp	x21, x22, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR106
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR108
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR42
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	adrp	x24, .LANCHOR5
	str	x0, [x21, 8]
	adrp	x20, .LANCHOR79
	ldr	x0, [x26, #:lo12:.LANCHOR108]
	str	x0, [x21, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1601
.L1609:
	mov	w0, -1
.L1600:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1601:
	add	x27, x20, :lo12:.LANCHOR79
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	sxth	w22, w0
	add	w0, w0, 1
	mov	w28, 61604
	strh	w0, [x27, 2]
	mov	w27, 19539
	movk	w27, 0x4654, lsl 16
.L1603:
	tbz	w22, #31, .L1606
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1437
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1605:
	adrp	x1, .LANCHOR23
	ldrh	w0, [x24, #:lo12:.LANCHOR5]
	ldrh	w1, [x1, #:lo12:.LANCHOR23]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L1608
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1439
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1608:
	add	x22, x19, :lo12:.LANCHOR106
	adrp	x19, .LANCHOR39
	add	x21, x19, :lo12:.LANCHOR39
	mov	w2, 48
	mov	x0, x21
	ldr	x1, [x22, 8]
	bl	ftl_memcpy
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	ldr	x1, [x22, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	ldr	x0, [x22, 8]
	lsr	w2, w1, 3
	ubfiz	x1, x1, 1, 16
	add	x1, x1, 48
	add	w2, w2, 4
	and	x1, x1, -4
	add	x1, x0, x1
	adrp	x0, .LANCHOR1
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	bl	ftl_memcpy
	ldr	w1, [x19, #:lo12:.LANCHOR39]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1609
	add	x20, x20, :lo12:.LANCHOR79
	adrp	x0, .LANCHOR10
	ldrh	w1, [x21, 8]
	ldrb	w2, [x21, 10]
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	strh	w1, [x20, 6]
	cmp	w2, w0
	bne	.L1609
	adrp	x0, .LANCHOR181
	adrp	x2, .LANCHOR61
	adrp	x3, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR181]
	adrp	x0, .LANCHOR19
	ldrh	w3, [x3, #:lo12:.LANCHOR3]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR61]
	adrp	x2, .LANCHOR12
	ldrh	w2, [x2, #:lo12:.LANCHOR12]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR34
	str	w0, [x2, #:lo12:.LANCHOR34]
	adrp	x0, .LANCHOR7
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LANCHOR37+6
	ldrh	w0, [x0, #:lo12:.LANCHOR37+6]
	cmp	w1, w2
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR78
	strh	w0, [x3, #:lo12:.LANCHOR78]
	bls	.L1610
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1461
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1610:
	add	x1, x19, :lo12:.LANCHOR39
	adrp	x0, .LANCHOR51
	add	x3, x0, :lo12:.LANCHOR51
	adrp	x20, .LANCHOR80
	ldrh	w2, [x1, 16]
	ldrh	w6, [x1, 14]
	strh	w6, [x0, #:lo12:.LANCHOR51]
	lsr	w4, w2, 6
	and	w2, w2, 63
	strb	w2, [x3, 6]
	ldrb	w2, [x1, 11]
	strb	w2, [x3, 8]
	add	x2, x20, :lo12:.LANCHOR80
	strh	w4, [x3, 2]
	mov	w3, -1
	strh	w3, [x20, #:lo12:.LANCHOR80]
	strh	wzr, [x2, 2]
	strb	wzr, [x2, 6]
	strb	wzr, [x2, 8]
	adrp	x2, .LANCHOR52
	ldrh	w3, [x1, 18]
	add	x4, x2, :lo12:.LANCHOR52
	strh	w3, [x2, #:lo12:.LANCHOR52]
	mov	x21, x2
	ldrh	w3, [x1, 20]
	lsr	w5, w3, 6
	and	w3, w3, 63
	strb	w3, [x4, 6]
	ldrb	w3, [x1, 12]
	strh	w5, [x4, 2]
	strb	w3, [x4, 8]
	adrp	x4, .LANCHOR53
	ldrh	w3, [x1, 22]
	add	x5, x4, :lo12:.LANCHOR53
	strh	w3, [x4, #:lo12:.LANCHOR53]
	mov	x22, x4
	ldrh	w3, [x1, 24]
	lsr	w7, w3, 6
	and	w3, w3, 63
	strb	w3, [x5, 6]
	ldrb	w3, [x1, 13]
	strb	w3, [x5, 8]
	adrp	x3, .LANCHOR67
	strh	w7, [x5, 2]
	ldr	w5, [x1, 32]
	str	wzr, [x3, #:lo12:.LANCHOR67]
	adrp	x3, .LANCHOR64
	str	wzr, [x3, #:lo12:.LANCHOR64]
	adrp	x3, .LANCHOR62
	str	wzr, [x3, #:lo12:.LANCHOR62]
	adrp	x3, .LANCHOR66
	str	wzr, [x3, #:lo12:.LANCHOR66]
	adrp	x3, .LANCHOR72
	str	w5, [x3, #:lo12:.LANCHOR72]
	adrp	x3, .LANCHOR73
	str	wzr, [x3, #:lo12:.LANCHOR73]
	adrp	x3, .LANCHOR76
	str	wzr, [x3, #:lo12:.LANCHOR76]
	adrp	x3, .LANCHOR65
	str	wzr, [x3, #:lo12:.LANCHOR65]
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR70
	ldr	w5, [x1, #:lo12:.LANCHOR70]
	cmp	w3, w5
	bls	.L1611
	str	w3, [x1, #:lo12:.LANCHOR70]
.L1611:
	add	x19, x19, :lo12:.LANCHOR39
	adrp	x1, .LANCHOR71
	ldr	w3, [x1, #:lo12:.LANCHOR71]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L1612
	str	w2, [x1, #:lo12:.LANCHOR71]
.L1612:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L1613
	add	x0, x0, :lo12:.LANCHOR51
	bl	make_superblock
.L1613:
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR52
	cmp	w2, w1
	beq	.L1614
	bl	make_superblock
.L1614:
	ldrh	w2, [x22, #:lo12:.LANCHOR53]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR53
	cmp	w2, w1
	beq	.L1615
	bl	make_superblock
.L1615:
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR80
	cmp	w2, w1
	beq	.L1616
	bl	make_superblock
.L1616:
	mov	w0, 0
	b	.L1600
.L1606:
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x21, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x0, [x21, 8]
	mov	x0, x21
	bl	FlashReadPages
	ldr	w0, [x21]
	cmn	w0, #1
	beq	.L1604
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1604
	ldr	x0, [x26, #:lo12:.LANCHOR108]
	ldrh	w0, [x0]
	cmp	w0, w28
	beq	.L1605
.L1604:
	sub	w22, w22, #1
	sxth	w22, w22
	b	.L1603
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlSysBlkInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkInit
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR4
	add	x29, sp, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR161
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	strh	wzr, [x20, #:lo12:.LANCHOR161]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR79
	ldrh	w1, [x0, #:lo12:.LANCHOR79]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1623
.L1625:
	mov	w23, -1
.L1622:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1623:
	bl	FtlLoadSysInfo
	mov	w23, w0
	cbnz	w0, .L1625
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	mov	w0, 1
	bl	FtlUpdateVaildLpn
	adrp	x0, .LANCHOR33
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR55
	ldr	x1, [x0, #:lo12:.LANCHOR55]
	mov	w0, 0
	add	x1, x1, 4
.L1626:
	cmp	w0, w2
	bge	.L1631
	ldr	w3, [x1], 16
	tbz	w3, #31, .L1627
.L1631:
	adrp	x19, .LANCHOR39
	add	x3, x19, :lo12:.LANCHOR39
	cmp	w0, w2
	adrp	x22, .LANCHOR51
	ldrh	w1, [x3, 28]
	add	w1, w1, 1
	strh	w1, [x3, 28]
	bge	.L1635
.L1628:
	add	x21, x22, :lo12:.LANCHOR51
	adrp	x24, .LANCHOR52
	mov	x0, x21
	add	x20, x24, :lo12:.LANCHOR52
	bl	FtlSuperblockPowerLostFix
	mov	x0, x20
	bl	FtlSuperblockPowerLostFix
	adrp	x0, .LANCHOR42
	ldrh	w3, [x21, 4]
	ldr	x1, [x0, #:lo12:.LANCHOR42]
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w3
	adrp	x3, .LANCHOR19
	strh	w2, [x1, x0]
	strb	wzr, [x21, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x21, 2]
	ldrh	w0, [x24, #:lo12:.LANCHOR52]
	strh	wzr, [x21, 4]
	ldrh	w4, [x20, 4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w4
	strh	w2, [x1, x0]
	strb	wzr, [x20, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x20, 2]
	strh	wzr, [x20, 4]
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	bl	FtlMapBlkWriteDump_data
	add	x1, x19, :lo12:.LANCHOR39
	ldrh	w0, [x1, 30]
	add	w0, w0, 1
	strh	w0, [x1, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1637:
	bl	FtlVpcTblFlush
	add	x21, x22, :lo12:.LANCHOR51
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L1634
	ldrh	w1, [x21, 4]
	cbnz	w1, .L1634
	adrp	x22, .LANCHOR52
	add	x20, x22, :lo12:.LANCHOR52
	ldrh	w1, [x20, 4]
	cbnz	w1, .L1634
	bl	FtlGcRefreshBlock
	ldrh	w0, [x22, #:lo12:.LANCHOR52]
	bl	FtlGcRefreshBlock
	mov	x0, x21
	bl	allocate_new_data_superblock
	mov	x0, x20
	bl	allocate_new_data_superblock
.L1634:
	add	x19, x19, :lo12:.LANCHOR39
	ldrh	w0, [x19, 28]
	tst	x0, 31
	bne	.L1622
	bl	FtlVpcCheckAndModify
	b	.L1622
.L1627:
	add	w0, w0, 1
	b	.L1626
.L1635:
	ldrh	w0, [x20, #:lo12:.LANCHOR161]
	cbnz	w0, .L1628
	bl	l2p_flush
	b	.L1637
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR71
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR4
	str	wzr, [x0, #:lo12:.LANCHOR71]
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR70
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	str	wzr, [x20, #:lo12:.LANCHOR70]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L1639
	bl	FtlMakeBbt
.L1639:
	adrp	x23, .LANCHOR12
	adrp	x0, .LANCHOR115
	mov	w6, 23752
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR113
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR113]
	mov	w0, 0
.L1640:
	cmp	w0, w1
	blt	.L1641
	adrp	x21, .LANCHOR5
	adrp	x22, .LANCHOR6
	add	x26, x22, :lo12:.LANCHOR6
	mov	w19, 0
	ldrh	w25, [x21, #:lo12:.LANCHOR5]
.L1642:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L1643
	adrp	x25, .LANCHOR3
	sub	w1, w19, #2
	ldrh	w0, [x25, #:lo12:.LANCHOR3]
	cmp	w1, w0, lsl 1
	bgt	.L1644
.L1648:
	add	x26, x21, :lo12:.LANCHOR5
	mov	w19, 0
	mov	w24, 0
.L1645:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L1649
	adrp	x0, .LANCHOR112
	ldrh	w1, [x22, #:lo12:.LANCHOR6]
	ldrh	w4, [x25, #:lo12:.LANCHOR3]
	adrp	x2, .LANCHOR78
	str	w1, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR7
	adrp	x3, .LANCHOR61
	ldr	w1, [x0, #:lo12:.LANCHOR7]
	udiv	w5, w1, w4
	ubfx	x0, x5, 5, 16
	str	w5, [x3, #:lo12:.LANCHOR61]
	add	w6, w0, 36
	strh	w6, [x2, #:lo12:.LANCHOR78]
	mov	w6, 24
	mul	w6, w4, w6
	cmp	w19, w6
	ble	.L1650
	sub	w1, w1, w19
	udiv	w1, w1, w4
	str	w1, [x3, #:lo12:.LANCHOR61]
	lsr	w1, w1, 5
	add	w1, w1, 24
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1650:
	adrp	x1, .LANCHOR15
	ldrh	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1652
	ldrh	w6, [x2, #:lo12:.LANCHOR78]
	add	w6, w6, w1, lsr 1
	strh	w6, [x2, #:lo12:.LANCHOR78]
	mul	w6, w1, w4
	cmp	w19, w6
	bge	.L1652
	add	w1, w1, 32
	str	w5, [x3, #:lo12:.LANCHOR61]
	add	w1, w0, w1
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1652:
	ldrh	w1, [x2, #:lo12:.LANCHOR78]
	adrp	x25, .LANCHOR181
	ldr	w0, [x3, #:lo12:.LANCHOR61]
	adrp	x24, .LANCHOR42
	sub	w0, w0, w1
	adrp	x1, .LANCHOR19
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w4
	str	w0, [x25, #:lo12:.LANCHOR181]
	mul	w0, w1, w0
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	str	w0, [x3, #:lo12:.LANCHOR61]
	mov	w23, -1
	mul	w0, w1, w0
	adrp	x1, .LANCHOR34
	str	w0, [x1, #:lo12:.LANCHOR34]
	bl	FtlBbmTblFlush
	ldr	x0, [x24, #:lo12:.LANCHOR42]
	mov	w1, 0
	ldrh	w2, [x22, #:lo12:.LANCHOR6]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR59
	adrp	x1, .LANCHOR80
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	str	wzr, [x0, #:lo12:.LANCHOR59]
	add	x0, x1, :lo12:.LANCHOR80
	strh	w23, [x1, #:lo12:.LANCHOR80]
	mov	w1, 255
	lsr	w2, w2, 3
	strh	wzr, [x0, 2]
	strb	wzr, [x0, 6]
	strb	wzr, [x0, 8]
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	strh	wzr, [x0, #:lo12:.LANCHOR51]
	mov	w0, 1
	strb	w0, [x19, 8]
	adrp	x0, .LANCHOR1
	strh	wzr, [x19, 2]
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	strb	wzr, [x19, 6]
	bl	ftl_memset
.L1654:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1655
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1654
.L1641:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L1640
.L1643:
	mov	w0, w25
	mov	w1, 1
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w25, w25, 65535
	and	w19, w19, 65535
	b	.L1642
.L1644:
	udiv	w0, w19, w0
	adrp	x1, .LANCHOR31
	ldr	w19, [x1, #:lo12:.LANCHOR31]
	add	w0, w0, w19
	bl	FtlSysBlkNumInit
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	add	x24, x22, :lo12:.LANCHOR6
	bl	FtlFreeSysBlkQueueInit
	ldrh	w19, [x21, #:lo12:.LANCHOR5]
.L1646:
	ldrh	w0, [x24]
	cmp	w0, w19
	bls	.L1648
	mov	w0, w19
	add	w19, w19, 1
	mov	w1, 1
	and	w19, w19, 65535
	bl	FtlLowFormatEraseBlock
	b	.L1646
.L1649:
	mov	w0, w24
	mov	w1, 0
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w24, w24, 65535
	and	w19, w19, 65535
	b	.L1645
.L1655:
	ldr	w1, [x20, #:lo12:.LANCHOR70]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	mov	w23, -1
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR70]
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	adrp	x2, .LANCHOR52
	add	x0, x2, :lo12:.LANCHOR52
	ldrh	w1, [x19]
	mov	x19, x0
	add	w1, w1, 1
	strh	wzr, [x0, 2]
	strh	w1, [x2, #:lo12:.LANCHOR52]
	mov	w1, 1
	strb	wzr, [x0, 6]
	strb	w1, [x0, 8]
.L1656:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1657
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1656
.L1657:
	ldr	w1, [x20, #:lo12:.LANCHOR70]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR70]
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ldrh	w2, [x19, 4]
	mov	w19, -1
	strh	w2, [x1, x0]
	adrp	x0, .LANCHOR53
	strh	w19, [x0, #:lo12:.LANCHOR53]
	bl	FtlFreeSysBlkQueueOut
	adrp	x2, .LANCHOR79
	add	x1, x2, :lo12:.LANCHOR79
	strh	w0, [x2, #:lo12:.LANCHOR79]
	ldr	w0, [x25, #:lo12:.LANCHOR181]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR70]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR70]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L1658
	adrp	x0, .LANCHOR86
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR86]
.L1658:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.sftl_init,"ax",@progbits
	.align	2
	.global	sftl_init
	.type	sftl_init, %function
sftl_init:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LC70
	add	x1, x1, :lo12:.LC70
	mov	w0, -1
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR86
	str	w0, [x19, #:lo12:.LANCHOR86]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	adrp	x0, .LANCHOR4
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbnz	w0, .L1667
	bl	FtlSysBlkInit
	cbnz	w0, .L1667
	mov	w0, 1
	str	w0, [x19, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 15
	bhi	.L1667
	mov	w19, 8129
.L1666:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L1666
.L1667:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	sftl_init, .-sftl_init
	.section	.text.ftl_memcmp,"ax",@progbits
	.align	2
	.global	ftl_memcmp
	.type	ftl_memcmp, %function
ftl_memcmp:
	uxtw	x2, w2
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
	.section	.bss.DeviceCapacity,"aw",@nobits
	.align	2
	.set	.LANCHOR26,. + 0
	.type	DeviceCapacity, %object
	.size	DeviceCapacity, 4
DeviceCapacity:
	.zero	4
	.section	.bss.FtlUpdateVaildLpnCount,"aw",@nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.zero	2
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",@nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.zero	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR6,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR17,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR18,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",@nobits
	.align	1
	.set	.LANCHOR24,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR23,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR5,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR78,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_die_num,"aw",@nobits
	.align	1
	.set	.LANCHOR10,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.zero	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR15,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR31,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR33,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR29,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR32,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR7,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR4,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR27,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR19,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR20,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR21,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.zero	2
	.section	.bss.c_ftl_nand_planes_num,"aw",@nobits
	.align	1
	.set	.LANCHOR3,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.zero	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR11,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR25,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR12,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR22,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.zero	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR2,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR8,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.zero	4
	.section	.bss.c_ftl_nand_type,"aw",@nobits
	.align	1
	.set	.LANCHOR9,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.zero	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR28,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.zero	2
	.section	.bss.c_ftl_vendor_part_size,"aw",@nobits
	.align	1
	.set	.LANCHOR16,. + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.zero	2
	.section	.bss.c_gc_page_buf_num,"aw",@nobits
	.align	2
	.set	.LANCHOR94,. + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.zero	4
	.section	.bss.c_mlc_erase_count_value,"aw",@nobits
	.align	1
	.set	.LANCHOR14,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.zero	2
	.section	.bss.check_buf,"aw",@nobits
	.align	3
	.type	check_buf, %object
	.size	check_buf, 4096
check_buf:
	.zero	4096
	.section	.bss.check_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR110,. + 0
	.type	check_spare_buf, %object
	.size	check_spare_buf, 512
check_spare_buf:
	.zero	512
	.section	.bss.check_vpc_table,"aw",@nobits
	.align	3
	.type	check_vpc_table, %object
	.size	check_vpc_table, 16384
check_vpc_table:
	.zero	16384
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",@nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.zero	4
	.section	.bss.ftl_temp_buf,"aw",@nobits
	.align	3
	.type	ftl_temp_buf, %object
	.size	ftl_temp_buf, 4096
ftl_temp_buf:
	.zero	4096
	.section	.bss.gBbtInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR37,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 96
gBbtInfo:
	.zero	96
	.section	.bss.gL2pMapInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR144,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 64
gL2pMapInfo:
	.zero	64
	.section	.bss.gSysFreeQueue,"aw",@nobits
	.align	3
	.set	.LANCHOR38,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.zero	2056
	.section	.bss.gSysInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR79,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.zero	12
	.section	.bss.gVendorBlkInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 64
gVendorBlkInfo:
	.zero	64
	.section	.bss.g_GlobalDataVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.zero	4
	.section	.bss.g_GlobalSysVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR70,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.zero	4
	.section	.bss.g_MaxLbaSector,"aw",@nobits
	.align	2
	.set	.LANCHOR34,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.zero	4
	.section	.bss.g_MaxLbn,"aw",@nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.zero	4
	.section	.bss.g_VaildLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR59,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.zero	4
	.section	.bss.g_active_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR51,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.zero	48
	.section	.bss.g_buffer_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR52,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.zero	48
	.section	.bss.g_cur_erase_blk,"aw",@nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.zero	4
	.section	.bss.g_ect_tbl_info_size,"aw",@nobits
	.align	1
	.set	.LANCHOR125,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.zero	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",@nobits
	.align	1
	.set	.LANCHOR165,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.zero	2
	.section	.bss.g_ftl_nand_free_count,"aw",@nobits
	.align	2
	.set	.LANCHOR176,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.zero	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",@nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR102,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_blk_index,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.zero	2
	.section	.bss.g_gc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.zero	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR174,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR173,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.zero	2
	.section	.bss.g_gc_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR82,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_head_data_block,"aw",@nobits
	.align	2
	.set	.LANCHOR118,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.zero	4
	.section	.bss.g_gc_head_data_block_count,"aw",@nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.zero	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_next_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.zero	2
	.section	.bss.g_gc_next_blk_1,"aw",@nobits
	.align	1
	.set	.LANCHOR100,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.zero	2
	.section	.bss.g_gc_num_req,"aw",@nobits
	.align	2
	.set	.LANCHOR89,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.zero	4
	.section	.bss.g_gc_page_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.zero	2
	.section	.bss.g_gc_skip_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR84,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.zero	4
	.section	.bss.g_gc_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR80,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.zero	48
	.section	.bss.g_gc_temp_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR53,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.zero	48
	.section	.bss.g_in_gc_progress,"aw",@nobits
	.align	2
	.set	.LANCHOR117,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.zero	4
	.section	.bss.g_in_swl_replace,"aw",@nobits
	.align	2
	.set	.LANCHOR87,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.zero	4
	.section	.bss.g_l2p_last_update_region_id,"aw",@nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.zero	2
	.section	.bss.g_max_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR76,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.zero	4
	.section	.bss.g_min_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.zero	4
	.section	.bss.g_nand_ops,"aw",@nobits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	g_nand_ops, %object
	.size	g_nand_ops, 32
g_nand_ops:
	.zero	32
	.section	.bss.g_nand_phy_info,"aw",@nobits
	.align	3
	.set	.LANCHOR0,. + 0
	.type	g_nand_phy_info, %object
	.size	g_nand_phy_info, 24
g_nand_phy_info:
	.zero	24
	.section	.bss.g_num_data_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR45,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.zero	2
	.section	.bss.g_num_free_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.zero	2
	.section	.bss.g_power_lost_recovery_flag,"aw",@nobits
	.align	1
	.set	.LANCHOR161,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR153,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR163,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.zero	128
	.section	.bss.g_sys_ext_data,"aw",@nobits
	.align	3
	.set	.LANCHOR81,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.zero	512
	.section	.bss.g_sys_save_data,"aw",@nobits
	.align	3
	.set	.LANCHOR39,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.zero	48
	.section	.bss.g_tmp_data_superblock_id,"aw",@nobits
	.align	1
	.set	.LANCHOR150,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.zero	2
	.section	.bss.g_totle_avg_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.zero	4
	.section	.bss.g_totle_cache_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.zero	4
	.section	.bss.g_totle_discard_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.zero	4
	.section	.bss.g_totle_gc_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR67,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.zero	4
	.section	.bss.g_totle_l2p_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR66,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.zero	4
	.section	.bss.g_totle_map_block,"aw",@nobits
	.align	1
	.set	.LANCHOR147,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.zero	2
	.section	.bss.g_totle_mlc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR72,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.zero	4
	.section	.bss.g_totle_read_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR62,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.zero	4
	.section	.bss.g_totle_read_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR69,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.zero	4
	.section	.bss.g_totle_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR73,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_swl_count,"aw",@nobits
	.align	2
	.set	.LANCHOR151,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.zero	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR75,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_vendor_block,"aw",@nobits
	.align	1
	.set	.LANCHOR35,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.zero	2
	.section	.bss.g_totle_write_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.zero	4
	.section	.bss.g_totle_write_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.zero	4
	.section	.bss.gc_discard_updated,"aw",@nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.zero	4
	.section	.bss.gc_ink_free_return_value,"aw",@nobits
	.align	1
	.set	.LANCHOR172,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.zero	2
	.section	.bss.gp_ect_tbl_info,"aw",@nobits
	.align	3
	.set	.LANCHOR127,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 8
gp_ect_tbl_info:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 262144
gp_flash_check_buf:
	.zero	262144
	.section	.bss.gp_gc_page_buf_info,"aw",@nobits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 8
gp_last_act_superblock:
	.zero	8
	.section	.bss.idb_buf,"aw",@nobits
	.align	3
	.type	idb_buf, %object
	.size	idb_buf, 262144
idb_buf:
	.zero	262144
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR179,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.p_blk_mode_table,"aw",@nobits
	.align	3
	.set	.LANCHOR1,. + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 8
p_blk_mode_table:
	.zero	8
	.section	.bss.p_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR41,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 8
p_data_block_list_head:
	.zero	8
	.section	.bss.p_data_block_list_table,"aw",@nobits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 8
p_data_block_list_table:
	.zero	8
	.section	.bss.p_data_block_list_tail,"aw",@nobits
	.align	3
	.set	.LANCHOR44,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 8
p_data_block_list_tail:
	.zero	8
	.section	.bss.p_erase_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR43,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 8
p_erase_count_table:
	.zero	8
	.section	.bss.p_free_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR47,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 8
p_free_data_block_list_head:
	.zero	8
	.section	.bss.p_gc_blk_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR96,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 8
p_gc_blk_tbl:
	.zero	8
	.section	.bss.p_gc_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR91,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 8
p_gc_data_buf:
	.zero	8
	.section	.bss.p_gc_page_info,"aw",@nobits
	.align	3
	.set	.LANCHOR98,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 8
p_gc_page_info:
	.zero	8
	.section	.bss.p_gc_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR92,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 8
p_gc_spare_buf:
	.zero	8
	.section	.bss.p_io_data_buf_0,"aw",@nobits
	.align	3
	.set	.LANCHOR115,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 8
p_io_data_buf_1:
	.zero	8
	.section	.bss.p_io_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 8
p_io_spare_buf:
	.zero	8
	.section	.bss.p_l2p_map_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 8
p_l2p_map_buf:
	.zero	8
	.section	.bss.p_l2p_ram_map,"aw",@nobits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 8
p_l2p_ram_map:
	.zero	8
	.section	.bss.p_map_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR129,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 8
p_map_block_table:
	.zero	8
	.section	.bss.p_map_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR130,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 8
p_map_block_valid_page_count:
	.zero	8
	.section	.bss.p_map_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 8
p_map_block_ver_table:
	.zero	8
	.section	.bss.p_map_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 8
p_map_region_ppn_table:
	.zero	8
	.section	.bss.p_plane_order_table,"aw",@nobits
	.align	3
	.set	.LANCHOR13,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.zero	32
	.section	.bss.p_swl_mul_table,"aw",@nobits
	.align	3
	.set	.LANCHOR126,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 8
p_swl_mul_table:
	.zero	8
	.section	.bss.p_sys_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 8
p_sys_data_buf:
	.zero	8
	.section	.bss.p_sys_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR123,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 8
p_sys_data_buf_1:
	.zero	8
	.section	.bss.p_sys_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 8
p_sys_spare_buf:
	.zero	8
	.section	.bss.p_valid_page_count_check_table,"aw",@nobits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	p_valid_page_count_check_table, %object
	.size	p_valid_page_count_check_table, 8
p_valid_page_count_check_table:
	.zero	8
	.section	.bss.p_valid_page_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR42,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 8
p_valid_page_count_table:
	.zero	8
	.section	.bss.p_vendor_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR36,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 8
p_vendor_block_table:
	.zero	8
	.section	.bss.p_vendor_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR131,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 8
p_vendor_block_valid_page_count:
	.zero	8
	.section	.bss.p_vendor_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR132,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 8
p_vendor_block_ver_table:
	.zero	8
	.section	.bss.p_vendor_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 8
p_vendor_data_buf:
	.zero	8
	.section	.bss.p_vendor_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR133,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 8
p_vendor_region_ppn_table:
	.zero	8
	.section	.bss.req_erase,"aw",@nobits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	req_erase, %object
	.size	req_erase, 8
req_erase:
	.zero	8
	.section	.bss.req_gc,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
	.type	req_gc, %object
	.size	req_gc, 8
req_gc:
	.zero	8
	.section	.bss.req_gc_dst,"aw",@nobits
	.align	3
	.set	.LANCHOR121,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 8
req_gc_dst:
	.zero	8
	.section	.bss.req_prgm,"aw",@nobits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 8
req_prgm:
	.zero	8
	.section	.bss.req_read,"aw",@nobits
	.align	3
	.set	.LANCHOR120,. + 0
	.type	req_read, %object
	.size	req_read, 8
req_read:
	.zero	8
	.section	.bss.req_sys,"aw",@nobits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	req_sys, %object
	.size	req_sys, 32
req_sys:
	.zero	32
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",@progbits
	.align	1
	.set	.LANCHOR156,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR86,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.power_up_flag,"aw",@progbits
	.align	2
	.set	.LANCHOR177,. + 0
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashProgPages.str1.1,"aMS",@progbits,1
.LC79:
	.string	"prog read error: = %x\n"
.LC80:
	.string	"prog read s error: = %x %x %x\n"
.LC81:
	.string	"prog read d error: = %x %x %x\n"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",@progbits,1
.LC0:
	.string	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\n"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",@progbits,1
.LC97:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC98:
	.string	"FtlBbmTblFlush error:%x\n"
.LC99:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC82:
	.string	"FtlFreeSysBlkQueueOut free count = %d\n"
.LC83:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcFreeBadSuperBlk.str1.1,"aMS",@progbits,1
.LC100:
	.string	"FtlGcFreeBadSuperBlk 0x%x\n"
	.section	.rodata.FtlGcMarkBadPhyBlk.str1.1,"aMS",@progbits,1
.LC74:
	.string	"FtlGcMarkBadPhyBlk %d 0x%x\n"
	.section	.rodata.FtlGcRefreshBlock.str1.1,"aMS",@progbits,1
.LC73:
	.string	"FtlGcRefreshBlock  0x%x\n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC103:
	.string	"no ect"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC89:
	.string	"FtlMapWritePage error = %x \n"
.LC90:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlMemInit.str1.1,"aMS",@progbits,1
.LC85:
	.string	"%s error allocating memory. return -1\n"
	.section	.rodata.FtlPrintInfo2buf.str1.1,"aMS",@progbits,1
.LC2:
	.string	"FLASH INFO:\n"
.LC3:
	.string	"Device Capacity: %d MB\n"
.LC4:
	.string	"FTL INFO:\n"
.LC5:
	.string	"g_MaxLpn = 0x%x\n"
.LC6:
	.string	"g_VaildLpn = 0x%x\n"
.LC7:
	.string	"read_page_count = 0x%x\n"
.LC8:
	.string	"discard_page_count = 0x%x\n"
.LC9:
	.string	"write_page_count = 0x%x\n"
.LC10:
	.string	"cache_write_count = 0x%x\n"
.LC11:
	.string	"l2p_write_count = 0x%x\n"
.LC12:
	.string	"gc_page_count = 0x%x\n"
.LC13:
	.string	"totle_write = %d MB\n"
.LC14:
	.string	"totle_read = %d MB\n"
.LC15:
	.string	"GSV = 0x%x\n"
.LC16:
	.string	"GDV = 0x%x\n"
.LC17:
	.string	"bad blk num = %d\n"
.LC18:
	.string	"free_superblocks = 0x%x\n"
.LC19:
	.string	"mlc_EC = 0x%x\n"
.LC20:
	.string	"slc_EC = 0x%x\n"
.LC21:
	.string	"avg_EC = 0x%x\n"
.LC22:
	.string	"sys_EC = 0x%x\n"
.LC23:
	.string	"max_EC = 0x%x\n"
.LC24:
	.string	"min_EC = 0x%x\n"
.LC25:
	.string	"PLT = 0x%x\n"
.LC26:
	.string	"POT = 0x%x\n"
.LC27:
	.string	"MaxSector = 0x%x\n"
.LC28:
	.string	"init_sys_blks_pp = 0x%x\n"
.LC29:
	.string	"sys_blks_pp = 0x%x\n"
.LC30:
	.string	"free sysblock = 0x%x\n"
.LC31:
	.string	"data_blks_pp = 0x%x\n"
.LC32:
	.string	"data_op_blks_pp = 0x%x\n"
.LC33:
	.string	"max_data_blks = 0x%x\n"
.LC34:
	.string	"Sys.id = 0x%x\n"
.LC35:
	.string	"Bbt.id = 0x%x\n"
.LC36:
	.string	"ACT.page = 0x%x\n"
.LC37:
	.string	"ACT.plane = 0x%x\n"
.LC38:
	.string	"ACT.id = 0x%x\n"
.LC39:
	.string	"ACT.mode = 0x%x\n"
.LC40:
	.string	"ACT.a_pages = 0x%x\n"
.LC41:
	.string	"ACT VPC = 0x%x\n"
.LC42:
	.string	"BUF.page = 0x%x\n"
.LC43:
	.string	"BUF.plane = 0x%x\n"
.LC44:
	.string	"BUF.id = 0x%x\n"
.LC45:
	.string	"BUF.mode = 0x%x\n"
.LC46:
	.string	"BUF.a_pages = 0x%x\n"
.LC47:
	.string	"BUF VPC = 0x%x\n"
.LC48:
	.string	"TMP.page = 0x%x\n"
.LC49:
	.string	"TMP.plane = 0x%x\n"
.LC50:
	.string	"TMP.id = 0x%x\n"
.LC51:
	.string	"TMP.mode = 0x%x\n"
.LC52:
	.string	"TMP.a_pages = 0x%x\n"
.LC53:
	.string	"GC.page = 0x%x\n"
.LC54:
	.string	"GC.plane = 0x%x\n"
.LC55:
	.string	"GC.id = 0x%x\n"
.LC56:
	.string	"GC.mode = 0x%x\n"
.LC57:
	.string	"GC.a_pages = 0x%x\n"
.LC58:
	.string	"WR_CHK = %x %x %x\n"
.LC59:
	.string	"Read Err Cnt = 0x%x\n"
.LC60:
	.string	"Prog Err Cnt = 0x%x\n"
.LC61:
	.string	"gc_free_blk_th= 0x%x\n"
.LC62:
	.string	"gc_merge_free_blk_th= 0x%x\n"
.LC63:
	.string	"gc_skip_write_count= 0x%x\n"
.LC64:
	.string	"gc_blk_index= 0x%x\n"
.LC65:
	.string	"free min EC= 0x%x\n"
.LC66:
	.string	"free max EC= 0x%x\n"
.LC67:
	.string	"GC__SB VPC = 0x%x\n"
.LC68:
	.string	"%d. [0x%x]=0x%x 0x%x  0x%x\n"
.LC69:
	.string	"free %d. [0x%x] 0x%x  0x%x\n"
	.section	.rodata.FtlProgPages.str1.1,"aMS",@progbits,1
.LC106:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC102:
	.string	"spuer block %x vpn is 0\n "
	.section	.rodata.FtlVpcCheckAndModify.str1.1,"aMS",@progbits,1
.LC105:
	.string	"FtlCheckVpc %x = %x  %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC104:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC108:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.GetSwlReplaceBlock.str1.1,"aMS",@progbits,1
.LC72:
	.string	"swblk %x ,avg = %x max= %x vpc= %x,ec=%x ,max ec=%x\n"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC1:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.__func__.6109,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.6109, %object
	.size	__func__.6109, 11
__func__.6109:
	.string	"FtlMemInit"
	.section	.rodata.__func__.6233,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.6233, %object
	.size	__func__.6233, 13
__func__.6233:
	.string	"FtlProgPages"
	.section	.rodata.__func__.6261,"a",@progbits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	__func__.6261, %object
	.size	__func__.6261, 9
__func__.6261:
	.string	"FtlWrite"
	.section	.rodata.__func__.6407,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.6407, %object
	.size	__func__.6407, 14
__func__.6407:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.6450,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.6450, %object
	.size	__func__.6450, 11
__func__.6450:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.6567,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.6567, %object
	.size	__func__.6567, 17
__func__.6567:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.6572,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.6572, %object
	.size	__func__.6572, 17
__func__.6572:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.6603,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.6603, %object
	.size	__func__.6603, 17
__func__.6603:
	.string	"List_remove_node"
	.section	.rodata.__func__.6635,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.6635, %object
	.size	__func__.6635, 22
__func__.6635:
	.string	"List_update_data_list"
	.section	.rodata.__func__.6644,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.6644, %object
	.size	__func__.6644, 16
__func__.6644:
	.string	"load_l2p_region"
	.section	.rodata.__func__.6677,"a",@progbits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	__func__.6677, %object
	.size	__func__.6677, 26
__func__.6677:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.6688,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.6688, %object
	.size	__func__.6688, 15
__func__.6688:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.6702,"a",@progbits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	__func__.6702, %object
	.size	__func__.6702, 31
__func__.6702:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.6716,"a",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	__func__.6716, %object
	.size	__func__.6716, 16
__func__.6716:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.6741,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.6741, %object
	.size	__func__.6741, 22
__func__.6741:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.6758,"a",@progbits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	__func__.6758, %object
	.size	__func__.6758, 9
__func__.6758:
	.string	"log2phys"
	.section	.rodata.__func__.6831,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.6831, %object
	.size	__func__.6831, 15
__func__.6831:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.6853,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.6853, %object
	.size	__func__.6853, 14
__func__.6853:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.6910,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.6910, %object
	.size	__func__.6910, 15
__func__.6910:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.6973,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.6973, %object
	.size	__func__.6973, 16
__func__.6973:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.7007,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.7007, %object
	.size	__func__.7007, 22
__func__.7007:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.7064,"a",@progbits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	__func__.7064, %object
	.size	__func__.7064, 16
__func__.7064:
	.string	"make_superblock"
	.section	.rodata.__func__.7085,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.7085, %object
	.size	__func__.7085, 18
__func__.7085:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.7110,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.7110, %object
	.size	__func__.7110, 21
__func__.7110:
	.string	"FtlVpcCheckAndModify"
	.section	.rodata.__func__.7126,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.7126, %object
	.size	__func__.7126, 14
__func__.7126:
	.string	"ftl_check_vpc"
	.section	.rodata.__func__.7211,"a",@progbits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	__func__.7211, %object
	.size	__func__.7211, 25
__func__.7211:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.7232,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.7232, %object
	.size	__func__.7232, 29
__func__.7232:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.7239,"a",@progbits
	.align	3
	.set	.LANCHOR88,. + 0
	.type	__func__.7239, %object
	.size	__func__.7239, 19
__func__.7239:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.7252,"a",@progbits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	__func__.7252, %object
	.size	__func__.7252, 16
__func__.7252:
	.string	"update_vpc_list"
	.section	.rodata.__func__.7259,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.7259, %object
	.size	__func__.7259, 20
__func__.7259:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.7329,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.7329, %object
	.size	__func__.7329, 19
__func__.7329:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.7435,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.7435, %object
	.size	__func__.7435, 23
__func__.7435:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.7702,"a",@progbits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	__func__.7702, %object
	.size	__func__.7702, 15
__func__.7702:
	.string	"FlashReadPages"
	.section	.rodata.__func__.7719,"a",@progbits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	__func__.7719, %object
	.size	__func__.7719, 15
__func__.7719:
	.string	"FlashProgPages"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC101:
	.string	"decrement_vpc_count %x = %d\n"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",@progbits,1
.LC94:
	.string	"...%s enter...\n"
.LC95:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC96:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC84:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC91:
	.string	"ftl_scan_all_data = %x\n"
.LC92:
	.string	"scan lpa = %x ppa= %x\n"
.LC93:
	.string	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC86:
	.string	"region_id = %x phyAddr = %x\n"
.LC87:
	.string	"spare:"
.LC88:
	.string	"map_ppn:"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",@progbits,1
.LC107:
	.string	"SWL %x, FSB = %x vpc= %x,ec=%x th=%x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC75:
	.string	"%s 0x%x:"
.LC76:
	.string	"%x "
.LC77:
	.string	"%02x "
.LC78:
	.string	"\n"
	.section	.rodata.rknand_proc_ftlread.str1.1,"aMS",@progbits,1
.LC70:
	.string	"SFTL version: 5.0.44 20180713"
.LC71:
	.string	"%s\n"
	.section	.rodata.sftl_write.str1.1,"aMS",@progbits,1
.LC109:
	.string	"write_idblock fail! %x %x %x %x\n"
	.hidden	free
