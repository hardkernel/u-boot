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
	@ args = 8, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #32
	ldr	r4, [sp, #68]
	ldr	r6, [sp, #64]
	cbnz	r4, .L351
	adds	r7, r6, #0
	it	ne
	movne	r7, #1
	b	.L340
.L351:
	movs	r7, #1
.L340:
	ldr	r5, .L354
	mov	r8, #16
	ldr	r4, [r5, r0, lsl #3]
	add	r0, r5, r0, lsl #3
	ldrb	ip, [r0, #4]	@ zero_extendqisi2
	movs	r0, #0
	ldr	r5, [r4, #12]
	bfi	r5, r8, #8, #8
	bfi	r5, r0, #3, #1
	bfi	r0, r1, #1, #1
	bfi	r5, ip, #5, #3
	orr	r0, r0, #8
	mov	ip, #1
	bfi	r0, ip, #5, #2
	lsr	r3, r3, ip
	orr	r0, r0, #536870912
	orr	r0, r0, #1024
	bfi	r0, r3, #4, #1
	ldr	r3, .L354+4
	ldr	r3, [r3, #0]
	cmp	r3, #3
	bls	.L341
	ldr	r3, [r4, #16]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	bfc	r3, #2, #1
	str	r3, [sp, #28]
	cmp	r7, #0
	beq	.L342
	cmp	r1, #0
	beq	.L343
	ldr	r3, .L354+8
	str	r1, [sp, #8]
	str	r2, [sp, #4]
	ldr	r3, [r3, #0]
	cmp	r3, #24
	ite	hi
	movhi	r3, #128
	movls	r3, #64
	str	r3, [sp, #16]
	lsr	r3, r2, ip
	str	r3, [sp, #20]
	ldr	r3, .L354+12
	ldr	ip, [sp, #68]
	ldr	r3, [r3, #4]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r7, r3
	b	.L345
.L348:
	ldr	r1, [sp, #68]
	lsr	fp, r3, #2
	cbz	r1, .L346
	ldrh	sl, [ip, #2]
	ldr	r2, [sp, #12]
	ldrh	r8, [ip], #4
	orr	r8, r8, sl, lsl #16
	str	r8, [r2, fp, lsl #2]
	b	.L347
.L346:
	ldr	r2, [sp, #12]
	mov	r1, #-1
	str	r1, [r2, fp, lsl #2]
.L347:
	ldr	r1, [sp, #16]
	adds	r7, r7, #1
	adds	r3, r3, r1
.L345:
	ldr	r2, [sp, #20]
	cmp	r7, r2
	bcc	.L348
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #4]
.L343:
	adds	r2, r2, #1
	ldr	r3, .L354+12
	asrs	r2, r2, #1
	bfi	r0, r2, #22, #6
	cbnz	r6, .L353
	ldr	r2, [r3, #0]
	b	.L349
.L353:
	mov	r2, r6
.L349:
	ldr	r7, [r3, #4]
	mov	ip, #1
	str	r2, [r3, #8]
	str	ip, [r3, #24]
	str	r2, [r3, #16]
	str	r7, [r3, #20]
	str	r7, [r3, #12]
	movs	r3, #0
	str	r2, [r4, #20]
	movs	r2, #16
	str	r7, [r4, #24]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	bfi	r3, r2, #9, #5
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	orr	r3, r3, #448
	str	r3, [sp, #28]
	lsls	r3, r6, #30
	bne	.L350
	ldr	r3, [sp, #28]
	movs	r2, #2
	bfi	r3, r2, #3, #3
	str	r3, [sp, #28]
.L350:
	ldr	r3, [sp, #28]
	rsbs	r1, r1, #1
	it	cc
	movcc	r1, #0
	orr	r3, r3, #4
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	bfi	r3, r1, #1, #1
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	orr	r3, r3, #1
	str	r3, [sp, #28]
.L342:
	ldr	r3, [sp, #28]
	str	r3, [r4, #16]
.L341:
	str	r5, [r4, #12]
	str	r0, [r4, #8]
	orr	r0, r0, #4
	str	r0, [r4, #8]
	add	sp, sp, #32
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
	ldr	r3, .L372
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, [r3, r0, lsl #3]
	ldr	r3, .L372+4
	ldr	r3, [r3, #0]
	cmp	r3, #3
	bls	.L368
	ldr	r2, [r4, #16]
	lsls	r0, r2, #29
	bpl	.L368
	ldr	r2, [r4, #16]
	lsls	r1, r2, #30
	bpl	.L364
	ldr	r2, [r4, #8]
	str	r2, [sp, #0]
	b	.L371
.L362:
	cmp	r3, #5
	bls	.L371
	ldr	r2, [r4, #0]
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	lsls	r2, r2, #18
	bpl	.L371
	ldr	r2, [sp, #4]
	lsls	r0, r2, #14
	bmi	.L361
.L371:
	ldr	r1, [r4, #28]
	ldr	r2, [sp, #0]
	ubfx	r1, r1, #16, #5
	ubfx	r2, r2, #22, #6
	cmp	r1, r2
	blt	.L362
	b	.L361
.L364:
	ldr	r3, [r4, #8]
	str	r3, [sp, #0]
	ldr	r3, [sp, #0]
	lsls	r1, r3, #11
	bpl	.L364
	ldr	r5, .L372+8
	ldr	r3, [r5, #0]
	cbz	r3, .L365
	mov	r0, r4
	bl	NandcSendDumpDataStart
.L365:
	ldr	r3, [r5, #0]
	cbz	r3, .L361
	mov	r0, r4
	bl	NandcSendDumpDataDone
.L361:
	ldr	r3, .L372+12
	movs	r2, #0
	str	r2, [r3, #24]
	b	.L356
.L368:
	ldr	r3, [r4, #8]
	str	r3, [sp, #0]
	ldr	r3, [sp, #0]
	lsls	r2, r3, #11
	bpl	.L368
.L356:
	pop	{r1, r2, r3, r4, r5, pc}
.L373:
	.align	2
.L372:
	.word	.LANCHOR5
	.word	.LANCHOR37
	.word	.LANCHOR39
	.word	.LANCHOR38
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
	bne	.L375
	cbz	r3, .L376
	mov	r0, r2
	mov	r1, r3
	mov	r2, #1024
	bl	memcpy
.L376:
	cbz	r5, .L374
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
.L375:
	cbz	r3, .L378
	mov	r1, r2
	mov	r0, r3
	mov	r2, #1024
	bl	memcpy
.L378:
	cbz	r5, .L374
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
.L374:
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
	ldr	r3, .L417
	mov	r6, r0
	str	r1, [sp, #12]
	lsls	r1, r4, #26
	mov	sl, r2
	ldr	r5, [sp, #120]
	ldr	r8, [r3, r0, lsl #3]
	bne	.L380
	cbnz	r5, .L381
	add	r0, sp, #20
	movs	r1, #255
	movs	r2, #64
	add	r5, sp, #20
	bl	memset
.L381:
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
	bne	.L404
	ldr	r3, .L417+4
	lsr	r0, sl, #1
	ldr	r1, .L417+8
	ldr	r4, [r3, #0]
	ldr	r3, [sp, #12]
	cmp	r4, #24
	ite	hi
	movhi	r4, #128
	movls	r4, #64
	mov	r2, r3
	b	.L384
.L385:
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
.L384:
	cmp	r2, r0
	add	r6, r3, r4
	bcc	.L385
	ldr	r3, .L417+4
	lsr	sl, sl, #2
	ldr	r0, [r3, #0]
	ldr	r3, .L417+12
	ldr	r1, [r3, #0]
	movs	r3, #0
	mov	r4, r3
	b	.L386
.L392:
	add	r2, r3, #8
	ldr	r2, [r8, r2, lsl #2]
	str	r2, [sp, #84]
	ldr	r2, [sp, #84]
	lsls	r2, r2, #29
	bmi	.L407
	ldr	r2, [sp, #84]
	ands	r2, r2, #32768
	bne	.L407
	cmp	r1, #5
	bls	.L388
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
	bls	.L389
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #3, #5
	ubfx	r2, r2, #27, #1
	b	.L416
.L389:
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #16, #5
	ubfx	r2, r2, #29, #1
	b	.L416
.L388:
	cmp	r1, #3
	bls	.L390
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
	bls	.L391
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #3, #5
	ubfx	r2, r2, #28, #1
	b	.L416
.L391:
	ldr	r2, [sp, #84]
	ubfx	r5, r5, #16, #5
	ubfx	r2, r2, #30, #1
.L416:
	orr	r2, r5, r2, lsl #5
.L390:
	cmp	r4, r2
	it	cc
	movcc	r4, r2
	b	.L387
.L407:
	mov	r4, #-1
.L387:
	adds	r3, r3, #1
.L386:
	cmp	r3, sl
	bcs	.L382
	cmp	r0, #0
	bne	.L392
	b	.L382
.L404:
	movs	r4, #0
.L382:
	movs	r3, #0
	str	r3, [r8, #16]
	b	.L393
.L380:
	ldr	r3, [sp, #12]
	mov	r7, #0
	cmp	r3, #1
	bne	.L414
	b	.L394
.L397:
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
.L394:
	cmp	r7, sl
	bcc	.L397
	movs	r4, #0
	b	.L393
.L414:
	mov	r1, r7
	movs	r2, #2
	mov	r3, r7
	str	r7, [sp, #0]
	str	r7, [sp, #4]
	mov	r4, r7
	bl	NandcXferStart
	b	.L398
.L402:
	mov	r0, r6
	bl	NandcXferComp
	ldr	r3, [r8, #32]
	add	ip, r7, #2
	cmp	ip, sl
	str	r3, [sp, #84]
	bcs	.L399
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
.L399:
	ldr	r3, [sp, #84]
	lsls	r3, r3, #29
	bmi	.L411
	ldr	r2, [sp, #84]
	ldr	r3, [sp, #84]
	ubfx	r2, r2, #3, #5
	ubfx	r3, r3, #27, #1
	orr	r3, r2, r3, lsl #5
	cmp	r4, r3
	it	cc
	movcc	r4, r3
	b	.L400
.L411:
	mov	r4, #-1
.L400:
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
.L398:
	cmp	r7, sl
	bcc	.L402
.L393:
	ldr	r3, .L417+12
	ldr	r3, [r3, #0]
	cmp	r3, #5
	bls	.L403
	ldr	r3, [sp, #12]
	cbnz	r3, .L403
	ldr	r3, [r8, #0]
	and	r2, r3, #139264
	cmp	r2, #139264
	bne	.L403
	mov	r4, #-1
	orr	r3, r3, #131072
	str	r3, [r8, #0]
.L403:
	mov	r0, r4
	add	sp, sp, #88
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L418:
	.align	2
.L417:
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
	ldr	r3, .L422
	mov	r5, r1
	mov	r6, r2
	mov	r4, r0
	ldrb	r7, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L420
	ldr	r3, .L422+4
	ldr	r2, .L422+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	muls	r3, r2, r3
	cmp	r1, r3
	bcs	.L420
	ldr	r3, .L422+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L421
	subs	r7, r7, #2
	b	.L420
.L421:
	movs	r7, #4
.L420:
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
.L423:
	.align	2
.L422:
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
	ldr	r3, .L432
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r2
	ldr	r2, .L432+4
	mov	r8, r0
	ldr	r3, [r3, #0]
	mov	r7, r1
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cbz	r2, .L425
	ldr	r2, .L432+8
	ldr	r1, [r2, #0]
	ldr	r2, .L432+12
	cmp	r1, r2
	beq	.L424
.L425:
	subs	r2, r3, #5
	cmp	r2, #2
	bls	.L429
	cmp	r3, #68
	beq	.L429
	cmp	r3, #35
	beq	.L429
	cmp	r3, #19
	bne	.L424
	b	.L429
.L430:
	ldrh	r3, [sl, r4, lsl #1]
	cmp	r3, fp
	bne	.L424
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
	b	.L431
.L429:
	ldr	r6, .L432
	movw	fp, #65535
	ldr	sl, .L432+20
	ldr	r5, .L432+16
.L431:
	ldr	r3, [r6, #0]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L430
.L424:
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L433:
	.align	2
.L432:
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
	ldr	r3, .L437
	mov	r6, r1
	mov	r5, r2
	mov	r4, r0
	ldrb	r7, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L435
	ldr	r3, .L437+4
	ldr	r2, .L437+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	muls	r3, r2, r3
	cmp	r1, r3
	it	cc
	movcc	r7, #4
.L435:
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
.L438:
	.align	2
.L437:
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
	ldr	r2, .L454
	mov	r7, r3
	mov	r6, r0
	str	r1, [sp, #4]
	adds	r3, r2, r0
	mov	r8, #0
	ldrb	fp, [r2, #2]	@ zero_extendqisi2
	mov	r5, #-1
	ldr	r2, .L454+4
	ldrb	r4, [r3, #12]	@ zero_extendqisi2
	ldr	r2, [r2, #0]
	ldrb	r2, [r2, #19]	@ zero_extendqisi2
	cmp	r2, #7
	it	eq
	ldrbeq	r4, [r3, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
	b	.L441
.L446:
	adds	r4, r4, #1
	ldr	r2, .L454
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
	beq	.L443
	ldr	r2, .L454+8
	cmp	r5, #-1
	it	eq
	moveq	r5, r0
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, lsr #2
	bcc	.L452
	movs	r7, #0
	mov	sl, r7
.L443:
	add	r8, r8, #1
.L441:
	cmp	r8, fp
	bcc	.L446
	b	.L445
.L452:
	mov	r5, r0
.L445:
	ldr	r3, .L454+4
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #7
	ldr	r3, .L454
	add	r6, r3, r6
	ldr	r3, .L454+8
	it	eq
	strbeq	r4, [r6, #20]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	it	ne
	strbne	r4, [r6, #12]
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bcc	.L449
	cmp	r5, #-1
	ite	eq
	moveq	r5, #-1
	movne	r5, #256
.L449:
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L455:
	.align	2
.L454:
	.word	.LANCHOR31
	.word	.LANCHOR23
	.word	.LANCHOR29
	.size	HynixReadRetrial, .-HynixReadRetrial
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
	sub	sp, sp, #24
	mov	fp, r3
	ldr	r3, .L470
	str	r2, [sp, #20]
	mov	sl, r0
	ldr	r2, .L470+4
	str	r1, [sp, #16]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbnz	r2, .L457
	add	r3, r3, r3, lsl #1
	ubfx	r3, r3, #2, #8
	b	.L469
.L457:
	lsrs	r3, r3, #2
.L469:
	mov	r0, sl
	str	r3, [sp, #12]
	bl	NandcWaitFlashReady
	ldr	r3, .L470+8
	mov	r8, #0
	mov	r4, #-1
	ldr	r6, [r3, sl, lsl #3]
	add	r3, r3, sl, lsl #3
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	adds	r7, r7, #8
	lsls	r7, r7, #8
	adds	r5, r6, r7
	b	.L459
.L463:
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
	beq	.L460
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L467
	mov	fp, #0
	str	fp, [sp, #20]
.L460:
	mov	r8, ip
.L459:
	ldr	r2, .L470+12
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	cmp	r8, r3
	bcc	.L463
	b	.L462
.L467:
	mov	r4, r0
.L462:
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
	bcc	.L464
	ldr	r0, .L470+16
	mov	r1, r8
	ldr	r2, [sp, #16]
	mov	r3, r8
	cmp	r4, #-1
	ite	eq
	moveq	r4, #-1
	movne	r4, #256
	str	r4, [sp, #0]
	bl	printf
.L464:
	mov	r0, r4
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L471:
	.align	2
.L470:
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
	ldr	r3, .L482
	movs	r5, #1
	mov	r4, #-1
	ldr	r2, [r3, r7, lsl #3]
	add	r3, r3, r7, lsl #3
	ldrb	sl, [r3, #4]	@ zero_extendqisi2
	add	sl, sl, #8
	add	sl, r2, sl, lsl #8
	b	.L473
.L477:
	mov	r0, sl
	uxtb	r1, r5
	bl	SamsungSetRRPara
	mov	r1, fp
	mov	r0, r7
	mov	r2, r8
	mov	r3, r6
	bl	FlashReadRawPage
	adds	r1, r0, #1
	beq	.L474
	ldr	r2, .L482+4
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, lsr #2
	bcc	.L480
	movs	r6, #0
	mov	r8, r6
.L474:
	adds	r5, r5, #1
.L473:
	ldr	r2, .L482+8
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r3
	bcc	.L477
	b	.L476
.L480:
	mov	r4, r0
.L476:
	movs	r1, #0
	mov	r0, sl
	bl	SamsungSetRRPara
	ldr	r3, .L482+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcc	.L478
	cmp	r4, #-1
	ite	eq
	moveq	r4, #-1
	movne	r4, #256
.L478:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L483:
	.align	2
.L482:
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
	ldr	r3, .L506
	ldr	r2, [r3, r7, lsl #3]
	add	r3, r3, r7, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L506+4
	adds	r4, r4, #8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r4, r2, r4, lsl #8
	subs	r3, r3, #67
	cmp	r3, #1
	bls	.L501
	ldr	r3, .L506+8
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L502
	movs	r0, #0
	mov	sl, #1
	bl	NandcSetDdrMode
	b	.L486
.L502:
	mov	sl, r3
.L486:
	movs	r3, #92
	str	r3, [r4, #8]
	movs	r3, #197
	str	r3, [r4, #8]
	b	.L485
.L501:
	mov	sl, #0
.L485:
	movs	r6, #1
	mov	r5, #-1
	b	.L487
.L496:
	ldr	r1, .L506+4
	mov	r0, r4
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	uxtb	r1, r6
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L488
	bl	SandiskSetRRPara
	b	.L489
.L488:
	bl	ToshibaSetRRPara
.L489:
	ldr	r2, .L506+4
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L490
	ldr	r1, .L506+12
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r6, r3
	bne	.L490
	movs	r2, #179
	str	r2, [r4, #8]
.L490:
	movs	r3, #38
	str	r3, [r4, #8]
	movs	r3, #93
	str	r3, [r4, #8]
	cmp	sl, #0
	beq	.L491
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
	b	.L492
.L491:
	mov	r3, r8
	mov	r0, r7
	ldr	r1, [sp, #4]
	mov	r2, fp
	bl	FlashReadRawPage
	mov	r3, r0
.L492:
	adds	r0, r3, #1
	beq	.L493
	ldr	r1, .L506+16
	cmp	r5, #-1
	it	eq
	moveq	r5, r3
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r3, r2, lsr #2
	bcc	.L504
	mov	r8, #0
	mov	fp, r8
.L493:
	adds	r6, r6, #1
.L487:
	ldr	r2, .L506+12
	ldrb	r3, [r2, #0]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L496
	b	.L495
.L504:
	mov	r5, r3
.L495:
	ldr	r3, .L506+4
	movs	r1, #0
	mov	r0, r4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L497
	bl	SandiskSetRRPara
	b	.L498
.L497:
	bl	ToshibaSetRRPara
.L498:
	movs	r3, #255
	str	r3, [r4, #8]
	ldr	r3, .L506+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bcc	.L499
	cmp	r5, #-1
	ite	eq
	moveq	r5, #-1
	movne	r5, #256
.L499:
	mov	r0, r7
	bl	NandcWaitFlashReady
	cmp	sl, #0
	beq	.L500
	movs	r0, #4
	bl	NandcSetDdrMode
.L500:
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L507:
	.align	2
.L506:
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
	ldr	r7, .L515
	ldr	r8, .L515+60
	ldr	sl, .L515+64
	ldr	r3, [r7, #0]
	ldr	fp, .L515+48
	ldr	r6, .L515+4
	str	r3, [r8, #0]
	ldr	r3, .L515+8
	ldrb	r0, [r3, #0]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r1, #0
	mov	r2, #2048
	ldr	r0, [r7, #0]
	bl	memset
	ldr	r0, [r8, #0]
	ldr	r3, .L515+12
	movs	r2, #32
	ldr	r1, .L515+16
	str	sl, [r0, #0]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	strh	r3, [r0, #12]	@ movhi
	ldr	r3, .L515+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	strh	r3, [r0, #14]	@ movhi
	ldr	r3, .L515+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	str	r3, [r0, #1076]
	adds	r0, r0, #16
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L515+28
	movs	r2, #8
	adds	r0, r0, #80
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L515+32
	movs	r2, #32
	adds	r0, r0, #96
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L515+36
	movs	r2, #32
	adds	r0, r0, #160
	bl	memcpy
	ldr	r0, [r8, #0]
	ldr	r1, .L515+40
	movs	r2, #32
	adds	r0, r0, #192
	bl	memcpy
	ldr	r0, [r8, #0]
	mov	r2, #852
	ldr	r1, .L515+44
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
.L511:
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
	ldr	r3, .L515+48
	movs	r0, #0
	ldr	r1, [r6, #0]
	muls	r1, r4, r1
	ldr	r2, [r3, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L509
	ldr	fp, [r8, #0]
	ldr	r3, [fp, #0]
	cmp	r3, sl
	bne	.L509
	add	r0, fp, #12
	movw	r1, #2036
	bl	JSHash
	ldr	r3, [fp, #8]
	cmp	r3, r0
	bne	.L509
	ldr	r3, .L515+52
	adds	r2, r4, #1
	adds	r5, r5, #1
	str	r2, [r3, #0]
	ldr	r3, .L515+56
	ldr	r2, [r6, #0]
	muls	r2, r4, r2
	cmp	r5, #1
	str	r2, [r3, #0]
	bhi	.L510
.L509:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L511
.L510:
	movs	r0, #0
	bl	flash_exit_slc_mode
	cmp	r5, #0
	ite	eq
	moveq	r0, #-1
	movne	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L516:
	.align	2
.L515:
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
	ldr	r1, .L528
	add	r0, sp, #12
	bl	memcpy
	ldr	r3, .L528+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	str	r3, [sp, #4]
	ldr	r3, .L528+8
	ldr	r2, [r3, #0]
	ldr	r3, .L528+12
	cmp	r2, r3
	bne	.L518
	movs	r0, #0
	bl	flash_enter_slc_mode
.L518:
	mov	r0, r8
	movs	r1, #0
	mov	r2, #2048
	mov	r7, #-1
	bl	memset
	movs	r4, #2
	ldr	sl, .L528+32
	ldr	fp, .L528+36
	ldr	r6, .L528+16
	b	.L519
.L526:
	movs	r5, #0
.L521:
	add	r3, sp, #12
	ldrb	r0, [r3, r5]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r3, .L528+16
	movs	r0, #0
	ldr	r1, [fp, #0]
	muls	r1, r4, r1
	ldr	r2, [r3, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L520
	adds	r5, r5, #1
	cmp	r5, #4
	bne	.L521
	b	.L522
.L520:
	ldr	r3, [r6, #0]
	ldr	r2, [r3, #0]
	ldr	r3, .L528+20
	cmp	r2, r3
	bne	.L522
	add	r3, sp, #16
	ldr	r0, .L528+24
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
	ldr	r3, .L528+28
	ldr	r2, [r3, #0]
	cmp	r2, r4
	bls	.L525
	str	r4, [r3, #0]
	movs	r7, #0
	bl	FlashSavePhyInfo
.L522:
	adds	r4, r4, #1
.L519:
	ldrb	r3, [sl, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L526
	b	.L523
.L525:
	movs	r7, #0
.L523:
	ldr	r0, [sp, #4]
	bl	FlashBchSel
	ldr	r3, .L528+8
	ldr	r2, [r3, #0]
	ldr	r3, .L528+12
	cmp	r2, r3
	bne	.L524
	movs	r0, #0
	bl	flash_exit_slc_mode
.L524:
	mov	r0, r7
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L529:
	.align	2
.L528:
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
	ldr	sl, .L542+40
	add	r0, sp, #12
	ldr	r1, .L542
	movs	r4, #0
	bl	memcpy
	ldr	r5, .L542+4
	ldr	r3, [sl, #0]
	mov	r0, r4
	ldr	r6, .L542+8
	mov	r8, #4
	mov	r7, #-1
	str	r3, [r5, #0]
	ldr	r3, .L542+12
	ldrh	r2, [r6, #10]
	str	r4, [r3, #0]
	str	r2, [sp, #4]
	bl	flash_enter_slc_mode
	b	.L531
.L533:
	add	r3, sp, #12
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
	mov	r1, r4
	ldr	r2, [sl, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L532
	movs	r0, #0
	mov	r1, fp
	ldr	r2, [sl, #0]
	mov	r3, r0
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L532
	adds	r6, r6, #1
	cmp	r6, #4
	beq	.L534
	b	.L533
.L532:
	ldr	r6, [r5, #0]
	ldr	r2, .L542+16
	ldr	r3, [r6, #0]
	cmp	r3, r2
	bne	.L534
	cbnz	r7, .L535
	ldr	r3, .L542+8
	mov	r0, r4
	ldrh	r1, [r3, #10]
	bl	__aeabi_uidiv
	ldr	r3, .L542+20
	adds	r0, r0, #1
	str	r0, [r3, #0]
	mov	r0, r7
	b	.L541
.L535:
	add	r0, r6, #12
	movw	r1, #2036
	bl	JSHash
	ldr	r3, [r6, #8]
	cmp	r3, r0
	bne	.L534
	add	r1, r6, #160
	movs	r2, #32
	ldr	r0, .L542+8
	bl	memcpy
	ldr	r1, [r5, #0]
	movs	r2, #32
	ldr	r0, .L542+24
	adds	r1, r1, #192
	bl	memcpy
	ldr	r1, [r5, #0]
	mov	r2, #852
	ldr	r0, .L542+28
	adds	r1, r1, #224
	bl	memcpy
	ldr	r6, [r5, #0]
	ldr	r3, .L542+32
	mov	r0, r4
	ldr	r2, [r6, #1076]
	strb	r2, [r3, #0]
	ldr	r3, .L542+12
	str	r4, [r3, #0]
	ldr	r3, .L542+8
	ldrh	r1, [r3, #10]
	bl	__aeabi_uidiv
	ldr	r3, .L542+20
	adds	r0, r0, #1
	str	r0, [r3, #0]
	cmp	r0, #1
	bne	.L537
	movs	r2, #2
	str	r2, [r3, #0]
.L537:
	ldrh	r2, [r6, #14]
	movs	r7, #0
	ldr	r3, .L542+36
	strb	r2, [r3, #0]
.L534:
	ldr	r2, [sp, #4]
	subs	r8, r8, #1
	add	r4, r4, r2
	beq	.L538
.L531:
	add	fp, r4, #1
	movs	r6, #0
	b	.L533
.L538:
	mov	r0, r8
.L541:
	bl	flash_exit_slc_mode
	mov	r0, r7
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L543:
	.align	2
.L542:
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
	ldr	r3, .L564
	sub	sp, sp, #24
	mov	fp, r2
	str	r0, [sp, #8]
	ldr	r3, [r3, #0]
	str	r1, [sp, #12]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L564+4
	ldr	r7, [r3, #0]
	ldr	r3, [sp, #56]
	cmp	r7, #7
	ite	hi
	movhi	r7, #12
	movls	r7, #6
	cbz	r3, .L556
	movs	r0, #1
	ldr	r4, .L564+8
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
	beq	.L547
	mov	r2, r8
	ldr	r0, .L564+12
	ldr	r1, [sp, #12]
	bl	printf
	ldr	r3, .L564+16
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	cmp	r2, #2048
	bcc	.L547
	movs	r2, #0
	str	r2, [r3, #0]
	mov	sl, r2
	mov	fp, r2
	b	.L546
.L556:
	mov	r8, #1024
.L546:
	movs	r4, #0
	mov	r6, #-1
	mov	ip, r4
	mov	r5, r4
	str	r4, [sp, #16]
.L552:
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
	bhi	.L548
	cmp	r0, #2
	bhi	.L558
	adds	r5, r5, #1
	cmp	r5, #9
	bls	.L558
	subs	r4, r7, r5
	mov	r8, r0
	movs	r6, #0
	b	.L550
.L548:
	cmp	ip, r5
	bcs	.L559
	cmp	r5, #7
	rsb	r3, r5, r4
	str	r3, [sp, #16]
	bhi	.L551
	mov	ip, r5
	b	.L559
.L558:
	movs	r6, #0
	mov	r4, r7
	mov	r8, r0
	mov	sl, r6
	mov	fp, r6
	b	.L549
.L559:
	movs	r5, #0
.L549:
	adds	r7, r7, #2
	cmp	r7, #69
	bls	.L552
.L550:
	cmp	ip, r5
	bcc	.L553
.L551:
	ldr	r4, [sp, #16]
.L553:
	cbz	r4, .L554
	ldr	r0, .L564+20
	mov	r1, r4
	bl	printf
	uxtb	r0, r4
	bl	NandcSetDdrPara
.L554:
	cbz	r6, .L547
	ldr	r0, .L564+24
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #12]
	bl	printf
	ldr	r3, [sp, #56]
	cbz	r3, .L561
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L547
.L561:
	mov	r8, r6
.L547:
	mov	r0, r8
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L565:
	.align	2
.L564:
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
	ldr	r5, .L571
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
	beq	.L567
	cmp	r8, #-1
	bne	.L568
.L567:
	ldrb	r3, [r5, #0]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L568
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r2, #0
	b	.L570
.L568:
	movs	r2, #1
.L570:
	ldr	r3, .L571+4
	movs	r0, #0
	strb	r2, [r3, #0]
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L572:
	.align	2
.L571:
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
	bne	.L574
	ldr	r6, .L579
	ldrb	fp, [r6, #0]	@ zero_extendqisi2
	cmp	fp, #0
	beq	.L575
	movs	r3, #0
	mov	r0, r5
	strb	r3, [r6, #0]
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	bl	FlashReadRawPage
	strb	fp, [r6, #0]
	adds	r6, r0, #1
	bne	.L578
.L575:
	ldr	r3, .L579+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L574
	ldr	r3, .L579+8
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
	beq	.L576
	ldr	r3, .L579+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r4, r3, lsr #1
	bls	.L574
.L576:
	ubfx	r0, r6, #8, #8
	bl	NandcSetDdrPara
	b	.L574
.L578:
	mov	r4, r0
.L574:
	ldr	fp, .L579+24
	ldr	r6, [fp, #0]
	cbz	r6, .L577
	adds	r1, r4, #1
	bne	.L577
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	mov	r0, r5
	blx	r6
	mov	r2, r5
	mov	r3, r7
	mov	r4, r0
	ldr	r0, .L579+16
	mov	r1, r4
	bl	printf
	adds	r2, r4, #1
	bne	.L577
	ldr	r3, .L579+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L577
	mov	r0, r5
	bl	flash_enter_slc_mode
	ldr	r4, [fp, #0]
	mov	r0, r5
	mov	r1, r7
	mov	r2, r8
	mov	r3, sl
	blx	r4
	mov	r4, r0
.L577:
	mov	r0, r4
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L580:
	.align	2
.L579:
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
	b	.L582
.L583:
	adds	r3, r3, #1
	lsls	r2, r2, #1
	uxth	r3, r3
.L582:
	cmp	r2, r0
	bls	.L583
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
	ldr	r3, .L588
	cmp	r0, #23
	it	ls
	movls	r0, #24
	ldr	r2, .L588+4
	str	r0, [r3, #0]
	ldr	r3, .L588+8
	ldrh	r3, [r3, #0]
	muls	r3, r0, r3
	str	r3, [r2, #0]
	ldr	r2, .L588+12
	ldrh	r2, [r2, #0]
	subs	r0, r2, r0
	ldr	r2, .L588+16
	strh	r0, [r2, #0]	@ movhi
	movs	r0, #0
	ldr	r2, .L588+20
	ldr	r2, [r2, #0]
	subs	r3, r2, r3
	ldr	r2, .L588+24
	str	r3, [r2, #0]
	bx	lr
.L589:
	.align	2
.L588:
	.word	.LANCHOR52
	.word	.LANCHOR54
	.word	.LANCHOR53
	.word	.LANCHOR56
	.word	.LANCHOR55
	.word	.LANCHOR58
	.word	.LANCHOR57
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.global	__aeabi_idiv
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
	ldr	r3, .L605
	ldrh	r1, [r0, #10]
	ldrh	r0, [r0, #12]
	strh	r7, [r3, #0]	@ movhi
	ldr	r3, .L605+4
	ldrh	ip, [r4, #14]
	ldr	r2, .L605+8
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L605+12
	strh	r0, [r3, #0]	@ movhi
	ldr	r3, .L605+16
	strh	ip, [r3, #0]	@ movhi
	movs	r3, #0
.L591:
	strb	r3, [r3, r2]
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L591
	ldrh	r2, [r4, #14]
	ldrh	r3, [r4, #20]
	cmp	r3, r2, lsr #8
	bcs	.L592
	ldr	r3, .L605+8
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
	b	.L593
.L594:
	ldr	r2, [sp, #12]
	add	fp, r6, r5
	add	lr, lr, #1
	strb	fp, [r2, r3]
	ldr	r2, [sp, #20]
	add	fp, r6, r2
	ldr	r2, [sp, #16]
	strb	fp, [r2, r3]
	b	.L595
.L603:
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
.L595:
	add	r6, r6, r8
	cmp	lr, r1
	add	r3, r3, r0
	uxtb	r6, r6
	bcc	.L594
	ldr	r2, [sp, #4]
	adds	r5, r5, #1
	adds	r2, r2, #1
	uxtb	r5, r5
.L593:
	cmp	r2, r0
	bcc	.L603
	ldr	r3, .L605+4
	lsls	r1, r1, #1
	lsr	ip, ip, #1
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L605+16
	strh	ip, [r3, #0]	@ movhi
.L592:
	ldr	r3, .L605+20
	movs	r2, #5
	movs	r1, #0
	cmp	r7, #1
	strh	r2, [r3, #0]	@ movhi
	ldr	r2, .L605+24
	it	eq
	strheq	r7, [r3, #0]	@ movhi
	ldr	r3, .L605+28
	strh	r1, [r2, #0]	@ movhi
	mov	r2, #4352
	strh	r2, [r3, #0]	@ movhi
	ldr	r2, .L605+32
	ldrb	r8, [r2, #0]	@ zero_extendqisi2
	cmp	r8, #0
	beq	.L597
	mov	r2, #384
	strh	r2, [r3, #0]	@ movhi
.L597:
	ldr	r3, .L605+4
	ldrh	r5, [r3, #0]
	muls	r5, r0, r5
	ldr	r3, .L605+36
	uxth	r5, r5
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L605+16
	ldrh	r6, [r3, #0]
	muls	r0, r6, r0
	ldr	r3, .L605+40
	uxth	r0, r0
	strh	r0, [r3, #0]	@ movhi
	bl	Ftl_log2
	ldr	r3, .L605+44
	ldrh	fp, [r4, #16]
	ldrh	r1, [r4, #18]
	ldrh	sl, [r4, #20]
	mul	r2, fp, r5
	strh	r0, [r3, #0]	@ movhi
	mov	r0, sl
	ldr	r3, .L605+48
	strh	fp, [r3, #0]	@ movhi
	ldr	r3, .L605+52
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L605+56
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L605+60
	strh	sl, [r3, #0]	@ movhi
	str	r1, [sp, #8]
	bl	Ftl_log2
	ldr	r3, .L605+64
	ldr	r2, .L605+68
	ldr	r1, [sp, #8]
	mul	r1, r1, sl
	strh	r0, [r3, #0]	@ movhi
	lsl	r3, sl, #9
	mov	r7, r0
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L605+72
	lsrs	r3, r3, #8
	cmp	r6, #1024
	strh	r3, [r2, #0]	@ movhi
	ldrh	r2, [r4, #26]
	ldr	r3, .L605+76
	ldr	r4, .L605+28
	strh	r2, [r3, #0]	@ movhi
	mul	r2, r6, r5
	ldr	r3, .L605+80
	ldrh	r0, [r4, #0]
	str	r2, [r3, #0]
	it	hi
	uxtbhi	r2, r6
	ldr	r3, .L605+24
	it	hi
	strhhi	r2, [r3, #0]	@ movhi
	lsls	r0, r0, #3
	ldrh	r2, [r3, #0]
	ldr	r3, .L605+84
	subs	r2, r6, r2
	muls	r2, r5, r2
	mul	r2, sl, r2
	mul	fp, fp, r2
	asr	r2, fp, #11
	str	r2, [r3, #0]
	bl	__aeabi_idiv
	ldr	r3, .L605+88
	uxth	r0, r0
	strh	r0, [r3, #0]	@ movhi
	cmp	r0, #4
	bhi	.L599
	movs	r2, #4
	strh	r2, [r3, #0]	@ movhi
.L599:
	cmp	r8, #0
	beq	.L600
	mov	r3, #640
	strh	r3, [r4, #0]	@ movhi
.L600:
	ldrh	r2, [r4, #0]
	lsls	r6, r6, #6
	ldr	r3, .L605+92
	mov	r1, r5
	ldr	r4, .L605+96
	asr	r2, r2, r7
	adds	r7, r7, #9
	asr	r6, r6, r7
	adds	r2, r2, #2
	strh	r2, [r3, #0]	@ movhi
	uxth	r6, r6
	ldr	r3, .L605+100
	mul	r2, r5, r6
	strh	r6, [r3, #0]	@ movhi
	ldr	r3, .L605+104
	adds	r6, r6, #8
	str	r2, [r3, #0]
	ldr	r3, .L605+88
	ldrh	r0, [r3, #0]
	bl	__aeabi_uidiv
	cmp	r5, #1
	uxtah	r6, r6, r0
	str	r6, [r4, #0]
	bne	.L601
	adds	r6, r6, #4
	str	r6, [r4, #0]
.L601:
	ldrh	r0, [r4, #0]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4, #0]
	ldr	r3, .L605+108
	str	r2, [r3, #0]
	ldr	r3, .L605+112
	ldr	r2, [r3, #0]
	ldr	r3, .L605+48
	lsls	r2, r2, #2
	ldrh	r3, [r3, #0]
	muls	r2, r3, r2
	ldr	r3, .L605+64
	ldrh	r3, [r3, #0]
	adds	r3, r3, #9
	lsr	r2, r2, r3
	ldr	r3, .L605+116
	adds	r2, r2, #2
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #24
	ldr	r3, .L605+120
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #0
	ldr	r3, .L605+124
	str	r2, [r3, #0]
	ldr	r2, .L605+88
	ldrh	r0, [r2, #0]
	adds	r3, r0, #3
	strh	r3, [r2, #0]	@ movhi
	ldr	r3, .L605+104
	ldr	r1, [r3, #0]
	adds	r4, r1, #3
	str	r4, [r3, #0]
	ldr	r4, .L605+128
	ldrb	r4, [r4, #0]	@ zero_extendqisi2
	cbz	r4, .L602
	adds	r0, r0, #4
	adds	r1, r1, #5
	strh	r0, [r2, #0]	@ movhi
	str	r1, [r3, #0]
.L602:
	movs	r0, #0
	add	sp, sp, #32
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L606:
	.align	2
.L605:
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
	ldr	r3, .L614
	push	{r4, lr}
	ldrh	r3, [r3, #0]
	cbz	r3, .L612
	ldr	r3, .L614+4
	ldrh	r1, [r3, #0]
	ldr	r3, .L614+8
	ldr	r2, [r3, #0]
	movs	r3, #0
	b	.L609
.L611:
	ldrh	r4, [r2], #2
	cmp	r4, r0
	beq	.L613
	adds	r3, r3, #1
	uxth	r3, r3
.L609:
	cmp	r3, r1
	bne	.L611
	movs	r0, #0
	pop	{r4, pc}
.L613:
	movs	r0, #1
	pop	{r4, pc}
.L612:
	mov	r0, r3
	pop	{r4, pc}
.L615:
	.align	2
.L614:
	.word	.LANCHOR85
	.word	.LANCHOR77
	.word	.LANCHOR86
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
	ldr	r3, .L617
	ldr	r0, [r3, #0]
	bx	lr
.L618:
	.align	2
.L617:
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
	ldr	r3, .L620
	ldr	r0, [r3, #0]
	bx	lr
.L621:
	.align	2
.L620:
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
	ldr	r3, .L623
	ldr	r0, [r3, #0]
	bx	lr
.L624:
	.align	2
.L623:
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
	ldr	r3, .L626
	ldr	r0, [r3, #0]
	bx	lr
.L627:
	.align	2
.L626:
	.word	.LANCHOR87
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
	ldr	r2, .L629
	ldr	r3, .L629+4
	ldr	r0, [r2, #0]
	ldrh	r3, [r3, #0]
	muls	r0, r3, r0
	bx	lr
.L630:
	.align	2
.L629:
	.word	.LANCHOR88
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
	ldr	r2, .L632
	ldr	r3, .L632+4
	ldrh	r0, [r2, #0]
	ldrh	r3, [r3, #0]
	muls	r0, r3, r0
	bx	lr
.L633:
	.align	2
.L632:
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
	ldr	r3, .L635
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3, #0]
	movs	r7, #1
	mov	r1, r4
	bl	__aeabi_uidiv
	uxth	r2, r0
	mls	r3, r4, r2, r5
	ldr	r4, .L635+4
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
	ldr	r0, .L635+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
.L636:
	.align	2
.L635:
	.word	.LANCHOR66
	.word	.LANCHOR89
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
	ldr	r3, .L638
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3, #0]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L638+4
	lsrs	r2, r4, #5
	and	r4, r4, #31
	uxth	r0, r0
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsr	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L639:
	.align	2
.L638:
	.word	.LANCHOR66
	.word	.LANCHOR89
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
	ldr	r3, .L646
	push	{r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	ldrh	r2, [r3, #0]
	mov	r0, r1
	mov	r5, r1
	movs	r1, #0
	ldr	r7, .L646+4
	movs	r4, #0
	lsls	r2, r2, #2
	movw	r8, #65535
	bl	memset
.L644:
	ldrh	r3, [r6, r4]
	cmp	r3, r8
	beq	.L641
	ldrh	r2, [r7, #0]
	cmp	r2, r3
	bhi	.L643
	ldr	r1, .L646+8
	movs	r2, #79
	ldr	r0, .L646+12
	bl	printf
	ldr	r0, .L646+16
	ldr	r1, .L646+20
	bl	printf
.L643:
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
	bne	.L644
.L641:
	pop	{r4, r5, r6, r7, r8, pc}
.L647:
	.align	2
.L646:
	.word	.LANCHOR90
	.word	.LANCHOR66
	.word	.LANCHOR91
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
	ldr	r0, .L649
	movw	r3, #65535
	movs	r1, #255
	movs	r2, #16
	strh	r3, [r0, #0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	memset
.L650:
	.align	2
.L649:
	.word	.LANCHOR89
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
	ldr	r3, .L652
	mov	r6, r0
	ldrh	r4, [r3, #0]
	muls	r7, r4, r7
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, .L652+4
	mov	r1, r4
	ldrh	r5, [r3, #0]
	mla	r5, r0, r5, r7
	mov	r0, r6
	bl	__aeabi_uidivmod
	adds	r1, r5, r1
	uxth	r0, r1
	pop	{r3, r4, r5, r6, r7, pc}
.L653:
	.align	2
.L652:
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
	ldr	r3, .L655
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r3, #0]
	ldr	r3, .L655+4
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	mov	r1, r4
	mul	r5, r0, r4
	mov	r0, r6
	bl	__aeabi_uidivmod
	adds	r1, r5, r1
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L656:
	.align	2
.L655:
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
	ldr	r3, .L658
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidivmod
	ldr	r3, .L658+4
	uxth	r0, r1
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L659:
	.align	2
.L658:
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
	bls	.L661
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L661:
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
	ldr	r3, .L664
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
.L665:
	.align	2
.L664:
	.word	.LANCHOR92
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
	ldr	r3, .L667
	ldrh	r0, [r3, #6]
	rsbs	r0, r0, #1
	it	cc
	movcc	r0, #0
	bx	lr
.L668:
	.align	2
.L667:
	.word	.LANCHOR92
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
	ldr	r3, .L670
	ldrh	r0, [r3, #6]
	sub	r2, r0, #1024
	rsbs	r0, r2, #0
	adc	r0, r0, r2
	bx	lr
.L671:
	.align	2
.L670:
	.word	.LANCHOR92
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
	ldr	r3, .L675
	ldrh	r3, [r3, #6]
	cmp	r3, #1024
	beq	.L672
	cbz	r1, .L674
	bl	P2V_block_in_plane
	ldr	r3, .L675+4
	movs	r1, #1
	mov	r2, r1
	mov	r5, r0
	ldr	r0, [r3, #0]
	lsls	r3, r4, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L675+8
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L675+12
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
.L674:
	ldr	r3, .L675
	ldrh	r2, [r3, #6]
	adds	r2, r2, #1
	strh	r2, [r3, #6]	@ movhi
	ldrh	r2, [r3, #4]
	adds	r1, r2, #4
	adds	r2, r2, #1
	bic	r2, r2, #64512
	strh	r2, [r3, #4]	@ movhi
	strh	r4, [r3, r1, lsl #1]	@ movhi
.L672:
	pop	{r3, r4, r5, pc}
.L676:
	.align	2
.L675:
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
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
	ldr	r5, .L687
	ldr	r7, .L687+4
	ldr	r6, .L687+8
	b	.L678
.L679:
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
.L678:
	ldrh	ip, [r5, #6]
	ldrh	r8, [r5, #2]
	cmp	r4, ip
	bcc	.L679
	ldr	r3, .L687+4
	add	r6, ip, #-1
	ldr	r4, .L687
	ldr	r1, [r3, #0]
	movs	r3, #0
	b	.L680
.L685:
	adds	r5, r3, #1
	mov	r2, r3
	uxth	r5, r5
	mov	r0, r5
	b	.L681
.L683:
	ldr	r7, [r1, r0, lsl #2]
	ldr	sl, [r1, r2, lsl #2]
	cmp	sl, r7
	it	hi
	movhi	r2, r0
	adds	r0, r0, #1
	uxth	r0, r0
.L681:
	cmp	r0, ip
	bcc	.L683
	cmp	r3, r2
	beq	.L684
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
.L684:
	mov	r3, r5
.L680:
	cmp	r3, r6
	blt	.L685
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L688:
	.align	2
.L687:
	.word	.LANCHOR92
	.word	.LANCHOR96
	.word	.LANCHOR94
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.IsInFreeQueue,"ax",%progbits
	.align	1
	.global	IsInFreeQueue
	.thumb
	.thumb_func
	.type	IsInFreeQueue, %function
IsInFreeQueue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L695
	push	{r4, r5, lr}
	ldrh	r1, [r2, #6]
	cmp	r1, #1024
	beq	.L693
	ldrh	r4, [r2, #2]
	movs	r3, #0
	b	.L691
.L692:
	adds	r5, r3, r4
	lsls	r5, r5, #22
	add	r5, r2, r5, lsr #21
	ldrh	r5, [r5, #8]
	cmp	r5, r0
	beq	.L694
	adds	r3, r3, #1
.L691:
	cmp	r3, r1
	bcc	.L692
.L693:
	movs	r0, #0
	pop	{r4, r5, pc}
.L694:
	movs	r0, #1
	pop	{r4, r5, pc}
.L696:
	.align	2
.L695:
	.word	.LANCHOR92
	.size	IsInFreeQueue, .-IsInFreeQueue
	.section	.text.FtlFreeSysBlkQueueOut,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueOut
	.thumb
	.thumb_func
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r3, .L700
	ldrh	r1, [r3, #6]
	cbz	r1, .L699
	ldrh	r2, [r3, #2]
	subs	r1, r1, #1
	strh	r1, [r3, #6]	@ movhi
	adds	r0, r2, #4
	adds	r2, r2, #1
	bic	r2, r2, #64512
	strh	r2, [r3, #2]	@ movhi
	ldrh	r4, [r3, r0, lsl #1]
	ldr	r3, .L700+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L698
	mov	r0, r4
	bl	P2V_block_in_plane
	ldr	r3, .L700+8
	movs	r1, #1
	mov	r2, r1
	mov	r5, r0
	ldr	r0, [r3, #0]
	lsls	r3, r4, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L700+12
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L700+16
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	b	.L698
.L699:
	movw	r4, #65535
.L698:
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L701:
	.align	2
.L700:
	.word	.LANCHOR92
	.word	.LANCHOR7
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
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
	ldr	r3, .L718
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	ldrh	fp, [r3, #0]
	cmp	r0, fp
	bcs	.L703
	ldr	r3, .L718+4
	movs	r6, #6
	muls	r6, r0, r6
	ldr	r1, [r3, #0]
	movw	r3, #65535
	adds	r2, r1, r6
	strh	r3, [r1, r6]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	ldr	r3, .L718+8
	ldr	r5, [r3, #0]
	cmp	r5, #0
	beq	.L717
.L704:
	ldr	r3, .L718+12
	ldrh	r4, [r2, #4]
	ldr	ip, [r3, #0]
	lsls	r3, r0, #1
	ldrh	r7, [ip, r0, lsl #1]
	cbz	r4, .L713
	muls	r4, r7, r4
	b	.L716
.L713:
	mov	r4, #-1
.L716:
	str	r4, [sp, #8]
	subs	r4, r5, r1
	ldr	r7, .L718+16
	mov	sl, r2
	asrs	r4, r4, #1
	muls	r4, r7, r4
	ldr	r7, .L718+20
	uxth	r4, r4
	str	ip, [sp, #4]
	ldr	r7, [r7, #0]
	adds	r3, r7, r3
	str	r3, [sp, #20]
	str	r7, [sp, #12]
	mov	r3, r5
	movs	r7, #0
.L711:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r7, fp
	bhi	.L703
	cmp	r0, r4
	beq	.L703
	ldr	r2, [sp, #4]
	lsl	r8, r4, #1
	str	r8, [sp, #16]
	ldrh	r8, [r2, r4, lsl #1]
	ldrh	r2, [r3, #4]
	cbz	r2, .L714
	mul	r2, r2, r8
	b	.L706
.L714:
	mov	r2, #-1
.L706:
	ldr	r8, [sp, #8]
	cmp	r2, r8
	bne	.L707
	ldr	r2, [sp, #12]
	ldr	ip, [sp, #16]
	ldrh	r8, [r2, ip]
	ldr	r2, [sp, #20]
	ldrh	ip, [r2, #0]
	cmp	r8, ip
	bcc	.L709
	b	.L715
.L707:
	bhi	.L715
.L709:
	ldrh	r2, [r3, #0]
	movw	r8, #65535
	cmp	r2, r8
	bne	.L710
	mov	r2, sl
	strh	r0, [r3, #0]	@ movhi
	ldr	r3, .L718+24
	strh	r4, [r2, #2]	@ movhi
	b	.L717
.L710:
	mov	ip, #6
	mov	r4, r2
	mla	r3, ip, r2, r1
	b	.L711
.L715:
	strh	r4, [r1, r6]	@ movhi
	mov	r2, sl
	ldrh	r4, [r3, #2]
	cmp	r3, r5
	strh	r4, [r2, #2]	@ movhi
	bne	.L712
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L718+8
.L717:
	str	r2, [r3, #0]
	b	.L703
.L712:
	ldrh	r2, [r3, #2]
	movs	r4, #6
	strh	r0, [r3, #2]	@ movhi
	muls	r2, r4, r2
	strh	r0, [r1, r2]	@ movhi
.L703:
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L719:
	.align	2
.L718:
	.word	.LANCHOR55
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	-1431655765
	.word	.LANCHOR94
	.word	.LANCHOR100
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
	ldr	r2, .L722
	ldrh	r3, [r2, #0]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L722+4
	ldrh	r2, [r2, #0]
	cmp	r2, r3
	bcs	.L720
	ldr	r1, .L722+8
	movs	r2, #196
	ldr	r0, .L722+12
	bl	printf
	ldr	r0, .L722+16
	ldr	r1, .L722+20
	pop	{r3, lr}
	b	printf
.L720:
	pop	{r3, pc}
.L723:
	.align	2
.L722:
	.word	.LANCHOR101
	.word	.LANCHOR55
	.word	.LANCHOR102
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
	beq	.L725
	ldr	r3, .L732
	mov	fp, #6
	mul	r6, fp, r0
	ldr	r2, [r3, #0]
	ldr	r3, .L732+4
	adds	r1, r2, r6
	ldr	r4, [r3, #0]
	strh	r8, [r1, #2]	@ movhi
	strh	r8, [r2, r6]	@ movhi
	cbz	r4, .L731
.L726:
	ldr	r3, .L732+8
	subs	r5, r4, r2
	asrs	r5, r5, #1
	ldr	ip, [r3, #0]
	ldr	r3, .L732+12
	muls	r5, r3, r5
	mov	r3, r4
	uxth	r5, r5
	ldrh	sl, [ip, r0, lsl #1]
.L729:
	ldrh	r7, [ip, r5, lsl #1]
	cmp	r7, sl
	bcs	.L727
	ldrh	r7, [r3, #0]
	cmp	r7, r8
	bne	.L728
	strh	r5, [r1, #2]	@ movhi
	strh	r0, [r3, #0]	@ movhi
	b	.L725
.L728:
	mla	r3, fp, r7, r2
	mov	r5, r7
	b	.L729
.L727:
	ldrh	r7, [r3, #2]
	cmp	r3, r4
	strh	r5, [r2, r6]	@ movhi
	strh	r7, [r1, #2]	@ movhi
	bne	.L730
	strh	r0, [r3, #2]	@ movhi
	ldr	r3, .L732+4
.L731:
	str	r1, [r3, #0]
	b	.L725
.L730:
	ldrh	r1, [r3, #2]
	movs	r4, #6
	strh	r0, [r3, #2]	@ movhi
	muls	r1, r4, r1
	strh	r0, [r2, r1]	@ movhi
.L725:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L733:
	.align	2
.L732:
	.word	.LANCHOR97
	.word	.LANCHOR103
	.word	.LANCHOR94
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
	ldr	r2, .L736
	ldrh	r3, [r2, #0]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L736+4
	ldrh	r2, [r2, #0]
	cmp	r2, r3
	bcs	.L734
	ldr	r1, .L736+8
	movs	r2, #189
	ldr	r0, .L736+12
	bl	printf
	ldr	r0, .L736+16
	ldr	r1, .L736+20
	pop	{r3, lr}
	b	printf
.L734:
	pop	{r3, pc}
.L737:
	.align	2
.L736:
	.word	.LANCHOR104
	.word	.LANCHOR55
	.word	.LANCHOR105
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
	ldr	r3, .L744
	mov	r5, r0
	ldr	r7, [r3, #0]
	movw	r3, #65535
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L739
	ldr	r3, [r0, #0]
	cmp	r4, r3
	beq	.L739
	ldr	r1, .L744+4
	mov	r2, #354
	ldr	r0, .L744+8
	bl	printf
	ldr	r0, .L744+12
	ldr	r1, .L744+16
	bl	printf
.L739:
	ldr	r3, [r5, #0]
	movw	r2, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L740
	cmp	r3, r2
	bne	.L741
	movs	r3, #0
	str	r3, [r5, #0]
	b	.L742
.L741:
	ldr	r1, .L744
	movs	r0, #6
	ldr	r1, [r1, #0]
	mla	r3, r0, r3, r1
	str	r3, [r5, #0]
	strh	r2, [r3, #2]	@ movhi
	b	.L742
.L740:
	cmp	r3, r2
	ldrh	r2, [r4, #2]
	bne	.L743
	cmp	r2, r3
	beq	.L742
	ldr	r1, .L744
	movs	r0, #6
	muls	r2, r0, r2
	ldr	r1, [r1, #0]
	strh	r3, [r1, r2]	@ movhi
	b	.L742
.L743:
	ldr	r1, .L744
	movs	r0, #6
	ldr	r1, [r1, #0]
	mla	r5, r0, r3, r1
	strh	r2, [r5, #2]	@ movhi
	ldrh	r2, [r4, #2]
	muls	r0, r2, r0
	strh	r3, [r1, r0]	@ movhi
.L742:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L745:
	.align	2
.L744:
	.word	.LANCHOR97
	.word	.LANCHOR106
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
	cbz	r3, .L751
	ldr	r2, .L752
	movw	r6, #65535
	movs	r5, #6
	ldr	r4, [r2, #0]
	b	.L748
.L750:
	mla	r3, r5, r2, r4
	subs	r1, r1, #1
	uxth	r1, r1
.L748:
	cbz	r1, .L749
	ldrh	r2, [r3, #0]
	cmp	r2, r6
	bne	.L750
.L749:
	subs	r4, r3, r4
	ldr	r3, .L752+4
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
	mov	r1, r4
	bl	List_remove_node
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L751:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L753:
	.align	2
.L752:
	.word	.LANCHOR97
	.word	-1431655765
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_pop_head_node,"ax",%progbits
	.align	1
	.global	List_pop_head_node
	.thumb
	.thumb_func
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
	.thumb
	.thumb_func
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L761
	push	{r4, lr}
	ldr	r3, [r3, #0]
	cbz	r3, .L760
	ldr	r2, .L761+4
	movw	r1, #65535
	movs	r4, #6
	ldr	r2, [r2, #0]
	b	.L757
.L759:
	mla	r3, r4, r3, r2
	subs	r0, r0, #1
	uxth	r0, r0
.L757:
	cbz	r0, .L758
	ldrh	r3, [r3, #0]
	cmp	r3, r1
	bne	.L759
	mov	r0, r1
	pop	{r4, pc}
.L758:
	subs	r3, r3, r2
	ldr	r0, .L761+8
	asrs	r3, r3, #1
	muls	r0, r3, r0
	uxth	r0, r0
	pop	{r4, pc}
.L760:
	movw	r0, #65535
	pop	{r4, pc}
.L762:
	.align	2
.L761:
	.word	.LANCHOR98
	.word	.LANCHOR97
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
	ldr	r3, .L772
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L764
	ldr	r3, .L772+4
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L764
	ldr	r3, .L772+8
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L764
	ldr	r3, .L772+12
	movs	r7, #6
	muls	r7, r0, r7
	ldr	r8, [r3, #0]
	ldr	r3, .L772+16
	add	r5, r8, r7
	ldr	r3, [r3, #0]
	cmp	r5, r3
	beq	.L764
	ldr	r3, .L772+20
	movw	r2, #65535
	ldrh	r6, [r5, #4]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	muls	r6, r3, r6
	ldrh	r3, [r5, #2]
	it	eq
	moveq	r6, #-1
	cmp	r3, r2
	bne	.L766
	ldrh	r2, [r8, r7]
	cmp	r2, r3
	bne	.L766
	ldr	r1, .L772+24
	movw	r2, #445
	ldr	r0, .L772+28
	bl	printf
	ldr	r0, .L772+32
	ldr	r1, .L772+36
	bl	printf
.L766:
	ldrh	r3, [r5, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L767
	ldrh	r2, [r8, r7]
	cmp	r2, r3
	beq	.L764
.L767:
	ldr	r2, .L772+12
	movs	r1, #6
	ldr	r2, [r2, #0]
	mla	r3, r1, r3, r2
	ldr	r1, .L772+40
	subs	r2, r3, r2
	asrs	r2, r2, #1
	muls	r2, r1, r2
	ldr	r1, .L772+20
	uxth	r2, r2
	ldrh	r3, [r3, #4]
	ldr	r1, [r1, #0]
	ldrh	r2, [r1, r2, lsl #1]
	muls	r3, r2, r3
	it	eq
	moveq	r3, #-1
	cmp	r6, r3
	bcs	.L764
	ldr	r5, .L772+44
	mov	r1, r4
	ldr	r0, .L772+16
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L769
	ldr	r1, .L772+24
	mov	r2, #456
	ldr	r0, .L772+28
	bl	printf
	ldr	r0, .L772+32
	ldr	r1, .L772+36
	bl	printf
.L769:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	INSERT_DATA_LIST
.L764:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L773:
	.align	2
.L772:
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR110
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	-1431655765
	.word	.LANCHOR101
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
	b	.L775
.L779:
	ldr	r1, [r7, r2, lsl #2]
	movs	r3, #0
	ubfx	r1, r1, #10, #16
	b	.L776
.L778:
	ldrh	r0, [r6, r3, lsl #1]
	cmp	r0, r1
	bne	.L777
	ldrh	r0, [r5, r3, lsl #1]
	adds	r0, r0, #1
	strh	r0, [r5, r3, lsl #1]	@ movhi
.L777:
	adds	r3, r3, #1
	uxth	r3, r3
.L776:
	ldrh	r0, [r4, #10]
	cmp	r0, r3
	bhi	.L778
	adds	r2, r2, #1
	uxth	r2, r2
.L775:
	ldrh	r3, [r4, #6]
	cmp	r3, r2
	bhi	.L779
	mov	sl, #0
	ldrh	r3, [r5, #0]
	mov	r7, sl
	ldr	r2, .L785
	b	.L780
.L784:
	ldrh	r1, [r4, #0]
	cmp	r1, r7
	bne	.L781
	ldrh	r1, [r2, #0]
	ldrh	r0, [r4, #2]
	cmp	r0, r1
	it	cc
	strhcc	r1, [r5, r7, lsl #1]	@ movhi
.L781:
	ldrh	r8, [r5, r7, lsl #1]
	lsl	fp, r7, #1
	cmp	r3, r8
	itt	hi
	movhi	sl, r7
	movhi	r3, r8
	cmp	r8, #0
	bne	.L783
	ldrh	r0, [r6, fp]
	cbz	r0, .L783
	movs	r1, #1
	stmia	sp, {r2, r3}
	bl	FtlFreeSysBlkQueueIn
	ldmia	sp, {r2, r3}
	strh	r8, [r6, fp]	@ movhi
	ldrh	r1, [r4, #8]
	subs	r1, r1, #1
	strh	r1, [r4, #8]	@ movhi
.L783:
	adds	r7, r7, #1
	uxth	r7, r7
.L780:
	ldrh	r1, [r4, #10]
	cmp	r1, r7
	bhi	.L784
	mov	r0, sl
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L786:
	.align	2
.L785:
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
	b	.L788
.L791:
	mov	r7, r3
	adds	r3, r3, #2
	ldrh	r6, [r7, #0]
	cbnz	r6, .L789
	bl	FtlFreeSysBlkQueueOut
	strh	r0, [r7, #0]	@ movhi
	cbz	r0, .L790
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	strh	r5, [r4, #0]	@ movhi
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L790
.L789:
	adds	r5, r5, #1
	uxth	r5, r5
.L788:
	cmp	r5, r2
	bne	.L791
.L790:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L792
	ldr	r1, .L793
	movw	r2, #553
	ldr	r0, .L793+4
	bl	printf
	ldr	r0, .L793+8
	ldr	r1, .L793+12
	bl	printf
.L792:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L794:
	.align	2
.L793:
	.word	.LANCHOR111
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
	ldr	r2, .L807
	movw	r1, #65535
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L807+4
	ldr	r0, [r2, #0]
	movs	r2, #0
	mov	r4, r2
	ldrh	r3, [r3, #0]
	b	.L796
.L798:
	adds	r2, r2, #12
	adds	r5, r0, r2
	ldrh	r5, [r5, #-12]
	cmp	r5, r1
	beq	.L797
	adds	r4, r4, #1
	uxth	r4, r4
.L796:
	cmp	r4, r3
	bne	.L798
	movs	r1, #0
	mov	r4, r3
	mov	r6, #-2147483648
	mov	r2, r1
	b	.L799
.L801:
	adds	r5, r0, r1
	ldr	r5, [r5, #4]
	cmp	r5, #0
	blt	.L800
	cmp	r5, r6
	itt	cc
	movcc	r6, r5
	movcc	r4, r2
.L800:
	adds	r2, r2, #1
	adds	r1, r1, #12
	uxth	r2, r2
.L799:
	cmp	r2, r3
	bne	.L801
	cmp	r4, r3
	bcc	.L797
	ldr	r2, .L807+8
	movs	r1, #0
	mov	r4, r3
	mov	r5, #-1
	ldrh	r7, [r2, #0]
	mov	r2, r1
	b	.L802
.L804:
	adds	r6, r0, r1
	ldr	r6, [r6, #4]
	cmp	r6, r5
	bcs	.L803
	ldrh	ip, [r0, r1]
	cmp	ip, r7
	it	ne
	movne	r5, r6
	it	ne
	movne	r4, r2
.L803:
	adds	r2, r2, #1
	adds	r1, r1, #12
	uxth	r2, r2
.L802:
	cmp	r2, r3
	bne	.L804
	cmp	r4, r2
	bcc	.L797
	ldr	r1, .L807+12
	mov	r2, #756
	ldr	r0, .L807+16
	bl	printf
	ldr	r0, .L807+20
	ldr	r1, .L807+24
	bl	printf
.L797:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L808:
	.align	2
.L807:
	.word	.LANCHOR112
	.word	.LANCHOR83
	.word	.LANCHOR113
	.word	.LANCHOR114
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
	ldr	r3, .L815
	push	{r4, r5, lr}
	ldrh	r2, [r3, #0]
	adds	r1, r2, #1
	cmp	r2, #4
	strh	r1, [r3, #0]	@ movhi
	mov	r2, r3
	bhi	.L810
	cbz	r0, .L809
.L810:
	movs	r3, #0
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L815+4
	movw	r4, #65535
	ldrh	r5, [r2, #0]
	ldr	r2, .L815+8
	ldr	r1, [r2, #0]
	mov	r2, r3
	b	.L812
.L814:
	ldrh	r0, [r1], #2
	cmp	r0, r4
	it	ne
	addne	r3, r3, r0
	adds	r2, r2, #1
	uxth	r2, r2
.L812:
	cmp	r2, r5
	bne	.L814
	ldr	r2, .L815+12
	str	r3, [r2, #0]
.L809:
	pop	{r4, r5, pc}
.L816:
	.align	2
.L815:
	.word	.LANCHOR115
	.word	.LANCHOR55
	.word	.LANCHOR99
	.word	.LANCHOR116
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
	ldr	r3, .L821
	lsrs	r2, r0, #5
	and	r0, r0, #31
	uxth	r2, r2
	ldr	r3, [r3, #0]
	cbz	r1, .L818
	movs	r1, #1
	lsl	r0, r1, r0
	ldr	r1, [r3, r2, lsl #2]
	orrs	r0, r0, r1
	b	.L820
.L818:
	movs	r1, #1
	lsl	r0, r1, r0
	ldr	r1, [r3, r2, lsl #2]
	bic	r0, r1, r0
.L820:
	str	r0, [r3, r2, lsl #2]
	bx	lr
.L822:
	.align	2
.L821:
	.word	.LANCHOR117
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
	ldr	r3, .L824
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3, #0]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L825:
	.align	2
.L824:
	.word	.LANCHOR117
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
	ldr	r3, .L829
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, lr}
	ldr	r2, [r3, #0]
	ldr	r3, .L829+4
	ldr	r5, .L829+8
	ldr	r4, .L829+12
	lsls	r2, r2, #1
	ldr	r6, .L829+16
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r3, [r4, #0]
	ldrh	r2, [r6, #0]
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r0, [r5, #0]
	bl	memset
	ldr	r3, .L829+20
	ldrh	r7, [r6, #0]
	ldr	ip, [r5, #0]
	movw	r5, #65535
	ldr	r2, [r3, #0]
	movs	r3, #0
	ldrh	r6, [r4, #0]
	mov	r1, r3
	mov	r4, r3
	b	.L827
.L828:
	adds	r1, r1, #1
	bic	r3, r3, #3
	add	r3, ip, r3
	str	r3, [r2, #-4]
	uxth	r1, r1
	mov	r3, r8
	str	r4, [r2, #-8]
	strh	r5, [r2, #-12]	@ movhi
.L827:
	adds	r2, r2, #12
	cmp	r1, r7
	add	r8, r3, r6
	movw	r0, #65535
	bne	.L828
	ldr	r2, .L829
	ldr	r3, .L829+24
	ldr	r2, [r2, #0]
	strh	r0, [r3, #2]	@ movhi
	strh	r0, [r3, #0]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L829+28
	ldrh	r2, [r2, #0]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L829+32
	ldrh	r2, [r2, #0]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L829+36
	ldr	r2, [r2, #0]
	str	r2, [r3, #12]
	ldr	r2, .L829+40
	ldr	r2, [r2, #0]
	str	r2, [r3, #16]
	ldr	r2, .L829+4
	ldr	r2, [r2, #0]
	str	r2, [r3, #20]
	ldr	r2, .L829+44
	ldr	r2, [r2, #0]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L830:
	.align	2
.L829:
	.word	.LANCHOR80
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR73
	.word	.LANCHOR83
	.word	.LANCHOR112
	.word	.LANCHOR120
	.word	.LANCHOR121
	.word	.LANCHOR82
	.word	.LANCHOR122
	.word	.LANCHOR123
	.word	.LANCHOR124
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
	ldr	r3, .L838
	push	{r4, r5, r6, r7, lr}
	movw	r4, #65535
	ldrh	r3, [r3, #0]
	b	.L832
.L834:
	add	r5, r2, #8
	ldrh	r5, [r0, r5, lsl #1]
	cmp	r5, r4
	beq	.L833
	ldrh	r5, [r0, #4]
	adds	r5, r5, #1
	strh	r5, [r0, #4]	@ movhi
.L833:
	adds	r2, r2, #1
	uxth	r2, r2
.L832:
	cmp	r2, r3
	bcc	.L834
	ldr	r2, .L838+4
	mov	r4, r0
	movw	r5, #65535
	mvns	r1, r1
	ldrh	r6, [r2, #0]
	movs	r2, #0
	b	.L835
.L837:
	ldrh	r7, [r4, #16]
	cmp	r7, r5
	beq	.L836
	ldrh	r7, [r0, #4]
	adds	r7, r6, r7
	adds	r7, r7, r1
	strh	r7, [r0, #4]	@ movhi
.L836:
	adds	r2, r2, #1
	adds	r4, r4, #2
	uxth	r2, r2
.L835:
	cmp	r2, r3
	bne	.L837
	pop	{r4, r5, r6, r7, pc}
.L839:
	.align	2
.L838:
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
	ldr	r3, .L847
	ldrh	r2, [r0, #0]
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L841
	ldr	r1, .L847+4
	movw	r2, #2145
	ldr	r0, .L847+8
	bl	printf
	ldr	r0, .L847+12
	ldr	r1, .L847+16
	bl	printf
.L841:
	movs	r5, #0
	ldr	r8, .L847+40
	strh	r5, [r4, #4]	@ movhi
	movw	r6, #65535
	strb	r5, [r4, #7]
	ldr	r7, .L847+20
	b	.L842
.L844:
	ldrb	r0, [r7, r5]	@ zero_extendqisi2
	add	sl, r5, #8
	ldrh	r1, [r4, #0]
	bl	V2P_block
	strh	r6, [r4, sl, lsl #1]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L843
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	strh	fp, [r4, sl, lsl #1]	@ movhi
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L843:
	adds	r5, r5, #1
	uxth	r5, r5
.L842:
	ldrh	r3, [r8, #0]
	cmp	r3, r5
	bhi	.L844
	ldr	r2, .L847+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L847+28
	ldr	r3, [r3, #0]
	cbz	r3, .L845
	ldr	r3, .L847+32
	ldrh	r2, [r4, #0]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #59
	bhi	.L845
	movs	r3, #1
	strb	r3, [r4, #9]
.L845:
	ldr	r3, .L847+36
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L846
	movs	r3, #1
	strb	r3, [r4, #9]
.L846:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L848:
	.align	2
.L847:
	.word	.LANCHOR55
	.word	.LANCHOR125
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR62
	.word	.LANCHOR68
	.word	.LANCHOR126
	.word	.LANCHOR94
	.word	.LANCHOR7
	.word	.LANCHOR53
	.size	make_superblock, .-make_superblock
	.section	.text.SupperBlkListInit,"ax",%progbits
	.align	1
	.global	SupperBlkListInit
	.thumb
	.thumb_func
	.type	SupperBlkListInit, %function
SupperBlkListInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L860
	movs	r1, #0
	ldr	r3, .L860+4
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r6, #0
	ldrh	r3, [r3, #0]
	mov	r7, r6
	ldr	r0, [r2, #0]
	movs	r2, #6
	muls	r2, r3, r2
	mov	r4, r6
	bl	memset
	ldr	r3, .L860+8
	ldr	sl, .L860+68
	str	r6, [r3, #0]
	ldr	r3, .L860+12
	str	r6, [r3, #0]
	ldr	r3, .L860+16
	str	r6, [r3, #0]
	ldr	r3, .L860+20
	strh	r6, [r3, #0]	@ movhi
	ldr	r3, .L860+24
	strh	r6, [r3, #0]	@ movhi
	b	.L850
.L852:
	ldr	r2, .L860+28
	mov	r1, r4
	ldrb	r0, [r2, r8]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L851
	ldrh	r3, [fp, #0]
	adds	r5, r5, r3
	uxth	r5, r5
.L851:
	add	r8, r8, #1
	uxth	r8, r8
	b	.L857
.L859:
	movs	r5, #0
	ldr	fp, .L860+72
	mov	r8, r5
.L857:
	ldr	r2, .L860+32
	ldrh	r3, [r2, #0]
	cmp	r3, r8
	bhi	.L852
	cbz	r5, .L853
	mov	r1, r5
	mov	r0, #32768
	bl	__aeabi_idiv
	uxth	r5, r0
	b	.L854
.L853:
	ldr	r3, .L860+36
	movw	r2, #65535
	ldr	r3, [r3, #0]
	strh	r2, [r3, r4, lsl #1]	@ movhi
.L854:
	ldr	r3, .L860
	movs	r2, #6
	ldr	r3, [r3, #0]
	mla	r3, r2, r4, r3
	strh	r5, [r3, #4]	@ movhi
	ldr	r3, .L860+40
	ldrh	r3, [r3, #0]
	cmp	r3, r4
	beq	.L855
	ldr	r3, .L860+44
	ldrh	r3, [r3, #0]
	cmp	r3, r4
	beq	.L855
	ldr	r3, .L860+48
	ldrh	r3, [r3, #0]
	cmp	r3, r4
	beq	.L855
	ldr	r3, .L860+36
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L856
	adds	r6, r6, #1
	mov	r0, r4
	uxth	r6, r6
	bl	INSERT_FREE_LIST
	b	.L855
.L856:
	adds	r7, r7, #1
	mov	r0, r4
	uxth	r7, r7
	bl	INSERT_DATA_LIST
.L855:
	adds	r4, r4, #1
	uxth	r4, r4
.L850:
	ldrh	r3, [sl, #0]
	cmp	r4, r3
	bcc	.L859
	ldr	r2, .L860+20
	strh	r7, [r2, #0]	@ movhi
	ldr	r2, .L860+24
	strh	r6, [r2, #0]	@ movhi
	adds	r6, r7, r6
	cmp	r6, r3
	ble	.L858
	ldr	r1, .L860+52
	movw	r2, #2209
	ldr	r0, .L860+56
	bl	printf
	ldr	r0, .L860+60
	ldr	r1, .L860+64
	bl	printf
.L858:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L861:
	.align	2
.L860:
	.word	.LANCHOR97
	.word	.LANCHOR56
	.word	.LANCHOR103
	.word	.LANCHOR98
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR104
	.word	.LANCHOR62
	.word	.LANCHOR53
	.word	.LANCHOR99
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR127
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR55
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
	ldr	sl, .L867+8
	ldr	r8, .L867+12
	ldr	r7, .L867
	b	.L863
.L865:
	mov	r1, r6
	ldrb	r0, [r8, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L864
	ldrh	r3, [r7, #0]
	adds	r4, r4, r3
	uxth	r4, r4
.L864:
	adds	r5, r5, #1
	uxth	r5, r5
.L863:
	ldrh	r3, [sl, #0]
	cmp	r3, r5
	bhi	.L865
	cbz	r4, .L866
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
	uxth	r4, r0
.L866:
	ldr	r3, .L867+4
	movs	r2, #6
	movs	r0, #0
	ldr	r3, [r3, #0]
	mla	r6, r2, r6, r3
	strh	r4, [r6, #4]	@ movhi
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L868:
	.align	2
.L867:
	.word	.LANCHOR68
	.word	.LANCHOR97
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
	ldr	r3, .L872
	ldr	r0, [r3, #0]
	cbz	r0, .L870
	ldr	r3, .L872+4
	ldr	r3, [r3, #0]
	subs	r0, r0, r3
	ldr	r3, .L872+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L872+12
	uxth	r0, r0
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r0, lsl #1]
.L870:
	bx	lr
.L873:
	.align	2
.L872:
	.word	.LANCHOR103
	.word	.LANCHOR97
	.word	-1431655765
	.word	.LANCHOR94
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
	ldr	r3, .L881
	push	{r4, r5, r6, lr}
	ldr	r3, [r3, #0]
	cbz	r3, .L880
	ldr	r2, .L881+4
	movs	r1, #7
	movw	r5, #65535
	ldrh	r2, [r2, #0]
	muls	r2, r1, r2
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L881+8
	movs	r6, #6
	ldr	r1, [r2, #0]
	ldr	r2, .L881+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
	b	.L877
.L879:
	mul	r4, r6, r3
	ldrh	r4, [r1, r4]
	cmp	r4, r5
	beq	.L878
	adds	r2, r2, #1
	mov	r3, r4
	uxth	r2, r2
.L877:
	cmp	r2, r0
	bne	.L879
.L878:
	ldr	r2, .L881+16
	ldr	r2, [r2, #0]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L880:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L882:
	.align	2
.L881:
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	.LANCHOR97
	.word	-1431655765
	.word	.LANCHOR94
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
	beq	.L884
	ldr	r2, .L885
	movs	r1, #0
	ldr	r2, [r2, #0]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L884:
	movs	r0, #0
	pop	{r3, pc}
.L886:
	.align	2
.L885:
	.word	.LANCHOR99
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
	ldr	r3, .L892
	movs	r2, #0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r2
	str	r2, [r3, #0]
	ldr	r3, .L892+4
	ldrh	ip, [r3, #0]
	ldr	r3, .L892+8
	ldr	r7, [r3, #0]
	ldr	r3, .L892+12
	ldr	r6, [r3, #0]
	ldr	r3, .L892+16
	ldr	r1, [r3, #0]
	ldr	r3, .L892+20
	ldrh	r5, [r3, #0]
	ldr	r3, .L892+24
	str	r5, [sp, #4]
	ldrh	fp, [r3, #0]
	ldr	r3, .L892+28
	ldr	r0, [r3, #0]
	mov	r3, r2
	b	.L888
.L889:
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
.L888:
	adds	r1, r1, #12
	ldr	r5, [sp, #4]
	adds	r0, r0, #36
	cmp	r3, ip
	add	r8, r4, r5
	add	sl, r2, fp
	bne	.L889
	ldr	r1, .L892+8
	movs	r4, #12
	ldr	r2, .L892+32
	mov	fp, #0
	ldr	ip, [r1, #0]
	ldr	r1, .L892+20
	ldr	r8, [r2, #0]
	ldr	r2, .L892+16
	ldrh	r7, [r1, #0]
	ldr	r1, .L892+12
	ldr	r2, [r2, #0]
	ldr	r6, [r1, #0]
	ldr	r1, .L892+24
	ldrh	r5, [r1, #0]
	b	.L890
.L891:
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
.L890:
	cmp	r3, r8
	bcc	.L891
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L893:
	.align	2
.L892:
	.word	.LANCHOR128
	.word	.LANCHOR53
	.word	.LANCHOR129
	.word	.LANCHOR130
	.word	.LANCHOR131
	.word	.LANCHOR73
	.word	.LANCHOR74
	.word	.LANCHOR132
	.word	.LANCHOR133
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
	ldr	r3, .L895
	movw	r2, #65535
	ldr	r5, .L895+4
	mov	r1, r4
	str	r4, [r3, #0]
	ldr	r3, .L895+8
	strh	r2, [r3, #0]	@ movhi
	mov	r2, #-1
	ldr	r3, .L895+12
	str	r4, [r3, #0]
	ldr	r3, .L895+16
	str	r4, [r3, #0]
	ldr	r3, .L895+20
	str	r2, [r3, #0]
	ldr	r3, .L895+24
	str	r4, [r3, #0]
	ldr	r3, .L895+28
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L895+32
	ldrh	r2, [r3, #0]
	ldr	r3, .L895+36
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r2, [r5, #0]
	ldr	r3, .L895+40
	mov	r1, r4
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r3, .L895+44
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L895+48
	bl	memset
	mov	r1, r4
	mov	r2, #512
	ldr	r0, .L895+52
	bl	memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L896:
	.align	2
.L895:
	.word	.LANCHOR134
	.word	.LANCHOR56
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LANCHOR137
	.word	.LANCHOR138
	.word	.LANCHOR126
	.word	.LANCHOR85
	.word	.LANCHOR77
	.word	.LANCHOR86
	.word	.LANCHOR94
	.word	.LANCHOR139
	.word	.LANCHOR140
	.word	.LANCHOR141
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
	ldr	r3, .L904
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r5, #36
	ldr	r6, [r3, #0]
	ldr	r3, .L904+4
	ldr	r4, [r3, #0]
	movs	r3, #0
	mov	fp, r3
	b	.L898
.L901:
	mov	ip, #12
	mul	r3, ip, r2
	add	sl, r4, r3
	ldr	ip, [r4, r3]
	ldr	r3, [r7, #8]
	cmp	ip, r3
	bne	.L899
	mov	r3, r8
	str	fp, [sl, #8]
	b	.L900
.L899:
	adds	r2, r2, #1
	uxth	r2, r2
.L903:
	cmp	r2, r6
	bcc	.L901
	mov	r3, r8
.L900:
	adds	r3, r3, #1
	uxth	r3, r3
.L898:
	cmp	r3, r1
	bcs	.L897
	mla	r7, r5, r3, r0
	movs	r2, #0
	mov	r8, r3
	b	.L903
.L897:
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L905:
	.align	2
.L904:
	.word	.LANCHOR133
	.word	.LANCHOR131
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
	ldr	r3, .L913
	push	{r4, r5, r6, r7, r8, sl, lr}
	movs	r7, #12
	ldr	r8, [r3, #0]
	movs	r6, #1
	ldr	r3, .L913+4
	movs	r5, #36
	ldr	ip, [r3, #0]
	movs	r3, #0
	b	.L907
.L910:
	mla	r4, r7, r2, ip
	ldr	sl, [r4, #8]
	cmp	sl, #0
	bne	.L908
	mla	r2, r5, r3, r0
	str	r6, [r4, #8]
	ldr	sl, [r4, #0]
	ldr	r4, [r4, #4]
	str	sl, [r2, #8]
	str	r4, [r2, #12]
	b	.L909
.L908:
	adds	r2, r2, #1
	uxth	r2, r2
	b	.L911
.L912:
	movs	r2, #0
.L911:
	cmp	r2, r8
	bcc	.L910
.L909:
	adds	r3, r3, #1
	uxth	r3, r3
.L907:
	cmp	r3, r1
	bcc	.L912
	pop	{r4, r5, r6, r7, r8, sl, pc}
.L914:
	.align	2
.L913:
	.word	.LANCHOR133
	.word	.LANCHOR131
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
	ldr	r3, .L920
	push	{r4, lr}
	ldrh	r1, [r3, #0]
	ldr	r3, .L920+4
	ldr	r2, [r3, #0]
	movs	r3, #0
	b	.L916
.L918:
	ldrh	r4, [r2], #2
	cmp	r4, r0
	beq	.L919
	adds	r3, r3, #1
	uxth	r3, r3
.L916:
	cmp	r3, r1
	bne	.L918
	movs	r0, #0
	pop	{r4, pc}
.L919:
	movs	r0, #1
	pop	{r4, pc}
.L921:
	.align	2
.L920:
	.word	.LANCHOR142
	.word	.LANCHOR143
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
	ldr	r3, .L926
	ldrh	r7, [r3, #0]
	ldr	r3, .L926+4
	ldr	r2, [r3, #0]
	movs	r3, #0
	mov	r1, r2
	b	.L923
.L925:
	ldrh	ip, [r1], #2
	cmp	ip, r0
	beq	.L924
	adds	r3, r3, #1
	uxth	r3, r3
.L923:
	cmp	r3, r7
	bne	.L925
	strh	r0, [r2, r3, lsl #1]	@ movhi
	ldr	r3, .L926
	ldrh	r2, [r3, #0]
	adds	r2, r2, #1
	strh	r2, [r3, #0]	@ movhi
.L924:
	ldr	r0, .L926+8
	movs	r1, #12
	ldr	r3, .L926+12
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
.L927:
	.align	2
.L926:
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR145
	.word	.LANCHOR144
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
	ldr	r2, .L929
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	strh	r3, [r2, #0]	@ movhi
	ldr	r4, .L929+4
	ldr	r2, .L929+8
	strh	r3, [r2, #0]	@ movhi
	ldrh	r2, [r4, #0]
	ldr	r3, .L929+12
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r2, .L929+16
	ldrh	r3, [r4, #0]
	movs	r1, #255
	ldr	r0, [r2, #0]
	movs	r2, #12
	muls	r2, r3, r2
	bl	memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L930:
	.align	2
.L929:
	.word	.LANCHOR142
	.word	.LANCHOR70
	.word	.LANCHOR144
	.word	.LANCHOR143
	.word	.LANCHOR145
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	ldr	r4, .L934
	ldrh	r5, [r4, #0]
	cmp	r5, r0
	beq	.L932
	ldr	r3, .L934+4
	ldrh	r1, [r3, #0]
	cmp	r1, r0
	beq	.L932
	movw	r2, #65535
	cmp	r5, r2
	bne	.L933
	strh	r0, [r4, #0]	@ movhi
	b	.L932
.L933:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3, #0]	@ movhi
.L932:
	movs	r0, #0
	pop	{r4, r5, pc}
.L935:
	.align	2
.L934:
	.word	.LANCHOR146
	.word	.LANCHOR147
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
	ldr	r3, .L941
	ldr	r3, [r3, #0]
	cbz	r3, .L937
	ldr	r3, .L941+4
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	cmp	r2, #29
	bls	.L937
	subs	r2, r2, #30
	strh	r2, [r3, r5, lsl #1]	@ movhi
.L937:
	ldr	r3, .L941+8
	ldr	r2, .L941+12
	ldrh	r1, [r3, #0]
	movs	r3, #0
	b	.L938
.L940:
	ldrh	r0, [r2, #2]!
	cmp	r0, r4
	beq	.L939
	adds	r3, r3, #1
	uxth	r3, r3
.L938:
	cmp	r3, r1
	bne	.L940
	cmp	r3, #15
	bhi	.L939
	ldr	r2, .L941+16
	strh	r4, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	ldr	r2, .L941+8
	strh	r3, [r2, #0]	@ movhi
.L939:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L942:
	.align	2
.L941:
	.word	.LANCHOR126
	.word	.LANCHOR94
	.word	.LANCHOR148
	.word	.LANCHOR149-2
	.word	.LANCHOR149
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
	ldr	r3, .L946
	push	{r4, lr}
	ldrh	r3, [r3, #0]
	cbz	r3, .L944
	ldr	r2, .L946+4
	ldrh	r1, [r2, #0]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L944
	ldr	r4, .L946+8
	ldrh	r2, [r4, #0]
	cmp	r2, r3
	bcc	.L945
	movs	r3, #0
	strh	r3, [r4, #0]	@ movhi
.L945:
	ldr	r3, .L946+12
	ldrh	r2, [r4, #0]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
.L944:
	movs	r0, #0
	pop	{r4, pc}
.L947:
	.align	2
.L946:
	.word	.LANCHOR148
	.word	.LANCHOR146
	.word	.LANCHOR150
	.word	.LANCHOR149
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
	ldr	r0, .L952
	bx	lr
.L953:
	.align	2
.L952:
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
	ldr	r3, .L960
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	movs	r1, #0
	str	r1, [r3, #0]
	movs	r5, #12
	ldr	r3, .L960+4
	ldr	r2, .L960+8
	ldr	r4, .L960+12
	str	r1, [r3, #0]
	ldr	r3, .L960+16
	ldrh	r0, [r4, #0]
	ldr	r8, .L960+296
	str	r1, [r3, #0]
	ldr	r3, .L960+20
	lsls	r0, r0, #1
	ldr	r7, .L960+24
	str	r1, [r3, #0]
	ldr	r3, .L960+28
	str	r1, [r3, #0]
	ldr	r3, .L960+32
	str	r1, [r3, #0]
	ldr	r3, .L960+36
	str	r1, [r3, #0]
	ldr	r3, .L960+40
	str	r1, [r3, #0]
	ldr	r3, .L960+44
	str	r1, [r3, #0]
	ldr	r3, .L960+48
	str	r1, [r3, #0]
	ldr	r3, .L960+52
	str	r1, [r3, #0]
	ldr	r3, .L960+56
	str	r1, [r3, #0]
	ldr	r3, .L960+60
	str	r1, [r3, #0]
	ldr	r3, .L960+64
	str	r1, [r3, #0]
	ldr	r3, .L960+68
	str	r1, [r3, #0]
	ldr	r3, .L960+72
	str	r1, [r3, #0]
	ldr	r3, .L960+76
	str	r1, [r3, #0]
	movw	r3, #65535
	str	r3, [r2, #0]
	ldr	r2, .L960+80
	str	r1, [r2, #0]
	ldr	r2, .L960+84
	str	r1, [r2, #0]
	ldr	r2, .L960+88
	str	r1, [r2, #0]
	ldr	r2, .L960+92
	strh	r3, [r2, #0]	@ movhi
	ldr	r2, .L960+96
	strh	r3, [r2, #0]	@ movhi
	movs	r2, #32
	ldr	r3, .L960+100
	strh	r2, [r3, #0]	@ movhi
	movs	r2, #128
	ldr	r3, .L960+104
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L960+108
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L960+112
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L960+116
	strh	r1, [r3, #0]	@ movhi
	str	r1, [sp, #4]
	bl	ftl_malloc
	ldr	r3, .L960+120
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L960+124
	movs	r4, #36
	str	r0, [r3, #0]
	ldrh	r3, [r8, #0]
	muls	r4, r3, r4
	lsls	r6, r4, #2
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L960+128
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+132
	str	r0, [r3, #0]
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L960+136
	ldr	r6, .L960+140
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+144
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+148
	ldrh	r4, [r6, #0]
	str	r0, [r3, #0]
	mov	r0, r4
	ldrh	r3, [r8, #0]
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r7, #0]
	bl	ftl_malloc
	ldr	r3, .L960+152
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+156
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+160
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	muls	r0, r4, r0
	bl	ftl_malloc
	ldr	r3, .L960+164
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+168
	str	r0, [r3, #0]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L960+172
	ldr	r4, .L960+176
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L960+180
	ldrh	r8, [r8, #0]
	str	r0, [r3, #0]
	ldrh	r3, [r4, #0]
	mul	r8, r8, r3
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L960+184
	str	r0, [r3, #0]
	lsl	r0, r8, #2
	bl	ftl_malloc
	ldr	r3, .L960+188
	str	r0, [r3, #0]
	ldrh	r3, [r4, #0]
	ldr	r0, [r7, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r4, .L960+192
	ldr	r3, .L960+196
	ldr	r7, .L960+200
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r7, #0]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L960+204
	str	r0, [r3, #0]
	ldrh	r0, [r7, #0]
	addw	r0, r0, #547
	lsrs	r0, r0, #9
	strh	r0, [r7, #0]	@ movhi
	ldr	r7, .L960+208
	lsls	r0, r0, #9
	bl	ftl_malloc
	ldr	r3, .L960+212
	str	r0, [r3, #0]
	adds	r0, r0, #32
	ldr	r3, .L960+216
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L960+220
	str	r0, [r3, #0]
	ldr	r3, [r7, #0]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L960+224
	str	r0, [r3, #0]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L960+228
	ldr	r8, .L960+300
	str	r0, [r3, #0]
	ldrh	r0, [r4, #0]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L960+232
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L960+236
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L960+240
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	ldr	r8, .L960+304
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L960+244
	str	r0, [r3, #0]
	ldrh	r0, [r8, #0]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L960+248
	ldrh	r2, [r8, #0]
	ldr	r1, [sp, #4]
	lsls	r2, r2, #2
	str	r0, [r3, #0]
	bl	memset
	ldr	r3, .L960+252
	ldrh	r0, [r3, #0]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L960+256
	str	r0, [r3, #0]
	ldr	r0, [r7, #0]
	ldr	r7, .L960+260
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L960+264
	str	r0, [r3, #0]
	ldrh	r0, [r7, #0]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L960+268
	ldr	r5, .L960+272
	str	r0, [r3, #0]
	ldrh	r3, [r7, #0]
	ldrh	r0, [r6, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L960+276
	str	r0, [r3, #0]
	movs	r0, #6
	ldrh	r3, [r4, #0]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L960+280
	ldr	r4, .L960+284
	ldrh	r2, [r5, #0]
	str	r0, [r3, #0]
	ldr	r3, .L960+288
	ldrh	r3, [r3, #0]
	adds	r3, r3, #31
	lsrs	r3, r3, #5
	strh	r3, [r4, #0]	@ movhi
	muls	r3, r2, r3
	lsls	r0, r3, #2
	bl	ftl_malloc
	ldr	r2, .L960+292
	ldrh	r4, [r4, #0]
	movs	r1, #1
	mov	r3, r2
	ldrh	r5, [r5, #0]
	lsls	r4, r4, #2
	str	r0, [r3, #28]!
	mov	r0, r4
	b	.L956
.L961:
	.align	2
.L960:
	.word	.LANCHOR151
	.word	.LANCHOR152
	.word	.LANCHOR167
	.word	.LANCHOR70
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR133
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR95
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LANCHOR88
	.word	.LANCHOR146
	.word	.LANCHOR147
	.word	.LANCHOR170
	.word	.LANCHOR171
	.word	.LANCHOR172
	.word	.LANCHOR148
	.word	.LANCHOR150
	.word	.LANCHOR143
	.word	.LANCHOR145
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR175
	.word	.LANCHOR73
	.word	.LANCHOR93
	.word	.LANCHOR132
	.word	.LANCHOR96
	.word	.LANCHOR176
	.word	.LANCHOR177
	.word	.LANCHOR129
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR74
	.word	.LANCHOR131
	.word	.LANCHOR180
	.word	.LANCHOR181
	.word	.LANCHOR56
	.word	.LANCHOR130
	.word	.LANCHOR182
	.word	.LANCHOR139
	.word	.LANCHOR80
	.word	.LANCHOR183
	.word	.LANCHOR94
	.word	.LANCHOR99
	.word	.LANCHOR122
	.word	.LANCHOR118
	.word	.LANCHOR117
	.word	.LANCHOR86
	.word	.LANCHOR184
	.word	.LANCHOR185
	.word	.LANCHOR186
	.word	.LANCHOR82
	.word	.LANCHOR124
	.word	.LANCHOR83
	.word	.LANCHOR123
	.word	.LANCHOR112
	.word	.LANCHOR60
	.word	.LANCHOR119
	.word	.LANCHOR97
	.word	.LANCHOR90
	.word	.LANCHOR66
	.word	.LANCHOR89
	.word	.LANCHOR53
	.word	.LANCHOR77
	.word	.LANCHOR78
.L957:
	ldr	r6, [r2, #28]
	adds	r1, r1, #1
	adds	r6, r6, r0
	adds	r0, r0, r4
	str	r6, [r3, #4]!
.L956:
	cmp	r1, r5
	bcc	.L957
	ldr	r0, .L962
	movs	r3, #0
	mov	r2, r3
	add	r0, r0, r1, lsl #2
	b	.L958
.L959:
	adds	r4, r0, r3
	adds	r1, r1, #1
	adds	r3, r3, #4
	str	r2, [r4, #28]
.L958:
	cmp	r1, #7
	bls	.L959
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L963:
	.align	2
.L962:
	.word	.LANCHOR89
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
	ldr	r3, .L965
	movs	r4, #0
	ldr	r5, .L965+4
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
	ldr	r2, .L965+8
	ldr	r3, [r0, #0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	str	r1, [r2, #0]
	ldr	r2, .L965+12
	and	r3, r3, #245760
	ldr	r1, [r0, #352]
	orr	r3, r3, #256
	ubfx	r1, r1, #16, #4
	str	r1, [r2, #0]
	ldr	r1, [r0, #352]
	ldr	r2, .L965+16
	str	r1, [r2, #0]
	str	r3, [r0, #0]
	str	r4, [r0, #336]
	movs	r0, #40
	bl	NandcTimeCfg
	ldr	r3, [r5, #0]
	movw	r2, #8322
	mov	r0, #36864
	str	r2, [r3, #344]
	ldr	r2, .L965+20
	str	r2, [r3, #304]
	bl	ftl_malloc
	ldr	r3, .L965+24
	str	r0, [r3, #0]
	ldr	r3, .L965+28
	str	r0, [r3, #0]
	add	r0, r0, #32768
	str	r4, [r3, #24]
	str	r0, [r3, #4]
	ldr	r3, .L965+32
	str	r4, [r3, #0]
	pop	{r3, r4, r5, pc}
.L966:
	.align	2
.L965:
	.word	.LANCHOR5
	.word	.LANCHOR30
	.word	.LANCHOR187
	.word	.LANCHOR37
	.word	.LANCHOR40
	.word	1710593
	.word	.LANCHOR188
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
	ldr	r3, .L973
	ldr	r0, [r3, #0]
	bx	lr
.L974:
	.align	2
.L973:
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
	b	.L976
.L982:
	cbnz	r7, .L977
	ldr	r0, .L984
	mov	r1, sl
	mov	r2, r6
	bl	printf
.L977:
	cmp	r5, #4
	ldr	r0, .L984+4
	bne	.L978
	ldr	r1, [r4, r6, lsl #2]
	b	.L983
.L978:
	cmp	r5, #2
	ite	eq
	ldrsheq	r1, [r4, r6, lsl #1]
	ldrbne	r1, [r4, r6]	@ zero_extendqisi2
.L983:
	adds	r7, r7, #1
	bl	printf
	cmp	r7, #15
	bls	.L981
	ldr	r0, .L984+8
	movs	r7, #0
	ldr	r1, .L984+12
	bl	printf
.L981:
	adds	r6, r6, #1
.L976:
	cmp	r6, r8
	bne	.L982
	ldr	r0, .L984+8
	ldr	r1, .L984+12
	pop	{r3, r4, r5, r6, r7, r8, sl, lr}
	b	printf
.L985:
	.align	2
.L984:
	.word	.LC12
	.word	.LC13
	.word	.LC10
	.word	.LC14
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
	ldr	r3, .L1000
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	mov	r7, r1
	ldrb	r8, [r3, #9]	@ zero_extendqisi2
	str	r2, [sp, #12]
	mov	r4, r0
	movs	r6, #0
	ldr	sl, .L1000+28
	b	.L987
.L996:
	subs	r3, r7, r6
	ldr	r1, [sp, #12]
	add	r2, sp, #20
	mov	r0, r4
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #16
	bl	LogAddr2PhyAddr
	ldr	r1, .L1000+4
	ldr	r3, [sp, #16]
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bcc	.L988
	mov	r3, #-1
	str	r3, [r4, #0]
	b	.L989
.L988:
	ldr	r2, .L1000+8
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
	cbz	r3, .L990
	add	r3, r3, #2048
.L990:
	ldr	r2, [r4, #12]
	cbz	r2, .L991
	adds	r2, r2, #8
.L991:
	movs	r1, #0
	str	r2, [sp, #0]
	mov	r0, r5
	mov	r2, r8
	bl	NandcXferData
	mov	r3, r0
	mov	r0, r5
	str	r3, [sp, #8]
	bl	NandcFlashDeCs
	ldr	r2, .L1000+12
	ldr	r3, [sp, #8]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cmp	r3, fp
	it	cc
	movcc	r3, fp
	add	r2, r2, r2, lsl #1
	cmp	r3, r2, lsr #2
	bls	.L992
	cmp	r3, #-1
	ite	eq
	moveq	r3, #-1
	movne	r3, #256
.L992:
	adds	r2, r3, #1
	str	r3, [r4, #0]
	beq	.L993
	cmp	r3, #256
	beq	.L993
	movs	r3, #0
	str	r3, [r4, #0]
.L993:
	ldr	r3, [r4, #12]
	cbz	r3, .L994
	ldr	r2, [r3, #8]
	adds	r0, r2, #1
	bne	.L994
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	it	ne
	strne	r2, [r4, #0]
.L994:
	ldr	r3, [r4, #0]
	adds	r1, r3, #1
	bne	.L989
	ldr	r2, .L1000+12
	ldr	r1, [r4, #4]
	ldr	r0, .L1000+16
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L995
	ldr	r0, .L1000+20
	movs	r2, #4
	movs	r3, #8
	bl	rknand_print_hex
.L995:
	ldr	r1, [r4, #12]
	cbz	r1, .L989
	movs	r2, #4
	ldr	r0, .L1000+24
	mov	r3, r2
	bl	rknand_print_hex
.L989:
	adds	r6, r6, #1
	adds	r4, r4, #36
.L987:
	cmp	r6, r7
	bne	.L996
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1001:
	.align	2
.L1000:
	.word	.LANCHOR18
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR29
	.word	.LC15
	.word	.LC16
	.word	.LC17
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
	ldr	r3, .L1050
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #48
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r0, [sp, #12]
	str	r1, [sp, #32]
	str	r3, [sp, #28]
	ldr	r3, .L1050+4
	str	r2, [sp, #20]
	ldrb	r4, [r3, #0]	@ zero_extendqisi2
	str	r4, [sp, #36]
	ldr	r4, .L1050+8
	ldrb	r4, [r4, #0]	@ zero_extendqisi2
	cmp	r4, #0
	beq	.L1036
	bl	FlashReadSlc2KPages
	b	.L1004
.L1035:
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
	ldr	r2, .L1050+12
	ldr	r3, [sp, #40]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cmp	r3, r2
	mov	r8, r0
	bcc	.L1005
	ldr	r1, [sp, #12]
	mov	r3, #-1
	ldr	r4, [sp, #16]
	str	r3, [r1, r4]
	b	.L1006
.L1005:
	ldr	r2, .L1050+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1050+20
	mov	r0, r4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r8, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1050+24
	ldr	r3, [r3, #0]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #6
	bhi	.L1008
	ldr	r2, .L1050+28
	cmp	r0, #7
	add	r1, r2, r4
	ldrb	r3, [r1, #12]	@ zero_extendqisi2
	it	eq
	ldrbeq	r3, [r1, #20]	@ zero_extendqisi2
	ldr	r1, .L1050+32
	ldrb	r1, [r1, r4]	@ zero_extendqisi2
	cmp	r1, r3
	beq	.L1008
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	mov	r0, r4
	ldr	r2, .L1050+36
	bl	HynixSetRRPara
.L1008:
	mov	r0, r4
	and	r5, r5, #-2147483648
	str	r5, [sp, #24]
	bl	NandcFlashCs
	ldr	r2, [sp, #20]
	cmp	r2, #1
	beq	.L1010
	ldr	r5, [sp, #24]
	cbz	r5, .L1011
.L1010:
	ldr	r3, .L1050+40
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1011
	mov	r0, r4
	bl	flash_enter_slc_mode
	b	.L1012
.L1011:
	mov	r0, r4
	bl	flash_exit_slc_mode
.L1012:
	mov	r5, r7
	movs	r6, #0
	mov	r7, r8
.L1049:
	ldr	r1, [sp, #44]
	adds	r2, r1, #1
	bne	.L1014
	cmp	r4, #255
	beq	.L1038
.L1014:
	cbz	r7, .L1016
	ldr	r3, .L1050+44
	mov	r0, r4
	ldr	r2, [r3, #0]
	adds	r2, r1, r2
	bl	FlashReadDpCmd
	b	.L1017
.L1016:
	mov	r0, r4
	bl	FlashReadCmd
.L1017:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r7, .L1015
	mov	r0, r4
	ldr	r1, [sp, #44]
	bl	FlashReadDpDataOutCmd
	b	.L1015
.L1038:
	movs	r7, #0
.L1015:
	ldr	r3, [r5, #12]
	movs	r1, #0
	mov	r0, r4
	ldr	r2, [sp, #28]
	str	r3, [sp, #0]
	ldr	r3, [r5, #8]
	bl	NandcXferData
	ldr	r1, .L1050+4
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	cbz	r3, .L1040
	adds	r3, r0, #1
	bne	.L1040
	strb	r6, [r1, #0]
	movs	r7, #0
	b	.L1049
.L1040:
	mov	r8, r7
	mov	r7, r5
	mov	r6, r8
	mov	r5, r0
	cmp	r8, #0
	beq	.L1019
	ldr	r2, .L1050+44
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
.L1019:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, [sp, #36]
	ldr	r2, .L1050+4
	adds	r0, r5, #1
	strb	r3, [r2, #0]
	bne	.L1023
	ldr	r3, .L1050+48
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1021
	ldr	r3, .L1050+52
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
	beq	.L1022
	ldr	r3, .L1050+56
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1043
.L1022:
	ubfx	r0, r6, #8, #8
	bl	NandcSetDdrPara
	adds	r2, r5, #1
	bne	.L1043
.L1021:
	ldr	r3, .L1050+60
	mov	r0, r4
	ldr	r1, [sp, #44]
	ldr	r2, [r7, #8]
	ldr	r6, [r3, #0]
	ldr	r3, [r7, #12]
	cmp	r6, #0
	beq	.L1024
	blx	r6
	adds	r3, r0, #1
	mov	r5, r0
	bne	.L1045
	ldr	r3, .L1050+24
	ldr	r3, [r3, #0]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1026
	ldr	r2, .L1050+28
	mov	r0, r4
	movs	r3, #0
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	adds	r2, r2, #4
	bl	HynixSetRRPara
.L1026:
	ldr	r1, [sp, #44]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r3, [r7, #12]
	bl	FlashReadRawPage
	ldr	r3, .L1050+56
	ldr	r1, [r7, #4]
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	mov	r5, r0
	ldr	r0, .L1050+64
	mov	r3, r5
	bl	printf
	adds	r6, r5, #1
	bne	.L1045
	ldr	r3, .L1050+40
	ldrb	r6, [r3, #0]	@ zero_extendqisi2
	cmp	r6, #0
	beq	.L1025
	ldr	r1, [sp, #20]
	mov	r0, r4
	cmp	r1, #1
	beq	.L1027
	ldr	r2, [sp, #24]
	cbz	r2, .L1028
.L1027:
	bl	flash_enter_slc_mode
	b	.L1029
.L1028:
	bl	flash_exit_slc_mode
.L1029:
	ldr	r3, .L1050+60
	mov	r0, r4
	ldr	r1, [sp, #44]
	ldr	r2, [r7, #8]
	ldr	r5, [r3, #0]
	ldr	r3, [r7, #12]
	blx	r5
	mov	r5, r0
	b	.L1045
.L1024:
	bl	FlashReadRawPage
	mov	r5, r0
	b	.L1025
.L1051:
	.align	2
.L1050:
	.word	.LANCHOR18
	.word	.LANCHOR4
	.word	.LANCHOR0
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR189
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
	.word	.LC18
.L1043:
	movs	r6, #0
.L1023:
	ldr	r3, .L1052
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r5, r3, lsr #2
	bls	.L1025
	ldr	r3, .L1052+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	it	eq
	moveq	r5, #256
	b	.L1025
.L1045:
	movs	r6, #0
.L1025:
	ldr	r1, [sp, #12]
	adds	r0, r5, #1
	ldr	r3, [sp, #16]
	str	r5, [r1, r3]
	beq	.L1030
	cmp	r5, #256
	beq	.L1030
	ldr	r2, [sp, #16]
	movs	r3, #0
	str	r3, [r1, r2]
.L1030:
	ldr	r1, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r3, [r2, r1]
	adds	r1, r3, #1
	bne	.L1031
	ldr	r2, .L1052
	ldr	r1, [r7, #4]
	ldr	r0, .L1052+8
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1031
	movs	r2, #4
	ldr	r0, .L1052+12
	mov	r3, r2
	bl	rknand_print_hex
.L1031:
	cbz	r6, .L1032
	ldr	r3, .L1052
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	sl, r3, lsr #2
	bls	.L1033
	ldr	r3, .L1052+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	it	eq
	moveq	sl, #256
.L1033:
	ldr	r1, [sp, #12]
	movs	r2, #36
	add	r3, fp, #1
	muls	r3, r2, r3
	cmp	sl, #-1
	str	sl, [r1, r3]
	beq	.L1032
	cmp	sl, #256
	beq	.L1032
	movs	r2, #0
	str	r2, [r1, r3]
.L1032:
	ldr	r2, [sp, #20]
	add	fp, fp, r6
	cmp	r2, #1
	beq	.L1034
	ldr	r3, [sp, #24]
	cbz	r3, .L1006
.L1034:
	ldr	r3, .L1052+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1006
	mov	r0, r4
	bl	flash_exit_slc_mode
.L1006:
	add	fp, fp, #1
	b	.L1003
.L1036:
	mov	sl, r4
	mov	fp, r4
.L1003:
	ldr	r4, [sp, #32]
	cmp	fp, r4
	bcc	.L1035
	movs	r0, #0
.L1004:
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1053:
	.align	2
.L1052:
	.word	.LANCHOR29
	.word	.LANCHOR51
	.word	.LC15
	.word	.LC17
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
	ldr	r3, .L1078
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r5, r0
	ldrh	r4, [r3, #0]
	movw	r3, #65535
	sub	sp, sp, #24
	cmp	r4, r3
	beq	.L1072
	cbnz	r4, .L1055
	b	.L1056
.L1072:
	movs	r4, #0
.L1055:
	ldr	r3, .L1078+4
	ldrh	r3, [r3, #0]
	cmp	r1, r3
	bne	.L1057
.L1056:
	bl	FtlGcPageVarInit
.L1057:
	mov	sl, #-1
	movw	r8, #65535
.L1069:
	ldrh	r3, [r5, #0]
	movs	r2, #0
	strb	r2, [r5, #8]
	cmp	r3, r8
	beq	.L1058
.L1059:
	mov	fp, sl
.L1076:
	ldr	r3, .L1078+8
	ldr	r2, .L1078+12
	ldr	r0, .L1078+16
	ldr	lr, [r3, #0]
	ldr	r3, .L1078+20
	ldr	ip, [r2, #0]
	mov	r2, r5
	ldrh	sl, [r0, #0]
	ldrh	r7, [r3, #0]
	movs	r3, #0
	mov	r6, r3
	str	ip, [sp, #8]
	str	r5, [sp, #4]
	b	.L1060
.L1062:
	ldrh	r0, [r2, #16]
	cmp	r0, r8
	beq	.L1061
	ldr	r5, [sp, #8]
	mov	ip, #36
	orr	r0, r4, r0, lsl #10
	mla	r1, ip, r6, r5
	str	r0, [r1, #4]
	movs	r0, #0
	str	r0, [r1, #8]
	mul	r0, r7, r6
	adds	r6, r6, #1
	uxth	r6, r6
	bic	r0, r0, #3
	add	r0, lr, r0
	str	r0, [r1, #12]
.L1061:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1060:
	cmp	r3, sl
	bne	.L1062
	ldr	r2, .L1078+12
	mov	r1, r6
	movs	r7, #0
	ldr	r5, [sp, #4]
	mov	sl, r7
	ldr	r0, [r2, #0]
	movs	r2, #0
	bl	FlashReadPages
	b	.L1063
.L1070:
	ldr	r0, .L1078+12
	ldr	r3, [r0, #0]
	adds	r2, r3, r7
	ldr	r1, [r2, #4]
	str	r2, [sp, #20]
	ubfx	r0, r1, #10, #16
	str	r3, [sp, #16]
	str	r1, [sp, #12]
	bl	P2V_plane
	ldr	r3, [sp, #16]
	ldr	r1, [sp, #12]
	ldr	r2, [sp, #20]
	ldr	r3, [r3, r7]
	cbnz	r3, .L1064
	ldr	r3, [r2, #12]
	adds	r7, r7, #36
	ldrh	r2, [r3, #0]
	cmp	r2, r8
	bne	.L1065
	ldr	r3, .L1078+24
	movs	r1, #1
	mov	r2, r0
	mov	sl, fp
	str	r1, [r3, #0]
	b	.L1058
.L1065:
	add	sl, sl, #1
	ldr	r0, [r3, #12]
	ldr	r2, [r3, #8]
	bl	FtlGcUpdatePage
	uxth	sl, sl
	b	.L1063
.L1064:
	ldr	r2, .L1078+28
	mov	sl, fp
	ldr	r2, [r2, #0]
	cbnz	r2, .L1066
	ldr	r2, .L1078+32
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1067
.L1066:
	ldr	r2, .L1078+36
	ldrh	r0, [r5, #0]
	ldr	r2, [r2, #0]
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r2, #119
	bls	.L1074
.L1067:
	cmp	r3, #-1
	it	eq
	moveq	sl, r1
	b	.L1068
.L1074:
	mov	sl, r1
.L1068:
	ldr	r3, .L1078+40
	movs	r4, #0
	ldrh	r2, [r5, #0]
	ldr	r3, [r3, #0]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5, #0]
	bl	INSERT_FREE_LIST
	strh	r8, [r5, #0]	@ movhi
	bl	FtlGcPageVarInit
	b	.L1069
.L1063:
	cmp	sl, r6
	bne	.L1070
	ldr	r3, .L1078+4
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3, #0]
	cmp	r3, r4
	bhi	.L1076
	mov	sl, fp
	movs	r2, #0
.L1058:
	ldr	r3, .L1078
	mov	r0, r5
	movw	r1, #65535
	strh	r4, [r5, #2]	@ movhi
	strb	r2, [r5, #6]
	strh	r1, [r3, #0]	@ movhi
	mov	r1, r4
	bl	ftl_sb_update_avl_pages
	mov	r0, sl
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1079:
	.align	2
.L1078:
	.word	.LANCHOR190
	.word	.LANCHOR68
	.word	.LANCHOR130
	.word	.LANCHOR173
	.word	.LANCHOR53
	.word	.LANCHOR74
	.word	.LANCHOR137
	.word	.LANCHOR126
	.word	.LANCHOR7
	.word	.LANCHOR94
	.word	.LANCHOR99
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
	ldr	r3, .L1141
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r4, #0
	ldr	r5, .L1141+4
	sub	sp, sp, #40
	strh	r4, [r3, #0]	@ movhi
	mov	r1, r4
	ldr	r3, .L1141+8
	ldr	r2, [r5, #0]
	ldr	r7, .L1141+12
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1141+16
	lsls	r2, r2, #2
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r2, [r5, #0]
	ldr	r3, .L1141+20
	mov	r1, r4
	ldr	r5, .L1141+24
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldr	r3, .L1141+28
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #2
	bl	memset
	ldr	r3, .L1141+32
	ldrh	r2, [r5, #0]
	mov	r1, r4
	ldr	r0, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	ldr	r0, .L1141+36
	movs	r1, #255
	movs	r2, #12
	bl	memset
	ldr	r3, .L1141+40
	ldrh	r3, [r3, #0]
	str	r3, [sp, #24]
	b	.L1081
.L1083:
	ldrb	r0, [fp, r4]	@ zero_extendqisi2
	ldr	r1, [sp, #24]
	str	r3, [sp, #4]
	bl	V2P_block
	str	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #4]
	cbnz	r0, .L1082
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
.L1082:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1118
.L1130:
	movs	r3, #0
	ldr	fp, .L1141+76
	ldr	r8, .L1141+80
	mov	r4, r3
	ldr	r6, .L1141+44
	mov	sl, #36
	ldr	r5, .L1141+48
	str	r3, [sp, #20]
.L1118:
	ldr	r1, .L1141+52
	ldrh	r2, [r1, #0]
	cmp	r2, r4
	bhi	.L1083
	str	r3, [sp, #20]
	cmp	r3, #0
	beq	.L1084
	ldr	r0, [r7, #0]
	mov	r1, r3
	movs	r2, #1
	movs	r6, #0
	bl	FlashReadPages
	str	r6, [sp, #32]
.L1117:
	ldr	r3, [r7, #0]
	adds	r2, r3, r6
	ldr	r3, [r3, r6]
	ldr	r5, [r2, #4]
	adds	r3, r3, #1
	ldr	r4, [r2, #12]
	ubfx	r5, r5, #10, #16
	bne	.L1085
	mov	r8, #16
.L1087:
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
	bne	.L1086
	ldr	r1, .L1141+12
	mov	r2, #-1
	ldr	r3, [r1, #0]
	str	r2, [r3, r6]
	b	.L1085
.L1086:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	bne	.L1085
	add	r8, r8, #-1
	uxth	r8, r8
	cmp	r8, #0
	bne	.L1087
.L1085:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	beq	.L1088
	ldr	r2, .L1141+56
	ldr	r3, [r4, #4]
	ldr	r1, [r2, #0]
	adds	r0, r1, #1
	beq	.L1089
	cmp	r1, r3
	bhi	.L1090
.L1089:
	adds	r1, r3, #1
	beq	.L1090
	adds	r3, r3, #1
	str	r3, [r2, #0]
.L1090:
	ldrh	r3, [r4, #0]
	movw	r2, #61604
	cmp	r3, r2
	beq	.L1093
	bhi	.L1096
	movw	r2, #61574
	cmp	r3, r2
	bne	.L1091
	b	.L1139
.L1096:
	movw	r2, #61634
	cmp	r3, r2
	beq	.L1094
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1091
	b	.L1140
.L1094:
	ldr	r3, .L1141
	ldr	r8, .L1141+4
	ldrh	r2, [r3, #0]
	ldr	r3, [r8, #0]
	cmp	r2, r3
	bls	.L1097
	ldr	r1, .L1141+60
	movw	r2, #1183
	ldr	r0, .L1141+64
	bl	printf
	ldr	r0, .L1141+68
	ldr	r1, .L1141+72
	bl	printf
.L1097:
	ldr	r3, [r8, #0]
	mov	ip, #0
	ldr	r1, .L1141
	uxth	r2, r3
	str	r3, [sp, #12]
	subs	r3, r2, #1
	ldrh	r0, [r1, #0]
	ldr	r1, .L1141+16
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
	b	.L1098
.L1104:
	rsb	r2, ip, fp
	str	r2, [sp, #28]
	ldr	r2, [sp, #16]
	add	ip, ip, #1
	ldr	r8, [r4, #4]
	subs	r5, r2, #4
	str	r5, [sp, #16]
	ldr	r5, [r2, #0]
	cmp	r8, r5
	bls	.L1099
	ldr	ip, [r1, #0]
	mov	r5, sl
	str	r2, [sp, #16]
	cmp	ip, #0
	bne	.L1100
	ldr	r2, [sp, #12]
	cmp	r0, r2
	beq	.L1100
	add	ip, r0, #1
	ldr	r0, .L1141
	strh	ip, [r0, #0]	@ movhi
.L1100:
	ldr	r0, .L1141+20
	sxth	sl, r3
	mov	fp, r3
	str	sl, [sp, #12]
	mov	r3, r1
	ldr	ip, [r0, #0]
	movs	r0, #0
	mov	r8, ip
	b	.L1101
.L1102:
	ldr	sl, [r1, #4]!
	adds	r0, r0, #1
	uxth	r0, r0
	str	sl, [r3], #4
	ldrh	sl, [ip, #2]!
	strh	sl, [r8], #2	@ movhi
.L1101:
	ldr	r2, [sp, #12]
	sxth	sl, r0
	cmp	sl, r2
	bne	.L1102
	ldr	r1, [r4, #4]
	mov	r3, fp
	ldr	r2, [sp, #16]
	ldr	sl, [sp, #28]
	str	r1, [r2, #0]
	ldr	r2, .L1141+20
	ldr	r2, [r2, #0]
	strh	r5, [r2, sl, lsl #1]	@ movhi
	b	.L1103
.L1099:
	subs	r3, r3, #1
	uxth	r3, r3
.L1098:
	ldr	r5, [sp, #36]
	sxth	r2, r3
	cmp	r2, r5
	bgt	.L1104
	mov	r5, sl
.L1103:
	sxth	r3, r3
	cmp	r3, #0
	blt	.L1091
	ldr	r2, .L1141
	ldr	r0, .L1141+4
	ldrh	r1, [r2, #0]
	ldr	r0, [r0, #0]
	subs	r0, r0, r1
	subs	r0, r0, #1
	sxth	r0, r0
	cmp	r3, r0
	bgt	.L1091
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
	ldr	r2, .L1141+16
	ldr	r1, [r4, #4]
	ldr	r2, [r2, #0]
	str	r1, [r2, r3, lsl #2]
	ldr	r2, .L1141+20
	b	.L1137
.L1142:
	.align	2
.L1141:
	.word	.LANCHOR121
	.word	.LANCHOR80
	.word	.LANCHOR85
	.word	.LANCHOR173
	.word	.LANCHOR123
	.word	.LANCHOR122
	.word	.LANCHOR77
	.word	.LANCHOR185
	.word	.LANCHOR86
	.word	.LANCHOR191
	.word	.LANCHOR55
	.word	.LANCHOR130
	.word	.LANCHOR74
	.word	.LANCHOR53
	.word	.LANCHOR153
	.word	.LANCHOR192
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR62
	.word	.LANCHOR129
.L1139:
	ldr	r3, .L1143
	ldr	r8, .L1143+28
	ldrh	r2, [r3, #0]
	ldrh	r3, [r8, #0]
	cmp	r2, r3
	bls	.L1105
	ldr	r1, .L1143+4
	movw	r2, #1230
	ldr	r0, .L1143+8
	bl	printf
	ldr	r0, .L1143+12
	ldr	r1, .L1143+16
	bl	printf
.L1105:
	ldr	r1, .L1143
	mov	ip, #0
	ldrh	r8, [r8, #0]
	ldrh	r0, [r1, #0]
	add	r2, r8, #-1
	str	r8, [sp, #16]
	uxth	r3, r2
	subs	r2, r2, r0
	str	r2, [sp, #36]
	ldr	r2, .L1143+20
	sxth	fp, r3
	ldr	r1, [r2, #0]
	add	sl, r1, fp, lsl #2
	str	sl, [sp, #28]
	mov	sl, r5
	b	.L1106
.L1112:
	ldr	r2, [sp, #28]
	add	ip, ip, #1
	ldr	r8, [r4, #4]
	subs	r5, r2, #4
	str	r5, [sp, #28]
	ldr	r5, [r2, #0]
	cmp	r8, r5
	bls	.L1107
	ldr	ip, [r1, #0]
	mov	r5, sl
	cmp	ip, #0
	bne	.L1108
	ldr	sl, [sp, #16]
	cmp	r0, sl
	beq	.L1108
	add	ip, r0, #1
	ldr	r0, .L1143
	strh	ip, [r0, #0]	@ movhi
.L1108:
	ldr	r0, .L1143+24
	sxth	sl, r3
	mov	fp, r3
	str	sl, [sp, #16]
	str	r2, [sp, #28]
	mov	r3, r1
	ldr	ip, [r0, #0]
	movs	r0, #0
	mov	r8, ip
	b	.L1109
.L1110:
	ldr	sl, [r1, #4]!
	adds	r0, r0, #1
	uxth	r0, r0
	str	sl, [r3], #4
	ldrh	sl, [r8, #2]!
	strh	sl, [ip], #2	@ movhi
.L1109:
	ldr	r2, [sp, #16]
	sxth	sl, r0
	cmp	sl, r2
	bne	.L1110
	ldr	r2, [sp, #28]
	mov	r3, fp
	ldr	r1, [r4, #4]
	ldr	sl, [sp, #12]
	str	r1, [r2, #0]
	ldr	r2, .L1143+24
	ldr	r2, [r2, #0]
	strh	r5, [r2, sl, lsl #1]	@ movhi
	b	.L1111
.L1107:
	subs	r3, r3, #1
	uxth	r3, r3
.L1106:
	ldr	r5, [sp, #36]
	rsb	r2, ip, fp
	str	r2, [sp, #12]
	cmp	r2, r5
	bgt	.L1112
	mov	r5, sl
.L1111:
	sxth	r3, r3
	cmp	r3, #0
	blt	.L1091
	ldr	r0, .L1143+28
	ldr	r2, .L1143
	ldrh	r0, [r0, #0]
	ldrh	r1, [r2, #0]
	subs	r0, r0, #1
	subs	r0, r0, r1
	sxth	r0, r0
	cmp	r3, r0
	bgt	.L1091
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
	ldr	r2, .L1143+20
	ldr	r1, [r4, #4]
	ldr	r2, [r2, #0]
	str	r1, [r2, r3, lsl #2]
	ldr	r2, .L1143+24
.L1137:
	ldr	r2, [r2, #0]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L1091
.L1093:
	ldr	r8, .L1143+32
	movw	sl, #65535
	ldrh	r3, [r8, #0]
	cmp	r3, sl
	bne	.L1113
	ldr	r3, [r4, #4]
	strh	r5, [r8, #0]	@ movhi
	str	r3, [r8, #8]
	b	.L1091
.L1113:
	ldrh	r0, [r8, #4]
	movw	ip, #65535
	cmp	r0, ip
	beq	.L1114
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L1114:
	ldr	r2, [r4, #4]
	ldr	r1, [r8, #8]
	ldr	r3, .L1143+32
	cmp	r1, r2
	bcs	.L1115
	ldrh	r1, [r3, #0]
	str	r2, [r3, #8]
	strh	r5, [r3, #0]	@ movhi
	strh	r1, [r3, #4]	@ movhi
	b	.L1091
.L1115:
	strh	r5, [r3, #4]	@ movhi
	b	.L1091
.L1140:
	mov	r0, r5
	b	.L1138
.L1088:
	ldr	r1, .L1143+36
	mov	r0, r5
	ldrb	r3, [r1, #0]	@ zero_extendqisi2
	cbz	r3, .L1116
.L1138:
	movs	r1, #0
	b	.L1136
.L1116:
	movs	r1, #1
.L1136:
	bl	FtlFreeSysBlkQueueIn
.L1091:
	ldr	r5, [sp, #32]
	adds	r6, r6, #36
	adds	r3, r5, #1
	ldr	r5, [sp, #20]
	uxth	r3, r3
	str	r3, [sp, #32]
	cmp	r3, r5
	bne	.L1117
.L1084:
	ldr	sl, [sp, #24]
	add	r3, sl, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L1081:
	ldr	r3, .L1143+40
	ldr	ip, [sp, #24]
	ldrh	r3, [r3, #0]
	cmp	r3, ip
	bhi	.L1130
	ldr	r3, .L1143+44
	ldr	r1, [r3, #0]
	ldrh	r3, [r1, #0]
	cbnz	r3, .L1119
	ldr	r2, .L1143+48
	ldrh	r2, [r2, #0]
	cbz	r2, .L1119
	ldr	r2, .L1143+52
	ldr	r4, [r2, #0]
	mov	r2, r1
	b	.L1120
.L1123:
	ldrh	r5, [r2], #2
	adds	r3, r3, #1
	cbz	r5, .L1120
	ldr	r3, .L1143+56
	sxth	r0, r0
	ldr	ip, .L1143+52
	mov	sl, r1
	add	r6, r1, r0, lsl #1
	ldr	r5, [r3, #0]
	movs	r3, #0
	mov	r2, r3
	mov	r4, r3
	add	r7, r5, r0, lsl #2
	mov	fp, r3
	b	.L1121
.L1122:
	ldrh	r1, [r6, r2]
	strh	r1, [sl, r2]	@ movhi
	ldr	r1, [r7, r3]
	str	r1, [r5, r3]
	adds	r3, r3, #4
	strh	fp, [r6, r2]	@ movhi
	adds	r2, r2, #2
.L1121:
	ldr	r1, [ip, #0]
	add	r8, r4, r0
	adds	r4, r4, #1
	cmp	r8, r1
	bcc	.L1122
	b	.L1119
.L1120:
	cmp	r3, r4
	uxth	r0, r3
	bne	.L1123
.L1119:
	ldr	r3, .L1143+24
	ldr	r0, [r3, #0]
	ldrh	r3, [r0, #0]
	cmp	r3, #0
	bne	.L1124
	ldr	r2, .L1143
	ldrh	r2, [r2, #0]
	cmp	r2, #0
	beq	.L1124
	ldr	r2, .L1143+28
	ldrh	r4, [r2, #0]
	mov	r2, r0
	b	.L1125
.L1128:
	ldrh	r5, [r2], #2
	adds	r3, r3, #1
	cmp	r5, #0
	beq	.L1125
	ldr	r3, .L1143+20
	sxth	r1, r1
	subs	r6, r1, r6
	add	r7, r0, r1, lsl #1
	ldr	r5, [r3, #0]
	movs	r3, #0
	mov	r2, r3
	mov	r4, r3
	add	r0, r0, r6, lsl #1
	add	ip, r5, r1, lsl #2
	b	.L1126
.L1127:
	ldrh	r8, [r7, r2]
	ldr	sl, [ip, r3]
	strh	r8, [r0, r2]	@ movhi
	add	r8, r5, r6, lsl #2
	str	sl, [r8, r3]
	mov	r8, #0
	adds	r3, r3, #4
	strh	r8, [r7, r2]	@ movhi
	adds	r2, r2, #2
.L1126:
	ldr	r8, .L1143+28
	add	sl, r4, r1
	adds	r4, r4, #1
	ldrh	r8, [r8, #0]
	cmp	sl, r8
	blt	.L1127
	b	.L1124
.L1144:
	.align	2
.L1143:
	.word	.LANCHOR85
	.word	.LANCHOR192
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR185
	.word	.LANCHOR86
	.word	.LANCHOR77
	.word	.LANCHOR191
	.word	.LANCHOR7
	.word	.LANCHOR56
	.word	.LANCHOR122
	.word	.LANCHOR121
	.word	.LANCHOR80
	.word	.LANCHOR123
.L1125:
	cmp	r3, r4
	uxth	r1, r3
	mov	r6, r3
	blt	.L1128
.L1124:
	ldr	r3, .L1145
	ldrh	r2, [r3, #0]
	ldr	r3, .L1145+4
	ldr	r3, [r3, #0]
	cmp	r2, r3
	bls	.L1129
	ldr	r1, .L1145+8
	movw	r2, #1364
	ldr	r0, .L1145+12
	bl	printf
	ldr	r0, .L1145+16
	ldr	r1, .L1145+20
	bl	printf
.L1129:
	movs	r0, #0
	add	sp, sp, #40
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1146:
	.align	2
.L1145:
	.word	.LANCHOR121
	.word	.LANCHOR80
	.word	.LANCHOR192
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlVendorPartRead,"ax",%progbits
	.align	1
	.global	FtlVendorPartRead
	.thumb
	.thumb_func
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1157
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r8, r2
	ldrh	sl, [r3, #0]
	adds	r2, r1, r0
	ldr	r3, .L1157+4
	sub	sp, sp, #48
	mov	r6, r0
	mov	r5, r1
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bhi	.L1155
	lsr	sl, r0, sl
	movs	r7, #0
	lsl	sl, sl, #2
	b	.L1149
.L1154:
	ldr	r1, .L1157+8
	mov	r0, r6
	ldr	r2, .L1157+12
	ldr	r3, [r1, #0]
	ldrh	r4, [r2, #0]
	mov	r1, r4
	ldr	fp, [r3, sl]
	bl	__aeabi_uidivmod
	uxth	r3, r1
	subs	r4, r4, r3
	uxth	r4, r4
	cmp	r4, r5
	it	hi
	uxthhi	r4, r5
	cmp	fp, #0
	beq	.L1151
	ldr	r1, .L1157+16
	add	r0, sp, #12
	str	fp, [sp, #16]
	ldr	r2, [r1, #0]
	movs	r1, #1
	str	r3, [sp, #4]
	str	r2, [sp, #20]
	movs	r2, #0
	str	r2, [sp, #24]
	mov	r2, r1
	bl	FlashReadPages
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	mov	r0, r8
	cmp	r2, #-1
	it	eq
	moveq	r7, #-1
	ldr	r2, .L1157+16
	ldr	r1, [r2, #0]
	lsls	r2, r4, #9
	add	r1, r1, r3, lsl #9
	bl	memcpy
	b	.L1153
.L1151:
	mov	r0, r8
	mov	r1, fp
	lsls	r2, r4, #9
	bl	memset
.L1153:
	subs	r5, r5, r4
	adds	r6, r6, r4
	add	r8, r8, r4, lsl #9
	add	sl, sl, #4
.L1149:
	cmp	r5, #0
	bne	.L1154
	b	.L1148
.L1155:
	mov	r7, #-1
.L1148:
	mov	r0, r7
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1158:
	.align	2
.L1157:
	.word	.LANCHOR72
	.word	.LANCHOR65
	.word	.LANCHOR186
	.word	.LANCHOR71
	.word	.LANCHOR177
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
	ldr	r4, .L1163
	movs	r1, #1
	ldr	r5, .L1163+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4, #0]
	cmp	r3, r5
	beq	.L1160
	mov	r0, r4
	movs	r1, #0
	mov	r2, #512
	bl	memset
	str	r5, [r4, #0]
.L1160:
	ldr	r2, [r4, #0]
	ldr	r3, .L1163
	cmp	r2, r5
	bne	.L1161
	ldr	r1, [r3, #88]
	ldr	r2, .L1163+8
	str	r1, [r2, #0]
	ldr	r1, [r3, #92]
	ldr	r2, .L1163+12
	str	r1, [r2, #0]
	ldr	r1, [r3, #8]
	ldr	r2, .L1163+16
	str	r1, [r2, #0]
	ldr	r1, [r3, #12]
	ldr	r2, .L1163+20
	str	r1, [r2, #0]
	ldr	r1, [r3, #16]
	ldr	r2, .L1163+24
	str	r1, [r2, #0]
	ldr	r1, [r3, #20]
	ldr	r2, .L1163+28
	str	r1, [r2, #0]
	ldr	r1, [r3, #28]
	ldr	r2, .L1163+32
	str	r1, [r2, #0]
	ldr	r1, [r3, #32]
	ldr	r2, .L1163+36
	str	r1, [r2, #0]
	ldr	r1, [r3, #36]
	ldr	r2, .L1163+40
	str	r1, [r2, #0]
	ldr	r1, [r3, #40]
	ldr	r2, .L1163+44
	str	r1, [r2, #0]
	ldr	r1, [r3, #44]
	ldr	r2, .L1163+48
	str	r1, [r2, #0]
	ldr	r1, [r3, #48]
	ldr	r2, .L1163+52
	str	r1, [r2, #0]
	ldr	r2, [r3, #60]
	ldr	r3, .L1163+56
	str	r2, [r3, #0]
.L1161:
	ldr	r3, .L1163+60
	movs	r2, #0
	str	r2, [r3, #0]
	ldr	r3, .L1163
	ldr	r2, [r3, #68]
	ldr	r3, .L1163+64
	cmp	r2, r3
	bne	.L1162
	ldr	r3, .L1163+68
	movs	r2, #1
	ldr	r0, .L1163+72
	ldr	r1, .L1163+76
	str	r2, [r3, #0]
	bl	printf
.L1162:
	ldr	r3, .L1163+80
	ldrh	r2, [r3, #0]
	ldr	r3, .L1163+84
	ldr	r0, [r3, #0]
	ldr	r3, .L1163+32
	ldr	r3, [r3, #0]
	mla	r0, r0, r2, r3
	ldr	r3, .L1163+88
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1163+92
	str	r0, [r3, #0]
	pop	{r3, r4, r5, pc}
.L1164:
	.align	2
.L1163:
	.word	.LANCHOR141
	.word	1179929683
	.word	.LANCHOR193
	.word	.LANCHOR194
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR160
	.word	.LANCHOR159
	.word	.LANCHOR162
	.word	.LANCHOR95
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR152
	.word	.LANCHOR151
	.word	305432421
	.word	.LANCHOR126
	.word	.LC10
	.word	.LC19
	.word	.LANCHOR63
	.word	.LANCHOR161
	.word	.LANCHOR55
	.word	.LANCHOR195
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
	ldr	r4, .L1167
	ldr	r5, .L1167+4
	ldr	r2, [r4, #0]
	ldrh	r1, [r5, #0]
	bl	FtlVendorPartRead
	ldr	r3, [r4, #0]
	ldr	r2, [r3, #0]
	ldr	r3, .L1167+8
	cmp	r2, r3
	beq	.L1166
	ldr	r1, .L1167+12
	ldr	r0, .L1167+16
	bl	printf
	ldrh	r2, [r5, #0]
	ldr	r0, [r4, #0]
	movs	r1, #0
	lsls	r2, r2, #9
	bl	memset
.L1166:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1168:
	.align	2
.L1167:
	.word	.LANCHOR183
	.word	.LANCHOR182
	.word	1112818501
	.word	.LC20
	.word	.LC10
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.global	load_l2p_region
	.thumb
	.thumb_func
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1174
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldrh	r3, [r3, #0]
	mov	r8, r1
	cmp	r3, r0
	bcs	.L1170
	ldr	r1, .L1174+4
	movw	r2, #467
	ldr	r0, .L1174+8
	bl	printf
	ldr	r0, .L1174+12
	ldr	r1, .L1174+16
	bl	printf
.L1170:
	ldr	r3, .L1174+20
	ldr	r7, .L1174+24
	ldr	r3, [r3, #0]
	ldr	r6, [r3, r4, lsl #2]
	movs	r3, #12
	cbnz	r6, .L1171
	mul	r5, r3, r8
	ldr	r3, [r7, #0]
	movs	r1, #255
	adds	r3, r3, r5
	ldr	r0, [r3, #8]
	ldr	r3, .L1174+28
	ldrh	r2, [r3, #0]
	bl	memset
	ldr	r3, [r7, #0]
	adds	r2, r3, r5
	strh	r4, [r3, r5]	@ movhi
	str	r6, [r2, #4]
	b	.L1172
.L1171:
	ldr	r5, .L1174+32
	movs	r1, #1
	mov	r2, r1
	mov	r0, r5
	str	r6, [r5, #4]
	mul	r6, r3, r8
	ldr	r3, [r7, #0]
	adds	r3, r3, r6
	ldr	r3, [r3, #8]
	str	r3, [r5, #8]
	ldr	r3, .L1174+36
	ldr	r3, [r3, #0]
	str	r3, [r5, #12]
	bl	FlashReadPages
	ldr	r3, [r5, #12]
	ldrh	r3, [r3, #8]
	cmp	r3, r4
	beq	.L1173
	ldr	r1, .L1174+4
	mov	r2, #488
	ldr	r0, .L1174+8
	bl	printf
	ldr	r0, .L1174+12
	ldr	r1, .L1174+16
	bl	printf
.L1173:
	ldr	r3, .L1174+24
	movs	r1, #0
	ldr	r3, [r3, #0]
	adds	r2, r3, r6
	strh	r4, [r3, r6]	@ movhi
	str	r1, [r2, #4]
.L1172:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L1175:
	.align	2
.L1174:
	.word	.LANCHOR82
	.word	.LANCHOR196
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR124
	.word	.LANCHOR112
	.word	.LANCHOR73
	.word	.LANCHOR197
	.word	.LANCHOR180
	.size	load_l2p_region, .-load_l2p_region
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
	ldreq	r3, .L1187
	mov	r5, r1
	it	ne
	ldrne	r3, .L1187+4
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
	bne	.L1180
	b	.L1185
.L1183:
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
	bne	.L1181
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	bne	.L1181
	ldr	r3, [sp, #68]
	adds	r3, r3, #1
	beq	.L1181
	subs	r4, r6, #1
	uxth	r4, r4
	b	.L1185
.L1181:
	adds	r6, r6, #1
	uxth	r7, r6
.L1185:
	sxth	r6, r7
	sxth	r3, r4
	cmp	r6, r3
	ble	.L1183
.L1180:
	sxth	r0, r4
	add	sp, sp, #108
	pop	{r4, r5, r6, r7, r8, sl, pc}
.L1188:
	.align	2
.L1187:
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
	ldr	r6, .L1209
	mov	r1, r4
	ldr	r5, .L1209+4
	ldr	r8, .L1209+48
	ldr	r3, [r6, #0]
	str	r4, [r5, #8]
	str	r3, [r5, #12]
	ldr	r3, .L1209+8
	ldrh	r2, [r3, #0]
	ldr	r3, .L1209+12
	lsls	r2, r2, #1
	ldr	r0, [r3, #0]
	bl	memset
	ldrh	r0, [r8, #0]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1205
	movs	r1, #1
	mov	fp, r8
	bl	FtlGetLastWrittenPage
	uxth	sl, r0
	mov	r7, r0
	add	r3, sl, #1
	strh	r3, [r8, #2]	@ movhi
	ldr	r8, .L1209+148
	ldr	r3, .L1209+16
	b	.L1191
.L1194:
	ldrh	r1, [fp, #0]
	sxth	r2, sl
	subs	r2, r2, r4
	ldr	r0, .L1209+4
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
	beq	.L1192
	ldr	r2, [r8, #0]
	ldr	r2, [r2, #0]
	cmp	r2, r3
	bne	.L1192
	ldr	r2, [r6, #0]
	ldrh	r1, [r2, #0]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L1193
.L1192:
	adds	r4, r4, #1
.L1191:
	subs	r2, r7, r4
	lsls	r2, r2, #16
	bpl	.L1194
	b	.L1208
.L1193:
	ldr	r3, .L1209+8
	ldrh	r2, [r3, #0]
	ldr	r3, .L1209+20
	adds	r2, r2, #24
	ldrh	r3, [r3, #0]
	cmp	r3, r2, lsl #1
	bcs	.L1196
	ldr	r1, .L1209+24
	movw	r2, #1426
	ldr	r0, .L1209+28
	bl	printf
	ldr	r0, .L1209+32
	ldr	r1, .L1209+36
	bl	printf
.L1196:
	ldr	r5, .L1209+4
	movs	r2, #48
	ldr	r4, .L1209+40
	ldr	r6, .L1209+8
	ldr	r1, [r5, #8]
	mov	r0, r4
	bl	memcpy
	ldr	r3, .L1209+12
	ldrh	r2, [r6, #0]
	ldr	r1, [r5, #8]
	ldr	r0, [r3, #0]
	adds	r1, r1, #48
	lsls	r2, r2, #1
	bl	memcpy
	ldrh	r2, [r6, #0]
	ldr	r0, .L1209+44
	add	r1, r2, #24
	ldr	r3, [r5, #8]
	lsrs	r2, r2, #3
	lsrs	r1, r1, #1
	adds	r2, r2, #4
	ldr	r0, [r0, #0]
	add	r1, r3, r1, lsl #2
	bl	memcpy
	ldr	r2, [r4, #0]
	ldr	r3, .L1209+16
	cmp	r2, r3
	bne	.L1205
	ldr	r3, .L1209+48
	ldrh	r5, [r4, #8]
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	strh	r5, [r3, #6]	@ movhi
	ldr	r3, .L1209+52
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1205
	ldr	r3, .L1209+56
	ldr	r2, .L1209+60
	str	r5, [r3, #0]
	ldr	r3, .L1209+64
	ldrh	r3, [r3, #0]
	muls	r3, r5, r3
	str	r3, [r2, #0]
	ldr	r2, .L1209+68
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	ldr	r2, .L1209+72
	str	r3, [r2, #0]
	ldr	r3, .L1209+76
	ldr	r4, [r3, #0]
	ldr	r3, .L1209+80
	ldrh	r0, [r3, #6]
	ldr	r3, .L1209+84
	subs	r0, r4, r0
	subs	r0, r0, r5
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1209+88
	cmp	r5, r4
	strh	r0, [r3, #0]	@ movhi
	bls	.L1197
	ldr	r1, .L1209+24
	mov	r2, #1448
	ldr	r0, .L1209+28
	bl	printf
	ldr	r0, .L1209+32
	ldr	r1, .L1209+36
	bl	printf
.L1197:
	ldr	r3, .L1209+40
	ldr	r2, .L1209+92
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
	ldr	r1, .L1209+96
	strh	r2, [r1, #2]	@ movhi
	strh	r4, [r1, #0]	@ movhi
	strb	r2, [r1, #6]
	strb	r2, [r1, #8]
	ldr	r1, .L1209+100
	strh	r5, [r1, #0]	@ movhi
	ldrh	r5, [r3, #20]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r1, #6]
	ldrb	r5, [r3, #12]	@ zero_extendqisi2
	strh	r6, [r1, #2]	@ movhi
	strb	r5, [r1, #8]
	ldr	r1, .L1209+104
	ldrh	r5, [r3, #22]
	strh	r5, [r1, #0]	@ movhi
	ldrh	r5, [r3, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r1, #6]
	ldrb	r5, [r3, #13]	@ zero_extendqisi2
	strh	r6, [r1, #2]	@ movhi
	strb	r5, [r1, #8]
	ldr	r1, .L1209+108
	ldr	r5, [r3, #32]
	str	r2, [r1, #0]
	ldr	r1, .L1209+112
	str	r2, [r1, #0]
	ldr	r1, .L1209+116
	str	r2, [r1, #0]
	ldr	r1, .L1209+120
	str	r2, [r1, #0]
	ldr	r1, .L1209+124
	str	r5, [r1, #0]
	ldr	r1, .L1209+128
	str	r2, [r1, #0]
	ldr	r1, .L1209+132
	str	r2, [r1, #0]
	ldr	r1, .L1209+136
	str	r2, [r1, #0]
	ldr	r2, .L1209+140
	ldr	r1, [r3, #40]
	ldr	r5, [r2, #0]
	cmp	r1, r5
	it	hi
	strhi	r1, [r2, #0]
	ldr	r2, [r3, #36]
	ldr	r3, .L1209+144
	ldr	r1, [r3, #0]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3, #0]
	cmp	r0, r4
	beq	.L1200
	ldr	r0, .L1209+92
	bl	make_superblock
.L1200:
	ldr	r0, .L1209+100
	movw	r4, #65535
	ldrh	r3, [r0, #0]
	cmp	r3, r4
	beq	.L1201
	bl	make_superblock
.L1201:
	ldr	r0, .L1209+104
	ldrh	r3, [r0, #0]
	cmp	r3, r4
	beq	.L1202
	bl	make_superblock
.L1202:
	ldr	r0, .L1209+96
	movw	r3, #65535
	ldrh	r2, [r0, #0]
	cmp	r2, r3
	beq	.L1206
	bl	make_superblock
	b	.L1206
.L1205:
	mov	r0, #-1
	b	.L1190
.L1206:
	movs	r0, #0
.L1190:
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1208:
	ldr	r1, .L1209+24
	mov	r2, #1424
	ldr	r0, .L1209+28
	bl	printf
	ldr	r1, .L1209+36
	ldr	r0, .L1209+32
	bl	printf
	b	.L1193
.L1210:
	.align	2
.L1209:
	.word	.LANCHOR180
	.word	.LANCHOR197
	.word	.LANCHOR55
	.word	.LANCHOR99
	.word	1179929683
	.word	.LANCHOR73
	.word	.LANCHOR198
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR140
	.word	.LANCHOR117
	.word	.LANCHOR191
	.word	.LANCHOR60
	.word	.LANCHOR199
	.word	.LANCHOR87
	.word	.LANCHOR68
	.word	.LANCHOR71
	.word	.LANCHOR84
	.word	.LANCHOR57
	.word	.LANCHOR89
	.word	.LANCHOR53
	.word	.LANCHOR200
	.word	.LANCHOR107
	.word	.LANCHOR201
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR160
	.word	.LANCHOR159
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR158
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR96
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
	ldr	r6, .L1230
	movw	sl, #61649
	str	r3, [r6, #8]
	ldr	r3, .L1230+4
	ldr	r4, [r3, #0]
	str	r4, [r6, #12]
	bl	FtlBbtMemInit
	ldr	r3, .L1230+8
	mov	r8, r3
	ldrh	r5, [r3, #0]
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1212
.L1216:
	movs	r1, #1
	ldr	r0, .L1230
	mov	r2, r1
	lsls	r3, r5, #10
	str	r3, [r6, #4]
	bl	FlashReadPages
	ldr	r3, [r6, #0]
	ldr	r7, .L1230
	adds	r3, r3, #1
	bne	.L1213
	ldr	r3, [r6, #4]
	movs	r1, #1
	mov	r0, r7
	mov	r2, r1
	adds	r3, r3, #1
	str	r3, [r6, #4]
	bl	FlashReadPages
.L1213:
	ldr	r3, [r7, #0]
	adds	r3, r3, #1
	beq	.L1214
	ldrh	r3, [r4, #0]
	cmp	r3, sl
	bne	.L1214
	ldr	r3, .L1230+12
	ldr	r2, [r4, #4]
	strh	r5, [r3, #0]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r4, #8]
	strh	r2, [r3, #4]	@ movhi
	b	.L1215
.L1214:
	subs	r5, r5, #1
	uxth	r5, r5
.L1212:
	ldrh	r3, [r8, #0]
	subs	r3, r3, #47
	cmp	r3, r5
	ble	.L1216
.L1215:
	ldr	r5, .L1230+12
	movw	r3, #65535
	ldrh	r2, [r5, #0]
	cmp	r2, r3
	beq	.L1227
	ldrh	r2, [r5, #4]
	cmp	r2, r3
	beq	.L1218
	ldr	r6, .L1230
	movs	r1, #1
	lsls	r2, r2, #10
	mov	r0, r6
	str	r2, [r6, #4]
	mov	r2, r1
	bl	FlashReadPages
	ldr	r3, [r6, #0]
	adds	r3, r3, #1
	beq	.L1218
	ldrh	r2, [r4, #0]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1218
	ldr	r3, [r4, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L1218
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r4, #8]
	strh	r2, [r5, #0]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L1218:
	ldr	fp, .L1230+12
	movs	r1, #1
	movs	r5, #0
	ldr	r6, .L1230
	ldr	r8, .L1230+48
	ldrh	r0, [fp, #0]
	bl	FtlGetLastWrittenPage
	uxth	sl, r0
	mov	r7, r0
	add	r3, sl, #1
	strh	r3, [fp, #2]	@ movhi
	sxth	sl, sl
	movw	r3, #61649
	b	.L1219
.L1222:
	ldrh	r1, [fp, #0]
	rsb	r2, r5, sl
	ldr	r0, .L1230
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
	beq	.L1220
	ldrh	r2, [r4, #0]
	cmp	r2, r3
	beq	.L1221
.L1220:
	adds	r5, r5, #1
.L1219:
	subs	r2, r7, r5
	lsls	r1, r2, #16
	bpl	.L1222
	b	.L1229
.L1221:
	ldr	r3, .L1230+12
	ldrh	r2, [r4, #10]
	ldrh	r0, [r4, #12]
	strh	r2, [r3, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1224
	ldr	r3, .L1230+16
	ldr	r2, [r3, #0]
	cmp	r0, r2
	beq	.L1224
	ldr	r3, .L1230+20
	ldrh	r3, [r3, #0]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L1224
	cmp	r0, r3
	bcs	.L1224
	bl	FtlSysBlkNumInit
.L1224:
	ldr	r5, .L1230+24
	movs	r4, #0
	ldr	r8, .L1230+52
	ldr	r7, .L1230+28
	ldr	r6, .L1230
	b	.L1225
.L1226:
	ldrh	r2, [r7, #0]
	ldr	r1, [r6, #8]
	ldr	r0, [r5, #4]!
	lsls	r2, r2, #2
	mla	r1, r4, r2, r1
	bl	memcpy
	adds	r4, r4, #1
.L1225:
	ldrh	r3, [r8, #0]
	cmp	r4, r3
	bcc	.L1226
	movs	r0, #0
	b	.L1217
.L1227:
	mov	r0, #-1
.L1217:
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1229:
	ldr	r1, .L1230+32
	mov	r2, #332
	ldr	r0, .L1230+36
	bl	printf
	ldr	r1, .L1230+40
	ldr	r0, .L1230+44
	bl	printf
	b	.L1221
.L1231:
	.align	2
.L1230:
	.word	.LANCHOR197
	.word	.LANCHOR180
	.word	.LANCHOR66
	.word	.LANCHOR89
	.word	.LANCHOR52
	.word	.LANCHOR56
	.word	.LANCHOR89+24
	.word	.LANCHOR90
	.word	.LANCHOR202
	.word	.LC9
	.word	.LC11
	.word	.LC10
	.word	.LANCHOR96
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
	ldr	r3, .L1239
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r5, #0
	ldr	r7, .L1239+4
	ldr	r3, [r3, #0]
	ldr	r6, .L1239+8
	ldr	r8, .L1239+20
	str	r3, [r7, #8]
	ldr	r3, .L1239+12
	ldr	sl, [r3, #0]
	ldr	r3, .L1239+16
	str	sl, [r7, #12]
	b	.L1233
.L1238:
	ldrh	r4, [r8, #0]
	movw	r2, #65535
	movw	fp, #61664
	strh	r2, [r6], #2	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1234
.L1237:
	mla	r2, r2, r5, r4
	movs	r1, #1
	ldr	r0, .L1239+4
	lsls	r2, r2, #10
	str	r2, [r7, #4]
	mov	r2, r1
	str	r3, [sp, #4]
	bl	FlashReadPages
	ldr	r2, [r7, #0]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L1235
	ldrh	r2, [sl, #0]
	cmp	r2, fp
	bne	.L1235
	strh	r4, [r6, #-2]	@ movhi
	b	.L1236
.L1235:
	subs	r4, r4, #1
	uxth	r4, r4
.L1234:
	ldrh	r2, [r8, #0]
	sub	r1, r2, #15
	cmp	r1, r4
	ble	.L1237
.L1236:
	adds	r5, r5, #1
.L1233:
	ldrh	r2, [r3, #0]
	cmp	r5, r2
	bcc	.L1238
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1240:
	.align	2
.L1239:
	.word	.LANCHOR96
	.word	.LANCHOR197
	.word	.LANCHOR89+12
	.word	.LANCHOR180
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
	ldr	r3, .L1259
	movs	r6, #0
	str	r2, [sp, #8]
	ldr	r7, .L1259+4
	ldrb	r8, [r3, #9]	@ zero_extendqisi2
	b	.L1242
.L1249:
	rsb	r3, r6, fp
	ldr	r1, [sp, #8]
	add	r2, sp, #56
	mov	r0, r5
	uxtb	r3, r3
	str	r3, [sp, #0]
	add	r3, sp, #60
	bl	LogAddr2PhyAddr
	ldr	r1, .L1259+8
	ldr	r3, [sp, #60]
	ldrb	r2, [r1, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bcc	.L1243
	mov	r3, #-1
	str	r3, [r5, #0]
	b	.L1244
.L1243:
	ldr	r2, .L1259+12
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
	cbz	r3, .L1246
	add	r3, r3, #2048
.L1246:
	ldr	r2, [r5, #12]
	cbz	r2, .L1247
	adds	r2, r2, #8
.L1247:
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
.L1244:
	adds	r6, r6, #1
	adds	r5, r5, #36
.L1242:
	cmp	r6, fp
	bne	.L1249
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L1250
	movs	r5, #0
	add	r4, sl, #8
	ldr	r6, .L1259+16
	mov	sl, r5
	ldr	r8, .L1259+36
	b	.L1251
.L1256:
	ldr	r3, [r4, #-8]
	sub	r7, r4, #8
	adds	r3, r3, #1
	bne	.L1252
	ldr	r1, [r4, #-4]
	ldr	r0, .L1259+20
	bl	printf
	b	.L1253
.L1252:
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
	bne	.L1254
	ldr	r0, .L1259+24
	ldr	r1, [r4, #-4]
	bl	printf
	str	r5, [r4, #-8]
.L1254:
	ldr	r3, [r4, #4]
	cbz	r3, .L1255
	ldr	r2, [r3, #0]
	ldr	r3, [r8, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1255
	ldr	r0, .L1259+28
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1255:
	ldr	r3, [r4, #0]
	cbz	r3, .L1253
	ldr	r2, [r3, #0]
	ldr	r3, [r6, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1253
	ldr	r0, .L1259+32
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1253:
	add	sl, sl, #1
	adds	r4, r4, #36
.L1251:
	cmp	sl, fp
	bne	.L1256
.L1250:
	movs	r0, #0
	add	sp, sp, #64
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1260:
	.align	2
.L1259:
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR16
	.word	.LANCHOR19
	.word	.LANCHOR203
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LANCHOR204
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
	ldr	r4, .L1288
	mov	r8, r0
	str	r1, [sp, #8]
	mov	fp, r2
	str	r3, [sp, #16]
	ldr	r4, [r4, #0]
	ldrb	r4, [r4, #19]	@ zero_extendqisi2
	str	r4, [sp, #20]
	ldr	r4, .L1288+4
	ldrb	r4, [r4, #9]	@ zero_extendqisi2
	str	r4, [sp, #12]
	ldr	r4, .L1288+8
	ldrb	r5, [r4, #0]	@ zero_extendqisi2
	cmp	r5, #0
	beq	.L1285
	bl	FlashProgSlc2KPages
	b	.L1263
.L1275:
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
	ldr	r3, .L1288+12
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	mov	r7, r0
	ldr	r0, [sp, #68]
	cmp	r0, r3
	bcc	.L1264
	mov	r3, #-1
	str	r3, [r8, r4]
	b	.L1265
.L1264:
	ldr	r3, .L1288+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r7, #0
	add	r3, sl, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1267
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1267:
	ldr	r2, [sp, #68]
	ldr	r1, .L1288+20
	add	r3, r1, r2, lsl #4
	movs	r1, #0
	str	r1, [r3, #12]
	ldr	r1, [sp, #64]
	str	r6, [r3, #8]
	str	r1, [r3, #4]
	cbz	r7, .L1268
	adds	r1, r5, #1
	movs	r0, #36
	mla	r1, r0, r1, r8
	str	r1, [r3, #12]
.L1268:
	ldr	r3, .L1288+24
	ldrb	r4, [r3, r2]	@ zero_extendqisi2
	lsls	r2, r2, #4
	ldr	r3, .L1288+12
	mov	r0, r4
	strb	r4, [sl, r2]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1269
	bl	NandcWaitFlashReady
	b	.L1270
.L1269:
	bl	NandcFlashCs
	ldr	r2, [sp, #68]
	ldr	r3, .L1288+28
	mov	r0, r4
	ldr	r1, [sp, #64]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r4
	bl	NandcFlashDeCs
.L1270:
	ldr	r2, [sp, #20]
	subs	r3, r2, #1
	cmp	r3, #6
	bhi	.L1271
	ldr	r3, .L1288+32
	ldrb	r3, [r3, r4]	@ zero_extendqisi2
	cbz	r3, .L1271
	ldr	r3, .L1288+36
	mov	r0, r4
	adds	r2, r3, #4
	ldrb	r1, [r3, #1]	@ zero_extendqisi2
	movs	r3, #0
	bl	HynixSetRRPara
.L1271:
	mov	r0, r4
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r4
	bne	.L1272
	ldr	r3, .L1288+40
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1272
	bl	flash_enter_slc_mode
	b	.L1273
.L1272:
	bl	flash_exit_slc_mode
.L1273:
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
	cbz	r7, .L1274
	mov	r0, r4
	ldr	r1, [sp, #64]
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1288+28
	ldr	r2, [sp, #68]
	mov	r0, r4
	ldr	r1, [sp, #64]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	ldr	r3, .L1288+44
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
.L1274:
	mov	r0, r4
	ldr	r1, [sp, #64]
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcFlashDeCs
	adds	r5, r5, r7
.L1265:
	adds	r5, r5, #1
	b	.L1262
.L1285:
	ldr	sl, .L1288+20
.L1262:
	ldr	r1, [sp, #8]
	cmp	r5, r1
	bcc	.L1275
	movs	r4, #0
	ldr	r7, .L1288+12
	ldr	r6, .L1288+40
	ldr	r5, .L1288+20
	b	.L1276
.L1278:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L1277
	ldrb	r3, [r6, #0]	@ zero_extendqisi2
	cbz	r3, .L1277
	lsls	r3, r4, #4
	ldrb	r0, [r5, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1277:
	adds	r4, r4, #1
.L1276:
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1278
	ldr	r2, [sp, #16]
	cmp	r2, #0
	beq	.L1287
	movs	r5, #0
	add	r4, r8, #8
	ldr	r6, .L1288+48
	mov	sl, r5
	ldr	r8, .L1288+68
	b	.L1279
.L1284:
	ldr	r3, [r4, #-8]
	sub	r7, r4, #8
	adds	r3, r3, #1
	bne	.L1280
	ldr	r1, [r4, #-4]
	ldr	r0, .L1288+52
	bl	printf
	b	.L1281
.L1280:
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
	bne	.L1282
	ldr	r0, .L1288+56
	ldr	r1, [r4, #-4]
	bl	printf
	str	r5, [r4, #-8]
.L1282:
	ldr	r3, [r4, #4]
	cbz	r3, .L1283
	ldr	r2, [r3, #0]
	ldr	r3, [r8, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1283
	ldr	r0, .L1288+60
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1283:
	ldr	r3, [r4, #0]
	cbz	r3, .L1281
	ldr	r2, [r3, #0]
	ldr	r3, [r6, #0]
	ldr	r3, [r3, #0]
	cmp	r2, r3
	beq	.L1281
	ldr	r0, .L1288+64
	ldr	r1, [r4, #-4]
	bl	printf
	mov	r3, #-1
	str	r3, [r4, #-8]
.L1281:
	add	sl, sl, #1
	adds	r4, r4, #36
.L1279:
	ldr	r2, [sp, #8]
	cmp	sl, r2
	bne	.L1284
	movs	r0, #0
	b	.L1263
.L1289:
	.align	2
.L1288:
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
	.word	.LANCHOR203
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LANCHOR204
.L1287:
	ldr	r0, [sp, #16]
.L1263:
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
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r8, #0
	ldr	r4, .L1302
	ldr	sl, .L1302+88
	ldr	fp, .L1302+92
	ldr	r6, .L1302+4
	ldr	r0, [sl, #0]
	ldr	r5, [fp, #0]
	ldrh	r3, [r4, #0]
	str	r0, [r6, #8]
	str	r5, [r6, #12]
	strh	r3, [r5, #2]	@ movhi
	movw	r3, #61604
	strh	r3, [r5, #0]	@ movhi
	ldr	r3, [r4, #8]
	ldr	r7, .L1302+8
	ldr	r1, .L1302+12
	str	r3, [r5, #4]
	ldr	r3, .L1302+16
	str	r8, [r5, #8]
	str	r8, [r5, #12]
	stmia	r7, {r1, r3}
	ldrh	r3, [r4, #6]
	strh	r3, [r7, #8]	@ movhi
	ldr	r3, .L1302+20
	ldrh	r3, [r3, #0]
	strb	r3, [r7, #10]
	ldr	r3, .L1302+24
	ldrh	r2, [r3, #0]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	strh	r2, [r7, #16]	@ movhi
	strb	r3, [r7, #11]
	ldr	r3, .L1302+28
	ldrh	r2, [r3, #0]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	strh	r2, [r7, #20]	@ movhi
	strb	r3, [r7, #12]
	ldr	r3, .L1302+32
	ldrh	r2, [r3, #0]
	strh	r2, [r7, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	orr	r2, r2, r1, lsl #6
	movs	r1, #255
	strh	r2, [r7, #24]	@ movhi
	strb	r3, [r7, #13]
	ldr	r3, .L1302+36
	ldr	r3, [r3, #0]
	str	r3, [r7, #32]
	ldr	r3, .L1302+40
	ldr	r3, [r3, #0]
	str	r3, [r7, #40]
	ldr	r3, .L1302+44
	ldr	r3, [r3, #0]
	str	r3, [r7, #36]
	ldr	r3, .L1302+48
	ldrh	r2, [r3, #0]
	bl	memset
	mov	r1, r7
	ldr	r7, .L1302+52
	movs	r2, #48
	ldr	r0, [r6, #8]
	bl	memcpy
	ldr	r3, .L1302+56
	ldrh	r2, [r7, #0]
	ldr	r0, [r6, #8]
	ldr	r1, [r3, #0]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	memcpy
	ldrh	r2, [r7, #0]
	ldr	r3, [r6, #8]
	mov	r7, r8
	add	r0, r2, #24
	lsrs	r2, r2, #3
	lsrs	r0, r0, #1
	adds	r2, r2, #4
	add	r0, r3, r0, lsl #2
	ldr	r3, .L1302+60
	ldr	r1, [r3, #0]
	bl	memcpy
	mov	r0, r8
	bl	FtlUpdateVaildLpn
	movw	r8, #65535
.L1301:
	ldr	r3, [sl, #0]
	movs	r1, #1
	ldrh	r2, [r4, #0]
	ldr	r0, .L1302+4
	str	r3, [r6, #8]
	ldr	r3, [fp, #0]
	str	r3, [r6, #12]
	ldrh	r3, [r4, #2]
	orr	r3, r3, r2, lsl #10
	mov	r2, r1
	str	r3, [r6, #4]
	mov	r3, r1
	bl	FlashProgPages
	ldr	r3, .L1302+64
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1292
	ldrh	r3, [r4, #0]
	ldrh	r8, [r4, #4]
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r2, .L1302+40
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
	ldr	r0, .L1302+4
	bl	FlashProgPages
.L1292:
	ldrh	r3, [r4, #2]
	ldr	r2, [r6, #0]
	adds	r3, r3, #1
	adds	r2, r2, #1
	uxth	r3, r3
	strh	r3, [r4, #2]	@ movhi
	bne	.L1293
	cmp	r3, #1
	bne	.L1294
	ldr	r1, .L1302+68
	mov	r2, #1096
	ldr	r0, .L1302+72
	bl	printf
	ldr	r0, .L1302+76
	ldr	r1, .L1302+80
	bl	printf
.L1294:
	ldr	r2, .L1302
	ldrh	r3, [r2, #2]
	cmp	r3, #1
	bne	.L1295
	ldr	r3, .L1302+64
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1295:
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r7, #3
	bls	.L1301
	ldr	r3, .L1302+4
	mov	r2, r7
	ldr	r0, .L1302+84
	ldr	r1, [r3, #4]
	bl	printf
.L1297:
	b	.L1297
.L1293:
	cmp	r3, #1
	beq	.L1301
	movw	r3, #65535
	cmp	r8, r3
	beq	.L1298
	mov	r0, r8
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L1298:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1303:
	.align	2
.L1302:
	.word	.LANCHOR191
	.word	.LANCHOR197
	.word	.LANCHOR140
	.word	1179929683
	.word	1342177344
	.word	.LANCHOR60
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR161
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR73
	.word	.LANCHOR55
	.word	.LANCHOR99
	.word	.LANCHOR117
	.word	.LANCHOR69
	.word	.LANCHOR205
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC25
	.word	.LANCHOR96
	.word	.LANCHOR180
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
	ldr	r3, .L1316
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	movs	r1, #0
	ldr	r0, [r3, #0]
	movs	r4, #0
	ldr	r3, .L1316+4
	ldr	r7, .L1316+8
	ldr	r5, .L1316+12
	ldr	r3, [r3, #0]
	str	r0, [r7, #8]
	ldr	r8, .L1316+48
	str	r3, [r7, #12]
	ldr	r3, .L1316+16
	ldr	sl, .L1316+52
	ldrh	r2, [r3, #0]
	bl	memset
	b	.L1305
.L1306:
	ldrh	r2, [sl, #0]
	ldr	r3, [r7, #8]
	ldr	r1, [r5, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	memcpy
.L1305:
	ldrh	r3, [r8, #0]
	ldr	r6, .L1316+8
	cmp	r4, r3
	blt	.L1306
	ldr	r5, [r6, #12]
	movs	r2, #16
	movs	r1, #255
	movs	r7, #0
	mov	r0, r5
	mov	r8, r7
	bl	memset
	movw	r3, #61649
	strh	r3, [r5, #0]	@ movhi
	ldr	r3, .L1316+20
	ldr	sl, .L1316
	ldr	fp, .L1316+4
	ldr	r2, [r3, #8]
	str	r2, [r5, #4]
	ldrh	r2, [r3, #0]
	strh	r2, [r5, #2]	@ movhi
	ldrh	r2, [r3, #4]
	ldrh	r3, [r3, #6]
	strh	r2, [r5, #8]	@ movhi
	strh	r3, [r5, #10]	@ movhi
	ldr	r3, .L1316+24
	ldr	r3, [r3, #0]
	strh	r3, [r5, #12]	@ movhi
	b	.L1315
.L1312:
	mov	r8, #1
.L1315:
	ldr	r3, [sl, #0]
	movs	r1, #0
	ldr	r4, .L1316+20
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
	ldr	r0, .L1316+28
	bl	printf
	movs	r1, #1
	mov	r2, r1
	mov	r3, r1
	ldr	r0, .L1316+8
	bl	FlashProgPages
	ldr	r3, .L1316+32
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1308
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
	ldr	r2, .L1316+36
	strh	r3, [r4, #0]	@ movhi
	lsls	r3, r3, #10
	str	r3, [r6, #4]
	ldr	r0, [r2, #0]
	mov	r2, r1
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	movs	r1, #1
	ldr	r0, .L1316+8
	mov	r2, r1
	mov	r3, r1
	bl	FlashProgPages
.L1308:
	ldr	r3, .L1316+20
	ldrh	r2, [r3, #2]
	adds	r2, r2, #1
	strh	r2, [r3, #2]	@ movhi
	ldr	r3, [r6, #0]
	adds	r3, r3, #1
	bne	.L1309
	adds	r7, r7, #1
	ldr	r0, .L1316+40
	ldr	r1, [r6, #4]
	uxth	r7, r7
	bl	printf
	cmp	r7, #3
	bls	.L1315
	ldr	r3, .L1316+8
	mov	r2, r7
	ldr	r0, .L1316+44
	ldr	r1, [r3, #4]
	bl	printf
.L1311:
	b	.L1311
.L1309:
	cmp	r8, #0
	beq	.L1312
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1317:
	.align	2
.L1316:
	.word	.LANCHOR96
	.word	.LANCHOR180
	.word	.LANCHOR197
	.word	.LANCHOR89+24
	.word	.LANCHOR73
	.word	.LANCHOR89
	.word	.LANCHOR52
	.word	.LC26
	.word	.LANCHOR69
	.word	.LANCHOR93
	.word	.LC27
	.word	.LC28
	.word	.LANCHOR60
	.word	.LANCHOR90
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
	ldr	r5, .L1328
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1327
	b	.L1320
.L1326:
	ldr	r3, .L1328+4
	mov	r1, sl
	mov	fp, #0
	ldrb	r0, [r3, r4]	@ zero_extendqisi2
	bl	V2P_block
	mov	r3, r0
	b	.L1321
.L1325:
	ldrh	r2, [r7, fp, lsl #1]
	cmp	r2, r3
	bne	.L1322
	mov	r0, r3
	str	r3, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r1, [r5, #0]
	mov	r2, fp
	ldr	r3, [sp, #4]
	b	.L1323
.L1324:
	adds	r0, r2, #1
	ldrh	lr, [r6, r0, lsl #1]
	strh	lr, [r6, r2, lsl #1]	@ movhi
	uxth	r2, r0
.L1323:
	cmp	r2, r1
	bcc	.L1324
	subs	r1, r1, #1
	strh	r1, [r5, #0]	@ movhi
.L1322:
	add	fp, fp, #1
	uxth	fp, fp
.L1321:
	ldrh	r2, [r5, #0]
	cmp	r2, fp
	bhi	.L1325
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1319
.L1327:
	ldr	r7, .L1328+8
	movs	r4, #0
	ldr	r8, .L1328+12
	mov	r6, r7
.L1319:
	ldrh	r3, [r8, #0]
	cmp	r3, r4
	bhi	.L1326
	bl	FtlGcReFreshBadBlk
.L1320:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1329:
	.align	2
.L1328:
	.word	.LANCHOR148
	.word	.LANCHOR62
	.word	.LANCHOR149
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
	ldr	r3, .L1340
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1331
	ldr	r2, .L1340+4
	ldrh	r1, [r2, #0]
	cmp	r1, r0
	bne	.L1332
	movw	r3, #65535
	strh	r3, [r2, #0]	@ movhi
	b	.L1333
.L1332:
	ldr	r2, .L1340+8
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1334
	ldr	r2, .L1340+12
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1334
	ldr	r2, .L1340+16
	ldrh	r2, [r2, #0]
	cmp	r2, r0
	beq	.L1334
.L1333:
	ldr	r5, .L1340+20
	mov	r1, r4
	ldr	r0, .L1340+24
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1335
	ldr	r1, .L1340+28
	movw	r2, #2809
	ldr	r0, .L1340+32
	bl	printf
	ldr	r0, .L1340+36
	ldr	r1, .L1340+40
	bl	printf
.L1335:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1340+44
	ldrh	r2, [r3, #0]
	ldrh	r3, [r5, #0]
	adds	r2, r2, r3
	ldr	r3, .L1340+48
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1339
	ldr	r1, .L1340+28
	movw	r2, #2812
	ldr	r0, .L1340+32
	bl	printf
	ldr	r1, .L1340+40
	ldr	r0, .L1340+36
	bl	printf
	b	.L1339
.L1331:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1334
.L1339:
	movs	r3, #1
.L1334:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1341:
	.align	2
.L1340:
	.word	.LANCHOR99
	.word	.LANCHOR201
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR101
	.word	.LANCHOR98
	.word	.LANCHOR206
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR104
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
	beq	.L1343
	ldr	r6, .L1349
	ldr	r3, [r6, #0]
	ldrh	r5, [r3, r0, lsl #1]
	cbnz	r5, .L1344
	mov	r1, r4
	ldr	r0, .L1349+4
	mov	r2, r5
	bl	printf
	ldr	r3, [r6, #0]
	ldrh	r4, [r3, r4, lsl #1]
	cmp	r4, #0
	bne	.L1345
	ldr	r1, .L1349+8
	movw	r2, #2827
	ldr	r0, .L1349+12
	mov	r5, r4
	bl	printf
	ldr	r0, .L1349+16
	ldr	r1, .L1349+20
	bl	printf
	b	.L1345
.L1344:
	subs	r5, r5, #1
	strh	r5, [r3, r0, lsl #1]	@ movhi
.L1343:
	ldr	r6, .L1349+24
	movw	r3, #65535
	ldrh	r0, [r6, #0]
	cmp	r0, r3
	bne	.L1346
	strh	r4, [r6, #0]	@ movhi
	b	.L1348
.L1346:
	cmp	r0, r4
	beq	.L1348
	bl	update_vpc_list
	ldr	r3, .L1349+28
	strh	r4, [r6, #0]	@ movhi
	ldr	r2, [r3, #0]
	ldr	r3, .L1349+32
	ldr	r3, [r3, #0]
	subs	r3, r2, r3
	ldr	r2, .L1349+36
	adds	r5, r0, #0
	it	ne
	movne	r5, #1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	ldr	r2, .L1349
	uxth	r3, r3
	ldr	r2, [r2, #0]
	ldrh	r2, [r2, r3, lsl #1]
	cbnz	r2, .L1345
	cmp	r4, r3
	beq	.L1345
	ldr	r1, .L1349+8
	movw	r2, #2843
	ldr	r0, .L1349+12
	bl	printf
	ldr	r1, .L1349+20
	ldr	r0, .L1349+16
	bl	printf
	b	.L1345
.L1348:
	movs	r5, #0
.L1345:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1350:
	.align	2
.L1349:
	.word	.LANCHOR99
	.word	.LC29
	.word	.LANCHOR207
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR135
	.word	.LANCHOR98
	.word	.LANCHOR97
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
	bne	.L1352
	ldr	r1, .L1367
	movw	r2, #2749
	ldr	r0, .L1367+4
	bl	printf
	ldr	r0, .L1367+8
	ldr	r1, .L1367+12
	bl	printf
.L1352:
	ldr	r3, .L1367+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1353
	ldr	r1, .L1367
	movw	r2, #2750
	ldr	r0, .L1367+4
	bl	printf
	ldr	r0, .L1367+8
	ldr	r1, .L1367+12
	bl	printf
.L1353:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1354
	ldr	r1, .L1367
	movw	r2, #2751
	ldr	r0, .L1367+4
	bl	printf
	ldr	r0, .L1367+8
	ldr	r1, .L1367+12
	bl	printf
.L1354:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movs	r7, #0
	movw	r6, #65535
	strb	r7, [r4, #10]
	adds	r3, r3, #8
	ldr	sl, .L1367+24
	ldr	r8, .L1367+28
	ldrh	r3, [r4, r3, lsl #1]
	ldr	r5, .L1367+20
	b	.L1355
.L1356:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r5, #0]
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1357
	ldrh	r3, [r4, #2]
	strb	r7, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1357:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
.L1355:
	cmp	r3, r6
	beq	.L1356
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L1358
	ldrb	r2, [sl, #0]	@ zero_extendqisi2
	cbnz	r2, .L1358
	ldrh	r2, [r4, #2]
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r2, r6
	bne	.L1358
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1356
.L1358:
	ldrh	r5, [r4, #2]
	movw	r6, #65535
	ldr	sl, .L1367+20
	mov	r8, r6
	ldr	r7, .L1367+24
	orr	r5, r5, r3, lsl #10
	ldrh	r3, [r4, #4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1363:
	ldrh	r2, [sl, #0]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
.L1360:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r2
	bne	.L1359
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
.L1359:
	add	r1, r3, #8
	ldrh	r1, [r4, r1, lsl #1]
	cmp	r1, r6
	beq	.L1360
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1361
	ldrb	r2, [r7, #0]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r2, .L1365
	ldr	r2, .L1367+28
	ldrh	r3, [r2, r3, lsl #1]
	cmp	r3, r8
	bne	.L1361
	ldrh	r3, [r4, #4]
	cbz	r3, .L1361
	subs	r3, r3, #1
	ldrh	r0, [r4, #0]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1363
.L1365:
	ldr	r2, .L1367+32
	ldrh	r2, [r2, #0]
	cmp	r3, r2
	bcc	.L1361
	ldr	r3, .L1367+36
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #4]	@ movhi
	mov	r2, r3	@ movhi
	ldr	r3, .L1367+16
	strb	r2, [r4, #6]
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
.L1361:
	ldr	r3, .L1367+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1364
	ldrh	r3, [r4, #4]
	cbz	r3, .L1364
	ldr	r1, .L1367
	movw	r2, #2795
	ldr	r0, .L1367+4
	bl	printf
	ldr	r0, .L1367+8
	ldr	r1, .L1367+12
	bl	printf
.L1364:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1368:
	.align	2
.L1367:
	.word	.LANCHOR208
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR68
	.word	.LANCHOR53
	.word	.LANCHOR7
	.word	.LANCHOR9
	.word	.LANCHOR69
	.word	.LANCHOR99
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
	beq	.L1369
	ldrh	r3, [r0, #0]
	movw	r5, #65535
	cmp	r3, r5
	beq	.L1369
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	movs	r6, #0
	ldr	sl, .L1375+4
	adds	r3, r3, #8
	ldr	r8, .L1375+20
	ldr	r7, .L1375
	ldrh	r3, [r0, r3, lsl #1]
	b	.L1371
.L1372:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7, #0]
	adds	r3, r3, #1
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1373
	ldrh	r3, [r4, #2]
	strb	r6, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1373:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
.L1371:
	cmp	r3, r5
	beq	.L1372
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1374
	ldrb	r2, [sl, #0]	@ zero_extendqisi2
	cbnz	r2, .L1374
	ldrh	r2, [r4, #2]
	ldrh	r2, [r8, r2, lsl #1]
	cmp	r2, r5
	bne	.L1374
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	bne	.L1372
	ldrh	r2, [r4, #2]
	strb	r3, [r4, #6]
	adds	r2, r2, #1
	strh	r2, [r4, #2]	@ movhi
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1374:
	ldr	r2, .L1375+4
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1369
	cmp	r3, #1
	bne	.L1369
	ldr	r3, .L1375+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1369
	ldr	r3, .L1375+12
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #4]	@ movhi
	mov	r2, r3	@ movhi
	ldr	r3, .L1375+16
	strb	r2, [r4, #6]
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
.L1369:
	pop	{r3, r4, r5, r6, r7, r8, sl, pc}
.L1376:
	.align	2
.L1375:
	.word	.LANCHOR53
	.word	.LANCHOR7
	.word	.LANCHOR69
	.word	.LANCHOR99
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
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r7, .L1419
	sub	sp, sp, #24
	ldr	r8, .L1419+100
.L1416:
	ldr	r1, .L1419+4
	ldrh	r2, [r7, #0]
	ldrh	r3, [r1, #0]
	adds	r2, r2, r3
	ldr	r3, .L1419+8
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1379
	ldr	r1, .L1419+12
	movw	r2, #2594
	ldr	r0, .L1419+16
	bl	printf
	ldr	r0, .L1419+20
	ldr	r1, .L1419+24
	bl	printf
.L1379:
	ldr	r3, .L1419+28
	cmp	r4, r3
	bne	.L1380
	ldr	r3, .L1419+32
	ldrh	r2, [r7, #0]
	ldr	r3, [r3, #0]
	lsrs	r1, r2, #1
	adds	r0, r1, #1
	mul	r5, r3, r2
	add	r0, r0, r5, lsr #2
	ldr	r5, .L1419+36
	uxth	r0, r0
	ldr	r5, [r5, #0]
	cbz	r5, .L1408
	ldr	r5, .L1419+40
	ldr	r5, [r5, #0]
	cmp	r5, #29
	bhi	.L1408
	cmp	r5, #2
	bls	.L1413
	lsls	r0, r2, #31
	bpl	.L1381
	cbz	r3, .L1410
	b	.L1381
.L1380:
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1413
	ldr	r3, .L1419+44
	ldrh	r3, [r3, #0]
	cmp	r3, #1
	beq	.L1413
	ldr	r3, .L1419+48
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1413
	ldr	r2, .L1419+36
	ldrh	r3, [r7, #0]
	ldr	r2, [r2, #0]
	lsrs	r1, r3, #3
	cbz	r2, .L1381
	ldr	r2, .L1419+40
	ldr	r2, [r2, #0]
	cmp	r2, #1
	bhi	.L1381
	movs	r1, #7
	muls	r1, r3, r1
	lsrs	r1, r1, #3
	b	.L1381
.L1408:
	mov	r1, r0
.L1381:
	cbz	r1, .L1382
	subs	r1, r1, #1
	uxth	r1, r1
	b	.L1382
.L1410:
	mov	r1, r3
	b	.L1382
.L1413:
	movs	r1, #0
.L1382:
	ldr	r0, .L1419+52
	bl	List_pop_index_node
	ldrh	r3, [r7, #0]
	uxth	r5, r0
	cbnz	r3, .L1383
	ldr	r1, .L1419+12
	movw	r2, #2614
	ldr	r0, .L1419+16
	bl	printf
	ldr	r0, .L1419+20
	ldr	r1, .L1419+24
	bl	printf
.L1383:
	ldr	r2, .L1419
	mov	r0, r4
	ldrh	r3, [r2, #0]
	subs	r3, r3, #1
	strh	r3, [r2, #0]	@ movhi
	strh	r5, [r4, #0]	@ movhi
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1384
	ldr	r3, .L1419+56
	movw	r2, #65535
	ldr	r1, .L1419+4
	ldr	r3, [r3, #0]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrh	r3, [r1, #0]
	ldrh	r2, [r7, #0]
	adds	r2, r2, r3
	ldr	r3, .L1419+8
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1416
	ldr	r1, .L1419+12
	movw	r2, #2625
	ldr	r0, .L1419+16
	bl	printf
	ldr	r1, .L1419+24
	ldr	r0, .L1419+20
	bl	printf
	b	.L1416
.L1384:
	ldr	r1, .L1419+4
	ldrh	r2, [r7, #0]
	ldrh	r3, [r1, #0]
	adds	r2, r2, r3
	ldr	r3, .L1419+8
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	ble	.L1386
	ldr	r1, .L1419+12
	movw	r2, #2628
	ldr	r0, .L1419+16
	bl	printf
	ldr	r0, .L1419+20
	ldr	r1, .L1419+24
	bl	printf
.L1386:
	ldr	r3, .L1419+60
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
	b	.L1387
.L1389:
	str	r0, [r3, #8]
	movw	r4, #65535
	str	r0, [r3, #12]
	ldrh	ip, [r1, #16]
	cmp	ip, r4
	beq	.L1388
	ldr	r4, [sp, #4]
	mov	lr, #36
	lsl	ip, ip, #10
	mla	fp, lr, r6, r4
	adds	r6, r6, #1
	uxth	r6, r6
	str	ip, [fp, #4]
.L1388:
	adds	r2, r2, #1
	adds	r3, r3, #36
	adds	r1, r1, #2
	uxth	r2, r2
.L1387:
	ldr	r4, [sp, #20]
	cmp	r2, r4
	bne	.L1389
	ldr	r4, [sp, #0]
	cbnz	r6, .L1390
	ldr	r1, .L1419+12
	mov	r2, #2640
	ldr	r0, .L1419+16
	bl	printf
	ldr	r0, .L1419+20
	ldr	r1, .L1419+24
	bl	printf
.L1390:
	ldr	r3, .L1419+36
	ldr	r3, [r3, #0]
	cbz	r3, .L1391
	ldr	r3, .L1419+64
	cmp	r4, r3
	bne	.L1391
	ldr	r3, .L1419+68
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #30
	bls	.L1391
	movs	r3, #0
	strb	r3, [r4, #8]
.L1391:
	ldr	r3, .L1419+72
	ldrh	r3, [r3, #0]
	cmp	r3, r5
	bne	.L1392
	ldr	r1, .L1419+12
	movw	r2, #2647
	ldr	r0, .L1419+16
	bl	printf
	ldr	r0, .L1419+20
	ldr	r1, .L1419+24
	bl	printf
.L1392:
	ldr	r3, .L1419+68
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, [r3, #0]
	cbnz	r2, .L1393
	ldrh	r2, [r3, r5, lsl #1]
	cbz	r2, .L1394
	ldr	r1, .L1419+76
	ldrh	r1, [r1, #0]
	adds	r2, r2, r1
	b	.L1417
.L1394:
	movs	r2, #2
.L1417:
	strh	r2, [r3, r5, lsl #1]	@ movhi
	mov	r0, r5
	ldr	r3, .L1419+80
	movs	r1, #0
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	b	.L1418
.L1393:
	ldrh	r2, [r3, r5, lsl #1]
	mov	r0, r5
	movs	r1, #1
	adds	r2, r2, #1
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L1419+84
	ldr	r2, [r3, #0]
	adds	r2, r2, #1
	str	r2, [r3, #0]
.L1418:
	bl	ftl_set_blk_mode
	ldr	r3, .L1419+68
	lsl	fp, r5, #1
	str	fp, [sp, #20]
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r5, lsl #1]
	ldr	r3, .L1419+88
	ldr	r1, [r3, #0]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3, #0]
	ldr	r3, .L1419+76
	ldrh	r2, [r3, #0]
	ldr	r3, .L1419+80
	ldr	r0, [r3, #0]
	ldr	r3, .L1419+84
	ldr	r3, [r3, #0]
	mla	r0, r0, r2, r3
	ldr	r3, .L1419+8
	ldrh	r1, [r3, #0]
	bl	__aeabi_uidiv
	ldr	r3, .L1419+92
	str	r0, [r3, #0]
	ldr	r3, .L1419+96
	ldr	r3, [r3, #0]
	ldr	r2, [r3, #16]
	adds	r2, r2, #1
	str	r2, [r3, #16]
	ldr	r3, [r8, #0]
	movs	r2, #0
	b	.L1398
.L1420:
	.align	2
.L1419:
	.word	.LANCHOR104
	.word	.LANCHOR101
	.word	.LANCHOR55
	.word	.LANCHOR209
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR109
	.word	.LANCHOR166
	.word	.LANCHOR126
	.word	.LANCHOR164
	.word	.LANCHOR59
	.word	.LANCHOR7
	.word	.LANCHOR103
	.word	.LANCHOR99
	.word	.LANCHOR53
	.word	.LANCHOR107
	.word	.LANCHOR94
	.word	.LANCHOR201
	.word	.LANCHOR63
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR195
	.word	.LANCHOR183
	.word	.LANCHOR93
.L1399:
	adds	r2, r2, #1
	ldr	r1, [r3, #-32]
	uxth	r2, r2
	bic	r1, r1, #1020
	bic	r1, r1, #3
	str	r1, [r3, #-32]
.L1398:
	adds	r3, r3, #36
	cmp	r2, r6
	bne	.L1399
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
	b	.L1400
.L1402:
	ldr	r1, [r8, #0]
	add	r0, r1, fp
	ldr	r1, [r1, fp]
	adds	r2, r1, #1
	bne	.L1401
	ldr	r0, [r0, #4]
	adds	r5, r5, #1
	str	r1, [sp, #16]
	ubfx	r0, r0, #10, #16
	str	r3, [sp, #12]
	str	ip, [sp, #8]
	bl	FtlBbmMapBadBlock
	ldr	r1, [sp, #16]
	strh	r1, [sl, #16]	@ movhi
	ldrb	r1, [r6, #7]	@ zero_extendqisi2
	subs	r1, r1, #1
	strb	r1, [r6, #7]
	ldr	ip, [sp, #8]
	ldr	r3, [sp, #12]
.L1401:
	adds	r4, r4, #1
	add	fp, fp, #36
	add	sl, sl, #2
	uxth	r4, r4
.L1400:
	cmp	r4, r3
	bne	.L1402
	mov	r3, r5
	mov	r4, r6
	mov	r5, ip
	cbz	r3, .L1403
	mov	r0, ip
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1403:
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1404
	ldr	r3, .L1421
	movw	r2, #65535
	ldr	r3, [r3, #0]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1416
.L1404:
	ldr	r2, .L1421+4
	ldr	fp, [sp, #20]
	ldrh	r2, [r2, #0]
	muls	r3, r2, r3
	movs	r2, #0
	strh	r2, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	uxth	r3, r3
	ldr	r2, .L1421+8
	strh	r5, [r4, #0]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	ldr	r1, [r2, #0]
	str	r1, [r4, #12]
	adds	r1, r1, #1
	str	r1, [r2, #0]
	ldr	r2, .L1421
	ldr	r2, [r2, #0]
	strh	r3, [r2, fp]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1405
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1406
.L1405:
	ldr	r1, .L1421+12
	movw	r2, #2700
	ldr	r0, .L1421+16
	bl	printf
	ldr	r0, .L1421+20
	ldr	r1, .L1421+24
	bl	printf
.L1406:
	movs	r0, #0
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1422:
	.align	2
.L1421:
	.word	.LANCHOR99
	.word	.LANCHOR68
	.word	.LANCHOR153
	.word	.LANCHOR209
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
	ldr	r3, .L1430
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldrb	r7, [r3, #0]	@ zero_extendqisi2
	sub	sp, sp, #40
	cbz	r7, .L1424
	ldrb	r7, [r0, #8]	@ zero_extendqisi2
	sub	r5, r7, #1
	rsbs	r7, r5, #0
	adc	r7, r7, r5
.L1424:
	mov	r8, #7
	mov	r5, #-1
	ldr	sl, .L1430+16
	ldr	fp, .L1430+20
	ldr	r6, .L1430+4
	b	.L1425
.L1428:
	ldrh	r3, [r4, #4]
	cbz	r3, .L1426
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1426
	ldr	r3, [sl, #0]
	add	r0, sp, #4
	ldr	r2, [fp, #0]
	ldr	r1, [r6, #0]
	str	r3, [sp, #12]
	ldrh	r3, [r4, #0]
	str	r2, [sp, #16]
	str	r5, [sp, #20]
	strh	r3, [r2, #2]	@ movhi
	movs	r3, #0
	str	r1, [r2, #4]
	strh	r3, [r2, #0]	@ movhi
	str	r5, [r2, #8]
	str	r5, [r2, #12]
	adds	r2, r1, #1
	cmp	r2, #-1
	it	eq
	moveq	r2, r3
	movs	r1, #1
	str	r2, [r6, #0]
	mov	r2, r7
	bl	FlashProgPages
	ldrh	r0, [r4, #0]
	bl	decrement_vpc_count
.L1425:
	subs	r8, r8, #1
	bne	.L1428
.L1426:
	ldr	r3, .L1430+8
	ldrh	r2, [r4, #0]
	ldrh	r1, [r4, #4]
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, r2, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1430+12
	ldrh	r3, [r3, #0]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #40
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1431:
	.align	2
.L1430:
	.word	.LANCHOR7
	.word	.LANCHOR154
	.word	.LANCHOR99
	.word	.LANCHOR68
	.word	.LANCHOR96
	.word	.LANCHOR180
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
	ldr	r3, .L1462
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	movs	r6, #0
	str	r0, [sp, #12]
	mov	r8, r1
	mov	r4, r6
	mov	r5, r6
	str	r3, [sp, #8]
	movs	r7, #36
	ldr	r3, .L1462+4
	ldr	sl, .L1462+24
	str	r0, [r3, #0]
	b	.L1433
.L1437:
	mul	r3, r7, r6
	ldr	r1, .L1462+8
	ldr	fp, [sl, #0]
	movs	r0, #0
	str	r0, [fp, r3]
	ldrb	r0, [r1, r6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	V2P_block
	str	r0, [sp, #4]
	cmp	r8, #0
	beq	.L1434
	bl	IsBlkInVendorPart
	cbnz	r0, .L1435
.L1434:
	ldr	r0, [sp, #4]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1436
	mul	r3, r7, r4
	ldr	r2, [sl, #0]
	ldr	ip, [sp, #4]
	adds	r2, r2, r3
	add	r3, fp, r3
	lsl	r1, ip, #10
	str	r0, [r3, #8]
	ldr	r0, .L1462+12
	str	r1, [r2, #4]
	ldrh	r2, [r0, #0]
	muls	r2, r4, r2
	ldr	r0, .L1462+16
	adds	r4, r4, #1
	bic	r2, r2, #3
	uxth	r4, r4
	ldr	r1, [r0, #0]
	adds	r2, r1, r2
	str	r2, [r3, #12]
	b	.L1435
.L1436:
	adds	r5, r5, #1
	uxth	r5, r5
.L1435:
	adds	r6, r6, #1
	uxth	r6, r6
.L1433:
	ldr	r1, .L1462+20
	ldrh	r3, [r1, #0]
	cmp	r3, r6
	bhi	.L1437
	cmp	r4, #0
	beq	.L1439
	ldr	r2, [sp, #8]
	mov	sl, #0
	ldr	r7, .L1462+24
	mov	fp, sl
	adds	r6, r2, #0
	mov	r2, r4
	it	ne
	movne	r6, #1
	ldr	r0, [r7, #0]
	mov	r1, r6
	bl	FlashEraseBlocks
.L1441:
	ldr	r3, [r7, #0]
	add	r2, r3, sl
	ldr	r3, [r3, sl]
	adds	r3, r3, #1
	bne	.L1440
	ldr	r0, [r2, #4]
	adds	r5, r5, #1
	ubfx	r0, r0, #10, #16
	uxth	r5, r5
	bl	FtlBbmMapBadBlock
.L1440:
	add	fp, fp, #1
	add	sl, sl, #36
	uxth	fp, fp
	cmp	fp, r4
	bne	.L1441
	cmp	r8, #0
	beq	.L1455
	ldr	r3, .L1462+28
	ldrh	r3, [r3, #0]
	str	r3, [sp, #8]
	ldr	r3, .L1462
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1456
	ldr	ip, [sp, #8]
	movs	r6, #1
	lsr	ip, ip, #2
	str	ip, [sp, #4]
	b	.L1442
.L1455:
	mov	ip, #6
	str	ip, [sp, #4]
	mov	ip, #1
	str	ip, [sp, #8]
	b	.L1442
.L1456:
	movs	r6, #1
	str	r6, [sp, #4]
.L1442:
	ldr	sl, .L1462+24
	movs	r7, #0
.L1450:
	mov	fp, #0
	mov	r4, fp
	b	.L1443
.L1446:
	mov	ip, #36
	ldr	r2, [sl, #0]
	ldr	r1, .L1462+8
	movs	r0, #0
	mul	r3, ip, fp
	str	r2, [sp, #16]
	str	r0, [r2, r3]
	ldrb	r0, [r1, fp]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	V2P_block
	str	r0, [sp, #20]
	cmp	r8, #0
	beq	.L1444
	bl	IsBlkInVendorPart
	cbnz	r0, .L1445
.L1444:
	ldr	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1445
	ldr	r2, [sp, #16]
	mov	ip, #36
	ldr	r1, [sp, #20]
	ldr	r0, .L1462+32
	mla	r3, ip, r4, r2
	add	r2, r7, r1, lsl #10
	ldr	r1, .L1462+12
	str	r2, [r3, #4]
	ldr	r2, [r0, #0]
	ldr	r0, .L1462+36
	str	r2, [r3, #8]
	ldrh	r2, [r1, #0]
	muls	r2, r4, r2
	adds	r4, r4, #1
	ldr	r1, [r0, #0]
	bic	r2, r2, #3
	uxth	r4, r4
	adds	r2, r1, r2
	str	r2, [r3, #12]
.L1445:
	add	fp, fp, #1
	uxth	fp, fp
.L1443:
	ldr	r1, .L1462+20
	ldrh	r3, [r1, #0]
	cmp	r3, fp
	bhi	.L1446
	cmp	r4, #0
	beq	.L1439
	mov	r1, r4
	mov	r2, r6
	ldr	r0, [sl, #0]
	movs	r3, #1
	mov	fp, #0
	bl	FlashProgPages
	mov	ip, r8
	mov	r8, r6
	mov	r6, r4
	mov	r4, fp
.L1449:
	ldr	r2, [sl, #0]
	add	r1, r2, fp
	ldr	r2, [r2, fp]
	cbz	r2, .L1448
	ldr	r0, [r1, #4]
	adds	r5, r5, #1
	str	ip, [sp, #0]
	ubfx	r0, r0, #10, #16
	uxth	r5, r5
	bl	FtlBbmMapBadBlock
	ldr	ip, [sp, #0]
.L1448:
	adds	r4, r4, #1
	add	fp, fp, #36
	uxth	r4, r4
	cmp	r4, r6
	bne	.L1449
	mov	r4, r6
	mov	r6, r8
	mov	r8, ip
	ldr	ip, [sp, #4]
	add	r7, r7, ip
	ldr	ip, [sp, #8]
	uxth	r7, r7
	cmp	r7, ip
	bcc	.L1450
	movs	r7, #0
	ldr	fp, .L1462+24
	mov	sl, r7
.L1452:
	cmp	r8, #0
	beq	.L1451
	ldr	r3, [fp, #0]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	cbnz	r3, .L1451
	ldr	r0, [r2, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1451:
	add	sl, sl, #1
	adds	r7, r7, #36
	uxth	sl, sl
	cmp	sl, r4
	bne	.L1452
	ldr	r0, [sp, #12]
	cmp	r0, #63
	bls	.L1453
	cmp	r8, #0
	beq	.L1439
.L1453:
	ldr	r3, .L1462+24
	mov	r1, r6
	mov	r2, r4
	ldr	r0, [r3, #0]
	bl	FlashEraseBlocks
.L1439:
	mov	r0, r5
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1463:
	.align	2
.L1462:
	.word	.LANCHOR7
	.word	.LANCHOR88
	.word	.LANCHOR62
	.word	.LANCHOR74
	.word	.LANCHOR181
	.word	.LANCHOR53
	.word	.LANCHOR93
	.word	.LANCHOR69
	.word	.LANCHOR178
	.word	.LANCHOR179
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
	ldr	r3, .L1469
	push	{r4, r5, lr}
	mov	r4, r0
	ldr	r3, [r3, #0]
	sub	sp, sp, #108
	cmp	r0, r3
	bcc	.L1467
.L1466:
	ldr	r5, .L1469+4
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
	b	.L1465
.L1467:
	movs	r4, #0
.L1465:
	mov	r0, r4
	add	sp, sp, #108
	pop	{r4, r5, pc}
.L1470:
	.align	2
.L1469:
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
	ldr	sl, [r0, #24]
	bl	ftl_free_no_use_map_blk
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4, #8]
	subs	r3, r3, #4
	cmp	r2, r3
	blt	.L1472
	uxth	r0, r0
	ldrh	r7, [r5, r0, lsl #1]
	cmp	r7, #0
	beq	.L1472
	ldr	r3, [r4, #32]
	cmp	r3, #0
	bne	.L1472
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L1480
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1473
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1473:
	movs	r5, #0
	ldr	r6, .L1480+4
	ldr	fp, .L1480+28
	mov	r8, r7
	b	.L1474
.L1478:
	lsls	r3, r5, #2
	str	r3, [sp, #4]
	ldr	r3, [sl, r5, lsl #2]
	cmp	r8, r3, lsr #10
	bne	.L1475
	ldr	r2, [fp, #0]
	movs	r1, #1
	ldr	r0, .L1480+4
	str	r3, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L1480+8
	ldr	r7, [r2, #0]
	mov	r2, r1
	str	r7, [r6, #12]
	bl	FlashReadPages
	ldrh	r3, [r7, #8]
	cmp	r3, r5
	beq	.L1476
	ldr	r1, .L1480+12
	movw	r2, #585
	ldr	r0, .L1480+16
	bl	printf
	ldr	r0, .L1480+20
	ldr	r1, .L1480+24
	bl	printf
.L1476:
	ldr	r3, .L1480+4
	ldr	r3, [r3, #0]
	adds	r3, r3, #1
	bne	.L1477
	ldr	r2, [sp, #4]
	movs	r3, #0
	str	r3, [sl, r2]
	b	.L1475
.L1477:
	mov	r0, r4
	mov	r1, r5
	ldr	r2, [r6, #8]
	bl	FtlMapWritePage
.L1475:
	adds	r5, r5, #1
	uxth	r5, r5
.L1474:
	ldrh	r3, [r4, #6]
	cmp	r3, r5
	bhi	.L1478
	mov	r7, r8
	mov	r0, r8
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L1472:
	ldr	r3, .L1480
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1479
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1479:
	movs	r0, #0
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1481:
	.align	2
.L1480:
	.word	.LANCHOR69
	.word	.LANCHOR197
	.word	.LANCHOR180
	.word	.LANCHOR210
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR176
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
	push	{r3, r4, r5, r6, r7, lr}
	movw	r2, #65535
	ldrh	r3, [r0, #0]
	mov	r4, r0
	ldr	r5, [r0, #12]
	cmp	r3, r2
	ldr	r7, [r0, #24]
	bne	.L1483
	ldrh	r3, [r0, #8]
	cbz	r3, .L1484
	ldr	r1, .L1489
	movw	r2, #613
	ldr	r0, .L1489+4
	bl	printf
	ldr	r0, .L1489+8
	ldr	r1, .L1489+12
	bl	printf
.L1484:
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
	b	.L1485
.L1483:
	ldrh	r5, [r5, r3, lsl #1]
	movs	r1, #255
	ldr	r2, .L1489+16
	ldrh	r3, [r0, #2]
	ldr	r6, .L1489+20
	orr	r3, r3, r5, lsl #10
	str	r3, [r2, #4]
	ldr	r3, .L1489+24
	ldr	r0, [r6, #0]
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
	ldr	r3, .L1489+28
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #3
	bl	memset
	movs	r3, #0
	ldrh	r0, [r4, #6]
	mov	r2, r3
	ldr	r1, [r6, #0]
	b	.L1486
.L1488:
	ldr	r6, [r7], #4
	cmp	r5, r6, lsr #10
	bne	.L1487
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r6, r1, r2, lsl #3
	ldr	lr, [r7, #-4]
	str	lr, [r6, #4]
.L1487:
	adds	r3, r3, #1
.L1486:
	uxth	r6, r3
	cmp	r6, r0
	bcc	.L1488
	movs	r1, #1
	movs	r3, #0
	ldr	r0, .L1489+16
	mov	r2, r1
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
.L1485:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L1490:
	.align	2
.L1489:
	.word	.LANCHOR211
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR197
	.word	.LANCHOR96
	.word	.LANCHOR180
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
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r7, .L1507
	movs	r6, #0
	ldr	r8, .L1507+32
	ldr	r5, .L1507+4
	ldr	fp, .L1507+36
	stmia	sp, {r1, r2}
.L1505:
	ldr	r3, [r7, #0]
	ldrh	r2, [r4, #2]
	adds	r3, r3, #1
	str	r3, [r7, #0]
	ldrh	r3, [r8, #0]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L1493
	ldrh	r3, [r4, #0]
	movw	r1, #65535
	cmp	r3, r1
	bne	.L1494
.L1493:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L1494:
	ldrh	r2, [r4, #0]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L1495
	ldr	r1, .L1507+8
	movw	r2, #671
	ldr	r0, .L1507+12
	bl	printf
	ldr	r0, .L1507+16
	ldr	r1, .L1507+20
	bl	printf
.L1495:
	ldrh	r2, [r4, #0]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L1496
	ldr	r1, .L1507+8
	mov	r2, #672
	ldr	r0, .L1507+12
	bl	printf
	ldr	r0, .L1507+16
	ldr	r1, .L1507+20
	bl	printf
.L1496:
	ldrh	r2, [r4, #0]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r0, [fp, #0]
	ldrh	sl, [r3, r2, lsl #1]
	ldr	r2, [sp, #4]
	ldrh	r3, [r4, #2]
	str	r0, [r5, #12]
	str	r2, [r5, #8]
	movs	r2, #16
	orr	r3, r3, sl, lsl #10
	str	r3, [r5, #4]
	bl	memset
	ldr	r3, [r5, #12]
	ldr	r2, [r4, #28]
	ldr	r1, [sp, #0]
	ldr	r0, .L1507+4
	str	r2, [r3, #4]
	ldrh	r2, [r4, #4]
	strh	r1, [r3, #8]	@ movhi
	movs	r1, #1
	strh	sl, [r3, #2]	@ movhi
	strh	r2, [r3, #0]	@ movhi
	mov	r2, r1
	mov	r3, r1
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5, #0]
	adds	r3, r3, #1
	adds	r2, r2, #1
	uxth	r3, r3
	strh	r3, [r4, #2]	@ movhi
	bne	.L1497
	ldr	r0, .L1507+24
	adds	r6, r6, #1
	ldr	r1, [r5, #4]
	bl	printf
	ldrh	r3, [r4, #2]
	uxth	r6, r6
	cmp	r3, #2
	bhi	.L1498
	ldrh	r3, [r8, #0]
	subs	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L1498:
	cmp	r6, #3
	bls	.L1499
	ldr	r3, .L1507+4
	mov	r2, r6
	ldr	r0, .L1507+28
	ldr	r1, [r3, #4]
	bl	printf
.L1500:
	b	.L1500
.L1499:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L1505
.L1506:
	b	.L1506
.L1497:
	cmp	r3, #1
	beq	.L1505
	ldr	r3, .L1507+4
	movs	r0, #0
	ldr	r1, [sp, #0]
	ldr	r2, [r3, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r1, lsl #2]
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1508:
	.align	2
.L1507:
	.word	.LANCHOR159
	.word	.LANCHOR197
	.word	.LANCHOR212
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC30
	.word	.LC31
	.word	.LANCHOR69
	.word	.LANCHOR180
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
	beq	.L1509
	movs	r3, #0
	str	r3, [r0, #36]
	ldr	r3, .L1515
	ldr	r5, .L1515+4
	ldr	r3, [r3, #0]
	str	r3, [r5, #8]
	ldr	r3, .L1515+8
	ldr	r7, [r3, #0]
	ldrh	r3, [r0, #2]
	str	r7, [r5, #12]
	cbz	r3, .L1511
	ldr	r2, .L1515+12
	ldrh	r2, [r2, #0]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L1511
	ldrh	r2, [r0, #0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1511
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
	beq	.L1511
	ldr	r3, [r4, #24]
	ldrh	r1, [r7, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L1511
	mov	r0, r4
	b	.L1514
.L1511:
	subs	r6, r6, #1
	ldr	r5, .L1515+4
	uxth	r6, r6
	ldr	r3, [r8, r6, lsl #2]
	str	r3, [r5, #4]
	cbz	r3, .L1512
	movs	r1, #1
	mov	r0, r5
	mov	r2, r1
	bl	FlashReadPages
	b	.L1513
.L1512:
	ldr	r3, .L1515+16
	movs	r1, #255
	ldr	r0, [r5, #8]
	ldrh	r2, [r3, #0]
	bl	memset
.L1513:
	mov	r0, r4
	mov	r1, r6
.L1514:
	ldr	r2, [r5, #8]
	pop	{r4, r5, r6, r7, r8, lr}
	b	FtlMapWritePage
.L1509:
	pop	{r4, r5, r6, r7, r8, pc}
.L1516:
	.align	2
.L1515:
	.word	.LANCHOR176
	.word	.LANCHOR197
	.word	.LANCHOR180
	.word	.LANCHOR69
	.word	.LANCHOR73
	.size	FtlMapBlkWriteDumpData, .-FtlMapBlkWriteDumpData
	.section	.text.FtlVendorPartWrite,"ax",%progbits
	.align	1
	.global	FtlVendorPartWrite
	.thumb
	.thumb_func
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1527
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #56
	ldrh	sl, [r3, #0]
	mov	r6, r0
	ldr	r3, .L1527+4
	mov	r4, r1
	str	r2, [sp, #8]
	adds	r2, r1, r0
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bhi	.L1525
	lsr	sl, r0, sl
	mov	fp, #0
	ldr	r7, .L1527+8
	lsl	r3, sl, #2
	str	r3, [sp, #4]
	b	.L1519
.L1524:
	ldr	r2, .L1527+12
	mov	r0, r6
	ldr	r3, [r2, #0]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, r2]
	ldr	r2, .L1527+16
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
	cbz	r3, .L1521
	cmp	r5, r8
	beq	.L1521
	str	r3, [sp, #24]
	movs	r1, #1
	ldr	r3, [r7, #0]
	add	r0, sp, #20
	mov	r2, r1
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
	b	.L1522
.L1521:
	ldr	r3, .L1527+20
	movs	r1, #0
	ldr	r0, [r7, #0]
	ldrh	r2, [r3, #0]
	bl	memset
.L1522:
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
	ldr	r0, .L1527+24
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
.L1519:
	cmp	r4, #0
	bne	.L1524
	b	.L1518
.L1525:
	mov	fp, #-1
.L1518:
	mov	r0, fp
	add	sp, sp, #56
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1528:
	.align	2
.L1527:
	.word	.LANCHOR72
	.word	.LANCHOR65
	.word	.LANCHOR177
	.word	.LANCHOR186
	.word	.LANCHOR71
	.word	.LANCHOR73
	.word	.LANCHOR213
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
	ldr	r2, .L1531
	ldr	r3, .L1531+4
	ldr	r1, [r2, #0]
	cmp	r1, r3
	bne	.L1529
	ldr	r3, .L1531+8
	movs	r0, #0
	movs	r1, #1
	str	r3, [r2, #4]
	ldr	r3, .L1531+12
	ldr	r3, [r3, #0]
	str	r3, [r2, #88]
	ldr	r3, .L1531+16
	ldr	r3, [r3, #0]
	str	r3, [r2, #92]
	ldr	r3, .L1531+20
	ldr	r3, [r3, #0]
	str	r3, [r2, #8]
	ldr	r3, .L1531+24
	ldr	r3, [r3, #0]
	str	r3, [r2, #12]
	ldr	r3, .L1531+28
	ldr	r3, [r3, #0]
	str	r3, [r2, #16]
	ldr	r3, .L1531+32
	ldr	r3, [r3, #0]
	str	r3, [r2, #20]
	ldr	r3, .L1531+36
	ldr	r3, [r3, #0]
	str	r3, [r2, #28]
	ldr	r3, .L1531+40
	ldr	r3, [r3, #0]
	str	r3, [r2, #32]
	ldr	r3, .L1531+44
	ldr	r3, [r3, #0]
	str	r3, [r2, #36]
	ldr	r3, .L1531+48
	ldr	r3, [r3, #0]
	str	r3, [r2, #40]
	ldr	r3, .L1531+52
	ldr	r3, [r3, #0]
	str	r3, [r2, #44]
	ldr	r3, .L1531+56
	ldr	r3, [r3, #0]
	str	r3, [r2, #48]
	ldr	r3, .L1531+60
	ldr	r3, [r3, #0]
	str	r3, [r2, #60]
	ldr	r3, .L1531+64
	ldr	r3, [r3, #0]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L1529:
	bx	lr
.L1532:
	.align	2
.L1531:
	.word	.LANCHOR141
	.word	1179929683
	.word	1342177344
	.word	.LANCHOR193
	.word	.LANCHOR194
	.word	.LANCHOR155
	.word	.LANCHOR156
	.word	.LANCHOR160
	.word	.LANCHOR159
	.word	.LANCHOR162
	.word	.LANCHOR95
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR152
	.word	.LANCHOR151
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
	ldr	r3, .L1540
	ldr	r3, [r3, #0]
	cbz	r3, .L1538
	ldr	r3, .L1540+4
	ldr	r3, [r3, #0]
	cmp	r3, #29
	ite	ls
	movls	r3, #4
	movhi	r3, #32
	b	.L1534
.L1538:
	movs	r3, #32
.L1534:
	ldr	r2, .L1540+8
	ldrh	r1, [r2, #0]
	cmp	r1, #31
	bhi	.L1535
	movs	r3, #1
	adds	r1, r1, #1
	strh	r1, [r2, #0]	@ movhi
.L1535:
	ldr	r2, .L1540+12
	cbnz	r0, .L1536
	ldr	r1, [r2, #0]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	adds	r3, r3, r0
	cmp	r1, r3
	bcc	.L1537
.L1536:
	ldr	r2, [r2, #0]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1540+16
	str	r3, [r2, #0]
	ldr	r3, .L1540+20
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
.L1537:
	movs	r0, #0
	pop	{r3, pc}
.L1541:
	.align	2
.L1540:
	.word	.LANCHOR126
	.word	.LANCHOR164
	.word	.LANCHOR214
	.word	.LANCHOR183
	.word	1112818501
	.word	.LANCHOR182
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
	ldr	r5, .L1543
	ldr	r0, .L1543+4
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
.L1544:
	.align	2
.L1543:
	.word	.LANCHOR112
	.word	.LANCHOR120
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.log2phys,"ax",%progbits
	.align	1
	.global	log2phys
	.thumb
	.thumb_func
	.type	log2phys, %function
log2phys:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1555
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #1
	ldrh	r3, [r3, #0]
	mov	r6, r1
	mov	r7, r2
	adds	r3, r3, #7
	lsr	r4, r0, r3
	lsl	r5, r5, r3
	ldr	r3, .L1555+4
	subs	r5, r5, #1
	ands	r5, r5, r0
	uxth	r4, r4
	ldr	r3, [r3, #0]
	uxth	r5, r5
	cmp	r0, r3
	bcc	.L1546
	ldr	r1, .L1555+8
	movw	r2, #781
	ldr	r0, .L1555+12
	bl	printf
	ldr	r0, .L1555+16
	ldr	r1, .L1555+20
	bl	printf
.L1546:
	ldr	r3, .L1555+24
	ldrh	r1, [r3, #0]
	ldr	r3, .L1555+28
	ldr	r2, [r3, #0]
	movs	r3, #0
	mov	r8, r3
	b	.L1547
.L1553:
	adds	r3, r3, #12
	adds	r0, r2, r3
	ldrh	r0, [r0, #-12]
	cmp	r0, r4
	bne	.L1548
.L1549:
	ldr	r2, .L1555+28
	movs	r3, #12
	ldr	r2, [r2, #0]
	mla	r3, r3, r8, r2
	cbnz	r7, .L1550
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r6, #0]
	b	.L1551
.L1550:
	ldr	r1, [r6, #0]
	ldr	r2, [r3, #8]
	str	r1, [r2, r5, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L1555+32
	strh	r4, [r3, #0]	@ movhi
.L1551:
	ldr	r3, .L1555+28
	movs	r2, #12
	ldr	r3, [r3, #0]
	mla	r3, r2, r8, r3
	ldr	r2, [r3, #4]
	adds	r1, r2, #1
	beq	.L1552
	adds	r2, r2, #1
	str	r2, [r3, #4]
.L1552:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L1548:
	add	r8, r8, #1
	uxth	r8, r8
.L1547:
	cmp	r8, r1
	bne	.L1553
	bl	select_l2p_ram_region
	movs	r3, #12
	ldr	r2, .L1555+28
	ldr	r2, [r2, #0]
	mul	r3, r3, r0
	mov	r8, r0
	adds	r1, r2, r3
	ldrh	r2, [r2, r3]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1554
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L1554
	bl	flush_l2p_region
.L1554:
	mov	r0, r4
	mov	r1, r8
	bl	load_l2p_region
	b	.L1549
.L1556:
	.align	2
.L1555:
	.word	.LANCHOR72
	.word	.LANCHOR87
	.word	.LANCHOR215
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR83
	.word	.LANCHOR112
	.word	.LANCHOR113
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
	ldr	r3, .L1564
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r0, lsl #1]
	mov	r4, r0
	cmp	r2, #0
	bne	.L1558
	ldr	r3, .L1564+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	beq	.L1559
	ldr	r1, .L1564+8
	movs	r5, #6
	ldr	r0, .L1564+12
	ldrh	r7, [r1, #0]
	ldr	r1, .L1564+16
	ldr	r1, [r1, #0]
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	movw	r0, #65535
	uxth	r3, r3
	b	.L1560
.L1563:
	cmp	r3, r4
	bne	.L1561
	ldr	r5, .L1564+8
	mov	r1, r4
	ldr	r0, .L1564+4
	bl	List_remove_node
	ldrh	r3, [r5, #0]
	cbnz	r3, .L1562
	ldr	r1, .L1564+20
	movw	r2, #1677
	ldr	r0, .L1564+24
	bl	printf
	ldr	r0, .L1564+28
	ldr	r1, .L1564+32
	bl	printf
.L1562:
	ldrh	r3, [r5, #0]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5, #0]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L1564
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r4, lsl #1]
	b	.L1558
.L1561:
	muls	r3, r5, r3
	ldrh	r3, [r1, r3]
	cmp	r3, r0
	beq	.L1559
	adds	r2, r2, #1
	uxth	r2, r2
.L1560:
	cmp	r2, r7
	bne	.L1563
	b	.L1559
.L1558:
	adds	r2, r2, #1
	strh	r2, [r3, r4, lsl #1]	@ movhi
.L1559:
	mov	r0, r6
	add	r1, sp, #4
	movs	r2, #1
	bl	log2phys
	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
.L1565:
	.align	2
.L1564:
	.word	.LANCHOR99
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	-1431655765
	.word	.LANCHOR97
	.word	.LANCHOR216
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	ldr	r7, .L1570
	movs	r5, #12
	ldr	r6, .L1570+4
	b	.L1567
.L1569:
	ldr	r3, [r6, #0]
	mla	r3, r5, r4, r3
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L1568
	mov	r0, r4
	bl	flush_l2p_region
.L1568:
	adds	r4, r4, #1
	uxth	r4, r4
.L1567:
	ldrh	r3, [r7, #0]
	cmp	r3, r4
	bhi	.L1569
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L1571:
	.align	2
.L1570:
	.word	.LANCHOR83
	.word	.LANCHOR112
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
	ldr	r3, .L1584
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0, #0]
	ldrh	r3, [r3, #0]
	cmp	r3, r5
	bhi	.L1573
	ldr	r1, .L1584+4
	movw	r2, #2707
	ldr	r0, .L1584+8
	bl	printf
	ldr	r0, .L1584+12
	ldr	r1, .L1584+16
	bl	printf
.L1573:
	movw	r3, #65535
	cmp	r5, r3
	beq	.L1574
	ldr	r3, .L1584+20
	mov	r0, r5
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L1575
	bl	INSERT_DATA_LIST
	b	.L1574
.L1575:
	bl	INSERT_FREE_LIST
.L1574:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L1584+24
	cmp	r4, r3
	beq	.L1576
	ldr	r3, .L1584+28
	ldrh	r3, [r3, #0]
	cmp	r3, #1
	beq	.L1576
	ldr	r2, .L1584+32
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1577
.L1576:
	movs	r3, #1
	strb	r3, [r4, #8]
	b	.L1578
.L1577:
	ldr	r2, .L1584+36
	cmp	r4, r2
	bne	.L1578
	cmp	r3, #3
	beq	.L1579
	ldr	r3, .L1584+40
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L1580
.L1579:
	movs	r3, #1
	strb	r3, [r2, #8]
.L1580:
	ldr	r3, .L1584+44
	ldr	r3, [r3, #0]
	cbz	r3, .L1578
	ldr	r3, .L1584+48
	ldr	r3, [r3, #0]
	cmp	r3, #29
	bhi	.L1578
	ldr	r3, .L1584+36
	movs	r2, #1
	strb	r2, [r3, #8]
.L1578:
	ldr	r6, .L1584+52
	movw	r3, #65535
	ldrh	r0, [r6, #0]
	cmp	r0, r3
	beq	.L1581
	cmp	r5, r0
	bne	.L1582
	ldr	r3, .L1584+20
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1583
.L1582:
	bl	update_vpc_list
.L1583:
	movw	r3, #65535
	strh	r3, [r6, #0]	@ movhi
.L1581:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1585:
	.align	2
.L1584:
	.word	.LANCHOR55
	.word	.LANCHOR217
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR99
	.word	.LANCHOR108
	.word	.LANCHOR59
	.word	.LANCHOR7
	.word	.LANCHOR107
	.word	.LANCHOR152
	.word	.LANCHOR126
	.word	.LANCHOR164
	.word	.LANCHOR135
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
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
	ldr	r3, .L1602
	mov	r5, r0
	str	r1, [sp, #4]
	ldrb	r7, [r3, #0]	@ zero_extendqisi2
	cbz	r7, .L1587
	ldrb	r7, [r4, #8]	@ zero_extendqisi2
	sub	r2, r7, #1
	rsbs	r7, r2, #0
	adc	r7, r7, r2
.L1587:
	mov	r0, r5
	ldr	r1, [sp, #4]
	mov	r2, r7
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	bl	FlashProgPages
	mov	sl, #0
	ldr	r6, .L1602+4
	ldr	fp, .L1602+36
	b	.L1588
.L1591:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4, #0]
	cmp	r3, r0
	bne	.L1589
	ldr	r2, [r6, #0]
	ldrh	r1, [r4, #4]
	ldrh	r0, [r2, r3, lsl #1]
	subs	r1, r0, r1
	strh	r1, [r2, r3, lsl #1]	@ movhi
	ldr	r2, .L1602+8
	strb	r8, [r4, #6]
	strh	r8, [r4, #4]	@ movhi
	ldrh	r3, [r2, #0]
	strh	r3, [r4, #2]	@ movhi
.L1589:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1590
	mov	r0, r4
	bl	allocate_new_data_superblock
.L1590:
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
	b	.L1600
.L1601:
	mov	r8, #0
.L1600:
	ldr	r3, [r5, #0]
	adds	r3, r3, #1
	beq	.L1591
	ldr	r3, .L1602+12
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1592
	ldr	r1, .L1602+16
	mov	r2, #1464
	ldr	r0, .L1602+20
	bl	printf
	ldr	r0, .L1602+24
	ldr	r1, .L1602+28
	bl	printf
.L1592:
	ldr	r3, [r5, #4]
	str	r3, [sp, #12]
	cbz	r7, .L1593
	orr	r3, r3, #-2147483648
	str	r3, [sp, #12]
.L1593:
	movs	r2, #1
	ldr	r0, [r5, #16]
	add	r1, sp, #12
	bl	log2phys
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #12]
	adds	r3, r0, #1
	beq	.L1594
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, [r6, #0]
	ldrh	r2, [r3, r0, lsl #1]
	mov	r8, r0
	cbnz	r2, .L1595
	ldr	r0, .L1602+32
	mov	r1, r8
	bl	printf
.L1595:
	mov	r0, r8
	bl	decrement_vpc_count
.L1594:
	add	sl, sl, #1
	adds	r5, r5, #36
.L1588:
	ldr	r3, [sp, #4]
	cmp	sl, r3
	bne	.L1601
	ldr	r3, .L1602+12
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L1586
	ldr	r1, .L1602+16
	movw	r2, #1481
	ldr	r0, .L1602+20
	bl	printf
	ldr	r0, .L1602+24
	ldr	r1, .L1602+28
	bl	printf
.L1586:
	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1603:
	.align	2
.L1602:
	.word	.LANCHOR7
	.word	.LANCHOR99
	.word	.LANCHOR68
	.word	.LANCHOR53
	.word	.LANCHOR218
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC32
	.word	.LANCHOR141
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
	ldr	r4, .L1606
	ldr	r0, [r4, #0]
	cbz	r0, .L1605
	ldr	r3, .L1606+4
	movs	r1, #1
	movs	r2, #0
	ldr	r3, [r3, #0]
	bl	FtlProgPages
	movs	r3, #0
	str	r3, [r4, #0]
.L1605:
	movs	r0, #0
	pop	{r4, pc}
.L1607:
	.align	2
.L1606:
	.word	.LANCHOR134
	.word	.LANCHOR219
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.FtlGcFreeTempBlock,"ax",%progbits
	.align	1
	.global	FtlGcFreeTempBlock
	.thumb
	.thumb_func
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	ldr	r0, .L1624
	ldr	r3, .L1624+4
	ldrh	r4, [r0, #0]
	ldrh	r1, [r3, #0]
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1609
	bl	FtlGcScanTempBlk
	str	r0, [sp, #4]
	adds	r0, r0, #1
	beq	.L1609
	ldr	r3, .L1624+8
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r4, lsl #1]
	cmp	r2, #4
	bls	.L1610
	subs	r2, r2, #5
	movs	r0, #1
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L1610:
	ldr	r3, .L1624+12
	ldr	r3, [r3, #0]
	cbnz	r3, .L1611
	ldr	r3, .L1624+16
	ldr	r0, [sp, #4]
	ldr	r2, [r3, #96]
	ubfx	r0, r0, #10, #16
	adds	r2, r2, #1
	str	r2, [r3, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1611:
	ldr	r3, .L1624+12
	movs	r2, #0
	movs	r4, #1
	str	r2, [r3, #0]
	b	.L1612
.L1609:
	ldr	r5, .L1624
	movs	r4, #0
	ldr	r3, .L1624+12
	ldrh	r2, [r5, #0]
	str	r4, [r3, #0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1612
	bl	FtlCacheWriteBack
	ldr	r3, .L1624+20
	ldr	r1, .L1624+4
	ldrh	r2, [r3, #0]
	ldrh	r1, [r1, #0]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L1613
	ldr	r1, .L1624+24
	movs	r2, #161
	ldr	r0, .L1624+28
	bl	printf
	ldr	r0, .L1624+32
	ldr	r1, .L1624+36
	bl	printf
.L1613:
	ldr	r3, .L1624
	movs	r5, #0
	ldr	r2, .L1624+40
	ldr	r4, .L1624+4
	ldrh	r1, [r3, #0]
	ldr	r2, [r2, #0]
	ldrh	r4, [r4, #0]
	ldrb	r0, [r3, #7]	@ zero_extendqisi2
	muls	r0, r4, r0
	strh	r0, [r2, r1, lsl #1]	@ movhi
	ldr	r1, .L1624+44
	ldr	r2, .L1624+20
	ldr	fp, .L1624+68
	ldr	r0, [r1, #0]
	mov	sl, r2
	ldrh	r4, [r2, #0]
	ldr	r8, .L1624+72
	adds	r0, r4, r0
	str	r0, [r1, #0]
	b	.L1614
.L1618:
	ldr	r7, [fp, #0]
	movs	r6, #12
	muls	r6, r5, r6
	ldr	r3, [r8, #0]
	adds	r4, r7, r6
	ldr	r2, [r4, #8]
	cmp	r2, r3
	bcc	.L1615
	ldr	r1, .L1624+24
	movs	r2, #166
	ldr	r0, .L1624+28
	bl	printf
	ldr	r0, .L1624+32
	ldr	r1, .L1624+36
	bl	printf
.L1615:
	movs	r2, #0
	ldr	r0, [r4, #8]
	add	r1, sp, #4
	bl	log2phys
	ldr	r0, [sp, #4]
	ldr	r3, [r7, r6]
	cmp	r0, r3
	bne	.L1616
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	adds	r1, r4, #4
	movs	r2, #1
	mov	r6, r0
	ldr	r0, [r4, #8]
	bl	log2phys
	mov	r0, r6
	b	.L1623
.L1616:
	ldr	r3, [r4, #4]
	cmp	r0, r3
	beq	.L1617
	ldr	r3, .L1624
	ldrh	r0, [r3, #0]
.L1623:
	bl	decrement_vpc_count
.L1617:
	adds	r5, r5, #1
	uxth	r5, r5
.L1614:
	ldrh	r3, [sl, #0]
	cmp	r3, r5
	bhi	.L1618
	movw	r0, #65535
	ldr	r4, .L1624
	bl	decrement_vpc_count
	ldr	r3, .L1624+40
	ldrh	r0, [r4, #0]
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1619
	bl	INSERT_DATA_LIST
	b	.L1620
.L1619:
	bl	INSERT_FREE_LIST
.L1620:
	ldr	r3, .L1624+20
	movw	r5, #65535
	strh	r5, [r4, #0]	@ movhi
	movs	r4, #0
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1624+48
	strh	r4, [r3, #0]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1624+52
	ldr	r2, .L1624+56
	movs	r1, #3
	ldrh	r3, [r3, #0]
	ldrh	r2, [r2, #0]
	muls	r2, r1, r2
	cmp	r3, r2, lsr #2
	ble	.L1612
	ldr	r3, .L1624+60
	movs	r2, #20
	strh	r5, [r3, #0]	@ movhi
	ldr	r3, .L1624+64
	strh	r2, [r3, #0]	@ movhi
.L1612:
	mov	r0, r4
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1625:
	.align	2
.L1624:
	.word	.LANCHOR109
	.word	.LANCHOR68
	.word	.LANCHOR94
	.word	.LANCHOR137
	.word	.LANCHOR141
	.word	.LANCHOR144
	.word	.LANCHOR220
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR99
	.word	.LANCHOR155
	.word	.LANCHOR142
	.word	.LANCHOR104
	.word	.LANCHOR200
	.word	.LANCHOR201
	.word	.LANCHOR170
	.word	.LANCHOR145
	.word	.LANCHOR87
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
	ldr	r3, .L1635
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	ldr	r3, .L1635+4
	cbz	r2, .L1627
	ldr	r2, [r3, #0]
	lsls	r2, r2, #31
	bpl	.L1627
	ldr	r2, .L1635+8
	ldrh	r2, [r2, #4]
	cmp	r2, #0
	bne	.L1632
.L1627:
	ldr	r4, .L1635+12
	movs	r2, #0
	ldr	r1, [r3, #0]
	mov	r3, r2
	movs	r5, #0
	ldr	r7, .L1635+4
	ldr	r0, [r4, #0]
	movs	r6, #36
	bl	FlashProgPages
	b	.L1629
.L1631:
	mul	r3, r6, r5
	ldr	r1, [r4, #0]
	adds	r2, r1, r3
	ldr	r1, [r1, r3]
	adds	r0, r1, #1
	bne	.L1630
	ldr	r3, .L1635+8
	movs	r5, #0
	ldr	r0, .L1635+16
	ldrh	r4, [r3, #0]
	ldr	r0, [r0, #0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r1, [r3, #0]	@ movhi
	ldr	r3, .L1635+20
	ldr	r0, [r2, #4]
	ldr	r1, [r3, #96]
	ubfx	r0, r0, #10, #16
	adds	r1, r1, #1
	str	r1, [r3, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
	b	.L1634
.L1630:
	ldr	r3, [r2, #12]
	adds	r5, r5, #1
	ldr	r1, [r2, #4]
	uxth	r5, r5
	ldr	r0, [r3, #12]
	ldr	r2, [r3, #8]
	bl	FtlGcUpdatePage
.L1629:
	ldr	r1, [r7, #0]
	cmp	r5, r1
	bcc	.L1631
	ldr	r3, .L1635+12
	ldr	r0, [r3, #0]
	bl	FtlGcBufFree
	ldr	r3, .L1635+4
	movs	r0, #0
	str	r0, [r3, #0]
	ldr	r3, .L1635+8
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1628
	movs	r0, #1
	bl	FtlGcFreeTempBlock
.L1634:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L1632:
	movs	r0, #0
.L1628:
	pop	{r3, r4, r5, r6, r7, pc}
.L1636:
	.align	2
.L1635:
	.word	.LANCHOR7
	.word	.LANCHOR128
	.word	.LANCHOR109
	.word	.LANCHOR174
	.word	.LANCHOR99
	.word	.LANCHOR141
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
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
	ldr	r4, .L1639
	ldr	r5, .L1639+4
	ldrh	r1, [r4, #0]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4, #0]
	cmp	r2, r3
	bcc	.L1637
	ldr	r0, .L1639+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1639+12
	movs	r2, #0
	str	r2, [r3, #0]
.L1637:
	pop	{r3, r4, r5, pc}
.L1640:
	.align	2
.L1639:
	.word	.LANCHOR68
	.word	.LANCHOR109
	.word	.LANCHOR120
	.word	.LANCHOR137
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
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
	ldr	r5, .L1644
	ldrh	r2, [r5, #0]
	cmp	r2, r3
	beq	.L1642
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1643
.L1642:
	bl	FtlCacheWriteBack
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1644
	movs	r4, #0
	strb	r4, [r5, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1644+4
	strh	r4, [r3, #0]	@ movhi
	ldr	r3, .L1644+8
	strh	r4, [r3, #0]	@ movhi
	bl	l2p_flush
	mov	r0, r4
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1643:
	ldr	r0, .L1644
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1645:
	.align	2
.L1644:
	.word	.LANCHOR109
	.word	.LANCHOR142
	.word	.LANCHOR144
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.ftl_discard,"ax",%progbits
	.align	1
	.global	ftl_discard
	.thumb
	.thumb_func
	.type	ftl_discard, %function
ftl_discard:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1655
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r4, r2
	ldr	r3, [r3, #0]
	adds	r2, r2, r1
	mov	r6, r1
	cmp	r2, r3
	bhi	.L1652
	cmp	r4, #31
	bls	.L1653
	bl	FtlCacheWriteBack
	ldr	r3, .L1655+4
	mov	r0, r6
	ldrh	r7, [r3, #0]
	mov	r1, r7
	bl	__aeabi_uidiv
	mls	r6, r0, r7, r6
	mov	r5, r0
	uxth	r6, r6
	cbz	r6, .L1648
	subs	r6, r7, r6
	adds	r5, r0, #1
	cmp	r6, r4
	it	cs
	movcs	r6, r4
	uxth	r6, r6
	subs	r4, r4, r6
.L1648:
	mov	r3, #-1
	ldr	r8, .L1655+4
	str	r3, [sp, #4]
	ldr	r7, .L1655+8
	ldr	r6, .L1655+12
	b	.L1649
.L1651:
	movs	r2, #0
	mov	r0, r5
	mov	r1, sp
	bl	log2phys
	ldr	r3, [sp, #0]
	adds	r3, r3, #1
	beq	.L1650
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
.L1650:
	ldrh	r3, [r8, #0]
	adds	r5, r5, #1
	subs	r4, r4, r3
.L1649:
	ldrh	r3, [r8, #0]
	cmp	r4, r3
	bcs	.L1651
	ldr	r3, .L1655+8
	mov	r4, #0
	ldr	r2, [r3, #0]
	cmp	r2, #32
	bls	.L1654
	str	r4, [r3, #0]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1654
.L1652:
	mov	r0, #-1
	b	.L1647
.L1653:
	movs	r0, #0
	b	.L1647
.L1654:
	mov	r0, r4
.L1647:
	pop	{r2, r3, r4, r5, r6, r7, r8, pc}
.L1656:
	.align	2
.L1655:
	.word	.LANCHOR84
	.word	.LANCHOR71
	.word	.LANCHOR221
	.word	.LANCHOR157
	.size	ftl_discard, .-ftl_discard
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
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r3, pc}
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
	ldr	r3, .L1660
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L1659
	bl	FtlSysFlush
.L1659:
	movs	r0, #0
	pop	{r3, pc}
.L1661:
	.align	2
.L1660:
	.word	.LANCHOR222
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
	.section	.text.FtlMapTblRecovery,"ax",%progbits
	.align	1
	.global	FtlMapTblRecovery
	.thumb
	.thumb_func
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r4, r0
	ldr	r3, [r0, #12]
	movs	r1, #0
	ldrh	sl, [r0, #6]
	ldr	fp, [r0, #24]
	str	r3, [sp, #8]
	ldr	r3, [r0, #16]
	lsl	r2, sl, #2
	ldr	r6, .L1683
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	mov	r0, fp
	str	r3, [sp, #4]
	bl	memset
	ldr	r1, .L1683+4
	movs	r2, #0
	mov	r8, r2
	str	r2, [r4, #32]
	str	r2, [r4, #28]
	ldr	r3, [r1, #0]
	str	r3, [r6, #8]
	ldr	r3, .L1683+8
	ldr	r5, [r3, #0]
	movw	r3, #65535
	str	r5, [r6, #12]
	strh	r3, [r4, #0]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #1
	str	r3, [r4, #36]
	ldr	r3, [sp, #8]
	mov	r7, r3
	mov	r3, fp
	mov	fp, sl
	mov	sl, r4
	b	.L1664
.L1677:
	ldr	r0, [sp, #4]
	subs	r2, r0, #1
	cmp	r8, r2
	bne	.L1665
	sxth	r6, r1
	mov	r4, sl
	mov	sl, fp
	mov	fp, r3
	ldr	r3, [sp, #8]
	mov	r7, r1
	movs	r1, #1
	add	r3, r3, r6, lsl #1
	str	r3, [sp, #4]
	ldr	r3, [sp, #8]
	ldrh	r0, [r3, r6, lsl #1]
	bl	FtlGetLastWrittenPage
	ldr	r1, [sp, #12]
	strh	r7, [r4, #0]	@ movhi
	ldr	r7, .L1683
	uxth	r0, r0
	adds	r3, r0, #1
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, [r1, r6, lsl #2]
	sxth	r8, r0
	movs	r6, #0
	str	r3, [r4, #28]
	b	.L1666
.L1668:
	ldr	r2, [sp, #4]
	movs	r1, #1
	ldr	r0, .L1683
	ldrh	r3, [r2, #0]
	mov	r2, r1
	orr	r3, r6, r3, lsl #10
	str	r3, [r7, #4]
	bl	FlashReadPages
	ldr	r3, [r7, #0]
	adds	r3, r3, #1
	beq	.L1667
	ldrh	r3, [r5, #8]
	cmp	r3, sl
	bcs	.L1667
	ldrh	r2, [r4, #4]
	ldrh	r1, [r5, #0]
	cmp	r1, r2
	itt	eq
	ldreq	r2, [r7, #4]
	streq	r2, [fp, r3, lsl #2]
.L1667:
	adds	r6, r6, #1
.L1666:
	sxth	r3, r6
	cmp	r8, r3
	bge	.L1668
	b	.L1669
.L1665:
	ldr	r0, .L1683+4
	ldrh	r1, [r7], #2
	ldr	r2, [r0, #0]
	ldr	r0, .L1683+12
	str	r2, [r6, #8]
	ldrh	r2, [r0, #0]
	ldr	r0, .L1683
	subs	r2, r2, #1
	orr	r2, r2, r1, lsl #10
	movs	r1, #1
	str	r2, [r6, #4]
	mov	r2, r1
	str	r3, [sp, #0]
	bl	FlashReadPages
	ldr	r2, [r6, #0]
	ldr	r3, [sp, #0]
	adds	r2, r2, #1
	beq	.L1681
	ldrh	r1, [r5, #0]
	ldrh	r2, [sl, #4]
	cmp	r1, r2
	bne	.L1681
	ldrh	r2, [r5, #8]
	movw	r1, #64245
	cmp	r2, r1
	bne	.L1681
	ldr	r2, .L1683+12
	movs	r1, #0
	ldr	r0, .L1683+4
	mov	lr, r3
	ldrh	r4, [r2, #0]
	ldr	r2, [r0, #0]
	subs	r4, r4, #1
	b	.L1671
.L1673:
	ldrh	r0, [r2, #0]
	cmp	r0, fp
	itt	cc
	ldrcc	r3, [r2, #4]
	strcc	r3, [lr, r0, lsl #2]
	adds	r1, r1, #1
	adds	r2, r2, #8
.L1671:
	cmp	r1, r4
	blt	.L1673
	mov	r3, lr
	b	.L1674
.L1676:
	ldrh	r2, [r7, #-2]
	movs	r1, #1
	ldr	r0, .L1683
	orr	r2, r4, r2, lsl #10
	str	r2, [r6, #4]
	mov	r2, r1
	str	ip, [sp, #0]
	bl	FlashReadPages
	ldr	r2, [r6, #0]
	ldr	ip, [sp, #0]
	adds	r2, r2, #1
	beq	.L1675
	ldrh	r2, [r5, #8]
	cmp	r2, fp
	bcs	.L1675
	ldrh	r1, [sl, #4]
	ldrh	r0, [r5, #0]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r6, #4]
	streq	r1, [r8, r2, lsl #2]
.L1675:
	adds	r4, r4, #1
	b	.L1682
.L1681:
	mov	ip, r8
	movs	r4, #0
	mov	r8, r3
.L1682:
	ldr	r1, .L1683+12
	ldrh	r2, [r1, #0]
	cmp	r4, r2
	blt	.L1676
	mov	r3, r8
	mov	r8, ip
.L1674:
	add	r8, r8, #1
.L1664:
	ldr	r2, [sp, #4]
	uxth	r1, r8
	cmp	r8, r2
	blt	.L1677
	mov	r4, sl
.L1669:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L1683+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1678
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1678:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #16
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1684:
	.align	2
.L1683:
	.word	.LANCHOR197
	.word	.LANCHOR96
	.word	.LANCHOR180
	.word	.LANCHOR69
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
	ldr	r0, .L1686
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1687:
	.align	2
.L1686:
	.word	.LANCHOR120
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
	ldr	r3, .L1689
	ldr	r0, .L1689+4
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L1689+8
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L1689+12
	ldrh	r3, [r3, #0]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L1689+16
	ldr	r3, [r3, #0]
	str	r3, [r0, #12]
	ldr	r3, .L1689+20
	ldr	r3, [r3, #0]
	str	r3, [r0, #16]
	ldr	r3, .L1689+24
	ldr	r3, [r3, #0]
	str	r3, [r0, #20]
	ldr	r3, .L1689+28
	ldr	r3, [r3, #0]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1690:
	.align	2
.L1689:
	.word	.LANCHOR77
	.word	.LANCHOR213
	.word	.LANCHOR85
	.word	.LANCHOR78
	.word	.LANCHOR86
	.word	.LANCHOR185
	.word	.LANCHOR184
	.word	.LANCHOR186
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.FtlRecoverySuperblock,"ax",%progbits
	.align	1
	.global	FtlRecoverySuperblock
	.thumb
	.thumb_func
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0, #0]
	movw	r3, #65535
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	cmp	r2, r3
	sub	sp, sp, #72
	mov	r4, r0
	beq	.L1692
	ldrh	r5, [r0, #2]
	ldr	r2, .L1784
	str	r5, [sp, #24]
	ldrb	r5, [r0, #6]	@ zero_extendqisi2
	ldrh	r2, [r2, #0]
	str	r5, [sp, #36]
	ldr	r5, [sp, #24]
	cmp	r2, r5
	mov	r5, #0
	bne	.L1693
	mov	r3, r5	@ movhi
	strh	r5, [r0, #4]	@ movhi
	b	.L1781
.L1693:
	ldrh	r0, [r0, #16]
	b	.L1694
.L1695:
	adds	r5, r5, #1
	uxth	r5, r5
	add	r2, r5, #8
	ldrh	r0, [r4, r2, lsl #1]
.L1694:
	cmp	r0, r3
	beq	.L1695
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L1696
	bl	FtlGetLastWrittenPage
	adds	r3, r0, #1
	mov	r6, r0
	beq	.L1697
	ldr	r3, .L1784+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1776
	ldr	r3, .L1784+8
	ldrh	r7, [r3, r0, lsl #1]
	b	.L1766
.L1696:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r6, r0
	adds	r0, r0, #1
	beq	.L1697
.L1776:
	mov	r7, r6
.L1766:
	ldr	r3, .L1784+12
	movs	r5, #0
	str	r4, [sp, #48]
	mov	r2, r4
	ldrh	fp, [r3, #0]
	ldr	r3, .L1784+16
	ldr	sl, [r3, #0]
	ldr	r3, .L1784+20
	ldr	r8, [r3, #0]
	ldr	r3, .L1784+24
	ldrh	ip, [r3, #0]
	mov	r3, r5
	b	.L1699
.L1697:
	ldr	r3, [sp, #24]
	cbz	r3, .L1700
	ldr	r1, .L1784+28
	movw	r2, #1748
	ldr	r0, .L1784+32
	bl	printf
	ldr	r0, .L1784+36
	ldr	r1, .L1784+40
	bl	printf
.L1700:
	ldr	r3, [sp, #36]
	cbz	r3, .L1701
	cmp	r3, r5
	beq	.L1701
	ldr	r1, .L1784+28
	movw	r2, #1749
	ldr	r0, .L1784+32
	bl	printf
	ldr	r0, .L1784+36
	ldr	r1, .L1784+40
	bl	printf
.L1701:
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	b	.L1692
.L1703:
	ldrh	r0, [r2, #16]
	movw	lr, #65535
	cmp	r0, lr
	beq	.L1702
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
.L1702:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1699:
	cmp	r3, fp
	bne	.L1703
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1768
	ldr	r3, .L1784+4
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
	b	.L1777
.L1768:
	movs	r3, #0
.L1777:
	ldr	r8, .L1784+16
	mov	r1, r5
	str	r3, [sp, #32]
	mov	fp, r7
	ldr	r2, [sp, #32]
	ldr	r0, [r8, #0]
	bl	FlashReadPages
	ldr	r2, .L1784+44
	ldr	sl, [r8, #0]
	uxth	ip, r7
	movw	r8, #65535
	str	r8, [sp, #16]
	ldr	r3, [r2, #0]
	mov	r8, #0
	str	r3, [sp, #20]
	mov	r3, r6
	mov	r6, sl
	mov	sl, ip
	b	.L1705
.L1710:
	ldr	r1, [r6, #0]
	cbnz	r1, .L1706
	ldr	ip, [r6, #12]
	ldr	r7, [ip, #4]
	adds	r1, r7, #1
	beq	.L1707
	ldr	r1, [r2, #0]
	mov	r0, r7
	str	r2, [sp, #12]
	str	r3, [sp, #4]
	str	ip, [sp, #8]
	bl	ftl_cmp_data_ver
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	ldr	ip, [sp, #8]
	cbz	r0, .L1707
	adds	r7, r7, #1
	str	r7, [r2, #0]
.L1707:
	ldr	r1, [ip, #0]
	adds	r1, r1, #1
	bne	.L1708
	uxth	r6, r3
	ldr	r3, .L1784+16
	movs	r2, #36
	mov	r7, fp
	ldr	r3, [r3, #0]
	mla	r3, r2, r8, r3
	b	.L1778
.L1706:
	str	sl, [sp, #16]
.L1708:
	add	r8, r8, #1
	adds	r6, r6, #36
	uxth	r8, r8
.L1705:
	cmp	r8, r5
	bne	.L1710
	adds	r6, r3, #1
	ldr	r3, .L1784+16
	mov	r7, fp
	uxth	r6, r6
	ldr	r3, [r3, #0]
.L1778:
	ldr	r0, [r3, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	str	r0, [sp, #28]
	bne	.L1711
	ldr	r2, .L1784+4
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbnz	r2, .L1711
	ldr	r2, .L1784+8
	ldrh	r6, [r2, r6, lsl #1]
.L1711:
	ldr	r2, .L1784
	ldrh	r2, [r2, #0]
	cmp	r2, r6
	bne	.L1712
	movs	r2, #0
	strh	r6, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	strh	r2, [r4, #4]	@ movhi
.L1712:
	ldr	r5, [sp, #24]
	cmp	r6, r5
	bne	.L1713
	ldr	r8, [sp, #28]
	ldr	r5, [sp, #36]
	cmp	r8, r5
	bne	.L1713
	mov	r0, r4
	mov	r1, r6
	mov	r2, r8
	b	.L1782
.L1713:
	ldr	r2, [sp, #20]
	ldr	r8, [sp, #16]
	subs	r5, r2, #1
	movw	r2, #65535
	cmp	r8, r2
	bne	.L1714
	cmp	r3, #0
	bne	.L1715
.L1714:
	ldr	r2, .L1784+48
	uxth	r3, r7
	ldr	r0, [sp, #24]
	ldr	r1, [r2, #0]
	adds	r1, r1, #1
	it	eq
	streq	r5, [r2, #0]
	ldr	r2, [r2, #0]
	str	r2, [sp, #16]
	adds	r2, r0, #7
	cmp	r3, r2
	ble	.L1769
	subs	r7, r3, #7
	uxth	r7, r7
	b	.L1717
.L1769:
	ldr	r7, [sp, #24]
.L1717:
	mov	fp, #-1
	mov	r8, r3
	mov	sl, fp
	mov	r3, r6
	mov	r6, r5
	b	.L1718
.L1720:
	ldrh	r0, [r1, #16]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1719
	ldr	r3, [sp, #20]
	mov	lr, #36
	orr	r0, r7, r0, lsl #10
	mla	ip, lr, r5, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r0, [ip, #4]
.L1719:
	adds	r2, r2, #1
	adds	r1, r1, #2
	uxth	r2, r2
.L1731:
	ldr	r0, [sp, #44]
	cmp	r2, r0
	bne	.L1720
	ldr	ip, .L1784+16
	mov	r1, r5
	ldr	r3, [sp, #40]
	ldr	r2, [sp, #32]
	ldr	r0, [ip, #0]
	str	r3, [sp, #4]
	str	ip, [sp, #8]
	bl	FlashReadPages
	ldr	r2, .L1784+4
	movs	r0, #0
	ldr	ip, [sp, #8]
	ldr	r3, [sp, #4]
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	ldr	r1, [ip, #0]
	mov	ip, r3
	str	r5, [sp, #40]
	str	r2, [sp, #20]
	ldr	r2, .L1784+48
	ldr	r2, [r2, #0]
	b	.L1721
.L1785:
	.align	2
.L1784:
	.word	.LANCHOR68
	.word	.LANCHOR7
	.word	.LANCHOR8
	.word	.LANCHOR53
	.word	.LANCHOR173
	.word	.LANCHOR130
	.word	.LANCHOR74
	.word	.LANCHOR223
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR154
	.word	.LANCHOR138
.L1729:
	ldr	r3, [r1, #0]
	cbnz	r3, .L1722
	ldr	r3, [r1, #12]
	movw	r5, #65535
	ldrh	lr, [r3, #0]
	cmp	lr, r5
	beq	.L1771
	ldr	r3, [r3, #4]
	adds	r5, r3, #1
	beq	.L1771
	cmp	fp, #-1
	bne	.L1723
	ldr	r5, .L1786
	ldrh	lr, [r5, r7, lsl #1]
	movw	r5, #65535
	cmp	lr, r5
	bne	.L1724
	ldr	r5, [sp, #20]
	cbz	r5, .L1723
.L1724:
	cmp	r2, r6
	ite	ne
	movne	fp, r2
	moveq	fp, #-1
	b	.L1723
.L1722:
	ldr	r3, .L1786+4
	mov	r5, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r6, ip
	str	r2, [r3, #0]
	cmp	r1, #0
	bne	.L1715
	ldr	r1, .L1786
	ldrh	r0, [r1, r7, lsl #1]
	movw	r1, #65535
	cmp	r0, r1
	bne	.L1725
	cmp	fp, #-1
	beq	.L1726
	str	fp, [r3, #0]
	b	.L1715
.L1726:
	ldr	r0, [sp, #16]
	cmp	r0, r5
	beq	.L1783
	str	r0, [r3, #0]
	b	.L1715
.L1725:
	cmp	sl, r5
	beq	.L1728
	cmp	sl, #-1
	beq	.L1715
	str	sl, [r3, #0]
	b	.L1715
.L1728:
	cmp	r2, r5
	beq	.L1715
.L1783:
	subs	r2, r2, #1
	b	.L1779
.L1771:
	mov	r3, r2
	mov	r2, sl
.L1723:
	adds	r0, r0, #1
	mov	sl, r2
	adds	r1, r1, #36
	mov	r2, r3
	uxth	r0, r0
.L1721:
	ldr	r3, [sp, #40]
	cmp	r0, r3
	bne	.L1729
	adds	r7, r7, #1
	ldr	r1, .L1786+4
	mov	r3, ip
	uxth	r7, r7
	str	r2, [r1, #0]
.L1718:
	cmp	r7, r8
	bhi	.L1730
	ldr	r5, .L1786+8
	mov	r1, r4
	ldr	r2, .L1786+12
	str	r3, [sp, #40]
	ldrh	lr, [r5, #0]
	movs	r5, #0
	ldr	r2, [r2, #0]
	str	lr, [sp, #44]
	str	r2, [sp, #20]
	mov	r2, r5
	b	.L1731
.L1730:
	mov	r5, r6
	mov	r6, r3
	ldr	r3, .L1786+4
	mov	r2, #-1
.L1779:
	str	r2, [r3, #0]
.L1715:
	ldr	r3, .L1786+16
	movs	r2, #1
	ldr	r0, .L1786+20
	ldr	r7, .L1786+12
	strh	r2, [r3, #0]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	sl, [sp, #24]
	str	r6, [sp, #20]
.L1732:
	ldr	r3, .L1786+24
	movs	r6, #0
	ldr	r0, .L1786+8
	mov	r2, r4
	ldr	lr, [r7, #0]
	ldrb	fp, [r3, #0]	@ zero_extendqisi2
	mov	r3, r6
	ldrh	ip, [r0, #0]
	b	.L1733
.L1736:
	ldrh	r0, [r2, #16]
	movw	r1, #65535
	cmp	r0, r1
	beq	.L1734
	mov	r8, #36
	orr	r0, sl, r0, lsl #10
	mla	r1, r8, r6, lr
	str	r0, [r1, #4]
	ldrb	r8, [r4, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L1735
	cmp	fp, #0
	beq	.L1735
	orr	r0, r0, #-2147483648
	str	r0, [r1, #4]
.L1735:
	adds	r6, r6, #1
	uxth	r6, r6
.L1734:
	adds	r3, r3, #1
	adds	r2, r2, #2
	uxth	r3, r3
.L1733:
	cmp	r3, ip
	bne	.L1736
	ldr	r0, [r7, #0]
	mov	r1, r6
	ldr	r2, [sp, #32]
	mov	r8, #0
	bl	FlashReadPages
	movs	r3, #36
	str	sl, [sp, #40]
	muls	r3, r6, r3
	str	r3, [sp, #52]
	b	.L1737
.L1761:
	ldr	r3, [r7, #0]
	add	sl, r3, r8
	ldr	r6, [sl, #4]
	ubfx	r0, r6, #10, #16
	str	r6, [sp, #68]
	bl	P2V_plane
	ldr	ip, [sp, #40]
	ldr	r3, [sp, #24]
	cmp	ip, r3
	bcc	.L1738
	bne	.L1739
	ldr	r3, [sp, #36]
	cmp	r0, r3
	bcc	.L1738
.L1739:
	ldr	ip, [sp, #40]
	ldr	r3, [sp, #20]
	cmp	ip, r3
	bne	.L1740
	ldr	ip, [sp, #28]
	cmp	r0, ip
	beq	.L1775
.L1740:
	ldr	r3, [sl, #0]
	adds	r3, r3, #1
	beq	.L1742
	ldr	r6, [sl, #12]
	movw	lr, #61589
	ldrh	r3, [r6, #0]
	cmp	r3, lr
	bne	.L1749
.L1743:
	ldr	r5, [r6, #4]
	adds	r3, r5, #1
	beq	.L1744
	ldr	sl, .L1786+28
	mov	r0, r5
	ldr	r1, [sl, #0]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1744
	adds	r3, r5, #1
	str	r3, [sl, #0]
.L1744:
	ldr	sl, [r6, #8]
	add	r1, sp, #64
	ldr	r3, [r6, #12]
	movs	r2, #0
	mov	r0, sl
	str	r3, [sp, #60]
	bl	log2phys
	ldr	r0, .L1786+4
	ldr	r1, [r0, #0]
	adds	r0, r1, #1
	beq	.L1745
	mov	r0, r5
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1745
	ldr	r3, [sp, #60]
	adds	r1, r3, #1
	beq	.L1746
	ldr	r0, [r7, #0]
	movs	r2, #0
	add	r0, r0, r8
	ldr	r1, [r0, #12]
	str	r3, [r0, #4]
	str	r1, [sp, #16]
	movs	r1, #1
	bl	FlashReadPages
	ldr	r3, [sp, #16]
	ldr	r3, [r3, #4]
	str	r3, [sp, #44]
	ldr	r3, [r7, #0]
	add	fp, r3, r8
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L1747
	b	.L1748
.L1746:
	ldr	r3, [sp, #68]
	ldr	r2, [sp, #64]
	cmp	r2, r3
	bne	.L1749
	mov	r0, sl
	add	r1, sp, #60
	movs	r2, #1
	bl	log2phys
.L1749:
	ldrh	r0, [r4, #0]
	b	.L1780
.L1747:
	ldr	r3, [sp, #16]
	ldr	r6, [r3, #8]
	cmp	r6, sl
	bne	.L1748
	ldr	r1, .L1786+4
	ldr	r0, [r1, #0]
	ldr	r1, [sp, #44]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1748
	ldr	r3, [sp, #64]
	ldr	r2, [sp, #68]
	cmp	r3, r2
	beq	.L1753
.L1750:
	ldr	r2, [sp, #60]
	cmp	r3, r2
	beq	.L1748
	adds	r2, r3, #1
	beq	.L1751
	ldr	r2, [fp, #12]
	mov	r0, fp
	str	r3, [fp, #4]
	movs	r1, #1
	str	r2, [sp, #16]
	movs	r2, #0
	bl	FlashReadPages
	b	.L1752
.L1751:
	str	r3, [fp, #0]
.L1752:
	ldr	r3, [r7, #0]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	beq	.L1753
	ldr	r3, [sp, #16]
	ldr	r1, .L1786+4
	ldr	sl, [r3, #4]
	ldr	r0, [r1, #0]
	mov	r1, sl
	bl	ftl_cmp_data_ver
	cbz	r0, .L1753
	ldr	r0, [sp, #44]
	mov	r1, sl
	bl	ftl_cmp_data_ver
	cbz	r0, .L1748
.L1753:
	mov	r0, r6
	ldr	r1, [sp, #60]
	bl	FtlReUsePrevPpa
.L1748:
	ldrh	r0, [r4, #0]
	mov	r3, #-1
	str	r3, [sp, #60]
	bl	decrement_vpc_count
	b	.L1755
.L1787:
	.align	2
.L1786:
	.word	.LANCHOR9
	.word	.LANCHOR138
	.word	.LANCHOR53
	.word	.LANCHOR173
	.word	.LANCHOR224
	.word	.LANCHOR120
	.word	.LANCHOR7
	.word	.LANCHOR154
.L1745:
	ldr	r3, [sp, #68]
	ldr	r2, [sp, #64]
	cmp	r2, r3
	beq	.L1755
	movs	r2, #1
	mov	r0, sl
	add	r1, sp, #68
	bl	log2phys
	ldr	fp, [sp, #64]
	cmp	fp, #-1
	beq	.L1755
	ldr	r3, [sp, #60]
	cmp	fp, r3
	beq	.L1755
	ubfx	r0, fp, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1788
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L1756
	ldr	r3, .L1788+4
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	beq	.L1756
	ldr	r3, .L1788+8
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	bne	.L1755
.L1756:
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
	beq	.L1755
	mov	r0, r5
	bl	ftl_cmp_data_ver
	cbnz	r0, .L1755
	mov	r0, sl
	add	r1, sp, #64
	movs	r2, #1
	bl	log2phys
.L1755:
	ldr	r0, [sp, #60]
	adds	r3, r0, #1
	beq	.L1738
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1788+12
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	mov	r6, r0
	bhi	.L1757
	ldr	r1, .L1788+16
	movw	r2, #2027
	ldr	r0, .L1788+20
	bl	printf
	ldr	r0, .L1788+24
	ldr	r1, .L1788+28
	bl	printf
.L1757:
	ldr	r3, .L1788+32
	ldr	r3, [r3, #0]
	ldrh	r3, [r3, r6, lsl #1]
	cbz	r3, .L1758
	mov	r0, r6
.L1780:
	bl	decrement_vpc_count
	b	.L1738
.L1758:
	mov	r1, r6
	ldr	r0, .L1788+36
	bl	printf
	b	.L1738
.L1742:
	ldr	r2, .L1788+40
	ldr	r3, [r2, #0]
	cmp	r3, #31
	bhi	.L1759
	ldr	r0, .L1788+44
	str	r6, [r0, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2, #0]
.L1759:
	ldrh	r0, [r4, #0]
	bl	decrement_vpc_count
	ldr	r1, .L1788+48
	ldr	r3, [r1, #0]
	adds	r0, r3, #1
	bne	.L1760
	str	r5, [r1, #0]
	b	.L1738
.L1760:
	cmp	r3, r5
	itt	hi
	ldrhi	r2, .L1788+48
	strhi	r5, [r2, #0]
.L1738:
	add	r8, r8, #36
.L1737:
	ldr	r3, [sp, #52]
	cmp	r8, r3
	bne	.L1761
	ldr	sl, [sp, #40]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	add	sl, sl, #1
	cmp	r3, #1
	uxth	sl, sl
	bne	.L1762
	ldr	r3, .L1788+52
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1762
	ldr	r3, .L1788+56
	ldrh	r3, [r3, #0]
	cmp	r3, sl
	bne	.L1762
	ldr	r8, [sp, #20]
	cmp	r8, sl
	beq	.L1775
.L1762:
	ldr	r3, .L1788+60
	ldrh	r3, [r3, #0]
	cmp	sl, r3
	bne	.L1732
	ldr	r2, .L1788+64
	movs	r3, #0
	strh	sl, [r4, #2]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	ldrh	r1, [r2, #0]
	movw	r2, #65535
	ldr	r0, [sp, #48]
	b	.L1763
.L1765:
	adds	r0, r0, #2
	ldrh	r5, [r0, #14]
	cmp	r5, r2
	beq	.L1764
.L1781:
	strb	r3, [r4, #6]
	b	.L1692
.L1764:
	adds	r3, r3, #1
	uxth	r3, r3
.L1763:
	cmp	r3, r1
	bne	.L1765
	b	.L1692
.L1775:
.L1741:
	ldr	r6, [sp, #20]
	mov	r0, r4
	ldr	r3, [sp, #28]
	mov	r1, r6
	mov	r2, r3
	strh	r6, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
.L1782:
	bl	ftl_sb_update_avl_pages
.L1692:
	movs	r0, #0
	add	sp, sp, #72
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1789:
	.align	2
.L1788:
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR55
	.word	.LANCHOR223
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR99
	.word	.LC33
	.word	.LANCHOR225
	.word	.LANCHOR226
	.word	.LANCHOR138
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
	ldr	r3, .L1791
	ldr	r5, .L1791+4
	str	r4, [r3, #0]
	mov	r0, r5
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1791+8
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
.L1792:
	.align	2
.L1791:
	.word	.LANCHOR225
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L1803
	movs	r2, #0
	push	{r4, lr}
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L1803+4
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1803+8
	ldrh	r2, [r3, #0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1799
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L1800
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1803+12
	ldrh	r1, [r3, #0]
	ldr	r3, .L1803+16
	ldr	r2, [r3, #0]
	mov	r3, r4
	b	.L1795
.L1797:
	adds	r0, r2, r4
	adds	r4, r4, #12
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L1796
	adds	r3, r3, #1
.L1795:
	cmp	r3, r1
	blt	.L1797
	b	.L1802
.L1796:
	ldr	r0, .L1803+20
	bl	FtlSuperblockPowerLostFix
	ldr	r0, .L1803+24
	bl	FtlSuperblockPowerLostFix
	ldr	r0, .L1803+28
	bl	FtlMapBlkWriteDumpData
	ldr	r0, .L1803+32
	bl	FtlMapBlkWriteDumpData
	ldr	r3, .L1803+36
	ldrh	r2, [r3, #30]
	adds	r2, r2, #1
	strh	r2, [r3, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, pc}
.L1799:
	mov	r0, #-1
	pop	{r4, pc}
.L1800:
	mov	r0, #-1
	pop	{r4, pc}
.L1802:
	ldr	r3, .L1803
	ldrh	r0, [r3, #0]
	cmp	r0, #0
	bne	.L1796
	pop	{r4, pc}
.L1804:
	.align	2
.L1803:
	.word	.LANCHOR224
	.word	.LANCHOR54
	.word	.LANCHOR191
	.word	.LANCHOR83
	.word	.LANCHOR112
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR120
	.word	.LANCHOR213
	.word	.LANCHOR140
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.FtlInit,"ax",%progbits
	.align	1
	.global	FtlInit
	.thumb
	.thumb_func
	.type	FtlInit, %function
FtlInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r3, #-1
	ldr	r4, .L1807
	movs	r2, #0
	str	r3, [r4, #0]
	ldr	r3, .L1807+4
	str	r2, [r3, #0]
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1807+8
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbnz	r0, .L1806
	bl	FtlSysBlkInit
	cbnz	r0, .L1806
	movs	r3, #1
	str	r3, [r4, #0]
.L1806:
	movs	r0, #0
	pop	{r4, pc}
.L1808:
	.align	2
.L1807:
	.word	.LANCHOR222
	.word	.LANCHOR227
	.word	.LANCHOR54
	.size	FtlInit, .-FtlInit
	.section	.text.rk_ftl_garbage_collect,"ax",%progbits
	.align	1
	.global	rk_ftl_garbage_collect
	.thumb
	.thumb_func
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1871
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	sub	sp, sp, #32
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L1861
	ldr	r2, .L1871+4
	ldrh	r2, [r2, #0]
	cmp	r2, #47
	bls	.L1862
	ldr	r3, .L1871+8
	movw	r5, #65535
	ldrh	r4, [r3, #0]
	cmp	r4, r5
	beq	.L1811
	ldr	r1, .L1871+12
	ldrh	r2, [r1, #0]
	cmp	r2, r5
	itt	eq
	strheq	r4, [r1, #0]	@ movhi
	strheq	r2, [r3, #0]	@ movhi
.L1811:
	cmp	r0, #0
	bne	.L1863
	ldr	r3, .L1871+16
	ldrh	r3, [r3, #0]
	cmp	r3, #24
	bhi	.L1864
	ldr	r2, .L1871+20
	cmp	r3, #16
	ldrh	r4, [r2, #0]
	bls	.L1814
	lsrs	r4, r4, #5
	b	.L1813
.L1814:
	cmp	r3, #12
	bls	.L1815
	lsrs	r4, r4, #4
	b	.L1813
.L1815:
	cmp	r3, #8
	bls	.L1813
	lsrs	r4, r4, #2
	b	.L1813
.L1864:
	movs	r4, #1
.L1813:
	ldr	r2, .L1871+24
	ldrh	r1, [r2, #0]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1817
	ldr	r3, .L1871+28
	movw	r0, #65535
	ldrh	r3, [r3, #0]
	cmp	r3, r0
	bne	.L1818
	ldr	r0, .L1871+12
	ldrh	r0, [r0, #0]
	cmp	r0, r3
	bne	.L1818
	ldr	r3, .L1871+32
	ldrh	r0, [r3, #0]
	cbnz	r0, .L1819
	ldr	r3, .L1871+36
	movs	r1, #3
	ldr	r3, [r3, #0]
	muls	r1, r3, r1
	ldr	r3, .L1871+40
	ldr	r3, [r3, #0]
	cmp	r3, r1, lsr #2
	bcs	.L1820
.L1819:
	ldr	r3, .L1871+44
	movs	r2, #3
	ldrh	r3, [r3, #0]
	muls	r2, r3, r2
	ldr	r3, .L1871+24
	asrs	r2, r2, #2
	strh	r2, [r3, #0]	@ movhi
	b	.L1821
.L1820:
	movs	r3, #18
	strh	r3, [r2, #0]	@ movhi
.L1821:
	ldr	r3, .L1871+48
	movs	r2, #0
	str	r2, [r3, #0]
	b	.L1810
.L1818:
	ldr	r3, .L1871+44
	movs	r2, #3
	ldrh	r3, [r3, #0]
	muls	r3, r2, r3
	asrs	r3, r3, #2
	strh	r3, [r1, #0]	@ movhi
.L1817:
	ldr	r3, .L1871+52
	ldrh	r3, [r3, #0]
	cbz	r3, .L1812
	adds	r4, r4, #32
	uxth	r4, r4
	b	.L1812
.L1863:
	movs	r4, #1
.L1812:
	ldr	r3, .L1871+56
	ldrh	r2, [r3, #0]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1823
	ldr	r3, .L1871+12
	ldrh	r1, [r3, #0]
	cmp	r1, r2
	beq	.L1824
	ldr	r0, .L1871+60
	ldr	r0, [r0, #0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L1825
	strh	r2, [r3, #0]	@ movhi
.L1825:
	ldrh	r1, [r3, #0]
	ldr	r2, .L1871+56
	strh	r1, [r2, #0]	@ movhi
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
.L1824:
	ldr	r5, .L1871+56
	movw	r6, #65535
	movs	r3, #0
	ldrh	r0, [r5, #0]
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L1823
	bl	IsBlkInGcList
	cbz	r0, .L1826
	strh	r6, [r5, #0]	@ movhi
.L1826:
	ldr	r3, .L1871+64
	ldr	r6, .L1871+56
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L1827
	ldrh	r0, [r6, #0]
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L1827:
	ldrh	r2, [r6, #0]
	movw	r3, #65535
	ldr	r5, .L1871+56
	cmp	r2, r3
	beq	.L1823
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L1871+68
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2, #0]	@ movhi
	ldr	r3, .L1871+60
	ldrh	r2, [r5, #0]
	ldr	r3, [r3, #0]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1871+72
	strh	r2, [r3, #0]	@ movhi
.L1823:
	ldr	r2, .L1871+56
	ldr	r1, .L1871+76
	ldrh	r3, [r2, #0]
	ldrh	r1, [r1, #0]
	cmp	r1, r3
	beq	.L1828
	ldr	r1, .L1871+80
	ldrh	r1, [r1, #0]
	cmp	r1, r3
	bne	.L1865
.L1829:
.L1828:
	movw	r3, #65535
	strh	r3, [r2, #0]	@ movhi
	b	.L1870
.L1865:
	ldr	r6, .L1871+84
	ldr	r7, .L1871+88
.L1867:
	ldr	r3, .L1871+56
	movw	r2, #65535
	ldrh	r8, [r3, #0]
	cmp	r8, r2
	bne	.L1831
	ldr	r2, .L1871+48
	mov	sl, r3
	ldr	fp, .L1871+60
	movs	r1, #0
	str	r1, [r2, #0]
.L1866:
	ldrh	r1, [r6, #0]
	mov	r0, r1
	str	r1, [sp, #8]
	bl	List_get_gc_head_node
	uxth	r5, r0
	strh	r5, [sl, #0]	@ movhi
	cmp	r5, r8
	bne	.L1833
	ldr	r3, .L1871+84
	movs	r2, #0
	movs	r0, #8
	strh	r2, [r3, #0]	@ movhi
	b	.L1810
.L1833:
	mov	r0, r5
	bl	IsBlkInGcList
	ldr	r2, [sp, #8]
	adds	r3, r2, #1
	cbnz	r0, .L1868
.L1834:
	ldr	r1, .L1871+20
	uxth	r0, r3
	ldr	r3, [fp, #0]
	strh	r0, [r6, #0]	@ movhi
	ldrh	ip, [r1, #0]
	ldr	r1, .L1871+92
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r1, [r1, #0]
	mul	r1, r1, ip
	cmp	r2, r1, asr #1
	bgt	.L1836
	cmp	r0, #48
	bls	.L1837
	cmp	r2, #8
	bls	.L1837
	ldr	r2, .L1871+96
	ldrh	r2, [r2, #0]
	cmp	r2, #35
	bhi	.L1837
.L1836:
	movs	r2, #0
	strh	r2, [r6, #0]	@ movhi
.L1837:
	ldrh	r2, [r3, r5, lsl #1]
	ldr	r3, .L1871+56
	cmp	r2, r1
	blt	.L1838
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
	ldr	r3, .L1871+84
	movs	r2, #0
	strh	r2, [r3, #0]	@ movhi
	b	.L1870
.L1838:
	cbnz	r2, .L1839
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r6, #0]
	adds	r3, r3, #1
.L1868:
	strh	r3, [r6, #0]	@ movhi
	b	.L1866
.L1872:
	.align	2
.L1871:
	.word	.LANCHOR165
	.word	.LANCHOR101
	.word	.LANCHOR147
	.word	.LANCHOR146
	.word	.LANCHOR104
	.word	.LANCHOR68
	.word	.LANCHOR170
	.word	.LANCHOR109
	.word	.LANCHOR228
	.word	.LANCHOR87
	.word	.LANCHOR116
	.word	.LANCHOR200
	.word	.LANCHOR166
	.word	.LANCHOR148
	.word	.LANCHOR201
	.word	.LANCHOR99
	.word	.LANCHOR7
	.word	.LANCHOR229
	.word	.LANCHOR230
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR172
	.word	.LANCHOR132
	.word	.LANCHOR53
	.word	.LANCHOR142
.L1839:
	movs	r2, #0
	strb	r2, [r3, #8]
	ldr	r2, .L1873
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbz	r2, .L1840
	mov	r0, r5
	str	r3, [sp, #4]
	bl	ftl_get_blk_mode
	ldr	r3, [sp, #4]
	strb	r0, [r3, #8]
.L1840:
	ldr	r5, .L1873+4
	ldr	r3, .L1873+8
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1841
	ldr	r1, .L1873+12
	mov	r2, #772
	ldr	r0, .L1873+16
	bl	printf
	ldr	r0, .L1873+20
	ldr	r1, .L1873+24
	bl	printf
.L1841:
	ldr	r3, .L1873+28
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1842
	ldr	r1, .L1873+12
	movw	r2, #773
	ldr	r0, .L1873+16
	bl	printf
	ldr	r0, .L1873+20
	ldr	r1, .L1873+24
	bl	printf
.L1842:
	ldr	r5, .L1873+4
	ldr	r3, .L1873+32
	ldrh	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1843
	ldr	r1, .L1873+12
	movw	r2, #774
	ldr	r0, .L1873+16
	bl	printf
	ldr	r0, .L1873+20
	ldr	r1, .L1873+24
	bl	printf
.L1843:
	ldr	r0, .L1873+4
	bl	make_superblock
	ldr	r1, .L1873+36
	movs	r3, #0
	ldrh	r0, [r5, #0]
	strh	r3, [r1, #0]	@ movhi
	ldr	r1, .L1873+40
	ldr	r1, [r1, #0]
	ldrh	r0, [r1, r0, lsl #1]
	ldr	r1, .L1873+44
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r0, [r1, #0]	@ movhi
.L1831:
	ldr	r3, .L1873+48
	movs	r2, #1
	str	r2, [r3, #0]
	ldr	r3, .L1873+52
	ldrh	r3, [r3, #0]
	str	r3, [sp, #8]
	ldr	r3, .L1873
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	ldr	r3, .L1873+4
	cbz	r2, .L1844
	ldrb	r2, [r3, #8]	@ zero_extendqisi2
	cmp	r2, #1
	bne	.L1844
	ldr	r2, .L1873+56
	ldrh	r2, [r2, #0]
	str	r2, [sp, #8]
.L1844:
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
	b	.L1846
.L1848:
	ldrh	r1, [r2, #2]!
	movw	r8, #65535
	cmp	r1, r8
	beq	.L1847
	mla	r8, r0, r5, lr
	adds	r5, r5, #1
	orr	r1, r4, r1, lsl #10
	uxth	r5, r5
	str	r1, [r8, #4]
.L1847:
	adds	r3, r3, #1
	uxth	r3, r3
.L1855:
	cmp	r3, ip
	bne	.L1848
	ldr	r3, .L1873+4
	mov	r1, r5
	ldr	r0, [r7, #0]
	movs	r4, #0
	mov	sl, r5
	ldrb	r2, [r3, #8]	@ zero_extendqisi2
	bl	FlashReadPages
	str	r4, [sp, #16]
	b	.L1849
.L1853:
	ldr	r3, [r7, #0]
	adds	r2, r3, r4
	ldr	r3, [r3, r4]
	ldr	r5, [r2, #12]
	adds	r3, r3, #1
	beq	.L1850
	ldrh	r3, [r5, #0]
	movw	r8, #61589
	cmp	r3, r8
	bne	.L1850
	ldr	r8, [r5, #8]
	cmp	r8, #-1
	bne	.L1851
	ldr	r1, .L1873+12
	mov	r2, #812
	ldr	r0, .L1873+16
	bl	printf
	ldr	r0, .L1873+20
	ldr	r1, .L1873+24
	bl	printf
.L1851:
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
	bne	.L1850
	ldr	r0, .L1873+36
	mov	fp, #36
	ldr	r8, .L1873+72
	ldr	r2, [r2, #16]
	ldrh	r3, [r0, #0]
	ldr	r1, [r8, #0]
	adds	r3, r3, #1
	strh	r3, [r0, #0]	@ movhi
	ldr	r0, .L1873+60
	ldr	r3, [r0, #0]
	mla	r3, fp, r1, r3
	str	r2, [r3, #16]
	str	r3, [sp, #4]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #4]
	ldr	r1, .L1873+60
	ldr	r2, [r1, #0]
	str	r0, [r3, #4]
	ldr	r3, [r8, #0]
	ldr	r0, [r7, #0]
	mla	r2, fp, r3, r2
	adds	r0, r0, r4
	ldr	fp, .L1873+32
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
	ldr	r2, .L1873+64
	str	r3, [r8, #0]
	ldr	r2, [r2, #0]
	str	r2, [r5, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L1873
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbnz	r3, .L1852
	ldrb	r3, [fp, #7]	@ zero_extendqisi2
	ldr	r2, [r8, #0]
	cmp	r2, r3
	beq	.L1852
	ldrh	r3, [fp, #4]
	cbnz	r3, .L1850
.L1852:
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L1869
.L1850:
	ldr	r8, [sp, #16]
	adds	r4, r4, #36
	add	r3, r8, #1
	uxth	r3, r3
	str	r3, [sp, #16]
.L1849:
	ldr	r3, [sp, #16]
	cmp	r3, sl
	bne	.L1853
	ldr	r8, [sp, #12]
	add	r8, r8, #1
	str	r8, [sp, #12]
.L1846:
	ldr	r8, [sp, #12]
	ldr	r2, .L1873+4
	uxth	r3, r8
	ldr	r8, [sp, #20]
	cmp	r3, r8
	bcs	.L1854
	ldr	r3, .L1873+68
	movs	r5, #0
	ldrh	r4, [r2, #2]
	movs	r0, #36
	ldr	lr, [r7, #0]
	adds	r2, r2, #14
	ldrh	ip, [r3, #0]
	ldr	r3, [sp, #12]
	adds	r4, r4, r3
	mov	r3, r5
	b	.L1855
.L1854:
	ldrh	r3, [r2, #2]
	ldr	r4, [sp, #20]
	ldr	r8, [sp, #8]
	adds	r4, r4, r3
	uxth	r4, r4
	strh	r4, [r2, #2]	@ movhi
	cmp	r4, r8
	bcs	.L1856
	ldr	r3, .L1873+36
	ldrh	r2, [r3, #0]
	ldr	r3, .L1873+44
	ldrh	r3, [r3, #0]
	cmp	r2, r3
	bne	.L1857
.L1856:
	ldr	r3, .L1873+72
	ldr	r3, [r3, #0]
	cbz	r3, .L1858
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1858
.L1869:
	ldr	r3, .L1873+48
	movs	r2, #0
	str	r2, [r3, #0]
.L1870:
	ldr	r3, .L1873+76
	ldrh	r0, [r3, #0]
	b	.L1810
.L1874:
	.align	2
.L1873:
	.word	.LANCHOR7
	.word	.LANCHOR201
	.word	.LANCHOR107
	.word	.LANCHOR231
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR229
	.word	.LANCHOR99
	.word	.LANCHOR230
	.word	.LANCHOR165
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR174
	.word	.LANCHOR154
	.word	.LANCHOR53
	.word	.LANCHOR128
	.word	.LANCHOR228
.L1858:
	ldr	r3, .L1875
	ldrh	r0, [r3, #0]
	cbnz	r0, .L1859
	ldr	r3, .L1875+4
	ldr	r2, .L1875+8
	ldrh	r1, [r3, #0]
	ldr	r2, [r2, #0]
	ldrh	r4, [r2, r1, lsl #1]
	cbz	r4, .L1859
	strh	r0, [r2, r1, lsl #1]	@ movhi
	ldrh	r0, [r3, #0]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1859:
	ldr	r3, .L1875+4
	movw	r2, #65535
	strh	r2, [r3, #0]	@ movhi
.L1857:
	ldr	r3, .L1875+12
	ldrh	r0, [r3, #0]
	cmp	r0, #2
	bhi	.L1860
	ldr	r3, .L1875+16
	ldrh	r4, [r3, #0]
	b	.L1867
.L1860:
	ldr	r3, .L1875+20
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3, #0]
	b	.L1810
.L1861:
	movs	r0, #0
	b	.L1810
.L1862:
	mov	r0, r3
.L1810:
	add	sp, sp, #32
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1876:
	.align	2
.L1875:
	.word	.LANCHOR229
	.word	.LANCHOR201
	.word	.LANCHOR99
	.word	.LANCHOR104
	.word	.LANCHOR68
	.word	.LANCHOR165
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
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
	bne	.L1878
	add	r0, r1, #256
	mov	r1, r2
	mov	r2, r3
	bl	FtlVendorPartWrite
	b	.L1879
.L1878:
	ldr	r3, .L1920
	ldr	r0, [sp, #12]
	ldr	r3, [r3, #0]
	adds	r7, r0, r1
	cmp	r7, r3
	bhi	.L1910
	ldr	r3, .L1920+4
	ldr	r0, [r3, #0]
	adds	r1, r0, #1
	beq	.L1879
	ldr	r3, .L1920+8
	mov	r2, #2048
	mov	r0, r5
	str	r2, [r3, #0]
	ldr	r3, .L1920+12
	ldrh	r6, [r3, #0]
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mov	sl, r0
	subs	r0, r7, #1
	bl	__aeabi_uidiv
	ldr	r3, .L1920+16
	ldr	r2, [r3, #0]
	rsb	r4, sl, r0
	str	r0, [sp, #24]
	adds	r1, r4, #1
	str	r1, [sp, #0]
	adds	r2, r1, r2
	str	r2, [r3, #0]
	ldr	r3, .L1920+20
	ldr	r7, [r3, #0]
	cbz	r7, .L1880
	ldr	r3, [r7, #16]
	cmp	sl, r3
	beq	.L1881
	bl	FtlCacheWriteBack
	b	.L1880
.L1881:
	ldr	r3, .L1920+24
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
	beq	.L1912
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
.L1880:
	mov	r4, sl
	str	sl, [sp, #20]
	ldr	r6, .L1920+28
	mov	sl, r5
	b	.L1882
.L1909:
	ldr	r1, .L1920+32
	ldrb	r2, [r6, #6]	@ zero_extendqisi2
	ldrh	r3, [r1, #0]
	cmp	r2, r3
	bcc	.L1883
	ldr	r1, .L1920+36
	mov	r2, #1544
	ldr	r0, .L1920+40
	bl	printf
	ldr	r0, .L1920+44
	ldr	r1, .L1920+48
	bl	printf
.L1883:
	ldr	r2, .L1920+28
	ldrh	r3, [r2, #4]
	cbnz	r3, .L1884
	bl	FtlCacheWriteBack
	ldr	r0, .L1920+28
	bl	allocate_new_data_superblock
.L1884:
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6, #4]
	ldr	r1, .L1920+32
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
	bcc	.L1885
	ldr	r1, .L1920+36
	movw	r2, #1577
	ldr	r0, .L1920+40
	bl	printf
	ldr	r0, .L1920+44
	ldr	r1, .L1920+48
	bl	printf
.L1885:
	movs	r3, #0
	ldr	r5, .L1920+52
	str	r3, [sp, #16]
	b	.L1886
.L1905:
	ldrh	r3, [r6, #4]
	cmp	r3, #0
	beq	.L1913
	movs	r2, #0
	add	r1, sp, #76
	mov	r0, r4
	movs	r7, #36
	bl	log2phys
	ldr	r0, .L1920+28
	bl	get_new_active_ppa
	ldr	r3, [sp, #16]
	muls	r7, r3, r7
	ldr	r3, [r5, #0]
	adds	r3, r3, r7
	str	r4, [r3, #16]
	str	r0, [r3, #4]
	ldr	r0, .L1920+56
	ldrh	r2, [r0, #0]
	ldr	r0, [sp, #16]
	mul	r1, r2, r0
	lsrs	r1, r1, #2
	str	r1, [sp, #32]
	ldr	r1, .L1920+60
	ldr	r0, [sp, #32]
	ldr	r1, [r1, #0]
	add	r8, r1, r0, lsl #2
	str	r8, [r3, #12]
	str	r1, [sp, #36]
	mov	r0, r8
	movs	r1, #0
	bl	memset
	ldr	r1, [sp, #20]
	ldr	r3, .L1920+12
	cmp	r4, r1
	beq	.L1888
	ldr	r2, [sp, #24]
	cmp	r4, r2
	bne	.L1915
	b	.L1919
.L1888:
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
	b	.L1891
.L1919:
	ldr	r0, [sp, #12]
	ldrh	fp, [r3, #0]
	movs	r3, #0
	add	r2, sl, r0
	str	r3, [sp, #28]
	mls	fp, r4, fp, r2
	uxth	fp, fp
.L1891:
	ldr	r3, .L1920+12
	ldrh	r3, [r3, #0]
	cmp	fp, r3
	bne	.L1892
	ldr	r0, [sp, #20]
	ldr	r3, [r5, #0]
	cmp	r4, r0
	add	r7, r3, r7
	bne	.L1893
	ldr	r1, [sp, #4]
	str	r1, [r7, #8]
	b	.L1894
.L1893:
	mul	r3, fp, r4
	ldr	r2, [sp, #4]
	rsb	r3, sl, r3
	add	r3, r2, r3, lsl #9
	b	.L1918
.L1892:
	ldr	r3, [sp, #20]
	cmp	r4, r3
	ldr	r3, [r5, #0]
	it	eq
	ldreq	r2, .L1920+64
	add	r3, r3, r7
	it	ne
	ldrne	r2, .L1920+68
	ldr	r2, [r2, #0]
	str	r2, [r3, #8]
	ldr	r3, [sp, #76]
	adds	r2, r3, #1
	beq	.L1897
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
	bne	.L1898
	ldr	r3, .L1920+72
	ldr	r2, [r3, #72]
	adds	r2, r2, #1
	str	r2, [r3, #72]
	b	.L1899
.L1898:
	ldr	r1, [r8, #8]
	cmp	r1, r4
	beq	.L1900
	ldr	r3, .L1920+72
	ldr	r0, .L1920+76
	ldr	r2, [r3, #72]
	adds	r2, r2, #1
	str	r2, [r3, #72]
	mov	r2, r4
	bl	printf
.L1900:
	ldr	r3, [r8, #8]
	cmp	r3, r4
	beq	.L1899
	ldr	r1, .L1920+36
	movw	r2, #1630
	ldr	r0, .L1920+40
	bl	printf
	ldr	r1, .L1920+48
	ldr	r0, .L1920+44
	bl	printf
	b	.L1899
.L1897:
	ldr	r3, [r5, #0]
	movs	r1, #0
	adds	r3, r3, r7
	ldr	r0, [r3, #8]
	ldr	r3, .L1920+80
	ldrh	r2, [r3, #0]
	bl	memset
.L1899:
	ldr	r0, [sp, #20]
	ldr	r3, [r5, #0]
	cmp	r4, r0
	add	r3, r3, r7
	bne	.L1901
	ldr	r0, [r3, #8]
	ldr	r3, [sp, #28]
	ldr	r1, [sp, #4]
	add	r0, r0, r3, lsl #9
	b	.L1917
.L1921:
	.align	2
.L1920:
	.word	.LANCHOR84
	.word	.LANCHOR222
	.word	.LANCHOR232
	.word	.LANCHOR71
	.word	.LANCHOR156
	.word	.LANCHOR134
	.word	.LANCHOR158
	.word	.LANCHOR107
	.word	.LANCHOR53
	.word	.LANCHOR233
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR175
	.word	.LANCHOR74
	.word	.LANCHOR181
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR141
	.word	.LC34
	.word	.LANCHOR73
.L1901:
	ldr	r2, .L1922
	ldr	r0, [r3, #8]
	ldrh	r1, [r2, #0]
	muls	r1, r4, r1
	ldr	r2, [sp, #4]
	rsb	r1, sl, r1
	add	r1, r2, r1, lsl #9
.L1917:
	lsl	r2, fp, #9
	bl	memcpy
	ldr	r3, [sp, #24]
	cmp	r4, r3
	bne	.L1894
	ldrh	r3, [r6, #4]
	cbz	r3, .L1894
	ldr	r3, [r5, #0]
	adds	r7, r3, r7
	ldr	r3, .L1922+4
	str	r7, [r3, #0]
	ldr	r3, .L1922+8
	str	r6, [r3, #0]
	b	.L1894
.L1915:
	ldr	r2, [r5, #0]
	ldrh	r3, [r3, #0]
	muls	r3, r4, r3
	ldr	r0, [sp, #4]
	rsb	r3, sl, r3
	adds	r7, r2, r7
	add	r3, r0, r3, lsl #9
.L1918:
	str	r3, [r7, #8]
.L1894:
	ldr	r1, .L1922+12
	ldrb	r2, [r6, #6]	@ zero_extendqisi2
	ldrh	r3, [r1, #0]
	cmp	r2, r3
	bcc	.L1903
	ldr	r1, .L1922+16
	movw	r2, #1651
	ldr	r0, .L1922+20
	bl	printf
	ldr	r0, .L1922+24
	ldr	r1, .L1922+28
	bl	printf
.L1903:
	ldr	r2, [sp, #36]
	movw	r3, #61589
	ldr	r0, [sp, #32]
	strh	r3, [r2, r0, lsl #2]	@ movhi
	ldr	r3, .L1922+32
	ldr	r2, [r3, #0]
	str	r2, [r8, #4]
	adds	r2, r2, #1
	str	r2, [r3, #0]
	adds	r2, r2, #1
	bne	.L1904
	movs	r2, #0
	str	r2, [r3, #0]
.L1904:
	ldr	r3, [sp, #76]
	str	r4, [r8, #8]
	adds	r4, r4, #1
	str	r3, [r8, #12]
	ldrh	r3, [r6, #0]
	strh	r3, [r8, #2]	@ movhi
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	str	r3, [sp, #16]
.L1886:
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #8]
	cmp	r3, r0
	bne	.L1905
	b	.L1887
.L1913:
	ldr	r3, [sp, #16]
	str	r3, [sp, #8]
.L1887:
	ldr	r3, .L1922+4
	ldr	r3, [r3, #0]
	cbz	r3, .L1906
	ldr	r0, [sp, #8]
	subs	r0, r0, #1
	str	r0, [sp, #8]
	beq	.L1907
	ldr	r1, [sp, #0]
	subs	r1, r1, #1
	str	r1, [sp, #0]
.L1906:
	ldr	r3, .L1922+36
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r3, #0]
	ldr	r3, .L1922+40
	bl	FtlProgPages
	ldr	r2, [sp, #0]
	ldr	r3, [sp, #8]
	cmp	r2, r3
	bcs	.L1908
	ldr	r1, .L1922+16
	movw	r2, #1666
	ldr	r0, .L1922+20
	bl	printf
	ldr	r0, .L1922+24
	ldr	r1, .L1922+28
	bl	printf
.L1908:
	ldr	r0, [sp, #0]
	ldr	r1, [sp, #8]
	subs	r0, r0, r1
	str	r0, [sp, #0]
.L1882:
	ldr	r2, [sp, #0]
	cmp	r2, #0
	bne	.L1909
.L1907:
	ldr	sl, [sp, #20]
	movs	r0, #0
	ldr	r3, [sp, #24]
	rsb	r1, sl, r3
	bl	rk_ftl_garbage_collect
	movs	r0, #0
	b	.L1879
.L1910:
	mov	r0, #-1
	b	.L1879
.L1912:
	mov	r0, r4
.L1879:
	add	sp, sp, #80
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1923:
	.align	2
.L1922:
	.word	.LANCHOR71
	.word	.LANCHOR134
	.word	.LANCHOR219
	.word	.LANCHOR53
	.word	.LANCHOR233
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LANCHOR154
	.word	.LANCHOR175
	.word	.LANCHOR107
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
	bne	.L1925
	add	r0, r1, #256
	mov	r1, r2
	mov	r2, r3
	bl	FtlVendorPartRead
	str	r0, [sp, #12]
	b	.L1926
.L1925:
	ldr	r3, [sp, #36]
	adds	r3, r3, r1
	str	r3, [sp, #16]
	ldr	r3, .L1958
	ldr	r1, [sp, #16]
	ldr	r3, [r3, #0]
	cmp	r1, r3
	bhi	.L1946
	ldr	r3, .L1958+4
	ldr	r3, [r3, #0]
	adds	r2, r3, #1
	beq	.L1947
	ldr	fp, .L1958+48
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
	ldr	r3, .L1958+8
	ldr	r1, [sp, #8]
	str	r0, [sp, #24]
	ldr	r2, [r3, #0]
	adds	r2, r1, r2
	str	r2, [r3, #0]
	b	.L1953
.L1945:
	movs	r2, #0
	mov	r0, r6
	add	r1, sp, #68
	bl	log2phys
	ldr	r3, [sp, #68]
	adds	r4, r3, #1
	bne	.L1954
	b	.L1957
.L1931:
	mla	r0, r0, r6, r4
	cmp	r0, r8
	bcc	.L1930
	ldr	r3, [sp, #16]
	cmp	r0, r3
	bcs	.L1930
	rsb	r0, r8, r0
	movs	r1, #0
	mov	r2, #512
	add	r0, r7, r0, lsl #9
	bl	memset
.L1930:
	adds	r4, r4, #1
	b	.L1928
.L1957:
	movs	r4, #0
.L1928:
	ldrh	r0, [fp, #0]
	cmp	r4, r0
	bcc	.L1931
	b	.L1932
.L1954:
	ldr	r2, .L1958+12
	movs	r4, #36
	ldr	r2, [r2, #0]
	mla	r4, r4, r5, r2
	str	r3, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r6, r3
	bne	.L1933
	ldr	r3, .L1958+16
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
	bne	.L1934
	str	r7, [r4, #8]
	b	.L1934
.L1933:
	ldr	r3, [sp, #24]
	cmp	r6, r3
	bne	.L1935
	ldr	r3, .L1958+20
	ldrh	r2, [fp, #0]
	ldr	r1, [sp, #16]
	ldr	r3, [r3, #0]
	str	r3, [r4, #8]
	mul	r3, r2, r6
	rsb	sl, r3, r1
	cmp	sl, r2
	bne	.L1934
	b	.L1955
.L1935:
	ldrh	r3, [fp, #0]
	muls	r3, r6, r3
.L1955:
	rsb	r3, r8, r3
	add	r3, r7, r3, lsl #9
	str	r3, [r4, #8]
.L1934:
	ldr	r3, .L1958+24
	ldr	r2, .L1958+28
	str	r6, [r4, #16]
	ldrh	r3, [r3, #0]
	muls	r3, r5, r3
	ldr	r2, [r2, #0]
	adds	r5, r5, #1
	bic	r3, r3, #3
	adds	r3, r2, r3
	str	r3, [r4, #12]
.L1932:
	ldr	r3, [sp, #8]
	adds	r6, r6, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1936
	ldr	r3, .L1958+32
	ldrh	r3, [r3, #0]
	cmp	r5, r3, lsl #2
	bne	.L1953
.L1936:
	cmp	r5, #0
	beq	.L1953
	ldr	r4, .L1958+12
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
.L1944:
	movs	r6, #36
	ldr	r3, [sp, #28]
	muls	r6, r3, r6
	ldr	r3, [r4, #0]
	ldr	r1, [sp, #20]
	adds	r3, r3, r6
	ldr	r2, [r3, #16]
	cmp	r2, r1
	bne	.L1938
	ldr	r1, [r3, #8]
	ldr	r3, .L1958+16
	ldr	r3, [r3, #0]
	cmp	r1, r3
	bne	.L1939
	ldr	r3, [sp, #44]
	mov	r0, r7
	ldr	r2, [sp, #48]
	adds	r1, r1, r3
	b	.L1956
.L1938:
	ldr	r1, [sp, #24]
	cmp	r2, r1
	bne	.L1939
	ldr	r2, .L1958+20
	ldr	r1, [r3, #8]
	ldr	r3, [r2, #0]
	cmp	r1, r3
	bne	.L1939
	ldrh	r0, [fp, #0]
	ldr	r3, [sp, #24]
	muls	r0, r3, r0
	rsb	r0, r8, r0
	ldr	r2, [sp, #52]
	add	r0, r7, r0, lsl #9
.L1956:
	bl	memcpy
.L1939:
	ldr	r3, [r4, #0]
	adds	r2, r3, r6
	ldr	r3, [r3, r6]
	adds	r0, r3, #1
	bne	.L1940
	ldr	r2, .L1958+36
	str	r3, [sp, #12]
	ldr	r1, [r2, #72]
	adds	r1, r1, #1
	str	r1, [r2, #72]
	b	.L1941
.L1940:
	cmp	r3, #256
	bne	.L1941
	ldr	r0, [r2, #4]
	movw	r6, #2049
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	str	r0, [sp, #56]
	bl	FtlGcRefreshBlock
.L1943:
	subs	r6, r6, #1
	beq	.L1942
	movs	r0, #1
	mov	r1, r0
	bl	rk_ftl_garbage_collect
	ldr	r1, .L1958+40
	ldr	r2, [sp, #56]
	ldrh	r3, [r1, #0]
	cmp	r3, r2
	beq	.L1943
.L1942:
	bl	FtlSysFlush
.L1941:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	cmp	r3, r5
	bne	.L1944
	ldr	r6, [sp, #60]
	movs	r5, #0
.L1953:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1945
	ldr	r3, .L1958+44
	ldrh	r3, [r3, #0]
	cbz	r3, .L1926
	ldr	r0, [sp, #8]
	movs	r1, #1
	bl	rk_ftl_garbage_collect
	b	.L1926
.L1946:
	mov	r3, #-1
.L1947:
	str	r3, [sp, #12]
.L1926:
	ldr	r0, [sp, #12]
	add	sp, sp, #72
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1959:
	.align	2
.L1958:
	.word	.LANCHOR84
	.word	.LANCHOR222
	.word	.LANCHOR160
	.word	.LANCHOR173
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR74
	.word	.LANCHOR181
	.word	.LANCHOR53
	.word	.LANCHOR141
	.word	.LANCHOR201
	.word	.LANCHOR148
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
	ldr	r2, .L1969
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	mov	r6, r1
	ldrh	sl, [r2, #14]
	sub	sp, sp, #48
	ldrh	r1, [r2, #12]
	mov	r4, r0
	ldr	r2, .L1969+4
	movw	fp, #61664
	ldr	r7, .L1969+8
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
	b	.L1961
.L1967:
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
	beq	.L1962
	ldr	r2, [r7, #0]
	ldrh	r2, [r2, #0]
	cmp	r2, fp
	bne	.L1962
	cbz	r4, .L1968
	cbnz	r6, .L1964
	ldr	r2, .L1969+4
	movs	r0, #1
	ldr	r5, .L1969+12
	ldr	r2, [r2, #0]
	b	.L1965
.L1966:
	ubfx	r1, r6, #5, #16
	and	r7, r6, #31
	adds	r6, r6, #1
	lsl	r7, r0, r7
	ldr	lr, [r2, r1, lsl #2]
	uxth	r6, r6
	orr	r7, lr, r7
	str	r7, [r2, r1, lsl #2]
.L1965:
	ldr	r1, [r5, #0]
	cmp	r6, r1
	bcc	.L1966
.L1964:
	ldr	r2, .L1969+4
	mov	r0, r4
	ldr	r1, [r2, #0]
	mov	r2, r3
	bl	memcpy
	movs	r2, #4
	ldr	r0, .L1969+16
	mov	r1, r4
	mov	r3, r2
	bl	rknand_print_hex
	movs	r0, #0
	b	.L1963
.L1962:
	subs	r5, r5, #1
	uxth	r5, r5
.L1961:
	cmp	sl, r5
	ble	.L1967
	mov	r0, #-1
	b	.L1963
.L1968:
	mov	r0, r4
.L1963:
	add	sp, sp, #48
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L1970:
	.align	2
.L1969:
	.word	.LANCHOR28
	.word	.LANCHOR44
	.word	.LANCHOR234
	.word	.LANCHOR46
	.word	.LC35
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
	ldr	r3, .L1978
	ldr	r6, .L1978+4
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
	beq	.L1977
	movs	r2, #0
	lsrs	r0, r4, #4
	ldr	r6, [r6, #0]
	mov	r3, r2
	subs	r4, r4, #1
	movs	r1, #1
	b	.L1973
.L1975:
	lsrs	r7, r2, #5
	and	ip, r2, #31
	lsl	ip, r1, ip
	ldr	r7, [r6, r7, lsl #2]
	tst	ip, r7
	beq	.L1974
	strh	r2, [r5, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	uxth	r3, r3
.L1974:
	cmp	r3, r0
	bcs	.L1977
	adds	r2, r2, #1
	uxth	r2, r2
.L1973:
	cmp	r2, r4
	blt	.L1975
	b	.L1972
.L1977:
	movs	r3, #0
.L1972:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L1979:
	.align	2
.L1978:
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
	push	{r0, r1, r4, r5, r6, r7, r8, sl, fp, lr}
	bl	FtlBbtMemInit
	movs	r4, #0
	ldr	r5, .L1998
	bl	FtlLoadFactoryBbt
	ldr	r6, .L1998+4
	add	r2, r5, #12
	str	r2, [sp, #4]
	b	.L1981
.L1987:
	ldr	r3, .L1998+8
	ldr	r2, [sp, #4]
	ldr	r8, .L1998+20
	ldr	r0, [r3, #0]
	ldr	r3, .L1998+12
	str	r0, [r8, #8]
	ldr	sl, [r3, #0]
	ldrh	r3, [r2], #2
	str	sl, [r8, #12]
	str	r2, [sp, #4]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1982
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
	b	.L1983
.L1982:
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
	b	.L1996
.L1985:
	add	fp, fp, #-1
	uxth	fp, fp
.L1996:
	ldrh	r0, [r6, #0]
	mla	r0, r5, r0, fp
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1985
	ldr	r3, [sp, #4]
	movs	r1, #0
	ldr	r2, .L1998+12
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
	ldr	r3, .L1998+16
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #2
	bl	memcpy
	movs	r1, #1
	mov	r2, r1
	ldr	r0, .L1998+20
	bl	FlashEraseBlocks
	movs	r1, #1
	mov	r3, r1
	ldr	r0, .L1998+20
	mov	r2, r1
	bl	FlashProgPages
	ldr	r3, [r8, #0]
	adds	r3, r3, #1
	bne	.L1997
	uxth	r0, r7
	bl	FtlBbmMapBadBlock
	b	.L1996
.L1997:
	mov	r4, r5
	mov	r5, sl
.L1983:
	uxth	r0, r7
	adds	r4, r4, #1
	bl	FtlBbmMapBadBlock
	adds	r5, r5, #4
.L1981:
	ldr	r2, .L1998+24
	ldrh	r3, [r2, #0]
	cmp	r4, r3
	bcc	.L1987
	movs	r4, #0
	ldr	r5, .L1998+28
	b	.L1988
.L1989:
	mov	r0, r4
	adds	r4, r4, #1
	bl	FtlBbmMapBadBlock
	uxth	r4, r4
.L1988:
	ldrh	r3, [r5, #0]
	cmp	r3, r4
	bhi	.L1989
	ldr	r5, .L1998
	movw	r6, #65535
	ldrh	r4, [r5, #12]
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1990
.L1995:
	mov	r0, r4
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1991
	mov	r0, r4
	bl	FlashTestBlk
	cbz	r0, .L1992
	mov	r0, r4
	bl	FtlBbmMapBadBlock
	b	.L1991
.L1992:
	ldrh	r3, [r5, #0]
	cmp	r3, r6
	bne	.L1993
	strh	r4, [r5, #0]	@ movhi
	b	.L1991
.L1993:
	ldr	r3, .L1998
	strh	r4, [r3, #4]	@ movhi
	b	.L1994
.L1991:
	subs	r4, r4, #1
	uxth	r4, r4
.L1990:
	ldrh	r3, [r5, #12]
	subs	r3, r3, #47
	cmp	r3, r4
	ble	.L1995
.L1994:
	ldr	r4, .L1998
	movs	r5, #0
	ldr	r3, .L1998+32
	movs	r1, #1
	movs	r2, #2
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
	mov	r0, r5
	pop	{r2, r3, r4, r5, r6, r7, r8, sl, fp, pc}
.L1999:
	.align	2
.L1998:
	.word	.LANCHOR89
	.word	.LANCHOR66
	.word	.LANCHOR96
	.word	.LANCHOR180
	.word	.LANCHOR90
	.word	.LANCHOR197
	.word	.LANCHOR60
	.word	.LANCHOR75
	.word	.LANCHOR93
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
	ldr	r2, .L2021
	movs	r3, #0
	push	{r4, r5, r6, r7, r8, sl, fp, lr}
	str	r3, [r2, #0]
	ldr	r2, .L2021+4
	str	r3, [r2, #0]
	ldr	r3, .L2021+8
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2001
	bl	FtlMakeBbt
.L2001:
	ldr	r3, .L2021+12
	ldr	r2, .L2021+16
	ldrh	r4, [r3, #0]
	ldr	r3, .L2021+20
	lsls	r4, r4, #7
	ldr	r0, [r3, #0]
	ldr	r3, .L2021+24
	ldr	r1, [r3, #0]
	movs	r3, #0
	b	.L2002
.L2003:
	mvns	r5, r3
	orr	r5, r3, r5, lsl #16
	str	r5, [r0, r3, lsl #2]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	uxth	r3, r3
.L2002:
	cmp	r3, r4
	blt	.L2003
	ldr	r3, .L2021+28
	movs	r4, #0
	ldr	r6, .L2021+32
	ldrh	r5, [r3, #0]
	b	.L2004
.L2005:
	mov	r0, r5
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r5, r5, #1
	uxth	r5, r5
	adds	r4, r4, r0
	uxth	r4, r4
.L2004:
	ldrh	r3, [r6, #0]
	cmp	r3, r5
	bhi	.L2005
	ldr	r3, .L2021+36
	ldrh	r1, [r3, #0]
	subs	r3, r4, #2
	cmp	r3, r1, lsl #1
	bgt	.L2006
.L2010:
	movs	r4, #0
	ldr	r6, .L2021+28
	mov	r5, r4
	b	.L2007
.L2006:
	mov	r0, r4
	ldr	r5, .L2021+32
	bl	__aeabi_uidiv
	ldr	r3, .L2021+40
	ldr	r3, [r3, #0]
	adds	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldr	r3, .L2021+8
	ldrh	r0, [r3, #0]
	bl	FtlFreeSysBlkQueueInit
	ldr	r3, .L2021+28
	ldrh	r4, [r3, #0]
	b	.L2008
.L2009:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	uxth	r4, r4
.L2008:
	ldrh	r3, [r5, #0]
	cmp	r3, r4
	bhi	.L2009
	b	.L2010
.L2011:
	mov	r0, r5
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	adds	r5, r5, #1
	uxth	r5, r5
	adds	r4, r4, r0
	uxth	r4, r4
.L2007:
	ldrh	r3, [r6, #0]
	cmp	r3, r5
	bhi	.L2011
	ldr	r3, .L2021+32
	ldr	r8, .L2021+64
	ldr	sl, .L2021+68
	ldrh	r2, [r3, #0]
	ldr	r3, .L2021+44
	str	r2, [r3, #0]
	ldr	r3, .L2021+48
	ldr	fp, [r3, #0]
	ldr	r3, .L2021+36
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
	ble	.L2012
	rsb	r0, r4, fp
	mov	r1, r5
	bl	__aeabi_uidiv
	str	r0, [sl, #0]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r8, #0]	@ movhi
.L2012:
	ldr	r3, .L2021+52
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L2013
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r8, .L2021+64
	ldrh	sl, [r8, #0]
	uxtah	r0, sl, r0
	add	sl, sl, r0, lsr #2
	strh	sl, [r8, #0]	@ movhi
.L2013:
	ldr	r3, .L2021+56
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L2014
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r8, .L2021+64
	ldrh	sl, [r8, #0]
	uxtah	r0, sl, r0
	add	sl, sl, r0, lsr #2
	strh	sl, [r8, #0]	@ movhi
.L2014:
	ldr	r3, .L2021+60
	ldrh	r3, [r3, #0]
	cbz	r3, .L2015
	ldr	r2, .L2021+64
	ldrh	r1, [r2, #0]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2, #0]	@ movhi
	mul	r1, r5, r3
	cmp	r1, r4
	ble	.L2015
	ldr	r1, .L2021+68
	adds	r3, r3, #32
	adds	r7, r7, r3
	strh	r7, [r2, #0]	@ movhi
	str	r6, [r1, #0]
.L2015:
	ldr	r3, .L2021+68
	ldr	r2, .L2021+64
	ldr	r6, .L2021+72
	ldr	r1, [r3, #0]
	ldrh	r2, [r2, #0]
	ldr	r4, .L2021+76
	subs	r2, r1, r2
	muls	r5, r2, r5
	ldr	r2, .L2021+80
	str	r5, [r2, #0]
	ldr	r2, .L2021+84
	ldrh	r2, [r2, #0]
	muls	r5, r2, r5
	str	r5, [r3, #0]
	ldr	r3, .L2021+12
	ldrh	r3, [r3, #0]
	muls	r5, r3, r5
	ldr	r3, .L2021+88
	str	r5, [r3, #0]
	movw	r5, #65535
	bl	FtlBbmTblFlush
	ldr	r3, .L2021+32
	movs	r1, #0
	ldr	r0, [r6, #0]
	ldrh	r2, [r3, #0]
	lsls	r2, r2, #1
	bl	memset
	ldr	r2, .L2021+92
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	movs	r1, #255
	str	r3, [r2, #0]
	ldr	r2, .L2021+96
	strh	r3, [r4, #0]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	strb	r3, [r2, #6]
	strb	r3, [r2, #8]
	movs	r3, #1
	strb	r3, [r4, #8]
	ldr	r3, .L2021+28
	strh	r5, [r2, #0]	@ movhi
	ldrh	r2, [r3, #0]
	ldr	r3, .L2021+100
	lsrs	r2, r2, #3
	ldr	r0, [r3, #0]
	bl	memset
.L2016:
	ldr	r7, .L2021+76
	mov	r0, r7
	bl	make_superblock
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	ldr	r3, .L2021+72
	cbnz	r2, .L2017
	ldrh	r2, [r4, #0]
	ldr	r3, [r6, #0]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
	b	.L2016
.L2017:
	ldr	r2, .L2021
	movw	r6, #65535
	ldr	r4, .L2021+104
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
.L2018:
	ldr	r5, .L2021+104
	mov	r0, r5
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2019
	ldrh	r2, [r4, #0]
	ldr	r3, [r7, #0]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4, #0]
	adds	r3, r3, #1
	strh	r3, [r4, #0]	@ movhi
	b	.L2018
.L2022:
	.align	2
.L2021:
	.word	.LANCHOR153
	.word	.LANCHOR154
	.word	.LANCHOR54
	.word	.LANCHOR71
	.word	168778952
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR55
	.word	.LANCHOR56
	.word	.LANCHOR53
	.word	.LANCHOR81
	.word	.LANCHOR88
	.word	.LANCHOR57
	.word	.LANCHOR126
	.word	.LANCHOR7
	.word	.LANCHOR64
	.word	.LANCHOR200
	.word	.LANCHOR87
	.word	.LANCHOR99
	.word	.LANCHOR107
	.word	.LANCHOR199
	.word	.LANCHOR68
	.word	.LANCHOR84
	.word	.LANCHOR116
	.word	.LANCHOR201
	.word	.LANCHOR117
	.word	.LANCHOR108
.L2019:
	ldr	r4, .L2023
	ldrh	r1, [r5, #4]
	ldrh	r2, [r5, #0]
	ldr	r3, [r4, #0]
	str	r3, [r5, #12]
	adds	r3, r3, #1
	str	r3, [r4, #0]
	movw	r5, #65535
	ldr	r3, .L2023+4
	ldr	r3, [r3, #0]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2023+8
	strh	r5, [r3, #0]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2023+12
	movs	r2, #0
	strh	r2, [r3, #2]	@ movhi
	ldr	r2, .L2023+16
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
	cbnz	r0, .L2020
	ldr	r3, .L2023+20
	movs	r2, #1
	str	r2, [r3, #0]
.L2020:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2024:
	.align	2
.L2023:
	.word	.LANCHOR153
	.word	.LANCHOR99
	.word	.LANCHOR109
	.word	.LANCHOR191
	.word	.LANCHOR199
	.word	.LANCHOR222
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
	ldr	r3, .L2114
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
	bne	.L2026
	movs	r2, #167
	strb	r2, [r3, #4]
	ldr	r3, .L2114+4
	movs	r2, #247
	strb	r2, [r3, #17]
	b	.L2081
.L2026:
	cmp	r4, #3
	bne	.L2028
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
	b	.L2108
.L2028:
	cmp	r4, #4
	bne	.L2029
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
.L2108:
	movs	r6, #8
	strb	r2, [r3, #11]
	mov	r5, r6
	b	.L2027
.L2029:
	cmp	r4, #5
	bne	.L2030
	movs	r2, #56
	movs	r6, #8
	strb	r2, [r3, #4]
	movs	r2, #57
	strb	r2, [r3, #5]
	movs	r2, #58
	strb	r2, [r3, #6]
	movs	r2, #59
	strb	r2, [r3, #7]
	b	.L2107
.L2030:
	cmp	r4, #6
	bne	.L2031
	movs	r2, #14
	movs	r6, #12
	strb	r2, [r3, #4]
	movs	r2, #15
	strb	r2, [r3, #5]
	movs	r2, #16
	strb	r2, [r3, #6]
	movs	r2, #17
	strb	r2, [r3, #7]
	b	.L2107
.L2031:
	cmp	r4, #7
	bne	.L2081
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
	b	.L2027
.L2081:
	movs	r6, #7
.L2107:
	movs	r5, #4
.L2027:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L2103
	b	.L2112
.L2038:
	ldr	r3, .L2114+8
	mov	sl, #0
	ldr	r1, .L2114+12
	ldr	r4, .L2114+16
	ldrb	r2, [r3, r7]	@ zero_extendqisi2
	ldr	r0, [r1, r2, lsl #3]
	add	r4, r4, r2, lsl #6
	add	r2, r1, r2, lsl #3
	ldrb	r3, [r2, #4]	@ zero_extendqisi2
	movs	r2, #55
	adds	r3, r3, #8
	add	r3, r0, r3, lsl #8
.L2034:
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
	bcc	.L2034
	movs	r3, #0
	b	.L2035
.L2036:
	ldrb	ip, [sl, r2, lsl #2]	@ zero_extendqisi2
	ldrb	r0, [r4, r3]	@ zero_extendqisi2
	add	r0, ip, r0
	strb	r0, [r1, r2, lsl #3]
	adds	r2, r2, #1
	cmp	r2, #7
	bne	.L2036
	adds	r3, r3, #1
	cmp	r3, #4
	beq	.L2037
.L2035:
	movs	r2, #1
	adds	r1, r4, r3
	add	sl, fp, r3
	b	.L2036
.L2037:
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
	b	.L2032
.L2112:
	ldr	r8, .L2114
	movs	r7, #0
	ldr	fp, .L2114+4
.L2032:
	ldr	r3, .L2114+20
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, r7
	bhi	.L2038
	b	.L2039
.L2103:
	subs	r3, r4, #3
	cmp	r3, #4
	bhi	.L2039
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
	b	.L2040
.L2080:
	ldr	r3, .L2114+8
	ldr	fp, [sp, #20]
	ldrb	r6, [r3, fp]	@ zero_extendqisi2
	ldr	r3, .L2114+12
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
	beq	.L2041
	ldr	r1, .L2114+16
	add	r3, r1, r3, lsl #6
	b	.L2109
.L2041:
	lsls	r1, r3, #7
	add	r3, r1, r3, lsl #5
	ldr	r1, .L2114+24
	adds	r3, r1, r3
.L2109:
	str	r3, [sp, #32]
	movs	r3, #54
	cmp	r4, #4
	str	r3, [r7, #8]
	bne	.L2043
	movs	r3, #255
	str	r3, [r7, #4]
	movs	r3, #64
	str	r3, [sl, r8]
	movs	r3, #204
	b	.L2110
.L2043:
	subs	r3, r4, #5
	cmp	r3, #1
	bhi	.L2045
	ldr	r3, .L2114
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r7, #4]
	movs	r3, #82
	b	.L2111
.L2045:
	movs	r3, #174
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [sl, r8]
	movs	r3, #176
.L2110:
	str	r3, [r7, #4]
	movs	r3, #77
.L2111:
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
	bls	.L2083
	cmp	r4, #7
	ite	eq
	moveq	r1, #32
	movne	r1, #2
	b	.L2049
.L2083:
	movs	r1, #16
.L2049:
	ldr	r3, .L2114+28
	ldr	r2, [r3, #0]
	movs	r3, #0
.L2050:
	ldr	r0, [r7, #0]
	strb	r0, [r2, r3]
	adds	r3, r3, #1
	uxtb	r0, r3
	cmp	r0, r1
	bcc	.L2050
	cmp	r4, #7
	bne	.L2051
	movs	r3, #0
.L2053:
	ldrb	r1, [r2, #0]	@ zero_extendqisi2
	cmp	r1, #12
	beq	.L2052
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	cmp	r1, #10
	beq	.L2052
	adds	r3, r3, #1
	adds	r2, r2, #4
	uxtb	r3, r3
	cmp	r3, #8
	bne	.L2053
	b	.L2054
.L2052:
	cmp	r3, #6
	bls	.L2055
.L2054:
	ldr	r0, .L2114+32
	movs	r1, #0
	bl	printf
.L2056:
	b	.L2056
.L2051:
	cmp	r4, #6
	bne	.L2055
	movs	r3, #0
.L2057:
	ldrb	r1, [r2], #1	@ zero_extendqisi2
	cmp	r1, #12
	beq	.L2055
	ldrb	r1, [r2, #7]	@ zero_extendqisi2
	cmp	r1, #4
	beq	.L2055
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #8
	bne	.L2057
	b	.L2113
.L2059:
	b	.L2059
.L2115:
	.align	2
.L2114:
	.word	.LANCHOR31
	.word	.LANCHOR235
	.word	.LANCHOR19
	.word	.LANCHOR5
	.word	.LANCHOR31+20
	.word	.LANCHOR16
	.word	.LANCHOR31+28
	.word	.LANCHOR44
	.word	.LC36
.L2055:
	ldr	r0, .L2116
	movs	r3, #0
	ldr	r0, [r0, #0]
	str	r0, [sp, #40]
.L2060:
	ldr	r2, [r7, #0]
	ldr	r1, [sp, #40]
	strb	r2, [r1, r3]
	adds	r3, r3, #1
	ldr	r2, [sp, #52]
	cmp	r3, r2
	blt	.L2060
	ldr	r3, .L2116
	movs	r2, #8
	ldr	ip, [sp, #24]
	ldr	r1, [r3, #0]
	lsl	r0, ip, #2
	lsl	fp, ip, #3
	str	r0, [sp, #44]
	adds	r0, r1, r0
.L2062:
	movs	r3, #0
	mov	lr, r3
.L2061:
	ldr	ip, [r0, r3]
	add	lr, lr, #1
	mvn	ip, ip
	str	ip, [r0, r3]
	ldr	ip, [sp, #24]
	adds	r3, r3, #4
	cmp	lr, ip
	blt	.L2061
	subs	r2, r2, #1
	add	r0, r0, fp
	bne	.L2062
	mov	lr, r1
	str	r2, [sp, #16]
	str	r5, [sp, #60]
	b	.L2063
.L2067:
	movs	r0, #1
	mov	fp, #16
	str	r3, [sp, #4]
	lsl	r5, r0, r3
	movs	r0, #0
	mov	ip, r0
	str	fp, [sp, #28]
.L2065:
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
	bne	.L2065
	ldr	r3, [sp, #4]
	cmp	ip, #8
	it	hi
	orrhi	r2, r2, r5
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L2067
	ldr	fp, [sp, #16]
	ldr	ip, [sp, #24]
	add	fp, fp, #1
	str	r2, [lr], #4
	cmp	fp, ip
	str	fp, [sp, #16]
	bge	.L2085
.L2063:
	movs	r2, #0
	mov	r3, r2
	b	.L2067
.L2085:
	movs	r3, #0
	ldr	r5, [sp, #60]
	mov	r2, r3
.L2068:
	ldr	r0, [r1, r3]
	cbnz	r0, .L2069
	adds	r2, r2, #1
.L2069:
	adds	r3, r3, #4
	cmp	r3, #32
	bne	.L2068
	cmp	r2, #7
	ble	.L2070
	ldr	r0, .L2116+4
	movs	r2, #1
	mov	r3, #1024
	bl	rknand_print_hex
	ldr	r0, .L2116+8
	movs	r1, #0
	bl	printf
.L2071:
	b	.L2071
.L2070:
	cmp	r4, #6
	beq	.L2086
	cmp	r4, #7
	ite	eq
	moveq	r0, #10
	movne	r0, #8
	str	r0, [sp, #16]
	b	.L2072
.L2086:
	movs	r1, #4
	str	r1, [sp, #16]
.L2072:
	cbz	r5, .L2073
	ldr	r2, [sp, #56]
	add	lr, r2, #1
	b	.L2074
.L2073:
	mov	lr, #1
.L2074:
	ldr	r0, [sp, #40]
	movs	r2, #0
	ldr	r1, [sp, #32]
	mov	fp, r4
	b	.L2075
.L2076:
	ldrb	ip, [r4], #1	@ zero_extendqisi2
	strb	ip, [r1, r3]
	adds	r3, r3, #1
	uxtb	ip, r3
	cmp	ip, r5
	bcc	.L2076
	ldr	ip, [sp, #48]
	adds	r2, r2, #1
	ldr	r3, [sp, #16]
	add	r0, r0, lr
	cmp	r2, ip
	add	r1, r1, r3
	bge	.L2077
.L2075:
	mov	r4, r0
	movs	r3, #0
	b	.L2076
.L2077:
	movs	r3, #255
	mov	r0, r6
	str	r3, [r7, #8]
	mov	r4, fp
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #36]
	cmp	r1, #1
	bhi	.L2078
	movs	r3, #54
	str	r3, [r7, #8]
	ldr	r3, .L2116+12
	mov	r1, #-1
	ldr	r0, [sp, #20]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [sl, r8]
	movs	r3, #22
	str	r3, [r7, #8]
	bl	FlashReadCmd
	b	.L2079
.L2078:
	movs	r3, #56
	str	r3, [r7, #8]
.L2079:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r2, [sp, #20]
	adds	r3, r2, #1
	uxtb	r3, r3
	str	r3, [sp, #20]
.L2040:
	ldr	r0, .L2116+16
	ldr	r2, [sp, #20]
	ldrb	r3, [r0, #0]	@ zero_extendqisi2
	cmp	r3, r2
	bhi	.L2080
	ldr	r6, [sp, #48]
.L2039:
	ldr	r3, .L2116+12
	strb	r5, [r3, #1]
	strb	r6, [r3, #2]
	add	sp, sp, #64
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2113:
	movs	r1, #0
	ldr	r0, .L2116+8
	bl	printf
	b	.L2059
.L2117:
	.align	2
.L2116:
	.word	.LANCHOR44
	.word	.LC37
	.word	.LC36
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
	beq	.L2118
	subs	r2, r0, #1
	cmp	r2, #6
	bhi	.L2120
	b	HynixGetReadRetryDefault
.L2120:
	cmp	r0, #49
	bne	.L2121
	ldr	r0, .L2129
	movs	r2, #64
	ldr	r1, .L2129+4
	strb	r3, [r0, #0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
	adds	r0, r0, #4
	b	.L2127
.L2121:
	cmp	r0, #33
	beq	.L2122
	cmp	r0, #65
	beq	.L2122
	cmp	r0, #66
	bne	.L2123
.L2122:
	ldr	r0, .L2129
	strb	r3, [r0, #0]
	movs	r3, #4
	b	.L2128
.L2123:
	cmp	r0, #34
	beq	.L2124
	cmp	r0, #67
	bne	.L2125
.L2124:
	ldr	r0, .L2129
	strb	r3, [r0, #0]
	movs	r3, #5
.L2128:
	strb	r3, [r0, #1]
	movs	r2, #45
	movs	r3, #7
	ldr	r1, .L2129+8
	strb	r3, [r0, #2]
	adds	r0, r0, #4
	b	.L2127
.L2125:
	cmp	r0, #35
	beq	.L2126
	cmp	r0, #68
	bne	.L2118
.L2126:
	ldr	r0, .L2129
	movs	r2, #95
	ldr	r1, .L2129+12
	strb	r3, [r0, #0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	adds	r0, r0, #4
.L2127:
	b	memcpy
.L2118:
	bx	lr
.L2130:
	.align	2
.L2129:
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
	ldr	r3, .L2180
	movs	r5, #0
	ldr	r8, .L2180+84
	mov	r6, r5
	str	r0, [r3, #0]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L2180+4
	str	r0, [r3, #0]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L2180+8
	str	r0, [r3, #0]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L2180+12
	str	r0, [r3, #0]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L2180+16
	ldr	r2, .L2180+20
	str	r0, [r3, #0]
	movs	r3, #50
	strb	r3, [r2, #0]
	mov	r0, r4
	ldr	r2, .L2180+24
	ldr	r4, .L2180+28
	strb	r3, [r2, #0]
	movs	r2, #128
	ldr	r3, .L2180+32
	mov	r7, r4
	str	r5, [r3, #0]
	ldr	r3, .L2180+36
	str	r2, [r3, #0]
	movs	r2, #60
	ldr	r3, .L2180+40
	strb	r5, [r3, #0]
	ldr	r3, .L2180+44
	str	r5, [r3, #0]
	ldr	r3, .L2180+48
	strb	r5, [r3, #0]
	ldr	r3, .L2180+52
	strb	r2, [r3, #0]
	bl	NandcInit
.L2136:
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
	bhi	.L2132
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L2180+56
	str	r1, [sp, #0]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	str	r1, [sp, #12]
	adds	r1, r6, #1
	bl	printf
.L2132:
	cbnz	r6, .L2133
	ldrb	r3, [r7, #0]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L2172
	ldrb	r3, [r7, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L2172
.L2133:
	ldrb	r3, [r5, r7]	@ zero_extendqisi2
	cmp	r3, #181
	bne	.L2135
	movs	r3, #44
	strb	r3, [r5, r7]
.L2135:
	adds	r6, r6, #1
	adds	r5, r5, #8
	adds	r4, r4, #8
	cmp	r6, #4
	bne	.L2136
	ldr	r3, .L2180+28
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L2137
	ldr	r3, .L2180+60
	ldr	r0, [r3, #0]
	bl	NandcSetDdrMode
.L2137:
	movs	r1, #0
	mov	r2, #852
	ldr	r0, .L2180+64
	bl	memset
	ldr	r2, .L2180+68
	ldr	r3, .L2180+72
	str	r2, [r3, #0]
	movs	r2, #0
	ldr	r3, .L2180+76
	strb	r2, [r3, #0]
	ldr	r3, .L2180+28
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	cmp	r3, #241
	beq	.L2138
	cmp	r3, #218
	beq	.L2138
	cmp	r3, #220
	bne	.L2139
.L2138:
	ldr	r2, .L2180+48
	movs	r1, #1
	ldr	r0, .L2180+28
	strb	r1, [r2, #0]
	movs	r2, #16
	ldr	r1, .L2180+20
	ldrb	r4, [r0, #0]	@ zero_extendqisi2
	strb	r2, [r1, #0]
	cmp	r4, #152
	ldr	r1, .L2180+52
	strb	r2, [r1, #0]
	ldr	r2, .L2180+80
	strb	r4, [r2, #1]
	bne	.L2140
	ldrsb	r0, [r0, #4]
	cmp	r0, #0
	blt	.L2140
	movs	r0, #24
	strb	r0, [r1, #0]
.L2140:
	cmp	r3, #218
	bne	.L2141
	mov	r1, #2048
	b	.L2177
.L2181:
	.align	2
.L2180:
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR234
	.word	.LANCHOR203
	.word	.LANCHOR204
	.word	.LANCHOR1
	.word	.LANCHOR49
	.word	.LANCHOR22
	.word	.LANCHOR46
	.word	.LANCHOR2
	.word	.LANCHOR35
	.word	.LANCHOR50
	.word	.LANCHOR0
	.word	.LANCHOR45
	.word	.LC38
	.word	.LANCHOR187
	.word	.LANCHOR31
	.word	.LANCHOR18
	.word	.LANCHOR23
	.word	.LANCHOR4
	.word	.LANCHOR236
	.word	.LANCHOR5
.L2141:
	cmp	r3, #220
	bne	.L2142
	mov	r1, #4096
.L2177:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L2142:
	ldr	r1, .L2182
	movs	r2, #32
	ldr	r0, .L2182+4
	bl	memcpy
	ldr	r0, .L2182+8
	ldr	r1, .L2182+12
	movs	r2, #32
	bl	memcpy
.L2139:
	ldr	r3, .L2182+16
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2143
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L2144
	ldr	r3, .L2182+20
	ldr	r4, .L2182+24
	ldr	r3, [r3, #0]
	ldrh	r0, [r3, #16]
	ubfx	r0, r0, #8, #3
	strb	r0, [r4, #0]
	lsls	r2, r0, #31
	bmi	.L2144
	ldr	r3, .L2182+28
	movs	r2, #1
	strb	r2, [r3, #0]
	bl	FlashSetInterfaceMode
	ldrb	r0, [r4, #0]	@ zero_extendqisi2
	bl	NandcSetMode
.L2144:
	ldr	r4, .L2182+20
	ldr	r3, [r4, #0]
	ldrb	r2, [r3, #26]	@ zero_extendqisi2
	ldr	r3, .L2182+32
	strb	r2, [r3, #0]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L2143
	ldr	r3, [r4, #0]
	ldr	r0, .L2182+36
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r3, r0, #1
	beq	.L2134
	bl	FlashDieInfoInit
	ldr	r3, [r4, #0]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r1, .L2182+40
	ldr	r3, [r4, #0]
	ldrh	r1, [r1, #0]
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	addw	r1, r1, #4095
	cmp	r2, r1, lsr #12
	blt	.L2145
	ldrh	r1, [r3, #14]
	adds	r1, r1, #255
	cmp	r2, r1, lsr #8
	bge	.L2146
.L2145:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L2146:
	ldr	r3, .L2182+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L2147
	bl	FlashSavePhyInfo
	ldr	r3, .L2182+44
	movs	r0, #0
	ldr	r1, [r3, #0]
	bl	FlashDdrParaScan
.L2147:
	bl	FlashSavePhyInfo
.L2143:
	ldr	r5, .L2182+20
	ldr	r2, .L2182+32
	ldr	r4, .L2182+48
	ldr	r3, [r5, #0]
	ldrb	r1, [r3, #26]	@ zero_extendqisi2
	ldrb	r6, [r3, #18]	@ zero_extendqisi2
	strb	r1, [r2, #0]
	ldr	r1, .L2182+52
	ldrh	r2, [r3, #16]
	ubfx	r0, r2, #7, #1
	strb	r0, [r1, #0]
	ldr	r1, .L2182+56
	ubfx	r0, r2, #3, #1
	strb	r0, [r1, #0]
	ubfx	r0, r2, #4, #1
	ldr	r1, .L2182+60
	ubfx	r2, r2, #8, #3
	strb	r0, [r1, #0]
	ldr	r1, .L2182+24
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
	bpl	.L2148
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	ldr	r2, .L2182+64
	ldr	r3, .L2182+68
	ldrb	r1, [r2, #1]	@ zero_extendqisi2
	strb	r0, [r3, #0]
	ldr	r3, .L2182+72
	strb	r1, [r3, #0]
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	ldr	r3, .L2182+76
	strb	r1, [r3, #0]
	subs	r1, r0, #1
	cmp	r1, #6
	bhi	.L2149
	ldr	r3, .L2182+80
	str	r3, [r4, #0]
	subs	r3, r0, #5
	cmp	r3, #1
	bhi	.L2150
	ldr	r3, .L2182+84
	movs	r2, #1
	str	r2, [r3, #0]
	b	.L2151
.L2150:
	cmp	r0, #7
	beq	.L2174
.L2151:
	ldr	r1, .L2182+88
	b	.L2152
.L2174:
	add	r1, r2, #28
.L2152:
	movs	r3, #0
	mov	r2, r3
.L2154:
	ldrsb	r4, [r1, r2]
	cbnz	r4, .L2153
	adds	r3, r3, #1
.L2153:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L2154
	cmp	r3, #27
	bls	.L2148
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
	b	.L2148
.L2149:
	sub	r2, r0, #17
	cmp	r2, #2
	bhi	.L2155
	ldr	r2, .L2182+92
	str	r2, [r4, #0]
	movs	r2, #7
	cmp	r0, #19
	strb	r2, [r3, #0]
	bne	.L2148
	movs	r2, #15
	b	.L2178
.L2155:
	cmp	r0, #33
	beq	.L2156
	cmp	r0, #65
	beq	.L2156
	cmp	r0, #66
	bne	.L2157
.L2156:
	ldr	r2, .L2182+96
	ldr	r3, .L2182+48
	str	r2, [r3, #0]
	movs	r2, #4
	ldr	r3, .L2182+72
	strb	r2, [r3, #0]
	movs	r2, #7
	ldr	r3, .L2182+76
	b	.L2178
.L2157:
	cmp	r0, #67
	beq	.L2158
	cmp	r0, #34
	beq	.L2158
	cmp	r0, #35
	beq	.L2158
	cmp	r0, #68
	bne	.L2159
.L2158:
	ldr	r2, .L2182+96
	ldr	r3, .L2182+48
	str	r2, [r3, #0]
	movs	r2, #7
	ldr	r3, .L2182+76
	cmp	r0, #35
	strb	r2, [r3, #0]
	beq	.L2160
	cmp	r0, #68
	bne	.L2161
.L2160:
	movs	r2, #17
	strb	r2, [r3, #0]
.L2161:
	subs	r0, r0, #67
	ldr	r3, .L2182+72
	cmp	r0, #1
	bhi	.L2162
	movs	r2, #4
.L2178:
	strb	r2, [r3, #0]
	b	.L2148
.L2162:
	movs	r2, #5
	b	.L2178
.L2159:
	cmp	r0, #49
	bne	.L2148
	ldr	r2, .L2182+100
	ldr	r3, .L2182+48
	str	r2, [r3, #0]
.L2148:
	ldr	r3, .L2182+104
	ldr	r2, [r3, #0]
	ldr	r3, .L2182+108
	cmp	r2, r3
	bne	.L2163
	ldr	r3, .L2182+32
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cbz	r3, .L2163
	ldr	r3, .L2182+20
	movs	r2, #0
	ldr	r3, [r3, #0]
	strb	r2, [r3, #18]
.L2163:
	ldr	r3, .L2182+112
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L2164
	ldr	r3, .L2182+28
	ldrb	r2, [r3, #0]	@ zero_extendqisi2
	cbz	r2, .L2164
	movs	r2, #0
	movs	r0, #1
	strb	r2, [r3, #0]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L2164:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldr	r3, .L2182+24
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L2165
	ldr	r2, .L2182+28
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cbnz	r2, .L2166
	lsls	r1, r3, #31
	bmi	.L2165
.L2166:
	ldr	r3, .L2182+44
	movs	r0, #0
	ldr	r1, [r3, #0]
	bl	FlashDdrParaScan
.L2165:
	movs	r0, #0
	bl	flash_exit_slc_mode
	ldr	r3, .L2182+20
	ldr	r3, [r3, #0]
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L2182+116
	bl	FlashReadIdbDataRaw
	ldr	r3, .L2182+120
	cmp	r0, #0
	bne	.L2167
	ldr	r2, .L2182+124
	ldrb	r1, [r3, #0]	@ zero_extendqisi2
	ldrb	r2, [r2, #0]	@ zero_extendqisi2
	cmp	r1, r2
	it	hi
	strbhi	r2, [r3, #0]
	ldrb	r3, [r3, #0]	@ zero_extendqisi2
	cmp	r3, #15
	bhi	.L2169
	movs	r2, #16
	ldr	r3, .L2182+120
	b	.L2179
.L2183:
	.align	2
.L2182:
	.word	.LANCHOR27+32
	.word	.LANCHOR6
	.word	.LANCHOR18
	.word	.LANCHOR236
	.word	.LANCHOR0
	.word	.LANCHOR23
	.word	.LANCHOR34
	.word	.LANCHOR35
	.word	.LANCHOR7
	.word	.LC39
	.word	.LANCHOR24
	.word	.LANCHOR47
	.word	.LANCHOR51
	.word	.LANCHOR4
	.word	.LANCHOR189
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
	.word	SamsungReadRetrial
	.word	.LANCHOR40
	.word	1446522928
	.word	.LANCHOR22
	.word	.LANCHOR25
	.word	.LANCHOR1
	.word	.LANCHOR49
.L2167:
	movs	r2, #16
.L2179:
	strb	r2, [r3, #0]
.L2169:
	ldr	r3, .L2184
	ldr	r4, .L2184+4
	ldr	r5, [r3, #0]
	ldrb	r1, [r5, #12]	@ zero_extendqisi2
	ldrh	r6, [r5, #10]
	ldrh	r7, [r5, #14]
	strh	r1, [r4, #8]	@ movhi
	mov	r0, r6
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	str	r3, [r4, #4]
	ldr	r3, .L2184+8
	ldr	r3, [r3, #0]
	str	r3, [r4, #0]
	ldr	r3, .L2184+12
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
	ldr	r2, .L2184+16
	strh	r3, [r4, #20]	@ movhi
	strh	r6, [r4, #22]	@ movhi
	ldrb	r1, [r2, #0]	@ zero_extendqisi2
	strh	r1, [r4, #26]	@ movhi
	ldr	r1, .L2184+20
	ldrb	r1, [r1, #0]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2170
	lsls	r3, r3, #1
	movs	r1, #16
	lsrs	r7, r7, #1
	strh	r3, [r4, #20]	@ movhi
	lsls	r6, r6, #1
	movs	r3, #8
	strb	r1, [r2, #0]
	strh	r7, [r4, #14]	@ movhi
	strh	r6, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L2170:
	ldrb	r0, [r5, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
	b	.L2134
.L2172:
	mvn	r0, #1
.L2134:
	add	sp, sp, #24
	pop	{r4, r5, r6, r7, r8, sl, fp, pc}
.L2185:
	.align	2
.L2184:
	.word	.LANCHOR23
	.word	.LANCHOR28
	.word	.LANCHOR22
	.word	.LANCHOR16
	.word	.LANCHOR1
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
	cbnz	r0, .L2187
	ldr	r0, .L2188
	bl	FtlInit
.L2187:
	mov	r1, r4
	ldr	r0, .L2188+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2189:
	.align	2
.L2188:
	.word	.LANCHOR28
	.word	.LC40
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
.LANCHOR226 = . + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.p_blk_mode_table,"aw",%nobits
	.align	2
.LANCHOR117 = . + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 4
p_blk_mode_table:
	.space	4
	.section	.rodata.__func__.8224,"a",%progbits
.LANCHOR220 = . + 0
	.type	__func__.8224, %object
	.size	__func__.8224, 19
__func__.8224:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.bss.p_gc_blk_tbl,"aw",%nobits
	.align	2
.LANCHOR143 = . + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.g_ect_tbl_power_up_flush,"aw",%nobits
	.align	1
.LANCHOR214 = . + 0
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
.LANCHOR235 = . + 0
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
.LANCHOR141 = . + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.space	512
	.section	.rodata.__func__.8120,"a",%progbits
.LANCHOR209 = . + 0
	.type	__func__.8120, %object
	.size	__func__.8120, 25
__func__.8120:
	.ascii	"allocate_data_superblock\000"
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
.LANCHOR70 = . + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.space	2
	.section	.bss.g_inkDie_check_enable,"aw",%nobits
	.align	2
.LANCHOR126 = . + 0
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
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",%nobits
	.align	1
.LANCHOR200 = . + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.space	2
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
.LANCHOR176 = . + 0
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
	.section	.rodata.__func__.7721,"a",%progbits
.LANCHOR212 = . + 0
	.type	__func__.7721, %object
	.size	__func__.7721, 16
__func__.7721:
	.ascii	"FtlMapWritePage\000"
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
.LANCHOR99 = . + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.req_erase,"aw",%nobits
	.align	2
.LANCHOR93 = . + 0
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
.LANCHOR199 = . + 0
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
	.section	.bss.gMasterTempBuf,"aw",%nobits
	.align	2
.LANCHOR188 = . + 0
	.type	gMasterTempBuf, %object
	.size	gMasterTempBuf, 4
gMasterTempBuf:
	.space	4
	.section	.rodata.__func__.7617,"a",%progbits
.LANCHOR106 = . + 0
	.type	__func__.7617, %object
	.size	__func__.7617, 17
__func__.7617:
	.ascii	"List_remove_node\000"
	.section	.bss.gpFlashSaveInfo,"aw",%nobits
	.align	2
.LANCHOR43 = . + 0
	.type	gpFlashSaveInfo, %object
	.size	gpFlashSaveInfo, 4
gpFlashSaveInfo:
	.space	4
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
.LANCHOR153 = . + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.space	4
	.section	.rodata.__func__.7840,"a",%progbits
.LANCHOR192 = . + 0
	.type	__func__.7840, %object
	.size	__func__.7840, 14
__func__.7840:
	.ascii	"FtlScanSysBlk\000"
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
	.ascii	"%s 0x%x:\000"
.LC13:
	.ascii	"%x \000"
.LC14:
	.ascii	"\000"
.LC15:
	.ascii	"Read pageadd=%x  ecc=%x err=%x\012\000"
.LC16:
	.ascii	"data:\000"
.LC17:
	.ascii	"spare:\000"
.LC18:
	.ascii	"ReadRetry pageadd=%x ecc=%x err=%x\012\000"
.LC19:
	.ascii	"slc mode\000"
.LC20:
	.ascii	"no ect\000"
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
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC31:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
.LC32:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
.LC33:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC34:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
.LC35:
	.ascii	"BBT:\000"
.LC36:
	.ascii	"otp error! %d\000"
.LC37:
	.ascii	"rr\000"
.LC38:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
.LC39:
	.ascii	"FlashLoadPhyInfo fail %x!!\012\000"
.LC40:
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
.LANCHOR197 = . + 0
	.type	req_sys, %object
	.size	req_sys, 36
req_sys:
	.space	36
	.section	.bss.gFlashSpareBuffer,"aw",%nobits
	.align	2
.LANCHOR234 = . + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 4
gFlashSpareBuffer:
	.space	4
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
.LANCHOR185 = . + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.g_gc_next_blk,"aw",%nobits
	.align	1
.LANCHOR146 = . + 0
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
	.section	.rodata.__func__.8134,"a",%progbits
.LANCHOR217 = . + 0
	.type	__func__.8134, %object
	.size	__func__.8134, 29
__func__.8134:
	.ascii	"allocate_new_data_superblock\000"
	.section	.bss.read_retry_cur_offset,"aw",%nobits
.LANCHOR32 = . + 0
	.type	read_retry_cur_offset, %object
	.size	read_retry_cur_offset, 4
read_retry_cur_offset:
	.space	4
	.section	.bss.p_vendor_block_valid_page_count,"aw",%nobits
	.align	2
.LANCHOR184 = . + 0
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
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
.LANCHOR104 = . + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
.LANCHOR97 = . + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.rodata.__func__.7894,"a",%progbits
.LANCHOR198 = . + 0
	.type	__func__.7894, %object
	.size	__func__.7894, 15
__func__.7894:
	.ascii	"FtlLoadSysInfo\000"
	.section	.bss.g_gc_skip_write_count,"aw",%nobits
	.align	2
.LANCHOR169 = . + 0
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
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
.LANCHOR228 = . + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.space	2
	.section	.rodata.__func__.7583,"a",%progbits
.LANCHOR105 = . + 0
	.type	__func__.7583, %object
	.size	__func__.7583, 17
__func__.7583:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.bss.DieAddrs,"aw",%nobits
	.align	2
.LANCHOR20 = . + 0
	.type	DieAddrs, %object
	.size	DieAddrs, 32
DieAddrs:
	.space	32
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
.LANCHOR161 = . + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.rodata.__func__.7587,"a",%progbits
.LANCHOR102 = . + 0
	.type	__func__.7587, %object
	.size	__func__.7587, 17
__func__.7587:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.data.gSlcNandParaInfo,"aw",%progbits
	.align	1
.LANCHOR236 = . + 0
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
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
.LANCHOR180 = . + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 4
p_sys_spare_buf:
	.space	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",%nobits
	.align	1
.LANCHOR150 = . + 0
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
.LANCHOR131 = . + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",%nobits
	.align	1
.LANCHOR230 = . + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.rodata.__func__.7474,"a",%progbits
.LANCHOR202 = . + 0
	.type	__func__.7474, %object
	.size	__func__.7474, 11
__func__.7474:
	.ascii	"FtlLoadBbt\000"
	.section	.bss.g_totle_write_sector,"aw",%nobits
	.align	2
.LANCHOR193 = . + 0
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
.LANCHOR166 = . + 0
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
.LANCHOR187 = . + 0
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
.LANCHOR122 = . + 0
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
	.section	.rodata.__func__.8140,"a",%progbits
.LANCHOR208 = . + 0
	.type	__func__.8140, %object
	.size	__func__.8140, 19
__func__.8140:
	.ascii	"get_new_active_ppa\000"
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
	.section	.bss.c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
.LANCHOR66 = . + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.space	2
	.section	.rodata.__func__.7364,"a",%progbits
.LANCHOR233 = . + 0
	.type	__func__.7364, %object
	.size	__func__.7364, 10
__func__.7364:
	.ascii	"ftl_write\000"
	.section	.bss.g_totle_read_sector,"aw",%nobits
	.align	2
.LANCHOR194 = . + 0
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
	.section	.rodata.__func__.7743,"a",%progbits
.LANCHOR114 = . + 0
	.type	__func__.7743, %object
	.size	__func__.7743, 22
__func__.7743:
	.ascii	"select_l2p_ram_region\000"
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
.LANCHOR147 = . + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.rodata.__func__.7820,"a",%progbits
.LANCHOR205 = . + 0
	.type	__func__.7820, %object
	.size	__func__.7820, 15
__func__.7820:
	.ascii	"FtlVpcTblFlush\000"
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
.LANCHOR82 = . + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.space	2
	.section	.bss.req_gc,"aw",%nobits
	.align	2
.LANCHOR132 = . + 0
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
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
.LANCHOR85 = . + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.p_l2p_ram_map,"aw",%nobits
	.align	2
.LANCHOR112 = . + 0
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
.LANCHOR158 = . + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
.LANCHOR128 = . + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
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
.LANCHOR149 = . + 0
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
.LANCHOR100 = . + 0
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
.LANCHOR123 = . + 0
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
.LANCHOR136 = . + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.space	4
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
.LANCHOR89 = . + 0
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
.LANCHOR224 = . + 0
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
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",%nobits
	.align	2
.LANCHOR204 = . + 0
	.type	gFlashProgCheckSpareBuffer, %object
	.size	gFlashProgCheckSpareBuffer, 4
gFlashProgCheckSpareBuffer:
	.space	4
	.section	.bss.g_tmp_data_superblock_id,"aw",%nobits
	.align	1
.LANCHOR135 = . + 0
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
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
.LANCHOR124 = . + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 4
p_map_region_ppn_table:
	.space	4
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
.LANCHOR229 = . + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.space	2
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
.LANCHOR145 = . + 0
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
.LANCHOR221 = . + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.rodata.__func__.7759,"a",%progbits
.LANCHOR215 = . + 0
	.type	__func__.7759, %object
	.size	__func__.7759, 9
__func__.7759:
	.ascii	"log2phys\000"
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
.LANCHOR182 = . + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.space	2
	.section	.bss.g_all_blk_used_slc_mode,"aw",%nobits
	.align	2
.LANCHOR152 = . + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.space	4
	.section	.rodata.__func__.8040,"a",%progbits
.LANCHOR125 = . + 0
	.type	__func__.8040, %object
	.size	__func__.8040, 16
__func__.8040:
	.ascii	"make_superblock\000"
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",%nobits
	.align	1
.LANCHOR78 = . + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
.LANCHOR232 = . + 0
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
.LANCHOR113 = . + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.space	2
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
.LANCHOR144 = . + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.space	2
	.section	.rodata.__func__.8060,"a",%progbits
.LANCHOR127 = . + 0
	.type	__func__.8060, %object
	.size	__func__.8060, 18
__func__.8060:
	.ascii	"SupperBlkListInit\000"
	.section	.bss.g_gc_blk_num,"aw",%nobits
	.align	1
.LANCHOR142 = . + 0
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
.LANCHOR160 = . + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.space	4
	.section	.rodata.__func__.7648,"a",%progbits
.LANCHOR110 = . + 0
	.type	__func__.7648, %object
	.size	__func__.7648, 22
__func__.7648:
	.ascii	"List_update_data_list\000"
	.section	.bss.p_swl_mul_table,"aw",%nobits
	.align	2
.LANCHOR139 = . + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
.LANCHOR137 = . + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
.LANCHOR177 = . + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.data.gc_tmp_blk_bops_scan_addr,"aw",%progbits
	.align	1
.LANCHOR190 = . + 0
	.type	gc_tmp_blk_bops_scan_addr, %object
	.size	gc_tmp_blk_bops_scan_addr, 2
gc_tmp_blk_bops_scan_addr:
	.short	-1
	.section	.rodata.__func__.8315,"a",%progbits
.LANCHOR231 = . + 0
	.type	__func__.8315, %object
	.size	__func__.8315, 23
__func__.8315:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
.LANCHOR186 = . + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 4
p_vendor_region_ppn_table:
	.space	4
	.section	.bss.p_map_block_valid_page_count,"aw",%nobits
	.align	2
.LANCHOR118 = . + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
.LANCHOR175 = . + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
.LANCHOR159 = . + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
.LANCHOR101 = . + 0
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
.LANCHOR167 = . + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_totle_slc_erase_count,"aw",%nobits
	.align	2
.LANCHOR162 = . + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.rodata.__func__.7685,"a",%progbits
.LANCHOR111 = . + 0
	.type	__func__.7685, %object
	.size	__func__.7685, 26
__func__.7685:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.bss.req_gc_dst,"aw",%nobits
	.align	2
.LANCHOR174 = . + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
.LANCHOR173 = . + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
.LANCHOR195 = . + 0
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
	.section	.rodata.__func__.7427,"a",%progbits
.LANCHOR91 = . + 0
	.type	__func__.7427, %object
	.size	__func__.7427, 14
__func__.7427:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
.LANCHOR171 = . + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.space	2
	.section	.rodata.__func__.7986,"a",%progbits
.LANCHOR223 = . + 0
	.type	__func__.7986, %object
	.size	__func__.7986, 22
__func__.7986:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
.LANCHOR87 = . + 0
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
	.section	.bss.g_LowFormat,"aw",%nobits
	.align	2
.LANCHOR227 = . + 0
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
.LANCHOR92 = . + 0
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
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",%nobits
	.align	2
.LANCHOR52 = . + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.space	4
	.section	.bss.g_buffer_superblock,"aw",%nobits
	.align	2
.LANCHOR108 = . + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
.LANCHOR96 = . + 0
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
.LANCHOR130 = . + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 4
p_gc_spare_buf:
	.space	4
	.section	.bss.gFlashProgCheckBuffer,"aw",%nobits
	.align	2
.LANCHOR203 = . + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 4
gFlashProgCheckBuffer:
	.space	4
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
.LANCHOR181 = . + 0
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
.LANCHOR178 = . + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
.LANCHOR179 = . + 0
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
.LANCHOR156 = . + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
.LANCHOR155 = . + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
.LANCHOR164 = . + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.FtlUpdateVaildLpnCount,"aw",%nobits
	.align	1
.LANCHOR115 = . + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.space	2
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
.LANCHOR88 = . + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_in_gc_progress,"aw",%nobits
	.align	2
.LANCHOR165 = . + 0
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
	.section	.rodata.__func__.8151,"a",%progbits
.LANCHOR206 = . + 0
	.type	__func__.8151, %object
	.size	__func__.8151, 16
__func__.8151:
	.ascii	"update_vpc_list\000"
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
.LANCHOR103 = . + 0
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
	.section	.bss.gNandFlashIDBEccBits,"aw",%nobits
.LANCHOR45 = . + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.space	1
	.section	.bss.gNandPhyInfo,"aw",%nobits
	.align	2
.LANCHOR28 = . + 0
	.type	gNandPhyInfo, %object
	.size	gNandPhyInfo, 28
gNandPhyInfo:
	.space	28
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
.LANCHOR191 = . + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.space	12
	.section	.bss.gMultiPageReadEn,"aw",%nobits
.LANCHOR189 = . + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.space	1
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
.LANCHOR172 = . + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.space	2
	.section	.bss.g_gc_free_blk_threshold,"aw",%nobits
	.align	1
.LANCHOR170 = . + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_max_erase_count,"aw",%nobits
	.align	2
.LANCHOR163 = . + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.gVendorBlkInfo,"aw",%nobits
	.align	2
.LANCHOR213 = . + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 40
gVendorBlkInfo:
	.space	40
	.section	.bss.g_GlobalDataVersion,"aw",%nobits
	.align	2
.LANCHOR154 = . + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
.LANCHOR219 = . + 0
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
	.section	.rodata.__func__.7708,"a",%progbits
.LANCHOR211 = . + 0
	.type	__func__.7708, %object
	.size	__func__.7708, 31
__func__.7708:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
.LANCHOR129 = . + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.rodata.__func__.7953,"a",%progbits
.LANCHOR216 = . + 0
	.type	__func__.7953, %object
	.size	__func__.7953, 16
__func__.7953:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.bss.g_MaxLbaSector,"aw",%nobits
	.align	2
.LANCHOR84 = . + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
.LANCHOR94 = . + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
.LANCHOR86 = . + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 4
p_vendor_block_table:
	.space	4
	.section	.bss.p_data_block_list_head,"aw",%nobits
	.align	2
.LANCHOR98 = . + 0
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
.LANCHOR140 = . + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.space	48
	.section	.bss.g_VaildLpn,"aw",%nobits
	.align	2
.LANCHOR116 = . + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
.LANCHOR225 = . + 0
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
	.section	.rodata.__func__.7695,"a",%progbits
.LANCHOR210 = . + 0
	.type	__func__.7695, %object
	.size	__func__.7695, 15
__func__.7695:
	.ascii	"ftl_map_blk_gc\000"
	.section	.bss.IDByte,"aw",%nobits
	.align	2
.LANCHOR22 = . + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.space	32
	.section	.bss.g_gc_temp_superblock,"aw",%nobits
	.align	2
.LANCHOR109 = . + 0
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
.LANCHOR201 = . + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.space	48
	.section	.bss.g_totle_sys_slc_erase_count,"aw",%nobits
	.align	2
.LANCHOR95 = . + 0
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
	.section	.rodata.__func__.8156,"a",%progbits
.LANCHOR207 = . + 0
	.type	__func__.8156, %object
	.size	__func__.8156, 20
__func__.8156:
	.ascii	"decrement_vpc_count\000"
	.section	.bss.g_SlcPartLbaEndSector,"aw",%nobits
	.align	2
.LANCHOR151 = . + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.space	4
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
.LANCHOR157 = . + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",%nobits
	.align	1
.LANCHOR90 = . + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.space	2
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
.LANCHOR120 = . + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 40
gL2pMapInfo:
	.space	40
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
.LANCHOR168 = . + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.rodata.__func__.7338,"a",%progbits
.LANCHOR218 = . + 0
	.type	__func__.7338, %object
	.size	__func__.7338, 13
__func__.7338:
	.ascii	"FtlProgPages\000"
	.section	.bss.gFlashPageBuffer0,"aw",%nobits
	.align	2
.LANCHOR44 = . + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 4
gFlashPageBuffer0:
	.space	4
	.section	.bss.g_req_cache,"aw",%nobits
	.align	2
.LANCHOR134 = . + 0
	.type	g_req_cache, %object
	.size	g_req_cache, 4
g_req_cache:
	.space	4
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
.LANCHOR222 = . + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.bss.c_gc_page_buf_num,"aw",%nobits
	.align	2
.LANCHOR133 = . + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.space	4
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
.LANCHOR121 = . + 0
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
.LANCHOR183 = . + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.rodata.__func__.7655,"a",%progbits
.LANCHOR196 = . + 0
	.type	__func__.7655, %object
	.size	__func__.7655, 16
__func__.7655:
	.ascii	"load_l2p_region\000"
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
.LANCHOR79 = . + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.p_l2p_map_buf,"aw",%nobits
	.align	2
.LANCHOR119 = . + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 4
p_l2p_map_buf:
	.space	4
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
.LANCHOR138 = . + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
.LANCHOR107 = . + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.space	48
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
.LANCHOR148 = . + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.hidden	free
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
