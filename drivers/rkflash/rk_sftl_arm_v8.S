/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2018-07-04
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
	.section	.text.ftl_set_blk_mode.part.7,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.7, %function
ftl_set_blk_mode.part.7:
.LFB356:
	.file 2 "drivers/rkflash/rksftl/sftl_sys.c"
	.loc 2 1346 0
	.cfi_startproc
.LVL10:
	.loc 2 1346 0
	and	w0, w0, 65535
	.loc 2 1349 0
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
.LFE356:
	.size	ftl_set_blk_mode.part.7, .-ftl_set_blk_mode.part.7
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
	.loc 3 159 0
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
	.loc 3 165 0
	.cfi_startproc
.LVL21:
	.loc 3 165 0
	and	w0, w0, 65535
	mov	w1, 24
	cmp	w0, 24
	.loc 3 169 0
	adrp	x2, .LANCHOR4
	csel	w0, w0, w1, cs
.LVL22:
	.loc 3 168 0
	adrp	x1, .LANCHOR2
	and	w0, w0, 65535
.LVL23:
	str	w0, [x1, #:lo12:.LANCHOR2]
	.loc 3 169 0
	adrp	x1, .LANCHOR3
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	mul	w1, w1, w0
	str	w1, [x2, #:lo12:.LANCHOR4]
	.loc 3 170 0
	adrp	x2, .LANCHOR6
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	sub	w0, w2, w0
.LVL24:
	adrp	x2, .LANCHOR5
	strh	w0, [x2, #:lo12:.LANCHOR5]
	.loc 3 171 0
	adrp	x0, .LANCHOR8
	ldr	w0, [x0, #:lo12:.LANCHOR8]
	sub	w1, w0, w1
	adrp	x0, .LANCHOR7
	str	w1, [x0, #:lo12:.LANCHOR7]
	.loc 3 174 0
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
	.loc 3 183 0
	.cfi_startproc
.LVL25:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x5, x0
	.loc 3 190 0
	adrp	x1, .LANCHOR11
	.loc 3 183 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 188 0
	ldrh	w2, [x0]
	adrp	x0, .LANCHOR9
.LVL26:
	.loc 3 189 0
	ldrh	w4, [x5, 2]
	.loc 3 188 0
	strh	w2, [x0, #:lo12:.LANCHOR9]
	.loc 3 189 0
	adrp	x0, .LANCHOR10
	strh	w4, [x0, #:lo12:.LANCHOR10]
	.loc 3 190 0
	ldrh	w0, [x5, 4]
	strh	w0, [x1, #:lo12:.LANCHOR11]
	.loc 3 191 0
	ldrh	w1, [x5, 14]
	cmp	w1, 4
	bne	.L10
	.loc 3 192 0
	ldrh	w1, [x5, 6]
	adrp	x3, .LANCHOR6
	lsr	w1, w1, 1
	strh	w1, [x3, #:lo12:.LANCHOR6]
	.loc 3 193 0
	adrp	x1, .LANCHOR12
	mov	w3, 8
	strh	w3, [x1, #:lo12:.LANCHOR12]
.L10:
	.loc 3 197 0 discriminator 3
	adrp	x3, .LANCHOR13
	add	x3, x3, :lo12:.LANCHOR13
	.loc 3 183 0 discriminator 3
	mov	x1, 0
.L11:
.LVL27:
	.loc 3 197 0 discriminator 3
	strb	w1, [x1, x3]
.LVL28:
	add	x1, x1, 1
.LVL29:
	.loc 3 196 0 discriminator 3
	cmp	x1, 32
	bne	.L11
	.loc 3 198 0
	adrp	x1, .LANCHOR14
	mov	w3, 5
	.loc 3 200 0
	cmp	w2, 1
	.loc 3 198 0
	strh	w3, [x1, #:lo12:.LANCHOR14]
	.loc 3 199 0
	adrp	x3, .LANCHOR15
	strh	wzr, [x3, #:lo12:.LANCHOR15]
	.loc 3 200 0
	bne	.L12
	.loc 3 201 0
	strh	w2, [x1, #:lo12:.LANCHOR14]
.L12:
	.loc 3 202 0
	adrp	x1, .LANCHOR16
	mov	w2, 640
	.loc 3 204 0
	mul	w4, w4, w0
	.loc 3 202 0
	strh	w2, [x1, #:lo12:.LANCHOR16]
	.loc 3 204 0
	adrp	x1, .LANCHOR3
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR3]
	.loc 3 205 0
	adrp	x1, .LANCHOR6
	ldrh	w3, [x1, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR17
	mul	w0, w0, w3
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR17]
	.loc 3 206 0
	bl	Ftl_log2
.LVL30:
	.loc 3 207 0
	ldrh	w7, [x5, 12]
	.loc 3 206 0
	adrp	x1, .LANCHOR18
	.loc 3 207 0
	adrp	x8, .LANCHOR19
	.loc 3 206 0
	strh	w0, [x1, #:lo12:.LANCHOR18]
	.loc 3 208 0
	adrp	x0, .LANCHOR20
	.loc 3 209 0
	mul	w1, w4, w7
	.loc 3 207 0
	strh	w7, [x8, #:lo12:.LANCHOR19]
	.loc 3 208 0
	strh	w7, [x0, #:lo12:.LANCHOR20]
	.loc 3 209 0
	adrp	x0, .LANCHOR21
	strh	w1, [x0, #:lo12:.LANCHOR21]
	.loc 3 210 0
	adrp	x0, .LANCHOR12
	ldrh	w6, [x0, #:lo12:.LANCHOR12]
	mov	w0, w6
	bl	Ftl_log2
.LVL31:
	and	w1, w0, 65535
	adrp	x2, .LANCHOR22
	.loc 3 212 0
	adrp	x10, .LANCHOR23
	.loc 3 214 0
	ldrh	w5, [x5, 20]
.LVL32:
	.loc 3 210 0
	strh	w0, [x2, #:lo12:.LANCHOR22]
	.loc 3 212 0
	ubfiz	w0, w6, 9, 7
	strh	w0, [x10, #:lo12:.LANCHOR23]
	.loc 3 213 0
	adrp	x10, .LANCHOR24
	ubfx	w0, w0, 8, 8
	strh	w0, [x10, #:lo12:.LANCHOR24]
	.loc 3 214 0
	adrp	x0, .LANCHOR25
	strh	w5, [x0, #:lo12:.LANCHOR25]
	.loc 3 216 0
	mul	w0, w4, w3
	adrp	x5, .LANCHOR8
	str	w0, [x5, #:lo12:.LANCHOR8]
	.loc 3 217 0
	adrp	x5, .LANCHOR26
	mul	w0, w0, w6
	.loc 3 218 0
	mul	w6, w6, w7
	.loc 3 217 0
	mul	w0, w0, w7
	mov	x7, x2
	asr	w0, w0, 11
	str	w0, [x5, #:lo12:.LANCHOR26]
	.loc 3 218 0
	mov	w0, 5120
	adrp	x5, .LANCHOR27
	sdiv	w0, w0, w6
	and	w0, w0, 65535
	.loc 3 219 0
	cmp	w0, 4
	bls	.L13
.L19:
	.loc 3 220 0
	strh	w0, [x5, #:lo12:.LANCHOR27]
	.loc 3 221 0
	adrp	x2, .LANCHOR28
	mov	w0, 640
	.loc 3 223 0
	lsl	w3, w3, 6
	.loc 3 221 0
	asr	w0, w0, w1
	add	w0, w0, 2
	.loc 3 223 0
	add	w1, w1, 9
	.loc 3 221 0
	strh	w0, [x2, #:lo12:.LANCHOR28]
	.loc 3 223 0
	adrp	x0, .LANCHOR29
	.loc 3 227 0
	cmp	w4, 1
	.loc 3 223 0
	asr	w3, w3, w1
	.loc 3 224 0
	adrp	x1, .LANCHOR30
	.loc 3 223 0
	strh	w3, [x0, #:lo12:.LANCHOR29]
	and	w3, w3, 65535
	adrp	x6, .LANCHOR2
	.loc 3 224 0
	mul	w0, w3, w4
	.loc 3 226 0
	add	w3, w3, 8
	.loc 3 224 0
	str	w0, [x1, #:lo12:.LANCHOR30]
	.loc 3 226 0
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	.loc 3 227 0
	beq	.L15
.L20:
	.loc 3 228 0
	str	w3, [x6, #:lo12:.LANCHOR2]
	.loc 3 231 0
	ldrh	w0, [x6, #:lo12:.LANCHOR2]
	bl	FtlSysBlkNumInit
.LVL33:
	.loc 3 232 0
	ldr	w1, [x6, #:lo12:.LANCHOR2]
	adrp	x0, .LANCHOR31
	.loc 3 263 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	.loc 3 232 0
	str	w1, [x0, #:lo12:.LANCHOR31]
	.loc 3 234 0
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
	.loc 3 235 0
	adrp	x0, .LANCHOR33
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR33]
	.loc 3 236 0
	adrp	x0, .LANCHOR34
	str	wzr, [x0, #:lo12:.LANCHOR34]
	.loc 3 237 0
	ldrh	w0, [x5, #:lo12:.LANCHOR27]
	add	w0, w0, 3
	strh	w0, [x5, #:lo12:.LANCHOR27]
	.loc 3 238 0
	ldr	w0, [x4, #:lo12:.LANCHOR30]
	add	w0, w0, 3
	str	w0, [x4, #:lo12:.LANCHOR30]
	.loc 3 263 0
	mov	w0, 0
	ret
.L13:
	.cfi_restore_state
	.loc 3 220 0
	mov	w0, 4
	b	.L19
.L15:
	.loc 3 228 0
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
.LBB166:
.LBB167:
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
.LBE167:
.LBE166:
	.loc 3 524 0
	mov	w0, 0
.LVL37:
	ret
.LVL38:
.L24:
	add	x1, x1, 1
.LVL39:
.LBB169:
.LBB168:
	.loc 3 519 0
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L23
	.loc 3 520 0
	mov	w0, 1
.LBE168:
.LBE169:
	.loc 3 525 0
	ret
	.cfi_endproc
.LFE208:
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.sftl_get_density,"ax",@progbits
	.align	2
	.global	sftl_get_density
	.type	sftl_get_density, %function
sftl_get_density:
.LFB221:
	.loc 3 1214 0
	.cfi_startproc
	.loc 3 1216 0
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
	blt	.L42
	.loc 4 169 0
	mov	w0, w5
	ret
.L42:
	.loc 4 157 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.L35:
	.loc 4 162 0
	mov	w0, w4
	bl	FtlBbmIsBadBlock
.LVL53:
	cbz	w0, .L34
	.loc 4 164 0
	add	w5, w5, 1
.LVL54:
	and	w5, w5, 65535
.LVL55:
.L34:
	.loc 4 160 0 discriminator 2
	add	w4, w4, 1
.LVL56:
	and	w4, w4, 65535
.LVL57:
	cmp	w4, w6
	blt	.L35
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
	bls	.L47
	.loc 2 36 0
	sub	w1, w0, w1
.LVL70:
	cmp	w1, w2
	cset	w0, ls
.LVL71:
	ret
.LVL72:
.L47:
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
	.loc 2 116 0
	.cfi_startproc
.LVL75:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 2 123 0
	adrp	x2, .LANCHOR38
	.loc 2 125 0
	adrp	x1, .LANCHOR39
	.loc 2 123 0
	add	x0, x2, :lo12:.LANCHOR38
	.loc 2 116 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 125 0
	ldr	x3, [x1, #:lo12:.LANCHOR39]
	adrp	x1, .LANCHOR40
	.loc 2 124 0
	ldrh	w8, [x0, 2]
	mov	x4, x2
	.loc 2 123 0
	ldrh	w7, [x0, 6]
	.loc 2 124 0
	mov	x6, x0
	.loc 2 125 0
	ldr	x10, [x1, #:lo12:.LANCHOR40]
	.loc 2 124 0
	and	x11, x8, 65535
	.loc 2 123 0
	mov	x5, 0
.LVL76:
.L52:
	.loc 2 123 0 is_stmt 0 discriminator 1
	cmp	w7, w5, uxth
	bhi	.L53
	.loc 2 128 0 is_stmt 1
	sub	w10, w7, #1
	.loc 2 139 0
	add	x2, x4, :lo12:.LANCHOR38
	mov	w0, 0
.LVL77:
.L54:
	.loc 2 128 0 discriminator 1
	cmp	w0, w10
	blt	.L59
	.loc 2 144 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL78:
.L53:
	.cfi_restore_state
	.loc 2 124 0 discriminator 3
	add	x0, x11, x5
	add	x0, x6, x0, lsl 1
	ldrh	w0, [x0, 8]
	bl	P2V_block_in_plane
.LVL79:
	.loc 2 125 0 discriminator 3
	ubfiz	x0, x0, 1, 16
.LVL80:
	ldrh	w0, [x10, x0]
	str	w0, [x3, x5, lsl 2]
.LVL81:
	add	x5, x5, 1
.LVL82:
	b	.L52
.LVL83:
.L59:
	.loc 2 130 0
	add	w5, w0, 1
	mov	w1, w0
	and	w5, w5, 65535
.LVL84:
	mov	w4, w5
.LVL85:
.L55:
	.loc 2 130 0 is_stmt 0 discriminator 1
	cmp	w4, w7
	bcc	.L57
	.loc 2 134 0 is_stmt 1
	cmp	w0, w1
	beq	.L58
	.loc 2 136 0
	ubfiz	x4, x0, 2, 16
.LVL86:
	.loc 2 135 0
	ubfiz	x6, x1, 2, 32
	.loc 2 140 0
	add	w0, w8, w0
.LVL87:
	.loc 2 139 0
	add	w1, w1, w8
.LVL88:
	.loc 2 140 0
	add	x0, x2, x0, sxtw 1
	.loc 2 139 0
	add	x1, x2, x1, sxtw 1
	.loc 2 136 0
	ldr	w12, [x3, x4]
	.loc 2 135 0
	ldr	w11, [x3, x6]
.LVL89:
	.loc 2 136 0
	str	w12, [x3, x6]
	.loc 2 137 0
	str	w11, [x3, x4]
	.loc 2 140 0
	ldrh	w6, [x0, 8]
	.loc 2 139 0
	ldrh	w4, [x1, 8]
.LVL90:
	.loc 2 140 0
	strh	w6, [x1, 8]
	.loc 2 141 0
	strh	w4, [x0, 8]
.LVL91:
.L58:
	mov	w0, w5
	b	.L54
.LVL92:
.L57:
	.loc 2 131 0
	ubfiz	x6, x4, 2, 16
	ldr	w11, [x3, w1, uxtw 2]
	ldr	w6, [x3, x6]
	cmp	w11, w6
	csel	w1, w1, w4, ls
.LVL93:
	.loc 2 130 0
	add	w4, w4, 1
.LVL94:
	and	w4, w4, 65535
.LVL95:
	b	.L55
	.cfi_endproc
.LFE241:
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.IsInFreeQueue,"ax",@progbits
	.align	2
	.global	IsInFreeQueue
	.type	IsInFreeQueue, %function
IsInFreeQueue:
.LFB242:
	.loc 2 147 0
	.cfi_startproc
.LVL96:
.LBB170:
.LBB171:
	.loc 2 94 0
	adrp	x1, .LANCHOR38
	add	x1, x1, :lo12:.LANCHOR38
.LBE171:
.LBE170:
	.loc 2 147 0
	and	w0, w0, 65535
.LBB173:
.LBB172:
	.loc 2 94 0
	ldrh	w4, [x1, 6]
.LBE172:
.LBE173:
	.loc 2 152 0
	cmp	w4, 1024
	beq	.L65
	.loc 2 155 0
	ldrh	w5, [x1, 2]
	mov	w3, 0
.L63:
.LVL97:
	.loc 2 154 0 discriminator 1
	cmp	w3, w4
	bcc	.L64
.LVL98:
.L65:
	.loc 2 148 0
	mov	w0, 0
.LVL99:
	ret
.LVL100:
.L64:
	.loc 2 155 0
	add	w2, w3, w5
	ubfiz	x2, x2, 1, 10
	add	x2, x1, x2
	ldrh	w2, [x2, 8]
	cmp	w2, w0
	beq	.L66
	.loc 2 154 0 discriminator 2
	add	w3, w3, 1
.LVL101:
	b	.L63
.L66:
	.loc 2 156 0
	mov	w0, 1
.LVL102:
	.loc 2 162 0
	ret
	.cfi_endproc
.LFE242:
	.size	IsInFreeQueue, .-IsInFreeQueue
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
.LFB243:
	.loc 2 165 0
	.cfi_startproc
.LVL103:
.LBB174:
.LBB175:
	.loc 2 89 0
	adrp	x1, .LANCHOR38
	add	x1, x1, :lo12:.LANCHOR38
	ldrh	w3, [x1, 6]
.LBE175:
.LBE174:
	.loc 2 168 0
	cbz	w3, .L69
.LVL104:
.LBB176:
	.loc 2 170 0
	ldrh	w2, [x1, 2]
	.loc 2 171 0
	sub	w3, w3, #1
	strh	w3, [x1, 6]
	.loc 2 170 0
	add	x0, x1, x2, sxtw 1
	.loc 2 172 0
	add	w2, w2, 1
	and	w2, w2, 1023
	strh	w2, [x1, 2]
	.loc 2 170 0
	ldrh	w0, [x0, 8]
.LVL105:
	ret
.LVL106:
.L69:
.LBE176:
	.loc 2 166 0
	mov	w0, 65535
.LVL107:
	.loc 2 176 0
	ret
	.cfi_endproc
.LFE243:
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.insert_data_list,"ax",@progbits
	.align	2
	.global	insert_data_list
	.type	insert_data_list, %function
insert_data_list:
.LFB246:
	.loc 2 217 0
	.cfi_startproc
.LVL108:
	and	w0, w0, 65535
	.loc 2 225 0
	mov	w11, 65535
	cmp	w0, w11
	beq	.L84
	.loc 2 230 0
	adrp	x1, .LANCHOR41
	mov	w6, 6
	ldr	x4, [x1, #:lo12:.LANCHOR41]
	umull	x13, w0, w6
	.loc 2 231 0
	mov	w1, -1
	.loc 2 230 0
	add	x3, x4, x13
.LVL109:
	.loc 2 231 0
	strh	w1, [x3, 2]
	strh	w1, [x4, x13]
	.loc 2 233 0
	adrp	x1, .LANCHOR42
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR42]
	cbnz	x12, .L72
	.loc 2 234 0
	str	x3, [x1, #:lo12:.LANCHOR42]
.LVL110:
.L84:
	.loc 2 281 0
	mov	w0, 0
.LVL111:
	ret
.LVL112:
.L72:
	.loc 2 217 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 2 238 0
	adrp	x1, .LANCHOR43
	ubfiz	x2, x0, 1, 16
	.loc 2 244 0
	mov	x8, -6148914691236517206
	.loc 2 217 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 238 0
	ldr	x14, [x1, #:lo12:.LANCHOR43]
	.loc 2 244 0
	movk	x8, 0xaaab, lsl 0
	.loc 2 239 0
	ldrh	w1, [x3, 4]
	mov	w7, -1
	.loc 2 247 0
	mov	w10, w7
	.loc 2 239 0
	cmp	w1, 0
	.loc 2 238 0
	ldrh	w5, [x14, x2]
.LVL113:
	.loc 2 239 0
	mul	w5, w5, w1
.LVL114:
	.loc 2 244 0
	sub	x1, x12, x4
.LVL115:
	asr	x1, x1, 1
	.loc 2 239 0
	csel	w5, w5, w7, ne
.LVL116:
	.loc 2 267 0
	mov	w7, w6
	.loc 2 244 0
	mul	x1, x1, x8
	.loc 2 252 0
	adrp	x8, .LANCHOR40
	ldr	x16, [x8, #:lo12:.LANCHOR40]
	.loc 2 244 0
	and	w1, w1, 65535
.LVL117:
	.loc 2 252 0
	add	x8, x16, x2
	mov	x2, x12
.LVL118:
.L79:
	.loc 2 246 0
	ubfiz	x17, x1, 1, 16
	.loc 2 247 0
	ldrh	w30, [x2, 4]
	cmp	w30, 0
	.loc 2 246 0
	ldrh	w6, [x14, x17]
.LVL119:
	.loc 2 247 0
	mul	w6, w6, w30
.LVL120:
	csel	w6, w6, w10, ne
.LVL121:
	.loc 2 251 0
	cmp	w5, w6
	bne	.L75
	.loc 2 252 0
	ldrh	w17, [x16, x17]
.LVL122:
	ldrh	w6, [x8]
.LVL123:
	cmp	w17, w6
	bcc	.L77
.L76:
	.loc 2 270 0
	strh	w1, [x4, x13]
.LVL124:
	.loc 2 273 0
	cmp	x2, x12
	.loc 2 271 0
	ldrh	w1, [x2, 2]
.LVL125:
	strh	w1, [x3, 2]
	.loc 2 273 0
	bne	.L80
	.loc 2 274 0
	strh	w0, [x2, 2]
	.loc 2 275 0
	str	x3, [x15, #:lo12:.LANCHOR42]
	b	.L71
.LVL126:
.L75:
	.loc 2 256 0
	bcc	.L76
.LVL127:
.L77:
	.loc 2 259 0
	ldrh	w6, [x2]
	cmp	w6, w11
	bne	.L78
	.loc 2 260 0
	strh	w1, [x3, 2]
.LVL128:
	.loc 2 261 0
	strh	w0, [x2]
	.loc 2 262 0
	adrp	x0, .LANCHOR44
	str	x3, [x0, #:lo12:.LANCHOR44]
.LVL129:
.L71:
	.loc 2 281 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL130:
.L78:
	.cfi_restore_state
	.loc 2 267 0
	umaddl	x2, w6, w7, x4
.LVL131:
	.loc 2 246 0
	mov	w1, w6
.LVL132:
	b	.L79
.LVL133:
.L80:
	.loc 2 277 0
	ldrh	w1, [x2, 2]
	mov	w3, 6
.LVL134:
	umull	x1, w1, w3
	strh	w0, [x4, x1]
.LVL135:
	.loc 2 278 0
	strh	w0, [x2, 2]
	b	.L71
	.cfi_endproc
.LFE246:
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
.LFB245:
	.loc 2 186 0
	.cfi_startproc
.LVL136:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 187 0
	bl	insert_data_list
.LVL137:
	.loc 2 188 0
	adrp	x1, .LANCHOR45
	ldrh	w0, [x1, #:lo12:.LANCHOR45]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR45]
	.loc 2 189 0
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L86
.LVL138:
	.loc 2 190 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
.LBB179:
.LBB180:
	.loc 2 189 0
	mov	w2, 189
	adrp	x1, .LANCHOR46
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC1
	b	printf
.LVL139:
.L86:
	.cfi_restore_state
.LBE180:
.LBE179:
	.loc 2 190 0
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
	.loc 2 284 0
	.cfi_startproc
.LVL140:
	.loc 2 284 0
	and	w0, w0, 65535
	.loc 2 290 0
	mov	w7, 65535
	cmp	w0, w7
	beq	.L90
	.loc 2 293 0
	adrp	x1, .LANCHOR41
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR41]
	umull	x8, w0, w6
	.loc 2 294 0
	mov	w1, -1
	.loc 2 293 0
	add	x4, x3, x8
.LVL141:
	.loc 2 294 0
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	.loc 2 296 0
	adrp	x1, .LANCHOR47
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR47]
	cbnz	x5, .L91
	.loc 2 297 0
	str	x4, [x1, #:lo12:.LANCHOR47]
.LVL142:
.L90:
	.loc 2 330 0
	mov	w0, 0
.LVL143:
	ret
.LVL144:
.L91:
	.loc 2 301 0
	adrp	x1, .LANCHOR40
	.loc 2 303 0
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	.loc 2 301 0
	ldr	x11, [x1, #:lo12:.LANCHOR40]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
.LVL145:
	.loc 2 303 0
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.LVL146:
.L94:
	.loc 2 306 0
	ubfiz	x10, x1, 1, 16
	.loc 2 307 0
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L92
	.loc 2 310 0
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L93
	.loc 2 311 0
	strh	w1, [x4, 2]
.LVL147:
	.loc 2 312 0
	strh	w0, [x2]
	.loc 2 313 0
	b	.L90
.LVL148:
.L93:
	.loc 2 316 0
	umaddl	x2, w10, w6, x3
.LVL149:
	.loc 2 306 0
	mov	w1, w10
.LVL150:
	b	.L94
.LVL151:
.L92:
	.loc 2 319 0
	ldrh	w6, [x2, 2]
	.loc 2 322 0
	cmp	x2, x5
	.loc 2 319 0
	strh	w6, [x4, 2]
.LVL152:
	.loc 2 320 0
	strh	w1, [x3, x8]
	.loc 2 322 0
	bne	.L95
	.loc 2 323 0
	strh	w0, [x2, 2]
	.loc 2 324 0
	str	x4, [x12, #:lo12:.LANCHOR47]
	b	.L90
.L95:
	.loc 2 326 0
	ldrh	w1, [x2, 2]
.LVL153:
	mov	w4, 6
.LVL154:
	umull	x1, w1, w4
	strh	w0, [x3, x1]
.LVL155:
	.loc 2 327 0
	strh	w0, [x2, 2]
	b	.L90
	.cfi_endproc
.LFE247:
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
.LFB244:
	.loc 2 179 0
	.cfi_startproc
.LVL156:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 180 0
	bl	insert_free_list
.LVL157:
	.loc 2 181 0
	adrp	x1, .LANCHOR48
	ldrh	w0, [x1, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR48]
	.loc 2 182 0
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcs	.L96
.LVL158:
	.loc 2 183 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
.LBB183:
.LBB184:
	.loc 2 182 0
	mov	w2, 182
	adrp	x1, .LANCHOR49
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC1
	b	printf
.LVL159:
.L96:
	.cfi_restore_state
.LBE184:
.LBE183:
	.loc 2 183 0
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
	.loc 2 333 0
	.cfi_startproc
.LVL160:
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
	.loc 2 336 0
	adrp	x20, .LANCHOR41
	.loc 2 333 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	.loc 2 336 0
	mov	w0, 6
.LVL161:
	.loc 2 333 0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	.loc 2 336 0
	ldr	x23, [x20, #:lo12:.LANCHOR41]
	umull	x21, w1, w0
	.loc 2 337 0
	mov	w0, 65535
	.loc 2 336 0
	add	x19, x23, x21
.LVL162:
	.loc 2 337 0
	ldrh	w1, [x19, 2]
.LVL163:
	cmp	w1, w0
	bne	.L100
	.loc 2 337 0 is_stmt 0 discriminator 1
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L100
	.loc 2 337 0 discriminator 2
	adrp	x1, .LANCHOR50
	adrp	x0, .LC1
	mov	w2, 337
	add	x1, x1, :lo12:.LANCHOR50
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL164:
.L100:
	.loc 2 339 0 is_stmt 1
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L101
	.loc 2 340 0
	cmp	w0, w1
	bne	.L102
	.loc 2 341 0
	str	xzr, [x22]
.L103:
	.loc 2 355 0
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	.loc 2 357 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL165:
	ldp	x21, x22, [sp, 32]
.LVL166:
	ldr	x23, [sp, 48]
.LVL167:
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
.LVL168:
.L102:
	.cfi_restore_state
	.loc 2 343 0
	ldr	x1, [x20, #:lo12:.LANCHOR41]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	.loc 2 344 0
	mov	w1, -1
	.loc 2 343 0
	str	x0, [x22]
	.loc 2 344 0
	strh	w1, [x0, 2]
	b	.L103
.L101:
	.loc 2 346 0
	cmp	w0, w1
	mov	w2, 6
	ldrh	w1, [x19, 2]
	bne	.L104
.LVL169:
	.loc 2 347 0
	umull	x1, w1, w2
	.loc 2 348 0
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	mov	w2, -1
	strh	w2, [x0, x1]
	b	.L103
.LVL170:
.L104:
	.loc 2 350 0
	ldr	x3, [x20, #:lo12:.LANCHOR41]
.LVL171:
	.loc 2 351 0
	umaddl	x4, w0, w2, x3
	strh	w1, [x4, 2]
.LVL172:
	.loc 2 352 0
	ldrh	w1, [x19, 2]
	umull	x1, w1, w2
	.loc 2 353 0
	strh	w0, [x3, x1]
	b	.L103
	.cfi_endproc
.LFE248:
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
.LFB249:
	.loc 2 360 0
	.cfi_startproc
.LVL173:
	.loc 2 364 0
	ldr	x2, [x0]
	cbz	x2, .L112
	.loc 2 360 0
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 369 0
	adrp	x3, .LANCHOR41
	and	w1, w1, 65535
	.loc 2 368 0
	mov	w4, 65535
	.loc 2 360 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 369 0
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR41]
.LVL174:
.L108:
	.loc 2 368 0
	cbnz	w1, .L109
.L111:
	.loc 2 372 0
	sub	x19, x2, x19
	mov	x2, -6148914691236517206
.LVL175:
	asr	x19, x19, 1
	movk	x2, 0xaaab, lsl 0
	mul	x19, x19, x2
	and	w19, w19, 65535
.LVL176:
	.loc 2 373 0
	mov	w1, w19
.LVL177:
	bl	List_remove_node
.LVL178:
	.loc 2 375 0
	mov	w0, w19
	.loc 2 376 0
	ldr	x19, [sp, 16]
.LVL179:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL180:
.L109:
	.cfi_restore_state
	.loc 2 368 0 discriminator 1
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L111
	.loc 2 370 0
	sub	w1, w1, #1
.LVL181:
	.loc 2 369 0
	umaddl	x2, w3, w5, x19
.LVL182:
	.loc 2 370 0
	and	w1, w1, 65535
.LVL183:
	b	.L108
.LVL184:
.L112:
	.cfi_def_cfa 31, 0
	.cfi_restore 19
	.cfi_restore 29
	.cfi_restore 30
	.loc 2 365 0
	mov	w0, 65535
.LVL185:
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
	.loc 2 379 0
	.cfi_startproc
.LVL186:
	.loc 2 380 0
	mov	w1, 0
	b	List_pop_index_node
.LVL187:
	.cfi_endproc
.LFE250:
	.size	List_pop_head_node, .-List_pop_head_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
.LFB251:
	.loc 2 384 0
	.cfi_startproc
.LVL188:
	.loc 2 384 0
	and	w2, w0, 65535
	.loc 2 388 0
	adrp	x0, .LANCHOR42
.LVL189:
	ldr	x1, [x0, #:lo12:.LANCHOR42]
	cbz	x1, .L123
	.loc 2 393 0
	adrp	x0, .LANCHOR41
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR41]
	.loc 2 392 0
	mov	w0, 65535
.LVL190:
.L120:
	cbz	w2, .L121
	.loc 2 392 0 is_stmt 0 discriminator 1
	ldrh	w1, [x1]
.LVL191:
	cmp	w1, w0
	bne	.L122
	ret
.L122:
	.loc 2 394 0 is_stmt 1
	sub	w2, w2, #1
.LVL192:
	.loc 2 393 0
	umaddl	x1, w1, w4, x3
.LVL193:
	.loc 2 394 0
	and	w2, w2, 65535
.LVL194:
	b	.L120
.LVL195:
.L123:
	.loc 2 389 0
	mov	w0, 65535
	ret
.LVL196:
.L121:
	.loc 2 398 0
	sub	x0, x1, x3
	mov	x1, -6148914691236517206
.LVL197:
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	.loc 2 400 0
	and	w0, w0, 65535
	.loc 2 401 0
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
	.loc 2 404 0
	.cfi_startproc
.LVL198:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	and	w19, w0, 65535
	.loc 2 413 0
	adrp	x0, .LANCHOR51
.LVL199:
	.loc 2 404 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	.loc 2 413 0
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L126
	.loc 2 413 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L126
	.loc 2 413 0 discriminator 2
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L126
.LVL200:
.LBB187:
.LBB188:
	.loc 2 416 0 is_stmt 1
	adrp	x2, .LANCHOR41
	mov	w1, 6
	.loc 2 418 0
	adrp	x0, .LANCHOR42
	mov	x24, x2
	.loc 2 416 0
	umull	x1, w19, w1
	ldr	x3, [x2, #:lo12:.LANCHOR41]
	.loc 2 418 0
	ldr	x4, [x0, #:lo12:.LANCHOR42]
	mov	x23, x0
	.loc 2 416 0
	add	x22, x3, x1
.LVL201:
	.loc 2 418 0
	cmp	x22, x4
	beq	.L126
.LVL202:
	.loc 2 421 0
	adrp	x0, .LANCHOR43
	ubfiz	x2, x19, 1, 16
	mov	x21, x0
	ldr	x4, [x0, #:lo12:.LANCHOR43]
	.loc 2 426 0
	ldrh	w0, [x22, 2]
	.loc 2 422 0
	ldrh	w20, [x4, x2]
	ldrh	w2, [x22, 4]
	mul	w20, w20, w2
.LVL203:
	.loc 2 426 0
	mov	w2, 65535
	.loc 2 424 0
	cmp	w20, 0
	csinv	w20, w20, wzr, ne
.LVL204:
	.loc 2 426 0
	cmp	w0, w2
	bne	.L129
	ldrh	w1, [x3, x1]
	cmp	w1, w0
	bne	.L129
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 426
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL205:
.L129:
	.loc 2 427 0
	ldrh	w1, [x22, 2]
	mov	w0, 6
	.loc 2 428 0
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	.loc 2 427 0
	umull	x1, w1, w0
.LVL206:
	.loc 2 428 0
	asr	x0, x1, 1
	mul	x0, x0, x2
	.loc 2 429 0
	ldr	x2, [x21, #:lo12:.LANCHOR43]
	.loc 2 430 0
	ldrh	w0, [x2, x0, lsl 1]
	ldr	x2, [x24, #:lo12:.LANCHOR41]
	add	x1, x2, x1
.LVL207:
	ldrh	w1, [x1, 4]
.LVL208:
	mul	w0, w0, w1
.LVL209:
	.loc 2 432 0
	cmp	w0, 0
	csinv	w0, w0, wzr, ne
.LVL210:
	.loc 2 434 0
	cmp	w20, w0
	bcs	.L126
	.loc 2 435 0
	adrp	x20, .LANCHOR45
.LVL211:
	mov	w1, w19
	add	x0, x23, :lo12:.LANCHOR42
.LVL212:
	bl	List_remove_node
.LVL213:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L131
	adrp	x1, .LANCHOR54
	adrp	x0, .LC1
	mov	w2, 435
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL214:
.L131:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	.loc 2 436 0
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL215:
.L126:
.LBE188:
.LBE187:
	.loc 2 439 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL216:
	ldp	x21, x22, [sp, 32]
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
.LFE252:
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",@progbits
	.align	2
	.global	ftl_map_blk_alloc_new_blk
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
.LFB255:
	.loc 2 516 0
	.cfi_startproc
.LVL217:
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
.LVL218:
	mov	x4, x0
	.loc 2 520 0
	mov	w5, 0
	.loc 2 516 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 520 0
	ldrh	w1, [x0, 10]
	ldr	x0, [x0, 16]
.LVL219:
.L134:
	.loc 2 520 0 is_stmt 0 discriminator 1
	cmp	w5, w1
	bne	.L137
.L138:
.LVL220:
.LBB191:
.LBB192:
	.loc 2 532 0 is_stmt 1
	mov	w2, 532
	adrp	x1, .LANCHOR55
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL221:
	b	.L139
.LVL222:
.L137:
.LBE192:
.LBE191:
	.loc 2 521 0
	mov	x6, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L135
	.loc 2 522 0
	bl	FtlFreeSysBlkQueueOut
.LVL223:
	strh	w0, [x6]
	.loc 2 523 0
	tst	w0, 65535
	beq	.L136
	.loc 2 526 0
	ldr	w0, [x4, 48]
	.loc 2 524 0
	strh	wzr, [x4, 2]
	.loc 2 526 0
	add	w0, w0, 1
	str	w0, [x4, 48]
	.loc 2 527 0
	ldrh	w0, [x4, 8]
	.loc 2 525 0
	strh	w5, [x4]
	.loc 2 527 0
	add	w0, w0, 1
	strh	w0, [x4, 8]
.L136:
	.loc 2 532 0
	ldrh	w0, [x4, 10]
	cmp	w0, w5
	bls	.L138
.LVL224:
.L139:
	.loc 2 534 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL225:
.L135:
	.cfi_restore_state
	.loc 2 520 0 discriminator 2
	add	w5, w5, 1
.LVL226:
	and	w5, w5, 65535
.LVL227:
	b	.L134
	.cfi_endproc
.LFE255:
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
.LFB260:
	.loc 2 700 0
	.cfi_startproc
.LVL228:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 705 0
	adrp	x0, .LANCHOR33
	mov	x1, 0
	.loc 2 706 0
	mov	w3, 65535
	.loc 2 700 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 705 0
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	.loc 2 706 0
	adrp	x0, .LANCHOR56
	.loc 2 700 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 706 0
	ldr	x0, [x0, #:lo12:.LANCHOR56]
.LVL229:
.L145:
	and	w19, w1, 65535
.LVL230:
	.loc 2 705 0 discriminator 1
	cmp	w19, w2
	bcc	.L147
	add	x3, x0, 4
	.loc 2 705 0 is_stmt 0
	mov	w19, w2
.LVL231:
	mov	w5, -2147483648
	mov	w1, 0
.LVL232:
.L148:
	.loc 2 715 0 is_stmt 1 discriminator 1
	cmp	w1, w2
	bne	.L150
	.loc 2 724 0
	cmp	w19, w2
	bcc	.L146
	.loc 2 730 0
	adrp	x1, .LANCHOR57
.LVL233:
	mov	w19, w2
.LVL234:
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR57]
	mov	w1, 0
.LVL235:
.L151:
	.loc 2 729 0 discriminator 1
	cmp	w1, w2
	bne	.L153
	.loc 2 735 0
	cmp	w19, w1
	bcc	.L146
	.loc 2 735 0 is_stmt 0 discriminator 1
	mov	w2, 735
	adrp	x1, .LANCHOR58
.LVL236:
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR58
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL237:
	b	.L146
.LVL238:
.L147:
	add	x1, x1, 1
	.loc 2 706 0 is_stmt 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L145
.LVL239:
.L146:
	.loc 2 737 0
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL240:
.L150:
	.cfi_restore_state
	.loc 2 716 0
	ldr	w4, [x3]
	tbnz	w4, #31, .L149
	.loc 2 717 0
	cmp	w5, w4
	bls	.L149
	mov	w5, w4
.LVL241:
	mov	w19, w1
.LVL242:
.L149:
	.loc 2 715 0 discriminator 2
	add	w1, w1, 1
.LVL243:
	add	x3, x3, 16
	and	w1, w1, 65535
.LVL244:
	b	.L148
.LVL245:
.L153:
	.loc 2 730 0
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L152
	.loc 2 730 0 is_stmt 0 discriminator 1
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
.LVL246:
	csel	w19, w19, w1, eq
.LVL247:
.L152:
	.loc 2 729 0 is_stmt 1 discriminator 2
	add	w1, w1, 1
.LVL248:
	add	x0, x0, 16
	and	w1, w1, 65535
.LVL249:
	b	.L151
	.cfi_endproc
.LFE260:
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
.LFB266:
	.loc 2 882 0
	.cfi_startproc
.LVL250:
	.loc 2 885 0
	adrp	x2, .LANCHOR59
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR59]
	cmp	w1, 4
	bhi	.L156
	.loc 2 885 0 is_stmt 0 discriminator 1
	cbnz	w0, .L156
	.loc 2 885 0
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR59]
	.loc 2 894 0 is_stmt 1
	ret
.L156:
.LBB195:
.LBB196:
	.loc 2 888 0
	adrp	x1, .LANCHOR5
.LBE196:
.LBE195:
	.loc 2 887 0
	adrp	x0, .LANCHOR60
.LVL251:
	.loc 2 886 0
	strh	wzr, [x3, #:lo12:.LANCHOR59]
.LBB199:
.LBB197:
	.loc 2 890 0
	mov	w2, 0
	.loc 2 888 0
	ldrh	w5, [x1, #:lo12:.LANCHOR5]
	.loc 2 890 0
	adrp	x1, .LANCHOR43
.LBE197:
.LBE199:
	.loc 2 887 0
	str	wzr, [x0, #:lo12:.LANCHOR60]
.LVL252:
.LBB200:
.LBB198:
	.loc 2 890 0
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR43]
	mov	w7, 65535
	mov	x1, 0
.L157:
.LVL253:
	.loc 2 888 0
	cmp	w5, w1, uxth
	bhi	.L159
	cbz	w3, .L155
	str	w2, [x0, #:lo12:.LANCHOR60]
.L155:
	ret
.L159:
	.loc 2 890 0
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L158
	.loc 2 891 0
	add	w2, w2, w4
	mov	w3, 1
.L158:
.LVL254:
	add	x1, x1, 1
.LVL255:
	b	.L157
.LBE198:
.LBE200:
	.cfi_endproc
.LFE266:
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
.LFB272:
	.loc 2 1347 0
	.cfi_startproc
.LVL256:
	.loc 2 1347 0
	and	w0, w0, 65535
	.loc 2 1348 0
	cbz	w1, .L166
	b	ftl_set_blk_mode.part.7
.LVL257:
.L166:
	.loc 2 1351 0
	adrp	x1, .LANCHOR1
.LVL258:
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
	.loc 2 1355 0
	.cfi_startproc
.LVL259:
	.loc 2 1355 0
	and	w1, w0, 65535
	.loc 2 1356 0
	adrp	x0, .LANCHOR1
.LVL260:
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	ubfx	x2, x1, 5, 11
	ldr	w0, [x0, x2, lsl 2]
	lsr	w0, w0, w1
	.loc 2 1357 0
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
	.loc 2 1608 0
	.cfi_startproc
.LVL261:
	.loc 2 1608 0
	and	w2, w2, 65535
	and	w6, w1, 65535
	ubfiz	x4, x2, 1, 16
	.loc 2 1611 0
	adrp	x1, .LANCHOR3
.LVL262:
	add	x4, x4, 16
	.loc 2 1610 0
	strh	wzr, [x0, 4]
.LVL263:
	add	x4, x0, x4
	.loc 2 1611 0
	ldrh	w3, [x1, #:lo12:.LANCHOR3]
	.loc 2 1613 0
	mov	w1, 65535
.LVL264:
.L169:
	.loc 2 1611 0 discriminator 1
	cmp	w2, w3
	bcc	.L171
	.loc 2 1622 0
	adrp	x1, .LANCHOR19
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
.LVL265:
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	add	x3, x0, x3
	.loc 2 1620 0
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	.loc 2 1622 0
	sub	w1, w1, w6
.L172:
	.loc 2 1618 0 discriminator 1
	cmp	x2, x3
	bne	.L174
	.loc 2 1625 0
	ret
.LVL266:
.L171:
	.loc 2 1613 0
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L170
	.loc 2 1615 0
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L170:
	.loc 2 1611 0 discriminator 2
	add	w2, w2, 1
.LVL267:
	add	x4, x4, 2
	and	w2, w2, 65535
.LVL268:
	b	.L169
.LVL269:
.L174:
	.loc 2 1620 0
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L173
	.loc 2 1622 0
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L173:
	add	x2, x2, 2
	b	.L172
	.cfi_endproc
.LFE279:
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
.LFB282:
	.loc 2 2013 0
	.cfi_startproc
.LVL270:
	.loc 2 2016 0
	ldrh	w1, [x0, 4]
	cbz	w1, .L175
	.loc 2 2018 0
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L175
.LVL271:
.LBB203:
.LBB204:
	.loc 2 2020 0
	ldrb	w2, [x0, 6]
	add	x2, x2, 8
	ldrh	w3, [x0, x2, lsl 1]
.LVL272:
	.loc 2 2023 0
	adrp	x2, .LANCHOR3
	ldrh	w4, [x2, #:lo12:.LANCHOR3]
	.loc 2 2021 0
	mov	w2, w1
.L178:
	cmp	w3, w2
	beq	.L180
.LVL273:
.L175:
	ret
.LVL274:
.L180:
	.loc 2 2022 0
	ldrb	w1, [x0, 6]
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x0, 6]
	.loc 2 2023 0
	cmp	w1, w4
	bne	.L179
	.loc 2 2024 0
	ldrh	w1, [x0, 2]
	.loc 2 2025 0
	strb	wzr, [x0, 6]
	.loc 2 2024 0
	add	w1, w1, 1
	strh	w1, [x0, 2]
.L179:
	.loc 2 2027 0
	ldrb	w1, [x0, 6]
	add	x1, x1, 8
	ldrh	w3, [x0, x1, lsl 1]
.LVL275:
	b	.L178
.LBE204:
.LBE203:
	.cfi_endproc
.LFE282:
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.make_superblock,"ax",@progbits
	.align	2
	.global	make_superblock
	.type	make_superblock, %function
make_superblock:
.LFB284:
	.loc 2 2045 0
	.cfi_startproc
.LVL276:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2048 0
	ldrh	w1, [x0]
	.loc 2 2045 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2045 0
	mov	x19, x0
	.loc 2 2048 0
	adrp	x0, .LANCHOR5
.LVL277:
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w1, w0
	bcc	.L182
	.loc 2 2048 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR61
	adrp	x0, .LC1
	mov	w2, 2048
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL278:
.L182:
	.loc 2 2051 0 is_stmt 1
	adrp	x0, .LANCHOR3
	.loc 2 2052 0
	adrp	x7, .LANCHOR13
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR13
	.loc 2 2051 0
	ldrh	w8, [x0, #:lo12:.LANCHOR3]
	mov	x5, 0
	.loc 2 2049 0
	strh	wzr, [x19, 4]
	.loc 2 2053 0
	mov	w10, -1
	.loc 2 2050 0
	strb	wzr, [x19, 7]
.LVL279:
.L183:
	.loc 2 2051 0 discriminator 1
	cmp	w8, w5, uxth
	bhi	.L185
	.loc 2 2061 0
	adrp	x1, .LANCHOR19
	ldrb	w0, [x19, 7]
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	.loc 2 2062 0
	mov	w0, 1
	strb	w0, [x19, 9]
	.loc 2 2064 0
	mov	w0, 0
	ldr	x19, [sp, 16]
.LVL280:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL281:
.L185:
	.cfi_restore_state
	.loc 2 2052 0
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
.LVL282:
	mov	w4, w0
.LVL283:
	.loc 2 2053 0
	strh	w10, [x6]
	.loc 2 2054 0
	bl	FtlBbmIsBadBlock
.LVL284:
	cbnz	w0, .L184
	.loc 2 2055 0
	strh	w4, [x6]
	.loc 2 2056 0
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L184:
.LVL285:
	add	x5, x5, 1
.LVL286:
	add	x6, x6, 2
	b	.L183
	.cfi_endproc
.LFE284:
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",@progbits
	.align	2
	.global	update_multiplier_value
	.type	update_multiplier_value, %function
update_multiplier_value:
.LFB293:
	.loc 2 2401 0
	.cfi_startproc
.LVL287:
	and	w6, w0, 65535
	.loc 2 2405 0
	adrp	x0, .LANCHOR3
.LVL288:
	mov	x7, 0
	.loc 2 2406 0
	adrp	x8, .LANCHOR13
	.loc 2 2405 0
	ldrh	w10, [x0, #:lo12:.LANCHOR3]
	.loc 2 2408 0
	adrp	x0, .LANCHOR19
	.loc 2 2403 0
	mov	w5, 0
	.loc 2 2406 0
	add	x8, x8, :lo12:.LANCHOR13
.LVL289:
	.loc 2 2408 0
	ldrh	w11, [x0, #:lo12:.LANCHOR19]
	.loc 2 2405 0
	cmp	w10, w7, uxth
	bhi	.L199
	.loc 2 2410 0
	cbz	w5, .L197
	.loc 2 2411 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL290:
.L198:
	.loc 2 2412 0
	adrp	x0, .LANCHOR41
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	umaddl	x6, w6, w1, x0
.LVL291:
	.loc 2 2414 0
	mov	w0, 0
	.loc 2 2412 0
	strh	w5, [x6, 4]
	.loc 2 2414 0
	ret
.LVL292:
.L192:
	.cfi_def_cfa 29, 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	w5, 0
.LVL293:
	b	.L191
.LVL294:
.L197:
	.cfi_def_cfa 31, 0
	.cfi_restore 29
	.cfi_restore 30
	mov	w5, 0
	b	.L198
.L199:
	.loc 2 2401 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.L190:
	.loc 2 2406 0
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
.LVL295:
	.loc 2 2407 0
	bl	FtlBbmIsBadBlock
.LVL296:
	cbnz	w0, .L189
	.loc 2 2408 0
	add	w5, w5, w11
.LVL297:
	and	w5, w5, 65535
.LVL298:
.L189:
	add	x7, x7, 1
.LVL299:
	.loc 2 2405 0 discriminator 2
	cmp	w10, w7, uxth
	bhi	.L190
	.loc 2 2410 0
	cbz	w5, .L192
	.loc 2 2411 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL300:
.L191:
	.loc 2 2412 0
	adrp	x0, .LANCHOR41
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	umaddl	x6, w6, w1, x0
	.loc 2 2414 0
	mov	w0, 0
	.loc 2 2412 0
	strh	w5, [x6, 4]
	.loc 2 2414 0
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
	.loc 2 2417 0
	.cfi_startproc
.LVL301:
	.loc 2 2420 0
	adrp	x0, .LANCHOR47
	ldr	x0, [x0, #:lo12:.LANCHOR47]
	cbz	x0, .L202
	.loc 2 2421 0
	adrp	x1, .LANCHOR41
	ldr	x1, [x1, #:lo12:.LANCHOR41]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR40
	ldr	x1, [x1, #:lo12:.LANCHOR40]
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
.LVL302:
	ret
.LVL303:
.L202:
	.loc 2 2418 0
	mov	w0, 0
.LVL304:
	.loc 2 2423 0
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
	.loc 2 2426 0
	.cfi_startproc
.LVL305:
	.loc 2 2431 0
	adrp	x1, .LANCHOR47
	.loc 2 2426 0
	and	w0, w0, 65535
	.loc 2 2431 0
	ldr	x1, [x1, #:lo12:.LANCHOR47]
	cbz	x1, .L210
	.loc 2 2432 0
	adrp	x2, .LANCHOR48
	mov	w3, 7
	.loc 2 2436 0
	mov	w5, 6
	mov	w6, 65535
	.loc 2 2432 0
	ldrh	w2, [x2, #:lo12:.LANCHOR48]
	mul	w2, w2, w3
	asr	w2, w2, 3
	.loc 2 2433 0
	cmp	w0, w2
	csel	w0, w2, w0, gt
.LVL306:
	.loc 2 2434 0
	adrp	x2, .LANCHOR41
	ldr	x3, [x2, #:lo12:.LANCHOR41]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	.loc 2 2435 0
	mov	w2, 0
	.loc 2 2434 0
	and	w1, w1, 65535
.LVL307:
.L206:
	.loc 2 2435 0 discriminator 1
	cmp	w0, w2
	beq	.L209
	.loc 2 2436 0
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L207
.L209:
	.loc 2 2440 0
	adrp	x0, .LANCHOR40
.LVL308:
	ubfiz	x1, x1, 1, 16
.LVL309:
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	ldrh	w0, [x0, x1]
.LVL310:
	ret
.LVL311:
.L207:
	.loc 2 2435 0 discriminator 2
	add	w2, w2, 1
.LVL312:
	mov	w1, w4
	and	w2, w2, 65535
.LVL313:
	b	.L206
.LVL314:
.L210:
	.loc 2 2427 0
	mov	w0, 0
.LVL315:
	.loc 2 2443 0
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
.LVL316:
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
.LVL317:
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 3 32 0
	adrp	x23, .LANCHOR48
	.loc 3 12 0
	stp	x25, x26, [sp, 64]
	.loc 3 39 0
	adrp	x22, .LANCHOR79
	.loc 3 12 0
	str	x27, [sp, 80]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.loc 3 16 0
	bl	sprintf
.LVL318:
	add	x20, x21, x0, sxtw
.LVL319:
	.loc 3 17 0
	adrp	x0, .LANCHOR26
	adrp	x1, .LC3
	add	x1, x1, :lo12:.LC3
	ldr	w2, [x0, #:lo12:.LANCHOR26]
	mov	x0, x20
	.loc 3 39 0
	add	x22, x22, :lo12:.LANCHOR79
	.loc 3 50 0
	adrp	x24, .LANCHOR51
	.loc 3 67 0
	adrp	x25, .LANCHOR82
	.loc 3 17 0
	bl	sprintf
.LVL320:
	add	x20, x20, x0, sxtw
.LVL321:
	.loc 3 18 0
	mov	x0, x20
	adrp	x1, .LC4
	add	x1, x1, :lo12:.LC4
	bl	sprintf
.LVL322:
	add	x20, x20, x0, sxtw
.LVL323:
	.loc 3 19 0
	adrp	x0, .LANCHOR62
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	ldr	w2, [x0, #:lo12:.LANCHOR62]
	mov	x0, x20
	bl	sprintf
.LVL324:
	add	x20, x20, x0, sxtw
.LVL325:
	.loc 3 20 0
	adrp	x0, .LANCHOR60
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	ldr	w2, [x0, #:lo12:.LANCHOR60]
	mov	x0, x20
	bl	sprintf
.LVL326:
	add	x20, x20, x0, sxtw
.LVL327:
	.loc 3 21 0
	adrp	x0, .LANCHOR63
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
	ldr	w2, [x0, #:lo12:.LANCHOR63]
	mov	x0, x20
	bl	sprintf
.LVL328:
	add	x20, x20, x0, sxtw
.LVL329:
	.loc 3 22 0
	adrp	x0, .LANCHOR64
	adrp	x1, .LC8
	add	x1, x1, :lo12:.LC8
	ldr	w2, [x0, #:lo12:.LANCHOR64]
	mov	x0, x20
	bl	sprintf
.LVL330:
	add	x20, x20, x0, sxtw
.LVL331:
	.loc 3 23 0
	adrp	x0, .LANCHOR65
	adrp	x1, .LC9
	add	x1, x1, :lo12:.LC9
	ldr	w2, [x0, #:lo12:.LANCHOR65]
	mov	x0, x20
	bl	sprintf
.LVL332:
	add	x20, x20, x0, sxtw
.LVL333:
	.loc 3 24 0
	adrp	x0, .LANCHOR66
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	ldr	w2, [x0, #:lo12:.LANCHOR66]
	mov	x0, x20
	bl	sprintf
.LVL334:
	add	x20, x20, x0, sxtw
.LVL335:
	.loc 3 25 0
	adrp	x0, .LANCHOR67
	adrp	x1, .LC11
	add	x1, x1, :lo12:.LC11
	ldr	w2, [x0, #:lo12:.LANCHOR67]
	mov	x0, x20
	bl	sprintf
.LVL336:
	add	x20, x20, x0, sxtw
.LVL337:
	.loc 3 26 0
	adrp	x0, .LANCHOR68
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	ldr	w2, [x0, #:lo12:.LANCHOR68]
	mov	x0, x20
	bl	sprintf
.LVL338:
	add	x20, x20, x0, sxtw
.LVL339:
	.loc 3 27 0
	adrp	x0, .LANCHOR69
	adrp	x1, .LC13
	add	x1, x1, :lo12:.LC13
	ldr	w2, [x0, #:lo12:.LANCHOR69]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
.LVL340:
	add	x20, x20, x0, sxtw
.LVL341:
	.loc 3 28 0
	adrp	x0, .LANCHOR70
	adrp	x1, .LC14
	add	x1, x1, :lo12:.LC14
	ldr	w2, [x0, #:lo12:.LANCHOR70]
	mov	x0, x20
	lsr	w2, w2, 11
	bl	sprintf
.LVL342:
	add	x20, x20, x0, sxtw
.LVL343:
	.loc 3 29 0
	adrp	x0, .LANCHOR71
	adrp	x1, .LC15
	add	x1, x1, :lo12:.LC15
	ldr	w2, [x0, #:lo12:.LANCHOR71]
	mov	x0, x20
	bl	sprintf
.LVL344:
	add	x20, x20, x0, sxtw
.LVL345:
	.loc 3 30 0
	adrp	x0, .LANCHOR72
	adrp	x1, .LC16
	add	x1, x1, :lo12:.LC16
	ldr	w2, [x0, #:lo12:.LANCHOR72]
	mov	x0, x20
	bl	sprintf
.LVL346:
	add	x20, x20, x0, sxtw
.LVL347:
	.loc 3 31 0
	add	x0, x19, :lo12:.LANCHOR37
	adrp	x1, .LC17
	add	x1, x1, :lo12:.LC17
	ldrh	w2, [x0, 6]
	mov	x0, x20
	bl	sprintf
.LVL348:
	add	x20, x20, x0, sxtw
.LVL349:
	.loc 3 32 0
	ldrh	w2, [x23, #:lo12:.LANCHOR48]
	mov	x0, x20
	adrp	x1, .LC18
	add	x1, x1, :lo12:.LC18
	bl	sprintf
.LVL350:
	add	x20, x20, x0, sxtw
.LVL351:
	.loc 3 33 0
	adrp	x0, .LANCHOR73
	adrp	x1, .LC19
	add	x1, x1, :lo12:.LC19
	ldr	w2, [x0, #:lo12:.LANCHOR73]
	mov	x0, x20
	bl	sprintf
.LVL352:
	add	x20, x20, x0, sxtw
.LVL353:
	.loc 3 34 0
	adrp	x0, .LANCHOR74
	adrp	x1, .LC20
	add	x1, x1, :lo12:.LC20
	ldr	w2, [x0, #:lo12:.LANCHOR74]
	mov	x0, x20
	bl	sprintf
.LVL354:
	add	x20, x20, x0, sxtw
.LVL355:
	.loc 3 35 0
	adrp	x0, .LANCHOR75
	adrp	x1, .LC21
	add	x1, x1, :lo12:.LC21
	ldr	w2, [x0, #:lo12:.LANCHOR75]
	mov	x0, x20
	bl	sprintf
.LVL356:
	add	x20, x20, x0, sxtw
.LVL357:
	.loc 3 36 0
	adrp	x0, .LANCHOR76
	adrp	x1, .LC22
	add	x1, x1, :lo12:.LC22
	ldr	w2, [x0, #:lo12:.LANCHOR76]
	mov	x0, x20
	bl	sprintf
.LVL358:
	add	x20, x20, x0, sxtw
.LVL359:
	.loc 3 37 0
	adrp	x0, .LANCHOR77
	adrp	x1, .LC23
	add	x1, x1, :lo12:.LC23
	ldr	w2, [x0, #:lo12:.LANCHOR77]
	mov	x0, x20
	bl	sprintf
.LVL360:
	add	x20, x20, x0, sxtw
.LVL361:
	.loc 3 38 0
	adrp	x0, .LANCHOR78
	adrp	x1, .LC24
	add	x1, x1, :lo12:.LC24
	ldr	w2, [x0, #:lo12:.LANCHOR78]
	mov	x0, x20
	bl	sprintf
.LVL362:
	add	x20, x20, x0, sxtw
.LVL363:
	.loc 3 39 0
	ldrh	w2, [x22, 30]
	mov	x0, x20
	adrp	x1, .LC25
	add	x1, x1, :lo12:.LC25
	bl	sprintf
.LVL364:
	add	x20, x20, x0, sxtw
.LVL365:
	.loc 3 40 0
	ldrh	w2, [x22, 28]
	mov	x0, x20
	adrp	x1, .LC26
	add	x1, x1, :lo12:.LC26
	.loc 3 55 0
	adrp	x22, .LANCHOR43
	.loc 3 40 0
	bl	sprintf
.LVL366:
	add	x20, x20, x0, sxtw
.LVL367:
	.loc 3 41 0
	adrp	x0, .LANCHOR34
	adrp	x1, .LC27
	add	x1, x1, :lo12:.LC27
	ldr	w2, [x0, #:lo12:.LANCHOR34]
	mov	x0, x20
	bl	sprintf
.LVL368:
	add	x20, x20, x0, sxtw
.LVL369:
	.loc 3 42 0
	adrp	x0, .LANCHOR31
	adrp	x1, .LC28
	add	x1, x1, :lo12:.LC28
	ldr	w2, [x0, #:lo12:.LANCHOR31]
	mov	x0, x20
	bl	sprintf
.LVL370:
	add	x20, x20, x0, sxtw
.LVL371:
	.loc 3 43 0
	adrp	x0, .LANCHOR2
	adrp	x1, .LC29
	add	x1, x1, :lo12:.LC29
	ldr	w2, [x0, #:lo12:.LANCHOR2]
	mov	x0, x20
	bl	sprintf
.LVL372:
	add	x20, x20, x0, sxtw
.LVL373:
	.loc 3 44 0
	adrp	x0, .LANCHOR38+6
	adrp	x1, .LC30
	add	x1, x1, :lo12:.LC30
	ldrh	w2, [x0, #:lo12:.LANCHOR38+6]
	mov	x0, x20
	bl	sprintf
.LVL374:
	add	x20, x20, x0, sxtw
.LVL375:
	.loc 3 45 0
	adrp	x0, .LANCHOR5
	adrp	x1, .LC31
	add	x1, x1, :lo12:.LC31
	ldrh	w2, [x0, #:lo12:.LANCHOR5]
	mov	x0, x20
	bl	sprintf
.LVL376:
	add	x20, x20, x0, sxtw
.LVL377:
	.loc 3 46 0
	adrp	x0, .LANCHOR80
	adrp	x1, .LC32
	add	x1, x1, :lo12:.LC32
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	mov	x0, x20
	bl	sprintf
.LVL378:
	add	x20, x20, x0, sxtw
.LVL379:
	.loc 3 47 0
	adrp	x0, .LANCHOR7
	adrp	x1, .LC33
	add	x1, x1, :lo12:.LC33
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	mov	x0, x20
	bl	sprintf
.LVL380:
	add	x20, x20, x0, sxtw
.LVL381:
	.loc 3 48 0
	adrp	x0, .LANCHOR81
	adrp	x1, .LC34
	add	x1, x1, :lo12:.LC34
	ldrh	w2, [x0, #:lo12:.LANCHOR81]
	mov	x0, x20
	bl	sprintf
.LVL382:
	add	x20, x20, x0, sxtw
.LVL383:
	.loc 3 49 0
	ldrh	w2, [x19, #:lo12:.LANCHOR37]
	.loc 3 50 0
	add	x19, x24, :lo12:.LANCHOR51
	.loc 3 49 0
	mov	x0, x20
	adrp	x1, .LC35
	add	x1, x1, :lo12:.LC35
	bl	sprintf
.LVL384:
	add	x20, x20, x0, sxtw
.LVL385:
	.loc 3 50 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	bl	sprintf
.LVL386:
	add	x20, x20, x0, sxtw
.LVL387:
	.loc 3 51 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC37
	add	x1, x1, :lo12:.LC37
	bl	sprintf
.LVL388:
	add	x20, x20, x0, sxtw
.LVL389:
	.loc 3 52 0
	ldrh	w2, [x24, #:lo12:.LANCHOR51]
	mov	x0, x20
	adrp	x1, .LC38
	add	x1, x1, :lo12:.LC38
	bl	sprintf
.LVL390:
	add	x20, x20, x0, sxtw
.LVL391:
	.loc 3 53 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC39
	add	x1, x1, :lo12:.LC39
	bl	sprintf
.LVL392:
	add	x20, x20, x0, sxtw
.LVL393:
	.loc 3 54 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC40
	add	x1, x1, :lo12:.LC40
	bl	sprintf
.LVL394:
	add	x20, x20, x0, sxtw
.LVL395:
	.loc 3 55 0
	ldrh	w1, [x24, #:lo12:.LANCHOR51]
	.loc 3 56 0
	adrp	x24, .LANCHOR52
	.loc 3 55 0
	ldr	x0, [x22, #:lo12:.LANCHOR43]
	.loc 3 56 0
	add	x19, x24, :lo12:.LANCHOR52
	.loc 3 55 0
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC41
	add	x1, x1, :lo12:.LC41
	bl	sprintf
.LVL396:
	add	x20, x20, x0, sxtw
.LVL397:
	.loc 3 56 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC42
	add	x1, x1, :lo12:.LC42
	bl	sprintf
.LVL398:
	add	x20, x20, x0, sxtw
.LVL399:
	.loc 3 57 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC43
	add	x1, x1, :lo12:.LC43
	bl	sprintf
.LVL400:
	add	x20, x20, x0, sxtw
.LVL401:
	.loc 3 58 0
	ldrh	w2, [x24, #:lo12:.LANCHOR52]
	mov	x0, x20
	adrp	x1, .LC44
	add	x1, x1, :lo12:.LC44
	bl	sprintf
.LVL402:
	add	x20, x20, x0, sxtw
.LVL403:
	.loc 3 59 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC45
	add	x1, x1, :lo12:.LC45
	bl	sprintf
.LVL404:
	add	x20, x20, x0, sxtw
.LVL405:
	.loc 3 60 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC46
	add	x1, x1, :lo12:.LC46
	bl	sprintf
.LVL406:
	add	x20, x20, x0, sxtw
.LVL407:
	.loc 3 61 0
	ldrh	w1, [x24, #:lo12:.LANCHOR52]
	.loc 3 62 0
	adrp	x24, .LANCHOR53
	.loc 3 61 0
	ldr	x0, [x22, #:lo12:.LANCHOR43]
	.loc 3 62 0
	add	x19, x24, :lo12:.LANCHOR53
	.loc 3 61 0
	ldrh	w2, [x0, x1, lsl 1]
	mov	x0, x20
	adrp	x1, .LC47
	add	x1, x1, :lo12:.LC47
	bl	sprintf
.LVL408:
	add	x20, x20, x0, sxtw
.LVL409:
	.loc 3 62 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC48
	add	x1, x1, :lo12:.LC48
	bl	sprintf
.LVL410:
	add	x20, x20, x0, sxtw
.LVL411:
	.loc 3 63 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC49
	add	x1, x1, :lo12:.LC49
	bl	sprintf
.LVL412:
	add	x20, x20, x0, sxtw
.LVL413:
	.loc 3 64 0
	ldrh	w2, [x24, #:lo12:.LANCHOR53]
	mov	x0, x20
	adrp	x1, .LC50
	add	x1, x1, :lo12:.LC50
	.loc 3 72 0
	adrp	x24, .LANCHOR83
	add	x24, x24, :lo12:.LANCHOR83
	.loc 3 64 0
	bl	sprintf
.LVL414:
	add	x20, x20, x0, sxtw
.LVL415:
	.loc 3 65 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC51
	add	x1, x1, :lo12:.LC51
	bl	sprintf
.LVL416:
	add	x20, x20, x0, sxtw
.LVL417:
	.loc 3 66 0
	ldrh	w2, [x19, 4]
	.loc 3 67 0
	add	x19, x25, :lo12:.LANCHOR82
	.loc 3 66 0
	mov	x0, x20
	adrp	x1, .LC52
	add	x1, x1, :lo12:.LC52
	bl	sprintf
.LVL418:
	add	x20, x20, x0, sxtw
.LVL419:
	.loc 3 67 0
	ldrh	w2, [x19, 2]
	mov	x0, x20
	adrp	x1, .LC53
	add	x1, x1, :lo12:.LC53
	bl	sprintf
.LVL420:
	add	x20, x20, x0, sxtw
.LVL421:
	.loc 3 68 0
	ldrb	w2, [x19, 6]
	mov	x0, x20
	adrp	x1, .LC54
	add	x1, x1, :lo12:.LC54
	bl	sprintf
.LVL422:
	add	x20, x20, x0, sxtw
.LVL423:
	.loc 3 69 0
	ldrh	w2, [x25, #:lo12:.LANCHOR82]
	mov	x0, x20
	adrp	x1, .LC55
	add	x1, x1, :lo12:.LC55
	bl	sprintf
.LVL424:
	add	x20, x20, x0, sxtw
.LVL425:
	.loc 3 70 0
	ldrb	w2, [x19, 8]
	mov	x0, x20
	adrp	x1, .LC56
	add	x1, x1, :lo12:.LC56
	bl	sprintf
.LVL426:
	add	x20, x20, x0, sxtw
.LVL427:
	.loc 3 71 0
	ldrh	w2, [x19, 4]
	mov	x0, x20
	adrp	x1, .LC57
	add	x1, x1, :lo12:.LC57
	bl	sprintf
.LVL428:
	add	x20, x20, x0, sxtw
.LVL429:
	.loc 3 72 0
	ldp	w4, w2, [x24, 76]
	adrp	x1, .LC58
	ldr	w3, [x24, 84]
	add	x1, x1, :lo12:.LC58
	mov	x0, x20
	bl	sprintf
.LVL430:
	add	x19, x20, x0, sxtw
.LVL431:
	.loc 3 73 0
	ldr	w2, [x24, 72]
	mov	x0, x19
	adrp	x1, .LC59
	add	x1, x1, :lo12:.LC59
	bl	sprintf
.LVL432:
	add	x19, x19, x0, sxtw
.LVL433:
	.loc 3 74 0
	ldr	w2, [x24, 96]
	mov	x0, x19
	adrp	x1, .LC60
	add	x1, x1, :lo12:.LC60
	bl	sprintf
.LVL434:
	add	x19, x19, x0, sxtw
.LVL435:
	.loc 3 75 0
	adrp	x0, .LANCHOR84
	adrp	x1, .LC61
	add	x1, x1, :lo12:.LC61
	ldrh	w2, [x0, #:lo12:.LANCHOR84]
	mov	x0, x19
	bl	sprintf
.LVL436:
	add	x19, x19, x0, sxtw
.LVL437:
	.loc 3 76 0
	adrp	x0, .LANCHOR85
	adrp	x1, .LC62
	add	x1, x1, :lo12:.LC62
	ldrh	w2, [x0, #:lo12:.LANCHOR85]
	mov	x0, x19
	bl	sprintf
.LVL438:
	add	x19, x19, x0, sxtw
.LVL439:
	.loc 3 77 0
	adrp	x0, .LANCHOR86
	adrp	x1, .LC63
	add	x1, x1, :lo12:.LC63
	ldr	w2, [x0, #:lo12:.LANCHOR86]
	mov	x0, x19
	bl	sprintf
.LVL440:
	add	x19, x19, x0, sxtw
.LVL441:
	.loc 3 78 0
	adrp	x0, .LANCHOR87
	adrp	x1, .LC64
	add	x1, x1, :lo12:.LC64
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	mov	x0, x19
	bl	sprintf
.LVL442:
	add	x19, x19, x0, sxtw
.LVL443:
	.loc 3 79 0
	bl	GetFreeBlockMinEraseCount
.LVL444:
	and	w2, w0, 65535
	adrp	x1, .LC65
	mov	x0, x19
	add	x1, x1, :lo12:.LC65
	bl	sprintf
.LVL445:
	add	x19, x19, x0, sxtw
.LVL446:
	.loc 3 80 0
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	bl	GetFreeBlockMaxEraseCount
.LVL447:
	and	w2, w0, 65535
	adrp	x1, .LC66
	mov	x0, x19
	add	x1, x1, :lo12:.LC66
	bl	sprintf
.LVL448:
	add	x19, x19, x0, sxtw
.LVL449:
	.loc 3 81 0
	adrp	x0, .LANCHOR88
	ldr	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 1
	beq	.L212
.L217:
	.loc 3 104 0
	sub	w0, w19, w21
	.loc 3 105 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
.LVL450:
	ldp	x21, x22, [sp, 32]
.LVL451:
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
.LVL452:
.L212:
	.cfi_restore_state
	.loc 3 84 0
	ldrh	w0, [x25, #:lo12:.LANCHOR82]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L214
	.loc 3 85 0
	ldr	x1, [x22, #:lo12:.LANCHOR43]
	ubfiz	x0, x0, 1, 16
	ldrh	w2, [x1, x0]
	mov	x0, x19
	adrp	x1, .LC67
	add	x1, x1, :lo12:.LC67
	bl	sprintf
.LVL453:
	add	x19, x19, x0, sxtw
.LVL454:
.L214:
.LBB205:
	.loc 3 87 0
	mov	w0, 0
	.loc 3 91 0
	adrp	x24, .LC68
	.loc 3 87 0
	bl	List_get_gc_head_node
.LVL455:
	.loc 3 91 0
	add	x24, x24, :lo12:.LC68
	.loc 3 87 0
	and	w3, w0, 65535
.LVL456:
	.loc 3 88 0
	mov	w23, 0
	.loc 3 89 0
	mov	w27, 65535
	adrp	x20, .LANCHOR41
	.loc 3 91 0
	mov	w26, 6
.LVL457:
.L216:
	.loc 3 89 0
	cmp	w3, w27
	beq	.L215
	.loc 3 91 0 discriminator 2
	adrp	x0, .LANCHOR40
	umull	x25, w3, w26
	ldr	x2, [x22, #:lo12:.LANCHOR43]
	ubfiz	x1, x3, 1, 16
	ldr	x4, [x0, #:lo12:.LANCHOR40]
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	add	x0, x0, x25
	ldrh	w6, [x4, x1]
	ldrh	w4, [x2, x1]
	mov	w2, w23
	ldrh	w5, [x0, 4]
	mov	x1, x24
	mov	x0, x19
	.loc 3 88 0 discriminator 2
	add	w23, w23, 1
.LVL458:
	.loc 3 91 0 discriminator 2
	bl	sprintf
.LVL459:
	add	x19, x19, x0, sxtw
.LVL460:
	.loc 3 92 0 discriminator 2
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	.loc 3 88 0 discriminator 2
	cmp	w23, 16
	.loc 3 92 0 discriminator 2
	ldrh	w3, [x0, x25]
.LVL461:
	.loc 3 88 0 discriminator 2
	bne	.L216
.L215:
.LBE205:
.LBB206:
	.loc 3 96 0
	adrp	x0, .LANCHOR47
	.loc 3 100 0
	adrp	x23, .LC69
.LVL462:
	add	x23, x23, :lo12:.LC69
	.loc 3 97 0
	mov	w22, 0
	.loc 3 96 0
	ldr	x3, [x0, #:lo12:.LANCHOR47]
.LVL463:
	.loc 3 98 0
	mov	w25, 65535
	.loc 3 96 0
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	.loc 3 100 0
	mov	w26, 6
	adrp	x27, .LANCHOR40
	.loc 3 96 0
	sub	x3, x3, x0
	mov	x0, -6148914691236517206
	asr	x3, x3, 1
	movk	x0, 0xaaab, lsl 0
	mul	x3, x3, x0
	and	w3, w3, 65535
.LVL464:
.L218:
	.loc 3 98 0
	cmp	w3, w25
	beq	.L217
	.loc 3 100 0 discriminator 2
	umull	x24, w3, w26
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	ldr	x2, [x27, #:lo12:.LANCHOR40]
	ubfiz	x1, x3, 1, 16
	add	x0, x0, x24
	ldrh	w5, [x2, x1]
	mov	w2, w22
	ldrh	w4, [x0, 4]
	mov	x1, x23
	mov	x0, x19
	.loc 3 97 0 discriminator 2
	add	w22, w22, 1
.LVL465:
	.loc 3 100 0 discriminator 2
	bl	sprintf
.LVL466:
	add	x19, x19, x0, sxtw
.LVL467:
	.loc 3 97 0 discriminator 2
	cmp	w22, 4
	beq	.L217
	.loc 3 101 0
	ldr	x0, [x20, #:lo12:.LANCHOR41]
	ldrh	w3, [x0, x24]
	b	.L218
.LBE206:
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
.LVL468:
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
.LVL469:
	.loc 3 120 0
	bl	sprintf
.LVL470:
	add	x19, x20, x0, sxtw
.LVL471:
	.loc 3 122 0
	mov	x0, x19
	bl	FtlPrintInfo2buf
.LVL472:
	add	x0, x19, x0, sxtw
.LVL473:
	.loc 3 124 0
	sub	w0, w0, w20
.LVL474:
	ldp	x19, x20, [sp, 16]
.LVL475:
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
	.loc 2 2447 0
	.cfi_startproc
.LVL476:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2456 0
	adrp	x2, .LANCHOR75
	adrp	x10, .LANCHOR78
	.loc 2 2447 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2456 0
	ldr	w3, [x2, #:lo12:.LANCHOR75]
	ldr	w7, [x10, #:lo12:.LANCHOR78]
	cmp	w3, w7
	bcs	.L227
	.loc 2 2459 0
	adrp	x1, .LANCHOR5
	.loc 2 2458 0
	adrp	x0, .LANCHOR73
	.loc 2 2459 0
	mov	w5, 0
	mov	w4, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR5]
	.loc 2 2460 0
	adrp	x1, .LANCHOR40
	.loc 2 2458 0
	str	wzr, [x0, #:lo12:.LANCHOR73]
.LVL477:
	.loc 2 2460 0
	ldr	x6, [x1, #:lo12:.LANCHOR40]
	.loc 2 2459 0
	mov	x1, 0
.LVL478:
.L228:
	.loc 2 2459 0 is_stmt 0 discriminator 1
	cmp	w3, w1
	bhi	.L229
	cbz	w5, .L230
	str	w4, [x0, #:lo12:.LANCHOR73]
.L230:
	.loc 2 2461 0 is_stmt 1
	ldr	w1, [x0, #:lo12:.LANCHOR73]
.LVL479:
	udiv	w3, w1, w3
	str	w3, [x2, #:lo12:.LANCHOR75]
	.loc 2 2462 0
	adrp	x3, .LANCHOR74
	ldr	w3, [x3, #:lo12:.LANCHOR74]
	sub	w1, w1, w3
	adrp	x3, .LANCHOR14
	ldrh	w3, [x3, #:lo12:.LANCHOR14]
	udiv	w1, w1, w3
	str	w1, [x0, #:lo12:.LANCHOR73]
.L231:
	.loc 2 2468 0
	ldr	w8, [x2, #:lo12:.LANCHOR75]
	add	w0, w7, 256
	cmp	w0, w8
	bls	.L236
	.loc 2 2468 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR77
	add	w0, w7, 768
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	cmp	w0, w1
	bls	.L236
.LVL480:
.L239:
	.loc 2 2469 0 is_stmt 1
	mov	w19, 65535
.L237:
	.loc 2 2518 0
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.LVL481:
.L229:
	.cfi_restore_state
	.loc 2 2460 0 discriminator 3
	ldrh	w5, [x6, x1, lsl 1]
	add	x1, x1, 1
.LVL482:
	add	w4, w4, w5
	mov	w5, 1
	b	.L228
.L227:
	.loc 2 2463 0
	adrp	x1, .LANCHOR77
	ldr	w0, [x1, #:lo12:.LANCHOR77]
	cmp	w3, w0
	bls	.L231
	.loc 2 2464 0
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR77]
.LVL483:
	.loc 2 2466 0
	adrp	x0, .LANCHOR40
	.loc 2 2465 0
	adrp	x1, .LANCHOR5
	add	x1, x1, :lo12:.LANCHOR5
	.loc 2 2466 0
	ldr	x4, [x0, #:lo12:.LANCHOR40]
	.loc 2 2465 0
	mov	w0, 0
.LVL484:
.L233:
	.loc 2 2465 0 is_stmt 0 discriminator 1
	ldrh	w3, [x1]
	cmp	w0, w3
	bcs	.L231
	.loc 2 2466 0 is_stmt 1 discriminator 3
	ubfiz	x5, x0, 1, 32
	.loc 2 2465 0 discriminator 3
	add	w0, w0, 1
.LVL485:
	.loc 2 2466 0 discriminator 3
	ldrh	w3, [x4, x5]
	add	w3, w3, 1
	strh	w3, [x4, x5]
	b	.L233
.LVL486:
.L236:
	.loc 2 2471 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w0, lsl 1
	lsr	w0, w0, 2
	bl	GetFreeBlockMaxEraseCount
.LVL487:
	and	w6, w0, 65535
.LVL488:
	.loc 2 2472 0
	add	w0, w7, 64
.LVL489:
	cmp	w6, w0
	bcs	.L238
	.loc 2 2472 0 is_stmt 0 discriminator 1
	cmp	w7, 30
	bhi	.L239
.L238:
	.loc 2 2476 0 is_stmt 1
	adrp	x0, .LANCHOR42
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	cbz	x0, .L239
	.loc 2 2483 0
	adrp	x1, .LANCHOR41
	.loc 2 2484 0
	mov	w3, 65535
	.loc 2 2483 0
	mov	x12, -6148914691236517206
	.loc 2 2484 0
	mov	w2, w3
	.loc 2 2483 0
	ldr	x5, [x1, #:lo12:.LANCHOR41]
	.loc 2 2484 0
	adrp	x1, .LANCHOR40
	.loc 2 2479 0
	mov	w11, w3
	.loc 2 2483 0
	movk	x12, 0xaaab, lsl 0
	.loc 2 2484 0
	ldr	x1, [x1, #:lo12:.LANCHOR40]
	.loc 2 2495 0
	mov	w13, 6
.LVL490:
.L240:
	.loc 2 2479 0
	ldrh	w4, [x0]
	cmp	w4, w11
	bne	.L243
	mov	w19, w2
.LVL491:
.L242:
	.loc 2 2498 0
	mov	w0, 65535
	cmp	w19, w0
	beq	.L239
	.loc 2 2500 0
	ubfiz	x2, x19, 1, 32
	ldrh	w5, [x1, x2]
.LVL492:
	.loc 2 2501 0
	cmp	w7, w5
	bcs	.L244
	.loc 2 2503 0
	bl	GetFreeBlockMinEraseCount
.LVL493:
	cmp	w7, w0, uxth
	bcs	.L244
	.loc 2 2504 0
	str	w3, [x10, #:lo12:.LANCHOR78]
.L244:
	.loc 2 2506 0
	cmp	w8, w5
	bls	.L239
	.loc 2 2506 0 is_stmt 0 discriminator 1
	add	w0, w5, 128
	cmp	w6, w0
	ble	.L239
	.loc 2 2508 0 is_stmt 1
	add	w0, w5, 256
	adrp	x1, .LANCHOR77
	cmp	w8, w0
	bhi	.L245
	.loc 2 2508 0 is_stmt 0 discriminator 1
	ldr	w3, [x1, #:lo12:.LANCHOR77]
.LVL494:
	add	w0, w5, 768
	cmp	w0, w3
	bcs	.L239
.L245:
	.loc 2 2510 0 is_stmt 1
	adrp	x0, .LANCHOR43
	ldr	w3, [x1, #:lo12:.LANCHOR77]
	mov	w1, w19
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	ldrh	w4, [x0, x2]
	mov	w2, w8
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
.LVL495:
	.loc 2 2511 0
	adrp	x0, .LANCHOR89
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR89]
	.loc 2 2512 0
	b	.L237
.LVL496:
.L243:
	.loc 2 2481 0
	ldrh	w14, [x0, 4]
	cbz	w14, .L241
	.loc 2 2483 0
	sub	x0, x0, x5
.LVL497:
	asr	x0, x0, 1
	mul	x0, x0, x12
	and	w19, w0, 65535
.LVL498:
	.loc 2 2484 0
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
	cmp	w7, w0
	bcs	.L242
	.loc 2 2489 0
	cmp	w3, w0
	bls	.L241
	mov	w3, w0
.LVL499:
	.loc 2 2483 0
	mov	w2, w19
.LVL500:
.L241:
	.loc 2 2495 0
	umaddl	x0, w4, w13, x5
.LVL501:
	b	.L240
	.cfi_endproc
.LFE296:
	.size	GetSwlReplaceBlock, .-GetSwlReplaceBlock
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
.LFB297:
	.loc 2 2522 0
	.cfi_startproc
.LVL502:
	and	w0, w0, 65535
	.loc 2 2523 0
	mov	w1, 65535
	cmp	w0, w1
	beq	.L259
.LVL503:
	.loc 2 2522 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
.LBB209:
.LBB210:
	.loc 2 2525 0
	adrp	x2, .LANCHOR43
	ubfiz	x1, x0, 1, 16
.LBE210:
.LBE209:
	.loc 2 2522 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
.LBB212:
.LBB211:
	.loc 2 2525 0
	ldr	x2, [x2, #:lo12:.LANCHOR43]
	strh	wzr, [x2, x1]
	.loc 2 2526 0
	bl	INSERT_FREE_LIST
.LVL504:
.LBE211:
.LBE212:
	.loc 2 2528 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL505:
.L259:
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
	.loc 2 2655 0
	.cfi_startproc
.LVL506:
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
	.loc 2 2659 0
	ldrh	w1, [x0]
	mov	w0, 65535
.LVL507:
	.loc 2 2655 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2659 0
	cmp	w1, w0
	bne	.L263
	.loc 2 2659 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR90
	adrp	x0, .LC1
	mov	w2, 2659
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL508:
.L263:
	.loc 2 2660 0 is_stmt 1
	adrp	x20, .LANCHOR19
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bne	.L264
	.loc 2 2660 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR90
	adrp	x0, .LC1
	mov	w2, 2660
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL509:
.L264:
	.loc 2 2661 0 is_stmt 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L265
	.loc 2 2661 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR90
	adrp	x0, .LC1
	mov	w2, 2661
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL510:
.L265:
	.loc 2 2663 0 is_stmt 1
	ldrb	w0, [x19, 6]
	.loc 2 2666 0
	adrp	x1, .LANCHOR3
	.loc 2 2662 0
	strb	wzr, [x19, 10]
	.loc 2 2663 0
	add	x0, x0, 8
	.loc 2 2666 0
	ldrh	w2, [x1, #:lo12:.LANCHOR3]
	.loc 2 2664 0
	mov	w1, 65535
	.loc 2 2663 0
	ldrh	w0, [x19, x0, lsl 1]
.LVL511:
.L266:
	.loc 2 2664 0
	cmp	w0, w1
	beq	.L268
	.loc 2 2672 0
	ldrh	w21, [x19, 2]
	.loc 2 2680 0
	mov	w3, 65535
	.loc 2 2673 0
	ldrh	w1, [x19, 4]
	.loc 2 2672 0
	orr	w21, w21, w0, lsl 10
.LVL512:
	ldrb	w0, [x19, 6]
.LVL513:
	.loc 2 2673 0
	sub	w1, w1, #1
	and	w1, w1, 65535
	strh	w1, [x19, 4]
.L270:
	.loc 2 2675 0
	add	w0, w0, 1
	and	w0, w0, 255
	.loc 2 2676 0
	cmp	w2, w0
	bne	.L269
	.loc 2 2677 0
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 2678 0
	mov	w0, 0
.L269:
	.loc 2 2680 0
	add	x4, x19, x0, sxtw 1
	ldrh	w4, [x4, 16]
	cmp	w4, w3
	beq	.L270
	strb	w0, [x19, 6]
	.loc 2 2682 0
	ldrh	w2, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w2, w0
	bne	.L262
	.loc 2 2682 0 is_stmt 0 discriminator 1
	cbz	w1, .L262
	.loc 2 2682 0 discriminator 2
	adrp	x1, .LANCHOR90
	adrp	x0, .LC1
	mov	w2, 2682
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL514:
.L262:
	.loc 2 2684 0 is_stmt 1
	mov	w0, w21
	ldr	x21, [sp, 32]
.LVL515:
	ldp	x19, x20, [sp, 16]
.LVL516:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL517:
.L268:
	.cfi_restore_state
	.loc 2 2665 0
	ldrb	w0, [x19, 6]
.LVL518:
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	.loc 2 2666 0
	cmp	w0, w2
	bne	.L267
	.loc 2 2667 0
	ldrh	w0, [x19, 2]
	.loc 2 2668 0
	strb	wzr, [x19, 6]
	.loc 2 2667 0
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L267:
	.loc 2 2670 0
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
.LVL519:
	b	.L266
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
	adrp	x1, .LANCHOR92
	.loc 5 25 0
	adrp	x0, .LANCHOR91
	.loc 5 28 0
	adrp	x7, .LANCHOR93
	.loc 5 29 0
	adrp	x6, .LANCHOR94
	.loc 5 27 0
	ldr	x5, [x1, #:lo12:.LANCHOR92]
	.loc 5 28 0
	adrp	x1, .LANCHOR23
	.loc 5 25 0
	str	wzr, [x0, #:lo12:.LANCHOR91]
.LVL520:
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
	adrp	x1, .LANCHOR95
	.loc 5 28 0
	ldr	x14, [x7, #:lo12:.LANCHOR93]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR95]
	.loc 5 26 0
	mov	w2, 0
	.loc 5 29 0
	ldr	x15, [x6, #:lo12:.LANCHOR94]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	.loc 5 26 0
	mov	w1, 0
	.loc 5 27 0
	mov	w16, 1
.LVL521:
.L278:
	add	w13, w2, w10
	add	w12, w1, w11
	.loc 5 26 0 discriminator 1
	cmp	x3, x8
	bne	.L279
	.loc 5 34 0
	adrp	x1, .LANCHOR96
	.loc 5 36 0
	ldr	x7, [x7, #:lo12:.LANCHOR93]
	.loc 5 37 0
	ldr	x6, [x6, #:lo12:.LANCHOR94]
	.loc 5 35 0
	mov	w8, 24
	.loc 5 34 0
	ldr	w4, [x1, #:lo12:.LANCHOR96]
.L280:
.LVL522:
	.loc 5 34 0 is_stmt 0 discriminator 1
	cmp	w0, w4
	bcc	.L281
	.loc 5 39 0 is_stmt 1
	ret
.LVL523:
.L279:
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
	b	.L278
.LVL524:
.L281:
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
.LVL525:
	and	w0, w0, 65535
.LVL526:
	.loc 5 37 0 discriminator 3
	asr	w1, w1, 2
	add	x1, x6, x1, sxtw 2
	str	x1, [x2, 8]
	b	.L280
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
.LVL527:
	.loc 5 47 0
	adrp	x2, .LANCHOR96
	.loc 5 46 0
	mov	w3, 0
	.loc 5 48 0
	mov	w8, 24
	.loc 5 47 0
	ldr	w7, [x2, #:lo12:.LANCHOR96]
	.loc 5 48 0
	adrp	x2, .LANCHOR92
	ldr	x5, [x2, #:lo12:.LANCHOR92]
.LVL528:
.L283:
	.loc 5 46 0 discriminator 1
	cmp	w3, w1
	bcs	.L282
	.loc 5 48 0
	ubfiz	x4, x3, 5, 16
	mov	w2, 0
	add	x4, x0, x4
	b	.L288
.LVL529:
.L284:
	.loc 5 47 0 discriminator 2
	add	w2, w2, 1
.LVL530:
	and	w2, w2, 65535
.LVL531:
.L288:
	.loc 5 47 0 is_stmt 0 discriminator 1
	cmp	w2, w7
	bcs	.L285
	.loc 5 48 0 is_stmt 1
	umull	x6, w2, w8
	add	x10, x5, x6
	ldr	x11, [x5, x6]
	ldr	x6, [x4, 8]
	cmp	x11, x6
	bne	.L284
	.loc 5 49 0
	str	wzr, [x10, 16]
.L285:
	.loc 5 46 0 discriminator 2
	add	w3, w3, 1
.LVL532:
	and	w3, w3, 65535
.LVL533:
	b	.L283
.LVL534:
.L282:
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
.LVL535:
	.loc 5 62 0
	adrp	x2, .LANCHOR96
	.loc 5 61 0
	mov	w3, 0
	.loc 5 63 0
	mov	w7, 24
	.loc 5 64 0
	mov	w8, 1
	.loc 5 62 0
	ldr	w5, [x2, #:lo12:.LANCHOR96]
	.loc 5 63 0
	adrp	x2, .LANCHOR92
	ldr	x6, [x2, #:lo12:.LANCHOR92]
.LVL536:
.L290:
	.loc 5 61 0 discriminator 1
	cmp	w3, w1
	bcs	.L289
	mov	w2, 0
	b	.L295
.LVL537:
.L291:
	.loc 5 62 0 discriminator 2
	add	w2, w2, 1
.LVL538:
	and	w2, w2, 65535
.LVL539:
.L295:
	.loc 5 62 0 is_stmt 0 discriminator 1
	cmp	w2, w5
	bcs	.L292
	.loc 5 63 0 is_stmt 1
	umaddl	x4, w2, w7, x6
	ldr	w10, [x4, 16]
	cbnz	w10, .L291
	.loc 5 65 0
	ubfiz	x2, x3, 5, 16
.LVL540:
	ldr	x10, [x4]
	add	x2, x0, x2
	.loc 5 64 0
	str	w8, [x4, 16]
	.loc 5 66 0
	ldr	x4, [x4, 8]
	stp	x10, x4, [x2, 8]
.L292:
	.loc 5 61 0 discriminator 2
	add	w3, w3, 1
.LVL541:
	and	w3, w3, 65535
.LVL542:
	b	.L290
.L289:
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
.LVL543:
	.loc 5 77 0
	adrp	x1, .LANCHOR97
	.loc 5 74 0
	and	w0, w0, 65535
	.loc 5 77 0
	ldrh	w2, [x1, #:lo12:.LANCHOR97]
	.loc 5 78 0
	adrp	x1, .LANCHOR98
	ldr	x3, [x1, #:lo12:.LANCHOR98]
	.loc 5 77 0
	mov	x1, 0
.LVL544:
.L297:
	.loc 5 77 0 is_stmt 0 discriminator 1
	cmp	w2, w1, uxth
	bhi	.L299
	.loc 5 81 0 is_stmt 1
	mov	w0, 0
.LVL545:
	ret
.L299:
	add	x1, x1, 1
.LVL546:
	.loc 5 78 0
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L297
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
.LVL547:
	mov	w6, w0
	mov	w10, w1
	mov	w8, w2
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 5 88 0
	lsr	w0, w0, 10
.LVL548:
	.loc 5 85 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 5 88 0
	bl	P2V_block_in_plane
.LVL549:
	and	w7, w0, 65535
.LVL550:
	.loc 5 91 0
	adrp	x4, .LANCHOR97
	.loc 5 92 0
	adrp	x2, .LANCHOR98
	.loc 5 91 0
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR97]
	.loc 5 92 0
	ldr	x5, [x2, #:lo12:.LANCHOR98]
.LVL551:
.L302:
	and	w2, w3, 65535
.LVL552:
	.loc 5 91 0 discriminator 1
	cmp	w2, w1
	bcc	.L304
	.loc 5 96 0
	bne	.L303
	.loc 5 97 0
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	.loc 5 98 0
	ldrh	w0, [x4, #:lo12:.LANCHOR97]
.LVL553:
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR97]
.LVL554:
	b	.L303
.LVL555:
.L304:
	add	x3, x3, 1
	.loc 5 92 0
	add	x2, x5, x3, lsl 1
.LVL556:
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L302
.LVL557:
.L303:
	.loc 5 101 0
	adrp	x4, .LANCHOR99
	adrp	x1, .LANCHOR100
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR99]
	ldr	x5, [x1, #:lo12:.LANCHOR100]
	umull	x3, w0, w3
	.loc 5 107 0
	add	w0, w0, 1
	.loc 5 101 0
	add	x7, x5, x3
.LVL558:
	.loc 5 102 0
	stp	w10, w8, [x7, 4]
	.loc 5 103 0
	str	w6, [x5, x3]
	.loc 5 107 0
	strh	w0, [x4, #:lo12:.LANCHOR99]
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
.LVL559:
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
.LVL560:
	add	x0, x0, :lo12:.LC73
	bl	printf
.LVL561:
	.loc 5 349 0
	adrp	x3, .LANCHOR101
	ldrh	w4, [x3, #:lo12:.LANCHOR101]
	cmp	w19, w4
	beq	.L307
	.loc 5 349 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR102
	ldrh	w2, [x0, #:lo12:.LANCHOR102]
	cmp	w19, w2
	beq	.L307
	.loc 5 351 0 is_stmt 1
	mov	w1, 65535
	cmp	w4, w1
	bne	.L308
	.loc 5 352 0
	strh	w19, [x3, #:lo12:.LANCHOR101]
.L307:
	.loc 5 356 0
	mov	w0, 0
	ldr	x19, [sp, 16]
.LVL562:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.L308:
	.cfi_restore_state
	.loc 5 353 0
	cmp	w2, w1
	bne	.L307
	.loc 5 354 0
	strh	w19, [x0, #:lo12:.LANCHOR102]
	b	.L307
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
.LVL563:
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
	adrp	x19, .LANCHOR103
	.loc 5 359 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 5 361 0
	mov	w0, w20
.LVL564:
	bl	P2V_block_in_plane
.LVL565:
	.loc 5 364 0
	ldrh	w1, [x19, #:lo12:.LANCHOR103]
	mov	w2, w20
	.loc 5 361 0
	mov	w21, w0
.LVL566:
	.loc 5 364 0
	adrp	x0, .LC74
.LVL567:
	add	x0, x0, :lo12:.LC74
	bl	printf
.LVL568:
	.loc 5 366 0
	mov	w0, w21
	bl	FtlGcRefreshBlock
.LVL569:
	.loc 5 368 0
	ldrh	w0, [x19, #:lo12:.LANCHOR103]
	.loc 5 369 0
	adrp	x2, .LANCHOR104
	add	x2, x2, :lo12:.LANCHOR104
	.loc 5 368 0
	mov	x1, 0
.LVL570:
.L311:
	.loc 5 368 0 is_stmt 0 discriminator 1
	cmp	w0, w1, uxth
	bhi	.L313
	.loc 5 372 0 is_stmt 1
	cmp	w0, 15
	bhi	.L312
	.loc 5 373 0
	add	w1, w0, 1
.LVL571:
	strh	w1, [x19, #:lo12:.LANCHOR103]
	adrp	x1, .LANCHOR104
	add	x1, x1, :lo12:.LANCHOR104
	strh	w20, [x1, w0, sxtw 1]
	b	.L312
.LVL572:
.L313:
	add	x1, x1, 1
.LVL573:
	.loc 5 369 0
	add	x3, x2, x1, lsl 1
	ldrh	w3, [x3, -2]
	cmp	w3, w20
	bne	.L311
.L312:
	.loc 5 375 0
	mov	w0, 0
	ldr	x21, [sp, 32]
.LVL574:
	ldp	x19, x20, [sp, 16]
.LVL575:
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
	adrp	x0, .LANCHOR103
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	cbz	w0, .L322
	.loc 5 380 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR101
	ldrh	w2, [x1, #:lo12:.LANCHOR101]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L322
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
	adrp	x19, .LANCHOR105
	ldrh	w1, [x19, #:lo12:.LANCHOR105]
	cmp	w1, w0
	bcc	.L317
	.loc 5 382 0
	strh	wzr, [x19, #:lo12:.LANCHOR105]
.L317:
.LBB215:
.LBB216:
	.loc 5 383 0
	ldrh	w1, [x19, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR104
	add	x0, x0, :lo12:.LANCHOR104
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
.LVL576:
	bl	FtlGcRefreshBlock
.LVL577:
	.loc 5 384 0
	ldrh	w0, [x19, #:lo12:.LANCHOR105]
	add	w0, w0, 1
	strh	w0, [x19, #:lo12:.LANCHOR105]
.LBE216:
.LBE215:
	.loc 5 387 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
.L322:
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
.LVL578:
.LBB217:
.LBB218:
	.file 6 "include/linux/compat.h"
	.loc 6 80 0
	b	free
.LVL579:
.LBE218:
.LBE217:
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
.LVL580:
	.loc 1 29 0
	mov	w1, 0
	sxtw	x0, w0
	b	kmalloc
.LVL581:
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
.LVL582:
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
.LVL583:
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
.LVL584:
.L328:
	.loc 1 40 0 discriminator 1
	cmp	w27, w19
	bhi	.L334
	.loc 1 56 0
	ldp	x19, x20, [sp, 16]
.LVL585:
	.loc 1 55 0
	adrp	x0, .LC78
	.loc 1 56 0
	ldp	x21, x22, [sp, 32]
.LVL586:
	.loc 1 55 0
	add	x0, x0, :lo12:.LC78
	.loc 1 56 0
	ldp	x23, x24, [sp, 48]
.LVL587:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL588:
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
.LVL589:
.L334:
	.cfi_restore_state
	.loc 1 41 0
	cbnz	w20, .L329
	.loc 1 42 0
	mov	w2, w21
	mov	x1, x28
	mov	x0, x24
	bl	printf
.LVL590:
.L329:
	.loc 1 44 0
	cmp	w23, 4
	bne	.L330
	.loc 1 45 0
	ldr	w1, [x22, x19, lsl 2]
.L337:
	.loc 1 47 0
	add	x0, x26, :lo12:.LC76
.L336:
	.loc 1 49 0
	bl	printf
.LVL591:
	.loc 1 50 0
	add	w20, w20, 1
.LVL592:
	cmp	w20, 15
	bls	.L333
.LVL593:
	.loc 1 51 0
	mov	w20, 0
	.loc 1 52 0
	adrp	x0, .LC78
	add	x0, x0, :lo12:.LC78
	bl	printf
.LVL594:
.L333:
	add	x19, x19, 1
.LVL595:
	add	w21, w21, w23
	b	.L328
.LVL596:
.L330:
	.loc 1 46 0
	cmp	w23, 2
	bne	.L332
	.loc 1 47 0
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L337
.L332:
	.loc 1 49 0
	ldrb	w1, [x22, x19]
	mov	x0, x25
	b	.L336
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
.LVL597:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 1 87 0
	adrp	x2, .LANCHOR0
.LVL598:
	add	x3, x2, :lo12:.LANCHOR0
	ubfiz	x1, x1, 5, 32
.LVL599:
	.loc 1 85 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x25, [sp, 64]
	.cfi_offset 25, -32
	.loc 1 87 0
	ldrh	w25, [x3, 12]
.LVL600:
	.loc 1 85 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 1 92 0
	adrp	x21, .LANCHOR106
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
	add	x21, x21, :lo12:.LANCHOR106
	add	x22, x22, :lo12:.LC1
.LVL601:
.L339:
	.loc 1 91 0 discriminator 1
	cmp	x19, x24
	bne	.L346
	.loc 1 112 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
.LVL602:
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
.LVL603:
.L346:
	.cfi_restore_state
	.loc 1 92 0
	ldr	x0, [x19, 8]
	cbz	x0, .L340
	.loc 1 92 0 is_stmt 0 discriminator 2
	ldr	x0, [x19, 16]
	cbnz	x0, .L341
.L340:
	.loc 1 92 0 discriminator 3
	mov	w2, 92
	mov	x1, x21
	mov	x0, x22
	bl	printf
.LVL604:
.L341:
	.loc 1 93 0 is_stmt 1
	ldr	w0, [x19, 4]
	.loc 1 94 0
	adrp	x20, .LANCHOR107
	add	x20, x20, :lo12:.LANCHOR107
	.loc 1 93 0
	add	x2, x29, 88
	add	x1, x29, 92
	bl	l2p_addr_tran.isra.0
.LVL605:
	.loc 1 94 0
	ldrb	w0, [x29, 88]
	ldr	w1, [x29, 92]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x20, 24]
	blr	x4
.LVL606:
	.loc 1 98 0
	str	w0, [x19]
	.loc 1 99 0
	add	x0, x23, :lo12:.LANCHOR0
.LVL607:
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L343
	.loc 1 100 0
	ldrb	w0, [x29, 88]
	ldr	x4, [x20, 24]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 92]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w25, w1
	blr	x4
.LVL608:
	.loc 1 104 0
	cmn	w0, #1
	beq	.L344
	.loc 1 105 0 discriminator 1
	ldr	x0, [x19, 16]
.LVL609:
	.loc 1 104 0 discriminator 1
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L343
	.loc 1 105 0
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L343
	.loc 1 106 0
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L343
.L344:
	.loc 1 108 0
	mov	w0, -1
	str	w0, [x19]
.L343:
	add	x19, x19, 32
	b	.L339
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
	adrp	x2, .LANCHOR39
	adrp	x0, .LANCHOR108
	add	x1, x0, :lo12:.LANCHOR108
	.loc 4 279 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 4 286 0
	ldr	x2, [x2, #:lo12:.LANCHOR39]
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
	adrp	x2, .LANCHOR109
	.loc 4 289 0
	adrp	x23, .LANCHOR10
	add	x20, x20, 12
	.loc 4 287 0
	ldr	x25, [x2, #:lo12:.LANCHOR109]
	.loc 4 289 0
	add	x23, x23, :lo12:.LANCHOR10
	mov	w21, 0
	.loc 4 290 0
	mov	w27, -1
	.loc 4 287 0
	str	x25, [x1, 16]
.LVL610:
.L358:
	.loc 4 289 0 discriminator 1
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L363
	.loc 4 314 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL611:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL612:
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
.LVL613:
.L363:
	.cfi_restore_state
	.loc 4 291 0
	ldrh	w19, [x26, #:lo12:.LANCHOR17]
	.loc 4 293 0
	add	x24, x22, :lo12:.LANCHOR108
	.loc 4 290 0
	strh	w27, [x20]
	.loc 4 301 0
	mov	w3, 61664
	.loc 4 291 0
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL614:
.L359:
	.loc 4 291 0 is_stmt 0 discriminator 1
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L361
	.loc 4 292 0 is_stmt 1
	madd	w0, w0, w21, w19
	.loc 4 294 0
	mov	w2, 1
	str	w3, [x29, 108]
.LVL615:
	mov	w1, w2
	.loc 4 292 0
	lsl	w0, w0, 10
	.loc 4 293 0
	str	w0, [x24, 4]
	.loc 4 294 0
	mov	x0, x24
	bl	FlashReadPages
.LVL616:
	.loc 4 295 0
	ldr	w0, [x24]
	ldr	w3, [x29, 108]
	cmn	w0, #1
	beq	.L360
	.loc 4 301 0
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L360
	.loc 4 303 0
	strh	w19, [x20]
.L361:
	.loc 4 289 0 discriminator 2
	add	w21, w21, 1
.LVL617:
	add	x20, x20, 2
	b	.L358
.L360:
	.loc 4 291 0 discriminator 2
	sub	w19, w19, #1
.LVL618:
	and	w19, w19, 65535
.LVL619:
	b	.L359
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
.LVL620:
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
	bne	.L369
	.loc 2 51 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR20
.LVL621:
	ldrh	w19, [x1, #:lo12:.LANCHOR20]
.L370:
.LVL622:
	.loc 2 56 0 is_stmt 1 discriminator 4
	sub	w19, w19, #1
.LVL623:
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
.LVL624:
	.loc 2 54 0 discriminator 4
	add	x1, x29, 96
	.loc 2 57 0 discriminator 4
	str	w0, [x29, 68]
	.loc 2 58 0 discriminator 4
	mov	w2, w23
	.loc 2 54 0 discriminator 4
	str	x1, [x29, 80]
.LVL625:
	.loc 2 58 0 discriminator 4
	add	x0, x29, 64
	mov	w1, 1
	bl	FlashReadPages
.LVL626:
	.loc 2 59 0 discriminator 4
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L371
	mov	w22, 0
	.loc 2 61 0
	mov	w24, 2
.LVL627:
.L372:
	.loc 2 60 0
	cmp	w22, w19
	ble	.L375
.LVL628:
.L371:
	.loc 2 73 0
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
.LVL629:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL630:
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
.LVL631:
.L369:
	.cfi_restore_state
	.loc 2 51 0 discriminator 2
	adrp	x1, .LANCHOR19
.LVL632:
	ldrh	w19, [x1, #:lo12:.LANCHOR19]
	b	.L370
.LVL633:
.L375:
	.loc 2 61 0
	add	w20, w22, w19
	.loc 2 63 0
	mov	w2, w23
	mov	w1, 1
	.loc 2 61 0
	sdiv	w20, w20, w24
.LVL634:
	.loc 2 62 0
	sxth	w0, w20
	orr	w0, w0, w21
	str	w0, [x29, 68]
	.loc 2 63 0
	add	x0, x29, 64
	bl	FlashReadPages
.LVL635:
	.loc 2 65 0
	ldr	w0, [x29, 96]
	cmn	w0, #1
	bne	.L373
	.loc 2 65 0 is_stmt 0 discriminator 1
	ldr	w0, [x29, 100]
	cmn	w0, #1
	bne	.L373
	.loc 2 66 0 is_stmt 1
	sub	w19, w20, #1
.LVL636:
	sxth	w19, w19
.LVL637:
	b	.L372
.L373:
	.loc 2 68 0
	add	w20, w20, 1
.LVL638:
	sxth	w22, w20
.LVL639:
	b	.L372
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
.LVL640:
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	ubfiz	x1, x1, 5, 32
.LVL641:
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	mov	w25, w2
	mov	w26, w3
	.loc 1 117 0
	adrp	x2, .LANCHOR0
.LVL642:
	add	x3, x2, :lo12:.LANCHOR0
.LVL643:
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
.LVL644:
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 1 122 0
	adrp	x21, .LANCHOR110
	.loc 1 115 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	.loc 1 124 0
	adrp	x22, .LANCHOR107
	add	x24, x0, x1
	mov	x23, x2
	.loc 1 122 0
	add	x21, x21, :lo12:.LANCHOR110
	.loc 1 133 0
	add	x28, x22, :lo12:.LANCHOR107
.LVL645:
.L378:
	.loc 1 121 0 discriminator 1
	cmp	x19, x24
	bne	.L386
	.loc 1 142 0
	cbnz	w26, .L387
.LVL646:
.L405:
	.loc 1 172 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL647:
	ldp	x27, x28, [sp, 80]
.LVL648:
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
.LVL649:
.L386:
	.cfi_restore_state
	.loc 1 122 0
	ldr	x0, [x19, 8]
	cbz	x0, .L379
	.loc 1 122 0 is_stmt 0 discriminator 2
	ldr	x0, [x19, 16]
	cbnz	x0, .L380
.L379:
	.loc 1 122 0 discriminator 3
	adrp	x0, .LC1
	mov	w2, 122
	mov	x1, x21
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL650:
.L380:
	.loc 1 123 0 is_stmt 1
	ldr	w0, [x19, 4]
	add	x2, x29, 104
	add	x1, x29, 108
	bl	l2p_addr_tran.isra.0
.LVL651:
	.loc 1 124 0
	add	x0, x22, :lo12:.LANCHOR107
	ldr	w1, [x29, 108]
	ldp	x2, x3, [x19, 8]
	ldr	x4, [x0, 16]
	ldrb	w0, [x29, 104]
	blr	x4
.LVL652:
	.loc 1 129 0
	cbnz	w0, .L381
	.loc 1 128 0
	str	wzr, [x19]
.LVL653:
.L382:
	.loc 1 132 0
	add	x0, x23, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L384
	.loc 1 133 0
	ldrb	w0, [x29, 104]
	ldr	x4, [x28, 16]
	ldp	x2, x3, [x19, 8]
	ldr	w1, [x29, 108]
	add	x3, x3, 8
	add	x2, x2, 2048
	add	w1, w27, w1
	blr	x4
.LVL654:
	.loc 1 137 0
	cbz	w0, .L384
	.loc 1 138 0
	mov	w0, -1
.LVL655:
	str	w0, [x19]
.L384:
	add	x19, x19, 32
	b	.L378
.LVL656:
.L381:
	.loc 1 130 0
	mov	w0, -1
.LVL657:
	str	w0, [x19]
	b	.L382
.LVL658:
.L391:
.LBB219:
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
.LVL659:
	.loc 1 154 0
	ldr	w26, [x29, 112]
	cmn	w26, #1
	bne	.L388
	.loc 1 155 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
.LVL660:
	.loc 1 156 0
	str	w26, [x20]
.L388:
	.loc 1 158 0
	ldr	x0, [x20, 16]
	cbz	x0, .L389
	.loc 1 159 0
	ldr	w3, [x23, #:lo12:.LANCHOR111]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L389
	.loc 1 160 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
.LVL661:
	.loc 1 161 0
	mov	w0, -1
	str	w0, [x20]
.L389:
	.loc 1 164 0
	ldr	x0, [x20, 8]
	cbz	x0, .L390
	.loc 1 165 0
	ldr	w3, [x21, #:lo12:check_buf]
	ldr	w2, [x0]
	cmp	w2, w3
	beq	.L390
	.loc 1 166 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	printf
.LVL662:
	.loc 1 167 0
	mov	w0, -1
	str	w0, [x20]
.L390:
	add	x20, x20, 32
.L406:
.LBE219:
	.loc 1 144 0 discriminator 1
	cmp	x20, x19
	bne	.L391
	b	.L405
.LVL663:
.L387:
.LBB220:
	.loc 1 147 0 discriminator 1
	adrp	x21, check_buf
	.loc 1 148 0 discriminator 1
	adrp	x23, .LANCHOR111
	.loc 1 147 0 discriminator 1
	add	x22, x21, :lo12:check_buf
	.loc 1 148 0 discriminator 1
	add	x24, x23, :lo12:.LANCHOR111
	b	.L406
.LBE220:
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
.LVL664:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 1 178 0
	adrp	x1, .LANCHOR0
.LVL665:
	add	x3, x1, :lo12:.LANCHOR0
	ubfiz	x2, x2, 5, 32
.LVL666:
	.loc 1 175 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	add	x2, x2, 4
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 1 178 0
	ldrh	w23, [x3, 12]
.LVL667:
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
	adrp	x21, .LANCHOR107
	add	x22, x0, x2
	.loc 1 188 0
	add	x24, x21, :lo12:.LANCHOR107
.LVL668:
.L409:
	.loc 1 181 0 discriminator 1
	cmp	x19, x22
	bne	.L415
	.loc 1 194 0
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL669:
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
.LVL670:
.L415:
	.cfi_restore_state
	.loc 1 182 0
	ldr	w0, [x19]
	add	x2, x29, 72
	add	x1, x29, 76
	bl	l2p_addr_tran.isra.0
.LVL671:
	.loc 1 183 0
	add	x0, x21, :lo12:.LANCHOR107
	ldr	w1, [x29, 76]
	ldr	x2, [x0, 8]
	ldrb	w0, [x29, 72]
	blr	x2
.LVL672:
	.loc 1 185 0
	cbnz	w0, .L410
	.loc 1 184 0
	str	wzr, [x19, -4]
.LVL673:
.L411:
	.loc 1 187 0
	add	x0, x20, :lo12:.LANCHOR0
	ldrh	w0, [x0, 14]
	cmp	w0, 4
	bne	.L413
	.loc 1 188 0
	ldrb	w0, [x29, 72]
	ldr	x2, [x24, 8]
	ldr	w1, [x29, 76]
	add	w1, w23, w1
	blr	x2
.LVL674:
	.loc 1 189 0
	cbz	w0, .L413
	.loc 1 190 0
	mov	w0, -1
.LVL675:
	str	w0, [x19, -4]
.L413:
	add	x19, x19, 32
	b	.L409
.LVL676:
.L410:
	.loc 1 186 0
	mov	w0, -1
.LVL677:
	str	w0, [x19, -4]
	b	.L411
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
.LVL678:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	and	w21, w0, 65535
.LBB221:
.LBB222:
	.loc 2 94 0
	adrp	x0, .LANCHOR38
.LVL679:
	add	x2, x0, :lo12:.LANCHOR38
.LBE222:
.LBE221:
	.loc 2 98 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 99 0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L420
	and	w1, w1, 65535
	mov	x19, x0
.LVL680:
.LBB223:
	.loc 2 101 0
	cbz	w1, .L422
.LBB224:
	.loc 2 102 0
	mov	w0, w21
	bl	P2V_block_in_plane
.LVL681:
	and	w20, w0, 65535
.LVL682:
	.loc 2 103 0
	adrp	x0, .LANCHOR112
.LVL683:
	lsl	w1, w21, 10
	.loc 2 104 0
	mov	w2, 1
	.loc 2 103 0
	ldr	x0, [x0, #:lo12:.LANCHOR112]
	str	w1, [x0, 4]
	.loc 2 104 0
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL684:
	.loc 2 105 0
	adrp	x1, .LANCHOR40
	ubfiz	x0, x20, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR40]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	.loc 2 106 0
	adrp	x1, .LANCHOR76
	ldr	w0, [x1, #:lo12:.LANCHOR76]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
.LVL685:
.L422:
.LBE224:
	.loc 2 108 0
	add	x0, x19, :lo12:.LANCHOR38
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	.loc 2 109 0
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	.loc 2 110 0
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	.loc 2 109 0
	strh	w21, [x2, 8]
.LVL686:
.L420:
.LBE223:
	.loc 2 113 0
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
.LVL687:
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
.LVL688:
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
	adrp	x0, .LANCHOR113
.LVL689:
	.loc 3 528 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w23, w1, 255
	.loc 3 538 0
	str	w24, [x0, #:lo12:.LANCHOR113]
.LVL690:
	.loc 3 551 0
	adrp	x0, .LANCHOR115
	.loc 3 550 0
	adrp	x1, .LANCHOR114
.LVL691:
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 3 539 0
	adrp	x20, .LANCHOR3
	.loc 3 540 0
	adrp	x21, .LANCHOR112
	.loc 3 551 0
	ldr	x11, [x0, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR24
	.loc 3 539 0
	ldrh	w8, [x20, #:lo12:.LANCHOR3]
	.loc 3 540 0
	ldr	x6, [x21, #:lo12:.LANCHOR112]
	.loc 3 536 0
	mov	w22, 0
	.loc 3 550 0
	ldr	x10, [x1, #:lo12:.LANCHOR114]
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
.LVL692:
.L431:
	.loc 3 539 0 discriminator 1
	cmp	w8, w5, uxth
	bhi	.L435
	.loc 3 559 0
	cbz	w22, .L430
	.loc 3 562 0
	mov	w2, w22
	ubfiz	x22, x22, 5, 16
.LVL693:
	mov	x25, 0
	mov	w1, 0
	mov	x0, x6
	bl	FlashEraseBlocks
.LVL694:
.L439:
	.loc 3 564 0
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L438
	.loc 3 566 0
	ldr	w0, [x1, 4]
	.loc 3 565 0
	add	w19, w19, 1
.LVL695:
	and	w19, w19, 65535
.LVL696:
	.loc 3 566 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL697:
.L438:
	add	x25, x25, 32
	.loc 3 563 0 discriminator 2
	cmp	x25, x22
	bne	.L439
	.loc 3 571 0
	cbz	w23, .L452
.LVL698:
	.loc 3 573 0
	adrp	x0, .LANCHOR20
	.loc 3 572 0
	mov	w25, 1
	.loc 3 573 0
	ldrh	w26, [x0, #:lo12:.LANCHOR20]
.LVL699:
	.loc 3 574 0
	lsr	w28, w26, 2
.LVL700:
.L440:
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
.LVL701:
.L448:
	.loc 3 578 0
	ldr	x0, [x29, 136]
	mov	x5, 0
	.loc 3 579 0
	ldr	x6, [x21, #:lo12:.LANCHOR112]
	.loc 3 577 0
	mov	w20, 0
	.loc 3 578 0
	ldrh	w7, [x0]
	.loc 3 587 0
	adrp	x0, .LANCHOR116
	ldr	x8, [x0, #:lo12:.LANCHOR116]
	.loc 3 588 0
	ldr	x0, [x29, 128]
	ldr	x10, [x0, #:lo12:.LANCHOR114]
	ldr	x0, [x29, 120]
	ldrh	w11, [x0, #:lo12:.LANCHOR24]
.LVL702:
.L441:
	.loc 3 578 0 discriminator 1
	cmp	w7, w5, uxth
	bhi	.L444
	.loc 3 593 0
	cbz	w20, .L430
	.loc 3 596 0
	mov	w1, w20
	mov	w3, 1
	mov	w2, w25
	mov	x0, x6
	bl	FlashProgPages
.LVL703:
	mov	x27, 0
	ubfiz	x1, x20, 5, 16
.LVL704:
.L447:
	.loc 3 598 0
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	add	x3, x0, x27
	ldr	w0, [x0, x27]
	cbz	w0, .L446
	.loc 3 600 0
	ldr	w0, [x3, 4]
	.loc 3 599 0
	add	w19, w19, 1
.LVL705:
	str	x1, [x29, 104]
	and	w19, w19, 65535
.LVL706:
	.loc 3 600 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL707:
	ldr	x1, [x29, 104]
.L446:
	add	x27, x27, 32
	.loc 3 597 0 discriminator 2
	cmp	x1, x27
	bne	.L447
	.loc 3 604 0
	add	w22, w22, w28
.LVL708:
	and	w22, w22, 65535
.LVL709:
	.loc 3 605 0
	cmp	w26, w22
	bhi	.L448
	mov	x22, 0
.LVL710:
.L450:
	.loc 3 611 0
	cbz	w23, .L449
	.loc 3 611 0 is_stmt 0 discriminator 1
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cbnz	w0, .L449
	.loc 3 612 0 is_stmt 1
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.LVL711:
.L449:
	add	x22, x22, 32
	.loc 3 610 0 discriminator 2
	cmp	x22, x27
	bne	.L450
	.loc 3 615 0
	cmp	w24, 63
	ccmp	w23, 0, 0, hi
	beq	.L430
	.loc 3 616 0
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	mov	w2, w20
	mov	w1, w25
	bl	FlashEraseBlocks
.LVL712:
.L430:
	.loc 3 619 0
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
.LVL713:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL714:
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
.LVL715:
.L435:
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
.LVL716:
	and	w13, w0, 65535
	mov	w14, w13
.LVL717:
	.loc 3 543 0
	cbz	w23, .L432
	.loc 3 544 0
	bl	IsBlkInVendorPart
.LVL718:
	cbnz	w0, .L433
.L432:
	.loc 3 548 0
	mov	w0, w14
	bl	FtlBbmIsBadBlock
.LVL719:
	cbnz	w0, .L434
	.loc 3 549 0
	ubfiz	x0, x22, 5, 16
	.loc 3 551 0
	mul	w1, w22, w12
	.loc 3 549 0
	add	x0, x6, x0
	.loc 3 552 0
	add	w22, w22, 1
.LVL720:
	and	w22, w22, 65535
.LVL721:
	.loc 3 549 0
	lsl	w13, w13, 10
.LVL722:
	.loc 3 551 0
	asr	w1, w1, 2
	add	x1, x11, x1, sxtw 2
	.loc 3 549 0
	str	w13, [x0, 4]
	.loc 3 551 0
	stp	x10, x1, [x0, 8]
.L433:
.LVL723:
	add	x5, x5, 1
.LVL724:
	b	.L431
.LVL725:
.L434:
	.loc 3 554 0
	add	w19, w19, 1
.LVL726:
	and	w19, w19, 65535
.LVL727:
	b	.L433
.LVL728:
.L452:
	.loc 3 534 0
	mov	w25, 0
	.loc 3 533 0
	mov	w28, 6
	.loc 3 531 0
	mov	w26, 1
	b	.L440
.LVL729:
.L444:
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
.LVL730:
	and	w12, w0, 65535
	mov	w13, w12
.LVL731:
	.loc 3 581 0
	cbz	w23, .L442
	.loc 3 582 0
	bl	IsBlkInVendorPart
.LVL732:
	cbnz	w0, .L443
.L442:
	.loc 3 585 0
	mov	w0, w13
	bl	FtlBbmIsBadBlock
.LVL733:
	cbnz	w0, .L443
	.loc 3 586 0
	ubfiz	x0, x20, 5, 16
	.loc 3 588 0
	mul	w1, w20, w11
	.loc 3 586 0
	add	x0, x6, x0
	.loc 3 589 0
	add	w20, w20, 1
.LVL734:
	and	w20, w20, 65535
.LVL735:
	.loc 3 586 0
	add	w12, w22, w12, lsl 10
.LVL736:
	.loc 3 588 0
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	.loc 3 586 0
	str	w12, [x0, 4]
	.loc 3 588 0
	stp	x8, x1, [x0, 8]
.L443:
.LVL737:
	add	x5, x5, 1
.LVL738:
	b	.L441
	.cfi_endproc
.LFE209:
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.ftl_memset,"ax",@progbits
	.align	2
	.global	ftl_memset
	.type	ftl_memset, %function
ftl_memset:
.LFB346:
	.loc 1 242 0
	.cfi_startproc
.LVL739:
	.loc 1 243 0
	uxtw	x2, w2
	b	memset
.LVL740:
	.cfi_endproc
.LFE346:
	.size	ftl_memset, .-ftl_memset
	.section	.text.FtlMemInit,"ax",@progbits
	.align	2
	.global	FtlMemInit
	.type	FtlMemInit, %function
FtlMemInit:
.LFB206:
	.loc 3 279 0
	.cfi_startproc
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	.loc 3 282 0
	adrp	x0, .LANCHOR71
	.loc 3 297 0
	mov	w1, 65535
	.loc 3 279 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 282 0
	str	wzr, [x0, #:lo12:.LANCHOR71]
	.loc 3 283 0
	adrp	x0, .LANCHOR72
	.loc 3 279 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.loc 3 310 0
	adrp	x19, .LANCHOR21
	.loc 3 283 0
	str	wzr, [x0, #:lo12:.LANCHOR72]
	.loc 3 284 0
	adrp	x0, .LANCHOR68
	.loc 3 279 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.loc 3 312 0
	adrp	x22, .LANCHOR3
	.loc 3 284 0
	str	wzr, [x0, #:lo12:.LANCHOR68]
	.loc 3 285 0
	adrp	x0, .LANCHOR65
	.loc 3 279 0
	stp	x23, x24, [sp, 48]
	.loc 3 319 0
	adrp	x21, .LANCHOR23
	.loc 3 285 0
	str	wzr, [x0, #:lo12:.LANCHOR65]
	.loc 3 286 0
	adrp	x0, .LANCHOR64
	.loc 3 279 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.loc 3 330 0
	adrp	x24, .LANCHOR109
	.loc 3 286 0
	str	wzr, [x0, #:lo12:.LANCHOR64]
	.loc 3 287 0
	adrp	x0, .LANCHOR66
	.loc 3 279 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 3 331 0
	adrp	x23, .LANCHOR115
	.loc 3 287 0
	str	wzr, [x0, #:lo12:.LANCHOR66]
	.loc 3 288 0
	adrp	x0, .LANCHOR67
	.loc 3 349 0
	adrp	x25, .LANCHOR43
	.loc 3 351 0
	adrp	x27, .LANCHOR129
	.loc 3 288 0
	str	wzr, [x0, #:lo12:.LANCHOR67]
	.loc 3 289 0
	adrp	x0, .LANCHOR63
	.loc 3 352 0
	adrp	x26, .LANCHOR130
	.loc 3 289 0
	str	wzr, [x0, #:lo12:.LANCHOR63]
	.loc 3 290 0
	adrp	x0, .LANCHOR73
	str	wzr, [x0, #:lo12:.LANCHOR73]
	.loc 3 291 0
	adrp	x0, .LANCHOR74
	str	wzr, [x0, #:lo12:.LANCHOR74]
	.loc 3 292 0
	adrp	x0, .LANCHOR76
	str	wzr, [x0, #:lo12:.LANCHOR76]
	.loc 3 293 0
	adrp	x0, .LANCHOR77
	str	wzr, [x0, #:lo12:.LANCHOR77]
	.loc 3 294 0
	adrp	x0, .LANCHOR78
	str	wzr, [x0, #:lo12:.LANCHOR78]
	.loc 3 295 0
	adrp	x0, .LANCHOR117
	str	wzr, [x0, #:lo12:.LANCHOR117]
	.loc 3 296 0
	adrp	x0, .LANCHOR89
	str	wzr, [x0, #:lo12:.LANCHOR89]
	.loc 3 297 0
	adrp	x0, .LANCHOR118
	str	w1, [x0, #:lo12:.LANCHOR118]
	.loc 3 298 0
	adrp	x0, .LANCHOR119
	.loc 3 301 0
	adrp	x1, .LANCHOR101
	.loc 3 298 0
	str	wzr, [x0, #:lo12:.LANCHOR119]
	.loc 3 299 0
	adrp	x0, .LANCHOR86
	str	wzr, [x0, #:lo12:.LANCHOR86]
	.loc 3 300 0
	adrp	x0, .LANCHOR113
	str	wzr, [x0, #:lo12:.LANCHOR113]
	.loc 3 301 0
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR101]
	.loc 3 302 0
	adrp	x1, .LANCHOR102
	strh	w0, [x1, #:lo12:.LANCHOR102]
	.loc 3 303 0
	adrp	x0, .LANCHOR84
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR84]
	.loc 3 304 0
	adrp	x0, .LANCHOR85
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR85]
	.loc 3 305 0
	adrp	x0, .LANCHOR87
	strh	wzr, [x0, #:lo12:.LANCHOR87]
	.loc 3 306 0
	adrp	x0, .LANCHOR103
	strh	wzr, [x0, #:lo12:.LANCHOR103]
	.loc 3 307 0
	adrp	x0, .LANCHOR105
	strh	wzr, [x0, #:lo12:.LANCHOR105]
	.loc 3 310 0
	ldrh	w0, [x19, #:lo12:.LANCHOR21]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL741:
	adrp	x1, .LANCHOR98
	str	x0, [x1, #:lo12:.LANCHOR98]
	.loc 3 311 0
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR21]
	mul	w0, w1, w0
	bl	ftl_malloc
.LVL742:
	.loc 3 312 0
	ldrh	w19, [x22, #:lo12:.LANCHOR3]
	.loc 3 311 0
	adrp	x3, .LANCHOR100
	str	x3, [x29, 104]
	.loc 3 312 0
	lsl	w20, w19, 5
.LVL743:
	.loc 3 313 0
	lsl	w19, w19, 7
	.loc 3 311 0
	str	x0, [x3, #:lo12:.LANCHOR100]
	.loc 3 313 0
	mov	w0, w19
	bl	ftl_malloc
.LVL744:
	adrp	x15, .LANCHOR120
	str	x15, [x29, 112]
	str	x0, [x15, #:lo12:.LANCHOR120]
	.loc 3 314 0
	mov	w0, w20
	bl	ftl_malloc
.LVL745:
	adrp	x11, .LANCHOR121
	str	x11, [x29, 120]
	str	x0, [x11, #:lo12:.LANCHOR121]
	.loc 3 315 0
	mov	w0, w19
	bl	ftl_malloc
.LVL746:
	adrp	x14, .LANCHOR122
	str	x14, [x29, 128]
	str	x0, [x14, #:lo12:.LANCHOR122]
	.loc 3 316 0
	mov	w0, w20
	bl	ftl_malloc
.LVL747:
	adrp	x13, .LANCHOR112
	str	x13, [x29, 136]
	str	x0, [x13, #:lo12:.LANCHOR112]
	.loc 3 317 0
	mov	w0, w20
	bl	ftl_malloc
.LVL748:
	.loc 3 320 0
	adrp	x20, .LANCHOR96
.LVL749:
	.loc 3 317 0
	adrp	x12, .LANCHOR95
	.loc 3 319 0
	ldrh	w19, [x21, #:lo12:.LANCHOR23]
.LVL750:
	.loc 3 317 0
	str	x12, [x29, 144]
	str	x0, [x12, #:lo12:.LANCHOR95]
	.loc 3 320 0
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR96]
	.loc 3 321 0
	mov	w0, w19
	bl	ftl_malloc
.LVL751:
	adrp	x10, .LANCHOR39
	str	x10, [x29, 152]
	str	x0, [x10, #:lo12:.LANCHOR39]
	.loc 3 322 0
	mov	w0, w19
	bl	ftl_malloc
.LVL752:
	adrp	x8, .LANCHOR123
	str	x8, [x29, 160]
	str	x0, [x8, #:lo12:.LANCHOR123]
	.loc 3 323 0
	mov	w0, w19
	bl	ftl_malloc
.LVL753:
	adrp	x7, .LANCHOR124
	str	x7, [x29, 168]
	str	x0, [x7, #:lo12:.LANCHOR124]
	.loc 3 324 0
	ldr	w0, [x20, #:lo12:.LANCHOR96]
	mul	w0, w19, w0
	bl	ftl_malloc
.LVL754:
	adrp	x6, .LANCHOR93
	str	x6, [x29, 176]
	str	x0, [x6, #:lo12:.LANCHOR93]
	.loc 3 325 0
	mov	w0, w19
	bl	ftl_malloc
.LVL755:
	adrp	x5, .LANCHOR116
	str	x5, [x29, 184]
	str	x0, [x5, #:lo12:.LANCHOR116]
	.loc 3 326 0
	mov	w0, w19
	bl	ftl_malloc
.LVL756:
	.loc 3 329 0
	adrp	x19, .LANCHOR24
.LVL757:
	.loc 3 326 0
	adrp	x4, .LANCHOR114
	.loc 3 327 0
	ldr	w2, [x20, #:lo12:.LANCHOR96]
	.loc 3 326 0
	str	x4, [x29, 192]
	str	x0, [x4, #:lo12:.LANCHOR114]
	.loc 3 327 0
	mov	w0, 24
	mul	w0, w2, w0
	bl	ftl_malloc
.LVL758:
	.loc 3 329 0
	ldrh	w28, [x19, #:lo12:.LANCHOR24]
	.loc 3 327 0
	adrp	x1, .LANCHOR92
	str	x0, [x1, #:lo12:.LANCHOR92]
	.loc 3 329 0
	ldrh	w0, [x22, #:lo12:.LANCHOR3]
	.loc 3 332 0
	adrp	x22, .LANCHOR94
	.loc 3 329 0
	mul	w28, w28, w0
.LVL759:
	.loc 3 330 0
	mov	w0, w28
	bl	ftl_malloc
.LVL760:
	str	x0, [x24, #:lo12:.LANCHOR109]
	.loc 3 331 0
	lsl	w0, w28, 2
	bl	ftl_malloc
.LVL761:
	str	x0, [x23, #:lo12:.LANCHOR115]
	.loc 3 332 0
	ldrh	w1, [x19, #:lo12:.LANCHOR24]
	.loc 3 335 0
	adrp	x28, .LANCHOR125
.LVL762:
	.loc 3 332 0
	ldr	w0, [x20, #:lo12:.LANCHOR96]
	.loc 3 335 0
	adrp	x20, .LANCHOR6
	.loc 3 332 0
	mul	w0, w1, w0
	bl	ftl_malloc
.LVL763:
	str	x0, [x22, #:lo12:.LANCHOR94]
	.loc 3 335 0
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x28, #:lo12:.LANCHOR125]
	.loc 3 336 0
	and	w0, w0, 65534
	bl	ftl_malloc
.LVL764:
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	.loc 3 337 0
	ldrh	w0, [x28, #:lo12:.LANCHOR125]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x28, #:lo12:.LANCHOR125]
	.loc 3 338 0
	lsl	w0, w0, 9
	bl	ftl_malloc
.LVL765:
	adrp	x1, .LANCHOR127
	.loc 3 345 0
	ldrh	w28, [x20, #:lo12:.LANCHOR6]
	.loc 3 338 0
	str	x0, [x1, #:lo12:.LANCHOR127]
	.loc 3 339 0
	adrp	x1, .LANCHOR40
	.loc 3 345 0
	lsl	w28, w28, 1
	.loc 3 339 0
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR40]
.LVL766:
	.loc 3 347 0
	mov	w0, w28
	bl	ftl_malloc
.LVL767:
	adrp	x1, .LANCHOR128
	str	x0, [x1, #:lo12:.LANCHOR128]
	.loc 3 349 0
	mov	w0, w28
	.loc 3 350 0
	adrp	x28, .LANCHOR30
.LVL768:
	.loc 3 349 0
	bl	ftl_malloc
.LVL769:
	str	x0, [x25, #:lo12:.LANCHOR43]
.LVL770:
	.loc 3 350 0
	ldr	w1, [x28, #:lo12:.LANCHOR30]
	lsl	w19, w1, 1
	.loc 3 351 0
	mov	w0, w19
	bl	ftl_malloc
.LVL771:
	str	x0, [x27, #:lo12:.LANCHOR129]
	.loc 3 352 0
	mov	w0, w19
	bl	ftl_malloc
.LVL772:
	str	x0, [x26, #:lo12:.LANCHOR130]
	.loc 3 353 0
	ldrh	w0, [x20, #:lo12:.LANCHOR6]
	.loc 3 354 0
	adrp	x19, .LANCHOR27
	.loc 3 353 0
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
.LVL773:
	adrp	x1, .LANCHOR1
	str	x0, [x1, #:lo12:.LANCHOR1]
	.loc 3 354 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL774:
	adrp	x2, .LANCHOR36
	str	x0, [x2, #:lo12:.LANCHOR36]
	.loc 3 355 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	lsl	w0, w0, 1
	bl	ftl_malloc
.LVL775:
	adrp	x2, .LANCHOR131
	str	x0, [x2, #:lo12:.LANCHOR131]
	.loc 3 356 0
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	adrp	x19, .LANCHOR40
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL776:
	adrp	x1, .LANCHOR132
	str	x0, [x1, #:lo12:.LANCHOR132]
	.loc 3 357 0
	adrp	x1, .LANCHOR28
	str	x1, [x29, 200]
	ldrh	w0, [x1, #:lo12:.LANCHOR28]
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL777:
	.loc 3 358 0
	ldr	x1, [x29, 200]
	.loc 3 357 0
	adrp	x2, .LANCHOR133
	str	x0, [x2, #:lo12:.LANCHOR133]
	.loc 3 358 0
	ldrh	w2, [x1, #:lo12:.LANCHOR28]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
.LVL778:
	.loc 3 360 0
	adrp	x0, .LANCHOR32
	ldrh	w0, [x0, #:lo12:.LANCHOR32]
	.loc 3 361 0
	lsl	w0, w0, 2
.LVL779:
	bl	ftl_malloc
.LVL780:
	adrp	x1, .LANCHOR134
	str	x0, [x1, #:lo12:.LANCHOR134]
.LVL781:
	.loc 3 362 0
	ldr	w0, [x28, #:lo12:.LANCHOR30]
	.loc 3 364 0
	adrp	x28, .LANCHOR33
	.loc 3 363 0
	lsl	w0, w0, 2
	bl	ftl_malloc
.LVL782:
	adrp	x1, .LANCHOR135
	str	x0, [x1, #:lo12:.LANCHOR135]
.LVL783:
	.loc 3 364 0
	ldrh	w0, [x28, #:lo12:.LANCHOR33]
	.loc 3 365 0
	lsl	w0, w0, 4
.LVL784:
	bl	ftl_malloc
.LVL785:
	adrp	x1, .LANCHOR56
	str	x0, [x1, #:lo12:.LANCHOR56]
.LVL786:
	.loc 3 366 0
	ldrh	w1, [x28, #:lo12:.LANCHOR33]
	ldrh	w0, [x21, #:lo12:.LANCHOR23]
	.loc 3 371 0
	adrp	x21, .LANCHOR10
	.loc 3 367 0
	mul	w0, w1, w0
.LVL787:
	bl	ftl_malloc
.LVL788:
	adrp	x1, .LANCHOR136
	str	x0, [x1, #:lo12:.LANCHOR136]
.LVL789:
	.loc 3 369 0
	mov	w0, 6
	.loc 3 368 0
	ldrh	w1, [x20, #:lo12:.LANCHOR6]
	.loc 3 370 0
	adrp	x20, .LANCHOR137
	.loc 3 369 0
	mul	w0, w1, w0
.LVL790:
	bl	ftl_malloc
.LVL791:
	adrp	x1, .LANCHOR41
	str	x0, [x1, #:lo12:.LANCHOR41]
	.loc 3 370 0
	adrp	x0, .LANCHOR17
	.loc 3 371 0
	ldrh	w1, [x21, #:lo12:.LANCHOR10]
	.loc 3 370 0
	ldrh	w0, [x0, #:lo12:.LANCHOR17]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x20, #:lo12:.LANCHOR137]
.LVL792:
	.loc 3 371 0
	mul	w0, w1, w0
.LVL793:
	.loc 3 372 0
	lsl	w0, w0, 2
.LVL794:
	bl	ftl_malloc
.LVL795:
	ldp	x3, x15, [x29, 104]
	adrp	x1, .LANCHOR37
	.loc 3 374 0
	ldrh	w20, [x20, #:lo12:.LANCHOR137]
	.loc 3 372 0
	add	x2, x1, :lo12:.LANCHOR37
	ldp	x11, x14, [x29, 120]
	.loc 3 373 0
	mov	w30, w20
	ldp	x13, x12, [x29, 136]
	mov	x16, x3
	ldp	x10, x8, [x29, 152]
	.loc 3 372 0
	str	x0, [x2, 32]
.LVL796:
	ldp	x7, x6, [x29, 168]
	adrp	x17, .LANCHOR98
	ldp	x5, x4, [x29, 184]
	adrp	x3, .LANCHOR92
	.loc 3 373 0
	ldrh	w28, [x21, #:lo12:.LANCHOR10]
	add	x21, x2, 40
	mov	x0, 1
	str	x19, [x29, 200]
.LVL797:
.L475:
	.loc 3 373 0 is_stmt 0 discriminator 1
	cmp	w0, w28
	bcc	.L476
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	.loc 3 379 0 is_stmt 1
	add	x1, x1, :lo12:.LANCHOR37
	.loc 3 373 0
	mov	x19, 0
.L477:
	add	x19, x19, 1
	.loc 3 377 0 discriminator 1
	cmp	x19, x2
	bne	.L478
	.loc 3 383 0
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	cbnz	x0, .L479
.L481:
	.loc 3 385 0
	adrp	x1, .LANCHOR138
	adrp	x0, .LC82
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC82
	bl	printf
.LVL798:
	.loc 3 386 0
	mov	w0, -1
.L474:
	.loc 3 484 0
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
.L476:
	.cfi_restore_state
	.loc 3 374 0 discriminator 3
	ldr	x19, [x2, 32]
	.loc 3 373 0 discriminator 3
	add	w0, w0, 1
	.loc 3 374 0 discriminator 3
	add	x19, x19, x30, uxtw 2
	add	w30, w30, w20
	str	x19, [x21], 8
	b	.L475
.L478:
	.loc 3 379 0 discriminator 2
	add	x20, x0, x19
	add	x20, x1, x20, lsl 3
	str	xzr, [x20, 24]
	b	.L477
.L479:
	.loc 3 388 0
	ldr	x0, [x26, #:lo12:.LANCHOR130]
	cbz	x0, .L481
	.loc 3 393 0
	adrp	x0, .LANCHOR134
	ldr	x0, [x0, #:lo12:.LANCHOR134]
	cbz	x0, .L481
	.loc 3 398 0
	adrp	x0, .LANCHOR135
	ldr	x0, [x0, #:lo12:.LANCHOR135]
	cbz	x0, .L481
	.loc 3 404 0
	adrp	x0, .LANCHOR56
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	cbz	x0, .L481
	.loc 3 409 0
	adrp	x0, .LANCHOR136
	ldr	x0, [x0, #:lo12:.LANCHOR136]
	cbz	x0, .L481
	.loc 3 414 0
	adrp	x0, .LANCHOR41
	ldr	x0, [x0, #:lo12:.LANCHOR41]
	cbz	x0, .L481
	.loc 3 419 0
	adrp	x0, .LANCHOR37+32
	ldr	x0, [x0, #:lo12:.LANCHOR37+32]
	cbz	x0, .L481
	.loc 3 425 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	cbz	x0, .L481
	.loc 3 430 0
	ldr	x0, [x17, #:lo12:.LANCHOR98]
	cbz	x0, .L481
	.loc 3 430 0 is_stmt 0 discriminator 1
	ldr	x0, [x16, #:lo12:.LANCHOR100]
	cbz	x0, .L481
	.loc 3 435 0 is_stmt 1
	ldr	x0, [x15, #:lo12:.LANCHOR120]
	cbz	x0, .L481
	.loc 3 435 0 is_stmt 0 discriminator 1
	ldr	x0, [x14, #:lo12:.LANCHOR122]
	cbz	x0, .L481
	.loc 3 435 0 discriminator 2
	ldr	x0, [x13, #:lo12:.LANCHOR112]
	cbz	x0, .L481
	.loc 3 435 0 discriminator 3
	ldr	x0, [x12, #:lo12:.LANCHOR95]
	cbz	x0, .L481
	.loc 3 435 0 discriminator 4
	ldr	x0, [x11, #:lo12:.LANCHOR121]
	cbz	x0, .L481
	.loc 3 440 0 is_stmt 1
	ldr	x0, [x10, #:lo12:.LANCHOR39]
	cbz	x0, .L481
	.loc 3 440 0 is_stmt 0 discriminator 1
	ldr	x0, [x8, #:lo12:.LANCHOR123]
	cbz	x0, .L481
	.loc 3 440 0 discriminator 2
	ldr	x0, [x7, #:lo12:.LANCHOR124]
	cbz	x0, .L481
	.loc 3 440 0 discriminator 3
	ldr	x0, [x6, #:lo12:.LANCHOR93]
	cbz	x0, .L481
	.loc 3 441 0 is_stmt 1
	ldr	x0, [x5, #:lo12:.LANCHOR116]
	cbz	x0, .L481
	.loc 3 441 0 is_stmt 0 discriminator 1
	ldr	x0, [x4, #:lo12:.LANCHOR114]
	cbz	x0, .L481
	.loc 3 441 0 discriminator 2
	ldr	x0, [x3, #:lo12:.LANCHOR92]
	cbz	x0, .L481
	.loc 3 446 0 is_stmt 1
	ldr	x0, [x24, #:lo12:.LANCHOR109]
	cbz	x0, .L481
	.loc 3 446 0 is_stmt 0 discriminator 1
	ldr	x0, [x23, #:lo12:.LANCHOR115]
	cbz	x0, .L481
	.loc 3 446 0 discriminator 2
	ldr	x0, [x22, #:lo12:.LANCHOR94]
	cbz	x0, .L481
	.loc 3 452 0 is_stmt 1
	ldr	x0, [x29, 200]
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	cbz	x0, .L481
	.loc 3 452 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR126
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	cbz	x0, .L481
	.loc 3 458 0 is_stmt 1
	adrp	x0, .LANCHOR36
	ldr	x0, [x0, #:lo12:.LANCHOR36]
	cbz	x0, .L481
	.loc 3 464 0
	adrp	x0, .LANCHOR131
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	cbz	x0, .L481
	.loc 3 470 0
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	cbz	x0, .L481
	.loc 3 476 0
	adrp	x0, .LANCHOR133
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	cbz	x0, .L481
	.loc 3 483 0
	mov	w0, 0
	b	.L474
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
.LVL799:
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
.LVL800:
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
.LVL801:
	mov	x0, x20
	bl	ftl_memset
.LVL802:
.L579:
	.loc 4 72 0
	ldrh	w0, [x22, x19]
	cmp	w0, w24
	beq	.L576
	.loc 4 74 0
	ldrh	w1, [x21]
	cmp	w1, w0
	bhi	.L578
	.loc 4 74 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 74
	mov	x1, x23
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL803:
.L578:
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
	bne	.L579
.L576:
	.loc 4 77 0
	ldp	x19, x20, [sp, 16]
.LVL804:
	ldp	x21, x22, [sp, 32]
.LVL805:
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
.LVL806:
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
.LVL807:
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
.LVL808:
	.loc 2 80 0
	strh	wzr, [x3, 4]
	.loc 2 81 0
	strh	wzr, [x3, 6]
	.loc 2 83 0
	bl	ftl_memset
.LVL809:
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
	.loc 2 442 0
	.cfi_startproc
.LVL810:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 2 446 0
	adrp	x23, .LANCHOR32
	.loc 2 442 0
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
	.loc 2 446 0
	ldrh	w0, [x23, #:lo12:.LANCHOR32]
.LVL811:
	cmp	w0, w21
	bcs	.L587
	.loc 2 446 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR140
.LVL812:
	adrp	x0, .LC1
	mov	w2, 446
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL813:
.L587:
	.loc 2 447 0 is_stmt 1
	adrp	x26, .LANCHOR134
	ubfiz	x0, x21, 2, 16
	adrp	x22, .LANCHOR56
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	ldr	w24, [x1, x0]
.LVL814:
	.loc 2 449 0
	cbnz	w24, .L588
	.loc 2 450 0
	ldr	x0, [x22, #:lo12:.LANCHOR56]
	lsl	x19, x19, 4
.LVL815:
	adrp	x1, .LANCHOR23
	add	x0, x0, x19
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
.LVL816:
	.loc 2 451 0
	ldr	x0, [x22, #:lo12:.LANCHOR56]
	add	x1, x0, x19
	strh	w21, [x0, x19]
	.loc 2 452 0
	str	wzr, [x1, 4]
.L589:
	.loc 2 473 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL817:
	ldp	x23, x24, [sp, 48]
.LVL818:
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
.LVL819:
.L588:
	.cfi_restore_state
	.loc 2 456 0
	ldr	x0, [x22, #:lo12:.LANCHOR56]
	lsl	x19, x19, 4
	.loc 2 455 0
	adrp	x20, .LANCHOR108
	add	x20, x20, :lo12:.LANCHOR108
	.loc 2 456 0
	add	x0, x0, x19
	.loc 2 458 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 455 0
	str	w24, [x20, 4]
	.loc 2 456 0
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	.loc 2 457 0
	adrp	x0, .LANCHOR109
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	str	x0, [x20, 16]
	.loc 2 458 0
	mov	x0, x20
	bl	FlashReadPages
.LVL820:
	.loc 2 459 0
	ldr	x25, [x20, 16]
.LVL821:
	.loc 2 461 0
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L590
	.loc 2 462 0
	mov	w2, w24
	mov	w1, w21
	adrp	x0, .LC83
	add	x0, x0, :lo12:.LC83
	bl	printf
.LVL822:
	.loc 2 463 0
	ldr	x1, [x20, 16]
	mov	w3, 4
	adrp	x0, .LC84
	mov	w2, w3
	add	x0, x0, :lo12:.LC84
	bl	rknand_print_hex
.LVL823:
	.loc 2 464 0
	ldrh	w3, [x23, #:lo12:.LANCHOR32]
	adrp	x0, .LC85
	ldr	x1, [x26, #:lo12:.LANCHOR134]
	mov	w2, 4
	add	x0, x0, :lo12:.LC85
	bl	rknand_print_hex
.LVL824:
.L590:
	.loc 2 467 0
	ldrh	w0, [x25, 8]
	cmp	w0, w21
	beq	.L591
	.loc 2 467 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR140
	adrp	x0, .LC1
	mov	w2, 467
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL825:
.L591:
	.loc 2 470 0 is_stmt 1
	ldr	x0, [x22, #:lo12:.LANCHOR56]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	.loc 2 471 0
	strh	w21, [x0, x19]
	.loc 2 472 0
	b	.L589
	.cfi_endproc
.LFE253:
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.ftl_free_no_use_map_blk,"ax",@progbits
	.align	2
	.global	ftl_free_no_use_map_blk
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
.LFB254:
	.loc 2 476 0
	.cfi_startproc
.LVL826:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	.loc 2 485 0
	mov	w1, 0
	.loc 2 476 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x0
	.loc 2 485 0
	ldrh	w2, [x0, 10]
	.loc 2 476 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 478 0
	ldp	x21, x20, [x0, 32]
	.loc 2 476 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 2 485 0
	lsl	w2, w2, 1
	.loc 2 477 0
	ldr	x23, [x0, 16]
.LVL827:
	.loc 2 485 0
	mov	x0, x21
.LVL828:
	bl	ftl_memset
.LVL829:
	.loc 2 486 0
	mov	w0, 0
.LVL830:
.L594:
	.loc 2 486 0 is_stmt 0 discriminator 1
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L598
	.loc 2 494 0 is_stmt 1
	ldrh	w26, [x21]
.LVL831:
	.loc 2 498 0
	adrp	x24, .LANCHOR20
	add	x24, x24, :lo12:.LANCHOR20
	.loc 2 495 0
	mov	w25, 0
	.loc 2 497 0
	mov	w20, 0
.LVL832:
.L599:
	.loc 2 497 0 is_stmt 0 discriminator 1
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L603
	.loc 2 513 0 is_stmt 1
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
.LVL833:
	ldp	x21, x22, [sp, 32]
.LVL834:
	ldp	x23, x24, [sp, 48]
.LVL835:
	ldp	x25, x26, [sp, 64]
.LVL836:
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
.LVL837:
.L598:
	.cfi_restore_state
	.loc 2 487 0
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	.loc 2 488 0
	mov	w1, 0
	.loc 2 487 0
	ubfx	x2, x2, 10, 16
.LVL838:
.L595:
	.loc 2 488 0 discriminator 1
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L597
	.loc 2 486 0 discriminator 2
	add	w0, w0, 1
.LVL839:
	and	w0, w0, 65535
.LVL840:
	b	.L594
.L597:
	.loc 2 489 0
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x23, x3]
	cmp	w4, w2
	bne	.L596
	.loc 2 490 0
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L596:
	.loc 2 488 0 discriminator 2
	add	w1, w1, 1
.LVL841:
	and	w1, w1, 65535
.LVL842:
	b	.L595
.LVL843:
.L603:
	.loc 2 498 0
	ldrh	w0, [x19]
	uxtw	x22, w20
	cmp	w0, w20
	bne	.L600
	.loc 2 498 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bcs	.L600
	.loc 2 499 0 is_stmt 1
	strh	w0, [x21, x22, lsl 1]
.L600:
	.loc 2 500 0
	lsl	x22, x22, 1
	ldrh	w0, [x21, x22]
	cmp	w26, w0
	bls	.L601
	mov	w25, w20
.LVL844:
	mov	w26, w0
.LVL845:
.L601:
	.loc 2 504 0
	cbnz	w0, .L602
	.loc 2 504 0 is_stmt 0 discriminator 1
	ldrh	w0, [x23, x22]
	cbz	w0, .L602
	.loc 2 506 0 is_stmt 1
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.LVL846:
	.loc 2 507 0
	strh	wzr, [x23, x22]
	.loc 2 508 0
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
.L602:
	.loc 2 497 0 discriminator 2
	add	w20, w20, 1
.LVL847:
	and	w20, w20, 65535
.LVL848:
	b	.L599
	.cfi_endproc
.LFE254:
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
.LFB257:
	.loc 2 583 0
	.cfi_startproc
.LVL849:
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 591 0
	mov	w1, 65535
	.loc 2 583 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	.loc 2 586 0
	ldr	x20, [x0, 16]
.LVL850:
	.loc 2 583 0
	stp	x21, x22, [sp, 32]
	.loc 2 591 0
	ldrh	w0, [x0]
.LVL851:
	.loc 2 583 0
	str	x23, [sp, 48]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.loc 2 591 0
	cmp	w0, w1
	bne	.L609
	.loc 2 592 0
	ldrh	w0, [x19, 8]
	cbz	w0, .L610
	.loc 2 592 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR141
	adrp	x0, .LC1
	mov	w2, 592
	add	x1, x1, :lo12:.LANCHOR141
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL852:
.L610:
	.loc 2 593 0 is_stmt 1
	ldrh	w0, [x19, 8]
	add	w0, w0, 1
	strh	w0, [x19, 8]
	.loc 2 594 0
	bl	FtlFreeSysBlkQueueOut
.LVL853:
	strh	w0, [x20]
	.loc 2 597 0
	ldr	w0, [x19, 48]
	.loc 2 595 0
	strh	wzr, [x19, 2]
	.loc 2 597 0
	add	w0, w0, 1
	.loc 2 596 0
	strh	wzr, [x19]
	.loc 2 597 0
	str	w0, [x19, 48]
.LVL854:
.L611:
	.loc 2 628 0
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
.LVL855:
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
.LVL856:
.L609:
	.cfi_restore_state
	.loc 2 601 0
	ubfiz	x0, x0, 1, 16
	.loc 2 604 0
	adrp	x1, .LANCHOR109
	.loc 2 603 0
	adrp	x23, .LANCHOR39
	.loc 2 587 0
	ldr	x22, [x19, 40]
	.loc 2 604 0
	ldr	x1, [x1, #:lo12:.LANCHOR109]
	.loc 2 601 0
	ldrh	w21, [x20, x0]
	.loc 2 602 0
	adrp	x20, .LANCHOR108
.LVL857:
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR108
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	.loc 2 603 0
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	.loc 2 604 0
	str	x1, [x2, 16]
.LVL858:
	.loc 2 603 0
	str	x0, [x2, 8]
	.loc 2 607 0
	ldr	w2, [x19, 48]
	str	w2, [x1, 4]
	.loc 2 608 0
	mov	w2, -1291
	strh	w2, [x1, 8]
	.loc 2 609 0
	ldrh	w2, [x19, 4]
	strh	w2, [x1]
	.loc 2 610 0
	strh	w21, [x1, 2]
	.loc 2 612 0
	adrp	x1, .LANCHOR20
.LVL859:
	ldrh	w2, [x1, #:lo12:.LANCHOR20]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
.LVL860:
	.loc 2 614 0
	ldrh	w4, [x19, 6]
	mov	x1, 0
	.loc 2 617 0
	ldr	x3, [x23, #:lo12:.LANCHOR39]
	.loc 2 613 0
	mov	w2, 0
.LVL861:
.L612:
	.loc 2 614 0 discriminator 1
	cmp	w4, w1, uxth
	bhi	.L614
	.loc 2 621 0
	mov	w2, 1
.LVL862:
	mov	w3, 0
	mov	w1, w2
.LVL863:
	add	x0, x20, :lo12:.LANCHOR108
	bl	FlashProgPages
.LVL864:
	.loc 2 622 0
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 626 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL865:
	.loc 2 627 0
	b	.L611
.LVL866:
.L614:
	.loc 2 615 0
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L613
	.loc 2 616 0
	add	w2, w2, 1
.LVL867:
	and	w2, w2, 65535
.LVL868:
	.loc 2 617 0
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	.loc 2 618 0
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L613:
.LVL869:
	add	x1, x1, 1
.LVL870:
	b	.L612
	.cfi_endproc
.LFE257:
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",@progbits
	.align	2
	.global	FtlMapWritePage
	.type	FtlMapWritePage, %function
FtlMapWritePage:
.LFB258:
	.loc 2 631 0
	.cfi_startproc
.LVL871:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 637 0
	adrp	x23, .LANCHOR67
	.loc 2 631 0
	stp	x25, x26, [sp, 64]
	.loc 2 650 0
	adrp	x24, .LANCHOR142
	.loc 2 631 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 638 0
	adrp	x26, .LANCHOR20
	.loc 2 631 0
	stp	x19, x20, [sp, 16]
	mov	w25, w1
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x19, x0
	mov	x27, x2
	.loc 2 637 0
	add	x23, x23, :lo12:.LANCHOR67
	.loc 2 650 0
	add	x24, x24, :lo12:.LANCHOR142
	.loc 2 671 0
	add	x28, x26, :lo12:.LANCHOR20
	.loc 2 631 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 634 0
	mov	w22, 0
.LVL872:
.L620:
	.loc 2 637 0
	ldr	w0, [x23]
	.loc 2 638 0
	ldrh	w1, [x19, 2]
	.loc 2 637 0
	add	w0, w0, 1
	str	w0, [x23]
	.loc 2 638 0
	ldrh	w0, [x26, #:lo12:.LANCHOR20]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L621
	.loc 2 638 0 is_stmt 0 discriminator 1
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L622
.L621:
	.loc 2 639 0 is_stmt 1
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.LVL873:
.L622:
	.loc 2 650 0
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L623
	.loc 2 650 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 650
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL874:
.L623:
	.loc 2 651 0 is_stmt 1
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L624
	.loc 2 651 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 651
	mov	x1, x24
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL875:
.L624:
	.loc 2 652 0 is_stmt 1
	ldrh	w1, [x19]
	.loc 2 654 0
	adrp	x21, .LANCHOR108
	.loc 2 652 0
	ldr	x0, [x19, 16]
	.loc 2 654 0
	add	x20, x21, :lo12:.LANCHOR108
	.loc 2 658 0
	mov	w2, 16
	.loc 2 652 0
	ldrh	w3, [x0, x1, lsl 1]
.LVL876:
	.loc 2 658 0
	mov	w1, 0
	.loc 2 654 0
	ldrh	w0, [x19, 2]
	str	w3, [x29, 108]
	.loc 2 655 0
	str	x27, [x20, 8]
	.loc 2 654 0
	orr	w0, w0, w3, lsl 10
	str	w0, [x20, 4]
	.loc 2 656 0
	adrp	x0, .LANCHOR109
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	str	x0, [x20, 16]
	.loc 2 658 0
	bl	ftl_memset
.LVL877:
	.loc 2 659 0
	ldr	x0, [x20, 16]
.LVL878:
	.loc 2 660 0
	ldr	w1, [x19, 48]
	.loc 2 663 0
	ldr	w3, [x29, 108]
	.loc 2 660 0
	str	w1, [x0, 4]
	.loc 2 662 0
	ldrh	w1, [x19, 4]
	strh	w1, [x0]
	.loc 2 663 0
	strh	w3, [x0, 2]
	.loc 2 664 0
	mov	w3, 1
	.loc 2 661 0
	strh	w25, [x0, 8]
	.loc 2 664 0
	mov	w1, w3
	mov	w2, w3
	mov	x0, x20
.LVL879:
	bl	FlashProgPages
.LVL880:
	.loc 2 665 0
	ldrh	w0, [x19, 2]
	.loc 2 667 0
	ldr	w1, [x21, #:lo12:.LANCHOR108]
	.loc 2 665 0
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	.loc 2 667 0
	cmn	w1, #1
	bne	.L625
	.loc 2 668 0
	ldr	w1, [x20, 4]
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	.loc 2 669 0
	add	w22, w22, 1
.LVL881:
	and	w22, w22, 65535
	.loc 2 668 0
	bl	printf
.LVL882:
	.loc 2 670 0
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L626
	.loc 2 671 0
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L626:
	.loc 2 673 0
	cmp	w22, 3
	bls	.L627
	.loc 2 674 0
	add	x21, x21, :lo12:.LANCHOR108
	adrp	x0, .LC87
	mov	w2, w22
	add	x0, x0, :lo12:.LC87
	ldr	w1, [x21, 4]
	bl	printf
.LVL883:
.L628:
	b	.L628
.L627:
	.loc 2 678 0
	ldr	w0, [x19, 52]
	cbz	w0, .L620
.L637:
	b	.L637
.L625:
	.loc 2 682 0
	cmp	w0, 1
	beq	.L620
	.loc 2 685 0
	ldr	x0, [x19, 40]
	ldr	w1, [x20, 4]
	.loc 2 687 0
	ldp	x21, x22, [sp, 32]
.LVL884:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
.LVL885:
	.loc 2 685 0
	str	w1, [x0, w25, uxtw 2]
	.loc 2 687 0
	ldp	x19, x20, [sp, 16]
.LVL886:
	mov	w0, 0
	ldp	x25, x26, [sp, 64]
.LVL887:
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
.LVL888:
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
	.loc 2 537 0
	.cfi_startproc
.LVL889:
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
	.loc 2 541 0
	ldr	x20, [x0, 16]
.LVL890:
	.loc 2 542 0
	ldr	x24, [x0, 40]
.LVL891:
	.loc 2 545 0
	bl	ftl_free_no_use_map_blk
.LVL892:
	.loc 2 547 0
	ldrh	w1, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w1, #4
	cmp	w2, w1
	blt	.L640
	.loc 2 548 0
	ubfiz	x0, x0, 1, 16
.LVL893:
	ldrh	w21, [x20, x0]
.LVL894:
	.loc 2 549 0
	cbz	w21, .L640
	.loc 2 549 0 is_stmt 0 discriminator 1
	ldr	w1, [x19, 52]
	cbnz	w1, .L640
	.loc 2 550 0 is_stmt 1
	mov	w1, 1
	str	w1, [x19, 52]
	.loc 2 551 0
	strh	wzr, [x20, x0]
	.loc 2 552 0
	ldrh	w0, [x19, 8]
	.loc 2 553 0
	ldrh	w1, [x19, 2]
	.loc 2 552 0
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	.loc 2 553 0
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L641
	.loc 2 554 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL895:
.L641:
	.loc 2 558 0 discriminator 1
	adrp	x25, .LANCHOR108
	.loc 2 564 0 discriminator 1
	adrp	x22, .LANCHOR143
	.loc 2 565 0 discriminator 1
	add	x26, x25, :lo12:.LANCHOR108
	.loc 2 564 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR143
	.loc 2 537 0 discriminator 1
	mov	w20, 0
.LVL896:
.L642:
	.loc 2 556 0 discriminator 1
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L646
	.loc 2 572 0
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
.LVL897:
	.loc 2 573 0
	str	wzr, [x19, 52]
.LVL898:
.L640:
	.loc 2 577 0
	ldrh	w1, [x19, 2]
	ldrh	w0, [x23, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bcc	.L647
	.loc 2 578 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL899:
.L647:
	.loc 2 580 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL900:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL901:
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
.LVL902:
.L646:
	.cfi_restore_state
	.loc 2 557 0
	ubfiz	x27, x20, 2, 16
	ldr	w1, [x24, x27]
	cmp	w21, w1, lsr 10
	bne	.L643
	.loc 2 558 0
	adrp	x2, .LANCHOR123
	add	x0, x25, :lo12:.LANCHOR108
	ldr	x2, [x2, #:lo12:.LANCHOR123]
	str	x2, [x0, 8]
	.loc 2 559 0
	adrp	x2, .LANCHOR109
	.loc 2 560 0
	str	w1, [x0, 4]
	.loc 2 559 0
	ldr	x28, [x2, #:lo12:.LANCHOR109]
.LVL903:
	.loc 2 562 0
	mov	w2, 1
	.loc 2 559 0
	str	x28, [x0, 16]
	.loc 2 562 0
	mov	w1, w2
	bl	FlashReadPages
.LVL904:
	.loc 2 564 0
	ldrh	w0, [x28, 8]
	cmp	w0, w20
	beq	.L644
	.loc 2 564 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 564
	mov	x1, x22
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL905:
.L644:
	.loc 2 565 0 is_stmt 1
	ldr	w0, [x26]
	cmn	w0, #1
	bne	.L645
	.loc 2 566 0
	str	wzr, [x24, x27]
.LVL906:
.L643:
	.loc 2 556 0 discriminator 2
	add	w20, w20, 1
.LVL907:
	and	w20, w20, 65535
.LVL908:
	b	.L642
.LVL909:
.L645:
	.loc 2 568 0
	ldr	x2, [x26, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.LVL910:
	b	.L643
	.cfi_endproc
.LFE256:
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
.LFB259:
	.loc 2 690 0
	.cfi_startproc
.LVL911:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 693 0
	adrp	x20, .LANCHOR56
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR56]
.LVL912:
	add	x1, x0, x19
.LVL913:
	.loc 2 694 0
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
.LVL914:
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapWritePage
.LVL915:
	.loc 2 695 0
	ldr	x0, [x20, #:lo12:.LANCHOR56]
	add	x0, x0, x19
	.loc 2 697 0
	ldp	x19, x20, [sp, 16]
	.loc 2 695 0
	ldr	w1, [x0, 4]
	and	w1, w1, 2147483647
	str	w1, [x0, 4]
	.loc 2 697 0
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
	.loc 2 753 0
	.cfi_startproc
.LVL916:
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
	.loc 2 756 0
	adrp	x1, .LANCHOR22
.LVL917:
	.loc 2 753 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w24, w2
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 756 0
	ldrh	w19, [x1, #:lo12:.LANCHOR22]
	.loc 2 753 0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	.loc 2 756 0
	add	w1, w19, 7
	.loc 2 757 0
	mov	x19, 1
	.loc 2 756 0
	lsr	w22, w0, w1
	and	w22, w22, 65535
.LVL918:
	.loc 2 757 0
	lsl	x19, x19, x1
	.loc 2 759 0
	adrp	x1, .LANCHOR62
	.loc 2 757 0
	sub	w19, w19, #1
	.loc 2 759 0
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	.loc 2 757 0
	and	w19, w19, w0
	and	x19, x19, 65535
.LVL919:
	.loc 2 759 0
	cmp	w0, w1
	bcc	.L655
	.loc 2 759 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR145
	adrp	x0, .LC1
.LVL920:
	mov	w2, 759
.LVL921:
	add	x1, x1, :lo12:.LANCHOR145
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL922:
.L655:
	.loc 2 762 0 is_stmt 1
	adrp	x21, .LANCHOR56
	.loc 2 761 0
	adrp	x0, .LANCHOR33
	.loc 2 762 0
	ldr	x2, [x21, #:lo12:.LANCHOR56]
	.loc 2 761 0
	ldrh	w1, [x0, #:lo12:.LANCHOR33]
	mov	x0, 0
.LVL923:
.L656:
	and	x20, x0, 65535
.LVL924:
	.loc 2 761 0 is_stmt 0 discriminator 1
	cmp	w20, w1
	bcc	.L661
	.loc 2 776 0 is_stmt 1
	bl	select_l2p_ram_region
.LVL925:
	and	x20, x0, 65535
.LVL926:
	.loc 2 777 0
	ldr	x2, [x21, #:lo12:.LANCHOR56]
	ubfiz	x1, x20, 4, 16
	.loc 2 776 0
	mov	w25, w0
	.loc 2 777 0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L662
	.loc 2 777 0 is_stmt 0 discriminator 1
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L662
	.loc 2 778 0 is_stmt 1
	bl	flush_l2p_region
.LVL927:
.L662:
	.loc 2 781 0
	mov	w1, w25
	mov	w0, w22
	bl	load_l2p_region
.LVL928:
	.loc 2 782 0
	b	.L657
.LVL929:
.L661:
	add	x0, x0, 1
	.loc 2 762 0
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L656
.LVL930:
.L657:
	.loc 2 765 0
	ldr	x0, [x21, #:lo12:.LANCHOR56]
	add	x0, x0, x20, lsl 4
	.loc 2 764 0
	cbnz	w24, .L658
	.loc 2 765 0
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x19, lsl 2]
	str	w0, [x23]
.L659:
	.loc 2 771 0
	ldr	x0, [x21, #:lo12:.LANCHOR56]
	add	x20, x0, x20, lsl 4
.LVL931:
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L664
	.loc 2 772 0
	add	w0, w0, 1
	str	w0, [x20, 4]
.L664:
	.loc 2 783 0
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
.LVL932:
	ldp	x21, x22, [sp, 32]
.LVL933:
	ldp	x23, x24, [sp, 48]
.LVL934:
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
.LVL935:
.L658:
	.cfi_restore_state
	.loc 2 767 0
	ldr	x1, [x0, 8]
	ldr	w2, [x23]
	str	w2, [x1, x19, lsl 2]
	.loc 2 768 0
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	.loc 2 769 0
	adrp	x0, .LANCHOR57
	strh	w22, [x0, #:lo12:.LANCHOR57]
	b	.L659
	.cfi_endproc
.LFE262:
	.size	log2phys, .-log2phys
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
.LFB280:
	.loc 2 1628 0
	.cfi_startproc
.LVL936:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.loc 2 1631 0
	adrp	x22, .LANCHOR43
	.loc 2 1628 0
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	.loc 2 1629 0
	lsr	w0, w1, 10
.LVL937:
	.loc 2 1628 0
	str	x23, [sp, 48]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 23, -32
	.loc 2 1629 0
	bl	P2V_block_in_plane
.LVL938:
	.loc 2 1631 0
	ldr	x2, [x22, #:lo12:.LANCHOR43]
	.loc 2 1629 0
	and	w3, w0, 65535
.LVL939:
	.loc 2 1631 0
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L670
	.loc 2 1632 0
	adrp	x0, .LANCHOR47
.LVL940:
	ldr	x19, [x0, #:lo12:.LANCHOR47]
	cbz	x19, .L671
.LBB225:
	.loc 2 1636 0
	adrp	x2, .LANCHOR41
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	.loc 2 1635 0
	adrp	x23, .LANCHOR48
	.loc 2 1636 0
	ldr	x2, [x2, #:lo12:.LANCHOR41]
	.loc 2 1644 0
	mov	w6, 65535
	.loc 2 1635 0
	ldrh	w4, [x23, #:lo12:.LANCHOR48]
.LVL941:
	.loc 2 1636 0
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	.loc 2 1644 0
	mov	w5, 6
	.loc 2 1636 0
	and	w19, w19, 65535
.LVL942:
.L672:
	.loc 2 1637 0 discriminator 1
	cmp	w1, w4
	beq	.L671
	.loc 2 1638 0
	cmp	w19, w3
	bne	.L673
	.loc 2 1639 0
	mov	w1, w19
.LVL943:
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_remove_node
.LVL944:
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	cbnz	w0, .L674
	.loc 2 1639 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR146
	adrp	x0, .LC1
	mov	w2, 1639
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL945:
.L674:
	.loc 2 1639 0 discriminator 3
	ldrh	w0, [x23, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR48]
	.loc 2 1640 0 is_stmt 1 discriminator 3
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL946:
	.loc 2 1641 0 discriminator 3
	ldr	x1, [x22, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.LVL947:
.L671:
.LBE225:
	.loc 2 1652 0
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
.LVL948:
	.loc 2 1653 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL949:
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
.LVL950:
.L673:
	.cfi_restore_state
.LBB226:
	.loc 2 1644 0
	umull	x19, w19, w5
.LVL951:
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L671
.LVL952:
	.loc 2 1637 0 discriminator 2
	add	w1, w1, 1
.LVL953:
	and	w1, w1, 65535
.LVL954:
	b	.L672
.LVL955:
.L670:
.LBE226:
	.loc 2 1650 0
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L671
	.cfi_endproc
.LFE280:
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
.LFB291:
	.loc 2 2275 0
	.cfi_startproc
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	.loc 2 2280 0
	adrp	x0, .LC88
	mov	w1, 0
	add	x0, x0, :lo12:.LC88
	.loc 2 2275 0
	stp	x29, x30, [sp, 16]
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 16
	.cfi_def_cfa 29, 80
	stp	x19, x20, [sp, 32]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.loc 2 2286 0
	adrp	x20, .LANCHOR108
	.loc 2 2275 0
	stp	x21, x22, [sp, 48]
	.loc 2 2281 0
	mov	w19, 0
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	adrp	x21, .LANCHOR62
	.loc 2 2297 0
	add	x22, x20, :lo12:.LANCHOR108
	.loc 2 2281 0
	add	x21, x21, :lo12:.LANCHOR62
	.loc 2 2275 0
	str	x23, [sp, 64]
	.cfi_offset 23, -32
	.loc 2 2280 0
	bl	printf
.LVL956:
.L681:
	.loc 2 2281 0 discriminator 1
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L687
	.loc 2 2303 0
	ldp	x19, x20, [sp, 32]
.LVL957:
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
.LVL958:
.L687:
	.cfi_restore_state
	.loc 2 2282 0
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
.LVL959:
	.loc 2 2283 0
	tst	x19, 2047
	bne	.L682
	.loc 2 2284 0
	ldr	w2, [x29, 76]
	adrp	x0, .LC89
	mov	w1, w19
	add	x0, x0, :lo12:.LC89
	bl	printf
.LVL960:
.L682:
	.loc 2 2285 0
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L684
	.loc 2 2286 0
	add	x0, x20, :lo12:.LANCHOR108
	.loc 2 2290 0
	str	wzr, [x20, #:lo12:.LANCHOR108]
	.loc 2 2292 0
	mov	w2, 0
	.loc 2 2286 0
	str	w1, [x0, 4]
	.loc 2 2288 0
	adrp	x1, .LANCHOR39
	.loc 2 2287 0
	str	w19, [x0, 24]
	.loc 2 2288 0
	ldr	x1, [x1, #:lo12:.LANCHOR39]
	str	x1, [x0, 8]
	.loc 2 2289 0
	adrp	x1, .LANCHOR109
	ldr	x23, [x1, #:lo12:.LANCHOR109]
.LVL961:
	.loc 2 2292 0
	mov	w1, 1
	.loc 2 2289 0
	str	x23, [x0, 16]
	.loc 2 2292 0
	bl	FlashReadPages
.LVL962:
	.loc 2 2293 0
	ldr	w0, [x20, #:lo12:.LANCHOR108]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L685
	.loc 2 2294 0
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L684
.L685:
	.loc 2 2297 0
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC90
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC90
	mov	w1, w19
	bl	printf
.LVL963:
.L684:
	.loc 2 2281 0 discriminator 2
	add	w19, w19, 1
.LVL964:
	b	.L681
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
.LVL965:
	.loc 5 425 0
	adrp	x1, .LANCHOR83
	add	x0, x1, :lo12:.LANCHOR83
	ldr	w2, [x0, 80]
	cbz	w2, .L690
	.loc 5 426 0
	adrp	x1, .LANCHOR62
	ldr	w3, [x0, 84]
	ldr	w2, [x1, #:lo12:.LANCHOR62]
	cmp	w3, w2
	bcs	.L691
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
.LBB232:
.LBB233:
	.loc 5 428 0
	mov	x19, x0
	add	x20, x1, :lo12:.LANCHOR62
.LBE233:
.LBE232:
	.loc 5 419 0
	str	x21, [sp, 32]
	.cfi_offset 21, -128
	mov	w21, 2048
.L696:
.LVL966:
.LBB238:
.LBB235:
	.loc 5 428 0
	ldr	w0, [x19, 84]
	ldr	w1, [x20]
	cmp	w0, w1
	bcs	.L693
	.loc 5 430 0
	add	x1, x29, 60
	mov	w2, 0
	bl	log2phys
.LVL967:
	.loc 5 431 0
	ldr	w0, [x19, 84]
	.loc 5 432 0
	ldr	w1, [x29, 60]
	.loc 5 431 0
	add	w0, w0, 1
	str	w0, [x19, 84]
	.loc 5 432 0
	cmn	w1, #1
	beq	.L694
.LBB234:
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
.LVL968:
	.loc 5 440 0
	ldr	w0, [x29, 64]
	cmp	w0, 256
	bne	.L693
	.loc 5 442 0
	ldr	w0, [x29, 60]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL969:
	bl	FtlGcRefreshBlock
.LVL970:
.L693:
.LBE234:
.LBE235:
.LBE238:
	.loc 5 466 0
	ldp	x19, x20, [sp, 16]
.LBB239:
.LBB236:
	mov	w0, -1
.LBE236:
.LBE239:
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
.LVL971:
.L694:
	.cfi_restore_state
.LBB240:
.LBB237:
	.loc 5 427 0
	subs	w21, w21, #1
.LVL972:
	bne	.L696
	b	.L693
.LVL973:
.L691:
	.cfi_def_cfa 31, 0
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 29
	.cfi_restore 30
.LBE237:
.LBE240:
	.loc 5 451 0
	adrp	x1, .LANCHOR63
	.loc 5 450 0
	str	wzr, [x0, 84]
	.loc 5 451 0
	ldr	w1, [x1, #:lo12:.LANCHOR63]
	.loc 5 449 0
	stp	w1, wzr, [x0, 76]
.L700:
	.loc 5 420 0
	mov	w0, 0
	.loc 5 465 0
	ret
.L690:
.LVL974:
.LBB241:
	.loc 5 456 0
	ldr	w4, [x0, 76]
	adrp	x0, .LANCHOR63
	ldr	w2, [x0, #:lo12:.LANCHOR63]
	add	w0, w2, 1048576
	cmp	w4, w0
	bhi	.L699
	.loc 5 454 0
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	lsr	w3, w0, 10
	mov	w0, 33554432
	asr	w0, w0, w3
	.loc 5 457 0
	add	w0, w0, w4
	cmp	w2, w0
	bhi	.L699
	.loc 5 458 0
	adrp	x0, .LANCHOR79+28
	ldrb	w0, [x0, #:lo12:.LANCHOR79+28]
	cbnz	w0, .L700
.L699:
	.loc 5 460 0
	add	x0, x1, :lo12:.LANCHOR83
	mov	w1, 1
	.loc 5 461 0
	str	wzr, [x0, 84]
	.loc 5 460 0
	stp	w2, w1, [x0, 76]
	b	.L700
.LBE241:
	.cfi_endproc
.LFE318:
	.size	FtlReadRefresh, .-FtlReadRefresh
	.section	.text.FtlMapBlkWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDump_data
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
.LFB267:
	.loc 2 897 0
	.cfi_startproc
.LVL975:
	.loc 2 903 0
	ldr	w1, [x0, 56]
	cbz	w1, .L706
	.loc 2 897 0
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
.LVL976:
	.loc 2 907 0
	adrp	x1, .LANCHOR108
	.loc 2 908 0
	adrp	x2, .LANCHOR109
	.loc 2 897 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	.loc 2 899 0
	ldrh	w20, [x0, 6]
	.loc 2 907 0
	adrp	x0, .LANCHOR123
.LVL977:
	.loc 2 908 0
	ldr	x2, [x2, #:lo12:.LANCHOR109]
	.loc 2 907 0
	ldr	x3, [x0, #:lo12:.LANCHOR123]
	add	x0, x1, :lo12:.LANCHOR108
	.loc 2 899 0
	sub	w20, w20, #1
	.loc 2 900 0
	ldr	x4, [x19, 40]
	.loc 2 899 0
	and	w20, w20, 65535
	.loc 2 897 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 908 0
	stp	x3, x2, [x0, 8]
	.loc 2 930 0
	ubfiz	x2, x20, 2, 16
	.loc 2 905 0
	str	wzr, [x19, 56]
	mov	x21, x1
	.loc 2 930 0
	ldr	w2, [x4, x2]
.LVL978:
	.loc 2 931 0
	str	w2, [x0, 4]
	.loc 2 932 0
	cbz	w2, .L708
	.loc 2 934 0
	mov	w2, 1
.LVL979:
	mov	w1, w2
	bl	FlashReadPages
.LVL980:
.L709:
	.loc 2 941 0
	add	x1, x21, :lo12:.LANCHOR108
	mov	x0, x19
	.loc 2 943 0
	ldr	x21, [sp, 32]
	.loc 2 941 0
	ldr	x2, [x1, 8]
	mov	w1, w20
	.loc 2 943 0
	ldp	x19, x20, [sp, 16]
.LVL981:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	.loc 2 941 0
	b	FtlMapWritePage
.LVL982:
.L708:
	.cfi_restore_state
	.loc 2 938 0
	adrp	x0, .LANCHOR23
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR23]
.LVL983:
	mov	x0, x3
	bl	ftl_memset
.LVL984:
	b	.L709
.LVL985:
.L706:
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
	.loc 2 1095 0
	.cfi_startproc
	stp	x29, x30, [sp, -176]!
	.cfi_def_cfa_offset 176
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	.loc 2 1103 0
	mov	w1, 0
	.loc 2 1095 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	.loc 2 1103 0
	adrp	x25, .LANCHOR135
	.loc 2 1095 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	.loc 2 1103 0
	adrp	x21, .LANCHOR30
	ldr	x0, [x25, #:lo12:.LANCHOR135]
	.loc 2 1105 0
	adrp	x22, .LANCHOR132
	.loc 2 1103 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	.loc 2 1095 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	.loc 2 1101 0
	adrp	x20, .LANCHOR147
	.loc 2 1095 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	.loc 2 1102 0
	adrp	x23, .LANCHOR35
	.loc 2 1095 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	.loc 2 1104 0
	adrp	x27, .LANCHOR129
	.loc 2 1103 0
	lsl	w2, w2, 2
	.loc 2 1101 0
	strh	wzr, [x20, #:lo12:.LANCHOR147]
	.loc 2 1102 0
	strh	wzr, [x23, #:lo12:.LANCHOR35]
	.loc 2 1103 0
	bl	ftl_memset
.LVL986:
	.loc 2 1104 0
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	.loc 2 1105 0
	adrp	x19, .LANCHOR27
	.loc 2 1106 0
	adrp	x28, .LANCHOR36
	.loc 2 1107 0
	adrp	x24, .LANCHOR81
	.loc 2 1104 0
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL987:
	.loc 2 1105 0
	ldr	x0, [x22, #:lo12:.LANCHOR132]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 2
	bl	ftl_memset
.LVL988:
	.loc 2 1106 0
	ldr	x0, [x28, #:lo12:.LANCHOR36]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL989:
	.loc 2 1107 0
	mov	w2, 12
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR81
	bl	ftl_memset
.LVL990:
	.loc 2 1109 0
	adrp	x0, .LANCHOR5
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	str	w0, [x29, 172]
.LVL991:
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 120]
	.loc 2 1152 0
	adrp	x0, .LANCHOR71
	add	x0, x0, :lo12:.LANCHOR71
	str	x0, [x29, 112]
.L714:
	.loc 2 1109 0 discriminator 1
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L754
	.loc 2 1113 0 discriminator 1
	adrp	x0, .LANCHOR3
	.loc 2 1118 0 discriminator 1
	adrp	x25, .LANCHOR120
	.loc 2 1115 0 discriminator 1
	adrp	x6, .LANCHOR13
	.loc 2 1120 0 discriminator 1
	mov	x5, 0
	.loc 2 1113 0 discriminator 1
	ldrh	w12, [x0, #:lo12:.LANCHOR3]
	.loc 2 1119 0 discriminator 1
	adrp	x0, .LANCHOR93
	.loc 2 1118 0 discriminator 1
	ldr	x7, [x25, #:lo12:.LANCHOR120]
	.loc 2 1120 0 discriminator 1
	mov	w22, 0
	.loc 2 1119 0 discriminator 1
	ldr	x11, [x0, #:lo12:.LANCHOR93]
	.loc 2 1120 0 discriminator 1
	adrp	x0, .LANCHOR94
	.loc 2 1115 0 discriminator 1
	add	x6, x6, :lo12:.LANCHOR13
	.loc 2 1120 0 discriminator 1
	ldr	x10, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR24
	ldrh	w8, [x0, #:lo12:.LANCHOR24]
	b	.L755
.LVL992:
.L716:
	.loc 2 1115 0
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
.LVL993:
	and	w4, w0, 65535
.LVL994:
	.loc 2 1116 0
	bl	FtlBbmIsBadBlock
.LVL995:
	cbnz	w0, .L715
	.loc 2 1118 0
	ubfiz	x0, x22, 5, 16
	.loc 2 1120 0
	mul	w1, w22, w8
	.loc 2 1118 0
	add	x0, x7, x0
	.loc 2 1121 0
	add	w22, w22, 1
.LVL996:
	and	w22, w22, 65535
.LVL997:
	.loc 2 1118 0
	lsl	w4, w4, 10
.LVL998:
	.loc 2 1120 0
	asr	w1, w1, 2
	add	x1, x10, x1, sxtw 2
	.loc 2 1118 0
	str	w4, [x0, 4]
	.loc 2 1120 0
	stp	x11, x1, [x0, 8]
.L715:
.LVL999:
	add	x5, x5, 1
.LVL1000:
.L755:
	.loc 2 1113 0 discriminator 1
	cmp	w12, w5, uxth
	bhi	.L716
	.loc 2 1124 0
	cbnz	w22, .L717
.LVL1001:
.L753:
	.loc 2 1109 0
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
.LVL1002:
	b	.L714
.LVL1003:
.L717:
	.loc 2 1127 0
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
.LVL1004:
	ubfiz	x0, x22, 5, 16
	mov	x22, 0
.LVL1005:
	str	x0, [x29, 128]
.LVL1006:
	.loc 2 1162 0
	adrp	x0, .LANCHOR148
	add	x0, x0, :lo12:.LANCHOR148
	str	x0, [x29, 136]
.L752:
	.loc 2 1129 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x1, x0, x22
	.loc 2 1132 0
	ldr	w0, [x0, x22]
	.loc 2 1129 0
	ldr	w3, [x1, 4]
	.loc 2 1132 0
	cmn	w0, #1
	.loc 2 1130 0
	ldr	x27, [x1, 16]
	.loc 2 1129 0
	ubfx	x26, x3, 10, 16
.LVL1007:
	.loc 2 1132 0
	bne	.L720
	mov	w5, 16
	.loc 2 1136 0
	mov	w7, 65535
.L722:
	.loc 2 1134 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	add	x6, x25, :lo12:.LANCHOR120
	.loc 2 1135 0
	mov	w2, 1
	str	w7, [x29, 100]
	.loc 2 1134 0
	add	x0, x0, x22
	str	x6, [x29, 104]
	str	w5, [x29, 168]
.LVL1008:
	ldr	w1, [x0, 4]
	add	w1, w1, 1
	str	w1, [x0, 4]
	.loc 2 1135 0
	mov	w1, w2
	bl	FlashReadPages
.LVL1009:
	.loc 2 1136 0
	ldrh	w0, [x27]
	ldr	w7, [x29, 100]
	ldr	w5, [x29, 168]
	cmp	w0, w7
	ldr	x6, [x29, 104]
	bne	.L719
	.loc 2 1137 0
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	.loc 2 1145 0
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	bne	.L720
.LVL1010:
.L721:
	.loc 2 1287 0
	mov	w1, 1
	b	.L791
.LVL1011:
.L719:
	.loc 2 1139 0
	ldr	x0, [x25, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L720
.LVL1012:
	sub	w5, w5, #1
.LVL1013:
	.loc 2 1133 0 discriminator 2
	ands	w5, w5, 65535
	bne	.L722
	b	.L721
.L720:
	.loc 2 1147 0
	adrp	x0, .LANCHOR71
	ldr	w1, [x0, #:lo12:.LANCHOR71]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L723
	.loc 2 1147 0 is_stmt 0 discriminator 1
	cmp	w1, w0
	bhi	.L724
.L723:
	.loc 2 1149 0 is_stmt 1
	cmn	w0, #1
	beq	.L724
	.loc 2 1152 0
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L724:
	.loc 2 1157 0
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L726
	bhi	.L727
	mov	w0, 61574
	cmp	w1, w0
	beq	.L728
.L725:
	.loc 2 1128 0 discriminator 2
	ldr	x0, [x29, 128]
	add	x22, x22, 32
	cmp	x0, x22
	bne	.L752
	b	.L753
.L727:
	.loc 2 1157 0
	mov	w0, 61634
	cmp	w1, w0
	beq	.L729
	mov	w0, 65535
	cmp	w1, w0
	bne	.L725
	.loc 2 1280 0
	mov	w1, 0
.L791:
	.loc 2 1287 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.LVL1014:
	b	.L725
.L729:
	.loc 2 1162 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L731
	.loc 2 1162 0 is_stmt 0 discriminator 1
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1162
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1015:
.L731:
	.loc 2 1163 0 is_stmt 1
	ldr	w6, [x21, #:lo12:.LANCHOR30]
	.loc 2 1165 0
	ldr	x3, [x29, 152]
	.loc 2 1163 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
.LVL1016:
	sub	w2, w2, #1
	.loc 2 1165 0
	ldr	x5, [x3, #:lo12:.LANCHOR135]
	.loc 2 1163 0
	sxth	w2, w2
.L732:
	.loc 2 1163 0 is_stmt 0 discriminator 1
	cmp	w0, w2
	bgt	.L738
	.loc 2 1186 0 is_stmt 1
	tbz	w0, #31, .L772
	b	.L725
.L738:
	.loc 2 1165 0
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L733
	.loc 2 1167 0
	ldr	w2, [x5]
	cbnz	w2, .L734
	.loc 2 1167 0 is_stmt 0 discriminator 1
	cmp	w6, w1
	beq	.L734
	.loc 2 1172 0 is_stmt 1
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
.L734:
	.loc 2 1178 0 discriminator 1
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L735:
.LVL1017:
	.loc 2 1175 0 discriminator 1
	cmp	w1, w0
	bne	.L736
	.loc 2 1180 0
	ldr	w1, [x27, 4]
.LVL1018:
	str	w1, [x10]
	.loc 2 1181 0
	strh	w26, [x6, x8, lsl 1]
	.loc 2 1186 0
	tbnz	w0, #31, .L725
	.loc 2 1193 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w2, [x21, #:lo12:.LANCHOR30]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L725
.L772:
	.loc 2 1195 0
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR147]
	.loc 2 1196 0
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	.loc 2 1197 0
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L790:
	.loc 2 1241 0
	strh	w26, [x1, x0, lsl 1]
	b	.L725
.LVL1019:
.L736:
	.loc 2 1177 0 discriminator 3
	sxtw	x2, w1
	add	w1, w1, 1
.LVL1020:
	lsl	x7, x2, 2
	.loc 2 1178 0 discriminator 3
	lsl	x2, x2, 1
	.loc 2 1177 0 discriminator 3
	add	x11, x5, x7
	sxth	w1, w1
.LVL1021:
	ldr	w11, [x11, 4]
	str	w11, [x5, x7]
	.loc 2 1178 0 discriminator 3
	add	x7, x6, x2
	ldrh	w7, [x7, 2]
	strh	w7, [x6, x2]
	b	.L735
.LVL1022:
.L733:
	sub	w0, w0, #1
.LVL1023:
	sxth	x0, w0
.LVL1024:
	b	.L732
.LVL1025:
.L728:
	.loc 2 1203 0
	ldrh	w1, [x23, #:lo12:.LANCHOR35]
	ldrh	w0, [x19, #:lo12:.LANCHOR27]
	cmp	w1, w0
	bls	.L741
	.loc 2 1203 0 is_stmt 0 discriminator 1
	ldr	x1, [x29, 136]
	adrp	x0, .LC1
	mov	w2, 1203
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1026:
.L741:
	.loc 2 1204 0 is_stmt 1
	ldrh	w6, [x19, #:lo12:.LANCHOR27]
	ldrh	w2, [x23, #:lo12:.LANCHOR35]
	sub	w1, w6, #1
	sxth	x0, w1
.LVL1027:
	sub	w5, w1, w2
	.loc 2 1206 0
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
.L742:
	.loc 2 1204 0 discriminator 1
	cmp	w0, w5
	ble	.L747
	.loc 2 1206 0
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L743
	.loc 2 1208 0
	ldr	w5, [x1]
	cbnz	w5, .L744
	.loc 2 1208 0 is_stmt 0 discriminator 1
	cmp	w6, w2
	beq	.L744
	.loc 2 1216 0 is_stmt 1
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR35]
.L744:
	.loc 2 1221 0 discriminator 1
	ldr	x6, [x28, #:lo12:.LANCHOR36]
	mov	w2, 0
.L745:
.LVL1028:
	.loc 2 1218 0 discriminator 1
	cmp	w2, w0
	bne	.L746
	.loc 2 1223 0
	ldr	w2, [x27, 4]
.LVL1029:
	str	w2, [x10]
	.loc 2 1224 0
	strh	w26, [x6, x7, lsl 1]
.L747:
	.loc 2 1229 0
	tbnz	w0, #31, .L725
	.loc 2 1237 0
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	ldrh	w5, [x23, #:lo12:.LANCHOR35]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L725
	.loc 2 1239 0
	add	w5, w5, 1
	.loc 2 1240 0
	ldr	w2, [x27, 4]
	.loc 2 1239 0
	strh	w5, [x23, #:lo12:.LANCHOR35]
	.loc 2 1240 0
	str	w2, [x1, x0, lsl 2]
	.loc 2 1241 0
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	b	.L790
.LVL1030:
.L746:
	.loc 2 1220 0 discriminator 3
	sxtw	x5, w2
	add	w2, w2, 1
.LVL1031:
	lsl	x8, x5, 2
	.loc 2 1221 0 discriminator 3
	lsl	x5, x5, 1
	.loc 2 1220 0 discriminator 3
	add	x11, x1, x8
	sxth	w2, w2
.LVL1032:
	ldr	w11, [x11, 4]
	str	w11, [x1, x8]
	.loc 2 1221 0 discriminator 3
	add	x8, x6, x5
	ldrh	w8, [x8, 2]
	strh	w8, [x6, x5]
	b	.L745
.LVL1033:
.L743:
	sub	w0, w0, #1
.LVL1034:
	sxth	x0, w0
.LVL1035:
	b	.L742
.LVL1036:
.L726:
	.loc 2 1248 0
	ldrh	w5, [x24, #:lo12:.LANCHOR81]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR81
	cmp	w5, w1
	bne	.L749
	.loc 2 1250 0
	strh	w26, [x24, #:lo12:.LANCHOR81]
	.loc 2 1251 0
	str	w0, [x2, 8]
	b	.L725
.L749:
	.loc 2 1255 0
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L750
	.loc 2 1256 0
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.LVL1037:
.L750:
	.loc 2 1257 0
	add	x0, x24, :lo12:.LANCHOR81
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L751
	.loc 2 1259 0
	ldrh	w2, [x24, #:lo12:.LANCHOR81]
	strh	w2, [x0, 4]
	.loc 2 1260 0
	strh	w26, [x24, #:lo12:.LANCHOR81]
	.loc 2 1261 0
	str	w1, [x0, 8]
	b	.L725
.L751:
	.loc 2 1265 0
	strh	w26, [x0, 4]
	b	.L725
.LVL1038:
.L754:
	.loc 2 1292 0
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L756
.L759:
	.loc 2 1310 0
	ldr	x1, [x28, #:lo12:.LANCHOR36]
	ldrh	w0, [x1]
	cbz	w0, .L757
.L758:
	.loc 2 1328 0
	ldrh	w1, [x20, #:lo12:.LANCHOR147]
	ldr	w0, [x21, #:lo12:.LANCHOR30]
	cmp	w1, w0
	bls	.L788
	.loc 2 1328 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR148
	adrp	x0, .LC1
	mov	w2, 1328
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1039:
.L788:
	.loc 2 1330 0 is_stmt 1
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
.LVL1040:
	ret
.LVL1041:
.L756:
	.cfi_restore_state
	.loc 2 1292 0 discriminator 1
	ldrh	w0, [x20, #:lo12:.LANCHOR147]
	cbz	w0, .L759
	.loc 2 1294 0 discriminator 1
	ldr	w1, [x21, #:lo12:.LANCHOR30]
	mov	w0, 0
.L760:
.LVL1042:
	cmp	w0, w1
	bcs	.L759
	.loc 2 1296 0
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L761
	.loc 2 1301 0
	ldr	x1, [x29, 152]
	.loc 2 1298 0
	add	x7, x21, :lo12:.LANCHOR30
	.loc 2 1301 0
	ldr	x4, [x1, #:lo12:.LANCHOR135]
	mov	w1, w0
.L762:
.LVL1043:
	.loc 2 1298 0 discriminator 1
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L759
	.loc 2 1300 0 discriminator 3
	sxtw	x6, w1
	sub	w3, w1, w0
	lsl	x5, x6, 1
	sxtw	x3, w3
	add	w1, w1, 1
.LVL1044:
	.loc 2 1301 0 discriminator 3
	ldr	w6, [x4, x6, lsl 2]
	sxth	w1, w1
.LVL1045:
	.loc 2 1300 0 discriminator 3
	ldrh	w8, [x2, x5]
	strh	w8, [x2, x3, lsl 1]
	.loc 2 1301 0 discriminator 3
	str	w6, [x4, x3, lsl 2]
	.loc 2 1302 0 discriminator 3
	strh	wzr, [x2, x5]
	b	.L762
.LVL1046:
.L761:
	add	w0, w0, 1
.LVL1047:
	sxth	w0, w0
.LVL1048:
	b	.L760
.LVL1049:
.L757:
	.loc 2 1310 0 discriminator 1
	ldrh	w0, [x23, #:lo12:.LANCHOR35]
	cbz	w0, .L758
	.loc 2 1312 0 discriminator 1
	ldrh	w2, [x19, #:lo12:.LANCHOR27]
	mov	w0, 0
.L767:
.LVL1050:
	mov	w6, w0
	cmp	w0, w2
	bge	.L758
	.loc 2 1314 0
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L768
	.loc 2 1319 0
	ldr	x2, [x29, 144]
	.loc 2 1316 0
	add	x19, x19, :lo12:.LANCHOR27
	.loc 2 1319 0
	ldr	x3, [x2, #:lo12:.LANCHOR132]
.LVL1051:
.L769:
	.loc 2 1316 0 discriminator 1
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L758
	.loc 2 1318 0 discriminator 3
	sxtw	x5, w0
	sub	w2, w0, w6
	lsl	x4, x5, 1
	sxtw	x2, w2
	add	w0, w0, 1
.LVL1052:
	.loc 2 1319 0 discriminator 3
	ldr	w5, [x3, x5, lsl 2]
	sxth	w0, w0
.LVL1053:
	.loc 2 1318 0 discriminator 3
	ldrh	w7, [x1, x4]
	strh	w7, [x1, x2, lsl 1]
	.loc 2 1319 0 discriminator 3
	str	w5, [x3, x2, lsl 2]
	.loc 2 1320 0 discriminator 3
	strh	wzr, [x1, x4]
	b	.L769
.LVL1054:
.L768:
	add	w0, w0, 1
.LVL1055:
	sxth	w0, w0
.LVL1056:
	b	.L767
	.cfi_endproc
.LFE270:
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
.LFB275:
	.loc 2 1466 0
	.cfi_startproc
.LVL1057:
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	.loc 2 1477 0
	mov	w1, 0
	.loc 2 1466 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.loc 2 1478 0
	adrp	x20, .LANCHOR108
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	.loc 2 1473 0
	ldrh	w23, [x0, 6]
	.loc 2 1511 0
	adrp	x24, .LANCHOR20
	.loc 2 1466 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.loc 2 1470 0
	ldr	x21, [x0, 40]
.LVL1058:
	.loc 2 1471 0
	ldr	x22, [x0, 16]
.LVL1059:
	.loc 2 1477 0
	lsl	w2, w23, 2
	.loc 2 1472 0
	ldr	x0, [x0, 24]
.LVL1060:
	str	x0, [x29, 128]
.LVL1061:
	.loc 2 1474 0
	ldrh	w0, [x19, 8]
.LVL1062:
	.loc 2 1466 0
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	.cfi_offset 27, -64
	.cfi_offset 28, -56
	.loc 2 1486 0
	mov	w27, 0
	.loc 2 1474 0
	str	w0, [x29, 140]
.LVL1063:
	.loc 2 1477 0
	mov	x0, x21
	bl	ftl_memset
.LVL1064:
	str	x20, [x29, 120]
	.loc 2 1478 0
	adrp	x7, .LANCHOR39
	add	x3, x20, :lo12:.LANCHOR108
	mov	x26, x7
	.loc 2 1510 0
	mov	x20, x3
	.loc 2 1478 0
	ldr	x0, [x7, #:lo12:.LANCHOR39]
	str	x0, [x3, 8]
	.loc 2 1479 0
	adrp	x0, .LANCHOR109
	.loc 2 1483 0
	stp	wzr, wzr, [x19, 48]
	.loc 2 1479 0
	ldr	x25, [x0, #:lo12:.LANCHOR109]
	.loc 2 1481 0
	mov	w0, -1
	.loc 2 1479 0
	str	x25, [x3, 16]
.LVL1065:
	.loc 2 1481 0
	strh	w0, [x19]
	.loc 2 1482 0
	strh	w0, [x19, 2]
	.loc 2 1485 0
	mov	w0, 1
	str	w0, [x19, 56]
.LVL1066:
	.loc 2 1488 0
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	str	w0, [x29, 136]
	.loc 2 1530 0
	add	x0, x24, :lo12:.LANCHOR20
	str	x0, [x29, 112]
.LVL1067:
.L793:
	.loc 2 1486 0 discriminator 1
	ldr	w0, [x29, 140]
	cmp	w27, w0
	bge	.L810
	.loc 2 1488 0
	ldr	w0, [x29, 136]
	sxtw	x28, w27
	cmp	w27, w0
	bne	.L794
	.loc 2 1490 0
	lsl	x0, x28, 1
	mov	w1, 1
	add	x24, x22, x0
	ldrh	w0, [x22, x0]
	.loc 2 1494 0
	mov	w22, 0
.LVL1068:
	.loc 2 1490 0
	bl	FtlGetLastWrittenPage
.LVL1069:
	sxth	w26, w0
.LVL1070:
	.loc 2 1491 0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	.loc 2 1493 0
	ldr	x0, [x29, 128]
	.loc 2 1492 0
	strh	w27, [x19]
	.loc 2 1493 0
	ldr	w0, [x0, x28, lsl 2]
	str	w0, [x19, 48]
.LVL1071:
	.loc 2 1496 0
	ldr	x0, [x29, 120]
	add	x20, x0, :lo12:.LANCHOR108
.LVL1072:
.L795:
	.loc 2 1494 0 discriminator 1
	cmp	w22, w26
	ble	.L797
.LVL1073:
.L810:
	.loc 2 1547 0
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
.LVL1074:
	.loc 2 1548 0
	adrp	x0, .LANCHOR20
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	cmp	w1, w0
	bne	.L799
	.loc 2 1550 0
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.LVL1075:
.L799:
	.loc 2 1553 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL1076:
	.loc 2 1555 0
	mov	x0, x19
	bl	ftl_map_blk_gc
.LVL1077:
	.loc 2 1557 0
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL1078:
	ldp	x21, x22, [sp, 32]
.LVL1079:
	ldp	x23, x24, [sp, 48]
.LVL1080:
	ldp	x25, x26, [sp, 64]
.LVL1081:
	ldp	x27, x28, [sp, 80]
.LVL1082:
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
.LVL1083:
	ret
.LVL1084:
.L797:
	.cfi_restore_state
	.loc 2 1496 0
	ldrh	w0, [x24]
	.loc 2 1497 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 1496 0
	orr	w0, w22, w0, lsl 10
	str	w0, [x20, 4]
	.loc 2 1497 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1085:
	.loc 2 1500 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L796
	.loc 2 1502 0
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L796
	.loc 2 1502 0 is_stmt 0 discriminator 1
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L796
	.loc 2 1504 0 is_stmt 1
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L796:
	add	w22, w22, 1
.LVL1086:
	sxth	w22, w22
.LVL1087:
	b	.L795
.LVL1088:
.L794:
	.loc 2 1510 0
	ldr	x0, [x26, #:lo12:.LANCHOR39]
	.loc 2 1512 0
	mov	w2, 1
	.loc 2 1510 0
	str	x0, [x20, 8]
	.loc 2 1511 0
	lsl	x0, x28, 1
	ldrh	w1, [x24, #:lo12:.LANCHOR20]
	add	x28, x22, x0
	ldrh	w0, [x22, x0]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	.loc 2 1512 0
	mov	w1, w2
	.loc 2 1511 0
	str	w0, [x20, 4]
	.loc 2 1512 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1089:
	.loc 2 1515 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L812
	.loc 2 1515 0 is_stmt 0 discriminator 1
	ldrh	w1, [x25]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L812
	.loc 2 1515 0 discriminator 2
	ldrh	w1, [x25, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L801
.L812:
	mov	w5, 0
.L802:
.LVL1090:
	.loc 2 1530 0 is_stmt 1 discriminator 1
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L808
	.loc 2 1532 0
	ldrh	w0, [x28]
	.loc 2 1533 0
	mov	w2, 1
	.loc 2 1532 0
	str	w5, [x29, 108]
	.loc 2 1533 0
	mov	w1, w2
	.loc 2 1532 0
	orr	w0, w5, w0, lsl 10
	str	w0, [x20, 4]
	.loc 2 1533 0
	mov	x0, x20
	bl	FlashReadPages
.LVL1091:
	.loc 2 1536 0
	ldr	w0, [x20]
	ldr	w5, [x29, 108]
	cmn	w0, #1
	beq	.L806
	.loc 2 1538 0
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L806
	.loc 2 1538 0 is_stmt 0 discriminator 1
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L806
	.loc 2 1540 0 is_stmt 1
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L806:
	add	w5, w5, 1
	sxth	w5, w5
.LVL1092:
	b	.L802
.LVL1093:
.L801:
	.loc 2 1518 0 discriminator 1
	ldrh	w5, [x24, #:lo12:.LANCHOR20]
	.loc 2 1520 0 discriminator 1
	mov	w0, 0
	ldr	x10, [x26, #:lo12:.LANCHOR39]
	.loc 2 1518 0 discriminator 1
	sub	w5, w5, #1
.L803:
.LVL1094:
	cmp	w0, w5
	blt	.L805
.LVL1095:
.L808:
	add	w4, w27, 1
	sxth	w27, w4
.LVL1096:
	b	.L793
.LVL1097:
.L805:
	.loc 2 1520 0
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
.LVL1098:
	.loc 2 1521 0
	cmp	w23, w1
	bls	.L804
	.loc 2 1523 0
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
.LVL1099:
	ldr	w2, [x10, x2, lsl 2]
.LVL1100:
	str	w2, [x21, x1]
.LVL1101:
.L804:
	add	w0, w0, 1
.LVL1102:
	sxth	w0, w0
.LVL1103:
	b	.L803
	.cfi_endproc
.LFE275:
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
.LFB276:
	.loc 2 1560 0
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	.loc 2 1561 0
	adrp	x1, .LANCHOR27
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	.loc 2 1560 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 1561 0
	ldrh	w1, [x1, #:lo12:.LANCHOR27]
	strh	w1, [x0, 10]
	.loc 2 1562 0
	mov	w1, -3962
	strh	w1, [x0, 4]
	.loc 2 1563 0
	adrp	x1, .LANCHOR35
	ldrh	w1, [x1, #:lo12:.LANCHOR35]
	strh	w1, [x0, 8]
	.loc 2 1564 0
	adrp	x1, .LANCHOR28
	ldrh	w1, [x1, #:lo12:.LANCHOR28]
	strh	w1, [x0, 6]
	.loc 2 1565 0
	adrp	x1, .LANCHOR36
	ldr	x1, [x1, #:lo12:.LANCHOR36]
	str	x1, [x0, 16]
	.loc 2 1566 0
	adrp	x1, .LANCHOR132
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	str	x1, [x0, 24]
	.loc 2 1567 0
	adrp	x1, .LANCHOR131
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	str	x1, [x0, 32]
	.loc 2 1568 0
	adrp	x1, .LANCHOR133
	ldr	x1, [x1, #:lo12:.LANCHOR133]
	str	x1, [x0, 40]
	.loc 2 1570 0
	bl	FtlMapTblRecovery
.LVL1104:
	.loc 2 1573 0
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
	.loc 2 1576 0
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 1578 0
	mov	w1, 0
	.loc 2 1576 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 2 1578 0
	adrp	x19, .LANCHOR130
	adrp	x20, .LANCHOR30
	.loc 2 1576 0
	stp	x21, x22, [sp, 32]
	.loc 2 1578 0
	ldr	x0, [x19, #:lo12:.LANCHOR130]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.loc 2 1579 0
	adrp	x22, .LANCHOR23
	.loc 2 1578 0
	ldr	w2, [x20, #:lo12:.LANCHOR30]
	.loc 2 1579 0
	adrp	x21, .LANCHOR33
	.loc 2 1576 0
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	.loc 2 1579 0
	adrp	x23, .LANCHOR136
	.loc 2 1578 0
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1105:
	.loc 2 1579 0
	ldrh	w0, [x21, #:lo12:.LANCHOR33]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR23]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR136]
	bl	ftl_memset
.LVL1106:
	adrp	x0, .LANCHOR56
	ldrh	w3, [x21, #:lo12:.LANCHOR33]
	.loc 2 1584 0
	ldr	x6, [x23, #:lo12:.LANCHOR136]
	.loc 2 1580 0
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR23]
	add	x3, x0, x3, lsl 4
.LVL1107:
.L823:
	add	x4, x1, x5
	.loc 2 1580 0 is_stmt 0 discriminator 1
	cmp	x0, x3
	bne	.L824
	.loc 2 1586 0 is_stmt 1
	adrp	x1, .LANCHOR144
	add	x0, x1, :lo12:.LANCHOR144
	.loc 2 1596 0
	ldp	x21, x22, [sp, 32]
	.loc 2 1587 0
	strh	w2, [x1, #:lo12:.LANCHOR144]
	.loc 2 1588 0
	ldr	w1, [x20, #:lo12:.LANCHOR30]
	strh	w1, [x0, 10]
	.loc 2 1589 0
	mov	w1, -3902
	strh	w1, [x0, 4]
	.loc 2 1590 0
	adrp	x1, .LANCHOR147
	.loc 2 1596 0
	ldr	x23, [sp, 48]
	.loc 2 1586 0
	strh	w2, [x0, 2]
	.loc 2 1590 0
	ldrh	w1, [x1, #:lo12:.LANCHOR147]
	strh	w1, [x0, 8]
	.loc 2 1591 0
	adrp	x1, .LANCHOR32
	ldrh	w1, [x1, #:lo12:.LANCHOR32]
	strh	w1, [x0, 6]
	.loc 2 1592 0
	adrp	x1, .LANCHOR129
	ldr	x1, [x1, #:lo12:.LANCHOR129]
	str	x1, [x0, 16]
	.loc 2 1593 0
	adrp	x1, .LANCHOR135
	ldr	x1, [x1, #:lo12:.LANCHOR135]
	str	x1, [x0, 24]
	.loc 2 1594 0
	ldr	x1, [x19, #:lo12:.LANCHOR130]
	.loc 2 1596 0
	ldp	x19, x20, [sp, 16]
	.loc 2 1594 0
	str	x1, [x0, 32]
	.loc 2 1595 0
	adrp	x1, .LANCHOR134
	ldr	x1, [x1, #:lo12:.LANCHOR134]
	str	x1, [x0, 40]
	.loc 2 1596 0
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
.L824:
	.cfi_restore_state
	.loc 2 1584 0 discriminator 3
	and	x1, x1, -4
	.loc 2 1583 0 discriminator 3
	strh	w2, [x0]
	.loc 2 1584 0 discriminator 3
	add	x1, x6, x1
	.loc 2 1582 0 discriminator 3
	str	wzr, [x0, 4]
	.loc 2 1584 0 discriminator 3
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L823
	.cfi_endproc
.LFE277:
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlLoadMapInfo,"ax",@progbits
	.align	2
	.global	FtlLoadMapInfo
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
.LFB278:
	.loc 2 1599 0
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 1600 0
	bl	FtlL2PDataInit
.LVL1108:
	.loc 2 1602 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapTblRecovery
.LVL1109:
	.loc 2 1605 0
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
	.loc 3 493 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 3 496 0
	adrp	x0, .LANCHOR150
	.loc 3 497 0
	mov	w1, -1
	.loc 3 493 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 496 0
	str	xzr, [x0, #:lo12:.LANCHOR150]
	.loc 3 497 0
	adrp	x0, .LANCHOR151
	.loc 3 493 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 3 503 0
	adrp	x19, .LANCHOR6
	.loc 3 497 0
	strh	w1, [x0, #:lo12:.LANCHOR151]
	.loc 3 498 0
	adrp	x0, .LANCHOR152
	.loc 3 500 0
	mov	w1, -1
	.loc 3 498 0
	str	wzr, [x0, #:lo12:.LANCHOR152]
	.loc 3 499 0
	adrp	x0, .LANCHOR153
	str	wzr, [x0, #:lo12:.LANCHOR153]
	.loc 3 500 0
	adrp	x0, .LANCHOR154
	str	w1, [x0, #:lo12:.LANCHOR154]
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
.LVL1110:
	.loc 3 503 0
	adrp	x0, .LANCHOR40
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR40]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1111:
	.loc 3 504 0
	adrp	x0, .LANCHOR126
	ldrh	w2, [x19, #:lo12:.LANCHOR6]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR126]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1112:
	.loc 3 505 0
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR79
	add	x0, x0, :lo12:.LANCHOR79
	bl	ftl_memset
.LVL1113:
	.loc 3 506 0
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	bl	ftl_memset
.LVL1114:
	.loc 3 507 0
	bl	FtlGcBufInit
.LVL1115:
	.loc 3 508 0
	bl	FtlL2PDataInit
.LVL1116:
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
	.loc 2 2067 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 2071 0
	adrp	x0, .LANCHOR6
	mov	w1, 0
	.loc 2 2067 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2071 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	mov	w0, 6
	.loc 2 2067 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 2 2071 0
	adrp	x24, .LANCHOR41
	.loc 2 2067 0
	stp	x19, x20, [sp, 16]
	.loc 2 2075 0
	adrp	x23, .LANCHOR45
	.loc 2 2067 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 2076 0
	adrp	x22, .LANCHOR48
	.loc 2 2071 0
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR41]
	.loc 2 2067 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.loc 2 2079 0
	adrp	x25, .LANCHOR5
	.loc 2 2067 0
	str	x27, [sp, 80]
	.cfi_offset 27, -16
	.loc 2 2082 0
	adrp	x26, .LANCHOR13
	.loc 2 2079 0
	add	x25, x25, :lo12:.LANCHOR5
	.loc 2 2082 0
	add	x26, x26, :lo12:.LANCHOR13
	.loc 2 2071 0
	bl	ftl_memset
.LVL1117:
	.loc 2 2077 0
	mov	w21, 0
	.loc 2 2072 0
	adrp	x0, .LANCHOR47
	.loc 2 2077 0
	mov	w20, 0
	.loc 2 2079 0
	mov	w19, 0
	.loc 2 2075 0
	strh	wzr, [x23, #:lo12:.LANCHOR45]
	.loc 2 2072 0
	str	xzr, [x0, #:lo12:.LANCHOR47]
	.loc 2 2073 0
	adrp	x0, .LANCHOR42
	.loc 2 2076 0
	strh	wzr, [x22, #:lo12:.LANCHOR48]
.LVL1118:
	.loc 2 2081 0
	adrp	x27, .LANCHOR3
	.loc 2 2073 0
	str	xzr, [x0, #:lo12:.LANCHOR42]
	.loc 2 2074 0
	adrp	x0, .LANCHOR44
	str	xzr, [x0, #:lo12:.LANCHOR44]
.LVL1119:
.L831:
	.loc 2 2079 0 discriminator 1
	ldrh	w0, [x25]
	cmp	w19, w0
	bcs	.L837
	.loc 2 2084 0
	adrp	x0, .LANCHOR19
	.loc 2 2081 0
	ldrh	w8, [x27, #:lo12:.LANCHOR3]
	.loc 2 2084 0
	mov	x6, 0
	mov	w5, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR19]
	b	.L838
.LVL1120:
.L833:
	.loc 2 2082 0
	ldrb	w0, [x26, x6]
	mov	w1, w19
	bl	V2P_block
.LVL1121:
	.loc 2 2083 0
	bl	FtlBbmIsBadBlock
.LVL1122:
	cbnz	w0, .L832
	.loc 2 2084 0
	add	w5, w5, w7
.LVL1123:
	and	w5, w5, 65535
.LVL1124:
.L832:
	add	x6, x6, 1
.LVL1125:
.L838:
	.loc 2 2081 0 discriminator 1
	cmp	w8, w6, uxth
	bhi	.L833
	.loc 2 2086 0
	cbz	w5, .L840
	.loc 2 2087 0
	mov	w0, 32768
	sdiv	w5, w0, w5
.LVL1126:
.L834:
	.loc 2 2088 0
	ldr	x1, [x24, #:lo12:.LANCHOR41]
	mov	w0, 6
	umaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	.loc 2 2090 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L835
	.loc 2 2091 0 discriminator 1
	adrp	x0, .LANCHOR52
	.loc 2 2090 0 discriminator 1
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L835
	.loc 2 2092 0
	adrp	x0, .LANCHOR53
	.loc 2 2091 0
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L835
	.loc 2 2094 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x0]
	cbnz	w0, .L836
	.loc 2 2095 0
	add	w21, w21, 1
.LVL1127:
	.loc 2 2096 0
	mov	w0, w19
	.loc 2 2095 0
	and	w21, w21, 65535
.LVL1128:
	.loc 2 2096 0
	bl	INSERT_FREE_LIST
.LVL1129:
.L835:
	.loc 2 2079 0 discriminator 2
	add	w19, w19, 1
.LVL1130:
	and	w19, w19, 65535
.LVL1131:
	b	.L831
.LVL1132:
.L840:
	mov	w5, 0
.LVL1133:
	b	.L834
.LVL1134:
.L836:
	.loc 2 2098 0
	add	w20, w20, 1
.LVL1135:
	.loc 2 2099 0
	mov	w0, w19
	.loc 2 2098 0
	and	w20, w20, 65535
.LVL1136:
	.loc 2 2099 0
	bl	INSERT_DATA_LIST
.LVL1137:
	b	.L835
.L837:
	.loc 2 2103 0
	strh	w20, [x23, #:lo12:.LANCHOR45]
	.loc 2 2105 0
	add	w20, w20, w21
.LVL1138:
	.loc 2 2104 0
	strh	w21, [x22, #:lo12:.LANCHOR48]
	.loc 2 2105 0
	cmp	w20, w0
	ble	.L839
	.loc 2 2105 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR155
	adrp	x0, .LC1
	mov	w2, 2105
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1139:
.L839:
	.loc 2 2107 0 is_stmt 1
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
.LVL1140:
	ldp	x21, x22, [sp, 32]
.LVL1141:
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
	.loc 2 2223 0
	.cfi_startproc
.LVL1142:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 2 2229 0
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	.loc 2 2223 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 2232 0
	adrp	x23, .LANCHOR62
	add	x23, x23, :lo12:.LANCHOR62
	.loc 2 2223 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 2232 0
	mov	w22, 0
	.loc 2 2223 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	.loc 2 2229 0
	adrp	x21, .LANCHOR156
	.loc 2 2223 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 2229 0
	add	x1, x21, :lo12:.LANCHOR156
	.loc 2 2231 0
	adrp	x20, check_vpc_table
	.loc 2 2229 0
	bl	printf
.LVL1143:
	.loc 2 2231 0
	add	x19, x20, :lo12:check_vpc_table
	mov	w2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	ftl_memset
.LVL1144:
.L843:
	.loc 2 2232 0 discriminator 1
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L845
	.loc 2 2243 0 discriminator 1
	adrp	x22, .LANCHOR5
.LVL1145:
	.loc 2 2247 0 discriminator 1
	adrp	x24, .LC92
	.loc 2 2243 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR5
	.loc 2 2245 0 discriminator 1
	add	x26, x20, :lo12:check_vpc_table
	.loc 2 2247 0 discriminator 1
	add	x24, x24, :lo12:.LC92
	mov	w23, 0
	mov	w19, 0
	.loc 2 2245 0 discriminator 1
	adrp	x25, .LANCHOR43
.LVL1146:
.L846:
	.loc 2 2243 0 discriminator 1
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L848
	.loc 2 2255 0
	adrp	x0, .LANCHOR47
	ldr	x19, [x0, #:lo12:.LANCHOR47]
.LVL1147:
	cbz	x19, .L849
.LBB242:
	.loc 2 2257 0
	adrp	x0, .LANCHOR48
	.loc 2 2263 0
	adrp	x25, .LC93
	add	x20, x20, :lo12:check_vpc_table
	add	x25, x25, :lo12:.LC93
	.loc 2 2257 0
	ldrh	w26, [x0, #:lo12:.LANCHOR48]
.LVL1148:
	.loc 2 2258 0
	adrp	x0, .LANCHOR41
	mov	x24, x0
	.loc 2 2259 0
	mov	w22, 0
	.loc 2 2258 0
	ldr	x1, [x0, #:lo12:.LANCHOR41]
	.loc 2 2261 0
	adrp	x27, .LANCHOR43
	.loc 2 2266 0
	mov	w28, 6
	.loc 2 2258 0
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.LVL1149:
.L850:
	.loc 2 2259 0 discriminator 1
	cmp	w22, w26
	bne	.L852
.LVL1150:
.L849:
.LBE242:
	.loc 2 2271 0
	cbz	w23, .L842
.LVL1151:
	.loc 2 2271 0 is_stmt 0 discriminator 1
	adrp	x0, .LC1
	mov	w2, 2271
	add	x1, x21, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1152:
.L842:
	.loc 2 2272 0 is_stmt 1
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
.LVL1153:
.L845:
	.cfi_restore_state
	.loc 2 2234 0
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
.LVL1154:
	.loc 2 2235 0
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L844
	.loc 2 2237 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1155:
	.loc 2 2238 0
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.LVL1156:
.L844:
	.loc 2 2232 0 discriminator 2
	add	w22, w22, 1
.LVL1157:
	b	.L843
.LVL1158:
.L848:
	.loc 2 2245 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L847
	.loc 2 2247 0
	mov	w1, w19
	mov	x0, x24
	bl	printf
.LVL1159:
	.loc 2 2248 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L847
	.loc 2 2248 0 is_stmt 0 discriminator 1
	ldrh	w1, [x26, x27, lsl 1]
	.loc 2 2250 0 is_stmt 1 discriminator 1
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.LVL1160:
.L847:
	.loc 2 2243 0 discriminator 2
	add	w19, w19, 1
.LVL1161:
	and	w19, w19, 65535
.LVL1162:
	b	.L846
.LVL1163:
.L852:
.LBB243:
	.loc 2 2261 0
	ldr	x1, [x27, #:lo12:.LANCHOR43]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L851
	.loc 2 2263 0
	ldrh	w3, [x20, w19, sxtw 1]
	.loc 2 2264 0
	mov	w23, 1
.LVL1164:
	.loc 2 2263 0
	mov	w1, w19
	mov	x0, x25
	bl	printf
.LVL1165:
.L851:
	.loc 2 2266 0
	ldr	x0, [x24, #:lo12:.LANCHOR41]
	umull	x19, w19, w28
.LVL1166:
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L849
.LVL1167:
	.loc 2 2259 0 discriminator 2
	add	w22, w22, 1
.LVL1168:
	and	w22, w22, 65535
.LVL1169:
	b	.L850
.LBE243:
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
	adrp	x0, .LANCHOR97
	.loc 5 205 0
	mov	w1, 255
	.loc 5 202 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 5 203 0
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	.loc 5 204 0
	adrp	x0, .LANCHOR99
	.loc 5 202 0
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 5 205 0
	adrp	x19, .LANCHOR21
	.loc 5 204 0
	strh	wzr, [x0, #:lo12:.LANCHOR99]
	.loc 5 205 0
	adrp	x0, .LANCHOR98
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	ldr	x0, [x0, #:lo12:.LANCHOR98]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1170:
	.loc 5 206 0
	ldrh	w2, [x19, #:lo12:.LANCHOR21]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR100
	ldr	x0, [x0, #:lo12:.LANCHOR100]
	bl	ftl_memset
.LVL1171:
	.loc 5 208 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	.loc 5 207 0
	b	FtlGcBufInit
.LVL1172:
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
.LVL1173:
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
	adrp	x21, .LANCHOR157
	.loc 5 211 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x20, x0
	stp	x27, x28, [sp, 80]
	.loc 5 221 0
	mov	w0, 65535
.LVL1174:
	.loc 5 220 0
	ldrh	w19, [x21, #:lo12:.LANCHOR157]
.LVL1175:
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
	beq	.L886
	.loc 5 223 0
	cbnz	w19, .L870
.L871:
	.loc 5 224 0
	bl	FtlGcPageVarInit
.LVL1176:
	b	.L872
.LVL1177:
.L886:
	.loc 5 222 0
	mov	w19, 0
.LVL1178:
.L870:
	.loc 5 223 0 discriminator 1
	adrp	x0, .LANCHOR19
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w28
	beq	.L871
.LVL1179:
.L872:
	.loc 5 235 0
	adrp	x27, .LANCHOR23
	add	x27, x27, :lo12:.LANCHOR23
	.loc 5 222 0
	mov	w22, 0
	.loc 5 228 0
	mov	w23, 65535
.LVL1180:
.L880:
	ldrh	w0, [x20]
	.loc 5 226 0
	strb	wzr, [x20, 8]
.LVL1181:
	.loc 5 228 0
	cmp	w0, w23
	beq	.L887
	.loc 5 236 0
	adrp	x25, .LANCHOR24
	.loc 5 231 0
	adrp	x26, .LANCHOR3
	.loc 5 236 0
	add	x25, x25, :lo12:.LANCHOR24
	.loc 5 231 0
	add	x26, x26, :lo12:.LANCHOR3
.L883:
.LVL1182:
	.loc 5 235 0
	adrp	x1, .LANCHOR93
	.loc 5 234 0
	adrp	x24, .LANCHOR120
	.loc 5 235 0
	ldrh	w7, [x27]
	add	x5, x20, 16
	ldr	x6, [x1, #:lo12:.LANCHOR93]
	.loc 5 236 0
	adrp	x1, .LANCHOR94
	.loc 5 234 0
	ldr	x0, [x24, #:lo12:.LANCHOR120]
	.loc 5 230 0
	mov	w3, 0
	.loc 5 236 0
	ldr	x8, [x1, #:lo12:.LANCHOR94]
	ldrh	w1, [x26]
	ldrh	w10, [x25]
	add	x1, x1, 8
	add	x1, x20, x1, lsl 1
.LVL1183:
.L874:
	.loc 5 231 0 discriminator 1
	cmp	x1, x5
	bne	.L876
	.loc 5 240 0
	mov	w1, w3
	str	w3, [x29, 108]
	mov	w2, 0
	bl	FlashReadPages
.LVL1184:
	ldr	w3, [x29, 108]
	.loc 5 241 0
	mov	x11, 0
	ubfiz	x12, x3, 5, 16
.LVL1185:
.L877:
	.loc 5 241 0 is_stmt 0 discriminator 1
	cmp	x11, x12
	bne	.L881
	.loc 5 264 0 is_stmt 1
	add	w19, w19, 1
.LVL1186:
	.loc 5 266 0
	add	w22, w22, 1
.LVL1187:
	.loc 5 264 0
	and	w19, w19, 65535
.LVL1188:
	.loc 5 268 0
	cmp	w28, w22
	adrp	x1, .LANCHOR19
	bls	.L882
.L884:
	.loc 5 274 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bhi	.L883
.L887:
	.loc 5 227 0
	mov	w2, 0
	b	.L873
.LVL1189:
.L876:
	.loc 5 232 0
	ldrh	w4, [x5]
.LVL1190:
	.loc 5 233 0
	cmp	w4, w23
	beq	.L875
	.loc 5 234 0
	ubfiz	x2, x3, 5, 16
	orr	w4, w19, w4, lsl 10
.LVL1191:
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
.LVL1192:
	and	w3, w3, 65535
.LVL1193:
	.loc 5 236 0
	asr	w4, w4, 2
	add	x4, x8, x4, sxtw 2
	str	x4, [x2, 16]
.L875:
	add	x5, x5, 2
.LVL1194:
	b	.L874
.LVL1195:
.L881:
	.loc 5 242 0
	ldr	x6, [x24, #:lo12:.LANCHOR120]
	add	x5, x6, x11
	ldr	w4, [x5, 4]
.LVL1196:
	.loc 5 243 0
	lsr	w0, w4, 10
	bl	P2V_plane
.LVL1197:
	and	w2, w0, 65535
.LVL1198:
	.loc 5 245 0
	ldr	w0, [x6, x11]
.LVL1199:
	cbnz	w0, .L878
	.loc 5 247 0
	ldr	x0, [x5, 16]
.LVL1200:
	add	x11, x11, 32
	.loc 5 248 0
	ldrh	w1, [x0]
	cmp	w1, w23
	bne	.L879
	.loc 5 249 0
	adrp	x0, .LANCHOR153
.LVL1201:
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR153]
.LVL1202:
.L873:
	.loc 5 282 0
	strh	w19, [x20, 2]
	.loc 5 281 0
	mov	w0, -1
	.loc 5 283 0
	strb	w2, [x20, 6]
	.loc 5 284 0
	mov	w1, w19
	.loc 5 281 0
	strh	w0, [x21, #:lo12:.LANCHOR157]
	.loc 5 284 0
	mov	x0, x20
	bl	ftl_sb_update_avl_pages
.LVL1203:
	.loc 5 285 0
	b	.L885
.LVL1204:
.L879:
	.loc 5 252 0
	ldp	w2, w0, [x0, 8]
.LVL1205:
	mov	w1, w4
	bl	FtlGcUpdatePage
.LVL1206:
	b	.L877
.LVL1207:
.L878:
	.loc 5 256 0
	adrp	x0, .LANCHOR43
	ldrh	w1, [x20]
	.loc 5 259 0
	mov	w19, 0
.LVL1208:
	.loc 5 256 0
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	strh	wzr, [x0, x1, lsl 1]
	.loc 5 257 0
	ldrh	w0, [x20]
	bl	INSERT_FREE_LIST
.LVL1209:
	.loc 5 258 0
	mov	w0, -1
	strh	w0, [x20]
.LVL1210:
	.loc 5 260 0
	bl	FtlGcPageVarInit
.LVL1211:
	.loc 5 261 0
	b	.L880
.LVL1212:
.L882:
	.loc 5 268 0 discriminator 1
	ldrh	w0, [x21, #:lo12:.LANCHOR157]
	cmp	w0, w23
	beq	.L884
	.loc 5 269 0
	add	w0, w0, w22
	strh	w0, [x21, #:lo12:.LANCHOR157]
	.loc 5 270 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	cmp	w0, w19
	bls	.L884
.LVL1213:
.L885:
	.loc 5 286 0
	ldp	x19, x20, [sp, 16]
.LVL1214:
	mov	w0, -1
	ldp	x21, x22, [sp, 32]
.LVL1215:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1216:
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
.LVL1217:
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
	bls	.L895
.LVL1218:
.LBB246:
.LBB247:
	.loc 1 207 0
	add	x0, x29, 64
.LVL1219:
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
.LVL1220:
	.loc 1 210 0
	lsl	w19, w19, 10
.LVL1221:
	.loc 1 209 0
	mov	w2, 8
	mov	w1, 90
	mov	x0, x20
	bl	ftl_memset
.LVL1222:
	.loc 1 211 0
	mov	w2, 1
	.loc 1 210 0
	str	w19, [x29, 36]
	.loc 1 211 0
	mov	w1, w2
	add	x0, x29, 32
	bl	FlashEraseBlocks
.LVL1223:
	.loc 1 212 0
	mov	w3, 1
	add	x0, x29, 32
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1224:
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
.LVL1225:
	.loc 1 219 0
	bl	FlashEraseBlocks
.LVL1226:
.L893:
.LBE247:
.LBE246:
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
.LVL1227:
.L895:
	.cfi_restore_state
	.loc 1 203 0
	mov	w19, 0
	b	.L893
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
.LVL1228:
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
.LVL1229:
	bl	ftl_memset
.LVL1230:
	.loc 1 228 0
	adrp	x0, .LANCHOR107
	mov	w1, w20
	ldr	x2, [x0, #:lo12:.LANCHOR107]
	mov	x0, x19
	blr	x2
.LVL1231:
	and	w0, w0, 65535
.LVL1232:
	.loc 1 229 0
	cmp	w0, 50
	bls	.L898
	.loc 1 230 0
	mov	w2, 256
	mov	w1, 255
	mov	x0, x19
.LVL1233:
	bl	ftl_memset
.LVL1234:
	.loc 1 231 0
	mov	w0, 0
.LVL1235:
.L898:
	.loc 1 233 0
	adrp	x1, .LANCHOR0+14
	ldrh	w1, [x1, #:lo12:.LANCHOR0+14]
	cmp	w1, 4
	bne	.L902
	mov	x1, 0
.L900:
.LVL1236:
	.loc 1 234 0 discriminator 1
	cmp	w0, w1, uxth
	bhi	.L901
.LVL1237:
.L902:
	.loc 1 239 0
	ldp	x19, x20, [sp, 16]
.LVL1238:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1239:
.L901:
	.cfi_restore_state
	.loc 1 235 0 discriminator 3
	ldrh	w2, [x19, x1, lsl 1]
	lsr	w2, w2, 1
	strh	w2, [x19, x1, lsl 1]
.LVL1240:
	add	x1, x1, 1
.LVL1241:
	b	.L900
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
.LVL1242:
	.loc 1 248 0
	uxtw	x2, w2
	b	memcpy
.LVL1243:
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
.LVL1244:
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
	adrp	x23, .LANCHOR109
	.loc 4 80 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 4 87 0
	adrp	x19, .LANCHOR108
	.loc 4 80 0
	stp	x21, x22, [sp, 32]
	.loc 4 87 0
	add	x20, x19, :lo12:.LANCHOR108
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	adrp	x22, .LANCHOR39
	.loc 4 88 0
	ldr	x1, [x23, #:lo12:.LANCHOR109]
	.loc 4 80 0
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR37
	str	x27, [sp, 80]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	add	x25, x21, :lo12:.LANCHOR37
	.loc 4 87 0
	ldr	x0, [x22, #:lo12:.LANCHOR39]
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
.LVL1245:
.L906:
	.loc 4 91 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w24, w0
	blt	.L907
	.loc 4 94 0
	add	x19, x19, :lo12:.LANCHOR108
	.loc 4 98 0
	add	x20, x21, :lo12:.LANCHOR37
	.loc 4 95 0
	mov	w2, 16
	mov	w1, 255
	.loc 4 108 0
	adrp	x24, .LC94
.LVL1246:
	.loc 4 110 0
	adrp	x26, .LANCHOR20
	.loc 4 94 0
	ldr	x27, [x19, 16]
.LVL1247:
	.loc 4 108 0
	add	x24, x24, :lo12:.LC94
	.loc 4 110 0
	add	x26, x26, :lo12:.LANCHOR20
	.loc 4 82 0
	mov	w25, 0
	.loc 4 95 0
	mov	x0, x27
	bl	ftl_memset
.LVL1248:
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
.LVL1249:
.L908:
	.loc 4 108 0
	ldrh	w4, [x27, 10]
	.loc 4 107 0
	ldrh	w1, [x20]
	ldrh	w2, [x20, 2]
	.loc 4 108 0
	ldrh	w3, [x20, 4]
	.loc 4 104 0
	ldr	x0, [x22, #:lo12:.LANCHOR39]
	str	x0, [x19, 8]
	.loc 4 105 0
	ldr	x0, [x23, #:lo12:.LANCHOR109]
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
.LVL1250:
	.loc 4 109 0
	mov	w3, 1
	mov	x0, x19
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
.LVL1251:
	.loc 4 110 0
	ldrh	w0, [x26]
	ldrh	w1, [x20, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L909
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
	adrp	x0, .LANCHOR112
	.loc 4 116 0
	strh	w1, [x20]
	.loc 4 119 0
	lsl	w1, w1, 10
	.loc 4 121 0
	ldr	x0, [x0, #:lo12:.LANCHOR112]
	.loc 4 119 0
	str	w1, [x19, 4]
	.loc 4 117 0
	strh	wzr, [x20, 2]
	.loc 4 121 0
	str	w1, [x0, 4]
	.loc 4 122 0
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL1252:
	.loc 4 123 0
	mov	w3, 1
	mov	x0, x19
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1253:
.L909:
	.loc 4 126 0
	ldrh	w0, [x20, 2]
	add	w0, w0, 1
	strh	w0, [x20, 2]
	.loc 4 127 0
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L910
	.loc 4 129 0
	ldr	w1, [x19, 4]
	.loc 4 130 0
	add	w21, w21, 1
.LVL1254:
	.loc 4 129 0
	adrp	x0, .LC95
	.loc 4 130 0
	and	w21, w21, 65535
	.loc 4 129 0
	add	x0, x0, :lo12:.LC95
	bl	printf
.LVL1255:
	.loc 4 131 0
	cmp	w21, 3
	bls	.L908
	.loc 4 132 0
	ldr	w1, [x19, 4]
	adrp	x0, .LC96
	mov	w2, w21
	add	x0, x0, :lo12:.LC96
	bl	printf
.LVL1256:
.L912:
	b	.L912
.LVL1257:
.L907:
	.loc 4 92 0 discriminator 3
	ldrh	w2, [x27]
	ldr	x1, [x25], 8
	ldr	x0, [x20, 8]
	mul	w3, w24, w2
	lsl	w2, w2, 2
	.loc 4 91 0 discriminator 3
	add	w24, w24, 1
.LVL1258:
	.loc 4 92 0 discriminator 3
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
.LVL1259:
	b	.L906
.LVL1260:
.L913:
	mov	w25, 1
.LVL1261:
	b	.L908
.LVL1262:
.L910:
	.loc 4 139 0
	cbz	w25, .L913
	.loc 4 146 0
	mov	w0, 0
	ldr	x27, [sp, 80]
.LVL1263:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
.LVL1264:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1265:
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
	.loc 2 2531 0
	.cfi_startproc
.LVL1266:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 2537 0
	adrp	x28, .LANCHOR48
	.loc 2 2531 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 2540 0
	add	x23, x28, :lo12:.LANCHOR48
	.loc 2 2531 0
	stp	x19, x20, [sp, 16]
	.loc 2 2537 0
	adrp	x27, .LANCHOR45
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.loc 2 2531 0
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.loc 2 2537 0
	add	x0, x27, :lo12:.LANCHOR45
.LVL1267:
	.loc 2 2531 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 2 2537 0
	str	x0, [x29, 104]
.LVL1268:
.L916:
	ldr	x1, [x29, 104]
	adrp	x24, .LANCHOR5
	ldrh	w0, [x28, #:lo12:.LANCHOR48]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L917
	.loc 2 2537 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2537
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1269:
.L917:
	.loc 2 2539 0 is_stmt 1
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	cmp	x19, x0
	bne	.L942
	.loc 2 2540 0
	adrp	x1, .LANCHOR89
	ldrh	w0, [x23]
	ldr	w1, [x1, #:lo12:.LANCHOR89]
	mul	w1, w0, w1
	lsr	w0, w0, 1
	add	w0, w0, 1
	add	w1, w0, w1, lsr 2
.LVL1270:
	.loc 2 2544 0
	ands	w1, w1, 65535
	beq	.L918
	.loc 2 2545 0
	sub	w1, w1, #1
.LVL1271:
	and	w1, w1, 65535
.LVL1272:
.L918:
	.loc 2 2546 0
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	List_pop_index_node
.LVL1273:
	and	w20, w0, 65535
.LVL1274:
	ldrh	w0, [x23]
	cbnz	w0, .L919
	.loc 2 2546 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2546
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1275:
.L919:
	.loc 2 2546 0 discriminator 3
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	.loc 2 2549 0 is_stmt 1 discriminator 3
	strh	w20, [x19]
	.loc 2 2550 0 discriminator 3
	mov	x0, x19
	bl	make_superblock
.LVL1276:
	.loc 2 2551 0 discriminator 3
	ldrb	w0, [x19, 7]
	cbnz	w0, .L920
	.loc 2 2555 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x20, 1, 16
	mov	w2, -1
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	strh	w2, [x1, x0]
	.loc 2 2556 0
	mov	w0, w20
	bl	INSERT_DATA_LIST
.LVL1277:
	.loc 2 2557 0
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L916
	.loc 2 2557 0 is_stmt 0 discriminator 1
	mov	w2, 2557
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1278:
	b	.L916
.LVL1279:
.L942:
	mov	w1, 0
	b	.L918
.LVL1280:
.L920:
	.loc 2 2560 0 is_stmt 1
	ldrh	w1, [x27, #:lo12:.LANCHOR45]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L922
	.loc 2 2560 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2560
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1281:
.L922:
	.loc 2 2563 0 is_stmt 1 discriminator 1
	adrp	x0, .LANCHOR3
	.loc 2 2564 0 discriminator 1
	adrp	x25, .LANCHOR112
	add	x26, x19, 16
	mov	w21, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	mov	x4, x26
	ldr	x3, [x25, #:lo12:.LANCHOR112]
	.loc 2 2566 0 discriminator 1
	mov	w6, 65535
	ubfiz	x0, x0, 5, 16
	add	x1, x3, 8
	add	x0, x0, 8
	add	x0, x3, x0
.L923:
.LVL1282:
	.loc 2 2563 0 discriminator 1
	cmp	x0, x1
	bne	.L925
	.loc 2 2571 0
	cbnz	w21, .L926
	.loc 2 2571 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2571
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1283:
.L926:
	.loc 2 2573 0 is_stmt 1
	adrp	x0, .LANCHOR82
	ldrh	w0, [x0, #:lo12:.LANCHOR82]
	cmp	w0, w20
	bne	.L927
	.loc 2 2573 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2573
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1284:
.L927:
	.loc 2 2574 0 is_stmt 1
	ldrb	w0, [x19, 8]
	uxtw	x22, w20
	adrp	x6, .LANCHOR40
	adrp	x7, .LANCHOR14
	adrp	x5, .LANCHOR73
	adrp	x4, .LANCHOR74
	cbnz	w0, .L928
	.loc 2 2575 0
	ldr	x2, [x6, #:lo12:.LANCHOR40]
	lsl	x1, x22, 1
	ldrh	w0, [x2, x1]
	cbz	w0, .L929
	.loc 2 2576 0
	ldrh	w3, [x7, #:lo12:.LANCHOR14]
	add	w0, w0, w3
.L953:
	.loc 2 2578 0
	strh	w0, [x2, x1]
	.loc 2 2580 0
	mov	w1, 0
	.loc 2 2579 0
	ldr	w0, [x5, #:lo12:.LANCHOR73]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR73]
	.loc 2 2580 0
	mov	w0, w20
	bl	ftl_set_blk_mode
.LVL1285:
.L931:
	.loc 2 2587 0
	ldr	x0, [x6, #:lo12:.LANCHOR40]
	lsl	x22, x22, 1
	ldrh	w1, [x0, x22]
	adrp	x0, .LANCHOR77
	ldr	w2, [x0, #:lo12:.LANCHOR77]
	cmp	w1, w2
	bls	.L932
	.loc 2 2588 0
	str	w1, [x0, #:lo12:.LANCHOR77]
.L932:
	.loc 2 2590 0
	ldr	w2, [x5, #:lo12:.LANCHOR73]
	ldr	w1, [x4, #:lo12:.LANCHOR74]
	ldrh	w0, [x7, #:lo12:.LANCHOR14]
	madd	w0, w0, w2, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR75
	str	w0, [x1, #:lo12:.LANCHOR75]
	.loc 2 2591 0
	adrp	x0, .LANCHOR127
	ldr	x1, [x0, #:lo12:.LANCHOR127]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
.LVL1286:
	.loc 2 2594 0
	ldr	x0, [x25, #:lo12:.LANCHOR112]
	ubfiz	x1, x21, 5, 16
	add	x1, x1, 4
	add	x2, x0, 4
	add	x1, x0, x1
.LVL1287:
.L933:
	.loc 2 2593 0 discriminator 1
	cmp	x1, x2
	bne	.L934
	.loc 2 2595 0
	ldrb	w1, [x19, 8]
	mov	w2, w21
	.loc 2 2597 0
	mov	x24, 0
	.loc 2 2595 0
	bl	FlashEraseBlocks
.LVL1288:
	.loc 2 2596 0
	mov	w1, 0
.LVL1289:
.L935:
	.loc 2 2597 0 discriminator 1
	cmp	w21, w24, uxth
	bhi	.L937
	.loc 2 2608 0
	cbz	w1, .L938
	.loc 2 2609 0
	mov	w0, w20
	bl	update_multiplier_value
.LVL1290:
	.loc 2 2610 0
	bl	FtlBbmTblFlush
.LVL1291:
.L938:
	.loc 2 2613 0
	ldrb	w0, [x19, 7]
	adrp	x2, .LANCHOR43
	cbnz	w0, .L939
	.loc 2 2615 0
	ldr	x0, [x2, #:lo12:.LANCHOR43]
	mov	w1, -1
	strh	w1, [x0, x22]
	.loc 2 2616 0
	mov	w0, w20
	bl	INSERT_DATA_LIST
.LVL1292:
	.loc 2 2617 0
	b	.L916
.LVL1293:
.L925:
	.loc 2 2566 0
	ldrh	w2, [x4]
	.loc 2 2565 0
	stp	xzr, xzr, [x1]
	.loc 2 2566 0
	cmp	w2, w6
	beq	.L924
	.loc 2 2567 0
	ubfiz	x5, x21, 5, 16
	.loc 2 2568 0
	add	w21, w21, 1
.LVL1294:
	.loc 2 2567 0
	add	x5, x3, x5
	.loc 2 2568 0
	and	w21, w21, 65535
.LVL1295:
	.loc 2 2567 0
	lsl	w2, w2, 10
	str	w2, [x5, 4]
.L924:
	add	x1, x1, 32
	add	x4, x4, 2
	b	.L923
.L929:
	.loc 2 2578 0
	mov	w0, 2
	b	.L953
.L928:
	.loc 2 2582 0
	ldr	x2, [x6, #:lo12:.LANCHOR40]
	lsl	x0, x22, 1
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	.loc 2 2583 0
	ldr	w0, [x4, #:lo12:.LANCHOR74]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR74]
.LVL1296:
.LBB248:
.LBB249:
	mov	w0, w20
	bl	ftl_set_blk_mode.part.7
.LVL1297:
	b	.L931
.LVL1298:
.L934:
.LBE249:
.LBE248:
	.loc 2 2594 0 discriminator 3
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 32
	b	.L933
.LVL1299:
.L937:
	.loc 2 2598 0
	ldr	x2, [x25, #:lo12:.LANCHOR112]
	lsl	x0, x24, 5
	add	x3, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L936
	.loc 2 2599 0
	add	w1, w1, 1
.LVL1300:
	.loc 2 2600 0
	ldr	w0, [x3, 4]
	.loc 2 2599 0
	stp	w2, w1, [x29, 96]
.LVL1301:
	.loc 2 2601 0
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1302:
	.loc 2 2603 0
	ldp	w2, w1, [x29, 96]
	.loc 2 2602 0
	strh	w2, [x26]
	.loc 2 2603 0
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
.LVL1303:
.L936:
	add	x24, x24, 1
.LVL1304:
	add	x26, x26, 2
	b	.L935
.LVL1305:
.L939:
	.loc 2 2620 0
	adrp	x1, .LANCHOR19
	.loc 2 2624 0
	adrp	x3, .LANCHOR71
	.loc 2 2623 0
	strb	wzr, [x19, 6]
	.loc 2 2620 0
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	.loc 2 2622 0
	strh	wzr, [x19, 2]
	.loc 2 2621 0
	strh	w20, [x19]
	.loc 2 2620 0
	mul	w0, w0, w1
	.loc 2 2624 0
	ldr	w1, [x3, #:lo12:.LANCHOR71]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x3, #:lo12:.LANCHOR71]
	.loc 2 2625 0
	ldr	x1, [x2, #:lo12:.LANCHOR43]
	.loc 2 2620 0
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	.loc 2 2625 0
	strh	w0, [x1, x22]
	.loc 2 2626 0
	ldrh	w0, [x19, 4]
	cbz	w0, .L940
	.loc 2 2626 0 is_stmt 0 discriminator 2
	ldrb	w0, [x19, 7]
	cbnz	w0, .L941
.L940:
	.loc 2 2626 0 discriminator 3
	adrp	x1, .LANCHOR158
	adrp	x0, .LC1
	mov	w2, 2626
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1306:
.L941:
	.loc 2 2628 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
.LVL1307:
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL1308:
	ldp	x23, x24, [sp, 48]
.LVL1309:
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
.LVL1310:
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
	adrp	x21, .LANCHOR103
	.loc 5 390 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	and	w25, w0, 65535
	.loc 5 395 0
	ldrh	w0, [x21, #:lo12:.LANCHOR103]
.LVL1311:
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
	cbz	w0, .L955
.LBB252:
.LBB253:
	.loc 5 399 0
	adrp	x23, .LANCHOR104
	.loc 5 406 0
	add	x24, x23, :lo12:.LANCHOR104
.LBE253:
.LBE252:
	mov	w19, 0
.L956:
.LVL1312:
.LBB256:
.LBB254:
	.loc 5 396 0
	adrp	x0, .LANCHOR3
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w0, w19
	bhi	.L962
	.loc 5 412 0
	bl	FtlGcReFreshBadBlk
.LVL1313:
.L955:
.LBE254:
.LBE256:
	.loc 5 415 0
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1314:
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
.LVL1315:
.L962:
	.cfi_restore_state
.LBB257:
.LBB255:
	.loc 5 397 0
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	mov	w1, w25
	.loc 5 398 0
	add	x22, x21, :lo12:.LANCHOR103
	mov	w20, 0
	.loc 5 397 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
.LVL1316:
	and	w26, w0, 65535
.LVL1317:
.L957:
	.loc 5 398 0
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L961
	.loc 5 396 0
	add	w19, w19, 1
.LVL1318:
	and	w19, w19, 65535
.LVL1319:
	b	.L956
.L961:
	.loc 5 399 0
	add	x0, x23, :lo12:.LANCHOR104
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L958
	.loc 5 401 0
	mov	w1, w26
	adrp	x0, .LC97
	add	x0, x0, :lo12:.LC97
	bl	printf
.LVL1320:
	.loc 5 403 0
	mov	w0, w26
	bl	FtlBbmMapBadBlock
.LVL1321:
	.loc 5 404 0
	bl	FtlBbmTblFlush
.LVL1322:
	.loc 5 405 0
	ldrh	w1, [x22]
	.loc 5 406 0
	sxtw	x3, w27
	and	x4, x20, 65535
	.loc 5 405 0
	mov	x0, 0
.LVL1323:
.L959:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L960
	.loc 5 407 0
	sub	w1, w1, #1
	strh	w1, [x22]
.LVL1324:
.L958:
	.loc 5 398 0
	and	w20, w27, 65535
.LVL1325:
	b	.L957
.LVL1326:
.L960:
	.loc 5 406 0
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
.LVL1327:
	strh	w5, [x24, x2, lsl 1]
	b	.L959
.LBE255:
.LBE257:
	.cfi_endproc
.LFE317:
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
.LFB301:
	.loc 2 2687 0
	.cfi_startproc
.LVL1328:
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2688 0
	adrp	x1, .LANCHOR43
	.loc 2 2687 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 2687 0
	and	w19, w0, 65535
	.loc 2 2688 0
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ubfiz	x0, x19, 1, 16
.LVL1329:
	ldrh	w0, [x1, x0]
	cbnz	w0, .L968
	.loc 2 2689 0
	adrp	x0, .LANCHOR82
	ldrh	w1, [x0, #:lo12:.LANCHOR82]
	cmp	w1, w19
	bne	.L969
	.loc 2 2691 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR82]
.L970:
.LVL1330:
.LBB260:
.LBB261:
	.loc 2 2696 0
	adrp	x20, .LANCHOR45
	mov	w1, w19
	adrp	x0, .LANCHOR42
	add	x0, x0, :lo12:.LANCHOR42
	bl	List_remove_node
.LVL1331:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	cbnz	w0, .L972
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	mov	w2, 2696
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1332:
.L972:
	ldrh	w0, [x20, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR45]
	.loc 2 2697 0
	mov	w0, w19
	bl	free_data_superblock
.LVL1333:
	.loc 2 2698 0
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
.LVL1334:
	.loc 2 2699 0
	adrp	x0, .LANCHOR48
	ldrh	w1, [x20, #:lo12:.LANCHOR45]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	add	w0, w0, w1
	adrp	x1, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	cmp	w0, w1
	ble	.L976
	adrp	x1, .LANCHOR159
	adrp	x0, .LC1
	mov	w2, 2699
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1335:
.L976:
	mov	w0, 1
	b	.L967
.LVL1336:
.L969:
.LBE261:
.LBE260:
	.loc 2 2692 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L975
	.loc 2 2692 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L975
	.loc 2 2692 0 discriminator 2
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bne	.L970
.L975:
	.loc 2 2694 0 is_stmt 1
	mov	w0, 0
.L967:
	.loc 2 2705 0
	ldp	x19, x20, [sp, 16]
.LVL1337:
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.L968:
	.cfi_restore_state
	.loc 2 2702 0
	mov	w0, w19
	bl	List_update_data_list
.LVL1338:
	b	.L975
	.cfi_endproc
.LFE301:
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",@progbits
	.align	2
	.global	decrement_vpc_count
	.type	decrement_vpc_count, %function
decrement_vpc_count:
.LFB302:
	.loc 2 2708 0
	.cfi_startproc
.LVL1339:
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
	.loc 2 2711 0
	mov	w0, 65535
.LVL1340:
	cmp	w19, w0
	beq	.L979
	.loc 2 2712 0
	adrp	x21, .LANCHOR43
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L980
	.loc 2 2713 0
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC98
	add	x0, x0, :lo12:.LC98
	bl	printf
.LVL1341:
	.loc 2 2714 0
	ldr	x0, [x21, #:lo12:.LANCHOR43]
	ldrh	w0, [x0, x20]
	cbz	w0, .L981
.L986:
.LVL1342:
	.loc 2 2715 0 discriminator 1
	mov	w20, 0
.LVL1343:
.L978:
	.loc 2 2733 0
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1344:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1345:
.L981:
	.cfi_restore_state
	.loc 2 2714 0 discriminator 1
	mov	w2, 2714
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1346:
	b	.L986
.L980:
	.loc 2 2717 0
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L979:
	.loc 2 2721 0
	adrp	x21, .LANCHOR151
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR151]
	cmp	w0, w1
	bne	.L983
	.loc 2 2722 0
	strh	w19, [x21, #:lo12:.LANCHOR151]
	b	.L986
.L983:
	.loc 2 2724 0
	cmp	w19, w0
	beq	.L986
	.loc 2 2727 0
	bl	update_vpc_list
.LVL1347:
	cmp	w0, 0
	.loc 2 2730 0
	adrp	x1, .LANCHOR41
	adrp	x0, .LANCHOR42
	.loc 2 2729 0
	strh	w19, [x21, #:lo12:.LANCHOR151]
	.loc 2 2727 0
	cset	w20, ne
.LVL1348:
	.loc 2 2730 0
	ldr	x1, [x1, #:lo12:.LANCHOR41]
	ldr	x0, [x0, #:lo12:.LANCHOR42]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR43
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	and	x2, x0, 65535
	ldrh	w1, [x1, x2, lsl 1]
	cbnz	w1, .L978
	.loc 2 2730 0 is_stmt 0 discriminator 1
	cmp	w19, w0, uxth
	beq	.L978
	.loc 2 2730 0 discriminator 2
	mov	w2, 2730
	adrp	x1, .LANCHOR160
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1349:
	b	.L978
	.cfi_endproc
.LFE302:
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlWriteDump_data,"ax",@progbits
	.align	2
	.global	FtlWriteDump_data
	.type	FtlWriteDump_data, %function
FtlWriteDump_data:
.LFB268:
	.loc 2 947 0 is_stmt 1
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
	.loc 2 948 0
	adrp	x19, .LANCHOR51
	add	x0, x19, :lo12:.LANCHOR51
	.loc 2 947 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.loc 2 948 0
	ldrh	w2, [x0, 4]
	.loc 2 947 0
	str	x25, [sp, 64]
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.cfi_offset 23, -80
	.cfi_offset 24, -72
	.cfi_offset 25, -64
	.loc 2 948 0
	cbz	w2, .L988
	.loc 2 948 0 is_stmt 0 discriminator 1
	ldrb	w1, [x0, 8]
	cbnz	w1, .L988
	.loc 2 949 0 is_stmt 1
	adrp	x3, .LANCHOR19
	ldrb	w1, [x0, 7]
	ldrh	w3, [x3, #:lo12:.LANCHOR19]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L988
.LVL1350:
.LBB265:
.LBB266:
	.loc 2 956 0
	ldrb	w0, [x0, 10]
	cbnz	w0, .L987
	.loc 2 951 0
	adrp	x0, .LANCHOR62
	.loc 2 958 0
	mov	w2, 0
	add	x1, x29, 92
	.loc 2 951 0
	ldr	w21, [x0, #:lo12:.LANCHOR62]
	.loc 2 953 0
	adrp	x0, .LANCHOR3
	.loc 2 951 0
	sub	w21, w21, #1
	.loc 2 953 0
	ldrh	w25, [x0, #:lo12:.LANCHOR3]
	.loc 2 958 0
	mov	w0, w21
	bl	log2phys
.LVL1351:
	.loc 2 964 0
	adrp	x2, .LANCHOR109
	.loc 2 963 0
	adrp	x0, .LANCHOR39
	.loc 2 961 0
	ldr	w1, [x29, 92]
	.loc 2 964 0
	ldr	x20, [x2, #:lo12:.LANCHOR109]
	.loc 2 963 0
	ldr	x0, [x0, #:lo12:.LANCHOR39]
	.loc 2 967 0
	cmn	w1, #1
	.loc 2 961 0
	str	w1, [x29, 100]
	.loc 2 964 0
	stp	x0, x20, [x29, 104]
.LVL1352:
	.loc 2 962 0
	str	w21, [x29, 120]
	.loc 2 966 0
	str	wzr, [x20, 4]
	.loc 2 967 0
	beq	.L990
	.loc 2 969 0
	mov	w2, 0
	mov	w1, 1
	add	x0, x29, 96
	bl	FlashReadPages
.LVL1353:
.L991:
	.loc 2 987 0
	adrp	x23, .LANCHOR72
	.loc 2 953 0
	lsl	w25, w25, 2
.LVL1354:
	.loc 2 978 0
	add	x22, x19, :lo12:.LANCHOR51
	.loc 2 987 0
	add	x23, x23, :lo12:.LANCHOR72
	.loc 2 975 0
	mov	w0, -3947
	mov	w24, 0
	strh	w0, [x20]
.L992:
	.loc 2 976 0
	cmp	w25, w24
	bne	.L996
.L993:
	.loc 2 992 0
	add	x19, x19, :lo12:.LANCHOR51
	mov	w0, 1
	strb	w0, [x19, 10]
.LVL1355:
.L987:
.LBE266:
.LBE265:
	.loc 2 1000 0
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
.LVL1356:
.L990:
	.cfi_restore_state
.LBB268:
.LBB267:
	.loc 2 973 0
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
.LVL1357:
	b	.L991
.LVL1358:
.L996:
	.loc 2 978 0
	ldrh	w0, [x22, 4]
	cbz	w0, .L993
	.loc 2 983 0
	ldr	w0, [x29, 100]
	add	w24, w24, 1
	stp	w21, w0, [x20, 8]
	.loc 2 984 0
	ldrh	w0, [x22]
	strh	w0, [x20, 2]
	.loc 2 986 0
	mov	x0, x22
	bl	get_new_active_ppa
.LVL1359:
	str	w0, [x29, 100]
	.loc 2 987 0
	ldr	w0, [x23]
	.loc 2 988 0
	mov	w3, 0
	.loc 2 987 0
	str	w0, [x20, 4]
	.loc 2 988 0
	mov	w2, 0
	.loc 2 987 0
	add	w0, w0, 1
	.loc 2 988 0
	mov	w1, 1
	.loc 2 987 0
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x23]
	.loc 2 988 0
	add	x0, x29, 96
	bl	FlashProgPages
.LVL1360:
	.loc 2 990 0
	ldrh	w0, [x22]
	bl	decrement_vpc_count
.LVL1361:
	b	.L992
.LVL1362:
.L988:
.LBE267:
.LBE268:
	.loc 2 998 0
	add	x19, x19, :lo12:.LANCHOR51
	strb	wzr, [x19, 10]
	.loc 2 1000 0
	b	.L987
	.cfi_endproc
.LFE268:
	.size	FtlWriteDump_data, .-FtlWriteDump_data
	.section	.text.l2p_flush,"ax",@progbits
	.align	2
	.global	l2p_flush
	.type	l2p_flush, %function
l2p_flush:
.LFB261:
	.loc 2 740 0
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
	.loc 2 746 0
	adrp	x20, .LANCHOR33
	add	x20, x20, :lo12:.LANCHOR33
	.loc 2 740 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 746 0
	mov	w19, 0
	.loc 2 747 0
	adrp	x21, .LANCHOR56
	.loc 2 744 0
	bl	FtlWriteDump_data
.LVL1363:
.L1006:
	.loc 2 746 0 discriminator 1
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1008
	.loc 2 750 0
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1364:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1365:
.L1008:
	.cfi_restore_state
	.loc 2 747 0
	ldr	x1, [x21, #:lo12:.LANCHOR56]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1007
	.loc 2 748 0
	mov	w0, w19
	bl	flush_l2p_region
.LVL1366:
.L1007:
	.loc 2 746 0 discriminator 2
	add	w19, w19, 1
.LVL1367:
	and	w19, w19, 65535
.LVL1368:
	b	.L1006
	.cfi_endproc
.LFE261:
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlRecoverySuperblock,"ax",@progbits
	.align	2
	.global	FtlRecoverySuperblock
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
.LFB281:
	.loc 2 1656 0
	.cfi_startproc
.LVL1369:
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	.loc 2 1670 0
	mov	w1, 65535
	.loc 2 1656 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.loc 2 1670 0
	ldrh	w0, [x0]
.LVL1370:
	.loc 2 1656 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.loc 2 1670 0
	cmp	w0, w1
	.loc 2 1656 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	.loc 2 1670 0
	beq	.L1134
	.loc 2 1676 0
	ldrb	w0, [x19, 6]
	str	w0, [x29, 164]
	.loc 2 1681 0
	adrp	x0, .LANCHOR19
	.loc 2 1675 0
	ldrh	w26, [x19, 2]
.LVL1371:
	str	x0, [x29, 128]
	.loc 2 1681 0
	ldrh	w2, [x0, #:lo12:.LANCHOR19]
	cmp	w2, w26
	bne	.L1013
	.loc 2 1682 0
	strh	wzr, [x19, 4]
.LVL1372:
.L1140:
	.loc 2 1709 0
	strb	wzr, [x19, 6]
.LVL1373:
.L1134:
	.loc 2 2010 0
	ldp	x19, x20, [sp, 16]
.LVL1374:
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
.LVL1375:
.L1013:
	.cfi_restore_state
	.loc 2 1689 0
	ldrh	w0, [x19, 16]
.LVL1376:
	.loc 2 1688 0
	mov	w20, 0
.LVL1377:
.L1014:
	.loc 2 1690 0
	cmp	w0, w1
	beq	.L1015
	.loc 2 1697 0
	mov	w1, 1
	bl	FtlGetLastWrittenPage
.LVL1378:
	mov	w23, w0
.LVL1379:
	.loc 2 1705 0
	cmn	w0, #1
	beq	.L1016
	.loc 2 1721 0
	adrp	x1, .LANCHOR93
	.loc 2 1717 0
	adrp	x2, .LANCHOR3
	.loc 2 1720 0
	adrp	x20, .LANCHOR120
.LVL1380:
	.loc 2 1722 0
	add	x4, x19, 16
	.loc 2 1721 0
	ldr	x5, [x1, #:lo12:.LANCHOR93]
	adrp	x1, .LANCHOR23
	.loc 2 1720 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
.LVL1381:
	.loc 2 1722 0
	mov	w22, 0
	.loc 2 1721 0
	ldrh	w6, [x1, #:lo12:.LANCHOR23]
	.loc 2 1722 0
	adrp	x1, .LANCHOR94
	.loc 2 1719 0
	mov	w10, 65535
	str	x2, [x29, 152]
	.loc 2 1722 0
	ldr	x7, [x1, #:lo12:.LANCHOR94]
	adrp	x1, .LANCHOR24
	ldrh	w8, [x1, #:lo12:.LANCHOR24]
	add	x1, x19, 16
	str	x1, [x29, 168]
	ldrh	w1, [x2, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L1017:
.LVL1382:
	.loc 2 1717 0 discriminator 1
	cmp	x4, x1
	bne	.L1021
	.loc 2 1727 0
	mov	w2, 0
	mov	w1, w22
	bl	FlashReadPages
.LVL1383:
	.loc 2 1728 0
	adrp	x0, .LANCHOR72
	.loc 2 1730 0
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	.loc 2 1742 0
	and	w10, w23, 65535
	.loc 2 1733 0
	add	x7, x0, :lo12:.LANCHOR72
	.loc 2 1728 0
	ldr	w21, [x0, #:lo12:.LANCHOR72]
	mov	x11, x4
	.loc 2 1666 0
	mov	w6, 65535
	.loc 2 1729 0
	mov	w3, 0
	.loc 2 1728 0
	sub	w21, w21, #1
.LVL1384:
	str	x0, [x29, 144]
.LVL1385:
.L1022:
	.loc 2 1729 0 discriminator 1
	cmp	w22, w3
	bne	.L1027
	.loc 2 1747 0
	add	w22, w23, 1
.LVL1386:
	.loc 2 1749 0
	ldr	w0, [x4, 4]
	.loc 2 1747 0
	and	w22, w22, 65535
.LVL1387:
.L1136:
	.loc 2 1753 0
	lsr	w0, w0, 10
	bl	P2V_plane
.LVL1388:
	and	w27, w0, 65535
.LVL1389:
	.loc 2 1758 0
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w22
	bne	.L1029
	.loc 2 1759 0
	strh	w22, [x19, 2]
	.loc 2 1760 0
	strb	wzr, [x19, 6]
	.loc 2 1761 0
	strh	wzr, [x19, 4]
.L1029:
	.loc 2 1764 0
	ldr	w0, [x29, 164]
	cmp	w22, w26
	cset	w1, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w1, w0
	beq	.L1030
.LVL1390:
.L1141:
	.loc 2 2004 0
	mov	w2, w27
	mov	w1, w22
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
.LVL1391:
	b	.L1134
.LVL1392:
.L1015:
	.loc 2 1691 0
	add	w20, w20, 1
.LVL1393:
	and	w20, w20, 65535
.LVL1394:
	.loc 2 1692 0
	add	x0, x19, x20, sxtw 1
.LVL1395:
	ldrh	w0, [x0, 16]
.LVL1396:
	b	.L1014
.LVL1397:
.L1016:
	.loc 2 1706 0
	cbz	w26, .L1018
	.loc 2 1706 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR161
	adrp	x0, .LC1
.LVL1398:
	mov	w2, 1706
	add	x1, x1, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1399:
.L1018:
	.loc 2 1707 0 is_stmt 1
	ldr	w0, [x29, 164]
	cmp	w0, 0
	ccmp	w20, w0, 4, ne
	beq	.L1019
	.loc 2 1707 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR161
	adrp	x0, .LC1
	mov	w2, 1707
	add	x1, x1, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1400:
.L1019:
	.loc 2 1708 0 is_stmt 1
	strh	wzr, [x19, 2]
	b	.L1140
.LVL1401:
.L1021:
	.loc 2 1718 0
	ldrh	w3, [x4]
.LVL1402:
	.loc 2 1719 0
	cmp	w3, w10
	beq	.L1020
	.loc 2 1720 0
	ubfiz	x2, x22, 5, 16
	orr	w3, w23, w3, lsl 10
.LVL1403:
	add	x2, x0, x2
	str	w3, [x2, 4]
	.loc 2 1721 0
	mul	w3, w22, w6
	asr	w3, w3, 2
	add	x3, x5, x3, sxtw 2
	str	x3, [x2, 8]
	.loc 2 1722 0
	mul	w3, w22, w8
	.loc 2 1723 0
	add	w22, w22, 1
.LVL1404:
	and	w22, w22, 65535
.LVL1405:
	.loc 2 1722 0
	asr	w3, w3, 2
	add	x3, x7, x3, sxtw 2
	str	x3, [x2, 16]
.L1020:
	add	x4, x4, 2
.LVL1406:
	b	.L1017
.LVL1407:
.L1027:
	.loc 2 1730 0
	ldr	w0, [x11]
	cbnz	w0, .L1023
	.loc 2 1731 0
	ldr	x8, [x11, 16]
.LVL1408:
	.loc 2 1732 0
	ldr	w5, [x8, 4]
	cmn	w5, #1
	beq	.L1024
	.loc 2 1733 0
	ldr	w1, [x7]
	mov	w0, w5
	bl	ftl_cmp_data_ver
.LVL1409:
	cbz	w0, .L1024
	.loc 2 1735 0
	add	w5, w5, 1
	str	w5, [x7]
.L1024:
	.loc 2 1738 0
	ldr	w0, [x8]
	cmn	w0, #1
	bne	.L1026
	.loc 2 1753 0
	ubfiz	x3, x3, 5, 16
.LVL1410:
	.loc 2 1752 0
	and	w22, w23, 65535
.LVL1411:
	.loc 2 1753 0
	add	x3, x4, x3
	ldr	w0, [x3, 4]
	b	.L1136
.LVL1412:
.L1023:
	.loc 2 1742 0
	mov	w6, w10
.LVL1413:
.L1026:
	.loc 2 1729 0 discriminator 2
	add	w3, w3, 1
.LVL1414:
	add	x11, x11, 32
	and	w3, w3, 65535
.LVL1415:
	b	.L1022
.LVL1416:
.L1030:
	.loc 2 1770 0
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1031
	.loc 2 1770 0 is_stmt 0 discriminator 1
	ldrb	w0, [x19, 8]
	cbnz	w0, .L1032
.L1031:
.LVL1417:
.LBB269:
	.loc 2 1775 0 is_stmt 1
	adrp	x25, .LANCHOR154
	.loc 2 1774 0
	and	w28, w23, 65535
.LVL1418:
	.loc 2 1775 0
	ldr	w0, [x25, #:lo12:.LANCHOR154]
	cmn	w0, #1
	bne	.L1033
	.loc 2 1776 0
	str	w21, [x25, #:lo12:.LANCHOR154]
.L1033:
.LVL1419:
	.loc 2 1778 0
	add	w0, w26, 7
	cmp	w0, w23, uxth
	bge	.L1083
	.loc 2 1779 0
	sub	w24, w28, #7
	and	w24, w24, 65535
.LVL1420:
.L1034:
	.loc 2 1782 0 discriminator 1
	ldr	x0, [x29, 152]
	.loc 2 1784 0 discriminator 1
	mov	w3, 65535
	mov	w5, 1
	.loc 2 1782 0 discriminator 1
	add	x4, x0, :lo12:.LANCHOR3
.LVL1421:
.L1035:
	.loc 2 1780 0 discriminator 1
	cmp	w24, w28
	bhi	.L1045
	ldrh	w1, [x4]
	.loc 2 1785 0
	mov	w23, 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	add	x1, x1, 8
	ldr	x2, [x29, 168]
	add	x1, x19, x1, lsl 1
	b	.L1046
.LVL1422:
.L1083:
	mov	w24, w26
	b	.L1034
.LVL1423:
.L1037:
	.loc 2 1783 0
	ldrh	w6, [x2]
.LVL1424:
	.loc 2 1784 0
	cmp	w6, w3
	beq	.L1036
	.loc 2 1785 0
	ubfiz	x7, x23, 5, 16
	.loc 2 1786 0
	add	w23, w23, 1
.LVL1425:
	.loc 2 1785 0
	add	x7, x0, x7
	.loc 2 1786 0
	and	w23, w23, 65535
.LVL1426:
	.loc 2 1785 0
	orr	w6, w24, w6, lsl 10
.LVL1427:
	str	w6, [x7, 4]
.L1036:
	add	x2, x2, 2
.LVL1428:
.L1046:
	.loc 2 1782 0 discriminator 1
	cmp	x2, x1
	bne	.L1037
	.loc 2 1789 0
	mov	w1, w23
	mov	w2, 0
	str	w5, [x29, 112]
	ubfiz	x23, x23, 5, 16
.LVL1429:
	str	w3, [x29, 120]
	add	x23, x23, 16
	str	x4, [x29, 136]
	bl	FlashReadPages
.LVL1430:
	.loc 2 1791 0
	ldr	x2, [x20, #:lo12:.LANCHOR120]
	ldr	w1, [x25, #:lo12:.LANCHOR154]
	.loc 2 1790 0
	ldr	w5, [x29, 112]
	add	x0, x2, 16
	ldr	w3, [x29, 120]
	add	x23, x2, x23
	ldr	x4, [x29, 136]
	mov	w2, 0
.LVL1431:
.L1038:
	.loc 2 1790 0 is_stmt 0 discriminator 1
	cmp	x23, x0
	bne	.L1043
	cbz	w2, .L1044
	str	w1, [x25, #:lo12:.LANCHOR154]
.L1044:
	.loc 2 1780 0 is_stmt 1
	add	w24, w24, 1
.LVL1432:
	and	w24, w24, 65535
.LVL1433:
	b	.L1035
.L1043:
	.loc 2 1791 0
	ldr	w6, [x0, -16]
	cbz	w6, .L1039
	cbz	w2, .L1032
	str	w1, [x25, #:lo12:.LANCHOR154]
.LVL1434:
.L1032:
.LBE269:
	.loc 2 1814 0
	mov	w1, 1
	adrp	x0, .LANCHOR162
	.loc 2 1815 0
	mov	w23, w26
	.loc 2 1975 0
	adrp	x28, .LANCHOR154
	.loc 2 1814 0
	strh	w1, [x0, #:lo12:.LANCHOR162]
	.loc 2 1815 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL1435:
.LBB270:
	.loc 2 1897 0
	add	x0, x28, :lo12:.LANCHOR154
	str	x0, [x29, 104]
.LVL1436:
.L1047:
	ldr	x1, [x29, 152]
.LBE270:
	.loc 2 1820 0
	mov	w24, 0
	.loc 2 1824 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	.loc 2 1823 0
	mov	w5, 65535
	.loc 2 1821 0
	ldr	x2, [x29, 168]
	ldrh	w1, [x1, #:lo12:.LANCHOR3]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.LVL1437:
.L1048:
	.loc 2 1821 0 is_stmt 0 discriminator 1
	cmp	x1, x2
	bne	.L1050
	.loc 2 1828 0 is_stmt 1
	mov	w2, 0
	mov	w1, w24
	bl	FlashReadPages
.LVL1438:
	.loc 2 1829 0
	mov	x25, 0
	ubfiz	x0, x24, 5, 16
	str	x0, [x29, 112]
	.loc 2 1969 0
	adrp	x0, .LANCHOR163
	add	x0, x0, :lo12:.LANCHOR163
	str	x0, [x29, 120]
.LVL1439:
.L1051:
	.loc 2 1829 0 discriminator 1
	ldr	x0, [x29, 112]
	cmp	x25, x0
	bne	.L1077
	.loc 2 1983 0
	ldr	x0, [x29, 128]
	.loc 2 1982 0
	add	w23, w23, 1
.LVL1440:
	and	w23, w23, 65535
.LVL1441:
	.loc 2 1983 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	cmp	w0, w23
	bne	.L1047
	.loc 2 1986 0
	ldr	x0, [x29, 152]
	.loc 2 1988 0
	mov	w2, 65535
	.loc 2 1984 0
	strh	w23, [x19, 2]
	.loc 2 1985 0
	strh	wzr, [x19, 4]
.LVL1442:
	.loc 2 1986 0
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.LVL1443:
.L1078:
	.loc 2 1986 0 is_stmt 0 discriminator 1
	cmp	w0, w1
	beq	.L1134
.LVL1444:
	.loc 2 1988 0 is_stmt 1
	ldr	x4, [x29, 168]
	ldrh	w3, [x4], 2
	str	x4, [x29, 168]
.LVL1445:
	cmp	w3, w2
	beq	.L1079
	.loc 2 1989 0
	strb	w0, [x19, 6]
.LVL1446:
	.loc 2 1990 0
	b	.L1134
.LVL1447:
.L1039:
.LBB271:
	.loc 2 1792 0
	ldr	x6, [x0]
.LVL1448:
	.loc 2 1793 0
	ldrh	w7, [x6]
	cmp	w7, w3
	beq	.L1042
	.loc 2 1795 0
	ldr	w6, [x6, 4]
.LVL1449:
	cmn	w6, #1
	csel	w1, w1, w6, eq
	csel	w2, w2, w5, eq
.L1042:
	add	x0, x0, 32
.LVL1450:
	b	.L1038
.LVL1451:
.L1045:
	.loc 2 1809 0
	mov	w0, -1
	str	w0, [x25, #:lo12:.LANCHOR154]
	b	.L1032
.LVL1452:
.L1050:
.LBE271:
	.loc 2 1822 0
	ldrh	w3, [x2]
.LVL1453:
	.loc 2 1823 0
	cmp	w3, w5
	beq	.L1049
	.loc 2 1824 0
	ubfiz	x4, x24, 5, 16
	.loc 2 1825 0
	add	w24, w24, 1
.LVL1454:
	.loc 2 1824 0
	add	x4, x0, x4
	.loc 2 1825 0
	and	w24, w24, 65535
.LVL1455:
	.loc 2 1824 0
	orr	w3, w23, w3, lsl 10
.LVL1456:
	str	w3, [x4, 4]
.L1049:
	add	x2, x2, 2
.LVL1457:
	b	.L1048
.LVL1458:
.L1077:
	.loc 2 1830 0
	ldr	x4, [x20, #:lo12:.LANCHOR120]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 188]
	.loc 2 1831 0
	lsr	w0, w5, 10
	bl	P2V_plane
.LVL1459:
	and	w0, w0, 65535
.LVL1460:
	.loc 2 1833 0
	cmp	w23, w26
	bcc	.L1052
	.loc 2 1833 0 is_stmt 0 discriminator 1
	ldr	w1, [x29, 164]
	ccmp	w1, w0, 0, eq
	bhi	.L1052
	.loc 2 1837 0 is_stmt 1
	cmp	w23, w22
	ccmp	w27, w0, 0, eq
	beq	.L1053
.LVL1461:
	.loc 2 1841 0
	ldr	w0, [x4]
.LVL1462:
	cmn	w0, #1
	beq	.L1054
	.loc 2 1842 0
	ldr	x3, [x4, 16]
.LVL1463:
	.loc 2 1843 0
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L1055
.LVL1464:
.L1061:
.LBB272:
	.loc 2 1876 0
	ldrh	w0, [x19]
.LVL1465:
.L1139:
.LBE272:
	.loc 2 1960 0
	bl	decrement_vpc_count
.LVL1466:
.L1052:
	add	x25, x25, 32
	b	.L1051
.LVL1467:
.L1055:
	.loc 2 1849 0
	ldr	w21, [x3, 4]
.LVL1468:
	.loc 2 1850 0
	cmn	w21, #1
	beq	.L1056
	.loc 2 1851 0 discriminator 1
	ldr	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR72]
	mov	w0, w21
	bl	ftl_cmp_data_ver
.LVL1469:
	.loc 2 1850 0 discriminator 1
	cbz	w0, .L1056
	.loc 2 1853 0
	ldr	x1, [x29, 144]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR72]
.L1056:
	.loc 2 1858 0
	ldp	w24, w0, [x3, 8]
	.loc 2 1859 0
	add	x1, x29, 184
	.loc 2 1858 0
	str	w0, [x29, 180]
	.loc 2 1859 0
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
.LVL1470:
	.loc 2 1860 0
	ldr	w1, [x28, #:lo12:.LANCHOR154]
	cmn	w1, #1
	beq	.L1057
	.loc 2 1861 0 discriminator 1
	mov	w0, w21
	bl	ftl_cmp_data_ver
.LVL1471:
	.loc 2 1860 0 discriminator 1
	cbz	w0, .L1057
.LBB273:
	.loc 2 1865 0
	ldr	w1, [x29, 180]
	cmn	w1, #1
	beq	.L1058
	.loc 2 1866 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	.loc 2 1868 0
	mov	w2, 0
	.loc 2 1866 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	.loc 2 1867 0
	str	w1, [x0, 4]
	.loc 2 1868 0
	mov	w1, 1
	.loc 2 1866 0
	str	x3, [x29, 136]
.LVL1472:
	.loc 2 1868 0
	bl	FlashReadPages
.LVL1473:
	.loc 2 1881 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	x3, [x29, 136]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L1059
.LVL1474:
.L1060:
	.loc 2 1913 0
	mov	w0, -1
	str	w0, [x29, 180]
	.loc 2 1914 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1475:
.L1068:
.LBE273:
	.loc 2 1954 0
	ldr	w3, [x29, 180]
	cmn	w3, #1
	beq	.L1052
.L1082:
	.loc 2 1956 0
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1476:
	and	w24, w0, 65535
	.loc 2 1957 0
	adrp	x0, .LANCHOR5
	.loc 2 1956 0
	mov	w3, w24
.LVL1477:
	.loc 2 1957 0
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w24
	bhi	.L1073
	.loc 2 1957 0 is_stmt 0 discriminator 1
	mov	w2, 1957
	adrp	x1, .LANCHOR161
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC1
	str	w24, [x29, 136]
	bl	printf
.LVL1478:
	ldr	w3, [x29, 136]
.LVL1479:
.L1073:
	.loc 2 1958 0 is_stmt 1
	adrp	x1, .LANCHOR43
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1074
	.loc 2 1960 0
	mov	w0, w3
	b	.L1139
.LVL1480:
.L1058:
.LBB274:
	.loc 2 1872 0
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	bne	.L1061
	.loc 2 1873 0
	mov	w2, 1
	add	x1, x29, 180
	mov	w0, w24
	bl	log2phys
.LVL1481:
	b	.L1061
.LVL1482:
.L1059:
	.loc 2 1881 0 discriminator 1
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L1060
	.loc 2 1869 0 discriminator 2
	ldr	w0, [x3, 4]
	str	w0, [x29, 136]
.LVL1483:
	str	x3, [x29, 96]
	.loc 2 1882 0 discriminator 2
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR154]
	bl	ftl_cmp_data_ver
.LVL1484:
	.loc 2 1881 0 discriminator 2
	cbz	w0, .L1060
	.loc 2 1883 0
	ldp	w0, w1, [x29, 184]
	ldr	x3, [x29, 96]
	cmp	w0, w1
	.loc 2 1885 0
	ldr	w1, [x29, 180]
	.loc 2 1883 0
	bne	.L1063
.L1137:
	.loc 2 1909 0
	mov	w0, w24
	bl	FtlReUsePrevPpa
.LVL1485:
	b	.L1060
.L1063:
	.loc 2 1886 0
	cmp	w0, w1
	beq	.L1060
	.loc 2 1887 0
	cmn	w0, #1
	beq	.L1064
.LVL1486:
	.loc 2 1888 0
	ldr	x3, [x4, 16]
	.loc 2 1890 0
	mov	w2, 0
	.loc 2 1889 0
	str	w0, [x4, 4]
	.loc 2 1890 0
	mov	w1, 1
	.loc 2 1888 0
	str	x3, [x29, 96]
	.loc 2 1890 0
	mov	x0, x4
	bl	FlashReadPages
.LVL1487:
	ldr	x3, [x29, 96]
.LVL1488:
.L1065:
	.loc 2 1895 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L1066
	.loc 2 1897 0
	ldr	x0, [x29, 104]
	.loc 2 1896 0
	ldr	w3, [x3, 4]
.LVL1489:
	.loc 2 1897 0
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
.LVL1490:
	cbz	w0, .L1066
	.loc 2 1898 0
	ldr	w0, [x29, 136]
	mov	w1, w3
	bl	ftl_cmp_data_ver
.LVL1491:
	cbz	w0, .L1060
.LVL1492:
.L1066:
	.loc 2 1909 0
	ldr	w1, [x29, 180]
	b	.L1137
.L1064:
	.loc 2 1892 0
	str	w0, [x4]
	b	.L1065
.L1057:
.LBE274:
	.loc 2 1915 0
	ldp	w1, w0, [x29, 184]
	cmp	w1, w0
	beq	.L1068
	.loc 2 1917 0
	mov	w2, 1
	add	x1, x29, 188
	mov	w0, w24
	bl	log2phys
.LVL1493:
	.loc 2 1918 0
	ldr	w3, [x29, 184]
	cmn	w3, #1
	beq	.L1068
	.loc 2 1918 0 is_stmt 0 discriminator 1
	ldr	w0, [x29, 180]
	cmp	w3, w0
	beq	.L1082
	.loc 2 1919 0 is_stmt 1
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1494:
	.loc 2 1921 0
	adrp	x1, .LANCHOR51
	.loc 2 1919 0
	and	w0, w0, 65535
.LVL1495:
	.loc 2 1921 0
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, w0
	beq	.L1072
	.loc 2 1922 0 discriminator 1
	adrp	x1, .LANCHOR52
	.loc 2 1921 0 discriminator 1
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, w0
	beq	.L1072
	.loc 2 1923 0
	adrp	x1, .LANCHOR53
	.loc 2 1922 0
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1068
.L1072:
.LVL1496:
.LBB275:
	.loc 2 1927 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
.LVL1497:
	.loc 2 1930 0
	mov	w2, 0
	mov	w1, 1
	.loc 2 1927 0
	ldr	x4, [x0, 16]
	.loc 2 1929 0
	str	w3, [x0, 4]
	.loc 2 1927 0
	str	x4, [x29, 136]
.LVL1498:
	.loc 2 1930 0
	bl	FlashReadPages
.LVL1499:
	.loc 2 1933 0
	ldr	x0, [x20, #:lo12:.LANCHOR120]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1068
	.loc 2 1934 0
	ldr	x4, [x29, 136]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
.LVL1500:
	cbnz	w0, .L1068
	.loc 2 1941 0
	mov	w2, 1
	add	x1, x29, 184
	mov	w0, w24
	bl	log2phys
.LVL1501:
	b	.L1068
.LVL1502:
.L1074:
.LBE275:
	.loc 2 1962 0
	mov	w1, w24
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	printf
.LVL1503:
	b	.L1052
.LVL1504:
.L1054:
	.loc 2 1969 0
	ldr	x0, [x29, 120]
	ldr	w0, [x0]
	cmp	w0, 31
	bhi	.L1075
	.loc 2 1970 0
	adrp	x1, .LANCHOR164
	add	x1, x1, :lo12:.LANCHOR164
	str	w5, [x1, w0, uxtw 2]
	.loc 2 1971 0
	add	w0, w0, 1
	ldr	x1, [x29, 120]
	str	w0, [x1]
.L1075:
	.loc 2 1973 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1505:
	.loc 2 1975 0
	ldr	w0, [x28, #:lo12:.LANCHOR154]
	cmn	w0, #1
	bne	.L1076
.L1138:
	.loc 2 1978 0
	str	w21, [x28, #:lo12:.LANCHOR154]
	b	.L1052
.L1076:
	.loc 2 1977 0
	cmp	w21, w0
	bcs	.L1052
	b	.L1138
.LVL1506:
.L1079:
	.loc 2 1986 0 discriminator 2
	add	w0, w0, 1
.LVL1507:
	and	w0, w0, 65535
.LVL1508:
	b	.L1078
.LVL1509:
.L1053:
	.loc 2 2002 0
	strb	w27, [x19, 6]
	.loc 2 2003 0
	strh	w22, [x19, 2]
	b	.L1141
	.cfi_endproc
.LFE281:
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
.LFB288:
	.loc 2 2156 0
	.cfi_startproc
.LVL1510:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 2 2178 0
	adrp	x20, .LANCHOR72
	.loc 2 2156 0
	mov	x19, x0
	.loc 2 2178 0
	add	x20, x20, :lo12:.LANCHOR72
	.loc 2 2156 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 2162 0
	mov	w21, 7
	.loc 2 2156 0
	str	x23, [sp, 48]
	.cfi_offset 23, -48
	.loc 2 2168 0
	mov	w22, -1
	.loc 2 2169 0
	adrp	x23, .LANCHOR39
.LVL1511:
.L1143:
	.loc 2 2162 0
	subs	w21, w21, #1
.LVL1512:
	beq	.L1145
.LVL1513:
	.loc 2 2163 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1144
.LVL1514:
.L1145:
	.loc 2 2183 0
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR43
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR43]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	.loc 2 2184 0
	adrp	x0, .LANCHOR19
	.loc 2 2185 0
	strb	wzr, [x19, 6]
	.loc 2 2186 0
	strh	wzr, [x19, 4]
	.loc 2 2184 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	strh	w0, [x19, 2]
	.loc 2 2188 0
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
.LVL1515:
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 96
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
.LVL1516:
.L1144:
	.cfi_restore_state
	.loc 2 2165 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL1517:
	str	w0, [x29, 68]
	.loc 2 2166 0
	cmn	w0, #1
	beq	.L1145
	.loc 2 2169 0
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	.loc 2 2179 0
	mov	w3, 0
	.loc 2 2169 0
	str	x0, [x29, 72]
	.loc 2 2179 0
	mov	w2, 0
	.loc 2 2170 0
	adrp	x0, .LANCHOR109
	.loc 2 2168 0
	str	w22, [x29, 88]
	.loc 2 2170 0
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	str	x1, [x29, 80]
.LVL1518:
	.loc 2 2175 0
	ldrh	w0, [x19]
	strh	w0, [x1, 2]
	.loc 2 2178 0
	ldr	w0, [x20]
	.loc 2 2173 0
	stp	w0, w22, [x1, 4]
	.loc 2 2178 0
	add	w0, w0, 1
	.loc 2 2176 0
	strh	wzr, [x1]
	.loc 2 2178 0
	cmn	w0, #1
	.loc 2 2174 0
	str	w22, [x1, 12]
	.loc 2 2178 0
	csel	w0, w0, wzr, ne
	.loc 2 2179 0
	mov	w1, 1
.LVL1519:
	.loc 2 2178 0
	str	w0, [x20]
	.loc 2 2179 0
	add	x0, x29, 64
	bl	FlashProgPages
.LVL1520:
	.loc 2 2180 0
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.LVL1521:
	b	.L1143
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
	adrp	x23, .LANCHOR39
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
	adrp	x22, .LANCHOR108
	add	x20, x22, :lo12:.LANCHOR108
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	.loc 4 173 0
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	.loc 4 196 0
	mov	w25, 61649
	.loc 4 180 0
	str	x0, [x20, 8]
	.loc 4 181 0
	adrp	x0, .LANCHOR109
	ldr	x21, [x0, #:lo12:.LANCHOR109]
	str	x21, [x20, 16]
.LVL1522:
	.loc 4 183 0
	bl	FtlBbtMemInit
.LVL1523:
	.loc 4 184 0
	ldrh	w19, [x24, #:lo12:.LANCHOR17]
	add	x24, x24, :lo12:.LANCHOR17
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL1524:
.L1155:
	.loc 4 184 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	sub	w0, w0, #15
	cmp	w0, w19
	bgt	.L1158
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
.LVL1525:
	.loc 4 187 0
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1156
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
.LVL1526:
.L1156:
	.loc 4 191 0
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1157
	.loc 4 196 0
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1157
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
.L1158:
	.loc 4 216 0
	adrp	x19, .LANCHOR37
.LVL1527:
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR37
	ldrh	w1, [x19, #:lo12:.LANCHOR37]
	cmp	w1, w0
	beq	.L1172
	.loc 4 222 0
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1162
	.loc 4 224 0
	add	x0, x22, :lo12:.LANCHOR108
	lsl	w1, w1, 10
	.loc 4 225 0
	mov	w2, 1
	.loc 4 224 0
	str	w1, [x0, 4]
	.loc 4 225 0
	mov	w1, w2
	bl	FlashReadPages
.LVL1528:
	.loc 4 226 0
	ldr	w0, [x22, #:lo12:.LANCHOR108]
	cmn	w0, #1
	beq	.L1162
	.loc 4 229 0
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1162
	.loc 4 229 0 is_stmt 0 discriminator 1
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1162
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
.L1162:
	.loc 4 238 0
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	add	x24, x19, :lo12:.LANCHOR37
	mov	w1, 1
	.loc 4 247 0
	mov	w25, 61649
	.loc 4 238 0
	bl	FtlGetLastWrittenPage
.LVL1529:
	sxth	w20, w0
.LVL1530:
	.loc 4 239 0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	.loc 4 243 0
	add	x24, x22, :lo12:.LANCHOR108
.L1164:
	.loc 4 241 0
	tbz	w20, #31, .L1167
	.loc 4 254 0
	adrp	x1, .LANCHOR165
	adrp	x0, .LC1
	mov	w2, 254
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1531:
.L1166:
	.loc 4 255 0
	add	x0, x19, :lo12:.LANCHOR37
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	.loc 4 257 0
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1169
	.loc 4 259 0
	adrp	x1, .LANCHOR2
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	cmp	w0, w2
	beq	.L1169
	.loc 4 259 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1169
	.loc 4 261 0 is_stmt 1
	cmp	w0, w1
	bcs	.L1169
	.loc 4 263 0
	bl	FtlSysBlkNumInit
.LVL1532:
.L1169:
	add	x19, x19, :lo12:.LANCHOR37
	.loc 4 268 0 discriminator 1
	adrp	x21, .LANCHOR10
.LVL1533:
	.loc 4 269 0 discriminator 1
	adrp	x23, .LANCHOR137
	add	x19, x19, 32
	.loc 4 268 0 discriminator 1
	add	x21, x21, :lo12:.LANCHOR10
	.loc 4 269 0 discriminator 1
	add	x23, x23, :lo12:.LANCHOR137
	add	x22, x22, :lo12:.LANCHOR108
	.loc 4 173 0 discriminator 1
	mov	w20, 0
.LVL1534:
.L1170:
	.loc 4 268 0 discriminator 1
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1171
	.loc 4 275 0
	mov	w0, 0
.LVL1535:
.L1154:
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
.LVL1536:
.L1157:
	.cfi_restore_state
	.loc 4 184 0 discriminator 2
	sub	w19, w19, #1
.LVL1537:
	and	w19, w19, 65535
.LVL1538:
	b	.L1155
.LVL1539:
.L1167:
	.loc 4 243 0
	ldrh	w0, [x19, #:lo12:.LANCHOR37]
	.loc 4 245 0
	mov	w2, 1
	mov	w1, w2
	.loc 4 243 0
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	.loc 4 244 0
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	str	x0, [x24, 8]
	.loc 4 245 0
	mov	x0, x24
	bl	FlashReadPages
.LVL1540:
	.loc 4 247 0
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L1165
	.loc 4 247 0 is_stmt 0 discriminator 1
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1166
.L1165:
	sub	w20, w20, #1
.LVL1541:
	sxth	w20, w20
.LVL1542:
	b	.L1164
.LVL1543:
.L1171:
	.loc 4 269 0 is_stmt 1 discriminator 3
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	.loc 4 268 0 discriminator 3
	add	w20, w20, 1
.LVL1544:
	.loc 4 269 0 discriminator 3
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
.LVL1545:
	b	.L1170
.LVL1546:
.L1172:
	.loc 4 218 0
	mov	w0, -1
	b	.L1154
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
.LVL1547:
	.loc 4 326 0
	bl	FtlLoadFactoryBbt
.LVL1548:
	.loc 4 328 0
	adrp	x28, .LANCHOR108
	add	x21, x21, 12
	.loc 4 356 0
	add	x25, x28, :lo12:.LANCHOR108
	.loc 4 327 0
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	str	x0, [x29, 120]
.LVL1549:
.L1185:
	.loc 4 327 0 is_stmt 0 discriminator 1
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L1191
	.loc 4 381 0 is_stmt 1 discriminator 1
	adrp	x21, .LANCHOR25
	add	x21, x21, :lo12:.LANCHOR25
	mov	w19, 0
.L1192:
.LVL1550:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L1193
	.loc 4 387 0
	add	x21, x20, :lo12:.LANCHOR37
	.loc 4 396 0
	mov	w22, 65535
.LVL1551:
	.loc 4 387 0
	ldrh	w19, [x21, 12]
.LVL1552:
	sub	w19, w19, #1
	and	w19, w19, 65535
.LVL1553:
.L1194:
	.loc 4 387 0 is_stmt 0 discriminator 1
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1198
	.loc 4 389 0 is_stmt 1
	mov	w0, w19
	bl	FtlBbmIsBadBlock
.LVL1554:
	cmp	w0, 1
	beq	.L1195
	.loc 4 391 0
	mov	w0, w19
	bl	FlashTestBlk
.LVL1555:
	cbz	w0, .L1196
	.loc 4 393 0
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.LVL1556:
.L1195:
	.loc 4 387 0 discriminator 2
	sub	w19, w19, #1
.LVL1557:
	and	w19, w19, 65535
.LVL1558:
	b	.L1194
.LVL1559:
.L1191:
	.loc 4 329 0
	adrp	x2, .LANCHOR109
	.loc 4 328 0
	adrp	x0, .LANCHOR39
	add	x19, x28, :lo12:.LANCHOR108
	.loc 4 331 0
	ldrh	w1, [x21]
	.loc 4 328 0
	ldr	x0, [x0, #:lo12:.LANCHOR39]
	.loc 4 331 0
	mov	w3, 65535
	.loc 4 329 0
	ldr	x26, [x2, #:lo12:.LANCHOR109]
	.loc 4 331 0
	cmp	w1, w3
	.loc 4 329 0
	stp	x0, x26, [x19, 8]
.LVL1560:
	adrp	x23, .LANCHOR17
	str	x2, [x29, 112]
	.loc 4 331 0
	beq	.L1186
	.loc 4 333 0
	ldrh	w4, [x23, #:lo12:.LANCHOR17]
	.loc 4 335 0
	mov	w2, 1
	.loc 4 333 0
	madd	w27, w4, w22, w1
.LVL1561:
	.loc 4 335 0
	mov	w1, w2
	.loc 4 334 0
	lsl	w0, w27, 10
	str	w0, [x19, 4]
	.loc 4 335 0
	mov	x0, x19
	bl	FlashReadPages
.LVL1562:
	.loc 4 336 0
	ldr	x1, [x19, 8]
	ldr	x0, [x24]
	ldrh	w2, [x23, #:lo12:.LANCHOR17]
	add	w2, w2, 7
	lsr	w2, w2, 3
	bl	ftl_memcpy
.LVL1563:
.L1187:
	.loc 4 376 0 discriminator 2
	mov	w0, w27
	.loc 4 327 0 discriminator 2
	add	w22, w22, 1
.LVL1564:
	.loc 4 376 0 discriminator 2
	bl	FtlBbmMapBadBlock
.LVL1565:
	add	x24, x24, 8
	add	x21, x21, 2
	b	.L1185
.LVL1566:
.L1186:
	.loc 4 340 0
	mov	w1, w22
	bl	FlashGetBadBlockList
.LVL1567:
	.loc 4 341 0
	ldr	x0, [x19, 8]
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
.LVL1568:
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
.LVL1569:
	.loc 4 357 0
	str	x0, [x29, 104]
.L1188:
	.loc 4 345 0
	ldrh	w0, [x23]
	madd	w0, w22, w0, w19
	bl	FtlBbmIsBadBlock
.LVL1570:
	cmp	w0, 1
	beq	.L1189
	.loc 4 350 0
	ldr	x0, [x29, 112]
	mov	w2, 16
	.loc 4 349 0
	strh	w19, [x21]
	.loc 4 350 0
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	bl	ftl_memset
.LVL1571:
	.loc 4 351 0
	adrp	x0, .LANCHOR39
	mov	w2, 4096
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR39]
	bl	ftl_memset
.LVL1572:
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
.LVL1573:
	.loc 4 356 0
	lsl	w0, w27, 10
	str	w0, [x25, 4]
	.loc 4 357 0
	ldr	x0, [x29, 104]
	ldrh	w2, [x0]
	ldr	x0, [x25, 8]
	lsl	w2, w2, 2
	bl	ftl_memcpy
.LVL1574:
	.loc 4 358 0
	mov	w2, 1
	mov	x0, x25
	mov	w1, w2
	bl	FlashEraseBlocks
.LVL1575:
	.loc 4 359 0
	mov	w3, 1
	mov	x0, x25
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.LVL1576:
	.loc 4 360 0
	ldr	w0, [x25]
	cmn	w0, #1
	bne	.L1187
	.loc 4 362 0
	mov	w0, w27
	bl	FtlBbmMapBadBlock
.LVL1577:
	.loc 4 363 0
	b	.L1188
.LVL1578:
.L1189:
	.loc 4 347 0
	sub	w19, w19, #1
.LVL1579:
	and	w19, w19, 65535
.LVL1580:
	b	.L1188
.LVL1581:
.L1193:
	.loc 4 383 0 discriminator 3
	mov	w0, w19
	.loc 4 381 0 discriminator 3
	add	w19, w19, 1
.LVL1582:
	.loc 4 383 0 discriminator 3
	bl	FtlBbmMapBadBlock
.LVL1583:
	.loc 4 381 0 discriminator 3
	and	w19, w19, 65535
.LVL1584:
	b	.L1192
.LVL1585:
.L1196:
	.loc 4 396 0
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L1197
	.loc 4 398 0
	strh	w19, [x21]
	b	.L1195
.L1197:
	.loc 4 402 0
	strh	w19, [x21, 4]
.L1198:
	.loc 4 414 0
	adrp	x0, .LANCHOR112
	.loc 4 411 0
	add	x19, x20, :lo12:.LANCHOR37
.LVL1586:
	.loc 4 414 0
	ldrh	w1, [x20, #:lo12:.LANCHOR37]
	.loc 4 416 0
	mov	w2, 2
	.loc 4 414 0
	ldr	x0, [x0, #:lo12:.LANCHOR112]
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
.LVL1587:
	.loc 4 418 0
	ldrh	w0, [x20, #:lo12:.LANCHOR37]
	bl	FtlBbmMapBadBlock
.LVL1588:
	.loc 4 419 0
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
.LVL1589:
	.loc 4 421 0
	bl	FtlBbmTblFlush
.LVL1590:
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
.LVL1591:
	.loc 4 427 0
	strh	w0, [x19, 4]
	.loc 4 425 0
	strh	w1, [x20, #:lo12:.LANCHOR37]
	.loc 4 429 0
	bl	FtlBbmTblFlush
.LVL1592:
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
	.loc 2 786 0
	.cfi_startproc
.LVL1593:
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
	.loc 2 794 0
	add	w1, w0, w1
.LVL1594:
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 2 786 0
	mov	w28, w0
.LVL1595:
	.loc 2 794 0
	adrp	x0, .LANCHOR16
.LVL1596:
	.loc 2 786 0
	stp	x21, x22, [sp, 32]
	.loc 2 794 0
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	.loc 2 786 0
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.loc 2 794 0
	cmp	w1, w0
	bhi	.L1212
	.loc 2 791 0
	adrp	x0, .LANCHOR22
	.loc 2 799 0
	adrp	x25, .LANCHOR12
	.loc 2 809 0
	adrp	x26, .LANCHOR23
	mov	x24, x2
	.loc 2 791 0
	ldrh	w21, [x0, #:lo12:.LANCHOR22]
	.loc 2 799 0
	add	x25, x25, :lo12:.LANCHOR12
	.loc 2 809 0
	add	x26, x26, :lo12:.LANCHOR23
	.loc 2 791 0
	mov	w23, 0
	lsr	w21, w28, w21
.LVL1597:
.L1206:
	.loc 2 797 0
	cbnz	w20, .L1211
.LVL1598:
.L1204:
	.loc 2 820 0
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
.LVL1599:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1600:
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
.LVL1601:
.L1211:
	.cfi_restore_state
	.loc 2 799 0
	ldrh	w1, [x25]
	.loc 2 798 0
	adrp	x0, .LANCHOR133
	adrp	x27, .LANCHOR124
	ldr	x0, [x0, #:lo12:.LANCHOR133]
	.loc 2 799 0
	udiv	w22, w28, w1
	.loc 2 798 0
	ldr	w2, [x0, w21, uxtw 2]
.LVL1602:
	.loc 2 802 0
	and	w0, w20, 65535
	.loc 2 799 0
	msub	w22, w22, w1, w28
.LVL1603:
	.loc 2 800 0
	sub	w19, w1, w22
	and	w19, w19, 65535
.LVL1604:
	.loc 2 802 0
	cmp	w20, w19
	csel	w19, w0, w19, cc
.LVL1605:
	.loc 2 803 0
	cbz	w2, .L1208
	.loc 2 803 0 is_stmt 0 discriminator 1
	cmp	w19, w1
	beq	.L1208
	.loc 2 805 0 is_stmt 1
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	.loc 2 806 0
	add	x0, x29, 144
	.loc 2 804 0
	str	w2, [x29, 116]
	.loc 2 807 0
	mov	w2, 1
.LVL1606:
	.loc 2 806 0
	str	x0, [x29, 128]
	.loc 2 807 0
	mov	w1, w2
	add	x0, x29, 112
.LVL1607:
	bl	FlashReadPages
.LVL1608:
.L1209:
	.loc 2 811 0
	lsl	w4, w19, 9
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	lsl	w22, w22, 7
.LVL1609:
	mov	w2, w4
	mov	x1, x24
	str	w4, [x29, 108]
	add	x0, x0, x22, sxtw 2
	bl	ftl_memcpy
.LVL1610:
	.loc 2 812 0
	ldr	x2, [x27, #:lo12:.LANCHOR124]
	mov	w1, w21
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	.loc 2 815 0
	sub	w20, w20, w19
.LVL1611:
	.loc 2 816 0
	add	w28, w28, w19
.LVL1612:
	.loc 2 814 0
	add	w21, w21, 1
.LVL1613:
	.loc 2 812 0
	bl	FtlMapWritePage
.LVL1614:
	.loc 2 813 0
	cmn	w0, #1
	.loc 2 817 0
	ldr	w4, [x29, 108]
	.loc 2 813 0
	csinv	w23, w23, wzr, ne
.LVL1615:
	.loc 2 817 0
	add	x24, x24, x4, sxtw
.LVL1616:
	b	.L1206
.LVL1617:
.L1208:
	.loc 2 809 0
	ldrh	w2, [x26]
.LVL1618:
	mov	w1, 0
	ldr	x0, [x27, #:lo12:.LANCHOR124]
	bl	ftl_memset
.LVL1619:
	b	.L1209
.LVL1620:
.L1212:
	.loc 2 795 0
	mov	w23, -1
	b	.L1204
	.cfi_endproc
.LFE263:
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
.LFB286:
	.loc 2 2110 0
	.cfi_startproc
	.loc 2 2111 0
	adrp	x0, .LANCHOR83
	add	x2, x0, :lo12:.LANCHOR83
	ldr	w1, [x0, #:lo12:.LANCHOR83]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1217
.LBB278:
.LBB279:
	.loc 2 2112 0
	mov	w0, 64
	.loc 2 2125 0
	mov	w1, 1
	.loc 2 2112 0
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	.loc 2 2113 0
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	str	w0, [x2, 88]
	.loc 2 2114 0
	adrp	x0, .LANCHOR70
	ldr	w0, [x0, #:lo12:.LANCHOR70]
	str	w0, [x2, 92]
	.loc 2 2115 0
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	str	w0, [x2, 8]
	.loc 2 2116 0
	adrp	x0, .LANCHOR65
	ldr	w0, [x0, #:lo12:.LANCHOR65]
	str	w0, [x2, 12]
	.loc 2 2117 0
	adrp	x0, .LANCHOR63
	ldr	w0, [x0, #:lo12:.LANCHOR63]
	str	w0, [x2, 16]
	.loc 2 2118 0
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	str	w0, [x2, 20]
	.loc 2 2119 0
	adrp	x0, .LANCHOR74
	ldr	w0, [x0, #:lo12:.LANCHOR74]
	str	w0, [x2, 28]
	.loc 2 2120 0
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	str	w0, [x2, 32]
	.loc 2 2121 0
	adrp	x0, .LANCHOR64
	ldr	w0, [x0, #:lo12:.LANCHOR64]
	str	w0, [x2, 36]
	.loc 2 2122 0
	adrp	x0, .LANCHOR66
	ldr	w0, [x0, #:lo12:.LANCHOR66]
	str	w0, [x2, 40]
	.loc 2 2123 0
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	str	w0, [x2, 44]
	.loc 2 2124 0
	adrp	x0, .LANCHOR78
	ldr	w0, [x0, #:lo12:.LANCHOR78]
	str	w0, [x2, 48]
	.loc 2 2125 0
	mov	w0, 0
	b	FtlVendorPartWrite
.LVL1621:
.L1217:
	ret
.LBE279:
.LBE278:
	.cfi_endproc
.LFE286:
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
.LFB265:
	.loc 2 861 0
	.cfi_startproc
.LVL1622:
	.loc 2 864 0
	adrp	x2, .LANCHOR166
	ldrh	w1, [x2, #:lo12:.LANCHOR166]
	cmp	w1, 31
	bhi	.L1223
	.loc 2 865 0
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR166]
.LVL1623:
	.loc 2 866 0
	mov	w1, 1
.LVL1624:
.L1220:
	adrp	x2, .LANCHOR127
	.loc 2 868 0
	cbnz	w0, .L1221
	.loc 2 868 0 is_stmt 0 discriminator 1
	ldr	x0, [x2, #:lo12:.LANCHOR127]
.LVL1625:
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
.LVL1626:
	cmp	w0, w1
	bcc	.L1225
.L1221:
	.loc 2 861 0 is_stmt 1
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 870 0
	ldr	x2, [x2, #:lo12:.LANCHOR127]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	.loc 2 871 0
	mov	w0, 17221
	.loc 2 874 0
	str	wzr, [x2, 4]
	.loc 2 871 0
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	.loc 2 872 0
	adrp	x0, .LANCHOR125
	ldrh	w1, [x0, #:lo12:.LANCHOR125]
	lsl	w0, w1, 9
	str	w0, [x2, 12]
	.loc 2 873 0
	ldr	w0, [x2, 8]
	add	w0, w0, 1
	str	w0, [x2, 8]
	.loc 2 875 0
	mov	w0, 64
	bl	FtlVendorPartWrite
.LVL1627:
	.loc 2 876 0
	bl	Ftl_save_ext_data
.LVL1628:
	.loc 2 878 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.LVL1629:
.L1223:
	.loc 2 862 0
	mov	w1, 32
	b	.L1220
.LVL1630:
.L1225:
	.loc 2 878 0
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
	.loc 2 823 0
	.cfi_startproc
.LVL1631:
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
	.loc 2 832 0
	add	w1, w0, w1
.LVL1632:
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.loc 2 823 0
	mov	w21, w0
.LVL1633:
	.loc 2 832 0
	adrp	x0, .LANCHOR16
.LVL1634:
	.loc 2 823 0
	stp	x23, x24, [sp, 48]
	.loc 2 832 0
	ldrh	w0, [x0, #:lo12:.LANCHOR16]
	.loc 2 823 0
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.loc 2 832 0
	cmp	w1, w0
	bhi	.L1235
	.loc 2 828 0
	adrp	x0, .LANCHOR22
	.loc 2 836 0
	adrp	x24, .LANCHOR12
	mov	x23, x2
	add	x24, x24, :lo12:.LANCHOR12
	.loc 2 828 0
	ldrh	w3, [x0, #:lo12:.LANCHOR22]
	mov	w22, 0
	.loc 2 835 0
	adrp	x25, .LANCHOR133
	.loc 2 828 0
	lsr	w26, w21, w3
.LVL1635:
.L1229:
	.loc 2 834 0
	cbnz	w20, .L1234
.LVL1636:
.L1227:
	.loc 2 857 0
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
.LVL1637:
	ldp	x21, x22, [sp, 32]
.LVL1638:
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
.LVL1639:
.L1234:
	.cfi_restore_state
	.loc 2 836 0
	ldrh	w19, [x24]
	.loc 2 835 0
	ldr	x0, [x25, #:lo12:.LANCHOR133]
	.loc 2 836 0
	udiv	w27, w21, w19
	.loc 2 835 0
	ldr	w1, [x0, w26, uxtw 2]
.LVL1640:
	.loc 2 839 0
	and	w0, w20, 65535
	.loc 2 836 0
	msub	w27, w27, w19, w21
.LVL1641:
	.loc 2 837 0
	sub	w19, w19, w27
	and	w19, w19, 65535
.LVL1642:
	.loc 2 839 0
	cmp	w20, w19
	csel	w19, w0, w19, cc
.LVL1643:
	lsl	w28, w19, 9
	.loc 2 840 0
	cbz	w1, .L1231
	.loc 2 842 0
	adrp	x4, .LANCHOR124
	.loc 2 844 0
	mov	w2, 1
	.loc 2 842 0
	str	x4, [x29, 104]
	.loc 2 847 0
	lsl	w27, w27, 7
.LVL1644:
	.loc 2 842 0
	ldr	x0, [x4, #:lo12:.LANCHOR124]
	str	x0, [x29, 120]
	.loc 2 843 0
	add	x0, x29, 144
	.loc 2 841 0
	str	w1, [x29, 116]
	.loc 2 844 0
	mov	w1, w2
.LVL1645:
	.loc 2 843 0
	str	x0, [x29, 128]
	.loc 2 844 0
	add	x0, x29, 112
.LVL1646:
	bl	FlashReadPages
.LVL1647:
	.loc 2 847 0
	ldr	x4, [x29, 104]
	mov	w2, w28
	.loc 2 846 0
	ldr	w0, [x29, 112]
	cmn	w0, #1
	.loc 2 847 0
	mov	x0, x23
	ldr	x1, [x4, #:lo12:.LANCHOR124]
	.loc 2 846 0
	csinv	w22, w22, wzr, ne
.LVL1648:
	.loc 2 847 0
	add	x1, x1, x27, sxtw 2
	bl	ftl_memcpy
.LVL1649:
.L1233:
	.loc 2 851 0
	add	w26, w26, 1
.LVL1650:
	.loc 2 852 0
	sub	w20, w20, w19
.LVL1651:
	.loc 2 853 0
	add	w21, w21, w19
.LVL1652:
	.loc 2 854 0
	add	x23, x23, x28, sxtw
.LVL1653:
	b	.L1229
.LVL1654:
.L1231:
	.loc 2 849 0
	mov	w2, w28
	mov	w1, 0
.LVL1655:
	mov	x0, x23
	bl	ftl_memset
.LVL1656:
	b	.L1233
.LVL1657:
.L1235:
	.loc 2 833 0
	mov	w22, -1
	b	.L1227
	.cfi_endproc
.LFE264:
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.FtlLoadEctTbl,"ax",@progbits
	.align	2
	.global	FtlLoadEctTbl
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
.LFB271:
	.loc 2 1334 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 1335 0
	mov	w0, 64
	.loc 2 1334 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	.loc 2 1335 0
	adrp	x19, .LANCHOR127
	adrp	x20, .LANCHOR125
	ldr	x2, [x19, #:lo12:.LANCHOR127]
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	bl	FtlVendorPartRead
.LVL1658:
	.loc 2 1336 0
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1238
.LBB282:
.LBB283:
	.loc 2 1338 0
	adrp	x1, .LC100
	adrp	x0, .LC71
	add	x1, x1, :lo12:.LC100
	add	x0, x0, :lo12:.LC71
	bl	printf
.LVL1659:
	.loc 2 1339 0
	ldr	x0, [x19, #:lo12:.LANCHOR127]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR125]
	lsl	w2, w2, 9
	bl	ftl_memset
.LVL1660:
.L1238:
.LBE283:
.LBE282:
	.loc 2 1344 0
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
	.loc 2 2130 0
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	.loc 2 2131 0
	mov	w1, 1
	mov	w0, 0
	.loc 2 2130 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 2131 0
	adrp	x19, .LANCHOR83
	.loc 2 2130 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2131 0
	add	x21, x19, :lo12:.LANCHOR83
	mov	x2, x21
	bl	FtlVendorPartRead
.LVL1661:
	.loc 2 2132 0
	ldr	w0, [x19, #:lo12:.LANCHOR83]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1241
	.loc 2 2133 0
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
.LVL1662:
	.loc 2 2134 0
	str	w20, [x19, #:lo12:.LANCHOR83]
.L1241:
	.loc 2 2137 0
	ldr	w1, [x19, #:lo12:.LANCHOR83]
	add	x0, x19, :lo12:.LANCHOR83
	cmp	w1, w20
	adrp	x1, .LANCHOR74
	bne	.L1242
	.loc 2 2138 0
	adrp	x2, .LANCHOR69
	ldr	w3, [x0, 88]
	str	w3, [x2, #:lo12:.LANCHOR69]
	.loc 2 2139 0
	adrp	x2, .LANCHOR70
	ldr	w3, [x0, 92]
	str	w3, [x2, #:lo12:.LANCHOR70]
	.loc 2 2140 0
	adrp	x2, .LANCHOR68
	ldr	w3, [x0, 8]
	str	w3, [x2, #:lo12:.LANCHOR68]
	.loc 2 2141 0
	adrp	x2, .LANCHOR65
	ldr	w3, [x0, 12]
	str	w3, [x2, #:lo12:.LANCHOR65]
	.loc 2 2142 0
	adrp	x2, .LANCHOR63
	ldr	w3, [x0, 16]
	str	w3, [x2, #:lo12:.LANCHOR63]
	.loc 2 2143 0
	adrp	x2, .LANCHOR67
	ldr	w3, [x0, 20]
	str	w3, [x2, #:lo12:.LANCHOR67]
	.loc 2 2145 0
	ldp	w2, w3, [x0, 28]
	.loc 2 2144 0
	str	w2, [x1, #:lo12:.LANCHOR74]
	.loc 2 2145 0
	adrp	x2, .LANCHOR76
	str	w3, [x2, #:lo12:.LANCHOR76]
	.loc 2 2146 0
	adrp	x2, .LANCHOR64
	ldr	w3, [x0, 36]
	str	w3, [x2, #:lo12:.LANCHOR64]
	.loc 2 2147 0
	adrp	x2, .LANCHOR66
	ldr	w3, [x0, 40]
	str	w3, [x2, #:lo12:.LANCHOR66]
	.loc 2 2148 0
	adrp	x2, .LANCHOR77
	ldr	w3, [x0, 44]
	str	w3, [x2, #:lo12:.LANCHOR77]
	.loc 2 2149 0
	ldr	w2, [x0, 48]
	adrp	x0, .LANCHOR78
	str	w2, [x0, #:lo12:.LANCHOR78]
.L1242:
	.loc 2 2152 0
	adrp	x0, .LANCHOR14
	adrp	x2, .LANCHOR73
	ldr	w1, [x1, #:lo12:.LANCHOR74]
	ldrh	w0, [x0, #:lo12:.LANCHOR14]
	ldr	w2, [x2, #:lo12:.LANCHOR73]
	.loc 2 2153 0
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	.loc 2 2152 0
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR5
	.loc 2 2153 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	.loc 2 2152 0
	ldrh	w1, [x1, #:lo12:.LANCHOR5]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR75
	str	w0, [x1, #:lo12:.LANCHOR75]
	.loc 2 2153 0
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
	.loc 2 1004 0
	.cfi_startproc
.LVL1663:
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.loc 2 1013 0
	adrp	x1, .LANCHOR81
	.loc 2 1019 0
	mov	w2, 19539
	.loc 2 1004 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.loc 2 1011 0
	adrp	x25, .LANCHOR109
	.loc 2 1004 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.loc 2 1010 0
	adrp	x22, .LANCHOR108
	.loc 2 1004 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.loc 2 1010 0
	adrp	x24, .LANCHOR39
	.loc 2 1004 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.loc 2 1010 0
	add	x28, x22, :lo12:.LANCHOR108
	.loc 2 1011 0
	ldr	x21, [x25, #:lo12:.LANCHOR109]
	.loc 2 1019 0
	movk	w2, 0x4654, lsl 16
	.loc 2 1004 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.loc 2 1013 0
	add	x19, x1, :lo12:.LANCHOR81
	.loc 2 1010 0
	ldr	x0, [x24, #:lo12:.LANCHOR39]
	.loc 2 1041 0
	adrp	x23, .LANCHOR71
	.loc 2 1013 0
	ldrh	w1, [x1, #:lo12:.LANCHOR81]
	.loc 2 1057 0
	adrp	x27, .LANCHOR20
	.loc 2 1011 0
	stp	x0, x21, [x28, 8]
.LVL1664:
	.loc 2 1005 0
	mov	w26, 65535
	.loc 2 1013 0
	strh	w1, [x21, 2]
	.loc 2 1014 0
	mov	w1, -3932
	strh	w1, [x21]
	.loc 2 1015 0
	ldr	w1, [x19, 8]
	.loc 2 1016 0
	stp	w1, wzr, [x21, 4]
	.loc 2 1019 0
	adrp	x1, .LANCHOR79
	add	x20, x1, :lo12:.LANCHOR79
	.loc 2 1017 0
	str	wzr, [x21, 12]
	.loc 2 1019 0
	str	w2, [x1, #:lo12:.LANCHOR79]
	.loc 2 1020 0
	mov	w1, 64
	movk	w1, 0x5000, lsl 16
	str	w1, [x20, 4]
	.loc 2 1021 0
	ldrh	w1, [x19, 6]
	.loc 2 1024 0
	adrp	x2, .LANCHOR51
	.loc 2 1021 0
	strh	w1, [x20, 8]
	.loc 2 1022 0
	adrp	x1, .LANCHOR10
	ldrh	w1, [x1, #:lo12:.LANCHOR10]
	strb	w1, [x20, 10]
	.loc 2 1024 0
	add	x1, x2, :lo12:.LANCHOR51
	ldrh	w2, [x2, #:lo12:.LANCHOR51]
	strh	w2, [x20, 14]
	.loc 2 1025 0
	ldrh	w2, [x1, 2]
	ldrb	w3, [x1, 6]
	.loc 2 1026 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 11]
	.loc 2 1025 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 16]
	.loc 2 1028 0
	adrp	x2, .LANCHOR52
	add	x1, x2, :lo12:.LANCHOR52
	ldrh	w2, [x2, #:lo12:.LANCHOR52]
	.loc 2 1029 0
	ldrb	w3, [x1, 6]
	.loc 2 1028 0
	strh	w2, [x20, 18]
	.loc 2 1029 0
	ldrh	w2, [x1, 2]
	.loc 2 1030 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 12]
	.loc 2 1029 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 20]
	.loc 2 1032 0
	adrp	x2, .LANCHOR53
	add	x1, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	.loc 2 1033 0
	ldrb	w3, [x1, 6]
	.loc 2 1032 0
	strh	w2, [x20, 22]
	.loc 2 1033 0
	ldrh	w2, [x1, 2]
	.loc 2 1034 0
	ldrb	w1, [x1, 8]
	strb	w1, [x20, 13]
	.loc 2 1036 0
	adrp	x1, .LANCHOR73
	.loc 2 1033 0
	orr	w2, w3, w2, lsl 6
	strh	w2, [x20, 24]
	.loc 2 1036 0
	ldr	w1, [x1, #:lo12:.LANCHOR73]
	str	w1, [x20, 32]
	.loc 2 1041 0
	ldr	w1, [x23, #:lo12:.LANCHOR71]
	str	w1, [x20, 40]
	.loc 2 1042 0
	adrp	x1, .LANCHOR72
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	str	w1, [x20, 36]
	.loc 2 1047 0
	adrp	x1, .LANCHOR23
	ldrh	w2, [x1, #:lo12:.LANCHOR23]
	mov	w1, 255
	bl	ftl_memset
.LVL1665:
	.loc 2 1048 0
	ldr	x0, [x28, 8]
	mov	x1, x20
	mov	w2, 48
	.loc 2 1049 0
	adrp	x20, .LANCHOR5
	.loc 2 1048 0
	bl	ftl_memcpy
.LVL1666:
	.loc 2 1049 0
	adrp	x1, .LANCHOR43
	ldrh	w2, [x20, #:lo12:.LANCHOR5]
	ldr	x0, [x28, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
.LVL1667:
	.loc 2 1050 0
	ldrh	w0, [x20, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR1
	ldr	x3, [x28, 8]
	.loc 2 1007 0
	mov	w20, 0
	.loc 2 1050 0
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	w2, w2, 4
	add	x0, x0, 48
	and	x0, x0, -4
	add	x0, x3, x0
	bl	ftl_memcpy
.LVL1668:
	.loc 2 1051 0
	mov	w0, 0
	bl	FtlUpdateVaildLpn
.LVL1669:
	.loc 2 1077 0
	add	x0, x27, :lo12:.LANCHOR20
	str	x0, [x29, 104]
.LVL1670:
.L1245:
	.loc 2 1053 0
	ldr	x0, [x24, #:lo12:.LANCHOR39]
	.loc 2 1056 0
	mov	w3, 1
	.loc 2 1053 0
	str	x0, [x28, 8]
	.loc 2 1056 0
	mov	w2, w3
	.loc 2 1054 0
	ldr	x0, [x25, #:lo12:.LANCHOR109]
	.loc 2 1055 0
	ldrh	w1, [x19, 2]
	.loc 2 1054 0
	str	x0, [x28, 16]
	.loc 2 1055 0
	ldrh	w0, [x19]
	orr	w0, w1, w0, lsl 10
	.loc 2 1056 0
	mov	w1, w3
	.loc 2 1055 0
	str	w0, [x28, 4]
	.loc 2 1056 0
	mov	x0, x28
	bl	FlashProgPages
.LVL1671:
	.loc 2 1057 0
	ldrh	w0, [x27, #:lo12:.LANCHOR20]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1246
	.loc 2 1059 0
	ldrh	w0, [x19]
	.loc 2 1058 0
	ldrh	w26, [x19, 4]
.LVL1672:
	.loc 2 1060 0
	strh	wzr, [x19, 2]
	.loc 2 1059 0
	strh	w0, [x19, 4]
	.loc 2 1061 0
	bl	FtlFreeSysBlkQueueOut
.LVL1673:
	strh	w0, [x19]
	.loc 2 1066 0
	ldr	w1, [x23, #:lo12:.LANCHOR71]
	.loc 2 1070 0
	mov	w3, 1
	.loc 2 1066 0
	str	w1, [x19, 8]
	add	w2, w1, 1
	str	w2, [x23, #:lo12:.LANCHOR71]
	.loc 2 1067 0
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	.loc 2 1069 0
	strh	w0, [x21, 2]
	.loc 2 1070 0
	mov	w2, w3
	.loc 2 1068 0
	str	w1, [x21, 4]
	.loc 2 1070 0
	mov	x0, x28
	mov	w1, w3
	bl	FlashProgPages
.LVL1674:
.L1246:
	.loc 2 1072 0
	ldrh	w0, [x19, 2]
	.loc 2 1073 0
	ldr	w1, [x28]
	.loc 2 1072 0
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	.loc 2 1073 0
	cmn	w1, #1
	bne	.L1247
	.loc 2 1075 0
	cmp	w0, 1
	bne	.L1248
	.loc 2 1075 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR167
	adrp	x0, .LC1
	mov	w2, 1075
	add	x1, x1, :lo12:.LANCHOR167
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1675:
.L1248:
	.loc 2 1076 0 is_stmt 1
	ldrh	w0, [x19, 2]
	cmp	w0, 1
	bne	.L1249
	.loc 2 1077 0
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1249:
	.loc 2 1078 0
	add	w20, w20, 1
.LVL1676:
	and	w20, w20, 65535
.LVL1677:
	.loc 2 1079 0
	cmp	w20, 3
	bls	.L1245
	.loc 2 1080 0
	add	x22, x22, :lo12:.LANCHOR108
	adrp	x0, .LC101
	mov	w2, w20
	add	x0, x0, :lo12:.LC101
	ldr	w1, [x22, 4]
	bl	printf
.LVL1678:
.L1251:
	b	.L1251
.L1247:
	.loc 2 1086 0
	cmp	w0, 1
	beq	.L1245
	.loc 2 1089 0
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1252
	.loc 2 1090 0
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
.LVL1679:
.L1252:
	.loc 2 1092 0
	ldp	x19, x20, [sp, 16]
.LVL1680:
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
.LVL1681:
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.LVL1682:
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
	.section	.text.FtlVpcCheckAndModify,"ax",@progbits
	.align	2
	.global	FtlVpcCheckAndModify
	.type	FtlVpcCheckAndModify, %function
FtlVpcCheckAndModify:
.LFB289:
	.loc 2 2192 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 2197 0
	adrp	x1, .LANCHOR168
	adrp	x0, .LC91
	add	x1, x1, :lo12:.LANCHOR168
	.loc 2 2192 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.loc 2 2197 0
	add	x0, x0, :lo12:.LC91
	.loc 2 2192 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 2198 0
	adrp	x20, .LANCHOR128
	.loc 2 2192 0
	stp	x23, x24, [sp, 48]
	.loc 2 2199 0
	adrp	x21, .LANCHOR62
	.loc 2 2192 0
	str	x25, [sp, 64]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 25, -32
	.loc 2 2197 0
	bl	printf
.LVL1683:
	.loc 2 2198 0
	adrp	x0, .LANCHOR6
	.loc 2 2199 0
	mov	w19, 0
	add	x21, x21, :lo12:.LANCHOR62
	.loc 2 2198 0
	mov	w1, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL1684:
.L1258:
	.loc 2 2199 0 discriminator 1
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L1260
	.loc 2 2206 0 discriminator 1
	adrp	x22, .LANCHOR5
	.loc 2 2209 0 discriminator 1
	adrp	x23, .LC102
	.loc 2 2206 0 discriminator 1
	add	x22, x22, :lo12:.LANCHOR5
	.loc 2 2209 0 discriminator 1
	add	x23, x23, :lo12:.LC102
	mov	w19, 0
.LVL1685:
	.loc 2 2207 0 discriminator 1
	adrp	x25, .LANCHOR43
	mov	w24, 65535
.L1261:
.LVL1686:
	.loc 2 2206 0 discriminator 1
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L1265
	.loc 2 2218 0
	ldp	x19, x20, [sp, 16]
.LVL1687:
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
.LVL1688:
.L1260:
	.cfi_restore_state
	.loc 2 2200 0
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w19
	bl	log2phys
.LVL1689:
	.loc 2 2201 0
	ldr	w0, [x29, 92]
	cmn	w0, #1
	beq	.L1259
	.loc 2 2202 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1690:
	.loc 2 2203 0
	ldr	x2, [x20, #:lo12:.LANCHOR128]
	ubfiz	x0, x0, 1, 16
.LVL1691:
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
.L1259:
	.loc 2 2199 0 discriminator 2
	add	w19, w19, 1
.LVL1692:
	b	.L1258
.LVL1693:
.L1265:
	.loc 2 2207 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	ubfiz	x21, x19, 1, 16
	ldrh	w2, [x0, x21]
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w3, [x0, x21]
	cmp	w2, w3
	beq	.L1263
	.loc 2 2207 0 is_stmt 0 discriminator 1
	cmp	w2, w24
	beq	.L1263
	.loc 2 2209 0 is_stmt 1
	mov	w1, w19
	mov	x0, x23
	bl	printf
.LVL1694:
	.loc 2 2210 0
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	beq	.L1263
	.loc 2 2210 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	beq	.L1263
	.loc 2 2210 0 discriminator 2
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w19
	beq	.L1263
	.loc 2 2211 0 is_stmt 1
	ldr	x0, [x20, #:lo12:.LANCHOR128]
	ldrh	w1, [x0, x21]
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	strh	w1, [x0, x21]
	.loc 2 2212 0
	mov	w0, w19
	bl	update_vpc_list
.LVL1695:
	.loc 2 2213 0
	bl	l2p_flush
.LVL1696:
	.loc 2 2214 0
	bl	FtlVpcTblFlush
.LVL1697:
.L1263:
	.loc 2 2206 0 discriminator 2
	add	w19, w19, 1
.LVL1698:
	and	w19, w19, 65535
.LVL1699:
	b	.L1261
	.cfi_endproc
.LFE289:
	.size	FtlVpcCheckAndModify, .-FtlVpcCheckAndModify
	.section	.text.allocate_new_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_new_data_superblock
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
.LFB299:
	.loc 2 2631 0
	.cfi_startproc
.LVL1700:
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	.loc 2 2632 0
	ldrh	w19, [x0]
.LVL1701:
	.loc 2 2631 0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	.loc 2 2631 0
	mov	x21, x0
	.loc 2 2633 0
	adrp	x0, .LANCHOR5
.LVL1702:
	ldrh	w0, [x0, #:lo12:.LANCHOR5]
	cmp	w0, w19
	bcs	.L1271
	.loc 2 2633 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR169
	adrp	x0, .LC1
	mov	w2, 2633
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1703:
.L1271:
	.loc 2 2635 0 is_stmt 1
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1272
	.loc 2 2636 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x19, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1273
	.loc 2 2637 0
	mov	w0, w19
	bl	INSERT_DATA_LIST
.LVL1704:
.L1272:
	.loc 2 2642 0
	adrp	x1, .LANCHOR151
	.loc 2 2641 0
	mov	w0, 1
	strb	w0, [x21, 8]
	.loc 2 2642 0
	mov	w2, 65535
	ldrh	w0, [x1, #:lo12:.LANCHOR151]
	mov	x20, x1
	cmp	w0, w2
	beq	.L1274
	.loc 2 2643 0
	cmp	w19, w0
	bne	.L1275
	.loc 2 2643 0 is_stmt 0 discriminator 1
	adrp	x2, .LANCHOR43
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1276
.L1275:
	.loc 2 2644 0 is_stmt 1
	bl	update_vpc_list
.LVL1705:
.L1276:
	.loc 2 2645 0
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR151]
.L1274:
	.loc 2 2647 0
	mov	x0, x21
	bl	allocate_data_superblock
.LVL1706:
	.loc 2 2648 0
	bl	l2p_flush
.LVL1707:
	.loc 2 2649 0
	mov	w0, 0
	bl	FtlEctTblFlush
.LVL1708:
	.loc 2 2650 0
	bl	FtlVpcTblFlush
.LVL1709:
	.loc 2 2652 0
	ldr	x21, [sp, 32]
.LVL1710:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
.LVL1711:
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
.LVL1712:
.L1273:
	.cfi_restore_state
	.loc 2 2639 0
	mov	w0, w19
	bl	INSERT_FREE_LIST
.LVL1713:
	b	.L1272
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
.LVL1714:
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 3 911 0
	mov	w2, 0
.LVL1715:
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
.LVL1716:
	.loc 3 926 0
	adrp	x23, .LANCHOR83
	add	x21, x0, x21
	.loc 3 918 0
	add	x24, x24, :lo12:.LANCHOR19
	.loc 3 926 0
	add	x23, x23, :lo12:.LANCHOR83
	.loc 3 911 0
	bl	FlashProgPages
.LVL1717:
.L1282:
	.loc 3 913 0 discriminator 1
	cmp	x20, x21
	beq	.L1289
	sub	x22, x20, #4
	.loc 3 917 0
	adrp	x25, .LANCHOR43
	b	.L1290
.L1285:
	.loc 3 915 0
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1718:
	.loc 3 916 0
	ldrh	w1, [x19]
	cmp	w1, w0, uxth
	bne	.L1283
	.loc 3 917 0
	ldr	x2, [x25, #:lo12:.LANCHOR43]
	ubfiz	x1, x1, 1, 16
	ldrh	w3, [x19, 4]
	ldrh	w0, [x2, x1]
.LVL1719:
	sub	w0, w0, w3
	strh	w0, [x2, x1]
	.loc 3 919 0
	strb	wzr, [x19, 6]
	.loc 3 918 0
	ldrh	w0, [x24]
	strh	w0, [x19, 2]
	.loc 3 920 0
	strh	wzr, [x19, 4]
.L1283:
	.loc 3 922 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1284
	.loc 3 923 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL1720:
.L1284:
	.loc 3 926 0
	ldr	w0, [x23, 96]
	add	w0, w0, 1
	str	w0, [x23, 96]
	.loc 3 927 0
	ldr	w0, [x20]
	lsr	w0, w0, 10
	bl	FtlGcMarkBadPhyBlk
.LVL1721:
	.loc 3 928 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL1722:
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
.LVL1723:
.L1290:
	.loc 3 914 0
	ldr	w0, [x20, -4]
	cmn	w0, #1
	beq	.L1285
	.loc 3 933 0
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1286
	.loc 3 933 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 933
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1724:
.L1286:
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
.LVL1725:
	.loc 3 937 0
	ldr	x0, [x22, 16]
	ldr	w3, [x0, 12]
.LVL1726:
	.loc 3 939 0
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
.LVL1727:
	and	w1, w0, 65535
	mov	w22, w1
.LVL1728:
	.loc 3 940 0
	cmn	w3, #1
	beq	.L1287
	.loc 3 942 0
	adrp	x2, .LANCHOR43
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR43]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1288
	.loc 3 943 0
	adrp	x0, .LC103
	mov	w2, 0
	add	x0, x0, :lo12:.LC103
	bl	printf
.LVL1729:
.L1288:
	.loc 3 944 0
	mov	w0, w22
	bl	decrement_vpc_count
.LVL1730:
.L1287:
	add	x20, x20, 32
	b	.L1282
.LVL1731:
.L1289:
	.loc 3 948 0
	adrp	x0, .LANCHOR3
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1281
	.loc 3 948 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR170
	adrp	x0, .LC1
	mov	w2, 948
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1732:
.L1281:
	.loc 3 949 0 is_stmt 1
	ldp	x19, x20, [sp, 16]
.LVL1733:
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
	.section	.text.FtlCacheWriteBack,"ax",@progbits
	.align	2
	.global	FtlCacheWriteBack
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
.LFB216:
	.loc 3 952 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 3 953 0
	adrp	x19, .LANCHOR150
	ldr	x0, [x19, #:lo12:.LANCHOR150]
	cbz	x0, .L1297
	.loc 3 954 0
	adrp	x1, .LANCHOR171
	mov	w2, 0
	ldr	x3, [x1, #:lo12:.LANCHOR171]
	mov	w1, 1
	bl	FtlProgPages
.LVL1734:
	.loc 3 955 0
	str	xzr, [x19, #:lo12:.LANCHOR150]
.L1297:
	.loc 3 958 0
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE216:
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
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
	.loc 3 798 0
	bl	FtlCacheWriteBack
.LVL1735:
	.loc 3 799 0
	bl	l2p_flush
.LVL1736:
	.loc 3 800 0
	mov	w0, 1
	bl	FtlEctTblFlush
.LVL1737:
	.loc 3 801 0
	bl	FtlVpcTblFlush
.LVL1738:
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
	adrp	x0, .LANCHOR88
	ldr	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 1
	bne	.L1307
	.loc 3 806 0
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 3 808 0
	bl	FtlSysFlush
.LVL1739:
	.loc 3 810 0
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
.L1307:
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
	.loc 3 1157 0
	.cfi_startproc
.LVL1740:
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	w20, w0
	mov	w19, w1
	.loc 3 1164 0
	add	w1, w0, w1
.LVL1741:
	adrp	x0, .LANCHOR34
.LVL1742:
	.loc 3 1157 0
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.loc 3 1164 0
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1318
	.loc 3 1167 0
	cmp	w19, 31
	bhi	.L1312
.LVL1743:
.L1326:
	.loc 3 1200 0
	mov	w0, 0
.L1310:
	.loc 3 1201 0
	ldp	x19, x20, [sp, 16]
.LVL1744:
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
.LVL1745:
.L1312:
	.cfi_restore_state
	.loc 3 1172 0
	adrp	x22, .LANCHOR12
	.loc 3 1170 0
	bl	FtlCacheWriteBack
.LVL1746:
	.loc 3 1172 0
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	udiv	w21, w20, w1
.LVL1747:
	.loc 3 1173 0
	msub	w20, w1, w21, w20
.LVL1748:
	.loc 3 1174 0
	ands	w20, w20, 65535
	beq	.L1313
.LVL1749:
	.loc 3 1175 0
	sub	w1, w1, w20
.LVL1750:
	.loc 3 1176 0
	add	w21, w21, 1
.LVL1751:
	.loc 3 1175 0
	cmp	w1, w19
	csel	w1, w1, w19, ls
	.loc 3 1177 0
	sub	w19, w19, w1, uxth
.LVL1752:
.L1313:
	.loc 3 1184 0
	adrp	x20, .LANCHOR172
.LVL1753:
	.loc 3 1185 0
	adrp	x23, .LANCHOR64
	.loc 3 1184 0
	add	x20, x20, :lo12:.LANCHOR172
	.loc 3 1185 0
	add	x23, x23, :lo12:.LANCHOR64
	.loc 3 1180 0
	mov	w0, -1
	str	w0, [x29, 76]
.LVL1754:
.L1314:
	.loc 3 1181 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	cmp	w19, w0
	bcs	.L1316
	.loc 3 1194 0
	adrp	x0, .LANCHOR172
	ldr	w1, [x0, #:lo12:.LANCHOR172]
	cmp	w1, 32
	bls	.L1326
	.loc 3 1196 0
	str	wzr, [x0, #:lo12:.LANCHOR172]
	.loc 3 1197 0
	bl	l2p_flush
.LVL1755:
	.loc 3 1198 0
	bl	FtlVpcTblFlush
.LVL1756:
	b	.L1326
.L1316:
	.loc 3 1182 0
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w21
	bl	log2phys
.LVL1757:
	.loc 3 1183 0
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1315
	.loc 3 1184 0
	ldr	w0, [x20]
	.loc 3 1186 0
	mov	w2, 1
	add	x1, x29, 76
	.loc 3 1184 0
	add	w0, w0, 1
	str	w0, [x20]
	.loc 3 1185 0
	ldr	w0, [x23]
	add	w0, w0, 1
	str	w0, [x23]
	.loc 3 1186 0
	mov	w0, w21
	bl	log2phys
.LVL1758:
	.loc 3 1187 0
	ldr	w0, [x29, 72]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1759:
	.loc 3 1188 0
	bl	decrement_vpc_count
.LVL1760:
.L1315:
	.loc 3 1191 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	.loc 3 1190 0
	add	w21, w21, 1
.LVL1761:
	.loc 3 1191 0
	sub	w19, w19, w0
.LVL1762:
	b	.L1314
.LVL1763:
.L1318:
	.loc 3 1165 0
	mov	w0, -1
	b	.L1310
	.cfi_endproc
.LFE218:
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
.LFB308:
	.loc 5 112 0
	.cfi_startproc
.LVL1764:
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
.LVL1765:
	.loc 5 119 0
	bne	.L1328
.LVL1766:
.L1338:
	.loc 5 152 0
	adrp	x0, .LANCHOR153
	.loc 5 153 0
	ldrh	w1, [x19, #:lo12:.LANCHOR53]
	add	x22, x19, :lo12:.LANCHOR53
	.loc 5 152 0
	str	wzr, [x0, #:lo12:.LANCHOR153]
	.loc 5 153 0
	mov	w0, 65535
	cmp	w1, w0
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
.LVL1767:
.L1328:
	.cfi_restore_state
	.loc 5 121 0
	cbz	w0, .L1331
.LVL1768:
	.loc 5 123 0
	adrp	x0, .LANCHOR157
.LVL1769:
	ldrh	w3, [x0, #:lo12:.LANCHOR157]
	cmp	w3, w2
	beq	.L1332
.L1333:
	.loc 5 122 0
	mov	w1, 2
.LVL1770:
.L1331:
	.loc 5 131 0
	add	x0, x19, :lo12:.LANCHOR53
	bl	FtlGcScanTempBlk
.LVL1771:
	str	w0, [x29, 108]
	.loc 5 132 0
	cmn	w0, #1
	beq	.L1334
	.loc 5 135 0
	adrp	x0, .LANCHOR40
	ubfiz	x20, x20, 1, 16
.LVL1772:
	ldr	x1, [x0, #:lo12:.LANCHOR40]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L1335
	.loc 5 136 0
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	.loc 5 137 0
	mov	w0, 1
	bl	FtlEctTblFlush
.LVL1773:
.L1335:
	.loc 5 139 0
	adrp	x0, .LANCHOR153
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR153]
	cbnz	w1, .L1336
	.loc 5 140 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	.loc 5 141 0
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1774:
	.loc 5 142 0
	bl	FtlBbmTblFlush
.LVL1775:
.L1336:
	.loc 5 144 0
	str	wzr, [x19, #:lo12:.LANCHOR153]
.L1347:
	.loc 5 149 0
	mov	w0, 1
	b	.L1327
.LVL1776:
.L1332:
	.loc 5 124 0
	strh	wzr, [x0, #:lo12:.LANCHOR157]
	.loc 5 125 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 17
	bhi	.L1333
	b	.L1331
.LVL1777:
.L1334:
	.loc 5 148 0
	adrp	x0, .LANCHOR157
	ldrh	w1, [x0, #:lo12:.LANCHOR157]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1347
	b	.L1338
.LVL1778:
.L1351:
	.loc 5 160 0
	bl	FtlCacheWriteBack
.LVL1779:
	.loc 5 162 0
	adrp	x20, .LANCHOR99
	ldrb	w0, [x22, 7]
	ldrh	w2, [x21, #:lo12:.LANCHOR19]
	ldrh	w1, [x20, #:lo12:.LANCHOR99]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1339
	.loc 5 162 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR173
	adrp	x0, .LC1
	mov	w2, 162
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1780:
.L1339:
	.loc 5 163 0 is_stmt 1
	add	x0, x19, :lo12:.LANCHOR53
	adrp	x23, .LANCHOR43
	ldrh	w3, [x21, #:lo12:.LANCHOR19]
	.loc 5 168 0
	adrp	x25, .LANCHOR62
	.loc 5 163 0
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	.loc 5 168 0
	adrp	x26, .LANCHOR173
	.loc 5 163 0
	ldrb	w0, [x0, 7]
	.loc 5 168 0
	add	x25, x25, :lo12:.LANCHOR62
	.loc 5 163 0
	ldr	x1, [x23, #:lo12:.LANCHOR43]
	.loc 5 168 0
	add	x26, x26, :lo12:.LANCHOR173
	.loc 5 165 0
	mov	w21, 0
	.loc 5 163 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	.loc 5 164 0
	adrp	x1, .LANCHOR68
	ldrh	w0, [x20, #:lo12:.LANCHOR99]
	ldr	w2, [x1, #:lo12:.LANCHOR68]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR68]
.LVL1781:
.L1340:
	.loc 5 165 0 discriminator 1
	ldrh	w0, [x20, #:lo12:.LANCHOR99]
	cmp	w0, w21
	bhi	.L1344
	.loc 5 181 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1782:
	.loc 5 182 0
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	ldr	x2, [x23, #:lo12:.LANCHOR43]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L1345
	.loc 5 183 0
	bl	INSERT_DATA_LIST
.LVL1783:
.L1346:
	.loc 5 188 0
	adrp	x0, .LANCHOR97
	.loc 5 186 0
	mov	w21, -1
.LVL1784:
	.loc 5 187 0
	strh	wzr, [x20, #:lo12:.LANCHOR99]
	.loc 5 186 0
	strh	w21, [x19, #:lo12:.LANCHOR53]
	.loc 5 188 0
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	.loc 5 189 0
	bl	l2p_flush
.LVL1785:
	.loc 5 190 0
	bl	FtlVpcTblFlush
.LVL1786:
	.loc 5 191 0
	adrp	x0, .LANCHOR48
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L1354
	.loc 5 192 0
	adrp	x0, .LANCHOR82
	.loc 5 193 0
	mov	w1, 20
	.loc 5 192 0
	strh	w21, [x0, #:lo12:.LANCHOR82]
	.loc 5 193 0
	adrp	x0, .LANCHOR84
	strh	w1, [x0, #:lo12:.LANCHOR84]
	b	.L1354
.LVL1787:
.L1344:
	.loc 5 166 0
	adrp	x0, .LANCHOR100
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR100]
	umull	x24, w21, w24
	.loc 5 168 0
	ldr	w0, [x25]
	.loc 5 166 0
	add	x22, x27, x24
.LVL1788:
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
.LVL1789:
.L1341:
	.loc 5 169 0 is_stmt 1
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
.LVL1790:
	.loc 5 170 0
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L1342
	.loc 5 171 0
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1791:
	mov	w24, w0
.LVL1792:
	.loc 5 172 0
	ldr	w0, [x22, 8]
.LVL1793:
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
.LVL1794:
	.loc 5 173 0
	mov	w0, w24
.LVL1795:
.L1353:
	.loc 5 177 0
	bl	decrement_vpc_count
.LVL1796:
.L1343:
	.loc 5 165 0 discriminator 2
	add	w21, w21, 1
.LVL1797:
	and	w21, w21, 65535
.LVL1798:
	b	.L1340
.L1342:
	.loc 5 175 0
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L1343
	.loc 5 177 0
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	b	.L1353
.LVL1799:
.L1345:
	.loc 5 185 0
	bl	INSERT_FREE_LIST
.LVL1800:
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
.LVL1801:
	.loc 5 291 0
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR19]
	cmp	w1, w0
	bcc	.L1355
.LBB286:
.LBB287:
	.loc 5 293 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL1802:
	.loc 5 294 0
	mov	w0, 0
	bl	FtlGcFreeTempBlock
.LVL1803:
	.loc 5 295 0
	adrp	x0, .LANCHOR153
	str	wzr, [x0, #:lo12:.LANCHOR153]
.L1355:
.LBE287:
.LBE286:
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
	.loc 2 2032 0
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	.loc 2 2033 0
	adrp	x0, .LANCHOR163
	.loc 2 2032 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	.loc 2 2035 0
	adrp	x19, .LANCHOR51
	add	x19, x19, :lo12:.LANCHOR51
	.loc 2 2033 0
	str	wzr, [x0, #:lo12:.LANCHOR163]
	.loc 2 2035 0
	mov	x0, x19
	bl	FtlRecoverySuperblock
.LVL1804:
	.loc 2 2036 0
	mov	x0, x19
	.loc 2 2037 0
	adrp	x19, .LANCHOR52
	.loc 2 2036 0
	bl	FtlSlcSuperblockCheck
.LVL1805:
	.loc 2 2037 0
	add	x19, x19, :lo12:.LANCHOR52
	mov	x0, x19
	bl	FtlRecoverySuperblock
.LVL1806:
	.loc 2 2038 0
	mov	x0, x19
	bl	FtlSlcSuperblockCheck
.LVL1807:
	.loc 2 2039 0
	bl	FtlGcPageRecovery
.LVL1808:
	.loc 2 2040 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1809:
	.loc 2 2042 0
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
	adrp	x19, .LANCHOR91
	adrp	x20, .LANCHOR121
	ldr	w1, [x19, #:lo12:.LANCHOR91]
	.loc 5 321 0
	add	x19, x19, :lo12:.LANCHOR91
	.loc 5 320 0
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FlashProgPages
.LVL1810:
	.loc 5 321 0
	mov	w11, 0
.LVL1811:
.L1361:
	.loc 5 321 0 is_stmt 0 discriminator 1
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L1364
	.loc 5 335 0 is_stmt 1
	ldr	x0, [x20, #:lo12:.LANCHOR121]
	bl	FtlGcBufFree
.LVL1812:
	.loc 5 336 0
	str	wzr, [x19]
	.loc 5 337 0
	adrp	x0, .LANCHOR53+4
	ldrh	w0, [x0, #:lo12:.LANCHOR53+4]
	cbnz	w0, .L1365
	.loc 5 338 0
	mov	w0, 1
	bl	FtlGcFreeTempBlock
.LVL1813:
	b	.L1367
.LVL1814:
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
	adrp	x3, .LANCHOR43
	ldrh	w4, [x0, #:lo12:.LANCHOR53]
	ldr	x3, [x3, #:lo12:.LANCHOR43]
	strh	wzr, [x3, x4, lsl 1]
	.loc 5 324 0
	strh	w2, [x0, #:lo12:.LANCHOR53]
	.loc 5 325 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	.loc 5 326 0
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.LVL1815:
	.loc 5 327 0
	bl	FtlBbmTblFlush
.LVL1816:
	.loc 5 328 0
	bl	FtlGcPageVarInit
.LVL1817:
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
.LVL1818:
.L1362:
	.cfi_restore_state
	.loc 5 331 0 discriminator 2
	ldr	x0, [x1, 16]
.LVL1819:
	.loc 5 332 0 discriminator 2
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
.LVL1820:
	bl	FtlGcUpdatePage
.LVL1821:
	.loc 5 321 0 discriminator 2
	add	w11, w11, 1
.LVL1822:
	and	w11, w11, 65535
.LVL1823:
	b	.L1361
.LVL1824:
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
	.loc 5 302 0 is_stmt 1
	bl	FtlCacheWriteBack
.LVL1825:
	.loc 5 303 0
	mov	w0, 0
	bl	FtlGcFreeTempBlock
.LVL1826:
	.loc 5 304 0
	add	x0, x19, :lo12:.LANCHOR53
	strb	wzr, [x0, 8]
	.loc 5 305 0
	bl	allocate_data_superblock
.LVL1827:
	.loc 5 306 0
	adrp	x0, .LANCHOR97
	strh	wzr, [x0, #:lo12:.LANCHOR97]
	.loc 5 307 0
	adrp	x0, .LANCHOR99
	strh	wzr, [x0, #:lo12:.LANCHOR99]
	.loc 5 308 0
	bl	l2p_flush
.LVL1828:
	.loc 5 309 0
	mov	w0, 0
	bl	FtlEctTblFlush
.LVL1829:
	.loc 5 310 0
	bl	FtlVpcTblFlush
.LVL1830:
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
.LVL1831:
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
.LVL1832:
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
.LVL1833:
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
	adrp	x0, .LANCHOR157
.LVL1834:
	ldrh	w1, [x0, #:lo12:.LANCHOR157]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1374
.L1377:
.LVL1835:
.LBB291:
.LBB292:
	.loc 5 489 0
	adrp	x0, .LANCHOR102
	mov	w3, 65535
	ldrh	w2, [x0, #:lo12:.LANCHOR102]
	cmp	w2, w3
	bne	.L1375
.L1376:
	.loc 5 496 0
	adrp	x2, .LANCHOR86
	.loc 5 497 0
	adrp	x19, .LANCHOR82
	mov	w20, 65535
	.loc 5 496 0
	ldr	w1, [x2, #:lo12:.LANCHOR86]
	.loc 5 497 0
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	.loc 5 496 0
	add	w1, w1, 1
	add	w1, w1, w24, lsl 7
	str	w1, [x2, #:lo12:.LANCHOR86]
	.loc 5 497 0
	cmp	w0, w20
	bne	.L1378
	adrp	x3, .LANCHOR53
	ldrh	w20, [x3, #:lo12:.LANCHOR53]
	cmp	w20, w0
	bne	.L1447
	adrp	x0, .LANCHOR101
	ldrh	w21, [x0, #:lo12:.LANCHOR101]
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
.LBB293:
	.loc 5 502 0
	adrp	x0, .LANCHOR174
	.loc 5 501 0
	str	wzr, [x2, #:lo12:.LANCHOR86]
	.loc 5 502 0
	strh	wzr, [x0, #:lo12:.LANCHOR174]
	.loc 5 503 0
	bl	GetSwlReplaceBlock
.LVL1836:
	and	w20, w0, 65535
.LVL1837:
	.loc 5 504 0
	cmp	w20, w21
	bne	.L1451
	.loc 5 505 0
	adrp	x5, .LANCHOR85
	ldrh	w1, [x23, #:lo12:.LANCHOR48]
	ldrh	w0, [x5, #:lo12:.LANCHOR85]
.LVL1838:
	cmp	w1, w0
	bcs	.L1381
	.loc 5 506 0
	mov	w0, 64
	bl	List_get_gc_head_node
.LVL1839:
	and	w0, w0, 65535
.LVL1840:
	.loc 5 507 0
	cmp	w0, w20
	beq	.L1383
	.loc 5 508 0
	adrp	x1, .LANCHOR43
	ubfiz	x0, x0, 1, 16
.LVL1841:
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ldrh	w0, [x1, x0]
	cmp	w0, 7
	bhi	.L1384
	.loc 5 509 0
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL1842:
	and	w21, w0, 65535
.LVL1843:
	.loc 5 510 0
	mov	w0, 128
	strh	w0, [x5, #:lo12:.LANCHOR85]
	.loc 5 520 0
	cmp	w21, w20
	bne	.L1380
.LVL1844:
.L1383:
	.loc 5 523 0
	bl	FtlGcReFreshBadBlk
.LVL1845:
.L1378:
.LBE293:
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
.LVL1846:
.L1387:
	.loc 5 539 0
	adrp	x2, .LANCHOR84
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR84]
	cmp	w1, w0
	bcs	.L1391
	.loc 5 540 0
	adrp	x0, .LANCHOR53
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bne	.L1392
	adrp	x1, .LANCHOR101
	ldrh	w1, [x1, #:lo12:.LANCHOR101]
	cmp	w1, w0
	bne	.L1392
	.loc 5 542 0
	adrp	x0, .LANCHOR174
	ldrh	w0, [x0, #:lo12:.LANCHOR174]
	cbnz	w0, .L1393
	adrp	x1, .LANCHOR62
	adrp	x4, .LANCHOR60
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	ldr	w4, [x4, #:lo12:.LANCHOR60]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L1394
.L1393:
	.loc 5 543 0
	adrp	x1, .LANCHOR80
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR84]
.L1395:
	.loc 5 546 0
	adrp	x1, .LANCHOR89
	str	wzr, [x1, #:lo12:.LANCHOR89]
.LVL1847:
.L1372:
.LBE292:
.LBE291:
	.loc 5 758 0
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
.LVL1848:
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
.LVL1849:
	cbz	w0, .L1377
	.loc 5 487 0
	mov	w0, 1
	b	.L1372
.LVL1850:
.L1375:
.LBB296:
.LBB295:
	.loc 5 489 0
	adrp	x1, .LANCHOR101
	ldrh	w4, [x1, #:lo12:.LANCHOR101]
	cmp	w4, w3
	bne	.L1376
	.loc 5 490 0
	strh	w2, [x1, #:lo12:.LANCHOR101]
	.loc 5 491 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR102]
	b	.L1376
.LVL1851:
.L1384:
.LBB294:
	.loc 5 512 0
	mov	w0, 64
.L1476:
	.loc 5 516 0
	strh	w0, [x5, #:lo12:.LANCHOR85]
	b	.L1383
.L1381:
	mov	w0, 80
	b	.L1476
.LVL1852:
.L1451:
	.loc 5 504 0
	mov	w21, w20
.LVL1853:
.L1380:
	.loc 5 521 0
	adrp	x1, .LANCHOR40
	ubfiz	x0, x21, 1, 32
	adrp	x3, .LANCHOR84
	mov	w20, w21
	ldr	x2, [x1, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR43
	ldrh	w5, [x3, #:lo12:.LANCHOR84]
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	ldrh	w4, [x2, x0]
	ldrh	w2, [x23, #:lo12:.LANCHOR48]
	ldrh	w3, [x1, x0]
	mov	w1, w21
	adrp	x0, .LC104
	add	x0, x0, :lo12:.LC104
	bl	printf
.LVL1854:
	b	.L1383
.LVL1855:
.L1447:
.LBE294:
	.loc 5 473 0
	mov	w20, w0
	b	.L1378
.L1450:
	mov	w20, w21
	b	.L1378
.LVL1856:
.L1388:
	.loc 5 532 0
	cmp	w0, 12
	bls	.L1389
	.loc 5 533 0
	lsr	w21, w21, 4
.LVL1857:
	b	.L1387
.LVL1858:
.L1389:
	.loc 5 534 0
	cmp	w0, 8
	bls	.L1387
	.loc 5 535 0
	lsr	w21, w21, 2
.LVL1859:
	b	.L1387
.LVL1860:
.L1452:
	.loc 5 529 0
	mov	w21, 1
	b	.L1387
.LVL1861:
.L1394:
	.loc 5 545 0
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR84]
	b	.L1395
.L1392:
	.loc 5 549 0
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR84]
.L1391:
	.loc 5 551 0
	adrp	x0, .LANCHOR103
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	cbz	w0, .L1453
	.loc 5 552 0
	add	w21, w21, 32
.LVL1862:
	and	w21, w21, 65535
.LVL1863:
.L1453:
	.loc 5 551 0
	mov	w20, 65535
.LVL1864:
.L1397:
	.loc 5 597 0
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1406
	.loc 5 598 0
	cmp	w20, w0
	beq	.L1407
	.loc 5 599 0
	strh	w20, [x19, #:lo12:.LANCHOR82]
.LVL1865:
.L1408:
	.loc 5 610 0
	add	x0, x19, :lo12:.LANCHOR82
	.loc 5 611 0
	mov	w1, 65535
	.loc 5 610 0
	strb	wzr, [x0, 8]
	.loc 5 611 0
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	cmp	w0, w1
	beq	.L1406
	.loc 5 612 0
	bl	IsBlkInGcList
.LVL1866:
	cbz	w0, .L1411
	.loc 5 613 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR82]
.L1411:
	.loc 5 615 0
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	mov	w0, 65535
	add	x23, x19, :lo12:.LANCHOR82
	cmp	w1, w0
	beq	.L1406
	.loc 5 616 0
	mov	x0, x23
	bl	make_superblock
.LVL1867:
	.loc 5 619 0
	adrp	x0, .LANCHOR175
	.loc 5 620 0
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	.loc 5 617 0
	strh	wzr, [x23, 2]
	.loc 5 619 0
	strh	wzr, [x0, #:lo12:.LANCHOR175]
	.loc 5 620 0
	adrp	x0, .LANCHOR43
	.loc 5 618 0
	strb	wzr, [x23, 6]
	.loc 5 620 0
	ldr	x0, [x0, #:lo12:.LANCHOR43]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR176
	strh	w1, [x0, #:lo12:.LANCHOR176]
.L1406:
	.loc 5 625 0
	adrp	x0, .LANCHOR51
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR51]
	cmp	w2, w1
	beq	.L1412
	adrp	x0, .LANCHOR52
	str	x0, [x29, 128]
	ldrh	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w2, w1
	beq	.L1412
	.loc 5 635 0
	adrp	x24, .LANCHOR87
.LVL1868:
	.loc 5 657 0
	add	x0, x24, :lo12:.LANCHOR87
	str	x0, [x29, 160]
.L1413:
	.loc 5 631 0
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1414
	.loc 5 632 0
	adrp	x0, .LANCHOR89
	.loc 5 645 0
	adrp	x25, .LANCHOR19
	add	x25, x25, :lo12:.LANCHOR19
	.loc 5 632 0
	str	wzr, [x0, #:lo12:.LANCHOR89]
.L1415:
	.loc 5 635 0
	ldrh	w5, [x24, #:lo12:.LANCHOR87]
	add	x7, x24, :lo12:.LANCHOR87
	mov	w0, w5
	bl	List_get_gc_head_node
.LVL1869:
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR82]
	.loc 5 636 0
	mov	w0, 65535
	cmp	w6, w0
	bne	.L1416
	.loc 5 637 0
	strh	wzr, [x7]
	.loc 5 638 0
	mov	w0, 8
	b	.L1372
.LVL1870:
.L1386:
	.loc 5 557 0
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1456
	adrp	x0, .LANCHOR101
	ldrh	w0, [x0, #:lo12:.LANCHOR101]
	cmp	w0, w1
	bne	.L1456
	cmp	w20, w0
	bne	.L1456
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	cmp	w0, w20
	beq	.L1398
.LVL1871:
.L1456:
	.loc 5 556 0
	mov	w21, 1
	b	.L1397
.LVL1872:
.L1398:
	.loc 5 558 0
	adrp	x0, .LANCHOR89
	.loc 5 560 0
	adrp	x21, .LANCHOR48
	adrp	x23, .LANCHOR174
	.loc 5 558 0
	str	wzr, [x0, #:lo12:.LANCHOR89]
	.loc 5 560 0
	adrp	x0, .LANCHOR84
	ldrh	w6, [x21, #:lo12:.LANCHOR48]
	mov	x2, x0
	ldrh	w1, [x0, #:lo12:.LANCHOR84]
	cmp	w1, w6
	.loc 5 561 0
	ldrh	w1, [x23, #:lo12:.LANCHOR174]
	.loc 5 560 0
	bcs	.L1399
	.loc 5 561 0
	cbnz	w1, .L1400
	adrp	x1, .LANCHOR62
	adrp	x3, .LANCHOR60
	ldr	w1, [x1, #:lo12:.LANCHOR62]
	ldr	w3, [x3, #:lo12:.LANCHOR60]
	add	w1, w1, w1, lsl 1
	cmp	w3, w1, lsr 2
	bcs	.L1401
.L1400:
	.loc 5 562 0
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR84]
.LVL1873:
.L1477:
	.loc 5 578 0
	bl	FtlReadRefresh
.LVL1874:
	.loc 5 579 0
	ldrh	w0, [x23, #:lo12:.LANCHOR174]
	b	.L1372
.LVL1875:
.L1401:
	.loc 5 564 0
	mov	w1, 18
	strh	w1, [x0, #:lo12:.LANCHOR84]
	b	.L1477
.L1399:
	.loc 5 572 0
	cbnz	w1, .L1456
	.loc 5 573 0
	adrp	x1, .LANCHOR80
	ldrh	w5, [x1, #:lo12:.LANCHOR80]
	add	w1, w5, w5, lsl 1
	asr	w1, w1, 2
	strh	w1, [x0, #:lo12:.LANCHOR84]
	.loc 5 574 0
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL1876:
	.loc 5 575 0
	ubfiz	x0, x0, 1, 16
.LVL1877:
	adrp	x1, .LANCHOR43
	adrp	x2, .LANCHOR3
	ldr	x1, [x1, #:lo12:.LANCHOR43]
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
.LVL1878:
	.loc 5 586 0
	ldrh	w0, [x21, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	b	.L1372
.LVL1879:
.L1407:
	.loc 5 600 0
	adrp	x0, .LANCHOR101
	ldrh	w1, [x0, #:lo12:.LANCHOR101]
	cmp	w1, w20
	beq	.L1408
	.loc 5 604 0
	adrp	x2, .LANCHOR43
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR43]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L1409
	.loc 5 605 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR101]
.L1409:
	.loc 5 606 0
	ldrh	w1, [x0, #:lo12:.LANCHOR101]
	strh	w1, [x19, #:lo12:.LANCHOR82]
	.loc 5 607 0
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR101]
	b	.L1408
.LVL1880:
.L1412:
	.loc 5 626 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR82]
.LVL1881:
.L1478:
	.loc 5 734 0
	adrp	x0, .LANCHOR174
	ldrh	w0, [x0, #:lo12:.LANCHOR174]
	b	.L1372
.LVL1882:
.L1416:
	.loc 5 640 0
	mov	w0, w6
	bl	IsBlkInGcList
.LVL1883:
	add	w5, w5, 1
	cbz	w0, .L1417
	.loc 5 641 0
	strh	w5, [x24, #:lo12:.LANCHOR87]
	b	.L1415
.L1417:
	.loc 5 645 0
	adrp	x23, .LANCHOR43
	adrp	x4, .LANCHOR3
	ldrh	w0, [x25]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR43]
	.loc 5 644 0
	and	w5, w5, 65535
	.loc 5 645 0
	ldrh	w4, [x4, #:lo12:.LANCHOR3]
	.loc 5 644 0
	strh	w5, [x24, #:lo12:.LANCHOR87]
	.loc 5 645 0
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L1419
	.loc 5 646 0
	cmp	w5, 48
	bls	.L1420
	cmp	w3, 8
	bls	.L1420
	adrp	x3, .LANCHOR97
	ldrh	w3, [x3, #:lo12:.LANCHOR97]
	cmp	w3, 35
	bhi	.L1420
.L1419:
	.loc 5 647 0
	ldr	x3, [x29, 160]
	strh	wzr, [x3]
.L1420:
	.loc 5 649 0
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L1421
	mov	w0, 65535
	cmp	w20, w0
	bne	.L1421
	.loc 5 650 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR82]
	.loc 5 651 0
	adrp	x0, .LANCHOR87
	strh	wzr, [x0, #:lo12:.LANCHOR87]
	b	.L1478
.L1421:
	.loc 5 655 0
	cbnz	w1, .L1422
	.loc 5 656 0
	mov	w0, -1
	bl	decrement_vpc_count
.LVL1884:
	.loc 5 657 0
	ldr	x0, [x29, 160]
	ldr	x1, [x29, 160]
	ldrh	w0, [x0]
	add	w0, w0, 1
	strh	w0, [x1]
	b	.L1415
.L1422:
	.loc 5 660 0
	add	x0, x19, :lo12:.LANCHOR82
	strb	wzr, [x0, 8]
	.loc 5 662 0
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w6
	bne	.L1423
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 662
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1885:
.L1423:
	.loc 5 663 0
	ldr	x0, [x29, 128]
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1424
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 663
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1886:
.L1424:
	.loc 5 664 0
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1425
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	mov	w2, 664
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1887:
.L1425:
	.loc 5 665 0
	add	x25, x19, :lo12:.LANCHOR82
	mov	x0, x25
	bl	make_superblock
.LVL1888:
	.loc 5 666 0
	adrp	x0, .LANCHOR175
	.loc 5 667 0
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	.loc 5 666 0
	strh	wzr, [x0, #:lo12:.LANCHOR175]
	.loc 5 667 0
	ldr	x0, [x23, #:lo12:.LANCHOR43]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR176
	.loc 5 668 0
	strh	wzr, [x25, 2]
	.loc 5 667 0
	strh	w1, [x0, #:lo12:.LANCHOR176]
	.loc 5 669 0
	strb	wzr, [x25, 6]
.L1414:
	.loc 5 675 0
	bl	FtlReadRefresh
.LVL1889:
	.loc 5 679 0
	adrp	x1, .LANCHOR19
	.loc 5 678 0
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR117]
	.loc 5 679 0
	ldrh	w0, [x1, #:lo12:.LANCHOR19]
	str	w0, [x29, 172]
.LVL1890:
	.loc 5 680 0
	add	x0, x19, :lo12:.LANCHOR82
	str	x1, [x29, 120]
	ldr	w3, [x29, 172]
	ldrh	w0, [x0, 2]
	add	w2, w0, w21
	cmp	w2, w3
	ble	.L1426
	.loc 5 681 0
	sub	w21, w3, w0
.LVL1891:
	and	w21, w21, 65535
.LVL1892:
.L1426:
	.loc 5 704 0
	adrp	x0, .LANCHOR175
	.loc 5 693 0
	mov	w27, 0
	.loc 5 704 0
	add	x0, x0, :lo12:.LANCHOR175
	str	x0, [x29, 152]
.LVL1893:
.L1427:
	.loc 5 683 0
	cmp	w21, w27, uxth
	bls	.L1435
	.loc 5 688 0
	add	x1, x19, :lo12:.LANCHOR82
	.loc 5 685 0
	adrp	x0, .LANCHOR3
	.loc 5 688 0
	adrp	x25, .LANCHOR95
	add	x1, x1, 16
	.loc 5 685 0
	ldrh	w7, [x0, #:lo12:.LANCHOR3]
	.loc 5 688 0
	mov	w23, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x25, #:lo12:.LANCHOR95]
	.loc 5 687 0
	mov	w6, 65535
	.loc 5 688 0
	add	w4, w4, w27
	b	.L1436
.LVL1894:
.L1429:
	.loc 5 686 0
	ldrh	w3, [x1]
.LVL1895:
	.loc 5 687 0
	cmp	w3, w6
	beq	.L1428
	.loc 5 688 0
	ubfiz	x5, x23, 5, 16
	.loc 5 689 0
	add	w23, w23, 1
.LVL1896:
	.loc 5 688 0
	add	x5, x0, x5
	.loc 5 689 0
	and	w23, w23, 65535
.LVL1897:
	.loc 5 688 0
	orr	w3, w4, w3, lsl 10
.LVL1898:
	str	w3, [x5, 4]
.L1428:
	.loc 5 685 0
	add	w2, w2, 1
.LVL1899:
	add	x1, x1, 2
.LVL1900:
	and	w2, w2, 65535
.LVL1901:
.L1436:
	cmp	w2, w7
	bne	.L1429
	.loc 5 693 0
	add	x1, x19, :lo12:.LANCHOR82
	.loc 5 705 0
	adrp	x26, .LANCHOR91
	add	x26, x26, :lo12:.LANCHOR91
	.loc 5 693 0
	ldrb	w2, [x1, 8]
.LVL1902:
	mov	w1, w23
	bl	FlashReadPages
.LVL1903:
	ubfiz	x0, x23, 5, 16
	mov	x23, 0
.LVL1904:
	str	x0, [x29, 144]
.LVL1905:
.L1430:
	.loc 5 695 0
	ldr	x0, [x29, 144]
	cmp	x0, x23
	bne	.L1434
.LVL1906:
	add	w27, w27, 1
.LVL1907:
	b	.L1427
.LVL1908:
.L1434:
	.loc 5 696 0
	ldr	x0, [x25, #:lo12:.LANCHOR95]
	add	x1, x0, x23
.LVL1909:
	.loc 5 697 0
	ldr	w0, [x0, x23]
	cmn	w0, #1
	beq	.L1431
	.loc 5 696 0
	ldr	x28, [x1, 16]
	.loc 5 697 0
	mov	w0, 61589
	ldrh	w1, [x28]
.LVL1910:
	cmp	w1, w0
	bne	.L1431
	.loc 5 699 0
	ldr	w4, [x28, 8]
.LVL1911:
	.loc 5 700 0
	cmn	w4, #1
	bne	.L1432
	str	w4, [x29, 112]
	mov	w2, 700
	adrp	x1, .LANCHOR177
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL1912:
	ldr	w4, [x29, 112]
.LVL1913:
.L1432:
	.loc 5 701 0
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
.LVL1914:
	.loc 5 702 0
	ldr	x0, [x25, #:lo12:.LANCHOR95]
	ldr	w1, [x29, 188]
	add	x0, x0, x23
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bne	.L1431
	.loc 5 704 0
	ldr	x1, [x29, 152]
	.loc 5 705 0
	adrp	x4, .LANCHOR121
	.loc 5 704 0
	ldr	x2, [x29, 152]
	.loc 5 705 0
	ldr	w0, [x0, 24]
	.loc 5 704 0
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	.loc 5 705 0
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	ldr	w1, [x26]
	add	x1, x2, x1, lsl 5
	stp	x4, x1, [x29, 104]
	str	w0, [x1, 24]
	.loc 5 706 0
	bl	Ftl_get_new_temp_ppa
.LVL1915:
	ldp	x4, x1, [x29, 104]
	.loc 5 707 0
	ldr	x2, [x4, #:lo12:.LANCHOR121]
	.loc 5 706 0
	str	w0, [x1, 4]
	.loc 5 707 0
	ldr	w1, [x26]
	ubfiz	x0, x1, 5, 32
	.loc 5 715 0
	add	w1, w1, 1
	.loc 5 707 0
	add	x2, x2, x0
	ldr	x0, [x25, #:lo12:.LANCHOR95]
	add	x0, x0, x23
	ldr	x4, [x0, 8]
	str	x4, [x2, 8]
	.loc 5 708 0
	ldr	x4, [x0, 16]
	str	x4, [x2, 16]
	.loc 5 709 0
	ldr	w2, [x29, 188]
	str	w2, [x28, 12]
	.loc 5 710 0
	adrp	x2, .LANCHOR53
	add	x11, x2, :lo12:.LANCHOR53
	ldrh	w2, [x2, #:lo12:.LANCHOR53]
	strh	w2, [x28, 2]
	.loc 5 713 0
	adrp	x2, .LANCHOR72
	.loc 5 715 0
	str	w1, [x26]
	.loc 5 716 0
	mov	w1, 1
	.loc 5 713 0
	ldr	w2, [x2, #:lo12:.LANCHOR72]
	str	w2, [x28, 4]
	.loc 5 716 0
	bl	FtlGcBufAlloc
.LVL1916:
	.loc 5 717 0
	ldrb	w1, [x11, 7]
	ldr	w0, [x26]
	cmp	w1, w0
	beq	.L1433
	ldrh	w0, [x11, 4]
	cbnz	w0, .L1431
.L1433:
	.loc 5 718 0
	bl	Ftl_gc_temp_data_write_back
.LVL1917:
	cbz	w0, .L1431
.LVL1918:
.L1479:
	.loc 5 733 0
	str	wzr, [x22, #:lo12:.LANCHOR117]
	b	.L1478
.LVL1919:
.L1431:
	add	x23, x23, 32
	b	.L1430
.L1435:
	.loc 5 727 0
	add	x1, x19, :lo12:.LANCHOR82
	ldrh	w0, [x1, 2]
	add	w21, w21, w0
.LVL1920:
	.loc 5 729 0
	ldr	w0, [x29, 172]
	.loc 5 727 0
	and	w21, w21, 65535
	strh	w21, [x1, 2]
	.loc 5 729 0
	cmp	w0, w21
	bls	.L1437
	adrp	x0, .LANCHOR175
	ldrh	w1, [x0, #:lo12:.LANCHOR175]
	adrp	x0, .LANCHOR176
	ldrh	w0, [x0, #:lo12:.LANCHOR176]
	cmp	w1, w0
	bne	.L1438
.L1437:
	.loc 5 731 0
	adrp	x0, .LANCHOR91
	ldr	w0, [x0, #:lo12:.LANCHOR91]
	cbz	w0, .L1439
	.loc 5 732 0
	bl	Ftl_gc_temp_data_write_back
.LVL1921:
	cbnz	w0, .L1479
.L1439:
	.loc 5 737 0
	adrp	x0, .LANCHOR175
	ldrh	w0, [x0, #:lo12:.LANCHOR175]
	cbnz	w0, .L1440
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	adrp	x1, .LANCHOR43
	ldr	x1, [x1, #:lo12:.LANCHOR43]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L1440
	.loc 5 739 0
	strh	wzr, [x1, x0]
	.loc 5 740 0
	ldrh	w0, [x19, #:lo12:.LANCHOR82]
	bl	update_vpc_list
.LVL1922:
	.loc 5 741 0
	bl	FtlCacheWriteBack
.LVL1923:
	.loc 5 742 0
	bl	l2p_flush
.LVL1924:
	.loc 5 743 0
	bl	FtlVpcTblFlush
.LVL1925:
.L1440:
	.loc 5 745 0
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR82]
.L1438:
	.loc 5 747 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 2
	bhi	.L1441
	.loc 5 749 0
	ldr	x0, [x29, 120]
	ldrh	w21, [x0, #:lo12:.LANCHOR19]
.LVL1926:
	b	.L1413
.LVL1927:
.L1441:
	.loc 5 754 0
	adrp	x1, .LANCHOR174
	.loc 5 752 0
	str	wzr, [x22, #:lo12:.LANCHOR117]
	.loc 5 754 0
	ldrh	w1, [x1, #:lo12:.LANCHOR174]
	.loc 5 755 0
	cmp	w1, 0
	csinc	w0, w1, w0, ne
	b	.L1372
.LVL1928:
.L1444:
.LBE295:
.LBE296:
	.loc 5 479 0
	mov	w0, 0
.LVL1929:
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
	.loc 5 761 0
	.cfi_startproc
	.loc 5 762 0
	mov	w1, 1
	mov	w0, w1
	b	rk_ftl_garbage_collect
.LVL1930:
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
.LVL1931:
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
.LVL1932:
	mov	w1, w27
.LVL1933:
	add	w0, w19, 256
.LVL1934:
	bl	FtlVendorPartRead
.LVL1935:
	mov	w21, w0
.LVL1936:
.L1481:
	.loc 3 901 0
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
.LVL1937:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL1938:
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.LVL1939:
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
.LVL1940:
.L1482:
	.cfi_restore_state
	.loc 3 830 0
	add	w0, w1, w2
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR34
	add	w1, w1, w2
.LVL1941:
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w1, w0
	bhi	.L1502
	.loc 3 830 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR88
	ldr	w21, [x0, #:lo12:.LANCHOR88]
	cmn	w21, #1
	beq	.L1481
	.loc 3 835 0 is_stmt 1
	adrp	x22, .LANCHOR12
	.loc 3 833 0
	bl	FtlCacheWriteBack
.LVL1942:
	.loc 3 836 0
	add	w1, w19, w27
	.loc 3 840 0
	mov	w25, 0
	.loc 3 835 0
	ldrh	w0, [x22, #:lo12:.LANCHOR12]
	.loc 3 836 0
	sub	w24, w1, #1
	.loc 3 841 0
	adrp	x1, .LANCHOR63
	.loc 3 815 0
	mov	w21, 0
	.loc 3 851 0
	adrp	x28, .LANCHOR120
	.loc 3 828 0
	stp	wzr, wzr, [x29, 144]
	.loc 3 835 0
	udiv	w26, w19, w0
.LVL1943:
	.loc 3 836 0
	udiv	w24, w24, w0
.LVL1944:
	.loc 3 835 0
	mov	w20, w26
	.loc 3 837 0
	sub	w0, w24, w26
	add	w0, w0, 1
	stp	wzr, w0, [x29, 152]
.LVL1945:
	.loc 3 841 0
	ldr	w0, [x1, #:lo12:.LANCHOR63]
.LVL1946:
	ldr	w2, [x29, 156]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR63]
	.loc 3 886 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	str	x0, [x29, 128]
.LVL1947:
.L1484:
	.loc 3 842 0
	ldr	w0, [x29, 156]
	cbnz	w0, .L1500
	.loc 3 898 0
	adrp	x0, .LANCHOR103
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
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
.LVL1948:
	b	.L1481
.L1500:
	.loc 3 843 0
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
.LVL1949:
	.loc 3 844 0
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1485
	.loc 3 845 0 discriminator 1
	add	x5, x22, :lo12:.LANCHOR12
	mov	w4, 0
.L1486:
.LVL1950:
	ldrh	w0, [x5]
	cmp	w4, w0
	bcc	.L1488
.LVL1951:
.L1489:
	.loc 3 874 0
	ldr	w0, [x29, 156]
	.loc 3 872 0
	add	w20, w20, 1
.LVL1952:
	.loc 3 874 0
	subs	w0, w0, #1
	str	w0, [x29, 156]
.LVL1953:
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
.LVL1954:
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
.LVL1955:
	str	x0, [x29, 104]
.LVL1956:
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
	adrp	x0, .LANCHOR116
	ldr	x0, [x0, #:lo12:.LANCHOR116]
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
.LVL1957:
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
.LVL1958:
	.loc 3 886 0
	ldr	x2, [x29, 128]
	ldr	w1, [x1, 72]
	add	w1, w1, 1
	str	w1, [x2, 72]
.LVL1959:
.L1498:
	.loc 3 877 0 discriminator 2
	ldr	x0, [x29, 104]
	add	x25, x25, 32
.LVL1960:
	cmp	x0, x25
	bne	.L1499
	.loc 3 894 0
	mov	w25, 0
	b	.L1484
.LVL1961:
.L1488:
	.loc 3 846 0
	madd	w0, w20, w0, w4
.LVL1962:
	.loc 3 847 0
	cmp	w19, w0
	bhi	.L1487
	.loc 3 847 0 is_stmt 0 discriminator 1
	ldr	w1, [x29, 140]
	cmp	w1, w0
	bls	.L1487
	.loc 3 848 0 is_stmt 1
	sub	w0, w0, w19
.LVL1963:
	str	x5, [x29, 112]
	lsl	w0, w0, 9
	str	w4, [x29, 120]
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
.LVL1964:
	ldr	w4, [x29, 120]
	ldr	x5, [x29, 112]
.LVL1965:
.L1487:
	.loc 3 845 0 discriminator 2
	add	w4, w4, 1
.LVL1966:
	b	.L1486
.LVL1967:
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
	adrp	x1, .LANCHOR116
	ldr	x1, [x1, #:lo12:.LANCHOR116]
	str	x1, [x0, 8]
	.loc 3 854 0
	ldrh	w1, [x22, #:lo12:.LANCHOR12]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 152]
.LVL1968:
	.loc 3 855 0
	sub	w2, w1, w2
.LVL1969:
	cmp	w27, w2
	csel	w2, w27, w2, ls
.LVL1970:
	str	w2, [x29, 148]
.LVL1971:
	.loc 3 857 0
	cmp	w1, w2
	bne	.L1491
	.loc 3 858 0
	str	x23, [x0, 8]
.LVL1972:
.L1491:
	.loc 3 867 0
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR115
	.loc 3 868 0
	str	w20, [x0, 24]
	.loc 3 867 0
	ldrh	w1, [x1, #:lo12:.LANCHOR24]
	ldr	x2, [x2, #:lo12:.LANCHOR115]
	mul	w1, w1, w25
	.loc 3 869 0
	add	w25, w25, 1
.LVL1973:
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
	adrp	x1, .LANCHOR114
	.loc 3 861 0
	ldr	w3, [x29, 140]
	.loc 3 860 0
	ldr	x1, [x1, #:lo12:.LANCHOR114]
	str	x1, [x0, 8]
	.loc 3 861 0
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 144]
.LVL1974:
	.loc 3 862 0
	cmp	w2, w3
	bne	.L1491
.LVL1975:
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
.LVL1976:
.L1495:
	.loc 3 881 0
	cmp	w24, w1
	bne	.L1496
	.loc 3 882 0
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR114
	ldr	x0, [x0, #:lo12:.LANCHOR114]
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
.LBB297:
	.loc 3 890 0
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
.LVL1977:
	.loc 3 891 0
	bl	FtlGcRefreshBlock
.LVL1978:
	b	.L1498
.LVL1979:
.L1502:
.LBE297:
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
	.loc 3 1204 0
	.cfi_startproc
.LVL1980:
	.loc 3 1205 0
	mov	x3, x2
	mov	w2, w1
.LVL1981:
	mov	w1, w0
.LVL1982:
	mov	w0, 0
.LVL1983:
	b	FtlRead
.LVL1984:
	.cfi_endproc
.LFE219:
	.size	sftl_read, .-sftl_read
	.section	.text.FtlWrite,"ax",@progbits
	.align	2
	.global	FtlWrite
	.type	FtlWrite, %function
FtlWrite:
.LFB217:
	.loc 3 962 0
	.cfi_startproc
.LVL1985:
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	and	w0, w0, 255
	.loc 3 970 0
	cmp	w0, 16
	.loc 3 962 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	mov	w22, w1
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	mov	w24, w2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	mov	x25, x3
	stp	x19, x20, [sp, 16]
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.loc 3 970 0
	bne	.L1516
	.loc 3 971 0
	mov	x2, x3
.LVL1986:
	mov	w1, w24
.LVL1987:
	add	w0, w22, 256
.LVL1988:
	bl	FtlVendorPartWrite
.LVL1989:
.L1515:
	.loc 3 1153 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.LVL1990:
	ldp	x25, x26, [sp, 64]
.LVL1991:
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
	ret
.LVL1992:
.L1516:
	.cfi_restore_state
	.loc 3 974 0
	adrp	x0, .LANCHOR34
	add	w2, w1, w2
.LVL1993:
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w2, w0
	bhi	.L1556
	.loc 3 974 0 is_stmt 0 discriminator 1
	adrp	x0, .LANCHOR88
	ldr	w0, [x0, #:lo12:.LANCHOR88]
	cmn	w0, #1
	beq	.L1515
	.loc 3 977 0 is_stmt 1
	adrp	x0, .LANCHOR178
	.loc 3 978 0
	adrp	x3, .LANCHOR12
.LVL1994:
	.loc 3 977 0
	mov	w1, 2048
.LVL1995:
	.loc 3 979 0
	sub	w2, w2, #1
	.loc 3 977 0
	str	w1, [x0, #:lo12:.LANCHOR178]
	.loc 3 978 0
	ldrh	w1, [x3, #:lo12:.LANCHOR12]
	str	x3, [x29, 176]
	.loc 3 979 0
	udiv	w0, w2, w1
	.loc 3 982 0
	adrp	x2, .LANCHOR65
	.loc 3 978 0
	udiv	w21, w22, w1
.LVL1996:
	.loc 3 979 0
	str	w0, [x29, 168]
.LVL1997:
	.loc 3 980 0
	sub	w23, w0, w21
	.loc 3 982 0
	ldr	w0, [x2, #:lo12:.LANCHOR65]
.LVL1998:
	.loc 3 980 0
	add	w26, w23, 1
.LVL1999:
	.loc 3 982 0
	add	w0, w0, w26
	str	w0, [x2, #:lo12:.LANCHOR65]
	.loc 3 983 0
	adrp	x0, .LANCHOR150
	str	x0, [x29, 120]
	ldr	x2, [x0, #:lo12:.LANCHOR150]
	cbz	x2, .L1518
	.loc 3 984 0
	ldr	w0, [x2, 24]
	cmp	w21, w0
	beq	.L1519
	.loc 3 985 0
	bl	FtlCacheWriteBack
.LVL2000:
.L1518:
	.loc 3 1008 0
	adrp	x0, .LANCHOR179
	str	x0, [x29, 152]
	ldr	w1, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
	cbz	w1, .L1521
	.loc 3 1008 0 is_stmt 0 discriminator 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1521
	.loc 3 1009 0 is_stmt 1
	adrp	x19, .LANCHOR52
	add	x19, x19, :lo12:.LANCHOR52
.L1521:
	mov	w20, w21
	.loc 3 1023 0
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	str	x0, [x29, 96]
.LVL2001:
.L1522:
	.loc 3 1011 0
	cbnz	w26, .L1552
	.loc 3 1137 0
	ldr	w0, [x29, 168]
	sub	w1, w0, w21
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL2002:
	.loc 3 1139 0
	adrp	x0, .LANCHOR48
	mov	x20, x0
.LVL2003:
	ldrh	w1, [x0, #:lo12:.LANCHOR48]
	cmp	w1, 15
	bhi	.L1553
	.loc 3 1141 0
	adrp	x22, .LANCHOR101
.LVL2004:
	.loc 3 1143 0
	adrp	x21, .LANCHOR85
.LVL2005:
	.loc 3 1144 0
	adrp	x19, .LANCHOR84
.LVL2006:
	.loc 3 1141 0
	add	x22, x22, :lo12:.LANCHOR101
	.loc 3 1143 0
	add	x21, x21, :lo12:.LANCHOR85
	.loc 3 1144 0
	add	x19, x19, :lo12:.LANCHOR84
.L1571:
	.loc 3 1141 0
	adrp	x0, .LANCHOR82
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR82]
	cmp	w0, w1
	bne	.L1554
	.loc 3 1141 0 is_stmt 0 discriminator 1
	ldrh	w1, [x22]
	cmp	w1, w0
	bne	.L1554
	.loc 3 1142 0 is_stmt 1
	mov	w0, 0
	bl	List_get_gc_head_node
.LVL2007:
	bl	FtlGcRefreshBlock
.LVL2008:
.L1554:
	.loc 3 1143 0
	mov	w0, 128
	.loc 3 1145 0
	mov	w1, 1
	.loc 3 1143 0
	strh	w0, [x21]
	.loc 3 1144 0
	strh	w0, [x19]
	.loc 3 1145 0
	mov	w0, w1
	bl	rk_ftl_garbage_collect
.LVL2009:
	.loc 3 1146 0
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL2010:
	.loc 3 1147 0
	ldrh	w0, [x20, #:lo12:.LANCHOR48]
	cmp	w0, 8
	bls	.L1571
	b	.L1553
.LVL2011:
.L1519:
	.loc 3 987 0
	adrp	x3, .LANCHOR66
	ldr	w0, [x3, #:lo12:.LANCHOR66]
	add	w0, w0, 1
	str	w0, [x3, #:lo12:.LANCHOR66]
	.loc 3 988 0
	msub	w0, w21, w1, w22
.LVL2012:
	.loc 3 992 0
	ldr	x3, [x2, 8]
	.loc 3 989 0
	sub	w1, w1, w0
.LVL2013:
	cmp	w24, w1
	.loc 3 992 0
	lsl	w0, w0, 9
.LVL2014:
	csel	w19, w24, w1, ls
.LVL2015:
	add	x0, x3, x0
	lsl	w20, w19, 9
	mov	x1, x25
	mov	w2, w20
	bl	ftl_memcpy
.LVL2016:
	.loc 3 994 0
	cbnz	w23, .L1520
.LVL2017:
.L1553:
	.loc 3 995 0
	mov	w0, 0
	b	.L1515
.LVL2018:
.L1520:
	.loc 3 996 0
	sub	w24, w24, w19
.LVL2019:
	.loc 3 997 0
	add	w22, w22, w19
.LVL2020:
	.loc 3 998 0
	add	x25, x25, x20
.LVL2021:
	.loc 3 999 0
	add	w21, w21, 1
.LVL2022:
	.loc 3 1000 0
	bl	FtlCacheWriteBack
.LVL2023:
	mov	w26, w23
	b	.L1518
.LVL2024:
.L1552:
	.loc 3 1012 0
	adrp	x0, .LANCHOR3
	ldrb	w2, [x19, 6]
	str	x0, [x29, 128]
	ldrh	w1, [x0, #:lo12:.LANCHOR3]
	cmp	w2, w1
	bcc	.L1523
	.loc 3 1012 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1012
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2025:
.L1523:
	.loc 3 1013 0 is_stmt 1
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1524
	.loc 3 1014 0
	bl	FtlCacheWriteBack
.LVL2026:
	.loc 3 1016 0
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	cmp	x19, x0
	bne	.L1525
	.loc 3 1017 0
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1526
	.loc 3 1018 0
	bl	allocate_new_data_superblock
.LVL2027:
	.loc 3 1019 0
	ldr	x0, [x29, 152]
	str	wzr, [x0, #:lo12:.LANCHOR179]
.L1526:
	.loc 3 1021 0
	adrp	x0, .LANCHOR51
	add	x19, x0, :lo12:.LANCHOR51
.LVL2028:
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2029:
	.loc 3 1022 0
	ldr	x0, [x29, 152]
	ldr	w0, [x0, #:lo12:.LANCHOR179]
	.loc 3 1023 0
	cmp	w0, 0
	ldr	x0, [x29, 96]
	csel	x19, x0, x19, ne
.L1527:
.LVL2030:
	.loc 3 1033 0
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1524
	.loc 3 1034 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2031:
.L1524:
	.loc 3 1043 0
	ldrh	w0, [x19, 4]
	.loc 3 1041 0
	ldrb	w1, [x19, 7]
	cmp	w0, w26
	csel	w0, w0, w26, ls
	lsl	w1, w1, 2
	cmp	w0, w1
	csel	w0, w0, w1, ls
	str	w0, [x29, 160]
.LVL2032:
	.loc 3 1045 0
	ldr	x0, [x29, 128]
.LVL2033:
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1528
	.loc 3 1045 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1045
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2034:
.L1528:
	.loc 3 1055 0 is_stmt 1 discriminator 1
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	.loc 3 1068 0 discriminator 1
	str	xzr, [x29, 184]
	.loc 3 1055 0 discriminator 1
	str	x0, [x29, 112]
	.loc 3 1101 0 discriminator 1
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	str	x0, [x29, 104]
.L1529:
	.loc 3 1046 0 discriminator 1
	ldr	w1, [x29, 160]
	adrp	x28, .LANCHOR122
	ldr	w27, [x29, 184]
.LVL2035:
	cmp	w27, w1
	bcc	.L1550
	mov	x27, x1
.L1530:
.LVL2036:
	.loc 3 1133 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	mov	x3, x19
	mov	w2, 0
	mov	w1, w27
	bl	FtlProgPages
.LVL2037:
	.loc 3 1134 0
	cmp	w26, w27
	bcs	.L1551
	.loc 3 1134 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1134
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2038:
.L1551:
	.loc 3 1135 0 is_stmt 1
	sub	w26, w26, w27
.LVL2039:
	b	.L1522
.LVL2040:
.L1525:
	.loc 3 1027 0
	ldr	x1, [x29, 152]
	str	wzr, [x1, #:lo12:.LANCHOR179]
	.loc 3 1028 0
	ldrh	w1, [x0, 4]
	cbnz	w1, .L1561
	.loc 3 1029 0
	mov	x0, x19
	bl	allocate_new_data_superblock
.LVL2041:
	b	.L1527
.L1561:
	mov	x19, x0
.LVL2042:
	b	.L1524
.LVL2043:
.L1550:
	.loc 3 1047 0
	ldrh	w0, [x19, 4]
	cbz	w0, .L1530
	.loc 3 1051 0
	add	x1, x29, 204
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
.LVL2044:
	.loc 3 1052 0
	mov	x0, x19
	bl	get_new_active_ppa
.LVL2045:
	ldr	x1, [x29, 184]
	lsl	x23, x1, 5
	.loc 3 1054 0
	ldr	x1, [x28, #:lo12:.LANCHOR122]
	add	x1, x1, x23
	str	w0, [x1, 4]
	.loc 3 1055 0
	ldr	x0, [x29, 112]
.LVL2046:
	.loc 3 1056 0
	str	w20, [x1, 24]
	.loc 3 1055 0
	ldrh	w2, [x0]
	mul	w27, w27, w2
	and	x0, x27, 4294967292
	str	x0, [x29, 144]
	adrp	x0, .LANCHOR115
	ldr	x3, [x29, 144]
	ldr	x0, [x0, #:lo12:.LANCHOR115]
	str	x0, [x29, 136]
	add	x27, x0, x3
.LVL2047:
	str	x27, [x1, 16]
	.loc 3 1059 0
	mov	x0, x27
	mov	w1, 0
.LVL2048:
	bl	ftl_memset
.LVL2049:
	.loc 3 1061 0
	ldr	w0, [x29, 168]
	cmp	w20, w21
	ccmp	w20, w0, 4, ne
	bne	.L1531
	.loc 3 1062 0
	cmp	w20, w21
	bne	.L1532
	.loc 3 1063 0
	ldr	x0, [x29, 176]
	ldrh	w2, [x0, #:lo12:.LANCHOR12]
	udiv	w0, w22, w2
	msub	w0, w0, w2, w22
	str	w0, [x29, 164]
.LVL2050:
	.loc 3 1064 0
	sub	w2, w2, w0
	cmp	w2, w24
	csel	w0, w2, w24, ls
.LVL2051:
	str	w0, [x29, 172]
.LVL2052:
.L1533:
	.loc 3 1072 0
	ldr	x0, [x29, 176]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0, #:lo12:.LANCHOR12]
	cmp	w1, w0
	.loc 3 1074 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	.loc 3 1072 0
	bne	.L1534
	.loc 3 1074 0
	add	x23, x0, x23
	.loc 3 1073 0
	cmp	w20, w21
	bne	.L1535
	.loc 3 1074 0
	str	x25, [x23, 8]
.LVL2053:
.L1536:
	.loc 3 1119 0
	ldr	x0, [x29, 128]
	ldrb	w1, [x19, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR3]
	cmp	w1, w0
	bcc	.L1547
	.loc 3 1119 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	mov	w2, 1119
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2054:
.L1547:
	.loc 3 1120 0 is_stmt 1
	ldp	x1, x2, [x29, 136]
	mov	w0, -3947
	strh	w0, [x1, x2]
	.loc 3 1121 0
	adrp	x1, .LANCHOR72
	ldr	w0, [x1, #:lo12:.LANCHOR72]
	.loc 3 1122 0
	stp	w0, w20, [x27, 4]
	.loc 3 1125 0
	add	w20, w20, 1
.LVL2055:
	.loc 3 1121 0
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR72]
	.loc 3 1123 0
	ldr	w0, [x29, 204]
	str	w0, [x27, 12]
	.loc 3 1124 0
	ldrh	w0, [x19]
	strh	w0, [x27, 2]
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
	b	.L1529
.LVL2056:
.L1532:
	.loc 3 1069 0
	ldr	x0, [x29, 176]
	add	w2, w22, w24
	.loc 3 1068 0
	str	wzr, [x29, 164]
	.loc 3 1069 0
	ldrh	w0, [x0, #:lo12:.LANCHOR12]
	msub	w2, w20, w0, w2
	and	w0, w2, 65535
	str	w0, [x29, 172]
.LVL2057:
	b	.L1533
.LVL2058:
.L1535:
	.loc 3 1076 0
	ldr	w0, [x29, 172]
.LVL2059:
.L1574:
	.loc 3 1117 0
	mul	w0, w0, w20
	sub	w0, w0, w22
	lsl	w0, w0, 9
	add	x0, x25, x0
	str	x0, [x23, 8]
	b	.L1536
.LVL2060:
.L1534:
	.loc 3 1080 0
	add	x0, x0, x23
	.loc 3 1079 0
	cmp	w20, w21
	bne	.L1537
	.loc 3 1080 0
	adrp	x1, .LANCHOR116
	ldr	x1, [x1, #:lo12:.LANCHOR116]
.L1573:
	.loc 3 1082 0
	str	x1, [x0, 8]
	.loc 3 1084 0
	ldr	w0, [x29, 204]
	cmn	w0, #1
	beq	.L1539
.LBB298:
	.loc 3 1086 0
	str	w0, [x29, 212]
	.loc 3 1090 0
	mov	w2, 0
	.loc 3 1088 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	.loc 3 1087 0
	str	w20, [x29, 232]
	.loc 3 1088 0
	add	x0, x0, x23
	.loc 3 1089 0
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 216]
	.loc 3 1090 0
	mov	w1, 1
	add	x0, x29, 208
	bl	FlashReadPages
.LVL2061:
	.loc 3 1091 0
	ldr	w0, [x29, 208]
	cmn	w0, #1
	bne	.L1540
	.loc 3 1092 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L1543:
	ldr	w0, [x29, 172]
.LBE298:
	.loc 3 1104 0
	cmp	w20, w21
	lsl	w2, w0, 9
	bne	.L1544
	.loc 3 1105 0
	ldr	x1, [x28, #:lo12:.LANCHOR122]
	ldr	w0, [x29, 164]
	add	x1, x1, x23
	lsl	w0, w0, 9
	ldr	x3, [x1, 8]
	mov	x1, x25
	add	x0, x3, x0
	bl	ftl_memcpy
.LVL2062:
	.loc 3 1109 0
	ldr	w0, [x29, 168]
	cmp	w20, w0
	bne	.L1536
.L1545:
	.loc 3 1110 0
	ldrh	w0, [x19, 4]
	cbz	w0, .L1536
	.loc 3 1111 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x23, x0, x23
	ldr	x0, [x29, 120]
	str	x23, [x0, #:lo12:.LANCHOR150]
	.loc 3 1112 0
	adrp	x0, .LANCHOR171
	str	x19, [x0, #:lo12:.LANCHOR171]
	b	.L1536
.L1537:
	.loc 3 1082 0
	adrp	x1, .LANCHOR114
	ldr	x1, [x1, #:lo12:.LANCHOR114]
	b	.L1573
.L1540:
.LBB299:
	.loc 3 1094 0
	ldr	w1, [x27, 8]
	cmp	w20, w1
	beq	.L1542
	.loc 3 1095 0
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	.loc 3 1096 0
	adrp	x0, .LC105
	mov	w2, w20
	add	x0, x0, :lo12:.LC105
	bl	printf
.LVL2063:
.L1542:
	.loc 3 1098 0
	ldr	w0, [x27, 8]
	cmp	w20, w0
	beq	.L1543
	.loc 3 1098 0 is_stmt 0 discriminator 1
	mov	w2, 1098
	adrp	x1, .LANCHOR180
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2064:
	b	.L1543
.LVL2065:
.L1539:
.LBE299:
	.loc 3 1101 0 is_stmt 1
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	ldr	x1, [x29, 104]
	add	x0, x0, x23
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
.LVL2066:
	b	.L1543
.L1544:
	.loc 3 1107 0
	ldr	x0, [x29, 176]
	ldrh	w1, [x0, #:lo12:.LANCHOR12]
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x0, x0, x23
	mul	w1, w1, w20
	ldr	x0, [x0, 8]
	sub	w1, w1, w22
	lsl	w1, w1, 9
	add	x1, x25, x1
	bl	ftl_memcpy
.LVL2067:
	b	.L1545
.LVL2068:
.L1531:
	.loc 3 1117 0
	ldr	x0, [x28, #:lo12:.LANCHOR122]
	add	x23, x0, x23
	ldr	x0, [x29, 176]
	ldrh	w0, [x0, #:lo12:.LANCHOR12]
	b	.L1574
.LVL2069:
.L1556:
	.loc 3 975 0
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
	.loc 3 1209 0
	.cfi_startproc
.LVL2070:
	.loc 3 1210 0
	mov	x3, x2
	mov	w2, w1
.LVL2071:
	mov	w1, w0
.LVL2072:
	mov	w0, 0
.LVL2073:
	b	FtlWrite
.LVL2074:
	.cfi_endproc
.LFE220:
	.size	sftl_write, .-sftl_write
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
.LFB274:
	.loc 2 1360 0
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.loc 2 1368 0
	mov	w1, 0
	.loc 2 1360 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.loc 2 1365 0
	adrp	x19, .LANCHOR108
	.loc 2 1360 0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.loc 2 1365 0
	adrp	x23, .LANCHOR39
	.loc 2 1360 0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.loc 2 1365 0
	add	x21, x19, :lo12:.LANCHOR108
	.loc 2 1360 0
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.loc 2 1366 0
	adrp	x26, .LANCHOR109
	.loc 2 1360 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	.loc 2 1368 0
	adrp	x25, .LANCHOR43
	.loc 2 1365 0
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	.loc 2 1368 0
	adrp	x24, .LANCHOR5
	.loc 2 1365 0
	str	x0, [x21, 8]
	.loc 2 1369 0
	adrp	x20, .LANCHOR81
	.loc 2 1366 0
	ldr	x0, [x26, #:lo12:.LANCHOR109]
	str	x0, [x21, 16]
	.loc 2 1368 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL2075:
	.loc 2 1369 0
	ldrh	w0, [x20, #:lo12:.LANCHOR81]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1577
.L1585:
	.loc 2 1370 0
	mov	w0, -1
.L1576:
	.loc 2 1463 0
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
.L1577:
	.cfi_restore_state
	add	x27, x20, :lo12:.LANCHOR81
	.loc 2 1372 0
	mov	w1, 1
	bl	FtlGetLastWrittenPage
.LVL2076:
	sxth	w22, w0
.LVL2077:
	.loc 2 1373 0
	add	w0, w0, 1
	.loc 2 1382 0
	mov	w28, 61604
	.loc 2 1373 0
	strh	w0, [x27, 2]
	.loc 2 1381 0
	mov	w27, 19539
	movk	w27, 0x4654, lsl 16
.L1579:
	.loc 2 1375 0
	tbz	w22, #31, .L1582
	.loc 2 1388 0
	adrp	x1, .LANCHOR181
	adrp	x0, .LC1
	mov	w2, 1388
	add	x1, x1, :lo12:.LANCHOR181
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2078:
.L1581:
	.loc 2 1390 0
	adrp	x1, .LANCHOR23
	ldrh	w0, [x24, #:lo12:.LANCHOR5]
	ldrh	w1, [x1, #:lo12:.LANCHOR23]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L1584
	.loc 2 1390 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR181
	adrp	x0, .LC1
	mov	w2, 1390
	add	x1, x1, :lo12:.LANCHOR181
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2079:
.L1584:
	.loc 2 1392 0 is_stmt 1
	add	x22, x19, :lo12:.LANCHOR108
.LVL2080:
	adrp	x19, .LANCHOR79
	add	x21, x19, :lo12:.LANCHOR79
	mov	w2, 48
	mov	x0, x21
	ldr	x1, [x22, 8]
	bl	ftl_memcpy
.LVL2081:
	.loc 2 1393 0
	ldr	x0, [x25, #:lo12:.LANCHOR43]
	ldrh	w2, [x24, #:lo12:.LANCHOR5]
	ldr	x1, [x22, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
.LVL2082:
	.loc 2 1394 0
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
.LVL2083:
	.loc 2 1396 0
	ldr	w1, [x19, #:lo12:.LANCHOR79]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1585
	.loc 2 1399 0
	add	x20, x20, :lo12:.LANCHOR81
	.loc 2 1400 0
	adrp	x0, .LANCHOR10
	.loc 2 1399 0
	ldrh	w1, [x21, 8]
	.loc 2 1400 0
	ldrb	w2, [x21, 10]
	ldrh	w0, [x0, #:lo12:.LANCHOR10]
	.loc 2 1399 0
	strh	w1, [x20, 6]
	.loc 2 1400 0
	cmp	w2, w0
	bne	.L1585
	.loc 2 1403 0
	adrp	x0, .LANCHOR182
	.loc 2 1404 0
	adrp	x2, .LANCHOR62
	.loc 2 1406 0
	adrp	x3, .LANCHOR3
	.loc 2 1403 0
	str	w1, [x0, #:lo12:.LANCHOR182]
	.loc 2 1404 0
	adrp	x0, .LANCHOR19
	.loc 2 1406 0
	ldrh	w3, [x3, #:lo12:.LANCHOR3]
	.loc 2 1404 0
	ldrh	w0, [x0, #:lo12:.LANCHOR19]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR62]
	.loc 2 1405 0
	adrp	x2, .LANCHOR12
	ldrh	w2, [x2, #:lo12:.LANCHOR12]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR34
	str	w0, [x2, #:lo12:.LANCHOR34]
	.loc 2 1406 0
	adrp	x0, .LANCHOR7
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LANCHOR37+6
	ldrh	w0, [x0, #:lo12:.LANCHOR37+6]
	.loc 2 1412 0
	cmp	w1, w2
	.loc 2 1406 0
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR80
	strh	w0, [x3, #:lo12:.LANCHOR80]
	.loc 2 1412 0
	bls	.L1586
	.loc 2 1412 0 is_stmt 0 discriminator 1
	adrp	x1, .LANCHOR181
	adrp	x0, .LC1
	mov	w2, 1412
	add	x1, x1, :lo12:.LANCHOR181
	add	x0, x0, :lo12:.LC1
	bl	printf
.LVL2084:
.L1586:
	.loc 2 1414 0 is_stmt 1
	add	x1, x19, :lo12:.LANCHOR79
	adrp	x0, .LANCHOR51
	add	x3, x0, :lo12:.LANCHOR51
	.loc 2 1419 0
	adrp	x20, .LANCHOR82
	.loc 2 1415 0
	ldrh	w2, [x1, 16]
	.loc 2 1414 0
	ldrh	w6, [x1, 14]
	strh	w6, [x0, #:lo12:.LANCHOR51]
	.loc 2 1415 0
	lsr	w4, w2, 6
	.loc 2 1416 0
	and	w2, w2, 63
	strb	w2, [x3, 6]
	.loc 2 1417 0
	ldrb	w2, [x1, 11]
	strb	w2, [x3, 8]
	.loc 2 1419 0
	add	x2, x20, :lo12:.LANCHOR82
	.loc 2 1415 0
	strh	w4, [x3, 2]
	.loc 2 1419 0
	mov	w3, -1
	strh	w3, [x20, #:lo12:.LANCHOR82]
	.loc 2 1420 0
	strh	wzr, [x2, 2]
	.loc 2 1421 0
	strb	wzr, [x2, 6]
	.loc 2 1422 0
	strb	wzr, [x2, 8]
	.loc 2 1424 0
	adrp	x2, .LANCHOR52
	ldrh	w3, [x1, 18]
	add	x4, x2, :lo12:.LANCHOR52
	strh	w3, [x2, #:lo12:.LANCHOR52]
	mov	x21, x2
	.loc 2 1425 0
	ldrh	w3, [x1, 20]
	lsr	w5, w3, 6
	.loc 2 1426 0
	and	w3, w3, 63
	strb	w3, [x4, 6]
	.loc 2 1427 0
	ldrb	w3, [x1, 12]
	.loc 2 1425 0
	strh	w5, [x4, 2]
	.loc 2 1427 0
	strb	w3, [x4, 8]
	.loc 2 1429 0
	adrp	x4, .LANCHOR53
	ldrh	w3, [x1, 22]
	add	x5, x4, :lo12:.LANCHOR53
	strh	w3, [x4, #:lo12:.LANCHOR53]
	mov	x22, x4
	.loc 2 1430 0
	ldrh	w3, [x1, 24]
	lsr	w7, w3, 6
	.loc 2 1431 0
	and	w3, w3, 63
	strb	w3, [x5, 6]
	.loc 2 1432 0
	ldrb	w3, [x1, 13]
	strb	w3, [x5, 8]
	.loc 2 1434 0
	adrp	x3, .LANCHOR68
	.loc 2 1430 0
	strh	w7, [x5, 2]
	.loc 2 1439 0
	ldr	w5, [x1, 32]
	.loc 2 1434 0
	str	wzr, [x3, #:lo12:.LANCHOR68]
	.loc 2 1435 0
	adrp	x3, .LANCHOR65
	str	wzr, [x3, #:lo12:.LANCHOR65]
	.loc 2 1436 0
	adrp	x3, .LANCHOR63
	str	wzr, [x3, #:lo12:.LANCHOR63]
	.loc 2 1437 0
	adrp	x3, .LANCHOR67
	str	wzr, [x3, #:lo12:.LANCHOR67]
	.loc 2 1439 0
	adrp	x3, .LANCHOR73
	str	w5, [x3, #:lo12:.LANCHOR73]
	.loc 2 1440 0
	adrp	x3, .LANCHOR74
	str	wzr, [x3, #:lo12:.LANCHOR74]
	.loc 2 1441 0
	adrp	x3, .LANCHOR77
	str	wzr, [x3, #:lo12:.LANCHOR77]
	.loc 2 1442 0
	adrp	x3, .LANCHOR66
	str	wzr, [x3, #:lo12:.LANCHOR66]
	.loc 2 1444 0
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR71
	ldr	w5, [x1, #:lo12:.LANCHOR71]
	cmp	w3, w5
	bls	.L1587
	.loc 2 1445 0
	str	w3, [x1, #:lo12:.LANCHOR71]
.L1587:
	.loc 2 1447 0
	add	x19, x19, :lo12:.LANCHOR79
	adrp	x1, .LANCHOR72
	ldr	w3, [x1, #:lo12:.LANCHOR72]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L1588
	.loc 2 1448 0
	str	w2, [x1, #:lo12:.LANCHOR72]
.L1588:
	.loc 2 1450 0
	mov	w1, 65535
	cmp	w6, w1
	beq	.L1589
	.loc 2 1451 0
	add	x0, x0, :lo12:.LANCHOR51
	bl	make_superblock
.LVL2085:
.L1589:
	.loc 2 1453 0
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR52
	cmp	w2, w1
	beq	.L1590
	.loc 2 1454 0
	bl	make_superblock
.LVL2086:
.L1590:
	.loc 2 1456 0
	ldrh	w2, [x22, #:lo12:.LANCHOR53]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR53
	cmp	w2, w1
	beq	.L1591
	.loc 2 1457 0
	bl	make_superblock
.LVL2087:
.L1591:
	.loc 2 1459 0
	ldrh	w2, [x20, #:lo12:.LANCHOR82]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR82
	cmp	w2, w1
	beq	.L1592
	.loc 2 1460 0
	bl	make_superblock
.LVL2088:
.L1592:
	.loc 2 1462 0
	mov	w0, 0
	b	.L1576
.LVL2089:
.L1582:
	.loc 2 1376 0
	ldrh	w0, [x20, #:lo12:.LANCHOR81]
	.loc 2 1378 0
	mov	w2, 1
	mov	w1, w2
	.loc 2 1376 0
	orr	w0, w22, w0, lsl 10
	str	w0, [x21, 4]
	.loc 2 1377 0
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	str	x0, [x21, 8]
	.loc 2 1378 0
	mov	x0, x21
	bl	FlashReadPages
.LVL2090:
	.loc 2 1381 0
	ldr	w0, [x21]
	cmn	w0, #1
	beq	.L1580
	.loc 2 1382 0 discriminator 1
	ldr	x0, [x23, #:lo12:.LANCHOR39]
	.loc 2 1381 0 discriminator 1
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1580
	.loc 2 1383 0
	ldr	x0, [x26, #:lo12:.LANCHOR109]
	ldrh	w0, [x0]
	.loc 2 1382 0
	cmp	w0, w28
	beq	.L1581
.L1580:
	sub	w22, w22, #1
.LVL2091:
	sxth	w22, w22
.LVL2092:
	b	.L1579
	.cfi_endproc
.LFE274:
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlSysBlkInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkInit
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
.LFB292:
	.loc 2 2306 0
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	.loc 2 2312 0
	adrp	x0, .LANCHOR4
	.loc 2 2306 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	.loc 2 2312 0
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	.loc 2 2306 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.loc 2 2310 0
	adrp	x20, .LANCHOR162
	.loc 2 2306 0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	.loc 2 2310 0
	strh	wzr, [x20, #:lo12:.LANCHOR162]
	.loc 2 2312 0
	bl	FtlFreeSysBlkQueueInit
.LVL2093:
	.loc 2 2313 0
	bl	FtlScanSysBlk
.LVL2094:
	.loc 2 2314 0
	adrp	x0, .LANCHOR81
	ldrh	w1, [x0, #:lo12:.LANCHOR81]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1599
.L1601:
	.loc 2 2315 0
	mov	w23, -1
.L1598:
	.loc 2 2398 0
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
.L1599:
	.cfi_restore_state
	.loc 2 2317 0
	bl	FtlLoadSysInfo
.LVL2095:
	mov	w23, w0
	cbnz	w0, .L1601
	.loc 2 2320 0
	bl	FtlLoadMapInfo
.LVL2096:
	.loc 2 2321 0
	bl	FtlLoadVonderInfo
.LVL2097:
	.loc 2 2322 0
	bl	Ftl_load_ext_data
.LVL2098:
	.loc 2 2324 0
	bl	FtlLoadEctTbl
.LVL2099:
	.loc 2 2325 0
	bl	FtlFreeSysBLkSort
.LVL2100:
	.loc 2 2327 0
	bl	SupperBlkListInit
.LVL2101:
	.loc 2 2328 0
	bl	FtlPowerLostRecovery
.LVL2102:
	.loc 2 2330 0
	mov	w0, 1
	bl	FtlUpdateVaildLpn
.LVL2103:
.LBB303:
.LBB304:
	.loc 2 2332 0
	adrp	x0, .LANCHOR33
	ldrh	w2, [x0, #:lo12:.LANCHOR33]
	.loc 2 2333 0
	adrp	x0, .LANCHOR56
	ldr	x1, [x0, #:lo12:.LANCHOR56]
	.loc 2 2332 0
	mov	w0, 0
	add	x1, x1, 4
.L1602:
.LVL2104:
	cmp	w0, w2
	bge	.L1607
	.loc 2 2333 0
	ldr	w3, [x1], 16
	tbz	w3, #31, .L1603
.L1607:
	.loc 2 2336 0
	adrp	x19, .LANCHOR79
	add	x3, x19, :lo12:.LANCHOR79
	.loc 2 2338 0
	cmp	w0, w2
	adrp	x22, .LANCHOR51
	.loc 2 2336 0
	ldrh	w1, [x3, 28]
	add	w1, w1, 1
	strh	w1, [x3, 28]
	.loc 2 2338 0
	bge	.L1613
.LVL2105:
.L1604:
	.loc 2 2339 0
	add	x21, x22, :lo12:.LANCHOR51
	.loc 2 2340 0
	adrp	x24, .LANCHOR52
	.loc 2 2339 0
	mov	x0, x21
	.loc 2 2340 0
	add	x20, x24, :lo12:.LANCHOR52
	.loc 2 2339 0
	bl	FtlSuperblockPowerLostFix
.LVL2106:
	.loc 2 2340 0
	mov	x0, x20
	bl	FtlSuperblockPowerLostFix
.LVL2107:
.LBB305:
	.loc 2 2346 0
	adrp	x0, .LANCHOR43
	ldrh	w3, [x21, 4]
	ldr	x1, [x0, #:lo12:.LANCHOR43]
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w3
	.loc 2 2347 0
	adrp	x3, .LANCHOR19
	.loc 2 2346 0
	strh	w2, [x1, x0]
	.loc 2 2348 0
	strb	wzr, [x21, 6]
	.loc 2 2347 0
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x21, 2]
	.loc 2 2352 0
	ldrh	w0, [x24, #:lo12:.LANCHOR52]
	.loc 2 2349 0
	strh	wzr, [x21, 4]
.LVL2108:
	.loc 2 2352 0
	ldrh	w4, [x20, 4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w4
	strh	w2, [x1, x0]
	.loc 2 2354 0
	strb	wzr, [x20, 6]
	.loc 2 2353 0
	ldrh	w0, [x3, #:lo12:.LANCHOR19]
	strh	w0, [x20, 2]
	.loc 2 2355 0
	strh	wzr, [x20, 4]
.LBE305:
	.loc 2 2359 0
	adrp	x0, .LANCHOR144
	add	x0, x0, :lo12:.LANCHOR144
	bl	FtlMapBlkWriteDump_data
.LVL2109:
	.loc 2 2360 0
	adrp	x0, .LANCHOR149
	add	x0, x0, :lo12:.LANCHOR149
	bl	FtlMapBlkWriteDump_data
.LVL2110:
	.loc 2 2372 0
	add	x1, x19, :lo12:.LANCHOR79
	ldrh	w0, [x1, 30]
	add	w0, w0, 1
	strh	w0, [x1, 30]
	.loc 2 2373 0
	bl	l2p_flush
.LVL2111:
	.loc 2 2374 0
	bl	FtlVpcTblFlush
.LVL2112:
	.loc 2 2375 0
	bl	FtlVpcTblFlush
.LVL2113:
	b	.L1608
.LVL2114:
.L1603:
	.loc 2 2332 0
	add	w0, w0, 1
.LVL2115:
	b	.L1602
.L1613:
	.loc 2 2338 0
	ldrh	w0, [x20, #:lo12:.LANCHOR162]
.LVL2116:
	cbnz	w0, .L1604
.L1608:
	.loc 2 2379 0
	ldrh	w0, [x22, #:lo12:.LANCHOR51]
	mov	w1, 65535
	add	x21, x22, :lo12:.LANCHOR51
	cmp	w0, w1
	beq	.L1609
	ldrh	w1, [x21, 4]
	cbnz	w1, .L1609
	.loc 2 2381 0
	adrp	x22, .LANCHOR52
	add	x20, x22, :lo12:.LANCHOR52
	.loc 2 2380 0
	ldrh	w1, [x20, 4]
	cbnz	w1, .L1609
	.loc 2 2382 0
	bl	FtlGcRefreshBlock
.LVL2117:
	.loc 2 2383 0
	ldrh	w0, [x22, #:lo12:.LANCHOR52]
	bl	FtlGcRefreshBlock
.LVL2118:
	.loc 2 2384 0
	mov	x0, x21
	bl	allocate_new_data_superblock
.LVL2119:
	.loc 2 2385 0
	mov	x0, x20
	bl	allocate_new_data_superblock
.LVL2120:
.L1609:
	.loc 2 2390 0
	add	x19, x19, :lo12:.LANCHOR79
	ldrh	w0, [x19, 28]
	tst	x0, 31
	bne	.L1598
	.loc 2 2391 0
	bl	FtlVpcCheckAndModify
.LVL2121:
	b	.L1598
.LBE304:
.LBE303:
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
	adrp	x0, .LANCHOR72
	.loc 3 623 0
	add	x29, sp, 0
	.cfi_def_cfa_register 29
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.loc 3 631 0
	adrp	x24, .LANCHOR4
	.loc 3 630 0
	str	wzr, [x0, #:lo12:.LANCHOR72]
	.loc 3 631 0
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	.loc 3 623 0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.loc 3 629 0
	adrp	x20, .LANCHOR71
	.loc 3 623 0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.loc 3 629 0
	str	wzr, [x20, #:lo12:.LANCHOR71]
	.loc 3 631 0
	bl	FtlFreeSysBlkQueueInit
.LVL2122:
	.loc 3 632 0
	bl	FtlLoadBbt
.LVL2123:
	cbz	w0, .L1616
	.loc 3 633 0
	bl	FtlMakeBbt
.LVL2124:
.L1616:
	.loc 3 635 0 discriminator 1
	adrp	x23, .LANCHOR12
	.loc 3 636 0 discriminator 1
	adrp	x0, .LANCHOR116
	.loc 3 637 0 discriminator 1
	mov	w6, 23752
	.loc 3 635 0 discriminator 1
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	.loc 3 637 0 discriminator 1
	movk	w6, 0xa0f, lsl 16
	.loc 3 636 0 discriminator 1
	ldr	x4, [x0, #:lo12:.LANCHOR116]
	.loc 3 637 0 discriminator 1
	adrp	x0, .LANCHOR114
	.loc 3 635 0 discriminator 1
	lsl	w1, w1, 7
	.loc 3 637 0 discriminator 1
	ldr	x5, [x0, #:lo12:.LANCHOR114]
	mov	w0, 0
.L1617:
.LVL2125:
	.loc 3 635 0 discriminator 1
	cmp	w0, w1
	blt	.L1618
.LVL2126:
	.loc 3 642 0
	adrp	x21, .LANCHOR5
	adrp	x22, .LANCHOR6
	add	x26, x22, :lo12:.LANCHOR6
	.loc 3 641 0
	mov	w19, 0
	.loc 3 642 0
	ldrh	w25, [x21, #:lo12:.LANCHOR5]
.LVL2127:
.L1619:
	.loc 3 642 0 is_stmt 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L1620
	.loc 3 645 0 is_stmt 1
	adrp	x25, .LANCHOR3
.LVL2128:
	sub	w1, w19, #2
	ldrh	w0, [x25, #:lo12:.LANCHOR3]
	cmp	w1, w0, lsl 1
	bgt	.L1621
.LVL2129:
.L1625:
	.loc 3 656 0
	add	x26, x21, :lo12:.LANCHOR5
	.loc 3 641 0
	mov	w19, 0
	mov	w24, 0
.L1622:
.LVL2130:
	.loc 3 656 0 discriminator 1
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L1626
	.loc 3 658 0
	adrp	x0, .LANCHOR113
	ldrh	w1, [x22, #:lo12:.LANCHOR6]
	.loc 3 661 0
	ldrh	w4, [x25, #:lo12:.LANCHOR3]
	.loc 3 662 0
	adrp	x2, .LANCHOR80
	.loc 3 658 0
	str	w1, [x0, #:lo12:.LANCHOR113]
	.loc 3 661 0
	adrp	x0, .LANCHOR7
	adrp	x3, .LANCHOR62
	ldr	w1, [x0, #:lo12:.LANCHOR7]
	udiv	w5, w1, w4
	.loc 3 662 0
	ubfx	x0, x5, 5, 16
	.loc 3 661 0
	str	w5, [x3, #:lo12:.LANCHOR62]
	.loc 3 662 0
	add	w6, w0, 36
	strh	w6, [x2, #:lo12:.LANCHOR80]
	.loc 3 663 0
	mov	w6, 24
	mul	w6, w4, w6
	cmp	w19, w6
	ble	.L1627
	.loc 3 664 0
	sub	w1, w1, w19
	udiv	w1, w1, w4
	str	w1, [x3, #:lo12:.LANCHOR62]
	.loc 3 665 0
	lsr	w1, w1, 5
	add	w1, w1, 24
	strh	w1, [x2, #:lo12:.LANCHOR80]
.L1627:
	.loc 3 668 0
	adrp	x1, .LANCHOR15
	ldrh	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1629
	.loc 3 669 0
	ldrh	w6, [x2, #:lo12:.LANCHOR80]
	add	w6, w6, w1, lsr 1
	strh	w6, [x2, #:lo12:.LANCHOR80]
	.loc 3 670 0
	mul	w6, w1, w4
	cmp	w19, w6
	bge	.L1629
	.loc 3 672 0
	add	w1, w1, 32
	.loc 3 671 0
	str	w5, [x3, #:lo12:.LANCHOR62]
	.loc 3 672 0
	add	w1, w0, w1
	strh	w1, [x2, #:lo12:.LANCHOR80]
.L1629:
	.loc 3 677 0
	ldrh	w1, [x2, #:lo12:.LANCHOR80]
	adrp	x25, .LANCHOR182
	ldr	w0, [x3, #:lo12:.LANCHOR62]
	.loc 3 687 0
	adrp	x24, .LANCHOR43
.LVL2131:
	.loc 3 677 0
	sub	w0, w0, w1
	.loc 3 678 0
	adrp	x1, .LANCHOR19
	ldrh	w1, [x1, #:lo12:.LANCHOR19]
	.loc 3 677 0
	mul	w0, w0, w4
	str	w0, [x25, #:lo12:.LANCHOR182]
	.loc 3 678 0
	mul	w0, w1, w0
	.loc 3 679 0
	ldrh	w1, [x23, #:lo12:.LANCHOR12]
	.loc 3 678 0
	str	w0, [x3, #:lo12:.LANCHOR62]
	.loc 3 689 0
	mov	w23, -1
	.loc 3 679 0
	mul	w0, w1, w0
	adrp	x1, .LANCHOR34
	str	w0, [x1, #:lo12:.LANCHOR34]
	.loc 3 684 0
	bl	FtlBbmTblFlush
.LVL2132:
	.loc 3 687 0
	ldr	x0, [x24, #:lo12:.LANCHOR43]
	mov	w1, 0
	ldrh	w2, [x22, #:lo12:.LANCHOR6]
	lsl	w2, w2, 1
	bl	ftl_memset
.LVL2133:
	.loc 3 688 0
	adrp	x0, .LANCHOR60
	.loc 3 689 0
	adrp	x1, .LANCHOR82
	.loc 3 698 0
	ldrh	w2, [x21, #:lo12:.LANCHOR5]
	.loc 3 688 0
	str	wzr, [x0, #:lo12:.LANCHOR60]
	.loc 3 689 0
	add	x0, x1, :lo12:.LANCHOR82
	strh	w23, [x1, #:lo12:.LANCHOR82]
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
.LVL2134:
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
.LVL2135:
.L1631:
	.loc 3 701 0
	mov	x0, x19
	bl	make_superblock
.LVL2136:
	.loc 3 702 0
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1632
	.loc 3 705 0
	ldr	x1, [x24, #:lo12:.LANCHOR43]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	.loc 3 706 0
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	.loc 3 707 0
	b	.L1631
.LVL2137:
.L1618:
	.loc 3 636 0 discriminator 3
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	.loc 3 635 0 discriminator 3
	add	w0, w0, 1
.LVL2138:
	and	w0, w0, 65535
.LVL2139:
	.loc 3 636 0 discriminator 3
	str	w2, [x4, x3]
	.loc 3 637 0 discriminator 3
	str	w6, [x5, x3]
	b	.L1617
.LVL2140:
.L1620:
	.loc 3 643 0 discriminator 3
	mov	w0, w25
	mov	w1, 1
	.loc 3 642 0 discriminator 3
	add	w25, w25, 1
.LVL2141:
	.loc 3 643 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2142:
	add	w19, w19, w0
.LVL2143:
	.loc 3 642 0 discriminator 3
	and	w25, w25, 65535
	.loc 3 643 0 discriminator 3
	and	w19, w19, 65535
.LVL2144:
	b	.L1619
.LVL2145:
.L1621:
	.loc 3 647 0
	udiv	w0, w19, w0
	adrp	x1, .LANCHOR31
	ldr	w19, [x1, #:lo12:.LANCHOR31]
.LVL2146:
	add	w0, w0, w19
	bl	FtlSysBlkNumInit
.LVL2147:
	.loc 3 648 0
	ldrh	w0, [x24, #:lo12:.LANCHOR4]
	.loc 3 650 0
	add	x24, x22, :lo12:.LANCHOR6
	.loc 3 648 0
	bl	FtlFreeSysBlkQueueInit
.LVL2148:
	.loc 3 650 0
	ldrh	w19, [x21, #:lo12:.LANCHOR5]
.LVL2149:
.L1623:
	.loc 3 650 0 is_stmt 0 discriminator 1
	ldrh	w0, [x24]
	cmp	w0, w19
	bls	.L1625
	.loc 3 651 0 is_stmt 1 discriminator 3
	mov	w0, w19
	.loc 3 650 0 discriminator 3
	add	w19, w19, 1
.LVL2150:
	.loc 3 651 0 discriminator 3
	mov	w1, 1
	.loc 3 650 0 discriminator 3
	and	w19, w19, 65535
	.loc 3 651 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2151:
	b	.L1623
.LVL2152:
.L1626:
	.loc 3 657 0 discriminator 3
	mov	w0, w24
	mov	w1, 0
	.loc 3 656 0 discriminator 3
	add	w24, w24, 1
.LVL2153:
	.loc 3 657 0 discriminator 3
	bl	FtlLowFormatEraseBlock
.LVL2154:
	add	w19, w19, w0
.LVL2155:
	.loc 3 656 0 discriminator 3
	and	w24, w24, 65535
	.loc 3 657 0 discriminator 3
	and	w19, w19, 65535
.LVL2156:
	b	.L1622
.LVL2157:
.L1632:
	.loc 3 709 0
	ldr	w1, [x20, #:lo12:.LANCHOR71]
	.loc 3 710 0
	ubfiz	x0, x0, 1, 16
	.loc 3 709 0
	str	w1, [x19, 12]
	.loc 3 721 0
	mov	w23, -1
	.loc 3 709 0
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR71]
	.loc 3 710 0
	ldr	x1, [x24, #:lo12:.LANCHOR43]
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
.L1633:
	.loc 3 717 0
	mov	x0, x19
	bl	make_superblock
.LVL2158:
	.loc 3 718 0
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L1634
	.loc 3 721 0
	ldr	x1, [x24, #:lo12:.LANCHOR43]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	.loc 3 722 0
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	.loc 3 723 0
	b	.L1633
.L1634:
	.loc 3 725 0
	ldr	w1, [x20, #:lo12:.LANCHOR71]
	.loc 3 726 0
	ubfiz	x0, x0, 1, 16
	.loc 3 725 0
	str	w1, [x19, 12]
	.loc 3 727 0
	mov	w4, -1
	.loc 3 725 0
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR71]
	.loc 3 726 0
	ldr	x1, [x24, #:lo12:.LANCHOR43]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	.loc 3 727 0
	adrp	x0, .LANCHOR53
	strh	w4, [x0, #:lo12:.LANCHOR53]
	.loc 3 730 0
	bl	FtlFreeSysBlkQueueOut
.LVL2159:
	adrp	x2, .LANCHOR81
	add	x1, x2, :lo12:.LANCHOR81
	strh	w0, [x2, #:lo12:.LANCHOR81]
	.loc 3 733 0
	ldr	w0, [x25, #:lo12:.LANCHOR182]
	strh	w0, [x1, 6]
	.loc 3 734 0
	ldr	w0, [x20, #:lo12:.LANCHOR71]
	str	w0, [x1, 8]
	add	w0, w0, 1
	.loc 3 731 0
	strh	wzr, [x1, 2]
	.loc 3 732 0
	strh	w4, [x1, 4]
	.loc 3 734 0
	str	w0, [x20, #:lo12:.LANCHOR71]
	.loc 3 735 0
	bl	FtlVpcTblFlush
.LVL2160:
	.loc 3 736 0
	bl	FtlSysBlkInit
.LVL2161:
	cbnz	w0, .L1635
	.loc 3 737 0
	adrp	x0, .LANCHOR88
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR88]
.L1635:
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
.LVL2162:
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
	adrp	x19, .LANCHOR88
	str	w0, [x19, #:lo12:.LANCHOR88]
	.loc 3 749 0
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
.LVL2163:
	.loc 3 750 0
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	bl	FtlConstantsInit
.LVL2164:
	.loc 3 751 0
	bl	FtlMemInit
.LVL2165:
	.loc 3 752 0
	bl	FtlVariablesInit
.LVL2166:
	.loc 3 753 0
	adrp	x0, .LANCHOR4
	ldrh	w0, [x0, #:lo12:.LANCHOR4]
	bl	FtlFreeSysBlkQueueInit
.LVL2167:
.LDL2:
	.loc 3 756 0
	bl	FtlLoadBbt
.LVL2168:
	cbnz	w0, .L1644
	.loc 3 767 0
	bl	FtlSysBlkInit
.LVL2169:
	cbnz	w0, .L1644
	.loc 3 779 0
	mov	w0, 1
	str	w0, [x19, #:lo12:.LANCHOR88]
	.loc 3 783 0
	adrp	x0, .LANCHOR48
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 15
	bhi	.L1644
	mov	w19, 8129
.L1643:
.LVL2170:
.LBB306:
	.loc 3 786 0 discriminator 3
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.LVL2171:
	.loc 3 785 0 discriminator 3
	subs	w19, w19, #1
.LVL2172:
	bne	.L1643
.LVL2173:
.L1644:
.LBE306:
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
.LVL2174:
	.loc 1 253 0
	uxtw	x2, w2
	b	memcmp
.LVL2175:
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
	.set	.LANCHOR59,. + 0
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
	.set	.LANCHOR80,. + 0
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
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR111,. + 0
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
	.set	.LANCHOR153,. + 0
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
	.set	.LANCHOR81,. + 0
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
	.set	.LANCHOR72,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.zero	4
	.section	.bss.g_GlobalSysVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR71,. + 0
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
	.set	.LANCHOR182,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR62,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.zero	4
	.section	.bss.g_VaildLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR60,. + 0
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
	.set	.LANCHOR113,. + 0
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
	.set	.LANCHOR166,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.zero	2
	.section	.bss.g_ftl_nand_free_count,"aw",@nobits
	.align	2
	.set	.LANCHOR178,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.zero	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",@nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_blk_index,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.zero	2
	.section	.bss.g_gc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.zero	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR176,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR175,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.zero	2
	.section	.bss.g_gc_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
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
	.set	.LANCHOR85,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_next_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.zero	2
	.section	.bss.g_gc_next_blk_1,"aw",@nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.zero	2
	.section	.bss.g_gc_num_req,"aw",@nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.zero	4
	.section	.bss.g_gc_page_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.zero	2
	.section	.bss.g_gc_skip_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR86,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.zero	4
	.section	.bss.g_gc_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR82,. + 0
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
	.set	.LANCHOR89,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.zero	4
	.section	.bss.g_l2p_last_update_region_id,"aw",@nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.zero	2
	.section	.bss.g_max_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.zero	4
	.section	.bss.g_min_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR78,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.zero	4
	.section	.bss.g_nand_ops,"aw",@nobits
	.align	3
	.set	.LANCHOR107,. + 0
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
	.set	.LANCHOR162,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.zero	128
	.section	.bss.g_req_cache,"aw",@nobits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	g_req_cache, %object
	.size	g_req_cache, 8
g_req_cache:
	.zero	8
	.section	.bss.g_sys_ext_data,"aw",@nobits
	.align	3
	.set	.LANCHOR83,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.zero	512
	.section	.bss.g_sys_save_data,"aw",@nobits
	.align	3
	.set	.LANCHOR79,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.zero	48
	.section	.bss.g_tmp_data_superblock_id,"aw",@nobits
	.align	1
	.set	.LANCHOR151,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.zero	2
	.section	.bss.g_totle_avg_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR75,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.zero	4
	.section	.bss.g_totle_cache_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR66,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.zero	4
	.section	.bss.g_totle_discard_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.zero	4
	.section	.bss.g_totle_gc_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.zero	4
	.section	.bss.g_totle_l2p_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR67,. + 0
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
	.set	.LANCHOR73,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.zero	4
	.section	.bss.g_totle_read_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.zero	4
	.section	.bss.g_totle_read_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR70,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.zero	4
	.section	.bss.g_totle_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_swl_count,"aw",@nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.zero	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR76,. + 0
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
	.set	.LANCHOR65,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.zero	4
	.section	.bss.g_totle_write_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR69,. + 0
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
	.set	.LANCHOR174,. + 0
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
	.set	.LANCHOR92,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR171,. + 0
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
	.set	.LANCHOR42,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 8
p_data_block_list_head:
	.zero	8
	.section	.bss.p_data_block_list_table,"aw",@nobits
	.align	3
	.set	.LANCHOR41,. + 0
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
	.set	.LANCHOR40,. + 0
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
	.set	.LANCHOR98,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 8
p_gc_blk_tbl:
	.zero	8
	.section	.bss.p_gc_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 8
p_gc_data_buf:
	.zero	8
	.section	.bss.p_gc_page_info,"aw",@nobits
	.align	3
	.set	.LANCHOR100,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 8
p_gc_page_info:
	.zero	8
	.section	.bss.p_gc_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 8
p_gc_spare_buf:
	.zero	8
	.section	.bss.p_io_data_buf_0,"aw",@nobits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR136,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 8
p_l2p_map_buf:
	.zero	8
	.section	.bss.p_l2p_ram_map,"aw",@nobits
	.align	3
	.set	.LANCHOR56,. + 0
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
	.set	.LANCHOR39,. + 0
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
	.set	.LANCHOR109,. + 0
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
	.set	.LANCHOR43,. + 0
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
	.set	.LANCHOR112,. + 0
	.type	req_erase, %object
	.size	req_erase, 8
req_erase:
	.zero	8
	.section	.bss.req_gc,"aw",@nobits
	.align	3
	.set	.LANCHOR95,. + 0
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
	.set	.LANCHOR108,. + 0
	.type	req_sys, %object
	.size	req_sys, 32
req_sys:
	.zero	32
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",@progbits
	.align	1
	.set	.LANCHOR157,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR88,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.power_up_flag,"aw",@progbits
	.align	2
	.set	.LANCHOR179,. + 0
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
.LC94:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC95:
	.string	"FtlBbmTblFlush error:%x\n"
.LC96:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlGcFreeBadSuperBlk.str1.1,"aMS",@progbits,1
.LC97:
	.string	"FtlGcFreeBadSuperBlk 0x%x\n"
	.section	.rodata.FtlGcMarkBadPhyBlk.str1.1,"aMS",@progbits,1
.LC74:
	.string	"FtlGcMarkBadPhyBlk %d 0x%x\n"
	.section	.rodata.FtlGcRefreshBlock.str1.1,"aMS",@progbits,1
.LC73:
	.string	"FtlGcRefreshBlock  0x%x\n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC100:
	.string	"no ect"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC86:
	.string	"FtlMapWritePage error = %x \n"
.LC87:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlMemInit.str1.1,"aMS",@progbits,1
.LC82:
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
.LC103:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC99:
	.string	"spuer block %x vpn is 0\n "
	.section	.rodata.FtlVpcCheckAndModify.str1.1,"aMS",@progbits,1
.LC102:
	.string	"FtlCheckVpc %x = %x  %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC101:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC105:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.GetSwlReplaceBlock.str1.1,"aMS",@progbits,1
.LC72:
	.string	"swblk %x ,avg = %x max= %x vpc= %x,ec=%x ,max ec=%x\n"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC1:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.__func__.6104,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.6104, %object
	.size	__func__.6104, 11
__func__.6104:
	.string	"FtlMemInit"
	.section	.rodata.__func__.6228,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.6228, %object
	.size	__func__.6228, 13
__func__.6228:
	.string	"FtlProgPages"
	.section	.rodata.__func__.6256,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.6256, %object
	.size	__func__.6256, 9
__func__.6256:
	.string	"FtlWrite"
	.section	.rodata.__func__.6320,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.6320, %object
	.size	__func__.6320, 14
__func__.6320:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.6363,"a",@progbits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	__func__.6363, %object
	.size	__func__.6363, 11
__func__.6363:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.6486,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.6486, %object
	.size	__func__.6486, 17
__func__.6486:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.6491,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.6491, %object
	.size	__func__.6491, 17
__func__.6491:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.6521,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.6521, %object
	.size	__func__.6521, 17
__func__.6521:
	.string	"List_remove_node"
	.section	.rodata.__func__.6553,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.6553, %object
	.size	__func__.6553, 22
__func__.6553:
	.string	"List_update_data_list"
	.section	.rodata.__func__.6562,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.6562, %object
	.size	__func__.6562, 16
__func__.6562:
	.string	"load_l2p_region"
	.section	.rodata.__func__.6594,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.6594, %object
	.size	__func__.6594, 26
__func__.6594:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.6605,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.6605, %object
	.size	__func__.6605, 15
__func__.6605:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.6619,"a",@progbits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	__func__.6619, %object
	.size	__func__.6619, 31
__func__.6619:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.6633,"a",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	__func__.6633, %object
	.size	__func__.6633, 16
__func__.6633:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.6658,"a",@progbits
	.align	3
	.set	.LANCHOR58,. + 0
	.type	__func__.6658, %object
	.size	__func__.6658, 22
__func__.6658:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.6675,"a",@progbits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	__func__.6675, %object
	.size	__func__.6675, 9
__func__.6675:
	.string	"log2phys"
	.section	.rodata.__func__.6748,"a",@progbits
	.align	3
	.set	.LANCHOR167,. + 0
	.type	__func__.6748, %object
	.size	__func__.6748, 15
__func__.6748:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.6770,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.6770, %object
	.size	__func__.6770, 14
__func__.6770:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.6827,"a",@progbits
	.align	3
	.set	.LANCHOR181,. + 0
	.type	__func__.6827, %object
	.size	__func__.6827, 15
__func__.6827:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.6890,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.6890, %object
	.size	__func__.6890, 16
__func__.6890:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.6924,"a",@progbits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	__func__.6924, %object
	.size	__func__.6924, 22
__func__.6924:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.6981,"a",@progbits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	__func__.6981, %object
	.size	__func__.6981, 16
__func__.6981:
	.string	"make_superblock"
	.section	.rodata.__func__.7002,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.7002, %object
	.size	__func__.7002, 18
__func__.7002:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.7027,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.7027, %object
	.size	__func__.7027, 21
__func__.7027:
	.string	"FtlVpcCheckAndModify"
	.section	.rodata.__func__.7043,"a",@progbits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	__func__.7043, %object
	.size	__func__.7043, 14
__func__.7043:
	.string	"ftl_check_vpc"
	.section	.rodata.__func__.7127,"a",@progbits
	.align	3
	.set	.LANCHOR158,. + 0
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
	.set	.LANCHOR90,. + 0
	.type	__func__.7155, %object
	.size	__func__.7155, 19
__func__.7155:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.7168,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.7168, %object
	.size	__func__.7168, 16
__func__.7168:
	.string	"update_vpc_list"
	.section	.rodata.__func__.7175,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.7175, %object
	.size	__func__.7175, 20
__func__.7175:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.7245,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.7245, %object
	.size	__func__.7245, 19
__func__.7245:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.7351,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.7351, %object
	.size	__func__.7351, 23
__func__.7351:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.7615,"a",@progbits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	__func__.7615, %object
	.size	__func__.7615, 15
__func__.7615:
	.string	"FlashReadPages"
	.section	.rodata.__func__.7632,"a",@progbits
	.align	3
	.set	.LANCHOR110,. + 0
	.type	__func__.7632, %object
	.size	__func__.7632, 15
__func__.7632:
	.string	"FlashProgPages"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC98:
	.string	"decrement_vpc_count %x = %d\n"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",@progbits,1
.LC91:
	.string	"...%s enter...\n"
.LC92:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC93:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC88:
	.string	"ftl_scan_all_data = %x\n"
.LC89:
	.string	"scan lpa = %x ppa= %x\n"
.LC90:
	.string	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC83:
	.string	"region_id = %x phyAddr = %x\n"
.LC84:
	.string	"spare:"
.LC85:
	.string	"map_ppn:"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",@progbits,1
.LC104:
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
	.string	"SFTL version: 5.0.43 20180116"
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
	.4byte	0xa977
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.4byte	.LASF882
	.byte	0xc
	.4byte	.LASF883
	.4byte	.LASF884
	.4byte	.Ldebug_ranges0+0x330
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
	.uleb128 0x28
	.4byte	.LASF443
	.byte	0x1b
	.byte	0x4d
	.4byte	0x1abc
	.uleb128 0x9
	.byte	0x3
	.8byte	g_req_cache
	.uleb128 0xa
	.4byte	0xdbe
	.4byte	0x1b3b
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x28
	.4byte	.LASF444
	.byte	0x1b
	.byte	0x4f
	.4byte	0x1b2b
	.uleb128 0x9
	.byte	0x3
	.8byte	p_plane_order_table
	.uleb128 0x28
	.4byte	.LASF445
	.byte	0x1b
	.byte	0x51
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_data_buf
	.uleb128 0x28
	.4byte	.LASF446
	.byte	0x1b
	.byte	0x52
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_data_buf_1
	.uleb128 0x28
	.4byte	.LASF447
	.byte	0x1b
	.byte	0x53
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_data_buf
	.uleb128 0x28
	.4byte	.LASF448
	.byte	0x1b
	.byte	0x54
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_sys_spare_buf
	.uleb128 0x28
	.4byte	.LASF449
	.byte	0x1b
	.byte	0x55
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_data_buf_0
	.uleb128 0x28
	.4byte	.LASF450
	.byte	0x1b
	.byte	0x56
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_data_buf_1
	.uleb128 0x28
	.4byte	.LASF451
	.byte	0x1b
	.byte	0x57
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_io_spare_buf
	.uleb128 0x28
	.4byte	.LASF452
	.byte	0x1b
	.byte	0x58
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_spare_buf
	.uleb128 0x28
	.4byte	.LASF453
	.byte	0x1b
	.byte	0x59
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_data_buf
	.uleb128 0x28
	.4byte	.LASF454
	.byte	0x1b
	.byte	0x5a
	.4byte	0x1c22
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_gc_page_buf_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x16d6
	.uleb128 0x28
	.4byte	.LASF455
	.byte	0x1b
	.byte	0x5b
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	c_gc_page_buf_num
	.uleb128 0x28
	.4byte	.LASF456
	.byte	0x1b
	.byte	0x5c
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_num_req
	.uleb128 0x28
	.4byte	.LASF457
	.byte	0x1b
	.byte	0x5d
	.4byte	0x1c67
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_ect_tbl_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x113b
	.uleb128 0x28
	.4byte	.LASF458
	.byte	0x1b
	.byte	0x5e
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ect_tbl_info_size
	.uleb128 0x28
	.4byte	.LASF459
	.byte	0x1b
	.byte	0x5f
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_erase_count_table
	.uleb128 0x28
	.4byte	.LASF460
	.byte	0x1b
	.byte	0x61
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_swl_mul_table
	.uleb128 0x28
	.4byte	.LASF461
	.byte	0x1b
	.byte	0x62
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_swl_count
	.uleb128 0x28
	.4byte	.LASF462
	.byte	0x1b
	.byte	0x63
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_valid_page_count_table
	.uleb128 0x28
	.4byte	.LASF463
	.byte	0x1b
	.byte	0x64
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_valid_page_count_check_table
	.uleb128 0x28
	.4byte	.LASF464
	.byte	0x1b
	.byte	0x65
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_blk_mode_table
	.uleb128 0x28
	.4byte	.LASF465
	.byte	0x1b
	.byte	0x67
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_table
	.uleb128 0x28
	.4byte	.LASF466
	.byte	0x1b
	.byte	0x68
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_valid_page_count
	.uleb128 0x28
	.4byte	.LASF467
	.byte	0x1b
	.byte	0x69
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_block_ver_table
	.uleb128 0x28
	.4byte	.LASF468
	.byte	0x1b
	.byte	0x6a
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_map_region_ppn_table
	.uleb128 0x28
	.4byte	.LASF469
	.byte	0x1b
	.byte	0x6b
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_map_block
	.uleb128 0x28
	.4byte	.LASF470
	.byte	0x1b
	.byte	0x6d
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_table
	.uleb128 0x28
	.4byte	.LASF471
	.byte	0x1b
	.byte	0x6e
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_valid_page_count
	.uleb128 0x28
	.4byte	.LASF472
	.byte	0x1b
	.byte	0x6f
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_block_ver_table
	.uleb128 0x28
	.4byte	.LASF473
	.byte	0x1b
	.byte	0x70
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_vendor_region_ppn_table
	.uleb128 0x28
	.4byte	.LASF474
	.byte	0x1b
	.byte	0x71
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_vendor_block
	.uleb128 0x28
	.4byte	.LASF475
	.byte	0x1b
	.byte	0x73
	.4byte	0x1de7
	.uleb128 0x9
	.byte	0x3
	.8byte	p_l2p_ram_map
	.uleb128 0x8
	.byte	0x8
	.4byte	0x10fe
	.uleb128 0x28
	.4byte	.LASF476
	.byte	0x1b
	.byte	0x74
	.4byte	0x1001
	.uleb128 0x9
	.byte	0x3
	.8byte	p_l2p_map_buf
	.uleb128 0x28
	.4byte	.LASF477
	.byte	0x1b
	.byte	0x75
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_l2p_last_update_region_id
	.uleb128 0x28
	.4byte	.LASF478
	.byte	0x1b
	.byte	0x7c
	.4byte	0x1e2c
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_table
	.uleb128 0x8
	.byte	0x8
	.4byte	0x1573
	.uleb128 0x28
	.4byte	.LASF479
	.byte	0x1b
	.byte	0x7d
	.4byte	0x1e2c
	.uleb128 0x9
	.byte	0x3
	.8byte	p_free_data_block_list_head
	.uleb128 0x28
	.4byte	.LASF480
	.byte	0x1b
	.byte	0x7f
	.4byte	0x1e2c
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_head
	.uleb128 0x28
	.4byte	.LASF481
	.byte	0x1b
	.byte	0x80
	.4byte	0x1e2c
	.uleb128 0x9
	.byte	0x3
	.8byte	p_data_block_list_tail
	.uleb128 0x28
	.4byte	.LASF482
	.byte	0x1b
	.byte	0x81
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_num_free_superblocks
	.uleb128 0x28
	.4byte	.LASF483
	.byte	0x1b
	.byte	0x82
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_num_data_superblocks
	.uleb128 0x28
	.4byte	.LASF484
	.byte	0x1b
	.byte	0x83
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_active_superblock
	.uleb128 0x28
	.4byte	.LASF485
	.byte	0x1b
	.byte	0x84
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_buffer_superblock
	.uleb128 0x28
	.4byte	.LASF486
	.byte	0x1b
	.byte	0x85
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_temp_superblock
	.uleb128 0x28
	.4byte	.LASF487
	.byte	0x1b
	.byte	0x86
	.4byte	0x15ff
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_superblock
	.uleb128 0x28
	.4byte	.LASF488
	.byte	0x1b
	.byte	0x87
	.4byte	0x1f04
	.uleb128 0x9
	.byte	0x3
	.8byte	gp_last_act_superblock
	.uleb128 0x8
	.byte	0x8
	.4byte	0x15ff
	.uleb128 0x28
	.4byte	.LASF489
	.byte	0x1b
	.byte	0x88
	.4byte	0x1320
	.uleb128 0x9
	.byte	0x3
	.8byte	g_sys_save_data
	.uleb128 0x28
	.4byte	.LASF490
	.byte	0x1b
	.byte	0x89
	.4byte	0x141d
	.uleb128 0x9
	.byte	0x3
	.8byte	g_sys_ext_data
	.uleb128 0x28
	.4byte	.LASF491
	.byte	0x1b
	.byte	0x8b
	.4byte	0x1f49
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_page_info
	.uleb128 0x8
	.byte	0x8
	.4byte	0x16a1
	.uleb128 0x28
	.4byte	.LASF492
	.byte	0x1b
	.byte	0x8c
	.4byte	0x10f8
	.uleb128 0x9
	.byte	0x3
	.8byte	p_gc_blk_tbl
	.uleb128 0x28
	.4byte	.LASF493
	.byte	0x1b
	.byte	0x8d
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_blk_num
	.uleb128 0x28
	.4byte	.LASF494
	.byte	0x1b
	.byte	0x8e
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_page_offset
	.uleb128 0x28
	.4byte	.LASF495
	.byte	0x1b
	.byte	0x8f
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_cur_blk_valid_pages
	.uleb128 0x28
	.4byte	.LASF496
	.byte	0x1b
	.byte	0x90
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_cur_blk_max_valid_pages
	.uleb128 0x28
	.4byte	.LASF497
	.byte	0x1b
	.byte	0x91
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_next_blk
	.uleb128 0x28
	.4byte	.LASF498
	.byte	0x1b
	.byte	0x92
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_next_blk_1
	.uleb128 0x28
	.4byte	.LASF499
	.byte	0x1b
	.byte	0x93
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_temp_num
	.uleb128 0x28
	.4byte	.LASF500
	.byte	0x1b
	.byte	0x94
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_gc_index
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x201c
	.uleb128 0xe
	.4byte	0xda
	.byte	0x10
	.byte	0
	.uleb128 0x28
	.4byte	.LASF501
	.byte	0x1b
	.byte	0x95
	.4byte	0x200c
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_bad_block_temp_tbl
	.uleb128 0x28
	.4byte	.LASF502
	.byte	0x1b
	.byte	0x97
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_free_blk_threshold
	.uleb128 0x28
	.4byte	.LASF503
	.byte	0x1b
	.byte	0x98
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_merge_free_blk_threshold
	.uleb128 0x28
	.4byte	.LASF504
	.byte	0x1b
	.byte	0x99
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_blk_index
	.uleb128 0x28
	.4byte	.LASF505
	.byte	0x1b
	.byte	0x9b
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_gc_page_count
	.uleb128 0x28
	.4byte	.LASF506
	.byte	0x1b
	.byte	0x9c
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_write_page_count
	.uleb128 0x28
	.4byte	.LASF507
	.byte	0x1b
	.byte	0x9d
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_write_sector
	.uleb128 0x28
	.4byte	.LASF508
	.byte	0x1b
	.byte	0x9e
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_read_sector
	.uleb128 0x28
	.4byte	.LASF509
	.byte	0x1b
	.byte	0xa0
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_discard_page_count
	.uleb128 0x28
	.4byte	.LASF510
	.byte	0x1b
	.byte	0xa1
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_read_page_count
	.uleb128 0x28
	.4byte	.LASF511
	.byte	0x1b
	.byte	0xa2
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_tmp_data_superblock_id
	.uleb128 0x28
	.4byte	.LASF512
	.byte	0x1b
	.byte	0xa3
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_cache_write_count
	.uleb128 0x28
	.4byte	.LASF513
	.byte	0x1b
	.byte	0xa4
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_l2p_write_count
	.uleb128 0x28
	.4byte	.LASF514
	.byte	0x1b
	.byte	0xa6
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_mlc_erase_count
	.uleb128 0x28
	.4byte	.LASF515
	.byte	0x1b
	.byte	0xa7
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_avg_erase_count
	.uleb128 0x28
	.4byte	.LASF516
	.byte	0x1b
	.byte	0xa8
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_min_erase_count
	.uleb128 0x28
	.4byte	.LASF517
	.byte	0x1b
	.byte	0xa9
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_slc_erase_count
	.uleb128 0x28
	.4byte	.LASF518
	.byte	0x1b
	.byte	0xaa
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_totle_sys_slc_erase_count
	.uleb128 0x28
	.4byte	.LASF519
	.byte	0x1b
	.byte	0xab
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_max_erase_count
	.uleb128 0x28
	.4byte	.LASF520
	.byte	0x1b
	.byte	0xac
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_in_gc_progress
	.uleb128 0x28
	.4byte	.LASF521
	.byte	0x1b
	.byte	0xad
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_in_swl_replace
	.uleb128 0x28
	.4byte	.LASF522
	.byte	0x1b
	.byte	0xae
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ftl_nand_free_count
	.uleb128 0x28
	.4byte	.LASF523
	.byte	0x1b
	.byte	0xaf
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_head_data_block
	.uleb128 0x28
	.4byte	.LASF524
	.byte	0x1b
	.byte	0xb0
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_head_data_block_count
	.uleb128 0x28
	.4byte	.LASF525
	.byte	0x1b
	.byte	0xb1
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_gc_skip_write_count
	.uleb128 0x28
	.4byte	.LASF526
	.byte	0x1b
	.byte	0xb2
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_cur_erase_blk
	.uleb128 0x28
	.4byte	.LASF527
	.byte	0x1b
	.byte	0xb4
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_page_num
	.uleb128 0x28
	.4byte	.LASF528
	.byte	0x1b
	.byte	0xb5
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_page_min_ver
	.uleb128 0xa
	.4byte	0xdd4
	.4byte	0x2278
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1f
	.byte	0
	.uleb128 0x28
	.4byte	.LASF529
	.byte	0x1b
	.byte	0xb6
	.4byte	0x2268
	.uleb128 0x9
	.byte	0x3
	.8byte	g_recovery_ppa_tbl
	.uleb128 0x28
	.4byte	.LASF530
	.byte	0x1b
	.byte	0xb7
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	c_mlc_erase_count_value
	.uleb128 0x28
	.4byte	.LASF531
	.byte	0x1b
	.byte	0xb8
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_power_lost_recovery_flag
	.uleb128 0x4
	.4byte	.LASF532
	.byte	0x18
	.byte	0x14
	.4byte	0xe44
	.uleb128 0x4
	.4byte	.LASF533
	.byte	0x18
	.byte	0x15
	.4byte	0xe44
	.uleb128 0x4
	.4byte	.LASF534
	.byte	0x18
	.byte	0x16
	.4byte	0xee6
	.uleb128 0xa
	.4byte	0xb9
	.4byte	0x22e9
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x3ff
	.byte	0
	.uleb128 0x4
	.4byte	.LASF535
	.byte	0x18
	.byte	0x17
	.4byte	0x22d8
	.uleb128 0x28
	.4byte	.LASF536
	.byte	0x3
	.byte	0x6
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	DeviceCapacity
	.uleb128 0x28
	.4byte	.LASF537
	.byte	0x3
	.byte	0x7
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	gFtlInitStatus
	.uleb128 0x4
	.4byte	.LASF538
	.byte	0x3
	.byte	0x6d
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF539
	.byte	0x3
	.byte	0x6e
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF540
	.byte	0x3
	.byte	0x6f
	.4byte	0xdd4
	.uleb128 0x4
	.4byte	.LASF541
	.byte	0x3
	.byte	0x70
	.4byte	0xdd4
	.uleb128 0x29
	.4byte	.LASF542
	.byte	0x3
	.2byte	0x3c0
	.4byte	0x5b
	.uleb128 0x9
	.byte	0x3
	.8byte	power_up_flag
	.uleb128 0x2a
	.4byte	.LASF546
	.byte	0x3
	.2byte	0x483
	.4byte	0xdd4
	.uleb128 0x9
	.byte	0x3
	.8byte	gc_discard_updated
	.uleb128 0x29
	.4byte	.LASF543
	.byte	0x2
	.2byte	0x35b
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	g_ect_tbl_power_up_flush
	.uleb128 0x29
	.4byte	.LASF544
	.byte	0x2
	.2byte	0x370
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	FtlUpdateVaildLpnCount
	.uleb128 0xa
	.4byte	0xdc9
	.4byte	0x23b3
	.uleb128 0x15
	.4byte	0xda
	.2byte	0x1fff
	.byte	0
	.uleb128 0x29
	.4byte	.LASF545
	.byte	0x2
	.2byte	0x8ad
	.4byte	0x23a2
	.uleb128 0x9
	.byte	0x3
	.8byte	check_vpc_table
	.uleb128 0x2b
	.4byte	.LASF547
	.byte	0x5
	.byte	0x6d
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	ftl_gc_temp_block_bops_scan_page_addr
	.uleb128 0x29
	.4byte	.LASF548
	.byte	0x5
	.2byte	0x1d4
	.4byte	0xdc9
	.uleb128 0x9
	.byte	0x3
	.8byte	gc_ink_free_return_value
	.uleb128 0xc
	.4byte	.LASF549
	.byte	0x1c
	.2byte	0x3ba
	.4byte	0x10b
	.uleb128 0xc
	.4byte	.LASF550
	.byte	0x1c
	.2byte	0x3bb
	.4byte	0x10b
	.uleb128 0xc
	.4byte	.LASF551
	.byte	0x1c
	.2byte	0x3bc
	.4byte	0x10b
	.uleb128 0xf
	.4byte	.LASF552
	.byte	0x4
	.byte	0x6
	.byte	0xc
	.4byte	0x2431
	.uleb128 0x16
	.string	"pid"
	.byte	0x6
	.byte	0xd
	.4byte	0x5b
	.byte	0
	.byte	0
	.uleb128 0x4
	.4byte	.LASF553
	.byte	0x6
	.byte	0x10
	.4byte	0x243c
	.uleb128 0x8
	.byte	0x8
	.4byte	0x2418
	.uleb128 0x2c
	.4byte	0x22c2
	.byte	0x1
	.byte	0x10
	.uleb128 0x9
	.byte	0x3
	.8byte	g_nand_phy_info
	.uleb128 0x2c
	.4byte	0x22cd
	.byte	0x1
	.byte	0x11
	.uleb128 0x9
	.byte	0x3
	.8byte	g_nand_ops
	.uleb128 0x2b
	.4byte	.LASF554
	.byte	0x1
	.byte	0x13
	.4byte	0x22d8
	.uleb128 0x9
	.byte	0x3
	.8byte	check_buf
	.uleb128 0x2c
	.4byte	0x22e9
	.byte	0x1
	.byte	0x14
	.uleb128 0x9
	.byte	0x3
	.8byte	ftl_temp_buf
	.uleb128 0xa
	.4byte	0xb9
	.4byte	0x249a
	.uleb128 0xe
	.4byte	0xda
	.byte	0x7f
	.byte	0
	.uleb128 0x2b
	.4byte	.LASF555
	.byte	0x1
	.byte	0x15
	.4byte	0x248a
	.uleb128 0x9
	.byte	0x3
	.8byte	check_spare_buf
	.uleb128 0x2d
	.4byte	.LASF558
	.byte	0x1
	.byte	0xfb
	.4byte	0x5b
	.8byte	.LFB348
	.8byte	.LFE348-.LFB348
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2527
	.uleb128 0x2e
	.4byte	.LASF556
	.byte	0x1
	.byte	0xfb
	.4byte	0x12c
	.4byte	.LLST470
	.uleb128 0x2e
	.4byte	.LASF557
	.byte	0x1
	.byte	0xfb
	.4byte	0x12c
	.4byte	.LLST471
	.uleb128 0x2e
	.4byte	.LASF325
	.byte	0x1
	.byte	0xfb
	.4byte	0x30
	.4byte	.LLST472
	.uleb128 0x2f
	.8byte	.LVL2175
	.4byte	0xa92a
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
	.4byte	.LASF559
	.byte	0x1
	.byte	0xf6
	.4byte	0x12c
	.8byte	.LFB347
	.8byte	.LFE347-.LFB347
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x259f
	.uleb128 0x2e
	.4byte	.LASF560
	.byte	0x1
	.byte	0xf6
	.4byte	0x12c
	.4byte	.LLST305
	.uleb128 0x2e
	.4byte	.LASF561
	.byte	0x1
	.byte	0xf6
	.4byte	0x16f
	.4byte	.LLST306
	.uleb128 0x2e
	.4byte	.LASF30
	.byte	0x1
	.byte	0xf6
	.4byte	0x30
	.4byte	.LLST307
	.uleb128 0x2f
	.8byte	.LVL1243
	.4byte	0xa935
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
	.byte	0xf1
	.4byte	0x12c
	.8byte	.LFB346
	.8byte	.LFE346-.LFB346
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2611
	.uleb128 0x31
	.string	"s"
	.byte	0x1
	.byte	0xf1
	.4byte	0x12c
	.4byte	.LLST198
	.uleb128 0x31
	.string	"c"
	.byte	0x1
	.byte	0xf1
	.4byte	0x5b
	.4byte	.LLST199
	.uleb128 0x31
	.string	"n"
	.byte	0x1
	.byte	0xf1
	.4byte	0x30
	.4byte	.LLST200
	.uleb128 0x2f
	.8byte	.LVL740
	.4byte	0xa941
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
	.4byte	.LASF563
	.byte	0x1
	.byte	0xdf
	.4byte	0xae
	.8byte	.LFB345
	.8byte	.LFE345-.LFB345
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x26cd
	.uleb128 0x2e
	.4byte	.LASF564
	.byte	0x1
	.byte	0xdf
	.4byte	0xf37
	.4byte	.LLST301
	.uleb128 0x31
	.string	"die"
	.byte	0x1
	.byte	0xdf
	.4byte	0xb9
	.4byte	.LLST302
	.uleb128 0x32
	.4byte	.LASF325
	.byte	0x1
	.byte	0xe1
	.4byte	0xa3
	.4byte	.LLST303
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0xe1
	.4byte	0xa3
	.4byte	.LLST304
	.uleb128 0x34
	.8byte	.LVL1230
	.4byte	0x259f
	.4byte	0x2691
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
	.8byte	.LVL1231
	.4byte	0x26ab
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
	.8byte	.LVL1234
	.4byte	0x259f
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
	.4byte	.LASF589
	.byte	0x1
	.byte	0xc4
	.4byte	0xddf
	.byte	0x1
	.4byte	0x2711
	.uleb128 0x38
	.4byte	.LASF577
	.byte	0x1
	.byte	0xc4
	.4byte	0xdc9
	.uleb128 0x39
	.string	"sts"
	.byte	0x1
	.byte	0xc6
	.4byte	0xddf
	.uleb128 0x3a
	.4byte	.LASF565
	.byte	0x1
	.byte	0xc7
	.4byte	0x2711
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
	.4byte	0x2721
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x3c
	.4byte	.LASF566
	.byte	0x1
	.byte	0xae
	.4byte	0xae
	.8byte	.LFB343
	.8byte	.LFE343-.LFB343
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x27e7
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0xae
	.4byte	0x12c
	.4byte	.LLST177
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0xae
	.4byte	0xb9
	.4byte	.LLST178
	.uleb128 0x2e
	.4byte	.LASF569
	.byte	0x1
	.byte	0xae
	.4byte	0xb9
	.4byte	.LLST179
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0xb0
	.4byte	0xb9
	.4byte	.LLST180
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
	.4byte	.LLST181
	.uleb128 0x2b
	.4byte	.LASF570
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
	.4byte	.LLST182
	.uleb128 0x32
	.4byte	.LASF571
	.byte	0x1
	.byte	0xb2
	.4byte	0xb9
	.4byte	.LLST183
	.uleb128 0x36
	.8byte	.LVL671
	.4byte	0x973d
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
	.4byte	0x2aad
	.uleb128 0x2
	.byte	0x83
	.sleb128 -4
	.byte	0
	.byte	0
	.uleb128 0x3c
	.4byte	.LASF572
	.byte	0x1
	.byte	0x72
	.4byte	0xae
	.8byte	.LFB342
	.8byte	.LFE342-.LFB342
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x298f
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0x72
	.4byte	0x12c
	.4byte	.LLST169
	.uleb128 0x2e
	.4byte	.LASF569
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST170
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST171
	.uleb128 0x2e
	.4byte	.LASF573
	.byte	0x1
	.byte	0x72
	.4byte	0xb9
	.4byte	.LLST172
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.4byte	.LLST173
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
	.4byte	.LLST174
	.uleb128 0x2b
	.4byte	.LASF570
	.byte	0x1
	.byte	0x74
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x32
	.4byte	.LASF571
	.byte	0x1
	.byte	0x75
	.4byte	0xb9
	.4byte	.LLST175
	.uleb128 0x33
	.string	"req"
	.byte	0x1
	.byte	0x76
	.4byte	0x1abc
	.4byte	.LLST176
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7632
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0xd0
	.4byte	0x2941
	.uleb128 0x2b
	.4byte	.LASF575
	.byte	0x1
	.byte	0x91
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x34
	.8byte	.LVL659
	.4byte	0x29a4
	.4byte	0x28e7
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
	.8byte	.LVL660
	.4byte	0xa94d
	.4byte	0x2906
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC79
	.byte	0
	.uleb128 0x34
	.8byte	.LVL661
	.4byte	0xa94d
	.4byte	0x2925
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC80
	.byte	0
	.uleb128 0x36
	.8byte	.LVL662
	.4byte	0xa94d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC81
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL650
	.4byte	0xa94d
	.4byte	0x296c
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
	.8byte	.LVL651
	.4byte	0x973d
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
	.4byte	0x2aad
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x299f
	.uleb128 0xe
	.4byte	0xda
	.byte	0xe
	.byte	0
	.uleb128 0x7
	.4byte	0x298f
	.uleb128 0x3c
	.4byte	.LASF576
	.byte	0x1
	.byte	0x54
	.4byte	0xae
	.8byte	.LFB341
	.8byte	.LFE341-.LFB341
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2a9d
	.uleb128 0x2e
	.4byte	.LASF567
	.byte	0x1
	.byte	0x54
	.4byte	0x12c
	.4byte	.LLST154
	.uleb128 0x2e
	.4byte	.LASF569
	.byte	0x1
	.byte	0x54
	.4byte	0xb9
	.4byte	.LLST155
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x1
	.byte	0x54
	.4byte	0xb9
	.4byte	.LLST156
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.4byte	.LLST157
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
	.4byte	.LLST158
	.uleb128 0x2b
	.4byte	.LASF570
	.byte	0x1
	.byte	0x56
	.4byte	0xb9
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x32
	.4byte	.LASF571
	.byte	0x1
	.byte	0x57
	.4byte	0xb9
	.4byte	.LLST159
	.uleb128 0x39
	.string	"req"
	.byte	0x1
	.byte	0x58
	.4byte	0x1abc
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7615
	.uleb128 0x34
	.8byte	.LVL604
	.4byte	0xa94d
	.4byte	0x2a7a
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
	.8byte	.LVL605
	.4byte	0x973d
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
	.4byte	0x2aad
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x41
	.4byte	.LASF885
	.byte	0x1
	.byte	0x3a
	.4byte	0xb9
	.byte	0x1
	.4byte	0x2b1c
	.uleb128 0x42
	.string	"req"
	.byte	0x1
	.byte	0x3a
	.4byte	0x1abc
	.uleb128 0x38
	.4byte	.LASF570
	.byte	0x1
	.byte	0x3a
	.4byte	0xe3e
	.uleb128 0x38
	.4byte	.LASF578
	.byte	0x1
	.byte	0x3a
	.4byte	0xe3e
	.uleb128 0x3a
	.4byte	.LASF579
	.byte	0x1
	.byte	0x3c
	.4byte	0xa3
	.uleb128 0x3a
	.4byte	.LASF580
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
	.4byte	.LASF581
	.byte	0x1
	.byte	0x3e
	.4byte	0xb9
	.uleb128 0x3a
	.4byte	.LASF277
	.byte	0x1
	.byte	0x3f
	.4byte	0xb9
	.uleb128 0x3a
	.4byte	.LASF582
	.byte	0x1
	.byte	0x40
	.4byte	0xb9
	.byte	0
	.uleb128 0x43
	.4byte	.LASF585
	.byte	0x1
	.byte	0x20
	.8byte	.LFB339
	.8byte	.LFE339-.LFB339
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2c25
	.uleb128 0x31
	.string	"s"
	.byte	0x1
	.byte	0x20
	.4byte	0xfa
	.4byte	.LLST145
	.uleb128 0x31
	.string	"buf"
	.byte	0x1
	.byte	0x20
	.4byte	0x12c
	.4byte	.LLST146
	.uleb128 0x2e
	.4byte	.LASF583
	.byte	0x1
	.byte	0x20
	.4byte	0x5b
	.4byte	.LLST147
	.uleb128 0x31
	.string	"len"
	.byte	0x1
	.byte	0x20
	.4byte	0x5b
	.4byte	.LLST148
	.uleb128 0x33
	.string	"i"
	.byte	0x1
	.byte	0x22
	.4byte	0xb9
	.4byte	.LLST149
	.uleb128 0x33
	.string	"j"
	.byte	0x1
	.byte	0x22
	.4byte	0xb9
	.4byte	.LLST150
	.uleb128 0x33
	.string	"p8"
	.byte	0x1
	.byte	0x23
	.4byte	0xfa
	.4byte	.LLST151
	.uleb128 0x33
	.string	"p16"
	.byte	0x1
	.byte	0x24
	.4byte	0x2c25
	.4byte	.LLST152
	.uleb128 0x33
	.string	"p32"
	.byte	0x1
	.byte	0x25
	.4byte	0xe3e
	.4byte	.LLST153
	.uleb128 0x44
	.8byte	.LVL589
	.4byte	0xa94d
	.4byte	0x2bd8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC78
	.byte	0
	.uleb128 0x34
	.8byte	.LVL590
	.4byte	0xa94d
	.4byte	0x2bfc
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
	.8byte	.LVL591
	.4byte	0xa94d
	.uleb128 0x36
	.8byte	.LVL594
	.4byte	0xa94d
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
	.4byte	.LASF584
	.byte	0x1
	.byte	0x1b
	.4byte	0x12c
	.8byte	.LFB338
	.8byte	.LFE338-.LFB338
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2c7c
	.uleb128 0x2e
	.4byte	.LASF30
	.byte	0x1
	.byte	0x1b
	.4byte	0x5b
	.4byte	.LLST144
	.uleb128 0x2f
	.8byte	.LVL581
	.4byte	0xa958
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
	.4byte	.LASF586
	.byte	0x1
	.byte	0x17
	.8byte	.LFB337
	.8byte	.LFE337-.LFB337
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2cdf
	.uleb128 0x31
	.string	"buf"
	.byte	0x1
	.byte	0x17
	.4byte	0x12c
	.4byte	.LLST142
	.uleb128 0x46
	.4byte	0x2cdf
	.8byte	.LBB217
	.8byte	.LBE217-.LBB217
	.byte	0x1
	.byte	0x19
	.uleb128 0x47
	.4byte	0x2ceb
	.4byte	.LLST143
	.uleb128 0x2f
	.8byte	.LVL579
	.4byte	0xa963
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
	.4byte	.LASF886
	.byte	0x6
	.byte	0x4e
	.byte	0x3
	.4byte	0x2cf7
	.uleb128 0x38
	.4byte	.LASF587
	.byte	0x6
	.byte	0x4e
	.4byte	0x16f
	.byte	0
	.uleb128 0x49
	.4byte	.LASF588
	.byte	0x5
	.2byte	0x2f8
	.4byte	0xb9
	.8byte	.LFB320
	.8byte	.LFE320-.LFB320
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2d32
	.uleb128 0x2f
	.8byte	.LVL1930
	.4byte	0x2d32
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
	.4byte	.LASF590
	.byte	0x5
	.2byte	0x1d5
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2dff
	.uleb128 0x4b
	.4byte	.LASF591
	.byte	0x5
	.2byte	0x1d5
	.4byte	0xdd4
	.uleb128 0x4b
	.4byte	.LASF592
	.byte	0x5
	.2byte	0x1d5
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF593
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
	.4byte	.LASF594
	.byte	0x5
	.2byte	0x1d9
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF299
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
	.2byte	0x1da
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF598
	.byte	0x5
	.2byte	0x1db
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF599
	.byte	0x5
	.2byte	0x1dc
	.4byte	0x2dff
	.uleb128 0x4e
	.4byte	.LASF600
	.byte	0x5
	.2byte	0x276
	.uleb128 0x4e
	.4byte	.LASF601
	.byte	0x5
	.2byte	0x279
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x2e15
	.4byte	.LASF590
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF602
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
	.4byte	0x2e15
	.uleb128 0xe
	.4byte	0xda
	.byte	0x16
	.byte	0
	.uleb128 0x7
	.4byte	0x2e05
	.uleb128 0x4a
	.4byte	.LASF603
	.byte	0x5
	.2byte	0x1a2
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2e7a
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
	.4byte	.LASF565
	.byte	0x5
	.2byte	0x1a7
	.4byte	0x2711
	.uleb128 0x51
	.4byte	0x2e6b
	.uleb128 0x4c
	.4byte	.LASF604
	.byte	0x5
	.2byte	0x1b1
	.4byte	0xdf5
	.byte	0
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF605
	.byte	0x5
	.2byte	0x1c6
	.4byte	0xdd4
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF606
	.byte	0x5
	.2byte	0x185
	.4byte	0x5b
	.byte	0x1
	.4byte	0x2ec4
	.uleb128 0x4b
	.4byte	.LASF607
	.byte	0x5
	.2byte	0x185
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF595
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
	.4byte	.LASF715
	.byte	0x5
	.2byte	0x17a
	.4byte	0x5b
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF608
	.byte	0x5
	.2byte	0x166
	.4byte	0x5b
	.8byte	.LFB315
	.8byte	.LFE315-.LFB315
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2f73
	.uleb128 0x53
	.4byte	.LASF388
	.byte	0x5
	.2byte	0x166
	.4byte	0xdc9
	.4byte	.LLST139
	.uleb128 0x54
	.string	"i"
	.byte	0x5
	.2byte	0x168
	.4byte	0xdc9
	.4byte	.LLST140
	.uleb128 0x55
	.4byte	.LASF609
	.byte	0x5
	.2byte	0x169
	.4byte	0xdc9
	.4byte	.LLST141
	.uleb128 0x34
	.8byte	.LVL565
	.4byte	0x6d71
	.4byte	0x2f39
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL568
	.4byte	0xa94d
	.4byte	0x2f5e
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
	.8byte	.LVL569
	.4byte	0x2f73
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF610
	.byte	0x5
	.2byte	0x158
	.4byte	0x5b
	.8byte	.LFB314
	.8byte	.LFE314-.LFB314
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2fc7
	.uleb128 0x53
	.4byte	.LASF587
	.byte	0x5
	.2byte	0x158
	.4byte	0xdc9
	.4byte	.LLST138
	.uleb128 0x36
	.8byte	.LVL561
	.4byte	0xa94d
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
	.4byte	.LASF611
	.byte	0x5
	.2byte	0x13b
	.4byte	0xdd4
	.8byte	.LFB313
	.8byte	.LFE313-.LFB313
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x308d
	.uleb128 0x54
	.string	"i"
	.byte	0x5
	.2byte	0x13d
	.4byte	0xdc9
	.4byte	.LLST411
	.uleb128 0x55
	.4byte	.LASF599
	.byte	0x5
	.2byte	0x13e
	.4byte	0x2dff
	.4byte	.LLST412
	.uleb128 0x34
	.8byte	.LVL1810
	.4byte	0x27e7
	.4byte	0x3023
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
	.8byte	.LVL1812
	.4byte	0x3641
	.4byte	0x3041
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
	.8byte	.LVL1813
	.4byte	0x3320
	.4byte	0x3058
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1815
	.4byte	0x75ef
	.uleb128 0x45
	.8byte	.LVL1816
	.4byte	0x7342
	.uleb128 0x45
	.8byte	.LVL1817
	.4byte	0x32c5
	.uleb128 0x45
	.8byte	.LVL1821
	.4byte	0x3532
	.byte	0
	.uleb128 0x49
	.4byte	.LASF612
	.byte	0x5
	.2byte	0x12b
	.4byte	0xdd4
	.8byte	.LFB312
	.8byte	.LFE312-.LFB312
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x313f
	.uleb128 0x45
	.8byte	.LVL1825
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL1826
	.4byte	0x3320
	.4byte	0x30d3
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1827
	.4byte	0x3a52
	.4byte	0x30f2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1828
	.4byte	0x5d63
	.uleb128 0x34
	.8byte	.LVL1829
	.4byte	0x5968
	.4byte	0x3116
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1830
	.4byte	0x5694
	.uleb128 0x2f
	.8byte	.LVL1831
	.4byte	0x3804
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.byte	0
	.uleb128 0x56
	.4byte	.LASF671
	.byte	0x5
	.2byte	0x120
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF613
	.byte	0x5
	.byte	0xd2
	.4byte	0xdd4
	.8byte	.LFB310
	.8byte	.LFE310-.LFB310
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x32c5
	.uleb128 0x2e
	.4byte	.LASF614
	.byte	0x5
	.byte	0xd2
	.4byte	0x1f04
	.4byte	.LLST288
	.uleb128 0x2e
	.4byte	.LASF615
	.byte	0x5
	.byte	0xd2
	.4byte	0xdd4
	.4byte	.LLST289
	.uleb128 0x32
	.4byte	.LASF597
	.byte	0x5
	.byte	0xd4
	.4byte	0xdc9
	.4byte	.LLST290
	.uleb128 0x32
	.4byte	.LASF569
	.byte	0x5
	.byte	0xd5
	.4byte	0xdc9
	.4byte	.LLST291
	.uleb128 0x33
	.string	"req"
	.byte	0x5
	.byte	0xd5
	.4byte	0xdc9
	.4byte	.LLST292
	.uleb128 0x32
	.4byte	.LASF595
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST293
	.uleb128 0x32
	.4byte	.LASF382
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST294
	.uleb128 0x32
	.4byte	.LASF380
	.byte	0x5
	.byte	0xd6
	.4byte	0xdc9
	.4byte	.LLST295
	.uleb128 0x32
	.4byte	.LASF616
	.byte	0x5
	.byte	0xd7
	.4byte	0xdd4
	.4byte	.LLST296
	.uleb128 0x32
	.4byte	.LASF617
	.byte	0x5
	.byte	0xd8
	.4byte	0xdd4
	.4byte	.LLST297
	.uleb128 0x57
	.4byte	.LASF618
	.byte	0x5
	.byte	0xd9
	.4byte	0xdd4
	.sleb128 -1
	.uleb128 0x32
	.4byte	.LASF599
	.byte	0x5
	.byte	0xda
	.4byte	0x2dff
	.4byte	.LLST298
	.uleb128 0x58
	.4byte	.LASF619
	.byte	0x5
	.byte	0xe1
	.uleb128 0x58
	.4byte	.LASF620
	.byte	0x5
	.byte	0xe5
	.uleb128 0x59
	.4byte	.LASF689
	.byte	0x5
	.2byte	0x117
	.8byte	.L873
	.uleb128 0x45
	.8byte	.LVL1176
	.4byte	0x32c5
	.uleb128 0x34
	.8byte	.LVL1184
	.4byte	0x29a4
	.4byte	0x3265
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
	.8byte	.LVL1197
	.4byte	0x6db1
	.4byte	0x327f
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
	.8byte	.LVL1203
	.4byte	0x4ee3
	.4byte	0x329d
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
	.8byte	.LVL1206
	.4byte	0x3532
	.uleb128 0x45
	.8byte	.LVL1209
	.4byte	0x695b
	.uleb128 0x45
	.8byte	.LVL1211
	.4byte	0x32c5
	.byte	0
	.uleb128 0x43
	.4byte	.LASF621
	.byte	0x5
	.byte	0xc9
	.8byte	.LFB309
	.8byte	.LFE309-.LFB309
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3320
	.uleb128 0x34
	.8byte	.LVL1170
	.4byte	0x259f
	.4byte	0x32fa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1171
	.4byte	0x259f
	.4byte	0x3312
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x5a
	.8byte	.LVL1172
	.4byte	0x3695
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF622
	.byte	0x5
	.byte	0x6f
	.4byte	0x5b
	.8byte	.LFB308
	.8byte	.LFE308-.LFB308
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x351d
	.uleb128 0x2e
	.4byte	.LASF623
	.byte	0x5
	.byte	0x6f
	.4byte	0x5b
	.4byte	.LLST406
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x71
	.4byte	0xdc9
	.4byte	.LLST407
	.uleb128 0x32
	.4byte	.LASF624
	.byte	0x5
	.byte	0x71
	.4byte	0xdc9
	.4byte	.LLST408
	.uleb128 0x2b
	.4byte	.LASF625
	.byte	0x5
	.byte	0x72
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x32
	.4byte	.LASF626
	.byte	0x5
	.byte	0x73
	.4byte	0xdd4
	.4byte	.LLST409
	.uleb128 0x2b
	.4byte	.LASF614
	.byte	0x5
	.byte	0x74
	.4byte	0x1f04
	.uleb128 0xa
	.byte	0x3
	.8byte	g_gc_temp_superblock
	.byte	0x9f
	.uleb128 0x32
	.4byte	.LASF627
	.byte	0x5
	.byte	0x75
	.4byte	0x1f49
	.4byte	.LLST410
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x352d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7245
	.uleb128 0x34
	.8byte	.LVL1771
	.4byte	0x3148
	.4byte	0x33e0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1773
	.4byte	0x5968
	.4byte	0x33f7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1774
	.4byte	0x75ef
	.uleb128 0x45
	.8byte	.LVL1775
	.4byte	0x7342
	.uleb128 0x45
	.8byte	.LVL1779
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL1780
	.4byte	0xa94d
	.4byte	0x3450
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
	.8byte	.LANCHOR173
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xa2
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1782
	.4byte	0x36c0
	.4byte	0x3468
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1783
	.4byte	0x6936
	.uleb128 0x45
	.8byte	.LVL1785
	.4byte	0x5d63
	.uleb128 0x45
	.8byte	.LVL1786
	.4byte	0x5694
	.uleb128 0x34
	.8byte	.LVL1789
	.4byte	0xa94d
	.4byte	0x34ba
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
	.8byte	.LVL1790
	.4byte	0x5c36
	.4byte	0x34d8
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
	.8byte	.LVL1791
	.4byte	0x6d71
	.uleb128 0x34
	.8byte	.LVL1794
	.4byte	0x5c36
	.4byte	0x3502
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
	.8byte	.LVL1796
	.4byte	0x36c0
	.uleb128 0x45
	.8byte	.LVL1800
	.4byte	0x695b
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x352d
	.uleb128 0xe
	.4byte	0xda
	.byte	0x12
	.byte	0
	.uleb128 0x7
	.4byte	0x351d
	.uleb128 0x43
	.4byte	.LASF628
	.byte	0x5
	.byte	0x54
	.8byte	.LFB307
	.8byte	.LFE307-.LFB307
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x35af
	.uleb128 0x2e
	.4byte	.LASF629
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST133
	.uleb128 0x2e
	.4byte	.LASF391
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST134
	.uleb128 0x31
	.string	"lpa"
	.byte	0x5
	.byte	0x54
	.4byte	0xdd4
	.4byte	.LLST135
	.uleb128 0x32
	.4byte	.LASF630
	.byte	0x5
	.byte	0x56
	.4byte	0xdc9
	.4byte	.LLST136
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x57
	.4byte	0xdc9
	.4byte	.LLST137
	.uleb128 0x36
	.8byte	.LVL549
	.4byte	0x6d71
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
	.4byte	.LASF631
	.byte	0x5
	.byte	0x49
	.4byte	0xdd4
	.8byte	.LFB306
	.8byte	.LFE306-.LFB306
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x35ed
	.uleb128 0x31
	.string	"blk"
	.byte	0x5
	.byte	0x49
	.4byte	0xdc9
	.4byte	.LLST131
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x4b
	.4byte	0xdc9
	.4byte	.LLST132
	.byte	0
	.uleb128 0x43
	.4byte	.LASF632
	.byte	0x5
	.byte	0x38
	.8byte	.LFB305
	.8byte	.LFE305-.LFB305
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3641
	.uleb128 0x5b
	.string	"req"
	.byte	0x5
	.byte	0x38
	.4byte	0x1abc
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5c
	.4byte	.LASF633
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
	.4byte	.LLST129
	.uleb128 0x32
	.4byte	.LASF634
	.byte	0x5
	.byte	0x3b
	.4byte	0xdc9
	.4byte	.LLST130
	.byte	0
	.uleb128 0x43
	.4byte	.LASF635
	.byte	0x5
	.byte	0x29
	.8byte	.LFB304
	.8byte	.LFE304-.LFB304
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3695
	.uleb128 0x5b
	.string	"req"
	.byte	0x5
	.byte	0x29
	.4byte	0x1abc
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5c
	.4byte	.LASF633
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
	.4byte	.LLST127
	.uleb128 0x32
	.4byte	.LASF634
	.byte	0x5
	.byte	0x2c
	.4byte	0xdc9
	.4byte	.LLST128
	.byte	0
	.uleb128 0x43
	.4byte	.LASF636
	.byte	0x5
	.byte	0x15
	.8byte	.LFB303
	.8byte	.LFE303-.LFB303
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x36c0
	.uleb128 0x33
	.string	"i"
	.byte	0x5
	.byte	0x17
	.4byte	0xdc9
	.4byte	.LLST126
	.byte	0
	.uleb128 0x49
	.4byte	.LASF637
	.byte	0x2
	.2byte	0xa93
	.4byte	0x5b
	.8byte	.LFB302
	.8byte	.LFE302-.LFB302
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x37af
	.uleb128 0x53
	.4byte	.LASF624
	.byte	0x2
	.2byte	0xa93
	.4byte	0xdc9
	.4byte	.LLST325
	.uleb128 0x54
	.string	"ret"
	.byte	0x2
	.2byte	0xa95
	.4byte	0x5b
	.4byte	.LLST326
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x37bf
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7175
	.uleb128 0x34
	.8byte	.LVL1341
	.4byte	0xa94d
	.4byte	0x373f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC98
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
	.8byte	.LVL1346
	.4byte	0xa94d
	.4byte	0x3772
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
	.2byte	0xa9a
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1347
	.4byte	0x37c4
	.uleb128 0x36
	.8byte	.LVL1349
	.4byte	0xa94d
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
	.2byte	0xaaa
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x37bf
	.uleb128 0xe
	.4byte	0xda
	.byte	0x13
	.byte	0
	.uleb128 0x7
	.4byte	0x37af
	.uleb128 0x4a
	.4byte	.LASF638
	.byte	0x2
	.2byte	0xa7e
	.4byte	0x5b
	.byte	0x1
	.4byte	0x37ef
	.uleb128 0x4b
	.4byte	.LASF624
	.byte	0x2
	.2byte	0xa7e
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x37ff
	.4byte	.LASF638
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x37ff
	.uleb128 0xe
	.4byte	0xda
	.byte	0xf
	.byte	0
	.uleb128 0x7
	.4byte	0x37ef
	.uleb128 0x49
	.4byte	.LASF639
	.byte	0x2
	.2byte	0xa5e
	.4byte	0xdd4
	.8byte	.LFB300
	.8byte	.LFE300-.LFB300
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3932
	.uleb128 0x53
	.4byte	.LASF640
	.byte	0x2
	.2byte	0xa5e
	.4byte	0x1f04
	.4byte	.LLST123
	.uleb128 0x55
	.4byte	.LASF597
	.byte	0x2
	.2byte	0xa60
	.4byte	0xdc9
	.4byte	.LLST124
	.uleb128 0x55
	.4byte	.LASF641
	.byte	0x2
	.2byte	0xa61
	.4byte	0xdd4
	.4byte	.LLST125
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x352d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7155
	.uleb128 0x34
	.8byte	.LVL508
	.4byte	0xa94d
	.4byte	0x389c
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
	.8byte	.LANCHOR90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa63
	.byte	0
	.uleb128 0x34
	.8byte	.LVL509
	.4byte	0xa94d
	.4byte	0x38cf
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
	.8byte	.LANCHOR90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa64
	.byte	0
	.uleb128 0x34
	.8byte	.LVL510
	.4byte	0xa94d
	.4byte	0x3902
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
	.8byte	.LANCHOR90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa65
	.byte	0
	.uleb128 0x36
	.8byte	.LVL514
	.4byte	0xa94d
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
	.8byte	.LANCHOR90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0xa7a
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF642
	.byte	0x2
	.2byte	0xa46
	.4byte	0x5b
	.8byte	.LFB299
	.8byte	.LFE299-.LFB299
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3a3d
	.uleb128 0x53
	.4byte	.LASF640
	.byte	0x2
	.2byte	0xa46
	.4byte	0x1f04
	.4byte	.LLST391
	.uleb128 0x55
	.4byte	.LASF624
	.byte	0x2
	.2byte	0xa48
	.4byte	0xdc9
	.4byte	.LLST392
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x3a4d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7148
	.uleb128 0x34
	.8byte	.LVL1703
	.4byte	0xa94d
	.4byte	0x39ba
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
	.2byte	0xa49
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1704
	.4byte	0x6936
	.4byte	0x39d2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1705
	.4byte	0x37c4
	.uleb128 0x34
	.8byte	.LVL1706
	.4byte	0x3a52
	.4byte	0x39f7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1707
	.4byte	0x5d63
	.uleb128 0x34
	.8byte	.LVL1708
	.4byte	0x5968
	.4byte	0x3a1b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1709
	.4byte	0x5694
	.uleb128 0x36
	.8byte	.LVL1713
	.4byte	0x695b
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
	.4byte	0x3a4d
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1c
	.byte	0
	.uleb128 0x7
	.4byte	0x3a3d
	.uleb128 0x49
	.4byte	.LASF643
	.byte	0x2
	.2byte	0x9e2
	.4byte	0x5b
	.8byte	.LFB298
	.8byte	.LFE298-.LFB298
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3d7d
	.uleb128 0x5d
	.string	"p"
	.byte	0x2
	.2byte	0x9e2
	.4byte	0x1f04
	.4byte	.LLST312
	.uleb128 0x55
	.4byte	.LASF644
	.byte	0x2
	.2byte	0x9e4
	.4byte	0xdc9
	.4byte	.LLST313
	.uleb128 0x4c
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x9e5
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF569
	.byte	0x2
	.2byte	0x9e5
	.4byte	0xdc9
	.4byte	.LLST314
	.uleb128 0x54
	.string	"n"
	.byte	0x2
	.2byte	0x9e5
	.4byte	0xdc9
	.4byte	.LLST315
	.uleb128 0x4c
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x9e5
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF645
	.byte	0x2
	.2byte	0x9e6
	.4byte	0x5b
	.4byte	.LLST316
	.uleb128 0x55
	.4byte	.LASF646
	.byte	0x2
	.2byte	0x9e7
	.4byte	0xdc9
	.4byte	.LLST317
	.uleb128 0x4e
	.4byte	.LASF647
	.byte	0x2
	.2byte	0x9e8
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x3d8d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7127
	.uleb128 0x5e
	.4byte	0x5413
	.8byte	.LBB248
	.8byte	.LBE248-.LBB248
	.byte	0x2
	.2byte	0xa18
	.4byte	0x3b4d
	.uleb128 0x47
	.4byte	0x542c
	.4byte	.LLST318
	.uleb128 0x47
	.4byte	0x5420
	.4byte	.LLST319
	.uleb128 0x36
	.8byte	.LVL1297
	.4byte	0x979f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.uleb128 0x3e
	.4byte	0x542c
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1269
	.4byte	0xa94d
	.4byte	0x3b80
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
	.2byte	0x9e9
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1273
	.4byte	0x66ea
	.4byte	0x3b9f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR47
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1275
	.4byte	0xa94d
	.4byte	0x3bd2
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
	.2byte	0x9f2
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1276
	.4byte	0x460e
	.4byte	0x3bea
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1277
	.4byte	0x6936
	.4byte	0x3c02
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1278
	.4byte	0xa94d
	.4byte	0x3c35
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
	.2byte	0x9fd
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1281
	.4byte	0xa94d
	.4byte	0x3c68
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
	.2byte	0xa00
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1283
	.4byte	0xa94d
	.4byte	0x3c9b
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
	.2byte	0xa0b
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1284
	.4byte	0xa94d
	.4byte	0x3cce
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
	.2byte	0xa0d
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1285
	.4byte	0x5413
	.4byte	0x3ceb
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
	.8byte	.LVL1288
	.4byte	0x2721
	.4byte	0x3d03
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1290
	.4byte	0x3f10
	.4byte	0x3d1b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1291
	.4byte	0x7342
	.uleb128 0x34
	.8byte	.LVL1292
	.4byte	0x6936
	.4byte	0x3d40
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1302
	.4byte	0x75ef
	.uleb128 0x36
	.8byte	.LVL1306
	.4byte	0xa94d
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
	.2byte	0xa42
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x3d8d
	.uleb128 0xe
	.4byte	0xda
	.byte	0x18
	.byte	0
	.uleb128 0x7
	.4byte	0x3d7d
	.uleb128 0x4a
	.4byte	.LASF648
	.byte	0x2
	.2byte	0x9d9
	.4byte	0x5b
	.byte	0x1
	.4byte	0x3db0
	.uleb128 0x4b
	.4byte	.LASF624
	.byte	0x2
	.2byte	0x9d9
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF649
	.byte	0x2
	.2byte	0x98e
	.4byte	0xdc9
	.8byte	.LFB296
	.8byte	.LFE296-.LFB296
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3e7c
	.uleb128 0x55
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x990
	.4byte	0xdc9
	.4byte	.LLST114
	.uleb128 0x55
	.4byte	.LASF651
	.byte	0x2
	.2byte	0x991
	.4byte	0xdc9
	.4byte	.LLST115
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x992
	.4byte	0xdc9
	.4byte	.LLST116
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x993
	.4byte	0x1e2c
	.4byte	.LLST117
	.uleb128 0x55
	.4byte	.LASF654
	.byte	0x2
	.2byte	0x994
	.4byte	0xdc9
	.4byte	.LLST118
	.uleb128 0x55
	.4byte	.LASF655
	.byte	0x2
	.2byte	0x995
	.4byte	0xdc9
	.4byte	.LLST119
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x996
	.4byte	0xdd4
	.4byte	.LLST120
	.uleb128 0x45
	.8byte	.LVL487
	.4byte	0x3e7c
	.uleb128 0x45
	.8byte	.LVL493
	.4byte	0x3edd
	.uleb128 0x36
	.8byte	.LVL495
	.4byte	0xa94d
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
	.4byte	.LASF656
	.byte	0x2
	.2byte	0x979
	.4byte	0xdc9
	.8byte	.LFB295
	.8byte	.LFE295-.LFB295
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3edd
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x979
	.4byte	0xdc9
	.4byte	.LLST103
	.uleb128 0x55
	.4byte	.LASF657
	.byte	0x2
	.2byte	0x97b
	.4byte	0xdc9
	.4byte	.LLST104
	.uleb128 0x55
	.4byte	.LASF587
	.byte	0x2
	.2byte	0x97c
	.4byte	0xdc9
	.4byte	.LLST105
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x97d
	.4byte	0xdc9
	.4byte	.LLST106
	.byte	0
	.uleb128 0x49
	.4byte	.LASF658
	.byte	0x2
	.2byte	0x970
	.4byte	0xdc9
	.8byte	.LFB294
	.8byte	.LFE294-.LFB294
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3f10
	.uleb128 0x55
	.4byte	.LASF652
	.byte	0x2
	.2byte	0x972
	.4byte	0xdc9
	.4byte	.LLST102
	.byte	0
	.uleb128 0x49
	.4byte	.LASF659
	.byte	0x2
	.2byte	0x960
	.4byte	0x5b
	.8byte	.LFB293
	.8byte	.LFE293-.LFB293
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3f98
	.uleb128 0x53
	.4byte	.LASF624
	.byte	0x2
	.2byte	0x960
	.4byte	0xdc9
	.4byte	.LLST98
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x962
	.4byte	0xdc9
	.4byte	.LLST99
	.uleb128 0x55
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x962
	.4byte	0xdc9
	.4byte	.LLST100
	.uleb128 0x55
	.4byte	.LASF375
	.byte	0x2
	.2byte	0x963
	.4byte	0xdc9
	.4byte	.LLST101
	.uleb128 0x34
	.8byte	.LVL295
	.4byte	0x6e0c
	.4byte	0x3f8a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL296
	.4byte	0x7560
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF660
	.byte	0x2
	.2byte	0x901
	.4byte	0x5b
	.byte	0x1
	.4byte	0x3fc2
	.uleb128 0x4d
	.string	"i"
	.byte	0x2
	.2byte	0x903
	.4byte	0x5b
	.uleb128 0x50
	.uleb128 0x4c
	.4byte	.LASF614
	.byte	0x2
	.2byte	0x928
	.4byte	0x1f04
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF661
	.byte	0x2
	.2byte	0x8e2
	.8byte	.LFB291
	.8byte	.LFE291-.LFB291
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x40c6
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x8e4
	.4byte	0x5b
	.4byte	.LLST251
	.uleb128 0x60
	.string	"ppa"
	.byte	0x2
	.2byte	0x8e5
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF662
	.byte	0x2
	.2byte	0x8e6
	.4byte	0x2dff
	.4byte	.LLST252
	.uleb128 0x34
	.8byte	.LVL956
	.4byte	0xa94d
	.4byte	0x4032
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC88
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL959
	.4byte	0x5c36
	.4byte	0x4056
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
	.8byte	.LVL960
	.4byte	0xa94d
	.4byte	0x407b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC89
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL962
	.4byte	0x29a4
	.4byte	0x40a4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR108
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
	.8byte	.LVL963
	.4byte	0xa94d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC90
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF663
	.byte	0x2
	.2byte	0x8ae
	.8byte	.LFB290
	.8byte	.LFE290-.LFB290
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4248
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x8b0
	.4byte	0xdc9
	.4byte	.LLST283
	.uleb128 0x54
	.string	"lpn"
	.byte	0x2
	.2byte	0x8b1
	.4byte	0xdd4
	.4byte	.LLST284
	.uleb128 0x2a
	.4byte	.LASF664
	.byte	0x2
	.2byte	0x8b2
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x54
	.string	"blk"
	.byte	0x2
	.2byte	0x8b3
	.4byte	0xdc9
	.4byte	.LLST285
	.uleb128 0x55
	.4byte	.LASF665
	.byte	0x2
	.2byte	0x8b4
	.4byte	0xdc9
	.4byte	.LLST286
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4258
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7043
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x180
	.4byte	0x4178
	.uleb128 0x55
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x8d1
	.4byte	0xdc9
	.4byte	.LLST287
	.uleb128 0x36
	.8byte	.LVL1165
	.4byte	0xa94d
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
	.8byte	.LVL1143
	.4byte	0xa94d
	.4byte	0x41a4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC91
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR156
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1144
	.4byte	0x259f
	.4byte	0x41c9
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
	.8byte	.LVL1152
	.4byte	0xa94d
	.4byte	0x41fc
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
	.8byte	.LANCHOR156
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x8df
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1154
	.4byte	0x5c36
	.4byte	0x4220
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
	.8byte	.LVL1155
	.4byte	0x6d71
	.uleb128 0x36
	.8byte	.LVL1159
	.4byte	0xa94d
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
	.4byte	0x4258
	.uleb128 0xe
	.4byte	0xda
	.byte	0xd
	.byte	0
	.uleb128 0x7
	.4byte	0x4248
	.uleb128 0x5f
	.4byte	.LASF666
	.byte	0x2
	.2byte	0x88f
	.8byte	.LFB289
	.8byte	.LFE289-.LFB289
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4391
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x891
	.4byte	0xdc9
	.4byte	.LLST388
	.uleb128 0x54
	.string	"lpn"
	.byte	0x2
	.2byte	0x892
	.4byte	0xdd4
	.4byte	.LLST389
	.uleb128 0x2a
	.4byte	.LASF664
	.byte	0x2
	.2byte	0x893
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x54
	.string	"blk"
	.byte	0x2
	.2byte	0x894
	.4byte	0xdc9
	.4byte	.LLST390
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x43a1
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7027
	.uleb128 0x34
	.8byte	.LVL1683
	.4byte	0xa94d
	.4byte	0x42f7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC91
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR168
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1684
	.4byte	0x259f
	.4byte	0x430f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1689
	.4byte	0x5c36
	.4byte	0x4333
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
	.8byte	.LVL1690
	.4byte	0x6d71
	.uleb128 0x34
	.8byte	.LVL1694
	.4byte	0xa94d
	.4byte	0x435e
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
	.8byte	.LVL1695
	.4byte	0x37c4
	.4byte	0x4376
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1696
	.4byte	0x5d63
	.uleb128 0x45
	.8byte	.LVL1697
	.4byte	0x5694
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x43a1
	.uleb128 0xe
	.4byte	0xda
	.byte	0x14
	.byte	0
	.uleb128 0x7
	.4byte	0x4391
	.uleb128 0x5f
	.4byte	.LASF667
	.byte	0x2
	.2byte	0x86b
	.8byte	.LFB288
	.8byte	.LFE288-.LFB288
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x445e
	.uleb128 0x53
	.4byte	.LASF614
	.byte	0x2
	.2byte	0x86b
	.4byte	0x1f04
	.4byte	.LLST356
	.uleb128 0x2a
	.4byte	.LASF668
	.byte	0x2
	.2byte	0x86d
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x55
	.4byte	.LASF599
	.byte	0x2
	.2byte	0x86e
	.4byte	0x2dff
	.4byte	.LLST357
	.uleb128 0x55
	.4byte	.LASF669
	.byte	0x2
	.2byte	0x86f
	.4byte	0x5b
	.4byte	.LLST358
	.uleb128 0x61
	.4byte	.LASF384
	.byte	0x2
	.2byte	0x870
	.4byte	0xdd4
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1517
	.4byte	0x3804
	.4byte	0x4428
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1520
	.4byte	0x27e7
	.4byte	0x4450
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
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1521
	.4byte	0x36c0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF670
	.byte	0x2
	.2byte	0x851
	.8byte	.LFB287
	.8byte	.LFE287-.LFB287
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x44bf
	.uleb128 0x34
	.8byte	.LVL1661
	.4byte	0x59d0
	.4byte	0x449e
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
	.8byte	.LVL1662
	.4byte	0x259f
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
	.4byte	.LASF672
	.byte	0x2
	.2byte	0x83d
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF673
	.byte	0x2
	.2byte	0x812
	.4byte	0x5b
	.8byte	.LFB285
	.8byte	.LFE285-.LFB285
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x45f9
	.uleb128 0x55
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x814
	.4byte	0xdc9
	.4byte	.LLST277
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x814
	.4byte	0xdc9
	.4byte	.LLST278
	.uleb128 0x55
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x814
	.4byte	0xdc9
	.4byte	.LLST279
	.uleb128 0x55
	.4byte	.LASF375
	.byte	0x2
	.2byte	0x814
	.4byte	0xdc9
	.4byte	.LLST280
	.uleb128 0x55
	.4byte	.LASF674
	.byte	0x2
	.2byte	0x815
	.4byte	0xdc9
	.4byte	.LLST281
	.uleb128 0x55
	.4byte	.LASF675
	.byte	0x2
	.2byte	0x815
	.4byte	0xdc9
	.4byte	.LLST282
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4609
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.7002
	.uleb128 0x34
	.8byte	.LVL1117
	.4byte	0x259f
	.4byte	0x4574
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1121
	.4byte	0x6e0c
	.4byte	0x458c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1122
	.4byte	0x7560
	.uleb128 0x34
	.8byte	.LVL1129
	.4byte	0x695b
	.4byte	0x45b1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1137
	.4byte	0x6936
	.4byte	0x45c9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1139
	.4byte	0xa94d
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
	.2byte	0x839
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x4609
	.uleb128 0xe
	.4byte	0xda
	.byte	0x11
	.byte	0
	.uleb128 0x7
	.4byte	0x45f9
	.uleb128 0x49
	.4byte	.LASF676
	.byte	0x2
	.2byte	0x7fc
	.4byte	0x5b
	.8byte	.LFB284
	.8byte	.LFE284-.LFB284
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x46c6
	.uleb128 0x5d
	.string	"p"
	.byte	0x2
	.2byte	0x7fc
	.4byte	0x1f04
	.4byte	.LLST95
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x7fe
	.4byte	0xdc9
	.4byte	.LLST96
	.uleb128 0x55
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x7fe
	.4byte	0xdc9
	.4byte	.LLST97
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x37ff
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6981
	.uleb128 0x34
	.8byte	.LVL278
	.4byte	0xa94d
	.4byte	0x46a4
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
	.8byte	.LANCHOR61
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x800
	.byte	0
	.uleb128 0x45
	.8byte	.LVL282
	.4byte	0x6e0c
	.uleb128 0x36
	.8byte	.LVL284
	.4byte	0x7560
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF677
	.byte	0x2
	.2byte	0x7ef
	.4byte	0x5b
	.8byte	.LFB283
	.8byte	.LFE283-.LFB283
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x476a
	.uleb128 0x34
	.8byte	.LVL1804
	.4byte	0x4790
	.4byte	0x4700
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1805
	.4byte	0x476a
	.4byte	0x4718
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x70
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1806
	.4byte	0x4790
	.4byte	0x4730
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1807
	.4byte	0x476a
	.4byte	0x4748
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1808
	.4byte	0x313f
	.uleb128 0x36
	.8byte	.LVL1809
	.4byte	0x36c0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x62
	.4byte	.LASF713
	.byte	0x2
	.2byte	0x7dc
	.byte	0x1
	.4byte	0x4790
	.uleb128 0x4b
	.4byte	.LASF640
	.byte	0x2
	.2byte	0x7dc
	.4byte	0x1f04
	.uleb128 0x4c
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x7de
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF678
	.byte	0x2
	.2byte	0x677
	.4byte	0x5b
	.8byte	.LFB281
	.8byte	.LFE281-.LFB281
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4d8d
	.uleb128 0x53
	.4byte	.LASF614
	.byte	0x2
	.2byte	0x677
	.4byte	0x1f04
	.4byte	.LLST331
	.uleb128 0x55
	.4byte	.LASF679
	.byte	0x2
	.2byte	0x679
	.4byte	0xdc9
	.4byte	.LLST332
	.uleb128 0x55
	.4byte	.LASF680
	.byte	0x2
	.2byte	0x679
	.4byte	0xdc9
	.4byte	.LLST333
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x67a
	.4byte	0xdc9
	.4byte	.LLST334
	.uleb128 0x55
	.4byte	.LASF382
	.byte	0x2
	.2byte	0x67a
	.4byte	0xdc9
	.4byte	.LLST335
	.uleb128 0x55
	.4byte	.LASF380
	.byte	0x2
	.2byte	0x67a
	.4byte	0xdc9
	.4byte	.LLST336
	.uleb128 0x55
	.4byte	.LASF681
	.byte	0x2
	.2byte	0x67b
	.4byte	0xdc9
	.4byte	.LLST337
	.uleb128 0x55
	.4byte	.LASF682
	.byte	0x2
	.2byte	0x67b
	.4byte	0xdc9
	.4byte	.LLST338
	.uleb128 0x55
	.4byte	.LASF597
	.byte	0x2
	.2byte	0x67c
	.4byte	0xdc9
	.4byte	.LLST339
	.uleb128 0x55
	.4byte	.LASF683
	.byte	0x2
	.2byte	0x67d
	.4byte	0x5b
	.4byte	.LLST340
	.uleb128 0x55
	.4byte	.LASF684
	.byte	0x2
	.2byte	0x67d
	.4byte	0x5b
	.4byte	.LLST340
	.uleb128 0x55
	.4byte	.LASF569
	.byte	0x2
	.2byte	0x67e
	.4byte	0xdc9
	.4byte	.LLST342
	.uleb128 0x54
	.string	"n"
	.byte	0x2
	.2byte	0x67e
	.4byte	0xdc9
	.4byte	.LLST343
	.uleb128 0x54
	.string	"req"
	.byte	0x2
	.2byte	0x67e
	.4byte	0xdc9
	.4byte	.LLST344
	.uleb128 0x60
	.string	"lpa"
	.byte	0x2
	.2byte	0x67f
	.4byte	0xdd4
	.uleb128 0x1
	.byte	0x68
	.uleb128 0x2a
	.4byte	.LASF664
	.byte	0x2
	.2byte	0x67f
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x2a
	.4byte	.LASF625
	.byte	0x2
	.2byte	0x67f
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x2a
	.4byte	.LASF616
	.byte	0x2
	.2byte	0x67f
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF630
	.byte	0x2
	.2byte	0x680
	.4byte	0xdc9
	.4byte	.LLST345
	.uleb128 0x55
	.4byte	.LASF685
	.byte	0x2
	.2byte	0x680
	.4byte	0xdc9
	.4byte	.LLST346
	.uleb128 0x55
	.4byte	.LASF686
	.byte	0x2
	.2byte	0x681
	.4byte	0xdd4
	.4byte	.LLST347
	.uleb128 0x55
	.4byte	.LASF687
	.byte	0x2
	.2byte	0x682
	.4byte	0xdc9
	.4byte	.LLST348
	.uleb128 0x55
	.4byte	.LASF599
	.byte	0x2
	.2byte	0x683
	.4byte	0x2dff
	.4byte	.LLST349
	.uleb128 0x61
	.4byte	.LASF688
	.byte	0x2
	.2byte	0x684
	.4byte	0xdd4
	.byte	0
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4d9d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6924
	.uleb128 0x59
	.4byte	.LASF690
	.byte	0x2
	.2byte	0x713
	.8byte	.L1032
	.uleb128 0x59
	.4byte	.LASF620
	.byte	0x2
	.2byte	0x71b
	.8byte	.L1047
	.uleb128 0x59
	.4byte	.LASF691
	.byte	0x2
	.2byte	0x7ce
	.8byte	.L1053
	.uleb128 0x4e
	.4byte	.LASF692
	.byte	0x2
	.2byte	0x7d8
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x220
	.4byte	0x49b0
	.uleb128 0x55
	.4byte	.LASF693
	.byte	0x2
	.2byte	0x6eb
	.4byte	0xdd4
	.4byte	.LLST350
	.uleb128 0x55
	.4byte	.LASF694
	.byte	0x2
	.2byte	0x6ec
	.4byte	0xdd4
	.4byte	.LLST351
	.uleb128 0x36
	.8byte	.LVL1430
	.4byte	0x29a4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x250
	.4byte	0x4aab
	.uleb128 0x55
	.4byte	.LASF695
	.byte	0x2
	.2byte	0x746
	.4byte	0xdd4
	.4byte	.LLST352
	.uleb128 0x55
	.4byte	.LASF696
	.byte	0x2
	.2byte	0x747
	.4byte	0xdd4
	.4byte	.LLST353
	.uleb128 0x34
	.8byte	.LVL1473
	.4byte	0x29a4
	.4byte	0x49f5
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
	.8byte	.LVL1475
	.4byte	0x36c0
	.uleb128 0x34
	.8byte	.LVL1481
	.4byte	0x5c36
	.4byte	0x4a26
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
	.8byte	.LVL1484
	.4byte	0x6d22
	.4byte	0x4a41
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
	.8byte	.LVL1485
	.4byte	0x4da2
	.4byte	0x4a59
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1487
	.4byte	0x29a4
	.4byte	0x4a75
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
	.8byte	.LVL1490
	.4byte	0x6d22
	.4byte	0x4a8d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1491
	.4byte	0x6d22
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
	.8byte	.LBB275
	.8byte	.LBE275-.LBB275
	.4byte	0x4b35
	.uleb128 0x55
	.4byte	.LASF697
	.byte	0x2
	.2byte	0x785
	.4byte	0xdd4
	.4byte	.LLST354
	.uleb128 0x55
	.4byte	.LASF696
	.byte	0x2
	.2byte	0x786
	.4byte	0xdd4
	.4byte	.LLST355
	.uleb128 0x34
	.8byte	.LVL1499
	.4byte	0x29a4
	.4byte	0x4afc
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
	.8byte	.LVL1500
	.4byte	0x6d22
	.4byte	0x4b14
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1501
	.4byte	0x5c36
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
	.8byte	.LVL1378
	.4byte	0x6c45
	.4byte	0x4b4c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1383
	.4byte	0x29a4
	.4byte	0x4b69
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
	.8byte	.LVL1388
	.4byte	0x6db1
	.uleb128 0x34
	.8byte	.LVL1391
	.4byte	0x4ee3
	.4byte	0x4b9a
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
	.8byte	.LVL1399
	.4byte	0xa94d
	.4byte	0x4bcd
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
	.8byte	.LANCHOR161
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x6aa
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1400
	.4byte	0xa94d
	.4byte	0x4c00
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
	.8byte	.LANCHOR161
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x6ab
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1409
	.4byte	0x6d22
	.4byte	0x4c18
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1435
	.4byte	0x588f
	.4byte	0x4c37
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1438
	.4byte	0x29a4
	.4byte	0x4c54
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
	.8byte	.LVL1459
	.4byte	0x6db1
	.4byte	0x4c6e
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
	.8byte	.LVL1466
	.4byte	0x36c0
	.uleb128 0x34
	.8byte	.LVL1469
	.4byte	0x6d22
	.4byte	0x4c93
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1470
	.4byte	0x5c36
	.4byte	0x4cb7
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
	.8byte	.LVL1471
	.4byte	0x6d22
	.4byte	0x4ccf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1476
	.4byte	0x6d71
	.4byte	0x4ce9
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
	.8byte	.LVL1478
	.4byte	0xa94d
	.4byte	0x4d1c
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
	.8byte	.LANCHOR161
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x7a5
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1493
	.4byte	0x5c36
	.4byte	0x4d40
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
	.8byte	.LVL1494
	.4byte	0x6d71
	.4byte	0x4d5a
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
	.8byte	.LVL1503
	.4byte	0xa94d
	.4byte	0x4d7f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC99
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1505
	.4byte	0x36c0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x4d9d
	.uleb128 0xe
	.4byte	0xda
	.byte	0x15
	.byte	0
	.uleb128 0x7
	.4byte	0x4d8d
	.uleb128 0x5f
	.4byte	.LASF698
	.byte	0x2
	.2byte	0x65b
	.8byte	.LFB280
	.8byte	.LFE280-.LFB280
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4ee3
	.uleb128 0x5d
	.string	"lpa"
	.byte	0x2
	.2byte	0x65b
	.4byte	0xdd4
	.4byte	.LLST245
	.uleb128 0x53
	.4byte	.LASF664
	.byte	0x2
	.2byte	0x65b
	.4byte	0xdd4
	.4byte	.LLST246
	.uleb128 0x55
	.4byte	.LASF630
	.byte	0x2
	.2byte	0x65d
	.4byte	0xdc9
	.4byte	.LLST247
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x37ff
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6890
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x100
	.4byte	0x4ea7
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x661
	.4byte	0xdc9
	.4byte	.LLST248
	.uleb128 0x55
	.4byte	.LASF587
	.byte	0x2
	.2byte	0x662
	.4byte	0xdc9
	.4byte	.LLST249
	.uleb128 0x55
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x663
	.4byte	0xdc9
	.4byte	.LLST250
	.uleb128 0x34
	.8byte	.LVL944
	.4byte	0x6761
	.4byte	0x4e5f
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
	.8byte	.LVL945
	.4byte	0xa94d
	.4byte	0x4e92
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
	.2byte	0x667
	.byte	0
	.uleb128 0x36
	.8byte	.LVL946
	.4byte	0x6936
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL938
	.4byte	0x6d71
	.4byte	0x4ec2
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
	.8byte	.LVL948
	.4byte	0x5c36
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
	.4byte	.LASF699
	.byte	0x2
	.2byte	0x647
	.8byte	.LFB279
	.8byte	.LFE279-.LFB279
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4f40
	.uleb128 0x64
	.4byte	.LASF614
	.byte	0x2
	.2byte	0x647
	.4byte	0x1f04
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x53
	.4byte	.LASF380
	.byte	0x2
	.2byte	0x647
	.4byte	0xdc9
	.4byte	.LLST90
	.uleb128 0x53
	.4byte	.LASF382
	.byte	0x2
	.2byte	0x647
	.4byte	0xdc9
	.4byte	.LLST91
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x649
	.4byte	0xdc9
	.4byte	.LLST92
	.byte	0
	.uleb128 0x49
	.4byte	.LASF700
	.byte	0x2
	.2byte	0x63e
	.4byte	0x5b
	.8byte	.LFB278
	.8byte	.LFE278-.LFB278
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4f8b
	.uleb128 0x45
	.8byte	.LVL1108
	.4byte	0x4f8b
	.uleb128 0x36
	.8byte	.LVL1109
	.4byte	0x5023
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF701
	.byte	0x2
	.2byte	0x627
	.8byte	.LFB277
	.8byte	.LFE277-.LFB277
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4fe5
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x629
	.4byte	0xdc9
	.4byte	.LLST276
	.uleb128 0x34
	.8byte	.LVL1105
	.4byte	0x259f
	.4byte	0x4fd0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1106
	.4byte	0x259f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF702
	.byte	0x2
	.2byte	0x617
	.4byte	0x5b
	.8byte	.LFB276
	.8byte	.LFE276-.LFB276
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5023
	.uleb128 0x36
	.8byte	.LVL1104
	.4byte	0x5023
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR149
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF703
	.byte	0x2
	.2byte	0x5b9
	.4byte	0x5b
	.8byte	.LFB275
	.8byte	.LFE275-.LFB275
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x51f5
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x5b9
	.4byte	0x51f5
	.4byte	.LLST265
	.uleb128 0x55
	.4byte	.LASF705
	.byte	0x2
	.2byte	0x5bb
	.4byte	0xdea
	.4byte	.LLST266
	.uleb128 0x55
	.4byte	.LASF299
	.byte	0x2
	.2byte	0x5bb
	.4byte	0xdea
	.4byte	.LLST267
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x5bc
	.4byte	0xdea
	.4byte	.LLST268
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x5bd
	.4byte	0xdc9
	.4byte	.LLST269
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x5be
	.4byte	0x1001
	.4byte	.LLST270
	.uleb128 0x55
	.4byte	.LASF310
	.byte	0x2
	.2byte	0x5bf
	.4byte	0x10f8
	.4byte	.LLST271
	.uleb128 0x55
	.4byte	.LASF311
	.byte	0x2
	.2byte	0x5c0
	.4byte	0x1001
	.4byte	.LLST272
	.uleb128 0x55
	.4byte	.LASF307
	.byte	0x2
	.2byte	0x5c1
	.4byte	0xdc9
	.4byte	.LLST273
	.uleb128 0x55
	.4byte	.LASF708
	.byte	0x2
	.2byte	0x5c2
	.4byte	0xdc9
	.4byte	.LLST274
	.uleb128 0x55
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x5c3
	.4byte	0x51fb
	.4byte	.LLST275
	.uleb128 0x34
	.8byte	.LVL1064
	.4byte	0x259f
	.4byte	0x511b
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
	.8byte	.LVL1069
	.4byte	0x6c45
	.4byte	0x5132
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1074
	.4byte	0x635a
	.4byte	0x514a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1075
	.4byte	0x6302
	.4byte	0x5162
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1076
	.4byte	0x6188
	.4byte	0x517a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1077
	.4byte	0x6188
	.4byte	0x5192
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1085
	.4byte	0x29a4
	.4byte	0x51b4
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
	.8byte	.LVL1089
	.4byte	0x29a4
	.4byte	0x51d6
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
	.8byte	.LVL1091
	.4byte	0x29a4
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
	.4byte	.LASF710
	.byte	0x2
	.2byte	0x54f
	.4byte	0x5b
	.8byte	.LFB274
	.8byte	.LFE274-.LFB274
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x53e0
	.uleb128 0x55
	.4byte	.LASF706
	.byte	0x2
	.2byte	0x551
	.4byte	0xdea
	.4byte	.LLST463
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6827
	.uleb128 0x34
	.8byte	.LVL2075
	.4byte	0x259f
	.4byte	0x525d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2076
	.4byte	0x6c45
	.4byte	0x5274
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2078
	.4byte	0xa94d
	.4byte	0x52a7
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
	.8byte	.LANCHOR181
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x56c
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2079
	.4byte	0xa94d
	.4byte	0x52da
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
	.8byte	.LANCHOR181
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x56e
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2081
	.4byte	0x2527
	.4byte	0x52f8
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
	.8byte	.LVL2082
	.4byte	0x2527
	.uleb128 0x45
	.8byte	.LVL2083
	.4byte	0x2527
	.uleb128 0x34
	.8byte	.LVL2084
	.4byte	0xa94d
	.4byte	0x5345
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
	.8byte	.LANCHOR181
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x584
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2085
	.4byte	0x460e
	.4byte	0x5364
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR51
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2086
	.4byte	0x460e
	.4byte	0x5383
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR52
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2087
	.4byte	0x460e
	.4byte	0x53a2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR53
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2088
	.4byte	0x460e
	.4byte	0x53c1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR82
	.byte	0
	.uleb128 0x36
	.8byte	.LVL2090
	.4byte	0x29a4
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
	.4byte	.LASF711
	.byte	0x2
	.2byte	0x54a
	.4byte	0x5b
	.8byte	.LFB273
	.8byte	.LFE273-.LFB273
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5413
	.uleb128 0x53
	.4byte	.LASF712
	.byte	0x2
	.2byte	0x54a
	.4byte	0xdc9
	.4byte	.LLST89
	.byte	0
	.uleb128 0x62
	.4byte	.LASF714
	.byte	0x2
	.2byte	0x542
	.byte	0x1
	.4byte	0x5439
	.uleb128 0x4b
	.4byte	.LASF712
	.byte	0x2
	.2byte	0x542
	.4byte	0xdc9
	.uleb128 0x4b
	.4byte	.LASF591
	.byte	0x2
	.2byte	0x542
	.4byte	0x5b
	.byte	0
	.uleb128 0x52
	.4byte	.LASF716
	.byte	0x2
	.2byte	0x535
	.4byte	0x5b
	.byte	0x1
	.uleb128 0x49
	.4byte	.LASF717
	.byte	0x2
	.2byte	0x446
	.4byte	0x5b
	.8byte	.LFB270
	.8byte	.LFE270-.LFB270
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5694
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x2
	.2byte	0x448
	.4byte	0xdc9
	.4byte	.LLST258
	.uleb128 0x55
	.4byte	.LASF718
	.byte	0x2
	.2byte	0x448
	.4byte	0xdc9
	.4byte	.LLST259
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x449
	.4byte	0xdc9
	.4byte	.LLST260
	.uleb128 0x55
	.4byte	.LASF569
	.byte	0x2
	.2byte	0x449
	.4byte	0xdc9
	.4byte	.LLST261
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x44a
	.4byte	0xdea
	.4byte	.LLST262
	.uleb128 0x54
	.string	"j"
	.byte	0x2
	.2byte	0x44a
	.4byte	0xdea
	.4byte	.LLST263
	.uleb128 0x55
	.4byte	.LASF719
	.byte	0x2
	.2byte	0x44b
	.4byte	0x51fb
	.4byte	.LLST264
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4258
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6770
	.uleb128 0x34
	.8byte	.LVL986
	.4byte	0x259f
	.4byte	0x54fe
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL987
	.4byte	0x259f
	.4byte	0x5515
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL988
	.4byte	0x259f
	.4byte	0x552c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL989
	.4byte	0x259f
	.4byte	0x5543
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL990
	.4byte	0x259f
	.4byte	0x556d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR81
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
	.8byte	.LVL993
	.4byte	0x6e0c
	.4byte	0x5588
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
	.8byte	.LVL995
	.4byte	0x7560
	.4byte	0x55a0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1004
	.4byte	0x29a4
	.4byte	0x55bd
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
	.8byte	.LVL1009
	.4byte	0x29a4
	.4byte	0x55d9
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
	.8byte	.LVL1014
	.4byte	0x6afa
	.4byte	0x55f1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1015
	.4byte	0xa94d
	.4byte	0x561f
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
	.2byte	0x48a
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1026
	.4byte	0xa94d
	.4byte	0x564d
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
	.2byte	0x4b3
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1037
	.4byte	0x6afa
	.4byte	0x5664
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1039
	.4byte	0xa94d
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
	.2byte	0x530
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF720
	.byte	0x2
	.2byte	0x3eb
	.4byte	0x5b
	.8byte	.LFB269
	.8byte	.LFE269-.LFB269
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x583d
	.uleb128 0x55
	.4byte	.LASF300
	.byte	0x2
	.2byte	0x3ed
	.4byte	0xdc9
	.4byte	.LLST385
	.uleb128 0x55
	.4byte	.LASF721
	.byte	0x2
	.2byte	0x3ee
	.4byte	0x583d
	.4byte	.LLST386
	.uleb128 0x55
	.4byte	.LASF722
	.byte	0x2
	.2byte	0x3ef
	.4byte	0xdc9
	.4byte	.LLST387
	.uleb128 0x4e
	.4byte	.LASF723
	.byte	0x2
	.2byte	0x41c
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6748
	.uleb128 0x34
	.8byte	.LVL1665
	.4byte	0x259f
	.4byte	0x5719
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1666
	.4byte	0x2527
	.4byte	0x573e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR79
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1667
	.4byte	0x2527
	.uleb128 0x45
	.8byte	.LVL1668
	.4byte	0x2527
	.uleb128 0x34
	.8byte	.LVL1669
	.4byte	0x5944
	.4byte	0x5770
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1671
	.4byte	0x27e7
	.4byte	0x5797
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
	.8byte	.LVL1673
	.4byte	0x6980
	.uleb128 0x34
	.8byte	.LVL1674
	.4byte	0x27e7
	.4byte	0x57cb
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
	.8byte	.LVL1675
	.4byte	0xa94d
	.4byte	0x57fe
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
	.8byte	.LANCHOR167
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x433
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1678
	.4byte	0xa94d
	.4byte	0x5823
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC101
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1679
	.4byte	0x6afa
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
	.4byte	.LASF724
	.byte	0x2
	.2byte	0x3b2
	.byte	0x1
	.4byte	0x588f
	.uleb128 0x50
	.uleb128 0x4d
	.string	"lpa"
	.byte	0x2
	.2byte	0x3b7
	.4byte	0xdd4
	.uleb128 0x4d
	.string	"ppa"
	.byte	0x2
	.2byte	0x3b8
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF725
	.byte	0x2
	.2byte	0x3b9
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF668
	.byte	0x2
	.2byte	0x3ba
	.4byte	0xdf5
	.uleb128 0x4c
	.4byte	.LASF599
	.byte	0x2
	.2byte	0x3bb
	.4byte	0x2dff
	.byte	0
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF726
	.byte	0x2
	.2byte	0x380
	.8byte	.LFB267
	.8byte	.LFE267-.LFB267
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5944
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x380
	.4byte	0x51f5
	.4byte	.LLST254
	.uleb128 0x54
	.string	"ppa"
	.byte	0x2
	.2byte	0x382
	.4byte	0xdd4
	.4byte	.LLST255
	.uleb128 0x55
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x383
	.4byte	0xdc9
	.4byte	.LLST256
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x384
	.4byte	0x1001
	.4byte	.LLST257
	.uleb128 0x34
	.8byte	.LVL980
	.4byte	0x29a4
	.4byte	0x5916
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR108
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
	.8byte	.LVL982
	.4byte	0x5ea6
	.4byte	0x592f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.uleb128 0x36
	.8byte	.LVL984
	.4byte	0x259f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x62
	.4byte	.LASF727
	.byte	0x2
	.2byte	0x371
	.byte	0x1
	.4byte	0x5968
	.uleb128 0x4b
	.4byte	.LASF393
	.byte	0x2
	.2byte	0x371
	.4byte	0xdd4
	.uleb128 0x4d
	.string	"i"
	.byte	0x2
	.2byte	0x373
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF728
	.byte	0x2
	.2byte	0x35c
	.4byte	0x5b
	.8byte	.LFB265
	.8byte	.LFE265-.LFB265
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x59d0
	.uleb128 0x53
	.4byte	.LASF729
	.byte	0x2
	.2byte	0x35c
	.4byte	0xdd4
	.4byte	.LLST375
	.uleb128 0x55
	.4byte	.LASF730
	.byte	0x2
	.2byte	0x35e
	.4byte	0xdd4
	.4byte	.LLST376
	.uleb128 0x34
	.8byte	.LVL1627
	.4byte	0x5af8
	.4byte	0x59c2
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1628
	.4byte	0x44bf
	.byte	0
	.uleb128 0x49
	.4byte	.LASF731
	.byte	0x2
	.2byte	0x336
	.4byte	0xdd4
	.8byte	.LFB264
	.8byte	.LFE264-.LFB264
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5af2
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x2
	.2byte	0x336
	.4byte	0xdd4
	.4byte	.LLST377
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x2
	.2byte	0x336
	.4byte	0xdd4
	.4byte	.LLST378
	.uleb128 0x53
	.4byte	.LASF734
	.byte	0x2
	.2byte	0x336
	.4byte	0x5af2
	.4byte	.LLST379
	.uleb128 0x54
	.string	"len"
	.byte	0x2
	.2byte	0x338
	.4byte	0xdc9
	.4byte	.LLST380
	.uleb128 0x55
	.4byte	.LASF735
	.byte	0x2
	.2byte	0x338
	.4byte	0xdc9
	.4byte	.LLST381
	.uleb128 0x54
	.string	"ppn"
	.byte	0x2
	.2byte	0x339
	.4byte	0xdd4
	.4byte	.LLST382
	.uleb128 0x55
	.4byte	.LASF736
	.byte	0x2
	.2byte	0x33a
	.4byte	0xdd4
	.4byte	.LLST383
	.uleb128 0x60
	.string	"req"
	.byte	0x2
	.2byte	0x33b
	.4byte	0xdf5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x55
	.4byte	.LASF737
	.byte	0x2
	.2byte	0x33c
	.4byte	0xdd4
	.4byte	.LLST384
	.uleb128 0x2a
	.4byte	.LASF565
	.byte	0x2
	.2byte	0x33d
	.4byte	0x2711
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x34
	.8byte	.LVL1647
	.4byte	0x29a4
	.4byte	0x5ab4
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
	.8byte	.LVL1649
	.4byte	0x2527
	.4byte	0x5ad2
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
	.8byte	.LVL1656
	.4byte	0x259f
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
	.4byte	.LASF738
	.byte	0x2
	.2byte	0x311
	.4byte	0xdd4
	.8byte	.LFB263
	.8byte	.LFE263-.LFB263
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5c36
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x2
	.2byte	0x311
	.4byte	0xdd4
	.4byte	.LLST367
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x2
	.2byte	0x311
	.4byte	0xdd4
	.4byte	.LLST368
	.uleb128 0x53
	.4byte	.LASF734
	.byte	0x2
	.2byte	0x311
	.4byte	0x5af2
	.4byte	.LLST369
	.uleb128 0x54
	.string	"len"
	.byte	0x2
	.2byte	0x313
	.4byte	0xdc9
	.4byte	.LLST370
	.uleb128 0x55
	.4byte	.LASF735
	.byte	0x2
	.2byte	0x313
	.4byte	0xdc9
	.4byte	.LLST371
	.uleb128 0x54
	.string	"ppn"
	.byte	0x2
	.2byte	0x314
	.4byte	0xdd4
	.4byte	.LLST372
	.uleb128 0x55
	.4byte	.LASF736
	.byte	0x2
	.2byte	0x315
	.4byte	0xdd4
	.4byte	.LLST373
	.uleb128 0x60
	.string	"req"
	.byte	0x2
	.2byte	0x316
	.4byte	0xdf5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x55
	.4byte	.LASF737
	.byte	0x2
	.2byte	0x317
	.4byte	0xdd4
	.4byte	.LLST374
	.uleb128 0x2a
	.4byte	.LASF565
	.byte	0x2
	.2byte	0x318
	.4byte	0x2711
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x34
	.8byte	.LVL1608
	.4byte	0x29a4
	.4byte	0x5bdc
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
	.8byte	.LVL1610
	.4byte	0x2527
	.4byte	0x5bfd
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
	.8byte	.LVL1614
	.4byte	0x5ea6
	.4byte	0x5c22
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
	.8byte	.LVL1619
	.4byte	0x259f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF739
	.byte	0x2
	.2byte	0x2f0
	.4byte	0x5b
	.8byte	.LFB262
	.8byte	.LFE262-.LFB262
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5d4e
	.uleb128 0x5d
	.string	"lpn"
	.byte	0x2
	.2byte	0x2f0
	.4byte	0xdd4
	.4byte	.LLST239
	.uleb128 0x5d
	.string	"ppn"
	.byte	0x2
	.2byte	0x2f0
	.4byte	0x1001
	.4byte	.LLST240
	.uleb128 0x53
	.4byte	.LASF740
	.byte	0x2
	.2byte	0x2f0
	.4byte	0x5b
	.4byte	.LLST241
	.uleb128 0x55
	.4byte	.LASF741
	.byte	0x2
	.2byte	0x2f2
	.4byte	0xdc9
	.4byte	.LLST242
	.uleb128 0x55
	.4byte	.LASF742
	.byte	0x2
	.2byte	0x2f2
	.4byte	0xdc9
	.4byte	.LLST243
	.uleb128 0x55
	.4byte	.LASF743
	.byte	0x2
	.2byte	0x2f2
	.4byte	0xdc9
	.4byte	.LLST244
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x5d5e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6675
	.uleb128 0x59
	.4byte	.LASF744
	.byte	0x2
	.2byte	0x2fb
	.8byte	.L657
	.uleb128 0x34
	.8byte	.LVL922
	.4byte	0xa94d
	.4byte	0x5d0e
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
	.2byte	0x2f7
	.byte	0
	.uleb128 0x45
	.8byte	.LVL925
	.4byte	0x5db5
	.uleb128 0x34
	.8byte	.LVL927
	.4byte	0x5e48
	.4byte	0x5d33
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL928
	.4byte	0x643d
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
	.4byte	0x5d5e
	.uleb128 0xe
	.4byte	0xda
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.4byte	0x5d4e
	.uleb128 0x49
	.4byte	.LASF745
	.byte	0x2
	.2byte	0x2e3
	.4byte	0x5b
	.8byte	.LFB261
	.8byte	.LFE261-.LFB261
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5db5
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x2e5
	.4byte	0xdc9
	.4byte	.LLST330
	.uleb128 0x45
	.8byte	.LVL1363
	.4byte	0x5843
	.uleb128 0x36
	.8byte	.LVL1366
	.4byte	0x5e48
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF746
	.byte	0x2
	.2byte	0x2bb
	.4byte	0xdc9
	.8byte	.LFB260
	.8byte	.LFE260-.LFB260
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5e48
	.uleb128 0x54
	.string	"i"
	.byte	0x2
	.2byte	0x2bd
	.4byte	0xdc9
	.4byte	.LLST83
	.uleb128 0x55
	.4byte	.LASF747
	.byte	0x2
	.2byte	0x2be
	.4byte	0xdc9
	.4byte	.LLST84
	.uleb128 0x55
	.4byte	.LASF748
	.byte	0x2
	.2byte	0x2bf
	.4byte	0xdd4
	.4byte	.LLST85
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4d9d
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6658
	.uleb128 0x36
	.8byte	.LVL237
	.4byte	0xa94d
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
	.8byte	.LANCHOR58
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2df
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF749
	.byte	0x2
	.2byte	0x2b1
	.4byte	0x5b
	.8byte	.LFB259
	.8byte	.LFE259-.LFB259
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5ea6
	.uleb128 0x53
	.4byte	.LASF741
	.byte	0x2
	.2byte	0x2b1
	.4byte	0xdc9
	.4byte	.LLST237
	.uleb128 0x55
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x2b3
	.4byte	0xdd4
	.4byte	.LLST238
	.uleb128 0x36
	.8byte	.LVL915
	.4byte	0x5ea6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF750
	.byte	0x2
	.2byte	0x276
	.4byte	0x5b
	.8byte	.LFB258
	.8byte	.LFE258-.LFB258
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6037
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x276
	.4byte	0x51f5
	.4byte	.LLST224
	.uleb128 0x53
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x276
	.4byte	0xdd4
	.4byte	.LLST225
	.uleb128 0x53
	.4byte	.LASF734
	.byte	0x2
	.2byte	0x276
	.4byte	0x1001
	.4byte	.LLST226
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x278
	.4byte	0xdd4
	.4byte	.LLST227
	.uleb128 0x55
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x279
	.4byte	0x51fb
	.4byte	.LLST228
	.uleb128 0x55
	.4byte	.LASF722
	.byte	0x2
	.2byte	0x27a
	.4byte	0xdc9
	.4byte	.LLST229
	.uleb128 0x4e
	.4byte	.LASF751
	.byte	0x2
	.2byte	0x27c
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x37ff
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6633
	.uleb128 0x34
	.8byte	.LVL873
	.4byte	0x6037
	.4byte	0x5f5b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL874
	.4byte	0xa94d
	.4byte	0x5f87
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
	.2byte	0x28a
	.byte	0
	.uleb128 0x34
	.8byte	.LVL875
	.4byte	0xa94d
	.4byte	0x5fb3
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
	.2byte	0x28b
	.byte	0
	.uleb128 0x34
	.8byte	.LVL877
	.4byte	0x259f
	.4byte	0x5fcf
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
	.8byte	.LVL880
	.4byte	0x27e7
	.4byte	0x5ff6
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
	.8byte	.LVL882
	.4byte	0xa94d
	.4byte	0x6015
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC86
	.byte	0
	.uleb128 0x36
	.8byte	.LVL883
	.4byte	0xa94d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC87
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF752
	.byte	0x2
	.2byte	0x246
	.4byte	0x5b
	.8byte	.LFB257
	.8byte	.LFE257-.LFB257
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6173
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x246
	.4byte	0x51f5
	.4byte	.LLST218
	.uleb128 0x4c
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x248
	.4byte	0xdc9
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x248
	.4byte	0xdc9
	.4byte	.LLST219
	.uleb128 0x55
	.4byte	.LASF753
	.byte	0x2
	.2byte	0x249
	.4byte	0xdc9
	.4byte	.LLST220
	.uleb128 0x55
	.4byte	.LASF754
	.byte	0x2
	.2byte	0x24a
	.4byte	0x10f8
	.4byte	.LLST221
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x24b
	.4byte	0x1001
	.4byte	.LLST222
	.uleb128 0x55
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x24c
	.4byte	0x51fb
	.4byte	.LLST223
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x6183
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6619
	.uleb128 0x34
	.8byte	.LVL852
	.4byte	0xa94d
	.4byte	0x610b
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
	.2byte	0x250
	.byte	0
	.uleb128 0x45
	.8byte	.LVL853
	.4byte	0x6980
	.uleb128 0x34
	.8byte	.LVL860
	.4byte	0x259f
	.4byte	0x6130
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL864
	.4byte	0x27e7
	.4byte	0x615e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR108
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
	.8byte	.LVL865
	.4byte	0x6188
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
	.4byte	0x6183
	.uleb128 0xe
	.4byte	0xda
	.byte	0x1e
	.byte	0
	.uleb128 0x7
	.4byte	0x6173
	.uleb128 0x49
	.4byte	.LASF755
	.byte	0x2
	.2byte	0x218
	.4byte	0x5b
	.8byte	.LFB256
	.8byte	.LFE256-.LFB256
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6302
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x218
	.4byte	0x51f5
	.4byte	.LLST230
	.uleb128 0x55
	.4byte	.LASF756
	.byte	0x2
	.2byte	0x21a
	.4byte	0xdc9
	.4byte	.LLST231
	.uleb128 0x55
	.4byte	.LASF757
	.byte	0x2
	.2byte	0x21b
	.4byte	0xdc9
	.4byte	.LLST232
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x21c
	.4byte	0xdc9
	.4byte	.LLST233
	.uleb128 0x55
	.4byte	.LASF754
	.byte	0x2
	.2byte	0x21d
	.4byte	0x10f8
	.4byte	.LLST234
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x21e
	.4byte	0x1001
	.4byte	.LLST235
	.uleb128 0x55
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x21f
	.4byte	0x51fb
	.4byte	.LLST236
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6605
	.uleb128 0x34
	.8byte	.LVL892
	.4byte	0x635a
	.4byte	0x6245
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL895
	.4byte	0x6302
	.4byte	0x625d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL897
	.4byte	0x6afa
	.4byte	0x627a
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
	.8byte	.LVL899
	.4byte	0x6302
	.4byte	0x6292
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL904
	.4byte	0x29a4
	.4byte	0x62bb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR108
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
	.8byte	.LVL905
	.4byte	0xa94d
	.4byte	0x62e7
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
	.2byte	0x234
	.byte	0
	.uleb128 0x36
	.8byte	.LVL910
	.4byte	0x5ea6
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
	.4byte	.LASF758
	.byte	0x2
	.2byte	0x203
	.4byte	0x5b
	.byte	0x1
	.4byte	0x6345
	.uleb128 0x4b
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x203
	.4byte	0x51f5
	.uleb128 0x4c
	.4byte	.LASF759
	.byte	0x2
	.2byte	0x205
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF754
	.byte	0x2
	.2byte	0x206
	.4byte	0x10f8
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x6355
	.4byte	.LASF758
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x6355
	.uleb128 0xe
	.4byte	0xda
	.byte	0x19
	.byte	0
	.uleb128 0x7
	.4byte	0x6345
	.uleb128 0x49
	.4byte	.LASF760
	.byte	0x2
	.2byte	0x1db
	.4byte	0x5b
	.8byte	.LFB254
	.8byte	.LFE254-.LFB254
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x643d
	.uleb128 0x53
	.4byte	.LASF704
	.byte	0x2
	.2byte	0x1db
	.4byte	0x51f5
	.4byte	.LLST209
	.uleb128 0x55
	.4byte	.LASF754
	.byte	0x2
	.2byte	0x1dd
	.4byte	0x10f8
	.4byte	.LLST210
	.uleb128 0x55
	.4byte	.LASF707
	.byte	0x2
	.2byte	0x1de
	.4byte	0x1001
	.4byte	.LLST211
	.uleb128 0x55
	.4byte	.LASF761
	.byte	0x2
	.2byte	0x1df
	.4byte	0x10f8
	.4byte	.LLST212
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x2
	.2byte	0x1e0
	.4byte	0xdc9
	.4byte	.LLST213
	.uleb128 0x55
	.4byte	.LASF330
	.byte	0x2
	.2byte	0x1e0
	.4byte	0xdc9
	.4byte	.LLST214
	.uleb128 0x55
	.4byte	.LASF759
	.byte	0x2
	.2byte	0x1e1
	.4byte	0xdc9
	.4byte	.LLST215
	.uleb128 0x55
	.4byte	.LASF762
	.byte	0x2
	.2byte	0x1e2
	.4byte	0xdc9
	.4byte	.LLST216
	.uleb128 0x55
	.4byte	.LASF757
	.byte	0x2
	.2byte	0x1e3
	.4byte	0xdc9
	.4byte	.LLST217
	.uleb128 0x34
	.8byte	.LVL829
	.4byte	0x259f
	.4byte	0x6429
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
	.8byte	.LVL846
	.4byte	0x6afa
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF763
	.byte	0x2
	.2byte	0x1b9
	.4byte	0x5b
	.8byte	.LFB253
	.8byte	.LFE253-.LFB253
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x65c5
	.uleb128 0x53
	.4byte	.LASF317
	.byte	0x2
	.2byte	0x1b9
	.4byte	0xdc9
	.4byte	.LLST206
	.uleb128 0x53
	.4byte	.LASF741
	.byte	0x2
	.2byte	0x1b9
	.4byte	0xdc9
	.4byte	.LLST207
	.uleb128 0x2a
	.4byte	.LASF709
	.byte	0x2
	.2byte	0x1bb
	.4byte	0x51fb
	.uleb128 0x1
	.byte	0x69
	.uleb128 0x55
	.4byte	.LASF764
	.byte	0x2
	.2byte	0x1bc
	.4byte	0xdd4
	.4byte	.LLST208
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x37ff
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6562
	.uleb128 0x34
	.8byte	.LVL813
	.4byte	0xa94d
	.4byte	0x64e3
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
	.2byte	0x1be
	.byte	0
	.uleb128 0x34
	.8byte	.LVL816
	.4byte	0x259f
	.4byte	0x64fb
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL820
	.4byte	0x29a4
	.4byte	0x651d
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
	.8byte	.LVL822
	.4byte	0xa94d
	.4byte	0x6548
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC83
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
	.8byte	.LVL823
	.4byte	0x2b1c
	.4byte	0x6571
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC84
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
	.8byte	.LVL824
	.4byte	0x2b1c
	.4byte	0x6595
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC85
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x34
	.byte	0
	.uleb128 0x36
	.8byte	.LVL825
	.4byte	0xa94d
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
	.2byte	0x1d3
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF765
	.byte	0x2
	.2byte	0x193
	.4byte	0x5b
	.byte	0x1
	.4byte	0x6644
	.uleb128 0x4b
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x193
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF766
	.byte	0x2
	.2byte	0x195
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF767
	.byte	0x2
	.2byte	0x196
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF768
	.byte	0x2
	.2byte	0x197
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF769
	.byte	0x2
	.2byte	0x199
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF770
	.byte	0x2
	.2byte	0x19a
	.4byte	0xdd4
	.uleb128 0x4c
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x19b
	.4byte	0x1e2c
	.uleb128 0x4c
	.4byte	.LASF771
	.byte	0x2
	.2byte	0x19b
	.4byte	0x1e2c
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x4d9d
	.4byte	.LASF765
	.byte	0
	.uleb128 0x49
	.4byte	.LASF772
	.byte	0x2
	.2byte	0x17f
	.4byte	0x5b
	.8byte	.LFB251
	.8byte	.LFE251-.LFB251
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6697
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x17f
	.4byte	0xdc9
	.4byte	.LLST67
	.uleb128 0x55
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x181
	.4byte	0xdc9
	.4byte	.LLST68
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x182
	.4byte	0x1e2c
	.4byte	.LLST69
	.byte	0
	.uleb128 0x49
	.4byte	.LASF773
	.byte	0x2
	.2byte	0x17a
	.4byte	0x5b
	.8byte	.LFB250
	.8byte	.LFE250-.LFB250
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x66e4
	.uleb128 0x53
	.4byte	.LASF774
	.byte	0x2
	.2byte	0x17a
	.4byte	0x66e4
	.4byte	.LLST66
	.uleb128 0x2f
	.8byte	.LVL187
	.4byte	0x66ea
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
	.4byte	0x1e2c
	.uleb128 0x49
	.4byte	.LASF775
	.byte	0x2
	.2byte	0x167
	.4byte	0x5b
	.8byte	.LFB249
	.8byte	.LFE249-.LFB249
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6761
	.uleb128 0x53
	.4byte	.LASF774
	.byte	0x2
	.2byte	0x167
	.4byte	0x66e4
	.4byte	.LLST62
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x2
	.2byte	0x167
	.4byte	0xdc9
	.4byte	.LLST63
	.uleb128 0x55
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x169
	.4byte	0xdc9
	.4byte	.LLST64
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x16a
	.4byte	0x1e2c
	.4byte	.LLST65
	.uleb128 0x36
	.8byte	.LVL178
	.4byte	0x6761
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF776
	.byte	0x2
	.2byte	0x14c
	.4byte	0x5b
	.8byte	.LFB248
	.8byte	.LFE248-.LFB248
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6806
	.uleb128 0x53
	.4byte	.LASF774
	.byte	0x2
	.2byte	0x14c
	.4byte	0x66e4
	.4byte	.LLST58
	.uleb128 0x53
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x14c
	.4byte	0xdc9
	.4byte	.LLST59
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x14e
	.4byte	0x1e2c
	.4byte	.LLST60
	.uleb128 0x55
	.4byte	.LASF777
	.byte	0x2
	.2byte	0x14e
	.4byte	0x1e2c
	.4byte	.LLST61
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x6816
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6521
	.uleb128 0x36
	.8byte	.LVL164
	.4byte	0xa94d
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
	.2byte	0x151
	.byte	0
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x6816
	.uleb128 0xe
	.4byte	0xda
	.byte	0x10
	.byte	0
	.uleb128 0x7
	.4byte	0x6806
	.uleb128 0x49
	.4byte	.LASF778
	.byte	0x2
	.2byte	0x11b
	.4byte	0x5b
	.8byte	.LFB247
	.8byte	.LFE247-.LFB247
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x689c
	.uleb128 0x53
	.4byte	.LASF650
	.byte	0x2
	.2byte	0x11b
	.4byte	0xdc9
	.4byte	.LLST51
	.uleb128 0x55
	.4byte	.LASF653
	.byte	0x2
	.2byte	0x11d
	.4byte	0x1e2c
	.4byte	.LLST52
	.uleb128 0x55
	.4byte	.LASF777
	.byte	0x2
	.2byte	0x11d
	.4byte	0x1e2c
	.4byte	.LLST53
	.uleb128 0x2a
	.4byte	.LASF779
	.byte	0x2
	.2byte	0x11e
	.4byte	0xdc9
	.uleb128 0x1
	.byte	0x5d
	.uleb128 0x55
	.4byte	.LASF780
	.byte	0x2
	.2byte	0x11f
	.4byte	0xdc9
	.4byte	.LLST54
	.uleb128 0x55
	.4byte	.LASF781
	.byte	0x2
	.2byte	0x120
	.4byte	0xdc9
	.4byte	.LLST55
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF782
	.byte	0x2
	.byte	0xd8
	.4byte	0x5b
	.8byte	.LFB246
	.8byte	.LFE246-.LFB246
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6936
	.uleb128 0x2e
	.4byte	.LASF650
	.byte	0x2
	.byte	0xd8
	.4byte	0xdc9
	.4byte	.LLST41
	.uleb128 0x32
	.4byte	.LASF653
	.byte	0x2
	.byte	0xda
	.4byte	0x1e2c
	.4byte	.LLST42
	.uleb128 0x32
	.4byte	.LASF777
	.byte	0x2
	.byte	0xda
	.4byte	0x1e2c
	.4byte	.LLST43
	.uleb128 0x32
	.4byte	.LASF783
	.byte	0x2
	.byte	0xdb
	.4byte	0xdc9
	.4byte	.LLST44
	.uleb128 0x32
	.4byte	.LASF784
	.byte	0x2
	.byte	0xdc
	.4byte	0xdc9
	.4byte	.LLST45
	.uleb128 0x32
	.4byte	.LASF768
	.byte	0x2
	.byte	0xdd
	.4byte	0xdd4
	.4byte	.LLST46
	.uleb128 0x32
	.4byte	.LASF785
	.byte	0x2
	.byte	0xde
	.4byte	0xdd4
	.4byte	.LLST47
	.uleb128 0x32
	.4byte	.LASF781
	.byte	0x2
	.byte	0xdf
	.4byte	0xdc9
	.4byte	.LLST48
	.byte	0
	.uleb128 0x65
	.4byte	.LASF786
	.byte	0x2
	.byte	0xb9
	.byte	0x1
	.4byte	0x695b
	.uleb128 0x38
	.4byte	.LASF650
	.byte	0x2
	.byte	0xb9
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x6816
	.4byte	.LASF786
	.byte	0
	.uleb128 0x65
	.4byte	.LASF787
	.byte	0x2
	.byte	0xb2
	.byte	0x1
	.4byte	0x6980
	.uleb128 0x38
	.4byte	.LASF650
	.byte	0x2
	.byte	0xb2
	.4byte	0xdc9
	.uleb128 0x4f
	.4byte	.LASF574
	.4byte	0x6816
	.4byte	.LASF787
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF788
	.byte	0x2
	.byte	0xa4
	.4byte	0xdc9
	.8byte	.LFB243
	.8byte	.LFE243-.LFB243
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x69eb
	.uleb128 0x33
	.string	"tmp"
	.byte	0x2
	.byte	0xa6
	.4byte	0xdc9
	.4byte	.LLST39
	.uleb128 0x63
	.8byte	.LBB176
	.8byte	.LBE176-.LBB176
	.4byte	0x69d3
	.uleb128 0x33
	.string	"Q"
	.byte	0x2
	.byte	0xa9
	.4byte	0x69eb
	.4byte	.LLST40
	.byte	0
	.uleb128 0x66
	.4byte	0x6bcd
	.8byte	.LBB174
	.8byte	.LBE174-.LBB174
	.byte	0x2
	.byte	0xa8
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x15a4
	.uleb128 0x2d
	.4byte	.LASF789
	.byte	0x2
	.byte	0x92
	.4byte	0x5b
	.8byte	.LFB242
	.8byte	.LFE242-.LFB242
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6a65
	.uleb128 0x31
	.string	"blk"
	.byte	0x2
	.byte	0x92
	.4byte	0xdc9
	.4byte	.LLST36
	.uleb128 0x33
	.string	"ret"
	.byte	0x2
	.byte	0x94
	.4byte	0x5b
	.4byte	.LLST37
	.uleb128 0x33
	.string	"i"
	.byte	0x2
	.byte	0x95
	.4byte	0xdd4
	.4byte	.LLST38
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0x96
	.4byte	0x69eb
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x67
	.4byte	0x6bc1
	.8byte	.LBB170
	.4byte	.Ldebug_ranges0+0x30
	.byte	0x2
	.byte	0x98
	.byte	0
	.uleb128 0x43
	.4byte	.LASF790
	.byte	0x2
	.byte	0x73
	.8byte	.LFB241
	.8byte	.LFE241-.LFB241
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6afa
	.uleb128 0x33
	.string	"i"
	.byte	0x2
	.byte	0x75
	.4byte	0xdc9
	.4byte	.LLST30
	.uleb128 0x33
	.string	"tmp"
	.byte	0x2
	.byte	0x75
	.4byte	0xdc9
	.4byte	.LLST31
	.uleb128 0x33
	.string	"j"
	.byte	0x2
	.byte	0x75
	.4byte	0xdc9
	.4byte	.LLST32
	.uleb128 0x32
	.4byte	.LASF602
	.byte	0x2
	.byte	0x76
	.4byte	0xdc9
	.4byte	.LLST33
	.uleb128 0x32
	.4byte	.LASF791
	.byte	0x2
	.byte	0x77
	.4byte	0xdc9
	.4byte	.LLST34
	.uleb128 0x32
	.4byte	.LASF792
	.byte	0x2
	.byte	0x78
	.4byte	0xdd4
	.4byte	.LLST35
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0x79
	.4byte	0x69eb
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x45
	.8byte	.LVL79
	.4byte	0x6d71
	.byte	0
	.uleb128 0x43
	.4byte	.LASF793
	.byte	0x2
	.byte	0x61
	.8byte	.LFB240
	.8byte	.LFE240-.LFB240
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6bc1
	.uleb128 0x31
	.string	"blk"
	.byte	0x2
	.byte	0x61
	.4byte	0xdc9
	.4byte	.LLST184
	.uleb128 0x2e
	.4byte	.LASF794
	.byte	0x2
	.byte	0x61
	.4byte	0xdc9
	.4byte	.LLST185
	.uleb128 0x63
	.8byte	.LBB223
	.8byte	.LBE223-.LBB223
	.4byte	0x6ba9
	.uleb128 0x33
	.string	"Q"
	.byte	0x2
	.byte	0x64
	.4byte	0x69eb
	.4byte	.LLST186
	.uleb128 0x68
	.8byte	.LBB224
	.8byte	.LBE224-.LBB224
	.uleb128 0x32
	.4byte	.LASF795
	.byte	0x2
	.byte	0x66
	.4byte	0xdc9
	.4byte	.LLST187
	.uleb128 0x34
	.8byte	.LVL681
	.4byte	0x6d71
	.4byte	0x6b8f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL684
	.4byte	0x2721
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
	.uleb128 0x66
	.4byte	0x6bc1
	.8byte	.LBB221
	.8byte	.LBE221-.LBB221
	.byte	0x2
	.byte	0x63
	.byte	0
	.uleb128 0x69
	.4byte	.LASF796
	.byte	0x2
	.byte	0x5c
	.4byte	0xdc9
	.byte	0x1
	.uleb128 0x69
	.4byte	.LASF797
	.byte	0x2
	.byte	0x57
	.4byte	0xdc9
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF798
	.byte	0x2
	.byte	0x4b
	.4byte	0xdc9
	.8byte	.LFB237
	.8byte	.LFE237-.LFB237
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6c45
	.uleb128 0x31
	.string	"max"
	.byte	0x2
	.byte	0x4b
	.4byte	0xdc9
	.4byte	.LLST205
	.uleb128 0x3d
	.string	"Q"
	.byte	0x2
	.byte	0x4d
	.4byte	0x69eb
	.uleb128 0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.uleb128 0x36
	.8byte	.LVL809
	.4byte	0x259f
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
	.4byte	.LASF799
	.byte	0x2
	.byte	0x2e
	.4byte	0x5b
	.8byte	.LFB236
	.8byte	.LFE236-.LFB236
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6d22
	.uleb128 0x2e
	.4byte	.LASF388
	.byte	0x2
	.byte	0x2e
	.4byte	0xdd4
	.4byte	.LLST163
	.uleb128 0x2e
	.4byte	.LASF568
	.byte	0x2
	.byte	0x2e
	.4byte	0x5b
	.4byte	.LLST164
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
	.4byte	.LLST165
	.uleb128 0x32
	.4byte	.LASF800
	.byte	0x2
	.byte	0x31
	.4byte	0xdea
	.4byte	.LLST166
	.uleb128 0x33
	.string	"mid"
	.byte	0x2
	.byte	0x31
	.4byte	0xdea
	.4byte	.LLST167
	.uleb128 0x2b
	.4byte	.LASF801
	.byte	0x2
	.byte	0x32
	.4byte	0x2711
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x32
	.4byte	.LASF802
	.byte	0x2
	.byte	0x33
	.4byte	0xdc9
	.4byte	.LLST168
	.uleb128 0x34
	.8byte	.LVL626
	.4byte	0x29a4
	.4byte	0x6d01
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
	.8byte	.LVL635
	.4byte	0x29a4
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
	.4byte	.LASF803
	.byte	0x2
	.byte	0x1e
	.4byte	0xdd4
	.8byte	.LFB235
	.8byte	.LFE235-.LFB235
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6d71
	.uleb128 0x2e
	.4byte	.LASF804
	.byte	0x2
	.byte	0x1e
	.4byte	0xdd4
	.4byte	.LLST27
	.uleb128 0x2e
	.4byte	.LASF805
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
	.4byte	.LASF806
	.byte	0x2
	.byte	0x14
	.4byte	0xdc9
	.8byte	.LFB234
	.8byte	.LFE234-.LFB234
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6db1
	.uleb128 0x2e
	.4byte	.LASF597
	.byte	0x2
	.byte	0x14
	.4byte	0xdc9
	.4byte	.LLST25
	.uleb128 0x32
	.4byte	.LASF718
	.byte	0x2
	.byte	0x16
	.4byte	0xdc9
	.4byte	.LLST26
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF807
	.byte	0x2
	.byte	0xc
	.4byte	0xdc9
	.8byte	.LFB233
	.8byte	.LFE233-.LFB233
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6e0c
	.uleb128 0x2e
	.4byte	.LASF597
	.byte	0x2
	.byte	0xc
	.4byte	0xdc9
	.4byte	.LLST24
	.uleb128 0x2b
	.4byte	.LASF595
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
	.4byte	.LASF808
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.8byte	.LFB232
	.8byte	.LFE232-.LFB232
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x6e59
	.uleb128 0x2e
	.4byte	.LASF595
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.4byte	.LLST22
	.uleb128 0x5c
	.4byte	.LASF718
	.byte	0x2
	.byte	0x4
	.4byte	0xdc9
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x32
	.4byte	.LASF587
	.byte	0x2
	.byte	0x6
	.4byte	0xdc9
	.4byte	.LLST23
	.byte	0
	.uleb128 0x49
	.4byte	.LASF809
	.byte	0x4
	.2byte	0x13c
	.4byte	0xddf
	.8byte	.LFB231
	.8byte	.LFE231-.LFB231
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x70a4
	.uleb128 0x54
	.string	"die"
	.byte	0x4
	.2byte	0x13e
	.4byte	0xdd4
	.4byte	.LLST363
	.uleb128 0x54
	.string	"blk"
	.byte	0x4
	.2byte	0x13f
	.4byte	0xdc9
	.4byte	.LLST364
	.uleb128 0x55
	.4byte	.LASF577
	.byte	0x4
	.2byte	0x140
	.4byte	0xdd4
	.4byte	.LLST365
	.uleb128 0x55
	.4byte	.LASF810
	.byte	0x4
	.2byte	0x142
	.4byte	0x70a4
	.4byte	.LLST366
	.uleb128 0x4e
	.4byte	.LASF811
	.byte	0x4
	.2byte	0x158
	.uleb128 0x45
	.8byte	.LVL1547
	.4byte	0x72fe
	.uleb128 0x45
	.8byte	.LVL1548
	.4byte	0x70aa
	.uleb128 0x34
	.8byte	.LVL1554
	.4byte	0x7560
	.4byte	0x6ef5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1555
	.4byte	0x26cd
	.4byte	0x6f0d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1556
	.4byte	0x75ef
	.4byte	0x6f25
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1562
	.4byte	0x29a4
	.4byte	0x6f47
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
	.8byte	.LVL1563
	.4byte	0x2527
	.uleb128 0x34
	.8byte	.LVL1565
	.4byte	0x75ef
	.4byte	0x6f6c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1567
	.4byte	0x2611
	.4byte	0x6f84
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1568
	.4byte	0x74bc
	.uleb128 0x45
	.8byte	.LVL1570
	.4byte	0x7560
	.uleb128 0x34
	.8byte	.LVL1571
	.4byte	0x259f
	.4byte	0x6fba
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
	.8byte	.LVL1572
	.4byte	0x259f
	.4byte	0x6fd8
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
	.8byte	.LVL1574
	.4byte	0x2527
	.uleb128 0x34
	.8byte	.LVL1575
	.4byte	0x2721
	.4byte	0x7007
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
	.8byte	.LVL1576
	.4byte	0x27e7
	.4byte	0x702e
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
	.8byte	.LVL1577
	.4byte	0x75ef
	.4byte	0x7046
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1583
	.4byte	0x75ef
	.uleb128 0x34
	.8byte	.LVL1587
	.4byte	0x2721
	.4byte	0x706f
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
	.8byte	.LVL1588
	.4byte	0x75ef
	.uleb128 0x45
	.8byte	.LVL1589
	.4byte	0x75ef
	.uleb128 0x45
	.8byte	.LVL1590
	.4byte	0x7342
	.uleb128 0x45
	.8byte	.LVL1592
	.4byte	0x7342
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0x11c8
	.uleb128 0x49
	.4byte	.LASF812
	.byte	0x4
	.2byte	0x116
	.4byte	0x5b
	.8byte	.LFB230
	.8byte	.LFE230-.LFB230
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7127
	.uleb128 0x54
	.string	"die"
	.byte	0x4
	.2byte	0x118
	.4byte	0xdd4
	.4byte	.LLST160
	.uleb128 0x54
	.string	"blk"
	.byte	0x4
	.2byte	0x119
	.4byte	0xdc9
	.4byte	.LLST161
	.uleb128 0x4c
	.4byte	.LASF813
	.byte	0x4
	.2byte	0x11a
	.4byte	0xdd4
	.uleb128 0x55
	.4byte	.LASF810
	.byte	0x4
	.2byte	0x11b
	.4byte	0x70a4
	.4byte	.LLST162
	.uleb128 0x36
	.8byte	.LVL616
	.4byte	0x29a4
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
	.4byte	.LASF814
	.byte	0x4
	.byte	0xac
	.4byte	0x5b
	.8byte	.LFB229
	.8byte	.LFE229-.LFB229
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7295
	.uleb128 0x33
	.string	"i"
	.byte	0x4
	.byte	0xae
	.4byte	0xdd4
	.4byte	.LLST359
	.uleb128 0x33
	.string	"blk"
	.byte	0x4
	.byte	0xaf
	.4byte	0xdc9
	.4byte	.LLST360
	.uleb128 0x32
	.4byte	.LASF706
	.byte	0x4
	.byte	0xb0
	.4byte	0xdea
	.4byte	.LLST361
	.uleb128 0x32
	.4byte	.LASF810
	.byte	0x4
	.byte	0xb1
	.4byte	0x70a4
	.4byte	.LLST362
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x72a5
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6363
	.uleb128 0x45
	.8byte	.LVL1523
	.4byte	0x72fe
	.uleb128 0x34
	.8byte	.LVL1525
	.4byte	0x29a4
	.4byte	0x71c4
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
	.8byte	.LVL1526
	.4byte	0x29a4
	.4byte	0x71e6
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
	.4byte	0x29a4
	.4byte	0x720f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR108
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
	.8byte	.LVL1529
	.4byte	0x6c45
	.4byte	0x7226
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1531
	.4byte	0xa94d
	.4byte	0x7258
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
	.8byte	.LANCHOR165
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x8
	.byte	0xfe
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1532
	.4byte	0x8b93
	.uleb128 0x34
	.8byte	.LVL1540
	.4byte	0x29a4
	.4byte	0x7287
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
	.8byte	.LVL1545
	.4byte	0x2527
	.byte	0
	.uleb128 0xa
	.4byte	0xee
	.4byte	0x72a5
	.uleb128 0xe
	.4byte	0xda
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.4byte	0x7295
	.uleb128 0x2d
	.4byte	.LASF815
	.byte	0x4
	.byte	0x9c
	.4byte	0xdc9
	.8byte	.LFB228
	.8byte	.LFE228-.LFB228
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x72fe
	.uleb128 0x33
	.string	"blk"
	.byte	0x4
	.byte	0x9e
	.4byte	0xdc9
	.4byte	.LLST20
	.uleb128 0x32
	.4byte	.LASF816
	.byte	0x4
	.byte	0x9f
	.4byte	0xdc9
	.4byte	.LLST21
	.uleb128 0x36
	.8byte	.LVL53
	.4byte	0x7560
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x43
	.4byte	.LASF817
	.byte	0x4
	.byte	0x94
	.8byte	.LFB227
	.8byte	.LFE227-.LFB227
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7342
	.uleb128 0x2f
	.8byte	.LVL806
	.4byte	0x259f
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
	.4byte	.LASF818
	.byte	0x4
	.byte	0x4f
	.4byte	0x5b
	.8byte	.LFB226
	.8byte	.LFE226-.LFB226
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x74bc
	.uleb128 0x33
	.string	"i"
	.byte	0x4
	.byte	0x51
	.4byte	0x5b
	.4byte	.LLST308
	.uleb128 0x32
	.4byte	.LASF819
	.byte	0x4
	.byte	0x52
	.4byte	0x5b
	.4byte	.LLST309
	.uleb128 0x32
	.4byte	.LASF810
	.byte	0x4
	.byte	0x53
	.4byte	0x70a4
	.4byte	.LLST310
	.uleb128 0x32
	.4byte	.LASF722
	.byte	0x4
	.byte	0x54
	.4byte	0xdc9
	.4byte	.LLST311
	.uleb128 0x58
	.4byte	.LASF820
	.byte	0x4
	.byte	0x67
	.uleb128 0x6a
	.4byte	.LASF574
	.4byte	0x299f
	.uleb128 0x34
	.8byte	.LVL1245
	.4byte	0x259f
	.4byte	0x73c5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1248
	.4byte	0x259f
	.4byte	0x73e8
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
	.8byte	.LVL1250
	.4byte	0xa94d
	.4byte	0x7400
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1251
	.4byte	0x27e7
	.4byte	0x7427
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
	.8byte	.LVL1252
	.4byte	0x2721
	.4byte	0x7443
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
	.8byte	.LVL1253
	.4byte	0x27e7
	.4byte	0x746a
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
	.8byte	.LVL1255
	.4byte	0xa94d
	.4byte	0x7489
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC95
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1256
	.4byte	0xa94d
	.4byte	0x74ae
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC96
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1259
	.4byte	0x2527
	.byte	0
	.uleb128 0x43
	.4byte	.LASF821
	.byte	0x4
	.byte	0x41
	.8byte	.LFB225
	.8byte	.LFE225-.LFB225
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7558
	.uleb128 0x2e
	.4byte	.LASF754
	.byte	0x4
	.byte	0x41
	.4byte	0x10f8
	.4byte	.LLST203
	.uleb128 0x2e
	.4byte	.LASF822
	.byte	0x4
	.byte	0x41
	.4byte	0x1001
	.4byte	.LLST204
	.uleb128 0x39
	.string	"i"
	.byte	0x4
	.byte	0x43
	.4byte	0xdd4
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x4258
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6320
	.uleb128 0x34
	.8byte	.LVL802
	.4byte	0x259f
	.4byte	0x7530
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
	.8byte	.LVL803
	.4byte	0xa94d
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
	.uleb128 0x6b
	.4byte	.LASF823
	.byte	0x4
	.byte	0x26
	.byte	0x1
	.uleb128 0x2d
	.4byte	.LASF824
	.byte	0x4
	.byte	0x17
	.4byte	0x5b
	.8byte	.LFB223
	.8byte	.LFE223-.LFB223
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x75ef
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
	.4byte	.LASF822
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
	.4byte	.LASF582
	.byte	0x4
	.byte	0x1c
	.4byte	0xdc9
	.4byte	.LLST19
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF825
	.byte	0x4
	.byte	0x4
	.4byte	0x5b
	.8byte	.LFB222
	.8byte	.LFE222-.LFB222
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7673
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
	.4byte	.LASF822
	.byte	0x4
	.byte	0x7
	.4byte	0x1001
	.4byte	.LLST14
	.uleb128 0x32
	.4byte	.LASF582
	.byte	0x4
	.byte	0x8
	.4byte	0xdc9
	.4byte	.LLST15
	.uleb128 0x36
	.8byte	.LVL44
	.4byte	0xa94d
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
	.uleb128 0x6c
	.4byte	.LASF887
	.byte	0x3
	.2byte	0x4bd
	.4byte	0xdd4
	.8byte	.LFB221
	.8byte	.LFE221-.LFB221
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x49
	.4byte	.LASF826
	.byte	0x3
	.2byte	0x4b8
	.4byte	0x5b
	.8byte	.LFB220
	.8byte	.LFE220-.LFB220
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x770c
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x3
	.2byte	0x4b8
	.4byte	0xb9
	.4byte	.LLST460
	.uleb128 0x53
	.4byte	.LASF325
	.byte	0x3
	.2byte	0x4b8
	.4byte	0xb9
	.4byte	.LLST461
	.uleb128 0x5d
	.string	"buf"
	.byte	0x3
	.2byte	0x4b8
	.4byte	0x770c
	.4byte	.LLST462
	.uleb128 0x2f
	.8byte	.LVL2074
	.4byte	0x78b7
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
	.4byte	.LASF827
	.byte	0x3
	.2byte	0x4b3
	.4byte	0x5b
	.8byte	.LFB219
	.8byte	.LFE219-.LFB219
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x778d
	.uleb128 0x53
	.4byte	.LASF236
	.byte	0x3
	.2byte	0x4b3
	.4byte	0xb9
	.4byte	.LLST442
	.uleb128 0x53
	.4byte	.LASF325
	.byte	0x3
	.2byte	0x4b3
	.4byte	0xb9
	.4byte	.LLST443
	.uleb128 0x5d
	.string	"buf"
	.byte	0x3
	.2byte	0x4b3
	.4byte	0x770c
	.4byte	.LLST444
	.uleb128 0x2f
	.8byte	.LVL1984
	.4byte	0x7fdd
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
	.4byte	.LASF828
	.byte	0x3
	.2byte	0x484
	.4byte	0x5b
	.8byte	.LFB218
	.8byte	.LFE218-.LFB218
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x78b7
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x3
	.2byte	0x484
	.4byte	0xdd4
	.4byte	.LLST400
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x3
	.2byte	0x484
	.4byte	0xdd4
	.4byte	.LLST401
	.uleb128 0x55
	.4byte	.LASF735
	.byte	0x3
	.2byte	0x486
	.4byte	0xdc9
	.4byte	.LLST402
	.uleb128 0x54
	.string	"tmp"
	.byte	0x3
	.2byte	0x487
	.4byte	0xdc9
	.4byte	.LLST403
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x488
	.4byte	0xdd4
	.4byte	.LLST404
	.uleb128 0x2a
	.4byte	.LASF664
	.byte	0x3
	.2byte	0x489
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x2a
	.4byte	.LASF641
	.byte	0x3
	.2byte	0x489
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x55
	.4byte	.LASF630
	.byte	0x3
	.2byte	0x48a
	.4byte	0xdc9
	.4byte	.LLST405
	.uleb128 0x45
	.8byte	.LVL1746
	.4byte	0x7d59
	.uleb128 0x45
	.8byte	.LVL1755
	.4byte	0x5d63
	.uleb128 0x45
	.8byte	.LVL1756
	.4byte	0x5694
	.uleb128 0x34
	.8byte	.LVL1757
	.4byte	0x5c36
	.4byte	0x7878
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
	.sleb128 120
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1758
	.4byte	0x5c36
	.4byte	0x789c
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
	.uleb128 0x45
	.8byte	.LVL1759
	.4byte	0x6d71
	.uleb128 0x45
	.8byte	.LVL1760
	.4byte	0x36c0
	.byte	0
	.uleb128 0x49
	.4byte	.LASF829
	.byte	0x3
	.2byte	0x3c1
	.4byte	0x5b
	.8byte	.LFB217
	.8byte	.LFE217-.LFB217
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7d59
	.uleb128 0x5d
	.string	"LUN"
	.byte	0x3
	.2byte	0x3c1
	.4byte	0xdbe
	.4byte	.LLST445
	.uleb128 0x53
	.4byte	.LASF732
	.byte	0x3
	.2byte	0x3c1
	.4byte	0xdd4
	.4byte	.LLST446
	.uleb128 0x53
	.4byte	.LASF733
	.byte	0x3
	.2byte	0x3c1
	.4byte	0xdd4
	.4byte	.LLST447
	.uleb128 0x53
	.4byte	.LASF734
	.byte	0x3
	.2byte	0x3c1
	.4byte	0x5af2
	.4byte	.LLST448
	.uleb128 0x55
	.4byte	.LASF599
	.byte	0x3
	.2byte	0x3c3
	.4byte	0x2dff
	.4byte	.LLST449
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x3c4
	.4byte	0xdd4
	.4byte	.LLST450
	.uleb128 0x55
	.4byte	.LASF830
	.byte	0x3
	.2byte	0x3c4
	.4byte	0xdd4
	.4byte	.LLST451
	.uleb128 0x55
	.4byte	.LASF831
	.byte	0x3
	.2byte	0x3c4
	.4byte	0xdd4
	.4byte	.LLST452
	.uleb128 0x2a
	.4byte	.LASF664
	.byte	0x3
	.2byte	0x3c5
	.4byte	0xdd4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x54
	.string	"ppa"
	.byte	0x3
	.2byte	0x3c5
	.4byte	0xdd4
	.4byte	.LLST453
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x3c6
	.4byte	0xdd4
	.4byte	.LLST454
	.uleb128 0x55
	.4byte	.LASF832
	.byte	0x3
	.2byte	0x3c6
	.4byte	0xdd4
	.4byte	.LLST455
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x3
	.2byte	0x3c6
	.4byte	0xdd4
	.4byte	.LLST456
	.uleb128 0x55
	.4byte	.LASF833
	.byte	0x3
	.2byte	0x3c7
	.4byte	0xdd4
	.4byte	.LLST457
	.uleb128 0x55
	.4byte	.LASF834
	.byte	0x3
	.2byte	0x3c7
	.4byte	0xdd4
	.4byte	.LLST458
	.uleb128 0x55
	.4byte	.LASF640
	.byte	0x3
	.2byte	0x3c8
	.4byte	0x1f04
	.4byte	.LLST459
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x5d5e
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6256
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x300
	.4byte	0x7a79
	.uleb128 0x2a
	.4byte	.LASF604
	.byte	0x3
	.2byte	0x43d
	.4byte	0xdf5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x34
	.8byte	.LVL2061
	.4byte	0x29a4
	.4byte	0x7a24
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
	.8byte	.LVL2063
	.4byte	0xa94d
	.4byte	0x7a49
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC105
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL2064
	.4byte	0xa94d
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
	.8byte	.LANCHOR180
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x44a
	.byte	0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1989
	.4byte	0x5af8
	.4byte	0x7a9e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0x86
	.sleb128 256
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
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2000
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL2002
	.4byte	0x2d32
	.4byte	0x7ace
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x8
	.byte	0x8f
	.sleb128 344
	.byte	0x94
	.byte	0x4
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2007
	.4byte	0x6644
	.4byte	0x7ae5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2008
	.4byte	0x2f73
	.uleb128 0x34
	.8byte	.LVL2009
	.4byte	0x2d32
	.4byte	0x7b0e
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
	.uleb128 0x34
	.8byte	.LVL2010
	.4byte	0x2d32
	.4byte	0x7b2a
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
	.8byte	.LVL2016
	.4byte	0x2527
	.4byte	0x7b48
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
	.uleb128 0x45
	.8byte	.LVL2023
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL2025
	.4byte	0xa94d
	.4byte	0x7b88
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
	.8byte	.LANCHOR180
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x3f4
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2026
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL2027
	.4byte	0x3932
	.4byte	0x7bb4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR52
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2029
	.4byte	0x3932
	.4byte	0x7bcc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2031
	.4byte	0x3932
	.4byte	0x7be4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2034
	.4byte	0xa94d
	.4byte	0x7c17
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
	.8byte	.LANCHOR180
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x415
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2037
	.4byte	0x7d94
	.4byte	0x7c3a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8b
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
	.8byte	.LVL2038
	.4byte	0xa94d
	.4byte	0x7c6d
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
	.8byte	.LANCHOR180
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x46e
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2041
	.4byte	0x3932
	.4byte	0x7c85
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2044
	.4byte	0x5c36
	.4byte	0x7ca9
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
	.8byte	.LVL2045
	.4byte	0x3804
	.4byte	0x7cc1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2049
	.4byte	0x259f
	.4byte	0x7cde
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8b
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2054
	.4byte	0xa94d
	.4byte	0x7d11
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
	.8byte	.LANCHOR180
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x45f
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2062
	.4byte	0x2527
	.4byte	0x7d34
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x7
	.byte	0x8f
	.sleb128 348
	.byte	0x94
	.byte	0x4
	.byte	0x39
	.byte	0x24
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2066
	.4byte	0x259f
	.4byte	0x7d4b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2067
	.4byte	0x2527
	.byte	0
	.uleb128 0x49
	.4byte	.LASF835
	.byte	0x3
	.2byte	0x3b7
	.4byte	0x5b
	.8byte	.LFB216
	.8byte	.LFE216-.LFB216
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7d94
	.uleb128 0x36
	.8byte	.LVL1734
	.4byte	0x7d94
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
	.byte	0
	.uleb128 0x5f
	.4byte	.LASF836
	.byte	0x3
	.2byte	0x387
	.8byte	.LFB215
	.8byte	.LFE215-.LFB215
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x7fc8
	.uleb128 0x5d
	.string	"req"
	.byte	0x3
	.2byte	0x387
	.4byte	0x1abc
	.4byte	.LLST393
	.uleb128 0x53
	.4byte	.LASF596
	.byte	0x3
	.2byte	0x387
	.4byte	0xdd4
	.4byte	.LLST394
	.uleb128 0x53
	.4byte	.LASF837
	.byte	0x3
	.2byte	0x387
	.4byte	0xdd4
	.4byte	.LLST395
	.uleb128 0x53
	.4byte	.LASF640
	.byte	0x3
	.2byte	0x387
	.4byte	0x1f04
	.4byte	.LLST396
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
	.4byte	.LASF664
	.byte	0x3
	.2byte	0x38a
	.4byte	0xdd4
	.4byte	.LLST397
	.uleb128 0x55
	.4byte	.LASF624
	.byte	0x3
	.2byte	0x38b
	.4byte	0xdc9
	.4byte	.LLST398
	.uleb128 0x55
	.4byte	.LASF599
	.byte	0x3
	.2byte	0x38c
	.4byte	0x2dff
	.4byte	.LLST399
	.uleb128 0x61
	.4byte	.LASF688
	.byte	0x3
	.2byte	0x38d
	.4byte	0xdd4
	.byte	0
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x7fd8
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6228
	.uleb128 0x34
	.8byte	.LVL1717
	.4byte	0x27e7
	.4byte	0x7e7f
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
	.8byte	.LVL1718
	.4byte	0x6d71
	.uleb128 0x34
	.8byte	.LVL1720
	.4byte	0x3932
	.4byte	0x7ea4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1721
	.4byte	0x2ed1
	.uleb128 0x34
	.8byte	.LVL1722
	.4byte	0x3804
	.4byte	0x7ec9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1723
	.4byte	0x27e7
	.4byte	0x7eeb
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
	.8byte	.LVL1724
	.4byte	0xa94d
	.4byte	0x7f1e
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
	.8byte	.LVL1725
	.4byte	0x5c36
	.4byte	0x7f3c
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
	.8byte	.LVL1727
	.4byte	0x6d71
	.4byte	0x7f56
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
	.8byte	.LVL1729
	.4byte	0xa94d
	.4byte	0x7f80
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC103
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
	.8byte	.LVL1730
	.4byte	0x36c0
	.4byte	0x7f98
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1732
	.4byte	0xa94d
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
	.4byte	0x7fd8
	.uleb128 0xe
	.4byte	0xda
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.4byte	0x7fc8
	.uleb128 0x49
	.4byte	.LASF838
	.byte	0x3
	.2byte	0x32d
	.4byte	0x5b
	.8byte	.LFB214
	.8byte	.LFE214-.LFB214
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8203
	.uleb128 0x5d
	.string	"LUN"
	.byte	0x3
	.2byte	0x32d
	.4byte	0xdbe
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
	.4byte	0xdd4
	.4byte	.LLST427
	.uleb128 0x53
	.4byte	.LASF734
	.byte	0x3
	.2byte	0x32d
	.4byte	0x5af2
	.4byte	.LLST428
	.uleb128 0x54
	.string	"ret"
	.byte	0x3
	.2byte	0x32f
	.4byte	0x5b
	.4byte	.LLST429
	.uleb128 0x55
	.4byte	.LASF830
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST430
	.uleb128 0x55
	.4byte	.LASF831
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST431
	.uleb128 0x55
	.4byte	.LASF839
	.byte	0x3
	.2byte	0x330
	.4byte	0xdd4
	.4byte	.LLST432
	.uleb128 0x54
	.string	"lpa"
	.byte	0x3
	.2byte	0x331
	.4byte	0xdd4
	.4byte	.LLST433
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
	.4byte	.LLST434
	.uleb128 0x55
	.4byte	.LASF596
	.byte	0x3
	.2byte	0x333
	.4byte	0xdd4
	.4byte	.LLST435
	.uleb128 0x55
	.4byte	.LASF832
	.byte	0x3
	.2byte	0x333
	.4byte	0xdd4
	.4byte	.LLST436
	.uleb128 0x55
	.4byte	.LASF840
	.byte	0x3
	.2byte	0x334
	.4byte	0xdd4
	.4byte	.LLST437
	.uleb128 0x55
	.4byte	.LASF841
	.byte	0x3
	.2byte	0x334
	.4byte	0xdd4
	.4byte	.LLST438
	.uleb128 0x55
	.4byte	.LASF842
	.byte	0x3
	.2byte	0x335
	.4byte	0xdd4
	.4byte	.LLST439
	.uleb128 0x55
	.4byte	.LASF843
	.byte	0x3
	.2byte	0x336
	.4byte	0xdd4
	.4byte	.LLST440
	.uleb128 0x63
	.8byte	.LBB297
	.8byte	.LBE297-.LBB297
	.4byte	0x814c
	.uleb128 0x55
	.4byte	.LASF587
	.byte	0x3
	.2byte	0x37a
	.4byte	0xdc9
	.4byte	.LLST441
	.uleb128 0x45
	.8byte	.LVL1977
	.4byte	0x6d71
	.uleb128 0x45
	.8byte	.LVL1978
	.4byte	0x2f73
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1935
	.4byte	0x59d0
	.4byte	0x8171
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
	.uleb128 0x45
	.8byte	.LVL1942
	.4byte	0x7d59
	.uleb128 0x34
	.8byte	.LVL1948
	.4byte	0x2d32
	.4byte	0x819a
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
	.8byte	.LVL1949
	.4byte	0x5c36
	.4byte	0x81be
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
	.8byte	.LVL1954
	.4byte	0x29a4
	.4byte	0x81db
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
	.8byte	.LVL1957
	.4byte	0x2527
	.uleb128 0x36
	.8byte	.LVL1964
	.4byte	0x259f
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
	.4byte	.LASF844
	.byte	0x3
	.2byte	0x325
	.4byte	0x5b
	.8byte	.LFB213
	.8byte	.LFE213-.LFB213
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8233
	.uleb128 0x45
	.8byte	.LVL1739
	.4byte	0x8233
	.byte	0
	.uleb128 0x49
	.4byte	.LASF845
	.byte	0x3
	.2byte	0x31c
	.4byte	0x5b
	.8byte	.LFB212
	.8byte	.LFE212-.LFB212
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8294
	.uleb128 0x45
	.8byte	.LVL1735
	.4byte	0x7d59
	.uleb128 0x45
	.8byte	.LVL1736
	.4byte	0x5d63
	.uleb128 0x34
	.8byte	.LVL1737
	.4byte	0x5968
	.4byte	0x8286
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1738
	.4byte	0x5694
	.byte	0
	.uleb128 0x49
	.4byte	.LASF846
	.byte	0x3
	.2byte	0x2e6
	.4byte	0x5b
	.8byte	.LFB211
	.8byte	.LFE211-.LFB211
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x83a6
	.uleb128 0x2a
	.4byte	.LASF847
	.byte	0x3
	.2byte	0x2e8
	.4byte	0x83a6
	.uleb128 0xa
	.byte	0x3
	.8byte	g_nand_phy_info
	.byte	0x9f
	.uleb128 0x59
	.4byte	.LASF848
	.byte	0x3
	.2byte	0x2f3
	.8byte	.LDL2
	.uleb128 0x63
	.8byte	.LBB306
	.8byte	.LBE306-.LBB306
	.4byte	0x8319
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x310
	.4byte	0xdd4
	.4byte	.LLST469
	.uleb128 0x36
	.8byte	.LVL2171
	.4byte	0x2d32
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
	.8byte	.LVL2163
	.4byte	0xa94d
	.4byte	0x8345
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
	.8byte	.LVL2164
	.4byte	0x8b23
	.4byte	0x8364
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2165
	.4byte	0x882f
	.uleb128 0x45
	.8byte	.LVL2166
	.4byte	0x8758
	.uleb128 0x45
	.8byte	.LVL2167
	.4byte	0x6bd9
	.uleb128 0x45
	.8byte	.LVL2168
	.4byte	0x7127
	.uleb128 0x45
	.8byte	.LVL2169
	.4byte	0x3f98
	.byte	0
	.uleb128 0x8
	.byte	0x8
	.4byte	0xee1
	.uleb128 0x49
	.4byte	.LASF849
	.byte	0x3
	.2byte	0x26e
	.4byte	0x5b
	.8byte	.LFB210
	.8byte	.LFE210-.LFB210
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8546
	.uleb128 0x55
	.4byte	.LASF718
	.byte	0x3
	.2byte	0x270
	.4byte	0xdc9
	.4byte	.LLST465
	.uleb128 0x55
	.4byte	.LASF850
	.byte	0x3
	.2byte	0x270
	.4byte	0xdc9
	.4byte	.LLST466
	.uleb128 0x55
	.4byte	.LASF851
	.byte	0x3
	.2byte	0x271
	.4byte	0xdc9
	.4byte	.LLST467
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x272
	.4byte	0xdc9
	.4byte	.LLST468
	.uleb128 0x59
	.4byte	.LASF852
	.byte	0x3
	.2byte	0x2bc
	.8byte	.L1631
	.uleb128 0x59
	.4byte	.LASF853
	.byte	0x3
	.2byte	0x2cc
	.8byte	.L1633
	.uleb128 0x45
	.8byte	.LVL2122
	.4byte	0x6bd9
	.uleb128 0x45
	.8byte	.LVL2123
	.4byte	0x7127
	.uleb128 0x45
	.8byte	.LVL2124
	.4byte	0x6e59
	.uleb128 0x45
	.8byte	.LVL2132
	.4byte	0x7342
	.uleb128 0x34
	.8byte	.LVL2133
	.4byte	0x259f
	.4byte	0x8477
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2135
	.4byte	0x259f
	.4byte	0x848f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2136
	.4byte	0x460e
	.4byte	0x84a7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2142
	.4byte	0x8546
	.4byte	0x84be
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2147
	.4byte	0x8b93
	.uleb128 0x45
	.8byte	.LVL2148
	.4byte	0x6bd9
	.uleb128 0x34
	.8byte	.LVL2151
	.4byte	0x8546
	.4byte	0x84ef
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2154
	.4byte	0x8546
	.4byte	0x8506
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2158
	.4byte	0x460e
	.4byte	0x851e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2159
	.4byte	0x6980
	.uleb128 0x45
	.8byte	.LVL2160
	.4byte	0x5694
	.uleb128 0x45
	.8byte	.LVL2161
	.4byte	0x3f98
	.byte	0
	.uleb128 0x49
	.4byte	.LASF854
	.byte	0x3
	.2byte	0x20f
	.4byte	0x5b
	.8byte	.LFB209
	.8byte	.LFE209-.LFB209
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x872e
	.uleb128 0x53
	.4byte	.LASF718
	.byte	0x3
	.2byte	0x20f
	.4byte	0xdc9
	.4byte	.LLST188
	.uleb128 0x53
	.4byte	.LASF855
	.byte	0x3
	.2byte	0x20f
	.4byte	0xdbe
	.4byte	.LLST189
	.uleb128 0x55
	.4byte	.LASF850
	.byte	0x3
	.2byte	0x211
	.4byte	0xdc9
	.4byte	.LLST190
	.uleb128 0x55
	.4byte	.LASF569
	.byte	0x3
	.2byte	0x211
	.4byte	0xdc9
	.4byte	.LLST191
	.uleb128 0x55
	.4byte	.LASF595
	.byte	0x3
	.2byte	0x212
	.4byte	0xdc9
	.4byte	.LLST192
	.uleb128 0x55
	.4byte	.LASF388
	.byte	0x3
	.2byte	0x212
	.4byte	0xdc9
	.4byte	.LLST193
	.uleb128 0x55
	.4byte	.LASF856
	.byte	0x3
	.2byte	0x213
	.4byte	0xdc9
	.4byte	.LLST194
	.uleb128 0x55
	.4byte	.LASF857
	.byte	0x3
	.2byte	0x214
	.4byte	0xdc9
	.4byte	.LLST195
	.uleb128 0x55
	.4byte	.LASF858
	.byte	0x3
	.2byte	0x215
	.4byte	0xdc9
	.4byte	.LLST196
	.uleb128 0x55
	.4byte	.LASF859
	.byte	0x3
	.2byte	0x216
	.4byte	0xdc9
	.4byte	.LLST197
	.uleb128 0x59
	.4byte	.LASF860
	.byte	0x3
	.2byte	0x240
	.8byte	.L440
	.uleb128 0x34
	.8byte	.LVL694
	.4byte	0x2721
	.4byte	0x862f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL697
	.4byte	0x75ef
	.uleb128 0x34
	.8byte	.LVL703
	.4byte	0x27e7
	.4byte	0x865f
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
	.8byte	.LVL707
	.4byte	0x75ef
	.uleb128 0x34
	.8byte	.LVL711
	.4byte	0x6afa
	.4byte	0x8683
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x34
	.8byte	.LVL712
	.4byte	0x2721
	.4byte	0x86a1
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
	.8byte	.LVL716
	.4byte	0x6e0c
	.4byte	0x86b9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL718
	.4byte	0x872e
	.4byte	0x86d1
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL719
	.4byte	0x7560
	.4byte	0x86e9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7e
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL730
	.4byte	0x6e0c
	.4byte	0x8701
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x88
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL732
	.4byte	0x872e
	.4byte	0x8719
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7c
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL733
	.4byte	0x7560
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x4a
	.4byte	.LASF861
	.byte	0x3
	.2byte	0x201
	.4byte	0x5b
	.byte	0x1
	.4byte	0x8758
	.uleb128 0x4b
	.4byte	.LASF388
	.byte	0x3
	.2byte	0x201
	.4byte	0xdc9
	.uleb128 0x4c
	.4byte	.LASF862
	.byte	0x3
	.2byte	0x203
	.4byte	0xdc9
	.byte	0
	.uleb128 0x49
	.4byte	.LASF863
	.byte	0x3
	.2byte	0x1ec
	.4byte	0x5b
	.8byte	.LFB207
	.8byte	.LFE207-.LFB207
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x882f
	.uleb128 0x34
	.8byte	.LVL1110
	.4byte	0x259f
	.4byte	0x8791
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1111
	.4byte	0x259f
	.4byte	0x87a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1112
	.4byte	0x259f
	.4byte	0x87bf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1113
	.4byte	0x259f
	.4byte	0x87e9
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR79
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
	.8byte	.LVL1114
	.4byte	0x259f
	.4byte	0x8814
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR83
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
	.8byte	.LVL1115
	.4byte	0x3695
	.uleb128 0x45
	.8byte	.LVL1116
	.4byte	0x4f8b
	.byte	0
	.uleb128 0x49
	.4byte	.LASF864
	.byte	0x3
	.2byte	0x116
	.4byte	0x5b
	.8byte	.LFB206
	.8byte	.LFE206-.LFB206
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8b23
	.uleb128 0x54
	.string	"i"
	.byte	0x3
	.2byte	0x118
	.4byte	0xdd4
	.4byte	.LLST201
	.uleb128 0x55
	.4byte	.LASF865
	.byte	0x3
	.2byte	0x119
	.4byte	0xdd4
	.4byte	.LLST202
	.uleb128 0x3f
	.4byte	.LASF574
	.4byte	0x72a5
	.uleb128 0x9
	.byte	0x3
	.8byte	__func__.6104
	.uleb128 0x45
	.8byte	.LVL741
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL742
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL744
	.4byte	0x2c2b
	.4byte	0x88b4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL745
	.4byte	0x2c2b
	.4byte	0x88cc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL746
	.4byte	0x2c2b
	.4byte	0x88e4
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL747
	.4byte	0x2c2b
	.4byte	0x88fc
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL748
	.4byte	0x2c2b
	.4byte	0x8914
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL751
	.4byte	0x2c2b
	.4byte	0x892c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL752
	.4byte	0x2c2b
	.4byte	0x8944
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL753
	.4byte	0x2c2b
	.4byte	0x895c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL754
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL755
	.4byte	0x2c2b
	.4byte	0x8981
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL756
	.4byte	0x2c2b
	.4byte	0x8999
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL758
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL760
	.4byte	0x2c2b
	.4byte	0x89be
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL761
	.4byte	0x2c2b
	.4byte	0x89d8
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
	.8byte	.LVL763
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL764
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL765
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL767
	.4byte	0x2c2b
	.4byte	0x8a17
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8c
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL769
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL771
	.4byte	0x2c2b
	.4byte	0x8a3c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL772
	.4byte	0x2c2b
	.4byte	0x8a54
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL773
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL774
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL775
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL776
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL777
	.4byte	0x2c2b
	.uleb128 0x34
	.8byte	.LVL778
	.4byte	0x259f
	.4byte	0x8aac
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL780
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL782
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL785
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL788
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL791
	.4byte	0x2c2b
	.uleb128 0x45
	.8byte	.LVL795
	.4byte	0x2c2b
	.uleb128 0x36
	.8byte	.LVL798
	.4byte	0xa94d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC82
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR138
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF866
	.byte	0x3
	.byte	0xb6
	.4byte	0x5b
	.8byte	.LFB205
	.8byte	.LFE205-.LFB205
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8b93
	.uleb128 0x2e
	.4byte	.LASF847
	.byte	0x3
	.byte	0xb6
	.4byte	0x83a6
	.4byte	.LLST8
	.uleb128 0x33
	.string	"i"
	.byte	0x3
	.byte	0xb8
	.4byte	0xdd4
	.4byte	.LLST9
	.uleb128 0x45
	.8byte	.LVL30
	.4byte	0x8bdc
	.uleb128 0x34
	.8byte	.LVL31
	.4byte	0x8bdc
	.4byte	0x8b85
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL33
	.4byte	0x8b93
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF867
	.byte	0x3
	.byte	0xa4
	.4byte	0x5b
	.8byte	.LFB204
	.8byte	.LFE204-.LFB204
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8bc4
	.uleb128 0x2e
	.4byte	.LASF868
	.byte	0x3
	.byte	0xa4
	.4byte	0xdc9
	.4byte	.LLST7
	.byte	0
	.uleb128 0x65
	.4byte	.LASF869
	.byte	0x3
	.byte	0x9e
	.byte	0x1
	.4byte	0x8bdc
	.uleb128 0x38
	.4byte	.LASF870
	.byte	0x3
	.byte	0x9e
	.4byte	0xdd4
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF871
	.byte	0x3
	.byte	0x7f
	.4byte	0xdc9
	.8byte	.LFB202
	.8byte	.LFE202-.LFB202
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8c29
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
	.4byte	.LASF872
	.byte	0x3
	.byte	0x82
	.4byte	0xdd4
	.4byte	.LLST6
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF873
	.byte	0x3
	.byte	0x71
	.4byte	0x5b
	.8byte	.LFB201
	.8byte	.LFE201-.LFB201
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x8caf
	.uleb128 0x2e
	.4byte	.LASF299
	.byte	0x3
	.byte	0x71
	.4byte	0xfa
	.4byte	.LLST112
	.uleb128 0x33
	.string	"buf"
	.byte	0x3
	.byte	0x73
	.4byte	0xfa
	.4byte	.LLST113
	.uleb128 0x34
	.8byte	.LVL470
	.4byte	0xa96f
	.4byte	0x8c9a
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
	.8byte	.LVL472
	.4byte	0x8caf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF874
	.byte	0x3
	.byte	0xb
	.4byte	0x5b
	.8byte	.LFB200
	.8byte	.LFE200-.LFB200
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x973d
	.uleb128 0x2e
	.4byte	.LASF299
	.byte	0x3
	.byte	0xb
	.4byte	0xfa
	.4byte	.LLST107
	.uleb128 0x33
	.string	"i"
	.byte	0x3
	.byte	0xd
	.4byte	0x5b
	.4byte	.LLST108
	.uleb128 0x33
	.string	"buf"
	.byte	0x3
	.byte	0xe
	.4byte	0xfa
	.4byte	.LLST109
	.uleb128 0x63
	.8byte	.LBB205
	.8byte	.LBE205-.LBB205
	.4byte	0x8d57
	.uleb128 0x32
	.4byte	.LASF587
	.byte	0x3
	.byte	0x57
	.4byte	0xdc9
	.4byte	.LLST110
	.uleb128 0x34
	.8byte	.LVL455
	.4byte	0x6644
	.4byte	0x8d36
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x36
	.8byte	.LVL459
	.4byte	0xa96f
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
	.8byte	.LBB206
	.8byte	.LBE206-.LBB206
	.4byte	0x8d9c
	.uleb128 0x32
	.4byte	.LASF587
	.byte	0x3
	.byte	0x60
	.4byte	0xdc9
	.4byte	.LLST111
	.uleb128 0x36
	.8byte	.LVL466
	.4byte	0xa96f
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
	.8byte	.LVL318
	.4byte	0xa96f
	.4byte	0x8dc1
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
	.8byte	.LVL320
	.4byte	0xa96f
	.4byte	0x8de6
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
	.8byte	.LVL322
	.4byte	0xa96f
	.4byte	0x8e0b
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
	.8byte	.LVL324
	.4byte	0xa96f
	.4byte	0x8e30
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
	.8byte	.LVL326
	.4byte	0xa96f
	.4byte	0x8e55
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
	.8byte	.LVL328
	.4byte	0xa96f
	.4byte	0x8e7a
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
	.8byte	.LVL330
	.4byte	0xa96f
	.4byte	0x8e9f
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
	.8byte	.LVL332
	.4byte	0xa96f
	.4byte	0x8ec4
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
	.8byte	.LVL334
	.4byte	0xa96f
	.4byte	0x8ee9
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
	.8byte	.LVL336
	.4byte	0xa96f
	.4byte	0x8f0e
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
	.8byte	.LVL338
	.4byte	0xa96f
	.4byte	0x8f33
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
	.8byte	.LVL340
	.4byte	0xa96f
	.4byte	0x8f58
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
	.8byte	.LVL342
	.4byte	0xa96f
	.4byte	0x8f7d
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
	.8byte	.LVL344
	.4byte	0xa96f
	.4byte	0x8fa2
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
	.8byte	.LVL346
	.4byte	0xa96f
	.4byte	0x8fc7
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
	.8byte	.LVL348
	.4byte	0xa96f
	.4byte	0x8fec
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
	.8byte	.LVL350
	.4byte	0xa96f
	.4byte	0x9011
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
	.8byte	.LVL352
	.4byte	0xa96f
	.4byte	0x9036
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
	.8byte	.LVL354
	.4byte	0xa96f
	.4byte	0x905b
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
	.8byte	.LVL356
	.4byte	0xa96f
	.4byte	0x9080
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
	.8byte	.LVL358
	.4byte	0xa96f
	.4byte	0x90a5
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
	.8byte	.LVL360
	.4byte	0xa96f
	.4byte	0x90ca
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
	.8byte	.LVL362
	.4byte	0xa96f
	.4byte	0x90ef
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
	.8byte	.LVL364
	.4byte	0xa96f
	.4byte	0x9114
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
	.8byte	.LVL366
	.4byte	0xa96f
	.4byte	0x9139
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
	.8byte	.LVL368
	.4byte	0xa96f
	.4byte	0x915e
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
	.8byte	.LVL370
	.4byte	0xa96f
	.4byte	0x9183
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
	.8byte	.LVL372
	.4byte	0xa96f
	.4byte	0x91a8
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
	.8byte	.LVL374
	.4byte	0xa96f
	.4byte	0x91cd
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
	.8byte	.LVL376
	.4byte	0xa96f
	.4byte	0x91f2
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
	.8byte	.LVL378
	.4byte	0xa96f
	.4byte	0x9217
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
	.8byte	.LVL380
	.4byte	0xa96f
	.4byte	0x923c
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
	.8byte	.LVL382
	.4byte	0xa96f
	.4byte	0x9261
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
	.8byte	.LVL384
	.4byte	0xa96f
	.4byte	0x9286
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
	.8byte	.LVL386
	.4byte	0xa96f
	.4byte	0x92ab
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
	.8byte	.LVL388
	.4byte	0xa96f
	.4byte	0x92d0
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
	.8byte	.LVL390
	.4byte	0xa96f
	.4byte	0x92f5
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
	.8byte	.LVL392
	.4byte	0xa96f
	.4byte	0x931a
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
	.8byte	.LVL394
	.4byte	0xa96f
	.4byte	0x933f
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
	.8byte	.LVL396
	.4byte	0xa96f
	.4byte	0x9364
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
	.8byte	.LVL398
	.4byte	0xa96f
	.4byte	0x9389
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
	.8byte	.LVL400
	.4byte	0xa96f
	.4byte	0x93ae
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
	.8byte	.LVL402
	.4byte	0xa96f
	.4byte	0x93d3
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
	.8byte	.LVL404
	.4byte	0xa96f
	.4byte	0x93f8
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
	.8byte	.LVL406
	.4byte	0xa96f
	.4byte	0x941d
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
	.8byte	.LVL408
	.4byte	0xa96f
	.4byte	0x9442
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
	.8byte	.LVL410
	.4byte	0xa96f
	.4byte	0x9467
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
	.8byte	.LVL412
	.4byte	0xa96f
	.4byte	0x948c
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
	.8byte	.LVL414
	.4byte	0xa96f
	.4byte	0x94b1
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
	.8byte	.LVL416
	.4byte	0xa96f
	.4byte	0x94d6
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
	.8byte	.LVL418
	.4byte	0xa96f
	.4byte	0x94fb
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
	.8byte	.LVL420
	.4byte	0xa96f
	.4byte	0x9520
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
	.8byte	.LVL422
	.4byte	0xa96f
	.4byte	0x9545
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
	.8byte	.LVL424
	.4byte	0xa96f
	.4byte	0x956a
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
	.8byte	.LVL426
	.4byte	0xa96f
	.4byte	0x958f
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
	.8byte	.LVL428
	.4byte	0xa96f
	.4byte	0x95b4
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
	.8byte	.LVL430
	.4byte	0xa96f
	.4byte	0x95d9
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
	.8byte	.LVL432
	.4byte	0xa96f
	.4byte	0x95fe
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
	.8byte	.LVL434
	.4byte	0xa96f
	.4byte	0x9623
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
	.8byte	.LVL436
	.4byte	0xa96f
	.4byte	0x9648
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
	.8byte	.LVL438
	.4byte	0xa96f
	.4byte	0x966d
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
	.8byte	.LVL440
	.4byte	0xa96f
	.4byte	0x9692
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
	.8byte	.LVL442
	.4byte	0xa96f
	.4byte	0x96b7
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
	.8byte	.LVL444
	.4byte	0x3edd
	.uleb128 0x34
	.8byte	.LVL445
	.4byte	0xa96f
	.4byte	0x96e9
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
	.8byte	.LVL447
	.4byte	0x3e7c
	.uleb128 0x34
	.8byte	.LVL448
	.4byte	0xa96f
	.4byte	0x971b
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
	.8byte	.LVL453
	.4byte	0xa96f
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
	.uleb128 0x6d
	.4byte	0x2a9d
	.8byte	.LFB349
	.8byte	.LFE349-.LFB349
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x979f
	.uleb128 0x6e
	.4byte	0x2ab8
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x6e
	.4byte	0x2ac3
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x6f
	.4byte	0x2aad
	.uleb128 0x70
	.4byte	0x2ace
	.4byte	.LLST0
	.uleb128 0x71
	.4byte	0x2ad9
	.uleb128 0x70
	.4byte	0x2ae4
	.4byte	.LLST1
	.uleb128 0x72
	.4byte	0x2aef
	.uleb128 0x1
	.byte	0x56
	.uleb128 0x72
	.4byte	0x2afa
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x70
	.4byte	0x2b05
	.4byte	.LLST2
	.uleb128 0x71
	.4byte	0x2b10
	.byte	0
	.uleb128 0x6d
	.4byte	0x5413
	.8byte	.LFB356
	.8byte	.LFE356-.LFB356
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x97d0
	.uleb128 0x47
	.4byte	0x5420
	.4byte	.LLST3
	.uleb128 0x6e
	.4byte	0x542c
	.uleb128 0x6
	.byte	0xfa
	.4byte	0x542c
	.byte	0x9f
	.byte	0
	.uleb128 0x6d
	.4byte	0x8bc4
	.8byte	.LFB203
	.8byte	.LFE203-.LFB203
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x97f3
	.uleb128 0x6e
	.4byte	0x8bd0
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.uleb128 0x6d
	.4byte	0x872e
	.8byte	.LFB208
	.8byte	.LFE208-.LFB208
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9837
	.uleb128 0x47
	.4byte	0x873f
	.4byte	.LLST10
	.uleb128 0x71
	.4byte	0x874b
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0
	.uleb128 0x6f
	.4byte	0x873f
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0
	.uleb128 0x70
	.4byte	0x9817
	.4byte	.LLST11
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x74
	.4byte	0x7558
	.8byte	.LFB224
	.8byte	.LFE224-.LFB224
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x74
	.4byte	0x6bcd
	.8byte	.LFB238
	.8byte	.LFE238-.LFB238
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x74
	.4byte	0x6bc1
	.8byte	.LFB239
	.8byte	.LFE239-.LFB239
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x6d
	.4byte	0x6936
	.8byte	.LFB245
	.8byte	.LFE245-.LFB245
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x991f
	.uleb128 0x47
	.4byte	0x6942
	.4byte	.LLST49
	.uleb128 0x71
	.4byte	0x694d
	.uleb128 0x63
	.8byte	.LBB179
	.8byte	.LBE179-.LBB179
	.4byte	0x9909
	.uleb128 0x47
	.4byte	0x6942
	.4byte	.LLST50
	.uleb128 0x68
	.8byte	.LBB180
	.8byte	.LBE180-.LBB180
	.uleb128 0x71
	.4byte	0x98a0
	.uleb128 0x2f
	.8byte	.LVL139
	.4byte	0xa94d
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
	.byte	0xbd
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL137
	.4byte	0x689c
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x695b
	.8byte	.LFB244
	.8byte	.LFE244-.LFB244
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x99c2
	.uleb128 0x47
	.4byte	0x6967
	.4byte	.LLST56
	.uleb128 0x71
	.4byte	0x6972
	.uleb128 0x63
	.8byte	.LBB183
	.8byte	.LBE183-.LBB183
	.4byte	0x99ac
	.uleb128 0x47
	.4byte	0x6967
	.4byte	.LLST57
	.uleb128 0x68
	.8byte	.LBB184
	.8byte	.LBE184-.LBB184
	.uleb128 0x71
	.4byte	0x9943
	.uleb128 0x2f
	.8byte	.LVL159
	.4byte	0xa94d
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
	.byte	0xb6
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL157
	.4byte	0x681b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x65c5
	.8byte	.LFB252
	.8byte	.LFE252-.LFB252
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9b1f
	.uleb128 0x47
	.4byte	0x65d6
	.4byte	.LLST70
	.uleb128 0x71
	.4byte	0x65e2
	.uleb128 0x71
	.4byte	0x65ee
	.uleb128 0x71
	.4byte	0x65fa
	.uleb128 0x71
	.4byte	0x6606
	.uleb128 0x71
	.4byte	0x6612
	.uleb128 0x71
	.4byte	0x661e
	.uleb128 0x71
	.4byte	0x662a
	.uleb128 0x71
	.4byte	0x6636
	.uleb128 0x68
	.8byte	.LBB187
	.8byte	.LBE187-.LBB187
	.uleb128 0x47
	.4byte	0x65d6
	.4byte	.LLST71
	.uleb128 0x68
	.8byte	.LBB188
	.8byte	.LBE188-.LBB188
	.uleb128 0x70
	.4byte	0x99e6
	.4byte	.LLST72
	.uleb128 0x70
	.4byte	0x99eb
	.4byte	.LLST73
	.uleb128 0x70
	.4byte	0x99f0
	.4byte	.LLST74
	.uleb128 0x70
	.4byte	0x99f5
	.4byte	.LLST75
	.uleb128 0x70
	.4byte	0x99fa
	.4byte	.LLST76
	.uleb128 0x70
	.4byte	0x99ff
	.4byte	.LLST77
	.uleb128 0x70
	.4byte	0x9a04
	.4byte	.LLST78
	.uleb128 0x71
	.4byte	0x9a09
	.uleb128 0x34
	.8byte	.LVL205
	.4byte	0xa94d
	.4byte	0x9ab0
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
	.2byte	0x1aa
	.byte	0
	.uleb128 0x34
	.8byte	.LVL213
	.4byte	0x6761
	.4byte	0x9ad5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR42
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL214
	.4byte	0xa94d
	.4byte	0x9b08
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
	.2byte	0x1b3
	.byte	0
	.uleb128 0x36
	.8byte	.LVL215
	.4byte	0x6936
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
	.uleb128 0x6d
	.4byte	0x6302
	.8byte	.LFB255
	.8byte	.LFE255-.LFB255
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9bd7
	.uleb128 0x47
	.4byte	0x6313
	.4byte	.LLST79
	.uleb128 0x70
	.4byte	0x631f
	.4byte	.LLST80
	.uleb128 0x70
	.4byte	0x632b
	.4byte	.LLST81
	.uleb128 0x71
	.4byte	0x6337
	.uleb128 0x63
	.8byte	.LBB191
	.8byte	.LBE191-.LBB191
	.4byte	0x9bc9
	.uleb128 0x47
	.4byte	0x6313
	.4byte	.LLST82
	.uleb128 0x68
	.8byte	.LBB192
	.8byte	.LBE192-.LBB192
	.uleb128 0x71
	.4byte	0x9b43
	.uleb128 0x71
	.4byte	0x9b4c
	.uleb128 0x71
	.4byte	0x9b55
	.uleb128 0x36
	.8byte	.LVL221
	.4byte	0xa94d
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
	.8byte	.LANCHOR55
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x214
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL223
	.4byte	0x6980
	.byte	0
	.uleb128 0x6d
	.4byte	0x5944
	.8byte	.LFB266
	.8byte	.LFE266-.LFB266
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9c1d
	.uleb128 0x47
	.4byte	0x5951
	.4byte	.LLST86
	.uleb128 0x75
	.4byte	0x595d
	.byte	0
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x60
	.uleb128 0x6e
	.4byte	0x5951
	.uleb128 0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x60
	.uleb128 0x71
	.4byte	0x9bfb
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x5413
	.8byte	.LFB272
	.8byte	.LFE272-.LFB272
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9c69
	.uleb128 0x47
	.4byte	0x5420
	.4byte	.LLST87
	.uleb128 0x47
	.4byte	0x542c
	.4byte	.LLST88
	.uleb128 0x2f
	.8byte	.LVL257
	.4byte	0x979f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x3e
	.4byte	0x542c
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x476a
	.8byte	.LFB282
	.8byte	.LFE282-.LFB282
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9cc7
	.uleb128 0x6e
	.4byte	0x4777
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x71
	.4byte	0x4783
	.uleb128 0x68
	.8byte	.LBB203
	.8byte	.LBE203-.LBB203
	.uleb128 0x47
	.4byte	0x4777
	.4byte	.LLST93
	.uleb128 0x68
	.8byte	.LBB204
	.8byte	.LBE204-.LBB204
	.uleb128 0x70
	.4byte	0x9c8b
	.4byte	.LLST94
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x3d92
	.8byte	.LFB297
	.8byte	.LFE297-.LFB297
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9d10
	.uleb128 0x47
	.4byte	0x3da3
	.4byte	.LLST121
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0xa0
	.uleb128 0x47
	.4byte	0x3da3
	.4byte	.LLST122
	.uleb128 0x36
	.8byte	.LVL504
	.4byte	0x695b
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
	.uleb128 0x6d
	.4byte	0x2ec4
	.8byte	.LFB316
	.8byte	.LFE316-.LFB316
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9d46
	.uleb128 0x45
	.8byte	.LVL576
	.4byte	0x6d71
	.uleb128 0x45
	.8byte	.LVL577
	.4byte	0x2f73
	.byte	0
	.uleb128 0x6d
	.4byte	0x2e1a
	.8byte	.LFB318
	.8byte	.LFE318-.LFB318
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9e40
	.uleb128 0x75
	.4byte	0x2e2b
	.byte	0
	.uleb128 0x71
	.4byte	0x2e37
	.uleb128 0x71
	.4byte	0x2e41
	.uleb128 0x71
	.4byte	0x2e4d
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x130
	.4byte	0x9e15
	.uleb128 0x71
	.4byte	0x9d61
	.uleb128 0x70
	.4byte	0x9d67
	.4byte	.LLST253
	.uleb128 0x72
	.4byte	0x9d6c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -100
	.uleb128 0x72
	.4byte	0x9d71
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x63
	.8byte	.LBB234
	.8byte	.LBE234-.LBB234
	.4byte	0x9dfa
	.uleb128 0x72
	.4byte	0x2e5e
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x34
	.8byte	.LVL968
	.4byte	0x29a4
	.4byte	0x9ddf
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
	.8byte	.LVL969
	.4byte	0x6d71
	.uleb128 0x45
	.8byte	.LVL970
	.4byte	0x2f73
	.byte	0
	.uleb128 0x36
	.8byte	.LVL967
	.4byte	0x5c36
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
	.uleb128 0x68
	.8byte	.LBB241
	.8byte	.LBE241-.LBB241
	.uleb128 0x72
	.4byte	0x2e6c
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
	.uleb128 0x6d
	.4byte	0x26cd
	.8byte	.LFB344
	.8byte	.LFE344-.LFB344
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x9f74
	.uleb128 0x47
	.4byte	0x26dd
	.4byte	.LLST299
	.uleb128 0x75
	.4byte	0x26e8
	.byte	0
	.uleb128 0x71
	.4byte	0x26f3
	.uleb128 0x71
	.4byte	0x26fe
	.uleb128 0x68
	.8byte	.LBB246
	.8byte	.LBE246-.LBB246
	.uleb128 0x47
	.4byte	0x26dd
	.4byte	.LLST300
	.uleb128 0x68
	.8byte	.LBB247
	.8byte	.LBE247-.LBB247
	.uleb128 0x71
	.4byte	0x9e64
	.uleb128 0x72
	.4byte	0x9e6a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x72
	.4byte	0x9e6f
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x76
	.4byte	0x2709
	.8byte	.LDL1
	.uleb128 0x34
	.8byte	.LVL1220
	.4byte	0x259f
	.4byte	0x9ee7
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
	.8byte	.LVL1222
	.4byte	0x259f
	.4byte	0x9f0a
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
	.8byte	.LVL1223
	.4byte	0x2721
	.4byte	0x9f2c
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
	.8byte	.LVL1224
	.4byte	0x27e7
	.4byte	0x9f53
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
	.8byte	.LVL1226
	.4byte	0x2721
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
	.uleb128 0x6d
	.4byte	0x2e7a
	.8byte	.LFB317
	.8byte	.LFE317-.LFB317
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa04d
	.uleb128 0x47
	.4byte	0x2e8b
	.4byte	.LLST320
	.uleb128 0x71
	.4byte	0x2e97
	.uleb128 0x71
	.4byte	0x2ea3
	.uleb128 0x71
	.4byte	0x2ead
	.uleb128 0x71
	.4byte	0x2eb7
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x1b0
	.uleb128 0x6f
	.4byte	0x2e8b
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x1b0
	.uleb128 0x70
	.4byte	0x9f98
	.4byte	.LLST321
	.uleb128 0x72
	.4byte	0x9f9d
	.uleb128 0x1
	.byte	0x64
	.uleb128 0x70
	.4byte	0x9fa2
	.4byte	.LLST322
	.uleb128 0x72
	.4byte	0x9fa7
	.uleb128 0x1
	.byte	0x6a
	.uleb128 0x45
	.8byte	.LVL1313
	.4byte	0x2ec4
	.uleb128 0x34
	.8byte	.LVL1316
	.4byte	0x6e0c
	.4byte	0xa000
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1320
	.4byte	0xa94d
	.4byte	0xa025
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC97
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1321
	.4byte	0x75ef
	.4byte	0xa03d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8a
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1322
	.4byte	0x7342
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x37c4
	.8byte	.LFB301
	.8byte	.LFE301-.LFB301
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa178
	.uleb128 0x47
	.4byte	0x37d5
	.4byte	.LLST323
	.uleb128 0x71
	.4byte	0x37e1
	.uleb128 0x63
	.8byte	.LBB260
	.8byte	.LBE260-.LBB260
	.4byte	0xa163
	.uleb128 0x47
	.4byte	0x37d5
	.4byte	.LLST324
	.uleb128 0x68
	.8byte	.LBB261
	.8byte	.LBE261-.LBB261
	.uleb128 0x71
	.4byte	0xa071
	.uleb128 0x34
	.8byte	.LVL1331
	.4byte	0x6761
	.4byte	0xa0cf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR42
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1332
	.4byte	0xa94d
	.4byte	0xa102
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
	.2byte	0xa88
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1333
	.4byte	0x3d92
	.4byte	0xa11a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1334
	.4byte	0x2e7a
	.4byte	0xa132
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1335
	.4byte	0xa94d
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
	.2byte	0xa8b
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1338
	.4byte	0x65c5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x5843
	.8byte	.LFB268
	.8byte	.LFE268-.LFB268
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa271
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x1f0
	.uleb128 0x70
	.4byte	0x5851
	.4byte	.LLST327
	.uleb128 0x72
	.4byte	0x585d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x70
	.4byte	0x5869
	.4byte	.LLST328
	.uleb128 0x72
	.4byte	0x5875
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x70
	.4byte	0x5881
	.4byte	.LLST329
	.uleb128 0x34
	.8byte	.LVL1351
	.4byte	0x5c36
	.4byte	0xa1e7
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
	.8byte	.LVL1353
	.4byte	0x29a4
	.4byte	0xa20a
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
	.8byte	.LVL1357
	.4byte	0x259f
	.4byte	0xa222
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1359
	.4byte	0x3804
	.4byte	0xa23a
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x86
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1360
	.4byte	0x27e7
	.4byte	0xa262
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
	.8byte	.LVL1361
	.4byte	0x36c0
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x44bf
	.8byte	.LFB286
	.8byte	.LFE286-.LFB286
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa2b2
	.uleb128 0x2f
	.8byte	.LVL1621
	.4byte	0x5af8
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
	.8byte	.LANCHOR83
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x5439
	.8byte	.LFB271
	.8byte	.LFE271-.LFB271
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa325
	.uleb128 0x34
	.8byte	.LVL1658
	.4byte	0x59d0
	.4byte	0xa2e5
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1659
	.4byte	0xa94d
	.4byte	0xa311
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
	.8byte	.LC100
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1660
	.4byte	0x259f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x313f
	.8byte	.LFB311
	.8byte	.LFE311-.LFB311
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa38b
	.uleb128 0x34
	.8byte	.LVL1801
	.4byte	0x3148
	.4byte	0xa358
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x83
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1802
	.4byte	0x588f
	.4byte	0xa377
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1803
	.4byte	0x3320
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x2d32
	.8byte	.LFB319
	.8byte	.LFE319-.LFB319
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa74d
	.uleb128 0x47
	.4byte	0x2d43
	.4byte	.LLST413
	.uleb128 0x47
	.4byte	0x2d4f
	.4byte	.LLST414
	.uleb128 0x75
	.4byte	0x2d5b
	.byte	0x1
	.uleb128 0x71
	.4byte	0x2d67
	.uleb128 0x71
	.4byte	0x2d73
	.uleb128 0x77
	.4byte	0x2d7f
	.sleb128 -1
	.uleb128 0x71
	.4byte	0x2d8b
	.uleb128 0x71
	.4byte	0x2d97
	.uleb128 0x71
	.4byte	0x2da3
	.uleb128 0x71
	.4byte	0x2daf
	.uleb128 0x71
	.4byte	0x2dbb
	.uleb128 0x71
	.4byte	0x2dc7
	.uleb128 0x71
	.4byte	0x2de3
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x2a0
	.4byte	0xa739
	.uleb128 0x47
	.4byte	0x2d4f
	.4byte	.LLST415
	.uleb128 0x47
	.4byte	0x2d43
	.4byte	.LLST416
	.uleb128 0x73
	.4byte	.Ldebug_ranges0+0x2a0
	.uleb128 0x71
	.4byte	0xa3b8
	.uleb128 0x70
	.4byte	0xa3be
	.4byte	.LLST417
	.uleb128 0x72
	.4byte	0xa3c3
	.uleb128 0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x71
	.4byte	0xa3c8
	.uleb128 0x70
	.4byte	0xa3ce
	.4byte	.LLST418
	.uleb128 0x70
	.4byte	0xa3d3
	.4byte	.LLST419
	.uleb128 0x70
	.4byte	0xa3d8
	.4byte	.LLST420
	.uleb128 0x70
	.4byte	0xa3dd
	.4byte	.LLST421
	.uleb128 0x70
	.4byte	0xa3e2
	.4byte	.LLST422
	.uleb128 0x70
	.4byte	0xa3e7
	.4byte	.LLST423
	.uleb128 0x78
	.4byte	0x2dd3
	.uleb128 0x78
	.4byte	0x2ddb
	.uleb128 0x71
	.4byte	0xa3ec
	.uleb128 0x40
	.4byte	.Ldebug_ranges0+0x2d0
	.4byte	0xa4ee
	.uleb128 0x70
	.4byte	0x2df1
	.4byte	.LLST424
	.uleb128 0x45
	.8byte	.LVL1836
	.4byte	0x3db0
	.uleb128 0x34
	.8byte	.LVL1839
	.4byte	0x6644
	.4byte	0xa4a8
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x8
	.byte	0x40
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1842
	.4byte	0x6644
	.4byte	0xa4bf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1845
	.4byte	0x2ec4
	.uleb128 0x36
	.8byte	.LVL1854
	.4byte	0xa94d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LC104
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1866
	.4byte	0x35af
	.uleb128 0x34
	.8byte	.LVL1867
	.4byte	0x460e
	.4byte	0xa513
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1869
	.4byte	0x6644
	.4byte	0xa52b
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1874
	.4byte	0x2e1a
	.uleb128 0x34
	.8byte	.LVL1876
	.4byte	0x6644
	.4byte	0xa54f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1878
	.4byte	0x36c0
	.4byte	0xa567
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1883
	.4byte	0x35af
	.4byte	0xa57f
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1884
	.4byte	0x36c0
	.4byte	0xa597
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1885
	.4byte	0xa94d
	.4byte	0xa5ca
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
	.8byte	.LANCHOR177
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x296
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1886
	.4byte	0xa94d
	.4byte	0xa5fd
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
	.8byte	.LANCHOR177
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x297
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1887
	.4byte	0xa94d
	.4byte	0xa630
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
	.8byte	.LANCHOR177
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x298
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1888
	.4byte	0x460e
	.4byte	0xa648
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x89
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL1889
	.4byte	0x2e1a
	.uleb128 0x34
	.8byte	.LVL1903
	.4byte	0x29a4
	.4byte	0xa66d
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x87
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1912
	.4byte	0xa94d
	.4byte	0xa6a0
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
	.8byte	.LANCHOR177
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa
	.2byte	0x2bc
	.byte	0
	.uleb128 0x34
	.8byte	.LVL1914
	.4byte	0x5c36
	.4byte	0xa6be
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
	.8byte	.LVL1915
	.4byte	0x308d
	.uleb128 0x34
	.8byte	.LVL1916
	.4byte	0x35ed
	.4byte	0xa6e9
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
	.8byte	.LVL1917
	.4byte	0x2fc7
	.uleb128 0x45
	.8byte	.LVL1921
	.4byte	0x2fc7
	.uleb128 0x45
	.8byte	.LVL1922
	.4byte	0x37c4
	.uleb128 0x45
	.8byte	.LVL1923
	.4byte	0x7d59
	.uleb128 0x45
	.8byte	.LVL1924
	.4byte	0x5d63
	.uleb128 0x45
	.8byte	.LVL1925
	.4byte	0x5694
	.byte	0
	.byte	0
	.uleb128 0x36
	.8byte	.LVL1849
	.4byte	0x3320
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x6d
	.4byte	0x3f98
	.8byte	.LFB292
	.8byte	.LFE292-.LFB292
	.uleb128 0x1
	.byte	0x9c
	.4byte	0xa92a
	.uleb128 0x75
	.4byte	0x3fa9
	.byte	0
	.uleb128 0x63
	.8byte	.LBB304
	.8byte	.LBE304-.LBB304
	.4byte	0xa894
	.uleb128 0x71
	.4byte	0xa768
	.uleb128 0x63
	.8byte	.LBB305
	.8byte	.LBE305-.LBB305
	.4byte	0xa7a7
	.uleb128 0x70
	.4byte	0x3fb4
	.4byte	.LLST464
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2106
	.4byte	0x43a6
	.4byte	0xa7bf
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2107
	.4byte	0x43a6
	.4byte	0xa7d7
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2109
	.4byte	0x588f
	.4byte	0xa7f6
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR144
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2110
	.4byte	0x588f
	.4byte	0xa815
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0x3
	.8byte	.LANCHOR149
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2111
	.4byte	0x5d63
	.uleb128 0x45
	.8byte	.LVL2112
	.4byte	0x5694
	.uleb128 0x45
	.8byte	.LVL2113
	.4byte	0x5694
	.uleb128 0x45
	.8byte	.LVL2117
	.4byte	0x2f73
	.uleb128 0x45
	.8byte	.LVL2118
	.4byte	0x2f73
	.uleb128 0x34
	.8byte	.LVL2119
	.4byte	0x3932
	.4byte	0xa86e
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x85
	.sleb128 0
	.byte	0
	.uleb128 0x34
	.8byte	.LVL2120
	.4byte	0x3932
	.4byte	0xa886
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x84
	.sleb128 0
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2121
	.4byte	0x425d
	.byte	0
	.uleb128 0x45
	.8byte	.LVL2093
	.4byte	0x6bd9
	.uleb128 0x45
	.8byte	.LVL2094
	.4byte	0x5446
	.uleb128 0x45
	.8byte	.LVL2095
	.4byte	0x5201
	.uleb128 0x45
	.8byte	.LVL2096
	.4byte	0x4f40
	.uleb128 0x45
	.8byte	.LVL2097
	.4byte	0x4fe5
	.uleb128 0x45
	.8byte	.LVL2098
	.4byte	0x445e
	.uleb128 0x45
	.8byte	.LVL2099
	.4byte	0x5439
	.uleb128 0x45
	.8byte	.LVL2100
	.4byte	0x6a65
	.uleb128 0x45
	.8byte	.LVL2101
	.4byte	0x44c8
	.uleb128 0x45
	.8byte	.LVL2102
	.4byte	0x46c6
	.uleb128 0x36
	.8byte	.LVL2103
	.4byte	0x5944
	.uleb128 0x30
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x79
	.4byte	.LASF875
	.4byte	.LASF875
	.byte	0xb
	.byte	0x72
	.uleb128 0x7a
	.4byte	.LASF876
	.4byte	.LASF876
	.byte	0x1c
	.2byte	0x16d
	.uleb128 0x7a
	.4byte	.LASF877
	.4byte	.LASF877
	.byte	0x1c
	.2byte	0x16c
	.uleb128 0x79
	.4byte	.LASF878
	.4byte	.LASF878
	.byte	0x1d
	.byte	0x12
	.uleb128 0x79
	.4byte	.LASF879
	.4byte	.LASF879
	.byte	0x6
	.byte	0x35
	.uleb128 0x7a
	.4byte	.LASF880
	.4byte	.LASF880
	.byte	0x1c
	.2byte	0x399
	.uleb128 0x79
	.4byte	.LASF881
	.4byte	.LASF881
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
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x69
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
	.uleb128 0x6a
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
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6c
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
	.uleb128 0x6d
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
	.uleb128 0x6e
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6f
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x70
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x71
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x72
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x73
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x74
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
	.uleb128 0xa
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x77
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x78
	.uleb128 0xa
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x79
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
	.uleb128 0x5
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST470:
	.8byte	.LVL2174
	.8byte	.LVL2175-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2175-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST471:
	.8byte	.LVL2174
	.8byte	.LVL2175-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2175-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST472:
	.8byte	.LVL2174
	.8byte	.LVL2175-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2175-1
	.8byte	.LFE348
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST305:
	.8byte	.LVL1242
	.8byte	.LVL1243-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1243-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST306:
	.8byte	.LVL1242
	.8byte	.LVL1243-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1243-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST307:
	.8byte	.LVL1242
	.8byte	.LVL1243-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1243-1
	.8byte	.LFE347
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST198:
	.8byte	.LVL739
	.8byte	.LVL740-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL740-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST199:
	.8byte	.LVL739
	.8byte	.LVL740-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL740-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST200:
	.8byte	.LVL739
	.8byte	.LVL740-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL740-1
	.8byte	.LFE346
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST301:
	.8byte	.LVL1228
	.8byte	.LVL1230-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1230-1
	.8byte	.LVL1238
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1238
	.8byte	.LVL1239
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1239
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST302:
	.8byte	.LVL1228
	.8byte	.LVL1229
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1229
	.8byte	.LVL1238
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1238
	.8byte	.LVL1239
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1239
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST303:
	.8byte	.LVL1232
	.8byte	.LVL1233
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1234
	.8byte	.LVL1235
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1235
	.8byte	.LFE345
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST304:
	.8byte	.LVL1236
	.8byte	.LVL1237
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1239
	.8byte	.LVL1240
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1240
	.8byte	.LVL1241
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST177:
	.8byte	.LVL664
	.8byte	.LVL668
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL668
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST178:
	.8byte	.LVL664
	.8byte	.LVL665
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL665
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST179:
	.8byte	.LVL664
	.8byte	.LVL666
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL666
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST180:
	.8byte	.LVL667
	.8byte	.LVL668
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST181:
	.8byte	.LVL672
	.8byte	.LVL673
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL674
	.8byte	.LVL675
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL676
	.8byte	.LVL677
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST182:
	.8byte	.LVL664
	.8byte	.LVL668
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL668
	.8byte	.LFE343
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST183:
	.8byte	.LVL667
	.8byte	.LVL669
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL670
	.8byte	.LFE343
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST169:
	.8byte	.LVL640
	.8byte	.LVL645
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL645
	.8byte	.LVL646
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL646
	.8byte	.LVL649
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL649
	.8byte	.LVL658
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL658
	.8byte	.LVL663
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL663
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST170:
	.8byte	.LVL640
	.8byte	.LVL641
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL641
	.8byte	.LFE342
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST171:
	.8byte	.LVL640
	.8byte	.LVL642
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL642
	.8byte	.LVL647
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL647
	.8byte	.LVL649
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL649
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST172:
	.8byte	.LVL640
	.8byte	.LVL643
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL643
	.8byte	.LVL646
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL646
	.8byte	.LVL649
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL649
	.8byte	.LVL658
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL658
	.8byte	.LVL663
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL663
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST173:
	.8byte	.LVL644
	.8byte	.LVL645
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST174:
	.8byte	.LVL652
	.8byte	.LVL653
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL654
	.8byte	.LVL655
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL656
	.8byte	.LVL657
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST175:
	.8byte	.LVL644
	.8byte	.LVL648
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL649
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST176:
	.8byte	.LVL644
	.8byte	.LVL645
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL645
	.8byte	.LVL646
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL646
	.8byte	.LVL649
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL649
	.8byte	.LVL658
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL658
	.8byte	.LVL663
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL663
	.8byte	.LFE342
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST154:
	.8byte	.LVL597
	.8byte	.LVL601
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL601
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST155:
	.8byte	.LVL597
	.8byte	.LVL599
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL599
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST156:
	.8byte	.LVL597
	.8byte	.LVL598
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL598
	.8byte	.LFE341
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST157:
	.8byte	.LVL600
	.8byte	.LVL601
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST158:
	.8byte	.LVL606
	.8byte	.LVL607
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL607
	.8byte	.LVL608-1
	.2byte	0x2
	.byte	0x83
	.sleb128 0
	.8byte	.LVL608
	.8byte	.LVL609
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST159:
	.8byte	.LVL600
	.8byte	.LVL602
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL603
	.8byte	.LFE341
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST145:
	.8byte	.LVL582
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL584
	.8byte	.LVL588
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL588
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST146:
	.8byte	.LVL582
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL584
	.8byte	.LVL586
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL586
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST147:
	.8byte	.LVL582
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL584
	.8byte	.LVL587
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL587
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST148:
	.8byte	.LVL582
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL584
	.8byte	.LVL588
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL588
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST149:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL584
	.8byte	.LVL585
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL589
	.8byte	.LVL594
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL594
	.8byte	.LVL595
	.2byte	0x3
	.byte	0x83
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL596
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST150:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL584
	.8byte	.LVL585
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL589
	.8byte	.LVL593
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL593
	.8byte	.LVL594
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL594
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST151:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL584
	.8byte	.LVL586
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL586
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST152:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL584
	.8byte	.LVL586
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL586
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST153:
	.8byte	.LVL583
	.8byte	.LVL584
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL584
	.8byte	.LVL586
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL586
	.8byte	.LVL589
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL589
	.8byte	.LFE339
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST144:
	.8byte	.LVL580
	.8byte	.LVL581-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL581-1
	.8byte	.LFE338
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST142:
	.8byte	.LVL578
	.8byte	.LVL579-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL579-1
	.8byte	.LFE337
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST143:
	.8byte	.LVL578
	.8byte	.LVL579-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL579-1
	.8byte	.LFE337
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST139:
	.8byte	.LVL563
	.8byte	.LVL564
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL564
	.8byte	.LVL575
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL575
	.8byte	.LFE315
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST140:
	.8byte	.LVL569
	.8byte	.LVL570
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL570
	.8byte	.LVL571
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL572
	.8byte	.LVL573
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST141:
	.8byte	.LVL566
	.8byte	.LVL567
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL567
	.8byte	.LVL574
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST138:
	.8byte	.LVL559
	.8byte	.LVL560
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL560
	.8byte	.LVL561-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL561-1
	.8byte	.LVL562
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL562
	.8byte	.LFE314
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST411:
	.8byte	.LVL1810
	.8byte	.LVL1811
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1811
	.8byte	.LVL1812-1
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1814
	.8byte	.LVL1815-1
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1818
	.8byte	.LVL1822
	.2byte	0x1
	.byte	0x5b
	.8byte	.LVL1823
	.8byte	.LVL1824
	.2byte	0x1
	.byte	0x5b
	.8byte	0
	.8byte	0
.LLST412:
	.8byte	.LVL1819
	.8byte	.LVL1820
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1820
	.8byte	.LVL1821-1
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
.LLST288:
	.8byte	.LVL1173
	.8byte	.LVL1174
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1174
	.8byte	.LVL1214
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1214
	.8byte	.LFE310
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST289:
	.8byte	.LVL1173
	.8byte	.LVL1176-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1176-1
	.8byte	.LVL1177
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1177
	.8byte	.LVL1179
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1179
	.8byte	.LVL1216
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1216
	.8byte	.LFE310
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST290:
	.8byte	.LVL1190
	.8byte	.LVL1191
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1191
	.8byte	.LVL1194
	.2byte	0x2
	.byte	0x75
	.sleb128 0
	.8byte	.LVL1194
	.8byte	.LVL1195
	.2byte	0x2
	.byte	0x75
	.sleb128 -2
	.8byte	0
	.8byte	0
.LLST291:
	.8byte	.LVL1182
	.8byte	.LVL1183
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1183
	.8byte	.LVL1184-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1189
	.8byte	.LVL1192
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1193
	.8byte	.LVL1195
	.2byte	0x1
	.byte	0x53
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
	.8byte	.LVL1182
	.8byte	.LVL1183
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST294:
	.8byte	.LVL1181
	.8byte	.LVL1185
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1188
	.8byte	.LVL1195
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1198
	.8byte	.LVL1199
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1199
	.8byte	.LVL1203-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1204
	.8byte	.LVL1205
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1207
	.8byte	.LVL1209-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1212
	.8byte	.LVL1213
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST295:
	.8byte	.LVL1175
	.8byte	.LVL1186
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1188
	.8byte	.LVL1208
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1210
	.8byte	.LVL1212
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1212
	.8byte	.LVL1214
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST296:
	.8byte	.LVL1196
	.8byte	.LVL1202
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1204
	.8byte	.LVL1206-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1207
	.8byte	.LVL1209-1
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST297:
	.8byte	.LVL1173
	.8byte	.LVL1180
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1180
	.8byte	.LVL1187
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1187
	.8byte	.LVL1188
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1188
	.8byte	.LVL1215
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST298:
	.8byte	.LVL1200
	.8byte	.LVL1201
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1201
	.8byte	.LVL1202
	.2byte	0x2
	.byte	0x75
	.sleb128 16
	.8byte	.LVL1204
	.8byte	.LVL1205
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1205
	.8byte	.LVL1206-1
	.2byte	0x2
	.byte	0x75
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST406:
	.8byte	.LVL1764
	.8byte	.LVL1766
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1766
	.8byte	.LVL1767
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1767
	.8byte	.LVL1769
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1769
	.8byte	.LFE308
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST407:
	.8byte	.LVL1778
	.8byte	.LVL1781
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1781
	.8byte	.LVL1784
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1787
	.8byte	.LVL1797
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1798
	.8byte	.LFE308
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST408:
	.8byte	.LVL1770
	.8byte	.LVL1772
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1777
	.8byte	.LVL1778
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1792
	.8byte	.LVL1793
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1793
	.8byte	.LVL1795
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST409:
	.8byte	.LVL1765
	.8byte	.LVL1766
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1767
	.8byte	.LVL1768
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1768
	.8byte	.LVL1770
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.8byte	.LVL1770
	.8byte	.LVL1771-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1776
	.8byte	.LVL1777
	.2byte	0x2
	.byte	0x32
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST410:
	.8byte	.LVL1788
	.8byte	.LVL1799
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST133:
	.8byte	.LVL547
	.8byte	.LVL548
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL548
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST134:
	.8byte	.LVL547
	.8byte	.LVL549-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL549-1
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x5a
	.8byte	0
	.8byte	0
.LLST135:
	.8byte	.LVL547
	.8byte	.LVL549-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL549-1
	.8byte	.LFE307
	.2byte	0x1
	.byte	0x58
	.8byte	0
	.8byte	0
.LLST136:
	.8byte	.LVL550
	.8byte	.LVL553
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL553
	.8byte	.LVL554
	.2byte	0x7
	.byte	0x73
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0x75
	.sleb128 0
	.byte	0x22
	.8byte	.LVL554
	.8byte	.LVL555
	.2byte	0x1
	.byte	0x57
	.8byte	.LVL555
	.8byte	.LVL557
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL557
	.8byte	.LVL558
	.2byte	0x1
	.byte	0x57
	.8byte	0
	.8byte	0
.LLST137:
	.8byte	.LVL550
	.8byte	.LVL551
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL552
	.8byte	.LVL556
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST131:
	.8byte	.LVL543
	.8byte	.LVL545
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL545
	.8byte	.LFE306
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST132:
	.8byte	.LVL543
	.8byte	.LVL544
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL544
	.8byte	.LVL546
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST129:
	.8byte	.LVL537
	.8byte	.LVL538
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL539
	.8byte	.LVL540
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST130:
	.8byte	.LVL535
	.8byte	.LVL536
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL536
	.8byte	.LVL541
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL542
	.8byte	.LFE305
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST127:
	.8byte	.LVL529
	.8byte	.LVL530
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL531
	.8byte	.LVL534
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST128:
	.8byte	.LVL527
	.8byte	.LVL528
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL528
	.8byte	.LVL532
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL533
	.8byte	.LFE304
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST126:
	.8byte	.LVL520
	.8byte	.LVL521
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL522
	.8byte	.LVL523
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL524
	.8byte	.LVL525
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL526
	.8byte	.LFE303
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST325:
	.8byte	.LVL1339
	.8byte	.LVL1340
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1340
	.8byte	.LVL1344
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1344
	.8byte	.LFE302
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST326:
	.8byte	.LVL1339
	.8byte	.LVL1343
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1345
	.8byte	.LVL1348
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1348
	.8byte	.LFE302
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST123:
	.8byte	.LVL506
	.8byte	.LVL507
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL507
	.8byte	.LVL516
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL516
	.8byte	.LVL517
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL517
	.8byte	.LFE300
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST124:
	.8byte	.LVL511
	.8byte	.LVL513
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL517
	.8byte	.LVL518
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL519
	.8byte	.LFE300
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST125:
	.8byte	.LVL506
	.8byte	.LVL512
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL512
	.8byte	.LVL515
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL515
	.8byte	.LVL517
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL517
	.8byte	.LFE300
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST391:
	.8byte	.LVL1700
	.8byte	.LVL1702
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1702
	.8byte	.LVL1710
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1710
	.8byte	.LVL1712
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1712
	.8byte	.LFE299
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST392:
	.8byte	.LVL1701
	.8byte	.LVL1711
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1712
	.8byte	.LFE299
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST312:
	.8byte	.LVL1266
	.8byte	.LVL1267
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1267
	.8byte	.LVL1307
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1307
	.8byte	.LFE298
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST313:
	.8byte	.LVL1274
	.8byte	.LVL1279
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1280
	.8byte	.LVL1307
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST314:
	.8byte	.LVL1282
	.8byte	.LVL1294
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1295
	.8byte	.LVL1308
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST315:
	.8byte	.LVL1286
	.8byte	.LVL1287
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1288
	.8byte	.LVL1289
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1289
	.8byte	.LVL1293
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1299
	.8byte	.LVL1303
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1303
	.8byte	.LVL1304
	.2byte	0x3
	.byte	0x88
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1305
	.8byte	.LVL1309
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST316:
	.8byte	.LVL1288
	.8byte	.LVL1289
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1289
	.8byte	.LVL1290-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1299
	.8byte	.LVL1300
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1300
	.8byte	.LVL1301
	.2byte	0x3
	.byte	0x71
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1301
	.8byte	.LVL1302-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1302-1
	.8byte	.LVL1303
	.2byte	0x3
	.byte	0x8f
	.sleb128 196
	.8byte	.LVL1303
	.8byte	.LVL1305
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST317:
	.8byte	.LVL1266
	.8byte	.LVL1268
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1270
	.8byte	.LVL1271
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1271
	.8byte	.LVL1272
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1272
	.8byte	.LVL1273-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST318:
	.8byte	.LVL1296
	.8byte	.LVL1298
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST319:
	.8byte	.LVL1296
	.8byte	.LVL1298
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST114:
	.8byte	.LVL476
	.8byte	.LVL480
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL481
	.8byte	.LVL490
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL498
	.8byte	.LVL500
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST115:
	.8byte	.LVL476
	.8byte	.LVL480
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL481
	.8byte	.LVL490
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL490
	.8byte	.LVL491
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL491
	.8byte	.LVL496
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL496
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST116:
	.8byte	.LVL476
	.8byte	.LVL480
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL481
	.8byte	.LVL490
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL490
	.8byte	.LVL494
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL496
	.8byte	.LVL499
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL500
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST117:
	.8byte	.LVL490
	.8byte	.LVL491
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL496
	.8byte	.LVL497
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL501
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST118:
	.8byte	.LVL488
	.8byte	.LVL489
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL489
	.8byte	.LVL495-1
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL496
	.8byte	.LFE296
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST119:
	.8byte	.LVL492
	.8byte	.LVL495-1
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST120:
	.8byte	.LVL477
	.8byte	.LVL478
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL478
	.8byte	.LVL479
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL481
	.8byte	.LVL482
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL483
	.8byte	.LVL484
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL484
	.8byte	.LVL486
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST103:
	.8byte	.LVL305
	.8byte	.LVL306
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL306
	.8byte	.LVL308
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL308
	.8byte	.LVL311
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
	.8byte	.LVL311
	.8byte	.LVL314
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL314
	.8byte	.LFE295
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST104:
	.8byte	.LVL305
	.8byte	.LVL310
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL310
	.8byte	.LVL311
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL311
	.8byte	.LVL315
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL315
	.8byte	.LFE295
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST105:
	.8byte	.LVL307
	.8byte	.LVL309
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL311
	.8byte	.LVL314
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST106:
	.8byte	.LVL307
	.8byte	.LVL312
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL313
	.8byte	.LVL314
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST102:
	.8byte	.LVL301
	.8byte	.LVL302
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL302
	.8byte	.LVL303
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL303
	.8byte	.LVL304
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL304
	.8byte	.LFE294
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST98:
	.8byte	.LVL287
	.8byte	.LVL288
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL288
	.8byte	.LVL291
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL291
	.8byte	.LFE293
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST99:
	.8byte	.LVL287
	.8byte	.LVL289
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL289
	.8byte	.LVL298
	.2byte	0x1
	.byte	0x57
	.8byte	.LVL298
	.8byte	.LVL299
	.2byte	0x3
	.byte	0x77
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL299
	.8byte	.LFE293
	.2byte	0x1
	.byte	0x57
	.8byte	0
	.8byte	0
.LLST100:
	.8byte	.LVL295
	.8byte	.LVL296-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST101:
	.8byte	.LVL287
	.8byte	.LVL289
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL289
	.8byte	.LVL293
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL294
	.8byte	.LVL297
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL298
	.8byte	.LFE293
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST251:
	.8byte	.LVL956
	.8byte	.LVL957
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL958
	.8byte	.LFE291
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST252:
	.8byte	.LVL961
	.8byte	.LVL963
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST283:
	.8byte	.LVL1146
	.8byte	.LVL1147
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1149
	.8byte	.LVL1150
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1158
	.8byte	.LVL1161
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1162
	.8byte	.LVL1163
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1163
	.8byte	.LVL1168
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1169
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST284:
	.8byte	.LVL1144
	.8byte	.LVL1145
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1153
	.8byte	.LVL1158
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST285:
	.8byte	.LVL1149
	.8byte	.LVL1150
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1155
	.8byte	.LVL1156
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1163
	.8byte	.LVL1166
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1167
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST286:
	.8byte	.LVL1142
	.8byte	.LVL1146
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1146
	.8byte	.LVL1151
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1151
	.8byte	.LVL1152
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL1153
	.8byte	.LVL1158
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1158
	.8byte	.LVL1164
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1165
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST287:
	.8byte	.LVL1148
	.8byte	.LVL1150
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1163
	.8byte	.LFE290
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST388:
	.8byte	.LVL1686
	.8byte	.LVL1687
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1693
	.8byte	.LVL1698
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1699
	.8byte	.LFE289
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST389:
	.8byte	.LVL1684
	.8byte	.LVL1685
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1688
	.8byte	.LVL1693
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST390:
	.8byte	.LVL1690
	.8byte	.LVL1691
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST356:
	.8byte	.LVL1510
	.8byte	.LVL1511
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1511
	.8byte	.LVL1515
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1515
	.8byte	.LVL1516
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1516
	.8byte	.LFE288
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST357:
	.8byte	.LVL1518
	.8byte	.LVL1519
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1519
	.8byte	.LVL1520-1
	.2byte	0x9
	.byte	0x3
	.8byte	p_sys_spare_buf
	.8byte	0
	.8byte	0
.LLST358:
	.8byte	.LVL1510
	.8byte	.LVL1511
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL1511
	.8byte	.LVL1512
	.2byte	0x3
	.byte	0x85
	.sleb128 -2
	.byte	0x9f
	.8byte	.LVL1512
	.8byte	.LVL1513
	.2byte	0x3
	.byte	0x85
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1513
	.8byte	.LVL1514
	.2byte	0x3
	.byte	0x85
	.sleb128 -2
	.byte	0x9f
	.8byte	.LVL1516
	.8byte	.LFE288
	.2byte	0x3
	.byte	0x85
	.sleb128 -2
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST277:
	.8byte	.LVL1118
	.8byte	.LVL1119
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1119
	.8byte	.LVL1130
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1131
	.8byte	.LVL1140
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST278:
	.8byte	.LVL1120
	.8byte	.LVL1124
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1124
	.8byte	.LVL1125
	.2byte	0x3
	.byte	0x76
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1125
	.8byte	.LVL1129-1
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1132
	.8byte	.LVL1137-1
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST279:
	.8byte	.LVL1121
	.8byte	.LVL1122-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST280:
	.8byte	.LVL1120
	.8byte	.LVL1123
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1124
	.8byte	.LVL1129-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1132
	.8byte	.LVL1133
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1134
	.8byte	.LVL1137-1
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST281:
	.8byte	.LVL1118
	.8byte	.LVL1119
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1119
	.8byte	.LVL1135
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1136
	.8byte	.LVL1138
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1138
	.8byte	.LVL1139-1
	.2byte	0x9
	.byte	0x3
	.8byte	g_num_data_superblocks
	.8byte	0
	.8byte	0
.LLST282:
	.8byte	.LVL1118
	.8byte	.LVL1119
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1119
	.8byte	.LVL1127
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1128
	.8byte	.LVL1141
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST95:
	.8byte	.LVL276
	.8byte	.LVL277
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL277
	.8byte	.LVL280
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL280
	.8byte	.LVL281
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL281
	.8byte	.LFE284
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST96:
	.8byte	.LVL279
	.8byte	.LVL285
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL285
	.8byte	.LVL286
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST97:
	.8byte	.LVL283
	.8byte	.LVL284-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL284-1
	.8byte	.LFE284
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST331:
	.8byte	.LVL1369
	.8byte	.LVL1370
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1370
	.8byte	.LVL1374
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1374
	.8byte	.LVL1375
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1375
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST332:
	.8byte	.LVL1371
	.8byte	.LVL1373
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1375
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST333:
	.8byte	.LVL1371
	.8byte	.LVL1372
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1372
	.8byte	.LVL1373
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1375
	.8byte	.LVL1378-1
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1378-1
	.8byte	.LVL1392
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1392
	.8byte	.LVL1397
	.2byte	0x8
	.byte	0x83
	.sleb128 6
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1397
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
.LLST334:
	.8byte	.LVL1375
	.8byte	.LVL1377
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1377
	.8byte	.LVL1380
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1392
	.8byte	.LVL1393
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1394
	.8byte	.LVL1401
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1436
	.8byte	.LVL1437
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1442
	.8byte	.LVL1443
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1443
	.8byte	.LVL1447
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1506
	.8byte	.LVL1507
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1508
	.8byte	.LVL1509
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST335:
	.8byte	.LVL1435
	.8byte	.LVL1436
	.2byte	0x9
	.byte	0x8f
	.sleb128 324
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL1460
	.8byte	.LVL1462
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1509
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST336:
	.8byte	.LVL1419
	.8byte	.LVL1420
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1421
	.8byte	.LVL1422
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1422
	.8byte	.LVL1423
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1423
	.8byte	.LVL1432
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1433
	.8byte	.LVL1434
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1435
	.8byte	.LVL1436
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1436
	.8byte	.LVL1440
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1441
	.8byte	.LVL1447
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1447
	.8byte	.LVL1452
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1452
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST337:
	.8byte	.LVL1389
	.8byte	.LVL1392
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1416
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST338:
	.8byte	.LVL1387
	.8byte	.LVL1392
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1411
	.8byte	.LVL1412
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1416
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST339:
	.8byte	.LVL1376
	.8byte	.LVL1378-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1392
	.8byte	.LVL1395
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1396
	.8byte	.LVL1397
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1402
	.8byte	.LVL1403
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1403
	.8byte	.LVL1406
	.2byte	0x2
	.byte	0x74
	.sleb128 0
	.8byte	.LVL1406
	.8byte	.LVL1407
	.2byte	0x2
	.byte	0x74
	.sleb128 -2
	.8byte	.LVL1424
	.8byte	.LVL1427
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1427
	.8byte	.LVL1428
	.2byte	0x2
	.byte	0x72
	.sleb128 0
	.8byte	.LVL1444
	.8byte	.LVL1445
	.2byte	0x6
	.byte	0x8f
	.sleb128 328
	.byte	0x6
	.byte	0x32
	.byte	0x1c
	.8byte	.LVL1445
	.8byte	.LVL1446
	.2byte	0x2
	.byte	0x74
	.sleb128 -4
	.8byte	.LVL1453
	.8byte	.LVL1456
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1456
	.8byte	.LVL1457
	.2byte	0x2
	.byte	0x72
	.sleb128 0
	.8byte	.LVL1457
	.8byte	.LVL1458
	.2byte	0x2
	.byte	0x72
	.sleb128 -2
	.8byte	.LVL1506
	.8byte	.LVL1509
	.2byte	0x2
	.byte	0x74
	.sleb128 -4
	.8byte	0
	.8byte	0
.LLST340:
	.8byte	.LVL1379
	.8byte	.LVL1381
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1381
	.8byte	.LVL1390
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1397
	.8byte	.LVL1398
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1398
	.8byte	.LVL1421
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1422
	.8byte	.LVL1423
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST342:
	.8byte	.LVL1382
	.8byte	.LVL1386
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1401
	.8byte	.LVL1404
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1405
	.8byte	.LVL1411
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1412
	.8byte	.LVL1416
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1423
	.8byte	.LVL1425
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1426
	.8byte	.LVL1429
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1436
	.8byte	.LVL1437
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1437
	.8byte	.LVL1439
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1452
	.8byte	.LVL1454
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1455
	.8byte	.LVL1458
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST343:
	.8byte	.LVL1384
	.8byte	.LVL1385
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1385
	.8byte	.LVL1387
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1407
	.8byte	.LVL1410
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1412
	.8byte	.LVL1414
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1415
	.8byte	.LVL1416
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST344:
	.8byte	.LVL1430
	.8byte	.LVL1431
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1438
	.8byte	.LVL1439
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST345:
	.8byte	.LVL1461
	.8byte	.LVL1465
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1467
	.8byte	.LVL1477
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1477
	.8byte	.LVL1480
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1480
	.8byte	.LVL1502
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1502
	.8byte	.LVL1504
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1504
	.8byte	.LVL1506
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST346:
	.8byte	.LVL1461
	.8byte	.LVL1465
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1467
	.8byte	.LVL1475
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1480
	.8byte	.LVL1495
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1495
	.8byte	.LVL1497
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1504
	.8byte	.LVL1506
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST347:
	.8byte	.LVL1384
	.8byte	.LVL1392
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1407
	.8byte	.LFE281
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST348:
	.8byte	.LVL1369
	.8byte	.LVL1373
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1375
	.8byte	.LVL1385
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1385
	.8byte	.LVL1390
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1392
	.8byte	.LVL1407
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1407
	.8byte	.LVL1418
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1418
	.8byte	.LVL1434
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1447
	.8byte	.LVL1452
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST349:
	.8byte	.LVL1408
	.8byte	.LVL1412
	.2byte	0x1
	.byte	0x58
	.8byte	.LVL1448
	.8byte	.LVL1449
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL1449
	.8byte	.LVL1450
	.2byte	0x2
	.byte	0x70
	.sleb128 0
	.8byte	.LVL1450
	.8byte	.LVL1451
	.2byte	0x2
	.byte	0x70
	.sleb128 -32
	.8byte	.LVL1463
	.8byte	.LVL1464
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1467
	.8byte	.LVL1470-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1472
	.8byte	.LVL1473-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1473-1
	.8byte	.LVL1474
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1482
	.8byte	.LVL1483
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1486
	.8byte	.LVL1487-1
	.2byte	0x2
	.byte	0x74
	.sleb128 16
	.8byte	.LVL1487-1
	.8byte	.LVL1488
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	.LVL1498
	.8byte	.LVL1499-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1499-1
	.8byte	.LVL1502
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	0
	.8byte	0
.LLST350:
	.8byte	.LVL1417
	.8byte	.LVL1434
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1447
	.8byte	.LVL1452
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST351:
	.8byte	.LVL1417
	.8byte	.LVL1421
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1422
	.8byte	.LVL1423
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST352:
	.8byte	.LVL1473
	.8byte	.LVL1474
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	.LVL1482
	.8byte	.LVL1483
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST353:
	.8byte	.LVL1489
	.8byte	.LVL1492
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST354:
	.8byte	.LVL1496
	.8byte	.LVL1502
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST355:
	.8byte	.LVL1499
	.8byte	.LVL1500-1
	.2byte	0x6
	.byte	0x8f
	.sleb128 296
	.byte	0x6
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST245:
	.8byte	.LVL936
	.8byte	.LVL937
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL937
	.8byte	.LVL949
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL949
	.8byte	.LVL950
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL950
	.8byte	.LFE280
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST246:
	.8byte	.LVL936
	.8byte	.LVL938-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST247:
	.8byte	.LVL939
	.8byte	.LVL940
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL940
	.8byte	.LVL944-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL950
	.8byte	.LVL955
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL955
	.8byte	.LFE280
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST248:
	.8byte	.LVL942
	.8byte	.LVL943
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL950
	.8byte	.LVL953
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL954
	.8byte	.LVL955
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST249:
	.8byte	.LVL942
	.8byte	.LVL947
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL950
	.8byte	.LVL951
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL952
	.8byte	.LVL955
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST250:
	.8byte	.LVL941
	.8byte	.LVL944-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL950
	.8byte	.LVL955
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST90:
	.8byte	.LVL261
	.8byte	.LVL262
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL262
	.8byte	.LFE279
	.2byte	0x1
	.byte	0x56
	.8byte	0
	.8byte	0
.LLST91:
	.8byte	.LVL261
	.8byte	.LVL264
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL264
	.8byte	.LFE279
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST92:
	.8byte	.LVL263
	.8byte	.LVL265
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL266
	.8byte	.LVL267
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL268
	.8byte	.LVL269
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST276:
	.8byte	.LVL1106
	.8byte	.LVL1107
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST265:
	.8byte	.LVL1057
	.8byte	.LVL1060
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1060
	.8byte	.LVL1078
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1078
	.8byte	.LVL1084
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST266:
	.8byte	.LVL1066
	.8byte	.LVL1067
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1067
	.8byte	.LVL1082
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST267:
	.8byte	.LVL1071
	.8byte	.LVL1072
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1072
	.8byte	.LVL1073
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1084
	.8byte	.LVL1086
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1087
	.8byte	.LVL1088
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1090
	.8byte	.LVL1091-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1092
	.8byte	.LVL1093
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1094
	.8byte	.LVL1095
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1097
	.8byte	.LVL1102
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1103
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST268:
	.8byte	.LVL1070
	.8byte	.LVL1073
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1084
	.8byte	.LVL1088
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST269:
	.8byte	.LVL1098
	.8byte	.LVL1099
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1099
	.8byte	.LVL1100
	.2byte	0x7
	.byte	0x72
	.sleb128 -1
	.byte	0x32
	.byte	0x24
	.byte	0x7a
	.sleb128 0
	.byte	0x22
	.8byte	.LVL1100
	.8byte	.LVL1101
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
.LLST270:
	.8byte	.LVL1058
	.8byte	.LVL1079
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST271:
	.8byte	.LVL1059
	.8byte	.LVL1068
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1088
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST272:
	.8byte	.LVL1061
	.8byte	.LVL1062
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1062
	.8byte	.LVL1064-1
	.2byte	0x2
	.byte	0x83
	.sleb128 24
	.8byte	.LVL1064-1
	.8byte	.LVL1083
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	.LVL1083
	.8byte	.LVL1084
	.2byte	0x3
	.byte	0x8f
	.sleb128 112
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x3
	.byte	0x8f
	.sleb128 256
	.8byte	0
	.8byte	0
.LLST273:
	.8byte	.LVL1061
	.8byte	.LVL1080
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST274:
	.8byte	.LVL1063
	.8byte	.LVL1083
	.2byte	0x3
	.byte	0x8f
	.sleb128 268
	.8byte	.LVL1083
	.8byte	.LVL1084
	.2byte	0x3
	.byte	0x8f
	.sleb128 124
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x3
	.byte	0x8f
	.sleb128 268
	.8byte	0
	.8byte	0
.LLST275:
	.8byte	.LVL1065
	.8byte	.LVL1081
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1084
	.8byte	.LFE275
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST463:
	.8byte	.LVL2077
	.8byte	.LVL2080
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2089
	.8byte	.LVL2091
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2092
	.8byte	.LFE274
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST89:
	.8byte	.LVL259
	.8byte	.LVL260
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL260
	.8byte	.LFE273
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST258:
	.8byte	.LVL992
	.8byte	.LVL999
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL999
	.8byte	.LVL1000
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1000
	.8byte	.LVL1001
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1003
	.8byte	.LVL1004-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL1004
	.8byte	.LVL1006
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST259:
	.8byte	.LVL991
	.8byte	.LVL1040
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	.LVL1040
	.8byte	.LVL1041
	.2byte	0x3
	.byte	0x8f
	.sleb128 156
	.8byte	.LVL1041
	.8byte	.LFE270
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	0
	.8byte	0
.LLST260:
	.8byte	.LVL994
	.8byte	.LVL995-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL995-1
	.8byte	.LVL998
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1007
	.8byte	.LVL1038
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST261:
	.8byte	.LVL992
	.8byte	.LVL996
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL997
	.8byte	.LVL1001
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1003
	.8byte	.LVL1005
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST262:
	.8byte	.LVL1017
	.8byte	.LVL1018
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1019
	.8byte	.LVL1020
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1021
	.8byte	.LVL1022
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1028
	.8byte	.LVL1029
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1030
	.8byte	.LVL1031
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1032
	.8byte	.LVL1033
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1042
	.8byte	.LVL1047
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1048
	.8byte	.LVL1049
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1050
	.8byte	.LVL1051
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1054
	.8byte	.LVL1055
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1056
	.8byte	.LFE270
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST263:
	.8byte	.LVL1008
	.8byte	.LVL1010
	.2byte	0x8
	.byte	0x40
	.byte	0x8f
	.sleb128 328
	.byte	0x94
	.byte	0x2
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1011
	.8byte	.LVL1012
	.2byte	0x8
	.byte	0x40
	.byte	0x8f
	.sleb128 328
	.byte	0x94
	.byte	0x2
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1012
	.8byte	.LVL1013
	.2byte	0x5
	.byte	0x41
	.byte	0x75
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1016
	.8byte	.LVL1023
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1024
	.8byte	.LVL1025
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1027
	.8byte	.LVL1034
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1035
	.8byte	.LVL1036
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1043
	.8byte	.LVL1044
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1045
	.8byte	.LVL1046
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1051
	.8byte	.LVL1052
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1053
	.8byte	.LVL1054
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST264:
	.8byte	.LVL1007
	.8byte	.LVL1038
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST385:
	.8byte	.LVL1663
	.8byte	.LVL1670
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL1670
	.8byte	.LVL1682
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST386:
	.8byte	.LVL1664
	.8byte	.LVL1681
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST387:
	.8byte	.LVL1663
	.8byte	.LVL1670
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1670
	.8byte	.LVL1676
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1677
	.8byte	.LVL1680
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST254:
	.8byte	.LVL975
	.8byte	.LVL977
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL977
	.8byte	.LVL981
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL981
	.8byte	.LVL982-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL982-1
	.8byte	.LVL982
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL982
	.8byte	.LVL985
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL985
	.8byte	.LFE267
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST255:
	.8byte	.LVL978
	.8byte	.LVL979
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL979
	.8byte	.LVL980-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+4
	.8byte	.LVL982
	.8byte	.LVL983
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL983
	.8byte	.LVL984-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+4
	.8byte	0
	.8byte	0
.LLST256:
	.8byte	.LVL975
	.8byte	.LVL976
	.2byte	0x7
	.byte	0x70
	.sleb128 6
	.byte	0x94
	.byte	0x2
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL985
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
.LLST257:
	.8byte	.LVL975
	.8byte	.LVL976
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	.LVL985
	.8byte	.LFE267
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	0
	.8byte	0
.LLST375:
	.8byte	.LVL1622
	.8byte	.LVL1625
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1625
	.8byte	.LVL1629
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1629
	.8byte	.LVL1630
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1630
	.8byte	.LFE265
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST376:
	.8byte	.LVL1622
	.8byte	.LVL1623
	.2byte	0x3
	.byte	0x8
	.byte	0x20
	.byte	0x9f
	.8byte	.LVL1623
	.8byte	.LVL1624
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL1624
	.8byte	.LVL1626
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1629
	.8byte	.LVL1630
	.2byte	0x3
	.byte	0x8
	.byte	0x20
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST377:
	.8byte	.LVL1631
	.8byte	.LVL1634
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1634
	.8byte	.LVL1638
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1639
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST378:
	.8byte	.LVL1631
	.8byte	.LVL1632
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1632
	.8byte	.LVL1637
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1639
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST379:
	.8byte	.LVL1631
	.8byte	.LVL1635
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1635
	.8byte	.LVL1636
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1639
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1657
	.8byte	.LFE264
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST380:
	.8byte	.LVL1642
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST381:
	.8byte	.LVL1641
	.8byte	.LVL1644
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1644
	.8byte	.LVL1647-1
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
	.8byte	.LVL1654
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST382:
	.8byte	.LVL1640
	.8byte	.LVL1645
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1645
	.8byte	.LVL1646
	.2byte	0x3
	.byte	0x8f
	.sleb128 212
	.8byte	.LVL1646
	.8byte	.LVL1647-1
	.2byte	0x2
	.byte	0x70
	.sleb128 4
	.8byte	.LVL1654
	.8byte	.LVL1655
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1655
	.8byte	.LVL1656-1
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
.LLST383:
	.8byte	.LVL1631
	.8byte	.LVL1635
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1635
	.8byte	.LVL1636
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1639
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1657
	.8byte	.LFE264
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST384:
	.8byte	.LVL1633
	.8byte	.LVL1634
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
	.8byte	.LVL1634
	.8byte	.LVL1635
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
	.8byte	.LVL1635
	.8byte	.LVL1636
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1639
	.8byte	.LVL1657
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1657
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
.LLST367:
	.8byte	.LVL1593
	.8byte	.LVL1596
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1596
	.8byte	.LVL1600
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1601
	.8byte	.LVL1612
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL1615
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST368:
	.8byte	.LVL1593
	.8byte	.LVL1594
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1594
	.8byte	.LVL1599
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1601
	.8byte	.LVL1611
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1615
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST369:
	.8byte	.LVL1593
	.8byte	.LVL1597
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1597
	.8byte	.LVL1598
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1601
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1620
	.8byte	.LFE263
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST370:
	.8byte	.LVL1604
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST371:
	.8byte	.LVL1603
	.8byte	.LVL1609
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1617
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST372:
	.8byte	.LVL1602
	.8byte	.LVL1606
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1606
	.8byte	.LVL1607
	.2byte	0x3
	.byte	0x8f
	.sleb128 212
	.8byte	.LVL1607
	.8byte	.LVL1608-1
	.2byte	0x2
	.byte	0x70
	.sleb128 4
	.8byte	.LVL1617
	.8byte	.LVL1618
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1618
	.8byte	.LVL1619-1
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
.LLST373:
	.8byte	.LVL1593
	.8byte	.LVL1597
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1597
	.8byte	.LVL1598
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1601
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1620
	.8byte	.LFE263
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST374:
	.8byte	.LVL1595
	.8byte	.LVL1596
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
	.8byte	.LVL1596
	.8byte	.LVL1597
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
	.8byte	.LVL1597
	.8byte	.LVL1598
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1601
	.8byte	.LVL1613
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1613
	.8byte	.LVL1614-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1614-1
	.8byte	.LVL1615
	.2byte	0x3
	.byte	0x85
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1615
	.8byte	.LVL1620
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1620
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
.LLST239:
	.8byte	.LVL916
	.8byte	.LVL920
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL920
	.8byte	.LFE262
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST240:
	.8byte	.LVL916
	.8byte	.LVL917
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL917
	.8byte	.LVL934
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL934
	.8byte	.LVL935
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL935
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST241:
	.8byte	.LVL916
	.8byte	.LVL921
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL921
	.8byte	.LVL934
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL934
	.8byte	.LVL935
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL935
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST242:
	.8byte	.LVL922
	.8byte	.LVL923
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL924
	.8byte	.LVL926
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL926
	.8byte	.LVL927-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL927-1
	.8byte	.LVL929
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL929
	.8byte	.LVL931
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL935
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST243:
	.8byte	.LVL918
	.8byte	.LVL933
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL935
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST244:
	.8byte	.LVL919
	.8byte	.LVL932
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL935
	.8byte	.LFE262
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST330:
	.8byte	.LVL1363
	.8byte	.LVL1364
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1365
	.8byte	.LVL1367
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1368
	.8byte	.LFE261
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST83:
	.8byte	.LVL228
	.8byte	.LVL229
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL230
	.8byte	.LVL231
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL231
	.8byte	.LVL233
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL235
	.8byte	.LVL236
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL238
	.8byte	.LVL239
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL240
	.8byte	.LVL243
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL244
	.8byte	.LVL248
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL249
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST84:
	.8byte	.LVL232
	.8byte	.LVL234
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL235
	.8byte	.LVL238
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL240
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST85:
	.8byte	.LVL232
	.8byte	.LVL235
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL235
	.8byte	.LVL237-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL240
	.8byte	.LVL241
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL242
	.8byte	.LVL245
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL245
	.8byte	.LVL246
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL247
	.8byte	.LFE260
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST237:
	.8byte	.LVL911
	.8byte	.LVL912
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL912
	.8byte	.LFE259
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST238:
	.8byte	.LVL913
	.8byte	.LVL914
	.2byte	0x9
	.byte	0x71
	.sleb128 0
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL914
	.8byte	.LVL915-1
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST224:
	.8byte	.LVL871
	.8byte	.LVL872
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL872
	.8byte	.LVL886
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL886
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST225:
	.8byte	.LVL871
	.8byte	.LVL872
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL872
	.8byte	.LVL887
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL887
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST226:
	.8byte	.LVL871
	.8byte	.LVL872
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL872
	.8byte	.LVL885
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL885
	.8byte	.LFE258
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST227:
	.8byte	.LVL876
	.8byte	.LVL877-1
	.2byte	0x7
	.byte	0x73
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL877-1
	.8byte	.LVL888
	.2byte	0xa
	.byte	0x8f
	.sleb128 204
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL888
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
.LLST228:
	.8byte	.LVL878
	.8byte	.LVL879
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL879
	.8byte	.LVL880-1
	.2byte	0x9
	.byte	0x3
	.8byte	req_sys+16
	.8byte	0
	.8byte	0
.LLST229:
	.8byte	.LVL871
	.8byte	.LVL872
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL872
	.8byte	.LVL881
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL882
	.8byte	.LVL884
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST218:
	.8byte	.LVL849
	.8byte	.LVL851
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL851
	.8byte	.LVL855
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL855
	.8byte	.LVL856
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL856
	.8byte	.LFE257
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST219:
	.8byte	.LVL860
	.8byte	.LVL861
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL861
	.8byte	.LVL863
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL866
	.8byte	.LVL869
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL869
	.8byte	.LVL870
	.2byte	0x3
	.byte	0x71
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST220:
	.8byte	.LVL860
	.8byte	.LVL861
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL861
	.8byte	.LVL862
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL866
	.8byte	.LVL867
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL868
	.8byte	.LFE257
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST221:
	.8byte	.LVL850
	.8byte	.LVL854
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL856
	.8byte	.LVL857
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL857
	.8byte	.LVL860-1
	.2byte	0x2
	.byte	0x83
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST222:
	.8byte	.LVL850
	.8byte	.LVL851
	.2byte	0x2
	.byte	0x70
	.sleb128 40
	.8byte	.LVL851
	.8byte	.LVL852-1
	.2byte	0x2
	.byte	0x83
	.sleb128 40
	.8byte	.LVL856
	.8byte	.LVL860-1
	.2byte	0x2
	.byte	0x83
	.sleb128 40
	.8byte	0
	.8byte	0
.LLST223:
	.8byte	.LVL858
	.8byte	.LVL859
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL859
	.8byte	.LVL860-1
	.2byte	0x9
	.byte	0x3
	.8byte	p_sys_spare_buf
	.8byte	0
	.8byte	0
.LLST230:
	.8byte	.LVL889
	.8byte	.LVL892-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL892-1
	.8byte	.LVL900
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL900
	.8byte	.LVL902
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL902
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST231:
	.8byte	.LVL894
	.8byte	.LVL898
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL902
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST232:
	.8byte	.LVL892
	.8byte	.LVL893
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST233:
	.8byte	.LVL896
	.8byte	.LVL898
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL902
	.8byte	.LVL907
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL908
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST234:
	.8byte	.LVL890
	.8byte	.LVL896
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST235:
	.8byte	.LVL891
	.8byte	.LVL901
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL902
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST236:
	.8byte	.LVL903
	.8byte	.LVL906
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL909
	.8byte	.LFE256
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST209:
	.8byte	.LVL826
	.8byte	.LVL828
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL828
	.8byte	.LVL833
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL833
	.8byte	.LVL837
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL837
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST210:
	.8byte	.LVL827
	.8byte	.LVL835
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL837
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST211:
	.8byte	.LVL827
	.8byte	.LVL832
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL837
	.8byte	.LVL843
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST212:
	.8byte	.LVL827
	.8byte	.LVL834
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL837
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST213:
	.8byte	.LVL838
	.8byte	.LVL843
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST214:
	.8byte	.LVL829
	.8byte	.LVL830
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL830
	.8byte	.LVL832
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL837
	.8byte	.LVL839
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL840
	.8byte	.LVL843
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST215:
	.8byte	.LVL831
	.8byte	.LVL832
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL832
	.8byte	.LVL833
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL838
	.8byte	.LVL841
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL842
	.8byte	.LVL843
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL843
	.8byte	.LVL847
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL848
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST216:
	.8byte	.LVL831
	.8byte	.LVL836
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL843
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST217:
	.8byte	.LVL831
	.8byte	.LVL832
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL832
	.8byte	.LVL836
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL843
	.8byte	.LVL844
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL845
	.8byte	.LFE254
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST206:
	.8byte	.LVL810
	.8byte	.LVL811
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL811
	.8byte	.LVL817
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL817
	.8byte	.LFE253
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST207:
	.8byte	.LVL810
	.8byte	.LVL812
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL812
	.8byte	.LVL815
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL815
	.8byte	.LFE253
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST208:
	.8byte	.LVL814
	.8byte	.LVL818
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL819
	.8byte	.LFE253
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST67:
	.8byte	.LVL188
	.8byte	.LVL189
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL189
	.8byte	.LVL192
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL194
	.8byte	.LFE251
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST68:
	.8byte	.LVL188
	.8byte	.LVL196
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL196
	.8byte	.LVL197
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
.LLST69:
	.8byte	.LVL190
	.8byte	.LVL191
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL193
	.8byte	.LVL195
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL196
	.8byte	.LVL197
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST66:
	.8byte	.LVL186
	.8byte	.LVL187-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL187-1
	.8byte	.LFE250
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST62:
	.8byte	.LVL173
	.8byte	.LVL178-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL178-1
	.8byte	.LVL180
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL180
	.8byte	.LVL185
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL185
	.8byte	.LFE249
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST63:
	.8byte	.LVL173
	.8byte	.LVL174
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL174
	.8byte	.LVL177
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL180
	.8byte	.LVL181
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL183
	.8byte	.LFE249
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST64:
	.8byte	.LVL173
	.8byte	.LVL176
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL176
	.8byte	.LVL179
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL179
	.8byte	.LVL180
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL180
	.8byte	.LFE249
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST65:
	.8byte	.LVL174
	.8byte	.LVL175
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL180
	.8byte	.LVL184
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST58:
	.8byte	.LVL160
	.8byte	.LVL161
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL161
	.8byte	.LVL166
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL166
	.8byte	.LVL168
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL168
	.8byte	.LFE248
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST59:
	.8byte	.LVL160
	.8byte	.LVL163
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL163
	.8byte	.LFE248
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST60:
	.8byte	.LVL162
	.8byte	.LVL165
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL165
	.8byte	.LVL166
	.2byte	0x6
	.byte	0x87
	.sleb128 0
	.byte	0x85
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL166
	.8byte	.LVL167
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
	.8byte	.LVL168
	.8byte	.LFE248
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST61:
	.8byte	.LVL169
	.8byte	.LVL170
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
	.8byte	.LVL171
	.8byte	.LVL172
	.2byte	0xc
	.byte	0x70
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x36
	.byte	0x1e
	.byte	0x73
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL172
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
	.byte	0x73
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST51:
	.8byte	.LVL140
	.8byte	.LVL143
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL143
	.8byte	.LFE247
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST52:
	.8byte	.LVL141
	.8byte	.LVL142
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL144
	.8byte	.LVL154
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL154
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
.LLST53:
	.8byte	.LVL145
	.8byte	.LVL146
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL146
	.8byte	.LFE247
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST54:
	.8byte	.LVL146
	.8byte	.LVL147
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
	.8byte	.LVL148
	.8byte	.LVL150
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
	.8byte	.LVL151
	.8byte	.LVL152
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
.LLST55:
	.8byte	.LVL146
	.8byte	.LVL148
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL148
	.8byte	.LVL151
	.2byte	0x1
	.byte	0x5a
	.8byte	.LVL151
	.8byte	.LVL153
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL153
	.8byte	.LVL155
	.2byte	0x5
	.byte	0x73
	.sleb128 0
	.byte	0x78
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST41:
	.8byte	.LVL108
	.8byte	.LVL111
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL111
	.8byte	.LFE246
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST42:
	.8byte	.LVL109
	.8byte	.LVL110
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL112
	.8byte	.LVL129
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL129
	.8byte	.LVL130
	.2byte	0x6
	.byte	0x74
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL130
	.8byte	.LVL134
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL134
	.8byte	.LFE246
	.2byte	0x6
	.byte	0x74
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST43:
	.8byte	.LVL116
	.8byte	.LVL118
	.2byte	0x1
	.byte	0x5c
	.8byte	.LVL118
	.8byte	.LFE246
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST44:
	.8byte	.LVL113
	.8byte	.LVL114
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL114
	.8byte	.LVL118
	.2byte	0x5
	.byte	0x7e
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.8byte	.LVL118
	.8byte	.LVL124
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL126
	.8byte	.LVL128
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL130
	.8byte	.LVL133
	.2byte	0xd
	.byte	0x70
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST45:
	.8byte	.LVL119
	.8byte	.LVL120
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL120
	.8byte	.LVL122
	.2byte	0x5
	.byte	0x7e
	.sleb128 0
	.byte	0x81
	.sleb128 0
	.byte	0x22
	.8byte	.LVL122
	.8byte	.LVL124
	.2byte	0xd
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL126
	.8byte	.LVL127
	.2byte	0x5
	.byte	0x7e
	.sleb128 0
	.byte	0x81
	.sleb128 0
	.byte	0x22
	.8byte	.LVL127
	.8byte	.LVL128
	.2byte	0xd
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	.LVL130
	.8byte	.LVL132
	.2byte	0xd
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST46:
	.8byte	.LVL113
	.8byte	.LVL114
	.2byte	0xe
	.byte	0x75
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
	.8byte	.LVL114
	.8byte	.LVL115
	.2byte	0x13
	.byte	0x7e
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
	.8byte	.LVL115
	.8byte	.LVL116
	.2byte	0x15
	.byte	0x7e
	.sleb128 0
	.byte	0x72
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x73
	.sleb128 4
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL116
	.8byte	.LFE246
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST47:
	.8byte	.LVL119
	.8byte	.LVL120
	.2byte	0xe
	.byte	0x76
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8e
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL120
	.8byte	.LVL121
	.2byte	0x13
	.byte	0x7e
	.sleb128 0
	.byte	0x81
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8e
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x1e
	.byte	0x9f
	.8byte	.LVL121
	.8byte	.LVL123
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL123
	.8byte	.LVL124
	.2byte	0x25
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8e
	.sleb128 0
	.byte	0x1e
	.byte	0x7a
	.sleb128 0
	.byte	0x8e
	.sleb128 0
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
	.8byte	.LVL126
	.8byte	.LVL127
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL127
	.8byte	.LVL128
	.2byte	0x25
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8e
	.sleb128 0
	.byte	0x1e
	.byte	0x7a
	.sleb128 0
	.byte	0x8e
	.sleb128 0
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
	.8byte	.LVL130
	.8byte	.LVL132
	.2byte	0x25
	.byte	0x71
	.sleb128 0
	.byte	0x31
	.byte	0x24
	.byte	0xc
	.4byte	0x1fffe
	.byte	0x1a
	.byte	0x7e
	.sleb128 0
	.byte	0x22
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x8e
	.sleb128 0
	.byte	0x1e
	.byte	0x7a
	.sleb128 0
	.byte	0x8e
	.sleb128 0
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
.LLST48:
	.8byte	.LVL117
	.8byte	.LVL125
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL125
	.8byte	.LVL126
	.2byte	0x5
	.byte	0x74
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.8byte	.LVL126
	.8byte	.LVL129
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL130
	.8byte	.LVL133
	.2byte	0x1
	.byte	0x56
	.8byte	.LVL133
	.8byte	.LVL135
	.2byte	0x5
	.byte	0x74
	.sleb128 0
	.byte	0x7d
	.sleb128 0
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST39:
	.8byte	.LVL103
	.8byte	.LVL105
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL105
	.8byte	.LVL106
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL106
	.8byte	.LVL107
	.2byte	0x3
	.byte	0x9
	.byte	0xff
	.byte	0x9f
	.8byte	.LVL107
	.8byte	.LFE243
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST40:
	.8byte	.LVL104
	.8byte	.LVL106
	.2byte	0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST36:
	.8byte	.LVL96
	.8byte	.LVL99
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL99
	.8byte	.LFE242
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST37:
	.8byte	.LVL96
	.8byte	.LVL102
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL102
	.8byte	.LFE242
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST38:
	.8byte	.LVL97
	.8byte	.LVL98
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL100
	.8byte	.LFE242
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST30:
	.8byte	.LVL75
	.8byte	.LVL76
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL76
	.8byte	.LVL77
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL77
	.8byte	.LVL78
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL78
	.8byte	.LVL81
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL81
	.8byte	.LVL82
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL83
	.8byte	.LVL87
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL92
	.8byte	.LFE241
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST31:
	.8byte	.LVL83
	.8byte	.LVL85
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL85
	.8byte	.LVL88
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL92
	.8byte	.LFE241
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST32:
	.8byte	.LVL84
	.8byte	.LVL85
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL85
	.8byte	.LVL86
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL92
	.8byte	.LVL94
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL95
	.8byte	.LFE241
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST33:
	.8byte	.LVL90
	.8byte	.LVL91
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST34:
	.8byte	.LVL79
	.8byte	.LVL80
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST35:
	.8byte	.LVL89
	.8byte	.LVL91
	.2byte	0x1
	.byte	0x5b
	.8byte	0
	.8byte	0
.LLST184:
	.8byte	.LVL678
	.8byte	.LVL679
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL679
	.8byte	.LVL687
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL687
	.8byte	.LFE240
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST185:
	.8byte	.LVL678
	.8byte	.LVL681-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL681-1
	.8byte	.LFE240
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST186:
	.8byte	.LVL680
	.8byte	.LVL686
	.2byte	0xa
	.byte	0x3
	.8byte	gSysFreeQueue
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST187:
	.8byte	.LVL682
	.8byte	.LVL683
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL683
	.8byte	.LVL685
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST205:
	.8byte	.LVL807
	.8byte	.LVL808
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL808
	.8byte	.LVL809-1
	.2byte	0x9
	.byte	0x3
	.8byte	gSysFreeQueue
	.8byte	.LVL809-1
	.8byte	.LFE237
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST163:
	.8byte	.LVL620
	.8byte	.LVL624
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL624
	.8byte	.LVL631
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL631
	.8byte	.LVL633
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL633
	.8byte	.LFE236
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST164:
	.8byte	.LVL620
	.8byte	.LVL621
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL621
	.8byte	.LVL630
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL630
	.8byte	.LVL631
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL631
	.8byte	.LVL632
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL632
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST165:
	.8byte	.LVL625
	.8byte	.LVL627
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL627
	.8byte	.LVL628
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL633
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST166:
	.8byte	.LVL625
	.8byte	.LVL629
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL633
	.8byte	.LVL636
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL637
	.8byte	.LFE236
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST167:
	.8byte	.LVL634
	.8byte	.LVL638
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL638
	.8byte	.LFE236
	.2byte	0x3
	.byte	0x84
	.sleb128 -1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST168:
	.8byte	.LVL622
	.8byte	.LVL623
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
.LLST363:
	.8byte	.LVL1548
	.8byte	.LVL1549
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1549
	.8byte	.LVL1551
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1559
	.8byte	.LVL1564
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1564
	.8byte	.LVL1565
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1565
	.8byte	.LVL1585
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST364:
	.8byte	.LVL1550
	.8byte	.LVL1552
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1553
	.8byte	.LVL1557
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1558
	.8byte	.LVL1559
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1569
	.8byte	.LVL1579
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1580
	.8byte	.LVL1582
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1582
	.8byte	.LVL1583-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1584
	.8byte	.LVL1586
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1591
	.8byte	.LVL1592-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST365:
	.8byte	.LVL1561
	.8byte	.LVL1566
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1573
	.8byte	.LVL1578
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST366:
	.8byte	.LVL1560
	.8byte	.LVL1581
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST160:
	.8byte	.LVL610
	.8byte	.LVL611
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL613
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST161:
	.8byte	.LVL614
	.8byte	.LVL618
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL619
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST162:
	.8byte	.LVL610
	.8byte	.LVL612
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL613
	.8byte	.LFE230
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST359:
	.8byte	.LVL1534
	.8byte	.LVL1535
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1543
	.8byte	.LVL1544
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1544
	.8byte	.LVL1545
	.2byte	0x3
	.byte	0x84
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1545
	.8byte	.LVL1546
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST360:
	.8byte	.LVL1524
	.8byte	.LVL1527
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1536
	.8byte	.LVL1537
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1538
	.8byte	.LVL1539
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST361:
	.8byte	.LVL1530
	.8byte	.LVL1534
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1539
	.8byte	.LVL1541
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1542
	.8byte	.LVL1543
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST362:
	.8byte	.LVL1522
	.8byte	.LVL1533
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1536
	.8byte	.LVL1543
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1546
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
.LLST308:
	.8byte	.LVL1245
	.8byte	.LVL1246
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1257
	.8byte	.LVL1258
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1258
	.8byte	.LVL1259
	.2byte	0x3
	.byte	0x88
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL1259
	.8byte	.LVL1260
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST309:
	.8byte	.LVL1244
	.8byte	.LVL1249
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1249
	.8byte	.LVL1257
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1257
	.8byte	.LVL1260
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1260
	.8byte	.LVL1261
	.2byte	0x3
	.byte	0x89
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1262
	.8byte	.LVL1265
	.2byte	0x3
	.byte	0x89
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST310:
	.8byte	.LVL1247
	.8byte	.LVL1257
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1260
	.8byte	.LVL1263
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST311:
	.8byte	.LVL1244
	.8byte	.LVL1249
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1249
	.8byte	.LVL1254
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1255
	.8byte	.LVL1257
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1257
	.8byte	.LVL1260
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1260
	.8byte	.LVL1264
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST203:
	.8byte	.LVL799
	.8byte	.LVL800
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL800
	.8byte	.LVL805
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL805
	.8byte	.LFE225
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST204:
	.8byte	.LVL799
	.8byte	.LVL801
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL801
	.8byte	.LVL804
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL804
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
.LLST460:
	.8byte	.LVL2070
	.8byte	.LVL2073
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2073
	.8byte	.LVL2074-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2074-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST461:
	.8byte	.LVL2070
	.8byte	.LVL2072
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2072
	.8byte	.LVL2074-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2074-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST462:
	.8byte	.LVL2070
	.8byte	.LVL2071
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL2071
	.8byte	.LVL2074-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL2074-1
	.8byte	.LFE220
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST442:
	.8byte	.LVL1980
	.8byte	.LVL1983
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1983
	.8byte	.LVL1984-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1984-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST443:
	.8byte	.LVL1980
	.8byte	.LVL1982
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1982
	.8byte	.LVL1984-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1984-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST444:
	.8byte	.LVL1980
	.8byte	.LVL1981
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1981
	.8byte	.LVL1984-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1984-1
	.8byte	.LFE219
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST400:
	.8byte	.LVL1740
	.8byte	.LVL1742
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1742
	.8byte	.LVL1743
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1743
	.8byte	.LVL1745
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1745
	.8byte	.LVL1748
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1748
	.8byte	.LVL1763
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1763
	.8byte	.LFE218
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST401:
	.8byte	.LVL1740
	.8byte	.LVL1741
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1741
	.8byte	.LVL1744
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1745
	.8byte	.LFE218
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST402:
	.8byte	.LVL1748
	.8byte	.LVL1753
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1753
	.8byte	.LVL1754
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
.LLST403:
	.8byte	.LVL1749
	.8byte	.LVL1750
	.2byte	0x25
	.byte	0x71
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x84
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
	.8byte	.LVL1750
	.8byte	.LVL1752
	.2byte	0x2e
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x84
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
.LLST404:
	.8byte	.LVL1747
	.8byte	.LVL1763
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST405:
	.8byte	.LVL1759
	.8byte	.LVL1760-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST445:
	.8byte	.LVL1985
	.8byte	.LVL1988
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1988
	.8byte	.LFE217
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST446:
	.8byte	.LVL1985
	.8byte	.LVL1987
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1987
	.8byte	.LVL1989
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL1992
	.8byte	.LVL1995
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1995
	.8byte	.LVL2004
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2011
	.8byte	.LVL2017
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2018
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL2069
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x51
	.8byte	0
	.8byte	0
.LLST447:
	.8byte	.LVL1985
	.8byte	.LVL1986
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1986
	.8byte	.LVL1990
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1992
	.8byte	.LVL1993
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1993
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST448:
	.8byte	.LVL1985
	.8byte	.LVL1989-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1989-1
	.8byte	.LVL1991
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1992
	.8byte	.LVL1994
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1994
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2069
	.8byte	.LFE217
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST449:
	.8byte	.LVL2047
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST450:
	.8byte	.LVL2000
	.8byte	.LVL2001
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL2001
	.8byte	.LVL2003
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL2024
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST451:
	.8byte	.LVL1996
	.8byte	.LVL2005
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL2011
	.8byte	.LVL2017
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL2018
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST452:
	.8byte	.LVL1997
	.8byte	.LVL1998
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1998
	.8byte	.LVL2069
	.2byte	0x3
	.byte	0x8f
	.sleb128 344
	.8byte	0
	.8byte	0
.LLST453:
	.8byte	.LVL2045
	.8byte	.LVL2046
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2046
	.8byte	.LVL2048
	.2byte	0x2
	.byte	0x71
	.sleb128 4
	.8byte	.LVL2048
	.8byte	.LVL2049-1
	.2byte	0xf
	.byte	0x3
	.8byte	req_prgm
	.byte	0x6
	.byte	0x87
	.sleb128 0
	.byte	0x22
	.byte	0x23
	.uleb128 0x4
	.8byte	0
	.8byte	0
.LLST454:
	.8byte	.LVL2035
	.8byte	.LVL2040
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	.LVL2043
	.8byte	.LVL2055
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	.LVL2055
	.8byte	.LVL2056
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2056
	.8byte	.LVL2069
	.2byte	0x3
	.byte	0x8f
	.sleb128 360
	.8byte	0
	.8byte	0
.LLST455:
	.8byte	.LVL1999
	.8byte	.LVL2016
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL2016
	.8byte	.LVL2017
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL2018
	.8byte	.LVL2024
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL2024
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST456:
	.8byte	.LVL2031
	.8byte	.LVL2032
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
	.byte	0x8a
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
	.8byte	.LVL2032
	.8byte	.LVL2033
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2033
	.8byte	.LVL2036
	.2byte	0x3
	.byte	0x8f
	.sleb128 336
	.8byte	.LVL2036
	.8byte	.LVL2040
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL2043
	.8byte	.LVL2069
	.2byte	0x3
	.byte	0x8f
	.sleb128 336
	.8byte	0
	.8byte	0
.LLST457:
	.8byte	.LVL2000
	.8byte	.LVL2001
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2012
	.8byte	.LVL2014
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2014
	.8byte	.LVL2016-1
	.2byte	0x16
	.byte	0x86
	.sleb128 0
	.byte	0x3
	.8byte	c_ftl_nand_sec_pre_page
	.byte	0x94
	.byte	0x2
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x85
	.sleb128 0
	.byte	0x1e
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL2050
	.8byte	.LVL2051
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2051
	.8byte	.LVL2053
	.2byte	0x3
	.byte	0x8f
	.sleb128 340
	.8byte	.LVL2056
	.8byte	.LVL2058
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2058
	.8byte	.LVL2059
	.2byte	0x3
	.byte	0x8f
	.sleb128 340
	.8byte	.LVL2060
	.8byte	.LVL2068
	.2byte	0x3
	.byte	0x8f
	.sleb128 340
	.8byte	0
	.8byte	0
.LLST458:
	.8byte	.LVL2000
	.8byte	.LVL2001
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2013
	.8byte	.LVL2015
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL2015
	.8byte	.LVL2017
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2018
	.8byte	.LVL2024
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2052
	.8byte	.LVL2053
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	.LVL2057
	.8byte	.LVL2058
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2058
	.8byte	.LVL2059
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	.LVL2060
	.8byte	.LVL2068
	.2byte	0x3
	.byte	0x8f
	.sleb128 348
	.8byte	0
	.8byte	0
.LLST459:
	.8byte	.LVL2000
	.8byte	.LVL2001
	.2byte	0xa
	.byte	0x3
	.8byte	g_active_superblock
	.byte	0x9f
	.8byte	.LVL2001
	.8byte	.LVL2006
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2024
	.8byte	.LVL2028
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2030
	.8byte	.LVL2042
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2043
	.8byte	.LVL2069
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST393:
	.8byte	.LVL1714
	.8byte	.LVL1717-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1717-1
	.8byte	.LVL1717
	.2byte	0x3
	.byte	0x84
	.sleb128 -4
	.byte	0x9f
	.8byte	.LVL1717
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST394:
	.8byte	.LVL1714
	.8byte	.LVL1717-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1717-1
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST395:
	.8byte	.LVL1714
	.8byte	.LVL1715
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1715
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST396:
	.8byte	.LVL1714
	.8byte	.LVL1716
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1716
	.8byte	.LVL1733
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1733
	.8byte	.LFE215
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST397:
	.8byte	.LVL1726
	.8byte	.LVL1729-1
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST398:
	.8byte	.LVL1718
	.8byte	.LVL1719
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1728
	.8byte	.LVL1729-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1729-1
	.8byte	.LVL1731
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST399:
	.8byte	.LVL1725
	.8byte	.LVL1727-1
	.2byte	0x2
	.byte	0x86
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST425:
	.8byte	.LVL1931
	.8byte	.LVL1934
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1934
	.8byte	.LFE214
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST426:
	.8byte	.LVL1931
	.8byte	.LVL1933
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1933
	.8byte	.LVL1937
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1937
	.8byte	.LVL1940
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1940
	.8byte	.LVL1941
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1941
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST427:
	.8byte	.LVL1931
	.8byte	.LVL1932
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1932
	.8byte	.LVL1939
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1939
	.8byte	.LVL1940
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.8byte	.LVL1940
	.8byte	.LVL1942-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1942-1
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x52
	.8byte	0
	.8byte	0
.LLST428:
	.8byte	.LVL1931
	.8byte	.LVL1935-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1935-1
	.8byte	.LVL1938
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1938
	.8byte	.LVL1940
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x53
	.byte	0x9f
	.8byte	.LVL1940
	.8byte	.LVL1942-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1942-1
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST429:
	.8byte	.LVL1931
	.8byte	.LVL1936
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1940
	.8byte	.LVL1947
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1947
	.8byte	.LVL1958
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1960
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST430:
	.8byte	.LVL1943
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST431:
	.8byte	.LVL1944
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST432:
	.8byte	.LVL1962
	.8byte	.LVL1963
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1963
	.8byte	.LVL1964-1
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
.LLST433:
	.8byte	.LVL1945
	.8byte	.LVL1947
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL1947
	.8byte	.LVL1979
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST434:
	.8byte	.LVL1954
	.8byte	.LVL1956
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST435:
	.8byte	.LVL1945
	.8byte	.LVL1947
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1947
	.8byte	.LVL1955
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1961
	.8byte	.LVL1976
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST436:
	.8byte	.LVL1945
	.8byte	.LVL1946
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1946
	.8byte	.LVL1952
	.2byte	0x3
	.byte	0x8f
	.sleb128 300
	.8byte	.LVL1952
	.8byte	.LVL1953
	.2byte	0x8
	.byte	0x8f
	.sleb128 300
	.byte	0x94
	.byte	0x4
	.byte	0x31
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1961
	.8byte	.LVL1976
	.2byte	0x3
	.byte	0x8f
	.sleb128 300
	.8byte	0
	.8byte	0
.LLST437:
	.8byte	.LVL1931
	.8byte	.LVL1936
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1940
	.8byte	.LVL1947
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1947
	.8byte	.LVL1968
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1968
	.8byte	.LVL1969
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1969
	.8byte	.LVL1979
	.2byte	0x3
	.byte	0x8f
	.sleb128 296
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST438:
	.8byte	.LVL1940
	.8byte	.LVL1947
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1947
	.8byte	.LVL1969
	.2byte	0x3
	.byte	0x8f
	.sleb128 292
	.8byte	.LVL1969
	.8byte	.LVL1970
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1970
	.8byte	.LVL1971
	.2byte	0x9
	.byte	0x71
	.sleb128 0
	.byte	0x8f
	.sleb128 296
	.byte	0x94
	.byte	0x4
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL1971
	.8byte	.LVL1972
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1972
	.8byte	.LVL1979
	.2byte	0x3
	.byte	0x8f
	.sleb128 292
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST439:
	.8byte	.LVL1940
	.8byte	.LVL1947
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1947
	.8byte	.LVL1974
	.2byte	0x3
	.byte	0x8f
	.sleb128 288
	.8byte	.LVL1974
	.8byte	.LVL1975
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1975
	.8byte	.LVL1979
	.2byte	0x3
	.byte	0x8f
	.sleb128 288
	.8byte	.LVL1979
	.8byte	.LFE214
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST440:
	.8byte	.LVL1950
	.8byte	.LVL1951
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1961
	.8byte	.LVL1964-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1964-1
	.8byte	.LVL1965
	.2byte	0x3
	.byte	0x8f
	.sleb128 264
	.8byte	.LVL1966
	.8byte	.LVL1967
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST441:
	.8byte	.LVL1977
	.8byte	.LVL1978-1
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST469:
	.8byte	.LVL2170
	.8byte	.LVL2171
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc1
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL2171
	.8byte	.LVL2172
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc2
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL2172
	.8byte	.LVL2173
	.2byte	0x7
	.byte	0xa
	.2byte	0x1fc1
	.byte	0x83
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST465:
	.8byte	.LVL2127
	.8byte	.LVL2128
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2130
	.8byte	.LVL2131
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL2140
	.8byte	.LVL2141
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2141
	.8byte	.LVL2142-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2144
	.8byte	.LVL2145
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL2149
	.8byte	.LVL2150
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2150
	.8byte	.LVL2151-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2151
	.8byte	.LVL2152
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2152
	.8byte	.LVL2153
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL2153
	.8byte	.LVL2154-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2156
	.8byte	.LVL2157
	.2byte	0x1
	.byte	0x68
	.8byte	0
	.8byte	0
.LLST466:
	.8byte	.LVL2130
	.8byte	.LVL2134
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2152
	.8byte	.LVL2155
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2156
	.8byte	.LVL2157
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST467:
	.8byte	.LVL2126
	.8byte	.LVL2127
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL2127
	.8byte	.LVL2129
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2140
	.8byte	.LVL2143
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2144
	.8byte	.LVL2146
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL2148
	.8byte	.LVL2149
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST468:
	.8byte	.LVL2125
	.8byte	.LVL2127
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2137
	.8byte	.LVL2138
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL2139
	.8byte	.LVL2140
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST188:
	.8byte	.LVL688
	.8byte	.LVL689
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL689
	.8byte	.LVL714
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL714
	.8byte	.LFE209
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST189:
	.8byte	.LVL688
	.8byte	.LVL691
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL691
	.8byte	.LVL714
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL714
	.8byte	.LFE209
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST190:
	.8byte	.LVL688
	.8byte	.LVL692
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL692
	.8byte	.LVL695
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL696
	.8byte	.LVL705
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL706
	.8byte	.LVL713
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL715
	.8byte	.LVL726
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL727
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST191:
	.8byte	.LVL688
	.8byte	.LVL692
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL692
	.8byte	.LVL693
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL701
	.8byte	.LVL702
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL702
	.8byte	.LVL712
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL715
	.8byte	.LVL720
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL721
	.8byte	.LVL728
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL729
	.8byte	.LVL734
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL735
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST192:
	.8byte	.LVL690
	.8byte	.LVL692
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL692
	.8byte	.LVL694-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL701
	.8byte	.LVL702
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL702
	.8byte	.LVL703-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL703
	.8byte	.LVL704
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL715
	.8byte	.LVL723
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL723
	.8byte	.LVL724
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL725
	.8byte	.LVL728
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL729
	.8byte	.LVL737
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL737
	.8byte	.LVL738
	.2byte	0x3
	.byte	0x75
	.sleb128 1
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST193:
	.8byte	.LVL717
	.8byte	.LVL722
	.2byte	0x1
	.byte	0x5d
	.8byte	.LVL722
	.8byte	.LVL725
	.2byte	0x1
	.byte	0x5e
	.8byte	.LVL725
	.8byte	.LVL728
	.2byte	0x1
	.byte	0x5d
	.8byte	.LVL731
	.8byte	.LVL736
	.2byte	0x1
	.byte	0x5c
	.8byte	.LVL736
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x5d
	.8byte	0
	.8byte	0
.LLST194:
	.8byte	.LVL688
	.8byte	.LVL699
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL699
	.8byte	.LVL700
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL701
	.8byte	.LVL712
	.2byte	0x1
	.byte	0x6a
	.8byte	.LVL715
	.8byte	.LVL729
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL729
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x6a
	.8byte	0
	.8byte	0
.LLST195:
	.8byte	.LVL688
	.8byte	.LVL701
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL701
	.8byte	.LVL708
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL709
	.8byte	.LVL710
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL715
	.8byte	.LVL729
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL729
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST196:
	.8byte	.LVL688
	.8byte	.LVL700
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL701
	.8byte	.LVL712
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL715
	.8byte	.LVL729
	.2byte	0x2
	.byte	0x36
	.byte	0x9f
	.8byte	.LVL729
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST197:
	.8byte	.LVL688
	.8byte	.LVL698
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL698
	.8byte	.LVL700
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	.LVL701
	.8byte	.LVL712
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL715
	.8byte	.LVL729
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL729
	.8byte	.LFE209
	.2byte	0x1
	.byte	0x69
	.8byte	0
	.8byte	0
.LLST201:
	.8byte	.LVL796
	.8byte	.LVL797
	.2byte	0x2
	.byte	0x31
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST202:
	.8byte	.LVL743
	.8byte	.LVL749
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL750
	.8byte	.LVL757
	.2byte	0x7
	.byte	0x83
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x9f
	.8byte	.LVL759
	.8byte	.LVL762
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL766
	.8byte	.LVL768
	.2byte	0x1
	.byte	0x6c
	.8byte	.LVL768
	.8byte	.LVL769-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL770
	.8byte	.LVL771-1
	.2byte	0xe
	.byte	0x3
	.8byte	c_ftl_nand_max_map_blks
	.byte	0x94
	.byte	0x4
	.byte	0x31
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL778
	.8byte	.LVL779
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
	.8byte	.LVL779
	.8byte	.LVL780-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL781
	.8byte	.LVL782-1
	.2byte	0xe
	.byte	0x3
	.8byte	c_ftl_nand_max_map_blks
	.byte	0x94
	.byte	0x4
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL783
	.8byte	.LVL784
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
	.8byte	.LVL784
	.8byte	.LVL785-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL786
	.8byte	.LVL787
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
	.8byte	.LVL787
	.8byte	.LVL788-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL789
	.8byte	.LVL790
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
	.8byte	.LVL790
	.8byte	.LVL791-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL792
	.8byte	.LVL793
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
	.8byte	.LVL793
	.8byte	.LVL794
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
	.8byte	.LVL794
	.8byte	.LVL795-1
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
.LLST112:
	.8byte	.LVL468
	.8byte	.LVL470-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL470-1
	.8byte	.LVL475
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL475
	.8byte	.LFE201
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST113:
	.8byte	.LVL469
	.8byte	.LVL470-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL470-1
	.8byte	.LVL471
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL471
	.8byte	.LVL472
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL472
	.8byte	.LVL473
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
	.8byte	.LVL473
	.8byte	.LVL474
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST107:
	.8byte	.LVL316
	.8byte	.LVL318-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL318-1
	.8byte	.LVL451
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL451
	.8byte	.LVL452
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL452
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x65
	.8byte	0
	.8byte	0
.LLST108:
	.8byte	.LVL456
	.8byte	.LVL457
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL457
	.8byte	.LVL458
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL458
	.8byte	.LVL459-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL459-1
	.8byte	.LVL461
	.2byte	0x3
	.byte	0x87
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL461
	.8byte	.LVL462
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL464
	.8byte	.LVL465
	.2byte	0x1
	.byte	0x66
	.8byte	.LVL465
	.8byte	.LVL466-1
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL466-1
	.8byte	.LVL467
	.2byte	0x3
	.byte	0x86
	.sleb128 -1
	.byte	0x9f
	.8byte	.LVL467
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST109:
	.8byte	.LVL317
	.8byte	.LVL318-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL318-1
	.8byte	.LVL319
	.2byte	0x1
	.byte	0x65
	.8byte	.LVL319
	.8byte	.LVL431
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL431
	.8byte	.LVL450
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL452
	.8byte	.LFE200
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST110:
	.8byte	.LVL456
	.8byte	.LVL459-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL461
	.8byte	.LVL463
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST111:
	.8byte	.LVL464
	.8byte	.LVL466-1
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL467
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
	.8byte	.LFE356
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
.LLST49:
	.8byte	.LVL136
	.8byte	.LVL137-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL137-1
	.8byte	.LFE245
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST50:
	.8byte	.LVL138
	.8byte	.LVL139
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST56:
	.8byte	.LVL156
	.8byte	.LVL157-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL157-1
	.8byte	.LFE244
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST57:
	.8byte	.LVL158
	.8byte	.LVL159
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST70:
	.8byte	.LVL198
	.8byte	.LVL199
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL199
	.8byte	.LVL216
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL216
	.8byte	.LFE252
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST71:
	.8byte	.LVL200
	.8byte	.LVL215
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST72:
	.8byte	.LVL206
	.8byte	.LVL207
	.2byte	0x5
	.byte	0x71
	.sleb128 0
	.byte	0x36
	.byte	0x1b
	.byte	0x9f
	.8byte	.LVL207
	.8byte	.LVL213-1
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
.LLST73:
	.8byte	.LVL202
	.8byte	.LVL205-1
	.2byte	0x13
	.byte	0x83
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x31
	.byte	0x24
	.byte	0x3
	.8byte	p_valid_page_count_table
	.byte	0x6
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST74:
	.8byte	.LVL203
	.8byte	.LVL211
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST75:
	.8byte	.LVL206
	.8byte	.LVL207
	.2byte	0x11
	.byte	0x71
	.sleb128 0
	.byte	0x36
	.byte	0x1b
	.byte	0x31
	.byte	0x24
	.byte	0x3
	.8byte	p_valid_page_count_table
	.byte	0x6
	.byte	0x22
	.8byte	.LVL207
	.8byte	.LVL213-1
	.2byte	0x19
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
	.byte	0x31
	.byte	0x24
	.byte	0x3
	.8byte	p_valid_page_count_table
	.byte	0x6
	.byte	0x22
	.8byte	0
	.8byte	0
.LLST76:
	.8byte	.LVL209
	.8byte	.LVL212
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST77:
	.8byte	.LVL201
	.8byte	.LVL215
	.2byte	0x1
	.byte	0x66
	.8byte	0
	.8byte	0
.LLST78:
	.8byte	.LVL206
	.8byte	.LVL207
	.2byte	0xe
	.byte	0x3
	.8byte	p_data_block_list_table
	.byte	0x6
	.byte	0x71
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL207
	.8byte	.LVL208
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL208
	.8byte	.LVL213-1
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
.LLST79:
	.8byte	.LVL217
	.8byte	.LVL219
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL219
	.8byte	.LVL221-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL221-1
	.8byte	.LVL222
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL222
	.8byte	.LVL224
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL224
	.8byte	.LVL225
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL225
	.8byte	.LFE255
	.2byte	0x1
	.byte	0x54
	.8byte	0
	.8byte	0
.LLST80:
	.8byte	.LVL217
	.8byte	.LVL219
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL219
	.8byte	.LVL221-1
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL222
	.8byte	.LVL224
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL225
	.8byte	.LVL226
	.2byte	0x1
	.byte	0x55
	.8byte	.LVL227
	.8byte	.LFE255
	.2byte	0x1
	.byte	0x55
	.8byte	0
	.8byte	0
.LLST81:
	.8byte	.LVL217
	.8byte	.LVL218
	.2byte	0x2
	.byte	0x70
	.sleb128 16
	.8byte	0
	.8byte	0
.LLST82:
	.8byte	.LVL220
	.8byte	.LVL221-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL221-1
	.8byte	.LVL222
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST86:
	.8byte	.LVL250
	.8byte	.LVL251
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL251
	.8byte	.LFE266
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST87:
	.8byte	.LVL256
	.8byte	.LVL257-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL257-1
	.8byte	.LFE272
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST88:
	.8byte	.LVL256
	.8byte	.LVL257-1
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL257-1
	.8byte	.LVL257
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL257
	.8byte	.LVL258
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL258
	.8byte	.LFE272
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST93:
	.8byte	.LVL271
	.8byte	.LVL273
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL274
	.8byte	.LFE282
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST94:
	.8byte	.LVL272
	.8byte	.LVL273
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL274
	.8byte	.LFE282
	.2byte	0x1
	.byte	0x53
	.8byte	0
	.8byte	0
.LLST121:
	.8byte	.LVL502
	.8byte	.LVL504-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL504-1
	.8byte	.LFE297
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST122:
	.8byte	.LVL503
	.8byte	.LVL504-1
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL504-1
	.8byte	.LVL505
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST253:
	.8byte	.LVL966
	.8byte	.LVL970
	.2byte	0x7
	.byte	0xa
	.2byte	0x800
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL971
	.8byte	.LVL972
	.2byte	0x7
	.byte	0xa
	.2byte	0x801
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	.LVL972
	.8byte	.LVL973
	.2byte	0x7
	.byte	0xa
	.2byte	0x800
	.byte	0x85
	.sleb128 0
	.byte	0x1c
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST299:
	.8byte	.LVL1217
	.8byte	.LVL1219
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1219
	.8byte	.LVL1221
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1221
	.8byte	.LVL1227
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1227
	.8byte	.LFE344
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST300:
	.8byte	.LVL1218
	.8byte	.LVL1221
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1221
	.8byte	.LVL1226
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST320:
	.8byte	.LVL1310
	.8byte	.LVL1311
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1311
	.8byte	.LVL1314
	.2byte	0x1
	.byte	0x69
	.8byte	.LVL1314
	.8byte	.LFE317
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST321:
	.8byte	.LVL1312
	.8byte	.LVL1313
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1315
	.8byte	.LVL1318
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1319
	.8byte	.LFE317
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST322:
	.8byte	.LVL1322
	.8byte	.LVL1323
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1323
	.8byte	.LVL1324
	.2byte	0x6
	.byte	0x70
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	.LVL1326
	.8byte	.LVL1327
	.2byte	0x6
	.byte	0x70
	.sleb128 0
	.byte	0x84
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST323:
	.8byte	.LVL1328
	.8byte	.LVL1329
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1329
	.8byte	.LVL1337
	.2byte	0x1
	.byte	0x63
	.8byte	.LVL1337
	.8byte	.LFE301
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST324:
	.8byte	.LVL1330
	.8byte	.LVL1336
	.2byte	0x1
	.byte	0x63
	.8byte	0
	.8byte	0
.LLST327:
	.8byte	.LVL1350
	.8byte	.LVL1351-1
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
.LLST328:
	.8byte	.LVL1350
	.8byte	.LVL1351-1
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
	.8byte	.LVL1351-1
	.8byte	.LVL1354
	.2byte	0x9
	.byte	0x89
	.sleb128 0
	.byte	0xa
	.2byte	0xffff
	.byte	0x1a
	.byte	0x32
	.byte	0x24
	.byte	0x9f
	.8byte	.LVL1356
	.8byte	.LVL1358
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
.LLST329:
	.8byte	.LVL1352
	.8byte	.LVL1355
	.2byte	0x1
	.byte	0x64
	.8byte	.LVL1356
	.8byte	.LVL1362
	.2byte	0x1
	.byte	0x64
	.8byte	0
	.8byte	0
.LLST413:
	.8byte	.LVL1832
	.8byte	.LVL1834
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1834
	.8byte	.LVL1847
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1847
	.8byte	.LVL1848
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1848
	.8byte	.LVL1868
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1868
	.8byte	.LVL1870
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1870
	.8byte	.LVL1881
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1881
	.8byte	.LVL1928
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1928
	.8byte	.LVL1929
	.2byte	0x1
	.byte	0x50
	.8byte	.LVL1929
	.8byte	.LFE319
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST414:
	.8byte	.LVL1832
	.8byte	.LVL1833
	.2byte	0x1
	.byte	0x51
	.8byte	.LVL1833
	.8byte	.LFE319
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST415:
	.8byte	.LVL1835
	.8byte	.LVL1847
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	.LVL1850
	.8byte	.LVL1928
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST416:
	.8byte	.LVL1835
	.8byte	.LVL1847
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1850
	.8byte	.LVL1868
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1868
	.8byte	.LVL1870
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	.LVL1870
	.8byte	.LVL1881
	.2byte	0x1
	.byte	0x68
	.8byte	.LVL1881
	.8byte	.LVL1928
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST417:
	.8byte	.LVL1911
	.8byte	.LVL1912-1
	.2byte	0x1
	.byte	0x54
	.8byte	.LVL1912-1
	.8byte	.LVL1913
	.2byte	0x3
	.byte	0x8f
	.sleb128 272
	.8byte	0
	.8byte	0
.LLST418:
	.8byte	.LVL1892
	.8byte	.LVL1893
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	.LVL1893
	.8byte	.LVL1906
	.2byte	0x1
	.byte	0x6b
	.8byte	.LVL1906
	.8byte	.LVL1907
	.2byte	0x3
	.byte	0x8b
	.sleb128 1
	.byte	0x9f
	.8byte	.LVL1908
	.8byte	.LVL1928
	.2byte	0x1
	.byte	0x6b
	.8byte	0
	.8byte	0
.LLST419:
	.8byte	.LVL1894
	.8byte	.LVL1899
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1901
	.8byte	.LVL1902
	.2byte	0x1
	.byte	0x52
	.8byte	.LVL1903
	.8byte	.LVL1905
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.8byte	0
	.8byte	0
.LLST420:
	.8byte	.LVL1894
	.8byte	.LVL1896
	.2byte	0x1
	.byte	0x67
	.8byte	.LVL1897
	.8byte	.LVL1904
	.2byte	0x1
	.byte	0x67
	.8byte	0
	.8byte	0
.LLST421:
	.8byte	.LVL1895
	.8byte	.LVL1898
	.2byte	0x1
	.byte	0x53
	.8byte	.LVL1898
	.8byte	.LVL1900
	.2byte	0x2
	.byte	0x71
	.sleb128 0
	.8byte	.LVL1900
	.8byte	.LVL1901
	.2byte	0x2
	.byte	0x71
	.sleb128 -2
	.8byte	0
	.8byte	0
.LLST422:
	.8byte	.LVL1890
	.8byte	.LVL1928
	.2byte	0x3
	.byte	0x8f
	.sleb128 332
	.8byte	0
	.8byte	0
.LLST423:
	.8byte	.LVL1909
	.8byte	.LVL1910
	.2byte	0x2
	.byte	0x71
	.sleb128 16
	.8byte	.LVL1910
	.8byte	.LVL1918
	.2byte	0x1
	.byte	0x6c
	.8byte	0
	.8byte	0
.LLST424:
	.8byte	.LVL1840
	.8byte	.LVL1841
	.2byte	0x1
	.byte	0x50
	.8byte	0
	.8byte	0
.LLST464:
	.8byte	.LVL2107
	.8byte	.LVL2108
	.2byte	0xa
	.byte	0x3
	.8byte	g_active_superblock
	.byte	0x9f
	.8byte	.LVL2108
	.8byte	.LVL2114
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
	.8byte	.LFB356
	.8byte	.LFE356-.LFB356
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
	.8byte	.LFB243
	.8byte	.LFE243-.LFB243
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
	.8byte	.LFB255
	.8byte	.LFE255-.LFB255
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
	.8byte	.LFB289
	.8byte	.LFE289-.LFB289
	.8byte	.LFB299
	.8byte	.LFE299-.LFB299
	.8byte	.LFB215
	.8byte	.LFE215-.LFB215
	.8byte	.LFB216
	.8byte	.LFE216-.LFB216
	.8byte	.LFB212
	.8byte	.LFE212-.LFB212
	.8byte	.LFB213
	.8byte	.LFE213-.LFB213
	.8byte	.LFB218
	.8byte	.LFE218-.LFB218
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
	.8byte	.LBB166
	.8byte	.LBE166
	.8byte	.LBB169
	.8byte	.LBE169
	.8byte	0
	.8byte	0
	.8byte	.LBB170
	.8byte	.LBE170
	.8byte	.LBB173
	.8byte	.LBE173
	.8byte	0
	.8byte	0
	.8byte	.LBB195
	.8byte	.LBE195
	.8byte	.LBB199
	.8byte	.LBE199
	.8byte	.LBB200
	.8byte	.LBE200
	.8byte	0
	.8byte	0
	.8byte	.LBB209
	.8byte	.LBE209
	.8byte	.LBB212
	.8byte	.LBE212
	.8byte	0
	.8byte	0
	.8byte	.LBB219
	.8byte	.LBE219
	.8byte	.LBB220
	.8byte	.LBE220
	.8byte	0
	.8byte	0
	.8byte	.LBB225
	.8byte	.LBE225
	.8byte	.LBB226
	.8byte	.LBE226
	.8byte	0
	.8byte	0
	.8byte	.LBB233
	.8byte	.LBE233
	.8byte	.LBB235
	.8byte	.LBE235
	.8byte	.LBB236
	.8byte	.LBE236
	.8byte	.LBB237
	.8byte	.LBE237
	.8byte	0
	.8byte	0
	.8byte	.LBB242
	.8byte	.LBE242
	.8byte	.LBB243
	.8byte	.LBE243
	.8byte	0
	.8byte	0
	.8byte	.LBB252
	.8byte	.LBE252
	.8byte	.LBB256
	.8byte	.LBE256
	.8byte	.LBB257
	.8byte	.LBE257
	.8byte	0
	.8byte	0
	.8byte	.LBB266
	.8byte	.LBE266
	.8byte	.LBB267
	.8byte	.LBE267
	.8byte	0
	.8byte	0
	.8byte	.LBB269
	.8byte	.LBE269
	.8byte	.LBB271
	.8byte	.LBE271
	.8byte	0
	.8byte	0
	.8byte	.LBB270
	.8byte	.LBE270
	.8byte	.LBB272
	.8byte	.LBE272
	.8byte	.LBB273
	.8byte	.LBE273
	.8byte	.LBB274
	.8byte	.LBE274
	.8byte	0
	.8byte	0
	.8byte	.LBB291
	.8byte	.LBE291
	.8byte	.LBB296
	.8byte	.LBE296
	.8byte	0
	.8byte	0
	.8byte	.LBB293
	.8byte	.LBE293
	.8byte	.LBB294
	.8byte	.LBE294
	.8byte	0
	.8byte	0
	.8byte	.LBB298
	.8byte	.LBE298
	.8byte	.LBB299
	.8byte	.LBE299
	.8byte	0
	.8byte	0
	.8byte	.LFB349
	.8byte	.LFE349
	.8byte	.LFB356
	.8byte	.LFE356
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
	.8byte	.LFB243
	.8byte	.LFE243
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
	.8byte	.LFB255
	.8byte	.LFE255
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
	.8byte	.LFB289
	.8byte	.LFE289
	.8byte	.LFB299
	.8byte	.LFE299
	.8byte	.LFB215
	.8byte	.LFE215
	.8byte	.LFB216
	.8byte	.LFE216
	.8byte	.LFB212
	.8byte	.LFE212
	.8byte	.LFB213
	.8byte	.LFE213
	.8byte	.LFB218
	.8byte	.LFE218
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
.LASF728:
	.string	"FtlEctTblFlush"
.LASF593:
	.string	"gc_page_num"
.LASF609:
	.string	"superBlk"
.LASF499:
	.string	"g_gc_bad_block_temp_num"
.LASF363:
	.string	"all_blk_used_slc_mode"
.LASF43:
	.string	"reserved"
.LASF508:
	.string	"g_totle_read_sector"
.LASF574:
	.string	"__func__"
.LASF419:
	.string	"c_ftl_nand_sys_blks_per_plane"
.LASF733:
	.string	"nSec"
.LASF729:
	.string	"forceFlush"
.LASF107:
	.string	"bootm_headers"
.LASF453:
	.string	"p_gc_data_buf"
.LASF125:
	.string	"rd_end"
.LASF492:
	.string	"p_gc_blk_tbl"
.LASF788:
	.string	"FtlFreeSysBlkQueueOut"
.LASF324:
	.string	"ftl_bbt_blk_header"
.LASF227:
	.string	"eth_device"
.LASF306:
	.string	"sign"
.LASF833:
	.string	"sctidx"
.LASF670:
	.string	"Ftl_load_ext_data"
.LASF96:
	.string	"ih_comp"
.LASF587:
	.string	"block"
.LASF22:
	.string	"_Bool"
.LASF652:
	.string	"min_ec"
.LASF604:
	.string	"req_read_temp"
.LASF279:
	.string	"p_spare"
.LASF686:
	.string	"recovery_cur_page_ver"
.LASF506:
	.string	"g_totle_write_page_count"
.LASF245:
	.string	"net_root_path"
.LASF625:
	.string	"lookup_ppa"
.LASF818:
	.string	"FtlBbmTblFlush"
.LASF612:
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
.LASF778:
	.string	"insert_free_list"
.LASF882:
	.ascii	"GNU C11 6.3.1 20170404 -ms"
	.string	"trict-align -march=armv8-a+nosimd -mlittle-endian -mabi=lp64 -g -Os -fno-builtin -ffreestanding -fshort-wchar -fno-stack-protector -fno-delete-null-pointer-checks -fstack-usage -fno-pic -ffunction-sections -fdata-sections -ffixed-r9 -fno-common -ffixed-x18"
.LASF21:
	.string	"___strtok"
.LASF198:
	.string	"UCLASS_SPI_GENERIC"
.LASF477:
	.string	"g_l2p_last_update_region_id"
.LASF699:
	.string	"ftl_sb_update_avl_pages"
.LASF572:
	.string	"FlashProgPages"
.LASF857:
	.string	"test_page_num"
.LASF685:
	.string	"lookup_superblock_id"
.LASF420:
	.string	"c_ftl_nand_init_sys_blks_per_plane"
.LASF866:
	.string	"FtlConstantsInit"
.LASF596:
	.string	"num_io"
.LASF869:
	.string	"FtlPrintInfo"
.LASF745:
	.string	"l2p_flush"
.LASF378:
	.string	"rear"
.LASF305:
	.string	"ftl_l2p_map_info"
.LASF521:
	.string	"g_in_swl_replace"
.LASF404:
	.string	"c_ftl_nand_page_pre_slc_blk"
.LASF243:
	.string	"net_nis_domain"
.LASF765:
	.string	"List_update_data_list"
.LASF853:
	.string	"create_first_buffer_superblock"
.LASF503:
	.string	"g_gc_merge_free_blk_threshold"
.LASF694:
	.string	"last_mlc_page_version"
.LASF631:
	.string	"IsBlkInGcList"
.LASF235:
	.string	"next"
.LASF312:
	.string	"pBlkVpcTbl"
.LASF698:
	.string	"FtlReUsePrevPpa"
.LASF659:
	.string	"update_multiplier_value"
.LASF411:
	.string	"c_ftl_nand_totle_phy_blks"
.LASF875:
	.string	"memcmp"
.LASF421:
	.string	"c_ftl_nand_max_sys_blks"
.LASF577:
	.string	"PhyBlk"
.LASF576:
	.string	"FlashReadPages"
.LASF479:
	.string	"p_free_data_block_list_head"
.LASF148:
	.string	"UCLASS_AHCI"
.LASF161:
	.string	"UCLASS_I2C_MUX"
.LASF263:
	.string	"uclass_id"
.LASF601:
	.string	"get_new_gc_superblock"
.LASF623:
	.string	"BOPS_EN"
.LASF241:
	.string	"net_netmask"
.LASF850:
	.string	"bad_block_cnt"
.LASF424:
	.string	"c_ftl_nand_max_data_blks"
.LASF560:
	.string	"pvTo"
.LASF117:
	.string	"fit_noffset_rd"
.LASF192:
	.string	"UCLASS_RTC"
.LASF810:
	.string	"pBbtHeader"
.LASF46:
	.string	"bi_memsize"
.LASF47:
	.string	"bi_flashstart"
.LASF762:
	.string	"minValidPageCount"
.LASF232:
	.string	"recv"
.LASF122:
	.string	"fit_uname_setup"
.LASF199:
	.string	"UCLASS_SYSCON"
.LASF153:
	.string	"UCLASS_DISPLAY"
.LASF519:
	.string	"g_max_erase_count"
.LASF568:
	.string	"flash_type"
.LASF529:
	.string	"g_recovery_ppa_tbl"
.LASF71:
	.string	"IRQ_STACK_START_IN"
.LASF63:
	.string	"bi_dram"
.LASF191:
	.string	"UCLASS_RKNAND"
.LASF581:
	.string	"die_index"
.LASF805:
	.string	"ver2"
.LASF434:
	.string	"gSysFreeQueue"
.LASF159:
	.string	"UCLASS_I2C_EEPROM"
.LASF533:
	.string	"g_nand_phy_info"
.LASF555:
	.string	"check_spare_buf"
.LASF144:
	.string	"UCLASS_PCI_EMUL"
.LASF72:
	.string	"fdt_header"
.LASF586:
	.string	"ftl_free"
.LASF429:
	.string	"g_MaxLpn"
.LASF342:
	.string	"bufferPageOffset"
.LASF387:
	.string	"reversed"
.LASF507:
	.string	"g_totle_write_sector"
.LASF75:
	.string	"off_dt_struct"
.LASF417:
	.string	"c_ftl_nand_max_vendor_blks"
.LASF769:
	.string	"prev_valid_page_count"
.LASF874:
	.string	"FtlPrintInfo2buf"
.LASF480:
	.string	"p_data_block_list_head"
.LASF265:
	.string	"NETLOOP_CONTINUE"
.LASF807:
	.string	"P2V_plane"
.LASF486:
	.string	"g_gc_temp_superblock"
.LASF195:
	.string	"UCLASS_SPI"
.LASF416:
	.string	"c_ftl_nand_max_map_blks"
.LASF302:
	.string	"BbtMap"
.LASF744:
	.string	"found_lpa"
.LASF209:
	.string	"UCLASS_VIDEO_CONSOLE"
.LASF367:
	.string	"last_refresh_read_count"
.LASF207:
	.string	"UCLASS_VIDEO"
.LASF616:
	.string	"current_ppa"
.LASF852:
	.string	"create_first_active_superblock"
.LASF313:
	.string	"pMapPpnTbl"
.LASF269:
	.string	"net_state"
.LASF725:
	.string	"num_page"
.LASF425:
	.string	"ftl_gc_temp_power_lost_recovery_flag"
.LASF615:
	.string	"totle_num"
.LASF732:
	.string	"Index"
.LASF682:
	.string	"next_free_active_page"
.LASF607:
	.string	"spperBlk"
.LASF65:
	.string	"IRQ_STACK_START"
.LASF132:
	.string	"verify"
.LASF714:
	.string	"ftl_set_blk_mode"
.LASF266:
	.string	"NETLOOP_RESTART"
.LASF270:
	.string	"uint8"
.LASF353:
	.string	"write_page_count"
.LASF611:
	.string	"Ftl_gc_temp_data_write_back"
.LASF295:
	.string	"erase_blk"
.LASF723:
	.string	"re_save_vpndata"
.LASF463:
	.string	"p_valid_page_count_check_table"
.LASF502:
	.string	"g_gc_free_blk_threshold"
.LASF482:
	.string	"g_num_free_superblocks"
.LASF226:
	.string	"s_addr"
.LASF820:
	.string	"re_save_bbmdata"
.LASF200:
	.string	"UCLASS_SYSRESET"
.LASF628:
	.string	"FtlGcUpdatePage"
.LASF812:
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
.LASF789:
	.string	"IsInFreeQueue"
.LASF236:
	.string	"index"
.LASF746:
	.string	"select_l2p_ram_region"
.LASF335:
	.string	"maxDieNum"
.LASF290:
	.string	"byte_per_sec"
.LASF278:
	.string	"p_data"
.LASF528:
	.string	"g_recovery_page_min_ver"
.LASF571:
	.string	"block_size"
.LASF90:
	.string	"ih_load"
.LASF836:
	.string	"FtlProgPages"
.LASF665:
	.string	"error_flag"
.LASF403:
	.string	"c_ftl_nand_page_pre_blk"
.LASF795:
	.string	"blk_Id"
.LASF213:
	.string	"UCLASS_KEY"
.LASF876:
	.string	"memcpy"
.LASF67:
	.string	"_datarel_start_ofs"
.LASF373:
	.string	"List_Node"
.LASF578:
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
.LASF494:
	.string	"g_gc_page_offset"
.LASF240:
	.string	"net_gateway"
.LASF803:
	.string	"ftl_cmp_data_ver"
.LASF430:
	.string	"g_VaildLpn"
.LASF471:
	.string	"p_vendor_block_valid_page_count"
.LASF262:
	.string	"net_ping_ip"
.LASF104:
	.string	"type"
.LASF40:
	.string	"lmb_region"
.LASF633:
	.string	"numREQ"
.LASF34:
	.string	"protect"
.LASF856:
	.string	"max_test_page_num"
.LASF705:
	.string	"blk_id"
.LASF349:
	.string	"GlobalDataVersion"
.LASF794:
	.string	"erase_flag"
.LASF362:
	.string	"last_refresh_data_times"
.LASF708:
	.string	"totleBlkNum"
.LASF679:
	.string	"saved_active_page"
.LASF777:
	.string	"pTmp"
.LASF605:
	.string	"add_count"
.LASF547:
	.string	"ftl_gc_temp_block_bops_scan_page_addr"
.LASF394:
	.string	"c_ftl_nand_type"
.LASF774:
	.string	"pHead"
.LASF688:
	.string	"recovery_flash_mode"
.LASF138:
	.string	"UCLASS_TEST"
.LASF485:
	.string	"g_buffer_superblock"
.LASF650:
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
.LASF575:
	.string	"read_req"
.LASF432:
	.string	"gBbtInfo"
.LASF169:
	.string	"UCLASS_MISC"
.LASF31:
	.string	"sector_count"
.LASF406:
	.string	"c_ftl_nand_sec_pre_page"
.LASF591:
	.string	"mode"
.LASF814:
	.string	"FtlLoadBbt"
.LASF561:
	.string	"pvForm"
.LASF323:
	.string	"padding"
.LASF460:
	.string	"p_swl_mul_table"
.LASF629:
	.string	"src_ppa"
.LASF683:
	.string	"detected_active_page"
.LASF389:
	.string	"ftl_gc_page_item"
.LASF549:
	.string	"mem_malloc_start"
.LASF210:
	.string	"UCLASS_VIDEO_CRTC"
.LASF58:
	.string	"bi_ethspeed"
.LASF98:
	.string	"image_header_t"
.LASF771:
	.string	"pPrev"
.LASF474:
	.string	"g_totle_vendor_block"
.LASF624:
	.string	"superblock_id"
.LASF595:
	.string	"plane"
.LASF11:
	.string	"phys_addr_t"
.LASF95:
	.string	"ih_type"
.LASF846:
	.string	"sftl_init"
.LASF2:
	.string	"unsigned char"
.LASF613:
	.string	"FtlGcScanTempBlk"
.LASF109:
	.string	"legacy_hdr_os_copy"
.LASF761:
	.string	"vpcTbl"
.LASF176:
	.string	"UCLASS_PANEL_BACKLIGHT"
.LASF339:
	.string	"activeSuperblockId"
.LASF804:
	.string	"ver1"
.LASF280:
	.string	"nand_phy_info"
.LASF760:
	.string	"ftl_free_no_use_map_blk"
.LASF806:
	.string	"P2V_block_in_plane"
.LASF556:
	.string	"str1"
.LASF557:
	.string	"str2"
.LASF719:
	.string	"pMapHeader"
.LASF140:
	.string	"UCLASS_TEST_BUS"
.LASF717:
	.string	"FtlScanSysBlk"
.LASF52:
	.string	"bi_arm_freq"
.LASF696:
	.string	"lookup_ppa_ver"
.LASF753:
	.string	"region_num"
.LASF476:
	.string	"p_l2p_map_buf"
.LASF488:
	.string	"gp_last_act_superblock"
.LASF871:
	.string	"Ftl_log2"
.LASF448:
	.string	"p_sys_spare_buf"
.LASF165:
	.string	"UCLASS_LED"
.LASF552:
	.string	"p_current"
.LASF647:
	.string	"get_new_id"
.LASF253:
	.string	"net_rx_packet_len"
.LASF255:
	.string	"net_null_ethaddr"
.LASF543:
	.string	"g_ect_tbl_power_up_flush"
.LASF597:
	.string	"physical_block"
.LASF32:
	.string	"flash_id"
.LASF839:
	.string	"absolute_sector"
.LASF222:
	.string	"load_addr"
.LASF347:
	.string	"PowerLostTimes"
.LASF501:
	.string	"g_gc_bad_block_temp_tbl"
.LASF886:
	.string	"kfree"
.LASF464:
	.string	"p_blk_mode_table"
.LASF776:
	.string	"List_remove_node"
.LASF291:
	.string	"reserved_blk"
.LASF734:
	.string	"pBuf"
.LASF792:
	.string	"tmp_ec"
.LASF484:
	.string	"g_active_superblock"
.LASF690:
	.string	"recovery_super_page"
.LASF437:
	.string	"req_sys"
.LASF381:
	.string	"available_pages"
.LASF800:
	.string	"high"
.LASF834:
	.string	"nscts"
.LASF410:
	.string	"c_ftl_nand_reserved_blks"
.LASF701:
	.string	"FtlL2PDataInit"
.LASF230:
	.string	"init"
.LASF215:
	.string	"UCLASS_CHARGE_DISPLAY"
.LASF573:
	.string	"check"
.LASF145:
	.string	"UCLASS_USB_EMUL"
.LASF798:
	.string	"FtlFreeSysBlkQueueInit"
.LASF678:
	.string	"FtlRecoverySuperblock"
.LASF396:
	.string	"c_ftl_nand_planes_per_die"
.LASF405:
	.string	"c_ftl_nand_page_pre_super_blk"
.LASF292:
	.string	"ecc_bits"
.LASF293:
	.string	"nand_ops"
.LASF602:
	.string	"tmp_blk"
.LASF523:
	.string	"g_gc_head_data_block"
.LASF829:
	.string	"FtlWrite"
.LASF182:
	.string	"UCLASS_PINCTRL"
.LASF832:
	.string	"num_lpa"
.LASF868:
	.string	"blkNum"
.LASF364:
	.string	"SlcPartLbaEndSector"
.LASF84:
	.string	"fdt32_t"
.LASF469:
	.string	"g_totle_map_block"
.LASF375:
	.string	"value"
.LASF211:
	.string	"UCLASS_WDT"
.LASF101:
	.string	"image_len"
.LASF441:
	.string	"req_gc"
.LASF855:
	.string	"is_sys_blk"
.LASF42:
	.string	"memory"
.LASF822:
	.string	"bitmap"
.LASF319:
	.string	"ftl_ect_tbl_info"
.LASF205:
	.string	"UCLASS_USB_DEV_GENERIC"
.LASF212:
	.string	"UCLASS_FG"
.LASF756:
	.string	"lastMapBlk"
.LASF370:
	.string	"totle_write_sector"
.LASF522:
	.string	"g_ftl_nand_free_count"
.LASF627:
	.string	"p_gc_page"
.LASF20:
	.string	"errno"
.LASF532:
	.string	"gNandPhyInfo"
.LASF862:
	.string	"ven_blk"
.LASF30:
	.string	"size"
.LASF244:
	.string	"net_hostname"
.LASF773:
	.string	"List_pop_head_node"
.LASF308:
	.string	"BlkNum"
.LASF851:
	.string	"sys_bad_block_cnt"
.LASF599:
	.string	"p_dataHeader"
.LASF781:
	.string	"tmp_id"
.LASF603:
	.string	"FtlReadRefresh"
.LASF646:
	.string	"free_blk_index"
.LASF821:
	.string	"FtlBbt2Bitmap"
.LASF663:
	.string	"ftl_check_vpc"
.LASF108:
	.string	"legacy_hdr_os"
.LASF100:
	.string	"image_start"
.LASF580:
	.string	"page_index"
.LASF18:
	.string	"uint8_t"
.LASF55:
	.string	"bi_bootflags"
.LASF487:
	.string	"g_gc_superblock"
.LASF303:
	.string	"ftl_sys_info"
.LASF87:
	.string	"ih_hcrc"
.LASF377:
	.string	"front"
.LASF175:
	.string	"UCLASS_PANEL"
.LASF472:
	.string	"p_vendor_block_ver_table"
.LASF204:
	.string	"UCLASS_USB"
.LASF517:
	.string	"g_totle_slc_erase_count"
.LASF461:
	.string	"g_totle_swl_count"
.LASF139:
	.string	"UCLASS_TEST_FDT"
.LASF294:
	.string	"get_bad_blk_list"
.LASF343:
	.string	"gcTempSuperblockId"
.LASF238:
	.string	"eth_current"
.LASF767:
	.string	"node_valid_page_count"
.LASF53:
	.string	"bi_dsp_freq"
.LASF5:
	.string	"uchar"
.LASF669:
	.string	"pages"
.LASF89:
	.string	"ih_size"
.LASF570:
	.string	"addr"
.LASF142:
	.string	"UCLASS_SPI_EMUL"
.LASF864:
	.string	"FtlMemInit"
.LASF819:
	.string	"write_count"
.LASF664:
	.string	"prev_ppa"
.LASF589:
	.string	"FlashTestBlk"
.LASF179:
	.string	"UCLASS_PCI_GENERIC"
.LASF50:
	.string	"bi_sramstart"
.LASF66:
	.string	"FIQ_STACK_START"
.LASF873:
	.string	"rknand_proc_ftlread"
.LASF228:
	.string	"enetaddr"
.LASF181:
	.string	"UCLASS_PINCONFIG"
.LASF742:
	.string	"l2p_region_id"
.LASF554:
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
.LASF770:
	.string	"prev_multiplier_value"
.LASF497:
	.string	"g_gc_next_blk"
.LASF516:
	.string	"g_min_erase_count"
.LASF149:
	.string	"UCLASS_BLK"
.LASF546:
	.string	"gc_discard_updated"
.LASF738:
	.string	"FtlVendorPartWrite"
.LASF622:
	.string	"FtlGcFreeTempBlock"
.LASF248:
	.string	"net_ip"
.LASF229:
	.string	"iobase"
.LASF658:
	.string	"GetFreeBlockMinEraseCount"
.LASF336:
	.string	"activeFlashMode"
.LASF92:
	.string	"ih_dcrc"
.LASF35:
	.string	"flash_info_t"
.LASF656:
	.string	"GetFreeBlockMaxEraseCount"
.LASF712:
	.string	"sblk"
.LASF755:
	.string	"ftl_map_blk_gc"
.LASF878:
	.string	"printf"
.LASF59:
	.string	"bi_intfreq"
.LASF223:
	.string	"save_addr"
.LASF538:
	.string	"TotleReadBufferCount1"
.LASF567:
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
.LASF541:
	.string	"TotleReadBufferMatchCount"
.LASF438:
	.string	"req_read"
.LASF752:
	.string	"Ftl_write_map_blk_to_last_page"
.LASF466:
	.string	"p_map_block_valid_page_count"
.LASF167:
	.string	"UCLASS_MAILBOX"
.LASF793:
	.string	"FtlFreeSysBlkQueueIn"
.LASF366:
	.string	"readErrorCount"
.LASF588:
	.string	"sftl_gc"
.LASF797:
	.string	"FtlFreeSysBlkQueueEmpty"
.LASF763:
	.string	"load_l2p_region"
.LASF640:
	.string	"p_superblock"
.LASF301:
	.string	"fBbtBlk"
.LASF77:
	.string	"off_mem_rsvmap"
.LASF445:
	.string	"p_sys_data_buf"
.LASF885:
	.string	"l2p_addr_tran"
.LASF164:
	.string	"UCLASS_KEYBOARD"
.LASF287:
	.string	"page_per_slc_blk"
.LASF398:
	.string	"c_ftl_nand_blks_per_die_shift"
.LASF739:
	.string	"log2phys"
.LASF478:
	.string	"p_data_block_list_table"
.LASF171:
	.string	"UCLASS_MOD_EXP"
.LASF645:
	.string	"num_bad_block"
.LASF85:
	.string	"image_header"
.LASF702:
	.string	"FtlLoadVonderInfo"
.LASF614:
	.string	"pSuperblock"
.LASF535:
	.string	"ftl_temp_buf"
.LASF384:
	.string	"flash_mode"
.LASF514:
	.string	"g_totle_mlc_erase_count"
.LASF79:
	.string	"last_comp_version"
.LASF415:
	.string	"c_ftl_nand_map_blks_per_plane"
.LASF811:
	.string	"re_try_next_blk"
.LASF56:
	.string	"bi_ip_addr"
.LASF579:
	.string	"block_index"
.LASF36:
	.string	"flash_info"
.LASF496:
	.string	"g_gc_cur_blk_max_valid_pages"
.LASF16:
	.string	"ushort"
.LASF764:
	.string	"phyAddr"
.LASF73:
	.string	"magic"
.LASF791:
	.string	"tmp_blk_id"
.LASF877:
	.string	"memset"
.LASF242:
	.string	"net_dns_server"
.LASF562:
	.string	"ftl_memset"
.LASF831:
	.string	"end_lpa"
.LASF736:
	.string	"result"
.LASF626:
	.string	"scan_page_num"
.LASF267:
	.string	"NETLOOP_SUCCESS"
.LASF27:
	.string	"name"
.LASF512:
	.string	"g_totle_cache_write_count"
.LASF768:
	.string	"node_multiplier_value"
.LASF759:
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
.LASF687:
	.string	"detected_error_page"
.LASF129:
	.string	"initrd_end"
.LASF620:
	.string	"read_super_page"
.LASF219:
	.string	"monitor_flash_len"
.LASF621:
	.string	"FtlGcPageVarInit"
.LASF823:
	.string	"FtlBbtInfoPrint"
.LASF530:
	.string	"c_mlc_erase_count_value"
.LASF551:
	.string	"mem_malloc_brk"
.LASF483:
	.string	"g_num_data_superblocks"
.LASF754:
	.string	"blkTbl"
.LASF348:
	.string	"mlc_erase_count"
.LASF12:
	.string	"phys_size_t"
.LASF716:
	.string	"FtlLoadEctTbl"
.LASF62:
	.string	"bi_boot_params"
.LASF214:
	.string	"UCLASS_RC"
.LASF51:
	.string	"bi_sramsize"
.LASF881:
	.string	"sprintf"
.LASF608:
	.string	"FtlGcMarkBadPhyBlk"
.LASF642:
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
.LASF600:
	.string	"gc_next_superblock"
.LASF813:
	.string	"blkAddr"
.LASF193:
	.string	"UCLASS_SCSI"
.LASF0:
	.string	"short unsigned int"
.LASF4:
	.string	"signed char"
.LASF250:
	.string	"net_tx_packet"
.LASF697:
	.string	"current_ppa_ver"
.LASF785:
	.string	"tmp_multiplier_value"
.LASF566:
	.string	"FlashEraseBlocks"
.LASF33:
	.string	"start"
.LASF830:
	.string	"start_lpa"
.LASF553:
	.string	"current"
.LASF218:
	.string	"LOGF_MAX_CATEGORIES"
.LASF518:
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
.LASF539:
	.string	"TotleReadBufferCount2"
.LASF540:
	.string	"TotleReadBufferCount3"
.LASF455:
	.string	"c_gc_page_buf_num"
.LASF720:
	.string	"FtlVpcTblFlush"
.LASF189:
	.string	"UCLASS_REMOTEPROC"
.LASF743:
	.string	"lpn_index"
.LASF118:
	.string	"fit_hdr_fdt"
.LASF632:
	.string	"FtlGcBufAlloc"
.LASF569:
	.string	"num_req"
.LASF779:
	.string	"node_erase_count"
.LASF254:
	.string	"net_bcast_ethaddr"
.LASF737:
	.string	"ppn_index"
.LASF796:
	.string	"FtlFreeSysBlkQueueFull"
.LASF133:
	.string	"state"
.LASF48:
	.string	"bi_flashsize"
.LASF747:
	.string	"target_region"
.LASF19:
	.string	"__be32"
.LASF131:
	.string	"cmdline_end"
.LASF418:
	.string	"c_ftl_vendor_part_size"
.LASF251:
	.string	"net_rx_packets"
.LASF827:
	.string	"sftl_read"
.LASF452:
	.string	"p_gc_spare_buf"
.LASF151:
	.string	"UCLASS_CPU"
.LASF467:
	.string	"p_map_block_ver_table"
.LASF456:
	.string	"g_gc_num_req"
.LASF449:
	.string	"p_io_data_buf_0"
.LASF450:
	.string	"p_io_data_buf_1"
.LASF68:
	.string	"_datarelrolocal_start_ofs"
.LASF684:
	.string	"mlc_detected_active_page"
.LASF854:
	.string	"FtlLowFormatEraseBlock"
.LASF317:
	.string	"region_id"
.LASF326:
	.string	"sysBlksPerPlane"
.LASF817:
	.string	"FtlBbtMemInit"
.LASF309:
	.string	"maxBlkNum"
.LASF395:
	.string	"c_ftl_nand_die_num"
.LASF286:
	.string	"page_per_blk"
.LASF722:
	.string	"prog_error_count"
.LASF372:
	.string	"progErrorCount"
.LASF259:
	.string	"net_boot_file_name"
.LASF495:
	.string	"g_gc_cur_blk_valid_pages"
.LASF233:
	.string	"halt"
.LASF654:
	.string	"maxFreeBlockEraseCount"
.LASF86:
	.string	"ih_magic"
.LASF582:
	.string	"block_in_die"
.LASF457:
	.string	"gp_ect_tbl_info"
.LASF655:
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
.LASF786:
	.string	"INSERT_DATA_LIST"
.LASF206:
	.string	"UCLASS_USB_HUB"
.LASF826:
	.string	"sftl_write"
.LASF444:
	.string	"p_plane_order_table"
.LASF782:
	.string	"insert_data_list"
.LASF70:
	.string	"_datarelro_start_ofs"
.LASF619:
	.string	"ReInit"
.LASF172:
	.string	"UCLASS_MTD"
.LASF134:
	.string	"bootm_headers_t"
.LASF730:
	.string	"ec_mod_count"
.LASF565:
	.string	"spare"
.LASF527:
	.string	"g_recovery_page_num"
.LASF15:
	.string	"long int"
.LASF668:
	.string	"req_temp"
.LASF141:
	.string	"UCLASS_TEST_PROBE"
.LASF883:
	.string	"drivers/rkflash/rksftl/rk_sftl.c"
.LASF660:
	.string	"FtlSysBlkInit"
.LASF524:
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
.LASF511:
	.string	"g_tmp_data_superblock_id"
.LASF872:
	.string	"limit"
.LASF661:
	.string	"ftl_scan_all_data"
.LASF331:
	.string	"ftl_sys_blk_header"
.LASF393:
	.string	"flag"
.LASF470:
	.string	"p_vendor_block_table"
.LASF680:
	.string	"saved_active_plane"
.LASF748:
	.string	"hit_count"
.LASF715:
	.string	"FtlGcReFreshBadBlk"
.LASF380:
	.string	"current_page"
.LASF201:
	.string	"UCLASS_THERMAL"
.LASF815:
	.string	"FtlBbtCalcTotleCnt"
.LASF787:
	.string	"INSERT_FREE_LIST"
.LASF563:
	.string	"FlashGetBadBlockList"
.LASF695:
	.string	"prev_ppa_ver"
.LASF246:
	.string	"net_ethaddr"
.LASF225:
	.string	"in_addr"
.LASF845:
	.string	"FtlSysFlush"
.LASF99:
	.string	"image_info"
.LASF88:
	.string	"ih_time"
.LASF610:
	.string	"FtlGcRefreshBlock"
.LASF334:
	.string	"ftl_sys_save_info"
.LASF772:
	.string	"List_get_gc_head_node"
.LASF399:
	.string	"c_ftl_nand_planes_num"
.LASF809:
	.string	"FtlMakeBbt"
.LASF37:
	.string	"long double"
.LASF481:
	.string	"p_data_block_list_tail"
.LASF493:
	.string	"g_gc_blk_num"
.LASF81:
	.string	"size_dt_strings"
.LASF271:
	.string	"uint16"
.LASF606:
	.string	"FtlGcFreeBadSuperBlk"
.LASF106:
	.string	"image_info_t"
.LASF704:
	.string	"pMapBlockInfo"
.LASF618:
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
.LASF692:
	.string	"function_exit"
.LASF135:
	.string	"images"
.LASF525:
	.string	"g_gc_skip_write_count"
.LASF585:
	.string	"rknand_print_hex"
.LASF636:
	.string	"FtlGcBufInit"
.LASF446:
	.string	"p_sys_data_buf_1"
.LASF14:
	.string	"char"
.LASF310:
	.string	"pBlkTbl"
.LASF113:
	.string	"fit_uname_os"
.LASF500:
	.string	"g_gc_bad_block_gc_index"
.LASF693:
	.string	"last_page_version"
.LASF802:
	.string	"pagePreBlk"
.LASF281:
	.string	"nand_type"
.LASF112:
	.string	"fit_hdr_os"
.LASF283:
	.string	"plane_per_die"
.LASF490:
	.string	"g_sys_ext_data"
.LASF272:
	.string	"uint32"
.LASF564:
	.string	"table"
.LASF299:
	.string	"page"
.LASF643:
	.string	"allocate_data_superblock"
.LASF316:
	.string	"ftl_l2p_ram_map_info"
.LASF102:
	.string	"load"
.LASF264:
	.string	"net_loop_state"
.LASF433:
	.string	"gSysInfo"
.LASF630:
	.string	"prev_superblock_id"
.LASF196:
	.string	"UCLASS_SPMI"
.LASF757:
	.string	"minValidPageIndex"
.LASF842:
	.string	"last_lpa_nscts"
.LASF194:
	.string	"UCLASS_SERIAL"
.LASF710:
	.string	"FtlLoadSysInfo"
.LASF440:
	.string	"req_erase"
.LASF320:
	.string	"hash"
.LASF545:
	.string	"check_vpc_table"
.LASF180:
	.string	"UCLASS_PHY"
.LASF54:
	.string	"bi_ddr_freq"
.LASF859:
	.string	"test_mode"
.LASF828:
	.string	"FtlDiscard"
.LASF671:
	.string	"FtlGcPageRecovery"
.LASF105:
	.string	"arch"
.LASF510:
	.string	"g_totle_read_page_count"
.LASF711:
	.string	"ftl_get_blk_mode"
.LASF741:
	.string	"ram_region_id"
.LASF435:
	.string	"gL2pMapInfo"
.LASF322:
	.string	"lastEc"
.LASF843:
	.string	"sector"
.LASF558:
	.string	"ftl_memcmp"
.LASF468:
	.string	"p_map_region_ppn_table"
.LASF120:
	.string	"fit_noffset_fdt"
.LASF867:
	.string	"FtlSysBlkNumInit"
.LASF672:
	.string	"Ftl_save_ext_data"
.LASF116:
	.string	"fit_uname_rd"
.LASF649:
	.string	"GetSwlReplaceBlock"
.LASF359:
	.string	"max_erase_count"
.LASF475:
	.string	"p_l2p_ram_map"
.LASF634:
	.string	"req_num"
.LASF115:
	.string	"fit_hdr_rd"
.LASF268:
	.string	"NETLOOP_FAIL"
.LASF824:
	.string	"FtlBbmIsBadBlock"
.LASF667:
	.string	"FtlSuperblockPowerLostFix"
.LASF157:
	.string	"UCLASS_FIRMWARE"
.LASF123:
	.string	"fit_noffset_setup"
.LASF401:
	.string	"c_ftl_nand_ext_blk_pre_plane"
.LASF550:
	.string	"mem_malloc_end"
.LASF451:
	.string	"p_io_spare_buf"
.LASF185:
	.string	"UCLASS_POWER_DOMAIN"
.LASF520:
	.string	"g_in_gc_progress"
.LASF168:
	.string	"UCLASS_MASS_STORAGE"
.LASF29:
	.string	"block_drvr"
.LASF173:
	.string	"UCLASS_NORTHBRIDGE"
.LASF422:
	.string	"c_ftl_nand_data_blks_per_plane"
.LASF617:
	.string	"page_count"
.LASF298:
	.string	"ftl_bbt_info"
.LASF160:
	.string	"UCLASS_I2C_GENERIC"
.LASF231:
	.string	"send"
.LASF531:
	.string	"g_power_lost_recovery_flag"
.LASF592:
	.string	"numPages"
.LASF447:
	.string	"p_vendor_data_buf"
.LASF354:
	.string	"read_page_count"
.LASF234:
	.string	"write_hwaddr"
.LASF726:
	.string	"FtlMapBlkWriteDump_data"
.LASF835:
	.string	"FtlCacheWriteBack"
.LASF700:
	.string	"FtlLoadMapInfo"
.LASF808:
	.string	"V2P_block"
.LASF721:
	.string	"pSysHeader"
.LASF673:
	.string	"SupperBlkListInit"
.LASF707:
	.string	"ppnTbl"
.LASF847:
	.string	"pNand"
.LASF559:
	.string	"ftl_memcpy"
.LASF346:
	.string	"PowerOnTimes"
.LASF505:
	.string	"g_totle_gc_page_count"
.LASF24:
	.string	"_binary_u_boot_bin_start"
.LASF674:
	.string	"num_data_node"
.LASF400:
	.string	"c_ftl_nand_blk_pre_plane"
.LASF884:
	.string	"/home/ldq/rk-linux/u-boot-release"
.LASF64:
	.string	"bd_t"
.LASF706:
	.string	"lastWritePage"
.LASF91:
	.string	"ih_ep"
.LASF45:
	.string	"bi_memstart"
.LASF119:
	.string	"fit_uname_fdt"
.LASF187:
	.string	"UCLASS_RAM"
.LASF675:
	.string	"num_free_node"
.LASF379:
	.string	"ftl_superblock_info"
.LASF126:
	.string	"ft_addr"
.LASF357:
	.string	"sys_slc_erase_count"
.LASF513:
	.string	"g_totle_l2p_write_count"
.LASF220:
	.string	"__dtb_dt_begin"
.LASF217:
	.string	"UCLASS_INVALID"
.LASF443:
	.string	"g_req_cache"
.LASF594:
	.string	"gc_blk"
.LASF277:
	.string	"page_addr"
.LASF865:
	.string	"mem_size"
.LASF858:
	.string	"test_page_step"
.LASF689:
	.string	"read_super_page_end"
.LASF368:
	.string	"refresh_enable_mode"
.LASF848:
	.string	"load_bbt"
.LASF861:
	.string	"IsBlkInVendorPart"
.LASF402:
	.string	"c_ftl_nand_bbm_buf_size"
.LASF783:
	.string	"node_data_count"
.LASF583:
	.string	"width"
.LASF39:
	.string	"base"
.LASF887:
	.string	"sftl_get_density"
.LASF840:
	.string	"first_lpa_sctidx"
.LASF590:
	.string	"rk_ftl_garbage_collect"
.LASF328:
	.string	"lastPpa"
.LASF111:
	.string	"fit_uname_cfg"
.LASF344:
	.string	"gcTempPageOffset"
.LASF637:
	.string	"decrement_vpc_count"
.LASF386:
	.string	"dump_writed"
.LASF749:
	.string	"flush_l2p_region"
.LASF130:
	.string	"cmdline_start"
.LASF536:
	.string	"DeviceCapacity"
.LASF355:
	.string	"l2p_write_count"
.LASF548:
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
.LASF849:
	.string	"ftl_low_format"
.LASF735:
	.string	"offset"
.LASF504:
	.string	"g_gc_blk_index"
.LASF439:
	.string	"req_prgm"
.LASF436:
	.string	"gVendorBlkInfo"
.LASF677:
	.string	"FtlPowerLostRecovery"
.LASF462:
	.string	"p_valid_page_count_table"
.LASF703:
	.string	"FtlMapTblRecovery"
.LASF156:
	.string	"UCLASS_GPIO"
.LASF870:
	.string	"debug_flag"
.LASF498:
	.string	"g_gc_next_blk_1"
.LASF76:
	.string	"off_dt_strings"
.LASF376:
	.string	"sys_blk_queue"
.LASF648:
	.string	"free_data_superblock"
.LASF860:
	.string	"re_test_next_page"
.LASF61:
	.string	"bi_arch_number"
.LASF750:
	.string	"FtlMapWritePage"
.LASF784:
	.string	"tmp_data_count"
.LASF26:
	.string	"ide_bus_offset"
.LASF740:
	.string	"action"
.LASF408:
	.string	"c_ftl_nand_byte_pre_page"
.LASF216:
	.string	"UCLASS_COUNT"
.LASF174:
	.string	"UCLASS_NVME"
.LASF644:
	.string	"new_id"
.LASF345:
	.string	"cache_write_count"
.LASF641:
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
.LASF458:
	.string	"g_ect_tbl_info_size"
.LASF338:
	.string	"gcTempFlashMode"
.LASF431:
	.string	"g_MaxLbn"
.LASF534:
	.string	"g_nand_ops"
.LASF584:
	.string	"ftl_malloc"
.LASF841:
	.string	"first_lpa_nscts"
.LASF183:
	.string	"UCLASS_PMIC"
.LASF318:
	.string	"L2PMap"
.LASF766:
	.string	"prev_node_id"
.LASF454:
	.string	"gp_gc_page_buf_info"
.LASF509:
	.string	"g_totle_discard_page_count"
.LASF657:
	.string	"max_ec"
.LASF537:
	.string	"gFtlInitStatus"
.LASF9:
	.string	"long long int"
.LASF459:
	.string	"p_erase_count_table"
.LASF825:
	.string	"FtlBbmMapBadBlock"
.LASF427:
	.string	"g_GlobalDataVersion"
.LASF718:
	.string	"block_in_plane"
.LASF128:
	.string	"initrd_start"
.LASF428:
	.string	"g_MaxLbaSector"
.LASF382:
	.string	"current_plane"
.LASF880:
	.string	"free"
.LASF383:
	.string	"num_planes"
.LASF801:
	.string	"spareBuf"
.LASF731:
	.string	"FtlVendorPartRead"
.LASF724:
	.string	"FtlWriteDump_data"
.LASF197:
	.string	"UCLASS_SPI_FLASH"
.LASF202:
	.string	"UCLASS_TIMER"
.LASF799:
	.string	"FtlGetLastWrittenPage"
.LASF662:
	.string	"pDataHeader"
.LASF542:
	.string	"power_up_flag"
.LASF365:
	.string	"inkDie_write_and_check_en"
.LASF413:
	.string	"c_ftl_nand_l2pmap_ram_region_num"
.LASF844:
	.string	"sftl_deinit"
.LASF816:
	.string	"totle_count"
.LASF282:
	.string	"die_num"
.LASF751:
	.string	"update_map_block"
.LASF307:
	.string	"maxRegion"
.LASF681:
	.string	"next_free_active_plane"
.LASF491:
	.string	"p_gc_page_info"
.LASF256:
	.string	"net_our_vlan"
.LASF361:
	.string	"totle_power_on_run_times"
.LASF93:
	.string	"ih_os"
.LASF526:
	.string	"g_cur_erase_blk"
.LASF184:
	.string	"UCLASS_PWM"
.LASF635:
	.string	"FtlGcBufFree"
.LASF775:
	.string	"List_pop_index_node"
.LASF691:
	.string	"scan_completed"
.LASF638:
	.string	"update_vpc_list"
.LASF170:
	.string	"UCLASS_MMC"
.LASF465:
	.string	"p_map_block_table"
.LASF544:
	.string	"FtlUpdateVaildLpnCount"
.LASF332:
	.string	"res32_0"
.LASF333:
	.string	"res32_1"
.LASF727:
	.string	"FtlUpdateVaildLpn"
.LASF390:
	.string	"scr_ppa"
.LASF162:
	.string	"UCLASS_IDE"
.LASF224:
	.string	"save_size"
.LASF78:
	.string	"version"
.LASF653:
	.string	"pNode"
.LASF639:
	.string	"get_new_active_ppa"
.LASF879:
	.string	"kmalloc"
.LASF25:
	.string	"_binary_u_boot_bin_end"
.LASF598:
	.string	"max_gc_page_num"
.LASF1:
	.string	"unsigned int"
.LASF713:
	.string	"FtlSlcSuperblockCheck"
.LASF515:
	.string	"g_totle_avg_erase_count"
.LASF837:
	.string	"flashType"
.LASF790:
	.string	"FtlFreeSysBLkSort"
.LASF780:
	.string	"tmp_erase_count"
.LASF83:
	.string	"working_fdt"
.LASF863:
	.string	"FtlVariablesInit"
.LASF392:
	.string	"ftl_gc_page_buffer"
.LASF239:
	.string	"push_packet"
.LASF709:
	.string	"pMapBlkHeader"
.LASF82:
	.string	"size_dt_struct"
.LASF473:
	.string	"p_vendor_region_ppn_table"
.LASF676:
	.string	"make_superblock"
.LASF97:
	.string	"ih_name"
.LASF186:
	.string	"UCLASS_PWRSEQ"
.LASF337:
	.string	"bufferFlashMode"
.LASF7:
	.string	"short int"
.LASF838:
	.string	"FtlRead"
.LASF74:
	.string	"totalsize"
.LASF758:
	.string	"ftl_map_blk_alloc_new_blk"
.LASF385:
	.string	"check_en"
.LASF442:
	.string	"req_gc_dst"
.LASF374:
	.string	"prev"
.LASF423:
	.string	"c_ftl_nand_data_op_blks_per_plane"
.LASF651:
	.string	"min_ec_id"
.LASF388:
	.string	"phyBlk"
.LASF260:
	.string	"net_boot_file_size"
.LASF412:
	.string	"c_ftl_nand_map_region_num"
.LASF666:
	.string	"FtlVpcCheckAndModify"
.LASF127:
	.string	"ft_len"
.LASF188:
	.string	"UCLASS_REGULATOR"
.LASF311:
	.string	"pBlkVerTbl"
.LASF489:
	.string	"g_sys_save_data"
.LASF124:
	.string	"rd_start"
	.hidden	free
