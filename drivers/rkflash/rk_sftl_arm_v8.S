/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 * date: 2018-07-13
 */
	.arch armv8-a+nosimd
	.file	"rk_sftl.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.l2p_addr_tran.isra.0,"ax",@progbits
	.align	2
	.type	l2p_addr_tran.isra.0, %function
l2p_addr_tran.isra.0:
.LFB349:
	.file 1 "drivers/rkflash/rksftl/sftl_flash.c"
	.loc 1 58 0
	.cfi_startproc
.LVL0:
	.loc 1 66 0
	adrp	x4, .LANCHOR0
	add	x4, x4, :lo12:.LANCHOR0
	ldrh	w3, [x4, 8]
.LVL1:
	.loc 1 67 0
	ldrh	w6, [x4, 10]
.LVL2:
	.loc 1 68 0
	ldrh	w4, [x4, 14]
	cmp	w4, 4
	bne	.L2
	.loc 1 69 0
	lsr	w3, w3, 1
.LVL3:
	.loc 1 70 0
	ubfiz	w6, w6, 1, 15
.LVL4:
.L2:
	.loc 1 74 0
	lsr	w5, w0, 10
.LVL5:
	.loc 1 78 0
	and	w0, w0, 1023
.LVL6:
	.loc 1 75 0
	and	w4, w5, 65535
	.loc 1 76 0
	and	w5, w5, 65535
.LVL7:
	.loc 1 75 0
	udiv	w4, w4, w3
.LVL8:
	.loc 1 76 0
	msub	w3, w3, w4, w5
.LVL9:
	.loc 1 78 0
	madd	w3, w3, w6, w0
	.loc 1 82 0
	mov	w0, 0
	.loc 1 78 0
	str	w3, [x1]
	.loc 1 79 0
	str	w4, [x2]
	.loc 1 82 0
	ret
	.cfi_endproc
.LFE349:
	.size	l2p_addr_tran.isra.0, .-l2p_addr_tran.isra.0
	.section	.text.ftl_set_blk_mode.part.6,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.6, %function
ftl_set_blk_mode.part.6:
.LFB355:
	.file 2 "drivers/rkflash/rksftl/sftl_sys.c"
	.loc 2 1395 0
	.cfi_startproc
.LVL10:
	.loc 2 1395 0
	and	w0, w0, 65535
	.loc 2 1398 0
	adrp	x2, .LANCHOR1
	ubfx	x1, x0, 5, 11
	ldr	x3, [x2, #:lo12:.LANCHOR1]
	lsl	x1, x1, 2
	mov	w2, 1
	lsl	w2, w2, w0
	ldr	w0, [x3, x1]
.LVL11:
	orr	w0, w0, w2
	str	w0, [x3, x1]
	ret
	.cfi_endproc
.LFE355:
	.size	ftl_set_blk_mode.part.6, .-ftl_set_blk_mode.part.6
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
.LFB202:
	.file 3 "drivers/rkflash/rksftl/sftl_plat.c"
	.loc 3 128 0
	.cfi_startproc
.LVL12:
	.loc 3 130 0
	mov	w2, 1
	.loc 3 132 0
	mov	w1, 0
.LVL13:
.L5:
	.loc 3 132 0 is_stmt 0 discriminator 1
	cmp	w2, w0
	bls	.L6
.LVL14:
	.loc 3 134 0 is_stmt 1
	sub	w0, w1, #1
.LVL15:
	.loc 3 136 0
	ret
.LVL16:
.L6:
	.loc 3 132 0 discriminator 3
	add	w1, w1, 1
.LVL17:
	.loc 3 133 0 discriminator 3
	lsl	w2, w2, 1
.LVL18:
	.loc 3 132 0 discriminator 3
	and	w1, w1, 65535
.LVL19:
	b	.L5
	.cfi_endproc
.LFE202:
	.size	Ftl_log2, .-Ftl_log2
	.section	.text.FtlPrintInfo,"ax",@progbits
	.align	2
	.global	FtlPrintInfo
	.type	FtlPrintInfo, %function
FtlPrintInfo:
.LFB203:
	.loc 3 160 0
	.cfi_startproc
.LVL20:
	ret
	.cfi_endproc
.LFE203:
	.size	FtlPrintInfo, .-FtlPrintInfo
	.section	.text.FtlSysBlkNumInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkNumInit
	.type	FtlSysBlkNumInit, %function
FtlSysBlkNumInit:
.LFB204:
	.loc 3 166 0
	.cfi_startproc
.LVL21:
	.loc 3 166 0
	and	w0, w0, 65535
	mov	w1, 24
	cmp	w0, 24
	.loc 3 170 0
	adrp	x2, .LANCHOR4
	csel	w0, w0, w1, cs
.LVL22:
	.loc 3 169 0
	adrp	x1, .LANCHOR2
	and	w0, w0, 65535
.LVL23:
	str	w0, [x1, #:lo12:.LANCHOR2]
	.loc 3 170 0
	adrp	x1, .LANCHOR3
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	mul	w1, w1, w0
	str	w1, [x2, #:lo12:.LANCHOR4]
	.loc 3 171 0
	adrp	x2, .LANCHOR6
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	sub	w0, w2, w0
.LVL24:
	adrp	x2, .LANCHOR5
	strh	w0, [x2, #:lo12:.LANCHOR5]
	.loc 3 172 0
	adrp	x0, .LANCHOR8
	ldr	w0, [x0, #:lo12:.LANCHOR8]
	sub	w1, w0, w1
	adrp	x0, .LANCHOR7
	str	w1, [x0, #:lo12:.LANCHOR7]
	.loc 3 175 0
	mov	w0, 0
	ret
	.cfi_endproc
.LFE204:
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.section	.text.FtlConstantsInit,"ax",@progbits
	.align	2
	.global	FtlConstantsInit
	.type	FtlConstantsInit, %function
FtlConstantsInit:
.LFB205:
	.loc 3 184 0
	.cfi_startproc
.LVL25:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x5, x0
	.loc 3 191 0
	adrp	x1, .LANCHOR11
	.loc 3 184 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 189 0
	ldrh	w2, [x0]
	adrp	x0, .LANCHOR9
.LVL26:
	.loc 3 190 0
	ldrh	w4, [x5, 2]
	.loc 3 189 0
	strh	w2, [x0, #:lo12:.LANCHOR9]
	.loc 3 190 0
	adrp	x0, .LANCHOR10
	strh	w4, [x0, #:lo12:.LANCHOR10]
	.loc 3 191 0
	ldrh	w0, [x5, 4]
	strh	w0, [x1, #:lo12:.LANCHOR11]
	.loc 3 192 0
	ldrh	w1, [x5, 14]
	cmp	w1, 4
	bne	.L10
	.loc 3 193 0
	ldrh	w1, [x5, 6]
	adrp	x3, .LANCHOR6
	lsr	w1, w1, 1
	strh	w1, [x3, #:lo12:.LANCHOR6]
	.loc 3 194 0
	adrp	x1, .LANCHOR12
	mov	w3, 8
	strh	w3, [x1, #:lo12:.LANCHOR12]
.L10:
	.loc 3 198 0 discriminator 3
	adrp	x3, .LANCHOR13
	add	x3, x3, :lo12:.LANCHOR13
	.loc 3 184 0 discriminator 3
	mov	x1, 0
.L11:
.LVL27:
	.loc 3 198 0 discriminator 3
	strb	w1, [x1, x3]
.LVL28:
	add	x1, x1, 1
.LVL29:
	.loc 3 197 0 discriminator 3
	cmp	x1, 32
	bne	.L11
	.loc 3 199 0
	adrp	x1, .LANCHOR14
	mov	w3, 5
	.loc 3 201 0
	cmp	w2, 1
	.loc 3 199 0
	strh	w3, [x1, #:lo12:.LANCHOR14]
	.loc 3 200 0
	adrp	x3, .LANCHOR15
	strh	wzr, [x3, #:lo12:.LANCHOR15]
	.loc 3 201 0
	bne	.L12
	.loc 3 202 0
	strh	w2, [x1, #:lo12:.LANCHOR14]
.L12:
	.loc 3 203 0
	adrp	x1, .LANCHOR16
	mov	w2, 640
	.loc 3 205 0
	mul	w4, w4, w0
	.loc 3 203 0
	strh	w2, [x1, #:lo12:.LANCHOR16]
	.loc 3 205 0
	adrp	x1, .LANCHOR3
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR3]
	.loc 3 206 0
	adrp	x1, .LANCHOR6
	ldrh	w3, [x1, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR17
	mul	w0, w0, w3
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR17]
	.loc 3 207 0
	bl	Ftl_log2
.LVL30:
	.loc 3 208 0
	ldrh	w7, [x5, 12]
	.loc 3 207 0
	adrp	x1, .LANCHOR18
	.loc 3 208 0
	adrp	x8, .LANCHOR19
	.loc 3 207 0
	strh	w0, [x1, #:lo12:.LANCHOR18]
	.loc 3 209 0
	adrp	x0, .LANCHOR20
	.loc 3 210 0
	mul	w1, w4, w7
	.loc 3 208 0
	strh	w7, [x8, #:lo12:.LANCHOR19]
	.loc 3 209 0
	strh	w7, [x0, #:lo12:.LANCHOR20]
	.loc 3 210 0
	adrp	x0, .LANCHOR21
	strh	w1, [x0, #:lo12:.LANCHOR21]
	.loc 3 211 0
	adrp	x0, .LANCHOR12
	ldrh	w6, [x0, #:lo12:.LANCHOR12]
	mov	w0, w6
	bl	Ftl_log2
.LVL31:
	and	w1, w0, 65535
	adrp	x2, .LANCHOR22
	.loc 3 213 0
	adrp	x10, .LANCHOR23
	.loc 3 215 0
	ldrh	w5, [x5, 20]
.LVL32:
	.loc 3 211 0
	strh	w0, [x2, #:lo12:.LANCHOR22]
	.loc 3 213 0
	ubfiz	w0, w6, 9, 7
	strh	w0, [x10, #:lo12:.LANCHOR23]
	.loc 3 214 0
	adrp	x10, .LANCHOR24
	ubfx	w0, w0, 8, 8
	strh	w0, [x10, #:lo12:.LANCHOR24]
	.loc 3 215 0
	adrp	x0, .LANCHOR25
	strh	w5, [x0, #:lo12:.LANCHOR25]
	.loc 3 217 0
	mul	w0, w4, w3
	adrp	x5, .LANCHOR8
	str	w0, [x5, #:lo12:.LANCHOR8]
	.loc 3 218 0
	adrp	x5, .LANCHOR26
	mul	w0, w0, w6
	.loc 3 219 0
	mul	w6, w6, w7
	.loc 3 218 0
	mul	w0, w0, w7
	mov	x7, x2
	asr	w0, w0, 11
	str	w0, [x5, #:lo12:.LANCHOR26]
	.loc 3 219 0
	mov	w0, 5120
	adrp	x5, .LANCHOR27
	sdiv	w0, w0, w6
	and	w0, w0, 65535
	.loc 3 220 0
	cmp	w0, 4
	bls	.L13
.L19:
	.loc 3 221 0
	strh	w0, [x5, #:lo12:.LANCHOR27]
	.loc 3 222 0
	adrp	x2, .LANCHOR28
	mov	w0, 640
	.loc 3 224 0
	lsl	w3, w3, 6
	.loc 3 222 0
	asr	w0, w0, w1
	add	w0, w0, 2
	.loc 3 224 0
	add	w1, w1, 9
	.loc 3 222 0
	strh	w0, [x2, #:lo12:.LANCHOR28]
	.loc 3 224 0
	adrp	x0, .LANCHOR29
	.loc 3 228 0
	cmp	w4, 1
	.loc 3 224 0
	asr	w3, w3, w1
	.loc 3 225 0
	adrp	x1, .LANCHOR30
	.loc 3 224 0
	strh	w3, [x0, #:lo12:.LANCHOR29]
	and	w3, w3, 65535
	adrp	x6, .LANCHOR2
	.loc 3 225 0
	mul	w0, w3, w4
	.loc 3 227 0
	add	w3, w3, 8
	.loc 3 225 0
	str	w0, [x1, #:lo12:.LANCHOR30]
	.loc 3 227 0
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	.loc 3 228 0
	beq	.L15
.L20:
	.loc 3 229 0
	str	w3, [x6, #:lo12:.LANCHOR2]
	.loc 3 232 0
	ldrh	w0, [x6, #:lo12:.LANCHOR2]
	bl	FtlSysBlkNumInit
.LVL33:
	.loc 3 233 0
	ldr	w1, [x6, #:lo12:.LANCHOR2]
	adrp	x0, .LANCHOR31
	.loc 3 264 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	.loc 3 233 0
	str	w1, [x0, #:lo12:.LANCHOR31]
	.loc 3 235 0
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
	.loc 3 236 0
	adrp	x0, .LANCHOR33
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR33]
	.loc 3 237 0
	adrp	x0, .LANCHOR34
	str	wzr, [x0, #:lo12:.LANCHOR34]
	.loc 3 238 0
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	add	w0, w0, 3
	strh	w0, [x5, #:lo12:.LANCHOR27]
	.loc 3 239 0
	ldr	w0, [x4, #:lo12:.LANCHOR30]
	add	w0, w0, 3
	str	w0, [x4, #:lo12:.LANCHOR30]
	.loc 3 264 0
	mov	w0, 0
	ret
.L13:
	.cfi_restore_state
	.loc 3 221 0
	mov	w0, 4
	b	.L19
.L15:
	.loc 3 229 0
	add	w3, w3, 4
	b	.L20
	.cfi_endproc
.LFE205:
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
.LFB208:
	.loc 3 514 0
	.cfi_startproc
.LVL34:
	.loc 3 517 0
	adrp	x1, .LANCHOR35
	.loc 3 514 0
	and	w0, w0, 65535
	.loc 3 517 0
	ldrh	w1, [x1, #:lo12:.LANCHOR35]
	cbz	w1, .L25
.LBB185:
.LBB186:
	.loc 3 518 0
	adrp	x1, .LANCHOR27
	ldrh	w2, [x1, #:lo12:.LANCHOR27]
	.loc 3 519 0
	adrp	x1, .LANCHOR36
	ldr	x3, [x1, #:lo12:.LANCHOR36]
	mov	x1, 0
.L23:
.LVL35:
	.loc 3 518 0
	cmp	w2, w1, uxth
	bhi	.L24
.LVL36:
.L25:
.LBE186:
.LBE185:
	.loc 3 524 0
	mov	w0, 0
.LVL37:
	ret
.LVL38:
.L24:
	add	x1, x1, 1
.LVL39:
.LBB188:
.LBB187:
	.loc 3 519 0
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L23
	.loc 3 520 0
	mov	w0, 1
.LBE187:
.LBE188:
	.loc 3 525 0
	ret
	.cfi_endproc
.LFE208:
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlCacheWriteBack,"ax",@progbits
	.align	2
	.global	FtlCacheWriteBack
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
.LFB216:
	.loc 3 952 0
	.cfi_startproc
	.loc 3 954 0
	mov	w0, 0
	ret
	.cfi_endproc
.LFE216:
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.sftl_get_density,"ax",@progbits
	.align	2
	.global	sftl_get_density
	.type	sftl_get_density, %function
sftl_get_density:
.LFB221:
	.loc 3 1178 0
	.cfi_startproc
	.loc 3 1180 0
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	ret
	.cfi_endproc
.LFE221:
	.size	sftl_get_density, .-sftl_get_density
	.section	.text.FtlBbmMapBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmMapBadBlock
	.type	FtlBbmMapBadBlock, %function
FtlBbmMapBadBlock:
.LFB222:
	.file 4 "drivers/rkflash/rksftl/sftl_bbm.c"
	.loc 4 5 0
	.cfi_startproc
.LVL40:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	and	w1, w0, 65535
	.loc 4 10 0
	adrp	x0, .LANCHOR17
.LVL41:
	.loc 4 15 0
	mov	w4, 1
	.loc 4 5 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 4 10 0
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	.loc 4 5 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 4 13 0
	adrp	x19, .LANCHOR37
	add	x19, x19, :lo12:.LANCHOR37
	.loc 4 10 0
	udiv	w3, w1, w0
	and	w2, w3, 65535
.LVL42:
	msub	w3, w3, w0, w1
	.loc 4 13 0
	add	x0, x19, x2, uxth 3
	and	w3, w3, 65535
.LVL43:
	.loc 4 15 0
	ldr	x0, [x0, 32]
	ubfx	x5, x3, 5, 11
	lsl	x5, x5, 2
	lsl	w4, w4, w3
	ldr	w6, [x0, x5]
	orr	w4, w4, w6
	str	w4, [x0, x5]
	.loc 4 16 0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
.LVL44:
	.loc 4 17 0
	ldrh	w0, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 6]
	.loc 4 19 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE222:
	.size	FtlBbmMapBadBlock, .-FtlBbmMapBadBlock
	.section	.text.FtlBbmIsBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmIsBadBlock
	.type	FtlBbmIsBadBlock, %function
FtlBbmIsBadBlock:
.LFB223:
	.loc 4 24 0
	.cfi_startproc
.LVL45:
	.loc 4 30 0
	adrp	x1, .LANCHOR17
	.loc 4 24 0
	and	w0, w0, 65535
	.loc 4 30 0
	ldrh	w1, [x1, #:lo12:.LANCHOR17]
.LVL46:
	.loc 4 31 0
	udiv	w2, w0, w1
	msub	w0, w2, w1, w0
.LVL47:
	.loc 4 33 0
	adrp	x1, .LANCHOR37
.LVL48:
	add	x1, x1, :lo12:.LANCHOR37
	add	x2, x1, x2, uxth 3
	.loc 4 31 0
	and	w0, w0, 65535
.LVL49:
	.loc 4 34 0
	ubfx	x3, x0, 5, 11
	ldr	x1, [x2, 32]
	ldr	w1, [x1, x3, lsl 2]
	lsr	w0, w1, w0
.LVL50:
	.loc 4 36 0
	and	w0, w0, 1
	ret
	.cfi_endproc
.LFE223:
	.size	FtlBbmIsBadBlock, .-FtlBbmIsBadBlock
	.section	.text.FtlBbtInfoPrint,"ax",@progbits
	.align	2
	.global	FtlBbtInfoPrint
	.type	FtlBbtInfoPrint, %function
FtlBbtInfoPrint:
.LFB224:
	.loc 4 39 0
	.cfi_startproc
	ret
	.cfi_endproc
.LFE224:
	.size	FtlBbtInfoPrint, .-FtlBbtInfoPrint
	.section	.text.FtlBbtCalcTotleCnt,"ax",@progbits
	.align	2
	.global	FtlBbtCalcTotleCnt
	.type	FtlBbtCalcTotleCnt, %function
FtlBbtCalcTotleCnt:
.LFB228:
	.loc 4 157 0
	.cfi_startproc
.LVL51:
	.loc 4 160 0
	adrp	x0, .LANCHOR17
	mov	w4, 0
	.loc 4 159 0
	mov	w5, 0
.LVL52:
	.loc 4 160 0
	ldrh	w6, [x0, #:lo12:.LANCHOR17]
	adrp	x0, .LANCHOR10
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	mul	w6, w6, w0
	cmp	w4, w6
	blt	.L43
	.loc 4 169 0
	mov	w0, w5
	ret
.L43:
	.loc 4 157 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.L36:
	.loc 4 162 0
	mov	w0, w4
	bl	FtlBbmIsBadBlock
.LVL53:
	cbz	w0, .L35
	.loc 4 164 0
	add	w5, w5, 1
.LVL54:
	and	w5, w5, 65535
.LVL55:
.L35:
	.loc 4 160 0 discriminator 2
	add	w4, w4, 1
.LVL56:
	and	w4, w4, 65535
.LVL57:
	cmp	w4, w6
	blt	.L36
	.loc 4 169 0
	mov	w0, w5
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE228:
	.size	FtlBbtCalcTotleCnt, .-FtlBbtCalcTotleCnt
	.section	.text.V2P_block,"ax",@progbits
	.align	2
	.global	V2P_block
	.type	V2P_block, %function
V2P_block:
.LFB232:
	.loc 2 5 0
	.cfi_startproc
.LVL58:
	.loc 2 8 0
	adrp	x2, .LANCHOR11
	.loc 2 5 0
	and	w0, w0, 65535
	.loc 2 8 0
	adrp	x4, .LANCHOR17
	.loc 2 5 0
	and	w1, w1, 65535
	.loc 2 8 0
	ldrh	w2, [x2, #:lo12:.LANCHOR11]
.LVL59:
	ldrh	w4, [x4, #:lo12:.LANCHOR17]
	udiv	w3, w0, w2
	msub	w0, w3, w2, w0
.LVL60:
	madd	w2, w2, w1, w0
.LVL61:
	madd	w0, w3, w4, w2
	.loc 2 10 0
	ret
	.cfi_endproc
.LFE232:
	.size	V2P_block, .-V2P_block
	.section	.text.P2V_plane,"ax",@progbits
	.align	2
	.global	P2V_plane
	.type	P2V_plane, %function
P2V_plane:
.LFB233:
	.loc 2 13 0
	.cfi_startproc
.LVL62:
	.loc 2 13 0
	and	w3, w0, 65535
	.loc 2 16 0
	adrp	x0, .LANCHOR11
.LVL63:
	ldrh	w1, [x0, #:lo12:.LANCHOR11]
.LVL64:
	adrp	x0, .LANCHOR17
	ldrh	w2, [x0, #:lo12:.LANCHOR17]
	udiv	w0, w3, w1
	udiv	w2, w3, w2
	msub	w0, w0, w1, w3
	madd	w0, w1, w2, w0
	.loc 2 18 0
	ret
	.cfi_endproc
.LFE233:
	.size	P2V_plane, .-P2V_plane
	.section	.text.P2V_block_in_plane,"ax",@progbits
	.align	2
	.global	P2V_block_in_plane
	.type	P2V_block_in_plane, %function
P2V_block_in_plane:
.LFB234:
	.loc 2 21 0
	.cfi_startproc
.LVL65:
	.loc 2 21 0
	and	w2, w0, 65535
	.loc 2 24 0
	adrp	x0, .LANCHOR17
.LVL66:
	ldrh	w1, [x0, #:lo12:.LANCHOR17]
	udiv	w0, w2, w1
	msub	w0, w0, w1, w2
	.loc 2 25 0
	adrp	x1, .LANCHOR11
	ldrh	w1, [x1, #:lo12:.LANCHOR11]
	.loc 2 24 0
	and	w0, w0, 65535
.LVL67:
	.loc 2 27 0
	udiv	w0, w0, w1
.LVL68:
	ret
	.cfi_endproc
.LFE234:
	.size	P2V_block_in_plane, .-P2V_block_in_plane
	.section	.text.ftl_cmp_data_ver,"ax",@progbits
	.align	2
	.global	ftl_cmp_data_ver
	.type	ftl_cmp_data_ver, %function
ftl_cmp_data_ver:
.LFB235:
	.loc 2 31 0
	.cfi_startproc
.LVL69:
	.loc 2 34 0
	cmp	w0, w1
	mov	w2, -2147483648
	bls	.L48
	.loc 2 36 0
	sub	w1, w0, w1
.LVL70:
	cmp	w1, w2
	cset	w0, ls
.LVL71:
	ret
.LVL72:
.L48:
	.loc 2 40 0
	sub	w1, w1, w0
.LVL73:
	cmp	w1, w2
	cset	w0, hi
.LVL74:
	.loc 2 44 0
	ret
	.cfi_endproc
.LFE235:
	.size	ftl_cmp_data_ver, .-ftl_cmp_data_ver
	.section	.text.FtlFreeSysBlkQueueEmpty,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueEmpty
	.type	FtlFreeSysBlkQueueEmpty, %function
FtlFreeSysBlkQueueEmpty:
.LFB238:
	.loc 2 88 0
	.cfi_startproc
	.loc 2 89 0
	adrp	x0, .LANCHOR38+6
	ldrh	w0, [x0, #:lo12:.LANCHOR38+6]
	cmp	w0, 0
	.loc 2 90 0
	cset	w0, eq
	ret
	.cfi_endproc
.LFE238:
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueFull
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
.LFB239:
	.loc 2 93 0
	.cfi_startproc
	.loc 2 94 0
	adrp	x0, .LANCHOR38+6
	ldrh	w0, [x0, #:lo12:.LANCHOR38+6]
	cmp	w0, 1024
	.loc 2 95 0
	cset	w0, eq
	ret
	.cfi_endproc
.LFE239:
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
	.section	.text.FtlFreeSysBLkSort,"ax",@progbits
	.align	2
	.global	FtlFreeSysBLkSort
	.type	FtlFreeSysBLkSort, %function
FtlFreeSysBLkSort:
.LFB241:
	.loc 2 118 0
	.cfi_startproc
.LVL75:
	.loc 2 123 0
	adrp	x0, .LANCHOR38
	add	x1, x0, :lo12:.LANCHOR38
	ldrh	w2, [x1, 6]
	cbz	w2, .L52
	.loc 2 119 0
	adrp	x2, .LANCHOR39+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR39+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L54:
.LVL76:
	.loc 2 124 0 discriminator 1
	cmp	w5, w4
	bgt	.L55
	cbz	w6, .L52
	add	x0, x0, :lo12:.LANCHOR38
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.LVL77:
.L52:
	ret
.LVL78:
.L55:
	.loc 2 125 0 discriminator 3
	add	x6, x1, x3, sxtw 1
	.loc 2 124 0 discriminator 3
	add	w4, w4, 1
.LVL79:
	.loc 2 126 0 discriminator 3
	add	w3, w3, 1
	.loc 2 124 0 discriminator 3
	and	w4, w4, 65535
	.loc 2 126 0 discriminator 3
	and	w3, w3, 1023
	.loc 2 125 0 discriminator 3
	ldrh	w7, [x6, 8]
.LVL80:
	.loc 2 127 0 discriminator 3
	add	x6, x1, x2, sxtw 1
	strh	w7, [x6, 8]
	mov	w6, 1
	.loc 2 128 0 discriminator 3
	add	w2, w2, w6
	and	w2, w2, 1023
	b	.L54
	.cfi_endproc
.LFE241:
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.IsInFreeQueue,"ax",@progbits
	.align	2
	.global	IsInFreeQueue
	.type	IsInFreeQueue, %function
IsInFreeQueue:
.LFB242:
	.loc 2 163 0
	.cfi_startproc
.LVL81:
.LBB189:
.LBB190:
	.loc 2 94 0
	adrp	x1, .LANCHOR38
	add	x1, x1, :lo12:.LANCHOR38
.LBE190:
.LBE189:
	.loc 2 163 0
	and	w0, w0, 65535
.LBB192:
.LBB191:
	.loc 2 94 0
	ldrh	w4, [x1, 6]
.LBE191:
.LBE192:
	.loc 2 168 0
	cmp	w4, 1024
	beq	.L65
	.loc 2 171 0
	ldrh	w5, [x1, 2]
	mov	w3, 0
.L63:
.LVL82:
	.loc 2 170 0 discriminator 1
	cmp	w3, w4
	bcc	.L64
.LVL83:
.L65:
	.loc 2 164 0
	mov	w0, 0
.LVL84:
	ret
.LVL85:
.L64:
	.loc 2 171 0
	add	w2, w3, w5
	ubfiz	x2, x2, 1, 10
	add	x2, x1, x2
	ldrh	w2, [x2, 8]
	cmp	w2, w0
	beq	.L66
	.loc 2 170 0 discriminator 2
	add	w3, w3, 1
.LVL86:
	b	.L63
.L66:
	.loc 2 172 0
	mov	w0, 1
.LVL87:
	.loc 2 178 0
	ret
	.cfi_endproc
.LFE242:
	.size	IsInFreeQueue, .-IsInFreeQueue
	.section	.text.insert_data_list,"ax",@progbits
	.align	2
	.global	insert_data_list
	.type	insert_data_list, %function
insert_data_list:
.LFB246:
	.loc 2 249 0
	.cfi_startproc
.LVL88:
	.loc 2 260 0
	adrp	x1, .LANCHOR5
	.loc 2 249 0
	and	w0, w0, 65535
	.loc 2 260 0
	ldrh	w14, [x1, #:lo12:.LANCHOR5]
	cmp	w14, w0
	bls	.L83
	.loc 2 265 0
	adrp	x1, .LANCHOR40
	mov	w3, 6
	ldr	x6, [x1, #:lo12:.LANCHOR40]
	umull	x13, w0, w3
	.loc 2 266 0
	mov	w1, -1
	.loc 2 265 0
	add	x5, x6, x13
.LVL89:
	.loc 2 266 0
	strh	w1, [x5, 2]
	strh	w1, [x6, x13]
	.loc 2 268 0
	adrp	x1, .LANCHOR41
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR41]
	cbnz	x12, .L70
	.loc 2 269 0
	str	x5, [x1, #:lo12:.LANCHOR41]
.LVL90:
.L83:
	.loc 2 323 0
	mov	w0, 0
.LVL91:
	ret
.LVL92:
.L70:
	.loc 2 249 0
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 273 0
	adrp	x1, .LANCHOR42
	ubfiz	x2, x0, 1, 16
	.loc 2 279 0
	mov	x4, -6148914691236517206
	.loc 2 249 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 273 0
	ldr	x16, [x1, #:lo12:.LANCHOR42]
	.loc 2 279 0
	movk	x4, 0xaaab, lsl 0
	.loc 2 274 0
	ldrh	w1, [x5, 4]
	mov	w8, -1
	.loc 2 289 0
	mov	w11, w8
	.loc 2 249 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 274 0
	cmp	w1, 0
	.loc 2 301 0
	mov	w20, 65535
	.loc 2 273 0
	ldrh	w7, [x16, x2]
.LVL93:
	.loc 2 274 0
	mul	w7, w7, w1
.LVL94:
	.loc 2 279 0
	sub	x1, x12, x6
.LVL95:
	asr	x1, x1, 1
	.loc 2 274 0
	csel	w7, w7, w8, ne
.LVL96:
	.loc 2 309 0
	mov	w8, w3
	.loc 2 279 0
	mul	x1, x1, x4
	.loc 2 294 0
	adrp	x4, .LANCHOR43
	ldr	x17, [x4, #:lo12:.LANCHOR43]
	.loc 2 279 0
	and	w1, w1, 65535
.LVL97:
	.loc 2 294 0
	mov	x4, x12
	add	x10, x17, x2
	.loc 2 256 0
	mov	w2, 0
.LVL98:
.L78:
	.loc 2 281 0
	add	w2, w2, 1
.LVL99:
	and	w2, w2, 65535
.LVL100:
	.loc 2 282 0
	cmp	w14, w2
	bcc	.L69
	.loc 2 285 0
	cmp	w1, w0
	beq	.L69
	.loc 2 288 0
	ubfiz	x30, x1, 1, 16
	.loc 2 289 0
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	.loc 2 288 0
	ldrh	w3, [x16, x30]
.LVL101:
	.loc 2 289 0
	mul	w3, w3, w19
.LVL102:
	csel	w3, w3, w11, ne
.LVL103:
	.loc 2 293 0
	cmp	w7, w3
	bne	.L74
	.loc 2 294 0
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
.LVL104:
	cmp	w19, w3
	bcc	.L76
.L75:
	.loc 2 312 0
	strh	w1, [x6, x13]
.LVL105:
	.loc 2 315 0
	cmp	x4, x12
	.loc 2 313 0
	ldrh	w1, [x4, 2]
.LVL106:
	strh	w1, [x5, 2]
	.loc 2 315 0
	bne	.L79
	.loc 2 316 0
	strh	w0, [x4, 2]
	.loc 2 317 0
	str	x5, [x15, #:lo12:.LANCHOR41]
	b	.L69
.LVL107:
.L74:
	.loc 2 298 0
	bcc	.L75
.LVL108:
.L76:
	.loc 2 301 0
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L77
	.loc 2 302 0
	strh	w1, [x5, 2]
.LVL109:
	.loc 2 303 0
	strh	w0, [x4]
	.loc 2 304 0
	adrp	x0, .LANCHOR44
	str	x5, [x0, #:lo12:.LANCHOR44]
.LVL110:
.L69:
	.loc 2 323 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL111:
.L77:
	.cfi_restore_state
	.loc 2 309 0
	umaddl	x4, w3, w8, x6
.LVL112:
	.loc 2 281 0
	mov	w1, w3
	b	.L78
.LVL113:
.L79:
	.loc 2 319 0
	ldrh	w1, [x4, 2]
	mov	w2, 6
.LVL114:
	umull	x1, w1, w2
	strh	w0, [x6, x1]
.LVL115:
	.loc 2 320 0
	strh	w0, [x4, 2]
	b	.L69
	.cfi_endproc
.LFE246:
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
.LFB245:
	.loc 2 218 0
	.cfi_startproc
.LVL116:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 219 0
	bl	insert_data_list
.LVL117:
	.loc 2 220 0
	adrp	x1, .LANCHOR45
	ldrh	w0, [x1, #:lo12:.LANCHOR45]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR45]
	.loc 2 221 0
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L85
.LVL118:
	.loc 2 222 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
.LBB195:
.LBB196:
	.loc 2 221 0
	mov	w2, 221
	adrp	x1, .LANCHOR46
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC1
	b	printf
.LVL119:
.L85:
	.cfi_restore_state
.LBE196:
.LBE195:
	.loc 2 222 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE245:
	.size	INSERT_DATA_LIST, .-INSERT_DATA_LIST
	.section	.text.insert_free_list,"ax",@progbits
	.align	2
	.global	insert_free_list
	.type	insert_free_list, %function
insert_free_list:
.LFB247:
	.loc 2 326 0
	.cfi_startproc
.LVL120:
	.loc 2 326 0
	and	w0, w0, 65535
	.loc 2 332 0
	mov	w7, 65535
	cmp	w0, w7
	beq	.L89
	.loc 2 335 0
	adrp	x1, .LANCHOR40
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR40]
	umull	x8, w0, w6
	.loc 2 336 0
	mov	w1, -1
	.loc 2 335 0
	add	x4, x3, x8
.LVL121:
	.loc 2 336 0
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	.loc 2 338 0
	adrp	x1, .LANCHOR47
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR47]
	cbnz	x5, .L90
	.loc 2 339 0
	str	x4, [x1, #:lo12:.LANCHOR47]
.LVL122:
.L89:
	.loc 2 372 0
	mov	w0, 0
.LVL123:
	ret
.LVL124:
.L90:
	.loc 2 343 0
	adrp	x1, .LANCHOR43
	.loc 2 345 0
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	.loc 2 343 0
	ldr	x11, [x1, #:lo12:.LANCHOR43]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
.LVL125:
	.loc 2 345 0
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.LVL126:
.L93:
	.loc 2 348 0
	ubfiz	x10, x1, 1, 16
	.loc 2 349 0
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L91
	.loc 2 352 0
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L92
	.loc 2 353 0
	strh	w1, [x4, 2]
.LVL127:
	.loc 2 354 0
	strh	w0, [x2]
	.loc 2 355 0
	b	.L89
.LVL128:
.L92:
	.loc 2 358 0
	umaddl	x2, w10, w6, x3
.LVL129:
	.loc 2 348 0
	mov	w1, w10
.LVL130:
	b	.L93
.LVL131:
.L91:
	.loc 2 361 0
	ldrh	w6, [x2, 2]
	.loc 2 364 0
	cmp	x2, x5
	.loc 2 361 0
	strh	w6, [x4, 2]
.LVL132:
	.loc 2 362 0
	strh	w1, [x3, x8]
	.loc 2 364 0
	bne	.L94
	.loc 2 365 0
	strh	w0, [x2, 2]
	.loc 2 366 0
	str	x4, [x12, #:lo12:.LANCHOR47]
	b	.L89
.L94:
	.loc 2 368 0
	ldrh	w1, [x2, 2]
.LVL133:
	mov	w4, 6
.LVL134:
	umull	x1, w1, w4
	strh	w0, [x3, x1]
.LVL135:
	.loc 2 369 0
	strh	w0, [x2, 2]
	b	.L89
	.cfi_endproc
.LFE247:
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
.LFB244:
	.loc 2 211 0
	.cfi_startproc
.LVL136:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 212 0
	bl	insert_free_list
.LVL137:
	.loc 2 213 0
	adrp	x1, .LANCHOR48
	ldrh	w0, [x1, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR48]
	.loc 2 214 0
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L95
.LVL138:
	.loc 2 215 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
.LBB199:
.LBB200:
	.loc 2 214 0
	mov	w2, 214
	adrp	x1, .LANCHOR49
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC1
	b	printf
.LVL139:
.L95:
	.cfi_restore_state
.LBE200:
.LBE199:
	.loc 2 215 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE244:
	.size	INSERT_FREE_LIST, .-INSERT_FREE_LIST
	.section	.text.List_remove_node,"ax",@progbits
	.align	2
	.global	List_remove_node
	.type	List_remove_node, %function
List_remove_node:
.LFB248:
	.loc 2 375 0
	.cfi_startproc
.LVL140:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	and	w1, w1, 65535
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 2 378 0
	adrp	x20, .LANCHOR40
	.loc 2 375 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	.loc 2 378 0
	mov	w0, 6
.LVL141:
	.loc 2 375 0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	.loc 2 378 0
	ldr	x23, [x20, #:lo12:.LANCHOR40]
	umull	x21, w1, w0
	.loc 2 379 0
	mov	w0, 65535
	.loc 2 378 0
	add	x19, x23, x21
.LVL142:
	.loc 2 379 0
	ldrh	w1, [x19, 2]
.LVL143:
	cmp	w1, w0
	bne	.L99
	.loc 2 379 0 is_stmt 0 discriminator 1
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L99
	.loc 2 379 0 discriminator 2
	adrp	x1, .LANCHOR50
	adrp	x0, .LC1
	mov	w2, 379
	add	x1, x1, :lo12:.LANCHOR50
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL144:
.L99:
	.loc 2 381 0 is_stmt 1
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L100
	.loc 2 382 0
	cmp	w0, w1
	bne	.L101
	.loc 2 383 0
	str	xzr, [x22]
.L102:
	.loc 2 399 0
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	.loc 2 401 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL145:
	ldp	x21, x22, [sp, 32]
.LVL146:
	ldr	x23, [sp, 48]
.LVL147:
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL148:
.L101:
	.cfi_restore_state
	.loc 2 385 0
	ldr	x1, [x20, #:lo12:.LANCHOR40]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	.loc 2 386 0
	mov	w1, -1
	.loc 2 385 0
	str	x0, [x22]
	.loc 2 386 0
	strh	w1, [x0, 2]
	b	.L102
.L100:
	.loc 2 388 0
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L103
	.loc 2 389 0
	cmp	w1, w0
	beq	.L102
.LVL149:
	.loc 2 390 0
	mov	w0, 6
	.loc 2 391 0
	mov	w2, -1
	.loc 2 390 0
	umull	x1, w1, w0
.LVL150:
	.loc 2 391 0
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	strh	w2, [x0, x1]
	b	.L102
.LVL151:
.L103:
	.loc 2 394 0
	ldr	x2, [x20, #:lo12:.LANCHOR40]
.LVL152:
	mov	w3, 6
	.loc 2 395 0
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
.LVL153:
	.loc 2 396 0
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	.loc 2 397 0
	strh	w0, [x2, x1]
	b	.L102
	.cfi_endproc
.LFE248:
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
.LFB249:
	.loc 2 404 0
	.cfi_startproc
.LVL154:
	.loc 2 408 0
	ldr	x2, [x0]
	cbz	x2, .L111
	.loc 2 404 0
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 413 0
	adrp	x3, .LANCHOR40
	and	w1, w1, 65535
	.loc 2 412 0
	mov	w4, 65535
	.loc 2 404 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 413 0
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR40]
.LVL155:
.L107:
	.loc 2 412 0
	cbnz	w1, .L108
.L110:
	.loc 2 416 0
	sub	x19, x2, x19
	mov	x2, -6148914691236517206
.LVL156:
	asr	x19, x19, 1
	movk	x2, 0xaaab, lsl 0
	mul	x19, x19, x2
	and	w19, w19, 65535
.LVL157:
	.loc 2 417 0
	mov	w1, w19
.LVL158:
	bl	List_remove_node
.LVL159:
	.loc 2 419 0
	mov	w0, w19
	.loc 2 420 0
	ldr	x19, [sp, 16]
.LVL160:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL161:
.L108:
	.cfi_restore_state
	.loc 2 412 0 discriminator 1
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L110
	.loc 2 414 0
	sub	w1, w1, #1
.LVL162:
	.loc 2 413 0
	umaddl	x2, w3, w5, x19
.LVL163:
	.loc 2 414 0
	and	w1, w1, 65535
.LVL164:
	b	.L107
.LVL165:
.L111:
	.cfi_def_cfa 31, 0
	.cfi_restore 19
	.cfi_restore 29
	.cfi_restore 30
	.loc 2 409 0
	mov	w0, 65535
.LVL166:
	ret
	.cfi_endproc
.LFE249:
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_pop_head_node,"ax",@progbits
	.align	2
	.global	List_pop_head_node
	.type	List_pop_head_node, %function
List_pop_head_node:
.LFB250:
	.loc 2 423 0
	.cfi_startproc
.LVL167:
	.loc 2 424 0
	mov	w1, 0
	b	List_pop_index_node
.LVL168:
	.cfi_endproc
.LFE250:
	.size	List_pop_head_node, .-List_pop_head_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
.LFB251:
	.loc 2 428 0
	.cfi_startproc
.LVL169:
	.loc 2 428 0
	and	w2, w0, 65535
	.loc 2 432 0
	adrp	x0, .LANCHOR41
.LVL170:
	ldr	x1, [x0, #:lo12:.LANCHOR41]
	cbz	x1, .L122
	.loc 2 437 0
	adrp	x0, .LANCHOR40
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR40]
	.loc 2 436 0
	mov	w0, 65535
.LVL171:
.L119:
	cbz	w2, .L120
	.loc 2 436 0 is_stmt 0 discriminator 1
	ldrh	w1, [x1]
.LVL172:
	cmp	w1, w0
	bne	.L121
	ret
.L121:
	.loc 2 438 0 is_stmt 1
	sub	w2, w2, #1
.LVL173:
	.loc 2 437 0
	umaddl	x1, w1, w4, x3
.LVL174:
	.loc 2 438 0
	and	w2, w2, 65535
.LVL175:
	b	.L119
.LVL176:
.L122:
	.loc 2 433 0
	mov	w0, 65535
	ret
.LVL177:
.L120:
	.loc 2 442 0
	sub	x0, x1, x3
	mov	x1, -6148914691236517206
.LVL178:
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	.loc 2 444 0
	and	w0, w0, 65535
	.loc 2 445 0
	ret
	.cfi_endproc
.LFE251:
	.size	List_get_gc_head_node, .-List_get_gc_head_node
	.section	.text.List_update_data_list,"ax",@progbits
	.align	2
	.global	List_update_data_list
	.type	List_update_data_list, %function
List_update_data_list:
.LFB252:
	.loc 2 448 0
	.cfi_startproc
.LVL179:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	and	w19, w0, 65535
	.loc 2 457 0
	adrp	x0, .LANCHOR51
.LVL180:
	.loc 2 448 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.loc 2 457 0
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	.loc 2 448 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 2 457 0
	cmp	w0, w19
	beq	.L125
	.loc 2 457 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L125
	.loc 2 457 0 discriminator 2
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L125
.LVL181:
.LBB203:
.LBB204:
	.loc 2 460 0 is_stmt 1
	adrp	x0, .LANCHOR40
	mov	w21, 6
	.loc 2 462 0
	adrp	x24, .LANCHOR41
	mov	x26, x0
	.loc 2 460 0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR40]
	.loc 2 462 0
	ldr	x1, [x24, #:lo12:.LANCHOR41]
	.loc 2 460 0
	add	x22, x23, x21
.LVL182:
	.loc 2 462 0
	cmp	x22, x1
	beq	.L125
	.loc 2 465 0
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	mov	x25, x1
	ldr	x2, [x1, #:lo12:.LANCHOR42]
	.loc 2 470 0
	mov	w1, 65535
	.loc 2 465 0
	ldrh	w20, [x2, x0]
.LVL183:
	.loc 2 466 0
	ldrh	w0, [x22, 4]
.LVL184:
	cmp	w0, 0
	mul	w20, w20, w0
.LVL185:
	.loc 2 470 0
	ldrh	w0, [x22, 2]
.LVL186:
	.loc 2 466 0
	csinv	w20, w20, wzr, ne
.LVL187:
	.loc 2 470 0
	cmp	w0, w1
	bne	.L128
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L128
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 470
.LVL188:
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL189:
.L128:
	.loc 2 471 0
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L129
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L125
.L129:
	.loc 2 473 0
	mov	w1, 6
	.loc 2 474 0
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	.loc 2 473 0
	umull	x0, w0, w1
.LVL190:
	.loc 2 474 0
	asr	x1, x0, 1
	mul	x1, x1, x2
	.loc 2 475 0
	ldr	x2, [x25, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1, lsl 1]
.LVL191:
	.loc 2 476 0
	ldr	x2, [x26, #:lo12:.LANCHOR40]
	add	x0, x2, x0
.LVL192:
	ldrh	w2, [x0, 4]
.LVL193:
	cmp	w2, 0
	mul	w0, w1, w2
.LVL194:
	csinv	w0, w0, wzr, ne
.LVL195:
	.loc 2 480 0
	cmp	w20, w0
	bcs	.L125
	.loc 2 481 0
	adrp	x20, .LANCHOR45
.LVL196:
	mov	w1, w19
.LVL197:
	add	x0, x24, :lo12:.LANCHOR41
.LVL198:
	bl	List_remove_node
.LVL199:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L131
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 481
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL200:
.L131:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	.loc 2 482 0
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL201:
.L125:
.LBE204:
.LBE203:
	.loc 2 485 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL202:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE252:
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
.LFB260:
	.loc 2 749 0
	.cfi_startproc
.LVL203:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 754 0
	adrp	x0, .LANCHOR33
	mov	x1, 0
	.loc 2 755 0
	mov	w3, 65535
	.loc 2 749 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 754 0
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	.loc 2 755 0
	adrp	x0, .LANCHOR55
	.loc 2 749 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 755 0
	ldr	x0, [x0, #:lo12:.LANCHOR55]
.LVL204:
.L136:
	and	w19, w1, 65535
.LVL205:
	.loc 2 754 0 discriminator 1
	cmp	w19, w2
	bcc	.L138
	add	x3, x0, 4
	.loc 2 754 0 is_stmt 0
	mov	w19, w2
.LVL206:
	mov	w5, -2147483648
	mov	w1, 0
.LVL207:
.L139:
	.loc 2 764 0 is_stmt 1 discriminator 1
	cmp	w1, w2
	bne	.L141
	.loc 2 773 0
	cmp	w19, w2
	bcc	.L137
	.loc 2 779 0
	adrp	x1, .LANCHOR56
.LVL208:
	mov	w19, w2
.LVL209:
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR56]
	mov	w1, 0
.LVL210:
.L142:
	.loc 2 778 0 discriminator 1
	cmp	w1, w2
	bne	.L144
	.loc 2 784 0
	cmp	w19, w1
	bcc	.L137
	.loc 2 784 0 is_stmt 0 discriminator 1
	mov	w2, 784
	adrp	x1, .LANCHOR57
.LVL211:
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR57
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL212:
	b	.L137
.LVL213:
.L138:
	add	x1, x1, 1
	.loc 2 755 0 is_stmt 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L136
.LVL214:
.L137:
	.loc 2 786 0
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL215:
.L141:
	.cfi_restore_state
	.loc 2 765 0
	ldr	w4, [x3]
	tbnz	w4, #31, .L140
	.loc 2 766 0
	cmp	w5, w4
	bls	.L140
	mov	w5, w4
.LVL216:
	mov	w19, w1
.LVL217:
.L140:
	.loc 2 764 0 discriminator 2
	add	w1, w1, 1
.LVL218:
	add	x3, x3, 16
	and	w1, w1, 65535
.LVL219:
	b	.L139
.LVL220:
.L144:
	.loc 2 779 0
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L143
	.loc 2 779 0 is_stmt 0 discriminator 1
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
.LVL221:
	csel	w19, w19, w1, eq
.LVL222:
.L143:
	.loc 2 778 0 is_stmt 1 discriminator 2
	add	w1, w1, 1
.LVL223:
	add	x0, x0, 16
	and	w1, w1, 65535
.LVL224:
	b	.L142
	.cfi_endproc
.LFE260:
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
.LFB266:
	.loc 2 931 0
	.cfi_startproc
.LVL225:
	.loc 2 934 0
	adrp	x2, .LANCHOR58
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR58]
	cmp	w1, 4
	bhi	.L147
	.loc 2 934 0 is_stmt 0 discriminator 1
	cbnz	w0, .L147
	.loc 2 934 0
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR58]
	.loc 2 943 0 is_stmt 1
	ret
.L147:
.LBB207:
.LBB208:
	.loc 2 937 0
	adrp	x1, .LANCHOR5
.LBE208:
.LBE207:
	.loc 2 936 0
	adrp	x0, .LANCHOR59
.LVL226:
	.loc 2 935 0
	strh	wzr, [x3, #:lo12:.LANCHOR58]
.LBB211:
.LBB209:
	.loc 2 939 0
	mov	w2, 0
	.loc 2 937 0
	ldrh	w5, [x1, #:lo12:.LANCHOR5]
	.loc 2 939 0
	adrp	x1, .LANCHOR42
.LBE209:
.LBE211:
	.loc 2 936 0
	str	wzr, [x0, #:lo12:.LANCHOR59]
.LVL227:
.LBB212:
.LBB210:
	.loc 2 939 0
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR42]
	mov	w7, 65535
	mov	x1, 0
.L148:
.LVL228:
	.loc 2 937 0
	cmp	w5, w1, uxth
	bhi	.L150
	cbz	w3, .L146
	str	w2, [x0, #:lo12:.LANCHOR59]
.L146:
	ret
.L150:
	.loc 2 939 0
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L149
	.loc 2 940 0
	add	w2, w2, w4
	mov	w3, 1
.L149:
.LVL229:
	add	x1, x1, 1
.LVL230:
	b	.L148
.LBE210:
.LBE212:
	.cfi_endproc
.LFE266:
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
.LFB272:
	.loc 2 1396 0
	.cfi_startproc
.LVL231:
	.loc 2 1396 0
	and	w0, w0, 65535
	.loc 2 1397 0
	cbz	w1, .L157
	b	ftl_set_blk_mode.part.6
.LVL232:
.L157:
	.loc 2 1400 0
	adrp	x1, .LANCHOR1
.LVL233:
	ubfx	x2, x0, 5, 11
	lsl	x2, x2, 2
	ldr	x3, [x1, #:lo12:.LANCHOR1]
	mov	w1, 1
	lsl	w0, w1, w0
	ldr	w1, [x3, x2]
	bic	w0, w1, w0
	str	w0, [x3, x2]
	ret
	.cfi_endproc
.LFE272:
	.size	ftl_set_blk_mode, .-ftl_set_blk_mode
	.section	.text.ftl_get_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_get_blk_mode
	.type	ftl_get_blk_mode, %function
ftl_get_blk_mode:
.LFB273:
	.loc 2 1404 0
	.cfi_startproc
.LVL234:
	.loc 2 1404 0
	and	w1, w0, 65535
	.loc 2 1405 0
	adrp	x0, .LANCHOR1
.LVL235:
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	ubfx	x2, x1, 5, 11
	ldr	w0, [x0, x2, lsl 2]
	lsr	w0, w0, w1
	.loc 2 1406 0
	and	w0, w0, 1
	ret
	.cfi_endproc
.LFE273:
	.size	ftl_get_blk_mode, .-ftl_get_blk_mode
	.section	.text.ftl_sb_update_avl_pages,"ax",@progbits
	.align	2
	.global	ftl_sb_update_avl_pages
	.type	ftl_sb_update_avl_pages, %function
ftl_sb_update_avl_pages:
.LFB279:
	.loc 2 1657 0
	.cfi_startproc
.LVL236:
	.loc 2 1657 0
	and	w2, w2, 65535
	and	w6, w1, 65535
	ubfiz	x4, x2, 1, 16
	.loc 2 1660 0
	adrp	x1, .LANCHOR3
.LVL237:
	add	x4, x4, 16
	.loc 2 1659 0
	strh	wzr, [x0, 4]
.LVL238:
	add	x4, x0, x4
	.loc 2 1660 0
	ldrh	w3, [x1, #:lo12:.LANCHOR3]
	.loc 2 1662 0
	mov	w1, 65535
.LVL239:
.L160:
	.loc 2 1660 0 discriminator 1
	cmp	w2, w3
	bcc	.L162
	.loc 2 1671 0
	adrp	x1, .LANCHOR19
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
.LVL240:
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	add	x3, x0, x3
	.loc 2 1669 0
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	.loc 2 1671 0
	sub	w1, w1, w6
.L163:
	.loc 2 1667 0 discriminator 1
	cmp	x2, x3
	bne	.L165
	.loc 2 1674 0
	ret
.LVL241:
.L162:
	.loc 2 1662 0
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L161
	.loc 2 1664 0
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L161:
	.loc 2 1660 0 discriminator 2
	add	w2, w2, 1
.LVL242:
	add	x4, x4, 2
	and	w2, w2, 65535
.LVL243:
	b	.L160
.LVL244:
.L165:
	.loc 2 1669 0
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L164
	.loc 2 1671 0
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L164:
	add	x2, x2, 2
	b	.L163
	.cfi_endproc
.LFE279:
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
.LFB282:
	.loc 2 2062 0
	.cfi_startproc
.LVL245:
	.loc 2 2065 0
	ldrh	w1, [x0, 4]
	cbz	w1, .L166
	.loc 2 2067 0
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L166
.LVL246:
.LBB215:
.LBB216:
	.loc 2 2069 0
	ldrb	w2, [x0, 6]
	add	x2, x2, 8
	ldrh	w3, [x0, x2, lsl 1]
.LVL247:
	.loc 2 2072 0
	adrp	x2, .LANCHOR3
	ldrh	w4, [x2, #:lo12:.LANCHOR3]
	.loc 2 2070 0
	mov	w2, w1
.L169:
	cmp	w3, w2
	beq	.L171
.LVL248:
.L166:
	ret
.LVL249:
.L171:
	.loc 2 2071 0
	ldrb	w1, [x0, 6]
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x0, 6]
	.loc 2 2072 0
	cmp	w1, w4
	bne	.L170
	.loc 2 2073 0
	ldrh	w1, [x0, 2]
	.loc 2 2074 0
	strb	wzr, [x0, 6]
	.loc 2 2073 0
	add	w1, w1, 1
	strh	w1, [x0, 2]
.L170:
	.loc 2 2076 0
	ldrb	w1, [x0, 6]
	add	x1, x1, 8
	ldrh	w3, [x0, x1, lsl 1]
.LVL250:
	b	.L169
.LBE216:
.LBE215:
	.cfi_endproc
.LFE282:
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.make_superblock,"ax",@progbits
	.align	2
	.global	make_superblock
	.type	make_superblock, %function
make_superblock:
.LFB284:
	.loc 2 2094 0
	.cfi_startproc
.LVL251:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2097 0
	ldrh	w1, [x0]
	.loc 2 2094 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2094 0
	mov	x19, x0
	.loc 2 2097 0
	adrp	x0, .LANCHOR5
.LVL252:
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcc	.L173
	.loc 2 2097 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR60
	adrp	x0, .LC1
	mov	w2, 2097
	add	x1, x1, :lo12:.LANCHOR60
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL253:
.L173:
	.loc 2 2100 0 is_stmt 1
	adrp	x0, .LANCHOR3
	.loc 2 2101 0
	adrp	x7, .LANCHOR13
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR13
	.loc 2 2100 0
	ldrh	w8, [x0, #:lo12:.LANCHOR3]
	mov	x5, 0
	.loc 2 2098 0
	strh	wzr, [x19, 4]
	.loc 2 2102 0
	mov	w10, -1
	.loc 2 2099 0
	strb	wzr, [x19, 7]
.LVL254:
.L174:
	.loc 2 2100 0 discriminator 1
	cmp	w8, w5, uxth
	bhi	.L176
	.loc 2 2110 0
	adrp	x1, .LANCHOR19
	ldrb	w0, [x19, 7]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	.loc 2 2111 0
	mov	w0, 1
	strb	w0, [x19, 9]
	.loc 2 2113 0
	mov	w0, 0
	ldr	x19, [sp, 16]
.LVL255:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL256:
.L176:
	.cfi_restore_state
	.loc 2 2101 0
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
.LVL257:
	mov	w4, w0
.LVL258:
	.loc 2 2102 0
	strh	w10, [x6]
	.loc 2 2103 0
	bl	FtlBbmIsBadBlock
.LVL259:
	cbnz	w0, .L175
	.loc 2 2104 0
	strh	w4, [x6]
	.loc 2 2105 0
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L175:
.LVL260:
	add	x5, x5, 1
.LVL261:
	add	x6, x6, 2
	b	.L174
	.cfi_endproc
.LFE284:
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",@progbits
	.align	2
	.global	update_multiplier_value
	.type	update_multiplier_value, %function
update_multiplier_value:
.LFB293:
	.loc 2 2454 0
	.cfi_startproc
.LVL262:
	and	w6, w0, 65535
	.loc 2 2458 0
	adrp	x0, .LANCHOR3
.LVL263:
	mov	x7, 0
	.loc 2 2459 0
	adrp	x8, .LANCHOR13
	.loc 2 2458 0
	ldrh	w10, [x0, #:lo12:.LANCHOR3]
	.loc 2 2461 0
	adrp	x0, .LANCHOR19
	.loc 2 2456 0
	mov	w5, 0
	.loc 2 2459 0
	add	x8, x8, :lo12:.LANCHOR13
.LVL264:
	.loc 2 2461 0
	ldrh	w11, [x0, #:lo12:.LANCHOR19]
	.loc 2 2458 0
	cmp	w10, w7, uxth
	bhi	.L190
	.loc 2 2463 0
	cbz	w5, .L188
	.loc 2 2464 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL265:
.L189:
	.loc 2 2465 0
	adrp	x0, .LANCHOR40
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	umaddl	x6, w6, w1, x0
.LVL266:
	.loc 2 2467 0
	mov	w0, 0
	.loc 2 2465 0
	strh	w5, [x6, 4]
	.loc 2 2467 0
	ret
.LVL267:
.L183:
	.cfi_def_cfa 29, 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	w5, 0
.LVL268:
	b	.L182
.LVL269:
.L188:
	.cfi_def_cfa 31, 0
	.cfi_restore 29
	.cfi_restore 30
	mov	w5, 0
	b	.L189
.L190:
	.loc 2 2454 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.L181:
	.loc 2 2459 0
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
.LVL270:
	.loc 2 2460 0
	bl	FtlBbmIsBadBlock
.LVL271:
	cbnz	w0, .L180
	.loc 2 2461 0
	add	w5, w5, w11
.LVL272:
	and	w5, w5, 65535
.LVL273:
.L180:
	add	x7, x7, 1
.LVL274:
	.loc 2 2458 0 discriminator 2
	cmp	w10, w7, uxth
	bhi	.L181
	.loc 2 2463 0
	cbz	w5, .L183
	.loc 2 2464 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL275:
.L182:
	.loc 2 2465 0
	adrp	x0, .LANCHOR40
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	umaddl	x6, w6, w1, x0
	.loc 2 2467 0
	mov	w0, 0
	.loc 2 2465 0
	strh	w5, [x6, 4]
	.loc 2 2467 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE293:
	.size	update_multiplier_value, .-update_multiplier_value
	.section	.text.GetFreeBlockMinEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMinEraseCount
	.type	GetFreeBlockMinEraseCount, %function
GetFreeBlockMinEraseCount:
.LFB294:
	.loc 2 2470 0
	.cfi_startproc
.LVL276:
	.loc 2 2473 0
	adrp	x0, .LANCHOR47
	ldr	x0, [x0, #:lo12:.LANCHOR47]
	cbz	x0, .L193
	.loc 2 2474 0
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
.LVL277:
	ret
.LVL278:
.L193:
	.loc 2 2471 0
	mov	w0, 0
.LVL279:
	.loc 2 2476 0
	ret
	.cfi_endproc
.LFE294:
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMaxEraseCount
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
.LFB295:
	.loc 2 2479 0
	.cfi_startproc
.LVL280:
	.loc 2 2484 0
	adrp	x1, .LANCHOR47
	.loc 2 2479 0
	and	w0, w0, 65535
	.loc 2 2484 0
	ldr	x1, [x1, #:lo12:.LANCHOR47]
	cbz	x1, .L201
	.loc 2 2485 0
	adrp	x2, .LANCHOR48
	mov	w3, 7
	.loc 2 2489 0
	mov	w5, 6
	mov	w6, 65535
	.loc 2 2485 0
	ldrh	w2, [x2, #:lo12:.LANCHOR48]
	mul	w2, w2, w3
	asr	w2, w2, 3
	.loc 2 2486 0
	cmp	w0, w2
	csel	w0, w2, w0, gt
.LVL281:
	.loc 2 2487 0
	adrp	x2, .LANCHOR40
	ldr	x3, [x2, #:lo12:.LANCHOR40]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	.loc 2 2488 0
	mov	w2, 0
	.loc 2 2487 0
	and	w1, w1, 65535
.LVL282:
.L197:
	.loc 2 2488 0 discriminator 1
	cmp	w0, w2
	beq	.L200
	.loc 2 2489 0
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L198
.L200:
	.loc 2 2493 0
	adrp	x0, .LANCHOR43
.LVL283:
	ubfiz	x1, x1, 1, 16
.LVL284:
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x0, x1]
.LVL285:
	ret
.LVL286:
.L198:
	.loc 2 2488 0 discriminator 2
	add	w2, w2, 1
.LVL287:
	mov	w1, w4
	and	w2, w2, 65535
.LVL288:
	b	.L197
.LVL289:
.L201:
	.loc 2 2480 0
	mov	w0, 0
.LVL290:
	.loc 2 2496 0
	ret
	.cfi_endproc
.LFE295:
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.FtlPrintInfo2buf,"ax",@progbits
	.align	2
	.global	FtlPrintInfo2buf
	.type	FtlPrintInfo2buf, %function
FtlPrintInfo2buf:
.LFB200:
	.loc 3 12 0
	.cfi_startproc
.LVL291:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 3 16 0
	adrp	x1, .LC2
	add	x1, x1, :lo12:.LC2
	.loc 3 12 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 3 31 0
	adrp	x19, .LANCHOR37
	.loc 3 12 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
.LVL292:
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 3 32 0
	adrp	x23, .LANCHOR48
	.loc 3 12 0
	stp	x25, x26, [sp, 64]
	.loc 3 39 0
	adrp	x22, .LANCHOR39
	.loc 3 12 0
	str	x27, [sp, 80]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.loc 3 16 0
	bl	sprintf
.LVL293:
	add	x20, x21, x0, sxtw
.LVL294:
	.loc 3 17 0
	adrp	x0, .LANCHOR26
	adrp	x1, .LC3
	add	x1, x1, :lo12:.LC3
	ldr	w2, [x0, #:lo12:.LANCHOR26]
	mov	x0, x20
	.loc 3 39 0
	add	x22, x22, :lo12:.LANCHOR39
	.loc 3 50 0
	adrp	x24, .LANCHOR51
	.loc 3 67 0
	adrp	x25, .LANCHOR80
	.loc 3 17 0
	bl	sprintf
.LVL295:
	add	x20, x20, x0, sxtw
.LVL296:
	.loc 3 18 0
	mov	x0, x20
	adrp	x1, .LC4
	add	x1, x1, :lo12:.LC4
	bl	sprintf
.LVL297:
	add	x20, x20, x0, sxtw
.LVL298:
	.loc 3 19 0
	adrp	x0, .LANCHOR61
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	ldr	w2, [x0, #:lo12:.LANCHOR61]
	mov	x0, x20
	bl	sprintf
.LVL299:
	add	x20, x20, x0, sxtw
.LVL300:
	.loc 3 20 0
	adrp	x0, .LANCHOR59
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	ldr	w2, [x0, #:lo12:.LANCHOR59]
	mov	x0, x20
	bl	sprintf
.LVL301:
	add	x20, x20, x0, sxtw
.LVL302:
	.loc 3 21 0
	adrp	x0, .LANCHOR62
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	mov	x0, x20
	bl	sprintf
.LVL303:
	add	x20, x20, x0, sxtw
.LVL304:
	.loc 3 22 0
	adrp	x0, .LANCHOR63
	adrp	x1, .LC8
	add	x1, x1, :lo12:.LC8
	ldr	w2, [x0, #:lo12:.LANCHOR63]
	mov	x0, x20
	bl	sprintf
.LVL305:
	add	x20, x20, x0, sxtw
.LVL306:
	.loc 3 23 0
	adrp	x0, .LANCHOR64
	adrp	x1, .LC9
	add	x1, x1, :lo12:.LC9
	ldr	w2, [x0, #:lo12:.LANCHOR64]
	mov	x0, x20
	bl	sprintf
.LVL307:
	add	x20, x20, x0, sxtw
.LVL308:
	.loc 3 24 0
	adrp	x0, .LANCHOR65
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	ldr	w2, [x0, #:lo12:.LANCHOR65]
	mov	x0, x20
	bl	sprintf
.LVL309:
	add	x20, x20, x0, sxtw
.LVL310:
	.loc 3 25 0
	adrp	x0, .LANCHOR66
	adrp	x1, .LC11
	add	x1, x1, :lo12:.LC11
	ldr	w2, [x0, #:lo12:.LANCHOR66]
	mov	x0, x20
	bl	sprintf
.LVL311:
	add	x20, x20, x0, sxtw
.LVL312:
	.loc 3 26 0
	adrp	x0, .LANCHOR67
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	ldr	w2, [x0, #:lo12:.LANCHOR67]
	mov	x0, x20
	bl	sprintf
.LVL313:
	add	x20, x20, x0, sxtw
.LVL314:
	.loc 3 27 0
	adrp	x0, .LANCHOR68
	adrp	x1, .LC13
	add	x1, x1, :lo12:.LC13
	ldr	w2, [x0, #:lo12:.LANCHOR68]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
.LVL315:
	add	x20, x20, x0, sxtw
.LVL316:
	.loc 3 28 0
	adrp	x0, .LANCHOR69
	adrp	x1, .LC14
	add	x1, x1, :lo12:.LC14
	ldr	w2, [x0, #:lo12:.LANCHOR69]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
.LVL317:
	add	x20, x20, x0, sxtw
.LVL318:
	.loc 3 29 0
	adrp	x0, .LANCHOR70
	adrp	x1, .LC15
	add	x1, x1, :lo12:.LC15
	ldr	w2, [x0, #:lo12:.LANCHOR70]
	mov	x0, x20
	bl	sprintf
.LVL319:
	add	x20, x20, x0, sxtw
.LVL320:
	.loc 3 30 0
	adrp	x0, .LANCHOR71
	adrp	x1, .LC16
	add	x1, x1, :lo12:.LC16
	ldr	w2, [x0, #:lo12:.LANCHOR71]
	mov	x0, x20
	bl	sprintf
.LVL321:
	add	x20, x20, x0, sxtw
.LVL322:
	.loc 3 31 0
	add	x0, x19, :lo12:.LANCHOR37
	adrp	x1, .LC17
	add	x1, x1, :lo12:.LC17
	ldrh	w2, [x0, 6]
	mov	x0, x20
	bl	sprintf
.LVL323:
	add	x20, x20, x0, sxtw
.LVL324:
	.loc 3 32 0
	ldrh	w2, [x23, #:lo12:.LANCHOR48]
	mov	x0, x20
	adrp	x1, .LC18
	add	x1, x1, :lo12:.LC18
	bl	sprintf
.LVL325:
	add	x20, x20, x0, sxtw
.LVL326:
	.loc 3 33 0
	adrp	x0, .LANCHOR72
	adrp	x1, .LC19
	add	x1, x1, :lo12:.LC19
	ldr	w2, [x0, #:lo12:.LANCHOR72]
	mov	x0, x20
	bl	sprintf
.LVL327:
	add	x20, x20, x0, sxtw
.LVL328:
	.loc 3 34 0
	adrp	x0, .LANCHOR73
	adrp	x1, .LC20
	add	x1, x1, :lo12:.LC20
	ldr	w2, [x0, #:lo12:.LANCHOR73]
	mov	x0, x20
	bl	sprintf
.LVL329:
	add	x20, x20, x0, sxtw
.LVL330:
	.loc 3 35 0
	adrp	x0, .LANCHOR74
	adrp	x1, .LC21
	add	x1, x1, :lo12:.LC21
	ldr	w2, [x0, #:lo12:.LANCHOR74]
	mov	x0, x20
	bl	sprintf
.LVL331:
	add	x20, x20, x0, sxtw
.LVL332:
	.loc 3 36 0
	adrp	x0, .LANCHOR75
	adrp	x1, .LC22
	add	x1, x1, :lo12:.LC22
	ldr	w2, [x0, #:lo12:.LANCHOR75]
	mov	x0, x20
	bl	sprintf
.LVL333:
	add	x20, x20, x0, sxtw
.LVL334:
	.loc 3 37 0
	adrp	x0, .LANCHOR76
	adrp	x1, .LC23
	add	x1, x1, :lo12:.LC23
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	mov	x0, x20
	bl	sprintf
.LVL335:
	add	x20, x20, x0, sxtw
.LVL336:
	.loc 3 38 0
	adrp	x0, .LANCHOR77
	adrp	x1, .LC24
	add	x1, x1, :lo12:.LC24
	ldr	w2, [x0, #:lo12:.LANCHOR77]
	mov	x0, x20
	bl	sprintf
.LVL337:
	add	x20, x20, x0, sxtw
.LVL338:
	.loc 3 39 0
	ldrh	w2, [x22, 30]
	mov	x0, x20
	adrp	x1, .LC25
	add	x1, x1, :lo12:.LC25
	bl	sprintf
.LVL339:
	add	x20, x20, x0, sxtw
.LVL340:
	.loc 3 40 0
	ldrh	w2, [x22, 28]
	mov	x0, x20
	adrp	x1, .LC26
	add	x1, x1, :lo12:.LC26
	.loc 3 55 0
	adrp	x22, .LANCHOR42
	.loc 3 40 0
	bl	sprintf
.LVL341:
	add	x20, x20, x0, sxtw
.LVL342:
	.loc 3 41 0
	adrp	x0, .LANCHOR34
	adrp	x1, .LC27
	add	x1, x1, :lo12:.LC27
	ldr	w2, [x0, #:lo12:.LANCHOR34]
	mov	x0, x20
	bl	sprintf
.LVL343:
	add	x20, x20, x0, sxtw
.LVL344:
	.loc 3 42 0
	adrp	x0, .LANCHOR31
	adrp	x1, .LC28
	add	x1, x1, :lo12:.LC28
	ldr	w2, [x0, #:lo12:.LANCHOR31]
	mov	x0, x20
	bl	sprintf
.LVL345:
	add	x20, x20, x0, sxtw
.LVL346:
	.loc 3 43 0
	adrp	x0, .LANCHOR2
	adrp	x1, .LC29
	add	x1, x1, :lo12:.LC29
	ldr	w2, [x0, #:lo12:.LANCHOR2]
	mov	x0, x20
	bl	sprintf
.LVL347:
	add	x20, x20, x0, sxtw
.LVL348:
	.loc 3 44 0
	adrp	x0, .LANCHOR38+6
	adrp	x1, .LC30
	add	x1, x1, :lo12:.LC30
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	mov	x0, x20
	bl	sprintf
.LVL349:
	add	x20, x20, x0, sxtw
.LVL350:
	.loc 3 45 0
	adrp	x0, .LANCHOR5
	adrp	x1, .LC31
	add	x1, x1, :lo12:.LC31
	ldrh	w2, [x0, #:lo12:.LANCHOR5]
	mov	x0, x20
	bl	sprintf
.LVL351:
	add	x20, x20, x0, sxtw
.LVL352:
	.loc 3 46 0
	adrp	x0, .LANCHOR78
	adrp	x1, .LC32
	add	x1, x1, :lo12:.LC32
	ldrh	w2, [x0, #:lo12:.LANCHOR78]
	mov	x0, x20
	bl	sprintf
.LVL353:
	add	x20, x20, x0, sxtw
.LVL354:
	.loc 3 47 0
	adrp	x0, .LANCHOR7
	adrp	x1, .LC33
	add	x1, x1, :lo12:.LC33
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	mov	x0, x20
	bl	sprintf
.LVL355:
	add	x20, x20, x0, sxtw
.LVL356:
	.loc 3 48 0
	adrp	x0, .LANCHOR79
	adrp	x1, .LC34
	add	x1, x1, :lo12:.LC34
	ldrh	w2, [x0, #:lo12:.LANCHOR79]
	mov	x0, x20
	bl	sprintf
.LVL357:
	add	x20, x20, x0, sxtw
.LVL358:
	.loc 3 49 0
	ldrh	w2, [x19, #:lo12:.LANCHOR37]
	.loc 3 50 0
	add	x19, x24, :lo12:.LANCHOR51
	.loc 3 49 0
	mov	x0, x20
	adrp	x1, .LC35
	add	x1, x1, :lo12:.LC35
	bl	sprintf
.LVL359:
	add	x20, x20, x0, sxtw
.LVL360:
	.loc 3 50 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	bl	sprintf
.LVL361:
	add	x20, x20, x0, sxtw
.LVL362:
	.loc 3 51 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC37
	add	x1, x1, :lo12:.LC37
	bl	sprintf
.LVL363:
	add	x20, x20, x0, sxtw
.LVL364:
	.loc 3 52 0
	ldrh	w2, [x24, #:lo12:.LANCHOR51]
	mov	x0, x20
	adrp	x1, .LC38
	add	x1, x1, :lo12:.LC38
	bl	sprintf
.LVL365:
	add	x20, x20, x0, sxtw
.LVL366:
	.loc 3 53 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC39
	add	x1, x1, :lo12:.LC39
	bl	sprintf
.LVL367:
	add	x20, x20, x0, sxtw
.LVL368:
	.loc 3 54 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC40
	add	x1, x1, :lo12:.LC40
	bl	sprintf
.LVL369:
	add	x20, x20, x0, sxtw
.LVL370:
	.loc 3 55 0
	ldrh	w1, [x24, #:lo12:.LANCHOR51]
	.loc 3 56 0
	adrp	x24, .LANCHOR52
	.loc 3 55 0
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	.loc 3 56 0
	add	x19, x24, :lo12:.LANCHOR52
	.loc 3 55 0
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC41
	add	x1, x1, :lo12:.LC41
	bl	sprintf
.LVL371:
	add	x20, x20, x0, sxtw
.LVL372:
	.loc 3 56 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC42
	add	x1, x1, :lo12:.LC42
	bl	sprintf
.LVL373:
	add	x20, x20, x0, sxtw
.LVL374:
	.loc 3 57 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC43
	add	x1, x1, :lo12:.LC43
	bl	sprintf
.LVL375:
	add	x20, x20, x0, sxtw
.LVL376:
	.loc 3 58 0
	ldrh	w2, [x24, #:lo12:.LANCHOR52]
	mov	x0, x20
	adrp	x1, .LC44
	add	x1, x1, :lo12:.LC44
	bl	sprintf
.LVL377:
	add	x20, x20, x0, sxtw
.LVL378:
	.loc 3 59 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC45
	add	x1, x1, :lo12:.LC45
	bl	sprintf
.LVL379:
	add	x20, x20, x0, sxtw
.LVL380:
	.loc 3 60 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC46
	add	x1, x1, :lo12:.LC46
	bl	sprintf
.LVL381:
	add	x20, x20, x0, sxtw
.LVL382:
	.loc 3 61 0
	ldrh	w1, [x24, #:lo12:.LANCHOR52]
	.loc 3 62 0
	adrp	x24, .LANCHOR53
	.loc 3 61 0
	ldr	x0, [x22, #:lo12:.LANCHOR42]
	.loc 3 62 0
	add	x19, x24, :lo12:.LANCHOR53
	.loc 3 61 0
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC47
	add	x1, x1, :lo12:.LC47
	bl	sprintf
.LVL383:
	add	x20, x20, x0, sxtw
.LVL384:
	.loc 3 62 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC48
	add	x1, x1, :lo12:.LC48
	bl	sprintf
.LVL385:
	add	x20, x20, x0, sxtw
.LVL386:
	.loc 3 63 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC49
	add	x1, x1, :lo12:.LC49
	bl	sprintf
.LVL387:
	add	x20, x20, x0, sxtw
.LVL388:
	.loc 3 64 0
	ldrh	w2, [x24, #:lo12:.LANCHOR53]
	mov	x0, x20
	adrp	x1, .LC50
	add	x1, x1, :lo12:.LC50
	.loc 3 72 0
	adrp	x24, .LANCHOR81
	add	x24, x24, :lo12:.LANCHOR81
	.loc 3 64 0
	bl	sprintf
.LVL389:
	add	x20, x20, x0, sxtw
.LVL390:
	.loc 3 65 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC51
	add	x1, x1, :lo12:.LC51
	bl	sprintf
.LVL391:
	add	x20, x20, x0, sxtw
.LVL392:
	.loc 3 66 0
	ldrh	w2, [x19, 4]
	.loc 3 67 0
	add	x19, x25, :lo12:.LANCHOR80
	.loc 3 66 0
	mov	x0, x20
	adrp	x1, .LC52
	add	x1, x1, :lo12:.LC52
	bl	sprintf
.LVL393:
	add	x20, x20, x0, sxtw
.LVL394:
	.loc 3 67 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC53
	add	x1, x1, :lo12:.LC53
	bl	sprintf
.LVL395:
	add	x20, x20, x0, sxtw
.LVL396:
	.loc 3 68 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC54
	add	x1, x1, :lo12:.LC54
	bl	sprintf
.LVL397:
	add	x20, x20, x0, sxtw
.LVL398:
	.loc 3 69 0
	ldrh	w2, [x25, #:lo12:.LANCHOR80]
	mov	x0, x20
	adrp	x1, .LC55
	add	x1, x1, :lo12:.LC55
	bl	sprintf
.LVL399:
	add	x20, x20, x0, sxtw
.LVL400:
	.loc 3 70 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC56
	add	x1, x1, :lo12:.LC56
	bl	sprintf
.LVL401:
	add	x20, x20, x0, sxtw
.LVL402:
	.loc 3 71 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC57
	add	x1, x1, :lo12:.LC57
	bl	sprintf
.LVL403:
	add	x20, x20, x0, sxtw
.LVL404:
	.loc 3 72 0
	ldp	w4, w2, [x24, 76]
	adrp	x1, .LC58
	ldr	w3, [x24, 84]
	add	x1, x1, :lo12:.LC58
	mov	x0, x20
	bl	sprintf
.LVL405:
	add	x19, x20, x0, sxtw
.LVL406:
	.loc 3 73 0
	ldr	w2, [x24, 72]
	mov	x0, x19
	adrp	x1, .LC59
	add	x1, x1, :lo12:.LC59
	bl	sprintf
.LVL407:
	add	x19, x19, x0, sxtw
.LVL408:
	.loc 3 74 0
	ldr	w2, [x24, 96]
	mov	x0, x19
	adrp	x1, .LC60
	add	x1, x1, :lo12:.LC60
	bl	sprintf
.LVL409:
	add	x19, x19, x0, sxtw
.LVL410:
	.loc 3 75 0
	adrp	x0, .LANCHOR82
	adrp	x1, .LC61
	add	x1, x1, :lo12:.LC61
	ldrh	w2, [x0, #:lo12:.LANCHOR82]
	mov	x0, x19
	bl	sprintf
.LVL411:
	add	x19, x19, x0, sxtw
.LVL412:
	.loc 3 76 0
	adrp	x0, .LANCHOR83
	adrp	x1, .LC62
	add	x1, x1, :lo12:.LC62
	ldrh	w2, [x0, #:lo12:.LANCHOR83]
	mov	x0, x19
	bl	sprintf
.LVL413:
	add	x19, x19, x0, sxtw
.LVL414:
	.loc 3 77 0
	adrp	x0, .LANCHOR84
	adrp	x1, .LC63
	add	x1, x1, :lo12:.LC63
	ldr	w2, [x0, #:lo12:.LANCHOR84]
	mov	x0, x19
	bl	sprintf
.LVL415:
	add	x19, x19, x0, sxtw
.LVL416:
	.loc 3 78 0
	adrp	x0, .LANCHOR85
	adrp	x1, .LC64
	add	x1, x1, :lo12:.LC64
	ldrh	w2, [x0, #:lo12:.LANCHOR85]
	mov	x0, x19
	bl	sprintf
.LVL417:
	add	x19, x19, x0, sxtw
.LVL418:
	.loc 3 79 0
	bl	GetFreeBlockMinEraseCount
.LVL419:
	and	w2, w0, 65535
	adrp	x1, .LC65
	mov	x0, x19
	add	x1, x1, :lo12:.LC65
	bl	sprintf
.LVL420:
	add	x19, x19, x0, sxtw
.LVL421:
	.loc 3 80 0
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	bl	GetFreeBlockMaxEraseCount
.LVL422:
	and	w2, w0, 65535
	adrp	x1, .LC66
	mov	x0, x19
	add	x1, x1, :lo12:.LC66
	bl	sprintf
.LVL423:
	add	x19, x19, x0, sxtw
.LVL424:
	.loc 3 81 0
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmp	w0, 1
	beq	.L203
.L208:
	.loc 3 104 0
	sub	w0, w19, w21
	.loc 3 105 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
.LVL425:
	ldp	x21, x22, [sp, 32]
.LVL426:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL427:
.L203:
	.cfi_restore_state
	.loc 3 84 0
	ldrh	w0, [x25, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L205
	.loc 3 85 0
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	ldrh	w2, [x1, x0]
	mov	x0, x19
	adrp	x1, .LC67
	add	x1, x1, :lo12:.LC67
	bl	sprintf
.LVL428:
	add	x19, x19, x0, sxtw
.LVL429:
.L205:
.LBB217:
	.loc 3 87 0
	mov	w0, 0
	.loc 3 91 0
	adrp	x24, .LC68
	.loc 3 87 0
	bl	List_get_gc_head_node
.LVL430:
	.loc 3 91 0
	add	x24, x24, :lo12:.LC68
	.loc 3 87 0
	and	w3, w0, 65535
.LVL431:
	.loc 3 88 0
	mov	w23, 0
	.loc 3 89 0
	mov	w27, 65535
	adrp	x20, .LANCHOR40
	.loc 3 91 0
	mov	w26, 6
.LVL432:
.L207:
	.loc 3 89 0
	cmp	w3, w27
	beq	.L206
	.loc 3 91 0 discriminator 2
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
	.loc 3 88 0 discriminator 2
	add	w23, w23, 1
.LVL433:
	.loc 3 91 0 discriminator 2
	bl	sprintf
.LVL434:
	add	x19, x19, x0, sxtw
.LVL435:
	.loc 3 92 0 discriminator 2
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	.loc 3 88 0 discriminator 2
	cmp	w23, 16
	.loc 3 92 0 discriminator 2
	ldrh	w3, [x0, x25]
.LVL436:
	.loc 3 88 0 discriminator 2
	bne	.L207
.L206:
.LBE217:
.LBB218:
	.loc 3 96 0
	adrp	x0, .LANCHOR47
	.loc 3 100 0
	adrp	x23, .LC69
.LVL437:
	add	x23, x23, :lo12:.LC69
	.loc 3 97 0
	mov	w22, 0
	.loc 3 96 0
	ldr	x3, [x0, #:lo12:.LANCHOR47]
.LVL438:
	.loc 3 98 0
	mov	w25, 65535
	.loc 3 96 0
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	.loc 3 100 0
	mov	w26, 6
	adrp	x27, .LANCHOR43
	.loc 3 96 0
	sub	x3, x3, x0
	mov	x0, -6148914691236517206
	asr	x3, x3, 1
	movk	x0, 0xaaab, lsl 0
	mul	x3, x3, x0
	and	w3, w3, 65535
.LVL439:
.L209:
	.loc 3 98 0
	cmp	w3, w25
	beq	.L208
	.loc 3 100 0 discriminator 2
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
	.loc 3 97 0 discriminator 2
	add	w22, w22, 1
.LVL440:
	.loc 3 100 0 discriminator 2
	bl	sprintf
.LVL441:
	add	x19, x19, x0, sxtw
.LVL442:
	.loc 3 97 0 discriminator 2
	cmp	w22, 4
	beq	.L208
	.loc 3 101 0
	ldr	x0, [x20, #:lo12:.LANCHOR40]
	ldrh	w3, [x0, x24]
	b	.L209
.LBE218:
	.cfi_endproc
.LFE200:
	.size	FtlPrintInfo2buf, .-FtlPrintInfo2buf
	.section	.text.rknand_proc_ftlread,"ax",@progbits
	.align	2
	.global	rknand_proc_ftlread
	.type	rknand_proc_ftlread, %function
rknand_proc_ftlread:
.LFB201:
	.loc 3 114 0
	.cfi_startproc
.LVL443:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 3 120 0
	adrp	x2, .LC70
	adrp	x1, .LC71
	add	x2, x2, :lo12:.LC70
	.loc 3 114 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 120 0
	add	x1, x1, :lo12:.LC71
	.loc 3 114 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 3 114 0
	mov	x20, x0
.LVL444:
	.loc 3 120 0
	bl	sprintf
.LVL445:
	add	x19, x20, x0, sxtw
.LVL446:
	.loc 3 122 0
	mov	x0, x19
	bl	FtlPrintInfo2buf
.LVL447:
	add	x0, x19, x0, sxtw
.LVL448:
	.loc 3 124 0
	sub	w0, w0, w20
.LVL449:
	ldp	x19, x20, [sp, 16]
.LVL450:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE201:
	.size	rknand_proc_ftlread, .-rknand_proc_ftlread
	.section	.text.GetSwlReplaceBlock,"ax",@progbits
	.align	2
	.global	GetSwlReplaceBlock
	.type	GetSwlReplaceBlock, %function
GetSwlReplaceBlock:
.LFB296:
	.loc 2 2500 0
	.cfi_startproc
.LVL451:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2510 0
	adrp	x2, .LANCHOR74
	adrp	x8, .LANCHOR77
	.loc 2 2500 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2510 0
	ldr	w3, [x2, #:lo12:.LANCHOR74]
	ldr	w7, [x8, #:lo12:.LANCHOR77]
	cmp	w3, w7
	bcs	.L218
	.loc 2 2513 0
	adrp	x1, .LANCHOR5
	.loc 2 2512 0
	adrp	x0, .LANCHOR72
	.loc 2 2513 0
	mov	w5, 0
	mov	w4, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR5]
	.loc 2 2514 0
	adrp	x1, .LANCHOR43
	.loc 2 2512 0
	str	wzr, [x0, #:lo12:.LANCHOR72]
.LVL452:
	.loc 2 2514 0
	ldr	x6, [x1, #:lo12:.LANCHOR43]
	.loc 2 2513 0
	mov	x1, 0
.LVL453:
.L219:
	.loc 2 2513 0 is_stmt 0 discriminator 1
	cmp	w3, w1
	bhi	.L220
	cbz	w5, .L221
	str	w4, [x0, #:lo12:.LANCHOR72]
.L221:
	.loc 2 2515 0 is_stmt 1
	ldr	w1, [x0, #:lo12:.LANCHOR72]
.LVL454:
	udiv	w3, w1, w3
	str	w3, [x2, #:lo12:.LANCHOR74]
	.loc 2 2516 0
	adrp	x3, .LANCHOR73
	ldr	w3, [x3, #:lo12:.LANCHOR73]
	sub	w1, w1, w3
	adrp	x3, .LANCHOR14
	ldrh	w3, [x3, #:lo12:.LANCHOR14]
	udiv	w1, w1, w3
	str	w1, [x0, #:lo12:.LANCHOR72]
.L222:
	.loc 2 2522 0
	ldr	w10, [x2, #:lo12:.LANCHOR74]
	add	w0, w7, 256
	cmp	w0, w10
	bls	.L227
	.loc 2 2522 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR76
	add	w0, w7, 768
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cmp	w0, w1
	bls	.L227
.LVL455:
.L229:
	.loc 2 2523 0 is_stmt 1
	mov	w19, 65535
.L228:
	.loc 2 2569 0
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL456:
.L220:
	.cfi_restore_state
	.loc 2 2514 0 discriminator 3
	ldrh	w5, [x6, x1, lsl 1]
	add	x1, x1, 1
.LVL457:
	add	w4, w4, w5
	mov	w5, 1
	b	.L219
.L218:
	.loc 2 2517 0
	adrp	x1, .LANCHOR76
	ldr	w0, [x1, #:lo12:.LANCHOR76]
	cmp	w3, w0
	bls	.L222
	.loc 2 2518 0
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
.LVL458:
	.loc 2 2520 0
	adrp	x0, .LANCHOR43
	.loc 2 2519 0
	adrp	x1, .LANCHOR5
	add	x1, x1, :lo12:.LANCHOR5
	.loc 2 2520 0
	ldr	x4, [x0, #:lo12:.LANCHOR43]
	.loc 2 2519 0
	mov	w0, 0
.LVL459:
.L224:
	.loc 2 2519 0 is_stmt 0 discriminator 1
	ldrh	w3, [x1]
	cmp	w0, w3
	bcs	.L222
	.loc 2 2520 0 is_stmt 1 discriminator 3
	ubfiz	x5, x0, 1, 32
	.loc 2 2519 0 discriminator 3
	add	w0, w0, 1
.LVL460:
	.loc 2 2520 0 discriminator 3
	ldrh	w3, [x4, x5]
	add	w3, w3, 1
	strh	w3, [x4, x5]
	b	.L224
.LVL461:
.L227:
	.loc 2 2525 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w0, lsl 1
	lsr	w0, w0, 2
	bl	GetFreeBlockMaxEraseCount
.LVL462:
	and	w6, w0, 65535
.LVL463:
	.loc 2 2526 0
	add	w0, w7, 64
.LVL464:
	cmp	w6, w0
	bcc	.L229
	.loc 2 2529 0
	adrp	x0, .LANCHOR41
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	cbz	x0, .L229
	.loc 2 2533 0
	adrp	x1, .LANCHOR5
	.loc 2 2537 0
	mov	w3, 65535
	.loc 2 2536 0
	mov	x14, -6148914691236517206
	.loc 2 2537 0
	mov	w2, w3
	.loc 2 2533 0
	ldrh	w13, [x1, #:lo12:.LANCHOR5]
	.loc 2 2536 0
	adrp	x1, .LANCHOR40
	.loc 2 2531 0
	mov	w12, w3
	.loc 2 2536 0
	movk	x14, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR40]
	.loc 2 2537 0
	adrp	x1, .LANCHOR43
	.loc 2 2546 0
	mov	w15, 6
	.loc 2 2537 0
	ldr	x4, [x1, #:lo12:.LANCHOR43]
	mov	w1, 0
.LVL465:
.L230:
	.loc 2 2531 0
	ldrh	w5, [x0]
	cmp	w5, w12
	bne	.L233
	mov	w19, w2
.LVL466:
.L232:
	.loc 2 2549 0
	mov	w0, 65535
	cmp	w19, w0
	beq	.L229
	.loc 2 2551 0
	ubfiz	x2, x19, 1, 32
	ldrh	w5, [x4, x2]
.LVL467:
	.loc 2 2552 0
	cmp	w7, w5
	bcs	.L234
	.loc 2 2554 0
	bl	GetFreeBlockMinEraseCount
.LVL468:
	cmp	w7, w0, uxth
	bcs	.L234
	.loc 2 2555 0
	str	w3, [x8, #:lo12:.LANCHOR77]
.L234:
	.loc 2 2557 0
	cmp	w10, w5
	bls	.L229
	.loc 2 2557 0 is_stmt 0 discriminator 1
	add	w0, w5, 128
	cmp	w6, w0
	ble	.L229
	.loc 2 2559 0 is_stmt 1
	add	w0, w5, 256
	adrp	x1, .LANCHOR76
	cmp	w10, w0
	bhi	.L235
	.loc 2 2559 0 is_stmt 0 discriminator 1
	ldr	w3, [x1, #:lo12:.LANCHOR76]
.LVL469:
	add	w0, w5, 768
	cmp	w0, w3
	bcs	.L229
.L235:
	.loc 2 2561 0 is_stmt 1
	adrp	x0, .LANCHOR42
	ldr	w3, [x1, #:lo12:.LANCHOR76]
	mov	w1, w19
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w4, [x0, x2]
	mov	w2, w10
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
.LVL470:
	.loc 2 2562 0
	adrp	x0, .LANCHOR87
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR87]
	.loc 2 2563 0
	b	.L228
.LVL471:
.L233:
	.loc 2 2532 0
	add	w1, w1, 1
.LVL472:
	and	w1, w1, 65535
.LVL473:
	.loc 2 2533 0
	cmp	w1, w13
	bhi	.L229
	.loc 2 2535 0
	ldrh	w16, [x0, 4]
	cbz	w16, .L231
	.loc 2 2536 0
	sub	x0, x0, x11
.LVL474:
	asr	x0, x0, 1
	mul	x0, x0, x14
	and	w19, w0, 65535
.LVL475:
	.loc 2 2537 0
	and	x0, x0, 65535
	ldrh	w0, [x4, x0, lsl 1]
	cmp	w7, w0
	bcs	.L232
	.loc 2 2541 0
	cmp	w3, w0
	bls	.L231
	mov	w3, w0
.LVL476:
	.loc 2 2536 0
	mov	w2, w19
.LVL477:
.L231:
	.loc 2 2546 0
	umaddl	x0, w5, w15, x11
.LVL478:
	b	.L230
	.cfi_endproc
.LFE296:
	.size	GetSwlReplaceBlock, .-GetSwlReplaceBlock
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
.LFB297:
	.loc 2 2573 0
	.cfi_startproc
.LVL479:
	and	w0, w0, 65535
	.loc 2 2574 0
	mov	w1, 65535
	cmp	w0, w1
	beq	.L249
.LVL480:
	.loc 2 2573 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
.LBB221:
.LBB222:
	.loc 2 2576 0
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
.LBE222:
.LBE221:
	.loc 2 2573 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.LBB224:
.LBB223:
	.loc 2 2576 0
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	strh	wzr, [x2, x1]
	.loc 2 2577 0
	bl	INSERT_FREE_LIST
.LVL481:
.LBE223:
.LBE224:
	.loc 2 2579 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL482:
.L249:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE297:
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.get_new_active_ppa,"ax",@progbits
	.align	2
	.global	get_new_active_ppa
	.type	get_new_active_ppa, %function
get_new_active_ppa:
.LFB300:
	.loc 2 2706 0
	.cfi_startproc
.LVL483:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	.loc 2 2710 0
	ldrh	w1, [x0]
	mov	w0, 65535
.LVL484:
	.loc 2 2706 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2710 0
	cmp	w1, w0
	bne	.L253
	.loc 2 2710 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2710
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL485:
.L253:
	.loc 2 2711 0 is_stmt 1
	adrp	x20, .LANCHOR19
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bne	.L254
	.loc 2 2711 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2711
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL486:
.L254:
	.loc 2 2712 0 is_stmt 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L255
	.loc 2 2712 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2712
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL487:
.L255:
	.loc 2 2714 0 is_stmt 1
	ldrb	w0, [x19, 6]
	.loc 2 2717 0
	adrp	x1, .LANCHOR3
	.loc 2 2713 0
	strb	wzr, [x19, 10]
	.loc 2 2714 0
	add	x0, x0, 8
	.loc 2 2717 0
	ldrh	w2, [x1, #:lo12:.LANCHOR3]
	.loc 2 2715 0
	mov	w1, 65535
	.loc 2 2714 0
	ldrh	w0, [x19, x0, lsl 1]
.LVL488:
.L256:
	.loc 2 2715 0
	cmp	w0, w1
	beq	.L258
	.loc 2 2723 0
	ldrh	w21, [x19, 2]
	.loc 2 2731 0
	mov	w3, 65535
	.loc 2 2724 0
	ldrh	w1, [x19, 4]
	.loc 2 2723 0
	orr	w21, w21, w0, lsl 10
.LVL489:
	ldrb	w0, [x19, 6]
.LVL490:
	.loc 2 2724 0
	sub	w1, w1, #1
	and	w1, w1, 65535
	strh	w1, [x19, 4]
.L260:
	.loc 2 2726 0
	add	w0, w0, 1
	and	w0, w0, 255
	.loc 2 2727 0
	cmp	w2, w0
	bne	.L259
	.loc 2 2728 0
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 2729 0
	mov	w0, 0
.L259:
	.loc 2 2731 0
	add	x4, x19, x0, sxtw 1
	ldrh	w4, [x4, 16]
	cmp	w4, w3
	beq	.L260
	strb	w0, [x19, 6]
	.loc 2 2733 0
	ldrh	w2, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w2, w0
	bne	.L252
	.loc 2 2733 0 is_stmt 0 discriminator 1
	cbz	w1, .L252
	.loc 2 2733 0 discriminator 2
	adrp	x1, .LANCHOR88
	adrp	x0, .LC1
	mov	w2, 2733
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL491:
.L252:
	.loc 2 2735 0 is_stmt 1
	mov	w0, w21
	ldr	x21, [sp, 32]
.LVL492:
	ldp	x19, x20, [sp, 16]
.LVL493:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL494:
.L258:
	.cfi_restore_state
	.loc 2 2716 0
	ldrb	w0, [x19, 6]
.LVL495:
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	.loc 2 2717 0
	cmp	w0, w2
	bne	.L257
	.loc 2 2718 0
	ldrh	w0, [x19, 2]
	.loc 2 2719 0
	strb	wzr, [x19, 6]
	.loc 2 2718 0
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L257:
	.loc 2 2721 0
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
.LVL496:
	b	.L256
	.cfi_endproc
.LFE300:
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlGcBufInit,"ax",@progbits
	.align	2
	.global	FtlGcBufInit
	.type	FtlGcBufInit, %function
FtlGcBufInit:
.LFB303:
	.file 5 "drivers/rkflash/rksftl/sftl_gc.c"
	.loc 5 22 0
	.cfi_startproc
	.loc 5 27 0
	adrp	x1, .LANCHOR90
	.loc 5 25 0
	adrp	x0, .LANCHOR89
	.loc 5 28 0
	adrp	x7, .LANCHOR91
	.loc 5 29 0
	adrp	x6, .LANCHOR92
	.loc 5 27 0
	ldr	x5, [x1, #:lo12:.LANCHOR90]
	.loc 5 28 0
	adrp	x1, .LANCHOR23
	.loc 5 25 0
	str	wzr, [x0, #:lo12:.LANCHOR89]
.LVL497:
	.loc 5 26 0
	adrp	x0, .LANCHOR3
	.loc 5 28 0
	ldrh	w10, [x1, #:lo12:.LANCHOR23]
	.loc 5 29 0
	adrp	x1, .LANCHOR24
	.loc 5 26 0
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	w8, 24
	.loc 5 29 0
	ldrh	w11, [x1, #:lo12:.LANCHOR24]
	.loc 5 30 0
	adrp	x1, .LANCHOR93
	.loc 5 28 0
	ldr	x14, [x7, #:lo12:.LANCHOR91]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR93]
	.loc 5 26 0
	mov	w2, 0
	.loc 5 29 0
	ldr	x15, [x6, #:lo12:.LANCHOR92]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	.loc 5 26 0
	mov	w1, 0
	.loc 5 27 0
	mov	w16, 1
.LVL498:
.L268:
	add	w13, w2, w10
	add	w12, w1, w11
	.loc 5 26 0 discriminator 1
	cmp	x3, x8
	bne	.L269
	.loc 5 34 0
	adrp	x1, .LANCHOR94
	.loc 5 36 0
	ldr	x7, [x7, #:lo12:.LANCHOR91]
	.loc 5 37 0
	ldr	x6, [x6, #:lo12:.LANCHOR92]
	.loc 5 35 0
	mov	w8, 24
	.loc 5 34 0
	ldr	w4, [x1, #:lo12:.LANCHOR94]
.L270:
.LVL499:
	.loc 5 34 0 is_stmt 0 discriminator 1
	cmp	w0, w4
	bcc	.L271
	.loc 5 39 0 is_stmt 1
	ret
.LVL500:
.L269:
	.loc 5 28 0 discriminator 3
	asr	w2, w2, 2
	.loc 5 29 0 discriminator 3
	asr	w1, w1, 2
	.loc 5 28 0 discriminator 3
	add	x2, x14, x2, sxtw 2
	.loc 5 29 0 discriminator 3
	add	x1, x15, x1, sxtw 2
	.loc 5 27 0 discriminator 3
	str	w16, [x3, 16]
	.loc 5 29 0 discriminator 3
	stp	x2, x1, [x3]
	add	x3, x3, 24
	.loc 5 31 0 discriminator 3
	stp	x2, x1, [x4]
	add	x4, x4, 32
	mov	w1, w12
	mov	w2, w13
	b	.L268
.LVL501:
.L271:
	.loc 5 35 0 discriminator 3
	umull	x3, w0, w8
	.loc 5 36 0 discriminator 3
	mul	w1, w10, w0
	.loc 5 35 0 discriminator 3
	add	x2, x5, x3
	.loc 5 36 0 discriminator 3
	asr	w1, w1, 2
	add	x1, x7, x1, sxtw 2
	.loc 5 35 0 discriminator 3
	str	wzr, [x2, 16]
	.loc 5 36 0 discriminator 3
	str	x1, [x5, x3]
	.loc 5 37 0 discriminator 3
	mul	w1, w11, w0
	.loc 5 34 0 discriminator 3
	add	w0, w0, 1
.LVL502:
	and	w0, w0, 65535
.LVL503:
	.loc 5 37 0 discriminator 3
	asr	w1, w1, 2
	add	x1, x6, x1, sxtw 2
	str	x1, [x2, 8]
	b	.L270
	.cfi_endproc
.LFE303:
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",@progbits
	.align	2
	.global	FtlGcBufFree
	.type	FtlGcBufFree, %function
FtlGcBufFree:
.LFB304:
	.loc 5 42 0
	.cfi_startproc
.LVL504:
	.loc 5 47 0
	adrp	x2, .LANCHOR94
	.loc 5 46 0
	mov	w3, 0
	.loc 5 48 0
	mov	w8, 24
	.loc 5 47 0
	ldr	w7, [x2, #:lo12:.LANCHOR94]
	.loc 5 48 0
	adrp	x2, .LANCHOR90
	ldr	x5, [x2, #:lo12:.LANCHOR90]
.LVL505:
.L273:
	.loc 5 46 0 discriminator 1
	cmp	w3, w1
	bcs	.L272
	.loc 5 48 0
	ubfiz	x4, x3, 5, 16
	mov	w2, 0
	add	x4, x0, x4
	b	.L278
.LVL506:
.L274:
	.loc 5 47 0 discriminator 2
	add	w2, w2, 1
.LVL507:
	and	w2, w2, 65535
.LVL508:
.L278:
	.loc 5 47 0 is_stmt 0 discriminator 1
	cmp	w2, w7
	bcs	.L275
	.loc 5 48 0 is_stmt 1
	umull	x6, w2, w8
	add	x10, x5, x6
	ldr	x11, [x5, x6]
	ldr	x6, [x4, 8]
	cmp	x11, x6
	bne	.L274
	.loc 5 49 0
	str	wzr, [x10, 16]
.L275:
	.loc 5 46 0 discriminator 2
	add	w3, w3, 1
.LVL509:
	and	w3, w3, 65535
.LVL510:
	b	.L273
.LVL511:
.L272:
	ret
	.cfi_endproc
.LFE304:
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",@progbits
	.align	2
	.global	FtlGcBufAlloc
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
.LFB305:
	.loc 5 57 0
	.cfi_startproc
.LVL512:
	.loc 5 62 0
	adrp	x2, .LANCHOR94
	.loc 5 61 0
	mov	w3, 0
	.loc 5 63 0
	mov	w7, 24
	.loc 5 64 0
	mov	w8, 1
	.loc 5 62 0
	ldr	w5, [x2, #:lo12:.LANCHOR94]
	.loc 5 63 0
	adrp	x2, .LANCHOR90
	ldr	x6, [x2, #:lo12:.LANCHOR90]
.LVL513:
.L280:
	.loc 5 61 0 discriminator 1
	cmp	w3, w1
	bcs	.L279
	mov	w2, 0
	b	.L285
.LVL514:
.L281:
	.loc 5 62 0 discriminator 2
	add	w2, w2, 1
.LVL515:
	and	w2, w2, 65535
.LVL516:
.L285:
	.loc 5 62 0 is_stmt 0 discriminator 1
	cmp	w2, w5
	bcs	.L282
	.loc 5 63 0 is_stmt 1
	umaddl	x4, w2, w7, x6
	ldr	w10, [x4, 16]
	cbnz	w10, .L281
	.loc 5 65 0
	ubfiz	x2, x3, 5, 16
.LVL517:
	ldr	x10, [x4]
	add	x2, x0, x2
	.loc 5 64 0
	str	w8, [x4, 16]
	.loc 5 66 0
	ldr	x4, [x4, 8]
	stp	x10, x4, [x2, 8]
.L282:
	.loc 5 61 0 discriminator 2
	add	w3, w3, 1
.LVL518:
	and	w3, w3, 65535
.LVL519:
	b	.L280
.L279:
	ret
	.cfi_endproc
.LFE305:
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",@progbits
	.align	2
	.global	IsBlkInGcList
	.type	IsBlkInGcList, %function
IsBlkInGcList:
.LFB306:
	.loc 5 74 0
	.cfi_startproc
.LVL520:
	.loc 5 77 0
	adrp	x1, .LANCHOR95
	.loc 5 74 0
	and	w0, w0, 65535
	.loc 5 77 0
	ldrh	w2, [x1, #:lo12:.LANCHOR95]
	.loc 5 78 0
	adrp	x1, .LANCHOR96
	ldr	x3, [x1, #:lo12:.LANCHOR96]
	.loc 5 77 0
	mov	x1, 0
.LVL521:
.L287:
	.loc 5 77 0 is_stmt 0 discriminator 1
	cmp	w2, w1, uxth
	bhi	.L289
	.loc 5 81 0 is_stmt 1
	mov	w0, 0
.LVL522:
	ret
.L289:
	add	x1, x1, 1
.LVL523:
	.loc 5 78 0
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L287
	.loc 5 79 0
	mov	w0, 1
	.loc 5 82 0
	ret
	.cfi_endproc
.LFE306:
	.size	IsBlkInGcList, .-IsBlkInGcList
	.section	.text.FtlGcUpdatePage,"ax",@progbits
	.align	2
	.global	FtlGcUpdatePage
	.type	FtlGcUpdatePage, %function
FtlGcUpdatePage:
.LFB307:
	.loc 5 85 0
	.cfi_startproc
.LVL524:
	mov	w6, w0
	mov	w10, w1
	mov	w8, w2
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 5 88 0
	lsr	w0, w0, 10
.LVL525:
	.loc 5 85 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 5 88 0
	bl	P2V_block_in_plane
.LVL526:
	and	w7, w0, 65535
.LVL527:
	.loc 5 91 0
	adrp	x4, .LANCHOR95
	.loc 5 92 0
	adrp	x2, .LANCHOR96
	.loc 5 91 0
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR95]
	.loc 5 92 0
	ldr	x5, [x2, #:lo12:.LANCHOR96]
.LVL528:
.L292:
	and	w2, w3, 65535
.LVL529:
	.loc 5 91 0 discriminator 1
	cmp	w2, w1
	bcc	.L294
	.loc 5 96 0
	bne	.L293
	.loc 5 97 0
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	.loc 5 98 0
	ldrh	w0, [x4, #:lo12:.LANCHOR95]
.LVL530:
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR95]
.LVL531:
	b	.L293
.LVL532:
.L294:
	add	x3, x3, 1
	.loc 5 92 0
	add	x2, x5, x3, lsl 1
.LVL533:
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L292
.LVL534:
.L293:
	.loc 5 101 0
	adrp	x4, .LANCHOR97
	adrp	x1, .LANCHOR98
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR97]
	ldr	x5, [x1, #:lo12:.LANCHOR98]
	umull	x3, w0, w3
	.loc 5 107 0
	add	w0, w0, 1
	.loc 5 101 0
	add	x7, x5, x3
.LVL535:
	.loc 5 102 0
	stp	w10, w8, [x7, 4]
	.loc 5 103 0
	str	w6, [x5, x3]
	.loc 5 107 0
	strh	w0, [x4, #:lo12:.LANCHOR97]
	.loc 5 108 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE307:
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
.LFB314:
	.loc 5 345 0
	.cfi_startproc
.LVL536:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 5 345 0
	and	w19, w0, 65535
	.loc 5 347 0
	mov	w1, w19
	adrp	x0, .LC73
.LVL537:
	add	x0, x0, :lo12:.LC73
	bl	printf
.LVL538:
	.loc 5 349 0
	adrp	x3, .LANCHOR99
	ldrh	w4, [x3, #:lo12:.LANCHOR99]
	cmp	w19, w4
	beq	.L297
	.loc 5 349 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR100
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w19, w2
	beq	.L297
	.loc 5 351 0 is_stmt 1
	mov	w1, 65535
	cmp	w4, w1
	bne	.L298
	.loc 5 352 0
	strh	w19, [x3, #:lo12:.LANCHOR99]
.L297:
	.loc 5 356 0
	mov	w0, 0
	ldr	x19, [sp, 16]
.LVL539:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.L298:
	.cfi_restore_state
	.loc 5 353 0
	cmp	w2, w1
	bne	.L297
	.loc 5 354 0
	strh	w19, [x0, #:lo12:.LANCHOR100]
	b	.L297
	.cfi_endproc
.LFE314:
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",@progbits
	.align	2
	.global	FtlGcMarkBadPhyBlk
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
.LFB315:
	.loc 5 359 0
	.cfi_startproc
.LVL540:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	and	w20, w0, 65535
	.loc 5 364 0
	adrp	x19, .LANCHOR101
	.loc 5 359 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 5 361 0
	mov	w0, w20
.LVL541:
	bl	P2V_block_in_plane
.LVL542:
	.loc 5 364 0
	ldrh	w1, [x19, #:lo12:.LANCHOR101]
	mov	w2, w20
	.loc 5 361 0
	mov	w21, w0
.LVL543:
	.loc 5 364 0
	adrp	x0, .LC74
.LVL544:
	add	x0, x0, :lo12:.LC74
	bl	printf
.LVL545:
	.loc 5 366 0
	mov	w0, w21
	bl	FtlGcRefreshBlock
.LVL546:
	.loc 5 368 0
	ldrh	w0, [x19, #:lo12:.LANCHOR101]
	.loc 5 369 0
	adrp	x2, .LANCHOR102
	add	x2, x2, :lo12:.LANCHOR102
	.loc 5 368 0
	mov	x1, 0
.LVL547:
.L301:
	.loc 5 368 0 is_stmt 0 discriminator 1
	cmp	w0, w1, uxth
	bhi	.L303
	.loc 5 372 0 is_stmt 1
	cmp	w0, 15
	bhi	.L302
	.loc 5 373 0
	add	w1, w0, 1
.LVL548:
	strh	w1, [x19, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR102
	add	x1, x1, :lo12:.LANCHOR102
	strh	w20, [x1, w0, sxtw 1]
	b	.L302
.LVL549:
.L303:
	add	x1, x1, 1
.LVL550:
	.loc 5 369 0
	add	x3, x2, x1, lsl 1
	ldrh	w3, [x3, -2]
	cmp	w3, w20
	bne	.L301
.L302:
	.loc 5 375 0
	mov	w0, 0
	ldr	x21, [sp, 32]
.LVL551:
	ldp	x19, x20, [sp, 16]
.LVL552:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE315:
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
.LFB316:
	.loc 5 379 0
	.cfi_startproc
	.loc 5 380 0
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L312
	.loc 5 380 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR99
	ldrh	w2, [x1, #:lo12:.LANCHOR99]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L312
	.loc 5 379 0 is_stmt 1
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 5 381 0
	adrp	x19, .LANCHOR103
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	cmp	w1, w0
	bcc	.L307
	.loc 5 382 0
	strh	wzr, [x19, #:lo12:.LANCHOR103]
.L307:
.LBB227:
.LBB228:
	.loc 5 383 0
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	adrp	x0, .LANCHOR102
	add	x0, x0, :lo12:.LANCHOR102
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
.LVL553:
	bl	FtlGcRefreshBlock
.LVL554:
	.loc 5 384 0
	ldrh	w0, [x19, #:lo12:.LANCHOR103]
	add	w0, w0, 1
	strh	w0, [x19, #:lo12:.LANCHOR103]
.LBE228:
.LBE227:
	.loc 5 387 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.L312:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE316:
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.ftl_free,"ax",@progbits
	.align	2
	.global	ftl_free
	.type	ftl_free, %function
ftl_free:
.LFB337:
	.loc 1 24 0
	.cfi_startproc
.LVL555:
.LBB229:
.LBB230:
	.file 6 "include/linux/compat.h"
	.loc 6 80 0
	b	free
.LVL556:
.LBE230:
.LBE229:
	.cfi_endproc
.LFE337:
	.size	ftl_free, .-ftl_free
	.section	.text.ftl_malloc,"ax",@progbits
	.align	2
	.global	ftl_malloc
	.type	ftl_malloc, %function
ftl_malloc:
.LFB338:
	.loc 1 28 0
	.cfi_startproc
.LVL557:
	.loc 1 29 0
	mov	w1, 0
	sxtw	x0, w0
	b	kmalloc
.LVL558:
	.cfi_endproc
.LFE338:
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.rknand_print_hex,"ax",@progbits
	.align	2
	.global	rknand_print_hex
	.type	rknand_print_hex, %function
rknand_print_hex:
.LFB339:
	.loc 1 33 0
	.cfi_startproc
.LVL559:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x22, x1
.LVL560:
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 1 42 0
	adrp	x24, .LC75
	.loc 1 33 0
	stp	x25, x26, [sp, 64]
	mov	w23, w2
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	.loc 1 49 0
	adrp	x25, .LC77
	.loc 1 33 0
	mov	x28, x0
	mov	w27, w3
	.loc 1 42 0
	add	x24, x24, :lo12:.LC75
	.loc 1 49 0
	add	x25, x25, :lo12:.LC77
	.loc 1 33 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 1 40 0
	mov	w21, 0
	mov	x19, 0
	.loc 1 39 0
	mov	w20, 0
	.loc 1 47 0
	adrp	x26, .LC76
.LVL561:
.L318:
	.loc 1 40 0 discriminator 1
	cmp	w27, w19
	bhi	.L324
	.loc 1 56 0
	ldp	x19, x20, [sp, 16]
.LVL562:
	.loc 1 55 0
	adrp	x0, .LC78
	.loc 1 56 0
	ldp	x21, x22, [sp, 32]
.LVL563:
	.loc 1 55 0
	add	x0, x0, :lo12:.LC78
	.loc 1 56 0
	ldp	x23, x24, [sp, 48]
.LVL564:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL565:
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	.loc 1 55 0
	b	printf
.LVL566:
.L324:
	.cfi_restore_state
	.loc 1 41 0
	cbnz	w20, .L319
	.loc 1 42 0
	mov	w2, w21
	mov	x1, x28
	mov	x0, x24
	bl	printf
.LVL567:
.L319:
	.loc 1 44 0
	cmp	w23, 4
	bne	.L320
	.loc 1 45 0
	ldr	w1, [x22, x19, lsl 2]
.L327:
	.loc 1 47 0
	add	x0, x26, :lo12:.LC76
.L326:
	.loc 1 49 0
	bl	printf
.LVL568:
	.loc 1 50 0
	add	w20, w20, 1
.LVL569:
	cmp	w20, 15
	bls	.L323
.LVL570:
	.loc 1 51 0
	mov	w20, 0
	.loc 1 52 0
	adrp	x0, .LC78
	add	x0, x0, :lo12:.LC78
	bl	printf
.LVL571:
.L323:
	add	x19, x19, 1
.LVL572:
	add	w21, w21, w23
	b	.L318
.LVL573:
.L320:
	.loc 1 46 0
	cmp	w23, 2
	bne	.L322
	.loc 1 47 0
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L327
.L322:
	.loc 1 49 0
	ldrb	w1, [x22, x19]
	mov	x0, x25
	b	.L326
	.cfi_endproc
.LFE339:
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.FlashReadPages,"ax",@progbits
	.align	2
	.global	FlashReadPages
	.type	FlashReadPages, %function
FlashReadPages:
.LFB341:
	.loc 1 85 0
	.cfi_startproc
.LVL574:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 1 87 0
	adrp	x2, .LANCHOR0
.LVL575:
	add	x3, x2, :lo12:.LANCHOR0
	ubfiz	x1, x1, 5, 32
.LVL576:
	.loc 1 85 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x25, [sp, 64]
	.cfi_offset 25, -32
	.loc 1 87 0
	ldrh	w25, [x3, 12]
.LVL577:
	.loc 1 85 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 1 92 0
	adrp	x21, .LANCHOR104
	.loc 1 85 0
	stp	x23, x24, [sp, 48]
	.loc 1 92 0
	adrp	x22, .LC1
	.loc 1 85 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	add	x24, x0, x1
	mov	x19, x0
	mov	x23, x2
	.loc 1 92 0
	add	x21, x21, :lo12:.LANCHOR104
	add	x22, x22, :lo12:.LC1
.LVL578:
.L329:
	.loc 1 91 0 discriminator 1
	cmp	x19, x24
	bne	.L336
	.loc 1 112 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
.LVL579:
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL580:
.L336:
	.cfi_restore_state
	.loc 1 92 0
	ldr	x0, [x19, 8]
	cbz	x0, .L330
	.loc 1 92 0 is_stmt 0 discriminator 2
	ldr	x0, [x19, 16]
	cbnz	x0, .L331
.L330:
	.loc 1 92 0 discriminator 3
	mov	w2, 92
	mov	x1, x21
	mov	x0, x22
	bl	printf
.LVL581:
.L331:
	.loc 1 93 0 is_stmt 1
	ldr	w0, [x19, 4]
	.loc 1 94 0
	adrp	x20, .LANCHOR105
	add	x20, x20, :lo12:.LANCHOR105
	.loc 1 93 0
	add	x2, x29, 88
	add	x1, x29, 92
	bl	l2p_addr_tran.isra.0
.LVL582:
	.loc 1 94 0
	ldrb	w0, [x29, 88]
	ldr	w1, [x29, 92]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x20, 24]
	blr	x4
.LVL583:
	.loc 1 98 0
	str	w0, [x19]
	.loc 1 99 0
	add	x0, x23, :lo12:.LANCHOR0
.LVL584:
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L333
	.loc 1 100 0
	ldrb	w0, [x29, 88]
	ldr	x4, [x20, 24]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 92]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w25, w1
	blr	x4
.LVL585:
	.loc 1 104 0
	cmn	w0, #1
	beq	.L334
	.loc 1 105 0 discriminator 1
	ldr	x0, [x19, 16]
.LVL586:
	.loc 1 104 0 discriminator 1
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L333
	.loc 1 105 0
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L333
	.loc 1 106 0
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L333
.L334:
	.loc 1 108 0
	mov	w0, -1
	str	w0, [x19]
.L333:
	add	x19, x19, 32
	b	.L329
	.cfi_endproc
.LFE341:
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
.LFB230:
	.loc 4 279 0
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 4 286 0
	adrp	x2, .LANCHOR107
	adrp	x0, .LANCHOR106
	add	x1, x0, :lo12:.LANCHOR106
	.loc 4 279 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 4 286 0
	ldr	x2, [x2, #:lo12:.LANCHOR107]
	.loc 4 279 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, x0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 4 291 0
	adrp	x26, .LANCHOR17
	.loc 4 279 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 4 291 0
	add	x28, x26, :lo12:.LANCHOR17
	.loc 4 279 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	adrp	x20, .LANCHOR37
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	add	x20, x20, :lo12:.LANCHOR37
	.loc 4 286 0
	str	x2, [x1, 8]
	.loc 4 287 0
	adrp	x2, .LANCHOR108
	.loc 4 289 0
	adrp	x23, .LANCHOR10
	add	x20, x20, 12
	.loc 4 287 0
	ldr	x25, [x2, #:lo12:.LANCHOR108]
	.loc 4 289 0
	add	x23, x23, :lo12:.LANCHOR10
	mov	w21, 0
	.loc 4 290 0
	mov	w27, -1
	.loc 4 287 0
	str	x25, [x1, 16]
.LVL587:
.L348:
	.loc 4 289 0 discriminator 1
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L353
	.loc 4 314 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL588:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL589:
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL590:
.L353:
	.cfi_restore_state
	.loc 4 291 0
	ldrh	w19, [x26, #:lo12:.LANCHOR17]
	.loc 4 293 0
	add	x24, x22, :lo12:.LANCHOR106
	.loc 4 290 0
	strh	w27, [x20]
	.loc 4 301 0
	mov	w3, 61664
	.loc 4 291 0
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL591:
.L349:
	.loc 4 291 0 is_stmt 0 discriminator 1
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L351
	.loc 4 292 0 is_stmt 1
	madd	w0, w0, w21, w19
	.loc 4 294 0
	mov	w2, 1
	str	w3, [x29, 108]
.LVL592:
	mov	w1, w2
	.loc 4 292 0
	lsl	w0, w0, 10
	.loc 4 293 0
	str	w0, [x24, 4]
	.loc 4 294 0
	mov	x0, x24
	bl	FlashReadPages
.LVL593:
	.loc 4 295 0
	ldr	w0, [x24]
	ldr	w3, [x29, 108]
	cmn	w0, #1
	beq	.L350
	.loc 4 301 0
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L350
	.loc 4 303 0
	strh	w19, [x20]
.L351:
	.loc 4 289 0 discriminator 2
	add	w21, w21, 1
.LVL594:
	add	x20, x20, 2
	b	.L348
.L350:
	.loc 4 291 0 discriminator 2
	sub	w19, w19, #1
.LVL595:
	and	w19, w19, 65535
.LVL596:
	b	.L349
	.cfi_endproc
.LFE230:
	.size	FtlLoadFactoryBbt, .-FtlLoadFactoryBbt
	.section	.text.FtlGetLastWrittenPage,"ax",@progbits
	.align	2
	.global	FtlGetLastWrittenPage
	.type	FtlGetLastWrittenPage, %function
FtlGetLastWrittenPage:
.LFB236:
	.loc 2 47 0
	.cfi_startproc
.LVL597:
	stp	x29, x30, [sp, -160]!
	.cfi_def_cfa_offset 160
	.cfi_offset 29, -160
	.cfi_offset 30, -152
	.loc 2 51 0
	cmp	w1, 1
	.loc 2 47 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -112
	.cfi_offset 24, -104
	mov	w23, w1
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -144
	.cfi_offset 20, -136
	.cfi_offset 21, -128
	.cfi_offset 22, -120
	.loc 2 51 0
	bne	.L359
	.loc 2 51 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR20
.LVL598:
	ldrh	w19, [x1, #:lo12:.LANCHOR20]
.L360:
.LVL599:
	.loc 2 56 0 is_stmt 1 discriminator 4
	sub	w19, w19, #1
.LVL600:
	.loc 2 53 0 discriminator 4
	adrp	x1, ftl_temp_buf
	.loc 2 56 0 discriminator 4
	sxth	w19, w19
	.loc 2 53 0 discriminator 4
	add	x1, x1, :lo12:ftl_temp_buf
	.loc 2 57 0 discriminator 4
	lsl	w21, w0, 10
	.loc 2 53 0 discriminator 4
	str	x1, [x29, 72]
	.loc 2 57 0 discriminator 4
	orr	w0, w19, w21
.LVL601:
	.loc 2 54 0 discriminator 4
	add	x1, x29, 96
	.loc 2 57 0 discriminator 4
	str	w0, [x29, 68]
	.loc 2 58 0 discriminator 4
	mov	w2, w23
	.loc 2 54 0 discriminator 4
	str	x1, [x29, 80]
.LVL602:
	.loc 2 58 0 discriminator 4
	add	x0, x29, 64
	mov	w1, 1
	bl	FlashReadPages
.LVL603:
	.loc 2 59 0 discriminator 4
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L361
	mov	w22, 0
	.loc 2 61 0
	mov	w24, 2
.LVL604:
.L362:
	.loc 2 60 0
	cmp	w22, w19
	ble	.L365
.LVL605:
.L361:
	.loc 2 73 0
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
.LVL606:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL607:
	ldp	x29, x30, [sp], 160
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL608:
.L359:
	.cfi_restore_state
	.loc 2 51 0 discriminator 2
	adrp	x1, .LANCHOR19
.LVL609:
	ldrh	w19, [x1, #:lo12:.LANCHOR19]
	b	.L360
.LVL610:
.L365:
	.loc 2 61 0
	add	w20, w22, w19
	.loc 2 63 0
	mov	w2, w23
	mov	w1, 1
	.loc 2 61 0
	sdiv	w20, w20, w24
.LVL611:
	.loc 2 62 0
	sxth	w0, w20
	orr	w0, w0, w21
	str	w0, [x29, 68]
	.loc 2 63 0
	add	x0, x29, 64
	bl	FlashReadPages
.LVL612:
	.loc 2 65 0
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L363
	.loc 2 65 0 is_stmt 0 discriminator 1
	ldr	w0, [x29, 100]
	cmn	w0, #1
	bne	.L363
	.loc 2 66 0 is_stmt 1
	sub	w19, w20, #1
.LVL613:
	sxth	w19, w19
.LVL614:
	b	.L362
.L363:
	.loc 2 68 0
	add	w20, w20, 1
.LVL615:
	sxth	w22, w20
.LVL616:
	b	.L362
	.cfi_endproc
.LFE236:
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FlashProgPages,"ax",@progbits
	.align	2
	.global	FlashProgPages
	.type	FlashProgPages, %function
FlashProgPages:
.LFB342:
	.loc 1 115 0
	.cfi_startproc
.LVL617:
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	ubfiz	x1, x1, 5, 32
.LVL618:
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	mov	w25, w2
	mov	w26, w3
	.loc 1 117 0
	adrp	x2, .LANCHOR0
.LVL619:
	add	x3, x2, :lo12:.LANCHOR0
.LVL620:
	.loc 1 115 0
	stp	x27, x28, [sp, 80]
	stp	x19, x20, [sp, 16]
	.cfi_offset 27, -64
	.cfi_offset 28, -56
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	.loc 1 121 0
	mov	x19, x0
	.loc 1 117 0
	ldrh	w27, [x3, 12]
.LVL621:
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 1 122 0
	adrp	x21, .LANCHOR109
	.loc 1 115 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	.loc 1 124 0
	adrp	x22, .LANCHOR105
	add	x24, x0, x1
	mov	x23, x2
	.loc 1 122 0
	add	x21, x21, :lo12:.LANCHOR109
	.loc 1 133 0
	add	x28, x22, :lo12:.LANCHOR105
.LVL622:
.L368:
	.loc 1 121 0 discriminator 1
	cmp	x19, x24
	bne	.L376
	.loc 1 142 0
	cbnz	w26, .L377
.LVL623:
.L395:
	.loc 1 172 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL624:
	ldp	x27, x28, [sp, 80]
.LVL625:
	ldp	x29, x30, [sp], 144
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL626:
.L376:
	.cfi_restore_state
	.loc 1 122 0
	ldr	x0, [x19, 8]
	cbz	x0, .L369
	.loc 1 122 0 is_stmt 0 discriminator 2
	ldr	x0, [x19, 16]
	cbnz	x0, .L370
.L369:
	.loc 1 122 0 discriminator 3
	adrp	x0, .LC1
	mov	w2, 122
	mov	x1, x21
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL627:
.L370:
	.loc 1 123 0 is_stmt 1
	ldr	w0, [x19, 4]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
.LVL628:
	.loc 1 124 0
	add	x0, x22, :lo12:.LANCHOR105
	ldr	w1, [x29, 108]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x0, 16]
	ldrb	w0, [x29, 104]
	blr	x4
.LVL629:
	.loc 1 129 0
	cbnz	w0, .L371
	.loc 1 128 0
	str	wzr, [x19]
.LVL630:
.L372:
	.loc 1 132 0
	add	x0, x23, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L374
	.loc 1 133 0
	ldrb	w0, [x29, 104]
	ldr	x4, [x28, 16]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 108]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w27, w1
	blr	x4
.LVL631:
	.loc 1 137 0
	cbz	w0, .L374
	.loc 1 138 0
	mov	w0, -1
.LVL632:
	str	w0, [x19]
.L374:
	add	x19, x19, 32
	b	.L368
.LVL633:
.L371:
	.loc 1 130 0
	mov	w0, -1
.LVL634:
	str	w0, [x19]
	b	.L372
.LVL635:
.L381:
.LBB231:
	.loc 1 147 0
	str	wzr, [x22]
	.loc 1 153 0
	mov	w2, w25
	.loc 1 148 0
	str	wzr, [x24]
	.loc 1 153 0
	mov	w1, 1
	.loc 1 151 0
	stp	x22, x24, [x29, 120]
	.loc 1 149 0
	ldr	w0, [x20, 4]
	str	w0, [x29, 116]
	.loc 1 153 0
	add	x0, x29, 112
	bl	FlashReadPages
.LVL636:
	.loc 1 154 0
	ldr	w26, [x29, 112]
	cmn	w26, #1
	bne	.L378
	.loc 1 155 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
.LVL637:
	.loc 1 156 0
	str	w26, [x20]
.L378:
	.loc 1 158 0
	ldr	x0, [x20, 16]
	cbz	x0, .L379
	.loc 1 159 0
	ldr	w3, [x23, #:lo12:.LANCHOR110]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L379
	.loc 1 160 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
.LVL638:
	.loc 1 161 0
	mov	w0, -1
	str	w0, [x20]
.L379:
	.loc 1 164 0
	ldr	x0, [x20, 8]
	cbz	x0, .L380
	.loc 1 165 0
	ldr	w3, [x21, #:lo12:check_buf]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L380
	.loc 1 166 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	printf
.LVL639:
	.loc 1 167 0
	mov	w0, -1
	str	w0, [x20]
.L380:
	add	x20, x20, 32
.L396:
.LBE231:
	.loc 1 144 0 discriminator 1
	cmp	x20, x19
	bne	.L381
	b	.L395
.LVL640:
.L377:
.LBB232:
	.loc 1 147 0 discriminator 1
	adrp	x21, check_buf
	.loc 1 148 0 discriminator 1
	adrp	x23, .LANCHOR110
	.loc 1 147 0 discriminator 1
	add	x22, x21, :lo12:check_buf
	.loc 1 148 0 discriminator 1
	add	x24, x23, :lo12:.LANCHOR110
	b	.L396
.LBE232:
	.cfi_endproc
.LFE342:
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FlashEraseBlocks,"ax",@progbits
	.align	2
	.global	FlashEraseBlocks
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
.LFB343:
	.loc 1 175 0
	.cfi_startproc
.LVL641:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 1 178 0
	adrp	x1, .LANCHOR0
.LVL642:
	add	x3, x1, :lo12:.LANCHOR0
	ubfiz	x2, x2, 5, 32
.LVL643:
	.loc 1 175 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	add	x2, x2, 4
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 1 178 0
	ldrh	w23, [x3, 12]
.LVL644:
	.loc 1 175 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	add	x19, x0, 4
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	x20, x1
	.loc 1 183 0
	adrp	x21, .LANCHOR105
	add	x22, x0, x2
	.loc 1 188 0
	add	x24, x21, :lo12:.LANCHOR105
.LVL645:
.L399:
	.loc 1 181 0 discriminator 1
	cmp	x19, x22
	bne	.L405
	.loc 1 194 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL646:
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL647:
.L405:
	.cfi_restore_state
	.loc 1 182 0
	ldr	w0, [x19]
	add	x2, x29, 72
	add	x1, x29, 76
	bl	l2p_addr_tran.isra.0
.LVL648:
	.loc 1 183 0
	add	x0, x21, :lo12:.LANCHOR105
	ldr	w1, [x29, 76]
	ldr	x2, [x0, 8]
	ldrb	w0, [x29, 72]
	blr	x2
.LVL649:
	.loc 1 185 0
	cbnz	w0, .L400
	.loc 1 184 0
	str	wzr, [x19, -4]
.LVL650:
.L401:
	.loc 1 187 0
	add	x0, x20, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L403
	.loc 1 188 0
	ldrb	w0, [x29, 72]
	ldr	x2, [x24, 8]
	ldr	w1, [x29, 76]
	add	w1, w23, w1
	blr	x2
.LVL651:
	.loc 1 189 0
	cbz	w0, .L403
	.loc 1 190 0
	mov	w0, -1
.LVL652:
	str	w0, [x19, -4]
.L403:
	add	x19, x19, 32
	b	.L399
.LVL653:
.L400:
	.loc 1 186 0
	mov	w0, -1
.LVL654:
	str	w0, [x19, -4]
	b	.L401
	.cfi_endproc
.LFE343:
	.size	FlashEraseBlocks, .-FlashEraseBlocks
	.section	.text.FtlFreeSysBlkQueueIn,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueIn
	.type	FtlFreeSysBlkQueueIn, %function
FtlFreeSysBlkQueueIn:
.LFB240:
	.loc 2 98 0
	.cfi_startproc
.LVL655:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	and	w20, w0, 65535
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 99 0
	sub	w2, w20, #1
	mov	w0, 65533
.LVL656:
	cmp	w0, w2, uxth
	bcc	.L410
.LBB241:
.LBB242:
	.loc 2 94 0
	adrp	x0, .LANCHOR38
	add	x2, x0, :lo12:.LANCHOR38
	mov	x19, x0
.LBE242:
.LBE241:
	.loc 2 101 0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L410
	and	w1, w1, 65535
.LVL657:
.LBB243:
.LBB244:
	.loc 2 103 0
	cbz	w1, .L412
.LBB245:
	.loc 2 104 0
	mov	w0, w20
	bl	P2V_block_in_plane
.LVL658:
	and	w21, w0, 65535
.LVL659:
	.loc 2 105 0
	adrp	x0, .LANCHOR111
.LVL660:
	lsl	w1, w20, 10
	.loc 2 106 0
	mov	w2, 1
	.loc 2 105 0
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	w1, [x0, 4]
	.loc 2 106 0
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL661:
	.loc 2 107 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	.loc 2 108 0
	adrp	x1, .LANCHOR75
	ldr	w0, [x1, #:lo12:.LANCHOR75]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR75]
.LVL662:
.L412:
.LBE245:
	.loc 2 110 0
	add	x0, x19, :lo12:.LANCHOR38
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	.loc 2 111 0
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	.loc 2 112 0
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	.loc 2 111 0
	strh	w20, [x2, 8]
.LVL663:
.L410:
.LBE244:
.LBE243:
	.loc 2 115 0
	ldp	x19, x20, [sp, 16]
.LVL664:
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE240:
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlLowFormatEraseBlock,"ax",@progbits
	.align	2
	.global	FtlLowFormatEraseBlock
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
.LFB209:
	.loc 3 528 0
	.cfi_startproc
.LVL665:
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	.loc 3 541 0
	adrp	x7, .LANCHOR13
	add	x7, x7, :lo12:.LANCHOR13
	.loc 3 539 0
	mov	x5, 0
	.loc 3 528 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	and	w24, w0, 65535
	.loc 3 538 0
	adrp	x0, .LANCHOR112
.LVL666:
	.loc 3 528 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w23, w1, 255
	.loc 3 538 0
	str	w24, [x0, #:lo12:.LANCHOR112]
.LVL667:
	.loc 3 551 0
	adrp	x0, .LANCHOR114
	.loc 3 550 0
	adrp	x1, .LANCHOR113
.LVL668:
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 3 539 0
	adrp	x20, .LANCHOR3
	.loc 3 540 0
	adrp	x21, .LANCHOR111
	.loc 3 551 0
	ldr	x11, [x0, #:lo12:.LANCHOR114]
	adrp	x0, .LANCHOR24
	.loc 3 539 0
	ldrh	w8, [x20, #:lo12:.LANCHOR3]
	.loc 3 540 0
	ldr	x6, [x21, #:lo12:.LANCHOR111]
	.loc 3 536 0
	mov	w22, 0
	.loc 3 550 0
	ldr	x10, [x1, #:lo12:.LANCHOR113]
	.loc 3 537 0
	mov	w19, 0
	.loc 3 551 0
	ldrh	w12, [x0, #:lo12:.LANCHOR24]
	.loc 3 528 0
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	.cfi_offset 27, -64
	.cfi_offset 28, -56
	stp	x0, x1, [x29, 120]
.LVL669:
.L421:
	.loc 3 539 0 discriminator 1
	cmp	w8, w5, uxth
	bhi	.L425
	.loc 3 559 0
	cbz	w22, .L420
	.loc 3 562 0
	mov	w2, w22
	ubfiz	x22, x22, 5, 16
.LVL670:
	mov	x25, 0
	mov	w1, 0
	mov	x0, x6
	bl	FlashEraseBlocks
.LVL671:
.L429:
	.loc 3 564 0
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L428
	.loc 3 566 0
	ldr	w0, [x1, 4]
	.loc 3 565 0
	add	w19, w19, 1
.LVL672:
	and	w19, w19, 65535
.LVL673:
	.loc 3 566 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL674:
.L428:
	add	x25, x25, 32
	.loc 3 563 0 discriminator 2
	cmp	x25, x22
	bne	.L429
	.loc 3 571 0
	cbz	w23, .L442
.LVL675:
	.loc 3 573 0
	adrp	x0, .LANCHOR20
	.loc 3 572 0
	mov	w25, 1
	.loc 3 573 0
	ldrh	w26, [x0, #:lo12:.LANCHOR20]
.LVL676:
	.loc 3 574 0
	lsr	w28, w26, 2
.LVL677:
.L430:
	.loc 3 578 0
	add	x0, x20, :lo12:.LANCHOR3
	.loc 3 580 0
	adrp	x27, .LANCHOR13
	.loc 3 578 0
	str	x0, [x29, 136]
	mov	w22, 0
	.loc 3 580 0
	add	x0, x27, :lo12:.LANCHOR13
	str	x0, [x29, 112]
.LVL678:
.L438:
	.loc 3 578 0
	ldr	x0, [x29, 136]
	mov	x5, 0
	.loc 3 579 0
	ldr	x6, [x21, #:lo12:.LANCHOR111]
	.loc 3 577 0
	mov	w20, 0
	.loc 3 578 0
	ldrh	w7, [x0]
	.loc 3 587 0
	adrp	x0, .LANCHOR115
	ldr	x8, [x0, #:lo12:.LANCHOR115]
	.loc 3 588 0
	ldr	x0, [x29, 128]
	ldr	x10, [x0, #:lo12:.LANCHOR113]
	ldr	x0, [x29, 120]
	ldrh	w11, [x0, #:lo12:.LANCHOR24]
.LVL679:
.L431:
	.loc 3 578 0 discriminator 1
	cmp	w7, w5, uxth
	bhi	.L434
	.loc 3 593 0
	cbz	w20, .L420
	.loc 3 596 0
	mov	w1, w20
	mov	w3, 1
	mov	w2, w25
	mov	x0, x6
	bl	FlashProgPages
.LVL680:
	mov	x27, 0
	ubfiz	x1, x20, 5, 16
.LVL681:
.L437:
	.loc 3 598 0
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x3, x0, x27
	ldr	w0, [x0, x27]
	cbz	w0, .L436
	.loc 3 600 0
	ldr	w0, [x3, 4]
	.loc 3 599 0
	add	w19, w19, 1
.LVL682:
	str	x1, [x29, 104]
	and	w19, w19, 65535
.LVL683:
	.loc 3 600 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL684:
	ldr	x1, [x29, 104]
.L436:
	add	x27, x27, 32
	.loc 3 597 0 discriminator 2
	cmp	x1, x27
	bne	.L437
	.loc 3 604 0
	add	w22, w22, w28
.LVL685:
	and	w22, w22, 65535
.LVL686:
	.loc 3 605 0
	cmp	w26, w22
	bhi	.L438
	mov	x22, 0
.LVL687:
.L440:
	.loc 3 611 0
	cbz	w23, .L439
	.loc 3 611 0 is_stmt 0 discriminator 1
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cbnz	w0, .L439
	.loc 3 612 0 is_stmt 1
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.LVL688:
.L439:
	add	x22, x22, 32
	.loc 3 610 0 discriminator 2
	cmp	x22, x27
	bne	.L440
	.loc 3 615 0
	cmp	w24, 63
	ccmp	w23, 0, 0, hi
	beq	.L420
	.loc 3 616 0
	ldr	x0, [x21, #:lo12:.LANCHOR111]
	mov	w2, w20
	mov	w1, w25
	bl	FlashEraseBlocks
.LVL689:
.L420:
	.loc 3 619 0
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
.LVL690:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL691:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL692:
.L425:
	.cfi_restore_state
	.loc 3 540 0
	lsl	x0, x5, 5
	.loc 3 541 0
	mov	w1, w24
	.loc 3 540 0
	str	wzr, [x6, x0]
	.loc 3 541 0
	ldrb	w0, [x7, x5]
	bl	V2P_block
.LVL693:
	and	w13, w0, 65535
	mov	w14, w13
.LVL694:
	.loc 3 543 0
	cbz	w23, .L422
	.loc 3 544 0
	bl	IsBlkInVendorPart
.LVL695:
	cbnz	w0, .L423
.L422:
	.loc 3 548 0
	mov	w0, w14
	bl	FtlBbmIsBadBlock
.LVL696:
	cbnz	w0, .L424
	.loc 3 549 0
	ubfiz	x0, x22, 5, 16
	.loc 3 551 0
	mul	w1, w22, w12
	.loc 3 549 0
	add	x0, x6, x0
	.loc 3 552 0
	add	w22, w22, 1
.LVL697:
	and	w22, w22, 65535
.LVL698:
	.loc 3 549 0
	lsl	w13, w13, 10
.LVL699:
	.loc 3 551 0
	asr	w1, w1, 2
	add	x1, x11, x1, sxtw 2
	.loc 3 549 0
	str	w13, [x0, 4]
	.loc 3 551 0
	stp	x10, x1, [x0, 8]
.L423:
.LVL700:
	add	x5, x5, 1
.LVL701:
	b	.L421
.LVL702:
.L424:
	.loc 3 554 0
	add	w19, w19, 1
.LVL703:
	and	w19, w19, 65535
.LVL704:
	b	.L423
.LVL705:
.L442:
	.loc 3 534 0
	mov	w25, 0
	.loc 3 533 0
	mov	w28, 6
	.loc 3 531 0
	mov	w26, 1
	b	.L430
.LVL706:
.L434:
	.loc 3 579 0
	lsl	x0, x5, 5
	.loc 3 580 0
	mov	w1, w24
	.loc 3 579 0
	str	wzr, [x6, x0]
	.loc 3 580 0
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, x5]
	bl	V2P_block
.LVL707:
	and	w12, w0, 65535
	mov	w13, w12
.LVL708:
	.loc 3 581 0
	cbz	w23, .L432
	.loc 3 582 0
	bl	IsBlkInVendorPart
.LVL709:
	cbnz	w0, .L433
.L432:
	.loc 3 585 0
	mov	w0, w13
	bl	FtlBbmIsBadBlock
.LVL710:
	cbnz	w0, .L433
	.loc 3 586 0
	ubfiz	x0, x20, 5, 16
	.loc 3 588 0
	mul	w1, w20, w11
	.loc 3 586 0
	add	x0, x6, x0
	.loc 3 589 0
	add	w20, w20, 1
.LVL711:
	and	w20, w20, 65535
.LVL712:
	.loc 3 586 0
	add	w12, w22, w12, lsl 10
.LVL713:
	.loc 3 588 0
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	.loc 3 586 0
	str	w12, [x0, 4]
	.loc 3 588 0
	stp	x8, x1, [x0, 8]
.L433:
.LVL714:
	add	x5, x5, 1
.LVL715:
	b	.L431
	.cfi_endproc
.LFE209:
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
.LFB243:
	.loc 2 181 0
	.cfi_startproc
.LVL716:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
.LBB246:
.LBB247:
	.loc 2 89 0
	adrp	x19, .LANCHOR38
.LBE247:
.LBE246:
	.loc 2 181 0
	stp	x21, x22, [sp, 32]
.LBB250:
.LBB248:
	.loc 2 89 0
	add	x19, x19, :lo12:.LANCHOR38
	.cfi_offset 21, -32
	.cfi_offset 22, -24
.LBE248:
.LBE250:
.LBB251:
	.loc 2 195 0
	adrp	x21, .LANCHOR75
.LBE251:
	.loc 2 181 0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
.LBB252:
	.loc 2 195 0
	add	x21, x21, :lo12:.LANCHOR75
.LBE252:
	.loc 2 203 0
	adrp	x23, .LC83
	add	x23, x23, :lo12:.LC83
.LVL717:
.L464:
.LBB253:
.LBB249:
	.loc 2 89 0
	ldrh	w1, [x19, 6]
.LBE249:
.LBE253:
	.loc 2 186 0
	cbz	w1, .L465
	.loc 2 187 0
	ldrh	w0, [x19, 2]
	.loc 2 188 0
	sub	w1, w1, #1
	strh	w1, [x19, 6]
	.loc 2 187 0
	add	x2, x19, x0, sxtw 1
	.loc 2 189 0
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x19, 2]
	.loc 2 187 0
	ldrh	w20, [x2, 8]
.LVL718:
.LBB254:
	.loc 2 191 0
	mov	w0, w20
	bl	P2V_block_in_plane
.LVL719:
	and	w22, w0, 65535
.LVL720:
	.loc 2 192 0
	adrp	x0, .LANCHOR111
.LVL721:
	lsl	w1, w20, 10
	.loc 2 193 0
	mov	w2, 1
	.loc 2 192 0
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	str	w1, [x0, 4]
	.loc 2 193 0
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL722:
	.loc 2 194 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x22, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	.loc 2 195 0
	ldr	w0, [x21]
.LBE254:
	.loc 2 202 0
	sub	w1, w20, #1
.LBB255:
	.loc 2 195 0
	add	w0, w0, 1
	str	w0, [x21]
.LBE255:
	.loc 2 202 0
	mov	w0, 65533
	cmp	w0, w1, uxth
	bcc	.L466
	.loc 2 208 0
	mov	w0, w20
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
.LVL723:
	ldp	x21, x22, [sp, 32]
.LVL724:
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL725:
.L465:
	.cfi_restore_state
	.loc 2 199 0
	adrp	x0, .LC82
	mov	w1, 0
	add	x0, x0, :lo12:.LC82
	bl	printf
.LVL726:
.L468:
	b	.L468
.LVL727:
.L466:
	.loc 2 203 0
	ldrh	w2, [x19, 6]
	mov	w1, w20
	mov	x0, x23
	bl	printf
.LVL728:
	.loc 2 205 0
	b	.L464
	.cfi_endproc
.LFE243:
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",@progbits
	.align	2
	.global	ftl_map_blk_alloc_new_blk
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
.LFB255:
	.loc 2 562 0
	.cfi_startproc
.LVL729:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
.LVL730:
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	.loc 2 566 0
	ldrh	w1, [x0, 10]
	mov	w20, 0
	ldr	x0, [x0, 16]
.LVL731:
	.loc 2 562 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
.LVL732:
.L472:
	.loc 2 566 0 discriminator 1
	cmp	w20, w1
	beq	.L476
	.loc 2 567 0
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L473
	.loc 2 568 0
	bl	FtlFreeSysBlkQueueOut
.LVL733:
	and	w1, w0, 65535
	strh	w0, [x21]
	.loc 2 569 0
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L474
	.loc 2 570 0
	adrp	x0, .LANCHOR38+6
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	adrp	x0, .LC84
	add	x0, x0, :lo12:.LC84
	bl	printf
.LVL734:
.L475:
	b	.L475
.L474:
	.loc 2 576 0
	ldr	w0, [x19, 48]
	.loc 2 574 0
	strh	wzr, [x19, 2]
	.loc 2 576 0
	add	w0, w0, 1
	str	w0, [x19, 48]
	.loc 2 577 0
	ldrh	w0, [x19, 8]
	.loc 2 575 0
	strh	w20, [x19]
	.loc 2 577 0
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L476:
	.loc 2 581 0
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L478
.LVL735:
.LBB258:
.LBB259:
	adrp	x1, .LANCHOR116
	adrp	x0, .LC1
	mov	w2, 581
	add	x1, x1, :lo12:.LANCHOR116
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL736:
.L478:
.LBE259:
.LBE258:
	.loc 2 583 0
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL737:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL738:
.L473:
	.cfi_restore_state
	.loc 2 566 0 discriminator 2
	add	w20, w20, 1
.LVL739:
	and	w20, w20, 65535
.LVL740:
	b	.L472
	.cfi_endproc
.LFE255:
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.ftl_memset,"ax",@progbits
	.align	2
	.global	ftl_memset
	.type	ftl_memset, %function
ftl_memset:
.LFB346:
	.loc 1 242 0
	.cfi_startproc
.LVL741:
	.loc 1 243 0
	uxtw	x2, w2
	b	memset
.LVL742:
	.cfi_endproc
.LFE346:
	.size	ftl_memset, .-ftl_memset
	.section	.text.FtlMemInit,"ax",@progbits
	.align	2
	.global	FtlMemInit
	.type	FtlMemInit, %function
FtlMemInit:
.LFB206:
	.loc 3 280 0
	.cfi_startproc
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	.loc 3 283 0
	adrp	x0, .LANCHOR70
	.loc 3 298 0
	mov	w1, 65535
	.loc 3 280 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 283 0
	str	wzr, [x0, #:lo12:.LANCHOR70]
	.loc 3 284 0
	adrp	x0, .LANCHOR71
	.loc 3 280 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.loc 3 311 0
	adrp	x19, .LANCHOR21
	.loc 3 284 0
	str	wzr, [x0, #:lo12:.LANCHOR71]
	.loc 3 285 0
	adrp	x0, .LANCHOR67
	.loc 3 280 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.loc 3 313 0
	adrp	x22, .LANCHOR3
	.loc 3 285 0
	str	wzr, [x0, #:lo12:.LANCHOR67]
	.loc 3 286 0
	adrp	x0, .LANCHOR64
	.loc 3 280 0
	stp	x23, x24, [sp, 48]
	.loc 3 320 0
	adrp	x21, .LANCHOR23
	.loc 3 286 0
	str	wzr, [x0, #:lo12:.LANCHOR64]
	.loc 3 287 0
	adrp	x0, .LANCHOR63
	.loc 3 280 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.loc 3 331 0
	adrp	x24, .LANCHOR108
	.loc 3 287 0
	str	wzr, [x0, #:lo12:.LANCHOR63]
	.loc 3 288 0
	adrp	x0, .LANCHOR65
	.loc 3 280 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 3 332 0
	adrp	x23, .LANCHOR114
	.loc 3 288 0
	str	wzr, [x0, #:lo12:.LANCHOR65]
	.loc 3 289 0
	adrp	x0, .LANCHOR66
	.loc 3 350 0
	adrp	x25, .LANCHOR42
	.loc 3 352 0
	adrp	x27, .LANCHOR129
	.loc 3 289 0
	str	wzr, [x0, #:lo12:.LANCHOR66]
	.loc 3 290 0
	adrp	x0, .LANCHOR62
	.loc 3 353 0
	adrp	x26, .LANCHOR130
	.loc 3 290 0
	str	wzr, [x0, #:lo12:.LANCHOR62]
	.loc 3 291 0
	adrp	x0, .LANCHOR72
	str	wzr, [x0, #:lo12:.LANCHOR72]
	.loc 3 292 0
	adrp	x0, .LANCHOR73
	str	wzr, [x0, #:lo12:.LANCHOR73]
	.loc 3 293 0
	adrp	x0, .LANCHOR75
	str	wzr, [x0, #:lo12:.LANCHOR75]
	.loc 3 294 0
	adrp	x0, .LANCHOR76
	str	wzr, [x0, #:lo12:.LANCHOR76]
	.loc 3 295 0
	adrp	x0, .LANCHOR77
	str	wzr, [x0, #:lo12:.LANCHOR77]
	.loc 3 296 0
	adrp	x0, .LANCHOR117
	str	wzr, [x0, #:lo12:.LANCHOR117]
	.loc 3 297 0
	adrp	x0, .LANCHOR87
	str	wzr, [x0, #:lo12:.LANCHOR87]
	.loc 3 298 0
	adrp	x0, .LANCHOR118
	str	w1, [x0, #:lo12:.LANCHOR118]
	.loc 3 299 0
	adrp	x0, .LANCHOR119
	.loc 3 302 0
	adrp	x1, .LANCHOR99
	.loc 3 299 0
	str	wzr, [x0, #:lo12:.LANCHOR119]
	.loc 3 300 0
	adrp	x0, .LANCHOR84
	str	wzr, [x0, #:lo12:.LANCHOR84]
	.loc 3 301 0
	adrp	x0, .LANCHOR112
	str	wzr, [x0, #:lo12:.LANCHOR112]
	.loc 3 302 0
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR99]
	.loc 3 303 0
	adrp	x1, .LANCHOR100
	strh	w0, [x1, #:lo12:.LANCHOR100]
	.loc 3 304 0
	adrp	x0, .LANCHOR82
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR82]
	.loc 3 305 0
	adrp	x0, .LANCHOR83
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR83]
	.loc 3 306 0
	adrp	x0, .LANCHOR85
	strh	wzr, [x0, #:lo12:.LANCHOR85]
	.loc 3 307 0
	adrp	x0, .LANCHOR101
	strh	wzr, [x0, #:lo12:.LANCHOR101]
	.loc 3 308 0
	adrp	x0, .LANCHOR103
	strh	wzr, [x0, #:lo12:.LANCHOR103]
	.loc 3 311 0
	ldrh	w0, [x19, #:lo12:.LANCHOR21]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL743:
	adrp	x1, .LANCHOR96
	str	x0, [x1, #:lo12:.LANCHOR96]
	.loc 3 312 0
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR21]
	mul	w0, w1, w0
	bl	ftl_malloc
.LVL744:
	.loc 3 313 0
	ldrh	w19, [x22, #:lo12:.LANCHOR3]
	.loc 3 312 0
	adrp	x3, .LANCHOR98
	str	x3, [x29, 104]
	.loc 3 313 0
	lsl	w20, w19, 5
.LVL745:
	.loc 3 314 0
	lsl	w19, w19, 7
	.loc 3 312 0
	str	x0, [x3, #:lo12:.LANCHOR98]
	.loc 3 314 0
	mov	w0, w19
	bl	ftl_malloc
.LVL746:
	adrp	x15, .LANCHOR120
	str	x15, [x29, 112]
	str	x0, [x15, #:lo12:.LANCHOR120]
	.loc 3 315 0
	mov	w0, w20
	bl	ftl_malloc
.LVL747:
	adrp	x11, .LANCHOR121
	str	x11, [x29, 120]
	str	x0, [x11, #:lo12:.LANCHOR121]
	.loc 3 316 0
	mov	w0, w19
	bl	ftl_malloc
.LVL748:
	adrp	x14, .LANCHOR122
	str	x14, [x29, 128]
	str	x0, [x14, #:lo12:.LANCHOR122]
	.loc 3 317 0
	mov	w0, w20
	bl	ftl_malloc
.LVL749:
	adrp	x13, .LANCHOR111
	str	x13, [x29, 136]
	str	x0, [x13, #:lo12:.LANCHOR111]
	.loc 3 318 0
	mov	w0, w20
	bl	ftl_malloc
.LVL750:
	.loc 3 321 0
	adrp	x20, .LANCHOR94
.LVL751:
	.loc 3 318 0
	adrp	x12, .LANCHOR93
	.loc 3 320 0
	ldrh	w19, [x21, #:lo12:.LANCHOR23]
.LVL752:
	.loc 3 318 0
	str	x12, [x29, 144]
	str	x0, [x12, #:lo12:.LANCHOR93]
	.loc 3 321 0
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR94]
	.loc 3 322 0
	mov	w0, w19
	bl	ftl_malloc
.LVL753:
	adrp	x10, .LANCHOR107
	str	x10, [x29, 152]
	str	x0, [x10, #:lo12:.LANCHOR107]
	.loc 3 323 0
	mov	w0, w19
	bl	ftl_malloc
.LVL754:
	adrp	x8, .LANCHOR123
	str	x8, [x29, 160]
	str	x0, [x8, #:lo12:.LANCHOR123]
	.loc 3 324 0
	mov	w0, w19
	bl	ftl_malloc
.LVL755:
	adrp	x7, .LANCHOR124
	str	x7, [x29, 168]
	str	x0, [x7, #:lo12:.LANCHOR124]
	.loc 3 325 0
	ldr	w0, [x20, #:lo12:.LANCHOR94]
	mul	w0, w19, w0
	bl	ftl_malloc
.LVL756:
	adrp	x6, .LANCHOR91
	str	x6, [x29, 176]
	str	x0, [x6, #:lo12:.LANCHOR91]
	.loc 3 326 0
	mov	w0, w19
	bl	ftl_malloc
.LVL757:
	adrp	x5, .LANCHOR115
	str	x5, [x29, 184]
	str	x0, [x5, #:lo12:.LANCHOR115]
	.loc 3 327 0
	mov	w0, w19
	bl	ftl_malloc
.LVL758:
	.loc 3 330 0
	adrp	x19, .LANCHOR24
.LVL759:
	.loc 3 327 0
	adrp	x4, .LANCHOR113
	.loc 3 328 0
	ldr	w2, [x20, #:lo12:.LANCHOR94]
	.loc 3 327 0
	str	x4, [x29, 192]
	str	x0, [x4, #:lo12:.LANCHOR113]
	.loc 3 328 0
	mov	w0, 24
	mul	w0, w2, w0
	bl	ftl_malloc
.LVL760:
	.loc 3 330 0
	ldrh	w28, [x19, #:lo12:.LANCHOR24]
	.loc 3 328 0
	adrp	x1, .LANCHOR90
	str	x0, [x1, #:lo12:.LANCHOR90]
	.loc 3 330 0
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	.loc 3 333 0
	adrp	x22, .LANCHOR92
	.loc 3 330 0
	mul	w28, w28, w0
.LVL761:
	.loc 3 331 0
	mov	w0, w28
	bl	ftl_malloc
.LVL762:
	str	x0, [x24, #:lo12:.LANCHOR108]
	.loc 3 332 0
	lsl	w0, w28, 2
	bl	ftl_malloc
.LVL763:
	str	x0, [x23, #:lo12:.LANCHOR114]
	.loc 3 333 0
	ldrh	w1, [x19, #:lo12:.LANCHOR24]
	.loc 3 336 0
	adrp	x28, .LANCHOR125
.LVL764:
	.loc 3 333 0
	ldr	w0, [x20, #:lo12:.LANCHOR94]
	.loc 3 336 0
	adrp	x20, .LANCHOR6
	.loc 3 333 0
	mul	w0, w1, w0
	bl	ftl_malloc
.LVL765:
	str	x0, [x22, #:lo12:.LANCHOR92]
	.loc 3 336 0
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x28, #:lo12:.LANCHOR125]
	.loc 3 337 0
	and	w0, w0, 65534
	bl	ftl_malloc
.LVL766:
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	.loc 3 338 0
	ldrh	w0, [x28, #:lo12:.LANCHOR125]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x28, #:lo12:.LANCHOR125]
	.loc 3 339 0
	lsl	w0, w0, 9
	bl	ftl_malloc
.LVL767:
	adrp	x1, .LANCHOR127
	.loc 3 346 0
	ldrh	w28, [x20, #:lo12:.LANCHOR6]
	.loc 3 339 0
	str	x0, [x1, #:lo12:.LANCHOR127]
	.loc 3 340 0
	adrp	x1, .LANCHOR43
	.loc 3 346 0
	lsl	w28, w28, 1
	.loc 3 340 0
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR43]
.LVL768:
	.loc 3 348 0
	mov	w0, w28
	bl	ftl_malloc
.LVL769:
	adrp	x1, .LANCHOR128
	str	x0, [x1, #:lo12:.LANCHOR128]
	.loc 3 350 0
	mov	w0, w28
	.loc 3 351 0
	adrp	x28, .LANCHOR30
.LVL770:
	.loc 3 350 0
	bl	ftl_malloc
.LVL771:
	str	x0, [x25, #:lo12:.LANCHOR42]
.LVL772:
	.loc 3 351 0
	ldr	w1, [x28, #:lo12:.LANCHOR30]
	lsl	w19, w1, 1
	.loc 3 352 0
	mov	w0, w19
	bl	ftl_malloc
.LVL773:
	str	x0, [x27, #:lo12:.LANCHOR129]
	.loc 3 353 0
	mov	w0, w19
	bl	ftl_malloc
.LVL774:
	str	x0, [x26, #:lo12:.LANCHOR130]
	.loc 3 354 0
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	.loc 3 355 0
	adrp	x19, .LANCHOR27
	.loc 3 354 0
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
.LVL775:
	adrp	x1, .LANCHOR1
	str	x0, [x1, #:lo12:.LANCHOR1]
	.loc 3 355 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL776:
	adrp	x2, .LANCHOR36
	str	x0, [x2, #:lo12:.LANCHOR36]
	.loc 3 356 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL777:
	adrp	x2, .LANCHOR131
	str	x0, [x2, #:lo12:.LANCHOR131]
	.loc 3 357 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	adrp	x19, .LANCHOR43
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL778:
	adrp	x1, .LANCHOR132
	str	x0, [x1, #:lo12:.LANCHOR132]
	.loc 3 358 0
	adrp	x1, .LANCHOR28
	str	x1, [x29, 200]
	ldrh	w0, [x1, #:lo12:.LANCHOR28]
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL779:
	.loc 3 359 0
	ldr	x1, [x29, 200]
	.loc 3 358 0
	adrp	x2, .LANCHOR133
	str	x0, [x2, #:lo12:.LANCHOR133]
	.loc 3 359 0
	ldrh	w2, [x1, #:lo12:.LANCHOR28]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
.LVL780:
	.loc 3 361 0
	adrp	x0, .LANCHOR32
	ldrh	w0, [x0, #:lo12:.LANCHOR32]
	.loc 3 362 0
	lsl	w0, w0, 2
.LVL781:
	bl	ftl_malloc
.LVL782:
	adrp	x1, .LANCHOR134
	str	x0, [x1, #:lo12:.LANCHOR134]
.LVL783:
	.loc 3 363 0
	ldr	w0, [x28, #:lo12:.LANCHOR30]
	.loc 3 365 0
	adrp	x28, .LANCHOR33
	.loc 3 364 0
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL784:
	adrp	x1, .LANCHOR135
	str	x0, [x1, #:lo12:.LANCHOR135]
.LVL785:
	.loc 3 365 0
	ldrh	w0, [x28, #:lo12:.LANCHOR33]
	.loc 3 366 0
	lsl	w0, w0, 4
.LVL786:
	bl	ftl_malloc
.LVL787:
	adrp	x1, .LANCHOR55
	str	x0, [x1, #:lo12:.LANCHOR55]
.LVL788:
	.loc 3 367 0
	ldrh	w1, [x28, #:lo12:.LANCHOR33]
	ldrh	w0, [x21, #:lo12:.LANCHOR23]
	.loc 3 372 0
	adrp	x21, .LANCHOR10
	.loc 3 368 0
	mul	w0, w1, w0
.LVL789:
	bl	ftl_malloc
.LVL790:
	adrp	x1, .LANCHOR136
	str	x0, [x1, #:lo12:.LANCHOR136]
.LVL791:
	.loc 3 370 0
	mov	w0, 6
	.loc 3 369 0
	ldrh	w1, [x20, #:lo12:.LANCHOR6]
	.loc 3 371 0
	adrp	x20, .LANCHOR137
	.loc 3 370 0
	mul	w0, w1, w0
.LVL792:
	bl	ftl_malloc
.LVL793:
	adrp	x1, .LANCHOR40
	str	x0, [x1, #:lo12:.LANCHOR40]
	.loc 3 371 0
	adrp	x0, .LANCHOR17
	.loc 3 372 0
	ldrh	w1, [x21, #:lo12:.LANCHOR10]
	.loc 3 371 0
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x20, #:lo12:.LANCHOR137]
.LVL794:
	.loc 3 372 0
	mul	w0, w1, w0
.LVL795:
	.loc 3 373 0
	lsl	w0, w0, 2
.LVL796:
	bl	ftl_malloc
.LVL797:
	ldp	x3, x15, [x29, 104]
	adrp	x1, .LANCHOR37
	.loc 3 375 0
	ldrh	w20, [x20, #:lo12:.LANCHOR137]
	.loc 3 373 0
	add	x2, x1, :lo12:.LANCHOR37
	ldp	x11, x14, [x29, 120]
	.loc 3 374 0
	mov	w30, w20
	ldp	x13, x12, [x29, 136]
	mov	x16, x3
	ldp	x10, x8, [x29, 152]
	.loc 3 373 0
	str	x0, [x2, 32]
.LVL798:
	ldp	x7, x6, [x29, 168]
	adrp	x17, .LANCHOR96
	ldp	x5, x4, [x29, 184]
	adrp	x3, .LANCHOR90
	.loc 3 374 0
	ldrh	w28, [x21, #:lo12:.LANCHOR10]
	add	x21, x2, 40
	mov	x0, 1
	str	x19, [x29, 200]
.LVL799:
.L482:
	.loc 3 374 0 is_stmt 0 discriminator 1
	cmp	w0, w28
	bcc	.L483
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	.loc 3 380 0 is_stmt 1
	add	x1, x1, :lo12:.LANCHOR37
	.loc 3 374 0
	mov	x19, 0
.L484:
	add	x19, x19, 1
	.loc 3 378 0 discriminator 1
	cmp	x19, x2
	bne	.L485
	.loc 3 384 0
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	cbnz	x0, .L486
.L488:
	.loc 3 386 0
	adrp	x1, .LANCHOR138
	adrp	x0, .LC85
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC85
	bl	printf
.LVL800:
	.loc 3 387 0
	mov	w0, -1
.L481:
	.loc 3 485 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L483:
	.cfi_restore_state
	.loc 3 375 0 discriminator 3
	ldr	x19, [x2, 32]
	.loc 3 374 0 discriminator 3
	add	w0, w0, 1
	.loc 3 375 0 discriminator 3
	add	x19, x19, x30, uxtw 2
	add	w30, w30, w20
	str	x19, [x21], 8
	b	.L482
.L485:
	.loc 3 380 0 discriminator 2
	add	x20, x0, x19
	add	x20, x1, x20, lsl 3
	str	xzr, [x20, 24]
	b	.L484
.L486:
	.loc 3 389 0
	ldr	x0, [x26, #:lo12:.LANCHOR130]
	cbz	x0, .L488
	.loc 3 394 0
	adrp	x0, .LANCHOR134
	ldr	x0, [x0, #:lo12:.LANCHOR134]
	cbz	x0, .L488
	.loc 3 399 0
	adrp	x0, .LANCHOR135
	ldr	x0, [x0, #:lo12:.LANCHOR135]
	cbz	x0, .L488
	.loc 3 405 0
	adrp	x0, .LANCHOR55
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	cbz	x0, .L488
	.loc 3 410 0
	adrp	x0, .LANCHOR136
	ldr	x0, [x0, #:lo12:.LANCHOR136]
	cbz	x0, .L488
	.loc 3 415 0
	adrp	x0, .LANCHOR40
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	cbz	x0, .L488
	.loc 3 420 0
	adrp	x0, .LANCHOR37+32
	ldr	x0, [x0, #:lo12:.LANCHOR37+32]
	cbz	x0, .L488
	.loc 3 426 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	cbz	x0, .L488
	.loc 3 431 0
	ldr	x0, [x17, #:lo12:.LANCHOR96]
	cbz	x0, .L488
	.loc 3 431 0 is_stmt 0 discriminator 1
	ldr	x0, [x16, #:lo12:.LANCHOR98]
	cbz	x0, .L488
	.loc 3 436 0 is_stmt 1
	ldr	x0, [x15, #:lo12:.LANCHOR120]
	cbz	x0, .L488
	.loc 3 436 0 is_stmt 0 discriminator 1
	ldr	x0, [x14, #:lo12:.LANCHOR122]
	cbz	x0, .L488
	.loc 3 436 0 discriminator 2
	ldr	x0, [x13, #:lo12:.LANCHOR111]
	cbz	x0, .L488
	.loc 3 436 0 discriminator 3
	ldr	x0, [x12, #:lo12:.LANCHOR93]
	cbz	x0, .L488
	.loc 3 436 0 discriminator 4
	ldr	x0, [x11, #:lo12:.LANCHOR121]
	cbz	x0, .L488
	.loc 3 441 0 is_stmt 1
	ldr	x0, [x10, #:lo12:.LANCHOR107]
	cbz	x0, .L488
	.loc 3 441 0 is_stmt 0 discriminator 1
	ldr	x0, [x8, #:lo12:.LANCHOR123]
	cbz	x0, .L488
	.loc 3 441 0 discriminator 2
	ldr	x0, [x7, #:lo12:.LANCHOR124]
	cbz	x0, .L488
	.loc 3 441 0 discriminator 3
	ldr	x0, [x6, #:lo12:.LANCHOR91]
	cbz	x0, .L488
	.loc 3 442 0 is_stmt 1
	ldr	x0, [x5, #:lo12:.LANCHOR115]
	cbz	x0, .L488
	.loc 3 442 0 is_stmt 0 discriminator 1
	ldr	x0, [x4, #:lo12:.LANCHOR113]
	cbz	x0, .L488
	.loc 3 442 0 discriminator 2
	ldr	x0, [x3, #:lo12:.LANCHOR90]
	cbz	x0, .L488
	.loc 3 447 0 is_stmt 1
	ldr	x0, [x24, #:lo12:.LANCHOR108]
	cbz	x0, .L488
	.loc 3 447 0 is_stmt 0 discriminator 1
	ldr	x0, [x23, #:lo12:.LANCHOR114]
	cbz	x0, .L488
	.loc 3 447 0 discriminator 2
	ldr	x0, [x22, #:lo12:.LANCHOR92]
	cbz	x0, .L488
	.loc 3 453 0 is_stmt 1
	ldr	x0, [x29, 200]
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	cbz	x0, .L488
	.loc 3 453 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR126
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	cbz	x0, .L488
	.loc 3 459 0 is_stmt 1
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	cbz	x0, .L488
	.loc 3 465 0
	adrp	x0, .LANCHOR131
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	cbz	x0, .L488
	.loc 3 471 0
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	cbz	x0, .L488
	.loc 3 477 0
	adrp	x0, .LANCHOR133
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	cbz	x0, .L488
	.loc 3 484 0
	mov	w0, 0
	b	.L481
	.cfi_endproc
.LFE206:
	.size	FtlMemInit, .-FtlMemInit
	.section	.text.FtlBbt2Bitmap,"ax",@progbits
	.align	2
	.global	FtlBbt2Bitmap
	.type	FtlBbt2Bitmap, %function
FtlBbt2Bitmap:
.LFB225:
	.loc 4 66 0
	.cfi_startproc
.LVL801:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	.loc 4 69 0
	adrp	x0, .LANCHOR137
.LVL802:
	.loc 4 66 0
	stp	x23, x24, [sp, 48]
	.loc 4 74 0
	adrp	x21, .LANCHOR17
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	adrp	x23, .LANCHOR139
	.loc 4 69 0
	ldrh	w2, [x0, #:lo12:.LANCHOR137]
	.loc 4 74 0
	add	x21, x21, :lo12:.LANCHOR17
	add	x23, x23, :lo12:.LANCHOR139
	.loc 4 66 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 4 72 0
	mov	w24, 65535
	.loc 4 69 0
	mov	x19, 0
	.loc 4 66 0
	mov	x20, x1
	.loc 4 69 0
	lsl	w2, w2, 2
	mov	w1, 0
.LVL803:
	mov	x0, x20
	bl	ftl_memset
.LVL804:
.L586:
	.loc 4 72 0
	ldrh	w0, [x22, x19]
	cmp	w0, w24
	beq	.L583
	.loc 4 74 0
	ldrh	w1, [x21]
	cmp	w1, w0
	bhi	.L585
	.loc 4 74 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 74
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL805:
.L585:
	.loc 4 75 0 is_stmt 1 discriminator 2
	ldrh	w2, [x22, x19]
	mov	w1, 1
	add	x19, x19, 2
	.loc 4 70 0 discriminator 2
	cmp	x19, 1024
	.loc 4 75 0 discriminator 2
	ubfx	x0, x2, 5, 11
	lsl	w2, w1, w2
	lsl	x0, x0, 2
	ldr	w1, [x20, x0]
	orr	w1, w1, w2
	str	w1, [x20, x0]
	.loc 4 70 0 discriminator 2
	bne	.L586
.L583:
	.loc 4 77 0
	ldp	x19, x20, [sp, 16]
.LVL806:
	ldp	x21, x22, [sp, 32]
.LVL807:
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE225:
	.size	FtlBbt2Bitmap, .-FtlBbt2Bitmap
	.section	.text.FtlBbtMemInit,"ax",@progbits
	.align	2
	.global	FtlBbtMemInit
	.type	FtlBbtMemInit, %function
FtlBbtMemInit:
.LFB227:
	.loc 4 149 0
	.cfi_startproc
	.loc 4 150 0
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	mov	w2, -1
	.loc 4 152 0
	add	x0, x0, 12
	.loc 4 150 0
	strh	w2, [x1, #:lo12:.LANCHOR37]
	.loc 4 152 0
	mov	w2, 16
	.loc 4 151 0
	strh	wzr, [x0, -6]
	.loc 4 152 0
	mov	w1, 255
	b	ftl_memset
.LVL808:
	.cfi_endproc
.LFE227:
	.size	FtlBbtMemInit, .-FtlBbtMemInit
	.section	.text.FtlFreeSysBlkQueueInit,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueInit
	.type	FtlFreeSysBlkQueueInit, %function
FtlFreeSysBlkQueueInit:
.LFB237:
	.loc 2 76 0
	.cfi_startproc
.LVL809:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 2 79 0
	adrp	x1, .LANCHOR38
	add	x3, x1, :lo12:.LANCHOR38
	.loc 2 83 0
	mov	w2, 2048
	.loc 2 76 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 82 0
	strh	w0, [x1, #:lo12:.LANCHOR38]
	.loc 2 83 0
	mov	w1, 0
	.loc 2 79 0
	strh	wzr, [x3, 2]
	.loc 2 83 0
	add	x0, x3, 8
.LVL810:
	.loc 2 80 0
	strh	wzr, [x3, 4]
	.loc 2 81 0
	strh	wzr, [x3, 6]
	.loc 2 83 0
	bl	ftl_memset
.LVL811:
	.loc 2 85 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE237:
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.global	load_l2p_region
	.type	load_l2p_region, %function
load_l2p_region:
.LFB253:
	.loc 2 488 0
	.cfi_startproc
.LVL812:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 2 492 0
	adrp	x23, .LANCHOR32
	.loc 2 488 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	and	x19, x1, 65535
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	and	w21, w0, 65535
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 2 492 0
	ldrh	w0, [x23, #:lo12:.LANCHOR32]
.LVL813:
	cmp	w0, w21
	bcs	.L594
	.loc 2 492 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR140
.LVL814:
	adrp	x0, .LC1
	mov	w2, 492
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL815:
.L594:
	.loc 2 493 0 is_stmt 1
	adrp	x26, .LANCHOR134
	ubfiz	x0, x21, 2, 16
	adrp	x22, .LANCHOR55
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	ldr	w24, [x1, x0]
.LVL816:
	.loc 2 495 0
	cbnz	w24, .L595
	.loc 2 496 0
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
.LVL817:
	adrp	x1, .LANCHOR23
	add	x0, x0, x19
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
.LVL818:
	.loc 2 497 0
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	strh	w21, [x0, x19]
	.loc 2 498 0
	str	wzr, [x1, 4]
.L596:
	.loc 2 519 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL819:
	ldp	x23, x24, [sp, 48]
.LVL820:
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL821:
.L595:
	.cfi_restore_state
	.loc 2 502 0
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	lsl	x19, x19, 4
	.loc 2 501 0
	adrp	x20, .LANCHOR106
	add	x20, x20, :lo12:.LANCHOR106
	.loc 2 502 0
	add	x0, x0, x19
	.loc 2 504 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 501 0
	str	w24, [x20, 4]
	.loc 2 502 0
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	.loc 2 503 0
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	str	x0, [x20, 16]
	.loc 2 504 0
	mov	x0, x20
	bl	FlashReadPages
.LVL822:
	.loc 2 505 0
	ldr	x25, [x20, 16]
.LVL823:
	.loc 2 507 0
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L597
	.loc 2 508 0
	mov	w2, w24
	mov	w1, w21
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	bl	printf
.LVL824:
	.loc 2 509 0
	ldr	x1, [x20, 16]
	mov	w3, 4
	adrp	x0, .LC87
	mov	w2, w3
	add	x0, x0, :lo12:.LC87
	bl	rknand_print_hex
.LVL825:
	.loc 2 510 0
	ldrh	w3, [x23, #:lo12:.LANCHOR32]
	adrp	x0, .LC88
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	mov	w2, 4
	add	x0, x0, :lo12:.LC88
	bl	rknand_print_hex
.LVL826:
.L597:
	.loc 2 513 0
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L598
	.loc 2 513 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR140
	adrp	x0, .LC1
	mov	w2, 513
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL827:
.L598:
	.loc 2 516 0 is_stmt 1
	ldr	x0, [x22, #:lo12:.LANCHOR55]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	.loc 2 517 0
	strh	w21, [x0, x19]
	.loc 2 518 0
	b	.L596
	.cfi_endproc
.LFE253:
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.ftl_free_no_use_map_blk,"ax",@progbits
	.align	2
	.global	ftl_free_no_use_map_blk
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
.LFB254:
	.loc 2 522 0
	.cfi_startproc
.LVL828:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 2 531 0
	mov	w1, 0
	.loc 2 522 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x0
	.loc 2 531 0
	ldrh	w2, [x0, 10]
	.loc 2 522 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 524 0
	ldp	x21, x20, [x0, 32]
	.loc 2 522 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 2 531 0
	lsl	w2, w2, 1
	.loc 2 523 0
	ldr	x23, [x0, 16]
.LVL829:
	.loc 2 531 0
	mov	x0, x21
.LVL830:
	bl	ftl_memset
.LVL831:
	.loc 2 532 0
	mov	w0, 0
.LVL832:
.L601:
	.loc 2 532 0 is_stmt 0 discriminator 1
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L605
	.loc 2 540 0 is_stmt 1
	ldrh	w26, [x21]
.LVL833:
	.loc 2 544 0
	adrp	x24, .LANCHOR20
	add	x24, x24, :lo12:.LANCHOR20
	.loc 2 541 0
	mov	w25, 0
	.loc 2 543 0
	mov	w20, 0
.LVL834:
.L606:
	.loc 2 543 0 is_stmt 0 discriminator 1
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L610
	.loc 2 559 0 is_stmt 1
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
.LVL835:
	ldp	x21, x22, [sp, 32]
.LVL836:
	ldp	x23, x24, [sp, 48]
.LVL837:
	ldp	x25, x26, [sp, 64]
.LVL838:
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL839:
.L605:
	.cfi_restore_state
	.loc 2 533 0
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	.loc 2 534 0
	mov	w1, 0
	.loc 2 533 0
	ubfx	x2, x2, 10, 16
.LVL840:
.L602:
	.loc 2 534 0 discriminator 1
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L604
	.loc 2 532 0 discriminator 2
	add	w0, w0, 1
.LVL841:
	and	w0, w0, 65535
.LVL842:
	b	.L601
.L604:
	.loc 2 535 0
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x23, x3]
	cmp	w4, w2
	bne	.L603
	.loc 2 536 0
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L603:
	.loc 2 534 0 discriminator 2
	add	w1, w1, 1
.LVL843:
	and	w1, w1, 65535
.LVL844:
	b	.L602
.LVL845:
.L610:
	.loc 2 544 0
	ldrh	w0, [x19]
	uxtw	x22, w20
	cmp	w0, w20
	bne	.L607
	.loc 2 544 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bcs	.L607
	.loc 2 545 0 is_stmt 1
	strh	w0, [x21, x22, lsl 1]
.L607:
	.loc 2 546 0
	lsl	x22, x22, 1
	ldrh	w0, [x21, x22]
	cmp	w26, w0
	bls	.L608
	mov	w25, w20
.LVL846:
	mov	w26, w0
.LVL847:
.L608:
	.loc 2 550 0
	cbnz	w0, .L609
	.loc 2 550 0 is_stmt 0 discriminator 1
	ldrh	w0, [x23, x22]
	cbz	w0, .L609
	.loc 2 552 0 is_stmt 1
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.LVL848:
	.loc 2 553 0
	strh	wzr, [x23, x22]
	.loc 2 554 0
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
.L609:
	.loc 2 543 0 discriminator 2
	add	w20, w20, 1
.LVL849:
	and	w20, w20, 65535
.LVL850:
	b	.L606
	.cfi_endproc
.LFE254:
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
.LFB257:
	.loc 2 632 0
	.cfi_startproc
.LVL851:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 640 0
	mov	w1, 65535
	.loc 2 632 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	.loc 2 635 0
	ldr	x20, [x0, 16]
.LVL852:
	.loc 2 632 0
	stp	x21, x22, [sp, 32]
	.loc 2 640 0
	ldrh	w0, [x0]
.LVL853:
	.loc 2 632 0
	str	x23, [sp, 48]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.loc 2 640 0
	cmp	w0, w1
	bne	.L616
	.loc 2 641 0
	ldrh	w0, [x19, 8]
	cbz	w0, .L617
	.loc 2 641 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR141
	adrp	x0, .LC1
	mov	w2, 641
	add	x1, x1, :lo12:.LANCHOR141
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL854:
.L617:
	.loc 2 642 0 is_stmt 1
	ldrh	w0, [x19, 8]
	add	w0, w0, 1
	strh	w0, [x19, 8]
	.loc 2 643 0
	bl	FtlFreeSysBlkQueueOut
.LVL855:
	strh	w0, [x20]
	.loc 2 646 0
	ldr	w0, [x19, 48]
	.loc 2 644 0
	strh	wzr, [x19, 2]
	.loc 2 646 0
	add	w0, w0, 1
	.loc 2 645 0
	strh	wzr, [x19]
	.loc 2 646 0
	str	w0, [x19, 48]
.LVL856:
.L618:
	.loc 2 677 0
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
.LVL857:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL858:
.L616:
	.cfi_restore_state
	.loc 2 650 0
	ubfiz	x0, x0, 1, 16
	.loc 2 653 0
	adrp	x1, .LANCHOR108
	.loc 2 652 0
	adrp	x23, .LANCHOR107
	.loc 2 636 0
	ldr	x22, [x19, 40]
	.loc 2 653 0
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	.loc 2 650 0
	ldrh	w21, [x20, x0]
	.loc 2 651 0
	adrp	x20, .LANCHOR106
.LVL859:
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR106
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	.loc 2 652 0
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	.loc 2 653 0
	str	x1, [x2, 16]
.LVL860:
	.loc 2 652 0
	str	x0, [x2, 8]
	.loc 2 656 0
	ldr	w2, [x19, 48]
	str	w2, [x1, 4]
	.loc 2 657 0
	mov	w2, -1291
	strh	w2, [x1, 8]
	.loc 2 658 0
	ldrh	w2, [x19, 4]
	strh	w2, [x1]
	.loc 2 659 0
	strh	w21, [x1, 2]
	.loc 2 661 0
	adrp	x1, .LANCHOR20
.LVL861:
	ldrh	w2, [x1, #:lo12:.LANCHOR20]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
.LVL862:
	.loc 2 663 0
	ldrh	w4, [x19, 6]
	mov	x1, 0
	.loc 2 666 0
	ldr	x3, [x23, #:lo12:.LANCHOR107]
	.loc 2 662 0
	mov	w2, 0
.LVL863:
.L619:
	.loc 2 663 0 discriminator 1
	cmp	w4, w1, uxth
	bhi	.L621
	.loc 2 670 0
	mov	w2, 1
.LVL864:
	mov	w3, 0
	mov	w1, w2
.LVL865:
	add	x0, x20, :lo12:.LANCHOR106
	bl	FlashProgPages
.LVL866:
	.loc 2 671 0
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 675 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL867:
	.loc 2 676 0
	b	.L618
.LVL868:
.L621:
	.loc 2 664 0
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L620
	.loc 2 665 0
	add	w2, w2, 1
.LVL869:
	and	w2, w2, 65535
.LVL870:
	.loc 2 666 0
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	.loc 2 667 0
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L620:
.LVL871:
	add	x1, x1, 1
.LVL872:
	b	.L619
	.cfi_endproc
.LFE257:
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",@progbits
	.align	2
	.global	FtlMapWritePage
	.type	FtlMapWritePage, %function
FtlMapWritePage:
.LFB258:
	.loc 2 680 0
	.cfi_startproc
.LVL873:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 686 0
	adrp	x23, .LANCHOR66
	.loc 2 680 0
	stp	x25, x26, [sp, 64]
	.loc 2 699 0
	adrp	x24, .LANCHOR142
	.loc 2 680 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 687 0
	adrp	x26, .LANCHOR20
	.loc 2 680 0
	stp	x19, x20, [sp, 16]
	mov	w25, w1
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x19, x0
	mov	x27, x2
	.loc 2 686 0
	add	x23, x23, :lo12:.LANCHOR66
	.loc 2 699 0
	add	x24, x24, :lo12:.LANCHOR142
	.loc 2 720 0
	add	x28, x26, :lo12:.LANCHOR20
	.loc 2 680 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 683 0
	mov	w22, 0
.LVL874:
.L627:
	.loc 2 686 0
	ldr	w0, [x23]
	.loc 2 687 0
	ldrh	w1, [x19, 2]
	.loc 2 686 0
	add	w0, w0, 1
	str	w0, [x23]
	.loc 2 687 0
	ldrh	w0, [x26, #:lo12:.LANCHOR20]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L628
	.loc 2 687 0 is_stmt 0 discriminator 1
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L629
.L628:
	.loc 2 688 0 is_stmt 1
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.LVL875:
.L629:
	.loc 2 699 0
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L630
	.loc 2 699 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 699
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL876:
.L630:
	.loc 2 700 0 is_stmt 1
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L631
	.loc 2 700 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 700
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL877:
.L631:
	.loc 2 701 0 is_stmt 1
	ldrh	w1, [x19]
	.loc 2 703 0
	adrp	x21, .LANCHOR106
	.loc 2 701 0
	ldr	x0, [x19, 16]
	.loc 2 703 0
	add	x20, x21, :lo12:.LANCHOR106
	.loc 2 707 0
	mov	w2, 16
	.loc 2 701 0
	ldrh	w3, [x0, x1, lsl 1]
.LVL878:
	.loc 2 707 0
	mov	w1, 0
	.loc 2 703 0
	ldrh	w0, [x19, 2]
	str	w3, [x29, 108]
	.loc 2 704 0
	str	x27, [x20, 8]
	.loc 2 703 0
	orr	w0, w0, w3, lsl 10
	str	w0, [x20, 4]
	.loc 2 705 0
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	str	x0, [x20, 16]
	.loc 2 707 0
	bl	ftl_memset
.LVL879:
	.loc 2 708 0
	ldr	x0, [x20, 16]
.LVL880:
	.loc 2 709 0
	ldr	w1, [x19, 48]
	.loc 2 712 0
	ldr	w3, [x29, 108]
	.loc 2 709 0
	str	w1, [x0, 4]
	.loc 2 711 0
	ldrh	w1, [x19, 4]
	strh	w1, [x0]
	.loc 2 712 0
	strh	w3, [x0, 2]
	.loc 2 713 0
	mov	w3, 1
	.loc 2 710 0
	strh	w25, [x0, 8]
	.loc 2 713 0
	mov	w1, w3
	mov	w2, w3
	mov	x0, x20
.LVL881:
	bl	FlashProgPages
.LVL882:
	.loc 2 714 0
	ldrh	w0, [x19, 2]
	.loc 2 716 0
	ldr	w1, [x21, #:lo12:.LANCHOR106]
	.loc 2 714 0
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	.loc 2 716 0
	cmn	w1, #1
	bne	.L632
	.loc 2 717 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC89
	add	x0, x0, :lo12:.LC89
	.loc 2 718 0
	add	w22, w22, 1
.LVL883:
	and	w22, w22, 65535
	.loc 2 717 0
	bl	printf
.LVL884:
	.loc 2 719 0
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L633
	.loc 2 720 0
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L633:
	.loc 2 722 0
	cmp	w22, 3
	bls	.L634
	.loc 2 723 0
	add	x21, x21, :lo12:.LANCHOR106
	adrp	x0, .LC90
	mov	w2, w22
	add	x0, x0, :lo12:.LC90
	ldr	w1, [x21, 4]
	bl	printf
.LVL885:
.L635:
	b	.L635
.L634:
	.loc 2 727 0
	ldr	w0, [x19, 52]
	cbz	w0, .L627
.L644:
	b	.L644
.L632:
	.loc 2 731 0
	cmp	w0, 1
	beq	.L627
	.loc 2 734 0
	ldr	x0, [x19, 40]
	ldr	w1, [x20, 4]
	.loc 2 736 0
	ldp	x21, x22, [sp, 32]
.LVL886:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
.LVL887:
	.loc 2 734 0
	str	w1, [x0, w25, uxtw 2]
	.loc 2 736 0
	ldp	x19, x20, [sp, 16]
.LVL888:
	mov	w0, 0
	ldp	x25, x26, [sp, 64]
.LVL889:
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
.LVL890:
	ret
	.cfi_endproc
.LFE258:
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.ftl_map_blk_gc,"ax",@progbits
	.align	2
	.global	ftl_map_blk_gc
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
.LFB256:
	.loc 2 586 0
	.cfi_startproc
.LVL891:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	adrp	x23, .LANCHOR20
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	.loc 2 590 0
	ldr	x20, [x0, 16]
.LVL892:
	.loc 2 591 0
	ldr	x24, [x0, 40]
.LVL893:
	.loc 2 594 0
	bl	ftl_free_no_use_map_blk
.LVL894:
	.loc 2 596 0
	ldrh	w1, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w1, #4
	cmp	w2, w1
	blt	.L647
	.loc 2 597 0
	ubfiz	x0, x0, 1, 16
.LVL895:
	ldrh	w21, [x20, x0]
.LVL896:
	.loc 2 598 0
	cbz	w21, .L647
	.loc 2 598 0 is_stmt 0 discriminator 1
	ldr	w1, [x19, 52]
	cbnz	w1, .L647
	.loc 2 599 0 is_stmt 1
	mov	w1, 1
	str	w1, [x19, 52]
	.loc 2 600 0
	strh	wzr, [x20, x0]
	.loc 2 601 0
	ldrh	w0, [x19, 8]
	.loc 2 602 0
	ldrh	w1, [x19, 2]
	.loc 2 601 0
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	.loc 2 602 0
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L648
	.loc 2 603 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL897:
.L648:
	.loc 2 607 0 discriminator 1
	adrp	x25, .LANCHOR106
	.loc 2 613 0 discriminator 1
	adrp	x22, .LANCHOR143
	.loc 2 614 0 discriminator 1
	add	x26, x25, :lo12:.LANCHOR106
	.loc 2 613 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR143
	.loc 2 586 0 discriminator 1
	mov	w20, 0
.LVL898:
.L649:
	.loc 2 605 0 discriminator 1
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L653
	.loc 2 621 0
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
.LVL899:
	.loc 2 622 0
	str	wzr, [x19, 52]
.LVL900:
.L647:
	.loc 2 626 0
	ldrh	w1, [x19, 2]
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L654
	.loc 2 627 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL901:
.L654:
	.loc 2 629 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL902:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL903:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL904:
.L653:
	.cfi_restore_state
	.loc 2 606 0
	ubfiz	x27, x20, 2, 16
	ldr	w1, [x24, x27]
	cmp	w21, w1, lsr 10
	bne	.L650
	.loc 2 607 0
	adrp	x2, .LANCHOR123
	add	x0, x25, :lo12:.LANCHOR106
	ldr	x2, [x2, #:lo12:.LANCHOR123]
	str	x2, [x0, 8]
	.loc 2 608 0
	adrp	x2, .LANCHOR108
	.loc 2 609 0
	str	w1, [x0, 4]
	.loc 2 608 0
	ldr	x28, [x2, #:lo12:.LANCHOR108]
.LVL905:
	.loc 2 611 0
	mov	w2, 1
	.loc 2 608 0
	str	x28, [x0, 16]
	.loc 2 611 0
	mov	w1, w2
	bl	FlashReadPages
.LVL906:
	.loc 2 613 0
	ldrh	w0, [x28, 8]
	cmp	w0, w20
	beq	.L651
	.loc 2 613 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 613
	mov	x1, x22
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL907:
.L651:
	.loc 2 614 0 is_stmt 1
	ldr	w0, [x26]
	cmn	w0, #1
	bne	.L652
	.loc 2 615 0
	str	wzr, [x24, x27]
.LVL908:
.L650:
	.loc 2 605 0 discriminator 2
	add	w20, w20, 1
.LVL909:
	and	w20, w20, 65535
.LVL910:
	b	.L649
.LVL911:
.L652:
	.loc 2 617 0
	ldr	x2, [x26, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.LVL912:
	b	.L650
	.cfi_endproc
.LFE256:
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
.LFB259:
	.loc 2 739 0
	.cfi_startproc
.LVL913:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 742 0
	adrp	x20, .LANCHOR55
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR55]
.LVL914:
	add	x1, x0, x19
.LVL915:
	.loc 2 743 0
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
.LVL916:
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapWritePage
.LVL917:
	.loc 2 744 0
	ldr	x0, [x20, #:lo12:.LANCHOR55]
	add	x0, x0, x19
	.loc 2 746 0
	ldp	x19, x20, [sp, 16]
	.loc 2 744 0
	ldr	w1, [x0, 4]
	and	w1, w1, 2147483647
	str	w1, [x0, 4]
	.loc 2 746 0
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE259:
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.log2phys,"ax",@progbits
	.align	2
	.global	log2phys
	.type	log2phys, %function
log2phys:
.LFB262:
	.loc 2 802 0
	.cfi_startproc
.LVL918:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	mov	x23, x1
	.loc 2 805 0
	adrp	x1, .LANCHOR22
.LVL919:
	.loc 2 802 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w24, w2
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 805 0
	ldrh	w19, [x1, #:lo12:.LANCHOR22]
	.loc 2 802 0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	.loc 2 805 0
	add	w1, w19, 7
	.loc 2 806 0
	mov	x19, 1
	.loc 2 805 0
	lsr	w22, w0, w1
	and	w22, w22, 65535
.LVL920:
	.loc 2 806 0
	lsl	x19, x19, x1
	.loc 2 808 0
	adrp	x1, .LANCHOR61
	.loc 2 806 0
	sub	w19, w19, #1
	.loc 2 808 0
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	.loc 2 806 0
	and	w19, w19, w0
	and	x19, x19, 65535
.LVL921:
	.loc 2 808 0
	cmp	w0, w1
	bcc	.L662
	.loc 2 808 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR145
	adrp	x0, .LC1
.LVL922:
	mov	w2, 808
.LVL923:
	add	x1, x1, :lo12:.LANCHOR145
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL924:
.L662:
	.loc 2 811 0 is_stmt 1
	adrp	x21, .LANCHOR55
	.loc 2 810 0
	adrp	x0, .LANCHOR33
	.loc 2 811 0
	ldr	x2, [x21, #:lo12:.LANCHOR55]
	.loc 2 810 0
	ldrh	w1, [x0, #:lo12:.LANCHOR33]
	mov	x0, 0
.LVL925:
.L663:
	and	x20, x0, 65535
.LVL926:
	.loc 2 810 0 is_stmt 0 discriminator 1
	cmp	w20, w1
	bcc	.L668
	.loc 2 825 0 is_stmt 1
	bl	select_l2p_ram_region
.LVL927:
	and	x20, x0, 65535
.LVL928:
	.loc 2 826 0
	ldr	x2, [x21, #:lo12:.LANCHOR55]
	ubfiz	x1, x20, 4, 16
	.loc 2 825 0
	mov	w25, w0
	.loc 2 826 0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L669
	.loc 2 826 0 is_stmt 0 discriminator 1
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L669
	.loc 2 827 0 is_stmt 1
	bl	flush_l2p_region
.LVL929:
.L669:
	.loc 2 830 0
	mov	w1, w25
	mov	w0, w22
	bl	load_l2p_region
.LVL930:
	.loc 2 831 0
	b	.L664
.LVL931:
.L668:
	add	x0, x0, 1
	.loc 2 811 0
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L663
.LVL932:
.L664:
	.loc 2 814 0
	ldr	x0, [x21, #:lo12:.LANCHOR55]
	add	x0, x0, x20, lsl 4
	.loc 2 813 0
	cbnz	w24, .L665
	.loc 2 814 0
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x19, lsl 2]
	str	w0, [x23]
.L666:
	.loc 2 820 0
	ldr	x0, [x21, #:lo12:.LANCHOR55]
	add	x20, x0, x20, lsl 4
.LVL933:
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L671
	.loc 2 821 0
	add	w0, w0, 1
	str	w0, [x20, 4]
.L671:
	.loc 2 832 0
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
.LVL934:
	ldp	x21, x22, [sp, 32]
.LVL935:
	ldp	x23, x24, [sp, 48]
.LVL936:
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL937:
.L665:
	.cfi_restore_state
	.loc 2 816 0
	ldr	x1, [x0, 8]
	ldr	w2, [x23]
	str	w2, [x1, x19, lsl 2]
	.loc 2 817 0
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	.loc 2 818 0
	adrp	x0, .LANCHOR56
	strh	w22, [x0, #:lo12:.LANCHOR56]
	b	.L666
	.cfi_endproc
.LFE262:
	.size	log2phys, .-log2phys
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
.LFB280:
	.loc 2 1677 0
	.cfi_startproc
.LVL938:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 1680 0
	adrp	x22, .LANCHOR42
	.loc 2 1677 0
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	.loc 2 1678 0
	lsr	w0, w1, 10
.LVL939:
	.loc 2 1677 0
	str	x23, [sp, 48]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 23, -32
	.loc 2 1678 0
	bl	P2V_block_in_plane
.LVL940:
	.loc 2 1680 0
	ldr	x2, [x22, #:lo12:.LANCHOR42]
	.loc 2 1678 0
	and	w3, w0, 65535
.LVL941:
	.loc 2 1680 0
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L677
	.loc 2 1681 0
	adrp	x0, .LANCHOR47
.LVL942:
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L678
.LBB260:
	.loc 2 1685 0
	adrp	x2, .LANCHOR40
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	.loc 2 1684 0
	adrp	x23, .LANCHOR48
	.loc 2 1685 0
	ldr	x2, [x2, #:lo12:.LANCHOR40]
	.loc 2 1693 0
	mov	w6, 65535
	.loc 2 1684 0
	ldrh	w4, [x23, #:lo12:.LANCHOR48]
.LVL943:
	.loc 2 1685 0
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	.loc 2 1693 0
	mov	w5, 6
	.loc 2 1685 0
	and	w19, w19, 65535
.LVL944:
.L679:
	.loc 2 1686 0 discriminator 1
	cmp	w1, w4
	beq	.L678
	.loc 2 1687 0
	cmp	w19, w3
	bne	.L680
	.loc 2 1688 0
	mov	w1, w19
.LVL945:
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_remove_node
.LVL946:
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cbnz	w0, .L681
	.loc 2 1688 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 1688
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL947:
.L681:
	.loc 2 1688 0 discriminator 3
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR48]
	.loc 2 1689 0 is_stmt 1 discriminator 3
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL948:
	.loc 2 1690 0 discriminator 3
	ldr	x1, [x22, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.LVL949:
.L678:
.LBE260:
	.loc 2 1701 0
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
.LVL950:
	.loc 2 1702 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL951:
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL952:
.L680:
	.cfi_restore_state
.LBB261:
	.loc 2 1693 0
	umull	x19, w19, w5
.LVL953:
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L678
.LVL954:
	.loc 2 1686 0 discriminator 2
	add	w1, w1, 1
.LVL955:
	and	w1, w1, 65535
.LVL956:
	b	.L679
.LVL957:
.L677:
.LBE261:
	.loc 2 1699 0
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L678
	.cfi_endproc
.LFE280:
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
.LFB291:
	.loc 2 2325 0
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	.loc 2 2330 0
	adrp	x0, .LC91
	mov	w1, 0
	add	x0, x0, :lo12:.LC91
	.loc 2 2325 0
	stp	x29, x30, [sp, 16]
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 16
	.cfi_def_cfa 29, 80
	stp	x19, x20, [sp, 32]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.loc 2 2336 0
	adrp	x20, .LANCHOR106
	.loc 2 2325 0
	stp	x21, x22, [sp, 48]
	.loc 2 2331 0
	mov	w19, 0
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	adrp	x21, .LANCHOR61
	.loc 2 2347 0
	add	x22, x20, :lo12:.LANCHOR106
	.loc 2 2331 0
	add	x21, x21, :lo12:.LANCHOR61
	.loc 2 2325 0
	str	x23, [sp, 64]
	.cfi_offset 23, -32
	.loc 2 2330 0
	bl	printf
.LVL958:
.L688:
	.loc 2 2331 0 discriminator 1
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L694
	.loc 2 2353 0
	ldp	x19, x20, [sp, 32]
.LVL959:
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL960:
.L694:
	.cfi_restore_state
	.loc 2 2332 0
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
.LVL961:
	.loc 2 2333 0
	tst	x19, 2047
	bne	.L689
	.loc 2 2334 0
	ldr	w2, [x29, 76]
	adrp	x0, .LC92
	mov	w1, w19
	add	x0, x0, :lo12:.LC92
	bl	printf
.LVL962:
.L689:
	.loc 2 2335 0
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L691
	.loc 2 2336 0
	add	x0, x20, :lo12:.LANCHOR106
	.loc 2 2340 0
	str	wzr, [x20, #:lo12:.LANCHOR106]
	.loc 2 2342 0
	mov	w2, 0
	.loc 2 2336 0
	str	w1, [x0, 4]
	.loc 2 2338 0
	adrp	x1, .LANCHOR107
	.loc 2 2337 0
	str	w19, [x0, 24]
	.loc 2 2338 0
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	str	x1, [x0, 8]
	.loc 2 2339 0
	adrp	x1, .LANCHOR108
	ldr	x23, [x1, #:lo12:.LANCHOR108]
.LVL963:
	.loc 2 2342 0
	mov	w1, 1
	.loc 2 2339 0
	str	x23, [x0, 16]
	.loc 2 2342 0
	bl	FlashReadPages
.LVL964:
	.loc 2 2343 0
	ldr	w0, [x20, #:lo12:.LANCHOR106]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L692
	.loc 2 2344 0
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L691
.L692:
	.loc 2 2347 0
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
.LVL965:
.L691:
	.loc 2 2331 0 discriminator 2
	add	w19, w19, 1
.LVL966:
	b	.L688
	.cfi_endproc
.LFE291:
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.FtlReadRefresh,"ax",@progbits
	.align	2
	.global	FtlReadRefresh
	.type	FtlReadRefresh, %function
FtlReadRefresh:
.LFB318:
	.loc 5 419 0
	.cfi_startproc
.LVL967:
	.loc 5 425 0
	adrp	x1, .LANCHOR81
	add	x0, x1, :lo12:.LANCHOR81
	ldr	w2, [x0, 80]
	cbz	w2, .L697
	.loc 5 426 0
	adrp	x1, .LANCHOR61
	ldr	w3, [x0, 84]
	ldr	w2, [x1, #:lo12:.LANCHOR61]
	cmp	w3, w2
	bcs	.L698
	.loc 5 419 0
	stp	x29, x30, [sp, -160]!
	.cfi_def_cfa_offset 160
	.cfi_offset 29, -160
	.cfi_offset 30, -152
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -144
	.cfi_offset 20, -136
.LBB267:
.LBB268:
	.loc 5 428 0
	mov	x19, x0
	add	x20, x1, :lo12:.LANCHOR61
.LBE268:
.LBE267:
	.loc 5 419 0
	str	x21, [sp, 32]
	.cfi_offset 21, -128
	mov	w21, 2048
.L703:
.LVL968:
.LBB273:
.LBB270:
	.loc 5 428 0
	ldr	w0, [x19, 84]
	ldr	w1, [x20]
	cmp	w0, w1
	bcs	.L700
	.loc 5 430 0
	add	x1, x29, 60
	mov	w2, 0
	bl	log2phys
.LVL969:
	.loc 5 431 0
	ldr	w0, [x19, 84]
	.loc 5 432 0
	ldr	w1, [x29, 60]
	.loc 5 431 0
	add	w0, w0, 1
	str	w0, [x19, 84]
	.loc 5 432 0
	cmn	w1, #1
	beq	.L701
.LBB269:
	.loc 5 435 0
	str	w0, [x29, 88]
	.loc 5 436 0
	adrp	x0, ftl_temp_buf
	add	x0, x0, :lo12:ftl_temp_buf
	str	x0, [x29, 72]
	.loc 5 437 0
	add	x0, x29, 96
	str	x0, [x29, 80]
	.loc 5 438 0
	add	x0, x29, 160
	.loc 5 434 0
	str	w1, [x29, 68]
	.loc 5 439 0
	mov	w2, 0
	mov	w1, 1
	.loc 5 438 0
	str	wzr, [x0, -96]!
	.loc 5 439 0
	bl	FlashReadPages
.LVL970:
	.loc 5 440 0
	ldr	w0, [x29, 64]
	cmp	w0, 256
	bne	.L700
	.loc 5 442 0
	ldr	w0, [x29, 60]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL971:
	bl	FtlGcRefreshBlock
.LVL972:
.L700:
.LBE269:
.LBE270:
.LBE273:
	.loc 5 466 0
	ldp	x19, x20, [sp, 16]
.LBB274:
.LBB271:
	mov	w0, -1
.LBE271:
.LBE274:
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 160
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL973:
.L701:
	.cfi_restore_state
.LBB275:
.LBB272:
	.loc 5 427 0
	subs	w21, w21, #1
.LVL974:
	bne	.L703
	b	.L700
.LVL975:
.L698:
	.cfi_def_cfa 31, 0
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 29
	.cfi_restore 30
.LBE272:
.LBE275:
	.loc 5 451 0
	adrp	x1, .LANCHOR62
	.loc 5 450 0
	str	wzr, [x0, 84]
	.loc 5 451 0
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	.loc 5 449 0
	stp	w1, wzr, [x0, 76]
.L707:
	.loc 5 420 0
	mov	w0, 0
	.loc 5 465 0
	ret
.L697:
.LVL976:
.LBB276:
	.loc 5 456 0
	ldr	w4, [x0, 76]
	adrp	x0, .LANCHOR62
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	add	w0, w2, 1048576
	cmp	w4, w0
	bhi	.L706
	.loc 5 454 0
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	lsr	w3, w0, 10
	mov	w0, 33554432
	asr	w0, w0, w3
	.loc 5 457 0
	add	w0, w0, w4
	cmp	w2, w0
	bhi	.L706
	.loc 5 458 0
	adrp	x0, .LANCHOR39+28
	ldrb	w0, [x0, #:lo12:.LANCHOR39+28]
	cbnz	w0, .L707
.L706:
	.loc 5 460 0
	add	x0, x1, :lo12:.LANCHOR81
	mov	w1, 1
	.loc 5 461 0
	str	wzr, [x0, 84]
	.loc 5 460 0
	stp	w2, w1, [x0, 76]
	b	.L707
.LBE276:
	.cfi_endproc
.LFE318:
	.size	FtlReadRefresh, .-FtlReadRefresh
	.section	.text.FtlMapBlkWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDump_data
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
.LFB267:
	.loc 2 946 0
	.cfi_startproc
.LVL977:
	.loc 2 952 0
	ldr	w1, [x0, 56]
	cbz	w1, .L713
	.loc 2 946 0
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
.LVL978:
	.loc 2 956 0
	adrp	x1, .LANCHOR106
	.loc 2 957 0
	adrp	x2, .LANCHOR108
	.loc 2 946 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	.loc 2 948 0
	ldrh	w20, [x0, 6]
	.loc 2 956 0
	adrp	x0, .LANCHOR123
.LVL979:
	.loc 2 957 0
	ldr	x2, [x2, #:lo12:.LANCHOR108]
	.loc 2 956 0
	ldr	x3, [x0, #:lo12:.LANCHOR123]
	add	x0, x1, :lo12:.LANCHOR106
	.loc 2 948 0
	sub	w20, w20, #1
	.loc 2 949 0
	ldr	x4, [x19, 40]
	.loc 2 948 0
	and	w20, w20, 65535
	.loc 2 946 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 957 0
	stp	x3, x2, [x0, 8]
	.loc 2 979 0
	ubfiz	x2, x20, 2, 16
	.loc 2 954 0
	str	wzr, [x19, 56]
	mov	x21, x1
	.loc 2 979 0
	ldr	w2, [x4, x2]
.LVL980:
	.loc 2 980 0
	str	w2, [x0, 4]
	.loc 2 981 0
	cbz	w2, .L715
	.loc 2 983 0
	mov	w2, 1
.LVL981:
	mov	w1, w2
	bl	FlashReadPages
.LVL982:
.L716:
	.loc 2 990 0
	add	x1, x21, :lo12:.LANCHOR106
	mov	x0, x19
	.loc 2 992 0
	ldr	x21, [sp, 32]
	.loc 2 990 0
	ldr	x2, [x1, 8]
	mov	w1, w20
	.loc 2 992 0
	ldp	x19, x20, [sp, 16]
.LVL983:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	.loc 2 990 0
	b	FtlMapWritePage
.LVL984:
.L715:
	.cfi_restore_state
	.loc 2 987 0
	adrp	x0, .LANCHOR23
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR23]
.LVL985:
	mov	x0, x3
	bl	ftl_memset
.LVL986:
	b	.L716
.LVL987:
.L713:
	.cfi_def_cfa 31, 0
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 29
	.cfi_restore 30
	ret
	.cfi_endproc
.LFE267:
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
	.section	.text.FtlScanSysBlk,"ax",@progbits
	.align	2
	.global	FtlScanSysBlk
	.type	FtlScanSysBlk, %function
FtlScanSysBlk:
.LFB270:
	.loc 2 1144 0
	.cfi_startproc
	stp	x29, x30, [sp, -176]!
	.cfi_def_cfa_offset 176
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	.loc 2 1152 0
	mov	w1, 0
	.loc 2 1144 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	.loc 2 1152 0
	adrp	x25, .LANCHOR135
	.loc 2 1144 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	.loc 2 1152 0
	adrp	x21, .LANCHOR30
	ldr	x0, [x25, #:lo12:.LANCHOR135]
	.loc 2 1154 0
	adrp	x22, .LANCHOR132
	.loc 2 1152 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	.loc 2 1144 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	.loc 2 1150 0
	adrp	x20, .LANCHOR147
	.loc 2 1144 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	.loc 2 1151 0
	adrp	x23, .LANCHOR35
	.loc 2 1144 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	.loc 2 1153 0
	adrp	x27, .LANCHOR129
	.loc 2 1152 0
	lsl	w2, w2, 2
	.loc 2 1150 0
	strh	wzr, [x20, #:lo12:.LANCHOR147]
	.loc 2 1151 0
	strh	wzr, [x23, #:lo12:.LANCHOR35]
	.loc 2 1152 0
	bl	ftl_memset
.LVL988:
	.loc 2 1153 0
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	.loc 2 1154 0
	adrp	x19, .LANCHOR27
	.loc 2 1155 0
	adrp	x28, .LANCHOR36
	.loc 2 1156 0
	adrp	x24, .LANCHOR79
	.loc 2 1153 0
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL989:
	.loc 2 1154 0
	ldr	x0, [x22, #:lo12:.LANCHOR132]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 2
	bl	ftl_memset
.LVL990:
	.loc 2 1155 0
	ldr	x0, [x28, #:lo12:.LANCHOR36]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL991:
	.loc 2 1156 0
	mov	w2, 12
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR79
	bl	ftl_memset
.LVL992:
	.loc 2 1158 0
	adrp	x0, .LANCHOR5
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	str	w0, [x29, 172]
.LVL993:
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 120]
	.loc 2 1201 0
	adrp	x0, .LANCHOR70
	add	x0, x0, :lo12:.LANCHOR70
	str	x0, [x29, 112]
.L721:
	.loc 2 1158 0 discriminator 1
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L761
	.loc 2 1162 0 discriminator 1
	adrp	x0, .LANCHOR3
	.loc 2 1167 0 discriminator 1
	adrp	x25, .LANCHOR120
	.loc 2 1164 0 discriminator 1
	adrp	x6, .LANCHOR13
	.loc 2 1169 0 discriminator 1
	mov	x5, 0
	.loc 2 1162 0 discriminator 1
	ldrh	w12, [x0, #:lo12:.LANCHOR3]
	.loc 2 1168 0 discriminator 1
	adrp	x0, .LANCHOR91
	.loc 2 1167 0 discriminator 1
	ldr	x7, [x25, #:lo12:.LANCHOR120]
	.loc 2 1169 0 discriminator 1
	mov	w22, 0
	.loc 2 1168 0 discriminator 1
	ldr	x11, [x0, #:lo12:.LANCHOR91]
	.loc 2 1169 0 discriminator 1
	adrp	x0, .LANCHOR92
	.loc 2 1164 0 discriminator 1
	add	x6, x6, :lo12:.LANCHOR13
	.loc 2 1169 0 discriminator 1
	ldr	x10, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x0, #:lo12:.LANCHOR24]
	b	.L762
.LVL994:
.L723:
	.loc 2 1164 0
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
.LVL995:
	and	w4, w0, 65535
.LVL996:
	.loc 2 1165 0
	bl	FtlBbmIsBadBlock
.LVL997:
	cbnz	w0, .L722
	.loc 2 1167 0
	ubfiz	x0, x22, 5, 16
	.loc 2 1169 0
	mul	w1, w22, w8
	.loc 2 1167 0
	add	x0, x7, x0
	.loc 2 1170 0
	add	w22, w22, 1
.LVL998:
	and	w22, w22, 65535
.LVL999:
	.loc 2 1167 0
	lsl	w4, w4, 10
.LVL1000:
	.loc 2 1169 0
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	.loc 2 1167 0
	str	w4, [x0, 4]
	.loc 2 1169 0
	stp	x11, x1, [x0, 8]
.L722:
.LVL1001:
	add	x5, x5, 1
.LVL1002:
.L762:
	.loc 2 1162 0 discriminator 1
	cmp	w12, w5, uxth
	bhi	.L723
	.loc 2 1173 0
	cbnz	w22, .L724
.LVL1003:
.L760:
	.loc 2 1158 0
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
.LVL1004:
	b	.L721
.LVL1005:
.L724:
	.loc 2 1176 0
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
.LVL1006:
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
.LVL1007:
	str	x0, [x29, 128]
.LVL1008:
	.loc 2 1211 0
	adrp	x0, .LANCHOR148
	add	x0, x0, :lo12:.LANCHOR148
	str	x0, [x29, 136]
.L759:
	.loc 2 1178 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x1, x0, x22
	.loc 2 1181 0
	ldr	w0, [x0, x22]
	.loc 2 1178 0
	ldr	w3, [x1, 4]
	.loc 2 1181 0
	cmn	w0, #1
	.loc 2 1179 0
	ldr	x27, [x1, 16]
	.loc 2 1178 0
	ubfx	x26, x3, 10, 16
.LVL1009:
	.loc 2 1181 0
	bne	.L727
	mov	w5, 16
	.loc 2 1185 0
	mov	w7, 65535
.L729:
	.loc 2 1183 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x6, x25, :lo12:.LANCHOR120
	.loc 2 1184 0
	mov	w2, 1
	str	w7, [x29, 100]
	.loc 2 1183 0
	add	x0, x0, x22
	str	x6, [x29, 104]
	str	w5, [x29, 168]
.LVL1010:
	ldr	w1, [x0, 4]
	add	w1, w1, 1
	str	w1, [x0, 4]
	.loc 2 1184 0
	mov	w1, w2
	bl	FlashReadPages
.LVL1011:
	.loc 2 1185 0
	ldrh	w0, [x27]
	ldr	w7, [x29, 100]
	ldr	w5, [x29, 168]
	cmp	w0, w7
	ldr	x6, [x29, 104]
	bne	.L726
	.loc 2 1186 0
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	.loc 2 1194 0
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	bne	.L727
.LVL1012:
.L728:
	.loc 2 1336 0
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.LVL1013:
	b	.L732
.LVL1014:
.L726:
	.loc 2 1188 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L727
.LVL1015:
	sub	w5, w5, #1
.LVL1016:
	.loc 2 1182 0 discriminator 2
	ands	w5, w5, 65535
	bne	.L729
	b	.L728
.L727:
	.loc 2 1196 0
	adrp	x0, .LANCHOR70
	ldr	w1, [x0, #:lo12:.LANCHOR70]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L730
	.loc 2 1196 0 is_stmt 0 discriminator 1
	cmp	w1, w0
	bhi	.L731
.L730:
	.loc 2 1198 0 is_stmt 1
	cmn	w0, #1
	beq	.L731
	.loc 2 1201 0
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L731:
	.loc 2 1206 0
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L733
	bhi	.L734
	mov	w0, 61574
	cmp	w1, w0
	beq	.L735
.L732:
	.loc 2 1177 0 discriminator 2
	ldr	x0, [x29, 128]
	add	x22, x22, 32
	cmp	x0, x22
	bne	.L759
	b	.L760
.L734:
	.loc 2 1206 0
	mov	w0, 61634
	cmp	w1, w0
	beq	.L736
	mov	w0, 65535
	cmp	w1, w0
	beq	.L728
	b	.L732
.L736:
	.loc 2 1211 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L738
	.loc 2 1211 0 is_stmt 0 discriminator 1
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1211
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1017:
.L738:
	.loc 2 1212 0 is_stmt 1
	ldr	w6, [x21, #:lo12:.LANCHOR30]
	.loc 2 1214 0
	ldr	x3, [x29, 152]
	.loc 2 1212 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
.LVL1018:
	sub	w2, w2, #1
	.loc 2 1214 0
	ldr	x5, [x3, #:lo12:.LANCHOR135]
	.loc 2 1212 0
	sxth	w2, w2
.L739:
	.loc 2 1212 0 is_stmt 0 discriminator 1
	cmp	w0, w2
	bgt	.L745
	.loc 2 1235 0 is_stmt 1
	tbz	w0, #31, .L779
	b	.L732
.L745:
	.loc 2 1214 0
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L740
	.loc 2 1216 0
	ldr	w2, [x5]
	cbnz	w2, .L741
	.loc 2 1216 0 is_stmt 0 discriminator 1
	cmp	w6, w1
	beq	.L741
	.loc 2 1221 0 is_stmt 1
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
.L741:
	.loc 2 1227 0 discriminator 1
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L742:
.LVL1019:
	.loc 2 1224 0 discriminator 1
	cmp	w1, w0
	bne	.L743
	.loc 2 1229 0
	ldr	w1, [x27, 4]
.LVL1020:
	str	w1, [x10]
	.loc 2 1230 0
	strh	w26, [x6, x8, lsl 1]
	.loc 2 1235 0
	tbnz	w0, #31, .L732
	.loc 2 1242 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L732
.L779:
	.loc 2 1244 0
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
	.loc 2 1245 0
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	.loc 2 1246 0
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L797:
	.loc 2 1290 0
	strh	w26, [x1, x0, lsl 1]
	b	.L732
.LVL1021:
.L743:
	.loc 2 1226 0 discriminator 3
	sxtw	x2, w1
	add	w1, w1, 1
.LVL1022:
	lsl	x7, x2, 2
	.loc 2 1227 0 discriminator 3
	lsl	x2, x2, 1
	.loc 2 1226 0 discriminator 3
	add	x11, x5, x7
	sxth	w1, w1
.LVL1023:
	ldr	w11, [x11, 4]
	str	w11, [x5, x7]
	.loc 2 1227 0 discriminator 3
	add	x7, x6, x2
	ldrh	w7, [x7, 2]
	strh	w7, [x6, x2]
	b	.L742
.LVL1024:
.L740:
	sub	w0, w0, #1
.LVL1025:
	sxth	x0, w0
.LVL1026:
	b	.L739
.LVL1027:
.L735:
	.loc 2 1252 0
	ldrh	w1, [x23, #:lo12:.LANCHOR35]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	cmp	w1, w0
	bls	.L748
	.loc 2 1252 0 is_stmt 0 discriminator 1
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1252
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1028:
.L748:
	.loc 2 1253 0 is_stmt 1
	ldrh	w6, [x19, #:lo12:.LANCHOR27]
	ldrh	w2, [x23, #:lo12:.LANCHOR35]
	sub	w1, w6, #1
	sxth	x0, w1
.LVL1029:
	sub	w5, w1, w2
	.loc 2 1255 0
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
.L749:
	.loc 2 1253 0 discriminator 1
	cmp	w0, w5
	ble	.L754
	.loc 2 1255 0
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L750
	.loc 2 1257 0
	ldr	w5, [x1]
	cbnz	w5, .L751
	.loc 2 1257 0 is_stmt 0 discriminator 1
	cmp	w6, w2
	beq	.L751
	.loc 2 1265 0 is_stmt 1
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR35]
.L751:
	.loc 2 1270 0 discriminator 1
	ldr	x6, [x28, #:lo12:.LANCHOR36]
	mov	w2, 0
.L752:
.LVL1030:
	.loc 2 1267 0 discriminator 1
	cmp	w2, w0
	bne	.L753
	.loc 2 1272 0
	ldr	w2, [x27, 4]
.LVL1031:
	str	w2, [x10]
	.loc 2 1273 0
	strh	w26, [x6, x7, lsl 1]
.L754:
	.loc 2 1278 0
	tbnz	w0, #31, .L732
	.loc 2 1286 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	ldrh	w5, [x23, #:lo12:.LANCHOR35]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L732
	.loc 2 1288 0
	add	w5, w5, 1
	.loc 2 1289 0
	ldr	w2, [x27, 4]
	.loc 2 1288 0
	strh	w5, [x23, #:lo12:.LANCHOR35]
	.loc 2 1289 0
	str	w2, [x1, x0, lsl 2]
	.loc 2 1290 0
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	b	.L797
.LVL1032:
.L753:
	.loc 2 1269 0 discriminator 3
	sxtw	x5, w2
	add	w2, w2, 1
.LVL1033:
	lsl	x8, x5, 2
	.loc 2 1270 0 discriminator 3
	lsl	x5, x5, 1
	.loc 2 1269 0 discriminator 3
	add	x11, x1, x8
	sxth	w2, w2
.LVL1034:
	ldr	w11, [x11, 4]
	str	w11, [x1, x8]
	.loc 2 1270 0 discriminator 3
	add	x8, x6, x5
	ldrh	w8, [x8, 2]
	strh	w8, [x6, x5]
	b	.L752
.LVL1035:
.L750:
	sub	w0, w0, #1
.LVL1036:
	sxth	x0, w0
.LVL1037:
	b	.L749
.LVL1038:
.L733:
	.loc 2 1297 0
	ldrh	w5, [x24, #:lo12:.LANCHOR79]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR79
	cmp	w5, w1
	bne	.L756
	.loc 2 1299 0
	strh	w26, [x24, #:lo12:.LANCHOR79]
	.loc 2 1300 0
	str	w0, [x2, 8]
	b	.L732
.L756:
	.loc 2 1304 0
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L757
	.loc 2 1305 0
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.LVL1039:
.L757:
	.loc 2 1306 0
	add	x0, x24, :lo12:.LANCHOR79
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L758
	.loc 2 1308 0
	ldrh	w2, [x24, #:lo12:.LANCHOR79]
	strh	w2, [x0, 4]
	.loc 2 1309 0
	strh	w26, [x24, #:lo12:.LANCHOR79]
	.loc 2 1310 0
	str	w1, [x0, 8]
	b	.L732
.L758:
	.loc 2 1314 0
	strh	w26, [x0, 4]
	b	.L732
.LVL1040:
.L761:
	.loc 2 1341 0
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L763
.L766:
	.loc 2 1359 0
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	ldrh	w0, [x1]
	cbz	w0, .L764
.L765:
	.loc 2 1377 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L795
	.loc 2 1377 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR148
	adrp	x0, .LC1
	mov	w2, 1377
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1041:
.L795:
	.loc 2 1379 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
.LVL1042:
	ret
.LVL1043:
.L763:
	.cfi_restore_state
	.loc 2 1341 0 discriminator 1
	ldrh	w0, [x20, #:lo12:.LANCHOR147]
	cbz	w0, .L766
	.loc 2 1343 0 discriminator 1
	ldr	w1, [x21, #:lo12:.LANCHOR30]
	mov	w0, 0
.L767:
.LVL1044:
	cmp	w0, w1
	bcs	.L766
	.loc 2 1345 0
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L768
	.loc 2 1350 0
	ldr	x1, [x29, 152]
	.loc 2 1347 0
	add	x7, x21, :lo12:.LANCHOR30
	.loc 2 1350 0
	ldr	x4, [x1, #:lo12:.LANCHOR135]
	mov	w1, w0
.L769:
.LVL1045:
	.loc 2 1347 0 discriminator 1
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L766
	.loc 2 1349 0 discriminator 3
	sxtw	x6, w1
	sub	w3, w1, w0
	lsl	x5, x6, 1
	sxtw	x3, w3
	add	w1, w1, 1
.LVL1046:
	.loc 2 1350 0 discriminator 3
	ldr	w6, [x4, x6, lsl 2]
	sxth	w1, w1
.LVL1047:
	.loc 2 1349 0 discriminator 3
	ldrh	w8, [x2, x5]
	strh	w8, [x2, x3, lsl 1]
	.loc 2 1350 0 discriminator 3
	str	w6, [x4, x3, lsl 2]
	.loc 2 1351 0 discriminator 3
	strh	wzr, [x2, x5]
	b	.L769
.LVL1048:
.L768:
	add	w0, w0, 1
.LVL1049:
	sxth	w0, w0
.LVL1050:
	b	.L767
.LVL1051:
.L764:
	.loc 2 1359 0 discriminator 1
	ldrh	w0, [x23, #:lo12:.LANCHOR35]
	cbz	w0, .L765
	.loc 2 1361 0 discriminator 1
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	mov	w0, 0
.L774:
.LVL1052:
	mov	w6, w0
	cmp	w0, w2
	bge	.L765
	.loc 2 1363 0
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L775
	.loc 2 1368 0
	ldr	x2, [x29, 144]
	.loc 2 1365 0
	add	x19, x19, :lo12:.LANCHOR27
	.loc 2 1368 0
	ldr	x3, [x2, #:lo12:.LANCHOR132]
.LVL1053:
.L776:
	.loc 2 1365 0 discriminator 1
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L765
	.loc 2 1367 0 discriminator 3
	sxtw	x5, w0
	sub	w2, w0, w6
	lsl	x4, x5, 1
	sxtw	x2, w2
	add	w0, w0, 1
.LVL1054:
	.loc 2 1368 0 discriminator 3
	ldr	w5, [x3, x5, lsl 2]
	sxth	w0, w0
.LVL1055:
	.loc 2 1367 0 discriminator 3
	ldrh	w7, [x1, x4]
	strh	w7, [x1, x2, lsl 1]
	.loc 2 1368 0 discriminator 3
	str	w5, [x3, x2, lsl 2]
	.loc 2 1369 0 discriminator 3
	strh	wzr, [x1, x4]
	b	.L776
.LVL1056:
.L775:
	add	w0, w0, 1
.LVL1057:
	sxth	w0, w0
.LVL1058:
	b	.L774
	.cfi_endproc
.LFE270:
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
.LFB275:
	.loc 2 1515 0
	.cfi_startproc
.LVL1059:
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	.loc 2 1526 0
	mov	w1, 0
	.loc 2 1515 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.loc 2 1527 0
	adrp	x20, .LANCHOR106
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	.loc 2 1522 0
	ldrh	w23, [x0, 6]
	.loc 2 1560 0
	adrp	x24, .LANCHOR20
	.loc 2 1515 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 2 1519 0
	ldr	x21, [x0, 40]
.LVL1060:
	.loc 2 1520 0
	ldr	x22, [x0, 16]
.LVL1061:
	.loc 2 1526 0
	lsl	w2, w23, 2
	.loc 2 1521 0
	ldr	x0, [x0, 24]
.LVL1062:
	str	x0, [x29, 128]
.LVL1063:
	.loc 2 1523 0
	ldrh	w0, [x19, 8]
.LVL1064:
	.loc 2 1515 0
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	.cfi_offset 27, -64
	.cfi_offset 28, -56
	.loc 2 1535 0
	mov	w27, 0
	.loc 2 1523 0
	str	w0, [x29, 140]
.LVL1065:
	.loc 2 1526 0
	mov	x0, x21
	bl	ftl_memset
.LVL1066:
	str	x20, [x29, 120]
	.loc 2 1527 0
	adrp	x7, .LANCHOR107
	add	x3, x20, :lo12:.LANCHOR106
	mov	x26, x7
	.loc 2 1559 0
	mov	x20, x3
	.loc 2 1527 0
	ldr	x0, [x7, #:lo12:.LANCHOR107]
	str	x0, [x3, 8]
	.loc 2 1528 0
	adrp	x0, .LANCHOR108
	.loc 2 1532 0
	stp	wzr, wzr, [x19, 48]
	.loc 2 1528 0
	ldr	x25, [x0, #:lo12:.LANCHOR108]
	.loc 2 1530 0
	mov	w0, -1
	.loc 2 1528 0
	str	x25, [x3, 16]
.LVL1067:
	.loc 2 1530 0
	strh	w0, [x19]
	.loc 2 1531 0
	strh	w0, [x19, 2]
	.loc 2 1534 0
	mov	w0, 1
	str	w0, [x19, 56]
.LVL1068:
	.loc 2 1537 0
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	str	w0, [x29, 136]
	.loc 2 1579 0
	add	x0, x24, :lo12:.LANCHOR20
	str	x0, [x29, 112]
.LVL1069:
.L799:
	.loc 2 1535 0 discriminator 1
	ldr	w0, [x29, 140]
	cmp	w27, w0
	bge	.L816
	.loc 2 1537 0
	ldr	w0, [x29, 136]
	sxtw	x28, w27
	cmp	w27, w0
	bne	.L800
	.loc 2 1539 0
	lsl	x0, x28, 1
	mov	w1, 1
	add	x24, x22, x0
	ldrh	w0, [x22, x0]
	.loc 2 1543 0
	mov	w22, 0
.LVL1070:
	.loc 2 1539 0
	bl	FtlGetLastWrittenPage
.LVL1071:
	sxth	w26, w0
.LVL1072:
	.loc 2 1540 0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 1542 0
	ldr	x0, [x29, 128]
	.loc 2 1541 0
	strh	w27, [x19]
	.loc 2 1542 0
	ldr	w0, [x0, x28, lsl 2]
	str	w0, [x19, 48]
.LVL1073:
	.loc 2 1545 0
	ldr	x0, [x29, 120]
	add	x20, x0, :lo12:.LANCHOR106
.LVL1074:
.L801:
	.loc 2 1543 0 discriminator 1
	cmp	w22, w26
	ble	.L803
.LVL1075:
.L816:
	.loc 2 1596 0
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
.LVL1076:
	.loc 2 1597 0
	adrp	x0, .LANCHOR20
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bne	.L805
	.loc 2 1599 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL1077:
.L805:
	.loc 2 1602 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL1078:
	.loc 2 1604 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL1079:
	.loc 2 1606 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL1080:
	ldp	x21, x22, [sp, 32]
.LVL1081:
	ldp	x23, x24, [sp, 48]
.LVL1082:
	ldp	x25, x26, [sp, 64]
.LVL1083:
	ldp	x27, x28, [sp, 80]
.LVL1084:
	ldp	x29, x30, [sp], 144
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
.LVL1085:
	ret
.LVL1086:
.L803:
	.cfi_restore_state
	.loc 2 1545 0
	ldrh	w0, [x24]
	.loc 2 1546 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 1545 0
	orr	w0, w22, w0, lsl 10
	str	w0, [x20, 4]
	.loc 2 1546 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1087:
	.loc 2 1549 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L802
	.loc 2 1551 0
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L802
	.loc 2 1551 0 is_stmt 0 discriminator 1
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L802
	.loc 2 1553 0 is_stmt 1
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L802:
	add	w22, w22, 1
.LVL1088:
	sxth	w22, w22
.LVL1089:
	b	.L801
.LVL1090:
.L800:
	.loc 2 1559 0
	ldr	x0, [x26, #:lo12:.LANCHOR107]
	.loc 2 1561 0
	mov	w2, 1
	.loc 2 1559 0
	str	x0, [x20, 8]
	.loc 2 1560 0
	lsl	x0, x28, 1
	ldrh	w1, [x24, #:lo12:.LANCHOR20]
	add	x28, x22, x0
	ldrh	w0, [x22, x0]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	.loc 2 1561 0
	mov	w1, w2
	.loc 2 1560 0
	str	w0, [x20, 4]
	.loc 2 1561 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1091:
	.loc 2 1564 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L818
	.loc 2 1564 0 is_stmt 0 discriminator 1
	ldrh	w1, [x25]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L818
	.loc 2 1564 0 discriminator 2
	ldrh	w1, [x25, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L807
.L818:
	mov	w5, 0
.L808:
.LVL1092:
	.loc 2 1579 0 is_stmt 1 discriminator 1
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L814
	.loc 2 1581 0
	ldrh	w0, [x28]
	.loc 2 1582 0
	mov	w2, 1
	.loc 2 1581 0
	str	w5, [x29, 108]
	.loc 2 1582 0
	mov	w1, w2
	.loc 2 1581 0
	orr	w0, w5, w0, lsl 10
	str	w0, [x20, 4]
	.loc 2 1582 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1093:
	.loc 2 1585 0
	ldr	w0, [x20]
	ldr	w5, [x29, 108]
	cmn	w0, #1
	beq	.L812
	.loc 2 1587 0
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L812
	.loc 2 1587 0 is_stmt 0 discriminator 1
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L812
	.loc 2 1589 0 is_stmt 1
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L812:
	add	w5, w5, 1
	sxth	w5, w5
.LVL1094:
	b	.L808
.LVL1095:
.L807:
	.loc 2 1567 0 discriminator 1
	ldrh	w5, [x24, #:lo12:.LANCHOR20]
	.loc 2 1569 0 discriminator 1
	mov	w0, 0
	ldr	x10, [x26, #:lo12:.LANCHOR107]
	.loc 2 1567 0 discriminator 1
	sub	w5, w5, #1
.L809:
.LVL1096:
	cmp	w0, w5
	blt	.L811
.LVL1097:
.L814:
	add	w4, w27, 1
	sxth	w27, w4
.LVL1098:
	b	.L799
.LVL1099:
.L811:
	.loc 2 1569 0
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
.LVL1100:
	.loc 2 1570 0
	cmp	w23, w1
	bls	.L810
	.loc 2 1572 0
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
.LVL1101:
	ldr	w2, [x10, x2, lsl 2]
.LVL1102:
	str	w2, [x21, x1]
.LVL1103:
.L810:
	add	w0, w0, 1
.LVL1104:
	sxth	w0, w0
.LVL1105:
	b	.L809
	.cfi_endproc
.LFE275:
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
.LFB276:
	.loc 2 1609 0
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 2 1610 0
	adrp	x1, .LANCHOR27
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	.loc 2 1609 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 1610 0
	ldrh	w1, [x1, #:lo12:.LANCHOR27]
	strh	w1, [x0, 10]
	.loc 2 1611 0
	mov	w1, -3962
	strh	w1, [x0, 4]
	.loc 2 1612 0
	adrp	x1, .LANCHOR35
	ldrh	w1, [x1, #:lo12:.LANCHOR35]
	strh	w1, [x0, 8]
	.loc 2 1613 0
	adrp	x1, .LANCHOR28
	ldrh	w1, [x1, #:lo12:.LANCHOR28]
	strh	w1, [x0, 6]
	.loc 2 1614 0
	adrp	x1, .LANCHOR36
	ldr	x1, [x1, #:lo12:.LANCHOR36]
	str	x1, [x0, 16]
	.loc 2 1615 0
	adrp	x1, .LANCHOR132
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	str	x1, [x0, 24]
	.loc 2 1616 0
	adrp	x1, .LANCHOR131
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	str	x1, [x0, 32]
	.loc 2 1617 0
	adrp	x1, .LANCHOR133
	ldr	x1, [x1, #:lo12:.LANCHOR133]
	str	x1, [x0, 40]
	.loc 2 1619 0
	bl	FtlMapTblRecovery
.LVL1106:
	.loc 2 1622 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE276:
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.FtlL2PDataInit,"ax",@progbits
	.align	2
	.global	FtlL2PDataInit
	.type	FtlL2PDataInit, %function
FtlL2PDataInit:
.LFB277:
	.loc 2 1625 0
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 1627 0
	mov	w1, 0
	.loc 2 1625 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 2 1627 0
	adrp	x19, .LANCHOR130
	adrp	x20, .LANCHOR30
	.loc 2 1625 0
	stp	x21, x22, [sp, 32]
	.loc 2 1627 0
	ldr	x0, [x19, #:lo12:.LANCHOR130]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.loc 2 1628 0
	adrp	x22, .LANCHOR23
	.loc 2 1627 0
	ldr	w2, [x20, #:lo12:.LANCHOR30]
	.loc 2 1628 0
	adrp	x21, .LANCHOR33
	.loc 2 1625 0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	.loc 2 1628 0
	adrp	x23, .LANCHOR136
	.loc 2 1627 0
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1107:
	.loc 2 1628 0
	ldrh	w0, [x21, #:lo12:.LANCHOR33]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR23]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR136]
	bl	ftl_memset
.LVL1108:
	adrp	x0, .LANCHOR55
	ldrh	w3, [x21, #:lo12:.LANCHOR33]
	.loc 2 1633 0
	ldr	x6, [x23, #:lo12:.LANCHOR136]
	.loc 2 1629 0
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR55]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR23]
	add	x3, x0, x3, lsl 4
.LVL1109:
.L829:
	add	x4, x1, x5
	.loc 2 1629 0 is_stmt 0 discriminator 1
	cmp	x0, x3
	bne	.L830
	.loc 2 1635 0 is_stmt 1
	adrp	x1, .LANCHOR144
	add	x0, x1, :lo12:.LANCHOR144
	.loc 2 1645 0
	ldp	x21, x22, [sp, 32]
	.loc 2 1636 0
	strh	w2, [x1, #:lo12:.LANCHOR144]
	.loc 2 1637 0
	ldr	w1, [x20, #:lo12:.LANCHOR30]
	strh	w1, [x0, 10]
	.loc 2 1638 0
	mov	w1, -3902
	strh	w1, [x0, 4]
	.loc 2 1639 0
	adrp	x1, .LANCHOR147
	.loc 2 1645 0
	ldr	x23, [sp, 48]
	.loc 2 1635 0
	strh	w2, [x0, 2]
	.loc 2 1639 0
	ldrh	w1, [x1, #:lo12:.LANCHOR147]
	strh	w1, [x0, 8]
	.loc 2 1640 0
	adrp	x1, .LANCHOR32
	ldrh	w1, [x1, #:lo12:.LANCHOR32]
	strh	w1, [x0, 6]
	.loc 2 1641 0
	adrp	x1, .LANCHOR129
	ldr	x1, [x1, #:lo12:.LANCHOR129]
	str	x1, [x0, 16]
	.loc 2 1642 0
	adrp	x1, .LANCHOR135
	ldr	x1, [x1, #:lo12:.LANCHOR135]
	str	x1, [x0, 24]
	.loc 2 1643 0
	ldr	x1, [x19, #:lo12:.LANCHOR130]
	.loc 2 1645 0
	ldp	x19, x20, [sp, 16]
	.loc 2 1643 0
	str	x1, [x0, 32]
	.loc 2 1644 0
	adrp	x1, .LANCHOR134
	ldr	x1, [x1, #:lo12:.LANCHOR134]
	str	x1, [x0, 40]
	.loc 2 1645 0
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L830:
	.cfi_restore_state
	.loc 2 1633 0 discriminator 3
	and	x1, x1, -4
	.loc 2 1632 0 discriminator 3
	strh	w2, [x0]
	.loc 2 1633 0 discriminator 3
	add	x1, x6, x1
	.loc 2 1631 0 discriminator 3
	str	wzr, [x0, 4]
	.loc 2 1633 0 discriminator 3
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L829
	.cfi_endproc
.LFE277:
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlLoadMapInfo,"ax",@progbits
	.align	2
	.global	FtlLoadMapInfo
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
.LFB278:
	.loc 2 1648 0
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 1649 0
	bl	FtlL2PDataInit
.LVL1110:
	.loc 2 1651 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapTblRecovery
.LVL1111:
	.loc 2 1654 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE278:
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
.LFB207:
	.loc 3 494 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 3 497 0
	adrp	x0, .LANCHOR150
	mov	w1, -1
	.loc 3 494 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 497 0
	strh	w1, [x0, #:lo12:.LANCHOR150]
	.loc 3 498 0
	adrp	x0, .LANCHOR151
	.loc 3 500 0
	mov	w1, -1
	.loc 3 494 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 3 498 0
	str	wzr, [x0, #:lo12:.LANCHOR151]
	.loc 3 499 0
	adrp	x0, .LANCHOR152
	.loc 3 503 0
	adrp	x19, .LANCHOR6
	.loc 3 499 0
	str	wzr, [x0, #:lo12:.LANCHOR152]
	.loc 3 500 0
	adrp	x0, .LANCHOR153
	str	w1, [x0, #:lo12:.LANCHOR153]
	.loc 3 501 0
	adrp	x0, .LANCHOR35
	.loc 3 502 0
	mov	w1, 0
	.loc 3 501 0
	strh	wzr, [x0, #:lo12:.LANCHOR35]
	.loc 3 502 0
	adrp	x0, .LANCHOR27
	ldrh	w2, [x0, #:lo12:.LANCHOR27]
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1112:
	.loc 3 503 0
	adrp	x0, .LANCHOR43
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1113:
	.loc 3 504 0
	adrp	x0, .LANCHOR126
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1114:
	.loc 3 505 0
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR39
	add	x0, x0, :lo12:.LANCHOR39
	bl	ftl_memset
.LVL1115:
	.loc 3 506 0
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	bl	ftl_memset
.LVL1116:
	.loc 3 507 0
	bl	FtlGcBufInit
.LVL1117:
	.loc 3 508 0
	bl	FtlL2PDataInit
.LVL1118:
	.loc 3 510 0
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE207:
	.size	FtlVariablesInit, .-FtlVariablesInit
	.section	.text.SupperBlkListInit,"ax",@progbits
	.align	2
	.global	SupperBlkListInit
	.type	SupperBlkListInit, %function
SupperBlkListInit:
.LFB285:
	.loc 2 2116 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 2120 0
	adrp	x0, .LANCHOR6
	mov	w1, 0
	.loc 2 2116 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2120 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	mov	w0, 6
	.loc 2 2116 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 2 2120 0
	adrp	x24, .LANCHOR40
	.loc 2 2116 0
	stp	x19, x20, [sp, 16]
	.loc 2 2124 0
	adrp	x23, .LANCHOR45
	.loc 2 2116 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 2125 0
	adrp	x22, .LANCHOR48
	.loc 2 2120 0
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	.loc 2 2116 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.loc 2 2128 0
	adrp	x25, .LANCHOR5
	.loc 2 2116 0
	str	x27, [sp, 80]
	.cfi_offset 27, -16
	.loc 2 2131 0
	adrp	x26, .LANCHOR13
	.loc 2 2128 0
	add	x25, x25, :lo12:.LANCHOR5
	.loc 2 2131 0
	add	x26, x26, :lo12:.LANCHOR13
	.loc 2 2120 0
	bl	ftl_memset
.LVL1119:
	.loc 2 2126 0
	mov	w21, 0
	.loc 2 2121 0
	adrp	x0, .LANCHOR47
	.loc 2 2126 0
	mov	w20, 0
	.loc 2 2128 0
	mov	w19, 0
	.loc 2 2124 0
	strh	wzr, [x23, #:lo12:.LANCHOR45]
	.loc 2 2121 0
	str	xzr, [x0, #:lo12:.LANCHOR47]
	.loc 2 2122 0
	adrp	x0, .LANCHOR41
	.loc 2 2125 0
	strh	wzr, [x22, #:lo12:.LANCHOR48]
.LVL1120:
	.loc 2 2130 0
	adrp	x27, .LANCHOR3
	.loc 2 2122 0
	str	xzr, [x0, #:lo12:.LANCHOR41]
	.loc 2 2123 0
	adrp	x0, .LANCHOR44
	str	xzr, [x0, #:lo12:.LANCHOR44]
.LVL1121:
.L837:
	.loc 2 2128 0 discriminator 1
	ldrh	w0, [x25]
	cmp	w19, w0
	bcs	.L843
	.loc 2 2133 0
	adrp	x0, .LANCHOR19
	.loc 2 2130 0
	ldrh	w8, [x27, #:lo12:.LANCHOR3]
	.loc 2 2133 0
	mov	x6, 0
	mov	w5, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR19]
	b	.L844
.LVL1122:
.L839:
	.loc 2 2131 0
	ldrb	w0, [x26, x6]
	mov	w1, w19
	bl	V2P_block
.LVL1123:
	.loc 2 2132 0
	bl	FtlBbmIsBadBlock
.LVL1124:
	cbnz	w0, .L838
	.loc 2 2133 0
	add	w5, w5, w7
.LVL1125:
	and	w5, w5, 65535
.LVL1126:
.L838:
	add	x6, x6, 1
.LVL1127:
.L844:
	.loc 2 2130 0 discriminator 1
	cmp	w8, w6, uxth
	bhi	.L839
	.loc 2 2135 0
	cbz	w5, .L846
	.loc 2 2136 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL1128:
.L840:
	.loc 2 2137 0
	ldr	x1, [x24, #:lo12:.LANCHOR40]
	mov	w0, 6
	umaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	.loc 2 2139 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L841
	.loc 2 2140 0 discriminator 1
	adrp	x0, .LANCHOR52
	.loc 2 2139 0 discriminator 1
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L841
	.loc 2 2141 0
	adrp	x0, .LANCHOR53
	.loc 2 2140 0
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L841
	.loc 2 2143 0
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbnz	w0, .L842
	.loc 2 2144 0
	add	w21, w21, 1
.LVL1129:
	.loc 2 2145 0
	mov	w0, w19
	.loc 2 2144 0
	and	w21, w21, 65535
.LVL1130:
	.loc 2 2145 0
	bl	INSERT_FREE_LIST
.LVL1131:
.L841:
	.loc 2 2128 0 discriminator 2
	add	w19, w19, 1
.LVL1132:
	and	w19, w19, 65535
.LVL1133:
	b	.L837
.LVL1134:
.L846:
	mov	w5, 0
.LVL1135:
	b	.L840
.LVL1136:
.L842:
	.loc 2 2147 0
	add	w20, w20, 1
.LVL1137:
	.loc 2 2148 0
	mov	w0, w19
	.loc 2 2147 0
	and	w20, w20, 65535
.LVL1138:
	.loc 2 2148 0
	bl	INSERT_DATA_LIST
.LVL1139:
	b	.L841
.L843:
	.loc 2 2152 0
	strh	w20, [x23, #:lo12:.LANCHOR45]
	.loc 2 2154 0
	add	w20, w20, w21
.LVL1140:
	.loc 2 2153 0
	strh	w21, [x22, #:lo12:.LANCHOR48]
	.loc 2 2154 0
	cmp	w20, w0
	ble	.L845
	.loc 2 2154 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR154
	adrp	x0, .LC1
	mov	w2, 2154
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1141:
.L845:
	.loc 2 2156 0 is_stmt 1
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
.LVL1142:
	ldp	x21, x22, [sp, 32]
.LVL1143:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE285:
	.size	SupperBlkListInit, .-SupperBlkListInit
	.section	.text.ftl_check_vpc,"ax",@progbits
	.align	2
	.global	ftl_check_vpc
	.type	ftl_check_vpc, %function
ftl_check_vpc:
.LFB290:
	.loc 2 2273 0
	.cfi_startproc
.LVL1144:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 2 2279 0
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	.loc 2 2273 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 2282 0
	adrp	x23, .LANCHOR61
	add	x23, x23, :lo12:.LANCHOR61
	.loc 2 2273 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 2282 0
	mov	w22, 0
	.loc 2 2273 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	.loc 2 2279 0
	adrp	x21, .LANCHOR155
	.loc 2 2273 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 2279 0
	add	x1, x21, :lo12:.LANCHOR155
	.loc 2 2281 0
	adrp	x20, check_vpc_table
	.loc 2 2279 0
	bl	printf
.LVL1145:
	.loc 2 2281 0
	add	x19, x20, :lo12:check_vpc_table
	mov	w2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
.LVL1146:
.L849:
	.loc 2 2282 0 discriminator 1
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L851
	.loc 2 2293 0 discriminator 1
	adrp	x22, .LANCHOR5
.LVL1147:
	.loc 2 2297 0 discriminator 1
	adrp	x24, .LC95
	.loc 2 2293 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR5
	.loc 2 2295 0 discriminator 1
	add	x26, x20, :lo12:check_vpc_table
	.loc 2 2297 0 discriminator 1
	add	x24, x24, :lo12:.LC95
	mov	w23, 0
	mov	w19, 0
	.loc 2 2295 0 discriminator 1
	adrp	x25, .LANCHOR42
.LVL1148:
.L852:
	.loc 2 2293 0 discriminator 1
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L854
	.loc 2 2305 0
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
.LVL1149:
	cbz	x19, .L855
.LBB277:
	.loc 2 2307 0
	adrp	x0, .LANCHOR48
	.loc 2 2313 0
	adrp	x25, .LC96
	add	x20, x20, :lo12:check_vpc_table
	add	x25, x25, :lo12:.LC96
	.loc 2 2307 0
	ldrh	w26, [x0, #:lo12:.LANCHOR48]
.LVL1150:
	.loc 2 2308 0
	adrp	x0, .LANCHOR40
	mov	x24, x0
	.loc 2 2309 0
	mov	w22, 0
	.loc 2 2308 0
	ldr	x1, [x0, #:lo12:.LANCHOR40]
	.loc 2 2311 0
	adrp	x27, .LANCHOR42
	.loc 2 2316 0
	mov	w28, 6
	.loc 2 2308 0
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.LVL1151:
.L856:
	.loc 2 2309 0 discriminator 1
	cmp	w22, w26
	bne	.L858
.LVL1152:
.L855:
.LBE277:
	.loc 2 2321 0
	cbz	w23, .L848
.LVL1153:
	.loc 2 2321 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 2321
	add	x1, x21, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1154:
.L848:
	.loc 2 2322 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1155:
.L851:
	.cfi_restore_state
	.loc 2 2284 0
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
.LVL1156:
	.loc 2 2285 0
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L850
	.loc 2 2287 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1157:
	.loc 2 2288 0
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.LVL1158:
.L850:
	.loc 2 2282 0 discriminator 2
	add	w22, w22, 1
.LVL1159:
	b	.L849
.LVL1160:
.L854:
	.loc 2 2295 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L853
	.loc 2 2297 0
	mov	w1, w19
	mov	x0, x24
	bl	printf
.LVL1161:
	.loc 2 2298 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L853
	.loc 2 2298 0 is_stmt 0 discriminator 1
	ldrh	w1, [x26, x27, lsl 1]
	.loc 2 2300 0 is_stmt 1 discriminator 1
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.LVL1162:
.L853:
	.loc 2 2293 0 discriminator 2
	add	w19, w19, 1
.LVL1163:
	and	w19, w19, 65535
.LVL1164:
	b	.L852
.LVL1165:
.L858:
.LBB278:
	.loc 2 2311 0
	ldr	x1, [x27, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L857
	.loc 2 2313 0
	ldrh	w3, [x20, w19, sxtw 1]
	.loc 2 2314 0
	mov	w23, 1
.LVL1166:
	.loc 2 2313 0
	mov	w1, w19
	mov	x0, x25
	bl	printf
.LVL1167:
.L857:
	.loc 2 2316 0
	ldr	x0, [x24, #:lo12:.LANCHOR40]
	umull	x19, w19, w28
.LVL1168:
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L855
.LVL1169:
	.loc 2 2309 0 discriminator 2
	add	w22, w22, 1
.LVL1170:
	and	w22, w22, 65535
.LVL1171:
	b	.L856
.LBE278:
	.cfi_endproc
.LFE290:
	.size	ftl_check_vpc, .-ftl_check_vpc
	.section	.text.FtlGcPageVarInit,"ax",@progbits
	.align	2
	.global	FtlGcPageVarInit
	.type	FtlGcPageVarInit, %function
FtlGcPageVarInit:
.LFB309:
	.loc 5 202 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 5 203 0
	adrp	x0, .LANCHOR95
	.loc 5 205 0
	mov	w1, 255
	.loc 5 202 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 5 203 0
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	.loc 5 204 0
	adrp	x0, .LANCHOR97
	.loc 5 202 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 5 205 0
	adrp	x19, .LANCHOR21
	.loc 5 204 0
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	.loc 5 205 0
	adrp	x0, .LANCHOR96
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	ldr	x0, [x0, #:lo12:.LANCHOR96]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1172:
	.loc 5 206 0
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR98
	ldr	x0, [x0, #:lo12:.LANCHOR98]
	bl	ftl_memset
.LVL1173:
	.loc 5 208 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	.loc 5 207 0
	b	FtlGcBufInit
.LVL1174:
	.cfi_endproc
.LFE309:
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
.LFB310:
	.loc 5 211 0
	.cfi_startproc
.LVL1175:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 5 220 0
	adrp	x21, .LANCHOR156
	.loc 5 211 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x20, x0
	stp	x27, x28, [sp, 80]
	.loc 5 221 0
	mov	w0, 65535
.LVL1176:
	.loc 5 220 0
	ldrh	w19, [x21, #:lo12:.LANCHOR156]
.LVL1177:
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 5 211 0
	mov	w28, w1
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 5 221 0
	cmp	w19, w0
	beq	.L892
	.loc 5 223 0
	cbnz	w19, .L876
.L877:
	.loc 5 224 0
	bl	FtlGcPageVarInit
.LVL1178:
	b	.L878
.LVL1179:
.L892:
	.loc 5 222 0
	mov	w19, 0
.LVL1180:
.L876:
	.loc 5 223 0 discriminator 1
	adrp	x0, .LANCHOR19
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w28
	beq	.L877
.LVL1181:
.L878:
	.loc 5 235 0
	adrp	x27, .LANCHOR23
	add	x27, x27, :lo12:.LANCHOR23
	.loc 5 222 0
	mov	w22, 0
	.loc 5 228 0
	mov	w23, 65535
.LVL1182:
.L886:
	ldrh	w0, [x20]
	.loc 5 226 0
	strb	wzr, [x20, 8]
.LVL1183:
	.loc 5 228 0
	cmp	w0, w23
	beq	.L893
	.loc 5 236 0
	adrp	x25, .LANCHOR24
	.loc 5 231 0
	adrp	x26, .LANCHOR3
	.loc 5 236 0
	add	x25, x25, :lo12:.LANCHOR24
	.loc 5 231 0
	add	x26, x26, :lo12:.LANCHOR3
.L889:
.LVL1184:
	.loc 5 235 0
	adrp	x1, .LANCHOR91
	.loc 5 234 0
	adrp	x24, .LANCHOR120
	.loc 5 235 0
	ldrh	w7, [x27]
	add	x5, x20, 16
	ldr	x6, [x1, #:lo12:.LANCHOR91]
	.loc 5 236 0
	adrp	x1, .LANCHOR92
	.loc 5 234 0
	ldr	x0, [x24, #:lo12:.LANCHOR120]
	.loc 5 230 0
	mov	w3, 0
	.loc 5 236 0
	ldr	x8, [x1, #:lo12:.LANCHOR92]
	ldrh	w1, [x26]
	ldrh	w10, [x25]
	add	x1, x1, 8
	add	x1, x20, x1, lsl 1
.LVL1185:
.L880:
	.loc 5 231 0 discriminator 1
	cmp	x1, x5
	bne	.L882
	.loc 5 240 0
	mov	w1, w3
	str	w3, [x29, 108]
	mov	w2, 0
	bl	FlashReadPages
.LVL1186:
	ldr	w3, [x29, 108]
	.loc 5 241 0
	mov	x11, 0
	ubfiz	x12, x3, 5, 16
.LVL1187:
.L883:
	.loc 5 241 0 is_stmt 0 discriminator 1
	cmp	x11, x12
	bne	.L887
	.loc 5 264 0 is_stmt 1
	add	w19, w19, 1
.LVL1188:
	.loc 5 266 0
	add	w22, w22, 1
.LVL1189:
	.loc 5 264 0
	and	w19, w19, 65535
.LVL1190:
	.loc 5 268 0
	cmp	w28, w22
	adrp	x1, .LANCHOR19
	bls	.L888
.L890:
	.loc 5 274 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bhi	.L889
.L893:
	.loc 5 227 0
	mov	w2, 0
	b	.L879
.LVL1191:
.L882:
	.loc 5 232 0
	ldrh	w4, [x5]
.LVL1192:
	.loc 5 233 0
	cmp	w4, w23
	beq	.L881
	.loc 5 234 0
	ubfiz	x2, x3, 5, 16
	orr	w4, w19, w4, lsl 10
.LVL1193:
	add	x2, x0, x2
	str	w4, [x2, 4]
	.loc 5 235 0
	mul	w4, w3, w7
	asr	w4, w4, 2
	add	x4, x6, x4, sxtw 2
	str	x4, [x2, 8]
	.loc 5 236 0
	mul	w4, w3, w10
	.loc 5 237 0
	add	w3, w3, 1
.LVL1194:
	and	w3, w3, 65535
.LVL1195:
	.loc 5 236 0
	asr	w4, w4, 2
	add	x4, x8, x4, sxtw 2
	str	x4, [x2, 16]
.L881:
	add	x5, x5, 2
.LVL1196:
	b	.L880
.LVL1197:
.L887:
	.loc 5 242 0
	ldr	x6, [x24, #:lo12:.LANCHOR120]
	add	x5, x6, x11
	ldr	w4, [x5, 4]
.LVL1198:
	.loc 5 243 0
	lsr	w0, w4, 10
	bl	P2V_plane
.LVL1199:
	and	w2, w0, 65535
.LVL1200:
	.loc 5 245 0
	ldr	w0, [x6, x11]
.LVL1201:
	cbnz	w0, .L884
	.loc 5 247 0
	ldr	x0, [x5, 16]
.LVL1202:
	add	x11, x11, 32
	.loc 5 248 0
	ldrh	w1, [x0]
	cmp	w1, w23
	bne	.L885
	.loc 5 249 0
	adrp	x0, .LANCHOR152
.LVL1203:
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR152]
.LVL1204:
.L879:
	.loc 5 282 0
	strh	w19, [x20, 2]
	.loc 5 281 0
	mov	w0, -1
	.loc 5 283 0
	strb	w2, [x20, 6]
	.loc 5 284 0
	mov	w1, w19
	.loc 5 281 0
	strh	w0, [x21, #:lo12:.LANCHOR156]
	.loc 5 284 0
	mov	x0, x20
	bl	ftl_sb_update_avl_pages
.LVL1205:
	.loc 5 285 0
	b	.L891
.LVL1206:
.L885:
	.loc 5 252 0
	ldp	w2, w0, [x0, 8]
.LVL1207:
	mov	w1, w4
	bl	FtlGcUpdatePage
.LVL1208:
	b	.L883
.LVL1209:
.L884:
	.loc 5 256 0
	adrp	x0, .LANCHOR42
	ldrh	w1, [x20]
	.loc 5 259 0
	mov	w19, 0
.LVL1210:
	.loc 5 256 0
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	strh	wzr, [x0, x1, lsl 1]
	.loc 5 257 0
	ldrh	w0, [x20]
	bl	INSERT_FREE_LIST
.LVL1211:
	.loc 5 258 0
	mov	w0, -1
	strh	w0, [x20]
.LVL1212:
	.loc 5 260 0
	bl	FtlGcPageVarInit
.LVL1213:
	.loc 5 261 0
	b	.L886
.LVL1214:
.L888:
	.loc 5 268 0 discriminator 1
	ldrh	w0, [x21, #:lo12:.LANCHOR156]
	cmp	w0, w23
	beq	.L890
	.loc 5 269 0
	add	w0, w0, w22
	strh	w0, [x21, #:lo12:.LANCHOR156]
	.loc 5 270 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bls	.L890
.LVL1215:
.L891:
	.loc 5 286 0
	ldp	x19, x20, [sp, 16]
.LVL1216:
	mov	w0, -1
	ldp	x21, x22, [sp, 32]
.LVL1217:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1218:
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE310:
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FlashTestBlk,"ax",@progbits
	.align	2
	.global	FlashTestBlk
	.type	FlashTestBlk, %function
FlashTestBlk:
.LFB344:
	.loc 1 197 0
	.cfi_startproc
.LVL1219:
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	.loc 1 197 0
	and	w19, w0, 65535
	.loc 1 202 0
	cmp	w19, 11
	bls	.L901
.LVL1220:
.LBB281:
.LBB282:
	.loc 1 207 0
	add	x0, x29, 64
.LVL1221:
	.loc 1 208 0
	mov	w2, 32
	mov	w1, 165
	.loc 1 206 0
	adrp	x20, ftl_temp_buf
	add	x20, x20, :lo12:ftl_temp_buf
	.loc 1 207 0
	stp	x20, x0, [x29, 40]
	.loc 1 208 0
	bl	ftl_memset
.LVL1222:
	.loc 1 210 0
	lsl	w19, w19, 10
.LVL1223:
	.loc 1 209 0
	mov	w2, 8
	mov	w1, 90
	mov	x0, x20
	bl	ftl_memset
.LVL1224:
	.loc 1 211 0
	mov	w2, 1
	.loc 1 210 0
	str	w19, [x29, 36]
	.loc 1 211 0
	mov	w1, w2
	add	x0, x29, 32
	bl	FlashEraseBlocks
.LVL1225:
	.loc 1 212 0
	mov	w3, 1
	add	x0, x29, 32
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1226:
	.loc 1 213 0
	ldr	w0, [x29, 32]
	.loc 1 219 0
	mov	w2, 1
	mov	w1, 0
	.loc 1 213 0
	cmp	w0, 0
	.loc 1 219 0
	add	x0, x29, 32
	.loc 1 213 0
	csetm	w19, ne
.LDL1:
.LVL1227:
	.loc 1 219 0
	bl	FlashEraseBlocks
.LVL1228:
.L899:
.LBE282:
.LBE281:
	.loc 1 221 0
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1229:
.L901:
	.cfi_restore_state
	.loc 1 203 0
	mov	w19, 0
	b	.L899
	.cfi_endproc
.LFE344:
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FlashGetBadBlockList,"ax",@progbits
	.align	2
	.global	FlashGetBadBlockList
	.type	FlashGetBadBlockList, %function
FlashGetBadBlockList:
.LFB345:
	.loc 1 224 0
	.cfi_startproc
.LVL1230:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 1 227 0
	mov	w2, 256
	.loc 1 224 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 1 224 0
	mov	x19, x0
	mov	w20, w1
	.loc 1 227 0
	mov	w1, 255
.LVL1231:
	bl	ftl_memset
.LVL1232:
	.loc 1 228 0
	adrp	x0, .LANCHOR105
	mov	w1, w20
	ldr	x2, [x0, #:lo12:.LANCHOR105]
	mov	x0, x19
	blr	x2
.LVL1233:
	and	w0, w0, 65535
.LVL1234:
	.loc 1 229 0
	cmp	w0, 50
	bls	.L904
	.loc 1 230 0
	mov	w2, 256
	mov	w1, 255
	mov	x0, x19
.LVL1235:
	bl	ftl_memset
.LVL1236:
	.loc 1 231 0
	mov	w0, 0
.LVL1237:
.L904:
	.loc 1 233 0
	adrp	x1, .LANCHOR0+14
	ldrh	w1, [x1, #:lo12:.LANCHOR0+14]
	cmp	w1, 4
	bne	.L908
	mov	x1, 0
.L906:
.LVL1238:
	.loc 1 234 0 discriminator 1
	cmp	w0, w1, uxth
	bhi	.L907
.LVL1239:
.L908:
	.loc 1 239 0
	ldp	x19, x20, [sp, 16]
.LVL1240:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1241:
.L907:
	.cfi_restore_state
	.loc 1 235 0 discriminator 3
	ldrh	w2, [x19, x1, lsl 1]
	lsr	w2, w2, 1
	strh	w2, [x19, x1, lsl 1]
.LVL1242:
	add	x1, x1, 1
.LVL1243:
	b	.L906
	.cfi_endproc
.LFE345:
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.ftl_memcpy,"ax",@progbits
	.align	2
	.global	ftl_memcpy
	.type	ftl_memcpy, %function
ftl_memcpy:
.LFB347:
	.loc 1 247 0
	.cfi_startproc
.LVL1244:
	.loc 1 248 0
	uxtw	x2, w2
	b	memcpy
.LVL1245:
	.cfi_endproc
.LFE347:
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
.LFB226:
	.loc 4 80 0
	.cfi_startproc
.LVL1246:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 4 88 0
	adrp	x23, .LANCHOR108
	.loc 4 80 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 4 87 0
	adrp	x19, .LANCHOR106
	.loc 4 80 0
	stp	x21, x22, [sp, 32]
	.loc 4 87 0
	add	x20, x19, :lo12:.LANCHOR106
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	adrp	x22, .LANCHOR107
	.loc 4 88 0
	ldr	x1, [x23, #:lo12:.LANCHOR108]
	.loc 4 80 0
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR37
	str	x27, [sp, 80]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	add	x25, x21, :lo12:.LANCHOR37
	.loc 4 87 0
	ldr	x0, [x22, #:lo12:.LANCHOR107]
	.loc 4 91 0
	adrp	x26, .LANCHOR10
	.loc 4 88 0
	stp	x0, x1, [x20, 8]
	.loc 4 89 0
	adrp	x1, .LANCHOR23
	.loc 4 92 0
	adrp	x27, .LANCHOR137
	add	x25, x25, 32
	.loc 4 89 0
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	.loc 4 91 0
	mov	w24, 0
	add	x26, x26, :lo12:.LANCHOR10
	.loc 4 92 0
	add	x27, x27, :lo12:.LANCHOR137
	.loc 4 89 0
	mov	w1, 0
	bl	ftl_memset
.LVL1247:
.L912:
	.loc 4 91 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w24, w0
	blt	.L913
	.loc 4 94 0
	add	x19, x19, :lo12:.LANCHOR106
	.loc 4 98 0
	add	x20, x21, :lo12:.LANCHOR37
	.loc 4 95 0
	mov	w2, 16
	mov	w1, 255
	.loc 4 108 0
	adrp	x24, .LC97
.LVL1248:
	.loc 4 110 0
	adrp	x26, .LANCHOR20
	.loc 4 94 0
	ldr	x27, [x19, 16]
.LVL1249:
	.loc 4 108 0
	add	x24, x24, :lo12:.LC97
	.loc 4 110 0
	add	x26, x26, :lo12:.LANCHOR20
	.loc 4 82 0
	mov	w25, 0
	.loc 4 95 0
	mov	x0, x27
	bl	ftl_memset
.LVL1250:
	.loc 4 97 0
	mov	w0, -3887
	strh	w0, [x27]
	.loc 4 98 0
	ldr	w0, [x20, 8]
	str	w0, [x27, 4]
	.loc 4 99 0
	ldrh	w0, [x21, #:lo12:.LANCHOR37]
	.loc 4 84 0
	mov	w21, 0
	.loc 4 99 0
	strh	w0, [x27, 2]
	.loc 4 100 0
	ldrh	w0, [x20, 4]
	strh	w0, [x27, 8]
	.loc 4 101 0
	ldrh	w0, [x20, 6]
	strh	w0, [x27, 10]
	.loc 4 102 0
	adrp	x0, .LANCHOR2
	ldr	w0, [x0, #:lo12:.LANCHOR2]
	strh	w0, [x27, 12]
.LVL1251:
.L914:
	.loc 4 108 0
	ldrh	w4, [x27, 10]
	.loc 4 107 0
	ldrh	w1, [x20]
	ldrh	w2, [x20, 2]
	.loc 4 108 0
	ldrh	w3, [x20, 4]
	.loc 4 104 0
	ldr	x0, [x22, #:lo12:.LANCHOR107]
	str	x0, [x19, 8]
	.loc 4 105 0
	ldr	x0, [x23, #:lo12:.LANCHOR108]
	str	x0, [x19, 16]
	.loc 4 107 0
	orr	w0, w2, w1, lsl 10
	.loc 4 106 0
	str	wzr, [x19]
	.loc 4 107 0
	str	w0, [x19, 4]
	.loc 4 108 0
	mov	x0, x24
	bl	printf
.LVL1252:
	.loc 4 109 0
	mov	w3, 1
	mov	x0, x19
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
.LVL1253:
	.loc 4 110 0
	ldrh	w0, [x26]
	ldrh	w1, [x20, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L915
	.loc 4 113 0
	ldr	w0, [x20, 8]
	.loc 4 122 0
	mov	w2, 1
	.loc 4 116 0
	ldrh	w1, [x20, 4]
	.loc 4 113 0
	add	w0, w0, 1
	str	w0, [x20, 8]
	.loc 4 114 0
	str	w0, [x27, 4]
	.loc 4 115 0
	ldrh	w0, [x20]
	strh	w0, [x27, 8]
	.loc 4 118 0
	strh	w0, [x20, 4]
	.loc 4 121 0
	adrp	x0, .LANCHOR111
	.loc 4 116 0
	strh	w1, [x20]
	.loc 4 119 0
	lsl	w1, w1, 10
	.loc 4 121 0
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	.loc 4 119 0
	str	w1, [x19, 4]
	.loc 4 117 0
	strh	wzr, [x20, 2]
	.loc 4 121 0
	str	w1, [x0, 4]
	.loc 4 122 0
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL1254:
	.loc 4 123 0
	mov	w3, 1
	mov	x0, x19
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1255:
.L915:
	.loc 4 126 0
	ldrh	w0, [x20, 2]
	add	w0, w0, 1
	strh	w0, [x20, 2]
	.loc 4 127 0
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L916
	.loc 4 129 0
	ldr	w1, [x19, 4]
	.loc 4 130 0
	add	w21, w21, 1
.LVL1256:
	.loc 4 129 0
	adrp	x0, .LC98
	.loc 4 130 0
	and	w21, w21, 65535
	.loc 4 129 0
	add	x0, x0, :lo12:.LC98
	bl	printf
.LVL1257:
	.loc 4 131 0
	cmp	w21, 3
	bls	.L914
	.loc 4 132 0
	ldr	w1, [x19, 4]
	adrp	x0, .LC99
	mov	w2, w21
	add	x0, x0, :lo12:.LC99
	bl	printf
.LVL1258:
.L918:
	b	.L918
.LVL1259:
.L913:
	.loc 4 92 0 discriminator 3
	ldrh	w2, [x27]
	ldr	x1, [x25], 8
	ldr	x0, [x20, 8]
	mul	w3, w24, w2
	lsl	w2, w2, 2
	.loc 4 91 0 discriminator 3
	add	w24, w24, 1
.LVL1260:
	.loc 4 92 0 discriminator 3
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
.LVL1261:
	b	.L912
.LVL1262:
.L919:
	mov	w25, 1
.LVL1263:
	b	.L914
.LVL1264:
.L916:
	.loc 4 139 0
	cbz	w25, .L919
	.loc 4 146 0
	mov	w0, 0
	ldr	x27, [sp, 80]
.LVL1265:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL1266:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1267:
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE226:
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
.LFB298:
	.loc 2 2582 0
	.cfi_startproc
.LVL1268:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 2588 0
	adrp	x28, .LANCHOR48
	.loc 2 2582 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 2591 0
	add	x23, x28, :lo12:.LANCHOR48
	.loc 2 2582 0
	stp	x19, x20, [sp, 16]
	.loc 2 2588 0
	adrp	x27, .LANCHOR45
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.loc 2 2582 0
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.loc 2 2588 0
	add	x0, x27, :lo12:.LANCHOR45
.LVL1269:
	.loc 2 2582 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 2 2588 0
	str	x0, [x29, 104]
.LVL1270:
.L922:
	ldr	x1, [x29, 104]
	adrp	x24, .LANCHOR5
	ldrh	w0, [x28, #:lo12:.LANCHOR48]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L923
	.loc 2 2588 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2588
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1271:
.L923:
	.loc 2 2590 0 is_stmt 1
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	cmp	x19, x0
	bne	.L948
	.loc 2 2591 0
	adrp	x1, .LANCHOR87
	ldrh	w0, [x23]
	ldr	w1, [x1, #:lo12:.LANCHOR87]
	mul	w1, w0, w1
	lsr	w0, w0, 1
	add	w0, w0, 1
	add	w1, w0, w1, lsr 2
.LVL1272:
	.loc 2 2595 0
	ands	w1, w1, 65535
	beq	.L924
	.loc 2 2596 0
	sub	w1, w1, #1
.LVL1273:
	and	w1, w1, 65535
.LVL1274:
.L924:
	.loc 2 2597 0
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_pop_index_node
.LVL1275:
	and	w20, w0, 65535
.LVL1276:
	ldrh	w0, [x23]
	cbnz	w0, .L925
	.loc 2 2597 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2597
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1277:
.L925:
	.loc 2 2597 0 discriminator 3
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	.loc 2 2600 0 is_stmt 1 discriminator 3
	strh	w20, [x19]
	.loc 2 2601 0 discriminator 3
	mov	x0, x19
	bl	make_superblock
.LVL1278:
	.loc 2 2602 0 discriminator 3
	ldrb	w0, [x19, 7]
	cbnz	w0, .L926
	.loc 2 2606 0
	adrp	x1, .LANCHOR42
	ubfiz	x0, x20, 1, 16
	mov	w2, -1
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	strh	w2, [x1, x0]
	.loc 2 2607 0
	mov	w0, w20
	bl	INSERT_DATA_LIST
.LVL1279:
	.loc 2 2608 0
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L922
	.loc 2 2608 0 is_stmt 0 discriminator 1
	mov	w2, 2608
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1280:
	b	.L922
.LVL1281:
.L948:
	mov	w1, 0
	b	.L924
.LVL1282:
.L926:
	.loc 2 2611 0 is_stmt 1
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L928
	.loc 2 2611 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2611
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1283:
.L928:
	.loc 2 2614 0 is_stmt 1 discriminator 1
	adrp	x0, .LANCHOR3
	.loc 2 2615 0 discriminator 1
	adrp	x25, .LANCHOR111
	add	x26, x19, 16
	mov	w21, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	x4, x26
	ldr	x3, [x25, #:lo12:.LANCHOR111]
	.loc 2 2617 0 discriminator 1
	mov	w6, 65535
	ubfiz	x0, x0, 5, 16
	add	x1, x3, 8
	add	x0, x0, 8
	add	x0, x3, x0
.L929:
.LVL1284:
	.loc 2 2614 0 discriminator 1
	cmp	x0, x1
	bne	.L931
	.loc 2 2622 0
	cbnz	w21, .L932
	.loc 2 2622 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2622
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1285:
.L932:
	.loc 2 2624 0 is_stmt 1
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w20
	bne	.L933
	.loc 2 2624 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2624
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1286:
.L933:
	.loc 2 2625 0 is_stmt 1
	ldrb	w0, [x19, 8]
	uxtw	x22, w20
	adrp	x6, .LANCHOR43
	adrp	x7, .LANCHOR14
	adrp	x5, .LANCHOR72
	adrp	x4, .LANCHOR73
	cbnz	w0, .L934
	.loc 2 2626 0
	ldr	x2, [x6, #:lo12:.LANCHOR43]
	lsl	x1, x22, 1
	ldrh	w0, [x2, x1]
	cbz	w0, .L935
	.loc 2 2627 0
	ldrh	w3, [x7, #:lo12:.LANCHOR14]
	add	w0, w0, w3
.L959:
	.loc 2 2629 0
	strh	w0, [x2, x1]
	.loc 2 2631 0
	mov	w1, 0
	.loc 2 2630 0
	ldr	w0, [x5, #:lo12:.LANCHOR72]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR72]
	.loc 2 2631 0
	mov	w0, w20
	bl	ftl_set_blk_mode
.LVL1287:
.L937:
	.loc 2 2638 0
	ldr	x0, [x6, #:lo12:.LANCHOR43]
	lsl	x22, x22, 1
	ldrh	w1, [x0, x22]
	adrp	x0, .LANCHOR76
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	cmp	w1, w2
	bls	.L938
	.loc 2 2639 0
	str	w1, [x0, #:lo12:.LANCHOR76]
.L938:
	.loc 2 2641 0
	ldr	w2, [x5, #:lo12:.LANCHOR72]
	ldr	w1, [x4, #:lo12:.LANCHOR73]
	ldrh	w0, [x7, #:lo12:.LANCHOR14]
	madd	w0, w0, w2, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR74
	str	w0, [x1, #:lo12:.LANCHOR74]
	.loc 2 2642 0
	adrp	x0, .LANCHOR127
	ldr	x1, [x0, #:lo12:.LANCHOR127]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
.LVL1288:
	.loc 2 2645 0
	ldr	x0, [x25, #:lo12:.LANCHOR111]
	ubfiz	x1, x21, 5, 16
	add	x1, x1, 4
	add	x2, x0, 4
	add	x1, x0, x1
.LVL1289:
.L939:
	.loc 2 2644 0 discriminator 1
	cmp	x1, x2
	bne	.L940
	.loc 2 2646 0
	ldrb	w1, [x19, 8]
	mov	w2, w21
	.loc 2 2648 0
	mov	x24, 0
	.loc 2 2646 0
	bl	FlashEraseBlocks
.LVL1290:
	.loc 2 2647 0
	mov	w1, 0
.LVL1291:
.L941:
	.loc 2 2648 0 discriminator 1
	cmp	w21, w24, uxth
	bhi	.L943
	.loc 2 2659 0
	cbz	w1, .L944
	.loc 2 2660 0
	mov	w0, w20
	bl	update_multiplier_value
.LVL1292:
	.loc 2 2661 0
	bl	FtlBbmTblFlush
.LVL1293:
.L944:
	.loc 2 2664 0
	ldrb	w0, [x19, 7]
	adrp	x2, .LANCHOR42
	cbnz	w0, .L945
	.loc 2 2666 0
	ldr	x0, [x2, #:lo12:.LANCHOR42]
	mov	w1, -1
	strh	w1, [x0, x22]
	.loc 2 2667 0
	mov	w0, w20
	bl	INSERT_DATA_LIST
.LVL1294:
	.loc 2 2668 0
	b	.L922
.LVL1295:
.L931:
	.loc 2 2617 0
	ldrh	w2, [x4]
	.loc 2 2616 0
	stp	xzr, xzr, [x1]
	.loc 2 2617 0
	cmp	w2, w6
	beq	.L930
	.loc 2 2618 0
	ubfiz	x5, x21, 5, 16
	.loc 2 2619 0
	add	w21, w21, 1
.LVL1296:
	.loc 2 2618 0
	add	x5, x3, x5
	.loc 2 2619 0
	and	w21, w21, 65535
.LVL1297:
	.loc 2 2618 0
	lsl	w2, w2, 10
	str	w2, [x5, 4]
.L930:
	add	x1, x1, 32
	add	x4, x4, 2
	b	.L929
.L935:
	.loc 2 2629 0
	mov	w0, 2
	b	.L959
.L934:
	.loc 2 2633 0
	ldr	x2, [x6, #:lo12:.LANCHOR43]
	lsl	x0, x22, 1
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	.loc 2 2634 0
	ldr	w0, [x4, #:lo12:.LANCHOR73]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR73]
.LVL1298:
.LBB283:
.LBB284:
	mov	w0, w20
	bl	ftl_set_blk_mode.part.6
.LVL1299:
	b	.L937
.LVL1300:
.L940:
.LBE284:
.LBE283:
	.loc 2 2645 0 discriminator 3
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 32
	b	.L939
.LVL1301:
.L943:
	.loc 2 2649 0
	ldr	x2, [x25, #:lo12:.LANCHOR111]
	lsl	x0, x24, 5
	add	x3, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L942
	.loc 2 2650 0
	add	w1, w1, 1
.LVL1302:
	.loc 2 2651 0
	ldr	w0, [x3, 4]
	.loc 2 2650 0
	stp	w2, w1, [x29, 96]
.LVL1303:
	.loc 2 2652 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1304:
	.loc 2 2654 0
	ldp	w2, w1, [x29, 96]
	.loc 2 2653 0
	strh	w2, [x26]
	.loc 2 2654 0
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
.LVL1305:
.L942:
	add	x24, x24, 1
.LVL1306:
	add	x26, x26, 2
	b	.L941
.LVL1307:
.L945:
	.loc 2 2671 0
	adrp	x1, .LANCHOR19
	.loc 2 2675 0
	adrp	x3, .LANCHOR70
	.loc 2 2674 0
	strb	wzr, [x19, 6]
	.loc 2 2671 0
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	.loc 2 2673 0
	strh	wzr, [x19, 2]
	.loc 2 2672 0
	strh	w20, [x19]
	.loc 2 2671 0
	mul	w0, w0, w1
	.loc 2 2675 0
	ldr	w1, [x3, #:lo12:.LANCHOR70]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x3, #:lo12:.LANCHOR70]
	.loc 2 2676 0
	ldr	x1, [x2, #:lo12:.LANCHOR42]
	.loc 2 2671 0
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	.loc 2 2676 0
	strh	w0, [x1, x22]
	.loc 2 2677 0
	ldrh	w0, [x19, 4]
	cbz	w0, .L946
	.loc 2 2677 0 is_stmt 0 discriminator 2
	ldrb	w0, [x19, 7]
	cbnz	w0, .L947
.L946:
	.loc 2 2677 0 discriminator 3
	adrp	x1, .LANCHOR157
	adrp	x0, .LC1
	mov	w2, 2677
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1308:
.L947:
	.loc 2 2679 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
.LVL1309:
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL1310:
	ldp	x23, x24, [sp, 48]
.LVL1311:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE298:
	.size	allocate_data_superblock, .-allocate_data_superblock
	.section	.text.FtlGcFreeBadSuperBlk,"ax",@progbits
	.align	2
	.global	FtlGcFreeBadSuperBlk
	.type	FtlGcFreeBadSuperBlk, %function
FtlGcFreeBadSuperBlk:
.LFB317:
	.loc 5 390 0
	.cfi_startproc
.LVL1312:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 5 395 0
	adrp	x21, .LANCHOR101
	.loc 5 390 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	and	w25, w0, 65535
	.loc 5 395 0
	ldrh	w0, [x21, #:lo12:.LANCHOR101]
.LVL1313:
	.loc 5 390 0
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 27, -16
	.loc 5 395 0
	cbz	w0, .L961
.LBB287:
.LBB288:
	.loc 5 399 0
	adrp	x23, .LANCHOR102
	.loc 5 406 0
	add	x24, x23, :lo12:.LANCHOR102
.LBE288:
.LBE287:
	mov	w19, 0
.L962:
.LVL1314:
.LBB291:
.LBB289:
	.loc 5 396 0
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w0, w19
	bhi	.L968
	.loc 5 412 0
	bl	FtlGcReFreshBadBlk
.LVL1315:
.L961:
.LBE289:
.LBE291:
	.loc 5 415 0
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1316:
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1317:
.L968:
	.cfi_restore_state
.LBB292:
.LBB290:
	.loc 5 397 0
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	mov	w1, w25
	.loc 5 398 0
	add	x22, x21, :lo12:.LANCHOR101
	mov	w20, 0
	.loc 5 397 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
.LVL1318:
	and	w26, w0, 65535
.LVL1319:
.L963:
	.loc 5 398 0
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L967
	.loc 5 396 0
	add	w19, w19, 1
.LVL1320:
	and	w19, w19, 65535
.LVL1321:
	b	.L962
.L967:
	.loc 5 399 0
	add	x0, x23, :lo12:.LANCHOR102
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L964
	.loc 5 401 0
	mov	w1, w26
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	bl	printf
.LVL1322:
	.loc 5 403 0
	mov	w0, w26
	bl	FtlBbmMapBadBlock
.LVL1323:
	.loc 5 404 0
	bl	FtlBbmTblFlush
.LVL1324:
	.loc 5 405 0
	ldrh	w1, [x22]
	.loc 5 406 0
	sxtw	x3, w27
	and	x4, x20, 65535
	.loc 5 405 0
	mov	x0, 0
.LVL1325:
.L965:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L966
	.loc 5 407 0
	sub	w1, w1, #1
	strh	w1, [x22]
.LVL1326:
.L964:
	.loc 5 398 0
	and	w20, w27, 65535
.LVL1327:
	b	.L963
.LVL1328:
.L966:
	.loc 5 406 0
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
.LVL1329:
	strh	w5, [x24, x2, lsl 1]
	b	.L965
.LBE290:
.LBE292:
	.cfi_endproc
.LFE317:
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
.LFB301:
	.loc 2 2738 0
	.cfi_startproc
.LVL1330:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2739 0
	adrp	x1, .LANCHOR42
	.loc 2 2738 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 2738 0
	and	w19, w0, 65535
	.loc 2 2739 0
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ubfiz	x0, x19, 1, 16
.LVL1331:
	ldrh	w0, [x1, x0]
	cbnz	w0, .L974
	.loc 2 2740 0
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w19
	bne	.L975
	.loc 2 2742 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR80]
.L976:
.LVL1332:
.LBB295:
.LBB296:
	.loc 2 2747 0
	adrp	x20, .LANCHOR45
	mov	w1, w19
	adrp	x0, .LANCHOR41
	add	x0, x0, :lo12:.LANCHOR41
	bl	List_remove_node
.LVL1333:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L978
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2747
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1334:
.L978:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	.loc 2 2748 0
	mov	w0, w19
	bl	free_data_superblock
.LVL1335:
	.loc 2 2749 0
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
.LVL1336:
	.loc 2 2750 0
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
.LVL1337:
.L982:
	mov	w0, 1
	b	.L973
.LVL1338:
.L975:
.LBE296:
.LBE295:
	.loc 2 2743 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L981
	.loc 2 2743 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L981
	.loc 2 2743 0 discriminator 2
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bne	.L976
.L981:
	.loc 2 2745 0 is_stmt 1
	mov	w0, 0
.L973:
	.loc 2 2756 0
	ldp	x19, x20, [sp, 16]
.LVL1339:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L974:
	.cfi_restore_state
	.loc 2 2753 0
	mov	w0, w19
	bl	List_update_data_list
.LVL1340:
	b	.L981
	.cfi_endproc
.LFE301:
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",@progbits
	.align	2
	.global	decrement_vpc_count
	.type	decrement_vpc_count, %function
decrement_vpc_count:
.LFB302:
	.loc 2 2759 0
	.cfi_startproc
.LVL1341:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	and	w19, w0, 65535
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2762 0
	mov	w0, 65535
.LVL1342:
	cmp	w19, w0
	beq	.L985
	.loc 2 2763 0
	adrp	x21, .LANCHOR42
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L986
	.loc 2 2764 0
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	bl	printf
.LVL1343:
	.loc 2 2765 0
	ldr	x0, [x21, #:lo12:.LANCHOR42]
	ldrh	w0, [x0, x20]
	cbz	w0, .L987
.L992:
.LVL1344:
	.loc 2 2766 0 discriminator 1
	mov	w20, 0
.LVL1345:
.L984:
	.loc 2 2784 0
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1346:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1347:
.L987:
	.cfi_restore_state
	.loc 2 2765 0 discriminator 1
	mov	w2, 2765
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1348:
	b	.L992
.L986:
	.loc 2 2768 0
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L985:
	.loc 2 2772 0
	adrp	x21, .LANCHOR150
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR150]
	cmp	w0, w1
	bne	.L989
	.loc 2 2773 0
	strh	w19, [x21, #:lo12:.LANCHOR150]
	b	.L992
.L989:
	.loc 2 2775 0
	cmp	w19, w0
	beq	.L992
	.loc 2 2778 0
	bl	update_vpc_list
.LVL1349:
	cmp	w0, 0
	.loc 2 2781 0
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR41
	.loc 2 2780 0
	strh	w19, [x21, #:lo12:.LANCHOR150]
	.loc 2 2778 0
	cset	w20, ne
.LVL1350:
	.loc 2 2781 0
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
	.loc 2 2781 0 is_stmt 0 discriminator 1
	cmp	w19, w0, uxth
	beq	.L984
	.loc 2 2781 0 discriminator 2
	mov	w2, 2781
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1351:
	b	.L984
	.cfi_endproc
.LFE302:
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlWriteDump_data
	.type	FtlWriteDump_data, %function
FtlWriteDump_data:
.LFB268:
	.loc 2 996 0 is_stmt 1
	.cfi_startproc
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	.loc 2 997 0
	adrp	x19, .LANCHOR51
	add	x0, x19, :lo12:.LANCHOR51
	.loc 2 996 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.loc 2 997 0
	ldrh	w2, [x0, 4]
	.loc 2 996 0
	str	x25, [sp, 64]
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	.cfi_offset 25, -64
	.loc 2 997 0
	cbz	w2, .L994
	.loc 2 997 0 is_stmt 0 discriminator 1
	ldrb	w1, [x0, 8]
	cbnz	w1, .L994
	.loc 2 998 0 is_stmt 1
	adrp	x3, .LANCHOR19
	ldrb	w1, [x0, 7]
	ldrh	w3, [x3, #:lo12:.LANCHOR19]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L994
.LVL1352:
.LBB300:
.LBB301:
	.loc 2 1005 0
	ldrb	w0, [x0, 10]
	cbnz	w0, .L993
	.loc 2 1000 0
	adrp	x0, .LANCHOR61
	.loc 2 1007 0
	mov	w2, 0
	add	x1, x29, 92
	.loc 2 1000 0
	ldr	w21, [x0, #:lo12:.LANCHOR61]
	.loc 2 1002 0
	adrp	x0, .LANCHOR3
	.loc 2 1000 0
	sub	w21, w21, #1
	.loc 2 1002 0
	ldrh	w25, [x0, #:lo12:.LANCHOR3]
	.loc 2 1007 0
	mov	w0, w21
	bl	log2phys
.LVL1353:
	.loc 2 1013 0
	adrp	x2, .LANCHOR108
	.loc 2 1012 0
	adrp	x0, .LANCHOR107
	.loc 2 1010 0
	ldr	w1, [x29, 92]
	.loc 2 1013 0
	ldr	x20, [x2, #:lo12:.LANCHOR108]
	.loc 2 1012 0
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	.loc 2 1016 0
	cmn	w1, #1
	.loc 2 1010 0
	str	w1, [x29, 100]
	.loc 2 1013 0
	stp	x0, x20, [x29, 104]
.LVL1354:
	.loc 2 1011 0
	str	w21, [x29, 120]
	.loc 2 1015 0
	str	wzr, [x20, 4]
	.loc 2 1016 0
	beq	.L996
	.loc 2 1018 0
	mov	w2, 0
	mov	w1, 1
	add	x0, x29, 96
	bl	FlashReadPages
.LVL1355:
.L997:
	.loc 2 1036 0
	adrp	x23, .LANCHOR71
	.loc 2 1002 0
	lsl	w25, w25, 2
.LVL1356:
	.loc 2 1027 0
	add	x22, x19, :lo12:.LANCHOR51
	.loc 2 1036 0
	add	x23, x23, :lo12:.LANCHOR71
	.loc 2 1024 0
	mov	w0, -3947
	mov	w24, 0
	strh	w0, [x20]
.L998:
	.loc 2 1025 0
	cmp	w25, w24
	bne	.L1002
.L999:
	.loc 2 1041 0
	add	x19, x19, :lo12:.LANCHOR51
	mov	w0, 1
	strb	w0, [x19, 10]
.LVL1357:
.L993:
.LBE301:
.LBE300:
	.loc 2 1049 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1358:
.L996:
	.cfi_restore_state
.LBB303:
.LBB302:
	.loc 2 1022 0
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
.LVL1359:
	b	.L997
.LVL1360:
.L1002:
	.loc 2 1027 0
	ldrh	w0, [x22, 4]
	cbz	w0, .L999
	.loc 2 1032 0
	ldr	w0, [x29, 100]
	add	w24, w24, 1
	stp	w21, w0, [x20, 8]
	.loc 2 1033 0
	ldrh	w0, [x22]
	strh	w0, [x20, 2]
	.loc 2 1035 0
	mov	x0, x22
	bl	get_new_active_ppa
.LVL1361:
	str	w0, [x29, 100]
	.loc 2 1036 0
	ldr	w0, [x23]
	.loc 2 1037 0
	mov	w3, 0
	.loc 2 1036 0
	str	w0, [x20, 4]
	.loc 2 1037 0
	mov	w2, 0
	.loc 2 1036 0
	add	w0, w0, 1
	.loc 2 1037 0
	mov	w1, 1
	.loc 2 1036 0
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x23]
	.loc 2 1037 0
	add	x0, x29, 96
	bl	FlashProgPages
.LVL1362:
	.loc 2 1039 0
	ldrh	w0, [x22]
	bl	decrement_vpc_count
.LVL1363:
	b	.L998
.LVL1364:
.L994:
.LBE302:
.LBE303:
	.loc 2 1047 0
	add	x19, x19, :lo12:.LANCHOR51
	strb	wzr, [x19, 10]
	.loc 2 1049 0
	b	.L993
	.cfi_endproc
.LFE268:
	.size	FtlWriteDump_data, .-FtlWriteDump_data
	.section	.text.l2p_flush,"ax",@progbits
	.align	2
	.global	l2p_flush
	.type	l2p_flush, %function
l2p_flush:
.LFB261:
	.loc 2 789 0
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 795 0
	adrp	x20, .LANCHOR33
	add	x20, x20, :lo12:.LANCHOR33
	.loc 2 789 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 795 0
	mov	w19, 0
	.loc 2 796 0
	adrp	x21, .LANCHOR55
	.loc 2 793 0
	bl	FtlWriteDump_data
.LVL1365:
.L1012:
	.loc 2 795 0 discriminator 1
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1014
	.loc 2 799 0
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1366:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1367:
.L1014:
	.cfi_restore_state
	.loc 2 796 0
	ldr	x1, [x21, #:lo12:.LANCHOR55]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1013
	.loc 2 797 0
	mov	w0, w19
	bl	flush_l2p_region
.LVL1368:
.L1013:
	.loc 2 795 0 discriminator 2
	add	w19, w19, 1
.LVL1369:
	and	w19, w19, 65535
.LVL1370:
	b	.L1012
	.cfi_endproc
.LFE261:
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlRecoverySuperblock,"ax",@progbits
	.align	2
	.global	FtlRecoverySuperblock
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
.LFB281:
	.loc 2 1705 0
	.cfi_startproc
.LVL1371:
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	.loc 2 1719 0
	mov	w1, 65535
	.loc 2 1705 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.loc 2 1719 0
	ldrh	w0, [x0]
.LVL1372:
	.loc 2 1705 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.loc 2 1719 0
	cmp	w0, w1
	.loc 2 1705 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	.loc 2 1719 0
	beq	.L1140
	.loc 2 1725 0
	ldrb	w0, [x19, 6]
	str	w0, [x29, 164]
	.loc 2 1730 0
	adrp	x0, .LANCHOR19
	.loc 2 1724 0
	ldrh	w26, [x19, 2]
.LVL1373:
	str	x0, [x29, 128]
	.loc 2 1730 0
	ldrh	w2, [x0, #:lo12:.LANCHOR19]
	cmp	w2, w26
	bne	.L1019
	.loc 2 1731 0
	strh	wzr, [x19, 4]
.LVL1374:
.L1146:
	.loc 2 1758 0
	strb	wzr, [x19, 6]
.LVL1375:
.L1140:
	.loc 2 2059 0
	ldp	x19, x20, [sp, 16]
.LVL1376:
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1377:
.L1019:
	.cfi_restore_state
	.loc 2 1738 0
	ldrh	w0, [x19, 16]
.LVL1378:
	.loc 2 1737 0
	mov	w20, 0
.LVL1379:
.L1020:
	.loc 2 1739 0
	cmp	w0, w1
	beq	.L1021
	.loc 2 1746 0
	mov	w1, 1
	bl	FtlGetLastWrittenPage
.LVL1380:
	mov	w23, w0
.LVL1381:
	.loc 2 1754 0
	cmn	w0, #1
	beq	.L1022
	.loc 2 1770 0
	adrp	x1, .LANCHOR91
	.loc 2 1766 0
	adrp	x2, .LANCHOR3
	.loc 2 1769 0
	adrp	x20, .LANCHOR120
.LVL1382:
	.loc 2 1771 0
	add	x4, x19, 16
	.loc 2 1770 0
	ldr	x5, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR23
	.loc 2 1769 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
.LVL1383:
	.loc 2 1771 0
	mov	w22, 0
	.loc 2 1770 0
	ldrh	w6, [x1, #:lo12:.LANCHOR23]
	.loc 2 1771 0
	adrp	x1, .LANCHOR92
	.loc 2 1768 0
	mov	w10, 65535
	str	x2, [x29, 152]
	.loc 2 1771 0
	ldr	x7, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR24
	ldrh	w8, [x1, #:lo12:.LANCHOR24]
	add	x1, x19, 16
	str	x1, [x29, 168]
	ldrh	w1, [x2, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1023:
.LVL1384:
	.loc 2 1766 0 discriminator 1
	cmp	x4, x1
	bne	.L1027
	.loc 2 1776 0
	mov	w2, 0
	mov	w1, w22
	bl	FlashReadPages
.LVL1385:
	.loc 2 1777 0
	adrp	x0, .LANCHOR71
	.loc 2 1779 0
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	.loc 2 1791 0
	and	w10, w23, 65535
	.loc 2 1782 0
	add	x7, x0, :lo12:.LANCHOR71
	.loc 2 1777 0
	ldr	w21, [x0, #:lo12:.LANCHOR71]
	mov	x11, x4
	.loc 2 1715 0
	mov	w6, 65535
	.loc 2 1778 0
	mov	w3, 0
	.loc 2 1777 0
	sub	w21, w21, #1
.LVL1386:
	str	x0, [x29, 144]
.LVL1387:
.L1028:
	.loc 2 1778 0 discriminator 1
	cmp	w22, w3
	bne	.L1033
	.loc 2 1796 0
	add	w22, w23, 1
.LVL1388:
	.loc 2 1798 0
	ldr	w0, [x4, 4]
	.loc 2 1796 0
	and	w22, w22, 65535
.LVL1389:
.L1142:
	.loc 2 1802 0
	lsr	w0, w0, 10
	bl	P2V_plane
.LVL1390:
	and	w27, w0, 65535
.LVL1391:
	.loc 2 1807 0
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w22
	bne	.L1035
	.loc 2 1808 0
	strh	w22, [x19, 2]
	.loc 2 1809 0
	strb	wzr, [x19, 6]
	.loc 2 1810 0
	strh	wzr, [x19, 4]
.L1035:
	.loc 2 1813 0
	ldr	w0, [x29, 164]
	cmp	w22, w26
	cset	w1, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w1, w0
	beq	.L1036
.LVL1392:
.L1147:
	.loc 2 2053 0
	mov	w2, w27
	mov	w1, w22
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
.LVL1393:
	b	.L1140
.LVL1394:
.L1021:
	.loc 2 1740 0
	add	w20, w20, 1
.LVL1395:
	and	w20, w20, 65535
.LVL1396:
	.loc 2 1741 0
	add	x0, x19, x20, sxtw 1
.LVL1397:
	ldrh	w0, [x0, 16]
.LVL1398:
	b	.L1020
.LVL1399:
.L1022:
	.loc 2 1755 0
	cbz	w26, .L1024
	.loc 2 1755 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
.LVL1400:
	mov	w2, 1755
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1401:
.L1024:
	.loc 2 1756 0 is_stmt 1
	ldr	w0, [x29, 164]
	cmp	w0, 0
	ccmp	w20, w0, 4, ne
	beq	.L1025
	.loc 2 1756 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	mov	w2, 1756
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1402:
.L1025:
	.loc 2 1757 0 is_stmt 1
	strh	wzr, [x19, 2]
	b	.L1146
.LVL1403:
.L1027:
	.loc 2 1767 0
	ldrh	w3, [x4]
.LVL1404:
	.loc 2 1768 0
	cmp	w3, w10
	beq	.L1026
	.loc 2 1769 0
	ubfiz	x2, x22, 5, 16
	orr	w3, w23, w3, lsl 10
.LVL1405:
	add	x2, x0, x2
	str	w3, [x2, 4]
	.loc 2 1770 0
	mul	w3, w22, w6
	asr	w3, w3, 2
	add	x3, x5, x3, sxtw 2
	str	x3, [x2, 8]
	.loc 2 1771 0
	mul	w3, w22, w8
	.loc 2 1772 0
	add	w22, w22, 1
.LVL1406:
	and	w22, w22, 65535
.LVL1407:
	.loc 2 1771 0
	asr	w3, w3, 2
	add	x3, x7, x3, sxtw 2
	str	x3, [x2, 16]
.L1026:
	add	x4, x4, 2
.LVL1408:
	b	.L1023
.LVL1409:
.L1033:
	.loc 2 1779 0
	ldr	w0, [x11]
	cbnz	w0, .L1029
	.loc 2 1780 0
	ldr	x8, [x11, 16]
.LVL1410:
	.loc 2 1781 0
	ldr	w5, [x8, 4]
	cmn	w5, #1
	beq	.L1030
	.loc 2 1782 0
	ldr	w1, [x7]
	mov	w0, w5
	bl	ftl_cmp_data_ver
.LVL1411:
	cbz	w0, .L1030
	.loc 2 1784 0
	add	w5, w5, 1
	str	w5, [x7]
.L1030:
	.loc 2 1787 0
	ldr	w0, [x8]
	cmn	w0, #1
	bne	.L1032
	.loc 2 1802 0
	ubfiz	x3, x3, 5, 16
.LVL1412:
	.loc 2 1801 0
	and	w22, w23, 65535
.LVL1413:
	.loc 2 1802 0
	add	x3, x4, x3
	ldr	w0, [x3, 4]
	b	.L1142
.LVL1414:
.L1029:
	.loc 2 1791 0
	mov	w6, w10
.LVL1415:
.L1032:
	.loc 2 1778 0 discriminator 2
	add	w3, w3, 1
.LVL1416:
	add	x11, x11, 32
	and	w3, w3, 65535
.LVL1417:
	b	.L1028
.LVL1418:
.L1036:
	.loc 2 1819 0
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1037
	.loc 2 1819 0 is_stmt 0 discriminator 1
	ldrb	w0, [x19, 8]
	cbnz	w0, .L1038
.L1037:
.LVL1419:
.LBB304:
	.loc 2 1824 0 is_stmt 1
	adrp	x25, .LANCHOR153
	.loc 2 1823 0
	and	w28, w23, 65535
.LVL1420:
	.loc 2 1824 0
	ldr	w0, [x25, #:lo12:.LANCHOR153]
	cmn	w0, #1
	bne	.L1039
	.loc 2 1825 0
	str	w21, [x25, #:lo12:.LANCHOR153]
.L1039:
.LVL1421:
	.loc 2 1827 0
	add	w0, w26, 7
	cmp	w0, w23, uxth
	bge	.L1089
	.loc 2 1828 0
	sub	w24, w28, #7
	and	w24, w24, 65535
.LVL1422:
.L1040:
	.loc 2 1831 0 discriminator 1
	ldr	x0, [x29, 152]
	.loc 2 1833 0 discriminator 1
	mov	w3, 65535
	mov	w5, 1
	.loc 2 1831 0 discriminator 1
	add	x4, x0, :lo12:.LANCHOR3
.LVL1423:
.L1041:
	.loc 2 1829 0 discriminator 1
	cmp	w24, w28
	bhi	.L1051
	ldrh	w1, [x4]
	.loc 2 1834 0
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	add	x1, x1, 8
	ldr	x2, [x29, 168]
	add	x1, x19, x1, lsl 1
	b	.L1052
.LVL1424:
.L1089:
	mov	w24, w26
	b	.L1040
.LVL1425:
.L1043:
	.loc 2 1832 0
	ldrh	w6, [x2]
.LVL1426:
	.loc 2 1833 0
	cmp	w6, w3
	beq	.L1042
	.loc 2 1834 0
	ubfiz	x7, x23, 5, 16
	.loc 2 1835 0
	add	w23, w23, 1
.LVL1427:
	.loc 2 1834 0
	add	x7, x0, x7
	.loc 2 1835 0
	and	w23, w23, 65535
.LVL1428:
	.loc 2 1834 0
	orr	w6, w24, w6, lsl 10
.LVL1429:
	str	w6, [x7, 4]
.L1042:
	add	x2, x2, 2
.LVL1430:
.L1052:
	.loc 2 1831 0 discriminator 1
	cmp	x2, x1
	bne	.L1043
	.loc 2 1838 0
	mov	w1, w23
	mov	w2, 0
	str	w5, [x29, 112]
	ubfiz	x23, x23, 5, 16
.LVL1431:
	str	w3, [x29, 120]
	add	x23, x23, 16
	str	x4, [x29, 136]
	bl	FlashReadPages
.LVL1432:
	.loc 2 1840 0
	ldr	x2, [x20, #:lo12:.LANCHOR120]
	ldr	w1, [x25, #:lo12:.LANCHOR153]
	.loc 2 1839 0
	ldr	w5, [x29, 112]
	add	x0, x2, 16
	ldr	w3, [x29, 120]
	add	x23, x2, x23
	ldr	x4, [x29, 136]
	mov	w2, 0
.LVL1433:
.L1044:
	.loc 2 1839 0 is_stmt 0 discriminator 1
	cmp	x23, x0
	bne	.L1049
	cbz	w2, .L1050
	str	w1, [x25, #:lo12:.LANCHOR153]
.L1050:
	.loc 2 1829 0 is_stmt 1
	add	w24, w24, 1
.LVL1434:
	and	w24, w24, 65535
.LVL1435:
	b	.L1041
.L1049:
	.loc 2 1840 0
	ldr	w6, [x0, -16]
	cbz	w6, .L1045
	cbz	w2, .L1038
	str	w1, [x25, #:lo12:.LANCHOR153]
.LVL1436:
.L1038:
.LBE304:
	.loc 2 1863 0
	mov	w1, 1
	adrp	x0, .LANCHOR161
	.loc 2 1864 0
	mov	w23, w26
	.loc 2 2024 0
	adrp	x28, .LANCHOR153
	.loc 2 1863 0
	strh	w1, [x0, #:lo12:.LANCHOR161]
	.loc 2 1864 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL1437:
.LBB305:
	.loc 2 1946 0
	add	x0, x28, :lo12:.LANCHOR153
	str	x0, [x29, 104]
.LVL1438:
.L1053:
	ldr	x1, [x29, 152]
.LBE305:
	.loc 2 1869 0
	mov	w24, 0
	.loc 2 1873 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	.loc 2 1872 0
	mov	w5, 65535
	.loc 2 1870 0
	ldr	x2, [x29, 168]
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.LVL1439:
.L1054:
	.loc 2 1870 0 is_stmt 0 discriminator 1
	cmp	x1, x2
	bne	.L1056
	.loc 2 1877 0 is_stmt 1
	mov	w2, 0
	mov	w1, w24
	bl	FlashReadPages
.LVL1440:
	.loc 2 1878 0
	mov	x25, 0
	ubfiz	x0, x24, 5, 16
	str	x0, [x29, 112]
	.loc 2 2018 0
	adrp	x0, .LANCHOR162
	add	x0, x0, :lo12:.LANCHOR162
	str	x0, [x29, 120]
.LVL1441:
.L1057:
	.loc 2 1878 0 discriminator 1
	ldr	x0, [x29, 112]
	cmp	x25, x0
	bne	.L1083
	.loc 2 2032 0
	ldr	x0, [x29, 128]
	.loc 2 2031 0
	add	w23, w23, 1
.LVL1442:
	and	w23, w23, 65535
.LVL1443:
	.loc 2 2032 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w23
	bne	.L1053
	.loc 2 2035 0
	ldr	x0, [x29, 152]
	.loc 2 2037 0
	mov	w2, 65535
	.loc 2 2033 0
	strh	w23, [x19, 2]
	.loc 2 2034 0
	strh	wzr, [x19, 4]
.LVL1444:
	.loc 2 2035 0
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.LVL1445:
.L1084:
	.loc 2 2035 0 is_stmt 0 discriminator 1
	cmp	w0, w1
	beq	.L1140
.LVL1446:
	.loc 2 2037 0 is_stmt 1
	ldr	x4, [x29, 168]
	ldrh	w3, [x4], 2
	str	x4, [x29, 168]
.LVL1447:
	cmp	w3, w2
	beq	.L1085
	.loc 2 2038 0
	strb	w0, [x19, 6]
.LVL1448:
	.loc 2 2039 0
	b	.L1140
.LVL1449:
.L1045:
.LBB306:
	.loc 2 1841 0
	ldr	x6, [x0]
.LVL1450:
	.loc 2 1842 0
	ldrh	w7, [x6]
	cmp	w7, w3
	beq	.L1048
	.loc 2 1844 0
	ldr	w6, [x6, 4]
.LVL1451:
	cmn	w6, #1
	csel	w1, w1, w6, eq
	csel	w2, w2, w5, eq
.L1048:
	add	x0, x0, 32
.LVL1452:
	b	.L1044
.LVL1453:
.L1051:
	.loc 2 1858 0
	mov	w0, -1
	str	w0, [x25, #:lo12:.LANCHOR153]
	b	.L1038
.LVL1454:
.L1056:
.LBE306:
	.loc 2 1871 0
	ldrh	w3, [x2]
.LVL1455:
	.loc 2 1872 0
	cmp	w3, w5
	beq	.L1055
	.loc 2 1873 0
	ubfiz	x4, x24, 5, 16
	.loc 2 1874 0
	add	w24, w24, 1
.LVL1456:
	.loc 2 1873 0
	add	x4, x0, x4
	.loc 2 1874 0
	and	w24, w24, 65535
.LVL1457:
	.loc 2 1873 0
	orr	w3, w23, w3, lsl 10
.LVL1458:
	str	w3, [x4, 4]
.L1055:
	add	x2, x2, 2
.LVL1459:
	b	.L1054
.LVL1460:
.L1083:
	.loc 2 1879 0
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 188]
	.loc 2 1880 0
	lsr	w0, w5, 10
	bl	P2V_plane
.LVL1461:
	and	w0, w0, 65535
.LVL1462:
	.loc 2 1882 0
	cmp	w23, w26
	bcc	.L1058
	.loc 2 1882 0 is_stmt 0 discriminator 1
	ldr	w1, [x29, 164]
	ccmp	w1, w0, 0, eq
	bhi	.L1058
	.loc 2 1886 0 is_stmt 1
	cmp	w23, w22
	ccmp	w27, w0, 0, eq
	beq	.L1059
.LVL1463:
	.loc 2 1890 0
	ldr	w0, [x4]
.LVL1464:
	cmn	w0, #1
	beq	.L1060
	.loc 2 1891 0
	ldr	x3, [x4, 16]
.LVL1465:
	.loc 2 1892 0
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L1061
.LVL1466:
.L1067:
.LBB307:
	.loc 2 1925 0
	ldrh	w0, [x19]
.LVL1467:
.L1145:
.LBE307:
	.loc 2 2009 0
	bl	decrement_vpc_count
.LVL1468:
.L1058:
	add	x25, x25, 32
	b	.L1057
.LVL1469:
.L1061:
	.loc 2 1898 0
	ldr	w21, [x3, 4]
.LVL1470:
	.loc 2 1899 0
	cmn	w21, #1
	beq	.L1062
	.loc 2 1900 0 discriminator 1
	ldr	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR71]
	mov	w0, w21
	bl	ftl_cmp_data_ver
.LVL1471:
	.loc 2 1899 0 discriminator 1
	cbz	w0, .L1062
	.loc 2 1902 0
	ldr	x1, [x29, 144]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR71]
.L1062:
	.loc 2 1907 0
	ldp	w24, w0, [x3, 8]
	.loc 2 1908 0
	add	x1, x29, 184
	.loc 2 1907 0
	str	w0, [x29, 180]
	.loc 2 1908 0
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
.LVL1472:
	.loc 2 1909 0
	ldr	w1, [x28, #:lo12:.LANCHOR153]
	cmn	w1, #1
	beq	.L1063
	.loc 2 1910 0 discriminator 1
	mov	w0, w21
	bl	ftl_cmp_data_ver
.LVL1473:
	.loc 2 1909 0 discriminator 1
	cbz	w0, .L1063
.LBB308:
	.loc 2 1914 0
	ldr	w1, [x29, 180]
	cmn	w1, #1
	beq	.L1064
	.loc 2 1915 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	.loc 2 1917 0
	mov	w2, 0
	.loc 2 1915 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	.loc 2 1916 0
	str	w1, [x0, 4]
	.loc 2 1917 0
	mov	w1, 1
	.loc 2 1915 0
	str	x3, [x29, 136]
.LVL1474:
	.loc 2 1917 0
	bl	FlashReadPages
.LVL1475:
	.loc 2 1930 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	x3, [x29, 136]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1065
.LVL1476:
.L1066:
	.loc 2 1962 0
	mov	w0, -1
	str	w0, [x29, 180]
	.loc 2 1963 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1477:
.L1074:
.LBE308:
	.loc 2 2003 0
	ldr	w3, [x29, 180]
	cmn	w3, #1
	beq	.L1058
.L1088:
	.loc 2 2005 0
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1478:
	and	w24, w0, 65535
	.loc 2 2006 0
	adrp	x0, .LANCHOR5
	.loc 2 2005 0
	mov	w3, w24
.LVL1479:
	.loc 2 2006 0
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w24
	bhi	.L1079
	.loc 2 2006 0 is_stmt 0 discriminator 1
	mov	w2, 2006
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	str	w24, [x29, 136]
	bl	printf
.LVL1480:
	ldr	w3, [x29, 136]
.LVL1481:
.L1079:
	.loc 2 2007 0 is_stmt 1
	adrp	x1, .LANCHOR42
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1080
	.loc 2 2009 0
	mov	w0, w3
	b	.L1145
.LVL1482:
.L1064:
.LBB309:
	.loc 2 1921 0
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	bne	.L1067
	.loc 2 1922 0
	mov	w2, 1
	add	x1, x29, 180
	mov	w0, w24
	bl	log2phys
.LVL1483:
	b	.L1067
.LVL1484:
.L1065:
	.loc 2 1930 0 discriminator 1
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L1066
	.loc 2 1918 0 discriminator 2
	ldr	w0, [x3, 4]
	str	w0, [x29, 136]
.LVL1485:
	str	x3, [x29, 96]
	.loc 2 1931 0 discriminator 2
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR153]
	bl	ftl_cmp_data_ver
.LVL1486:
	.loc 2 1930 0 discriminator 2
	cbz	w0, .L1066
	.loc 2 1932 0
	ldp	w0, w1, [x29, 184]
	ldr	x3, [x29, 96]
	cmp	w0, w1
	.loc 2 1934 0
	ldr	w1, [x29, 180]
	.loc 2 1932 0
	bne	.L1069
.L1143:
	.loc 2 1958 0
	mov	w0, w24
	bl	FtlReUsePrevPpa
.LVL1487:
	b	.L1066
.L1069:
	.loc 2 1935 0
	cmp	w0, w1
	beq	.L1066
	.loc 2 1936 0
	cmn	w0, #1
	beq	.L1070
.LVL1488:
	.loc 2 1937 0
	ldr	x3, [x4, 16]
	.loc 2 1939 0
	mov	w2, 0
	.loc 2 1938 0
	str	w0, [x4, 4]
	.loc 2 1939 0
	mov	w1, 1
	.loc 2 1937 0
	str	x3, [x29, 96]
	.loc 2 1939 0
	mov	x0, x4
	bl	FlashReadPages
.LVL1489:
	ldr	x3, [x29, 96]
.LVL1490:
.L1071:
	.loc 2 1944 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L1072
	.loc 2 1946 0
	ldr	x0, [x29, 104]
	.loc 2 1945 0
	ldr	w3, [x3, 4]
.LVL1491:
	.loc 2 1946 0
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
.LVL1492:
	cbz	w0, .L1072
	.loc 2 1947 0
	ldr	w0, [x29, 136]
	mov	w1, w3
	bl	ftl_cmp_data_ver
.LVL1493:
	cbz	w0, .L1066
.LVL1494:
.L1072:
	.loc 2 1958 0
	ldr	w1, [x29, 180]
	b	.L1143
.L1070:
	.loc 2 1941 0
	str	w0, [x4]
	b	.L1071
.L1063:
.LBE309:
	.loc 2 1964 0
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	beq	.L1074
	.loc 2 1966 0
	mov	w2, 1
	add	x1, x29, 188
	mov	w0, w24
	bl	log2phys
.LVL1495:
	.loc 2 1967 0
	ldr	w3, [x29, 184]
	cmn	w3, #1
	beq	.L1074
	.loc 2 1967 0 is_stmt 0 discriminator 1
	ldr	w0, [x29, 180]
	cmp	w3, w0
	beq	.L1088
	.loc 2 1968 0 is_stmt 1
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1496:
	.loc 2 1970 0
	adrp	x1, .LANCHOR51
	.loc 2 1968 0
	and	w0, w0, 65535
.LVL1497:
	.loc 2 1970 0
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, w0
	beq	.L1078
	.loc 2 1971 0 discriminator 1
	adrp	x1, .LANCHOR52
	.loc 2 1970 0 discriminator 1
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	beq	.L1078
	.loc 2 1972 0
	adrp	x1, .LANCHOR53
	.loc 2 1971 0
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1074
.L1078:
.LVL1498:
.LBB310:
	.loc 2 1976 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
.LVL1499:
	.loc 2 1979 0
	mov	w2, 0
	mov	w1, 1
	.loc 2 1976 0
	ldr	x4, [x0, 16]
	.loc 2 1978 0
	str	w3, [x0, 4]
	.loc 2 1976 0
	str	x4, [x29, 136]
.LVL1500:
	.loc 2 1979 0
	bl	FlashReadPages
.LVL1501:
	.loc 2 1982 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1074
	.loc 2 1983 0
	ldr	x4, [x29, 136]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
.LVL1502:
	cbnz	w0, .L1074
	.loc 2 1990 0
	mov	w2, 1
	add	x1, x29, 184
	mov	w0, w24
	bl	log2phys
.LVL1503:
	b	.L1074
.LVL1504:
.L1080:
.LBE310:
	.loc 2 2011 0
	mov	w1, w24
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	bl	printf
.LVL1505:
	b	.L1058
.LVL1506:
.L1060:
	.loc 2 2018 0
	ldr	x0, [x29, 120]
	ldr	w0, [x0]
	cmp	w0, 31
	bhi	.L1081
	.loc 2 2019 0
	adrp	x1, .LANCHOR163
	add	x1, x1, :lo12:.LANCHOR163
	str	w5, [x1, w0, uxtw 2]
	.loc 2 2020 0
	add	w0, w0, 1
	ldr	x1, [x29, 120]
	str	w0, [x1]
.L1081:
	.loc 2 2022 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1507:
	.loc 2 2024 0
	ldr	w0, [x28, #:lo12:.LANCHOR153]
	cmn	w0, #1
	bne	.L1082
.L1144:
	.loc 2 2027 0
	str	w21, [x28, #:lo12:.LANCHOR153]
	b	.L1058
.L1082:
	.loc 2 2026 0
	cmp	w21, w0
	bcs	.L1058
	b	.L1144
.LVL1508:
.L1085:
	.loc 2 2035 0 discriminator 2
	add	w0, w0, 1
.LVL1509:
	and	w0, w0, 65535
.LVL1510:
	b	.L1084
.LVL1511:
.L1059:
	.loc 2 2051 0
	strb	w27, [x19, 6]
	.loc 2 2052 0
	strh	w22, [x19, 2]
	b	.L1147
	.cfi_endproc
.LFE281:
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
.LFB288:
	.loc 2 2205 0
	.cfi_startproc
.LVL1512:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 2 2213 0
	adrp	x1, .LANCHOR108
	.loc 2 2205 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x0
	.loc 2 2211 0
	mov	w0, -1
.LVL1513:
	.loc 2 2213 0
	ldr	x20, [x1, #:lo12:.LANCHOR108]
	.loc 2 2211 0
	str	w0, [x29, 72]
	.loc 2 2212 0
	adrp	x0, .LANCHOR107
	.loc 2 2205 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 2216 0
	mov	w1, -3
	.loc 2 2212 0
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	.loc 2 2229 0
	adrp	x21, .LANCHOR71
	.loc 2 2213 0
	str	x20, [x29, 64]
.LVL1514:
	.loc 2 2229 0
	add	x21, x21, :lo12:.LANCHOR71
	.loc 2 2212 0
	str	x0, [x29, 56]
	.loc 2 2223 0
	mov	w22, 7
	.loc 2 2216 0
	str	w1, [x20, 8]
	.loc 2 2217 0
	mov	w1, -2
	str	w1, [x20, 12]
	.loc 2 2218 0
	ldrh	w1, [x19]
	strh	w1, [x20, 2]
	.loc 2 2219 0
	strh	wzr, [x20]
	.loc 2 2220 0
	mov	w1, 61589
	str	w1, [x0]
	.loc 2 2221 0
	mov	w1, 22136
	movk	w1, 0x1234, lsl 16
	str	w1, [x0, 4]
.LVL1515:
.L1149:
	.loc 2 2223 0
	subs	w22, w22, #1
.LVL1516:
	beq	.L1151
.LVL1517:
	.loc 2 2224 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1150
.LVL1518:
.L1151:
	.loc 2 2234 0
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR42
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	.loc 2 2235 0
	adrp	x0, .LANCHOR19
	.loc 2 2236 0
	strb	wzr, [x19, 6]
	.loc 2 2237 0
	strh	wzr, [x19, 4]
	.loc 2 2235 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	strh	w0, [x19, 2]
	.loc 2 2238 0
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1519:
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1520:
.L1150:
	.cfi_restore_state
	.loc 2 2226 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL1521:
	str	w0, [x29, 52]
	.loc 2 2227 0
	cmn	w0, #1
	beq	.L1151
	.loc 2 2229 0
	ldr	w0, [x21]
	.loc 2 2230 0
	mov	w3, 0
	.loc 2 2229 0
	str	w0, [x20, 4]
	.loc 2 2230 0
	mov	w2, 0
	.loc 2 2229 0
	add	w0, w0, 1
	.loc 2 2230 0
	mov	w1, 1
	.loc 2 2229 0
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x21]
	.loc 2 2230 0
	add	x0, x29, 48
	bl	FlashProgPages
.LVL1522:
	.loc 2 2231 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1523:
	b	.L1149
	.cfi_endproc
.LFE288:
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
.LFB229:
	.loc 4 173 0
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 4 180 0
	adrp	x23, .LANCHOR107
	.loc 4 173 0
	stp	x19, x20, [sp, 16]
	.loc 4 184 0
	adrp	x24, .LANCHOR17
	.loc 4 173 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 4 180 0
	adrp	x22, .LANCHOR106
	add	x20, x22, :lo12:.LANCHOR106
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	.loc 4 173 0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	.loc 4 196 0
	mov	w25, 61649
	.loc 4 180 0
	str	x0, [x20, 8]
	.loc 4 181 0
	adrp	x0, .LANCHOR108
	ldr	x21, [x0, #:lo12:.LANCHOR108]
	str	x21, [x20, 16]
.LVL1524:
	.loc 4 183 0
	bl	FtlBbtMemInit
.LVL1525:
	.loc 4 184 0
	ldrh	w19, [x24, #:lo12:.LANCHOR17]
	add	x24, x24, :lo12:.LANCHOR17
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL1526:
.L1161:
	.loc 4 184 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	sub	w0, w0, #15
	cmp	w0, w19
	bgt	.L1164
	.loc 4 185 0 is_stmt 1
	lsl	w0, w19, 10
	.loc 4 186 0
	mov	w2, 1
	.loc 4 185 0
	str	w0, [x20, 4]
	.loc 4 186 0
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
.LVL1527:
	.loc 4 187 0
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1162
	.loc 4 188 0
	ldr	w0, [x20, 4]
	.loc 4 189 0
	mov	w2, 1
	mov	w1, w2
	.loc 4 188 0
	add	w0, w0, 1
	str	w0, [x20, 4]
	.loc 4 189 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1528:
.L1162:
	.loc 4 191 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1163
	.loc 4 196 0
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1163
	.loc 4 198 0
	adrp	x1, .LANCHOR37
	add	x0, x1, :lo12:.LANCHOR37
	strh	w19, [x1, #:lo12:.LANCHOR37]
	.loc 4 199 0
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	.loc 4 200 0
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1164:
	.loc 4 216 0
	adrp	x19, .LANCHOR37
.LVL1529:
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR37
	ldrh	w1, [x19, #:lo12:.LANCHOR37]
	cmp	w1, w0
	beq	.L1178
	.loc 4 222 0
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1168
	.loc 4 224 0
	add	x0, x22, :lo12:.LANCHOR106
	lsl	w1, w1, 10
	.loc 4 225 0
	mov	w2, 1
	.loc 4 224 0
	str	w1, [x0, 4]
	.loc 4 225 0
	mov	w1, w2
	bl	FlashReadPages
.LVL1530:
	.loc 4 226 0
	ldr	w0, [x22, #:lo12:.LANCHOR106]
	cmn	w0, #1
	beq	.L1168
	.loc 4 229 0
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1168
	.loc 4 229 0 is_stmt 0 discriminator 1
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1168
	.loc 4 231 0 is_stmt 1
	ldrh	w1, [x20, 4]
	.loc 4 232 0
	str	w0, [x20, 8]
	.loc 4 233 0
	ldrh	w0, [x21, 8]
	.loc 4 231 0
	strh	w1, [x19, #:lo12:.LANCHOR37]
	.loc 4 233 0
	strh	w0, [x20, 4]
.L1168:
	.loc 4 238 0
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	add	x24, x19, :lo12:.LANCHOR37
	mov	w1, 1
	.loc 4 247 0
	mov	w25, 61649
	.loc 4 238 0
	bl	FtlGetLastWrittenPage
.LVL1531:
	sxth	w20, w0
.LVL1532:
	.loc 4 239 0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	.loc 4 243 0
	add	x24, x22, :lo12:.LANCHOR106
.L1170:
	.loc 4 241 0
	tbz	w20, #31, .L1173
	.loc 4 254 0
	adrp	x1, .LANCHOR164
	adrp	x0, .LC1
	mov	w2, 254
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1533:
.L1172:
	.loc 4 255 0
	add	x0, x19, :lo12:.LANCHOR37
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	.loc 4 257 0
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1175
	.loc 4 259 0
	adrp	x1, .LANCHOR2
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	cmp	w0, w2
	beq	.L1175
	.loc 4 259 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1175
	.loc 4 261 0 is_stmt 1
	cmp	w0, w1
	bcs	.L1175
	.loc 4 263 0
	bl	FtlSysBlkNumInit
.LVL1534:
.L1175:
	add	x19, x19, :lo12:.LANCHOR37
	.loc 4 268 0 discriminator 1
	adrp	x21, .LANCHOR10
.LVL1535:
	.loc 4 269 0 discriminator 1
	adrp	x23, .LANCHOR137
	add	x19, x19, 32
	.loc 4 268 0 discriminator 1
	add	x21, x21, :lo12:.LANCHOR10
	.loc 4 269 0 discriminator 1
	add	x23, x23, :lo12:.LANCHOR137
	add	x22, x22, :lo12:.LANCHOR106
	.loc 4 173 0 discriminator 1
	mov	w20, 0
.LVL1536:
.L1176:
	.loc 4 268 0 discriminator 1
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1177
	.loc 4 275 0
	mov	w0, 0
.LVL1537:
.L1160:
	.loc 4 276 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1538:
.L1163:
	.cfi_restore_state
	.loc 4 184 0 discriminator 2
	sub	w19, w19, #1
.LVL1539:
	and	w19, w19, 65535
.LVL1540:
	b	.L1161
.LVL1541:
.L1173:
	.loc 4 243 0
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	.loc 4 245 0
	mov	w2, 1
	mov	w1, w2
	.loc 4 243 0
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	.loc 4 244 0
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x0, [x24, 8]
	.loc 4 245 0
	mov	x0, x24
	bl	FlashReadPages
.LVL1542:
	.loc 4 247 0
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L1171
	.loc 4 247 0 is_stmt 0 discriminator 1
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1172
.L1171:
	sub	w20, w20, #1
.LVL1543:
	sxth	w20, w20
.LVL1544:
	b	.L1170
.LVL1545:
.L1177:
	.loc 4 269 0 is_stmt 1 discriminator 3
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	.loc 4 268 0 discriminator 3
	add	w20, w20, 1
.LVL1546:
	.loc 4 269 0 discriminator 3
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
.LVL1547:
	b	.L1176
.LVL1548:
.L1178:
	.loc 4 218 0
	mov	w0, -1
	b	.L1160
	.cfi_endproc
.LFE229:
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.FtlMakeBbt,"ax",@progbits
	.align	2
	.global	FtlMakeBbt
	.type	FtlMakeBbt, %function
FtlMakeBbt:
.LFB231:
	.loc 4 317 0
	.cfi_startproc
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.loc 4 327 0
	mov	w22, 0
	.loc 4 317 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	adrp	x20, .LANCHOR37
	stp	x23, x24, [sp, 48]
	add	x21, x20, :lo12:.LANCHOR37
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	.cfi_offset 25, -64
	.cfi_offset 26, -56
	add	x24, x21, 32
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -48
	.cfi_offset 28, -40
	.loc 4 325 0
	bl	FtlBbtMemInit
.LVL1549:
	.loc 4 326 0
	bl	FtlLoadFactoryBbt
.LVL1550:
	.loc 4 328 0
	adrp	x28, .LANCHOR106
	add	x21, x21, 12
	.loc 4 356 0
	add	x25, x28, :lo12:.LANCHOR106
	.loc 4 327 0
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	str	x0, [x29, 120]
.LVL1551:
.L1191:
	.loc 4 327 0 is_stmt 0 discriminator 1
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L1197
	.loc 4 381 0 is_stmt 1 discriminator 1
	adrp	x21, .LANCHOR25
	add	x21, x21, :lo12:.LANCHOR25
	mov	w19, 0
.L1198:
.LVL1552:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L1199
	.loc 4 387 0
	add	x21, x20, :lo12:.LANCHOR37
	.loc 4 396 0
	mov	w22, 65535
.LVL1553:
	.loc 4 387 0
	ldrh	w19, [x21, 12]
.LVL1554:
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL1555:
.L1200:
	.loc 4 387 0 is_stmt 0 discriminator 1
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1204
	.loc 4 389 0 is_stmt 1
	mov	w0, w19
	bl	FtlBbmIsBadBlock
.LVL1556:
	cmp	w0, 1
	beq	.L1201
	.loc 4 391 0
	mov	w0, w19
	bl	FlashTestBlk
.LVL1557:
	cbz	w0, .L1202
	.loc 4 393 0
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.LVL1558:
.L1201:
	.loc 4 387 0 discriminator 2
	sub	w19, w19, #1
.LVL1559:
	and	w19, w19, 65535
.LVL1560:
	b	.L1200
.LVL1561:
.L1197:
	.loc 4 329 0
	adrp	x2, .LANCHOR108
	.loc 4 328 0
	adrp	x0, .LANCHOR107
	add	x19, x28, :lo12:.LANCHOR106
	.loc 4 331 0
	ldrh	w1, [x21]
	.loc 4 328 0
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	.loc 4 331 0
	mov	w3, 65535
	.loc 4 329 0
	ldr	x26, [x2, #:lo12:.LANCHOR108]
	.loc 4 331 0
	cmp	w1, w3
	.loc 4 329 0
	stp	x0, x26, [x19, 8]
.LVL1562:
	adrp	x23, .LANCHOR17
	str	x2, [x29, 112]
	.loc 4 331 0
	beq	.L1192
	.loc 4 333 0
	ldrh	w4, [x23, #:lo12:.LANCHOR17]
	.loc 4 335 0
	mov	w2, 1
	.loc 4 333 0
	madd	w27, w4, w22, w1
.LVL1563:
	.loc 4 335 0
	mov	w1, w2
	.loc 4 334 0
	lsl	w0, w27, 10
	str	w0, [x19, 4]
	.loc 4 335 0
	mov	x0, x19
	bl	FlashReadPages
.LVL1564:
	.loc 4 336 0
	ldr	x1, [x19, 8]
	ldr	x0, [x24]
	ldrh	w2, [x23, #:lo12:.LANCHOR17]
	add	w2, w2, 7
	lsr	w2, w2, 3
	bl	ftl_memcpy
.LVL1565:
.L1193:
	.loc 4 376 0 discriminator 2
	mov	w0, w27
	.loc 4 327 0 discriminator 2
	add	w22, w22, 1
.LVL1566:
	.loc 4 376 0 discriminator 2
	bl	FtlBbmMapBadBlock
.LVL1567:
	add	x24, x24, 8
	add	x21, x21, 2
	b	.L1191
.LVL1568:
.L1192:
	.loc 4 340 0
	mov	w1, w22
	bl	FlashGetBadBlockList
.LVL1569:
	.loc 4 341 0
	ldr	x0, [x19, 8]
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
.LVL1570:
	.loc 4 343 0
	ldrh	w19, [x23, #:lo12:.LANCHOR17]
	.loc 4 345 0
	add	x23, x23, :lo12:.LANCHOR17
	.loc 4 357 0
	adrp	x0, .LANCHOR137
	.loc 4 343 0
	sub	w19, w19, #1
	.loc 4 357 0
	add	x0, x0, :lo12:.LANCHOR137
	.loc 4 343 0
	and	w19, w19, 65535
.LVL1571:
	.loc 4 357 0
	str	x0, [x29, 104]
.L1194:
	.loc 4 345 0
	ldrh	w0, [x23]
	madd	w0, w22, w0, w19
	bl	FtlBbmIsBadBlock
.LVL1572:
	cmp	w0, 1
	beq	.L1195
	.loc 4 350 0
	ldr	x0, [x29, 112]
	mov	w2, 16
	.loc 4 349 0
	strh	w19, [x21]
	.loc 4 350 0
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	bl	ftl_memset
.LVL1573:
	.loc 4 351 0
	adrp	x0, .LANCHOR107
	mov	w2, 4096
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	bl	ftl_memset
.LVL1574:
	.loc 4 352 0
	mov	w0, -3872
	strh	w0, [x26]
	.loc 4 355 0
	ldrh	w4, [x23]
	.loc 4 354 0
	ldrh	w0, [x21]
	strh	w0, [x26, 2]
	.loc 4 357 0
	ldr	x1, [x24]
	.loc 4 353 0
	str	wzr, [x26, 4]
	.loc 4 355 0
	madd	w27, w4, w22, w0
.LVL1575:
	.loc 4 356 0
	lsl	w0, w27, 10
	str	w0, [x25, 4]
	.loc 4 357 0
	ldr	x0, [x29, 104]
	ldrh	w2, [x0]
	ldr	x0, [x25, 8]
	lsl	w2, w2, 2
	bl	ftl_memcpy
.LVL1576:
	.loc 4 358 0
	mov	w2, 1
	mov	x0, x25
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL1577:
	.loc 4 359 0
	mov	w3, 1
	mov	x0, x25
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1578:
	.loc 4 360 0
	ldr	w0, [x25]
	cmn	w0, #1
	bne	.L1193
	.loc 4 362 0
	mov	w0, w27
	bl	FtlBbmMapBadBlock
.LVL1579:
	.loc 4 363 0
	b	.L1194
.LVL1580:
.L1195:
	.loc 4 347 0
	sub	w19, w19, #1
.LVL1581:
	and	w19, w19, 65535
.LVL1582:
	b	.L1194
.LVL1583:
.L1199:
	.loc 4 383 0 discriminator 3
	mov	w0, w19
	.loc 4 381 0 discriminator 3
	add	w19, w19, 1
.LVL1584:
	.loc 4 383 0 discriminator 3
	bl	FtlBbmMapBadBlock
.LVL1585:
	.loc 4 381 0 discriminator 3
	and	w19, w19, 65535
.LVL1586:
	b	.L1198
.LVL1587:
.L1202:
	.loc 4 396 0
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L1203
	.loc 4 398 0
	strh	w19, [x21]
	b	.L1201
.L1203:
	.loc 4 402 0
	strh	w19, [x21, 4]
.L1204:
	.loc 4 414 0
	adrp	x0, .LANCHOR111
	.loc 4 411 0
	add	x19, x20, :lo12:.LANCHOR37
.LVL1588:
	.loc 4 414 0
	ldrh	w1, [x20, #:lo12:.LANCHOR37]
	.loc 4 416 0
	mov	w2, 2
	.loc 4 414 0
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	.loc 4 413 0
	str	wzr, [x19, 8]
	.loc 4 414 0
	lsl	w1, w1, 10
	.loc 4 411 0
	strh	wzr, [x19, 2]
	.loc 4 414 0
	str	w1, [x0, 4]
	.loc 4 415 0
	ldrh	w1, [x19, 4]
	lsl	w1, w1, 10
	str	w1, [x0, 36]
	.loc 4 416 0
	mov	w1, 1
	bl	FlashEraseBlocks
.LVL1589:
	.loc 4 418 0
	ldrh	w0, [x20, #:lo12:.LANCHOR37]
	bl	FtlBbmMapBadBlock
.LVL1590:
	.loc 4 419 0
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
.LVL1591:
	.loc 4 421 0
	bl	FtlBbmTblFlush
.LVL1592:
	.loc 4 426 0
	strh	wzr, [x19, 2]
	.loc 4 422 0
	ldr	w0, [x19, 8]
	.loc 4 425 0
	ldrh	w1, [x19, 4]
	.loc 4 422 0
	add	w0, w0, 1
	str	w0, [x19, 8]
	.loc 4 424 0
	ldrh	w0, [x20, #:lo12:.LANCHOR37]
.LVL1593:
	.loc 4 427 0
	strh	w0, [x19, 4]
	.loc 4 425 0
	strh	w1, [x20, #:lo12:.LANCHOR37]
	.loc 4 429 0
	bl	FtlBbmTblFlush
.LVL1594:
	.loc 4 432 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE231:
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.FtlVendorPartWrite,"ax",@progbits
	.align	2
	.global	FtlVendorPartWrite
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
.LFB263:
	.loc 2 835 0
	.cfi_startproc
.LVL1595:
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	w20, w1
	stp	x27, x28, [sp, 80]
	.loc 2 843 0
	add	w1, w0, w1
.LVL1596:
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 2 835 0
	mov	w28, w0
.LVL1597:
	.loc 2 843 0
	adrp	x0, .LANCHOR16
.LVL1598:
	.loc 2 835 0
	stp	x21, x22, [sp, 32]
	.loc 2 843 0
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	.loc 2 835 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.loc 2 843 0
	cmp	w1, w0
	bhi	.L1218
	.loc 2 840 0
	adrp	x0, .LANCHOR22
	.loc 2 848 0
	adrp	x25, .LANCHOR12
	.loc 2 858 0
	adrp	x26, .LANCHOR23
	mov	x24, x2
	.loc 2 840 0
	ldrh	w21, [x0, #:lo12:.LANCHOR22]
	.loc 2 848 0
	add	x25, x25, :lo12:.LANCHOR12
	.loc 2 858 0
	add	x26, x26, :lo12:.LANCHOR23
	.loc 2 840 0
	mov	w23, 0
	lsr	w21, w28, w21
.LVL1599:
.L1212:
	.loc 2 846 0
	cbnz	w20, .L1217
.LVL1600:
.L1210:
	.loc 2 869 0
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
.LVL1601:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1602:
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1603:
.L1217:
	.cfi_restore_state
	.loc 2 848 0
	ldrh	w1, [x25]
	.loc 2 847 0
	adrp	x0, .LANCHOR133
	adrp	x27, .LANCHOR124
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	.loc 2 848 0
	udiv	w22, w28, w1
	.loc 2 847 0
	ldr	w2, [x0, w21, uxtw 2]
.LVL1604:
	.loc 2 851 0
	and	w0, w20, 65535
	.loc 2 848 0
	msub	w22, w22, w1, w28
.LVL1605:
	.loc 2 849 0
	sub	w19, w1, w22
	and	w19, w19, 65535
.LVL1606:
	.loc 2 851 0
	cmp	w20, w19
	csel	w19, w0, w19, cc
.LVL1607:
	.loc 2 852 0
	cbz	w2, .L1214
	.loc 2 852 0 is_stmt 0 discriminator 1
	cmp	w19, w1
	beq	.L1214
	.loc 2 854 0 is_stmt 1
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	.loc 2 855 0
	add	x0, x29, 144
	.loc 2 853 0
	str	w2, [x29, 116]
	.loc 2 856 0
	mov	w2, 1
.LVL1608:
	.loc 2 855 0
	str	x0, [x29, 128]
	.loc 2 856 0
	mov	w1, w2
	add	x0, x29, 112
.LVL1609:
	bl	FlashReadPages
.LVL1610:
.L1215:
	.loc 2 860 0
	lsl	w4, w19, 9
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	lsl	w22, w22, 7
.LVL1611:
	mov	w2, w4
	mov	x1, x24
	str	w4, [x29, 108]
	add	x0, x0, x22, sxtw 2
	bl	ftl_memcpy
.LVL1612:
	.loc 2 861 0
	ldr	x2, [x27, #:lo12:.LANCHOR124]
	mov	w1, w21
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	.loc 2 864 0
	sub	w20, w20, w19
.LVL1613:
	.loc 2 865 0
	add	w28, w28, w19
.LVL1614:
	.loc 2 863 0
	add	w21, w21, 1
.LVL1615:
	.loc 2 861 0
	bl	FtlMapWritePage
.LVL1616:
	.loc 2 862 0
	cmn	w0, #1
	.loc 2 866 0
	ldr	w4, [x29, 108]
	.loc 2 862 0
	csinv	w23, w23, wzr, ne
.LVL1617:
	.loc 2 866 0
	add	x24, x24, x4, sxtw
.LVL1618:
	b	.L1212
.LVL1619:
.L1214:
	.loc 2 858 0
	ldrh	w2, [x26]
.LVL1620:
	mov	w1, 0
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	bl	ftl_memset
.LVL1621:
	b	.L1215
.LVL1622:
.L1218:
	.loc 2 844 0
	mov	w23, -1
	b	.L1210
	.cfi_endproc
.LFE263:
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
.LFB286:
	.loc 2 2159 0
	.cfi_startproc
	.loc 2 2160 0
	adrp	x0, .LANCHOR81
	add	x2, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, #:lo12:.LANCHOR81]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1223
.LBB313:
.LBB314:
	.loc 2 2161 0
	mov	w0, 68
	.loc 2 2174 0
	mov	w1, 1
	.loc 2 2161 0
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	.loc 2 2162 0
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	str	w0, [x2, 88]
	.loc 2 2163 0
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	str	w0, [x2, 92]
	.loc 2 2164 0
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	str	w0, [x2, 8]
	.loc 2 2165 0
	adrp	x0, .LANCHOR64
	ldr	w0, [x0, #:lo12:.LANCHOR64]
	str	w0, [x2, 12]
	.loc 2 2166 0
	adrp	x0, .LANCHOR62
	ldr	w0, [x0, #:lo12:.LANCHOR62]
	str	w0, [x2, 16]
	.loc 2 2167 0
	adrp	x0, .LANCHOR66
	ldr	w0, [x0, #:lo12:.LANCHOR66]
	str	w0, [x2, 20]
	.loc 2 2168 0
	adrp	x0, .LANCHOR73
	ldr	w0, [x0, #:lo12:.LANCHOR73]
	str	w0, [x2, 28]
	.loc 2 2169 0
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	str	w0, [x2, 32]
	.loc 2 2170 0
	adrp	x0, .LANCHOR63
	ldr	w0, [x0, #:lo12:.LANCHOR63]
	str	w0, [x2, 36]
	.loc 2 2171 0
	adrp	x0, .LANCHOR65
	ldr	w0, [x0, #:lo12:.LANCHOR65]
	str	w0, [x2, 40]
	.loc 2 2172 0
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	str	w0, [x2, 44]
	.loc 2 2173 0
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	str	w0, [x2, 48]
	.loc 2 2174 0
	mov	w0, 0
	b	FtlVendorPartWrite
.LVL1623:
.L1223:
	ret
.LBE314:
.LBE313:
	.cfi_endproc
.LFE286:
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
.LFB265:
	.loc 2 910 0
	.cfi_startproc
.LVL1624:
	.loc 2 913 0
	adrp	x2, .LANCHOR165
	ldrh	w1, [x2, #:lo12:.LANCHOR165]
	cmp	w1, 31
	bhi	.L1229
	.loc 2 914 0
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR165]
.LVL1625:
	.loc 2 915 0
	mov	w1, 1
.LVL1626:
.L1226:
	adrp	x2, .LANCHOR127
	.loc 2 917 0
	cbnz	w0, .L1227
	.loc 2 917 0 is_stmt 0 discriminator 1
	ldr	x0, [x2, #:lo12:.LANCHOR127]
.LVL1627:
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
.LVL1628:
	cmp	w0, w1
	bcc	.L1231
.L1227:
	.loc 2 910 0 is_stmt 1
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 919 0
	ldr	x2, [x2, #:lo12:.LANCHOR127]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	.loc 2 920 0
	mov	w0, 17221
	.loc 2 923 0
	str	wzr, [x2, 4]
	.loc 2 920 0
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	.loc 2 921 0
	adrp	x0, .LANCHOR125
	ldrh	w1, [x0, #:lo12:.LANCHOR125]
	lsl	w0, w1, 9
	str	w0, [x2, 12]
	.loc 2 922 0
	ldr	w0, [x2, 8]
	add	w0, w0, 1
	str	w0, [x2, 8]
	.loc 2 924 0
	mov	w0, 64
	bl	FtlVendorPartWrite
.LVL1629:
	.loc 2 925 0
	bl	Ftl_save_ext_data
.LVL1630:
	.loc 2 927 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL1631:
.L1229:
	.loc 2 911 0
	mov	w1, 32
	b	.L1226
.LVL1632:
.L1231:
	.loc 2 927 0
	mov	w0, 0
	ret
	.cfi_endproc
.LFE265:
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.FtlVendorPartRead,"ax",@progbits
	.align	2
	.global	FtlVendorPartRead
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
.LFB264:
	.loc 2 872 0
	.cfi_startproc
.LVL1633:
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	.loc 2 881 0
	add	w1, w0, w1
.LVL1634:
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.loc 2 872 0
	mov	w21, w0
.LVL1635:
	.loc 2 881 0
	adrp	x0, .LANCHOR16
.LVL1636:
	.loc 2 872 0
	stp	x23, x24, [sp, 48]
	.loc 2 881 0
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	.loc 2 872 0
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 2 881 0
	cmp	w1, w0
	bhi	.L1241
	.loc 2 877 0
	adrp	x0, .LANCHOR22
	.loc 2 885 0
	adrp	x24, .LANCHOR12
	mov	x23, x2
	add	x24, x24, :lo12:.LANCHOR12
	.loc 2 877 0
	ldrh	w3, [x0, #:lo12:.LANCHOR22]
	mov	w22, 0
	.loc 2 884 0
	adrp	x25, .LANCHOR133
	.loc 2 877 0
	lsr	w26, w21, w3
.LVL1637:
.L1235:
	.loc 2 883 0
	cbnz	w20, .L1240
.LVL1638:
.L1233:
	.loc 2 906 0
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
.LVL1639:
	ldp	x21, x22, [sp, 32]
.LVL1640:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1641:
.L1240:
	.cfi_restore_state
	.loc 2 885 0
	ldrh	w19, [x24]
	.loc 2 884 0
	ldr	x0, [x25, #:lo12:.LANCHOR133]
	.loc 2 885 0
	udiv	w27, w21, w19
	.loc 2 884 0
	ldr	w1, [x0, w26, uxtw 2]
.LVL1642:
	.loc 2 888 0
	and	w0, w20, 65535
	.loc 2 885 0
	msub	w27, w27, w19, w21
.LVL1643:
	.loc 2 886 0
	sub	w19, w19, w27
	and	w19, w19, 65535
.LVL1644:
	.loc 2 888 0
	cmp	w20, w19
	csel	w19, w0, w19, cc
.LVL1645:
	lsl	w28, w19, 9
	.loc 2 889 0
	cbz	w1, .L1237
	.loc 2 891 0
	adrp	x4, .LANCHOR124
	.loc 2 893 0
	mov	w2, 1
	.loc 2 891 0
	str	x4, [x29, 104]
	.loc 2 896 0
	lsl	w27, w27, 7
.LVL1646:
	.loc 2 891 0
	ldr	x0, [x4, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	.loc 2 892 0
	add	x0, x29, 144
	.loc 2 890 0
	str	w1, [x29, 116]
	.loc 2 893 0
	mov	w1, w2
.LVL1647:
	.loc 2 892 0
	str	x0, [x29, 128]
	.loc 2 893 0
	add	x0, x29, 112
.LVL1648:
	bl	FlashReadPages
.LVL1649:
	.loc 2 896 0
	ldr	x4, [x29, 104]
	mov	w2, w28
	.loc 2 895 0
	ldr	w0, [x29, 112]
	cmn	w0, #1
	.loc 2 896 0
	mov	x0, x23
	ldr	x1, [x4, #:lo12:.LANCHOR124]
	.loc 2 895 0
	csinv	w22, w22, wzr, ne
.LVL1650:
	.loc 2 896 0
	add	x1, x1, x27, sxtw 2
	bl	ftl_memcpy
.LVL1651:
.L1239:
	.loc 2 900 0
	add	w26, w26, 1
.LVL1652:
	.loc 2 901 0
	sub	w20, w20, w19
.LVL1653:
	.loc 2 902 0
	add	w21, w21, w19
.LVL1654:
	.loc 2 903 0
	add	x23, x23, x28, sxtw
.LVL1655:
	b	.L1235
.LVL1656:
.L1237:
	.loc 2 898 0
	mov	w2, w28
	mov	w1, 0
.LVL1657:
	mov	x0, x23
	bl	ftl_memset
.LVL1658:
	b	.L1239
.LVL1659:
.L1241:
	.loc 2 882 0
	mov	w22, -1
	b	.L1233
	.cfi_endproc
.LFE264:
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.FtlLoadEctTbl,"ax",@progbits
	.align	2
	.global	FtlLoadEctTbl
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
.LFB271:
	.loc 2 1383 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 1384 0
	mov	w0, 64
	.loc 2 1383 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 1384 0
	adrp	x19, .LANCHOR127
	adrp	x20, .LANCHOR125
	ldr	x2, [x19, #:lo12:.LANCHOR127]
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	bl	FtlVendorPartRead
.LVL1660:
	.loc 2 1385 0
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1244
.LBB317:
.LBB318:
	.loc 2 1387 0
	adrp	x1, .LC103
	adrp	x0, .LC71
	add	x1, x1, :lo12:.LC103
	add	x0, x0, :lo12:.LC71
	bl	printf
.LVL1661:
	.loc 2 1388 0
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR125]
	lsl	w2, w2, 9
	bl	ftl_memset
.LVL1662:
.L1244:
.LBE318:
.LBE317:
	.loc 2 1393 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE271:
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.Ftl_load_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_load_ext_data
	.type	Ftl_load_ext_data, %function
Ftl_load_ext_data:
.LFB287:
	.loc 2 2179 0
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	.loc 2 2180 0
	mov	w1, 1
	mov	w0, 0
	.loc 2 2179 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 2180 0
	adrp	x19, .LANCHOR81
	.loc 2 2179 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2180 0
	add	x21, x19, :lo12:.LANCHOR81
	mov	x2, x21
	bl	FtlVendorPartRead
.LVL1663:
	.loc 2 2181 0
	ldr	w0, [x19, #:lo12:.LANCHOR81]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1247
	.loc 2 2182 0
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
.LVL1664:
	.loc 2 2183 0
	str	w20, [x19, #:lo12:.LANCHOR81]
.L1247:
	.loc 2 2186 0
	ldr	w1, [x19, #:lo12:.LANCHOR81]
	add	x0, x19, :lo12:.LANCHOR81
	cmp	w1, w20
	adrp	x1, .LANCHOR73
	bne	.L1248
	.loc 2 2187 0
	adrp	x2, .LANCHOR68
	ldr	w3, [x0, 88]
	str	w3, [x2, #:lo12:.LANCHOR68]
	.loc 2 2188 0
	adrp	x2, .LANCHOR69
	ldr	w3, [x0, 92]
	str	w3, [x2, #:lo12:.LANCHOR69]
	.loc 2 2189 0
	adrp	x2, .LANCHOR67
	ldr	w3, [x0, 8]
	str	w3, [x2, #:lo12:.LANCHOR67]
	.loc 2 2190 0
	adrp	x2, .LANCHOR64
	ldr	w3, [x0, 12]
	str	w3, [x2, #:lo12:.LANCHOR64]
	.loc 2 2191 0
	adrp	x2, .LANCHOR62
	ldr	w3, [x0, 16]
	str	w3, [x2, #:lo12:.LANCHOR62]
	.loc 2 2192 0
	adrp	x2, .LANCHOR66
	ldr	w3, [x0, 20]
	str	w3, [x2, #:lo12:.LANCHOR66]
	.loc 2 2194 0
	ldp	w2, w3, [x0, 28]
	.loc 2 2193 0
	str	w2, [x1, #:lo12:.LANCHOR73]
	.loc 2 2194 0
	adrp	x2, .LANCHOR75
	str	w3, [x2, #:lo12:.LANCHOR75]
	.loc 2 2195 0
	adrp	x2, .LANCHOR63
	ldr	w3, [x0, 36]
	str	w3, [x2, #:lo12:.LANCHOR63]
	.loc 2 2196 0
	adrp	x2, .LANCHOR65
	ldr	w3, [x0, 40]
	str	w3, [x2, #:lo12:.LANCHOR65]
	.loc 2 2197 0
	adrp	x2, .LANCHOR76
	ldr	w3, [x0, 44]
	str	w3, [x2, #:lo12:.LANCHOR76]
	.loc 2 2198 0
	ldr	w2, [x0, 48]
	adrp	x0, .LANCHOR77
	str	w2, [x0, #:lo12:.LANCHOR77]
.L1248:
	.loc 2 2201 0
	adrp	x0, .LANCHOR14
	adrp	x2, .LANCHOR72
	ldr	w1, [x1, #:lo12:.LANCHOR73]
	ldrh	w0, [x0, #:lo12:.LANCHOR14]
	ldr	w2, [x2, #:lo12:.LANCHOR72]
	.loc 2 2202 0
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	.loc 2 2201 0
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR5
	.loc 2 2202 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	.loc 2 2201 0
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR74
	str	w0, [x1, #:lo12:.LANCHOR74]
	.loc 2 2202 0
	ret
	.cfi_endproc
.LFE287:
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.FtlVpcTblFlush,"ax",@progbits
	.align	2
	.global	FtlVpcTblFlush
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
.LFB269:
	.loc 2 1053 0
	.cfi_startproc
.LVL1665:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 2 1062 0
	adrp	x1, .LANCHOR79
	.loc 2 1068 0
	mov	w2, 19539
	.loc 2 1053 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 2 1060 0
	adrp	x25, .LANCHOR108
	.loc 2 1053 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 1059 0
	adrp	x22, .LANCHOR106
	.loc 2 1053 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 1059 0
	adrp	x24, .LANCHOR107
	.loc 2 1053 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 1059 0
	add	x28, x22, :lo12:.LANCHOR106
	.loc 2 1060 0
	ldr	x21, [x25, #:lo12:.LANCHOR108]
	.loc 2 1068 0
	movk	w2, 0x4654, lsl 16
	.loc 2 1053 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.loc 2 1062 0
	add	x19, x1, :lo12:.LANCHOR79
	.loc 2 1059 0
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	.loc 2 1090 0
	adrp	x23, .LANCHOR70
	.loc 2 1062 0
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	.loc 2 1106 0
	adrp	x27, .LANCHOR20
	.loc 2 1060 0
	stp	x0, x21, [x28, 8]
.LVL1666:
	.loc 2 1054 0
	mov	w26, 65535
	.loc 2 1062 0
	strh	w1, [x21, 2]
	.loc 2 1063 0
	mov	w1, -3932
	strh	w1, [x21]
	.loc 2 1064 0
	ldr	w1, [x19, 8]
	.loc 2 1065 0
	stp	w1, wzr, [x21, 4]
	.loc 2 1068 0
	adrp	x1, .LANCHOR39
	add	x20, x1, :lo12:.LANCHOR39
	.loc 2 1066 0
	str	wzr, [x21, 12]
	.loc 2 1068 0
	str	w2, [x1, #:lo12:.LANCHOR39]
	.loc 2 1069 0
	mov	w1, 68
	movk	w1, 0x5000, lsl 16
	str	w1, [x20, 4]
	.loc 2 1070 0
	ldrh	w1, [x19, 6]
	.loc 2 1073 0
	adrp	x2, .LANCHOR51
	.loc 2 1070 0
	strh	w1, [x20, 8]
	.loc 2 1071 0
	adrp	x1, .LANCHOR10
	ldrh	w1, [x1, #:lo12:.LANCHOR10]
	strb	w1, [x20, 10]
	.loc 2 1073 0
	add	x1, x2, :lo12:.LANCHOR51
	ldrh	w2, [x2, #:lo12:.LANCHOR51]
	strh	w2, [x20, 14]
	.loc 2 1074 0
	ldrh	w2, [x1, 2]
	ldrb	w3, [x1, 6]
	.loc 2 1075 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 11]
	.loc 2 1074 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 16]
	.loc 2 1077 0
	adrp	x2, .LANCHOR52
	add	x1, x2, :lo12:.LANCHOR52
	ldrh	w2, [x2, #:lo12:.LANCHOR52]
	.loc 2 1078 0
	ldrb	w3, [x1, 6]
	.loc 2 1077 0
	strh	w2, [x20, 18]
	.loc 2 1078 0
	ldrh	w2, [x1, 2]
	.loc 2 1079 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 12]
	.loc 2 1078 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 20]
	.loc 2 1081 0
	adrp	x2, .LANCHOR53
	add	x1, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	.loc 2 1082 0
	ldrb	w3, [x1, 6]
	.loc 2 1081 0
	strh	w2, [x20, 22]
	.loc 2 1082 0
	ldrh	w2, [x1, 2]
	.loc 2 1083 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 13]
	.loc 2 1085 0
	adrp	x1, .LANCHOR72
	.loc 2 1082 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 24]
	.loc 2 1085 0
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	str	w1, [x20, 32]
	.loc 2 1090 0
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	str	w1, [x20, 40]
	.loc 2 1091 0
	adrp	x1, .LANCHOR71
	ldr	w1, [x1, #:lo12:.LANCHOR71]
	str	w1, [x20, 36]
	.loc 2 1096 0
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
.LVL1667:
	.loc 2 1097 0
	ldr	x0, [x28, 8]
	mov	x1, x20
	mov	w2, 48
	.loc 2 1098 0
	adrp	x20, .LANCHOR5
	.loc 2 1097 0
	bl	ftl_memcpy
.LVL1668:
	.loc 2 1098 0
	adrp	x1, .LANCHOR42
	ldrh	w2, [x20, #:lo12:.LANCHOR5]
	ldr	x0, [x28, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
.LVL1669:
	.loc 2 1099 0
	ldrh	w0, [x20, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR1
	ldr	x3, [x28, 8]
	.loc 2 1056 0
	mov	w20, 0
	.loc 2 1099 0
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	w2, w2, 4
	add	x0, x0, 48
	and	x0, x0, -4
	add	x0, x3, x0
	bl	ftl_memcpy
.LVL1670:
	.loc 2 1100 0
	mov	w0, 0
	bl	FtlUpdateVaildLpn
.LVL1671:
	.loc 2 1126 0
	add	x0, x27, :lo12:.LANCHOR20
	str	x0, [x29, 104]
.LVL1672:
.L1251:
	.loc 2 1102 0
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	.loc 2 1105 0
	mov	w3, 1
	.loc 2 1102 0
	str	x0, [x28, 8]
	.loc 2 1105 0
	mov	w2, w3
	.loc 2 1103 0
	ldr	x0, [x25, #:lo12:.LANCHOR108]
	.loc 2 1104 0
	ldrh	w1, [x19, 2]
	.loc 2 1103 0
	str	x0, [x28, 16]
	.loc 2 1104 0
	ldrh	w0, [x19]
	orr	w0, w1, w0, lsl 10
	.loc 2 1105 0
	mov	w1, w3
	.loc 2 1104 0
	str	w0, [x28, 4]
	.loc 2 1105 0
	mov	x0, x28
	bl	FlashProgPages
.LVL1673:
	.loc 2 1106 0
	ldrh	w0, [x27, #:lo12:.LANCHOR20]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1252
	.loc 2 1108 0
	ldrh	w0, [x19]
	.loc 2 1107 0
	ldrh	w26, [x19, 4]
.LVL1674:
	.loc 2 1109 0
	strh	wzr, [x19, 2]
	.loc 2 1108 0
	strh	w0, [x19, 4]
	.loc 2 1110 0
	bl	FtlFreeSysBlkQueueOut
.LVL1675:
	strh	w0, [x19]
	.loc 2 1115 0
	ldr	w1, [x23, #:lo12:.LANCHOR70]
	.loc 2 1119 0
	mov	w3, 1
	.loc 2 1115 0
	str	w1, [x19, 8]
	add	w2, w1, 1
	str	w2, [x23, #:lo12:.LANCHOR70]
	.loc 2 1116 0
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	.loc 2 1118 0
	strh	w0, [x21, 2]
	.loc 2 1119 0
	mov	w2, w3
	.loc 2 1117 0
	str	w1, [x21, 4]
	.loc 2 1119 0
	mov	x0, x28
	mov	w1, w3
	bl	FlashProgPages
.LVL1676:
.L1252:
	.loc 2 1121 0
	ldrh	w0, [x19, 2]
	.loc 2 1122 0
	ldr	w1, [x28]
	.loc 2 1121 0
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	.loc 2 1122 0
	cmn	w1, #1
	bne	.L1253
	.loc 2 1124 0
	cmp	w0, 1
	bne	.L1254
	.loc 2 1124 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR166
	adrp	x0, .LC1
	mov	w2, 1124
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1677:
.L1254:
	.loc 2 1125 0 is_stmt 1
	ldrh	w0, [x19, 2]
	cmp	w0, 1
	bne	.L1255
	.loc 2 1126 0
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1255:
	.loc 2 1127 0
	add	w20, w20, 1
.LVL1678:
	and	w20, w20, 65535
.LVL1679:
	.loc 2 1128 0
	cmp	w20, 3
	bls	.L1251
	.loc 2 1129 0
	add	x22, x22, :lo12:.LANCHOR106
	adrp	x0, .LC104
	mov	w2, w20
	add	x0, x0, :lo12:.LC104
	ldr	w1, [x22, 4]
	bl	printf
.LVL1680:
.L1257:
	b	.L1257
.L1253:
	.loc 2 1135 0
	cmp	w0, 1
	beq	.L1251
	.loc 2 1138 0
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1258
	.loc 2 1139 0
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.LVL1681:
.L1258:
	.loc 2 1141 0
	ldp	x19, x20, [sp, 16]
.LVL1682:
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL1683:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1684:
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE269:
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSysFlush,"ax",@progbits
	.align	2
	.global	FtlSysFlush
	.type	FtlSysFlush, %function
FtlSysFlush:
.LFB212:
	.loc 3 797 0
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 799 0
	bl	l2p_flush
.LVL1685:
	.loc 3 800 0
	mov	w0, 1
	bl	FtlEctTblFlush
.LVL1686:
	.loc 3 801 0
	bl	FtlVpcTblFlush
.LVL1687:
	.loc 3 803 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE212:
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.sftl_deinit,"ax",@progbits
	.align	2
	.global	sftl_deinit
	.type	sftl_deinit, %function
sftl_deinit:
.LFB213:
	.loc 3 806 0
	.cfi_startproc
	.loc 3 807 0
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmp	w0, 1
	bne	.L1268
	.loc 3 806 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 808 0
	bl	FtlSysFlush
.LVL1688:
	.loc 3 810 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.L1268:
	mov	w0, 0
	ret
	.cfi_endproc
.LFE213:
	.size	sftl_deinit, .-sftl_deinit
	.section	.text.FtlDiscard,"ax",@progbits
	.align	2
	.global	FtlDiscard
	.type	FtlDiscard, %function
FtlDiscard:
.LFB218:
	.loc 3 1121 0
	.cfi_startproc
.LVL1689:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 3 1128 0
	add	w2, w0, w1
	.loc 3 1121 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	w19, w1
	.loc 3 1128 0
	adrp	x1, .LANCHOR34
.LVL1690:
	.loc 3 1121 0
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.loc 3 1128 0
	ldr	w1, [x1, #:lo12:.LANCHOR34]
	cmp	w2, w1
	bhi	.L1279
	.loc 3 1131 0
	cmp	w19, 31
	bhi	.L1273
.LVL1691:
.L1287:
	.loc 3 1164 0
	mov	w0, 0
.L1271:
	.loc 3 1165 0
	ldp	x19, x20, [sp, 16]
.LVL1692:
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1693:
.L1273:
	.cfi_restore_state
	.loc 3 1136 0
	adrp	x21, .LANCHOR12
	ldrh	w1, [x21, #:lo12:.LANCHOR12]
	udiv	w20, w0, w1
.LVL1694:
	.loc 3 1137 0
	msub	w0, w1, w20, w0
.LVL1695:
	.loc 3 1138 0
	ands	w0, w0, 65535
	beq	.L1274
.LVL1696:
	.loc 3 1139 0
	sub	w1, w1, w0
.LVL1697:
	.loc 3 1140 0
	add	w20, w20, 1
.LVL1698:
	.loc 3 1139 0
	cmp	w1, w19
	csel	w1, w1, w19, ls
	.loc 3 1141 0
	sub	w19, w19, w1, uxth
.LVL1699:
.L1274:
	.loc 3 1148 0
	adrp	x22, .LANCHOR167
	.loc 3 1149 0
	adrp	x23, .LANCHOR63
	.loc 3 1148 0
	add	x22, x22, :lo12:.LANCHOR167
	.loc 3 1149 0
	add	x23, x23, :lo12:.LANCHOR63
	.loc 3 1144 0
	mov	w0, -1
.LVL1700:
	str	w0, [x29, 76]
.LVL1701:
.L1275:
	.loc 3 1145 0
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	cmp	w19, w0
	bcs	.L1277
	.loc 3 1158 0
	adrp	x0, .LANCHOR167
	ldr	w1, [x0, #:lo12:.LANCHOR167]
	cmp	w1, 32
	bls	.L1287
	.loc 3 1160 0
	str	wzr, [x0, #:lo12:.LANCHOR167]
	.loc 3 1161 0
	bl	l2p_flush
.LVL1702:
	.loc 3 1162 0
	bl	FtlVpcTblFlush
.LVL1703:
	b	.L1287
.L1277:
	.loc 3 1146 0
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w20
	bl	log2phys
.LVL1704:
	.loc 3 1147 0
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1276
	.loc 3 1148 0
	ldr	w0, [x22]
	.loc 3 1150 0
	mov	w2, 1
	add	x1, x29, 76
	.loc 3 1148 0
	add	w0, w0, 1
	str	w0, [x22]
	.loc 3 1149 0
	ldr	w0, [x23]
	add	w0, w0, 1
	str	w0, [x23]
	.loc 3 1150 0
	mov	w0, w20
	bl	log2phys
.LVL1705:
	.loc 3 1151 0
	ldr	w0, [x29, 72]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1706:
	.loc 3 1152 0
	bl	decrement_vpc_count
.LVL1707:
.L1276:
	.loc 3 1155 0
	ldrh	w0, [x21, #:lo12:.LANCHOR12]
	.loc 3 1154 0
	add	w20, w20, 1
.LVL1708:
	.loc 3 1155 0
	sub	w19, w19, w0
.LVL1709:
	b	.L1275
.LVL1710:
.L1279:
	.loc 3 1129 0
	mov	w0, -1
.LVL1711:
	b	.L1271
	.cfi_endproc
.LFE218:
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.FtlVpcCheckAndModify,"ax",@progbits
	.align	2
	.global	FtlVpcCheckAndModify
	.type	FtlVpcCheckAndModify, %function
FtlVpcCheckAndModify:
.LFB289:
	.loc 2 2242 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 2247 0
	adrp	x1, .LANCHOR168
	adrp	x0, .LC94
	add	x1, x1, :lo12:.LANCHOR168
	.loc 2 2242 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.loc 2 2247 0
	add	x0, x0, :lo12:.LC94
	.loc 2 2242 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 2248 0
	adrp	x20, .LANCHOR128
	.loc 2 2242 0
	stp	x23, x24, [sp, 48]
	.loc 2 2249 0
	adrp	x21, .LANCHOR61
	.loc 2 2242 0
	str	x25, [sp, 64]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.loc 2 2247 0
	bl	printf
.LVL1712:
	.loc 2 2248 0
	adrp	x0, .LANCHOR6
	.loc 2 2249 0
	mov	w19, 0
	add	x21, x21, :lo12:.LANCHOR61
	.loc 2 2248 0
	mov	w1, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1713:
.L1289:
	.loc 2 2249 0 discriminator 1
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L1291
	.loc 2 2256 0 discriminator 1
	adrp	x22, .LANCHOR5
	.loc 2 2259 0 discriminator 1
	adrp	x23, .LC105
	.loc 2 2256 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR5
	.loc 2 2259 0 discriminator 1
	add	x23, x23, :lo12:.LC105
	mov	w19, 0
.LVL1714:
	.loc 2 2257 0 discriminator 1
	adrp	x25, .LANCHOR42
	mov	w24, 65535
.L1292:
.LVL1715:
	.loc 2 2256 0 discriminator 1
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L1296
	.loc 2 2268 0
	ldp	x19, x20, [sp, 16]
.LVL1716:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1717:
.L1291:
	.cfi_restore_state
	.loc 2 2250 0
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w19
	bl	log2phys
.LVL1718:
	.loc 2 2251 0
	ldr	w0, [x29, 92]
	cmn	w0, #1
	beq	.L1290
	.loc 2 2252 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1719:
	.loc 2 2253 0
	ldr	x2, [x20, #:lo12:.LANCHOR128]
	ubfiz	x0, x0, 1, 16
.LVL1720:
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
.L1290:
	.loc 2 2249 0 discriminator 2
	add	w19, w19, 1
.LVL1721:
	b	.L1289
.LVL1722:
.L1296:
	.loc 2 2257 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ubfiz	x21, x19, 1, 16
	ldrh	w2, [x0, x21]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w3, [x0, x21]
	cmp	w2, w3
	beq	.L1294
	.loc 2 2257 0 is_stmt 0 discriminator 1
	cmp	w2, w24
	beq	.L1294
	.loc 2 2259 0 is_stmt 1
	mov	w1, w19
	mov	x0, x23
	bl	printf
.LVL1723:
	.loc 2 2260 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L1294
	.loc 2 2260 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L1294
	.loc 2 2260 0 discriminator 2
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L1294
	.loc 2 2261 0 is_stmt 1
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w1, [x0, x21]
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	strh	w1, [x0, x21]
	.loc 2 2262 0
	mov	w0, w19
	bl	update_vpc_list
.LVL1724:
	.loc 2 2263 0
	bl	l2p_flush
.LVL1725:
	.loc 2 2264 0
	bl	FtlVpcTblFlush
.LVL1726:
.L1294:
	.loc 2 2256 0 discriminator 2
	add	w19, w19, 1
.LVL1727:
	and	w19, w19, 65535
.LVL1728:
	b	.L1292
	.cfi_endproc
.LFE289:
	.size	FtlVpcCheckAndModify, .-FtlVpcCheckAndModify
	.section	.text.allocate_new_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_new_data_superblock
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
.LFB299:
	.loc 2 2682 0
	.cfi_startproc
.LVL1729:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 2683 0
	ldrh	w19, [x0]
.LVL1730:
	.loc 2 2682 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2682 0
	mov	x21, x0
	.loc 2 2684 0
	adrp	x0, .LANCHOR5
.LVL1731:
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w19
	bcs	.L1302
	.loc 2 2684 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR169
	adrp	x0, .LC1
	mov	w2, 2684
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1732:
.L1302:
	.loc 2 2686 0 is_stmt 1
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1303
	.loc 2 2687 0
	adrp	x1, .LANCHOR42
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1304
	.loc 2 2688 0
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL1733:
.L1303:
	.loc 2 2693 0
	adrp	x1, .LANCHOR150
	.loc 2 2692 0
	mov	w0, 1
	strb	w0, [x21, 8]
	.loc 2 2693 0
	mov	w2, 65535
	ldrh	w0, [x1, #:lo12:.LANCHOR150]
	mov	x20, x1
	cmp	w0, w2
	beq	.L1305
	.loc 2 2694 0
	cmp	w19, w0
	bne	.L1306
	.loc 2 2694 0 is_stmt 0 discriminator 1
	adrp	x2, .LANCHOR42
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1307
.L1306:
	.loc 2 2695 0 is_stmt 1
	bl	update_vpc_list
.LVL1734:
.L1307:
	.loc 2 2696 0
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR150]
.L1305:
	.loc 2 2698 0
	mov	x0, x21
	bl	allocate_data_superblock
.LVL1735:
	.loc 2 2699 0
	bl	l2p_flush
.LVL1736:
	.loc 2 2700 0
	mov	w0, 0
	bl	FtlEctTblFlush
.LVL1737:
	.loc 2 2701 0
	bl	FtlVpcTblFlush
.LVL1738:
	.loc 2 2703 0
	ldr	x21, [sp, 32]
.LVL1739:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL1740:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1741:
.L1304:
	.cfi_restore_state
	.loc 2 2690 0
	mov	w0, w19
	bl	INSERT_FREE_LIST
.LVL1742:
	b	.L1303
	.cfi_endproc
.LFE299:
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlProgPages,"ax",@progbits
	.align	2
	.global	FtlProgPages
	.type	FtlProgPages, %function
FtlProgPages:
.LFB215:
	.loc 3 904 0
	.cfi_startproc
.LVL1743:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 3 911 0
	mov	w2, 0
.LVL1744:
	.loc 3 904 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x19, x3
	stp	x23, x24, [sp, 48]
	add	x20, x0, 4
	stp	x21, x22, [sp, 32]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	w21, w1
	str	x25, [sp, 64]
	.cfi_offset 25, -32
	ubfiz	x21, x21, 5, 32
	add	x21, x21, 4
	.loc 3 918 0
	adrp	x24, .LANCHOR19
	.loc 3 911 0
	ldrb	w3, [x3, 9]
.LVL1745:
	.loc 3 926 0
	adrp	x23, .LANCHOR81
	add	x21, x0, x21
	.loc 3 918 0
	add	x24, x24, :lo12:.LANCHOR19
	.loc 3 926 0
	add	x23, x23, :lo12:.LANCHOR81
	.loc 3 911 0
	bl	FlashProgPages
.LVL1746:
.L1313:
	.loc 3 913 0 discriminator 1
	cmp	x20, x21
	beq	.L1320
	sub	x22, x20, #4
	.loc 3 917 0
	adrp	x25, .LANCHOR42
	b	.L1321
.L1316:
	.loc 3 915 0
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1747:
	.loc 3 916 0
	ldrh	w1, [x19]
	cmp	w1, w0, uxth
	bne	.L1314
	.loc 3 917 0
	ldr	x2, [x25, #:lo12:.LANCHOR42]
	ubfiz	x1, x1, 1, 16
	ldrh	w3, [x19, 4]
	ldrh	w0, [x2, x1]
.LVL1748:
	sub	w0, w0, w3
	strh	w0, [x2, x1]
	.loc 3 919 0
	strb	wzr, [x19, 6]
	.loc 3 918 0
	ldrh	w0, [x24]
	strh	w0, [x19, 2]
	.loc 3 920 0
	strh	wzr, [x19, 4]
.L1314:
	.loc 3 922 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1315
	.loc 3 923 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL1749:
.L1315:
	.loc 3 926 0
	ldr	w0, [x23, 96]
	add	w0, w0, 1
	str	w0, [x23, 96]
	.loc 3 927 0
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	FtlGcMarkBadPhyBlk
.LVL1750:
	.loc 3 928 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL1751:
	.loc 3 929 0
	str	w0, [x20]
	.loc 3 930 0
	mov	w2, 0
	.loc 3 928 0
	str	w0, [x29, 92]
	.loc 3 930 0
	mov	w1, 1
	ldrb	w3, [x19, 9]
	mov	x0, x22
	bl	FlashProgPages
.LVL1752:
.L1321:
	.loc 3 914 0
	ldr	w0, [x20, -4]
	cmn	w0, #1
	beq	.L1316
	.loc 3 933 0
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1317
	.loc 3 933 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 933
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1753:
.L1317:
	.loc 3 934 0 is_stmt 1
	add	x1, x29, 96
	ldr	w0, [x22, 4]
	.loc 3 935 0
	mov	w2, 1
	.loc 3 934 0
	str	w0, [x1, -4]!
	.loc 3 935 0
	ldr	w0, [x22, 24]
	bl	log2phys
.LVL1754:
	.loc 3 937 0
	ldr	x0, [x22, 16]
	ldr	w3, [x0, 12]
.LVL1755:
	.loc 3 939 0
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1756:
	and	w1, w0, 65535
	mov	w22, w1
.LVL1757:
	.loc 3 940 0
	cmn	w3, #1
	beq	.L1318
	.loc 3 942 0
	adrp	x2, .LANCHOR42
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1319
	.loc 3 943 0
	adrp	x0, .LC106
	mov	w2, 0
	add	x0, x0, :lo12:.LC106
	bl	printf
.LVL1758:
.L1319:
	.loc 3 944 0
	mov	w0, w22
	bl	decrement_vpc_count
.LVL1759:
.L1318:
	add	x20, x20, 32
	b	.L1313
.LVL1760:
.L1320:
	.loc 3 948 0
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1312
	.loc 3 948 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 948
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1761:
.L1312:
	.loc 3 949 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
.LVL1762:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE215:
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
.LFB308:
	.loc 5 112 0
	.cfi_startproc
.LVL1763:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 5 119 0
	mov	w2, 65535
	.loc 5 112 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.loc 5 119 0
	adrp	x19, .LANCHOR53
	.loc 5 112 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 5 115 0
	adrp	x21, .LANCHOR19
	.loc 5 119 0
	ldrh	w20, [x19, #:lo12:.LANCHOR53]
	.loc 5 112 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.loc 5 119 0
	cmp	w20, w2
	.loc 5 112 0
	str	x27, [sp, 80]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.loc 5 115 0
	ldrh	w1, [x21, #:lo12:.LANCHOR19]
.LVL1764:
	.loc 5 119 0
	bne	.L1328
.LVL1765:
.L1338:
	.loc 5 152 0
	adrp	x0, .LANCHOR152
	.loc 5 153 0
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65535
	.loc 5 152 0
	str	wzr, [x0, #:lo12:.LANCHOR152]
	.loc 5 153 0
	cmp	w2, w1
	add	x0, x19, :lo12:.LANCHOR53
	bne	.L1351
.L1354:
	.loc 5 198 0
	mov	w0, 0
.L1327:
	.loc 5 199 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1766:
.L1328:
	.cfi_restore_state
	.loc 5 121 0
	cbz	w0, .L1331
.LVL1767:
	.loc 5 123 0
	adrp	x0, .LANCHOR156
.LVL1768:
	ldrh	w3, [x0, #:lo12:.LANCHOR156]
	cmp	w3, w2
	beq	.L1332
.L1333:
	.loc 5 122 0
	mov	w1, 2
.LVL1769:
.L1331:
	.loc 5 131 0
	add	x0, x19, :lo12:.LANCHOR53
	bl	FtlGcScanTempBlk
.LVL1770:
	str	w0, [x29, 108]
	.loc 5 132 0
	cmn	w0, #1
	beq	.L1334
	.loc 5 135 0
	adrp	x0, .LANCHOR43
	ubfiz	x20, x20, 1, 16
.LVL1771:
	ldr	x1, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L1335
	.loc 5 136 0
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	.loc 5 137 0
	mov	w0, 1
	bl	FtlEctTblFlush
.LVL1772:
.L1335:
	.loc 5 139 0
	adrp	x0, .LANCHOR152
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	cbnz	w1, .L1336
	.loc 5 140 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	.loc 5 141 0
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1773:
	.loc 5 142 0
	bl	FtlBbmTblFlush
.LVL1774:
.L1336:
	.loc 5 144 0
	str	wzr, [x19, #:lo12:.LANCHOR152]
.L1347:
	.loc 5 149 0
	mov	w0, 1
	b	.L1327
.LVL1775:
.L1332:
	.loc 5 124 0
	strh	wzr, [x0, #:lo12:.LANCHOR156]
	.loc 5 125 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 17
	bhi	.L1333
	b	.L1331
.LVL1776:
.L1334:
	.loc 5 148 0
	adrp	x0, .LANCHOR156
	ldrh	w1, [x0, #:lo12:.LANCHOR156]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1347
	b	.L1338
.LVL1777:
.L1351:
	.loc 5 162 0
	ldrb	w0, [x0, 7]
	adrp	x20, .LANCHOR97
	ldrh	w2, [x21, #:lo12:.LANCHOR19]
	ldrh	w1, [x20, #:lo12:.LANCHOR97]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1339
	.loc 5 162 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR171
	adrp	x0, .LC1
	mov	w2, 162
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1778:
.L1339:
	.loc 5 163 0 is_stmt 1
	add	x0, x19, :lo12:.LANCHOR53
	adrp	x23, .LANCHOR42
	ldrh	w3, [x21, #:lo12:.LANCHOR19]
	.loc 5 168 0
	adrp	x25, .LANCHOR61
	.loc 5 163 0
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	.loc 5 168 0
	adrp	x26, .LANCHOR171
	.loc 5 163 0
	ldrb	w0, [x0, 7]
	.loc 5 168 0
	add	x25, x25, :lo12:.LANCHOR61
	.loc 5 163 0
	ldr	x1, [x23, #:lo12:.LANCHOR42]
	.loc 5 168 0
	add	x26, x26, :lo12:.LANCHOR171
	.loc 5 165 0
	mov	w21, 0
	.loc 5 163 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	.loc 5 164 0
	adrp	x1, .LANCHOR67
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	ldr	w2, [x1, #:lo12:.LANCHOR67]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR67]
.LVL1779:
.L1340:
	.loc 5 165 0 discriminator 1
	ldrh	w0, [x20, #:lo12:.LANCHOR97]
	cmp	w0, w21
	bhi	.L1344
	.loc 5 181 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1780:
	.loc 5 182 0
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L1345
	.loc 5 183 0
	bl	INSERT_DATA_LIST
.LVL1781:
.L1346:
	.loc 5 188 0
	adrp	x0, .LANCHOR95
	.loc 5 186 0
	mov	w21, -1
.LVL1782:
	.loc 5 187 0
	strh	wzr, [x20, #:lo12:.LANCHOR97]
	.loc 5 186 0
	strh	w21, [x19, #:lo12:.LANCHOR53]
	.loc 5 188 0
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	.loc 5 189 0
	bl	l2p_flush
.LVL1783:
	.loc 5 190 0
	bl	FtlVpcTblFlush
.LVL1784:
	.loc 5 191 0
	adrp	x0, .LANCHOR48
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L1354
	.loc 5 192 0
	adrp	x0, .LANCHOR80
	.loc 5 193 0
	mov	w1, 20
	.loc 5 192 0
	strh	w21, [x0, #:lo12:.LANCHOR80]
	.loc 5 193 0
	adrp	x0, .LANCHOR82
	strh	w1, [x0, #:lo12:.LANCHOR82]
	b	.L1354
.LVL1785:
.L1344:
	.loc 5 166 0
	adrp	x0, .LANCHOR98
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR98]
	umull	x24, w21, w24
	.loc 5 168 0
	ldr	w0, [x25]
	.loc 5 166 0
	add	x22, x27, x24
.LVL1786:
	.loc 5 168 0
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L1341
	.loc 5 168 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 168
	mov	x1, x26
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1787:
.L1341:
	.loc 5 169 0 is_stmt 1
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
.LVL1788:
	.loc 5 170 0
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L1342
	.loc 5 171 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1789:
	mov	w24, w0
.LVL1790:
	.loc 5 172 0
	ldr	w0, [x22, 8]
.LVL1791:
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
.LVL1792:
	.loc 5 173 0
	mov	w0, w24
.LVL1793:
.L1353:
	.loc 5 177 0
	bl	decrement_vpc_count
.LVL1794:
.L1343:
	.loc 5 165 0 discriminator 2
	add	w21, w21, 1
.LVL1795:
	and	w21, w21, 65535
.LVL1796:
	b	.L1340
.L1342:
	.loc 5 175 0
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L1343
	.loc 5 177 0
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	b	.L1353
.LVL1797:
.L1345:
	.loc 5 185 0
	bl	INSERT_FREE_LIST
.LVL1798:
	b	.L1346
	.cfi_endproc
.LFE308:
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.FtlGcPageRecovery,"ax",@progbits
	.align	2
	.global	FtlGcPageRecovery
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
.LFB311:
	.loc 5 289 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 5 290 0
	adrp	x20, .LANCHOR19
	adrp	x19, .LANCHOR53
	add	x19, x19, :lo12:.LANCHOR53
	ldrh	w1, [x20, #:lo12:.LANCHOR19]
	mov	x0, x19
	bl	FtlGcScanTempBlk
.LVL1799:
	.loc 5 291 0
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bcc	.L1355
.LBB321:
.LBB322:
	.loc 5 293 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL1800:
	.loc 5 294 0
	mov	w0, 0
	bl	FtlGcFreeTempBlock
.LVL1801:
	.loc 5 295 0
	adrp	x0, .LANCHOR152
	str	wzr, [x0, #:lo12:.LANCHOR152]
.L1355:
.LBE322:
.LBE321:
	.loc 5 297 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE311:
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
	.section	.text.FtlPowerLostRecovery,"ax",@progbits
	.align	2
	.global	FtlPowerLostRecovery
	.type	FtlPowerLostRecovery, %function
FtlPowerLostRecovery:
.LFB283:
	.loc 2 2081 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2082 0
	adrp	x0, .LANCHOR162
	.loc 2 2081 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2084 0
	adrp	x19, .LANCHOR51
	add	x19, x19, :lo12:.LANCHOR51
	.loc 2 2082 0
	str	wzr, [x0, #:lo12:.LANCHOR162]
	.loc 2 2084 0
	mov	x0, x19
	bl	FtlRecoverySuperblock
.LVL1802:
	.loc 2 2085 0
	mov	x0, x19
	.loc 2 2086 0
	adrp	x19, .LANCHOR52
	.loc 2 2085 0
	bl	FtlSlcSuperblockCheck
.LVL1803:
	.loc 2 2086 0
	add	x19, x19, :lo12:.LANCHOR52
	mov	x0, x19
	bl	FtlRecoverySuperblock
.LVL1804:
	.loc 2 2087 0
	mov	x0, x19
	bl	FtlSlcSuperblockCheck
.LVL1805:
	.loc 2 2088 0
	bl	FtlGcPageRecovery
.LVL1806:
	.loc 2 2089 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1807:
	.loc 2 2091 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE283:
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
	.section	.text.Ftl_gc_temp_data_write_back,"ax",@progbits
	.align	2
	.global	Ftl_gc_temp_data_write_back
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
.LFB313:
	.loc 5 316 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 5 320 0
	mov	w3, 0
	mov	w2, 0
	.loc 5 316 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 5 320 0
	adrp	x19, .LANCHOR89
	adrp	x20, .LANCHOR121
	ldr	w1, [x19, #:lo12:.LANCHOR89]
	.loc 5 321 0
	add	x19, x19, :lo12:.LANCHOR89
	.loc 5 320 0
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FlashProgPages
.LVL1808:
	.loc 5 321 0
	mov	w11, 0
.LVL1809:
.L1361:
	.loc 5 321 0 is_stmt 0 discriminator 1
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L1364
	.loc 5 335 0 is_stmt 1
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FtlGcBufFree
.LVL1810:
	.loc 5 336 0
	str	wzr, [x19]
	.loc 5 337 0
	adrp	x0, .LANCHOR53+4
	ldrh	w0, [x0, #:lo12:.LANCHOR53+4]
	cbnz	w0, .L1365
	.loc 5 338 0
	mov	w0, 1
	bl	FtlGcFreeTempBlock
.LVL1811:
	b	.L1367
.LVL1812:
.L1364:
	.loc 5 322 0
	ldr	x2, [x20, #:lo12:.LANCHOR121]
	ubfiz	x0, x11, 5, 16
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1362
	.loc 5 323 0
	adrp	x0, .LANCHOR53
	adrp	x3, .LANCHOR42
	ldrh	w4, [x0, #:lo12:.LANCHOR53]
	ldr	x3, [x3, #:lo12:.LANCHOR42]
	strh	wzr, [x3, x4, lsl 1]
	.loc 5 324 0
	strh	w2, [x0, #:lo12:.LANCHOR53]
	.loc 5 325 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	.loc 5 326 0
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1813:
	.loc 5 327 0
	bl	FtlBbmTblFlush
.LVL1814:
	.loc 5 328 0
	bl	FtlGcPageVarInit
.LVL1815:
.L1367:
	.loc 5 339 0
	mov	w0, 1
.L1360:
	.loc 5 342 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1816:
.L1362:
	.cfi_restore_state
	.loc 5 331 0 discriminator 2
	ldr	x0, [x1, 16]
.LVL1817:
	.loc 5 332 0 discriminator 2
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
.LVL1818:
	bl	FtlGcUpdatePage
.LVL1819:
	.loc 5 321 0 discriminator 2
	add	w11, w11, 1
.LVL1820:
	and	w11, w11, 65535
.LVL1821:
	b	.L1361
.LVL1822:
.L1365:
	.loc 5 341 0
	mov	w0, 0
	b	.L1360
	.cfi_endproc
.LFE313:
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.Ftl_get_new_temp_ppa,"ax",@progbits
	.align	2
	.global	Ftl_get_new_temp_ppa
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
.LFB312:
	.loc 5 300 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 5 301 0
	adrp	x0, .LANCHOR53
	mov	w2, 65535
	.loc 5 300 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	.loc 5 301 0
	ldrh	w3, [x0, #:lo12:.LANCHOR53]
	cmp	w3, w2
	beq	.L1369
	add	x1, x0, :lo12:.LANCHOR53
	.loc 5 301 0 is_stmt 0 discriminator 1
	ldrh	w0, [x1, 4]
	cbnz	w0, .L1370
.L1369:
	.loc 5 303 0 is_stmt 1
	mov	w0, 0
	bl	FtlGcFreeTempBlock
.LVL1823:
	.loc 5 304 0
	add	x0, x19, :lo12:.LANCHOR53
	strb	wzr, [x0, 8]
	.loc 5 305 0
	bl	allocate_data_superblock
.LVL1824:
	.loc 5 306 0
	adrp	x0, .LANCHOR95
	strh	wzr, [x0, #:lo12:.LANCHOR95]
	.loc 5 307 0
	adrp	x0, .LANCHOR97
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	.loc 5 308 0
	bl	l2p_flush
.LVL1825:
	.loc 5 309 0
	mov	w0, 0
	bl	FtlEctTblFlush
.LVL1826:
	.loc 5 310 0
	bl	FtlVpcTblFlush
.LVL1827:
.L1370:
	.loc 5 312 0
	add	x0, x19, :lo12:.LANCHOR53
	.loc 5 313 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	.loc 5 312 0
	b	get_new_active_ppa
.LVL1828:
	.cfi_endproc
.LFE312:
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
.LFB319:
	.loc 5 470 0
	.cfi_startproc
.LVL1829:
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	.loc 5 478 0
	adrp	x22, .LANCHOR117
	.loc 5 470 0
	stp	x19, x20, [sp, 16]
	.loc 5 478 0
	ldr	w1, [x22, #:lo12:.LANCHOR117]
.LVL1830:
	.loc 5 470 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	.loc 5 478 0
	cbnz	w1, .L1444
	.loc 5 481 0
	adrp	x1, .LANCHOR45
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	cmp	w1, 47
	bls	.L1444
	mov	w24, w0
	.loc 5 485 0
	adrp	x0, .LANCHOR156
.LVL1831:
	ldrh	w1, [x0, #:lo12:.LANCHOR156]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1374
.L1377:
.LVL1832:
.LBB326:
.LBB327:
	.loc 5 489 0
	adrp	x0, .LANCHOR100
	mov	w3, 65535
	ldrh	w2, [x0, #:lo12:.LANCHOR100]
	cmp	w2, w3
	bne	.L1375
.L1376:
	.loc 5 496 0
	adrp	x2, .LANCHOR84
	.loc 5 497 0
	adrp	x19, .LANCHOR80
	mov	w20, 65535
	.loc 5 496 0
	ldr	w1, [x2, #:lo12:.LANCHOR84]
	.loc 5 497 0
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	.loc 5 496 0
	add	w1, w1, 1
	add	w1, w1, w24, lsl 7
	str	w1, [x2, #:lo12:.LANCHOR84]
	.loc 5 497 0
	cmp	w0, w20
	bne	.L1378
	adrp	x3, .LANCHOR53
	ldrh	w20, [x3, #:lo12:.LANCHOR53]
	cmp	w20, w0
	bne	.L1447
	adrp	x0, .LANCHOR99
	ldrh	w21, [x0, #:lo12:.LANCHOR99]
	cmp	w21, w20
	bne	.L1378
	.loc 5 498 0
	adrp	x23, .LANCHOR48
	mov	w3, 1024
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cmp	w0, 24
	mov	w0, 5120
	csel	w0, w0, w3, cc
	cmp	w1, w0
	bls	.L1450
.LBB328:
	.loc 5 502 0
	adrp	x0, .LANCHOR172
	.loc 5 501 0
	str	wzr, [x2, #:lo12:.LANCHOR84]
	.loc 5 502 0
	strh	wzr, [x0, #:lo12:.LANCHOR172]
	.loc 5 503 0
	bl	GetSwlReplaceBlock
.LVL1833:
	and	w20, w0, 65535
.LVL1834:
	.loc 5 504 0
	cmp	w20, w21
	bne	.L1451
	.loc 5 505 0
	adrp	x5, .LANCHOR83
	ldrh	w1, [x23, #:lo12:.LANCHOR48]
	ldrh	w0, [x5, #:lo12:.LANCHOR83]
.LVL1835:
	cmp	w1, w0
	bcs	.L1381
	.loc 5 506 0
	mov	w0, 64
	bl	List_get_gc_head_node
.LVL1836:
	and	w0, w0, 65535
.LVL1837:
	.loc 5 507 0
	cmp	w0, w20
	beq	.L1383
	.loc 5 508 0
	adrp	x1, .LANCHOR42
	ubfiz	x0, x0, 1, 16
.LVL1838:
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w0, [x1, x0]
	cmp	w0, 7
	bhi	.L1384
	.loc 5 509 0
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL1839:
	and	w21, w0, 65535
.LVL1840:
	.loc 5 510 0
	mov	w0, 128
	strh	w0, [x5, #:lo12:.LANCHOR83]
	.loc 5 520 0
	cmp	w21, w20
	bne	.L1380
.LVL1841:
.L1383:
	.loc 5 523 0
	bl	FtlGcReFreshBadBlk
.LVL1842:
.L1378:
.LBE328:
	.loc 5 527 0
	cmp	w24, 0
	mov	w0, 65535
	ccmp	w20, w0, 0, eq
	bne	.L1386
	.loc 5 528 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 24
	bhi	.L1452
	adrp	x1, .LANCHOR19
	.loc 5 530 0
	cmp	w0, 16
	.loc 5 531 0
	ldrh	w21, [x1, #:lo12:.LANCHOR19]
	.loc 5 530 0
	bls	.L1388
	.loc 5 531 0
	lsr	w21, w21, 5
.LVL1843:
.L1387:
	.loc 5 539 0
	adrp	x2, .LANCHOR82
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR82]
	cmp	w1, w0
	bcs	.L1391
	.loc 5 540 0
	adrp	x0, .LANCHOR53
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bne	.L1392
	adrp	x1, .LANCHOR99
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	cmp	w1, w0
	bne	.L1392
	.loc 5 542 0
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	cbnz	w0, .L1393
	adrp	x1, .LANCHOR61
	adrp	x4, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	ldr	w4, [x4, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L1394
.L1393:
	.loc 5 543 0
	adrp	x1, .LANCHOR78
	ldrh	w1, [x1, #:lo12:.LANCHOR78]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR82]
.L1395:
	.loc 5 546 0
	adrp	x1, .LANCHOR87
	str	wzr, [x1, #:lo12:.LANCHOR87]
.LVL1844:
.L1372:
.LBE327:
.LBE326:
	.loc 5 754 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1845:
.L1374:
	.cfi_restore_state
	.loc 5 485 0 discriminator 1
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	beq	.L1377
	.loc 5 486 0
	mov	w0, 1
	bl	FtlGcFreeTempBlock
.LVL1846:
	cbz	w0, .L1377
	.loc 5 487 0
	mov	w0, 1
	b	.L1372
.LVL1847:
.L1375:
.LBB331:
.LBB330:
	.loc 5 489 0
	adrp	x1, .LANCHOR99
	ldrh	w4, [x1, #:lo12:.LANCHOR99]
	cmp	w4, w3
	bne	.L1376
	.loc 5 490 0
	strh	w2, [x1, #:lo12:.LANCHOR99]
	.loc 5 491 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR100]
	b	.L1376
.LVL1848:
.L1384:
.LBB329:
	.loc 5 512 0
	mov	w0, 64
.L1476:
	.loc 5 516 0
	strh	w0, [x5, #:lo12:.LANCHOR83]
	b	.L1383
.L1381:
	mov	w0, 80
	b	.L1476
.LVL1849:
.L1451:
	.loc 5 504 0
	mov	w21, w20
.LVL1850:
.L1380:
	.loc 5 521 0
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
.LVL1851:
	b	.L1383
.LVL1852:
.L1447:
.LBE329:
	.loc 5 473 0
	mov	w20, w0
	b	.L1378
.L1450:
	mov	w20, w21
	b	.L1378
.LVL1853:
.L1388:
	.loc 5 532 0
	cmp	w0, 12
	bls	.L1389
	.loc 5 533 0
	lsr	w21, w21, 4
.LVL1854:
	b	.L1387
.LVL1855:
.L1389:
	.loc 5 534 0
	cmp	w0, 8
	bls	.L1387
	.loc 5 535 0
	lsr	w21, w21, 2
.LVL1856:
	b	.L1387
.LVL1857:
.L1452:
	.loc 5 529 0
	mov	w21, 1
	b	.L1387
.LVL1858:
.L1394:
	.loc 5 545 0
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR82]
	b	.L1395
.L1392:
	.loc 5 549 0
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR82]
.L1391:
	.loc 5 551 0
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L1453
	.loc 5 552 0
	add	w21, w21, 32
.LVL1859:
	and	w21, w21, 65535
.LVL1860:
.L1453:
	.loc 5 551 0
	mov	w20, 65535
.LVL1861:
.L1397:
	.loc 5 595 0
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1406
	.loc 5 596 0
	cmp	w20, w0
	beq	.L1407
	.loc 5 597 0
	strh	w20, [x19, #:lo12:.LANCHOR80]
.LVL1862:
.L1408:
	.loc 5 606 0
	add	x0, x19, :lo12:.LANCHOR80
	.loc 5 607 0
	mov	w1, 65535
	.loc 5 606 0
	strb	wzr, [x0, 8]
	.loc 5 607 0
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w1
	beq	.L1406
	.loc 5 608 0
	bl	IsBlkInGcList
.LVL1863:
	cbz	w0, .L1411
	.loc 5 609 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1411:
	.loc 5 611 0
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	add	x23, x19, :lo12:.LANCHOR80
	cmp	w1, w0
	beq	.L1406
	.loc 5 612 0
	mov	x0, x23
	bl	make_superblock
.LVL1864:
	.loc 5 615 0
	adrp	x0, .LANCHOR173
	.loc 5 616 0
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	.loc 5 613 0
	strh	wzr, [x23, 2]
	.loc 5 615 0
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	.loc 5 616 0
	adrp	x0, .LANCHOR42
	.loc 5 614 0
	strb	wzr, [x23, 6]
	.loc 5 616 0
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	strh	w1, [x0, #:lo12:.LANCHOR174]
.L1406:
	.loc 5 621 0
	adrp	x0, .LANCHOR51
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR51]
	cmp	w2, w1
	beq	.L1412
	adrp	x0, .LANCHOR52
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w2, w1
	beq	.L1412
	.loc 5 631 0
	adrp	x24, .LANCHOR85
.LVL1865:
	.loc 5 653 0
	add	x0, x24, :lo12:.LANCHOR85
	str	x0, [x29, 160]
.L1413:
	.loc 5 627 0
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1414
	.loc 5 628 0
	adrp	x0, .LANCHOR87
	.loc 5 641 0
	adrp	x25, .LANCHOR19
	add	x25, x25, :lo12:.LANCHOR19
	.loc 5 628 0
	str	wzr, [x0, #:lo12:.LANCHOR87]
.L1415:
	.loc 5 631 0
	ldrh	w5, [x24, #:lo12:.LANCHOR85]
	add	x7, x24, :lo12:.LANCHOR85
	mov	w0, w5
	bl	List_get_gc_head_node
.LVL1866:
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR80]
	.loc 5 632 0
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1416
	.loc 5 633 0
	strh	wzr, [x7]
	.loc 5 634 0
	mov	w0, 8
	b	.L1372
.LVL1867:
.L1386:
	.loc 5 557 0
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1456
	adrp	x0, .LANCHOR99
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	cmp	w0, w1
	bne	.L1456
	cmp	w20, w0
	bne	.L1456
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	cmp	w0, w20
	beq	.L1398
.LVL1868:
.L1456:
	.loc 5 556 0
	mov	w21, 1
	b	.L1397
.LVL1869:
.L1398:
	.loc 5 558 0
	adrp	x0, .LANCHOR87
	.loc 5 560 0
	adrp	x21, .LANCHOR48
	adrp	x23, .LANCHOR172
	.loc 5 558 0
	str	wzr, [x0, #:lo12:.LANCHOR87]
	.loc 5 560 0
	adrp	x0, .LANCHOR82
	ldrh	w6, [x21, #:lo12:.LANCHOR48]
	mov	x2, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR82]
	cmp	w1, w6
	.loc 5 561 0
	ldrh	w1, [x23, #:lo12:.LANCHOR172]
	.loc 5 560 0
	bcs	.L1399
	.loc 5 561 0
	cbnz	w1, .L1400
	adrp	x1, .LANCHOR61
	adrp	x3, .LANCHOR59
	ldr	w1, [x1, #:lo12:.LANCHOR61]
	ldr	w3, [x3, #:lo12:.LANCHOR59]
	add	w1, w1, w1, lsl 1
	cmp	w3, w1, lsr 2
	bcs	.L1401
.L1400:
	.loc 5 562 0
	adrp	x0, .LANCHOR78
	ldrh	w0, [x0, #:lo12:.LANCHOR78]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR82]
.LVL1870:
.L1477:
	.loc 5 578 0
	bl	FtlReadRefresh
.LVL1871:
	.loc 5 579 0
	ldrh	w0, [x23, #:lo12:.LANCHOR172]
	b	.L1372
.LVL1872:
.L1401:
	.loc 5 564 0
	mov	w1, 18
	strh	w1, [x0, #:lo12:.LANCHOR82]
	b	.L1477
.L1399:
	.loc 5 572 0
	cbnz	w1, .L1456
	.loc 5 573 0
	adrp	x1, .LANCHOR78
	ldrh	w5, [x1, #:lo12:.LANCHOR78]
	add	w1, w5, w5, lsl 1
	asr	w1, w1, 2
	strh	w1, [x0, #:lo12:.LANCHOR82]
	.loc 5 574 0
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL1873:
	.loc 5 575 0
	ubfiz	x0, x0, 1, 16
.LVL1874:
	adrp	x1, .LANCHOR42
	adrp	x2, .LANCHOR3
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	ldrh	w2, [x2, #:lo12:.LANCHOR3]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR20
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	mul	w0, w0, w2
	cmp	w1, w0, asr 1
	ble	.L1404
	.loc 5 576 0
	sub	w5, w5, #1
	.loc 5 575 0
	cmp	w6, w5
	bge	.L1477
.L1404:
	.loc 5 584 0
	cbnz	w1, .L1456
	.loc 5 585 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1875:
	.loc 5 586 0
	ldrh	w0, [x21, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	b	.L1372
.LVL1876:
.L1407:
	.loc 5 598 0
	adrp	x0, .LANCHOR99
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	cmp	w1, w20
	beq	.L1408
	.loc 5 600 0
	adrp	x2, .LANCHOR42
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR42]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L1409
	.loc 5 601 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
.L1409:
	.loc 5 602 0
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	strh	w1, [x19, #:lo12:.LANCHOR80]
	.loc 5 603 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR99]
	b	.L1408
.LVL1877:
.L1412:
	.loc 5 622 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.LVL1878:
.L1478:
	.loc 5 730 0
	adrp	x0, .LANCHOR172
	ldrh	w0, [x0, #:lo12:.LANCHOR172]
	b	.L1372
.LVL1879:
.L1416:
	.loc 5 636 0
	mov	w0, w6
	bl	IsBlkInGcList
.LVL1880:
	add	w5, w5, 1
	cbz	w0, .L1417
	.loc 5 637 0
	strh	w5, [x24, #:lo12:.LANCHOR85]
	b	.L1415
.L1417:
	.loc 5 641 0
	adrp	x23, .LANCHOR42
	adrp	x4, .LANCHOR3
	ldrh	w0, [x25]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR42]
	.loc 5 640 0
	and	w5, w5, 65535
	.loc 5 641 0
	ldrh	w4, [x4, #:lo12:.LANCHOR3]
	.loc 5 640 0
	strh	w5, [x24, #:lo12:.LANCHOR85]
	.loc 5 641 0
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L1419
	.loc 5 642 0
	cmp	w5, 48
	bls	.L1420
	cmp	w3, 8
	bls	.L1420
	adrp	x3, .LANCHOR95
	ldrh	w3, [x3, #:lo12:.LANCHOR95]
	cmp	w3, 35
	bhi	.L1420
.L1419:
	.loc 5 643 0
	ldr	x3, [x29, 160]
	strh	wzr, [x3]
.L1420:
	.loc 5 645 0
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L1421
	mov	w0, 65535
	cmp	w20, w0
	bne	.L1421
	.loc 5 646 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
	.loc 5 647 0
	adrp	x0, .LANCHOR85
	strh	wzr, [x0, #:lo12:.LANCHOR85]
	b	.L1478
.L1421:
	.loc 5 651 0
	cbnz	w1, .L1422
	.loc 5 652 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1881:
	.loc 5 653 0
	ldr	x0, [x29, 160]
	ldr	x1, [x29, 160]
	ldrh	w0, [x0]
	add	w0, w0, 1
	strh	w0, [x1]
	b	.L1415
.L1422:
	.loc 5 656 0
	add	x0, x19, :lo12:.LANCHOR80
	strb	wzr, [x0, 8]
	.loc 5 658 0
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w6
	bne	.L1423
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 658
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1882:
.L1423:
	.loc 5 659 0
	ldr	x0, [x29, 128]
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1424
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 659
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1883:
.L1424:
	.loc 5 660 0
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1425
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	mov	w2, 660
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1884:
.L1425:
	.loc 5 661 0
	add	x25, x19, :lo12:.LANCHOR80
	mov	x0, x25
	bl	make_superblock
.LVL1885:
	.loc 5 662 0
	adrp	x0, .LANCHOR173
	.loc 5 663 0
	ldrh	w1, [x19, #:lo12:.LANCHOR80]
	.loc 5 662 0
	strh	wzr, [x0, #:lo12:.LANCHOR173]
	.loc 5 663 0
	ldr	x0, [x23, #:lo12:.LANCHOR42]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR174
	.loc 5 664 0
	strh	wzr, [x25, 2]
	.loc 5 663 0
	strh	w1, [x0, #:lo12:.LANCHOR174]
	.loc 5 665 0
	strb	wzr, [x25, 6]
.L1414:
	.loc 5 671 0
	bl	FtlReadRefresh
.LVL1886:
	.loc 5 675 0
	adrp	x1, .LANCHOR19
	.loc 5 674 0
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR117]
	.loc 5 675 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	str	w0, [x29, 172]
.LVL1887:
	.loc 5 676 0
	add	x0, x19, :lo12:.LANCHOR80
	str	x1, [x29, 120]
	ldr	w3, [x29, 172]
	ldrh	w0, [x0, 2]
	add	w2, w0, w21
	cmp	w2, w3
	ble	.L1426
	.loc 5 677 0
	sub	w21, w3, w0
.LVL1888:
	and	w21, w21, 65535
.LVL1889:
.L1426:
	.loc 5 700 0
	adrp	x0, .LANCHOR173
	.loc 5 689 0
	mov	w27, 0
	.loc 5 700 0
	add	x0, x0, :lo12:.LANCHOR173
	str	x0, [x29, 152]
.LVL1890:
.L1427:
	.loc 5 679 0
	cmp	w21, w27, uxth
	bls	.L1435
	.loc 5 684 0
	add	x1, x19, :lo12:.LANCHOR80
	.loc 5 681 0
	adrp	x0, .LANCHOR3
	.loc 5 684 0
	adrp	x25, .LANCHOR93
	add	x1, x1, 16
	.loc 5 681 0
	ldrh	w7, [x0, #:lo12:.LANCHOR3]
	.loc 5 684 0
	mov	w23, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	.loc 5 683 0
	mov	w6, 65535
	.loc 5 684 0
	add	w4, w4, w27
	b	.L1436
.LVL1891:
.L1429:
	.loc 5 682 0
	ldrh	w3, [x1]
.LVL1892:
	.loc 5 683 0
	cmp	w3, w6
	beq	.L1428
	.loc 5 684 0
	ubfiz	x5, x23, 5, 16
	.loc 5 685 0
	add	w23, w23, 1
.LVL1893:
	.loc 5 684 0
	add	x5, x0, x5
	.loc 5 685 0
	and	w23, w23, 65535
.LVL1894:
	.loc 5 684 0
	orr	w3, w4, w3, lsl 10
.LVL1895:
	str	w3, [x5, 4]
.L1428:
	.loc 5 681 0
	add	w2, w2, 1
.LVL1896:
	add	x1, x1, 2
.LVL1897:
	and	w2, w2, 65535
.LVL1898:
.L1436:
	cmp	w2, w7
	bne	.L1429
	.loc 5 689 0
	add	x1, x19, :lo12:.LANCHOR80
	.loc 5 701 0
	adrp	x26, .LANCHOR89
	add	x26, x26, :lo12:.LANCHOR89
	.loc 5 689 0
	ldrb	w2, [x1, 8]
.LVL1899:
	mov	w1, w23
	bl	FlashReadPages
.LVL1900:
	ubfiz	x0, x23, 5, 16
	mov	x23, 0
.LVL1901:
	str	x0, [x29, 144]
.LVL1902:
.L1430:
	.loc 5 691 0
	ldr	x0, [x29, 144]
	cmp	x0, x23
	bne	.L1434
.LVL1903:
	add	w27, w27, 1
.LVL1904:
	b	.L1427
.LVL1905:
.L1434:
	.loc 5 692 0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	add	x1, x0, x23
.LVL1906:
	.loc 5 693 0
	ldr	w0, [x0, x23]
	cmn	w0, #1
	beq	.L1431
	.loc 5 692 0
	ldr	x28, [x1, 16]
	.loc 5 693 0
	mov	w0, 61589
	ldrh	w1, [x28]
.LVL1907:
	cmp	w1, w0
	bne	.L1431
	.loc 5 695 0
	ldr	w4, [x28, 8]
.LVL1908:
	.loc 5 696 0
	cmn	w4, #1
	bne	.L1432
	str	w4, [x29, 112]
	mov	w2, 696
	adrp	x1, .LANCHOR175
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1909:
	ldr	w4, [x29, 112]
.LVL1910:
.L1432:
	.loc 5 697 0
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
.LVL1911:
	.loc 5 698 0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	ldr	w1, [x29, 188]
	add	x0, x0, x23
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bne	.L1431
	.loc 5 700 0
	ldr	x1, [x29, 152]
	.loc 5 701 0
	adrp	x4, .LANCHOR121
	.loc 5 700 0
	ldr	x2, [x29, 152]
	.loc 5 701 0
	ldr	w0, [x0, 24]
	.loc 5 700 0
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	.loc 5 701 0
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	ldr	w1, [x26]
	add	x1, x2, x1, lsl 5
	stp	x4, x1, [x29, 104]
	str	w0, [x1, 24]
	.loc 5 702 0
	bl	Ftl_get_new_temp_ppa
.LVL1912:
	ldp	x4, x1, [x29, 104]
	.loc 5 703 0
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	.loc 5 702 0
	str	w0, [x1, 4]
	.loc 5 703 0
	ldr	w1, [x26]
	ubfiz	x0, x1, 5, 32
	.loc 5 711 0
	add	w1, w1, 1
	.loc 5 703 0
	add	x2, x2, x0
	ldr	x0, [x25, #:lo12:.LANCHOR93]
	add	x0, x0, x23
	ldr	x4, [x0, 8]
	str	x4, [x2, 8]
	.loc 5 704 0
	ldr	x4, [x0, 16]
	str	x4, [x2, 16]
	.loc 5 705 0
	ldr	w2, [x29, 188]
	str	w2, [x28, 12]
	.loc 5 706 0
	adrp	x2, .LANCHOR53
	add	x11, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	strh	w2, [x28, 2]
	.loc 5 709 0
	adrp	x2, .LANCHOR71
	.loc 5 711 0
	str	w1, [x26]
	.loc 5 712 0
	mov	w1, 1
	.loc 5 709 0
	ldr	w2, [x2, #:lo12:.LANCHOR71]
	str	w2, [x28, 4]
	.loc 5 712 0
	bl	FtlGcBufAlloc
.LVL1913:
	.loc 5 713 0
	ldrb	w1, [x11, 7]
	ldr	w0, [x26]
	cmp	w1, w0
	beq	.L1433
	ldrh	w0, [x11, 4]
	cbnz	w0, .L1431
.L1433:
	.loc 5 714 0
	bl	Ftl_gc_temp_data_write_back
.LVL1914:
	cbz	w0, .L1431
.LVL1915:
.L1479:
	.loc 5 729 0
	str	wzr, [x22, #:lo12:.LANCHOR117]
	b	.L1478
.LVL1916:
.L1431:
	add	x23, x23, 32
	b	.L1430
.L1435:
	.loc 5 723 0
	add	x1, x19, :lo12:.LANCHOR80
	ldrh	w0, [x1, 2]
	add	w21, w21, w0
.LVL1917:
	.loc 5 725 0
	ldr	w0, [x29, 172]
	.loc 5 723 0
	and	w21, w21, 65535
	strh	w21, [x1, 2]
	.loc 5 725 0
	cmp	w0, w21
	bls	.L1437
	adrp	x0, .LANCHOR173
	ldrh	w1, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR174
	ldrh	w0, [x0, #:lo12:.LANCHOR174]
	cmp	w1, w0
	bne	.L1438
.L1437:
	.loc 5 727 0
	adrp	x0, .LANCHOR89
	ldr	w0, [x0, #:lo12:.LANCHOR89]
	cbz	w0, .L1439
	.loc 5 728 0
	bl	Ftl_gc_temp_data_write_back
.LVL1918:
	cbnz	w0, .L1479
.L1439:
	.loc 5 733 0
	adrp	x0, .LANCHOR173
	ldrh	w0, [x0, #:lo12:.LANCHOR173]
	cbnz	w0, .L1440
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	adrp	x1, .LANCHOR42
	ldr	x1, [x1, #:lo12:.LANCHOR42]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L1440
	.loc 5 735 0
	strh	wzr, [x1, x0]
	.loc 5 736 0
	ldrh	w0, [x19, #:lo12:.LANCHOR80]
	bl	update_vpc_list
.LVL1919:
	.loc 5 738 0
	bl	l2p_flush
.LVL1920:
	.loc 5 739 0
	bl	FtlVpcTblFlush
.LVL1921:
.L1440:
	.loc 5 741 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR80]
.L1438:
	.loc 5 743 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1441
	.loc 5 745 0
	ldr	x0, [x29, 120]
	ldrh	w21, [x0, #:lo12:.LANCHOR19]
.LVL1922:
	b	.L1413
.LVL1923:
.L1441:
	.loc 5 750 0
	adrp	x1, .LANCHOR172
	.loc 5 748 0
	str	wzr, [x22, #:lo12:.LANCHOR117]
	.loc 5 750 0
	ldrh	w1, [x1, #:lo12:.LANCHOR172]
	.loc 5 751 0
	cmp	w1, 0
	csinc	w0, w1, w0, ne
	b	.L1372
.LVL1924:
.L1444:
.LBE330:
.LBE331:
	.loc 5 479 0
	mov	w0, 0
.LVL1925:
	b	.L1372
	.cfi_endproc
.LFE319:
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.sftl_gc,"ax",@progbits
	.align	2
	.global	sftl_gc
	.type	sftl_gc, %function
sftl_gc:
.LFB320:
	.loc 5 757 0
	.cfi_startproc
	.loc 5 758 0
	mov	w1, 1
	mov	w0, w1
	b	rk_ftl_garbage_collect
.LVL1926:
	.cfi_endproc
.LFE320:
	.size	sftl_gc, .-sftl_gc
	.section	.text.FtlRead,"ax",@progbits
	.align	2
	.global	FtlRead
	.type	FtlRead, %function
FtlRead:
.LFB214:
	.loc 3 814 0
	.cfi_startproc
.LVL1927:
	stp	x29, x30, [sp, -176]!
	.cfi_def_cfa_offset 176
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	and	w0, w0, 255
	.loc 3 824 0
	cmp	w0, 16
	.loc 3 814 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	mov	w19, w1
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	mov	x23, x3
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	mov	w27, w2
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	.loc 3 824 0
	bne	.L1482
	.loc 3 825 0
	mov	x2, x3
.LVL1928:
	mov	w1, w27
.LVL1929:
	add	w0, w19, 256
.LVL1930:
	bl	FtlVendorPartRead
.LVL1931:
	mov	w21, w0
.LVL1932:
.L1481:
	.loc 3 901 0
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
.LVL1933:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL1934:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1935:
	ldp	x29, x30, [sp], 176
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1936:
.L1482:
	.cfi_restore_state
	.loc 3 830 0
	add	w0, w1, w2
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR34
	add	w1, w1, w2
.LVL1937:
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1502
	.loc 3 830 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR86
	ldr	w21, [x0, #:lo12:.LANCHOR86]
	cmn	w21, #1
	beq	.L1481
	.loc 3 835 0 is_stmt 1
	adrp	x22, .LANCHOR12
	.loc 3 836 0
	sub	w24, w1, #1
	.loc 3 841 0
	adrp	x1, .LANCHOR62
	.loc 3 840 0
	mov	w25, 0
	.loc 3 835 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	.loc 3 815 0
	mov	w21, 0
	.loc 3 851 0
	adrp	x28, .LANCHOR120
	.loc 3 828 0
	stp	wzr, wzr, [x29, 144]
	.loc 3 835 0
	udiv	w26, w19, w0
.LVL1938:
	.loc 3 836 0
	udiv	w24, w24, w0
.LVL1939:
	.loc 3 835 0
	mov	w20, w26
	.loc 3 837 0
	sub	w0, w24, w26
	add	w0, w0, 1
	stp	wzr, w0, [x29, 152]
.LVL1940:
	.loc 3 841 0
	ldr	w0, [x1, #:lo12:.LANCHOR62]
.LVL1941:
	ldr	w2, [x29, 156]
.LVL1942:
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR62]
	.loc 3 886 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	str	x0, [x29, 128]
.LVL1943:
.L1484:
	.loc 3 842 0
	ldr	w0, [x29, 156]
	cbnz	w0, .L1500
	.loc 3 898 0
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cbnz	w0, .L1501
	.loc 3 898 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 31
	bhi	.L1481
.L1501:
	.loc 3 899 0 is_stmt 1
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL1944:
	b	.L1481
.L1500:
	.loc 3 843 0
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
.LVL1945:
	.loc 3 844 0
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1485
	.loc 3 845 0 discriminator 1
	add	x5, x22, :lo12:.LANCHOR12
	mov	w4, 0
.L1486:
.LVL1946:
	ldrh	w0, [x5]
	cmp	w4, w0
	bcc	.L1488
.LVL1947:
.L1489:
	.loc 3 874 0
	ldr	w0, [x29, 156]
	.loc 3 872 0
	add	w20, w20, 1
.LVL1948:
	.loc 3 874 0
	subs	w0, w0, #1
	str	w0, [x29, 156]
.LVL1949:
	beq	.L1493
	.loc 3 874 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w25, w0, lsl 2
	bne	.L1484
.L1493:
	.loc 3 875 0 is_stmt 1
	cbz	w25, .L1484
	.loc 3 876 0
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	mov	w1, w25
	mov	w2, 0
	bl	FlashReadPages
.LVL1950:
	.loc 3 883 0
	ldr	w0, [x29, 144]
	lsl	w0, w0, 9
	str	w0, [x29, 136]
	.loc 3 880 0
	ldr	w0, [x29, 152]
	lsl	w0, w0, 9
	str	x0, [x29, 120]
	ldr	w0, [x29, 148]
	lsl	w0, w0, 9
	str	w0, [x29, 112]
	ubfiz	x0, x25, 5, 32
	mov	x25, 0
.LVL1951:
	str	x0, [x29, 104]
.LVL1952:
	.loc 3 883 0
	add	x0, x22, :lo12:.LANCHOR12
	str	x0, [x29, 96]
.L1499:
	.loc 3 878 0
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	add	x0, x0, x25
	ldr	w1, [x0, 24]
	cmp	w26, w1
	bne	.L1495
	.loc 3 879 0
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR115
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	cmp	x1, x0
	bne	.L1496
	.loc 3 880 0
	ldr	x0, [x29, 120]
	ldr	w2, [x29, 112]
	add	x1, x1, x0
	mov	x0, x23
.L1513:
	.loc 3 883 0
	bl	ftl_memcpy
.LVL1953:
.L1496:
	.loc 3 885 0
	ldr	x0, [x28, #:lo12:.LANCHOR120]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1497
	.loc 3 886 0
	ldr	x1, [x29, 128]
	.loc 3 887 0
	mov	w21, w0
.LVL1954:
	.loc 3 886 0
	ldr	x2, [x29, 128]
	ldr	w1, [x1, 72]
	add	w1, w1, 1
	str	w1, [x2, 72]
.LVL1955:
.L1498:
	.loc 3 877 0 discriminator 2
	ldr	x0, [x29, 104]
	add	x25, x25, 32
.LVL1956:
	cmp	x0, x25
	bne	.L1499
	.loc 3 894 0
	mov	w25, 0
	b	.L1484
.LVL1957:
.L1488:
	.loc 3 846 0
	madd	w0, w20, w0, w4
.LVL1958:
	.loc 3 847 0
	cmp	w19, w0
	bhi	.L1487
	.loc 3 847 0 is_stmt 0 discriminator 1
	ldr	w1, [x29, 140]
	cmp	w1, w0
	bls	.L1487
	.loc 3 848 0 is_stmt 1
	sub	w0, w0, w19
.LVL1959:
	str	x5, [x29, 112]
	lsl	w0, w0, 9
	str	w4, [x29, 120]
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
.LVL1960:
	ldr	w4, [x29, 120]
	ldr	x5, [x29, 112]
.LVL1961:
.L1487:
	.loc 3 845 0 discriminator 2
	add	w4, w4, 1
.LVL1962:
	b	.L1486
.LVL1963:
.L1485:
	.loc 3 851 0
	ldr	x2, [x28, #:lo12:.LANCHOR120]
	ubfiz	x0, x25, 5, 32
	.loc 3 852 0
	cmp	w20, w26
	.loc 3 851 0
	add	x0, x2, x0
	str	w1, [x0, 4]
	.loc 3 852 0
	bne	.L1490
	.loc 3 853 0
	adrp	x1, .LANCHOR115
	ldr	x1, [x1, #:lo12:.LANCHOR115]
	str	x1, [x0, 8]
	.loc 3 854 0
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 152]
.LVL1964:
	.loc 3 855 0
	sub	w2, w1, w2
.LVL1965:
	cmp	w27, w2
	csel	w2, w27, w2, ls
.LVL1966:
	str	w2, [x29, 148]
.LVL1967:
	.loc 3 857 0
	cmp	w1, w2
	bne	.L1491
	.loc 3 858 0
	str	x23, [x0, 8]
.LVL1968:
.L1491:
	.loc 3 867 0
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR114
	.loc 3 868 0
	str	w20, [x0, 24]
	.loc 3 867 0
	ldrh	w1, [x1, #:lo12:.LANCHOR24]
	ldr	x2, [x2, #:lo12:.LANCHOR114]
	mul	w1, w1, w25
	.loc 3 869 0
	add	w25, w25, 1
.LVL1969:
	.loc 3 867 0
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L1489
.L1490:
	.loc 3 859 0
	cmp	w20, w24
	bne	.L1492
	.loc 3 861 0
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	.loc 3 860 0
	adrp	x1, .LANCHOR113
	.loc 3 861 0
	ldr	w3, [x29, 140]
	.loc 3 860 0
	ldr	x1, [x1, #:lo12:.LANCHOR113]
	str	x1, [x0, 8]
	.loc 3 861 0
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 144]
.LVL1970:
	.loc 3 862 0
	cmp	w2, w3
	bne	.L1491
.LVL1971:
.L1512:
	.loc 3 865 0
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L1491
.L1492:
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	mul	w1, w1, w20
	b	.L1512
.LVL1972:
.L1495:
	.loc 3 881 0
	cmp	w24, w1
	bne	.L1496
	.loc 3 882 0
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR113
	ldr	x0, [x0, #:lo12:.LANCHOR113]
	cmp	x1, x0
	bne	.L1496
	.loc 3 883 0
	ldr	x0, [x29, 96]
	ldr	w2, [x29, 136]
	ldrh	w0, [x0]
	mul	w0, w0, w24
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L1513
.L1497:
	.loc 3 889 0
	cmp	w0, 256
	bne	.L1498
.LBB332:
	.loc 3 890 0
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1973:
	.loc 3 891 0
	bl	FtlGcRefreshBlock
.LVL1974:
	b	.L1498
.LVL1975:
.L1502:
.LBE332:
	.loc 3 831 0
	mov	w21, -1
	b	.L1481
	.cfi_endproc
.LFE214:
	.size	FtlRead, .-FtlRead
	.section	.text.sftl_read,"ax",@progbits
	.align	2
	.global	sftl_read
	.type	sftl_read, %function
sftl_read:
.LFB219:
	.loc 3 1168 0
	.cfi_startproc
.LVL1976:
	.loc 3 1169 0
	mov	x3, x2
	mov	w2, w1
.LVL1977:
	mov	w1, w0
.LVL1978:
	mov	w0, 0
.LVL1979:
	b	FtlRead
.LVL1980:
	.cfi_endproc
.LFE219:
	.size	sftl_read, .-sftl_read
	.section	.text.FtlWrite,"ax",@progbits
	.align	2
	.global	FtlWrite
	.type	FtlWrite, %function
FtlWrite:
.LFB217:
	.loc 3 958 0
	.cfi_startproc
.LVL1981:
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	and	w0, w0, 255
	.loc 3 966 0
	cmp	w0, 16
	.loc 3 958 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	mov	w21, w1
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	mov	x26, x3
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.loc 3 958 0
	str	w2, [x29, 176]
	.loc 3 966 0
	bne	.L1516
	.loc 3 967 0
	add	w0, w1, 256
.LVL1982:
	ldr	w1, [x29, 176]
.LVL1983:
	mov	x2, x3
.LVL1984:
	bl	FtlVendorPartWrite
.LVL1985:
.L1515:
	.loc 3 1117 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1986:
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
.LVL1987:
	ret
.LVL1988:
.L1516:
	.cfi_restore_state
	.loc 3 970 0
	ldr	w0, [x29, 176]
	add	w0, w1, w0
	str	w0, [x29, 168]
	adrp	x0, .LANCHOR34
	ldr	w1, [x29, 168]
.LVL1989:
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1551
	.loc 3 970 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR86
	ldr	w0, [x0, #:lo12:.LANCHOR86]
	cmn	w0, #1
	beq	.L1515
	.loc 3 973 0 is_stmt 1
	adrp	x0, .LANCHOR176
	mov	w1, 2048
	.loc 3 974 0
	adrp	x22, .LANCHOR12
	.loc 3 973 0
	str	w1, [x0, #:lo12:.LANCHOR176]
	.loc 3 975 0
	ldr	w1, [x29, 168]
	.loc 3 974 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	.loc 3 975 0
	sub	w1, w1, #1
	.loc 3 974 0
	udiv	w25, w21, w0
.LVL1990:
	.loc 3 975 0
	udiv	w0, w1, w0
	.loc 3 978 0
	adrp	x1, .LANCHOR64
	.loc 3 975 0
	str	w0, [x29, 156]
.LVL1991:
	.loc 3 976 0
	sub	w0, w0, w25
.LVL1992:
	add	w24, w0, 1
.LVL1993:
	str	w0, [x29, 152]
	.loc 3 978 0
	ldr	w0, [x1, #:lo12:.LANCHOR64]
	add	w0, w0, w24
	str	w0, [x1, #:lo12:.LANCHOR64]
.LVL1994:
	.loc 3 984 0
	adrp	x0, .LANCHOR177
	str	x0, [x29, 160]
	ldr	w1, [x0, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	cbz	w1, .L1518
	.loc 3 984 0 is_stmt 0 discriminator 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1518
	.loc 3 985 0 is_stmt 1
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L1518:
	mov	w20, w25
	.loc 3 999 0
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	str	x0, [x29, 96]
.LVL1995:
.L1519:
	.loc 3 987 0
	cbnz	w24, .L1547
	.loc 3 1101 0
	ldr	w1, [x29, 152]
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL1996:
	.loc 3 1103 0
	adrp	x0, .LANCHOR48
	mov	x22, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	cmp	w1, 15
	bls	.L1548
.LVL1997:
.L1550:
	.loc 3 1116 0
	mov	w0, 0
	b	.L1515
.LVL1998:
.L1547:
	.loc 3 988 0
	adrp	x0, .LANCHOR3
	ldrb	w2, [x19, 6]
	str	x0, [x29, 120]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	cmp	w2, w1
	bcc	.L1520
	.loc 3 988 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 988
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1999:
.L1520:
	.loc 3 989 0 is_stmt 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1521
	.loc 3 992 0
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	cmp	x19, x0
	bne	.L1522
	.loc 3 993 0
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1523
	.loc 3 994 0
	bl	allocate_new_data_superblock
.LVL2000:
	.loc 3 995 0
	ldr	x0, [x29, 160]
	str	wzr, [x0, #:lo12:.LANCHOR177]
.L1523:
	.loc 3 997 0
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
.LVL2001:
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2002:
	.loc 3 998 0
	ldr	x0, [x29, 160]
	ldr	w0, [x0, #:lo12:.LANCHOR177]
	.loc 3 999 0
	cmp	w0, 0
	ldr	x0, [x29, 96]
	csel	x19, x0, x19, ne
.L1524:
.LVL2003:
	.loc 3 1009 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1521
	.loc 3 1010 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2004:
.L1521:
	.loc 3 1019 0
	ldrh	w0, [x19, 4]
	.loc 3 1017 0
	ldrb	w1, [x19, 7]
	cmp	w0, w24
	csel	w0, w0, w24, ls
	lsl	w1, w1, 2
	cmp	w1, w0
	csel	w0, w1, w0, ls
	str	w0, [x29, 148]
.LVL2005:
	.loc 3 1021 0
	ldr	x0, [x29, 120]
.LVL2006:
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1525
	.loc 3 1021 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1021
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2007:
.L1525:
	.loc 3 1031 0 is_stmt 1 discriminator 1
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	.loc 3 1044 0 discriminator 1
	str	xzr, [x29, 184]
	.loc 3 1031 0 discriminator 1
	str	x0, [x29, 112]
	.loc 3 1077 0 discriminator 1
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	str	x0, [x29, 104]
.L1526:
	.loc 3 1022 0 discriminator 1
	ldr	w1, [x29, 148]
	adrp	x28, .LANCHOR122
	ldr	w23, [x29, 184]
.LVL2008:
	cmp	w23, w1
	bcc	.L1545
	mov	x23, x1
.L1527:
.LVL2009:
	.loc 3 1097 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	mov	x3, x19
	mov	w2, 0
	mov	w1, w23
	bl	FtlProgPages
.LVL2010:
	.loc 3 1098 0
	cmp	w24, w23
	bcs	.L1546
	.loc 3 1098 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1098
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2011:
.L1546:
	.loc 3 1099 0 is_stmt 1
	sub	w24, w24, w23
.LVL2012:
	b	.L1519
.LVL2013:
.L1522:
	.loc 3 1003 0
	ldr	x1, [x29, 160]
	str	wzr, [x1, #:lo12:.LANCHOR177]
	.loc 3 1004 0
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1556
	.loc 3 1005 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2014:
	b	.L1524
.L1556:
	mov	x19, x0
.LVL2015:
	b	.L1521
.LVL2016:
.L1545:
	.loc 3 1023 0
	ldrh	w0, [x19, 4]
	cbz	w0, .L1527
	.loc 3 1027 0
	add	x1, x29, 204
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
.LVL2017:
	.loc 3 1028 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL2018:
	ldr	x1, [x29, 184]
	lsl	x27, x1, 5
	.loc 3 1030 0
	ldr	x1, [x28, #:lo12:.LANCHOR122]
	add	x1, x1, x27
	str	w0, [x1, 4]
	.loc 3 1031 0
	ldr	x0, [x29, 112]
.LVL2019:
	.loc 3 1032 0
	str	w20, [x1, 24]
	.loc 3 1031 0
	ldrh	w2, [x0]
	mul	w23, w23, w2
	and	x0, x23, 4294967292
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR114
	ldr	x3, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR114]
	str	x0, [x29, 128]
	add	x23, x0, x3
.LVL2020:
	str	x23, [x1, 16]
	.loc 3 1035 0
	mov	x0, x23
	mov	w1, 0
.LVL2021:
	bl	ftl_memset
.LVL2022:
	.loc 3 1037 0
	ldr	w0, [x29, 156]
	cmp	w20, w25
	ccmp	w20, w0, 4, ne
	bne	.L1528
	.loc 3 1038 0
	cmp	w20, w25
	bne	.L1529
	.loc 3 1039 0
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 172]
.LVL2023:
	.loc 3 1040 0
	sub	w2, w2, w0
	ldr	w0, [x29, 176]
.LVL2024:
	cmp	w2, w0
	csel	w0, w2, w0, ls
	str	w0, [x29, 180]
.LVL2025:
.L1530:
	.loc 3 1048 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	ldr	w1, [x29, 180]
	cmp	w1, w0
	.loc 3 1050 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	.loc 3 1048 0
	bne	.L1531
	.loc 3 1050 0
	add	x3, x0, x27
	.loc 3 1049 0
	cmp	w20, w25
	bne	.L1532
	.loc 3 1050 0
	str	x26, [x3, 8]
.LVL2026:
.L1533:
	.loc 3 1089 0
	ldr	x0, [x29, 120]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1542
	.loc 3 1089 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	mov	w2, 1089
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2027:
.L1542:
	.loc 3 1090 0 is_stmt 1
	ldp	x1, x2, [x29, 128]
	mov	w0, -3947
	strh	w0, [x1, x2]
	.loc 3 1091 0
	adrp	x1, .LANCHOR71
	ldr	w0, [x1, #:lo12:.LANCHOR71]
	.loc 3 1092 0
	stp	w0, w20, [x23, 4]
	.loc 3 1095 0
	add	w20, w20, 1
.LVL2028:
	.loc 3 1091 0
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR71]
	.loc 3 1093 0
	ldr	w0, [x29, 204]
	str	w0, [x23, 12]
	.loc 3 1094 0
	ldrh	w0, [x19]
	strh	w0, [x23, 2]
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
	b	.L1526
.LVL2029:
.L1529:
	.loc 3 1045 0
	ldr	w0, [x29, 168]
	ldrh	w2, [x22, #:lo12:.LANCHOR12]
	.loc 3 1044 0
	str	wzr, [x29, 172]
	.loc 3 1045 0
	msub	w2, w20, w2, w0
	and	w0, w2, 65535
	str	w0, [x29, 180]
.LVL2030:
	b	.L1530
.LVL2031:
.L1532:
	.loc 3 1052 0
	ldr	w0, [x29, 180]
.LVL2032:
.L1563:
	.loc 3 1087 0
	mul	w0, w0, w20
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x26, x0
	str	x0, [x3, 8]
	b	.L1533
.LVL2033:
.L1531:
	.loc 3 1056 0
	add	x0, x0, x27
	.loc 3 1055 0
	cmp	w20, w25
	bne	.L1534
	.loc 3 1056 0
	adrp	x1, .LANCHOR115
	ldr	x1, [x1, #:lo12:.LANCHOR115]
.L1562:
	.loc 3 1058 0
	str	x1, [x0, 8]
	.loc 3 1060 0
	ldr	w0, [x29, 204]
	cmn	w0, #1
	beq	.L1536
.LBB333:
	.loc 3 1062 0
	str	w0, [x29, 212]
	.loc 3 1066 0
	mov	w2, 0
	.loc 3 1064 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	.loc 3 1063 0
	str	w20, [x29, 232]
	.loc 3 1064 0
	add	x0, x0, x27
	.loc 3 1065 0
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 216]
	.loc 3 1066 0
	mov	w1, 1
	add	x0, x29, 208
	bl	FlashReadPages
.LVL2034:
	.loc 3 1067 0
	ldr	w0, [x29, 208]
	cmn	w0, #1
	bne	.L1537
	.loc 3 1068 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L1540:
	ldr	w0, [x29, 180]
.LBE333:
	.loc 3 1080 0
	cmp	w20, w25
	lsl	w2, w0, 9
	bne	.L1541
	.loc 3 1081 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	mov	x1, x26
	add	x3, x0, x27
	ldr	w0, [x29, 172]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L1564:
	.loc 3 1083 0
	bl	ftl_memcpy
.LVL2035:
	b	.L1533
.L1534:
	.loc 3 1058 0
	adrp	x1, .LANCHOR113
	ldr	x1, [x1, #:lo12:.LANCHOR113]
	b	.L1562
.L1537:
.LBB334:
	.loc 3 1070 0
	ldr	w1, [x23, 8]
	cmp	w20, w1
	beq	.L1539
	.loc 3 1071 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	.loc 3 1072 0
	adrp	x0, .LC108
	mov	w2, w20
	add	x0, x0, :lo12:.LC108
	bl	printf
.LVL2036:
.L1539:
	.loc 3 1074 0
	ldr	w0, [x23, 8]
	cmp	w20, w0
	beq	.L1540
	.loc 3 1074 0 is_stmt 0 discriminator 1
	mov	w2, 1074
	adrp	x1, .LANCHOR178
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2037:
	b	.L1540
.LVL2038:
.L1536:
.LBE334:
	.loc 3 1077 0 is_stmt 1
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	ldr	x1, [x29, 104]
	add	x0, x0, x27
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
.LVL2039:
	b	.L1540
.L1541:
	.loc 3 1083 0
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x3, x0, x27
	mul	w1, w1, w20
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x26, x1
	b	.L1564
.LVL2040:
.L1528:
	.loc 3 1087 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x3, x0, x27
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	b	.L1563
.LVL2041:
.L1548:
	.loc 3 1105 0
	adrp	x21, .LANCHOR99
.LVL2042:
	.loc 3 1107 0
	adrp	x20, .LANCHOR83
.LVL2043:
	.loc 3 1108 0
	adrp	x19, .LANCHOR82
.LVL2044:
	.loc 3 1105 0
	add	x21, x21, :lo12:.LANCHOR99
	.loc 3 1107 0
	add	x20, x20, :lo12:.LANCHOR83
	.loc 3 1108 0
	add	x19, x19, :lo12:.LANCHOR82
.L1560:
	.loc 3 1105 0
	adrp	x0, .LANCHOR80
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w1
	bne	.L1549
	.loc 3 1105 0 is_stmt 0 discriminator 1
	ldrh	w1, [x21]
	cmp	w1, w0
	bne	.L1549
	.loc 3 1106 0 is_stmt 1
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL2045:
	bl	FtlGcRefreshBlock
.LVL2046:
.L1549:
	.loc 3 1107 0
	mov	w0, 128
	.loc 3 1109 0
	mov	w1, 1
	.loc 3 1107 0
	strh	w0, [x20]
	.loc 3 1108 0
	strh	w0, [x19]
	.loc 3 1109 0
	mov	w0, w1
	bl	rk_ftl_garbage_collect
.LVL2047:
	.loc 3 1110 0
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL2048:
	.loc 3 1111 0
	ldrh	w0, [x22, #:lo12:.LANCHOR48]
	cmp	w0, 8
	bls	.L1560
	b	.L1550
.LVL2049:
.L1551:
	.loc 3 971 0
	mov	w0, -1
	b	.L1515
	.cfi_endproc
.LFE217:
	.size	FtlWrite, .-FtlWrite
	.section	.text.sftl_write,"ax",@progbits
	.align	2
	.global	sftl_write
	.type	sftl_write, %function
sftl_write:
.LFB220:
	.loc 3 1173 0
	.cfi_startproc
.LVL2050:
	.loc 3 1174 0
	mov	x3, x2
	mov	w2, w1
.LVL2051:
	mov	w1, w0
.LVL2052:
	mov	w0, 0
.LVL2053:
	b	FtlWrite
.LVL2054:
	.cfi_endproc
.LFE220:
	.size	sftl_write, .-sftl_write
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
.LFB274:
	.loc 2 1409 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 1417 0
	mov	w1, 0
	.loc 2 1409 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 2 1414 0
	adrp	x19, .LANCHOR106
	.loc 2 1409 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 2 1414 0
	adrp	x23, .LANCHOR107
	.loc 2 1409 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 1414 0
	add	x21, x19, :lo12:.LANCHOR106
	.loc 2 1409 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.loc 2 1415 0
	adrp	x26, .LANCHOR108
	.loc 2 1409 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	.loc 2 1417 0
	adrp	x25, .LANCHOR42
	.loc 2 1414 0
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	.loc 2 1417 0
	adrp	x24, .LANCHOR5
	.loc 2 1414 0
	str	x0, [x21, 8]
	.loc 2 1418 0
	adrp	x20, .LANCHOR79
	.loc 2 1415 0
	ldr	x0, [x26, #:lo12:.LANCHOR108]
	str	x0, [x21, 16]
	.loc 2 1417 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL2055:
	.loc 2 1418 0
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1567
.L1575:
	.loc 2 1419 0
	mov	w0, -1
.L1566:
	.loc 2 1512 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L1567:
	.cfi_restore_state
	add	x27, x20, :lo12:.LANCHOR79
	.loc 2 1421 0
	mov	w1, 1
	bl	FtlGetLastWrittenPage
.LVL2056:
	sxth	w22, w0
.LVL2057:
	.loc 2 1422 0
	add	w0, w0, 1
	.loc 2 1431 0
	mov	w28, 61604
	.loc 2 1422 0
	strh	w0, [x27, 2]
	.loc 2 1430 0
	mov	w27, 19539
	movk	w27, 0x4654, lsl 16
.L1569:
	.loc 2 1424 0
	tbz	w22, #31, .L1572
	.loc 2 1437 0
	adrp	x1, .LANCHOR179
	adrp	x0, .LC1
	mov	w2, 1437
	add	x1, x1, :lo12:.LANCHOR179
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2058:
.L1571:
	.loc 2 1439 0
	adrp	x1, .LANCHOR23
	ldrh	w0, [x24, #:lo12:.LANCHOR5]
	ldrh	w1, [x1, #:lo12:.LANCHOR23]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L1574
	.loc 2 1439 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR179
	adrp	x0, .LC1
	mov	w2, 1439
	add	x1, x1, :lo12:.LANCHOR179
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2059:
.L1574:
	.loc 2 1441 0 is_stmt 1
	add	x22, x19, :lo12:.LANCHOR106
.LVL2060:
	adrp	x19, .LANCHOR39
	add	x21, x19, :lo12:.LANCHOR39
	mov	w2, 48
	mov	x0, x21
	ldr	x1, [x22, 8]
	bl	ftl_memcpy
.LVL2061:
	.loc 2 1442 0
	ldr	x0, [x25, #:lo12:.LANCHOR42]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	ldr	x1, [x22, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
.LVL2062:
	.loc 2 1443 0
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
.LVL2063:
	.loc 2 1445 0
	ldr	w1, [x19, #:lo12:.LANCHOR39]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1575
	.loc 2 1448 0
	add	x20, x20, :lo12:.LANCHOR79
	.loc 2 1449 0
	adrp	x0, .LANCHOR10
	.loc 2 1448 0
	ldrh	w1, [x21, 8]
	.loc 2 1449 0
	ldrb	w2, [x21, 10]
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	.loc 2 1448 0
	strh	w1, [x20, 6]
	.loc 2 1449 0
	cmp	w2, w0
	bne	.L1575
	.loc 2 1452 0
	adrp	x0, .LANCHOR180
	.loc 2 1453 0
	adrp	x2, .LANCHOR61
	.loc 2 1455 0
	adrp	x3, .LANCHOR3
	.loc 2 1452 0
	str	w1, [x0, #:lo12:.LANCHOR180]
	.loc 2 1453 0
	adrp	x0, .LANCHOR19
	.loc 2 1455 0
	ldrh	w3, [x3, #:lo12:.LANCHOR3]
	.loc 2 1453 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR61]
	.loc 2 1454 0
	adrp	x2, .LANCHOR12
	ldrh	w2, [x2, #:lo12:.LANCHOR12]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR34
	str	w0, [x2, #:lo12:.LANCHOR34]
	.loc 2 1455 0
	adrp	x0, .LANCHOR7
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LANCHOR37+6
	ldrh	w0, [x0, #:lo12:.LANCHOR37+6]
	.loc 2 1461 0
	cmp	w1, w2
	.loc 2 1455 0
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR78
	strh	w0, [x3, #:lo12:.LANCHOR78]
	.loc 2 1461 0
	bls	.L1576
	.loc 2 1461 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR179
	adrp	x0, .LC1
	mov	w2, 1461
	add	x1, x1, :lo12:.LANCHOR179
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2064:
.L1576:
	.loc 2 1463 0 is_stmt 1
	add	x1, x19, :lo12:.LANCHOR39
	adrp	x0, .LANCHOR51
	add	x3, x0, :lo12:.LANCHOR51
	.loc 2 1468 0
	adrp	x20, .LANCHOR80
	.loc 2 1464 0
	ldrh	w2, [x1, 16]
	.loc 2 1463 0
	ldrh	w6, [x1, 14]
	strh	w6, [x0, #:lo12:.LANCHOR51]
	.loc 2 1464 0
	lsr	w4, w2, 6
	.loc 2 1465 0
	and	w2, w2, 63
	strb	w2, [x3, 6]
	.loc 2 1466 0
	ldrb	w2, [x1, 11]
	strb	w2, [x3, 8]
	.loc 2 1468 0
	add	x2, x20, :lo12:.LANCHOR80
	.loc 2 1464 0
	strh	w4, [x3, 2]
	.loc 2 1468 0
	mov	w3, -1
	strh	w3, [x20, #:lo12:.LANCHOR80]
	.loc 2 1469 0
	strh	wzr, [x2, 2]
	.loc 2 1470 0
	strb	wzr, [x2, 6]
	.loc 2 1471 0
	strb	wzr, [x2, 8]
	.loc 2 1473 0
	adrp	x2, .LANCHOR52
	ldrh	w3, [x1, 18]
	add	x4, x2, :lo12:.LANCHOR52
	strh	w3, [x2, #:lo12:.LANCHOR52]
	mov	x21, x2
	.loc 2 1474 0
	ldrh	w3, [x1, 20]
	lsr	w5, w3, 6
	.loc 2 1475 0
	and	w3, w3, 63
	strb	w3, [x4, 6]
	.loc 2 1476 0
	ldrb	w3, [x1, 12]
	.loc 2 1474 0
	strh	w5, [x4, 2]
	.loc 2 1476 0
	strb	w3, [x4, 8]
	.loc 2 1478 0
	adrp	x4, .LANCHOR53
	ldrh	w3, [x1, 22]
	add	x5, x4, :lo12:.LANCHOR53
	strh	w3, [x4, #:lo12:.LANCHOR53]
	mov	x22, x4
	.loc 2 1479 0
	ldrh	w3, [x1, 24]
	lsr	w7, w3, 6
	.loc 2 1480 0
	and	w3, w3, 63
	strb	w3, [x5, 6]
	.loc 2 1481 0
	ldrb	w3, [x1, 13]
	strb	w3, [x5, 8]
	.loc 2 1483 0
	adrp	x3, .LANCHOR67
	.loc 2 1479 0
	strh	w7, [x5, 2]
	.loc 2 1488 0
	ldr	w5, [x1, 32]
	.loc 2 1483 0
	str	wzr, [x3, #:lo12:.LANCHOR67]
	.loc 2 1484 0
	adrp	x3, .LANCHOR64
	str	wzr, [x3, #:lo12:.LANCHOR64]
	.loc 2 1485 0
	adrp	x3, .LANCHOR62
	str	wzr, [x3, #:lo12:.LANCHOR62]
	.loc 2 1486 0
	adrp	x3, .LANCHOR66
	str	wzr, [x3, #:lo12:.LANCHOR66]
	.loc 2 1488 0
	adrp	x3, .LANCHOR72
	str	w5, [x3, #:lo12:.LANCHOR72]
	.loc 2 1489 0
	adrp	x3, .LANCHOR73
	str	wzr, [x3, #:lo12:.LANCHOR73]
	.loc 2 1490 0
	adrp	x3, .LANCHOR76
	str	wzr, [x3, #:lo12:.LANCHOR76]
	.loc 2 1491 0
	adrp	x3, .LANCHOR65
	str	wzr, [x3, #:lo12:.LANCHOR65]
	.loc 2 1493 0
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR70
	ldr	w5, [x1, #:lo12:.LANCHOR70]
	cmp	w3, w5
	bls	.L1577
	.loc 2 1494 0
	str	w3, [x1, #:lo12:.LANCHOR70]
.L1577:
	.loc 2 1496 0
	add	x19, x19, :lo12:.LANCHOR39
	adrp	x1, .LANCHOR71
	ldr	w3, [x1, #:lo12:.LANCHOR71]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L1578
	.loc 2 1497 0
	str	w2, [x1, #:lo12:.LANCHOR71]
.L1578:
	.loc 2 1499 0
	mov	w1, 65535
	cmp	w6, w1
	beq	.L1579
	.loc 2 1500 0
	add	x0, x0, :lo12:.LANCHOR51
	bl	make_superblock
.LVL2065:
.L1579:
	.loc 2 1502 0
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR52
	cmp	w2, w1
	beq	.L1580
	.loc 2 1503 0
	bl	make_superblock
.LVL2066:
.L1580:
	.loc 2 1505 0
	ldrh	w2, [x22, #:lo12:.LANCHOR53]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR53
	cmp	w2, w1
	beq	.L1581
	.loc 2 1506 0
	bl	make_superblock
.LVL2067:
.L1581:
	.loc 2 1508 0
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR80
	cmp	w2, w1
	beq	.L1582
	.loc 2 1509 0
	bl	make_superblock
.LVL2068:
.L1582:
	.loc 2 1511 0
	mov	w0, 0
	b	.L1566
.LVL2069:
.L1572:
	.loc 2 1425 0
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	.loc 2 1427 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 1425 0
	orr	w0, w22, w0, lsl 10
	str	w0, [x21, 4]
	.loc 2 1426 0
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	str	x0, [x21, 8]
	.loc 2 1427 0
	mov	x0, x21
	bl	FlashReadPages
.LVL2070:
	.loc 2 1430 0
	ldr	w0, [x21]
	cmn	w0, #1
	beq	.L1570
	.loc 2 1431 0 discriminator 1
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	.loc 2 1430 0 discriminator 1
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1570
	.loc 2 1432 0
	ldr	x0, [x26, #:lo12:.LANCHOR108]
	ldrh	w0, [x0]
	.loc 2 1431 0
	cmp	w0, w28
	beq	.L1571
.L1570:
	sub	w22, w22, #1
.LVL2071:
	sxth	w22, w22
.LVL2072:
	b	.L1569
	.cfi_endproc
.LFE274:
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlSysBlkInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkInit
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
.LFB292:
	.loc 2 2356 0
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 2362 0
	adrp	x0, .LANCHOR4
	.loc 2 2356 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2362 0
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	.loc 2 2356 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 2 2360 0
	adrp	x20, .LANCHOR161
	.loc 2 2356 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	.loc 2 2360 0
	strh	wzr, [x20, #:lo12:.LANCHOR161]
	.loc 2 2362 0
	bl	FtlFreeSysBlkQueueInit
.LVL2073:
	.loc 2 2363 0
	bl	FtlScanSysBlk
.LVL2074:
	.loc 2 2364 0
	adrp	x0, .LANCHOR79
	ldrh	w1, [x0, #:lo12:.LANCHOR79]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1589
.L1591:
	.loc 2 2365 0
	mov	w23, -1
.L1588:
	.loc 2 2451 0
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L1589:
	.cfi_restore_state
	.loc 2 2367 0
	bl	FtlLoadSysInfo
.LVL2075:
	mov	w23, w0
	cbnz	w0, .L1591
	.loc 2 2370 0
	bl	FtlLoadMapInfo
.LVL2076:
	.loc 2 2371 0
	bl	FtlLoadVonderInfo
.LVL2077:
	.loc 2 2372 0
	bl	Ftl_load_ext_data
.LVL2078:
	.loc 2 2374 0
	bl	FtlLoadEctTbl
.LVL2079:
	.loc 2 2375 0
	bl	FtlFreeSysBLkSort
.LVL2080:
	.loc 2 2377 0
	bl	SupperBlkListInit
.LVL2081:
	.loc 2 2378 0
	bl	FtlPowerLostRecovery
.LVL2082:
	.loc 2 2380 0
	mov	w0, 1
	bl	FtlUpdateVaildLpn
.LVL2083:
.LBB338:
.LBB339:
	.loc 2 2382 0
	adrp	x0, .LANCHOR33
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	.loc 2 2383 0
	adrp	x0, .LANCHOR55
	ldr	x1, [x0, #:lo12:.LANCHOR55]
	.loc 2 2382 0
	mov	w0, 0
	add	x1, x1, 4
.L1592:
.LVL2084:
	cmp	w0, w2
	bge	.L1597
	.loc 2 2383 0
	ldr	w3, [x1], 16
	tbz	w3, #31, .L1593
.L1597:
	.loc 2 2386 0
	adrp	x19, .LANCHOR39
	add	x3, x19, :lo12:.LANCHOR39
	.loc 2 2388 0
	cmp	w0, w2
	adrp	x22, .LANCHOR51
	.loc 2 2386 0
	ldrh	w1, [x3, 28]
	add	w1, w1, 1
	strh	w1, [x3, 28]
	.loc 2 2388 0
	bge	.L1601
.LVL2085:
.L1594:
	.loc 2 2389 0
	add	x21, x22, :lo12:.LANCHOR51
	.loc 2 2390 0
	adrp	x24, .LANCHOR52
	.loc 2 2389 0
	mov	x0, x21
	.loc 2 2390 0
	add	x20, x24, :lo12:.LANCHOR52
	.loc 2 2389 0
	bl	FtlSuperblockPowerLostFix
.LVL2086:
	.loc 2 2390 0
	mov	x0, x20
	bl	FtlSuperblockPowerLostFix
.LVL2087:
.LBB340:
	.loc 2 2396 0
	adrp	x0, .LANCHOR42
	ldrh	w3, [x21, 4]
	ldr	x1, [x0, #:lo12:.LANCHOR42]
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w3
	.loc 2 2397 0
	adrp	x3, .LANCHOR19
	.loc 2 2396 0
	strh	w2, [x1, x0]
	.loc 2 2398 0
	strb	wzr, [x21, 6]
	.loc 2 2397 0
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x21, 2]
	.loc 2 2402 0
	ldrh	w0, [x24, #:lo12:.LANCHOR52]
	.loc 2 2399 0
	strh	wzr, [x21, 4]
.LVL2088:
	.loc 2 2402 0
	ldrh	w4, [x20, 4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w4
	strh	w2, [x1, x0]
	.loc 2 2404 0
	strb	wzr, [x20, 6]
	.loc 2 2403 0
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x20, 2]
	.loc 2 2405 0
	strh	wzr, [x20, 4]
.LBE340:
	.loc 2 2409 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL2089:
	.loc 2 2410 0
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	bl	FtlMapBlkWriteDump_data
.LVL2090:
	.loc 2 2422 0
	add	x1, x19, :lo12:.LANCHOR39
	ldrh	w0, [x1, 30]
	add	w0, w0, 1
	strh	w0, [x1, 30]
	.loc 2 2423 0
	bl	l2p_flush
.LVL2091:
	.loc 2 2424 0
	bl	FtlVpcTblFlush
.LVL2092:
.L1603:
	.loc 2 2428 0
	bl	FtlVpcTblFlush
.LVL2093:
	.loc 2 2432 0
	add	x21, x22, :lo12:.LANCHOR51
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L1600
	ldrh	w1, [x21, 4]
	cbnz	w1, .L1600
	.loc 2 2434 0
	adrp	x22, .LANCHOR52
	add	x20, x22, :lo12:.LANCHOR52
	.loc 2 2433 0
	ldrh	w1, [x20, 4]
	cbnz	w1, .L1600
	.loc 2 2435 0
	bl	FtlGcRefreshBlock
.LVL2094:
	.loc 2 2436 0
	ldrh	w0, [x22, #:lo12:.LANCHOR52]
	bl	FtlGcRefreshBlock
.LVL2095:
	.loc 2 2437 0
	mov	x0, x21
	bl	allocate_new_data_superblock
.LVL2096:
	.loc 2 2438 0
	mov	x0, x20
	bl	allocate_new_data_superblock
.LVL2097:
.L1600:
	.loc 2 2443 0
	add	x19, x19, :lo12:.LANCHOR39
	ldrh	w0, [x19, 28]
	tst	x0, 31
	bne	.L1588
	.loc 2 2444 0
	bl	FtlVpcCheckAndModify
.LVL2098:
	b	.L1588
.LVL2099:
.L1593:
	.loc 2 2382 0
	add	w0, w0, 1
.LVL2100:
	b	.L1592
.L1601:
	.loc 2 2388 0
	ldrh	w0, [x20, #:lo12:.LANCHOR161]
.LVL2101:
	cbnz	w0, .L1594
	.loc 2 2427 0
	bl	l2p_flush
.LVL2102:
	b	.L1603
.LBE339:
.LBE338:
	.cfi_endproc
.LFE292:
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
.LFB210:
	.loc 3 623 0
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 3 630 0
	adrp	x0, .LANCHOR71
	.loc 3 623 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 3 631 0
	adrp	x24, .LANCHOR4
	.loc 3 630 0
	str	wzr, [x0, #:lo12:.LANCHOR71]
	.loc 3 631 0
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	.loc 3 623 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.loc 3 629 0
	adrp	x20, .LANCHOR70
	.loc 3 623 0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 3 629 0
	str	wzr, [x20, #:lo12:.LANCHOR70]
	.loc 3 631 0
	bl	FtlFreeSysBlkQueueInit
.LVL2103:
	.loc 3 632 0
	bl	FtlLoadBbt
.LVL2104:
	cbz	w0, .L1605
	.loc 3 633 0
	bl	FtlMakeBbt
.LVL2105:
.L1605:
	.loc 3 635 0 discriminator 1
	adrp	x23, .LANCHOR12
	.loc 3 636 0 discriminator 1
	adrp	x0, .LANCHOR115
	.loc 3 637 0 discriminator 1
	mov	w6, 23752
	.loc 3 635 0 discriminator 1
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	.loc 3 637 0 discriminator 1
	movk	w6, 0xa0f, lsl 16
	.loc 3 636 0 discriminator 1
	ldr	x4, [x0, #:lo12:.LANCHOR115]
	.loc 3 637 0 discriminator 1
	adrp	x0, .LANCHOR113
	.loc 3 635 0 discriminator 1
	lsl	w1, w1, 7
	.loc 3 637 0 discriminator 1
	ldr	x5, [x0, #:lo12:.LANCHOR113]
	mov	w0, 0
.L1606:
.LVL2106:
	.loc 3 635 0 discriminator 1
	cmp	w0, w1
	blt	.L1607
.LVL2107:
	.loc 3 642 0
	adrp	x21, .LANCHOR5
	adrp	x22, .LANCHOR6
	add	x26, x22, :lo12:.LANCHOR6
	.loc 3 641 0
	mov	w19, 0
	.loc 3 642 0
	ldrh	w25, [x21, #:lo12:.LANCHOR5]
.LVL2108:
.L1608:
	.loc 3 642 0 is_stmt 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L1609
	.loc 3 645 0 is_stmt 1
	adrp	x25, .LANCHOR3
.LVL2109:
	sub	w1, w19, #2
	ldrh	w0, [x25, #:lo12:.LANCHOR3]
	cmp	w1, w0, lsl 1
	bgt	.L1610
.LVL2110:
.L1614:
	.loc 3 656 0
	add	x26, x21, :lo12:.LANCHOR5
	.loc 3 641 0
	mov	w19, 0
	mov	w24, 0
.L1611:
.LVL2111:
	.loc 3 656 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L1615
	.loc 3 658 0
	adrp	x0, .LANCHOR112
	ldrh	w1, [x22, #:lo12:.LANCHOR6]
	.loc 3 661 0
	ldrh	w4, [x25, #:lo12:.LANCHOR3]
	.loc 3 662 0
	adrp	x2, .LANCHOR78
	.loc 3 658 0
	str	w1, [x0, #:lo12:.LANCHOR112]
	.loc 3 661 0
	adrp	x0, .LANCHOR7
	adrp	x3, .LANCHOR61
	ldr	w1, [x0, #:lo12:.LANCHOR7]
	udiv	w5, w1, w4
	.loc 3 662 0
	ubfx	x0, x5, 5, 16
	.loc 3 661 0
	str	w5, [x3, #:lo12:.LANCHOR61]
	.loc 3 662 0
	add	w6, w0, 36
	strh	w6, [x2, #:lo12:.LANCHOR78]
	.loc 3 663 0
	mov	w6, 24
	mul	w6, w4, w6
	cmp	w19, w6
	ble	.L1616
	.loc 3 664 0
	sub	w1, w1, w19
	udiv	w1, w1, w4
	str	w1, [x3, #:lo12:.LANCHOR61]
	.loc 3 665 0
	lsr	w1, w1, 5
	add	w1, w1, 24
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1616:
	.loc 3 668 0
	adrp	x1, .LANCHOR15
	ldrh	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1618
	.loc 3 669 0
	ldrh	w6, [x2, #:lo12:.LANCHOR78]
	add	w6, w6, w1, lsr 1
	strh	w6, [x2, #:lo12:.LANCHOR78]
	.loc 3 670 0
	mul	w6, w1, w4
	cmp	w19, w6
	bge	.L1618
	.loc 3 672 0
	add	w1, w1, 32
	.loc 3 671 0
	str	w5, [x3, #:lo12:.LANCHOR61]
	.loc 3 672 0
	add	w1, w0, w1
	strh	w1, [x2, #:lo12:.LANCHOR78]
.L1618:
	.loc 3 677 0
	ldrh	w1, [x2, #:lo12:.LANCHOR78]
	adrp	x25, .LANCHOR180
	ldr	w0, [x3, #:lo12:.LANCHOR61]
	.loc 3 687 0
	adrp	x24, .LANCHOR42
.LVL2112:
	.loc 3 677 0
	sub	w0, w0, w1
	.loc 3 678 0
	adrp	x1, .LANCHOR19
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	.loc 3 677 0
	mul	w0, w0, w4
	str	w0, [x25, #:lo12:.LANCHOR180]
	.loc 3 678 0
	mul	w0, w1, w0
	.loc 3 679 0
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	.loc 3 678 0
	str	w0, [x3, #:lo12:.LANCHOR61]
	.loc 3 689 0
	mov	w23, -1
	.loc 3 679 0
	mul	w0, w1, w0
	adrp	x1, .LANCHOR34
	str	w0, [x1, #:lo12:.LANCHOR34]
	.loc 3 684 0
	bl	FtlBbmTblFlush
.LVL2113:
	.loc 3 687 0
	ldr	x0, [x24, #:lo12:.LANCHOR42]
	mov	w1, 0
	ldrh	w2, [x22, #:lo12:.LANCHOR6]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL2114:
	.loc 3 688 0
	adrp	x0, .LANCHOR59
	.loc 3 689 0
	adrp	x1, .LANCHOR80
	.loc 3 698 0
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	.loc 3 688 0
	str	wzr, [x0, #:lo12:.LANCHOR59]
	.loc 3 689 0
	add	x0, x1, :lo12:.LANCHOR80
	strh	w23, [x1, #:lo12:.LANCHOR80]
	.loc 3 698 0
	mov	w1, 255
	lsr	w2, w2, 3
	.loc 3 690 0
	strh	wzr, [x0, 2]
	.loc 3 691 0
	strb	wzr, [x0, 6]
	.loc 3 692 0
	strb	wzr, [x0, 8]
	.loc 3 694 0
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
.LVL2115:
	.loc 3 696 0
	strh	wzr, [x0, #:lo12:.LANCHOR51]
	.loc 3 697 0
	mov	w0, 1
	strb	w0, [x19, 8]
	.loc 3 698 0
	adrp	x0, .LANCHOR1
	.loc 3 694 0
	strh	wzr, [x19, 2]
	.loc 3 698 0
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	.loc 3 695 0
	strb	wzr, [x19, 6]
	.loc 3 698 0
	bl	ftl_memset
.LVL2116:
.L1620:
	.loc 3 701 0
	mov	x0, x19
	bl	make_superblock
.LVL2117:
	.loc 3 702 0
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1621
	.loc 3 705 0
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	.loc 3 706 0
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	.loc 3 707 0
	b	.L1620
.LVL2118:
.L1607:
	.loc 3 636 0 discriminator 3
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	.loc 3 635 0 discriminator 3
	add	w0, w0, 1
.LVL2119:
	and	w0, w0, 65535
.LVL2120:
	.loc 3 636 0 discriminator 3
	str	w2, [x4, x3]
	.loc 3 637 0 discriminator 3
	str	w6, [x5, x3]
	b	.L1606
.LVL2121:
.L1609:
	.loc 3 643 0 discriminator 3
	mov	w0, w25
	mov	w1, 1
	.loc 3 642 0 discriminator 3
	add	w25, w25, 1
.LVL2122:
	.loc 3 643 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2123:
	add	w19, w19, w0
.LVL2124:
	.loc 3 642 0 discriminator 3
	and	w25, w25, 65535
	.loc 3 643 0 discriminator 3
	and	w19, w19, 65535
.LVL2125:
	b	.L1608
.LVL2126:
.L1610:
	.loc 3 647 0
	udiv	w0, w19, w0
	adrp	x1, .LANCHOR31
	ldr	w19, [x1, #:lo12:.LANCHOR31]
.LVL2127:
	add	w0, w0, w19
	bl	FtlSysBlkNumInit
.LVL2128:
	.loc 3 648 0
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	.loc 3 650 0
	add	x24, x22, :lo12:.LANCHOR6
	.loc 3 648 0
	bl	FtlFreeSysBlkQueueInit
.LVL2129:
	.loc 3 650 0
	ldrh	w19, [x21, #:lo12:.LANCHOR5]
.LVL2130:
.L1612:
	.loc 3 650 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	cmp	w0, w19
	bls	.L1614
	.loc 3 651 0 is_stmt 1 discriminator 3
	mov	w0, w19
	.loc 3 650 0 discriminator 3
	add	w19, w19, 1
.LVL2131:
	.loc 3 651 0 discriminator 3
	mov	w1, 1
	.loc 3 650 0 discriminator 3
	and	w19, w19, 65535
	.loc 3 651 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2132:
	b	.L1612
.LVL2133:
.L1615:
	.loc 3 657 0 discriminator 3
	mov	w0, w24
	mov	w1, 0
	.loc 3 656 0 discriminator 3
	add	w24, w24, 1
.LVL2134:
	.loc 3 657 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2135:
	add	w19, w19, w0
.LVL2136:
	.loc 3 656 0 discriminator 3
	and	w24, w24, 65535
	.loc 3 657 0 discriminator 3
	and	w19, w19, 65535
.LVL2137:
	b	.L1611
.LVL2138:
.L1621:
	.loc 3 709 0
	ldr	w1, [x20, #:lo12:.LANCHOR70]
	.loc 3 710 0
	ubfiz	x0, x0, 1, 16
	.loc 3 709 0
	str	w1, [x19, 12]
	.loc 3 721 0
	mov	w23, -1
	.loc 3 709 0
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR70]
	.loc 3 710 0
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	.loc 3 712 0
	adrp	x2, .LANCHOR52
	add	x0, x2, :lo12:.LANCHOR52
	.loc 3 714 0
	ldrh	w1, [x19]
	.loc 3 717 0
	mov	x19, x0
	.loc 3 714 0
	add	w1, w1, 1
	.loc 3 712 0
	strh	wzr, [x0, 2]
	.loc 3 714 0
	strh	w1, [x2, #:lo12:.LANCHOR52]
	.loc 3 715 0
	mov	w1, 1
	.loc 3 713 0
	strb	wzr, [x0, 6]
	.loc 3 715 0
	strb	w1, [x0, 8]
.L1622:
	.loc 3 717 0
	mov	x0, x19
	bl	make_superblock
.LVL2139:
	.loc 3 718 0
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1623
	.loc 3 721 0
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	.loc 3 722 0
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	.loc 3 723 0
	b	.L1622
.L1623:
	.loc 3 725 0
	ldr	w1, [x20, #:lo12:.LANCHOR70]
	.loc 3 726 0
	ubfiz	x0, x0, 1, 16
	.loc 3 725 0
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR70]
	.loc 3 726 0
	ldr	x1, [x24, #:lo12:.LANCHOR42]
	ldrh	w2, [x19, 4]
	.loc 3 727 0
	mov	w19, -1
	.loc 3 726 0
	strh	w2, [x1, x0]
	.loc 3 727 0
	adrp	x0, .LANCHOR53
	strh	w19, [x0, #:lo12:.LANCHOR53]
	.loc 3 730 0
	bl	FtlFreeSysBlkQueueOut
.LVL2140:
	adrp	x2, .LANCHOR79
	add	x1, x2, :lo12:.LANCHOR79
	strh	w0, [x2, #:lo12:.LANCHOR79]
	.loc 3 733 0
	ldr	w0, [x25, #:lo12:.LANCHOR180]
	strh	w0, [x1, 6]
	.loc 3 734 0
	ldr	w0, [x20, #:lo12:.LANCHOR70]
	str	w0, [x1, 8]
	add	w0, w0, 1
	.loc 3 731 0
	strh	wzr, [x1, 2]
	.loc 3 732 0
	strh	w19, [x1, 4]
	.loc 3 734 0
	str	w0, [x20, #:lo12:.LANCHOR70]
	.loc 3 735 0
	bl	FtlVpcTblFlush
.LVL2141:
	.loc 3 736 0
	bl	FtlSysBlkInit
.LVL2142:
	cbnz	w0, .L1624
	.loc 3 737 0
	adrp	x0, .LANCHOR86
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR86]
.L1624:
	.loc 3 739 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE210:
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.sftl_init,"ax",@progbits
	.align	2
	.global	sftl_init
	.type	sftl_init, %function
sftl_init:
.LFB211:
	.loc 3 743 0
	.cfi_startproc
.LVL2143:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 3 749 0
	adrp	x1, .LC70
	add	x1, x1, :lo12:.LC70
	.loc 3 746 0
	mov	w0, -1
	.loc 3 743 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 3 746 0
	adrp	x19, .LANCHOR86
	str	w0, [x19, #:lo12:.LANCHOR86]
	.loc 3 749 0
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
.LVL2144:
	.loc 3 750 0
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	bl	FtlConstantsInit
.LVL2145:
	.loc 3 751 0
	bl	FtlMemInit
.LVL2146:
	.loc 3 752 0
	bl	FtlVariablesInit
.LVL2147:
	.loc 3 753 0
	adrp	x0, .LANCHOR4
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	bl	FtlFreeSysBlkQueueInit
.LVL2148:
.LDL2:
	.loc 3 756 0
	bl	FtlLoadBbt
.LVL2149:
	cbnz	w0, .L1633
	.loc 3 767 0
	bl	FtlSysBlkInit
.LVL2150:
	cbnz	w0, .L1633
	.loc 3 779 0
	mov	w0, 1
	str	w0, [x19, #:lo12:.LANCHOR86]
	.loc 3 783 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 15
	bhi	.L1633
	mov	w19, 8129
.L1632:
.LVL2151:
.LBB341:
	.loc 3 786 0 discriminator 3
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL2152:
	.loc 3 785 0 discriminator 3
	subs	w19, w19, #1
.LVL2153:
	bne	.L1632
.LVL2154:
.L1633:
.LBE341:
	.loc 3 794 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE211:
	.size	sftl_init, .-sftl_init
	.section	.text.ftl_memcmp,"ax",@progbits
	.align	2
	.global	ftl_memcmp
	.type	ftl_memcmp, %function
ftl_memcmp:
.LFB348:
	.loc 1 252 0
	.cfi_startproc
.LVL2155:
	.loc 1 253 0
	uxtw	x2, w2
	b	memcmp
.LVL2156:
	.cfi_endproc
.LFE348:
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
	.set	.LANCHOR180,. + 0
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
	.section	.rodata.__func__.6107,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.6107, %object
	.size	__func__.6107, 11
__func__.6107:
	.string	"FtlMemInit"
	.section	.rodata.__func__.6231,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.6231, %object
	.size	__func__.6231, 13
__func__.6231:
	.string	"FtlProgPages"
	.section	.rodata.__func__.6259,"a",@progbits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	__func__.6259, %object
	.size	__func__.6259, 9
__func__.6259:
	.string	"FtlWrite"
	.section	.rodata.__func__.6323,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.6323, %object
	.size	__func__.6323, 14
__func__.6323:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.6366,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.6366, %object
	.size	__func__.6366, 11
__func__.6366:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.6483,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.6483, %object
	.size	__func__.6483, 17
__func__.6483:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.6488,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.6488, %object
	.size	__func__.6488, 17
__func__.6488:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.6519,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.6519, %object
	.size	__func__.6519, 17
__func__.6519:
	.string	"List_remove_node"
	.section	.rodata.__func__.6551,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.6551, %object
	.size	__func__.6551, 22
__func__.6551:
	.string	"List_update_data_list"
	.section	.rodata.__func__.6560,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.6560, %object
	.size	__func__.6560, 16
__func__.6560:
	.string	"load_l2p_region"
	.section	.rodata.__func__.6593,"a",@progbits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	__func__.6593, %object
	.size	__func__.6593, 26
__func__.6593:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.6604,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.6604, %object
	.size	__func__.6604, 15
__func__.6604:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.6618,"a",@progbits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	__func__.6618, %object
	.size	__func__.6618, 31
__func__.6618:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.6632,"a",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	__func__.6632, %object
	.size	__func__.6632, 16
__func__.6632:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.6657,"a",@progbits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	__func__.6657, %object
	.size	__func__.6657, 22
__func__.6657:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.6674,"a",@progbits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	__func__.6674, %object
	.size	__func__.6674, 9
__func__.6674:
	.string	"log2phys"
	.section	.rodata.__func__.6747,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.6747, %object
	.size	__func__.6747, 15
__func__.6747:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.6769,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.6769, %object
	.size	__func__.6769, 14
__func__.6769:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.6826,"a",@progbits
	.align	3
	.set	.LANCHOR179,. + 0
	.type	__func__.6826, %object
	.size	__func__.6826, 15
__func__.6826:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.6889,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.6889, %object
	.size	__func__.6889, 16
__func__.6889:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.6923,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.6923, %object
	.size	__func__.6923, 22
__func__.6923:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.6980,"a",@progbits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	__func__.6980, %object
	.size	__func__.6980, 16
__func__.6980:
	.string	"make_superblock"
	.section	.rodata.__func__.7001,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.7001, %object
	.size	__func__.7001, 18
__func__.7001:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.7026,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.7026, %object
	.size	__func__.7026, 21
__func__.7026:
	.string	"FtlVpcCheckAndModify"
	.section	.rodata.__func__.7042,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.7042, %object
	.size	__func__.7042, 14
__func__.7042:
	.string	"ftl_check_vpc"
	.section	.rodata.__func__.7127,"a",@progbits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	__func__.7127, %object
	.size	__func__.7127, 25
__func__.7127:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.7148,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.7148, %object
	.size	__func__.7148, 29
__func__.7148:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.7155,"a",@progbits
	.align	3
	.set	.LANCHOR88,. + 0
	.type	__func__.7155, %object
	.size	__func__.7155, 19
__func__.7155:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.7168,"a",@progbits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	__func__.7168, %object
	.size	__func__.7168, 16
__func__.7168:
	.string	"update_vpc_list"
	.section	.rodata.__func__.7175,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.7175, %object
	.size	__func__.7175, 20
__func__.7175:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.7245,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.7245, %object
	.size	__func__.7245, 19
__func__.7245:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.7351,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.7351, %object
	.size	__func__.7351, 23
__func__.7351:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.7615,"a",@progbits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	__func__.7615, %object
	.size	__func__.7615, 15
__func__.7615:
	.string	"FlashReadPages"
	.section	.rodata.__func__.7632,"a",@progbits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	__func__.7632, %object
	.size	__func__.7632, 15
__func__.7632:
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
	.text
.Letext0:
	.file 7 "include/common.h"
	.file 8 "./arch/arm/include/asm/types.h"
	.file 9 "include/linux/types.h"
	.file 10 "include/errno.h"
	.file 11 "include/linux/string.h"
	.file 12 "include/efi.h"
	.file 13 "include/ide.h"
	.file 14 "include/part.h"
	.file 15 "include/flash.h"
	.file 16 "include/lmb.h"
	.file 17 "include/asm-generic/u-boot.h"
	.file 18 "./arch/arm/include/asm/u-boot-arm.h"
	.file 19 "include/../scripts/dtc/libfdt/fdt.h"
	.file 20 "include/libfdt_env.h"
	.file 21 "include/image.h"
	.file 22 "include/net.h"
	.file 23 "include/dm/uclass-id.h"
	.file 24 "drivers/rkflash/rksftl/sftl_inc.h"
	.file 25 "drivers/rkflash/rksftl/flash_com.h"
	.file 26 "drivers/rkflash/rksftl/sftl_struct.h"
	.file 27 "drivers/rkflash/rksftl/sftl_global.h"
	.file 28 "include/malloc.h"
	.file 29 "include/stdio.h"
	.file 30 "include/vsprintf.h"
	.file 31 "include/log.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0xa979
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.4byte	.LASF880
	.byte	0xc
	.4byte	.LASF881
	.4byte	.LASF882
	.4byte	.Ldebug_ranges0+0x3c0
	.8byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.4byte	.LASF1
	.uleb128 0x3
	.4byte	.LASF5
	.byte	0x7
	.byte	0xd
	.4byte	0x42
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF2
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x4
	.4byte	.LASF20
	.byte	0xa
	.byte	0xc
	.4byte	0x5b
	.uleb128 0x5
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x3
	.4byte	.LASF6
	.byte	0x8
	.byte	0xc
	.4byte	0x42
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x3
	.4byte	.LASF8
	.byte	0x8
	.byte	0x12
	.4byte	0x30
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF9
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF10
	.uleb128 0x6
	.string	"u8"
	.byte	0x8
	.byte	0x1f
	.4byte	0x42
	.uleb128 0x7
	.4byte	0x94
	.uleb128 0x6
	.string	"u16"
	.byte	0x8
	.byte	0x22
	.4byte	0x29
	.uleb128 0x6
	.string	"s32"
	.byte	0x8
	.byte	0x24
	.4byte	0x5b
	.uleb128 0x6
	.string	"u32"
	.byte	0x8
	.byte	0x25
	.4byte	0x30
	.uleb128 0x3
	.4byte	.LASF11
	.byte	0x8
	.byte	0x31
	.4byte	0x8d
	.uleb128 0x3
	.4byte	.LASF12
	.byte	0x8
	.byte	0x32
	.4byte	0x8d
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.4byte	.LASF13
	.uleb128 0x8
	.byte	0x8
	.4byte	0xee
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.4byte	.LASF14
	.uleb128 0x7
	.4byte	0xe7
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.4byte	.LASF15
	.uleb128 0x8
	.byte	0x8
	.4byte	0xe7
	.uleb128 0x3
	.4byte	.LASF16
	.byte	0x9
	.byte	0x59
	.4byte	0x29
	.uleb128 0x3
	.4byte	.LASF17
	.byte	0x9
	.byte	0x5b
	.4byte	0x49
	.uleb128 0x3
	.4byte	.LASF18
	.byte	0x9
	.byte	0x69
	.4byte	0x69
	.uleb128 0x3
	.4byte	.LASF19
	.byte	0x9
	.byte	0x97
	.4byte	0x7b
	.uleb128 0x9
	.byte	0x8
	.uleb128 0x4
	.4byte	.LASF21
	.byte	0xb
	.byte	0xb
	.4byte	0xfa
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.4byte	.LASF22
	.uleb128 0xa
	.4byte	0xe7
	.4byte	0x14b
	.uleb128 0xb
	.byte	0
	.uleb128 0xc
	.4byte	.LASF23
	.byte	0xc
	.2byte	0x140
	.4byte	0x140
	.uleb128 0xc
	.4byte	.LASF24
	.byte	0xc
	.2byte	0x143
	.4byte	0x140
	.uleb128 0xc
	.4byte	.LASF25
	.byte	0xc
	.2byte	0x143
	.4byte	0x140
	.uleb128 0x8
	.byte	0x8
	.4byte	0x175
	.uleb128 0xd
	.uleb128 0xa
	.4byte	0x10b
	.4byte	0x181
	.uleb128 0xb
	.byte	0
	.uleb128 0x4
	.4byte	.LASF26
	.byte	0xd
	.byte	0x10
	.4byte	0x176
	.uleb128 0xa
	.4byte	0x42
	.4byte	0x19c
	.uleb128 0xe
	.4byte	0xda
	.byte	0x5
	.byte	0
	.uleb128 0xf
	.4byte	.LASF29
	.byte	0x10
	.byte	0xe
	.byte	0xf
	.4byte	0x1c1
	.uleb128 0x10
	.4byte	.LASF27
	.byte	0xe
	.byte	0x10
	.4byte	0xfa
	.byte	0
	.uleb128 0x10
	.4byte	.LASF28
	.byte	0xe
	.byte	0x11
	.4byte	0x1da
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.4byte	0x19c
	.uleb128 0x11
	.4byte	0x5b
	.4byte	0x1da
	.uleb128 0x12
	.4byte	0x5b
	.uleb128 0x12
	.4byte	0x5b
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1c6
	.uleb128 0xa
	.4byte	0x1c1
	.4byte	0x1eb
	.uleb128 0xb
	.byte	0
	.uleb128 0x7
	.4byte	0x1e0
	.uleb128 0x4
	.4byte	.LASF29
	.byte	0xe
	.byte	0xcd
	.4byte	0x1eb
	.uleb128 0x13
	.2byte	0x1218
	.byte	0xf
	.byte	0x13
	.4byte	0x242
	.uleb128 0x10
	.4byte	.LASF30
	.byte	0xf
	.byte	0x14
	.4byte	0x10b
	.byte	0
	.uleb128 0x10
	.4byte	.LASF31
	.byte	0xf
	.byte	0x15
	.4byte	0x100
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF32
	.byte	0xf
	.byte	0x16
	.4byte	0x10b
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF33
	.byte	0xf
	.byte	0x17
	.4byte	0x242
	.byte	0x18
	.uleb128 0x14
	.4byte	.LASF34
	.byte	0xf
	.byte	0x18
	.4byte	0x253
	.2byte	0x1018
	.byte	0
	.uleb128 0xa
	.4byte	0x10b
	.4byte	0x253
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x1ff
	.byte	0
	.uleb128 0xa
	.4byte	0x37
	.4byte	0x264
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x1ff
	.byte	0
	.uleb128 0x3
	.4byte	.LASF35
	.byte	0xf
	.byte	0x32
	.4byte	0x1fb
	.uleb128 0xa
	.4byte	0x264
	.4byte	0x27a
	.uleb128 0xb
	.byte	0
	.uleb128 0x4
	.4byte	.LASF36
	.byte	0xf
	.byte	0x34
	.4byte	0x26f
	.uleb128 0x2
	.byte	0x10
	.byte	0x4
	.4byte	.LASF37
	.uleb128 0xf
	.4byte	.LASF38
	.byte	0x10
	.byte	0x10
	.byte	0x10
	.4byte	0x2b1
	.uleb128 0x10
	.4byte	.LASF39
	.byte	0x10
	.byte	0x11
	.4byte	0xc4
	.byte	0
	.uleb128 0x10
	.4byte	.LASF30
	.byte	0x10
	.byte	0x12
	.4byte	0xcf
	.byte	0x8
	.byte	0
	.uleb128 0xf
	.4byte	.LASF40
	.byte	0xa0
	.byte	0x10
	.byte	0x15
	.4byte	0x2e2
	.uleb128 0x16
	.string	"cnt"
	.byte	0x10
	.byte	0x16
	.4byte	0x49
	.byte	0
	.uleb128 0x10
	.4byte	.LASF30
	.byte	0x10
	.byte	0x17
	.4byte	0xcf
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF41
	.byte	0x10
	.byte	0x18
	.4byte	0x2e2
	.byte	0x10
	.byte	0
	.uleb128 0xa
	.4byte	0x28c
	.4byte	0x2f2
	.uleb128 0xe
	.4byte	0xda
	.byte	0x8
	.byte	0
	.uleb128 0x17
	.string	"lmb"
	.2byte	0x140
	.byte	0x10
	.byte	0x1b
	.4byte	0x318
	.uleb128 0x10
	.4byte	.LASF42
	.byte	0x10
	.byte	0x1c
	.4byte	0x2b1
	.byte	0
	.uleb128 0x10
	.4byte	.LASF43
	.byte	0x10
	.byte	0x1d
	.4byte	0x2b1
	.byte	0xa0
	.byte	0
	.uleb128 0x18
	.string	"lmb"
	.byte	0x10
	.byte	0x20
	.4byte	0x2f2
	.uleb128 0x19
	.byte	0x10
	.byte	0x11
	.byte	0x5a
	.4byte	0x344
	.uleb128 0x10
	.4byte	.LASF33
	.byte	0x11
	.byte	0x5b
	.4byte	0xc4
	.byte	0
	.uleb128 0x10
	.4byte	.LASF30
	.byte	0x11
	.byte	0x5c
	.4byte	0xcf
	.byte	0x8
	.byte	0
	.uleb128 0xf
	.4byte	.LASF44
	.byte	0xa8
	.byte	0x11
	.byte	0x1b
	.4byte	0x435
	.uleb128 0x10
	.4byte	.LASF45
	.byte	0x11
	.byte	0x1c
	.4byte	0x49
	.byte	0
	.uleb128 0x10
	.4byte	.LASF46
	.byte	0x11
	.byte	0x1d
	.4byte	0xcf
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF47
	.byte	0x11
	.byte	0x1e
	.4byte	0x49
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF48
	.byte	0x11
	.byte	0x1f
	.4byte	0x49
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF49
	.byte	0x11
	.byte	0x20
	.4byte	0x49
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF50
	.byte	0x11
	.byte	0x21
	.4byte	0x49
	.byte	0x28
	.uleb128 0x10
	.4byte	.LASF51
	.byte	0x11
	.byte	0x22
	.4byte	0x49
	.byte	0x30
	.uleb128 0x10
	.4byte	.LASF52
	.byte	0x11
	.byte	0x24
	.4byte	0x49
	.byte	0x38
	.uleb128 0x10
	.4byte	.LASF53
	.byte	0x11
	.byte	0x25
	.4byte	0x49
	.byte	0x40
	.uleb128 0x10
	.4byte	.LASF54
	.byte	0x11
	.byte	0x26
	.4byte	0x49
	.byte	0x48
	.uleb128 0x10
	.4byte	.LASF55
	.byte	0x11
	.byte	0x31
	.4byte	0x49
	.byte	0x50
	.uleb128 0x10
	.4byte	.LASF56
	.byte	0x11
	.byte	0x32
	.4byte	0x49
	.byte	0x58
	.uleb128 0x10
	.4byte	.LASF57
	.byte	0x11
	.byte	0x33
	.4byte	0x18c
	.byte	0x60
	.uleb128 0x10
	.4byte	.LASF58
	.byte	0x11
	.byte	0x34
	.4byte	0x29
	.byte	0x66
	.uleb128 0x10
	.4byte	.LASF59
	.byte	0x11
	.byte	0x35
	.4byte	0x49
	.byte	0x68
	.uleb128 0x10
	.4byte	.LASF60
	.byte	0x11
	.byte	0x36
	.4byte	0x49
	.byte	0x70
	.uleb128 0x10
	.4byte	.LASF61
	.byte	0x11
	.byte	0x57
	.4byte	0x10b
	.byte	0x78
	.uleb128 0x10
	.4byte	.LASF62
	.byte	0x11
	.byte	0x58
	.4byte	0x10b
	.byte	0x80
	.uleb128 0x10
	.4byte	.LASF63
	.byte	0x11
	.byte	0x5d
	.4byte	0x435
	.byte	0x88
	.byte	0
	.uleb128 0xa
	.4byte	0x323
	.4byte	0x445
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1
	.byte	0
	.uleb128 0x3
	.4byte	.LASF64
	.byte	0x11
	.byte	0x5f
	.4byte	0x344
	.uleb128 0x4
	.4byte	.LASF65
	.byte	0x12
	.byte	0x13
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF66
	.byte	0x12
	.byte	0x14
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF67
	.byte	0x12
	.byte	0x15
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF68
	.byte	0x12
	.byte	0x16
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF69
	.byte	0x12
	.byte	0x17
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF70
	.byte	0x12
	.byte	0x18
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF71
	.byte	0x12
	.byte	0x19
	.4byte	0x10b
	.uleb128 0xf
	.4byte	.LASF72
	.byte	0x28
	.byte	0x13
	.byte	0x39
	.4byte	0x522
	.uleb128 0x10
	.4byte	.LASF73
	.byte	0x13
	.byte	0x3a
	.4byte	0x533
	.byte	0
	.uleb128 0x10
	.4byte	.LASF74
	.byte	0x13
	.byte	0x3b
	.4byte	0x533
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF75
	.byte	0x13
	.byte	0x3c
	.4byte	0x533
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF76
	.byte	0x13
	.byte	0x3d
	.4byte	0x533
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF77
	.byte	0x13
	.byte	0x3e
	.4byte	0x533
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x13
	.byte	0x3f
	.4byte	0x533
	.byte	0x14
	.uleb128 0x10
	.4byte	.LASF79
	.byte	0x13
	.byte	0x40
	.4byte	0x533
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF80
	.byte	0x13
	.byte	0x43
	.4byte	0x533
	.byte	0x1c
	.uleb128 0x10
	.4byte	.LASF81
	.byte	0x13
	.byte	0x46
	.4byte	0x533
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF82
	.byte	0x13
	.byte	0x49
	.4byte	0x533
	.byte	0x24
	.byte	0
	.uleb128 0x4
	.4byte	.LASF83
	.byte	0x14
	.byte	0xf
	.4byte	0x52d
	.uleb128 0x8
	.byte	0x8
	.4byte	0x49d
	.uleb128 0x3
	.4byte	.LASF84
	.byte	0x14
	.byte	0x12
	.4byte	0x121
	.uleb128 0x1a
	.4byte	.LASF85
	.byte	0x40
	.byte	0x15
	.2byte	0x133
	.4byte	0x5e8
	.uleb128 0x1b
	.4byte	.LASF86
	.byte	0x15
	.2byte	0x134
	.4byte	0x121
	.byte	0
	.uleb128 0x1b
	.4byte	.LASF87
	.byte	0x15
	.2byte	0x135
	.4byte	0x121
	.byte	0x4
	.uleb128 0x1b
	.4byte	.LASF88
	.byte	0x15
	.2byte	0x136
	.4byte	0x121
	.byte	0x8
	.uleb128 0x1b
	.4byte	.LASF89
	.byte	0x15
	.2byte	0x137
	.4byte	0x121
	.byte	0xc
	.uleb128 0x1b
	.4byte	.LASF90
	.byte	0x15
	.2byte	0x138
	.4byte	0x121
	.byte	0x10
	.uleb128 0x1b
	.4byte	.LASF91
	.byte	0x15
	.2byte	0x139
	.4byte	0x121
	.byte	0x14
	.uleb128 0x1b
	.4byte	.LASF92
	.byte	0x15
	.2byte	0x13a
	.4byte	0x121
	.byte	0x18
	.uleb128 0x1b
	.4byte	.LASF93
	.byte	0x15
	.2byte	0x13b
	.4byte	0x116
	.byte	0x1c
	.uleb128 0x1b
	.4byte	.LASF94
	.byte	0x15
	.2byte	0x13c
	.4byte	0x116
	.byte	0x1d
	.uleb128 0x1b
	.4byte	.LASF95
	.byte	0x15
	.2byte	0x13d
	.4byte	0x116
	.byte	0x1e
	.uleb128 0x1b
	.4byte	.LASF96
	.byte	0x15
	.2byte	0x13e
	.4byte	0x116
	.byte	0x1f
	.uleb128 0x1b
	.4byte	.LASF97
	.byte	0x15
	.2byte	0x13f
	.4byte	0x5e8
	.byte	0x20
	.byte	0
	.uleb128 0xa
	.4byte	0x116
	.4byte	0x5f8
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x1c
	.4byte	.LASF98
	.byte	0x15
	.2byte	0x140
	.4byte	0x53e
	.uleb128 0x1a
	.4byte	.LASF99
	.byte	0x30
	.byte	0x15
	.2byte	0x142
	.4byte	0x686
	.uleb128 0x1b
	.4byte	.LASF33
	.byte	0x15
	.2byte	0x143
	.4byte	0x10b
	.byte	0
	.uleb128 0x1d
	.string	"end"
	.byte	0x15
	.2byte	0x143
	.4byte	0x10b
	.byte	0x8
	.uleb128 0x1b
	.4byte	.LASF100
	.byte	0x15
	.2byte	0x144
	.4byte	0x10b
	.byte	0x10
	.uleb128 0x1b
	.4byte	.LASF101
	.byte	0x15
	.2byte	0x144
	.4byte	0x10b
	.byte	0x18
	.uleb128 0x1b
	.4byte	.LASF102
	.byte	0x15
	.2byte	0x145
	.4byte	0x10b
	.byte	0x20
	.uleb128 0x1b
	.4byte	.LASF103
	.byte	0x15
	.2byte	0x146
	.4byte	0x116
	.byte	0x28
	.uleb128 0x1b
	.4byte	.LASF104
	.byte	0x15
	.2byte	0x146
	.4byte	0x116
	.byte	0x29
	.uleb128 0x1d
	.string	"os"
	.byte	0x15
	.2byte	0x146
	.4byte	0x116
	.byte	0x2a
	.uleb128 0x1b
	.4byte	.LASF105
	.byte	0x15
	.2byte	0x147
	.4byte	0x116
	.byte	0x2b
	.byte	0
	.uleb128 0x1c
	.4byte	.LASF106
	.byte	0x15
	.2byte	0x148
	.4byte	0x604
	.uleb128 0x1e
	.4byte	.LASF107
	.2byte	0x280
	.byte	0x15
	.2byte	0x14e
	.4byte	0x82f
	.uleb128 0x1b
	.4byte	.LASF108
	.byte	0x15
	.2byte	0x154
	.4byte	0x82f
	.byte	0
	.uleb128 0x1b
	.4byte	.LASF109
	.byte	0x15
	.2byte	0x155
	.4byte	0x5f8
	.byte	0x8
	.uleb128 0x1b
	.4byte	.LASF110
	.byte	0x15
	.2byte	0x156
	.4byte	0x10b
	.byte	0x48
	.uleb128 0x1b
	.4byte	.LASF111
	.byte	0x15
	.2byte	0x159
	.4byte	0xe1
	.byte	0x50
	.uleb128 0x1b
	.4byte	.LASF112
	.byte	0x15
	.2byte	0x15b
	.4byte	0x12c
	.byte	0x58
	.uleb128 0x1b
	.4byte	.LASF113
	.byte	0x15
	.2byte	0x15c
	.4byte	0xe1
	.byte	0x60
	.uleb128 0x1b
	.4byte	.LASF114
	.byte	0x15
	.2byte	0x15d
	.4byte	0x5b
	.byte	0x68
	.uleb128 0x1b
	.4byte	.LASF115
	.byte	0x15
	.2byte	0x15f
	.4byte	0x12c
	.byte	0x70
	.uleb128 0x1b
	.4byte	.LASF116
	.byte	0x15
	.2byte	0x160
	.4byte	0xe1
	.byte	0x78
	.uleb128 0x1b
	.4byte	.LASF117
	.byte	0x15
	.2byte	0x161
	.4byte	0x5b
	.byte	0x80
	.uleb128 0x1b
	.4byte	.LASF118
	.byte	0x15
	.2byte	0x163
	.4byte	0x12c
	.byte	0x88
	.uleb128 0x1b
	.4byte	.LASF119
	.byte	0x15
	.2byte	0x164
	.4byte	0xe1
	.byte	0x90
	.uleb128 0x1b
	.4byte	.LASF120
	.byte	0x15
	.2byte	0x165
	.4byte	0x5b
	.byte	0x98
	.uleb128 0x1b
	.4byte	.LASF121
	.byte	0x15
	.2byte	0x167
	.4byte	0x12c
	.byte	0xa0
	.uleb128 0x1b
	.4byte	.LASF122
	.byte	0x15
	.2byte	0x168
	.4byte	0xe1
	.byte	0xa8
	.uleb128 0x1b
	.4byte	.LASF123
	.byte	0x15
	.2byte	0x169
	.4byte	0x5b
	.byte	0xb0
	.uleb128 0x1d
	.string	"os"
	.byte	0x15
	.2byte	0x16d
	.4byte	0x686
	.byte	0xb8
	.uleb128 0x1d
	.string	"ep"
	.byte	0x15
	.2byte	0x16e
	.4byte	0x10b
	.byte	0xe8
	.uleb128 0x1b
	.4byte	.LASF124
	.byte	0x15
	.2byte	0x170
	.4byte	0x10b
	.byte	0xf0
	.uleb128 0x1b
	.4byte	.LASF125
	.byte	0x15
	.2byte	0x170
	.4byte	0x10b
	.byte	0xf8
	.uleb128 0x1f
	.4byte	.LASF126
	.byte	0x15
	.2byte	0x172
	.4byte	0xfa
	.2byte	0x100
	.uleb128 0x1f
	.4byte	.LASF127
	.byte	0x15
	.2byte	0x173
	.4byte	0x10b
	.2byte	0x108
	.uleb128 0x1f
	.4byte	.LASF128
	.byte	0x15
	.2byte	0x175
	.4byte	0x10b
	.2byte	0x110
	.uleb128 0x1f
	.4byte	.LASF129
	.byte	0x15
	.2byte	0x176
	.4byte	0x10b
	.2byte	0x118
	.uleb128 0x1f
	.4byte	.LASF130
	.byte	0x15
	.2byte	0x177
	.4byte	0x10b
	.2byte	0x120
	.uleb128 0x1f
	.4byte	.LASF131
	.byte	0x15
	.2byte	0x178
	.4byte	0x10b
	.2byte	0x128
	.uleb128 0x20
	.string	"kbd"
	.byte	0x15
	.2byte	0x179
	.4byte	0x835
	.2byte	0x130
	.uleb128 0x1f
	.4byte	.LASF132
	.byte	0x15
	.2byte	0x17c
	.4byte	0x5b
	.2byte	0x138
	.uleb128 0x1f
	.4byte	.LASF133
	.byte	0x15
	.2byte	0x189
	.4byte	0x5b
	.2byte	0x13c
	.uleb128 0x20
	.string	"lmb"
	.byte	0x15
	.2byte	0x18c
	.4byte	0x2f2
	.2byte	0x140
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x5f8
	.uleb128 0x8
	.byte	0x8
	.4byte	0x445
	.uleb128 0x1c
	.4byte	.LASF134
	.byte	0x15
	.2byte	0x18e
	.4byte	0x692
	.uleb128 0xc
	.4byte	.LASF135
	.byte	0x15
	.2byte	0x190
	.4byte	0x83b
	.uleb128 0x21
	.4byte	.LASF263
	.byte	0x4
	.4byte	0x5b
	.byte	0x17
	.byte	0xe
	.4byte	0xa50
	.uleb128 0x22
	.4byte	.LASF136
	.byte	0
	.uleb128 0x22
	.4byte	.LASF137
	.byte	0x1
	.uleb128 0x22
	.4byte	.LASF138
	.byte	0x2
	.uleb128 0x22
	.4byte	.LASF139
	.byte	0x3
	.uleb128 0x22
	.4byte	.LASF140
	.byte	0x4
	.uleb128 0x22
	.4byte	.LASF141
	.byte	0x5
	.uleb128 0x22
	.4byte	.LASF142
	.byte	0x6
	.uleb128 0x22
	.4byte	.LASF143
	.byte	0x7
	.uleb128 0x22
	.4byte	.LASF144
	.byte	0x8
	.uleb128 0x22
	.4byte	.LASF145
	.byte	0x9
	.uleb128 0x22
	.4byte	.LASF146
	.byte	0xa
	.uleb128 0x22
	.4byte	.LASF147
	.byte	0xb
	.uleb128 0x22
	.4byte	.LASF148
	.byte	0xc
	.uleb128 0x22
	.4byte	.LASF149
	.byte	0xd
	.uleb128 0x22
	.4byte	.LASF150
	.byte	0xe
	.uleb128 0x22
	.4byte	.LASF151
	.byte	0xf
	.uleb128 0x22
	.4byte	.LASF152
	.byte	0x10
	.uleb128 0x22
	.4byte	.LASF153
	.byte	0x11
	.uleb128 0x22
	.4byte	.LASF154
	.byte	0x12
	.uleb128 0x22
	.4byte	.LASF155
	.byte	0x13
	.uleb128 0x22
	.4byte	.LASF156
	.byte	0x14
	.uleb128 0x22
	.4byte	.LASF157
	.byte	0x15
	.uleb128 0x22
	.4byte	.LASF158
	.byte	0x16
	.uleb128 0x22
	.4byte	.LASF159
	.byte	0x17
	.uleb128 0x22
	.4byte	.LASF160
	.byte	0x18
	.uleb128 0x22
	.4byte	.LASF161
	.byte	0x19
	.uleb128 0x22
	.4byte	.LASF162
	.byte	0x1a
	.uleb128 0x22
	.4byte	.LASF163
	.byte	0x1b
	.uleb128 0x22
	.4byte	.LASF164
	.byte	0x1c
	.uleb128 0x22
	.4byte	.LASF165
	.byte	0x1d
	.uleb128 0x22
	.4byte	.LASF166
	.byte	0x1e
	.uleb128 0x22
	.4byte	.LASF167
	.byte	0x1f
	.uleb128 0x22
	.4byte	.LASF168
	.byte	0x20
	.uleb128 0x22
	.4byte	.LASF169
	.byte	0x21
	.uleb128 0x22
	.4byte	.LASF170
	.byte	0x22
	.uleb128 0x22
	.4byte	.LASF171
	.byte	0x23
	.uleb128 0x22
	.4byte	.LASF172
	.byte	0x24
	.uleb128 0x22
	.4byte	.LASF173
	.byte	0x25
	.uleb128 0x22
	.4byte	.LASF174
	.byte	0x26
	.uleb128 0x22
	.4byte	.LASF175
	.byte	0x27
	.uleb128 0x22
	.4byte	.LASF176
	.byte	0x28
	.uleb128 0x22
	.4byte	.LASF177
	.byte	0x29
	.uleb128 0x22
	.4byte	.LASF178
	.byte	0x2a
	.uleb128 0x22
	.4byte	.LASF179
	.byte	0x2b
	.uleb128 0x22
	.4byte	.LASF180
	.byte	0x2c
	.uleb128 0x22
	.4byte	.LASF181
	.byte	0x2d
	.uleb128 0x22
	.4byte	.LASF182
	.byte	0x2e
	.uleb128 0x22
	.4byte	.LASF183
	.byte	0x2f
	.uleb128 0x22
	.4byte	.LASF184
	.byte	0x30
	.uleb128 0x22
	.4byte	.LASF185
	.byte	0x31
	.uleb128 0x22
	.4byte	.LASF186
	.byte	0x32
	.uleb128 0x22
	.4byte	.LASF187
	.byte	0x33
	.uleb128 0x22
	.4byte	.LASF188
	.byte	0x34
	.uleb128 0x22
	.4byte	.LASF189
	.byte	0x35
	.uleb128 0x22
	.4byte	.LASF190
	.byte	0x36
	.uleb128 0x22
	.4byte	.LASF191
	.byte	0x37
	.uleb128 0x22
	.4byte	.LASF192
	.byte	0x38
	.uleb128 0x22
	.4byte	.LASF193
	.byte	0x39
	.uleb128 0x22
	.4byte	.LASF194
	.byte	0x3a
	.uleb128 0x22
	.4byte	.LASF195
	.byte	0x3b
	.uleb128 0x22
	.4byte	.LASF196
	.byte	0x3c
	.uleb128 0x22
	.4byte	.LASF197
	.byte	0x3d
	.uleb128 0x22
	.4byte	.LASF198
	.byte	0x3e
	.uleb128 0x22
	.4byte	.LASF199
	.byte	0x3f
	.uleb128 0x22
	.4byte	.LASF200
	.byte	0x40
	.uleb128 0x22
	.4byte	.LASF201
	.byte	0x41
	.uleb128 0x22
	.4byte	.LASF202
	.byte	0x42
	.uleb128 0x22
	.4byte	.LASF203
	.byte	0x43
	.uleb128 0x22
	.4byte	.LASF204
	.byte	0x44
	.uleb128 0x22
	.4byte	.LASF205
	.byte	0x45
	.uleb128 0x22
	.4byte	.LASF206
	.byte	0x46
	.uleb128 0x22
	.4byte	.LASF207
	.byte	0x47
	.uleb128 0x22
	.4byte	.LASF208
	.byte	0x48
	.uleb128 0x22
	.4byte	.LASF209
	.byte	0x49
	.uleb128 0x22
	.4byte	.LASF210
	.byte	0x4a
	.uleb128 0x22
	.4byte	.LASF211
	.byte	0x4b
	.uleb128 0x22
	.4byte	.LASF212
	.byte	0x4c
	.uleb128 0x22
	.4byte	.LASF213
	.byte	0x4d
	.uleb128 0x22
	.4byte	.LASF214
	.byte	0x4e
	.uleb128 0x22
	.4byte	.LASF215
	.byte	0x4f
	.uleb128 0x22
	.4byte	.LASF216
	.byte	0x50
	.uleb128 0x23
	.4byte	.LASF217
	.sleb128 -1
	.byte	0
	.uleb128 0x24
	.byte	0x4
	.4byte	0x30
	.byte	0x1f
	.byte	0xe0
	.4byte	0xa63
	.uleb128 0x22
	.4byte	.LASF218
	.byte	0x5
	.byte	0
	.uleb128 0xa
	.4byte	0xe7
	.4byte	0xa73
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x4
	.4byte	.LASF219
	.byte	0x7
	.byte	0xa6
	.4byte	0x10b
	.uleb128 0xa
	.4byte	0x94
	.4byte	0xa89
	.uleb128 0xb
	.byte	0
	.uleb128 0x4
	.4byte	.LASF220
	.byte	0x7
	.byte	0xa8
	.4byte	0xa7e
	.uleb128 0x4
	.4byte	.LASF221
	.byte	0x7
	.byte	0xa9
	.4byte	0xa7e
	.uleb128 0x4
	.4byte	.LASF222
	.byte	0x7
	.byte	0xf7
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF223
	.byte	0x7
	.byte	0xf8
	.4byte	0x10b
	.uleb128 0x4
	.4byte	.LASF224
	.byte	0x7
	.byte	0xf9
	.4byte	0x10b
	.uleb128 0xf
	.4byte	.LASF225
	.byte	0x4
	.byte	0x16
	.byte	0x2e
	.4byte	0xad9
	.uleb128 0x10
	.4byte	.LASF226
	.byte	0x16
	.byte	0x2f
	.4byte	0x121
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x37
	.uleb128 0xf
	.4byte	.LASF227
	.byte	0x68
	.byte	0x16
	.byte	0xa6
	.4byte	0xb7c
	.uleb128 0x10
	.4byte	.LASF27
	.byte	0x16
	.byte	0xa8
	.4byte	0xb7c
	.byte	0
	.uleb128 0x10
	.4byte	.LASF228
	.byte	0x16
	.byte	0xa9
	.4byte	0x18c
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF229
	.byte	0x16
	.byte	0xaa
	.4byte	0xc4
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF133
	.byte	0x16
	.byte	0xab
	.4byte	0x5b
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF230
	.byte	0x16
	.byte	0xad
	.4byte	0xba6
	.byte	0x28
	.uleb128 0x10
	.4byte	.LASF231
	.byte	0x16
	.byte	0xae
	.4byte	0xbc5
	.byte	0x30
	.uleb128 0x10
	.4byte	.LASF232
	.byte	0x16
	.byte	0xaf
	.4byte	0xbda
	.byte	0x38
	.uleb128 0x10
	.4byte	.LASF233
	.byte	0x16
	.byte	0xb0
	.4byte	0xbeb
	.byte	0x40
	.uleb128 0x10
	.4byte	.LASF234
	.byte	0x16
	.byte	0xb4
	.4byte	0xbda
	.byte	0x48
	.uleb128 0x10
	.4byte	.LASF235
	.byte	0x16
	.byte	0xb5
	.4byte	0xba0
	.byte	0x50
	.uleb128 0x10
	.4byte	.LASF236
	.byte	0x16
	.byte	0xb6
	.4byte	0x5b
	.byte	0x58
	.uleb128 0x10
	.4byte	.LASF237
	.byte	0x16
	.byte	0xb7
	.4byte	0x12c
	.byte	0x60
	.byte	0
	.uleb128 0xa
	.4byte	0xe7
	.4byte	0xb8c
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x11
	.4byte	0x5b
	.4byte	0xba0
	.uleb128 0x12
	.4byte	0xba0
	.uleb128 0x12
	.4byte	0x835
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xadf
	.uleb128 0x8
	.byte	0x8
	.4byte	0xb8c
	.uleb128 0x11
	.4byte	0x5b
	.4byte	0xbc5
	.uleb128 0x12
	.4byte	0xba0
	.uleb128 0x12
	.4byte	0x12c
	.uleb128 0x12
	.4byte	0x5b
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xbac
	.uleb128 0x11
	.4byte	0x5b
	.4byte	0xbda
	.uleb128 0x12
	.4byte	0xba0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xbcb
	.uleb128 0x25
	.4byte	0xbeb
	.uleb128 0x12
	.4byte	0xba0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xbe0
	.uleb128 0x4
	.4byte	.LASF238
	.byte	0x16
	.byte	0xbd
	.4byte	0xba0
	.uleb128 0x25
	.4byte	0xc0c
	.uleb128 0x12
	.4byte	0x12c
	.uleb128 0x12
	.4byte	0x5b
	.byte	0
	.uleb128 0xc
	.4byte	.LASF239
	.byte	0x16
	.2byte	0x11e
	.4byte	0xc18
	.uleb128 0x8
	.byte	0x8
	.4byte	0xbfc
	.uleb128 0xa
	.4byte	0x94
	.4byte	0xc2e
	.uleb128 0xe
	.4byte	0xda
	.byte	0x5
	.byte	0
	.uleb128 0xc
	.4byte	.LASF240
	.byte	0x16
	.2byte	0x1fd
	.4byte	0xac0
	.uleb128 0xc
	.4byte	.LASF241
	.byte	0x16
	.2byte	0x1fe
	.4byte	0xac0
	.uleb128 0xc
	.4byte	.LASF242
	.byte	0x16
	.2byte	0x200
	.4byte	0xac0
	.uleb128 0xc
	.4byte	.LASF243
	.byte	0x16
	.2byte	0x205
	.4byte	0xa63
	.uleb128 0xc
	.4byte	.LASF244
	.byte	0x16
	.2byte	0x206
	.4byte	0xa63
	.uleb128 0xa
	.4byte	0xe7
	.4byte	0xc7a
	.uleb128 0xe
	.4byte	0xda
	.byte	0x3f
	.byte	0
	.uleb128 0xc
	.4byte	.LASF245
	.byte	0x16
	.2byte	0x207
	.4byte	0xc6a
	.uleb128 0xc
	.4byte	.LASF246
	.byte	0x16
	.2byte	0x209
	.4byte	0xc1e
	.uleb128 0xc
	.4byte	.LASF247
	.byte	0x16
	.2byte	0x20a
	.4byte	0xc1e
	.uleb128 0xc
	.4byte	.LASF248
	.byte	0x16
	.2byte	0x20b
	.4byte	0xac0
	.uleb128 0xc
	.4byte	.LASF249
	.byte	0x16
	.2byte	0x20c
	.4byte	0xac0
	.uleb128 0xc
	.4byte	.LASF250
	.byte	0x16
	.2byte	0x20d
	.4byte	0xad9
	.uleb128 0xa
	.4byte	0xad9
	.4byte	0xcd2
	.uleb128 0xe
	.4byte	0xda
	.byte	0x3
	.byte	0
	.uleb128 0xc
	.4byte	.LASF251
	.byte	0x16
	.2byte	0x20e
	.4byte	0xcc2
	.uleb128 0xc
	.4byte	.LASF252
	.byte	0x16
	.2byte	0x20f
	.4byte	0xad9
	.uleb128 0xc
	.4byte	.LASF253
	.byte	0x16
	.2byte	0x210
	.4byte	0x5b
	.uleb128 0xa
	.4byte	0x9e
	.4byte	0xd06
	.uleb128 0xe
	.4byte	0xda
	.byte	0x5
	.byte	0
	.uleb128 0x7
	.4byte	0xcf6
	.uleb128 0xc
	.4byte	.LASF254
	.byte	0x16
	.2byte	0x211
	.4byte	0xd06
	.uleb128 0xc
	.4byte	.LASF255
	.byte	0x16
	.2byte	0x212
	.4byte	0xd06
	.uleb128 0xc
	.4byte	.LASF256
	.byte	0x16
	.2byte	0x216
	.4byte	0x100
	.uleb128 0xc
	.4byte	.LASF257
	.byte	0x16
	.2byte	0x217
	.4byte	0x100
	.uleb128 0xc
	.4byte	.LASF258
	.byte	0x16
	.2byte	0x219
	.4byte	0x5b
	.uleb128 0xa
	.4byte	0xe7
	.4byte	0xd58
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x3ff
	.byte	0
	.uleb128 0xc
	.4byte	.LASF259
	.byte	0x16
	.2byte	0x220
	.4byte	0xd47
	.uleb128 0xc
	.4byte	.LASF260
	.byte	0x16
	.2byte	0x222
	.4byte	0xb9
	.uleb128 0xc
	.4byte	.LASF261
	.byte	0x16
	.2byte	0x224
	.4byte	0xb9
	.uleb128 0xc
	.4byte	.LASF262
	.byte	0x16
	.2byte	0x230
	.4byte	0xac0
	.uleb128 0x26
	.4byte	.LASF264
	.byte	0x4
	.4byte	0x30
	.byte	0x16
	.2byte	0x286
	.4byte	0xdb2
	.uleb128 0x22
	.4byte	.LASF265
	.byte	0
	.uleb128 0x22
	.4byte	.LASF266
	.byte	0x1
	.uleb128 0x22
	.4byte	.LASF267
	.byte	0x2
	.uleb128 0x22
	.4byte	.LASF268
	.byte	0x3
	.byte	0
	.uleb128 0xc
	.4byte	.LASF269
	.byte	0x16
	.2byte	0x28c
	.4byte	0xd88
	.uleb128 0x3
	.4byte	.LASF270
	.byte	0x18
	.byte	0x9
	.4byte	0x42
	.uleb128 0x3
	.4byte	.LASF271
	.byte	0x18
	.byte	0xa
	.4byte	0x29
	.uleb128 0x3
	.4byte	.LASF272
	.byte	0x18
	.byte	0xb
	.4byte	0x30
	.uleb128 0x3
	.4byte	.LASF273
	.byte	0x18
	.byte	0xc
	.4byte	0x5b
	.uleb128 0x3
	.4byte	.LASF274
	.byte	0x18
	.byte	0xd
	.4byte	0x74
	.uleb128 0xf
	.4byte	.LASF275
	.byte	0x20
	.byte	0x19
	.byte	0x24
	.4byte	0xe3e
	.uleb128 0x10
	.4byte	.LASF276
	.byte	0x19
	.byte	0x25
	.4byte	0xb9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF277
	.byte	0x19
	.byte	0x26
	.4byte	0xb9
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF278
	.byte	0x19
	.byte	0x27
	.4byte	0xe3e
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF279
	.byte	0x19
	.byte	0x28
	.4byte	0xe3e
	.byte	0x10
	.uleb128 0x16
	.string	"lpa"
	.byte	0x19
	.byte	0x29
	.4byte	0xb9
	.byte	0x18
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xb9
	.uleb128 0xf
	.4byte	.LASF280
	.byte	0x18
	.byte	0x19
	.byte	0x2c
	.4byte	0xee1
	.uleb128 0x10
	.4byte	.LASF281
	.byte	0x19
	.byte	0x2d
	.4byte	0xa3
	.byte	0
	.uleb128 0x10
	.4byte	.LASF282
	.byte	0x19
	.byte	0x2e
	.4byte	0xa3
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF283
	.byte	0x19
	.byte	0x2f
	.4byte	0xa3
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF284
	.byte	0x19
	.byte	0x30
	.4byte	0xa3
	.byte	0x6
	.uleb128 0x10
	.4byte	.LASF285
	.byte	0x19
	.byte	0x31
	.4byte	0xa3
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF286
	.byte	0x19
	.byte	0x32
	.4byte	0xa3
	.byte	0xa
	.uleb128 0x10
	.4byte	.LASF287
	.byte	0x19
	.byte	0x33
	.4byte	0xa3
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF288
	.byte	0x19
	.byte	0x34
	.4byte	0xa3
	.byte	0xe
	.uleb128 0x10
	.4byte	.LASF289
	.byte	0x19
	.byte	0x35
	.4byte	0xa3
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF290
	.byte	0x19
	.byte	0x36
	.4byte	0xa3
	.byte	0x12
	.uleb128 0x10
	.4byte	.LASF291
	.byte	0x19
	.byte	0x37
	.4byte	0xa3
	.byte	0x14
	.uleb128 0x10
	.4byte	.LASF292
	.byte	0x19
	.byte	0x38
	.4byte	0x94
	.byte	0x16
	.byte	0
	.uleb128 0x7
	.4byte	0xe44
	.uleb128 0xf
	.4byte	.LASF293
	.byte	0x20
	.byte	0x19
	.byte	0x3b
	.4byte	0xf23
	.uleb128 0x10
	.4byte	.LASF294
	.byte	0x19
	.byte	0x3c
	.4byte	0xf3d
	.byte	0
	.uleb128 0x10
	.4byte	.LASF295
	.byte	0x19
	.byte	0x3d
	.4byte	0xf57
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF296
	.byte	0x19
	.byte	0x3e
	.4byte	0xf7b
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF297
	.byte	0x19
	.byte	0x3f
	.4byte	0xf7b
	.byte	0x18
	.byte	0
	.uleb128 0x11
	.4byte	0xae
	.4byte	0xf37
	.uleb128 0x12
	.4byte	0xf37
	.uleb128 0x12
	.4byte	0xb9
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xa3
	.uleb128 0x8
	.byte	0x8
	.4byte	0xf23
	.uleb128 0x11
	.4byte	0xb9
	.4byte	0xf57
	.uleb128 0x12
	.4byte	0x94
	.uleb128 0x12
	.4byte	0xb9
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xf43
	.uleb128 0x11
	.4byte	0xb9
	.4byte	0xf7b
	.uleb128 0x12
	.4byte	0x94
	.uleb128 0x12
	.4byte	0xb9
	.uleb128 0x12
	.4byte	0xe3e
	.uleb128 0x12
	.4byte	0xe3e
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xf5d
	.uleb128 0xf
	.4byte	.LASF298
	.byte	0x60
	.byte	0x1a
	.byte	0x2b
	.4byte	0xfe1
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x2d
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF299
	.byte	0x1a
	.byte	0x2e
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF300
	.byte	0x1a
	.byte	0x2f
	.4byte	0xdc9
	.byte	0x4
	.uleb128 0x16
	.string	"cnt"
	.byte	0x1a
	.byte	0x30
	.4byte	0xdc9
	.byte	0x6
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x31
	.4byte	0xdd4
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF301
	.byte	0x1a
	.byte	0x32
	.4byte	0xfe1
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF302
	.byte	0x1a
	.byte	0x33
	.4byte	0xff1
	.byte	0x20
	.byte	0
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0xff1
	.uleb128 0xe
	.4byte	0xda
	.byte	0x7
	.byte	0
	.uleb128 0xa
	.4byte	0x1001
	.4byte	0x1001
	.uleb128 0xe
	.4byte	0xda
	.byte	0x7
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xdd4
	.uleb128 0xf
	.4byte	.LASF303
	.byte	0xc
	.byte	0x1a
	.byte	0x3f
	.4byte	0x104f
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x41
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF299
	.byte	0x1a
	.byte	0x42
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF300
	.byte	0x1a
	.byte	0x43
	.4byte	0xdc9
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF304
	.byte	0x1a
	.byte	0x44
	.4byte	0xdc9
	.byte	0x6
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x45
	.4byte	0xdd4
	.byte	0x8
	.byte	0
	.uleb128 0xf
	.4byte	.LASF305
	.byte	0x40
	.byte	0x1a
	.byte	0x48
	.4byte	0x10f8
	.uleb128 0x10
	.4byte	.LASF236
	.byte	0x1a
	.byte	0x4a
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF299
	.byte	0x1a
	.byte	0x4b
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x4d
	.4byte	0xdc9
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF307
	.byte	0x1a
	.byte	0x4e
	.4byte	0xdc9
	.byte	0x6
	.uleb128 0x10
	.4byte	.LASF308
	.byte	0x1a
	.byte	0x50
	.4byte	0xdc9
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF309
	.byte	0x1a
	.byte	0x51
	.4byte	0xdc9
	.byte	0xa
	.uleb128 0x10
	.4byte	.LASF310
	.byte	0x1a
	.byte	0x53
	.4byte	0x10f8
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF311
	.byte	0x1a
	.byte	0x54
	.4byte	0x1001
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF312
	.byte	0x1a
	.byte	0x55
	.4byte	0x10f8
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF313
	.byte	0x1a
	.byte	0x56
	.4byte	0x1001
	.byte	0x28
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x58
	.4byte	0xdd4
	.byte	0x30
	.uleb128 0x10
	.4byte	.LASF314
	.byte	0x1a
	.byte	0x59
	.4byte	0xdd4
	.byte	0x34
	.uleb128 0x10
	.4byte	.LASF315
	.byte	0x1a
	.byte	0x5a
	.4byte	0xdd4
	.byte	0x38
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xdc9
	.uleb128 0xf
	.4byte	.LASF316
	.byte	0x10
	.byte	0x1a
	.byte	0x5d
	.4byte	0x113b
	.uleb128 0x10
	.4byte	.LASF317
	.byte	0x1a
	.byte	0x5f
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF43
	.byte	0x1a
	.byte	0x60
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x16
	.string	"hit"
	.byte	0x1a
	.byte	0x61
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF318
	.byte	0x1a
	.byte	0x62
	.4byte	0x1001
	.byte	0x8
	.byte	0
	.uleb128 0xf
	.4byte	.LASF319
	.byte	0x24
	.byte	0x1a
	.byte	0x65
	.4byte	0x11a8
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x67
	.4byte	0xdd4
	.byte	0
	.uleb128 0x10
	.4byte	.LASF320
	.byte	0x1a
	.byte	0x68
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x69
	.4byte	0xdd4
	.byte	0x8
	.uleb128 0x16
	.string	"len"
	.byte	0x1a
	.byte	0x6a
	.4byte	0xdd4
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF321
	.byte	0x1a
	.byte	0x6b
	.4byte	0xdd4
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF322
	.byte	0x1a
	.byte	0x6c
	.4byte	0xdd4
	.byte	0x14
	.uleb128 0x10
	.4byte	.LASF323
	.byte	0x1a
	.byte	0x6d
	.4byte	0x11a8
	.byte	0x18
	.uleb128 0x16
	.string	"tbl"
	.byte	0x1a
	.byte	0x6e
	.4byte	0x11b8
	.byte	0x20
	.byte	0
	.uleb128 0xa
	.4byte	0xdd4
	.4byte	0x11b8
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1
	.byte	0
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x11c8
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1
	.byte	0
	.uleb128 0xf
	.4byte	.LASF324
	.byte	0x10
	.byte	0x1a
	.byte	0x72
	.4byte	0x1228
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x74
	.4byte	0xdc9
	.byte	0
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x75
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x76
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF300
	.byte	0x1a
	.byte	0x77
	.4byte	0xdc9
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF325
	.byte	0x1a
	.byte	0x78
	.4byte	0xdc9
	.byte	0xa
	.uleb128 0x10
	.4byte	.LASF326
	.byte	0x1a
	.byte	0x79
	.4byte	0xdc9
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF323
	.byte	0x1a
	.byte	0x7a
	.4byte	0x1228
	.byte	0xe
	.byte	0
	.uleb128 0xa
	.4byte	0xdbe
	.4byte	0x1238
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1
	.byte	0
	.uleb128 0xf
	.4byte	.LASF327
	.byte	0x10
	.byte	0x1a
	.byte	0x7d
	.4byte	0x1280
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x7f
	.4byte	0xdc9
	.byte	0
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x80
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x81
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x16
	.string	"lpa"
	.byte	0x1a
	.byte	0x82
	.4byte	0xdd4
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF328
	.byte	0x1a
	.byte	0x83
	.4byte	0xdd4
	.byte	0xc
	.byte	0
	.uleb128 0xf
	.4byte	.LASF329
	.byte	0x10
	.byte	0x1a
	.byte	0x8f
	.4byte	0x12c8
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x91
	.4byte	0xdc9
	.byte	0
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x92
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x93
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF330
	.byte	0x1a
	.byte	0x94
	.4byte	0xdc9
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF323
	.byte	0x1a
	.byte	0x95
	.4byte	0x12c8
	.byte	0xa
	.byte	0
	.uleb128 0xa
	.4byte	0xdbe
	.4byte	0x12d8
	.uleb128 0xe
	.4byte	0xda
	.byte	0x5
	.byte	0
	.uleb128 0xf
	.4byte	.LASF331
	.byte	0x10
	.byte	0x1a
	.byte	0x98
	.4byte	0x1320
	.uleb128 0x10
	.4byte	.LASF306
	.byte	0x1a
	.byte	0x9a
	.4byte	0xdc9
	.byte	0
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0x9b
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF78
	.byte	0x1a
	.byte	0x9c
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF332
	.byte	0x1a
	.byte	0x9d
	.4byte	0xdd4
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF333
	.byte	0x1a
	.byte	0x9e
	.4byte	0xdd4
	.byte	0xc
	.byte	0
	.uleb128 0xf
	.4byte	.LASF334
	.byte	0x30
	.byte	0x1a
	.byte	0xa1
	.4byte	0x141d
	.uleb128 0x16
	.string	"tag"
	.byte	0x1a
	.byte	0xa3
	.4byte	0xdd4
	.byte	0
	.uleb128 0x16
	.string	"ver"
	.byte	0x1a
	.byte	0xa4
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF304
	.byte	0x1a
	.byte	0xa6
	.4byte	0xdc9
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF335
	.byte	0x1a
	.byte	0xa7
	.4byte	0xdbe
	.byte	0xa
	.uleb128 0x10
	.4byte	.LASF336
	.byte	0x1a
	.byte	0xa8
	.4byte	0xdbe
	.byte	0xb
	.uleb128 0x10
	.4byte	.LASF337
	.byte	0x1a
	.byte	0xa9
	.4byte	0xdbe
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF338
	.byte	0x1a
	.byte	0xaa
	.4byte	0xdbe
	.byte	0xd
	.uleb128 0x10
	.4byte	.LASF339
	.byte	0x1a
	.byte	0xab
	.4byte	0xdc9
	.byte	0xe
	.uleb128 0x10
	.4byte	.LASF340
	.byte	0x1a
	.byte	0xad
	.4byte	0xdc9
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF341
	.byte	0x1a
	.byte	0xae
	.4byte	0xdc9
	.byte	0x12
	.uleb128 0x10
	.4byte	.LASF342
	.byte	0x1a
	.byte	0xaf
	.4byte	0xdc9
	.byte	0x14
	.uleb128 0x10
	.4byte	.LASF343
	.byte	0x1a
	.byte	0xb0
	.4byte	0xdc9
	.byte	0x16
	.uleb128 0x10
	.4byte	.LASF344
	.byte	0x1a
	.byte	0xb2
	.4byte	0xdc9
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF345
	.byte	0x1a
	.byte	0xb3
	.4byte	0xdc9
	.byte	0x1a
	.uleb128 0x10
	.4byte	.LASF346
	.byte	0x1a
	.byte	0xb4
	.4byte	0xdc9
	.byte	0x1c
	.uleb128 0x10
	.4byte	.LASF347
	.byte	0x1a
	.byte	0xb5
	.4byte	0xdc9
	.byte	0x1e
	.uleb128 0x10
	.4byte	.LASF348
	.byte	0x1a
	.byte	0xb7
	.4byte	0xdd4
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF349
	.byte	0x1a
	.byte	0xb8
	.4byte	0xdd4
	.byte	0x24
	.uleb128 0x10
	.4byte	.LASF350
	.byte	0x1a
	.byte	0xb9
	.4byte	0xdd4
	.byte	0x28
	.uleb128 0x10
	.4byte	.LASF323
	.byte	0x1a
	.byte	0xba
	.4byte	0x11b8
	.byte	0x2c
	.byte	0
	.uleb128 0x27
	.4byte	.LASF351
	.2byte	0x200
	.byte	0x1a
	.byte	0xbe
	.4byte	0x1563
	.uleb128 0x16
	.string	"tag"
	.byte	0x1a
	.byte	0xc0
	.4byte	0xdd4
	.byte	0
	.uleb128 0x16
	.string	"ver"
	.byte	0x1a
	.byte	0xc1
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF352
	.byte	0x1a
	.byte	0xc3
	.4byte	0xdd4
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF353
	.byte	0x1a
	.byte	0xc4
	.4byte	0xdd4
	.byte	0xc
	.uleb128 0x10
	.4byte	.LASF354
	.byte	0x1a
	.byte	0xc5
	.4byte	0xdd4
	.byte	0x10
	.uleb128 0x10
	.4byte	.LASF355
	.byte	0x1a
	.byte	0xc6
	.4byte	0xdd4
	.byte	0x14
	.uleb128 0x10
	.4byte	.LASF348
	.byte	0x1a
	.byte	0xc8
	.4byte	0xdd4
	.byte	0x18
	.uleb128 0x10
	.4byte	.LASF356
	.byte	0x1a
	.byte	0xc9
	.4byte	0xdd4
	.byte	0x1c
	.uleb128 0x10
	.4byte	.LASF357
	.byte	0x1a
	.byte	0xca
	.4byte	0xdd4
	.byte	0x20
	.uleb128 0x10
	.4byte	.LASF358
	.byte	0x1a
	.byte	0xcb
	.4byte	0xdd4
	.byte	0x24
	.uleb128 0x10
	.4byte	.LASF345
	.byte	0x1a
	.byte	0xcd
	.4byte	0xdd4
	.byte	0x28
	.uleb128 0x10
	.4byte	.LASF359
	.byte	0x1a
	.byte	0xce
	.4byte	0xdd4
	.byte	0x2c
	.uleb128 0x10
	.4byte	.LASF360
	.byte	0x1a
	.byte	0xcf
	.4byte	0xdd4
	.byte	0x30
	.uleb128 0x10
	.4byte	.LASF361
	.byte	0x1a
	.byte	0xd0
	.4byte	0xdd4
	.byte	0x34
	.uleb128 0x10
	.4byte	.LASF362
	.byte	0x1a
	.byte	0xd2
	.4byte	0xdd4
	.byte	0x38
	.uleb128 0x10
	.4byte	.LASF363
	.byte	0x1a
	.byte	0xd3
	.4byte	0xdd4
	.byte	0x3c
	.uleb128 0x10
	.4byte	.LASF364
	.byte	0x1a
	.byte	0xd4
	.4byte	0xdd4
	.byte	0x40
	.uleb128 0x10
	.4byte	.LASF365
	.byte	0x1a
	.byte	0xd5
	.4byte	0xdd4
	.byte	0x44
	.uleb128 0x10
	.4byte	.LASF366
	.byte	0x1a
	.byte	0xd7
	.4byte	0xdd4
	.byte	0x48
	.uleb128 0x10
	.4byte	.LASF367
	.byte	0x1a
	.byte	0xd8
	.4byte	0xdd4
	.byte	0x4c
	.uleb128 0x10
	.4byte	.LASF368
	.byte	0x1a
	.byte	0xd9
	.4byte	0xdd4
	.byte	0x50
	.uleb128 0x10
	.4byte	.LASF369
	.byte	0x1a
	.byte	0xda
	.4byte	0xdd4
	.byte	0x54
	.uleb128 0x10
	.4byte	.LASF370
	.byte	0x1a
	.byte	0xdc
	.4byte	0xdd4
	.byte	0x58
	.uleb128 0x10
	.4byte	.LASF371
	.byte	0x1a
	.byte	0xdd
	.4byte	0xdd4
	.byte	0x5c
	.uleb128 0x10
	.4byte	.LASF372
	.byte	0x1a
	.byte	0xde
	.4byte	0xdd4
	.byte	0x60
	.uleb128 0x10
	.4byte	.LASF323
	.byte	0x1a
	.byte	0xe0
	.4byte	0x1563
	.byte	0x64
	.byte	0
	.uleb128 0xa
	.4byte	0xdd4
	.4byte	0x1573
	.uleb128 0xe
	.4byte	0xda
	.byte	0x66
	.byte	0
	.uleb128 0xf
	.4byte	.LASF373
	.byte	0x6
	.byte	0x1a
	.byte	0xe4
	.4byte	0x15a4
	.uleb128 0x10
	.4byte	.LASF235
	.byte	0x1a
	.byte	0xe6
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF374
	.byte	0x1a
	.byte	0xe7
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF375
	.byte	0x1a
	.byte	0xe8
	.4byte	0xdc9
	.byte	0x4
	.byte	0
	.uleb128 0x27
	.4byte	.LASF376
	.2byte	0x808
	.byte	0x1a
	.byte	0xeb
	.4byte	0x15ee
	.uleb128 0x16
	.string	"max"
	.byte	0x1a
	.byte	0xed
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF377
	.byte	0x1a
	.byte	0xee
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF378
	.byte	0x1a
	.byte	0xef
	.4byte	0xdc9
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF325
	.byte	0x1a
	.byte	0xf0
	.4byte	0xdc9
	.byte	0x6
	.uleb128 0x16
	.string	"arr"
	.byte	0x1a
	.byte	0xf1
	.4byte	0x15ee
	.byte	0x8
	.byte	0
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x15ff
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x3ff
	.byte	0
	.uleb128 0xf
	.4byte	.LASF379
	.byte	0x30
	.byte	0x1a
	.byte	0xf5
	.4byte	0x1691
	.uleb128 0x16
	.string	"id"
	.byte	0x1a
	.byte	0xf7
	.4byte	0xdc9
	.byte	0
	.uleb128 0x10
	.4byte	.LASF380
	.byte	0x1a
	.byte	0xf8
	.4byte	0xdc9
	.byte	0x2
	.uleb128 0x10
	.4byte	.LASF381
	.byte	0x1a
	.byte	0xf9
	.4byte	0xdc9
	.byte	0x4
	.uleb128 0x10
	.4byte	.LASF382
	.byte	0x1a
	.byte	0xfa
	.4byte	0xdbe
	.byte	0x6
	.uleb128 0x10
	.4byte	.LASF383
	.byte	0x1a
	.byte	0xfb
	.4byte	0xdbe
	.byte	0x7
	.uleb128 0x10
	.4byte	.LASF384
	.byte	0x1a
	.byte	0xfc
	.4byte	0xdbe
	.byte	0x8
	.uleb128 0x10
	.4byte	.LASF385
	.byte	0x1a
	.byte	0xfd
	.4byte	0xdbe
	.byte	0x9
	.uleb128 0x10
	.4byte	.LASF386
	.byte	0x1a
	.byte	0xfe
	.4byte	0xdbe
	.byte	0xa
	.uleb128 0x10
	.4byte	.LASF387
	.byte	0x1a
	.byte	0xff
	.4byte	0xdbe
	.byte	0xb
	.uleb128 0x1b
	.4byte	.LASF78
	.byte	0x1a
	.2byte	0x100
	.4byte	0xdd4
	.byte	0xc
	.uleb128 0x1b
	.4byte	.LASF388
	.byte	0x1a
	.2byte	0x101
	.4byte	0x1691
	.byte	0x10
	.byte	0
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x16a1
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x1a
	.4byte	.LASF389
	.byte	0xc
	.byte	0x1a
	.2byte	0x105
	.4byte	0x16d6
	.uleb128 0x1b
	.4byte	.LASF390
	.byte	0x1a
	.2byte	0x107
	.4byte	0xdd4
	.byte	0
	.uleb128 0x1b
	.4byte	.LASF391
	.byte	0x1a
	.2byte	0x108
	.4byte	0xdd4
	.byte	0x4
	.uleb128 0x1d
	.string	"lpa"
	.byte	0x1a
	.2byte	0x109
	.4byte	0xdd4
	.byte	0x8
	.byte	0
	.uleb128 0x1a
	.4byte	.LASF392
	.byte	0x18
	.byte	0x1a
	.2byte	0x10c
	.4byte	0x170b
	.uleb128 0x1b
	.4byte	.LASF278
	.byte	0x1a
	.2byte	0x10e
	.4byte	0x1001
	.byte	0
	.uleb128 0x1b
	.4byte	.LASF279
	.byte	0x1a
	.2byte	0x10f
	.4byte	0x1001
	.byte	0x8
	.uleb128 0x1b
	.4byte	.LASF393
	.byte	0x1a
	.2byte	0x110
	.4byte	0xdd4
	.byte	0x10
	.byte	0
	.uleb128 0x28
	.4byte	.LASF394
	.byte	0x1b
	.byte	0x12
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_type
	.uleb128 0x28
	.4byte	.LASF395
	.byte	0x1b
	.byte	0x13
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_die_num
	.uleb128 0x28
	.4byte	.LASF396
	.byte	0x1b
	.byte	0x14
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.uleb128 0x28
	.4byte	.LASF397
	.byte	0x1b
	.byte	0x15
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.uleb128 0x28
	.4byte	.LASF398
	.byte	0x1b
	.byte	0x16
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die_shift
	.uleb128 0x28
	.4byte	.LASF399
	.byte	0x1b
	.byte	0x17
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_planes_num
	.uleb128 0x28
	.4byte	.LASF400
	.byte	0x1b
	.byte	0x18
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_blk_pre_plane
	.uleb128 0x28
	.4byte	.LASF401
	.byte	0x1b
	.byte	0x19
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_ext_blk_pre_plane
	.uleb128 0x28
	.4byte	.LASF402
	.byte	0x1b
	.byte	0x1a
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_bbm_buf_size
	.uleb128 0x28
	.4byte	.LASF403
	.byte	0x1b
	.byte	0x1c
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_page_pre_blk
	.uleb128 0x28
	.4byte	.LASF404
	.byte	0x1b
	.byte	0x1d
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_page_pre_slc_blk
	.uleb128 0x28
	.4byte	.LASF405
	.byte	0x1b
	.byte	0x1e
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_page_pre_super_blk
	.uleb128 0x28
	.4byte	.LASF406
	.byte	0x1b
	.byte	0x1f
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.uleb128 0x28
	.4byte	.LASF407
	.byte	0x1b
	.byte	0x20
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.uleb128 0x28
	.4byte	.LASF408
	.byte	0x1b
	.byte	0x24
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_byte_pre_page
	.uleb128 0x28
	.4byte	.LASF409
	.byte	0x1b
	.byte	0x25
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_byte_pre_oob
	.uleb128 0x28
	.4byte	.LASF410
	.byte	0x1b
	.byte	0x26
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_reserved_blks
	.uleb128 0x28
	.4byte	.LASF411
	.byte	0x1b
	.byte	0x27
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_totle_phy_blks
	.uleb128 0x28
	.4byte	.LASF412
	.byte	0x1b
	.byte	0x29
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_map_region_num
	.uleb128 0x28
	.4byte	.LASF413
	.byte	0x1b
	.byte	0x2a
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_l2pmap_ram_region_num
	.uleb128 0x28
	.4byte	.LASF414
	.byte	0x1b
	.byte	0x2c
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_vendor_region_num
	.uleb128 0x28
	.4byte	.LASF415
	.byte	0x1b
	.byte	0x2e
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_map_blks_per_plane
	.uleb128 0x28
	.4byte	.LASF416
	.byte	0x1b
	.byte	0x2f
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_max_map_blks
	.uleb128 0x28
	.4byte	.LASF417
	.byte	0x1b
	.byte	0x30
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_max_vendor_blks
	.uleb128 0x28
	.4byte	.LASF418
	.byte	0x1b
	.byte	0x31
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_vendor_part_size
	.uleb128 0x28
	.4byte	.LASF419
	.byte	0x1b
	.byte	0x32
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_sys_blks_per_plane
	.uleb128 0x28
	.4byte	.LASF420
	.byte	0x1b
	.byte	0x33
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_init_sys_blks_per_plane
	.uleb128 0x28
	.4byte	.LASF421
	.byte	0x1b
	.byte	0x34
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_max_sys_blks
	.uleb128 0x28
	.4byte	.LASF422
	.byte	0x1b
	.byte	0x35
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_data_blks_per_plane
	.uleb128 0x28
	.4byte	.LASF423
	.byte	0x1b
	.byte	0x36
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_data_op_blks_per_plane
	.uleb128 0x28
	.4byte	.LASF424
	.byte	0x1b
	.byte	0x37
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_ftl_nand_max_data_blks
	.uleb128 0x28
	.4byte	.LASF425
	.byte	0x1b
	.byte	0x38
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	ftl_gc_temp_power_lost_recovery_flag
	.uleb128 0x28
	.4byte	.LASF426
	.byte	0x1b
	.byte	0x3a
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_GlobalSysVersion
	.uleb128 0x28
	.4byte	.LASF427
	.byte	0x1b
	.byte	0x3b
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_GlobalDataVersion
	.uleb128 0x28
	.4byte	.LASF428
	.byte	0x1b
	.byte	0x3c
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_MaxLbaSector
	.uleb128 0x28
	.4byte	.LASF429
	.byte	0x1b
	.byte	0x3d
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_MaxLpn
	.uleb128 0x28
	.4byte	.LASF430
	.byte	0x1b
	.byte	0x3e
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_VaildLpn
	.uleb128 0x28
	.4byte	.LASF431
	.byte	0x1b
	.byte	0x3f
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_MaxLbn
	.uleb128 0x28
	.4byte	.LASF432
	.byte	0x1b
	.byte	0x41
	.4byte	0xf81
	.uleb128 0x9
	.byte	0x3
	.8byte	gBbtInfo
	.uleb128 0x28
	.4byte	.LASF433
	.byte	0x1b
	.byte	0x42
	.4byte	0x1007
	.uleb128 0x9
	.byte	0x3
	.8byte	gSysInfo
	.uleb128 0x28
	.4byte	.LASF434
	.byte	0x1b
	.byte	0x43
	.4byte	0x15a4
	.uleb128 0x9
	.byte	0x3
	.8byte	gSysFreeQueue
	.uleb128 0x28
	.4byte	.LASF435
	.byte	0x1b
	.byte	0x44
	.4byte	0x104f
	.uleb128 0x9
	.byte	0x3
	.8byte	gL2pMapInfo
	.uleb128 0x28
	.4byte	.LASF436
	.byte	0x1b
	.byte	0x45
	.4byte	0x104f
	.uleb128 0x9
	.byte	0x3
	.8byte	gVendorBlkInfo
	.uleb128 0x28
	.4byte	.LASF437
	.byte	0x1b
	.byte	0x46
	.4byte	0xdf5
	.uleb128 0x9
	.byte	0x3
	.8byte	req_sys
	.uleb128 0x28
	.4byte	.LASF438
	.byte	0x1b
	.byte	0x47
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	req_read
	.uleb128 0x8
	.byte	0x8
	.4byte	0xdf5
	.uleb128 0x28
	.4byte	.LASF439
	.byte	0x1b
	.byte	0x48
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	req_prgm
	.uleb128 0x28
	.4byte	.LASF440
	.byte	0x1b
	.byte	0x49
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	req_erase
	.uleb128 0x28
	.4byte	.LASF441
	.byte	0x1b
	.byte	0x4a
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	req_gc
	.uleb128 0x28
	.4byte	.LASF442
	.byte	0x1b
	.byte	0x4b
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	req_gc_dst
	.uleb128 0xa
	.4byte	0xdbe
	.4byte	0x1b26
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x28
	.4byte	.LASF443
	.byte	0x1b
	.byte	0x4d
	.4byte	0x1b16
	.uleb128 0x9
	.byte	0x3
	.8byte	p_plane_order_table
	.uleb128 0x28
	.4byte	.LASF444
	.byte	0x1b
	.byte	0x4f
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_data_buf
	.uleb128 0x28
	.4byte	.LASF445
	.byte	0x1b
	.byte	0x50
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_data_buf_1
	.uleb128 0x28
	.4byte	.LASF446
	.byte	0x1b
	.byte	0x51
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_data_buf
	.uleb128 0x28
	.4byte	.LASF447
	.byte	0x1b
	.byte	0x52
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_spare_buf
	.uleb128 0x28
	.4byte	.LASF448
	.byte	0x1b
	.byte	0x53
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_data_buf_0
	.uleb128 0x28
	.4byte	.LASF449
	.byte	0x1b
	.byte	0x54
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_data_buf_1
	.uleb128 0x28
	.4byte	.LASF450
	.byte	0x1b
	.byte	0x55
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_spare_buf
	.uleb128 0x28
	.4byte	.LASF451
	.byte	0x1b
	.byte	0x56
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_spare_buf
	.uleb128 0x28
	.4byte	.LASF452
	.byte	0x1b
	.byte	0x57
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_data_buf
	.uleb128 0x28
	.4byte	.LASF453
	.byte	0x1b
	.byte	0x58
	.4byte	0x1c0d
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_gc_page_buf_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x16d6
	.uleb128 0x28
	.4byte	.LASF454
	.byte	0x1b
	.byte	0x59
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_gc_page_buf_num
	.uleb128 0x28
	.4byte	.LASF455
	.byte	0x1b
	.byte	0x5a
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_num_req
	.uleb128 0x28
	.4byte	.LASF456
	.byte	0x1b
	.byte	0x5b
	.4byte	0x1c52
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_ect_tbl_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x113b
	.uleb128 0x28
	.4byte	.LASF457
	.byte	0x1b
	.byte	0x5c
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ect_tbl_info_size
	.uleb128 0x28
	.4byte	.LASF458
	.byte	0x1b
	.byte	0x5d
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_erase_count_table
	.uleb128 0x28
	.4byte	.LASF459
	.byte	0x1b
	.byte	0x5f
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_swl_mul_table
	.uleb128 0x28
	.4byte	.LASF460
	.byte	0x1b
	.byte	0x60
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_swl_count
	.uleb128 0x28
	.4byte	.LASF461
	.byte	0x1b
	.byte	0x61
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_valid_page_count_table
	.uleb128 0x28
	.4byte	.LASF462
	.byte	0x1b
	.byte	0x62
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_valid_page_count_check_table
	.uleb128 0x28
	.4byte	.LASF463
	.byte	0x1b
	.byte	0x63
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_blk_mode_table
	.uleb128 0x28
	.4byte	.LASF464
	.byte	0x1b
	.byte	0x65
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_table
	.uleb128 0x28
	.4byte	.LASF465
	.byte	0x1b
	.byte	0x66
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_valid_page_count
	.uleb128 0x28
	.4byte	.LASF466
	.byte	0x1b
	.byte	0x67
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_ver_table
	.uleb128 0x28
	.4byte	.LASF467
	.byte	0x1b
	.byte	0x68
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_region_ppn_table
	.uleb128 0x28
	.4byte	.LASF468
	.byte	0x1b
	.byte	0x69
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_map_block
	.uleb128 0x28
	.4byte	.LASF469
	.byte	0x1b
	.byte	0x6b
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_table
	.uleb128 0x28
	.4byte	.LASF470
	.byte	0x1b
	.byte	0x6c
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_valid_page_count
	.uleb128 0x28
	.4byte	.LASF471
	.byte	0x1b
	.byte	0x6d
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_ver_table
	.uleb128 0x28
	.4byte	.LASF472
	.byte	0x1b
	.byte	0x6e
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_region_ppn_table
	.uleb128 0x28
	.4byte	.LASF473
	.byte	0x1b
	.byte	0x6f
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_vendor_block
	.uleb128 0x28
	.4byte	.LASF474
	.byte	0x1b
	.byte	0x71
	.4byte	0x1dd2
	.uleb128 0x9
	.byte	0x3
	.8byte	p_l2p_ram_map
	.uleb128 0x8
	.byte	0x8
	.4byte	0x10fe
	.uleb128 0x28
	.4byte	.LASF475
	.byte	0x1b
	.byte	0x72
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_l2p_map_buf
	.uleb128 0x28
	.4byte	.LASF476
	.byte	0x1b
	.byte	0x73
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_l2p_last_update_region_id
	.uleb128 0x28
	.4byte	.LASF477
	.byte	0x1b
	.byte	0x7a
	.4byte	0x1e17
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_table
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1573
	.uleb128 0x28
	.4byte	.LASF478
	.byte	0x1b
	.byte	0x7b
	.4byte	0x1e17
	.uleb128 0x9
	.byte	0x3
	.8byte	p_free_data_block_list_head
	.uleb128 0x28
	.4byte	.LASF479
	.byte	0x1b
	.byte	0x7d
	.4byte	0x1e17
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_head
	.uleb128 0x28
	.4byte	.LASF480
	.byte	0x1b
	.byte	0x7e
	.4byte	0x1e17
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_tail
	.uleb128 0x28
	.4byte	.LASF481
	.byte	0x1b
	.byte	0x7f
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_num_free_superblocks
	.uleb128 0x28
	.4byte	.LASF482
	.byte	0x1b
	.byte	0x80
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_num_data_superblocks
	.uleb128 0x28
	.4byte	.LASF483
	.byte	0x1b
	.byte	0x81
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_active_superblock
	.uleb128 0x28
	.4byte	.LASF484
	.byte	0x1b
	.byte	0x82
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_buffer_superblock
	.uleb128 0x28
	.4byte	.LASF485
	.byte	0x1b
	.byte	0x83
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_temp_superblock
	.uleb128 0x28
	.4byte	.LASF486
	.byte	0x1b
	.byte	0x84
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_superblock
	.uleb128 0x28
	.4byte	.LASF487
	.byte	0x1b
	.byte	0x85
	.4byte	0x1eef
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_last_act_superblock
	.uleb128 0x8
	.byte	0x8
	.4byte	0x15ff
	.uleb128 0x28
	.4byte	.LASF488
	.byte	0x1b
	.byte	0x86
	.4byte	0x1320
	.uleb128 0x9
	.byte	0x3
	.8byte	g_sys_save_data
	.uleb128 0x28
	.4byte	.LASF489
	.byte	0x1b
	.byte	0x87
	.4byte	0x141d
	.uleb128 0x9
	.byte	0x3
	.8byte	g_sys_ext_data
	.uleb128 0x28
	.4byte	.LASF490
	.byte	0x1b
	.byte	0x89
	.4byte	0x1f34
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_page_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x16a1
	.uleb128 0x28
	.4byte	.LASF491
	.byte	0x1b
	.byte	0x8a
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_blk_tbl
	.uleb128 0x28
	.4byte	.LASF492
	.byte	0x1b
	.byte	0x8b
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_blk_num
	.uleb128 0x28
	.4byte	.LASF493
	.byte	0x1b
	.byte	0x8c
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_page_offset
	.uleb128 0x28
	.4byte	.LASF494
	.byte	0x1b
	.byte	0x8d
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_cur_blk_valid_pages
	.uleb128 0x28
	.4byte	.LASF495
	.byte	0x1b
	.byte	0x8e
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_cur_blk_max_valid_pages
	.uleb128 0x28
	.4byte	.LASF496
	.byte	0x1b
	.byte	0x8f
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_next_blk
	.uleb128 0x28
	.4byte	.LASF497
	.byte	0x1b
	.byte	0x90
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_next_blk_1
	.uleb128 0x28
	.4byte	.LASF498
	.byte	0x1b
	.byte	0x91
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_temp_num
	.uleb128 0x28
	.4byte	.LASF499
	.byte	0x1b
	.byte	0x92
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_gc_index
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x2007
	.uleb128 0xe
	.4byte	0xda
	.byte	0x10
	.byte	0
	.uleb128 0x28
	.4byte	.LASF500
	.byte	0x1b
	.byte	0x93
	.4byte	0x1ff7
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_temp_tbl
	.uleb128 0x28
	.4byte	.LASF501
	.byte	0x1b
	.byte	0x95
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_free_blk_threshold
	.uleb128 0x28
	.4byte	.LASF502
	.byte	0x1b
	.byte	0x96
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_merge_free_blk_threshold
	.uleb128 0x28
	.4byte	.LASF503
	.byte	0x1b
	.byte	0x97
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_blk_index
	.uleb128 0x28
	.4byte	.LASF504
	.byte	0x1b
	.byte	0x99
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_gc_page_count
	.uleb128 0x28
	.4byte	.LASF505
	.byte	0x1b
	.byte	0x9a
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_write_page_count
	.uleb128 0x28
	.4byte	.LASF506
	.byte	0x1b
	.byte	0x9b
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_write_sector
	.uleb128 0x28
	.4byte	.LASF507
	.byte	0x1b
	.byte	0x9c
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_read_sector
	.uleb128 0x28
	.4byte	.LASF508
	.byte	0x1b
	.byte	0x9e
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_discard_page_count
	.uleb128 0x28
	.4byte	.LASF509
	.byte	0x1b
	.byte	0x9f
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_read_page_count
	.uleb128 0x28
	.4byte	.LASF510
	.byte	0x1b
	.byte	0xa0
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_tmp_data_superblock_id
	.uleb128 0x28
	.4byte	.LASF511
	.byte	0x1b
	.byte	0xa1
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_cache_write_count
	.uleb128 0x28
	.4byte	.LASF512
	.byte	0x1b
	.byte	0xa2
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_l2p_write_count
	.uleb128 0x28
	.4byte	.LASF513
	.byte	0x1b
	.byte	0xa4
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_mlc_erase_count
	.uleb128 0x28
	.4byte	.LASF514
	.byte	0x1b
	.byte	0xa5
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_avg_erase_count
	.uleb128 0x28
	.4byte	.LASF515
	.byte	0x1b
	.byte	0xa6
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_min_erase_count
	.uleb128 0x28
	.4byte	.LASF516
	.byte	0x1b
	.byte	0xa7
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_slc_erase_count
	.uleb128 0x28
	.4byte	.LASF517
	.byte	0x1b
	.byte	0xa8
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_sys_slc_erase_count
	.uleb128 0x28
	.4byte	.LASF518
	.byte	0x1b
	.byte	0xa9
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_max_erase_count
	.uleb128 0x28
	.4byte	.LASF519
	.byte	0x1b
	.byte	0xaa
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_in_gc_progress
	.uleb128 0x28
	.4byte	.LASF520
	.byte	0x1b
	.byte	0xab
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_in_swl_replace
	.uleb128 0x28
	.4byte	.LASF521
	.byte	0x1b
	.byte	0xac
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ftl_nand_free_count
	.uleb128 0x28
	.4byte	.LASF522
	.byte	0x1b
	.byte	0xad
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_head_data_block
	.uleb128 0x28
	.4byte	.LASF523
	.byte	0x1b
	.byte	0xae
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_head_data_block_count
	.uleb128 0x28
	.4byte	.LASF524
	.byte	0x1b
	.byte	0xaf
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_skip_write_count
	.uleb128 0x28
	.4byte	.LASF525
	.byte	0x1b
	.byte	0xb0
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_cur_erase_blk
	.uleb128 0x28
	.4byte	.LASF526
	.byte	0x1b
	.byte	0xb2
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_page_num
	.uleb128 0x28
	.4byte	.LASF527
	.byte	0x1b
	.byte	0xb3
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_page_min_ver
	.uleb128 0xa
	.4byte	0xdd4
	.4byte	0x2263
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x28
	.4byte	.LASF528
	.byte	0x1b
	.byte	0xb4
	.4byte	0x2253
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_ppa_tbl
	.uleb128 0x28
	.4byte	.LASF529
	.byte	0x1b
	.byte	0xb5
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_mlc_erase_count_value
	.uleb128 0x28
	.4byte	.LASF530
	.byte	0x1b
	.byte	0xb6
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_power_lost_recovery_flag
	.uleb128 0x4
	.4byte	.LASF531
	.byte	0x18
	.byte	0x14
	.4byte	0xe44
	.uleb128 0x4
	.4byte	.LASF532
	.byte	0x18
	.byte	0x15
	.4byte	0xe44
	.uleb128 0x4
	.4byte	.LASF533
	.byte	0x18
	.byte	0x16
	.4byte	0xee6
	.uleb128 0xa
	.4byte	0xb9
	.4byte	0x22d4
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x3ff
	.byte	0
	.uleb128 0x4
	.4byte	.LASF534
	.byte	0x18
	.byte	0x17
	.4byte	0x22c3
	.uleb128 0x28
	.4byte	.LASF535
	.byte	0x3
	.byte	0x6
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	DeviceCapacity
	.uleb128 0x28
	.4byte	.LASF536
	.byte	0x3
	.byte	0x7
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	gFtlInitStatus
	.uleb128 0x4
	.4byte	.LASF537
	.byte	0x3
	.byte	0x6d
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF538
	.byte	0x3
	.byte	0x6e
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF539
	.byte	0x3
	.byte	0x6f
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF540
	.byte	0x3
	.byte	0x70
	.4byte	0xdd4
	.uleb128 0x29
	.4byte	.LASF541
	.byte	0x3
	.2byte	0x3bc
	.4byte	0x5b
	.uleb128 0x9
	.byte	0x3
	.8byte	power_up_flag
	.uleb128 0x2a
	.4byte	.LASF545
	.byte	0x3
	.2byte	0x45f
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	gc_discard_updated
	.uleb128 0x29
	.4byte	.LASF542
	.byte	0x2
	.2byte	0x38c
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ect_tbl_power_up_flush
	.uleb128 0x29
	.4byte	.LASF543
	.byte	0x2
	.2byte	0x3a1
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	FtlUpdateVaildLpnCount
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x239e
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x1fff
	.byte	0
	.uleb128 0x29
	.4byte	.LASF544
	.byte	0x2
	.2byte	0x8df
	.4byte	0x238d
	.uleb128 0x9
	.byte	0x3
	.8byte	check_vpc_table
	.uleb128 0x2b
	.4byte	.LASF546
	.byte	0x5
	.byte	0x6d
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	ftl_gc_temp_block_bops_scan_page_addr
	.uleb128 0x29
	.4byte	.LASF547
	.byte	0x5
	.2byte	0x1d4
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	gc_ink_free_return_value
	.uleb128 0xc
	.4byte	.LASF548
	.byte	0x1c
	.2byte	0x3ba
	.4byte	0x10b
	.uleb128 0xc
	.4byte	.LASF549
	.byte	0x1c
	.2byte	0x3bb
	.4byte	0x10b
	.uleb128 0xc
	.4byte	.LASF550
	.byte	0x1c
	.2byte	0x3bc
	.4byte	0x10b
	.uleb128 0xf
	.4byte	.LASF551
	.byte	0x4
	.byte	0x6
	.byte	0xc
	.4byte	0x241c
	.uleb128 0x16
	.string	"pid"
	.byte	0x6
	.byte	0xd
	.4byte	0x5b
	.byte	0
	.byte	0
	.uleb128 0x4
	.4byte	.LASF552
	.byte	0x6
	.byte	0x10
	.4byte	0x2427
	.uleb128 0x8
	.byte	0x8
	.4byte	0x2403
	.uleb128 0x2c
	.4byte	0x22ad
	.byte	0x1
	.byte	0x10
	.uleb128 0x9
	.byte	0x3
	.8byte	g_nand_phy_info
	.uleb128 0x2c
	.4byte	0x22b8
	.byte	0x1
	.byte	0x11
	.uleb128 0x9
	.byte	0x3
	.8byte	g_nand_ops
	.uleb128 0x2b
	.4byte	.LASF553
	.byte	0x1
	.byte	0x13
	.4byte	0x22c3
	.uleb128 0x9
	.byte	0x3
	.8byte	check_buf
	.uleb128 0x2c
	.4byte	0x22d4
	.byte	0x1
	.byte	0x14
	.uleb128 0x9
	.byte	0x3
	.8byte	ftl_temp_buf
	.uleb128 0xa
	.4byte	0xb9
	.4byte	0x2485
	.uleb128 0xe
	.4byte	0xda
	.byte	0x7f
	.byte	0
	.uleb128 0x2b
	.4byte	.LASF554
	.byte	0x1
	.byte	0x15
	.4byte	0x2475
	.uleb128 0x9
	.byte	0x3
	.8byte	check_spare_buf
	.uleb128 0x2d
	.4byte	.LASF557
	.byte	0x1
	.byte	0xfb
	.4byte	0x5b
	.8byte	.LFB348
	.8byte	.LFE348-.LFB348
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2512
	.uleb128 0x2e
	.4byte	.LASF555
	.byte	0x1
	.byte	0xfb
	.4byte	0x12c
	.4byte	.LLST469
	.uleb128 0x2e
	.4byte	.LASF556
	.byte	0x1
	.byte	0xfb
	.4byte	0x12c
	.4byte	.LLST470
	.uleb128 0x2e
	.4byte	.LASF325
	.byte	0x1
	.byte	0xfb
	.4byte	0x30
	.4byte	.LLST471
	.uleb128 0x2f
	.8byte	.LVL2156
	.4byte	0xa92c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF558
	.byte	0x1
	.byte	0xf6
	.4byte	0x12c
	.8byte	.LFB347
	.8byte	.LFE347-.LFB347
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x258a
	.uleb128 0x2e
	.4byte	.LASF559
	.byte	0x1
	.byte	0xf6
	.4byte	0x12c
	.4byte	.LLST304
	.uleb128 0x2e
	.4byte	.LASF560
	.byte	0x1
	.byte	0xf6
	.4byte	0x16f
	.4byte	.LLST305
	.uleb128 0x2e
	.4byte	.LASF30
	.byte	0x1
	.byte	0xf6
	.4byte	0x30
	.4byte	.LLST306
	.uleb128 0x2f
	.8byte	.LVL1245
	.4byte	0xa937
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF561
	.byte	0x1
	.byte	0xf1
	.4byte	0x12c
	.8byte	.LFB346
	.8byte	.LFE346-.LFB346
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x25fc
	.uleb128 0x31
	.string	"s"
	.byte	0x1
	.byte	0xf1
	.4byte	0x12c
	.4byte	.LLST197
	.uleb128 0x31
	.string	"c"
	.byte	0x1
	.byte	0xf1
	.4byte	0x5b
	.4byte	.LLST198
	.uleb128 0x31
	.string	"n"
	.byte	0x1
	.byte	0xf1
	.4byte	0x30
	.4byte	.LLST199
	.uleb128 0x2f
	.8byte	.LVL742
	.4byte	0xa943
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF562
	.byte	0x1
	.byte	0xdf
	.4byte	0xae
	.8byte	.LFB345
	.8byte	.LFE345-.LFB345
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x26b8
	.uleb128 0x2e
	.4byte	.LASF563
	.byte	0x1
	.byte	0xdf
	.4byte	0xf37
	.4byte	.LLST300
	.uleb128 0x31
	.string	"die"
	.byte	0x1
	.byte	0xdf
	.4byte	0xb9
	.4byte	.LLST301
	.uleb128 0x32
	.4byte	.LASF325
	.byte	0x1
	.byte	0xe1
	.4byte	0xa3
	.4byte	.LLST302
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0xe1
	.4byte	0xa3
	.4byte	.LLST303
	.uleb128 0x34
	.8byte	.LVL1232
	.4byte	0x258a
	.4byte	0x267c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x100
	.byte	0
	.uleb128 0x35
	.8byte	.LVL1233
	.4byte	0x2696
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1236
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x100
	.byte	0
	.byte	0
	.uleb128 0x37
	.4byte	.LASF588
	.byte	0x1
	.byte	0xc4
	.4byte	0xddf
	.byte	0x1
	.4byte	0x26fc
	.uleb128 0x38
	.4byte	.LASF576
	.byte	0x1
	.byte	0xc4
	.4byte	0xdc9
	.uleb128 0x39
	.string	"sts"
	.byte	0x1
	.byte	0xc6
	.4byte	0xddf
	.uleb128 0x3a
	.4byte	.LASF564
	.byte	0x1
	.byte	0xc7
	.4byte	0x26fc
	.uleb128 0x39
	.string	"req"
	.byte	0x1
	.byte	0xc8
	.4byte	0xdf5
	.uleb128 0x3b
	.string	"out"
	.byte	0x1
	.byte	0xda
	.byte	0
	.uleb128 0xa
	.4byte	0xdd4
	.4byte	0x270c
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x3c
	.4byte	.LASF565
	.byte	0x1
	.byte	0xae
	.4byte	0xae
	.8byte	.LFB343
	.8byte	.LFE343-.LFB343
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x27d2
	.uleb128 0x2e
	.4byte	.LASF566
	.byte	0x1
	.byte	0xae
	.4byte	0x12c
	.4byte	.LLST168
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0xae
	.4byte	0xb9
	.4byte	.LLST169
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0xae
	.4byte	0xb9
	.4byte	.LLST170
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0xb0
	.4byte	0xb9
	.4byte	.LLST171
	.uleb128 0x3d
	.string	"cs"
	.byte	0x1
	.byte	0xb0
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x32
	.4byte	.LASF276
	.byte	0x1
	.byte	0xb0
	.4byte	0xb9
	.4byte	.LLST172
	.uleb128 0x2b
	.4byte	.LASF569
	.byte	0x1
	.byte	0xb0
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x33
	.string	"req"
	.byte	0x1
	.byte	0xb1
	.4byte	0x1abc
	.4byte	.LLST173
	.uleb128 0x32
	.4byte	.LASF570
	.byte	0x1
	.byte	0xb2
	.4byte	0xb9
	.4byte	.LLST174
	.uleb128 0x36
	.8byte	.LVL648
	.4byte	0x963e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x71
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x72
	.sleb128 0
	.uleb128 0x3e
	.4byte	0x2a98
	.uleb128 0x2
	.byte	0x83
	.sleb128 -4
	.byte	0
	.byte	0
	.uleb128 0x3c
	.4byte	.LASF571
	.byte	0x1
	.byte	0x72
	.4byte	0xae
	.8byte	.LFB342
	.8byte	.LFE342-.LFB342
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x297a
	.uleb128 0x2e
	.4byte	.LASF566
	.byte	0x1
	.byte	0x72
	.4byte	0x12c
	.4byte	.LLST160
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST161
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST162
	.uleb128 0x2e
	.4byte	.LASF572
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST163
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.4byte	.LLST164
	.uleb128 0x3d
	.string	"cs"
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x32
	.4byte	.LASF276
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.4byte	.LLST165
	.uleb128 0x2b
	.4byte	.LASF569
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x32
	.4byte	.LASF570
	.byte	0x1
	.byte	0x75
	.4byte	0xb9
	.4byte	.LLST166
	.uleb128 0x33
	.string	"req"
	.byte	0x1
	.byte	0x76
	.4byte	0x1abc
	.4byte	.LLST167
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7632
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0xd0
	.4byte	0x292c
	.uleb128 0x2b
	.4byte	.LASF574
	.byte	0x1
	.byte	0x91
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x34
	.8byte	.LVL636
	.4byte	0x298f
	.4byte	0x28d2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 192
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL637
	.4byte	0xa94f
	.4byte	0x28f1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC79
	.byte	0
	.uleb128 0x34
	.8byte	.LVL638
	.4byte	0xa94f
	.4byte	0x2910
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC80
	.byte	0
	.uleb128 0x36
	.8byte	.LVL639
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC81
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL627
	.4byte	0xa94f
	.4byte	0x2957
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x7a
	.byte	0
	.uleb128 0x36
	.8byte	.LVL628
	.4byte	0x963e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x71
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x72
	.sleb128 0
	.uleb128 0x3e
	.4byte	0x2a98
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x298a
	.uleb128 0xe
	.4byte	0xda
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.4byte	0x297a
	.uleb128 0x3c
	.4byte	.LASF575
	.byte	0x1
	.byte	0x54
	.4byte	0xae
	.8byte	.LFB341
	.8byte	.LFE341-.LFB341
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2a88
	.uleb128 0x2e
	.4byte	.LASF566
	.byte	0x1
	.byte	0x54
	.4byte	0x12c
	.4byte	.LLST145
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0x54
	.4byte	0xb9
	.4byte	.LLST146
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0x54
	.4byte	0xb9
	.4byte	.LLST147
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.4byte	.LLST148
	.uleb128 0x3d
	.string	"cs"
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x32
	.4byte	.LASF276
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.4byte	.LLST149
	.uleb128 0x2b
	.4byte	.LASF569
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x32
	.4byte	.LASF570
	.byte	0x1
	.byte	0x57
	.4byte	0xb9
	.4byte	.LLST150
	.uleb128 0x39
	.string	"req"
	.byte	0x1
	.byte	0x58
	.4byte	0x1abc
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7615
	.uleb128 0x34
	.8byte	.LVL581
	.4byte	0xa94f
	.4byte	0x2a65
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x5c
	.byte	0
	.uleb128 0x36
	.8byte	.LVL582
	.4byte	0x963e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x71
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x72
	.sleb128 0
	.uleb128 0x3e
	.4byte	0x2a98
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x41
	.4byte	.LASF883
	.byte	0x1
	.byte	0x3a
	.4byte	0xb9
	.byte	0x1
	.4byte	0x2b07
	.uleb128 0x42
	.string	"req"
	.byte	0x1
	.byte	0x3a
	.4byte	0x1abc
	.uleb128 0x38
	.4byte	.LASF569
	.byte	0x1
	.byte	0x3a
	.4byte	0xe3e
	.uleb128 0x38
	.4byte	.LASF577
	.byte	0x1
	.byte	0x3a
	.4byte	0xe3e
	.uleb128 0x3a
	.4byte	.LASF578
	.byte	0x1
	.byte	0x3c
	.4byte	0xa3
	.uleb128 0x3a
	.4byte	.LASF579
	.byte	0x1
	.byte	0x3c
	.4byte	0xa3
	.uleb128 0x3a
	.4byte	.LASF285
	.byte	0x1
	.byte	0x3d
	.4byte	0xa3
	.uleb128 0x3a
	.4byte	.LASF286
	.byte	0x1
	.byte	0x3d
	.4byte	0xa3
	.uleb128 0x3a
	.4byte	.LASF580
	.byte	0x1
	.byte	0x3e
	.4byte	0xb9
	.uleb128 0x3a
	.4byte	.LASF277
	.byte	0x1
	.byte	0x3f
	.4byte	0xb9
	.uleb128 0x3a
	.4byte	.LASF581
	.byte	0x1
	.byte	0x40
	.4byte	0xb9
	.byte	0
	.uleb128 0x43
	.4byte	.LASF584
	.byte	0x1
	.byte	0x20
	.8byte	.LFB339
	.8byte	.LFE339-.LFB339
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2c10
	.uleb128 0x31
	.string	"s"
	.byte	0x1
	.byte	0x20
	.4byte	0xfa
	.4byte	.LLST136
	.uleb128 0x31
	.string	"buf"
	.byte	0x1
	.byte	0x20
	.4byte	0x12c
	.4byte	.LLST137
	.uleb128 0x2e
	.4byte	.LASF582
	.byte	0x1
	.byte	0x20
	.4byte	0x5b
	.4byte	.LLST138
	.uleb128 0x31
	.string	"len"
	.byte	0x1
	.byte	0x20
	.4byte	0x5b
	.4byte	.LLST139
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x22
	.4byte	0xb9
	.4byte	.LLST140
	.uleb128 0x33
	.string	"j"
	.byte	0x1
	.byte	0x22
	.4byte	0xb9
	.4byte	.LLST141
	.uleb128 0x33
	.string	"p8"
	.byte	0x1
	.byte	0x23
	.4byte	0xfa
	.4byte	.LLST142
	.uleb128 0x33
	.string	"p16"
	.byte	0x1
	.byte	0x24
	.4byte	0x2c10
	.4byte	.LLST143
	.uleb128 0x33
	.string	"p32"
	.byte	0x1
	.byte	0x25
	.4byte	0xe3e
	.4byte	.LLST144
	.uleb128 0x44
	.8byte	.LVL566
	.4byte	0xa94f
	.4byte	0x2bc3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC78
	.byte	0
	.uleb128 0x34
	.8byte	.LVL567
	.4byte	0xa94f
	.4byte	0x2be7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL568
	.4byte	0xa94f
	.uleb128 0x36
	.8byte	.LVL571
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC78
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x74
	.uleb128 0x2d
	.4byte	.LASF583
	.byte	0x1
	.byte	0x1b
	.4byte	0x12c
	.8byte	.LFB338
	.8byte	.LFE338-.LFB338
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2c67
	.uleb128 0x2e
	.4byte	.LASF30
	.byte	0x1
	.byte	0x1b
	.4byte	0x5b
	.4byte	.LLST135
	.uleb128 0x2f
	.8byte	.LVL558
	.4byte	0xa95a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x8
	.byte	0x20
	.byte	0x26
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x43
	.4byte	.LASF585
	.byte	0x1
	.byte	0x17
	.8byte	.LFB337
	.8byte	.LFE337-.LFB337
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2cca
	.uleb128 0x31
	.string	"buf"
	.byte	0x1
	.byte	0x17
	.4byte	0x12c
	.4byte	.LLST133
	.uleb128 0x46
	.4byte	0x2cca
	.8byte	.LBB229
	.8byte	.LBE229-.LBB229
	.byte	0x1
	.byte	0x19
	.uleb128 0x47
	.4byte	0x2cd6
	.4byte	.LLST134
	.uleb128 0x2f
	.8byte	.LVL556
	.4byte	0xa965
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x48
	.4byte	.LASF884
	.byte	0x6
	.byte	0x4e
	.byte	0x3
	.4byte	0x2ce2
	.uleb128 0x38
	.4byte	.LASF586
	.byte	0x6
	.byte	0x4e
	.4byte	0x16f
	.byte	0
	.uleb128 0x49
	.4byte	.LASF587
	.byte	0x5
	.2byte	0x2f4
	.4byte	0xb9
	.8byte	.LFB320
	.8byte	.LFE320-.LFB320
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2d1d
	.uleb128 0x2f
	.8byte	.LVL1926
	.4byte	0x2d1d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF589
	.byte	0x5
	.2byte	0x1d5
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2dea
	.uleb128 0x4b
	.4byte	.LASF590
	.byte	0x5
	.2byte	0x1d5
	.4byte	0xdd4
	.uleb128 0x4b
	.4byte	.LASF591
	.byte	0x5
	.2byte	0x1d5
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF592
	.byte	0x5
	.2byte	0x1d7
	.4byte	0xdc9
	.uleb128 0x4d
	.string	"lpa"
	.byte	0x5
	.2byte	0x1d8
	.4byte	0xdd4
	.uleb128 0x4d
	.string	"ppa"
	.byte	0x5
	.2byte	0x1d8
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF593
	.byte	0x5
	.2byte	0x1d9
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF299
	.byte	0x5
	.2byte	0x1da
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF594
	.byte	0x5
	.2byte	0x1da
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF595
	.byte	0x5
	.2byte	0x1da
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF596
	.byte	0x5
	.2byte	0x1da
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF597
	.byte	0x5
	.2byte	0x1db
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF598
	.byte	0x5
	.2byte	0x1dc
	.4byte	0x2dea
	.uleb128 0x4e
	.4byte	.LASF599
	.byte	0x5
	.2byte	0x272
	.uleb128 0x4e
	.4byte	.LASF600
	.byte	0x5
	.2byte	0x275
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x2e00
	.4byte	.LASF589
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF601
	.byte	0x5
	.2byte	0x1f3
	.4byte	0xdc9
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1238
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x2e00
	.uleb128 0xe
	.4byte	0xda
	.byte	0x16
	.byte	0
	.uleb128 0x7
	.4byte	0x2df0
	.uleb128 0x4a
	.4byte	.LASF602
	.byte	0x5
	.2byte	0x1a2
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2e65
	.uleb128 0x4d
	.string	"ret"
	.byte	0x5
	.2byte	0x1a4
	.4byte	0x5b
	.uleb128 0x4d
	.string	"i"
	.byte	0x5
	.2byte	0x1a5
	.4byte	0x5b
	.uleb128 0x4d
	.string	"ppa"
	.byte	0x5
	.2byte	0x1a6
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF564
	.byte	0x5
	.2byte	0x1a7
	.4byte	0x26fc
	.uleb128 0x51
	.4byte	0x2e56
	.uleb128 0x4c
	.4byte	.LASF603
	.byte	0x5
	.2byte	0x1b1
	.4byte	0xdf5
	.byte	0
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF604
	.byte	0x5
	.2byte	0x1c6
	.4byte	0xdd4
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF605
	.byte	0x5
	.2byte	0x185
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2eaf
	.uleb128 0x4b
	.4byte	.LASF606
	.byte	0x5
	.2byte	0x185
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF594
	.byte	0x5
	.2byte	0x187
	.4byte	0xdc9
	.uleb128 0x4d
	.string	"i"
	.byte	0x5
	.2byte	0x188
	.4byte	0xdc9
	.uleb128 0x4d
	.string	"j"
	.byte	0x5
	.2byte	0x188
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF388
	.byte	0x5
	.2byte	0x189
	.4byte	0xdc9
	.byte	0
	.uleb128 0x52
	.4byte	.LASF714
	.byte	0x5
	.2byte	0x17a
	.4byte	0x5b
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF607
	.byte	0x5
	.2byte	0x166
	.4byte	0x5b
	.8byte	.LFB315
	.8byte	.LFE315-.LFB315
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2f5e
	.uleb128 0x53
	.4byte	.LASF388
	.byte	0x5
	.2byte	0x166
	.4byte	0xdc9
	.4byte	.LLST130
	.uleb128 0x54
	.string	"i"
	.byte	0x5
	.2byte	0x168
	.4byte	0xdc9
	.4byte	.LLST131
	.uleb128 0x55
	.4byte	.LASF608
	.byte	0x5
	.2byte	0x169
	.4byte	0xdc9
	.4byte	.LLST132
	.uleb128 0x34
	.8byte	.LVL542
	.4byte	0x6d33
	.4byte	0x2f24
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL545
	.4byte	0xa94f
	.4byte	0x2f49
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC74
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL546
	.4byte	0x2f5e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF609
	.byte	0x5
	.2byte	0x158
	.4byte	0x5b
	.8byte	.LFB314
	.8byte	.LFE314-.LFB314
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2fb2
	.uleb128 0x53
	.4byte	.LASF586
	.byte	0x5
	.2byte	0x158
	.4byte	0xdc9
	.4byte	.LLST129
	.uleb128 0x36
	.8byte	.LVL538
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC73
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF610
	.byte	0x5
	.2byte	0x13b
	.4byte	0xdd4
	.8byte	.LFB313
	.8byte	.LFE313-.LFB313
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3078
	.uleb128 0x54
	.string	"i"
	.byte	0x5
	.2byte	0x13d
	.4byte	0xdc9
	.4byte	.LLST410
	.uleb128 0x55
	.4byte	.LASF598
	.byte	0x5
	.2byte	0x13e
	.4byte	0x2dea
	.4byte	.LLST411
	.uleb128 0x34
	.8byte	.LVL1808
	.4byte	0x27d2
	.4byte	0x300e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1810
	.4byte	0x3612
	.4byte	0x302c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x71
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1811
	.4byte	0x32fe
	.4byte	0x3043
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1813
	.4byte	0x75b1
	.uleb128 0x45
	.8byte	.LVL1814
	.4byte	0x7304
	.uleb128 0x45
	.8byte	.LVL1815
	.4byte	0x32a3
	.uleb128 0x45
	.8byte	.LVL1819
	.4byte	0x3503
	.byte	0
	.uleb128 0x49
	.4byte	.LASF611
	.byte	0x5
	.2byte	0x12b
	.4byte	0xdd4
	.8byte	.LFB312
	.8byte	.LFE312-.LFB312
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x311d
	.uleb128 0x34
	.8byte	.LVL1823
	.4byte	0x32fe
	.4byte	0x30b1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1824
	.4byte	0x3a23
	.4byte	0x30d0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1825
	.4byte	0x5d49
	.uleb128 0x34
	.8byte	.LVL1826
	.4byte	0x594e
	.4byte	0x30f4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1827
	.4byte	0x567a
	.uleb128 0x2f
	.8byte	.LVL1828
	.4byte	0x37d5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.byte	0
	.uleb128 0x56
	.4byte	.LASF670
	.byte	0x5
	.2byte	0x120
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF612
	.byte	0x5
	.byte	0xd2
	.4byte	0xdd4
	.8byte	.LFB310
	.8byte	.LFE310-.LFB310
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x32a3
	.uleb128 0x2e
	.4byte	.LASF613
	.byte	0x5
	.byte	0xd2
	.4byte	0x1eef
	.4byte	.LLST287
	.uleb128 0x2e
	.4byte	.LASF614
	.byte	0x5
	.byte	0xd2
	.4byte	0xdd4
	.4byte	.LLST288
	.uleb128 0x32
	.4byte	.LASF596
	.byte	0x5
	.byte	0xd4
	.4byte	0xdc9
	.4byte	.LLST289
	.uleb128 0x32
	.4byte	.LASF568
	.byte	0x5
	.byte	0xd5
	.4byte	0xdc9
	.4byte	.LLST290
	.uleb128 0x33
	.string	"req"
	.byte	0x5
	.byte	0xd5
	.4byte	0xdc9
	.4byte	.LLST291
	.uleb128 0x32
	.4byte	.LASF594
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST292
	.uleb128 0x32
	.4byte	.LASF382
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST293
	.uleb128 0x32
	.4byte	.LASF380
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST294
	.uleb128 0x32
	.4byte	.LASF615
	.byte	0x5
	.byte	0xd7
	.4byte	0xdd4
	.4byte	.LLST295
	.uleb128 0x32
	.4byte	.LASF616
	.byte	0x5
	.byte	0xd8
	.4byte	0xdd4
	.4byte	.LLST296
	.uleb128 0x57
	.4byte	.LASF617
	.byte	0x5
	.byte	0xd9
	.4byte	0xdd4
	.sleb128 -1
	.uleb128 0x32
	.4byte	.LASF598
	.byte	0x5
	.byte	0xda
	.4byte	0x2dea
	.4byte	.LLST297
	.uleb128 0x58
	.4byte	.LASF618
	.byte	0x5
	.byte	0xe1
	.uleb128 0x58
	.4byte	.LASF619
	.byte	0x5
	.byte	0xe5
	.uleb128 0x59
	.4byte	.LASF688
	.byte	0x5
	.2byte	0x117
	.8byte	.L879
	.uleb128 0x45
	.8byte	.LVL1178
	.4byte	0x32a3
	.uleb128 0x34
	.8byte	.LVL1186
	.4byte	0x298f
	.4byte	0x3243
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x8f
	.sleb128 204
	.byte	0x94
	.byte	0x4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1199
	.4byte	0x6d73
	.4byte	0x325d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x74
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1205
	.4byte	0x4ec4
	.4byte	0x327b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1208
	.4byte	0x3503
	.uleb128 0x45
	.8byte	.LVL1211
	.4byte	0x6951
	.uleb128 0x45
	.8byte	.LVL1213
	.4byte	0x32a3
	.byte	0
	.uleb128 0x43
	.4byte	.LASF620
	.byte	0x5
	.byte	0xc9
	.8byte	.LFB309
	.8byte	.LFE309-.LFB309
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x32fe
	.uleb128 0x34
	.8byte	.LVL1172
	.4byte	0x258a
	.4byte	0x32d8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1173
	.4byte	0x258a
	.4byte	0x32f0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x5a
	.8byte	.LVL1174
	.4byte	0x3666
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF621
	.byte	0x5
	.byte	0x6f
	.4byte	0x5b
	.8byte	.LFB308
	.8byte	.LFE308-.LFB308
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x34ee
	.uleb128 0x2e
	.4byte	.LASF622
	.byte	0x5
	.byte	0x6f
	.4byte	0x5b
	.4byte	.LLST405
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x71
	.4byte	0xdc9
	.4byte	.LLST406
	.uleb128 0x32
	.4byte	.LASF623
	.byte	0x5
	.byte	0x71
	.4byte	0xdc9
	.4byte	.LLST407
	.uleb128 0x2b
	.4byte	.LASF624
	.byte	0x5
	.byte	0x72
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x32
	.4byte	.LASF625
	.byte	0x5
	.byte	0x73
	.4byte	0xdd4
	.4byte	.LLST408
	.uleb128 0x2b
	.4byte	.LASF613
	.byte	0x5
	.byte	0x74
	.4byte	0x1eef
	.uleb128 0xa
	.byte	0x3
	.8byte	g_gc_temp_superblock
	.byte	0x9f
	.uleb128 0x32
	.4byte	.LASF626
	.byte	0x5
	.byte	0x75
	.4byte	0x1f34
	.4byte	.LLST409
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x34fe
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7245
	.uleb128 0x34
	.8byte	.LVL1770
	.4byte	0x3126
	.4byte	0x33be
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1772
	.4byte	0x594e
	.4byte	0x33d5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1773
	.4byte	0x75b1
	.uleb128 0x45
	.8byte	.LVL1774
	.4byte	0x7304
	.uleb128 0x34
	.8byte	.LVL1778
	.4byte	0xa94f
	.4byte	0x3421
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR171
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xa2
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1780
	.4byte	0x3691
	.4byte	0x3439
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1781
	.4byte	0x692c
	.uleb128 0x45
	.8byte	.LVL1783
	.4byte	0x5d49
	.uleb128 0x45
	.8byte	.LVL1784
	.4byte	0x567a
	.uleb128 0x34
	.8byte	.LVL1787
	.4byte	0xa94f
	.4byte	0x348b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xa8
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1788
	.4byte	0x5c1c
	.4byte	0x34a9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 188
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1789
	.4byte	0x6d33
	.uleb128 0x34
	.8byte	.LVL1792
	.4byte	0x5c1c
	.4byte	0x34d3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1794
	.4byte	0x3691
	.uleb128 0x45
	.8byte	.LVL1798
	.4byte	0x6951
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x34fe
	.uleb128 0xe
	.4byte	0xda
	.byte	0x12
	.byte	0
	.uleb128 0x7
	.4byte	0x34ee
	.uleb128 0x43
	.4byte	.LASF627
	.byte	0x5
	.byte	0x54
	.8byte	.LFB307
	.8byte	.LFE307-.LFB307
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3580
	.uleb128 0x2e
	.4byte	.LASF628
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST124
	.uleb128 0x2e
	.4byte	.LASF391
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST125
	.uleb128 0x31
	.string	"lpa"
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST126
	.uleb128 0x32
	.4byte	.LASF629
	.byte	0x5
	.byte	0x56
	.4byte	0xdc9
	.4byte	.LLST127
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x57
	.4byte	0xdc9
	.4byte	.LLST128
	.uleb128 0x36
	.8byte	.LVL526
	.4byte	0x6d33
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x76
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF630
	.byte	0x5
	.byte	0x49
	.4byte	0xdd4
	.8byte	.LFB306
	.8byte	.LFE306-.LFB306
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x35be
	.uleb128 0x31
	.string	"blk"
	.byte	0x5
	.byte	0x49
	.4byte	0xdc9
	.4byte	.LLST122
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x4b
	.4byte	0xdc9
	.4byte	.LLST123
	.byte	0
	.uleb128 0x43
	.4byte	.LASF631
	.byte	0x5
	.byte	0x38
	.8byte	.LFB305
	.8byte	.LFE305-.LFB305
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3612
	.uleb128 0x5b
	.string	"req"
	.byte	0x5
	.byte	0x38
	.4byte	0x1abc
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5c
	.4byte	.LASF632
	.byte	0x5
	.byte	0x38
	.4byte	0xdd4
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x3a
	.4byte	0xdc9
	.4byte	.LLST120
	.uleb128 0x32
	.4byte	.LASF633
	.byte	0x5
	.byte	0x3b
	.4byte	0xdc9
	.4byte	.LLST121
	.byte	0
	.uleb128 0x43
	.4byte	.LASF634
	.byte	0x5
	.byte	0x29
	.8byte	.LFB304
	.8byte	.LFE304-.LFB304
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3666
	.uleb128 0x5b
	.string	"req"
	.byte	0x5
	.byte	0x29
	.4byte	0x1abc
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5c
	.4byte	.LASF632
	.byte	0x5
	.byte	0x29
	.4byte	0xdd4
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x2b
	.4byte	0xdc9
	.4byte	.LLST118
	.uleb128 0x32
	.4byte	.LASF633
	.byte	0x5
	.byte	0x2c
	.4byte	0xdc9
	.4byte	.LLST119
	.byte	0
	.uleb128 0x43
	.4byte	.LASF635
	.byte	0x5
	.byte	0x15
	.8byte	.LFB303
	.8byte	.LFE303-.LFB303
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3691
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x17
	.4byte	0xdc9
	.4byte	.LLST117
	.byte	0
	.uleb128 0x49
	.4byte	.LASF636
	.byte	0x2
	.2byte	0xac6
	.4byte	0x5b
	.8byte	.LFB302
	.8byte	.LFE302-.LFB302
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3780
	.uleb128 0x53
	.4byte	.LASF623
	.byte	0x2
	.2byte	0xac6
	.4byte	0xdc9
	.4byte	.LLST324
	.uleb128 0x54
	.string	"ret"
	.byte	0x2
	.2byte	0xac8
	.4byte	0x5b
	.4byte	.LLST325
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x3790
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7175
	.uleb128 0x34
	.8byte	.LVL1343
	.4byte	0xa94f
	.4byte	0x3710
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC101
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1348
	.4byte	0xa94f
	.4byte	0x3743
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR159
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xacd
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1349
	.4byte	0x3795
	.uleb128 0x36
	.8byte	.LVL1351
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR159
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xadd
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x3790
	.uleb128 0xe
	.4byte	0xda
	.byte	0x13
	.byte	0
	.uleb128 0x7
	.4byte	0x3780
	.uleb128 0x4a
	.4byte	.LASF637
	.byte	0x2
	.2byte	0xab1
	.4byte	0x5b
	.byte	0x1
	.4byte	0x37c0
	.uleb128 0x4b
	.4byte	.LASF623
	.byte	0x2
	.2byte	0xab1
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x37d0
	.4byte	.LASF637
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x37d0
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.4byte	0x37c0
	.uleb128 0x49
	.4byte	.LASF638
	.byte	0x2
	.2byte	0xa91
	.4byte	0xdd4
	.8byte	.LFB300
	.8byte	.LFE300-.LFB300
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3903
	.uleb128 0x53
	.4byte	.LASF639
	.byte	0x2
	.2byte	0xa91
	.4byte	0x1eef
	.4byte	.LLST114
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x2
	.2byte	0xa93
	.4byte	0xdc9
	.4byte	.LLST115
	.uleb128 0x55
	.4byte	.LASF640
	.byte	0x2
	.2byte	0xa94
	.4byte	0xdd4
	.4byte	.LLST116
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x34fe
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7155
	.uleb128 0x34
	.8byte	.LVL485
	.4byte	0xa94f
	.4byte	0x386d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa96
	.byte	0
	.uleb128 0x34
	.8byte	.LVL486
	.4byte	0xa94f
	.4byte	0x38a0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa97
	.byte	0
	.uleb128 0x34
	.8byte	.LVL487
	.4byte	0xa94f
	.4byte	0x38d3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa98
	.byte	0
	.uleb128 0x36
	.8byte	.LVL491
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xaad
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF641
	.byte	0x2
	.2byte	0xa79
	.4byte	0x5b
	.8byte	.LFB299
	.8byte	.LFE299-.LFB299
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3a0e
	.uleb128 0x53
	.4byte	.LASF639
	.byte	0x2
	.2byte	0xa79
	.4byte	0x1eef
	.4byte	.LLST396
	.uleb128 0x55
	.4byte	.LASF623
	.byte	0x2
	.2byte	0xa7b
	.4byte	0xdc9
	.4byte	.LLST397
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x3a1e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7148
	.uleb128 0x34
	.8byte	.LVL1732
	.4byte	0xa94f
	.4byte	0x398b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR169
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa7c
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1733
	.4byte	0x692c
	.4byte	0x39a3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1734
	.4byte	0x3795
	.uleb128 0x34
	.8byte	.LVL1735
	.4byte	0x3a23
	.4byte	0x39c8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1736
	.4byte	0x5d49
	.uleb128 0x34
	.8byte	.LVL1737
	.4byte	0x594e
	.4byte	0x39ec
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1738
	.4byte	0x567a
	.uleb128 0x36
	.8byte	.LVL1742
	.4byte	0x6951
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x3a1e
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1c
	.byte	0
	.uleb128 0x7
	.4byte	0x3a0e
	.uleb128 0x49
	.4byte	.LASF642
	.byte	0x2
	.2byte	0xa15
	.4byte	0x5b
	.8byte	.LFB298
	.8byte	.LFE298-.LFB298
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3d4e
	.uleb128 0x5d
	.string	"p"
	.byte	0x2
	.2byte	0xa15
	.4byte	0x1eef
	.4byte	.LLST311
	.uleb128 0x55
	.4byte	.LASF643
	.byte	0x2
	.2byte	0xa17
	.4byte	0xdc9
	.4byte	.LLST312
	.uleb128 0x4c
	.4byte	.LASF594
	.byte	0x2
	.2byte	0xa18
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF568
	.byte	0x2
	.2byte	0xa18
	.4byte	0xdc9
	.4byte	.LLST313
	.uleb128 0x54
	.string	"n"
	.byte	0x2
	.2byte	0xa18
	.4byte	0xdc9
	.4byte	.LLST314
	.uleb128 0x4c
	.4byte	.LASF596
	.byte	0x2
	.2byte	0xa18
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF644
	.byte	0x2
	.2byte	0xa19
	.4byte	0x5b
	.4byte	.LLST315
	.uleb128 0x55
	.4byte	.LASF645
	.byte	0x2
	.2byte	0xa1a
	.4byte	0xdc9
	.4byte	.LLST316
	.uleb128 0x4e
	.4byte	.LASF646
	.byte	0x2
	.2byte	0xa1b
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x3d5e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7127
	.uleb128 0x5e
	.4byte	0x53f4
	.8byte	.LBB283
	.8byte	.LBE283-.LBB283
	.byte	0x2
	.2byte	0xa4b
	.4byte	0x3b1e
	.uleb128 0x47
	.4byte	0x540d
	.4byte	.LLST317
	.uleb128 0x47
	.4byte	0x5401
	.4byte	.LLST318
	.uleb128 0x36
	.8byte	.LVL1299
	.4byte	0x96a0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x3e
	.4byte	0x540d
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1271
	.4byte	0xa94f
	.4byte	0x3b51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa1c
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1275
	.4byte	0x66d0
	.4byte	0x3b70
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR47
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1277
	.4byte	0xa94f
	.4byte	0x3ba3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1278
	.4byte	0x45ef
	.4byte	0x3bbb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1279
	.4byte	0x692c
	.4byte	0x3bd3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1280
	.4byte	0xa94f
	.4byte	0x3c06
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1283
	.4byte	0xa94f
	.4byte	0x3c39
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa33
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1285
	.4byte	0xa94f
	.4byte	0x3c6c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa3e
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1286
	.4byte	0xa94f
	.4byte	0x3c9f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1287
	.4byte	0x53f4
	.4byte	0x3cbc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1290
	.4byte	0x270c
	.4byte	0x3cd4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1292
	.4byte	0x3ef1
	.4byte	0x3cec
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1293
	.4byte	0x7304
	.uleb128 0x34
	.8byte	.LVL1294
	.4byte	0x692c
	.4byte	0x3d11
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1304
	.4byte	0x75b1
	.uleb128 0x36
	.8byte	.LVL1308
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR157
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa75
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x3d5e
	.uleb128 0xe
	.4byte	0xda
	.byte	0x18
	.byte	0
	.uleb128 0x7
	.4byte	0x3d4e
	.uleb128 0x4a
	.4byte	.LASF647
	.byte	0x2
	.2byte	0xa0c
	.4byte	0x5b
	.byte	0x1
	.4byte	0x3d81
	.uleb128 0x4b
	.4byte	.LASF623
	.byte	0x2
	.2byte	0xa0c
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF648
	.byte	0x2
	.2byte	0x9c3
	.4byte	0xdc9
	.8byte	.LFB296
	.8byte	.LFE296-.LFB296
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3e5d
	.uleb128 0x55
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x9c5
	.4byte	0xdc9
	.4byte	.LLST104
	.uleb128 0x55
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x9c6
	.4byte	0xdc9
	.4byte	.LLST105
	.uleb128 0x55
	.4byte	.LASF651
	.byte	0x2
	.2byte	0x9c7
	.4byte	0xdc9
	.4byte	.LLST106
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x9c8
	.4byte	0x1e17
	.4byte	.LLST107
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x9c9
	.4byte	0xdc9
	.4byte	.LLST108
	.uleb128 0x55
	.4byte	.LASF654
	.byte	0x2
	.2byte	0x9ca
	.4byte	0xdc9
	.4byte	.LLST109
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x9cb
	.4byte	0xdd4
	.4byte	.LLST110
	.uleb128 0x55
	.4byte	.LASF325
	.byte	0x2
	.2byte	0x9cc
	.4byte	0xdc9
	.4byte	.LLST111
	.uleb128 0x45
	.8byte	.LVL462
	.4byte	0x3e5d
	.uleb128 0x45
	.8byte	.LVL468
	.4byte	0x3ebe
	.uleb128 0x36
	.8byte	.LVL470
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC72
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF655
	.byte	0x2
	.2byte	0x9ae
	.4byte	0xdc9
	.8byte	.LFB295
	.8byte	.LFE295-.LFB295
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3ebe
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x9ae
	.4byte	0xdc9
	.4byte	.LLST93
	.uleb128 0x55
	.4byte	.LASF656
	.byte	0x2
	.2byte	0x9b0
	.4byte	0xdc9
	.4byte	.LLST94
	.uleb128 0x55
	.4byte	.LASF586
	.byte	0x2
	.2byte	0x9b1
	.4byte	0xdc9
	.4byte	.LLST95
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x9b2
	.4byte	0xdc9
	.4byte	.LLST96
	.byte	0
	.uleb128 0x49
	.4byte	.LASF657
	.byte	0x2
	.2byte	0x9a5
	.4byte	0xdc9
	.8byte	.LFB294
	.8byte	.LFE294-.LFB294
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3ef1
	.uleb128 0x55
	.4byte	.LASF651
	.byte	0x2
	.2byte	0x9a7
	.4byte	0xdc9
	.4byte	.LLST92
	.byte	0
	.uleb128 0x49
	.4byte	.LASF658
	.byte	0x2
	.2byte	0x995
	.4byte	0x5b
	.8byte	.LFB293
	.8byte	.LFE293-.LFB293
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3f79
	.uleb128 0x53
	.4byte	.LASF623
	.byte	0x2
	.2byte	0x995
	.4byte	0xdc9
	.4byte	.LLST88
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x997
	.4byte	0xdc9
	.4byte	.LLST89
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x2
	.2byte	0x997
	.4byte	0xdc9
	.4byte	.LLST90
	.uleb128 0x55
	.4byte	.LASF375
	.byte	0x2
	.2byte	0x998
	.4byte	0xdc9
	.4byte	.LLST91
	.uleb128 0x34
	.8byte	.LVL270
	.4byte	0x6dce
	.4byte	0x3f6b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL271
	.4byte	0x7522
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF659
	.byte	0x2
	.2byte	0x933
	.4byte	0x5b
	.byte	0x1
	.4byte	0x3fa3
	.uleb128 0x4d
	.string	"i"
	.byte	0x2
	.2byte	0x935
	.4byte	0x5b
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF613
	.byte	0x2
	.2byte	0x95a
	.4byte	0x1eef
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF660
	.byte	0x2
	.2byte	0x914
	.8byte	.LFB291
	.8byte	.LFE291-.LFB291
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x40a7
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x916
	.4byte	0x5b
	.4byte	.LLST250
	.uleb128 0x60
	.string	"ppa"
	.byte	0x2
	.2byte	0x917
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF661
	.byte	0x2
	.2byte	0x918
	.4byte	0x2dea
	.4byte	.LLST251
	.uleb128 0x34
	.8byte	.LVL958
	.4byte	0xa94f
	.4byte	0x4013
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC91
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL961
	.4byte	0x5c1c
	.4byte	0x4037
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 140
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL962
	.4byte	0xa94f
	.4byte	0x405c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC92
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL964
	.4byte	0x298f
	.4byte	0x4085
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL965
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC93
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF662
	.byte	0x2
	.2byte	0x8e0
	.8byte	.LFB290
	.8byte	.LFE290-.LFB290
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4229
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x8e2
	.4byte	0xdc9
	.4byte	.LLST282
	.uleb128 0x54
	.string	"lpn"
	.byte	0x2
	.2byte	0x8e3
	.4byte	0xdd4
	.4byte	.LLST283
	.uleb128 0x2a
	.4byte	.LASF663
	.byte	0x2
	.2byte	0x8e4
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x54
	.string	"blk"
	.byte	0x2
	.2byte	0x8e5
	.4byte	0xdc9
	.4byte	.LLST284
	.uleb128 0x55
	.4byte	.LASF664
	.byte	0x2
	.2byte	0x8e6
	.4byte	0xdc9
	.4byte	.LLST285
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4239
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7042
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x210
	.4byte	0x4159
	.uleb128 0x55
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x903
	.4byte	0xdc9
	.4byte	.LLST286
	.uleb128 0x36
	.8byte	.LVL1167
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1145
	.4byte	0xa94f
	.4byte	0x4185
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC94
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR155
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1146
	.4byte	0x258a
	.4byte	0x41aa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2000
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1154
	.4byte	0xa94f
	.4byte	0x41dd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR155
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x911
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1156
	.4byte	0x5c1c
	.4byte	0x4201
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 188
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1157
	.4byte	0x6d33
	.uleb128 0x36
	.8byte	.LVL1161
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x4239
	.uleb128 0xe
	.4byte	0xda
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.4byte	0x4229
	.uleb128 0x5f
	.4byte	.LASF665
	.byte	0x2
	.2byte	0x8c1
	.8byte	.LFB289
	.8byte	.LFE289-.LFB289
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4372
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x8c3
	.4byte	0xdc9
	.4byte	.LLST393
	.uleb128 0x54
	.string	"lpn"
	.byte	0x2
	.2byte	0x8c4
	.4byte	0xdd4
	.4byte	.LLST394
	.uleb128 0x2a
	.4byte	.LASF663
	.byte	0x2
	.2byte	0x8c5
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x54
	.string	"blk"
	.byte	0x2
	.2byte	0x8c6
	.4byte	0xdc9
	.4byte	.LLST395
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4382
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7026
	.uleb128 0x34
	.8byte	.LVL1712
	.4byte	0xa94f
	.4byte	0x42d8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC94
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR168
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1713
	.4byte	0x258a
	.4byte	0x42f0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1718
	.4byte	0x5c1c
	.4byte	0x4314
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 156
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1719
	.4byte	0x6d33
	.uleb128 0x34
	.8byte	.LVL1723
	.4byte	0xa94f
	.4byte	0x433f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1724
	.4byte	0x3795
	.4byte	0x4357
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1725
	.4byte	0x5d49
	.uleb128 0x45
	.8byte	.LVL1726
	.4byte	0x567a
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x4382
	.uleb128 0xe
	.4byte	0xda
	.byte	0x14
	.byte	0
	.uleb128 0x7
	.4byte	0x4372
	.uleb128 0x5f
	.4byte	.LASF666
	.byte	0x2
	.2byte	0x89c
	.8byte	.LFB288
	.8byte	.LFE288-.LFB288
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x443f
	.uleb128 0x53
	.4byte	.LASF613
	.byte	0x2
	.2byte	0x89c
	.4byte	0x1eef
	.4byte	.LLST355
	.uleb128 0x2a
	.4byte	.LASF667
	.byte	0x2
	.2byte	0x89e
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x55
	.4byte	.LASF598
	.byte	0x2
	.2byte	0x89f
	.4byte	0x2dea
	.4byte	.LLST356
	.uleb128 0x55
	.4byte	.LASF668
	.byte	0x2
	.2byte	0x8a0
	.4byte	0x5b
	.4byte	.LLST357
	.uleb128 0x61
	.4byte	.LASF384
	.byte	0x2
	.2byte	0x8a1
	.4byte	0xdd4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1521
	.4byte	0x37d5
	.4byte	0x4409
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1522
	.4byte	0x27d2
	.4byte	0x4431
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 80
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1523
	.4byte	0x3691
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF669
	.byte	0x2
	.2byte	0x882
	.8byte	.LFB287
	.8byte	.LFE287-.LFB287
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x44a0
	.uleb128 0x34
	.8byte	.LVL1663
	.4byte	0x59b6
	.4byte	0x447f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1664
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x200
	.byte	0
	.byte	0
	.uleb128 0x56
	.4byte	.LASF671
	.byte	0x2
	.2byte	0x86e
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF672
	.byte	0x2
	.2byte	0x843
	.4byte	0x5b
	.8byte	.LFB285
	.8byte	.LFE285-.LFB285
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x45da
	.uleb128 0x55
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x845
	.4byte	0xdc9
	.4byte	.LLST276
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x845
	.4byte	0xdc9
	.4byte	.LLST277
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x2
	.2byte	0x845
	.4byte	0xdc9
	.4byte	.LLST278
	.uleb128 0x55
	.4byte	.LASF375
	.byte	0x2
	.2byte	0x845
	.4byte	0xdc9
	.4byte	.LLST279
	.uleb128 0x55
	.4byte	.LASF673
	.byte	0x2
	.2byte	0x846
	.4byte	0xdc9
	.4byte	.LLST280
	.uleb128 0x55
	.4byte	.LASF674
	.byte	0x2
	.2byte	0x846
	.4byte	0xdc9
	.4byte	.LLST281
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x45ea
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7001
	.uleb128 0x34
	.8byte	.LVL1119
	.4byte	0x258a
	.4byte	0x4555
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1123
	.4byte	0x6dce
	.4byte	0x456d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1124
	.4byte	0x7522
	.uleb128 0x34
	.8byte	.LVL1131
	.4byte	0x6951
	.4byte	0x4592
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1139
	.4byte	0x692c
	.4byte	0x45aa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1141
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR154
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x86a
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x45ea
	.uleb128 0xe
	.4byte	0xda
	.byte	0x11
	.byte	0
	.uleb128 0x7
	.4byte	0x45da
	.uleb128 0x49
	.4byte	.LASF675
	.byte	0x2
	.2byte	0x82d
	.4byte	0x5b
	.8byte	.LFB284
	.8byte	.LFE284-.LFB284
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x46a7
	.uleb128 0x5d
	.string	"p"
	.byte	0x2
	.2byte	0x82d
	.4byte	0x1eef
	.4byte	.LLST85
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x82f
	.4byte	0xdc9
	.4byte	.LLST86
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x2
	.2byte	0x82f
	.4byte	0xdc9
	.4byte	.LLST87
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x37d0
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6980
	.uleb128 0x34
	.8byte	.LVL253
	.4byte	0xa94f
	.4byte	0x4685
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR60
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x831
	.byte	0
	.uleb128 0x45
	.8byte	.LVL257
	.4byte	0x6dce
	.uleb128 0x36
	.8byte	.LVL259
	.4byte	0x7522
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF676
	.byte	0x2
	.2byte	0x820
	.4byte	0x5b
	.8byte	.LFB283
	.8byte	.LFE283-.LFB283
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x474b
	.uleb128 0x34
	.8byte	.LVL1802
	.4byte	0x4771
	.4byte	0x46e1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1803
	.4byte	0x474b
	.4byte	0x46f9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1804
	.4byte	0x4771
	.4byte	0x4711
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1805
	.4byte	0x474b
	.4byte	0x4729
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1806
	.4byte	0x311d
	.uleb128 0x36
	.8byte	.LVL1807
	.4byte	0x3691
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x62
	.4byte	.LASF712
	.byte	0x2
	.2byte	0x80d
	.byte	0x1
	.4byte	0x4771
	.uleb128 0x4b
	.4byte	.LASF639
	.byte	0x2
	.2byte	0x80d
	.4byte	0x1eef
	.uleb128 0x4c
	.4byte	.LASF596
	.byte	0x2
	.2byte	0x80f
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF677
	.byte	0x2
	.2byte	0x6a8
	.4byte	0x5b
	.8byte	.LFB281
	.8byte	.LFE281-.LFB281
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4d6e
	.uleb128 0x53
	.4byte	.LASF613
	.byte	0x2
	.2byte	0x6a8
	.4byte	0x1eef
	.4byte	.LLST330
	.uleb128 0x55
	.4byte	.LASF678
	.byte	0x2
	.2byte	0x6aa
	.4byte	0xdc9
	.4byte	.LLST331
	.uleb128 0x55
	.4byte	.LASF679
	.byte	0x2
	.2byte	0x6aa
	.4byte	0xdc9
	.4byte	.LLST332
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x6ab
	.4byte	0xdc9
	.4byte	.LLST333
	.uleb128 0x55
	.4byte	.LASF382
	.byte	0x2
	.2byte	0x6ab
	.4byte	0xdc9
	.4byte	.LLST334
	.uleb128 0x55
	.4byte	.LASF380
	.byte	0x2
	.2byte	0x6ab
	.4byte	0xdc9
	.4byte	.LLST335
	.uleb128 0x55
	.4byte	.LASF680
	.byte	0x2
	.2byte	0x6ac
	.4byte	0xdc9
	.4byte	.LLST336
	.uleb128 0x55
	.4byte	.LASF681
	.byte	0x2
	.2byte	0x6ac
	.4byte	0xdc9
	.4byte	.LLST337
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x2
	.2byte	0x6ad
	.4byte	0xdc9
	.4byte	.LLST338
	.uleb128 0x55
	.4byte	.LASF682
	.byte	0x2
	.2byte	0x6ae
	.4byte	0x5b
	.4byte	.LLST339
	.uleb128 0x55
	.4byte	.LASF683
	.byte	0x2
	.2byte	0x6ae
	.4byte	0x5b
	.4byte	.LLST339
	.uleb128 0x55
	.4byte	.LASF568
	.byte	0x2
	.2byte	0x6af
	.4byte	0xdc9
	.4byte	.LLST341
	.uleb128 0x54
	.string	"n"
	.byte	0x2
	.2byte	0x6af
	.4byte	0xdc9
	.4byte	.LLST342
	.uleb128 0x54
	.string	"req"
	.byte	0x2
	.2byte	0x6af
	.4byte	0xdc9
	.4byte	.LLST343
	.uleb128 0x60
	.string	"lpa"
	.byte	0x2
	.2byte	0x6b0
	.4byte	0xdd4
	.uleb128 0x1
	.byte	0x68
	.uleb128 0x2a
	.4byte	.LASF663
	.byte	0x2
	.2byte	0x6b0
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x2a
	.4byte	.LASF624
	.byte	0x2
	.2byte	0x6b0
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x2a
	.4byte	.LASF615
	.byte	0x2
	.2byte	0x6b0
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF629
	.byte	0x2
	.2byte	0x6b1
	.4byte	0xdc9
	.4byte	.LLST344
	.uleb128 0x55
	.4byte	.LASF684
	.byte	0x2
	.2byte	0x6b1
	.4byte	0xdc9
	.4byte	.LLST345
	.uleb128 0x55
	.4byte	.LASF685
	.byte	0x2
	.2byte	0x6b2
	.4byte	0xdd4
	.4byte	.LLST346
	.uleb128 0x55
	.4byte	.LASF686
	.byte	0x2
	.2byte	0x6b3
	.4byte	0xdc9
	.4byte	.LLST347
	.uleb128 0x55
	.4byte	.LASF598
	.byte	0x2
	.2byte	0x6b4
	.4byte	0x2dea
	.4byte	.LLST348
	.uleb128 0x61
	.4byte	.LASF687
	.byte	0x2
	.2byte	0x6b5
	.4byte	0xdd4
	.byte	0
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4d7e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6923
	.uleb128 0x59
	.4byte	.LASF689
	.byte	0x2
	.2byte	0x744
	.8byte	.L1038
	.uleb128 0x59
	.4byte	.LASF619
	.byte	0x2
	.2byte	0x74c
	.8byte	.L1053
	.uleb128 0x59
	.4byte	.LASF690
	.byte	0x2
	.2byte	0x7ff
	.8byte	.L1059
	.uleb128 0x4e
	.4byte	.LASF691
	.byte	0x2
	.2byte	0x809
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x2b0
	.4byte	0x4991
	.uleb128 0x55
	.4byte	.LASF692
	.byte	0x2
	.2byte	0x71c
	.4byte	0xdd4
	.4byte	.LLST349
	.uleb128 0x55
	.4byte	.LASF693
	.byte	0x2
	.2byte	0x71d
	.4byte	0xdd4
	.4byte	.LLST350
	.uleb128 0x36
	.8byte	.LVL1432
	.4byte	0x298f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x2e0
	.4byte	0x4a8c
	.uleb128 0x55
	.4byte	.LASF694
	.byte	0x2
	.2byte	0x777
	.4byte	0xdd4
	.4byte	.LLST351
	.uleb128 0x55
	.4byte	.LASF695
	.byte	0x2
	.2byte	0x778
	.4byte	0xdd4
	.4byte	.LLST352
	.uleb128 0x34
	.8byte	.LVL1475
	.4byte	0x298f
	.4byte	0x49d6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1477
	.4byte	0x3691
	.uleb128 0x34
	.8byte	.LVL1483
	.4byte	0x5c1c
	.4byte	0x4a07
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 340
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1486
	.4byte	0x6ce4
	.4byte	0x4a22
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x8f
	.sleb128 296
	.byte	0x94
	.byte	0x4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1487
	.4byte	0x4d83
	.4byte	0x4a3a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1489
	.4byte	0x298f
	.4byte	0x4a56
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1492
	.4byte	0x6ce4
	.4byte	0x4a6e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1493
	.4byte	0x6ce4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5
	.byte	0x8f
	.sleb128 296
	.byte	0x94
	.byte	0x4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x63
	.8byte	.LBB310
	.8byte	.LBE310-.LBB310
	.4byte	0x4b16
	.uleb128 0x55
	.4byte	.LASF696
	.byte	0x2
	.2byte	0x7b6
	.4byte	0xdd4
	.4byte	.LLST353
	.uleb128 0x55
	.4byte	.LASF695
	.byte	0x2
	.2byte	0x7b7
	.4byte	0xdd4
	.4byte	.LLST354
	.uleb128 0x34
	.8byte	.LVL1501
	.4byte	0x298f
	.4byte	0x4add
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1502
	.4byte	0x6ce4
	.4byte	0x4af5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1503
	.4byte	0x5c1c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 344
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1380
	.4byte	0x6c07
	.4byte	0x4b2d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1385
	.4byte	0x298f
	.4byte	0x4b4a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1390
	.4byte	0x6d73
	.uleb128 0x34
	.8byte	.LVL1393
	.4byte	0x4ec4
	.4byte	0x4b7b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1401
	.4byte	0xa94f
	.4byte	0x4bae
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR160
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x6db
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1402
	.4byte	0xa94f
	.4byte	0x4be1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR160
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x6dc
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1411
	.4byte	0x6ce4
	.4byte	0x4bf9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1437
	.4byte	0x5875
	.4byte	0x4c18
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1440
	.4byte	0x298f
	.4byte	0x4c35
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1461
	.4byte	0x6d73
	.4byte	0x4c4f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x75
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1468
	.4byte	0x3691
	.uleb128 0x34
	.8byte	.LVL1471
	.4byte	0x6ce4
	.4byte	0x4c74
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1472
	.4byte	0x5c1c
	.4byte	0x4c98
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 344
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1473
	.4byte	0x6ce4
	.4byte	0x4cb0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1478
	.4byte	0x6d33
	.4byte	0x4cca
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x73
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1480
	.4byte	0xa94f
	.4byte	0x4cfd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR160
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x7d6
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1495
	.4byte	0x5c1c
	.4byte	0x4d21
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 348
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1496
	.4byte	0x6d33
	.4byte	0x4d3b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x73
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1505
	.4byte	0xa94f
	.4byte	0x4d60
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC102
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1507
	.4byte	0x3691
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x4d7e
	.uleb128 0xe
	.4byte	0xda
	.byte	0x15
	.byte	0
	.uleb128 0x7
	.4byte	0x4d6e
	.uleb128 0x5f
	.4byte	.LASF697
	.byte	0x2
	.2byte	0x68c
	.8byte	.LFB280
	.8byte	.LFE280-.LFB280
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4ec4
	.uleb128 0x5d
	.string	"lpa"
	.byte	0x2
	.2byte	0x68c
	.4byte	0xdd4
	.4byte	.LLST244
	.uleb128 0x53
	.4byte	.LASF663
	.byte	0x2
	.2byte	0x68c
	.4byte	0xdd4
	.4byte	.LLST245
	.uleb128 0x55
	.4byte	.LASF629
	.byte	0x2
	.2byte	0x68e
	.4byte	0xdc9
	.4byte	.LLST246
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x37d0
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6889
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x190
	.4byte	0x4e88
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x692
	.4byte	0xdc9
	.4byte	.LLST247
	.uleb128 0x55
	.4byte	.LASF586
	.byte	0x2
	.2byte	0x693
	.4byte	0xdc9
	.4byte	.LLST248
	.uleb128 0x55
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x694
	.4byte	0xdc9
	.4byte	.LLST249
	.uleb128 0x34
	.8byte	.LVL946
	.4byte	0x6747
	.4byte	0x4e40
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR47
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL947
	.4byte	0xa94f
	.4byte	0x4e73
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR146
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x698
	.byte	0
	.uleb128 0x36
	.8byte	.LVL948
	.4byte	0x692c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL940
	.4byte	0x6d33
	.4byte	0x4ea3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x36
	.8byte	.LVL950
	.4byte	0x5c1c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 124
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF698
	.byte	0x2
	.2byte	0x678
	.8byte	.LFB279
	.8byte	.LFE279-.LFB279
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4f21
	.uleb128 0x64
	.4byte	.LASF613
	.byte	0x2
	.2byte	0x678
	.4byte	0x1eef
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x53
	.4byte	.LASF380
	.byte	0x2
	.2byte	0x678
	.4byte	0xdc9
	.4byte	.LLST80
	.uleb128 0x53
	.4byte	.LASF382
	.byte	0x2
	.2byte	0x678
	.4byte	0xdc9
	.4byte	.LLST81
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x67a
	.4byte	0xdc9
	.4byte	.LLST82
	.byte	0
	.uleb128 0x49
	.4byte	.LASF699
	.byte	0x2
	.2byte	0x66f
	.4byte	0x5b
	.8byte	.LFB278
	.8byte	.LFE278-.LFB278
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4f6c
	.uleb128 0x45
	.8byte	.LVL1110
	.4byte	0x4f6c
	.uleb128 0x36
	.8byte	.LVL1111
	.4byte	0x5004
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF700
	.byte	0x2
	.2byte	0x658
	.8byte	.LFB277
	.8byte	.LFE277-.LFB277
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4fc6
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x65a
	.4byte	0xdc9
	.4byte	.LLST275
	.uleb128 0x34
	.8byte	.LVL1107
	.4byte	0x258a
	.4byte	0x4fb1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1108
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF701
	.byte	0x2
	.2byte	0x648
	.4byte	0x5b
	.8byte	.LFB276
	.8byte	.LFE276-.LFB276
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5004
	.uleb128 0x36
	.8byte	.LVL1106
	.4byte	0x5004
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR149
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF702
	.byte	0x2
	.2byte	0x5ea
	.4byte	0x5b
	.8byte	.LFB275
	.8byte	.LFE275-.LFB275
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x51d6
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x5ea
	.4byte	0x51d6
	.4byte	.LLST264
	.uleb128 0x55
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x5ec
	.4byte	0xdea
	.4byte	.LLST265
	.uleb128 0x55
	.4byte	.LASF299
	.byte	0x2
	.2byte	0x5ec
	.4byte	0xdea
	.4byte	.LLST266
	.uleb128 0x55
	.4byte	.LASF705
	.byte	0x2
	.2byte	0x5ed
	.4byte	0xdea
	.4byte	.LLST267
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x5ee
	.4byte	0xdc9
	.4byte	.LLST268
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x5ef
	.4byte	0x1001
	.4byte	.LLST269
	.uleb128 0x55
	.4byte	.LASF310
	.byte	0x2
	.2byte	0x5f0
	.4byte	0x10f8
	.4byte	.LLST270
	.uleb128 0x55
	.4byte	.LASF311
	.byte	0x2
	.2byte	0x5f1
	.4byte	0x1001
	.4byte	.LLST271
	.uleb128 0x55
	.4byte	.LASF307
	.byte	0x2
	.2byte	0x5f2
	.4byte	0xdc9
	.4byte	.LLST272
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x5f3
	.4byte	0xdc9
	.4byte	.LLST273
	.uleb128 0x55
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x5f4
	.4byte	0x51dc
	.4byte	.LLST274
	.uleb128 0x34
	.8byte	.LVL1066
	.4byte	0x258a
	.4byte	0x50fc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x4
	.byte	0x87
	.sleb128 0
	.byte	0x32
	.byte	0x24
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1071
	.4byte	0x6c07
	.4byte	0x5113
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1076
	.4byte	0x6340
	.4byte	0x512b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1077
	.4byte	0x62e8
	.4byte	0x5143
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1078
	.4byte	0x616e
	.4byte	0x515b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1079
	.4byte	0x616e
	.4byte	0x5173
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1087
	.4byte	0x298f
	.4byte	0x5195
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1091
	.4byte	0x298f
	.4byte	0x51b7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1093
	.4byte	0x298f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x104f
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1280
	.uleb128 0x49
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x580
	.4byte	0x5b
	.8byte	.LFB274
	.8byte	.LFE274-.LFB274
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x53c1
	.uleb128 0x55
	.4byte	.LASF705
	.byte	0x2
	.2byte	0x582
	.4byte	0xdea
	.4byte	.LLST462
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6826
	.uleb128 0x34
	.8byte	.LVL2055
	.4byte	0x258a
	.4byte	0x523e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2056
	.4byte	0x6c07
	.4byte	0x5255
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2058
	.4byte	0xa94f
	.4byte	0x5288
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR179
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x59d
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2059
	.4byte	0xa94f
	.4byte	0x52bb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR179
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x59f
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2061
	.4byte	0x2512
	.4byte	0x52d9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2062
	.4byte	0x2512
	.uleb128 0x45
	.8byte	.LVL2063
	.4byte	0x2512
	.uleb128 0x34
	.8byte	.LVL2064
	.4byte	0xa94f
	.4byte	0x5326
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR179
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x5b5
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2065
	.4byte	0x45ef
	.4byte	0x5345
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR51
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2066
	.4byte	0x45ef
	.4byte	0x5364
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR52
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2067
	.4byte	0x45ef
	.4byte	0x5383
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2068
	.4byte	0x45ef
	.4byte	0x53a2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR80
	.byte	0
	.uleb128 0x36
	.8byte	.LVL2070
	.4byte	0x298f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF710
	.byte	0x2
	.2byte	0x57b
	.4byte	0x5b
	.8byte	.LFB273
	.8byte	.LFE273-.LFB273
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x53f4
	.uleb128 0x53
	.4byte	.LASF711
	.byte	0x2
	.2byte	0x57b
	.4byte	0xdc9
	.4byte	.LLST79
	.byte	0
	.uleb128 0x62
	.4byte	.LASF713
	.byte	0x2
	.2byte	0x573
	.byte	0x1
	.4byte	0x541a
	.uleb128 0x4b
	.4byte	.LASF711
	.byte	0x2
	.2byte	0x573
	.4byte	0xdc9
	.uleb128 0x4b
	.4byte	.LASF590
	.byte	0x2
	.2byte	0x573
	.4byte	0x5b
	.byte	0
	.uleb128 0x52
	.4byte	.LASF715
	.byte	0x2
	.2byte	0x566
	.4byte	0x5b
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF716
	.byte	0x2
	.2byte	0x477
	.4byte	0x5b
	.8byte	.LFB270
	.8byte	.LFE270-.LFB270
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x567a
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x2
	.2byte	0x479
	.4byte	0xdc9
	.4byte	.LLST257
	.uleb128 0x55
	.4byte	.LASF717
	.byte	0x2
	.2byte	0x479
	.4byte	0xdc9
	.4byte	.LLST258
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x47a
	.4byte	0xdc9
	.4byte	.LLST259
	.uleb128 0x55
	.4byte	.LASF568
	.byte	0x2
	.2byte	0x47a
	.4byte	0xdc9
	.4byte	.LLST260
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x47b
	.4byte	0xdea
	.4byte	.LLST261
	.uleb128 0x54
	.string	"j"
	.byte	0x2
	.2byte	0x47b
	.4byte	0xdea
	.4byte	.LLST262
	.uleb128 0x55
	.4byte	.LASF718
	.byte	0x2
	.2byte	0x47c
	.4byte	0x51dc
	.4byte	.LLST263
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4239
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6769
	.uleb128 0x34
	.8byte	.LVL988
	.4byte	0x258a
	.4byte	0x54df
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL989
	.4byte	0x258a
	.4byte	0x54f6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL990
	.4byte	0x258a
	.4byte	0x550d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL991
	.4byte	0x258a
	.4byte	0x5524
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL992
	.4byte	0x258a
	.4byte	0x554e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR79
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x3c
	.byte	0
	.uleb128 0x34
	.8byte	.LVL995
	.4byte	0x6dce
	.4byte	0x5569
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x8f
	.sleb128 332
	.byte	0x94
	.byte	0x2
	.byte	0
	.uleb128 0x34
	.8byte	.LVL997
	.4byte	0x7522
	.4byte	0x5581
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1006
	.4byte	0x298f
	.4byte	0x559e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1011
	.4byte	0x298f
	.4byte	0x55ba
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1013
	.4byte	0x6b48
	.4byte	0x55d7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1017
	.4byte	0xa94f
	.4byte	0x5605
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x4
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x4bb
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1028
	.4byte	0xa94f
	.4byte	0x5633
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x4
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x4e4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1039
	.4byte	0x6b48
	.4byte	0x564a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1041
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR148
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x561
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF719
	.byte	0x2
	.2byte	0x41c
	.4byte	0x5b
	.8byte	.LFB269
	.8byte	.LFE269-.LFB269
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5823
	.uleb128 0x55
	.4byte	.LASF300
	.byte	0x2
	.2byte	0x41e
	.4byte	0xdc9
	.4byte	.LLST384
	.uleb128 0x55
	.4byte	.LASF720
	.byte	0x2
	.2byte	0x41f
	.4byte	0x5823
	.4byte	.LLST385
	.uleb128 0x55
	.4byte	.LASF721
	.byte	0x2
	.2byte	0x420
	.4byte	0xdc9
	.4byte	.LLST386
	.uleb128 0x4e
	.4byte	.LASF722
	.byte	0x2
	.2byte	0x44d
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6747
	.uleb128 0x34
	.8byte	.LVL1667
	.4byte	0x258a
	.4byte	0x56ff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1668
	.4byte	0x2512
	.4byte	0x5724
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR39
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1669
	.4byte	0x2512
	.uleb128 0x45
	.8byte	.LVL1670
	.4byte	0x2512
	.uleb128 0x34
	.8byte	.LVL1671
	.4byte	0x592a
	.4byte	0x5756
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1673
	.4byte	0x27d2
	.4byte	0x577d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1675
	.4byte	0x6976
	.uleb128 0x34
	.8byte	.LVL1676
	.4byte	0x27d2
	.4byte	0x57b1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1677
	.4byte	0xa94f
	.4byte	0x57e4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR166
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x464
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1680
	.4byte	0xa94f
	.4byte	0x5809
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC104
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1681
	.4byte	0x6b48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x12d8
	.uleb128 0x62
	.4byte	.LASF723
	.byte	0x2
	.2byte	0x3e3
	.byte	0x1
	.4byte	0x5875
	.uleb128 0x50
	.uleb128 0x4d
	.string	"lpa"
	.byte	0x2
	.2byte	0x3e8
	.4byte	0xdd4
	.uleb128 0x4d
	.string	"ppa"
	.byte	0x2
	.2byte	0x3e9
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF724
	.byte	0x2
	.2byte	0x3ea
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF667
	.byte	0x2
	.2byte	0x3eb
	.4byte	0xdf5
	.uleb128 0x4c
	.4byte	.LASF598
	.byte	0x2
	.2byte	0x3ec
	.4byte	0x2dea
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF725
	.byte	0x2
	.2byte	0x3b1
	.8byte	.LFB267
	.8byte	.LFE267-.LFB267
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x592a
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x3b1
	.4byte	0x51d6
	.4byte	.LLST253
	.uleb128 0x54
	.string	"ppa"
	.byte	0x2
	.2byte	0x3b3
	.4byte	0xdd4
	.4byte	.LLST254
	.uleb128 0x55
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x3b4
	.4byte	0xdc9
	.4byte	.LLST255
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x3b5
	.4byte	0x1001
	.4byte	.LLST256
	.uleb128 0x34
	.8byte	.LVL982
	.4byte	0x298f
	.4byte	0x58fc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x44
	.8byte	.LVL984
	.4byte	0x5e8c
	.4byte	0x5915
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.uleb128 0x36
	.8byte	.LVL986
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x62
	.4byte	.LASF726
	.byte	0x2
	.2byte	0x3a2
	.byte	0x1
	.4byte	0x594e
	.uleb128 0x4b
	.4byte	.LASF393
	.byte	0x2
	.2byte	0x3a2
	.4byte	0xdd4
	.uleb128 0x4d
	.string	"i"
	.byte	0x2
	.2byte	0x3a4
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF727
	.byte	0x2
	.2byte	0x38d
	.4byte	0x5b
	.8byte	.LFB265
	.8byte	.LFE265-.LFB265
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x59b6
	.uleb128 0x53
	.4byte	.LASF728
	.byte	0x2
	.2byte	0x38d
	.4byte	0xdd4
	.4byte	.LLST374
	.uleb128 0x55
	.4byte	.LASF729
	.byte	0x2
	.2byte	0x38f
	.4byte	0xdd4
	.4byte	.LLST375
	.uleb128 0x34
	.8byte	.LVL1629
	.4byte	0x5ade
	.4byte	0x59a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1630
	.4byte	0x44a0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF730
	.byte	0x2
	.2byte	0x367
	.4byte	0xdd4
	.8byte	.LFB264
	.8byte	.LFE264-.LFB264
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5ad8
	.uleb128 0x53
	.4byte	.LASF731
	.byte	0x2
	.2byte	0x367
	.4byte	0xdd4
	.4byte	.LLST376
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x2
	.2byte	0x367
	.4byte	0xdd4
	.4byte	.LLST377
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x2
	.2byte	0x367
	.4byte	0x5ad8
	.4byte	.LLST378
	.uleb128 0x54
	.string	"len"
	.byte	0x2
	.2byte	0x369
	.4byte	0xdc9
	.4byte	.LLST379
	.uleb128 0x55
	.4byte	.LASF734
	.byte	0x2
	.2byte	0x369
	.4byte	0xdc9
	.4byte	.LLST380
	.uleb128 0x54
	.string	"ppn"
	.byte	0x2
	.2byte	0x36a
	.4byte	0xdd4
	.4byte	.LLST381
	.uleb128 0x55
	.4byte	.LASF735
	.byte	0x2
	.2byte	0x36b
	.4byte	0xdd4
	.4byte	.LLST382
	.uleb128 0x60
	.string	"req"
	.byte	0x2
	.2byte	0x36c
	.4byte	0xdf5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x55
	.4byte	.LASF736
	.byte	0x2
	.2byte	0x36d
	.4byte	0xdd4
	.4byte	.LLST383
	.uleb128 0x2a
	.4byte	.LASF564
	.byte	0x2
	.2byte	0x36e
	.4byte	0x26fc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x34
	.8byte	.LVL1649
	.4byte	0x298f
	.4byte	0x5a9a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 208
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1651
	.4byte	0x2512
	.4byte	0x5ab8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1658
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xdbe
	.uleb128 0x49
	.4byte	.LASF737
	.byte	0x2
	.2byte	0x342
	.4byte	0xdd4
	.8byte	.LFB263
	.8byte	.LFE263-.LFB263
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5c1c
	.uleb128 0x53
	.4byte	.LASF731
	.byte	0x2
	.2byte	0x342
	.4byte	0xdd4
	.4byte	.LLST366
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x2
	.2byte	0x342
	.4byte	0xdd4
	.4byte	.LLST367
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x2
	.2byte	0x342
	.4byte	0x5ad8
	.4byte	.LLST368
	.uleb128 0x54
	.string	"len"
	.byte	0x2
	.2byte	0x344
	.4byte	0xdc9
	.4byte	.LLST369
	.uleb128 0x55
	.4byte	.LASF734
	.byte	0x2
	.2byte	0x344
	.4byte	0xdc9
	.4byte	.LLST370
	.uleb128 0x54
	.string	"ppn"
	.byte	0x2
	.2byte	0x345
	.4byte	0xdd4
	.4byte	.LLST371
	.uleb128 0x55
	.4byte	.LASF735
	.byte	0x2
	.2byte	0x346
	.4byte	0xdd4
	.4byte	.LLST372
	.uleb128 0x60
	.string	"req"
	.byte	0x2
	.2byte	0x347
	.4byte	0xdf5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x55
	.4byte	.LASF736
	.byte	0x2
	.2byte	0x348
	.4byte	0xdd4
	.4byte	.LLST373
	.uleb128 0x2a
	.4byte	.LASF564
	.byte	0x2
	.2byte	0x349
	.4byte	0x26fc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x34
	.8byte	.LVL1610
	.4byte	0x298f
	.4byte	0x5bc2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 208
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1612
	.4byte	0x2512
	.4byte	0x5be3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x5
	.byte	0x8f
	.sleb128 204
	.byte	0x94
	.byte	0x4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1616
	.4byte	0x5e8c
	.4byte	0x5c08
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR149
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x85
	.sleb128 -1
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1621
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF738
	.byte	0x2
	.2byte	0x321
	.4byte	0x5b
	.8byte	.LFB262
	.8byte	.LFE262-.LFB262
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5d34
	.uleb128 0x5d
	.string	"lpn"
	.byte	0x2
	.2byte	0x321
	.4byte	0xdd4
	.4byte	.LLST238
	.uleb128 0x5d
	.string	"ppn"
	.byte	0x2
	.2byte	0x321
	.4byte	0x1001
	.4byte	.LLST239
	.uleb128 0x53
	.4byte	.LASF739
	.byte	0x2
	.2byte	0x321
	.4byte	0x5b
	.4byte	.LLST240
	.uleb128 0x55
	.4byte	.LASF740
	.byte	0x2
	.2byte	0x323
	.4byte	0xdc9
	.4byte	.LLST241
	.uleb128 0x55
	.4byte	.LASF741
	.byte	0x2
	.2byte	0x323
	.4byte	0xdc9
	.4byte	.LLST242
	.uleb128 0x55
	.4byte	.LASF742
	.byte	0x2
	.2byte	0x323
	.4byte	0xdc9
	.4byte	.LLST243
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x5d44
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6674
	.uleb128 0x59
	.4byte	.LASF743
	.byte	0x2
	.2byte	0x32c
	.8byte	.L664
	.uleb128 0x34
	.8byte	.LVL924
	.4byte	0xa94f
	.4byte	0x5cf4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR145
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x328
	.byte	0
	.uleb128 0x45
	.8byte	.LVL927
	.4byte	0x5d9b
	.uleb128 0x34
	.8byte	.LVL929
	.4byte	0x5e2e
	.4byte	0x5d19
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL930
	.4byte	0x6423
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x5d44
	.uleb128 0xe
	.4byte	0xda
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.4byte	0x5d34
	.uleb128 0x49
	.4byte	.LASF744
	.byte	0x2
	.2byte	0x314
	.4byte	0x5b
	.8byte	.LFB261
	.8byte	.LFE261-.LFB261
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5d9b
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x316
	.4byte	0xdc9
	.4byte	.LLST329
	.uleb128 0x45
	.8byte	.LVL1365
	.4byte	0x5829
	.uleb128 0x36
	.8byte	.LVL1368
	.4byte	0x5e2e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF745
	.byte	0x2
	.2byte	0x2ec
	.4byte	0xdc9
	.8byte	.LFB260
	.8byte	.LFE260-.LFB260
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5e2e
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x2ee
	.4byte	0xdc9
	.4byte	.LLST73
	.uleb128 0x55
	.4byte	.LASF746
	.byte	0x2
	.2byte	0x2ef
	.4byte	0xdc9
	.4byte	.LLST74
	.uleb128 0x55
	.4byte	.LASF747
	.byte	0x2
	.2byte	0x2f0
	.4byte	0xdd4
	.4byte	.LLST75
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4d7e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6657
	.uleb128 0x36
	.8byte	.LVL212
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR57
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x310
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF748
	.byte	0x2
	.2byte	0x2e2
	.4byte	0x5b
	.8byte	.LFB259
	.8byte	.LFE259-.LFB259
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5e8c
	.uleb128 0x53
	.4byte	.LASF740
	.byte	0x2
	.2byte	0x2e2
	.4byte	0xdc9
	.4byte	.LLST236
	.uleb128 0x55
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x2e4
	.4byte	0xdd4
	.4byte	.LLST237
	.uleb128 0x36
	.8byte	.LVL917
	.4byte	0x5e8c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF749
	.byte	0x2
	.2byte	0x2a7
	.4byte	0x5b
	.8byte	.LFB258
	.8byte	.LFE258-.LFB258
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x601d
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x2a7
	.4byte	0x51d6
	.4byte	.LLST223
	.uleb128 0x53
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x2a7
	.4byte	0xdd4
	.4byte	.LLST224
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x2
	.2byte	0x2a7
	.4byte	0x1001
	.4byte	.LLST225
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x2a9
	.4byte	0xdd4
	.4byte	.LLST226
	.uleb128 0x55
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x2aa
	.4byte	0x51dc
	.4byte	.LLST227
	.uleb128 0x55
	.4byte	.LASF721
	.byte	0x2
	.2byte	0x2ab
	.4byte	0xdc9
	.4byte	.LLST228
	.uleb128 0x4e
	.4byte	.LASF750
	.byte	0x2
	.2byte	0x2ad
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x37d0
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6632
	.uleb128 0x34
	.8byte	.LVL875
	.4byte	0x601d
	.4byte	0x5f41
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL876
	.4byte	0xa94f
	.4byte	0x5f6d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2bb
	.byte	0
	.uleb128 0x34
	.8byte	.LVL877
	.4byte	0xa94f
	.4byte	0x5f99
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2bc
	.byte	0
	.uleb128 0x34
	.8byte	.LVL879
	.4byte	0x258a
	.4byte	0x5fb5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL882
	.4byte	0x27d2
	.4byte	0x5fdc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL884
	.4byte	0xa94f
	.4byte	0x5ffb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC89
	.byte	0
	.uleb128 0x36
	.8byte	.LVL885
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF751
	.byte	0x2
	.2byte	0x277
	.4byte	0x5b
	.8byte	.LFB257
	.8byte	.LFE257-.LFB257
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6159
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x277
	.4byte	0x51d6
	.4byte	.LLST217
	.uleb128 0x4c
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x279
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x279
	.4byte	0xdc9
	.4byte	.LLST218
	.uleb128 0x55
	.4byte	.LASF752
	.byte	0x2
	.2byte	0x27a
	.4byte	0xdc9
	.4byte	.LLST219
	.uleb128 0x55
	.4byte	.LASF753
	.byte	0x2
	.2byte	0x27b
	.4byte	0x10f8
	.4byte	.LLST220
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x27c
	.4byte	0x1001
	.4byte	.LLST221
	.uleb128 0x55
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x27d
	.4byte	0x51dc
	.4byte	.LLST222
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x6169
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6618
	.uleb128 0x34
	.8byte	.LVL854
	.4byte	0xa94f
	.4byte	0x60f1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR141
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x281
	.byte	0
	.uleb128 0x45
	.8byte	.LVL855
	.4byte	0x6976
	.uleb128 0x34
	.8byte	.LVL862
	.4byte	0x258a
	.4byte	0x6116
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL866
	.4byte	0x27d2
	.4byte	0x6144
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL867
	.4byte	0x616e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x6169
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1e
	.byte	0
	.uleb128 0x7
	.4byte	0x6159
	.uleb128 0x49
	.4byte	.LASF754
	.byte	0x2
	.2byte	0x249
	.4byte	0x5b
	.8byte	.LFB256
	.8byte	.LFE256-.LFB256
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x62e8
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x249
	.4byte	0x51d6
	.4byte	.LLST229
	.uleb128 0x55
	.4byte	.LASF755
	.byte	0x2
	.2byte	0x24b
	.4byte	0xdc9
	.4byte	.LLST230
	.uleb128 0x55
	.4byte	.LASF756
	.byte	0x2
	.2byte	0x24c
	.4byte	0xdc9
	.4byte	.LLST231
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x24d
	.4byte	0xdc9
	.4byte	.LLST232
	.uleb128 0x55
	.4byte	.LASF753
	.byte	0x2
	.2byte	0x24e
	.4byte	0x10f8
	.4byte	.LLST233
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x24f
	.4byte	0x1001
	.4byte	.LLST234
	.uleb128 0x55
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x250
	.4byte	0x51dc
	.4byte	.LLST235
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6604
	.uleb128 0x34
	.8byte	.LVL894
	.4byte	0x6340
	.4byte	0x622b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL897
	.4byte	0x62e8
	.4byte	0x6243
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL899
	.4byte	0x6b48
	.4byte	0x6260
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL901
	.4byte	0x62e8
	.4byte	0x6278
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL906
	.4byte	0x298f
	.4byte	0x62a1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL907
	.4byte	0xa94f
	.4byte	0x62cd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x265
	.byte	0
	.uleb128 0x36
	.8byte	.LVL912
	.4byte	0x5e8c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF757
	.byte	0x2
	.2byte	0x231
	.4byte	0x5b
	.byte	0x1
	.4byte	0x632b
	.uleb128 0x4b
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x231
	.4byte	0x51d6
	.uleb128 0x4c
	.4byte	.LASF758
	.byte	0x2
	.2byte	0x233
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF753
	.byte	0x2
	.2byte	0x234
	.4byte	0x10f8
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x633b
	.4byte	.LASF757
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x633b
	.uleb128 0xe
	.4byte	0xda
	.byte	0x19
	.byte	0
	.uleb128 0x7
	.4byte	0x632b
	.uleb128 0x49
	.4byte	.LASF759
	.byte	0x2
	.2byte	0x209
	.4byte	0x5b
	.8byte	.LFB254
	.8byte	.LFE254-.LFB254
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6423
	.uleb128 0x53
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x209
	.4byte	0x51d6
	.4byte	.LLST208
	.uleb128 0x55
	.4byte	.LASF753
	.byte	0x2
	.2byte	0x20b
	.4byte	0x10f8
	.4byte	.LLST209
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x20c
	.4byte	0x1001
	.4byte	.LLST210
	.uleb128 0x55
	.4byte	.LASF760
	.byte	0x2
	.2byte	0x20d
	.4byte	0x10f8
	.4byte	.LLST211
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x20e
	.4byte	0xdc9
	.4byte	.LLST212
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x20e
	.4byte	0xdc9
	.4byte	.LLST213
	.uleb128 0x55
	.4byte	.LASF758
	.byte	0x2
	.2byte	0x20f
	.4byte	0xdc9
	.4byte	.LLST214
	.uleb128 0x55
	.4byte	.LASF761
	.byte	0x2
	.2byte	0x210
	.4byte	0xdc9
	.4byte	.LLST215
	.uleb128 0x55
	.4byte	.LASF756
	.byte	0x2
	.2byte	0x211
	.4byte	0xdc9
	.4byte	.LLST216
	.uleb128 0x34
	.8byte	.LVL831
	.4byte	0x258a
	.4byte	0x640f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL848
	.4byte	0x6b48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF762
	.byte	0x2
	.2byte	0x1e7
	.4byte	0x5b
	.8byte	.LFB253
	.8byte	.LFE253-.LFB253
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x65ab
	.uleb128 0x53
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x1e7
	.4byte	0xdc9
	.4byte	.LLST205
	.uleb128 0x53
	.4byte	.LASF740
	.byte	0x2
	.2byte	0x1e7
	.4byte	0xdc9
	.4byte	.LLST206
	.uleb128 0x2a
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x1e9
	.4byte	0x51dc
	.uleb128 0x1
	.byte	0x69
	.uleb128 0x55
	.4byte	.LASF763
	.byte	0x2
	.2byte	0x1ea
	.4byte	0xdd4
	.4byte	.LLST207
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x37d0
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6560
	.uleb128 0x34
	.8byte	.LVL815
	.4byte	0xa94f
	.4byte	0x64c9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR140
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x1ec
	.byte	0
	.uleb128 0x34
	.8byte	.LVL818
	.4byte	0x258a
	.4byte	0x64e1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL822
	.4byte	0x298f
	.4byte	0x6503
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL824
	.4byte	0xa94f
	.4byte	0x652e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC86
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL825
	.4byte	0x2b07
	.4byte	0x6557
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC87
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x34
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x34
	.byte	0
	.uleb128 0x34
	.8byte	.LVL826
	.4byte	0x2b07
	.4byte	0x657b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x34
	.byte	0
	.uleb128 0x36
	.8byte	.LVL827
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR140
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x201
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF764
	.byte	0x2
	.2byte	0x1bf
	.4byte	0x5b
	.byte	0x1
	.4byte	0x662a
	.uleb128 0x4b
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x1bf
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF765
	.byte	0x2
	.2byte	0x1c1
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF766
	.byte	0x2
	.2byte	0x1c2
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF767
	.byte	0x2
	.2byte	0x1c3
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF768
	.byte	0x2
	.2byte	0x1c5
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF769
	.byte	0x2
	.2byte	0x1c6
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x1c7
	.4byte	0x1e17
	.uleb128 0x4c
	.4byte	.LASF770
	.byte	0x2
	.2byte	0x1c7
	.4byte	0x1e17
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x4d7e
	.4byte	.LASF764
	.byte	0
	.uleb128 0x49
	.4byte	.LASF771
	.byte	0x2
	.2byte	0x1ab
	.4byte	0x5b
	.8byte	.LFB251
	.8byte	.LFE251-.LFB251
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x667d
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x1ab
	.4byte	0xdc9
	.4byte	.LLST61
	.uleb128 0x55
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x1ad
	.4byte	0xdc9
	.4byte	.LLST62
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x1ae
	.4byte	0x1e17
	.4byte	.LLST63
	.byte	0
	.uleb128 0x49
	.4byte	.LASF772
	.byte	0x2
	.2byte	0x1a6
	.4byte	0x5b
	.8byte	.LFB250
	.8byte	.LFE250-.LFB250
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x66ca
	.uleb128 0x53
	.4byte	.LASF773
	.byte	0x2
	.2byte	0x1a6
	.4byte	0x66ca
	.4byte	.LLST60
	.uleb128 0x2f
	.8byte	.LVL168
	.4byte	0x66d0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1e17
	.uleb128 0x49
	.4byte	.LASF774
	.byte	0x2
	.2byte	0x193
	.4byte	0x5b
	.8byte	.LFB249
	.8byte	.LFE249-.LFB249
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6747
	.uleb128 0x53
	.4byte	.LASF773
	.byte	0x2
	.2byte	0x193
	.4byte	0x66ca
	.4byte	.LLST56
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x193
	.4byte	0xdc9
	.4byte	.LLST57
	.uleb128 0x55
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x195
	.4byte	0xdc9
	.4byte	.LLST58
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x196
	.4byte	0x1e17
	.4byte	.LLST59
	.uleb128 0x36
	.8byte	.LVL159
	.4byte	0x6747
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF775
	.byte	0x2
	.2byte	0x176
	.4byte	0x5b
	.8byte	.LFB248
	.8byte	.LFE248-.LFB248
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x67ec
	.uleb128 0x53
	.4byte	.LASF773
	.byte	0x2
	.2byte	0x176
	.4byte	0x66ca
	.4byte	.LLST52
	.uleb128 0x53
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x176
	.4byte	0xdc9
	.4byte	.LLST53
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x178
	.4byte	0x1e17
	.4byte	.LLST54
	.uleb128 0x55
	.4byte	.LASF776
	.byte	0x2
	.2byte	0x178
	.4byte	0x1e17
	.4byte	.LLST55
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x67fc
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6519
	.uleb128 0x36
	.8byte	.LVL144
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x17b
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x67fc
	.uleb128 0xe
	.4byte	0xda
	.byte	0x10
	.byte	0
	.uleb128 0x7
	.4byte	0x67ec
	.uleb128 0x49
	.4byte	.LASF777
	.byte	0x2
	.2byte	0x145
	.4byte	0x5b
	.8byte	.LFB247
	.8byte	.LFE247-.LFB247
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6882
	.uleb128 0x53
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x145
	.4byte	0xdc9
	.4byte	.LLST45
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x147
	.4byte	0x1e17
	.4byte	.LLST46
	.uleb128 0x55
	.4byte	.LASF776
	.byte	0x2
	.2byte	0x147
	.4byte	0x1e17
	.4byte	.LLST47
	.uleb128 0x2a
	.4byte	.LASF778
	.byte	0x2
	.2byte	0x148
	.4byte	0xdc9
	.uleb128 0x1
	.byte	0x5d
	.uleb128 0x55
	.4byte	.LASF779
	.byte	0x2
	.2byte	0x149
	.4byte	0xdc9
	.4byte	.LLST48
	.uleb128 0x55
	.4byte	.LASF780
	.byte	0x2
	.2byte	0x14a
	.4byte	0xdc9
	.4byte	.LLST49
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF781
	.byte	0x2
	.byte	0xf8
	.4byte	0x5b
	.8byte	.LFB246
	.8byte	.LFE246-.LFB246
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x692c
	.uleb128 0x2e
	.4byte	.LASF649
	.byte	0x2
	.byte	0xf8
	.4byte	0xdc9
	.4byte	.LLST34
	.uleb128 0x32
	.4byte	.LASF652
	.byte	0x2
	.byte	0xfa
	.4byte	0x1e17
	.4byte	.LLST35
	.uleb128 0x32
	.4byte	.LASF776
	.byte	0x2
	.byte	0xfa
	.4byte	0x1e17
	.4byte	.LLST36
	.uleb128 0x32
	.4byte	.LASF782
	.byte	0x2
	.byte	0xfb
	.4byte	0xdc9
	.4byte	.LLST37
	.uleb128 0x32
	.4byte	.LASF783
	.byte	0x2
	.byte	0xfc
	.4byte	0xdc9
	.4byte	.LLST38
	.uleb128 0x32
	.4byte	.LASF767
	.byte	0x2
	.byte	0xfd
	.4byte	0xdd4
	.4byte	.LLST39
	.uleb128 0x32
	.4byte	.LASF784
	.byte	0x2
	.byte	0xfe
	.4byte	0xdd4
	.4byte	.LLST40
	.uleb128 0x32
	.4byte	.LASF780
	.byte	0x2
	.byte	0xff
	.4byte	0xdc9
	.4byte	.LLST41
	.uleb128 0x55
	.4byte	.LASF325
	.byte	0x2
	.2byte	0x100
	.4byte	0xdc9
	.4byte	.LLST42
	.byte	0
	.uleb128 0x65
	.4byte	.LASF785
	.byte	0x2
	.byte	0xd9
	.byte	0x1
	.4byte	0x6951
	.uleb128 0x38
	.4byte	.LASF649
	.byte	0x2
	.byte	0xd9
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x67fc
	.4byte	.LASF785
	.byte	0
	.uleb128 0x65
	.4byte	.LASF786
	.byte	0x2
	.byte	0xd2
	.byte	0x1
	.4byte	0x6976
	.uleb128 0x38
	.4byte	.LASF649
	.byte	0x2
	.byte	0xd2
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF573
	.4byte	0x67fc
	.4byte	.LASF786
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF787
	.byte	0x2
	.byte	0xb4
	.4byte	0xdc9
	.8byte	.LFB243
	.8byte	.LFE243-.LFB243
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6a64
	.uleb128 0x33
	.string	"tmp"
	.byte	0x2
	.byte	0xb6
	.4byte	0xdc9
	.4byte	.LLST191
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0xb7
	.4byte	0x6a64
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x66
	.4byte	.LASF788
	.byte	0x2
	.byte	0xb9
	.8byte	.L464
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x140
	.4byte	0x6a12
	.uleb128 0x32
	.4byte	.LASF789
	.byte	0x2
	.byte	0xbf
	.4byte	0xdc9
	.4byte	.LLST192
	.uleb128 0x34
	.8byte	.LVL719
	.4byte	0x6d33
	.4byte	0x69f9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL722
	.4byte	0x270c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x67
	.4byte	0x6b8f
	.8byte	.LBB246
	.4byte	.Ldebug_ranges0+0x100
	.byte	0x2
	.byte	0xba
	.uleb128 0x34
	.8byte	.LVL726
	.4byte	0xa94f
	.4byte	0x6a49
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC82
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL728
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x15a4
	.uleb128 0x2d
	.4byte	.LASF790
	.byte	0x2
	.byte	0xa2
	.4byte	0x5b
	.8byte	.LFB242
	.8byte	.LFE242-.LFB242
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6ade
	.uleb128 0x31
	.string	"blk"
	.byte	0x2
	.byte	0xa2
	.4byte	0xdc9
	.4byte	.LLST31
	.uleb128 0x33
	.string	"ret"
	.byte	0x2
	.byte	0xa4
	.4byte	0x5b
	.4byte	.LLST32
	.uleb128 0x33
	.string	"i"
	.byte	0x2
	.byte	0xa5
	.4byte	0xdd4
	.4byte	.LLST33
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0xa6
	.4byte	0x6a64
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x67
	.4byte	0x6b83
	.8byte	.LBB189
	.4byte	.Ldebug_ranges0+0x30
	.byte	0x2
	.byte	0xa8
	.byte	0
	.uleb128 0x43
	.4byte	.LASF791
	.byte	0x2
	.byte	0x75
	.8byte	.LFB241
	.8byte	.LFE241-.LFB241
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6b48
	.uleb128 0x2b
	.4byte	.LASF325
	.byte	0x2
	.byte	0x77
	.4byte	0xddf
	.uleb128 0x12
	.byte	0x3
	.8byte	g_sys_save_data+28
	.byte	0x94
	.byte	0x2
	.byte	0x4f
	.byte	0x1a
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.uleb128 0x33
	.string	"i"
	.byte	0x2
	.byte	0x78
	.4byte	0xdc9
	.4byte	.LLST30
	.uleb128 0x3d
	.string	"blk"
	.byte	0x2
	.byte	0x78
	.4byte	0xdc9
	.uleb128 0x1
	.byte	0x57
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0x79
	.4byte	0x6a64
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.byte	0
	.uleb128 0x65
	.4byte	.LASF792
	.byte	0x2
	.byte	0x61
	.byte	0x1
	.4byte	0x6b83
	.uleb128 0x42
	.string	"blk"
	.byte	0x2
	.byte	0x61
	.4byte	0xdc9
	.uleb128 0x38
	.4byte	.LASF793
	.byte	0x2
	.byte	0x61
	.4byte	0xdc9
	.uleb128 0x50
	.uleb128 0x39
	.string	"Q"
	.byte	0x2
	.byte	0x66
	.4byte	0x6a64
	.uleb128 0x50
	.uleb128 0x3a
	.4byte	.LASF789
	.byte	0x2
	.byte	0x68
	.4byte	0xdc9
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x68
	.4byte	.LASF794
	.byte	0x2
	.byte	0x5c
	.4byte	0xdc9
	.byte	0x1
	.uleb128 0x68
	.4byte	.LASF795
	.byte	0x2
	.byte	0x57
	.4byte	0xdc9
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF796
	.byte	0x2
	.byte	0x4b
	.4byte	0xdc9
	.8byte	.LFB237
	.8byte	.LFE237-.LFB237
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6c07
	.uleb128 0x31
	.string	"max"
	.byte	0x2
	.byte	0x4b
	.4byte	0xdc9
	.4byte	.LLST204
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0x4d
	.4byte	0x6a64
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x36
	.8byte	.LVL811
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR38+8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x800
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF797
	.byte	0x2
	.byte	0x2e
	.4byte	0x5b
	.8byte	.LFB236
	.8byte	.LFE236-.LFB236
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6ce4
	.uleb128 0x2e
	.4byte	.LASF388
	.byte	0x2
	.byte	0x2e
	.4byte	0xdd4
	.4byte	.LLST154
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x2
	.byte	0x2e
	.4byte	0x5b
	.4byte	.LLST155
	.uleb128 0x3d
	.string	"req"
	.byte	0x2
	.byte	0x30
	.4byte	0xdf5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x33
	.string	"low"
	.byte	0x2
	.byte	0x31
	.4byte	0xdea
	.4byte	.LLST156
	.uleb128 0x32
	.4byte	.LASF798
	.byte	0x2
	.byte	0x31
	.4byte	0xdea
	.4byte	.LLST157
	.uleb128 0x33
	.string	"mid"
	.byte	0x2
	.byte	0x31
	.4byte	0xdea
	.4byte	.LLST158
	.uleb128 0x2b
	.4byte	.LASF799
	.byte	0x2
	.byte	0x32
	.4byte	0x26fc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x32
	.4byte	.LASF800
	.byte	0x2
	.byte	0x33
	.4byte	0xdc9
	.4byte	.LLST159
	.uleb128 0x34
	.8byte	.LVL603
	.4byte	0x298f
	.4byte	0x6cc3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 112
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL612
	.4byte	0x298f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 112
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF801
	.byte	0x2
	.byte	0x1e
	.4byte	0xdd4
	.8byte	.LFB235
	.8byte	.LFE235-.LFB235
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6d33
	.uleb128 0x2e
	.4byte	.LASF802
	.byte	0x2
	.byte	0x1e
	.4byte	0xdd4
	.4byte	.LLST27
	.uleb128 0x2e
	.4byte	.LASF803
	.byte	0x2
	.byte	0x1e
	.4byte	0xdd4
	.4byte	.LLST28
	.uleb128 0x33
	.string	"ret"
	.byte	0x2
	.byte	0x20
	.4byte	0xdd4
	.4byte	.LLST29
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF804
	.byte	0x2
	.byte	0x14
	.4byte	0xdc9
	.8byte	.LFB234
	.8byte	.LFE234-.LFB234
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6d73
	.uleb128 0x2e
	.4byte	.LASF596
	.byte	0x2
	.byte	0x14
	.4byte	0xdc9
	.4byte	.LLST25
	.uleb128 0x32
	.4byte	.LASF717
	.byte	0x2
	.byte	0x16
	.4byte	0xdc9
	.4byte	.LLST26
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF805
	.byte	0x2
	.byte	0xc
	.4byte	0xdc9
	.8byte	.LFB233
	.8byte	.LFE233-.LFB233
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6dce
	.uleb128 0x2e
	.4byte	.LASF596
	.byte	0x2
	.byte	0xc
	.4byte	0xdc9
	.4byte	.LLST24
	.uleb128 0x2b
	.4byte	.LASF594
	.byte	0x2
	.byte	0xe
	.4byte	0xdc9
	.uleb128 0x1e
	.byte	0x73
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x71
	.sleb128 0
	.byte	0x1e
	.byte	0x73
	.sleb128 0
	.byte	0x71
	.sleb128 0
	.byte	0x1d
	.byte	0x22
	.byte	0x9f
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF806
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.8byte	.LFB232
	.8byte	.LFE232-.LFB232
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6e1b
	.uleb128 0x2e
	.4byte	.LASF594
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.4byte	.LLST22
	.uleb128 0x5c
	.4byte	.LASF717
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x32
	.4byte	.LASF586
	.byte	0x2
	.byte	0x6
	.4byte	0xdc9
	.4byte	.LLST23
	.byte	0
	.uleb128 0x49
	.4byte	.LASF807
	.byte	0x4
	.2byte	0x13c
	.4byte	0xddf
	.8byte	.LFB231
	.8byte	.LFE231-.LFB231
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7066
	.uleb128 0x54
	.string	"die"
	.byte	0x4
	.2byte	0x13e
	.4byte	0xdd4
	.4byte	.LLST362
	.uleb128 0x54
	.string	"blk"
	.byte	0x4
	.2byte	0x13f
	.4byte	0xdc9
	.4byte	.LLST363
	.uleb128 0x55
	.4byte	.LASF576
	.byte	0x4
	.2byte	0x140
	.4byte	0xdd4
	.4byte	.LLST364
	.uleb128 0x55
	.4byte	.LASF808
	.byte	0x4
	.2byte	0x142
	.4byte	0x7066
	.4byte	.LLST365
	.uleb128 0x4e
	.4byte	.LASF809
	.byte	0x4
	.2byte	0x158
	.uleb128 0x45
	.8byte	.LVL1549
	.4byte	0x72c0
	.uleb128 0x45
	.8byte	.LVL1550
	.4byte	0x706c
	.uleb128 0x34
	.8byte	.LVL1556
	.4byte	0x7522
	.4byte	0x6eb7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1557
	.4byte	0x26b8
	.4byte	0x6ecf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1558
	.4byte	0x75b1
	.4byte	0x6ee7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1564
	.4byte	0x298f
	.4byte	0x6f09
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1565
	.4byte	0x2512
	.uleb128 0x34
	.8byte	.LVL1567
	.4byte	0x75b1
	.4byte	0x6f2e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1569
	.4byte	0x25fc
	.4byte	0x6f46
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1570
	.4byte	0x747e
	.uleb128 0x45
	.8byte	.LVL1572
	.4byte	0x7522
	.uleb128 0x34
	.8byte	.LVL1573
	.4byte	0x258a
	.4byte	0x6f7c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1574
	.4byte	0x258a
	.4byte	0x6f9a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x1000
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1576
	.4byte	0x2512
	.uleb128 0x34
	.8byte	.LVL1577
	.4byte	0x270c
	.4byte	0x6fc9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1578
	.4byte	0x27d2
	.4byte	0x6ff0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1579
	.4byte	0x75b1
	.4byte	0x7008
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1585
	.4byte	0x75b1
	.uleb128 0x34
	.8byte	.LVL1589
	.4byte	0x270c
	.4byte	0x7031
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1590
	.4byte	0x75b1
	.uleb128 0x45
	.8byte	.LVL1591
	.4byte	0x75b1
	.uleb128 0x45
	.8byte	.LVL1592
	.4byte	0x7304
	.uleb128 0x45
	.8byte	.LVL1594
	.4byte	0x7304
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x11c8
	.uleb128 0x49
	.4byte	.LASF810
	.byte	0x4
	.2byte	0x116
	.4byte	0x5b
	.8byte	.LFB230
	.8byte	.LFE230-.LFB230
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x70e9
	.uleb128 0x54
	.string	"die"
	.byte	0x4
	.2byte	0x118
	.4byte	0xdd4
	.4byte	.LLST151
	.uleb128 0x54
	.string	"blk"
	.byte	0x4
	.2byte	0x119
	.4byte	0xdc9
	.4byte	.LLST152
	.uleb128 0x4c
	.4byte	.LASF811
	.byte	0x4
	.2byte	0x11a
	.4byte	0xdd4
	.uleb128 0x55
	.4byte	.LASF808
	.byte	0x4
	.2byte	0x11b
	.4byte	0x7066
	.4byte	.LLST153
	.uleb128 0x36
	.8byte	.LVL593
	.4byte	0x298f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF812
	.byte	0x4
	.byte	0xac
	.4byte	0x5b
	.8byte	.LFB229
	.8byte	.LFE229-.LFB229
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7257
	.uleb128 0x33
	.string	"i"
	.byte	0x4
	.byte	0xae
	.4byte	0xdd4
	.4byte	.LLST358
	.uleb128 0x33
	.string	"blk"
	.byte	0x4
	.byte	0xaf
	.4byte	0xdc9
	.4byte	.LLST359
	.uleb128 0x32
	.4byte	.LASF705
	.byte	0x4
	.byte	0xb0
	.4byte	0xdea
	.4byte	.LLST360
	.uleb128 0x32
	.4byte	.LASF808
	.byte	0x4
	.byte	0xb1
	.4byte	0x7066
	.4byte	.LLST361
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x7267
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6366
	.uleb128 0x45
	.8byte	.LVL1525
	.4byte	0x72c0
	.uleb128 0x34
	.8byte	.LVL1527
	.4byte	0x298f
	.4byte	0x7186
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1528
	.4byte	0x298f
	.4byte	0x71a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1530
	.4byte	0x298f
	.4byte	0x71d1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1531
	.4byte	0x6c07
	.4byte	0x71e8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1533
	.4byte	0xa94f
	.4byte	0x721a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR164
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xfe
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1534
	.4byte	0x8a94
	.uleb128 0x34
	.8byte	.LVL1542
	.4byte	0x298f
	.4byte	0x7249
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1547
	.4byte	0x2512
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x7267
	.uleb128 0xe
	.4byte	0xda
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.4byte	0x7257
	.uleb128 0x2d
	.4byte	.LASF813
	.byte	0x4
	.byte	0x9c
	.4byte	0xdc9
	.8byte	.LFB228
	.8byte	.LFE228-.LFB228
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x72c0
	.uleb128 0x33
	.string	"blk"
	.byte	0x4
	.byte	0x9e
	.4byte	0xdc9
	.4byte	.LLST20
	.uleb128 0x32
	.4byte	.LASF814
	.byte	0x4
	.byte	0x9f
	.4byte	0xdc9
	.4byte	.LLST21
	.uleb128 0x36
	.8byte	.LVL53
	.4byte	0x7522
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x43
	.4byte	.LASF815
	.byte	0x4
	.byte	0x94
	.8byte	.LFB227
	.8byte	.LFE227-.LFB227
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7304
	.uleb128 0x2f
	.8byte	.LVL808
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR37+12
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x40
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF816
	.byte	0x4
	.byte	0x4f
	.4byte	0x5b
	.8byte	.LFB226
	.8byte	.LFE226-.LFB226
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x747e
	.uleb128 0x33
	.string	"i"
	.byte	0x4
	.byte	0x51
	.4byte	0x5b
	.4byte	.LLST307
	.uleb128 0x32
	.4byte	.LASF817
	.byte	0x4
	.byte	0x52
	.4byte	0x5b
	.4byte	.LLST308
	.uleb128 0x32
	.4byte	.LASF808
	.byte	0x4
	.byte	0x53
	.4byte	0x7066
	.4byte	.LLST309
	.uleb128 0x32
	.4byte	.LASF721
	.byte	0x4
	.byte	0x54
	.4byte	0xdc9
	.4byte	.LLST310
	.uleb128 0x58
	.4byte	.LASF818
	.byte	0x4
	.byte	0x67
	.uleb128 0x69
	.4byte	.LASF573
	.4byte	0x298a
	.uleb128 0x34
	.8byte	.LVL1247
	.4byte	0x258a
	.4byte	0x7387
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1250
	.4byte	0x258a
	.4byte	0x73aa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1252
	.4byte	0xa94f
	.4byte	0x73c2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1253
	.4byte	0x27d2
	.4byte	0x73e9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1254
	.4byte	0x270c
	.4byte	0x7405
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1255
	.4byte	0x27d2
	.4byte	0x742c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1257
	.4byte	0xa94f
	.4byte	0x744b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC98
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1258
	.4byte	0xa94f
	.4byte	0x7470
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC99
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1261
	.4byte	0x2512
	.byte	0
	.uleb128 0x43
	.4byte	.LASF819
	.byte	0x4
	.byte	0x41
	.8byte	.LFB225
	.8byte	.LFE225-.LFB225
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x751a
	.uleb128 0x2e
	.4byte	.LASF753
	.byte	0x4
	.byte	0x41
	.4byte	0x10f8
	.4byte	.LLST202
	.uleb128 0x2e
	.4byte	.LASF820
	.byte	0x4
	.byte	0x41
	.4byte	0x1001
	.4byte	.LLST203
	.uleb128 0x39
	.string	"i"
	.byte	0x4
	.byte	0x43
	.4byte	0xdd4
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x4239
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6323
	.uleb128 0x34
	.8byte	.LVL804
	.4byte	0x258a
	.4byte	0x74f2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL805
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x4a
	.byte	0
	.byte	0
	.uleb128 0x6a
	.4byte	.LASF821
	.byte	0x4
	.byte	0x26
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF822
	.byte	0x4
	.byte	0x17
	.4byte	0x5b
	.8byte	.LFB223
	.8byte	.LFE223-.LFB223
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x75b1
	.uleb128 0x2e
	.4byte	.LASF388
	.byte	0x4
	.byte	0x17
	.4byte	0xdc9
	.4byte	.LLST16
	.uleb128 0x33
	.string	"die"
	.byte	0x4
	.byte	0x19
	.4byte	0xdd4
	.4byte	.LLST17
	.uleb128 0x33
	.string	"i"
	.byte	0x4
	.byte	0x1a
	.4byte	0xdd4
	.4byte	.LLST18
	.uleb128 0x2b
	.4byte	.LASF820
	.byte	0x4
	.byte	0x1b
	.4byte	0x1001
	.uleb128 0x27
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x23
	.uleb128 0x4
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.8byte	gBbtInfo
	.byte	0x22
	.uleb128 0x32
	.4byte	.LASF581
	.byte	0x4
	.byte	0x1c
	.4byte	0xdc9
	.4byte	.LLST19
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF823
	.byte	0x4
	.byte	0x4
	.4byte	0x5b
	.8byte	.LFB222
	.8byte	.LFE222-.LFB222
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7635
	.uleb128 0x2e
	.4byte	.LASF388
	.byte	0x4
	.byte	0x4
	.4byte	0xdc9
	.4byte	.LLST12
	.uleb128 0x33
	.string	"die"
	.byte	0x4
	.byte	0x6
	.4byte	0xdd4
	.4byte	.LLST13
	.uleb128 0x32
	.4byte	.LASF820
	.byte	0x4
	.byte	0x7
	.4byte	0x1001
	.4byte	.LLST14
	.uleb128 0x32
	.4byte	.LASF581
	.byte	0x4
	.byte	0x8
	.4byte	0xdc9
	.4byte	.LLST15
	.uleb128 0x36
	.8byte	.LVL44
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x7
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0
	.byte	0
	.uleb128 0x6b
	.4byte	.LASF885
	.byte	0x3
	.2byte	0x499
	.4byte	0xdd4
	.8byte	.LFB221
	.8byte	.LFE221-.LFB221
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x49
	.4byte	.LASF824
	.byte	0x3
	.2byte	0x494
	.4byte	0x5b
	.8byte	.LFB220
	.8byte	.LFE220-.LFB220
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x76ce
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x3
	.2byte	0x494
	.4byte	0xb9
	.4byte	.LLST459
	.uleb128 0x53
	.4byte	.LASF325
	.byte	0x3
	.2byte	0x494
	.4byte	0xb9
	.4byte	.LLST460
	.uleb128 0x5d
	.string	"buf"
	.byte	0x3
	.2byte	0x494
	.4byte	0x76ce
	.4byte	.LLST461
	.uleb128 0x2f
	.8byte	.LVL2054
	.4byte	0x786c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x94
	.uleb128 0x49
	.4byte	.LASF825
	.byte	0x3
	.2byte	0x48f
	.4byte	0x5b
	.8byte	.LFB219
	.8byte	.LFE219-.LFB219
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x774f
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x3
	.2byte	0x48f
	.4byte	0xb9
	.4byte	.LLST441
	.uleb128 0x53
	.4byte	.LASF325
	.byte	0x3
	.2byte	0x48f
	.4byte	0xb9
	.4byte	.LLST442
	.uleb128 0x5d
	.string	"buf"
	.byte	0x3
	.2byte	0x48f
	.4byte	0x76ce
	.4byte	.LLST443
	.uleb128 0x2f
	.8byte	.LVL1980
	.4byte	0x7ef8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF826
	.byte	0x3
	.2byte	0x460
	.4byte	0x5b
	.8byte	.LFB218
	.8byte	.LFE218-.LFB218
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x786c
	.uleb128 0x53
	.4byte	.LASF731
	.byte	0x3
	.2byte	0x460
	.4byte	0xdd4
	.4byte	.LLST387
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x3
	.2byte	0x460
	.4byte	0xdd4
	.4byte	.LLST388
	.uleb128 0x55
	.4byte	.LASF734
	.byte	0x3
	.2byte	0x462
	.4byte	0xdc9
	.4byte	.LLST389
	.uleb128 0x54
	.string	"tmp"
	.byte	0x3
	.2byte	0x463
	.4byte	0xdc9
	.4byte	.LLST390
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x464
	.4byte	0xdd4
	.4byte	.LLST391
	.uleb128 0x2a
	.4byte	.LASF663
	.byte	0x3
	.2byte	0x465
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x2a
	.4byte	.LASF640
	.byte	0x3
	.2byte	0x465
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF629
	.byte	0x3
	.2byte	0x466
	.4byte	0xdc9
	.4byte	.LLST392
	.uleb128 0x45
	.8byte	.LVL1702
	.4byte	0x5d49
	.uleb128 0x45
	.8byte	.LVL1703
	.4byte	0x567a
	.uleb128 0x34
	.8byte	.LVL1704
	.4byte	0x5c1c
	.4byte	0x782d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 120
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1705
	.4byte	0x5c1c
	.4byte	0x7851
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 124
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1706
	.4byte	0x6d33
	.uleb128 0x45
	.8byte	.LVL1707
	.4byte	0x3691
	.byte	0
	.uleb128 0x49
	.4byte	.LASF827
	.byte	0x3
	.2byte	0x3bd
	.4byte	0x5b
	.8byte	.LFB217
	.8byte	.LFE217-.LFB217
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7ca2
	.uleb128 0x5d
	.string	"LUN"
	.byte	0x3
	.2byte	0x3bd
	.4byte	0xdbe
	.4byte	.LLST444
	.uleb128 0x53
	.4byte	.LASF731
	.byte	0x3
	.2byte	0x3bd
	.4byte	0xdd4
	.4byte	.LLST445
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x3
	.2byte	0x3bd
	.4byte	0xdd4
	.4byte	.LLST446
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x3
	.2byte	0x3bd
	.4byte	0x5ad8
	.4byte	.LLST447
	.uleb128 0x55
	.4byte	.LASF598
	.byte	0x3
	.2byte	0x3bf
	.4byte	0x2dea
	.4byte	.LLST448
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x3c0
	.4byte	0xdd4
	.4byte	.LLST449
	.uleb128 0x55
	.4byte	.LASF828
	.byte	0x3
	.2byte	0x3c0
	.4byte	0xdd4
	.4byte	.LLST450
	.uleb128 0x55
	.4byte	.LASF829
	.byte	0x3
	.2byte	0x3c0
	.4byte	0xdd4
	.4byte	.LLST451
	.uleb128 0x2a
	.4byte	.LASF663
	.byte	0x3
	.2byte	0x3c1
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x54
	.string	"ppa"
	.byte	0x3
	.2byte	0x3c1
	.4byte	0xdd4
	.4byte	.LLST452
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x3c2
	.4byte	0xdd4
	.4byte	.LLST453
	.uleb128 0x55
	.4byte	.LASF830
	.byte	0x3
	.2byte	0x3c2
	.4byte	0xdd4
	.4byte	.LLST454
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x3
	.2byte	0x3c2
	.4byte	0xdd4
	.4byte	.LLST455
	.uleb128 0x55
	.4byte	.LASF831
	.byte	0x3
	.2byte	0x3c3
	.4byte	0xdd4
	.4byte	.LLST456
	.uleb128 0x55
	.4byte	.LASF832
	.byte	0x3
	.2byte	0x3c3
	.4byte	0xdd4
	.4byte	.LLST457
	.uleb128 0x55
	.4byte	.LASF639
	.byte	0x3
	.2byte	0x3c4
	.4byte	0x1eef
	.4byte	.LLST458
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x5d44
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6259
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x390
	.4byte	0x7a2e
	.uleb128 0x2a
	.4byte	.LASF603
	.byte	0x3
	.2byte	0x425
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x34
	.8byte	.LVL2034
	.4byte	0x298f
	.4byte	0x79d9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 384
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2036
	.4byte	0xa94f
	.4byte	0x79fe
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC108
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL2037
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR178
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x432
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1985
	.4byte	0x5ade
	.4byte	0x7a56
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x85
	.sleb128 256
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x8f
	.sleb128 352
	.byte	0x94
	.byte	0x4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1996
	.4byte	0x2d1d
	.4byte	0x7a76
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x8f
	.sleb128 328
	.byte	0x94
	.byte	0x4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1999
	.4byte	0xa94f
	.4byte	0x7aa9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR178
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x3dc
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2000
	.4byte	0x3903
	.4byte	0x7ac8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR52
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2002
	.4byte	0x3903
	.4byte	0x7ae0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2004
	.4byte	0x3903
	.4byte	0x7af8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2007
	.4byte	0xa94f
	.4byte	0x7b2b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR178
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x3fd
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2010
	.4byte	0x7caf
	.4byte	0x7b4e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2011
	.4byte	0xa94f
	.4byte	0x7b81
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR178
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x44a
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2014
	.4byte	0x3903
	.4byte	0x7b99
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2017
	.4byte	0x5c1c
	.4byte	0x7bbd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 380
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2018
	.4byte	0x37d5
	.4byte	0x7bd5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2022
	.4byte	0x258a
	.4byte	0x7bf2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2027
	.4byte	0xa94f
	.4byte	0x7c25
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR178
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x441
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2035
	.4byte	0x2512
	.uleb128 0x34
	.8byte	.LVL2039
	.4byte	0x258a
	.4byte	0x7c49
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2045
	.4byte	0x662a
	.4byte	0x7c60
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2046
	.4byte	0x2f5e
	.uleb128 0x34
	.8byte	.LVL2047
	.4byte	0x2d1d
	.4byte	0x7c89
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x36
	.8byte	.LVL2048
	.4byte	0x2d1d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x52
	.4byte	.LASF833
	.byte	0x3
	.2byte	0x3b7
	.4byte	0x5b
	.byte	0x1
	.uleb128 0x5f
	.4byte	.LASF834
	.byte	0x3
	.2byte	0x387
	.8byte	.LFB215
	.8byte	.LFE215-.LFB215
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7ee3
	.uleb128 0x5d
	.string	"req"
	.byte	0x3
	.2byte	0x387
	.4byte	0x1abc
	.4byte	.LLST398
	.uleb128 0x53
	.4byte	.LASF595
	.byte	0x3
	.2byte	0x387
	.4byte	0xdd4
	.4byte	.LLST399
	.uleb128 0x53
	.4byte	.LASF835
	.byte	0x3
	.2byte	0x387
	.4byte	0xdd4
	.4byte	.LLST400
	.uleb128 0x53
	.4byte	.LASF639
	.byte	0x3
	.2byte	0x387
	.4byte	0x1eef
	.4byte	.LLST401
	.uleb128 0x4d
	.string	"i"
	.byte	0x3
	.2byte	0x389
	.4byte	0xdd4
	.uleb128 0x60
	.string	"ppa"
	.byte	0x3
	.2byte	0x38a
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF663
	.byte	0x3
	.2byte	0x38a
	.4byte	0xdd4
	.4byte	.LLST402
	.uleb128 0x55
	.4byte	.LASF623
	.byte	0x3
	.2byte	0x38b
	.4byte	0xdc9
	.4byte	.LLST403
	.uleb128 0x55
	.4byte	.LASF598
	.byte	0x3
	.2byte	0x38c
	.4byte	0x2dea
	.4byte	.LLST404
	.uleb128 0x61
	.4byte	.LASF687
	.byte	0x3
	.2byte	0x38d
	.4byte	0xdd4
	.byte	0
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x7ef3
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6231
	.uleb128 0x34
	.8byte	.LVL1746
	.4byte	0x27d2
	.4byte	0x7d9a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 -4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1747
	.4byte	0x6d33
	.uleb128 0x34
	.8byte	.LVL1749
	.4byte	0x3903
	.4byte	0x7dbf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1750
	.4byte	0x2ebc
	.uleb128 0x34
	.8byte	.LVL1751
	.4byte	0x37d5
	.4byte	0x7de4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1752
	.4byte	0x27d2
	.4byte	0x7e06
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1753
	.4byte	0xa94f
	.4byte	0x7e39
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR170
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x3a5
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1754
	.4byte	0x5c1c
	.4byte	0x7e57
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 156
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1756
	.4byte	0x6d33
	.4byte	0x7e71
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x73
	.sleb128 0
	.byte	0x3a
	.byte	0x25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1758
	.4byte	0xa94f
	.4byte	0x7e9b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC106
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1759
	.4byte	0x3691
	.4byte	0x7eb3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1761
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR170
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x3b4
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x7ef3
	.uleb128 0xe
	.4byte	0xda
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.4byte	0x7ee3
	.uleb128 0x49
	.4byte	.LASF836
	.byte	0x3
	.2byte	0x32d
	.4byte	0x5b
	.8byte	.LFB214
	.8byte	.LFE214-.LFB214
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8111
	.uleb128 0x5d
	.string	"LUN"
	.byte	0x3
	.2byte	0x32d
	.4byte	0xdbe
	.4byte	.LLST424
	.uleb128 0x53
	.4byte	.LASF731
	.byte	0x3
	.2byte	0x32d
	.4byte	0xdd4
	.4byte	.LLST425
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x3
	.2byte	0x32d
	.4byte	0xdd4
	.4byte	.LLST426
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x3
	.2byte	0x32d
	.4byte	0x5ad8
	.4byte	.LLST427
	.uleb128 0x54
	.string	"ret"
	.byte	0x3
	.2byte	0x32f
	.4byte	0x5b
	.4byte	.LLST428
	.uleb128 0x55
	.4byte	.LASF828
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST429
	.uleb128 0x55
	.4byte	.LASF829
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST430
	.uleb128 0x55
	.4byte	.LASF837
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST431
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x331
	.4byte	0xdd4
	.4byte	.LLST432
	.uleb128 0x60
	.string	"ppa"
	.byte	0x3
	.2byte	0x331
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x54
	.string	"n"
	.byte	0x3
	.2byte	0x333
	.4byte	0xdd4
	.4byte	.LLST433
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x3
	.2byte	0x333
	.4byte	0xdd4
	.4byte	.LLST434
	.uleb128 0x55
	.4byte	.LASF830
	.byte	0x3
	.2byte	0x333
	.4byte	0xdd4
	.4byte	.LLST435
	.uleb128 0x55
	.4byte	.LASF838
	.byte	0x3
	.2byte	0x334
	.4byte	0xdd4
	.4byte	.LLST436
	.uleb128 0x55
	.4byte	.LASF839
	.byte	0x3
	.2byte	0x334
	.4byte	0xdd4
	.4byte	.LLST437
	.uleb128 0x55
	.4byte	.LASF840
	.byte	0x3
	.2byte	0x335
	.4byte	0xdd4
	.4byte	.LLST438
	.uleb128 0x55
	.4byte	.LASF841
	.byte	0x3
	.2byte	0x336
	.4byte	0xdd4
	.4byte	.LLST439
	.uleb128 0x63
	.8byte	.LBB332
	.8byte	.LBE332-.LBB332
	.4byte	0x8067
	.uleb128 0x55
	.4byte	.LASF586
	.byte	0x3
	.2byte	0x37a
	.4byte	0xdc9
	.4byte	.LLST440
	.uleb128 0x45
	.8byte	.LVL1973
	.4byte	0x6d33
	.uleb128 0x45
	.8byte	.LVL1974
	.4byte	0x2f5e
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1931
	.4byte	0x59b6
	.4byte	0x808c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x83
	.sleb128 256
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1944
	.4byte	0x2d1d
	.4byte	0x80a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1945
	.4byte	0x5c1c
	.4byte	0x80cc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 316
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1950
	.4byte	0x298f
	.4byte	0x80e9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1953
	.4byte	0x2512
	.uleb128 0x36
	.8byte	.LVL1960
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x200
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF842
	.byte	0x3
	.2byte	0x325
	.4byte	0x5b
	.8byte	.LFB213
	.8byte	.LFE213-.LFB213
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8141
	.uleb128 0x45
	.8byte	.LVL1688
	.4byte	0x8141
	.byte	0
	.uleb128 0x49
	.4byte	.LASF843
	.byte	0x3
	.2byte	0x31c
	.4byte	0x5b
	.8byte	.LFB212
	.8byte	.LFE212-.LFB212
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8195
	.uleb128 0x45
	.8byte	.LVL1685
	.4byte	0x5d49
	.uleb128 0x34
	.8byte	.LVL1686
	.4byte	0x594e
	.4byte	0x8187
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1687
	.4byte	0x567a
	.byte	0
	.uleb128 0x49
	.4byte	.LASF844
	.byte	0x3
	.2byte	0x2e6
	.4byte	0x5b
	.8byte	.LFB211
	.8byte	.LFE211-.LFB211
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x82a7
	.uleb128 0x2a
	.4byte	.LASF845
	.byte	0x3
	.2byte	0x2e8
	.4byte	0x82a7
	.uleb128 0xa
	.byte	0x3
	.8byte	g_nand_phy_info
	.byte	0x9f
	.uleb128 0x59
	.4byte	.LASF846
	.byte	0x3
	.2byte	0x2f3
	.8byte	.LDL2
	.uleb128 0x63
	.8byte	.LBB341
	.8byte	.LBE341-.LBB341
	.4byte	0x821a
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x310
	.4byte	0xdd4
	.4byte	.LLST468
	.uleb128 0x36
	.8byte	.LVL2152
	.4byte	0x2d1d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2144
	.4byte	0xa94f
	.4byte	0x8246
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC71
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC70
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2145
	.4byte	0x8a24
	.4byte	0x8265
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2146
	.4byte	0x8730
	.uleb128 0x45
	.8byte	.LVL2147
	.4byte	0x8659
	.uleb128 0x45
	.8byte	.LVL2148
	.4byte	0x6b9b
	.uleb128 0x45
	.8byte	.LVL2149
	.4byte	0x70e9
	.uleb128 0x45
	.8byte	.LVL2150
	.4byte	0x3f79
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xee1
	.uleb128 0x49
	.4byte	.LASF847
	.byte	0x3
	.2byte	0x26e
	.4byte	0x5b
	.8byte	.LFB210
	.8byte	.LFE210-.LFB210
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8447
	.uleb128 0x55
	.4byte	.LASF717
	.byte	0x3
	.2byte	0x270
	.4byte	0xdc9
	.4byte	.LLST464
	.uleb128 0x55
	.4byte	.LASF848
	.byte	0x3
	.2byte	0x270
	.4byte	0xdc9
	.4byte	.LLST465
	.uleb128 0x55
	.4byte	.LASF849
	.byte	0x3
	.2byte	0x271
	.4byte	0xdc9
	.4byte	.LLST466
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x272
	.4byte	0xdc9
	.4byte	.LLST467
	.uleb128 0x59
	.4byte	.LASF850
	.byte	0x3
	.2byte	0x2bc
	.8byte	.L1620
	.uleb128 0x59
	.4byte	.LASF851
	.byte	0x3
	.2byte	0x2cc
	.8byte	.L1622
	.uleb128 0x45
	.8byte	.LVL2103
	.4byte	0x6b9b
	.uleb128 0x45
	.8byte	.LVL2104
	.4byte	0x70e9
	.uleb128 0x45
	.8byte	.LVL2105
	.4byte	0x6e1b
	.uleb128 0x45
	.8byte	.LVL2113
	.4byte	0x7304
	.uleb128 0x34
	.8byte	.LVL2114
	.4byte	0x258a
	.4byte	0x8378
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2116
	.4byte	0x258a
	.4byte	0x8390
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2117
	.4byte	0x45ef
	.4byte	0x83a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2123
	.4byte	0x8447
	.4byte	0x83bf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2128
	.4byte	0x8a94
	.uleb128 0x45
	.8byte	.LVL2129
	.4byte	0x6b9b
	.uleb128 0x34
	.8byte	.LVL2132
	.4byte	0x8447
	.4byte	0x83f0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2135
	.4byte	0x8447
	.4byte	0x8407
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2139
	.4byte	0x45ef
	.4byte	0x841f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2140
	.4byte	0x6976
	.uleb128 0x45
	.8byte	.LVL2141
	.4byte	0x567a
	.uleb128 0x45
	.8byte	.LVL2142
	.4byte	0x3f79
	.byte	0
	.uleb128 0x49
	.4byte	.LASF852
	.byte	0x3
	.2byte	0x20f
	.4byte	0x5b
	.8byte	.LFB209
	.8byte	.LFE209-.LFB209
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x862f
	.uleb128 0x53
	.4byte	.LASF717
	.byte	0x3
	.2byte	0x20f
	.4byte	0xdc9
	.4byte	.LLST181
	.uleb128 0x53
	.4byte	.LASF853
	.byte	0x3
	.2byte	0x20f
	.4byte	0xdbe
	.4byte	.LLST182
	.uleb128 0x55
	.4byte	.LASF848
	.byte	0x3
	.2byte	0x211
	.4byte	0xdc9
	.4byte	.LLST183
	.uleb128 0x55
	.4byte	.LASF568
	.byte	0x3
	.2byte	0x211
	.4byte	0xdc9
	.4byte	.LLST184
	.uleb128 0x55
	.4byte	.LASF594
	.byte	0x3
	.2byte	0x212
	.4byte	0xdc9
	.4byte	.LLST185
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x3
	.2byte	0x212
	.4byte	0xdc9
	.4byte	.LLST186
	.uleb128 0x55
	.4byte	.LASF854
	.byte	0x3
	.2byte	0x213
	.4byte	0xdc9
	.4byte	.LLST187
	.uleb128 0x55
	.4byte	.LASF855
	.byte	0x3
	.2byte	0x214
	.4byte	0xdc9
	.4byte	.LLST188
	.uleb128 0x55
	.4byte	.LASF856
	.byte	0x3
	.2byte	0x215
	.4byte	0xdc9
	.4byte	.LLST189
	.uleb128 0x55
	.4byte	.LASF857
	.byte	0x3
	.2byte	0x216
	.4byte	0xdc9
	.4byte	.LLST190
	.uleb128 0x59
	.4byte	.LASF858
	.byte	0x3
	.2byte	0x240
	.8byte	.L430
	.uleb128 0x34
	.8byte	.LVL671
	.4byte	0x270c
	.4byte	0x8530
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL674
	.4byte	0x75b1
	.uleb128 0x34
	.8byte	.LVL680
	.4byte	0x27d2
	.4byte	0x8560
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL684
	.4byte	0x75b1
	.uleb128 0x34
	.8byte	.LVL688
	.4byte	0x6b48
	.4byte	0x8584
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL689
	.4byte	0x270c
	.4byte	0x85a2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL693
	.4byte	0x6dce
	.4byte	0x85ba
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL695
	.4byte	0x862f
	.4byte	0x85d2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL696
	.4byte	0x7522
	.4byte	0x85ea
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7e
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL707
	.4byte	0x6dce
	.4byte	0x8602
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL709
	.4byte	0x862f
	.4byte	0x861a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7c
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL710
	.4byte	0x7522
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF859
	.byte	0x3
	.2byte	0x201
	.4byte	0x5b
	.byte	0x1
	.4byte	0x8659
	.uleb128 0x4b
	.4byte	.LASF388
	.byte	0x3
	.2byte	0x201
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF860
	.byte	0x3
	.2byte	0x203
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF861
	.byte	0x3
	.2byte	0x1ed
	.4byte	0x5b
	.8byte	.LFB207
	.8byte	.LFE207-.LFB207
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8730
	.uleb128 0x34
	.8byte	.LVL1112
	.4byte	0x258a
	.4byte	0x8692
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1113
	.4byte	0x258a
	.4byte	0x86a9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1114
	.4byte	0x258a
	.4byte	0x86c0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1115
	.4byte	0x258a
	.4byte	0x86ea
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR39
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1116
	.4byte	0x258a
	.4byte	0x8715
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR81
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x200
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1117
	.4byte	0x3666
	.uleb128 0x45
	.8byte	.LVL1118
	.4byte	0x4f6c
	.byte	0
	.uleb128 0x49
	.4byte	.LASF862
	.byte	0x3
	.2byte	0x117
	.4byte	0x5b
	.8byte	.LFB206
	.8byte	.LFE206-.LFB206
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8a24
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x119
	.4byte	0xdd4
	.4byte	.LLST200
	.uleb128 0x55
	.4byte	.LASF863
	.byte	0x3
	.2byte	0x11a
	.4byte	0xdd4
	.4byte	.LLST201
	.uleb128 0x3f
	.4byte	.LASF573
	.4byte	0x7267
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6107
	.uleb128 0x45
	.8byte	.LVL743
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL744
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL746
	.4byte	0x2c16
	.4byte	0x87b5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL747
	.4byte	0x2c16
	.4byte	0x87cd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL748
	.4byte	0x2c16
	.4byte	0x87e5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL749
	.4byte	0x2c16
	.4byte	0x87fd
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL750
	.4byte	0x2c16
	.4byte	0x8815
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL753
	.4byte	0x2c16
	.4byte	0x882d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL754
	.4byte	0x2c16
	.4byte	0x8845
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL755
	.4byte	0x2c16
	.4byte	0x885d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL756
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL757
	.4byte	0x2c16
	.4byte	0x8882
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL758
	.4byte	0x2c16
	.4byte	0x889a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL760
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL762
	.4byte	0x2c16
	.4byte	0x88bf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL763
	.4byte	0x2c16
	.4byte	0x88d9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x4
	.byte	0x8c
	.sleb128 0
	.byte	0x32
	.byte	0x24
	.byte	0
	.uleb128 0x45
	.8byte	.LVL765
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL766
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL767
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL769
	.4byte	0x2c16
	.4byte	0x8918
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL771
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL773
	.4byte	0x2c16
	.4byte	0x893d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL774
	.4byte	0x2c16
	.4byte	0x8955
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL775
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL776
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL777
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL778
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL779
	.4byte	0x2c16
	.uleb128 0x34
	.8byte	.LVL780
	.4byte	0x258a
	.4byte	0x89ad
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL782
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL784
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL787
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL790
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL793
	.4byte	0x2c16
	.uleb128 0x45
	.8byte	.LVL797
	.4byte	0x2c16
	.uleb128 0x36
	.8byte	.LVL800
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC85
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR138
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF864
	.byte	0x3
	.byte	0xb7
	.4byte	0x5b
	.8byte	.LFB205
	.8byte	.LFE205-.LFB205
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8a94
	.uleb128 0x2e
	.4byte	.LASF845
	.byte	0x3
	.byte	0xb7
	.4byte	0x82a7
	.4byte	.LLST8
	.uleb128 0x33
	.string	"i"
	.byte	0x3
	.byte	0xb9
	.4byte	0xdd4
	.4byte	.LLST9
	.uleb128 0x45
	.8byte	.LVL30
	.4byte	0x8add
	.uleb128 0x34
	.8byte	.LVL31
	.4byte	0x8add
	.4byte	0x8a86
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL33
	.4byte	0x8a94
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF865
	.byte	0x3
	.byte	0xa5
	.4byte	0x5b
	.8byte	.LFB204
	.8byte	.LFE204-.LFB204
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8ac5
	.uleb128 0x2e
	.4byte	.LASF866
	.byte	0x3
	.byte	0xa5
	.4byte	0xdc9
	.4byte	.LLST7
	.byte	0
	.uleb128 0x65
	.4byte	.LASF867
	.byte	0x3
	.byte	0x9f
	.byte	0x1
	.4byte	0x8add
	.uleb128 0x38
	.4byte	.LASF868
	.byte	0x3
	.byte	0x9f
	.4byte	0xdd4
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF869
	.byte	0x3
	.byte	0x7f
	.4byte	0xdc9
	.8byte	.LFB202
	.8byte	.LFE202-.LFB202
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8b2a
	.uleb128 0x31
	.string	"num"
	.byte	0x3
	.byte	0x7f
	.4byte	0xdd4
	.4byte	.LLST4
	.uleb128 0x33
	.string	"i"
	.byte	0x3
	.byte	0x81
	.4byte	0xdc9
	.4byte	.LLST5
	.uleb128 0x32
	.4byte	.LASF870
	.byte	0x3
	.byte	0x82
	.4byte	0xdd4
	.4byte	.LLST6
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF871
	.byte	0x3
	.byte	0x71
	.4byte	0x5b
	.8byte	.LFB201
	.8byte	.LFE201-.LFB201
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8bb0
	.uleb128 0x2e
	.4byte	.LASF299
	.byte	0x3
	.byte	0x71
	.4byte	0xfa
	.4byte	.LLST102
	.uleb128 0x33
	.string	"buf"
	.byte	0x3
	.byte	0x73
	.4byte	0xfa
	.4byte	.LLST103
	.uleb128 0x34
	.8byte	.LVL445
	.4byte	0xa971
	.4byte	0x8b9b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC71
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC70
	.byte	0
	.uleb128 0x36
	.8byte	.LVL447
	.4byte	0x8bb0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF872
	.byte	0x3
	.byte	0xb
	.4byte	0x5b
	.8byte	.LFB200
	.8byte	.LFE200-.LFB200
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x963e
	.uleb128 0x2e
	.4byte	.LASF299
	.byte	0x3
	.byte	0xb
	.4byte	0xfa
	.4byte	.LLST97
	.uleb128 0x33
	.string	"i"
	.byte	0x3
	.byte	0xd
	.4byte	0x5b
	.4byte	.LLST98
	.uleb128 0x33
	.string	"buf"
	.byte	0x3
	.byte	0xe
	.4byte	0xfa
	.4byte	.LLST99
	.uleb128 0x63
	.8byte	.LBB217
	.8byte	.LBE217-.LBB217
	.4byte	0x8c58
	.uleb128 0x32
	.4byte	.LASF586
	.byte	0x3
	.byte	0x57
	.4byte	0xdc9
	.4byte	.LLST100
	.uleb128 0x34
	.8byte	.LVL430
	.4byte	0x662a
	.4byte	0x8c37
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL434
	.4byte	0xa971
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x87
	.sleb128 -1
	.byte	0
	.byte	0
	.uleb128 0x63
	.8byte	.LBB218
	.8byte	.LBE218-.LBB218
	.4byte	0x8c9d
	.uleb128 0x32
	.4byte	.LASF586
	.byte	0x3
	.byte	0x60
	.4byte	0xdc9
	.4byte	.LLST101
	.uleb128 0x36
	.8byte	.LVL441
	.4byte	0xa971
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x86
	.sleb128 -1
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL293
	.4byte	0xa971
	.4byte	0x8cc2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC2
	.byte	0
	.uleb128 0x34
	.8byte	.LVL295
	.4byte	0xa971
	.4byte	0x8ce7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC3
	.byte	0
	.uleb128 0x34
	.8byte	.LVL297
	.4byte	0xa971
	.4byte	0x8d0c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL299
	.4byte	0xa971
	.4byte	0x8d31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC5
	.byte	0
	.uleb128 0x34
	.8byte	.LVL301
	.4byte	0xa971
	.4byte	0x8d56
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC6
	.byte	0
	.uleb128 0x34
	.8byte	.LVL303
	.4byte	0xa971
	.4byte	0x8d7b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC7
	.byte	0
	.uleb128 0x34
	.8byte	.LVL305
	.4byte	0xa971
	.4byte	0x8da0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC8
	.byte	0
	.uleb128 0x34
	.8byte	.LVL307
	.4byte	0xa971
	.4byte	0x8dc5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC9
	.byte	0
	.uleb128 0x34
	.8byte	.LVL309
	.4byte	0xa971
	.4byte	0x8dea
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC10
	.byte	0
	.uleb128 0x34
	.8byte	.LVL311
	.4byte	0xa971
	.4byte	0x8e0f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC11
	.byte	0
	.uleb128 0x34
	.8byte	.LVL313
	.4byte	0xa971
	.4byte	0x8e34
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC12
	.byte	0
	.uleb128 0x34
	.8byte	.LVL315
	.4byte	0xa971
	.4byte	0x8e59
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC13
	.byte	0
	.uleb128 0x34
	.8byte	.LVL317
	.4byte	0xa971
	.4byte	0x8e7e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC14
	.byte	0
	.uleb128 0x34
	.8byte	.LVL319
	.4byte	0xa971
	.4byte	0x8ea3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC15
	.byte	0
	.uleb128 0x34
	.8byte	.LVL321
	.4byte	0xa971
	.4byte	0x8ec8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC16
	.byte	0
	.uleb128 0x34
	.8byte	.LVL323
	.4byte	0xa971
	.4byte	0x8eed
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC17
	.byte	0
	.uleb128 0x34
	.8byte	.LVL325
	.4byte	0xa971
	.4byte	0x8f12
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC18
	.byte	0
	.uleb128 0x34
	.8byte	.LVL327
	.4byte	0xa971
	.4byte	0x8f37
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC19
	.byte	0
	.uleb128 0x34
	.8byte	.LVL329
	.4byte	0xa971
	.4byte	0x8f5c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC20
	.byte	0
	.uleb128 0x34
	.8byte	.LVL331
	.4byte	0xa971
	.4byte	0x8f81
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC21
	.byte	0
	.uleb128 0x34
	.8byte	.LVL333
	.4byte	0xa971
	.4byte	0x8fa6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC22
	.byte	0
	.uleb128 0x34
	.8byte	.LVL335
	.4byte	0xa971
	.4byte	0x8fcb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC23
	.byte	0
	.uleb128 0x34
	.8byte	.LVL337
	.4byte	0xa971
	.4byte	0x8ff0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC24
	.byte	0
	.uleb128 0x34
	.8byte	.LVL339
	.4byte	0xa971
	.4byte	0x9015
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC25
	.byte	0
	.uleb128 0x34
	.8byte	.LVL341
	.4byte	0xa971
	.4byte	0x903a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC26
	.byte	0
	.uleb128 0x34
	.8byte	.LVL343
	.4byte	0xa971
	.4byte	0x905f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC27
	.byte	0
	.uleb128 0x34
	.8byte	.LVL345
	.4byte	0xa971
	.4byte	0x9084
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC28
	.byte	0
	.uleb128 0x34
	.8byte	.LVL347
	.4byte	0xa971
	.4byte	0x90a9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC29
	.byte	0
	.uleb128 0x34
	.8byte	.LVL349
	.4byte	0xa971
	.4byte	0x90ce
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL351
	.4byte	0xa971
	.4byte	0x90f3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL353
	.4byte	0xa971
	.4byte	0x9118
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC32
	.byte	0
	.uleb128 0x34
	.8byte	.LVL355
	.4byte	0xa971
	.4byte	0x913d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC33
	.byte	0
	.uleb128 0x34
	.8byte	.LVL357
	.4byte	0xa971
	.4byte	0x9162
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC34
	.byte	0
	.uleb128 0x34
	.8byte	.LVL359
	.4byte	0xa971
	.4byte	0x9187
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC35
	.byte	0
	.uleb128 0x34
	.8byte	.LVL361
	.4byte	0xa971
	.4byte	0x91ac
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC36
	.byte	0
	.uleb128 0x34
	.8byte	.LVL363
	.4byte	0xa971
	.4byte	0x91d1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC37
	.byte	0
	.uleb128 0x34
	.8byte	.LVL365
	.4byte	0xa971
	.4byte	0x91f6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC38
	.byte	0
	.uleb128 0x34
	.8byte	.LVL367
	.4byte	0xa971
	.4byte	0x921b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC39
	.byte	0
	.uleb128 0x34
	.8byte	.LVL369
	.4byte	0xa971
	.4byte	0x9240
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL371
	.4byte	0xa971
	.4byte	0x9265
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC41
	.byte	0
	.uleb128 0x34
	.8byte	.LVL373
	.4byte	0xa971
	.4byte	0x928a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC42
	.byte	0
	.uleb128 0x34
	.8byte	.LVL375
	.4byte	0xa971
	.4byte	0x92af
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC43
	.byte	0
	.uleb128 0x34
	.8byte	.LVL377
	.4byte	0xa971
	.4byte	0x92d4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC44
	.byte	0
	.uleb128 0x34
	.8byte	.LVL379
	.4byte	0xa971
	.4byte	0x92f9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC45
	.byte	0
	.uleb128 0x34
	.8byte	.LVL381
	.4byte	0xa971
	.4byte	0x931e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC46
	.byte	0
	.uleb128 0x34
	.8byte	.LVL383
	.4byte	0xa971
	.4byte	0x9343
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC47
	.byte	0
	.uleb128 0x34
	.8byte	.LVL385
	.4byte	0xa971
	.4byte	0x9368
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC48
	.byte	0
	.uleb128 0x34
	.8byte	.LVL387
	.4byte	0xa971
	.4byte	0x938d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC49
	.byte	0
	.uleb128 0x34
	.8byte	.LVL389
	.4byte	0xa971
	.4byte	0x93b2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC50
	.byte	0
	.uleb128 0x34
	.8byte	.LVL391
	.4byte	0xa971
	.4byte	0x93d7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC51
	.byte	0
	.uleb128 0x34
	.8byte	.LVL393
	.4byte	0xa971
	.4byte	0x93fc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC52
	.byte	0
	.uleb128 0x34
	.8byte	.LVL395
	.4byte	0xa971
	.4byte	0x9421
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC53
	.byte	0
	.uleb128 0x34
	.8byte	.LVL397
	.4byte	0xa971
	.4byte	0x9446
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC54
	.byte	0
	.uleb128 0x34
	.8byte	.LVL399
	.4byte	0xa971
	.4byte	0x946b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC55
	.byte	0
	.uleb128 0x34
	.8byte	.LVL401
	.4byte	0xa971
	.4byte	0x9490
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC56
	.byte	0
	.uleb128 0x34
	.8byte	.LVL403
	.4byte	0xa971
	.4byte	0x94b5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC57
	.byte	0
	.uleb128 0x34
	.8byte	.LVL405
	.4byte	0xa971
	.4byte	0x94da
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC58
	.byte	0
	.uleb128 0x34
	.8byte	.LVL407
	.4byte	0xa971
	.4byte	0x94ff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC59
	.byte	0
	.uleb128 0x34
	.8byte	.LVL409
	.4byte	0xa971
	.4byte	0x9524
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC60
	.byte	0
	.uleb128 0x34
	.8byte	.LVL411
	.4byte	0xa971
	.4byte	0x9549
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC61
	.byte	0
	.uleb128 0x34
	.8byte	.LVL413
	.4byte	0xa971
	.4byte	0x956e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC62
	.byte	0
	.uleb128 0x34
	.8byte	.LVL415
	.4byte	0xa971
	.4byte	0x9593
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC63
	.byte	0
	.uleb128 0x34
	.8byte	.LVL417
	.4byte	0xa971
	.4byte	0x95b8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC64
	.byte	0
	.uleb128 0x45
	.8byte	.LVL419
	.4byte	0x3ebe
	.uleb128 0x34
	.8byte	.LVL420
	.4byte	0xa971
	.4byte	0x95ea
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC65
	.byte	0
	.uleb128 0x45
	.8byte	.LVL422
	.4byte	0x3e5d
	.uleb128 0x34
	.8byte	.LVL423
	.4byte	0xa971
	.4byte	0x961c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC66
	.byte	0
	.uleb128 0x36
	.8byte	.LVL428
	.4byte	0xa971
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC67
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x2a88
	.8byte	.LFB349
	.8byte	.LFE349-.LFB349
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x96a0
	.uleb128 0x6d
	.4byte	0x2aa3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x6d
	.4byte	0x2aae
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x6e
	.4byte	0x2a98
	.uleb128 0x6f
	.4byte	0x2ab9
	.4byte	.LLST0
	.uleb128 0x70
	.4byte	0x2ac4
	.uleb128 0x6f
	.4byte	0x2acf
	.4byte	.LLST1
	.uleb128 0x71
	.4byte	0x2ada
	.uleb128 0x1
	.byte	0x56
	.uleb128 0x71
	.4byte	0x2ae5
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x6f
	.4byte	0x2af0
	.4byte	.LLST2
	.uleb128 0x70
	.4byte	0x2afb
	.byte	0
	.uleb128 0x6c
	.4byte	0x53f4
	.8byte	.LFB355
	.8byte	.LFE355-.LFB355
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x96d1
	.uleb128 0x47
	.4byte	0x5401
	.4byte	.LLST3
	.uleb128 0x6d
	.4byte	0x540d
	.uleb128 0x6
	.byte	0xfa
	.4byte	0x540d
	.byte	0x9f
	.byte	0
	.uleb128 0x6c
	.4byte	0x8ac5
	.8byte	.LFB203
	.8byte	.LFE203-.LFB203
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x96f4
	.uleb128 0x6d
	.4byte	0x8ad1
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.uleb128 0x6c
	.4byte	0x862f
	.8byte	.LFB208
	.8byte	.LFE208-.LFB208
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9738
	.uleb128 0x47
	.4byte	0x8640
	.4byte	.LLST10
	.uleb128 0x70
	.4byte	0x864c
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0
	.uleb128 0x6e
	.4byte	0x8640
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0
	.uleb128 0x6f
	.4byte	0x9718
	.4byte	.LLST11
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x73
	.4byte	0x7ca2
	.8byte	.LFB216
	.8byte	.LFE216-.LFB216
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x73
	.4byte	0x751a
	.8byte	.LFB224
	.8byte	.LFE224-.LFB224
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x73
	.4byte	0x6b8f
	.8byte	.LFB238
	.8byte	.LFE238-.LFB238
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x73
	.4byte	0x6b83
	.8byte	.LFB239
	.8byte	.LFE239-.LFB239
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x6c
	.4byte	0x692c
	.8byte	.LFB245
	.8byte	.LFE245-.LFB245
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9837
	.uleb128 0x47
	.4byte	0x6938
	.4byte	.LLST43
	.uleb128 0x70
	.4byte	0x6943
	.uleb128 0x63
	.8byte	.LBB195
	.8byte	.LBE195-.LBB195
	.4byte	0x9821
	.uleb128 0x47
	.4byte	0x6938
	.4byte	.LLST44
	.uleb128 0x74
	.8byte	.LBB196
	.8byte	.LBE196-.LBB196
	.uleb128 0x70
	.4byte	0x97b8
	.uleb128 0x2f
	.8byte	.LVL119
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR46
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xdd
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL117
	.4byte	0x6882
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x6951
	.8byte	.LFB244
	.8byte	.LFE244-.LFB244
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x98da
	.uleb128 0x47
	.4byte	0x695d
	.4byte	.LLST50
	.uleb128 0x70
	.4byte	0x6968
	.uleb128 0x63
	.8byte	.LBB199
	.8byte	.LBE199-.LBB199
	.4byte	0x98c4
	.uleb128 0x47
	.4byte	0x695d
	.4byte	.LLST51
	.uleb128 0x74
	.8byte	.LBB200
	.8byte	.LBE200-.LBB200
	.uleb128 0x70
	.4byte	0x985b
	.uleb128 0x2f
	.8byte	.LVL139
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR49
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xd6
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL137
	.4byte	0x6801
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x65ab
	.8byte	.LFB252
	.8byte	.LFE252-.LFB252
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9a37
	.uleb128 0x47
	.4byte	0x65bc
	.4byte	.LLST64
	.uleb128 0x70
	.4byte	0x65c8
	.uleb128 0x70
	.4byte	0x65d4
	.uleb128 0x70
	.4byte	0x65e0
	.uleb128 0x70
	.4byte	0x65ec
	.uleb128 0x70
	.4byte	0x65f8
	.uleb128 0x70
	.4byte	0x6604
	.uleb128 0x70
	.4byte	0x6610
	.uleb128 0x70
	.4byte	0x661c
	.uleb128 0x74
	.8byte	.LBB203
	.8byte	.LBE203-.LBB203
	.uleb128 0x47
	.4byte	0x65bc
	.4byte	.LLST65
	.uleb128 0x74
	.8byte	.LBB204
	.8byte	.LBE204-.LBB204
	.uleb128 0x6f
	.4byte	0x98fe
	.4byte	.LLST66
	.uleb128 0x6f
	.4byte	0x9903
	.4byte	.LLST67
	.uleb128 0x6f
	.4byte	0x9908
	.4byte	.LLST68
	.uleb128 0x6f
	.4byte	0x990d
	.4byte	.LLST69
	.uleb128 0x6f
	.4byte	0x9912
	.4byte	.LLST70
	.uleb128 0x6f
	.4byte	0x9917
	.4byte	.LLST71
	.uleb128 0x6f
	.4byte	0x991c
	.4byte	.LLST72
	.uleb128 0x70
	.4byte	0x9921
	.uleb128 0x34
	.8byte	.LVL189
	.4byte	0xa94f
	.4byte	0x99c8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR54
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x1d6
	.byte	0
	.uleb128 0x34
	.8byte	.LVL199
	.4byte	0x6747
	.4byte	0x99ed
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR41
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL200
	.4byte	0xa94f
	.4byte	0x9a20
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR54
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x1e1
	.byte	0
	.uleb128 0x36
	.8byte	.LVL201
	.4byte	0x692c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x592a
	.8byte	.LFB266
	.8byte	.LFE266-.LFB266
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9a7d
	.uleb128 0x47
	.4byte	0x5937
	.4byte	.LLST76
	.uleb128 0x75
	.4byte	0x5943
	.byte	0
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x60
	.uleb128 0x6d
	.4byte	0x5937
	.uleb128 0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x60
	.uleb128 0x70
	.4byte	0x9a5b
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x53f4
	.8byte	.LFB272
	.8byte	.LFE272-.LFB272
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9ac9
	.uleb128 0x47
	.4byte	0x5401
	.4byte	.LLST77
	.uleb128 0x47
	.4byte	0x540d
	.4byte	.LLST78
	.uleb128 0x2f
	.8byte	.LVL232
	.4byte	0x96a0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3e
	.4byte	0x540d
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x474b
	.8byte	.LFB282
	.8byte	.LFE282-.LFB282
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9b27
	.uleb128 0x6d
	.4byte	0x4758
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x70
	.4byte	0x4764
	.uleb128 0x74
	.8byte	.LBB215
	.8byte	.LBE215-.LBB215
	.uleb128 0x47
	.4byte	0x4758
	.4byte	.LLST83
	.uleb128 0x74
	.8byte	.LBB216
	.8byte	.LBE216-.LBB216
	.uleb128 0x6f
	.4byte	0x9aeb
	.4byte	.LLST84
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x3d63
	.8byte	.LFB297
	.8byte	.LFE297-.LFB297
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9b70
	.uleb128 0x47
	.4byte	0x3d74
	.4byte	.LLST112
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0xa0
	.uleb128 0x47
	.4byte	0x3d74
	.4byte	.LLST113
	.uleb128 0x36
	.8byte	.LVL481
	.4byte	0x6951
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x2eaf
	.8byte	.LFB316
	.8byte	.LFE316-.LFB316
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9ba6
	.uleb128 0x45
	.8byte	.LVL553
	.4byte	0x6d33
	.uleb128 0x45
	.8byte	.LVL554
	.4byte	0x2f5e
	.byte	0
	.uleb128 0x6c
	.4byte	0x6b48
	.8byte	.LFB240
	.8byte	.LFE240-.LFB240
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9c75
	.uleb128 0x47
	.4byte	0x6b54
	.4byte	.LLST175
	.uleb128 0x47
	.4byte	0x6b5f
	.4byte	.LLST176
	.uleb128 0x76
	.4byte	0x6b83
	.8byte	.LBB241
	.8byte	.LBE241-.LBB241
	.byte	0x2
	.byte	0x65
	.uleb128 0x74
	.8byte	.LBB243
	.8byte	.LBE243-.LBB243
	.uleb128 0x47
	.4byte	0x6b5f
	.4byte	.LLST177
	.uleb128 0x47
	.4byte	0x6b54
	.4byte	.LLST178
	.uleb128 0x74
	.8byte	.LBB244
	.8byte	.LBE244-.LBB244
	.uleb128 0x6f
	.4byte	0x6b6b
	.4byte	.LLST179
	.uleb128 0x74
	.8byte	.LBB245
	.8byte	.LBE245-.LBB245
	.uleb128 0x6f
	.4byte	0x6b75
	.4byte	.LLST180
	.uleb128 0x34
	.8byte	.LVL658
	.4byte	0x6d33
	.4byte	0x9c59
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL661
	.4byte	0x270c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x62e8
	.8byte	.LFB255
	.8byte	.LFE255-.LFB255
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9d48
	.uleb128 0x47
	.4byte	0x62f9
	.4byte	.LLST193
	.uleb128 0x6f
	.4byte	0x6305
	.4byte	.LLST194
	.uleb128 0x6f
	.4byte	0x6311
	.4byte	.LLST195
	.uleb128 0x70
	.4byte	0x631d
	.uleb128 0x63
	.8byte	.LBB258
	.8byte	.LBE258-.LBB258
	.4byte	0x9d1f
	.uleb128 0x47
	.4byte	0x62f9
	.4byte	.LLST196
	.uleb128 0x74
	.8byte	.LBB259
	.8byte	.LBE259-.LBB259
	.uleb128 0x70
	.4byte	0x9c99
	.uleb128 0x70
	.4byte	0x9ca2
	.uleb128 0x70
	.4byte	0x9cab
	.uleb128 0x36
	.8byte	.LVL736
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR116
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x245
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL733
	.4byte	0x6976
	.uleb128 0x36
	.8byte	.LVL734
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC84
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x2e05
	.8byte	.LFB318
	.8byte	.LFE318-.LFB318
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9e42
	.uleb128 0x75
	.4byte	0x2e16
	.byte	0
	.uleb128 0x70
	.4byte	0x2e22
	.uleb128 0x70
	.4byte	0x2e2c
	.uleb128 0x70
	.4byte	0x2e38
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x1c0
	.4byte	0x9e17
	.uleb128 0x70
	.4byte	0x9d63
	.uleb128 0x6f
	.4byte	0x9d69
	.4byte	.LLST252
	.uleb128 0x71
	.4byte	0x9d6e
	.uleb128 0x3
	.byte	0x91
	.sleb128 -100
	.uleb128 0x71
	.4byte	0x9d73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x63
	.8byte	.LBB269
	.8byte	.LBE269-.LBB269
	.4byte	0x9dfc
	.uleb128 0x71
	.4byte	0x2e49
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x34
	.8byte	.LVL970
	.4byte	0x298f
	.4byte	0x9de1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 96
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL971
	.4byte	0x6d33
	.uleb128 0x45
	.8byte	.LVL972
	.4byte	0x2f5e
	.byte	0
	.uleb128 0x36
	.8byte	.LVL969
	.4byte	0x5c1c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 92
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x74
	.8byte	.LBB276
	.8byte	.LBE276-.LBB276
	.uleb128 0x71
	.4byte	0x2e57
	.uleb128 0x12
	.byte	0x40
	.byte	0x45
	.byte	0x24
	.byte	0x3
	.8byte	g_max_erase_count
	.byte	0x94
	.byte	0x4
	.byte	0x3a
	.byte	0x25
	.byte	0x26
	.byte	0x9f
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x26b8
	.8byte	.LFB344
	.8byte	.LFE344-.LFB344
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9f76
	.uleb128 0x47
	.4byte	0x26c8
	.4byte	.LLST298
	.uleb128 0x75
	.4byte	0x26d3
	.byte	0
	.uleb128 0x70
	.4byte	0x26de
	.uleb128 0x70
	.4byte	0x26e9
	.uleb128 0x74
	.8byte	.LBB281
	.8byte	.LBE281-.LBB281
	.uleb128 0x47
	.4byte	0x26c8
	.4byte	.LLST299
	.uleb128 0x74
	.8byte	.LBB282
	.8byte	.LBE282-.LBB282
	.uleb128 0x70
	.4byte	0x9e66
	.uleb128 0x71
	.4byte	0x9e6c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x71
	.4byte	0x9e71
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x77
	.4byte	0x26f4
	.8byte	.LDL1
	.uleb128 0x34
	.8byte	.LVL1222
	.4byte	0x258a
	.4byte	0x9ee9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 80
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xa5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x20
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1224
	.4byte	0x258a
	.4byte	0x9f0c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0x5a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x38
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1225
	.4byte	0x270c
	.4byte	0x9f2e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8f
	.sleb128 48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1226
	.4byte	0x27d2
	.4byte	0x9f55
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8f
	.sleb128 48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1228
	.4byte	0x270c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8f
	.sleb128 48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x2e65
	.8byte	.LFB317
	.8byte	.LFE317-.LFB317
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa04f
	.uleb128 0x47
	.4byte	0x2e76
	.4byte	.LLST319
	.uleb128 0x70
	.4byte	0x2e82
	.uleb128 0x70
	.4byte	0x2e8e
	.uleb128 0x70
	.4byte	0x2e98
	.uleb128 0x70
	.4byte	0x2ea2
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x240
	.uleb128 0x6e
	.4byte	0x2e76
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x240
	.uleb128 0x6f
	.4byte	0x9f9a
	.4byte	.LLST320
	.uleb128 0x71
	.4byte	0x9f9f
	.uleb128 0x1
	.byte	0x64
	.uleb128 0x6f
	.4byte	0x9fa4
	.4byte	.LLST321
	.uleb128 0x71
	.4byte	0x9fa9
	.uleb128 0x1
	.byte	0x6a
	.uleb128 0x45
	.8byte	.LVL1315
	.4byte	0x2eaf
	.uleb128 0x34
	.8byte	.LVL1318
	.4byte	0x6dce
	.4byte	0xa002
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1322
	.4byte	0xa94f
	.4byte	0xa027
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC100
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1323
	.4byte	0x75b1
	.4byte	0xa03f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1324
	.4byte	0x7304
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x3795
	.8byte	.LFB301
	.8byte	.LFE301-.LFB301
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa17a
	.uleb128 0x47
	.4byte	0x37a6
	.4byte	.LLST322
	.uleb128 0x70
	.4byte	0x37b2
	.uleb128 0x63
	.8byte	.LBB295
	.8byte	.LBE295-.LBB295
	.4byte	0xa165
	.uleb128 0x47
	.4byte	0x37a6
	.4byte	.LLST323
	.uleb128 0x74
	.8byte	.LBB296
	.8byte	.LBE296-.LBB296
	.uleb128 0x70
	.4byte	0xa073
	.uleb128 0x34
	.8byte	.LVL1333
	.4byte	0x6747
	.4byte	0xa0d1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR41
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1334
	.4byte	0xa94f
	.4byte	0xa104
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR158
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xabb
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1335
	.4byte	0x3d63
	.4byte	0xa11c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1336
	.4byte	0x2e65
	.4byte	0xa134
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1337
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR158
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xabe
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1340
	.4byte	0x65ab
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x5829
	.8byte	.LFB268
	.8byte	.LFE268-.LFB268
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa273
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x280
	.uleb128 0x6f
	.4byte	0x5837
	.4byte	.LLST326
	.uleb128 0x71
	.4byte	0x5843
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x6f
	.4byte	0x584f
	.4byte	.LLST327
	.uleb128 0x71
	.4byte	0x585b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x6f
	.4byte	0x5867
	.4byte	.LLST328
	.uleb128 0x34
	.8byte	.LVL1353
	.4byte	0x5c1c
	.4byte	0xa1e9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 156
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1355
	.4byte	0x298f
	.4byte	0xa20c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 160
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1359
	.4byte	0x258a
	.4byte	0xa224
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1361
	.4byte	0x37d5
	.4byte	0xa23c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1362
	.4byte	0x27d2
	.4byte	0xa264
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x8f
	.sleb128 160
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1363
	.4byte	0x3691
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x44a0
	.8byte	.LFB286
	.8byte	.LFE286-.LFB286
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa2b4
	.uleb128 0x2f
	.8byte	.LVL1623
	.4byte	0x5ade
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR81
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x541a
	.8byte	.LFB271
	.8byte	.LFE271-.LFB271
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa327
	.uleb128 0x34
	.8byte	.LVL1660
	.4byte	0x59b6
	.4byte	0xa2e7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1661
	.4byte	0xa94f
	.4byte	0xa313
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC71
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC103
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1662
	.4byte	0x258a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x311d
	.8byte	.LFB311
	.8byte	.LFE311-.LFB311
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa38d
	.uleb128 0x34
	.8byte	.LVL1799
	.4byte	0x3126
	.4byte	0xa35a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1800
	.4byte	0x5875
	.4byte	0xa379
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1801
	.4byte	0x32fe
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x2d1d
	.8byte	.LFB319
	.8byte	.LFE319-.LFB319
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa742
	.uleb128 0x47
	.4byte	0x2d2e
	.4byte	.LLST412
	.uleb128 0x47
	.4byte	0x2d3a
	.4byte	.LLST413
	.uleb128 0x75
	.4byte	0x2d46
	.byte	0x1
	.uleb128 0x70
	.4byte	0x2d52
	.uleb128 0x70
	.4byte	0x2d5e
	.uleb128 0x78
	.4byte	0x2d6a
	.sleb128 -1
	.uleb128 0x70
	.4byte	0x2d76
	.uleb128 0x70
	.4byte	0x2d82
	.uleb128 0x70
	.4byte	0x2d8e
	.uleb128 0x70
	.4byte	0x2d9a
	.uleb128 0x70
	.4byte	0x2da6
	.uleb128 0x70
	.4byte	0x2db2
	.uleb128 0x70
	.4byte	0x2dce
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x330
	.4byte	0xa72e
	.uleb128 0x47
	.4byte	0x2d3a
	.4byte	.LLST414
	.uleb128 0x47
	.4byte	0x2d2e
	.4byte	.LLST415
	.uleb128 0x72
	.4byte	.Ldebug_ranges0+0x330
	.uleb128 0x70
	.4byte	0xa3ba
	.uleb128 0x6f
	.4byte	0xa3c0
	.4byte	.LLST416
	.uleb128 0x71
	.4byte	0xa3c5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x70
	.4byte	0xa3ca
	.uleb128 0x6f
	.4byte	0xa3d0
	.4byte	.LLST417
	.uleb128 0x6f
	.4byte	0xa3d5
	.4byte	.LLST418
	.uleb128 0x6f
	.4byte	0xa3da
	.4byte	.LLST419
	.uleb128 0x6f
	.4byte	0xa3df
	.4byte	.LLST420
	.uleb128 0x6f
	.4byte	0xa3e4
	.4byte	.LLST421
	.uleb128 0x6f
	.4byte	0xa3e9
	.4byte	.LLST422
	.uleb128 0x79
	.4byte	0x2dbe
	.uleb128 0x79
	.4byte	0x2dc6
	.uleb128 0x70
	.4byte	0xa3ee
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x360
	.4byte	0xa4f0
	.uleb128 0x6f
	.4byte	0x2ddc
	.4byte	.LLST423
	.uleb128 0x45
	.8byte	.LVL1833
	.4byte	0x3d81
	.uleb128 0x34
	.8byte	.LVL1836
	.4byte	0x662a
	.4byte	0xa4aa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1839
	.4byte	0x662a
	.4byte	0xa4c1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1842
	.4byte	0x2eaf
	.uleb128 0x36
	.8byte	.LVL1851
	.4byte	0xa94f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC107
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1863
	.4byte	0x3580
	.uleb128 0x34
	.8byte	.LVL1864
	.4byte	0x45ef
	.4byte	0xa515
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1866
	.4byte	0x662a
	.4byte	0xa52d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1871
	.4byte	0x2e05
	.uleb128 0x34
	.8byte	.LVL1873
	.4byte	0x662a
	.4byte	0xa551
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1875
	.4byte	0x3691
	.4byte	0xa569
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1880
	.4byte	0x3580
	.4byte	0xa581
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1881
	.4byte	0x3691
	.4byte	0xa599
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1882
	.4byte	0xa94f
	.4byte	0xa5cc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR175
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x292
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1883
	.4byte	0xa94f
	.4byte	0xa5ff
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR175
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x293
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1884
	.4byte	0xa94f
	.4byte	0xa632
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR175
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x294
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1885
	.4byte	0x45ef
	.4byte	0xa64a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1886
	.4byte	0x2e05
	.uleb128 0x34
	.8byte	.LVL1900
	.4byte	0x298f
	.4byte	0xa66f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1909
	.4byte	0xa94f
	.4byte	0xa6a2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR175
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2b8
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1911
	.4byte	0x5c1c
	.4byte	0xa6c0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0x8f
	.sleb128 348
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1912
	.4byte	0x3078
	.uleb128 0x34
	.8byte	.LVL1913
	.4byte	0x35be
	.4byte	0xa6eb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x71
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1914
	.4byte	0x2fb2
	.uleb128 0x45
	.8byte	.LVL1918
	.4byte	0x2fb2
	.uleb128 0x45
	.8byte	.LVL1919
	.4byte	0x3795
	.uleb128 0x45
	.8byte	.LVL1920
	.4byte	0x5d49
	.uleb128 0x45
	.8byte	.LVL1921
	.4byte	0x567a
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1846
	.4byte	0x32fe
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x6c
	.4byte	0x3f79
	.8byte	.LFB292
	.8byte	.LFE292-.LFB292
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa92c
	.uleb128 0x75
	.4byte	0x3f8a
	.byte	0
	.uleb128 0x63
	.8byte	.LBB339
	.8byte	.LBE339-.LBB339
	.4byte	0xa896
	.uleb128 0x70
	.4byte	0xa75d
	.uleb128 0x63
	.8byte	.LBB340
	.8byte	.LBE340-.LBB340
	.4byte	0xa79c
	.uleb128 0x6f
	.4byte	0x3f95
	.4byte	.LLST463
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2086
	.4byte	0x4387
	.4byte	0xa7b4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2087
	.4byte	0x4387
	.4byte	0xa7cc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2089
	.4byte	0x5875
	.4byte	0xa7eb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2090
	.4byte	0x5875
	.4byte	0xa80a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR149
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2091
	.4byte	0x5d49
	.uleb128 0x45
	.8byte	.LVL2092
	.4byte	0x567a
	.uleb128 0x45
	.8byte	.LVL2093
	.4byte	0x567a
	.uleb128 0x45
	.8byte	.LVL2094
	.4byte	0x2f5e
	.uleb128 0x45
	.8byte	.LVL2095
	.4byte	0x2f5e
	.uleb128 0x34
	.8byte	.LVL2096
	.4byte	0x3903
	.4byte	0xa863
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2097
	.4byte	0x3903
	.4byte	0xa87b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2098
	.4byte	0x423e
	.uleb128 0x45
	.8byte	.LVL2102
	.4byte	0x5d49
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2073
	.4byte	0x6b9b
	.uleb128 0x45
	.8byte	.LVL2074
	.4byte	0x5427
	.uleb128 0x45
	.8byte	.LVL2075
	.4byte	0x51e2
	.uleb128 0x45
	.8byte	.LVL2076
	.4byte	0x4f21
	.uleb128 0x45
	.8byte	.LVL2077
	.4byte	0x4fc6
	.uleb128 0x45
	.8byte	.LVL2078
	.4byte	0x443f
	.uleb128 0x45
	.8byte	.LVL2079
	.4byte	0x541a
	.uleb128 0x45
	.8byte	.LVL2080
	.4byte	0x6ade
	.uleb128 0x45
	.8byte	.LVL2081
	.4byte	0x44a9
	.uleb128 0x45
	.8byte	.LVL2082
	.4byte	0x46a7
	.uleb128 0x36
	.8byte	.LVL2083
	.4byte	0x592a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x7a
	.4byte	.LASF873
	.4byte	.LASF873
	.byte	0xb
	.byte	0x72
	.uleb128 0x7b
	.4byte	.LASF874
	.4byte	.LASF874
	.byte	0x1c
	.2byte	0x16d
	.uleb128 0x7b
	.4byte	.LASF875
	.4byte	.LASF875
	.byte	0x1c
	.2byte	0x16c
	.uleb128 0x7a
	.4byte	.LASF876
	.4byte	.LASF876
	.byte	0x1d
	.byte	0x12
	.uleb128 0x7a
	.4byte	.LASF877
	.4byte	.LASF877
	.byte	0x6
	.byte	0x35
	.uleb128 0x7b
	.4byte	.LASF878
	.4byte	.LASF878
	.byte	0x1c
	.2byte	0x399
	.uleb128 0x7a
	.4byte	.LASF879
	.4byte	.LASF879
	.byte	0x1e
	.byte	0x6d
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x34
	.byte	0
	.uleb128 0x47
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2e
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2f
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x2115
	.uleb128 0x19
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x30
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x31
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x32
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x33
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x34
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x35
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x36
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x37
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x38
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x39
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3b
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x3c
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3d
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x3e
	.uleb128 0x410a
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x3f
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x40
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x41
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x42
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x43
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x44
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x2115
	.uleb128 0x19
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x45
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x46
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x47
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x48
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x49
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4b
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4c
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4d
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4e
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x4f
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0x19
	.uleb128 0x1c
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x50
	.uleb128 0xb
	.byte	0x1
	.byte	0
	.byte	0
	.uleb128 0x51
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x52
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x53
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x54
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x55
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x56
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x57
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x58
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x59
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x5a
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x2115
	.uleb128 0x19
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5b
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x5c
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x5d
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x5e
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x60
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x61
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x62
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x63
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x64
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x65
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x66
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x67
	.uleb128 0x1d
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x68
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x69
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x6a
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6b
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x6c
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6d
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6e
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6f
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x70
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x71
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x72
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x73
	.uleb128 0x2e
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x74
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x75
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x76
	.uleb128 0x1d
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x77
	.uleb128 0xa
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x78
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x79
	.uleb128 0xa
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7a
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7b
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST469:
	.8byte	.LVL2155
	.8byte	.LVL2156-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2156-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST470:
	.8byte	.LVL2155
	.8byte	.LVL2156-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2156-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST471:
	.8byte	.LVL2155
	.8byte	.LVL2156-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2156-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST304:
	.8byte	.LVL1244
	.8byte	.LVL1245-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1245-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST305:
	.8byte	.LVL1244
	.8byte	.LVL1245-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1245-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST306:
	.8byte	.LVL1244
	.8byte	.LVL1245-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1245-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST197:
	.8byte	.LVL741
	.8byte	.LVL742-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL742-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST198:
	.8byte	.LVL741
	.8byte	.LVL742-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL742-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST199:
	.8byte	.LVL741
	.8byte	.LVL742-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL742-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST300:
	.8byte	.LVL1230
	.8byte	.LVL1232-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1232-1
	.8byte	.LVL1240
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1240
	.8byte	.LVL1241
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1241
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST301:
	.8byte	.LVL1230
	.8byte	.LVL1231
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1231
	.8byte	.LVL1240
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1240
	.8byte	.LVL1241
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1241
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST302:
	.8byte	.LVL1234
	.8byte	.LVL1235
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1236
	.8byte	.LVL1237
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1237
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST303:
	.8byte	.LVL1238
	.8byte	.LVL1239
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1241
	.8byte	.LVL1242
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1242
	.8byte	.LVL1243
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST168:
	.8byte	.LVL641
	.8byte	.LVL645
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL645
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST169:
	.8byte	.LVL641
	.8byte	.LVL642
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL642
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST170:
	.8byte	.LVL641
	.8byte	.LVL643
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL643
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST171:
	.8byte	.LVL644
	.8byte	.LVL645
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST172:
	.8byte	.LVL649
	.8byte	.LVL650
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL651
	.8byte	.LVL652
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL653
	.8byte	.LVL654
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST173:
	.8byte	.LVL641
	.8byte	.LVL645
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL645
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST174:
	.8byte	.LVL644
	.8byte	.LVL646
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL647
	.8byte	.LFE343
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST160:
	.8byte	.LVL617
	.8byte	.LVL622
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL622
	.8byte	.LVL623
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL623
	.8byte	.LVL626
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL626
	.8byte	.LVL635
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL635
	.8byte	.LVL640
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL640
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST161:
	.8byte	.LVL617
	.8byte	.LVL618
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL618
	.8byte	.LFE342
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST162:
	.8byte	.LVL617
	.8byte	.LVL619
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL619
	.8byte	.LVL624
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL624
	.8byte	.LVL626
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL626
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST163:
	.8byte	.LVL617
	.8byte	.LVL620
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL620
	.8byte	.LVL623
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL623
	.8byte	.LVL626
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL626
	.8byte	.LVL635
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL635
	.8byte	.LVL640
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL640
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST164:
	.8byte	.LVL621
	.8byte	.LVL622
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST165:
	.8byte	.LVL629
	.8byte	.LVL630
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL631
	.8byte	.LVL632
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL633
	.8byte	.LVL634
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST166:
	.8byte	.LVL621
	.8byte	.LVL625
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL626
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST167:
	.8byte	.LVL621
	.8byte	.LVL622
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL622
	.8byte	.LVL623
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL623
	.8byte	.LVL626
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL626
	.8byte	.LVL635
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL635
	.8byte	.LVL640
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL640
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST145:
	.8byte	.LVL574
	.8byte	.LVL578
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL578
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST146:
	.8byte	.LVL574
	.8byte	.LVL576
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL576
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST147:
	.8byte	.LVL574
	.8byte	.LVL575
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL575
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST148:
	.8byte	.LVL577
	.8byte	.LVL578
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST149:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL584
	.8byte	.LVL585-1
	.2byte	0x2
	.byte	0x83
	.sleb128 0
	.8byte	.LVL585
	.8byte	.LVL586
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST150:
	.8byte	.LVL577
	.8byte	.LVL579
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL580
	.8byte	.LFE341
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST136:
	.8byte	.LVL559
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL561
	.8byte	.LVL565
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL565
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST137:
	.8byte	.LVL559
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL561
	.8byte	.LVL563
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL563
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST138:
	.8byte	.LVL559
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL561
	.8byte	.LVL564
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL564
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST139:
	.8byte	.LVL559
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL561
	.8byte	.LVL565
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL565
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST140:
	.8byte	.LVL560
	.8byte	.LVL561
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL561
	.8byte	.LVL562
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL566
	.8byte	.LVL571
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL571
	.8byte	.LVL572
	.2byte	0x3
	.byte	0x83
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL573
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST141:
	.8byte	.LVL560
	.8byte	.LVL561
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL561
	.8byte	.LVL562
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL566
	.8byte	.LVL570
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL570
	.8byte	.LVL571
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL571
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST142:
	.8byte	.LVL560
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL561
	.8byte	.LVL563
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL563
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST143:
	.8byte	.LVL560
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL561
	.8byte	.LVL563
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL563
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST144:
	.8byte	.LVL560
	.8byte	.LVL561
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL561
	.8byte	.LVL563
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL563
	.8byte	.LVL566
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL566
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST135:
	.8byte	.LVL557
	.8byte	.LVL558-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL558-1
	.8byte	.LFE338
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST133:
	.8byte	.LVL555
	.8byte	.LVL556-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL556-1
	.8byte	.LFE337
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST134:
	.8byte	.LVL555
	.8byte	.LVL556-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL556-1
	.8byte	.LFE337
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST130:
	.8byte	.LVL540
	.8byte	.LVL541
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL541
	.8byte	.LVL552
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL552
	.8byte	.LFE315
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST131:
	.8byte	.LVL546
	.8byte	.LVL547
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL547
	.8byte	.LVL548
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL549
	.8byte	.LVL550
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST132:
	.8byte	.LVL543
	.8byte	.LVL544
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL544
	.8byte	.LVL551
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST129:
	.8byte	.LVL536
	.8byte	.LVL537
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL537
	.8byte	.LVL538-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL538-1
	.8byte	.LVL539
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL539
	.8byte	.LFE314
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST410:
	.8byte	.LVL1808
	.8byte	.LVL1809
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1809
	.8byte	.LVL1810-1
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1812
	.8byte	.LVL1813-1
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1816
	.8byte	.LVL1820
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1821
	.8byte	.LVL1822
	.2byte	0x1
	.byte	0x5b
	.8byte	0
	.8byte	0
.LLST411:
	.8byte	.LVL1817
	.8byte	.LVL1818
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1818
	.8byte	.LVL1819-1
	.2byte	0x17
	.byte	0x7b
	.sleb128 0
	.byte	0x35
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe0
	.byte	0x1a
	.byte	0x3
	.8byte	req_gc_dst
	.byte	0x6
	.byte	0x22
	.byte	0x23
	.uleb128 0x10
	.8byte	0
	.8byte	0
.LLST287:
	.8byte	.LVL1175
	.8byte	.LVL1176
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1176
	.8byte	.LVL1216
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1216
	.8byte	.LFE310
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST288:
	.8byte	.LVL1175
	.8byte	.LVL1178-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1178-1
	.8byte	.LVL1179
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1179
	.8byte	.LVL1181
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1181
	.8byte	.LVL1218
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1218
	.8byte	.LFE310
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST289:
	.8byte	.LVL1192
	.8byte	.LVL1193
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1193
	.8byte	.LVL1196
	.2byte	0x2
	.byte	0x75
	.sleb128 0
	.8byte	.LVL1196
	.8byte	.LVL1197
	.2byte	0x2
	.byte	0x75
	.sleb128 -2
	.8byte	0
	.8byte	0
.LLST290:
	.8byte	.LVL1184
	.8byte	.LVL1185
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1185
	.8byte	.LVL1186-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1191
	.8byte	.LVL1194
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1195
	.8byte	.LVL1197
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST291:
	.8byte	.LVL1186
	.8byte	.LVL1187
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST292:
	.8byte	.LVL1184
	.8byte	.LVL1185
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST293:
	.8byte	.LVL1183
	.8byte	.LVL1187
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1190
	.8byte	.LVL1197
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1200
	.8byte	.LVL1201
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1201
	.8byte	.LVL1205-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1206
	.8byte	.LVL1207
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1209
	.8byte	.LVL1211-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1214
	.8byte	.LVL1215
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST294:
	.8byte	.LVL1177
	.8byte	.LVL1188
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1190
	.8byte	.LVL1210
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1212
	.8byte	.LVL1214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1214
	.8byte	.LVL1216
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST295:
	.8byte	.LVL1198
	.8byte	.LVL1204
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1206
	.8byte	.LVL1208-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1209
	.8byte	.LVL1211-1
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST296:
	.8byte	.LVL1175
	.8byte	.LVL1182
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1182
	.8byte	.LVL1189
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1189
	.8byte	.LVL1190
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1190
	.8byte	.LVL1217
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST297:
	.8byte	.LVL1202
	.8byte	.LVL1203
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1203
	.8byte	.LVL1204
	.2byte	0x2
	.byte	0x75
	.sleb128 16
	.8byte	.LVL1206
	.8byte	.LVL1207
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1207
	.8byte	.LVL1208-1
	.2byte	0x2
	.byte	0x75
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST405:
	.8byte	.LVL1763
	.8byte	.LVL1765
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1765
	.8byte	.LVL1766
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1766
	.8byte	.LVL1768
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1768
	.8byte	.LFE308
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST406:
	.8byte	.LVL1777
	.8byte	.LVL1779
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1779
	.8byte	.LVL1782
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1785
	.8byte	.LVL1795
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1796
	.8byte	.LFE308
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST407:
	.8byte	.LVL1769
	.8byte	.LVL1771
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1776
	.8byte	.LVL1777
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1790
	.8byte	.LVL1791
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1791
	.8byte	.LVL1793
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST408:
	.8byte	.LVL1764
	.8byte	.LVL1765
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1766
	.8byte	.LVL1767
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1767
	.8byte	.LVL1769
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.8byte	.LVL1769
	.8byte	.LVL1770-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1775
	.8byte	.LVL1776
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST409:
	.8byte	.LVL1786
	.8byte	.LVL1797
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST124:
	.8byte	.LVL524
	.8byte	.LVL525
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL525
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST125:
	.8byte	.LVL524
	.8byte	.LVL526-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL526-1
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x5a
	.8byte	0
	.8byte	0
.LLST126:
	.8byte	.LVL524
	.8byte	.LVL526-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL526-1
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x58
	.8byte	0
	.8byte	0
.LLST127:
	.8byte	.LVL527
	.8byte	.LVL530
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL530
	.8byte	.LVL531
	.2byte	0x7
	.byte	0x73
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0x75
	.sleb128 0
	.byte	0x22
	.8byte	.LVL531
	.8byte	.LVL532
	.2byte	0x1
	.byte	0x57
	.8byte	.LVL532
	.8byte	.LVL534
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL534
	.8byte	.LVL535
	.2byte	0x1
	.byte	0x57
	.8byte	0
	.8byte	0
.LLST128:
	.8byte	.LVL527
	.8byte	.LVL528
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL529
	.8byte	.LVL533
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST122:
	.8byte	.LVL520
	.8byte	.LVL522
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL522
	.8byte	.LFE306
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST123:
	.8byte	.LVL520
	.8byte	.LVL521
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL521
	.8byte	.LVL523
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST120:
	.8byte	.LVL514
	.8byte	.LVL515
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL516
	.8byte	.LVL517
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST121:
	.8byte	.LVL512
	.8byte	.LVL513
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL513
	.8byte	.LVL518
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL519
	.8byte	.LFE305
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST118:
	.8byte	.LVL506
	.8byte	.LVL507
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL508
	.8byte	.LVL511
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST119:
	.8byte	.LVL504
	.8byte	.LVL505
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL505
	.8byte	.LVL509
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL510
	.8byte	.LFE304
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST117:
	.8byte	.LVL497
	.8byte	.LVL498
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL499
	.8byte	.LVL500
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL501
	.8byte	.LVL502
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL503
	.8byte	.LFE303
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST324:
	.8byte	.LVL1341
	.8byte	.LVL1342
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1342
	.8byte	.LVL1346
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1346
	.8byte	.LFE302
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST325:
	.8byte	.LVL1341
	.8byte	.LVL1345
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1347
	.8byte	.LVL1350
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1350
	.8byte	.LFE302
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST114:
	.8byte	.LVL483
	.8byte	.LVL484
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL484
	.8byte	.LVL493
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL493
	.8byte	.LVL494
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL494
	.8byte	.LFE300
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST115:
	.8byte	.LVL488
	.8byte	.LVL490
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL494
	.8byte	.LVL495
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL496
	.8byte	.LFE300
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST116:
	.8byte	.LVL483
	.8byte	.LVL489
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL489
	.8byte	.LVL492
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL492
	.8byte	.LVL494
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL494
	.8byte	.LFE300
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST396:
	.8byte	.LVL1729
	.8byte	.LVL1731
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1731
	.8byte	.LVL1739
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1739
	.8byte	.LVL1741
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1741
	.8byte	.LFE299
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST397:
	.8byte	.LVL1730
	.8byte	.LVL1740
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1741
	.8byte	.LFE299
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST311:
	.8byte	.LVL1268
	.8byte	.LVL1269
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1269
	.8byte	.LVL1309
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1309
	.8byte	.LFE298
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST312:
	.8byte	.LVL1276
	.8byte	.LVL1281
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1282
	.8byte	.LVL1309
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST313:
	.8byte	.LVL1284
	.8byte	.LVL1296
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1297
	.8byte	.LVL1310
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST314:
	.8byte	.LVL1288
	.8byte	.LVL1289
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1290
	.8byte	.LVL1291
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1291
	.8byte	.LVL1295
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1301
	.8byte	.LVL1305
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1305
	.8byte	.LVL1306
	.2byte	0x3
	.byte	0x88
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1307
	.8byte	.LVL1311
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST315:
	.8byte	.LVL1290
	.8byte	.LVL1291
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1291
	.8byte	.LVL1292-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1301
	.8byte	.LVL1302
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1302
	.8byte	.LVL1303
	.2byte	0x3
	.byte	0x71
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1303
	.8byte	.LVL1304-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1304-1
	.8byte	.LVL1305
	.2byte	0x3
	.byte	0x8f
	.sleb128 196
	.8byte	.LVL1305
	.8byte	.LVL1307
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST316:
	.8byte	.LVL1268
	.8byte	.LVL1270
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1272
	.8byte	.LVL1273
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1273
	.8byte	.LVL1274
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1274
	.8byte	.LVL1275-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST317:
	.8byte	.LVL1298
	.8byte	.LVL1300
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST318:
	.8byte	.LVL1298
	.8byte	.LVL1300
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST104:
	.8byte	.LVL451
	.8byte	.LVL455
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL456
	.8byte	.LVL465
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL475
	.8byte	.LVL477
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST105:
	.8byte	.LVL451
	.8byte	.LVL455
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL456
	.8byte	.LVL465
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL465
	.8byte	.LVL466
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL466
	.8byte	.LVL471
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL471
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST106:
	.8byte	.LVL451
	.8byte	.LVL455
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL456
	.8byte	.LVL465
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL465
	.8byte	.LVL469
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL471
	.8byte	.LVL476
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL477
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST107:
	.8byte	.LVL465
	.8byte	.LVL466
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL471
	.8byte	.LVL474
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL478
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST108:
	.8byte	.LVL463
	.8byte	.LVL464
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL464
	.8byte	.LVL470-1
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL471
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST109:
	.8byte	.LVL467
	.8byte	.LVL470-1
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST110:
	.8byte	.LVL452
	.8byte	.LVL453
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL453
	.8byte	.LVL454
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL456
	.8byte	.LVL457
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL458
	.8byte	.LVL459
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL459
	.8byte	.LVL461
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST111:
	.8byte	.LVL451
	.8byte	.LVL455
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL456
	.8byte	.LVL465
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL465
	.8byte	.LVL468-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL471
	.8byte	.LVL472
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL473
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST93:
	.8byte	.LVL280
	.8byte	.LVL281
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL281
	.8byte	.LVL283
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL283
	.8byte	.LVL286
	.2byte	0x41
	.byte	0x3
	.8byte	g_num_free_superblocks
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x37
	.byte	0x1e
	.byte	0x33
	.byte	0x26
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x3
	.8byte	g_num_free_superblocks
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x37
	.byte	0x1e
	.byte	0x33
	.byte	0x26
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x2b
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	.LVL286
	.8byte	.LVL289
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL289
	.8byte	.LFE295
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST94:
	.8byte	.LVL280
	.8byte	.LVL285
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL285
	.8byte	.LVL286
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL286
	.8byte	.LVL290
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL290
	.8byte	.LFE295
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST95:
	.8byte	.LVL282
	.8byte	.LVL284
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL286
	.8byte	.LVL289
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST96:
	.8byte	.LVL282
	.8byte	.LVL287
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL288
	.8byte	.LVL289
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST92:
	.8byte	.LVL276
	.8byte	.LVL277
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL277
	.8byte	.LVL278
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL278
	.8byte	.LVL279
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL279
	.8byte	.LFE294
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST88:
	.8byte	.LVL262
	.8byte	.LVL263
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL263
	.8byte	.LVL266
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL266
	.8byte	.LFE293
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST89:
	.8byte	.LVL262
	.8byte	.LVL264
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL264
	.8byte	.LVL273
	.2byte	0x1
	.byte	0x57
	.8byte	.LVL273
	.8byte	.LVL274
	.2byte	0x3
	.byte	0x77
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL274
	.8byte	.LFE293
	.2byte	0x1
	.byte	0x57
	.8byte	0
	.8byte	0
.LLST90:
	.8byte	.LVL270
	.8byte	.LVL271-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST91:
	.8byte	.LVL262
	.8byte	.LVL264
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL264
	.8byte	.LVL268
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL269
	.8byte	.LVL272
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL273
	.8byte	.LFE293
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST250:
	.8byte	.LVL958
	.8byte	.LVL959
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL960
	.8byte	.LFE291
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST251:
	.8byte	.LVL963
	.8byte	.LVL965
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST282:
	.8byte	.LVL1148
	.8byte	.LVL1149
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1151
	.8byte	.LVL1152
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1160
	.8byte	.LVL1163
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1164
	.8byte	.LVL1165
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1165
	.8byte	.LVL1170
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1171
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST283:
	.8byte	.LVL1146
	.8byte	.LVL1147
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1155
	.8byte	.LVL1160
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST284:
	.8byte	.LVL1151
	.8byte	.LVL1152
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1157
	.8byte	.LVL1158
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1165
	.8byte	.LVL1168
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1169
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST285:
	.8byte	.LVL1144
	.8byte	.LVL1148
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1148
	.8byte	.LVL1153
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1153
	.8byte	.LVL1154
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL1155
	.8byte	.LVL1160
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1160
	.8byte	.LVL1166
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1167
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST286:
	.8byte	.LVL1150
	.8byte	.LVL1152
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1165
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST393:
	.8byte	.LVL1715
	.8byte	.LVL1716
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1722
	.8byte	.LVL1727
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1728
	.8byte	.LFE289
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST394:
	.8byte	.LVL1713
	.8byte	.LVL1714
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1717
	.8byte	.LVL1722
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST395:
	.8byte	.LVL1719
	.8byte	.LVL1720
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST355:
	.8byte	.LVL1512
	.8byte	.LVL1513
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1513
	.8byte	.LVL1519
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1519
	.8byte	.LVL1520
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1520
	.8byte	.LFE288
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST356:
	.8byte	.LVL1514
	.8byte	.LVL1519
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1520
	.8byte	.LFE288
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST357:
	.8byte	.LVL1512
	.8byte	.LVL1515
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL1515
	.8byte	.LVL1516
	.2byte	0x3
	.byte	0x86
	.sleb128 -2
	.byte	0x9f
	.8byte	.LVL1516
	.8byte	.LVL1517
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1517
	.8byte	.LVL1518
	.2byte	0x3
	.byte	0x86
	.sleb128 -2
	.byte	0x9f
	.8byte	.LVL1520
	.8byte	.LFE288
	.2byte	0x3
	.byte	0x86
	.sleb128 -2
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST276:
	.8byte	.LVL1120
	.8byte	.LVL1121
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1121
	.8byte	.LVL1132
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1133
	.8byte	.LVL1142
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST277:
	.8byte	.LVL1122
	.8byte	.LVL1126
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1126
	.8byte	.LVL1127
	.2byte	0x3
	.byte	0x76
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1127
	.8byte	.LVL1131-1
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1134
	.8byte	.LVL1139-1
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST278:
	.8byte	.LVL1123
	.8byte	.LVL1124-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST279:
	.8byte	.LVL1122
	.8byte	.LVL1125
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1126
	.8byte	.LVL1131-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1134
	.8byte	.LVL1135
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1136
	.8byte	.LVL1139-1
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST280:
	.8byte	.LVL1120
	.8byte	.LVL1121
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1121
	.8byte	.LVL1137
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1138
	.8byte	.LVL1140
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1140
	.8byte	.LVL1141-1
	.2byte	0x9
	.byte	0x3
	.8byte	g_num_data_superblocks
	.8byte	0
	.8byte	0
.LLST281:
	.8byte	.LVL1120
	.8byte	.LVL1121
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1121
	.8byte	.LVL1129
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1130
	.8byte	.LVL1143
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST85:
	.8byte	.LVL251
	.8byte	.LVL252
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL252
	.8byte	.LVL255
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL255
	.8byte	.LVL256
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL256
	.8byte	.LFE284
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST86:
	.8byte	.LVL254
	.8byte	.LVL260
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL260
	.8byte	.LVL261
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST87:
	.8byte	.LVL258
	.8byte	.LVL259-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL259-1
	.8byte	.LFE284
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST330:
	.8byte	.LVL1371
	.8byte	.LVL1372
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1372
	.8byte	.LVL1376
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1376
	.8byte	.LVL1377
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1377
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST331:
	.8byte	.LVL1373
	.8byte	.LVL1375
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1377
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST332:
	.8byte	.LVL1373
	.8byte	.LVL1374
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1374
	.8byte	.LVL1375
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1377
	.8byte	.LVL1380-1
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1380-1
	.8byte	.LVL1394
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1394
	.8byte	.LVL1399
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1399
	.8byte	.LFE281
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST333:
	.8byte	.LVL1377
	.8byte	.LVL1379
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1379
	.8byte	.LVL1382
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1394
	.8byte	.LVL1395
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1396
	.8byte	.LVL1403
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1438
	.8byte	.LVL1439
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1444
	.8byte	.LVL1445
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1445
	.8byte	.LVL1449
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1508
	.8byte	.LVL1509
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1510
	.8byte	.LVL1511
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST334:
	.8byte	.LVL1437
	.8byte	.LVL1438
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1462
	.8byte	.LVL1464
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1511
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST335:
	.8byte	.LVL1421
	.8byte	.LVL1422
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1423
	.8byte	.LVL1424
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1424
	.8byte	.LVL1425
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1425
	.8byte	.LVL1434
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1435
	.8byte	.LVL1436
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1437
	.8byte	.LVL1438
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1438
	.8byte	.LVL1442
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1443
	.8byte	.LVL1449
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1449
	.8byte	.LVL1454
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1454
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST336:
	.8byte	.LVL1391
	.8byte	.LVL1394
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1418
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST337:
	.8byte	.LVL1389
	.8byte	.LVL1394
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1413
	.8byte	.LVL1414
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1418
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST338:
	.8byte	.LVL1378
	.8byte	.LVL1380-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1394
	.8byte	.LVL1397
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1398
	.8byte	.LVL1399
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1404
	.8byte	.LVL1405
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1405
	.8byte	.LVL1408
	.2byte	0x2
	.byte	0x74
	.sleb128 0
	.8byte	.LVL1408
	.8byte	.LVL1409
	.2byte	0x2
	.byte	0x74
	.sleb128 -2
	.8byte	.LVL1426
	.8byte	.LVL1429
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1429
	.8byte	.LVL1430
	.2byte	0x2
	.byte	0x72
	.sleb128 0
	.8byte	.LVL1446
	.8byte	.LVL1447
	.2byte	0x6
	.byte	0x8f
	.sleb128 328
	.byte	0x6
	.byte	0x32
	.byte	0x1c
	.8byte	.LVL1447
	.8byte	.LVL1448
	.2byte	0x2
	.byte	0x74
	.sleb128 -4
	.8byte	.LVL1455
	.8byte	.LVL1458
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1458
	.8byte	.LVL1459
	.2byte	0x2
	.byte	0x72
	.sleb128 0
	.8byte	.LVL1459
	.8byte	.LVL1460
	.2byte	0x2
	.byte	0x72
	.sleb128 -2
	.8byte	.LVL1508
	.8byte	.LVL1511
	.2byte	0x2
	.byte	0x74
	.sleb128 -4
	.8byte	0
	.8byte	0
.LLST339:
	.8byte	.LVL1381
	.8byte	.LVL1383
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1383
	.8byte	.LVL1392
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1399
	.8byte	.LVL1400
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1400
	.8byte	.LVL1423
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1424
	.8byte	.LVL1425
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST341:
	.8byte	.LVL1384
	.8byte	.LVL1388
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1403
	.8byte	.LVL1406
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1407
	.8byte	.LVL1413
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1414
	.8byte	.LVL1418
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1425
	.8byte	.LVL1427
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1428
	.8byte	.LVL1431
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1438
	.8byte	.LVL1439
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1439
	.8byte	.LVL1441
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1454
	.8byte	.LVL1456
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1457
	.8byte	.LVL1460
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST342:
	.8byte	.LVL1386
	.8byte	.LVL1387
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1387
	.8byte	.LVL1389
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1409
	.8byte	.LVL1412
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1414
	.8byte	.LVL1416
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1417
	.8byte	.LVL1418
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST343:
	.8byte	.LVL1432
	.8byte	.LVL1433
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1440
	.8byte	.LVL1441
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST344:
	.8byte	.LVL1463
	.8byte	.LVL1467
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1469
	.8byte	.LVL1479
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1479
	.8byte	.LVL1482
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1482
	.8byte	.LVL1504
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1504
	.8byte	.LVL1506
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1506
	.8byte	.LVL1508
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST345:
	.8byte	.LVL1463
	.8byte	.LVL1467
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1469
	.8byte	.LVL1477
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1482
	.8byte	.LVL1497
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1497
	.8byte	.LVL1499
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1506
	.8byte	.LVL1508
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST346:
	.8byte	.LVL1386
	.8byte	.LVL1394
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1409
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST347:
	.8byte	.LVL1371
	.8byte	.LVL1375
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1377
	.8byte	.LVL1387
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1387
	.8byte	.LVL1392
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1394
	.8byte	.LVL1409
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1409
	.8byte	.LVL1420
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1420
	.8byte	.LVL1436
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1449
	.8byte	.LVL1454
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST348:
	.8byte	.LVL1410
	.8byte	.LVL1414
	.2byte	0x1
	.byte	0x58
	.8byte	.LVL1450
	.8byte	.LVL1451
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1451
	.8byte	.LVL1452
	.2byte	0x2
	.byte	0x70
	.sleb128 0
	.8byte	.LVL1452
	.8byte	.LVL1453
	.2byte	0x2
	.byte	0x70
	.sleb128 -32
	.8byte	.LVL1465
	.8byte	.LVL1466
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1469
	.8byte	.LVL1472-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1474
	.8byte	.LVL1475-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1475-1
	.8byte	.LVL1476
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1484
	.8byte	.LVL1485
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1488
	.8byte	.LVL1489-1
	.2byte	0x2
	.byte	0x74
	.sleb128 16
	.8byte	.LVL1489-1
	.8byte	.LVL1490
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	.LVL1500
	.8byte	.LVL1501-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1501-1
	.8byte	.LVL1504
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	0
	.8byte	0
.LLST349:
	.8byte	.LVL1419
	.8byte	.LVL1436
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1449
	.8byte	.LVL1454
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST350:
	.8byte	.LVL1419
	.8byte	.LVL1423
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1424
	.8byte	.LVL1425
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST351:
	.8byte	.LVL1475
	.8byte	.LVL1476
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	.LVL1484
	.8byte	.LVL1485
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST352:
	.8byte	.LVL1491
	.8byte	.LVL1494
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST353:
	.8byte	.LVL1498
	.8byte	.LVL1504
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST354:
	.8byte	.LVL1501
	.8byte	.LVL1502-1
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST244:
	.8byte	.LVL938
	.8byte	.LVL939
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL939
	.8byte	.LVL951
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL951
	.8byte	.LVL952
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL952
	.8byte	.LFE280
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST245:
	.8byte	.LVL938
	.8byte	.LVL940-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST246:
	.8byte	.LVL941
	.8byte	.LVL942
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL942
	.8byte	.LVL946-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL952
	.8byte	.LVL957
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL957
	.8byte	.LFE280
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST247:
	.8byte	.LVL944
	.8byte	.LVL945
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL952
	.8byte	.LVL955
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL956
	.8byte	.LVL957
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST248:
	.8byte	.LVL944
	.8byte	.LVL949
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL952
	.8byte	.LVL953
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL954
	.8byte	.LVL957
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST249:
	.8byte	.LVL943
	.8byte	.LVL946-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL952
	.8byte	.LVL957
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST80:
	.8byte	.LVL236
	.8byte	.LVL237
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL237
	.8byte	.LFE279
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST81:
	.8byte	.LVL236
	.8byte	.LVL239
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL239
	.8byte	.LFE279
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST82:
	.8byte	.LVL238
	.8byte	.LVL240
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL241
	.8byte	.LVL242
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL243
	.8byte	.LVL244
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST275:
	.8byte	.LVL1108
	.8byte	.LVL1109
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST264:
	.8byte	.LVL1059
	.8byte	.LVL1062
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1062
	.8byte	.LVL1080
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1080
	.8byte	.LVL1086
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST265:
	.8byte	.LVL1068
	.8byte	.LVL1069
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1069
	.8byte	.LVL1084
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST266:
	.8byte	.LVL1073
	.8byte	.LVL1074
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1074
	.8byte	.LVL1075
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1086
	.8byte	.LVL1088
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1089
	.8byte	.LVL1090
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1092
	.8byte	.LVL1093-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1094
	.8byte	.LVL1095
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1096
	.8byte	.LVL1097
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1099
	.8byte	.LVL1104
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1105
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST267:
	.8byte	.LVL1072
	.8byte	.LVL1075
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1086
	.8byte	.LVL1090
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST268:
	.8byte	.LVL1100
	.8byte	.LVL1101
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1101
	.8byte	.LVL1102
	.2byte	0x7
	.byte	0x72
	.sleb128 -1
	.byte	0x32
	.byte	0x24
	.byte	0x7a
	.sleb128 0
	.byte	0x22
	.8byte	.LVL1102
	.8byte	.LVL1103
	.2byte	0xf
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x8
	.byte	0x20
	.byte	0x26
	.byte	0x32
	.byte	0x24
	.byte	0x7a
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST269:
	.8byte	.LVL1060
	.8byte	.LVL1081
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST270:
	.8byte	.LVL1061
	.8byte	.LVL1070
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1090
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST271:
	.8byte	.LVL1063
	.8byte	.LVL1064
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1064
	.8byte	.LVL1066-1
	.2byte	0x2
	.byte	0x83
	.sleb128 24
	.8byte	.LVL1066-1
	.8byte	.LVL1085
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	.LVL1085
	.8byte	.LVL1086
	.2byte	0x3
	.byte	0x8f
	.sleb128 112
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	0
	.8byte	0
.LLST272:
	.8byte	.LVL1063
	.8byte	.LVL1082
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST273:
	.8byte	.LVL1065
	.8byte	.LVL1085
	.2byte	0x3
	.byte	0x8f
	.sleb128 268
	.8byte	.LVL1085
	.8byte	.LVL1086
	.2byte	0x3
	.byte	0x8f
	.sleb128 124
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x3
	.byte	0x8f
	.sleb128 268
	.8byte	0
	.8byte	0
.LLST274:
	.8byte	.LVL1067
	.8byte	.LVL1083
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1086
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST462:
	.8byte	.LVL2057
	.8byte	.LVL2060
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2069
	.8byte	.LVL2071
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2072
	.8byte	.LFE274
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST79:
	.8byte	.LVL234
	.8byte	.LVL235
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL235
	.8byte	.LFE273
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST257:
	.8byte	.LVL994
	.8byte	.LVL1001
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1001
	.8byte	.LVL1002
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1002
	.8byte	.LVL1003
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1005
	.8byte	.LVL1006-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1006
	.8byte	.LVL1008
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST258:
	.8byte	.LVL993
	.8byte	.LVL1042
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	.LVL1042
	.8byte	.LVL1043
	.2byte	0x3
	.byte	0x8f
	.sleb128 156
	.8byte	.LVL1043
	.8byte	.LFE270
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	0
	.8byte	0
.LLST259:
	.8byte	.LVL996
	.8byte	.LVL997-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL997-1
	.8byte	.LVL1000
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1009
	.8byte	.LVL1040
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST260:
	.8byte	.LVL994
	.8byte	.LVL998
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL999
	.8byte	.LVL1003
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1005
	.8byte	.LVL1007
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST261:
	.8byte	.LVL1019
	.8byte	.LVL1020
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1021
	.8byte	.LVL1022
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1023
	.8byte	.LVL1024
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1030
	.8byte	.LVL1031
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1032
	.8byte	.LVL1033
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1034
	.8byte	.LVL1035
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1044
	.8byte	.LVL1049
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1050
	.8byte	.LVL1051
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1052
	.8byte	.LVL1053
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1056
	.8byte	.LVL1057
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1058
	.8byte	.LFE270
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST262:
	.8byte	.LVL1010
	.8byte	.LVL1012
	.2byte	0x8
	.byte	0x40
	.byte	0x8f
	.sleb128 328
	.byte	0x94
	.byte	0x2
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1014
	.8byte	.LVL1015
	.2byte	0x8
	.byte	0x40
	.byte	0x8f
	.sleb128 328
	.byte	0x94
	.byte	0x2
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1015
	.8byte	.LVL1016
	.2byte	0x5
	.byte	0x41
	.byte	0x75
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1018
	.8byte	.LVL1025
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1026
	.8byte	.LVL1027
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1029
	.8byte	.LVL1036
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1037
	.8byte	.LVL1038
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1045
	.8byte	.LVL1046
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1047
	.8byte	.LVL1048
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1053
	.8byte	.LVL1054
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1055
	.8byte	.LVL1056
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST263:
	.8byte	.LVL1009
	.8byte	.LVL1040
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST384:
	.8byte	.LVL1665
	.8byte	.LVL1672
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1672
	.8byte	.LVL1684
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST385:
	.8byte	.LVL1666
	.8byte	.LVL1683
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST386:
	.8byte	.LVL1665
	.8byte	.LVL1672
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1672
	.8byte	.LVL1678
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1679
	.8byte	.LVL1682
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST253:
	.8byte	.LVL977
	.8byte	.LVL979
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL979
	.8byte	.LVL983
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL983
	.8byte	.LVL984-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL984-1
	.8byte	.LVL984
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL984
	.8byte	.LVL987
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL987
	.8byte	.LFE267
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST254:
	.8byte	.LVL980
	.8byte	.LVL981
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL981
	.8byte	.LVL982-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+4
	.8byte	.LVL984
	.8byte	.LVL985
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL985
	.8byte	.LVL986-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+4
	.8byte	0
	.8byte	0
.LLST255:
	.8byte	.LVL977
	.8byte	.LVL978
	.2byte	0x7
	.byte	0x70
	.sleb128 6
	.byte	0x94
	.byte	0x2
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL987
	.8byte	.LFE267
	.2byte	0x7
	.byte	0x70
	.sleb128 6
	.byte	0x94
	.byte	0x2
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST256:
	.8byte	.LVL977
	.8byte	.LVL978
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	.LVL987
	.8byte	.LFE267
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	0
	.8byte	0
.LLST374:
	.8byte	.LVL1624
	.8byte	.LVL1627
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1627
	.8byte	.LVL1631
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1631
	.8byte	.LVL1632
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1632
	.8byte	.LFE265
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST375:
	.8byte	.LVL1624
	.8byte	.LVL1625
	.2byte	0x3
	.byte	0x8
	.byte	0x20
	.byte	0x9f
	.8byte	.LVL1625
	.8byte	.LVL1626
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL1626
	.8byte	.LVL1628
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1631
	.8byte	.LVL1632
	.2byte	0x3
	.byte	0x8
	.byte	0x20
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST376:
	.8byte	.LVL1633
	.8byte	.LVL1636
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1636
	.8byte	.LVL1640
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1641
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST377:
	.8byte	.LVL1633
	.8byte	.LVL1634
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1634
	.8byte	.LVL1639
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1641
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST378:
	.8byte	.LVL1633
	.8byte	.LVL1637
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1637
	.8byte	.LVL1638
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1641
	.8byte	.LVL1659
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1659
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST379:
	.8byte	.LVL1644
	.8byte	.LVL1659
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST380:
	.8byte	.LVL1643
	.8byte	.LVL1646
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1646
	.8byte	.LVL1649-1
	.2byte	0x28
	.byte	0x85
	.sleb128 0
	.byte	0x85
	.sleb128 0
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1656
	.8byte	.LVL1659
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST381:
	.8byte	.LVL1642
	.8byte	.LVL1647
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1647
	.8byte	.LVL1648
	.2byte	0x3
	.byte	0x8f
	.sleb128 212
	.8byte	.LVL1648
	.8byte	.LVL1649-1
	.2byte	0x2
	.byte	0x70
	.sleb128 4
	.8byte	.LVL1656
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1657
	.8byte	.LVL1658-1
	.2byte	0x16
	.byte	0x8a
	.sleb128 0
	.byte	0x32
	.byte	0x24
	.byte	0x10
	.uleb128 0x3fffffffc
	.byte	0x1a
	.byte	0x3
	.8byte	p_vendor_region_ppn_table
	.byte	0x6
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST382:
	.8byte	.LVL1633
	.8byte	.LVL1637
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1637
	.8byte	.LVL1638
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1641
	.8byte	.LVL1659
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1659
	.8byte	.LFE264
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST383:
	.8byte	.LVL1635
	.8byte	.LVL1636
	.2byte	0x13
	.byte	0x70
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	.LVL1636
	.8byte	.LVL1637
	.2byte	0x13
	.byte	0x85
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	.LVL1637
	.8byte	.LVL1638
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1641
	.8byte	.LVL1659
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1659
	.8byte	.LFE264
	.2byte	0x13
	.byte	0x85
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST366:
	.8byte	.LVL1595
	.8byte	.LVL1598
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1598
	.8byte	.LVL1602
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1603
	.8byte	.LVL1614
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1617
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST367:
	.8byte	.LVL1595
	.8byte	.LVL1596
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1596
	.8byte	.LVL1601
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1603
	.8byte	.LVL1613
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1617
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST368:
	.8byte	.LVL1595
	.8byte	.LVL1599
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1599
	.8byte	.LVL1600
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1603
	.8byte	.LVL1622
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1622
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST369:
	.8byte	.LVL1606
	.8byte	.LVL1622
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST370:
	.8byte	.LVL1605
	.8byte	.LVL1611
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1619
	.8byte	.LVL1622
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST371:
	.8byte	.LVL1604
	.8byte	.LVL1608
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1608
	.8byte	.LVL1609
	.2byte	0x3
	.byte	0x8f
	.sleb128 212
	.8byte	.LVL1609
	.8byte	.LVL1610-1
	.2byte	0x2
	.byte	0x70
	.sleb128 4
	.8byte	.LVL1619
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1620
	.8byte	.LVL1621-1
	.2byte	0x16
	.byte	0x85
	.sleb128 0
	.byte	0x32
	.byte	0x24
	.byte	0x10
	.uleb128 0x3fffffffc
	.byte	0x1a
	.byte	0x3
	.8byte	p_vendor_region_ppn_table
	.byte	0x6
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST372:
	.8byte	.LVL1595
	.8byte	.LVL1599
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1599
	.8byte	.LVL1600
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1603
	.8byte	.LVL1622
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1622
	.8byte	.LFE263
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST373:
	.8byte	.LVL1597
	.8byte	.LVL1598
	.2byte	0x13
	.byte	0x70
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	.LVL1598
	.8byte	.LVL1599
	.2byte	0x13
	.byte	0x8c
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	.LVL1599
	.8byte	.LVL1600
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1603
	.8byte	.LVL1615
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1615
	.8byte	.LVL1616-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1616-1
	.8byte	.LVL1617
	.2byte	0x3
	.byte	0x85
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1617
	.8byte	.LVL1622
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1622
	.8byte	.LFE263
	.2byte	0x13
	.byte	0x8c
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page_shift
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST238:
	.8byte	.LVL918
	.8byte	.LVL922
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL922
	.8byte	.LFE262
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST239:
	.8byte	.LVL918
	.8byte	.LVL919
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL919
	.8byte	.LVL936
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL936
	.8byte	.LVL937
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL937
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST240:
	.8byte	.LVL918
	.8byte	.LVL923
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL923
	.8byte	.LVL936
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL936
	.8byte	.LVL937
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL937
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST241:
	.8byte	.LVL924
	.8byte	.LVL925
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL926
	.8byte	.LVL928
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL928
	.8byte	.LVL929-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL929-1
	.8byte	.LVL931
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL931
	.8byte	.LVL933
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL937
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST242:
	.8byte	.LVL920
	.8byte	.LVL935
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL937
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST243:
	.8byte	.LVL921
	.8byte	.LVL934
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL937
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST329:
	.8byte	.LVL1365
	.8byte	.LVL1366
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1367
	.8byte	.LVL1369
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1370
	.8byte	.LFE261
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST73:
	.8byte	.LVL203
	.8byte	.LVL204
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL205
	.8byte	.LVL206
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL206
	.8byte	.LVL208
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL210
	.8byte	.LVL211
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL213
	.8byte	.LVL214
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL215
	.8byte	.LVL218
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL219
	.8byte	.LVL223
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL224
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST74:
	.8byte	.LVL207
	.8byte	.LVL209
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL210
	.8byte	.LVL213
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL215
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST75:
	.8byte	.LVL207
	.8byte	.LVL210
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL210
	.8byte	.LVL212-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL215
	.8byte	.LVL216
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL217
	.8byte	.LVL220
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL220
	.8byte	.LVL221
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL222
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST236:
	.8byte	.LVL913
	.8byte	.LVL914
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL914
	.8byte	.LFE259
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST237:
	.8byte	.LVL915
	.8byte	.LVL916
	.2byte	0x9
	.byte	0x71
	.sleb128 0
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL916
	.8byte	.LVL917-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST223:
	.8byte	.LVL873
	.8byte	.LVL874
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL874
	.8byte	.LVL888
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL888
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST224:
	.8byte	.LVL873
	.8byte	.LVL874
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL874
	.8byte	.LVL889
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL889
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST225:
	.8byte	.LVL873
	.8byte	.LVL874
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL874
	.8byte	.LVL887
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL887
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST226:
	.8byte	.LVL878
	.8byte	.LVL879-1
	.2byte	0x7
	.byte	0x73
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL879-1
	.8byte	.LVL890
	.2byte	0xa
	.byte	0x8f
	.sleb128 204
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL890
	.8byte	.LFE258
	.2byte	0xa
	.byte	0x8f
	.sleb128 92
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST227:
	.8byte	.LVL880
	.8byte	.LVL881
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL881
	.8byte	.LVL882-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+16
	.8byte	0
	.8byte	0
.LLST228:
	.8byte	.LVL873
	.8byte	.LVL874
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL874
	.8byte	.LVL883
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL884
	.8byte	.LVL886
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST217:
	.8byte	.LVL851
	.8byte	.LVL853
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL853
	.8byte	.LVL857
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL857
	.8byte	.LVL858
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL858
	.8byte	.LFE257
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST218:
	.8byte	.LVL862
	.8byte	.LVL863
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL863
	.8byte	.LVL865
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL868
	.8byte	.LVL871
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL871
	.8byte	.LVL872
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST219:
	.8byte	.LVL862
	.8byte	.LVL863
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL863
	.8byte	.LVL864
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL868
	.8byte	.LVL869
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL870
	.8byte	.LFE257
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST220:
	.8byte	.LVL852
	.8byte	.LVL856
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL858
	.8byte	.LVL859
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL859
	.8byte	.LVL862-1
	.2byte	0x2
	.byte	0x83
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST221:
	.8byte	.LVL852
	.8byte	.LVL853
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	.LVL853
	.8byte	.LVL854-1
	.2byte	0x2
	.byte	0x83
	.sleb128 40
	.8byte	.LVL858
	.8byte	.LVL862-1
	.2byte	0x2
	.byte	0x83
	.sleb128 40
	.8byte	0
	.8byte	0
.LLST222:
	.8byte	.LVL860
	.8byte	.LVL861
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL861
	.8byte	.LVL862-1
	.2byte	0x9
	.byte	0x3
	.8byte	p_sys_spare_buf
	.8byte	0
	.8byte	0
.LLST229:
	.8byte	.LVL891
	.8byte	.LVL894-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL894-1
	.8byte	.LVL902
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL902
	.8byte	.LVL904
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL904
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST230:
	.8byte	.LVL896
	.8byte	.LVL900
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL904
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST231:
	.8byte	.LVL894
	.8byte	.LVL895
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST232:
	.8byte	.LVL898
	.8byte	.LVL900
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL904
	.8byte	.LVL909
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL910
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST233:
	.8byte	.LVL892
	.8byte	.LVL898
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST234:
	.8byte	.LVL893
	.8byte	.LVL903
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL904
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST235:
	.8byte	.LVL905
	.8byte	.LVL908
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL911
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST208:
	.8byte	.LVL828
	.8byte	.LVL830
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL830
	.8byte	.LVL835
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL835
	.8byte	.LVL839
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL839
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST209:
	.8byte	.LVL829
	.8byte	.LVL837
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL839
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST210:
	.8byte	.LVL829
	.8byte	.LVL834
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL839
	.8byte	.LVL845
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST211:
	.8byte	.LVL829
	.8byte	.LVL836
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL839
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST212:
	.8byte	.LVL840
	.8byte	.LVL845
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST213:
	.8byte	.LVL831
	.8byte	.LVL832
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL832
	.8byte	.LVL834
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL839
	.8byte	.LVL841
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL842
	.8byte	.LVL845
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST214:
	.8byte	.LVL833
	.8byte	.LVL834
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL834
	.8byte	.LVL835
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL840
	.8byte	.LVL843
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL844
	.8byte	.LVL845
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL845
	.8byte	.LVL849
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL850
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST215:
	.8byte	.LVL833
	.8byte	.LVL838
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL845
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST216:
	.8byte	.LVL833
	.8byte	.LVL834
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL834
	.8byte	.LVL838
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL845
	.8byte	.LVL846
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL847
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST205:
	.8byte	.LVL812
	.8byte	.LVL813
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL813
	.8byte	.LVL819
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL819
	.8byte	.LFE253
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST206:
	.8byte	.LVL812
	.8byte	.LVL814
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL814
	.8byte	.LVL817
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL817
	.8byte	.LFE253
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST207:
	.8byte	.LVL816
	.8byte	.LVL820
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL821
	.8byte	.LFE253
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST61:
	.8byte	.LVL169
	.8byte	.LVL170
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL170
	.8byte	.LVL173
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL175
	.8byte	.LFE251
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST62:
	.8byte	.LVL169
	.8byte	.LVL177
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL177
	.8byte	.LVL178
	.2byte	0x8
	.byte	0x71
	.sleb128 0
	.byte	0x73
	.sleb128 0
	.byte	0x1c
	.byte	0x36
	.byte	0x1b
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST63:
	.8byte	.LVL171
	.8byte	.LVL172
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL174
	.8byte	.LVL176
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL177
	.8byte	.LVL178
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST60:
	.8byte	.LVL167
	.8byte	.LVL168-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL168-1
	.8byte	.LFE250
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST56:
	.8byte	.LVL154
	.8byte	.LVL159-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL159-1
	.8byte	.LVL161
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL161
	.8byte	.LVL166
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL166
	.8byte	.LFE249
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST57:
	.8byte	.LVL154
	.8byte	.LVL155
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL155
	.8byte	.LVL158
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL161
	.8byte	.LVL162
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL164
	.8byte	.LFE249
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST58:
	.8byte	.LVL154
	.8byte	.LVL157
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL157
	.8byte	.LVL160
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL160
	.8byte	.LVL161
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL161
	.8byte	.LFE249
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST59:
	.8byte	.LVL155
	.8byte	.LVL156
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL161
	.8byte	.LVL165
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST52:
	.8byte	.LVL140
	.8byte	.LVL141
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL141
	.8byte	.LVL146
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL146
	.8byte	.LVL148
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL148
	.8byte	.LFE248
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST53:
	.8byte	.LVL140
	.8byte	.LVL143
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL143
	.8byte	.LFE248
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST54:
	.8byte	.LVL142
	.8byte	.LVL145
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL145
	.8byte	.LVL146
	.2byte	0x6
	.byte	0x87
	.sleb128 0
	.byte	0x85
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL146
	.8byte	.LVL147
	.2byte	0xd
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x87
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL148
	.8byte	.LFE248
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST55:
	.8byte	.LVL149
	.8byte	.LVL150
	.2byte	0x14
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL150
	.8byte	.LVL151
	.2byte	0x16
	.byte	0x83
	.sleb128 2
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL152
	.8byte	.LVL153
	.2byte	0xc
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL153
	.8byte	.LFE248
	.2byte	0xe
	.byte	0x83
	.sleb128 2
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST45:
	.8byte	.LVL120
	.8byte	.LVL123
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL123
	.8byte	.LFE247
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST46:
	.8byte	.LVL121
	.8byte	.LVL122
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL124
	.8byte	.LVL134
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL134
	.8byte	.LFE247
	.2byte	0x6
	.byte	0x73
	.sleb128 0
	.byte	0x78
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST47:
	.8byte	.LVL125
	.8byte	.LVL126
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL126
	.8byte	.LFE247
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST48:
	.8byte	.LVL126
	.8byte	.LVL127
	.2byte	0xb
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x31
	.byte	0x24
	.byte	0x7b
	.sleb128 0
	.byte	0x22
	.8byte	.LVL128
	.8byte	.LVL130
	.2byte	0xb
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x31
	.byte	0x24
	.byte	0x7b
	.sleb128 0
	.byte	0x22
	.8byte	.LVL131
	.8byte	.LVL132
	.2byte	0xb
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x31
	.byte	0x24
	.byte	0x7b
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST49:
	.8byte	.LVL126
	.8byte	.LVL128
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL128
	.8byte	.LVL131
	.2byte	0x1
	.byte	0x5a
	.8byte	.LVL131
	.8byte	.LVL133
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL133
	.8byte	.LVL135
	.2byte	0x5
	.byte	0x73
	.sleb128 0
	.byte	0x78
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST34:
	.8byte	.LVL88
	.8byte	.LVL91
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL91
	.8byte	.LFE246
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST35:
	.8byte	.LVL89
	.8byte	.LVL90
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL92
	.8byte	.LFE246
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST36:
	.8byte	.LVL96
	.8byte	.LVL98
	.2byte	0x1
	.byte	0x5c
	.8byte	.LVL98
	.8byte	.LFE246
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST37:
	.8byte	.LVL93
	.8byte	.LVL94
	.2byte	0x1
	.byte	0x57
	.8byte	.LVL94
	.8byte	.LVL98
	.2byte	0x5
	.byte	0x80
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.8byte	.LVL98
	.8byte	.LVL105
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x80
	.sleb128 0
	.byte	0x22
	.8byte	.LVL107
	.8byte	.LVL109
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x80
	.sleb128 0
	.byte	0x22
	.8byte	.LVL111
	.8byte	.LVL113
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x80
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST38:
	.8byte	.LVL101
	.8byte	.LVL102
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL102
	.8byte	.LVL105
	.2byte	0x5
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL107
	.8byte	.LVL109
	.2byte	0x5
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL111
	.8byte	.LVL113
	.2byte	0x5
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST39:
	.8byte	.LVL93
	.8byte	.LVL94
	.2byte	0xe
	.byte	0x77
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL94
	.8byte	.LVL95
	.2byte	0x13
	.byte	0x80
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL95
	.8byte	.LVL96
	.2byte	0x15
	.byte	0x80
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x75
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL96
	.8byte	.LFE246
	.2byte	0x1
	.byte	0x57
	.8byte	0
	.8byte	0
.LLST40:
	.8byte	.LVL101
	.8byte	.LVL102
	.2byte	0xe
	.byte	0x73
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x83
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL102
	.8byte	.LVL103
	.2byte	0x13
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x83
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL103
	.8byte	.LVL104
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL104
	.8byte	.LVL105
	.2byte	0x29
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x7b
	.sleb128 0
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x2e
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	.LVL107
	.8byte	.LVL108
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL108
	.8byte	.LVL109
	.2byte	0x29
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x7b
	.sleb128 0
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x2e
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	.LVL111
	.8byte	.LVL112
	.2byte	0x29
	.byte	0x80
	.sleb128 0
	.byte	0x8e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x7b
	.sleb128 0
	.byte	0x74
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x2e
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST41:
	.8byte	.LVL97
	.8byte	.LVL106
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL106
	.8byte	.LVL107
	.2byte	0x5
	.byte	0x76
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.8byte	.LVL107
	.8byte	.LVL110
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL111
	.8byte	.LVL113
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL113
	.8byte	.LVL115
	.2byte	0x5
	.byte	0x76
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST42:
	.8byte	.LVL88
	.8byte	.LVL98
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL98
	.8byte	.LVL99
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL100
	.8byte	.LVL110
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL111
	.8byte	.LVL114
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST191:
	.8byte	.LVL716
	.8byte	.LVL717
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL718
	.8byte	.LVL723
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL723
	.8byte	.LVL725
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL727
	.8byte	.LFE243
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST192:
	.8byte	.LVL720
	.8byte	.LVL721
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL721
	.8byte	.LVL724
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL727
	.8byte	.LFE243
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST31:
	.8byte	.LVL81
	.8byte	.LVL84
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL84
	.8byte	.LFE242
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST32:
	.8byte	.LVL81
	.8byte	.LVL87
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL87
	.8byte	.LFE242
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST33:
	.8byte	.LVL82
	.8byte	.LVL83
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL85
	.8byte	.LFE242
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST30:
	.8byte	.LVL76
	.8byte	.LVL77
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL78
	.8byte	.LVL79
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL80
	.8byte	.LFE241
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST204:
	.8byte	.LVL809
	.8byte	.LVL810
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL810
	.8byte	.LVL811-1
	.2byte	0x9
	.byte	0x3
	.8byte	gSysFreeQueue
	.8byte	.LVL811-1
	.8byte	.LFE237
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST154:
	.8byte	.LVL597
	.8byte	.LVL601
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL601
	.8byte	.LVL608
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL608
	.8byte	.LVL610
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL610
	.8byte	.LFE236
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST155:
	.8byte	.LVL597
	.8byte	.LVL598
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL598
	.8byte	.LVL607
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL607
	.8byte	.LVL608
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL608
	.8byte	.LVL609
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL609
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST156:
	.8byte	.LVL602
	.8byte	.LVL604
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL604
	.8byte	.LVL605
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL610
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST157:
	.8byte	.LVL602
	.8byte	.LVL606
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL610
	.8byte	.LVL613
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL614
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST158:
	.8byte	.LVL611
	.8byte	.LVL615
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL615
	.8byte	.LFE236
	.2byte	0x3
	.byte	0x84
	.sleb128 -1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST159:
	.8byte	.LVL599
	.8byte	.LVL600
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST27:
	.8byte	.LVL69
	.8byte	.LVL71
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL71
	.8byte	.LVL72
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL72
	.8byte	.LVL74
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL74
	.8byte	.LFE235
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST28:
	.8byte	.LVL69
	.8byte	.LVL70
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL70
	.8byte	.LVL72
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL72
	.8byte	.LVL73
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL73
	.8byte	.LFE235
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST29:
	.8byte	.LVL69
	.8byte	.LVL72
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL72
	.8byte	.LVL74
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL74
	.8byte	.LFE235
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST25:
	.8byte	.LVL65
	.8byte	.LVL66
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL66
	.8byte	.LFE234
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST26:
	.8byte	.LVL67
	.8byte	.LVL68
	.2byte	0x15
	.byte	0x70
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x9f
	.8byte	.LVL68
	.8byte	.LFE234
	.2byte	0x3a
	.byte	0x72
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST24:
	.8byte	.LVL62
	.8byte	.LVL63
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL63
	.8byte	.LFE233
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST22:
	.8byte	.LVL58
	.8byte	.LVL60
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL60
	.8byte	.LFE232
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST23:
	.8byte	.LVL59
	.8byte	.LVL60
	.2byte	0x24
	.byte	0x70
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x72
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x72
	.sleb128 0
	.byte	0x71
	.sleb128 0
	.byte	0x1e
	.byte	0x70
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x1d
	.byte	0x22
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL60
	.8byte	.LVL61
	.2byte	0x26
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x72
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x72
	.sleb128 0
	.byte	0x71
	.sleb128 0
	.byte	0x1e
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x72
	.sleb128 0
	.byte	0x1d
	.byte	0x22
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL61
	.8byte	.LFE232
	.2byte	0x41
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x71
	.sleb128 0
	.byte	0x1e
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x3
	.8byte	c_ftl_nand_planes_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1d
	.byte	0x22
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST362:
	.8byte	.LVL1550
	.8byte	.LVL1551
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1551
	.8byte	.LVL1553
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1561
	.8byte	.LVL1566
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1566
	.8byte	.LVL1567
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1567
	.8byte	.LVL1587
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST363:
	.8byte	.LVL1552
	.8byte	.LVL1554
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1555
	.8byte	.LVL1559
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1560
	.8byte	.LVL1561
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1571
	.8byte	.LVL1581
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1582
	.8byte	.LVL1584
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1584
	.8byte	.LVL1585-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1586
	.8byte	.LVL1588
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1593
	.8byte	.LVL1594-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST364:
	.8byte	.LVL1563
	.8byte	.LVL1568
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1575
	.8byte	.LVL1580
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST365:
	.8byte	.LVL1562
	.8byte	.LVL1583
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST151:
	.8byte	.LVL587
	.8byte	.LVL588
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL590
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST152:
	.8byte	.LVL591
	.8byte	.LVL595
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL596
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST153:
	.8byte	.LVL587
	.8byte	.LVL589
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL590
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST358:
	.8byte	.LVL1536
	.8byte	.LVL1537
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1545
	.8byte	.LVL1546
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1546
	.8byte	.LVL1547
	.2byte	0x3
	.byte	0x84
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1547
	.8byte	.LVL1548
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST359:
	.8byte	.LVL1526
	.8byte	.LVL1529
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1538
	.8byte	.LVL1539
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1540
	.8byte	.LVL1541
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST360:
	.8byte	.LVL1532
	.8byte	.LVL1536
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1541
	.8byte	.LVL1543
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1544
	.8byte	.LVL1545
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST361:
	.8byte	.LVL1524
	.8byte	.LVL1535
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1538
	.8byte	.LVL1545
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1548
	.8byte	.LFE229
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST20:
	.8byte	.LVL51
	.8byte	.LVL52
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL52
	.8byte	.LVL56
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL57
	.8byte	.LFE228
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST21:
	.8byte	.LVL51
	.8byte	.LVL52
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL52
	.8byte	.LVL54
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL55
	.8byte	.LFE228
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST307:
	.8byte	.LVL1247
	.8byte	.LVL1248
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1259
	.8byte	.LVL1260
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1260
	.8byte	.LVL1261
	.2byte	0x3
	.byte	0x88
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1261
	.8byte	.LVL1262
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST308:
	.8byte	.LVL1246
	.8byte	.LVL1251
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1251
	.8byte	.LVL1259
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1259
	.8byte	.LVL1262
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1262
	.8byte	.LVL1263
	.2byte	0x3
	.byte	0x89
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1264
	.8byte	.LVL1267
	.2byte	0x3
	.byte	0x89
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST309:
	.8byte	.LVL1249
	.8byte	.LVL1259
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1262
	.8byte	.LVL1265
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST310:
	.8byte	.LVL1246
	.8byte	.LVL1251
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1251
	.8byte	.LVL1256
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1257
	.8byte	.LVL1259
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1259
	.8byte	.LVL1262
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1262
	.8byte	.LVL1266
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST202:
	.8byte	.LVL801
	.8byte	.LVL802
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL802
	.8byte	.LVL807
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL807
	.8byte	.LFE225
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST203:
	.8byte	.LVL801
	.8byte	.LVL803
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL803
	.8byte	.LVL806
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL806
	.8byte	.LFE225
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST16:
	.8byte	.LVL45
	.8byte	.LVL47
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL47
	.8byte	.LFE223
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST17:
	.8byte	.LVL46
	.8byte	.LVL47
	.2byte	0x10
	.byte	0x70
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x71
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL47
	.8byte	.LVL48
	.2byte	0x11
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x71
	.sleb128 0
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL48
	.8byte	.LFE223
	.2byte	0x1a
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST18:
	.8byte	.LVL49
	.8byte	.LVL50
	.2byte	0x41
	.byte	0x70
	.sleb128 0
	.byte	0x35
	.byte	0x25
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x23
	.uleb128 0x4
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.8byte	gBbtInfo
	.byte	0x22
	.byte	0x6
	.byte	0x22
	.byte	0x94
	.byte	0x4
	.byte	0x70
	.sleb128 0
	.byte	0x4f
	.byte	0x1a
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x31
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL50
	.8byte	.LFE223
	.2byte	0x97
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0x35
	.byte	0x25
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x29
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xf7
	.uleb128 0x29
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x23
	.uleb128 0x4
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.8byte	gBbtInfo
	.byte	0x22
	.byte	0x6
	.byte	0x22
	.byte	0x94
	.byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0x4f
	.byte	0x1a
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x25
	.byte	0x31
	.byte	0x1a
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST19:
	.8byte	.LVL49
	.8byte	.LVL50
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL50
	.8byte	.LFE223
	.2byte	0x2e
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST12:
	.8byte	.LVL40
	.8byte	.LVL41
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL41
	.8byte	.LVL44-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL44-1
	.8byte	.LFE222
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST13:
	.8byte	.LVL42
	.8byte	.LVL44-1
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST14:
	.8byte	.LVL43
	.8byte	.LVL44-1
	.2byte	0x16
	.byte	0x72
	.sleb128 0
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x23
	.uleb128 0x4
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.8byte	gBbtInfo
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST15:
	.8byte	.LVL43
	.8byte	.LVL44-1
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST459:
	.8byte	.LVL2050
	.8byte	.LVL2053
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2053
	.8byte	.LVL2054-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2054-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST460:
	.8byte	.LVL2050
	.8byte	.LVL2052
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2052
	.8byte	.LVL2054-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2054-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST461:
	.8byte	.LVL2050
	.8byte	.LVL2051
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2051
	.8byte	.LVL2054-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL2054-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST441:
	.8byte	.LVL1976
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1979
	.8byte	.LVL1980-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1980-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST442:
	.8byte	.LVL1976
	.8byte	.LVL1978
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1978
	.8byte	.LVL1980-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1980-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST443:
	.8byte	.LVL1976
	.8byte	.LVL1977
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1977
	.8byte	.LVL1980-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1980-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST387:
	.8byte	.LVL1689
	.8byte	.LVL1691
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1691
	.8byte	.LVL1693
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1693
	.8byte	.LVL1695
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1695
	.8byte	.LVL1710
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1710
	.8byte	.LVL1711
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1711
	.8byte	.LFE218
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST388:
	.8byte	.LVL1689
	.8byte	.LVL1690
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1690
	.8byte	.LVL1692
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1693
	.8byte	.LFE218
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST389:
	.8byte	.LVL1695
	.8byte	.LVL1700
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1700
	.8byte	.LVL1701
	.2byte	0x2a
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0xf7
	.uleb128 0x30
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0xf7
	.uleb128 0x30
	.byte	0x1b
	.byte	0xf7
	.uleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0x1e
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST390:
	.8byte	.LVL1696
	.8byte	.LVL1697
	.2byte	0x25
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1c
	.byte	0x12
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x83
	.sleb128 0
	.byte	0x16
	.byte	0x14
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x2d
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	.LVL1697
	.8byte	.LVL1699
	.2byte	0x2e
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1c
	.byte	0x12
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x83
	.sleb128 0
	.byte	0x16
	.byte	0x14
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x2d
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST391:
	.8byte	.LVL1694
	.8byte	.LVL1710
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST392:
	.8byte	.LVL1706
	.8byte	.LVL1707-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST444:
	.8byte	.LVL1981
	.8byte	.LVL1982
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1982
	.8byte	.LFE217
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST445:
	.8byte	.LVL1981
	.8byte	.LVL1983
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1983
	.8byte	.LVL1985
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1985
	.8byte	.LVL1988
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1988
	.8byte	.LVL1989
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1989
	.8byte	.LVL1997
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1997
	.8byte	.LVL1998
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1998
	.8byte	.LVL2042
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL2042
	.8byte	.LVL2049
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL2049
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST446:
	.8byte	.LVL1981
	.8byte	.LVL1984
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1984
	.8byte	.LVL1987
	.2byte	0x3
	.byte	0x8f
	.sleb128 352
	.8byte	.LVL1987
	.8byte	.LVL1988
	.2byte	0x3
	.byte	0x8f
	.sleb128 112
	.8byte	.LVL1988
	.8byte	.LVL1995
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1995
	.8byte	.LVL2049
	.2byte	0x3
	.byte	0x8f
	.sleb128 352
	.8byte	.LVL2049
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST447:
	.8byte	.LVL1981
	.8byte	.LVL1985-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1985-1
	.8byte	.LVL1986
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1986
	.8byte	.LVL1988
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL1988
	.8byte	.LVL1995
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1995
	.8byte	.LVL2049
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL2049
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST448:
	.8byte	.LVL2020
	.8byte	.LVL2041
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST449:
	.8byte	.LVL1994
	.8byte	.LVL1995
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1995
	.8byte	.LVL1997
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1998
	.8byte	.LVL2043
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST450:
	.8byte	.LVL1990
	.8byte	.LVL2049
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST451:
	.8byte	.LVL1991
	.8byte	.LVL1992
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1992
	.8byte	.LVL2049
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	0
	.8byte	0
.LLST452:
	.8byte	.LVL2018
	.8byte	.LVL2019
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2019
	.8byte	.LVL2021
	.2byte	0x2
	.byte	0x71
	.sleb128 4
	.8byte	.LVL2021
	.8byte	.LVL2022-1
	.2byte	0xf
	.byte	0x3
	.8byte	req_prgm
	.byte	0x6
	.byte	0x8b
	.sleb128 0
	.byte	0x22
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST453:
	.8byte	.LVL2008
	.8byte	.LVL2013
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	.LVL2016
	.8byte	.LVL2028
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	.LVL2028
	.8byte	.LVL2029
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2029
	.8byte	.LVL2041
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	0
	.8byte	0
.LLST454:
	.8byte	.LVL1993
	.8byte	.LVL2049
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST455:
	.8byte	.LVL2004
	.8byte	.LVL2005
	.2byte	0x21
	.byte	0x83
	.sleb128 7
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x12
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x88
	.sleb128 0
	.byte	0x16
	.byte	0x14
	.byte	0xc
	.4byte	0xffffffff
	.byte	0x1a
	.byte	0x2d
	.byte	0x28
	.2byte	0x1
	.byte	0x16
	.byte	0x13
	.byte	0x9f
	.8byte	.LVL2005
	.8byte	.LVL2006
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2006
	.8byte	.LVL2009
	.2byte	0x3
	.byte	0x8f
	.sleb128 324
	.8byte	.LVL2009
	.8byte	.LVL2013
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL2016
	.8byte	.LVL2041
	.2byte	0x3
	.byte	0x8f
	.sleb128 324
	.8byte	0
	.8byte	0
.LLST456:
	.8byte	.LVL1994
	.8byte	.LVL1995
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2023
	.8byte	.LVL2024
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2024
	.8byte	.LVL2026
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	.LVL2029
	.8byte	.LVL2031
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2031
	.8byte	.LVL2032
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	.LVL2033
	.8byte	.LVL2040
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	0
	.8byte	0
.LLST457:
	.8byte	.LVL1994
	.8byte	.LVL1995
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2025
	.8byte	.LVL2026
	.2byte	0x3
	.byte	0x8f
	.sleb128 356
	.8byte	.LVL2030
	.8byte	.LVL2031
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2031
	.8byte	.LVL2032
	.2byte	0x3
	.byte	0x8f
	.sleb128 356
	.8byte	.LVL2033
	.8byte	.LVL2040
	.2byte	0x3
	.byte	0x8f
	.sleb128 356
	.8byte	0
	.8byte	0
.LLST458:
	.8byte	.LVL1994
	.8byte	.LVL1995
	.2byte	0xa
	.byte	0x3
	.8byte	g_active_superblock
	.byte	0x9f
	.8byte	.LVL1995
	.8byte	.LVL1997
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1998
	.8byte	.LVL2001
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2003
	.8byte	.LVL2015
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2016
	.8byte	.LVL2044
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST398:
	.8byte	.LVL1743
	.8byte	.LVL1746-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1746-1
	.8byte	.LVL1746
	.2byte	0x3
	.byte	0x84
	.sleb128 -4
	.byte	0x9f
	.8byte	.LVL1746
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST399:
	.8byte	.LVL1743
	.8byte	.LVL1746-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1746-1
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST400:
	.8byte	.LVL1743
	.8byte	.LVL1744
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1744
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST401:
	.8byte	.LVL1743
	.8byte	.LVL1745
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1745
	.8byte	.LVL1762
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1762
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST402:
	.8byte	.LVL1755
	.8byte	.LVL1758-1
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST403:
	.8byte	.LVL1747
	.8byte	.LVL1748
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1757
	.8byte	.LVL1758-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1758-1
	.8byte	.LVL1760
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST404:
	.8byte	.LVL1754
	.8byte	.LVL1756-1
	.2byte	0x2
	.byte	0x86
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST424:
	.8byte	.LVL1927
	.8byte	.LVL1930
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1930
	.8byte	.LFE214
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST425:
	.8byte	.LVL1927
	.8byte	.LVL1929
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1929
	.8byte	.LVL1933
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1933
	.8byte	.LVL1936
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1936
	.8byte	.LVL1937
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1937
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST426:
	.8byte	.LVL1927
	.8byte	.LVL1928
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1928
	.8byte	.LVL1935
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1935
	.8byte	.LVL1936
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL1936
	.8byte	.LVL1942
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1942
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST427:
	.8byte	.LVL1927
	.8byte	.LVL1931-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1931-1
	.8byte	.LVL1934
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1934
	.8byte	.LVL1936
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL1936
	.8byte	.LVL1943
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1943
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST428:
	.8byte	.LVL1927
	.8byte	.LVL1932
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1936
	.8byte	.LVL1943
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1943
	.8byte	.LVL1954
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1956
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST429:
	.8byte	.LVL1938
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST430:
	.8byte	.LVL1939
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST431:
	.8byte	.LVL1958
	.8byte	.LVL1959
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1959
	.8byte	.LVL1960-1
	.2byte	0x16
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x84
	.sleb128 0
	.byte	0x1e
	.byte	0x74
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST432:
	.8byte	.LVL1940
	.8byte	.LVL1943
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1943
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST433:
	.8byte	.LVL1950
	.8byte	.LVL1952
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST434:
	.8byte	.LVL1940
	.8byte	.LVL1943
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1943
	.8byte	.LVL1951
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1957
	.8byte	.LVL1972
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST435:
	.8byte	.LVL1940
	.8byte	.LVL1941
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1941
	.8byte	.LVL1948
	.2byte	0x3
	.byte	0x8f
	.sleb128 300
	.8byte	.LVL1948
	.8byte	.LVL1949
	.2byte	0x8
	.byte	0x8f
	.sleb128 300
	.byte	0x94
	.byte	0x4
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1957
	.8byte	.LVL1972
	.2byte	0x3
	.byte	0x8f
	.sleb128 300
	.8byte	0
	.8byte	0
.LLST436:
	.8byte	.LVL1927
	.8byte	.LVL1932
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1936
	.8byte	.LVL1943
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1943
	.8byte	.LVL1964
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1964
	.8byte	.LVL1965
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1965
	.8byte	.LVL1975
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST437:
	.8byte	.LVL1936
	.8byte	.LVL1943
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1943
	.8byte	.LVL1965
	.2byte	0x3
	.byte	0x8f
	.sleb128 292
	.8byte	.LVL1965
	.8byte	.LVL1966
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1966
	.8byte	.LVL1967
	.2byte	0x9
	.byte	0x71
	.sleb128 0
	.byte	0x8f
	.sleb128 296
	.byte	0x94
	.byte	0x4
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1967
	.8byte	.LVL1968
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1968
	.8byte	.LVL1975
	.2byte	0x3
	.byte	0x8f
	.sleb128 292
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST438:
	.8byte	.LVL1936
	.8byte	.LVL1943
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1943
	.8byte	.LVL1970
	.2byte	0x3
	.byte	0x8f
	.sleb128 288
	.8byte	.LVL1970
	.8byte	.LVL1971
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1971
	.8byte	.LVL1975
	.2byte	0x3
	.byte	0x8f
	.sleb128 288
	.8byte	.LVL1975
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST439:
	.8byte	.LVL1946
	.8byte	.LVL1947
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1957
	.8byte	.LVL1960-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1960-1
	.8byte	.LVL1961
	.2byte	0x3
	.byte	0x8f
	.sleb128 264
	.8byte	.LVL1962
	.8byte	.LVL1963
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST440:
	.8byte	.LVL1973
	.8byte	.LVL1974-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST468:
	.8byte	.LVL2151
	.8byte	.LVL2152
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc1
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL2152
	.8byte	.LVL2153
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc2
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL2153
	.8byte	.LVL2154
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc1
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST464:
	.8byte	.LVL2108
	.8byte	.LVL2109
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2111
	.8byte	.LVL2112
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL2121
	.8byte	.LVL2122
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2122
	.8byte	.LVL2123-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2125
	.8byte	.LVL2126
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2130
	.8byte	.LVL2131
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2131
	.8byte	.LVL2132-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2132
	.8byte	.LVL2133
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2133
	.8byte	.LVL2134
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL2134
	.8byte	.LVL2135-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2137
	.8byte	.LVL2138
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST465:
	.8byte	.LVL2111
	.8byte	.LVL2115
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2133
	.8byte	.LVL2136
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2137
	.8byte	.LVL2138
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST466:
	.8byte	.LVL2107
	.8byte	.LVL2108
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2108
	.8byte	.LVL2110
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2121
	.8byte	.LVL2124
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2125
	.8byte	.LVL2127
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2129
	.8byte	.LVL2130
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST467:
	.8byte	.LVL2106
	.8byte	.LVL2108
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2118
	.8byte	.LVL2119
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2120
	.8byte	.LVL2121
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST181:
	.8byte	.LVL665
	.8byte	.LVL666
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL666
	.8byte	.LVL691
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL691
	.8byte	.LFE209
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST182:
	.8byte	.LVL665
	.8byte	.LVL668
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL668
	.8byte	.LVL691
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL691
	.8byte	.LFE209
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST183:
	.8byte	.LVL665
	.8byte	.LVL669
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL669
	.8byte	.LVL672
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL673
	.8byte	.LVL682
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL683
	.8byte	.LVL690
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL692
	.8byte	.LVL703
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL704
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST184:
	.8byte	.LVL665
	.8byte	.LVL669
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL669
	.8byte	.LVL670
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL678
	.8byte	.LVL679
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL679
	.8byte	.LVL689
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL692
	.8byte	.LVL697
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL698
	.8byte	.LVL705
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL706
	.8byte	.LVL711
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL712
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST185:
	.8byte	.LVL667
	.8byte	.LVL669
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL669
	.8byte	.LVL671-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL678
	.8byte	.LVL679
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL679
	.8byte	.LVL680-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL680
	.8byte	.LVL681
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL692
	.8byte	.LVL700
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL700
	.8byte	.LVL701
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL702
	.8byte	.LVL705
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL706
	.8byte	.LVL714
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL714
	.8byte	.LVL715
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST186:
	.8byte	.LVL694
	.8byte	.LVL699
	.2byte	0x1
	.byte	0x5d
	.8byte	.LVL699
	.8byte	.LVL702
	.2byte	0x1
	.byte	0x5e
	.8byte	.LVL702
	.8byte	.LVL705
	.2byte	0x1
	.byte	0x5d
	.8byte	.LVL708
	.8byte	.LVL713
	.2byte	0x1
	.byte	0x5c
	.8byte	.LVL713
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x5d
	.8byte	0
	.8byte	0
.LLST187:
	.8byte	.LVL665
	.8byte	.LVL676
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL676
	.8byte	.LVL677
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL678
	.8byte	.LVL689
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL692
	.8byte	.LVL706
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL706
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST188:
	.8byte	.LVL665
	.8byte	.LVL678
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL678
	.8byte	.LVL685
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL686
	.8byte	.LVL687
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL692
	.8byte	.LVL706
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL706
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST189:
	.8byte	.LVL665
	.8byte	.LVL677
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL678
	.8byte	.LVL689
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL692
	.8byte	.LVL706
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL706
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST190:
	.8byte	.LVL665
	.8byte	.LVL675
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL675
	.8byte	.LVL677
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL678
	.8byte	.LVL689
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL692
	.8byte	.LVL706
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL706
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST200:
	.8byte	.LVL798
	.8byte	.LVL799
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST201:
	.8byte	.LVL745
	.8byte	.LVL751
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL752
	.8byte	.LVL759
	.2byte	0x7
	.byte	0x83
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL761
	.8byte	.LVL764
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL768
	.8byte	.LVL770
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL770
	.8byte	.LVL771-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL772
	.8byte	.LVL773-1
	.2byte	0xe
	.byte	0x3
	.8byte	c_ftl_nand_max_map_blks
	.byte	0x94
	.byte	0x4
	.byte	0x31
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL780
	.8byte	.LVL781
	.2byte	0x12
	.byte	0x3
	.8byte	c_ftl_nand_map_region_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL781
	.8byte	.LVL782-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL783
	.8byte	.LVL784-1
	.2byte	0xe
	.byte	0x3
	.8byte	c_ftl_nand_max_map_blks
	.byte	0x94
	.byte	0x4
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL785
	.8byte	.LVL786
	.2byte	0x12
	.byte	0x3
	.8byte	c_ftl_nand_l2pmap_ram_region_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x34
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL786
	.8byte	.LVL787-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL788
	.8byte	.LVL789
	.2byte	0x20
	.byte	0x3
	.8byte	c_ftl_nand_l2pmap_ram_region_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x3
	.8byte	c_ftl_nand_byte_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL789
	.8byte	.LVL790-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL791
	.8byte	.LVL792
	.2byte	0x12
	.byte	0x3
	.8byte	c_ftl_nand_blk_pre_plane
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL792
	.8byte	.LVL793-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL794
	.8byte	.LVL795
	.2byte	0x15
	.byte	0x3
	.8byte	c_ftl_nand_die_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0x1e
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL795
	.8byte	.LVL796
	.2byte	0x26
	.byte	0x3
	.8byte	c_ftl_nand_blks_per_die
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x23
	.uleb128 0x1f
	.byte	0x35
	.byte	0x26
	.byte	0x3
	.8byte	c_ftl_nand_die_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL796
	.8byte	.LVL797-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST8:
	.8byte	.LVL25
	.8byte	.LVL26
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL26
	.8byte	.LVL32
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL32
	.8byte	.LFE205
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST9:
	.8byte	.LVL27
	.8byte	.LVL28
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL28
	.8byte	.LVL29
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST7:
	.8byte	.LVL21
	.8byte	.LVL22
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL22
	.8byte	.LVL23
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL23
	.8byte	.LVL24
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL24
	.8byte	.LFE204
	.2byte	0x9
	.byte	0x3
	.8byte	c_ftl_nand_sys_blks_per_plane
	.8byte	0
	.8byte	0
.LLST4:
	.8byte	.LVL12
	.8byte	.LVL15
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL15
	.8byte	.LVL16
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL16
	.8byte	.LFE202
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST5:
	.8byte	.LVL12
	.8byte	.LVL13
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL13
	.8byte	.LVL14
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL14
	.8byte	.LVL16
	.2byte	0x3
	.byte	0x71
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL16
	.8byte	.LVL17
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL19
	.8byte	.LFE202
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST6:
	.8byte	.LVL12
	.8byte	.LVL13
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL13
	.8byte	.LFE202
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST102:
	.8byte	.LVL443
	.8byte	.LVL445-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL445-1
	.8byte	.LVL450
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL450
	.8byte	.LFE201
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST103:
	.8byte	.LVL444
	.8byte	.LVL445-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL445-1
	.8byte	.LVL446
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL446
	.8byte	.LVL447
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL447
	.8byte	.LVL448
	.2byte	0xc
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x8
	.byte	0x20
	.byte	0x26
	.byte	0x83
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL448
	.8byte	.LVL449
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST97:
	.8byte	.LVL291
	.8byte	.LVL293-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL293-1
	.8byte	.LVL426
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL426
	.8byte	.LVL427
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL427
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST98:
	.8byte	.LVL431
	.8byte	.LVL432
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL432
	.8byte	.LVL433
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL433
	.8byte	.LVL434-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL434-1
	.8byte	.LVL436
	.2byte	0x3
	.byte	0x87
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL436
	.8byte	.LVL437
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL439
	.8byte	.LVL440
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL440
	.8byte	.LVL441-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL441-1
	.8byte	.LVL442
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL442
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST99:
	.8byte	.LVL292
	.8byte	.LVL293-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL293-1
	.8byte	.LVL294
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL294
	.8byte	.LVL406
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL406
	.8byte	.LVL425
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL427
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST100:
	.8byte	.LVL431
	.8byte	.LVL434-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL436
	.8byte	.LVL438
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST101:
	.8byte	.LVL439
	.8byte	.LVL441-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL442
	.8byte	.LFE200
	.2byte	0xd
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x88
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST0:
	.8byte	.LVL5
	.8byte	.LVL7
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL7
	.8byte	.LVL8
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST1:
	.8byte	.LVL1
	.8byte	.LVL9
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST2:
	.8byte	.LVL4
	.8byte	.LVL6
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST3:
	.8byte	.LVL10
	.8byte	.LVL11
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL11
	.8byte	.LFE355
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST10:
	.8byte	.LVL34
	.8byte	.LVL37
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL37
	.8byte	.LFE208
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST11:
	.8byte	.LVL35
	.8byte	.LVL36
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL38
	.8byte	.LVL39
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST43:
	.8byte	.LVL116
	.8byte	.LVL117-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL117-1
	.8byte	.LFE245
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST44:
	.8byte	.LVL118
	.8byte	.LVL119
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST50:
	.8byte	.LVL136
	.8byte	.LVL137-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL137-1
	.8byte	.LFE244
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST51:
	.8byte	.LVL138
	.8byte	.LVL139
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST64:
	.8byte	.LVL179
	.8byte	.LVL180
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL180
	.8byte	.LVL202
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL202
	.8byte	.LFE252
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST65:
	.8byte	.LVL181
	.8byte	.LVL201
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST66:
	.8byte	.LVL190
	.8byte	.LVL192
	.2byte	0x5
	.byte	0x70
	.sleb128 0
	.byte	0x36
	.byte	0x1b
	.byte	0x9f
	.8byte	.LVL192
	.8byte	.LVL199-1
	.2byte	0xd
	.byte	0x86
	.sleb128 2
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x36
	.byte	0x1b
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST67:
	.8byte	.LVL183
	.8byte	.LVL185
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL185
	.8byte	.LVL188
	.2byte	0xd
	.byte	0x83
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.8byte	.LVL188
	.8byte	.LVL189-1
	.2byte	0x15
	.byte	0x83
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x3
	.8byte	p_valid_page_count_table
	.byte	0x6
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST68:
	.8byte	.LVL184
	.8byte	.LVL185
	.2byte	0xe
	.byte	0x84
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL185
	.8byte	.LVL186
	.2byte	0x1b
	.byte	0x83
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL186
	.8byte	.LVL187
	.2byte	0x1d
	.byte	0x83
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x86
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL187
	.8byte	.LVL196
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST69:
	.8byte	.LVL191
	.8byte	.LVL197
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST70:
	.8byte	.LVL193
	.8byte	.LVL195
	.2byte	0xe
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x72
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL195
	.8byte	.LVL198
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST71:
	.8byte	.LVL182
	.8byte	.LVL201
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST72:
	.8byte	.LVL190
	.8byte	.LVL192
	.2byte	0xe
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x70
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL192
	.8byte	.LVL194
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL194
	.8byte	.LVL199-1
	.2byte	0x16
	.byte	0x86
	.sleb128 2
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST76:
	.8byte	.LVL225
	.8byte	.LVL226
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL226
	.8byte	.LFE266
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST77:
	.8byte	.LVL231
	.8byte	.LVL232-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL232-1
	.8byte	.LFE272
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST78:
	.8byte	.LVL231
	.8byte	.LVL232-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL232-1
	.8byte	.LVL232
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL232
	.8byte	.LVL233
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL233
	.8byte	.LFE272
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST83:
	.8byte	.LVL246
	.8byte	.LVL248
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL249
	.8byte	.LFE282
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST84:
	.8byte	.LVL247
	.8byte	.LVL248
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL249
	.8byte	.LFE282
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST112:
	.8byte	.LVL479
	.8byte	.LVL481-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL481-1
	.8byte	.LFE297
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST113:
	.8byte	.LVL480
	.8byte	.LVL481-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL481-1
	.8byte	.LVL482
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST175:
	.8byte	.LVL655
	.8byte	.LVL656
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL656
	.8byte	.LVL664
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL664
	.8byte	.LFE240
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST176:
	.8byte	.LVL655
	.8byte	.LVL658-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL658-1
	.8byte	.LFE240
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST177:
	.8byte	.LVL657
	.8byte	.LVL658-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL658-1
	.8byte	.LVL663
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST178:
	.8byte	.LVL657
	.8byte	.LVL663
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST179:
	.8byte	.LVL657
	.8byte	.LVL663
	.2byte	0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST180:
	.8byte	.LVL659
	.8byte	.LVL660
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL660
	.8byte	.LVL662
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST193:
	.8byte	.LVL729
	.8byte	.LVL731
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL731
	.8byte	.LVL737
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL737
	.8byte	.LVL738
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL738
	.8byte	.LFE255
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST194:
	.8byte	.LVL729
	.8byte	.LVL732
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL732
	.8byte	.LVL737
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL738
	.8byte	.LVL739
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL740
	.8byte	.LFE255
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST195:
	.8byte	.LVL729
	.8byte	.LVL730
	.2byte	0x2
	.byte	0x70
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST196:
	.8byte	.LVL735
	.8byte	.LVL736
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST252:
	.8byte	.LVL968
	.8byte	.LVL972
	.2byte	0x7
	.byte	0xa
	.2byte	0x800
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL973
	.8byte	.LVL974
	.2byte	0x7
	.byte	0xa
	.2byte	0x801
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL974
	.8byte	.LVL975
	.2byte	0x7
	.byte	0xa
	.2byte	0x800
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST298:
	.8byte	.LVL1219
	.8byte	.LVL1221
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1221
	.8byte	.LVL1223
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1223
	.8byte	.LVL1229
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1229
	.8byte	.LFE344
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST299:
	.8byte	.LVL1220
	.8byte	.LVL1223
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1223
	.8byte	.LVL1228
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST319:
	.8byte	.LVL1312
	.8byte	.LVL1313
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1313
	.8byte	.LVL1316
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1316
	.8byte	.LFE317
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST320:
	.8byte	.LVL1314
	.8byte	.LVL1315
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1317
	.8byte	.LVL1320
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1321
	.8byte	.LFE317
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST321:
	.8byte	.LVL1324
	.8byte	.LVL1325
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1325
	.8byte	.LVL1326
	.2byte	0x6
	.byte	0x70
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL1328
	.8byte	.LVL1329
	.2byte	0x6
	.byte	0x70
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST322:
	.8byte	.LVL1330
	.8byte	.LVL1331
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1331
	.8byte	.LVL1339
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1339
	.8byte	.LFE301
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST323:
	.8byte	.LVL1332
	.8byte	.LVL1338
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST326:
	.8byte	.LVL1352
	.8byte	.LVL1353-1
	.2byte	0xe
	.byte	0x3
	.8byte	g_MaxLpn
	.byte	0x94
	.byte	0x4
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST327:
	.8byte	.LVL1352
	.8byte	.LVL1353-1
	.2byte	0x12
	.byte	0x3
	.8byte	c_ftl_nand_planes_num
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL1353-1
	.8byte	.LVL1356
	.2byte	0x9
	.byte	0x89
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL1358
	.8byte	.LVL1360
	.2byte	0x9
	.byte	0x89
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST328:
	.8byte	.LVL1354
	.8byte	.LVL1357
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1358
	.8byte	.LVL1364
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST412:
	.8byte	.LVL1829
	.8byte	.LVL1831
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1831
	.8byte	.LVL1844
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1844
	.8byte	.LVL1845
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1845
	.8byte	.LVL1865
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1865
	.8byte	.LVL1867
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1867
	.8byte	.LVL1878
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1878
	.8byte	.LVL1924
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1924
	.8byte	.LVL1925
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1925
	.8byte	.LFE319
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST413:
	.8byte	.LVL1829
	.8byte	.LVL1830
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1830
	.8byte	.LFE319
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST414:
	.8byte	.LVL1832
	.8byte	.LVL1844
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1847
	.8byte	.LVL1924
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST415:
	.8byte	.LVL1832
	.8byte	.LVL1844
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1847
	.8byte	.LVL1865
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1865
	.8byte	.LVL1867
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1867
	.8byte	.LVL1878
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1878
	.8byte	.LVL1924
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST416:
	.8byte	.LVL1908
	.8byte	.LVL1909-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1909-1
	.8byte	.LVL1910
	.2byte	0x3
	.byte	0x8f
	.sleb128 272
	.8byte	0
	.8byte	0
.LLST417:
	.8byte	.LVL1889
	.8byte	.LVL1890
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1890
	.8byte	.LVL1903
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1903
	.8byte	.LVL1904
	.2byte	0x3
	.byte	0x8b
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1905
	.8byte	.LVL1924
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST418:
	.8byte	.LVL1891
	.8byte	.LVL1896
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1898
	.8byte	.LVL1899
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1900
	.8byte	.LVL1902
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST419:
	.8byte	.LVL1891
	.8byte	.LVL1893
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1894
	.8byte	.LVL1901
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST420:
	.8byte	.LVL1892
	.8byte	.LVL1895
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1895
	.8byte	.LVL1897
	.2byte	0x2
	.byte	0x71
	.sleb128 0
	.8byte	.LVL1897
	.8byte	.LVL1898
	.2byte	0x2
	.byte	0x71
	.sleb128 -2
	.8byte	0
	.8byte	0
.LLST421:
	.8byte	.LVL1887
	.8byte	.LVL1924
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	0
	.8byte	0
.LLST422:
	.8byte	.LVL1906
	.8byte	.LVL1907
	.2byte	0x2
	.byte	0x71
	.sleb128 16
	.8byte	.LVL1907
	.8byte	.LVL1915
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST423:
	.8byte	.LVL1837
	.8byte	.LVL1838
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST463:
	.8byte	.LVL2087
	.8byte	.LVL2088
	.2byte	0xa
	.byte	0x3
	.8byte	g_active_superblock
	.byte	0x9f
	.8byte	.LVL2088
	.8byte	.LVL2092
	.2byte	0xa
	.byte	0x3
	.8byte	g_buffer_superblock
	.byte	0x9f
	.8byte	0
	.8byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x87c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x8
	.byte	0
	.2byte	0
	.2byte	0
	.8byte	.LFB349
	.8byte	.LFE349-.LFB349
	.8byte	.LFB355
	.8byte	.LFE355-.LFB355
	.8byte	.LFB202
	.8byte	.LFE202-.LFB202
	.8byte	.LFB203
	.8byte	.LFE203-.LFB203
	.8byte	.LFB204
	.8byte	.LFE204-.LFB204
	.8byte	.LFB205
	.8byte	.LFE205-.LFB205
	.8byte	.LFB208
	.8byte	.LFE208-.LFB208
	.8byte	.LFB216
	.8byte	.LFE216-.LFB216
	.8byte	.LFB221
	.8byte	.LFE221-.LFB221
	.8byte	.LFB222
	.8byte	.LFE222-.LFB222
	.8byte	.LFB223
	.8byte	.LFE223-.LFB223
	.8byte	.LFB224
	.8byte	.LFE224-.LFB224
	.8byte	.LFB228
	.8byte	.LFE228-.LFB228
	.8byte	.LFB232
	.8byte	.LFE232-.LFB232
	.8byte	.LFB233
	.8byte	.LFE233-.LFB233
	.8byte	.LFB234
	.8byte	.LFE234-.LFB234
	.8byte	.LFB235
	.8byte	.LFE235-.LFB235
	.8byte	.LFB238
	.8byte	.LFE238-.LFB238
	.8byte	.LFB239
	.8byte	.LFE239-.LFB239
	.8byte	.LFB241
	.8byte	.LFE241-.LFB241
	.8byte	.LFB242
	.8byte	.LFE242-.LFB242
	.8byte	.LFB246
	.8byte	.LFE246-.LFB246
	.8byte	.LFB245
	.8byte	.LFE245-.LFB245
	.8byte	.LFB247
	.8byte	.LFE247-.LFB247
	.8byte	.LFB244
	.8byte	.LFE244-.LFB244
	.8byte	.LFB248
	.8byte	.LFE248-.LFB248
	.8byte	.LFB249
	.8byte	.LFE249-.LFB249
	.8byte	.LFB250
	.8byte	.LFE250-.LFB250
	.8byte	.LFB251
	.8byte	.LFE251-.LFB251
	.8byte	.LFB252
	.8byte	.LFE252-.LFB252
	.8byte	.LFB260
	.8byte	.LFE260-.LFB260
	.8byte	.LFB266
	.8byte	.LFE266-.LFB266
	.8byte	.LFB272
	.8byte	.LFE272-.LFB272
	.8byte	.LFB273
	.8byte	.LFE273-.LFB273
	.8byte	.LFB279
	.8byte	.LFE279-.LFB279
	.8byte	.LFB282
	.8byte	.LFE282-.LFB282
	.8byte	.LFB284
	.8byte	.LFE284-.LFB284
	.8byte	.LFB293
	.8byte	.LFE293-.LFB293
	.8byte	.LFB294
	.8byte	.LFE294-.LFB294
	.8byte	.LFB295
	.8byte	.LFE295-.LFB295
	.8byte	.LFB200
	.8byte	.LFE200-.LFB200
	.8byte	.LFB201
	.8byte	.LFE201-.LFB201
	.8byte	.LFB296
	.8byte	.LFE296-.LFB296
	.8byte	.LFB297
	.8byte	.LFE297-.LFB297
	.8byte	.LFB300
	.8byte	.LFE300-.LFB300
	.8byte	.LFB303
	.8byte	.LFE303-.LFB303
	.8byte	.LFB304
	.8byte	.LFE304-.LFB304
	.8byte	.LFB305
	.8byte	.LFE305-.LFB305
	.8byte	.LFB306
	.8byte	.LFE306-.LFB306
	.8byte	.LFB307
	.8byte	.LFE307-.LFB307
	.8byte	.LFB314
	.8byte	.LFE314-.LFB314
	.8byte	.LFB315
	.8byte	.LFE315-.LFB315
	.8byte	.LFB316
	.8byte	.LFE316-.LFB316
	.8byte	.LFB337
	.8byte	.LFE337-.LFB337
	.8byte	.LFB338
	.8byte	.LFE338-.LFB338
	.8byte	.LFB339
	.8byte	.LFE339-.LFB339
	.8byte	.LFB341
	.8byte	.LFE341-.LFB341
	.8byte	.LFB230
	.8byte	.LFE230-.LFB230
	.8byte	.LFB236
	.8byte	.LFE236-.LFB236
	.8byte	.LFB342
	.8byte	.LFE342-.LFB342
	.8byte	.LFB343
	.8byte	.LFE343-.LFB343
	.8byte	.LFB240
	.8byte	.LFE240-.LFB240
	.8byte	.LFB209
	.8byte	.LFE209-.LFB209
	.8byte	.LFB243
	.8byte	.LFE243-.LFB243
	.8byte	.LFB255
	.8byte	.LFE255-.LFB255
	.8byte	.LFB346
	.8byte	.LFE346-.LFB346
	.8byte	.LFB206
	.8byte	.LFE206-.LFB206
	.8byte	.LFB225
	.8byte	.LFE225-.LFB225
	.8byte	.LFB227
	.8byte	.LFE227-.LFB227
	.8byte	.LFB237
	.8byte	.LFE237-.LFB237
	.8byte	.LFB253
	.8byte	.LFE253-.LFB253
	.8byte	.LFB254
	.8byte	.LFE254-.LFB254
	.8byte	.LFB257
	.8byte	.LFE257-.LFB257
	.8byte	.LFB258
	.8byte	.LFE258-.LFB258
	.8byte	.LFB256
	.8byte	.LFE256-.LFB256
	.8byte	.LFB259
	.8byte	.LFE259-.LFB259
	.8byte	.LFB262
	.8byte	.LFE262-.LFB262
	.8byte	.LFB280
	.8byte	.LFE280-.LFB280
	.8byte	.LFB291
	.8byte	.LFE291-.LFB291
	.8byte	.LFB318
	.8byte	.LFE318-.LFB318
	.8byte	.LFB267
	.8byte	.LFE267-.LFB267
	.8byte	.LFB270
	.8byte	.LFE270-.LFB270
	.8byte	.LFB275
	.8byte	.LFE275-.LFB275
	.8byte	.LFB276
	.8byte	.LFE276-.LFB276
	.8byte	.LFB277
	.8byte	.LFE277-.LFB277
	.8byte	.LFB278
	.8byte	.LFE278-.LFB278
	.8byte	.LFB207
	.8byte	.LFE207-.LFB207
	.8byte	.LFB285
	.8byte	.LFE285-.LFB285
	.8byte	.LFB290
	.8byte	.LFE290-.LFB290
	.8byte	.LFB309
	.8byte	.LFE309-.LFB309
	.8byte	.LFB310
	.8byte	.LFE310-.LFB310
	.8byte	.LFB344
	.8byte	.LFE344-.LFB344
	.8byte	.LFB345
	.8byte	.LFE345-.LFB345
	.8byte	.LFB347
	.8byte	.LFE347-.LFB347
	.8byte	.LFB226
	.8byte	.LFE226-.LFB226
	.8byte	.LFB298
	.8byte	.LFE298-.LFB298
	.8byte	.LFB317
	.8byte	.LFE317-.LFB317
	.8byte	.LFB301
	.8byte	.LFE301-.LFB301
	.8byte	.LFB302
	.8byte	.LFE302-.LFB302
	.8byte	.LFB268
	.8byte	.LFE268-.LFB268
	.8byte	.LFB261
	.8byte	.LFE261-.LFB261
	.8byte	.LFB281
	.8byte	.LFE281-.LFB281
	.8byte	.LFB288
	.8byte	.LFE288-.LFB288
	.8byte	.LFB229
	.8byte	.LFE229-.LFB229
	.8byte	.LFB231
	.8byte	.LFE231-.LFB231
	.8byte	.LFB263
	.8byte	.LFE263-.LFB263
	.8byte	.LFB286
	.8byte	.LFE286-.LFB286
	.8byte	.LFB265
	.8byte	.LFE265-.LFB265
	.8byte	.LFB264
	.8byte	.LFE264-.LFB264
	.8byte	.LFB271
	.8byte	.LFE271-.LFB271
	.8byte	.LFB287
	.8byte	.LFE287-.LFB287
	.8byte	.LFB269
	.8byte	.LFE269-.LFB269
	.8byte	.LFB212
	.8byte	.LFE212-.LFB212
	.8byte	.LFB213
	.8byte	.LFE213-.LFB213
	.8byte	.LFB218
	.8byte	.LFE218-.LFB218
	.8byte	.LFB289
	.8byte	.LFE289-.LFB289
	.8byte	.LFB299
	.8byte	.LFE299-.LFB299
	.8byte	.LFB215
	.8byte	.LFE215-.LFB215
	.8byte	.LFB308
	.8byte	.LFE308-.LFB308
	.8byte	.LFB311
	.8byte	.LFE311-.LFB311
	.8byte	.LFB283
	.8byte	.LFE283-.LFB283
	.8byte	.LFB313
	.8byte	.LFE313-.LFB313
	.8byte	.LFB312
	.8byte	.LFE312-.LFB312
	.8byte	.LFB319
	.8byte	.LFE319-.LFB319
	.8byte	.LFB320
	.8byte	.LFE320-.LFB320
	.8byte	.LFB214
	.8byte	.LFE214-.LFB214
	.8byte	.LFB219
	.8byte	.LFE219-.LFB219
	.8byte	.LFB217
	.8byte	.LFE217-.LFB217
	.8byte	.LFB220
	.8byte	.LFE220-.LFB220
	.8byte	.LFB274
	.8byte	.LFE274-.LFB274
	.8byte	.LFB292
	.8byte	.LFE292-.LFB292
	.8byte	.LFB210
	.8byte	.LFE210-.LFB210
	.8byte	.LFB211
	.8byte	.LFE211-.LFB211
	.8byte	.LFB348
	.8byte	.LFE348-.LFB348
	.8byte	0
	.8byte	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.8byte	.LBB185
	.8byte	.LBE185
	.8byte	.LBB188
	.8byte	.LBE188
	.8byte	0
	.8byte	0
	.8byte	.LBB189
	.8byte	.LBE189
	.8byte	.LBB192
	.8byte	.LBE192
	.8byte	0
	.8byte	0
	.8byte	.LBB207
	.8byte	.LBE207
	.8byte	.LBB211
	.8byte	.LBE211
	.8byte	.LBB212
	.8byte	.LBE212
	.8byte	0
	.8byte	0
	.8byte	.LBB221
	.8byte	.LBE221
	.8byte	.LBB224
	.8byte	.LBE224
	.8byte	0
	.8byte	0
	.8byte	.LBB231
	.8byte	.LBE231
	.8byte	.LBB232
	.8byte	.LBE232
	.8byte	0
	.8byte	0
	.8byte	.LBB246
	.8byte	.LBE246
	.8byte	.LBB250
	.8byte	.LBE250
	.8byte	.LBB253
	.8byte	.LBE253
	.8byte	0
	.8byte	0
	.8byte	.LBB251
	.8byte	.LBE251
	.8byte	.LBB252
	.8byte	.LBE252
	.8byte	.LBB254
	.8byte	.LBE254
	.8byte	.LBB255
	.8byte	.LBE255
	.8byte	0
	.8byte	0
	.8byte	.LBB260
	.8byte	.LBE260
	.8byte	.LBB261
	.8byte	.LBE261
	.8byte	0
	.8byte	0
	.8byte	.LBB268
	.8byte	.LBE268
	.8byte	.LBB270
	.8byte	.LBE270
	.8byte	.LBB271
	.8byte	.LBE271
	.8byte	.LBB272
	.8byte	.LBE272
	.8byte	0
	.8byte	0
	.8byte	.LBB277
	.8byte	.LBE277
	.8byte	.LBB278
	.8byte	.LBE278
	.8byte	0
	.8byte	0
	.8byte	.LBB287
	.8byte	.LBE287
	.8byte	.LBB291
	.8byte	.LBE291
	.8byte	.LBB292
	.8byte	.LBE292
	.8byte	0
	.8byte	0
	.8byte	.LBB301
	.8byte	.LBE301
	.8byte	.LBB302
	.8byte	.LBE302
	.8byte	0
	.8byte	0
	.8byte	.LBB304
	.8byte	.LBE304
	.8byte	.LBB306
	.8byte	.LBE306
	.8byte	0
	.8byte	0
	.8byte	.LBB305
	.8byte	.LBE305
	.8byte	.LBB307
	.8byte	.LBE307
	.8byte	.LBB308
	.8byte	.LBE308
	.8byte	.LBB309
	.8byte	.LBE309
	.8byte	0
	.8byte	0
	.8byte	.LBB326
	.8byte	.LBE326
	.8byte	.LBB331
	.8byte	.LBE331
	.8byte	0
	.8byte	0
	.8byte	.LBB328
	.8byte	.LBE328
	.8byte	.LBB329
	.8byte	.LBE329
	.8byte	0
	.8byte	0
	.8byte	.LBB333
	.8byte	.LBE333
	.8byte	.LBB334
	.8byte	.LBE334
	.8byte	0
	.8byte	0
	.8byte	.LFB349
	.8byte	.LFE349
	.8byte	.LFB355
	.8byte	.LFE355
	.8byte	.LFB202
	.8byte	.LFE202
	.8byte	.LFB203
	.8byte	.LFE203
	.8byte	.LFB204
	.8byte	.LFE204
	.8byte	.LFB205
	.8byte	.LFE205
	.8byte	.LFB208
	.8byte	.LFE208
	.8byte	.LFB216
	.8byte	.LFE216
	.8byte	.LFB221
	.8byte	.LFE221
	.8byte	.LFB222
	.8byte	.LFE222
	.8byte	.LFB223
	.8byte	.LFE223
	.8byte	.LFB224
	.8byte	.LFE224
	.8byte	.LFB228
	.8byte	.LFE228
	.8byte	.LFB232
	.8byte	.LFE232
	.8byte	.LFB233
	.8byte	.LFE233
	.8byte	.LFB234
	.8byte	.LFE234
	.8byte	.LFB235
	.8byte	.LFE235
	.8byte	.LFB238
	.8byte	.LFE238
	.8byte	.LFB239
	.8byte	.LFE239
	.8byte	.LFB241
	.8byte	.LFE241
	.8byte	.LFB242
	.8byte	.LFE242
	.8byte	.LFB246
	.8byte	.LFE246
	.8byte	.LFB245
	.8byte	.LFE245
	.8byte	.LFB247
	.8byte	.LFE247
	.8byte	.LFB244
	.8byte	.LFE244
	.8byte	.LFB248
	.8byte	.LFE248
	.8byte	.LFB249
	.8byte	.LFE249
	.8byte	.LFB250
	.8byte	.LFE250
	.8byte	.LFB251
	.8byte	.LFE251
	.8byte	.LFB252
	.8byte	.LFE252
	.8byte	.LFB260
	.8byte	.LFE260
	.8byte	.LFB266
	.8byte	.LFE266
	.8byte	.LFB272
	.8byte	.LFE272
	.8byte	.LFB273
	.8byte	.LFE273
	.8byte	.LFB279
	.8byte	.LFE279
	.8byte	.LFB282
	.8byte	.LFE282
	.8byte	.LFB284
	.8byte	.LFE284
	.8byte	.LFB293
	.8byte	.LFE293
	.8byte	.LFB294
	.8byte	.LFE294
	.8byte	.LFB295
	.8byte	.LFE295
	.8byte	.LFB200
	.8byte	.LFE200
	.8byte	.LFB201
	.8byte	.LFE201
	.8byte	.LFB296
	.8byte	.LFE296
	.8byte	.LFB297
	.8byte	.LFE297
	.8byte	.LFB300
	.8byte	.LFE300
	.8byte	.LFB303
	.8byte	.LFE303
	.8byte	.LFB304
	.8byte	.LFE304
	.8byte	.LFB305
	.8byte	.LFE305
	.8byte	.LFB306
	.8byte	.LFE306
	.8byte	.LFB307
	.8byte	.LFE307
	.8byte	.LFB314
	.8byte	.LFE314
	.8byte	.LFB315
	.8byte	.LFE315
	.8byte	.LFB316
	.8byte	.LFE316
	.8byte	.LFB337
	.8byte	.LFE337
	.8byte	.LFB338
	.8byte	.LFE338
	.8byte	.LFB339
	.8byte	.LFE339
	.8byte	.LFB341
	.8byte	.LFE341
	.8byte	.LFB230
	.8byte	.LFE230
	.8byte	.LFB236
	.8byte	.LFE236
	.8byte	.LFB342
	.8byte	.LFE342
	.8byte	.LFB343
	.8byte	.LFE343
	.8byte	.LFB240
	.8byte	.LFE240
	.8byte	.LFB209
	.8byte	.LFE209
	.8byte	.LFB243
	.8byte	.LFE243
	.8byte	.LFB255
	.8byte	.LFE255
	.8byte	.LFB346
	.8byte	.LFE346
	.8byte	.LFB206
	.8byte	.LFE206
	.8byte	.LFB225
	.8byte	.LFE225
	.8byte	.LFB227
	.8byte	.LFE227
	.8byte	.LFB237
	.8byte	.LFE237
	.8byte	.LFB253
	.8byte	.LFE253
	.8byte	.LFB254
	.8byte	.LFE254
	.8byte	.LFB257
	.8byte	.LFE257
	.8byte	.LFB258
	.8byte	.LFE258
	.8byte	.LFB256
	.8byte	.LFE256
	.8byte	.LFB259
	.8byte	.LFE259
	.8byte	.LFB262
	.8byte	.LFE262
	.8byte	.LFB280
	.8byte	.LFE280
	.8byte	.LFB291
	.8byte	.LFE291
	.8byte	.LFB318
	.8byte	.LFE318
	.8byte	.LFB267
	.8byte	.LFE267
	.8byte	.LFB270
	.8byte	.LFE270
	.8byte	.LFB275
	.8byte	.LFE275
	.8byte	.LFB276
	.8byte	.LFE276
	.8byte	.LFB277
	.8byte	.LFE277
	.8byte	.LFB278
	.8byte	.LFE278
	.8byte	.LFB207
	.8byte	.LFE207
	.8byte	.LFB285
	.8byte	.LFE285
	.8byte	.LFB290
	.8byte	.LFE290
	.8byte	.LFB309
	.8byte	.LFE309
	.8byte	.LFB310
	.8byte	.LFE310
	.8byte	.LFB344
	.8byte	.LFE344
	.8byte	.LFB345
	.8byte	.LFE345
	.8byte	.LFB347
	.8byte	.LFE347
	.8byte	.LFB226
	.8byte	.LFE226
	.8byte	.LFB298
	.8byte	.LFE298
	.8byte	.LFB317
	.8byte	.LFE317
	.8byte	.LFB301
	.8byte	.LFE301
	.8byte	.LFB302
	.8byte	.LFE302
	.8byte	.LFB268
	.8byte	.LFE268
	.8byte	.LFB261
	.8byte	.LFE261
	.8byte	.LFB281
	.8byte	.LFE281
	.8byte	.LFB288
	.8byte	.LFE288
	.8byte	.LFB229
	.8byte	.LFE229
	.8byte	.LFB231
	.8byte	.LFE231
	.8byte	.LFB263
	.8byte	.LFE263
	.8byte	.LFB286
	.8byte	.LFE286
	.8byte	.LFB265
	.8byte	.LFE265
	.8byte	.LFB264
	.8byte	.LFE264
	.8byte	.LFB271
	.8byte	.LFE271
	.8byte	.LFB287
	.8byte	.LFE287
	.8byte	.LFB269
	.8byte	.LFE269
	.8byte	.LFB212
	.8byte	.LFE212
	.8byte	.LFB213
	.8byte	.LFE213
	.8byte	.LFB218
	.8byte	.LFE218
	.8byte	.LFB289
	.8byte	.LFE289
	.8byte	.LFB299
	.8byte	.LFE299
	.8byte	.LFB215
	.8byte	.LFE215
	.8byte	.LFB308
	.8byte	.LFE308
	.8byte	.LFB311
	.8byte	.LFE311
	.8byte	.LFB283
	.8byte	.LFE283
	.8byte	.LFB313
	.8byte	.LFE313
	.8byte	.LFB312
	.8byte	.LFE312
	.8byte	.LFB319
	.8byte	.LFE319
	.8byte	.LFB320
	.8byte	.LFE320
	.8byte	.LFB214
	.8byte	.LFE214
	.8byte	.LFB219
	.8byte	.LFE219
	.8byte	.LFB217
	.8byte	.LFE217
	.8byte	.LFB220
	.8byte	.LFE220
	.8byte	.LFB274
	.8byte	.LFE274
	.8byte	.LFB292
	.8byte	.LFE292
	.8byte	.LFB210
	.8byte	.LFE210
	.8byte	.LFB211
	.8byte	.LFE211
	.8byte	.LFB348
	.8byte	.LFE348
	.8byte	0
	.8byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF727:
	.string	"FtlEctTblFlush"
.LASF592:
	.string	"gc_page_num"
.LASF608:
	.string	"superBlk"
.LASF498:
	.string	"g_gc_bad_block_temp_num"
.LASF363:
	.string	"all_blk_used_slc_mode"
.LASF43:
	.string	"reserved"
.LASF507:
	.string	"g_totle_read_sector"
.LASF573:
	.string	"__func__"
.LASF419:
	.string	"c_ftl_nand_sys_blks_per_plane"
.LASF732:
	.string	"nSec"
.LASF728:
	.string	"forceFlush"
.LASF107:
	.string	"bootm_headers"
.LASF452:
	.string	"p_gc_data_buf"
.LASF125:
	.string	"rd_end"
.LASF491:
	.string	"p_gc_blk_tbl"
.LASF787:
	.string	"FtlFreeSysBlkQueueOut"
.LASF324:
	.string	"ftl_bbt_blk_header"
.LASF227:
	.string	"eth_device"
.LASF306:
	.string	"sign"
.LASF831:
	.string	"sctidx"
.LASF669:
	.string	"Ftl_load_ext_data"
.LASF96:
	.string	"ih_comp"
.LASF586:
	.string	"block"
.LASF22:
	.string	"_Bool"
.LASF651:
	.string	"min_ec"
.LASF603:
	.string	"req_read_temp"
.LASF279:
	.string	"p_spare"
.LASF685:
	.string	"recovery_cur_page_ver"
.LASF505:
	.string	"g_totle_write_page_count"
.LASF245:
	.string	"net_root_path"
.LASF624:
	.string	"lookup_ppa"
.LASF816:
	.string	"FtlBbmTblFlush"
.LASF611:
	.string	"Ftl_get_new_temp_ppa"
.LASF327:
	.string	"ftl_data_blk_header"
.LASF284:
	.string	"blk_per_plane"
.LASF360:
	.string	"min_erase_count"
.LASF114:
	.string	"fit_noffset_os"
.LASF391:
	.string	"des_ppa"
.LASF237:
	.string	"priv"
.LASF777:
	.string	"insert_free_list"
.LASF880:
	.ascii	"GNU C11 6.3.1 20170404 -ms"
	.string	"trict-align -march=armv8-a+nosimd -mlittle-endian -mabi=lp64 -g -Os -fno-builtin -ffreestanding -fshort-wchar -fno-stack-protector -fno-delete-null-pointer-checks -fstack-usage -fno-pic -ffunction-sections -fdata-sections -ffixed-r9 -fno-common -ffixed-x18"
.LASF21:
	.string	"___strtok"
.LASF198:
	.string	"UCLASS_SPI_GENERIC"
.LASF476:
	.string	"g_l2p_last_update_region_id"
.LASF698:
	.string	"ftl_sb_update_avl_pages"
.LASF571:
	.string	"FlashProgPages"
.LASF855:
	.string	"test_page_num"
.LASF684:
	.string	"lookup_superblock_id"
.LASF420:
	.string	"c_ftl_nand_init_sys_blks_per_plane"
.LASF864:
	.string	"FtlConstantsInit"
.LASF595:
	.string	"num_io"
.LASF867:
	.string	"FtlPrintInfo"
.LASF744:
	.string	"l2p_flush"
.LASF378:
	.string	"rear"
.LASF305:
	.string	"ftl_l2p_map_info"
.LASF520:
	.string	"g_in_swl_replace"
.LASF404:
	.string	"c_ftl_nand_page_pre_slc_blk"
.LASF243:
	.string	"net_nis_domain"
.LASF764:
	.string	"List_update_data_list"
.LASF851:
	.string	"create_first_buffer_superblock"
.LASF502:
	.string	"g_gc_merge_free_blk_threshold"
.LASF693:
	.string	"last_mlc_page_version"
.LASF630:
	.string	"IsBlkInGcList"
.LASF235:
	.string	"next"
.LASF312:
	.string	"pBlkVpcTbl"
.LASF697:
	.string	"FtlReUsePrevPpa"
.LASF658:
	.string	"update_multiplier_value"
.LASF411:
	.string	"c_ftl_nand_totle_phy_blks"
.LASF873:
	.string	"memcmp"
.LASF421:
	.string	"c_ftl_nand_max_sys_blks"
.LASF576:
	.string	"PhyBlk"
.LASF575:
	.string	"FlashReadPages"
.LASF478:
	.string	"p_free_data_block_list_head"
.LASF148:
	.string	"UCLASS_AHCI"
.LASF161:
	.string	"UCLASS_I2C_MUX"
.LASF263:
	.string	"uclass_id"
.LASF600:
	.string	"get_new_gc_superblock"
.LASF622:
	.string	"BOPS_EN"
.LASF241:
	.string	"net_netmask"
.LASF848:
	.string	"bad_block_cnt"
.LASF424:
	.string	"c_ftl_nand_max_data_blks"
.LASF559:
	.string	"pvTo"
.LASF117:
	.string	"fit_noffset_rd"
.LASF192:
	.string	"UCLASS_RTC"
.LASF808:
	.string	"pBbtHeader"
.LASF46:
	.string	"bi_memsize"
.LASF47:
	.string	"bi_flashstart"
.LASF761:
	.string	"minValidPageCount"
.LASF232:
	.string	"recv"
.LASF122:
	.string	"fit_uname_setup"
.LASF199:
	.string	"UCLASS_SYSCON"
.LASF153:
	.string	"UCLASS_DISPLAY"
.LASF518:
	.string	"g_max_erase_count"
.LASF567:
	.string	"flash_type"
.LASF528:
	.string	"g_recovery_ppa_tbl"
.LASF71:
	.string	"IRQ_STACK_START_IN"
.LASF63:
	.string	"bi_dram"
.LASF191:
	.string	"UCLASS_RKNAND"
.LASF580:
	.string	"die_index"
.LASF803:
	.string	"ver2"
.LASF434:
	.string	"gSysFreeQueue"
.LASF159:
	.string	"UCLASS_I2C_EEPROM"
.LASF532:
	.string	"g_nand_phy_info"
.LASF554:
	.string	"check_spare_buf"
.LASF144:
	.string	"UCLASS_PCI_EMUL"
.LASF72:
	.string	"fdt_header"
.LASF585:
	.string	"ftl_free"
.LASF429:
	.string	"g_MaxLpn"
.LASF342:
	.string	"bufferPageOffset"
.LASF387:
	.string	"reversed"
.LASF506:
	.string	"g_totle_write_sector"
.LASF75:
	.string	"off_dt_struct"
.LASF417:
	.string	"c_ftl_nand_max_vendor_blks"
.LASF768:
	.string	"prev_valid_page_count"
.LASF872:
	.string	"FtlPrintInfo2buf"
.LASF479:
	.string	"p_data_block_list_head"
.LASF265:
	.string	"NETLOOP_CONTINUE"
.LASF805:
	.string	"P2V_plane"
.LASF485:
	.string	"g_gc_temp_superblock"
.LASF195:
	.string	"UCLASS_SPI"
.LASF416:
	.string	"c_ftl_nand_max_map_blks"
.LASF302:
	.string	"BbtMap"
.LASF743:
	.string	"found_lpa"
.LASF209:
	.string	"UCLASS_VIDEO_CONSOLE"
.LASF367:
	.string	"last_refresh_read_count"
.LASF207:
	.string	"UCLASS_VIDEO"
.LASF615:
	.string	"current_ppa"
.LASF850:
	.string	"create_first_active_superblock"
.LASF313:
	.string	"pMapPpnTbl"
.LASF269:
	.string	"net_state"
.LASF724:
	.string	"num_page"
.LASF425:
	.string	"ftl_gc_temp_power_lost_recovery_flag"
.LASF614:
	.string	"totle_num"
.LASF731:
	.string	"Index"
.LASF681:
	.string	"next_free_active_page"
.LASF606:
	.string	"spperBlk"
.LASF65:
	.string	"IRQ_STACK_START"
.LASF132:
	.string	"verify"
.LASF713:
	.string	"ftl_set_blk_mode"
.LASF266:
	.string	"NETLOOP_RESTART"
.LASF270:
	.string	"uint8"
.LASF353:
	.string	"write_page_count"
.LASF610:
	.string	"Ftl_gc_temp_data_write_back"
.LASF295:
	.string	"erase_blk"
.LASF722:
	.string	"re_save_vpndata"
.LASF462:
	.string	"p_valid_page_count_check_table"
.LASF501:
	.string	"g_gc_free_blk_threshold"
.LASF481:
	.string	"g_num_free_superblocks"
.LASF226:
	.string	"s_addr"
.LASF818:
	.string	"re_save_bbmdata"
.LASF200:
	.string	"UCLASS_SYSRESET"
.LASF627:
	.string	"FtlGcUpdatePage"
.LASF810:
	.string	"FtlLoadFactoryBbt"
.LASF289:
	.string	"sec_per_blk"
.LASF136:
	.string	"UCLASS_ROOT"
.LASF296:
	.string	"prog_page"
.LASF340:
	.string	"activePageOffset"
.LASF152:
	.string	"UCLASS_CROS_EC"
.LASF407:
	.string	"c_ftl_nand_sec_pre_page_shift"
.LASF790:
	.string	"IsInFreeQueue"
.LASF236:
	.string	"index"
.LASF745:
	.string	"select_l2p_ram_region"
.LASF335:
	.string	"maxDieNum"
.LASF290:
	.string	"byte_per_sec"
.LASF278:
	.string	"p_data"
.LASF527:
	.string	"g_recovery_page_min_ver"
.LASF570:
	.string	"block_size"
.LASF90:
	.string	"ih_load"
.LASF834:
	.string	"FtlProgPages"
.LASF664:
	.string	"error_flag"
.LASF403:
	.string	"c_ftl_nand_page_pre_blk"
.LASF789:
	.string	"blk_Id"
.LASF213:
	.string	"UCLASS_KEY"
.LASF874:
	.string	"memcpy"
.LASF67:
	.string	"_datarel_start_ofs"
.LASF373:
	.string	"List_Node"
.LASF577:
	.string	"p_die"
.LASF314:
	.string	"in_gc_mode"
.LASF147:
	.string	"UCLASS_ADC"
.LASF94:
	.string	"ih_arch"
.LASF163:
	.string	"UCLASS_IRQ"
.LASF6:
	.string	"__u8"
.LASF493:
	.string	"g_gc_page_offset"
.LASF240:
	.string	"net_gateway"
.LASF801:
	.string	"ftl_cmp_data_ver"
.LASF430:
	.string	"g_VaildLpn"
.LASF470:
	.string	"p_vendor_block_valid_page_count"
.LASF262:
	.string	"net_ping_ip"
.LASF104:
	.string	"type"
.LASF40:
	.string	"lmb_region"
.LASF632:
	.string	"numREQ"
.LASF34:
	.string	"protect"
.LASF854:
	.string	"max_test_page_num"
.LASF704:
	.string	"blk_id"
.LASF349:
	.string	"GlobalDataVersion"
.LASF793:
	.string	"erase_flag"
.LASF362:
	.string	"last_refresh_data_times"
.LASF707:
	.string	"totleBlkNum"
.LASF678:
	.string	"saved_active_page"
.LASF776:
	.string	"pTmp"
.LASF604:
	.string	"add_count"
.LASF546:
	.string	"ftl_gc_temp_block_bops_scan_page_addr"
.LASF394:
	.string	"c_ftl_nand_type"
.LASF773:
	.string	"pHead"
.LASF687:
	.string	"recovery_flash_mode"
.LASF138:
	.string	"UCLASS_TEST"
.LASF484:
	.string	"g_buffer_superblock"
.LASF649:
	.string	"node_id"
.LASF397:
	.string	"c_ftl_nand_blks_per_die"
.LASF261:
	.string	"net_boot_file_expected_size_in_blocks"
.LASF23:
	.string	"image_base"
.LASF110:
	.string	"legacy_hdr_valid"
.LASF203:
	.string	"UCLASS_TPM"
.LASF574:
	.string	"read_req"
.LASF432:
	.string	"gBbtInfo"
.LASF169:
	.string	"UCLASS_MISC"
.LASF31:
	.string	"sector_count"
.LASF406:
	.string	"c_ftl_nand_sec_pre_page"
.LASF590:
	.string	"mode"
.LASF812:
	.string	"FtlLoadBbt"
.LASF560:
	.string	"pvForm"
.LASF323:
	.string	"padding"
.LASF459:
	.string	"p_swl_mul_table"
.LASF628:
	.string	"src_ppa"
.LASF682:
	.string	"detected_active_page"
.LASF389:
	.string	"ftl_gc_page_item"
.LASF548:
	.string	"mem_malloc_start"
.LASF210:
	.string	"UCLASS_VIDEO_CRTC"
.LASF58:
	.string	"bi_ethspeed"
.LASF98:
	.string	"image_header_t"
.LASF770:
	.string	"pPrev"
.LASF473:
	.string	"g_totle_vendor_block"
.LASF623:
	.string	"superblock_id"
.LASF594:
	.string	"plane"
.LASF11:
	.string	"phys_addr_t"
.LASF95:
	.string	"ih_type"
.LASF844:
	.string	"sftl_init"
.LASF2:
	.string	"unsigned char"
.LASF612:
	.string	"FtlGcScanTempBlk"
.LASF109:
	.string	"legacy_hdr_os_copy"
.LASF760:
	.string	"vpcTbl"
.LASF176:
	.string	"UCLASS_PANEL_BACKLIGHT"
.LASF339:
	.string	"activeSuperblockId"
.LASF802:
	.string	"ver1"
.LASF280:
	.string	"nand_phy_info"
.LASF759:
	.string	"ftl_free_no_use_map_blk"
.LASF804:
	.string	"P2V_block_in_plane"
.LASF555:
	.string	"str1"
.LASF556:
	.string	"str2"
.LASF718:
	.string	"pMapHeader"
.LASF140:
	.string	"UCLASS_TEST_BUS"
.LASF716:
	.string	"FtlScanSysBlk"
.LASF52:
	.string	"bi_arm_freq"
.LASF695:
	.string	"lookup_ppa_ver"
.LASF752:
	.string	"region_num"
.LASF475:
	.string	"p_l2p_map_buf"
.LASF487:
	.string	"gp_last_act_superblock"
.LASF869:
	.string	"Ftl_log2"
.LASF447:
	.string	"p_sys_spare_buf"
.LASF165:
	.string	"UCLASS_LED"
.LASF551:
	.string	"p_current"
.LASF646:
	.string	"get_new_id"
.LASF253:
	.string	"net_rx_packet_len"
.LASF255:
	.string	"net_null_ethaddr"
.LASF542:
	.string	"g_ect_tbl_power_up_flush"
.LASF596:
	.string	"physical_block"
.LASF32:
	.string	"flash_id"
.LASF837:
	.string	"absolute_sector"
.LASF222:
	.string	"load_addr"
.LASF347:
	.string	"PowerLostTimes"
.LASF500:
	.string	"g_gc_bad_block_temp_tbl"
.LASF884:
	.string	"kfree"
.LASF463:
	.string	"p_blk_mode_table"
.LASF775:
	.string	"List_remove_node"
.LASF291:
	.string	"reserved_blk"
.LASF733:
	.string	"pBuf"
.LASF483:
	.string	"g_active_superblock"
.LASF689:
	.string	"recovery_super_page"
.LASF437:
	.string	"req_sys"
.LASF381:
	.string	"available_pages"
.LASF798:
	.string	"high"
.LASF832:
	.string	"nscts"
.LASF410:
	.string	"c_ftl_nand_reserved_blks"
.LASF700:
	.string	"FtlL2PDataInit"
.LASF230:
	.string	"init"
.LASF215:
	.string	"UCLASS_CHARGE_DISPLAY"
.LASF572:
	.string	"check"
.LASF145:
	.string	"UCLASS_USB_EMUL"
.LASF796:
	.string	"FtlFreeSysBlkQueueInit"
.LASF677:
	.string	"FtlRecoverySuperblock"
.LASF396:
	.string	"c_ftl_nand_planes_per_die"
.LASF405:
	.string	"c_ftl_nand_page_pre_super_blk"
.LASF292:
	.string	"ecc_bits"
.LASF293:
	.string	"nand_ops"
.LASF601:
	.string	"tmp_blk"
.LASF522:
	.string	"g_gc_head_data_block"
.LASF827:
	.string	"FtlWrite"
.LASF182:
	.string	"UCLASS_PINCTRL"
.LASF830:
	.string	"num_lpa"
.LASF866:
	.string	"blkNum"
.LASF364:
	.string	"SlcPartLbaEndSector"
.LASF84:
	.string	"fdt32_t"
.LASF468:
	.string	"g_totle_map_block"
.LASF375:
	.string	"value"
.LASF211:
	.string	"UCLASS_WDT"
.LASF101:
	.string	"image_len"
.LASF441:
	.string	"req_gc"
.LASF853:
	.string	"is_sys_blk"
.LASF42:
	.string	"memory"
.LASF820:
	.string	"bitmap"
.LASF319:
	.string	"ftl_ect_tbl_info"
.LASF205:
	.string	"UCLASS_USB_DEV_GENERIC"
.LASF212:
	.string	"UCLASS_FG"
.LASF755:
	.string	"lastMapBlk"
.LASF370:
	.string	"totle_write_sector"
.LASF521:
	.string	"g_ftl_nand_free_count"
.LASF626:
	.string	"p_gc_page"
.LASF20:
	.string	"errno"
.LASF531:
	.string	"gNandPhyInfo"
.LASF860:
	.string	"ven_blk"
.LASF30:
	.string	"size"
.LASF244:
	.string	"net_hostname"
.LASF772:
	.string	"List_pop_head_node"
.LASF308:
	.string	"BlkNum"
.LASF849:
	.string	"sys_bad_block_cnt"
.LASF598:
	.string	"p_dataHeader"
.LASF780:
	.string	"tmp_id"
.LASF602:
	.string	"FtlReadRefresh"
.LASF645:
	.string	"free_blk_index"
.LASF819:
	.string	"FtlBbt2Bitmap"
.LASF662:
	.string	"ftl_check_vpc"
.LASF108:
	.string	"legacy_hdr_os"
.LASF100:
	.string	"image_start"
.LASF579:
	.string	"page_index"
.LASF18:
	.string	"uint8_t"
.LASF55:
	.string	"bi_bootflags"
.LASF486:
	.string	"g_gc_superblock"
.LASF303:
	.string	"ftl_sys_info"
.LASF87:
	.string	"ih_hcrc"
.LASF377:
	.string	"front"
.LASF175:
	.string	"UCLASS_PANEL"
.LASF471:
	.string	"p_vendor_block_ver_table"
.LASF204:
	.string	"UCLASS_USB"
.LASF516:
	.string	"g_totle_slc_erase_count"
.LASF460:
	.string	"g_totle_swl_count"
.LASF139:
	.string	"UCLASS_TEST_FDT"
.LASF294:
	.string	"get_bad_blk_list"
.LASF343:
	.string	"gcTempSuperblockId"
.LASF238:
	.string	"eth_current"
.LASF766:
	.string	"node_valid_page_count"
.LASF53:
	.string	"bi_dsp_freq"
.LASF5:
	.string	"uchar"
.LASF668:
	.string	"pages"
.LASF89:
	.string	"ih_size"
.LASF569:
	.string	"addr"
.LASF142:
	.string	"UCLASS_SPI_EMUL"
.LASF862:
	.string	"FtlMemInit"
.LASF817:
	.string	"write_count"
.LASF663:
	.string	"prev_ppa"
.LASF588:
	.string	"FlashTestBlk"
.LASF179:
	.string	"UCLASS_PCI_GENERIC"
.LASF50:
	.string	"bi_sramstart"
.LASF66:
	.string	"FIQ_STACK_START"
.LASF871:
	.string	"rknand_proc_ftlread"
.LASF228:
	.string	"enetaddr"
.LASF181:
	.string	"UCLASS_PINCONFIG"
.LASF741:
	.string	"l2p_region_id"
.LASF553:
	.string	"check_buf"
.LASF190:
	.string	"UCLASS_RESET"
.LASF137:
	.string	"UCLASS_DEMO"
.LASF44:
	.string	"bd_info"
.LASF275:
	.string	"nand_req"
.LASF356:
	.string	"slc_erase_count"
.LASF60:
	.string	"bi_busfreq"
.LASF769:
	.string	"prev_multiplier_value"
.LASF496:
	.string	"g_gc_next_blk"
.LASF515:
	.string	"g_min_erase_count"
.LASF149:
	.string	"UCLASS_BLK"
.LASF545:
	.string	"gc_discard_updated"
.LASF737:
	.string	"FtlVendorPartWrite"
.LASF621:
	.string	"FtlGcFreeTempBlock"
.LASF248:
	.string	"net_ip"
.LASF229:
	.string	"iobase"
.LASF657:
	.string	"GetFreeBlockMinEraseCount"
.LASF788:
	.string	"remalloc"
.LASF336:
	.string	"activeFlashMode"
.LASF92:
	.string	"ih_dcrc"
.LASF35:
	.string	"flash_info_t"
.LASF655:
	.string	"GetFreeBlockMaxEraseCount"
.LASF711:
	.string	"sblk"
.LASF754:
	.string	"ftl_map_blk_gc"
.LASF876:
	.string	"printf"
.LASF59:
	.string	"bi_intfreq"
.LASF223:
	.string	"save_addr"
.LASF537:
	.string	"TotleReadBufferCount1"
.LASF566:
	.string	"request"
.LASF330:
	.string	"regionId"
.LASF166:
	.string	"UCLASS_LPC"
.LASF285:
	.string	"blk_per_die"
.LASF352:
	.string	"gc_page_count"
.LASF49:
	.string	"bi_flashoffset"
.LASF540:
	.string	"TotleReadBufferMatchCount"
.LASF438:
	.string	"req_read"
.LASF751:
	.string	"Ftl_write_map_blk_to_last_page"
.LASF465:
	.string	"p_map_block_valid_page_count"
.LASF167:
	.string	"UCLASS_MAILBOX"
.LASF792:
	.string	"FtlFreeSysBlkQueueIn"
.LASF366:
	.string	"readErrorCount"
.LASF587:
	.string	"sftl_gc"
.LASF795:
	.string	"FtlFreeSysBlkQueueEmpty"
.LASF762:
	.string	"load_l2p_region"
.LASF639:
	.string	"p_superblock"
.LASF301:
	.string	"fBbtBlk"
.LASF77:
	.string	"off_mem_rsvmap"
.LASF444:
	.string	"p_sys_data_buf"
.LASF883:
	.string	"l2p_addr_tran"
.LASF164:
	.string	"UCLASS_KEYBOARD"
.LASF287:
	.string	"page_per_slc_blk"
.LASF398:
	.string	"c_ftl_nand_blks_per_die_shift"
.LASF738:
	.string	"log2phys"
.LASF477:
	.string	"p_data_block_list_table"
.LASF171:
	.string	"UCLASS_MOD_EXP"
.LASF644:
	.string	"num_bad_block"
.LASF85:
	.string	"image_header"
.LASF701:
	.string	"FtlLoadVonderInfo"
.LASF613:
	.string	"pSuperblock"
.LASF534:
	.string	"ftl_temp_buf"
.LASF384:
	.string	"flash_mode"
.LASF513:
	.string	"g_totle_mlc_erase_count"
.LASF79:
	.string	"last_comp_version"
.LASF415:
	.string	"c_ftl_nand_map_blks_per_plane"
.LASF809:
	.string	"re_try_next_blk"
.LASF56:
	.string	"bi_ip_addr"
.LASF578:
	.string	"block_index"
.LASF36:
	.string	"flash_info"
.LASF495:
	.string	"g_gc_cur_blk_max_valid_pages"
.LASF16:
	.string	"ushort"
.LASF763:
	.string	"phyAddr"
.LASF73:
	.string	"magic"
.LASF875:
	.string	"memset"
.LASF242:
	.string	"net_dns_server"
.LASF561:
	.string	"ftl_memset"
.LASF829:
	.string	"end_lpa"
.LASF882:
	.string	"/home/ldq/rk-linux/u-boot-debug"
.LASF735:
	.string	"result"
.LASF625:
	.string	"scan_page_num"
.LASF267:
	.string	"NETLOOP_SUCCESS"
.LASF27:
	.string	"name"
.LASF511:
	.string	"g_totle_cache_write_count"
.LASF767:
	.string	"node_multiplier_value"
.LASF758:
	.string	"blk_index"
.LASF69:
	.string	"_datarellocal_start_ofs"
.LASF288:
	.string	"sec_per_page"
.LASF409:
	.string	"c_ftl_nand_byte_pre_oob"
.LASF121:
	.string	"fit_hdr_setup"
.LASF150:
	.string	"UCLASS_CLK"
.LASF686:
	.string	"detected_error_page"
.LASF129:
	.string	"initrd_end"
.LASF619:
	.string	"read_super_page"
.LASF219:
	.string	"monitor_flash_len"
.LASF620:
	.string	"FtlGcPageVarInit"
.LASF821:
	.string	"FtlBbtInfoPrint"
.LASF529:
	.string	"c_mlc_erase_count_value"
.LASF550:
	.string	"mem_malloc_brk"
.LASF482:
	.string	"g_num_data_superblocks"
.LASF753:
	.string	"blkTbl"
.LASF348:
	.string	"mlc_erase_count"
.LASF12:
	.string	"phys_size_t"
.LASF715:
	.string	"FtlLoadEctTbl"
.LASF62:
	.string	"bi_boot_params"
.LASF214:
	.string	"UCLASS_RC"
.LASF51:
	.string	"bi_sramsize"
.LASF879:
	.string	"sprintf"
.LASF607:
	.string	"FtlGcMarkBadPhyBlk"
.LASF641:
	.string	"allocate_new_data_superblock"
.LASF13:
	.string	"sizetype"
.LASF57:
	.string	"bi_enetaddr"
.LASF252:
	.string	"net_rx_packet"
.LASF350:
	.string	"GlobalSysVersion"
.LASF329:
	.string	"ftl_map_blk_header"
.LASF599:
	.string	"gc_next_superblock"
.LASF811:
	.string	"blkAddr"
.LASF193:
	.string	"UCLASS_SCSI"
.LASF0:
	.string	"short unsigned int"
.LASF4:
	.string	"signed char"
.LASF250:
	.string	"net_tx_packet"
.LASF696:
	.string	"current_ppa_ver"
.LASF784:
	.string	"tmp_multiplier_value"
.LASF565:
	.string	"FlashEraseBlocks"
.LASF33:
	.string	"start"
.LASF828:
	.string	"start_lpa"
.LASF552:
	.string	"current"
.LASF218:
	.string	"LOGF_MAX_CATEGORIES"
.LASF517:
	.string	"g_totle_sys_slc_erase_count"
.LASF300:
	.string	"prev_id"
.LASF276:
	.string	"status"
.LASF103:
	.string	"comp"
.LASF325:
	.string	"count"
.LASF146:
	.string	"UCLASS_SIMPLE_BUS"
.LASF538:
	.string	"TotleReadBufferCount2"
.LASF539:
	.string	"TotleReadBufferCount3"
.LASF454:
	.string	"c_gc_page_buf_num"
.LASF719:
	.string	"FtlVpcTblFlush"
.LASF189:
	.string	"UCLASS_REMOTEPROC"
.LASF742:
	.string	"lpn_index"
.LASF118:
	.string	"fit_hdr_fdt"
.LASF631:
	.string	"FtlGcBufAlloc"
.LASF568:
	.string	"num_req"
.LASF778:
	.string	"node_erase_count"
.LASF254:
	.string	"net_bcast_ethaddr"
.LASF736:
	.string	"ppn_index"
.LASF794:
	.string	"FtlFreeSysBlkQueueFull"
.LASF133:
	.string	"state"
.LASF48:
	.string	"bi_flashsize"
.LASF746:
	.string	"target_region"
.LASF19:
	.string	"__be32"
.LASF131:
	.string	"cmdline_end"
.LASF418:
	.string	"c_ftl_vendor_part_size"
.LASF251:
	.string	"net_rx_packets"
.LASF825:
	.string	"sftl_read"
.LASF451:
	.string	"p_gc_spare_buf"
.LASF151:
	.string	"UCLASS_CPU"
.LASF466:
	.string	"p_map_block_ver_table"
.LASF455:
	.string	"g_gc_num_req"
.LASF448:
	.string	"p_io_data_buf_0"
.LASF449:
	.string	"p_io_data_buf_1"
.LASF68:
	.string	"_datarelrolocal_start_ofs"
.LASF683:
	.string	"mlc_detected_active_page"
.LASF852:
	.string	"FtlLowFormatEraseBlock"
.LASF317:
	.string	"region_id"
.LASF326:
	.string	"sysBlksPerPlane"
.LASF815:
	.string	"FtlBbtMemInit"
.LASF309:
	.string	"maxBlkNum"
.LASF395:
	.string	"c_ftl_nand_die_num"
.LASF286:
	.string	"page_per_blk"
.LASF721:
	.string	"prog_error_count"
.LASF372:
	.string	"progErrorCount"
.LASF259:
	.string	"net_boot_file_name"
.LASF494:
	.string	"g_gc_cur_blk_valid_pages"
.LASF233:
	.string	"halt"
.LASF653:
	.string	"maxFreeBlockEraseCount"
.LASF86:
	.string	"ih_magic"
.LASF581:
	.string	"block_in_die"
.LASF456:
	.string	"gp_ect_tbl_info"
.LASF654:
	.string	"minDataBlockEraseCount"
.LASF17:
	.string	"ulong"
.LASF41:
	.string	"region"
.LASF315:
	.string	"dump_write_en"
.LASF8:
	.string	"__u32"
.LASF249:
	.string	"net_server_ip"
.LASF785:
	.string	"INSERT_DATA_LIST"
.LASF206:
	.string	"UCLASS_USB_HUB"
.LASF824:
	.string	"sftl_write"
.LASF443:
	.string	"p_plane_order_table"
.LASF781:
	.string	"insert_data_list"
.LASF70:
	.string	"_datarelro_start_ofs"
.LASF618:
	.string	"ReInit"
.LASF172:
	.string	"UCLASS_MTD"
.LASF134:
	.string	"bootm_headers_t"
.LASF729:
	.string	"ec_mod_count"
.LASF564:
	.string	"spare"
.LASF526:
	.string	"g_recovery_page_num"
.LASF15:
	.string	"long int"
.LASF667:
	.string	"req_temp"
.LASF141:
	.string	"UCLASS_TEST_PROBE"
.LASF881:
	.string	"drivers/rkflash/rksftl/rk_sftl.c"
.LASF659:
	.string	"FtlSysBlkInit"
.LASF523:
	.string	"g_gc_head_data_block_count"
.LASF297:
	.string	"read_page"
.LASF177:
	.string	"UCLASS_PCH"
.LASF178:
	.string	"UCLASS_PCI"
.LASF154:
	.string	"UCLASS_DMA"
.LASF426:
	.string	"g_GlobalSysVersion"
.LASF510:
	.string	"g_tmp_data_superblock_id"
.LASF870:
	.string	"limit"
.LASF660:
	.string	"ftl_scan_all_data"
.LASF331:
	.string	"ftl_sys_blk_header"
.LASF393:
	.string	"flag"
.LASF469:
	.string	"p_vendor_block_table"
.LASF679:
	.string	"saved_active_plane"
.LASF747:
	.string	"hit_count"
.LASF714:
	.string	"FtlGcReFreshBadBlk"
.LASF380:
	.string	"current_page"
.LASF201:
	.string	"UCLASS_THERMAL"
.LASF813:
	.string	"FtlBbtCalcTotleCnt"
.LASF786:
	.string	"INSERT_FREE_LIST"
.LASF562:
	.string	"FlashGetBadBlockList"
.LASF694:
	.string	"prev_ppa_ver"
.LASF246:
	.string	"net_ethaddr"
.LASF225:
	.string	"in_addr"
.LASF843:
	.string	"FtlSysFlush"
.LASF99:
	.string	"image_info"
.LASF88:
	.string	"ih_time"
.LASF609:
	.string	"FtlGcRefreshBlock"
.LASF334:
	.string	"ftl_sys_save_info"
.LASF771:
	.string	"List_get_gc_head_node"
.LASF399:
	.string	"c_ftl_nand_planes_num"
.LASF807:
	.string	"FtlMakeBbt"
.LASF37:
	.string	"long double"
.LASF480:
	.string	"p_data_block_list_tail"
.LASF492:
	.string	"g_gc_blk_num"
.LASF81:
	.string	"size_dt_strings"
.LASF271:
	.string	"uint16"
.LASF605:
	.string	"FtlGcFreeBadSuperBlk"
.LASF106:
	.string	"image_info_t"
.LASF703:
	.string	"pMapBlockInfo"
.LASF617:
	.string	"error_phy_page"
.LASF3:
	.string	"long unsigned int"
.LASF414:
	.string	"c_ftl_nand_vendor_region_num"
.LASF158:
	.string	"UCLASS_I2C"
.LASF143:
	.string	"UCLASS_I2C_EMUL"
.LASF28:
	.string	"select_hwpart"
.LASF257:
	.string	"net_native_vlan"
.LASF351:
	.string	"ftl_sys_ext_info"
.LASF247:
	.string	"net_server_ethaddr"
.LASF208:
	.string	"UCLASS_VIDEO_BRIDGE"
.LASF691:
	.string	"function_exit"
.LASF135:
	.string	"images"
.LASF524:
	.string	"g_gc_skip_write_count"
.LASF584:
	.string	"rknand_print_hex"
.LASF635:
	.string	"FtlGcBufInit"
.LASF445:
	.string	"p_sys_data_buf_1"
.LASF14:
	.string	"char"
.LASF310:
	.string	"pBlkTbl"
.LASF113:
	.string	"fit_uname_os"
.LASF499:
	.string	"g_gc_bad_block_gc_index"
.LASF692:
	.string	"last_page_version"
.LASF800:
	.string	"pagePreBlk"
.LASF281:
	.string	"nand_type"
.LASF112:
	.string	"fit_hdr_os"
.LASF283:
	.string	"plane_per_die"
.LASF489:
	.string	"g_sys_ext_data"
.LASF272:
	.string	"uint32"
.LASF563:
	.string	"table"
.LASF299:
	.string	"page"
.LASF642:
	.string	"allocate_data_superblock"
.LASF316:
	.string	"ftl_l2p_ram_map_info"
.LASF102:
	.string	"load"
.LASF264:
	.string	"net_loop_state"
.LASF433:
	.string	"gSysInfo"
.LASF629:
	.string	"prev_superblock_id"
.LASF196:
	.string	"UCLASS_SPMI"
.LASF756:
	.string	"minValidPageIndex"
.LASF840:
	.string	"last_lpa_nscts"
.LASF194:
	.string	"UCLASS_SERIAL"
.LASF709:
	.string	"FtlLoadSysInfo"
.LASF440:
	.string	"req_erase"
.LASF320:
	.string	"hash"
.LASF544:
	.string	"check_vpc_table"
.LASF180:
	.string	"UCLASS_PHY"
.LASF54:
	.string	"bi_ddr_freq"
.LASF857:
	.string	"test_mode"
.LASF826:
	.string	"FtlDiscard"
.LASF670:
	.string	"FtlGcPageRecovery"
.LASF105:
	.string	"arch"
.LASF509:
	.string	"g_totle_read_page_count"
.LASF710:
	.string	"ftl_get_blk_mode"
.LASF740:
	.string	"ram_region_id"
.LASF435:
	.string	"gL2pMapInfo"
.LASF322:
	.string	"lastEc"
.LASF841:
	.string	"sector"
.LASF557:
	.string	"ftl_memcmp"
.LASF467:
	.string	"p_map_region_ppn_table"
.LASF120:
	.string	"fit_noffset_fdt"
.LASF865:
	.string	"FtlSysBlkNumInit"
.LASF671:
	.string	"Ftl_save_ext_data"
.LASF116:
	.string	"fit_uname_rd"
.LASF648:
	.string	"GetSwlReplaceBlock"
.LASF359:
	.string	"max_erase_count"
.LASF474:
	.string	"p_l2p_ram_map"
.LASF633:
	.string	"req_num"
.LASF115:
	.string	"fit_hdr_rd"
.LASF268:
	.string	"NETLOOP_FAIL"
.LASF822:
	.string	"FtlBbmIsBadBlock"
.LASF666:
	.string	"FtlSuperblockPowerLostFix"
.LASF157:
	.string	"UCLASS_FIRMWARE"
.LASF123:
	.string	"fit_noffset_setup"
.LASF401:
	.string	"c_ftl_nand_ext_blk_pre_plane"
.LASF549:
	.string	"mem_malloc_end"
.LASF450:
	.string	"p_io_spare_buf"
.LASF185:
	.string	"UCLASS_POWER_DOMAIN"
.LASF519:
	.string	"g_in_gc_progress"
.LASF168:
	.string	"UCLASS_MASS_STORAGE"
.LASF29:
	.string	"block_drvr"
.LASF173:
	.string	"UCLASS_NORTHBRIDGE"
.LASF422:
	.string	"c_ftl_nand_data_blks_per_plane"
.LASF616:
	.string	"page_count"
.LASF298:
	.string	"ftl_bbt_info"
.LASF160:
	.string	"UCLASS_I2C_GENERIC"
.LASF231:
	.string	"send"
.LASF530:
	.string	"g_power_lost_recovery_flag"
.LASF591:
	.string	"numPages"
.LASF446:
	.string	"p_vendor_data_buf"
.LASF354:
	.string	"read_page_count"
.LASF234:
	.string	"write_hwaddr"
.LASF725:
	.string	"FtlMapBlkWriteDump_data"
.LASF833:
	.string	"FtlCacheWriteBack"
.LASF699:
	.string	"FtlLoadMapInfo"
.LASF806:
	.string	"V2P_block"
.LASF720:
	.string	"pSysHeader"
.LASF672:
	.string	"SupperBlkListInit"
.LASF706:
	.string	"ppnTbl"
.LASF845:
	.string	"pNand"
.LASF558:
	.string	"ftl_memcpy"
.LASF346:
	.string	"PowerOnTimes"
.LASF504:
	.string	"g_totle_gc_page_count"
.LASF24:
	.string	"_binary_u_boot_bin_start"
.LASF673:
	.string	"num_data_node"
.LASF400:
	.string	"c_ftl_nand_blk_pre_plane"
.LASF64:
	.string	"bd_t"
.LASF705:
	.string	"lastWritePage"
.LASF91:
	.string	"ih_ep"
.LASF45:
	.string	"bi_memstart"
.LASF119:
	.string	"fit_uname_fdt"
.LASF187:
	.string	"UCLASS_RAM"
.LASF674:
	.string	"num_free_node"
.LASF379:
	.string	"ftl_superblock_info"
.LASF126:
	.string	"ft_addr"
.LASF357:
	.string	"sys_slc_erase_count"
.LASF512:
	.string	"g_totle_l2p_write_count"
.LASF220:
	.string	"__dtb_dt_begin"
.LASF217:
	.string	"UCLASS_INVALID"
.LASF593:
	.string	"gc_blk"
.LASF277:
	.string	"page_addr"
.LASF863:
	.string	"mem_size"
.LASF856:
	.string	"test_page_step"
.LASF688:
	.string	"read_super_page_end"
.LASF368:
	.string	"refresh_enable_mode"
.LASF846:
	.string	"load_bbt"
.LASF859:
	.string	"IsBlkInVendorPart"
.LASF402:
	.string	"c_ftl_nand_bbm_buf_size"
.LASF782:
	.string	"node_data_count"
.LASF582:
	.string	"width"
.LASF39:
	.string	"base"
.LASF885:
	.string	"sftl_get_density"
.LASF838:
	.string	"first_lpa_sctidx"
.LASF589:
	.string	"rk_ftl_garbage_collect"
.LASF328:
	.string	"lastPpa"
.LASF111:
	.string	"fit_uname_cfg"
.LASF344:
	.string	"gcTempPageOffset"
.LASF636:
	.string	"decrement_vpc_count"
.LASF386:
	.string	"dump_writed"
.LASF748:
	.string	"flush_l2p_region"
.LASF130:
	.string	"cmdline_start"
.LASF535:
	.string	"DeviceCapacity"
.LASF355:
	.string	"l2p_write_count"
.LASF547:
	.string	"gc_ink_free_return_value"
.LASF358:
	.string	"discard_page_count"
.LASF155:
	.string	"UCLASS_ETH"
.LASF221:
	.string	"__dtb_dt_spl_begin"
.LASF10:
	.string	"long long unsigned int"
.LASF274:
	.string	"int16"
.LASF847:
	.string	"ftl_low_format"
.LASF734:
	.string	"offset"
.LASF503:
	.string	"g_gc_blk_index"
.LASF439:
	.string	"req_prgm"
.LASF436:
	.string	"gVendorBlkInfo"
.LASF676:
	.string	"FtlPowerLostRecovery"
.LASF461:
	.string	"p_valid_page_count_table"
.LASF702:
	.string	"FtlMapTblRecovery"
.LASF156:
	.string	"UCLASS_GPIO"
.LASF868:
	.string	"debug_flag"
.LASF497:
	.string	"g_gc_next_blk_1"
.LASF76:
	.string	"off_dt_strings"
.LASF376:
	.string	"sys_blk_queue"
.LASF647:
	.string	"free_data_superblock"
.LASF858:
	.string	"re_test_next_page"
.LASF61:
	.string	"bi_arch_number"
.LASF749:
	.string	"FtlMapWritePage"
.LASF783:
	.string	"tmp_data_count"
.LASF26:
	.string	"ide_bus_offset"
.LASF739:
	.string	"action"
.LASF408:
	.string	"c_ftl_nand_byte_pre_page"
.LASF216:
	.string	"UCLASS_COUNT"
.LASF174:
	.string	"UCLASS_NVME"
.LASF643:
	.string	"new_id"
.LASF345:
	.string	"cache_write_count"
.LASF640:
	.string	"new_ppa"
.LASF258:
	.string	"net_restart_wrap"
.LASF371:
	.string	"totle_read_sector"
.LASF341:
	.string	"bufferSuperblockId"
.LASF273:
	.string	"int32"
.LASF369:
	.string	"refresh_start_lpa"
.LASF80:
	.string	"boot_cpuid_phys"
.LASF304:
	.string	"maxLogicBlk"
.LASF321:
	.string	"totleEc"
.LASF38:
	.string	"lmb_property"
.LASF457:
	.string	"g_ect_tbl_info_size"
.LASF338:
	.string	"gcTempFlashMode"
.LASF431:
	.string	"g_MaxLbn"
.LASF533:
	.string	"g_nand_ops"
.LASF583:
	.string	"ftl_malloc"
.LASF839:
	.string	"first_lpa_nscts"
.LASF183:
	.string	"UCLASS_PMIC"
.LASF318:
	.string	"L2PMap"
.LASF765:
	.string	"prev_node_id"
.LASF453:
	.string	"gp_gc_page_buf_info"
.LASF508:
	.string	"g_totle_discard_page_count"
.LASF656:
	.string	"max_ec"
.LASF536:
	.string	"gFtlInitStatus"
.LASF9:
	.string	"long long int"
.LASF458:
	.string	"p_erase_count_table"
.LASF823:
	.string	"FtlBbmMapBadBlock"
.LASF427:
	.string	"g_GlobalDataVersion"
.LASF717:
	.string	"block_in_plane"
.LASF128:
	.string	"initrd_start"
.LASF428:
	.string	"g_MaxLbaSector"
.LASF382:
	.string	"current_plane"
.LASF878:
	.string	"free"
.LASF383:
	.string	"num_planes"
.LASF799:
	.string	"spareBuf"
.LASF730:
	.string	"FtlVendorPartRead"
.LASF723:
	.string	"FtlWriteDump_data"
.LASF197:
	.string	"UCLASS_SPI_FLASH"
.LASF202:
	.string	"UCLASS_TIMER"
.LASF797:
	.string	"FtlGetLastWrittenPage"
.LASF661:
	.string	"pDataHeader"
.LASF541:
	.string	"power_up_flag"
.LASF365:
	.string	"inkDie_write_and_check_en"
.LASF413:
	.string	"c_ftl_nand_l2pmap_ram_region_num"
.LASF842:
	.string	"sftl_deinit"
.LASF814:
	.string	"totle_count"
.LASF282:
	.string	"die_num"
.LASF750:
	.string	"update_map_block"
.LASF307:
	.string	"maxRegion"
.LASF680:
	.string	"next_free_active_plane"
.LASF490:
	.string	"p_gc_page_info"
.LASF256:
	.string	"net_our_vlan"
.LASF361:
	.string	"totle_power_on_run_times"
.LASF93:
	.string	"ih_os"
.LASF525:
	.string	"g_cur_erase_blk"
.LASF184:
	.string	"UCLASS_PWM"
.LASF634:
	.string	"FtlGcBufFree"
.LASF774:
	.string	"List_pop_index_node"
.LASF690:
	.string	"scan_completed"
.LASF637:
	.string	"update_vpc_list"
.LASF170:
	.string	"UCLASS_MMC"
.LASF464:
	.string	"p_map_block_table"
.LASF543:
	.string	"FtlUpdateVaildLpnCount"
.LASF332:
	.string	"res32_0"
.LASF333:
	.string	"res32_1"
.LASF726:
	.string	"FtlUpdateVaildLpn"
.LASF390:
	.string	"scr_ppa"
.LASF162:
	.string	"UCLASS_IDE"
.LASF224:
	.string	"save_size"
.LASF78:
	.string	"version"
.LASF652:
	.string	"pNode"
.LASF638:
	.string	"get_new_active_ppa"
.LASF877:
	.string	"kmalloc"
.LASF25:
	.string	"_binary_u_boot_bin_end"
.LASF597:
	.string	"max_gc_page_num"
.LASF1:
	.string	"unsigned int"
.LASF712:
	.string	"FtlSlcSuperblockCheck"
.LASF514:
	.string	"g_totle_avg_erase_count"
.LASF835:
	.string	"flashType"
.LASF791:
	.string	"FtlFreeSysBLkSort"
.LASF779:
	.string	"tmp_erase_count"
.LASF83:
	.string	"working_fdt"
.LASF861:
	.string	"FtlVariablesInit"
.LASF392:
	.string	"ftl_gc_page_buffer"
.LASF239:
	.string	"push_packet"
.LASF708:
	.string	"pMapBlkHeader"
.LASF82:
	.string	"size_dt_struct"
.LASF472:
	.string	"p_vendor_region_ppn_table"
.LASF675:
	.string	"make_superblock"
.LASF97:
	.string	"ih_name"
.LASF186:
	.string	"UCLASS_PWRSEQ"
.LASF337:
	.string	"bufferFlashMode"
.LASF7:
	.string	"short int"
.LASF836:
	.string	"FtlRead"
.LASF74:
	.string	"totalsize"
.LASF757:
	.string	"ftl_map_blk_alloc_new_blk"
.LASF385:
	.string	"check_en"
.LASF442:
	.string	"req_gc_dst"
.LASF374:
	.string	"prev"
.LASF423:
	.string	"c_ftl_nand_data_op_blks_per_plane"
.LASF650:
	.string	"min_ec_id"
.LASF388:
	.string	"phyBlk"
.LASF260:
	.string	"net_boot_file_size"
.LASF412:
	.string	"c_ftl_nand_map_region_num"
.LASF665:
	.string	"FtlVpcCheckAndModify"
.LASF127:
	.string	"ft_len"
.LASF188:
	.string	"UCLASS_REGULATOR"
.LASF311:
	.string	"pBlkVerTbl"
.LASF488:
	.string	"g_sys_save_data"
.LASF124:
	.string	"rd_start"
	.hidden	free
