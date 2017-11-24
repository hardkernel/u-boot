	.syntax unified
	.arch armv7-a
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.thumb
	.file	"rk_ftl_arm_v7.c"
	.section	.text.FlashMemCmp8,"ax",%progbits
	.align	1
	.global	FlashMemCmp8
	.thumb
	.thumb_func
	.type	FlashMemCmp8, %function
FlashMemCmp8:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L10
	push	{r4, r5, lr}
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L9
	ldrb	r4, [r0, #1]	@ zero_extendqisi2
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r4, r3
	beq	.L8
	movs	r3, #0
	b	.L9
.L6:
	ldrb	r5, [r0, r3]	@ zero_extendqisi2
	ldrb	r4, [r1, r3]	@ zero_extendqisi2
	add	r3, r3, #1
	cmp	r5, r4
	beq	.L9
	mov	r0, r3
	pop	{r4, r5, pc}
.L9:
	cmp	r3, r2
	bne	.L6
	movs	r0, #0
	pop	{r4, r5, pc}
.L8:
	movs	r0, #0
	pop	{r4, r5, pc}
.L11:
	.align	2
.L10:
	.word	.LANCHOR0
	.size	FlashMemCmp8, .-FlashMemCmp8
	.section	.text.FlashRsvdBlkChk,"ax",%progbits
	.align	1
	.global	FlashRsvdBlkChk
	.thumb
	.thumb_func
	.type	FlashRsvdBlkChk, %function
FlashRsvdBlkChk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L15
	ldr	r2, .L15+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	muls	r3, r2, r3
	cmp	r1, r3
	bcs	.L14
	adds	r0, r0, #0
	it	ne
	movne	r0, #1
	bx	lr
.L14:
	movs	r0, #1
	bx	lr
.L16:
	.align	2
.L15:
	.word	.LANCHOR1
	.word	.LANCHOR2
	.size	FlashRsvdBlkChk, .-FlashRsvdBlkChk
	.section	.text.FlashGetRandomizer,"ax",%progbits
	.align	1
	.global	FlashGetRandomizer
	.thumb
	.thumb_func
	.type	FlashGetRandomizer, %function
FlashGetRandomizer:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L19
	and	r2, r1, #127
	push	{r4, lr}
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L19+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L18
	bl	FlashRsvdBlkChk
	cbz	r0, .L18
	orr	r4, r4, #-1073741824
.L18:
	mov	r0, r4
	pop	{r4, pc}
.L20:
	.align	2
.L19:
	.word	.LANCHOR3
	.word	.LANCHOR4
	.size	FlashGetRandomizer, .-FlashGetRandomizer
	.section	.text.FlashSetRandomizer,"ax",%progbits
	.align	1
	.global	FlashSetRandomizer
	.thumb
	.thumb_func
	.type	FlashSetRandomizer, %function
FlashSetRandomizer:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	and	r2, r1, #127
	ldr	r3, .L23
	mov	r5, r0
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L23+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L22
	bl	FlashRsvdBlkChk
	cbz	r0, .L22
	orr	r4, r4, #-1073741824
.L22:
	ldr	r3, .L23+8
	ldr	r3, [r3, r5, lsl #3]
	str	r4, [r3, #336]
	pop	{r3, r4, r5, pc}
.L24:
	.align	2
.L23:
	.word	.LANCHOR3
	.word	.LANCHOR4
	.word	.LANCHOR5
	.size	FlashSetRandomizer, .-FlashSetRandomizer
	.section	.text.FlashReadCmd,"ax",%progbits
	.align	1
	.global	FlashReadCmd
	.thumb
	.thumb_func
	.type	FlashReadCmd, %function
FlashReadCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	lsrs	r2, r1, #16
	ldr	r4, .L26
	mov	r5, r0
	ldr	r6, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	movs	r4, #0
	adds	r3, r3, #8
	add	r3, r6, r3, lsl #8
	str	r4, [r3, #8]
	str	r4, [r3, #4]
	str	r4, [r3, #4]
	uxtb	r4, r1
	str	r4, [r3, #4]
	lsrs	r4, r1, #8
	str	r4, [r3, #4]
	str	r2, [r3, #4]
	movs	r2, #48
	str	r2, [r3, #8]
	pop	{r4, r5, r6, lr}
	b	FlashSetRandomizer
.L27:
	.align	2
.L26:
	.word	.LANCHOR5
	.size	FlashReadCmd, .-FlashReadCmd
	.section	.text.FlashReadDpDataOutCmd,"ax",%progbits
	.align	1
	.global	FlashReadDpDataOutCmd
	.thumb
	.thumb_func
	.type	FlashReadDpDataOutCmd, %function
FlashReadDpDataOutCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L32
	push	{r4, lr}
	ldr	r4, [r2, r0, lsl #3]
	add	r2, r2, r0, lsl #3
	ldrb	r3, [r2, #4]	@ zero_extendqisi2
	ldr	r2, .L32+4
	adds	r3, r3, #8
	ldrb	r2, [r2, #16]	@ zero_extendqisi2
	add	r3, r4, r3, lsl #8
	cmp	r2, #1
	mov	r2, #0
	bne	.L29
	movs	r4, #6
	str	r4, [r3, #8]
	str	r2, [r3, #4]
	str	r2, [r3, #4]
	uxtb	r2, r1
	str	r2, [r3, #4]
	lsrs	r2, r1, #8
	str	r2, [r3, #4]
	lsrs	r2, r1, #16
	b	.L31
.L29:
	str	r2, [r3, #8]
	uxtb	r4, r1
	str	r2, [r3, #4]
	str	r2, [r3, #4]
	str	r4, [r3, #4]
	lsrs	r4, r1, #8
	str	r4, [r3, #4]
	lsrs	r4, r1, #16
	str	r4, [r3, #4]
	movs	r4, #5
	str	r4, [r3, #8]
	str	r2, [r3, #4]
.L31:
	str	r2, [r3, #4]
	movs	r2, #224
	str	r2, [r3, #8]
	pop	{r4, lr}
	b	FlashSetRandomizer
.L33:
	.align	2
.L32:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
	.section	.text.flash_enter_slc_mode,"ax",%progbits
	.align	1
	.global	flash_enter_slc_mode
	.thumb
	.thumb_func
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L36
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L34
	ldr	r3, .L36+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r3, r2, r3, lsl #8
	movs	r2, #218
	str	r2, [r3, #8]
.L34:
	bx	lr
.L37:
	.align	2
.L36:
	.word	.LANCHOR7
	.word	.LANCHOR5
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",%progbits
	.align	1
	.global	flash_exit_slc_mode
	.thumb
	.thumb_func
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L40
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L38
	ldr	r3, .L40+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r3, r2, r3, lsl #8
	movs	r2, #223
	str	r2, [r3, #8]
.L38:
	bx	lr
.L41:
	.align	2
.L40:
	.word	.LANCHOR7
	.word	.LANCHOR5
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
	.section	.text.FlashProgFirstCmd,"ax",%progbits
	.align	1
	.global	FlashProgFirstCmd
	.thumb
	.thumb_func
	.type	FlashProgFirstCmd, %function
FlashProgFirstCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	lsrs	r2, r1, #16
	ldr	r4, .L43
	mov	r5, r0
	ldr	r6, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	movs	r4, #128
	adds	r3, r3, #8
	add	r3, r6, r3, lsl #8
	str	r4, [r3, #8]
	movs	r4, #0
	str	r4, [r3, #4]
	str	r4, [r3, #4]
	uxtb	r4, r1
	str	r4, [r3, #4]
	lsrs	r4, r1, #8
	str	r4, [r3, #4]
	str	r2, [r3, #4]
	pop	{r4, r5, r6, lr}
	b	FlashSetRandomizer
.L44:
	.align	2
.L43:
	.word	.LANCHOR5
	.size	FlashProgFirstCmd, .-FlashProgFirstCmd
	.section	.text.FlashEraseCmd,"ax",%progbits
	.align	1
	.global	FlashEraseCmd
	.thumb
	.thumb_func
	.type	FlashEraseCmd, %function
FlashEraseCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldr	r4, .L47
	ldr	r5, [r4, r0, lsl #3]
	add	r0, r4, r0, lsl #3
	ldrb	r3, [r0, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r3, r5, r3, lsl #8
	cbz	r2, .L46
	movs	r2, #96
	str	r2, [r3, #8]
	uxtb	r2, r1
	str	r2, [r3, #4]
	lsrs	r2, r1, #8
	str	r2, [r3, #4]
	lsrs	r2, r1, #16
	str	r2, [r3, #4]
	ldr	r2, .L47+4
	ldr	r2, [r2, #0]
	adds	r1, r1, r2
.L46:
	movs	r2, #96
	str	r2, [r3, #8]
	uxtb	r2, r1
	str	r2, [r3, #4]
	lsrs	r2, r1, #8
	lsrs	r1, r1, #16
	str	r2, [r3, #4]
	movs	r2, #208
	str	r1, [r3, #4]
	str	r2, [r3, #8]
	pop	{r4, r5, pc}
.L48:
	.align	2
.L47:
	.word	.LANCHOR5
	.word	.LANCHOR2
	.size	FlashEraseCmd, .-FlashEraseCmd
	.section	.text.FlashProgDpSecondCmd,"ax",%progbits
	.align	1
	.global	FlashProgDpSecondCmd
	.thumb
	.thumb_func
	.type	FlashProgDpSecondCmd, %function
FlashProgDpSecondCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	lsrs	r2, r1, #16
	ldr	r4, .L50
	mov	r5, r0
	ldr	r6, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	ldr	r4, .L50+4
	adds	r3, r3, #8
	ldrb	r4, [r4, #11]	@ zero_extendqisi2
	add	r3, r6, r3, lsl #8
	str	r4, [r3, #8]
	movs	r4, #0
	str	r4, [r3, #4]
	str	r4, [r3, #4]
	uxtb	r4, r1
	str	r4, [r3, #4]
	lsrs	r4, r1, #8
	str	r4, [r3, #4]
	str	r2, [r3, #4]
	pop	{r4, r5, r6, lr}
	b	FlashSetRandomizer
.L51:
	.align	2
.L50:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	FlashProgDpSecondCmd, .-FlashProgDpSecondCmd
	.section	.text.FlashProgSecondCmd,"ax",%progbits
	.align	1
	.global	FlashProgSecondCmd
	.thumb
	.thumb_func
	.type	FlashProgSecondCmd, %function
FlashProgSecondCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L53
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r3, r2, r3, lsl #8
	movs	r2, #16
	str	r2, [r3, #8]
	bx	lr
.L54:
	.align	2
.L53:
	.word	.LANCHOR5
	.size	FlashProgSecondCmd, .-FlashProgSecondCmd
	.section	.text.FlashProgDpFirstCmd,"ax",%progbits
	.align	1
	.global	FlashProgDpFirstCmd
	.thumb
	.thumb_func
	.type	FlashProgDpFirstCmd, %function
FlashProgDpFirstCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L56
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r3, r2, r3, lsl #8
	ldr	r2, .L56+4
	ldrb	r2, [r2, #10]	@ zero_extendqisi2
	str	r2, [r3, #8]
	bx	lr
.L57:
	.align	2
.L56:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	FlashProgDpFirstCmd, .-FlashProgDpFirstCmd
	.section	.text.FlashReadStatus,"ax",%progbits
	.align	1
	.global	FlashReadStatus
	.thumb
	.thumb_func
	.type	FlashReadStatus, %function
FlashReadStatus:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r2, #112
	ldr	r3, .L59
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	movs	r0, #80
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	adds	r4, r4, #8
	lsls	r4, r4, #8
	adds	r3, r5, r4
	str	r2, [r3, #8]
	bl	udelay
	ldr	r0, [r5, r4]
	pop	{r3, r4, r5, pc}
.L60:
	.align	2
.L59:
	.word	.LANCHOR5
	.size	FlashReadStatus, .-FlashReadStatus
	.section	.text.JSHash,"ax",%progbits
	.align	1
	.global	JSHash
	.thumb
	.thumb_func
	.type	JSHash, %function
JSHash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r3, r0
	movs	r2, #0
	push	{r4, r5, lr}
	ldr	r0, .L64
	b	.L62
.L63:
	lsls	r4, r0, #5
	ldrb	r5, [r3, r2]	@ zero_extendqisi2
	add	r4, r4, r0, lsr #2
	adds	r2, r2, #1
	adds	r4, r4, r5
	eors	r0, r0, r4
.L62:
	cmp	r2, r1
	bne	.L63
	pop	{r4, r5, pc}
.L65:
	.align	2
.L64:
	.word	1204201446
	.size	JSHash, .-JSHash
	.section	.text.FlashLoadIdbInfo,"ax",%progbits
	.align	1
	.global	FlashLoadIdbInfo
	.thumb
	.thumb_func
	.type	FlashLoadIdbInfo, %function
FlashLoadIdbInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	FlashLoadIdbInfo, .-FlashLoadIdbInfo
	.section	.text.BuildFlashLsbPageTable,"ax",%progbits
	.align	1
	.global	BuildFlashLsbPageTable
	.thumb
	.thumb_func
	.type	BuildFlashLsbPageTable, %function
BuildFlashLsbPageTable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r1
	cbnz	r0, .L68
	ldr	r3, .L107
.L69:
	strh	r0, [r3, #2]!	@ movhi
	adds	r0, r0, #1
	uxth	r0, r0
	cmp	r0, #256
	bne	.L69
	b	.L70
.L68:
	cmp	r0, #1
	bne	.L71
	movs	r2, #0
	ldr	r0, .L107+4
	mov	r3, r2
.L74:
	uxth	r1, r3
	cmp	r1, #3
	bls	.L72
	tst	r3, #1
	ite	eq
	moveq	r1, #2
	movne	r1, #3
	subs	r1, r2, r1
	uxth	r1, r1
.L72:
	adds	r3, r3, #1
	strh	r1, [r2, r0]	@ movhi
	adds	r2, r2, #2
	cmp	r3, #256
	bne	.L74
	b	.L70
.L71:
	cmp	r0, #2
	bne	.L75
	movs	r3, #0
	ldr	r0, .L107
	movw	r2, #65535
	mov	r1, r3
	b	.L106
.L78:
	cmp	r3, #1
	ite	ls
	movls	r1, r3
	movhi	r1, r2
.L106:
	adds	r3, r3, #1
	adds	r2, r2, #2
	strh	r1, [r0, #2]!	@ movhi
	uxth	r3, r3
	uxth	r2, r2
	cmp	r3, #256
	bne	.L78
	b	.L70
.L75:
	cmp	r0, #3
	mov	r2, #0
	bne	.L79
	ldr	r0, .L107+4
	mov	r3, r2
.L82:
	uxth	r1, r2
	cmp	r1, #5
	bls	.L80
	tst	r2, #1
	ite	eq
	moveq	r1, #4
	movne	r1, #5
	subs	r1, r3, r1
	uxth	r1, r1
.L80:
	adds	r2, r2, #1
	strh	r1, [r3, r0]	@ movhi
	adds	r3, r3, #2
	cmp	r2, #256
	bne	.L82
	b	.L70
.L79:
	cmp	r0, #4
	bne	.L83
	ldr	r3, .L107+4
	movs	r1, #16
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #1
	strh	r0, [r3, #8]	@ movhi
	strh	r2, [r3, #2]	@ movhi
	movs	r2, #2
	strh	r2, [r3, #4]	@ movhi
	movs	r2, #3
	strh	r2, [r3, #6]	@ movhi
	movs	r2, #5
	strh	r2, [r3, #10]	@ movhi
	movs	r2, #7
	strh	r2, [r3, #12]	@ movhi
	movs	r2, #8
	strh	r2, [r3, #14]!	@ movhi
.L85:
	tst	r2, #1
	ite	eq
	moveq	r0, #6
	movne	r0, #7
	adds	r2, r2, #1
	subs	r0, r1, r0
	adds	r1, r1, #2
	cmp	r2, #256
	strh	r0, [r3, #2]!	@ movhi
	uxth	r1, r1
	bne	.L85
	b	.L70
.L83:
	cmp	r0, #5
	bne	.L86
	ldr	r1, .L107
	mov	r3, r2
.L87:
	strh	r3, [r1, #2]!	@ movhi
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #16
	bne	.L87
	ldr	r2, .L107+8
.L88:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L88
	b	.L70
.L86:
	cmp	r0, #6
	bne	.L70
	ldr	r0, .L107
	mov	r3, r2
.L91:
	uxth	r1, r3
	cmp	r1, #5
	bls	.L89
	tst	r3, #1
	ite	eq
	moveq	r1, #10
	movne	r1, #12
	subs	r1, r2, r1
	uxth	r1, r1
.L89:
	adds	r3, r3, #1
	adds	r2, r2, #3
	cmp	r3, #256
	strh	r1, [r0, #2]!	@ movhi
	uxth	r2, r2
	bne	.L91
.L70:
	mov	r2, #1024
	ldr	r0, .L107+12
	movs	r1, #255
	uxth	r4, r4
	bl	memset
	ldr	r2, .L107
	movs	r3, #0
	ldr	r0, .L107+12
	b	.L92
.L93:
	adds	r3, r3, #1
	ldrh	r1, [r2, #2]!
	uxth	r3, r3
	strh	r1, [r0, r1, lsl #1]	@ movhi
.L92:
	cmp	r3, r4
	bcc	.L93
	pop	{r4, pc}
.L108:
	.align	2
.L107:
	.word	.LANCHOR8-2
	.word	.LANCHOR8
	.word	.LANCHOR8+30
	.word	.LANCHOR9
	.size	BuildFlashLsbPageTable, .-BuildFlashLsbPageTable
	.section	.text.FlashPrintInfo,"ax",%progbits
	.align	1
	.global	FlashPrintInfo
	.thumb
	.thumb_func
	.type	FlashPrintInfo, %function
FlashPrintInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashPrintInfo, .-FlashPrintInfo
	.section	.text.ToshibaSetRRPara,"ax",%progbits
	.align	1
	.global	ToshibaSetRRPara
	.thumb
	.thumb_func
	.type	ToshibaSetRRPara, %function
ToshibaSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	add	r7, r1, r1, lsl #2
	ldr	r3, .L118
	mov	r4, r0
	mov	r6, r1
	movs	r5, #0
	add	sl, r3, r7
	b	.L111
.L115:
	ldr	r8, .L118+16
	movs	r3, #85
	str	r3, [r4, #8]
	movs	r0, #200
	ldrsb	r3, [r5, r8]
	str	r3, [r4, #4]
	bl	udelay
	ldr	r3, .L118+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L112
	add	r8, r8, r7
	add	r3, r8, r5
	b	.L117
.L112:
	cmp	r3, #35
	bne	.L114
	add	r3, sl, r5
.L117:
	ldrsb	r3, [r3, #5]
	b	.L116
.L114:
	ldr	r3, .L118+8
	ldrsb	r3, [r3, r6]
.L116:
	adds	r5, r5, #1
	str	r3, [r4, #0]
.L111:
	ldr	r3, .L118+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L115
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L119:
	.align	2
.L118:
	.word	.LANCHOR12
	.word	.LANCHOR11
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LANCHOR10
	.size	ToshibaSetRRPara, .-ToshibaSetRRPara
	.section	.text.SamsungSetRRPara,"ax",%progbits
	.align	1
	.global	SamsungSetRRPara
	.thumb
	.thumb_func
	.type	SamsungSetRRPara, %function
SamsungSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r6, .L123
	movs	r4, #0
	ldr	r7, .L123+4
	add	r8, r6, r1, lsl #2
	b	.L121
.L122:
	movs	r3, #161
	str	r3, [r5, #8]
	movs	r3, #0
	str	r3, [r5, #0]
	ldrsb	r3, [r4, r6]
	mov	r0, #300
	str	r3, [r5, #0]
	add	r3, r8, r4
	adds	r4, r4, #1
	ldrsb	r3, [r3, #4]
	str	r3, [r5, #0]
	bl	udelay
.L121:
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L122
	pop	{r4, r5, r6, r7, r8, pc}
.L124:
	.align	2
.L123:
	.word	.LANCHOR15
	.word	.LANCHOR14
	.size	SamsungSetRRPara, .-SamsungSetRRPara
	.section	.text.FlashDieInfoInit,"ax",%progbits
	.align	1
	.global	FlashDieInfoInit
	.thumb
	.thumb_func
	.type	FlashDieInfoInit, %function
FlashDieInfoInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L137
	movs	r3, #0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	strb	r3, [r2, #0]
	ldr	r2, .L137+4
	strb	r3, [r2, #0]
	ldr	r3, .L137+8
	ldrh	r2, [r3, #10]
	ldr	r3, .L137+12
	cmp	r2, #256
	str	r2, [r3, #0]
	bls	.L126
	mov	r2, #512
	b	.L136
.L126:
	cmp	r2, #128
	bls	.L127
	mov	r2, #256
.L136:
	str	r2, [r3, #0]
.L127:
	movs	r1, #0
	movs	r2, #8
	ldr	r0, .L137+16
	movs	r5, #0
	bl	memset
	movs	r1, #0
	movs	r2, #32
	ldr	r0, .L137+20
	bl	memset
	ldr	r6, .L137+24
	ldr	r0, .L137+28
	movs	r1, #0
	movs	r2, #128
	ldr	sl, .L137+36
	bl	memset
	ldr	r8, .L137
	ldr	r3, .L137+20
	mov	r7, r6
.L129:
	ldr	r4, [sl, #0]
	mov	r1, r7
	mov	r0, r4
	ldrb	fp, [r0], #1	@ zero_extendqisi2
	str	r3, [sp, #4]
	mov	r2, fp
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L128
	ldrb	r2, [r8, #0]	@ zero_extendqisi2
	ldr	r1, .L137+16
	str	r0, [r3, r2, lsl #2]
	strb	r5, [r1, r2]
	adds	r2, r2, #1
	strb	r2, [r8, #0]
.L128:
	adds	r5, r5, #1
	adds	r7, r7, #8
	cmp	r5, #4
	bne	.L129
	ldr	r2, .L137
	ldr	r3, .L137+4
	ldrb	r1, [r2, #0]	@ zero_extendqisi2
	strb	r1, [r3, #0]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #2
	bne	.L130
	ldr	r7, .L137+20
	movs	r5, #0
	ldr	r8, .L137+12
	adds	r3, r4, #1
	mov	sl, r2
.L133:
	mov	r0, r3
	mov	r1, r6
	mov	r2, fp
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L131
	ldrb	r2, [sl, #0]	@ zero_extendqisi2
	ldrb	r1, [r4, #13]	@ zero_extendqisi2
	ldr	r0, [r8, #0]
	muls	r0, r1, r0
	ldrh	r1, [r4, #14]
	and	r1, r1, #65280
	muls	r1, r0, r1
	str	r1, [r7, r2, lsl #2]
	ldrb	r0, [r4, #23]	@ zero_extendqisi2
	cbz	r0, .L132
	lsls	r1, r1, #1
	str	r1, [r7, r2, lsl #2]
.L132:
	ldr	r1, .L137+16
	strb	r5, [r1, r2]
	adds	r2, r2, #1
	ldr	r1, .L137
	strb	r2, [r1, #0]
.L131:
	adds	r5, r5, #1
	adds	r6, r6, #8
	cmp	r5, #4
	bne	.L133
.L130:
	ldr	r3, .L137
	ldrb	r2, [r4, #13]	@ zero_extendqisi2
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldrh	r3, [r4, #14]
	muls	r2, r3, r2
	ldr	r3, .L137+32
	strh	r2, [r3, #0]	@ movhi
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L138:
	.align	2
.L137:
	.word	.LANCHOR16
	.word	.LANCHOR17
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR19
	.word	.LANCHOR20
	.word	.LANCHOR22
	.word	.LANCHOR21
	.word	.LANCHOR24
	.word	.LANCHOR23
	.size	FlashDieInfoInit, .-FlashDieInfoInit
	.section	.text.FlashReadIdbData,"ax",%progbits
	.align	1
	.global	FlashReadIdbData
	.thumb
	.thumb_func
	.type	FlashReadIdbData, %function
FlashReadIdbData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r2, #2048
	ldr	r1, .L140
	bl	memcpy
	movs	r0, #0
	pop	{r3, pc}
.L141:
	.align	2
.L140:
	.word	.LANCHOR25
	.size	FlashReadIdbData, .-FlashReadIdbData
	.section	.text.FlashLoadPhyInfoInRam,"ax",%progbits
	.align	1
	.global	FlashLoadPhyInfoInRam
	.thumb
	.thumb_func
	.type	FlashLoadPhyInfoInRam, %function
FlashLoadPhyInfoInRam:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r5, #0
	ldr	r6, .L154
.L146:
	lsls	r3, r5, #5
	ldr	r1, .L154+4
	adds	r4, r6, r3
	adds	r0, r4, #1
	ldrb	r2, [r6, r3]	@ zero_extendqisi2
	bl	FlashMemCmp8
	cbnz	r0, .L143
	cbnz	r4, .L152
	b	.L153
.L143:
	adds	r5, r5, #1
	cmp	r5, #72
	bne	.L146
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L152:
	ldrb	r2, [r4, #22]	@ zero_extendqisi2
	mov	r1, r0
	ldr	r3, .L154+8
.L148:
	lsls	r0, r1, #5
	ldrb	r0, [r0, r3]	@ zero_extendqisi2
	cmp	r0, r2
	beq	.L147
	adds	r1, r1, #1
	cmp	r1, #4
	bne	.L148
.L147:
	ldr	r3, .L154+8
	movs	r2, #32
	ldr	r0, .L154+12
	add	r1, r3, r1, lsl #5
	bl	memcpy
	ldr	r0, .L154+16
	mov	r1, r4
	movs	r2, #32
	bl	memcpy
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L153:
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L155:
	.align	2
.L154:
	.word	.LANCHOR26
	.word	.LANCHOR22
	.word	.LANCHOR27
	.word	.LANCHOR6
	.word	.LANCHOR18
	.size	FlashLoadPhyInfoInRam, .-FlashLoadPhyInfoInRam
	.global	__aeabi_uidiv
	.section	.text.LogAddr2PhyAddr,"ax",%progbits
	.align	1
	.global	LogAddr2PhyAddr
	.thumb
	.thumb_func
	.type	LogAddr2PhyAddr, %function
LogAddr2PhyAddr:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	fp, r3
	ldr	r3, .L161
	mov	r5, r2
	mov	r4, r0
	mov	ip, r1
	ldrh	r2, [r3, #12]
	ldrh	r8, [r3, #14]
	ldr	r3, .L161+4
	mul	r8, r8, r2
	ldrh	r6, [r3, #0]
	ldr	r3, .L161+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	uxth	r8, r8
	cmp	r3, #1
	bne	.L157
	lsls	r6, r6, #1
	uxth	r6, r6
.L157:
	ldr	r7, [r4, #4]
	mov	r1, r8
	str	ip, [sp, #4]
	bic	r7, r7, #-2147483648
	ubfx	sl, r7, #10, #16
	mov	r0, sl
	lsls	r7, r7, #22
	bl	__aeabi_uidiv
	ldr	ip, [sp, #4]
	lsrs	r7, r7, #22
	cmp	ip, #1
	uxth	r0, r0
	mls	r8, r8, r0, sl
	uxth	r8, r8
	bne	.L158
	ldr	r3, .L161+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L158
	ldr	r3, .L161+16
	ldrh	r7, [r3, r7, lsl #1]
.L158:
	ldr	r3, .L161+20
	ldr	r3, [r3, r0, lsl #2]
	mla	r6, r6, r8, r3
	ldrb	r3, [sp, #40]	@ zero_extendqisi2
	cmp	r3, #1
	add	r7, r6, r7
	str	r7, [r5, #0]
	str	r0, [fp, #0]
	bls	.L160
	ldr	r0, [r4, #4]
	ldr	r3, [r4, #40]
	add	r0, r0, #1024
	subs	r3, r0, r3
	rsbs	r0, r3, #0
	adc	r0, r0, r3
	b	.L159
.L160:
	movs	r0, #0
.L159:
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L162:
	.align	2
.L161:
	.word	.LANCHOR28
	.word	.LANCHOR2
	.word	.LANCHOR0
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	.LANCHOR20
	.size	LogAddr2PhyAddr, .-LogAddr2PhyAddr
	.section	.text.FlashReadStatusEN,"ax",%progbits
	.align	1
	.global	FlashReadStatusEN
	.thumb
	.thumb_func
	.type	FlashReadStatusEN, %function
FlashReadStatusEN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L172
	push	{r4, r5, r6, lr}
	ldr	r5, [r3, r0, lsl #3]
	add	r0, r3, r0, lsl #3
	ldrb	r4, [r0, #4]	@ zero_extendqisi2
	ldr	r0, .L172+4
	adds	r4, r4, #8
	ldr	r0, [r0, #0]
	lsls	r4, r4, #8
	adds	r3, r5, r4
	ldrb	r0, [r0, #8]	@ zero_extendqisi2
	cmp	r0, #2
	bne	.L164
	ldr	r0, .L172+8
	cbnz	r2, .L165
	ldrb	r2, [r0, #13]	@ zero_extendqisi2
	b	.L171
.L165:
	ldrb	r2, [r0, #14]	@ zero_extendqisi2
.L171:
	str	r2, [r3, #8]
	ldrb	r0, [r0, #15]	@ zero_extendqisi2
	cbnz	r0, .L170
	b	.L168
.L169:
	lsls	r6, r2, #3
	adds	r2, r2, #1
	lsr	r6, r1, r6
	uxtb	r6, r6
	str	r6, [r3, #4]
	b	.L167
.L170:
	movs	r2, #0
.L167:
	cmp	r2, r0
	bcc	.L169
	b	.L168
.L164:
	movs	r2, #112
	str	r2, [r3, #8]
.L168:
	movs	r0, #80
	bl	udelay
	ldr	r0, [r5, r4]
	uxtb	r0, r0
	pop	{r4, r5, r6, pc}
.L173:
	.align	2
.L172:
	.word	.LANCHOR5
	.word	.LANCHOR23
	.word	.LANCHOR6
	.size	FlashReadStatusEN, .-FlashReadStatusEN
	.section	.text.FlashWaitReadyEN,"ax",%progbits
	.align	1
	.global	FlashWaitReadyEN
	.thumb
	.thumb_func
	.type	FlashWaitReadyEN, %function
FlashWaitReadyEN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r6, r0
	mov	r5, r1
	mov	r4, r2
.L178:
	mov	r0, r6
	mov	r1, r5
	mov	r2, r4
	bl	FlashReadStatusEN
	cmp	r0, #255
	beq	.L178
	lsls	r2, r0, #25
	bpl	.L178
	pop	{r4, r5, r6, pc}
	.size	FlashWaitReadyEN, .-FlashWaitReadyEN
	.section	.text.ReadFlashInfo,"ax",%progbits
	.align	1
	.global	ReadFlashInfo
	.thumb
	.thumb_func
	.type	ReadFlashInfo, %function
ReadFlashInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r1, #0
	movs	r2, #11
	mov	r4, r0
	bl	memset
	ldr	r3, .L182
	ldr	r1, .L182+4
	ldr	r3, [r3, #0]
	ldr	r1, [r1, #0]
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	muls	r2, r1, r2
	uxth	r2, r2
	strb	r2, [r4, #4]
	movs	r1, #0
	lsrs	r0, r2, #8
	strb	r0, [r4, #5]
	ldr	r0, .L182+8
	ldrb	r0, [r0, #0]	@ zero_extendqisi2
	strb	r0, [r4, #7]
	ldrb	r0, [r3, #13]	@ zero_extendqisi2
	muls	r2, r0, r2
	ldrh	r0, [r3, #14]
	muls	r2, r0, r2
	ldrb	r0, [r3, #8]	@ zero_extendqisi2
	muls	r2, r0, r2
	strb	r2, [r4, #0]
	ubfx	r0, r2, #8, #8
	strb	r0, [r4, #1]
	ubfx	r0, r2, #16, #8
	lsrs	r2, r2, #24
	strb	r0, [r4, #2]
	strb	r2, [r4, #3]
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	strb	r2, [r4, #6]
	movs	r2, #32
	strb	r2, [r4, #8]
	movs	r2, #1
	ldrb	r3, [r3, #7]	@ zero_extendqisi2
	strb	r1, [r4, #10]
	strb	r3, [r4, #9]
	ldr	r3, .L182+12
	ldrb	r0, [r3, #0]	@ zero_extendqisi2
	mov	r3, r1
	ldr	r1, .L182+16
	b	.L180
.L181:
	ldrb	r5, [r3, r1]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r5, r2, r5
	orrs	r5, r5, r6
	strb	r5, [r4, #10]
.L180:
	uxtb	r5, r3
	cmp	r5, r0
	bcc	.L181
	pop	{r4, r5, r6, pc}
.L183:
	.align	2
.L182:
	.word	.LANCHOR23
	.word	.LANCHOR2
	.word	.LANCHOR29
	.word	.LANCHOR16
	.word	.LANCHOR19
	.size	ReadFlashInfo, .-ReadFlashInfo
	.section	.text.NandcReadDontCaseBusyEn,"ax",%progbits
	.align	1
	.global	NandcReadDontCaseBusyEn
	.thumb
	.thumb_func
	.type	NandcReadDontCaseBusyEn, %function
NandcReadDontCaseBusyEn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandcReadDontCaseBusyEn, .-NandcReadDontCaseBusyEn
	.section	.text.NandcGetChipIf,"ax",%progbits
	.align	1
	.global	NandcGetChipIf
	.thumb
	.thumb_func
	.type	NandcGetChipIf, %function
NandcGetChipIf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L186
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r0, [r3, #4]	@ zero_extendqisi2
	adds	r0, r0, #8
	add	r0, r2, r0, lsl #8
	bx	lr
.L187:
	.align	2
.L186:
	.word	.LANCHOR5
	.size	NandcGetChipIf, .-NandcGetChipIf
	.section	.text.NandcSetDdrPara,"ax",%progbits
	.align	1
	.global	NandcSetDdrPara
	.thumb
	.thumb_func
	.type	NandcSetDdrPara, %function
NandcSetDdrPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L189
	lsls	r2, r0, #8
	orr	r2, r2, r0, lsl #16
	orr	r2, r2, #1
	ldr	r3, [r3, #0]
	str	r2, [r3, #304]
	bx	lr
.L190:
	.align	2
.L189:
	.word	.LANCHOR30
	.size	NandcSetDdrPara, .-NandcSetDdrPara
	.section	.text.NandcSetDdrDiv,"ax",%progbits
	.align	1
	.global	NandcSetDdrDiv
	.thumb
	.thumb_func
	.type	NandcSetDdrDiv, %function
NandcSetDdrDiv:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L192
	orr	r0, r0, #16640
	ldr	r3, [r3, #0]
	str	r0, [r3, #344]
	bx	lr
.L193:
	.align	2
.L192:
	.word	.LANCHOR30
	.size	NandcSetDdrDiv, .-NandcSetDdrDiv
	.section	.text.NandcSetDdrMode,"ax",%progbits
	.align	1
	.global	NandcSetDdrMode
	.thumb
	.thumb_func
	.type	NandcSetDdrMode, %function
NandcSetDdrMode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L196
	ldr	r2, [r3, #0]
	ldr	r3, [r2, #0]
	bfc	r3, #13, #1
	cbz	r0, .L195
	orr	r3, r3, #253952
.L195:
	str	r3, [r2, #0]
	bx	lr
.L197:
	.align	2
.L196:
	.word	.LANCHOR30
	.size	NandcSetDdrMode, .-NandcSetDdrMode
	.section	.text.NandcSetMode,"ax",%progbits
	.align	1
	.global	NandcSetMode
	.thumb
	.thumb_func
	.type	NandcSetMode, %function
NandcSetMode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L202
	ands	r1, r0, #6
	ldr	r2, [r3, #0]
	ldr	r3, [r2, #0]
	beq	.L199
	lsls	r1, r0, #29
	orr	r3, r3, #24576
	movw	r1, #16641
	str	r1, [r2, #344]
	ldr	r1, .L202+4
	bfc	r3, #15, #1
	orr	r3, r3, #196608
	it	mi
	orrmi	r3, r3, #32768
	str	r1, [r2, #304]
	movs	r1, #38
	str	r1, [r2, #308]
	movs	r1, #39
	str	r1, [r2, #308]
	b	.L201
.L199:
	bfi	r3, r1, #13, #1
.L201:
	str	r3, [r2, #0]
	movs	r0, #0
	bx	lr
.L203:
	.align	2
.L202:
	.word	.LANCHOR30
	.word	1710595
	.size	NandcSetMode, .-NandcSetMode
	.section	.text.NandcFlashCs,"ax",%progbits
	.align	1
	.global	NandcFlashCs
	.thumb
	.thumb_func
	.type	NandcFlashCs, %function
NandcFlashCs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L205
	ldr	r3, [r2, r0, lsl #3]
	add	r2, r2, r0, lsl #3
	movs	r0, #1
	ldrb	r1, [r2, #4]	@ zero_extendqisi2
	ldr	r2, [r3, #0]
	lsl	r1, r0, r1
	bfi	r2, r1, #0, #8
	str	r2, [r3, #0]
	bx	lr
.L206:
	.align	2
.L205:
	.word	.LANCHOR5
	.size	NandcFlashCs, .-NandcFlashCs
	.section	.text.NandcFlashDeCs,"ax",%progbits
	.align	1
	.global	NandcFlashDeCs
	.thumb
	.thumb_func
	.type	NandcFlashDeCs, %function
NandcFlashDeCs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L208
	ldr	r2, [r3, r0, lsl #3]
	ldr	r3, [r2, #0]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2, #0]
	bx	lr
.L209:
	.align	2
.L208:
	.word	.LANCHOR5
	.size	NandcFlashDeCs, .-NandcFlashDeCs
	.section	.text.FlashWaitCmdDone,"ax",%progbits
	.align	1
	.global	FlashWaitCmdDone
	.thumb
	.thumb_func
	.type	FlashWaitCmdDone, %function
FlashWaitCmdDone:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L213
	lsls	r3, r0, #4
	push	{r4, r5, r6, lr}
	adds	r4, r2, r3
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r6, r0
	ldr	r3, [r4, #8]
	cbz	r3, .L211
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r3, .L213+4
	ldr	r1, [r4, #4]
	mov	r0, r5
	ldr	r2, [r3, r6, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r6, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, [r4, #8]
	ldr	r2, [r4, #12]
	ands	r6, r6, #1
	it	ne
	movne	r6, #-1
	str	r6, [r3, #0]
	movs	r3, #0
	str	r3, [r4, #8]
	cbz	r2, .L211
	str	r6, [r2, #0]
	str	r3, [r4, #12]
.L211:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L214:
	.align	2
.L213:
	.word	.LANCHOR21
	.word	.LANCHOR20
	.size	FlashWaitCmdDone, .-FlashWaitCmdDone
	.section	.text.HynixSetRRPara,"ax",%progbits
	.align	1
	.global	HynixSetRRPara
	.thumb
	.thumb_func
	.type	HynixSetRRPara, %function
HynixSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r8, r3
	ldr	r3, .L221
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	sxth	fp, r0
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #6
	bne	.L216
	ldr	r3, .L221+4
	add	fp, r3, fp, lsl #6
	add	fp, fp, r8, lsl #2
	b	.L217
.L216:
	cmp	r3, #7
	bne	.L218
	lsl	r3, fp, #7
	add	fp, r3, fp, lsl #5
	ldr	r3, .L221+8
	add	fp, r3, fp
	sxth	r3, r8
	lsls	r2, r3, #3
	add	r3, r2, r3, lsl #1
	add	fp, fp, r3
	b	.L217
.L218:
	add	fp, r8, fp, lsl #3
	ldr	r3, .L221+4
	add	fp, r3, fp, lsl #3
.L217:
	ldr	r3, .L221+12
	mov	r0, r4
	movs	r7, #0
	ldr	r2, [r3, r4, lsl #3]
	add	r3, r3, r4, lsl #3
	ldrb	sl, [r3, #4]	@ zero_extendqisi2
	add	sl, sl, #8
	add	sl, r2, sl, lsl #8
	bl	NandcFlashCs
	movs	r3, #54
	str	r3, [sl, #8]
	b	.L219
.L220:
	ldrb	r3, [r6, r7]	@ zero_extendqisi2
	movs	r0, #200
	str	r3, [sl, #4]
	bl	udelay
	ldrsb	r3, [fp, r7]
	adds	r7, r7, #1
	str	r3, [sl, #0]
.L219:
	uxtb	r3, r7
	cmp	r3, r5
	bcc	.L220
	movs	r3, #22
	mov	r0, r4
	str	r3, [sl, #8]
	bl	NandcFlashDeCs
	ldr	r3, .L221+16
	strb	r8, [r3, r4]
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L222:
	.align	2
.L221:
	.word	.LANCHOR23
	.word	.LANCHOR31+20
	.word	.LANCHOR31+28
	.word	.LANCHOR5
	.word	.LANCHOR32
	.size	HynixSetRRPara, .-HynixSetRRPara
	.section	.text.FlashSetReadRetryDefault,"ax",%progbits
	.align	1
	.global	FlashSetReadRetryDefault
	.thumb
	.thumb_func
	.type	FlashSetReadRetryDefault, %function
FlashSetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L228
	push	{r4, r5, r6, lr}
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L223
	ldr	r6, .L228+4
	movs	r4, #0
	ldr	r5, .L228+8
.L226:
	ldrb	r3, [r6, r4, lsl #3]	@ zero_extendqisi2
	uxtb	r0, r4
	cmp	r3, #173
	bne	.L225
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	movs	r3, #0
	ldr	r2, .L228+12
	bl	HynixSetRRPara
.L225:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L226
.L223:
	pop	{r4, r5, r6, pc}
.L229:
	.align	2
.L228:
	.word	.LANCHOR23
	.word	.LANCHOR22
	.word	.LANCHOR31
	.word	.LANCHOR31+4
	.size	FlashSetReadRetryDefault, .-FlashSetReadRetryDefault
	.section	.text.NandcDelayns,"ax",%progbits
	.align	1
	.global	NandcDelayns
	.thumb
	.thumb_func
	.type	NandcDelayns, %function
NandcDelayns:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	udelay
	movs	r0, #0
	pop	{r3, pc}
	.size	NandcDelayns, .-NandcDelayns
	.section	.text.NandcWaitFlashReady,"ax",%progbits
	.align	1
	.global	NandcWaitFlashReady
	.thumb
	.thumb_func
	.type	NandcWaitFlashReady, %function
NandcWaitFlashReady:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L236
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r5, [r3, r0, lsl #3]
	ldr	r4, .L236+4
.L233:
	movs	r0, #100
	bl	udelay
	ldr	r3, [r5, #0]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r0, r3, #22
	bmi	.L234
	subs	r4, r4, #1
	bne	.L233
	mov	r0, #-1
	b	.L232
.L234:
	movs	r0, #0
.L232:
	pop	{r1, r2, r3, r4, r5, pc}
.L237:
	.align	2
.L236:
	.word	.LANCHOR5
	.word	100000
	.size	NandcWaitFlashReady, .-NandcWaitFlashReady
	.section	.text.FlashEraseSLc2KBlocks,"ax",%progbits
	.align	1
	.global	FlashEraseSLc2KBlocks
	.thumb
	.thumb_func
	.type	FlashEraseSLc2KBlocks, %function
FlashEraseSLc2KBlocks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r6, r1
	mov	r4, r0
	movs	r5, #0
	ldr	r7, .L246
	ldr	sl, .L246+12
	ldr	fp, .L246+16
	b	.L239
.L245:
	subs	r3, r6, r5
	movs	r1, #0
	add	r2, sp, #8
	mov	r0, r4
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #12
	bl	LogAddr2PhyAddr
	ldr	r3, [sp, #12]
	ldrb	r2, [r7, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bcc	.L240
	mov	r3, #-1
	str	r3, [r4, #0]
	b	.L241
.L240:
	ldrb	r8, [sl, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	mov	r0, r8
	strb	r8, [fp, r3]
	bl	NandcWaitFlashReady
	mov	r0, r8
	bl	NandcFlashCs
	movs	r2, #0
	ldr	r1, [sp, #8]
	mov	r0, r8
	bl	FlashEraseCmd
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #8]
	mov	r0, r8
	bl	FlashReadStatus
	ldr	r3, .L246+4
	ldr	r1, [r3, #0]
	ldr	r3, [sp, #8]
	adds	r1, r1, r3
	ands	r0, r0, #1
	it	ne
	movne	r0, #-1
	movs	r2, #0
	str	r0, [r4, #0]
	mov	r0, r8
	bl	FlashEraseCmd
	mov	r0, r8
	bl	NandcWaitFlashReady
	mov	r0, r8
	ldr	r1, [sp, #8]
	bl	FlashReadStatus
	lsls	r3, r0, #31
	itt	mi
	movmi	r3, #-1
	strmi	r3, [r4, #0]
	ldr	r3, [r4, #0]
	adds	r3, r3, #1
	bne	.L244
	ldr	r0, .L246+8
	ldr	r1, [sp, #8]
	bl	printf
.L244:
	mov	r0, r8
	bl	NandcFlashDeCs
.L241:
	adds	r5, r5, #1
	adds	r4, r4, #36
.L239:
	cmp	r5, r6
	bne	.L245
	movs	r0, #0
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L247:
	.align	2
.L246:
	.word	.LANCHOR16
	.word	.LANCHOR2
	.word	.LC1
	.word	.LANCHOR19
	.word	.LANCHOR21
	.size	FlashEraseSLc2KBlocks, .-FlashEraseSLc2KBlocks
	.section	.text.FlashEraseBlocks,"ax",%progbits
	.align	1
	.global	FlashEraseBlocks
	.thumb
	.thumb_func
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L264
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	ldrb	r4, [r3, #0]	@ zero_extendqisi2
	mov	r5, r0
	str	r1, [sp, #12]
	mov	r6, r2
	cmp	r4, #0
	beq	.L262
	mov	r1, r2
	bl	FlashEraseSLc2KBlocks
	b	.L250
.L258:
	rsb	r3, r4, r8
	movs	r6, #36
	muls	r6, r4, r6
	add	fp, r5, r6
	movs	r1, #0
	uxtb	r3, r3
	mov	r0, fp
	str	r3, [sp, #0]
	add	r2, sp, #16
	add	r3, sp, #20
	bl	LogAddr2PhyAddr
	ldr	r1, .L264+4
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	mov	r7, r0
	ldr	r0, [sp, #20]
	cmp	r0, r3
	bcc	.L251
	mov	r3, #-1
	str	r3, [r5, r6]
	b	.L252
.L251:
	ldr	r3, .L264+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r7, #0
	add	r3, sl, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L254
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L254:
	ldr	r2, [sp, #20]
	ldr	r1, .L264+12
	add	r3, r1, r2, lsl #4
	movs	r1, #0
	str	r1, [r3, #12]
	ldr	r1, [sp, #16]
	str	fp, [r3, #8]
	str	r1, [r3, #4]
	cbz	r7, .L255
	adds	r1, r4, #1
	movs	r0, #36
	mla	r1, r0, r1, r5
	str	r1, [r3, #12]
.L255:
	ldr	r3, .L264+16
	ldrb	r6, [r3, r2]	@ zero_extendqisi2
	lsls	r2, r2, #4
	mov	r0, r6
	strb	r6, [sl, r2]
	bl	NandcFlashCs
	ldr	r2, [sp, #12]
	mov	r0, r6
	cmp	r2, #1
	bne	.L256
	ldr	r3, .L264+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L256
	bl	flash_enter_slc_mode
	b	.L257
.L256:
	bl	flash_exit_slc_mode
.L257:
	ldr	r3, .L264+24
	mov	r0, r6
	ldr	r2, [sp, #20]
	adds	r4, r4, r7
	ldr	r1, [sp, #16]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r6
	ldr	r1, [sp, #16]
	mov	r2, r7
	bl	FlashEraseCmd
	mov	r0, r6
	bl	NandcFlashDeCs
.L252:
	adds	r4, r4, #1
	b	.L249
.L262:
	ldr	sl, .L264+12
	mov	r8, r2
.L249:
	cmp	r4, r8
	bcc	.L258
	movs	r4, #0
	ldr	r7, .L264+4
	ldr	r6, .L264+20
	ldr	r5, .L264+12
	b	.L259
.L261:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L260
	ldrb	r3, [r6, #0]	@ zero_extendqisi2
	cbz	r3, .L260
	lsls	r3, r4, #4
	ldrb	r0, [r5, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L260:
	adds	r4, r4, #1
.L259:
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L261
	movs	r0, #0
.L250:
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L265:
	.align	2
.L264:
	.word	.LANCHOR0
	.word	.LANCHOR16
	.word	.LANCHOR33
	.word	.LANCHOR21
	.word	.LANCHOR19
	.word	.LANCHOR7
	.word	.LANCHOR20
	.size	FlashEraseBlocks, .-FlashEraseBlocks
	.section	.text.SandiskSetRRPara,"ax",%progbits
	.align	1
	.global	SandiskSetRRPara
	.thumb
	.thumb_func
	.type	SandiskSetRRPara, %function
SandiskSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r3, #239
	mov	r4, r0
	str	r3, [r0, #8]
	movs	r3, #17
	str	r3, [r0, #4]
	movs	r0, #200
	mov	r5, r1
	bl	udelay
	ldr	r3, .L272
	ldr	r1, .L272+4
	add	r5, r5, r5, lsl #2
	ldr	r2, .L272+8
	ldrb	r6, [r3, #0]	@ zero_extendqisi2
	adds	r1, r1, r5
	ldr	r3, .L272+12
	adds	r5, r2, r5
	ldrb	r0, [r3, #0]	@ zero_extendqisi2
	movs	r3, #0
	b	.L267
.L270:
	cmp	r0, #67
	ite	eq
	addeq	r2, r5, r3
	addne	r2, r1, r3
	adds	r3, r3, #1
	ldrsb	r2, [r2, #5]
	str	r2, [r4, #0]
.L267:
	cmp	r3, r6
	bcc	.L270
	movs	r0, #0
	pop	{r4, r5, r6, lr}
	b	NandcWaitFlashReady
.L273:
	.align	2
.L272:
	.word	.LANCHOR14
	.word	.LANCHOR12
	.word	.LANCHOR10
	.word	.LANCHOR11
	.size	SandiskSetRRPara, .-SandiskSetRRPara
	.section	.text.FlashEraseBlock,"ax",%progbits
	.align	1
	.global	FlashEraseBlock
	.thumb
	.thumb_func
	.type	FlashEraseBlock, %function
FlashEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	bl	FlashEraseCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatus
	mov	r5, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	and	r0, r5, #1
	pop	{r4, r5, r6, pc}
	.size	FlashEraseBlock, .-FlashEraseBlock
	.section	.text.FlashReset,"ax",%progbits
	.align	1
	.global	FlashReset
	.thumb
	.thumb_func
	.type	FlashReset, %function
FlashReset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L276
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	adds	r5, r5, #8
	add	r5, r2, r5, lsl #8
	bl	NandcFlashCs
	movs	r3, #255
	mov	r0, r4
	str	r3, [r5, #8]
	bl	NandcWaitFlashReady
	mov	r0, r4
	pop	{r3, r4, r5, lr}
	b	NandcFlashDeCs
.L277:
	.align	2
.L276:
	.word	.LANCHOR5
	.size	FlashReset, .-FlashReset
	.section	.text.FlashSetInterfaceMode,"ax",%progbits
	.align	1
	.global	FlashSetInterfaceMode
	.thumb
	.thumb_func
	.type	FlashSetInterfaceMode, %function
FlashSetInterfaceMode:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L292
	mov	ip, #239
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r6, #0
	ldr	r8, .L292+8
	mov	r1, r6
	ldrb	sl, [r3, #0]	@ zero_extendqisi2
	mov	lr, #128
	and	fp, sl, #1
	and	sl, sl, #4
	str	sl, [sp, #4]
.L288:
	add	r3, r8, r6
	ldr	r7, .L292+4
	ldr	r2, [r6, r8]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	ldrb	r5, [r6, r7]	@ zero_extendqisi2
	adds	r3, r3, #8
	lsls	r3, r3, #8
	cmp	r5, #152
	add	r4, r2, r3
	beq	.L279
	cmp	r5, #69
	beq	.L279
	cmp	r5, #173
	beq	.L279
	cmp	r5, #44
	bne	.L280
.L279:
	cmp	r0, #1
	bne	.L281
	cmp	fp, #0
	beq	.L280
	cmp	r5, #173
	str	ip, [r4, #8]
	bne	.L282
	str	r0, [r4, #4]
	b	.L291
.L282:
	cmp	r5, #44
	bne	.L284
	str	r0, [r4, #4]
	movs	r4, #5
	str	r4, [r2, r3]
	b	.L286
.L284:
	str	lr, [r4, #4]
	str	r0, [r2, r3]
	b	.L286
.L281:
	ldr	r7, [sp, #4]
	cbz	r7, .L280
	cmp	r5, #173
	str	ip, [r4, #8]
	bne	.L285
	movs	r5, #1
	movs	r7, #32
	str	r5, [r4, #4]
	b	.L290
.L285:
	cmp	r5, #44
	bne	.L287
	movs	r7, #35
	movs	r5, #1
	str	r5, [r4, #4]
.L290:
	str	r7, [r2, r3]
	b	.L286
.L287:
	str	lr, [r4, #4]
.L291:
	str	r1, [r2, r3]
.L286:
	str	r1, [r2, r3]
	str	r1, [r2, r3]
	str	r1, [r2, r3]
.L280:
	adds	r6, r6, #8
	cmp	r6, #32
	bne	.L288
	movs	r0, #0
	bl	NandcWaitFlashReady
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L293:
	.align	2
.L292:
	.word	.LANCHOR34
	.word	.LANCHOR22
	.word	.LANCHOR5
	.size	FlashSetInterfaceMode, .-FlashSetInterfaceMode
	.section	.text.FlashReadDpCmd,"ax",%progbits
	.align	1
	.global	FlashReadDpCmd
	.thumb
	.thumb_func
	.type	FlashReadDpCmd, %function
FlashReadDpCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L298
	push	{r4, r5, r6, r7, r8, lr}
	mov	r7, r2
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	mov	r4, r0
	mov	r5, r1
	ldrb	r6, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L298+4
	adds	r6, r6, #8
	add	r6, r2, r6, lsl #8
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	cmp	r2, #1
	ldrb	r2, [r3, #8]	@ zero_extendqisi2
	str	r2, [r6, #8]
	bne	.L295
	mov	r8, #0
	uxtb	r2, r1
	str	r8, [r6, #4]
	str	r8, [r6, #4]
	str	r2, [r6, #4]
	lsrs	r2, r1, #8
	str	r2, [r6, #4]
	lsrs	r2, r1, #16
	str	r2, [r6, #4]
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [r6, #8]
	bl	NandcWaitFlashReady
	str	r8, [r6, #8]
	str	r8, [r6, #4]
	str	r8, [r6, #4]
	b	.L297
.L295:
	uxtb	r2, r1
	str	r2, [r6, #4]
	lsrs	r2, r1, #8
	str	r2, [r6, #4]
	lsrs	r2, r1, #16
	str	r2, [r6, #4]
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [r6, #8]
.L297:
	uxtb	r3, r7
	mov	r0, r4
	str	r3, [r6, #4]
	mov	r1, r5
	lsrs	r3, r7, #8
	lsrs	r7, r7, #16
	str	r3, [r6, #4]
	movs	r3, #48
	str	r7, [r6, #4]
	str	r3, [r6, #8]
	pop	{r4, r5, r6, r7, r8, lr}
	b	FlashSetRandomizer
.L299:
	.align	2
.L298:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	FlashReadDpCmd, .-FlashReadDpCmd
	.section	.text.FlashDeInit,"ax",%progbits
	.align	1
	.global	FlashDeInit
	.thumb
	.thumb_func
	.type	FlashDeInit, %function
FlashDeInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	movs	r0, #0
	ldr	r4, .L302
	bl	NandcWaitFlashReady
	bl	FlashSetReadRetryDefault
	ldrb	r3, [r4, #0]	@ zero_extendqisi2
	cbz	r3, .L301
	ldr	r3, .L302+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	lsls	r2, r3, #31
	bpl	.L301
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
	strb	r3, [r4, #0]
.L301:
	ldr	r3, .L302+8
	movs	r0, #0
	ldr	r3, [r3, #0]
	str	r0, [r3, #336]
	pop	{r4, pc}
.L303:
	.align	2
.L302:
	.word	.LANCHOR35
	.word	.LANCHOR34
	.word	.LANCHOR5
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.NandcRandmzSel,"ax",%progbits
	.align	1
	.global	NandcRandmzSel
	.thumb
	.thumb_func
	.type	NandcRandmzSel, %function
NandcRandmzSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L305
	ldr	r3, [r3, r0, lsl #3]
	str	r1, [r3, #336]
	bx	lr
.L306:
	.align	2
.L305:
	.word	.LANCHOR5
	.size	NandcRandmzSel, .-NandcRandmzSel
	.section	.text.NandcTimeCfg,"ax",%progbits
	.align	1
	.global	NandcTimeCfg
	.thumb
	.thumb_func
	.type	NandcTimeCfg, %function
NandcTimeCfg:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L312
	cmp	r0, #35
	ldr	r3, [r3, #0]
	bhi	.L308
	movw	r2, #4193
	b	.L311
.L308:
	cmp	r0, #99
	ite	hi
	movwhi	r2, #8322
	movwls	r2, #4225
.L311:
	str	r2, [r3, #4]
	bx	lr
.L313:
	.align	2
.L312:
	.word	.LANCHOR30
	.size	NandcTimeCfg, .-NandcTimeCfg
	.section	.text.FlashTimingCfg,"ax",%progbits
	.align	1
	.global	FlashTimingCfg
	.thumb
	.thumb_func
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L315
	ldrb	r0, [r3, #21]	@ zero_extendqisi2
	b	NandcTimeCfg
.L316:
	.align	2
.L315:
	.word	.LANCHOR18
	.size	FlashTimingCfg, .-FlashTimingCfg
	.section	.text.NandcBchSel,"ax",%progbits
	.align	1
	.global	NandcBchSel
	.thumb
	.thumb_func
	.type	NandcBchSel, %function
NandcBchSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L322
	movs	r1, #16
	ldr	r2, [r3, #0]
	movs	r3, #1
	str	r3, [r2, #8]
	ldr	r3, .L322+4
	str	r0, [r3, #0]
	movs	r3, #0
	cmp	r0, r1
	bfi	r3, r1, #8, #8
	bfc	r3, #18, #1
	beq	.L321
.L318:
	cmp	r0, #24
	bne	.L320
	orr	r3, r3, #16
	b	.L319
.L320:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L319
.L321:
	bfc	r3, #4, #1
.L319:
	orr	r3, r3, #1
	str	r3, [r2, #12]
	bx	lr
.L323:
	.align	2
.L322:
	.word	.LANCHOR30
	.word	.LANCHOR36
	.size	NandcBchSel, .-NandcBchSel
	.section	.text.FlashBchSel,"ax",%progbits
	.align	1
	.global	FlashBchSel
	.thumb
	.thumb_func
	.type	FlashBchSel, %function
FlashBchSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L325
	strb	r0, [r3, #0]
	b	NandcBchSel
.L326:
	.align	2
.L325:
	.word	.LANCHOR29
	.size	FlashBchSel, .-FlashBchSel
	.section	.text.NandCIrqEnable,"ax",%progbits
	.align	1
	.global	NandCIrqEnable
	.thumb
	.thumb_func
	.type	NandCIrqEnable, %function
NandCIrqEnable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandCIrqEnable, .-NandCIrqEnable
	.section	.text.NandCIrqDisable,"ax",%progbits
	.align	1
	.global	NandCIrqDisable
	.thumb
	.thumb_func
	.type	NandCIrqDisable, %function
NandCIrqDisable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandCIrqDisable, .-NandCIrqDisable
	.section	.text.rk_nandc_get_irq_status,"ax",%progbits
	.align	1
	.global	rk_nandc_get_irq_status
	.thumb
	.thumb_func
	.type	rk_nandc_get_irq_status, %function
rk_nandc_get_irq_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, [r0, #372]
	bx	lr
	.size	rk_nandc_get_irq_status, .-rk_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_ready
	.thumb
	.thumb_func
	.type	rk_nandc_flash_ready, %function
rk_nandc_flash_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_ready, .-rk_nandc_flash_ready
	.section	.text.NandcIqrWaitFlashReady,"ax",%progbits
	.align	1
	.global	NandcIqrWaitFlashReady
	.thumb
	.thumb_func
	.type	NandcIqrWaitFlashReady, %function
NandcIqrWaitFlashReady:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandcIqrWaitFlashReady, .-NandcIqrWaitFlashReady
	.section	.text.rk_nandc_flash_xfer_completed,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_xfer_completed
	.thumb
	.thumb_func
	.type	rk_nandc_flash_xfer_completed, %function
rk_nandc_flash_xfer_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_xfer_completed, .-rk_nandc_flash_xfer_completed
	.section	.text.NandcSendDumpDataStart,"ax",%progbits
	.align	1
	.global	NandcSendDumpDataStart
	.thumb
	.thumb_func
	.type	NandcSendDumpDataStart, %function
NandcSendDumpDataStart:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, [r0, #16]
	sub	sp, sp, #8
	ldr	r3, .L334
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	bfc	r2, #2, #1
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	str	r2, [r0, #16]
	str	r3, [r0, #8]
	orr	r3, r3, #4
	str	r3, [r0, #8]
	add	sp, sp, #8
	bx	lr
.L335:
	.align	2
.L334:
	.word	538969130
	.size	NandcSendDumpDataStart, .-NandcSendDumpDataStart
	.section	.text.NandcSendDumpDataDone,"ax",%progbits
	.align	1
	.global	NandcSendDumpDataDone
	.thumb
	.thumb_func
	.type	NandcSendDumpDataDone, %function
NandcSendDumpDataDone:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	sp, sp, #8
.L337:
	ldr	r3, [r0, #8]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #11
	bpl	.L337
	add	sp, sp, #8
	bx	lr
	.size	NandcSendDumpDataDone, .-NandcSendDumpDataDone
	.section	.text.NandcXferStart,"ax",%progbits
	.align	1
	.global	NandcXferStart
	.thumb
	.thumb_func
	.type	NandcXferStart, %function
NandcXferStart:
	@ args = 8, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	mov	r4, r1
	ldr	r1, [sp, #60]
	ldr	r8, [sp, #56]
	cbnz	r1, .L351
	adds	r1, r8, #0
	it	ne
	movne	r1, #1
	b	.L340
.L351:
	movs	r1, #1
.L340:
	ldr	r5, .L354
	mov	ip, #16
	ldr	r6, [r5, r0, lsl #3]
	add	r0, r5, r0, lsl #3
	movs	r5, #0
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	ldr	r7, [r6, #12]
	bfi	r7, ip, #8, #8
	bfi	r7, r5, #3, #1
	bfi	r5, r4, #1, #1
	bfi	r7, r0, #5, #3
	orr	r5, r5, #8
	movs	r0, #1
	bfi	r5, r0, #5, #2
	lsr	r3, r3, r0
	orr	r5, r5, #536870912
	orr	r5, r5, #1024
	bfi	r5, r3, #4, #1
	ldr	r3, .L354+4
	ldr	r3, [r3, #0]
	cmp	r3, #3
	bls	.L341
	ldr	r3, [r6, #16]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfc	r3, #2, #1
	str	r3, [sp, #20]
	cmp	r1, #0
	beq	.L342
	cbz	r4, .L343
	ldr	r3, .L354+8
	str	r2, [sp, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #24
	ite	hi
	movhi	r3, #128
	movls	r3, #64
	str	r3, [sp, #8]
	lsr	r3, r2, r0
	str	r3, [sp, #12]
	ldr	r3, .L354+12
	ldr	r0, [sp, #60]
	ldr	lr, [r3, #4]
	movs	r3, #0
	mov	r1, r3
	b	.L345
.L348:
	ldr	r2, [sp, #60]
	lsr	ip, r3, #2
	cbz	r2, .L346
	ldrh	fp, [r0, #2]
	ldrh	sl, [r0], #4
	orr	sl, sl, fp, lsl #16
	str	sl, [lr, ip, lsl #2]
	b	.L347
.L346:
	mov	r2, #-1
	str	r2, [lr, ip, lsl #2]
.L347:
	ldr	r2, [sp, #8]
	adds	r1, r1, #1
	adds	r3, r3, r2
.L345:
	ldr	r2, [sp, #12]
	cmp	r1, r2
	bcc	.L348
	ldr	r2, [sp, #4]
.L343:
	adds	r2, r2, #1
	ldr	sl, .L354+12
	asrs	r2, r2, #1
	bfi	r5, r2, #22, #6
	cmp	r8, #0
	bne	.L353
	ldr	r0, [sl, #0]
	b	.L349
.L353:
	mov	r0, r8
.L349:
	ldr	r3, [sl, #4]
	ubfx	fp, r5, #22, #5
	str	r0, [sl, #8]
	add	r1, r0, fp, lsl #10
	str	r0, [sl, #16]
	str	r3, [sl, #12]
	str	r3, [sl, #20]
	bl	flush_dcache_range
	ldr	r0, [sl, #12]
	add	r1, r0, fp, lsl #7
	bl	flush_dcache_range
	movs	r3, #1
	str	r3, [sl, #24]
	movs	r2, #16
	ldr	r3, [sl, #16]
	str	r3, [r6, #20]
	ldr	r3, [sl, #20]
	str	r3, [r6, #24]
	movs	r3, #0
	str	r3, [sp, #20]
	tst	r8, #3
	ldr	r3, [sp, #20]
	bfi	r3, r2, #9, #5
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	orr	r3, r3, #448
	str	r3, [sp, #20]
	bne	.L350
	ldr	r3, [sp, #20]
	movs	r2, #2
	bfi	r3, r2, #3, #3
	str	r3, [sp, #20]
.L350:
	ldr	r3, [sp, #20]
	rsbs	r4, r4, #1
	it	cc
	movcc	r4, #0
	orr	r3, r3, #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfi	r3, r4, #1, #1
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	orr	r3, r3, #1
	str	r3, [sp, #20]
.L342:
	ldr	r3, [sp, #20]
	str	r3, [r6, #16]
.L341:
	str	r7, [r6, #12]
	str	r5, [r6, #8]
	orr	r5, r5, #4
	str	r5, [r6, #8]
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L355:
	.align	2
.L354:
	.word	.LANCHOR5
	.word	.LANCHOR37
	.word	.LANCHOR36
	.word	.LANCHOR38
	.size	NandcXferStart, .-NandcXferStart
	.section	.text.NandcXferComp,"ax",%progbits
	.align	1
	.global	NandcXferComp
	.thumb
	.thumb_func
	.type	NandcXferComp, %function
NandcXferComp:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L373
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, [r3, r0, lsl #3]
	ldr	r3, .L373+4
	ldr	r3, [r3, #0]
	cmp	r3, #3
	bls	.L369
	ldr	r2, [r4, #16]
	lsls	r2, r2, #29
	bpl	.L369
	ldr	r2, [r4, #16]
	lsls	r0, r2, #30
	bpl	.L365
	ldr	r2, [r4, #8]
	str	r2, [sp, #0]
	b	.L372
.L362:
	cmp	r3, #5
	bls	.L372
	ldr	r2, [r4, #0]
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	lsls	r1, r2, #18
	bpl	.L372
	ldr	r2, [sp, #4]
	lsls	r2, r2, #14
	bmi	.L361
.L372:
	ldr	r1, [r4, #28]
	ldr	r2, [sp, #0]
	ubfx	r1, r1, #16, #5
	ubfx	r2, r2, #22, #6
	cmp	r1, r2
	blt	.L362
.L361:
	ldr	r4, .L373+8
	ldr	r3, [r4, #24]
	cbz	r3, .L363
	ldr	r1, [sp, #0]
	ldr	r0, [r4, #16]
	ubfx	r1, r1, #22, #5
	add	r1, r0, r1, lsl #10
	bl	invalidate_dcache_range
	ldr	r1, [sp, #0]
	ldr	r0, [r4, #20]
	ubfx	r1, r1, #22, #5
	add	r1, r0, r1, lsl #7
	bl	invalidate_dcache_range
	b	.L363
.L365:
	ldr	r3, [r4, #8]
	str	r3, [sp, #0]
	ldr	r3, [sp, #0]
	lsls	r5, r3, #11
	bpl	.L365
	ldr	r5, .L373+12
	ldr	r3, [r5, #0]
	cbz	r3, .L366
	mov	r0, r4
	bl	NandcSendDumpDataStart
.L366:
	ldr	r3, [r5, #0]
	cbz	r3, .L363
	mov	r0, r4
	bl	NandcSendDumpDataDone
.L363:
	ldr	r3, .L373+8
	movs	r2, #0
	str	r2, [r3, #24]
	b	.L356
.L369:
	ldr	r3, [r4, #8]
	str	r3, [sp, #0]
	ldr	r3, [sp, #0]
	lsls	r0, r3, #11
	bpl	.L369
.L356:
	pop	{r1, r2, r3, r4, r5, pc}
.L374:
	.align	2
.L373:
	.word	.LANCHOR5
	.word	.LANCHOR37
	.word	.LANCHOR38
	.word	.LANCHOR39
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.NandcCopy1KB,"ax",%progbits
	.align	1
	.global	NandcCopy1KB
	.thumb
	.thumb_func
	.type	NandcCopy1KB, %function
NandcCopy1KB:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	cmp	r1, #1
	mov	r4, r2
	add	r2, r0, #4096
	ldr	r5, [sp, #16]
	add	r6, r0, #512
	add	r2, r2, r4, lsl #9
	bne	.L376
	cbz	r3, .L377
	mov	r0, r2
	mov	r1, r3
	mov	r2, #1024
	bl	memcpy
.L377:
	cbz	r5, .L375
	lsrs	r4, r4, #1
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	lsls	r3, r4, #4
	lsls	r4, r4, #6
	subs	r4, r4, r3
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	lsls	r3, r3, #16
	orr	r3, r3, r2, lsl #8
	ldrb	r2, [r5, #0]	@ zero_extendqisi2
	orrs	r3, r3, r2
	ldrb	r2, [r5, #3]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #24
	str	r3, [r6, r4]
	pop	{r4, r5, r6, pc}
.L376:
	cbz	r3, .L379
	mov	r1, r2
	mov	r0, r3
	mov	r2, #1024
	bl	memcpy
.L379:
	cbz	r5, .L375
	lsrs	r4, r4, #1
	lsls	r3, r4, #4
	lsls	r4, r4, #6
	subs	r4, r4, r3
	ldr	r3, [r6, r4]
	lsrs	r2, r3, #8
	strb	r3, [r5, #0]
	strb	r2, [r5, #1]
	lsrs	r2, r3, #16
	lsrs	r3, r3, #24
	strb	r2, [r5, #2]
	strb	r3, [r5, #3]
.L375:
	pop	{r4, r5, r6, pc}
	.size	NandcCopy1KB, .-NandcCopy1KB
	.section	.text.NandcXferData,"ax",%progbits
	.align	1
	.global	NandcXferData
	.thumb
	.thumb_func
	.type	NandcXferData, %function
NandcXferData:
	@ args = 4, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #88
	mov	r4, r3
	mov	fp, r3
	ldr	r3, .L418
	mov	r6, r0
	str	r1, [sp, #12]
	lsls	r1, r4, #26
	mov	sl, r2
	ldr	r5, [sp, #120]
	ldr	r8, [r3, r0, lsl #3]
	bne	.L381
	cbnz	r5, .L382
	add	r0, sp, #20
	movs	r1, #255
	movs	r2, #64
	add	r5, sp, #20
	bl	memset
.L382:
	movs	r3, #0
	mov	r0, r6
	ldr	r1, [sp, #12]
	mov	r2, sl
	stmia	sp, {r4, r5}
	bl	NandcXferStart
	mov	r0, r6
	bl	NandcXferComp
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L405
	ldr	r3, .L418+4
	lsr	r0, sl, #1
	ldr	r1, .L418+8
	ldr	r4, [r3, #0]
	ldr	r3, [sp, #12]
	cmp	r4, #24
	ite	hi
	movhi	r4, #128
	movls	r4, #64
	mov	r2, r3
	b	.L385
.L386:
	ldr	r7, [r1, #4]
	lsrs	r3, r3, #2
	adds	r2, r2, #1
	ldr	r3, [r7, r3, lsl #2]
	lsrs	r7, r3, #8
	strb	r3, [r5, #0]
	strb	r7, [r5, #1]
	lsrs	r7, r3, #16
	lsrs	r3, r3, #24
	strb	r7, [r5, #2]
	strb	r3, [r5, #3]
	adds	r5, r5, #4
	mov	r3, r6
.L385:
	cmp	r2, r0
	add	r6, r3, r4
	bcc	.L386
	ldr	r3, .L418+4
	lsr	sl, sl, #2
	ldr	r0, [r3, #0]
	ldr	r3, .L418+12
	ldr	r1, [r3, #0]
	movs	r3, #0
	mov	r4, r3
	b	.L387
.L393:
	add	r2, r3, #8
	ldr	r2, [r8, r2, lsl #2]
	str	r2, [sp, #84]
	ldr	r2, [sp, #84]
	lsls	r2, r2, #29
	bmi	.L408
	ldr	r2, [sp, #84]
	ands	r2, r2, #32768
	bne	.L408
	cmp	r1, #5
	bls	.L389
	ldr	r7, [sp, #84]
	ldr	r5, [sp, #84]
	ldr	r6, [sp, #84]
	ubfx	r7, r7, #3, #5
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #27, #1
	ubfx	r6, r6, #16, #5
	ubfx	r2, r2, #29, #1
	orr	r5, r7, r5, lsl #5
	orr	r2, r6, r2, lsl #5
	cmp	r5, r2
	ldr	r5, [sp, #84]
	bls	.L390
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #3, #5
	ubfx	r2, r2, #27, #1
	b	.L417
.L390:
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #16, #5
	ubfx	r2, r2, #29, #1
	b	.L417
.L389:
	cmp	r1, #3
	bls	.L391
	ldr	r7, [sp, #84]
	ldr	r5, [sp, #84]
	ldr	r6, [sp, #84]
	ubfx	r7, r7, #3, #5
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #28, #1
	ubfx	r6, r6, #16, #5
	ubfx	r2, r2, #30, #1
	orr	r5, r7, r5, lsl #5
	orr	r2, r6, r2, lsl #5
	cmp	r5, r2
	ldr	r5, [sp, #84]
	bls	.L392
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #3, #5
	ubfx	r2, r2, #28, #1
	b	.L417
.L392:
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #16, #5
	ubfx	r2, r2, #30, #1
.L417:
	orr	r2, r5, r2, lsl #5
.L391:
	cmp	r4, r2
	it	cc
	movcc	r4, r2
	b	.L388
.L408:
	mov	r4, #-1
.L388:
	adds	r3, r3, #1
.L387:
	cmp	r3, sl
	bcs	.L383
	cmp	r0, #0
	bne	.L393
	b	.L383
.L405:
	movs	r4, #0
.L383:
	movs	r3, #0
	str	r3, [r8, #16]
	b	.L394
.L381:
	ldr	r3, [sp, #12]
	mov	r7, #0
	cmp	r3, #1
	bne	.L415
	b	.L395
.L398:
	cmp	r5, #0
	ite	ne
	movne	r3, #2
	moveq	r3, #0
	and	r4, r7, #3
	mov	r0, r8
	movs	r1, #1
	mla	r3, r7, r3, r5
	mov	r2, r4
	adds	r7, r7, #2
	str	r3, [sp, #0]
	mov	r3, fp
	bl	NandcCopy1KB
	movs	r3, #0
	mov	r0, r6
	str	r3, [sp, #0]
	str	r3, [sp, #4]
	movs	r1, #1
	movs	r2, #2
	mov	r3, r4
	bl	NandcXferStart
	mov	r0, r6
	bl	NandcXferComp
	add	fp, fp, #1024
.L395:
	cmp	r7, sl
	bcc	.L398
	movs	r4, #0
	b	.L394
.L415:
	mov	r1, r7
	movs	r2, #2
	mov	r3, r7
	str	r7, [sp, #0]
	str	r7, [sp, #4]
	mov	r4, r7
	bl	NandcXferStart
	b	.L399
.L403:
	mov	r0, r6
	bl	NandcXferComp
	ldr	r3, [r8, #32]
	add	ip, r7, #2
	cmp	ip, sl
	str	r3, [sp, #84]
	bcs	.L400
	movs	r3, #0
	mov	r0, r6
	str	r3, [sp, #0]
	mov	r1, r3
	str	r3, [sp, #4]
	movs	r2, #2
	and	r3, ip, #3
	str	ip, [sp, #8]
	bl	NandcXferStart
	ldr	ip, [sp, #8]
.L400:
	ldr	r3, [sp, #84]
	lsls	r1, r3, #29
	bmi	.L412
	ldr	r2, [sp, #84]
	ldr	r3, [sp, #84]
	ubfx	r2, r2, #3, #5
	ubfx	r3, r3, #27, #1
	orr	r3, r2, r3, lsl #5
	cmp	r4, r3
	it	cc
	movcc	r4, r3
	b	.L401
.L412:
	mov	r4, #-1
.L401:
	cmp	r5, #0
	ite	ne
	movne	r3, #2
	moveq	r3, #0
	sub	r2, ip, #2
	mov	r0, r8
	movs	r1, #0
	mla	r7, r7, r3, r5
	and	r2, r2, #3
	mov	r3, fp
	str	ip, [sp, #8]
	add	fp, fp, #1024
	str	r7, [sp, #0]
	bl	NandcCopy1KB
	ldr	ip, [sp, #8]
	mov	r7, ip
.L399:
	cmp	r7, sl
	bcc	.L403
.L394:
	ldr	r3, .L418+12
	ldr	r3, [r3, #0]
	cmp	r3, #5
	bls	.L404
	ldr	r3, [sp, #12]
	cbnz	r3, .L404
	ldr	r3, [r8, #0]
	and	r2, r3, #139264
	cmp	r2, #139264
	bne	.L404
	mov	r4, #-1
	orr	r3, r3, #131072
	str	r3, [r8, #0]
.L404:
	mov	r0, r4
	add	sp, sp, #88
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L419:
	.align	2
.L418:
	.word	.LANCHOR5
	.word	.LANCHOR36
	.word	.LANCHOR38
	.word	.LANCHOR37
	.size	NandcXferData, .-NandcXferData
	.section	.text.FlashProgPage,"ax",%progbits
	.align	1
	.global	FlashProgPage
	.thumb
	.thumb_func
	.type	FlashProgPage, %function
FlashProgPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r3
	ldr	r3, .L423
	mov	r5, r1
	mov	r6, r2
	mov	r4, r0
	ldrb	r7, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L421
	ldr	r3, .L423+4
	ldr	r2, .L423+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	muls	r3, r2, r3
	cmp	r1, r3
	bcs	.L421
	ldr	r3, .L423+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L422
	subs	r7, r7, #2
	b	.L421
.L422:
	movs	r7, #4
.L421:
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r0, r4
	mov	r1, r5
	bl	FlashProgFirstCmd
	uxtb	r2, r7
	mov	r3, r6
	movs	r1, #1
	mov	r0, r4
	str	r8, [sp, #0]
	bl	NandcXferData
	mov	r1, r5
	mov	r0, r4
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatus
	mov	r5, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	and	r0, r5, #1
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L424:
	.align	2
.L423:
	.word	.LANCHOR18
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR0
	.size	FlashProgPage, .-FlashProgPage
	.section	.text.FlashPageProgMsbFFData,"ax",%progbits
	.align	1
	.global	FlashPageProgMsbFFData
	.thumb
	.thumb_func
	.type	FlashPageProgMsbFFData, %function
FlashPageProgMsbFFData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L433
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r2
	ldr	r2, .L433+4
	mov	r8, r0
	ldr	r3, [r3, #0]
	mov	r7, r1
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cbz	r2, .L426
	ldr	r2, .L433+8
	ldr	r1, [r2, #0]
	ldr	r2, .L433+12
	cmp	r1, r2
	beq	.L425
.L426:
	subs	r2, r3, #5
	cmp	r2, #2
	bls	.L430
	cmp	r3, #68
	beq	.L430
	cmp	r3, #35
	beq	.L430
	cmp	r3, #19
	bne	.L425
	b	.L430
.L431:
	ldrh	r3, [sl, r4, lsl #1]
	cmp	r3, fp
	bne	.L425
	movs	r1, #255
	mov	r2, #32768
	ldr	r0, [r5, #0]
	bl	memset
	adds	r1, r4, r7
	adds	r4, r4, #1
	mov	r0, r8
	ldr	r2, [r5, #0]
	movs	r3, #0
	bl	FlashProgPage
	uxth	r4, r4
	b	.L432
.L430:
	ldr	r6, .L433
	movw	fp, #65535
	ldr	sl, .L433+20
	ldr	r5, .L433+16
.L432:
	ldr	r3, [r6, #0]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L431
.L425:
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L434:
	.align	2
.L433:
	.word	.LANCHOR23
	.word	.LANCHOR7
	.word	.LANCHOR40
	.word	1446522928
	.word	.LANCHOR41
	.word	.LANCHOR9
	.size	FlashPageProgMsbFFData, .-FlashPageProgMsbFFData
	.section	.text.FlashReadRawPage,"ax",%progbits
	.align	1
	.global	FlashReadRawPage
	.thumb
	.thumb_func
	.type	FlashReadRawPage, %function
FlashReadRawPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r3
	ldr	r3, .L438
	mov	r6, r1
	mov	r5, r2
	mov	r4, r0
	ldrb	r7, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L436
	ldr	r3, .L438+4
	ldr	r2, .L438+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	muls	r3, r2, r3
	cmp	r1, r3
	it	cc
	movcc	r7, #4
.L436:
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r1, r6
	mov	r0, r4
	bl	FlashReadCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r3, r5
	movs	r1, #0
	mov	r2, r7
	mov	r0, r4
	str	r8, [sp, #0]
	bl	NandcXferData
	mov	r5, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L439:
	.align	2
.L438:
	.word	.LANCHOR18
	.word	.LANCHOR1
	.word	.LANCHOR2
	.size	FlashReadRawPage, .-FlashReadRawPage
	.section	.text.HynixReadRetrial,"ax",%progbits
	.align	1
	.global	HynixReadRetrial
	.thumb
	.thumb_func
	.type	HynixReadRetrial, %function
HynixReadRetrial:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	sl, r2
	ldr	r2, .L455
	mov	r7, r3
	mov	r6, r0
	str	r1, [sp, #4]
	adds	r3, r2, r0
	mov	r8, #0
	ldrb	fp, [r2, #2]	@ zero_extendqisi2
	mov	r5, #-1
	ldr	r2, .L455+4
	ldrb	r4, [r3, #12]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	ldrb	r2, [r2, #19]	@ zero_extendqisi2
	cmp	r2, #7
	it	eq
	ldrbeq	r4, [r3, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
	b	.L442
.L447:
	adds	r4, r4, #1
	ldr	r2, .L455
	mov	r0, r6
	uxtb	r4, r4
	cmp	r4, fp
	it	cs
	movcs	r4, #0
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	mov	r3, r4
	adds	r2, r2, #4
	bl	HynixSetRRPara
	mov	r3, r7
	mov	r0, r6
	ldr	r1, [sp, #4]
	mov	r2, sl
	bl	FlashReadRawPage
	adds	r3, r0, #1
	beq	.L444
	ldr	r2, .L455+8
	cmp	r5, #-1
	it	eq
	moveq	r5, r0
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, lsr #2
	bcc	.L453
	movs	r7, #0
	mov	sl, r7
.L444:
	add	r8, r8, #1
.L442:
	cmp	r8, fp
	bcc	.L447
	b	.L446
.L453:
	mov	r5, r0
.L446:
	ldr	r3, .L455+4
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #7
	ldr	r3, .L455
	add	r6, r3, r6
	ldr	r3, .L455+8
	it	eq
	strbeq	r4, [r6, #20]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	it	ne
	strbne	r4, [r6, #12]
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bcc	.L450
	cmp	r5, #-1
	ite	eq
	moveq	r5, #-1
	movne	r5, #256
.L450:
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L456:
	.align	2
.L455:
	.word	.LANCHOR31
	.word	.LANCHOR23
	.word	.LANCHOR29
	.size	HynixReadRetrial, .-HynixReadRetrial
	.global	__aeabi_idiv
	.section	.text.MicronReadRetrial,"ax",%progbits
	.align	1
	.global	MicronReadRetrial
	.thumb
	.thumb_func
	.type	MicronReadRetrial, %function
MicronReadRetrial:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	fp, r3
	ldr	r3, .L471
	mov	sl, r0
	sub	sp, sp, #24
	ldrb	r0, [r3, #0]	@ zero_extendqisi2
	ldr	r3, .L471+4
	str	r1, [sp, #16]
	str	r2, [sp, #20]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L458
	add	r0, r0, r0, lsl #1
	ubfx	r0, r0, #2, #8
	b	.L470
.L458:
	movs	r1, #3
	bl	__aeabi_idiv
	uxtb	r0, r0
.L470:
	str	r0, [sp, #12]
	mov	r0, sl
	bl	NandcWaitFlashReady
	ldr	r3, .L471+8
	mov	r8, #0
	mov	r4, #-1
	ldr	r6, [r3, sl, lsl #3]
	add	r3, r3, sl, lsl #3
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	adds	r7, r7, #8
	lsls	r7, r7, #8
	adds	r5, r6, r7
	b	.L460
.L464:
	movs	r2, #239
	movs	r3, #137
	str	r2, [r5, #8]
	movs	r0, #200
	str	r3, [r5, #4]
	bl	udelay
	movs	r2, #0
	add	ip, r8, #1
	mov	r0, sl
	str	ip, [r5, #0]
	mov	r3, fp
	str	r2, [r5, #0]
	ldr	r1, [sp, #16]
	str	r2, [r5, #0]
	str	r2, [r5, #0]
	ldr	r2, [sp, #20]
	str	ip, [sp, #8]
	bl	FlashReadRawPage
	ldr	ip, [sp, #8]
	adds	r2, r0, #1
	beq	.L461
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L468
	mov	fp, #0
	str	fp, [sp, #20]
.L461:
	mov	r8, ip
.L460:
	ldr	r2, .L471+12
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	cmp	r8, r3
	bcc	.L464
	b	.L463
.L468:
	mov	r4, r0
.L463:
	movs	r3, #239
	movs	r0, #200
	str	r3, [r5, #8]
	movs	r3, #137
	str	r3, [r5, #4]
	bl	udelay
	movs	r3, #0
	str	r3, [r6, r7]
	str	r3, [r6, r7]
	str	r3, [r6, r7]
	str	r3, [r6, r7]
	ldr	r3, [sp, #12]
	cmp	r4, r3
	bcc	.L465
	ldr	r0, .L471+16
	mov	r1, r8
	ldr	r2, [sp, #16]
	mov	r3, r8
	cmp	r4, #-1
	ite	eq
	moveq	r4, #-1
	movne	r4, #256
	str	r4, [sp, #0]
	bl	printf
.L465:
	mov	r0, r4
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L472:
	.align	2
.L471:
	.word	.LANCHOR29
	.word	.LANCHOR7
	.word	.LANCHOR5
	.word	.LANCHOR42
	.word	.LC2
	.size	MicronReadRetrial, .-MicronReadRetrial
	.section	.text.SamsungReadRetrial,"ax",%progbits
	.align	1
	.global	SamsungReadRetrial
	.thumb
	.thumb_func
	.type	SamsungReadRetrial, %function
SamsungReadRetrial:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r7, r0
	mov	r8, r2
	mov	r6, r3
	mov	fp, r1
	bl	NandcWaitFlashReady
	ldr	r3, .L483
	movs	r5, #1
	mov	r4, #-1
	ldr	r2, [r3, r7, lsl #3]
	add	r3, r3, r7, lsl #3
	ldrb	sl, [r3, #4]	@ zero_extendqisi2
	add	sl, sl, #8
	add	sl, r2, sl, lsl #8
	b	.L474
.L478:
	mov	r0, sl
	uxtb	r1, r5
	bl	SamsungSetRRPara
	mov	r1, fp
	mov	r0, r7
	mov	r2, r8
	mov	r3, r6
	bl	FlashReadRawPage
	adds	r1, r0, #1
	beq	.L475
	ldr	r2, .L483+4
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, lsr #2
	bcc	.L481
	movs	r6, #0
	mov	r8, r6
.L475:
	adds	r5, r5, #1
.L474:
	ldr	r2, .L483+8
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r3
	bcc	.L478
	b	.L477
.L481:
	mov	r4, r0
.L477:
	movs	r1, #0
	mov	r0, sl
	bl	SamsungSetRRPara
	ldr	r3, .L483+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcc	.L479
	cmp	r4, #-1
	ite	eq
	moveq	r4, #-1
	movne	r4, #256
.L479:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L484:
	.align	2
.L483:
	.word	.LANCHOR5
	.word	.LANCHOR29
	.word	.LANCHOR42
	.size	SamsungReadRetrial, .-SamsungReadRetrial
	.section	.text.ToshibaReadRetrial,"ax",%progbits
	.align	1
	.global	ToshibaReadRetrial
	.thumb
	.thumb_func
	.type	ToshibaReadRetrial, %function
ToshibaReadRetrial:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r7, r0
	mov	fp, r2
	mov	r8, r3
	str	r1, [sp, #4]
	bl	NandcWaitFlashReady
	ldr	r3, .L507
	ldr	r2, [r3, r7, lsl #3]
	add	r3, r3, r7, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L507+4
	adds	r4, r4, #8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r4, r2, r4, lsl #8
	subs	r3, r3, #67
	cmp	r3, #1
	bls	.L502
	ldr	r3, .L507+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L503
	movs	r0, #0
	mov	sl, #1
	bl	NandcSetDdrMode
	b	.L487
.L503:
	mov	sl, r3
.L487:
	movs	r3, #92
	str	r3, [r4, #8]
	movs	r3, #197
	str	r3, [r4, #8]
	b	.L486
.L502:
	mov	sl, #0
.L486:
	movs	r6, #1
	mov	r5, #-1
	b	.L488
.L497:
	ldr	r1, .L507+4
	mov	r0, r4
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	uxtb	r1, r6
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L489
	bl	SandiskSetRRPara
	b	.L490
.L489:
	bl	ToshibaSetRRPara
.L490:
	ldr	r2, .L507+4
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L491
	ldr	r1, .L507+12
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r6, r3
	bne	.L491
	movs	r2, #179
	str	r2, [r4, #8]
.L491:
	movs	r3, #38
	str	r3, [r4, #8]
	movs	r3, #93
	str	r3, [r4, #8]
	cmp	sl, #0
	beq	.L492
	movs	r0, #4
	bl	NandcSetDdrMode
	ldr	r1, [sp, #4]
	mov	r2, fp
	mov	r3, r8
	mov	r0, r7
	bl	FlashReadRawPage
	mov	r3, r0
	movs	r0, #0
	str	r3, [sp, #0]
	bl	NandcSetDdrMode
	ldr	r3, [sp, #0]
	b	.L493
.L492:
	mov	r3, r8
	mov	r0, r7
	ldr	r1, [sp, #4]
	mov	r2, fp
	bl	FlashReadRawPage
	mov	r3, r0
.L493:
	adds	r0, r3, #1
	beq	.L494
	ldr	r1, .L507+16
	cmp	r5, #-1
	it	eq
	moveq	r5, r3
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r3, r2, lsr #2
	bcc	.L505
	mov	r8, #0
	mov	fp, r8
.L494:
	adds	r6, r6, #1
.L488:
	ldr	r2, .L507+12
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L497
	b	.L496
.L505:
	mov	r5, r3
.L496:
	ldr	r3, .L507+4
	movs	r1, #0
	mov	r0, r4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L498
	bl	SandiskSetRRPara
	b	.L499
.L498:
	bl	ToshibaSetRRPara
.L499:
	movs	r3, #255
	str	r3, [r4, #8]
	ldr	r3, .L507+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bcc	.L500
	cmp	r5, #-1
	ite	eq
	moveq	r5, #-1
	movne	r5, #256
.L500:
	mov	r0, r7
	bl	NandcWaitFlashReady
	cmp	sl, #0
	beq	.L501
	movs	r0, #4
	bl	NandcSetDdrMode
.L501:
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L508:
	.align	2
.L507:
	.word	.LANCHOR5
	.word	.LANCHOR11
	.word	.LANCHOR35
	.word	.LANCHOR42
	.word	.LANCHOR29
	.size	ToshibaReadRetrial, .-ToshibaReadRetrial
	.section	.text.FlashSavePhyInfo,"ax",%progbits
	.align	1
	.global	FlashSavePhyInfo
	.thumb
	.thumb_func
	.type	FlashSavePhyInfo, %function
FlashSavePhyInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r5, #0
	ldr	r7, .L516
	ldr	r8, .L516+60
	ldr	sl, .L516+64
	ldr	r3, [r7, #0]
	ldr	fp, .L516+48
	ldr	r6, .L516+4
	str	r3, [r8, #0]
	ldr	r3, .L516+8
	ldrb	r0, [r3, #0]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r1, #0
	mov	r2, #2048
	ldr	r0, [r7, #0]
	bl	memset
	ldr	r0, [r8, #0]
	ldr	r3, .L516+12
	movs	r2, #32
	ldr	r1, .L516+16
	str	sl, [r0, #0]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	strh	r3, [r0, #12]	@ movhi
	ldr	r3, .L516+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	strh	r3, [r0, #14]	@ movhi
	ldr	r3, .L516+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	str	r3, [r0, #1076]
	adds	r0, r0, #16
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L516+28
	movs	r2, #8
	adds	r0, r0, #80
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L516+32
	movs	r2, #32
	adds	r0, r0, #96
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L516+36
	movs	r2, #32
	adds	r0, r0, #160
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L516+40
	movs	r2, #32
	adds	r0, r0, #192
	bl	memcpy
	ldr	r0, [r8, #0]
	mov	r2, #852
	ldr	r1, .L516+44
	adds	r0, r0, #224
	bl	memcpy
	ldr	r4, [r8, #0]
	movw	r1, #2036
	add	r0, r4, #12
	bl	JSHash
	mov	r3, #1592
	str	r3, [r4, #4]
	ldr	r3, [fp, #0]
	str	r3, [r8, #0]
	str	r0, [r4, #8]
	movs	r0, #0
	bl	flash_enter_slc_mode
	mov	r4, r5
.L512:
	movs	r0, #0
	ldr	r1, [r6, #0]
	mov	r2, r0
	muls	r1, r4, r1
	bl	FlashEraseBlock
	movs	r0, #0
	ldr	r1, [r6, #0]
	mov	r3, r0
	muls	r1, r4, r1
	ldr	r2, [r7, #0]
	bl	FlashProgPage
	movs	r0, #0
	ldr	r1, [r6, #0]
	mov	r3, r0
	muls	r1, r4, r1
	ldr	r2, [r7, #0]
	adds	r1, r1, #1
	bl	FlashProgPage
	ldr	r3, .L516+48
	movs	r0, #0
	ldr	r1, [r6, #0]
	muls	r1, r4, r1
	ldr	r2, [r3, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L510
	ldr	fp, [r8, #0]
	ldr	r3, [fp, #0]
	cmp	r3, sl
	bne	.L510
	add	r0, fp, #12
	movw	r1, #2036
	bl	JSHash
	ldr	r3, [fp, #8]
	cmp	r3, r0
	bne	.L510
	ldr	r3, .L516+52
	adds	r2, r4, #1
	adds	r5, r5, #1
	str	r2, [r3, #0]
	ldr	r3, .L516+56
	ldr	r2, [r6, #0]
	muls	r2, r4, r2
	cmp	r5, #1
	str	r2, [r3, #0]
	bhi	.L511
.L510:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L512
.L511:
	movs	r0, #0
	bl	flash_exit_slc_mode
	cmp	r5, #0
	ite	eq
	moveq	r0, #-1
	movne	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L517:
	.align	2
.L516:
	.word	.LANCHOR44
	.word	.LANCHOR2
	.word	.LANCHOR45
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR1
	.word	.LANCHOR35
	.word	.LANCHOR19
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR6
	.word	.LANCHOR31
	.word	.LANCHOR41
	.word	.LANCHOR46
	.word	.LANCHOR47
	.word	.LANCHOR43
	.word	1312902724
	.size	FlashSavePhyInfo, .-FlashSavePhyInfo
	.section	.text.FlashReadIdbDataRaw,"ax",%progbits
	.align	1
	.global	FlashReadIdbDataRaw
	.thumb
	.thumb_func
	.type	FlashReadIdbDataRaw, %function
FlashReadIdbDataRaw:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r2, #4
	mov	r8, r0
	ldr	r1, .L529
	add	r0, sp, #12
	bl	memcpy
	ldr	r3, .L529+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	str	r3, [sp, #4]
	ldr	r3, .L529+8
	ldr	r2, [r3, #0]
	ldr	r3, .L529+12
	cmp	r2, r3
	bne	.L519
	movs	r0, #0
	bl	flash_enter_slc_mode
.L519:
	mov	r0, r8
	movs	r1, #0
	mov	r2, #2048
	mov	r7, #-1
	bl	memset
	movs	r4, #2
	ldr	sl, .L529+32
	ldr	fp, .L529+36
	ldr	r6, .L529+16
	b	.L520
.L527:
	movs	r5, #0
.L522:
	add	r3, sp, #12
	ldrb	r0, [r3, r5]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r3, .L529+16
	movs	r0, #0
	ldr	r1, [fp, #0]
	muls	r1, r4, r1
	ldr	r2, [r3, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L521
	adds	r5, r5, #1
	cmp	r5, #4
	bne	.L522
	b	.L523
.L521:
	ldr	r3, [r6, #0]
	ldr	r2, [r3, #0]
	ldr	r3, .L529+20
	cmp	r2, r3
	bne	.L523
	add	r3, sp, #16
	ldr	r0, .L529+24
	adds	r5, r3, r5
	ldrb	r1, [r5, #-4]	@ zero_extendqisi2
	bl	printf
	mov	r2, #2048
	mov	r0, r8
	ldr	r1, [r6, #0]
	bl	memcpy
	ldr	r3, [r6, #0]
	ldr	r3, [r3, #512]
	strb	r3, [sl, #0]
	ldr	r3, .L529+28
	ldr	r2, [r3, #0]
	cmp	r2, r4
	bls	.L526
	str	r4, [r3, #0]
	movs	r7, #0
	bl	FlashSavePhyInfo
.L523:
	adds	r4, r4, #1
.L520:
	ldrb	r3, [sl, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L527
	b	.L524
.L526:
	movs	r7, #0
.L524:
	ldr	r0, [sp, #4]
	bl	FlashBchSel
	ldr	r3, .L529+8
	ldr	r2, [r3, #0]
	ldr	r3, .L529+12
	cmp	r2, r3
	bne	.L525
	movs	r0, #0
	bl	flash_exit_slc_mode
.L525:
	mov	r0, r7
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L530:
	.align	2
.L529:
	.word	.LANCHOR48
	.word	.LANCHOR29
	.word	.LANCHOR40
	.word	1446522928
	.word	.LANCHOR44
	.word	-52655045
	.word	.LC3
	.word	.LANCHOR46
	.word	.LANCHOR1
	.word	.LANCHOR2
	.size	FlashReadIdbDataRaw, .-FlashReadIdbDataRaw
	.section	.text.FlashLoadPhyInfo,"ax",%progbits
	.align	1
	.global	FlashLoadPhyInfo
	.thumb
	.thumb_func
	.type	FlashLoadPhyInfo, %function
FlashLoadPhyInfo:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r2, #4
	ldr	sl, .L543+40
	add	r0, sp, #12
	ldr	r1, .L543
	movs	r4, #0
	bl	memcpy
	ldr	r5, .L543+4
	ldr	r3, [sl, #0]
	mov	r0, r4
	ldr	r6, .L543+8
	mov	r8, #4
	mov	r7, #-1
	str	r3, [r5, #0]
	ldr	r3, .L543+12
	ldrh	r2, [r6, #10]
	str	r4, [r3, #0]
	str	r2, [sp, #4]
	bl	flash_enter_slc_mode
	b	.L532
.L534:
	add	r3, sp, #12
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
	mov	r1, r4
	ldr	r2, [sl, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L533
	movs	r0, #0
	mov	r1, fp
	ldr	r2, [sl, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L533
	adds	r6, r6, #1
	cmp	r6, #4
	beq	.L535
	b	.L534
.L533:
	ldr	r6, [r5, #0]
	ldr	r2, .L543+16
	ldr	r3, [r6, #0]
	cmp	r3, r2
	bne	.L535
	cbnz	r7, .L536
	ldr	r3, .L543+8
	mov	r0, r4
	ldrh	r1, [r3, #10]
	bl	__aeabi_uidiv
	ldr	r3, .L543+20
	adds	r0, r0, #1
	str	r0, [r3, #0]
	mov	r0, r7
	b	.L542
.L536:
	add	r0, r6, #12
	movw	r1, #2036
	bl	JSHash
	ldr	r3, [r6, #8]
	cmp	r3, r0
	bne	.L535
	add	r1, r6, #160
	movs	r2, #32
	ldr	r0, .L543+8
	bl	memcpy
	ldr	r1, [r5, #0]
	movs	r2, #32
	ldr	r0, .L543+24
	adds	r1, r1, #192
	bl	memcpy
	ldr	r1, [r5, #0]
	mov	r2, #852
	ldr	r0, .L543+28
	adds	r1, r1, #224
	bl	memcpy
	ldr	r6, [r5, #0]
	ldr	r3, .L543+32
	mov	r0, r4
	ldr	r2, [r6, #1076]
	strb	r2, [r3, #0]
	ldr	r3, .L543+12
	str	r4, [r3, #0]
	ldr	r3, .L543+8
	ldrh	r1, [r3, #10]
	bl	__aeabi_uidiv
	ldr	r3, .L543+20
	adds	r0, r0, #1
	str	r0, [r3, #0]
	cmp	r0, #1
	bne	.L538
	movs	r2, #2
	str	r2, [r3, #0]
.L538:
	ldrh	r2, [r6, #14]
	movs	r7, #0
	ldr	r3, .L543+36
	strb	r2, [r3, #0]
.L535:
	ldr	r2, [sp, #4]
	subs	r8, r8, #1
	add	r4, r4, r2
	beq	.L539
.L532:
	add	fp, r4, #1
	movs	r6, #0
	b	.L534
.L539:
	mov	r0, r8
.L542:
	bl	flash_exit_slc_mode
	mov	r0, r7
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L544:
	.align	2
.L543:
	.word	.LANCHOR48
	.word	.LANCHOR43
	.word	.LANCHOR18
	.word	.LANCHOR47
	.word	1312902724
	.word	.LANCHOR46
	.word	.LANCHOR6
	.word	.LANCHOR31
	.word	.LANCHOR35
	.word	.LANCHOR49
	.word	.LANCHOR44
	.size	FlashLoadPhyInfo, .-FlashLoadPhyInfo
	.section	.text.FlashDdrTunningRead,"ax",%progbits
	.align	1
	.global	FlashDdrTunningRead
	.thumb
	.thumb_func
	.type	FlashDdrTunningRead, %function
FlashDdrTunningRead:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	sl, r3
	ldr	r3, .L565
	sub	sp, sp, #24
	mov	fp, r2
	str	r0, [sp, #8]
	ldr	r3, [r3, #0]
	str	r1, [sp, #12]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L565+4
	ldr	r7, [r3, #0]
	ldr	r3, [sp, #56]
	cmp	r7, #7
	ite	hi
	movhi	r7, #12
	movls	r7, #6
	cbz	r3, .L557
	movs	r0, #1
	ldr	r4, .L565+8
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	ldr	r0, [sp, #8]
	bl	FlashReset
	ldr	r1, [sp, #12]
	mov	r2, fp
	mov	r3, sl
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	mov	r8, r0
	ldrb	r0, [r4, #0]	@ zero_extendqisi2
	bl	FlashSetInterfaceMode
	ldrb	r0, [r4, #0]	@ zero_extendqisi2
	bl	NandcSetMode
	cmp	r8, #-1
	beq	.L548
	mov	r2, r8
	ldr	r0, .L565+12
	ldr	r1, [sp, #12]
	bl	printf
	ldr	r3, .L565+16
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	cmp	r2, #2048
	bcc	.L548
	movs	r2, #0
	str	r2, [r3, #0]
	mov	sl, r2
	mov	fp, r2
	b	.L547
.L557:
	mov	r8, #1024
.L547:
	movs	r4, #0
	mov	r6, #-1
	mov	ip, r4
	mov	r5, r4
	str	r4, [sp, #16]
.L553:
	uxtb	r0, r7
	str	ip, [sp, #4]
	bl	NandcSetDdrPara
	mov	r3, sl
	ldr	r0, [sp, #8]
	mov	r2, fp
	ldr	r1, [sp, #12]
	bl	FlashReadRawPage
	add	r3, r8, #1
	ldr	ip, [sp, #4]
	cmp	r0, r3
	bhi	.L549
	cmp	r0, #2
	bhi	.L559
	adds	r5, r5, #1
	cmp	r5, #9
	bls	.L559
	subs	r4, r7, r5
	mov	r8, r0
	movs	r6, #0
	b	.L551
.L549:
	cmp	ip, r5
	bcs	.L560
	cmp	r5, #7
	rsb	r3, r5, r4
	str	r3, [sp, #16]
	bhi	.L552
	mov	ip, r5
	b	.L560
.L559:
	movs	r6, #0
	mov	r4, r7
	mov	r8, r0
	mov	sl, r6
	mov	fp, r6
	b	.L550
.L560:
	movs	r5, #0
.L550:
	adds	r7, r7, #2
	cmp	r7, #69
	bls	.L553
.L551:
	cmp	ip, r5
	bcc	.L554
.L552:
	ldr	r4, [sp, #16]
.L554:
	cbz	r4, .L555
	ldr	r0, .L565+20
	mov	r1, r4
	bl	printf
	uxtb	r0, r4
	bl	NandcSetDdrPara
.L555:
	cbz	r6, .L548
	ldr	r0, .L565+24
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #12]
	bl	printf
	ldr	r3, [sp, #56]
	cbz	r3, .L562
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L548
.L562:
	mov	r8, r6
.L548:
	mov	r0, r8
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L566:
	.align	2
.L565:
	.word	.LANCHOR30
	.word	.LANCHOR37
	.word	.LANCHOR34
	.word	.LC4
	.word	.LANCHOR50
	.word	.LC5
	.word	.LC6
	.size	FlashDdrTunningRead, .-FlashDdrTunningRead
	.section	.text.FlashDdrParaScan,"ax",%progbits
	.align	1
	.global	FlashDdrParaScan
	.thumb
	.thumb_func
	.type	FlashDdrParaScan, %function
FlashDdrParaScan:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	ldr	r5, .L572
	movs	r4, #0
	mov	r7, r1
	ldrb	r0, [r5, #0]	@ zero_extendqisi2
	bl	FlashSetInterfaceMode
	ldrb	r0, [r5, #0]	@ zero_extendqisi2
	bl	NandcSetMode
	mov	r1, r7
	mov	r2, r4
	mov	r3, r4
	mov	r0, r6
	str	r4, [sp, #0]
	bl	FlashDdrTunningRead
	mov	r1, r7
	mov	r2, r4
	mov	r3, r4
	mov	r8, r0
	mov	r0, r6
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L568
	cmp	r8, #-1
	bne	.L569
.L568:
	ldrb	r3, [r5, #0]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L569
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r2, #0
	b	.L571
.L569:
	movs	r2, #1
.L571:
	ldr	r3, .L572+4
	movs	r0, #0
	strb	r2, [r3, #0]
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L573:
	.align	2
.L572:
	.word	.LANCHOR34
	.word	.LANCHOR35
	.size	FlashDdrParaScan, .-FlashDdrParaScan
	.section	.text.FlashReadPage,"ax",%progbits
	.align	1
	.global	FlashReadPage
	.thumb
	.thumb_func
	.type	FlashReadPage, %function
FlashReadPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	sl, r3
	mov	r5, r0
	mov	r7, r1
	mov	r8, r2
	bl	FlashReadRawPage
	adds	r3, r0, #1
	mov	r4, r0
	bne	.L575
	ldr	r6, .L580
	ldrb	fp, [r6, #0]	@ zero_extendqisi2
	cmp	fp, #0
	beq	.L576
	movs	r3, #0
	mov	r0, r5
	strb	r3, [r6, #0]
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	bl	FlashReadRawPage
	strb	fp, [r6, #0]
	adds	r6, r0, #1
	bne	.L579
.L576:
	ldr	r3, .L580+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L575
	ldr	r3, .L580+8
	mov	r0, r5
	mov	r1, r7
	mov	r2, r8
	ldr	r3, [r3, #0]
	ldr	r6, [r3, #304]
	movs	r3, #1
	str	r3, [sp, #0]
	mov	r3, sl
	bl	FlashDdrTunningRead
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L577
	ldr	r3, .L580+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r4, r3, lsr #1
	bls	.L575
.L577:
	ubfx	r0, r6, #8, #8
	bl	NandcSetDdrPara
	b	.L575
.L579:
	mov	r4, r0
.L575:
	ldr	fp, .L580+24
	ldr	r6, [fp, #0]
	cbz	r6, .L578
	adds	r1, r4, #1
	bne	.L578
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	mov	r0, r5
	blx	r6
	mov	r2, r5
	mov	r3, r7
	mov	r4, r0
	ldr	r0, .L580+16
	mov	r1, r4
	bl	printf
	adds	r2, r4, #1
	bne	.L578
	ldr	r3, .L580+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L578
	mov	r0, r5
	bl	flash_enter_slc_mode
	ldr	r4, [fp, #0]
	mov	r0, r5
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	blx	r4
	mov	r4, r0
	mov	r0, r5
	bl	flash_exit_slc_mode
.L578:
	mov	r0, r4
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L581:
	.align	2
.L580:
	.word	.LANCHOR4
	.word	.LANCHOR35
	.word	.LANCHOR30
	.word	.LANCHOR29
	.word	.LC7
	.word	.LANCHOR7
	.word	.LANCHOR51
	.size	FlashReadPage, .-FlashReadPage
	.section	.text.Ftl_log2,"ax",%progbits
	.align	1
	.global	Ftl_log2
	.thumb
	.thumb_func
	.type	Ftl_log2, %function
Ftl_log2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r2, #1
	movs	r3, #0
	b	.L583
.L584:
	adds	r3, r3, #1
	lsls	r2, r2, #1
	uxth	r3, r3
.L583:
	cmp	r2, r0
	bls	.L584
	subs	r3, r3, #1
	uxth	r0, r3
	bx	lr
	.size	Ftl_log2, .-Ftl_log2
	.section	.text.FtlPrintInfo,"ax",%progbits
	.align	1
	.global	FtlPrintInfo
	.thumb
	.thumb_func
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
	.thumb
	.thumb_func
	.type	FtlSysBlkNumInit, %function
FtlSysBlkNumInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L589
	cmp	r0, #23
	it	ls
	movls	r0, #24
	ldr	r2, .L589+4
	str	r0, [r3, #0]
	ldr	r3, .L589+8
	ldrh	r3, [r3, #0]
	muls	r3, r0, r3
	str	r3, [r2, #0]
	ldr	r2, .L589+12
	ldrh	r2, [r2, #0]
	subs	r0, r2, r0
	ldr	r2, .L589+16
	strh	r0, [r2, #0]	@ movhi
	movs	r0, #0
	ldr	r2, .L589+20
	ldr	r2, [r2, #0]
	subs	r3, r2, r3
	ldr	r2, .L589+24
	str	r3, [r2, #0]
	bx	lr
.L590:
	.align	2
.L589:
	.word	.LANCHOR52
	.word	.LANCHOR54
	.word	.LANCHOR53
	.word	.LANCHOR56
	.word	.LANCHOR55
	.word	.LANCHOR58
	.word	.LANCHOR57
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.section	.text.FtlConstantsInit,"ax",%progbits
	.align	1
	.global	FtlConstantsInit
	.thumb
	.thumb_func
	.type	FtlConstantsInit, %function
FtlConstantsInit:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrh	r7, [r0, #8]
	sub	sp, sp, #32
	ldr	r3, .L607
	ldrh	r1, [r0, #10]
	ldrh	r0, [r0, #12]
	strh	r7, [r3, #0]	@ movhi
	ldr	r3, .L607+4
	ldrh	ip, [r4, #14]
	ldr	r2, .L607+8
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L607+12
	strh	r0, [r3, #0]	@ movhi
	ldr	r3, .L607+16
	strh	ip, [r3, #0]	@ movhi
	movs	r3, #0
.L592:
	strb	r3, [r3, r2]
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L592
	ldrh	r2, [r4, #14]
	ldrh	r3, [r4, #20]
	cmp	r3, r2, lsr #8
	bcs	.L593
	ldr	r3, .L607+8
	uxtb	sl, r0
	movs	r2, #0
	subs	r6, r3, r0
	str	r6, [sp, #24]
	subs	r6, r1, #1
	lsl	r8, sl, #1
	mla	r6, r0, r6, r3
	uxtb	r8, r8
	rsb	r5, r8, #0
	uxtb	r5, r5
	str	r6, [sp, #28]
	b	.L594
.L595:
	ldr	r2, [sp, #12]
	add	fp, r6, r5
	add	lr, lr, #1
	strb	fp, [r2, r3]
	ldr	r2, [sp, #20]
	add	fp, r6, r2
	ldr	r2, [sp, #16]
	strb	fp, [r2, r3]
	b	.L596
.L605:
	ldr	fp, [sp, #24]
	movs	r3, #0
	mov	r6, r3
	mov	lr, r3
	add	fp, fp, r2
	str	fp, [sp, #12]
	ldr	fp, [sp, #28]
	str	r2, [sp, #4]
	add	fp, fp, r2
	str	fp, [sp, #16]
	add	fp, r5, sl
	str	fp, [sp, #20]
.L596:
	add	r6, r6, r8
	cmp	lr, r1
	add	r3, r3, r0
	uxtb	r6, r6
	bcc	.L595
	ldr	r2, [sp, #4]
	adds	r5, r5, #1
	adds	r2, r2, #1
	uxtb	r5, r5
.L594:
	cmp	r2, r0
	bcc	.L605
	ldr	r3, .L607+4
	lsls	r1, r1, #1
	lsr	ip, ip, #1
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L607+16
	strh	ip, [r3, #0]	@ movhi
.L593:
	ldr	r3, .L607+20
	movs	r2, #5
	movs	r1, #0
	cmp	r7, #1
	strh	r2, [r3, #0]	@ movhi
	ldr	r2, .L607+24
	it	eq
	strheq	r7, [r3, #0]	@ movhi
	ldr	r3, .L607+28
	strh	r1, [r2, #0]	@ movhi
	mov	r2, #4352
	strh	r2, [r3, #0]	@ movhi
	ldr	r2, .L607+32
	ldrb	r8, [r2, #0]	@ zero_extendqisi2
	cmp	r8, #0
	beq	.L598
	mov	r2, #384
	strh	r2, [r3, #0]	@ movhi
.L598:
	ldr	r3, .L607+4
	ldrh	r5, [r3, #0]
	muls	r5, r0, r5
	ldr	r3, .L607+36
	uxth	r5, r5
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L607+16
	ldrh	r6, [r3, #0]
	muls	r0, r6, r0
	ldr	r3, .L607+40
	uxth	r0, r0
	strh	r0, [r3, #0]	@ movhi
	bl	Ftl_log2
	ldr	r3, .L607+44
	ldrh	fp, [r4, #16]
	ldrh	r1, [r4, #18]
	ldrh	sl, [r4, #20]
	mul	r2, fp, r5
	strh	r0, [r3, #0]	@ movhi
	mov	r0, sl
	ldr	r3, .L607+48
	strh	fp, [r3, #0]	@ movhi
	ldr	r3, .L607+52
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L607+56
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L607+60
	strh	sl, [r3, #0]	@ movhi
	str	r1, [sp, #8]
	bl	Ftl_log2
	ldr	r3, .L607+64
	ldr	r2, .L607+68
	ldr	r1, [sp, #8]
	mul	r1, r1, sl
	strh	r0, [r3, #0]	@ movhi
	lsl	r3, sl, #9
	mov	r7, r0
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L607+72
	lsrs	r3, r3, #8
	cmp	r6, #1024
	strh	r3, [r2, #0]	@ movhi
	ldrh	r2, [r4, #26]
	ldr	r3, .L607+76
	ldr	r4, .L607+28
	strh	r2, [r3, #0]	@ movhi
	mul	r2, r6, r5
	ldr	r3, .L607+80
	ldrh	r0, [r4, #0]
	str	r2, [r3, #0]
	it	hi
	uxtbhi	r2, r6
	ldr	r3, .L607+24
	it	hi
	strhhi	r2, [r3, #0]	@ movhi
	lsls	r0, r0, #3
	ldrh	r2, [r3, #0]
	ldr	r3, .L607+84
	subs	r2, r6, r2
	muls	r2, r5, r2
	mul	r2, sl, r2
	mul	fp, fp, r2
	asr	r2, fp, #11
	str	r2, [r3, #0]
	bl	__aeabi_idiv
	ldr	r3, .L607+88
	uxth	r0, r0
	strh	r0, [r3, #0]	@ movhi
	cmp	r0, #4
	bhi	.L600
	movs	r2, #4
	strh	r2, [r3, #0]	@ movhi
.L600:
	cmp	r8, #0
	beq	.L601
	mov	r3, #640
	strh	r3, [r4, #0]	@ movhi
.L601:
	ldrh	r2, [r4, #0]
	lsls	r6, r6, #6
	ldr	r3, .L607+92
	mov	r1, r5
	ldr	r4, .L607+96
	asr	r2, r2, r7
	adds	r7, r7, #9
	asr	r6, r6, r7
	adds	r2, r2, #2
	strh	r2, [r3, #0]	@ movhi
	uxth	r6, r6
	ldr	r3, .L607+100
	mul	r2, r5, r6
	strh	r6, [r3, #0]	@ movhi
	ldr	r3, .L607+104
	adds	r6, r6, #8
	str	r2, [r3, #0]
	ldr	r3, .L607+88
	ldrh	r0, [r3, #0]
	bl	__aeabi_uidiv
	cmp	r5, #1
	uxtah	r6, r6, r0
	str	r6, [r4, #0]
	bne	.L602
	adds	r6, r6, #4
	str	r6, [r4, #0]
.L602:
	ldrh	r0, [r4, #0]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4, #0]
	ldr	r3, .L607+108
	str	r2, [r3, #0]
	movs	r2, #24
	ldr	r3, .L607+112
	ldr	r1, [r3, #0]
	ldr	r3, .L607+48
	lsls	r1, r1, #2
	ldrh	r3, [r3, #0]
	muls	r1, r3, r1
	ldr	r3, .L607+64
	ldrh	r3, [r3, #0]
	adds	r3, r3, #9
	lsr	r1, r1, r3
	ldr	r3, .L607+116
	adds	r1, r1, #2
	uxth	r1, r1
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L607+120
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #0
	ldr	r3, .L607+124
	str	r2, [r3, #0]
	ldr	r2, .L607+88
	ldrh	r4, [r2, #0]
	adds	r3, r4, #3
	strh	r3, [r2, #0]	@ movhi
	ldr	r3, .L607+104
	ldr	r0, [r3, #0]
	adds	r5, r0, #3
	str	r5, [r3, #0]
	ldr	r5, .L607+128
	ldrb	r5, [r5, #0]	@ zero_extendqisi2
	cbz	r5, .L603
	adds	r4, r4, #4
	adds	r0, r0, #5
	strh	r4, [r2, #0]	@ movhi
	str	r0, [r3, #0]
.L603:
	ldr	r3, .L607+132
	movs	r2, #0
	strh	r2, [r3, #0]	@ movhi
	ldr	r2, .L607+136
	ldrh	r2, [r2, #0]
	lsrs	r0, r2, #3
	add	r2, r0, r2, lsl #1
	adds	r2, r2, #52
	add	r1, r2, r1, lsl #2
	ldr	r2, .L607+60
	ldrh	r2, [r2, #0]
	cmp	r1, r2, lsl #9
	bcs	.L604
	movs	r2, #1
	strh	r2, [r3, #0]	@ movhi
.L604:
	movs	r0, #0
	add	sp, sp, #32
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L608:
	.align	2
.L607:
	.word	.LANCHOR59
	.word	.LANCHOR60
	.word	.LANCHOR62
	.word	.LANCHOR61
	.word	.LANCHOR56
	.word	.LANCHOR63
	.word	.LANCHOR64
	.word	.LANCHOR65
	.word	.LANCHOR0
	.word	.LANCHOR53
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR74
	.word	.LANCHOR75
	.word	.LANCHOR58
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR78
	.word	.LANCHOR52
	.word	.LANCHOR79
	.word	.LANCHOR80
	.word	.LANCHOR81
	.word	.LANCHOR57
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR84
	.word	.LANCHOR7
	.word	.LANCHOR85
	.word	.LANCHOR55
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",%progbits
	.align	1
	.global	IsBlkInVendorPart
	.thumb
	.thumb_func
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L616
	push	{r4, lr}
	ldrh	r3, [r3, #0]
	cbz	r3, .L614
	ldr	r3, .L616+4
	ldrh	r1, [r3, #0]
	ldr	r3, .L616+8
	ldr	r2, [r3, #0]
	movs	r3, #0
	b	.L611
.L613:
	ldrh	r4, [r2], #2
	cmp	r4, r0
	beq	.L615
	adds	r3, r3, #1
	uxth	r3, r3
.L611:
	cmp	r3, r1
	bne	.L613
	movs	r0, #0
	pop	{r4, pc}
.L615:
	movs	r0, #1
	pop	{r4, pc}
.L614:
	mov	r0, r3
	pop	{r4, pc}
.L617:
	.align	2
.L616:
	.word	.LANCHOR86
	.word	.LANCHOR77
	.word	.LANCHOR87
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlGetCap,"ax",%progbits
	.align	1
	.global	FtlGetCap
	.thumb
	.thumb_func
	.type	FtlGetCap, %function
FtlGetCap:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L619
	ldr	r0, [r3, #0]
	bx	lr
.L620:
	.align	2
.L619:
	.word	.LANCHOR84
	.size	FtlGetCap, .-FtlGetCap
	.section	.text.FtlGetCapacity,"ax",%progbits
	.align	1
	.global	FtlGetCapacity
	.thumb
	.thumb_func
	.type	FtlGetCapacity, %function
FtlGetCapacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L622
	ldr	r0, [r3, #0]
	bx	lr
.L623:
	.align	2
.L622:
	.word	.LANCHOR84
	.size	FtlGetCapacity, .-FtlGetCapacity
	.section	.text.ftl_get_density,"ax",%progbits
	.align	1
	.global	ftl_get_density
	.thumb
	.thumb_func
	.type	ftl_get_density, %function
ftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L625
	ldr	r0, [r3, #0]
	bx	lr
.L626:
	.align	2
.L625:
	.word	.LANCHOR84
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.FtlGetLpn,"ax",%progbits
	.align	1
	.global	FtlGetLpn
	.thumb
	.thumb_func
	.type	FtlGetLpn, %function
FtlGetLpn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L628
	ldr	r0, [r3, #0]
	bx	lr
.L629:
	.align	2
.L628:
	.word	.LANCHOR88
	.size	FtlGetLpn, .-FtlGetLpn
	.section	.text.FtlGetCurEraseBlock,"ax",%progbits
	.align	1
	.global	FtlGetCurEraseBlock
	.thumb
	.thumb_func
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L631
	ldr	r3, .L631+4
	ldr	r0, [r2, #0]
	ldrh	r3, [r3, #0]
	muls	r0, r3, r0
	bx	lr
.L632:
	.align	2
.L631:
	.word	.LANCHOR89
	.word	.LANCHOR53
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",%progbits
	.align	1
	.global	FtlGetAllBlockNum
	.thumb
	.thumb_func
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L634
	ldr	r3, .L634+4
	ldrh	r0, [r2, #0]
	ldrh	r3, [r3, #0]
	muls	r0, r3, r0
	bx	lr
.L635:
	.align	2
.L634:
	.word	.LANCHOR53
	.word	.LANCHOR56
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlBbmMapBadBlock,"ax",%progbits
	.align	1
	.global	FtlBbmMapBadBlock
	.thumb
	.thumb_func
	.type	FtlBbmMapBadBlock, %function
FtlBbmMapBadBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L637
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3, #0]
	movs	r7, #1
	mov	r1, r4
	bl	__aeabi_uidiv
	uxth	r2, r0
	mls	r3, r4, r2, r5
	ldr	r4, .L637+4
	add	r1, r4, r2, lsl #2
	ldr	r0, [r1, #28]
	uxth	r3, r3
	and	r1, r3, #31
	lsrs	r6, r3, #5
	lsl	r1, r7, r1
	ldr	r7, [r0, r6, lsl #2]
	orrs	r1, r1, r7
	str	r1, [r0, r6, lsl #2]
	str	r1, [sp, #0]
	mov	r1, r5
	ldr	r0, .L637+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
.L638:
	.align	2
.L637:
	.word	.LANCHOR66
	.word	.LANCHOR90
	.word	.LC8
	.size	FtlBbmMapBadBlock, .-FtlBbmMapBadBlock
	.global	__aeabi_uidivmod
	.section	.text.FtlBbmIsBadBlock,"ax",%progbits
	.align	1
	.global	FtlBbmIsBadBlock
	.thumb
	.thumb_func
	.type	FtlBbmIsBadBlock, %function
FtlBbmIsBadBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L640
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3, #0]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L640+4
	lsrs	r2, r4, #5
	and	r4, r4, #31
	uxth	r0, r0
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsr	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L641:
	.align	2
.L640:
	.word	.LANCHOR66
	.word	.LANCHOR90
	.size	FtlBbmIsBadBlock, .-FtlBbmIsBadBlock
	.section	.text.FtlBbtInfoPrint,"ax",%progbits
	.align	1
	.global	FtlBbtInfoPrint
	.thumb
	.thumb_func
	.type	FtlBbtInfoPrint, %function
FtlBbtInfoPrint:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FtlBbtInfoPrint, .-FtlBbtInfoPrint
	.section	.text.FtlBbt2Bitmap,"ax",%progbits
	.align	1
	.global	FtlBbt2Bitmap
	.thumb
	.thumb_func
	.type	FtlBbt2Bitmap, %function
FtlBbt2Bitmap:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L648
	push	{r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	ldrh	r2, [r3, #0]
	mov	r0, r1
	mov	r5, r1
	movs	r1, #0
	ldr	r7, .L648+4
	movs	r4, #0
	lsls	r2, r2, #2
	movw	r8, #65535
	bl	memset
.L646:
	ldrh	r3, [r6, r4]
	cmp	r3, r8
	beq	.L643
	ldrh	r2, [r7, #0]
	cmp	r2, r3
	bhi	.L645
	ldr	r1, .L648+8
	movs	r2, #79
	ldr	r0, .L648+12
	bl	printf
	ldr	r0, .L648+16
	ldr	r1, .L648+20
	bl	printf
.L645:
	ldrh	r2, [r6, r4]
	movs	r1, #1
	adds	r4, r4, #2
	lsrs	r3, r2, #5
	and	r2, r2, #31
	lsl	r2, r1, r2
	cmp	r4, #1024
	ldr	r1, [r5, r3, lsl #2]
	orr	r2, r1, r2
	str	r2, [r5, r3, lsl #2]
	bne	.L646
.L643:
	pop	{r4, r5, r6, r7, r8, pc}
.L649:
	.align	2
.L648:
	.word	.LANCHOR91
	.word	.LANCHOR66
	.word	.LANCHOR92
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	FtlBbt2Bitmap, .-FtlBbt2Bitmap
	.section	.text.FtlBbtMemInit,"ax",%progbits
	.align	1
	.global	FtlBbtMemInit
	.thumb
	.thumb_func
	.type	FtlBbtMemInit, %function
FtlBbtMemInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L651
	movw	r3, #65535
	movs	r1, #255
	movs	r2, #16
	strh	r3, [r0, #0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	memset
.L652:
	.align	2
.L651:
	.word	.LANCHOR90
	.size	FtlBbtMemInit, .-FtlBbtMemInit
	.section	.text.V2P_block,"ax",%progbits
	.align	1
	.global	V2P_block
	.thumb
	.thumb_func
	.type	V2P_block, %function
V2P_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r7, r1
	ldr	r3, .L654
	mov	r6, r0
	ldrh	r4, [r3, #0]
	muls	r7, r4, r7
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, .L654+4
	mov	r1, r4
	ldrh	r5, [r3, #0]
	mla	r5, r0, r5, r7
	mov	r0, r6
	bl	__aeabi_uidivmod
	adds	r1, r5, r1
	uxth	r0, r1
	pop	{r3, r4, r5, r6, r7, pc}
.L655:
	.align	2
.L654:
	.word	.LANCHOR61
	.word	.LANCHOR66
	.size	V2P_block, .-V2P_block
	.section	.text.P2V_plane,"ax",%progbits
	.align	1
	.global	P2V_plane
	.thumb
	.thumb_func
	.type	P2V_plane, %function
P2V_plane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L657
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r3, #0]
	ldr	r3, .L657+4
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	mov	r1, r4
	mul	r5, r0, r4
	mov	r0, r6
	bl	__aeabi_uidivmod
	adds	r1, r5, r1
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L658:
	.align	2
.L657:
	.word	.LANCHOR61
	.word	.LANCHOR66
	.size	P2V_plane, .-P2V_plane
	.section	.text.P2V_block_in_plane,"ax",%progbits
	.align	1
	.global	P2V_block_in_plane
	.thumb
	.thumb_func
	.type	P2V_block_in_plane, %function
P2V_block_in_plane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L660
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidivmod
	ldr	r3, .L660+4
	uxth	r0, r1
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L661:
	.align	2
.L660:
	.word	.LANCHOR66
	.word	.LANCHOR61
	.size	P2V_block_in_plane, .-P2V_block_in_plane
	.section	.text.ftl_cmp_data_ver,"ax",%progbits
	.align	1
	.global	ftl_cmp_data_ver
	.thumb
	.thumb_func
	.type	ftl_cmp_data_ver, %function
ftl_cmp_data_ver:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, r1
	bls	.L663
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L663:
	subs	r0, r1, r0
	cmp	r0, #-2147483648
	ite	ls
	movls	r0, #0
	movhi	r0, #1
	bx	lr
	.size	ftl_cmp_data_ver, .-ftl_cmp_data_ver
	.section	.text.FtlFreeSysBlkQueueInit,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueInit
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueInit, %function
FtlFreeSysBlkQueueInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L666
	mov	r2, #2048
	push	{r4, lr}
	movs	r4, #0
	mov	r1, r4
	strh	r4, [r3, #2]	@ movhi
	strh	r4, [r3, #4]	@ movhi
	strh	r4, [r3, #6]	@ movhi
	strh	r0, [r3], #8	@ movhi
	mov	r0, r3
	bl	memset
	mov	r0, r4
	pop	{r4, pc}
.L667:
	.align	2
.L666:
	.word	.LANCHOR93
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
	.section	.text.FtlFreeSysBlkQueueEmpty,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueEmpty
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueEmpty, %function
FtlFreeSysBlkQueueEmpty:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L669
	ldrh	r0, [r3, #6]
	rsbs	r0, r0, #1
	it	cc
	movcc	r0, #0
	bx	lr
.L670:
	.align	2
.L669:
	.word	.LANCHOR93
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueFull
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L672
	ldrh	r0, [r3, #6]
	sub	r2, r0, #1024
	rsbs	r0, r2, #0
	adc	r0, r0, r2
	bx	lr
.L673:
	.align	2
.L672:
	.word	.LANCHOR93
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
	.section	.text.FtlFreeSysBlkQueueIn,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueIn
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueIn, %function
FtlFreeSysBlkQueueIn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L677
	ldrh	r3, [r3, #6]
	cmp	r3, #1024
	beq	.L674
	cbz	r1, .L676
	ldr	r3, .L677+4
	ldr	r3, [r3, #0]
	cbnz	r3, .L676
	bl	P2V_block_in_plane
	ldr	r3, .L677+8
	movs	r1, #1
	mov	r2, r1
	mov	r5, r0
	ldr	r0, [r3, #0]
	lsls	r3, r4, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L677+12
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L677+16
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
.L676:
	ldr	r3, .L677
	ldrh	r2, [r3, #6]
	adds	r2, r2, #1
	strh	r2, [r3, #6]	@ movhi
	ldrh	r2, [r3, #4]
	adds	r1, r2, #4
	adds	r2, r2, #1
	bic	r2, r2, #64512
	strh	r2, [r3, #4]	@ movhi
	strh	r4, [r3, r1, lsl #1]	@ movhi
.L674:
	pop	{r3, r4, r5, pc}
.L678:
	.align	2
.L677:
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR97
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlFreeSysBLkSort,"ax",%progbits
	.align	1
	.global	FtlFreeSysBLkSort
	.thumb
	.thumb_func
	.type	FtlFreeSysBLkSort, %function
FtlFreeSysBLkSort:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	movs	r4, #0
	ldr	r5, .L689
	ldr	r7, .L689+4
	ldr	r6, .L689+8
	b	.L680
.L681:
	add	r8, r4, r8
	add	r8, r8, #4
	ldrh	r0, [r5, r8, lsl #1]
	bl	P2V_block_in_plane
	ldr	r2, [r6, #0]
	ldr	r3, [r7, #0]
	ldrh	r2, [r2, r0, lsl #1]
	str	r2, [r3, r4, lsl #2]
	adds	r4, r4, #1
	uxth	r4, r4
.L680:
	ldrh	ip, [r5, #6]
	ldrh	r8, [r5, #2]
	cmp	r4, ip
	bcc	.L681
	ldr	r3, .L689+4
	add	r6, ip, #-1
	ldr	r4, .L689
	ldr	r1, [r3, #0]
	movs	r3, #0
	b	.L682
.L687:
	adds	r5, r3, #1
	mov	r2, r3
	uxth	r5, r5
	mov	r0, r5
	b	.L683
.L685:
	ldr	r7, [r1, r0, lsl #2]
	ldr	sl, [r1, r2, lsl #2]
	cmp	sl, r7
	it	hi
	movhi	r2, r0
	adds	r0, r0, #1
	uxth	r0, r0
.L683:
	cmp	r0, ip
	bcc	.L685
	cmp	r3, r2
	beq	.L686
	ldr	r0, [r1, r2, lsl #2]
	ldr	r7, [r1, r3, lsl #2]
	str	r7, [r1, r2, lsl #2]
	add	r2, r8, r2
	str	r0, [r1, r3, lsl #2]
	add	r3, r8, r3
	adds	r2, r2, #4
	adds	r3, r3, #4
	ldrh	r0, [r4, r2, lsl #1]
	ldrh	r7, [r4, r3, lsl #1]
	strh	r7, [r4, r2, lsl #1]	@ movhi
	strh	r0, [r4, r3, lsl #1]	@ movhi
.L686:
	mov	r3, r5
.L682:
	cmp	r3, r6
	blt	.L687
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L690:
	.align	2
.L689:
	.word	.LANCHOR93
	.word	.LANCHOR98
	.word	.LANCHOR96
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.remove_from_free_sys_Queue,"ax",%progbits
	.align	1
	.global	remove_from_free_sys_Queue
	.thumb
	.thumb_func
	.type	remove_from_free_sys_Queue, %function
remove_from_free_sys_Queue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L697
	mov	r1, r0
	push	{r4, r5, r6, lr}
	ldrh	r0, [r3, #6]
	cbz	r0, .L692
	ldrh	r2, [r3, #2]
	movs	r5, #0
	b	.L693
.L695:
	adds	r6, r5, r2
	ldr	r4, .L697
	lsls	r6, r6, #22
	add	r6, r3, r6, lsr #21
	ldrh	r6, [r6, #8]
	cmp	r6, r1
	bne	.L694
	ldr	r0, .L697+4
	bl	printf
	ldrh	r3, [r4, #2]
	movs	r0, #1
	adds	r5, r5, r3
	adds	r2, r3, #4
	adds	r3, r3, #1
	lsls	r5, r5, #22
	ldrh	r2, [r4, r2, lsl #1]
	bic	r3, r3, #64512
	strh	r3, [r4, #2]	@ movhi
	add	r5, r4, r5, lsr #21
	ldrh	r3, [r4, #6]
	strh	r2, [r5, #8]	@ movhi
	subs	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	pop	{r4, r5, r6, pc}
.L694:
	adds	r5, r5, #1
.L693:
	cmp	r5, r0
	bcc	.L695
	movs	r0, #0
.L692:
	pop	{r4, r5, r6, pc}
.L698:
	.align	2
.L697:
	.word	.LANCHOR93
	.word	.LC12
	.size	remove_from_free_sys_Queue, .-remove_from_free_sys_Queue
	.section	.text.FtlFreeSysBlkQueueOut,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueOut
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L703
	ldrh	r1, [r3, #6]
	cmp	r1, #0
	beq	.L702
	ldrh	r2, [r3, #2]
	subs	r1, r1, #1
	strh	r1, [r3, #6]	@ movhi
	adds	r0, r2, #4
	adds	r2, r2, #1
	bic	r2, r2, #64512
	strh	r2, [r3, #2]	@ movhi
	ldrh	r4, [r3, r0, lsl #1]
	ldr	r3, .L703+4
	ldr	r7, [r3, #0]
	cbnz	r7, .L700
	mov	r0, r4
	ldr	r6, .L703+8
	bl	P2V_block_in_plane
	lsls	r3, r4, #10
	mov	r5, r0
	ldr	r0, [r6, #0]
	str	r3, [r0, #4]
	ldr	r3, .L703+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L701
	mov	r1, r7
	movs	r2, #1
	bl	FlashEraseBlocks
.L701:
	movs	r1, #1
	ldr	r0, [r6, #0]
	mov	r2, r1
	bl	FlashEraseBlocks
	ldr	r3, .L703+16
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L703+20
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	b	.L700
.L702:
	movw	r4, #65535
.L700:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L704:
	.align	2
.L703:
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR7
	.word	.LANCHOR96
	.word	.LANCHOR97
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.insert_data_list,"ax",%progbits
	.align	1
	.global	insert_data_list
	.thumb
	.thumb_func
	.type	insert_data_list, %function
insert_data_list:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L721
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	ldrh	fp, [r3, #0]
	cmp	r0, fp
	bcs	.L706
	ldr	r3, .L721+4
	movs	r6, #6
	muls	r6, r0, r6
	ldr	r1, [r3, #0]
	movw	r3, #65535
	adds	r2, r1, r6
	strh	r3, [r1, r6]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	ldr	r3, .L721+8
	ldr	r5, [r3, #0]
	cmp	r5, #0
	beq	.L720
.L707:
	ldr	r3, .L721+12
	ldrh	r4, [r2, #4]
	ldr	ip, [r3, #0]
	lsls	r3, r0, #1
	ldrh	r7, [ip, r0, lsl #1]
	cbz	r4, .L716
	muls	r4, r7, r4
	b	.L719
.L716:
	mov	r4, #-1
.L719:
	str	r4, [sp, #8]
	subs	r4, r5, r1
	ldr	r7, .L721+16
	mov	sl, r2
	asrs	r4, r4, #1
	muls	r4, r7, r4
	ldr	r7, .L721+20
	uxth	r4, r4
	str	ip, [sp, #4]
	ldr	r7, [r7, #0]
	adds	r3, r7, r3
	str	r3, [sp, #20]
	str	r7, [sp, #12]
	mov	r3, r5
	movs	r7, #0
.L714:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r7, fp
	bhi	.L706
	cmp	r0, r4
	beq	.L706
	ldr	r2, [sp, #4]
	lsl	r8, r4, #1
	str	r8, [sp, #16]
	ldrh	r8, [r2, r4, lsl #1]
	ldrh	r2, [r3, #4]
	cbz	r2, .L717
	mul	r2, r2, r8
	b	.L709
.L717:
	mov	r2, #-1
.L709:
	ldr	r8, [sp, #8]
	cmp	r2, r8
	bne	.L710
	ldr	r2, [sp, #12]
	ldr	ip, [sp, #16]
	ldrh	r8, [r2, ip]
	ldr	r2, [sp, #20]
	ldrh	ip, [r2, #0]
	cmp	r8, ip
	bcc	.L712
	b	.L718
.L710:
	bhi	.L718
.L712:
	ldrh	r2, [r3, #0]
	movw	r8, #65535
	cmp	r2, r8
	bne	.L713
	mov	r2, sl
	strh	r0, [r3, #0]	@ movhi
	ldr	r3, .L721+24
	strh	r4, [r2, #2]	@ movhi
	b	.L720
.L713:
	mov	ip, #6
	mov	r4, r2
	mla	r3, ip, r2, r1
	b	.L714
.L718:
	strh	r4, [r1, r6]	@ movhi
	mov	r2, sl
	ldrh	r4, [r3, #2]
	cmp	r3, r5
	strh	r4, [r2, #2]	@ movhi
	bne	.L715
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L721+8
.L720:
	str	r2, [r3, #0]
	b	.L706
.L715:
	ldrh	r2, [r3, #2]
	movs	r4, #6
	strh	r0, [r3, #2]	@ movhi
	muls	r2, r4, r2
	strh	r0, [r1, r2]	@ movhi
.L706:
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L722:
	.align	2
.L721:
	.word	.LANCHOR55
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	-1431655765
	.word	.LANCHOR96
	.word	.LANCHOR102
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",%progbits
	.align	1
	.global	INSERT_DATA_LIST
	.thumb
	.thumb_func
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	insert_data_list
	ldr	r2, .L725
	ldrh	r3, [r2, #0]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L725+4
	ldrh	r2, [r2, #0]
	cmp	r2, r3
	bcs	.L723
	ldr	r1, .L725+8
	movs	r2, #205
	ldr	r0, .L725+12
	bl	printf
	ldr	r0, .L725+16
	ldr	r1, .L725+20
	pop	{r3, lr}
	b	printf
.L723:
	pop	{r3, pc}
.L726:
	.align	2
.L725:
	.word	.LANCHOR103
	.word	.LANCHOR55
	.word	.LANCHOR104
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	INSERT_DATA_LIST, .-INSERT_DATA_LIST
	.section	.text.insert_free_list,"ax",%progbits
	.align	1
	.global	insert_free_list
	.thumb
	.thumb_func
	.type	insert_free_list, %function
insert_free_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movw	r8, #65535
	cmp	r0, r8
	beq	.L728
	ldr	r3, .L735
	mov	fp, #6
	mul	r6, fp, r0
	ldr	r2, [r3, #0]
	ldr	r3, .L735+4
	adds	r1, r2, r6
	ldr	r4, [r3, #0]
	strh	r8, [r1, #2]	@ movhi
	strh	r8, [r2, r6]	@ movhi
	cbz	r4, .L734
.L729:
	ldr	r3, .L735+8
	subs	r5, r4, r2
	asrs	r5, r5, #1
	ldr	ip, [r3, #0]
	ldr	r3, .L735+12
	muls	r5, r3, r5
	mov	r3, r4
	uxth	r5, r5
	ldrh	sl, [ip, r0, lsl #1]
.L732:
	ldrh	r7, [ip, r5, lsl #1]
	cmp	r7, sl
	bcs	.L730
	ldrh	r7, [r3, #0]
	cmp	r7, r8
	bne	.L731
	strh	r5, [r1, #2]	@ movhi
	strh	r0, [r3, #0]	@ movhi
	b	.L728
.L731:
	mla	r3, fp, r7, r2
	mov	r5, r7
	b	.L732
.L730:
	ldrh	r7, [r3, #2]
	cmp	r3, r4
	strh	r5, [r2, r6]	@ movhi
	strh	r7, [r1, #2]	@ movhi
	bne	.L733
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L735+4
.L734:
	str	r1, [r3, #0]
	b	.L728
.L733:
	ldrh	r1, [r3, #2]
	movs	r4, #6
	strh	r0, [r3, #2]	@ movhi
	muls	r1, r4, r1
	strh	r0, [r2, r1]	@ movhi
.L728:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L736:
	.align	2
.L735:
	.word	.LANCHOR99
	.word	.LANCHOR105
	.word	.LANCHOR96
	.word	-1431655765
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",%progbits
	.align	1
	.global	INSERT_FREE_LIST
	.thumb
	.thumb_func
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	insert_free_list
	ldr	r2, .L739
	ldrh	r3, [r2, #0]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L739+4
	ldrh	r2, [r2, #0]
	cmp	r2, r3
	bcs	.L737
	ldr	r1, .L739+8
	movs	r2, #198
	ldr	r0, .L739+12
	bl	printf
	ldr	r0, .L739+16
	ldr	r1, .L739+20
	pop	{r3, lr}
	b	printf
.L737:
	pop	{r3, pc}
.L740:
	.align	2
.L739:
	.word	.LANCHOR106
	.word	.LANCHOR55
	.word	.LANCHOR107
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	INSERT_FREE_LIST, .-INSERT_FREE_LIST
	.section	.text.List_remove_node,"ax",%progbits
	.align	1
	.global	List_remove_node
	.thumb
	.thumb_func
	.type	List_remove_node, %function
List_remove_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r6, #6
	muls	r6, r1, r6
	ldr	r3, .L747
	mov	r5, r0
	ldr	r7, [r3, #0]
	movw	r3, #65535
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L742
	ldr	r3, [r0, #0]
	cmp	r4, r3
	beq	.L742
	ldr	r1, .L747+4
	movw	r2, #363
	ldr	r0, .L747+8
	bl	printf
	ldr	r0, .L747+12
	ldr	r1, .L747+16
	bl	printf
.L742:
	ldr	r3, [r5, #0]
	movw	r2, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L743
	cmp	r3, r2
	bne	.L744
	movs	r3, #0
	str	r3, [r5, #0]
	b	.L745
.L744:
	ldr	r1, .L747
	movs	r0, #6
	ldr	r1, [r1, #0]
	mla	r3, r0, r3, r1
	str	r3, [r5, #0]
	strh	r2, [r3, #2]	@ movhi
	b	.L745
.L743:
	cmp	r3, r2
	ldrh	r2, [r4, #2]
	bne	.L746
	cmp	r2, r3
	beq	.L745
	ldr	r1, .L747
	movs	r0, #6
	muls	r2, r0, r2
	ldr	r1, [r1, #0]
	strh	r3, [r1, r2]	@ movhi
	b	.L745
.L746:
	ldr	r1, .L747
	movs	r0, #6
	ldr	r1, [r1, #0]
	mla	r5, r0, r3, r1
	strh	r2, [r5, #2]	@ movhi
	ldrh	r2, [r4, #2]
	muls	r0, r2, r0
	strh	r3, [r1, r0]	@ movhi
.L745:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L748:
	.align	2
.L747:
	.word	.LANCHOR99
	.word	.LANCHOR108
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",%progbits
	.align	1
	.global	List_pop_index_node
	.thumb
	.thumb_func
	.type	List_pop_index_node, %function
List_pop_index_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #0]
	push	{r4, r5, r6, lr}
	cbz	r3, .L754
	ldr	r2, .L755
	movw	r6, #65535
	movs	r5, #6
	ldr	r4, [r2, #0]
	b	.L751
.L753:
	mla	r3, r5, r2, r4
	subs	r1, r1, #1
	uxth	r1, r1
.L751:
	cbz	r1, .L752
	ldrh	r2, [r3, #0]
	cmp	r2, r6
	bne	.L753
.L752:
	subs	r4, r3, r4
	ldr	r3, .L755+4
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
	mov	r1, r4
	bl	List_remove_node
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L754:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L756:
	.align	2
.L755:
	.word	.LANCHOR99
	.word	-1431655765
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_get_gc_head_node,"ax",%progbits
	.align	1
	.global	List_get_gc_head_node
	.thumb
	.thumb_func
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L763
	push	{r4, lr}
	ldr	r3, [r3, #0]
	cbz	r3, .L762
	ldr	r2, .L763+4
	movw	r1, #65535
	movs	r4, #6
	ldr	r2, [r2, #0]
	b	.L759
.L761:
	mla	r3, r4, r3, r2
	subs	r0, r0, #1
	uxth	r0, r0
.L759:
	cbz	r0, .L760
	ldrh	r3, [r3, #0]
	cmp	r3, r1
	bne	.L761
	mov	r0, r1
	pop	{r4, pc}
.L760:
	subs	r3, r3, r2
	ldr	r0, .L763+8
	asrs	r3, r3, #1
	muls	r0, r3, r0
	uxth	r0, r0
	pop	{r4, pc}
.L762:
	movw	r0, #65535
	pop	{r4, pc}
.L764:
	.align	2
.L763:
	.word	.LANCHOR100
	.word	.LANCHOR99
	.word	-1431655765
	.size	List_get_gc_head_node, .-List_get_gc_head_node
	.section	.text.List_update_data_list,"ax",%progbits
	.align	1
	.global	List_update_data_list
	.thumb
	.thumb_func
	.type	List_update_data_list, %function
List_update_data_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L774
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L766
	ldr	r3, .L774+4
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L766
	ldr	r3, .L774+8
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L766
	ldr	r3, .L774+12
	movs	r7, #6
	muls	r7, r0, r7
	ldr	r8, [r3, #0]
	ldr	r3, .L774+16
	add	r5, r8, r7
	ldr	r3, [r3, #0]
	cmp	r5, r3
	beq	.L766
	ldr	r3, .L774+20
	movw	r2, #65535
	ldrh	r6, [r5, #4]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	muls	r6, r3, r6
	ldrh	r3, [r5, #2]
	it	eq
	moveq	r6, #-1
	cmp	r3, r2
	bne	.L768
	ldrh	r2, [r8, r7]
	cmp	r2, r3
	bne	.L768
	ldr	r1, .L774+24
	movw	r2, #481
	ldr	r0, .L774+28
	bl	printf
	ldr	r0, .L774+32
	ldr	r1, .L774+36
	bl	printf
.L768:
	ldrh	r3, [r5, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L769
	ldrh	r2, [r8, r7]
	cmp	r2, r3
	beq	.L766
.L769:
	ldr	r2, .L774+12
	movs	r1, #6
	ldr	r2, [r2, #0]
	mla	r3, r1, r3, r2
	ldr	r1, .L774+40
	subs	r2, r3, r2
	asrs	r2, r2, #1
	muls	r2, r1, r2
	ldr	r1, .L774+20
	uxth	r2, r2
	ldrh	r3, [r3, #4]
	ldr	r1, [r1, #0]
	ldrh	r2, [r1, r2, lsl #1]
	muls	r3, r2, r3
	it	eq
	moveq	r3, #-1
	cmp	r6, r3
	bcs	.L766
	ldr	r5, .L774+44
	mov	r1, r4
	ldr	r0, .L774+16
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L771
	ldr	r1, .L774+24
	mov	r2, #492
	ldr	r0, .L774+28
	bl	printf
	ldr	r0, .L774+32
	ldr	r1, .L774+36
	bl	printf
.L771:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	INSERT_DATA_LIST
.L766:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L775:
	.align	2
.L774:
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR112
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	-1431655765
	.word	.LANCHOR103
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.ftl_free_no_use_map_blk,"ax",%progbits
	.align	1
	.global	ftl_free_no_use_map_blk
	.thumb
	.thumb_func
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0, #10]
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r5, [r0, #20]
	lsls	r2, r2, #1
	ldr	r6, [r0, #12]
	movs	r1, #0
	ldr	r7, [r0, #24]
	mov	r0, r5
	bl	memset
	movs	r2, #0
	b	.L777
.L781:
	ldr	r1, [r7, r2, lsl #2]
	movs	r3, #0
	ubfx	r1, r1, #10, #16
	b	.L778
.L780:
	ldrh	r0, [r6, r3, lsl #1]
	cmp	r0, r1
	bne	.L779
	ldrh	r0, [r5, r3, lsl #1]
	adds	r0, r0, #1
	strh	r0, [r5, r3, lsl #1]	@ movhi
.L779:
	adds	r3, r3, #1
	uxth	r3, r3
.L778:
	ldrh	r0, [r4, #10]
	cmp	r0, r3
	bhi	.L780
	adds	r2, r2, #1
	uxth	r2, r2
.L777:
	ldrh	r3, [r4, #6]
	cmp	r3, r2
	bhi	.L781
	mov	sl, #0
	ldrh	r3, [r5, #0]
	mov	r7, sl
	ldr	r2, .L787
	b	.L782
.L786:
	ldrh	r1, [r4, #0]
	cmp	r1, r7
	bne	.L783
	ldrh	r1, [r2, #0]
	ldrh	r0, [r4, #2]
	cmp	r0, r1
	it	cc
	strhcc	r1, [r5, r7, lsl #1]	@ movhi
.L783:
	ldrh	r8, [r5, r7, lsl #1]
	lsl	fp, r7, #1
	cmp	r3, r8
	itt	hi
	movhi	sl, r7
	movhi	r3, r8
	cmp	r8, #0
	bne	.L785
	ldrh	r0, [r6, fp]
	cbz	r0, .L785
	movs	r1, #1
	stmia	sp, {r2, r3}
	bl	FtlFreeSysBlkQueueIn
	ldmia	sp, {r2, r3}
	strh	r8, [r6, fp]	@ movhi
	ldrh	r1, [r4, #8]
	subs	r1, r1, #1
	strh	r1, [r4, #8]	@ movhi
.L785:
	adds	r7, r7, #1
	uxth	r7, r7
.L782:
	ldrh	r1, [r4, #10]
	cmp	r1, r7
	bhi	.L786
	mov	r0, sl
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L788:
	.align	2
.L787:
	.word	.LANCHOR69
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",%progbits
	.align	1
	.global	ftl_map_blk_alloc_new_blk
	.thumb
	.thumb_func
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldrh	r2, [r0, #10]
	movs	r5, #0
	ldr	r3, [r0, #12]
	b	.L790
.L793:
	mov	r7, r3
	adds	r3, r3, #2
	ldrh	r6, [r7, #0]
	cbnz	r6, .L791
	bl	FtlFreeSysBlkQueueOut
	strh	r0, [r7, #0]	@ movhi
	cbz	r0, .L792
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	strh	r5, [r4, #0]	@ movhi
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L792
.L791:
	adds	r5, r5, #1
	uxth	r5, r5
.L790:
	cmp	r5, r2
	bne	.L793
.L792:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L794
	ldr	r1, .L795
	movw	r2, #594
	ldr	r0, .L795+4
	bl	printf
	ldr	r0, .L795+8
	ldr	r1, .L795+12
	bl	printf
.L794:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L796:
	.align	2
.L795:
	.word	.LANCHOR113
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",%progbits
	.align	1
	.global	select_l2p_ram_region
	.thumb
	.thumb_func
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L809
	movw	r1, #65535
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L809+4
	ldr	r0, [r2, #0]
	movs	r2, #0
	mov	r4, r2
	ldrh	r3, [r3, #0]
	b	.L798
.L800:
	adds	r2, r2, #12
	adds	r5, r0, r2
	ldrh	r5, [r5, #-12]
	cmp	r5, r1
	beq	.L799
	adds	r4, r4, #1
	uxth	r4, r4
.L798:
	cmp	r4, r3
	bne	.L800
	movs	r1, #0
	mov	r4, r3
	mov	r6, #-2147483648
	mov	r2, r1
	b	.L801
.L803:
	adds	r5, r0, r1
	ldr	r5, [r5, #4]
	cmp	r5, #0
	blt	.L802
	cmp	r5, r6
	itt	cc
	movcc	r6, r5
	movcc	r4, r2
.L802:
	adds	r2, r2, #1
	adds	r1, r1, #12
	uxth	r2, r2
.L801:
	cmp	r2, r3
	bne	.L803
	cmp	r4, r3
	bcc	.L799
	ldr	r2, .L809+8
	movs	r1, #0
	mov	r4, r3
	mov	r5, #-1
	ldrh	r7, [r2, #0]
	mov	r2, r1
	b	.L804
.L806:
	adds	r6, r0, r1
	ldr	r6, [r6, #4]
	cmp	r6, r5
	bcs	.L805
	ldrh	ip, [r0, r1]
	cmp	ip, r7
	it	ne
	movne	r5, r6
	it	ne
	movne	r4, r2
.L805:
	adds	r2, r2, #1
	adds	r1, r1, #12
	uxth	r2, r2
.L804:
	cmp	r2, r3
	bne	.L806
	cmp	r4, r2
	bcc	.L799
	ldr	r1, .L809+12
	movw	r2, #826
	ldr	r0, .L809+16
	bl	printf
	ldr	r0, .L809+20
	ldr	r1, .L809+24
	bl	printf
.L799:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L810:
	.align	2
.L809:
	.word	.LANCHOR114
	.word	.LANCHOR83
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",%progbits
	.align	1
	.global	FtlUpdateVaildLpn
	.thumb
	.thumb_func
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L817
	push	{r4, r5, lr}
	ldrh	r2, [r3, #0]
	adds	r1, r2, #1
	cmp	r2, #4
	strh	r1, [r3, #0]	@ movhi
	mov	r2, r3
	bhi	.L812
	cbz	r0, .L811
.L812:
	movs	r3, #0
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L817+4
	movw	r4, #65535
	ldrh	r5, [r2, #0]
	ldr	r2, .L817+8
	ldr	r1, [r2, #0]
	mov	r2, r3
	b	.L814
.L816:
	ldrh	r0, [r1], #2
	cmp	r0, r4
	it	ne
	addne	r3, r3, r0
	adds	r2, r2, #1
	uxth	r2, r2
.L814:
	cmp	r2, r5
	bne	.L816
	ldr	r2, .L817+12
	str	r3, [r2, #0]
.L811:
	pop	{r4, r5, pc}
.L818:
	.align	2
.L817:
	.word	.LANCHOR117
	.word	.LANCHOR55
	.word	.LANCHOR101
	.word	.LANCHOR118
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",%progbits
	.align	1
	.global	ftl_set_blk_mode
	.thumb
	.thumb_func
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L823
	lsrs	r2, r0, #5
	and	r0, r0, #31
	uxth	r2, r2
	ldr	r3, [r3, #0]
	cbz	r1, .L820
	movs	r1, #1
	lsl	r0, r1, r0
	ldr	r1, [r3, r2, lsl #2]
	orrs	r0, r0, r1
	b	.L822
.L820:
	movs	r1, #1
	lsl	r0, r1, r0
	ldr	r1, [r3, r2, lsl #2]
	bic	r0, r1, r0
.L822:
	str	r0, [r3, r2, lsl #2]
	bx	lr
.L824:
	.align	2
.L823:
	.word	.LANCHOR119
	.size	ftl_set_blk_mode, .-ftl_set_blk_mode
	.section	.text.ftl_get_blk_mode,"ax",%progbits
	.align	1
	.global	ftl_get_blk_mode
	.thumb
	.thumb_func
	.type	ftl_get_blk_mode, %function
ftl_get_blk_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L826
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3, #0]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L827:
	.align	2
.L826:
	.word	.LANCHOR119
	.size	ftl_get_blk_mode, .-ftl_get_blk_mode
	.section	.text.FtlL2PDataInit,"ax",%progbits
	.align	1
	.global	FtlL2PDataInit
	.thumb
	.thumb_func
	.type	FtlL2PDataInit, %function
FtlL2PDataInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L831
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, lr}
	ldr	r2, [r3, #0]
	ldr	r3, .L831+4
	ldr	r5, .L831+8
	ldr	r4, .L831+12
	lsls	r2, r2, #1
	ldr	r6, .L831+16
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r3, [r4, #0]
	ldrh	r2, [r6, #0]
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r0, [r5, #0]
	bl	memset
	ldr	r3, .L831+20
	ldrh	r7, [r6, #0]
	ldr	ip, [r5, #0]
	movw	r5, #65535
	ldr	r2, [r3, #0]
	movs	r3, #0
	ldrh	r6, [r4, #0]
	mov	r0, r3
	mov	r4, r3
	b	.L829
.L830:
	adds	r0, r0, #1
	bic	r3, r3, #3
	add	r3, ip, r3
	str	r3, [r2, #-4]
	uxth	r0, r0
	mov	r3, r8
	str	r4, [r2, #-8]
	strh	r5, [r2, #-12]	@ movhi
.L829:
	adds	r2, r2, #12
	cmp	r0, r7
	add	r8, r3, r6
	movw	r1, #65535
	bne	.L830
	ldr	r2, .L831
	ldr	r3, .L831+24
	ldr	r2, [r2, #0]
	strh	r1, [r3, #2]	@ movhi
	strh	r1, [r3, #0]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L831+28
	strh	r1, [r3, #40]	@ movhi
	ldrh	r2, [r2, #0]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L831+32
	ldrh	r2, [r2, #0]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L831+36
	ldr	r2, [r2, #0]
	str	r2, [r3, #12]
	ldr	r2, .L831+40
	ldr	r2, [r2, #0]
	str	r2, [r3, #16]
	ldr	r2, .L831+4
	ldr	r2, [r2, #0]
	str	r2, [r3, #20]
	ldr	r2, .L831+44
	ldr	r2, [r2, #0]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L832:
	.align	2
.L831:
	.word	.LANCHOR80
	.word	.LANCHOR120
	.word	.LANCHOR121
	.word	.LANCHOR73
	.word	.LANCHOR83
	.word	.LANCHOR114
	.word	.LANCHOR122
	.word	.LANCHOR123
	.word	.LANCHOR82
	.word	.LANCHOR124
	.word	.LANCHOR125
	.word	.LANCHOR126
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.ftl_sb_update_avl_pages,"ax",%progbits
	.align	1
	.global	ftl_sb_update_avl_pages
	.thumb
	.thumb_func
	.type	ftl_sb_update_avl_pages, %function
ftl_sb_update_avl_pages:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L840
	push	{r4, r5, r6, r7, lr}
	movw	r4, #65535
	ldrh	r3, [r3, #0]
	b	.L834
.L836:
	add	r5, r2, #8
	ldrh	r5, [r0, r5, lsl #1]
	cmp	r5, r4
	beq	.L835
	ldrh	r5, [r0, #4]
	adds	r5, r5, #1
	strh	r5, [r0, #4]	@ movhi
.L835:
	adds	r2, r2, #1
	uxth	r2, r2
.L834:
	cmp	r2, r3
	bcc	.L836
	ldr	r2, .L840+4
	mov	r4, r0
	movw	r5, #65535
	mvns	r1, r1
	ldrh	r6, [r2, #0]
	movs	r2, #0
	b	.L837
.L839:
	ldrh	r7, [r4, #16]
	cmp	r7, r5
	beq	.L838
	ldrh	r7, [r0, #4]
	adds	r7, r6, r7
	adds	r7, r7, r1
	strh	r7, [r0, #4]	@ movhi
.L838:
	adds	r2, r2, #1
	adds	r4, r4, #2
	uxth	r2, r2
.L837:
	cmp	r2, r3
	bne	.L839
	pop	{r4, r5, r6, r7, pc}
.L841:
	.align	2
.L840:
	.word	.LANCHOR53
	.word	.LANCHOR68
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.make_superblock,"ax",%progbits
	.align	1
	.global	make_superblock
	.thumb
	.thumb_func
	.type	make_superblock, %function
make_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L849
	ldrh	r2, [r0, #0]
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L843
	ldr	r1, .L849+4
	movw	r2, #2296
	ldr	r0, .L849+8
	bl	printf
	ldr	r0, .L849+12
	ldr	r1, .L849+16
	bl	printf
.L843:
	movs	r5, #0
	ldr	r8, .L849+40
	strh	r5, [r4, #4]	@ movhi
	movw	r6, #65535
	strb	r5, [r4, #7]
	ldr	r7, .L849+20
	b	.L844
.L846:
	ldrb	r0, [r7, r5]	@ zero_extendqisi2
	add	sl, r5, #8
	ldrh	r1, [r4, #0]
	bl	V2P_block
	strh	r6, [r4, sl, lsl #1]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L845
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	strh	fp, [r4, sl, lsl #1]	@ movhi
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L845:
	adds	r5, r5, #1
	uxth	r5, r5
.L844:
	ldrh	r3, [r8, #0]
	cmp	r3, r5
	bhi	.L846
	ldr	r2, .L849+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L849+28
	ldr	r3, [r3, #0]
	cbz	r3, .L847
	ldr	r3, .L849+32
	ldrh	r2, [r4, #0]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #59
	bhi	.L847
	movs	r3, #1
	strb	r3, [r4, #9]
.L847:
	ldr	r3, .L849+36
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L848
	movs	r3, #1
	strb	r3, [r4, #9]
.L848:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L850:
	.align	2
.L849:
	.word	.LANCHOR55
	.word	.LANCHOR127
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR62
	.word	.LANCHOR68
	.word	.LANCHOR128
	.word	.LANCHOR96
	.word	.LANCHOR0
	.word	.LANCHOR53
	.size	make_superblock, .-make_superblock
	.section	.text.SupperBlkListInit,"ax",%progbits
	.align	1
	.global	SupperBlkListInit
	.thumb
	.thumb_func
	.type	SupperBlkListInit, %function
SupperBlkListInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L862
	ldr	r3, .L862+4
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r1, #0
	ldrh	r3, [r3, #0]
	movs	r5, #0
	ldr	r0, [r2, #0]
	movs	r2, #6
	muls	r2, r3, r2
	mov	r4, r5
	bl	memset
	ldr	r3, .L862+8
	mov	r8, r5
	mov	sl, r5
	str	r5, [r3, #0]
	ldr	r3, .L862+12
	str	r5, [r3, #0]
	ldr	r3, .L862+16
	str	r5, [r3, #0]
	ldr	r3, .L862+20
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L862+24
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L862+28
	strh	r5, [r3, #0]	@ movhi
	b	.L852
.L854:
	ldr	r2, .L862+32
	mov	r1, r4
	ldrb	r0, [r2, r7]	@ zero_extendqisi2
	str	ip, [sp, #4]
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	ip, [sp, #4]
	cbnz	r0, .L853
	ldrh	r2, [fp, #0]
	adds	r6, r6, r2
	uxth	r6, r6
.L853:
	adds	r7, r7, #1
	b	.L859
.L861:
	movs	r7, #0
	uxth	r3, r4
	ldr	fp, .L862+76
	mov	ip, r4
	mov	r6, r7
	mov	r4, r3
.L859:
	ldr	r3, .L862+36
	ldrh	r2, [r3, #0]
	cmp	r7, r2
	blt	.L854
	mov	r4, ip
	cbz	r6, .L855
	sxth	r1, r6
	mov	r0, #32768
	bl	__aeabi_idiv
	uxth	r6, r0
	b	.L856
.L855:
	ldr	r3, .L862+40
	movw	r2, #65535
	ldr	r3, [r3, #0]
	strh	r2, [r3, ip, lsl #1]	@ movhi
.L856:
	ldr	r3, .L862
	ldr	r3, [r3, #0]
	adds	r3, r3, r5
	strh	r6, [r3, #4]	@ movhi
	ldr	r3, .L862+44
	ldrh	r3, [r3, #0]
	cmp	r4, r3
	beq	.L857
	ldr	r3, .L862+48
	ldrh	r3, [r3, #0]
	cmp	r4, r3
	beq	.L857
	ldr	r3, .L862+52
	ldrh	r3, [r3, #0]
	cmp	r4, r3
	beq	.L857
	ldr	r3, .L862+40
	uxth	r0, r4
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L858
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
	b	.L857
.L858:
	add	sl, sl, #1
	uxth	sl, sl
	bl	INSERT_DATA_LIST
.L857:
	adds	r4, r4, #1
	adds	r5, r5, #6
.L852:
	ldr	r2, .L862+56
	ldrh	r3, [r2, #0]
	cmp	r4, r3
	blt	.L861
	ldr	r2, .L862+20
	strh	sl, [r2, #0]	@ movhi
	ldr	r2, .L862+24
	strh	r8, [r2, #0]	@ movhi
	add	r8, sl, r8
	cmp	r8, r3
	ble	.L860
	ldr	r1, .L862+60
	movw	r2, #2366
	ldr	r0, .L862+64
	bl	printf
	ldr	r0, .L862+68
	ldr	r1, .L862+72
	bl	printf
.L860:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L863:
	.align	2
.L862:
	.word	.LANCHOR99
	.word	.LANCHOR56
	.word	.LANCHOR105
	.word	.LANCHOR100
	.word	.LANCHOR102
	.word	.LANCHOR103
	.word	.LANCHOR106
	.word	.LANCHOR129
	.word	.LANCHOR62
	.word	.LANCHOR53
	.word	.LANCHOR101
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR55
	.word	.LANCHOR130
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR68
	.size	SupperBlkListInit, .-SupperBlkListInit
	.section	.text.update_multiplier_value,"ax",%progbits
	.align	1
	.global	update_multiplier_value
	.thumb
	.thumb_func
	.type	update_multiplier_value, %function
update_multiplier_value:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	movs	r4, #0
	mov	r6, r0
	mov	r5, r4
	ldr	sl, .L869+8
	ldr	r8, .L869+12
	ldr	r7, .L869
	b	.L865
.L867:
	mov	r1, r6
	ldrb	r0, [r8, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L866
	ldrh	r3, [r7, #0]
	adds	r4, r4, r3
	uxth	r4, r4
.L866:
	adds	r5, r5, #1
	uxth	r5, r5
.L865:
	ldrh	r3, [sl, #0]
	cmp	r3, r5
	bhi	.L867
	cbz	r4, .L868
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
	uxth	r4, r0
.L868:
	ldr	r3, .L869+4
	movs	r2, #6
	movs	r0, #0
	ldr	r3, [r3, #0]
	mla	r6, r2, r6, r3
	strh	r4, [r6, #4]	@ movhi
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L870:
	.align	2
.L869:
	.word	.LANCHOR68
	.word	.LANCHOR99
	.word	.LANCHOR53
	.word	.LANCHOR62
	.size	update_multiplier_value, .-update_multiplier_value
	.section	.text.GetFreeBlockMinEraseCount,"ax",%progbits
	.align	1
	.global	GetFreeBlockMinEraseCount
	.thumb
	.thumb_func
	.type	GetFreeBlockMinEraseCount, %function
GetFreeBlockMinEraseCount:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L874
	ldr	r0, [r3, #0]
	cbz	r0, .L872
	ldr	r3, .L874+4
	ldr	r3, [r3, #0]
	subs	r0, r0, r3
	ldr	r3, .L874+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L874+12
	uxth	r0, r0
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r0, lsl #1]
.L872:
	bx	lr
.L875:
	.align	2
.L874:
	.word	.LANCHOR105
	.word	.LANCHOR99
	.word	-1431655765
	.word	.LANCHOR96
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",%progbits
	.align	1
	.global	GetFreeBlockMaxEraseCount
	.thumb
	.thumb_func
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L883
	push	{r4, r5, r6, lr}
	ldr	r3, [r3, #0]
	cbz	r3, .L882
	ldr	r2, .L883+4
	movs	r1, #7
	movw	r5, #65535
	ldrh	r2, [r2, #0]
	muls	r2, r1, r2
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L883+8
	movs	r6, #6
	ldr	r1, [r2, #0]
	ldr	r2, .L883+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
	b	.L879
.L881:
	mul	r4, r6, r3
	ldrh	r4, [r1, r4]
	cmp	r4, r5
	beq	.L880
	adds	r2, r2, #1
	mov	r3, r4
	uxth	r2, r2
.L879:
	cmp	r2, r0
	bne	.L881
.L880:
	ldr	r2, .L883+16
	ldr	r2, [r2, #0]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L882:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L884:
	.align	2
.L883:
	.word	.LANCHOR105
	.word	.LANCHOR106
	.word	.LANCHOR99
	.word	-1431655765
	.word	.LANCHOR96
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.free_data_superblock,"ax",%progbits
	.align	1
	.global	free_data_superblock
	.thumb
	.thumb_func
	.type	free_data_superblock, %function
free_data_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r2, #65535
	cmp	r0, r2
	push	{r3, lr}
	beq	.L886
	ldr	r2, .L887
	movs	r1, #0
	ldr	r2, [r2, #0]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L886:
	movs	r0, #0
	pop	{r3, pc}
.L888:
	.align	2
.L887:
	.word	.LANCHOR101
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.FtlGcBufInit,"ax",%progbits
	.align	1
	.global	FtlGcBufInit
	.thumb
	.thumb_func
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L894
	movs	r2, #0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r2
	str	r2, [r3, #0]
	ldr	r3, .L894+4
	ldrh	ip, [r3, #0]
	ldr	r3, .L894+8
	ldr	r7, [r3, #0]
	ldr	r3, .L894+12
	ldr	r6, [r3, #0]
	ldr	r3, .L894+16
	ldr	r1, [r3, #0]
	ldr	r3, .L894+20
	ldrh	r5, [r3, #0]
	ldr	r3, .L894+24
	str	r5, [sp, #4]
	ldrh	fp, [r3, #0]
	ldr	r3, .L894+28
	ldr	r0, [r3, #0]
	mov	r3, r2
	b	.L890
.L891:
	movs	r5, #1
	bic	r4, r4, #3
	adds	r3, r3, r5
	bic	r2, r2, #3
	adds	r4, r7, r4
	adds	r2, r6, r2
	str	r4, [r1, #-12]
	uxth	r3, r3
	str	r2, [r1, #-8]
	str	r5, [r1, #-4]
	str	r4, [r0, #-28]
	mov	r4, r8
	str	r2, [r0, #-24]
	mov	r2, sl
.L890:
	adds	r1, r1, #12
	ldr	r5, [sp, #4]
	adds	r0, r0, #36
	cmp	r3, ip
	add	r8, r4, r5
	add	sl, r2, fp
	bne	.L891
	ldr	r1, .L894+8
	movs	r4, #12
	ldr	r2, .L894+32
	mov	fp, #0
	ldr	ip, [r1, #0]
	ldr	r1, .L894+20
	ldr	r8, [r2, #0]
	ldr	r2, .L894+16
	ldrh	r7, [r1, #0]
	ldr	r1, .L894+12
	ldr	r2, [r2, #0]
	ldr	r6, [r1, #0]
	ldr	r1, .L894+24
	ldrh	r5, [r1, #0]
	b	.L892
.L893:
	mul	r1, r4, r3
	mul	r0, r7, r3
	add	sl, r2, r1
	bic	r0, r0, #3
	str	fp, [sl, #8]
	add	r0, ip, r0
	str	r0, [r2, r1]
	mul	r1, r5, r3
	adds	r3, r3, #1
	uxth	r3, r3
	bic	r1, r1, #3
	adds	r1, r6, r1
	str	r1, [sl, #4]
.L892:
	cmp	r3, r8
	bcc	.L893
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L895:
	.align	2
.L894:
	.word	.LANCHOR131
	.word	.LANCHOR53
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR134
	.word	.LANCHOR73
	.word	.LANCHOR74
	.word	.LANCHOR135
	.word	.LANCHOR136
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlVariablesInit,"ax",%progbits
	.align	1
	.global	FtlVariablesInit
	.thumb
	.thumb_func
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r3, .L897
	movw	r2, #65535
	ldr	r5, .L897+4
	mov	r1, r4
	str	r4, [r3, #0]
	ldr	r3, .L897+8
	strh	r2, [r3, #0]	@ movhi
	mov	r2, #-1
	ldr	r3, .L897+12
	str	r4, [r3, #0]
	ldr	r3, .L897+16
	str	r4, [r3, #0]
	ldr	r3, .L897+20
	str	r2, [r3, #0]
	ldr	r3, .L897+24
	str	r4, [r3, #0]
	ldr	r3, .L897+28
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L897+32
	ldrh	r2, [r3, #0]
	ldr	r3, .L897+36
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r2, [r5, #0]
	ldr	r3, .L897+40
	mov	r1, r4
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r3, .L897+44
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L897+48
	bl	memset
	mov	r1, r4
	mov	r2, #512
	ldr	r0, .L897+52
	bl	memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L898:
	.align	2
.L897:
	.word	.LANCHOR137
	.word	.LANCHOR56
	.word	.LANCHOR138
	.word	.LANCHOR139
	.word	.LANCHOR140
	.word	.LANCHOR141
	.word	.LANCHOR128
	.word	.LANCHOR86
	.word	.LANCHOR77
	.word	.LANCHOR87
	.word	.LANCHOR96
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR144
	.size	FtlVariablesInit, .-FtlVariablesInit
	.section	.text.FtlGcBufFree,"ax",%progbits
	.align	1
	.global	FtlGcBufFree
	.thumb
	.thumb_func
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L906
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r5, #36
	ldr	r6, [r3, #0]
	ldr	r3, .L906+4
	ldr	r4, [r3, #0]
	movs	r3, #0
	mov	fp, r3
	b	.L900
.L903:
	mov	ip, #12
	mul	r3, ip, r2
	add	sl, r4, r3
	ldr	ip, [r4, r3]
	ldr	r3, [r7, #8]
	cmp	ip, r3
	bne	.L901
	mov	r3, r8
	str	fp, [sl, #8]
	b	.L902
.L901:
	adds	r2, r2, #1
	uxth	r2, r2
.L905:
	cmp	r2, r6
	bcc	.L903
	mov	r3, r8
.L902:
	adds	r3, r3, #1
	uxth	r3, r3
.L900:
	cmp	r3, r1
	bcs	.L899
	mla	r7, r5, r3, r0
	movs	r2, #0
	mov	r8, r3
	b	.L905
.L899:
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L907:
	.align	2
.L906:
	.word	.LANCHOR136
	.word	.LANCHOR134
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",%progbits
	.align	1
	.global	FtlGcBufAlloc
	.thumb
	.thumb_func
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L915
	push	{r4, r5, r6, r7, r8, sl, lr}
	movs	r7, #12
	ldr	r8, [r3, #0]
	movs	r6, #1
	ldr	r3, .L915+4
	movs	r5, #36
	ldr	ip, [r3, #0]
	movs	r3, #0
	b	.L909
.L912:
	mla	r4, r7, r2, ip
	ldr	sl, [r4, #8]
	cmp	sl, #0
	bne	.L910
	mla	r2, r5, r3, r0
	str	r6, [r4, #8]
	ldr	sl, [r4, #0]
	ldr	r4, [r4, #4]
	str	sl, [r2, #8]
	str	r4, [r2, #12]
	b	.L911
.L910:
	adds	r2, r2, #1
	uxth	r2, r2
	b	.L913
.L914:
	movs	r2, #0
.L913:
	cmp	r2, r8
	bcc	.L912
.L911:
	adds	r3, r3, #1
	uxth	r3, r3
.L909:
	cmp	r3, r1
	bcc	.L914
	pop	{r4, r5, r6, r7, r8, sl, pc}
.L916:
	.align	2
.L915:
	.word	.LANCHOR136
	.word	.LANCHOR134
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",%progbits
	.align	1
	.global	IsBlkInGcList
	.thumb
	.thumb_func
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L922
	push	{r4, lr}
	ldrh	r1, [r3, #0]
	ldr	r3, .L922+4
	ldr	r2, [r3, #0]
	movs	r3, #0
	b	.L918
.L920:
	ldrh	r4, [r2], #2
	cmp	r4, r0
	beq	.L921
	adds	r3, r3, #1
	uxth	r3, r3
.L918:
	cmp	r3, r1
	bne	.L920
	movs	r0, #0
	pop	{r4, pc}
.L921:
	movs	r0, #1
	pop	{r4, pc}
.L923:
	.align	2
.L922:
	.word	.LANCHOR145
	.word	.LANCHOR146
	.size	IsBlkInGcList, .-IsBlkInGcList
	.section	.text.FtlGcUpdatePage,"ax",%progbits
	.align	1
	.global	FtlGcUpdatePage
	.thumb
	.thumb_func
	.type	FtlGcUpdatePage, %function
FtlGcUpdatePage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ubfx	r0, r0, #10, #16
	mov	r5, r1
	mov	r6, r2
	bl	P2V_block_in_plane
	ldr	r3, .L928
	ldrh	r7, [r3, #0]
	ldr	r3, .L928+4
	ldr	r2, [r3, #0]
	movs	r3, #0
	mov	r1, r2
	b	.L925
.L927:
	ldrh	ip, [r1], #2
	cmp	ip, r0
	beq	.L926
	adds	r3, r3, #1
	uxth	r3, r3
.L925:
	cmp	r3, r7
	bne	.L927
	strh	r0, [r2, r3, lsl #1]	@ movhi
	ldr	r3, .L928
	ldrh	r2, [r3, #0]
	adds	r2, r2, #1
	strh	r2, [r3, #0]	@ movhi
.L926:
	ldr	r0, .L928+8
	movs	r1, #12
	ldr	r3, .L928+12
	ldr	r0, [r0, #0]
	ldrh	r2, [r3, #0]
	muls	r1, r2, r1
	adds	r7, r0, r1
	str	r4, [r0, r1]
	adds	r2, r2, #1
	str	r5, [r7, #4]
	str	r6, [r7, #8]
	strh	r2, [r3, #0]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L929:
	.align	2
.L928:
	.word	.LANCHOR145
	.word	.LANCHOR146
	.word	.LANCHOR148
	.word	.LANCHOR147
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcPageVarInit,"ax",%progbits
	.align	1
	.global	FtlGcPageVarInit
	.thumb
	.thumb_func
	.type	FtlGcPageVarInit, %function
FtlGcPageVarInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L931
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	strh	r3, [r2, #0]	@ movhi
	ldr	r4, .L931+4
	ldr	r2, .L931+8
	strh	r3, [r2, #0]	@ movhi
	ldrh	r2, [r4, #0]
	ldr	r3, .L931+12
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r2, .L931+16
	ldrh	r3, [r4, #0]
	movs	r1, #255
	ldr	r0, [r2, #0]
	movs	r2, #12
	muls	r2, r3, r2
	bl	memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L932:
	.align	2
.L931:
	.word	.LANCHOR145
	.word	.LANCHOR70
	.word	.LANCHOR147
	.word	.LANCHOR146
	.word	.LANCHOR148
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
	.section	.text.FtlGcRefreshOpenBlock,"ax",%progbits
	.align	1
	.global	FtlGcRefreshOpenBlock
	.thumb
	.thumb_func
	.type	FtlGcRefreshOpenBlock, %function
FtlGcRefreshOpenBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldr	r4, .L936
	ldrh	r5, [r4, #0]
	cmp	r5, r0
	beq	.L934
	ldr	r3, .L936+4
	ldrh	r1, [r3, #0]
	cmp	r1, r0
	beq	.L934
	movw	r2, #65535
	cmp	r5, r2
	bne	.L935
	strh	r0, [r4, #0]	@ movhi
	b	.L934
.L935:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3, #0]	@ movhi
.L934:
	movs	r0, #0
	pop	{r4, r5, pc}
.L937:
	.align	2
.L936:
	.word	.LANCHOR149
	.word	.LANCHOR150
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
	.section	.text.FtlGcRefreshBlock,"ax",%progbits
	.align	1
	.global	FtlGcRefreshBlock
	.thumb
	.thumb_func
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldr	r4, .L941
	ldrh	r5, [r4, #0]
	cmp	r5, r0
	beq	.L939
	ldr	r3, .L941+4
	ldrh	r1, [r3, #0]
	cmp	r1, r0
	beq	.L939
	movw	r2, #65535
	cmp	r5, r2
	bne	.L940
	strh	r0, [r4, #0]	@ movhi
	b	.L939
.L940:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3, #0]	@ movhi
.L939:
	movs	r0, #0
	pop	{r4, r5, pc}
.L942:
	.align	2
.L941:
	.word	.LANCHOR149
	.word	.LANCHOR150
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",%progbits
	.align	1
	.global	FtlGcMarkBadPhyBlk
	.thumb
	.thumb_func
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	bl	P2V_block_in_plane
	mov	r5, r0
	bl	FtlGcRefreshBlock
	ldr	r3, .L948
	ldr	r3, [r3, #0]
	cbz	r3, .L944
	ldr	r3, .L948+4
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	cmp	r2, #29
	bls	.L944
	subs	r2, r2, #30
	strh	r2, [r3, r5, lsl #1]	@ movhi
.L944:
	ldr	r3, .L948+8
	ldr	r2, .L948+12
	ldrh	r1, [r3, #0]
	movs	r3, #0
	b	.L945
.L947:
	ldrh	r0, [r2, #2]!
	cmp	r0, r4
	beq	.L946
	adds	r3, r3, #1
	uxth	r3, r3
.L945:
	cmp	r3, r1
	bne	.L947
	cmp	r3, #15
	bhi	.L946
	ldr	r2, .L948+16
	strh	r4, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	ldr	r2, .L948+8
	strh	r3, [r2, #0]	@ movhi
.L946:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L949:
	.align	2
.L948:
	.word	.LANCHOR128
	.word	.LANCHOR96
	.word	.LANCHOR151
	.word	.LANCHOR152-2
	.word	.LANCHOR152
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",%progbits
	.align	1
	.global	FtlGcReFreshBadBlk
	.thumb
	.thumb_func
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L953
	push	{r4, lr}
	ldrh	r3, [r3, #0]
	cbz	r3, .L951
	ldr	r2, .L953+4
	ldrh	r1, [r2, #0]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L951
	ldr	r4, .L953+8
	ldrh	r2, [r4, #0]
	cmp	r2, r3
	bcc	.L952
	movs	r3, #0
	strh	r3, [r4, #0]	@ movhi
.L952:
	ldr	r3, .L953+12
	ldrh	r2, [r4, #0]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
.L951:
	movs	r0, #0
	pop	{r4, pc}
.L954:
	.align	2
.L953:
	.word	.LANCHOR151
	.word	.LANCHOR149
	.word	.LANCHOR153
	.word	.LANCHOR152
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.ftl_memset,"ax",%progbits
	.align	1
	.global	ftl_memset
	.thumb
	.thumb_func
	.type	ftl_memset, %function
ftl_memset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.ftl_memcpy,"ax",%progbits
	.align	1
	.global	ftl_memcpy
	.thumb
	.thumb_func
	.type	ftl_memcpy, %function
ftl_memcpy:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.ftl_memcmp,"ax",%progbits
	.align	1
	.global	ftl_memcmp
	.thumb
	.thumb_func
	.type	ftl_memcmp, %function
ftl_memcmp:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcmp
	.size	ftl_memcmp, .-ftl_memcmp
	.section	.text.rknand_get_clk_rate,"ax",%progbits
	.align	1
	.global	rknand_get_clk_rate
	.thumb
	.thumb_func
	.type	rknand_get_clk_rate, %function
rknand_get_clk_rate:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L959
	bx	lr
.L960:
	.align	2
.L959:
	.word	148000000
	.size	rknand_get_clk_rate, .-rknand_get_clk_rate
	.section	.text.ftl_malloc,"ax",%progbits
	.align	1
	.global	ftl_malloc
	.thumb
	.thumb_func
	.type	ftl_malloc, %function
ftl_malloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #0
	b	kmalloc
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.FtlMemInit,"ax",%progbits
	.align	1
	.global	FtlMemInit
	.thumb
	.thumb_func
	.type	FtlMemInit, %function
FtlMemInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L967
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	movs	r1, #0
	strh	r1, [r3, #0]	@ movhi
	movs	r5, #12
	ldr	r3, .L967+4
	ldr	r2, .L967+8
	ldr	r4, .L967+12
	str	r1, [r3, #0]
	ldr	r3, .L967+16
	ldrh	r0, [r4, #0]
	ldr	r8, .L967+304
	str	r1, [r3, #0]
	ldr	r3, .L967+20
	lsls	r0, r0, #1
	ldr	r7, .L967+24
	str	r1, [r3, #0]
	ldr	r3, .L967+28
	str	r1, [r3, #0]
	ldr	r3, .L967+32
	str	r1, [r3, #0]
	ldr	r3, .L967+36
	str	r1, [r3, #0]
	ldr	r3, .L967+40
	str	r1, [r3, #0]
	ldr	r3, .L967+44
	str	r1, [r3, #0]
	ldr	r3, .L967+48
	str	r1, [r3, #0]
	ldr	r3, .L967+52
	str	r1, [r3, #0]
	ldr	r3, .L967+56
	str	r1, [r3, #0]
	ldr	r3, .L967+60
	str	r1, [r3, #0]
	ldr	r3, .L967+64
	str	r1, [r3, #0]
	ldr	r3, .L967+68
	str	r1, [r3, #0]
	ldr	r3, .L967+72
	str	r1, [r3, #0]
	ldr	r3, .L967+76
	str	r1, [r3, #0]
	ldr	r3, .L967+80
	str	r1, [r3, #0]
	movw	r3, #65535
	str	r3, [r2, #0]
	ldr	r2, .L967+84
	str	r1, [r2, #0]
	ldr	r2, .L967+88
	str	r1, [r2, #0]
	ldr	r2, .L967+92
	str	r1, [r2, #0]
	ldr	r2, .L967+96
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L967+100
	strh	r3, [r2, #0]	@ movhi
	movs	r2, #32
	ldr	r3, .L967+104
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #128
	ldr	r3, .L967+108
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L967+112
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L967+116
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L967+120
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L967+124
	strh	r1, [r3, #0]	@ movhi
	str	r1, [sp, #4]
	bl	ftl_malloc
	ldr	r3, .L967+128
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L967+132
	movs	r4, #36
	str	r0, [r3, #0]
	ldrh	r3, [r8, #0]
	muls	r4, r3, r4
	lsls	r6, r4, #2
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L967+136
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+140
	str	r0, [r3, #0]
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L967+144
	ldr	r6, .L967+148
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+152
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+156
	ldrh	r4, [r6, #0]
	str	r0, [r3, #0]
	mov	r0, r4
	ldrh	r3, [r8, #0]
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r7, #0]
	bl	ftl_malloc
	ldr	r3, .L967+160
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+164
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+168
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	muls	r0, r4, r0
	bl	ftl_malloc
	ldr	r3, .L967+172
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+176
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L967+180
	ldr	r4, .L967+184
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L967+188
	ldrh	r8, [r8, #0]
	str	r0, [r3, #0]
	ldrh	r3, [r4, #0]
	mul	r8, r8, r3
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L967+192
	str	r0, [r3, #0]
	lsl	r0, r8, #2
	bl	ftl_malloc
	ldr	r3, .L967+196
	str	r0, [r3, #0]
	ldrh	r3, [r4, #0]
	ldr	r0, [r7, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r4, .L967+200
	ldr	r3, .L967+204
	ldr	r7, .L967+208
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r7, #0]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L967+212
	str	r0, [r3, #0]
	ldrh	r0, [r7, #0]
	addw	r0, r0, #547
	lsrs	r0, r0, #9
	strh	r0, [r7, #0]	@ movhi
	ldr	r7, .L967+216
	lsls	r0, r0, #9
	bl	ftl_malloc
	ldr	r3, .L967+220
	str	r0, [r3, #0]
	adds	r0, r0, #32
	ldr	r3, .L967+224
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L967+228
	str	r0, [r3, #0]
	ldr	r3, [r7, #0]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L967+232
	str	r0, [r3, #0]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L967+236
	ldr	r8, .L967+308
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L967+240
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L967+244
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L967+248
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	ldr	r8, .L967+312
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L967+252
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L967+256
	ldrh	r2, [r8, #0]
	ldr	r1, [sp, #4]
	lsls	r2, r2, #2
	str	r0, [r3, #0]
	bl	memset
	ldr	r3, .L967+260
	ldrh	r8, [r3, #0]
	lsl	r8, r8, #2
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L967+264
	str	r0, [r3, #0]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L967+268
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	ldr	r7, .L967+272
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L967+276
	str	r0, [r3, #0]
	ldrh	r0, [r7, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L967+280
	ldr	r5, .L967+284
	str	r0, [r3, #0]
	ldrh	r3, [r7, #0]
	ldrh	r0, [r6, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L967+288
	str	r0, [r3, #0]
	movs	r0, #6
	ldrh	r3, [r4, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L967+292
	ldr	r4, .L967+296
	ldrh	r2, [r5, #0]
	str	r0, [r3, #0]
	ldr	r3, .L967+300
	ldrh	r3, [r3, #0]
	adds	r3, r3, #31
	lsrs	r3, r3, #5
	strh	r3, [r4, #0]	@ movhi
	muls	r3, r2, r3
	lsls	r0, r3, #2
	bl	ftl_malloc
	b	.L968
.L969:
	.align	2
.L967:
	.word	.LANCHOR129
	.word	.LANCHOR154
	.word	.LANCHOR170
	.word	.LANCHOR70
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR136
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR97
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LANCHOR171
	.word	.LANCHOR172
	.word	.LANCHOR89
	.word	.LANCHOR149
	.word	.LANCHOR150
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR175
	.word	.LANCHOR151
	.word	.LANCHOR176
	.word	.LANCHOR153
	.word	.LANCHOR146
	.word	.LANCHOR148
	.word	.LANCHOR177
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR73
	.word	.LANCHOR95
	.word	.LANCHOR135
	.word	.LANCHOR98
	.word	.LANCHOR180
	.word	.LANCHOR181
	.word	.LANCHOR132
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	.LANCHOR74
	.word	.LANCHOR134
	.word	.LANCHOR184
	.word	.LANCHOR185
	.word	.LANCHOR56
	.word	.LANCHOR133
	.word	.LANCHOR186
	.word	.LANCHOR142
	.word	.LANCHOR80
	.word	.LANCHOR187
	.word	.LANCHOR96
	.word	.LANCHOR101
	.word	.LANCHOR124
	.word	.LANCHOR120
	.word	.LANCHOR119
	.word	.LANCHOR87
	.word	.LANCHOR188
	.word	.LANCHOR189
	.word	.LANCHOR190
	.word	.LANCHOR82
	.word	.LANCHOR126
	.word	.LANCHOR191
	.word	.LANCHOR83
	.word	.LANCHOR125
	.word	.LANCHOR114
	.word	.LANCHOR60
	.word	.LANCHOR121
	.word	.LANCHOR99
	.word	.LANCHOR91
	.word	.LANCHOR66
	.word	.LANCHOR53
	.word	.LANCHOR77
	.word	.LANCHOR78
.L968:
	ldr	r2, .L970
	ldrh	r4, [r4, #0]
	movs	r1, #1
	mov	r3, r2
	ldrh	r5, [r5, #0]
	lsls	r4, r4, #2
	str	r0, [r3, #28]!
	mov	r0, r4
	b	.L963
.L964:
	ldr	r6, [r2, #28]
	adds	r1, r1, #1
	adds	r6, r6, r0
	adds	r0, r0, r4
	str	r6, [r3, #4]!
.L963:
	cmp	r1, r5
	bcc	.L964
	ldr	r0, .L970
	movs	r3, #0
	mov	r2, r3
	add	r0, r0, r1, lsl #2
	b	.L965
.L966:
	adds	r4, r0, r3
	adds	r1, r1, #1
	adds	r3, r3, #4
	str	r2, [r4, #28]
.L965:
	cmp	r1, #7
	bls	.L966
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L971:
	.align	2
.L970:
	.word	.LANCHOR90
	.size	FtlMemInit, .-FtlMemInit
	.section	.text.NandcInit,"ax",%progbits
	.align	1
	.global	NandcInit
	.thumb
	.thumb_func
	.type	NandcInit, %function
NandcInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r2, #1
	ldr	r3, .L973
	movs	r4, #0
	ldr	r5, .L973+4
	stmia	r3, {r0, r4}
	str	r2, [r3, #12]
	movs	r2, #2
	str	r0, [r3, #8]
	str	r2, [r3, #20]
	movs	r2, #3
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	str	r0, [r5, #0]
	ldr	r2, .L973+8
	ldr	r3, [r0, #0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	str	r1, [r2, #0]
	ldr	r2, .L973+12
	and	r3, r3, #245760
	ldr	r1, [r0, #352]
	orr	r3, r3, #256
	ubfx	r1, r1, #16, #4
	str	r1, [r2, #0]
	ldr	r1, [r0, #352]
	ldr	r2, .L973+16
	str	r1, [r2, #0]
	str	r3, [r0, #0]
	str	r4, [r0, #336]
	movs	r0, #40
	bl	NandcTimeCfg
	ldr	r3, [r5, #0]
	movw	r2, #8322
	mov	r0, #36864
	str	r2, [r3, #344]
	ldr	r2, .L973+20
	str	r2, [r3, #304]
	bl	ftl_malloc
	ldr	r3, .L973+24
	str	r0, [r3, #0]
	ldr	r3, .L973+28
	str	r0, [r3, #0]
	add	r0, r0, #32768
	str	r4, [r3, #24]
	str	r0, [r3, #4]
	ldr	r3, .L973+32
	str	r4, [r3, #0]
	pop	{r3, r4, r5, pc}
.L974:
	.align	2
.L973:
	.word	.LANCHOR5
	.word	.LANCHOR30
	.word	.LANCHOR192
	.word	.LANCHOR37
	.word	.LANCHOR40
	.word	1710593
	.word	.LANCHOR193
	.word	.LANCHOR38
	.word	.LANCHOR39
	.size	NandcInit, .-NandcInit
	.section	.text.ftl_free,"ax",%progbits
	.align	1
	.global	ftl_free
	.thumb
	.thumb_func
	.type	ftl_free, %function
ftl_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.StorageSysDataLoad,"ax",%progbits
	.align	1
	.global	StorageSysDataLoad
	.thumb
	.thumb_func
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r2, #512
	mov	r5, r0
	mov	r4, r1
	mov	r0, r1
	movs	r1, #0
	bl	memset
	movs	r0, #16
	add	r1, r5, #256
	movs	r2, #1
	mov	r3, r4
	pop	{r4, r5, r6, lr}
	b	FtlRead
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.StorageSysDataStore,"ax",%progbits
	.align	1
	.global	StorageSysDataStore
	.thumb
	.thumb_func
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r1
	movs	r2, #1
	add	r1, r0, #256
	movs	r0, #16
	b	FtlWrite
	.size	StorageSysDataStore, .-StorageSysDataStore
	.section	.text.FlashCs123Init,"ax",%progbits
	.align	1
	.global	FlashCs123Init
	.thumb
	.thumb_func
	.type	FlashCs123Init, %function
FlashCs123Init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashCs123Init, .-FlashCs123Init
	.section	.text.rk_nand_de_init,"ax",%progbits
	.align	1
	.global	rk_nand_de_init
	.thumb
	.thumb_func
	.type	rk_nand_de_init, %function
rk_nand_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	FlashDeInit
	.size	rk_nand_de_init, .-rk_nand_de_init
	.section	.text.rk_ftl_get_capacity,"ax",%progbits
	.align	1
	.global	rk_ftl_get_capacity
	.thumb
	.thumb_func
	.type	rk_ftl_get_capacity, %function
rk_ftl_get_capacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L981
	ldr	r0, [r3, #0]
	bx	lr
.L982:
	.align	2
.L981:
	.word	.LANCHOR84
	.size	rk_ftl_get_capacity, .-rk_ftl_get_capacity
	.section	.text.rknand_print_hex,"ax",%progbits
	.align	1
	.global	rknand_print_hex
	.thumb
	.thumb_func
	.type	rknand_print_hex, %function
rknand_print_hex:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	movs	r7, #0
	mov	sl, r0
	mov	r4, r1
	mov	r5, r2
	mov	r8, r3
	mov	r6, r7
	b	.L984
.L990:
	cbnz	r7, .L985
	ldr	r0, .L992
	mov	r1, sl
	mov	r2, r6
	bl	printf
.L985:
	cmp	r5, #4
	ldr	r0, .L992+4
	bne	.L986
	ldr	r1, [r4, r6, lsl #2]
	b	.L991
.L986:
	cmp	r5, #2
	ite	eq
	ldrsheq	r1, [r4, r6, lsl #1]
	ldrbne	r1, [r4, r6]	@ zero_extendqisi2
.L991:
	adds	r7, r7, #1
	bl	printf
	cmp	r7, #15
	bls	.L989
	ldr	r0, .L992+8
	movs	r7, #0
	ldr	r1, .L992+12
	bl	printf
.L989:
	adds	r6, r6, #1
.L984:
	cmp	r6, r8
	bne	.L990
	ldr	r0, .L992+8
	ldr	r1, .L992+12
	pop	{r3, r4, r5, r6, r7, r8, sl, lr}
	b	printf
.L993:
	.align	2
.L992:
	.word	.LC13
	.word	.LC14
	.word	.LC10
	.word	.LC15
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.FlashReadSlc2KPages,"ax",%progbits
	.align	1
	.global	FlashReadSlc2KPages
	.thumb
	.thumb_func
	.type	FlashReadSlc2KPages, %function
FlashReadSlc2KPages:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1008
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	mov	r7, r1
	ldrb	r8, [r3, #9]	@ zero_extendqisi2
	str	r2, [sp, #12]
	mov	r4, r0
	movs	r6, #0
	ldr	sl, .L1008+28
	b	.L995
.L1004:
	subs	r3, r7, r6
	ldr	r1, [sp, #12]
	add	r2, sp, #20
	mov	r0, r4
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #16
	bl	LogAddr2PhyAddr
	ldr	r1, .L1008+4
	ldr	r3, [sp, #16]
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bcc	.L996
	mov	r3, #-1
	str	r3, [r4, #0]
	b	.L997
.L996:
	ldr	r2, .L1008+8
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcWaitFlashReady
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashReadCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r3, [r4, #12]
	movs	r1, #0
	mov	r2, r8
	mov	r0, r5
	str	r3, [sp, #0]
	ldr	r3, [r4, #8]
	bl	NandcXferData
	ldr	r3, [sp, #20]
	ldr	r1, [sl, #0]
	adds	r1, r1, r3
	mov	fp, r0
	mov	r0, r5
	bl	FlashReadCmd
	ldr	r3, [r4, #8]
	cbz	r3, .L998
	add	r3, r3, #2048
.L998:
	ldr	r2, [r4, #12]
	cbz	r2, .L999
	adds	r2, r2, #8
.L999:
	movs	r1, #0
	str	r2, [sp, #0]
	mov	r0, r5
	mov	r2, r8
	bl	NandcXferData
	mov	r3, r0
	mov	r0, r5
	str	r3, [sp, #8]
	bl	NandcFlashDeCs
	ldr	r2, .L1008+12
	ldr	r3, [sp, #8]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cmp	r3, fp
	it	cc
	movcc	r3, fp
	add	r2, r2, r2, lsl #1
	cmp	r3, r2, lsr #2
	bls	.L1000
	cmp	r3, #-1
	ite	eq
	moveq	r3, #-1
	movne	r3, #256
.L1000:
	adds	r2, r3, #1
	str	r3, [r4, #0]
	beq	.L1001
	cmp	r3, #256
	beq	.L1001
	movs	r3, #0
	str	r3, [r4, #0]
.L1001:
	ldr	r3, [r4, #12]
	cbz	r3, .L1002
	ldr	r2, [r3, #8]
	adds	r0, r2, #1
	bne	.L1002
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	it	ne
	strne	r2, [r4, #0]
.L1002:
	ldr	r3, [r4, #0]
	adds	r1, r3, #1
	bne	.L997
	ldr	r2, .L1008+12
	ldr	r1, [r4, #4]
	ldr	r0, .L1008+16
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1003
	ldr	r0, .L1008+20
	movs	r2, #4
	movs	r3, #8
	bl	rknand_print_hex
.L1003:
	ldr	r1, [r4, #12]
	cbz	r1, .L997
	movs	r2, #4
	ldr	r0, .L1008+24
	mov	r3, r2
	bl	rknand_print_hex
.L997:
	adds	r6, r6, #1
	adds	r4, r4, #36
.L995:
	cmp	r6, r7
	bne	.L1004
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1009:
	.align	2
.L1008:
	.word	.LANCHOR18
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR29
	.word	.LC16
	.word	.LC17
	.word	.LC18
	.word	.LANCHOR2
	.size	FlashReadSlc2KPages, .-FlashReadSlc2KPages
	.section	.text.FlashReadPages,"ax",%progbits
	.align	1
	.global	FlashReadPages
	.thumb
	.thumb_func
	.type	FlashReadPages, %function
FlashReadPages:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1058
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #48
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r0, [sp, #12]
	str	r1, [sp, #32]
	str	r3, [sp, #28]
	ldr	r3, .L1058+4
	str	r2, [sp, #20]
	ldrb	r4, [r3, #0]	@ zero_extendqisi2
	str	r4, [sp, #36]
	ldr	r4, .L1058+8
	ldrb	r4, [r4, #0]	@ zero_extendqisi2
	cmp	r4, #0
	beq	.L1044
	bl	FlashReadSlc2KPages
	b	.L1012
.L1043:
	movs	r3, #36
	ldr	r4, [sp, #12]
	add	r2, sp, #44
	ldr	r1, [sp, #20]
	mul	r3, r3, fp
	adds	r7, r4, r3
	ldr	r4, [sp, #32]
	mov	r0, r7
	str	r3, [sp, #16]
	rsb	r3, fp, r4
	ldr	r5, [r7, #4]
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #40
	bl	LogAddr2PhyAddr
	ldr	r2, .L1058+12
	ldr	r3, [sp, #40]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cmp	r3, r2
	mov	r8, r0
	bcc	.L1013
	ldr	r1, [sp, #12]
	mov	r3, #-1
	ldr	r4, [sp, #16]
	str	r3, [r1, r4]
	b	.L1014
.L1013:
	ldr	r2, .L1058+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1058+20
	mov	r0, r4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r8, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1058+24
	ldr	r3, [r3, #0]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #6
	bhi	.L1016
	ldr	r2, .L1058+28
	cmp	r0, #7
	add	r1, r2, r4
	ldrb	r3, [r1, #12]	@ zero_extendqisi2
	it	eq
	ldrbeq	r3, [r1, #20]	@ zero_extendqisi2
	ldr	r1, .L1058+32
	ldrb	r1, [r1, r4]	@ zero_extendqisi2
	cmp	r1, r3
	beq	.L1016
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	mov	r0, r4
	ldr	r2, .L1058+36
	bl	HynixSetRRPara
.L1016:
	mov	r0, r4
	and	r5, r5, #-2147483648
	str	r5, [sp, #24]
	bl	NandcFlashCs
	ldr	r2, [sp, #20]
	cmp	r2, #1
	beq	.L1018
	ldr	r5, [sp, #24]
	cbz	r5, .L1019
.L1018:
	ldr	r3, .L1058+40
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1019
	mov	r0, r4
	bl	flash_enter_slc_mode
	b	.L1020
.L1019:
	mov	r0, r4
	bl	flash_exit_slc_mode
.L1020:
	mov	r5, r7
	movs	r6, #0
	mov	r7, r8
.L1057:
	ldr	r1, [sp, #44]
	adds	r2, r1, #1
	bne	.L1022
	cmp	r4, #255
	beq	.L1046
.L1022:
	cbz	r7, .L1024
	ldr	r3, .L1058+44
	mov	r0, r4
	ldr	r2, [r3, #0]
	adds	r2, r1, r2
	bl	FlashReadDpCmd
	b	.L1025
.L1024:
	mov	r0, r4
	bl	FlashReadCmd
.L1025:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r7, .L1023
	mov	r0, r4
	ldr	r1, [sp, #44]
	bl	FlashReadDpDataOutCmd
	b	.L1023
.L1046:
	movs	r7, #0
.L1023:
	ldr	r3, [r5, #12]
	movs	r1, #0
	mov	r0, r4
	ldr	r2, [sp, #28]
	str	r3, [sp, #0]
	ldr	r3, [r5, #8]
	bl	NandcXferData
	ldr	r1, .L1058+4
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	cbz	r3, .L1048
	adds	r3, r0, #1
	bne	.L1048
	strb	r6, [r1, #0]
	movs	r7, #0
	b	.L1057
.L1048:
	mov	r8, r7
	mov	r7, r5
	mov	r6, r8
	mov	r5, r0
	cmp	r8, #0
	beq	.L1027
	ldr	r2, .L1058+44
	mov	r0, r4
	ldr	r3, [sp, #44]
	ldr	r1, [r2, #0]
	adds	r1, r1, r3
	bl	FlashReadDpDataOutCmd
	ldr	r1, [sp, #12]
	movs	r2, #36
	add	r3, fp, #1
	mov	r0, r4
	mla	r3, r2, r3, r1
	movs	r1, #0
	ldr	r2, [r3, #12]
	str	r2, [sp, #0]
	ldr	r2, [sp, #28]
	ldr	r3, [r3, #8]
	bl	NandcXferData
	mov	sl, r0
	cmp	r0, #-1
	ite	ne
	movne	r6, r8
	moveq	r6, #0
.L1027:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, [sp, #36]
	ldr	r2, .L1058+4
	adds	r0, r5, #1
	strb	r3, [r2, #0]
	bne	.L1031
	ldr	r3, .L1058+48
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1029
	ldr	r3, .L1058+52
	mov	r0, r4
	ldr	r1, [sp, #44]
	ldr	r3, [r3, #0]
	ldr	r6, [r3, #304]
	movs	r3, #1
	str	r3, [sp, #0]
	ldr	r2, [r7, #8]
	ldr	r3, [r7, #12]
	bl	FlashDdrTunningRead
	adds	r1, r0, #1
	mov	r5, r0
	beq	.L1030
	ldr	r3, .L1058+56
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1051
.L1030:
	ubfx	r0, r6, #8, #8
	bl	NandcSetDdrPara
	adds	r2, r5, #1
	bne	.L1051
.L1029:
	ldr	r3, .L1058+60
	mov	r0, r4
	ldr	r1, [sp, #44]
	ldr	r2, [r7, #8]
	ldr	r6, [r3, #0]
	ldr	r3, [r7, #12]
	cmp	r6, #0
	beq	.L1032
	blx	r6
	adds	r3, r0, #1
	mov	r5, r0
	bne	.L1053
	ldr	r3, .L1058+24
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1034
	ldr	r2, .L1058+28
	mov	r0, r4
	movs	r3, #0
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	adds	r2, r2, #4
	bl	HynixSetRRPara
.L1034:
	ldr	r1, [sp, #44]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r3, [r7, #12]
	bl	FlashReadRawPage
	ldr	r3, .L1058+56
	ldr	r1, [r7, #4]
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	mov	r5, r0
	ldr	r0, .L1058+64
	mov	r3, r5
	bl	printf
	adds	r6, r5, #1
	bne	.L1053
	ldr	r3, .L1058+40
	ldrb	r6, [r3, #0]	@ zero_extendqisi2
	cmp	r6, #0
	beq	.L1033
	ldr	r1, [sp, #20]
	mov	r0, r4
	cmp	r1, #1
	beq	.L1035
	ldr	r2, [sp, #24]
	cbz	r2, .L1036
.L1035:
	bl	flash_enter_slc_mode
	b	.L1037
.L1036:
	bl	flash_exit_slc_mode
.L1037:
	ldr	r3, .L1058+60
	mov	r0, r4
	ldr	r1, [sp, #44]
	ldr	r2, [r7, #8]
	ldr	r5, [r3, #0]
	ldr	r3, [r7, #12]
	blx	r5
	mov	r5, r0
	b	.L1053
.L1032:
	bl	FlashReadRawPage
	mov	r5, r0
	b	.L1033
.L1059:
	.align	2
.L1058:
	.word	.LANCHOR18
	.word	.LANCHOR4
	.word	.LANCHOR0
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR194
	.word	.LANCHOR23
	.word	.LANCHOR31
	.word	.LANCHOR32
	.word	.LANCHOR31+4
	.word	.LANCHOR7
	.word	.LANCHOR2
	.word	.LANCHOR35
	.word	.LANCHOR30
	.word	.LANCHOR29
	.word	.LANCHOR51
	.word	.LC19
.L1051:
	movs	r6, #0
.L1031:
	ldr	r3, .L1060
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bls	.L1033
	ldr	r3, .L1060+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	it	eq
	moveq	r5, #256
	b	.L1033
.L1053:
	movs	r6, #0
.L1033:
	ldr	r1, [sp, #12]
	adds	r0, r5, #1
	ldr	r3, [sp, #16]
	str	r5, [r1, r3]
	beq	.L1038
	cmp	r5, #256
	beq	.L1038
	ldr	r2, [sp, #16]
	movs	r3, #0
	str	r3, [r1, r2]
.L1038:
	ldr	r1, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r3, [r2, r1]
	adds	r1, r3, #1
	bne	.L1039
	ldr	r2, .L1060
	ldr	r1, [r7, #4]
	ldr	r0, .L1060+8
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1039
	movs	r2, #4
	ldr	r0, .L1060+12
	mov	r3, r2
	bl	rknand_print_hex
.L1039:
	cbz	r6, .L1040
	ldr	r3, .L1060
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	sl, r3, lsr #2
	bls	.L1041
	ldr	r3, .L1060+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	it	eq
	moveq	sl, #256
.L1041:
	ldr	r1, [sp, #12]
	movs	r2, #36
	add	r3, fp, #1
	muls	r3, r2, r3
	cmp	sl, #-1
	str	sl, [r1, r3]
	beq	.L1040
	cmp	sl, #256
	beq	.L1040
	movs	r2, #0
	str	r2, [r1, r3]
.L1040:
	ldr	r2, [sp, #20]
	add	fp, fp, r6
	cmp	r2, #1
	beq	.L1042
	ldr	r3, [sp, #24]
	cbz	r3, .L1014
.L1042:
	ldr	r3, .L1060+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1014
	mov	r0, r4
	bl	flash_exit_slc_mode
.L1014:
	add	fp, fp, #1
	b	.L1011
.L1044:
	mov	sl, r4
	mov	fp, r4
.L1011:
	ldr	r4, [sp, #32]
	cmp	fp, r4
	bcc	.L1043
	movs	r0, #0
.L1012:
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1061:
	.align	2
.L1060:
	.word	.LANCHOR29
	.word	.LANCHOR51
	.word	.LC16
	.word	.LC18
	.word	.LANCHOR7
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FtlGcScanTempBlk,"ax",%progbits
	.align	1
	.global	FtlGcScanTempBlk
	.thumb
	.thumb_func
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1085
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrh	r5, [r3, #0]
	movw	r3, #65535
	sub	sp, sp, #24
	cmp	r5, r3
	beq	.L1081
	cbnz	r5, .L1063
	b	.L1064
.L1081:
	movs	r5, #0
.L1063:
	ldr	r3, .L1085+4
	ldrh	r3, [r3, #0]
	cmp	r1, r3
	bne	.L1065
.L1064:
	bl	FtlGcPageVarInit
.L1065:
	ldr	r8, .L1085+44
	movw	sl, #65535
	mov	r3, #-1
	str	r3, [sp, #20]
.L1078:
	ldrh	r3, [r4, #0]
	movs	r2, #0
	strb	r2, [r4, #8]
	cmp	r3, sl
	beq	.L1066
.L1067:
	mov	r7, r4
.L1083:
	ldr	r3, .L1085+8
	mov	r2, r7
	ldr	r6, .L1085+12
	ldr	ip, [r8, #0]
	ldr	lr, [r3, #0]
	ldr	r3, .L1085+16
	ldrh	fp, [r6, #0]
	ldrh	r6, [r3, #0]
	movs	r3, #0
	mov	r4, r3
	stmia	sp, {r6, ip}
	b	.L1068
.L1070:
	ldrh	r0, [r2, #16]
	cmp	r0, sl
	beq	.L1069
	ldr	r6, [sp, #4]
	mov	ip, #36
	orr	r0, r5, r0, lsl #10
	mla	r1, ip, r4, r6
	ldr	r6, [sp, #0]
	str	r0, [r1, #4]
	movs	r0, #0
	str	r0, [r1, #8]
	mul	r0, r6, r4
	adds	r4, r4, #1
	uxth	r4, r4
	bic	r0, r0, #3
	add	r0, lr, r0
	str	r0, [r1, #12]
.L1069:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1068:
	cmp	r3, fp
	bne	.L1070
	ldr	r0, [r8, #0]
	mov	r1, r4
	movs	r2, #0
	movs	r6, #0
	bl	FlashReadPages
	mov	fp, r6
	b	.L1071
.L1079:
	ldr	r3, [r8, #0]
	adds	r2, r3, r6
	ldr	r1, [r2, #4]
	str	r2, [sp, #16]
	ubfx	r0, r1, #10, #16
	str	r3, [sp, #12]
	str	r1, [sp, #8]
	bl	P2V_plane
	ldr	r3, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #16]
	ldr	r3, [r3, r6]
	cbnz	r3, .L1072
	ldr	r3, [r2, #12]
	adds	r6, r6, #36
	ldrh	r2, [r3, #0]
	cmp	r2, sl
	bne	.L1073
	ldr	r3, .L1085+20
	movs	r1, #1
	mov	r2, r0
	mov	r4, r7
	str	r1, [r3, #0]
	b	.L1066
.L1073:
	add	fp, fp, #1
	ldr	r0, [r3, #12]
	ldr	r2, [r3, #8]
	bl	FtlGcUpdatePage
	uxth	fp, fp
	b	.L1071
.L1072:
	mov	fp, r1
	ldr	r0, .L1085+24
	ldrh	r1, [r7, #0]
	mov	r2, fp
	bl	printf
	ldr	r3, .L1085+28
	mov	r4, r7
	ldr	r3, [r3, #0]
	cbnz	r3, .L1074
	ldr	r3, .L1085+32
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1075
.L1074:
	ldr	r3, .L1085+36
	ldrh	r2, [r4, #0]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #119
	bls	.L1076
.L1075:
	ldr	r3, [r8, #0]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	bne	.L1077
.L1076:
	ldr	r3, [r8, #0]
	adds	r6, r3, r6
	ldr	r6, [r6, #4]
	str	r6, [sp, #20]
.L1077:
	ldr	r3, .L1085+40
	movs	r5, #0
	ldrh	r2, [r4, #0]
	ldr	r3, [r3, #0]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4, #0]
	bl	INSERT_FREE_LIST
	strh	sl, [r4, #0]	@ movhi
	bl	FtlGcPageVarInit
	b	.L1078
.L1071:
	cmp	fp, r4
	bne	.L1079
	ldr	r3, .L1085+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3, #0]
	cmp	r3, r5
	bhi	.L1083
	mov	r4, r7
	movs	r2, #0
.L1066:
	ldr	r3, .L1085
	mov	r0, r4
	movw	r1, #65535
	strh	r5, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	strh	r1, [r3, #0]	@ movhi
	mov	r1, r5
	bl	ftl_sb_update_avl_pages
	ldr	r0, [sp, #20]
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1086:
	.align	2
.L1085:
	.word	.LANCHOR195
	.word	.LANCHOR68
	.word	.LANCHOR133
	.word	.LANCHOR53
	.word	.LANCHOR74
	.word	.LANCHOR140
	.word	.LC20
	.word	.LANCHOR128
	.word	.LANCHOR7
	.word	.LANCHOR96
	.word	.LANCHOR101
	.word	.LANCHOR177
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlScanSysBlk,"ax",%progbits
	.align	1
	.global	FtlScanSysBlk
	.thumb
	.thumb_func
	.type	FtlScanSysBlk, %function
FtlScanSysBlk:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1148
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r4, #0
	ldr	r5, .L1148+4
	sub	sp, sp, #40
	strh	r4, [r3, #0]	@ movhi
	mov	r1, r4
	ldr	r3, .L1148+8
	ldr	r2, [r5, #0]
	ldr	r7, .L1148+12
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1148+16
	lsls	r2, r2, #2
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r2, [r5, #0]
	ldr	r3, .L1148+20
	mov	r1, r4
	ldr	r5, .L1148+24
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r3, .L1148+28
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #2
	bl	memset
	ldr	r3, .L1148+32
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	ldr	r0, .L1148+36
	movs	r1, #255
	movs	r2, #12
	bl	memset
	ldr	r3, .L1148+40
	ldrh	r3, [r3, #0]
	str	r3, [sp, #24]
	b	.L1088
.L1090:
	ldrb	r0, [fp, r4]	@ zero_extendqisi2
	ldr	r1, [sp, #24]
	str	r3, [sp, #4]
	bl	V2P_block
	str	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #4]
	cbnz	r0, .L1089
	ldr	r1, [r7, #0]
	lsls	r2, r2, #10
	ldr	r0, [r6, #0]
	mla	r1, sl, r3, r1
	str	r2, [r1, #4]
	ldr	r2, [r8, #0]
	str	r2, [r1, #8]
	ldrh	r2, [r5, #0]
	muls	r2, r3, r2
	adds	r3, r3, #1
	bic	r2, r2, #3
	adds	r2, r0, r2
	str	r2, [r1, #12]
	uxth	r3, r3
.L1089:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1125
.L1137:
	movs	r3, #0
	ldr	fp, .L1148+76
	ldr	r8, .L1148+80
	mov	r4, r3
	ldr	r6, .L1148+44
	mov	sl, #36
	ldr	r5, .L1148+48
	str	r3, [sp, #20]
.L1125:
	ldr	r1, .L1148+52
	ldrh	r2, [r1, #0]
	cmp	r2, r4
	bhi	.L1090
	str	r3, [sp, #20]
	cmp	r3, #0
	beq	.L1091
	ldr	r0, [r7, #0]
	mov	r1, r3
	movs	r2, #1
	movs	r6, #0
	bl	FlashReadPages
	str	r6, [sp, #32]
.L1124:
	ldr	r3, [r7, #0]
	adds	r2, r3, r6
	ldr	r3, [r3, r6]
	ldr	r5, [r2, #4]
	adds	r3, r3, #1
	ldr	r4, [r2, #12]
	ubfx	r5, r5, #10, #16
	bne	.L1092
	mov	r8, #16
.L1094:
	ldr	r0, [r7, #0]
	movs	r1, #1
	mov	r2, r1
	adds	r0, r0, r6
	ldr	r3, [r0, #4]
	adds	r3, r3, #1
	str	r3, [r0, #4]
	bl	FlashReadPages
	ldrh	r3, [r4, #0]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1093
	ldr	r1, .L1148+12
	mov	r2, #-1
	ldr	r3, [r1, #0]
	str	r2, [r3, r6]
	b	.L1092
.L1093:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	bne	.L1092
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L1094
.L1092:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	beq	.L1095
	ldr	r2, .L1148+56
	ldr	r3, [r4, #4]
	ldr	r1, [r2, #0]
	adds	r0, r1, #1
	beq	.L1096
	cmp	r1, r3
	bhi	.L1097
.L1096:
	adds	r1, r3, #1
	beq	.L1097
	adds	r3, r3, #1
	str	r3, [r2, #0]
.L1097:
	ldrh	r3, [r4, #0]
	movw	r2, #61604
	cmp	r3, r2
	beq	.L1100
	bhi	.L1103
	movw	r2, #61574
	cmp	r3, r2
	bne	.L1098
	b	.L1146
.L1103:
	movw	r2, #61634
	cmp	r3, r2
	beq	.L1101
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1098
	b	.L1147
.L1101:
	ldr	r3, .L1148
	ldr	r8, .L1148+4
	ldrh	r2, [r3, #0]
	ldr	r3, [r8, #0]
	cmp	r2, r3
	bls	.L1104
	ldr	r1, .L1148+60
	movw	r2, #1269
	ldr	r0, .L1148+64
	bl	printf
	ldr	r0, .L1148+68
	ldr	r1, .L1148+72
	bl	printf
.L1104:
	ldr	r3, [r8, #0]
	mov	ip, #0
	ldr	r1, .L1148
	uxth	r2, r3
	str	r3, [sp, #12]
	subs	r3, r2, #1
	ldrh	r0, [r1, #0]
	ldr	r1, .L1148+16
	uxth	r3, r3
	subs	r2, r2, r0
	subs	r2, r2, #1
	ldr	r1, [r1, #0]
	sxth	fp, r3
	sxth	r2, r2
	str	r2, [sp, #36]
	add	sl, r1, fp, lsl #2
	str	sl, [sp, #16]
	mov	sl, r5
	b	.L1105
.L1111:
	rsb	r2, ip, fp
	str	r2, [sp, #28]
	ldr	r2, [sp, #16]
	add	ip, ip, #1
	ldr	r8, [r4, #4]
	subs	r5, r2, #4
	str	r5, [sp, #16]
	ldr	r5, [r2, #0]
	cmp	r8, r5
	bls	.L1106
	ldr	ip, [r1, #0]
	mov	r5, sl
	str	r2, [sp, #16]
	cmp	ip, #0
	bne	.L1107
	ldr	r2, [sp, #12]
	cmp	r0, r2
	beq	.L1107
	add	ip, r0, #1
	ldr	r0, .L1148
	strh	ip, [r0, #0]	@ movhi
.L1107:
	ldr	r0, .L1148+20
	sxth	sl, r3
	mov	fp, r3
	str	sl, [sp, #12]
	mov	r3, r1
	ldr	ip, [r0, #0]
	movs	r0, #0
	mov	r8, ip
	b	.L1108
.L1109:
	ldr	sl, [r1, #4]!
	adds	r0, r0, #1
	uxth	r0, r0
	str	sl, [r3], #4
	ldrh	sl, [ip, #2]!
	strh	sl, [r8], #2	@ movhi
.L1108:
	ldr	r2, [sp, #12]
	sxth	sl, r0
	cmp	sl, r2
	bne	.L1109
	ldr	r1, [r4, #4]
	mov	r3, fp
	ldr	r2, [sp, #16]
	ldr	sl, [sp, #28]
	str	r1, [r2, #0]
	ldr	r2, .L1148+20
	ldr	r2, [r2, #0]
	strh	r5, [r2, sl, lsl #1]	@ movhi
	b	.L1110
.L1106:
	subs	r3, r3, #1
	uxth	r3, r3
.L1105:
	ldr	r5, [sp, #36]
	sxth	r2, r3
	cmp	r2, r5
	bgt	.L1111
	mov	r5, sl
.L1110:
	sxth	r3, r3
	cmp	r3, #0
	blt	.L1098
	ldr	r2, .L1148
	ldr	r0, .L1148+4
	ldrh	r1, [r2, #0]
	ldr	r0, [r0, #0]
	subs	r0, r0, r1
	subs	r0, r0, #1
	sxth	r0, r0
	cmp	r3, r0
	bgt	.L1098
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
	ldr	r2, .L1148+16
	ldr	r1, [r4, #4]
	ldr	r2, [r2, #0]
	str	r1, [r2, r3, lsl #2]
	ldr	r2, .L1148+20
	b	.L1144
.L1149:
	.align	2
.L1148:
	.word	.LANCHOR123
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR177
	.word	.LANCHOR125
	.word	.LANCHOR124
	.word	.LANCHOR77
	.word	.LANCHOR189
	.word	.LANCHOR87
	.word	.LANCHOR196
	.word	.LANCHOR55
	.word	.LANCHOR133
	.word	.LANCHOR74
	.word	.LANCHOR53
	.word	.LANCHOR156
	.word	.LANCHOR197
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR62
	.word	.LANCHOR132
.L1146:
	ldr	r3, .L1150
	ldr	r8, .L1150+28
	ldrh	r2, [r3, #0]
	ldrh	r3, [r8, #0]
	cmp	r2, r3
	bls	.L1112
	ldr	r1, .L1150+4
	movw	r2, #1316
	ldr	r0, .L1150+8
	bl	printf
	ldr	r0, .L1150+12
	ldr	r1, .L1150+16
	bl	printf
.L1112:
	ldr	r1, .L1150
	mov	ip, #0
	ldrh	r8, [r8, #0]
	ldrh	r0, [r1, #0]
	add	r2, r8, #-1
	str	r8, [sp, #16]
	uxth	r3, r2
	subs	r2, r2, r0
	str	r2, [sp, #36]
	ldr	r2, .L1150+20
	sxth	fp, r3
	ldr	r1, [r2, #0]
	add	sl, r1, fp, lsl #2
	str	sl, [sp, #28]
	mov	sl, r5
	b	.L1113
.L1119:
	ldr	r2, [sp, #28]
	add	ip, ip, #1
	ldr	r8, [r4, #4]
	subs	r5, r2, #4
	str	r5, [sp, #28]
	ldr	r5, [r2, #0]
	cmp	r8, r5
	bls	.L1114
	ldr	ip, [r1, #0]
	mov	r5, sl
	cmp	ip, #0
	bne	.L1115
	ldr	sl, [sp, #16]
	cmp	r0, sl
	beq	.L1115
	add	ip, r0, #1
	ldr	r0, .L1150
	strh	ip, [r0, #0]	@ movhi
.L1115:
	ldr	r0, .L1150+24
	sxth	sl, r3
	mov	fp, r3
	str	sl, [sp, #16]
	str	r2, [sp, #28]
	mov	r3, r1
	ldr	ip, [r0, #0]
	movs	r0, #0
	mov	r8, ip
	b	.L1116
.L1117:
	ldr	sl, [r1, #4]!
	adds	r0, r0, #1
	uxth	r0, r0
	str	sl, [r3], #4
	ldrh	sl, [r8, #2]!
	strh	sl, [ip], #2	@ movhi
.L1116:
	ldr	r2, [sp, #16]
	sxth	sl, r0
	cmp	sl, r2
	bne	.L1117
	ldr	r2, [sp, #28]
	mov	r3, fp
	ldr	r1, [r4, #4]
	ldr	sl, [sp, #12]
	str	r1, [r2, #0]
	ldr	r2, .L1150+24
	ldr	r2, [r2, #0]
	strh	r5, [r2, sl, lsl #1]	@ movhi
	b	.L1118
.L1114:
	subs	r3, r3, #1
	uxth	r3, r3
.L1113:
	ldr	r5, [sp, #36]
	rsb	r2, ip, fp
	str	r2, [sp, #12]
	cmp	r2, r5
	bgt	.L1119
	mov	r5, sl
.L1118:
	sxth	r3, r3
	cmp	r3, #0
	blt	.L1098
	ldr	r0, .L1150+28
	ldr	r2, .L1150
	ldrh	r0, [r0, #0]
	ldrh	r1, [r2, #0]
	subs	r0, r0, #1
	subs	r0, r0, r1
	sxth	r0, r0
	cmp	r3, r0
	bgt	.L1098
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
	ldr	r2, .L1150+20
	ldr	r1, [r4, #4]
	ldr	r2, [r2, #0]
	str	r1, [r2, r3, lsl #2]
	ldr	r2, .L1150+24
.L1144:
	ldr	r2, [r2, #0]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L1098
.L1100:
	ldr	r8, .L1150+32
	movw	sl, #65535
	ldrh	r3, [r8, #0]
	cmp	r3, sl
	bne	.L1120
	ldr	r3, [r4, #4]
	strh	r5, [r8, #0]	@ movhi
	str	r3, [r8, #8]
	b	.L1098
.L1120:
	ldrh	r0, [r8, #4]
	movw	ip, #65535
	cmp	r0, ip
	beq	.L1121
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L1121:
	ldr	r2, [r4, #4]
	ldr	r1, [r8, #8]
	ldr	r3, .L1150+32
	cmp	r1, r2
	bcs	.L1122
	ldrh	r1, [r3, #0]
	str	r2, [r3, #8]
	strh	r5, [r3, #0]	@ movhi
	strh	r1, [r3, #4]	@ movhi
	b	.L1098
.L1122:
	strh	r5, [r3, #4]	@ movhi
	b	.L1098
.L1147:
	mov	r0, r5
	b	.L1145
.L1095:
	ldr	r1, .L1150+36
	mov	r0, r5
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	cbz	r3, .L1123
.L1145:
	movs	r1, #0
	b	.L1143
.L1123:
	movs	r1, #1
.L1143:
	bl	FtlFreeSysBlkQueueIn
.L1098:
	ldr	r5, [sp, #32]
	adds	r6, r6, #36
	adds	r3, r5, #1
	ldr	r5, [sp, #20]
	uxth	r3, r3
	str	r3, [sp, #32]
	cmp	r3, r5
	bne	.L1124
.L1091:
	ldr	sl, [sp, #24]
	add	r3, sl, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L1088:
	ldr	r3, .L1150+40
	ldr	ip, [sp, #24]
	ldrh	r3, [r3, #0]
	cmp	r3, ip
	bhi	.L1137
	ldr	r3, .L1150+44
	ldr	r1, [r3, #0]
	ldrh	r3, [r1, #0]
	cbnz	r3, .L1126
	ldr	r2, .L1150+48
	ldrh	r2, [r2, #0]
	cbz	r2, .L1126
	ldr	r2, .L1150+52
	ldr	r4, [r2, #0]
	mov	r2, r1
	b	.L1127
.L1130:
	ldrh	r5, [r2], #2
	adds	r3, r3, #1
	cbz	r5, .L1127
	ldr	r3, .L1150+56
	sxth	r0, r0
	ldr	ip, .L1150+52
	mov	sl, r1
	add	r6, r1, r0, lsl #1
	ldr	r5, [r3, #0]
	movs	r3, #0
	mov	r2, r3
	mov	r4, r3
	add	r7, r5, r0, lsl #2
	mov	fp, r3
	b	.L1128
.L1129:
	ldrh	r1, [r6, r2]
	strh	r1, [sl, r2]	@ movhi
	ldr	r1, [r7, r3]
	str	r1, [r5, r3]
	adds	r3, r3, #4
	strh	fp, [r6, r2]	@ movhi
	adds	r2, r2, #2
.L1128:
	ldr	r1, [ip, #0]
	add	r8, r4, r0
	adds	r4, r4, #1
	cmp	r8, r1
	bcc	.L1129
	b	.L1126
.L1127:
	cmp	r3, r4
	uxth	r0, r3
	bne	.L1130
.L1126:
	ldr	r3, .L1150+24
	ldr	r0, [r3, #0]
	ldrh	r3, [r0, #0]
	cmp	r3, #0
	bne	.L1131
	ldr	r2, .L1150
	ldrh	r2, [r2, #0]
	cmp	r2, #0
	beq	.L1131
	ldr	r2, .L1150+28
	ldrh	r4, [r2, #0]
	mov	r2, r0
	b	.L1132
.L1135:
	ldrh	r5, [r2], #2
	adds	r3, r3, #1
	cmp	r5, #0
	beq	.L1132
	ldr	r3, .L1150+20
	sxth	r1, r1
	subs	r6, r1, r6
	add	r7, r0, r1, lsl #1
	ldr	r5, [r3, #0]
	movs	r3, #0
	mov	r2, r3
	mov	r4, r3
	add	r0, r0, r6, lsl #1
	add	ip, r5, r1, lsl #2
	b	.L1133
.L1134:
	ldrh	r8, [r7, r2]
	ldr	sl, [ip, r3]
	strh	r8, [r0, r2]	@ movhi
	add	r8, r5, r6, lsl #2
	str	sl, [r8, r3]
	mov	r8, #0
	adds	r3, r3, #4
	strh	r8, [r7, r2]	@ movhi
	adds	r2, r2, #2
.L1133:
	ldr	r8, .L1150+28
	add	sl, r4, r1
	adds	r4, r4, #1
	ldrh	r8, [r8, #0]
	cmp	sl, r8
	blt	.L1134
	b	.L1131
.L1151:
	.align	2
.L1150:
	.word	.LANCHOR86
	.word	.LANCHOR197
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR189
	.word	.LANCHOR87
	.word	.LANCHOR77
	.word	.LANCHOR196
	.word	.LANCHOR7
	.word	.LANCHOR56
	.word	.LANCHOR124
	.word	.LANCHOR123
	.word	.LANCHOR80
	.word	.LANCHOR125
.L1132:
	cmp	r3, r4
	uxth	r1, r3
	mov	r6, r3
	blt	.L1135
.L1131:
	ldr	r3, .L1152
	ldrh	r2, [r3, #0]
	ldr	r3, .L1152+4
	ldr	r3, [r3, #0]
	cmp	r2, r3
	bls	.L1136
	ldr	r1, .L1152+8
	movw	r2, #1450
	ldr	r0, .L1152+12
	bl	printf
	ldr	r0, .L1152+16
	ldr	r1, .L1152+20
	bl	printf
.L1136:
	movs	r0, #0
	add	sp, sp, #40
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1153:
	.align	2
.L1152:
	.word	.LANCHOR123
	.word	.LANCHOR80
	.word	.LANCHOR197
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlGetLastWrittenPage,"ax",%progbits
	.align	1
	.global	FtlGetLastWrittenPage
	.thumb
	.thumb_func
	.type	FtlGetLastWrittenPage, %function
FtlGetLastWrittenPage:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #1
	push	{r4, r5, r6, r7, r8, sl, lr}
	sub	sp, sp, #108
	it	eq
	ldreq	r3, .L1165
	mov	r5, r1
	it	ne
	ldrne	r3, .L1165+4
	add	sl, sp, #68
	lsl	r8, r0, #10
	movs	r1, #1
	mov	r0, sl
	mov	r2, r5
	ldrh	r4, [r3, #0]
	add	r3, sp, #4
	str	r3, [sp, #80]
	movs	r7, #0
	subs	r4, r4, #1
	str	r7, [sp, #76]
	uxth	r4, r4
	sxth	r3, r4
	orr	r3, r3, r8
	str	r3, [sp, #72]
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L1158
	b	.L1163
.L1161:
	adds	r6, r6, r3
	movs	r1, #1
	mov	r0, sl
	mov	r2, r5
	add	r6, r6, r6, lsr #31
	ubfx	r6, r6, #1, #16
	sxth	r3, r6
	orr	r3, r3, r8
	str	r3, [sp, #72]
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L1159
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	bne	.L1159
	ldr	r3, [sp, #68]
	adds	r3, r3, #1
	beq	.L1159
	subs	r4, r6, #1
	uxth	r4, r4
	b	.L1163
.L1159:
	adds	r6, r6, #1
	uxth	r7, r6
.L1163:
	sxth	r6, r7
	sxth	r3, r4
	cmp	r6, r3
	ble	.L1161
.L1158:
	sxth	r0, r4
	add	sp, sp, #108
	pop	{r4, r5, r6, r7, r8, sl, pc}
.L1166:
	.align	2
.L1165:
	.word	.LANCHOR69
	.word	.LANCHOR68
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FtlLoadSysInfo,"ax",%progbits
	.align	1
	.global	FtlLoadSysInfo
	.thumb
	.thumb_func
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r4, #0
	ldr	r6, .L1188
	mov	r1, r4
	ldr	r5, .L1188+4
	ldr	r8, .L1188+60
	ldr	r3, [r6, #0]
	str	r4, [r5, #8]
	str	r3, [r5, #12]
	ldr	r3, .L1188+8
	ldrh	r2, [r3, #0]
	ldr	r3, .L1188+12
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r0, [r8, #0]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1184
	movs	r1, #1
	mov	fp, r8
	bl	FtlGetLastWrittenPage
	uxth	sl, r0
	mov	r7, r0
	add	r3, sl, #1
	strh	r3, [r8, #2]	@ movhi
	ldr	r8, .L1188+160
	ldr	r3, .L1188+16
	b	.L1169
.L1172:
	ldrh	r1, [fp, #0]
	sxth	r2, sl
	subs	r2, r2, r4
	ldr	r0, .L1188+4
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	ldr	r2, [r8, #0]
	movs	r1, #1
	str	r2, [r5, #8]
	mov	r2, r1
	str	r3, [sp, #4]
	bl	FlashReadPages
	ldr	r2, [r5, #0]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L1170
	ldr	r2, [r8, #0]
	ldr	r2, [r2, #0]
	cmp	r2, r3
	bne	.L1170
	ldr	r2, [r6, #0]
	ldrh	r1, [r2, #0]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L1171
.L1170:
	adds	r4, r4, #1
.L1169:
	subs	r2, r7, r4
	lsls	r2, r2, #16
	bpl	.L1172
	b	.L1187
.L1171:
	ldr	r3, .L1188+8
	ldrh	r2, [r3, #0]
	ldr	r3, .L1188+20
	adds	r2, r2, #24
	ldrh	r3, [r3, #0]
	cmp	r3, r2, lsl #1
	bcs	.L1174
	ldr	r1, .L1188+24
	mov	r2, #1512
	ldr	r0, .L1188+28
	bl	printf
	ldr	r0, .L1188+32
	ldr	r1, .L1188+36
	bl	printf
.L1174:
	ldr	r4, .L1188+4
	movs	r2, #48
	ldr	r5, .L1188+8
	ldr	r0, .L1188+40
	ldr	r1, [r4, #8]
	bl	memcpy
	ldr	r3, .L1188+12
	ldrh	r2, [r5, #0]
	ldr	r1, [r4, #8]
	ldr	r0, [r3, #0]
	adds	r1, r1, #48
	lsls	r2, r2, #1
	bl	memcpy
	ldrh	r2, [r5, #0]
	ldr	r0, .L1188+44
	add	r1, r2, #24
	ldr	r3, [r4, #8]
	lsrs	r2, r2, #3
	lsrs	r1, r1, #1
	ldr	r0, [r0, #0]
	adds	r2, r2, #4
	add	r1, r3, r1, lsl #2
	bl	memcpy
	ldr	r3, .L1188+48
	ldrh	r3, [r3, #0]
	cbz	r3, .L1175
	ldrh	r3, [r5, #0]
	ldr	r2, .L1188+52
	ldr	r0, .L1188+56
	lsrs	r1, r3, #3
	add	r1, r1, r3, lsl #1
	ldrh	r2, [r2, #0]
	adds	r1, r1, #52
	ldr	r3, [r4, #8]
	ubfx	r1, r1, #2, #14
	ldr	r0, [r0, #0]
	lsls	r2, r2, #2
	add	r1, r3, r1, lsl #2
	bl	memcpy
.L1175:
	ldr	r3, .L1188+40
	ldr	r2, .L1188+16
	ldr	r1, [r3, #0]
	cmp	r1, r2
	bne	.L1184
	ldrh	r4, [r3, #8]
	ldr	r2, .L1188+60
	strh	r4, [r2, #6]	@ movhi
	ldrb	r2, [r3, #10]	@ zero_extendqisi2
	ldr	r3, .L1188+64
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1184
	ldr	r3, .L1188+68
	ldr	r2, .L1188+72
	str	r4, [r3, #0]
	ldr	r3, .L1188+76
	ldrh	r3, [r3, #0]
	muls	r3, r4, r3
	str	r3, [r2, #0]
	ldr	r2, .L1188+80
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	ldr	r2, .L1188+84
	str	r3, [r2, #0]
	ldr	r3, .L1188+88
	ldr	r5, [r3, #0]
	ldr	r3, .L1188+92
	ldrh	r0, [r3, #6]
	ldr	r3, .L1188+96
	subs	r0, r5, r0
	subs	r0, r0, r4
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1188+100
	cmp	r4, r5
	strh	r0, [r3, #0]	@ movhi
	bls	.L1176
	ldr	r1, .L1188+24
	movw	r2, #1539
	ldr	r0, .L1188+28
	bl	printf
	ldr	r0, .L1188+32
	ldr	r1, .L1188+36
	bl	printf
.L1176:
	ldr	r3, .L1188+40
	ldr	r2, .L1188+104
	ldrh	r1, [r3, #16]
	ldrh	r0, [r3, #14]
	ldrh	r5, [r3, #18]
	lsrs	r4, r1, #6
	and	r1, r1, #63
	strb	r1, [r2, #6]
	ldrb	r1, [r3, #11]	@ zero_extendqisi2
	strh	r4, [r2, #2]	@ movhi
	movw	r4, #65535
	strh	r0, [r2, #0]	@ movhi
	strb	r1, [r2, #8]
	movs	r2, #0
	ldr	r1, .L1188+108
	strh	r2, [r1, #2]	@ movhi
	strh	r4, [r1, #0]	@ movhi
	strb	r2, [r1, #6]
	strb	r2, [r1, #8]
	ldr	r1, .L1188+112
	strh	r5, [r1, #0]	@ movhi
	ldrh	r5, [r3, #20]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r1, #6]
	ldrb	r5, [r3, #12]	@ zero_extendqisi2
	strh	r6, [r1, #2]	@ movhi
	strb	r5, [r1, #8]
	ldr	r1, .L1188+116
	ldrh	r5, [r3, #22]
	strh	r5, [r1, #0]	@ movhi
	ldrh	r5, [r3, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r1, #6]
	ldrb	r5, [r3, #13]	@ zero_extendqisi2
	strh	r6, [r1, #2]	@ movhi
	strb	r5, [r1, #8]
	ldr	r1, .L1188+120
	ldr	r5, [r3, #32]
	str	r2, [r1, #0]
	ldr	r1, .L1188+124
	str	r2, [r1, #0]
	ldr	r1, .L1188+128
	str	r2, [r1, #0]
	ldr	r1, .L1188+132
	str	r2, [r1, #0]
	ldr	r1, .L1188+136
	str	r5, [r1, #0]
	ldr	r1, .L1188+140
	str	r2, [r1, #0]
	ldr	r1, .L1188+144
	str	r2, [r1, #0]
	ldr	r1, .L1188+148
	str	r2, [r1, #0]
	ldr	r2, .L1188+152
	ldr	r1, [r3, #40]
	ldr	r5, [r2, #0]
	cmp	r1, r5
	it	hi
	strhi	r1, [r2, #0]
	ldr	r2, [r3, #36]
	ldr	r3, .L1188+156
	ldr	r1, [r3, #0]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3, #0]
	cmp	r0, r4
	beq	.L1179
	ldr	r0, .L1188+104
	bl	make_superblock
.L1179:
	ldr	r0, .L1188+112
	movw	r4, #65535
	ldrh	r3, [r0, #0]
	cmp	r3, r4
	beq	.L1180
	bl	make_superblock
.L1180:
	ldr	r0, .L1188+116
	ldrh	r3, [r0, #0]
	cmp	r3, r4
	beq	.L1181
	bl	make_superblock
.L1181:
	ldr	r0, .L1188+108
	movw	r3, #65535
	ldrh	r2, [r0, #0]
	cmp	r2, r3
	beq	.L1185
	bl	make_superblock
	b	.L1185
.L1184:
	mov	r0, #-1
	b	.L1168
.L1185:
	movs	r0, #0
.L1168:
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1187:
	ldr	r1, .L1188+24
	movw	r2, #1510
	ldr	r0, .L1188+28
	bl	printf
	ldr	r1, .L1188+36
	ldr	r0, .L1188+32
	bl	printf
	b	.L1171
.L1189:
	.align	2
.L1188:
	.word	.LANCHOR184
	.word	.LANCHOR198
	.word	.LANCHOR55
	.word	.LANCHOR101
	.word	1179929683
	.word	.LANCHOR73
	.word	.LANCHOR199
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR143
	.word	.LANCHOR119
	.word	.LANCHOR85
	.word	.LANCHOR82
	.word	.LANCHOR191
	.word	.LANCHOR196
	.word	.LANCHOR60
	.word	.LANCHOR200
	.word	.LANCHOR88
	.word	.LANCHOR68
	.word	.LANCHOR71
	.word	.LANCHOR84
	.word	.LANCHOR57
	.word	.LANCHOR90
	.word	.LANCHOR53
	.word	.LANCHOR201
	.word	.LANCHOR109
	.word	.LANCHOR202
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR163
	.word	.LANCHOR162
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR161
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR98
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlLoadBbt,"ax",%progbits
	.align	1
	.global	FtlLoadBbt
	.thumb
	.thumb_func
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r3, #0
	ldr	r6, .L1209
	movw	sl, #61649
	str	r3, [r6, #8]
	ldr	r3, .L1209+4
	ldr	r4, [r3, #0]
	str	r4, [r6, #12]
	bl	FtlBbtMemInit
	ldr	r3, .L1209+8
	mov	r8, r3
	ldrh	r5, [r3, #0]
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1191
.L1195:
	movs	r1, #1
	ldr	r0, .L1209
	mov	r2, r1
	lsls	r3, r5, #10
	str	r3, [r6, #4]
	bl	FlashReadPages
	ldr	r3, [r6, #0]
	ldr	r7, .L1209
	adds	r3, r3, #1
	bne	.L1192
	ldr	r3, [r6, #4]
	movs	r1, #1
	mov	r0, r7
	mov	r2, r1
	adds	r3, r3, #1
	str	r3, [r6, #4]
	bl	FlashReadPages
.L1192:
	ldr	r3, [r7, #0]
	adds	r3, r3, #1
	beq	.L1193
	ldrh	r3, [r4, #0]
	cmp	r3, sl
	bne	.L1193
	ldr	r3, .L1209+12
	ldr	r2, [r4, #4]
	strh	r5, [r3, #0]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r4, #8]
	strh	r2, [r3, #4]	@ movhi
	b	.L1194
.L1193:
	subs	r5, r5, #1
	uxth	r5, r5
.L1191:
	ldrh	r3, [r8, #0]
	subs	r3, r3, #47
	cmp	r3, r5
	ble	.L1195
.L1194:
	ldr	r5, .L1209+12
	movw	r3, #65535
	ldrh	r2, [r5, #0]
	cmp	r2, r3
	beq	.L1206
	ldrh	r2, [r5, #4]
	cmp	r2, r3
	beq	.L1197
	ldr	r6, .L1209
	movs	r1, #1
	lsls	r2, r2, #10
	mov	r0, r6
	str	r2, [r6, #4]
	mov	r2, r1
	bl	FlashReadPages
	ldr	r3, [r6, #0]
	adds	r3, r3, #1
	beq	.L1197
	ldrh	r2, [r4, #0]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1197
	ldr	r3, [r4, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L1197
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r4, #8]
	strh	r2, [r5, #0]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L1197:
	ldr	fp, .L1209+12
	movs	r1, #1
	movs	r5, #0
	ldr	r6, .L1209
	ldr	r8, .L1209+48
	ldrh	r0, [fp, #0]
	bl	FtlGetLastWrittenPage
	uxth	sl, r0
	mov	r7, r0
	add	r3, sl, #1
	strh	r3, [fp, #2]	@ movhi
	sxth	sl, sl
	movw	r3, #61649
	b	.L1198
.L1201:
	ldrh	r1, [fp, #0]
	rsb	r2, r5, sl
	ldr	r0, .L1209
	orr	r2, r2, r1, lsl #10
	str	r2, [r6, #4]
	ldr	r2, [r8, #0]
	movs	r1, #1
	str	r3, [sp, #4]
	str	r2, [r6, #8]
	mov	r2, r1
	bl	FlashReadPages
	ldr	r2, [r6, #0]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L1199
	ldrh	r2, [r4, #0]
	cmp	r2, r3
	beq	.L1200
.L1199:
	adds	r5, r5, #1
.L1198:
	subs	r2, r7, r5
	lsls	r1, r2, #16
	bpl	.L1201
	b	.L1208
.L1200:
	ldr	r3, .L1209+12
	ldrh	r2, [r4, #10]
	ldrh	r0, [r4, #12]
	strh	r2, [r3, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1203
	ldr	r3, .L1209+16
	ldr	r2, [r3, #0]
	cmp	r0, r2
	beq	.L1203
	ldr	r3, .L1209+20
	ldrh	r3, [r3, #0]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L1203
	cmp	r0, r3
	bcs	.L1203
	bl	FtlSysBlkNumInit
.L1203:
	ldr	r5, .L1209+24
	movs	r4, #0
	ldr	r8, .L1209+52
	ldr	r7, .L1209+28
	ldr	r6, .L1209
	b	.L1204
.L1205:
	ldrh	r2, [r7, #0]
	ldr	r1, [r6, #8]
	ldr	r0, [r5, #4]!
	lsls	r2, r2, #2
	mla	r1, r4, r2, r1
	bl	memcpy
	adds	r4, r4, #1
.L1204:
	ldrh	r3, [r8, #0]
	cmp	r4, r3
	bcc	.L1205
	movs	r0, #0
	b	.L1196
.L1206:
	mov	r0, #-1
.L1196:
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1208:
	ldr	r1, .L1209+32
	mov	r2, #336
	ldr	r0, .L1209+36
	bl	printf
	ldr	r1, .L1209+40
	ldr	r0, .L1209+44
	bl	printf
	b	.L1200
.L1210:
	.align	2
.L1209:
	.word	.LANCHOR198
	.word	.LANCHOR184
	.word	.LANCHOR66
	.word	.LANCHOR90
	.word	.LANCHOR52
	.word	.LANCHOR56
	.word	.LANCHOR90+24
	.word	.LANCHOR91
	.word	.LANCHOR203
	.word	.LC9
	.word	.LC11
	.word	.LC10
	.word	.LANCHOR98
	.word	.LANCHOR60
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.FtlLoadFactoryBbt,"ax",%progbits
	.align	1
	.global	FtlLoadFactoryBbt
	.thumb
	.thumb_func
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1218
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r5, #0
	ldr	r7, .L1218+4
	ldr	r3, [r3, #0]
	ldr	r6, .L1218+8
	ldr	r8, .L1218+20
	str	r3, [r7, #8]
	ldr	r3, .L1218+12
	ldr	sl, [r3, #0]
	ldr	r3, .L1218+16
	str	sl, [r7, #12]
	b	.L1212
.L1217:
	ldrh	r4, [r8, #0]
	movw	r2, #65535
	movw	fp, #61664
	strh	r2, [r6], #2	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1213
.L1216:
	mla	r2, r2, r5, r4
	movs	r1, #1
	ldr	r0, .L1218+4
	lsls	r2, r2, #10
	str	r2, [r7, #4]
	mov	r2, r1
	str	r3, [sp, #4]
	bl	FlashReadPages
	ldr	r2, [r7, #0]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L1214
	ldrh	r2, [sl, #0]
	cmp	r2, fp
	bne	.L1214
	strh	r4, [r6, #-2]	@ movhi
	b	.L1215
.L1214:
	subs	r4, r4, #1
	uxth	r4, r4
.L1213:
	ldrh	r2, [r8, #0]
	sub	r1, r2, #15
	cmp	r1, r4
	ble	.L1216
.L1215:
	adds	r5, r5, #1
.L1212:
	ldrh	r2, [r3, #0]
	cmp	r5, r2
	bcc	.L1217
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1219:
	.align	2
.L1218:
	.word	.LANCHOR98
	.word	.LANCHOR198
	.word	.LANCHOR90+12
	.word	.LANCHOR184
	.word	.LANCHOR60
	.word	.LANCHOR66
	.size	FtlLoadFactoryBbt, .-FtlLoadFactoryBbt
	.section	.text.FlashProgSlc2KPages,"ax",%progbits
	.align	1
	.global	FlashProgSlc2KPages
	.thumb
	.thumb_func
	.type	FlashProgSlc2KPages, %function
FlashProgSlc2KPages:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #64
	mov	sl, r0
	mov	fp, r1
	str	r3, [sp, #12]
	mov	r5, r0
	ldr	r3, .L1238
	movs	r6, #0
	str	r2, [sp, #8]
	ldr	r7, .L1238+4
	ldrb	r8, [r3, #9]	@ zero_extendqisi2
	b	.L1221
.L1228:
	rsb	r3, r6, fp
	ldr	r1, [sp, #8]
	add	r2, sp, #56
	mov	r0, r5
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #60
	bl	LogAddr2PhyAddr
	ldr	r1, .L1238+8
	ldr	r3, [sp, #60]
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bcc	.L1222
	mov	r3, #-1
	str	r3, [r5, #0]
	b	.L1223
.L1222:
	ldr	r2, .L1238+12
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r0, r4
	ldr	r1, [sp, #56]
	bl	FlashProgFirstCmd
	ldr	r3, [r5, #12]
	mov	r2, r8
	movs	r1, #1
	mov	r0, r4
	str	r3, [sp, #0]
	ldr	r3, [r5, #8]
	bl	NandcXferData
	ldr	r1, [sp, #56]
	mov	r0, r4
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #56]
	mov	r0, r4
	bl	FlashReadStatus
	ldr	r3, [sp, #56]
	ldr	r1, [r7, #0]
	adds	r1, r1, r3
	ands	r0, r0, #1
	it	ne
	movne	r0, #-1
	str	r0, [r5, #0]
	mov	r0, r4
	bl	FlashProgFirstCmd
	ldr	r3, [r5, #8]
	cbz	r3, .L1225
	add	r3, r3, #2048
.L1225:
	ldr	r2, [r5, #12]
	cbz	r2, .L1226
	adds	r2, r2, #8
.L1226:
	movs	r1, #1
	str	r2, [sp, #0]
	mov	r0, r4
	mov	r2, r8
	bl	NandcXferData
	ldr	r3, [sp, #56]
	ldr	r1, [r7, #0]
	mov	r0, r4
	adds	r1, r1, r3
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	ldr	r1, [sp, #56]
	bl	FlashReadStatus
	lsls	r3, r0, #31
	mov	r0, r4
	itt	mi
	movmi	r3, #-1
	strmi	r3, [r5, #0]
	bl	NandcFlashDeCs
.L1223:
	adds	r6, r6, #1
	adds	r5, r5, #36
.L1221:
	cmp	r6, fp
	bne	.L1228
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L1229
	movs	r5, #0
	add	r4, sl, #8
	ldr	r6, .L1238+16
	mov	sl, r5
	ldr	r8, .L1238+36
	b	.L1230
.L1235:
	ldr	r3, [r4, #-8]
	sub	r7, r4, #8
	adds	r3, r3, #1
	bne	.L1231
	ldr	r1, [r4, #-4]
	ldr	r0, .L1238+20
	bl	printf
	b	.L1232
.L1231:
	rsb	r3, sl, fp
	mov	r0, r7
	ldr	r1, [sp, #8]
	add	r2, sp, #56
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #60
	add	r5, sp, #20
	bl	LogAddr2PhyAddr
	ldr	lr, [r6, #0]
	ldr	ip, [r8, #0]
	movs	r3, #0
	str	r3, [lr, #0]
	str	r3, [ip, #0]
	ldmia	r7!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	ldmia	r7!, {r0, r1, r2, r3}
	str	lr, [sp, #28]
	str	ip, [sp, #32]
	stmia	r5!, {r0, r1, r2, r3}
	movs	r1, #1
	ldr	r3, [r7, #0]
	add	r0, sp, #20
	ldr	r2, [sp, #8]
	str	r3, [r5, #0]
	bl	FlashReadPages
	ldr	r5, [sp, #20]
	adds	r0, r5, #1
	bne	.L1233
	ldr	r0, .L1238+24
	ldr	r1, [r4, #-4]
	bl	printf
	str	r5, [r4, #-8]
.L1233:
	ldr	r3, [r4, #4]
	cbz	r3, .L1234
	ldr	r2, [r3, #0]
	ldr	r3, [r8, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1234
	ldr	r0, .L1238+28
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1234:
	ldr	r3, [r4, #0]
	cbz	r3, .L1232
	ldr	r2, [r3, #0]
	ldr	r3, [r6, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1232
	ldr	r0, .L1238+32
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1232:
	add	sl, sl, #1
	adds	r4, r4, #36
.L1230:
	cmp	sl, fp
	bne	.L1235
.L1229:
	movs	r0, #0
	add	sp, sp, #64
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1239:
	.align	2
.L1238:
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR204
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LANCHOR205
	.size	FlashProgSlc2KPages, .-FlashProgSlc2KPages
	.section	.text.FlashProgPages,"ax",%progbits
	.align	1
	.global	FlashProgPages
	.thumb
	.thumb_func
	.type	FlashProgPages, %function
FlashProgPages:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #72
	ldr	r4, .L1267
	mov	r8, r0
	str	r1, [sp, #8]
	mov	fp, r2
	str	r3, [sp, #16]
	ldr	r4, [r4, #0]
	ldrb	r4, [r4, #19]	@ zero_extendqisi2
	str	r4, [sp, #20]
	ldr	r4, .L1267+4
	ldrb	r4, [r4, #9]	@ zero_extendqisi2
	str	r4, [sp, #12]
	ldr	r4, .L1267+8
	ldrb	r5, [r4, #0]	@ zero_extendqisi2
	cmp	r5, #0
	beq	.L1264
	bl	FlashProgSlc2KPages
	b	.L1242
.L1254:
	ldr	r1, [sp, #8]
	movs	r4, #36
	muls	r4, r5, r4
	add	r6, r8, r4
	subs	r3, r1, r5
	mov	r0, r6
	mov	r1, fp
	add	r2, sp, #64
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #68
	bl	LogAddr2PhyAddr
	ldr	r3, .L1267+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	mov	r7, r0
	ldr	r0, [sp, #68]
	cmp	r0, r3
	bcc	.L1243
	mov	r3, #-1
	str	r3, [r8, r4]
	b	.L1244
.L1243:
	ldr	r3, .L1267+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r7, #0
	add	r3, sl, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1246
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1246:
	ldr	r2, [sp, #68]
	ldr	r1, .L1267+20
	add	r3, r1, r2, lsl #4
	movs	r1, #0
	str	r1, [r3, #12]
	ldr	r1, [sp, #64]
	str	r6, [r3, #8]
	str	r1, [r3, #4]
	cbz	r7, .L1247
	adds	r1, r5, #1
	movs	r0, #36
	mla	r1, r0, r1, r8
	str	r1, [r3, #12]
.L1247:
	ldr	r3, .L1267+24
	ldrb	r4, [r3, r2]	@ zero_extendqisi2
	lsls	r2, r2, #4
	ldr	r3, .L1267+12
	mov	r0, r4
	strb	r4, [sl, r2]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1248
	bl	NandcWaitFlashReady
	b	.L1249
.L1248:
	bl	NandcFlashCs
	ldr	r2, [sp, #68]
	ldr	r3, .L1267+28
	mov	r0, r4
	ldr	r1, [sp, #64]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r4
	bl	NandcFlashDeCs
.L1249:
	ldr	r2, [sp, #20]
	subs	r3, r2, #1
	cmp	r3, #6
	bhi	.L1250
	ldr	r3, .L1267+32
	ldrb	r3, [r3, r4]	@ zero_extendqisi2
	cbz	r3, .L1250
	ldr	r3, .L1267+36
	mov	r0, r4
	adds	r2, r3, #4
	ldrb	r1, [r3, #1]	@ zero_extendqisi2
	movs	r3, #0
	bl	HynixSetRRPara
.L1250:
	mov	r0, r4
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r4
	bne	.L1251
	ldr	r3, .L1267+40
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1251
	bl	flash_enter_slc_mode
	b	.L1252
.L1251:
	bl	flash_exit_slc_mode
.L1252:
	mov	r0, r4
	ldr	r1, [sp, #64]
	bl	FlashProgFirstCmd
	ldr	r3, [r6, #12]
	mov	r0, r4
	movs	r1, #1
	ldr	r2, [sp, #12]
	str	r3, [sp, #0]
	ldr	r3, [r6, #8]
	bl	NandcXferData
	cbz	r7, .L1253
	mov	r0, r4
	ldr	r1, [sp, #64]
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1267+28
	ldr	r2, [sp, #68]
	mov	r0, r4
	ldr	r1, [sp, #64]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	ldr	r3, .L1267+44
	mov	r0, r4
	ldr	r1, [r3, #0]
	ldr	r3, [sp, #64]
	adds	r1, r1, r3
	bl	FlashProgDpSecondCmd
	movs	r2, #36
	adds	r3, r5, #1
	mov	r0, r4
	movs	r1, #1
	mla	r3, r2, r3, r8
	ldr	r2, [r3, #12]
	str	r2, [sp, #0]
	ldr	r2, [sp, #12]
	ldr	r3, [r3, #8]
	bl	NandcXferData
.L1253:
	mov	r0, r4
	ldr	r1, [sp, #64]
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcFlashDeCs
	adds	r5, r5, r7
.L1244:
	adds	r5, r5, #1
	b	.L1241
.L1264:
	ldr	sl, .L1267+20
.L1241:
	ldr	r1, [sp, #8]
	cmp	r5, r1
	bcc	.L1254
	movs	r4, #0
	ldr	r7, .L1267+12
	ldr	r6, .L1267+40
	ldr	r5, .L1267+20
	b	.L1255
.L1257:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L1256
	ldrb	r3, [r6, #0]	@ zero_extendqisi2
	cbz	r3, .L1256
	lsls	r3, r4, #4
	ldrb	r0, [r5, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1256:
	adds	r4, r4, #1
.L1255:
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1257
	ldr	r2, [sp, #16]
	cmp	r2, #0
	beq	.L1266
	movs	r5, #0
	add	r4, r8, #8
	ldr	r6, .L1267+48
	mov	sl, r5
	ldr	r8, .L1267+68
	b	.L1258
.L1263:
	ldr	r3, [r4, #-8]
	sub	r7, r4, #8
	adds	r3, r3, #1
	bne	.L1259
	ldr	r1, [r4, #-4]
	ldr	r0, .L1267+52
	bl	printf
	b	.L1260
.L1259:
	ldr	r1, [sp, #8]
	mov	r0, r7
	add	r2, sp, #64
	add	r5, sp, #28
	rsb	r3, sl, r1
	mov	r1, fp
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #68
	bl	LogAddr2PhyAddr
	ldr	lr, [r6, #0]
	ldr	ip, [r8, #0]
	movs	r3, #0
	str	r3, [lr, #0]
	str	r3, [ip, #0]
	ldmia	r7!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	ldmia	r7!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	movs	r1, #1
	ldr	r3, [r7, #0]
	mov	r2, fp
	add	r0, sp, #28
	str	lr, [sp, #36]
	str	ip, [sp, #40]
	str	r3, [r5, #0]
	bl	FlashReadPages
	ldr	r5, [sp, #28]
	adds	r2, r5, #1
	bne	.L1261
	ldr	r0, .L1267+56
	ldr	r1, [r4, #-4]
	bl	printf
	str	r5, [r4, #-8]
.L1261:
	ldr	r3, [r4, #4]
	cbz	r3, .L1262
	ldr	r2, [r3, #0]
	ldr	r3, [r8, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1262
	ldr	r0, .L1267+60
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1262:
	ldr	r3, [r4, #0]
	cbz	r3, .L1260
	ldr	r2, [r3, #0]
	ldr	r3, [r6, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1260
	ldr	r0, .L1267+64
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1260:
	add	sl, sl, #1
	adds	r4, r4, #36
.L1258:
	ldr	r2, [sp, #8]
	cmp	sl, r2
	bne	.L1263
	movs	r0, #0
	b	.L1242
.L1268:
	.align	2
.L1267:
	.word	.LANCHOR23
	.word	.LANCHOR18
	.word	.LANCHOR0
	.word	.LANCHOR16
	.word	.LANCHOR33
	.word	.LANCHOR21
	.word	.LANCHOR19
	.word	.LANCHOR20
	.word	.LANCHOR32
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR2
	.word	.LANCHOR204
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LANCHOR205
.L1266:
	ldr	r0, [sp, #16]
.L1242:
	add	sp, sp, #72
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FtlVpcTblFlush,"ax",%progbits
	.align	1
	.global	FtlVpcTblFlush
	.thumb
	.thumb_func
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1281
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1270
	ldr	r2, .L1281+4
	ldr	r6, .L1281+8
	ldr	r4, .L1281+12
	ldr	r0, [r2, #0]
	ldr	r2, .L1281+16
	ldr	r7, .L1281+20
	str	r0, [r6, #8]
	ldr	r5, [r2, #0]
	ldr	r2, .L1281+24
	str	r5, [r6, #12]
	ldrh	r1, [r2, #0]
	str	r3, [r5, #12]
	strh	r1, [r5, #2]	@ movhi
	movw	r1, #61604
	strh	r1, [r5, #0]	@ movhi
	ldr	r1, [r2, #8]
	str	r3, [r5, #8]
	ldr	r3, .L1281+28
	str	r1, [r5, #4]
	stmia	r4, {r3, r7}
	ldrh	r3, [r2, #6]
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L1281+32
	ldrh	r3, [r3, #0]
	strb	r3, [r4, #10]
	ldr	r3, .L1281+36
	ldrh	r2, [r3, #0]
	ldrh	r1, [r3, #2]
	strh	r2, [r4, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	strh	r2, [r4, #16]	@ movhi
	strb	r3, [r4, #11]
	ldr	r3, .L1281+40
	ldrh	r2, [r3, #0]
	ldrh	r1, [r3, #2]
	strh	r2, [r4, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	strh	r2, [r4, #20]	@ movhi
	strb	r3, [r4, #12]
	ldr	r3, .L1281+44
	ldrh	r2, [r3, #0]
	ldrh	r1, [r3, #2]
	strh	r2, [r4, #22]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	strh	r2, [r4, #24]	@ movhi
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	movs	r1, #255
	strb	r3, [r4, #13]
	ldr	r3, .L1281+48
	ldr	r3, [r3, #0]
	str	r3, [r4, #32]
	ldr	r3, .L1281+52
	ldr	r3, [r3, #0]
	str	r3, [r4, #40]
	ldr	r3, .L1281+56
	ldr	r3, [r3, #0]
	str	r3, [r4, #36]
	ldr	r3, .L1281+60
	ldrh	r2, [r3, #0]
	bl	memset
	mov	r1, r4
	ldr	r4, .L1281+64
	movs	r2, #48
	ldr	r0, [r6, #8]
	bl	memcpy
	ldr	r3, .L1281+68
	ldrh	r2, [r4, #0]
	ldr	r0, [r6, #8]
	ldr	r1, [r3, #0]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	memcpy
	ldrh	r2, [r4, #0]
	ldr	r3, [r6, #8]
	add	r0, r2, #24
	lsrs	r2, r2, #3
	lsrs	r0, r0, #1
	adds	r2, r2, #4
	add	r0, r3, r0, lsl #2
	ldr	r3, .L1281+72
	ldr	r1, [r3, #0]
	bl	memcpy
	ldr	r3, .L1281+76
	ldrh	r3, [r3, #0]
	cbz	r3, .L1271
	ldrh	r3, [r4, #0]
	ldr	r1, [r6, #8]
	lsrs	r0, r3, #3
	add	r0, r0, r3, lsl #1
	ldr	r3, .L1281+80
	adds	r0, r0, #52
	ubfx	r0, r0, #2, #14
	ldrh	r2, [r3, #0]
	ldr	r3, .L1281+84
	add	r0, r1, r0, lsl #2
	lsls	r2, r2, #2
	ldr	r1, [r3, #0]
	bl	memcpy
.L1271:
	movs	r0, #0
	ldr	r6, .L1281+8
	bl	FtlUpdateVaildLpn
	ldr	sl, .L1281+4
	ldr	fp, .L1281+16
	movs	r7, #0
	ldr	r4, .L1281+24
	movw	r8, #65535
.L1280:
	ldr	r3, [sl, #0]
	movs	r1, #1
	ldrh	r2, [r4, #0]
	ldr	r0, .L1281+8
	str	r3, [r6, #8]
	ldr	r3, [fp, #0]
	str	r3, [r6, #12]
	ldrh	r3, [r4, #2]
	orr	r3, r3, r2, lsl #10
	mov	r2, r1
	str	r3, [r6, #4]
	mov	r3, r1
	bl	FlashProgPages
	ldr	r3, .L1281+88
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1273
	ldrh	r3, [r4, #0]
	ldrh	r8, [r4, #4]
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r2, .L1281+52
	ldr	r3, [r2, #0]
	adds	r1, r3, #1
	str	r1, [r2, #0]
	movs	r1, #1
	str	r3, [r4, #8]
	lsls	r2, r0, #10
	strh	r0, [r4, #0]	@ movhi
	str	r2, [r6, #4]
	mov	r2, r1
	str	r3, [r5, #4]
	mov	r3, r1
	strh	r0, [r5, #2]	@ movhi
	ldr	r0, .L1281+8
	bl	FlashProgPages
.L1273:
	ldrh	r3, [r4, #2]
	ldr	r2, [r6, #0]
	adds	r3, r3, #1
	adds	r1, r2, #1
	uxth	r3, r3
	strh	r3, [r4, #2]	@ movhi
	bne	.L1274
	cmp	r3, #1
	bne	.L1275
	ldr	r1, .L1281+92
	movw	r2, #1180
	ldr	r0, .L1281+96
	bl	printf
	ldr	r0, .L1281+100
	ldr	r1, .L1281+104
	bl	printf
.L1275:
	ldr	r2, .L1281+24
	ldrh	r3, [r2, #2]
	cmp	r3, #1
	bne	.L1276
	ldr	r3, .L1281+88
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1276:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r7, #3
	bls	.L1280
	ldr	r3, .L1281+8
	mov	r2, r7
	ldr	r0, .L1281+108
	ldr	r1, [r3, #4]
	bl	printf
	ldr	r3, .L1281
	movs	r2, #1
	str	r2, [r3, #0]
	b	.L1270
.L1274:
	cmp	r3, #1
	beq	.L1280
	cmp	r2, #256
	beq	.L1280
	movw	r3, #65535
	cmp	r8, r3
	beq	.L1270
	mov	r0, r8
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L1270:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1282:
	.align	2
.L1281:
	.word	.LANCHOR94
	.word	.LANCHOR98
	.word	.LANCHOR198
	.word	.LANCHOR143
	.word	.LANCHOR184
	.word	1342177351
	.word	.LANCHOR196
	.word	1179929683
	.word	.LANCHOR60
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR164
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR73
	.word	.LANCHOR55
	.word	.LANCHOR101
	.word	.LANCHOR119
	.word	.LANCHOR85
	.word	.LANCHOR82
	.word	.LANCHOR126
	.word	.LANCHOR69
	.word	.LANCHOR206
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC25
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlBbmTblFlush,"ax",%progbits
	.align	1
	.global	FtlBbmTblFlush
	.thumb
	.thumb_func
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1295
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	ldr	r4, [r3, #0]
	cmp	r4, #0
	bne	.L1284
	ldr	r3, .L1295+4
	mov	r1, r4
	ldr	r7, .L1295+8
	ldr	r5, .L1295+12
	ldr	r0, [r3, #0]
	ldr	r3, .L1295+16
	ldr	r8, .L1295+52
	str	r0, [r7, #8]
	ldr	r3, [r3, #0]
	ldr	sl, .L1295+56
	str	r3, [r7, #12]
	ldr	r3, .L1295+20
	ldrh	r2, [r3, #0]
	bl	memset
	b	.L1285
.L1286:
	ldrh	r2, [sl, #0]
	ldr	r3, [r7, #8]
	ldr	r1, [r5, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	memcpy
.L1285:
	ldrh	r3, [r8, #0]
	ldr	r6, .L1295+8
	cmp	r4, r3
	blt	.L1286
	ldr	r5, [r6, #12]
	movs	r2, #16
	movs	r1, #255
	movs	r7, #0
	mov	r0, r5
	mov	r8, r7
	bl	memset
	movw	r3, #61649
	strh	r3, [r5, #0]	@ movhi
	ldr	r3, .L1295+24
	ldr	sl, .L1295+4
	ldr	fp, .L1295+16
	ldr	r2, [r3, #8]
	str	r2, [r5, #4]
	ldrh	r2, [r3, #0]
	strh	r2, [r5, #2]	@ movhi
	ldrh	r2, [r3, #4]
	ldrh	r3, [r3, #6]
	strh	r2, [r5, #8]	@ movhi
	strh	r3, [r5, #10]	@ movhi
	ldr	r3, .L1295+28
	ldr	r3, [r3, #0]
	strh	r3, [r5, #12]	@ movhi
	b	.L1294
.L1291:
	mov	r8, #1
.L1294:
	ldr	r3, [sl, #0]
	movs	r1, #0
	ldr	r4, .L1295+24
	ldrh	r0, [r5, #10]
	str	r3, [r6, #8]
	str	r1, [r6, #0]
	ldr	r3, [fp, #0]
	ldrh	r1, [r4, #0]
	ldrh	r2, [r4, #2]
	str	r3, [r6, #12]
	orr	r3, r2, r1, lsl #10
	str	r3, [r6, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp, #0]
	ldr	r0, .L1295+32
	bl	printf
	movs	r1, #1
	mov	r2, r1
	mov	r3, r1
	ldr	r0, .L1295+8
	bl	FlashProgPages
	ldr	r3, .L1295+36
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1288
	ldrh	r2, [r4, #0]
	movs	r1, #0
	ldr	r3, [r4, #8]
	strh	r1, [r4, #2]	@ movhi
	movs	r1, #1
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r5, #4]
	strh	r2, [r5, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1295+40
	strh	r3, [r4, #0]	@ movhi
	lsls	r3, r3, #10
	str	r3, [r6, #4]
	ldr	r0, [r2, #0]
	mov	r2, r1
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	movs	r1, #1
	ldr	r0, .L1295+8
	mov	r2, r1
	mov	r3, r1
	bl	FlashProgPages
.L1288:
	ldr	r3, .L1295+24
	ldrh	r2, [r3, #2]
	adds	r2, r2, #1
	strh	r2, [r3, #2]	@ movhi
	ldr	r3, [r6, #0]
	adds	r3, r3, #1
	bne	.L1289
	adds	r7, r7, #1
	ldr	r0, .L1295+44
	ldr	r1, [r6, #4]
	uxth	r7, r7
	bl	printf
	cmp	r7, #3
	bls	.L1294
	ldr	r3, .L1295+8
	mov	r2, r7
	ldr	r0, .L1295+48
	ldr	r1, [r3, #4]
	bl	printf
	ldr	r3, .L1295
	movs	r2, #1
	str	r2, [r3, #0]
	b	.L1284
.L1289:
	cmp	r8, #0
	beq	.L1291
.L1284:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1296:
	.align	2
.L1295:
	.word	.LANCHOR94
	.word	.LANCHOR98
	.word	.LANCHOR198
	.word	.LANCHOR90+24
	.word	.LANCHOR184
	.word	.LANCHOR73
	.word	.LANCHOR90
	.word	.LANCHOR52
	.word	.LC26
	.word	.LANCHOR69
	.word	.LANCHOR95
	.word	.LC27
	.word	.LC28
	.word	.LANCHOR60
	.word	.LANCHOR91
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.FtlGcFreeBadSuperBlk,"ax",%progbits
	.align	1
	.global	FtlGcFreeBadSuperBlk
	.thumb
	.thumb_func
	.type	FtlGcFreeBadSuperBlk, %function
FtlGcFreeBadSuperBlk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	sl, r0
	ldr	r5, .L1307
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1306
	b	.L1299
.L1305:
	ldr	r3, .L1307+4
	mov	r1, sl
	mov	fp, #0
	ldrb	r0, [r3, r4]	@ zero_extendqisi2
	bl	V2P_block
	mov	r3, r0
	b	.L1300
.L1304:
	ldrh	r2, [r7, fp, lsl #1]
	cmp	r2, r3
	bne	.L1301
	mov	r0, r3
	str	r3, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r1, [r5, #0]
	mov	r2, fp
	ldr	r3, [sp, #4]
	b	.L1302
.L1303:
	adds	r0, r2, #1
	ldrh	lr, [r6, r0, lsl #1]
	strh	lr, [r6, r2, lsl #1]	@ movhi
	uxth	r2, r0
.L1302:
	cmp	r2, r1
	bcc	.L1303
	subs	r1, r1, #1
	strh	r1, [r5, #0]	@ movhi
.L1301:
	add	fp, fp, #1
	uxth	fp, fp
.L1300:
	ldrh	r2, [r5, #0]
	cmp	r2, fp
	bhi	.L1304
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1298
.L1306:
	ldr	r7, .L1307+8
	movs	r4, #0
	ldr	r8, .L1307+12
	mov	r6, r7
.L1298:
	ldrh	r3, [r8, #0]
	cmp	r3, r4
	bhi	.L1305
	bl	FtlGcReFreshBadBlk
.L1299:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1308:
	.align	2
.L1307:
	.word	.LANCHOR151
	.word	.LANCHOR62
	.word	.LANCHOR152
	.word	.LANCHOR53
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",%progbits
	.align	1
	.global	update_vpc_list
	.thumb
	.thumb_func
	.type	update_vpc_list, %function
update_vpc_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L1319
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1310
	ldr	r2, .L1319+4
	ldrh	r1, [r2, #0]
	cmp	r1, r0
	bne	.L1311
	movw	r3, #65535
	strh	r3, [r2, #0]	@ movhi
	b	.L1312
.L1311:
	ldr	r2, .L1319+8
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1313
	ldr	r2, .L1319+12
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1313
	ldr	r2, .L1319+16
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1313
.L1312:
	ldr	r5, .L1319+20
	mov	r1, r4
	ldr	r0, .L1319+24
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1314
	ldr	r1, .L1319+28
	movw	r2, #3039
	ldr	r0, .L1319+32
	bl	printf
	ldr	r0, .L1319+36
	ldr	r1, .L1319+40
	bl	printf
.L1314:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1319+44
	ldrh	r2, [r3, #0]
	ldrh	r3, [r5, #0]
	adds	r2, r2, r3
	ldr	r3, .L1319+48
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1318
	ldr	r1, .L1319+28
	movw	r2, #3042
	ldr	r0, .L1319+32
	bl	printf
	ldr	r1, .L1319+40
	ldr	r0, .L1319+36
	bl	printf
	b	.L1318
.L1310:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1313
.L1318:
	movs	r3, #1
.L1313:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1320:
	.align	2
.L1319:
	.word	.LANCHOR101
	.word	.LANCHOR202
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR103
	.word	.LANCHOR100
	.word	.LANCHOR207
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR106
	.word	.LANCHOR55
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",%progbits
	.align	1
	.global	decrement_vpc_count
	.thumb
	.thumb_func
	.type	decrement_vpc_count, %function
decrement_vpc_count:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #65535
	cmp	r0, r3
	push	{r4, r5, r6, lr}
	mov	r4, r0
	beq	.L1322
	ldr	r6, .L1328
	ldr	r3, [r6, #0]
	ldrh	r5, [r3, r0, lsl #1]
	cbnz	r5, .L1323
	mov	r1, r4
	ldr	r0, .L1328+4
	mov	r2, r5
	bl	printf
	ldr	r3, [r6, #0]
	ldrh	r4, [r3, r4, lsl #1]
	cmp	r4, #0
	bne	.L1324
	ldr	r1, .L1328+8
	movw	r2, #3057
	ldr	r0, .L1328+12
	mov	r5, r4
	bl	printf
	ldr	r0, .L1328+16
	ldr	r1, .L1328+20
	bl	printf
	b	.L1324
.L1323:
	subs	r5, r5, #1
	strh	r5, [r3, r0, lsl #1]	@ movhi
.L1322:
	ldr	r6, .L1328+24
	movw	r3, #65535
	ldrh	r0, [r6, #0]
	cmp	r0, r3
	bne	.L1325
	strh	r4, [r6, #0]	@ movhi
	b	.L1327
.L1325:
	cmp	r0, r4
	beq	.L1327
	bl	update_vpc_list
	ldr	r3, .L1328+28
	strh	r4, [r6, #0]	@ movhi
	ldr	r2, [r3, #0]
	ldr	r3, .L1328+32
	ldr	r3, [r3, #0]
	subs	r3, r2, r3
	ldr	r2, .L1328+36
	adds	r5, r0, #0
	it	ne
	movne	r5, #1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	ldr	r2, .L1328
	uxth	r3, r3
	ldr	r2, [r2, #0]
	ldrh	r2, [r2, r3, lsl #1]
	cbnz	r2, .L1324
	cmp	r4, r3
	beq	.L1324
	ldr	r1, .L1328+8
	movw	r2, #3079
	ldr	r0, .L1328+12
	bl	printf
	ldr	r1, .L1328+20
	ldr	r0, .L1328+16
	bl	printf
	b	.L1324
.L1327:
	movs	r5, #0
.L1324:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1329:
	.align	2
.L1328:
	.word	.LANCHOR101
	.word	.LC29
	.word	.LANCHOR208
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR138
	.word	.LANCHOR100
	.word	.LANCHOR99
	.word	-1431655765
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.get_new_active_ppa,"ax",%progbits
	.align	1
	.global	get_new_active_ppa
	.thumb
	.thumb_func
	.type	get_new_active_ppa, %function
get_new_active_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0, #0]
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	movw	r3, #65535
	cmp	r2, r3
	mov	r4, r0
	bne	.L1331
	ldr	r1, .L1346
	movw	r2, #2979
	ldr	r0, .L1346+4
	bl	printf
	ldr	r0, .L1346+8
	ldr	r1, .L1346+12
	bl	printf
.L1331:
	ldr	r3, .L1346+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1332
	ldr	r1, .L1346
	movw	r2, #2980
	ldr	r0, .L1346+4
	bl	printf
	ldr	r0, .L1346+8
	ldr	r1, .L1346+12
	bl	printf
.L1332:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1333
	ldr	r1, .L1346
	movw	r2, #2981
	ldr	r0, .L1346+4
	bl	printf
	ldr	r0, .L1346+8
	ldr	r1, .L1346+12
	bl	printf
.L1333:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movs	r7, #0
	movw	r6, #65535
	strb	r7, [r4, #10]
	adds	r3, r3, #8
	ldr	sl, .L1346+24
	ldr	r8, .L1346+28
	ldrh	r3, [r4, r3, lsl #1]
	ldr	r5, .L1346+20
	b	.L1334
.L1335:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r5, #0]
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1336
	ldrh	r3, [r4, #2]
	strb	r7, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1336:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
.L1334:
	cmp	r3, r6
	beq	.L1335
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L1337
	ldrb	r2, [sl, #0]	@ zero_extendqisi2
	cbnz	r2, .L1337
	ldrh	r2, [r4, #2]
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r2, r6
	bne	.L1337
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1335
.L1337:
	ldrh	r5, [r4, #2]
	movw	r6, #65535
	ldr	sl, .L1346+20
	mov	r8, r6
	ldr	r7, .L1346+24
	orr	r5, r5, r3, lsl #10
	ldrh	r3, [r4, #4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1342:
	ldrh	r2, [sl, #0]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
.L1339:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r2
	bne	.L1338
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
.L1338:
	add	r1, r3, #8
	ldrh	r1, [r4, r1, lsl #1]
	cmp	r1, r6
	beq	.L1339
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1340
	ldrb	r2, [r7, #0]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r2, .L1344
	ldr	r2, .L1346+28
	ldrh	r3, [r2, r3, lsl #1]
	cmp	r3, r8
	bne	.L1340
	ldrh	r3, [r4, #4]
	cbz	r3, .L1340
	subs	r3, r3, #1
	ldrh	r0, [r4, #0]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1342
.L1344:
	ldr	r2, .L1346+32
	ldrh	r2, [r2, #0]
	cmp	r3, r2
	bcc	.L1340
	ldr	r3, .L1346+36
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #4]	@ movhi
	mov	r2, r3	@ movhi
	ldr	r3, .L1346+16
	strb	r2, [r4, #6]
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
.L1340:
	ldr	r3, .L1346+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1343
	ldrh	r3, [r4, #4]
	cbz	r3, .L1343
	ldr	r1, .L1346
	movw	r2, #3025
	ldr	r0, .L1346+4
	bl	printf
	ldr	r0, .L1346+8
	ldr	r1, .L1346+12
	bl	printf
.L1343:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1347:
	.align	2
.L1346:
	.word	.LANCHOR209
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR68
	.word	.LANCHOR53
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR69
	.word	.LANCHOR101
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlSlcSuperblockCheck,"ax",%progbits
	.align	1
	.global	FtlSlcSuperblockCheck
	.thumb
	.thumb_func
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	mov	r4, r0
	ldrh	r3, [r0, #4]
	cmp	r3, #0
	beq	.L1348
	ldrh	r3, [r0, #0]
	movw	r5, #65535
	cmp	r3, r5
	beq	.L1348
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	movs	r6, #0
	ldr	sl, .L1354+4
	adds	r3, r3, #8
	ldr	r8, .L1354+20
	ldr	r7, .L1354
	ldrh	r3, [r0, r3, lsl #1]
	b	.L1350
.L1351:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7, #0]
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1352
	ldrh	r3, [r4, #2]
	strb	r6, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1352:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
.L1350:
	cmp	r3, r5
	beq	.L1351
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1353
	ldrb	r2, [sl, #0]	@ zero_extendqisi2
	cbnz	r2, .L1353
	ldrh	r2, [r4, #2]
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r2, r5
	bne	.L1353
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	bne	.L1351
	ldrh	r2, [r4, #2]
	strb	r3, [r4, #6]
	adds	r2, r2, #1
	strh	r2, [r4, #2]	@ movhi
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1353:
	ldr	r2, .L1354+4
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1348
	cmp	r3, #1
	bne	.L1348
	ldr	r3, .L1354+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1348
	ldr	r3, .L1354+12
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #4]	@ movhi
	mov	r2, r3	@ movhi
	ldr	r3, .L1354+16
	strb	r2, [r4, #6]
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
.L1348:
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1355:
	.align	2
.L1354:
	.word	.LANCHOR53
	.word	.LANCHOR7
	.word	.LANCHOR69
	.word	.LANCHOR101
	.word	.LANCHOR68
	.word	.LANCHOR9
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.allocate_data_superblock,"ax",%progbits
	.align	1
	.global	allocate_data_superblock
	.thumb
	.thumb_func
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1401
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r3, [r3, #0]
	sub	sp, sp, #24
	cmp	r3, #0
	bne	.L1357
	ldr	r7, .L1401+4
	ldr	r8, .L1401+104
.L1397:
	ldr	r1, .L1401+8
	ldrh	r2, [r7, #0]
	ldrh	r3, [r1, #0]
	adds	r2, r2, r3
	ldr	r3, .L1401+12
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1359
	ldr	r1, .L1401+16
	movw	r2, #2815
	ldr	r0, .L1401+20
	bl	printf
	ldr	r0, .L1401+24
	ldr	r1, .L1401+28
	bl	printf
.L1359:
	ldr	r3, .L1401+32
	cmp	r4, r3
	bne	.L1360
	ldr	r3, .L1401+36
	ldrh	r2, [r7, #0]
	ldr	r3, [r3, #0]
	lsrs	r1, r2, #1
	adds	r0, r1, #1
	mul	r5, r3, r2
	add	r0, r0, r5, lsr #2
	ldr	r5, .L1401+40
	uxth	r0, r0
	ldr	r5, [r5, #0]
	cbz	r5, .L1389
	ldr	r5, .L1401+44
	ldr	r5, [r5, #0]
	cmp	r5, #29
	bhi	.L1389
	cmp	r5, #2
	bls	.L1394
	lsls	r0, r2, #31
	bpl	.L1361
	cbz	r3, .L1391
	b	.L1361
.L1360:
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1394
	ldr	r3, .L1401+48
	ldrh	r3, [r3, #0]
	cmp	r3, #1
	beq	.L1394
	ldr	r3, .L1401+52
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1394
	ldr	r2, .L1401+40
	ldrh	r3, [r7, #0]
	ldr	r2, [r2, #0]
	lsrs	r1, r3, #3
	cbz	r2, .L1361
	ldr	r2, .L1401+44
	ldr	r2, [r2, #0]
	cmp	r2, #1
	bhi	.L1361
	movs	r1, #7
	muls	r1, r3, r1
	lsrs	r1, r1, #3
	b	.L1361
.L1389:
	mov	r1, r0
.L1361:
	cbz	r1, .L1362
	subs	r1, r1, #1
	uxth	r1, r1
	b	.L1362
.L1391:
	mov	r1, r3
	b	.L1362
.L1394:
	movs	r1, #0
.L1362:
	ldr	r0, .L1401+56
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	bl	List_pop_index_node
	ldrh	r3, [r7, #0]
	uxth	r5, r0
	cbnz	r3, .L1363
	ldr	r1, .L1401+16
	movw	r2, #2835
	ldr	r0, .L1401+20
	bl	printf
	ldr	r0, .L1401+24
	ldr	r1, .L1401+28
	bl	printf
.L1363:
	ldr	r2, .L1401+4
	mov	r0, r4
	ldrh	r3, [r2, #0]
	subs	r3, r3, #1
	strh	r3, [r2, #0]	@ movhi
	strh	r5, [r4, #0]	@ movhi
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1364
	ldr	r3, .L1401+60
	movw	r2, #65535
	ldr	r1, .L1401+8
	ldr	r3, [r3, #0]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrh	r3, [r1, #0]
	ldrh	r2, [r7, #0]
	adds	r2, r2, r3
	ldr	r3, .L1401+12
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1397
	ldr	r1, .L1401+16
	movw	r2, #2847
	ldr	r0, .L1401+20
	bl	printf
	ldr	r1, .L1401+28
	ldr	r0, .L1401+24
	bl	printf
	b	.L1397
.L1364:
	ldr	r1, .L1401+8
	ldrh	r2, [r7, #0]
	ldrh	r3, [r1, #0]
	adds	r2, r2, r3
	ldr	r3, .L1401+12
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1366
	ldr	r1, .L1401+16
	movw	r2, #2850
	ldr	r0, .L1401+20
	bl	printf
	ldr	r0, .L1401+24
	ldr	r1, .L1401+28
	bl	printf
.L1366:
	ldr	r3, .L1401+64
	movs	r6, #0
	ldr	lr, [r8, #0]
	mov	sl, r4
	mov	r1, r4
	mov	r2, r6
	ldrh	r3, [r3, #0]
	mov	r0, r6
	stmia	sp, {r4, lr}
	str	r3, [sp, #20]
	mov	r3, lr
	b	.L1367
.L1369:
	str	r0, [r3, #8]
	movw	r4, #65535
	str	r0, [r3, #12]
	ldrh	ip, [r1, #16]
	cmp	ip, r4
	beq	.L1368
	ldr	r4, [sp, #4]
	mov	lr, #36
	lsl	ip, ip, #10
	mla	fp, lr, r6, r4
	adds	r6, r6, #1
	uxth	r6, r6
	str	ip, [fp, #4]
.L1368:
	adds	r2, r2, #1
	adds	r3, r3, #36
	adds	r1, r1, #2
	uxth	r2, r2
.L1367:
	ldr	r4, [sp, #20]
	cmp	r2, r4
	bne	.L1369
	ldr	r4, [sp, #0]
	cbnz	r6, .L1370
	ldr	r1, .L1401+16
	movw	r2, #2862
	ldr	r0, .L1401+20
	bl	printf
	ldr	r0, .L1401+24
	ldr	r1, .L1401+28
	bl	printf
.L1370:
	ldr	r3, .L1401+40
	ldr	r3, [r3, #0]
	cbz	r3, .L1371
	ldr	r3, .L1401+68
	cmp	r4, r3
	bne	.L1371
	ldr	r3, .L1401+72
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #30
	bls	.L1371
	movs	r3, #0
	strb	r3, [r4, #8]
.L1371:
	ldr	r3, .L1401+76
	ldrh	r3, [r3, #0]
	cmp	r3, r5
	bne	.L1372
	ldr	r1, .L1401+16
	movw	r2, #2869
	ldr	r0, .L1401+20
	bl	printf
	ldr	r0, .L1401+24
	ldr	r1, .L1401+28
	bl	printf
.L1372:
	ldr	r3, .L1401+72
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, [r3, #0]
	cbnz	r2, .L1373
	ldrh	r2, [r3, r5, lsl #1]
	cbz	r2, .L1374
	ldr	r1, .L1401+80
	ldrh	r1, [r1, #0]
	adds	r2, r2, r1
	b	.L1398
.L1374:
	movs	r2, #2
.L1398:
	strh	r2, [r3, r5, lsl #1]	@ movhi
	mov	r0, r5
	ldr	r3, .L1401+84
	movs	r1, #0
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	b	.L1399
.L1373:
	ldrh	r2, [r3, r5, lsl #1]
	mov	r0, r5
	movs	r1, #1
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L1401+88
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
.L1399:
	bl	ftl_set_blk_mode
	ldr	r3, .L1401+72
	lsl	fp, r5, #1
	str	fp, [sp, #20]
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	ldr	r3, .L1401+92
	ldr	r1, [r3, #0]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3, #0]
	ldr	r3, .L1401+80
	ldrh	r2, [r3, #0]
	ldr	r3, .L1401+84
	ldr	r0, [r3, #0]
	ldr	r3, .L1401+88
	ldr	r3, [r3, #0]
	mla	r0, r0, r2, r3
	ldr	r3, .L1401+12
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1401+96
	str	r0, [r3, #0]
	ldr	r3, .L1401+100
	ldr	r3, [r3, #0]
	ldr	r2, [r3, #16]
	adds	r2, r2, #1
	str	r2, [r3, #16]
	ldr	r3, [r8, #0]
	movs	r2, #0
	b	.L1378
.L1402:
	.align	2
.L1401:
	.word	.LANCHOR94
	.word	.LANCHOR106
	.word	.LANCHOR103
	.word	.LANCHOR55
	.word	.LANCHOR210
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR111
	.word	.LANCHOR169
	.word	.LANCHOR128
	.word	.LANCHOR167
	.word	.LANCHOR59
	.word	.LANCHOR7
	.word	.LANCHOR105
	.word	.LANCHOR101
	.word	.LANCHOR53
	.word	.LANCHOR109
	.word	.LANCHOR96
	.word	.LANCHOR202
	.word	.LANCHOR63
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR211
	.word	.LANCHOR187
	.word	.LANCHOR95
.L1379:
	adds	r2, r2, #1
	ldr	r1, [r3, #-32]
	uxth	r2, r2
	bic	r1, r1, #1020
	bic	r1, r1, #3
	str	r1, [r3, #-32]
.L1378:
	adds	r3, r3, #36
	cmp	r2, r6
	bne	.L1379
	ldr	r3, .L1403
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1380
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldr	r0, [r8, #0]
	cmp	r3, #1
	bne	.L1381
	movs	r1, #0
	b	.L1400
.L1381:
	movs	r1, #1
.L1400:
	mov	r2, r6
	bl	FlashEraseBlocks
.L1380:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	mov	fp, #0
	ldr	r0, [r8, #0]
	bl	FlashEraseBlocks
	mov	ip, r5
	mov	r3, r6
	mov	r5, fp
	mov	r6, r4
	mov	r4, fp
	b	.L1382
.L1384:
	ldr	r1, [r8, #0]
	add	r0, r1, fp
	ldr	r1, [r1, fp]
	adds	r2, r1, #1
	bne	.L1383
	ldr	r0, [r0, #4]
	adds	r5, r5, #1
	str	r1, [sp, #16]
	ubfx	r0, r0, #10, #16
	str	r3, [sp, #8]
	str	ip, [sp, #12]
	bl	FtlBbmMapBadBlock
	ldr	r1, [sp, #16]
	strh	r1, [sl, #16]	@ movhi
	ldrb	r1, [r6, #7]	@ zero_extendqisi2
	subs	r1, r1, #1
	strb	r1, [r6, #7]
	ldr	ip, [sp, #12]
	ldr	r3, [sp, #8]
.L1383:
	adds	r4, r4, #1
	add	fp, fp, #36
	add	sl, sl, #2
	uxth	r4, r4
.L1382:
	cmp	r4, r3
	bne	.L1384
	mov	r3, r5
	mov	r4, r6
	mov	r5, ip
	cbz	r3, .L1385
	mov	r0, ip
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1385:
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1386
	ldr	r3, .L1403+4
	movw	r2, #65535
	ldr	r3, [r3, #0]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1397
.L1386:
	ldr	r2, .L1403+8
	ldr	fp, [sp, #20]
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	movs	r2, #0
	strh	r2, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	uxth	r3, r3
	ldr	r2, .L1403+12
	strh	r5, [r4, #0]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	ldr	r1, [r2, #0]
	str	r1, [r4, #12]
	adds	r1, r1, #1
	str	r1, [r2, #0]
	ldr	r2, .L1403+4
	ldr	r2, [r2, #0]
	strh	r3, [r2, fp]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1387
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1357
.L1387:
	ldr	r1, .L1403+16
	mov	r2, #2928
	ldr	r0, .L1403+20
	bl	printf
	ldr	r0, .L1403+24
	ldr	r1, .L1403+28
	bl	printf
.L1357:
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1404:
	.align	2
.L1403:
	.word	.LANCHOR7
	.word	.LANCHOR101
	.word	.LANCHOR68
	.word	.LANCHOR156
	.word	.LANCHOR210
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	allocate_data_superblock, .-allocate_data_superblock
	.section	.text.FtlSuperblockPowerLostFix,"ax",%progbits
	.align	1
	.global	FtlSuperblockPowerLostFix
	.thumb
	.thumb_func
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1414
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrb	r6, [r3, #0]	@ zero_extendqisi2
	sub	sp, sp, #40
	cbz	r6, .L1413
	ldrb	r6, [r0, #8]	@ zero_extendqisi2
	cmp	r6, #1
	bne	.L1412
	ldrh	r5, [r0, #4]
	b	.L1406
.L1412:
	movs	r6, #0
.L1413:
	movs	r5, #12
.L1406:
	mov	r7, #-1
	ldr	sl, .L1414+12
	ldr	fp, .L1414+16
	ldr	r8, .L1414+20
	b	.L1407
.L1410:
	ldrh	r3, [r4, #4]
	cbz	r3, .L1408
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1408
	ldr	r3, [sl, #0]
	add	r0, sp, #4
	ldr	r2, [fp, #0]
	subs	r5, r5, #1
	ldr	r1, [r8, #0]
	str	r3, [sp, #12]
	ldrh	r3, [r4, #0]
	str	r2, [sp, #16]
	str	r7, [sp, #20]
	strh	r3, [r2, #2]	@ movhi
	movs	r3, #0
	str	r1, [r2, #4]
	strh	r3, [r2, #0]	@ movhi
	str	r7, [r2, #8]
	str	r7, [r2, #12]
	adds	r2, r1, #1
	cmp	r2, #-1
	it	eq
	moveq	r2, r3
	movs	r1, #1
	str	r2, [r8, #0]
	mov	r2, r6
	bl	FlashProgPages
	ldrh	r0, [r4, #0]
	bl	decrement_vpc_count
.L1407:
	cmp	r5, #0
	bne	.L1410
.L1408:
	ldr	r3, .L1414+4
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1414+8
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #40
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1415:
	.align	2
.L1414:
	.word	.LANCHOR7
	.word	.LANCHOR101
	.word	.LANCHOR68
	.word	.LANCHOR98
	.word	.LANCHOR184
	.word	.LANCHOR157
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLowFormatEraseBlock,"ax",%progbits
	.align	1
	.global	FtlLowFormatEraseBlock
	.thumb
	.thumb_func
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1447
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	ldr	r6, [r3, #0]
	mov	r8, r1
	str	r0, [sp, #12]
	cmp	r6, #0
	bne	.L1440
	ldr	r3, .L1447+4
	mov	r5, r6
	mov	r4, r6
	ldr	sl, .L1447+28
	movs	r7, #36
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	str	r3, [sp, #8]
	ldr	r3, .L1447+8
	str	r0, [r3, #0]
	b	.L1418
.L1422:
	mul	r3, r7, r6
	ldr	r1, .L1447+12
	ldr	fp, [sl, #0]
	movs	r0, #0
	str	r0, [fp, r3]
	ldrb	r0, [r1, r6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	V2P_block
	str	r0, [sp, #4]
	cmp	r8, #0
	beq	.L1419
	bl	IsBlkInVendorPart
	cbnz	r0, .L1420
.L1419:
	ldr	r0, [sp, #4]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1421
	mul	r3, r7, r5
	ldr	r2, [sl, #0]
	ldr	ip, [sp, #4]
	adds	r2, r2, r3
	add	r3, fp, r3
	lsl	r1, ip, #10
	str	r0, [r3, #8]
	ldr	r0, .L1447+16
	str	r1, [r2, #4]
	ldrh	r2, [r0, #0]
	muls	r2, r5, r2
	ldr	r0, .L1447+20
	adds	r5, r5, #1
	bic	r2, r2, #3
	uxth	r5, r5
	ldr	r1, [r0, #0]
	adds	r2, r1, r2
	str	r2, [r3, #12]
	b	.L1420
.L1421:
	adds	r4, r4, #1
	uxth	r4, r4
.L1420:
	adds	r6, r6, #1
	uxth	r6, r6
.L1418:
	ldr	r1, .L1447+24
	ldrh	r3, [r1, #0]
	cmp	r3, r6
	bhi	.L1422
	cmp	r5, #0
	beq	.L1417
	ldr	r2, [sp, #8]
	mov	sl, #0
	ldr	r7, .L1447+28
	mov	fp, sl
	adds	r6, r2, #0
	mov	r2, r5
	it	ne
	movne	r6, #1
	ldr	r0, [r7, #0]
	mov	r1, r6
	bl	FlashEraseBlocks
.L1426:
	ldr	r3, [r7, #0]
	add	r2, r3, sl
	ldr	r3, [r3, sl]
	adds	r3, r3, #1
	bne	.L1425
	ldr	r0, [r2, #4]
	adds	r4, r4, #1
	ubfx	r0, r0, #10, #16
	uxth	r4, r4
	bl	FtlBbmMapBadBlock
.L1425:
	add	fp, fp, #1
	add	sl, sl, #36
	uxth	fp, fp
	cmp	fp, r5
	bne	.L1426
	cmp	r8, #0
	beq	.L1441
	ldr	r3, .L1447+32
	ldrh	r3, [r3, #0]
	str	r3, [sp, #4]
	ldr	r3, .L1447+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1442
	ldr	ip, [sp, #4]
	movs	r6, #1
	lsr	ip, ip, #2
	str	ip, [sp, #8]
	b	.L1427
.L1441:
	mov	ip, #6
	str	ip, [sp, #8]
	mov	ip, #1
	str	ip, [sp, #4]
	b	.L1427
.L1442:
	movs	r6, #1
	str	r6, [sp, #8]
.L1427:
	ldr	sl, .L1447+28
	movs	r7, #0
.L1435:
	mov	fp, #0
	mov	r5, fp
	b	.L1428
.L1431:
	mov	ip, #36
	ldr	r2, [sl, #0]
	ldr	r1, .L1447+12
	movs	r0, #0
	mul	r3, ip, fp
	str	r2, [sp, #16]
	str	r0, [r2, r3]
	ldrb	r0, [r1, fp]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	V2P_block
	str	r0, [sp, #20]
	cmp	r8, #0
	beq	.L1429
	bl	IsBlkInVendorPart
	cbnz	r0, .L1430
.L1429:
	ldr	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1430
	ldr	r2, [sp, #16]
	mov	ip, #36
	ldr	r1, [sp, #20]
	ldr	r0, .L1447+36
	mla	r3, ip, r5, r2
	add	r2, r7, r1, lsl #10
	ldr	r1, .L1447+16
	str	r2, [r3, #4]
	ldr	r2, [r0, #0]
	ldr	r0, .L1447+40
	str	r2, [r3, #8]
	ldrh	r2, [r1, #0]
	muls	r2, r5, r2
	adds	r5, r5, #1
	ldr	r1, [r0, #0]
	bic	r2, r2, #3
	uxth	r5, r5
	adds	r2, r1, r2
	str	r2, [r3, #12]
.L1430:
	add	fp, fp, #1
	uxth	fp, fp
.L1428:
	ldr	r1, .L1447+24
	ldrh	r3, [r1, #0]
	cmp	r3, fp
	bhi	.L1431
	cmp	r5, #0
	beq	.L1417
	mov	r1, r5
	mov	r2, r6
	ldr	r0, [sl, #0]
	movs	r3, #1
	mov	fp, #0
	bl	FlashProgPages
	mov	ip, r8
	mov	r8, r7
	mov	r7, r6
	mov	r6, r5
	mov	r5, fp
.L1434:
	ldr	r2, [sl, #0]
	add	r1, r2, fp
	ldr	r2, [r2, fp]
	cbz	r2, .L1433
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	str	ip, [sp, #0]
	ubfx	r0, r0, #10, #16
	uxth	r4, r4
	bl	FtlBbmMapBadBlock
	ldr	ip, [sp, #0]
.L1433:
	adds	r5, r5, #1
	add	fp, fp, #36
	uxth	r5, r5
	cmp	r5, r6
	bne	.L1434
	mov	r5, r6
	mov	r6, r7
	mov	r7, r8
	mov	r8, ip
	ldr	ip, [sp, #8]
	add	r7, r7, ip
	ldr	ip, [sp, #4]
	uxth	r7, r7
	cmp	r7, ip
	bcc	.L1435
	movs	r7, #0
	ldr	fp, .L1447+28
	mov	sl, r7
.L1437:
	cmp	r8, #0
	beq	.L1436
	ldr	r3, [fp, #0]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	cbnz	r3, .L1436
	ldr	r0, [r2, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1436:
	add	sl, sl, #1
	adds	r7, r7, #36
	uxth	sl, sl
	cmp	sl, r5
	bne	.L1437
	ldr	r0, [sp, #12]
	cmp	r0, #63
	bls	.L1438
	cmp	r8, #0
	beq	.L1417
.L1438:
	ldr	r3, .L1447+28
	mov	r1, r6
	mov	r2, r5
	ldr	r0, [r3, #0]
	bl	FlashEraseBlocks
	b	.L1417
.L1440:
	movs	r4, #0
.L1417:
	mov	r0, r4
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1448:
	.align	2
.L1447:
	.word	.LANCHOR94
	.word	.LANCHOR7
	.word	.LANCHOR89
	.word	.LANCHOR62
	.word	.LANCHOR74
	.word	.LANCHOR185
	.word	.LANCHOR53
	.word	.LANCHOR95
	.word	.LANCHOR69
	.word	.LANCHOR182
	.word	.LANCHOR183
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FlashTestBlk,"ax",%progbits
	.align	1
	.global	FlashTestBlk
	.thumb
	.thumb_func
	.type	FlashTestBlk, %function
FlashTestBlk:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1454
	push	{r4, r5, lr}
	mov	r4, r0
	ldr	r3, [r3, #0]
	sub	sp, sp, #108
	cmp	r0, r3
	bcc	.L1452
.L1451:
	ldr	r5, .L1454+4
	add	r0, sp, #4
	movs	r1, #165
	movs	r2, #32
	str	r0, [sp, #80]
	lsls	r4, r4, #10
	ldr	r3, [r5, #0]
	str	r3, [sp, #76]
	bl	memset
	movs	r1, #90
	movs	r2, #8
	ldr	r0, [r5, #0]
	bl	memset
	movs	r1, #1
	mov	r2, r1
	add	r0, sp, #68
	str	r4, [sp, #72]
	bl	FlashEraseBlocks
	movs	r1, #1
	add	r0, sp, #68
	mov	r2, r1
	mov	r3, r1
	bl	FlashProgPages
	ldr	r4, [sp, #68]
	add	r0, sp, #68
	movs	r1, #0
	movs	r2, #1
	cmp	r4, #0
	ite	ne
	movne	r4, #-1
	moveq	r4, #0
	bl	FlashEraseBlocks
	b	.L1450
.L1452:
	movs	r4, #0
.L1450:
	mov	r0, r4
	add	sp, sp, #108
	pop	{r4, r5, pc}
.L1455:
	.align	2
.L1454:
	.word	.LANCHOR46
	.word	.LANCHOR41
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.ftl_map_blk_gc,"ax",%progbits
	.align	1
	.global	ftl_map_blk_gc
	.thumb
	.thumb_func
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r5, [r0, #12]
	ldr	fp, [r0, #24]
	bl	ftl_free_no_use_map_blk
	ldrh	r7, [r4, #10]
	ldrh	r2, [r4, #8]
	subs	r3, r7, #4
	cmp	r2, r3
	bge	.L1457
	ldrh	r2, [r4, #40]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1458
	ldr	r3, .L1471
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1458
.L1457:
	ldrh	r1, [r4, #40]
	movw	r3, #65535
	uxth	r6, r0
	cmp	r1, r3
	beq	.L1459
	ldr	r2, .L1471
	ldrh	r3, [r4, #2]
	ldrh	r2, [r2, #0]
	cmp	r2, r3
	bhi	.L1459
	mov	r0, r5
	movs	r2, #0
	b	.L1460
.L1462:
	ldrh	lr, [r0], #2
	cmp	lr, r1
	beq	.L1470
	adds	r2, r2, #1
	uxth	r2, r2
.L1460:
	cmp	r2, r7
	bne	.L1462
	b	.L1461
.L1470:
	mov	r6, r2
.L1461:
	ldr	r0, .L1471+4
	ldrh	r2, [r5, r2, lsl #1]
	bl	printf
	movw	r3, #65535
	strh	r3, [r4, #40]	@ movhi
.L1459:
	ldrh	r7, [r5, r6, lsl #1]
	lsls	r2, r6, #1
	cmp	r7, #0
	beq	.L1458
	ldr	r3, [r4, #32]
	cmp	r3, #0
	bne	.L1458
	movs	r1, #1
	str	r1, [r4, #32]
	strh	r3, [r5, r2]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L1471
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1463
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1463:
	movs	r5, #0
	ldr	r6, .L1471+8
	ldr	sl, .L1471+40
	b	.L1464
.L1468:
	lsls	r3, r5, #2
	str	r3, [sp, #4]
	ldr	r3, [fp, r5, lsl #2]
	cmp	r7, r3, lsr #10
	bne	.L1465
	ldr	r2, [sl, #0]
	movs	r1, #1
	str	r3, [r6, #4]
	ldr	r0, .L1471+8
	str	r2, [r6, #8]
	ldr	r2, .L1471+12
	ldr	r8, [r2, #0]
	mov	r2, r1
	str	r8, [r6, #12]
	bl	FlashReadPages
	ldrh	r3, [r8, #8]
	cmp	r3, r5
	beq	.L1466
	ldr	r1, .L1471+16
	movw	r2, #638
	ldr	r0, .L1471+20
	bl	printf
	ldr	r0, .L1471+24
	ldr	r1, .L1471+28
	bl	printf
.L1466:
	ldr	r3, .L1471+8
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	bne	.L1467
	ldr	r2, [sp, #4]
	movs	r3, #0
	ldr	r0, .L1471+32
	str	r3, [fp, r2]
	ldrh	r2, [r8, #8]
	ldr	r1, [r6, #4]
	bl	printf
	ldr	r2, .L1471+36
	movs	r3, #1
	str	r3, [r2, #0]
	b	.L1465
.L1467:
	mov	r0, r4
	mov	r1, r5
	ldr	r2, [r6, #8]
	bl	FtlMapWritePage
.L1465:
	adds	r5, r5, #1
	uxth	r5, r5
.L1464:
	ldrh	r3, [r4, #6]
	cmp	r3, r5
	bhi	.L1468
	mov	r0, r7
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L1458:
	ldr	r3, .L1471
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1469
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1469:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1472:
	.align	2
.L1471:
	.word	.LANCHOR69
	.word	.LC30
	.word	.LANCHOR198
	.word	.LANCHOR184
	.word	.LANCHOR212
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC31
	.word	.LANCHOR94
	.word	.LANCHOR180
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",%progbits
	.align	1
	.global	Ftl_write_map_blk_to_last_page
	.thumb
	.thumb_func
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1480
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r6, [r3, #0]
	ldr	r5, [r0, #12]
	ldr	r8, [r0, #24]
	cmp	r6, #0
	bne	.L1474
	ldrh	r3, [r0, #0]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1475
	ldrh	r3, [r0, #8]
	cbz	r3, .L1476
	ldr	r1, .L1480+4
	movw	r2, #670
	ldr	r0, .L1480+8
	bl	printf
	ldr	r0, .L1480+12
	ldr	r1, .L1480+16
	bl	printf
.L1476:
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	movs	r3, #0
	strh	r0, [r5, #0]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	strh	r3, [r4, #0]	@ movhi
	ldr	r3, [r4, #28]
	adds	r3, r3, #1
	str	r3, [r4, #28]
	b	.L1474
.L1475:
	ldrh	r5, [r5, r3, lsl #1]
	movs	r1, #255
	ldr	r2, .L1480+20
	ldrh	r3, [r0, #2]
	ldr	r7, .L1480+24
	orr	r3, r3, r5, lsl #10
	str	r3, [r2, #4]
	ldr	r3, .L1480+28
	ldr	r0, [r7, #0]
	ldr	r3, [r3, #0]
	str	r0, [r2, #8]
	str	r3, [r2, #12]
	ldr	r2, [r4, #28]
	str	r2, [r3, #4]
	movw	r2, #64245
	strh	r2, [r3, #8]	@ movhi
	ldrh	r2, [r4, #4]
	strh	r5, [r3, #2]	@ movhi
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L1480+32
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #3
	bl	memset
	ldrh	r0, [r4, #6]
	ldr	r1, [r7, #0]
	mov	r2, r8
	mov	r3, r6
	b	.L1477
.L1479:
	ldr	r7, [r2], #4
	cmp	r5, r7, lsr #10
	bne	.L1478
	adds	r3, r3, #1
	uxth	r3, r3
	str	r6, [r1, r3, lsl #3]
	add	r7, r1, r3, lsl #3
	ldr	lr, [r2, #-4]
	str	lr, [r7, #4]
.L1478:
	adds	r6, r6, #1
.L1477:
	uxth	r7, r6
	cmp	r7, r0
	bcc	.L1479
	movs	r1, #1
	movs	r3, #0
	ldr	r0, .L1480+20
	mov	r2, r1
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
.L1474:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L1481:
	.align	2
.L1480:
	.word	.LANCHOR94
	.word	.LANCHOR213
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR198
	.word	.LANCHOR98
	.word	.LANCHOR184
	.word	.LANCHOR69
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",%progbits
	.align	1
	.global	FtlMapWritePage
	.thumb
	.thumb_func
	.type	FtlMapWritePage, %function
FtlMapWritePage:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1496
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r6, [r3, #0]
	stmia	sp, {r1, r2}
	cmp	r6, #0
	bne	.L1483
	ldr	r8, .L1496+32
	ldr	sl, .L1496+36
	ldr	r5, .L1496+4
	ldr	fp, .L1496+40
.L1495:
	ldr	r3, [r8, #0]
	ldrh	r2, [r4, #2]
	adds	r3, r3, #1
	str	r3, [r8, #0]
	ldrh	r3, [sl, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L1485
	ldrh	r3, [r4, #0]
	movw	r1, #65535
	cmp	r3, r1
	bne	.L1486
.L1485:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L1486:
	ldrh	r2, [r4, #0]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L1487
	ldr	r1, .L1496+8
	movw	r2, #731
	ldr	r0, .L1496+12
	bl	printf
	ldr	r0, .L1496+16
	ldr	r1, .L1496+20
	bl	printf
.L1487:
	ldrh	r2, [r4, #0]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L1488
	ldr	r1, .L1496+8
	mov	r2, #732
	ldr	r0, .L1496+12
	bl	printf
	ldr	r0, .L1496+16
	ldr	r1, .L1496+20
	bl	printf
.L1488:
	ldrh	r2, [r4, #0]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r0, [fp, #0]
	ldrh	r7, [r3, r2, lsl #1]
	ldr	r2, [sp, #4]
	ldrh	r3, [r4, #2]
	str	r0, [r5, #12]
	str	r2, [r5, #8]
	movs	r2, #16
	orr	r3, r3, r7, lsl #10
	str	r3, [r5, #4]
	bl	memset
	ldr	r3, [r5, #12]
	ldr	r2, [r4, #28]
	ldr	r1, [sp, #0]
	ldr	r0, .L1496+4
	str	r2, [r3, #4]
	ldrh	r2, [r4, #4]
	strh	r1, [r3, #8]	@ movhi
	movs	r1, #1
	strh	r7, [r3, #2]	@ movhi
	strh	r2, [r3, #0]	@ movhi
	mov	r2, r1
	mov	r3, r1
	bl	FlashProgPages
	ldrh	r2, [r4, #2]
	ldr	r3, [r5, #0]
	adds	r2, r2, #1
	adds	r1, r3, #1
	uxth	r2, r2
	strh	r2, [r4, #2]	@ movhi
	bne	.L1489
	ldr	r0, .L1496+24
	adds	r6, r6, #1
	ldr	r1, [r5, #4]
	bl	printf
	ldrh	r3, [r4, #2]
	uxth	r6, r6
	cmp	r3, #2
	bhi	.L1490
	ldrh	r3, [sl, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1490:
	cmp	r6, #3
	bls	.L1495
	ldr	r3, .L1496+4
	mov	r2, r6
	ldr	r0, .L1496+28
	ldr	r1, [r3, #4]
	bl	printf
	ldr	r3, .L1496
	movs	r2, #1
	str	r2, [r3, #0]
	b	.L1483
.L1489:
	cbz	r3, .L1492
	strh	r7, [r4, #40]	@ movhi
.L1492:
	cmp	r2, #1
	beq	.L1495
	cmp	r3, #256
	beq	.L1495
	ldr	r3, .L1496+4
	ldr	r1, [sp, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r1, lsl #2]
.L1483:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1497:
	.align	2
.L1496:
	.word	.LANCHOR94
	.word	.LANCHOR198
	.word	.LANCHOR214
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC32
	.word	.LC33
	.word	.LANCHOR162
	.word	.LANCHOR69
	.word	.LANCHOR184
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.FtlMapBlkWriteDumpData,"ax",%progbits
	.align	1
	.global	FtlMapBlkWriteDumpData
	.thumb
	.thumb_func
	.type	FtlMapBlkWriteDumpData, %function
FtlMapBlkWriteDumpData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #36]
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldrh	r6, [r0, #6]
	ldr	r8, [r0, #24]
	cmp	r3, #0
	beq	.L1498
	movs	r3, #0
	str	r3, [r0, #36]
	ldr	r3, .L1504
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1498
	ldr	r3, .L1504+4
	ldr	r5, .L1504+8
	ldr	r3, [r3, #0]
	str	r3, [r5, #8]
	ldr	r3, .L1504+12
	ldr	r7, [r3, #0]
	ldrh	r3, [r0, #2]
	str	r7, [r5, #12]
	cbz	r3, .L1500
	ldr	r2, .L1504+16
	ldrh	r2, [r2, #0]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L1500
	ldrh	r2, [r0, #0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1500
	ldr	r1, [r0, #12]
	subs	r3, r3, #1
	mov	r0, r5
	ldrh	r2, [r1, r2, lsl #1]
	movs	r1, #1
	orr	r3, r3, r2, lsl #10
	mov	r2, r1
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5, #0]
	adds	r3, r3, #1
	beq	.L1500
	ldr	r3, [r4, #24]
	ldrh	r1, [r7, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L1500
	mov	r0, r4
	b	.L1503
.L1500:
	subs	r6, r6, #1
	ldr	r5, .L1504+8
	uxth	r6, r6
	ldr	r3, [r8, r6, lsl #2]
	str	r3, [r5, #4]
	cbz	r3, .L1501
	movs	r1, #1
	mov	r0, r5
	mov	r2, r1
	bl	FlashReadPages
	b	.L1502
.L1501:
	ldr	r3, .L1504+20
	movs	r1, #255
	ldr	r0, [r5, #8]
	ldrh	r2, [r3, #0]
	bl	memset
.L1502:
	mov	r0, r4
	mov	r1, r6
.L1503:
	ldr	r2, [r5, #8]
	pop	{r4, r5, r6, r7, r8, lr}
	b	FtlMapWritePage
.L1498:
	pop	{r4, r5, r6, r7, r8, pc}
.L1505:
	.align	2
.L1504:
	.word	.LANCHOR94
	.word	.LANCHOR180
	.word	.LANCHOR198
	.word	.LANCHOR184
	.word	.LANCHOR69
	.word	.LANCHOR73
	.size	FtlMapBlkWriteDumpData, .-FtlMapBlkWriteDumpData
	.section	.text.FtlVendorPartRead,"ax",%progbits
	.align	1
	.global	FtlVendorPartRead
	.thumb
	.thumb_func
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1517
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	fp, r2
	ldrh	r6, [r3, #0]
	adds	r2, r1, r0
	ldr	r3, .L1517+4
	sub	sp, sp, #56
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bhi	.L1515
	lsr	r6, r0, r6
	ldr	r8, .L1517+28
	lsls	r3, r6, #2
	str	r3, [sp, #8]
	movs	r3, #0
	str	r3, [sp, #4]
	b	.L1508
.L1514:
	ldr	r2, .L1517+8
	mov	r0, r7
	ldr	r3, [r2, #0]
	ldr	r2, [sp, #8]
	ldr	sl, [r3, r2]
	ldr	r3, .L1517+12
	ldrh	r4, [r3, #0]
	mov	r1, r4
	bl	__aeabi_uidivmod
	uxth	r1, r1
	str	r1, [sp, #12]
	subs	r4, r4, r1
	uxth	r4, r4
	cmp	r4, r5
	it	hi
	uxthhi	r4, r5
	cmp	sl, #0
	beq	.L1510
	ldr	r3, [r8, #0]
	movs	r1, #1
	mov	r2, r1
	add	r0, sp, #20
	str	sl, [sp, #24]
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #4]
	cmp	r3, #-1
	it	eq
	moveq	r2, #-1
	str	r2, [sp, #4]
	ldr	r2, .L1517+16
	ldr	r3, [r2, #0]
	cmp	r3, #256
	bne	.L1512
	mov	r1, r6
	mov	r2, sl
	ldr	r0, .L1517+20
	bl	printf
	ldr	r0, .L1517+24
	mov	r1, r6
	ldr	r2, [r8, #0]
	bl	FtlMapWritePage
.L1512:
	ldr	r3, [sp, #12]
	mov	r0, fp
	ldr	r1, [r8, #0]
	lsls	r2, r4, #9
	add	r1, r1, r3, lsl #9
	bl	memcpy
	b	.L1513
.L1510:
	mov	r0, fp
	mov	r1, sl
	lsls	r2, r4, #9
	bl	memset
.L1513:
	ldr	r3, [sp, #8]
	adds	r6, r6, #1
	subs	r5, r5, r4
	adds	r7, r7, r4
	add	fp, fp, r4, lsl #9
	adds	r3, r3, #4
	str	r3, [sp, #8]
.L1508:
	cmp	r5, #0
	bne	.L1514
	b	.L1507
.L1515:
	mov	r3, #-1
	str	r3, [sp, #4]
.L1507:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1518:
	.align	2
.L1517:
	.word	.LANCHOR72
	.word	.LANCHOR65
	.word	.LANCHOR190
	.word	.LANCHOR71
	.word	.LANCHOR198
	.word	.LC34
	.word	.LANCHOR215
	.word	.LANCHOR181
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.Ftl_load_ext_data,"ax",%progbits
	.align	1
	.global	Ftl_load_ext_data
	.thumb
	.thumb_func
	.type	Ftl_load_ext_data, %function
Ftl_load_ext_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r0, #0
	ldr	r4, .L1523
	movs	r1, #1
	ldr	r5, .L1523+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4, #0]
	cmp	r3, r5
	beq	.L1520
	mov	r0, r4
	movs	r1, #0
	mov	r2, #512
	bl	memset
	str	r5, [r4, #0]
.L1520:
	ldr	r2, [r4, #0]
	ldr	r3, .L1523
	cmp	r2, r5
	bne	.L1521
	ldr	r1, [r3, #88]
	ldr	r2, .L1523+8
	str	r1, [r2, #0]
	ldr	r1, [r3, #92]
	ldr	r2, .L1523+12
	str	r1, [r2, #0]
	ldr	r1, [r3, #8]
	ldr	r2, .L1523+16
	str	r1, [r2, #0]
	ldr	r1, [r3, #12]
	ldr	r2, .L1523+20
	str	r1, [r2, #0]
	ldr	r1, [r3, #16]
	ldr	r2, .L1523+24
	str	r1, [r2, #0]
	ldr	r1, [r3, #20]
	ldr	r2, .L1523+28
	str	r1, [r2, #0]
	ldr	r1, [r3, #28]
	ldr	r2, .L1523+32
	str	r1, [r2, #0]
	ldr	r1, [r3, #32]
	ldr	r2, .L1523+36
	str	r1, [r2, #0]
	ldr	r1, [r3, #36]
	ldr	r2, .L1523+40
	str	r1, [r2, #0]
	ldr	r1, [r3, #40]
	ldr	r2, .L1523+44
	str	r1, [r2, #0]
	ldr	r1, [r3, #44]
	ldr	r2, .L1523+48
	str	r1, [r2, #0]
	ldr	r1, [r3, #48]
	ldr	r2, .L1523+52
	str	r1, [r2, #0]
	ldr	r2, [r3, #60]
	ldr	r3, .L1523+56
	str	r2, [r3, #0]
.L1521:
	ldr	r3, .L1523+60
	movs	r2, #0
	str	r2, [r3, #0]
	ldr	r3, .L1523
	ldr	r2, [r3, #68]
	ldr	r3, .L1523+64
	cmp	r2, r3
	bne	.L1522
	ldr	r3, .L1523+68
	movs	r2, #1
	ldr	r0, .L1523+72
	ldr	r1, .L1523+76
	str	r2, [r3, #0]
	bl	printf
.L1522:
	ldr	r3, .L1523+80
	ldrh	r2, [r3, #0]
	ldr	r3, .L1523+84
	ldr	r0, [r3, #0]
	ldr	r3, .L1523+32
	ldr	r3, [r3, #0]
	mla	r0, r0, r2, r3
	ldr	r3, .L1523+88
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1523+92
	str	r0, [r3, #0]
	pop	{r3, r4, r5, pc}
.L1524:
	.align	2
.L1523:
	.word	.LANCHOR144
	.word	1179929683
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR163
	.word	.LANCHOR162
	.word	.LANCHOR165
	.word	.LANCHOR97
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR155
	.word	.LANCHOR154
	.word	305432421
	.word	.LANCHOR128
	.word	.LC10
	.word	.LC35
	.word	.LANCHOR63
	.word	.LANCHOR164
	.word	.LANCHOR55
	.word	.LANCHOR211
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.FtlLoadEctTbl,"ax",%progbits
	.align	1
	.global	FtlLoadEctTbl
	.thumb
	.thumb_func
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r0, #64
	ldr	r4, .L1527
	ldr	r5, .L1527+4
	ldr	r2, [r4, #0]
	ldrh	r1, [r5, #0]
	bl	FtlVendorPartRead
	ldr	r3, [r4, #0]
	ldr	r2, [r3, #0]
	ldr	r3, .L1527+8
	cmp	r2, r3
	beq	.L1526
	ldr	r1, .L1527+12
	ldr	r0, .L1527+16
	bl	printf
	ldrh	r2, [r5, #0]
	ldr	r0, [r4, #0]
	movs	r1, #0
	lsls	r2, r2, #9
	bl	memset
.L1526:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1528:
	.align	2
.L1527:
	.word	.LANCHOR187
	.word	.LANCHOR186
	.word	1112818501
	.word	.LC36
	.word	.LC10
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.FtlVendorPartWrite,"ax",%progbits
	.align	1
	.global	FtlVendorPartWrite
	.thumb
	.thumb_func
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1539
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #56
	ldrh	sl, [r3, #0]
	mov	r6, r0
	ldr	r3, .L1539+4
	mov	r4, r1
	str	r2, [sp, #8]
	adds	r2, r1, r0
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bhi	.L1537
	lsr	sl, r0, sl
	mov	fp, #0
	ldr	r7, .L1539+8
	lsl	r3, sl, #2
	str	r3, [sp, #4]
	b	.L1531
.L1536:
	ldr	r2, .L1539+12
	mov	r0, r6
	ldr	r3, [r2, #0]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, r2]
	ldr	r2, .L1539+16
	ldrh	r8, [r2, #0]
	str	r3, [sp, #0]
	mov	r1, r8
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #0]
	uxth	r1, r1
	str	r1, [sp, #12]
	rsb	r5, r1, r8
	uxth	r5, r5
	cmp	r5, r4
	it	hi
	uxthhi	r5, r4
	cbz	r3, .L1533
	cmp	r5, r8
	beq	.L1533
	str	r3, [sp, #24]
	movs	r1, #1
	ldr	r3, [r7, #0]
	add	r0, sp, #20
	mov	r2, r1
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
	b	.L1534
.L1533:
	ldr	r3, .L1539+20
	movs	r1, #0
	ldr	r0, [r7, #0]
	ldrh	r2, [r3, #0]
	bl	memset
.L1534:
	ldr	r3, [sp, #12]
	lsl	r8, r5, #9
	ldr	r0, [r7, #0]
	mov	r2, r8
	ldr	r1, [sp, #8]
	subs	r4, r4, r5
	add	r0, r0, r3, lsl #9
	adds	r6, r6, r5
	bl	memcpy
	mov	r1, sl
	ldr	r0, .L1539+24
	add	sl, sl, #1
	ldr	r2, [r7, #0]
	bl	FtlMapWritePage
	ldr	r3, [sp, #8]
	add	r3, r3, r8
	str	r3, [sp, #8]
	ldr	r3, [sp, #4]
	adds	r3, r3, #4
	str	r3, [sp, #4]
	cmp	r0, #-1
	it	eq
	moveq	fp, #-1
.L1531:
	cmp	r4, #0
	bne	.L1536
	b	.L1530
.L1537:
	mov	fp, #-1
.L1530:
	mov	r0, fp
	add	sp, sp, #56
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1540:
	.align	2
.L1539:
	.word	.LANCHOR72
	.word	.LANCHOR65
	.word	.LANCHOR181
	.word	.LANCHOR190
	.word	.LANCHOR71
	.word	.LANCHOR73
	.word	.LANCHOR215
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",%progbits
	.align	1
	.global	Ftl_save_ext_data
	.thumb
	.thumb_func
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L1543
	ldr	r3, .L1543+4
	ldr	r1, [r2, #0]
	cmp	r1, r3
	bne	.L1541
	ldr	r3, .L1543+8
	movs	r0, #0
	movs	r1, #1
	str	r3, [r2, #4]
	ldr	r3, .L1543+12
	ldr	r3, [r3, #0]
	str	r3, [r2, #88]
	ldr	r3, .L1543+16
	ldr	r3, [r3, #0]
	str	r3, [r2, #92]
	ldr	r3, .L1543+20
	ldr	r3, [r3, #0]
	str	r3, [r2, #8]
	ldr	r3, .L1543+24
	ldr	r3, [r3, #0]
	str	r3, [r2, #12]
	ldr	r3, .L1543+28
	ldr	r3, [r3, #0]
	str	r3, [r2, #16]
	ldr	r3, .L1543+32
	ldr	r3, [r3, #0]
	str	r3, [r2, #20]
	ldr	r3, .L1543+36
	ldr	r3, [r3, #0]
	str	r3, [r2, #28]
	ldr	r3, .L1543+40
	ldr	r3, [r3, #0]
	str	r3, [r2, #32]
	ldr	r3, .L1543+44
	ldr	r3, [r3, #0]
	str	r3, [r2, #36]
	ldr	r3, .L1543+48
	ldr	r3, [r3, #0]
	str	r3, [r2, #40]
	ldr	r3, .L1543+52
	ldr	r3, [r3, #0]
	str	r3, [r2, #44]
	ldr	r3, .L1543+56
	ldr	r3, [r3, #0]
	str	r3, [r2, #48]
	ldr	r3, .L1543+60
	ldr	r3, [r3, #0]
	str	r3, [r2, #60]
	ldr	r3, .L1543+64
	ldr	r3, [r3, #0]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L1541:
	bx	lr
.L1544:
	.align	2
.L1543:
	.word	.LANCHOR144
	.word	1179929683
	.word	1342177351
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR163
	.word	.LANCHOR162
	.word	.LANCHOR165
	.word	.LANCHOR97
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR155
	.word	.LANCHOR154
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",%progbits
	.align	1
	.global	FtlEctTblFlush
	.thumb
	.thumb_func
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L1552
	ldr	r3, [r3, #0]
	cbz	r3, .L1550
	ldr	r3, .L1552+4
	ldr	r3, [r3, #0]
	cmp	r3, #29
	ite	ls
	movls	r3, #4
	movhi	r3, #32
	b	.L1546
.L1550:
	movs	r3, #32
.L1546:
	ldr	r2, .L1552+8
	ldrh	r1, [r2, #0]
	cmp	r1, #31
	bhi	.L1547
	movs	r3, #1
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
.L1547:
	ldr	r2, .L1552+12
	cbnz	r0, .L1548
	ldr	r1, [r2, #0]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	adds	r3, r3, r0
	cmp	r1, r3
	bcc	.L1549
.L1548:
	ldr	r2, [r2, #0]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1552+16
	str	r3, [r2, #0]
	ldr	r3, .L1552+20
	ldrh	r1, [r3, #0]
	lsls	r3, r1, #9
	str	r3, [r2, #12]
	ldr	r3, [r2, #8]
	adds	r3, r3, #1
	str	r3, [r2, #8]
	movs	r3, #0
	str	r3, [r2, #4]
	bl	FtlVendorPartWrite
	bl	Ftl_save_ext_data
.L1549:
	movs	r0, #0
	pop	{r3, pc}
.L1553:
	.align	2
.L1552:
	.word	.LANCHOR128
	.word	.LANCHOR167
	.word	.LANCHOR218
	.word	.LANCHOR187
	.word	1112818501
	.word	.LANCHOR186
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.flush_l2p_region,"ax",%progbits
	.align	1
	.global	flush_l2p_region
	.thumb
	.thumb_func
	.type	flush_l2p_region, %function
flush_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #12
	muls	r4, r0, r4
	ldr	r5, .L1555
	ldr	r0, .L1555+4
	ldr	r2, [r5, #0]
	adds	r3, r2, r4
	ldrh	r1, [r2, r4]
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	ldr	r3, [r5, #0]
	movs	r0, #0
	adds	r4, r3, r4
	ldr	r3, [r4, #4]
	bic	r3, r3, #-2147483648
	str	r3, [r4, #4]
	pop	{r3, r4, r5, pc}
.L1556:
	.align	2
.L1555:
	.word	.LANCHOR114
	.word	.LANCHOR122
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.l2p_flush,"ax",%progbits
	.align	1
	.global	l2p_flush
	.thumb
	.thumb_func
	.type	l2p_flush, %function
l2p_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r4, #0
	ldr	r7, .L1561
	movs	r5, #12
	ldr	r6, .L1561+4
	b	.L1558
.L1560:
	ldr	r3, [r6, #0]
	mla	r3, r5, r4, r3
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L1559
	mov	r0, r4
	bl	flush_l2p_region
.L1559:
	adds	r4, r4, #1
	uxth	r4, r4
.L1558:
	ldrh	r3, [r7, #0]
	cmp	r3, r4
	bhi	.L1560
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L1562:
	.align	2
.L1561:
	.word	.LANCHOR83
	.word	.LANCHOR114
	.size	l2p_flush, .-l2p_flush
	.section	.text.allocate_new_data_superblock,"ax",%progbits
	.align	1
	.global	allocate_new_data_superblock
	.thumb
	.thumb_func
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1576
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0, #0]
	ldrh	r3, [r3, #0]
	cmp	r3, r5
	bcs	.L1564
	ldr	r1, .L1576+4
	movw	r2, #2936
	ldr	r0, .L1576+8
	bl	printf
	ldr	r0, .L1576+12
	ldr	r1, .L1576+16
	bl	printf
.L1564:
	ldr	r3, .L1576+20
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1565
	movw	r3, #65535
	cmp	r5, r3
	beq	.L1566
	ldr	r3, .L1576+24
	mov	r0, r5
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L1567
	bl	INSERT_DATA_LIST
	b	.L1566
.L1567:
	bl	INSERT_FREE_LIST
.L1566:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L1576+28
	cmp	r4, r3
	beq	.L1568
	ldr	r3, .L1576+32
	ldrh	r3, [r3, #0]
	cmp	r3, #1
	beq	.L1568
	ldr	r2, .L1576+36
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1569
.L1568:
	movs	r3, #1
	strb	r3, [r4, #8]
	b	.L1570
.L1569:
	ldr	r2, .L1576+40
	cmp	r4, r2
	bne	.L1570
	cmp	r3, #3
	beq	.L1571
	ldr	r3, .L1576+44
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L1572
.L1571:
	movs	r3, #1
	strb	r3, [r2, #8]
.L1572:
	ldr	r3, .L1576+48
	ldr	r3, [r3, #0]
	cbz	r3, .L1570
	ldr	r3, .L1576+52
	ldr	r3, [r3, #0]
	cmp	r3, #29
	bhi	.L1570
	ldr	r3, .L1576+40
	movs	r2, #1
	strb	r2, [r3, #8]
.L1570:
	ldr	r6, .L1576+56
	movw	r3, #65535
	ldrh	r0, [r6, #0]
	cmp	r0, r3
	beq	.L1573
	cmp	r5, r0
	bne	.L1574
	ldr	r3, .L1576+24
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1575
.L1574:
	bl	update_vpc_list
.L1575:
	movw	r3, #65535
	strh	r3, [r6, #0]	@ movhi
.L1573:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1565:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1577:
	.align	2
.L1576:
	.word	.LANCHOR55
	.word	.LANCHOR219
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR94
	.word	.LANCHOR101
	.word	.LANCHOR110
	.word	.LANCHOR59
	.word	.LANCHOR7
	.word	.LANCHOR109
	.word	.LANCHOR155
	.word	.LANCHOR128
	.word	.LANCHOR167
	.word	.LANCHOR138
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlMapTblRecovery,"ax",%progbits
	.align	1
	.global	FtlMapTblRecovery
	.thumb
	.thumb_func
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	sub	sp, sp, #24
	ldr	fp, [r0, #24]
	ldr	r3, [r4, #16]
	movs	r1, #0
	ldrh	sl, [r4, #6]
	ldr	r0, [r0, #12]
	str	r3, [sp, #20]
	ldrh	r3, [r4, #8]
	lsl	r2, sl, #2
	str	r0, [sp, #12]
	mov	r0, fp
	ldr	r6, .L1615
	str	r3, [sp, #16]
	bl	memset
	ldr	r1, .L1615+4
	movs	r2, #0
	mov	r8, r2
	str	r2, [r4, #32]
	str	r2, [r4, #28]
	ldr	r3, [r1, #0]
	str	r3, [r6, #8]
	ldr	r3, .L1615+8
	ldr	r5, [r3, #0]
	movw	r3, #65535
	str	r5, [r6, #12]
	strh	r3, [r4, #0]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #1
	str	r3, [r4, #36]
	ldr	r3, [sp, #12]
	mov	r7, r3
	mov	r3, fp
	mov	fp, sl
	mov	sl, r4
	b	.L1579
.L1593:
	ldr	r0, [sp, #16]
	subs	r2, r0, #1
	cmp	r8, r2
	bne	.L1580
	sxth	r6, r1
	mov	r7, r1
	ldr	r1, [sp, #12]
	mov	r4, sl
	mov	sl, fp
	mov	fp, r3
	add	r8, r1, r6, lsl #1
	ldrh	r0, [r1, r6, lsl #1]
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	strh	r7, [r4, #0]	@ movhi
	ldr	r7, .L1615
	uxth	r3, r0
	ldr	r0, [sp, #20]
	adds	r2, r3, #1
	strh	r2, [r4, #2]	@ movhi
	sxth	r3, r3
	ldr	r2, [r0, r6, lsl #2]
	movs	r6, #0
	str	r2, [r4, #28]
	b	.L1581
.L1584:
	ldrh	r2, [r8, #0]
	movs	r1, #1
	ldr	r0, .L1615
	orr	r2, r6, r2, lsl #10
	str	r2, [r7, #4]
	mov	r2, r1
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r2, [r7, #0]
	ldr	r3, [sp, #8]
	adds	r2, r2, #1
	beq	.L1582
	ldrh	r2, [r5, #8]
	cmp	r2, sl
	bcs	.L1583
	ldrh	r0, [r5, #0]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L1583
	ldr	r1, [r7, #4]
	str	r1, [fp, r2, lsl #2]
	b	.L1583
.L1582:
	ldrh	r2, [r8, #0]
	strh	r2, [r4, #40]	@ movhi
.L1583:
	adds	r6, r6, #1
.L1581:
	sxth	r2, r6
	cmp	r3, r2
	bge	.L1584
	b	.L1585
.L1580:
	ldr	r1, .L1615+4
	ldr	r0, .L1615+12
	ldr	r2, [r1, #0]
	ldrh	r1, [r7], #2
	str	r2, [r6, #8]
	ldrh	r2, [r0, #0]
	ldr	r0, .L1615
	subs	r2, r2, #1
	orr	r2, r2, r1, lsl #10
	movs	r1, #1
	str	r2, [r6, #4]
	mov	r2, r1
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r2, [r6, #0]
	ldr	r3, [sp, #8]
	adds	r2, r2, #1
	beq	.L1606
	ldrh	r1, [r5, #0]
	ldrh	r2, [sl, #4]
	cmp	r1, r2
	bne	.L1606
	ldrh	r2, [r5, #8]
	movw	r1, #64245
	cmp	r2, r1
	bne	.L1606
	ldr	r2, .L1615+12
	movs	r1, #0
	ldr	r0, .L1615+4
	mov	lr, r3
	ldrh	r4, [r2, #0]
	ldr	r2, [r0, #0]
	subs	r4, r4, #1
	b	.L1587
.L1589:
	ldrh	r0, [r2, #0]
	cmp	r0, fp
	itt	cc
	ldrcc	r3, [r2, #4]
	strcc	r3, [lr, r0, lsl #2]
	adds	r1, r1, #1
	adds	r2, r2, #8
.L1587:
	cmp	r1, r4
	blt	.L1589
	mov	r3, lr
	b	.L1590
.L1592:
	ldrh	r2, [r7, #-2]
	movs	r1, #1
	ldr	r0, .L1615
	orr	r2, r4, r2, lsl #10
	str	r2, [r6, #4]
	mov	r2, r1
	str	ip, [sp, #8]
	bl	FlashReadPages
	ldr	r2, [r6, #0]
	ldr	ip, [sp, #8]
	adds	r2, r2, #1
	beq	.L1591
	ldrh	r2, [r5, #8]
	cmp	r2, fp
	bcs	.L1591
	ldrh	r1, [sl, #4]
	ldrh	r0, [r5, #0]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r6, #4]
	streq	r1, [r8, r2, lsl #2]
.L1591:
	adds	r4, r4, #1
	b	.L1610
.L1606:
	mov	ip, r8
	movs	r4, #0
	mov	r8, r3
.L1610:
	ldr	r1, .L1615+12
	ldrh	r2, [r1, #0]
	cmp	r4, r2
	blt	.L1592
	mov	r3, r8
	mov	r8, ip
.L1590:
	add	r8, r8, #1
.L1579:
	ldr	r2, [sp, #16]
	uxth	r1, r8
	cmp	r8, r2
	blt	.L1593
	mov	r4, sl
.L1585:
	ldr	r3, .L1615+16
	cmp	r4, r3
	bne	.L1594
	ldr	r3, .L1615+20
	ldrh	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1607
	b	.L1594
.L1601:
	ldr	r3, [r8, #0]
	lsls	r4, r7, #2
	ldr	r3, [r3, r7, lsl #2]
	subs	r2, r3, #1
	adds	r2, r2, #3
	bhi	.L1596
	ldr	r2, [r6, #0]
	ldr	r2, [r2, r7, lsl #2]
	cmp	r3, r2
	beq	.L1596
	ldr	r0, .L1615+4
	movs	r1, #1
	str	r3, [sl, #4]
	ldr	r2, [r0, #0]
	ldr	r0, .L1615
	str	r2, [sl, #8]
	ldr	r2, .L1615+8
	ldr	r5, [r2, #0]
	mov	r2, r1
	str	r5, [sl, #12]
	bl	FlashReadPages
	ldr	r3, [sl, #0]
	adds	r3, r3, #1
	beq	.L1609
	ldr	r3, .L1615+16
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #4]
	cmp	r2, r3
	bne	.L1609
	ldr	fp, [r5, #4]
	b	.L1597
.L1609:
	mov	fp, #0
.L1597:
	ldr	r3, [r6, #0]
	movs	r1, #1
	mov	r2, r1
	ldr	r0, .L1615
	ldr	r3, [r3, r4]
	str	r3, [sl, #4]
	bl	FlashReadPages
	ldr	r1, [r5, #4]
	cmp	fp, r1
	bls	.L1596
	ldr	r2, [r8, #0]
	ldr	r3, [r6, #0]
	ldr	r0, .L1615+24
	str	r1, [sp, #0]
	ldr	r1, [r2, r4]
	ldr	r2, [r3, r4]
	mov	r3, fp
	bl	printf
	ldr	r3, [r8, #0]
	ldr	r2, [r6, #0]
	ldr	r1, [r3, r4]
	str	r1, [r2, r4]
	movs	r2, #0
	ldr	r0, [r3, r4]
	ldr	r3, .L1615+28
	ubfx	r0, r0, #10, #16
	ldr	r1, [sp, #12]
	ldrh	r3, [r3, #0]
	b	.L1598
.L1599:
	ldrh	r4, [r1], #2
	adds	r2, r2, #1
	cmp	r4, r0
	beq	.L1596
.L1598:
	cmp	r2, r3
	blt	.L1599
	b	.L1613
.L1614:
	ldr	r1, [sp, #12]
	strh	r0, [r1, r3, lsl #1]	@ movhi
	ldr	r3, .L1615+28
	ldrh	r2, [r3, #0]
	adds	r2, r2, #1
	strh	r2, [r3, #0]	@ movhi
	bl	remove_from_free_sys_Queue
.L1596:
	adds	r7, r7, #1
	b	.L1595
.L1616:
	.align	2
.L1615:
	.word	.LANCHOR198
	.word	.LANCHOR98
	.word	.LANCHOR184
	.word	.LANCHOR69
	.word	.LANCHOR122
	.word	.LANCHOR85
	.word	.LC37
	.word	.LANCHOR123
.L1607:
	ldr	r8, .L1617+16
	movs	r7, #0
	ldr	r6, .L1617
	ldr	sl, .L1617+20
	str	r4, [sp, #16]
.L1595:
	ldr	r2, .L1617+4
	ldrh	r3, [r2, #0]
	cmp	r7, r3
	bcc	.L1601
	ldr	r4, [sp, #16]
.L1594:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L1617+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1602
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1602:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1613:
	ldr	r2, .L1617+12
	ldr	r2, [r2, #0]
	cmp	r3, r2
	bcs	.L1596
	b	.L1614
.L1618:
	.align	2
.L1617:
	.word	.LANCHOR126
	.word	.LANCHOR82
	.word	.LANCHOR69
	.word	.LANCHOR80
	.word	.LANCHOR191
	.word	.LANCHOR198
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadMapInfo,"ax",%progbits
	.align	1
	.global	FtlLoadMapInfo
	.thumb
	.thumb_func
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	FtlL2PDataInit
	ldr	r0, .L1620
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1621:
	.align	2
.L1620:
	.word	.LANCHOR122
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.FtlLoadVonderInfo,"ax",%progbits
	.align	1
	.global	FtlLoadVonderInfo
	.thumb
	.thumb_func
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L1623
	ldr	r0, .L1623+4
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L1623+8
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L1623+12
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L1623+16
	ldr	r3, [r3, #0]
	str	r3, [r0, #12]
	ldr	r3, .L1623+20
	ldr	r3, [r3, #0]
	str	r3, [r0, #16]
	ldr	r3, .L1623+24
	ldr	r3, [r3, #0]
	str	r3, [r0, #20]
	ldr	r3, .L1623+28
	ldr	r3, [r3, #0]
	str	r3, [r0, #24]
	movw	r3, #65535
	strh	r3, [r0, #40]	@ movhi
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1624:
	.align	2
.L1623:
	.word	.LANCHOR77
	.word	.LANCHOR215
	.word	.LANCHOR86
	.word	.LANCHOR78
	.word	.LANCHOR87
	.word	.LANCHOR189
	.word	.LANCHOR188
	.word	.LANCHOR190
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.global	load_l2p_region
	.thumb
	.thumb_func
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, sl, lr}
	mov	r4, r0
	ldr	r3, .L1631
	mov	r7, r1
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	bcs	.L1626
	ldr	r1, .L1631+4
	movw	r2, #503
	ldr	r0, .L1631+8
	bl	printf
	ldr	r0, .L1631+12
	ldr	r1, .L1631+16
	bl	printf
.L1626:
	ldr	r3, .L1631+20
	ldr	r8, .L1631+44
	ldr	r3, [r3, #0]
	ldr	r6, [r3, r4, lsl #2]
	movs	r3, #12
	cbnz	r6, .L1627
	muls	r7, r3, r7
	ldr	r3, [r8, #0]
	movs	r1, #255
	adds	r3, r3, r7
	ldr	r0, [r3, #8]
	ldr	r3, .L1631+24
	ldrh	r2, [r3, #0]
	bl	memset
	ldr	r3, [r8, #0]
	adds	r2, r3, r7
	strh	r4, [r3, r7]	@ movhi
	str	r6, [r2, #4]
	b	.L1628
.L1627:
	muls	r7, r3, r7
	ldr	r3, [r8, #0]
	ldr	r5, .L1631+28
	movs	r1, #1
	adds	r3, r3, r7
	mov	r2, r1
	mov	r0, r5
	ldr	r3, [r3, #8]
	str	r6, [r5, #4]
	str	r3, [r5, #8]
	ldr	r3, .L1631+32
	ldr	r3, [r3, #0]
	str	r3, [r5, #12]
	bl	FlashReadPages
	ldr	r3, [r5, #0]
	ldr	sl, [r5, #12]
	cmp	r3, #256
	bne	.L1629
	mov	r2, r6
	mov	r1, r4
	ldr	r0, .L1631+36
	lsrs	r6, r6, #10
	bl	printf
	ldr	r3, [r8, #0]
	ldr	r0, .L1631+40
	mov	r1, r4
	adds	r3, r3, r7
	strh	r6, [r0, #40]	@ movhi
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
.L1629:
	ldrh	r3, [sl, #8]
	cmp	r3, r4
	beq	.L1630
	ldr	r1, .L1631+4
	movw	r2, #529
	ldr	r0, .L1631+8
	bl	printf
	ldr	r0, .L1631+12
	ldr	r1, .L1631+16
	bl	printf
.L1630:
	ldr	r3, .L1631+44
	movs	r1, #0
	ldr	r3, [r3, #0]
	adds	r2, r3, r7
	strh	r4, [r3, r7]	@ movhi
	str	r1, [r2, #4]
.L1628:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1632:
	.align	2
.L1631:
	.word	.LANCHOR82
	.word	.LANCHOR220
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR126
	.word	.LANCHOR73
	.word	.LANCHOR198
	.word	.LANCHOR184
	.word	.LC38
	.word	.LANCHOR122
	.word	.LANCHOR114
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.log2phys,"ax",%progbits
	.align	1
	.global	log2phys
	.thumb
	.thumb_func
	.type	log2phys, %function
log2phys:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1643
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #1
	ldrh	r3, [r3, #0]
	mov	r6, r1
	mov	r7, r2
	adds	r3, r3, #7
	lsr	r4, r0, r3
	lsl	r5, r5, r3
	ldr	r3, .L1643+4
	subs	r5, r5, #1
	ands	r5, r5, r0
	uxth	r4, r4
	ldr	r3, [r3, #0]
	uxth	r5, r5
	cmp	r0, r3
	bcc	.L1634
	ldr	r1, .L1643+8
	movw	r2, #851
	ldr	r0, .L1643+12
	bl	printf
	ldr	r0, .L1643+16
	ldr	r1, .L1643+20
	bl	printf
.L1634:
	ldr	r3, .L1643+24
	ldrh	r1, [r3, #0]
	ldr	r3, .L1643+28
	ldr	r2, [r3, #0]
	movs	r3, #0
	mov	r8, r3
	b	.L1635
.L1641:
	adds	r3, r3, #12
	adds	r0, r2, r3
	ldrh	r0, [r0, #-12]
	cmp	r0, r4
	bne	.L1636
.L1637:
	ldr	r2, .L1643+28
	movs	r3, #12
	ldr	r2, [r2, #0]
	mla	r3, r3, r8, r2
	cbnz	r7, .L1638
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r6, #0]
	b	.L1639
.L1638:
	ldr	r1, [r6, #0]
	ldr	r2, [r3, #8]
	str	r1, [r2, r5, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L1643+32
	strh	r4, [r3, #0]	@ movhi
.L1639:
	ldr	r3, .L1643+28
	movs	r2, #12
	ldr	r3, [r3, #0]
	mla	r3, r2, r8, r3
	ldr	r2, [r3, #4]
	adds	r0, r2, #1
	beq	.L1640
	adds	r2, r2, #1
	str	r2, [r3, #4]
.L1640:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L1636:
	add	r8, r8, #1
	uxth	r8, r8
.L1635:
	cmp	r8, r1
	bne	.L1641
	bl	select_l2p_ram_region
	movs	r3, #12
	ldr	r2, .L1643+28
	ldr	r2, [r2, #0]
	mul	r3, r3, r0
	mov	r8, r0
	adds	r1, r2, r3
	ldrh	r2, [r2, r3]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1642
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L1642
	bl	flush_l2p_region
.L1642:
	mov	r0, r4
	mov	r1, r8
	bl	load_l2p_region
	b	.L1637
.L1644:
	.align	2
.L1643:
	.word	.LANCHOR72
	.word	.LANCHOR88
	.word	.LANCHOR221
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR83
	.word	.LANCHOR114
	.word	.LANCHOR115
	.size	log2phys, .-log2phys
	.section	.text.FtlReUsePrevPpa,"ax",%progbits
	.align	1
	.global	FtlReUsePrevPpa
	.thumb
	.thumb_func
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r6, r0
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r3, .L1652
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r0, lsl #1]
	mov	r4, r0
	cmp	r2, #0
	bne	.L1646
	ldr	r3, .L1652+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	beq	.L1647
	ldr	r1, .L1652+8
	movs	r5, #6
	ldr	r0, .L1652+12
	ldrh	r7, [r1, #0]
	ldr	r1, .L1652+16
	ldr	r1, [r1, #0]
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	movw	r0, #65535
	uxth	r3, r3
	b	.L1648
.L1651:
	cmp	r3, r4
	bne	.L1649
	ldr	r5, .L1652+8
	mov	r1, r4
	ldr	r0, .L1652+4
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1650
	ldr	r1, .L1652+20
	movw	r2, #1823
	ldr	r0, .L1652+24
	bl	printf
	ldr	r0, .L1652+28
	ldr	r1, .L1652+32
	bl	printf
.L1650:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L1652
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r4, lsl #1]
	b	.L1646
.L1649:
	muls	r3, r5, r3
	ldrh	r3, [r1, r3]
	cmp	r3, r0
	beq	.L1647
	adds	r2, r2, #1
	uxth	r2, r2
.L1648:
	cmp	r2, r7
	bne	.L1651
	b	.L1647
.L1646:
	adds	r2, r2, #1
	strh	r2, [r3, r4, lsl #1]	@ movhi
.L1647:
	mov	r0, r6
	add	r1, sp, #4
	movs	r2, #1
	bl	log2phys
	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
.L1653:
	.align	2
.L1652:
	.word	.LANCHOR101
	.word	.LANCHOR105
	.word	.LANCHOR106
	.word	-1431655765
	.word	.LANCHOR99
	.word	.LANCHOR222
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.FtlProgPages,"ax",%progbits
	.align	1
	.global	FtlProgPages
	.thumb
	.thumb_func
	.type	FtlProgPages, %function
FtlProgPages:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r3
	ldr	r3, .L1670
	mov	r5, r0
	str	r1, [sp, #4]
	ldrb	r7, [r3, #0]	@ zero_extendqisi2
	cbz	r7, .L1655
	ldrb	r7, [r4, #8]	@ zero_extendqisi2
	sub	r2, r7, #1
	rsbs	r7, r2, #0
	adc	r7, r7, r2
.L1655:
	mov	r0, r5
	ldr	r1, [sp, #4]
	mov	r2, r7
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	bl	FlashProgPages
	mov	sl, #0
	ldr	r6, .L1670+4
	ldr	fp, .L1670+36
	b	.L1656
.L1659:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4, #0]
	cmp	r3, r0
	bne	.L1657
	ldr	r2, [r6, #0]
	ldrh	r1, [r4, #4]
	ldrh	r0, [r2, r3, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r2, r3, lsl #1]	@ movhi
	ldr	r2, .L1670+8
	strb	r8, [r4, #6]
	strh	r8, [r4, #4]	@ movhi
	ldrh	r3, [r2, #0]
	strh	r3, [r4, #2]	@ movhi
.L1657:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1658
	mov	r0, r4
	bl	allocate_new_data_superblock
.L1658:
	ldr	r0, [r5, #4]
	ldr	r3, [fp, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [fp, #96]
	bl	FtlGcMarkBadPhyBlk
	mov	r0, r4
	bl	get_new_active_ppa
	movs	r1, #1
	mov	r2, r7
	str	r0, [r5, #4]
	str	r0, [sp, #12]
	mov	r0, r5
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	bl	FlashProgPages
	b	.L1668
.L1669:
	mov	r8, #0
.L1668:
	ldr	r3, [r5, #0]
	adds	r3, r3, #1
	beq	.L1659
	ldr	r3, .L1670+12
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1660
	ldr	r1, .L1670+16
	movw	r2, #1550
	ldr	r0, .L1670+20
	bl	printf
	ldr	r0, .L1670+24
	ldr	r1, .L1670+28
	bl	printf
.L1660:
	ldr	r3, [r5, #4]
	str	r3, [sp, #12]
	cbz	r7, .L1661
	orr	r3, r3, #-2147483648
	str	r3, [sp, #12]
.L1661:
	movs	r2, #1
	ldr	r0, [r5, #16]
	add	r1, sp, #12
	bl	log2phys
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #12]
	adds	r3, r0, #1
	beq	.L1662
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, [r6, #0]
	ldrh	r2, [r3, r0, lsl #1]
	mov	r8, r0
	cbnz	r2, .L1663
	ldr	r0, .L1670+32
	mov	r1, r8
	bl	printf
.L1663:
	mov	r0, r8
	bl	decrement_vpc_count
.L1662:
	add	sl, sl, #1
	adds	r5, r5, #36
.L1656:
	ldr	r3, [sp, #4]
	cmp	sl, r3
	bne	.L1669
	ldr	r3, .L1670+12
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1654
	ldr	r1, .L1670+16
	movw	r2, #1567
	ldr	r0, .L1670+20
	bl	printf
	ldr	r0, .L1670+24
	ldr	r1, .L1670+28
	bl	printf
.L1654:
	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1671:
	.align	2
.L1670:
	.word	.LANCHOR7
	.word	.LANCHOR101
	.word	.LANCHOR68
	.word	.LANCHOR53
	.word	.LANCHOR223
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC39
	.word	.LANCHOR144
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlCacheWriteBack,"ax",%progbits
	.align	1
	.global	FtlCacheWriteBack
	.thumb
	.thumb_func
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L1674
	ldr	r0, [r4, #0]
	cbz	r0, .L1673
	ldr	r3, .L1674+4
	movs	r1, #1
	movs	r2, #0
	ldr	r3, [r3, #0]
	bl	FtlProgPages
	movs	r3, #0
	str	r3, [r4, #0]
.L1673:
	movs	r0, #0
	pop	{r4, pc}
.L1675:
	.align	2
.L1674:
	.word	.LANCHOR137
	.word	.LANCHOR224
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.FtlSysFlush,"ax",%progbits
	.align	1
	.global	FtlSysFlush
	.thumb
	.thumb_func
	.type	FtlSysFlush, %function
FtlSysFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L1678
	ldr	r3, [r3, #0]
	cbnz	r3, .L1677
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1677:
	movs	r0, #0
	pop	{r3, pc}
.L1679:
	.align	2
.L1678:
	.word	.LANCHOR94
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",%progbits
	.align	1
	.global	FtlDeInit
	.thumb
	.thumb_func
	.type	FtlDeInit, %function
FtlDeInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L1682
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L1681
	bl	FtlSysFlush
.L1681:
	movs	r0, #0
	pop	{r3, pc}
.L1683:
	.align	2
.L1682:
	.word	.LANCHOR225
	.size	FtlDeInit, .-FtlDeInit
	.section	.text.rk_ftl_de_init,"ax",%progbits
	.align	1
	.global	rk_ftl_de_init
	.thumb
	.thumb_func
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	rk_nand_de_init
	bl	FtlDeInit
	pop	{r3, lr}
	b	rk_nand_de_init
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.FtlGcFreeTempBlock,"ax",%progbits
	.align	1
	.global	FtlGcFreeTempBlock
	.thumb
	.thumb_func
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1703
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	ldrh	r1, [r3, #0]
	ldr	r3, .L1703+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1699
	ldr	r0, .L1703+8
	movw	r3, #65535
	ldrh	r4, [r0, #0]
	cmp	r4, r3
	beq	.L1687
	bl	FtlGcScanTempBlk
	str	r0, [sp, #4]
	adds	r0, r0, #1
	beq	.L1687
	ldr	r3, .L1703+12
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r4, lsl #1]
	cmp	r2, #4
	bls	.L1688
	subs	r2, r2, #5
	movs	r0, #1
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L1688:
	ldr	r3, .L1703+16
	ldr	r3, [r3, #0]
	cbnz	r3, .L1689
	ldr	r3, .L1703+20
	ldr	r0, [sp, #4]
	ldr	r2, [r3, #96]
	ubfx	r0, r0, #10, #16
	adds	r2, r2, #1
	str	r2, [r3, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1689:
	ldr	r3, .L1703+16
	movs	r2, #0
	movs	r4, #1
	str	r2, [r3, #0]
	b	.L1686
.L1687:
	ldr	r5, .L1703+8
	movs	r4, #0
	ldr	r3, .L1703+16
	ldrh	r2, [r5, #0]
	str	r4, [r3, #0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1686
	bl	FtlCacheWriteBack
	ldr	r3, .L1703+24
	ldr	r1, .L1703
	ldrh	r2, [r3, #0]
	ldrh	r1, [r1, #0]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L1690
	ldr	r1, .L1703+28
	movs	r2, #163
	ldr	r0, .L1703+32
	bl	printf
	ldr	r0, .L1703+36
	ldr	r1, .L1703+40
	bl	printf
.L1690:
	ldr	r3, .L1703+8
	movs	r5, #0
	ldr	r2, .L1703+44
	ldr	r4, .L1703
	ldrh	r1, [r3, #0]
	ldr	r2, [r2, #0]
	ldrh	r4, [r4, #0]
	ldrb	r0, [r3, #7]	@ zero_extendqisi2
	muls	r0, r4, r0
	strh	r0, [r2, r1, lsl #1]	@ movhi
	ldr	r1, .L1703+48
	ldr	r2, .L1703+24
	ldr	fp, .L1703+80
	ldr	r0, [r1, #0]
	mov	sl, r2
	ldrh	r4, [r2, #0]
	ldr	r8, .L1703+84
	adds	r0, r4, r0
	str	r0, [r1, #0]
	b	.L1691
.L1695:
	ldr	r7, [fp, #0]
	movs	r6, #12
	muls	r6, r5, r6
	ldr	r3, [r8, #0]
	adds	r4, r7, r6
	ldr	r2, [r4, #8]
	cmp	r2, r3
	bcc	.L1692
	ldr	r1, .L1703+28
	movs	r2, #168
	ldr	r0, .L1703+32
	bl	printf
	ldr	r0, .L1703+36
	ldr	r1, .L1703+40
	bl	printf
.L1692:
	movs	r2, #0
	ldr	r0, [r4, #8]
	add	r1, sp, #4
	bl	log2phys
	ldr	r0, [sp, #4]
	ldr	r3, [r7, r6]
	cmp	r0, r3
	bne	.L1693
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	adds	r1, r4, #4
	movs	r2, #1
	mov	r6, r0
	ldr	r0, [r4, #8]
	bl	log2phys
	mov	r0, r6
	b	.L1702
.L1693:
	ldr	r3, [r4, #4]
	cmp	r0, r3
	beq	.L1694
	ldr	r3, .L1703+8
	ldrh	r0, [r3, #0]
.L1702:
	bl	decrement_vpc_count
.L1694:
	adds	r5, r5, #1
	uxth	r5, r5
.L1691:
	ldrh	r3, [sl, #0]
	cmp	r3, r5
	bhi	.L1695
	movw	r0, #65535
	ldr	r4, .L1703+8
	bl	decrement_vpc_count
	ldr	r3, .L1703+52
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1696
	ldr	r0, .L1703+56
	ldrh	r1, [r4, #0]
	bl	printf
.L1696:
	ldr	r3, .L1703+44
	ldrh	r0, [r4, #0]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1697
	bl	INSERT_DATA_LIST
	b	.L1698
.L1697:
	bl	INSERT_FREE_LIST
.L1698:
	ldr	r3, .L1703+8
	movw	r5, #65535
	movs	r4, #0
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L1703+24
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1703+60
	strh	r4, [r3, #0]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1703+64
	ldr	r2, .L1703+68
	movs	r1, #3
	ldrh	r3, [r3, #0]
	ldrh	r2, [r2, #0]
	muls	r2, r1, r2
	cmp	r3, r2, lsr #2
	ble	.L1686
	ldr	r3, .L1703+72
	movs	r2, #20
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L1703+76
	strh	r2, [r3, #0]	@ movhi
	b	.L1686
.L1699:
	movs	r4, #0
.L1686:
	mov	r0, r4
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1704:
	.align	2
.L1703:
	.word	.LANCHOR68
	.word	.LANCHOR94
	.word	.LANCHOR111
	.word	.LANCHOR96
	.word	.LANCHOR140
	.word	.LANCHOR144
	.word	.LANCHOR147
	.word	.LANCHOR226
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR101
	.word	.LANCHOR158
	.word	.LANCHOR7
	.word	.LC40
	.word	.LANCHOR145
	.word	.LANCHOR106
	.word	.LANCHOR201
	.word	.LANCHOR202
	.word	.LANCHOR173
	.word	.LANCHOR148
	.word	.LANCHOR88
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.Ftl_gc_temp_data_write_back,"ax",%progbits
	.align	1
	.global	Ftl_gc_temp_data_write_back
	.thumb
	.thumb_func
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L1714
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	ldr	r3, .L1714+4
	cbz	r2, .L1706
	ldr	r2, [r3, #0]
	lsls	r2, r2, #31
	bpl	.L1706
	ldr	r2, .L1714+8
	ldrh	r2, [r2, #4]
	cmp	r2, #0
	bne	.L1711
.L1706:
	ldr	r4, .L1714+12
	movs	r2, #0
	ldr	r1, [r3, #0]
	mov	r3, r2
	movs	r5, #0
	ldr	r7, .L1714+4
	ldr	r0, [r4, #0]
	movs	r6, #36
	bl	FlashProgPages
	b	.L1708
.L1710:
	mul	r3, r6, r5
	ldr	r1, [r4, #0]
	adds	r2, r1, r3
	ldr	r1, [r1, r3]
	adds	r0, r1, #1
	bne	.L1709
	ldr	r3, .L1714+8
	movs	r5, #0
	ldr	r0, .L1714+16
	ldrh	r4, [r3, #0]
	ldr	r0, [r0, #0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L1714+20
	ldr	r0, [r2, #4]
	ldr	r1, [r3, #96]
	ubfx	r0, r0, #10, #16
	adds	r1, r1, #1
	str	r1, [r3, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
	b	.L1713
.L1709:
	ldr	r3, [r2, #12]
	adds	r5, r5, #1
	ldr	r1, [r2, #4]
	uxth	r5, r5
	ldr	r0, [r3, #12]
	ldr	r2, [r3, #8]
	bl	FtlGcUpdatePage
.L1708:
	ldr	r1, [r7, #0]
	cmp	r5, r1
	bcc	.L1710
	ldr	r3, .L1714+12
	ldr	r0, [r3, #0]
	bl	FtlGcBufFree
	ldr	r3, .L1714+4
	movs	r0, #0
	str	r0, [r3, #0]
	ldr	r3, .L1714+8
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1707
	movs	r0, #1
	bl	FtlGcFreeTempBlock
.L1713:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L1711:
	movs	r0, #0
.L1707:
	pop	{r3, r4, r5, r6, r7, pc}
.L1715:
	.align	2
.L1714:
	.word	.LANCHOR7
	.word	.LANCHOR131
	.word	.LANCHOR111
	.word	.LANCHOR178
	.word	.LANCHOR101
	.word	.LANCHOR144
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.Ftl_get_new_temp_ppa,"ax",%progbits
	.align	1
	.global	Ftl_get_new_temp_ppa
	.thumb
	.thumb_func
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movw	r3, #65535
	ldr	r5, .L1719
	ldrh	r2, [r5, #0]
	cmp	r2, r3
	beq	.L1717
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1718
.L1717:
	bl	FtlCacheWriteBack
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1719
	movs	r4, #0
	strb	r4, [r5, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1719+4
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1719+8
	strh	r4, [r3, #0]	@ movhi
	bl	l2p_flush
	mov	r0, r4
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1718:
	ldr	r0, .L1719
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1720:
	.align	2
.L1719:
	.word	.LANCHOR111
	.word	.LANCHOR145
	.word	.LANCHOR147
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.FtlGcPageRecovery,"ax",%progbits
	.align	1
	.global	FtlGcPageRecovery
	.thumb
	.thumb_func
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r4, .L1723
	ldr	r5, .L1723+4
	ldrh	r1, [r4, #0]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4, #0]
	cmp	r2, r3
	bcc	.L1721
	ldr	r0, .L1723+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1723+12
	movs	r2, #0
	str	r2, [r3, #0]
.L1721:
	pop	{r3, r4, r5, pc}
.L1724:
	.align	2
.L1723:
	.word	.LANCHOR68
	.word	.LANCHOR111
	.word	.LANCHOR122
	.word	.LANCHOR140
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
	.section	.text.ftl_discard,"ax",%progbits
	.align	1
	.global	ftl_discard
	.thumb
	.thumb_func
	.type	ftl_discard, %function
ftl_discard:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1734
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r4, r2
	ldr	r3, [r3, #0]
	adds	r2, r2, r1
	mov	r6, r1
	cmp	r2, r3
	bhi	.L1731
	cmp	r4, #31
	bls	.L1732
	bl	FtlCacheWriteBack
	ldr	r3, .L1734+4
	mov	r0, r6
	ldrh	r7, [r3, #0]
	mov	r1, r7
	bl	__aeabi_uidiv
	mls	r6, r0, r7, r6
	mov	r5, r0
	uxth	r6, r6
	cbz	r6, .L1727
	subs	r6, r7, r6
	adds	r5, r0, #1
	cmp	r6, r4
	it	cs
	movcs	r6, r4
	uxth	r6, r6
	subs	r4, r4, r6
.L1727:
	mov	r3, #-1
	ldr	r8, .L1734+4
	str	r3, [sp, #4]
	ldr	r7, .L1734+8
	ldr	r6, .L1734+12
	b	.L1728
.L1730:
	movs	r2, #0
	mov	r0, r5
	mov	r1, sp
	bl	log2phys
	ldr	r3, [sp, #0]
	adds	r3, r3, #1
	beq	.L1729
	ldr	r3, [r7, #0]
	add	r1, sp, #4
	movs	r2, #1
	mov	r0, r5
	adds	r3, r3, #1
	str	r3, [r7, #0]
	ldr	r3, [r6, #0]
	adds	r3, r3, #1
	str	r3, [r6, #0]
	bl	log2phys
	ldr	r0, [sp, #0]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
.L1729:
	ldrh	r3, [r8, #0]
	adds	r5, r5, #1
	subs	r4, r4, r3
.L1728:
	ldrh	r3, [r8, #0]
	cmp	r4, r3
	bcs	.L1730
	ldr	r3, .L1734+8
	mov	r4, #0
	ldr	r2, [r3, #0]
	cmp	r2, #32
	bls	.L1733
	str	r4, [r3, #0]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1733
.L1731:
	mov	r0, #-1
	b	.L1726
.L1732:
	movs	r0, #0
	b	.L1726
.L1733:
	mov	r0, r4
.L1726:
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L1735:
	.align	2
.L1734:
	.word	.LANCHOR84
	.word	.LANCHOR71
	.word	.LANCHOR227
	.word	.LANCHOR160
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlRecoverySuperblock,"ax",%progbits
	.align	1
	.global	FtlRecoverySuperblock
	.thumb
	.thumb_func
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0, #0]
	movw	r3, #65535
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	cmp	r2, r3
	sub	sp, sp, #64
	mov	r4, r0
	beq	.L1737
	ldrh	r5, [r0, #2]
	ldr	r2, .L1829
	str	r5, [sp, #20]
	ldrb	r5, [r0, #6]	@ zero_extendqisi2
	ldrh	r2, [r2, #0]
	str	r5, [sp, #28]
	ldr	r5, [sp, #20]
	cmp	r2, r5
	mov	r5, #0
	bne	.L1738
	mov	r3, r5	@ movhi
	strh	r5, [r0, #4]	@ movhi
	b	.L1826
.L1738:
	ldrh	r0, [r0, #16]
	b	.L1739
.L1740:
	adds	r5, r5, #1
	uxth	r5, r5
	add	r2, r5, #8
	ldrh	r0, [r4, r2, lsl #1]
.L1739:
	cmp	r0, r3
	beq	.L1740
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L1741
	bl	FtlGetLastWrittenPage
	adds	r2, r0, #1
	mov	r6, r0
	beq	.L1742
	ldr	r3, .L1829+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1821
	ldr	r3, .L1829+8
	ldrh	r7, [r3, r0, lsl #1]
	b	.L1811
.L1741:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	adds	r3, r0, #1
	mov	r6, r0
	beq	.L1742
.L1821:
	mov	r7, r6
.L1811:
	ldr	r3, .L1829+12
	movs	r5, #0
	str	r4, [sp, #44]
	mov	r2, r4
	ldrh	fp, [r3, #0]
	ldr	r3, .L1829+16
	ldr	sl, [r3, #0]
	ldr	r3, .L1829+20
	ldr	r8, [r3, #0]
	ldr	r3, .L1829+24
	ldrh	ip, [r3, #0]
	mov	r3, r5
	b	.L1744
.L1742:
	ldr	r3, [sp, #20]
	cbz	r3, .L1745
	ldr	r1, .L1829+28
	movw	r2, #1894
	ldr	r0, .L1829+32
	bl	printf
	ldr	r0, .L1829+36
	ldr	r1, .L1829+40
	bl	printf
.L1745:
	ldr	r3, [sp, #28]
	cbz	r3, .L1746
	cmp	r3, r5
	beq	.L1746
	ldr	r1, .L1829+28
	movw	r2, #1895
	ldr	r0, .L1829+32
	bl	printf
	ldr	r0, .L1829+36
	ldr	r1, .L1829+40
	bl	printf
.L1746:
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	b	.L1737
.L1748:
	ldrh	r0, [r2, #16]
	movw	lr, #65535
	cmp	r0, lr
	beq	.L1747
	mov	lr, #36
	orr	r0, r7, r0, lsl #10
	mla	r1, lr, r5, sl
	str	r0, [r1, #4]
	movs	r0, #0
	str	r0, [r1, #8]
	mul	r0, ip, r5
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r0, r0, #3
	add	r0, r8, r0
	str	r0, [r1, #12]
.L1747:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1744:
	cmp	r3, fp
	bne	.L1748
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1813
	ldr	r3, .L1829+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
	b	.L1822
.L1813:
	movs	r3, #0
.L1822:
	ldr	r8, .L1829+16
	mov	r1, r5
	str	r3, [sp, #24]
	mov	fp, #0
	ldr	r2, [sp, #24]
	mov	sl, fp
	ldr	r0, [r8, #0]
	bl	FlashReadPages
	ldr	r3, .L1829+44
	movw	ip, #65535
	str	ip, [sp, #8]
	ldr	r2, [r3, #0]
	str	r2, [sp, #12]
	uxth	r2, r7
	str	r2, [sp, #16]
	b	.L1750
.L1755:
	ldr	r3, .L1829+16
	ldr	r2, [r3, #0]
	add	r3, r2, fp
	ldr	r2, [r2, fp]
	cbnz	r2, .L1751
	ldr	r3, [r3, #12]
	ldr	r8, [r3, #4]
	cmp	r8, #-1
	beq	.L1752
	ldr	r2, .L1829+44
	mov	r0, r8
	ldr	r1, [r2, #0]
	str	r3, [sp, #0]
	bl	ftl_cmp_data_ver
	ldr	r3, [sp, #0]
	cbz	r0, .L1752
	ldr	r0, .L1829+44
	add	r2, r8, #1
	str	r2, [r0, #0]
.L1752:
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	bne	.L1753
	ldr	r3, .L1829+16
	movs	r2, #36
	uxth	r6, r6
	ldr	r3, [r3, #0]
	mla	r3, r2, sl, r3
	b	.L1823
.L1751:
	ldr	r1, [r3, #4]
	ldr	r0, .L1829+48
	bl	printf
	ldr	r2, [sp, #16]
	ldrh	r3, [r4, #0]
	ldr	r0, .L1829+52
	str	r2, [sp, #8]
	strh	r3, [r0, #0]	@ movhi
.L1753:
	add	sl, sl, #1
	add	fp, fp, #36
	uxth	sl, sl
.L1750:
	cmp	sl, r5
	bne	.L1755
	ldr	r3, .L1829+16
	adds	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r3, #0]
.L1823:
	ldr	r0, [r3, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	str	r0, [sp, #16]
	bne	.L1756
	ldr	r2, .L1829+4
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbnz	r2, .L1756
	ldr	r2, .L1829+8
	ldrh	r6, [r2, r6, lsl #1]
.L1756:
	ldr	r2, .L1829
	ldrh	r2, [r2, #0]
	cmp	r2, r6
	bne	.L1757
	movs	r2, #0
	strh	r6, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	strh	r2, [r4, #4]	@ movhi
.L1757:
	ldr	r5, [sp, #20]
	cmp	r6, r5
	bne	.L1758
	ldr	r8, [sp, #16]
	ldr	r5, [sp, #28]
	cmp	r8, r5
	bne	.L1758
	mov	r0, r4
	mov	r1, r6
	mov	r2, r8
	b	.L1827
.L1758:
	ldr	r2, [sp, #12]
	ldr	r8, [sp, #8]
	subs	r5, r2, #1
	movw	r2, #65535
	cmp	r8, r2
	bne	.L1759
	cmp	r3, #0
	bne	.L1760
.L1759:
	ldr	r2, .L1829+56
	uxth	r3, r7
	ldr	r0, [sp, #20]
	ldr	r1, [r2, #0]
	adds	r1, r1, #1
	it	eq
	streq	r5, [r2, #0]
	ldr	r2, [r2, #0]
	str	r2, [sp, #8]
	adds	r2, r0, #7
	cmp	r3, r2
	ble	.L1814
	subs	r7, r3, #7
	uxth	r7, r7
	b	.L1762
.L1814:
	ldr	r7, [sp, #20]
.L1762:
	mov	fp, #-1
	mov	r8, r3
	mov	sl, fp
	mov	r3, r6
	mov	r6, r5
	b	.L1763
.L1765:
	ldrh	r0, [r1, #16]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1764
	ldr	r3, [sp, #12]
	mov	lr, #36
	orr	r0, r7, r0, lsl #10
	mla	ip, lr, r5, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r0, [ip, #4]
.L1764:
	adds	r2, r2, #1
	adds	r1, r1, #2
	uxth	r2, r2
.L1776:
	ldr	r0, [sp, #36]
	cmp	r2, r0
	bne	.L1765
	ldr	ip, .L1829+16
	mov	r1, r5
	ldr	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldr	r0, [ip, #0]
	stmia	sp, {r3, ip}
	bl	FlashReadPages
	ldr	r2, .L1829+4
	movs	r0, #0
	ldr	ip, [sp, #4]
	ldr	r3, [sp, #0]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	ldr	r1, [ip, #0]
	mov	ip, r3
	str	r5, [sp, #32]
	str	r2, [sp, #12]
	ldr	r2, .L1829+56
	ldr	r2, [r2, #0]
	b	.L1766
.L1830:
	.align	2
.L1829:
	.word	.LANCHOR68
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	.LANCHOR53
	.word	.LANCHOR177
	.word	.LANCHOR133
	.word	.LANCHOR74
	.word	.LANCHOR228
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR157
	.word	.LC41
	.word	.LANCHOR229
	.word	.LANCHOR141
.L1774:
	ldr	r3, [r1, #0]
	cbnz	r3, .L1767
	ldr	r3, [r1, #12]
	movw	r5, #65535
	ldrh	lr, [r3, #0]
	cmp	lr, r5
	beq	.L1816
	ldr	r3, [r3, #4]
	adds	r5, r3, #1
	beq	.L1816
	cmp	fp, #-1
	bne	.L1768
	ldr	r5, .L1831
	ldrh	lr, [r5, r7, lsl #1]
	movw	r5, #65535
	cmp	lr, r5
	bne	.L1769
	ldr	r5, [sp, #12]
	cmp	r5, #0
	beq	.L1768
.L1769:
	cmp	r2, r6
	ite	ne
	movne	fp, r2
	moveq	fp, #-1
	b	.L1768
.L1767:
	ldr	r1, .L1831+4
	mov	r5, r6
	ldrh	r0, [r4, #0]
	mov	r6, ip
	ldr	r3, .L1831+8
	strh	r0, [r1, #0]	@ movhi
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	str	r2, [r3, #0]
	cmp	r1, #0
	bne	.L1760
	ldr	r1, .L1831
	ldrh	r0, [r1, r7, lsl #1]
	movw	r1, #65535
	cmp	r0, r1
	bne	.L1770
	cmp	fp, #-1
	beq	.L1771
	str	fp, [r3, #0]
	b	.L1760
.L1771:
	ldr	r0, [sp, #8]
	cmp	r0, r5
	beq	.L1828
	str	r0, [r3, #0]
	b	.L1760
.L1770:
	cmp	sl, r5
	beq	.L1773
	cmp	sl, #-1
	beq	.L1760
	str	sl, [r3, #0]
	b	.L1760
.L1773:
	cmp	r2, r5
	beq	.L1760
.L1828:
	subs	r2, r2, #1
	b	.L1824
.L1816:
	mov	r3, r2
	mov	r2, sl
.L1768:
	adds	r0, r0, #1
	mov	sl, r2
	adds	r1, r1, #36
	mov	r2, r3
	uxth	r0, r0
.L1766:
	ldr	r3, [sp, #32]
	cmp	r0, r3
	bne	.L1774
	adds	r7, r7, #1
	ldr	r1, .L1831+8
	mov	r3, ip
	uxth	r7, r7
	str	r2, [r1, #0]
.L1763:
	cmp	r7, r8
	bhi	.L1775
	ldr	r5, .L1831+12
	mov	r1, r4
	ldr	r2, .L1831+16
	str	r3, [sp, #32]
	ldrh	lr, [r5, #0]
	movs	r5, #0
	ldr	r2, [r2, #0]
	str	lr, [sp, #36]
	str	r2, [sp, #12]
	mov	r2, r5
	b	.L1776
.L1775:
	mov	r5, r6
	mov	r6, r3
	ldr	r3, .L1831+8
	mov	r2, #-1
.L1824:
	str	r2, [r3, #0]
.L1760:
	ldr	r3, .L1831+20
	movs	r2, #1
	ldr	r0, .L1831+24
	ldr	r7, .L1831+16
	strh	r2, [r3, #0]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	sl, [sp, #20]
	str	r6, [sp, #12]
.L1777:
	ldr	r3, .L1831+28
	movs	r6, #0
	ldr	r0, .L1831+12
	mov	r2, r4
	ldr	lr, [r7, #0]
	ldrb	fp, [r3, #0]	@ zero_extendqisi2
	mov	r3, r6
	ldrh	ip, [r0, #0]
	b	.L1778
.L1781:
	ldrh	r0, [r2, #16]
	movw	r1, #65535
	cmp	r0, r1
	beq	.L1779
	mov	r8, #36
	orr	r0, sl, r0, lsl #10
	mla	r1, r8, r6, lr
	str	r0, [r1, #4]
	ldrb	r8, [r4, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L1780
	cmp	fp, #0
	beq	.L1780
	orr	r0, r0, #-2147483648
	str	r0, [r1, #4]
.L1780:
	adds	r6, r6, #1
	uxth	r6, r6
.L1779:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1778:
	cmp	r3, ip
	bne	.L1781
	ldr	r0, [r7, #0]
	mov	r1, r6
	ldr	r2, [sp, #24]
	mov	r8, #0
	bl	FlashReadPages
	movs	r3, #36
	str	sl, [sp, #32]
	muls	r3, r6, r3
	str	r3, [sp, #40]
	b	.L1782
.L1806:
	ldr	r3, [r7, #0]
	add	sl, r3, r8
	ldr	r6, [sl, #4]
	ubfx	r0, r6, #10, #16
	str	r6, [sp, #60]
	bl	P2V_plane
	ldr	ip, [sp, #32]
	ldr	r3, [sp, #20]
	cmp	ip, r3
	bcc	.L1783
	bne	.L1784
	ldr	r3, [sp, #28]
	cmp	r0, r3
	bcc	.L1783
.L1784:
	ldr	ip, [sp, #32]
	ldr	r3, [sp, #12]
	cmp	ip, r3
	bne	.L1785
	ldr	ip, [sp, #16]
	cmp	r0, ip
	beq	.L1820
.L1785:
	ldr	r3, [sl, #0]
	adds	r3, r3, #1
	beq	.L1787
	ldr	r6, [sl, #12]
	movw	r3, #61589
	ldrh	r2, [r6, #0]
	cmp	r2, r3
	bne	.L1794
.L1788:
	ldr	r5, [r6, #4]
	adds	r3, r5, #1
	beq	.L1789
	ldr	sl, .L1831+32
	mov	r0, r5
	ldr	r1, [sl, #0]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1789
	adds	r3, r5, #1
	str	r3, [sl, #0]
.L1789:
	ldr	sl, [r6, #8]
	add	r1, sp, #56
	ldr	r3, [r6, #12]
	movs	r2, #0
	mov	r0, sl
	str	r3, [sp, #52]
	bl	log2phys
	ldr	r0, .L1831+8
	ldr	r1, [r0, #0]
	adds	r0, r1, #1
	beq	.L1790
	mov	r0, r5
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1790
	ldr	r3, [sp, #52]
	adds	r1, r3, #1
	beq	.L1791
	ldr	r0, [r7, #0]
	movs	r2, #0
	add	r0, r0, r8
	ldr	r1, [r0, #12]
	str	r3, [r0, #4]
	str	r1, [sp, #8]
	movs	r1, #1
	bl	FlashReadPages
	ldr	r3, [sp, #8]
	ldr	r3, [r3, #4]
	str	r3, [sp, #36]
	ldr	r3, [r7, #0]
	add	fp, r3, r8
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L1792
	b	.L1793
.L1791:
	ldr	r3, [sp, #60]
	ldr	r2, [sp, #56]
	cmp	r2, r3
	bne	.L1794
	mov	r0, sl
	add	r1, sp, #52
	movs	r2, #1
	bl	log2phys
.L1794:
	ldrh	r0, [r4, #0]
	b	.L1825
.L1792:
	ldr	r3, [sp, #8]
	ldr	r6, [r3, #8]
	cmp	r6, sl
	bne	.L1793
	ldr	r1, .L1831+8
	ldr	r0, [r1, #0]
	ldr	r1, [sp, #36]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1793
	ldr	r3, [sp, #56]
	ldr	r2, [sp, #60]
	cmp	r3, r2
	beq	.L1798
.L1795:
	ldr	r2, [sp, #52]
	cmp	r3, r2
	beq	.L1793
	adds	r2, r3, #1
	beq	.L1796
	ldr	r2, [fp, #12]
	mov	r0, fp
	str	r3, [fp, #4]
	movs	r1, #1
	str	r2, [sp, #8]
	movs	r2, #0
	bl	FlashReadPages
	b	.L1797
.L1796:
	str	r3, [fp, #0]
.L1797:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	beq	.L1798
	ldr	r3, [sp, #8]
	ldr	r1, .L1831+8
	ldr	sl, [r3, #4]
	ldr	r0, [r1, #0]
	mov	r1, sl
	bl	ftl_cmp_data_ver
	cbz	r0, .L1798
	ldr	r0, [sp, #36]
	mov	r1, sl
	bl	ftl_cmp_data_ver
	cbz	r0, .L1793
.L1798:
	mov	r0, r6
	ldr	r1, [sp, #52]
	bl	FtlReUsePrevPpa
.L1793:
	ldrh	r0, [r4, #0]
	mov	r3, #-1
	str	r3, [sp, #52]
	bl	decrement_vpc_count
	b	.L1800
.L1832:
	.align	2
.L1831:
	.word	.LANCHOR9
	.word	.LANCHOR229
	.word	.LANCHOR141
	.word	.LANCHOR53
	.word	.LANCHOR177
	.word	.LANCHOR230
	.word	.LANCHOR122
	.word	.LANCHOR7
	.word	.LANCHOR157
.L1790:
	ldr	r3, [sp, #60]
	ldr	r2, [sp, #56]
	cmp	r2, r3
	beq	.L1800
	movs	r2, #1
	mov	r0, sl
	add	r1, sp, #60
	bl	log2phys
	ldr	fp, [sp, #56]
	cmp	fp, #-1
	beq	.L1800
	ldr	r3, [sp, #52]
	cmp	fp, r3
	beq	.L1800
	ubfx	r0, fp, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1833
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L1801
	ldr	r3, .L1833+4
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L1801
	ldr	r3, .L1833+8
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	bne	.L1800
.L1801:
	ldr	r0, [r7, #0]
	movs	r1, #1
	movs	r2, #0
	str	fp, [r0, #4]
	ldr	r6, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r7, #0]
	ldr	r1, [r6, #4]
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	beq	.L1800
	mov	r0, r5
	bl	ftl_cmp_data_ver
	cbnz	r0, .L1800
	mov	r0, sl
	add	r1, sp, #56
	movs	r2, #1
	bl	log2phys
.L1800:
	ldr	r0, [sp, #52]
	adds	r3, r0, #1
	beq	.L1783
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1833+12
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	mov	r6, r0
	bhi	.L1802
	ldr	r1, .L1833+16
	movw	r2, #2177
	ldr	r0, .L1833+20
	bl	printf
	ldr	r0, .L1833+24
	ldr	r1, .L1833+28
	bl	printf
.L1802:
	ldr	r3, .L1833+32
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r6, lsl #1]
	cbz	r3, .L1803
	mov	r0, r6
.L1825:
	bl	decrement_vpc_count
	b	.L1783
.L1803:
	mov	r1, r6
	ldr	r0, .L1833+36
	bl	printf
	b	.L1783
.L1787:
	ldrh	r3, [r4, #0]
	mov	r1, r6
	ldr	r2, .L1833+40
	ldr	r0, .L1833+44
	strh	r3, [r2, #0]	@ movhi
	mov	r2, r5
	bl	printf
	ldr	r0, .L1833+48
	ldr	r3, [r0, #0]
	cmp	r3, #31
	bhi	.L1804
	ldr	r2, [sp, #60]
	ldr	r1, .L1833+52
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r0, #0]
.L1804:
	ldrh	r0, [r4, #0]
	bl	decrement_vpc_count
	ldr	r2, .L1833+56
	ldr	r3, [r2, #0]
	adds	r1, r3, #1
	bne	.L1805
	str	r5, [r2, #0]
	b	.L1783
.L1805:
	cmp	r3, r5
	itt	hi
	ldrhi	r3, .L1833+56
	strhi	r5, [r3, #0]
.L1783:
	add	r8, r8, #36
.L1782:
	ldr	ip, [sp, #40]
	cmp	r8, ip
	bne	.L1806
	ldr	sl, [sp, #32]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	add	sl, sl, #1
	cmp	r3, #1
	uxth	sl, sl
	bne	.L1807
	ldr	r3, .L1833+60
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1807
	ldr	r3, .L1833+64
	ldrh	r3, [r3, #0]
	cmp	r3, sl
	bne	.L1807
	ldr	r3, [sp, #12]
	cmp	r3, sl
	beq	.L1820
.L1807:
	ldr	r3, .L1833+68
	ldrh	r3, [r3, #0]
	cmp	sl, r3
	bne	.L1777
	ldr	r2, .L1833+72
	movs	r3, #0
	strh	sl, [r4, #2]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	ldrh	r1, [r2, #0]
	movw	r2, #65535
	ldr	r0, [sp, #44]
	b	.L1808
.L1810:
	adds	r0, r0, #2
	ldrh	r5, [r0, #14]
	cmp	r5, r2
	beq	.L1809
.L1826:
	strb	r3, [r4, #6]
	b	.L1737
.L1809:
	adds	r3, r3, #1
	uxth	r3, r3
.L1808:
	cmp	r3, r1
	bne	.L1810
	b	.L1737
.L1820:
.L1786:
	ldr	r6, [sp, #12]
	mov	r0, r4
	ldr	r5, [sp, #16]
	mov	r1, r6
	mov	r2, r5
	strh	r6, [r4, #2]	@ movhi
	strb	r5, [r4, #6]
.L1827:
	bl	ftl_sb_update_avl_pages
.L1737:
	movs	r0, #0
	add	sp, sp, #64
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1834:
	.align	2
.L1833:
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR55
	.word	.LANCHOR228
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR101
	.word	.LC42
	.word	.LANCHOR229
	.word	.LC43
	.word	.LANCHOR231
	.word	.LANCHOR232
	.word	.LANCHOR141
	.word	.LANCHOR7
	.word	.LANCHOR69
	.word	.LANCHOR68
	.word	.LANCHOR53
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlPowerLostRecovery,"ax",%progbits
	.align	1
	.global	FtlPowerLostRecovery
	.thumb
	.thumb_func
	.type	FtlPowerLostRecovery, %function
FtlPowerLostRecovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r3, .L1836
	ldr	r5, .L1836+4
	str	r4, [r3, #0]
	mov	r0, r5
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1836+8
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
.L1837:
	.align	2
.L1836:
	.word	.LANCHOR231
	.word	.LANCHOR109
	.word	.LANCHOR110
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
	.section	.text.FtlSysBlkInit,"ax",%progbits
	.align	1
	.global	FtlSysBlkInit
	.thumb
	.thumb_func
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1848
	movs	r2, #0
	push	{r4, r5, r6, lr}
	movw	r4, #65535
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L1848+4
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1848+8
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1848+12
	ldrh	r3, [r3, #0]
	cmp	r3, r4
	beq	.L1844
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L1845
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1848+16
	ldrh	r1, [r3, #0]
	ldr	r3, .L1848+20
	ldr	r2, [r3, #0]
	mov	r3, r4
	b	.L1840
.L1842:
	adds	r0, r2, r4
	adds	r4, r4, #12
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L1841
	adds	r3, r3, #1
.L1840:
	cmp	r3, r1
	blt	.L1842
	b	.L1847
.L1841:
	ldr	r5, .L1848+24
	movs	r6, #0
	ldr	r4, .L1848+28
	mov	r0, r5
	bl	FtlSuperblockPowerLostFix
	mov	r0, r4
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1848+32
	ldrh	r2, [r5, #0]
	ldrh	r1, [r5, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r2, .L1848+36
	ldrh	r0, [r4, #4]
	strb	r6, [r5, #6]
	ldrh	r1, [r2, #0]
	strh	r6, [r5, #4]	@ movhi
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #0]
	ldrh	r5, [r3, r1, lsl #1]
	subs	r0, r5, r0
	strh	r0, [r3, r1, lsl #1]	@ movhi
	ldrh	r3, [r2, #0]
	ldr	r0, .L1848+40
	strb	r6, [r4, #6]
	strh	r3, [r4, #2]	@ movhi
	strh	r6, [r4, #4]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	r0, .L1848+44
	bl	FtlMapBlkWriteDumpData
	ldr	r3, .L1848+48
	ldrh	r2, [r3, #30]
	adds	r2, r2, #1
	strh	r2, [r3, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	mov	r0, r6
	pop	{r4, r5, r6, pc}
.L1844:
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L1845:
	mov	r0, #-1
	pop	{r4, r5, r6, pc}
.L1847:
	ldr	r3, .L1848
	ldrh	r0, [r3, #0]
	cmp	r0, #0
	bne	.L1841
	pop	{r4, r5, r6, pc}
.L1849:
	.align	2
.L1848:
	.word	.LANCHOR230
	.word	.LANCHOR229
	.word	.LANCHOR54
	.word	.LANCHOR196
	.word	.LANCHOR83
	.word	.LANCHOR114
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR101
	.word	.LANCHOR68
	.word	.LANCHOR122
	.word	.LANCHOR215
	.word	.LANCHOR143
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.rk_ftl_garbage_collect,"ax",%progbits
	.align	1
	.global	rk_ftl_garbage_collect
	.thumb
	.thumb_func
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1912
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #32
	ldr	r2, [r3, #0]
	cmp	r2, #0
	bne	.L1901
	ldr	r3, .L1912+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1902
	ldr	r2, .L1912+8
	ldrh	r2, [r2, #0]
	cmp	r2, #47
	bls	.L1903
	ldr	r3, .L1912+12
	movw	r5, #65535
	ldrh	r4, [r3, #0]
	cmp	r4, r5
	beq	.L1852
	ldr	r1, .L1912+16
	ldrh	r2, [r1, #0]
	cmp	r2, r5
	itt	eq
	strheq	r4, [r1, #0]	@ movhi
	strheq	r2, [r3, #0]	@ movhi
.L1852:
	cmp	r0, #0
	bne	.L1904
	ldr	r3, .L1912+20
	ldrh	r3, [r3, #0]
	cmp	r3, #24
	bhi	.L1905
	ldr	r2, .L1912+24
	cmp	r3, #16
	ldrh	r4, [r2, #0]
	bls	.L1855
	lsrs	r4, r4, #5
	b	.L1854
.L1855:
	cmp	r3, #12
	bls	.L1856
	lsrs	r4, r4, #4
	b	.L1854
.L1856:
	cmp	r3, #8
	bls	.L1854
	lsrs	r4, r4, #2
	b	.L1854
.L1905:
	movs	r4, #1
.L1854:
	ldr	r2, .L1912+28
	ldrh	r1, [r2, #0]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1858
	ldr	r3, .L1912+32
	movw	r0, #65535
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	bne	.L1859
	ldr	r0, .L1912+16
	ldrh	r0, [r0, #0]
	cmp	r0, r3
	bne	.L1859
	ldr	r3, .L1912+36
	ldrh	r0, [r3, #0]
	cbnz	r0, .L1860
	ldr	r3, .L1912+40
	movs	r1, #3
	ldr	r3, [r3, #0]
	muls	r1, r3, r1
	ldr	r3, .L1912+44
	ldr	r3, [r3, #0]
	cmp	r3, r1, lsr #2
	bcs	.L1861
.L1860:
	ldr	r3, .L1912+48
	movs	r2, #3
	ldrh	r3, [r3, #0]
	muls	r2, r3, r2
	ldr	r3, .L1912+28
	asrs	r2, r2, #2
	strh	r2, [r3, #0]	@ movhi
	b	.L1862
.L1861:
	movs	r3, #18
	strh	r3, [r2, #0]	@ movhi
.L1862:
	ldr	r3, .L1912+52
	movs	r2, #0
	str	r2, [r3, #0]
	b	.L1851
.L1859:
	ldr	r3, .L1912+48
	movs	r2, #3
	ldrh	r3, [r3, #0]
	muls	r3, r2, r3
	asrs	r3, r3, #2
	strh	r3, [r1, #0]	@ movhi
.L1858:
	ldr	r3, .L1912+56
	ldrh	r3, [r3, #0]
	cbz	r3, .L1853
	adds	r4, r4, #32
	uxth	r4, r4
	b	.L1853
.L1904:
	movs	r4, #1
.L1853:
	ldr	r3, .L1912+60
	ldrh	r2, [r3, #0]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1864
	ldr	r3, .L1912+16
	ldrh	r1, [r3, #0]
	cmp	r1, r2
	beq	.L1865
	ldr	r0, .L1912+64
	ldr	r0, [r0, #0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L1866
	strh	r2, [r3, #0]	@ movhi
.L1866:
	ldrh	r1, [r3, #0]
	ldr	r2, .L1912+60
	strh	r1, [r2, #0]	@ movhi
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
.L1865:
	ldr	r5, .L1912+60
	movw	r6, #65535
	movs	r3, #0
	ldrh	r0, [r5, #0]
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L1864
	bl	IsBlkInGcList
	cbz	r0, .L1867
	strh	r6, [r5, #0]	@ movhi
.L1867:
	ldr	r3, .L1912+68
	ldr	r6, .L1912+60
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1868
	ldrh	r0, [r6, #0]
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L1868:
	ldrh	r2, [r6, #0]
	movw	r3, #65535
	ldr	r5, .L1912+60
	cmp	r2, r3
	beq	.L1864
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L1912+72
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2, #0]	@ movhi
	ldr	r3, .L1912+64
	ldrh	r2, [r5, #0]
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1912+76
	strh	r2, [r3, #0]	@ movhi
.L1864:
	ldr	r2, .L1912+60
	ldr	r1, .L1912+80
	ldrh	r3, [r2, #0]
	ldrh	r1, [r1, #0]
	cmp	r1, r3
	beq	.L1869
	ldr	r1, .L1912+84
	ldrh	r1, [r1, #0]
	cmp	r1, r3
	bne	.L1906
.L1870:
.L1869:
	movw	r3, #65535
	strh	r3, [r2, #0]	@ movhi
	b	.L1911
.L1906:
	ldr	r6, .L1912+88
	ldr	r7, .L1912+92
.L1908:
	ldr	r3, .L1912+60
	movw	r2, #65535
	ldrh	r8, [r3, #0]
	cmp	r8, r2
	bne	.L1872
	ldr	r2, .L1912+52
	mov	sl, r3
	ldr	fp, .L1912+64
	movs	r1, #0
	str	r1, [r2, #0]
.L1907:
	ldrh	r1, [r6, #0]
	mov	r0, r1
	str	r1, [sp, #8]
	bl	List_get_gc_head_node
	uxth	r5, r0
	strh	r5, [sl, #0]	@ movhi
	cmp	r5, r8
	bne	.L1874
	ldr	r3, .L1912+88
	movs	r2, #0
	movs	r0, #8
	strh	r2, [r3, #0]	@ movhi
	b	.L1851
.L1874:
	mov	r0, r5
	bl	IsBlkInGcList
	ldr	r2, [sp, #8]
	adds	r3, r2, #1
	cbnz	r0, .L1909
.L1875:
	ldr	r1, .L1912+24
	uxth	r0, r3
	ldr	r3, [fp, #0]
	strh	r0, [r6, #0]	@ movhi
	ldrh	ip, [r1, #0]
	ldr	r1, .L1912+96
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r1, [r1, #0]
	mul	r1, r1, ip
	cmp	r2, r1, asr #1
	bgt	.L1877
	cmp	r0, #48
	bls	.L1878
	cmp	r2, #8
	bls	.L1878
	ldr	r2, .L1912+100
	ldrh	r2, [r2, #0]
	cmp	r2, #35
	bhi	.L1878
.L1877:
	movs	r2, #0
	strh	r2, [r6, #0]	@ movhi
.L1878:
	ldrh	r2, [r3, r5, lsl #1]
	ldr	r3, .L1912+60
	cmp	r2, r1
	blt	.L1879
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L1912+88
	movs	r2, #0
	strh	r2, [r3, #0]	@ movhi
	b	.L1911
.L1879:
	cmp	r2, #0
	bne	.L1880
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r6, #0]
	adds	r3, r3, #1
.L1909:
	strh	r3, [r6, #0]	@ movhi
	b	.L1907
.L1913:
	.align	2
.L1912:
	.word	.LANCHOR94
	.word	.LANCHOR168
	.word	.LANCHOR103
	.word	.LANCHOR150
	.word	.LANCHOR149
	.word	.LANCHOR106
	.word	.LANCHOR68
	.word	.LANCHOR173
	.word	.LANCHOR111
	.word	.LANCHOR233
	.word	.LANCHOR88
	.word	.LANCHOR118
	.word	.LANCHOR201
	.word	.LANCHOR169
	.word	.LANCHOR151
	.word	.LANCHOR202
	.word	.LANCHOR101
	.word	.LANCHOR7
	.word	.LANCHOR234
	.word	.LANCHOR235
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR175
	.word	.LANCHOR135
	.word	.LANCHOR53
	.word	.LANCHOR145
.L1880:
	movs	r2, #0
	strb	r2, [r3, #8]
	ldr	r2, .L1914
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1881
	mov	r0, r5
	str	r3, [sp, #4]
	bl	ftl_get_blk_mode
	ldr	r3, [sp, #4]
	strb	r0, [r3, #8]
.L1881:
	ldr	r5, .L1914+4
	ldr	r3, .L1914+8
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1882
	ldr	r1, .L1914+12
	movw	r2, #835
	ldr	r0, .L1914+16
	bl	printf
	ldr	r0, .L1914+20
	ldr	r1, .L1914+24
	bl	printf
.L1882:
	ldr	r3, .L1914+28
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1883
	ldr	r1, .L1914+12
	mov	r2, #836
	ldr	r0, .L1914+16
	bl	printf
	ldr	r0, .L1914+20
	ldr	r1, .L1914+24
	bl	printf
.L1883:
	ldr	r5, .L1914+4
	ldr	r3, .L1914+32
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1884
	ldr	r1, .L1914+12
	movw	r2, #837
	ldr	r0, .L1914+16
	bl	printf
	ldr	r0, .L1914+20
	ldr	r1, .L1914+24
	bl	printf
.L1884:
	ldr	r0, .L1914+4
	bl	make_superblock
	ldr	r1, .L1914+36
	movs	r3, #0
	ldrh	r0, [r5, #0]
	strh	r3, [r1, #0]	@ movhi
	ldr	r1, .L1914+40
	ldr	r1, [r1, #0]
	ldrh	r0, [r1, r0, lsl #1]
	ldr	r1, .L1914+44
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r0, [r1, #0]	@ movhi
.L1872:
	ldr	r3, .L1914+48
	movs	r2, #1
	str	r2, [r3, #0]
	ldr	r3, .L1914+52
	ldrh	r3, [r3, #0]
	str	r3, [sp, #8]
	ldr	r3, .L1914
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	ldr	r3, .L1914+4
	cbz	r2, .L1885
	ldrb	r2, [r3, #8]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L1885
	ldr	r2, .L1914+56
	ldrh	r2, [r2, #0]
	str	r2, [sp, #8]
.L1885:
	ldrh	r3, [r3, #2]
	ldr	r8, [sp, #8]
	adds	r2, r3, r4
	cmp	r2, r8
	itt	gt
	rsbgt	r4, r3, r8
	uxthgt	r4, r4
	movs	r3, #0
	str	r4, [sp, #20]
	str	r3, [sp, #12]
	b	.L1887
.L1889:
	ldrh	r1, [r2, #2]!
	movw	r8, #65535
	cmp	r1, r8
	beq	.L1888
	mla	r8, r0, r5, lr
	adds	r5, r5, #1
	orr	r1, r4, r1, lsl #10
	uxth	r5, r5
	str	r1, [r8, #4]
.L1888:
	adds	r3, r3, #1
	uxth	r3, r3
.L1896:
	cmp	r3, ip
	bne	.L1889
	ldr	r3, .L1914+4
	mov	r1, r5
	ldr	r0, [r7, #0]
	movs	r4, #0
	mov	sl, r5
	ldrb	r2, [r3, #8]	@ zero_extendqisi2
	bl	FlashReadPages
	str	r4, [sp, #16]
	b	.L1890
.L1894:
	ldr	r3, [r7, #0]
	adds	r2, r3, r4
	ldr	r3, [r3, r4]
	ldr	r5, [r2, #12]
	adds	r3, r3, #1
	beq	.L1891
	ldrh	r3, [r5, #0]
	movw	r8, #61589
	cmp	r3, r8
	bne	.L1891
	ldr	r8, [r5, #8]
	cmp	r8, #-1
	bne	.L1892
	ldr	r1, .L1914+12
	mov	r2, #876
	ldr	r0, .L1914+16
	bl	printf
	ldr	r0, .L1914+20
	ldr	r1, .L1914+24
	bl	printf
.L1892:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r8
	bl	log2phys
	ldr	r2, [r7, #0]
	ldr	r1, [sp, #28]
	adds	r2, r2, r4
	bic	r1, r1, #-2147483648
	ldr	r3, [r2, #4]
	cmp	r1, r3
	bne	.L1891
	ldr	r0, .L1914+36
	mov	fp, #36
	ldr	r8, .L1914+72
	ldr	r2, [r2, #16]
	ldrh	r3, [r0, #0]
	ldr	r1, [r8, #0]
	adds	r3, r3, #1
	strh	r3, [r0, #0]	@ movhi
	ldr	r0, .L1914+60
	ldr	r3, [r0, #0]
	mla	r3, fp, r1, r3
	str	r2, [r3, #16]
	str	r3, [sp, #4]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #4]
	ldr	r1, .L1914+60
	ldr	r2, [r1, #0]
	str	r0, [r3, #4]
	ldr	r3, [r8, #0]
	ldr	r0, [r7, #0]
	mla	r2, fp, r3, r2
	adds	r0, r0, r4
	ldr	fp, .L1914+32
	adds	r3, r3, #1
	ldr	r1, [r0, #8]
	str	r1, [r2, #8]
	ldr	r1, [r0, #12]
	str	r1, [r2, #12]
	movs	r1, #1
	ldr	r2, [sp, #28]
	str	r2, [r5, #12]
	ldrh	r2, [fp, #0]
	strh	r2, [r5, #2]	@ movhi
	ldr	r2, .L1914+64
	str	r3, [r8, #0]
	ldr	r2, [r2, #0]
	str	r2, [r5, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L1914
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1893
	ldrb	r3, [fp, #7]	@ zero_extendqisi2
	ldr	r2, [r8, #0]
	cmp	r2, r3
	beq	.L1893
	ldrh	r3, [fp, #4]
	cbnz	r3, .L1891
.L1893:
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L1910
.L1891:
	ldr	r8, [sp, #16]
	adds	r4, r4, #36
	add	r3, r8, #1
	uxth	r3, r3
	str	r3, [sp, #16]
.L1890:
	ldr	r3, [sp, #16]
	cmp	r3, sl
	bne	.L1894
	ldr	r8, [sp, #12]
	add	r8, r8, #1
	str	r8, [sp, #12]
.L1887:
	ldr	r8, [sp, #12]
	ldr	r2, .L1914+4
	uxth	r3, r8
	ldr	r8, [sp, #20]
	cmp	r3, r8
	bcs	.L1895
	ldr	r3, .L1914+68
	movs	r5, #0
	ldrh	r4, [r2, #2]
	movs	r0, #36
	ldr	lr, [r7, #0]
	adds	r2, r2, #14
	ldrh	ip, [r3, #0]
	ldr	r3, [sp, #12]
	adds	r4, r4, r3
	mov	r3, r5
	b	.L1896
.L1895:
	ldrh	r3, [r2, #2]
	ldr	r4, [sp, #20]
	ldr	r8, [sp, #8]
	adds	r4, r4, r3
	uxth	r4, r4
	strh	r4, [r2, #2]	@ movhi
	cmp	r4, r8
	bcc	.L1897
	ldr	r3, .L1914+72
	ldr	r3, [r3, #0]
	cbz	r3, .L1898
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1898
.L1910:
	ldr	r3, .L1914+48
	movs	r2, #0
	str	r2, [r3, #0]
.L1911:
	ldr	r3, .L1914+76
	ldrh	r0, [r3, #0]
	b	.L1851
.L1898:
	ldr	r3, .L1914+36
	ldrh	r0, [r3, #0]
	cbnz	r0, .L1899
	ldr	r3, .L1914+4
	ldr	r2, .L1914+40
	ldrh	r1, [r3, #0]
	ldr	r2, [r2, #0]
	ldrh	r4, [r2, r1, lsl #1]
	cbz	r4, .L1899
	strh	r0, [r2, r1, lsl #1]	@ movhi
	ldrh	r0, [r3, #0]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1899:
	ldr	r3, .L1914+4
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
.L1897:
	ldr	r3, .L1914+80
	ldrh	r0, [r3, #0]
	cmp	r0, #2
	bhi	.L1900
	ldr	r3, .L1914+52
	ldrh	r4, [r3, #0]
	b	.L1908
.L1900:
	ldr	r3, .L1914+48
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3, #0]
	b	.L1851
.L1915:
	.align	2
.L1914:
	.word	.LANCHOR7
	.word	.LANCHOR202
	.word	.LANCHOR109
	.word	.LANCHOR236
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR110
	.word	.LANCHOR111
	.word	.LANCHOR234
	.word	.LANCHOR101
	.word	.LANCHOR235
	.word	.LANCHOR168
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR178
	.word	.LANCHOR157
	.word	.LANCHOR53
	.word	.LANCHOR131
	.word	.LANCHOR233
	.word	.LANCHOR106
.L1901:
	movs	r0, #0
	b	.L1851
.L1902:
	mov	r0, r2
	b	.L1851
.L1903:
	mov	r0, r3
.L1851:
	add	sp, sp, #32
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.ftl_fix_nand_power_lost_error,"ax",%progbits
	.align	1
	.global	ftl_fix_nand_power_lost_error
	.thumb
	.thumb_func
	.type	ftl_fix_nand_power_lost_error, %function
ftl_fix_nand_power_lost_error:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1925
	push	{r4, r5, r6, r7, r8, lr}
	sub	sp, sp, #48
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1916
	ldr	r3, .L1925+4
	ldr	r5, .L1925+8
	ldr	r8, .L1925+32
	ldrh	r4, [r3, #0]
	ldr	r3, [r5, #0]
	ldr	r7, .L1925+12
	mov	r1, r4
	ldr	r0, .L1925+16
	lsls	r6, r4, #1
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
	ldrh	r0, [r8, #0]
	bl	FtlGcRefreshOpenBlock
	ldrh	r0, [r7, #0]
	bl	FtlGcRefreshOpenBlock
	mov	r0, r8
	bl	allocate_new_data_superblock
	mov	r0, r7
	bl	allocate_new_data_superblock
	movw	r7, #4097
	b	.L1918
.L1920:
	movs	r0, #1
	mov	r1, r0
	bl	rk_ftl_garbage_collect
	ldr	r3, [r5, #0]
	ldrh	r3, [r3, r6]
	cbz	r3, .L1919
.L1918:
	subs	r7, r7, #1
	bne	.L1920
.L1919:
	ldr	r5, .L1925+8
	mov	r1, r4
	ldr	r0, .L1925+16
	ldr	r3, [r5, #0]
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
	ldr	r3, [r5, #0]
	ldrh	r5, [r3, r4, lsl #1]
	cmp	r5, #0
	bne	.L1921
	add	r6, sp, #48
	mov	r0, sp
	movs	r7, #36
	strh	r4, [r6, #-48]!	@ movhi
	adds	r6, r6, #14
	bl	make_superblock
	ldr	r3, .L1925+20
	movw	lr, #65535
	mov	r1, r5
	ldrh	r8, [r3, #0]
	ldr	r3, .L1925+24
	ldr	ip, [r3, #0]
	mov	r3, r5
	b	.L1922
.L1924:
	ldrh	r0, [r6, #2]!
	cmp	r0, lr
	beq	.L1923
	mla	r2, r7, r5, ip
	adds	r5, r5, #1
	lsls	r0, r0, #10
	uxth	r5, r5
	str	r0, [r2, #4]
	str	r1, [r2, #8]
	str	r1, [r2, #12]
.L1923:
	adds	r3, r3, #1
	uxth	r3, r3
.L1922:
	cmp	r3, r8
	bne	.L1924
	ldr	r3, .L1925+8
	mov	r1, r4
	ldr	r0, .L1925+28
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r4, lsl #1]
	ldr	r4, .L1925+24
	bl	printf
	movs	r1, #0
	mov	r2, r5
	ldr	r0, [r4, #0]
	bl	FlashEraseBlocks
	ldr	r0, [r4, #0]
	movs	r1, #1
	mov	r2, r5
	bl	FlashEraseBlocks
.L1921:
	ldr	r3, .L1925+4
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
.L1916:
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, pc}
.L1926:
	.align	2
.L1925:
	.word	.LANCHOR7
	.word	.LANCHOR229
	.word	.LANCHOR101
	.word	.LANCHOR110
	.word	.LC44
	.word	.LANCHOR53
	.word	.LANCHOR95
	.word	.LC45
	.word	.LANCHOR109
	.size	ftl_fix_nand_power_lost_error, .-ftl_fix_nand_power_lost_error
	.section	.text.FtlInit,"ax",%progbits
	.align	1
	.global	FtlInit
	.thumb
	.thumb_func
	.type	FtlInit, %function
FtlInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
.L1928:
	push	{r3, r4, r5, lr}
	mov	r3, #-1
	ldr	r2, .L1935
	mov	r5, r0
	ldr	r4, .L1935+4
	ldr	r1, .L1935+8
	ldr	r0, .L1935+12
	str	r3, [r4, #0]
	movs	r3, #0
	str	r3, [r2, #0]
	ldr	r2, .L1935+16
	str	r3, [r2, #0]
	bl	printf
	mov	r0, r5
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1935+20
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1929
	ldr	r0, .L1935+24
	b	.L1934
.L1929:
	bl	FtlSysBlkInit
	cbz	r0, .L1931
	ldr	r0, .L1935+28
.L1934:
	ldr	r1, .L1935+32
	bl	printf
	b	.L1930
.L1931:
	movs	r1, #1
	str	r1, [r4, #0]
	bl	rk_ftl_garbage_collect
	ldr	r3, .L1935+36
	ldrh	r3, [r3, #0]
	cmp	r3, #15
	bhi	.L1930
	mov	r4, #1024
.L1932:
	movs	r0, #1
	mov	r1, r0
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L1932
.L1930:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1936:
	.align	2
.L1935:
	.word	.LANCHOR237
	.word	.LANCHOR225
	.word	.LC46
	.word	.LC10
	.word	.LANCHOR94
	.word	.LANCHOR54
	.word	.LC47
	.word	.LC48
	.word	.LANCHOR238
	.word	.LANCHOR106
	.size	FtlInit, .-FtlInit
	.section	.text.ftl_write,"ax",%progbits
	.align	1
	.global	ftl_write
	.thumb
	.thumb_func
	.type	ftl_write, %function
ftl_write:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	cmp	r0, #16
	sub	sp, sp, #80
	mov	r5, r1
	str	r2, [sp, #12]
	str	r3, [sp, #4]
	bne	.L1938
	add	r0, r1, #256
	mov	r1, r2
	mov	r2, r3
	bl	FtlVendorPartWrite
	b	.L1939
.L1938:
	ldr	r3, .L1980
	ldr	r0, [sp, #12]
	ldr	r3, [r3, #0]
	adds	r7, r0, r1
	cmp	r7, r3
	bhi	.L1970
	ldr	r3, .L1980+4
	ldr	r0, [r3, #0]
	adds	r3, r0, #1
	beq	.L1939
	ldr	r3, .L1980+8
	mov	r2, #2048
	mov	r0, r1
	str	r2, [r3, #0]
	ldr	r3, .L1980+12
	ldrh	r6, [r3, #0]
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mov	sl, r0
	subs	r0, r7, #1
	bl	__aeabi_uidiv
	ldr	r3, .L1980+16
	ldr	r2, [r3, #0]
	rsb	r4, sl, r0
	str	r0, [sp, #24]
	adds	r1, r4, #1
	str	r1, [sp, #0]
	adds	r2, r1, r2
	str	r2, [r3, #0]
	ldr	r3, .L1980+20
	ldr	r7, [r3, #0]
	cbz	r7, .L1940
	ldr	r3, [r7, #16]
	cmp	sl, r3
	beq	.L1941
	bl	FtlCacheWriteBack
	b	.L1940
.L1941:
	ldr	r3, .L1980+24
	mov	r1, r6
	mov	r0, r5
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	ldr	r0, [r7, #8]
	subs	r6, r6, r1
	add	r0, r0, r1, lsl #9
	cmp	r6, r2
	it	cs
	movcs	r6, r2
	ldr	r1, [sp, #4]
	lsl	r8, r6, #9
	mov	r2, r8
	bl	memcpy
	cmp	r4, #0
	beq	.L1972
	ldr	r3, [sp, #12]
	adds	r5, r5, r6
	ldr	r0, [sp, #4]
	add	sl, sl, #1
	subs	r3, r3, r6
	str	r3, [sp, #12]
	add	r0, r0, r8
	str	r0, [sp, #4]
	bl	FtlCacheWriteBack
	str	r4, [sp, #0]
.L1940:
	mov	r4, sl
	str	sl, [sp, #20]
	ldr	r6, .L1980+28
	mov	sl, r5
	b	.L1942
.L1969:
	ldr	r1, .L1980+32
	ldrb	r2, [r6, #6]	@ zero_extendqisi2
	ldrh	r3, [r1, #0]
	cmp	r2, r3
	bcc	.L1943
	ldr	r1, .L1980+36
	movw	r2, #1630
	ldr	r0, .L1980+40
	bl	printf
	ldr	r0, .L1980+44
	ldr	r1, .L1980+48
	bl	printf
.L1943:
	ldr	r2, .L1980+28
	ldrh	r3, [r2, #4]
	cbnz	r3, .L1944
	bl	FtlCacheWriteBack
	ldr	r0, .L1980+28
	bl	allocate_new_data_superblock
.L1944:
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6, #4]
	ldr	r1, .L1980+32
	lsls	r3, r3, #2
	ldr	r0, [sp, #0]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldrb	r2, [r6, #6]	@ zero_extendqisi2
	cmp	r3, r0
	it	cc
	movcc	r0, r3
	ldrh	r3, [r1, #0]
	str	r0, [sp, #8]
	cmp	r2, r3
	bcc	.L1945
	ldr	r1, .L1980+36
	movw	r2, #1663
	ldr	r0, .L1980+40
	bl	printf
	ldr	r0, .L1980+44
	ldr	r1, .L1980+48
	bl	printf
.L1945:
	movs	r3, #0
	ldr	r5, .L1980+52
	str	r3, [sp, #16]
	b	.L1946
.L1965:
	ldrh	r3, [r6, #4]
	cmp	r3, #0
	beq	.L1973
	movs	r2, #0
	add	r1, sp, #76
	mov	r0, r4
	movs	r7, #36
	bl	log2phys
	ldr	r0, .L1980+28
	bl	get_new_active_ppa
	ldr	r3, [sp, #16]
	muls	r7, r3, r7
	ldr	r3, [r5, #0]
	adds	r3, r3, r7
	str	r4, [r3, #16]
	str	r0, [r3, #4]
	ldr	r0, .L1980+56
	ldrh	r2, [r0, #0]
	ldr	r0, [sp, #16]
	mul	r1, r2, r0
	lsrs	r1, r1, #2
	str	r1, [sp, #32]
	ldr	r1, .L1980+60
	ldr	r0, [sp, #32]
	ldr	r1, [r1, #0]
	add	r8, r1, r0, lsl #2
	str	r8, [r3, #12]
	str	r1, [sp, #36]
	mov	r0, r8
	movs	r1, #0
	bl	memset
	ldr	r1, [sp, #20]
	ldr	r3, .L1980+12
	cmp	r4, r1
	beq	.L1948
	ldr	r2, [sp, #24]
	cmp	r4, r2
	bne	.L1975
	b	.L1979
.L1948:
	ldrh	fp, [r3, #0]
	mov	r0, sl
	mov	r1, fp
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #12]
	rsb	fp, r1, fp
	str	r1, [sp, #28]
	cmp	fp, r3
	it	cs
	movcs	fp, r3
	b	.L1951
.L1979:
	ldr	r0, [sp, #12]
	ldrh	fp, [r3, #0]
	movs	r3, #0
	add	r2, sl, r0
	str	r3, [sp, #28]
	mls	fp, r4, fp, r2
	uxth	fp, fp
.L1951:
	ldr	r3, .L1980+12
	ldrh	r3, [r3, #0]
	cmp	fp, r3
	bne	.L1952
	ldr	r0, [sp, #20]
	ldr	r3, [r5, #0]
	cmp	r4, r0
	add	r7, r3, r7
	bne	.L1953
	ldr	r1, [sp, #4]
	str	r1, [r7, #8]
	b	.L1954
.L1953:
	mul	r3, fp, r4
	ldr	r2, [sp, #4]
	rsb	r3, sl, r3
	add	r3, r2, r3, lsl #9
	b	.L1978
.L1952:
	ldr	r3, [sp, #20]
	cmp	r4, r3
	ldr	r3, [r5, #0]
	it	eq
	ldreq	r2, .L1980+64
	add	r3, r3, r7
	it	ne
	ldrne	r2, .L1980+68
	ldr	r2, [r2, #0]
	str	r2, [r3, #8]
	ldr	r3, [sp, #76]
	adds	r1, r3, #1
	beq	.L1957
	str	r3, [sp, #44]
	movs	r1, #1
	ldr	r3, [r5, #0]
	add	r0, sp, #40
	str	r4, [sp, #56]
	adds	r3, r3, r7
	ldr	r2, [r3, #8]
	ldr	r3, [r3, #12]
	str	r2, [sp, #48]
	movs	r2, #0
	str	r3, [sp, #52]
	bl	FlashReadPages
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	bne	.L1958
	ldr	r3, .L1980+72
	ldr	r2, [r3, #72]
	adds	r2, r2, #1
	str	r2, [r3, #72]
	b	.L1959
.L1958:
	ldr	r1, [r8, #8]
	cmp	r1, r4
	beq	.L1960
	ldr	r3, .L1980+72
	ldr	r0, .L1980+76
	ldr	r2, [r3, #72]
	adds	r2, r2, #1
	str	r2, [r3, #72]
	mov	r2, r4
	bl	printf
.L1960:
	ldr	r3, [r8, #8]
	cmp	r3, r4
	beq	.L1959
	ldr	r1, .L1980+36
	movw	r2, #1716
	ldr	r0, .L1980+40
	bl	printf
	ldr	r1, .L1980+48
	ldr	r0, .L1980+44
	bl	printf
	b	.L1959
.L1957:
	ldr	r3, [r5, #0]
	movs	r1, #0
	adds	r3, r3, r7
	ldr	r0, [r3, #8]
	ldr	r3, .L1980+80
	ldrh	r2, [r3, #0]
	bl	memset
.L1959:
	ldr	r0, [sp, #20]
	ldr	r3, [r5, #0]
	cmp	r4, r0
	add	r3, r3, r7
	bne	.L1961
	ldr	r0, [r3, #8]
	ldr	r3, [sp, #28]
	ldr	r1, [sp, #4]
	add	r0, r0, r3, lsl #9
	b	.L1977
.L1981:
	.align	2
.L1980:
	.word	.LANCHOR84
	.word	.LANCHOR225
	.word	.LANCHOR239
	.word	.LANCHOR71
	.word	.LANCHOR159
	.word	.LANCHOR137
	.word	.LANCHOR161
	.word	.LANCHOR109
	.word	.LANCHOR53
	.word	.LANCHOR240
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR179
	.word	.LANCHOR74
	.word	.LANCHOR185
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	.LANCHOR144
	.word	.LC49
	.word	.LANCHOR73
.L1961:
	ldr	r2, .L1982
	ldr	r0, [r3, #8]
	ldrh	r1, [r2, #0]
	muls	r1, r4, r1
	ldr	r2, [sp, #4]
	rsb	r1, sl, r1
	add	r1, r2, r1, lsl #9
.L1977:
	lsl	r2, fp, #9
	bl	memcpy
	ldr	r3, [sp, #24]
	cmp	r4, r3
	bne	.L1954
	ldrh	r3, [r6, #4]
	cbz	r3, .L1954
	ldr	r3, [r5, #0]
	adds	r7, r3, r7
	ldr	r3, .L1982+4
	str	r7, [r3, #0]
	ldr	r3, .L1982+8
	str	r6, [r3, #0]
	b	.L1954
.L1975:
	ldr	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	muls	r3, r4, r3
	ldr	r0, [sp, #4]
	rsb	r3, sl, r3
	adds	r7, r2, r7
	add	r3, r0, r3, lsl #9
.L1978:
	str	r3, [r7, #8]
.L1954:
	ldr	r1, .L1982+12
	ldrb	r2, [r6, #6]	@ zero_extendqisi2
	ldrh	r3, [r1, #0]
	cmp	r2, r3
	bcc	.L1963
	ldr	r1, .L1982+16
	movw	r2, #1737
	ldr	r0, .L1982+20
	bl	printf
	ldr	r0, .L1982+24
	ldr	r1, .L1982+28
	bl	printf
.L1963:
	ldr	r2, [sp, #36]
	movw	r3, #61589
	ldr	r0, [sp, #32]
	strh	r3, [r2, r0, lsl #2]	@ movhi
	ldr	r3, .L1982+32
	ldr	r2, [r3, #0]
	str	r2, [r8, #4]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	adds	r2, r2, #1
	bne	.L1964
	movs	r2, #0
	str	r2, [r3, #0]
.L1964:
	ldr	r3, [sp, #76]
	str	r4, [r8, #8]
	adds	r4, r4, #1
	str	r3, [r8, #12]
	ldrh	r3, [r6, #0]
	strh	r3, [r8, #2]	@ movhi
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	str	r3, [sp, #16]
.L1946:
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #8]
	cmp	r3, r0
	bne	.L1965
	b	.L1947
.L1973:
	ldr	r3, [sp, #16]
	str	r3, [sp, #8]
.L1947:
	ldr	r3, .L1982+4
	ldr	r3, [r3, #0]
	cbz	r3, .L1966
	ldr	r0, [sp, #8]
	subs	r0, r0, #1
	str	r0, [sp, #8]
	beq	.L1967
	ldr	r1, [sp, #0]
	subs	r1, r1, #1
	str	r1, [sp, #0]
.L1966:
	ldr	r3, .L1982+36
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r3, #0]
	ldr	r3, .L1982+40
	bl	FtlProgPages
	ldr	r2, [sp, #0]
	ldr	r3, [sp, #8]
	cmp	r2, r3
	bcs	.L1968
	ldr	r1, .L1982+16
	mov	r2, #1752
	ldr	r0, .L1982+20
	bl	printf
	ldr	r0, .L1982+24
	ldr	r1, .L1982+28
	bl	printf
.L1968:
	ldr	r0, [sp, #0]
	ldr	r1, [sp, #8]
	subs	r0, r0, r1
	str	r0, [sp, #0]
.L1942:
	ldr	r2, [sp, #0]
	cmp	r2, #0
	bne	.L1969
.L1967:
	ldr	sl, [sp, #20]
	movs	r0, #0
	ldr	r3, [sp, #24]
	rsb	r1, sl, r3
	bl	rk_ftl_garbage_collect
	movs	r0, #0
	b	.L1939
.L1970:
	mov	r0, #-1
	b	.L1939
.L1972:
	mov	r0, r4
.L1939:
	add	sp, sp, #80
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1983:
	.align	2
.L1982:
	.word	.LANCHOR71
	.word	.LANCHOR137
	.word	.LANCHOR224
	.word	.LANCHOR53
	.word	.LANCHOR240
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR157
	.word	.LANCHOR179
	.word	.LANCHOR109
	.size	ftl_write, .-ftl_write
	.section	.text.ftl_read,"ax",%progbits
	.align	1
	.global	ftl_read
	.thumb
	.thumb_func
	.type	ftl_read, %function
ftl_read:
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	cmp	r0, #16
	sub	sp, sp, #72
	mov	r4, r1
	mov	r7, r3
	str	r2, [sp, #36]
	bne	.L1985
	add	r0, r1, #256
	mov	r1, r2
	mov	r2, r3
	bl	FtlVendorPartRead
	str	r0, [sp, #12]
	b	.L1986
.L1985:
	ldr	r3, [sp, #36]
	adds	r3, r3, r1
	str	r3, [sp, #16]
	ldr	r3, .L2018
	ldr	r1, [sp, #16]
	ldr	r3, [r3, #0]
	cmp	r1, r3
	bhi	.L2006
	ldr	r3, .L2018+4
	ldr	r3, [r3, #0]
	adds	r2, r3, #1
	beq	.L2007
	ldr	fp, .L2018+48
	bl	FtlCacheWriteBack
	mov	r0, r4
	mov	sl, #0
	mov	r8, r4
	ldrh	r5, [fp, #0]
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	mov	r1, r5
	mov	r5, sl
	str	r0, [sp, #20]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r1, [sp, #20]
	ldr	r6, [sp, #20]
	rsb	r3, r1, #1
	str	sl, [sp, #32]
	str	sl, [sp, #12]
	adds	r3, r3, r0
	str	r3, [sp, #8]
	ldr	r3, .L2018+8
	ldr	r1, [sp, #8]
	str	r0, [sp, #24]
	ldr	r2, [r3, #0]
	adds	r2, r1, r2
	str	r2, [r3, #0]
	b	.L2013
.L2005:
	movs	r2, #0
	mov	r0, r6
	add	r1, sp, #68
	bl	log2phys
	ldr	r3, [sp, #68]
	adds	r0, r3, #1
	bne	.L2014
	b	.L2017
.L1991:
	mla	r0, r0, r6, r4
	cmp	r0, r8
	bcc	.L1990
	ldr	r3, [sp, #16]
	cmp	r0, r3
	bcs	.L1990
	rsb	r0, r8, r0
	movs	r1, #0
	mov	r2, #512
	add	r0, r7, r0, lsl #9
	bl	memset
.L1990:
	adds	r4, r4, #1
	b	.L1988
.L2017:
	movs	r4, #0
.L1988:
	ldrh	r0, [fp, #0]
	cmp	r4, r0
	bcc	.L1991
	b	.L1992
.L2014:
	ldr	r2, .L2018+12
	movs	r4, #36
	ldr	r2, [r2, #0]
	mla	r4, r4, r5, r2
	str	r3, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r6, r3
	bne	.L1993
	ldr	r3, .L2018+16
	mov	r0, r8
	ldr	r3, [r3, #0]
	str	r3, [r4, #8]
	ldrh	r3, [fp, #0]
	mov	r1, r3
	str	r3, [sp, #4]
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #4]
	str	r1, [sp, #40]
	subs	r2, r3, r1
	ldr	r1, [sp, #36]
	cmp	r2, r1
	it	cc
	movcc	r1, r2
	str	r1, [sp, #32]
	cmp	r1, r3
	bne	.L1994
	str	r7, [r4, #8]
	b	.L1994
.L1993:
	ldr	r3, [sp, #24]
	cmp	r6, r3
	bne	.L1995
	ldr	r3, .L2018+20
	ldrh	r2, [fp, #0]
	ldr	r1, [sp, #16]
	ldr	r3, [r3, #0]
	str	r3, [r4, #8]
	mul	r3, r2, r6
	rsb	sl, r3, r1
	cmp	sl, r2
	bne	.L1994
	b	.L2015
.L1995:
	ldrh	r3, [fp, #0]
	muls	r3, r6, r3
.L2015:
	rsb	r3, r8, r3
	add	r3, r7, r3, lsl #9
	str	r3, [r4, #8]
.L1994:
	ldr	r3, .L2018+24
	ldr	r2, .L2018+28
	str	r6, [r4, #16]
	ldrh	r3, [r3, #0]
	muls	r3, r5, r3
	ldr	r2, [r2, #0]
	adds	r5, r5, #1
	bic	r3, r3, #3
	adds	r3, r2, r3
	str	r3, [r4, #12]
.L1992:
	ldr	r3, [sp, #8]
	adds	r6, r6, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1996
	ldr	r3, .L2018+32
	ldrh	r3, [r3, #0]
	cmp	r5, r3, lsl #2
	bne	.L2013
.L1996:
	cmp	r5, #0
	beq	.L2013
	ldr	r4, .L2018+12
	mov	r1, r5
	movs	r2, #0
	ldr	r0, [r4, #0]
	bl	FlashReadPages
	ldr	r3, [sp, #40]
	str	r6, [sp, #60]
	lsls	r3, r3, #9
	str	r3, [sp, #44]
	ldr	r3, [sp, #32]
	lsls	r3, r3, #9
	str	r3, [sp, #48]
	lsl	r3, sl, #9
	str	r3, [sp, #52]
	movs	r3, #0
	str	r3, [sp, #28]
.L2004:
	movs	r6, #36
	ldr	r3, [sp, #28]
	muls	r6, r3, r6
	ldr	r3, [r4, #0]
	ldr	r1, [sp, #20]
	adds	r3, r3, r6
	ldr	r2, [r3, #16]
	cmp	r2, r1
	bne	.L1998
	ldr	r1, [r3, #8]
	ldr	r3, .L2018+16
	ldr	r3, [r3, #0]
	cmp	r1, r3
	bne	.L1999
	ldr	r3, [sp, #44]
	mov	r0, r7
	ldr	r2, [sp, #48]
	adds	r1, r1, r3
	b	.L2016
.L1998:
	ldr	r1, [sp, #24]
	cmp	r2, r1
	bne	.L1999
	ldr	r2, .L2018+20
	ldr	r1, [r3, #8]
	ldr	r3, [r2, #0]
	cmp	r1, r3
	bne	.L1999
	ldrh	r0, [fp, #0]
	ldr	r3, [sp, #24]
	muls	r0, r3, r0
	rsb	r0, r8, r0
	ldr	r2, [sp, #52]
	add	r0, r7, r0, lsl #9
.L2016:
	bl	memcpy
.L1999:
	ldr	r3, [r4, #0]
	adds	r2, r3, r6
	ldr	r3, [r3, r6]
	adds	r1, r3, #1
	bne	.L2000
	ldr	r2, .L2018+36
	str	r3, [sp, #12]
	ldr	r1, [r2, #72]
	adds	r1, r1, #1
	str	r1, [r2, #72]
	b	.L2001
.L2000:
	cmp	r3, #256
	bne	.L2001
	ldr	r0, [r2, #4]
	movw	r6, #2049
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	str	r0, [sp, #56]
	bl	FtlGcRefreshBlock
.L2003:
	subs	r6, r6, #1
	beq	.L2002
	movs	r0, #1
	mov	r1, r0
	bl	rk_ftl_garbage_collect
	ldr	r1, .L2018+40
	ldr	r2, [sp, #56]
	ldrh	r3, [r1, #0]
	cmp	r3, r2
	beq	.L2003
.L2002:
	bl	FtlSysFlush
.L2001:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	cmp	r3, r5
	bne	.L2004
	ldr	r6, [sp, #60]
	movs	r5, #0
.L2013:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L2005
	ldr	r3, .L2018+44
	ldrh	r3, [r3, #0]
	cbz	r3, .L1986
	ldr	r0, [sp, #8]
	movs	r1, #1
	bl	rk_ftl_garbage_collect
	b	.L1986
.L2006:
	mov	r3, #-1
.L2007:
	str	r3, [sp, #12]
.L1986:
	ldr	r0, [sp, #12]
	add	sp, sp, #72
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2019:
	.align	2
.L2018:
	.word	.LANCHOR84
	.word	.LANCHOR225
	.word	.LANCHOR163
	.word	.LANCHOR177
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	.LANCHOR74
	.word	.LANCHOR185
	.word	.LANCHOR53
	.word	.LANCHOR144
	.word	.LANCHOR202
	.word	.LANCHOR151
	.word	.LANCHOR71
	.size	ftl_read, .-ftl_read
	.section	.text.FlashReadFacBbtData,"ax",%progbits
	.align	1
	.global	FlashReadFacBbtData
	.thumb
	.thumb_func
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r3, r2
	ldr	r2, .L2029
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r6, r1
	ldrh	sl, [r2, #14]
	sub	sp, sp, #48
	ldrh	r1, [r2, #12]
	mov	r4, r0
	ldr	r2, .L2029+4
	movw	fp, #61664
	ldr	r7, .L2029+8
	mul	sl, sl, r1
	ldr	r2, [r2, #0]
	str	r2, [sp, #20]
	ldr	r2, [r7, #0]
	uxth	sl, sl
	add	r5, sl, #-1
	mul	r8, sl, r6
	str	r2, [sp, #24]
	uxth	r5, r5
	sub	sl, sl, #15
	b	.L2021
.L2027:
	add	r2, r5, r8
	movs	r1, #1
	add	r0, sp, #12
	str	r3, [sp, #4]
	lsls	r2, r2, #10
	str	r2, [sp, #16]
	mov	r2, r1
	bl	FlashReadPages
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L2022
	ldr	r2, [r7, #0]
	ldrh	r2, [r2, #0]
	cmp	r2, fp
	bne	.L2022
	cbz	r4, .L2028
	cbnz	r6, .L2024
	ldr	r2, .L2029+4
	movs	r0, #1
	ldr	r5, .L2029+12
	ldr	r2, [r2, #0]
	b	.L2025
.L2026:
	ubfx	r1, r6, #5, #16
	and	r7, r6, #31
	adds	r6, r6, #1
	lsl	r7, r0, r7
	ldr	lr, [r2, r1, lsl #2]
	uxth	r6, r6
	orr	r7, lr, r7
	str	r7, [r2, r1, lsl #2]
.L2025:
	ldr	r1, [r5, #0]
	cmp	r6, r1
	bcc	.L2026
.L2024:
	ldr	r2, .L2029+4
	mov	r0, r4
	ldr	r1, [r2, #0]
	mov	r2, r3
	bl	memcpy
	movs	r2, #4
	ldr	r0, .L2029+16
	mov	r1, r4
	mov	r3, r2
	bl	rknand_print_hex
	movs	r0, #0
	b	.L2023
.L2022:
	subs	r5, r5, #1
	uxth	r5, r5
.L2021:
	cmp	sl, r5
	ble	.L2027
	mov	r0, #-1
	b	.L2023
.L2028:
	mov	r0, r4
.L2023:
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2030:
	.align	2
.L2029:
	.word	.LANCHOR28
	.word	.LANCHOR44
	.word	.LANCHOR241
	.word	.LANCHOR46
	.word	.LC50
	.size	FlashReadFacBbtData, .-FlashReadFacBbtData
	.section	.text.FlashGetBadBlockList,"ax",%progbits
	.align	1
	.global	FlashGetBadBlockList
	.thumb
	.thumb_func
	.type	FlashGetBadBlockList, %function
FlashGetBadBlockList:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldr	r3, .L2038
	ldr	r6, .L2038+4
	ldr	r3, [r3, #0]
	ldr	r0, [r6, #0]
	ldrb	r2, [r3, #13]	@ zero_extendqisi2
	ldrh	r4, [r3, #14]
	muls	r4, r2, r4
	uxth	r4, r4
	adds	r2, r4, #7
	lsrs	r2, r2, #3
	bl	FlashReadFacBbtData
	adds	r0, r0, #1
	beq	.L2037
	movs	r2, #0
	lsrs	r0, r4, #4
	ldr	r6, [r6, #0]
	mov	r3, r2
	subs	r4, r4, #1
	movs	r1, #1
	b	.L2033
.L2035:
	lsrs	r7, r2, #5
	and	ip, r2, #31
	lsl	ip, r1, ip
	ldr	r7, [r6, r7, lsl #2]
	tst	ip, r7
	beq	.L2034
	strh	r2, [r5, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	uxth	r3, r3
.L2034:
	cmp	r3, r0
	bcs	.L2037
	adds	r2, r2, #1
	uxth	r2, r2
.L2033:
	cmp	r2, r4
	blt	.L2035
	b	.L2032
.L2037:
	movs	r3, #0
.L2032:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2039:
	.align	2
.L2038:
	.word	.LANCHOR23
	.word	.LANCHOR41
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.FtlMakeBbt,"ax",%progbits
	.align	1
	.global	FtlMakeBbt
	.thumb
	.thumb_func
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2059
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	ldr	r4, [r3, #0]
	cmp	r4, #0
	bne	.L2041
	ldr	r5, .L2059+4
	bl	FtlBbtMemInit
	ldr	r6, .L2059+8
	bl	FtlLoadFactoryBbt
	add	r2, r5, #12
	str	r2, [sp, #4]
	b	.L2042
.L2048:
	ldr	r3, .L2059+12
	ldr	r2, [sp, #4]
	ldr	r8, .L2059+24
	ldr	r0, [r3, #0]
	ldr	r3, .L2059+16
	str	r0, [r8, #8]
	ldr	sl, [r3, #0]
	ldrh	r3, [r2], #2
	str	sl, [r8, #12]
	str	r2, [sp, #4]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L2043
	ldrh	r7, [r6, #0]
	movs	r1, #1
	mov	r2, r1
	mov	r0, r8
	mla	r7, r7, r4, r3
	lsls	r3, r7, #10
	str	r3, [r8, #4]
	bl	FlashReadPages
	ldrh	r2, [r6, #0]
	ldr	r0, [r5, #28]
	adds	r2, r2, #7
	ldr	r1, [r8, #8]
	lsrs	r2, r2, #3
	bl	memcpy
	b	.L2044
.L2043:
	mov	r1, r4
	bl	FlashGetBadBlockList
	ldr	r1, [r5, #28]
	ldr	r0, [r8, #8]
	bl	FtlBbt2Bitmap
	ldrh	fp, [r6, #0]
	mov	r3, r5
	mov	r5, r4
	add	fp, fp, #-1
	mov	r4, sl
	mov	sl, r3
	uxth	fp, fp
	b	.L2057
.L2046:
	add	fp, fp, #-1
	uxth	fp, fp
.L2057:
	ldrh	r0, [r6, #0]
	mla	r0, r5, r0, fp
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2046
	ldr	r3, [sp, #4]
	movs	r1, #0
	ldr	r2, .L2059+16
	strh	fp, [r3, #-2]	@ movhi
	ldr	r0, [r2, #0]
	movs	r2, #16
	bl	memset
	ldr	r2, [sp, #4]
	movw	r3, 61664	@ movhi
	ldrh	r7, [r6, #0]
	strh	r3, [r4, #0]	@ movhi
	movs	r3, #0
	str	r3, [r4, #4]
	ldrh	r3, [r2, #-2]
	ldr	r0, [r8, #8]
	mla	r7, r7, r5, r3
	strh	r3, [r4, #2]	@ movhi
	ldr	r1, [sl, #28]
	lsls	r3, r7, #10
	str	r3, [r8, #4]
	ldr	r3, .L2059+20
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #2
	bl	memcpy
	movs	r1, #1
	mov	r2, r1
	ldr	r0, .L2059+24
	bl	FlashEraseBlocks
	movs	r1, #1
	mov	r3, r1
	ldr	r0, .L2059+24
	mov	r2, r1
	bl	FlashProgPages
	ldr	r3, [r8, #0]
	adds	r3, r3, #1
	bne	.L2058
	uxth	r0, r7
	bl	FtlBbmMapBadBlock
	b	.L2057
.L2058:
	mov	r4, r5
	mov	r5, sl
.L2044:
	uxth	r0, r7
	adds	r4, r4, #1
	bl	FtlBbmMapBadBlock
	adds	r5, r5, #4
.L2042:
	ldr	r2, .L2059+28
	ldrh	r3, [r2, #0]
	cmp	r4, r3
	bcc	.L2048
	movs	r4, #0
	ldr	r5, .L2059+32
	b	.L2049
.L2050:
	mov	r0, r4
	adds	r4, r4, #1
	bl	FtlBbmMapBadBlock
	uxth	r4, r4
.L2049:
	ldrh	r3, [r5, #0]
	cmp	r3, r4
	bhi	.L2050
	ldr	r5, .L2059+4
	movw	r6, #65535
	ldrh	r4, [r5, #12]
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L2051
.L2056:
	mov	r0, r4
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2052
	mov	r0, r4
	bl	FlashTestBlk
	cbz	r0, .L2053
	mov	r0, r4
	bl	FtlBbmMapBadBlock
	b	.L2052
.L2053:
	ldrh	r3, [r5, #0]
	cmp	r3, r6
	bne	.L2054
	strh	r4, [r5, #0]	@ movhi
	b	.L2052
.L2054:
	ldr	r3, .L2059+4
	strh	r4, [r3, #4]	@ movhi
	b	.L2055
.L2052:
	subs	r4, r4, #1
	uxth	r4, r4
.L2051:
	ldrh	r3, [r5, #12]
	subs	r3, r3, #47
	cmp	r3, r4
	ble	.L2056
.L2055:
	ldr	r4, .L2059+4
	movs	r5, #0
	ldr	r3, .L2059+36
	movs	r2, #2
	movs	r1, #1
	str	r5, [r4, #8]
	ldr	r0, [r3, #0]
	ldrh	r3, [r4, #0]
	strh	r5, [r4, #2]	@ movhi
	lsls	r3, r3, #10
	str	r3, [r0, #4]
	ldrh	r3, [r4, #4]
	lsls	r3, r3, #10
	str	r3, [r0, #40]
	bl	FlashEraseBlocks
	ldrh	r0, [r4, #0]
	bl	FtlBbmMapBadBlock
	ldrh	r0, [r4, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldr	r3, [r4, #8]
	ldrh	r2, [r4, #4]
	adds	r3, r3, #1
	str	r3, [r4, #8]
	ldrh	r3, [r4, #0]
	strh	r5, [r4, #2]	@ movhi
	strh	r2, [r4, #0]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	bl	FtlBbmTblFlush
.L2041:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L2060:
	.align	2
.L2059:
	.word	.LANCHOR94
	.word	.LANCHOR90
	.word	.LANCHOR66
	.word	.LANCHOR98
	.word	.LANCHOR184
	.word	.LANCHOR91
	.word	.LANCHOR198
	.word	.LANCHOR60
	.word	.LANCHOR75
	.word	.LANCHOR95
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.FtlLowFormat,"ax",%progbits
	.align	1
	.global	FtlLowFormat
	.thumb
	.thumb_func
	.type	FtlLowFormat, %function
FtlLowFormat:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2082
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L2062
	ldr	r2, .L2082+4
	str	r3, [r2, #0]
	ldr	r2, .L2082+8
	str	r3, [r2, #0]
	ldr	r3, .L2082+12
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2063
	bl	FtlMakeBbt
.L2063:
	ldr	r3, .L2082+16
	ldr	r2, .L2082+20
	ldrh	r4, [r3, #0]
	ldr	r3, .L2082+24
	lsls	r4, r4, #7
	ldr	r0, [r3, #0]
	ldr	r3, .L2082+28
	ldr	r1, [r3, #0]
	movs	r3, #0
	b	.L2064
.L2065:
	mvns	r5, r3
	orr	r5, r3, r5, lsl #16
	str	r5, [r0, r3, lsl #2]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	uxth	r3, r3
.L2064:
	cmp	r3, r4
	blt	.L2065
	ldr	r3, .L2082+32
	movs	r4, #0
	ldr	r6, .L2082+36
	ldrh	r5, [r3, #0]
	b	.L2066
.L2067:
	mov	r0, r5
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r5, r5, #1
	uxth	r5, r5
	adds	r4, r4, r0
	uxth	r4, r4
.L2066:
	ldrh	r3, [r6, #0]
	cmp	r3, r5
	bhi	.L2067
	ldr	r3, .L2082+40
	ldrh	r1, [r3, #0]
	subs	r3, r4, #2
	cmp	r3, r1, lsl #1
	bgt	.L2068
.L2072:
	movs	r4, #0
	ldr	r6, .L2082+32
	mov	r5, r4
	b	.L2069
.L2068:
	mov	r0, r4
	ldr	r5, .L2082+36
	bl	__aeabi_uidiv
	ldr	r3, .L2082+44
	ldr	r3, [r3, #0]
	adds	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldr	r3, .L2082+12
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	ldr	r3, .L2082+32
	ldrh	r4, [r3, #0]
	b	.L2070
.L2071:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	uxth	r4, r4
.L2070:
	ldrh	r3, [r5, #0]
	cmp	r3, r4
	bhi	.L2071
	b	.L2072
.L2073:
	mov	r0, r5
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	adds	r5, r5, #1
	uxth	r5, r5
	adds	r4, r4, r0
	uxth	r4, r4
.L2069:
	ldrh	r3, [r6, #0]
	cmp	r3, r5
	bhi	.L2073
	ldr	r3, .L2082+36
	ldr	r8, .L2082+68
	ldr	sl, .L2082+72
	ldrh	r2, [r3, #0]
	ldr	r3, .L2082+48
	str	r2, [r3, #0]
	ldr	r3, .L2082+52
	ldr	fp, [r3, #0]
	ldr	r3, .L2082+40
	mov	r0, fp
	ldrh	r5, [r3, #0]
	mov	r1, r5
	bl	__aeabi_uidiv
	ubfx	r7, r0, #5, #16
	mov	r6, r0
	add	r3, r7, #36
	strh	r3, [r8, #0]	@ movhi
	movs	r3, #24
	muls	r3, r5, r3
	cmp	r4, r3
	str	r0, [sl, #0]
	ble	.L2074
	rsb	r0, r4, fp
	mov	r1, r5
	bl	__aeabi_uidiv
	str	r0, [sl, #0]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r8, #0]	@ movhi
.L2074:
	ldr	r3, .L2082+56
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L2075
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r8, .L2082+68
	ldrh	sl, [r8, #0]
	uxtah	r0, sl, r0
	add	sl, sl, r0, lsr #2
	strh	sl, [r8, #0]	@ movhi
.L2075:
	ldr	r3, .L2082+60
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L2076
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r8, .L2082+68
	ldrh	sl, [r8, #0]
	uxtah	r0, sl, r0
	add	sl, sl, r0, lsr #2
	strh	sl, [r8, #0]	@ movhi
.L2076:
	ldr	r3, .L2082+64
	ldrh	r3, [r3, #0]
	cbz	r3, .L2077
	ldr	r2, .L2082+68
	ldrh	r1, [r2, #0]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2, #0]	@ movhi
	mul	r1, r5, r3
	cmp	r1, r4
	ble	.L2077
	ldr	r1, .L2082+72
	adds	r3, r3, #32
	adds	r7, r7, r3
	strh	r7, [r2, #0]	@ movhi
	str	r6, [r1, #0]
.L2077:
	ldr	r3, .L2082+72
	ldr	r2, .L2082+68
	ldr	r6, .L2082+76
	ldr	r1, [r3, #0]
	ldrh	r2, [r2, #0]
	ldr	r4, .L2082+80
	subs	r2, r1, r2
	muls	r5, r2, r5
	ldr	r2, .L2082+84
	str	r5, [r2, #0]
	ldr	r2, .L2082+88
	ldrh	r2, [r2, #0]
	muls	r5, r2, r5
	str	r5, [r3, #0]
	ldr	r3, .L2082+16
	ldrh	r3, [r3, #0]
	muls	r5, r3, r5
	ldr	r3, .L2082+92
	str	r5, [r3, #0]
	movw	r5, #65535
	bl	FtlBbmTblFlush
	ldr	r3, .L2082+36
	movs	r1, #0
	ldr	r0, [r6, #0]
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	ldr	r2, .L2082+96
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	movs	r1, #255
	str	r3, [r2, #0]
	ldr	r2, .L2082+100
	strh	r3, [r4, #0]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	strb	r3, [r2, #6]
	strb	r3, [r2, #8]
	movs	r3, #1
	strb	r3, [r4, #8]
	ldr	r3, .L2082+32
	strh	r5, [r2, #0]	@ movhi
	ldrh	r2, [r3, #0]
	ldr	r3, .L2082+104
	lsrs	r2, r2, #3
	ldr	r0, [r3, #0]
	bl	memset
.L2078:
	ldr	r7, .L2082+80
	mov	r0, r7
	bl	make_superblock
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	ldr	r3, .L2082+76
	cbnz	r2, .L2079
	ldrh	r2, [r4, #0]
	ldr	r3, [r6, #0]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
	b	.L2078
.L2079:
	ldr	r2, .L2082+4
	movw	r6, #65535
	ldr	r4, .L2082+108
	ldrh	r0, [r7, #4]
	ldr	r1, [r2, #0]
	str	r1, [r7, #12]
	adds	r1, r1, #1
	str	r1, [r2, #0]
	ldrh	r1, [r7, #0]
	ldr	r2, [r3, #0]
	strh	r0, [r2, r1, lsl #1]	@ movhi
	movs	r2, #0
	strh	r2, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	ldrh	r2, [r7, #0]
	mov	r7, r3
	adds	r2, r2, #1
	strh	r2, [r4, #0]	@ movhi
	movs	r2, #1
	strb	r2, [r4, #8]
.L2080:
	ldr	r5, .L2082+108
	mov	r0, r5
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2081
	ldrh	r2, [r4, #0]
	ldr	r3, [r7, #0]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
	b	.L2080
.L2083:
	.align	2
.L2082:
	.word	.LANCHOR94
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR54
	.word	.LANCHOR71
	.word	168778952
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	.LANCHOR55
	.word	.LANCHOR56
	.word	.LANCHOR53
	.word	.LANCHOR81
	.word	.LANCHOR89
	.word	.LANCHOR57
	.word	.LANCHOR128
	.word	.LANCHOR7
	.word	.LANCHOR64
	.word	.LANCHOR201
	.word	.LANCHOR88
	.word	.LANCHOR101
	.word	.LANCHOR109
	.word	.LANCHOR200
	.word	.LANCHOR68
	.word	.LANCHOR84
	.word	.LANCHOR118
	.word	.LANCHOR202
	.word	.LANCHOR119
	.word	.LANCHOR110
.L2081:
	ldr	r4, .L2084
	ldrh	r1, [r5, #4]
	ldrh	r2, [r5, #0]
	ldr	r3, [r4, #0]
	str	r3, [r5, #12]
	adds	r3, r3, #1
	str	r3, [r4, #0]
	movw	r5, #65535
	ldr	r3, .L2084+4
	ldr	r3, [r3, #0]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2084+8
	strh	r5, [r3, #0]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2084+12
	movs	r2, #0
	strh	r2, [r3, #2]	@ movhi
	ldr	r2, .L2084+16
	strh	r5, [r3, #4]	@ movhi
	ldr	r2, [r2, #0]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, [r4, #0]
	str	r2, [r3, #8]
	adds	r2, r2, #1
	str	r2, [r4, #0]
	strh	r0, [r3, #0]	@ movhi
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	r0, .L2062
	ldr	r3, .L2084+20
	movs	r2, #1
	str	r2, [r3, #0]
.L2062:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2085:
	.align	2
.L2084:
	.word	.LANCHOR156
	.word	.LANCHOR101
	.word	.LANCHOR111
	.word	.LANCHOR196
	.word	.LANCHOR200
	.word	.LANCHOR225
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.HynixGetReadRetryDefault,"ax",%progbits
	.align	1
	.global	HynixGetReadRetryDefault
	.thumb
	.thumb_func
	.type	HynixGetReadRetryDefault, %function
HynixGetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2175
	movs	r2, #172
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	movs	r1, #174
	strb	r0, [r3, #0]
	strb	r2, [r3, #4]
	movs	r0, #173
	movs	r2, #175
	cmp	r4, #2
	sub	sp, sp, #64
	strb	r0, [r3, #5]
	strb	r1, [r3, #6]
	strb	r2, [r3, #7]
	bne	.L2087
	movs	r2, #167
	strb	r2, [r3, #4]
	ldr	r3, .L2175+4
	movs	r2, #247
	strb	r2, [r3, #17]
	b	.L2142
.L2087:
	cmp	r4, #3
	bne	.L2089
	movs	r2, #176
	strb	r2, [r3, #4]
	movs	r2, #177
	strb	r2, [r3, #5]
	movs	r2, #178
	strb	r2, [r3, #6]
	movs	r2, #179
	strb	r2, [r3, #7]
	movs	r2, #180
	strb	r2, [r3, #8]
	movs	r2, #181
	strb	r2, [r3, #9]
	movs	r2, #182
	strb	r2, [r3, #10]
	movs	r2, #183
	b	.L2169
.L2089:
	cmp	r4, #4
	bne	.L2090
	movs	r5, #204
	strb	r0, [r3, #9]
	strb	r5, [r3, #4]
	movs	r5, #191
	strb	r1, [r3, #10]
	strb	r5, [r3, #5]
	movs	r5, #170
	strb	r5, [r3, #6]
	movs	r5, #171
	strb	r5, [r3, #7]
	movs	r5, #205
	strb	r5, [r3, #8]
.L2169:
	movs	r6, #8
	strb	r2, [r3, #11]
	mov	r5, r6
	b	.L2088
.L2090:
	cmp	r4, #5
	bne	.L2091
	movs	r2, #56
	movs	r6, #8
	strb	r2, [r3, #4]
	movs	r2, #57
	strb	r2, [r3, #5]
	movs	r2, #58
	strb	r2, [r3, #6]
	movs	r2, #59
	strb	r2, [r3, #7]
	b	.L2168
.L2091:
	cmp	r4, #6
	bne	.L2092
	movs	r2, #14
	movs	r6, #12
	strb	r2, [r3, #4]
	movs	r2, #15
	strb	r2, [r3, #5]
	movs	r2, #16
	strb	r2, [r3, #6]
	movs	r2, #17
	strb	r2, [r3, #7]
	b	.L2168
.L2092:
	cmp	r4, #7
	bne	.L2142
	movs	r2, #176
	movs	r6, #12
	strb	r2, [r3, #4]
	movs	r5, #10
	movs	r2, #177
	strb	r2, [r3, #5]
	movs	r2, #178
	strb	r2, [r3, #6]
	movs	r2, #179
	strb	r2, [r3, #7]
	movs	r2, #180
	strb	r2, [r3, #8]
	movs	r2, #181
	strb	r2, [r3, #9]
	movs	r2, #182
	strb	r2, [r3, #10]
	movs	r2, #183
	strb	r2, [r3, #11]
	movs	r2, #212
	strb	r2, [r3, #12]
	movs	r2, #213
	strb	r2, [r3, #13]
	b	.L2088
.L2142:
	movs	r6, #7
.L2168:
	movs	r5, #4
.L2088:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L2164
	b	.L2173
.L2099:
	ldr	r3, .L2175+8
	mov	sl, #0
	ldr	r1, .L2175+12
	ldr	r4, .L2175+16
	ldrb	r2, [r3, r7]	@ zero_extendqisi2
	ldr	r0, [r1, r2, lsl #3]
	add	r4, r4, r2, lsl #6
	add	r2, r1, r2, lsl #3
	ldrb	r3, [r2, #4]	@ zero_extendqisi2
	movs	r2, #55
	adds	r3, r3, #8
	add	r3, r0, r3, lsl #8
.L2095:
	add	r1, r8, sl
	str	r2, [r3, #8]
	movs	r0, #80
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	str	r1, [r3, #4]
	str	r2, [sp, #8]
	str	r3, [sp, #12]
	bl	udelay
	ldr	r3, [sp, #12]
	ldr	r1, [r3, #0]
	strb	r1, [r4, sl]
	add	sl, sl, #1
	ldr	r2, [sp, #8]
	uxtb	r1, sl
	cmp	r1, r5
	bcc	.L2095
	movs	r3, #0
	b	.L2096
.L2097:
	ldrb	ip, [sl, r2, lsl #2]	@ zero_extendqisi2
	ldrb	r0, [r4, r3]	@ zero_extendqisi2
	add	r0, ip, r0
	strb	r0, [r1, r2, lsl #3]
	adds	r2, r2, #1
	cmp	r2, #7
	bne	.L2097
	adds	r3, r3, #1
	cmp	r3, #4
	beq	.L2098
.L2096:
	movs	r2, #1
	adds	r1, r4, r3
	add	sl, fp, r3
	b	.L2097
.L2098:
	adds	r7, r7, #1
	movs	r3, #0
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	uxtb	r7, r7
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L2093
.L2173:
	ldr	r8, .L2175
	movs	r7, #0
	ldr	fp, .L2175+4
.L2093:
	ldr	r3, .L2175+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, r7
	bhi	.L2099
	b	.L2100
.L2164:
	subs	r3, r4, #3
	cmp	r3, #4
	bhi	.L2100
	smulbb	r3, r5, r6
	str	r6, [sp, #48]
	asrs	r2, r3, #2
	lsls	r3, r3, #4
	str	r3, [sp, #52]
	movs	r3, #0
	str	r3, [sp, #20]
	subs	r3, r5, #1
	str	r2, [sp, #24]
	uxtb	r3, r3
	str	r3, [sp, #56]
	b	.L2101
.L2141:
	ldr	r3, .L2175+8
	ldr	fp, [sp, #20]
	ldrb	r6, [r3, fp]	@ zero_extendqisi2
	ldr	r3, .L2175+12
	mov	r0, r6
	ldr	sl, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	ldrb	r8, [r3, #4]	@ zero_extendqisi2
	movs	r3, #255
	add	r8, r8, #8
	lsl	r8, r8, #8
	add	r7, sl, r8
	str	r3, [r7, #8]
	bl	NandcWaitFlashReady
	cmp	r4, #7
	sxth	r3, r6
	beq	.L2102
	ldr	r1, .L2175+16
	add	r3, r1, r3, lsl #6
	b	.L2170
.L2102:
	lsls	r1, r3, #7
	add	r3, r1, r3, lsl #5
	ldr	r1, .L2175+24
	adds	r3, r1, r3
.L2170:
	str	r3, [sp, #32]
	movs	r3, #54
	cmp	r4, #4
	str	r3, [r7, #8]
	bne	.L2104
	movs	r3, #255
	str	r3, [r7, #4]
	movs	r3, #64
	str	r3, [sl, r8]
	movs	r3, #204
	b	.L2171
.L2104:
	subs	r3, r4, #5
	cmp	r3, #1
	bhi	.L2106
	ldr	r3, .L2175
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r7, #4]
	movs	r3, #82
	b	.L2172
.L2106:
	movs	r3, #174
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [sl, r8]
	movs	r3, #176
.L2171:
	str	r3, [r7, #4]
	movs	r3, #77
.L2172:
	str	r3, [sl, r8]
	movs	r3, #22
	str	r3, [r7, #8]
	movs	r3, #23
	str	r3, [r7, #8]
	movs	r3, #4
	str	r3, [r7, #8]
	movs	r3, #25
	str	r3, [r7, #8]
	movs	r3, #0
	cmp	r4, #6
	str	r3, [r7, #8]
	mov	r0, r6
	str	r3, [r7, #4]
	str	r3, [r7, #4]
	it	eq
	moveq	r3, #31
	str	r3, [r7, #4]
	movs	r3, #2
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [r7, #4]
	movs	r3, #48
	str	r3, [r7, #8]
	bl	NandcWaitFlashReady
	sub	ip, r4, #5
	mov	r1, ip
	str	ip, [sp, #36]
	cmp	r1, #1
	bls	.L2144
	cmp	r4, #7
	ite	eq
	moveq	r1, #32
	movne	r1, #2
	b	.L2110
.L2144:
	movs	r1, #16
.L2110:
	ldr	r3, .L2175+28
	ldr	r2, [r3, #0]
	movs	r3, #0
.L2111:
	ldr	r0, [r7, #0]
	strb	r0, [r2, r3]
	adds	r3, r3, #1
	uxtb	r0, r3
	cmp	r0, r1
	bcc	.L2111
	cmp	r4, #7
	bne	.L2112
	movs	r3, #0
.L2114:
	ldrb	r1, [r2, #0]	@ zero_extendqisi2
	cmp	r1, #12
	beq	.L2113
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	cmp	r1, #10
	beq	.L2113
	adds	r3, r3, #1
	adds	r2, r2, #4
	uxtb	r3, r3
	cmp	r3, #8
	bne	.L2114
	b	.L2115
.L2113:
	cmp	r3, #6
	bls	.L2116
.L2115:
	ldr	r0, .L2175+32
	movs	r1, #0
	bl	printf
.L2117:
	b	.L2117
.L2112:
	cmp	r4, #6
	bne	.L2116
	movs	r3, #0
.L2118:
	ldrb	r1, [r2], #1	@ zero_extendqisi2
	cmp	r1, #12
	beq	.L2116
	ldrb	r1, [r2, #7]	@ zero_extendqisi2
	cmp	r1, #4
	beq	.L2116
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #8
	bne	.L2118
	b	.L2174
.L2120:
	b	.L2120
.L2176:
	.align	2
.L2175:
	.word	.LANCHOR31
	.word	.LANCHOR242
	.word	.LANCHOR19
	.word	.LANCHOR5
	.word	.LANCHOR31+20
	.word	.LANCHOR16
	.word	.LANCHOR31+28
	.word	.LANCHOR44
	.word	.LC51
.L2116:
	ldr	r0, .L2177
	movs	r3, #0
	ldr	r0, [r0, #0]
	str	r0, [sp, #40]
.L2121:
	ldr	r2, [r7, #0]
	ldr	r1, [sp, #40]
	strb	r2, [r1, r3]
	adds	r3, r3, #1
	ldr	r2, [sp, #52]
	cmp	r3, r2
	blt	.L2121
	ldr	r3, .L2177
	movs	r2, #8
	ldr	ip, [sp, #24]
	ldr	r1, [r3, #0]
	lsl	r0, ip, #2
	lsl	fp, ip, #3
	str	r0, [sp, #44]
	adds	r0, r1, r0
.L2123:
	movs	r3, #0
	mov	lr, r3
.L2122:
	ldr	ip, [r0, r3]
	add	lr, lr, #1
	mvn	ip, ip
	str	ip, [r0, r3]
	ldr	ip, [sp, #24]
	adds	r3, r3, #4
	cmp	lr, ip
	blt	.L2122
	subs	r2, r2, #1
	add	r0, r0, fp
	bne	.L2123
	mov	lr, r1
	str	r2, [sp, #16]
	str	r5, [sp, #60]
	b	.L2124
.L2128:
	movs	r0, #1
	mov	fp, #16
	str	r3, [sp, #4]
	lsl	r5, r0, r3
	movs	r0, #0
	mov	ip, r0
	str	fp, [sp, #28]
.L2126:
	ldr	fp, [lr, r0]
	ldr	r3, [sp, #44]
	and	fp, r5, fp
	adds	r0, r0, r3
	ldr	r3, [sp, #28]
	cmp	fp, r5
	it	eq
	addeq	ip, ip, #1
	subs	r3, r3, #1
	str	r3, [sp, #28]
	bne	.L2126
	ldr	r3, [sp, #4]
	cmp	ip, #8
	it	hi
	orrhi	r2, r2, r5
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L2128
	ldr	fp, [sp, #16]
	ldr	ip, [sp, #24]
	add	fp, fp, #1
	str	r2, [lr], #4
	cmp	fp, ip
	str	fp, [sp, #16]
	bge	.L2146
.L2124:
	movs	r2, #0
	mov	r3, r2
	b	.L2128
.L2146:
	movs	r3, #0
	ldr	r5, [sp, #60]
	mov	r2, r3
.L2129:
	ldr	r0, [r1, r3]
	cbnz	r0, .L2130
	adds	r2, r2, #1
.L2130:
	adds	r3, r3, #4
	cmp	r3, #32
	bne	.L2129
	cmp	r2, #7
	ble	.L2131
	ldr	r0, .L2177+4
	movs	r2, #1
	mov	r3, #1024
	bl	rknand_print_hex
	ldr	r0, .L2177+8
	movs	r1, #0
	bl	printf
.L2132:
	b	.L2132
.L2131:
	cmp	r4, #6
	beq	.L2147
	cmp	r4, #7
	ite	eq
	moveq	r0, #10
	movne	r0, #8
	str	r0, [sp, #16]
	b	.L2133
.L2147:
	movs	r1, #4
	str	r1, [sp, #16]
.L2133:
	cbz	r5, .L2134
	ldr	r2, [sp, #56]
	add	lr, r2, #1
	b	.L2135
.L2134:
	mov	lr, #1
.L2135:
	ldr	r0, [sp, #40]
	movs	r2, #0
	ldr	r1, [sp, #32]
	mov	fp, r4
	b	.L2136
.L2137:
	ldrb	ip, [r4], #1	@ zero_extendqisi2
	strb	ip, [r1, r3]
	adds	r3, r3, #1
	uxtb	ip, r3
	cmp	ip, r5
	bcc	.L2137
	ldr	ip, [sp, #48]
	adds	r2, r2, #1
	ldr	r3, [sp, #16]
	add	r0, r0, lr
	cmp	r2, ip
	add	r1, r1, r3
	bge	.L2138
.L2136:
	mov	r4, r0
	movs	r3, #0
	b	.L2137
.L2138:
	movs	r3, #255
	mov	r0, r6
	str	r3, [r7, #8]
	mov	r4, fp
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #36]
	cmp	r1, #1
	bhi	.L2139
	movs	r3, #54
	str	r3, [r7, #8]
	ldr	r3, .L2177+12
	mov	r1, #-1
	ldr	r0, [sp, #20]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [sl, r8]
	movs	r3, #22
	str	r3, [r7, #8]
	bl	FlashReadCmd
	b	.L2140
.L2139:
	movs	r3, #56
	str	r3, [r7, #8]
.L2140:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r2, [sp, #20]
	adds	r3, r2, #1
	uxtb	r3, r3
	str	r3, [sp, #20]
.L2101:
	ldr	r0, .L2177+16
	ldr	r2, [sp, #20]
	ldrb	r3, [r0, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bhi	.L2141
	ldr	r6, [sp, #48]
.L2100:
	ldr	r3, .L2177+12
	strb	r5, [r3, #1]
	strb	r6, [r3, #2]
	add	sp, sp, #64
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2174:
	movs	r1, #0
	ldr	r0, .L2177+8
	bl	printf
	b	.L2120
.L2178:
	.align	2
.L2177:
	.word	.LANCHOR44
	.word	.LC52
	.word	.LC51
	.word	.LANCHOR31
	.word	.LANCHOR16
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",%progbits
	.align	1
	.global	FlashGetReadRetryDefault
	.thumb
	.thumb_func
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r0
	cmp	r0, #0
	beq	.L2179
	subs	r2, r0, #1
	cmp	r2, #6
	bhi	.L2181
	b	HynixGetReadRetryDefault
.L2181:
	cmp	r0, #49
	bne	.L2182
	ldr	r0, .L2190
	movs	r2, #64
	ldr	r1, .L2190+4
	strb	r3, [r0, #0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
	adds	r0, r0, #4
	b	.L2188
.L2182:
	cmp	r0, #33
	beq	.L2183
	cmp	r0, #65
	beq	.L2183
	cmp	r0, #66
	bne	.L2184
.L2183:
	ldr	r0, .L2190
	strb	r3, [r0, #0]
	movs	r3, #4
	b	.L2189
.L2184:
	cmp	r0, #34
	beq	.L2185
	cmp	r0, #67
	bne	.L2186
.L2185:
	ldr	r0, .L2190
	strb	r3, [r0, #0]
	movs	r3, #5
.L2189:
	strb	r3, [r0, #1]
	movs	r2, #45
	movs	r3, #7
	ldr	r1, .L2190+8
	strb	r3, [r0, #2]
	adds	r0, r0, #4
	b	.L2188
.L2186:
	cmp	r0, #35
	beq	.L2187
	cmp	r0, #68
	bne	.L2179
.L2187:
	ldr	r0, .L2190
	movs	r2, #95
	ldr	r1, .L2190+12
	strb	r3, [r0, #0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	adds	r0, r0, #4
.L2188:
	b	memcpy
.L2179:
	bx	lr
.L2191:
	.align	2
.L2190:
	.word	.LANCHOR31
	.word	.LANCHOR15
	.word	.LANCHOR10
	.word	.LANCHOR12
	.size	FlashGetReadRetryDefault, .-FlashGetReadRetryDefault
	.section	.text.FlashInit,"ax",%progbits
	.align	1
	.global	FlashInit
	.thumb
	.thumb_func
	.type	FlashInit, %function
FlashInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	sub	sp, sp, #24
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L2238
	movs	r5, #0
	ldr	r8, .L2238+84
	mov	r6, r5
	str	r0, [r3, #0]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L2238+4
	str	r0, [r3, #0]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L2238+8
	str	r0, [r3, #0]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L2238+12
	str	r0, [r3, #0]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L2238+16
	ldr	r2, .L2238+20
	str	r0, [r3, #0]
	movs	r3, #50
	strb	r3, [r2, #0]
	mov	r0, r4
	ldr	r2, .L2238+24
	ldr	r4, .L2238+28
	strb	r3, [r2, #0]
	movs	r2, #128
	ldr	r3, .L2238+32
	mov	r7, r4
	str	r5, [r3, #0]
	ldr	r3, .L2238+36
	str	r2, [r3, #0]
	movs	r2, #60
	ldr	r3, .L2238+40
	strb	r5, [r3, #0]
	ldr	r3, .L2238+44
	str	r5, [r3, #0]
	ldr	r3, .L2238+48
	strb	r5, [r3, #0]
	ldr	r3, .L2238+52
	strb	r2, [r3, #0]
	bl	NandcInit
.L2197:
	uxtb	r3, r6
	str	r3, [sp, #16]
	mov	r0, r3
	bl	FlashReset
	add	r2, r8, r5
	ldr	r3, [sp, #16]
	ldrb	sl, [r2, #4]	@ zero_extendqisi2
	ldr	fp, [r5, r8]
	mov	r0, r3
	add	sl, sl, #8
	lsl	sl, sl, #8
	add	r2, fp, sl
	str	r2, [sp, #20]
	bl	NandcFlashCs
	ldr	r2, [sp, #20]
	movs	r1, #144
	movs	r0, #200
	str	r1, [r2, #8]
	movs	r1, #0
	str	r1, [r2, #4]
	bl	udelay
	ldr	r2, [fp, sl]
	strb	r2, [r5, r7]
	ldr	r2, [fp, sl]
	strb	r2, [r4, #1]
	ldr	r2, [fp, sl]
	strb	r2, [r4, #2]
	ldr	r2, [fp, sl]
	strb	r2, [r4, #3]
	ldr	r2, [fp, sl]
	strb	r2, [r4, #4]
	ldr	r2, [fp, sl]
	strb	r2, [r4, #5]
	ldr	r3, [sp, #16]
	mov	r0, r3
	bl	NandcFlashDeCs
	ldrb	r2, [r5, r7]	@ zero_extendqisi2
	subs	r3, r2, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L2193
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L2238+56
	str	r1, [sp, #0]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	str	r1, [sp, #12]
	adds	r1, r6, #1
	bl	printf
.L2193:
	cbnz	r6, .L2194
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L2231
	ldrb	r3, [r7, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2231
.L2194:
	ldrb	r3, [r5, r7]	@ zero_extendqisi2
	cmp	r3, #181
	bne	.L2196
	movs	r3, #44
	strb	r3, [r5, r7]
.L2196:
	adds	r6, r6, #1
	adds	r5, r5, #8
	adds	r4, r4, #8
	cmp	r6, #4
	bne	.L2197
	ldr	r3, .L2238+28
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L2198
	ldr	r3, .L2238+60
	ldr	r0, [r3, #0]
	bl	NandcSetDdrMode
.L2198:
	movs	r1, #0
	mov	r2, #852
	ldr	r0, .L2238+64
	bl	memset
	ldr	r2, .L2238+68
	ldr	r3, .L2238+72
	str	r2, [r3, #0]
	movs	r2, #0
	ldr	r3, .L2238+76
	strb	r2, [r3, #0]
	ldr	r3, .L2238+28
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	cmp	r3, #241
	beq	.L2199
	cmp	r3, #218
	beq	.L2199
	cmp	r3, #220
	bne	.L2200
.L2199:
	ldr	r2, .L2238+48
	movs	r1, #1
	ldr	r0, .L2238+28
	strb	r1, [r2, #0]
	movs	r2, #16
	ldr	r1, .L2238+20
	ldrb	r4, [r0, #0]	@ zero_extendqisi2
	strb	r2, [r1, #0]
	cmp	r4, #152
	ldr	r1, .L2238+52
	strb	r2, [r1, #0]
	ldr	r2, .L2238+80
	strb	r4, [r2, #1]
	bne	.L2201
	ldrsb	r0, [r0, #4]
	cmp	r0, #0
	blt	.L2201
	movs	r0, #24
	strb	r0, [r1, #0]
.L2201:
	cmp	r3, #218
	bne	.L2202
	mov	r1, #2048
	b	.L2236
.L2239:
	.align	2
.L2238:
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR241
	.word	.LANCHOR204
	.word	.LANCHOR205
	.word	.LANCHOR1
	.word	.LANCHOR49
	.word	.LANCHOR22
	.word	.LANCHOR46
	.word	.LANCHOR2
	.word	.LANCHOR35
	.word	.LANCHOR50
	.word	.LANCHOR0
	.word	.LANCHOR45
	.word	.LC53
	.word	.LANCHOR192
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR23
	.word	.LANCHOR4
	.word	.LANCHOR243
	.word	.LANCHOR5
.L2202:
	cmp	r3, #220
	bne	.L2203
	mov	r1, #4096
.L2236:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L2203:
	ldr	r1, .L2240
	movs	r2, #32
	ldr	r0, .L2240+4
	bl	memcpy
	ldr	r0, .L2240+8
	ldr	r1, .L2240+12
	movs	r2, #32
	bl	memcpy
.L2200:
	ldr	r3, .L2240+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2204
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L2205
	ldr	r3, .L2240+20
	ldr	r4, .L2240+24
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, #16]
	ubfx	r0, r0, #8, #3
	strb	r0, [r4, #0]
	lsls	r2, r0, #31
	bmi	.L2205
	ldr	r3, .L2240+28
	movs	r2, #1
	strb	r2, [r3, #0]
	bl	FlashSetInterfaceMode
	ldrb	r0, [r4, #0]	@ zero_extendqisi2
	bl	NandcSetMode
.L2205:
	ldr	r4, .L2240+20
	ldr	r3, [r4, #0]
	ldrb	r2, [r3, #26]	@ zero_extendqisi2
	ldr	r3, .L2240+32
	strb	r2, [r3, #0]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L2204
	ldr	r3, [r4, #0]
	ldr	r0, .L2240+36
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r3, r0, #1
	beq	.L2195
	bl	FlashDieInfoInit
	ldr	r3, [r4, #0]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r1, .L2240+40
	ldr	r3, [r4, #0]
	ldrh	r1, [r1, #0]
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	addw	r1, r1, #4095
	cmp	r2, r1, lsr #12
	blt	.L2206
	ldrh	r1, [r3, #14]
	adds	r1, r1, #255
	cmp	r2, r1, lsr #8
	bge	.L2207
.L2206:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L2207:
	ldr	r3, .L2240+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L2208
	bl	FlashSavePhyInfo
	ldr	r3, .L2240+44
	movs	r0, #0
	ldr	r1, [r3, #0]
	bl	FlashDdrParaScan
.L2208:
	bl	FlashSavePhyInfo
.L2204:
	ldr	r5, .L2240+20
	ldr	r2, .L2240+32
	ldr	r4, .L2240+48
	ldr	r3, [r5, #0]
	ldrb	r1, [r3, #26]	@ zero_extendqisi2
	ldrb	r6, [r3, #18]	@ zero_extendqisi2
	strb	r1, [r2, #0]
	ldr	r1, .L2240+52
	ldrh	r2, [r3, #16]
	ubfx	r0, r2, #7, #1
	strb	r0, [r1, #0]
	ldr	r1, .L2240+56
	ubfx	r0, r2, #3, #1
	strb	r0, [r1, #0]
	ubfx	r0, r2, #4, #1
	ldr	r1, .L2240+60
	ubfx	r2, r2, #8, #3
	strb	r0, [r1, #0]
	ldr	r1, .L2240+24
	ldrh	r0, [r3, #10]
	strb	r2, [r1, #0]
	movs	r2, #0
	ldrb	r1, [r3, #12]	@ zero_extendqisi2
	str	r2, [r4, #0]
	bl	__aeabi_idiv
	mov	r1, r0
	mov	r0, r6
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	r3, [r5, #0]
	ldrh	r2, [r3, #16]
	lsls	r0, r2, #25
	bpl	.L2209
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	ldr	r2, .L2240+64
	ldr	r3, .L2240+68
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	strb	r0, [r3, #0]
	ldr	r3, .L2240+72
	strb	r1, [r3, #0]
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	ldr	r3, .L2240+76
	strb	r1, [r3, #0]
	subs	r1, r0, #1
	cmp	r1, #6
	bhi	.L2210
	ldr	r3, .L2240+80
	str	r3, [r4, #0]
	subs	r3, r0, #5
	cmp	r3, #1
	bhi	.L2211
	ldr	r3, .L2240+84
	movs	r2, #1
	str	r2, [r3, #0]
	b	.L2212
.L2211:
	cmp	r0, #7
	beq	.L2233
.L2212:
	ldr	r1, .L2240+88
	b	.L2213
.L2233:
	add	r1, r2, #28
.L2213:
	movs	r3, #0
	mov	r2, r3
.L2215:
	ldrsb	r4, [r1, r2]
	cbnz	r4, .L2214
	adds	r3, r3, #1
.L2214:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L2215
	cmp	r3, #27
	bls	.L2209
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
	b	.L2209
.L2210:
	sub	r2, r0, #17
	cmp	r2, #2
	bhi	.L2216
	ldr	r2, .L2240+92
	str	r2, [r4, #0]
	movs	r2, #7
	cmp	r0, #19
	strb	r2, [r3, #0]
	bne	.L2209
	movs	r2, #15
	b	.L2237
.L2216:
	cmp	r0, #33
	beq	.L2217
	cmp	r0, #65
	beq	.L2217
	cmp	r0, #66
	bne	.L2218
.L2217:
	ldr	r2, .L2240+96
	ldr	r3, .L2240+48
	str	r2, [r3, #0]
	movs	r2, #4
	ldr	r3, .L2240+72
	strb	r2, [r3, #0]
	movs	r2, #7
	ldr	r3, .L2240+76
	b	.L2237
.L2218:
	cmp	r0, #67
	beq	.L2219
	cmp	r0, #34
	beq	.L2219
	cmp	r0, #35
	beq	.L2219
	cmp	r0, #68
	bne	.L2220
.L2219:
	ldr	r2, .L2240+96
	ldr	r3, .L2240+48
	str	r2, [r3, #0]
	movs	r2, #7
	ldr	r3, .L2240+76
	cmp	r0, #35
	strb	r2, [r3, #0]
	beq	.L2221
	cmp	r0, #68
	bne	.L2222
.L2221:
	movs	r2, #17
	strb	r2, [r3, #0]
.L2222:
	subs	r0, r0, #67
	ldr	r3, .L2240+72
	cmp	r0, #1
	bhi	.L2223
	movs	r2, #4
.L2237:
	strb	r2, [r3, #0]
	b	.L2209
.L2223:
	movs	r2, #5
	b	.L2237
.L2241:
	.align	2
.L2240:
	.word	.LANCHOR27+32
	.word	.LANCHOR6
	.word	.LANCHOR18
	.word	.LANCHOR243
	.word	.LANCHOR0
	.word	.LANCHOR23
	.word	.LANCHOR34
	.word	.LANCHOR35
	.word	.LANCHOR7
	.word	.LC54
	.word	.LANCHOR24
	.word	.LANCHOR47
	.word	.LANCHOR51
	.word	.LANCHOR4
	.word	.LANCHOR194
	.word	.LANCHOR33
	.word	.LANCHOR31
	.word	.LANCHOR11
	.word	.LANCHOR14
	.word	.LANCHOR42
	.word	HynixReadRetrial
	.word	.LANCHOR39
	.word	.LANCHOR31+20
	.word	MicronReadRetrial
	.word	ToshibaReadRetrial
.L2220:
	cmp	r0, #49
	bne	.L2209
	ldr	r2, .L2242
	ldr	r3, .L2242+4
	str	r2, [r3, #0]
.L2209:
	ldr	r3, .L2242+8
	ldr	r2, [r3, #0]
	ldr	r3, .L2242+12
	cmp	r2, r3
	bne	.L2224
	ldr	r3, .L2242+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L2224
	ldr	r3, .L2242+20
	movs	r2, #0
	ldr	r3, [r3, #0]
	strb	r2, [r3, #18]
.L2224:
	ldr	r3, .L2242+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L2225
	ldr	r3, .L2242+28
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	cbz	r2, .L2225
	movs	r2, #0
	movs	r0, #1
	strb	r2, [r3, #0]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L2225:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldr	r3, .L2242+32
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L2226
	ldr	r2, .L2242+28
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbnz	r2, .L2227
	lsls	r1, r3, #31
	bmi	.L2226
.L2227:
	ldr	r3, .L2242+36
	movs	r0, #0
	ldr	r1, [r3, #0]
	bl	FlashDdrParaScan
.L2226:
	ldr	r4, .L2242+20
	movs	r0, #0
	bl	flash_exit_slc_mode
	mov	r8, #16
	ldr	r3, [r4, #0]
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L2242+40
	bl	FlashReadIdbDataRaw
	ldr	r5, [r4, #0]
	ldr	r3, .L2242+44
	ldr	r4, .L2242+48
	ldrb	r1, [r5, #12]	@ zero_extendqisi2
	strb	r8, [r3, #0]
	ldrh	r6, [r5, #10]
	strh	r1, [r4, #8]	@ movhi
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	mov	r0, r6
	ldrh	r7, [r5, #14]
	str	r3, [r4, #4]
	ldr	r3, .L2242+24
	ldr	r3, [r3, #0]
	str	r3, [r4, #0]
	ldr	r3, .L2242+52
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	strh	r3, [r4, #10]	@ movhi
	ldrb	r3, [r5, #13]	@ zero_extendqisi2
	strh	r6, [r4, #16]	@ movhi
	strh	r7, [r4, #14]	@ movhi
	strh	r3, [r4, #12]	@ movhi
	bl	__aeabi_idiv
	mov	r2, #512
	strh	r0, [r4, #18]	@ movhi
	ldrb	r3, [r5, #9]	@ zero_extendqisi2
	muls	r6, r3, r6
	strh	r2, [r4, #24]	@ movhi
	uxth	r6, r6
	ldr	r2, .L2242+56
	strh	r3, [r4, #20]	@ movhi
	strh	r6, [r4, #22]	@ movhi
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	strh	r8, [r4, #26]	@ movhi
	cmp	r2, #1
	bne	.L2229
	lsls	r3, r3, #1
	lsrs	r7, r7, #1
	strh	r3, [r4, #20]	@ movhi
	lsls	r6, r6, #1
	movs	r3, #8
	strh	r7, [r4, #14]	@ movhi
	strh	r6, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L2229:
	ldrb	r0, [r5, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
	b	.L2195
.L2231:
	mvn	r0, #1
.L2195:
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2243:
	.align	2
.L2242:
	.word	SamsungReadRetrial
	.word	.LANCHOR51
	.word	.LANCHOR40
	.word	1446522928
	.word	.LANCHOR7
	.word	.LANCHOR23
	.word	.LANCHOR22
	.word	.LANCHOR35
	.word	.LANCHOR34
	.word	.LANCHOR47
	.word	.LANCHOR25
	.word	.LANCHOR1
	.word	.LANCHOR28
	.word	.LANCHOR16
	.word	.LANCHOR0
	.size	FlashInit, .-FlashInit
	.section	.text.rk_ftl_init,"ax",%progbits
	.align	1
	.global	rk_ftl_init
	.thumb
	.thumb_func
	.type	rk_ftl_init, %function
rk_ftl_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	bl	FlashInit
	mov	r4, r0
	cbnz	r0, .L2245
	ldr	r0, .L2246
	bl	FtlInit
.L2245:
	mov	r1, r4
	ldr	r0, .L2246+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2247:
	.align	2
.L2246:
	.word	.LANCHOR28
	.word	.LC55
	.size	rk_ftl_init, .-rk_ftl_init
	.global	gc_ink_free_return_value
	.global	FtlUpdateVaildLpnCount
	.global	g_ect_tbl_power_up_flush
	.global	power_up_flag
	.global	g_LowFormat
	.global	gFtlInitStatus
	.global	DeviceCapacity
	.global	ToshibaRefValue
	.global	Toshiba15RefValue
	.global	ToshibaA19RefValue
	.global	SamsungRefValue
	.global	refValueDefault
	.global	random_seed
	.global	gSlcNandParaInfo
	.global	gNandParaInfo
	.global	NandFlashParaTbl
	.global	g_page_map_check_enable
	.global	g_power_lost_ecc_error_blk
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
	.global	g_all_blk_used_slc_mode
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
	.global	g_gc_refresh_block_temp_tbl
	.global	g_free_slc_blk_num
	.global	g_gc_refresh_block_temp_num
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
	.global	p_map_region_ppn_check_table
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
	.global	g_flash_read_only_en
	.global	g_inkDie_check_enable
	.global	g_SlcPartLbaEndSector
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
	.global	gMasterTempBuf
	.global	gMasterInfo
	.global	gNandcDumpWriteEn
	.global	gToggleModeClkDiv
	.global	gBootDdrMode
	.global	gNandcEccBits
	.global	gpNandc1
	.global	gpNandc
	.global	g_nandc_version_data
	.global	gNandcVer
	.global	gNandChipMap
	.global	gNandIDataBuf
	.global	FlashDdrTunningReadCount
	.global	FlashWaitBusyScheduleEn
	.global	gNandPhyInfo
	.global	gFlashProgCheckSpareBuffer
	.global	gFlashProgCheckBuffer
	.global	gFlashSpareBuffer
	.global	gFlashPageBuffer1
	.global	gFlashPageBuffer0
	.global	gpFlashSaveInfo
	.global	gReadRetryInfo
	.global	gpNandParaInfo
	.global	gNandOptPara
	.global	g_slc2KBNand
	.global	g_maxRetryCount
	.global	g_maxRegNum
	.global	g_retryMode
	.global	gNandIDBResBlkNumSaveInFlash
	.global	gNandIDBResBlkNum
	.global	gNandFlashResEndPageAddr
	.global	gNandFlashInfoBlockAddr
	.global	gNandFlashIdbBlockAddr
	.global	gNandFlashInfoBlockEcc
	.global	gNandFlashIDBEccBits
	.global	gNandFlashEccBits
	.global	gNandRandomizer
	.global	gBlockPageAlignSize
	.global	gTotleBlock
	.global	gNandMaxChip
	.global	gNandMaxDie
	.global	gFlashInterfaceMode
	.global	gFlashSlcMode
	.global	gFlashOnfiModeEn
	.global	gFlashToggleModeEn
	.global	gFlashSdrModeEn
	.global	gMultiPageProgEn
	.global	gMultiPageReadEn
	.global	gpReadRetrial
	.global	mlcPageToSlcPageTbl
	.global	slcPageToMlcPageTbl
	.global	DieAddrs
	.global	gDieOp
	.global	DieCsIndex
	.global	IDByte
	.global	read_retry_cur_offset
	.section	.rodata
.LANCHOR48 = . + 0
.LC0:
	.byte	60
	.byte	40
	.byte	24
	.byte	16
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
.LANCHOR232 = . + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.p_blk_mode_table,"aw",%nobits
	.align	2
.LANCHOR119 = . + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 4
p_blk_mode_table:
	.space	4
	.section	.rodata.__func__.7399,"a",%progbits
.LANCHOR240 = . + 0
	.type	__func__.7399, %object
	.size	__func__.7399, 10
__func__.7399:
	.ascii	"ftl_write\000"
	.section	.bss.p_gc_blk_tbl,"aw",%nobits
	.align	2
.LANCHOR146 = . + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.g_ect_tbl_power_up_flush,"aw",%nobits
	.align	1
.LANCHOR218 = . + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.space	2
	.section	.bss.gFlashSlcMode,"aw",%nobits
.LANCHOR7 = . + 0
	.type	gFlashSlcMode, %object
	.size	gFlashSlcMode, 1
gFlashSlcMode:
	.space	1
	.section	.data.gNandParaInfo,"aw",%progbits
	.align	1
.LANCHOR18 = . + 0
	.type	gNandParaInfo, %object
	.size	gNandParaInfo, 32
gNandParaInfo:
	.byte	0
	.byte	0
	.space	5
	.byte	0
	.byte	1
	.byte	8
	.short	128
	.byte	2
	.byte	1
	.short	2048
	.short	0
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.section	.rodata.__func__.8085,"a",%progbits
.LANCHOR127 = . + 0
	.type	__func__.8085, %object
	.size	__func__.8085, 16
__func__.8085:
	.ascii	"make_superblock\000"
	.section	.bss.gNandRandomizer,"aw",%nobits
.LANCHOR4 = . + 0
	.type	gNandRandomizer, %object
	.size	gNandRandomizer, 1
gNandRandomizer:
	.space	1
	.section	.bss.gDieOp,"aw",%nobits
	.align	2
.LANCHOR21 = . + 0
	.type	gDieOp, %object
	.size	gDieOp, 128
gDieOp:
	.space	128
	.section	.data.refValueDefault,"aw",%progbits
.LANCHOR242 = . + 0
	.type	refValueDefault, %object
	.size	refValueDefault, 28
refValueDefault:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	10
	.byte	6
	.byte	0
	.byte	-3
	.byte	-7
	.byte	-8
	.byte	0
	.byte	-6
	.byte	-13
	.byte	-15
	.byte	0
	.byte	-11
	.byte	-20
	.byte	-23
	.byte	0
	.byte	0
	.byte	-26
	.byte	-30
	.byte	0
	.byte	0
	.byte	-32
	.byte	-37
	.section	.bss.gFlashToggleModeEn,"aw",%nobits
.LANCHOR35 = . + 0
	.type	gFlashToggleModeEn, %object
	.size	gFlashToggleModeEn, 1
gFlashToggleModeEn:
	.space	1
	.section	.bss.g_sys_ext_data,"aw",%nobits
	.align	2
.LANCHOR144 = . + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.space	512
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
.LANCHOR70 = . + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.space	2
	.section	.bss.g_inkDie_check_enable,"aw",%nobits
	.align	2
.LANCHOR128 = . + 0
	.type	g_inkDie_check_enable, %object
	.size	g_inkDie_check_enable, 4
g_inkDie_check_enable:
	.space	4
	.section	.bss.gNandFlashEccBits,"aw",%nobits
.LANCHOR29 = . + 0
	.type	gNandFlashEccBits, %object
	.size	gNandFlashEccBits, 1
gNandFlashEccBits:
	.space	1
	.section	.rodata.__func__.7688,"a",%progbits
.LANCHOR220 = . + 0
	.type	__func__.7688, %object
	.size	__func__.7688, 16
__func__.7688:
	.ascii	"load_l2p_region\000"
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",%nobits
	.align	1
.LANCHOR201 = . + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.space	2
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
.LANCHOR180 = . + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.g_maxRetryCount,"aw",%nobits
.LANCHOR42 = . + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.gMultiPageProgEn,"aw",%nobits
.LANCHOR33 = . + 0
	.type	gMultiPageProgEn, %object
	.size	gMultiPageProgEn, 1
gMultiPageProgEn:
	.space	1
	.section	.bss.gMasterInfo,"aw",%nobits
	.align	2
.LANCHOR38 = . + 0
	.type	gMasterInfo, %object
	.size	gMasterInfo, 32
gMasterInfo:
	.space	32
	.section	.bss.g_gc_refresh_block_temp_tbl,"aw",%nobits
	.align	1
	.type	g_gc_refresh_block_temp_tbl, %object
	.size	g_gc_refresh_block_temp_tbl, 34
g_gc_refresh_block_temp_tbl:
	.space	34
	.section	.bss.gReadRetryInfo,"aw",%nobits
.LANCHOR31 = . + 0
	.type	gReadRetryInfo, %object
	.size	gReadRetryInfo, 852
gReadRetryInfo:
	.space	852
	.section	.bss.c_ftl_nand_die_num,"aw",%nobits
	.align	1
.LANCHOR60 = . + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.space	2
	.section	.bss.gToggleModeClkDiv,"aw",%nobits
	.align	2
	.type	gToggleModeClkDiv, %object
	.size	gToggleModeClkDiv, 4
gToggleModeClkDiv:
	.space	4
	.section	.bss.p_valid_page_count_table,"aw",%nobits
	.align	2
.LANCHOR101 = . + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.req_erase,"aw",%nobits
	.align	2
.LANCHOR95 = . + 0
	.type	req_erase, %object
	.size	req_erase, 4
req_erase:
	.space	4
	.section	.bss.c_ftl_nand_max_data_blks,"aw",%nobits
	.align	2
.LANCHOR57 = . + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.space	4
	.section	.bss.gNandFlashInfoBlockEcc,"aw",%nobits
	.type	gNandFlashInfoBlockEcc, %object
	.size	gNandFlashInfoBlockEcc, 1
gNandFlashInfoBlockEcc:
	.space	1
	.section	.bss.g_nandc_version_data,"aw",%nobits
	.align	2
.LANCHOR40 = . + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.space	4
	.section	.bss.gNandIDBResBlkNumSaveInFlash,"aw",%nobits
.LANCHOR49 = . + 0
	.type	gNandIDBResBlkNumSaveInFlash, %object
	.size	gNandIDBResBlkNumSaveInFlash, 1
gNandIDBResBlkNumSaveInFlash:
	.space	1
	.section	.bss.g_MaxLbn,"aw",%nobits
	.align	2
.LANCHOR200 = . + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.space	4
	.section	.bss.g_retryMode,"aw",%nobits
.LANCHOR11 = . + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.space	1
	.section	.bss.g_page_map_check_enable,"aw",%nobits
	.align	1
.LANCHOR85 = . + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.space	2
	.section	.rodata.__func__.7617,"a",%progbits
.LANCHOR107 = . + 0
	.type	__func__.7617, %object
	.size	__func__.7617, 17
__func__.7617:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.7462,"a",%progbits
.LANCHOR92 = . + 0
	.type	__func__.7462, %object
	.size	__func__.7462, 14
__func__.7462:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
.LANCHOR156 = . + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.space	4
	.section	.bss.gpReadRetrial,"aw",%nobits
	.align	2
.LANCHOR51 = . + 0
	.type	gpReadRetrial, %object
	.size	gpReadRetrial, 4
gpReadRetrial:
	.space	4
	.section	.rodata.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"FlashEraseBlocks pageAddr error %x\012\000"
.LC2:
	.ascii	"micron RR %d row=%x,count %d,status=%d\012\000"
.LC3:
	.ascii	"ECC:%d\012\000"
.LC4:
	.ascii	"sdr read ok %x ecc=%d\012\000"
.LC5:
	.ascii	"sync para %d\012\000"
.LC6:
	.ascii	"TOG mode Read error %x %x\012\000"
.LC7:
	.ascii	"read retry status %x %x %x\012\000"
.LC8:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
.LC9:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
.LC10:
	.ascii	"%s\012\000"
.LC11:
	.ascii	"!!!!! FTL sys Error !!!!!\000"
.LC12:
	.ascii	"remove_from_free_sys_Queue %x\012\000"
.LC13:
	.ascii	"%s 0x%x:\000"
.LC14:
	.ascii	"%x \000"
.LC15:
	.ascii	"\000"
.LC16:
	.ascii	"Read pageadd=%x  ecc=%x err=%x\012\000"
.LC17:
	.ascii	"data:\000"
.LC18:
	.ascii	"spare:\000"
.LC19:
	.ascii	"ReadRetry pageadd=%x ecc=%x err=%x\012\000"
.LC20:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!! \012\000"
.LC21:
	.ascii	"prog error: = %x\012\000"
.LC22:
	.ascii	"prog read error: = %x\012\000"
.LC23:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC24:
	.ascii	"prog read d error: = %x %x %x\012\000"
.LC25:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
.LC26:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC27:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC28:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
.LC29:
	.ascii	"decrement_vpc_count %x = %d\012\000"
.LC30:
	.ascii	"ftl_map_blk_gc blk info: %x %x %x\012\000"
.LC31:
	.ascii	"page map lost: %x %x\012\000"
.LC32:
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC33:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
.LC34:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
.LC35:
	.ascii	"slc mode\000"
.LC36:
	.ascii	"no ect\000"
.LC37:
	.ascii	"page map lost %x %x %x %x\012\000"
.LC38:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
.LC39:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
.LC40:
	.ascii	"GC des block %x done\012\000"
.LC41:
	.ascii	"RSB refresh addr %x \012\000"
.LC42:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC43:
	.ascii	"g_recovery_ppa %x ver %x\012 \000"
.LC44:
	.ascii	"fix power lost blk = %x vpc=%x\012\000"
.LC45:
	.ascii	"erase power lost blk = %x vpc=%x\012\000"
.LC46:
	.ascii	"FTL version: 5.0.47 20171110\000"
.LC47:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC48:
	.ascii	"...%s FtlSysBlkInit error ,format device!\012\000"
.LC49:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
.LC50:
	.ascii	"BBT:\000"
.LC51:
	.ascii	"otp error! %d\000"
.LC52:
	.ascii	"rr\000"
.LC53:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
.LC54:
	.ascii	"FlashLoadPhyInfo fail %x!!\012\000"
.LC55:
	.ascii	"FtlInit %x\012\000"
	.section	.bss.gNandFlashIdbBlockAddr,"aw",%nobits
	.align	2
.LANCHOR46 = . + 0
	.type	gNandFlashIdbBlockAddr, %object
	.size	gNandFlashIdbBlockAddr, 4
gNandFlashIdbBlockAddr:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
.LANCHOR198 = . + 0
	.type	req_sys, %object
	.size	req_sys, 36
req_sys:
	.space	36
	.section	.rodata.__func__.7998,"a",%progbits
.LANCHOR222 = . + 0
	.type	__func__.7998, %object
	.size	__func__.7998, 16
__func__.7998:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.7856,"a",%progbits
.LANCHOR206 = . + 0
	.type	__func__.7856, %object
	.size	__func__.7856, 15
__func__.7856:
	.ascii	"FtlVpcTblFlush\000"
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
.LANCHOR189 = . + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.g_gc_next_blk,"aw",%nobits
	.align	1
.LANCHOR149 = . + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.space	2
	.section	.bss.mlcPageToSlcPageTbl,"aw",%nobits
	.align	2
.LANCHOR9 = . + 0
	.type	mlcPageToSlcPageTbl, %object
	.size	mlcPageToSlcPageTbl, 1024
mlcPageToSlcPageTbl:
	.space	1024
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",%nobits
	.align	1
.LANCHOR72 = . + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.space	2
	.section	.bss.g_flash_read_only_en,"aw",%nobits
	.align	2
.LANCHOR94 = . + 0
	.type	g_flash_read_only_en, %object
	.size	g_flash_read_only_en, 4
g_flash_read_only_en:
	.space	4
	.section	.rodata.__func__.8218,"a",%progbits
.LANCHOR208 = . + 0
	.type	__func__.8218, %object
	.size	__func__.8218, 20
__func__.8218:
	.ascii	"decrement_vpc_count\000"
	.section	.bss.read_retry_cur_offset,"aw",%nobits
.LANCHOR32 = . + 0
	.type	read_retry_cur_offset, %object
	.size	read_retry_cur_offset, 4
read_retry_cur_offset:
	.space	4
	.section	.bss.p_vendor_block_valid_page_count,"aw",%nobits
	.align	2
.LANCHOR188 = . + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 4
p_vendor_block_valid_page_count:
	.space	4
	.section	.bss.gNandcVer,"aw",%nobits
	.align	2
.LANCHOR37 = . + 0
	.type	gNandcVer, %object
	.size	gNandcVer, 4
gNandcVer:
	.space	4
	.section	.rodata.__func__.7732,"a",%progbits
.LANCHOR212 = . + 0
	.type	__func__.7732, %object
	.size	__func__.7732, 15
__func__.7732:
	.ascii	"ftl_map_blk_gc\000"
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
.LANCHOR106 = . + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
.LANCHOR99 = . + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.bss.g_power_lost_ecc_error_blk,"aw",%nobits
	.align	1
.LANCHOR229 = . + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.space	2
	.section	.bss.g_gc_skip_write_count,"aw",%nobits
	.align	2
.LANCHOR172 = . + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.space	4
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",%nobits
	.align	1
.LANCHOR55 = . + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.space	2
	.section	.bss.p_map_region_ppn_check_table,"aw",%nobits
	.align	2
.LANCHOR191 = . + 0
	.type	p_map_region_ppn_check_table, %object
	.size	p_map_region_ppn_check_table, 4
p_map_region_ppn_check_table:
	.space	4
	.section	.bss.gMultiPageReadEn,"aw",%nobits
.LANCHOR194 = . + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.space	1
	.section	.bss.DieAddrs,"aw",%nobits
	.align	2
.LANCHOR20 = . + 0
	.type	DieAddrs, %object
	.size	DieAddrs, 32
DieAddrs:
	.space	32
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
.LANCHOR164 = . + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",%nobits
	.align	2
.LANCHOR205 = . + 0
	.type	gFlashProgCheckSpareBuffer, %object
	.size	gFlashProgCheckSpareBuffer, 4
gFlashProgCheckSpareBuffer:
	.space	4
	.section	.data.gSlcNandParaInfo,"aw",%progbits
	.align	1
.LANCHOR243 = . + 0
	.type	gSlcNandParaInfo, %object
	.size	gSlcNandParaInfo, 32
gSlcNandParaInfo:
	.byte	2
	.byte	-104
	.byte	-15
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	4
	.short	64
	.byte	1
	.byte	1
	.short	1024
	.short	256
	.byte	0
	.byte	0
	.byte	16
	.byte	40
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.section	.rodata.__func__.7621,"a",%progbits
.LANCHOR104 = . + 0
	.type	__func__.7621, %object
	.size	__func__.7621, 17
__func__.7621:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
.LANCHOR184 = . + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 4
p_sys_spare_buf:
	.space	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",%nobits
	.align	1
.LANCHOR153 = . + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.gNandFlashResEndPageAddr,"aw",%nobits
	.align	2
	.type	gNandFlashResEndPageAddr, %object
	.size	gNandFlashResEndPageAddr, 4
gNandFlashResEndPageAddr:
	.space	4
	.section	.bss.gp_gc_page_buf_info,"aw",%nobits
	.align	2
.LANCHOR134 = . + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
.LANCHOR233 = . + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.space	2
	.section	.bss.g_totle_write_sector,"aw",%nobits
	.align	2
.LANCHOR216 = . + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.space	4
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",%nobits
	.align	1
.LANCHOR64 = . + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.space	2
	.section	.bss.gpNandc1,"aw",%nobits
	.align	2
	.type	gpNandc1, %object
	.size	gpNandc1, 4
gpNandc1:
	.space	4
	.section	.bss.g_in_swl_replace,"aw",%nobits
	.align	2
.LANCHOR169 = . + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.space	4
	.section	.bss.FlashDdrTunningReadCount,"aw",%nobits
	.align	2
.LANCHOR50 = . + 0
	.type	FlashDdrTunningReadCount, %object
	.size	FlashDdrTunningReadCount, 4
FlashDdrTunningReadCount:
	.space	4
	.section	.bss.gBootDdrMode,"aw",%nobits
	.align	2
.LANCHOR192 = . + 0
	.type	gBootDdrMode, %object
	.size	gBootDdrMode, 4
gBootDdrMode:
	.space	4
	.section	.bss.gNandMaxChip,"aw",%nobits
.LANCHOR17 = . + 0
	.type	gNandMaxChip, %object
	.size	gNandMaxChip, 1
gNandMaxChip:
	.space	1
	.section	.bss.c_mlc_erase_count_value,"aw",%nobits
	.align	1
.LANCHOR63 = . + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.space	2
	.section	.bss.p_map_block_table,"aw",%nobits
	.align	2
.LANCHOR124 = . + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 4
p_map_block_table:
	.space	4
	.section	.data.SamsungRefValue,"aw",%progbits
.LANCHOR15 = . + 0
	.type	SamsungRefValue, %object
	.size	SamsungRefValue, 64
SamsungRefValue:
	.byte	-89
	.byte	-92
	.byte	-91
	.byte	-90
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	10
	.byte	0
	.byte	0
	.byte	40
	.byte	0
	.byte	-20
	.byte	-40
	.byte	-19
	.byte	-11
	.byte	-19
	.byte	-26
	.byte	10
	.byte	15
	.byte	5
	.byte	0
	.byte	15
	.byte	10
	.byte	-5
	.byte	-20
	.byte	-24
	.byte	-17
	.byte	-24
	.byte	-36
	.byte	-15
	.byte	-5
	.byte	-2
	.byte	-16
	.byte	10
	.byte	0
	.byte	-5
	.byte	-20
	.byte	-48
	.byte	-30
	.byte	-48
	.byte	-62
	.byte	20
	.byte	15
	.byte	-5
	.byte	-20
	.byte	-24
	.byte	-5
	.byte	-24
	.byte	-36
	.byte	30
	.byte	20
	.byte	-5
	.byte	-20
	.byte	-5
	.byte	-1
	.byte	-5
	.byte	-8
	.byte	7
	.byte	12
	.byte	2
	.byte	0
	.section	.data.NandOptPara,"aw",%progbits
.LANCHOR27 = . + 0
	.type	NandOptPara, %object
	.size	NandOptPara, 128
NandOptPara:
	.byte	1
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	0
	.byte	50
	.byte	17
	.byte	-128
	.byte	112
	.byte	120
	.byte	120
	.byte	3
	.byte	1
	.byte	0
	.space	14
	.byte	2
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	0
	.byte	0
	.byte	17
	.byte	-127
	.byte	112
	.byte	-15
	.byte	-14
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.byte	3
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	96
	.byte	96
	.byte	17
	.byte	-127
	.byte	112
	.byte	-15
	.byte	-14
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.byte	4
	.byte	0
	.byte	49
	.byte	63
	.byte	0
	.byte	49
	.byte	-128
	.byte	21
	.byte	96
	.byte	96
	.byte	17
	.byte	-127
	.byte	112
	.byte	112
	.byte	112
	.byte	0
	.byte	0
	.byte	0
	.space	14
	.section	.rodata.__func__.7373,"a",%progbits
.LANCHOR223 = . + 0
	.type	__func__.7373, %object
	.size	__func__.7373, 13
__func__.7373:
	.ascii	"FtlProgPages\000"
	.section	.bss.c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
.LANCHOR66 = . + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.space	2
	.section	.rodata.__func__.8031,"a",%progbits
.LANCHOR228 = . + 0
	.type	__func__.8031, %object
	.size	__func__.8031, 22
__func__.8031:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.bss.g_totle_read_sector,"aw",%nobits
	.align	2
.LANCHOR217 = . + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.space	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",%nobits
	.align	2
.LANCHOR54 = . + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.space	4
	.section	.bss.g_slc2KBNand,"aw",%nobits
.LANCHOR0 = . + 0
	.type	g_slc2KBNand, %object
	.size	g_slc2KBNand, 1
g_slc2KBNand:
	.space	1
	.section	.bss.gNandFlashIDBEccBits,"aw",%nobits
.LANCHOR45 = . + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.space	1
	.section	.rodata.__func__.8182,"a",%progbits
.LANCHOR210 = . + 0
	.type	__func__.8182, %object
	.size	__func__.8182, 25
__func__.8182:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.7745,"a",%progbits
.LANCHOR213 = . + 0
	.type	__func__.7745, %object
	.size	__func__.7745, 31
__func__.7745:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.data.Toshiba15RefValue,"aw",%progbits
.LANCHOR12 = . + 0
	.type	Toshiba15RefValue, %object
	.size	Toshiba15RefValue, 95
Toshiba15RefValue:
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.byte	4
	.byte	2
	.byte	0
	.byte	0
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	124
	.byte	0
	.byte	124
	.byte	124
	.byte	0
	.byte	122
	.byte	0
	.byte	122
	.byte	122
	.byte	0
	.byte	11
	.byte	126
	.byte	118
	.byte	116
	.byte	0
	.byte	120
	.byte	2
	.byte	120
	.byte	122
	.byte	0
	.byte	126
	.byte	4
	.byte	126
	.byte	122
	.byte	0
	.byte	16
	.byte	118
	.byte	114
	.byte	112
	.byte	0
	.byte	118
	.byte	4
	.byte	118
	.byte	120
	.byte	0
	.byte	4
	.byte	4
	.byte	4
	.byte	118
	.byte	0
	.byte	2
	.byte	0
	.byte	126
	.byte	124
	.byte	0
	.byte	6
	.byte	10
	.byte	6
	.byte	2
	.byte	0
	.byte	116
	.byte	124
	.byte	116
	.byte	118
	.byte	0
	.byte	4
	.byte	4
	.byte	124
	.byte	126
	.byte	0
	.byte	0
	.byte	124
	.byte	120
	.byte	120
	.byte	0
	.byte	124
	.byte	118
	.byte	116
	.byte	114
	.byte	0
	.section	.bss.g_gc_next_blk_1,"aw",%nobits
	.align	1
.LANCHOR150 = . + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.bss.g_free_slc_blk_num,"aw",%nobits
	.align	1
.LANCHOR129 = . + 0
	.type	g_free_slc_blk_num, %object
	.size	g_free_slc_blk_num, 2
g_free_slc_blk_num:
	.space	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
.LANCHOR82 = . + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.space	2
	.section	.bss.req_gc,"aw",%nobits
	.align	2
.LANCHOR135 = . + 0
	.type	req_gc, %object
	.size	req_gc, 4
req_gc:
	.space	4
	.section	.bss.gpNandc,"aw",%nobits
	.align	2
.LANCHOR30 = . + 0
	.type	gpNandc, %object
	.size	gpNandc, 4
gpNandc:
	.space	4
	.section	.bss.gpFlashSaveInfo,"aw",%nobits
	.align	2
.LANCHOR43 = . + 0
	.type	gpFlashSaveInfo, %object
	.size	gpFlashSaveInfo, 4
gpFlashSaveInfo:
	.space	4
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
.LANCHOR86 = . + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.p_l2p_ram_map,"aw",%nobits
	.align	2
.LANCHOR114 = . + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 4
p_l2p_ram_map:
	.space	4
	.section	.bss.FlashWaitBusyScheduleEn,"aw",%nobits
	.align	2
	.type	FlashWaitBusyScheduleEn, %object
	.size	FlashWaitBusyScheduleEn, 4
FlashWaitBusyScheduleEn:
	.space	4
	.section	.bss.p_plane_order_table,"aw",%nobits
.LANCHOR62 = . + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.space	32
	.section	.bss.DieCsIndex,"aw",%nobits
	.align	2
.LANCHOR19 = . + 0
	.type	DieCsIndex, %object
	.size	DieCsIndex, 8
DieCsIndex:
	.space	8
	.section	.bss.g_totle_cache_write_count,"aw",%nobits
	.align	2
.LANCHOR161 = . + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",%nobits
	.align	1
.LANCHOR74 = . + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
.LANCHOR152 = . + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.space	34
	.section	.bss.gFlashSdrModeEn,"aw",%nobits
	.type	gFlashSdrModeEn, %object
	.size	gFlashSdrModeEn, 1
gFlashSdrModeEn:
	.space	1
	.section	.bss.p_data_block_list_tail,"aw",%nobits
	.align	2
.LANCHOR102 = . + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.gFlashInterfaceMode,"aw",%nobits
.LANCHOR34 = . + 0
	.type	gFlashInterfaceMode, %object
	.size	gFlashInterfaceMode, 1
gFlashInterfaceMode:
	.space	1
	.section	.bss.p_map_block_ver_table,"aw",%nobits
	.align	2
.LANCHOR125 = . + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 4
p_map_block_ver_table:
	.space	4
	.section	.bss.gNandcEccBits,"aw",%nobits
	.align	2
.LANCHOR36 = . + 0
	.type	gNandcEccBits, %object
	.size	gNandcEccBits, 4
gNandcEccBits:
	.space	4
	.section	.data.ToshibaA19RefValue,"aw",%progbits
.LANCHOR10 = . + 0
	.type	ToshibaA19RefValue, %object
	.size	ToshibaA19RefValue, 45
ToshibaA19RefValue:
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	13
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	4
	.byte	4
	.byte	124
	.byte	126
	.byte	0
	.byte	0
	.byte	124
	.byte	120
	.byte	120
	.byte	0
	.byte	124
	.byte	118
	.byte	116
	.byte	114
	.byte	0
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	11
	.byte	126
	.byte	118
	.byte	116
	.byte	0
	.byte	16
	.byte	118
	.byte	114
	.byte	112
	.byte	0
	.byte	2
	.byte	0
	.byte	126
	.byte	124
	.byte	0
	.section	.bss.g_totle_swl_count,"aw",%nobits
	.align	2
.LANCHOR139 = . + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.space	4
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
.LANCHOR90 = . + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 60
gBbtInfo:
	.space	60
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",%nobits
	.align	1
.LANCHOR73 = . + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
.LANCHOR230 = . + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.gNandIDBResBlkNum,"aw",%nobits
.LANCHOR1 = . + 0
	.type	gNandIDBResBlkNum, %object
	.size	gNandIDBResBlkNum, 1
gNandIDBResBlkNum:
	.space	1
	.section	.bss.gNandcDumpWriteEn,"aw",%nobits
	.align	2
.LANCHOR39 = . + 0
	.type	gNandcDumpWriteEn, %object
	.size	gNandcDumpWriteEn, 4
gNandcDumpWriteEn:
	.space	4
	.section	.bss.g_gc_refresh_block_temp_num,"aw",%nobits
	.align	1
.LANCHOR176 = . + 0
	.type	g_gc_refresh_block_temp_num, %object
	.size	g_gc_refresh_block_temp_num, 2
g_gc_refresh_block_temp_num:
	.space	2
	.section	.bss.g_tmp_data_superblock_id,"aw",%nobits
	.align	1
.LANCHOR138 = . + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.space	2
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",%nobits
	.align	2
.LANCHOR58 = . + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.space	4
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
.LANCHOR195 = . + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
.LANCHOR126 = . + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 4
p_map_region_ppn_table:
	.space	4
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
.LANCHOR234 = . + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.space	2
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
.LANCHOR148 = . + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 4
p_gc_page_info:
	.space	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",%nobits
	.align	1
.LANCHOR83 = . + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.space	2
	.section	.bss.gc_discard_updated,"aw",%nobits
	.align	2
.LANCHOR227 = . + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.rodata.__func__.7758,"a",%progbits
.LANCHOR214 = . + 0
	.type	__func__.7758, %object
	.size	__func__.7758, 16
__func__.7758:
	.ascii	"FtlMapWritePage\000"
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
.LANCHOR186 = . + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.space	2
	.section	.bss.g_all_blk_used_slc_mode,"aw",%nobits
	.align	2
.LANCHOR155 = . + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.space	4
	.section	.rodata.__func__.7508,"a",%progbits
.LANCHOR203 = . + 0
	.type	__func__.7508, %object
	.size	__func__.7508, 11
__func__.7508:
	.ascii	"FtlLoadBbt\000"
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",%nobits
	.align	1
.LANCHOR78 = . + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
.LANCHOR239 = . + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.space	4
	.section	.data.ToshibaRefValue,"aw",%progbits
.LANCHOR13 = . + 0
	.type	ToshibaRefValue, %object
	.size	ToshibaRefValue, 8
ToshibaRefValue:
	.byte	0
	.byte	4
	.byte	124
	.byte	120
	.byte	116
	.byte	8
	.byte	12
	.byte	112
	.section	.bss.g_l2p_last_update_region_id,"aw",%nobits
	.align	1
.LANCHOR115 = . + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.space	2
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
.LANCHOR147 = . + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.space	2
	.section	.bss.gMasterTempBuf,"aw",%nobits
	.align	2
.LANCHOR193 = . + 0
	.type	gMasterTempBuf, %object
	.size	gMasterTempBuf, 4
gMasterTempBuf:
	.space	4
	.section	.bss.g_gc_blk_num,"aw",%nobits
	.align	1
.LANCHOR145 = . + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.space	2
	.section	.bss.c_ftl_nand_max_map_blks,"aw",%nobits
	.align	2
.LANCHOR80 = . + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.space	4
	.section	.bss.g_totle_read_page_count,"aw",%nobits
	.align	2
.LANCHOR163 = . + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.space	4
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
.LANCHOR131 = . + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.space	4
	.section	.bss.p_swl_mul_table,"aw",%nobits
	.align	2
.LANCHOR142 = . + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
.LANCHOR140 = . + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
.LANCHOR181 = . + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.rodata.__func__.7875,"a",%progbits
.LANCHOR197 = . + 0
	.type	__func__.7875, %object
	.size	__func__.7875, 14
__func__.7875:
	.ascii	"FtlScanSysBlk\000"
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
.LANCHOR190 = . + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 4
p_vendor_region_ppn_table:
	.space	4
	.section	.bss.p_map_block_valid_page_count,"aw",%nobits
	.align	2
.LANCHOR120 = . + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
.LANCHOR179 = . + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
.LANCHOR162 = . + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
.LANCHOR103 = . + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.space	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",%nobits
	.align	1
.LANCHOR56 = . + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.space	2
	.section	.bss.g_gc_head_data_block,"aw",%nobits
	.align	2
.LANCHOR170 = . + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_totle_slc_erase_count,"aw",%nobits
	.align	2
.LANCHOR165 = . + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.rodata.__func__.8202,"a",%progbits
.LANCHOR209 = . + 0
	.type	__func__.8202, %object
	.size	__func__.8202, 19
__func__.8202:
	.ascii	"get_new_active_ppa\000"
	.section	.bss.req_gc_dst,"aw",%nobits
	.align	2
.LANCHOR178 = . + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
.LANCHOR177 = . + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
.LANCHOR211 = . + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.space	4
	.section	.bss.c_ftl_nand_planes_per_die,"aw",%nobits
	.align	1
.LANCHOR61 = . + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.space	2
	.section	.rodata.__func__.7794,"a",%progbits
.LANCHOR221 = . + 0
	.type	__func__.7794, %object
	.size	__func__.7794, 9
__func__.7794:
	.ascii	"log2phys\000"
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
.LANCHOR174 = . + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.space	2
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
.LANCHOR88 = . + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.space	4
	.section	.bss.gpNandParaInfo,"aw",%nobits
	.align	2
.LANCHOR23 = . + 0
	.type	gpNandParaInfo, %object
	.size	gpNandParaInfo, 4
gpNandParaInfo:
	.space	4
	.section	.rodata.__func__.7651,"a",%progbits
.LANCHOR108 = . + 0
	.type	__func__.7651, %object
	.size	__func__.7651, 17
__func__.7651:
	.ascii	"List_remove_node\000"
	.section	.bss.g_LowFormat,"aw",%nobits
	.align	2
.LANCHOR237 = . + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.space	4
	.section	.bss.c_ftl_nand_type,"aw",%nobits
	.align	1
.LANCHOR59 = . + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.space	2
	.section	.bss.gSysFreeQueue,"aw",%nobits
	.align	1
.LANCHOR93 = . + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.slcPageToMlcPageTbl,"aw",%nobits
	.align	2
.LANCHOR8 = . + 0
	.type	slcPageToMlcPageTbl, %object
	.size	slcPageToMlcPageTbl, 512
slcPageToMlcPageTbl:
	.space	512
	.section	.rodata.__func__.8286,"a",%progbits
.LANCHOR226 = . + 0
	.type	__func__.8286, %object
	.size	__func__.8286, 19
__func__.8286:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.7313,"a",%progbits
.LANCHOR238 = . + 0
	.type	__func__.7313, %object
	.size	__func__.7313, 8
__func__.7313:
	.ascii	"FtlInit\000"
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",%nobits
	.align	2
.LANCHOR52 = . + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.space	4
	.section	.rodata.__func__.8380,"a",%progbits
.LANCHOR236 = . + 0
	.type	__func__.8380, %object
	.size	__func__.8380, 23
__func__.8380:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.bss.g_buffer_superblock,"aw",%nobits
	.align	2
.LANCHOR110 = . + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
.LANCHOR98 = . + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.c_ftl_nand_reserved_blks,"aw",%nobits
	.align	1
.LANCHOR75 = . + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.space	2
	.section	.bss.g_maxRegNum,"aw",%nobits
.LANCHOR14 = . + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.space	1
	.section	.bss.p_gc_spare_buf,"aw",%nobits
	.align	2
.LANCHOR133 = . + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 4
p_gc_spare_buf:
	.space	4
	.section	.rodata.__func__.7681,"a",%progbits
.LANCHOR112 = . + 0
	.type	__func__.7681, %object
	.size	__func__.7681, 22
__func__.7681:
	.ascii	"List_update_data_list\000"
	.section	.bss.gNandFlashInfoBlockAddr,"aw",%nobits
	.align	2
.LANCHOR47 = . + 0
	.type	gNandFlashInfoBlockAddr, %object
	.size	gNandFlashInfoBlockAddr, 4
gNandFlashInfoBlockAddr:
	.space	4
	.section	.bss.p_valid_page_count_check_table,"aw",%nobits
	.align	2
	.type	p_valid_page_count_check_table, %object
	.size	p_valid_page_count_check_table, 4
p_valid_page_count_check_table:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
.LANCHOR185 = . + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 4
p_io_spare_buf:
	.space	4
	.section	.bss.c_ftl_vendor_part_size,"aw",%nobits
	.align	1
.LANCHOR65 = . + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.space	2
	.section	.bss.c_ftl_nand_planes_num,"aw",%nobits
	.align	1
.LANCHOR53 = . + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.space	2
	.section	.bss.p_io_data_buf_0,"aw",%nobits
	.align	2
.LANCHOR182 = . + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
.LANCHOR183 = . + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.data.power_up_flag,"aw",%progbits
	.align	2
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.bss.gFlashOnfiModeEn,"aw",%nobits
	.type	gFlashOnfiModeEn, %object
	.size	gFlashOnfiModeEn, 1
gFlashOnfiModeEn:
	.space	1
	.section	.bss.g_totle_write_page_count,"aw",%nobits
	.align	2
.LANCHOR159 = . + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
.LANCHOR158 = . + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.rodata.__func__.7929,"a",%progbits
.LANCHOR199 = . + 0
	.type	__func__.7929, %object
	.size	__func__.7929, 15
__func__.7929:
	.ascii	"FtlLoadSysInfo\000"
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
.LANCHOR167 = . + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.FtlUpdateVaildLpnCount,"aw",%nobits
	.align	1
.LANCHOR117 = . + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.space	2
	.section	.rodata.__func__.8213,"a",%progbits
.LANCHOR207 = . + 0
	.type	__func__.8213, %object
	.size	__func__.8213, 16
__func__.8213:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.7778,"a",%progbits
.LANCHOR116 = . + 0
	.type	__func__.7778, %object
	.size	__func__.7778, 22
__func__.7778:
	.ascii	"select_l2p_ram_region\000"
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
.LANCHOR89 = . + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_in_gc_progress,"aw",%nobits
	.align	2
.LANCHOR168 = . + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.space	4
	.section	.bss.gNandChipMap,"aw",%nobits
	.align	2
.LANCHOR5 = . + 0
	.type	gNandChipMap, %object
	.size	gNandChipMap, 32
gNandChipMap:
	.space	32
	.section	.bss.gFlashPageBuffer1,"aw",%nobits
	.align	2
.LANCHOR41 = . + 0
	.type	gFlashPageBuffer1, %object
	.size	gFlashPageBuffer1, 4
gFlashPageBuffer1:
	.space	4
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",%nobits
	.align	2
.LANCHOR81 = . + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
.LANCHOR105 = . + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 4
p_free_data_block_list_head:
	.space	4
	.section	.bss.gNandIDataBuf,"aw",%nobits
	.align	2
.LANCHOR25 = . + 0
	.type	gNandIDataBuf, %object
	.size	gNandIDataBuf, 2048
gNandIDataBuf:
	.space	2048
	.section	.bss.gNandPhyInfo,"aw",%nobits
	.align	2
.LANCHOR28 = . + 0
	.type	gNandPhyInfo, %object
	.size	gNandPhyInfo, 28
gNandPhyInfo:
	.space	28
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
.LANCHOR196 = . + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.space	12
	.section	.rodata.__func__.8105,"a",%progbits
.LANCHOR130 = . + 0
	.type	__func__.8105, %object
	.size	__func__.8105, 18
__func__.8105:
	.ascii	"SupperBlkListInit\000"
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
.LANCHOR175 = . + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.space	2
	.section	.bss.g_gc_free_blk_threshold,"aw",%nobits
	.align	1
.LANCHOR173 = . + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_max_erase_count,"aw",%nobits
	.align	2
.LANCHOR166 = . + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.gVendorBlkInfo,"aw",%nobits
	.align	2
.LANCHOR215 = . + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 44
gVendorBlkInfo:
	.space	44
	.section	.bss.g_GlobalDataVersion,"aw",%nobits
	.align	2
.LANCHOR157 = . + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
.LANCHOR224 = . + 0
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 4
gp_last_act_superblock:
	.space	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",%nobits
	.align	1
.LANCHOR77 = . + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.space	2
	.section	.data.random_seed,"aw",%progbits
	.align	1
.LANCHOR3 = . + 0
	.type	random_seed, %object
	.size	random_seed, 256
random_seed:
	.short	22378
	.short	1512
	.short	25245
	.short	17827
	.short	25756
	.short	19440
	.short	9026
	.short	10030
	.short	29528
	.short	20467
	.short	29676
	.short	24432
	.short	31328
	.short	6872
	.short	13426
	.short	13842
	.short	8783
	.short	1108
	.short	782
	.short	28837
	.short	30729
	.short	9505
	.short	18676
	.short	23085
	.short	18730
	.short	1085
	.short	32609
	.short	14697
	.short	20858
	.short	15170
	.short	30365
	.short	1607
	.short	32298
	.short	4995
	.short	18905
	.short	1976
	.short	9592
	.short	20204
	.short	17443
	.short	13615
	.short	23330
	.short	29369
	.short	13947
	.short	9398
	.short	32398
	.short	8984
	.short	27600
	.short	21785
	.short	6019
	.short	6311
	.short	31598
	.short	30210
	.short	19327
	.short	13896
	.short	11347
	.short	27545
	.short	3107
	.short	26575
	.short	32270
	.short	19852
	.short	20601
	.short	8349
	.short	9290
	.short	29819
	.short	13579
	.short	3661
	.short	28676
	.short	27331
	.short	32574
	.short	8693
	.short	31253
	.short	9081
	.short	5399
	.short	6842
	.short	20087
	.short	5537
	.short	1274
	.short	11617
	.short	9530
	.short	4866
	.short	8035
	.short	23219
	.short	1178
	.short	23272
	.short	7383
	.short	18944
	.short	12488
	.short	12871
	.short	29340
	.short	20532
	.short	11022
	.short	22514
	.short	228
	.short	22363
	.short	24978
	.short	14584
	.short	12138
	.short	3092
	.short	17916
	.short	16863
	.short	14554
	.short	31457
	.short	29474
	.short	25311
	.short	24121
	.short	3684
	.short	28037
	.short	22865
	.short	22839
	.short	25217
	.short	13217
	.short	27186
	.short	14938
	.short	11180
	.short	29754
	.short	24180
	.short	15150
	.short	32455
	.short	20434
	.short	23848
	.short	29983
	.short	16120
	.short	14769
	.short	20041
	.short	29803
	.short	28406
	.short	17598
	.short	28087
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",%nobits
	.align	1
.LANCHOR71 = . + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.space	2
	.section	.bss.gNandMaxDie,"aw",%nobits
.LANCHOR16 = . + 0
	.type	gNandMaxDie, %object
	.size	gNandMaxDie, 1
gNandMaxDie:
	.space	1
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
.LANCHOR132 = . + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.bss.g_MaxLbaSector,"aw",%nobits
	.align	2
.LANCHOR84 = . + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
.LANCHOR96 = . + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
.LANCHOR87 = . + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 4
p_vendor_block_table:
	.space	4
	.section	.bss.p_data_block_list_head,"aw",%nobits
	.align	2
.LANCHOR100 = . + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 4
p_data_block_list_head:
	.space	4
	.section	.bss.gNandOptPara,"aw",%nobits
.LANCHOR6 = . + 0
	.type	gNandOptPara, %object
	.size	gNandOptPara, 32
gNandOptPara:
	.space	32
	.section	.bss.g_sys_save_data,"aw",%nobits
	.align	2
.LANCHOR143 = . + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.space	48
	.section	.bss.g_VaildLpn,"aw",%nobits
	.align	2
.LANCHOR118 = . + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
.LANCHOR231 = . + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.gTotleBlock,"aw",%nobits
	.align	1
.LANCHOR24 = . + 0
	.type	gTotleBlock, %object
	.size	gTotleBlock, 2
gTotleBlock:
	.space	2
	.section	.bss.gFlashSpareBuffer,"aw",%nobits
	.align	2
.LANCHOR241 = . + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 4
gFlashSpareBuffer:
	.space	4
	.section	.bss.gFlashProgCheckBuffer,"aw",%nobits
	.align	2
.LANCHOR204 = . + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 4
gFlashProgCheckBuffer:
	.space	4
	.section	.bss.IDByte,"aw",%nobits
	.align	2
.LANCHOR22 = . + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.space	32
	.section	.bss.g_gc_temp_superblock,"aw",%nobits
	.align	2
.LANCHOR111 = . + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.space	48
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",%nobits
	.align	1
.LANCHOR69 = . + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.space	2
	.section	.bss.gBlockPageAlignSize,"aw",%nobits
	.align	2
.LANCHOR2 = . + 0
	.type	gBlockPageAlignSize, %object
	.size	gBlockPageAlignSize, 4
gBlockPageAlignSize:
	.space	4
	.section	.bss.g_gc_superblock,"aw",%nobits
	.align	2
.LANCHOR202 = . + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.space	48
	.section	.rodata.__func__.8196,"a",%progbits
.LANCHOR219 = . + 0
	.type	__func__.8196, %object
	.size	__func__.8196, 29
__func__.8196:
	.ascii	"allocate_new_data_superblock\000"
	.section	.bss.g_totle_sys_slc_erase_count,"aw",%nobits
	.align	2
.LANCHOR97 = . + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.space	4
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",%nobits
	.align	1
.LANCHOR67 = . + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.space	2
	.section	.bss.g_SlcPartLbaEndSector,"aw",%nobits
	.align	2
.LANCHOR154 = . + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.space	4
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",%nobits
	.align	1
.LANCHOR235 = . + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
.LANCHOR160 = . + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",%nobits
	.align	1
.LANCHOR91 = . + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.space	2
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
.LANCHOR122 = . + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 44
gL2pMapInfo:
	.space	44
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
.LANCHOR171 = . + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.bss.gFlashPageBuffer0,"aw",%nobits
	.align	2
.LANCHOR44 = . + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 4
gFlashPageBuffer0:
	.space	4
	.section	.bss.g_req_cache,"aw",%nobits
	.align	2
.LANCHOR137 = . + 0
	.type	g_req_cache, %object
	.size	g_req_cache, 4
g_req_cache:
	.space	4
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
.LANCHOR225 = . + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.bss.c_gc_page_buf_num,"aw",%nobits
	.align	2
.LANCHOR136 = . + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.space	4
	.section	.rodata.__func__.7718,"a",%progbits
.LANCHOR113 = . + 0
	.type	__func__.7718, %object
	.size	__func__.7718, 26
__func__.7718:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.data.NandFlashParaTbl,"aw",%progbits
	.align	1
.LANCHOR26 = . + 0
	.type	NandFlashParaTbl, %object
	.size	NandFlashParaTbl, 2304
NandFlashParaTbl:
	.byte	6
	.byte	44
	.byte	100
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	68
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1064
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	104
	.byte	4
	.byte	74
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	-120
	.byte	4
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-88
	.byte	5
	.byte	-53
	.byte	-87
	.byte	0
	.byte	4
	.byte	2
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	104
	.byte	4
	.byte	70
	.byte	-119
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	72
	.byte	4
	.byte	74
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-124
	.byte	100
	.byte	60
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	-124
	.byte	100
	.byte	84
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-41
	.byte	-108
	.byte	62
	.byte	-124
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	128
	.byte	2
	.byte	2
	.short	4096
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	72
	.byte	4
	.byte	70
	.byte	-123
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-120
	.byte	5
	.byte	-58
	.byte	-119
	.byte	0
	.byte	4
	.byte	2
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	104
	.byte	0
	.byte	39
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.short	128
	.byte	1
	.byte	2
	.short	2048
	.short	287
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	86
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	24
	.short	512
	.byte	2
	.byte	2
	.short	700
	.short	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-124
	.byte	-59
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	2
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-43
	.byte	-47
	.byte	-90
	.byte	104
	.byte	0
	.byte	4
	.byte	2
	.byte	8
	.short	64
	.byte	1
	.byte	2
	.short	2048
	.short	279
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	44
	.byte	-36
	.byte	-112
	.byte	-90
	.byte	84
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.short	64
	.byte	1
	.byte	2
	.short	1024
	.short	279
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	84
	.byte	-92
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1024
	.short	479
	.byte	4
	.byte	18
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	100
	.byte	68
	.byte	50
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1048
	.short	1503
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.space	4
	.byte	5
	.byte	44
	.byte	100
	.byte	100
	.byte	60
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	32
	.short	512
	.byte	2
	.byte	1
	.short	1044
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-46
	.byte	4
	.byte	67
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	473
	.byte	1
	.byte	1
	.byte	24
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-61
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	473
	.byte	1
	.byte	2
	.byte	40
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-111
	.byte	96
	.byte	68
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1046
	.short	473
	.byte	1
	.byte	3
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-60
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2090
	.short	473
	.byte	1
	.byte	4
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-21
	.byte	116
	.byte	68
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	473
	.byte	1
	.byte	7
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-43
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-60
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	530
	.short	473
	.byte	1
	.byte	3
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-102
	.byte	116
	.byte	66
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	281
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	20
	.byte	-89
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1060
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	20
	.byte	-98
	.byte	52
	.byte	74
	.byte	2
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-89
	.byte	66
	.byte	72
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1060
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	20
	.byte	-85
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	473
	.byte	2
	.byte	6
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-83
	.byte	58
	.byte	20
	.byte	-85
	.byte	66
	.byte	74
	.byte	2
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2092
	.short	473
	.byte	2
	.byte	5
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	100
	.byte	68
	.byte	75
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	-124
	.byte	7
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	36
	.byte	74
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	4
	.byte	74
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	-41
	.byte	-108
	.byte	62
	.byte	-124
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	4
	.byte	70
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	58
	.byte	-123
	.byte	-109
	.byte	118
	.byte	87
	.byte	1
	.byte	2
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1505
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-43
	.byte	-124
	.byte	50
	.byte	114
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	1
	.short	2056
	.short	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-108
	.byte	50
	.byte	118
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2058
	.short	1489
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-126
	.byte	118
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2062
	.short	1489
	.byte	1
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	80
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	58
	.byte	-107
	.byte	-109
	.byte	122
	.byte	80
	.byte	1
	.byte	2
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-108
	.byte	50
	.byte	118
	.byte	85
	.byte	1
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2050
	.short	401
	.byte	2
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	87
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	80
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	58
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1056
	.short	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	87
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-92
	.byte	-126
	.byte	118
	.byte	86
	.byte	8
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2082
	.short	473
	.byte	1
	.byte	65
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
	.byte	2
	.byte	67
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
	.byte	2
	.byte	67
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-92
	.byte	-126
	.byte	118
	.byte	-41
	.byte	8
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2090
	.short	1241
	.byte	1
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-124
	.byte	-109
	.byte	114
	.byte	87
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1473
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	58
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	1497
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	81
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	1497
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	58
	.byte	-92
	.byte	-109
	.byte	122
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	2138
	.short	1497
	.byte	2
	.byte	0
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-126
	.byte	118
	.byte	86
	.byte	8
	.byte	1
	.byte	16
	.short	256
	.byte	2
	.byte	2
	.short	2062
	.short	473
	.byte	1
	.byte	0
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	-41
	.byte	8
	.byte	1
	.byte	32
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	-108
	.byte	126
	.byte	100
	.byte	68
	.byte	0
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2048
	.short	473
	.byte	2
	.byte	49
	.byte	60
	.byte	36
	.byte	3
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-34
	.byte	-43
	.byte	126
	.byte	104
	.byte	68
	.byte	0
	.byte	2
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2048
	.short	505
	.byte	2
	.byte	49
	.byte	60
	.byte	36
	.byte	3
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	-108
	.byte	122
	.byte	84
	.byte	67
	.byte	0
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	409
	.byte	2
	.byte	0
	.byte	40
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-34
	.byte	-43
	.byte	122
	.byte	88
	.byte	67
	.byte	0
	.byte	2
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	441
	.byte	2
	.byte	0
	.byte	40
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-43
	.byte	-108
	.byte	118
	.byte	84
	.byte	67
	.byte	0
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	1038
	.short	281
	.byte	2
	.byte	0
	.byte	24
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	20
	.byte	118
	.byte	84
	.byte	-62
	.byte	0
	.byte	1
	.byte	16
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	1169
	.byte	2
	.byte	0
	.byte	24
	.byte	40
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.space	4
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",%nobits
	.align	1
.LANCHOR68 = . + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.space	2
	.section	.bss.g_totle_map_block,"aw",%nobits
	.align	1
.LANCHOR123 = . + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.space	2
	.section	.bss.DeviceCapacity,"aw",%nobits
	.align	2
.LANCHOR76 = . + 0
	.type	DeviceCapacity, %object
	.size	DeviceCapacity, 4
DeviceCapacity:
	.space	4
	.section	.bss.gp_ect_tbl_info,"aw",%nobits
	.align	2
.LANCHOR187 = . + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
.LANCHOR79 = . + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.p_l2p_map_buf,"aw",%nobits
	.align	2
.LANCHOR121 = . + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 4
p_l2p_map_buf:
	.space	4
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
.LANCHOR141 = . + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
.LANCHOR109 = . + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.space	48
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
.LANCHOR151 = . + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.hidden	free
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
