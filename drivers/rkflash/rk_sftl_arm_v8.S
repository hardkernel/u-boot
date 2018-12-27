/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2018-12-27
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
	adrp	x6, .LANCHOR12
	add	x29, sp, 0
	ldrh	w3, [x0]
	adrp	x0, .LANCHOR9
	ldrh	w4, [x5, 2]
	strh	w3, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LANCHOR10
	ldrh	w7, [x5, 14]
	strh	w4, [x0, #:lo12:.LANCHOR10]
	ldrh	w0, [x5, 4]
	cmp	w7, 4
	strh	w0, [x1, #:lo12:.LANCHOR11]
	adrp	x1, .LANCHOR6
	ldrh	w2, [x5, 6]
	strh	w2, [x1, #:lo12:.LANCHOR6]
	strh	w7, [x6, #:lo12:.LANCHOR12]
	bne	.L10
	lsr	w2, w2, 1
	strh	w2, [x1, #:lo12:.LANCHOR6]
	mov	w2, 8
	strh	w2, [x6, #:lo12:.LANCHOR12]
.L10:
	adrp	x7, .LANCHOR13
	add	x7, x7, :lo12:.LANCHOR13
	mov	x2, 0
.L11:
	strb	w2, [x2, x7]
	add	x2, x2, 1
	cmp	x2, 32
	bne	.L11
	adrp	x2, .LANCHOR14
	mov	w7, 5
	cmp	w3, 1
	strh	w7, [x2, #:lo12:.LANCHOR14]
	adrp	x7, .LANCHOR15
	strh	wzr, [x7, #:lo12:.LANCHOR15]
	bne	.L12
	strh	w3, [x2, #:lo12:.LANCHOR14]
.L12:
	adrp	x2, .LANCHOR16
	mov	w3, 640
	mul	w4, w4, w0
	strh	w3, [x2, #:lo12:.LANCHOR16]
	adrp	x2, .LANCHOR3
	ldrh	w3, [x1, #:lo12:.LANCHOR6]
	and	w4, w4, 65535
	adrp	x1, .LANCHOR17
	strh	w4, [x2, #:lo12:.LANCHOR3]
	mul	w0, w0, w3
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR17]
	bl	Ftl_log2
	ldrh	w7, [x5, 12]
	adrp	x1, .LANCHOR18
	ldrh	w6, [x6, #:lo12:.LANCHOR12]
	adrp	x8, .LANCHOR19
	strh	w0, [x1, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR20
	mul	w1, w4, w7
	strh	w7, [x8, #:lo12:.LANCHOR19]
	strh	w7, [x0, #:lo12:.LANCHOR20]
	adrp	x0, .LANCHOR21
	strh	w1, [x0, #:lo12:.LANCHOR21]
	mov	w0, w6
	bl	Ftl_log2
	and	w10, w0, 65535
	adrp	x2, .LANCHOR22
	ubfiz	w1, w6, 9, 7
	strh	w0, [x2, #:lo12:.LANCHOR22]
	adrp	x0, .LANCHOR23
	strh	w1, [x0, #:lo12:.LANCHOR23]
	adrp	x0, .LANCHOR24
	ubfx	w1, w1, 8, 8
	strh	w1, [x0, #:lo12:.LANCHOR24]
	adrp	x0, .LANCHOR25
	ldrh	w1, [x5, 20]
	adrp	x5, .LANCHOR27
	strh	w1, [x0, #:lo12:.LANCHOR25]
	mul	w0, w4, w3
	adrp	x1, .LANCHOR8
	str	w0, [x1, #:lo12:.LANCHOR8]
	adrp	x1, .LANCHOR26
	mul	w0, w0, w6
	mul	w6, w6, w7
	mul	w0, w0, w7
	mov	x7, x2
	asr	w0, w0, 11
	str	w0, [x1, #:lo12:.LANCHOR26]
	mov	w0, 5120
	sdiv	w0, w0, w6
	and	w0, w0, 65535
	cmp	w0, 4
	bls	.L13
.L19:
	strh	w0, [x5, #:lo12:.LANCHOR27]
	adrp	x1, .LANCHOR28
	mov	w0, 640
	lsl	w3, w3, 6
	asr	w0, w0, w10
	add	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR28]
	add	w0, w10, 9
	adrp	x1, .LANCHOR30
	cmp	w4, 1
	asr	w3, w3, w0
	adrp	x0, .LANCHOR29
	adrp	x6, .LANCHOR2
	strh	w3, [x0, #:lo12:.LANCHOR29]
	and	w3, w3, 65535
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
	bls	.L37
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L37:
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
	cbz	w2, .L41
	adrp	x2, .LANCHOR39+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR39+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L43:
	cmp	w5, w4
	bgt	.L44
	cbz	w6, .L41
	add	x0, x0, :lo12:.LANCHOR38
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.L41:
	ret
.L44:
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
	b	.L43
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
	beq	.L54
	ldrh	w5, [x1, 2]
	mov	w3, 0
.L52:
	cmp	w3, w4
	bcc	.L53
.L54:
	mov	w0, 0
	ret
.L53:
	add	w2, w3, w5
	ubfiz	x2, x2, 1, 10
	add	x2, x1, x2
	ldrh	w2, [x2, 8]
	cmp	w2, w0
	beq	.L55
	add	w3, w3, 1
	b	.L52
.L55:
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
	bls	.L72
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
	cbnz	x12, .L59
	str	x5, [x1, #:lo12:.LANCHOR41]
.L72:
	mov	w0, 0
	ret
.L59:
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
.L67:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L58
	cmp	w1, w0
	beq	.L58
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L63
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L65
.L64:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L68
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR41]
	b	.L58
.L63:
	bcc	.L64
.L65:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L66
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR44
	str	x5, [x0, #:lo12:.LANCHOR44]
.L58:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L66:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L67
.L68:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L58
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
	bcs	.L74
	ldp	x29, x30, [sp], 16
	mov	w2, 214
	adrp	x1, .LANCHOR46
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC1
	b	printf
.L74:
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
	beq	.L78
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
	cbnz	x5, .L79
	str	x4, [x1, #:lo12:.LANCHOR47]
.L78:
	mov	w0, 0
	ret
.L79:
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
.L82:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L80
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L81
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L78
.L81:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L82
.L80:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L83
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR47]
	b	.L78
.L83:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L78
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
	bcs	.L84
	ldp	x29, x30, [sp], 16
	mov	w2, 207
	adrp	x1, .LANCHOR49
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC1
	b	printf
.L84:
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
	bne	.L88
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L88
	adrp	x1, .LANCHOR50
	adrp	x0, .LC1
	mov	w2, 372
	add	x1, x1, :lo12:.LANCHOR50
	add	x0, x0, :lo12:.LC1
	bl	printf
.L88:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L89
	cmp	w0, w1
	bne	.L90
	str	xzr, [x22]
.L91:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L90:
	ldr	x1, [x20, #:lo12:.LANCHOR40]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L91
.L89:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L92
	cmp	w1, w0
	beq	.L91
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	strh	w2, [x0, x1]
	b	.L91
.L92:
	ldr	x2, [x20, #:lo12:.LANCHOR40]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L91
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L100
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR40
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR40]
.L96:
	cbnz	w1, .L97
.L99:
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
.L97:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L99
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L96
.L100:
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
	cbz	x1, .L111
	adrp	x0, .LANCHOR40
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR40]
	mov	w0, 65535
.L108:
	cbz	w2, .L109
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L110
	ret
.L110:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L108
.L111:
	mov	w0, 65535
	ret
.L109:
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
	beq	.L114
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L114
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L114
	adrp	x0, .LANCHOR40
	mov	w21, 6
	adrp	x24, .LANCHOR41
	mov	x26, x0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR40]
	ldr	x1, [x24, #:lo12:.LANCHOR41]
	add	x22, x23, x21
	cmp	x22, x1
	beq	.L114
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
	bne	.L117
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L117
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 463
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.L117:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L118
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L114
.L118:
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
	bcs	.L114
	adrp	x20, .LANCHOR45
	mov	w1, w19
	add	x0, x24, :lo12:.LANCHOR41
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L120
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 474
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.L120:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L114:
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
.L125:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L127
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L128:
	cmp	w1, w2
	bne	.L130
	cmp	w19, w2
	bcc	.L126
	adrp	x1, .LANCHOR56
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR56]
	mov	w1, 0
.L131:
	cmp	w1, w2
	bne	.L133
	cmp	w19, w1
	bcc	.L126
	mov	w2, 789
	adrp	x1, .LANCHOR57
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR57
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L126
.L127:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L125
.L126:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L130:
	ldr	w4, [x3]
	tbnz	w4, #31, .L129
	cmp	w5, w4
	bls	.L129
	mov	w5, w4
	mov	w19, w1
.L129:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L128
.L133:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L132
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L132:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L131
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
	bhi	.L136
	cbnz	w0, .L136
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR58]
	ret
.L136:
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
.L137:
	cmp	w5, w1, uxth
	bhi	.L139
	cbz	w3, .L135
	str	w2, [x0, #:lo12:.LANCHOR59]
.L135:
	ret
.L139:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L138
	add	w2, w2, w4
	mov	w3, 1
.L138:
	add	x1, x1, 1
	b	.L137
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L146
	b	ftl_set_blk_mode.part.6
.L146:
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
.L149:
	cmp	w2, w3
	bcc	.L151
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
.L152:
	cmp	x2, x3
	bne	.L154
	ret
.L151:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L150
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L150:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L149
.L154:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L153
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L153:
	add	x2, x2, 2
	b	.L152
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	ldrh	w1, [x0, 4]
	cbz	w1, .L155
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L155
	ldrb	w2, [x0, 6]
	add	x2, x2, 8
	ldrh	w3, [x0, x2, lsl 1]
	adrp	x2, .LANCHOR3
	ldrh	w4, [x2, #:lo12:.LANCHOR3]
	mov	w2, w1
.L158:
	cmp	w3, w2
	beq	.L160
.L155:
	ret
.L160:
	ldrb	w1, [x0, 6]
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x0, 6]
	cmp	w1, w4
	bne	.L159
	ldrh	w1, [x0, 2]
	strb	wzr, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 2]
.L159:
	ldrb	w1, [x0, 6]
	add	x1, x1, 8
	ldrh	w3, [x0, x1, lsl 1]
	b	.L158
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
	bcc	.L162
	adrp	x1, .LANCHOR60
	adrp	x0, .LC1
	mov	w2, 2156
	add	x1, x1, :lo12:.LANCHOR60
	add	x0, x0, :lo12:.LC1
	bl	printf
.L162:
	adrp	x0, .LANCHOR3
	adrp	x7, .LANCHOR13
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR13
	ldrh	w8, [x0, #:lo12:.LANCHOR3]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L163:
	cmp	w8, w5, uxth
	bhi	.L165
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
.L165:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L164
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L164:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L163
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
	bhi	.L179
	cbz	w5, .L177
	mov	w0, 32768
	sdiv	w5, w0, w5
.L178:
	adrp	x0, .LANCHOR40
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L172:
	mov	w5, 0
	b	.L171
.L177:
	mov	w5, 0
	b	.L178
.L179:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L170:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L169
	add	w5, w5, w11
	and	w5, w5, 65535
.L169:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L170
	cbz	w5, .L172
	mov	w0, 32768
	sdiv	w5, w0, w5
.L171:
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
	cbz	x0, .L182
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
.L182:
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
	cbz	x1, .L190
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
.L186:
	cmp	w0, w2
	beq	.L189
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L187
.L189:
	adrp	x0, .LANCHOR43
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x0, x1]
	ret
.L187:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L186
.L190:
	mov	w0, 0
	ret
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L194
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
.L194:
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
	bne	.L198
	adrp	x1, .LANCHOR61
	adrp	x0, .LC1
	mov	w2, 2786
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC1
	bl	printf
.L198:
	adrp	x20, .LANCHOR19
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bne	.L199
	adrp	x1, .LANCHOR61
	adrp	x0, .LC1
	mov	w2, 2787
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC1
	bl	printf
.L199:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L200
	adrp	x1, .LANCHOR61
	adrp	x0, .LC1
	mov	w2, 2788
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC1
	bl	printf
.L200:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR3
	strb	wzr, [x19, 10]
	add	x0, x0, 8
	ldrh	w2, [x1, #:lo12:.LANCHOR3]
	mov	w1, 65535
	ldrh	w0, [x19, x0, lsl 1]
.L201:
	cmp	w0, w1
	beq	.L203
	ldrh	w21, [x19, 2]
	mov	w3, 65535
	ldrh	w1, [x19, 4]
	orr	w21, w21, w0, lsl 10
	ldrb	w0, [x19, 6]
	sub	w1, w1, #1
	and	w1, w1, 65535
	strh	w1, [x19, 4]
.L205:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w2, w0
	bne	.L204
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L204:
	add	x4, x19, x0, sxtw 1
	ldrh	w4, [x4, 16]
	cmp	w4, w3
	beq	.L205
	strb	w0, [x19, 6]
	ldrh	w2, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w2, w0
	bne	.L197
	cbz	w1, .L197
	adrp	x1, .LANCHOR61
	adrp	x0, .LC1
	mov	w2, 2809
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC1
	bl	printf
.L197:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L203:
	ldrb	w0, [x19, 6]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w0, w2
	bne	.L202
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L202:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L201
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlGcBufInit,"ax",@progbits
	.align	2
	.global	FtlGcBufInit
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	adrp	x1, .LANCHOR63
	adrp	x0, .LANCHOR62
	adrp	x7, .LANCHOR64
	adrp	x6, .LANCHOR65
	ldr	x5, [x1, #:lo12:.LANCHOR63]
	adrp	x1, .LANCHOR23
	str	wzr, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR3
	ldrh	w10, [x1, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR24
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	w8, 24
	ldrh	w11, [x1, #:lo12:.LANCHOR24]
	adrp	x1, .LANCHOR66
	ldr	x14, [x7, #:lo12:.LANCHOR64]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR66]
	mov	w2, 0
	ldr	x15, [x6, #:lo12:.LANCHOR65]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	mov	w1, 0
	mov	w16, 1
.L213:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L214
	adrp	x1, .LANCHOR67
	ldr	x7, [x7, #:lo12:.LANCHOR64]
	ldr	x6, [x6, #:lo12:.LANCHOR65]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR67]
.L215:
	cmp	w0, w4
	bcc	.L216
	ret
.L214:
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
	b	.L213
.L216:
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
	b	.L215
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",@progbits
	.align	2
	.global	FtlGcBufFree
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	adrp	x2, .LANCHOR67
	mov	w3, 0
	mov	w8, 24
	ldr	w7, [x2, #:lo12:.LANCHOR67]
	adrp	x2, .LANCHOR63
	ldr	x5, [x2, #:lo12:.LANCHOR63]
.L218:
	cmp	w3, w1
	bcs	.L217
	ubfiz	x4, x3, 5, 16
	mov	w2, 0
	add	x4, x0, x4
	b	.L223
.L219:
	add	w2, w2, 1
	and	w2, w2, 65535
.L223:
	cmp	w2, w7
	bcs	.L220
	umull	x6, w2, w8
	add	x10, x5, x6
	ldr	x11, [x5, x6]
	ldr	x6, [x4, 8]
	cmp	x11, x6
	bne	.L219
	str	wzr, [x10, 16]
.L220:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L218
.L217:
	ret
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",@progbits
	.align	2
	.global	FtlGcBufAlloc
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	adrp	x2, .LANCHOR67
	mov	w3, 0
	mov	w7, 24
	mov	w8, 1
	ldr	w5, [x2, #:lo12:.LANCHOR67]
	adrp	x2, .LANCHOR63
	ldr	x6, [x2, #:lo12:.LANCHOR63]
.L225:
	cmp	w3, w1
	bcs	.L224
	mov	w2, 0
	b	.L230
.L226:
	add	w2, w2, 1
	and	w2, w2, 65535
.L230:
	cmp	w2, w5
	bcs	.L227
	umaddl	x4, w2, w7, x6
	ldr	w10, [x4, 16]
	cbnz	w10, .L226
	ubfiz	x2, x3, 5, 16
	ldr	x10, [x4]
	add	x2, x0, x2
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x10, x4, [x2, 8]
.L227:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L225
.L224:
	ret
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",@progbits
	.align	2
	.global	IsBlkInGcList
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	adrp	x1, .LANCHOR68
	and	w0, w0, 65535
	ldrh	w2, [x1, #:lo12:.LANCHOR68]
	adrp	x1, .LANCHOR69
	ldr	x3, [x1, #:lo12:.LANCHOR69]
	mov	x1, 0
.L232:
	cmp	w2, w1, uxth
	bhi	.L234
	mov	w0, 0
	ret
.L234:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L232
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
	adrp	x4, .LANCHOR68
	adrp	x2, .LANCHOR69
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR68]
	ldr	x5, [x2, #:lo12:.LANCHOR69]
.L237:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L239
	bne	.L238
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR68]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR68]
	b	.L238
.L239:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L237
.L238:
	adrp	x4, .LANCHOR70
	adrp	x1, .LANCHOR71
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR70]
	ldr	x5, [x1, #:lo12:.LANCHOR71]
	umull	x3, w0, w3
	add	w0, w0, 1
	add	x7, x5, x3
	stp	w10, w8, [x7, 4]
	str	w6, [x5, x3]
	strh	w0, [x4, #:lo12:.LANCHOR70]
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	adrp	x4, .LANCHOR72
	and	w0, w0, 65535
	ldrh	w5, [x4, #:lo12:.LANCHOR72]
	cmp	w5, w0
	beq	.L242
	adrp	x1, .LANCHOR73
	ldrh	w3, [x1, #:lo12:.LANCHOR73]
	cmp	w0, w3
	beq	.L242
	mov	w2, 65535
	cmp	w5, w2
	bne	.L243
	strh	w0, [x4, #:lo12:.LANCHOR72]
.L242:
	mov	w0, 0
	ret
.L243:
	cmp	w3, w2
	bne	.L242
	strh	w0, [x1, #:lo12:.LANCHOR73]
	b	.L242
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",@progbits
	.align	2
	.global	FtlGcMarkBadPhyBlk
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	and	w6, w0, 65535
	stp	x29, x30, [sp, -16]!
	mov	w0, w6
	add	x29, sp, 0
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	adrp	x1, .LANCHOR74
	adrp	x3, .LANCHOR75
	add	x3, x3, :lo12:.LANCHOR75
	mov	x2, 0
	ldrh	w0, [x1, #:lo12:.LANCHOR74]
.L245:
	cmp	w0, w2, uxth
	bhi	.L247
	cmp	w0, 15
	bhi	.L246
	add	w2, w0, 1
	strh	w2, [x1, #:lo12:.LANCHOR74]
	adrp	x1, .LANCHOR75
	add	x1, x1, :lo12:.LANCHOR75
	strh	w6, [x1, w0, sxtw 1]
	b	.L246
.L247:
	add	x2, x2, 1
	add	x4, x3, x2, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w6
	bne	.L245
.L246:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	adrp	x0, .LANCHOR74
	ldrh	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L256
	adrp	x1, .LANCHOR72
	ldrh	w2, [x1, #:lo12:.LANCHOR72]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L256
	stp	x29, x30, [sp, -16]!
	adrp	x6, .LANCHOR76
	add	x29, sp, 0
	ldrh	w1, [x6, #:lo12:.LANCHOR76]
	cmp	w1, w0
	bcc	.L251
	strh	wzr, [x6, #:lo12:.LANCHOR76]
.L251:
	ldrh	w1, [x6, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR75
	add	x0, x0, :lo12:.LANCHOR75
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	w0, [x6, #:lo12:.LANCHOR76]
	ldp	x29, x30, [sp], 16
	add	w0, w0, 1
	strh	w0, [x6, #:lo12:.LANCHOR76]
	mov	w0, 0
	ret
.L256:
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
	adrp	x24, .LC2
	stp	x25, x26, [sp, 64]
	mov	w23, w2
	stp	x27, x28, [sp, 80]
	adrp	x25, .LC4
	mov	x28, x0
	mov	w27, w3
	add	x24, x24, :lo12:.LC2
	add	x25, x25, :lo12:.LC4
	stp	x19, x20, [sp, 16]
	mov	w21, 0
	mov	x19, 0
	mov	w20, 0
	adrp	x26, .LC3
.L262:
	cmp	w27, w19
	bhi	.L268
	ldp	x19, x20, [sp, 16]
	adrp	x0, .LC5
	ldp	x21, x22, [sp, 32]
	add	x0, x0, :lo12:.LC5
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L268:
	cbnz	w20, .L263
	mov	w2, w21
	mov	x1, x28
	mov	x0, x24
	bl	printf
.L263:
	cmp	w23, 4
	bne	.L264
	ldr	w1, [x22, x19, lsl 2]
.L271:
	add	x0, x26, :lo12:.LC3
.L270:
	bl	printf
	add	w20, w20, 1
	cmp	w20, 15
	bls	.L267
	mov	w20, 0
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
.L267:
	add	x19, x19, 1
	add	w21, w21, w23
	b	.L262
.L264:
	cmp	w23, 2
	bne	.L266
	ldrh	w1, [x22, x19, lsl 1]
	b	.L271
.L266:
	ldrb	w1, [x22, x19]
	mov	x0, x25
	b	.L270
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
	adrp	x25, .LANCHOR78
	str	x27, [sp, 80]
	lsl	w26, w24, 3
	mov	x22, x0
	add	x27, x25, :lo12:.LANCHOR78
.L273:
	cmp	x19, x23
	beq	.L287
	ldr	w0, [x19]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
	ldr	w0, [x29, 104]
	cbnz	w0, .L274
	ldr	w1, [x29, 108]
	cmp	w26, w1
	bls	.L274
	mov	x19, x20
	add	x21, x20, x21
	adrp	x22, .LC6
	adrp	x20, .LANCHOR77
	add	x22, x22, :lo12:.LC6
	add	x20, x20, :lo12:.LANCHOR77
	mov	w23, -1
.L275:
	cmp	x19, x21
	bne	.L276
.L287:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L276:
	ldr	w2, [x29, 108]
	mov	x1, x20
	str	w23, [x19]
	mov	x0, x22
	add	x19, x19, 32
	bl	printf
	ldr	x1, [x19, -24]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	rknand_print_hex
	ldr	x1, [x19, -16]
	mov	w3, 4
	adrp	x0, .LC8
	mov	w2, w3
	add	x0, x0, :lo12:.LC8
	bl	rknand_print_hex
	b	.L275
.L274:
	add	x1, x25, :lo12:.LANCHOR78
	ldr	x2, [x1, 8]
	ldr	w1, [x29, 108]
	blr	x2
	cbnz	w0, .L277
	str	wzr, [x19, -4]
.L278:
	add	x0, x22, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L280
	ldrb	w0, [x29, 104]
	ldr	x2, [x27, 8]
	ldr	w1, [x29, 108]
	add	w1, w24, w1
	blr	x2
	cbz	w0, .L280
	mov	w0, -1
	str	w0, [x19, -4]
.L280:
	add	x19, x19, 32
	b	.L273
.L277:
	mov	w0, -1
	str	w0, [x19, -4]
	b	.L278
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
	bcc	.L289
	adrp	x0, .LANCHOR38
	add	x2, x0, :lo12:.LANCHOR38
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L289
	and	w1, w1, 65535
	cbz	w1, .L291
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w21, w0, 65535
	adrp	x0, .LANCHOR79
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR43
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR80
	ldr	w0, [x1, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR80]
.L291:
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
.L289:
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
	cbz	w2, .L303
	ldrh	w0, [x1, 2]
	sub	w2, w2, #1
	strh	w2, [x1, 6]
	mov	w2, 1
	add	x3, x1, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x1, 2]
	adrp	x0, .LANCHOR79
	ldrh	w20, [x3, 8]
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	lsl	w1, w20, 10
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR80
	ldr	w0, [x1, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR80]
.L300:
	sub	w0, w20, #1
	mov	w1, 65533
	cmp	w1, w0, uxth
	bcs	.L301
	add	x0, x19, :lo12:.LANCHOR38
	mov	w1, w20
	ldrh	w2, [x0, 6]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
.L302:
	b	.L302
.L303:
	mov	w20, 65535
	b	.L300
.L301:
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
.L306:
	cmp	w20, w1
	beq	.L310
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L307
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L308
	adrp	x0, .LANCHOR38+6
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
.L309:
	b	.L309
.L308:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L310:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L312
	adrp	x1, .LANCHOR81
	adrp	x0, .LC1
	mov	w2, 578
	add	x1, x1, :lo12:.LANCHOR81
	add	x0, x0, :lo12:.LC1
	bl	printf
.L312:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L307:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L306
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
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR82
	mov	w1, 65535
	add	x29, sp, 0
	str	wzr, [x0, #:lo12:.LANCHOR82]
	adrp	x0, .LANCHOR83
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR21
	str	wzr, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR84
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR3
	str	wzr, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR85
	str	x23, [sp, 48]
	adrp	x21, .LANCHOR23
	str	wzr, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR86
	adrp	x23, .LANCHOR24
	str	wzr, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR87
	str	wzr, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR88
	str	wzr, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR89
	str	wzr, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR90
	str	wzr, [x0, #:lo12:.LANCHOR90]
	adrp	x0, .LANCHOR91
	str	wzr, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LANCHOR80
	str	wzr, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR92
	str	wzr, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR93
	str	wzr, [x0, #:lo12:.LANCHOR93]
	adrp	x0, .LANCHOR94
	str	wzr, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR95
	str	wzr, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR96
	str	w1, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LANCHOR97
	adrp	x1, .LANCHOR72
	str	wzr, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR98
	str	wzr, [x0, #:lo12:.LANCHOR98]
	adrp	x0, .LANCHOR99
	str	wzr, [x0, #:lo12:.LANCHOR99]
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR72]
	adrp	x1, .LANCHOR73
	strh	w0, [x1, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR100
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR100]
	adrp	x0, .LANCHOR101
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR102
	strh	wzr, [x0, #:lo12:.LANCHOR102]
	adrp	x0, .LANCHOR74
	strh	wzr, [x0, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR76
	strh	wzr, [x0, #:lo12:.LANCHOR76]
	ldrh	w0, [x19, #:lo12:.LANCHOR21]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR69
	str	x0, [x1, #:lo12:.LANCHOR69]
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR21]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x22, #:lo12:.LANCHOR3]
	adrp	x1, .LANCHOR71
	lsl	w20, w19, 5
	lsl	w19, w19, 7
	str	x0, [x1, #:lo12:.LANCHOR71]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR103
	str	x0, [x1, #:lo12:.LANCHOR103]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR104
	str	x0, [x1, #:lo12:.LANCHOR104]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR105
	str	x0, [x1, #:lo12:.LANCHOR105]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR79
	str	x0, [x1, #:lo12:.LANCHOR79]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR67
	adrp	x1, .LANCHOR66
	ldrh	w19, [x21, #:lo12:.LANCHOR23]
	str	x0, [x1, #:lo12:.LANCHOR66]
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR67]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR106
	str	x0, [x1, #:lo12:.LANCHOR106]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR107
	str	x0, [x1, #:lo12:.LANCHOR107]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR108
	str	x0, [x1, #:lo12:.LANCHOR108]
	ldr	w0, [x20, #:lo12:.LANCHOR67]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR64
	str	x0, [x1, #:lo12:.LANCHOR64]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR109
	str	x0, [x1, #:lo12:.LANCHOR109]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR110
	str	x0, [x1, #:lo12:.LANCHOR110]
	mov	w0, 24
	ldr	w1, [x20, #:lo12:.LANCHOR67]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR63
	str	x0, [x1, #:lo12:.LANCHOR63]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR111
	str	x0, [x1, #:lo12:.LANCHOR111]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR112
	str	x0, [x1, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR12
	ldrh	w0, [x0, #:lo12:.LANCHOR12]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR113
	ldrh	w19, [x23, #:lo12:.LANCHOR24]
	str	x0, [x1, #:lo12:.LANCHOR113]
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	adrp	x22, .LANCHOR30
	mul	w19, w19, w0
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR114
	str	x0, [x1, #:lo12:.LANCHOR114]
	lsl	w0, w19, 2
	bl	ftl_malloc
	adrp	x19, .LANCHOR6
	adrp	x1, .LANCHOR115
	str	x0, [x1, #:lo12:.LANCHOR115]
	ldrh	w1, [x23, #:lo12:.LANCHOR24]
	ldr	w0, [x20, #:lo12:.LANCHOR67]
	adrp	x20, .LANCHOR116
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR65
	str	x0, [x1, #:lo12:.LANCHOR65]
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x20, #:lo12:.LANCHOR116]
	and	w0, w0, 65534
	bl	ftl_malloc
	adrp	x1, .LANCHOR117
	str	x0, [x1, #:lo12:.LANCHOR117]
	ldrh	w0, [x20, #:lo12:.LANCHOR116]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x20, #:lo12:.LANCHOR116]
	lsl	w0, w0, 9
	bl	ftl_malloc
	adrp	x1, .LANCHOR118
	str	x0, [x1, #:lo12:.LANCHOR118]
	adrp	x1, .LANCHOR43
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR43]
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	lsl	w0, w0, 1
	bl	ftl_malloc
	ldr	w20, [x22, #:lo12:.LANCHOR30]
	adrp	x1, .LANCHOR42
	str	x0, [x1, #:lo12:.LANCHOR42]
	lsl	w20, w20, 1
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR119
	str	x0, [x1, #:lo12:.LANCHOR119]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR27
	adrp	x1, .LANCHOR120
	str	x0, [x1, #:lo12:.LANCHOR120]
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR1
	str	x0, [x1, #:lo12:.LANCHOR1]
	ldrh	w0, [x20, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR36
	str	x0, [x1, #:lo12:.LANCHOR36]
	ldrh	w0, [x20, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR121
	str	x0, [x1, #:lo12:.LANCHOR121]
	ldrh	w0, [x20, #:lo12:.LANCHOR27]
	adrp	x20, .LANCHOR28
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR122
	str	x0, [x1, #:lo12:.LANCHOR122]
	ldrh	w0, [x20, #:lo12:.LANCHOR28]
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldrh	w2, [x20, #:lo12:.LANCHOR28]
	adrp	x1, .LANCHOR123
	adrp	x20, .LANCHOR33
	str	x0, [x1, #:lo12:.LANCHOR123]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR32
	ldrh	w0, [x0, #:lo12:.LANCHOR32]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR124
	str	x0, [x1, #:lo12:.LANCHOR124]
	ldr	w0, [x22, #:lo12:.LANCHOR30]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR125
	str	x0, [x1, #:lo12:.LANCHOR125]
	ldrh	w0, [x20, #:lo12:.LANCHOR33]
	lsl	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR55
	str	x0, [x1, #:lo12:.LANCHOR55]
	ldrh	w1, [x20, #:lo12:.LANCHOR33]
	adrp	x20, .LANCHOR10
	ldrh	w0, [x21, #:lo12:.LANCHOR23]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	mov	w0, 6
	ldrh	w1, [x19, #:lo12:.LANCHOR6]
	adrp	x19, .LANCHOR127
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR40
	str	x0, [x1, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR17
	ldrh	w1, [x20, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x19, #:lo12:.LANCHOR127]
	mul	w0, w1, w0
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR37
	ldrh	w5, [x19, #:lo12:.LANCHOR127]
	add	x2, x1, :lo12:.LANCHOR37
	ldrh	w7, [x20, #:lo12:.LANCHOR10]
	add	x6, x2, 40
	mov	w3, w5
	str	x0, [x2, 32]
	mov	x0, 1
.L316:
	cmp	w0, w7
	bcc	.L317
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR37
	mov	x3, 0
.L318:
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L319
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L317:
	ldr	x4, [x2, 32]
	add	w0, w0, 1
	add	x4, x4, x3, uxtw 2
	add	w3, w3, w5
	str	x4, [x6], 8
	b	.L316
.L319:
	add	x4, x0, x3
	add	x4, x1, x4, lsl 3
	str	xzr, [x4, 24]
	b	.L318
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
	adrp	x0, .LANCHOR127
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR17
	adrp	x23, .LANCHOR128
	ldrh	w2, [x0, #:lo12:.LANCHOR127]
	add	x21, x21, :lo12:.LANCHOR17
	add	x23, x23, :lo12:.LANCHOR128
	stp	x19, x20, [sp, 16]
	mov	w24, 65535
	mov	x19, 0
	mov	x20, x1
	lsl	w2, w2, 2
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
.L324:
	ldrh	w0, [x22, x19]
	cmp	w0, w24
	beq	.L321
	ldrh	w1, [x21]
	cmp	w1, w0
	bhi	.L323
	adrp	x0, .LC1
	mov	w2, 74
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.L323:
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
	bne	.L324
.L321:
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
.L332:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L336
	adrp	x0, .LANCHOR20
	mov	w23, 0
	mov	w20, 0
	ldrh	w1, [x0, #:lo12:.LANCHOR20]
	ldrh	w0, [x19]
	strh	w1, [x21, x0, lsl 1]
	ldrh	w24, [x21]
.L337:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L341
	mov	w0, w23
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L336:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L333:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L335
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L332
.L335:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x22, x3]
	cmp	w4, w2
	bne	.L334
	cbz	w2, .L334
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L334:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L333
.L341:
	ubfiz	x0, x20, 1, 16
	ldrh	w1, [x21, x0]
	cmp	w24, w1
	bls	.L338
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbnz	w0, .L339
.L340:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L337
.L338:
	cbnz	w1, .L340
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbz	w0, .L340
.L342:
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x25]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	b	.L340
.L343:
	mov	w24, 0
	b	.L342
.L339:
	mov	w23, w20
	cbz	w1, .L343
	mov	w24, w1
	b	.L340
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
	adrp	x19, .LANCHOR120
	adrp	x20, .LANCHOR30
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR120]
	adrp	x22, .LANCHOR23
	ldr	w2, [x20, #:lo12:.LANCHOR30]
	adrp	x21, .LANCHOR33
	str	x23, [sp, 48]
	adrp	x23, .LANCHOR126
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR33]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR23]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR126]
	bl	ftl_memset
	adrp	x0, .LANCHOR55
	ldrh	w3, [x21, #:lo12:.LANCHOR33]
	ldr	x6, [x23, #:lo12:.LANCHOR126]
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR23]
	add	x3, x0, x3, lsl 4
.L353:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L354
	adrp	x1, .LANCHOR129
	add	x0, x1, :lo12:.LANCHOR129
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR129]
	ldr	w1, [x20, #:lo12:.LANCHOR30]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR130
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR130]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR32
	ldrh	w1, [x1, #:lo12:.LANCHOR32]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR119
	ldr	x1, [x1, #:lo12:.LANCHOR119]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR125
	ldr	x1, [x1, #:lo12:.LANCHOR125]
	str	x1, [x0, 24]
	ldr	x1, [x19, #:lo12:.LANCHOR120]
	ldp	x19, x20, [sp, 16]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR124
	ldr	x1, [x1, #:lo12:.LANCHOR124]
	str	x1, [x0, 40]
	ldp	x29, x30, [sp], 64
	ret
.L354:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L353
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR131
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LANCHOR132
	mov	w1, -1
	str	x19, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR132]
	adrp	x0, .LANCHOR133
	adrp	x19, .LANCHOR6
	str	wzr, [x0, #:lo12:.LANCHOR133]
	adrp	x0, .LANCHOR134
	str	w1, [x0, #:lo12:.LANCHOR134]
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
	adrp	x0, .LANCHOR117
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR117]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR39
	add	x0, x0, :lo12:.LANCHOR39
	bl	ftl_memset
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
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
.L359:
	ldrh	w0, [x25]
	cmp	w19, w0
	bcs	.L366
	adrp	x0, .LANCHOR19
	ldrh	w8, [x27, #:lo12:.LANCHOR3]
	mov	x6, 0
	mov	w5, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR19]
	b	.L367
.L361:
	ldrb	w0, [x26, x6]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L360
	add	w5, w5, w7
	and	w5, w5, 65535
.L360:
	add	x6, x6, 1
.L367:
	cmp	w8, w6, uxth
	bhi	.L361
	cbz	w5, .L362
	mov	w0, 32768
	sdiv	w5, w0, w5
.L363:
	ldr	x1, [x24, #:lo12:.LANCHOR40]
	mov	w0, 6
	umaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L364
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L364
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L364
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbnz	w0, .L365
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L364:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L359
.L362:
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	mov	w2, -1
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w2, [x1, x0]
	b	.L363
.L365:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L364
.L366:
	strh	w20, [x23, #:lo12:.LANCHOR45]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR48]
	cmp	w20, w0
	ble	.L368
	adrp	x1, .LANCHOR136
	adrp	x0, .LC1
	mov	w2, 2216
	add	x1, x1, :lo12:.LANCHOR136
	add	x0, x0, :lo12:.LC1
	bl	printf
.L368:
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
	adrp	x0, .LANCHOR68
	mov	w1, 255
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR70
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR21
	strh	wzr, [x0, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR69
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	ldr	x0, [x0, #:lo12:.LANCHOR69]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR71
	ldr	x0, [x0, #:lo12:.LANCHOR71]
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
	adrp	x0, .LANCHOR78
	mov	w1, w20
	ldr	x2, [x0, #:lo12:.LANCHOR78]
	mov	x0, x19
	blr	x2
	and	w0, w0, 65535
	cmp	w0, 50
	bls	.L373
	mov	w2, 256
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	mov	w0, 0
.L373:
	adrp	x1, .LANCHOR0+14
	ldrh	w1, [x1, #:lo12:.LANCHOR0+14]
	cmp	w1, 4
	bne	.L377
	mov	x1, 0
.L375:
	cmp	w0, w1, uxth
	bhi	.L376
.L377:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L376:
	ldrh	w2, [x19, x1, lsl 1]
	lsr	w2, w2, 1
	strh	w2, [x19, x1, lsl 1]
	add	x1, x1, 1
	b	.L375
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
	adrp	x24, .LANCHOR137
	stp	x19, x20, [sp, 16]
	add	x23, x0, x1
	ldrh	w27, [x2, 12]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	add	x24, x24, :lo12:.LANCHOR137
	adrp	x25, .LC1
	add	x25, x25, :lo12:.LC1
.L381:
	cmp	x23, x19
	bne	.L392
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L392:
	ldr	x0, [x19, 8]
	cbz	x0, .L382
	ldr	x0, [x19, 16]
	cbnz	x0, .L383
.L382:
	mov	w2, 90
	mov	x1, x24
	mov	x0, x25
	bl	printf
.L383:
	ldr	w0, [x19, 4]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
	ldr	w0, [x29, 104]
	cmp	w0, 3
	bls	.L384
	mov	w0, -1
	str	w0, [x19]
.L385:
	add	x19, x19, 32
	b	.L381
.L384:
	ldr	x20, [x19, 8]
	adrp	x26, .LANCHOR111
	tst	x20, 63
	beq	.L386
	ldr	x20, [x26, #:lo12:.LANCHOR111]
.L386:
	adrp	x22, .LANCHOR78
	add	x22, x22, :lo12:.LANCHOR78
	ldr	w1, [x29, 108]
	mov	x2, x20
	ldr	x3, [x19, 16]
	ldr	x4, [x22, 24]
	blr	x4
	str	w0, [x19]
	add	x0, x21, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L388
	ldrb	w0, [x29, 104]
	add	x2, x20, 2048
	ldr	x4, [x22, 24]
	ldr	w1, [x29, 108]
	ldr	x3, [x19, 16]
	add	w1, w27, w1
	add	x3, x3, 8
	blr	x4
	cmn	w0, #1
	beq	.L389
	ldr	x1, [x19, 16]
	ldr	w2, [x1, 12]
	cmn	w2, #1
	bne	.L390
	ldr	w2, [x1, 8]
	cmn	w2, #1
	bne	.L390
	ldr	w1, [x1]
	cmn	w1, #1
	beq	.L390
.L389:
	mov	w1, -1
	str	w1, [x19]
.L390:
	ldr	w1, [x19]
	cmn	w1, #1
	beq	.L388
	cmp	w0, 256
	bne	.L388
	str	w0, [x19]
.L388:
	ldr	x0, [x26, #:lo12:.LANCHOR111]
	cmp	x20, x0
	bne	.L385
	ldr	x0, [x19, 8]
	cmp	x20, x0
	beq	.L385
	adrp	x1, .LANCHOR12
	ldrh	w2, [x1, #:lo12:.LANCHOR12]
	mov	x1, x20
	lsl	w2, w2, 9
	bl	ftl_memcpy
	b	.L385
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR106
	adrp	x0, .LANCHOR138
	add	x1, x0, :lo12:.LANCHOR138
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR106]
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
	adrp	x2, .LANCHOR114
	adrp	x23, .LANCHOR10
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR114]
	add	x23, x23, :lo12:.LANCHOR10
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L410:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L415
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L415:
	ldrh	w19, [x26, #:lo12:.LANCHOR17]
	add	x24, x22, :lo12:.LANCHOR138
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L411:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L413
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
	beq	.L412
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L412
	strh	w19, [x20]
.L413:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L410
.L412:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L411
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
	bne	.L421
	adrp	x1, .LANCHOR20
	ldrh	w19, [x1, #:lo12:.LANCHOR20]
.L422:
	adrp	x1, .LANCHOR112
	sub	w19, w19, #1
	sxth	w19, w19
	lsl	w21, w0, 10
	ldr	x1, [x1, #:lo12:.LANCHOR112]
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
	bne	.L423
	mov	w22, 0
	mov	w24, 2
.L424:
	cmp	w22, w19
	ble	.L427
.L423:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 160
	ret
.L421:
	adrp	x1, .LANCHOR19
	ldrh	w19, [x1, #:lo12:.LANCHOR19]
	b	.L422
.L427:
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
	bne	.L425
	ldr	w0, [x29, 100]
	cmn	w0, #1
	bne	.L425
	ldr	w0, [x29, 64]
	cmn	w0, #1
	beq	.L425
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L424
.L425:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L424
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
	adrp	x25, .LANCHOR125
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR30
	ldr	x0, [x25, #:lo12:.LANCHOR125]
	adrp	x22, .LANCHOR122
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR130
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR35
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR119
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR130]
	strh	wzr, [x23, #:lo12:.LANCHOR35]
	bl	ftl_memset
	ldr	x0, [x27, #:lo12:.LANCHOR119]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	adrp	x19, .LANCHOR27
	adrp	x28, .LANCHOR36
	adrp	x24, .LANCHOR139
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR122]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldr	x0, [x28, #:lo12:.LANCHOR36]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 16
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR139
	bl	ftl_memset
	adrp	x0, .LANCHOR5
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR82
	add	x0, x0, :lo12:.LANCHOR82
	str	x0, [x29, 112]
.L433:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L473
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR103
	adrp	x6, .LANCHOR13
	mov	x5, 0
	ldrh	w12, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR64
	ldr	x7, [x25, #:lo12:.LANCHOR103]
	mov	w22, 0
	ldr	x11, [x0, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR65
	add	x6, x6, :lo12:.LANCHOR13
	ldr	x10, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x0, #:lo12:.LANCHOR24]
	b	.L474
.L435:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L434
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
.L434:
	add	x5, x5, 1
.L474:
	cmp	w12, w5, uxth
	bhi	.L435
	cbnz	w22, .L436
.L472:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L433
.L436:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
	str	x0, [x29, 136]
.L471:
	ldr	x0, [x25, #:lo12:.LANCHOR103]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L439
	mov	w5, 16
	mov	w7, 65535
.L441:
	ldr	x0, [x25, #:lo12:.LANCHOR103]
	add	x6, x25, :lo12:.LANCHOR103
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
	bne	.L438
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	bne	.L439
.L440:
	mov	w1, 1
	b	.L510
.L438:
	ldr	x0, [x25, #:lo12:.LANCHOR103]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L439
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L441
	b	.L440
.L439:
	adrp	x0, .LANCHOR82
	ldr	w1, [x0, #:lo12:.LANCHOR82]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L442
	cmp	w1, w0
	bhi	.L443
.L442:
	cmn	w0, #1
	beq	.L443
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L443:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L445
	bhi	.L446
	mov	w0, 61574
	cmp	w1, w0
	beq	.L447
.L444:
	ldr	x0, [x29, 128]
	add	x22, x22, 32
	cmp	x0, x22
	bne	.L471
	b	.L472
.L446:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L448
	mov	w0, 65535
	cmp	w1, w0
	bne	.L444
	mov	w1, 0
.L510:
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L444
.L448:
	ldrh	w1, [x20, #:lo12:.LANCHOR130]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L450
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1225
	add	x0, x0, :lo12:.LC1
	bl	printf
.L450:
	ldr	w6, [x21, #:lo12:.LANCHOR30]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR130]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR125]
	sxth	w2, w2
.L451:
	cmp	w0, w2
	bgt	.L457
	tbz	w0, #31, .L491
	b	.L444
.L457:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L452
	ldr	w2, [x5]
	cbnz	w2, .L453
	cmp	w6, w1
	beq	.L453
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR130]
.L453:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR119]
	mov	w1, 0
.L454:
	cmp	w1, w0
	bne	.L455
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L444
	ldrh	w1, [x20, #:lo12:.LANCHOR130]
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L444
.L491:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR130]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR119]
.L509:
	strh	w26, [x1, x0, lsl 1]
	b	.L444
.L455:
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
	b	.L454
.L452:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L451
.L447:
	ldrh	w1, [x23, #:lo12:.LANCHOR35]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	cmp	w1, w0
	bls	.L460
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1266
	add	x0, x0, :lo12:.LC1
	bl	printf
.L460:
	ldrh	w6, [x19, #:lo12:.LANCHOR27]
	ldrh	w2, [x23, #:lo12:.LANCHOR35]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR122]
.L461:
	cmp	w0, w5
	ble	.L466
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L462
	ldr	w5, [x1]
	cbnz	w5, .L463
	cmp	w6, w2
	beq	.L463
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR35]
.L463:
	ldr	x6, [x28, #:lo12:.LANCHOR36]
	mov	w2, 0
.L464:
	cmp	w2, w0
	bne	.L465
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L466:
	tbnz	w0, #31, .L444
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	ldrh	w5, [x23, #:lo12:.LANCHOR35]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L444
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR35]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	b	.L509
.L465:
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
	b	.L464
.L462:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L461
.L445:
	ldrh	w5, [x24, #:lo12:.LANCHOR139]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR139
	cmp	w5, w1
	bne	.L468
	strh	w26, [x24, #:lo12:.LANCHOR139]
	str	w0, [x2, 8]
	b	.L444
.L468:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L469
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L469:
	add	x0, x24, :lo12:.LANCHOR139
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L470
	ldrh	w2, [x24, #:lo12:.LANCHOR139]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR139]
	str	w1, [x0, 8]
	b	.L444
.L470:
	strh	w26, [x0, 4]
	b	.L444
.L473:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR119]
	ldrh	w0, [x2]
	cbz	w0, .L475
.L478:
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	ldrh	w0, [x1]
	cbz	w0, .L476
.L477:
	ldrh	w1, [x20, #:lo12:.LANCHOR130]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L507
	adrp	x1, .LANCHOR140
	adrp	x0, .LC1
	mov	w2, 1391
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.L507:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L475:
	ldrh	w0, [x20, #:lo12:.LANCHOR130]
	cbz	w0, .L478
	ldr	w1, [x21, #:lo12:.LANCHOR30]
	mov	w0, 0
.L479:
	cmp	w0, w1
	bcs	.L478
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L480
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR30
	ldr	x4, [x1, #:lo12:.LANCHOR125]
	mov	w1, w0
.L481:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L478
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
	b	.L481
.L480:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L479
.L476:
	ldrh	w0, [x23, #:lo12:.LANCHOR35]
	cbz	w0, .L477
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	mov	w0, 0
.L486:
	mov	w6, w0
	cmp	w0, w2
	bge	.L477
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L487
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR27
	ldr	x3, [x2, #:lo12:.LANCHOR122]
.L488:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L477
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
	b	.L488
.L487:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L486
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR106
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR17
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR138
	add	x20, x22, :lo12:.LANCHOR138
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	str	x25, [sp, 64]
	mov	w25, 61649
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR114
	ldr	x21, [x0, #:lo12:.LANCHOR114]
	str	x21, [x20, 16]
	bl	FtlBbtMemInit
	ldrh	w19, [x24, #:lo12:.LANCHOR17]
	add	x24, x24, :lo12:.LANCHOR17
	sub	w19, w19, #1
	and	w19, w19, 65535
.L512:
	ldrh	w0, [x24]
	sub	w0, w0, #15
	cmp	w0, w19
	bgt	.L515
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L513
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L513:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L514
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L514
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	strh	w19, [x1, #:lo12:.LANCHOR37]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L515:
	adrp	x19, .LANCHOR37
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR37
	ldrh	w1, [x19, #:lo12:.LANCHOR37]
	cmp	w1, w0
	beq	.L529
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L519
	add	x0, x22, :lo12:.LANCHOR138
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR138]
	cmn	w0, #1
	beq	.L519
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L519
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L519
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR37]
	strh	w0, [x20, 4]
.L519:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	add	x24, x19, :lo12:.LANCHOR37
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR138
.L521:
	tbz	w20, #31, .L524
	adrp	x1, .LANCHOR141
	adrp	x0, .LC1
	mov	w2, 253
	add	x1, x1, :lo12:.LANCHOR141
	add	x0, x0, :lo12:.LC1
	bl	printf
.L523:
	add	x0, x19, :lo12:.LANCHOR37
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L526
	adrp	x1, .LANCHOR2
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	cmp	w0, w2
	beq	.L526
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L526
	cmp	w0, w1
	bcs	.L526
	bl	FtlSysBlkNumInit
.L526:
	add	x19, x19, :lo12:.LANCHOR37
	adrp	x21, .LANCHOR10
	adrp	x23, .LANCHOR127
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR10
	add	x23, x23, :lo12:.LANCHOR127
	add	x22, x22, :lo12:.LANCHOR138
	mov	w20, 0
.L527:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L528
	mov	w0, 0
.L511:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L514:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L512
.L524:
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	str	x0, [x24, 8]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L522
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L523
.L522:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L521
.L528:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L527
.L529:
	mov	w0, -1
	b	.L511
	.size	FtlLoadBbt, .-FtlLoadBbt
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
	adrp	x22, .LANCHOR142
	stp	w3, w2, [x29, 104]
	add	x2, x21, :lo12:.LANCHOR0
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR78
	stp	x27, x28, [sp, 80]
	mov	x19, x0
	ldrh	w23, [x2, 12]
	add	x20, x0, x1
	stp	x25, x26, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR142
	mov	x25, x0
	add	x28, x24, :lo12:.LANCHOR78
	lsl	w27, w23, 3
.L542:
	cmp	x25, x20
	bne	.L555
	ldr	w0, [x29, 104]
	cbz	w0, .L568
	adrp	x21, .LANCHOR111
	adrp	x22, .LANCHOR113
	mov	x23, x21
	mov	x24, x22
.L557:
	cmp	x19, x20
	beq	.L568
	ldr	x1, [x21, #:lo12:.LANCHOR111]
	ldr	x0, [x22, #:lo12:.LANCHOR113]
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
	bne	.L558
	ldr	w1, [x19, 4]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
	str	w26, [x19]
.L558:
	ldr	x0, [x19, 16]
	cbz	x0, .L559
	ldr	w2, [x0]
	ldr	x0, [x24, #:lo12:.LANCHOR113]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L559
	ldr	w1, [x19, 4]
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L559:
	ldr	x0, [x19, 8]
	cbz	x0, .L560
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR111]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L560
	ldr	w1, [x19, 4]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L560:
	add	x19, x19, 32
	b	.L557
.L555:
	ldr	x0, [x25, 8]
	cbz	x0, .L543
	ldr	x0, [x25, 16]
	cbnz	x0, .L544
.L543:
	adrp	x0, .LC1
	mov	w2, 134
	mov	x1, x22
	add	x0, x0, :lo12:.LC1
	bl	printf
.L544:
	ldr	w0, [x25, 4]
	add	x2, x29, 120
	add	x1, x29, 124
	bl	l2p_addr_tran.isra.0
	ldr	w0, [x29, 120]
	cmp	w0, 3
	bls	.L545
.L581:
	mov	w0, -1
	str	w0, [x25]
	b	.L546
.L545:
	cbnz	w0, .L547
	ldr	w0, [x29, 124]
	cmp	w27, w0
	bls	.L547
	adrp	x21, .LANCHOR142
	adrp	x22, .LC6
	mov	w23, -1
	add	x21, x21, :lo12:.LANCHOR142
	add	x22, x22, :lo12:.LC6
	b	.L579
.L549:
	ldr	w2, [x19, 4]
	mov	x1, x21
	str	w23, [x19]
	mov	x0, x22
	add	x19, x19, 32
	bl	printf
	ldr	x1, [x19, -24]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	rknand_print_hex
	ldr	x1, [x19, -16]
	mov	w3, 4
	adrp	x0, .LC8
	mov	w2, w3
	add	x0, x0, :lo12:.LC8
	bl	rknand_print_hex
.L579:
	cmp	x19, x20
	bne	.L549
.L568:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L547:
	ldr	x1, [x25, 8]
	tst	x1, 63
	beq	.L562
	adrp	x0, .LANCHOR111
	ldr	x26, [x0, #:lo12:.LANCHOR111]
	cmp	x1, x26
	beq	.L550
	adrp	x0, .LANCHOR12
	ldrh	w2, [x0, #:lo12:.LANCHOR12]
	mov	x0, x26
	lsl	w2, w2, 9
	bl	ftl_memcpy
.L550:
	add	x0, x24, :lo12:.LANCHOR78
	ldr	w1, [x29, 124]
	ldr	x3, [x25, 16]
	mov	x2, x26
	ldr	x6, [x0, 16]
	ldrb	w0, [x29, 120]
	blr	x6
	cbnz	w0, .L551
	str	wzr, [x25]
.L552:
	add	x0, x21, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L546
	ldrb	w0, [x29, 120]
	add	x2, x26, 2048
	ldr	x6, [x28, 16]
	ldr	w1, [x29, 124]
	ldr	x3, [x25, 16]
	add	w1, w23, w1
	add	x3, x3, 8
	blr	x6
	cbnz	w0, .L581
.L546:
	add	x25, x25, 32
	b	.L542
.L562:
	mov	x26, x1
	b	.L550
.L551:
	mov	w0, -1
	str	w0, [x25]
	b	.L552
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
	adrp	x0, .LANCHOR99
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR3
	stp	x25, x26, [sp, 64]
	and	w22, w1, 255
	str	w23, [x0, #:lo12:.LANCHOR99]
	adrp	x21, .LANCHOR79
	adrp	x0, .LANCHOR110
	adrp	x1, .LANCHOR115
	adrp	x25, .LANCHOR24
	ldrh	w8, [x20, #:lo12:.LANCHOR3]
	ldr	x6, [x21, #:lo12:.LANCHOR79]
	mov	w24, 0
	ldr	x10, [x0, #:lo12:.LANCHOR110]
	mov	w19, 0
	ldr	x11, [x1, #:lo12:.LANCHOR115]
	ldrh	w12, [x25, #:lo12:.LANCHOR24]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 112]
.L583:
	cmp	w8, w5, uxth
	bhi	.L587
	cbz	w24, .L582
	mov	w2, w24
	ubfiz	x24, x24, 5, 16
	mov	x26, 0
	mov	w1, 0
	mov	x0, x6
	bl	FlashEraseBlocks
.L591:
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	add	x1, x0, x26
	ldr	w0, [x0, x26]
	cmn	w0, #1
	bne	.L590
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L590:
	add	x26, x26, 32
	cmp	x26, x24
	bne	.L591
	cbz	w22, .L604
	adrp	x0, .LANCHOR20
	mov	w26, 1
	ldrh	w28, [x0, #:lo12:.LANCHOR20]
.L592:
	add	x0, x20, :lo12:.LANCHOR3
	adrp	x27, .LANCHOR13
	str	x0, [x29, 120]
	mov	w24, 0
	add	x0, x27, :lo12:.LANCHOR13
	str	x0, [x29, 104]
.L600:
	ldr	x0, [x29, 120]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR79]
	mov	w20, 0
	ldrh	w11, [x25, #:lo12:.LANCHOR24]
	ldrh	w7, [x0]
	adrp	x0, .LANCHOR109
	ldr	x8, [x0, #:lo12:.LANCHOR109]
	ldr	x0, [x29, 112]
	ldr	x10, [x0, #:lo12:.LANCHOR110]
.L593:
	cmp	w7, w5, uxth
	bhi	.L596
	cbz	w20, .L582
	mov	w1, w20
	mov	w3, 1
	mov	w2, w26
	mov	x0, x6
	bl	FlashProgPages
	mov	x27, 0
	ubfiz	x1, x20, 5, 16
.L599:
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	add	x3, x0, x27
	ldr	w0, [x0, x27]
	cbz	w0, .L598
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	str	x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldr	x1, [x29, 96]
.L598:
	add	x27, x27, 32
	cmp	x1, x27
	bne	.L599
	add	w24, w24, 1
	cmp	w28, w24, uxth
	bhi	.L600
	mov	x24, 0
.L602:
	cbz	w22, .L601
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	add	x1, x0, x24
	ldr	w0, [x0, x24]
	cbnz	w0, .L601
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.L601:
	add	x24, x24, 32
	cmp	x24, x27
	bne	.L602
	cmp	w23, 63
	ccmp	w22, 0, 0, hi
	beq	.L582
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	mov	w2, w20
	mov	w1, w26
	bl	FlashEraseBlocks
.L582:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L587:
	lsl	x0, x5, 5
	mov	w1, w23
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w22, .L584
	bl	IsBlkInVendorPart
	cbnz	w0, .L585
.L584:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L586
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
.L585:
	add	x5, x5, 1
	b	.L583
.L586:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L585
.L604:
	mov	w26, 0
	mov	w28, 2
	b	.L592
.L596:
	lsl	x0, x5, 5
	mov	w1, w23
	str	wzr, [x6, x0]
	ldr	x0, [x29, 104]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w12, w0, 65535
	mov	w13, w12
	cbz	w22, .L594
	bl	IsBlkInVendorPart
	cbnz	w0, .L595
.L594:
	mov	w0, w13
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L595
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
.L595:
	add	x5, x5, 1
	b	.L593
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
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
	bls	.L628
	adrp	x20, .LANCHOR112
	mov	w2, 32
	mov	w1, 165
	lsl	w19, w19, 10
	ldr	x0, [x20, #:lo12:.LANCHOR112]
	str	x0, [x29, 40]
	add	x0, x29, 64
	str	x0, [x29, 48]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR112]
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
	cbnz	w0, .L629
	add	w0, w19, 1
	mov	w3, 1
	str	w0, [x29, 36]
	mov	w2, w3
	mov	w1, w3
	add	x0, x29, 32
	bl	FlashProgPages
	ldr	w0, [x29, 32]
	cmp	w0, 0
	csetm	w20, ne
.L627:
	mov	w2, 1
	mov	w1, 0
	add	x0, x29, 32
	str	w19, [x29, 36]
	bl	FlashEraseBlocks
.L625:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 128
	ret
.L629:
	mov	w20, -1
	b	.L627
.L628:
	mov	w20, 0
	b	.L625
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR114
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR138
	stp	x21, x22, [sp, 32]
	add	x19, x20, :lo12:.LANCHOR138
	adrp	x22, .LANCHOR106
	ldr	x1, [x23, #:lo12:.LANCHOR114]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR37
	str	x27, [sp, 80]
	add	x25, x21, :lo12:.LANCHOR37
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	adrp	x26, .LANCHOR10
	stp	x0, x1, [x19, 8]
	adrp	x1, .LANCHOR23
	adrp	x27, .LANCHOR127
	add	x25, x25, 32
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w24, 0
	add	x26, x26, :lo12:.LANCHOR10
	add	x27, x27, :lo12:.LANCHOR127
	mov	w1, 0
	bl	ftl_memset
.L632:
	ldrh	w0, [x26]
	cmp	w24, w0
	blt	.L633
	add	x20, x20, :lo12:.LANCHOR138
	add	x19, x21, :lo12:.LANCHOR37
	mov	w2, 16
	mov	w1, 255
	adrp	x24, .LC14
	adrp	x26, .LANCHOR20
	ldr	x27, [x20, 16]
	add	x24, x24, :lo12:.LC14
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
.L634:
	ldrh	w1, [x19]
	ldrh	w4, [x27, 10]
	ldrh	w2, [x19, 2]
	ldrh	w3, [x19, 4]
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	str	x0, [x20, 8]
	ldr	x0, [x23, #:lo12:.LANCHOR114]
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
	blt	.L635
	ldr	w0, [x19, 8]
	mov	w2, 1
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	str	w0, [x27, 4]
	ldrh	w0, [x19]
	strh	w0, [x27, 8]
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR79
	strh	w1, [x19]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	str	w1, [x20, 4]
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
.L635:
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
	bne	.L636
	ldr	w1, [x20, 4]
	add	w21, w21, 1
	adrp	x0, .LC15
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC15
	bl	printf
	cmp	w21, 3
	bls	.L634
	ldr	w1, [x20, 4]
	adrp	x0, .LC16
	mov	w2, w21
	add	x0, x0, :lo12:.LC16
	bl	printf
.L638:
	b	.L638
.L633:
	ldrh	w2, [x27]
	ldr	x1, [x25], 8
	ldr	x0, [x19, 8]
	mul	w3, w24, w2
	lsl	w2, w2, 2
	add	w24, w24, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L632
.L639:
	mov	w25, 1
	b	.L634
.L636:
	cbz	w25, .L639
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
.L642:
	ldr	x1, [x29, 104]
	adrp	x23, .LANCHOR5
	ldrh	w0, [x28, #:lo12:.LANCHOR48]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L643
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2661
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L643:
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	cmp	x19, x0
	bne	.L669
	adrp	x1, .LANCHOR95
	ldrh	w0, [x24]
	ldr	w1, [x1, #:lo12:.LANCHOR95]
	mul	w1, w0, w1
	lsr	w0, w0, 1
	add	w0, w0, 1
	add	w1, w0, w1, lsr 2
	ands	w1, w1, 65535
	beq	.L644
	sub	w1, w1, #1
	and	w1, w1, 65535
.L644:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_pop_index_node
	and	w22, w0, 65535
	ldrh	w0, [x24]
	cbnz	w0, .L645
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2670
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L645:
	ldrh	w0, [x24]
	sub	w0, w0, #1
	strh	w0, [x24]
	ldrh	w0, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w22
	bls	.L642
	adrp	x25, .LANCHOR42
	ubfiz	x20, x22, 1, 16
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w21, [x0, x20]
	cbnz	w21, .L642
	strh	w22, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L647
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
	ble	.L642
	mov	w2, 2684
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L642
.L669:
	mov	w1, 0
	b	.L644
.L647:
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x24]
	add	w0, w0, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L649
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2687
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L649:
	adrp	x0, .LANCHOR3
	adrp	x25, .LANCHOR79
	add	x26, x19, 16
	mov	w6, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	x4, x26
	ldr	x3, [x25, #:lo12:.LANCHOR79]
	ubfiz	x0, x0, 5, 16
	add	x1, x3, 8
	add	x0, x0, 8
	add	x0, x3, x0
.L650:
	cmp	x0, x1
	bne	.L652
	cbnz	w21, .L653
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2698
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L653:
	adrp	x0, .LANCHOR144
	ldrh	w0, [x0, #:lo12:.LANCHOR144]
	cmp	w0, w22
	bne	.L654
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2700
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L654:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR43
	adrp	x7, .LANCHOR14
	adrp	x5, .LANCHOR90
	adrp	x4, .LANCHOR91
	ldr	x1, [x6, #:lo12:.LANCHOR43]
	cbnz	w0, .L655
	ldrh	w0, [x1, x20]
	cbz	w0, .L656
	ldrh	w2, [x7, #:lo12:.LANCHOR14]
	add	w0, w0, w2
.L680:
	strh	w0, [x1, x20]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR90]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR90]
	mov	w0, w22
	bl	ftl_set_blk_mode
.L658:
	ldr	x0, [x6, #:lo12:.LANCHOR43]
	ldrh	w1, [x0, x20]
	adrp	x0, .LANCHOR92
	ldr	w2, [x0, #:lo12:.LANCHOR92]
	cmp	w1, w2
	bls	.L659
	str	w1, [x0, #:lo12:.LANCHOR92]
.L659:
	ldr	w2, [x5, #:lo12:.LANCHOR90]
	ldr	w1, [x4, #:lo12:.LANCHOR91]
	ldrh	w0, [x7, #:lo12:.LANCHOR14]
	madd	w0, w0, w2, w1
	ldrh	w1, [x23, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR145
	str	w0, [x1, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR118
	ldr	x1, [x0, #:lo12:.LANCHOR118]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR79]
	ubfiz	x1, x21, 5, 16
	add	x1, x1, 4
	add	x2, x0, 4
	add	x1, x0, x1
.L660:
	cmp	x1, x2
	bne	.L661
	ldrb	w1, [x19, 8]
	mov	w2, w21
	mov	x23, 0
	bl	FlashEraseBlocks
	mov	w1, 0
.L662:
	cmp	w21, w23, uxth
	bhi	.L664
	cbz	w1, .L665
	mov	w0, w22
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L665:
	ldrb	w0, [x19, 7]
	cbnz	w0, .L666
	adrp	x0, .LANCHOR42
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	w1, [x0, x20]
	b	.L642
.L652:
	ldrh	w2, [x4]
	stp	xzr, xzr, [x1]
	cmp	w2, w6
	beq	.L651
	ubfiz	x5, x21, 5, 16
	add	w21, w21, 1
	add	x5, x3, x5
	and	w21, w21, 65535
	lsl	w2, w2, 10
	str	w2, [x5, 4]
.L651:
	add	x1, x1, 32
	add	x4, x4, 2
	b	.L650
.L656:
	mov	w0, 2
	b	.L680
.L655:
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
	ldr	w0, [x4, #:lo12:.LANCHOR91]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR91]
	mov	w0, w22
	bl	ftl_set_blk_mode.part.6
	b	.L658
.L661:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 32
	b	.L660
.L664:
	ldr	x2, [x25, #:lo12:.LANCHOR79]
	lsl	x0, x23, 5
	add	x3, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L663
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
.L663:
	add	x23, x23, 1
	add	x26, x26, 2
	b	.L662
.L666:
	adrp	x1, .LANCHOR19
	adrp	x2, .LANCHOR82
	strh	wzr, [x19, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	strh	w22, [x19]
	strb	wzr, [x19, 6]
	mul	w0, w0, w1
	ldr	w1, [x2, #:lo12:.LANCHOR82]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR82]
	adrp	x1, .LANCHOR42
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w0, [x1, x20]
	ldrh	w0, [x19, 4]
	cbz	w0, .L667
	ldrb	w0, [x19, 7]
	cbnz	w0, .L668
.L667:
	adrp	x1, .LANCHOR143
	adrp	x0, .LC1
	mov	w2, 2753
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC1
	bl	printf
.L668:
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
	adrp	x21, .LANCHOR74
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR74]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	cbz	w0, .L682
	adrp	x23, .LANCHOR75
	add	x24, x23, :lo12:.LANCHOR75
	mov	w19, 0
.L683:
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w0, w19
	bhi	.L689
	bl	FtlGcReFreshBadBlk
.L682:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L689:
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR74
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L684:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L688
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L683
.L688:
	add	x0, x23, :lo12:.LANCHOR75
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L685
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L686:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L687
	sub	w1, w1, #1
	strh	w1, [x22]
.L685:
	and	w20, w27, 65535
	b	.L684
.L687:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L686
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
	cbnz	w0, .L695
	adrp	x0, .LANCHOR144
	ldrh	w1, [x0, #:lo12:.LANCHOR144]
	cmp	w1, w19
	bne	.L696
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR144]
.L697:
	adrp	x20, .LANCHOR45
	mov	w1, w19
	adrp	x0, .LANCHOR41
	add	x0, x0, :lo12:.LANCHOR41
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L699
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 2823
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.L699:
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
	ble	.L703
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 2826
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.L703:
	mov	w0, 1
	b	.L694
.L696:
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L702
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L702
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bne	.L697
.L702:
	mov	w0, 0
.L694:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L695:
	mov	w0, w19
	bl	List_update_data_list
	b	.L702
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
	beq	.L706
	adrp	x21, .LANCHOR42
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L707
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x0, x20]
	cbz	w0, .L708
.L713:
	mov	w20, 0
.L705:
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L708:
	mov	w2, 2841
	adrp	x1, .LANCHOR147
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L713
.L707:
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L706:
	adrp	x21, .LANCHOR131
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR131]
	cmp	w0, w1
	bne	.L710
	strh	w19, [x21, #:lo12:.LANCHOR131]
	b	.L713
.L710:
	cmp	w19, w0
	beq	.L713
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR41
	strh	w19, [x21, #:lo12:.LANCHOR131]
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
	cbnz	w1, .L705
	cmp	w19, w0, uxth
	beq	.L705
	mov	w2, 2857
	adrp	x1, .LANCHOR147
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L705
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR114
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w0, -1
	stp	x21, x22, [sp, 32]
	str	w0, [x29, 72]
	adrp	x0, .LANCHOR106
	ldr	x21, [x1, #:lo12:.LANCHOR114]
	mov	w1, -3
	ldr	x0, [x0, #:lo12:.LANCHOR106]
	adrp	x22, .LANCHOR83
	str	x21, [x29, 64]
	add	x22, x22, :lo12:.LANCHOR83
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
.L720:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L716
.L717:
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
.L716:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 52]
	cmn	w0, #1
	beq	.L717
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
	bne	.L720
	b	.L717
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
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
	adrp	x28, .LANCHOR138
	add	x21, x21, 12
	add	x25, x28, :lo12:.LANCHOR138
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	str	x0, [x29, 120]
.L729:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L735
	adrp	x21, .LANCHOR25
	add	x21, x21, :lo12:.LANCHOR25
	mov	w19, 0
.L736:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L737
	add	x21, x20, :lo12:.LANCHOR37
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L738:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L742
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L739
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L740
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L739:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L738
.L735:
	adrp	x2, .LANCHOR114
	adrp	x0, .LANCHOR106
	add	x19, x28, :lo12:.LANCHOR138
	ldrh	w1, [x21]
	ldr	x0, [x0, #:lo12:.LANCHOR106]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR114]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR17
	str	x2, [x29, 112]
	beq	.L730
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
.L731:
	mov	w0, w27
	add	w22, w22, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x21, x21, 2
	b	.L729
.L730:
	mov	w1, w22
	bl	FlashGetBadBlockList
	ldr	x0, [x19, 8]
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
	ldrh	w19, [x23, #:lo12:.LANCHOR17]
	add	x23, x23, :lo12:.LANCHOR17
	adrp	x0, .LANCHOR127
	sub	w19, w19, #1
	add	x0, x0, :lo12:.LANCHOR127
	and	w19, w19, 65535
	str	x0, [x29, 104]
.L732:
	ldrh	w0, [x23]
	madd	w0, w22, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L733
	ldr	x0, [x29, 112]
	mov	w2, 16
	strh	w19, [x21]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR114]
	bl	ftl_memset
	adrp	x0, .LANCHOR106
	mov	w2, 4096
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR106]
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
	bne	.L731
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L732
.L733:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L732
.L737:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L736
.L740:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L741
	strh	w19, [x21]
	b	.L739
.L741:
	strh	w19, [x21, 4]
.L742:
	adrp	x0, .LANCHOR79
	add	x19, x20, :lo12:.LANCHOR37
	ldrh	w1, [x20, #:lo12:.LANCHOR37]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR79]
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
	.section	.text.ftl_memcmp,"ax",@progbits
	.align	2
	.global	ftl_memcmp
	.type	ftl_memcmp, %function
ftl_memcmp:
	uxtw	x2, w2
	b	memcmp
	.size	ftl_memcmp, .-ftl_memcmp
	.section	.text.js_hash,"ax",@progbits
	.align	2
	.global	js_hash
	.type	js_hash, %function
js_hash:
	mov	x4, x0
	mov	w0, 42982
	mov	x3, 0
	movk	w0, 0x47c6, lsl 16
.L750:
	cmp	w1, w3
	bhi	.L751
	ret
.L751:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L750
	.size	js_hash, .-js_hash
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
	stp	x23, x24, [sp, 48]
	cmp	w0, w1
	bne	.L753
	ldrh	w0, [x19, 8]
	cbz	w0, .L754
	adrp	x1, .LANCHOR148
	adrp	x0, .LC1
	mov	w2, 641
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC1
	bl	printf
.L754:
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
.L755:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L753:
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR114
	adrp	x24, .LANCHOR106
	ldr	x23, [x19, 40]
	ldr	x21, [x2, #:lo12:.LANCHOR114]
	ldrh	w22, [x20, x0]
	adrp	x20, .LANCHOR138
	ldrh	w0, [x19, 2]
	add	x1, x20, :lo12:.LANCHOR138
	orr	w0, w0, w22, lsl 10
	str	w0, [x1, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR106]
	str	x21, [x1, 16]
	str	x0, [x1, 8]
	ldr	w1, [x19, 48]
	str	w1, [x21, 4]
	mov	w1, -1291
	strh	w1, [x21, 8]
	ldrh	w1, [x19, 4]
	strh	w1, [x21]
	adrp	x1, .LANCHOR20
	strh	w22, [x21, 2]
	ldrh	w2, [x1, #:lo12:.LANCHOR20]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
	ldrh	w4, [x19, 6]
	mov	x0, 0
	ldr	x3, [x24, #:lo12:.LANCHOR106]
	mov	w1, 0
.L756:
	cmp	w4, w0, uxth
	bhi	.L758
	add	x20, x20, :lo12:.LANCHOR138
	adrp	x0, .LANCHOR23
	ldrh	w1, [x0, #:lo12:.LANCHOR23]
	ldr	x0, [x20, 8]
	bl	js_hash
	str	w0, [x21, 12]
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	mov	x0, x20
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L755
.L758:
	ldr	w2, [x23, x0, lsl 2]
	cmp	w22, w2, lsr 10
	bne	.L757
	add	w1, w1, 1
	and	w1, w1, 65535
	ubfiz	x2, x1, 1, 16
	str	w0, [x3, x2, lsl 2]
	add	x2, x2, 1
	ldr	w5, [x23, x0, lsl 2]
	str	w5, [x3, x2, lsl 2]
.L757:
	add	x0, x0, 1
	b	.L756
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",@progbits
	.align	2
	.global	FtlMapWritePage
	.type	FtlMapWritePage, %function
FtlMapWritePage:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR88
	stp	x25, x26, [sp, 64]
	adrp	x24, .LANCHOR149
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR20
	stp	x19, x20, [sp, 16]
	mov	w25, w1
	mov	x19, x0
	mov	x27, x2
	add	x23, x23, :lo12:.LANCHOR88
	add	x24, x24, :lo12:.LANCHOR149
	add	x28, x26, :lo12:.LANCHOR20
	stp	x21, x22, [sp, 32]
	mov	w22, 0
.L764:
	ldr	w0, [x23]
	ldrh	w1, [x19, 2]
	add	w0, w0, 1
	str	w0, [x23]
	ldrh	w0, [x26, #:lo12:.LANCHOR20]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L765
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L766
.L765:
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.L766:
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L767
	adrp	x0, .LC1
	mov	w2, 700
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L767:
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L768
	adrp	x0, .LC1
	mov	w2, 701
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.L768:
	ldrh	w1, [x19]
	adrp	x21, .LANCHOR138
	ldr	x0, [x19, 16]
	add	x20, x21, :lo12:.LANCHOR138
	mov	w2, 16
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x19, 2]
	str	w3, [x29, 108]
	str	x27, [x20, 8]
	orr	w0, w0, w3, lsl 10
	str	w0, [x20, 4]
	adrp	x0, .LANCHOR114
	ldr	x0, [x0, #:lo12:.LANCHOR114]
	str	x0, [x20, 16]
	bl	ftl_memset
	ldr	x6, [x20, 16]
	ldr	w0, [x19, 48]
	ldr	w3, [x29, 108]
	str	w0, [x6, 4]
	ldrh	w0, [x19, 4]
	strh	w0, [x6]
	adrp	x0, .LANCHOR23
	strh	w3, [x6, 2]
	strh	w25, [x6, 8]
	ldrh	w1, [x0, #:lo12:.LANCHOR23]
	ldr	x0, [x20, 8]
	bl	js_hash
	str	w0, [x6, 12]
	mov	w3, 1
	mov	x0, x20
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	ldr	w1, [x21, #:lo12:.LANCHOR138]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L769
	ldr	w1, [x20, 4]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	add	w22, w22, 1
	and	w22, w22, 65535
	bl	printf
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L770
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L770:
	cmp	w22, 3
	bls	.L771
	add	x21, x21, :lo12:.LANCHOR138
	adrp	x0, .LC19
	mov	w2, w22
	add	x0, x0, :lo12:.LC19
	ldr	w1, [x21, 4]
	bl	printf
.L772:
	b	.L772
.L771:
	ldr	w0, [x19, 52]
	cbz	w0, .L764
.L786:
	b	.L786
.L769:
	cmp	w0, 1
	beq	.L775
	cmp	w1, 256
	beq	.L775
	ldr	w0, [x19, 56]
	cbz	w0, .L776
.L775:
	str	wzr, [x19, 56]
	b	.L764
.L776:
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
	bcs	.L789
	adrp	x1, .LANCHOR150
	adrp	x0, .LC1
	mov	w2, 485
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC1
	bl	printf
.L789:
	adrp	x27, .LANCHOR124
	ubfiz	x0, x20, 2, 16
	adrp	x22, .LANCHOR55
	ldr	x1, [x27, #:lo12:.LANCHOR124]
	ldr	w23, [x1, x0]
	cbnz	w23, .L790
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
.L791:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L790:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
	adrp	x26, .LANCHOR138
	add	x21, x26, :lo12:.LANCHOR138
	add	x0, x0, x19
	mov	w2, 1
	mov	w1, w2
	str	w23, [x21, 4]
	ldr	x0, [x0, 8]
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR114
	ldr	x0, [x0, #:lo12:.LANCHOR114]
	str	x0, [x21, 16]
	mov	x0, x21
	bl	FlashReadPages
	ldr	x25, [x21, 16]
	ldrh	w0, [x25, 8]
	cmp	w0, w20
	beq	.L792
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	bl	printf
	ldr	x1, [x21, 16]
	mov	w3, 4
	adrp	x0, .LC21
	mov	w2, w3
	add	x0, x0, :lo12:.LC21
	bl	rknand_print_hex
	ldrh	w3, [x24, #:lo12:.LANCHOR32]
	adrp	x0, .LC22
	ldr	x1, [x27, #:lo12:.LANCHOR124]
	mov	w2, 4
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
.L793:
	ldrh	w0, [x25, 8]
	cmp	w0, w20
	beq	.L794
	adrp	x1, .LANCHOR150
	adrp	x0, .LC1
	mov	w2, 508
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC1
	bl	printf
.L794:
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	strh	w20, [x0, x19]
	b	.L791
.L792:
	ldr	w0, [x26, #:lo12:.LANCHOR138]
	cmp	w0, 256
	bne	.L793
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	mov	w1, w20
	add	x0, x0, x19
	ldr	x2, [x0, 8]
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	FtlMapWritePage
	b	.L793
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
	blt	.L797
	ubfiz	x0, x0, 1, 16
	ldrh	w22, [x20, x0]
	cbz	w22, .L797
	ldr	w1, [x19, 52]
	cbnz	w1, .L797
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x24, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L798
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L798:
	adrp	x26, .LANCHOR138
	adrp	x23, .LANCHOR151
	add	x27, x26, :lo12:.LANCHOR138
	add	x23, x23, :lo12:.LANCHOR151
	mov	w20, 0
.L799:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L806
	mov	w1, 1
	mov	w0, w22
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L797:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x24, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L807
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L807:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L806:
	ubfiz	x0, x20, 2, 16
	add	x28, x25, x0
	ldr	w1, [x25, x0]
	cmp	w22, w1, lsr 10
	bne	.L800
	adrp	x2, .LANCHOR107
	add	x0, x26, :lo12:.LANCHOR138
	ldr	x2, [x2, #:lo12:.LANCHOR107]
	str	x2, [x0, 8]
	adrp	x2, .LANCHOR114
	str	w1, [x0, 4]
	ldr	x21, [x2, #:lo12:.LANCHOR114]
	mov	w2, 1
	str	x21, [x0, 16]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x21, 8]
	cmp	w0, w20
	beq	.L801
	adrp	x0, .LC1
	mov	w2, 611
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.L801:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L802
.L804:
	str	wzr, [x28]
.L803:
	b	.L803
.L802:
	ldrh	w0, [x21, 8]
	cmp	w0, w20
	bne	.L804
	ldrh	w1, [x21]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L804
	ldr	x2, [x27, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.L800:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L799
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
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
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
.L816:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L818
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L818:
	ldr	x1, [x21, #:lo12:.LANCHOR55]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L817
	mov	w0, w19
	bl	flush_l2p_region
.L817:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L816
	.size	l2p_flush, .-l2p_flush
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
	adrp	x0, .LANCHOR152
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	mov	w21, w2
	cmp	w25, w1
	bcc	.L821
	adrp	x1, .LANCHOR153
	adrp	x0, .LC1
	mov	w2, 813
	add	x1, x1, :lo12:.LANCHOR153
	add	x0, x0, :lo12:.LC1
	bl	printf
.L821:
	ldr	w0, [x19, #:lo12:.LANCHOR152]
	cmp	w25, w0
	bcs	.L822
	adrp	x23, .LANCHOR55
	add	w24, w24, 7
	adrp	x0, .LANCHOR33
	ldr	x2, [x23, #:lo12:.LANCHOR55]
	lsr	w22, w25, w24
	and	w22, w22, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR33]
	mov	x0, 0
.L823:
	and	x19, x0, 65535
	cmp	w19, w1
	bcc	.L828
	bl	select_l2p_ram_region
	and	x19, x0, 65535
	ldr	x2, [x23, #:lo12:.LANCHOR55]
	ubfiz	x1, x19, 4, 16
	mov	w26, w0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L829
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L829
	bl	flush_l2p_region
.L829:
	mov	w1, w26
	mov	w0, w22
	bl	load_l2p_region
	b	.L825
.L822:
	mov	w0, -1
	cbnz	w21, .L820
	str	w0, [x20]
.L820:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L828:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L823
.L825:
	mov	x0, 1
	ldr	x1, [x23, #:lo12:.LANCHOR55]
	lsl	x0, x0, x24
	sub	w0, w0, #1
	and	w0, w0, w25
	and	x0, x0, 65535
	add	x1, x1, x19, lsl 4
	cbnz	w21, .L826
	ldr	x1, [x1, 8]
	ldr	w0, [x1, x0, lsl 2]
	str	w0, [x20]
.L827:
	ldr	x0, [x23, #:lo12:.LANCHOR55]
	add	x19, x0, x19, lsl 4
	ldr	w0, [x19, 4]
	cmn	w0, #1
	beq	.L831
	add	w0, w0, 1
	str	w0, [x19, 4]
.L831:
	mov	w0, 0
	b	.L820
.L826:
	ldr	x2, [x1, 8]
	ldr	w3, [x20]
	str	w3, [x2, x0, lsl 2]
	ldr	w0, [x1, 4]
	orr	w0, w0, -2147483648
	str	w0, [x1, 4]
	adrp	x0, .LANCHOR56
	strh	w22, [x0, #:lo12:.LANCHOR56]
	b	.L827
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
	cbnz	w1, .L835
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L836
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
.L837:
	cmp	w1, w4
	beq	.L836
	cmp	w19, w3
	bne	.L838
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cbnz	w0, .L839
	adrp	x1, .LANCHOR154
	adrp	x0, .LC1
	mov	w2, 1733
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC1
	bl	printf
.L839:
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR48]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L836:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L838:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L836
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L837
.L835:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L836
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	beq	.L968
	ldrb	w0, [x19, 6]
	str	w0, [x29, 164]
	adrp	x0, .LANCHOR19
	ldrh	w26, [x19, 2]
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR19]
	cmp	w2, w26
	bne	.L848
	strh	wzr, [x19, 4]
.L976:
	strb	wzr, [x19, 6]
.L968:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L848:
	ldrh	w0, [x19, 16]
	mov	w20, 0
.L849:
	cmp	w0, w1
	beq	.L850
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	mov	w23, w0
	cmn	w0, #1
	beq	.L851
	adrp	x1, .LANCHOR64
	adrp	x2, .LANCHOR3
	adrp	x20, .LANCHOR103
	add	x4, x19, 16
	ldr	x5, [x1, #:lo12:.LANCHOR64]
	adrp	x1, .LANCHOR23
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	mov	w22, 0
	ldrh	w6, [x1, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR65
	mov	w10, 65535
	str	x2, [x29, 152]
	ldr	x7, [x1, #:lo12:.LANCHOR65]
	adrp	x1, .LANCHOR24
	ldrh	w8, [x1, #:lo12:.LANCHOR24]
	add	x1, x19, 16
	str	x1, [x29, 168]
	ldrh	w1, [x2, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L852:
	cmp	x4, x1
	bne	.L856
	mov	w2, 0
	mov	w1, w22
	bl	FlashReadPages
	adrp	x0, .LANCHOR83
	ldr	x4, [x20, #:lo12:.LANCHOR103]
	and	w10, w23, 65535
	add	x7, x0, :lo12:.LANCHOR83
	ldr	w21, [x0, #:lo12:.LANCHOR83]
	mov	x11, x4
	mov	w6, 65535
	mov	w3, 0
	sub	w21, w21, #1
	str	x0, [x29, 144]
.L857:
	cmp	w22, w3
	bne	.L862
	add	w22, w23, 1
	ldr	w0, [x4, 4]
	and	w22, w22, 65535
.L970:
	lsr	w0, w0, 10
	bl	P2V_plane
	and	w27, w0, 65535
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w22
	bne	.L864
	strh	w22, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L864:
	ldr	w0, [x29, 164]
	cmp	w22, w26
	cset	w1, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w1, w0
	beq	.L865
.L977:
	mov	w2, w27
	mov	w1, w22
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L968
.L850:
	add	w20, w20, 1
	and	w20, w20, 65535
	add	x0, x19, x20, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L849
.L851:
	cbz	w26, .L853
	adrp	x1, .LANCHOR155
	adrp	x0, .LC1
	mov	w2, 1800
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	bl	printf
.L853:
	ldr	w0, [x29, 164]
	cmp	w0, 0
	ccmp	w20, w0, 4, ne
	beq	.L854
	adrp	x1, .LANCHOR155
	adrp	x0, .LC1
	mov	w2, 1801
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	bl	printf
.L854:
	strh	wzr, [x19, 2]
	b	.L976
.L856:
	ldrh	w3, [x4]
	cmp	w3, w10
	beq	.L855
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
.L855:
	add	x4, x4, 2
	b	.L852
.L862:
	ldr	w0, [x11]
	cbnz	w0, .L858
	ldr	x8, [x11, 16]
	ldr	w5, [x8, 4]
	cmn	w5, #1
	beq	.L859
	ldr	w1, [x7]
	mov	w0, w5
	bl	ftl_cmp_data_ver
	cbz	w0, .L859
	add	w5, w5, 1
	str	w5, [x7]
.L859:
	ldr	w0, [x8]
	cmn	w0, #1
	bne	.L861
	ubfiz	x3, x3, 5, 16
	and	w22, w23, 65535
	add	x3, x4, x3
	ldr	w0, [x3, 4]
	b	.L970
.L858:
	mov	w6, w10
.L861:
	add	w3, w3, 1
	add	x11, x11, 32
	and	w3, w3, 65535
	b	.L857
.L865:
	mov	w0, 65535
	cmp	w6, w0
	bne	.L866
	ldrb	w0, [x19, 8]
	cbnz	w0, .L867
.L866:
	adrp	x25, .LANCHOR134
	and	w28, w23, 65535
	ldr	w0, [x25, #:lo12:.LANCHOR134]
	cmn	w0, #1
	bne	.L868
	str	w21, [x25, #:lo12:.LANCHOR134]
.L868:
	add	w0, w26, 7
	cmp	w0, w23, uxth
	bge	.L920
	sub	w24, w28, #7
	and	w24, w24, 65535
.L869:
	ldr	x0, [x29, 152]
	mov	w3, 65535
	mov	w5, 1
	add	x4, x0, :lo12:.LANCHOR3
.L870:
	cmp	w24, w28
	bhi	.L880
	ldrh	w1, [x4]
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	add	x1, x1, 8
	ldr	x2, [x29, 168]
	add	x1, x19, x1, lsl 1
	b	.L881
.L920:
	mov	w24, w26
	b	.L869
.L872:
	ldrh	w6, [x2]
	cmp	w6, w3
	beq	.L871
	ubfiz	x7, x23, 5, 16
	add	w23, w23, 1
	add	x7, x0, x7
	and	w23, w23, 65535
	orr	w6, w24, w6, lsl 10
	str	w6, [x7, 4]
.L871:
	add	x2, x2, 2
.L881:
	cmp	x1, x2
	bne	.L872
	mov	w1, w23
	mov	w2, 0
	str	w5, [x29, 112]
	ubfiz	x23, x23, 5, 16
	str	w3, [x29, 120]
	add	x23, x23, 16
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x2, [x20, #:lo12:.LANCHOR103]
	ldr	w1, [x25, #:lo12:.LANCHOR134]
	ldr	w5, [x29, 112]
	add	x0, x2, 16
	ldr	w3, [x29, 120]
	add	x23, x2, x23
	ldr	x4, [x29, 136]
	mov	w2, 0
.L873:
	cmp	x23, x0
	bne	.L878
	cbz	w2, .L879
	str	w1, [x25, #:lo12:.LANCHOR134]
.L879:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L870
.L878:
	ldr	w6, [x0, -16]
	cbz	w6, .L874
	cbz	w2, .L867
	str	w1, [x25, #:lo12:.LANCHOR134]
.L867:
	adrp	x0, .LANCHOR156
	mov	w24, w26
	mov	w1, 1
	adrp	x28, .LANCHOR134
	strh	w1, [x0, #:lo12:.LANCHOR156]
	add	x0, x28, :lo12:.LANCHOR134
	str	x0, [x29, 104]
.L882:
	ldr	x1, [x29, 152]
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	mov	w5, 65535
	ldr	x2, [x29, 168]
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L883:
	cmp	x1, x2
	bne	.L885
	mov	w2, 0
	mov	w1, w23
	bl	FlashReadPages
	mov	x25, 0
	ubfiz	x0, x23, 5, 16
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR157
	add	x0, x0, :lo12:.LANCHOR157
	str	x0, [x29, 120]
.L886:
	ldr	x0, [x29, 112]
	cmp	x0, x25
	bne	.L914
	ldr	x0, [x29, 128]
	add	w24, w24, 1
	and	w24, w24, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w24
	bne	.L882
	ldr	x0, [x29, 152]
	mov	w2, 65535
	strh	w24, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.L915:
	cmp	w0, w1
	beq	.L968
	ldr	x4, [x29, 168]
	ldrh	w3, [x4], 2
	str	x4, [x29, 168]
	cmp	w3, w2
	beq	.L916
	strb	w0, [x19, 6]
	b	.L968
.L874:
	ldr	x6, [x0]
	ldrh	w7, [x6]
	cmp	w7, w3
	beq	.L877
	ldr	w6, [x6, 4]
	cmn	w6, #1
	csel	w1, w1, w6, eq
	csel	w2, w2, w5, eq
.L877:
	add	x0, x0, 32
	b	.L873
.L880:
	mov	w0, -1
	str	w0, [x25, #:lo12:.LANCHOR134]
	b	.L867
.L885:
	ldrh	w3, [x2]
	cmp	w3, w5
	beq	.L884
	ubfiz	x4, x23, 5, 16
	add	w23, w23, 1
	add	x4, x0, x4
	and	w23, w23, 65535
	orr	w3, w24, w3, lsl 10
	str	w3, [x4, 4]
.L884:
	add	x2, x2, 2
	b	.L883
.L914:
	ldr	x4, [x20, #:lo12:.LANCHOR103]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 188]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w24, w26
	bcc	.L887
	ldr	w1, [x29, 164]
	ccmp	w1, w0, 0, eq
	bhi	.L887
	cmp	w24, w22
	ccmp	w27, w0, 0, eq
	beq	.L888
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L889
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L890
	ldrh	w0, [x19]
.L974:
	bl	decrement_vpc_count
	b	.L887
.L890:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L891
	ldr	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR83]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L891
	ldr	x1, [x29, 144]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR83]
.L891:
	ldp	w23, w0, [x3, 8]
	add	x1, x29, 184
	str	w0, [x29, 180]
	mov	w2, 0
	mov	w0, w23
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR134]
	ldr	w3, [x29, 180]
	cmn	w1, #1
	beq	.L892
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L892
	cmn	w3, #1
	beq	.L893
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	mov	w2, 0
	mov	w1, 1
	add	x0, x0, x25
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	ldr	x4, [x29, 136]
	add	x3, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L894
.L895:
	mov	w0, -1
	str	w0, [x29, 180]
.L902:
	ldr	w3, [x29, 180]
	cmn	w3, #1
	beq	.L887
.L919:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w23, w0, 65535
	adrp	x0, .LANCHOR5
	mov	w3, w23
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w23
	bhi	.L910
	mov	w2, 2065
	adrp	x1, .LANCHOR155
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	str	w23, [x29, 136]
	bl	printf
	ldr	w3, [x29, 136]
.L910:
	adrp	x1, .LANCHOR42
	ubfiz	x0, x23, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L911
	mov	w0, w3
	b	.L974
.L893:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	bne	.L887
	mov	w2, 1
	add	x1, x29, 180
	mov	w0, w23
	bl	log2phys
.L887:
	add	x25, x25, 32
	b	.L886
.L894:
	ldr	w0, [x4, 8]
	cmp	w23, w0
	bne	.L895
	ldr	w0, [x4, 4]
	str	w0, [x29, 136]
	str	x4, [x29, 96]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR134]
	bl	ftl_cmp_data_ver
	cbz	w0, .L895
	ldp	w0, w1, [x29, 184]
	ldr	x4, [x29, 96]
	cmp	w0, w1
	ldr	w1, [x29, 180]
	bne	.L897
.L971:
	mov	w0, w23
	bl	FtlReUsePrevPpa
	b	.L895
.L897:
	cmp	w0, w1
	beq	.L895
	cmn	w0, #1
	beq	.L898
	ldr	x4, [x3, 16]
	mov	w2, 0
	str	w0, [x3, 4]
	mov	w1, 1
	str	x4, [x29, 96]
	mov	x0, x3
	bl	FlashReadPages
	ldr	x4, [x29, 96]
.L899:
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L900
	ldr	x0, [x29, 104]
	ldr	w3, [x4, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L900
	ldr	w0, [x29, 136]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L895
.L900:
	ldr	w1, [x29, 180]
	b	.L971
.L898:
	str	w0, [x3]
	b	.L899
.L892:
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	beq	.L902
	adrp	x0, .LANCHOR8
	ldr	w0, [x0, #:lo12:.LANCHOR8]
	cmp	w0, w3, lsr 10
	bhi	.L904
	cmn	w3, #1
.L973:
	bne	.L887
	mov	w2, 1
	add	x1, x29, 188
	mov	w0, w23
	bl	log2phys
	ldr	w3, [x29, 184]
	cmn	w3, #1
	beq	.L902
	ldr	w0, [x29, 180]
	cmp	w3, w0
	beq	.L919
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR51
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, w0
	beq	.L909
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	beq	.L909
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L902
.L909:
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L902
	ldr	x4, [x29, 136]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L902
	mov	w2, 1
	add	x1, x29, 184
	mov	w0, w23
	bl	log2phys
	b	.L902
.L904:
	ldr	x0, [x20, #:lo12:.LANCHOR103]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 136]
	bl	FlashReadPages
	ldr	x4, [x29, 136]
	ldr	w0, [x4, 8]
	cmp	w23, w0
	bne	.L887
	ldrh	w1, [x4]
	mov	w0, 61589
	cmp	w1, w0
	b	.L973
.L911:
	mov	w1, w23
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
	b	.L887
.L889:
	ldr	x0, [x29, 120]
	ldr	w0, [x0]
	cmp	w0, 31
	bhi	.L912
	adrp	x1, .LANCHOR158
	add	x1, x1, :lo12:.LANCHOR158
	str	w5, [x1, w0, uxtw 2]
	add	w0, w0, 1
	ldr	x1, [x29, 120]
	str	w0, [x1]
.L912:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR134]
	cmn	w0, #1
	bne	.L913
.L975:
	str	w21, [x28, #:lo12:.LANCHOR134]
	b	.L887
.L913:
	cmp	w21, w0
	bcs	.L887
	b	.L975
.L916:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L915
.L888:
	strb	w27, [x19, 6]
	strh	w22, [x19, 2]
	b	.L977
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.ftl_check_vpc,"ax",@progbits
	.align	2
	.global	ftl_check_vpc
	.type	ftl_check_vpc, %function
ftl_check_vpc:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR152
	add	x23, x23, :lo12:.LANCHOR152
	stp	x21, x22, [sp, 32]
	mov	w22, 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR159
	stp	x27, x28, [sp, 80]
	add	x1, x21, :lo12:.LANCHOR159
	adrp	x20, check_vpc_table
	bl	printf
	add	x19, x20, :lo12:check_vpc_table
	mov	w2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
.L979:
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L981
	adrp	x22, .LANCHOR5
	adrp	x24, .LC26
	add	x22, x22, :lo12:.LANCHOR5
	add	x26, x20, :lo12:check_vpc_table
	add	x24, x24, :lo12:.LC26
	mov	w23, 0
	mov	w19, 0
	adrp	x25, .LANCHOR42
.L982:
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L984
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L985
	adrp	x0, .LANCHOR48
	adrp	x25, .LC27
	add	x20, x20, :lo12:check_vpc_table
	add	x25, x25, :lo12:.LC27
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
.L986:
	cmp	w22, w26
	bne	.L988
.L985:
	cbz	w23, .L978
	adrp	x0, .LC1
	mov	w2, 2389
	add	x1, x21, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.L978:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L981:
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L980
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L980:
	add	w22, w22, 1
	b	.L979
.L984:
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L983
	mov	w1, w19
	mov	x0, x24
	bl	printf
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L983
	ldrh	w1, [x26, x27, lsl 1]
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.L983:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L982
.L988:
	ldr	x1, [x27, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L987
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w23, 1
	mov	w1, w19
	mov	x0, x25
	bl	printf
.L987:
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	umull	x19, w19, w28
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L985
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L986
	.size	ftl_check_vpc, .-ftl_check_vpc
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	sub	sp, sp, #96
	adrp	x0, .LC28
	mov	w1, 0
	add	x0, x0, :lo12:.LC28
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR138
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR152
	add	x22, x20, :lo12:.LANCHOR138
	add	x21, x21, :lo12:.LANCHOR152
	str	x23, [sp, 64]
	bl	printf
.L1004:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L1010
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L1010:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L1005
	ldr	w2, [x29, 76]
	adrp	x0, .LC29
	mov	w1, w19
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1005:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L1007
	add	x0, x20, :lo12:.LANCHOR138
	str	wzr, [x20, #:lo12:.LANCHOR138]
	mov	w2, 0
	str	w1, [x0, 4]
	adrp	x1, .LANCHOR106
	str	w19, [x0, 24]
	ldr	x1, [x1, #:lo12:.LANCHOR106]
	str	x1, [x0, 8]
	adrp	x1, .LANCHOR114
	ldr	x23, [x1, #:lo12:.LANCHOR114]
	mov	w1, 1
	str	x23, [x0, 16]
	bl	FlashReadPages
	ldr	w0, [x20, #:lo12:.LANCHOR138]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L1008
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L1007
.L1008:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC30
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC30
	mov	w1, w19
	bl	printf
.L1007:
	add	w19, w19, 1
	b	.L1004
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR160
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x26, #:lo12:.LANCHOR160]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w20, w0
	stp	x27, x28, [sp, 80]
	beq	.L1033
	cbnz	w20, .L1013
.L1014:
	bl	FtlGcPageVarInit
	b	.L1015
.L1033:
	mov	w20, 0
.L1013:
	adrp	x0, .LANCHOR19
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w1
	beq	.L1014
.L1015:
	adrp	x27, .LANCHOR152
	add	x27, x27, :lo12:.LANCHOR152
.L1016:
	ldrh	w0, [x19]
	mov	w23, 65535
	strb	wzr, [x19, 8]
	cmp	w0, w23
	beq	.L1017
.L1032:
	adrp	x1, .LANCHOR64
	adrp	x24, .LANCHOR103
	add	x4, x19, 16
	mov	w21, 0
	ldr	x5, [x1, #:lo12:.LANCHOR64]
	adrp	x1, .LANCHOR23
	ldr	x0, [x24, #:lo12:.LANCHOR103]
	ldrh	w6, [x1, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR65
	ldr	x7, [x1, #:lo12:.LANCHOR65]
	adrp	x1, .LANCHOR24
	ldrh	w8, [x1, #:lo12:.LANCHOR24]
	adrp	x1, .LANCHOR3
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1018:
	cmp	x4, x1
	bne	.L1020
	mov	w1, w21
	ubfiz	x21, x21, 5, 16
	mov	x22, 0
	mov	w2, 0
	bl	FlashReadPages
.L1021:
	cmp	x21, x22
	bne	.L1031
	adrp	x0, .LANCHOR19
	add	w20, w20, 1
	and	w20, w20, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w20
	bhi	.L1032
.L1017:
	strh	w20, [x19, 2]
	mov	w0, -1
	strb	wzr, [x19, 6]
	mov	w1, w20
	strh	w0, [x26, #:lo12:.LANCHOR160]
	mov	w2, 0
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	mov	w0, -1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1020:
	ldrh	w3, [x4]
	cmp	w3, w23
	beq	.L1019
	ubfiz	x2, x21, 5, 16
	orr	w3, w20, w3, lsl 10
	add	x2, x0, x2
	str	w3, [x2, 4]
	mul	w3, w21, w6
	asr	w3, w3, 2
	add	x3, x5, x3, sxtw 2
	str	x3, [x2, 8]
	mul	w3, w21, w8
	add	w21, w21, 1
	and	w21, w21, 65535
	asr	w3, w3, 2
	add	x3, x7, x3, sxtw 2
	str	x3, [x2, 16]
.L1019:
	add	x4, x4, 2
	b	.L1018
.L1031:
	ldr	x1, [x24, #:lo12:.LANCHOR103]
	add	x0, x1, x22
	ldr	w1, [x1, x22]
	ldr	w28, [x0, 4]
	cbnz	w1, .L1022
	ldr	x25, [x0, 16]
	ldrh	w0, [x25]
	cmp	w0, w23
	beq	.L1022
	ldr	w0, [x25, 8]
	ldr	w1, [x27]
	cmp	w0, w1
	bls	.L1024
.L1022:
	adrp	x0, .LANCHOR42
	ldrh	w1, [x19]
	mov	w20, 0
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x19]
	bl	FtlGcPageVarInit
	b	.L1016
.L1024:
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x25, 12]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	beq	.L1026
.L1027:
	ldp	w2, w0, [x25, 8]
	mov	w1, w28
	add	x22, x22, 32
	bl	FtlGcUpdatePage
	b	.L1021
.L1026:
	cmn	w0, #1
	beq	.L1027
	str	w0, [x29, 116]
	adrp	x0, .LANCHOR110
	mov	w2, 0
	mov	w1, 1
	ldr	x0, [x0, #:lo12:.LANCHOR110]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR115
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	str	x0, [x29, 128]
	add	x0, x29, 112
	bl	FlashReadPages
	adrp	x0, .LANCHOR12
	ldr	x2, [x24, #:lo12:.LANCHOR103]
	ldr	x3, [x29, 120]
	ldrh	w1, [x0, #:lo12:.LANCHOR12]
	add	x2, x2, x22
	mov	x0, 0
	ubfiz	x1, x1, 9, 16
.L1028:
	cmp	x0, x1
	beq	.L1027
	ldr	x4, [x2, 8]
	ldr	w5, [x4, x0]
	add	x0, x0, 4
	add	x4, x3, x0
	ldr	w4, [x4, -4]
	cmp	w5, w4
	beq	.L1028
	ldrh	w1, [x19]
	adrp	x0, .LC31
	ldr	w2, [x29, 116]
	add	x0, x0, :lo12:.LC31
	bl	printf
	b	.L1022
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
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
	bhi	.L1051
	adrp	x0, .LANCHOR22
	adrp	x25, .LANCHOR12
	adrp	x26, .LANCHOR23
	mov	x24, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR22]
	add	x25, x25, :lo12:.LANCHOR12
	add	x26, x26, :lo12:.LANCHOR23
	mov	w23, 0
	lsr	w21, w28, w21
.L1045:
	cbnz	w20, .L1050
.L1043:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1050:
	ldrh	w1, [x25]
	adrp	x0, .LANCHOR123
	adrp	x27, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR123]
	udiv	w22, w28, w1
	ldr	w2, [x0, w21, uxtw 2]
	and	w0, w20, 65535
	msub	w22, w22, w1, w28
	sub	w19, w1, w22
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	cbz	w2, .L1047
	cmp	w19, w1
	beq	.L1047
	ldr	x0, [x27, #:lo12:.LANCHOR108]
	str	x0, [x29, 120]
	add	x0, x29, 144
	str	w2, [x29, 116]
	mov	w2, 1
	str	x0, [x29, 128]
	mov	w1, w2
	add	x0, x29, 112
	bl	FlashReadPages
.L1048:
	lsl	w4, w19, 9
	ldr	x0, [x27, #:lo12:.LANCHOR108]
	lsl	w22, w22, 7
	mov	w2, w4
	mov	x1, x24
	str	w4, [x29, 108]
	add	x0, x0, x22, sxtw 2
	bl	ftl_memcpy
	ldr	x2, [x27, #:lo12:.LANCHOR108]
	mov	w1, w21
	adrp	x0, .LANCHOR161
	add	x0, x0, :lo12:.LANCHOR161
	sub	w20, w20, w19
	add	w28, w28, w19
	add	w21, w21, 1
	bl	FtlMapWritePage
	cmn	w0, #1
	ldr	w4, [x29, 108]
	csinv	w23, w23, wzr, ne
	add	x24, x24, x4, sxtw
	b	.L1045
.L1047:
	ldrh	w2, [x26]
	mov	w1, 0
	ldr	x0, [x27, #:lo12:.LANCHOR108]
	bl	ftl_memset
	b	.L1048
.L1051:
	mov	w23, -1
	b	.L1043
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	adrp	x0, .LANCHOR135
	add	x2, x0, :lo12:.LANCHOR135
	ldr	w1, [x0, #:lo12:.LANCHOR135]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1056
	mov	w0, 72
	mov	w1, 1
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	adrp	x0, .LANCHOR162
	ldr	w0, [x0, #:lo12:.LANCHOR162]
	str	w0, [x2, 88]
	adrp	x0, .LANCHOR163
	ldr	w0, [x0, #:lo12:.LANCHOR163]
	str	w0, [x2, 92]
	adrp	x0, .LANCHOR84
	ldr	w0, [x0, #:lo12:.LANCHOR84]
	str	w0, [x2, 8]
	adrp	x0, .LANCHOR85
	ldr	w0, [x0, #:lo12:.LANCHOR85]
	str	w0, [x2, 12]
	adrp	x0, .LANCHOR89
	ldr	w0, [x0, #:lo12:.LANCHOR89]
	str	w0, [x2, 16]
	adrp	x0, .LANCHOR88
	ldr	w0, [x0, #:lo12:.LANCHOR88]
	str	w0, [x2, 20]
	adrp	x0, .LANCHOR91
	ldr	w0, [x0, #:lo12:.LANCHOR91]
	str	w0, [x2, 28]
	adrp	x0, .LANCHOR80
	ldr	w0, [x0, #:lo12:.LANCHOR80]
	str	w0, [x2, 32]
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	str	w0, [x2, 36]
	adrp	x0, .LANCHOR87
	ldr	w0, [x0, #:lo12:.LANCHOR87]
	str	w0, [x2, 40]
	adrp	x0, .LANCHOR92
	ldr	w0, [x0, #:lo12:.LANCHOR92]
	str	w0, [x2, 44]
	adrp	x0, .LANCHOR93
	ldr	w0, [x0, #:lo12:.LANCHOR93]
	str	w0, [x2, 48]
	mov	w0, 0
	b	FtlVendorPartWrite
.L1056:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x2, .LANCHOR164
	ldrh	w1, [x2, #:lo12:.LANCHOR164]
	cmp	w1, 31
	bhi	.L1062
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR164]
	mov	w1, 1
.L1059:
	adrp	x2, .LANCHOR118
	cbnz	w0, .L1060
	ldr	x0, [x2, #:lo12:.LANCHOR118]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1064
.L1060:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR118]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	mov	w0, 17221
	str	wzr, [x2, 4]
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	adrp	x0, .LANCHOR116
	ldrh	w1, [x0, #:lo12:.LANCHOR116]
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
.L1062:
	mov	w1, 32
	b	.L1059
.L1064:
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
	bhi	.L1076
	adrp	x0, .LANCHOR22
	mov	x25, x2
	mov	w24, 0
	adrp	x27, .LANCHOR123
	ldrh	w20, [x0, #:lo12:.LANCHOR22]
	adrp	x0, .LANCHOR12
	add	x0, x0, :lo12:.LANCHOR12
	str	x0, [x29, 104]
	lsr	w20, w22, w20
.L1069:
	cbnz	w21, .L1075
.L1067:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L1075:
	ldr	x0, [x27, #:lo12:.LANCHOR123]
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
	cbz	w4, .L1071
	adrp	x28, .LANCHOR108
	mov	w2, 1
	str	w4, [x29, 96]
	mov	w1, w2
	ldr	x0, [x28, #:lo12:.LANCHOR108]
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
	adrp	x0, .LANCHOR138
	csinv	w24, w24, wzr, ne
	ldr	w0, [x0, #:lo12:.LANCHOR138]
	cmp	w0, 256
	bne	.L1073
	mov	w2, w4
	mov	w1, w20
	adrp	x0, .LC32
	str	x28, [x29, 96]
	add	x0, x0, :lo12:.LC32
	bl	printf
	ldr	x2, [x28, #:lo12:.LANCHOR108]
	mov	w1, w20
	adrp	x0, .LANCHOR161
	add	x0, x0, :lo12:.LANCHOR161
	bl	FtlMapWritePage
	ldr	x5, [x29, 96]
.L1073:
	ldr	x1, [x5, #:lo12:.LANCHOR108]
	lsl	w23, w23, 7
	mov	w2, w26
	mov	x0, x25
	add	x1, x1, x23, sxtw 2
	bl	ftl_memcpy
.L1074:
	add	w20, w20, 1
	sub	w21, w21, w19
	add	w22, w22, w19
	add	x25, x25, x26, sxtw
	b	.L1069
.L1071:
	mov	w2, w26
	mov	w1, 0
	mov	x0, x25
	bl	ftl_memset
	b	.L1074
.L1076:
	mov	w24, -1
	b	.L1067
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
	adrp	x19, .LANCHOR118
	adrp	x20, .LANCHOR116
	ldr	x2, [x19, #:lo12:.LANCHOR118]
	ldrh	w1, [x20, #:lo12:.LANCHOR116]
	bl	FtlVendorPartRead
	ldr	x0, [x19, #:lo12:.LANCHOR118]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1079
	adrp	x1, .LC33
	adrp	x0, .LC34
	add	x1, x1, :lo12:.LC33
	add	x0, x0, :lo12:.LC34
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR118]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR116]
	lsl	w2, w2, 9
	bl	ftl_memset
.L1079:
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
	adrp	x19, .LANCHOR135
	str	x21, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR135
	mov	x2, x21
	bl	FtlVendorPartRead
	ldr	w0, [x19, #:lo12:.LANCHOR135]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1082
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR135]
.L1082:
	ldr	w1, [x19, #:lo12:.LANCHOR135]
	add	x0, x19, :lo12:.LANCHOR135
	cmp	w1, w20
	adrp	x1, .LANCHOR91
	bne	.L1083
	adrp	x2, .LANCHOR162
	ldr	w3, [x0, 88]
	str	w3, [x2, #:lo12:.LANCHOR162]
	adrp	x2, .LANCHOR163
	ldr	w3, [x0, 92]
	str	w3, [x2, #:lo12:.LANCHOR163]
	adrp	x2, .LANCHOR84
	ldr	w3, [x0, 8]
	str	w3, [x2, #:lo12:.LANCHOR84]
	adrp	x2, .LANCHOR85
	ldr	w3, [x0, 12]
	str	w3, [x2, #:lo12:.LANCHOR85]
	adrp	x2, .LANCHOR89
	ldr	w3, [x0, 16]
	str	w3, [x2, #:lo12:.LANCHOR89]
	adrp	x2, .LANCHOR88
	ldr	w3, [x0, 20]
	str	w3, [x2, #:lo12:.LANCHOR88]
	ldp	w2, w3, [x0, 28]
	str	w2, [x1, #:lo12:.LANCHOR91]
	adrp	x2, .LANCHOR80
	str	w3, [x2, #:lo12:.LANCHOR80]
	adrp	x2, .LANCHOR86
	ldr	w3, [x0, 36]
	str	w3, [x2, #:lo12:.LANCHOR86]
	adrp	x2, .LANCHOR87
	ldr	w3, [x0, 40]
	str	w3, [x2, #:lo12:.LANCHOR87]
	adrp	x2, .LANCHOR92
	ldr	w3, [x0, 44]
	str	w3, [x2, #:lo12:.LANCHOR92]
	ldr	w2, [x0, 48]
	adrp	x0, .LANCHOR93
	str	w2, [x0, #:lo12:.LANCHOR93]
.L1083:
	adrp	x0, .LANCHOR14
	adrp	x2, .LANCHOR90
	ldr	w1, [x1, #:lo12:.LANCHOR91]
	ldrh	w0, [x0, #:lo12:.LANCHOR14]
	ldr	w2, [x2, #:lo12:.LANCHOR90]
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR5
	ldp	x29, x30, [sp], 48
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR145
	str	w0, [x1, #:lo12:.LANCHOR145]
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
	.section	.text.FtlMapBlkWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDump_data
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
	ldr	w1, [x0, 56]
	cbz	w1, .L1086
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x0, 6]
	adrp	x0, .LANCHOR107
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR138
	add	x21, x23, :lo12:.LANCHOR138
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	mov	x22, x23
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR114
	ldr	x24, [x0, #:lo12:.LANCHOR114]
	ldrh	w0, [x19, 2]
	str	x25, [sp, 64]
	str	x24, [x21, 16]
	str	wzr, [x19, 56]
	ldr	x25, [x19, 40]
	cbz	w0, .L1088
	adrp	x1, .LANCHOR20
	ldrh	w1, [x1, #:lo12:.LANCHOR20]
	sub	w1, w1, #1
	cmp	w0, w1
	bge	.L1088
	ldrh	w1, [x19]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1088
	ldr	x2, [x19, 16]
	ubfiz	x1, x1, 1, 16
	sub	w0, w0, #1
	ldrh	w1, [x2, x1]
	mov	w2, 1
	orr	w0, w0, w1, lsl 10
	mov	w1, w2
	str	w0, [x21, 4]
	mov	x0, x21
	bl	FlashReadPages
	ldr	w0, [x23, #:lo12:.LANCHOR138]
	cmn	w0, #1
	beq	.L1088
	ldrh	w1, [x24, 8]
	ldr	x2, [x19, 40]
	ubfiz	x0, x1, 2, 16
	ldr	w2, [x2, x0]
	ldr	w0, [x21, 4]
	cmp	w2, w0
	bne	.L1088
	ldr	x2, [x21, 8]
.L1100:
	mov	x0, x19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	FtlMapWritePage
.L1088:
	sub	w20, w20, #1
	and	w20, w20, 65535
	ubfiz	x0, x20, 2, 16
	ldr	w1, [x25, x0]
	add	x0, x22, :lo12:.LANCHOR138
	str	w1, [x0, 4]
	cbz	w1, .L1089
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L1090:
	add	x22, x22, :lo12:.LANCHOR138
	mov	w1, w20
	ldr	x2, [x22, 8]
	b	.L1100
.L1089:
	adrp	x1, .LANCHOR23
	ldr	x0, [x0, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
	b	.L1090
.L1086:
	ret
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
	.section	.text.FtlVpcTblFlush,"ax",@progbits
	.align	2
	.global	FtlVpcTblFlush
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR139
	mov	w2, 19539
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR114
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR106
	stp	x27, x28, [sp, 80]
	adrp	x21, .LANCHOR138
	ldr	x27, [x25, #:lo12:.LANCHOR114]
	add	x28, x21, :lo12:.LANCHOR138
	stp	x19, x20, [sp, 16]
	movk	w2, 0x4654, lsl 16
	stp	x23, x24, [sp, 48]
	add	x24, x1, :lo12:.LANCHOR139
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	adrp	x23, .LANCHOR82
	ldrh	w1, [x1, #:lo12:.LANCHOR139]
	adrp	x26, .LANCHOR23
	stp	x0, x27, [x28, 8]
	mov	w20, 0
	strh	w1, [x27, 2]
	mov	w1, -3932
	strh	w1, [x27]
	ldr	w1, [x24, 8]
	stp	w1, wzr, [x27, 4]
	adrp	x1, .LANCHOR39
	add	x19, x1, :lo12:.LANCHOR39
	str	wzr, [x27, 12]
	str	w2, [x1, #:lo12:.LANCHOR39]
	mov	w1, 72
	movk	w1, 0x5000, lsl 16
	str	w1, [x19, 4]
	ldrh	w1, [x24, 6]
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
	adrp	x1, .LANCHOR90
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR90]
	str	w1, [x19, 32]
	ldr	w1, [x23, #:lo12:.LANCHOR82]
	str	w1, [x19, 40]
	ldrh	w2, [x26, #:lo12:.LANCHOR23]
	adrp	x1, .LANCHOR83
	ldr	w1, [x1, #:lo12:.LANCHOR83]
	str	w1, [x19, 36]
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
	ldrh	w0, [x19, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR1
	ldr	x3, [x28, 8]
	mov	x19, x28
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	mov	x28, x24
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	w2, w2, 4
	add	x0, x0, 48
	and	x0, x0, -4
	adrp	x24, .LANCHOR20
	add	x0, x3, x0
	bl	ftl_memcpy
	mov	w0, 0
	bl	FtlUpdateVaildLpn
	mov	w0, 65535
	add	x24, x24, :lo12:.LANCHOR20
	str	w0, [x29, 108]
	str	x24, [x29, 96]
.L1102:
	ldrh	w2, [x28, 2]
	ldrh	w1, [x28]
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	str	x0, [x19, 8]
	ldr	x0, [x25, #:lo12:.LANCHOR114]
	str	x0, [x19, 16]
	orr	w0, w2, w1, lsl 10
	str	w0, [x19, 4]
	ldrh	w0, [x24]
	sub	w0, w0, #1
	cmp	w2, w0
	blt	.L1103
	ldrh	w0, [x28, 4]
	strh	wzr, [x28, 2]
	strh	w1, [x28, 4]
	str	w0, [x29, 108]
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x28]
	ldr	w1, [x23, #:lo12:.LANCHOR82]
	str	w1, [x28, 8]
	add	w2, w1, 1
	str	w2, [x23, #:lo12:.LANCHOR82]
	ubfiz	w2, w0, 10, 16
	str	w2, [x19, 4]
	strh	w0, [x27, 2]
	str	w1, [x27, 4]
.L1103:
	ldrh	w1, [x26, #:lo12:.LANCHOR23]
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	bl	js_hash
	str	w0, [x27, 12]
	mov	w3, 1
	mov	x0, x19
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x28, 2]
	ldr	w1, [x19]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x28, 2]
	cmn	w1, #1
	bne	.L1104
	cmp	w0, 1
	bne	.L1105
	adrp	x1, .LANCHOR165
	adrp	x0, .LC1
	mov	w2, 1138
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1105:
	ldrh	w0, [x28, 2]
	cmp	w0, 1
	bne	.L1106
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x28, 2]
.L1106:
	add	w20, w20, 1
	and	w20, w20, 65535
	cmp	w20, 3
	bls	.L1102
	add	x21, x21, :lo12:.LANCHOR138
	adrp	x0, .LC35
	mov	w2, w20
	add	x0, x0, :lo12:.LC35
	ldr	w1, [x21, 4]
	bl	printf
.L1108:
	b	.L1108
.L1104:
	cmp	w0, 1
	beq	.L1102
	cmp	w1, 256
	beq	.L1102
	ldr	w1, [x29, 108]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L1109
	ldrh	w0, [x29, 108]
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L1109:
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
	adrp	x0, .LANCHOR166
	ldr	w0, [x0, #:lo12:.LANCHOR166]
	cmp	w0, 1
	bne	.L1122
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1122:
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
	bhi	.L1133
	cmp	w19, 31
	bhi	.L1127
.L1141:
	mov	w0, 0
.L1125:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1127:
	adrp	x21, .LANCHOR12
	ldrh	w1, [x21, #:lo12:.LANCHOR12]
	udiv	w20, w0, w1
	msub	w0, w1, w20, w0
	ands	w0, w0, 65535
	beq	.L1128
	sub	w1, w1, w0
	add	w20, w20, 1
	cmp	w1, w19
	csel	w1, w1, w19, ls
	sub	w19, w19, w1, uxth
.L1128:
	adrp	x22, .LANCHOR167
	adrp	x23, .LANCHOR86
	add	x22, x22, :lo12:.LANCHOR167
	add	x23, x23, :lo12:.LANCHOR86
	mov	w0, -1
	str	w0, [x29, 76]
.L1129:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	cmp	w19, w0
	bcs	.L1131
	adrp	x0, .LANCHOR167
	ldr	w1, [x0, #:lo12:.LANCHOR167]
	cmp	w1, 32
	bls	.L1141
	str	wzr, [x0, #:lo12:.LANCHOR167]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1141
.L1131:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w20
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1130
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
.L1130:
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L1129
.L1133:
	mov	w0, -1
	b	.L1125
	.size	FtlDiscard, .-FtlDiscard
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
	bcs	.L1143
	adrp	x1, .LANCHOR168
	adrp	x0, .LC1
	mov	w2, 2760
	add	x1, x1, :lo12:.LANCHOR168
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1143:
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1144
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1145
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L1144:
	adrp	x1, .LANCHOR131
	mov	w0, 1
	strb	w0, [x21, 8]
	mov	w2, 65535
	ldrh	w0, [x1, #:lo12:.LANCHOR131]
	mov	x20, x1
	cmp	w0, w2
	beq	.L1146
	cmp	w19, w0
	bne	.L1147
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1148
.L1147:
	bl	update_vpc_list
.L1148:
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR131]
.L1146:
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
.L1145:
	mov	w0, w19
	bl	INSERT_FREE_LIST
	b	.L1144
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
	adrp	x23, .LANCHOR135
	add	x21, x0, x21
	add	x24, x24, :lo12:.LANCHOR19
	add	x23, x23, :lo12:.LANCHOR135
	bl	FlashProgPages
.L1154:
	cmp	x20, x21
	beq	.L1161
	sub	x22, x20, #4
	adrp	x25, .LANCHOR42
	b	.L1162
.L1157:
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x19]
	cmp	w1, w0, uxth
	bne	.L1155
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
.L1155:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1156
	mov	x0, x19
	bl	allocate_new_data_superblock
.L1156:
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
.L1162:
	ldr	w0, [x20, -4]
	cmn	w0, #1
	beq	.L1157
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1158
	adrp	x1, .LANCHOR169
	adrp	x0, .LC1
	mov	w2, 960
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1158:
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
	beq	.L1159
	adrp	x2, .LANCHOR42
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1160
	adrp	x0, .LC36
	mov	w2, 0
	add	x0, x0, :lo12:.LC36
	bl	printf
.L1160:
	mov	w0, w22
	bl	decrement_vpc_count
.L1159:
	add	x20, x20, 32
	b	.L1154
.L1161:
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1153
	adrp	x1, .LANCHOR169
	adrp	x0, .LC1
	mov	w2, 975
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1153:
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
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR133
	ldrh	w20, [x19, #:lo12:.LANCHOR53]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w20, w1
	str	x27, [sp, 80]
	beq	.L1169
	adrp	x1, .LANCHOR19
	add	x0, x19, :lo12:.LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L1169
	adrp	x0, .LANCHOR43
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L1170
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L1170:
	ldr	w0, [x21, #:lo12:.LANCHOR133]
	cbnz	w0, .L1171
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1171:
	str	wzr, [x21, #:lo12:.LANCHOR133]
	mov	w0, 1
.L1168:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1169:
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65535
	str	wzr, [x21, #:lo12:.LANCHOR133]
	add	x0, x19, :lo12:.LANCHOR53
	cmp	w2, w1
	bne	.L1173
.L1188:
	mov	w0, 0
	b	.L1168
.L1173:
	ldrb	w1, [x0, 7]
	adrp	x0, .LANCHOR19
	adrp	x20, .LANCHOR70
	mov	x21, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR19]
	ldrh	w2, [x20, #:lo12:.LANCHOR70]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L1174
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 162
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1174:
	add	x0, x19, :lo12:.LANCHOR53
	adrp	x23, .LANCHOR42
	ldrh	w3, [x21, #:lo12:.LANCHOR19]
	adrp	x25, .LANCHOR152
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	adrp	x26, .LANCHOR170
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR152
	ldr	x1, [x23, #:lo12:.LANCHOR42]
	add	x26, x26, :lo12:.LANCHOR170
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR84
	ldrh	w0, [x20, #:lo12:.LANCHOR70]
	ldr	w2, [x1, #:lo12:.LANCHOR84]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR84]
.L1175:
	ldrh	w0, [x20, #:lo12:.LANCHOR70]
	cmp	w0, w21
	bhi	.L1179
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L1180
	bl	INSERT_DATA_LIST
.L1181:
	adrp	x0, .LANCHOR68
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR70]
	strh	w21, [x19, #:lo12:.LANCHOR53]
	strh	wzr, [x0, #:lo12:.LANCHOR68]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR144
	strh	w21, [x0, #:lo12:.LANCHOR144]
	adrp	x0, .LANCHOR48
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR171
	ldrh	w0, [x0, #:lo12:.LANCHOR171]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L1188
	adrp	x0, .LANCHOR100
	mov	w1, 20
	strh	w1, [x0, #:lo12:.LANCHOR100]
	b	.L1188
.L1179:
	adrp	x0, .LANCHOR71
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR71]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L1176
	adrp	x0, .LC1
	mov	w2, 168
	mov	x1, x26
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1176:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L1177
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L1187:
	bl	decrement_vpc_count
.L1178:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L1175
.L1177:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L1178
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	b	.L1187
.L1180:
	bl	INSERT_FREE_LIST
	b	.L1181
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
	bcc	.L1189
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	FtlMapBlkWriteDump_data
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR133
	str	wzr, [x0, #:lo12:.LANCHOR133]
.L1189:
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
	adrp	x0, .LANCHOR157
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR51
	add	x19, x19, :lo12:.LANCHOR51
	str	wzr, [x0, #:lo12:.LANCHOR157]
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
	adrp	x19, .LANCHOR62
	adrp	x20, .LANCHOR104
	ldr	w1, [x19, #:lo12:.LANCHOR62]
	add	x19, x19, :lo12:.LANCHOR62
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	bl	FlashProgPages
	mov	w11, 0
.L1195:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L1198
	ldr	x0, [x20, #:lo12:.LANCHOR104]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR53+4
	ldrh	w0, [x0, #:lo12:.LANCHOR53+4]
	cbnz	w0, .L1199
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L1201
.L1198:
	ldr	x2, [x20, #:lo12:.LANCHOR104]
	ubfiz	x0, x11, 5, 16
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1196
	adrp	x0, .LANCHOR53
	adrp	x3, .LANCHOR42
	ldrh	w4, [x0, #:lo12:.LANCHOR53]
	ldr	x3, [x3, #:lo12:.LANCHOR42]
	strh	wzr, [x3, x4, lsl 1]
	strh	w2, [x0, #:lo12:.LANCHOR53]
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L1201:
	mov	w0, 1
.L1194:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1196:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L1195
.L1199:
	mov	w0, 0
	b	.L1194
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
	beq	.L1203
	add	x1, x0, :lo12:.LANCHOR53
	ldrh	w0, [x1, 4]
	cbnz	w0, .L1204
.L1203:
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	add	x0, x19, :lo12:.LANCHOR53
	strb	wzr, [x0, 8]
	bl	allocate_data_superblock
	adrp	x0, .LANCHOR68
	strh	wzr, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR70
	strh	wzr, [x0, #:lo12:.LANCHOR70]
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1204:
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
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR94
	stp	x19, x20, [sp, 16]
	ldr	w1, [x21, #:lo12:.LANCHOR94]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L1258
	adrp	x1, .LANCHOR45
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	cmp	w1, 47
	bls	.L1258
	adrp	x1, .LANCHOR73
	mov	w4, 65535
	ldrh	w3, [x1, #:lo12:.LANCHOR73]
	cmp	w3, w4
	beq	.L1208
	adrp	x2, .LANCHOR72
	ldrh	w5, [x2, #:lo12:.LANCHOR72]
	cmp	w5, w4
	bne	.L1208
	strh	w3, [x2, #:lo12:.LANCHOR72]
	mov	w2, -1
	strh	w2, [x1, #:lo12:.LANCHOR73]
.L1208:
	cbnz	w0, .L1259
	adrp	x1, .LANCHOR48
	ldrh	w1, [x1, #:lo12:.LANCHOR48]
	cmp	w1, 24
	bhi	.L1260
	adrp	x2, .LANCHOR19
	cmp	w1, 16
	ldrh	w20, [x2, #:lo12:.LANCHOR19]
	bls	.L1211
	lsr	w20, w20, 5
.L1210:
	adrp	x2, .LANCHOR100
	ldrh	w3, [x2, #:lo12:.LANCHOR100]
	cmp	w3, w1
	mov	x3, x2
	bcs	.L1214
	adrp	x1, .LANCHOR53
	mov	w4, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w4
	bne	.L1215
	adrp	x4, .LANCHOR72
	ldrh	w4, [x4, #:lo12:.LANCHOR72]
	cmp	w4, w1
	bne	.L1215
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	cbnz	w0, .L1216
	adrp	x1, .LANCHOR152
	adrp	x4, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR152]
	ldr	w4, [x4, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L1217
.L1216:
	adrp	x1, .LANCHOR171
	ldrh	w1, [x1, #:lo12:.LANCHOR171]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR100]
.L1218:
	adrp	x1, .LANCHOR95
	str	wzr, [x1, #:lo12:.LANCHOR95]
.L1206:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1211:
	cmp	w1, 12
	bls	.L1212
	lsr	w20, w20, 4
	b	.L1210
.L1212:
	cmp	w1, 8
	bls	.L1210
	lsr	w20, w20, 2
	b	.L1210
.L1260:
	mov	w20, 1
	b	.L1210
.L1217:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR100]
	b	.L1218
.L1215:
	adrp	x1, .LANCHOR171
	ldrh	w1, [x1, #:lo12:.LANCHOR171]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR100]
.L1214:
	adrp	x1, .LANCHOR74
	ldrh	w1, [x1, #:lo12:.LANCHOR74]
	cbz	w1, .L1209
	add	w20, w20, 32
	and	w20, w20, 65535
.L1209:
	adrp	x19, .LANCHOR144
	str	w0, [x29, 152]
	mov	w0, 65535
	ldrh	w2, [x19, #:lo12:.LANCHOR144]
	cmp	w2, w0
	bne	.L1221
	adrp	x0, .LANCHOR72
	ldrh	w1, [x0, #:lo12:.LANCHOR72]
	cmp	w1, w2
	beq	.L1222
	adrp	x2, .LANCHOR42
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L1223
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR72]
.L1223:
	ldrh	w1, [x0, #:lo12:.LANCHOR72]
	strh	w1, [x19, #:lo12:.LANCHOR144]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR72]
.L1222:
	add	x0, x19, :lo12:.LANCHOR144
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR144]
	cmp	w0, w1
	beq	.L1221
	bl	IsBlkInGcList
	cbz	w0, .L1225
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR144]
.L1225:
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR144
	cmp	w1, w0
	beq	.L1221
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR173
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR42
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	strh	w1, [x0, #:lo12:.LANCHOR174]
.L1221:
	adrp	x1, .LANCHOR51
	ldrh	w0, [x19, #:lo12:.LANCHOR144]
	str	x1, [x29, 128]
	ldrh	w2, [x1, #:lo12:.LANCHOR51]
	cmp	w2, w0
	beq	.L1226
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1227
.L1226:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR144]
.L1227:
	adrp	x25, .LANCHOR102
	add	x26, x25, :lo12:.LANCHOR102
.L1256:
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1228
	adrp	x0, .LANCHOR95
	adrp	x22, .LANCHOR19
	add	x22, x22, :lo12:.LANCHOR19
	str	wzr, [x0, #:lo12:.LANCHOR95]
.L1229:
	ldrh	w5, [x25, #:lo12:.LANCHOR102]
	add	x7, x25, :lo12:.LANCHOR102
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR144]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1230
	strh	wzr, [x7]
	mov	w0, 8
	b	.L1206
.L1259:
	mov	w20, 1
	b	.L1209
.L1230:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L1231
	strh	w5, [x25, #:lo12:.LANCHOR102]
	b	.L1229
.L1231:
	adrp	x23, .LANCHOR42
	adrp	x4, .LANCHOR3
	ldrh	w0, [x22]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR3]
	strh	w5, [x25, #:lo12:.LANCHOR102]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L1233
	cmp	w5, 48
	bls	.L1234
	cmp	w3, 8
	bls	.L1234
	adrp	x3, .LANCHOR68
	ldrh	w3, [x3, #:lo12:.LANCHOR68]
	cmp	w3, 35
	bhi	.L1234
.L1233:
	strh	wzr, [x26]
.L1234:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L1235
	ldrh	w0, [x26]
	cmp	w0, 3
	bhi	.L1235
	mov	w0, -1
	strh	wzr, [x26]
	strh	w0, [x19, #:lo12:.LANCHOR144]
.L1286:
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	b	.L1206
.L1235:
	cbnz	w1, .L1236
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x26]
	add	w0, w0, 1
	strh	w0, [x26]
	b	.L1229
.L1236:
	add	x0, x19, :lo12:.LANCHOR144
	strb	wzr, [x0, 8]
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w6
	bne	.L1237
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 700
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1237:
	adrp	x0, .LANCHOR52
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1238
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 701
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1238:
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1239
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 702
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1239:
	add	x22, x19, :lo12:.LANCHOR144
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR173
	ldrh	w1, [x19, #:lo12:.LANCHOR144]
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR174]
	strb	wzr, [x22, 6]
.L1228:
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR19
	str	x0, [x29, 120]
	ldrh	w1, [x0, #:lo12:.LANCHOR19]
	ldr	w0, [x29, 152]
	str	w1, [x29, 156]
	cbz	w0, .L1240
	adrp	x0, .LANCHOR3
	ldrh	w2, [x19, #:lo12:.LANCHOR144]
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
.L1240:
	add	x0, x19, :lo12:.LANCHOR144
	ldr	w2, [x29, 156]
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w2
	ble	.L1241
	sub	w20, w2, w0
	and	w20, w20, 65535
.L1241:
	adrp	x0, .LANCHOR173
	mov	w28, 0
	add	x0, x0, :lo12:.LANCHOR173
	str	x0, [x29, 144]
.L1242:
	cmp	w20, w28, uxth
	bls	.L1250
	add	x1, x19, :lo12:.LANCHOR144
	adrp	x0, .LANCHOR3
	adrp	x23, .LANCHOR66
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR3]
	mov	w22, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x23, #:lo12:.LANCHOR66]
	mov	w6, 65535
	add	w4, w4, w28
	b	.L1251
.L1244:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L1243
	ubfiz	x5, x22, 5, 16
	add	w22, w22, 1
	add	x5, x0, x5
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x5, 4]
.L1243:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L1251:
	cmp	w2, w7
	bne	.L1244
	add	x1, x19, :lo12:.LANCHOR144
	adrp	x24, .LANCHOR62
	add	x24, x24, :lo12:.LANCHOR62
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
	str	x0, [x29, 136]
.L1245:
	ldr	x0, [x29, 136]
	cmp	x22, x0
	bne	.L1249
	add	w28, w28, 1
	b	.L1242
.L1249:
	ldr	x0, [x23, #:lo12:.LANCHOR66]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L1246
	ldr	x27, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x27]
	cmp	w1, w0
	bne	.L1246
	ldr	w4, [x27, 8]
	cmn	w4, #1
	bne	.L1247
	str	w4, [x29, 112]
	mov	w2, 736
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
	ldr	w4, [x29, 112]
.L1247:
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x23, #:lo12:.LANCHOR66]
	ldr	w1, [x29, 172]
	add	x0, x0, x22
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bne	.L1246
	ldr	x1, [x29, 144]
	adrp	x4, .LANCHOR104
	ldr	x2, [x29, 144]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	x2, [x4, #:lo12:.LANCHOR104]
	ldr	w1, [x24]
	add	x1, x2, x1, lsl 5
	stp	x4, x1, [x29, 104]
	str	w0, [x1, 24]
	bl	Ftl_get_new_temp_ppa
	ldp	x4, x1, [x29, 104]
	ldr	x2, [x4, #:lo12:.LANCHOR104]
	str	w0, [x1, 4]
	ldr	w1, [x24]
	ubfiz	x0, x1, 5, 32
	add	w1, w1, 1
	add	x2, x2, x0
	ldr	x0, [x23, #:lo12:.LANCHOR66]
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
	adrp	x2, .LANCHOR83
	str	w1, [x24]
	mov	w1, 1
	ldr	w2, [x2, #:lo12:.LANCHOR83]
	str	w2, [x27, 4]
	bl	FtlGcBufAlloc
	ldrb	w1, [x11, 7]
	ldr	w0, [x24]
	cmp	w1, w0
	beq	.L1248
	ldrh	w0, [x11, 4]
	cbnz	w0, .L1246
.L1248:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L1246
.L1287:
	str	wzr, [x21, #:lo12:.LANCHOR94]
	b	.L1286
.L1246:
	add	x22, x22, 32
	b	.L1245
.L1250:
	add	x1, x19, :lo12:.LANCHOR144
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	ldr	w0, [x29, 156]
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w0, w20
	bhi	.L1252
	adrp	x0, .LANCHOR62
	ldr	w0, [x0, #:lo12:.LANCHOR62]
	cbz	w0, .L1253
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L1287
.L1253:
	adrp	x0, .LANCHOR173
	ldrh	w0, [x0, #:lo12:.LANCHOR173]
	cbnz	w0, .L1254
	ldrh	w0, [x19, #:lo12:.LANCHOR144]
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L1254
	strh	wzr, [x1, x0]
	ldrh	w0, [x19, #:lo12:.LANCHOR144]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1254:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR144]
.L1252:
	adrp	x0, .LANCHOR48
	str	wzr, [x21, #:lo12:.LANCHOR94]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1255
	ldr	x0, [x29, 120]
	ldrh	w20, [x0, #:lo12:.LANCHOR19]
	b	.L1256
.L1255:
	add	w0, w0, 1
	b	.L1206
.L1258:
	mov	w0, 0
	b	.L1206
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
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
	bne	.L1289
	mov	x2, x3
	mov	w1, w26
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L1288:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1289:
	add	w0, w1, w2
	str	w0, [x29, 136]
	adrp	x0, .LANCHOR34
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1310
	adrp	x0, .LANCHOR166
	ldr	w21, [x0, #:lo12:.LANCHOR166]
	cmn	w21, #1
	beq	.L1288
	adrp	x22, .LANCHOR12
	adrp	x25, .LANCHOR135
	add	x25, x25, :lo12:.LANCHOR135
	mov	w27, 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	mov	w21, 0
	adrp	x28, .LANCHOR103
	stp	wzr, wzr, [x29, 140]
	udiv	w1, w19, w0
	stp	wzr, w1, [x29, 148]
	add	w1, w19, w2
	sub	w24, w1, #1
	adrp	x1, .LANCHOR163
	ldr	w20, [x29, 152]
	udiv	w24, w24, w0
	ldr	w0, [x29, 152]
	sub	w0, w24, w0
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x1, #:lo12:.LANCHOR163]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR163]
	adrp	x1, .LANCHOR89
	ldr	w2, [x29, 156]
	ldr	w0, [x1, #:lo12:.LANCHOR89]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR89]
.L1291:
	ldr	w0, [x29, 156]
	cbnz	w0, .L1308
	adrp	x0, .LANCHOR74
	ldrh	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L1309
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 31
	bhi	.L1288
.L1309:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L1288
.L1308:
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1292
	add	x5, x22, :lo12:.LANCHOR12
	mov	w4, 0
.L1293:
	ldrh	w0, [x5]
	cmp	w4, w0
	bcc	.L1295
.L1296:
	ldr	w0, [x29, 156]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 156]
	beq	.L1300
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w27, w0, lsl 2
	bne	.L1291
.L1300:
	cbz	w27, .L1291
	ldr	x0, [x28, #:lo12:.LANCHOR103]
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
.L1307:
	ldr	x0, [x28, #:lo12:.LANCHOR103]
	ldr	w2, [x29, 152]
	add	x0, x0, x27
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L1302
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR109
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	cmp	x1, x0
	bne	.L1303
	ldr	x0, [x29, 128]
	ldr	w2, [x29, 120]
	add	x1, x1, x0
	mov	x0, x23
.L1321:
	bl	ftl_memcpy
.L1303:
	ldr	x0, [x28, #:lo12:.LANCHOR103]
	add	x0, x0, x27
	ldr	x1, [x0, 16]
	ldr	w2, [x0, 24]
	ldr	w1, [x1, 8]
	cmp	w2, w1
	beq	.L1304
	ldr	w1, [x25, 72]
	add	w1, w1, 1
	str	w1, [x25, 72]
.L1304:
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L1305
	ldr	w0, [x25, 72]
	mov	w21, w1
	add	w0, w0, 1
	str	w0, [x25, 72]
.L1306:
	ldr	x0, [x29, 104]
	add	x27, x27, 32
	cmp	x0, x27
	bne	.L1307
	mov	w27, 0
	b	.L1291
.L1295:
	madd	w0, w20, w0, w4
	cmp	w19, w0
	bhi	.L1294
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L1294
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
.L1294:
	add	w4, w4, 1
	b	.L1293
.L1292:
	ldr	x2, [x28, #:lo12:.LANCHOR103]
	ubfiz	x0, x27, 5, 32
	add	x0, x2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 152]
	cmp	w20, w1
	bne	.L1297
	adrp	x1, .LANCHOR109
	ldr	x1, [x1, #:lo12:.LANCHOR109]
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
	bne	.L1298
	str	x23, [x0, 8]
.L1298:
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR115
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR24]
	ldr	x2, [x2, #:lo12:.LANCHOR115]
	mul	w1, w1, w27
	add	w27, w27, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L1296
.L1297:
	cmp	w20, w24
	bne	.L1299
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	adrp	x1, .LANCHOR110
	ldr	w3, [x29, 136]
	ldr	x1, [x1, #:lo12:.LANCHOR110]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 140]
	cmp	w2, w3
	bne	.L1298
.L1320:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L1298
.L1299:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	mul	w1, w1, w20
	b	.L1320
.L1302:
	cmp	w24, w1
	bne	.L1303
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR110
	ldr	x0, [x0, #:lo12:.LANCHOR110]
	cmp	x1, x0
	bne	.L1303
	ldr	x0, [x29, 96]
	ldr	w2, [x29, 116]
	ldrh	w0, [x0]
	mul	w0, w0, w24
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L1321
.L1305:
	cmp	w1, 256
	bne	.L1306
	ldr	w0, [x0, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1306
.L1310:
	mov	w21, -1
	b	.L1288
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
	stp	x29, x30, [sp, -224]!
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
	str	w2, [x29, 164]
	bne	.L1324
	add	w0, w1, 256
	ldr	w1, [x29, 164]
	mov	x2, x3
	bl	FtlVendorPartWrite
.L1323:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 224
	ret
.L1324:
	ldr	w0, [x29, 164]
	add	w0, w1, w0
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR34
	ldr	w1, [x29, 152]
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1356
	adrp	x0, .LANCHOR166
	ldr	w0, [x0, #:lo12:.LANCHOR166]
	cmn	w0, #1
	beq	.L1323
	adrp	x0, .LANCHOR176
	mov	w1, 2048
	adrp	x22, .LANCHOR12
	ldr	w2, [x29, 164]
	str	w1, [x0, #:lo12:.LANCHOR176]
	ldr	w1, [x29, 152]
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	sub	w1, w1, #1
	udiv	w25, w21, w0
	udiv	w0, w1, w0
	adrp	x1, .LANCHOR162
	mov	w19, w25
	str	w0, [x29, 144]
	sub	w0, w0, w25
	add	w24, w0, 1
	str	w0, [x29, 140]
	ldr	w0, [x1, #:lo12:.LANCHOR162]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR162]
	adrp	x1, .LANCHOR85
	ldr	w0, [x1, #:lo12:.LANCHOR85]
	add	w0, w0, w24
	str	w0, [x1, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR51
	add	x20, x0, :lo12:.LANCHOR51
.L1326:
	cbnz	w24, .L1351
	ldr	w1, [x29, 140]
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR48
	mov	x22, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	cmp	w1, 5
	bls	.L1352
.L1354:
	mov	w0, 0
	b	.L1323
.L1351:
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	adrp	x1, .LANCHOR3
	str	x1, [x29, 112]
	ldrb	w2, [x0, 6]
	ldrh	w0, [x1, #:lo12:.LANCHOR3]
	cmp	w2, w0
	bcc	.L1327
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 1016
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1327:
	ldrh	w0, [x20, 4]
	cbnz	w0, .L1328
	mov	x0, x20
	bl	allocate_new_data_superblock
.L1328:
	ldrb	w0, [x20, 7]
	ldrh	w1, [x20, 4]
	lsl	w0, w0, 2
	cmp	w0, w1
	csel	w0, w0, w1, ls
	ldrb	w1, [x20, 6]
	cmp	w0, w24
	csel	w0, w0, w24, ls
	str	w0, [x29, 148]
	ldr	x0, [x29, 112]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1329
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 1049
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1329:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	str	xzr, [x29, 168]
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	str	x0, [x29, 96]
.L1330:
	ldr	w1, [x29, 148]
	adrp	x27, .LANCHOR105
	ldr	w23, [x29, 168]
	cmp	w23, w1
	bcc	.L1349
	mov	x23, x1
.L1331:
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	mov	x3, x20
	mov	w2, 0
	mov	w1, w23
	bl	FtlProgPages
	cmp	w24, w23
	bcs	.L1350
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 1126
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1350:
	sub	w24, w24, w23
	b	.L1326
.L1349:
	ldrh	w0, [x20, 4]
	cbz	w0, .L1331
	add	x1, x29, 188
	mov	w2, 0
	mov	w0, w19
	bl	log2phys
	mov	x0, x20
	bl	get_new_active_ppa
	ldr	x1, [x29, 168]
	lsl	x28, x1, 5
	ldr	x1, [x27, #:lo12:.LANCHOR105]
	add	x1, x1, x28
	str	w0, [x1, 4]
	ldr	x0, [x29, 104]
	str	w19, [x1, 24]
	ldrh	w2, [x0]
	mul	w23, w23, w2
	and	x0, x23, 4294967292
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR115
	ldr	x3, [x29, 128]
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	str	x0, [x29, 120]
	add	x23, x0, x3
	str	x23, [x1, 16]
	mov	x0, x23
	mov	w1, 0
	bl	ftl_memset
	ldr	w0, [x29, 144]
	cmp	w19, w25
	ccmp	w19, w0, 4, ne
	bne	.L1332
	cmp	w19, w25
	bne	.L1333
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 156]
	sub	w2, w2, w0
	ldr	w0, [x29, 164]
	cmp	w2, w0
	csel	w0, w2, w0, ls
	str	w0, [x29, 160]
.L1334:
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	ldr	w1, [x29, 160]
	cmp	w1, w0
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	bne	.L1335
	add	x3, x0, x28
	cmp	w19, w25
	bne	.L1336
	str	x26, [x3, 8]
.L1337:
	ldr	x0, [x29, 112]
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1346
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 1117
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1346:
	ldp	x1, x2, [x29, 120]
	mov	w0, -3947
	strh	w0, [x1, x2]
	adrp	x1, .LANCHOR83
	ldr	w0, [x1, #:lo12:.LANCHOR83]
	stp	w0, w19, [x23, 4]
	add	w19, w19, 1
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR83]
	ldr	w0, [x29, 188]
	str	w0, [x23, 12]
	ldrh	w0, [x20]
	strh	w0, [x23, 2]
	ldr	x0, [x29, 168]
	add	x0, x0, 1
	str	x0, [x29, 168]
	b	.L1330
.L1333:
	ldr	w0, [x29, 152]
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	msub	w2, w19, w2, w0
	and	w0, w2, 65535
	stp	wzr, w0, [x29, 156]
	b	.L1334
.L1336:
	ldr	w0, [x29, 160]
.L1364:
	mul	w0, w0, w19
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x26, x0
	str	x0, [x3, 8]
	b	.L1337
.L1335:
	add	x0, x0, x28
	cmp	w19, w25
	bne	.L1338
	adrp	x1, .LANCHOR109
	ldr	x1, [x1, #:lo12:.LANCHOR109]
.L1363:
	str	x1, [x0, 8]
	ldr	w0, [x29, 188]
	cmn	w0, #1
	beq	.L1340
	str	w0, [x29, 196]
	mov	w2, 0
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	str	w19, [x29, 216]
	add	x0, x0, x28
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 200]
	mov	w1, 1
	add	x0, x29, 192
	bl	FlashReadPages
	ldr	w0, [x29, 192]
	cmn	w0, #1
	bne	.L1341
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L1344:
	ldr	w0, [x29, 160]
	cmp	w19, w25
	lsl	w2, w0, 9
	bne	.L1345
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	mov	x1, x26
	add	x3, x0, x28
	ldr	w0, [x29, 156]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L1365:
	bl	ftl_memcpy
	b	.L1337
.L1338:
	adrp	x1, .LANCHOR110
	ldr	x1, [x1, #:lo12:.LANCHOR110]
	b	.L1363
.L1341:
	ldr	w1, [x23, 8]
	cmp	w19, w1
	beq	.L1343
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC37
	mov	w2, w19
	add	x0, x0, :lo12:.LC37
	bl	printf
.L1343:
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L1344
	mov	w2, 1102
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
	b	.L1344
.L1340:
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	ldr	x1, [x29, 96]
	add	x0, x0, x28
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L1344
.L1345:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	add	x3, x0, x28
	mul	w1, w1, w19
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x26, x1
	b	.L1365
.L1332:
	ldr	x0, [x27, #:lo12:.LANCHOR105]
	add	x3, x0, x28
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	b	.L1364
.L1352:
	adrp	x23, .LANCHOR72
	adrp	x20, .LANCHOR101
	adrp	x21, .LANCHOR100
	add	x23, x23, :lo12:.LANCHOR72
	add	x20, x20, :lo12:.LANCHOR101
	add	x21, x21, :lo12:.LANCHOR100
	mov	w19, 256
.L1355:
	adrp	x0, .LANCHOR144
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR144]
	cmp	w0, w1
	bne	.L1353
	ldrh	w1, [x23]
	cmp	w1, w0
	bne	.L1353
	mov	w0, 0
	bl	List_get_gc_head_node
	bl	FtlGcRefreshBlock
.L1353:
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
	bhi	.L1354
	subs	w19, w19, #1
	bne	.L1355
	b	.L1354
.L1356:
	mov	w0, -1
	b	.L1323
	.size	FtlWrite, .-FtlWrite
	.section	.text.sftl_gc,"ax",@progbits
	.align	2
	.global	sftl_gc
	.type	sftl_gc, %function
sftl_gc:
	mov	w1, 1
	mov	w0, w1
	b	rk_ftl_garbage_collect
	.size	sftl_gc, .-sftl_gc
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR138
	stp	x21, x22, [sp, 32]
	add	x0, x19, :lo12:.LANCHOR138
	adrp	x22, .LANCHOR106
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR114
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	adrp	x23, .LANCHOR42
	ldr	x1, [x22, #:lo12:.LANCHOR106]
	adrp	x21, .LANCHOR5
	str	x1, [x0, 8]
	adrp	x20, .LANCHOR139
	ldr	x1, [x25, #:lo12:.LANCHOR114]
	str	x1, [x0, 16]
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	mov	w1, 0
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x20, #:lo12:.LANCHOR139]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1368
.L1379:
	mov	w0, -1
.L1367:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1368:
	add	x24, x20, :lo12:.LANCHOR139
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	sxth	w28, w0
	add	w0, w0, 1
	adrp	x26, .LANCHOR23
	strh	w0, [x24, 2]
	adrp	x27, .LANCHOR178
	ldrsh	w24, [x20, #:lo12:.LANCHOR139]
	add	x26, x26, :lo12:.LANCHOR23
	add	x27, x27, :lo12:.LANCHOR178
.L1370:
	tbz	w28, #31, .L1376
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1465
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1375:
	adrp	x1, .LANCHOR23
	ldrh	w0, [x21, #:lo12:.LANCHOR5]
	ldrh	w1, [x1, #:lo12:.LANCHOR23]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L1378
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1467
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1378:
	add	x24, x19, :lo12:.LANCHOR138
	adrp	x19, .LANCHOR39
	add	x22, x19, :lo12:.LANCHOR39
	mov	w2, 48
	mov	x0, x22
	ldr	x1, [x24, 8]
	bl	ftl_memcpy
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	ldr	x1, [x24, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
	ldrh	w1, [x21, #:lo12:.LANCHOR5]
	ldr	x0, [x24, 8]
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
	bne	.L1379
	add	x20, x20, :lo12:.LANCHOR139
	adrp	x0, .LANCHOR10
	ldrh	w1, [x22, 8]
	ldrb	w2, [x22, 10]
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	strh	w1, [x20, 6]
	cmp	w2, w0
	bne	.L1379
	adrp	x0, .LANCHOR179
	adrp	x2, .LANCHOR152
	adrp	x3, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LANCHOR19
	ldrh	w3, [x3, #:lo12:.LANCHOR3]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR152]
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
	adrp	x3, .LANCHOR171
	strh	w0, [x3, #:lo12:.LANCHOR171]
	bls	.L1380
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1489
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1380:
	add	x4, x19, :lo12:.LANCHOR39
	adrp	x0, .LANCHOR51
	add	x2, x0, :lo12:.LANCHOR51
	adrp	x5, .LANCHOR144
	adrp	x20, .LANCHOR52
	mov	x22, x5
	ldrh	w1, [x4, 16]
	ldrh	w6, [x4, 14]
	strh	w6, [x0, #:lo12:.LANCHOR51]
	lsr	w3, w1, 6
	and	w1, w1, 63
	strb	w1, [x2, 6]
	ldrb	w1, [x4, 11]
	strb	w1, [x2, 8]
	add	x1, x5, :lo12:.LANCHOR144
	strh	w3, [x2, 2]
	mov	w2, -1
	strh	w2, [x5, #:lo12:.LANCHOR144]
	add	x2, x20, :lo12:.LANCHOR52
	strh	wzr, [x1, 2]
	strb	wzr, [x1, 6]
	strb	wzr, [x1, 8]
	ldrh	w1, [x4, 18]
	strh	w1, [x20, #:lo12:.LANCHOR52]
	ldrh	w1, [x4, 20]
	lsr	w3, w1, 6
	and	w1, w1, 63
	strb	w1, [x2, 6]
	ldrb	w1, [x4, 12]
	strh	w3, [x2, 2]
	strb	w1, [x2, 8]
	adrp	x2, .LANCHOR53
	ldrh	w1, [x4, 22]
	add	x3, x2, :lo12:.LANCHOR53
	strh	w1, [x2, #:lo12:.LANCHOR53]
	mov	x21, x2
	ldrh	w1, [x4, 24]
	lsr	w7, w1, 6
	and	w1, w1, 63
	strb	w1, [x3, 6]
	ldrb	w1, [x4, 13]
	strb	w1, [x3, 8]
	adrp	x1, .LANCHOR84
	strh	w7, [x3, 2]
	ldr	w3, [x4, 32]
	str	wzr, [x1, #:lo12:.LANCHOR84]
	adrp	x1, .LANCHOR85
	str	wzr, [x1, #:lo12:.LANCHOR85]
	adrp	x1, .LANCHOR89
	str	wzr, [x1, #:lo12:.LANCHOR89]
	adrp	x1, .LANCHOR88
	str	wzr, [x1, #:lo12:.LANCHOR88]
	adrp	x1, .LANCHOR90
	str	w3, [x1, #:lo12:.LANCHOR90]
	adrp	x1, .LANCHOR91
	str	wzr, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR92
	str	wzr, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR87
	ldr	w3, [x4, 40]
	str	wzr, [x1, #:lo12:.LANCHOR87]
	adrp	x1, .LANCHOR82
	ldr	w4, [x1, #:lo12:.LANCHOR82]
	cmp	w3, w4
	bls	.L1381
	str	w3, [x1, #:lo12:.LANCHOR82]
.L1381:
	add	x19, x19, :lo12:.LANCHOR39
	adrp	x1, .LANCHOR83
	ldr	w3, [x1, #:lo12:.LANCHOR83]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L1382
	str	w2, [x1, #:lo12:.LANCHOR83]
.L1382:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L1383
	add	x0, x0, :lo12:.LANCHOR51
	bl	make_superblock
.L1383:
	ldrh	w2, [x20, #:lo12:.LANCHOR52]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR52
	cmp	w2, w1
	beq	.L1384
	bl	make_superblock
.L1384:
	ldrh	w2, [x21, #:lo12:.LANCHOR53]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR53
	cmp	w2, w1
	beq	.L1385
	bl	make_superblock
.L1385:
	ldrh	w2, [x22, #:lo12:.LANCHOR144]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR144
	cmp	w2, w1
	beq	.L1386
	bl	make_superblock
.L1386:
	mov	w0, 0
	b	.L1367
.L1376:
	add	x3, x19, :lo12:.LANCHOR138
	orr	w0, w28, w24, lsl 10
	mov	w2, 1
	str	x3, [x29, 104]
	mov	w1, w2
	str	w0, [x3, 4]
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	str	x0, [x3, 8]
	mov	x0, x3
	bl	FlashReadPages
	ldr	x3, [x29, 104]
	ldr	x0, [x3, 16]
	ldr	w8, [x0, 12]
	cbz	w8, .L1371
	ldrh	w1, [x26]
	ldr	x0, [x3, 8]
	bl	js_hash
	cmp	w8, w0
	beq	.L1371
	add	x10, x20, :lo12:.LANCHOR139
	mov	w6, w0
	mov	w5, w8
	adrp	x0, .LC38
	mov	w3, w28
	mov	w2, w24
	ldrh	w4, [x10, 4]
	mov	x1, x27
	add	x0, x0, :lo12:.LC38
	str	x10, [x29, 104]
	bl	printf
	cbnz	w28, .L1372
	ldr	x10, [x29, 104]
	ldrh	w0, [x10, 4]
	cmp	w24, w0
	beq	.L1372
	sxth	w24, w0
	adrp	x0, .LANCHOR20
	ldrh	w7, [x0, #:lo12:.LANCHOR20]
	sub	w7, w7, #1
.L1395:
	sxth	w28, w7
	b	.L1370
.L1372:
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR138]
.L1371:
	ldr	w0, [x19, #:lo12:.LANCHOR138]
	cmn	w0, #1
	beq	.L1374
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	ldr	w0, [x0]
	cmp	w0, w1
	bne	.L1374
	ldr	x0, [x25, #:lo12:.LANCHOR114]
	ldrh	w1, [x0]
	mov	w0, 61604
	cmp	w1, w0
	beq	.L1375
.L1374:
	sub	w7, w28, #1
	b	.L1395
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	stp	x29, x30, [sp, -160]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	mov	w20, 0
	ldrh	w25, [x0, 6]
	adrp	x26, .LANCHOR20
	stp	x23, x24, [sp, 48]
	ldr	x23, [x0, 40]
	ldr	x24, [x0, 16]
	lsl	w2, w25, 2
	ldr	x0, [x0, 24]
	str	x0, [x29, 144]
	ldrh	w0, [x19, 8]
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR106
	stp	x27, x28, [sp, 80]
	str	w0, [x29, 152]
	mov	x0, x23
	bl	ftl_memset
	stp	wzr, wzr, [x19, 48]
	adrp	x0, .LANCHOR138
	add	x6, x0, :lo12:.LANCHOR138
	ldr	x1, [x22, #:lo12:.LANCHOR106]
	mov	x27, x6
	str	x0, [x29, 128]
	str	x1, [x6, 8]
	adrp	x1, .LANCHOR114
	ldr	w0, [x29, 152]
	ldr	x21, [x1, #:lo12:.LANCHOR114]
	mov	w1, -1
	str	x21, [x6, 16]
	sub	w0, w0, #1
	strh	w1, [x19]
	strh	w1, [x19, 2]
	mov	w1, 1
	str	w0, [x29, 108]
	add	x0, x26, :lo12:.LANCHOR20
	str	w1, [x19, 56]
	str	x0, [x29, 96]
.L1397:
	ldr	w0, [x29, 152]
	cmp	w20, w0
	bge	.L1416
	ldr	w0, [x29, 108]
	sxtw	x28, w20
	cmp	w20, w0
	bne	.L1398
	lsl	x0, x28, 1
	mov	w1, 1
	add	x26, x24, x0
	adrp	x27, .LANCHOR23
	add	x27, x27, :lo12:.LANCHOR23
	mov	w22, 0
	ldrh	w0, [x24, x0]
	bl	FtlGetLastWrittenPage
	sxth	w1, w0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	x0, [x29, 144]
	strh	w20, [x19]
	str	w1, [x29, 152]
	ldr	w0, [x0, x28, lsl 2]
	adrp	x28, .LANCHOR180
	str	w0, [x19, 48]
	add	x28, x28, :lo12:.LANCHOR180
	ldr	x0, [x29, 128]
	add	x24, x0, :lo12:.LANCHOR138
.L1399:
	ldr	w0, [x29, 152]
	cmp	w22, w0
	ble	.L1402
.L1416:
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR20
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bne	.L1404
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1404:
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
	ldp	x29, x30, [sp], 160
	ret
.L1402:
	ldrh	w0, [x26]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x24, 4]
	mov	x0, x24
	bl	FlashReadPages
	ldr	x0, [x24, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 156]
	uxtw	x0, w0
	cbz	w0, .L1400
	ldrh	w1, [x27]
	ldr	x0, [x24, 8]
	bl	js_hash
	ldr	w1, [x29, 156]
	cmp	w1, w0
	beq	.L1400
	mov	w5, w0
	mov	x4, x1
	mov	w3, w22
	mov	w2, w20
	mov	x1, x28
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	bl	printf
	mov	w0, -1
	str	w0, [x24]
.L1400:
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L1401
	ldrh	w0, [x21, 8]
	cmp	w25, w0
	bls	.L1401
	ldrh	w2, [x21]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L1401
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x24, 4]
	str	w1, [x23, x0]
.L1401:
	add	w22, w22, 1
	sxth	w22, w22
	b	.L1399
.L1398:
	lsl	x2, x28, 1
	ldr	x0, [x22, #:lo12:.LANCHOR106]
	str	x0, [x27, 8]
	add	x0, x24, x2
	ldrh	w1, [x26, #:lo12:.LANCHOR20]
	str	x0, [x29, 136]
	ldrh	w0, [x24, x2]
	sub	w1, w1, #1
	mov	w2, 1
	orr	w0, w1, w0, lsl 10
	mov	w1, w2
	str	w0, [x27, 4]
	mov	x0, x27
	bl	FlashReadPages
	ldr	w0, [x27]
	cmn	w0, #1
	beq	.L1418
	ldrh	w1, [x21]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L1418
	ldrh	w1, [x21, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L1406
.L1418:
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	mov	w28, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR180
	add	x0, x0, :lo12:.LANCHOR180
	str	x0, [x29, 112]
.L1407:
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	cmp	w28, w0
	bge	.L1414
	ldr	x0, [x29, 136]
	mov	w2, 1
	mov	w1, w2
	ldrh	w0, [x0]
	orr	w0, w28, w0, lsl 10
	str	w0, [x27, 4]
	mov	x0, x27
	bl	FlashReadPages
	ldr	x0, [x27, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 156]
	uxtw	x0, w0
	cbz	w0, .L1411
	ldr	x0, [x29, 120]
	ldrh	w1, [x0]
	ldr	x0, [x27, 8]
	bl	js_hash
	ldr	w1, [x29, 156]
	cmp	w1, w0
	beq	.L1411
	mov	x4, x1
	ldr	x1, [x29, 112]
	mov	w5, w0
	mov	w3, w28
	mov	w2, w20
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	bl	printf
	mov	w0, -1
	str	w0, [x27]
.L1411:
	ldr	w0, [x27]
	cmn	w0, #1
	beq	.L1412
	ldrh	w0, [x21, 8]
	cmp	w25, w0
	bls	.L1412
	ldrh	w2, [x21]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L1412
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x27, 4]
	str	w1, [x23, x0]
.L1412:
	add	w7, w28, 1
	sxth	w28, w7
	b	.L1407
.L1406:
	ldrh	w3, [x26, #:lo12:.LANCHOR20]
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR106]
	sub	w3, w3, #1
.L1408:
	cmp	w0, w3
	blt	.L1410
.L1414:
	add	w20, w20, 1
	sxth	w20, w20
	b	.L1397
.L1410:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x4, x1]
	cmp	w25, w1
	bls	.L1409
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x4, x2, lsl 2]
	str	w2, [x23, x1]
.L1409:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L1408
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR27
	adrp	x0, .LANCHOR161
	add	x0, x0, :lo12:.LANCHOR161
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
	adrp	x1, .LANCHOR122
	ldr	x1, [x1, #:lo12:.LANCHOR122]
	str	x1, [x0, 24]
	adrp	x1, .LANCHOR121
	ldr	x1, [x1, #:lo12:.LANCHOR121]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR123
	ldr	x1, [x1, #:lo12:.LANCHOR123]
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
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	adrp	x19, .LANCHOR156
	stp	x21, x22, [sp, 32]
	strh	wzr, [x19, #:lo12:.LANCHOR156]
	str	x23, [sp, 48]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR139
	ldrh	w1, [x0, #:lo12:.LANCHOR139]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1437
.L1439:
	mov	w21, -1
.L1436:
	mov	w0, w21
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1437:
	bl	FtlLoadSysInfo
	mov	w21, w0
	cbnz	w0, .L1439
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
.L1440:
	cmp	w0, w2
	bge	.L1445
	ldr	w3, [x1], 16
	tbz	w3, #31, .L1441
.L1445:
	adrp	x3, .LANCHOR83
	cmp	w0, w2
	ldr	w1, [x3, #:lo12:.LANCHOR83]
	add	w1, w1, 32
	str	w1, [x3, #:lo12:.LANCHOR83]
	bge	.L1447
.L1442:
	adrp	x23, .LANCHOR51
	add	x20, x23, :lo12:.LANCHOR51
	mov	x0, x20
	adrp	x22, .LANCHOR52
	bl	FtlSuperblockPowerLostFix
	add	x19, x22, :lo12:.LANCHOR52
	mov	x0, x19
	bl	FtlSuperblockPowerLostFix
	adrp	x0, .LANCHOR42
	ldrh	w3, [x20, 4]
	ldr	x1, [x0, #:lo12:.LANCHOR42]
	ldrh	w0, [x23, #:lo12:.LANCHOR51]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w3
	adrp	x3, .LANCHOR19
	strh	w2, [x1, x0]
	strb	wzr, [x20, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x20, 2]
	ldrh	w0, [x22, #:lo12:.LANCHOR52]
	strh	wzr, [x20, 4]
	ldrh	w4, [x19, 4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w4
	strh	w2, [x1, x0]
	strb	wzr, [x19, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x19, 2]
	adrp	x0, .LANCHOR39
	add	x0, x0, :lo12:.LANCHOR39
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, 30]
	add	w1, w1, 1
	strh	w1, [x0, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1449:
	bl	FtlVpcTblFlush
	b	.L1436
.L1441:
	add	w0, w0, 1
	b	.L1440
.L1447:
	ldrh	w0, [x19, #:lo12:.LANCHOR156]
	cbnz	w0, .L1442
	bl	l2p_flush
	b	.L1449
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR83
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR4
	str	wzr, [x0, #:lo12:.LANCHOR83]
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR82
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	str	wzr, [x20, #:lo12:.LANCHOR82]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L1451
	bl	FtlMakeBbt
.L1451:
	adrp	x23, .LANCHOR12
	adrp	x0, .LANCHOR109
	mov	w6, 23752
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LANCHOR110
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR110]
	mov	w0, 0
.L1452:
	cmp	w0, w1
	blt	.L1453
	adrp	x21, .LANCHOR5
	adrp	x22, .LANCHOR6
	add	x26, x22, :lo12:.LANCHOR6
	mov	w19, 0
	ldrh	w25, [x21, #:lo12:.LANCHOR5]
.L1454:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L1455
	adrp	x25, .LANCHOR3
	sub	w1, w19, #2
	ldrh	w0, [x25, #:lo12:.LANCHOR3]
	cmp	w1, w0, lsl 1
	bgt	.L1456
.L1460:
	add	x26, x21, :lo12:.LANCHOR5
	mov	w19, 0
	mov	w24, 0
.L1457:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L1461
	adrp	x0, .LANCHOR99
	ldrh	w1, [x22, #:lo12:.LANCHOR6]
	ldrh	w4, [x25, #:lo12:.LANCHOR3]
	adrp	x2, .LANCHOR171
	str	w1, [x0, #:lo12:.LANCHOR99]
	adrp	x0, .LANCHOR7
	adrp	x3, .LANCHOR152
	ldr	w1, [x0, #:lo12:.LANCHOR7]
	udiv	w5, w1, w4
	ubfx	x0, x5, 5, 16
	str	w5, [x3, #:lo12:.LANCHOR152]
	add	w6, w0, 36
	strh	w6, [x2, #:lo12:.LANCHOR171]
	mov	w6, 24
	mul	w6, w4, w6
	cmp	w19, w6
	ble	.L1462
	sub	w1, w1, w19
	udiv	w1, w1, w4
	str	w1, [x3, #:lo12:.LANCHOR152]
	lsr	w1, w1, 5
	add	w1, w1, 24
	strh	w1, [x2, #:lo12:.LANCHOR171]
.L1462:
	adrp	x1, .LANCHOR15
	ldrh	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1464
	ldrh	w6, [x2, #:lo12:.LANCHOR171]
	add	w6, w6, w1, lsr 1
	strh	w6, [x2, #:lo12:.LANCHOR171]
	mul	w6, w1, w4
	cmp	w19, w6
	bge	.L1464
	add	w1, w1, 32
	str	w5, [x3, #:lo12:.LANCHOR152]
	add	w1, w0, w1
	strh	w1, [x2, #:lo12:.LANCHOR171]
.L1464:
	ldrh	w1, [x2, #:lo12:.LANCHOR171]
	adrp	x25, .LANCHOR179
	ldr	w0, [x3, #:lo12:.LANCHOR152]
	adrp	x24, .LANCHOR42
	sub	w0, w0, w1
	adrp	x1, .LANCHOR19
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w4
	str	w0, [x25, #:lo12:.LANCHOR179]
	mul	w0, w1, w0
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	str	w0, [x3, #:lo12:.LANCHOR152]
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
	adrp	x1, .LANCHOR144
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	str	wzr, [x0, #:lo12:.LANCHOR59]
	add	x0, x1, :lo12:.LANCHOR144
	strh	w23, [x1, #:lo12:.LANCHOR144]
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
.L1466:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1467
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1466
.L1453:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L1452
.L1455:
	mov	w0, w25
	mov	w1, 1
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w25, w25, 65535
	and	w19, w19, 65535
	b	.L1454
.L1456:
	udiv	w0, w19, w0
	adrp	x1, .LANCHOR31
	ldr	w19, [x1, #:lo12:.LANCHOR31]
	add	w0, w0, w19
	bl	FtlSysBlkNumInit
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	add	x24, x22, :lo12:.LANCHOR6
	bl	FtlFreeSysBlkQueueInit
	ldrh	w19, [x21, #:lo12:.LANCHOR5]
.L1458:
	ldrh	w0, [x24]
	cmp	w0, w19
	bls	.L1460
	mov	w0, w19
	add	w19, w19, 1
	mov	w1, 1
	and	w19, w19, 65535
	bl	FtlLowFormatEraseBlock
	b	.L1458
.L1461:
	mov	w0, w24
	mov	w1, 0
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w19, w19, w0
	and	w24, w24, 65535
	and	w19, w19, 65535
	b	.L1457
.L1467:
	ldr	w1, [x20, #:lo12:.LANCHOR82]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	mov	w23, -1
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR82]
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
.L1468:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1469
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L1468
.L1469:
	ldr	w1, [x20, #:lo12:.LANCHOR82]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR82]
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ldrh	w2, [x19, 4]
	mov	w19, -1
	strh	w2, [x1, x0]
	adrp	x0, .LANCHOR53
	strh	w19, [x0, #:lo12:.LANCHOR53]
	bl	FtlFreeSysBlkQueueOut
	adrp	x2, .LANCHOR139
	add	x1, x2, :lo12:.LANCHOR139
	strh	w0, [x2, #:lo12:.LANCHOR139]
	ldr	w0, [x25, #:lo12:.LANCHOR179]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR82]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR82]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L1470
	adrp	x0, .LANCHOR166
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR166]
.L1470:
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
	adrp	x1, .LC41
	add	x1, x1, :lo12:.LC41
	mov	w0, -1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR166
	adrp	x19, .LANCHOR181
	add	x19, x19, :lo12:.LANCHOR181
	str	w0, [x20, #:lo12:.LANCHOR166]
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	bl	printf
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	adrp	x0, .LANCHOR4
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	bl	FtlFreeSysBlkQueueInit
.L1476:
	bl	FtlLoadBbt
	cbz	w0, .L1477
.L1492:
	ldr	w0, [x19]
	cmp	w0, 1
	bne	.L1476
	str	wzr, [x19]
	bl	ftl_low_format
	b	.L1476
.L1477:
	bl	FtlSysBlkInit
	cbnz	w0, .L1492
	mov	w0, 1
	str	w0, [x20, #:lo12:.LANCHOR166]
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 15
	bhi	.L1489
	mov	w19, 8129
.L1483:
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L1483
.L1489:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	sftl_init, .-sftl_init
	.section	.text.FtlWriteToIDB,"ax",@progbits
	.align	2
	.global	FtlWriteToIDB
	.type	FtlWriteToIDB, %function
FtlWriteToIDB:
	stp	x29, x30, [sp, -224]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	add	w23, w1, w0
	stp	x25, x26, [sp, 64]
	sub	w25, w23, #1
	stp	x19, x20, [sp, 16]
	cmp	w25, 63
	stp	x21, x22, [sp, 32]
	adrp	x24, .LANCHOR182
	stp	x27, x28, [sp, 80]
	bls	.L1494
	mov	w19, w0
	cmp	w0, 575
	bls	.L1495
.L1494:
	ldr	w0, [x24, #:lo12:.LANCHOR182]
	cbnz	w0, .L1496
.L1561:
	mov	w19, 0
	b	.L1493
.L1496:
	adrp	x0, .LANCHOR183
	str	x0, [x29, 120]
	mov	w1, 35899
	ldr	x23, [x0, #:lo12:.LANCHOR183]
	movk	w1, 0xfcdc, lsl 16
	ldr	w2, [x23]
	cmp	w2, w1
	bne	.L1498
	adrp	x21, .LANCHOR0
	add	x0, x21, :lo12:.LANCHOR0
	mov	w19, 65535
	mov	w3, 4097
	ldrh	w1, [x0, 10]
	mov	x0, 262140
	add	x2, x23, x0
	mov	w0, 0
.L1502:
	ldr	w4, [x2]
	cbnz	w4, .L1499
	ldr	w4, [x23, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x2], -4
	cmp	w0, w3
	sub	w19, w19, #1
	csel	w0, w0, wzr, cc
	cmp	w19, 4096
	bne	.L1502
	mov	w19, 512
	b	.L1501
.L1499:
	add	w19, w19, 127
	lsr	w19, w19, 7
.L1501:
	add	w0, w19, 4
	ubfiz	w1, w1, 2, 14
	mov	w22, 0
	udiv	w0, w0, w1
	add	w0, w0, 1
	stp	wzr, w0, [x29, 152]
	lsl	w0, w19, 7
	str	w0, [x29, 136]
	adrp	x0, .LANCHOR78
	add	x20, x0, :lo12:.LANCHOR78
.L1524:
	adrp	x26, .LANCHOR184
	mov	w1, 0
	mov	x2, 512
	ldr	x0, [x26, #:lo12:.LANCHOR184]
	bl	memset
	str	x26, [x29, 144]
	add	x0, x21, :lo12:.LANCHOR0
	ldrh	w27, [x0, 10]
	adrp	x0, .LANCHOR78
	add	x0, x0, :lo12:.LANCHOR78
	ldr	x1, [x0, 32]
	mul	w25, w27, w22
	cbz	x1, .L1532
	ldr	x0, [x0, 40]
	mov	w26, 6
	cmp	x0, 0
	mov	w0, 9
	csel	w26, w26, w0, eq
.L1503:
	ldr	x2, [x20, 8]
	mov	w1, w25
	mov	w0, 0
	blr	x2
	ldr	w0, [x29, 156]
	cmp	w0, 1
	beq	.L1504
	ldr	x2, [x20, 8]
	add	w1, w27, w25
	mov	w0, 0
	blr	x2
.L1504:
	cmp	w26, 9
	bne	.L1534
	ldr	x0, [x29, 144]
	mov	w2, 1024
	mov	w1, 0
	ldr	x28, [x0, #:lo12:.LANCHOR184]
	mov	x0, x28
	bl	ftl_memset
	mov	w0, 18766
	mov	w1, 12
	movk	w0, 0x464e, lsl 16
	stp	w0, w1, [x28]
	mov	w0, 4
	strb	w0, [x28, 17]
	add	x0, x21, :lo12:.LANCHOR0
	strb	wzr, [x28, 16]
	strb	wzr, [x28, 20]
	strh	wzr, [x28, 22]
	ldrh	w0, [x0, 10]
	strh	w0, [x28, 18]
	str	wzr, [x28, 12]
	mov	w0, 16
	strb	w0, [x28, 21]
	add	x0, x28, 12
	bl	js_hash
	str	w0, [x28, 8]
.L1505:
	ldr	w0, [x29, 156]
	mov	x6, x23
	mul	w0, w0, w27
	mov	x27, 0
	str	w0, [x29, 140]
	add	w0, w25, 1
	str	w0, [x29, 132]
.L1506:
	ldr	w0, [x29, 140]
	mov	w1, w27
	cmp	w27, w0
	bcs	.L1513
	cmp	w26, 9
	bne	.L1507
	ldr	w0, [x29, 132]
	add	w0, w0, w1
.L1560:
	str	w0, [x29, 160]
	mov	w0, 61424
	str	w0, [x29, 164]
	cmp	w1, 0
	ccmp	w26, 9, 0, eq
	bne	.L1509
	ldr	x1, [x20, 32]
	mov	w0, 70
	str	x6, [x29, 104]
	blr	x1
	ldr	x7, [x20, 16]
	add	x3, x29, 160
	mov	x2, x28
	mov	w1, w25
	mov	w0, 0
	blr	x7
	mov	w1, w0
	add	x0, x21, :lo12:.LANCHOR0
	ldr	x2, [x20, 32]
	str	w1, [x29, 112]
	ldrb	w0, [x0, 22]
	blr	x2
	ldr	w1, [x29, 112]
	ldr	x6, [x29, 104]
	cmn	w1, #1
	bne	.L1510
.L1513:
	ldr	x0, [x29, 144]
	ldr	x26, [x0, #:lo12:.LANCHOR184]
	add	x0, x21, :lo12:.LANCHOR0
	ldrb	w28, [x0, 14]
	ldrh	w0, [x0, 10]
	mul	w1, w0, w22
	str	w1, [x29, 140]
	ldr	x1, [x20, 32]
	cbnz	x1, .L1511
	mov	w25, 6
.L1512:
	ldr	w1, [x29, 156]
	mov	x27, 0
	mul	w0, w1, w0
	str	w0, [x29, 132]
.L1515:
	ldr	w0, [x29, 132]
	mov	w1, w27
	cmp	w27, w0
	bcs	.L1519
	cmp	w27, 0
	ccmp	w25, 9, 0, eq
	bne	.L1516
	ldr	x1, [x20, 32]
	mov	w0, 70
	blr	x1
	ldr	x1, [x20, 40]
	mov	w0, 2
	blr	x1
	ldr	x6, [x20, 24]
	add	x3, x29, 160
	ldr	w1, [x29, 140]
	mov	x2, x26
	mov	w0, 0
	blr	x6
	ldr	x1, [x20, 40]
	mov	w0, w28
	blr	x1
	add	x0, x21, :lo12:.LANCHOR0
	ldr	x1, [x20, 32]
	ldrb	w0, [x0, 22]
	blr	x1
	ldr	w0, [x26]
	mov	w1, 18766
	movk	w1, 0x464e, lsl 16
	cmp	w0, w1
	beq	.L1517
.L1519:
	ldr	x0, [x29, 144]
	mov	x2, x23
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR184]
.L1518:
	ldr	w3, [x29, 136]
	mov	w26, w1
	cmp	w1, w3
	bcc	.L1522
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	cmp	w0, 5
	bls	.L1521
	b	.L1525
.L1532:
	mov	w26, 6
	b	.L1503
.L1534:
	mov	x28, 0
	b	.L1505
.L1507:
	add	w0, w1, w25
	lsl	w0, w0, 2
	b	.L1560
.L1509:
	ldr	x7, [x20, 16]
	add	x3, x29, 160
	mov	x2, x6
	add	w1, w1, w25
	mov	w0, 0
	str	x6, [x29, 112]
	blr	x7
	cmn	w0, #1
	beq	.L1513
	ldr	x6, [x29, 112]
	add	x6, x6, 2048
.L1510:
	add	x27, x27, 1
	b	.L1506
.L1511:
	ldr	x1, [x20, 40]
	mov	w25, 6
	cmp	x1, 0
	mov	w1, 9
	csel	w25, w25, w1, eq
	b	.L1512
.L1516:
	ldr	x6, [x20, 24]
	add	x3, x29, 160
	ldr	w0, [x29, 140]
	mov	x2, x26
	add	w1, w1, w0
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	beq	.L1519
	ldr	w0, [x29, 164]
	mov	w1, 61424
	cmp	w0, w1
	bne	.L1519
	add	x26, x26, 2048
.L1517:
	add	x27, x27, 1
	b	.L1515
.L1522:
	mov	x25, x2
	ldr	w4, [x0, x1, lsl 2]
	lsl	x27, x1, 2
	add	x2, x2, 4
	add	x1, x1, 1
	ldr	w3, [x25]
	cmp	w4, w3
	beq	.L1518
	mov	x2, 512
	mov	w1, 0
	bl	memset
	ldr	x0, [x29, 144]
	mov	w1, w22
	ldr	w3, [x25]
	mov	w4, w26
	ldr	x0, [x0, #:lo12:.LANCHOR184]
	ldr	w2, [x0, x27]
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	add	x0, x21, :lo12:.LANCHOR0
	ldr	x2, [x20, 8]
	ldrh	w1, [x0, 10]
	mov	w0, 0
	mul	w1, w1, w22
	blr	x2
.L1521:
	ldr	w0, [x29, 156]
	add	w22, w22, w0
	cmp	w22, 15
	bls	.L1524
	ldr	w0, [x29, 152]
	cbnz	w0, .L1525
.L1498:
	mov	w19, -1
.L1525:
	ldr	x0, [x29, 120]
	str	wzr, [x24, #:lo12:.LANCHOR182]
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	bl	free
	adrp	x0, .LANCHOR184
	ldr	x0, [x0, #:lo12:.LANCHOR184]
	bl	free
.L1493:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 224
	ret
.L1495:
	mov	w21, w1
	mov	x22, x2
	cmp	w0, 64
	bne	.L1526
	adrp	x20, .LANCHOR183
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x20, #:lo12:.LANCHOR183]
	mov	w0, 262144
	bl	ftl_malloc
	mov	x1, x0
	adrp	x0, .LANCHOR184
	str	x1, [x0, #:lo12:.LANCHOR184]
	ldr	x0, [x20, #:lo12:.LANCHOR183]
	cbz	x0, .L1527
	cbz	x1, .L1527
	mov	w1, 1
	mov	w2, 262144
	str	w1, [x24, #:lo12:.LANCHOR182]
	mov	w1, 0
	bl	ftl_memset
.L1526:
	ldr	w0, [x24, #:lo12:.LANCHOR182]
	cbz	w0, .L1561
	adrp	x0, .LANCHOR183
	cmp	w19, 63
	ldr	x1, [x0, #:lo12:.LANCHOR183]
	bhi	.L1529
	mov	w0, 64
	sub	w19, w0, w19
	sub	w21, w21, w19
	ubfiz	x19, x19, 9, 25
	add	x22, x22, x19
	mov	x20, x1
.L1530:
	cmp	w25, 575
	bls	.L1531
	sub	w21, w21, w23
	sub	w21, w21, #446
.L1531:
	mov	w4, w21
	mov	x3, x20
	mov	w2, 262144
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printf
	lsl	w2, w21, 9
	mov	x1, x22
	mov	x0, x20
	bl	ftl_memcpy
	b	.L1561
.L1527:
	adrp	x1, .LANCHOR185
	adrp	x0, .LC43
	add	x1, x1, :lo12:.LANCHOR185
	add	x0, x0, :lo12:.LC43
	bl	printf
	b	.L1526
.L1529:
	lsl	w20, w19, 7
	sub	w20, w20, #8192
	add	x20, x1, x20, lsl 2
	b	.L1530
	.size	FtlWriteToIDB, .-FtlWriteToIDB
	.section	.text.sftl_write,"ax",@progbits
	.align	2
	.global	sftl_write
	.type	sftl_write, %function
sftl_write:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	mov	w19, w0
	str	x21, [sp, 32]
	mov	x21, x2
	bl	FtlWriteToIDB
	mov	x3, x21
	mov	w2, w20
	mov	w1, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 48
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
	.set	.LANCHOR127,. + 0
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
	.set	.LANCHOR171,. + 0
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
	.set	.LANCHOR67,. + 0
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
	.set	.LANCHOR133,. + 0
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
	.set	.LANCHOR129,. + 0
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
	.set	.LANCHOR139,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 16
gSysInfo:
	.zero	16
	.section	.bss.gVendorBlkInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 64
gVendorBlkInfo:
	.zero	64
	.section	.bss.g_GlobalDataVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.zero	4
	.section	.bss.g_GlobalSysVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR82,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR152,. + 0
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
	.set	.LANCHOR99,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.zero	4
	.section	.bss.g_ect_tbl_info_size,"aw",@nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.zero	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",@nobits
	.align	1
	.set	.LANCHOR164,. + 0
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
	.set	.LANCHOR76,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR74,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR75,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_blk_index,"aw",@nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.zero	2
	.section	.bss.g_gc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR68,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_head_data_block,"aw",@nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.zero	4
	.section	.bss.g_gc_head_data_block_count,"aw",@nobits
	.align	2
	.set	.LANCHOR97,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.zero	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_next_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR72,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.zero	2
	.section	.bss.g_gc_next_blk_1,"aw",@nobits
	.align	1
	.set	.LANCHOR73,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.zero	2
	.section	.bss.g_gc_num_req,"aw",@nobits
	.align	2
	.set	.LANCHOR62,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.zero	4
	.section	.bss.g_gc_page_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.zero	2
	.section	.bss.g_gc_skip_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.zero	4
	.section	.bss.g_gc_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR94,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.zero	4
	.section	.bss.g_in_swl_replace,"aw",@nobits
	.align	2
	.set	.LANCHOR95,. + 0
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
	.set	.LANCHOR92,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.zero	4
	.section	.bss.g_min_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR93,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.zero	4
	.section	.bss.g_nand_ops,"aw",@nobits
	.align	3
	.set	.LANCHOR78,. + 0
	.type	g_nand_ops, %object
	.size	g_nand_ops, 48
g_nand_ops:
	.zero	48
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
	.set	.LANCHOR156,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.zero	128
	.section	.bss.g_sys_ext_data,"aw",@nobits
	.align	3
	.set	.LANCHOR135,. + 0
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
	.set	.LANCHOR131,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.zero	2
	.section	.bss.g_totle_avg_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.zero	4
	.section	.bss.g_totle_cache_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR87,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.zero	4
	.section	.bss.g_totle_discard_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR86,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.zero	4
	.section	.bss.g_totle_gc_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR84,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.zero	4
	.section	.bss.g_totle_l2p_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR88,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.zero	4
	.section	.bss.g_totle_map_block,"aw",@nobits
	.align	1
	.set	.LANCHOR130,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.zero	2
	.section	.bss.g_totle_mlc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR90,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.zero	4
	.section	.bss.g_totle_read_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR89,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.zero	4
	.section	.bss.g_totle_read_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.zero	4
	.section	.bss.g_totle_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_swl_count,"aw",@nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.zero	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR80,. + 0
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
	.set	.LANCHOR85,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.zero	4
	.section	.bss.g_totle_write_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR162,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 8
gp_ect_tbl_info:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 8
gp_flash_check_buf:
	.zero	8
	.section	.bss.gp_gc_page_buf_info,"aw",@nobits
	.align	3
	.set	.LANCHOR63,. + 0
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
	.set	.LANCHOR183,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 8
idb_buf:
	.zero	8
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR182,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.low_format_en,"aw",@nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	low_format_en, %object
	.size	low_format_en, 4
low_format_en:
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
	.set	.LANCHOR69,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 8
p_gc_blk_tbl:
	.zero	8
	.section	.bss.p_gc_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR64,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 8
p_gc_data_buf:
	.zero	8
	.section	.bss.p_gc_page_info,"aw",@nobits
	.align	3
	.set	.LANCHOR71,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 8
p_gc_page_info:
	.zero	8
	.section	.bss.p_gc_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 8
p_gc_spare_buf:
	.zero	8
	.section	.bss.p_io_data_buf_0,"aw",@nobits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR110,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 8
p_io_data_buf_1:
	.zero	8
	.section	.bss.p_io_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR115,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 8
p_io_spare_buf:
	.zero	8
	.section	.bss.p_l2p_map_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR126,. + 0
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
	.set	.LANCHOR119,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 8
p_map_block_table:
	.zero	8
	.section	.bss.p_map_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR120,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 8
p_map_block_valid_page_count:
	.zero	8
	.section	.bss.p_map_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 8
p_map_block_ver_table:
	.zero	8
	.section	.bss.p_map_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR124,. + 0
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
	.set	.LANCHOR117,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 8
p_swl_mul_table:
	.zero	8
	.section	.bss.p_sys_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 8
p_sys_data_buf:
	.zero	8
	.section	.bss.p_sys_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 8
p_sys_data_buf_1:
	.zero	8
	.section	.bss.p_sys_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 8
p_sys_spare_buf:
	.zero	8
	.section	.bss.p_valid_page_count_check_table,"aw",@nobits
	.align	3
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
	.set	.LANCHOR121,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 8
p_vendor_block_valid_page_count:
	.zero	8
	.section	.bss.p_vendor_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 8
p_vendor_block_ver_table:
	.zero	8
	.section	.bss.p_vendor_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 8
p_vendor_data_buf:
	.zero	8
	.section	.bss.p_vendor_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR123,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 8
p_vendor_region_ppn_table:
	.zero	8
	.section	.bss.req_erase,"aw",@nobits
	.align	3
	.set	.LANCHOR79,. + 0
	.type	req_erase, %object
	.size	req_erase, 8
req_erase:
	.zero	8
	.section	.bss.req_gc,"aw",@nobits
	.align	3
	.set	.LANCHOR66,. + 0
	.type	req_gc, %object
	.size	req_gc, 8
req_gc:
	.zero	8
	.section	.bss.req_gc_dst,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 8
req_gc_dst:
	.zero	8
	.section	.bss.req_prgm,"aw",@nobits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 8
req_prgm:
	.zero	8
	.section	.bss.req_read,"aw",@nobits
	.align	3
	.set	.LANCHOR103,. + 0
	.type	req_read, %object
	.size	req_read, 8
req_read:
	.zero	8
	.section	.bss.req_sys,"aw",@nobits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	req_sys, %object
	.size	req_sys, 32
req_sys:
	.zero	32
	.section	.bss.sftl_nand_check_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	sftl_nand_check_buf, %object
	.size	sftl_nand_check_buf, 8
sftl_nand_check_buf:
	.zero	8
	.section	.bss.sftl_nand_check_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	sftl_nand_check_spare_buf, %object
	.size	sftl_nand_check_spare_buf, 8
sftl_nand_check_spare_buf:
	.zero	8
	.section	.bss.sftl_temp_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	sftl_temp_buf, %object
	.size	sftl_temp_buf, 8
sftl_temp_buf:
	.zero	8
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",@progbits
	.align	1
	.set	.LANCHOR160,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.power_up_flag,"aw",@progbits
	.align	2
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashEraseBlocks.str1.1,"aMS",@progbits,1
.LC6:
	.string	"%s: addr: %x is in id block!!!!!!!!!!\n"
.LC7:
	.string	"not free: w: d:"
.LC8:
	.string	"not free: w: s:"
	.section	.rodata.FlashProgPages.str1.1,"aMS",@progbits,1
.LC11:
	.string	"prog read error: = %x\n"
.LC12:
	.string	"prog read s error: = %x %x %x\n"
.LC13:
	.string	"prog read d error: = %x %x %x\n"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",@progbits,1
.LC0:
	.string	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\n"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",@progbits,1
.LC14:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC15:
	.string	"FtlBbmTblFlush error:%x\n"
.LC16:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC9:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC31:
	.string	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC33:
	.string	"no ect"
.LC34:
	.string	"%s\n"
	.section	.rodata.FtlLoadSysInfo.str1.1,"aMS",@progbits,1
.LC38:
	.string	"%s hash error this.id =%x page =%x pre_id =%x hash =%x hash_r =%x\n"
	.section	.rodata.FtlMapTblRecovery.str1.1,"aMS",@progbits,1
.LC39:
	.string	"%s last blk_id =%x page =%x hash error hash =%x hash_r =%x\n"
.LC40:
	.string	"%s scan blk_id =%x page =%x hash error hash =%x hash_r =%x\n"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC18:
	.string	"FtlMapWritePage error = %x \n"
.LC19:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlProgPages.str1.1,"aMS",@progbits,1
.LC36:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC24:
	.string	"spuer block %x vpn is 0\n "
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",@progbits,1
.LC32:
	.string	"FtlVendorPartRead refresh = %x phyAddr = %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC35:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC37:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.FtlWriteToIDB.str1.1,"aMS",@progbits,1
.LC42:
	.string	"write_idblock fail! %x %x %x %x\n"
.LC43:
	.string	"%s idb buffer alloc fail\n"
.LC44:
	.string	"%p %x %p %x\n"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC1:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.__func__.6241,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.6241, %object
	.size	__func__.6241, 13
__func__.6241:
	.string	"FtlProgPages"
	.section	.rodata.__func__.6269,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.6269, %object
	.size	__func__.6269, 9
__func__.6269:
	.string	"FtlWrite"
	.section	.rodata.__func__.6344,"a",@progbits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	__func__.6344, %object
	.size	__func__.6344, 14
__func__.6344:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.6379,"a",@progbits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	__func__.6379, %object
	.size	__func__.6379, 11
__func__.6379:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.6494,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.6494, %object
	.size	__func__.6494, 17
__func__.6494:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.6499,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.6499, %object
	.size	__func__.6499, 17
__func__.6499:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.6530,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.6530, %object
	.size	__func__.6530, 17
__func__.6530:
	.string	"List_remove_node"
	.section	.rodata.__func__.6562,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.6562, %object
	.size	__func__.6562, 22
__func__.6562:
	.string	"List_update_data_list"
	.section	.rodata.__func__.6571,"a",@progbits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	__func__.6571, %object
	.size	__func__.6571, 16
__func__.6571:
	.string	"load_l2p_region"
	.section	.rodata.__func__.6604,"a",@progbits
	.align	3
	.set	.LANCHOR81,. + 0
	.type	__func__.6604, %object
	.size	__func__.6604, 26
__func__.6604:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.6615,"a",@progbits
	.align	3
	.set	.LANCHOR151,. + 0
	.type	__func__.6615, %object
	.size	__func__.6615, 15
__func__.6615:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.6630,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.6630, %object
	.size	__func__.6630, 31
__func__.6630:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.6644,"a",@progbits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	__func__.6644, %object
	.size	__func__.6644, 16
__func__.6644:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.6669,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.6669, %object
	.size	__func__.6669, 22
__func__.6669:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.6686,"a",@progbits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	__func__.6686, %object
	.size	__func__.6686, 9
__func__.6686:
	.string	"log2phys"
	.section	.rodata.__func__.6750,"a",@progbits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	__func__.6750, %object
	.size	__func__.6750, 15
__func__.6750:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.6772,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.6772, %object
	.size	__func__.6772, 14
__func__.6772:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.6828,"a",@progbits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	__func__.6828, %object
	.size	__func__.6828, 15
__func__.6828:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.6850,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.6850, %object
	.size	__func__.6850, 18
__func__.6850:
	.string	"FtlMapTblRecovery"
	.section	.rodata.__func__.6896,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.6896, %object
	.size	__func__.6896, 16
__func__.6896:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.6930,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.6930, %object
	.size	__func__.6930, 22
__func__.6930:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.6987,"a",@progbits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	__func__.6987, %object
	.size	__func__.6987, 16
__func__.6987:
	.string	"make_superblock"
	.section	.rodata.__func__.7008,"a",@progbits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	__func__.7008, %object
	.size	__func__.7008, 18
__func__.7008:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.7035,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.7035, %object
	.size	__func__.7035, 14
__func__.7035:
	.string	"ftl_check_vpc"
	.section	.rodata.__func__.7100,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.7100, %object
	.size	__func__.7100, 25
__func__.7100:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.7121,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.7121, %object
	.size	__func__.7121, 29
__func__.7121:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.7128,"a",@progbits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	__func__.7128, %object
	.size	__func__.7128, 19
__func__.7128:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.7141,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.7141, %object
	.size	__func__.7141, 16
__func__.7141:
	.string	"update_vpc_list"
	.section	.rodata.__func__.7148,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.7148, %object
	.size	__func__.7148, 20
__func__.7148:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.7218,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.7218, %object
	.size	__func__.7218, 19
__func__.7218:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.7316,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.7316, %object
	.size	__func__.7316, 23
__func__.7316:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.7578,"a",@progbits
	.align	3
	.set	.LANCHOR137,. + 0
	.type	__func__.7578, %object
	.size	__func__.7578, 15
__func__.7578:
	.string	"FlashReadPages"
	.section	.rodata.__func__.7597,"a",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	__func__.7597, %object
	.size	__func__.7597, 15
__func__.7597:
	.string	"FlashProgPages"
	.section	.rodata.__func__.7621,"a",@progbits
	.align	3
	.set	.LANCHOR77,. + 0
	.type	__func__.7621, %object
	.size	__func__.7621, 17
__func__.7621:
	.string	"FlashEraseBlocks"
	.section	.rodata.__func__.7736,"a",@progbits
	.align	3
	.set	.LANCHOR185,. + 0
	.type	__func__.7736, %object
	.size	__func__.7736, 14
__func__.7736:
	.string	"FtlWriteToIDB"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC17:
	.string	"decrement_vpc_count %x = %d\n"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",@progbits,1
.LC25:
	.string	"...%s enter...\n"
.LC26:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC27:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC10:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC28:
	.string	"ftl_scan_all_data = %x\n"
.LC29:
	.string	"scan lpa = %x ppa= %x\n"
.LC30:
	.string	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC20:
	.string	"region_id = %x phyAddr = %x\n"
.LC21:
	.string	"spare:"
.LC22:
	.string	"map_ppn:"
.LC23:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC2:
	.string	"%s 0x%x:"
.LC3:
	.string	"%x "
.LC4:
	.string	"%02x "
.LC5:
	.string	"\n"
	.section	.rodata.sftl_init.str1.1,"aMS",@progbits,1
.LC41:
	.string	"SFTL version: 5.0.50 20181227"
	.hidden	free
