/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2018-09-30
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
	mov	w2, 214
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
	mov	w2, 207
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
	mov	w2, 372
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
	mov	w2, 463
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
	mov	w2, 474
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
	mov	w2, 787
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
	mov	w2, 2110
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
	strb	wzr, [x19, 9]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
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
	mov	x1, 64
	adrp	x2, .LC2
	add	x2, x2, :lo12:.LC2
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
	bl	snprintf
	add	x20, x21, x0, sxtw
	adrp	x0, .LANCHOR26
	mov	x1, 64
	adrp	x2, .LC3
	ldr	w3, [x0, #:lo12:.LANCHOR26]
	add	x2, x2, :lo12:.LC3
	mov	x0, x20
	add	x22, x22, :lo12:.LANCHOR39
	adrp	x24, .LANCHOR51
	adrp	x25, .LANCHOR81
	add	x25, x25, :lo12:.LANCHOR81
	bl	snprintf
	add	x20, x20, x0, sxtw
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC4
	add	x2, x2, :lo12:.LC4
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR61
	mov	x1, 64
	adrp	x2, .LC5
	add	x2, x2, :lo12:.LC5
	ldr	w3, [x0, #:lo12:.LANCHOR61]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR59
	mov	x1, 64
	adrp	x2, .LC6
	add	x2, x2, :lo12:.LC6
	ldr	w3, [x0, #:lo12:.LANCHOR59]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR62
	mov	x1, 64
	adrp	x2, .LC7
	add	x2, x2, :lo12:.LC7
	ldr	w3, [x0, #:lo12:.LANCHOR62]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR63
	mov	x1, 64
	adrp	x2, .LC8
	add	x2, x2, :lo12:.LC8
	ldr	w3, [x0, #:lo12:.LANCHOR63]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR64
	mov	x1, 64
	adrp	x2, .LC9
	add	x2, x2, :lo12:.LC9
	ldr	w3, [x0, #:lo12:.LANCHOR64]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR65
	mov	x1, 64
	adrp	x2, .LC10
	add	x2, x2, :lo12:.LC10
	ldr	w3, [x0, #:lo12:.LANCHOR65]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR66
	mov	x1, 64
	adrp	x2, .LC11
	add	x2, x2, :lo12:.LC11
	ldr	w3, [x0, #:lo12:.LANCHOR66]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR67
	mov	x1, 64
	adrp	x2, .LC12
	add	x2, x2, :lo12:.LC12
	ldr	w3, [x0, #:lo12:.LANCHOR67]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR68
	mov	x1, 64
	adrp	x2, .LC13
	add	x2, x2, :lo12:.LC13
	ldr	w3, [x0, #:lo12:.LANCHOR68]
	mov	x0, x20
	lsr	w3, w3, 11
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR69
	mov	x1, 64
	adrp	x2, .LC14
	ldr	w3, [x0, #:lo12:.LANCHOR69]
	add	x2, x2, :lo12:.LC14
	mov	x0, x20
	lsr	w3, w3, 11
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR70
	mov	x1, 64
	adrp	x2, .LC15
	ldr	w3, [x0, #:lo12:.LANCHOR70]
	add	x2, x2, :lo12:.LC15
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR71
	mov	x1, 64
	adrp	x2, .LC16
	add	x2, x2, :lo12:.LC16
	ldr	w3, [x0, #:lo12:.LANCHOR71]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	add	x0, x19, :lo12:.LANCHOR37
	mov	x1, 64
	adrp	x2, .LC17
	add	x2, x2, :lo12:.LC17
	ldrh	w3, [x0, 6]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x23, #:lo12:.LANCHOR48]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC18
	add	x2, x2, :lo12:.LC18
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR72
	mov	x1, 64
	adrp	x2, .LC19
	add	x2, x2, :lo12:.LC19
	ldr	w3, [x0, #:lo12:.LANCHOR72]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR73
	mov	x1, 64
	adrp	x2, .LC20
	add	x2, x2, :lo12:.LC20
	ldr	w3, [x0, #:lo12:.LANCHOR73]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR74
	mov	x1, 64
	adrp	x2, .LC21
	add	x2, x2, :lo12:.LC21
	ldr	w3, [x0, #:lo12:.LANCHOR74]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR75
	mov	x1, 64
	adrp	x2, .LC22
	add	x2, x2, :lo12:.LC22
	ldr	w3, [x0, #:lo12:.LANCHOR75]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR76
	mov	x1, 64
	adrp	x2, .LC23
	add	x2, x2, :lo12:.LC23
	ldr	w3, [x0, #:lo12:.LANCHOR76]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR77
	mov	x1, 64
	adrp	x2, .LC24
	add	x2, x2, :lo12:.LC24
	ldr	w3, [x0, #:lo12:.LANCHOR77]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x22, 30]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC25
	add	x2, x2, :lo12:.LC25
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x22, 28]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC26
	add	x2, x2, :lo12:.LC26
	adrp	x22, .LANCHOR42
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR34
	mov	x1, 64
	adrp	x2, .LC27
	add	x2, x2, :lo12:.LC27
	ldr	w3, [x0, #:lo12:.LANCHOR34]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR31
	mov	x1, 64
	adrp	x2, .LC28
	add	x2, x2, :lo12:.LC28
	ldr	w3, [x0, #:lo12:.LANCHOR31]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR2
	mov	x1, 64
	adrp	x2, .LC29
	add	x2, x2, :lo12:.LC29
	ldr	w3, [x0, #:lo12:.LANCHOR2]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR38+6
	mov	x1, 64
	adrp	x2, .LC30
	add	x2, x2, :lo12:.LC30
	ldrh	w3, [x0, #:lo12:.LANCHOR38+6]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR5
	mov	x1, 64
	adrp	x2, .LC31
	add	x2, x2, :lo12:.LC31
	ldrh	w3, [x0, #:lo12:.LANCHOR5]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR78
	mov	x1, 64
	adrp	x2, .LC32
	add	x2, x2, :lo12:.LC32
	ldrh	w3, [x0, #:lo12:.LANCHOR78]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR7
	mov	x1, 64
	adrp	x2, .LC33
	add	x2, x2, :lo12:.LC33
	ldr	w3, [x0, #:lo12:.LANCHOR7]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	adrp	x0, .LANCHOR79
	mov	x1, 64
	adrp	x2, .LC34
	add	x2, x2, :lo12:.LC34
	ldrh	w3, [x0, #:lo12:.LANCHOR79]
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, #:lo12:.LANCHOR37]
	add	x19, x24, :lo12:.LANCHOR51
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC35
	add	x2, x2, :lo12:.LC35
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 2]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC36
	add	x2, x2, :lo12:.LC36
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 6]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC37
	add	x2, x2, :lo12:.LC37
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x24, #:lo12:.LANCHOR51]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC38
	add	x2, x2, :lo12:.LC38
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 8]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC39
	add	x2, x2, :lo12:.LC39
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 4]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC40
	add	x2, x2, :lo12:.LC40
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w1, [x24, #:lo12:.LANCHOR51]
	adrp	x24, .LANCHOR52
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	add	x19, x24, :lo12:.LANCHOR52
	adrp	x2, .LC41
	add	x2, x2, :lo12:.LC41
	ldrh	w3, [x0, x1, lsl 1]
	mov	x1, 64
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 2]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC42
	add	x2, x2, :lo12:.LC42
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 6]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC43
	add	x2, x2, :lo12:.LC43
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x24, #:lo12:.LANCHOR52]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC44
	add	x2, x2, :lo12:.LC44
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 8]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC45
	add	x2, x2, :lo12:.LC45
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 4]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC46
	add	x2, x2, :lo12:.LC46
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w1, [x24, #:lo12:.LANCHOR52]
	adrp	x24, .LANCHOR53
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	add	x19, x24, :lo12:.LANCHOR53
	adrp	x2, .LC47
	add	x2, x2, :lo12:.LC47
	ldrh	w3, [x0, x1, lsl 1]
	mov	x1, 64
	mov	x0, x20
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 2]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC48
	add	x2, x2, :lo12:.LC48
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 6]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC49
	add	x2, x2, :lo12:.LC49
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x24, #:lo12:.LANCHOR53]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC50
	add	x2, x2, :lo12:.LC50
	adrp	x24, .LANCHOR80
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 8]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC51
	add	x2, x2, :lo12:.LC51
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 4]
	add	x19, x24, :lo12:.LANCHOR80
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC52
	add	x2, x2, :lo12:.LC52
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 2]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC53
	add	x2, x2, :lo12:.LC53
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 6]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC54
	add	x2, x2, :lo12:.LC54
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x24, #:lo12:.LANCHOR80]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC55
	add	x2, x2, :lo12:.LC55
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrb	w3, [x19, 8]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC56
	add	x2, x2, :lo12:.LC56
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldrh	w3, [x19, 4]
	mov	x1, 64
	mov	x0, x20
	adrp	x2, .LC57
	add	x2, x2, :lo12:.LC57
	bl	snprintf
	add	x20, x20, x0, sxtw
	ldp	w5, w3, [x25, 76]
	mov	x1, 64
	ldr	w4, [x25, 84]
	adrp	x2, .LC58
	mov	x0, x20
	add	x2, x2, :lo12:.LC58
	bl	snprintf
	add	x19, x20, x0, sxtw
	ldr	w3, [x25, 72]
	mov	x1, 64
	mov	x0, x19
	adrp	x2, .LC59
	add	x2, x2, :lo12:.LC59
	bl	snprintf
	add	x19, x19, x0, sxtw
	ldr	w3, [x25, 96]
	mov	x1, 64
	mov	x0, x19
	adrp	x2, .LC60
	add	x2, x2, :lo12:.LC60
	bl	snprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR82
	mov	x1, 64
	adrp	x2, .LC61
	add	x2, x2, :lo12:.LC61
	ldrh	w3, [x0, #:lo12:.LANCHOR82]
	mov	x0, x19
	bl	snprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR83
	mov	x1, 64
	adrp	x2, .LC62
	add	x2, x2, :lo12:.LC62
	ldrh	w3, [x0, #:lo12:.LANCHOR83]
	mov	x0, x19
	bl	snprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR84
	mov	x1, 64
	adrp	x2, .LC63
	add	x2, x2, :lo12:.LC63
	ldr	w3, [x0, #:lo12:.LANCHOR84]
	mov	x0, x19
	bl	snprintf
	add	x19, x19, x0, sxtw
	adrp	x0, .LANCHOR85
	adrp	x2, .LC64
	add	x2, x2, :lo12:.LC64
	mov	x1, 64
	ldrh	w3, [x0, #:lo12:.LANCHOR85]
	mov	x0, x19
	bl	snprintf
	add	x19, x19, x0, sxtw
	bl	GetFreeBlockMinEraseCount
	and	w3, w0, 65535
	mov	x1, 64
	mov	x0, x19
	adrp	x2, .LC65
	add	x2, x2, :lo12:.LC65
	bl	snprintf
	add	x19, x19, x0, sxtw
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	bl	GetFreeBlockMaxEraseCount
	and	w3, w0, 65535
	adrp	x2, .LC66
	mov	x0, x19
	add	x2, x2, :lo12:.LC66
	mov	x1, 64
	bl	snprintf
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
	ldrh	w0, [x24, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L205
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LC67
	add	x2, x2, :lo12:.LC67
	ldrh	w3, [x1, x0]
	mov	x0, x19
	mov	x1, 64
	bl	snprintf
	add	x19, x19, x0, sxtw
.L205:
	mov	w0, 0
	adrp	x24, .LC68
	bl	List_get_gc_head_node
	add	x24, x24, :lo12:.LC68
	and	w4, w0, 65535
	mov	w23, 0
	mov	w27, 65535
	adrp	x20, .LANCHOR40
	mov	w26, 6
.L207:
	cmp	w4, w27
	beq	.L206
	adrp	x0, .LANCHOR43
	umull	x25, w4, w26
	ldr	x2, [x22, #:lo12:.LANCHOR42]
	ubfiz	x1, x4, 1, 16
	ldr	x3, [x0, #:lo12:.LANCHOR43]
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	add	x0, x0, x25
	ldrh	w5, [x2, x1]
	ldrh	w7, [x3, x1]
	mov	x2, x24
	mov	w3, w23
	mov	x1, 64
	ldrh	w6, [x0, 4]
	mov	x0, x19
	add	w23, w23, 1
	bl	snprintf
	add	x19, x19, x0, sxtw
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	cmp	w23, 16
	ldrh	w4, [x0, x25]
	bne	.L207
.L206:
	adrp	x0, .LANCHOR47
	adrp	x23, .LC69
	add	x23, x23, :lo12:.LC69
	mov	w22, 0
	ldr	x4, [x0, #:lo12:.LANCHOR47]
	mov	w25, 65535
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	mov	w26, 6
	adrp	x27, .LANCHOR43
	sub	x4, x4, x0
	mov	x0, -6148914691236517206
	asr	x4, x4, 1
	movk	x0, 0xaaab, lsl 0
	mul	x4, x4, x0
	and	w4, w4, 65535
.L209:
	cmp	w4, w25
	beq	.L208
	umull	x24, w4, w26
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	ldr	x2, [x27, #:lo12:.LANCHOR43]
	ubfiz	x1, x4, 1, 16
	add	x0, x0, x24
	mov	w3, w22
	add	w22, w22, 1
	ldrh	w6, [x2, x1]
	mov	x2, x23
	ldrh	w5, [x0, 4]
	mov	x1, 64
	mov	x0, x19
	bl	snprintf
	add	x19, x19, x0, sxtw
	cmp	w22, 4
	beq	.L208
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	ldrh	w4, [x0, x24]
	b	.L209
	.size	FtlPrintInfo2buf, .-FtlPrintInfo2buf
	.section	.text.rknand_proc_ftlread,"ax",@progbits
	.align	2
	.global	rknand_proc_ftlread
	.type	rknand_proc_ftlread, %function
rknand_proc_ftlread:
	cmp	w0, 2047
	ble	.L217
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LC70
	adrp	x2, .LC71
	add	x3, x3, :lo12:.LC70
	add	x29, sp, 0
	add	x2, x2, :lo12:.LC71
	stp	x19, x20, [sp, 16]
	mov	x20, x1
	mov	x1, 64
	mov	x0, x20
	bl	snprintf
	add	x19, x20, x0, sxtw
	mov	x0, x19
	bl	FtlPrintInfo2buf
	add	x0, x19, x0, sxtw
	sub	w0, w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L217:
	mov	w0, 0
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
	bcs	.L223
	adrp	x1, .LANCHOR5
	adrp	x0, .LANCHOR72
	mov	w5, 0
	mov	w4, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR43
	str	wzr, [x0, #:lo12:.LANCHOR72]
	ldr	x6, [x1, #:lo12:.LANCHOR43]
	mov	x1, 0
.L224:
	cmp	w3, w1
	bhi	.L225
	cbz	w5, .L226
	str	w4, [x0, #:lo12:.LANCHOR72]
.L226:
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
.L227:
	ldr	w10, [x2, #:lo12:.LANCHOR74]
	add	w0, w7, 256
	cmp	w0, w10
	bls	.L232
	adrp	x1, .LANCHOR76
	add	w0, w7, 768
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cmp	w0, w1
	bls	.L232
.L234:
	mov	w19, 65535
.L233:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L225:
	ldrh	w5, [x6, x1, lsl 1]
	add	x1, x1, 1
	add	w4, w4, w5
	mov	w5, 1
	b	.L224
.L223:
	adrp	x1, .LANCHOR76
	ldr	w0, [x1, #:lo12:.LANCHOR76]
	cmp	w3, w0
	bls	.L227
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR43
	adrp	x1, .LANCHOR5
	add	x1, x1, :lo12:.LANCHOR5
	ldr	x4, [x0, #:lo12:.LANCHOR43]
	mov	w0, 0
.L229:
	ldrh	w3, [x1]
	cmp	w0, w3
	bcs	.L227
	ubfiz	x5, x0, 1, 32
	add	w0, w0, 1
	ldrh	w3, [x4, x5]
	add	w3, w3, 1
	strh	w3, [x4, x5]
	b	.L229
.L232:
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w0, lsl 1
	lsr	w0, w0, 2
	bl	GetFreeBlockMaxEraseCount
	and	w6, w0, 65535
	add	w0, w7, 64
	cmp	w6, w0
	bcc	.L234
	adrp	x0, .LANCHOR41
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	cbz	x0, .L234
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
.L235:
	ldrh	w5, [x0]
	cmp	w5, w12
	bne	.L238
	mov	w19, w2
.L237:
	mov	w0, 65535
	cmp	w19, w0
	beq	.L234
	ubfiz	x2, x19, 1, 32
	ldrh	w5, [x4, x2]
	cmp	w7, w5
	bcs	.L239
	bl	GetFreeBlockMinEraseCount
	cmp	w7, w0, uxth
	bcs	.L239
	str	w3, [x8, #:lo12:.LANCHOR77]
.L239:
	cmp	w10, w5
	bls	.L234
	add	w0, w5, 128
	cmp	w6, w0
	ble	.L234
	add	w0, w5, 256
	adrp	x1, .LANCHOR76
	cmp	w10, w0
	bhi	.L240
	ldr	w3, [x1, #:lo12:.LANCHOR76]
	add	w0, w5, 768
	cmp	w0, w3
	bcs	.L234
.L240:
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
	b	.L233
.L238:
	add	w1, w1, 1
	and	w1, w1, 65535
	cmp	w1, w13
	bhi	.L234
	ldrh	w16, [x0, 4]
	cbz	w16, .L236
	sub	x0, x0, x11
	asr	x0, x0, 1
	mul	x0, x0, x14
	and	w19, w0, 65535
	and	x0, x0, 65535
	ldrh	w0, [x4, x0, lsl 1]
	cmp	w7, w0
	bcs	.L237
	cmp	w3, w0
	bls	.L236
	mov	w3, w0
	mov	w2, w19
.L236:
	umaddl	x0, w5, w15, x11
	b	.L235
	.size	GetSwlReplaceBlock, .-GetSwlReplaceBlock
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L254
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
.L254:
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
	bne	.L258
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2740
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L258:
	adrp	x20, .LANCHOR19
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bne	.L259
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2741
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L259:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L260
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2742
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L260:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR3
	strb	wzr, [x19, 10]
	add	x0, x0, 8
	ldrh	w2, [x1, #:lo12:.LANCHOR3]
	mov	w1, 65535
	ldrh	w0, [x19, x0, lsl 1]
.L261:
	cmp	w0, w1
	beq	.L263
	ldrh	w21, [x19, 2]
	mov	w3, 65535
	ldrh	w1, [x19, 4]
	orr	w21, w21, w0, lsl 10
	ldrb	w0, [x19, 6]
	sub	w1, w1, #1
	and	w1, w1, 65535
	strh	w1, [x19, 4]
.L265:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w2, w0
	bne	.L264
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L264:
	add	x4, x19, x0, sxtw 1
	ldrh	w4, [x4, 16]
	cmp	w4, w3
	beq	.L265
	strb	w0, [x19, 6]
	ldrh	w2, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w2, w0
	bne	.L257
	cbz	w1, .L257
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2763
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.L257:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L263:
	ldrb	w0, [x19, 6]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w0, w2
	bne	.L262
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L262:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L261
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
.L273:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L274
	adrp	x1, .LANCHOR94
	ldr	x7, [x7, #:lo12:.LANCHOR91]
	ldr	x6, [x6, #:lo12:.LANCHOR92]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR94]
.L275:
	cmp	w0, w4
	bcc	.L276
	ret
.L274:
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
	b	.L273
.L276:
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
	b	.L275
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
.L278:
	cmp	w3, w1
	bcs	.L277
	ubfiz	x4, x3, 5, 16
	mov	w2, 0
	add	x4, x0, x4
	b	.L283
.L279:
	add	w2, w2, 1
	and	w2, w2, 65535
.L283:
	cmp	w2, w7
	bcs	.L280
	umull	x6, w2, w8
	add	x10, x5, x6
	ldr	x11, [x5, x6]
	ldr	x6, [x4, 8]
	cmp	x11, x6
	bne	.L279
	str	wzr, [x10, 16]
.L280:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L278
.L277:
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
.L285:
	cmp	w3, w1
	bcs	.L284
	mov	w2, 0
	b	.L290
.L286:
	add	w2, w2, 1
	and	w2, w2, 65535
.L290:
	cmp	w2, w5
	bcs	.L287
	umaddl	x4, w2, w7, x6
	ldr	w10, [x4, 16]
	cbnz	w10, .L286
	ubfiz	x2, x3, 5, 16
	ldr	x10, [x4]
	add	x2, x0, x2
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x10, x4, [x2, 8]
.L287:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L285
.L284:
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
.L292:
	cmp	w2, w1, uxth
	bhi	.L294
	mov	w0, 0
	ret
.L294:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L292
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
.L297:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L299
	bne	.L298
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR95]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR95]
	b	.L298
.L299:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L297
.L298:
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
	beq	.L302
	adrp	x0, .LANCHOR100
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w19, w2
	beq	.L302
	mov	w1, 65535
	cmp	w4, w1
	bne	.L303
	strh	w19, [x3, #:lo12:.LANCHOR99]
.L302:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L303:
	cmp	w2, w1
	bne	.L302
	strh	w19, [x0, #:lo12:.LANCHOR100]
	b	.L302
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
.L306:
	cmp	w0, w1, uxth
	bhi	.L308
	cmp	w0, 15
	bhi	.L307
	add	w1, w0, 1
	strh	w1, [x19, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR102
	add	x1, x1, :lo12:.LANCHOR102
	strh	w20, [x1, w0, sxtw 1]
	b	.L307
.L308:
	add	x1, x1, 1
	add	x3, x2, x1, lsl 1
	ldrh	w3, [x3, -2]
	cmp	w3, w20
	bne	.L306
.L307:
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
	cbz	w0, .L317
	adrp	x1, .LANCHOR99
	ldrh	w2, [x1, #:lo12:.LANCHOR99]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L317
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR103
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	cmp	w1, w0
	bcc	.L312
	strh	wzr, [x19, #:lo12:.LANCHOR103]
.L312:
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
.L317:
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
.L323:
	cmp	w27, w19
	bhi	.L329
	ldp	x19, x20, [sp, 16]
	adrp	x0, .LC78
	ldp	x21, x22, [sp, 32]
	add	x0, x0, :lo12:.LC78
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L329:
	cbnz	w20, .L324
	mov	w2, w21
	mov	x1, x28
	mov	x0, x24
	bl	printf
.L324:
	cmp	w23, 4
	bne	.L325
	ldr	w1, [x22, x19, lsl 2]
.L332:
	add	x0, x26, :lo12:.LC76
.L331:
	bl	printf
	add	w20, w20, 1
	cmp	w20, 15
	bls	.L328
	mov	w20, 0
	adrp	x0, .LC78
	add	x0, x0, :lo12:.LC78
	bl	printf
.L328:
	add	x19, x19, 1
	add	w21, w21, w23
	b	.L323
.L325:
	cmp	w23, 2
	bne	.L327
	ldrh	w1, [x22, x19, lsl 1]
	b	.L332
.L327:
	ldrb	w1, [x22, x19]
	mov	x0, x25
	b	.L331
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.FlashEraseBlocks,"ax",@progbits
	.align	2
	.global	FlashEraseBlocks
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	adrp	x0, .LANCHOR0
	add	x1, x0, :lo12:.LANCHOR0
	stp	x23, x24, [sp, 48]
	add	x19, x20, 4
	stp	x21, x22, [sp, 32]
	ubfiz	x21, x2, 5, 32
	ldrh	w24, [x1, 12]
	add	x23, x21, 4
	stp	x25, x26, [sp, 64]
	add	x23, x20, x23
	adrp	x25, .LANCHOR105
	str	x27, [sp, 80]
	lsl	w26, w24, 3
	mov	x22, x0
	add	x27, x25, :lo12:.LANCHOR105
.L334:
	cmp	x19, x23
	beq	.L348
	ldr	w0, [x19]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
	ldr	w0, [x29, 104]
	cbnz	w0, .L335
	ldr	w1, [x29, 108]
	cmp	w26, w1
	bls	.L335
	mov	x19, x20
	add	x21, x20, x21
	adrp	x22, .LC79
	adrp	x20, .LANCHOR104
	add	x22, x22, :lo12:.LC79
	add	x20, x20, :lo12:.LANCHOR104
	mov	w23, -1
.L336:
	cmp	x19, x21
	bne	.L337
.L348:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L337:
	ldr	w2, [x29, 108]
	mov	x1, x20
	str	w23, [x19]
	mov	x0, x22
	add	x19, x19, 32
	bl	printf
	ldr	x1, [x19, -24]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	rknand_print_hex
	ldr	x1, [x19, -16]
	mov	w3, 4
	adrp	x0, .LC81
	mov	w2, w3
	add	x0, x0, :lo12:.LC81
	bl	rknand_print_hex
	b	.L336
.L335:
	add	x1, x25, :lo12:.LANCHOR105
	ldr	x2, [x1, 8]
	ldr	w1, [x29, 108]
	blr	x2
	cbnz	w0, .L338
	str	wzr, [x19, -4]
.L339:
	add	x0, x22, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L341
	ldrb	w0, [x29, 104]
	ldr	x2, [x27, 8]
	ldr	w1, [x29, 108]
	add	w1, w24, w1
	blr	x2
	cbz	w0, .L341
	mov	w0, -1
	str	w0, [x19, -4]
.L341:
	add	x19, x19, 32
	b	.L334
.L338:
	mov	w0, -1
	str	w0, [x19, -4]
	b	.L339
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
	bcc	.L350
	adrp	x0, .LANCHOR38
	add	x2, x0, :lo12:.LANCHOR38
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L350
	and	w1, w1, 65535
	cbz	w1, .L352
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w21, w0, 65535
	adrp	x0, .LANCHOR106
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR106]
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
.L352:
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
.L350:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	adrp	x0, .LANCHOR38
	add	x1, x0, :lo12:.LANCHOR38
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldrh	w2, [x1, 6]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	cbz	w2, .L364
	ldrh	w0, [x1, 2]
	sub	w2, w2, #1
	strh	w2, [x1, 6]
	mov	w2, 1
	add	x3, x1, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x1, 2]
	adrp	x0, .LANCHOR106
	ldrh	w20, [x3, 8]
	ldr	x0, [x0, #:lo12:.LANCHOR106]
	lsl	w1, w20, 10
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR75
	ldr	w0, [x1, #:lo12:.LANCHOR75]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR75]
.L361:
	sub	w0, w20, #1
	mov	w1, 65533
	cmp	w1, w0, uxth
	bcs	.L362
	add	x0, x19, :lo12:.LANCHOR38
	mov	w1, w20
	ldrh	w2, [x0, 6]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	printf
.L363:
	b	.L363
.L364:
	mov	w20, 65535
	b	.L361
.L362:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
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
.L367:
	cmp	w20, w1
	beq	.L371
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L368
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L369
	adrp	x0, .LANCHOR38+6
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	adrp	x0, .LC83
	add	x0, x0, :lo12:.LC83
	bl	printf
.L370:
	b	.L370
.L369:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L371:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L373
	adrp	x1, .LANCHOR107
	adrp	x0, .LC1
	mov	w2, 578
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC1
	bl	printf
.L373:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L368:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L367
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
	adrp	x24, .LANCHOR118
	str	wzr, [x0, #:lo12:.LANCHOR63]
	adrp	x0, .LANCHOR65
	stp	x27, x28, [sp, 80]
	adrp	x23, .LANCHOR124
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
	adrp	x0, .LANCHOR108
	str	wzr, [x0, #:lo12:.LANCHOR108]
	adrp	x0, .LANCHOR87
	str	wzr, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR109
	str	w1, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LANCHOR110
	adrp	x1, .LANCHOR99
	str	wzr, [x0, #:lo12:.LANCHOR110]
	adrp	x0, .LANCHOR84
	str	wzr, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR111
	str	wzr, [x0, #:lo12:.LANCHOR111]
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
	adrp	x5, .LANCHOR98
	str	x5, [x29, 104]
	lsl	w20, w19, 5
	lsl	w19, w19, 7
	str	x0, [x5, #:lo12:.LANCHOR98]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x15, .LANCHOR112
	str	x15, [x29, 112]
	str	x0, [x15, #:lo12:.LANCHOR112]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x11, .LANCHOR113
	str	x11, [x29, 120]
	str	x0, [x11, #:lo12:.LANCHOR113]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x14, .LANCHOR114
	str	x14, [x29, 128]
	str	x0, [x14, #:lo12:.LANCHOR114]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x13, .LANCHOR106
	str	x13, [x29, 136]
	str	x0, [x13, #:lo12:.LANCHOR106]
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
	adrp	x10, .LANCHOR115
	str	x10, [x29, 152]
	str	x0, [x10, #:lo12:.LANCHOR115]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x8, .LANCHOR116
	str	x8, [x29, 160]
	str	x0, [x8, #:lo12:.LANCHOR116]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x7, .LANCHOR117
	str	x7, [x29, 168]
	str	x0, [x7, #:lo12:.LANCHOR117]
	ldr	w0, [x20, #:lo12:.LANCHOR94]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x6, .LANCHOR91
	str	x6, [x29, 176]
	str	x0, [x6, #:lo12:.LANCHOR91]
	mov	w0, w19
	bl	ftl_malloc
	str	x0, [x24, #:lo12:.LANCHOR118]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x4, .LANCHOR119
	ldr	w2, [x20, #:lo12:.LANCHOR94]
	str	x4, [x29, 184]
	str	x0, [x4, #:lo12:.LANCHOR119]
	mov	w0, 24
	mul	w0, w2, w0
	bl	ftl_malloc
	adrp	x3, .LANCHOR90
	str	x3, [x29, 192]
	str	x0, [x3, #:lo12:.LANCHOR90]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x2, .LANCHOR120
	str	x0, [x2, #:lo12:.LANCHOR120]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x19, .LANCHOR24
	adrp	x2, .LANCHOR121
	str	x0, [x2, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR12
	ldrh	w0, [x0, #:lo12:.LANCHOR12]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x2, .LANCHOR122
	ldrh	w28, [x19, #:lo12:.LANCHOR24]
	str	x0, [x2, #:lo12:.LANCHOR122]
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	adrp	x22, .LANCHOR92
	mul	w28, w28, w0
	mov	w0, w28
	bl	ftl_malloc
	adrp	x1, .LANCHOR123
	str	x0, [x1, #:lo12:.LANCHOR123]
	lsl	w0, w28, 2
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR124]
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
	ldp	x5, x15, [x29, 104]
	adrp	x1, .LANCHOR37
	ldrh	w20, [x20, #:lo12:.LANCHOR137]
	add	x2, x1, :lo12:.LANCHOR37
	ldp	x11, x14, [x29, 120]
	mov	w30, w20
	ldp	x13, x12, [x29, 136]
	mov	x16, x5
	ldp	x10, x8, [x29, 152]
	mov	x5, x24
	ldp	x7, x6, [x29, 168]
	str	x0, [x2, 32]
	ldp	x4, x3, [x29, 184]
	adrp	x17, .LANCHOR96
	ldrh	w28, [x21, #:lo12:.LANCHOR10]
	add	x21, x2, 40
	adrp	x24, .LANCHOR123
	mov	x0, 1
	str	x19, [x29, 200]
.L377:
	cmp	w0, w28
	bcc	.L378
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR37
	mov	x19, 0
.L379:
	add	x19, x19, 1
	cmp	x19, x2
	bne	.L380
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	cbnz	x0, .L381
.L383:
	adrp	x1, .LANCHOR138
	adrp	x0, .LC84
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC84
	bl	printf
	mov	w0, -1
.L376:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L378:
	ldr	x19, [x2, 32]
	add	w0, w0, 1
	add	x19, x19, x30, uxtw 2
	add	w30, w30, w20
	str	x19, [x21], 8
	b	.L377
.L380:
	add	x20, x0, x19
	add	x20, x1, x20, lsl 3
	str	xzr, [x20, 24]
	b	.L379
.L381:
	ldr	x0, [x26, #:lo12:.LANCHOR130]
	cbz	x0, .L383
	adrp	x0, .LANCHOR134
	ldr	x0, [x0, #:lo12:.LANCHOR134]
	cbz	x0, .L383
	adrp	x0, .LANCHOR135
	ldr	x0, [x0, #:lo12:.LANCHOR135]
	cbz	x0, .L383
	adrp	x0, .LANCHOR55
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	cbz	x0, .L383
	adrp	x0, .LANCHOR136
	ldr	x0, [x0, #:lo12:.LANCHOR136]
	cbz	x0, .L383
	adrp	x0, .LANCHOR40
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	cbz	x0, .L383
	adrp	x0, .LANCHOR37+32
	ldr	x0, [x0, #:lo12:.LANCHOR37+32]
	cbz	x0, .L383
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	cbz	x0, .L383
	ldr	x0, [x17, #:lo12:.LANCHOR96]
	cbz	x0, .L383
	ldr	x0, [x16, #:lo12:.LANCHOR98]
	cbz	x0, .L383
	ldr	x0, [x15, #:lo12:.LANCHOR112]
	cbz	x0, .L383
	ldr	x0, [x14, #:lo12:.LANCHOR114]
	cbz	x0, .L383
	ldr	x0, [x13, #:lo12:.LANCHOR106]
	cbz	x0, .L383
	ldr	x0, [x12, #:lo12:.LANCHOR93]
	cbz	x0, .L383
	ldr	x0, [x11, #:lo12:.LANCHOR113]
	cbz	x0, .L383
	ldr	x0, [x10, #:lo12:.LANCHOR115]
	cbz	x0, .L383
	ldr	x0, [x8, #:lo12:.LANCHOR116]
	cbz	x0, .L383
	ldr	x0, [x7, #:lo12:.LANCHOR117]
	cbz	x0, .L383
	ldr	x0, [x6, #:lo12:.LANCHOR91]
	cbz	x0, .L383
	ldr	x0, [x5, #:lo12:.LANCHOR118]
	cbz	x0, .L383
	ldr	x0, [x4, #:lo12:.LANCHOR119]
	cbz	x0, .L383
	ldr	x0, [x3, #:lo12:.LANCHOR90]
	cbz	x0, .L383
	ldr	x0, [x24, #:lo12:.LANCHOR123]
	cbz	x0, .L383
	ldr	x0, [x23, #:lo12:.LANCHOR124]
	cbz	x0, .L383
	ldr	x0, [x22, #:lo12:.LANCHOR92]
	cbz	x0, .L383
	ldr	x0, [x29, 200]
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	cbz	x0, .L383
	adrp	x0, .LANCHOR126
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	cbz	x0, .L383
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	cbz	x0, .L383
	adrp	x0, .LANCHOR131
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	cbz	x0, .L383
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	cbz	x0, .L383
	adrp	x0, .LANCHOR133
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	cbz	x0, .L383
	mov	w0, 0
	b	.L376
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
.L481:
	ldrh	w0, [x22, x19]
	cmp	w0, w24
	beq	.L478
	ldrh	w1, [x21]
	cmp	w1, w0
	bhi	.L480
	adrp	x0, .LC1
	mov	w2, 74
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.L480:
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
	bne	.L481
.L478:
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
	ldr	x22, [x0, 16]
	lsl	w2, w2, 1
	mov	x0, x21
	str	x25, [sp, 64]
	bl	ftl_memset
	mov	w0, 0
.L489:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L493
	adrp	x0, .LANCHOR20
	mov	w23, 0
	mov	w20, 0
	ldrh	w1, [x0, #:lo12:.LANCHOR20]
	ldrh	w0, [x19]
	strh	w1, [x21, x0, lsl 1]
	ldrh	w24, [x21]
.L494:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L498
	mov	w0, w23
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L493:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L490:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L492
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L489
.L492:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x22, x3]
	cmp	w4, w2
	bne	.L491
	cbz	w2, .L491
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L491:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L490
.L498:
	ubfiz	x0, x20, 1, 16
	ldrh	w1, [x21, x0]
	cmp	w24, w1
	bls	.L495
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbnz	w0, .L496
.L497:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L494
.L495:
	cbnz	w1, .L497
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbz	w0, .L497
.L499:
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x25]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	b	.L497
.L500:
	mov	w24, 0
	b	.L499
.L496:
	mov	w23, w20
	cbz	w1, .L500
	mov	w24, w1
	b	.L497
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
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
.L510:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L511
	adrp	x1, .LANCHOR140
	add	x0, x1, :lo12:.LANCHOR140
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR140]
	ldr	w1, [x20, #:lo12:.LANCHOR30]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR141
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR141]
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
.L511:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L510
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR142
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR142]
	adrp	x0, .LANCHOR143
	mov	w1, -1
	str	x19, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR143]
	adrp	x0, .LANCHOR144
	adrp	x19, .LANCHOR6
	str	wzr, [x0, #:lo12:.LANCHOR144]
	adrp	x0, .LANCHOR145
	str	w1, [x0, #:lo12:.LANCHOR145]
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
.L516:
	ldrh	w0, [x25]
	cmp	w19, w0
	bcs	.L523
	adrp	x0, .LANCHOR19
	ldrh	w8, [x27, #:lo12:.LANCHOR3]
	mov	x6, 0
	mov	w5, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR19]
	b	.L524
.L518:
	ldrb	w0, [x26, x6]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L517
	add	w5, w5, w7
	and	w5, w5, 65535
.L517:
	add	x6, x6, 1
.L524:
	cmp	w8, w6, uxth
	bhi	.L518
	cbz	w5, .L519
	mov	w0, 32768
	sdiv	w5, w0, w5
.L520:
	ldr	x1, [x24, #:lo12:.LANCHOR40]
	mov	w0, 6
	umaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L521
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L521
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L521
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbnz	w0, .L522
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L521:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L516
.L519:
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	mov	w2, -1
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w2, [x1, x0]
	b	.L520
.L522:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L521
.L523:
	strh	w20, [x23, #:lo12:.LANCHOR45]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR48]
	cmp	w20, w0
	ble	.L525
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 2170
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.L525:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	SupperBlkListInit, .-SupperBlkListInit
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
	bls	.L530
	mov	w2, 256
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	mov	w0, 0
.L530:
	adrp	x1, .LANCHOR0+14
	ldrh	w1, [x1, #:lo12:.LANCHOR0+14]
	cmp	w1, 4
	bne	.L534
	mov	x1, 0
.L532:
	cmp	w0, w1, uxth
	bhi	.L533
.L534:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L533:
	ldrh	w2, [x19, x1, lsl 1]
	lsr	w2, w2, 1
	strh	w2, [x19, x1, lsl 1]
	add	x1, x1, 1
	b	.L532
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.ftl_memcpy,"ax",@progbits
	.align	2
	.global	ftl_memcpy
	.type	ftl_memcpy, %function
ftl_memcpy:
	uxtw	x2, w2
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.FlashReadPages,"ax",@progbits
	.align	2
	.global	FlashReadPages
	.type	FlashReadPages, %function
FlashReadPages:
	stp	x29, x30, [sp, -112]!
	ubfiz	x1, x1, 5, 32
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR0
	add	x2, x21, :lo12:.LANCHOR0
	str	x27, [sp, 80]
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR147
	stp	x19, x20, [sp, 16]
	add	x23, x0, x1
	ldrh	w27, [x2, 12]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	add	x24, x24, :lo12:.LANCHOR147
	adrp	x25, .LC1
	add	x25, x25, :lo12:.LC1
.L538:
	cmp	x23, x19
	bne	.L548
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L548:
	ldr	x0, [x19, 8]
	cbz	x0, .L539
	ldr	x0, [x19, 16]
	cbnz	x0, .L540
.L539:
	mov	w2, 90
	mov	x1, x24
	mov	x0, x25
	bl	printf
.L540:
	ldr	w0, [x19, 4]
	add	x2, x29, 104
	add	x1, x29, 108
	adrp	x26, .LANCHOR120
	bl	l2p_addr_tran.isra.0
	ldr	x20, [x19, 8]
	tst	x20, 63
	beq	.L541
	ldr	x20, [x26, #:lo12:.LANCHOR120]
.L541:
	adrp	x22, .LANCHOR105
	add	x22, x22, :lo12:.LANCHOR105
	ldrb	w0, [x29, 104]
	mov	x2, x20
	ldr	w1, [x29, 108]
	ldr	x3, [x19, 16]
	ldr	x4, [x22, 24]
	blr	x4
	str	w0, [x19]
	add	x0, x21, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L543
	ldrb	w0, [x29, 104]
	add	x2, x20, 2048
	ldr	x4, [x22, 24]
	ldr	w1, [x29, 108]
	ldr	x3, [x19, 16]
	add	w1, w27, w1
	add	x3, x3, 8
	blr	x4
	cmn	w0, #1
	beq	.L544
	ldr	x1, [x19, 16]
	ldr	w2, [x1, 12]
	cmn	w2, #1
	bne	.L545
	ldr	w2, [x1, 8]
	cmn	w2, #1
	bne	.L545
	ldr	w1, [x1]
	cmn	w1, #1
	beq	.L545
.L544:
	mov	w1, -1
	str	w1, [x19]
.L545:
	ldr	w1, [x19]
	cmn	w1, #1
	beq	.L543
	cmp	w0, 256
	bne	.L543
	str	w0, [x19]
.L543:
	ldr	x0, [x26, #:lo12:.LANCHOR120]
	cmp	x20, x0
	bne	.L547
	ldr	x0, [x19, 8]
	cmp	x20, x0
	beq	.L547
	adrp	x1, .LANCHOR12
	ldrh	w2, [x1, #:lo12:.LANCHOR12]
	mov	x1, x20
	lsl	w2, w2, 9
	bl	ftl_memcpy
.L547:
	add	x19, x19, 32
	b	.L538
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR115
	adrp	x0, .LANCHOR148
	add	x1, x0, :lo12:.LANCHOR148
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR115]
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
	adrp	x2, .LANCHOR123
	adrp	x23, .LANCHOR10
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR123]
	add	x23, x23, :lo12:.LANCHOR10
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L566:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L571
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L571:
	ldrh	w19, [x26, #:lo12:.LANCHOR17]
	add	x24, x22, :lo12:.LANCHOR148
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L567:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L569
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
	beq	.L568
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L568
	strh	w19, [x20]
.L569:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L566
.L568:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L567
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
	bne	.L577
	adrp	x1, .LANCHOR20
	ldrh	w19, [x1, #:lo12:.LANCHOR20]
.L578:
	adrp	x1, .LANCHOR121
	sub	w19, w19, #1
	sxth	w19, w19
	lsl	w21, w0, 10
	ldr	x1, [x1, #:lo12:.LANCHOR121]
	orr	w0, w19, w21
	str	x1, [x29, 72]
	add	x1, x29, 96
	str	w0, [x29, 68]
	mov	w2, w23
	str	x1, [x29, 80]
	add	x0, x29, 64
	mov	w1, 1
	bl	FlashReadPages
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L579
	mov	w22, 0
	mov	w24, 2
.L580:
	cmp	w22, w19
	ble	.L583
.L579:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 160
	ret
.L577:
	adrp	x1, .LANCHOR19
	ldrh	w19, [x1, #:lo12:.LANCHOR19]
	b	.L578
.L583:
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
	bne	.L581
	ldr	w0, [x29, 100]
	cmn	w0, #1
	bne	.L581
	ldr	w0, [x29, 64]
	cmn	w0, #1
	beq	.L581
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L580
.L581:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L580
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
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
	adrp	x20, .LANCHOR141
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR35
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR129
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR141]
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
.L589:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L629
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR112
	adrp	x6, .LANCHOR13
	mov	x5, 0
	ldrh	w12, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR91
	ldr	x7, [x25, #:lo12:.LANCHOR112]
	mov	w22, 0
	ldr	x11, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LANCHOR92
	add	x6, x6, :lo12:.LANCHOR13
	ldr	x10, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x0, #:lo12:.LANCHOR24]
	b	.L630
.L591:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L590
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
.L590:
	add	x5, x5, 1
.L630:
	cmp	w12, w5, uxth
	bhi	.L591
	cbnz	w22, .L592
.L628:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L589
.L592:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	str	x0, [x29, 136]
.L627:
	ldr	x0, [x25, #:lo12:.LANCHOR112]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L595
	mov	w5, 16
	mov	w7, 65535
.L597:
	ldr	x0, [x25, #:lo12:.LANCHOR112]
	add	x6, x25, :lo12:.LANCHOR112
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
	bne	.L594
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	bne	.L595
.L596:
	mov	w1, 1
	b	.L666
.L594:
	ldr	x0, [x25, #:lo12:.LANCHOR112]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L595
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L597
	b	.L596
.L595:
	adrp	x0, .LANCHOR70
	ldr	w1, [x0, #:lo12:.LANCHOR70]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L598
	cmp	w1, w0
	bhi	.L599
.L598:
	cmn	w0, #1
	beq	.L599
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L599:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L601
	bhi	.L602
	mov	w0, 61574
	cmp	w1, w0
	beq	.L603
.L600:
	ldr	x0, [x29, 128]
	add	x22, x22, 32
	cmp	x0, x22
	bne	.L627
	b	.L628
.L602:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L604
	mov	w0, 65535
	cmp	w1, w0
	bne	.L600
	mov	w1, 0
.L666:
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L600
.L604:
	ldrh	w1, [x20, #:lo12:.LANCHOR141]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L606
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1222
	add	x0, x0, :lo12:.LC1
	bl	printf
.L606:
	ldr	w6, [x21, #:lo12:.LANCHOR30]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR141]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR135]
	sxth	w2, w2
.L607:
	cmp	w0, w2
	bgt	.L613
	tbz	w0, #31, .L647
	b	.L600
.L613:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L608
	ldr	w2, [x5]
	cbnz	w2, .L609
	cmp	w6, w1
	beq	.L609
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR141]
.L609:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L610:
	cmp	w1, w0
	bne	.L611
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L600
	ldrh	w1, [x20, #:lo12:.LANCHOR141]
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L600
.L647:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR141]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L665:
	strh	w26, [x1, x0, lsl 1]
	b	.L600
.L611:
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
	b	.L610
.L608:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L607
.L603:
	ldrh	w1, [x23, #:lo12:.LANCHOR35]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	cmp	w1, w0
	bls	.L616
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1263
	add	x0, x0, :lo12:.LC1
	bl	printf
.L616:
	ldrh	w6, [x19, #:lo12:.LANCHOR27]
	ldrh	w2, [x23, #:lo12:.LANCHOR35]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
.L617:
	cmp	w0, w5
	ble	.L622
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L618
	ldr	w5, [x1]
	cbnz	w5, .L619
	cmp	w6, w2
	beq	.L619
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR35]
.L619:
	ldr	x6, [x28, #:lo12:.LANCHOR36]
	mov	w2, 0
.L620:
	cmp	w2, w0
	bne	.L621
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L622:
	tbnz	w0, #31, .L600
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	ldrh	w5, [x23, #:lo12:.LANCHOR35]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L600
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR35]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	b	.L665
.L621:
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
	b	.L620
.L618:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L617
.L601:
	ldrh	w5, [x24, #:lo12:.LANCHOR79]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR79
	cmp	w5, w1
	bne	.L624
	strh	w26, [x24, #:lo12:.LANCHOR79]
	str	w0, [x2, 8]
	b	.L600
.L624:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L625
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L625:
	add	x0, x24, :lo12:.LANCHOR79
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L626
	ldrh	w2, [x24, #:lo12:.LANCHOR79]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR79]
	str	w1, [x0, 8]
	b	.L600
.L626:
	strh	w26, [x0, 4]
	b	.L600
.L629:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L631
.L634:
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	ldrh	w0, [x1]
	cbz	w0, .L632
.L633:
	ldrh	w1, [x20, #:lo12:.LANCHOR141]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L663
	adrp	x1, .LANCHOR149
	adrp	x0, .LC1
	mov	w2, 1388
	add	x1, x1, :lo12:.LANCHOR149
	add	x0, x0, :lo12:.LC1
	bl	printf
.L663:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L631:
	ldrh	w0, [x20, #:lo12:.LANCHOR141]
	cbz	w0, .L634
	ldr	w1, [x21, #:lo12:.LANCHOR30]
	mov	w0, 0
.L635:
	cmp	w0, w1
	bcs	.L634
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L636
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR30
	ldr	x4, [x1, #:lo12:.LANCHOR135]
	mov	w1, w0
.L637:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L634
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
	b	.L637
.L636:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L635
.L632:
	ldrh	w0, [x23, #:lo12:.LANCHOR35]
	cbz	w0, .L633
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	mov	w0, 0
.L642:
	mov	w6, w0
	cmp	w0, w2
	bge	.L633
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L643
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR27
	ldr	x3, [x2, #:lo12:.LANCHOR132]
.L644:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L633
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
	b	.L644
.L643:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L642
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR115
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR17
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR148
	add	x20, x22, :lo12:.LANCHOR148
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	str	x25, [sp, 64]
	mov	w25, 61649
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR123
	ldr	x21, [x0, #:lo12:.LANCHOR123]
	str	x21, [x20, 16]
	bl	FtlBbtMemInit
	ldrh	w19, [x24, #:lo12:.LANCHOR17]
	add	x24, x24, :lo12:.LANCHOR17
	sub	w19, w19, #1
	and	w19, w19, 65535
.L668:
	ldrh	w0, [x24]
	sub	w0, w0, #15
	cmp	w0, w19
	bgt	.L671
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L669
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L669:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L670
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L670
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	strh	w19, [x1, #:lo12:.LANCHOR37]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L671:
	adrp	x19, .LANCHOR37
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR37
	ldrh	w1, [x19, #:lo12:.LANCHOR37]
	cmp	w1, w0
	beq	.L685
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L675
	add	x0, x22, :lo12:.LANCHOR148
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR148]
	cmn	w0, #1
	beq	.L675
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L675
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L675
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR37]
	strh	w0, [x20, 4]
.L675:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	add	x24, x19, :lo12:.LANCHOR37
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR148
.L677:
	tbz	w20, #31, .L680
	adrp	x1, .LANCHOR150
	adrp	x0, .LC1
	mov	w2, 253
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC1
	bl	printf
.L679:
	add	x0, x19, :lo12:.LANCHOR37
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L682
	adrp	x1, .LANCHOR2
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	cmp	w0, w2
	beq	.L682
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L682
	cmp	w0, w1
	bcs	.L682
	bl	FtlSysBlkNumInit
.L682:
	add	x19, x19, :lo12:.LANCHOR37
	adrp	x21, .LANCHOR10
	adrp	x23, .LANCHOR137
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR10
	add	x23, x23, :lo12:.LANCHOR137
	add	x22, x22, :lo12:.LANCHOR148
	mov	w20, 0
.L683:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L684
	mov	w0, 0
.L667:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L670:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L668
.L680:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	str	x0, [x24, 8]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L678
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L679
.L678:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L677
.L684:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L683
.L685:
	mov	w0, -1
	b	.L667
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	stp	x29, x30, [sp, -96]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR148
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR115
	stp	x21, x22, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR148
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR123
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR42
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	adrp	x24, .LANCHOR5
	str	x0, [x21, 8]
	adrp	x20, .LANCHOR79
	ldr	x0, [x26, #:lo12:.LANCHOR123]
	str	x0, [x21, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L698
.L706:
	mov	w0, -1
.L697:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L698:
	add	x27, x20, :lo12:.LANCHOR79
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	sxth	w22, w0
	add	w0, w0, 1
	mov	w28, 61604
	strh	w0, [x27, 2]
	mov	w27, 19539
	movk	w27, 0x4654, lsl 16
.L700:
	tbz	w22, #31, .L703
	adrp	x1, .LANCHOR151
	adrp	x0, .LC1
	mov	w2, 1448
	add	x1, x1, :lo12:.LANCHOR151
	add	x0, x0, :lo12:.LC1
	bl	printf
.L702:
	adrp	x1, .LANCHOR23
	ldrh	w0, [x24, #:lo12:.LANCHOR5]
	ldrh	w1, [x1, #:lo12:.LANCHOR23]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L705
	adrp	x1, .LANCHOR151
	adrp	x0, .LC1
	mov	w2, 1450
	add	x1, x1, :lo12:.LANCHOR151
	add	x0, x0, :lo12:.LC1
	bl	printf
.L705:
	add	x22, x19, :lo12:.LANCHOR148
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
	bne	.L706
	add	x20, x20, :lo12:.LANCHOR79
	adrp	x0, .LANCHOR10
	ldrh	w1, [x21, 8]
	ldrb	w2, [x21, 10]
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	strh	w1, [x20, 6]
	cmp	w2, w0
	bne	.L706
	adrp	x0, .LANCHOR152
	adrp	x2, .LANCHOR61
	adrp	x3, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR152]
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
	bls	.L707
	adrp	x1, .LANCHOR151
	adrp	x0, .LC1
	mov	w2, 1472
	add	x1, x1, :lo12:.LANCHOR151
	add	x0, x0, :lo12:.LC1
	bl	printf
.L707:
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
	bls	.L708
	str	w3, [x1, #:lo12:.LANCHOR70]
.L708:
	add	x19, x19, :lo12:.LANCHOR39
	adrp	x1, .LANCHOR71
	ldr	w3, [x1, #:lo12:.LANCHOR71]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L709
	str	w2, [x1, #:lo12:.LANCHOR71]
.L709:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L710
	add	x0, x0, :lo12:.LANCHOR51
	bl	make_superblock
.L710:
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR52
	cmp	w2, w1
	beq	.L711
	bl	make_superblock
.L711:
	ldrh	w2, [x22, #:lo12:.LANCHOR53]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR53
	cmp	w2, w1
	beq	.L712
	bl	make_superblock
.L712:
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR80
	cmp	w2, w1
	beq	.L713
	bl	make_superblock
.L713:
	mov	w0, 0
	b	.L697
.L703:
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x21, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	str	x0, [x21, 8]
	mov	x0, x21
	bl	FlashReadPages
	ldr	w0, [x21]
	cmn	w0, #1
	beq	.L701
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L701
	ldr	x0, [x26, #:lo12:.LANCHOR123]
	ldrh	w0, [x0]
	cmp	w0, w28
	beq	.L702
.L701:
	sub	w22, w22, #1
	sxth	w22, w22
	b	.L700
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FlashProgPages,"ax",@progbits
	.align	2
	.global	FlashProgPages
	.type	FlashProgPages, %function
FlashProgPages:
	stp	x29, x30, [sp, -160]!
	ubfiz	x1, x1, 5, 32
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR0
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR153
	stp	w3, w2, [x29, 104]
	add	x2, x21, :lo12:.LANCHOR0
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR105
	stp	x27, x28, [sp, 80]
	mov	x19, x0
	ldrh	w23, [x2, 12]
	add	x20, x0, x1
	stp	x25, x26, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR153
	mov	x25, x0
	add	x28, x24, :lo12:.LANCHOR105
	lsl	w27, w23, 3
.L720:
	cmp	x25, x20
	bne	.L732
	ldr	w0, [x29, 104]
	cbz	w0, .L745
	adrp	x21, .LANCHOR120
	adrp	x22, .LANCHOR122
	mov	x23, x21
	mov	x24, x22
.L734:
	cmp	x19, x20
	beq	.L745
	ldr	x1, [x21, #:lo12:.LANCHOR120]
	ldr	x0, [x22, #:lo12:.LANCHOR122]
	str	wzr, [x1]
	str	wzr, [x0]
	stp	x1, x0, [x29, 136]
	mov	w1, 1
	ldr	w2, [x19, 4]
	add	x0, x29, 128
	str	w2, [x29, 132]
	ldr	w2, [x29, 108]
	bl	FlashReadPages
	ldr	w26, [x29, 128]
	cmn	w26, #1
	bne	.L735
	ldr	w1, [x19, 4]
	adrp	x0, .LC85
	add	x0, x0, :lo12:.LC85
	bl	printf
	str	w26, [x19]
.L735:
	ldr	x0, [x19, 16]
	cbz	x0, .L736
	ldr	w2, [x0]
	ldr	x0, [x24, #:lo12:.LANCHOR122]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L736
	ldr	w1, [x19, 4]
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L736:
	ldr	x0, [x19, 8]
	cbz	x0, .L737
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR120]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L737
	ldr	w1, [x19, 4]
	adrp	x0, .LC87
	add	x0, x0, :lo12:.LC87
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L737:
	add	x19, x19, 32
	b	.L734
.L732:
	ldr	x0, [x25, 8]
	cbz	x0, .L721
	ldr	x0, [x25, 16]
	cbnz	x0, .L722
.L721:
	adrp	x0, .LC1
	mov	w2, 130
	mov	x1, x22
	add	x0, x0, :lo12:.LC1
	bl	printf
.L722:
	ldr	w0, [x25, 4]
	add	x2, x29, 120
	add	x1, x29, 124
	bl	l2p_addr_tran.isra.0
	ldr	w0, [x29, 120]
	cbnz	w0, .L723
	ldr	w0, [x29, 124]
	cmp	w27, w0
	bls	.L723
	adrp	x21, .LANCHOR153
	adrp	x22, .LC79
	mov	w23, -1
	add	x21, x21, :lo12:.LANCHOR153
	add	x22, x22, :lo12:.LC79
	b	.L756
.L725:
	ldr	w2, [x19, 4]
	mov	x1, x21
	str	w23, [x19]
	mov	x0, x22
	add	x19, x19, 32
	bl	printf
	ldr	x1, [x19, -24]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	rknand_print_hex
	ldr	x1, [x19, -16]
	mov	w3, 4
	adrp	x0, .LC81
	mov	w2, w3
	add	x0, x0, :lo12:.LC81
	bl	rknand_print_hex
.L756:
	cmp	x19, x20
	bne	.L725
.L745:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L723:
	ldr	x1, [x25, 8]
	tst	x1, 63
	beq	.L739
	adrp	x0, .LANCHOR120
	ldr	x26, [x0, #:lo12:.LANCHOR120]
	cmp	x1, x26
	beq	.L726
	adrp	x0, .LANCHOR12
	ldrh	w2, [x0, #:lo12:.LANCHOR12]
	mov	x0, x26
	lsl	w2, w2, 9
	bl	ftl_memcpy
.L726:
	add	x0, x24, :lo12:.LANCHOR105
	ldr	w1, [x29, 124]
	ldr	x3, [x25, 16]
	mov	x2, x26
	ldr	x6, [x0, 16]
	ldrb	w0, [x29, 120]
	blr	x6
	cbnz	w0, .L727
	str	wzr, [x25]
.L728:
	add	x0, x21, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L730
	ldrb	w0, [x29, 120]
	add	x2, x26, 2048
	ldr	x6, [x28, 16]
	ldr	w1, [x29, 124]
	ldr	x3, [x25, 16]
	add	w1, w23, w1
	add	x3, x3, 8
	blr	x6
	cbz	w0, .L730
	mov	w0, -1
	str	w0, [x25]
.L730:
	add	x25, x25, 32
	b	.L720
.L739:
	mov	x26, x1
	b	.L726
.L727:
	mov	w0, -1
	str	w0, [x25]
	b	.L728
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FtlLowFormatEraseBlock,"ax",@progbits
	.align	2
	.global	FtlLowFormatEraseBlock
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	stp	x29, x30, [sp, -128]!
	adrp	x7, .LANCHOR13
	add	x7, x7, :lo12:.LANCHOR13
	mov	x5, 0
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 65535
	adrp	x0, .LANCHOR111
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR3
	stp	x25, x26, [sp, 64]
	and	w22, w1, 255
	str	w23, [x0, #:lo12:.LANCHOR111]
	adrp	x21, .LANCHOR106
	adrp	x0, .LANCHOR119
	adrp	x1, .LANCHOR124
	adrp	x25, .LANCHOR24
	ldrh	w8, [x20, #:lo12:.LANCHOR3]
	ldr	x6, [x21, #:lo12:.LANCHOR106]
	mov	w24, 0
	ldr	x10, [x0, #:lo12:.LANCHOR119]
	mov	w19, 0
	ldr	x11, [x1, #:lo12:.LANCHOR124]
	ldrh	w12, [x25, #:lo12:.LANCHOR24]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 112]
.L759:
	cmp	w8, w5, uxth
	bhi	.L763
	cbz	w24, .L758
	mov	w2, w24
	ubfiz	x24, x24, 5, 16
	mov	x26, 0
	mov	w1, 0
	mov	x0, x6
	bl	FlashEraseBlocks
.L767:
	ldr	x0, [x21, #:lo12:.LANCHOR106]
	add	x1, x0, x26
	ldr	w0, [x0, x26]
	cmn	w0, #1
	bne	.L766
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L766:
	add	x26, x26, 32
	cmp	x26, x24
	bne	.L767
	cbz	w22, .L780
	adrp	x0, .LANCHOR20
	mov	w26, 1
	ldrh	w28, [x0, #:lo12:.LANCHOR20]
.L768:
	add	x0, x20, :lo12:.LANCHOR3
	adrp	x27, .LANCHOR13
	str	x0, [x29, 120]
	mov	w24, 0
	add	x0, x27, :lo12:.LANCHOR13
	str	x0, [x29, 104]
.L776:
	ldr	x0, [x29, 120]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR106]
	mov	w20, 0
	ldrh	w11, [x25, #:lo12:.LANCHOR24]
	ldrh	w7, [x0]
	adrp	x0, .LANCHOR118
	ldr	x8, [x0, #:lo12:.LANCHOR118]
	ldr	x0, [x29, 112]
	ldr	x10, [x0, #:lo12:.LANCHOR119]
.L769:
	cmp	w7, w5, uxth
	bhi	.L772
	cbz	w20, .L758
	mov	w1, w20
	mov	w3, 1
	mov	w2, w26
	mov	x0, x6
	bl	FlashProgPages
	mov	x27, 0
	ubfiz	x1, x20, 5, 16
.L775:
	ldr	x0, [x21, #:lo12:.LANCHOR106]
	add	x3, x0, x27
	ldr	w0, [x0, x27]
	cbz	w0, .L774
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	str	x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldr	x1, [x29, 96]
.L774:
	add	x27, x27, 32
	cmp	x1, x27
	bne	.L775
	add	w24, w24, 1
	cmp	w28, w24, uxth
	bhi	.L776
	mov	x24, 0
.L778:
	cbz	w22, .L777
	ldr	x0, [x21, #:lo12:.LANCHOR106]
	add	x1, x0, x24
	ldr	w0, [x0, x24]
	cbnz	w0, .L777
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.L777:
	add	x24, x24, 32
	cmp	x24, x27
	bne	.L778
	cmp	w23, 63
	ccmp	w22, 0, 0, hi
	beq	.L758
	ldr	x0, [x21, #:lo12:.LANCHOR106]
	mov	w2, w20
	mov	w1, w26
	bl	FlashEraseBlocks
.L758:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L763:
	lsl	x0, x5, 5
	mov	w1, w23
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w22, .L760
	bl	IsBlkInVendorPart
	cbnz	w0, .L761
.L760:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L762
	ubfiz	x0, x24, 5, 16
	mul	w1, w24, w12
	add	x0, x6, x0
	add	w24, w24, 1
	and	w24, w24, 65535
	lsl	w13, w13, 10
	asr	w1, w1, 2
	add	x1, x11, x1, sxtw 2
	str	w13, [x0, 4]
	stp	x10, x1, [x0, 8]
.L761:
	add	x5, x5, 1
	b	.L759
.L762:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L761
.L780:
	mov	w26, 0
	mov	w28, 2
	b	.L768
.L772:
	lsl	x0, x5, 5
	mov	w1, w23
	str	wzr, [x6, x0]
	ldr	x0, [x29, 104]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w12, w0, 65535
	mov	w13, w12
	cbz	w22, .L770
	bl	IsBlkInVendorPart
	cbnz	w0, .L771
.L770:
	mov	w0, w13
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L771
	ubfiz	x0, x20, 5, 16
	mul	w1, w20, w11
	add	x0, x6, x0
	add	w20, w20, 1
	and	w20, w20, 65535
	add	w12, w24, w12, lsl 10
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	str	w12, [x0, 4]
	stp	x8, x1, [x0, 8]
.L771:
	add	x5, x5, 1
	b	.L769
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
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
	bne	.L802
	ldrh	w0, [x19, 8]
	cbz	w0, .L803
	adrp	x1, .LANCHOR154
	adrp	x0, .LC1
	mov	w2, 641
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC1
	bl	printf
.L803:
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
.L804:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L802:
	ubfiz	x0, x0, 1, 16
	adrp	x1, .LANCHOR123
	adrp	x23, .LANCHOR115
	ldr	x22, [x19, 40]
	ldr	x1, [x1, #:lo12:.LANCHOR123]
	ldrh	w21, [x20, x0]
	adrp	x20, .LANCHOR148
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR148
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR115]
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
	ldr	x3, [x23, #:lo12:.LANCHOR115]
	mov	w2, 0
.L805:
	cmp	w4, w1, uxth
	bhi	.L807
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x20, :lo12:.LANCHOR148
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L804
.L807:
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L806
	add	w2, w2, 1
	and	w2, w2, 65535
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L806:
	add	x1, x1, 1
	b	.L805
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
	adrp	x24, .LANCHOR155
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR20
	stp	x19, x20, [sp, 16]
	mov	w25, w1
	mov	x19, x0
	mov	x27, x2
	add	x23, x23, :lo12:.LANCHOR66
	add	x24, x24, :lo12:.LANCHOR155
	add	x28, x26, :lo12:.LANCHOR20
	stp	x21, x22, [sp, 32]
	mov	w22, 0
.L813:
	ldr	w0, [x23]
	ldrh	w1, [x19, 2]
	add	w0, w0, 1
	str	w0, [x23]
	ldrh	w0, [x26, #:lo12:.LANCHOR20]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L814
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L815
.L814:
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.L815:
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L816
	adrp	x0, .LC1
	mov	w2, 699
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L816:
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L817
	adrp	x0, .LC1
	mov	w2, 700
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L817:
	ldrh	w1, [x19]
	adrp	x21, .LANCHOR148
	ldr	x0, [x19, 16]
	add	x20, x21, :lo12:.LANCHOR148
	mov	w2, 16
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x19, 2]
	str	w3, [x29, 108]
	str	x27, [x20, 8]
	orr	w0, w0, w3, lsl 10
	str	w0, [x20, 4]
	adrp	x0, .LANCHOR123
	ldr	x0, [x0, #:lo12:.LANCHOR123]
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
	ldr	w1, [x21, #:lo12:.LANCHOR148]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L818
	ldr	w1, [x20, 4]
	adrp	x0, .LC88
	add	x0, x0, :lo12:.LC88
	add	w22, w22, 1
	and	w22, w22, 65535
	bl	printf
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L819
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L819:
	cmp	w22, 3
	bls	.L820
	add	x21, x21, :lo12:.LANCHOR148
	adrp	x0, .LC89
	mov	w2, w22
	add	x0, x0, :lo12:.LC89
	ldr	w1, [x21, 4]
	bl	printf
.L821:
	b	.L821
.L820:
	ldr	w0, [x19, 52]
	cbz	w0, .L813
.L835:
	b	.L835
.L818:
	cmp	w0, 1
	beq	.L824
	cmp	w1, 256
	beq	.L824
	ldr	w0, [x19, 56]
	cbz	w0, .L825
.L824:
	str	wzr, [x19, 56]
	b	.L813
.L825:
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
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.global	load_l2p_region
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR32
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	stp	x21, x22, [sp, 32]
	and	x19, x1, 65535
	ldrh	w0, [x24, #:lo12:.LANCHOR32]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cmp	w0, w20
	bcs	.L838
	adrp	x1, .LANCHOR156
	adrp	x0, .LC1
	mov	w2, 485
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC1
	bl	printf
.L838:
	adrp	x27, .LANCHOR134
	ubfiz	x0, x20, 2, 16
	adrp	x22, .LANCHOR55
	ldr	x1, [x27, #:lo12:.LANCHOR134]
	ldr	w23, [x1, x0]
	cbnz	w23, .L839
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
	strh	w20, [x0, x19]
	str	wzr, [x1, 4]
.L840:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L839:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
	adrp	x26, .LANCHOR148
	add	x21, x26, :lo12:.LANCHOR148
	add	x0, x0, x19
	mov	w2, 1
	mov	w1, w2
	str	w23, [x21, 4]
	ldr	x0, [x0, 8]
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR123
	ldr	x0, [x0, #:lo12:.LANCHOR123]
	str	x0, [x21, 16]
	mov	x0, x21
	bl	FlashReadPages
	ldr	x25, [x21, 16]
	ldrh	w0, [x25, 8]
	cmp	w0, w20
	beq	.L841
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC90
	add	x0, x0, :lo12:.LC90
	bl	printf
	ldr	x1, [x21, 16]
	mov	w3, 4
	adrp	x0, .LC91
	mov	w2, w3
	add	x0, x0, :lo12:.LC91
	bl	rknand_print_hex
	ldrh	w3, [x24, #:lo12:.LANCHOR32]
	adrp	x0, .LC92
	ldr	x1, [x27, #:lo12:.LANCHOR134]
	mov	w2, 4
	add	x0, x0, :lo12:.LC92
	bl	rknand_print_hex
.L842:
	ldrh	w0, [x25, 8]
	cmp	w0, w20
	beq	.L843
	adrp	x1, .LANCHOR156
	adrp	x0, .LC1
	mov	w2, 508
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC1
	bl	printf
.L843:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	strh	w20, [x0, x19]
	b	.L840
.L841:
	ldr	w0, [x26, #:lo12:.LANCHOR148]
	cmp	w0, 256
	bne	.L842
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	mov	w1, w20
	add	x0, x0, x19
	ldr	x2, [x0, 8]
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
	bl	FtlMapWritePage
	b	.L842
	.size	load_l2p_region, .-load_l2p_region
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
	adrp	x24, .LANCHOR20
	stp	x25, x26, [sp, 64]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	ldr	x20, [x0, 16]
	ldr	x25, [x0, 40]
	bl	ftl_free_no_use_map_blk
	ldrh	w1, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w1, #5
	cmp	w2, w1
	blt	.L846
	ubfiz	x0, x0, 1, 16
	ldrh	w22, [x20, x0]
	cbz	w22, .L846
	ldr	w1, [x19, 52]
	cbnz	w1, .L846
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x24, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L847
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L847:
	adrp	x26, .LANCHOR148
	adrp	x23, .LANCHOR157
	add	x27, x26, :lo12:.LANCHOR148
	add	x23, x23, :lo12:.LANCHOR157
	mov	w20, 0
.L848:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L855
	mov	w1, 1
	mov	w0, w22
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L846:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x24, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L856
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L856:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L855:
	ubfiz	x0, x20, 2, 16
	add	x28, x25, x0
	ldr	w1, [x25, x0]
	cmp	w22, w1, lsr 10
	bne	.L849
	adrp	x2, .LANCHOR116
	add	x0, x26, :lo12:.LANCHOR148
	ldr	x2, [x2, #:lo12:.LANCHOR116]
	str	x2, [x0, 8]
	adrp	x2, .LANCHOR123
	str	w1, [x0, 4]
	ldr	x21, [x2, #:lo12:.LANCHOR123]
	mov	w2, 1
	str	x21, [x0, 16]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x21, 8]
	cmp	w0, w20
	beq	.L850
	adrp	x0, .LC1
	mov	w2, 611
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.L850:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L851
.L853:
	str	wzr, [x28]
.L852:
	b	.L852
.L851:
	ldrh	w0, [x21, 8]
	cmp	w0, w20
	bne	.L853
	ldrh	w1, [x21]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L853
	ldr	x2, [x27, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.L849:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L848
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
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
	adrp	x20, .LANCHOR148
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
	adrp	x7, .LANCHOR115
	add	x3, x20, :lo12:.LANCHOR148
	mov	x26, x7
	mov	x20, x3
	ldr	x0, [x7, #:lo12:.LANCHOR115]
	str	x0, [x3, 8]
	adrp	x0, .LANCHOR123
	stp	wzr, wzr, [x19, 48]
	ldr	x25, [x0, #:lo12:.LANCHOR123]
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
.L863:
	ldr	w0, [x29, 140]
	cmp	w27, w0
	bge	.L880
	ldr	w0, [x29, 136]
	sxtw	x28, w27
	cmp	w27, w0
	bne	.L864
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
	add	x20, x0, :lo12:.LANCHOR148
.L865:
	cmp	w22, w26
	ble	.L867
.L880:
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR20
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bne	.L869
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L869:
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
.L867:
	ldrh	w0, [x24]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L866
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L866
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L866
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L866:
	add	w22, w22, 1
	sxth	w22, w22
	b	.L865
.L864:
	ldr	x0, [x26, #:lo12:.LANCHOR115]
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
	beq	.L882
	ldrh	w1, [x25]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L882
	ldrh	w1, [x25, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L871
.L882:
	mov	w5, 0
.L872:
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L878
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
	beq	.L876
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L876
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L876
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L876:
	add	w5, w5, 1
	sxth	w5, w5
	b	.L872
.L871:
	ldrh	w5, [x24, #:lo12:.LANCHOR20]
	mov	w0, 0
	ldr	x10, [x26, #:lo12:.LANCHOR115]
	sub	w5, w5, #1
.L873:
	cmp	w0, w5
	blt	.L875
.L878:
	add	w4, w27, 1
	sxth	w27, w4
	b	.L863
.L875:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
	cmp	w23, w1
	bls	.L874
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x10, x2, lsl 2]
	str	w2, [x21, x1]
.L874:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L873
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR27
	adrp	x0, .LANCHOR158
	add	x0, x0, :lo12:.LANCHOR158
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
	.section	.text.FtlLoadMapInfo,"ax",@progbits
	.align	2
	.global	FtlLoadMapInfo
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlL2PDataInit
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
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
	stp	x25, x26, [sp, 64]
	mov	w25, w0
	adrp	x0, .LANCHOR22
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	x20, x1
	ldrh	w24, [x0, #:lo12:.LANCHOR22]
	adrp	x0, .LANCHOR61
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR61]
	mov	w21, w2
	cmp	w25, w1
	bcc	.L897
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	mov	w2, 811
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.L897:
	ldr	w0, [x19, #:lo12:.LANCHOR61]
	cmp	w25, w0
	bcs	.L898
	adrp	x23, .LANCHOR55
	add	w24, w24, 7
	adrp	x0, .LANCHOR33
	ldr	x2, [x23, #:lo12:.LANCHOR55]
	lsr	w22, w25, w24
	and	w22, w22, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR33]
	mov	x0, 0
.L899:
	and	x19, x0, 65535
	cmp	w19, w1
	bcc	.L904
	bl	select_l2p_ram_region
	and	x19, x0, 65535
	ldr	x2, [x23, #:lo12:.LANCHOR55]
	ubfiz	x1, x19, 4, 16
	mov	w26, w0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L905
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L905
	bl	flush_l2p_region
.L905:
	mov	w1, w26
	mov	w0, w22
	bl	load_l2p_region
	b	.L901
.L898:
	mov	w0, -1
	cbnz	w21, .L896
	str	w0, [x20]
.L896:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L904:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L899
.L901:
	mov	x0, 1
	ldr	x1, [x23, #:lo12:.LANCHOR55]
	lsl	x0, x0, x24
	sub	w0, w0, #1
	and	w0, w0, w25
	and	x0, x0, 65535
	add	x1, x1, x19, lsl 4
	cbnz	w21, .L902
	ldr	x1, [x1, 8]
	ldr	w0, [x1, x0, lsl 2]
	str	w0, [x20]
.L903:
	ldr	x0, [x23, #:lo12:.LANCHOR55]
	add	x19, x0, x19, lsl 4
	ldr	w0, [x19, 4]
	cmn	w0, #1
	beq	.L907
	add	w0, w0, 1
	str	w0, [x19, 4]
.L907:
	mov	w0, 0
	b	.L896
.L902:
	ldr	x2, [x1, 8]
	ldr	w3, [x20]
	str	w3, [x2, x0, lsl 2]
	ldr	w0, [x1, 4]
	orr	w0, w0, -2147483648
	str	w0, [x1, 4]
	adrp	x0, .LANCHOR56
	strh	w22, [x0, #:lo12:.LANCHOR56]
	b	.L903
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
	cbnz	w1, .L911
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L912
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
.L913:
	cmp	w1, w4
	beq	.L912
	cmp	w19, w3
	bne	.L914
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cbnz	w0, .L915
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	mov	w2, 1699
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.L915:
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR48]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L912:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L914:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L912
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L913
.L911:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L912
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	adrp	x21, .LANCHOR161
	stp	x27, x28, [sp, 80]
	add	x1, x21, :lo12:.LANCHOR161
	adrp	x20, check_vpc_table
	bl	printf
	add	x19, x20, :lo12:check_vpc_table
	mov	w2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
.L922:
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L924
	adrp	x22, .LANCHOR5
	adrp	x24, .LC95
	add	x22, x22, :lo12:.LANCHOR5
	add	x26, x20, :lo12:check_vpc_table
	add	x24, x24, :lo12:.LC95
	mov	w23, 0
	mov	w19, 0
	adrp	x25, .LANCHOR42
.L925:
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L927
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L928
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
.L929:
	cmp	w22, w26
	bne	.L931
.L928:
	cbz	w23, .L921
	adrp	x0, .LC1
	mov	w2, 2343
	add	x1, x21, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC1
	bl	printf
.L921:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L924:
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L923
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L923:
	add	w22, w22, 1
	b	.L922
.L927:
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L926
	mov	w1, w19
	mov	x0, x24
	bl	printf
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L926
	ldrh	w1, [x26, x27, lsl 1]
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.L926:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L925
.L931:
	ldr	x1, [x27, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L930
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w23, 1
	mov	w1, w19
	mov	x0, x25
	bl	printf
.L930:
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	umull	x19, w19, w28
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L928
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L929
	.size	ftl_check_vpc, .-ftl_check_vpc
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	sub	sp, sp, #96
	adrp	x0, .LC97
	mov	w1, 0
	add	x0, x0, :lo12:.LC97
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR148
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR61
	add	x22, x20, :lo12:.LANCHOR148
	add	x21, x21, :lo12:.LANCHOR61
	str	x23, [sp, 64]
	bl	printf
.L947:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L953
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L953:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L948
	ldr	w2, [x29, 76]
	adrp	x0, .LC98
	mov	w1, w19
	add	x0, x0, :lo12:.LC98
	bl	printf
.L948:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L950
	add	x0, x20, :lo12:.LANCHOR148
	str	wzr, [x20, #:lo12:.LANCHOR148]
	mov	w2, 0
	str	w1, [x0, 4]
	adrp	x1, .LANCHOR115
	str	w19, [x0, 24]
	ldr	x1, [x1, #:lo12:.LANCHOR115]
	str	x1, [x0, 8]
	adrp	x1, .LANCHOR123
	ldr	x23, [x1, #:lo12:.LANCHOR123]
	mov	w1, 1
	str	x23, [x0, 16]
	bl	FlashReadPages
	ldr	w0, [x20, #:lo12:.LANCHOR148]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L951
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L950
.L951:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC99
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC99
	mov	w1, w19
	bl	printf
.L950:
	add	w19, w19, 1
	b	.L947
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR162
	stp	x27, x28, [sp, 80]
	mov	w27, w1
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w28, [x21, #:lo12:.LANCHOR162]
	mov	w0, 65535
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w28, w0
	beq	.L978
	cbnz	w28, .L956
.L957:
	bl	FtlGcPageVarInit
	b	.L958
.L978:
	mov	w28, 0
.L956:
	adrp	x0, .LANCHOR19
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w27
	beq	.L957
.L958:
	mov	w24, 0
.L959:
	ldrh	w0, [x19]
	mov	w22, 65535
	strb	wzr, [x19, 8]
	cmp	w0, w22
	beq	.L960
	adrp	x25, .LANCHOR23
	add	x0, x25, :lo12:.LANCHOR23
	str	x0, [x29, 104]
.L975:
	adrp	x1, .LANCHOR91
	adrp	x23, .LANCHOR112
	add	x5, x19, 16
	mov	w20, 0
	ldr	x6, [x1, #:lo12:.LANCHOR91]
	ldr	x1, [x29, 104]
	ldr	x0, [x23, #:lo12:.LANCHOR112]
	ldrh	w7, [x1]
	adrp	x1, .LANCHOR92
	ldr	x8, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR24
	ldrh	w10, [x1, #:lo12:.LANCHOR24]
	adrp	x1, .LANCHOR3
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L961:
	cmp	x1, x5
	bne	.L963
	mov	w1, w20
	mov	w2, 0
	adrp	x26, .LANCHOR12
	bl	FlashReadPages
	add	x26, x26, :lo12:.LANCHOR12
	ubfiz	x0, x20, 5, 16
	mov	x20, 0
	str	x0, [x29, 112]
.L964:
	ldr	x0, [x29, 112]
	cmp	x20, x0
	bne	.L973
	add	w3, w28, 1
	add	w24, w24, 1
	and	w28, w3, 65535
	cmp	w27, w24
	adrp	x1, .LANCHOR19
	bls	.L974
.L976:
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w28
	bhi	.L975
.L960:
	strh	w28, [x19, 2]
	mov	w0, -1
	strb	wzr, [x19, 6]
	mov	w2, 0
	strh	w0, [x21, #:lo12:.LANCHOR162]
	mov	w1, w28
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L977
.L963:
	ldrh	w4, [x5]
	cmp	w4, w22
	beq	.L962
	ubfiz	x2, x20, 5, 16
	orr	w4, w28, w4, lsl 10
	add	x2, x0, x2
	str	w4, [x2, 4]
	mul	w4, w20, w7
	asr	w4, w4, 2
	add	x4, x6, x4, sxtw 2
	str	x4, [x2, 8]
	mul	w4, w20, w10
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w4, w4, 2
	add	x4, x8, x4, sxtw 2
	str	x4, [x2, 16]
.L962:
	add	x5, x5, 2
	b	.L961
.L973:
	ldr	x1, [x23, #:lo12:.LANCHOR112]
	add	x0, x1, x20
	ldr	w1, [x1, x20]
	ldr	w2, [x0, 4]
	str	w2, [x29, 124]
	cbnz	w1, .L965
	ldr	x25, [x0, 16]
	ldrh	w0, [x25]
	cmp	w0, w22
	bne	.L966
.L965:
	adrp	x0, .LANCHOR42
	ldrh	w1, [x19]
	mov	w28, 0
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x19]
	bl	FtlGcPageVarInit
	b	.L959
.L966:
	ldr	w0, [x25, 8]
	add	x1, x29, 140
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x25, 12]
	ldr	w1, [x29, 140]
	cmp	w0, w1
	beq	.L968
.L971:
	ldp	w2, w0, [x25, 8]
	add	x20, x20, 32
	ldr	w1, [x29, 124]
	bl	FtlGcUpdatePage
	b	.L964
.L968:
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR119
	mov	w2, 0
	mov	w1, 1
	ldr	x0, [x0, #:lo12:.LANCHOR119]
	str	x0, [x29, 152]
	adrp	x0, .LANCHOR124
	ldr	x0, [x0, #:lo12:.LANCHOR124]
	str	x0, [x29, 160]
	add	x0, x29, 144
	bl	FlashReadPages
	ldrh	w1, [x26]
	mov	x0, 0
	ldr	x2, [x23, #:lo12:.LANCHOR112]
	ldr	x6, [x29, 152]
	add	x2, x2, x20
	ubfiz	x1, x1, 9, 16
.L969:
	cmp	x0, x1
	beq	.L971
	ldr	x7, [x2, 8]
	ldr	w8, [x7, x0]
	add	x0, x0, 4
	add	x7, x6, x0
	ldr	w7, [x7, -4]
	cmp	w8, w7
	beq	.L969
	ldrh	w1, [x19]
	adrp	x0, .LC100
	ldr	w2, [x29, 148]
	add	x0, x0, :lo12:.LC100
	bl	printf
	b	.L965
.L974:
	ldrh	w0, [x21, #:lo12:.LANCHOR162]
	cmp	w0, w22
	beq	.L976
	add	w0, w0, w24
	strh	w0, [x21, #:lo12:.LANCHOR162]
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w28
	bls	.L976
.L977:
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlReadRefresh,"ax",@progbits
	.align	2
	.global	FtlReadRefresh
	.type	FtlReadRefresh, %function
FtlReadRefresh:
	adrp	x1, .LANCHOR81
	add	x0, x1, :lo12:.LANCHOR81
	ldr	w2, [x0, 80]
	cbz	w2, .L986
	adrp	x1, .LANCHOR61
	ldr	w3, [x0, 84]
	ldr	w2, [x1, #:lo12:.LANCHOR61]
	cmp	w3, w2
	bcs	.L987
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	add	x20, x1, :lo12:.LANCHOR61
	str	x21, [sp, 32]
	mov	w21, 2048
.L992:
	ldr	w0, [x19, 84]
	ldr	w1, [x20]
	cmp	w0, w1
	bcs	.L989
	add	x1, x29, 60
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x19, 84]
	ldr	w1, [x29, 60]
	add	w0, w0, 1
	str	w0, [x19, 84]
	cmn	w1, #1
	beq	.L990
	str	w0, [x29, 88]
	adrp	x0, .LANCHOR121
	str	w1, [x29, 68]
	mov	w2, 0
	ldr	x0, [x0, #:lo12:.LANCHOR121]
	mov	w1, 1
	str	x0, [x29, 72]
	add	x0, x29, 96
	str	x0, [x29, 80]
	add	x0, x29, 160
	str	wzr, [x0, -96]!
	bl	FlashReadPages
	ldr	w0, [x29, 64]
	cmp	w0, 256
	bne	.L989
	ldr	w0, [x29, 60]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
.L989:
	ldp	x19, x20, [sp, 16]
	mov	w0, -1
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 160
	ret
.L990:
	subs	w21, w21, #1
	bne	.L992
	b	.L989
.L987:
	adrp	x1, .LANCHOR62
	str	wzr, [x0, 84]
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	stp	w1, wzr, [x0, 76]
.L996:
	mov	w0, 0
	ret
.L986:
	ldr	w4, [x0, 76]
	adrp	x0, .LANCHOR62
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	add	w0, w2, 1048576
	cmp	w4, w0
	bhi	.L995
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	lsr	w3, w0, 10
	mov	w0, 33554432
	asr	w0, w0, w3
	add	w0, w0, w4
	cmp	w2, w0
	bhi	.L995
	adrp	x0, .LANCHOR39+28
	ldrb	w0, [x0, #:lo12:.LANCHOR39+28]
	cbnz	w0, .L996
.L995:
	add	x0, x1, :lo12:.LANCHOR81
	mov	w1, 1
	str	wzr, [x0, 84]
	stp	w2, w1, [x0, 76]
	b	.L996
	.size	FtlReadRefresh, .-FtlReadRefresh
	.section	.text.FtlMapBlkWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDump_data
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
	ldr	w1, [x0, 56]
	cbz	w1, .L1002
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR148
	adrp	x2, .LANCHOR123
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x0, 6]
	adrp	x0, .LANCHOR116
	ldr	x2, [x2, #:lo12:.LANCHOR123]
	ldr	x3, [x0, #:lo12:.LANCHOR116]
	add	x0, x1, :lo12:.LANCHOR148
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
	cbz	w2, .L1004
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L1005:
	add	x1, x21, :lo12:.LANCHOR148
	mov	x0, x19
	ldr	x21, [sp, 32]
	ldr	x2, [x1, 8]
	mov	w1, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	FtlMapWritePage
.L1004:
	adrp	x0, .LANCHOR23
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR23]
	mov	x0, x3
	bl	ftl_memset
	b	.L1005
.L1002:
	ret
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
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
	bls	.L1011
	adrp	x20, .LANCHOR121
	mov	w2, 32
	mov	w1, 165
	lsl	w19, w19, 10
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	str	x0, [x29, 40]
	add	x0, x29, 64
	str	x0, [x29, 48]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	str	w19, [x29, 36]
	mov	w2, 1
	add	x0, x29, 32
	mov	w1, w2
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
.L1009:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 128
	ret
.L1011:
	mov	w19, 0
	b	.L1009
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR123
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR148
	stp	x21, x22, [sp, 32]
	add	x19, x20, :lo12:.LANCHOR148
	adrp	x22, .LANCHOR115
	ldr	x1, [x23, #:lo12:.LANCHOR123]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR37
	str	x27, [sp, 80]
	add	x25, x21, :lo12:.LANCHOR37
	ldr	x0, [x22, #:lo12:.LANCHOR115]
	adrp	x26, .LANCHOR10
	stp	x0, x1, [x19, 8]
	adrp	x1, .LANCHOR23
	adrp	x27, .LANCHOR137
	add	x25, x25, 32
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w24, 0
	add	x26, x26, :lo12:.LANCHOR10
	add	x27, x27, :lo12:.LANCHOR137
	mov	w1, 0
	bl	ftl_memset
.L1014:
	ldrh	w0, [x26]
	cmp	w24, w0
	blt	.L1015
	add	x20, x20, :lo12:.LANCHOR148
	add	x19, x21, :lo12:.LANCHOR37
	mov	w2, 16
	mov	w1, 255
	adrp	x24, .LC101
	adrp	x26, .LANCHOR20
	ldr	x27, [x20, 16]
	add	x24, x24, :lo12:.LC101
	add	x26, x26, :lo12:.LANCHOR20
	mov	w25, 0
	mov	x0, x27
	bl	ftl_memset
	mov	w0, -3887
	strh	w0, [x27]
	ldr	w0, [x19, 8]
	str	w0, [x27, 4]
	ldrh	w0, [x21, #:lo12:.LANCHOR37]
	mov	w21, 0
	strh	w0, [x27, 2]
	ldrh	w0, [x19, 4]
	strh	w0, [x27, 8]
	ldrh	w0, [x19, 6]
	strh	w0, [x27, 10]
	adrp	x0, .LANCHOR2
	ldr	w0, [x0, #:lo12:.LANCHOR2]
	strh	w0, [x27, 12]
.L1016:
	ldrh	w1, [x19]
	ldrh	w4, [x27, 10]
	ldrh	w2, [x19, 2]
	ldrh	w3, [x19, 4]
	ldr	x0, [x22, #:lo12:.LANCHOR115]
	str	x0, [x20, 8]
	ldr	x0, [x23, #:lo12:.LANCHOR123]
	str	x0, [x20, 16]
	orr	w0, w2, w1, lsl 10
	str	wzr, [x20]
	str	w0, [x20, 4]
	mov	x0, x24
	bl	printf
	ldrh	w0, [x26]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1017
	ldr	w0, [x19, 8]
	mov	w2, 1
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	str	w0, [x27, 4]
	ldrh	w0, [x19]
	strh	w0, [x27, 8]
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR106
	strh	w1, [x19]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR106]
	str	w1, [x20, 4]
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
.L1017:
	mov	w3, 1
	mov	x0, x20
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1018
	ldr	w1, [x20, 4]
	add	w21, w21, 1
	adrp	x0, .LC102
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC102
	bl	printf
	cmp	w21, 3
	bls	.L1016
	ldr	w1, [x20, 4]
	adrp	x0, .LC103
	mov	w2, w21
	add	x0, x0, :lo12:.LC103
	bl	printf
.L1020:
	b	.L1020
.L1015:
	ldrh	w2, [x27]
	ldr	x1, [x25], 8
	ldr	x0, [x19, 8]
	mul	w3, w24, w2
	lsl	w2, w2, 2
	add	w24, w24, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L1014
.L1021:
	mov	w25, 1
	b	.L1016
.L1018:
	cbz	w25, .L1021
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
	add	x24, x28, :lo12:.LANCHOR48
	stp	x19, x20, [sp, 16]
	adrp	x27, .LANCHOR45
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	add	x0, x27, :lo12:.LANCHOR45
	stp	x25, x26, [sp, 64]
	str	x0, [x29, 104]
.L1024:
	ldr	x1, [x29, 104]
	adrp	x23, .LANCHOR5
	ldrh	w0, [x28, #:lo12:.LANCHOR48]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L1025
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2615
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1025:
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	cmp	x19, x0
	bne	.L1051
	adrp	x1, .LANCHOR87
	ldrh	w0, [x24]
	ldr	w1, [x1, #:lo12:.LANCHOR87]
	mul	w1, w0, w1
	lsr	w0, w0, 1
	add	w0, w0, 1
	add	w1, w0, w1, lsr 2
	ands	w1, w1, 65535
	beq	.L1026
	sub	w1, w1, #1
	and	w1, w1, 65535
.L1026:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_pop_index_node
	and	w22, w0, 65535
	ldrh	w0, [x24]
	cbnz	w0, .L1027
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2624
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1027:
	ldrh	w0, [x24]
	sub	w0, w0, #1
	strh	w0, [x24]
	ldrh	w0, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w22
	bls	.L1024
	adrp	x25, .LANCHOR42
	ubfiz	x20, x22, 1, 16
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w21, [x0, x20]
	cbnz	w21, .L1024
	strh	w22, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1029
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	mov	w1, -1
	strh	w1, [x0, x20]
	mov	w0, w22
	bl	INSERT_DATA_LIST
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x24]
	add	w0, w0, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L1024
	mov	w2, 2638
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1024
.L1051:
	mov	w1, 0
	b	.L1026
.L1029:
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x24]
	add	w0, w0, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L1031
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2641
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1031:
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR106
	add	x26, x19, 16
	mov	w6, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	x4, x26
	ldr	x3, [x25, #:lo12:.LANCHOR106]
	ubfiz	x0, x0, 5, 16
	add	x1, x3, 8
	add	x0, x0, 8
	add	x0, x3, x0
.L1032:
	cmp	x0, x1
	bne	.L1034
	cbnz	w21, .L1035
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2652
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1035:
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w22
	bne	.L1036
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2654
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1036:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR43
	adrp	x7, .LANCHOR14
	adrp	x5, .LANCHOR72
	adrp	x4, .LANCHOR73
	ldr	x1, [x6, #:lo12:.LANCHOR43]
	cbnz	w0, .L1037
	ldrh	w0, [x1, x20]
	cbz	w0, .L1038
	ldrh	w2, [x7, #:lo12:.LANCHOR14]
	add	w0, w0, w2
.L1062:
	strh	w0, [x1, x20]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR72]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR72]
	mov	w0, w22
	bl	ftl_set_blk_mode
.L1040:
	ldr	x0, [x6, #:lo12:.LANCHOR43]
	ldrh	w1, [x0, x20]
	adrp	x0, .LANCHOR76
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	cmp	w1, w2
	bls	.L1041
	str	w1, [x0, #:lo12:.LANCHOR76]
.L1041:
	ldr	w2, [x5, #:lo12:.LANCHOR72]
	ldr	w1, [x4, #:lo12:.LANCHOR73]
	ldrh	w0, [x7, #:lo12:.LANCHOR14]
	madd	w0, w0, w2, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR74
	str	w0, [x1, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR127
	ldr	x1, [x0, #:lo12:.LANCHOR127]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR106]
	ubfiz	x1, x21, 5, 16
	add	x1, x1, 4
	add	x2, x0, 4
	add	x1, x0, x1
.L1042:
	cmp	x1, x2
	bne	.L1043
	ldrb	w1, [x19, 8]
	mov	w2, w21
	mov	x23, 0
	bl	FlashEraseBlocks
	mov	w1, 0
.L1044:
	cmp	w21, w23, uxth
	bhi	.L1046
	cbz	w1, .L1047
	mov	w0, w22
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1047:
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1048
	adrp	x0, .LANCHOR42
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	w1, [x0, x20]
	b	.L1024
.L1034:
	ldrh	w2, [x4]
	stp	xzr, xzr, [x1]
	cmp	w2, w6
	beq	.L1033
	ubfiz	x5, x21, 5, 16
	add	w21, w21, 1
	add	x5, x3, x5
	and	w21, w21, 65535
	lsl	w2, w2, 10
	str	w2, [x5, 4]
.L1033:
	add	x1, x1, 32
	add	x4, x4, 2
	b	.L1032
.L1038:
	mov	w0, 2
	b	.L1062
.L1037:
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
	ldr	w0, [x4, #:lo12:.LANCHOR73]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR73]
	mov	w0, w22
	bl	ftl_set_blk_mode.part.6
	b	.L1040
.L1043:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 32
	b	.L1042
.L1046:
	ldr	x2, [x25, #:lo12:.LANCHOR106]
	lsl	x0, x23, 5
	add	x3, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1045
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
.L1045:
	add	x23, x23, 1
	add	x26, x26, 2
	b	.L1044
.L1048:
	adrp	x1, .LANCHOR19
	adrp	x2, .LANCHOR70
	strh	wzr, [x19, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	strh	w22, [x19]
	strb	wzr, [x19, 6]
	mul	w0, w0, w1
	ldr	w1, [x2, #:lo12:.LANCHOR70]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR70]
	adrp	x1, .LANCHOR42
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w0, [x1, x20]
	ldrh	w0, [x19, 4]
	cbz	w0, .L1049
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1050
.L1049:
	adrp	x1, .LANCHOR163
	adrp	x0, .LC1
	mov	w2, 2707
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1050:
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
	cbz	w0, .L1064
	adrp	x23, .LANCHOR102
	add	x24, x23, :lo12:.LANCHOR102
	mov	w19, 0
.L1065:
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w0, w19
	bhi	.L1071
	bl	FtlGcReFreshBadBlk
.L1064:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1071:
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR101
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L1066:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L1070
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1065
.L1070:
	add	x0, x23, :lo12:.LANCHOR102
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L1067
	mov	w1, w26
	adrp	x0, .LC104
	add	x0, x0, :lo12:.LC104
	bl	printf
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L1068:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L1069
	sub	w1, w1, #1
	strh	w1, [x22]
.L1067:
	and	w20, w27, 65535
	b	.L1066
.L1069:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L1068
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
	cbnz	w0, .L1077
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w19
	bne	.L1078
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR80]
.L1079:
	adrp	x20, .LANCHOR45
	mov	w1, w19
	adrp	x0, .LANCHOR41
	add	x0, x0, :lo12:.LANCHOR41
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L1081
	adrp	x1, .LANCHOR164
	adrp	x0, .LC1
	mov	w2, 2777
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1081:
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
	ble	.L1085
	adrp	x1, .LANCHOR164
	adrp	x0, .LC1
	mov	w2, 2780
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1085:
	mov	w0, 1
	b	.L1076
.L1078:
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L1084
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L1084
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bne	.L1079
.L1084:
	mov	w0, 0
.L1076:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1077:
	mov	w0, w19
	bl	List_update_data_list
	b	.L1084
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
	beq	.L1088
	adrp	x21, .LANCHOR42
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L1089
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x0, x20]
	cbz	w0, .L1090
.L1095:
	mov	w20, 0
.L1087:
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1090:
	mov	w2, 2795
	adrp	x1, .LANCHOR165
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1095
.L1089:
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L1088:
	adrp	x21, .LANCHOR142
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR142]
	cmp	w0, w1
	bne	.L1092
	strh	w19, [x21, #:lo12:.LANCHOR142]
	b	.L1095
.L1092:
	cmp	w19, w0
	beq	.L1095
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR41
	strh	w19, [x21, #:lo12:.LANCHOR142]
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
	cbnz	w1, .L1087
	cmp	w19, w0, uxth
	beq	.L1087
	mov	w2, 2811
	adrp	x1, .LANCHOR165
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1087
	.size	decrement_vpc_count, .-decrement_vpc_count
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
	beq	.L1219
	ldrb	w0, [x19, 6]
	str	w0, [x29, 164]
	adrp	x0, .LANCHOR19
	ldrh	w26, [x19, 2]
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR19]
	cmp	w2, w26
	bne	.L1099
	strh	wzr, [x19, 4]
.L1225:
	strb	wzr, [x19, 6]
.L1219:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1099:
	ldrh	w0, [x19, 16]
	mov	w20, 0
.L1100:
	cmp	w0, w1
	beq	.L1101
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	mov	w23, w0
	cmn	w0, #1
	beq	.L1102
	adrp	x1, .LANCHOR91
	adrp	x2, .LANCHOR3
	adrp	x20, .LANCHOR112
	add	x4, x19, 16
	ldr	x5, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR23
	ldr	x0, [x20, #:lo12:.LANCHOR112]
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
.L1103:
	cmp	x4, x1
	bne	.L1107
	mov	w2, 0
	mov	w1, w22
	bl	FlashReadPages
	adrp	x0, .LANCHOR71
	ldr	x4, [x20, #:lo12:.LANCHOR112]
	and	w10, w23, 65535
	add	x7, x0, :lo12:.LANCHOR71
	ldr	w21, [x0, #:lo12:.LANCHOR71]
	mov	x11, x4
	mov	w6, 65535
	mov	w3, 0
	sub	w21, w21, #1
	str	x0, [x29, 144]
.L1108:
	cmp	w22, w3
	bne	.L1113
	add	w22, w23, 1
	ldr	w0, [x4, 4]
	and	w22, w22, 65535
.L1221:
	lsr	w0, w0, 10
	bl	P2V_plane
	and	w27, w0, 65535
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w22
	bne	.L1115
	strh	w22, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L1115:
	ldr	w0, [x29, 164]
	cmp	w22, w26
	cset	w1, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w1, w0
	beq	.L1116
.L1226:
	mov	w2, w27
	mov	w1, w22
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L1219
.L1101:
	add	w20, w20, 1
	and	w20, w20, 65535
	add	x0, x19, x20, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L1100
.L1102:
	cbz	w26, .L1104
	adrp	x1, .LANCHOR166
	adrp	x0, .LC1
	mov	w2, 1766
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1104:
	ldr	w0, [x29, 164]
	cmp	w0, 0
	ccmp	w20, w0, 4, ne
	beq	.L1105
	adrp	x1, .LANCHOR166
	adrp	x0, .LC1
	mov	w2, 1767
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1105:
	strh	wzr, [x19, 2]
	b	.L1225
.L1107:
	ldrh	w3, [x4]
	cmp	w3, w10
	beq	.L1106
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
.L1106:
	add	x4, x4, 2
	b	.L1103
.L1113:
	ldr	w0, [x11]
	cbnz	w0, .L1109
	ldr	x8, [x11, 16]
	ldr	w5, [x8, 4]
	cmn	w5, #1
	beq	.L1110
	ldr	w1, [x7]
	mov	w0, w5
	bl	ftl_cmp_data_ver
	cbz	w0, .L1110
	add	w5, w5, 1
	str	w5, [x7]
.L1110:
	ldr	w0, [x8]
	cmn	w0, #1
	bne	.L1112
	ubfiz	x3, x3, 5, 16
	and	w22, w23, 65535
	add	x3, x4, x3
	ldr	w0, [x3, 4]
	b	.L1221
.L1109:
	mov	w6, w10
.L1112:
	add	w3, w3, 1
	add	x11, x11, 32
	and	w3, w3, 65535
	b	.L1108
.L1116:
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1117
	ldrb	w0, [x19, 8]
	cbnz	w0, .L1118
.L1117:
	adrp	x25, .LANCHOR145
	and	w28, w23, 65535
	ldr	w0, [x25, #:lo12:.LANCHOR145]
	cmn	w0, #1
	bne	.L1119
	str	w21, [x25, #:lo12:.LANCHOR145]
.L1119:
	add	w0, w26, 7
	cmp	w0, w23, uxth
	bge	.L1168
	sub	w24, w28, #7
	and	w24, w24, 65535
.L1120:
	ldr	x0, [x29, 152]
	mov	w3, 65535
	mov	w5, 1
	add	x4, x0, :lo12:.LANCHOR3
.L1121:
	cmp	w24, w28
	bhi	.L1131
	ldrh	w1, [x4]
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	add	x1, x1, 8
	ldr	x2, [x29, 168]
	add	x1, x19, x1, lsl 1
	b	.L1132
.L1168:
	mov	w24, w26
	b	.L1120
.L1123:
	ldrh	w6, [x2]
	cmp	w6, w3
	beq	.L1122
	ubfiz	x7, x23, 5, 16
	add	w23, w23, 1
	add	x7, x0, x7
	and	w23, w23, 65535
	orr	w6, w24, w6, lsl 10
	str	w6, [x7, 4]
.L1122:
	add	x2, x2, 2
.L1132:
	cmp	x2, x1
	bne	.L1123
	mov	w1, w23
	mov	w2, 0
	str	w5, [x29, 112]
	ubfiz	x23, x23, 5, 16
	str	w3, [x29, 120]
	add	x23, x23, 16
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x2, [x20, #:lo12:.LANCHOR112]
	ldr	w1, [x25, #:lo12:.LANCHOR145]
	ldr	w5, [x29, 112]
	add	x0, x2, 16
	ldr	w3, [x29, 120]
	add	x23, x2, x23
	ldr	x4, [x29, 136]
	mov	w2, 0
.L1124:
	cmp	x23, x0
	bne	.L1129
	cbz	w2, .L1130
	str	w1, [x25, #:lo12:.LANCHOR145]
.L1130:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L1121
.L1129:
	ldr	w6, [x0, -16]
	cbz	w6, .L1125
	cbz	w2, .L1118
	str	w1, [x25, #:lo12:.LANCHOR145]
.L1118:
	adrp	x0, .LANCHOR167
	mov	w23, w26
	mov	w1, 1
	adrp	x28, .LANCHOR145
	strh	w1, [x0, #:lo12:.LANCHOR167]
	add	x0, x28, :lo12:.LANCHOR145
	str	x0, [x29, 104]
.L1133:
	ldr	x1, [x29, 152]
	mov	w24, 0
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	mov	w5, 65535
	ldr	x2, [x29, 168]
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1134:
	cmp	x1, x2
	bne	.L1136
	mov	w2, 0
	mov	w1, w24
	bl	FlashReadPages
	mov	x25, 0
	ubfiz	x0, x24, 5, 16
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR168
	add	x0, x0, :lo12:.LANCHOR168
	str	x0, [x29, 120]
.L1137:
	ldr	x0, [x29, 112]
	cmp	x25, x0
	bne	.L1162
	ldr	x0, [x29, 128]
	add	w23, w23, 1
	and	w23, w23, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w23
	bne	.L1133
	ldr	x0, [x29, 152]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.L1163:
	cmp	w0, w1
	beq	.L1219
	ldr	x4, [x29, 168]
	ldrh	w3, [x4], 2
	str	x4, [x29, 168]
	cmp	w3, w2
	beq	.L1164
	strb	w0, [x19, 6]
	b	.L1219
.L1125:
	ldr	x6, [x0]
	ldrh	w7, [x6]
	cmp	w7, w3
	beq	.L1128
	ldr	w6, [x6, 4]
	cmn	w6, #1
	csel	w1, w1, w6, eq
	csel	w2, w2, w5, eq
.L1128:
	add	x0, x0, 32
	b	.L1124
.L1131:
	mov	w0, -1
	str	w0, [x25, #:lo12:.LANCHOR145]
	b	.L1118
.L1136:
	ldrh	w3, [x2]
	cmp	w3, w5
	beq	.L1135
	ubfiz	x4, x24, 5, 16
	add	w24, w24, 1
	add	x4, x0, x4
	and	w24, w24, 65535
	orr	w3, w23, w3, lsl 10
	str	w3, [x4, 4]
.L1135:
	add	x2, x2, 2
	b	.L1134
.L1162:
	ldr	x4, [x20, #:lo12:.LANCHOR112]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 188]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L1138
	ldr	w1, [x29, 164]
	ccmp	w1, w0, 0, eq
	bhi	.L1138
	cmp	w23, w22
	ccmp	w27, w0, 0, eq
	beq	.L1139
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L1140
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L1141
	ldrh	w0, [x19]
.L1223:
	bl	decrement_vpc_count
	b	.L1138
.L1141:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L1142
	ldr	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR71]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L1142
	ldr	x1, [x29, 144]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR71]
.L1142:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 184
	str	w0, [x29, 180]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR145]
	cmn	w1, #1
	beq	.L1143
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L1143
	ldr	w1, [x29, 180]
	cmn	w1, #1
	beq	.L1144
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	mov	w2, 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	str	w1, [x0, 4]
	mov	w1, 1
	str	x3, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	ldr	x3, [x29, 136]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1145
.L1146:
	mov	w0, -1
	str	w0, [x29, 180]
.L1153:
	ldr	w3, [x29, 180]
	cmn	w3, #1
	beq	.L1138
.L1167:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR5
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w24
	bhi	.L1158
	mov	w2, 2019
	adrp	x1, .LANCHOR166
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC1
	str	w24, [x29, 136]
	bl	printf
	ldr	w3, [x29, 136]
.L1158:
	adrp	x1, .LANCHOR42
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1159
	mov	w0, w3
	b	.L1223
.L1144:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	bne	.L1138
	mov	w2, 1
	add	x1, x29, 180
	mov	w0, w24
	bl	log2phys
.L1138:
	add	x25, x25, 32
	b	.L1137
.L1145:
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L1146
	ldr	w0, [x3, 4]
	str	w0, [x29, 136]
	str	x3, [x29, 96]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR145]
	bl	ftl_cmp_data_ver
	cbz	w0, .L1146
	ldp	w0, w1, [x29, 184]
	ldr	x3, [x29, 96]
	cmp	w0, w1
	ldr	w1, [x29, 180]
	bne	.L1148
.L1222:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L1146
.L1148:
	cmp	w0, w1
	beq	.L1146
	cmn	w0, #1
	beq	.L1149
	ldr	x3, [x4, 16]
	mov	w2, 0
	str	w0, [x4, 4]
	mov	w1, 1
	str	x3, [x29, 96]
	mov	x0, x4
	bl	FlashReadPages
	ldr	x3, [x29, 96]
.L1150:
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L1151
	ldr	x0, [x29, 104]
	ldr	w3, [x3, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L1151
	ldr	w0, [x29, 136]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L1146
.L1151:
	ldr	w1, [x29, 180]
	b	.L1222
.L1149:
	str	w0, [x4]
	b	.L1150
.L1143:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	beq	.L1153
	mov	w2, 1
	add	x1, x29, 188
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 184]
	cmn	w3, #1
	beq	.L1153
	ldr	w0, [x29, 180]
	cmp	w3, w0
	beq	.L1167
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR51
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, w0
	beq	.L1157
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	beq	.L1157
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1153
.L1157:
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1153
	ldr	x4, [x29, 136]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L1153
	mov	w2, 1
	add	x1, x29, 184
	mov	w0, w24
	bl	log2phys
	b	.L1153
.L1159:
	mov	w1, w24
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
	b	.L1138
.L1140:
	ldr	x0, [x29, 120]
	ldr	w0, [x0]
	cmp	w0, 31
	bhi	.L1160
	adrp	x1, .LANCHOR169
	add	x1, x1, :lo12:.LANCHOR169
	str	w5, [x1, w0, uxtw 2]
	add	w0, w0, 1
	ldr	x1, [x29, 120]
	str	w0, [x1]
.L1160:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR145]
	cmn	w0, #1
	bne	.L1161
.L1224:
	str	w21, [x28, #:lo12:.LANCHOR145]
	b	.L1138
.L1161:
	cmp	w21, w0
	bcs	.L1138
	b	.L1224
.L1164:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L1163
.L1139:
	strb	w27, [x19, 6]
	strh	w22, [x19, 2]
	b	.L1226
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
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
	cbz	w2, .L1228
	ldrb	w1, [x0, 8]
	cbnz	w1, .L1228
	adrp	x3, .LANCHOR19
	ldrb	w1, [x0, 7]
	ldrh	w3, [x3, #:lo12:.LANCHOR19]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L1228
	ldrb	w0, [x0, 10]
	cbnz	w0, .L1227
	adrp	x0, .LANCHOR61
	mov	w2, 0
	add	x1, x29, 92
	ldr	w21, [x0, #:lo12:.LANCHOR61]
	adrp	x0, .LANCHOR3
	sub	w21, w21, #1
	ldrh	w25, [x0, #:lo12:.LANCHOR3]
	mov	w0, w21
	bl	log2phys
	adrp	x2, .LANCHOR123
	adrp	x0, .LANCHOR115
	ldr	w1, [x29, 92]
	ldr	x20, [x2, #:lo12:.LANCHOR123]
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	cmn	w1, #1
	str	w1, [x29, 100]
	stp	x0, x20, [x29, 104]
	str	w21, [x29, 120]
	str	wzr, [x20, 4]
	beq	.L1230
	mov	w2, 0
	mov	w1, 1
	add	x0, x29, 96
	bl	FlashReadPages
.L1231:
	adrp	x23, .LANCHOR71
	lsl	w25, w25, 2
	add	x22, x19, :lo12:.LANCHOR51
	add	x23, x23, :lo12:.LANCHOR71
	mov	w0, -3947
	mov	w24, 0
	strh	w0, [x20]
.L1232:
	cmp	w25, w24
	bne	.L1236
.L1233:
	add	x19, x19, :lo12:.LANCHOR51
	mov	w0, 1
	strb	w0, [x19, 10]
.L1227:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L1230:
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
	b	.L1231
.L1236:
	ldrh	w0, [x22, 4]
	cbz	w0, .L1233
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
	b	.L1232
.L1228:
	add	x19, x19, :lo12:.LANCHOR51
	strb	wzr, [x19, 10]
	b	.L1227
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
.L1246:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1248
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1248:
	ldr	x1, [x21, #:lo12:.LANCHOR55]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1247
	mov	w0, w19
	bl	flush_l2p_region
.L1247:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1246
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR123
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w0, -1
	stp	x21, x22, [sp, 32]
	str	w0, [x29, 72]
	adrp	x0, .LANCHOR115
	ldr	x21, [x1, #:lo12:.LANCHOR123]
	mov	w1, -3
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	adrp	x22, .LANCHOR71
	str	x21, [x29, 64]
	add	x22, x22, :lo12:.LANCHOR71
	str	x0, [x29, 56]
	ldrh	w20, [x19, 4]
	str	w1, [x21, 8]
	mov	w1, -2
	str	w1, [x21, 12]
	and	w20, w20, 1
	ldrh	w1, [x19]
	add	w20, w20, 6
	strh	w1, [x21, 2]
	strh	wzr, [x21]
	mov	w1, 61589
	str	w1, [x0]
	mov	w1, 22136
	movk	w1, 0x1234, lsl 16
	str	w1, [x0, 4]
.L1256:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1252
.L1253:
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
.L1252:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 52]
	cmn	w0, #1
	beq	.L1253
	ldr	w0, [x22]
	mov	w3, 0
	str	w0, [x21, 4]
	mov	w2, 0
	add	w0, w0, 1
	mov	w1, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x22]
	add	x0, x29, 48
	bl	FlashProgPages
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	subs	w20, w20, #1
	bne	.L1256
	b	.L1253
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
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
	bhi	.L1272
	adrp	x0, .LANCHOR22
	adrp	x25, .LANCHOR12
	adrp	x26, .LANCHOR23
	mov	x24, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR22]
	add	x25, x25, :lo12:.LANCHOR12
	add	x26, x26, :lo12:.LANCHOR23
	mov	w23, 0
	lsr	w21, w28, w21
.L1266:
	cbnz	w20, .L1271
.L1264:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1271:
	ldrh	w1, [x25]
	adrp	x0, .LANCHOR133
	adrp	x27, .LANCHOR117
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	udiv	w22, w28, w1
	ldr	w2, [x0, w21, uxtw 2]
	and	w0, w20, 65535
	msub	w22, w22, w1, w28
	sub	w19, w1, w22
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	cbz	w2, .L1268
	cmp	w19, w1
	beq	.L1268
	ldr	x0, [x27, #:lo12:.LANCHOR117]
	str	x0, [x29, 120]
	add	x0, x29, 144
	str	w2, [x29, 116]
	mov	w2, 1
	str	x0, [x29, 128]
	mov	w1, w2
	add	x0, x29, 112
	bl	FlashReadPages
.L1269:
	lsl	w4, w19, 9
	ldr	x0, [x27, #:lo12:.LANCHOR117]
	lsl	w22, w22, 7
	mov	w2, w4
	mov	x1, x24
	str	w4, [x29, 108]
	add	x0, x0, x22, sxtw 2
	bl	ftl_memcpy
	ldr	x2, [x27, #:lo12:.LANCHOR117]
	mov	w1, w21
	adrp	x0, .LANCHOR158
	add	x0, x0, :lo12:.LANCHOR158
	sub	w20, w20, w19
	add	w28, w28, w19
	add	w21, w21, 1
	bl	FtlMapWritePage
	cmn	w0, #1
	ldr	w4, [x29, 108]
	csinv	w23, w23, wzr, ne
	add	x24, x24, x4, sxtw
	b	.L1266
.L1268:
	ldrh	w2, [x26]
	mov	w1, 0
	ldr	x0, [x27, #:lo12:.LANCHOR117]
	bl	ftl_memset
	b	.L1269
.L1272:
	mov	w23, -1
	b	.L1264
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
	bne	.L1277
	mov	w0, 72
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
.L1277:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x2, .LANCHOR170
	ldrh	w1, [x2, #:lo12:.LANCHOR170]
	cmp	w1, 31
	bhi	.L1283
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR170]
	mov	w1, 1
.L1280:
	adrp	x2, .LANCHOR127
	cbnz	w0, .L1281
	ldr	x0, [x2, #:lo12:.LANCHOR127]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1285
.L1281:
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
.L1283:
	mov	w1, 32
	b	.L1280
.L1285:
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
	stp	x21, x22, [sp, 32]
	mov	w22, w0
	mov	w21, w1
	add	w1, w0, w1
	adrp	x0, .LANCHOR16
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1297
	adrp	x0, .LANCHOR22
	mov	x25, x2
	mov	w24, 0
	adrp	x27, .LANCHOR133
	ldrh	w20, [x0, #:lo12:.LANCHOR22]
	adrp	x0, .LANCHOR12
	add	x0, x0, :lo12:.LANCHOR12
	str	x0, [x29, 104]
	lsr	w20, w22, w20
.L1290:
	cbnz	w21, .L1296
.L1288:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1296:
	ldr	x0, [x27, #:lo12:.LANCHOR133]
	ldr	w4, [x0, w20, uxtw 2]
	ldr	x0, [x29, 104]
	ldrh	w19, [x0]
	and	w0, w21, 65535
	udiv	w23, w22, w19
	msub	w23, w23, w19, w22
	sub	w19, w19, w23
	and	w19, w19, 65535
	cmp	w21, w19
	csel	w19, w0, w19, cc
	lsl	w26, w19, 9
	cbz	w4, .L1292
	adrp	x28, .LANCHOR117
	mov	w2, 1
	str	w4, [x29, 96]
	mov	w1, w2
	ldr	x0, [x28, #:lo12:.LANCHOR117]
	str	x0, [x29, 120]
	add	x0, x29, 144
	str	w4, [x29, 116]
	str	x0, [x29, 128]
	add	x0, x29, 112
	bl	FlashReadPages
	ldr	w0, [x29, 112]
	mov	x5, x28
	ldr	w4, [x29, 96]
	cmn	w0, #1
	adrp	x0, .LANCHOR148
	csinv	w24, w24, wzr, ne
	ldr	w0, [x0, #:lo12:.LANCHOR148]
	cmp	w0, 256
	bne	.L1294
	mov	w2, w4
	mov	w1, w20
	adrp	x0, .LC107
	str	x28, [x29, 96]
	add	x0, x0, :lo12:.LC107
	bl	printf
	ldr	x2, [x28, #:lo12:.LANCHOR117]
	mov	w1, w20
	adrp	x0, .LANCHOR158
	add	x0, x0, :lo12:.LANCHOR158
	bl	FtlMapWritePage
	ldr	x5, [x29, 96]
.L1294:
	ldr	x1, [x5, #:lo12:.LANCHOR117]
	lsl	w23, w23, 7
	mov	w2, w26
	mov	x0, x25
	add	x1, x1, x23, sxtw 2
	bl	ftl_memcpy
.L1295:
	add	w20, w20, 1
	sub	w21, w21, w19
	add	w22, w22, w19
	add	x25, x25, x26, sxtw
	b	.L1290
.L1292:
	mov	w2, w26
	mov	w1, 0
	mov	x0, x25
	bl	ftl_memset
	b	.L1295
.L1297:
	mov	w24, -1
	b	.L1288
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
	beq	.L1300
	adrp	x1, .LC108
	adrp	x0, .LC71
	add	x1, x1, :lo12:.LC108
	add	x0, x0, :lo12:.LC71
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR125]
	lsl	w2, w2, 9
	bl	ftl_memset
.L1300:
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
	beq	.L1303
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR81]
.L1303:
	ldr	w1, [x19, #:lo12:.LANCHOR81]
	add	x0, x19, :lo12:.LANCHOR81
	cmp	w1, w20
	adrp	x1, .LANCHOR73
	bne	.L1304
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
.L1304:
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
	adrp	x25, .LANCHOR123
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR148
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR115
	stp	x27, x28, [sp, 80]
	add	x28, x22, :lo12:.LANCHOR148
	ldr	x27, [x25, #:lo12:.LANCHOR123]
	movk	w2, 0x4654, lsl 16
	stp	x19, x20, [sp, 16]
	add	x20, x1, :lo12:.LANCHOR79
	ldr	x0, [x24, #:lo12:.LANCHOR115]
	adrp	x23, .LANCHOR70
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	mov	w21, 0
	stp	x0, x27, [x28, 8]
	mov	w26, 65535
	strh	w1, [x27, 2]
	mov	w1, -3932
	strh	w1, [x27]
	ldr	w1, [x20, 8]
	stp	w1, wzr, [x27, 4]
	adrp	x1, .LANCHOR39
	add	x19, x1, :lo12:.LANCHOR39
	str	wzr, [x27, 12]
	str	w2, [x1, #:lo12:.LANCHOR39]
	mov	w1, 72
	movk	w1, 0x5000, lsl 16
	str	w1, [x19, 4]
	ldrh	w1, [x20, 6]
	adrp	x2, .LANCHOR51
	strh	w1, [x19, 8]
	adrp	x1, .LANCHOR10
	ldrh	w1, [x1, #:lo12:.LANCHOR10]
	strb	w1, [x19, 10]
	add	x1, x2, :lo12:.LANCHOR51
	ldrh	w2, [x2, #:lo12:.LANCHOR51]
	strh	w2, [x19, 14]
	ldrh	w2, [x1, 2]
	ldrb	w3, [x1, 6]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 16]
	adrp	x2, .LANCHOR52
	add	x1, x2, :lo12:.LANCHOR52
	ldrh	w2, [x2, #:lo12:.LANCHOR52]
	ldrb	w3, [x1, 6]
	strh	w2, [x19, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 20]
	adrp	x2, .LANCHOR53
	add	x1, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	ldrb	w3, [x1, 6]
	strh	w2, [x19, 22]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 13]
	adrp	x1, .LANCHOR72
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	str	w1, [x19, 32]
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	str	w1, [x19, 40]
	adrp	x1, .LANCHOR71
	ldr	w1, [x1, #:lo12:.LANCHOR71]
	str	w1, [x19, 36]
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x28, 8]
	mov	x1, x19
	mov	w2, 48
	adrp	x19, .LANCHOR5
	bl	ftl_memcpy
	adrp	x1, .LANCHOR42
	ldrh	w2, [x19, #:lo12:.LANCHOR5]
	ldr	x0, [x28, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
	ldrh	w1, [x19, #:lo12:.LANCHOR5]
	mov	x19, x20
	ldr	x0, [x28, 8]
	adrp	x20, .LANCHOR20
	add	x20, x20, :lo12:.LANCHOR20
	lsr	w2, w1, 3
	ubfiz	x3, x1, 1, 16
	adrp	x1, .LANCHOR1
	add	x3, x3, 48
	and	x3, x3, -4
	add	w2, w2, 4
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	add	x0, x0, x3
	bl	ftl_memcpy
	mov	w0, 0
	bl	FtlUpdateVaildLpn
	str	x20, [x29, 104]
.L1308:
	ldrh	w2, [x19, 2]
	ldrh	w1, [x19]
	ldr	x0, [x24, #:lo12:.LANCHOR115]
	str	x0, [x28, 8]
	ldr	x0, [x25, #:lo12:.LANCHOR123]
	str	x0, [x28, 16]
	orr	w0, w2, w1, lsl 10
	str	w0, [x28, 4]
	ldrh	w0, [x20]
	sub	w0, w0, #1
	cmp	w2, w0
	blt	.L1309
	ldrh	w26, [x19, 4]
	strh	wzr, [x19, 2]
	strh	w1, [x19, 4]
	bl	FtlFreeSysBlkQueueOut
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	str	w1, [x19, 8]
	add	w2, w1, 1
	str	w2, [x23, #:lo12:.LANCHOR70]
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	strh	w0, [x19]
	strh	w0, [x27, 2]
	str	w1, [x27, 4]
.L1309:
	mov	w3, 1
	mov	x0, x28
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	ldr	w1, [x28]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L1310
	cmp	w0, 1
	bne	.L1311
	adrp	x1, .LANCHOR171
	adrp	x0, .LC1
	mov	w2, 1135
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1311:
	ldrh	w0, [x19, 2]
	cmp	w0, 1
	bne	.L1312
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1312:
	add	w21, w21, 1
	and	w21, w21, 65535
	cmp	w21, 3
	bls	.L1308
	add	x22, x22, :lo12:.LANCHOR148
	adrp	x0, .LC109
	mov	w2, w21
	add	x0, x0, :lo12:.LC109
	ldr	w1, [x22, 4]
	bl	printf
.L1314:
	b	.L1314
.L1310:
	cmp	w0, 1
	beq	.L1308
	cmp	w1, 256
	beq	.L1308
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1315
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.L1315:
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
	bne	.L1328
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1328:
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
	bhi	.L1339
	cmp	w19, 31
	bhi	.L1333
.L1347:
	mov	w0, 0
.L1331:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1333:
	adrp	x21, .LANCHOR12
	ldrh	w1, [x21, #:lo12:.LANCHOR12]
	udiv	w20, w0, w1
	msub	w0, w1, w20, w0
	ands	w0, w0, 65535
	beq	.L1334
	sub	w1, w1, w0
	add	w20, w20, 1
	cmp	w1, w19
	csel	w1, w1, w19, ls
	sub	w19, w19, w1, uxth
.L1334:
	adrp	x22, .LANCHOR172
	adrp	x23, .LANCHOR63
	add	x22, x22, :lo12:.LANCHOR172
	add	x23, x23, :lo12:.LANCHOR63
	mov	w0, -1
	str	w0, [x29, 76]
.L1335:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	cmp	w19, w0
	bcs	.L1337
	adrp	x0, .LANCHOR172
	ldr	w1, [x0, #:lo12:.LANCHOR172]
	cmp	w1, 32
	bls	.L1347
	str	wzr, [x0, #:lo12:.LANCHOR172]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1347
.L1337:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w20
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1336
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
.L1336:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L1335
.L1339:
	mov	w0, -1
	b	.L1331
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.FtlVpcCheckAndModify,"ax",@progbits
	.align	2
	.global	FtlVpcCheckAndModify
	.type	FtlVpcCheckAndModify, %function
FtlVpcCheckAndModify:
	stp	x29, x30, [sp, -96]!
	adrp	x1, .LANCHOR173
	adrp	x0, .LC94
	add	x1, x1, :lo12:.LANCHOR173
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC94
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR128
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR61
	str	x25, [sp, 64]
	bl	printf
	adrp	x0, .LANCHOR6
	mov	w19, 0
	add	x20, x20, :lo12:.LANCHOR61
	mov	w1, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x24, #:lo12:.LANCHOR128]
	lsl	w2, w2, 1
	bl	ftl_memset
.L1349:
	ldr	w0, [x20]
	cmp	w19, w0
	bcc	.L1351
	adrp	x21, .LANCHOR5
	adrp	x22, .LC110
	add	x21, x21, :lo12:.LANCHOR5
	add	x22, x22, :lo12:.LC110
	mov	w19, 0
	adrp	x25, .LANCHOR42
	mov	w23, 65535
.L1352:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L1357
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	ret
.L1351:
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w19
	bl	log2phys
	ldr	w0, [x29, 92]
	cmn	w0, #1
	beq	.L1350
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldr	x2, [x24, #:lo12:.LANCHOR128]
	ubfiz	x0, x0, 1, 16
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
.L1350:
	add	w19, w19, 1
	b	.L1349
.L1357:
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x20, x19, 1, 16
	ldrh	w2, [x0, x20]
	ldr	x0, [x24, #:lo12:.LANCHOR128]
	ldrh	w3, [x0, x20]
	cmp	w2, w3
	beq	.L1354
	cmp	w2, w23
	beq	.L1354
	mov	w1, w19
	mov	x0, x22
	bl	printf
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L1354
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L1354
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L1354
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x20]
	cbnz	w1, .L1356
	ldr	x1, [x24, #:lo12:.LANCHOR128]
	ldrh	w1, [x1, x20]
	strh	w1, [x0, x20]
.L1354:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1352
.L1356:
	ldr	x1, [x24, #:lo12:.LANCHOR128]
	ldrh	w1, [x1, x20]
	strh	w1, [x0, x20]
	mov	w0, w19
	bl	update_vpc_list
	b	.L1354
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
	bcs	.L1363
	adrp	x1, .LANCHOR174
	adrp	x0, .LC1
	mov	w2, 2714
	add	x1, x1, :lo12:.LANCHOR174
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1363:
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1364
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1365
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L1364:
	adrp	x1, .LANCHOR142
	mov	w0, 1
	strb	w0, [x21, 8]
	mov	w2, 65535
	ldrh	w0, [x1, #:lo12:.LANCHOR142]
	mov	x20, x1
	cmp	w0, w2
	beq	.L1366
	cmp	w19, w0
	bne	.L1367
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1368
.L1367:
	bl	update_vpc_list
.L1368:
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR142]
.L1366:
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
.L1365:
	mov	w0, w19
	bl	INSERT_FREE_LIST
	b	.L1364
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
.L1374:
	cmp	x20, x21
	beq	.L1381
	sub	x22, x20, #4
	adrp	x25, .LANCHOR42
	b	.L1382
.L1377:
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x19]
	cmp	w1, w0, uxth
	bne	.L1375
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
.L1375:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1376
	mov	x0, x19
	bl	allocate_new_data_superblock
.L1376:
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
.L1382:
	ldr	w0, [x20, -4]
	cmn	w0, #1
	beq	.L1377
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1378
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 955
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1378:
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
	beq	.L1379
	adrp	x2, .LANCHOR42
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1380
	adrp	x0, .LC111
	mov	w2, 0
	add	x0, x0, :lo12:.LC111
	bl	printf
.L1380:
	mov	w0, w22
	bl	decrement_vpc_count
.L1379:
	add	x20, x20, 32
	b	.L1374
.L1381:
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1373
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 970
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1373:
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
	bne	.L1389
.L1399:
	adrp	x0, .LANCHOR144
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65535
	str	wzr, [x0, #:lo12:.LANCHOR144]
	cmp	w2, w1
	add	x0, x19, :lo12:.LANCHOR53
	bne	.L1412
.L1415:
	mov	w0, 0
.L1388:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1389:
	cbz	w0, .L1392
	adrp	x0, .LANCHOR162
	ldrh	w3, [x0, #:lo12:.LANCHOR162]
	cmp	w3, w2
	beq	.L1393
.L1394:
	mov	w1, 2
.L1392:
	add	x0, x19, :lo12:.LANCHOR53
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L1395
	adrp	x0, .LANCHOR43
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L1396
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L1396:
	adrp	x0, .LANCHOR144
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR144]
	cbnz	w1, .L1397
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1397:
	str	wzr, [x19, #:lo12:.LANCHOR144]
.L1408:
	mov	w0, 1
	b	.L1388
.L1393:
	strh	wzr, [x0, #:lo12:.LANCHOR162]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 17
	bhi	.L1394
	b	.L1392
.L1395:
	adrp	x0, .LANCHOR162
	ldrh	w1, [x0, #:lo12:.LANCHOR162]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1408
	b	.L1399
.L1412:
	ldrb	w0, [x0, 7]
	adrp	x20, .LANCHOR97
	ldrh	w2, [x21, #:lo12:.LANCHOR19]
	ldrh	w1, [x20, #:lo12:.LANCHOR97]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1400
	adrp	x1, .LANCHOR176
	adrp	x0, .LC1
	mov	w2, 162
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1400:
	add	x0, x19, :lo12:.LANCHOR53
	adrp	x23, .LANCHOR42
	ldrh	w3, [x21, #:lo12:.LANCHOR19]
	adrp	x25, .LANCHOR61
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	adrp	x26, .LANCHOR176
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR61
	ldr	x1, [x23, #:lo12:.LANCHOR42]
	add	x26, x26, :lo12:.LANCHOR176
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR67
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	ldr	w2, [x1, #:lo12:.LANCHOR67]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR67]
.L1401:
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	cmp	w0, w21
	bhi	.L1405
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L1406
	bl	INSERT_DATA_LIST
.L1407:
	adrp	x0, .LANCHOR95
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR97]
	strh	w21, [x19, #:lo12:.LANCHOR53]
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR80
	strh	w21, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR48
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L1415
	adrp	x0, .LANCHOR82
	mov	w1, 20
	strh	w1, [x0, #:lo12:.LANCHOR82]
	b	.L1415
.L1405:
	adrp	x0, .LANCHOR98
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR98]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L1402
	adrp	x0, .LC1
	mov	w2, 168
	mov	x1, x26
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1402:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L1403
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L1414:
	bl	decrement_vpc_count
.L1404:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L1401
.L1403:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L1404
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	b	.L1414
.L1406:
	bl	INSERT_FREE_LIST
	b	.L1407
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
	bcc	.L1416
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
	bl	FtlMapBlkWriteDump_data
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR144
	str	wzr, [x0, #:lo12:.LANCHOR144]
.L1416:
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
	adrp	x0, .LANCHOR168
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR51
	add	x19, x19, :lo12:.LANCHOR51
	str	wzr, [x0, #:lo12:.LANCHOR168]
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
	adrp	x20, .LANCHOR113
	ldr	w1, [x19, #:lo12:.LANCHOR89]
	add	x19, x19, :lo12:.LANCHOR89
	ldr	x0, [x20, #:lo12:.LANCHOR113]
	bl	FlashProgPages
	mov	w11, 0
.L1422:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L1425
	ldr	x0, [x20, #:lo12:.LANCHOR113]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR53+4
	ldrh	w0, [x0, #:lo12:.LANCHOR53+4]
	cbnz	w0, .L1426
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L1428
.L1425:
	ldr	x2, [x20, #:lo12:.LANCHOR113]
	ubfiz	x0, x11, 5, 16
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1423
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
.L1428:
	mov	w0, 1
.L1421:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1423:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L1422
.L1426:
	mov	w0, 0
	b	.L1421
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
	beq	.L1430
	add	x1, x0, :lo12:.LANCHOR53
	ldrh	w0, [x1, 4]
	cbnz	w0, .L1431
.L1430:
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
.L1431:
	add	x0, x19, :lo12:.LANCHOR53
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	get_new_active_ppa
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
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
	adrp	x20, .LANCHOR167
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	strh	wzr, [x20, #:lo12:.LANCHOR167]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR79
	ldrh	w1, [x0, #:lo12:.LANCHOR79]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1434
.L1436:
	mov	w23, -1
.L1433:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1434:
	bl	FtlLoadSysInfo
	mov	w23, w0
	cbnz	w0, .L1436
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
	mov	w1, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR55
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	add	x0, x0, 4
.L1437:
	cmp	w1, w3
	bge	.L1442
	ldr	w2, [x0], 16
	tbz	w2, #31, .L1438
.L1442:
	adrp	x0, .LANCHOR39
	add	x4, x0, :lo12:.LANCHOR39
	cmp	w1, w3
	mov	x19, x0
	adrp	x22, .LANCHOR51
	ldrh	w2, [x4, 28]
	add	w2, w2, 1
	strh	w2, [x4, 28]
	bge	.L1447
.L1439:
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
	add	x0, x19, :lo12:.LANCHOR39
	strh	wzr, [x20, 4]
	ldrh	w1, [x0, 30]
	add	w1, w1, 1
	strh	w1, [x0, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	b	.L1443
.L1438:
	add	w1, w1, 1
	b	.L1437
.L1447:
	ldrh	w0, [x20, #:lo12:.LANCHOR167]
	cbnz	w0, .L1439
.L1443:
	bl	FtlVpcCheckAndModify
	add	x20, x22, :lo12:.LANCHOR51
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L1433
	ldrh	w1, [x20, 4]
	cbnz	w1, .L1433
	adrp	x21, .LANCHOR52
	add	x19, x21, :lo12:.LANCHOR52
	ldrh	w1, [x19, 4]
	cbnz	w1, .L1433
	bl	FtlGcRefreshBlock
	ldrh	w0, [x21, #:lo12:.LANCHOR52]
	bl	FtlGcRefreshBlock
	bl	FtlVpcTblFlush
	mov	x0, x20
	bl	allocate_new_data_superblock
	mov	x0, x19
	bl	allocate_new_data_superblock
	b	.L1433
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	stp	x29, x30, [sp, -176]!
	adrp	x1, .LANCHOR108
	add	x29, sp, 0
	ldr	w2, [x1, #:lo12:.LANCHOR108]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x1, [x29, 144]
	cbnz	w2, .L1522
	adrp	x1, .LANCHOR45
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	cmp	w1, 47
	bls	.L1522
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR162
	ldrh	w1, [x0, #:lo12:.LANCHOR162]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1451
.L1454:
	adrp	x0, .LANCHOR100
	mov	w3, 65535
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w2, w3
	bne	.L1452
.L1453:
	bl	FtlReadRefresh
	adrp	x19, .LANCHOR80
	adrp	x2, .LANCHOR84
	ldr	w1, [x29, 152]
	mov	w21, 65535
	ldr	w0, [x2, #:lo12:.LANCHOR84]
	add	w0, w0, 1
	add	w0, w0, w1, lsl 7
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	str	w0, [x2, #:lo12:.LANCHOR84]
	cmp	w1, w21
	bne	.L1455
	adrp	x3, .LANCHOR53
	ldrh	w21, [x3, #:lo12:.LANCHOR53]
	cmp	w21, w1
	bne	.L1525
	adrp	x1, .LANCHOR99
	ldrh	w20, [x1, #:lo12:.LANCHOR99]
	cmp	w20, w21
	bne	.L1455
	adrp	x22, .LANCHOR48
	mov	w3, 1024
	ldrh	w1, [x22, #:lo12:.LANCHOR48]
	cmp	w1, 24
	mov	w1, 5120
	csel	w1, w1, w3, cc
	cmp	w0, w1
	bls	.L1528
	adrp	x0, .LANCHOR177
	str	wzr, [x2, #:lo12:.LANCHOR84]
	strh	wzr, [x0, #:lo12:.LANCHOR177]
	bl	GetSwlReplaceBlock
	and	w21, w0, 65535
	cmp	w21, w20
	bne	.L1529
	adrp	x5, .LANCHOR83
	ldrh	w1, [x22, #:lo12:.LANCHOR48]
	ldrh	w0, [x5, #:lo12:.LANCHOR83]
	cmp	w1, w0
	bcs	.L1458
	mov	w0, 64
	bl	List_get_gc_head_node
	and	w0, w0, 65535
	cmp	w0, w21
	beq	.L1460
	adrp	x1, .LANCHOR42
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cmp	w0, 7
	bhi	.L1461
	mov	w0, 0
	bl	List_get_gc_head_node
	and	w20, w0, 65535
	mov	w0, 128
	strh	w0, [x5, #:lo12:.LANCHOR83]
	cmp	w20, w21
	bne	.L1457
.L1460:
	bl	FtlGcReFreshBadBlk
.L1455:
	ldr	w1, [x29, 152]
	mov	w0, 65535
	cmp	w1, 0
	ccmp	w21, w0, 0, eq
	bne	.L1463
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 24
	bhi	.L1530
	adrp	x1, .LANCHOR19
	cmp	w0, 16
	ldrh	w20, [x1, #:lo12:.LANCHOR19]
	bls	.L1465
	lsr	w20, w20, 5
.L1464:
	adrp	x2, .LANCHOR82
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR82]
	cmp	w1, w0
	bcs	.L1468
	adrp	x0, .LANCHOR53
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bne	.L1469
	adrp	x1, .LANCHOR99
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	cmp	w1, w0
	bne	.L1469
	adrp	x0, .LANCHOR177
	ldrh	w0, [x0, #:lo12:.LANCHOR177]
	cbnz	w0, .L1470
	adrp	x1, .LANCHOR61
	adrp	x4, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	ldr	w4, [x4, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L1471
.L1470:
	adrp	x1, .LANCHOR78
	ldrh	w1, [x1, #:lo12:.LANCHOR78]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR82]
.L1472:
	adrp	x1, .LANCHOR87
	str	wzr, [x1, #:lo12:.LANCHOR87]
.L1449:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1451:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	beq	.L1454
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	cbz	w0, .L1454
	mov	w0, 1
	b	.L1449
.L1452:
	adrp	x1, .LANCHOR99
	ldrh	w4, [x1, #:lo12:.LANCHOR99]
	cmp	w4, w3
	bne	.L1453
	strh	w2, [x1, #:lo12:.LANCHOR99]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR100]
	b	.L1453
.L1461:
	mov	w0, 64
.L1557:
	strh	w0, [x5, #:lo12:.LANCHOR83]
	b	.L1460
.L1458:
	mov	w0, 80
	b	.L1557
.L1529:
	mov	w20, w21
.L1457:
	adrp	x1, .LANCHOR43
	ubfiz	x0, x20, 1, 32
	adrp	x3, .LANCHOR82
	mov	w21, w20
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	adrp	x1, .LANCHOR42
	ldrh	w5, [x3, #:lo12:.LANCHOR82]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w4, [x2, x0]
	ldrh	w2, [x22, #:lo12:.LANCHOR48]
	ldrh	w3, [x1, x0]
	mov	w1, w20
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	b	.L1460
.L1525:
	mov	w21, w1
	b	.L1455
.L1528:
	mov	w21, w20
	b	.L1455
.L1465:
	cmp	w0, 12
	bls	.L1466
	lsr	w20, w20, 4
	b	.L1464
.L1466:
	cmp	w0, 8
	bls	.L1464
	lsr	w20, w20, 2
	b	.L1464
.L1530:
	mov	w20, 1
	b	.L1464
.L1471:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR82]
	b	.L1472
.L1469:
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR82]
.L1468:
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L1531
	add	w20, w20, 32
	and	w20, w20, 65535
.L1531:
	mov	w21, 65535
.L1474:
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1483
	cmp	w21, w0
	beq	.L1484
	strh	w21, [x19, #:lo12:.LANCHOR80]
.L1485:
	add	x0, x19, :lo12:.LANCHOR80
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w1
	beq	.L1483
	bl	IsBlkInGcList
	cbz	w0, .L1488
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1488:
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR80
	cmp	w1, w0
	beq	.L1483
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR178
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR178]
	adrp	x0, .LANCHOR42
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR179
	strh	w1, [x0, #:lo12:.LANCHOR179]
.L1483:
	adrp	x1, .LANCHOR51
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	str	x1, [x29, 120]
	ldrh	w2, [x1, #:lo12:.LANCHOR51]
	cmp	w2, w0
	beq	.L1489
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1490
.L1489:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1490:
	adrp	x25, .LANCHOR85
	add	x26, x25, :lo12:.LANCHOR85
.L1519:
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1491
	adrp	x0, .LANCHOR87
	adrp	x22, .LANCHOR19
	add	x22, x22, :lo12:.LANCHOR19
	str	wzr, [x0, #:lo12:.LANCHOR87]
.L1492:
	ldrh	w5, [x25, #:lo12:.LANCHOR85]
	add	x7, x25, :lo12:.LANCHOR85
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1493
	strh	wzr, [x7]
	mov	w0, 8
	b	.L1449
.L1463:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1534
	adrp	x0, .LANCHOR99
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	cmp	w0, w1
	bne	.L1534
	cmp	w21, w0
	bne	.L1534
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w21
	beq	.L1475
.L1534:
	mov	w20, 1
	b	.L1474
.L1475:
	adrp	x0, .LANCHOR87
	adrp	x22, .LANCHOR48
	adrp	x20, .LANCHOR82
	adrp	x23, .LANCHOR177
	str	wzr, [x0, #:lo12:.LANCHOR87]
	ldrh	w1, [x22, #:lo12:.LANCHOR48]
	ldrh	w0, [x20, #:lo12:.LANCHOR82]
	cmp	w1, w0
	bls	.L1476
	ldrh	w0, [x23, #:lo12:.LANCHOR177]
	cbnz	w0, .L1477
	adrp	x0, .LANCHOR61
	adrp	x1, .LANCHOR59
	ldr	w0, [x0, #:lo12:.LANCHOR61]
	ldr	w1, [x1, #:lo12:.LANCHOR59]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	bcs	.L1478
.L1477:
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
.L1558:
	strh	w0, [x20, #:lo12:.LANCHOR82]
	bl	FtlReadRefresh
	mov	w0, 0
	bl	List_get_gc_head_node
	adrp	x1, .LANCHOR42
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cmp	w0, 4
	bls	.L1476
.L1559:
	ldrh	w0, [x23, #:lo12:.LANCHOR177]
	b	.L1449
.L1478:
	mov	w0, 18
	b	.L1558
.L1476:
	ldrh	w0, [x23, #:lo12:.LANCHOR177]
	cbnz	w0, .L1534
	adrp	x0, .LANCHOR78
	ldrh	w5, [x0, #:lo12:.LANCHOR78]
	add	w0, w5, w5, lsl 1
	asr	w0, w0, 2
	strh	w0, [x20, #:lo12:.LANCHOR82]
	mov	w0, 0
	bl	List_get_gc_head_node
	adrp	x1, .LANCHOR42
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR3
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w2, [x2, #:lo12:.LANCHOR3]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR20
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	mul	w0, w0, w2
	cmp	w1, w0, asr 1
	ble	.L1481
	ldrh	w0, [x22, #:lo12:.LANCHOR48]
	sub	w5, w5, #1
	cmp	w0, w5
	blt	.L1481
	bl	FtlReadRefresh
	b	.L1559
.L1481:
	cbnz	w1, .L1534
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x22, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	b	.L1449
.L1484:
	adrp	x0, .LANCHOR99
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	cmp	w1, w21
	beq	.L1485
	adrp	x2, .LANCHOR42
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L1486
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
.L1486:
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	strh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
	b	.L1485
.L1493:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L1494
	strh	w5, [x25, #:lo12:.LANCHOR85]
	b	.L1492
.L1494:
	adrp	x23, .LANCHOR42
	adrp	x4, .LANCHOR3
	ldrh	w0, [x22]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR3]
	strh	w5, [x25, #:lo12:.LANCHOR85]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L1496
	cmp	w5, 48
	bls	.L1497
	cmp	w3, 8
	bls	.L1497
	adrp	x3, .LANCHOR95
	ldrh	w3, [x3, #:lo12:.LANCHOR95]
	cmp	w3, 35
	bhi	.L1497
.L1496:
	strh	wzr, [x26]
.L1497:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L1498
	mov	w0, 65535
	cmp	w21, w0
	bne	.L1498
	ldrh	w0, [x26]
	cmp	w0, 3
	bhi	.L1498
	mov	w0, -1
	strh	wzr, [x26]
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1560:
	adrp	x0, .LANCHOR177
	ldrh	w0, [x0, #:lo12:.LANCHOR177]
	b	.L1449
.L1498:
	cbnz	w1, .L1499
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x26]
	add	w0, w0, 1
	strh	w0, [x26]
	b	.L1492
.L1499:
	add	x0, x19, :lo12:.LANCHOR80
	strb	wzr, [x0, 8]
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w6
	bne	.L1500
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 700
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1500:
	adrp	x0, .LANCHOR52
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1501
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 701
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1501:
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1502
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 702
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1502:
	add	x22, x19, :lo12:.LANCHOR80
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR178
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	strh	wzr, [x0, #:lo12:.LANCHOR178]
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR179
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR179]
	strb	wzr, [x22, 6]
.L1491:
	ldr	x1, [x29, 144]
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR108]
	adrp	x0, .LANCHOR19
	str	x0, [x29, 112]
	ldrh	w1, [x0, #:lo12:.LANCHOR19]
	ldr	w0, [x29, 152]
	str	w1, [x29, 156]
	cbz	w0, .L1503
	adrp	x0, .LANCHOR3
	ldrh	w2, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w1, [x1, x2, lsl 1]
	sub	w0, w0, w1
	mov	w1, 4
	sdiv	w0, w0, w1
	add	w20, w20, w0
	and	w20, w20, 65535
.L1503:
	add	x0, x19, :lo12:.LANCHOR80
	ldr	w2, [x29, 156]
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w2
	ble	.L1504
	sub	w20, w2, w0
	and	w20, w20, 65535
.L1504:
	adrp	x0, .LANCHOR178
	mov	w28, 0
	add	x0, x0, :lo12:.LANCHOR178
	str	x0, [x29, 136]
.L1505:
	cmp	w20, w28, uxth
	bls	.L1513
	add	x1, x19, :lo12:.LANCHOR80
	adrp	x0, .LANCHOR3
	adrp	x23, .LANCHOR93
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR3]
	mov	w22, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x23, #:lo12:.LANCHOR93]
	mov	w6, 65535
	add	w4, w4, w28
	b	.L1514
.L1507:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L1506
	ubfiz	x5, x22, 5, 16
	add	w22, w22, 1
	add	x5, x0, x5
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x5, 4]
.L1506:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L1514:
	cmp	w2, w7
	bne	.L1507
	add	x1, x19, :lo12:.LANCHOR80
	adrp	x24, .LANCHOR89
	add	x24, x24, :lo12:.LANCHOR89
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
	str	x0, [x29, 128]
.L1508:
	ldr	x0, [x29, 128]
	cmp	x0, x22
	bne	.L1512
	add	w28, w28, 1
	b	.L1505
.L1512:
	ldr	x0, [x23, #:lo12:.LANCHOR93]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L1509
	ldr	x27, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x27]
	cmp	w1, w0
	bne	.L1509
	ldr	w4, [x27, 8]
	cmn	w4, #1
	bne	.L1510
	str	w4, [x29, 104]
	mov	w2, 736
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
	ldr	w4, [x29, 104]
.L1510:
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x23, #:lo12:.LANCHOR93]
	ldr	w1, [x29, 172]
	add	x0, x0, x22
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bne	.L1509
	ldr	x1, [x29, 136]
	adrp	x4, .LANCHOR113
	ldr	x2, [x29, 136]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	x2, [x4, #:lo12:.LANCHOR113]
	ldr	w1, [x24]
	add	x1, x2, x1, lsl 5
	stp	x4, x1, [x29, 96]
	str	w0, [x1, 24]
	bl	Ftl_get_new_temp_ppa
	ldp	x4, x1, [x29, 96]
	ldr	x2, [x4, #:lo12:.LANCHOR113]
	str	w0, [x1, 4]
	ldr	w1, [x24]
	ubfiz	x0, x1, 5, 32
	add	w1, w1, 1
	add	x2, x2, x0
	ldr	x0, [x23, #:lo12:.LANCHOR93]
	add	x0, x0, x22
	ldr	x4, [x0, 8]
	str	x4, [x2, 8]
	ldr	x4, [x0, 16]
	str	x4, [x2, 16]
	ldr	w2, [x29, 172]
	str	w2, [x27, 12]
	adrp	x2, .LANCHOR53
	add	x11, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	strh	w2, [x27, 2]
	adrp	x2, .LANCHOR71
	str	w1, [x24]
	mov	w1, 1
	ldr	w2, [x2, #:lo12:.LANCHOR71]
	str	w2, [x27, 4]
	bl	FtlGcBufAlloc
	ldrb	w1, [x11, 7]
	ldr	w0, [x24]
	cmp	w1, w0
	beq	.L1511
	ldrh	w0, [x11, 4]
	cbnz	w0, .L1509
.L1511:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L1509
.L1561:
	ldr	x0, [x29, 144]
	str	wzr, [x0, #:lo12:.LANCHOR108]
	b	.L1560
.L1509:
	add	x22, x22, 32
	b	.L1508
.L1513:
	add	x1, x19, :lo12:.LANCHOR80
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	ldr	w0, [x29, 156]
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w0, w20
	bhi	.L1515
	adrp	x0, .LANCHOR89
	ldr	w0, [x0, #:lo12:.LANCHOR89]
	cbz	w0, .L1516
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L1561
.L1516:
	adrp	x0, .LANCHOR178
	ldrh	w0, [x0, #:lo12:.LANCHOR178]
	cbnz	w0, .L1517
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L1517
	strh	wzr, [x1, x0]
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1517:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1515:
	ldr	x0, [x29, 144]
	str	wzr, [x0, #:lo12:.LANCHOR108]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1518
	ldr	x0, [x29, 112]
	ldrh	w20, [x0, #:lo12:.LANCHOR19]
	b	.L1519
.L1518:
	adrp	x1, .LANCHOR177
	ldrh	w1, [x1, #:lo12:.LANCHOR177]
	cmp	w1, 0
	csinc	w0, w1, w0, ne
	b	.L1449
.L1522:
	mov	w0, 0
	b	.L1449
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
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
	cbnz	w0, .L1566
	bl	FtlSysBlkInit
	cbnz	w0, .L1566
	mov	w0, 1
	str	w0, [x19, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 15
	bhi	.L1566
	mov	w19, 8129
.L1565:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L1565
.L1566:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	sftl_init, .-sftl_init
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
	stp	x25, x26, [sp, 64]
	mov	w26, w2
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	bne	.L1571
	mov	x2, x3
	mov	w1, w26
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L1570:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1571:
	add	w0, w1, w2
	str	w0, [x29, 136]
	adrp	x0, .LANCHOR34
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1592
	adrp	x0, .LANCHOR86
	ldr	w21, [x0, #:lo12:.LANCHOR86]
	cmn	w21, #1
	beq	.L1570
	adrp	x22, .LANCHOR12
	adrp	x25, .LANCHOR81
	add	x25, x25, :lo12:.LANCHOR81
	mov	w27, 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	mov	w21, 0
	adrp	x28, .LANCHOR112
	stp	wzr, wzr, [x29, 140]
	udiv	w1, w19, w0
	stp	wzr, w1, [x29, 148]
	add	w1, w19, w2
	sub	w24, w1, #1
	adrp	x1, .LANCHOR69
	ldr	w20, [x29, 152]
	udiv	w24, w24, w0
	ldr	w0, [x29, 152]
	sub	w0, w24, w0
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x1, #:lo12:.LANCHOR69]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR69]
	adrp	x1, .LANCHOR62
	ldr	w2, [x29, 156]
	ldr	w0, [x1, #:lo12:.LANCHOR62]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR62]
.L1573:
	ldr	w0, [x29, 156]
	cbnz	w0, .L1590
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbnz	w0, .L1591
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 31
	bhi	.L1570
.L1591:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L1570
.L1590:
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1574
	add	x5, x22, :lo12:.LANCHOR12
	mov	w4, 0
.L1575:
	ldrh	w0, [x5]
	cmp	w4, w0
	bcc	.L1577
.L1578:
	ldr	w0, [x29, 156]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 156]
	beq	.L1582
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w27, w0, lsl 2
	bne	.L1573
.L1582:
	cbz	w27, .L1573
	ldr	x0, [x28, #:lo12:.LANCHOR112]
	mov	w1, w27
	mov	w2, 0
	bl	FlashReadPages
	ldr	w0, [x29, 140]
	lsl	w0, w0, 9
	str	w0, [x29, 116]
	ldr	w0, [x29, 148]
	lsl	w0, w0, 9
	str	x0, [x29, 128]
	ldr	w0, [x29, 144]
	lsl	w0, w0, 9
	str	w0, [x29, 120]
	ubfiz	x0, x27, 5, 32
	mov	x27, 0
	str	x0, [x29, 104]
	add	x0, x22, :lo12:.LANCHOR12
	str	x0, [x29, 96]
.L1589:
	ldr	x0, [x28, #:lo12:.LANCHOR112]
	ldr	w2, [x29, 152]
	add	x0, x0, x27
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L1584
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR118
	ldr	x0, [x0, #:lo12:.LANCHOR118]
	cmp	x1, x0
	bne	.L1585
	ldr	x0, [x29, 128]
	ldr	w2, [x29, 120]
	add	x1, x1, x0
	mov	x0, x23
.L1603:
	bl	ftl_memcpy
.L1585:
	ldr	x0, [x28, #:lo12:.LANCHOR112]
	add	x0, x0, x27
	ldr	x1, [x0, 16]
	ldr	w2, [x0, 24]
	ldr	w1, [x1, 8]
	cmp	w2, w1
	beq	.L1586
	ldr	w1, [x25, 72]
	add	w1, w1, 1
	str	w1, [x25, 72]
.L1586:
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L1587
	ldr	w0, [x25, 72]
	mov	w21, w1
	add	w0, w0, 1
	str	w0, [x25, 72]
.L1588:
	ldr	x0, [x29, 104]
	add	x27, x27, 32
	cmp	x0, x27
	bne	.L1589
	mov	w27, 0
	b	.L1573
.L1577:
	madd	w0, w20, w0, w4
	cmp	w19, w0
	bhi	.L1576
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L1576
	sub	w0, w0, w19
	str	x5, [x29, 120]
	lsl	w0, w0, 9
	str	w4, [x29, 128]
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	w4, [x29, 128]
	ldr	x5, [x29, 120]
.L1576:
	add	w4, w4, 1
	b	.L1575
.L1574:
	ldr	x2, [x28, #:lo12:.LANCHOR112]
	ubfiz	x0, x27, 5, 32
	add	x0, x2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 152]
	cmp	w20, w1
	bne	.L1579
	adrp	x1, .LANCHOR118
	ldr	x1, [x1, #:lo12:.LANCHOR118]
	str	x1, [x0, 8]
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 148]
	sub	w2, w1, w2
	cmp	w26, w2
	csel	w2, w26, w2, ls
	str	w2, [x29, 144]
	cmp	w1, w2
	bne	.L1580
	str	x23, [x0, 8]
.L1580:
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR124
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR24]
	ldr	x2, [x2, #:lo12:.LANCHOR124]
	mul	w1, w1, w27
	add	w27, w27, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L1578
.L1579:
	cmp	w20, w24
	bne	.L1581
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	adrp	x1, .LANCHOR119
	ldr	w3, [x29, 136]
	ldr	x1, [x1, #:lo12:.LANCHOR119]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 140]
	cmp	w2, w3
	bne	.L1580
.L1602:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L1580
.L1581:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	mul	w1, w1, w20
	b	.L1602
.L1584:
	cmp	w24, w1
	bne	.L1585
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR119
	ldr	x0, [x0, #:lo12:.LANCHOR119]
	cmp	x1, x0
	bne	.L1585
	ldr	x0, [x29, 96]
	ldr	w2, [x29, 116]
	ldrh	w0, [x0]
	mul	w0, w0, w24
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L1603
.L1587:
	cmp	w1, 256
	bne	.L1588
	ldr	w0, [x0, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1588
.L1592:
	mov	w21, -1
	b	.L1570
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
	str	w2, [x29, 180]
	bne	.L1606
	add	w0, w1, 256
	ldr	w1, [x29, 180]
	mov	x2, x3
	bl	FtlVendorPartWrite
.L1605:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1606:
	ldr	w0, [x29, 180]
	add	w0, w1, w0
	str	w0, [x29, 168]
	adrp	x0, .LANCHOR34
	ldr	w1, [x29, 168]
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1642
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmn	w0, #1
	beq	.L1605
	adrp	x0, .LANCHOR181
	mov	w1, 2048
	adrp	x22, .LANCHOR12
	ldr	w2, [x29, 180]
	str	w1, [x0, #:lo12:.LANCHOR181]
	ldr	w1, [x29, 168]
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	sub	w1, w1, #1
	udiv	w25, w21, w0
	udiv	w0, w1, w0
	adrp	x1, .LANCHOR68
	str	w0, [x29, 156]
	sub	w0, w0, w25
	add	w24, w0, 1
	str	w0, [x29, 152]
	ldr	w0, [x1, #:lo12:.LANCHOR68]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR68]
	adrp	x1, .LANCHOR64
	ldr	w0, [x1, #:lo12:.LANCHOR64]
	add	w0, w0, w24
	str	w0, [x1, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR182
	str	x0, [x29, 160]
	ldr	w1, [x0, #:lo12:.LANCHOR182]
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	cbz	w1, .L1608
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1608
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L1608:
	mov	w20, w25
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	str	x0, [x29, 96]
.L1609:
	cbnz	w24, .L1637
	ldr	w1, [x29, 152]
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR48
	mov	x22, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	cmp	w1, 5
	bls	.L1638
.L1640:
	mov	w0, 0
	b	.L1605
.L1637:
	adrp	x0, .LANCHOR3
	ldrb	w2, [x19, 6]
	str	x0, [x29, 120]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	cmp	w2, w1
	bcc	.L1610
	adrp	x1, .LANCHOR183
	adrp	x0, .LC1
	mov	w2, 1011
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1610:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1611
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	cmp	x19, x0
	bne	.L1612
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1613
	bl	allocate_new_data_superblock
	ldr	x0, [x29, 160]
	str	wzr, [x0, #:lo12:.LANCHOR182]
.L1613:
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	mov	x0, x19
	bl	allocate_new_data_superblock
	ldr	x0, [x29, 160]
	ldr	w0, [x0, #:lo12:.LANCHOR182]
	cmp	w0, 0
	ldr	x0, [x29, 96]
	csel	x19, x0, x19, ne
.L1614:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1611
	mov	x0, x19
	bl	allocate_new_data_superblock
.L1611:
	ldrh	w0, [x19, 4]
	ldrb	w1, [x19, 7]
	cmp	w0, w24
	csel	w0, w0, w24, ls
	lsl	w1, w1, 2
	cmp	w0, w1
	csel	w0, w0, w1, ls
	str	w0, [x29, 148]
	ldr	x0, [x29, 120]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1615
	adrp	x1, .LANCHOR183
	adrp	x0, .LC1
	mov	w2, 1044
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1615:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	str	xzr, [x29, 184]
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	str	x0, [x29, 104]
.L1616:
	ldr	w1, [x29, 148]
	adrp	x27, .LANCHOR114
	ldr	w23, [x29, 184]
	cmp	w23, w1
	bcc	.L1635
	mov	x23, x1
.L1617:
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	mov	x3, x19
	mov	w2, 0
	mov	w1, w23
	bl	FtlProgPages
	cmp	w24, w23
	bcs	.L1636
	adrp	x1, .LANCHOR183
	adrp	x0, .LC1
	mov	w2, 1121
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1636:
	sub	w24, w24, w23
	b	.L1609
.L1612:
	ldr	x1, [x29, 160]
	str	wzr, [x1, #:lo12:.LANCHOR182]
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1647
	mov	x0, x19
	bl	allocate_new_data_superblock
	b	.L1614
.L1647:
	mov	x19, x0
	b	.L1611
.L1635:
	ldrh	w0, [x19, 4]
	cbz	w0, .L1617
	add	x1, x29, 204
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	mov	x0, x19
	bl	get_new_active_ppa
	ldr	x1, [x29, 184]
	lsl	x28, x1, 5
	ldr	x1, [x27, #:lo12:.LANCHOR114]
	add	x1, x1, x28
	str	w0, [x1, 4]
	ldr	x0, [x29, 112]
	str	w20, [x1, 24]
	ldrh	w2, [x0]
	mul	w23, w23, w2
	and	x0, x23, 4294967292
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR124
	ldr	x3, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR124]
	str	x0, [x29, 128]
	add	x23, x0, x3
	str	x23, [x1, 16]
	mov	x0, x23
	mov	w1, 0
	bl	ftl_memset
	ldr	w0, [x29, 156]
	cmp	w20, w25
	ccmp	w20, w0, 4, ne
	bne	.L1618
	cmp	w20, w25
	bne	.L1619
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 172]
	sub	w2, w2, w0
	ldr	w0, [x29, 180]
	cmp	w2, w0
	csel	w0, w2, w0, ls
	str	w0, [x29, 176]
.L1620:
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	ldr	w1, [x29, 176]
	cmp	w1, w0
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	bne	.L1621
	add	x3, x0, x28
	cmp	w20, w25
	bne	.L1622
	str	x26, [x3, 8]
.L1623:
	ldr	x0, [x29, 120]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1632
	adrp	x1, .LANCHOR183
	adrp	x0, .LC1
	mov	w2, 1112
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1632:
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
	b	.L1616
.L1619:
	ldr	w0, [x29, 168]
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	msub	w2, w20, w2, w0
	and	w0, w2, 65535
	stp	wzr, w0, [x29, 172]
	b	.L1620
.L1622:
	ldr	w0, [x29, 176]
.L1654:
	mul	w0, w0, w20
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x26, x0
	str	x0, [x3, 8]
	b	.L1623
.L1621:
	add	x0, x0, x28
	cmp	w20, w25
	bne	.L1624
	adrp	x1, .LANCHOR118
	ldr	x1, [x1, #:lo12:.LANCHOR118]
.L1653:
	str	x1, [x0, 8]
	ldr	w0, [x29, 204]
	cmn	w0, #1
	beq	.L1626
	str	w0, [x29, 212]
	mov	w2, 0
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	str	w20, [x29, 232]
	add	x0, x0, x28
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 216]
	mov	w1, 1
	add	x0, x29, 208
	bl	FlashReadPages
	ldr	w0, [x29, 208]
	cmn	w0, #1
	bne	.L1627
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L1630:
	ldr	w0, [x29, 176]
	cmp	w20, w25
	lsl	w2, w0, 9
	bne	.L1631
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	mov	x1, x26
	add	x3, x0, x28
	ldr	w0, [x29, 172]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L1655:
	bl	ftl_memcpy
	b	.L1623
.L1624:
	adrp	x1, .LANCHOR119
	ldr	x1, [x1, #:lo12:.LANCHOR119]
	b	.L1653
.L1627:
	ldr	w1, [x23, 8]
	cmp	w20, w1
	beq	.L1629
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC113
	mov	w2, w20
	add	x0, x0, :lo12:.LC113
	bl	printf
.L1629:
	ldr	w0, [x23, 8]
	cmp	w20, w0
	beq	.L1630
	mov	w2, 1097
	adrp	x1, .LANCHOR183
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1630
.L1626:
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	ldr	x1, [x29, 104]
	add	x0, x0, x28
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L1630
.L1631:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	add	x3, x0, x28
	mul	w1, w1, w20
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x26, x1
	b	.L1655
.L1618:
	ldr	x0, [x27, #:lo12:.LANCHOR114]
	add	x3, x0, x28
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	b	.L1654
.L1638:
	adrp	x23, .LANCHOR99
	adrp	x20, .LANCHOR83
	adrp	x21, .LANCHOR82
	add	x23, x23, :lo12:.LANCHOR99
	add	x20, x20, :lo12:.LANCHOR83
	add	x21, x21, :lo12:.LANCHOR82
	mov	w19, 256
.L1641:
	adrp	x0, .LANCHOR80
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w1
	bne	.L1639
	ldrh	w1, [x23]
	cmp	w1, w0
	bne	.L1639
	mov	w0, 0
	bl	List_get_gc_head_node
	bl	FtlGcRefreshBlock
.L1639:
	mov	w0, 128
	mov	w1, 1
	strh	w0, [x20]
	strh	w0, [x21]
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	ldrh	w0, [x22, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1640
	subs	w19, w19, #1
	bne	.L1641
	b	.L1640
.L1642:
	mov	w0, -1
	b	.L1605
	.size	FtlWrite, .-FtlWrite
	.section	.text.sftl_write,"ax",@progbits
	.align	2
	.global	sftl_write
	.type	sftl_write, %function
sftl_write:
	stp	x29, x30, [sp, -272]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	w19, w0, w1
	stp	x21, x22, [sp, 32]
	sub	w20, w19, #1
	stp	x25, x26, [sp, 64]
	mov	w22, w0
	stp	x23, x24, [sp, 48]
	mov	w25, w1
	stp	x27, x28, [sp, 80]
	cmp	w20, 63
	str	x2, [x29, 184]
	bls	.L1657
	cmp	w0, 576
	bls	.L1658
.L1657:
	adrp	x0, .LANCHOR184
	str	x0, [x29, 152]
	ldr	w1, [x0, #:lo12:.LANCHOR184]
	cbz	w1, .L1659
	adrp	x0, .LANCHOR185
	str	x0, [x29, 144]
	mov	w1, 35899
	ldr	x24, [x0, #:lo12:.LANCHOR185]
	movk	w1, 0xfcdc, lsl 16
	ldr	w2, [x24]
	cmp	w2, w1
	beq	.L1660
.L1677:
	ldr	x0, [x29, 152]
	str	wzr, [x0, #:lo12:.LANCHOR184]
	ldr	x0, [x29, 144]
	ldr	x0, [x0, #:lo12:.LANCHOR185]
	bl	free
	adrp	x0, .LANCHOR186
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	bl	free
.L1659:
	ldr	x3, [x29, 184]
	mov	w2, w25
	mov	w1, w22
	mov	w0, 0
	bl	FtlWrite
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 272
	ret
.L1660:
	adrp	x1, .LANCHOR0
	add	x0, x1, :lo12:.LANCHOR0
	mov	w2, 65535
	mov	w4, 4097
	str	x1, [x29, 168]
	ldrh	w19, [x0, 14]
	ldrh	w20, [x0, 10]
	mov	x0, 262140
	add	x3, x24, x0
	mov	w0, 0
.L1664:
	ldr	w1, [x3]
	cbnz	w1, .L1661
	ldr	w1, [x24, w0, uxtw 2]
	add	w0, w0, 1
	str	w1, [x3], -4
	cmp	w0, w4
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L1664
	mov	w23, 512
	b	.L1663
.L1661:
	add	w23, w2, 127
	adrp	x0, .LC114
	lsr	w23, w23, 7
	add	x0, x0, :lo12:.LC114
	mov	w3, w23
	bl	printf
.L1663:
	and	w19, w19, 255
	adrp	x26, .LANCHOR105
	mul	w20, w20, w19
	mov	w19, 0
	and	w20, w20, 65535
	sub	w21, w20, #1
	add	w21, w21, w23
	udiv	w21, w21, w20
	mul	w0, w20, w21
	stp	w21, wzr, [x29, 196]
	str	w0, [x29, 204]
	lsl	w0, w23, 7
	str	w0, [x29, 192]
	add	x0, x26, :lo12:.LANCHOR105
	str	x0, [x29, 136]
	b	.L1676
.L1667:
	add	w0, w5, w4
	ldr	x3, [x29, 136]
	ubfiz	x2, x4, 9, 16
	stp	w5, w7, [x29, 112]
	str	w4, [x29, 120]
	add	x2, x24, x2
	udiv	w0, w0, w27
	str	w6, [x29, 128]
	ldr	x8, [x3, 16]
	add	x3, x29, 208
	and	w0, w0, 65535
	mul	w1, w0, w27
	stp	w1, w7, [x29, 208]
	udiv	w1, w6, w27
	add	w1, w1, w0
	mov	w0, 0
	blr	x8
	ldr	w4, [x29, 120]
	ldr	w0, [x29, 160]
	ldp	w5, w7, [x29, 112]
	add	w4, w0, w4
	ldr	w6, [x29, 128]
	and	w4, w4, 65535
	b	.L1666
.L1669:
	add	w27, w8, w27
	mov	w0, 0
	and	w27, w27, 65535
	b	.L1668
.L1674:
	mov	x27, x2
	ldr	w4, [x0, x1, lsl 2]
	lsl	x5, x1, 2
	add	x2, x2, 4
	add	x1, x1, 1
	ldr	w3, [x27]
	cmp	w4, w3
	beq	.L1670
	mov	x2, 512
	mov	w1, 0
	str	x5, [x29, 160]
	bl	memset
	ldr	x0, [x29, 176]
	mov	w4, w28
	ldr	x5, [x29, 160]
	mov	w1, w19
	ldr	w3, [x27]
	add	x27, x26, :lo12:.LANCHOR105
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	ldr	w2, [x0, x5]
	adrp	x0, .LC115
	add	x0, x0, :lo12:.LC115
	bl	printf
	ldr	x2, [x27, 8]
	mov	w1, w19
	mov	w0, 0
	blr	x2
	cmp	w21, 1
	bls	.L1683
	ldr	x2, [x27, 8]
	add	w1, w20, w19
	mov	w0, 0
	blr	x2
.L1683:
	ldr	w1, [x29, 204]
	ldr	w0, [x29, 196]
	add	w19, w19, w1
	ldr	w1, [x29, 196]
	add	w0, w21, w0
	cmp	w1, 15
	bhi	.L1677
	str	w0, [x29, 196]
.L1676:
	adrp	x5, .LANCHOR186
	mov	x2, 512
	mov	w1, 0
	str	x5, [x29, 176]
	ldr	x0, [x5, #:lo12:.LANCHOR186]
	bl	memset
	ldr	x0, [x29, 168]
	add	x4, x26, :lo12:.LANCHOR105
	str	x4, [x29, 120]
	add	x0, x0, :lo12:.LANCHOR0
	ldr	x6, [x4, 8]
	ldrh	w3, [x0, 14]
	ldrh	w2, [x0, 10]
	mov	w0, 0
	and	w27, w3, 255
	str	w3, [x29, 128]
	str	w27, [x29, 160]
	udiv	w1, w19, w3
	mul	w2, w27, w2
	and	w28, w2, 65535
	blr	x6
	ldr	w0, [x29, 204]
	ldr	w3, [x29, 128]
	cmp	w0, w28
	ldr	x4, [x29, 120]
	bls	.L1665
	add	w1, w28, w19
	ldr	x4, [x4, 8]
	mov	w0, 0
	udiv	w1, w1, w3
	blr	x4
.L1665:
	udiv	w5, w19, w28
	mov	w4, 0
	mov	w7, 61424
	msub	w5, w5, w28, w19
	sub	w6, w19, w5
.L1666:
	ldr	w0, [x29, 204]
	cmp	w0, w4
	bhi	.L1667
	ldr	x0, [x29, 176]
	add	x10, x26, :lo12:.LANCHOR105
	mov	w27, 0
	ldr	x6, [x0, #:lo12:.LANCHOR186]
	ldr	x0, [x29, 168]
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
	sub	w7, w19, w5
	sdiv	w0, w1, w28
	msub	w0, w0, w28, w1
	and	w0, w0, 65535
.L1668:
	cmp	w27, w23
	bcs	.L1672
	add	w1, w5, w27
	sub	w8, w4, w0
	add	w0, w0, w7
	ldr	x11, [x10, 24]
	and	w8, w8, 65535
	ubfiz	x2, x27, 9, 16
	udiv	w1, w1, w28
	add	x2, x6, x2
	stp	w4, w8, [x29, 108]
	add	x3, x29, 208
	stp	w5, w7, [x29, 116]
	str	x10, [x29, 128]
	and	w1, w1, 65535
	str	x6, [x29, 160]
	madd	w1, w1, w28, w0
	mov	w0, 0
	udiv	w1, w1, w28
	blr	x11
	cmn	w0, #1
	ldp	w4, w8, [x29, 108]
	ldp	w5, w7, [x29, 116]
	ldr	x10, [x29, 128]
	ldr	x6, [x29, 160]
	bne	.L1669
.L1672:
	ldr	x0, [x29, 176]
	mov	x2, x24
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR186]
.L1670:
	ldr	w3, [x29, 192]
	mov	w28, w1
	cmp	w1, w3
	bcc	.L1674
	ldr	w0, [x29, 200]
	add	w0, w0, 1
	str	w0, [x29, 200]
	cmp	w0, 5
	bls	.L1683
	b	.L1677
.L1658:
	cmp	w0, 64
	adrp	x21, .LANCHOR185
	bne	.L1678
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x21, #:lo12:.LANCHOR185]
	mov	w0, 262144
	bl	ftl_malloc
	mov	x1, x0
	adrp	x0, .LANCHOR186
	str	x1, [x0, #:lo12:.LANCHOR186]
	ldr	x0, [x21, #:lo12:.LANCHOR185]
	cbz	x0, .L1679
	cbz	x1, .L1679
	adrp	x1, .LANCHOR184
	mov	w2, 1
	str	w2, [x1, #:lo12:.LANCHOR184]
	mov	w2, 262144
	mov	w1, 0
	bl	ftl_memset
.L1678:
	ldr	x0, [x21, #:lo12:.LANCHOR185]
	cmp	w22, 63
	bhi	.L1680
	mov	w1, 64
	ldr	x3, [x29, 184]
	sub	w1, w1, w22
	sub	w2, w25, w1
	ubfiz	x1, x1, 9, 25
	add	x1, x3, x1
.L1681:
	cmp	w20, 576
	bls	.L1682
	sub	w2, w2, w19
	sub	w2, w2, #447
.L1682:
	lsl	w2, w2, 9
	bl	ftl_memcpy
	b	.L1659
.L1679:
	adrp	x1, .LANCHOR187
	adrp	x0, .LC116
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC116
	bl	printf
	b	.L1678
.L1680:
	lsl	w1, w22, 7
	mov	w2, w25
	sub	w1, w1, #8192
	add	x0, x0, x1, lsl 2
	ldr	x1, [x29, 184]
	b	.L1681
	.size	sftl_write, .-sftl_write
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
	adrp	x28, .LANCHOR148
	add	x21, x21, 12
	add	x25, x28, :lo12:.LANCHOR148
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	str	x0, [x29, 120]
.L1701:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L1707
	adrp	x21, .LANCHOR25
	add	x21, x21, :lo12:.LANCHOR25
	mov	w19, 0
.L1708:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L1709
	add	x21, x20, :lo12:.LANCHOR37
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1710:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1714
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L1711
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L1712
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L1711:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1710
.L1707:
	adrp	x2, .LANCHOR123
	adrp	x0, .LANCHOR115
	add	x19, x28, :lo12:.LANCHOR148
	ldrh	w1, [x21]
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR123]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR17
	str	x2, [x29, 112]
	beq	.L1702
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
.L1703:
	mov	w0, w27
	add	w22, w22, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x21, x21, 2
	b	.L1701
.L1702:
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
.L1704:
	ldrh	w0, [x23]
	madd	w0, w22, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L1705
	ldr	x0, [x29, 112]
	mov	w2, 16
	strh	w19, [x21]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR123]
	bl	ftl_memset
	adrp	x0, .LANCHOR115
	mov	w2, 4096
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR115]
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
	bne	.L1703
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L1704
.L1705:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1704
.L1709:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L1708
.L1712:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L1713
	strh	w19, [x21]
	b	.L1711
.L1713:
	strh	w19, [x21, 4]
.L1714:
	adrp	x0, .LANCHOR106
	add	x19, x20, :lo12:.LANCHOR37
	ldrh	w1, [x20, #:lo12:.LANCHOR37]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR106]
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
	cbz	w0, .L1721
	bl	FtlMakeBbt
.L1721:
	adrp	x23, .LANCHOR12
	adrp	x0, .LANCHOR118
	mov	w6, 23752
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR118]
	adrp	x0, .LANCHOR119
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR119]
	mov	w0, 0
.L1722:
	cmp	w0, w1
	blt	.L1723
	adrp	x21, .LANCHOR5
	adrp	x22, .LANCHOR6
	add	x26, x22, :lo12:.LANCHOR6
	mov	w19, 0
	ldrh	w25, [x21, #:lo12:.LANCHOR5]
.L1724:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L1725
	adrp	x25, .LANCHOR3
	sub	w1, w19, #2
	ldrh	w0, [x25, #:lo12:.LANCHOR3]
	cmp	w1, w0, lsl 1
	bgt	.L1726
.L1730:
	add	x26, x21, :lo12:.LANCHOR5
	mov	w19, 0
	mov	w24, 0
.L1727:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L1731
	adrp	x0, .LANCHOR111
	ldrh	w1, [x22, #:lo12:.LANCHOR6]
	ldrh	w4, [x25, #:lo12:.LANCHOR3]
	adrp	x2, .LANCHOR78
	str	w1, [x0, #:lo12:.LANCHOR111]
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
	ble	.L1732
	sub	w1, w1, w19
	udiv	w1, w1, w4
	str	w1, [x3, #:lo12:.LANCHOR61]
	lsr	w1, w1, 5
	add	w1, w1, 24
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1732:
	adrp	x1, .LANCHOR15
	ldrh	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1734
	ldrh	w6, [x2, #:lo12:.LANCHOR78]
	add	w6, w6, w1, lsr 1
	strh	w6, [x2, #:lo12:.LANCHOR78]
	mul	w6, w1, w4
	cmp	w19, w6
	bge	.L1734
	add	w1, w1, 32
	str	w5, [x3, #:lo12:.LANCHOR61]
	add	w1, w0, w1
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1734:
	ldrh	w1, [x2, #:lo12:.LANCHOR78]
	adrp	x25, .LANCHOR152
	ldr	w0, [x3, #:lo12:.LANCHOR61]
	adrp	x24, .LANCHOR42
	sub	w0, w0, w1
	adrp	x1, .LANCHOR19
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w4
	str	w0, [x25, #:lo12:.LANCHOR152]
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
.L1736:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1737
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1736
.L1723:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L1722
.L1725:
	mov	w0, w25
	mov	w1, 1
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w25, w25, 65535
	and	w19, w19, 65535
	b	.L1724
.L1726:
	udiv	w0, w19, w0
	adrp	x1, .LANCHOR31
	ldr	w19, [x1, #:lo12:.LANCHOR31]
	add	w0, w0, w19
	bl	FtlSysBlkNumInit
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	add	x24, x22, :lo12:.LANCHOR6
	bl	FtlFreeSysBlkQueueInit
	ldrh	w19, [x21, #:lo12:.LANCHOR5]
.L1728:
	ldrh	w0, [x24]
	cmp	w0, w19
	bls	.L1730
	mov	w0, w19
	add	w19, w19, 1
	mov	w1, 1
	and	w19, w19, 65535
	bl	FtlLowFormatEraseBlock
	b	.L1728
.L1731:
	mov	w0, w24
	mov	w1, 0
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w24, w24, 65535
	and	w19, w19, 65535
	b	.L1727
.L1737:
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
.L1738:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1739
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1738
.L1739:
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
	ldr	w0, [x25, #:lo12:.LANCHOR152]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR70]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR70]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L1740
	adrp	x0, .LANCHOR86
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR86]
.L1740:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_memcmp,"ax",@progbits
	.align	2
	.global	ftl_memcmp
	.type	ftl_memcmp, %function
ftl_memcmp:
	uxtw	x2, w2
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
	.section	.bss.check_vpc_table,"aw",@nobits
	.align	3
	.type	check_vpc_table, %object
	.size	check_vpc_table, 16384
check_vpc_table:
	.zero	16384
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",@nobits
	.align	2
	.set	.LANCHOR144,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.zero	4
	.section	.bss.gBbtInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR37,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 96
gBbtInfo:
	.zero	96
	.section	.bss.gL2pMapInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR140,. + 0
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
	.set	.LANCHOR158,. + 0
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
	.set	.LANCHOR152,. + 0
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
	.set	.LANCHOR111,. + 0
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
	.set	.LANCHOR170,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.zero	2
	.section	.bss.g_ftl_nand_free_count,"aw",@nobits
	.align	2
	.set	.LANCHOR181,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR178,. + 0
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
	.set	.LANCHOR109,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.zero	4
	.section	.bss.g_gc_head_data_block_count,"aw",@nobits
	.align	2
	.set	.LANCHOR110,. + 0
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
	.set	.LANCHOR108,. + 0
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
	.set	.LANCHOR167,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR169,. + 0
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
	.set	.LANCHOR142,. + 0
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
	.set	.LANCHOR141,. + 0
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
	.set	.LANCHOR143,. + 0
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
	.set	.LANCHOR172,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.zero	4
	.section	.bss.gc_ink_free_return_value,"aw",@nobits
	.align	1
	.set	.LANCHOR177,. + 0
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
	.set	.LANCHOR186,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 8
gp_flash_check_buf:
	.zero	8
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
	.set	.LANCHOR185,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 8
idb_buf:
	.zero	8
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR184,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR119,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 8
p_io_data_buf_1:
	.zero	8
	.section	.bss.p_io_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR124,. + 0
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
	.set	.LANCHOR115,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 8
p_sys_data_buf:
	.zero	8
	.section	.bss.p_sys_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 8
p_sys_data_buf_1:
	.zero	8
	.section	.bss.p_sys_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR123,. + 0
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
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR106,. + 0
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
	.set	.LANCHOR113,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 8
req_gc_dst:
	.zero	8
	.section	.bss.req_prgm,"aw",@nobits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 8
req_prgm:
	.zero	8
	.section	.bss.req_read,"aw",@nobits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	req_read, %object
	.size	req_read, 8
req_read:
	.zero	8
	.section	.bss.req_sys,"aw",@nobits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	req_sys, %object
	.size	req_sys, 32
req_sys:
	.zero	32
	.section	.bss.sftl_nand_check_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR120,. + 0
	.type	sftl_nand_check_buf, %object
	.size	sftl_nand_check_buf, 8
sftl_nand_check_buf:
	.zero	8
	.section	.bss.sftl_nand_check_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	sftl_nand_check_spare_buf, %object
	.size	sftl_nand_check_spare_buf, 8
sftl_nand_check_spare_buf:
	.zero	8
	.section	.bss.sftl_temp_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR121,. + 0
	.type	sftl_temp_buf, %object
	.size	sftl_temp_buf, 8
sftl_temp_buf:
	.zero	8
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",@progbits
	.align	1
	.set	.LANCHOR162,. + 0
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
	.set	.LANCHOR182,. + 0
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashEraseBlocks.str1.1,"aMS",@progbits,1
.LC79:
	.string	"%s: addr: %x is in id block!!!!!!!!!!\n"
.LC80:
	.string	"not free: w: d:"
.LC81:
	.string	"not free: w: s:"
	.section	.rodata.FlashProgPages.str1.1,"aMS",@progbits,1
.LC85:
	.string	"prog read error: = %x\n"
.LC86:
	.string	"prog read s error: = %x %x %x\n"
.LC87:
	.string	"prog read d error: = %x %x %x\n"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",@progbits,1
.LC0:
	.string	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\n"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",@progbits,1
.LC101:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC102:
	.string	"FtlBbmTblFlush error:%x\n"
.LC103:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC82:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcFreeBadSuperBlk.str1.1,"aMS",@progbits,1
.LC104:
	.string	"FtlGcFreeBadSuperBlk 0x%x\n"
	.section	.rodata.FtlGcMarkBadPhyBlk.str1.1,"aMS",@progbits,1
.LC74:
	.string	"FtlGcMarkBadPhyBlk %d 0x%x\n"
	.section	.rodata.FtlGcRefreshBlock.str1.1,"aMS",@progbits,1
.LC73:
	.string	"FtlGcRefreshBlock  0x%x\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC100:
	.string	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC108:
	.string	"no ect"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC88:
	.string	"FtlMapWritePage error = %x \n"
.LC89:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlMemInit.str1.1,"aMS",@progbits,1
.LC84:
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
.LC111:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC106:
	.string	"spuer block %x vpn is 0\n "
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",@progbits,1
.LC107:
	.string	"FtlVendorPartRead refresh = %x phyAddr = %x\n"
	.section	.rodata.FtlVpcCheckAndModify.str1.1,"aMS",@progbits,1
.LC110:
	.string	"FtlCheckVpc %x = %x  %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC109:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC113:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.GetSwlReplaceBlock.str1.1,"aMS",@progbits,1
.LC72:
	.string	"swblk %x ,avg = %x max= %x vpc= %x,ec=%x ,max ec=%x\n"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC1:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.__func__.6119,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.6119, %object
	.size	__func__.6119, 11
__func__.6119:
	.string	"FtlMemInit"
	.section	.rodata.__func__.6243,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.6243, %object
	.size	__func__.6243, 13
__func__.6243:
	.string	"FtlProgPages"
	.section	.rodata.__func__.6271,"a",@progbits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	__func__.6271, %object
	.size	__func__.6271, 9
__func__.6271:
	.string	"FtlWrite"
	.section	.rodata.__func__.6377,"a",@progbits
	.align	3
	.set	.LANCHOR187,. + 0
	.type	__func__.6377, %object
	.size	__func__.6377, 14
__func__.6377:
	.string	"FtlWriteToIDB"
	.section	.rodata.__func__.6418,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.6418, %object
	.size	__func__.6418, 14
__func__.6418:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.6461,"a",@progbits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	__func__.6461, %object
	.size	__func__.6461, 11
__func__.6461:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.6576,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.6576, %object
	.size	__func__.6576, 17
__func__.6576:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.6581,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.6581, %object
	.size	__func__.6581, 17
__func__.6581:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.6612,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.6612, %object
	.size	__func__.6612, 17
__func__.6612:
	.string	"List_remove_node"
	.section	.rodata.__func__.6644,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.6644, %object
	.size	__func__.6644, 22
__func__.6644:
	.string	"List_update_data_list"
	.section	.rodata.__func__.6653,"a",@progbits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	__func__.6653, %object
	.size	__func__.6653, 16
__func__.6653:
	.string	"load_l2p_region"
	.section	.rodata.__func__.6686,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.6686, %object
	.size	__func__.6686, 26
__func__.6686:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.6697,"a",@progbits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	__func__.6697, %object
	.size	__func__.6697, 15
__func__.6697:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.6712,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.6712, %object
	.size	__func__.6712, 31
__func__.6712:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.6726,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.6726, %object
	.size	__func__.6726, 16
__func__.6726:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.6751,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.6751, %object
	.size	__func__.6751, 22
__func__.6751:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.6768,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.6768, %object
	.size	__func__.6768, 9
__func__.6768:
	.string	"log2phys"
	.section	.rodata.__func__.6841,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.6841, %object
	.size	__func__.6841, 15
__func__.6841:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.6863,"a",@progbits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	__func__.6863, %object
	.size	__func__.6863, 14
__func__.6863:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.6920,"a",@progbits
	.align	3
	.set	.LANCHOR151,. + 0
	.type	__func__.6920, %object
	.size	__func__.6920, 15
__func__.6920:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.6983,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.6983, %object
	.size	__func__.6983, 16
__func__.6983:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.7017,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.7017, %object
	.size	__func__.7017, 22
__func__.7017:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.7074,"a",@progbits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	__func__.7074, %object
	.size	__func__.7074, 16
__func__.7074:
	.string	"make_superblock"
	.section	.rodata.__func__.7095,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.7095, %object
	.size	__func__.7095, 18
__func__.7095:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.7120,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.7120, %object
	.size	__func__.7120, 21
__func__.7120:
	.string	"FtlVpcCheckAndModify"
	.section	.rodata.__func__.7136,"a",@progbits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	__func__.7136, %object
	.size	__func__.7136, 14
__func__.7136:
	.string	"ftl_check_vpc"
	.section	.rodata.__func__.7221,"a",@progbits
	.align	3
	.set	.LANCHOR163,. + 0
	.type	__func__.7221, %object
	.size	__func__.7221, 25
__func__.7221:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.7242,"a",@progbits
	.align	3
	.set	.LANCHOR174,. + 0
	.type	__func__.7242, %object
	.size	__func__.7242, 29
__func__.7242:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.7249,"a",@progbits
	.align	3
	.set	.LANCHOR88,. + 0
	.type	__func__.7249, %object
	.size	__func__.7249, 19
__func__.7249:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.7262,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.7262, %object
	.size	__func__.7262, 16
__func__.7262:
	.string	"update_vpc_list"
	.section	.rodata.__func__.7269,"a",@progbits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	__func__.7269, %object
	.size	__func__.7269, 20
__func__.7269:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.7339,"a",@progbits
	.align	3
	.set	.LANCHOR176,. + 0
	.type	__func__.7339, %object
	.size	__func__.7339, 19
__func__.7339:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.7450,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.7450, %object
	.size	__func__.7450, 23
__func__.7450:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.7712,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.7712, %object
	.size	__func__.7712, 15
__func__.7712:
	.string	"FlashReadPages"
	.section	.rodata.__func__.7730,"a",@progbits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	__func__.7730, %object
	.size	__func__.7730, 15
__func__.7730:
	.string	"FlashProgPages"
	.section	.rodata.__func__.7753,"a",@progbits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	__func__.7753, %object
	.size	__func__.7753, 17
__func__.7753:
	.string	"FlashEraseBlocks"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC105:
	.string	"decrement_vpc_count %x = %d\n"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",@progbits,1
.LC94:
	.string	"...%s enter...\n"
.LC95:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC96:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC83:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC97:
	.string	"ftl_scan_all_data = %x\n"
.LC98:
	.string	"scan lpa = %x ppa= %x\n"
.LC99:
	.string	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC90:
	.string	"region_id = %x phyAddr = %x\n"
.LC91:
	.string	"spare:"
.LC92:
	.string	"map_ppn:"
.LC93:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",@progbits,1
.LC112:
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
	.string	"SFTL version: 5.0.48 20180930"
.LC71:
	.string	"%s\n"
	.section	.rodata.sftl_write.str1.1,"aMS",@progbits,1
.LC114:
	.string	"write_idblock fix data %x %x %x\n"
.LC115:
	.string	"write_idblock fail! %x %x %x %x\n"
.LC116:
	.string	"%s idb buffer alloc fail\n"
	.hidden	free
