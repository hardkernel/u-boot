/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-02-11
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
	.file	"rk_zftl_arm_v7.S"
	.section	.text.flash_mem_cmp8,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_mem_cmp8, %function
flash_mem_cmp8:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, r5, lr}
.L2:
	cmp	r3, r2
	bne	.L5
	movs	r0, #0
	pop	{r4, r5, pc}
.L5:
	ldrb	r5, [r0, r3]	@ zero_extendqisi2
	ldrb	r4, [r1, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r4
	beq	.L2
	mov	r0, r3
	pop	{r4, r5, pc}
	.size	flash_mem_cmp8, .-flash_mem_cmp8
	.section	.text.nand_flash_print_info,"ax",%progbits
	.align	1
	.global	nand_flash_print_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nand_flash_print_info, %function
nand_flash_print_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	nand_flash_print_info, .-nand_flash_print_info
	.section	.text.FlashTimingCfg,"ax",%progbits
	.align	1
	.global	FlashTimingCfg
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashTimingCfg, .-FlashTimingCfg
	.section	.text.timer_delay_ns,"ax",%progbits
	.align	1
	.global	timer_delay_ns
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	timer_delay_ns, %function
timer_delay_ns:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	lsrs	r0, r0, #4
	sub	sp, sp, #8
	str	r0, [sp, #4]
.L9:
	ldr	r3, [sp, #4]
	subs	r2, r3, #1
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L9
	add	sp, sp, #8
	@ sp needed
	bx	lr
	.size	timer_delay_ns, .-timer_delay_ns
	.section	.text.flash_read_status,"ax",%progbits
	.align	1
	.global	flash_read_status
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_status, %function
flash_read_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	movs	r3, #112
	mov	r1, r0
	str	r3, [r0, #8]
	movs	r0, #120
	bl	timer_delay_ns
	ldr	r0, [r1]
	uxtb	r0, r0
	pop	{r3, pc}
	.size	flash_read_status, .-flash_read_status
	.section	.text.toshiba_set_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_set_rr_para, %function
toshiba_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	add	r6, r1, r1, lsl #2
	ldr	r8, .L20+16
	mov	r5, r0
	movs	r4, #0
	ldr	r7, .L20
.L13:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L17
	pop	{r4, r5, r6, r7, r8, pc}
.L17:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r7]
	str	r3, [r5, #4]
	bl	timer_delay_ns
	ldr	r3, .L20+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L14
	adds	r3, r4, r6
	add	r3, r3, r7
.L19:
	ldrsb	r3, [r3, #5]
.L18:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L13
.L14:
	cmp	r3, #35
	bne	.L16
	ldr	r3, .L20+8
	adds	r2, r4, r6
	add	r3, r3, r2
	b	.L19
.L16:
	ldr	r3, .L20+12
	ldrsb	r3, [r3, r1]
	b	.L18
.L21:
	.align	2
.L20:
	.word	.LANCHOR0
	.word	.LANCHOR1
	.word	.LANCHOR2
	.word	.LANCHOR3
	.word	.LANCHOR4
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L25
	push	{r4, r5, r6, r7, r8, lr}
	lsls	r7, r0, #8
	ldr	r2, .L25+4
	ldr	r3, [r3]
	ldr	r5, [r2]
	movs	r2, #54
	ldrb	r4, [r3, #113]	@ zero_extendqisi2
	add	r6, r3, #127
	add	r8, r5, r7
	str	r2, [r8, #2056]
	movs	r2, #160
	muls	r1, r4, r1
	mla	r1, r2, r0, r1
	add	r1, r1, r3
	add	r3, r3, r4
	adds	r1, r1, #143
	add	r4, r3, #127
.L23:
	cmp	r6, r4
	bne	.L24
	add	r5, r5, r7
	movs	r3, #22
	str	r3, [r5, #2056]
	pop	{r4, r5, r6, r7, r8, pc}
.L24:
	ldrb	r3, [r6, #1]!	@ zero_extendqisi2
	movs	r0, #120
	str	r3, [r8, #2052]
	bl	timer_delay_ns
	ldrsb	r3, [r1, #1]!
	str	r3, [r8, #2048]
	b	.L23
.L26:
	.align	2
.L25:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	hynix_set_rr_para, .-hynix_set_rr_para
	.section	.text.hynix_reconfig_rr_para,"ax",%progbits
	.align	1
	.global	hynix_reconfig_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_reconfig_rr_para, %function
hynix_reconfig_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L32
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L27
	ldr	r5, .L32+4
	ldr	r3, [r5]
	add	r3, r3, r0
	ldrb	r3, [r3, #120]	@ zero_extendqisi2
	cbz	r3, .L27
	movs	r1, #0
	bl	hynix_set_rr_para
	ldr	r0, [r5]
	movs	r3, #0
	add	r0, r0, r4
	strb	r3, [r0, #120]
.L27:
	pop	{r3, r4, r5, pc}
.L33:
	.align	2
.L32:
	.word	.LANCHOR1
	.word	.LANCHOR5
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",%progbits
	.align	1
	.global	nandc_set_ddr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L37
	ldr	r2, .L37+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, [r2]
	cmp	r3, #9
	lsl	r3, r0, #16
	lsl	r0, r0, #8
	orr	r3, r3, r0
	orr	r3, r3, #3
	ite	eq
	streq	r3, [r2, #80]
	strne	r3, [r2, #304]
	bx	lr
.L38:
	.align	2
.L37:
	.word	.LANCHOR7
	.word	.LANCHOR6
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",%progbits
	.align	1
	.global	nandc_get_ddr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L43
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ldr	r3, .L43+4
	ldr	r3, [r3]
	ite	eq
	ldreq	r0, [r3, #80]
	ldrne	r0, [r3, #304]
	ubfx	r0, r0, #8, #8
	bx	lr
.L44:
	.align	2
.L43:
	.word	.LANCHOR7
	.word	.LANCHOR6
	.size	nandc_get_ddr_para, .-nandc_get_ddr_para
	.section	.text.nandc_set_if_mode,"ax",%progbits
	.align	1
	.global	nandc_set_if_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_if_mode, %function
nandc_set_if_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L53
	ands	r1, r0, #6
	ldr	r3, [r3]
	ldr	r2, [r3]
	beq	.L46
	lsls	r1, r0, #29
	ldr	r1, .L53+4
	orr	r2, r2, #24576
	bfc	r2, #15, #1
	ldrb	r1, [r1]	@ zero_extendqisi2
	orr	r2, r2, #196608
	it	mi
	orrmi	r2, r2, #32768
	cmp	r1, #9
	ldr	r1, .L53+8
	bne	.L48
	movw	r0, #8321
	str	r0, [r3, #8]
	str	r1, [r3, #80]
	movs	r1, #38
	str	r1, [r3, #84]
	movs	r1, #39
	str	r1, [r3, #84]
.L49:
	str	r2, [r3]
	bx	lr
.L48:
	movw	r0, #8322
	str	r0, [r3, #344]
	str	r1, [r3, #304]
	movs	r1, #38
	str	r1, [r3, #308]
	movs	r1, #39
	str	r1, [r3, #308]
	b	.L49
.L46:
	bfi	r2, r1, #13, #1
	b	.L49
.L54:
	.align	2
.L53:
	.word	.LANCHOR6
	.word	.LANCHOR7
	.word	1052675
	.size	nandc_set_if_mode, .-nandc_set_if_mode
	.section	.text.nandc_cs,"ax",%progbits
	.align	1
	.global	nandc_cs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_cs, %function
nandc_cs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L56
	movs	r2, #1
	lsl	r0, r2, r0
	ldr	r1, [r3]
	ldr	r3, [r1]
	bfi	r3, r0, #0, #8
	str	r3, [r1]
	bx	lr
.L57:
	.align	2
.L56:
	.word	.LANCHOR6
	.size	nandc_cs, .-nandc_cs
	.section	.text.nandc_de_cs,"ax",%progbits
	.align	1
	.global	nandc_de_cs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_de_cs, %function
nandc_de_cs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L59
	ldr	r2, [r3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L60:
	.align	2
.L59:
	.word	.LANCHOR6
	.size	nandc_de_cs, .-nandc_de_cs
	.section	.text.flash_wait_device_ready_raw,"ax",%progbits
	.align	1
	.global	flash_wait_device_ready_raw
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_wait_device_ready_raw, %function
flash_wait_device_ready_raw:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r1
	ldr	r3, .L70
	mov	r7, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L62
	mov	r2, #604
	ldr	r1, .L70+4
	ldr	r0, .L70+8
	bl	printf
.L63:
	b	.L63
.L62:
	ldr	r3, .L70+12
	ldrb	r6, [r3, r0]	@ zero_extendqisi2
	ldr	r3, .L70+16
	mov	r0, r6
	ldr	r4, [r3]
	bl	nandc_cs
	uxtb	r3, r5
	movs	r0, #120
	add	r4, r4, r6, lsl #8
	str	r0, [r4, #2056]
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	lsrs	r5, r5, #16
	str	r3, [r4, #2052]
	str	r5, [r4, #2052]
.L69:
	bl	timer_delay_ns
	ldr	r1, [r4, #2048]
	uxtb	r1, r1
	bics	r3, r7, r1
	bne	.L65
	cmp	r1, #255
	beq	.L65
	mov	r0, r6
	bl	nandc_de_cs
	mov	r0, r1
	pop	{r3, r4, r5, r6, r7, pc}
.L65:
	movs	r0, #20
	b	.L69
.L71:
	.align	2
.L70:
	.word	.LANCHOR8
	.word	.LANCHOR9
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.size	flash_wait_device_ready_raw, .-flash_wait_device_ready_raw
	.global	__aeabi_uidiv
	.global	__aeabi_uidivmod
	.section	.text.flash_wait_device_ready,"ax",%progbits
	.align	1
	.global	flash_wait_device_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_wait_device_ready, %function
flash_wait_device_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	tst	r0, #50331648
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r10, r1
	ubfx	r4, r0, #0, #21
	ubfx	r8, r0, #21, #3
	bne	.L73
	ldr	r3, .L82
	ldr	r6, .L82+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L74
	ldrb	r3, [r6]	@ zero_extendqisi2
	cbz	r3, .L73
.L74:
	ldr	r3, .L82+8
	mov	r0, r4
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	mul	r7, r5, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [r6]	@ zero_extendqisi2
	cbz	r3, .L75
	add	r4, r7, r1, lsl #1
.L73:
	mov	r2, r10
	mov	r1, r4
	mov	r0, r8
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	flash_wait_device_ready_raw
.L75:
	ldr	r3, .L82+12
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, r7
	b	.L73
.L83:
	.align	2
.L82:
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR14
	.size	flash_wait_device_ready, .-flash_wait_device_ready
	.section	.text.nandc_wait_flash_ready,"ax",%progbits
	.align	1
	.global	nandc_wait_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, lr}
	ldr	r1, .L89
	ldr	r4, .L89+4
.L86:
	movs	r0, #100
	bl	timer_delay_ns
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L87
	subs	r1, r1, #1
	bne	.L86
	mov	r0, #-1
.L84:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L87:
	movs	r0, #0
	b	.L84
.L90:
	.align	2
.L89:
	.word	100000
	.word	.LANCHOR6
	.size	nandc_wait_flash_ready, .-nandc_wait_flash_ready
	.section	.text.sandisk_set_rr_para,"ax",%progbits
	.align	1
	.global	sandisk_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sandisk_set_rr_para, %function
sandisk_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #239
	str	r3, [r0, #8]
	movs	r3, #17
	mov	r4, r0
	str	r3, [r0, #4]
	movs	r0, #200
	bl	timer_delay_ns
	ldr	r3, .L97
	add	r1, r1, r1, lsl #2
	ldr	r6, .L97+4
	movs	r2, #0
	ldr	r7, .L97+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, .L97+12
	ldrb	r5, [r3]	@ zero_extendqisi2
.L92:
	cmp	r2, r0
	bcc	.L95
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L95:
	adds	r3, r2, r1
	cmp	r5, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r4]
	b	.L92
.L98:
	.align	2
.L97:
	.word	.LANCHOR4
	.word	.LANCHOR2
	.word	.LANCHOR0
	.word	.LANCHOR1
	.size	sandisk_set_rr_para, .-sandisk_set_rr_para
	.section	.text.toshiba_3d_set_tlc_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_3d_set_tlc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_set_tlc_rr_para, %function
toshiba_3d_set_tlc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r6, #0
	movs	r7, #213
	mvn	r3, #118
	adds	r1, r1, #1
	mov	r4, r0
	str	r7, [r0, #8]
	rsb	r1, r1, r1, lsl #3
	str	r6, [r0, #4]
	str	r3, [r0, #4]
	ldr	r3, .L100
	adds	r5, r3, r1
	ldrsb	r3, [r3, r1]
	str	r3, [r0]
	ldrsb	r3, [r5, #1]
	str	r3, [r0]
	ldrsb	r3, [r5, #2]
	str	r3, [r0]
	ldrsb	r3, [r5, #3]
	str	r3, [r0]
	bl	nandc_wait_flash_ready
	mvn	r3, #117
	str	r7, [r4, #8]
	str	r6, [r4, #4]
	str	r3, [r4, #4]
	ldrsb	r3, [r5, #4]
	str	r3, [r4]
	ldrsb	r3, [r5, #5]
	str	r3, [r4]
	ldrsb	r3, [r5, #6]
	str	r3, [r4]
	str	r6, [r4]
	pop	{r3, r4, r5, r6, r7, lr}
	b	nandc_wait_flash_ready
.L101:
	.align	2
.L100:
	.word	.LANCHOR15
	.size	toshiba_3d_set_tlc_rr_para, .-toshiba_3d_set_tlc_rr_para
	.section	.text.toshiba_3d_set_slc_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_3d_set_slc_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_set_slc_rr_para, %function
toshiba_3d_set_slc_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, #213
	mvn	r2, #116
	str	r3, [r0, #8]
	movs	r3, #0
	str	r3, [r0, #4]
	str	r2, [r0, #4]
	ldr	r2, .L103
	add	r1, r1, r2
	ldrsb	r2, [r1, #1]
	str	r2, [r0]
	str	r3, [r0]
	str	r3, [r0]
	str	r3, [r0]
	b	nandc_wait_flash_ready
.L104:
	.align	2
.L103:
	.word	.LANCHOR16
	.size	toshiba_3d_set_slc_rr_para, .-toshiba_3d_set_slc_rr_para
	.section	.text.toshiba_tlc_set_rr_para,"ax",%progbits
	.align	1
	.global	toshiba_tlc_set_rr_para
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_tlc_set_rr_para, %function
toshiba_tlc_set_rr_para:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r6, #239
	mov	r4, r0
	str	r6, [r0, #8]
	cbz	r2, .L106
	movs	r3, #18
	rsb	r1, r1, r1, lsl #3
	str	r3, [r0, #4]
	ldr	r3, .L108
	adds	r5, r3, r1
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	str	r3, [r0]
	ldrb	r3, [r5, #3]	@ zero_extendqisi2
	str	r3, [r0]
	bl	nandc_wait_flash_ready
	movs	r3, #19
	str	r6, [r4, #8]
	str	r3, [r4, #4]
	ldrb	r3, [r5, #4]	@ zero_extendqisi2
	str	r3, [r4]
	ldrb	r3, [r5, #5]	@ zero_extendqisi2
	str	r3, [r4]
	ldrb	r3, [r5, #6]	@ zero_extendqisi2
	str	r3, [r4]
	movs	r3, #0
	str	r3, [r4]
.L107:
	pop	{r4, r5, r6, lr}
	b	nandc_wait_flash_ready
.L106:
	movs	r3, #20
	str	r3, [r0, #4]
	ldr	r3, .L108+4
	ldrb	r3, [r3, r1]	@ zero_extendqisi2
	str	r3, [r0]
	str	r2, [r0]
	str	r2, [r0]
	str	r2, [r0]
	b	.L107
.L109:
	.align	2
.L108:
	.word	.LANCHOR17
	.word	.LANCHOR18
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.flash_enter_slc_mode,"ax",%progbits
	.align	1
	.global	flash_enter_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L122
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L110
	ldr	r3, .L122+4
	cmp	r2, #1
	ldr	r3, [r3]
	bne	.L112
	ldr	r2, .L122+8
	ldrb	r2, [r2, #29]	@ zero_extendqisi2
	cbz	r2, .L110
	add	r0, r3, r0, lsl #8
	str	r2, [r0, #2056]
	bx	lr
.L112:
	cmp	r2, #2
	bne	.L110
	ldr	r1, .L122+12
	ldrb	r2, [r1]	@ zero_extendqisi2
	cbz	r2, .L110
	add	r0, r3, r0, lsl #8
	movs	r3, #239
	movs	r2, #0
	str	r3, [r0, #2056]
	movs	r3, #145
	str	r3, [r0, #2052]
	movs	r3, #1
	str	r2, [r0, #2048]
	str	r3, [r0, #2048]
	str	r2, [r0, #2048]
	str	r2, [r0, #2048]
	strb	r2, [r1]
	b	nandc_wait_flash_ready
.L110:
	bx	lr
.L123:
	.align	2
.L122:
	.word	.LANCHOR11
	.word	.LANCHOR6
	.word	.LANCHOR19
	.word	.LANCHOR20
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",%progbits
	.align	1
	.global	flash_exit_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L136
	push	{r4}
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L124
	ldr	r3, .L136+4
	cmp	r2, #1
	ldr	r3, [r3]
	bne	.L126
	ldr	r2, .L136+8
	ldrb	r2, [r2, #30]	@ zero_extendqisi2
	cbz	r2, .L124
	add	r0, r3, r0, lsl #8
	str	r2, [r0, #2056]
.L124:
	pop	{r4}
	bx	lr
.L126:
	cmp	r2, #2
	bne	.L124
	ldr	r4, .L136+12
	ldrb	r1, [r4]	@ zero_extendqisi2
	cmp	r1, #0
	bne	.L124
	ldr	r2, .L136+8
	add	r0, r3, r0, lsl #8
	movs	r3, #239
	str	r3, [r0, #2056]
	movs	r3, #145
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	str	r3, [r0, #2052]
	movs	r3, #1
	cmp	r2, #2
	it	ne
	movne	r2, #4
	str	r2, [r0, #2048]
	strb	r2, [r4]
	str	r3, [r0, #2048]
	pop	{r4}
	str	r1, [r0, #2048]
	str	r1, [r0, #2048]
	b	nandc_wait_flash_ready
.L137:
	.align	2
.L136:
	.word	.LANCHOR11
	.word	.LANCHOR6
	.word	.LANCHOR19
	.word	.LANCHOR20
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
	.section	.text.flash_erase_duplane_block,"ax",%progbits
	.align	1
	.global	flash_erase_duplane_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r1
	ldr	r1, .L154
	mov	r7, r2
	mov	r6, r3
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, r0
	bhi	.L139
	movw	r2, #517
	ldr	r1, .L154+4
	ldr	r0, .L154+8
	bl	printf
.L140:
	b	.L140
.L139:
	ldr	r1, .L154+12
	ldrb	r4, [r1, r0]	@ zero_extendqisi2
	ldr	r1, .L154+16
	add	r8, r4, #8
	ldr	r5, [r1]
	ldr	r1, .L154+20
	ldr	r1, [r1]
	add	r8, r5, r8, lsl #8
	lsls	r1, r1, #27
	bpl	.L141
	mov	r1, r4
	ldr	r0, .L154+24
	bl	printf
.L141:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	fp, #0
	bne	.L142
	bl	flash_enter_slc_mode
.L143:
	lsls	r2, r4, #8
	movs	r1, #96
	adds	r3, r5, r2
	str	r1, [r3, #2056]
	uxtb	r1, r7
	str	r1, [r3, #2052]
	lsrs	r1, r7, #8
	str	r1, [r3, #2052]
	lsrs	r1, r7, #16
	str	r1, [r3, #2052]
	ldr	r1, .L154+28
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	bne	.L147
	movs	r1, #208
	str	r2, [sp, #4]
	str	r1, [r3, #2056]
	str	r3, [sp]
	bl	nandc_wait_flash_ready
	mov	r0, r8
	bl	flash_read_status
	ldr	r3, [sp]
	and	r10, r0, #5
	ldr	r2, [sp, #4]
.L144:
	add	r5, r5, r2
	movs	r2, #96
	str	r2, [r5, #2056]
	uxtb	r2, r6
	str	r2, [r3, #2052]
	lsrs	r2, r6, #8
	lsrs	r6, r6, #16
	str	r2, [r3, #2052]
	str	r6, [r3, #2052]
	movs	r3, #208
	str	r3, [r5, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r8
	bl	flash_read_status
	mov	r5, r0
	cmp	fp, #0
	bne	.L145
	mov	r0, r4
	bl	flash_exit_slc_mode
.L145:
	mov	r0, r4
	bl	nandc_de_cs
	and	r0, r5, #5
	orrs	r10, r0, r10
	beq	.L146
	mov	r2, r5
	mov	r1, r7
	ldr	r0, .L154+32
	bl	printf
.L146:
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L142:
	bl	flash_exit_slc_mode
	b	.L143
.L147:
	mov	r10, #0
	b	.L144
.L155:
	.align	2
.L154:
	.word	.LANCHOR8
	.word	.LANCHOR21
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR22
	.word	.LC1
	.word	.LANCHOR23
	.word	.LC2
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",%progbits
	.align	1
	.global	flash_erase_block_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L170
	push	{r4, r5, r6, r7, r8, lr}
	mov	r8, r1
	mov	r6, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L157
	movw	r2, #561
	ldr	r1, .L170+4
	ldr	r0, .L170+8
	bl	printf
.L158:
	b	.L158
.L157:
	ldr	r3, .L170+12
	ldrb	r4, [r3, r0]	@ zero_extendqisi2
	ldr	r3, .L170+16
	add	r7, r4, #8
	ldr	r5, [r3]
	ldr	r3, .L170+20
	ldr	r3, [r3]
	add	r7, r5, r7, lsl #8
	lsls	r3, r3, #27
	bpl	.L159
	mov	r1, r4
	ldr	r0, .L170+24
	bl	printf
.L159:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	bl	nandc_cs
	mov	r0, r4
	cmp	r8, #0
	bne	.L160
	bl	flash_enter_slc_mode
.L161:
	add	r3, r5, r4, lsl #8
	movs	r1, #96
	ubfx	r2, r6, #0, #21
	str	r1, [r3, #2056]
	uxtb	r1, r6
	str	r1, [r3, #2052]
	lsrs	r1, r2, #8
	lsrs	r2, r2, #16
	str	r1, [r3, #2052]
	str	r2, [r3, #2052]
	movs	r2, #208
	str	r2, [r3, #2056]
	bl	nandc_wait_flash_ready
	mov	r0, r7
	bl	flash_read_status
	mov	r5, r0
	cmp	r8, #0
	bne	.L162
	mov	r0, r4
	bl	flash_exit_slc_mode
.L162:
	mov	r0, r4
	bl	nandc_de_cs
	ands	r5, r5, #5
	beq	.L163
	ldr	r3, .L170+28
	mov	r0, r6
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	mov	r2, r5
	mov	r1, r0
	ldr	r0, .L170+32
	bl	printf
.L163:
	mov	r0, r5
	pop	{r4, r5, r6, r7, r8, pc}
.L160:
	bl	flash_exit_slc_mode
	b	.L161
.L171:
	.align	2
.L170:
	.word	.LANCHOR8
	.word	.LANCHOR24
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR22
	.word	.LC3
	.word	.LANCHOR13
	.word	.LC4
	.size	flash_erase_block_en, .-flash_erase_block_en
	.section	.text.flash_erase_block,"ax",%progbits
	.align	1
	.global	flash_erase_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_block, %function
flash_erase_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, r1
	movs	r1, #0
	b	flash_erase_block_en
	.size	flash_erase_block, .-flash_erase_block
	.section	.text.flash_erase_all,"ax",%progbits
	.align	1
	.global	flash_erase_all
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_erase_all, %function
flash_erase_all:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L178
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L178+4
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	smulbb	r4, r4, r3
	uxth	r4, r4
.L174:
	ldr	r3, .L178+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L177
	movs	r1, #0
	ldr	r0, .L178+12
	pop	{r4, r5, r6, r7, r8, lr}
	b	printf
.L177:
	ldr	r2, .L178+16
	uxth	r3, r5
	movs	r6, #0
	ldrb	r8, [r2, r3]	@ zero_extendqisi2
.L175:
	uxth	r3, r6
	cmp	r4, r3
	bhi	.L176
	adds	r5, r5, #1
	b	.L174
.L176:
	ldrh	r1, [r7]
	mov	r0, r8
	muls	r1, r6, r1
	adds	r6, r6, #1
	bl	flash_erase_block
	b	.L175
.L179:
	.align	2
.L178:
	.word	.LANCHOR19
	.word	.LANCHOR13
	.word	.LANCHOR8
	.word	.LC5
	.word	.LANCHOR10
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_set_interface_mode,"ax",%progbits
	.align	1
	.global	flash_set_interface_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L202
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #239
	ldr	ip, .L202+8
	movs	r7, #128
	mov	lr, #1
	mov	r8, #35
	ldr	r5, [r3]
	mov	r10, #5
	ldr	r3, .L202+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	and	r2, r3, #4
	and	r3, r3, #1
	str	r3, [sp]
	movs	r3, #0
	str	r2, [sp, #4]
	mov	r2, r3
.L188:
	ldrb	r4, [ip, r3, lsl #3]	@ zero_extendqisi2
	cmp	r4, #152
	beq	.L181
	cmp	r4, #69
	beq	.L181
	cmp	r4, #44
	bne	.L182
.L181:
	cmp	r0, #1
	bne	.L183
	ldr	r1, [sp]
	cbz	r1, .L182
	lsls	r1, r3, #8
	cmp	r4, #44
	add	fp, r5, r1
	str	r6, [fp, #2056]
	itete	eq
	streq	r0, [fp, #2052]
	strne	r7, [fp, #2052]
	streq	r10, [fp, #2048]
	strne	r0, [fp, #2048]
.L187:
	add	r1, r1, r5
	str	r2, [r1, #2048]
	str	r2, [r1, #2048]
	str	r2, [r1, #2048]
.L182:
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L188
	bl	nandc_wait_flash_ready
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L183:
	ldr	r1, [sp, #4]
	cmp	r1, #0
	beq	.L182
	lsls	r1, r3, #8
	cmp	r4, #44
	add	fp, r5, r1
	str	r6, [fp, #2056]
	itete	eq
	streq	lr, [fp, #2052]
	strne	r7, [fp, #2052]
	streq	r8, [fp, #2048]
	strne	r2, [fp, #2048]
	b	.L187
.L203:
	.align	2
.L202:
	.word	.LANCHOR6
	.word	.LANCHOR25
	.word	.LANCHOR26
	.size	flash_set_interface_mode, .-flash_set_interface_mode
	.section	.text.flash_reset,"ax",%progbits
	.align	1
	.global	flash_reset
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_reset, %function
flash_reset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L205
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	movs	r3, #255
	str	r3, [r0, #2056]
	b	nandc_wait_flash_ready
.L206:
	.align	2
.L205:
	.word	.LANCHOR6
	.size	flash_reset, .-flash_reset
	.section	.text.flash_read_id,"ax",%progbits
	.align	1
	.global	flash_read_id
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_id, %function
flash_read_id:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L208
	push	{r4, r5, r6, lr}
	mov	r6, r0
	mov	r5, r1
	ldr	r4, [r3]
	bl	flash_reset
	mov	r0, r6
	bl	nandc_cs
	add	r4, r4, r6, lsl #8
	movs	r3, #144
	movs	r0, #200
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	bl	timer_delay_ns
	ldr	r3, [r4, #2048]
	mov	r0, r6
	strb	r3, [r5]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #1]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #2]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #3]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #4]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #5]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #6]
	ldr	r3, [r4, #2048]
	strb	r3, [r5, #7]
	pop	{r4, r5, r6, lr}
	b	nandc_de_cs
.L209:
	.align	2
.L208:
	.word	.LANCHOR6
	.size	flash_read_id, .-flash_read_id
	.section	.text.flash_read_spare,"ax",%progbits
	.align	1
	.global	flash_read_spare
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_spare, %function
flash_read_spare:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r5, r2
	ldr	r3, .L211
	ldr	r2, .L211+4
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	ldr	r4, [r2]
	movs	r2, #0
	lsls	r3, r3, #9
	add	r4, r4, r0, lsl #8
	str	r2, [r4, #2056]
	str	r3, [r4, #2052]
	lsrs	r3, r3, #8
	str	r3, [r4, #2052]
	uxtb	r3, r1
	str	r3, [r4, #2052]
	lsrs	r3, r1, #8
	lsrs	r1, r1, #16
	str	r3, [r4, #2052]
	movs	r3, #48
	str	r1, [r4, #2052]
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #2048]
	strb	r3, [r5]
	pop	{r3, r4, r5, pc}
.L212:
	.align	2
.L211:
	.word	.LANCHOR19
	.word	.LANCHOR6
	.size	flash_read_spare, .-flash_read_spare
	.section	.text.sandisk_prog_test_bad_block,"ax",%progbits
	.align	1
	.global	sandisk_prog_test_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sandisk_prog_test_bad_block, %function
sandisk_prog_test_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	lsls	r0, r0, #8
	ldr	r3, .L220
	ldr	r5, .L220+4
	ldr	r4, [r3]
	ldrb	r3, [r5, #29]	@ zero_extendqisi2
	cbz	r3, .L214
	adds	r2, r4, r0
	str	r3, [r2, #2056]
.L215:
	add	r4, r4, r0
	movs	r3, #128
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r1
	str	r3, [r4, #2052]
	lsrs	r3, r1, #8
	lsrs	r1, r1, #16
	str	r3, [r4, #2052]
	movs	r3, #16
	str	r1, [r4, #2052]
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	movs	r3, #112
	movs	r0, #80
	str	r3, [r4, #2056]
	bl	timer_delay_ns
	ldrb	r3, [r5, #30]	@ zero_extendqisi2
	ldr	r0, [r4, #2048]
	and	r0, r0, #5
	cbz	r3, .L213
	str	r3, [r4, #2056]
.L213:
	pop	{r3, r4, r5, pc}
.L214:
	adds	r3, r4, r0
	movs	r2, #162
	str	r2, [r3, #2056]
	b	.L215
.L221:
	.align	2
.L220:
	.word	.LANCHOR6
	.word	.LANCHOR19
	.size	sandisk_prog_test_bad_block, .-sandisk_prog_test_bad_block
	.section	.text.nandc_bch_sel,"ax",%progbits
	.align	1
	.global	nandc_bch_sel
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_bch_sel, %function
nandc_bch_sel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r1, .L236
	movs	r2, #0
	push	{r4, lr}
	movs	r3, #1
	strb	r0, [r1]
	ldr	r1, .L236+4
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #9
	ldr	r1, .L236+8
	ldr	r1, [r1]
	bne	.L223
	cmp	r0, #70
	str	r3, [r1, #16]
	beq	.L224
	cmp	r0, #60
	beq	.L231
	cmp	r0, #40
	ite	eq
	moveq	r2, #2
	movne	r2, r3
.L224:
	lsls	r3, r2, #25
	orr	r3, r3, #1
	str	r3, [r1, #32]
	pop	{r4, pc}
.L231:
	movs	r2, #3
	b	.L224
.L223:
	movs	r4, #16
	str	r3, [r1, #8]
	cmp	r0, r4
	mov	r3, r2
	bfi	r3, r4, #8, #8
	bfi	r3, r2, #18, #1
	bne	.L226
.L229:
	bfc	r3, #4, #1
.L227:
	orr	r3, r3, #1
	str	r3, [r1, #12]
	pop	{r4, pc}
.L226:
	cmp	r0, #24
	bne	.L228
	orr	r3, r3, #16
	b	.L227
.L228:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L227
	b	.L229
.L237:
	.align	2
.L236:
	.word	.LANCHOR27
	.word	.LANCHOR7
	.word	.LANCHOR6
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.NandCIrqEnable,"ax",%progbits
	.align	1
	.global	NandCIrqEnable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_get_irq_status, %function
rk_nandc_get_irq_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L243
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	ite	eq
	ldreq	r0, [r0, #296]
	ldrne	r0, [r0, #372]
	bx	lr
.L244:
	.align	2
.L243:
	.word	.LANCHOR7
	.size	rk_nandc_get_irq_status, .-rk_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_flash_xfer_completed, %function
rk_nandc_flash_xfer_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_xfer_completed, .-rk_nandc_flash_xfer_completed
	.section	.text.nandc_xfer_start,"ax",%progbits
	.align	1
	.global	nandc_xfer_start
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer_start, %function
nandc_xfer_start:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	ldr	r0, .L264
	adds	r6, r1, #1
	ldr	r5, .L264+4
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r10, .L264+24
	cmp	r0, #9
	bne	.L249
	movs	r4, #0
	movs	r1, #1
	bfi	r4, r7, #1, #1
	asrs	r6, r6, r1
	orr	r4, r4, #8
	bfi	r4, r1, #5, #2
	ldr	r1, .L264+8
	orr	r4, r4, #536870912
	orr	r4, r4, #1024
	ldrb	r1, [r1]	@ zero_extendqisi2
	bfc	r4, #4, #1
	bfi	r4, r6, #22, #6
	cbz	r1, .L250
	ldr	r1, .L264+12
	ldrb	r1, [r1]	@ zero_extendqisi2
	cbz	r1, .L250
	orr	r4, r4, #512
.L250:
	add	r1, r2, #63
	and	r6, r6, #63
	bic	r1, r1, #63
	bic	r0, r2, #63
	add	r1, r1, r6, lsl #10
	str	r2, [r5, #4]
	str	r3, [r5, #8]
	clz	r7, r7
	str	r2, [r5, #12]
	lsrs	r7, r7, #5
	str	r3, [r5, #16]
	bl	flush_dcache_range
	ldr	r0, [r5, #8]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	add	r1, r1, r6, lsl #2
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r10]
	str	r3, [r5, #20]
	movs	r1, #16
	ldr	r3, [r5, #12]
	str	r3, [r2, #52]
	ldr	r3, [r5, #16]
	str	r3, [r2, #56]
	ldr	r3, [r2, #48]
	bfi	r3, r1, #9, #5
	movs	r1, #2
	orr	r3, r3, #448
	bfi	r3, r1, #3, #3
	ldr	r1, .L264+16
	orr	r3, r3, #4
	bfi	r3, r7, #1, #1
	ldrh	r1, [r1]
	orr	r3, r3, #1
	bfi	r3, r1, #16, #11
	str	r3, [r2, #48]
	str	r4, [r2, #16]
	orr	r4, r4, #4
	str	r4, [r2, #16]
.L248:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L249:
	ldr	r0, [r10]
	movs	r4, #0
	bfi	r4, r7, #1, #1
	orr	r4, r4, #8
	ldr	r8, [r0, #12]
	movs	r0, #16
	bfi	r8, r0, #8, #8
	movs	r0, #1
	bfi	r4, r0, #5, #2
	asrs	r6, r6, r0
	orr	r4, r4, #536870912
	orr	r4, r4, #1024
	bfc	r8, #3, #1
	bfc	r4, #4, #1
	bfc	r8, #5, #3
	str	r6, [sp]
	bfi	r4, r6, #22, #6
	cmp	r7, #0
	beq	.L252
	ldr	r0, .L264+20
	lsrs	r1, r1, #1
	str	r1, [sp, #8]
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldr	r1, [r5]
	cmp	r0, #24
	ite	hi
	movhi	r0, #128
	movls	r0, #64
	str	r1, [sp, #12]
	movs	r1, #0
	str	r0, [sp, #4]
	mov	r0, r1
.L254:
	ldr	r6, [sp, #4]
	add	fp, r3, r0, lsl #2
	add	lr, r6, r1
	ldr	r6, [sp, #8]
	cmp	r0, r6
	blt	.L255
.L256:
	ldr	r3, [r5]
	add	r1, r2, #63
	bic	r1, r1, #63
	bic	r0, r2, #63
	str	r2, [r5, #4]
	clz	r7, r7
	str	r3, [r5, #8]
	lsrs	r7, r7, #5
	str	r3, [r5, #16]
	ldr	r3, [sp]
	str	r2, [r5, #12]
	and	r6, r3, #63
	add	r1, r1, r6, lsl #10
	bl	flush_dcache_range
	ldr	r0, [r5, #8]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	add	r1, r1, r6, lsl #7
	bl	flush_dcache_range
	movs	r3, #1
	ldr	r2, [r10]
	str	r3, [r5, #20]
	movs	r1, #16
	ldr	r3, [r5, #12]
	str	r3, [r2, #20]
	ldr	r3, [r5, #16]
	str	r3, [r2, #24]
	movs	r3, #0
	bfi	r3, r1, #9, #5
	movs	r1, #2
	orr	r3, r3, #448
	bfi	r3, r1, #3, #3
	orr	r3, r3, #4
	bfi	r3, r7, #1, #1
	orr	r3, r3, #1
	str	r3, [r2, #16]
	str	r8, [r2, #12]
	str	r4, [r2, #8]
	orr	r4, r4, #4
	str	r4, [r2, #8]
	b	.L248
.L255:
	ldrh	ip, [r3, r0, lsl #2]
	bic	r1, r1, #3
	ldrh	fp, [fp, #2]
	adds	r0, r0, #1
	ldr	r6, [sp, #12]
	orr	ip, ip, fp, lsl #16
	str	ip, [r6, r1]
	mov	r1, lr
	b	.L254
.L252:
	ldr	r3, [r5]
	str	r0, [r3]
	b	.L256
.L265:
	.align	2
.L264:
	.word	.LANCHOR7
	.word	.LANCHOR30
	.word	.LANCHOR28
	.word	.LANCHOR29
	.word	.LANCHOR31
	.word	.LANCHOR27
	.word	.LANCHOR6
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",%progbits
	.align	1
	.global	nandc_set_seed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_set_seed, %function
nandc_set_seed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L273
	and	r0, r0, #127
	ldr	r3, .L273+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r2, .L267
	orr	r3, r3, #-1073741824
.L267:
	ldr	r2, .L273+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #9
	ldr	r2, .L273+12
	ldr	r2, [r2]
	ite	eq
	streq	r3, [r2, #520]
	strne	r3, [r2, #336]
	bx	lr
.L274:
	.align	2
.L273:
	.word	.LANCHOR29
	.word	.LANCHOR32
	.word	.LANCHOR7
	.word	.LANCHOR6
	.size	nandc_set_seed, .-nandc_set_seed
	.section	.text.flash_start_page_read,"ax",%progbits
	.align	1
	.global	flash_start_page_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_page_read, %function
flash_start_page_read:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ubfx	r3, r1, #21, #3
	ldr	r2, .L293
	str	r0, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L276
	movw	r2, #738
	ldr	r1, .L293+4
	ldr	r0, .L293+8
	bl	printf
.L277:
	b	.L277
.L276:
	ldr	r2, .L293+12
	ubfx	r5, r1, #24, #2
	ubfx	r4, r1, #0, #21
	ldr	r10, .L293+36
	ldrb	r7, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L293+16
	mov	r0, r7
	ldr	r6, [r3]
	lsl	fp, r7, #8
	bl	nandc_cs
	cmp	r5, #0
	bne	.L278
	ldr	r3, .L293+20
	ldr	r2, .L293+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L279
	ldrb	r3, [r2]	@ zero_extendqisi2
	cbz	r3, .L280
.L279:
	ldr	r3, .L293+28
	mov	r0, r4
	str	r2, [sp, #12]
	ldrh	r8, [r3]
	mov	r1, r8
	bl	__aeabi_uidiv
	mul	r3, r8, r0
	mov	r1, r8
	mov	r0, r4
	str	r3, [sp, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L281
	add	r4, r3, r1, lsl #1
.L280:
	mov	r0, r7
	bl	flash_enter_slc_mode
	b	.L282
.L281:
	ldr	r2, .L293+32
	ldrh	r4, [r2, r1, lsl #1]
	add	r4, r4, r3
.L282:
	add	r6, r6, fp
	movs	r3, #0
	str	r3, [r6, #2056]
	str	r3, [r6, #2052]
	str	r3, [r6, #2052]
	uxtb	r3, r4
	str	r3, [r6, #2052]
	lsrs	r3, r4, #8
	str	r3, [r6, #2052]
	lsrs	r3, r4, #16
	str	r3, [r6, #2052]
	ldr	r3, [sp, #4]
	str	r3, [r6, #2056]
	ldr	r3, [r10]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L284
	cbz	r5, .L284
	add	r4, r4, r4, lsl #1
	subs	r5, r5, #1
	adds	r0, r4, r5
.L292:
	bl	nandc_set_seed
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs
.L278:
	ldr	r3, [r10]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L283
	add	r3, r6, fp
	str	r5, [r3, #2056]
	b	.L282
.L283:
	mov	r0, r7
	bl	flash_exit_slc_mode
	b	.L282
.L284:
	mov	r0, r4
	b	.L292
.L294:
	.align	2
.L293:
	.word	.LANCHOR8
	.word	.LANCHOR33
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LANCHOR34
	.size	flash_start_page_read, .-flash_start_page_read
	.section	.text.FlashDeInit,"ax",%progbits
	.align	1
	.global	FlashDeInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashDeInit, %function
FlashDeInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L307
	bl	nandc_wait_flash_ready
	movs	r0, #0
	bl	hynix_reconfig_rr_para
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L296
	ldr	r3, .L307+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L296
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L296:
	ldr	r1, .L307+8
	ldrb	r3, [r1]	@ zero_extendqisi2
	cbz	r3, .L297
	movs	r0, #0
	strb	r0, [r1]
	bl	nandc_set_seed
	movs	r3, #1
	strb	r3, [r1]
.L297:
	movs	r0, #0
	pop	{r4, pc}
.L308:
	.align	2
.L307:
	.word	.LANCHOR35
	.word	.LANCHOR25
	.word	.LANCHOR29
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.nandc_randomizer_enable,"ax",%progbits
	.align	1
	.global	nandc_randomizer_enable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_randomizer_enable, %function
nandc_randomizer_enable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L310
	strb	r0, [r3]
	bx	lr
.L311:
	.align	2
.L310:
	.word	.LANCHOR29
	.size	nandc_randomizer_enable, .-nandc_randomizer_enable
	.section	.text.nandc_get_chip_if,"ax",%progbits
	.align	1
	.global	nandc_get_chip_if
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_get_chip_if, %function
nandc_get_chip_if:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L313
	adds	r0, r0, #8
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #8
	bx	lr
.L314:
	.align	2
.L313:
	.word	.LANCHOR6
	.size	nandc_get_chip_if, .-nandc_get_chip_if
	.section	.text.buf_reinit,"ax",%progbits
	.align	1
	.global	buf_reinit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_reinit, %function
buf_reinit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L318
	movs	r2, #0
	push	{r4, r5, lr}
	mov	r1, r2
	mov	r4, r3
.L316:
	uxtb	r0, r2
	adds	r2, r2, #1
	cmp	r2, #32
	strb	r1, [r3, #2]
	add	r5, r0, #1
	strb	r0, [r3, #1]
	strb	r5, [r3]
	add	r3, r3, #48
	str	r1, [r3, #-40]
	bne	.L316
	movs	r3, #255
	strb	r3, [r4, #1488]
	ldr	r3, .L318+4
	strb	r1, [r3]
	ldr	r3, .L318+8
	strb	r2, [r3]
	pop	{r4, r5, pc}
.L319:
	.align	2
.L318:
	.word	.LANCHOR36
	.word	.LANCHOR37
	.word	.LANCHOR38
	.size	buf_reinit, .-buf_reinit
	.section	.text.buf_add_tail,"ax",%progbits
	.align	1
	.global	buf_add_tail
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_add_tail, %function
buf_add_tail:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #255
	push	{r4, lr}
	strb	r3, [r1]
	ldrb	r2, [r0]	@ zero_extendqisi2
	cmp	r2, r3
	bne	.L321
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L322
	movs	r2, #74
	ldr	r1, .L329
	ldr	r0, .L329+4
	bl	printf
.L323:
	b	.L323
.L322:
	strb	r3, [r0]
	pop	{r4, pc}
.L325:
	muls	r3, r0, r3
	strb	r2, [r4, r3]
	pop	{r4, pc}
.L321:
	ldr	r4, .L329+8
	movs	r3, #48
.L328:
	mov	r0, r2
	muls	r2, r3, r2
	ldrb	r2, [r4, r2]	@ zero_extendqisi2
	cmp	r2, #255
	bne	.L328
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	cmp	r2, #255
	bne	.L325
	movs	r2, #81
	ldr	r1, .L329
	ldr	r0, .L329+4
	bl	printf
.L326:
	b	.L326
.L330:
	.align	2
.L329:
	.word	.LANCHOR39
	.word	.LC0
	.word	.LANCHOR36
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.buf_free,"ax",%progbits
	.align	1
	.global	buf_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_free, %function
buf_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r1, r0
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	and	r3, r3, #8
	strb	r3, [r0, #2]
	cbz	r3, .L332
	ldr	r0, .L334
	bl	buf_add_tail
.L333:
	ldr	r2, .L334+4
	ldrb	r3, [r2]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2]
	pop	{r3, pc}
.L332:
	ldr	r3, .L334
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r0]
	ldrb	r2, [r0, #1]	@ zero_extendqisi2
	strb	r2, [r3]
	b	.L333
.L335:
	.align	2
.L334:
	.word	.LANCHOR37
	.word	.LANCHOR38
	.size	buf_free, .-buf_free
	.section	.text.buf_alloc,"ax",%progbits
	.align	1
	.global	buf_alloc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_alloc, %function
buf_alloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r2, r0
	ldr	r7, .L342
	ldrb	r1, [r7]	@ zero_extendqisi2
	cbnz	r1, .L337
	movs	r2, #121
	ldr	r1, .L342+4
	ldr	r0, .L342+8
	bl	printf
.L338:
	b	.L338
.L337:
	ldr	r5, .L342+12
	ldr	r3, .L342+16
	ldrb	r6, [r5]	@ zero_extendqisi2
	add	r0, r6, r6, lsl #1
	add	r0, r3, r0, lsl #4
	cbnz	r2, .L339
	cmp	r1, #1
	beq	.L341
.L339:
	movs	r2, #48
	subs	r1, r1, #1
	muls	r2, r6, r2
	strb	r1, [r7]
	movs	r1, #1
	adds	r4, r3, r2
	ldrb	r6, [r3, r2]	@ zero_extendqisi2
	strb	r1, [r4, #2]
	movs	r1, #255
	strb	r1, [r3, r2]
	mov	r3, #-1
	str	r3, [r4, #20]
	movs	r3, #0
	strb	r6, [r5]
	strh	r3, [r4, #34]	@ movhi
	str	r3, [r4, #8]
	pop	{r3, r4, r5, r6, r7, pc}
.L341:
	mov	r0, r2
	pop	{r3, r4, r5, r6, r7, pc}
.L343:
	.align	2
.L342:
	.word	.LANCHOR38
	.word	.LANCHOR40
	.word	.LC0
	.word	.LANCHOR37
	.word	.LANCHOR36
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",%progbits
	.align	1
	.global	buf_remove_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_remove_buf, %function
buf_remove_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldrb	r4, [r1, #1]	@ zero_extendqisi2
	ldrb	r3, [r0]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L345
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0]
.L350:
	movs	r0, #1
	pop	{r4, r5, pc}
.L348:
	mov	r5, r3
	muls	r3, r2, r3
	ldrb	r3, [r0, r3]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L347
	muls	r2, r5, r2
	ldrb	r3, [r1]	@ zero_extendqisi2
	strb	r3, [r0, r2]
	movs	r3, #255
	strb	r3, [r1]
	b	.L350
.L345:
	ldr	r0, .L351
	movs	r2, #48
.L347:
	cmp	r3, #255
	bne	.L348
	movs	r0, #0
	pop	{r4, r5, pc}
.L352:
	.align	2
.L351:
	.word	.LANCHOR36
	.size	buf_remove_buf, .-buf_remove_buf
	.section	.text.buf_remove_free,"ax",%progbits
	.align	1
	.global	buf_remove_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_remove_free, %function
buf_remove_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r5, .L357
	ldrb	r3, [r5]	@ zero_extendqisi2
	cbnz	r3, .L354
	movs	r2, #170
	ldr	r1, .L357+4
	ldr	r0, .L357+8
	bl	printf
.L355:
	b	.L355
.L354:
	mov	r1, r0
	ldr	r0, .L357+12
	bl	buf_remove_buf
	cmp	r0, #1
	bne	.L353
	ldrb	r3, [r5]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r5]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #1
	strb	r3, [r4, #2]
.L353:
	pop	{r3, r4, r5, pc}
.L358:
	.align	2
.L357:
	.word	.LANCHOR38
	.word	.LANCHOR41
	.word	.LC0
	.word	.LANCHOR37
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",%progbits
	.align	1
	.global	flash_check_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L360
	push	{r4, lr}
	lsrs	r4, r1, #5
	and	r1, r1, #31
	ldrb	r3, [r2, #13]	@ zero_extendqisi2
	ldrh	r2, [r2, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L360+4
	uxth	r3, r3
	ldr	r2, [r2]
	adds	r3, r3, #31
	asrs	r3, r3, #5
	add	r2, r2, r4, lsl #2
	lsls	r3, r3, #2
	uxth	r3, r3
	mla	r0, r0, r3, r2
	ldr	r0, [r0, #912]
	lsrs	r0, r0, r1
	and	r0, r0, #1
	pop	{r4, pc}
.L361:
	.align	2
.L360:
	.word	.LANCHOR19
	.word	.LANCHOR5
	.size	flash_check_bad_block, .-flash_check_bad_block
	.section	.text.flash_mask_bad_block,"ax",%progbits
	.align	1
	.global	flash_mask_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_mask_bad_block, %function
flash_mask_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L363
	mov	r2, r1
	push	{r4, r5, r6, lr}
	mov	r5, r0
	mov	r6, r1
	mov	r1, r0
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	ldr	r0, .L363+4
	smulbb	r4, r4, r3
	bl	printf
	uxth	r4, r4
	ldr	r3, .L363+8
	add	r0, r4, #31
	asrs	r0, r0, #5
	ldr	r2, [r3]
	movs	r3, #1
	lsls	r0, r0, #2
	uxth	r0, r0
	muls	r0, r5, r0
	lsrs	r5, r6, #5
	and	r6, r6, #31
	lsl	r6, r3, r6
	add	r0, r0, #912
	add	r0, r0, r5, lsl #2
	ldr	r3, [r2, r0]
	orrs	r3, r3, r6
	str	r3, [r2, r0]
	pop	{r4, r5, r6, pc}
.L364:
	.align	2
.L363:
	.word	.LANCHOR19
	.word	.LC6
	.word	.LANCHOR5
	.size	flash_mask_bad_block, .-flash_mask_bad_block
	.section	.text.ftl_gc_write_buf,"ax",%progbits
	.align	1
	.global	ftl_gc_write_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_gc_write_buf, %function
ftl_gc_write_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r1, r0
	ldrb	r3, [r0, #2]	@ zero_extendqisi2
	orr	r3, r3, #2
	strb	r3, [r0, #2]
	ldr	r0, .L366
	bl	buf_add_tail
	ldr	r3, .L366+4
	ldrb	r0, [r3]	@ zero_extendqisi2
	adds	r0, r0, #1
	uxtb	r0, r0
	strb	r0, [r3]
	pop	{r3, pc}
.L367:
	.align	2
.L366:
	.word	.LANCHOR42
	.word	.LANCHOR43
	.size	ftl_gc_write_buf, .-ftl_gc_write_buf
	.section	.text.ftl_write_buf,"ax",%progbits
	.align	1
	.global	ftl_write_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_buf, %function
ftl_write_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	cbnz	r0, .L369
	movw	r2, #539
	ldr	r1, .L375
	ldr	r0, .L375+4
	bl	printf
.L370:
	b	.L370
.L369:
	ldr	r2, .L375+8
	ldrb	r3, [r0, #40]	@ zero_extendqisi2
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bcs	.L371
	mov	r2, #544
	ldr	r1, .L375
	ldr	r0, .L375+4
	bl	printf
.L372:
	b	.L372
.L371:
	ldr	r5, .L375+12
	cbnz	r3, .L373
	bl	buf_free
	ldrb	r0, [r5]	@ zero_extendqisi2
	pop	{r3, r4, r5, pc}
.L373:
	mov	r1, r0
	ldr	r0, .L375+16
	bl	buf_add_tail
	ldr	r3, .L375+20
	ldrb	r1, [r4, #40]	@ zero_extendqisi2
	ldrb	r0, [r5]	@ zero_extendqisi2
	ldr	r3, [r3]
	adds	r0, r0, #1
	ldr	r2, [r3, #16]
	uxtb	r0, r0
	strb	r0, [r5]
	add	r2, r2, r1
	str	r2, [r3, #16]
	ldr	r2, [r3, #32]
	adds	r2, r2, #1
	str	r2, [r3, #32]
	pop	{r3, r4, r5, pc}
.L376:
	.align	2
.L375:
	.word	.LANCHOR44
	.word	.LC0
	.word	.LANCHOR45
	.word	.LANCHOR43
	.word	.LANCHOR42
	.word	.LANCHOR46
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_cache_flush,"ax",%progbits
	.align	1
	.global	ftl_cache_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_cache_flush, %function
ftl_cache_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	ftl_cache_flush, .-ftl_cache_flush
	.section	.text.ftl_read_buf,"ax",%progbits
	.align	1
	.global	ftl_read_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_buf, %function
ftl_read_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r3, .L389
	ldr	r3, [r3]
	cmp	r3, r0
	bhi	.L379
	movw	r2, #771
	ldr	r1, .L389+4
	ldr	r0, .L389+8
	bl	printf
.L380:
	b	.L380
.L379:
	ldr	r3, .L389+12
	movs	r4, #0
	mov	r5, r3
.L383:
	ldr	r2, [r3, #20]
	cmp	r0, r2
	bne	.L381
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	tst	r2, #8
	beq	.L381
	movs	r3, #48
	mla	r4, r3, r4, r5
	orr	r3, r2, #4
	strb	r3, [r4, #2]
	lsls	r3, r2, #31
	bmi	.L378
	mov	r0, r4
	bl	buf_remove_free
.L378:
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L381:
	adds	r4, r4, #1
	adds	r3, r3, #48
	cmp	r4, #32
	bne	.L383
	ldr	r3, .L389+16
	movs	r4, #0
	ldr	r2, [r3]
	adds	r2, r2, #1
	ittt	eq
	streq	r0, [r3]
	ldreq	r3, .L389+20
	streq	r1, [r3]
	b	.L378
.L390:
	.align	2
.L389:
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LC0
	.word	.LANCHOR36
	.word	.LANCHOR49
	.word	.LANCHOR50
	.size	ftl_read_buf, .-ftl_read_buf
	.section	.text.ftl_read_buf_free,"ax",%progbits
	.align	1
	.global	ftl_read_buf_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_buf_free, %function
ftl_read_buf_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r1, r0
	mov	r4, r0
	ldr	r0, .L395
	bl	buf_remove_buf
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	lsls	r2, r3, #30
	bpl	.L392
	bic	r3, r3, #4
	strb	r3, [r4, #2]
	pop	{r4, pc}
.L392:
	mov	r0, r4
	pop	{r4, lr}
	b	buf_free
.L396:
	.align	2
.L395:
	.word	.LANCHOR51
	.size	ftl_read_buf_free, .-ftl_read_buf_free
	.section	.text.ftl_get_density,"ax",%progbits
	.align	1
	.global	ftl_get_density
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_density, %function
ftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cbnz	r0, .L398
	ldr	r3, .L401
	ldr	r0, [r3]
	bx	lr
.L398:
	cmp	r0, #4
	ite	cc
	movcc	r0, #8192
	movcs	r0, #0
	bx	lr
.L402:
	.align	2
.L401:
	.word	.LANCHOR52
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.gc_hook,"ax",%progbits
	.align	1
	.global	gc_hook
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_hook, %function
gc_hook:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	gc_hook, .-gc_hook
	.section	.text.FtlGetCurEraseBlock,"ax",%progbits
	.align	1
	.global	FtlGetCurEraseBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L405
	ldrh	r0, [r3]
	bx	lr
.L406:
	.align	2
.L405:
	.word	.LANCHOR53
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",%progbits
	.align	1
	.global	FtlGetAllBlockNum
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L408
	ldrh	r0, [r3]
	bx	lr
.L409:
	.align	2
.L408:
	.word	.LANCHOR54
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlLowFormat,"ax",%progbits
	.align	1
	.global	FtlLowFormat
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLowFormat, %function
FtlLowFormat:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.gc_add_sblk,"ax",%progbits
	.align	1
	.global	gc_add_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_add_sblk, %function
gc_add_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L438
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r5, r0
	sub	sp, sp, #20
	mov	r6, r1
	mov	r7, r2
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L412
	movs	r2, #240
	ldr	r1, .L438+4
	ldr	r0, .L438+8
	bl	printf
.L413:
	b	.L413
.L412:
	ldr	r3, .L438+12
	lsl	r8, r0, #2
	ldr	r10, .L438+36
	ldr	r3, [r3]
	ldrh	r4, [r3, r0, lsl #1]
	ldr	r3, .L438+16
	ldr	r3, [r3]
	tst	r3, #256
	beq	.L414
	ldr	r2, .L438+20
	ldr	r3, [r10]
	ldrh	r2, [r2]
	add	r3, r3, r8
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	str	r2, [sp, #8]
	ldr	r2, .L438+24
	lsrs	r3, r3, #5
	ldrh	r2, [r2, #52]
	str	r4, [sp]
	str	r2, [sp, #4]
	mov	r2, r1
	mov	r1, r0
	ldr	r0, .L438+28
	bl	printf
.L414:
	ldr	r3, [r10]
	add	r3, r3, r8
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L415
	cmp	r4, #0
	beq	.L429
	movs	r2, #245
	ldr	r1, .L438+4
	ldr	r0, .L438+8
	bl	printf
.L417:
	b	.L417
.L415:
	ldr	r3, .L438+24
	ldrh	r2, [r3]
	cmp	r2, r5
	beq	.L429
	ldr	r2, .L438+32
	ldr	r2, [r2]
	ldrh	r1, [r2, #48]
	cmp	r1, r5
	beq	.L429
	ldrh	r1, [r2, #16]
	cmp	r1, r5
	beq	.L429
	ldrh	r1, [r2, #80]
	cmp	r1, r5
	beq	.L429
	ldrh	r0, [r3, #52]!
	movs	r1, #0
.L418:
	cmp	r1, r0
	bcc	.L419
	add	r3, r2, r7, lsl #7
	adds	r3, r3, #136
	cbz	r6, .L420
	add	r3, r2, #392
.L420:
	add	r0, r3, #128
	movw	r4, #65535
.L423:
	mov	r1, r3
	adds	r3, r3, #2
	ldrh	ip, [r1]
	cmp	ip, r4
	bne	.L421
	strh	r5, [r1]	@ movhi
	cbz	r6, .L422
	ldrh	r3, [r2, #124]
	adds	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
.L437:
	movs	r0, #1
.L411:
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L419:
	ldrh	r4, [r3, #2]!
	cmp	r4, r5
	beq	.L429
	adds	r1, r1, #1
	b	.L418
.L422:
	add	r2, r2, r7, lsl #1
	ldrh	r3, [r2, #120]
	adds	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	b	.L437
.L421:
	cmp	r0, r3
	bne	.L423
	b	.L437
.L429:
	movs	r0, #0
	b	.L411
.L439:
	.align	2
.L438:
	.word	.LANCHOR54
	.word	.LANCHOR55
	.word	.LC0
	.word	.LANCHOR56
	.word	.LANCHOR22
	.word	.LANCHOR58
	.word	.LANCHOR59
	.word	.LC7
	.word	.LANCHOR60
	.word	.LANCHOR57
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_get_src_ppa_from_index,"ax",%progbits
	.align	1
	.global	gc_get_src_ppa_from_index
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L441
	ldr	r3, [r3]
	ldr	r0, [r3, r0, lsl #2]
	bx	lr
.L442:
	.align	2
.L441:
	.word	.LANCHOR61
	.size	gc_get_src_ppa_from_index, .-gc_get_src_ppa_from_index
	.section	.text.gc_write_completed,"ax",%progbits
	.align	1
	.global	gc_write_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_write_completed, %function
gc_write_completed:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r6, .L465
.L444:
	ldr	r1, .L465+4
	ldrb	r5, [r1]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L457
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L457:
	movs	r3, #48
	muls	r3, r5, r3
	adds	r2, r6, r3
	ldrb	r3, [r6, r3]	@ zero_extendqisi2
	ldrh	r4, [r2, #32]
	strb	r3, [r1]
	ldr	r1, [r2, #36]
	cbz	r1, .L445
	ldr	r3, .L465+8
	movs	r0, #1
	ldr	r2, [r2, #24]
	strh	r0, [r3, #314]	@ movhi
	ldr	r0, .L465+12
	str	r2, [r3, #316]
	bl	printf
	mov	r2, #502
	ldr	r1, .L465+16
	ldr	r0, .L465+20
	bl	printf
.L446:
	b	.L446
.L445:
	ldr	fp, .L465+40
	ldr	r10, .L465+44
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	itett	eq
	ldreq	r3, .L465+24
	movne	r7, #1
	ldreq	r3, [r3]
	ldrbeq	r7, [r3, #89]	@ zero_extendqisi2
	ldr	r3, .L465+28
	ldr	r3, [r3]
	it	eq
	addeq	r7, r7, r7, lsl #1
	tst	r3, #256
	beq	.L448
	movs	r3, #48
	mov	r1, r4
	mla	r3, r3, r5, r6
	ldr	r0, .L465+32
	ldrb	r2, [r3, #1]	@ zero_extendqisi2
	ldr	r3, [r10]
	ldrb	r3, [r3, r4]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r4
	bl	printf
.L448:
	movs	r2, #48
	ldr	r3, [r10]
	mla	r5, r2, r5, r6
	ldrb	r1, [r3, r4]	@ zero_extendqisi2
	adds	r0, r3, r4
	mov	r8, r4
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	cmp	r1, r3
	beq	.L449
	movw	r2, #509
	ldr	r1, .L465+16
	ldr	r0, .L465+20
	bl	printf
.L450:
	b	.L450
.L449:
	ldrb	r3, [r5, #45]	@ zero_extendqisi2
	cmp	r3, #3
	beq	.L451
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L451
	ldr	r3, .L465+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L451
	mov	r4, r3
.L452:
	uxth	r1, r3
	cmp	r7, r1
	bls	.L444
	ldrb	r1, [r0, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	mla	r1, r2, r1, r6
	strb	r4, [r1, #45]
	b	.L452
.L451:
	ldr	r5, .L465+8
	mov	fp, #255
	movs	r3, #48
	strh	r4, [r5, #312]	@ movhi
.L453:
	sub	r2, r8, r4
	uxth	r2, r2
	cmp	r7, r2
	bls	.L444
	ldr	r2, [r10]
	movs	r1, #0
	str	r3, [sp, #12]
	ldrb	r0, [r2, r8]	@ zero_extendqisi2
	strb	fp, [r2, r8]
	add	r8, r8, #1
	mla	r2, r3, r0, r6
	add	r0, r0, r0, lsl #1
	strb	r1, [r2, #45]
	add	r0, r6, r0, lsl #4
	bl	buf_free
	ldrb	r2, [r5, #7]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	subs	r2, r2, #1
	strb	r2, [r5, #7]
	b	.L453
.L466:
	.align	2
.L465:
	.word	.LANCHOR36
	.word	.LANCHOR62
	.word	.LANCHOR59
	.word	.LC8
	.word	.LANCHOR63
	.word	.LC0
	.word	.LANCHOR60
	.word	.LANCHOR22
	.word	.LC9
	.word	.LANCHOR66
	.word	.LANCHOR64
	.word	.LANCHOR65
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",%progbits
	.align	1
	.global	gc_get_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L476
	push	{r4, r5, r6, r7, lr}
	ldr	r2, [r3]
	ldr	r3, .L476+4
	ldrh	r4, [r2, #124]
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbz	r4, .L468
	add	r3, r2, #392
	movs	r4, #1
.L469:
	add	r6, r3, #128
	movw	r5, #65535
.L473:
	mov	r7, r3
	ldrh	r0, [r3], #2
	cmp	r0, r5
	beq	.L471
	strh	r5, [r7]	@ movhi
	cbz	r4, .L472
	ldrh	r3, [r2, #124]
	subs	r3, r3, #1
	strh	r3, [r2, #124]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L468:
	add	r3, r1, #60
	ldrh	r3, [r2, r3, lsl #1]
	cbz	r3, .L474
	add	r3, r2, r1, lsl #7
	adds	r3, r3, #136
	b	.L469
.L472:
	add	r2, r2, r1, lsl #1
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L471:
	cmp	r3, r6
	bne	.L473
	pop	{r4, r5, r6, r7, pc}
.L474:
	movw	r0, #65535
	pop	{r4, r5, r6, r7, pc}
.L477:
	.align	2
.L476:
	.word	.LANCHOR60
	.word	.LANCHOR67
	.size	gc_get_src_blk, .-gc_get_src_blk
	.section	.text.gc_free_temp_buf,"ax",%progbits
	.align	1
	.global	gc_free_temp_buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_free_temp_buf, %function
gc_free_temp_buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r5, .L492
	ldrb	r0, [r5, #7]	@ zero_extendqisi2
	cbz	r0, .L478
	ldr	r3, .L492+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bhi	.L485
	ldr	r3, .L492+8
	movs	r7, #48
	ldrh	r4, [r5, #312]
	ldr	r6, .L492+12
	ldrh	r2, [r3]
	ldr	r3, .L492+16
	add	r1, r4, #24
	ldr	r0, .L492+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	cmp	r2, r1
	it	cs
	movcs	r2, r1
	ldr	r1, [r6]
.L480:
	cmp	r4, r2
	bcc	.L483
.L485:
	movs	r0, #0
.L478:
	pop	{r3, r4, r5, r6, r7, pc}
.L483:
	ldrb	r3, [r1, r4]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L481
	mla	ip, r7, r3, r0
	ldrb	ip, [ip, #45]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L481
	add	r3, r3, r3, lsl #1
	add	r0, r0, r3, lsl #4
	bl	buf_free
	ldr	r3, .L492+24
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L482
	ldr	r3, [r6]
	mov	r1, r4
	ldr	r0, .L492+28
	ldrb	r2, [r3, r4]	@ zero_extendqisi2
	bl	printf
.L482:
	ldr	r3, [r6]
	movs	r2, #255
	movs	r0, #1
	strb	r2, [r3, r4]
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r5, #7]
	pop	{r3, r4, r5, r6, r7, pc}
.L481:
	adds	r4, r4, #1
	b	.L480
.L493:
	.align	2
.L492:
	.word	.LANCHOR59
	.word	.LANCHOR38
	.word	.LANCHOR68
	.word	.LANCHOR65
	.word	.LANCHOR69
	.word	.LANCHOR36
	.word	.LANCHOR22
	.word	.LC10
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.gc_static_wearleveling,"ax",%progbits
	.align	1
	.global	gc_static_wearleveling
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L542
	ldr	r4, [r3]
	ldr	r3, [r4, #32]
	cmp	r3, #20480
	bls	.L495
	ldr	r2, [r4, #36]
	add	r2, r2, r3, lsr #10
	ubfx	r3, r3, #0, #10
	str	r3, [r4, #32]
	str	r2, [r4, #36]
.L495:
	ldr	r3, .L542+4
	ldr	r0, [r4, #36]
	ldr	r3, [r3]
	ldr	r2, [r3, #568]
	ldr	r1, [r3, #12]
	add	r2, r2, #12910592
	add	r2, r2, #49408
	cmp	r1, r2
	bhi	.L496
	ldr	r2, [r3, #572]
	adds	r2, r2, #128
	cmp	r0, r2
	bls	.L494
.L496:
	str	r0, [r3, #572]
	movw	r6, #65535
	str	r1, [r3, #568]
	movs	r0, #0
	ldr	r3, .L542+8
	mov	r2, r0
	ldrh	ip, [r4, #134]
	mov	r8, r0
	mov	r10, r0
	mov	fp, r0
	ldrh	r3, [r3]
	mov	r7, r0
	mov	r5, r6
	str	r3, [sp, #8]
	ldr	r3, .L542+12
	ldr	r3, [r3]
	add	r3, r3, ip, lsl #2
.L498:
	ldr	r1, [sp, #8]
	cmp	ip, r1
	bcc	.L502
	ldrh	r3, [r4, #96]
	mov	r1, r10
	str	r2, [sp, #12]
	cmp	r3, fp
	ldrh	r3, [r4, #98]
	it	cc
	strhcc	fp, [r4, #96]	@ movhi
	cmp	r3, r7
	it	cc
	strhcc	r7, [r4, #98]	@ movhi
	bl	__aeabi_uidiv
	ldr	r2, [sp, #12]
	mov	r1, r8
	strh	r0, [r4, #88]	@ movhi
	str	r0, [sp, #8]
	mov	r0, r2
	bl	__aeabi_uidiv
	strh	r0, [r4, #90]	@ movhi
	ldr	r4, .L542+16
	ldr	r3, [sp, #8]
	ldr	r2, [r4]
	tst	r2, #256
	beq	.L505
	uxth	r0, r0
	uxth	r3, r3
	str	r0, [sp]
	mov	r2, r8
	mov	r1, r10
	ldr	r0, .L542+20
	bl	printf
.L505:
	ldr	r3, [r4]
	lsls	r2, r3, #23
	bpl	.L506
	str	r7, [sp]
	mov	r3, fp
	mov	r2, r5
	mov	r1, r6
	ldr	r0, .L542+24
	bl	printf
.L506:
	subs	r7, r7, r5
	cmp	r7, #64
	bgt	.L507
.L513:
	cmp	r5, #0
	bne	.L508
.L514:
	cbz	r6, .L494
	ldr	r3, .L542
	ldr	r2, .L542+8
	ldr	r1, [r3]
	ldrh	r5, [r2]
	ldr	r2, .L542+12
	ldrh	r3, [r1, #134]
	ldr	r2, [r2]
	add	r2, r2, r3, lsl #2
.L519:
	cmp	r3, r5
	bcc	.L521
	ldrh	r3, [r1, #74]
	add	r3, r3, r6
	strh	r3, [r1, #74]	@ movhi
	ldrh	r3, [r1, #96]
	cmp	r6, r3
	bcs	.L494
	subs	r6, r3, r6
	strh	r6, [r1, #96]	@ movhi
.L494:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L502:
	ldrb	r1, [r3, #2]	@ zero_extendqisi2
	tst	r1, #8
	beq	.L499
	ldrh	lr, [r3]
	ldr	r1, [r3]
	ubfx	lr, lr, #0, #11
	ubfx	r1, r1, #11, #8
.L500:
	cmp	r6, lr
	add	r0, r0, lr
	it	cs
	movcs	r6, lr
	cmp	fp, lr
	it	cc
	movcc	fp, lr
	movw	lr, #65535
	cmp	r1, lr
	add	r10, r10, #1
	uxth	r10, r10
	bne	.L522
	b	.L523
.L499:
	tst	r1, #24
	bne	.L501
	ldrh	lr, [r3]
	movw	r1, #65535
	ubfx	lr, lr, #0, #11
	b	.L500
.L501:
	ldr	r1, [r3]
	ubfx	r1, r1, #11, #8
.L522:
	cmp	r5, r1
	add	r8, r8, #1
	it	cs
	movcs	r5, r1
	uxth	r8, r8
	cmp	r7, r1
	add	r2, r2, r1
	it	cc
	movcc	r7, r1
.L523:
	add	ip, ip, #1
	adds	r3, r3, #4
	uxth	ip, ip
	b	.L498
.L507:
	ldr	r3, .L542
	ldr	r7, .L542+8
	ldr	r8, .L542+12
	ldr	r3, [r3]
	ldrh	r4, [r3, #134]
.L510:
	ldrh	r3, [r7]
	cmp	r3, r4
	bls	.L513
	ldr	r1, [r8]
	lsls	r2, r4, #2
	adds	r3, r1, r2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	tst	r3, #192
	beq	.L511
	and	r0, r3, #224
	cmp	r0, #224
	beq	.L511
	ubfx	r3, r3, #3, #2
	lsls	r3, r3, #30
	bpl	.L511
	ldr	r3, [r1, r2]
	ubfx	r3, r3, #11, #8
	cmp	r3, r5
	bhi	.L511
	movs	r2, #1
	mov	r0, r4
	mov	r1, r2
	bl	gc_add_sblk
.L511:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L510
.L508:
	ldr	r3, .L542
	ldr	r2, .L542+8
	ldr	r1, [r3]
	ldrh	r7, [r2]
	ldr	r2, .L542+12
	ldrh	r3, [r1, #134]
	ldr	r2, [r2]
	add	r2, r2, r3, lsl #2
.L515:
	cmp	r3, r7
	bcc	.L517
	ldrh	r3, [r1, #72]
	add	r3, r3, r5
	strh	r3, [r1, #72]	@ movhi
	ldrh	r3, [r1, #98]
	cmp	r5, r3
	itt	cc
	subcc	r5, r3, r5
	strhcc	r5, [r1, #98]	@ movhi
	b	.L514
.L517:
	ldr	r0, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r2, r2, #4
	ubfx	r4, r0, #11, #8
	cmp	r5, r4
	ittt	ls
	subls	r4, r4, r5
	bfils	r0, r4, #11, #8
	strls	r0, [r2, #-4]
	b	.L515
.L521:
	ldrh	r0, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r2, r2, #4
	ubfx	r4, r0, #0, #11
	cmp	r4, r6
	ittt	ge
	subge	r4, r4, r6
	bfige	r0, r4, #0, #11
	strhge	r0, [r2, #-4]	@ movhi
	b	.L519
.L543:
	.align	2
.L542:
	.word	.LANCHOR46
	.word	.LANCHOR60
	.word	.LANCHOR54
	.word	.LANCHOR57
	.word	.LANCHOR22
	.word	.LC11
	.word	.LC12
	.size	gc_static_wearleveling, .-gc_static_wearleveling
	.section	.text.print_gc_debug_info,"ax",%progbits
	.align	1
	.global	print_gc_debug_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, lr}
	ldr	r0, .L545
	ldrh	r3, [r0, #310]
	ldrh	r2, [r0, #2]
	ldrh	r1, [r0]
	ldrb	r0, [r0, #7]	@ zero_extendqisi2
	str	r0, [sp, #4]
	ldr	r0, .L545+4
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r0, .L545+8
	bl	printf
	add	sp, sp, #12
	@ sp needed
	ldr	pc, [sp], #4
.L546:
	.align	2
.L545:
	.word	.LANCHOR59
	.word	.LANCHOR38
	.word	.LC13
	.size	print_gc_debug_info, .-print_gc_debug_info
	.global	__aeabi_idiv
	.section	.text.ftl_get_blk_list_in_sblk,"ax",%progbits
	.align	1
	.global	ftl_get_blk_list_in_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L556
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	r7, r1
	mov	r5, r4
	ldr	r3, [r3]
	add	r3, r3, r0, lsl #2
	ldrb	fp, [r3, #3]	@ zero_extendqisi2
	ldr	r3, .L556+4
	ldrb	r10, [r3]	@ zero_extendqisi2
	ldr	r3, .L556+8
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, .L556+12
	smulbb	r0, r8, r0
	uxth	r6, r0
.L548:
	cmp	r5, r10
	blt	.L552
	mov	r3, r4
	movw	r2, #65535
.L553:
	cmp	r3, r10
	blt	.L554
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L552:
	asr	r2, fp, r5
	lsls	r2, r2, #31
	bmi	.L549
	mov	r1, r8
	mov	r0, r5
	str	r3, [sp, #4]
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	cmp	r8, #1
	ldrh	r2, [r3]
	rsb	r2, r2, #21
	lsl	r0, r0, r2
	it	hi
	andhi	r2, r5, #1
	add	r0, r0, r6
	uxth	r0, r0
	it	hi
	addhi	r0, r0, r2
	strh	r0, [r7, r4, lsl #1]	@ movhi
	adds	r4, r4, #1
.L549:
	adds	r5, r5, #1
	b	.L548
.L554:
	strh	r2, [r7, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	b	.L553
.L557:
	.align	2
.L556:
	.word	.LANCHOR57
	.word	.LANCHOR69
	.word	.LANCHOR70
	.word	.LANCHOR71
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_alloc_sblk,"ax",%progbits
	.align	1
	.global	ftl_alloc_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_sblk, %function
ftl_alloc_sblk:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
.L559:
	ldr	r3, .L580
	cmp	r0, #5
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	movw	r4, #65535
	mov	r5, r0
	mov	lr, #0
	mov	ip, r4
	ldrh	r3, [r3]
	str	r3, [sp, #8]
	ite	ne
	movne	r3, #0
	moveq	r3, #2
	ldr	r8, [sp, #8]
	str	r3, [sp, #12]
	ite	ne
	movne	r3, #2
	moveq	r3, #0
	str	r3, [sp, #20]
	ldr	r3, .L580+4
	ldr	r2, [r3]
	ldr	r3, .L580+8
	ldr	r3, [r3]
	str	r3, [sp, #16]
.L574:
	ldrh	r7, [r2, #132]
	ldr	r1, [sp, #16]
	mov	r3, r7
	add	r1, r1, r7, lsl #2
.L560:
	cmp	r3, r8
	blt	.L572
	subs	r3, r3, r7
	ldr	r1, [sp, #8]
	add	lr, lr, r3
	ldrh	r3, [r2, #134]
	uxth	lr, lr
	subs	r1, r1, r3
	cmp	lr, r1
	blt	.L573
	movw	r1, #65535
	cmp	r4, r1
	beq	.L573
	ldr	r3, [sp, #16]
	add	r6, r3, r4, lsl #2
	b	.L564
.L572:
	ldrb	r0, [r1, #2]	@ zero_extendqisi2
	mov	r6, r1
	tst	r0, #224
	bne	.L561
	ubfx	r10, r0, #3, #2
	ldr	r0, [sp, #20]
	cmp	r0, r10
	beq	.L561
	ldr	r0, [sp, #12]
	cbz	r0, .L562
	ldr	r0, [r1]
	ldrh	fp, [r2, #72]
	ldrh	r10, [r2, #90]
	ubfx	r0, r0, #11, #8
	add	fp, fp, r0
	add	r10, r10, #1
	cmp	fp, r10
	ble	.L563
	uxth	r0, r0
	cmp	ip, r0
	bls	.L561
	uxth	r4, r3
	mov	ip, r0
.L561:
	adds	r3, r3, #1
	adds	r1, r1, #4
	b	.L560
.L562:
	ldrh	r0, [r1]
	ldrh	fp, [r2, #74]
	ldrh	r10, [r2, #88]
	ubfx	r0, r0, #0, #11
	add	fp, fp, r0
	add	r10, r10, #1
	cmp	fp, r10
	ble	.L563
	cmp	r0, ip
	bge	.L561
	mov	ip, r0
	uxth	r4, r3
	b	.L561
.L563:
	uxth	r4, r3
.L564:
	ldr	r3, .L580+12
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L565
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	mov	r1, r4
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	ldr	r0, .L580+16
	str	r2, [sp]
	lsrs	r3, r3, #5
	mov	r2, r5
	bl	printf
.L565:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bfi	r3, r5, #5, #3
	uxtb	r3, r3
	ubfx	r2, r3, #3, #2
	orrs	r2, r2, r1
	bfi	r3, r2, #3, #2
	lsls	r2, r2, #31
	strb	r3, [r6, #2]
	ldr	r3, .L580+4
	ldr	r3, [r3]
	strh	r4, [r3, #132]	@ movhi
	bpl	.L566
	ldrh	r2, [r3, #116]
	subs	r2, r2, #1
	strh	r2, [r3, #116]	@ movhi
.L567:
	cmp	r5, #5
	bne	.L569
	ldrh	r2, [r3, #120]
	adds	r2, r2, #1
	strh	r2, [r3, #120]	@ movhi
.L576:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L566:
	ldrb	r2, [r6, #2]	@ zero_extendqisi2
	tst	r2, #24
	itete	eq
	ldrheq	r2, [r3, #114]
	ldrhne	r2, [r3, #118]
	addeq	r2, r2, #-1
	addne	r2, r2, #-1
	ite	eq
	strheq	r2, [r3, #114]	@ movhi
	strhne	r2, [r3, #118]	@ movhi
	b	.L567
.L569:
	cmp	r5, #2
	bne	.L571
	ldrh	r2, [r3, #122]
	adds	r2, r2, #1
	strh	r2, [r3, #122]	@ movhi
	b	.L576
.L571:
	cmp	r5, #3
	bne	.L576
	ldrh	r2, [r3, #124]
	adds	r2, r2, #1
	strh	r2, [r3, #124]	@ movhi
	b	.L576
.L573:
	strh	r3, [r2, #132]	@ movhi
	mov	r8, r7
	b	.L574
.L581:
	.align	2
.L580:
	.word	.LANCHOR54
	.word	.LANCHOR46
	.word	.LANCHOR57
	.word	.LANCHOR22
	.word	.LC14
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.ftl_free_sblk,"ax",%progbits
	.align	1
	.global	ftl_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movw	r3, #65535
	cmp	r0, r3
	bne	.L583
	movw	r2, #313
	ldr	r1, .L593
	ldr	r0, .L593+4
	bl	printf
.L584:
	b	.L584
.L583:
	ldr	r3, .L593+8
	ldr	r2, [r3]
	add	r2, r2, r0, lsl #2
	ldrb	r3, [r2, #2]	@ zero_extendqisi2
	ands	r1, r3, #224
	bne	.L585
	mov	r2, #316
	ldr	r1, .L593
	ldr	r0, .L593+4
	bl	printf
.L586:
	b	.L586
.L585:
	cmp	r1, #160
	ubfx	r4, r3, #3, #2
	ldr	r3, .L593+12
	bne	.L587
	ldr	r5, [r3]
	ldrh	r1, [r5, #120]
	subs	r1, r1, #1
	strh	r1, [r5, #120]	@ movhi
.L588:
	ldr	r1, [r3]
	lsls	r3, r4, #31
	bpl	.L590
	ldrh	r3, [r1, #116]
	adds	r3, r3, #1
	strh	r3, [r1, #116]	@ movhi
.L591:
	ldrb	r3, [r2, #2]	@ zero_extendqisi2
	bfc	r3, #5, #3
	strb	r3, [r2, #2]
	movs	r2, #0
	ldr	r3, .L593+16
	ldr	r3, [r3]
	strh	r2, [r3, r0, lsl #1]	@ movhi
	pop	{r3, r4, r5, pc}
.L587:
	cmp	r1, #64
	bne	.L589
	ldr	r5, [r3]
	ldrh	r1, [r5, #122]
	subs	r1, r1, #1
	strh	r1, [r5, #122]	@ movhi
	b	.L588
.L589:
	cmp	r1, #96
	itttt	eq
	ldreq	r5, [r3]
	ldrheq	r1, [r5, #124]
	addeq	r1, r1, #-1
	strheq	r1, [r5, #124]	@ movhi
	b	.L588
.L590:
	cbnz	r4, .L592
	ldrh	r3, [r1, #114]
	adds	r3, r3, #1
	strh	r3, [r1, #114]	@ movhi
	b	.L591
.L592:
	ldrh	r3, [r1, #118]
	adds	r3, r3, #1
	strh	r3, [r1, #118]	@ movhi
	b	.L591
.L594:
	.align	2
.L593:
	.word	.LANCHOR72
	.word	.LC0
	.word	.LANCHOR57
	.word	.LANCHOR46
	.word	.LANCHOR56
	.size	ftl_free_sblk, .-ftl_free_sblk
	.section	.text.gc_free_src_blk,"ax",%progbits
	.align	1
	.global	gc_free_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_free_src_blk, %function
gc_free_src_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r5, #0
	ldr	r6, .L634
.L596:
	uxth	r2, r5
	ldr	r3, .L634+4
	ldrh	r1, [r3, #52]
	cmp	r1, r2
	bhi	.L612
	movs	r2, #0
	strh	r2, [r3, #52]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L612:
	uxth	r2, r5
	add	r3, r3, r2, lsl #1
	ldrh	r4, [r3, #54]
	ldr	r3, [r6]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L597
	mov	r1, r4
	ldr	r0, .L634+8
	bl	printf
.L597:
	ldr	r3, [r6]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	bne	.L598
	ldr	r3, .L634+12
	ldr	r7, [r3]
	ldr	r3, .L634+16
	ldr	r3, [r3]
	add	r7, r7, r4, lsl #2
	lsls	r3, r3, #23
	bpl	.L599
	ldrb	r2, [r7, #2]	@ zero_extendqisi2
	mov	r1, r4
	ldr	r0, .L634+20
	lsrs	r2, r2, #5
	bl	printf
.L599:
	ldrb	r3, [r7, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L600
	tst	r3, #192
	bne	.L601
.L600:
	movw	r2, #753
	ldr	r1, .L634+24
	ldr	r0, .L634+28
	bl	printf
.L602:
	b	.L602
.L601:
	mov	r0, r4
	bl	ftl_free_sblk
	ldr	r3, .L634+32
	ldr	r3, [r3]
	ldrh	r1, [r3, #124]
	cbz	r1, .L603
	add	r0, r3, #392
	movs	r2, #0
.L605:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L604
	adds	r2, r2, #196
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #124]	@ movhi
.L603:
	ldrh	r1, [r3, #120]
	cbz	r1, .L606
	add	r0, r3, #136
	movs	r2, #0
.L608:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L607
	adds	r2, r2, #68
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #120]	@ movhi
.L606:
	ldrh	r1, [r3, #122]
	cbz	r1, .L609
	add	r0, r3, #264
	movs	r2, #0
.L611:
	ldrh	r7, [r0], #2
	cmp	r4, r7
	bne	.L610
	adds	r2, r2, #132
	movw	r0, #65535
	subs	r1, r1, #1
	strh	r0, [r3, r2, lsl #1]	@ movhi
	strh	r1, [r3, #122]	@ movhi
.L609:
	adds	r5, r5, #1
	b	.L596
.L604:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L605
	b	.L603
.L607:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L608
	b	.L606
.L610:
	adds	r2, r2, #1
	cmp	r2, #64
	bne	.L611
	b	.L609
.L598:
	movs	r2, #0
	movs	r1, #1
	mov	r0, r4
	bl	gc_add_sblk
	b	.L609
.L635:
	.align	2
.L634:
	.word	.LANCHOR56
	.word	.LANCHOR59
	.word	.LC15
	.word	.LANCHOR57
	.word	.LANCHOR22
	.word	.LC16
	.word	.LANCHOR73
	.word	.LC0
	.word	.LANCHOR60
	.size	gc_free_src_blk, .-gc_free_src_blk
	.section	.text.ftl_erase_phy_blk,"ax",%progbits
	.align	1
	.global	ftl_erase_phy_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_erase_phy_blk, %function
ftl_erase_phy_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r6, r1
	ldr	r3, .L641
	ldr	r7, .L641+4
	ldrh	r4, [r3]
	rsb	r3, r4, #21
	movs	r4, #1
	asr	r5, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L641+8
	subs	r4, r4, #1
	uxtb	r5, r5
	ands	r4, r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxth	r4, r4
	cbz	r3, .L637
	ldrh	r2, [r7]
	clz	r1, r1
	lsrs	r1, r1, #5
	mov	r0, r5
	muls	r2, r4, r2
	bl	flash_erase_block_en
.L637:
	ldrh	r2, [r7]
	uxtb	r1, r6
	mov	r0, r5
	muls	r2, r4, r2
	pop	{r3, r4, r5, r6, r7, lr}
	b	flash_erase_block_en
.L642:
	.align	2
.L641:
	.word	.LANCHOR71
	.word	.LANCHOR75
	.word	.LANCHOR74
	.size	ftl_erase_phy_blk, .-ftl_erase_phy_blk
	.section	.text.ftl_erase_sblk,"ax",%progbits
	.align	1
	.global	ftl_erase_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_erase_sblk, %function
ftl_erase_sblk:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r6, .L663
	sub	sp, sp, #64
	mov	r7, r1
	movs	r5, #0
	ldr	r3, [r6]
	add	r3, r3, r0, lsl #2
	ldrb	r8, [r3, #3]	@ zero_extendqisi2
.L644:
	ldr	r3, .L663+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bge	.L651
	ldr	r3, .L663+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, .L663+12
	ldrh	ip, [r3]
	movs	r3, #0
	mul	r10, r0, r5
	mov	r2, r3
	mul	lr, r0, r4
	b	.L652
.L646:
	add	r1, r2, r10
	asr	r1, r8, r1
	lsls	r1, r1, #31
	bmi	.L645
	add	r1, sp, #64
	add	fp, r1, r3, lsl #2
	and	r1, r2, #1
	add	r1, r1, lr
	mul	r1, ip, r1
	adds	r3, r3, #1
	str	r1, [fp, #-64]
.L645:
	adds	r2, r2, #1
.L652:
	cmp	r2, r0
	blt	.L646
	cmp	r3, #2
	bne	.L647
	ldr	r3, .L663+16
	uxtb	r10, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L648
	clz	r1, r7
	ldm	sp, {r2, r3}
	lsrs	r1, r1, #5
	mov	r0, r10
	bl	flash_erase_duplane_block
.L648:
	ldm	sp, {r2, r3}
	uxtb	r1, r7
	mov	r0, r10
	bl	flash_erase_duplane_block
.L649:
	adds	r5, r5, #1
	b	.L644
.L647:
	cmp	r3, #1
	bne	.L649
	ldr	r3, .L663+16
	uxtb	r10, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L650
	clz	r1, r7
	ldr	r2, [sp]
	lsrs	r1, r1, #5
	mov	r0, r10
	bl	flash_erase_block_en
.L650:
	ldr	r2, [sp]
	uxtb	r1, r7
	mov	r0, r10
	bl	flash_erase_block_en
	b	.L649
.L651:
	ldr	r1, .L663+20
	ldr	r0, [r6]
	cbnz	r7, .L653
	ldrh	r2, [r0, r4, lsl #2]
	adds	r3, r2, #1
	ubfx	r3, r3, #0, #11
	bfi	r2, r3, #0, #11
	strh	r2, [r0, r4, lsl #2]	@ movhi
	ldr	r2, [r1]
	ldr	r1, [r2, #84]
	adds	r1, r1, #1
	str	r1, [r2, #84]
	ldrh	r1, [r2, #96]
	cmp	r1, r3
	bge	.L655
	strh	r3, [r2, #96]	@ movhi
.L655:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L653:
	ldr	r2, [r0, r4, lsl #2]
	ubfx	r3, r2, #11, #8
	adds	r3, r3, #1
	uxtb	r3, r3
	bfi	r2, r3, #11, #8
	uxth	r3, r3
	str	r2, [r0, r4, lsl #2]
	ldr	r2, [r1]
	ldr	r1, [r2, #80]
	adds	r1, r1, #1
	str	r1, [r2, #80]
	ldrh	r1, [r2, #98]
	cmp	r1, r3
	it	cc
	strhcc	r3, [r2, #98]	@ movhi
	b	.L655
.L664:
	.align	2
.L663:
	.word	.LANCHOR57
	.word	.LANCHOR76
	.word	.LANCHOR70
	.word	.LANCHOR75
	.word	.LANCHOR74
	.word	.LANCHOR46
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",%progbits
	.align	1
	.global	ftl_alloc_sys_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L675
	ldr	r3, [r3]
	ldrh	r2, [r3, #136]
	ldrh	r1, [r3, #112]
	cmp	r2, #63
	itt	hi
	movhi	r2, #0
	strhhi	r2, [r3, #136]	@ movhi
	cbnz	r1, .L667
	mov	r2, #440
	ldr	r1, .L675+4
	ldr	r0, .L675+8
	bl	printf
.L668:
	b	.L668
.L667:
	movw	r5, #65535
	movs	r6, #0
	mov	r7, r5
.L673:
	ldrh	r2, [r3, #136]
	add	r4, r3, r2, lsl #1
	adds	r4, r4, #158
.L669:
	cmp	r2, #63
	ble	.L671
	strh	r6, [r3, #136]	@ movhi
	b	.L673
.L671:
	ldrh	r0, [r4, #2]!
	cmp	r0, r5
	bne	.L674
	adds	r2, r2, #1
	b	.L669
.L674:
	add	r4, r2, #80
	subs	r1, r1, #1
	strh	r7, [r3, r4, lsl #1]	@ movhi
	strh	r2, [r3, #136]	@ movhi
	strh	r1, [r3, #112]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L676:
	.align	2
.L675:
	.word	.LANCHOR46
	.word	.LANCHOR77
	.word	.LC0
	.size	ftl_alloc_sys_blk, .-ftl_alloc_sys_blk
	.section	.text.ftl_free_sys_blk,"ax",%progbits
	.align	1
	.global	ftl_free_sys_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free_sys_blk, %function
ftl_free_sys_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L686
	ldr	r3, [r3]
	ldrh	r2, [r3, #138]
	ldrh	r1, [r3, #112]
	cmp	r2, #63
	itt	hi
	movhi	r2, #0
	strhhi	r2, [r3, #138]	@ movhi
	cmp	r1, #63
	bls	.L679
	mov	r2, #464
	ldr	r1, .L686+4
	ldr	r0, .L686+8
	bl	printf
.L680:
	b	.L680
.L679:
	movw	r6, #65535
	movs	r5, #0
.L685:
	ldrh	r2, [r3, #138]
	add	r4, r3, r2, lsl #1
	adds	r4, r4, #158
.L681:
	cmp	r2, #63
	ble	.L683
	strh	r5, [r3, #138]	@ movhi
	b	.L685
.L683:
	ldrh	r7, [r4, #2]!
	cmp	r7, r6
	bne	.L682
	add	r4, r2, #80
	adds	r1, r1, #1
	strh	r0, [r3, r4, lsl #1]	@ movhi
	strh	r2, [r3, #138]	@ movhi
	strh	r1, [r3, #112]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L682:
	adds	r2, r2, #1
	b	.L681
.L687:
	.align	2
.L686:
	.word	.LANCHOR46
	.word	.LANCHOR78
	.word	.LC0
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",%progbits
	.align	1
	.global	ftl_info_data_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r1, [r0]
	movw	r3, #65535
	push	{r4, r5, lr}
	cmp	r1, r3
	beq	.L688
	ldr	r3, .L697
	ldr	r4, [r3]
	add	r2, r4, r1, lsl #2
	ldrb	r3, [r2, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L688
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	bfi	r3, r0, #5, #3
	strb	r3, [r2, #2]
	uxtb	r3, r3
	ldr	r2, .L697+4
	tst	r3, #8
	ldr	r5, [r2]
	beq	.L692
	ldrh	r0, [r5, #116]
	subs	r0, r0, #1
	strh	r0, [r5, #116]	@ movhi
.L693:
	and	r3, r3, #224
	cmp	r3, #160
	bne	.L695
	ldr	r3, [r4, r1, lsl #2]
	ldr	r2, [r2]
	ubfx	r0, r3, #11, #8
	adds	r0, r0, #1
	bfi	r3, r0, #11, #8
	str	r3, [r4, r1, lsl #2]
	ldrh	r3, [r2, #120]
	subs	r3, r3, #1
	strh	r3, [r2, #120]	@ movhi
	pop	{r4, r5, pc}
.L692:
	tst	r3, #24
	itete	eq
	ldrheq	r0, [r5, #114]
	ldrhne	r0, [r5, #118]
	addeq	r0, r0, #-1
	addne	r0, r0, #-1
	ite	eq
	strheq	r0, [r5, #114]	@ movhi
	strhne	r0, [r5, #118]	@ movhi
	b	.L693
.L695:
	ldrh	r0, [r4, r1, lsl #2]
	cmp	r3, #64
	add	r5, r0, #1
	bfi	r0, r5, #0, #11
	strh	r0, [r4, r1, lsl #2]	@ movhi
	bne	.L696
	ldr	r2, [r2]
	ldrh	r3, [r2, #122]
	subs	r3, r3, #1
	strh	r3, [r2, #122]	@ movhi
	pop	{r4, r5, pc}
.L696:
	cmp	r3, #96
	itttt	eq
	ldreq	r2, [r2]
	ldrheq	r3, [r2, #124]
	addeq	r3, r3, #-1
	strheq	r3, [r2, #124]	@ movhi
.L688:
	pop	{r4, r5, pc}
.L698:
	.align	2
.L697:
	.word	.LANCHOR57
	.word	.LANCHOR46
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",%progbits
	.align	1
	.global	ftl_get_ppa_from_index
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L704
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldr	r5, [r3]
	ldr	r3, .L704+4
	ldrh	r2, [r3]
	ldr	r3, .L704+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	mul	r1, r3, r2
	cmp	r0, r1
	itet	ge
	smulbbge	r3, r3, r2
	addlt	r5, r5, #16
	addge	r5, r5, #48
	ldrb	r6, [r5, #9]	@ zero_extendqisi2
	itt	ge
	subge	r4, r0, r3
	uxthge	r4, r4
	mov	r1, r6
	mov	r0, r4
	bl	__aeabi_idiv
	smulbb	r6, r0, r6
	movw	r2, #65535
	subs	r4, r4, r6
	uxth	r4, r4
	adds	r4, r4, #8
	ldrh	r3, [r5, r4, lsl #1]
	cmp	r3, r2
	bne	.L702
	movw	r2, #837
	ldr	r1, .L704+12
	ldr	r0, .L704+16
	bl	printf
.L703:
	b	.L703
.L702:
	ldr	r2, .L704+20
	ldrh	r2, [r2]
	mla	r0, r3, r2, r0
	pop	{r4, r5, r6, pc}
.L705:
	.align	2
.L704:
	.word	.LANCHOR60
	.word	.LANCHOR79
	.word	.LANCHOR69
	.word	.LANCHOR80
	.word	.LC0
	.word	.LANCHOR75
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",%progbits
	.align	1
	.global	lpa_hash_get_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L710
	uxtb	r2, r0
	push	{r4, r5}
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L710+4
	ldr	r1, [r2]
	ldr	r2, .L710+8
	ldr	r4, [r2]
	movw	r2, #65535
.L707:
	cmp	r3, r2
	bne	.L709
	mov	r0, #-1
	pop	{r4, r5}
	bx	lr
.L709:
	ldr	r5, [r1, r3, lsl #2]
	cmp	r0, r5
	bne	.L708
	mov	r0, r3
	pop	{r4, r5}
	b	ftl_get_ppa_from_index
.L708:
	ldrh	r3, [r4, r3, lsl #1]
	b	.L707
.L711:
	.align	2
.L710:
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR83
	.size	lpa_hash_get_ppa, .-lpa_hash_get_ppa
	.section	.text.ftl_get_new_free_page,"ax",%progbits
	.align	1
	.global	ftl_get_new_free_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_new_free_page, %function
ftl_get_new_free_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r1, [r0]
	movw	r2, #65535
	push	{r4, r5, r6, lr}
	mov	r3, r0
	cmp	r1, r2
	bne	.L713
	mov	r2, #948
	ldr	r1, .L723
	ldr	r0, .L723+4
	bl	printf
.L714:
	b	.L714
.L713:
	ldr	r1, .L723+8
	ldrh	r0, [r0, #2]
	ldrh	r1, [r1]
	cmp	r0, r1
	bne	.L715
	movw	r2, #949
	ldr	r1, .L723
	ldr	r0, .L723+4
	bl	printf
.L716:
	b	.L716
.L715:
	ldrh	r1, [r3, #6]
	cbnz	r1, .L717
	movw	r2, #950
	ldr	r1, .L723
	ldr	r0, .L723+4
	bl	printf
.L718:
	b	.L718
.L717:
	ldrb	r0, [r3, #5]	@ zero_extendqisi2
	movs	r6, #0
	ldr	r4, .L723+12
	adds	r0, r0, #8
	ldrh	r0, [r3, r0, lsl #1]
	ldrb	r5, [r4]	@ zero_extendqisi2
	mov	r4, r2
.L719:
	cmp	r0, r4
	ldrb	r2, [r3, #5]	@ zero_extendqisi2
	beq	.L721
	ldr	r6, .L723+16
	adds	r2, r2, #1
	uxtb	r2, r2
	ldrh	r4, [r3, #2]
	subs	r1, r1, #1
	ldrh	r6, [r6]
	cmp	r5, r2
	strh	r1, [r3, #6]	@ movhi
	ldrh	r1, [r3, #10]
	strb	r2, [r3, #5]
	it	eq
	addeq	r2, r4, #1
	mul	r0, r0, r6
	it	eq
	strheq	r2, [r3, #2]	@ movhi
	add	r1, r1, #1
	it	eq
	moveq	r2, #0
	strh	r1, [r3, #10]	@ movhi
	it	eq
	strbeq	r2, [r3, #5]
	orrs	r0, r0, r4
	pop	{r4, r5, r6, pc}
.L721:
	adds	r2, r2, #1
	uxtb	r2, r2
	cmp	r2, r5
	strb	r2, [r3, #5]
	itttt	eq
	ldrheq	r2, [r3, #2]
	strbeq	r6, [r3, #5]
	addeq	r2, r2, #1
	strheq	r2, [r3, #2]	@ movhi
	ldrb	r2, [r3, #5]	@ zero_extendqisi2
	adds	r2, r2, #8
	ldrh	r0, [r3, r2, lsl #1]
	b	.L719
.L724:
	.align	2
.L723:
	.word	.LANCHOR84
	.word	.LC0
	.word	.LANCHOR79
	.word	.LANCHOR69
	.word	.LANCHOR75
	.size	ftl_get_new_free_page, .-ftl_get_new_free_page
	.section	.text.ftl_ext_alloc_new_blk,"ax",%progbits
	.align	1
	.global	ftl_ext_alloc_new_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_alloc_new_blk, %function
ftl_ext_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	bl	ftl_alloc_sys_blk
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r4, r0
	cmp	r3, r2
	bls	.L726
	movw	r2, #981
	ldr	r1, .L728
	ldr	r0, .L728+4
	bl	printf
.L727:
	b	.L727
.L726:
	ldr	r5, .L728+8
	movs	r1, #0
	bl	ftl_erase_phy_blk
	ldr	r3, [r5]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sys_blk
	ldr	r3, [r5]
	movs	r0, #0
	strh	r4, [r3, #130]	@ movhi
	strh	r0, [r3, #140]	@ movhi
	pop	{r3, r4, r5, pc}
.L729:
	.align	2
.L728:
	.word	.LANCHOR85
	.word	.LC0
	.word	.LANCHOR46
	.size	ftl_ext_alloc_new_blk, .-ftl_ext_alloc_new_blk
	.section	.text.ftl_total_vpn_update,"ax",%progbits
	.align	1
	.global	ftl_total_vpn_update
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_total_vpn_update, %function
ftl_total_vpn_update:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L737
	push	{r4, r5, r6, r7, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L731
	cbnz	r0, .L731
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, r7, pc}
.L731:
	ldr	r2, .L737+4
	movs	r3, #0
	strh	r3, [r1]	@ movhi
	movw	ip, #65535
	mov	r1, r3
	ldrh	r5, [r2]
	ldr	r2, .L737+8
	ldr	r6, [r2]
	ldr	r2, .L737+12
	ldr	r7, [r2]
	mov	r2, r3
.L733:
	uxth	r0, r3
	cmp	r5, r0
	bhi	.L736
	ldr	r3, .L737+16
	ldr	r3, [r3]
	str	r1, [r3, #524]
	str	r2, [r3, #528]
	pop	{r4, r5, r6, r7, pc}
.L736:
	ldrh	r0, [r6, r3, lsl #1]
	cmp	r0, ip
	beq	.L734
	add	r4, r7, r3, lsl #2
	ldrb	r4, [r4, #2]	@ zero_extendqisi2
	and	r4, r4, #224
	cmp	r4, #160
	ite	eq
	addeq	r2, r2, r0
	addne	r1, r1, r0
.L734:
	adds	r3, r3, #1
	b	.L733
.L738:
	.align	2
.L737:
	.word	.LANCHOR86
	.word	.LANCHOR54
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LANCHOR60
	.size	ftl_total_vpn_update, .-ftl_total_vpn_update
	.section	.text.ftl_debug_info_fill,"ax",%progbits
	.align	1
	.global	ftl_debug_info_fill
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_debug_info_fill, %function
ftl_debug_info_fill:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	ftl_debug_info_fill, .-ftl_debug_info_fill
	.section	.text.ftl_vpn_update,"ax",%progbits
	.align	1
	.global	ftl_vpn_update
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vpn_update, %function
ftl_vpn_update:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L741
	ldr	r3, [r3]
	ldrh	r0, [r3, r0, lsl #1]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L742:
	.align	2
.L741:
	.word	.LANCHOR56
	.size	ftl_vpn_update, .-ftl_vpn_update
	.section	.text.ftl_vpn_decrement,"ax",%progbits
	.align	1
	.global	ftl_vpn_decrement
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vpn_decrement, %function
ftl_vpn_decrement:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #65535
	push	{r4, lr}
	cmp	r0, r3
	mov	r1, r0
	beq	.L744
	ldr	r3, .L749
	ldr	r3, [r3]
	ldrh	r4, [r3, r0, lsl #1]
	cbnz	r4, .L745
	mov	r2, r4
	ldr	r0, .L749+4
	bl	printf
.L748:
	movs	r0, #0
	pop	{r4, pc}
.L745:
	subs	r4, r4, #1
	strh	r4, [r3, r0, lsl #1]	@ movhi
.L744:
	ldr	r2, .L749+8
	ldrh	r0, [r2]
	cmp	r1, r0
	beq	.L748
	movw	r3, #65535
	cmp	r0, r3
	bne	.L747
	strh	r1, [r2]	@ movhi
	b	.L748
.L747:
	bl	ftl_vpn_update
	adds	r0, r0, #0
	strh	r1, [r2]	@ movhi
	it	ne
	movne	r0, #1
	pop	{r4, pc}
.L750:
	.align	2
.L749:
	.word	.LANCHOR56
	.word	.LC17
	.word	.LANCHOR87
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",%progbits
	.align	1
	.global	lpa_hash_update_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	uxtb	ip, r0
	ldr	r4, .L762
	movw	r6, #65535
	mov	fp, r6
	ldr	r5, .L762+4
	ldr	lr, [r4]
	ldr	r4, .L762+8
	ldrh	r3, [r5, ip, lsl #1]
	ldr	r4, [r4]
.L752:
	cmp	r3, fp
	beq	.L756
	ldr	r7, [lr, r3, lsl #2]
	add	r8, lr, r3, lsl #2
	cmp	r0, r7
	bne	.L753
	cmp	r6, fp
	mov	r10, #-1
	ite	eq
	ldrheq	r6, [r4, r3, lsl #1]
	ldrhne	r7, [r4, r3, lsl #1]
	str	r10, [r8]
	ite	eq
	strheq	r6, [r5, ip, lsl #1]	@ movhi
	strhne	r7, [r4, r6, lsl #1]	@ movhi
	movw	r6, #65535
	strh	r6, [r4, r3, lsl #1]	@ movhi
.L756:
	ldrh	r3, [r5, ip, lsl #1]
	str	r0, [lr, r2, lsl #2]
	strh	r2, [r5, ip, lsl #1]	@ movhi
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r3, r1, #1
	beq	.L758
	ldr	r3, .L762+12
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, .L762+16
	lsr	r0, r1, r0
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L758:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L753:
	mov	r6, r3
	ldrh	r3, [r4, r3, lsl #1]
	b	.L752
.L763:
	.align	2
.L762:
	.word	.LANCHOR82
	.word	.LANCHOR81
	.word	.LANCHOR83
	.word	.LANCHOR71
	.word	.LANCHOR70
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_write_completed,"ax",%progbits
	.align	1
	.global	ftl_write_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_completed, %function
ftl_write_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, .L772
	ldr	r6, .L772+4
.L765:
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L771
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L771:
	movs	r2, #48
	add	r5, r3, r3, lsl #1
	muls	r3, r2, r3
	add	r5, r6, r5, lsl #4
	adds	r4, r6, r3
	ldrb	r3, [r6, r3]	@ zero_extendqisi2
	strb	r3, [r7]
	ldr	r3, [r4, #36]
	adds	r3, r3, #1
	bne	.L766
	ldr	r3, .L772+8
	mov	r8, #1
	ldr	r10, [r4, #24]
	ldrh	r0, [r3]
	ldr	r3, .L772+12
	rsb	r2, r0, #21
	lsl	r2, r8, r2
	lsr	r0, r10, r0
	ldrb	r1, [r3]	@ zero_extendqisi2
	subs	r2, r2, #1
	ands	r0, r0, r2
	bl	__aeabi_uidiv
	uxth	fp, r0
	mov	r3, r10
	ldr	r2, [r4, #20]
	mov	r1, fp
	ldr	r0, .L772+16
	bl	printf
	movs	r2, #0
	mov	r1, r8
	mov	r0, fp
	bl	gc_add_sblk
	ldr	r3, .L772+20
	ldr	r3, [r3]
	ldrh	r2, [r3, #16]
	cmp	r2, fp
	bne	.L767
	movs	r2, #0
	strh	r2, [r3, #22]	@ movhi
.L768:
	mov	r0, r5
	bl	ftl_write_buf
	b	.L765
.L767:
	ldrh	r2, [r3, #48]
	cmp	r2, fp
	itt	eq
	moveq	r2, #0
	strheq	r2, [r3, #54]	@ movhi
	b	.L768
.L766:
	ldrh	r2, [r4, #32]
	ldr	r1, [r4, #28]
	ldr	r0, [r4, #20]
	bl	lpa_hash_update_ppa
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	lsls	r2, r3, #29
	bpl	.L770
	bic	r3, r3, #2
	strb	r3, [r4, #2]
	b	.L765
.L770:
	mov	r0, r5
	bl	buf_free
	b	.L765
.L773:
	.align	2
.L772:
	.word	.LANCHOR88
	.word	.LANCHOR36
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LC18
	.word	.LANCHOR60
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.ftl_mask_bad_block,"ax",%progbits
	.align	1
	.global	ftl_mask_bad_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ubfx	r4, r0, #21, #3
	ldr	r3, .L780
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r1, r2, #21
	lsls	r3, r3, r1
	lsrs	r0, r0, r2
	ldr	r2, .L780+4
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r3, .L780+8
	uxtb	r5, r0
	ldr	r3, [r3]
	lsls	r3, r3, #17
	bpl	.L775
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L780+12
	bl	printf
.L775:
	ldr	r3, .L780+16
	ldrh	r3, [r3]
	cmp	r3, r5
	bls	.L774
	ldr	r3, .L780+20
	ldr	r2, [r3]
	movs	r3, #1
	lsls	r3, r3, r4
	add	r2, r2, r5, lsl #2
	ldrb	r4, [r2, #3]	@ zero_extendqisi2
	orrs	r4, r4, r3
	strb	r4, [r2, #3]
.L774:
	pop	{r3, r4, r5, pc}
.L781:
	.align	2
.L780:
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR22
	.word	.LC19
	.word	.LANCHOR54
	.word	.LANCHOR57
	.size	ftl_mask_bad_block, .-ftl_mask_bad_block
	.section	.text.print_ftl_debug_info,"ax",%progbits
	.align	1
	.global	print_ftl_debug_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	print_ftl_debug_info, %function
print_ftl_debug_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L783
	push	{r4, r5, r6, lr}
	sub	sp, sp, #32
	ldr	r4, .L783+4
	ldr	r5, [r3]
	ldr	r0, [r4]
	ldr	r6, [r5, #528]
	ldrh	r3, [r0, #116]
	ldrh	r2, [r0, #118]
	ldrh	r1, [r0, #114]
	str	r6, [sp, #16]
	ldr	r5, [r5, #524]
	str	r5, [sp, #12]
	ldrh	r5, [r0, #120]
	str	r5, [sp, #8]
	ldrh	r5, [r0, #124]
	str	r5, [sp, #4]
	ldrh	r0, [r0, #122]
	str	r0, [sp]
	ldr	r0, .L783+8
	bl	printf
	ldr	r1, [r4]
	ldr	r3, .L783+12
	ldr	r0, .L783+16
	ldr	r2, [r1, #64]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #4]
	ldr	r2, [r1, #8]
	str	r2, [sp]
	ldr	r2, [r1, #28]
	ldr	r1, [r1, #20]
	bl	printf
	ldr	r1, [r4]
	ldr	r0, .L783+20
	ldr	r3, [r1, #16]
	ldr	r2, [r1, #60]
	ldr	r1, [r1, #52]
	lsrs	r3, r3, #11
	bl	printf
	ldr	r2, [r4]
	ldrh	r0, [r2, #98]
	ldrh	r3, [r2, #88]
	ldrh	r1, [r2, #74]
	str	r0, [sp, #24]
	ldrh	r0, [r2, #94]
	str	r0, [sp, #20]
	ldrh	r0, [r2, #90]
	str	r0, [sp, #16]
	ldr	r0, [r2, #80]
	str	r0, [sp, #12]
	ldrh	r0, [r2, #72]
	str	r0, [sp, #8]
	ldrh	r0, [r2, #96]
	str	r0, [sp, #4]
	ldrh	r0, [r2, #92]
	str	r0, [sp]
	ldr	r0, .L783+24
	ldr	r2, [r2, #84]
	bl	printf
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, pc}
.L784:
	.align	2
.L783:
	.word	.LANCHOR60
	.word	.LANCHOR46
	.word	.LC20
	.word	.LANCHOR89
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.size	print_ftl_debug_info, .-print_ftl_debug_info
	.section	.text.sblk_init,"ax",%progbits
	.align	1
	.global	sblk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_init, %function
sblk_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L786
	movs	r3, #255
	movs	r0, #0
	strb	r3, [r2]
	ldr	r2, .L786+4
	strb	r3, [r2]
	ldr	r2, .L786+8
	strb	r3, [r2]
	ldr	r2, .L786+12
	strb	r3, [r2]
	bx	lr
.L787:
	.align	2
.L786:
	.word	.LANCHOR90
	.word	.LANCHOR88
	.word	.LANCHOR51
	.word	.LANCHOR62
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",%progbits
	.align	1
	.global	dump_sblk_queue
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r4, .L797
	ldr	r0, .L797+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L788
	ldr	r5, .L797+8
	add	r4, r4, r4, lsl #1
	ldr	r6, .L797+12
	add	r4, r5, r4, lsl #4
.L790:
	ldr	r3, [r4, #24]
	mov	r0, r6
	ldrb	r2, [r4, #42]	@ zero_extendqisi2
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	bl	printf
	ldrb	r4, [r4]	@ zero_extendqisi2
	cmp	r4, #255
	beq	.L788
	add	r4, r4, r4, lsl #1
	add	r4, r5, r4, lsl #4
	b	.L790
.L788:
	pop	{r4, r5, r6, pc}
.L798:
	.align	2
.L797:
	.word	.LANCHOR90
	.word	.LC24
	.word	.LANCHOR36
	.word	.LC25
	.size	dump_sblk_queue, .-dump_sblk_queue
	.section	.text.queue_lun_state,"ax",%progbits
	.align	1
	.global	queue_lun_state
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_lun_state, %function
queue_lun_state:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L816
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	beq	.L808
	ldr	r3, .L816+4
	ubfx	r10, r0, #21, #3
	ldr	lr, .L816+12
	mov	ip, #48
	ldrh	r7, [r3]
	movs	r3, #1
	mov	r8, lr
	rsb	r2, r7, #21
	lsls	r3, r3, r2
	ldr	r2, .L816+8
	subs	r3, r3, #1
	ldrb	r6, [r2]	@ zero_extendqisi2
	asr	r2, r0, r7
	uxth	r3, r3
	subs	r6, r6, #1
	uxth	r6, r6
	ands	r2, r2, r6
	ands	r2, r2, r3
.L807:
	mla	r0, ip, r5, lr
	ldr	r4, [r0, #24]
	ubfx	fp, r4, #21, #3
	cmp	r10, fp
	bne	.L801
	lsrs	r4, r4, r7
	ldrb	r0, [r0, #42]	@ zero_extendqisi2
	ands	r4, r4, r6
	ands	r4, r4, r3
	cmp	r2, r4
	bne	.L802
	cmp	r1, #1
	bne	.L799
	cmp	r0, #6
	beq	.L801
	cmp	r0, #8
	beq	.L801
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L802:
	cmp	r1, #3
	bhi	.L801
	tbb	[pc, r1]
.L804:
	.byte	(.L803-.L804)/2
	.byte	(.L805-.L804)/2
	.byte	(.L806-.L804)/2
	.byte	(.L799-.L804)/2
	.p2align 1
.L803:
	cmp	r0, #2
	beq	.L801
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L805:
	cmp	r0, #6
	beq	.L801
	cmp	r0, #8
	beq	.L801
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L806:
	cmp	r0, #10
	bne	.L799
.L801:
	mul	r5, ip, r5
	ldrb	r5, [r8, r5]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L807
.L808:
	movs	r0, #0
.L799:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L817:
	.align	2
.L816:
	.word	.LANCHOR90
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR36
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",%progbits
	.align	1
	.global	queue_remove_completed_req
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, lr}
	ldr	r5, .L834
	ldrb	r0, [r5]	@ zero_extendqisi2
	cmp	r0, #255
	beq	.L818
	movs	r1, #48
	ldr	r2, .L834+4
	muls	r1, r0, r1
	adds	r3, r2, r1
	ldrb	r4, [r3, #42]	@ zero_extendqisi2
	subs	r4, r4, #11
	cmp	r4, #1
	bhi	.L818
	ldrb	r4, [r2, r1]	@ zero_extendqisi2
	strb	r4, [r5]
	movs	r4, #255
	strb	r4, [r2, r1]
	ldrb	r1, [r3, #43]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L820
	ldrh	r3, [r3, #34]
	cbnz	r3, .L821
	ldr	r3, .L834+8
.L833:
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #255
	bne	.L823
	movs	r1, #48
	mla	r2, r1, r0, r2
	ldrb	r2, [r2, #1]	@ zero_extendqisi2
	strb	r2, [r3]
	pop	{r4, r5, pc}
.L821:
	ldr	r3, .L834+12
	b	.L833
.L820:
	cbnz	r1, .L818
	ldr	r3, [r3, #20]
	adds	r3, r3, #1
	beq	.L818
	ldr	r3, .L834+16
	b	.L833
.L823:
	movs	r3, #48
.L826:
	mov	r4, r1
	muls	r1, r3, r1
	ldrb	r1, [r2, r1]	@ zero_extendqisi2
	cmp	r1, #255
	bne	.L826
	muls	r4, r3, r4
	mla	r3, r3, r0, r2
	ldrb	r3, [r3, #1]	@ zero_extendqisi2
	strb	r3, [r2, r4]
	pop	{r4, r5, pc}
.L818:
	pop	{r4, r5, pc}
.L835:
	.align	2
.L834:
	.word	.LANCHOR90
	.word	.LANCHOR36
	.word	.LANCHOR88
	.word	.LANCHOR62
	.word	.LANCHOR51
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",%progbits
	.align	1
	.global	pm_alloc_new_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r4, .L854
	ldr	r1, .L854+4
	ldr	r2, [r4]
	ldrb	r1, [r1]	@ zero_extendqisi2
	ldrh	r3, [r2, #690]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r1, r3
	strh	r3, [r2, #690]	@ movhi
	bls	.L837
	add	r3, r3, #336
	ldrh	r2, [r2, r3, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L838
.L837:
	ldr	r7, .L854+8
	ldr	r6, .L854+12
.L852:
	movs	r0, #1
	bl	ftl_alloc_sblk
	movs	r1, #0
	mov	r5, r0
	bl	ftl_erase_sblk
	ldr	r1, [r4]
	mov	r0, r5
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	uxth	r0, r0
	cbnz	r0, .L839
	mov	r1, r5
	mov	r0, r7
	bl	printf
	ldr	r3, [r6]
	add	r5, r3, r5, lsl #2
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r5, #2]
	b	.L852
.L839:
	ldr	r2, [r4]
	movs	r0, #1
	ldr	r1, .L854+16
	movs	r3, #0
	strh	r3, [r2, #690]	@ movhi
	str	r0, [r1]
	add	r1, r2, #416
	movw	r0, #65535
.L841:
	ldrh	r6, [r1], #2
	cmp	r6, r0
	beq	.L840
	adds	r3, r3, #1
	cmp	r3, #128
	bne	.L841
	movs	r2, #188
	ldr	r1, .L854+20
	ldr	r0, .L854+24
	bl	printf
.L843:
	b	.L843
.L844:
	movs	r2, #0
	strh	r3, [r1, #692]	@ movhi
	strh	r2, [r1, #696]	@ movhi
	ldr	r2, .L854+28
	ldrh	r2, [r2]
	rsb	r2, r2, #21
	asr	r0, r3, r2
	strh	r0, [r1, #694]	@ movhi
	ldr	r1, .L854+32
	ldr	r1, [r1]
	lsls	r1, r1, #19
	bpl	.L849
	movs	r1, #1
	uxth	r0, r0
	lsl	r2, r1, r2
	mov	r1, r3
	str	r0, [sp]
	subs	r2, r2, #1
	ldr	r0, .L854+36
	bl	printf
.L849:
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L840:
	adds	r3, r3, #208
	strh	r5, [r2, r3, lsl #1]	@ movhi
	ldrh	r3, [r2, #688]
	adds	r3, r3, #1
	strh	r3, [r2, #688]	@ movhi
.L838:
	ldr	r1, [r4]
	movw	r0, #65533
	ldrh	r3, [r1, #690]
	add	r3, r3, #336
	ldrh	r3, [r1, r3, lsl #1]
	subs	r2, r3, #1
	uxth	r2, r2
	cmp	r2, r0
	bls	.L844
	movs	r2, #193
	ldr	r1, .L854+20
	ldr	r0, .L854+24
	bl	printf
.L845:
	b	.L845
.L855:
	.align	2
.L854:
	.word	.LANCHOR46
	.word	.LANCHOR69
	.word	.LC26
	.word	.LANCHOR57
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LC0
	.word	.LANCHOR71
	.word	.LANCHOR22
	.word	.LC27
	.size	pm_alloc_new_blk, .-pm_alloc_new_blk
	.section	.text.pm_select_ram_region,"ax",%progbits
	.align	1
	.global	pm_select_ram_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_select_ram_region, %function
pm_select_ram_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L867
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #0
	movw	r4, #65535
	mov	r1, r2
.L858:
	ldrh	r5, [r2, r3, lsl #3]
	uxth	r0, r3
	cmp	r5, r4
	beq	.L857
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L858
	movs	r2, #0
	mov	r4, #32768
	mov	r0, r3
.L860:
	add	r3, r1, r2, lsl #3
	uxth	r5, r2
	ldrh	r3, [r3, #2]
	lsls	r6, r3, #16
	bmi	.L859
	cmp	r3, r4
	itt	cc
	movcc	r4, r3
	movcc	r0, r5
.L859:
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L860
	cmp	r0, #32
	bne	.L857
	ldr	r3, .L867+4
	mov	r2, #-1
	ldrb	r5, [r3]	@ zero_extendqisi2
	movs	r3, #0
.L862:
	add	r4, r1, r3, lsl #3
	uxth	r6, r3
	ldrh	r4, [r4, #2]
	cmp	r4, r2
	bcs	.L861
	ldrh	r7, [r1, r3, lsl #3]
	cmp	r7, r5
	itt	ne
	movne	r2, r4
	movne	r0, r6
.L861:
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L862
	cmp	r0, #32
	bne	.L857
	movw	r2, #289
	ldr	r1, .L867+8
	ldr	r0, .L867+12
	bl	printf
.L863:
	b	.L863
.L857:
	pop	{r3, r4, r5, r6, r7, pc}
.L868:
	.align	2
.L867:
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LC0
	.size	pm_select_ram_region, .-pm_select_ram_region
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
	.section	.text.flash_lsb_page_tbl_build,"ax",%progbits
	.align	1
	.global	flash_lsb_page_tbl_build
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_lsb_page_tbl_build, %function
flash_lsb_page_tbl_build:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L905
	cbnz	r0, .L871
.L872:
	strh	r0, [r4, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L872
.L878:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L905+4
	bl	ftl_memset
	ldr	r1, .L905+4
	movs	r3, #0
.L873:
	ldrh	r2, [r4, r3, lsl #1]
	adds	r3, r3, #1
	cmp	r3, #256
	strh	r2, [r1, r2, lsl #1]	@ movhi
	bne	.L873
	pop	{r4, pc}
.L871:
	cmp	r0, #1
	bne	.L874
	movs	r3, #0
.L877:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L875
	tst	r2, #1
	ite	ne
	movne	r1, #3
	moveq	r1, #2
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L875:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L877
	b	.L878
.L874:
	cmp	r0, #2
	bne	.L879
	movs	r2, #0
.L881:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r4, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L881
	b	.L878
.L879:
	cmp	r0, #3
	bne	.L882
	movs	r3, #0
.L885:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L883
	tst	r2, #1
	ite	ne
	movne	r1, #5
	moveq	r1, #4
	rsb	r2, r1, r2, lsl #1
	uxth	r2, r2
.L883:
	strh	r2, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L885
	b	.L878
.L882:
	cmp	r0, #4
	mov	r3, #0
	bne	.L886
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #3
	strh	r3, [r4, #6]	@ movhi
	movs	r3, #5
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #7
	strh	r3, [r4, #12]	@ movhi
	mov	r2, r4
	movs	r3, #8
	strh	r0, [r4, #8]	@ movhi
	strh	r3, [r2, #14]!	@ movhi
.L888:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L888
	b	.L878
.L886:
	cmp	r0, #5
	bne	.L889
.L890:
	strh	r3, [r4, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L890
	ldr	r2, .L905+8
.L891:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L891
	b	.L878
.L889:
	cmp	r0, #8
	bne	.L878
.L892:
	strh	r3, [r4, r3]	@ movhi
	adds	r3, r3, #2
	cmp	r3, #512
	bne	.L892
	b	.L878
.L906:
	.align	2
.L905:
	.word	.LANCHOR14
	.word	.LANCHOR96
	.word	.LANCHOR14+30
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",%progbits
	.align	1
	.global	flash_die_info_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_die_info_init, %function
flash_die_info_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r4, .L920
	ldr	r6, .L920+4
	ldrh	r3, [r4, #26]
	add	r10, r4, #1
	ldr	r7, .L920+8
	ldrb	r1, [r4, #12]	@ zero_extendqisi2
	ldrh	r0, [r4, #10]
	strh	r3, [r7]	@ movhi
	strb	r5, [r6]
	bl	__aeabi_idiv
	ldr	r3, .L920+12
	movs	r2, #8
	mov	r1, r5
	ldr	r8, .L920+32
	ldr	fp, .L920+20
	strh	r0, [r3]	@ movhi
	ldr	r0, .L920+16
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L920+20
	bl	ftl_memset
	ldrb	r3, [r4]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L920+16
.L909:
	ldr	r2, [sp]
	add	r1, r8, r5, lsl #3
	mov	r0, r10
	str	r3, [sp, #4]
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L908
	ldrb	r2, [r6]	@ zero_extendqisi2
	adds	r1, r2, #1
	str	r0, [fp, r2, lsl #2]
	strb	r1, [r6]
	strb	r5, [r3, r2]
.L908:
	adds	r5, r5, #1
	cmp	r5, #4
	bne	.L909
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L910
.L914:
	ldrb	r2, [r4, #13]	@ zero_extendqisi2
	ldrb	r3, [r6]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrh	r2, [r4, #14]
	smulbb	r3, r3, r2
	ldr	r2, .L920+24
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L910:
	ldrh	r5, [r7]
	movs	r7, #0
	ldrb	r3, [r4, #13]	@ zero_extendqisi2
	ldrb	r8, [r4, #23]	@ zero_extendqisi2
	ldr	fp, .L920+16
	muls	r3, r5, r3
	ldrh	r5, [r4, #14]
	and	r5, r5, #65280
	muls	r5, r3, r5
	ldr	r3, .L920+28
	lsl	r10, r5, #1
.L913:
	ldr	r1, .L920+32
	mov	r0, r3
	ldr	r2, [sp]
	str	r3, [sp, #4]
	add	r1, r1, r7, lsl #3
	bl	flash_mem_cmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L911
	ldrb	r2, [r6]	@ zero_extendqisi2
	cmp	r8, #0
	ite	eq
	moveq	r1, r5
	movne	r1, r10
	ldr	r0, .L920+20
	strb	r7, [fp, r2]
	str	r1, [r0, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r6]
.L911:
	adds	r7, r7, #1
	cmp	r7, #4
	bne	.L913
	b	.L914
.L921:
	.align	2
.L920:
	.word	.LANCHOR19
	.word	.LANCHOR8
	.word	.LANCHOR13
	.word	.LANCHOR97
	.word	.LANCHOR10
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR19+1
	.word	.LANCHOR26
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.FlashReadFacBbtData,"ax",%progbits
	.align	1
	.global	FlashReadFacBbtData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	lsrs	r2, r2, #3
	movs	r1, #0
	bl	ftl_memset
	movs	r0, #0
	pop	{r3, pc}
	.size	FlashReadFacBbtData, .-FlashReadFacBbtData
	.section	.text.lpa_hash_init,"ax",%progbits
	.align	1
	.global	lpa_hash_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_hash_init, %function
lpa_hash_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r2, #512
	movs	r1, #255
	ldr	r0, .L924
	bl	ftl_memset
	ldr	r3, .L924+4
	movs	r1, #255
	ldr	r2, .L924+8
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L924+12
	ldr	r0, [r3]
	lsls	r2, r2, #2
	pop	{r3, lr}
	b	ftl_memset
.L925:
	.align	2
.L924:
	.word	.LANCHOR81
	.word	.LANCHOR79
	.word	.LANCHOR69
	.word	.LANCHOR83
	.size	lpa_hash_init, .-lpa_hash_init
	.section	.text.lpa_rebuild_hash,"ax",%progbits
	.align	1
	.global	lpa_rebuild_hash
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	lpa_rebuild_hash, %function
lpa_rebuild_hash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L937
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L927
	movs	r3, #0
	movs	r2, #190
	ldr	r1, .L937+4
	ldr	r0, .L937+8
	bl	printf
.L927:
	ldr	r6, .L937+12
	mov	r2, #512
	ldr	r4, .L937+16
	movs	r1, #255
	ldr	r0, .L937+20
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r5, .L937+24
	muls	r2, r3, r2
	ldr	r0, [r5]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, .L937+28
	movs	r2, #0
	ldrb	r6, [r6]	@ zero_extendqisi2
	ldr	ip, [r5]
	ldr	r7, [r3]
	ldr	r0, .L937+20
.L928:
	ldrh	r3, [r4]
	uxth	r5, r2
	mov	r1, r5
	muls	r3, r6, r3
	cmp	r5, r3, lsl #1
	blt	.L930
	pop	{r3, r4, r5, r6, r7, pc}
.L930:
	ldr	r3, [r7, r1, lsl #2]
	adds	r2, r2, #1
	cmp	r3, #-1
	itttt	ne
	uxtbne	r3, r3
	ldrhne	lr, [r0, r3, lsl #1]
	strhne	r5, [r0, r3, lsl #1]	@ movhi
	strhne	lr, [ip, r1, lsl #1]	@ movhi
	b	.L928
.L938:
	.align	2
.L937:
	.word	.LANCHOR22
	.word	.LANCHOR100
	.word	.LC28
	.word	.LANCHOR69
	.word	.LANCHOR79
	.word	.LANCHOR81
	.word	.LANCHOR83
	.word	.LANCHOR82
	.size	lpa_rebuild_hash, .-lpa_rebuild_hash
	.section	.text.ftl_open_sblk_init,"ax",%progbits
	.align	1
	.global	ftl_open_sblk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r8, .L945+12
	mov	r6, r1
	movs	r7, #0
.L940:
.L943:
	mov	r0, r6
	ldr	r10, .L945+16
	bl	ftl_alloc_sblk
	movs	r1, #0
	mov	r5, r0
	bl	ftl_erase_sblk
	add	r1, r4, #16
	mov	r0, r5
	bl	ftl_get_blk_list_in_sblk
	ldr	r1, .L945
	cmp	r6, #2
	ldrh	r2, [r8]
	uxtb	r0, r0
	strh	r5, [r4]	@ movhi
	ite	eq
	moveq	r3, #0
	ldrbne	r3, [r1]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	strb	r0, [r4, #9]
	smulbb	r0, r0, r2
	strh	r7, [r4, #2]	@ movhi
	it	ne
	smulbbne	r3, r3, r2
	strb	r7, [r4, #5]
	mul	r2, r2, r1
	ldr	r1, .L945+4
	strh	r0, [r4, #6]	@ movhi
	it	ne
	uxthne	r3, r3
	strh	r7, [r4, #10]	@ movhi
	ldr	r0, [r1]
	movs	r1, #255
	strh	r3, [r4, #12]	@ movhi
	lsls	r2, r2, #2
	strb	r6, [r4, #4]
	add	r0, r0, r3, lsl #2
	bl	ftl_memset
	ldr	r3, [r10]
	ldrh	r2, [r4, #6]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cbnz	r3, .L939
	mov	r1, r5
	ldr	r0, .L945+8
	bl	printf
	ldr	r3, [r10]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	movs	r3, #7
	strb	r3, [r4, #4]
	b	.L943
.L939:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L946:
	.align	2
.L945:
	.word	.LANCHOR69
	.word	.LANCHOR82
	.word	.LC26
	.word	.LANCHOR79
	.word	.LANCHOR56
	.size	ftl_open_sblk_init, .-ftl_open_sblk_init
	.section	.text.pm_free_sblk,"ax",%progbits
	.align	1
	.global	pm_free_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_free_sblk, %function
pm_free_sblk:
	@ args = 0, pretend = 0, frame = 280
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L962
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #280
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, #128
	bls	.L948
	movs	r2, #74
	ldr	r1, .L962+4
	ldr	r0, .L962+8
	bl	printf
.L949:
	b	.L949
.L948:
	mov	r2, #256
	movs	r1, #0
	add	r0, sp, #24
	movs	r4, #1
	bl	ftl_memset
	ldr	r3, .L962+12
	add	r10, sp, #24
	ldr	r0, .L962+16
	ldr	r1, .L962+20
	ldrh	r7, [r3]
	ldr	r6, [r0]
	ldr	r5, [sp, #4]
	rsb	r3, r7, #21
	str	r0, [sp, #8]
	lsls	r4, r4, r3
	ldrh	r2, [r6, #698]
	ldrb	r3, [r1]	@ zero_extendqisi2
	add	r8, r6, #704
	ldrh	fp, [r5]
	subs	r4, r4, #1
	movs	r5, #0
	str	r1, [sp, #12]
.L950:
	uxth	r1, r5
	cmp	r2, r1
	bhi	.L954
	ldr	r6, .L962+24
	movs	r5, #0
	ldr	r7, .L962+28
	mov	r10, r5
	ldrb	r4, [r6]	@ zero_extendqisi2
	ldrh	r3, [r7]
	smulbb	r4, r4, r3
	uxth	r4, r4
.L955:
	ldr	r3, [sp, #4]
	uxth	r2, r5
	ldrh	r3, [r3]
	cmp	r3, r2
	bhi	.L960
	mov	r0, r10
	add	sp, sp, #280
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L954:
	ldr	r0, [r8], #4
	mov	r1, r3
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	lsrs	r0, r0, r7
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	uxth	r0, r0
	ldr	r2, [sp, #20]
	add	lr, r6, #416
	movs	r1, #0
.L951:
	uxth	ip, r1
	cmp	fp, ip
	bhi	.L953
	adds	r5, r5, #1
	b	.L950
.L953:
	ldrh	ip, [lr], #2
	cmp	r0, ip
	ittt	eq
	ldrheq	ip, [r10, r1, lsl #1]
	addeq	ip, ip, #1
	strheq	ip, [r10, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	b	.L951
.L960:
	ldr	r3, [sp, #8]
	str	r2, [sp, #20]
	ldr	r0, [r3]
	uxth	r3, r5
	add	fp, r3, #208
	str	r3, [sp, #16]
	ldr	r3, [sp, #12]
	ldrh	r8, [r0, fp, lsl #1]
	ldrh	r0, [r0, #692]
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_idiv
	cmp	r0, r8
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	bne	.L956
	ldrh	r0, [r7]
	ldrb	r1, [r6]	@ zero_extendqisi2
	smulbb	r1, r1, r0
	add	r0, sp, #24
	strh	r1, [r0, r3, lsl #1]	@ movhi
.L956:
	add	r1, sp, #24
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r4, r3
	bls	.L957
	cbnz	r3, .L961
.L959:
	movw	r3, #65535
	cmp	r8, r3
	str	r3, [sp, #16]
	beq	.L958
	mov	r0, r8
	bl	ftl_free_sblk
	ldr	r3, [sp, #8]
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	strh	r3, [r2, fp, lsl #1]	@ movhi
	ldrh	r3, [r2, #688]
	subs	r3, r3, #1
	strh	r3, [r2, #688]	@ movhi
	b	.L958
.L957:
	cmp	r3, #0
	beq	.L959
.L958:
	adds	r5, r5, #1
	b	.L955
.L961:
	mov	r10, r2
	mov	r4, r3
	b	.L958
.L963:
	.align	2
.L962:
	.word	.LANCHOR101
	.word	.LANCHOR102
	.word	.LC0
	.word	.LANCHOR71
	.word	.LANCHOR46
	.word	.LANCHOR70
	.word	.LANCHOR69
	.word	.LANCHOR79
	.size	pm_free_sblk, .-pm_free_sblk
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
	.section	.text.flash_into_data_init,"ax",%progbits
	.align	1
	.global	flash_into_data_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_into_data_init, %function
flash_into_data_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r2, #2048
	ldr	r4, .L966
	movs	r1, #0
	ldr	r0, [r4]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L966+4
	ldr	r1, .L966+8
	adds	r0, r0, #80
	str	r3, [r0, #-80]
	mov	r3, #2032
	str	r3, [r0, #-72]
	movs	r3, #1
	strh	r3, [r0, #-64]	@ movhi
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L966+12
	pop	{r4, lr}
	adds	r0, r0, #48
	b	ftl_memcpy
.L967:
	.align	2
.L966:
	.word	.LANCHOR5
	.word	1398362953
	.word	.LANCHOR103
	.word	.LANCHOR19
	.size	flash_into_data_init, .-flash_into_data_init
	.section	.text.ftl_memcpy32,"ax",%progbits
	.align	1
	.global	ftl_memcpy32
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, lr}
.L969:
	cmp	r3, r2
	bne	.L970
	pop	{r4, pc}
.L970:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L969
	.size	ftl_memcpy32, .-ftl_memcpy32
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
	.section	.text.rknand_get_clk_rate,"ax",%progbits
	.align	1
	.global	rknand_get_clk_rate
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_get_clk_rate, %function
rknand_get_clk_rate:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L973
	bx	lr
.L974:
	.align	2
.L973:
	.word	148000000
	.size	rknand_get_clk_rate, .-rknand_get_clk_rate
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
	.section	.text.nandc_init,"ax",%progbits
	.align	1
	.global	nandc_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_init, %function
nandc_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r0, r1, r2, lr}
	str	r3, [sp, #4]
	movs	r2, #6
	ldr	r3, .L981
	ldr	r1, [r0, #352]
	strb	r2, [r3]
	ldr	r2, .L981+4
	str	r0, [r2]
	ldr	r2, .L981+8
	cmp	r1, r2
	ldr	r1, [r0, #128]
	itt	eq
	moveq	r2, #8
	strbeq	r2, [r3]
	ldr	r2, .L981+12
	cmp	r1, r2
	itt	eq
	moveq	r2, #9
	strbeq	r2, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L981+16
	cmp	r3, #9
	ldr	r3, .L981+20
	bne	.L979
	movs	r1, #1
	strb	r1, [r3]
	ldr	r3, [sp, #4]
	orr	r3, r3, #256
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	str	r3, [r0]
	movs	r3, #0
	str	r3, [r0, #520]
	movw	r3, #4225
	str	r3, [r0, #4]
	movw	r3, #8321
	str	r3, [r0, #8]
	movs	r3, #38
	str	r2, [r0, #80]
	str	r3, [r0, #84]
	movs	r3, #39
	str	r3, [r0, #84]
.L980:
	ldr	r3, .L981+24
	movs	r2, #1
	strb	r2, [r3]
	movs	r3, #0
	ldr	r2, .L981+28
	strh	r3, [r2]	@ movhi
	ldr	r2, .L981+32
	strb	r3, [r2]
	add	sp, sp, #12
	@ sp needed
	ldr	pc, [sp], #4
.L979:
	movs	r1, #0
	strb	r1, [r3]
	ldr	r3, [sp, #4]
	orr	r3, r3, #256
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	str	r3, [r0]
	movw	r3, #4225
	str	r1, [r0, #336]
	str	r3, [r0, #4]
	movw	r3, #8321
	str	r3, [r0, #344]
	movs	r3, #38
	str	r2, [r0, #304]
	str	r3, [r0, #308]
	movs	r3, #39
	str	r3, [r0, #308]
	mov	r0, #2048
	bl	ftl_malloc
	ldr	r3, .L981+36
	str	r0, [r3]
	b	.L980
.L982:
	.align	2
.L981:
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	1446522928
	.word	1446588464
	.word	1052675
	.word	.LANCHOR28
	.word	.LANCHOR29
	.word	.LANCHOR31
	.word	.LANCHOR27
	.word	.LANCHOR30
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",%progbits
	.align	1
	.global	buf_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	buf_init, %function
buf_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r4, .L986
	mov	r6, r5
	ldr	r7, .L986+4
	mov	r8, r4
.L984:
	ldrb	r0, [r7]	@ zero_extendqisi2
	uxtb	r3, r5
	strb	r6, [r4, #2]
	adds	r5, r5, #1
	adds	r2, r3, #1
	strb	r3, [r4, #1]
	strb	r2, [r4]
	adds	r4, r4, #48
	str	r6, [r4, #-40]
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r4, #-44]
	ldrb	r0, [r7]	@ zero_extendqisi2
	lsls	r0, r0, #1
	bl	ftl_malloc
	cmp	r5, #32
	str	r0, [r4, #-36]
	bne	.L984
	movs	r3, #255
	strb	r3, [r8, #1488]
	ldr	r3, .L986+8
	strb	r6, [r3]
	ldr	r3, .L986+12
	strb	r5, [r3]
	pop	{r4, r5, r6, r7, r8, pc}
.L987:
	.align	2
.L986:
	.word	.LANCHOR36
	.word	.LANCHOR45
	.word	.LANCHOR37
	.word	.LANCHOR38
	.size	buf_init, .-buf_init
	.section	.text.gc_init,"ax",%progbits
	.align	1
	.global	gc_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_init, %function
gc_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r5, #0
	ldr	r3, .L989
	mov	r1, r5
	mov	r2, #320
	ldr	r4, .L989+4
	strb	r5, [r3]
	ldr	r3, .L989+8
	mov	r0, r4
	strb	r5, [r3]
	bl	ftl_memset
	movw	r3, #65535
	str	r5, [r4, #8]
	strh	r3, [r4]	@ movhi
	ldr	r3, .L989+12
	ldr	r5, .L989+16
	ldrh	r3, [r3]
	lsrs	r2, r3, #2
	lsrs	r1, r3, #1
	strh	r2, [r4, #32]	@ movhi
	strh	r1, [r4, #34]	@ movhi
	ldr	r4, .L989+20
	ldrb	r0, [r4]	@ zero_extendqisi2
	smulbb	r3, r0, r3
	subs	r3, r3, #32
	strh	r3, [r5]	@ movhi
	ldr	r3, .L989+24
	ldr	r5, .L989+28
	strh	r1, [r3]	@ movhi
	ldr	r3, .L989+32
	strh	r2, [r3]	@ movhi
	ldrh	r3, [r5]
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L989+36
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L989+40
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L989+44
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L989+48
	str	r0, [r3]
	ldrh	r3, [r5]
	ldrb	r0, [r4]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L989+52
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L990:
	.align	2
.L989:
	.word	.LANCHOR67
	.word	.LANCHOR59
	.word	.LANCHOR104
	.word	.LANCHOR79
	.word	.LANCHOR105
	.word	.LANCHOR69
	.word	.LANCHOR106
	.word	.LANCHOR68
	.word	.LANCHOR58
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR65
	.word	.LANCHOR61
	.word	.LANCHOR109
	.size	gc_init, .-gc_init
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
	ldr	r3, .L995
	add	r1, r1, r0
	push	{r4, lr}
.L993:
	cmp	r0, r1
	bne	.L994
	mov	r0, r3
	pop	{r4, pc}
.L994:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L993
.L996:
	.align	2
.L995:
	.word	1204201446
	.size	js_hash, .-js_hash
	.section	.text.timer_get_time,"ax",%progbits
	.align	1
	.global	timer_get_time
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	timer_get_time, %function
timer_get_time:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	timer_get_time, .-timer_get_time
	.section	.text.FlashCs123Init,"ax",%progbits
	.align	1
	.global	FlashCs123Init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
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
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_get_capacity, %function
rk_ftl_get_capacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1001
	ldr	r0, [r3]
	bx	lr
.L1002:
	.align	2
.L1001:
	.word	.LANCHOR52
	.size	rk_ftl_get_capacity, .-rk_ftl_get_capacity
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
	movs	r5, #0
	ldr	r7, .L1012
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1004:
	cmp	r4, r10
	bne	.L1010
	ldr	r1, .L1012+4
	ldr	r0, .L1012+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1010:
	cbnz	r5, .L1005
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1012+12
	bl	printf
.L1005:
	cmp	r8, #4
	bne	.L1006
	ldr	r1, [r6, r4, lsl #2]
.L1011:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1009
	movs	r5, #0
	ldr	r1, .L1012+4
	ldr	r0, .L1012+8
	bl	printf
.L1009:
	adds	r4, r4, #1
	b	.L1004
.L1006:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1011
.L1013:
	.align	2
.L1012:
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC29
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.hynix_get_read_retry_default,"ax",%progbits
	.align	1
	.global	hynix_get_read_retry_default
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_get_read_retry_default, %function
hynix_get_read_retry_default:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1107
	cmp	r0, #2
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	mov	r1, #173
	mov	r2, #174
	mov	r6, r0
	ldr	r4, [r3]
	add	r3, r4, #128
	strb	r0, [r4, #112]
	str	r3, [sp, #8]
	mov	r3, #172
	strb	r3, [r4, #128]
	mov	r3, #175
	strb	r1, [r4, #129]
	strb	r2, [r4, #130]
	strb	r3, [r4, #131]
	bne	.L1015
	movs	r3, #167
	movs	r2, #247
	strb	r3, [r4, #128]
	ldr	r3, .L1107+4
	strb	r2, [r3, #17]
.L1069:
	mov	r10, #7
	b	.L1101
.L1015:
	cmp	r0, #3
	bne	.L1017
	add	r2, r4, #127
	movs	r3, #176
.L1018:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1018
.L1102:
	mov	r10, #8
	mov	fp, r10
.L1016:
	subs	r3, r6, #1
	cmp	r3, #1
	bhi	.L1023
	movs	r6, #0
.L1024:
	ldr	r3, .L1107+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r6
	cmp	r2, r3
	bhi	.L1029
.L1030:
	strb	fp, [r4, #113]
	strb	r10, [r4, #114]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1017:
	cmp	r0, #4
	bne	.L1019
	movs	r0, #204
	strb	r1, [r4, #133]
	strb	r0, [r4, #128]
	movs	r0, #191
	strb	r0, [r4, #129]
	movs	r0, #170
	strb	r0, [r4, #130]
	movs	r0, #171
	strb	r0, [r4, #131]
	movs	r0, #205
	strb	r0, [r4, #132]
	strb	r2, [r4, #134]
	strb	r3, [r4, #135]
	b	.L1102
.L1019:
	cmp	r0, #5
	bne	.L1020
	movs	r3, #56
	mov	r10, #8
	strb	r3, [r4, #128]
	movs	r3, #57
	strb	r3, [r4, #129]
	movs	r3, #58
	strb	r3, [r4, #130]
	movs	r3, #59
	strb	r3, [r4, #131]
.L1101:
	mov	fp, #4
	b	.L1016
.L1020:
	cmp	r0, #6
	bne	.L1021
	movs	r3, #14
	mov	r10, #12
	strb	r3, [r4, #128]
	movs	r3, #15
	strb	r3, [r4, #129]
	movs	r3, #16
	strb	r3, [r4, #130]
	movs	r3, #17
	strb	r3, [r4, #131]
	b	.L1101
.L1021:
	cmp	r0, #7
	bne	.L1069
	add	r2, r4, #127
	movs	r3, #176
.L1022:
	strb	r3, [r2, #1]!
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #184
	bne	.L1022
	movs	r3, #212
	mov	r10, #12
	strb	r3, [r4, #136]
	movs	r3, #213
	strb	r3, [r4, #137]
	mov	fp, #10
	b	.L1016
.L1029:
	ldr	r2, .L1107+12
	movs	r1, #160
	add	r8, fp, #-1
	add	r7, r4, #127
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	mla	r1, r1, r3, r4
	add	r2, r1, #144
	ldr	r1, [sp, #8]
	str	r2, [sp, #4]
	ldr	r2, .L1107+16
	uxtab	r8, r1, r8
	ldr	r5, [r2]
	ldr	r2, [sp, #4]
	add	r5, r5, r3, lsl #8
	subs	r2, r2, #1
	addw	r3, r5, #2056
.L1025:
	str	r2, [sp, #16]
	movs	r2, #55
	str	r2, [r3]
	ldrb	r0, [r7, #1]!	@ zero_extendqisi2
	str	r3, [sp, #12]
	str	r0, [r5, #2052]
	movs	r0, #80
	bl	timer_delay_ns
	ldr	r0, [r5, #2048]
	cmp	r8, r7
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #12]
	strb	r0, [r2, #1]!
	bne	.L1025
	ldr	r0, [sp, #4]
	movs	r2, #0
	ldr	ip, .L1107+4
.L1026:
	movs	r3, #1
	add	r7, ip, r2
.L1027:
	ldrb	r5, [r7, r3, lsl #2]	@ zero_extendqisi2
	ldrb	lr, [r0]	@ zero_extendqisi2
	add	r5, r5, lr
	strb	r5, [r0, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1027
	adds	r2, r2, #1
	adds	r0, r0, #1
	cmp	r2, #4
	bne	.L1026
	ldr	r2, [sp, #4]
	movs	r3, #0
	adds	r6, r6, #1
	strb	r3, [r2, #16]
	strb	r3, [r2, #24]
	strb	r3, [r2, #32]
	strb	r3, [r2, #40]
	strb	r3, [r2, #48]
	strb	r3, [r2, #41]
	strb	r3, [r2, #49]
	b	.L1024
.L1023:
	subs	r3, r6, #3
	cmp	r3, #4
	bhi	.L1030
	smulbb	r3, r10, fp
	asrs	r2, r3, #2
	lsls	r3, r3, #4
	str	r3, [sp, #48]
	lsls	r3, r2, #3
	str	r2, [sp, #8]
	str	r3, [sp, #52]
	lsls	r3, r2, #2
	str	r3, [sp, #36]
	movs	r3, #0
.L1106:
	str	r3, [sp, #24]
	ldr	r3, .L1107+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldrb	r3, [sp, #24]	@ zero_extendqisi2
	cmp	r2, r3
	bls	.L1030
	ldr	r2, .L1107+12
	movs	r1, #160
	movs	r7, #255
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	str	r3, [sp, #4]
	mla	r1, r1, r3, r4
	ldr	r2, [sp, #4]
	add	r3, r1, #144
	str	r3, [sp, #44]
	ldr	r3, .L1107+16
	ldr	r3, [r3]
	str	r3, [sp, #12]
	add	r5, r3, r2, lsl #8
	str	r7, [r5, #2056]
	bl	nandc_wait_flash_ready
	cmp	r6, #4
	mov	r3, #54
	str	r3, [r5, #2056]
	bne	.L1032
	movs	r3, #64
	str	r7, [r5, #2052]
	str	r3, [r5, #2048]
	movs	r3, #204
.L1103:
	str	r3, [r5, #2052]
	movs	r3, #77
	b	.L1104
.L1032:
	subs	r3, r6, #5
	cmp	r3, #1
	bhi	.L1034
	ldrb	r3, [r4, #128]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #82
.L1104:
	str	r3, [r5, #2048]
	cmp	r6, #6
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #4]
	add	r5, r3, r2, lsl #8
	mov	r3, #22
	ldr	r2, [sp, #4]
	str	r3, [r5, #2056]
	mov	r3, #23
	str	r3, [r5, #2056]
	mov	r3, #4
	str	r3, [r5, #2056]
	mov	r3, #25
	str	r3, [r5, #2056]
	mov	r3, #0
	str	r3, [r5, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	it	eq
	moveq	r3, #31
	str	r3, [r5, #2052]
	movs	r3, #2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2052]
	ldr	r3, [sp, #12]
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	nandc_wait_flash_ready
	subs	r3, r6, #5
	cmp	r3, #1
	str	r3, [sp, #28]
	bls	.L1070
	cmp	r6, #7
	ite	ne
	movne	r2, #2
	moveq	r2, #32
.L1037:
	ldr	r3, .L1107+20
	subs	r2, r2, #1
	ldr	r3, [r3]
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1038:
	ldr	r7, [r5, #2048]
	strb	r7, [r0, #1]!
	cmp	r0, r2
	bne	.L1038
	cmp	r6, #7
	bne	.L1039
	movs	r2, #0
.L1041:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1040
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1040
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1041
.L1042:
	movs	r1, #0
	ldr	r0, .L1107+24
	bl	printf
.L1044:
	b	.L1044
.L1034:
	movs	r3, #174
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #176
	b	.L1103
.L1070:
	movs	r2, #16
	b	.L1037
.L1108:
	.align	2
.L1107:
	.word	.LANCHOR5
	.word	.LANCHOR110
	.word	.LANCHOR8
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR111
	.word	.LC33
.L1040:
	cmp	r1, #6
	bhi	.L1042
.L1043:
	ldr	r3, .L1109
	ldr	r8, [r3]
	mov	r3, r8
.L1048:
	ldr	r1, [sp, #48]
	sub	r2, r3, r8
	cmp	r1, r2
	bgt	.L1049
	ldr	r3, .L1109
	ldr	r1, [r3]
	ldr	r3, [sp, #36]
	adds	r0, r1, r3
	movs	r3, #8
.L1051:
	mov	ip, r0
	movs	r7, #0
.L1050:
	ldr	r2, [ip]
	adds	r7, r7, #1
	mvns	r2, r2
	str	r2, [ip], #4
	ldr	r2, [sp, #8]
	cmp	r2, r7
	bgt	.L1050
	ldr	r2, [sp, #52]
	subs	r3, r3, #1
	add	r0, r0, r2
	bne	.L1051
	mov	ip, r1
	str	r3, [sp, #20]
.L1052:
	movs	r0, #0
	mov	r2, r0
.L1056:
	movs	r3, #1
	mov	lr, #0
	lsl	r7, r3, r2
	movs	r3, #16
	str	ip, [sp, #16]
	str	r7, [sp, #32]
	str	r3, [sp, #40]
.L1054:
	ldr	r3, [sp, #32]
	mov	r7, r3
	ldr	r3, [sp, #16]
	ldr	r3, [r3]
	bics	r3, r7, r3
	ldr	r3, [sp, #36]
	ldr	r7, [sp, #16]
	it	eq
	addeq	lr, lr, #1
	add	r7, r7, r3
	ldr	r3, [sp, #40]
	str	r7, [sp, #16]
	subs	r3, r3, #1
	str	r3, [sp, #40]
	bne	.L1054
	cmp	lr, #8
	add	r2, r2, #1
	itt	hi
	ldrhi	r3, [sp, #32]
	orrhi	r0, r0, r3
	cmp	r2, #32
	bne	.L1056
	ldr	r3, [sp, #20]
	str	r0, [ip], #4
	adds	r3, r3, #1
	str	r3, [sp, #20]
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	bgt	.L1052
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1059:
	ldr	r7, [r2, #4]!
	cbnz	r7, .L1058
	adds	r3, r3, #1
.L1058:
	cmp	r0, r2
	bne	.L1059
	cmp	r3, #7
	ble	.L1060
	ldr	r0, .L1109+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1109+8
	bl	printf
.L1061:
	b	.L1061
.L1039:
	cmp	r6, #6
	bne	.L1043
	adds	r3, r3, #7
.L1045:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1043
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1043
	cmp	r1, r3
	bne	.L1045
	movs	r1, #0
	ldr	r0, .L1109+8
	bl	printf
.L1047:
	b	.L1047
.L1049:
	ldr	r2, [r5, #2048]
	strb	r2, [r3], #1
	b	.L1048
.L1060:
	cmp	r6, #6
	beq	.L1072
	cmp	r6, #7
	ite	ne
	movne	lr, #8
	moveq	lr, #10
.L1062:
	add	r3, fp, #-1
	ldr	r1, [sp, #44]
	uxtb	r3, r3
	movs	r0, #0
	adds	r3, r3, #1
.L1063:
	mov	ip, r1
	mov	r2, r8
.L1064:
	ldrb	r7, [r2], #1	@ zero_extendqisi2
	strb	r7, [ip], #1
	sub	r7, r2, r8
	uxtb	r7, r7
	cmp	fp, r7
	bhi	.L1064
	adds	r0, r0, #1
	add	r8, r8, r3
	cmp	r10, r0
	add	r1, r1, lr
	bgt	.L1063
	ldr	r3, [sp, #12]
	mov	r8, #255
	ldr	r2, [sp, #4]
	add	r7, r3, r2, lsl #8
	str	r8, [r7, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #28]
	cmp	r3, #1
	bhi	.L1066
	movs	r3, #54
	movs	r2, #22
	str	r3, [r7, #2056]
	ldrb	r3, [r4, #128]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	str	r2, [r7, #2056]
	str	r3, [r7, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	movs	r3, #48
	str	r8, [r5, #2052]
	str	r8, [r5, #2052]
	str	r8, [r5, #2052]
.L1105:
	str	r3, [r7, #2056]
	bl	nandc_wait_flash_ready
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1106
.L1072:
	mov	lr, #4
	b	.L1062
.L1066:
	movs	r3, #56
	b	.L1105
.L1110:
	.align	2
.L1109:
	.word	.LANCHOR111
	.word	.LC34
	.word	.LC33
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",%progbits
	.align	1
	.global	flash_get_read_retry_tbl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1113
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	subs	r3, r0, #1
	cmp	r3, #6
	bhi	.L1111
	b	hynix_get_read_retry_default
.L1111:
	bx	lr
.L1114:
	.align	2
.L1113:
	.word	.LANCHOR19
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",%progbits
	.align	1
	.global	nandc_xfer_done
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1149
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	ldr	r4, .L1149+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r6, [r4]
	cmp	r3, #9
	bne	.L1116
	ldr	r3, [r6, #16]
	str	r3, [sp]
	ldr	r5, [r6, #48]
	ubfx	r5, r5, #1, #1
	cbnz	r5, .L1117
	ldr	r7, .L1149+8
	ldr	r8, .L1149+24
.L1118:
	ldr	r3, [sp]
	lsls	r0, r3, #11
	bmi	.L1121
	ldr	r3, [r4]
	adds	r5, r5, #1
	ldr	r3, [r3, #16]
	str	r3, [sp]
	bics	r3, r5, #-16777216
	bne	.L1118
	ldr	r2, [sp]
	mov	r1, r5
	ldr	r3, [r6, #64]
	mov	r0, r7
	ubfx	r3, r3, #16, #6
	bl	printf
	mov	r3, #256
	movs	r2, #4
	ldr	r1, [r4]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1118
.L1117:
	ldr	r7, .L1149+12
	movs	r5, #0
	ldr	r8, .L1149+24
.L1119:
	ldr	r2, [r6, #64]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #6
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	blt	.L1123
.L1121:
	ldr	r3, .L1149+16
	movs	r2, #0
	str	r2, [r3, #20]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1123:
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r2, r3, #18
	bpl	.L1120
	ldr	r3, [sp, #4]
	lsls	r3, r3, #14
	bmi	.L1121
.L1120:
	adds	r5, r5, #1
	bics	r3, r5, #-16777216
	bne	.L1119
	ldr	r2, [r6, #64]
	mov	r1, r5
	ldr	r3, [sp]
	mov	r0, r7
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	bl	printf
	mov	r3, #256
	movs	r2, #4
	ldr	r1, [r4]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1119
.L1116:
	ldr	r3, [r6, #8]
	str	r3, [sp]
	ldr	r5, [r6, #16]
	ubfx	r5, r5, #1, #1
	cbnz	r5, .L1127
	ldr	r7, .L1149+8
	ldr	r8, .L1149+24
.L1128:
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bmi	.L1121
	ldr	r3, [r4]
	adds	r5, r5, #1
	ldr	r3, [r3, #8]
	str	r3, [sp]
	bics	r3, r5, #-16777216
	bne	.L1128
	ldr	r2, [sp]
	mov	r1, r5
	ldr	r3, [r6, #28]
	mov	r0, r7
	ubfx	r3, r3, #16, #5
	bl	printf
	mov	r3, #256
	movs	r2, #4
	ldr	r1, [r4]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1128
.L1127:
	ldr	r7, .L1149+12
	movs	r5, #0
	ldr	r8, .L1149+24
.L1129:
	ldr	r2, [r6, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L1121
	ldr	r3, [r4]
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r1, r3, #18
	bpl	.L1130
	ldr	r3, [sp, #4]
	lsls	r2, r3, #14
	bpl	.L1130
	ldr	r1, [sp, #4]
	ldr	r0, .L1149+20
	bl	printf
	b	.L1121
.L1130:
	adds	r5, r5, #1
	bics	r3, r5, #-16777216
	bne	.L1129
	ldr	r2, [r6, #28]
	mov	r1, r5
	ldr	r3, [sp]
	mov	r0, r7
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	bl	printf
	mov	r3, #256
	movs	r2, #4
	ldr	r1, [r4]
	mov	r0, r8
	bl	rknand_print_hex
	b	.L1129
.L1150:
	.align	2
.L1149:
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	.LC37
	.word	.LC35
	.word	.LANCHOR30
	.word	.LC38
	.word	.LC36
	.size	nandc_xfer_done, .-nandc_xfer_done
	.section	.text.nandc_xfer,"ax",%progbits
	.align	1
	.global	nandc_xfer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nandc_xfer, %function
nandc_xfer:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r1
	ldr	r4, [sp, #32]
	mov	r6, r2
	mov	r5, r3
	mov	r1, r6
	mov	r2, r5
	mov	r0, r8
	mov	r3, r4
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	cmp	r8, #0
	bne	.L1169
	ldr	r3, .L1182
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #9
	bne	.L1153
	ldr	r5, .L1182+4
	lsrs	r6, r6, #2
	movs	r2, #1
	mov	r1, r8
	mov	r0, r8
	ldr	r4, [r5]
.L1154:
	cmp	r1, r6
	bcc	.L1158
	ldr	r4, [r4]
	cmp	r2, #0
	it	ne
	movne	r0, #512
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1152
	mov	r1, r4
	ldr	r0, .L1182+8
	bl	printf
	ldr	r3, [r5]
	orr	r4, r4, #131072
.L1181:
	mov	r0, #-1
	str	r4, [r3]
.L1152:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1158:
	add	r3, r1, #84
	ldr	r3, [r4, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	r7, [sp, #4]
	ldr	r3, [sp, #4]
	ubfx	r3, r3, #26, #1
	and	r3, r3, r7, lsr #10
	ands	r2, r2, r3
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1171
	ldr	r3, [sp, #4]
	lsls	r7, r3, #13
	bmi	.L1171
	ldr	r7, [sp, #4]
	ldr	r3, [sp, #4]
	ubfx	r7, r7, #3, #7
	ubfx	r3, r3, #19, #7
	cmp	r7, r3
	ldr	r3, [sp, #4]
	ite	gt
	ubfxgt	r3, r3, #3, #7
	ubfxle	r3, r3, #19, #7
	cmp	r0, r3
	it	cc
	movcc	r0, r3
.L1155:
	adds	r1, r1, #1
	b	.L1154
.L1171:
	mov	r0, #-1
	b	.L1155
.L1153:
	ldr	r3, .L1182+12
	mov	r1, r8
	mov	r0, r8
	ldr	r8, .L1182+20
	lsrs	r7, r6, #1
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #25
	mov	r3, r4
	ite	cc
	movcc	lr, #64
	movcs	lr, #128
.L1161:
	cmp	r0, r7
	add	ip, lr, r1
	add	r3, r3, #4
	bcc	.L1162
	lsrs	r7, r6, #2
	ldr	r6, .L1182+4
	movs	r2, #0
	mov	r0, r2
	ldr	r1, [r6]
.L1163:
	cmp	r2, r7
	bcc	.L1167
	movs	r3, #0
	str	r3, [r1, #16]
	adds	r3, r0, #1
	beq	.L1168
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1168
	ldr	r3, [r4, #4]
	adds	r3, r3, #1
	bne	.L1168
	ldr	r3, [r5]
	adds	r3, r3, #1
	it	eq
	moveq	r0, #512
.L1168:
	ldr	r4, [r1]
	and	r3, r4, #139264
	cmp	r3, #139264
	bne	.L1152
	mov	r1, r4
	ldr	r0, .L1182+16
	bl	printf
	orr	r4, r4, #131072
	ldr	r3, [r6]
	b	.L1181
.L1162:
	ldr	r2, [r8]
	bic	r1, r1, #3
	adds	r0, r0, #1
	ldr	r2, [r2, r1]
	strb	r2, [r3, #-4]
	lsrs	r1, r2, #8
	strb	r1, [r3, #-3]
	lsrs	r1, r2, #16
	lsrs	r2, r2, #24
	strb	r1, [r3, #-2]
	mov	r1, ip
	strb	r2, [r3, #-1]
	b	.L1161
.L1167:
	add	r3, r2, #8
	ldr	r3, [r1, r3, lsl #2]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #29
	bmi	.L1174
	ldr	r3, [sp, #4]
	lsls	r3, r3, #16
	bmi	.L1174
	ldr	r3, [sp, #4]
	ubfx	ip, r3, #3, #5
	ldr	r3, [sp, #4]
	ubfx	r8, r3, #27, #1
	ldr	r3, [sp, #4]
	ldr	lr, [sp, #4]
	orr	ip, ip, r8, lsl #5
	ubfx	r3, r3, #16, #5
	ubfx	lr, lr, #29, #1
	orr	r3, r3, lr, lsl #5
	cmp	ip, r3
	ldr	r3, [sp, #4]
	itete	hi
	ldrhi	ip, [sp, #4]
	ldrls	ip, [sp, #4]
	ubfxhi	r3, r3, #3, #5
	ubfxls	r3, r3, #16, #5
	ite	hi
	ubfxhi	ip, ip, #27, #1
	ubfxls	ip, ip, #29, #1
	orr	r3, r3, ip, lsl #5
	cmp	r0, r3
	it	cc
	movcc	r0, r3
.L1164:
	adds	r2, r2, #1
	b	.L1163
.L1174:
	mov	r0, #-1
	b	.L1164
.L1169:
	movs	r0, #0
	b	.L1152
.L1183:
	.align	2
.L1182:
	.word	.LANCHOR7
	.word	.LANCHOR6
	.word	.LC39
	.word	.LANCHOR27
	.word	.LC40
	.word	.LANCHOR30
	.size	nandc_xfer, .-nandc_xfer
	.section	.text.flash_read_page,"ax",%progbits
	.align	1
	.global	flash_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_page, %function
flash_read_page:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	str	r3, [sp, #16]
	mov	r5, r0
	mov	r8, r1
	ubfx	r4, r1, #0, #21
	ldr	r3, .L1200
	ubfx	r6, r1, #24, #2
	str	r2, [sp, #12]
	ldr	r7, [r3]
	ldr	r3, .L1200+4
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L1185
	mov	r3, r1
	mov	r2, r6
	mov	r1, r0
	ldr	r0, .L1200+8
	bl	printf
.L1185:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	lsl	r10, r5, #8
	bl	nandc_cs
	ldr	r1, .L1200+12
	cbnz	r6, .L1186
	mov	r0, r5
	str	r1, [sp, #20]
	bl	flash_enter_slc_mode
.L1198:
	ldr	r1, [sp, #20]
	b	.L1187
.L1186:
	ldr	r3, [r1]
	ldrb	r3, [r3, #12]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L1188
	add	r3, r7, r10
	str	r6, [r3, #2056]
.L1187:
	add	fp, r7, r10
	movs	r2, #0
	str	r2, [fp, #2056]
	str	r2, [fp, #2052]
	str	r2, [fp, #2052]
	uxtb	r2, r8
	str	r2, [fp, #2052]
	lsrs	r2, r4, #8
	str	r2, [fp, #2052]
	lsrs	r2, r4, #16
	str	r2, [fp, #2052]
	movs	r2, #48
	str	r2, [fp, #2056]
	ldr	r2, [r1]
	ldrb	r2, [r2, #12]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L1189
	cbz	r6, .L1189
	add	r4, r4, r4, lsl #1
	subs	r0, r4, #1
	add	r0, r0, r6
.L1199:
	bl	nandc_set_seed
	add	r7, r7, r10
	bl	nandc_wait_flash_ready
	movs	r1, #0
	movs	r2, #5
	movs	r3, #224
	str	r2, [r7, #2056]
	str	r1, [fp, #2052]
	mov	r0, r5
	str	r1, [fp, #2052]
	str	r3, [r7, #2056]
	ldr	r3, [sp, #16]
	ldrb	r2, [sp, #56]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, [sp, #12]
	bl	nandc_xfer
	mov	r4, r0
	cbnz	r6, .L1191
	mov	r0, r5
	bl	flash_exit_slc_mode
.L1191:
	movs	r0, #0
	bl	nandc_de_cs
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1188:
	mov	r0, r5
	str	r1, [sp, #20]
	bl	flash_exit_slc_mode
	b	.L1198
.L1189:
	mov	r0, r4
	b	.L1199
.L1201:
	.align	2
.L1200:
	.word	.LANCHOR6
	.word	.LANCHOR22
	.word	.LC41
	.word	.LANCHOR34
	.size	flash_read_page, .-flash_read_page
	.section	.text.micron_read_retrial,"ax",%progbits
	.align	1
	.global	micron_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	micron_read_retrial, %function
micron_read_retrial:
	@ args = 8, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	str	r3, [sp, #12]
	mov	r7, r2
	movs	r5, #0
	mov	r4, #-1
	ldr	r3, .L1215
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	asr	r10, r3, #2
	bl	nandc_wait_flash_ready
	ldr	r3, .L1215+4
	ldr	r3, [r3]
	str	r3, [sp, #8]
.L1203:
	ldr	r3, .L1215+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1207
.L1206:
	ldr	r3, [sp, #8]
	movs	r0, #200
	add	r8, r3, r8, lsl #8
	movs	r3, #239
	str	r3, [r8, #2056]
	movs	r3, #137
	str	r3, [r8, #2052]
	bl	timer_delay_ns
	cmp	r4, r10
	mov	r3, #0
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	str	r3, [r8, #2048]
	bcc	.L1202
	adds	r3, r4, #1
	mov	r2, r7
	it	ne
	movne	r4, #256
	mov	r3, r5
	str	r4, [sp]
	mov	r1, r5
	ldr	r0, .L1215+12
	bl	printf
.L1202:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1207:
	ldr	r3, [sp, #8]
	movs	r0, #200
	add	fp, r5, #1
	add	r1, r3, r8, lsl #8
	movs	r3, #239
	str	r3, [r1, #2056]
	movs	r3, #137
	str	r3, [r1, #2052]
	bl	timer_delay_ns
	movs	r3, #0
	str	fp, [r1, #2048]
	str	r3, [r1, #2048]
	mov	r0, r8
	str	r3, [r1, #2048]
	str	r3, [r1, #2048]
	mov	r1, r7
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #12]
	str	r3, [sp]
	ldr	r3, [sp, #48]
	bl	flash_read_page
	mov	r2, r7
	mov	r6, r0
	str	r4, [sp]
	mov	r3, r5
	mov	r1, r5
	ldr	r0, .L1215+16
	bl	printf
	adds	r2, r6, #1
	beq	.L1204
	ldr	r3, .L1215+20
	cmp	r4, #-1
	it	eq
	moveq	r4, r6
	cmp	r6, r10
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1215+24
	ldr	r3, [r3]
	str	r3, [sp, #48]
	bcc	.L1210
.L1204:
	mov	r5, fp
	b	.L1203
.L1210:
	mov	r4, r6
	b	.L1206
.L1216:
	.align	2
.L1215:
	.word	.LANCHOR27
	.word	.LANCHOR6
	.word	.LANCHOR113
	.word	.LC43
	.word	.LC42
	.word	.LANCHOR111
	.word	.LANCHOR112
	.size	micron_read_retrial, .-micron_read_retrial
	.section	.text.toshiba_3d_read_retrial,"ax",%progbits
	.align	1
	.global	toshiba_3d_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_3d_read_retrial, %function
toshiba_3d_read_retrial:
	@ args = 8, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r10, r0
	mov	r8, r2
	mov	r4, r1
	add	r7, r10, #8
	str	r3, [sp, #12]
	bl	nandc_wait_flash_ready
	ldr	r3, .L1252
	ldr	r6, [r3]
	ldr	r3, .L1252+4
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r7, r6, r7, lsl #8
	cmp	r2, #36
	ite	ne
	movne	r2, #56
	moveq	r2, #46
	str	r2, [sp, #20]
	ite	ne
	movne	r2, #10
	moveq	r2, #26
	str	r2, [sp, #16]
	cmp	r4, #0
	bne	.L1219
	mov	r4, #-1
	movs	r5, #1
	str	r3, [sp, #20]
.L1225:
	ldr	r3, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1220
	movs	r2, #0
	mov	r1, r5
	mov	r0, r7
	bl	toshiba_tlc_set_rr_para
	add	r3, r6, r10, lsl #8
	movs	r2, #93
	str	r2, [r3, #2056]
.L1221:
	ldr	r3, [sp, #60]
	mov	r1, r8
	ldr	r2, [sp, #12]
	mov	r0, r10
	str	r3, [sp]
	ldr	r3, [sp, #56]
	bl	flash_read_page
	mov	r2, r8
	mov	fp, r0
	mov	r3, r0
	mov	r1, r5
	ldr	r0, .L1252+8
	bl	printf
	cmp	fp, #-1
	beq	.L1222
	ldr	r3, .L1252+12
	cmp	r4, #-1
	it	eq
	moveq	r4, fp
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1252+16
	ldr	r3, [r3]
	str	r3, [sp, #56]
	ldr	r3, .L1252+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	fp, r3, asr #2
	bcc	.L1238
.L1222:
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1225
.L1224:
	ldr	r3, .L1252+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1226
	movs	r2, #0
.L1251:
	movs	r1, #0
	mov	r0, r7
	bl	toshiba_tlc_set_rr_para
	b	.L1227
.L1220:
	uxtb	r1, r5
	mov	r0, r7
	bl	toshiba_3d_set_slc_rr_para
	b	.L1221
.L1238:
	mov	r4, fp
	b	.L1224
.L1226:
	movs	r1, #0
	mov	r0, r7
	bl	toshiba_3d_set_slc_rr_para
.L1227:
	ldr	r3, .L1252+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1235
	add	r6, r6, r10, lsl #8
	movs	r3, #85
	str	r3, [r6, #2056]
	movs	r3, #0
	str	r3, [r6, #2052]
	str	r3, [r6, #2048]
	movs	r3, #255
	str	r3, [r6, #2056]
.L1235:
	mov	r3, r5
	str	r4, [sp]
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L1252+24
	bl	printf
	ldr	r3, .L1252+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1236
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1236:
	bl	nandc_wait_flash_ready
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1219:
	orr	r8, r8, r4, lsl #24
	movs	r5, #1
	mov	r4, #-1
	str	r3, [sp, #16]
.L1233:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1228
	movs	r2, #1
	mov	r1, r5
	mov	r0, r7
	bl	toshiba_tlc_set_rr_para
	add	r3, r6, r10, lsl #8
	movs	r2, #93
.L1250:
	str	r2, [r3, #2056]
	mov	r1, r8
	ldr	r3, [sp, #60]
	mov	r0, r10
	ldr	r2, [sp, #12]
	str	r3, [sp]
	ldr	r3, [sp, #56]
	bl	flash_read_page
	mov	r2, r8
	mov	fp, r0
	mov	r3, r0
	mov	r1, r5
	ldr	r0, .L1252+28
	bl	printf
	cmp	fp, #-1
	beq	.L1230
	ldr	r3, .L1252+12
	cmp	r4, #-1
	it	eq
	moveq	r4, fp
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1252+16
	ldr	r3, [r3]
	str	r3, [sp, #56]
	ldr	r3, .L1252+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	fp, r3, asr #2
	bcc	.L1239
.L1230:
	ldr	r3, [sp, #20]
	adds	r5, r5, #1
	cmp	r3, r5
	bne	.L1233
.L1232:
	ldr	r3, .L1252+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #36
	bne	.L1234
	movs	r2, #1
	b	.L1251
.L1228:
	uxtb	r1, r5
	mov	r0, r7
	bl	toshiba_3d_set_tlc_rr_para
	add	r3, r6, r10, lsl #8
	movs	r2, #38
	b	.L1250
.L1239:
	mov	r4, fp
	b	.L1232
.L1234:
	movs	r1, #0
	mov	r0, r7
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1227
.L1253:
	.align	2
.L1252:
	.word	.LANCHOR6
	.word	.LANCHOR1
	.word	.LC44
	.word	.LANCHOR111
	.word	.LANCHOR112
	.word	.LANCHOR27
	.word	.LC46
	.word	.LC45
	.size	toshiba_3d_read_retrial, .-toshiba_3d_read_retrial
	.section	.text.toshiba_read_retrial,"ax",%progbits
	.align	1
	.global	toshiba_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	toshiba_read_retrial, %function
toshiba_read_retrial:
	@ args = 8, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r7, r0
	str	r2, [sp, #12]
	add	r10, r7, #8
	str	r3, [sp, #16]
	bl	nandc_wait_flash_ready
	ldr	r3, .L1281
	ldr	r2, .L1281+4
	ldr	r6, [r3]
	ldrb	r3, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	subs	r3, r3, #67
	add	r10, r6, r10, lsl #8
	cmp	r3, #1
	bls	.L1272
	ldr	r3, .L1281+8
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1256
	movs	r5, #1
	movs	r0, #1
	bl	nandc_set_if_mode
.L1256:
	add	r3, r6, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1255:
	mov	r8, #1
	mov	fp, #-1
.L1257:
	ldr	r3, .L1281+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1266
	mov	r4, fp
.L1265:
	ldr	r3, .L1281+4
	movs	r1, #0
	mov	r0, r10
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1267
	bl	sandisk_set_rr_para
.L1268:
	add	r6, r6, r7, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	ldr	r3, .L1281+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1269
	adds	r3, r4, #1
	ldr	r2, [sp, #12]
	it	ne
	movne	r4, #256
	mov	r3, r8
	str	r4, [sp]
	mov	r1, r8
	ldr	r0, .L1281+20
	bl	printf
.L1269:
	bl	nandc_wait_flash_ready
	cbz	r5, .L1254
	movs	r0, #4
	bl	nandc_set_if_mode
.L1254:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1272:
	movs	r5, #0
	b	.L1255
.L1266:
	ldr	r3, [sp, #20]
	mov	r0, r10
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1258
	bl	sandisk_set_rr_para
.L1259:
	ldr	r3, .L1281+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1260
	ldr	r3, .L1281+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r6, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1260:
	add	r3, r6, r7, lsl #8
	movs	r2, #38
	ldr	r1, [sp, #12]
	mov	r0, r7
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #60]
	ldr	r2, [sp, #16]
	str	r3, [sp]
	ldr	r3, [sp, #56]
	bl	flash_read_page
	adds	r2, r0, #1
	mov	r4, r0
	beq	.L1263
	ldr	r3, .L1281+24
	cmp	fp, #-1
	it	eq
	moveq	fp, r0
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1281+28
	ldr	r3, [r3]
	str	r3, [sp, #56]
	ldr	r3, .L1281+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1265
.L1263:
	add	r8, r8, #1
	b	.L1257
.L1258:
	bl	toshiba_set_rr_para
	b	.L1259
.L1267:
	bl	toshiba_set_rr_para
	b	.L1268
.L1282:
	.align	2
.L1281:
	.word	.LANCHOR6
	.word	.LANCHOR1
	.word	.LANCHOR35
	.word	.LANCHOR113
	.word	.LANCHOR27
	.word	.LC46
	.word	.LANCHOR111
	.word	.LANCHOR112
	.size	toshiba_read_retrial, .-toshiba_read_retrial
	.section	.text.hynix_read_retrial,"ax",%progbits
	.align	1
	.global	hynix_read_retrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	hynix_read_retrial, %function
hynix_read_retrial:
	@ args = 8, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	str	r3, [sp, #12]
	mov	r4, #-1
	mov	r7, r0
	mov	r8, r2
	ldr	r3, .L1297
	ldr	r3, [r3]
	add	fp, r3, r0
	ldrb	r10, [r3, #114]	@ zero_extendqisi2
	ldrb	r5, [fp, #120]	@ zero_extendqisi2
	bl	nandc_wait_flash_ready
.L1284:
	cmp	r6, r10
	bcc	.L1289
.L1288:
	ldr	r3, .L1297+4
	strb	r5, [fp, #120]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1283
	adds	r3, r4, #1
	mov	r2, r8
	it	ne
	movne	r4, #256
	mov	r3, r6
	str	r4, [sp]
	mov	r1, r6
	ldr	r0, .L1297+8
	bl	printf
.L1283:
	mov	r0, r4
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1289:
	adds	r5, r5, #1
	mov	r0, r7
	uxtb	r5, r5
	cmp	r10, r5
	it	ls
	movls	r5, #0
	mov	r1, r5
	bl	hynix_set_rr_para
	ldr	r3, [sp, #52]
	mov	r1, r8
	ldr	r2, [sp, #12]
	mov	r0, r7
	str	r3, [sp]
	ldr	r3, [sp, #48]
	bl	flash_read_page
	adds	r2, r0, #1
	beq	.L1286
	ldr	r3, .L1297+12
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1297+16
	ldr	r3, [r3]
	str	r3, [sp, #48]
	ldr	r3, .L1297+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1292
.L1286:
	adds	r6, r6, #1
	b	.L1284
.L1292:
	mov	r4, r0
	b	.L1288
.L1298:
	.align	2
.L1297:
	.word	.LANCHOR5
	.word	.LANCHOR27
	.word	.LC47
	.word	.LANCHOR111
	.word	.LANCHOR112
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tunning_read,"ax",%progbits
	.align	1
	.global	flash_ddr_tunning_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_ddr_tunning_read, %function
flash_ddr_tunning_read:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, #0
	mov	r5, r8
	mov	r4, r8
	mov	r7, #1024
	movs	r6, #6
	mov	fp, #-1
	sub	sp, sp, #32
	str	r0, [sp, #16]
	str	r1, [sp, #12]
	str	r2, [sp, #20]
	str	r3, [sp, #24]
	bl	nandc_get_ddr_para
	str	r8, [sp, #8]
	str	r0, [sp, #28]
.L1304:
	uxtb	r0, r6
	bl	nandc_set_ddr_para
	ldr	r3, [sp, #64]
	ldr	r2, [sp, #20]
	ldr	r1, [sp, #12]
	str	r3, [sp]
	ldr	r0, [sp, #16]
	ldr	r3, [sp, #24]
	bl	flash_read_page
	ldr	r2, [sp, #12]
	mov	r3, r0
	mov	r10, r0
	mov	r1, r6
	ldr	r0, .L1316
	bl	printf
	adds	r3, r7, #1
	cmp	r10, r3
	bhi	.L1300
	ldr	r3, .L1316+4
	cmp	r10, #2
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L1316+8
	ldr	r3, [r3]
	str	r3, [sp, #24]
	bhi	.L1309
	adds	r4, r4, #1
	cmp	r4, #7
	bls	.L1309
	mov	r3, r5
	mov	r7, r10
	subs	r5, r6, r4
	mov	fp, #0
.L1302:
	ldr	r2, [sp, #8]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L1303:
	cbz	r5, .L1305
	ldr	r3, .L1316+12
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1316+16
	umull	r2, r3, r2, r3
	ubfx	r3, r3, #1, #8
	cmp	r3, r7
	bls	.L1305
	mov	r1, r5
	ldr	r0, .L1316+20
	bl	printf
	uxtb	r0, r5
.L1315:
	bl	nandc_set_ddr_para
	cmp	fp, #0
	beq	.L1299
	mov	r7, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #16]
	ldr	r0, .L1316+24
	bl	printf
.L1299:
	mov	r0, r7
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1300:
	ldr	r3, [sp, #8]
	cmp	r4, r3
	bls	.L1310
	cmp	r4, #7
	sub	r5, r8, r4
	bhi	.L1303
	str	r4, [sp, #8]
.L1310:
	movs	r4, #0
	b	.L1301
.L1309:
	mov	r8, r6
	mov	r7, r10
	mov	fp, #0
.L1301:
	adds	r6, r6, #2
	cmp	r6, #50
	bne	.L1304
	mov	r3, r5
	mov	r5, r8
	b	.L1302
.L1305:
	ldrb	r0, [sp, #28]	@ zero_extendqisi2
	b	.L1315
.L1317:
	.align	2
.L1316:
	.word	.LC48
	.word	.LANCHOR111
	.word	.LANCHOR112
	.word	.LANCHOR27
	.word	-1431655765
	.word	.LC49
	.word	.LC50
	.size	flash_ddr_tunning_read, .-flash_ddr_tunning_read
	.section	.text.flash_read_page_en,"ax",%progbits
	.align	1
	.global	flash_read_page_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_page_en, %function
flash_read_page_en:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r3, .L1347
	mov	r4, r1
	mov	r7, r2
	ldr	r10, [sp, #48]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1319
	mov	r2, #386
	ldr	r1, .L1347+4
	ldr	r0, .L1347+8
	bl	printf
.L1320:
	b	.L1320
.L1319:
	ldr	r3, .L1347+12
	ldrb	r5, [r3, r0]	@ zero_extendqisi2
	ldr	r3, .L1347+16
	ldr	r3, [r3]
	lsls	r0, r3, #27
	bpl	.L1321
	mov	r2, r1
	ldr	r0, .L1347+20
	mov	r1, r5
	bl	printf
.L1321:
	tst	r4, #50331648
	bne	.L1322
	ldr	r3, .L1347+24
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1347+28
	cbz	r2, .L1323
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L1322
.L1323:
	ldr	r2, .L1347+32
	mov	r0, r4
	str	r3, [sp, #12]
	ldrh	r6, [r2]
	mov	r1, r6
	bl	__aeabi_uidiv
	mov	r1, r6
	mul	fp, r6, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1324
	add	r4, fp, r1, lsl #1
.L1322:
	mov	r1, r4
	str	r10, [sp]
	mov	r3, r8
	mov	r2, r7
	mov	r0, r5
	bl	flash_read_page
	adds	r1, r0, #1
	mov	r6, r0
	bne	.L1318
	ldr	fp, .L1347+40
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp, #12]
	cbnz	r3, .L1326
.L1329:
	ldr	r3, .L1347+36
	ldr	fp, [r3]
	cmp	fp, #0
	bne	.L1327
.L1328:
	ldr	r3, .L1347+40
	mov	r2, r4
	movs	r1, #0
	ldr	r0, .L1347+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L1347+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1318
	str	r10, [sp, #48]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r4
	mov	r0, r5
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	flash_ddr_tunning_read
.L1324:
	ldr	r3, .L1347+52
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, fp
	b	.L1322
.L1326:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [fp]
	mov	r1, r4
	mov	r3, r8
	str	r10, [sp]
	mov	r0, r5
	bl	flash_read_page
	ldrb	r3, [sp, #12]	@ zero_extendqisi2
	adds	r2, r0, #1
	strb	r3, [fp]
	beq	.L1329
.L1346:
	mov	r6, r0
.L1318:
	mov	r0, r6
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1327:
	mov	r3, r7
	stm	sp, {r8, r10}
	mov	r2, r4
	movs	r1, #0
	mov	r0, r5
	blx	fp
	adds	r3, r0, #1
	bne	.L1346
	b	.L1328
.L1348:
	.align	2
.L1347:
	.word	.LANCHOR8
	.word	.LANCHOR114
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR22
	.word	.LC51
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR115
	.word	.LANCHOR29
	.word	.LC52
	.word	.LANCHOR35
	.word	.LANCHOR14
	.size	flash_read_page_en, .-flash_read_page_en
	.section	.text.flash_get_last_written_page,"ax",%progbits
	.align	1
	.global	flash_get_last_written_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_last_written_page, %function
flash_get_last_written_page:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	ldr	r4, .L1355
	mov	r10, r2
	mov	fp, r3
	ldrh	r5, [r4]
	ldr	r4, .L1355+4
	subs	r5, r5, #1
	ldrh	r6, [r4, #26]
	sxth	r5, r5
	muls	r6, r1, r6
	ldr	r1, [sp, #40]
	str	r1, [sp]
	adds	r1, r5, r6
	bl	flash_read_page_en
	cmp	r0, #512
	bne	.L1350
	movs	r7, #0
.L1351:
	cmp	r7, r5
	ble	.L1354
.L1350:
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1354:
	adds	r4, r7, r5
	ldr	r3, [sp, #40]
	add	r4, r4, r4, lsr #31
	mov	r2, r10
	mov	r0, r8
	asrs	r4, r4, #1
	str	r3, [sp]
	mov	r3, fp
	sxtah	r1, r6, r4
	bl	flash_read_page_en
	cmp	r0, #512
	itete	eq
	addeq	r4, r4, #-1
	addne	r4, r4, #1
	sxtheq	r5, r4
	sxthne	r7, r4
	b	.L1351
.L1356:
	.align	2
.L1355:
	.word	.LANCHOR97
	.word	.LANCHOR19
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",%progbits
	.align	1
	.global	flash_get_last_written_page_ext
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, lr}
	movs	r5, #1
	ldr	r4, .L1358
	ldrh	r4, [r4]
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	rsb	r4, r4, #21
	lsls	r5, r5, r4
	asr	r4, r0, r4
	subs	r5, r5, #1
	and	r1, r5, r0
	uxtb	r0, r4
	bl	flash_get_last_written_page
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L1359:
	.align	2
.L1358:
	.word	.LANCHOR71
	.size	flash_get_last_written_page_ext, .-flash_get_last_written_page_ext
	.section	.text.flash_info_blk_init,"ax",%progbits
	.align	1
	.global	flash_info_blk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_info_blk_init, %function
flash_info_blk_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #4
	ldr	r10, .L1384+12
.L1363:
	movs	r5, #4
	movs	r0, #0
	ldr	r8, .L1384+16
	ldr	fp, .L1384+20
	ldr	r6, .L1384
	ldrh	r1, [r8]
	str	r5, [sp]
	mov	r7, fp
	ldr	r3, [r6]
	ldr	r2, [fp]
	muls	r1, r4, r1
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L1361
	ldr	r2, [fp]
	ldr	r3, [r2]
	cmp	r3, r10
	beq	.L1362
.L1361:
	adds	r4, r4, #1
	cmp	r4, #16
	bne	.L1363
.L1383:
	mov	r0, #-1
.L1360:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1371:
	ldr	r3, [r7]
	ldr	r2, [r3]
	cmp	r2, r10
	bne	.L1372
	ldr	r4, [r3, #4]
.L1365:
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	movs	r3, #4
	ldrh	r0, [r8]
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r6]
	muls	r1, r0, r1
	movs	r0, #0
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L1366
	ldr	r3, [r7]
	ldr	r2, [r3]
	cmp	r2, r10
	bne	.L1366
	ldr	r2, [r3, #4]
	cmp	r4, r2
	itttt	cc
	ldrbcc	r2, [r3, #37]	@ zero_extendqisi2
	ldrbcc	r3, [r3, #36]	@ zero_extendqisi2
	strbcc	r2, [r5]
	strbcc	r3, [r5, #1]
.L1366:
	mov	fp, #4
	ldrb	r1, [r5]	@ zero_extendqisi2
	str	fp, [sp]
	movs	r0, #0
	ldr	r3, [r6]
	ldr	r2, [r7]
	bl	flash_get_last_written_page
	adds	r3, r0, #1
	mov	r4, r0
	strh	r3, [r5, #2]	@ movhi
	ldrb	r5, [r5]	@ zero_extendqisi2
	ldrh	r3, [r8]
	mla	r5, r3, r5, r0
.L1367:
	cmp	r4, #0
	bge	.L1369
	adds	r4, r4, #1
	bne	.L1370
	ldr	r3, [r7]
	ldr	r0, .L1384+4
	ldr	r1, [r3]
	bl	printf
	b	.L1383
.L1369:
	str	fp, [sp]
	mov	r1, r5
	ldr	r3, [r6]
	movs	r0, #0
	ldr	r2, [r7]
	bl	flash_read_page_en
	adds	r0, r0, #1
	beq	.L1368
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r3, r10
	bne	.L1368
.L1370:
	movs	r0, #0
	b	.L1360
.L1368:
	subs	r4, r4, #1
	subs	r5, r5, #1
	sxth	r4, r4
	b	.L1367
.L1362:
	ldrb	r1, [r2, #36]	@ zero_extendqisi2
	ldrh	r0, [r8]
	ldrb	r3, [r2, #37]	@ zero_extendqisi2
	ldr	r4, .L1384+8
	strb	r1, [r4]
	muls	r1, r0, r1
	strb	r3, [r4, #1]
	movs	r0, #0
	str	r5, [sp]
	mov	r5, r4
	ldr	r3, [r6]
	bl	flash_read_page_en
	adds	r0, r0, #1
	bne	.L1371
.L1372:
	movs	r4, #0
	b	.L1365
.L1385:
	.align	2
.L1384:
	.word	.LANCHOR116
	.word	.LC53
	.word	.LANCHOR117
	.word	1398362953
	.word	.LANCHOR13
	.word	.LANCHOR5
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.flash_ddr_para_scan,"ax",%progbits
	.align	1
	.global	flash_ddr_para_scan
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	ldr	r6, .L1392
	movs	r5, #1
	mov	r8, r1
	ldr	r4, .L1392+4
	ldr	fp, .L1392+8
	ldr	r10, .L1392+12
	ldrb	r0, [r6]	@ zero_extendqisi2
	strb	r5, [r4]
	bl	flash_set_interface_mode
	ldrb	r0, [r6]	@ zero_extendqisi2
	bl	nandc_set_if_mode
	movs	r3, #4
	ldr	r2, [r10]
	str	r3, [sp]
	mov	r1, r8
	ldr	r3, [fp]
	mov	r0, r7
	bl	flash_ddr_tunning_read
	movs	r3, #4
	ldr	r2, [r10]
	str	r3, [sp]
	mov	r1, r8
	ldr	r3, [fp]
	mov	r0, r7
	bl	flash_read_page
	adds	r0, r0, #1
	mov	r3, r4
	bne	.L1387
	ldrb	r2, [r6]	@ zero_extendqisi2
	lsls	r2, r2, #31
	bpl	.L1387
	mov	r0, r5
	bl	flash_set_interface_mode
	mov	r0, r5
	bl	nandc_set_if_mode
	movs	r3, #0
	strb	r3, [r4]
.L1388:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1387:
	movs	r2, #1
	strb	r2, [r3]
	b	.L1388
.L1393:
	.align	2
.L1392:
	.word	.LANCHOR25
	.word	.LANCHOR35
	.word	.LANCHOR118
	.word	.LANCHOR119
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_page_read,"ax",%progbits
	.align	1
	.global	flash_complete_page_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	ldr	r2, .L1419
	ubfx	r3, r0, #21, #3
	sub	sp, sp, #24
	str	r0, [sp, #12]
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r1, [sp, #16]
	cmp	r2, r3
	bhi	.L1395
	movw	r2, #791
	ldr	r1, .L1419+4
	ldr	r0, .L1419+8
	bl	printf
.L1396:
	b	.L1396
.L1395:
	ldr	r2, [sp, #12]
	ubfx	r4, r2, #0, #21
	ubfx	r2, r2, #24, #2
	str	r2, [sp, #8]
	ldr	r2, .L1419+12
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1419+16
	mov	r0, r5
	ldr	r6, [r3]
	bl	nandc_cs
	ldr	r3, [sp, #8]
	cbnz	r3, .L1397
	ldr	r3, .L1419+20
	ldr	fp, .L1419+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1398
	ldrb	r3, [fp]	@ zero_extendqisi2
	cbz	r3, .L1397
.L1398:
	ldr	r3, .L1419+24
	mov	r0, r4
	ldrh	r8, [r3]
	mov	r1, r8
	bl	__aeabi_uidiv
	mov	r1, r8
	mul	r10, r8, r0
	mov	r0, r4
	bl	__aeabi_uidivmod
	ldrb	r3, [fp]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1399
	add	r4, r10, r1, lsl #1
.L1397:
	add	r6, r6, r5, lsl #8
	movs	r3, #5
	mov	r8, #0
	ldr	fp, .L1419+44
	str	r3, [r6, #2056]
	uxtb	r3, r4
	str	r8, [r6, #2052]
	mov	r1, r8
	str	r8, [r6, #2052]
	mov	r0, r5
	str	r3, [r6, #2052]
	lsrs	r3, r4, #8
	ldrb	r2, [fp, #9]	@ zero_extendqisi2
	str	r3, [r6, #2052]
	lsrs	r3, r4, #16
	str	r3, [r6, #2052]
	movs	r3, #224
	str	r3, [r6, #2056]
	str	r7, [sp]
	ldr	r3, [sp, #16]
	bl	nandc_xfer
	adds	r1, r0, #1
	mov	r6, r0
	bne	.L1394
	ldr	r10, .L1419+32
	ldrb	r3, [r10]	@ zero_extendqisi2
	str	r3, [sp, #20]
	cbnz	r3, .L1401
.L1404:
	ldr	r3, .L1419+28
	ldr	r8, [r3]
	cmp	r8, #0
	bne	.L1402
.L1403:
	ldr	r3, .L1419+32
	movs	r1, #0
	ldr	r2, [sp, #12]
	ldr	r0, .L1419+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, #-1
	bl	printf
	ldr	r3, .L1419+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1394
	ldr	r3, .L1419+44
	mov	r0, r5
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #16]
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	orr	r1, r4, r1, lsl #24
	str	r3, [sp]
	mov	r3, r7
	bl	flash_ddr_tunning_read
	b	.L1418
.L1399:
	ldr	r3, .L1419+48
	ldrh	r4, [r3, r1, lsl #1]
	add	r4, r4, r10
	b	.L1397
.L1401:
	ldr	r1, [sp, #8]
	mov	r0, r5
	ldrb	r3, [fp, #9]	@ zero_extendqisi2
	strb	r8, [r10]
	ldr	r2, [sp, #16]
	str	r3, [sp]
	orr	r1, r4, r1, lsl #24
	mov	r3, r7
	bl	flash_read_page
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	adds	r2, r0, #1
	strb	r3, [r10]
	beq	.L1404
.L1418:
	mov	r6, r0
.L1394:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1402:
	ldr	r3, .L1419+44
	mov	r2, r4
	ldr	r1, [sp, #8]
	mov	r0, r5
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r7, [sp]
	str	r3, [sp, #4]
	ldr	r3, [sp, #16]
	blx	r8
	adds	r3, r0, #1
	beq	.L1403
	b	.L1418
.L1420:
	.align	2
.L1419:
	.word	.LANCHOR8
	.word	.LANCHOR120
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR11
	.word	.LANCHOR13
	.word	.LANCHOR115
	.word	.LANCHOR29
	.word	.LC54
	.word	.LANCHOR35
	.word	.LANCHOR19
	.word	.LANCHOR14
	.word	.LANCHOR12
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1458
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldrb	r5, [r3]	@ zero_extendqisi2
	cmp	r5, #255
	bne	.L1422
.L1440:
	movs	r4, #0
	b	.L1421
.L1422:
	ldr	r6, .L1458+4
	movs	r3, #48
	mla	r3, r3, r5, r6
	ldrb	r2, [r3, #42]	@ zero_extendqisi2
	ldr	r4, [r3, #24]
	subs	r3, r2, #1
	cmp	r3, #9
	bhi	.L1440
	tbb	[pc, r3]
.L1425:
	.byte	(.L1424-.L1425)/2
	.byte	(.L1424-.L1425)/2
	.byte	(.L1426-.L1425)/2
	.byte	(.L1426-.L1425)/2
	.byte	(.L1426-.L1425)/2
	.byte	(.L1427-.L1425)/2
	.byte	(.L1428-.L1425)/2
	.byte	(.L1429-.L1425)/2
	.byte	(.L1426-.L1425)/2
	.byte	(.L1429-.L1425)/2
	.p2align 1
.L1424:
	movs	r1, #64
	mov	r0, r4
	bl	flash_wait_device_ready
	lsls	r0, r0, #25
	bpl	.L1440
	movs	r3, #48
	mov	r0, r4
	mla	r5, r3, r5, r6
	ldr	r3, [r5, #4]
	ldr	r1, [r5, #8]
	ldr	r2, [r5, #12]
	cmp	r1, #0
	it	eq
	moveq	r1, r3
	bl	flash_complete_page_read
	movs	r3, #12
	str	r0, [r5, #36]
	strb	r3, [r5, #42]
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #8
	strb	r3, [r5, #2]
	b	.L1440
.L1426:
	movs	r1, #64
	mov	r0, r4
	bl	flash_wait_device_ready
	lsls	r1, r0, #25
	mov	r4, r0
	bpl	.L1440
	ands	r2, r0, #5
	mov	r3, #48
	mla	r5, r3, r5, r6
	beq	.L1439
	movs	r3, #11
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	strb	r3, [r5, #42]
	ldr	r0, .L1458+8
	str	r3, [sp]
	ldr	r3, [r5, #24]
	ldr	r2, [r5, #36]
	bl	printf
.L1457:
	mov	r3, #-1
	str	r3, [r5, #36]
	b	.L1421
.L1429:
	add	r3, r5, r5, lsl #1
	cmp	r2, #10
	it	eq
	moveq	r1, #9
	add	r3, r6, r3, lsl #4
	it	ne
	movne	r1, #3
	ubfx	r0, r4, #21, #3
	movs	r7, #48
.L1434:
	ldrb	r8, [r3]	@ zero_extendqisi2
	cmp	r8, #255
	bne	.L1438
	mov	r4, #-1
	b	.L1421
.L1438:
	mla	r2, r7, r8, r6
	add	r3, r8, r8, lsl #1
	ldrb	ip, [r2, #42]	@ zero_extendqisi2
	add	r3, r6, r3, lsl #4
	cmp	ip, r1
	bne	.L1434
	ldr	r2, [r2, #24]
	ubfx	r2, r2, #21, #3
	cmp	r0, r2
	bne	.L1434
	mov	r0, r4
	movs	r1, #64
	bl	flash_wait_device_ready
	ands	r4, r0, #64
	mov	r10, r0
	beq	.L1436
	ands	r4, r0, #15
	mul	r7, r7, r5
	beq	.L1437
	adds	r4, r6, r7
	movs	r7, #11
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1458+8
	str	r7, [sp]
	ldr	r3, [r4, #24]
	ldr	r2, [r4, #36]
	bl	printf
	mov	r3, #-1
	strb	r7, [r4, #42]
	str	r3, [r4, #36]
	mov	r4, r10
.L1436:
	movs	r3, #48
	mla	r5, r3, r5, r6
	mla	r6, r3, r8, r6
	ldrb	r2, [r5, #42]	@ zero_extendqisi2
	ldr	r3, [r5, #36]
	strb	r2, [r6, #42]
	str	r3, [r6, #36]
.L1421:
	mov	r0, r4
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1437:
	add	r7, r7, r6
	movs	r3, #12
	strb	r3, [r7, #42]
	str	r4, [r7, #36]
	b	.L1436
.L1427:
	mov	r0, r4
	movs	r1, #32
	bl	flash_wait_device_ready
	lsls	r2, r0, #26
	mov	r4, r0
	bpl	.L1440
	ands	r2, r0, #15
	mov	r3, #48
	mla	r5, r3, r5, r6
	beq	.L1439
	movs	r3, #11
	strb	r3, [r5, #42]
	b	.L1457
.L1439:
	movs	r3, #12
	str	r2, [r5, #36]
	strb	r3, [r5, #42]
	b	.L1440
.L1428:
	movs	r1, #64
	mov	r0, r4
	bl	flash_wait_device_ready
	lsls	r3, r0, #25
	bpl	.L1440
	movs	r3, #48
	mla	r5, r3, r5, r6
	movs	r3, #6
	str	r0, [r5, #36]
	strb	r3, [r5, #42]
	b	.L1440
.L1459:
	.align	2
.L1458:
	.word	.LANCHOR90
	.word	.LANCHOR36
	.word	.LC55
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",%progbits
	.align	1
	.global	sblk_wait_write_queue_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L1463
.L1461:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L1462
	pop	{r4, pc}
.L1462:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1461
.L1464:
	.align	2
.L1463:
	.word	.LANCHOR90
	.size	sblk_wait_write_queue_completed, .-sblk_wait_write_queue_completed
	.section	.text.ftl_read_page,"ax",%progbits
	.align	1
	.global	ftl_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_page, %function
ftl_read_page:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r8, [sp, #24]
	mov	r5, r1
	mov	r6, r2
	mov	r7, r3
	bl	sblk_wait_write_queue_completed
	str	r8, [sp, #24]
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, lr}
	b	flash_read_page_en
	.size	ftl_read_page, .-ftl_read_page
	.section	.text.ftl_read_ppa_page,"ax",%progbits
	.align	1
	.global	ftl_read_ppa_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_ppa_page, %function
ftl_read_ppa_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	mov	r7, r3
	bl	sblk_wait_write_queue_completed
	str	r7, [sp]
	mov	r3, r6
	mov	r2, r5
	mov	r1, r4
	ubfx	r0, r4, #21, #3
	bl	flash_read_page_en
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
	.size	ftl_read_ppa_page, .-ftl_read_ppa_page
	.section	.text.ftl_open_sblk_read_test,"ax",%progbits
	.align	1
	.global	ftl_open_sblk_read_test
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_open_sblk_read_test, %function
ftl_open_sblk_read_test:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r8, .L1477+20
	sub	sp, sp, #32
	mov	r4, r0
	add	r1, sp, #16
	bl	ftl_get_blk_list_in_sblk
	strh	r4, [sp]	@ movhi
	strb	r0, [sp, #9]
.L1468:
	ldr	r3, .L1477
	ldrh	r2, [r3]
	uxth	r3, r5
	cmp	r2, r3
	bls	.L1467
	movs	r4, #0
	ldr	r7, .L1477+4
	b	.L1470
.L1473:
	uxth	r3, r4
	add	r2, sp, #32
	add	r3, r2, r3, lsl #1
	ldrh	r0, [r3, #-16]
	movw	r3, #65535
	cmp	r0, r3
	bne	.L1469
.L1472:
	adds	r4, r4, #1
.L1470:
	ldrb	r2, [r7]	@ zero_extendqisi2
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L1473
	adds	r5, r5, #1
	b	.L1468
.L1469:
	ldr	r3, .L1477+8
	uxth	r6, r5
	ldr	r2, .L1477+12
	ldr	r1, .L1477+16
	ldrh	ip, [r3]
	ldrb	r3, [r8]	@ zero_extendqisi2
	mla	r0, r0, ip, r6
	bl	ftl_read_ppa_page
	cmp	r0, #512
	bne	.L1472
.L1467:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1478:
	.align	2
.L1477:
	.word	.LANCHOR79
	.word	.LANCHOR69
	.word	.LANCHOR75
	.word	.LANCHOR121
	.word	ftl_tmp_buffer
	.word	.LANCHOR45
	.size	ftl_open_sblk_read_test, .-ftl_open_sblk_read_test
	.section	.text.sblk_read_page,"ax",%progbits
	.align	1
	.global	sblk_read_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_read_page, %function
sblk_read_page:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r10, .L1493
	mov	r5, r1
	mov	r8, r0
	mov	r6, r1
.L1480:
	cbnz	r6, .L1484
.L1492:
	ldr	r6, .L1493
.L1485:
	cbnz	r5, .L1488
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1484:
	ldrb	r7, [r8]	@ zero_extendqisi2
	ldr	fp, [r8, #24]
.L1481:
	movs	r1, #0
	mov	r0, fp
	bl	queue_lun_state
	cbnz	r0, .L1482
	str	r0, [sp, #4]
	movs	r0, #48
	ldr	r1, [r8, #24]
	bl	flash_start_page_read
	ldr	r2, [sp, #4]
	movs	r1, #1
	strb	r1, [r8, #42]
	mov	r1, r8
	ldr	r0, .L1493+4
	strb	r2, [r8, #43]
	movs	r2, #255
	strb	r2, [r8]
	bl	buf_add_tail
	subs	r6, r6, #1
	beq	.L1492
	add	r7, r7, r7, lsl #1
	add	r8, r10, r7, lsl #4
	b	.L1480
.L1482:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1481
.L1488:
	ldrb	r3, [r4, #42]	@ zero_extendqisi2
	cmp	r3, #12
	bne	.L1486
	ldrb	r4, [r4]	@ zero_extendqisi2
	subs	r5, r5, #1
	add	r4, r4, r4, lsl #1
	add	r4, r6, r4, lsl #4
	b	.L1485
.L1486:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1485
.L1494:
	.align	2
.L1493:
	.word	.LANCHOR36
	.word	.LANCHOR90
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.gc_check_data_one_wl,"ax",%progbits
	.align	1
	.global	gc_check_data_one_wl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r3, .L1520
	ldr	r4, .L1520+4
	ldr	r8, [r3]
	ldr	r3, [r4, #8]
	cbnz	r3, .L1496
	movs	r0, #1
	bl	buf_alloc
	str	r0, [r4, #8]
.L1496:
	ldr	r5, [r4, #8]
	cbz	r5, .L1497
	ldr	fp, .L1520+40
	add	r10, r8, #96
	movs	r7, #0
.L1498:
	ldrb	r3, [r8, #89]	@ zero_extendqisi2
	cmp	r7, r3
	bge	.L1508
	movs	r6, #1
	b	.L1509
.L1497:
	movw	r2, #333
	ldr	r1, .L1520+8
	ldr	r0, .L1520+12
	bl	printf
.L1499:
	b	.L1499
.L1507:
	ldrh	r3, [fp]
	ldrh	r2, [r10]
	muls	r2, r3, r2
	ldr	r3, .L1520+16
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldrh	r3, [r4, #12]
	cmp	r1, #3
	bne	.L1500
	add	r3, r3, r2
	orr	r3, r3, r6, lsl #24
.L1519:
	movs	r1, #1
	str	r3, [r5, #24]
	mov	r0, r5
	bl	sblk_read_page
	ldr	r2, [r5, #36]
	ldr	r1, .L1520+20
	adds	r0, r2, #1
	beq	.L1503
	ldr	r3, [r1]
	ldrh	ip, [r4, #18]
	ldr	r0, [r5, #12]
	ldr	lr, [r3, ip, lsl #2]
	ldr	r3, [r0, #4]
	cmp	lr, r3
	bne	.L1503
	ldr	r3, .L1520+24
	ldr	r3, [r3]
	ldr	ip, [r3, ip, lsl #2]
	ldr	r3, [r0, #8]
	cmp	ip, r3
	beq	.L1504
.L1503:
	ldrh	r3, [r4, #18]
	ldr	r1, [r1]
	lsls	r0, r3, #2
	ldr	r3, [r1, r3, lsl #2]
	adds	r1, r3, #1
	beq	.L1504
	ldr	r1, .L1520+28
	ldr	r1, [r1]
	lsls	r1, r1, #21
	bpl	.L1505
	ldr	r1, [r5, #12]
	ldr	r4, [r1, #12]
	str	r4, [sp, #16]
	ldr	r4, [r1, #8]
	str	r4, [sp, #12]
	ldr	r4, [r1, #4]
	str	r4, [sp, #8]
	ldr	r1, [r1]
	str	r1, [sp, #4]
	ldr	r1, .L1520+24
	ldr	r1, [r1]
	ldr	r1, [r1, r0]
	ldr	r0, .L1520+32
	str	r1, [sp]
	ldr	r1, [r5, #24]
	bl	printf
.L1505:
	ldr	r3, .L1520+36
	mov	r0, #-1
	ldrh	r2, [r8, #80]
	movs	r1, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
.L1495:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1500:
	cmp	r1, #2
	itett	eq
	addeq	r3, r3, #-1
	addne	r3, r3, r2
	addeq	r3, r3, r2
	addeq	r3, r3, r6
	it	eq
	orreq	r3, r3, #33554432
	b	.L1519
.L1504:
	ldrh	r3, [r4, #18]
	adds	r6, r6, #1
	adds	r3, r3, #1
	strh	r3, [r4, #18]	@ movhi
.L1509:
	ldrh	r3, [r4, #16]
	cmp	r6, r3
	ble	.L1507
	adds	r7, r7, #1
	add	r10, r10, #2
	b	.L1498
.L1508:
.L1506:
	ldrh	r3, [r4, #12]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #12]	@ movhi
	b	.L1495
.L1521:
	.align	2
.L1520:
	.word	.LANCHOR60
	.word	.LANCHOR59
	.word	.LANCHOR122
	.word	.LC0
	.word	.LANCHOR64
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR22
	.word	.LC56
	.word	.LANCHOR56
	.word	.LANCHOR75
	.size	gc_check_data_one_wl, .-gc_check_data_one_wl
	.section	.text.flash_prog_page,"ax",%progbits
	.align	1
	.global	flash_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_prog_page, %function
flash_prog_page:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r3
	ldr	r3, .L1530
	mov	r5, r0
	mov	r6, r1
	mov	r10, r2
	ubfx	r8, r1, #0, #21
	ubfx	r7, r1, #24, #2
	ldr	r4, [r3]
	add	r3, r0, #8
	add	r3, r4, r3, lsl #8
	str	r3, [sp, #4]
	ldr	r3, .L1530+4
	ldr	r3, [r3]
	lsls	r3, r3, #27
	bpl	.L1523
	ldr	r3, [sp, #40]
	mov	r2, r7
	ldr	r0, .L1530+8
	bl	printf
.L1523:
	bl	nandc_wait_flash_ready
	mov	r0, r5
	bl	hynix_reconfig_rr_para
	mov	r0, r5
	bl	nandc_cs
	mov	r0, r5
	cbnz	r7, .L1524
	bl	flash_enter_slc_mode
.L1525:
	add	r4, r4, r5, lsl #8
	movs	r3, #128
	uxtb	r6, r6
	mov	r0, r8
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	lsr	r3, r8, #8
	str	r6, [r4, #2052]
	str	r3, [r4, #2052]
	lsr	r3, r8, #16
	str	r3, [r4, #2052]
	bl	nandc_set_seed
	ldr	r1, .L1530+12
	mov	r2, r10
	mov	r3, fp
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	movs	r3, #16
	str	r3, [r4, #2056]
	bl	nandc_wait_flash_ready
	ldr	r0, [sp, #4]
	bl	flash_read_status
	mov	r4, r0
	cbnz	r7, .L1526
	mov	r0, r5
	bl	flash_exit_slc_mode
.L1526:
	mov	r0, r5
	bl	nandc_de_cs
	and	r0, r4, #4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1524:
	bl	flash_exit_slc_mode
	b	.L1525
.L1531:
	.align	2
.L1530:
	.word	.LANCHOR6
	.word	.LANCHOR22
	.word	.LC57
	.word	.LANCHOR19
	.size	flash_prog_page, .-flash_prog_page
	.section	.text.flash_test_blk,"ax",%progbits
	.align	1
	.global	flash_test_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_test_blk, %function
flash_test_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r1
	mov	r4, r0
	cbnz	r0, .L1533
	ldr	r3, .L1550
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r1
	bhi	.L1537
.L1533:
	ldr	r6, .L1550+4
	movs	r2, #32
	ldr	r7, .L1550+8
	movs	r1, #165
	ldr	r0, [r6]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r3, .L1550+12
	mov	r0, r4
	ldrh	r3, [r3]
	muls	r5, r3, r5
	mov	r1, r5
	bl	flash_erase_block
	adds	r0, r0, #1
	beq	.L1535
	ldr	r8, .L1550+16
	mov	r1, r5
	mov	r0, r4
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r6]
	bl	flash_prog_page
	adds	r0, r0, #1
	beq	.L1535
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r4
	str	r3, [sp]
	ldr	r2, [r7]
	ldr	r3, [r6]
	bl	flash_read_page
	cmp	r0, #-1
	mov	r8, r0
	beq	.L1535
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r3, #1515870810
	bne	.L1535
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r3, #-1515870811
	beq	.L1536
.L1535:
	mov	r8, #-1
.L1536:
	mov	r1, r5
	mov	r0, r4
	bl	flash_erase_block
	mov	r0, r8
.L1532:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1537:
	b	.L1532
.L1551:
	.align	2
.L1550:
	.word	.LANCHOR123
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR13
	.word	.LANCHOR19
	.size	flash_test_blk, .-flash_test_blk
	.section	.text.flash_start_tlc_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_tlc_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	@ args = 12, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	ldr	r2, .L1559
	add	r5, sp, #40
	mov	r4, r0
	mov	fp, r1
	ldm	r5, {r5, r8, r10}
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1553
	movw	r2, #655
	ldr	r1, .L1559+4
	ldr	r0, .L1559+8
	bl	printf
.L1554:
	b	.L1554
.L1553:
	ldr	r2, .L1559+12
	ldrb	r6, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1559+16
	mov	r0, r6
	ldr	r2, [r3]
	str	r2, [sp, #4]
	bl	nandc_cs
	lsls	r3, r6, #8
	ldr	r2, [sp, #4]
	cbz	r4, .L1555
	adds	r1, r2, r3
	str	r4, [r1, #2056]
.L1555:
	adds	r4, r2, r3
	movs	r3, #128
	str	fp, [r4, #2056]
	str	r3, [r4, #2056]
	movs	r3, #0
	str	r3, [r4, #2052]
	str	r3, [r4, #2052]
	uxtb	r3, r5
	str	r3, [r4, #2052]
	lsrs	r3, r5, #8
	str	r3, [r4, #2052]
	lsrs	r3, r5, #16
	add	r5, r5, r5, lsl #1
	str	r3, [r4, #2052]
	subs	r0, r5, #1
	add	r0, r0, fp
	bl	nandc_set_seed
	ldr	r1, .L1559+20
	mov	r3, r10
	mov	r2, r8
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r7, [r4, #2056]
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs
.L1560:
	.align	2
.L1559:
	.word	.LANCHOR8
	.word	.LANCHOR124
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR19
	.size	flash_start_tlc_page_prog, .-flash_start_tlc_page_prog
	.section	.text.queue_tlc_prog_cmd,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_tlc_prog_cmd, %function
queue_tlc_prog_cmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, lr}
	mov	r4, r0
	ldr	r3, [r0]
	movs	r1, #1
	ldr	r2, [r3, #12]
	ldr	r5, [r3, #24]
	ldrb	r0, [r3, #44]	@ zero_extendqisi2
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	ubfx	r6, r5, #0, #21
	ubfx	r5, r5, #21, #3
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r4, {r2, r3}
	movs	r1, #2
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	ldr	r1, [r4]
	movs	r3, #4
	ldr	r0, .L1562
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, lr}
	b	buf_add_tail
.L1563:
	.align	2
.L1562:
	.word	.LANCHOR90
	.size	queue_tlc_prog_cmd, .-queue_tlc_prog_cmd
	.section	.text.sblk_tlc_prog_one_page,"ax",%progbits
	.align	1
	.global	sblk_tlc_prog_one_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_tlc_prog_one_page, %function
sblk_tlc_prog_one_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0]
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldr	r6, [r3, #24]
.L1565:
	movs	r1, #1
	mov	r0, r6
	bl	queue_lun_state
	mov	r4, r0
	cbnz	r0, .L1566
	mov	r0, r5
	bl	queue_tlc_prog_cmd
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L1566:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1565
	.size	sblk_tlc_prog_one_page, .-sblk_tlc_prog_one_page
	.section	.text.sblk_xlc_prog_pages,"ax",%progbits
	.align	1
	.global	sblk_xlc_prog_pages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_xlc_prog_pages, %function
sblk_xlc_prog_pages:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0]
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #20
	mov	r7, r1
	mov	r10, r2
	ldr	r5, [r3, #24]
.L1568:
	movs	r1, #1
	mov	r0, r5
	bl	queue_lun_state
	cmp	r0, #0
	bne	.L1569
	cmp	r10, #2
	bne	.L1570
	ldr	r2, [r7]
	movs	r1, #1
	ldr	r3, [r4]
	ldr	r6, [r2, #24]
	ldr	r2, [r3, #12]
	ldr	r5, [r3, #24]
	ldrb	r0, [r3, #44]	@ zero_extendqisi2
	ubfx	r6, r6, #0, #21
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	ubfx	r8, r5, #0, #21
	ubfx	r5, r5, #21, #3
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7]
	movs	r1, #1
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldm	r4, {r2, r3}
	mov	r1, r10
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7, #4]
	mov	r1, r10
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #26
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r4, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #17
	ldr	r3, [r3, #4]
	str	r8, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	r3, [r7, #8]
	movs	r1, #3
	ldr	r2, [r4]
	ldrb	r0, [r2, #44]	@ zero_extendqisi2
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	movs	r2, #16
	ldr	r3, [r3, #4]
	str	r6, [sp]
	str	r3, [sp, #4]
	mov	r3, r5
	bl	flash_start_tlc_page_prog
	ldr	r1, [r4]
	movs	r3, #5
	ldr	r0, .L1572
	strb	r3, [r1, #42]
	movs	r3, #1
	strb	r3, [r1, #43]
	movs	r3, #255
	strb	r3, [r1]
	bl	buf_add_tail
.L1571:
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1569:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1568
.L1570:
	mov	r0, r4
	bl	queue_tlc_prog_cmd
	b	.L1571
.L1573:
	.align	2
.L1572:
	.word	.LANCHOR90
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.flash_start_page_prog,"ax",%progbits
	.align	1
	.global	flash_start_page_prog
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r2
	ldr	r2, .L1585
	mov	r10, r3
	ubfx	r3, r1, #21, #3
	mov	r7, r0
	mov	fp, r1
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1575
	mov	r2, #692
	ldr	r1, .L1585+4
	ldr	r0, .L1585+8
	bl	printf
.L1576:
	b	.L1576
.L1575:
	ldr	r2, .L1585+12
	ubfx	r4, r1, #0, #21
	ldrb	r6, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1585+16
	mov	r0, r6
	ldr	r5, [r3]
	bl	hynix_reconfig_rr_para
	mov	r0, r6
	bl	nandc_cs
	tst	fp, #50331648
	bne	.L1577
	ldr	r3, .L1585+20
	ldr	r2, .L1585+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1578
	ldrb	r3, [r2]	@ zero_extendqisi2
	cbz	r3, .L1579
.L1578:
	ldr	r3, .L1585+28
	mov	r0, r4
	str	r2, [sp, #4]
	ldrh	fp, [r3]
	mov	r1, fp
	bl	__aeabi_uidiv
	mul	r3, fp, r0
	mov	r1, fp
	mov	r0, r4
	str	r3, [sp]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #4]
	ldr	r3, [sp]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L1580
	add	r4, r3, r1, lsl #1
.L1579:
	mov	r0, r6
	bl	flash_enter_slc_mode
	b	.L1581
.L1580:
	ldr	r2, .L1585+32
	ldrh	r4, [r2, r1, lsl #1]
	add	r4, r4, r3
.L1581:
	add	r5, r5, r6, lsl #8
	movs	r3, #128
	mov	r0, r4
	str	r3, [r5, #2056]
	movs	r3, #0
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	uxtb	r3, r4
	str	r3, [r5, #2052]
	lsrs	r3, r4, #8
	str	r3, [r5, #2052]
	lsrs	r3, r4, #16
	str	r3, [r5, #2052]
	bl	nandc_set_seed
	ldr	r1, .L1585+36
	mov	r3, r10
	mov	r2, r8
	movs	r0, #1
	ldrb	r1, [r1, #9]	@ zero_extendqisi2
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	r7, [r5, #2056]
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	nandc_de_cs
.L1577:
	mov	r0, r6
	bl	flash_exit_slc_mode
	b	.L1581
.L1586:
	.align	2
.L1585:
	.word	.LANCHOR8
	.word	.LANCHOR125
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR6
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LANCHOR19
	.size	flash_start_page_prog, .-flash_start_page_prog
	.section	.text.queue_prog_cmd,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	queue_prog_cmd, %function
queue_prog_cmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	ldr	r3, [r0, #12]
	ldr	r2, [r0, #4]
	ldr	r1, [r0, #24]
	movs	r0, #16
	bl	flash_start_page_prog
	ldr	r3, .L1595
	ldr	r2, [r4, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1588
	ldr	r6, .L1595+4
	ubfx	r2, r2, #21, #3
	movs	r5, #48
	mov	r7, r6
.L1590:
	mla	r1, r5, r3, r6
	ldr	r0, [r1, #24]
	ubfx	r0, r0, #21, #3
	cmp	r2, r0
	bne	.L1589
	add	r0, r1, #42
	ldrb	r1, [r1, #42]	@ zero_extendqisi2
	cmp	r1, #6
	bne	.L1589
	movs	r3, #3
	strb	r3, [r0]
.L1588:
	movs	r3, #3
	mov	r1, r4
	strb	r3, [r4, #42]
	movs	r3, #1
	strb	r3, [r4, #43]
	movs	r3, #255
	strb	r3, [r4]
	ldr	r0, .L1595
	pop	{r3, r4, r5, r6, r7, lr}
	b	buf_add_tail
.L1589:
	muls	r3, r5, r3
	ldrb	r3, [r7, r3]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L1590
	b	.L1588
.L1596:
	.align	2
.L1595:
	.word	.LANCHOR90
	.word	.LANCHOR36
	.size	queue_prog_cmd, .-queue_prog_cmd
	.section	.text.sblk_prog_page,"ax",%progbits
	.align	1
	.global	sblk_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sblk_prog_page, %function
sblk_prog_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0, #34]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r5, r1
	cbz	r3, .L1598
	ldr	r3, .L1620
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L1598
	mov	r2, r1
	ldr	r1, [r0, #24]
	ldr	r0, .L1620+4
	bl	printf
.L1598:
	movs	r6, #0
.L1599:
	cbnz	r5, .L1610
	mov	r0, r5
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1610:
	ldrb	r7, [r4]	@ zero_extendqisi2
	ldr	r10, [r4, #24]
.L1600:
	movs	r1, #1
	mov	r0, r10
	bl	queue_lun_state
	mov	fp, r0
	cbnz	r0, .L1601
	cmp	r5, #1
	beq	.L1602
	ldr	r3, .L1620+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1603
.L1602:
	mov	r0, r4
	bl	queue_prog_cmd
.L1604:
	ldr	r3, .L1620+12
	add	r7, r7, r7, lsl #1
	subs	r5, r5, #1
	add	r4, r3, r7, lsl #4
	b	.L1599
.L1601:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1600
.L1603:
	ldrb	r3, [r4]	@ zero_extendqisi2
	ubfx	r2, r10, #21, #3
	cmp	r3, #255
	bne	.L1605
	mov	r2, #478
	ldr	r1, .L1620+16
	ldr	r0, .L1620+20
	bl	printf
.L1606:
	b	.L1606
.L1605:
	ldr	r0, .L1620+12
	movs	r1, #48
	mla	r3, r1, r3, r0
	ldr	ip, [r3, #24]
	ubfx	r3, ip, #21, #3
	cmp	r2, r3
	bne	.L1607
	ldr	r3, .L1620+24
	mov	r8, #1
	ldrh	r1, [r3]
	ldr	r3, .L1620+28
	lsl	r2, r8, r1
	ldrb	r0, [r3]	@ zero_extendqisi2
	rsb	r3, r1, #21
	lsl	r3, r8, r3
	subs	r2, r2, #1
	uxth	r2, r2
	subs	r0, r0, #1
	subs	r3, r3, #1
	ands	r3, r3, r0
	and	lr, r2, r10
	uxth	r3, r3
	lsr	r10, r10, r1
	lsr	r1, ip, r1
	and	r10, r3, r10
	ands	r1, r1, r3
	and	r2, r2, ip
	cmp	r10, r1
	beq	.L1608
	cmp	lr, r2
	bne	.L1608
	cmp	r6, r0
	beq	.L1607
	ldr	r3, [r4, #12]
	movs	r0, #17
	ldr	r2, [r4, #4]
	add	r6, r6, r8
	ldr	r1, [r4, #24]
	bl	flash_start_page_prog
	movs	r3, #8
	strb	r8, [r4, #43]
	strb	r3, [r4, #42]
	movs	r3, #255
	strb	r3, [r4]
	mov	r1, r4
	ldr	r0, .L1620+32
	bl	buf_add_tail
	b	.L1604
.L1608:
	mov	r0, r4
	movs	r6, #0
	bl	queue_prog_cmd
	b	.L1604
.L1607:
	mov	r0, r4
	mov	r6, fp
	bl	queue_prog_cmd
	b	.L1604
.L1621:
	.align	2
.L1620:
	.word	.LANCHOR22
	.word	.LC58
	.word	.LANCHOR23
	.word	.LANCHOR36
	.word	.LANCHOR126
	.word	.LC0
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR90
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",%progbits
	.align	1
	.global	ftl_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_flush, %function
ftl_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r4, .L1627
	ldr	r5, .L1627+4
	ldrb	r1, [r4]	@ zero_extendqisi2
	cbz	r1, .L1623
	ldrb	r0, [r5]	@ zero_extendqisi2
	ldr	r3, .L1627+8
	add	r0, r0, r0, lsl #1
	add	r0, r3, r0, lsl #4
	bl	sblk_prog_page
.L1623:
	movs	r3, #255
	strb	r3, [r5]
	movs	r3, #0
	strb	r3, [r4]
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	movw	r0, #65535
	pop	{r3, r4, r5, lr}
	b	ftl_vpn_decrement
.L1628:
	.align	2
.L1627:
	.word	.LANCHOR89
	.word	.LANCHOR127
	.word	.LANCHOR36
	.size	ftl_flush, .-ftl_flush
	.section	.text.flash_prog_page_en,"ax",%progbits
	.align	1
	.global	flash_prog_page_en
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_prog_page_en, %function
flash_prog_page_en:
	@ args = 8, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r3
	ldr	r3, .L1658
	mov	r7, r0
	mov	r5, r1
	mov	r10, r2
	ldrb	r6, [sp, #52]	@ zero_extendqisi2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1630
	mov	r2, #480
	ldr	r1, .L1658+4
	ldr	r0, .L1658+8
	bl	printf
.L1631:
	b	.L1631
.L1630:
	ldr	r3, .L1658+12
	tst	r1, #50331648
	ldrb	fp, [r3, r0]	@ zero_extendqisi2
	bne	.L1642
	ldr	r3, .L1658+16
	ldr	r2, .L1658+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1633
	ldrb	r3, [r2]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1642
.L1633:
	ldr	r3, .L1658+24
	mov	r0, r5
	str	r2, [sp, #12]
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mul	r3, r4, r0
	mov	r1, r4
	mov	r0, r5
	str	r3, [sp, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L1634
	add	r4, r3, r1, lsl #1
.L1632:
	ldr	r3, .L1658+28
	ldr	r3, [r3]
	lsls	r2, r3, #27
	bpl	.L1635
	mov	r2, r5
	mov	r1, fp
	ldr	r0, .L1658+32
	bl	printf
.L1635:
	ldr	r3, [sp, #48]
	mov	r0, fp
	mov	r2, r10
	mov	r1, r4
	str	r3, [sp]
	mov	r3, r8
	bl	flash_prog_page
	mov	fp, r0
	cmp	r6, #0
	beq	.L1636
	ldr	r3, [sp, #48]
	mov	r1, r5
	ldr	r6, .L1658+36
	mov	r0, r7
	ldr	r4, .L1658+40
	str	r3, [sp]
	ldr	r3, [r6]
	ldr	r2, [r4]
	bl	flash_read_page_en
	adds	r3, r0, #1
	beq	.L1637
	cmp	r0, #512
	beq	.L1637
	ldr	r3, [r4]
	ldr	r2, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L1637
	ldr	r3, [r6]
	ldr	r2, [r8]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1636
.L1637:
	movs	r3, #4
	ldr	r1, [r6]
	mov	r2, r3
	ldr	r0, .L1658+44
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4]
	mov	r2, r3
	ldr	r0, .L1658+48
	bl	rknand_print_hex
.L1638:
	mov	r1, r5
	ldr	r0, .L1658+52
	bl	printf
	mov	r2, #506
	ldr	r1, .L1658+4
	ldr	r0, .L1658+8
	bl	printf
.L1640:
	b	.L1640
.L1634:
	ldr	r2, .L1658+56
	ldrh	r4, [r2, r1, lsl #1]
	add	r4, r4, r3
	b	.L1632
.L1642:
	mov	r4, r5
	b	.L1632
.L1636:
	cmp	fp, #-1
	beq	.L1638
	mov	r0, fp
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1659:
	.align	2
.L1658:
	.word	.LANCHOR8
	.word	.LANCHOR128
	.word	.LC0
	.word	.LANCHOR10
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR22
	.word	.LC59
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LC60
	.word	.LC61
	.word	.LC62
	.word	.LANCHOR14
	.size	flash_prog_page_en, .-flash_prog_page_en
	.section	.text.ftl_test_block,"ax",%progbits
	.align	1
	.global	ftl_test_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_test_block, %function
ftl_test_block:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r3, .L1677
	mov	r10, r0
	ldr	fp, .L1677+32
	str	r5, [r3]
	ldr	r3, .L1677+4
	str	r5, [r3]
.L1661:
	uxth	r3, r5
	str	r3, [sp, #12]
	ldr	r3, .L1677+8
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1668
	mov	r8, #0
	b	.L1669
.L1667:
	ldr	r3, .L1677+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1662
	mov	r1, r10
	ldr	r0, .L1677+16
	bl	printf
.L1662:
	ldrb	r4, [fp]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	smulbb	r4, r4, r10
	add	r4, r4, r6
	uxth	r4, r4
	cbnz	r3, .L1663
	ldr	r3, .L1677+20
	ldr	r3, [r3]
	ldrb	r3, [r3, #47]	@ zero_extendqisi2
	cmp	r3, r4
	bcs	.L1664
.L1663:
	uxtb	r6, r5
	mov	r1, r4
	mov	r0, r6
	bl	flash_check_bad_block
	cbnz	r0, .L1664
	ldr	r3, .L1677+24
	mov	r0, r6
	ldrh	r7, [r3]
	muls	r7, r4, r7
	mov	r1, r7
	bl	flash_erase_block
	cbz	r0, .L1666
.L1676:
	mov	r1, r4
	mov	r0, r6
	bl	flash_mask_bad_block
	b	.L1664
.L1666:
	movs	r3, #1
	ldr	r2, .L1677
	str	r3, [sp, #4]
	mov	r1, r7
	ldr	r3, .L1677+28
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1677+4
	bl	flash_prog_page_en
	cmp	r0, #0
	bne	.L1676
.L1664:
	add	r8, r8, #1
.L1669:
	ldrb	r3, [fp]	@ zero_extendqisi2
	uxth	r6, r8
	cmp	r3, r6
	bhi	.L1667
	adds	r5, r5, #1
	b	.L1661
.L1668:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1678:
	.align	2
.L1677:
	.word	ftl_tmp_buffer
	.word	.LANCHOR121
	.word	.LANCHOR76
	.word	.LANCHOR22
	.word	.LC63
	.word	.LANCHOR5
	.word	.LANCHOR75
	.word	.LANCHOR45
	.word	.LANCHOR70
	.size	ftl_test_block, .-ftl_test_block
	.section	.text.ftl_prog_page,"ax",%progbits
	.align	1
	.global	ftl_prog_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_prog_page, %function
ftl_prog_page:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r7, r3
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	bl	sblk_wait_write_queue_completed
	movs	r3, #1
	mov	r2, r6
	str	r3, [sp, #4]
	mov	r1, r5
	ldr	r3, [sp, #32]
	mov	r0, r4
	str	r3, [sp]
	mov	r3, r7
	bl	flash_prog_page_en
	adds	r3, r0, #1
	bne	.L1679
	movw	r2, #1414
	ldr	r1, .L1682
	ldr	r0, .L1682+4
	bl	printf
.L1681:
	b	.L1681
.L1679:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L1683:
	.align	2
.L1682:
	.word	.LANCHOR129
	.word	.LC0
	.size	ftl_prog_page, .-ftl_prog_page
	.section	.text.ftl_info_flush,"ax",%progbits
	.align	1
	.global	ftl_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_flush, %function
ftl_info_flush:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, #0
	ldr	r4, .L1721
	movs	r1, #0
	ldr	r6, .L1721+4
	ldrb	r2, [r4]	@ zero_extendqisi2
	mov	fp, r4
	str	r0, [sp, #12]
	mov	r4, r6
	ldr	r0, .L1721+8
	lsls	r2, r2, #1
	bl	ftl_memset
.L1685:
	ldr	r7, .L1721+12
	ldr	r1, [sp, #12]
	ldrb	r10, [r6]	@ zero_extendqisi2
	ldrh	r3, [r7]
	ldrh	r5, [r6, #2]
	str	r3, [sp, #8]
	ldr	r3, .L1721+16
	ldr	r2, [r3]
	ldr	r3, [r2, #4]
	adds	r3, r3, #1
	str	r3, [r2, #4]
	ldr	r2, .L1721+8
	stm	r2, {r1, r3}
	ldr	r2, .L1721+20
	ldr	r2, [r2]
	lsls	r2, r2, #19
	bpl	.L1686
	mov	r2, r5
	mov	r1, r10
	ldr	r0, .L1721+24
	bl	printf
.L1686:
	ldr	r3, .L1721+28
	ldrh	r0, [r4, #2]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1687
	ldr	r2, .L1721+32
	movs	r0, #0
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r5, [r2]
	ldrb	r2, [r4]	@ zero_extendqisi2
.L1694:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #7
	bls	.L1688
	add	lr, r5, #40
	movs	r1, #0
.L1693:
	ldrb	r8, [lr], #1	@ zero_extendqisi2
	uxth	ip, r1
	cmp	r8, #128
	bls	.L1689
	cmp	r8, #255
	beq	.L1690
	strb	r3, [r4, #1]
	cbz	r0, .L1691
	strb	r2, [r4]
.L1691:
	movs	r2, #156
	ldr	r1, .L1721+36
	ldr	r0, .L1721+40
	bl	printf
.L1692:
	b	.L1692
.L1690:
	adds	r1, r1, #1
	cmp	r1, #8
	bne	.L1693
	mov	ip, r1
.L1689:
	uxtb	r3, ip
	mov	r8, #1
.L1688:
	adds	r2, r5, r3
	ldrb	r2, [r2, #40]	@ zero_extendqisi2
	movs	r0, #1
	cmp	r2, #255
	beq	.L1694
	ldrh	r5, [r7]
	movs	r0, #0
	strb	r3, [r4, #1]
	strb	r2, [r4]
	muls	r5, r2, r5
	mov	r1, r5
	bl	flash_erase_block
	ldrb	r3, [fp]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r2, .L1721+44
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L1721+8
	bl	ftl_prog_page
	movs	r3, #1
	add	r5, r5, r3
	strh	r3, [r4, #2]	@ movhi
.L1695:
	ldrb	r3, [fp]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r2, .L1721+44
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L1721+8
	bl	ftl_prog_page
	ldrh	r3, [r4, #2]
	adds	r0, r0, #1
	add	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	beq	.L1685
	cmp	r8, #0
	bne	.L1696
.L1704:
	ldrb	r3, [r4]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L1720
	movs	r2, #191
	ldr	r1, .L1721+36
	ldr	r0, .L1721+40
	bl	printf
.L1705:
	b	.L1705
.L1687:
	ldr	r3, [sp, #8]
	mla	r5, r10, r3, r5
	cmp	r0, #0
	bne	.L1695
	mov	r1, r5
	bl	flash_erase_block
	b	.L1695
.L1696:
	ldrb	r5, [r4, #1]	@ zero_extendqisi2
	ldr	r6, .L1721+32
	adds	r5, r5, #1
.L1699:
	cmp	r5, #7
	bhi	.L1704
	ldr	r3, [r6]
	add	r3, r3, r5
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	uxth	r2, r3
	cmp	r2, #128
	bls	.L1700
	cmp	r2, #255
	beq	.L1701
	movs	r2, #184
	ldr	r1, .L1721+36
	ldr	r0, .L1721+40
	bl	printf
.L1702:
	b	.L1702
.L1700:
	ldr	r2, .L1721+12
	movs	r0, #0
	ldrh	r1, [r2]
	muls	r1, r3, r1
	bl	flash_erase_block
.L1701:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L1699
.L1720:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1722:
	.align	2
.L1721:
	.word	.LANCHOR45
	.word	.LANCHOR131
	.word	.LANCHOR130
	.word	.LANCHOR75
	.word	.LANCHOR46
	.word	.LANCHOR22
	.word	.LC64
	.word	.LANCHOR79
	.word	.LANCHOR5
	.word	.LANCHOR132
	.word	.LC0
	.word	ftl_info_data_buffer
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",%progbits
	.align	1
	.global	ftl_info_blk_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L1755
	mov	r1, r4
	mov	r2, #16384
	ldr	r0, .L1755+4
	strb	r4, [r3]
	ldr	r3, .L1755+8
	ldr	r5, .L1755+12
	ldr	r6, .L1755+16
	str	r0, [r3]
	ldr	r3, .L1755+20
	ldrh	r3, [r3]
	add	r3, r0, r3, lsl #2
	str	r3, [r5]
	bl	ftl_memset
	mov	r2, #16384
	mov	r1, r4
	ldr	r0, .L1755+24
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, .L1755+28
	ldrb	r2, [r2, #40]	@ zero_extendqisi2
	strb	r4, [r3, #1]
	strh	r4, [r3, #2]	@ movhi
	movs	r4, #7
	strb	r2, [r3]
	str	r3, [sp, #12]
.L1725:
	ldr	r3, [r6]
	sxth	r8, r4
	add	r3, r3, r4
	ldrb	r7, [r3, #40]	@ zero_extendqisi2
	cmp	r7, #255
	bne	.L1724
.L1729:
	adds	r4, r4, #-1
	bcs	.L1725
	mov	r8, #0
.L1726:
	ldr	r3, .L1755+32
	ldr	r3, [r3]
	lsls	r1, r3, #19
	bpl	.L1730
	ldr	r3, [r5]
	mov	r2, #4800
	mov	r1, r4
	ldr	r0, .L1755+36
	ldr	r3, [r3]
	bl	printf
.L1730:
	adds	r2, r4, #1
	bne	.L1731
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L1755+4
	bl	ftl_memset
	ldr	r3, [r5]
	mov	r0, r4
	ldr	r2, .L1755+40
	str	r2, [r3]
.L1723:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1724:
	ldr	r3, .L1755+44
	movs	r0, #0
	ldr	fp, .L1755+56
	ldr	r2, .L1755+4
	ldrh	r3, [r3]
	muls	r7, r3, r7
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r1, r7
	ldr	r3, .L1755+48
	bl	ftl_read_page
	cmp	r0, #-1
	mov	r10, r0
	bne	.L1727
	ldrb	r3, [fp]	@ zero_extendqisi2
	adds	r1, r7, #1
	ldr	r2, .L1755+4
	movs	r0, #0
	str	r3, [sp]
	ldr	r3, .L1755+48
	bl	ftl_read_page
	mov	r10, r0
.L1727:
	ldr	r3, .L1755+32
	ldr	r3, [r3]
	lsls	r0, r3, #19
	bpl	.L1728
	ldr	r3, [r5]
	mov	r2, r10
	mov	r1, r4
	ldr	r0, .L1755+52
	ldr	r3, [r3]
	str	r3, [sp]
	movs	r3, #64
	bl	printf
.L1728:
	cmp	r10, #-1
	beq	.L1729
	ldr	r3, [r5]
	ldr	r2, .L1755+40
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1729
	mov	r4, r8
	b	.L1726
.L1731:
	ldr	r3, [r6]
	movs	r0, #0
	ldr	r2, .L1755+4
	movs	r4, #0
	ldr	r10, .L1755+40
	add	r3, r3, r8
	ldrb	r1, [r3, #40]	@ zero_extendqisi2
	ldr	r3, [sp, #12]
	strb	r8, [r3, #1]
	strb	r1, [r3]
	movs	r3, #4
	str	r3, [sp]
	ldr	r3, .L1755+48
	bl	flash_get_last_written_page
	uxth	r6, r0
	mov	r7, r0
	adds	r3, r6, #1
	uxth	r8, r3
	ldr	r3, [sp, #12]
	ldrb	fp, [r3]	@ zero_extendqisi2
	ldr	r3, .L1755+44
	ldrh	r3, [r3]
	mul	fp, r3, fp
.L1733:
	subs	r3, r6, r4
	lsls	r3, r3, #16
	bmi	.L1738
	ldr	r3, .L1755+56
	add	r1, r7, fp
	ldr	r2, .L1755+4
	subs	r1, r1, r4
	movs	r0, #0
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1755+48
	bl	ftl_read_page
	adds	r0, r0, #1
	beq	.L1734
	ldr	r3, [r5]
	ldr	r3, [r3]
	cmp	r3, r10
	bne	.L1734
.L1738:
	ldr	r3, [sp, #12]
	strh	r8, [r3, #2]	@ movhi
	ldr	r3, [r5]
	ldr	r2, [r3, #16]
	cmp	r2, #2048
	bhi	.L1735
.L1736:
	ldr	r2, [r3, #24]
	cmp	r2, #2048
	bls	.L1739
	ldr	r1, [r3, #28]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #24]
	str	r1, [r3, #28]
.L1739:
	ldr	r2, [r3, #32]
	cmp	r2, #1024
	bls	.L1740
	ldr	r1, [r3, #36]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #32]
	str	r1, [r3, #36]
.L1740:
	ldr	r2, [r3, #40]
	cmp	r2, #1024
	bls	.L1741
	ldr	r1, [r3, #44]
	add	r1, r1, r2, lsr #10
	ubfx	r2, r2, #0, #10
	str	r2, [r3, #40]
	str	r1, [r3, #44]
.L1741:
	ldr	r2, [r3, #64]
	movs	r0, #0
	adds	r2, r2, #1
	str	r2, [r3, #64]
	bl	ftl_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	movs	r0, #0
	b	.L1723
.L1734:
	adds	r4, r4, #1
	b	.L1733
.L1735:
	ldr	r1, [r3, #20]
	add	r1, r1, r2, lsr #11
	ubfx	r2, r2, #0, #11
	str	r2, [r3, #16]
	str	r1, [r3, #20]
	b	.L1736
.L1756:
	.align	2
.L1755:
	.word	.LANCHOR133
	.word	ftl_info_data_buffer
	.word	.LANCHOR57
	.word	.LANCHOR46
	.word	.LANCHOR5
	.word	.LANCHOR54
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR131
	.word	.LANCHOR22
	.word	.LC66
	.word	1229739078
	.word	.LANCHOR75
	.word	.LANCHOR130
	.word	.LC65
	.word	.LANCHOR45
	.size	ftl_info_blk_init, .-ftl_info_blk_init
	.section	.text.ftl_ext_info_flush,"ax",%progbits
	.align	1
	.global	ftl_ext_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_info_flush, %function
ftl_ext_info_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1771
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r3]
	ldr	r2, [r3, #520]
	cbz	r2, .L1758
	movs	r2, #0
	str	r2, [r3, #520]
.L1758:
	ldr	r5, .L1771+4
	movs	r0, #0
	bl	ftl_total_vpn_update
	mov	r4, r5
.L1767:
	ldr	r3, [r5]
	ldr	r2, [r3, #56]
	adds	r2, r2, #1
	str	r2, [r3, #56]
	ldrh	r2, [r3, #140]
	ldr	r3, .L1771+8
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1759
	bl	ftl_ext_alloc_new_blk
.L1759:
	ldr	r0, [r4]
	movw	r3, #65535
	ldrh	r1, [r0, #130]
	cmp	r1, r3
	bne	.L1760
	mov	r2, #1048
	ldr	r1, .L1771+12
	ldr	r0, .L1771+16
	bl	printf
.L1761:
	b	.L1761
.L1760:
	ldr	r3, .L1771+20
	movs	r7, #0
	ldr	fp, .L1771+32
	ldr	r10, .L1771+36
	ldrh	r3, [r3]
	rsb	r2, r3, #21
	movs	r3, #1
	asr	r6, r1, r2
	lsls	r3, r3, r2
	ldr	r2, .L1771+24
	subs	r3, r3, #1
	ands	r3, r3, r1
	movs	r1, #0
	ldrh	r8, [r2]
	ldrh	r2, [r0, #140]
	mov	r0, r10
	smlabb	r3, r8, r3, r2
	ldrb	r2, [fp]	@ zero_extendqisi2
	uxth	r8, r3
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r3, [r4]
	mov	r1, r8
	ldr	r2, .L1771+28
	uxtb	r0, r6
	str	r7, [r10]
	ldr	r3, [r3, #56]
	str	r3, [r10, #4]
	ldrb	r3, [fp]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r10
	bl	ftl_prog_page
	ldr	r2, [r4]
	ldrh	r3, [r2, #140]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #140]	@ movhi
	beq	.L1767
	adds	r0, r0, #1
	beq	.L1767
	mov	r0, r7
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1772:
	.align	2
.L1771:
	.word	.LANCHOR60
	.word	.LANCHOR46
	.word	.LANCHOR79
	.word	.LANCHOR134
	.word	.LC0
	.word	.LANCHOR71
	.word	.LANCHOR75
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR45
	.word	.LANCHOR130
	.size	ftl_ext_info_flush, .-ftl_ext_info_flush
	.section	.text.ftl_ext_info_init,"ax",%progbits
	.align	1
	.global	ftl_ext_info_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_ext_info_init, %function
ftl_ext_info_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #0
	ldr	r3, .L1790
	ldr	r5, .L1790+4
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1790+8
	ldr	r3, [r5]
	mov	r10, r5
	ldrh	r4, [r3, #130]
	ldr	r3, .L1790+12
	ubfx	r8, r4, #0, #14
	ldrh	r3, [r3]
	mov	r1, r8
	rsb	r3, r3, #21
	asrs	r4, r4, r3
	movs	r3, #4
	str	r3, [sp]
	uxtb	r4, r4
	ldr	r3, .L1790+16
	mov	r0, r4
	bl	flash_get_last_written_page
	ldr	r3, .L1790+20
	mov	r6, r0
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L1774
	mov	r3, r0
	movw	r2, #1091
	ldr	r1, .L1790+24
	ldr	r0, .L1790+28
	bl	printf
.L1774:
	ldr	fp, .L1790+48
	movs	r7, #0
.L1775:
	uxth	r5, r6
	subs	r3, r5, r7
	lsls	r3, r3, #16
	bmi	.L1780
	ldr	r3, .L1790+32
	subs	r1, r6, r7
	ldr	r2, .L1790+8
	ldrh	r0, [r3]
	ldr	r3, .L1790+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	mla	r1, r8, r0, r1
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, .L1790+16
	bl	flash_read_page_en
	adds	r2, r0, #1
	beq	.L1776
	cmp	r0, #512
	beq	.L1776
	ldr	r3, .L1790+40
	ldr	r3, [r3]
	ldr	r3, [r3]
	cmp	r3, fp
	bne	.L1776
.L1780:
	ldr	r3, [r10]
	ldrh	r2, [r3, #140]
	cmp	r2, r6
	bgt	.L1778
	adds	r5, r5, #1
	strh	r5, [r3, #140]	@ movhi
	bl	ftl_ext_info_flush
.L1778:
	ldr	r3, .L1790+40
	movs	r0, #0
	movw	r2, #65535
	ldr	r3, [r3]
	str	r0, [r3, #520]
	ldr	r3, .L1790+44
	strh	r2, [r3]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1776:
	adds	r7, r7, #1
	b	.L1775
.L1791:
	.align	2
.L1790:
	.word	.LANCHOR86
	.word	.LANCHOR46
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR71
	.word	.LANCHOR130
	.word	.LANCHOR22
	.word	.LANCHOR135
	.word	.LC28
	.word	.LANCHOR75
	.word	.LANCHOR45
	.word	.LANCHOR60
	.word	.LANCHOR87
	.word	1162432070
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_low_format,"ax",%progbits
	.align	1
	.global	ftl_low_format
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_low_format, %function
ftl_low_format:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #8
	ldr	r5, .L1829
	sub	sp, sp, #40
.L1796:
	ldr	r3, [r5]
	add	r3, r3, r4
	ldrb	r3, [r3, #32]	@ zero_extendqisi2
	cmp	r3, #128
	ble	.L1793
	cmp	r3, #255
	beq	.L1794
	movw	r2, #1228
	ldr	r1, .L1829+4
	ldr	r0, .L1829+8
	bl	printf
.L1795:
	b	.L1795
.L1793:
	ldr	r2, .L1829+12
	movs	r0, #0
	ldrh	r1, [r2]
	muls	r1, r3, r1
	bl	flash_erase_block
.L1794:
	adds	r4, r4, #1
	cmp	r4, #16
	bne	.L1796
	ldr	r4, .L1829+16
	mov	r10, #0
	bl	sblk_init
	bl	ftl_info_blk_init
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L1829+20
	bl	ftl_memset
	ldr	r3, [r4]
	ldr	r2, .L1829+24
	str	r2, [r3]
.L1797:
	ldr	r3, .L1829+28
	uxth	r0, r10
	ldr	r6, .L1829+32
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1804
	ldr	r7, .L1829+36
	mov	r2, #16384
	movs	r1, #0
	ldr	r0, .L1829+40
	bl	ftl_memset
	ldr	r3, [r7]
	ldr	r2, .L1829+44
	str	r2, [r3]
	ldr	r3, .L1829+48
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, .L1829
	mov	r1, r8
	ldr	r3, [r3]
	ldrb	r0, [r3, #47]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	ip, [r6]
	uxtb	r0, r0
	cmp	r8, #1
	str	r7, [sp, #8]
	add	r5, r0, #1
	mov	r3, #0
	ite	eq
	moveq	r0, #1
	movne	r0, #3
.L1805:
	add	r1, ip, r3, lsl #2
	adds	r3, r3, #1
	ldrb	r2, [r1, #2]	@ zero_extendqisi2
	strb	r0, [r1, #3]
	orn	r2, r2, #31
	bfc	r2, #3, #2
	strb	r2, [r1, #2]
	uxth	r2, r3
	cmp	r5, r2
	bhi	.L1805
	mov	r1, r8
	movs	r0, #16
	bl	__aeabi_idiv
	ldr	r3, [r4]
	add	r0, r0, r5
	uxth	r0, r0
	strh	r0, [r3, #134]	@ movhi
	ldr	r3, .L1829+52
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L1806
	str	r0, [sp]
	mov	r3, r5
	movs	r2, #128
	movw	r1, #1265
	ldr	r0, .L1829+56
	bl	printf
.L1806:
	ldr	r0, [r4]
	movs	r2, #128
	movs	r1, #255
	adds	r0, r0, #160
	bl	ftl_memset
	ldr	r3, [r6]
	ldr	r0, [r4]
	str	r3, [sp, #24]
	ldr	r3, .L1829+60
	ldrh	ip, [r0, #134]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L1829+48
	ldrb	fp, [r3]	@ zero_extendqisi2
	uxth	r3, fp
	str	r3, [sp, #16]
	ldrh	r3, [sp, #16]
	smulbb	r2, r5, r3
	ldr	r3, .L1829+64
	ldrh	r1, [r3]
	uxth	r2, r2
	str	r3, [sp, #36]
	rsb	r6, r1, #21
	movs	r1, #1
	lsls	r1, r1, r6
	movs	r6, #0
	uxth	r1, r1
	str	r1, [sp, #32]
.L1807:
	cmp	r5, ip
	bcc	.L1813
	ldr	r3, .L1829+28
	mov	r2, ip
	mov	lr, #1
	ldrh	r1, [r3]
	ldr	r3, [sp, #24]
	add	r3, r3, ip, lsl #2
.L1814:
	cmp	r2, r1
	bcc	.L1815
	sub	ip, r1, ip
	movs	r5, #0
	strh	ip, [r0, #116]	@ movhi
	strh	r6, [r0, #112]	@ movhi
	strh	r5, [r0, #114]	@ movhi
	strh	r5, [r0, #118]	@ movhi
	movs	r0, #1
	bl	ftl_alloc_sblk
	mov	r1, r5
	mov	r6, r0
	bl	ftl_erase_sblk
	ldr	r1, [r4]
	mov	r0, r6
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	ldr	r0, [r4]
	movw	r2, #65533
	ldrh	r8, [r0, #672]
	strh	r5, [r0, #690]	@ movhi
	add	r3, r8, #-1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L1816
	movw	r2, #1297
	ldr	r1, .L1829+4
	ldr	r0, .L1829+8
	bl	printf
.L1817:
	b	.L1817
.L1804:
	ldr	r3, .L1829+68
	strh	r0, [r3]	@ movhi
	bl	ftl_test_block
	ldr	r3, .L1829+60
	uxth	r1, r10
	ldr	r5, [r6]
	movs	r6, #0
	mov	fp, r6
	mov	r7, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r5, r5, r1, lsl #2
	str	r3, [sp, #8]
	ldr	r3, .L1829+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	uxth	r2, r3
	str	r2, [sp, #12]
	mul	r2, r3, r1
.L1798:
	ldr	r0, [sp, #8]
	uxth	r1, fp
	cmp	r0, r1
	bhi	.L1818
	cbnz	r7, .L1803
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, #224
	strb	r3, [r5, #2]
.L1803:
	add	r10, r10, #1
	b	.L1797
.L1801:
	add	r1, r8, r2
	ldr	r0, [sp, #16]
	str	r3, [sp, #24]
	str	r2, [sp, #20]
	bl	flash_check_bad_block
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #24]
	cbz	r0, .L1799
	ldrb	r0, [r5, #3]	@ zero_extendqisi2
	movs	r1, #1
	lsl	r1, r1, r8
	orrs	r1, r1, r0
	strb	r1, [r5, #3]
.L1800:
	add	r8, r8, #1
.L1802:
	sub	r1, r8, r6
	ldr	r0, [sp, #12]
	uxth	r1, r1
	cmp	r0, r1
	bhi	.L1801
	add	fp, fp, #1
	add	r6, r6, r3
	subs	r2, r2, r3
	b	.L1798
.L1799:
	adds	r7, r7, #1
	uxth	r7, r7
	b	.L1800
.L1818:
	uxtb	r1, fp
	mov	r8, r6
	str	r1, [sp, #16]
	b	.L1802
.L1813:
	ldr	r3, [sp, #24]
	add	r3, r3, r5, lsl #2
	str	r3, [sp, #12]
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	orn	r3, r3, #31
	bfc	r3, #3, #2
	strb	r3, [r1, #2]
	movs	r1, #0
	mov	r8, r1
	str	r1, [sp, #20]
.L1808:
	ldrh	r3, [sp, #20]
	ldr	r7, [sp, #28]
	cmp	r7, r3
	bhi	.L1820
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	uxth	r5, r5
	add	r2, r2, r3
	uxth	r2, r2
	b	.L1807
.L1811:
	ldr	r7, [sp, #12]
	ldrb	r10, [r7, #3]	@ zero_extendqisi2
	add	r7, lr, r8
	asr	r10, r10, r7
	tst	r10, #1
	bne	.L1809
	cmp	fp, #1
	add	r10, r6, #80
	it	hi
	andhi	r3, r3, #1
	add	r6, r6, #1
	it	hi
	addhi	r3, r3, r2
	uxth	r6, r6
	ite	hi
	uxthhi	r3, r3
	movls	r3, r2
	add	r3, r3, r1
	strh	r3, [r0, r10, lsl #1]	@ movhi
.L1809:
	add	lr, lr, #1
.L1812:
	ldr	r7, [sp, #16]
	uxth	r3, lr
	cmp	r3, r7
	bcc	.L1811
	ldr	r3, [sp, #20]
	add	r8, r8, fp
	adds	r3, r3, #1
	str	r3, [sp, #20]
	ldr	r3, [sp, #32]
	add	r1, r1, r3
	uxth	r1, r1
	b	.L1808
.L1820:
	mov	lr, #0
	b	.L1812
.L1815:
	ldrb	r5, [r3, #2]	@ zero_extendqisi2
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r3, #4
	and	r5, r5, #31
	bfi	r5, lr, #3, #2
	strb	r5, [r3, #-2]
	b	.L1814
.L1830:
	.align	2
.L1829:
	.word	.LANCHOR5
	.word	.LANCHOR136
	.word	.LC0
	.word	.LANCHOR75
	.word	.LANCHOR46
	.word	ftl_info_data_buffer
	.word	1229739078
	.word	.LANCHOR54
	.word	.LANCHOR57
	.word	.LANCHOR60
	.word	ftl_ext_info_data_buffer
	.word	1162432070
	.word	.LANCHOR70
	.word	.LANCHOR22
	.word	.LC67
	.word	.LANCHOR76
	.word	.LANCHOR71
	.word	.LANCHOR53
.L1816:
	strh	r5, [r0, #696]	@ movhi
	movs	r1, #255
	mov	r2, #256
	add	r0, r0, #416
	bl	ftl_memset
	ldr	r2, [sp, #36]
	ldr	r3, [r4]
	ldrh	r2, [r2]
	strh	r8, [r3, #692]	@ movhi
	strh	r6, [r3, #416]	@ movhi
	rsb	r2, r2, #21
	asr	r2, r8, r2
	strh	r2, [r3, #694]	@ movhi
	movs	r2, #1
	strh	r2, [r3, #688]	@ movhi
	ldr	r2, .L1831
	ldrh	r2, [r2]
	strh	r2, [r3, #698]	@ movhi
	bl	ftl_alloc_sys_blk
	mov	r1, r5
	mov	r6, r0
	bl	ftl_erase_phy_blk
	ldr	r3, [r4]
	movs	r1, #2
	strh	r6, [r3, #130]	@ movhi
	ldr	r3, [sp, #8]
	ldr	r0, [r3]
	adds	r0, r0, #16
	bl	ftl_open_sblk_init
	ldr	r3, [sp, #8]
	movs	r1, #3
	ldr	r0, [r3]
	adds	r0, r0, #48
	bl	ftl_open_sblk_init
	ldr	r3, [sp, #8]
	movs	r1, #255
	ldr	r0, [r3]
	ldr	r3, [r4]
	adds	r0, r0, #136
	ldrh	r2, [r3, #134]
	strh	r5, [r0, #-12]	@ movhi
	strh	r5, [r0, #-16]	@ movhi
	strh	r2, [r0, #-10]	@ movhi
	movw	r2, #65535
	strh	r2, [r0, #-56]	@ movhi
	strh	r2, [r0, #-6]	@ movhi
	mov	r2, #-1
	strh	r5, [r0, #-14]	@ movhi
	str	r2, [r0, #408]
	strh	r2, [r3, #126]	@ movhi
	mov	r2, #256
	bl	ftl_memset
	ldr	r3, [sp, #8]
	movs	r2, #128
	movs	r1, #255
	ldr	r0, [r3]
	add	r0, r0, #392
	bl	ftl_memset
	bl	ftl_ext_info_flush
	mov	r0, r5
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	mov	r0, r5
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1832:
	.align	2
.L1831:
	.word	.LANCHOR137
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format_test,"ax",%progbits
	.align	1
	.global	ftl_re_low_format_test
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_re_low_format_test, %function
ftl_re_low_format_test:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r1, #1
	ldr	r5, .L1841
	ldr	r0, .L1841+4
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	r2, .L1841+8
	ldr	r3, [r5]
	ldr	r6, .L1841+12
	ldr	r0, [r2]
	movs	r2, #0
	ldrh	r1, [r3, #134]
	mov	r7, r2
	ldrh	lr, [r6]
	mov	ip, r2
	add	r0, r0, r1, lsl #2
.L1834:
	cmp	r1, lr
	bcc	.L1838
	movs	r4, #0
	strh	r7, [r3, #118]	@ movhi
	strh	r2, [r3, #116]	@ movhi
	movs	r0, #1
	strh	ip, [r3, #114]	@ movhi
	strh	r4, [r3, #122]	@ movhi
	strh	r4, [r3, #120]	@ movhi
	strh	r4, [r3, #124]	@ movhi
	bl	ftl_alloc_sblk
	mov	r1, r4
	mov	r8, r0
	bl	ftl_erase_sblk
	ldr	r1, [r5]
	mov	r0, r8
	add	r1, r1, #672
	bl	ftl_get_blk_list_in_sblk
	ldr	r0, [r5]
	movw	r2, #65533
	ldrh	r7, [r0, #672]
	strh	r4, [r0, #690]	@ movhi
	subs	r3, r7, #1
	uxth	r3, r3
	cmp	r3, r2
	bls	.L1839
	movw	r2, #1366
	ldr	r1, .L1841+16
	ldr	r0, .L1841+20
	bl	printf
.L1840:
	b	.L1840
.L1838:
	ldrb	r4, [r0, #2]	@ zero_extendqisi2
	bfc	r4, #5, #3
	strb	r4, [r0, #2]
	ands	r4, r4, #24
	bne	.L1835
	add	ip, ip, #1
	uxth	ip, ip
.L1836:
	adds	r1, r1, #1
	uxth	r1, r1
	adds	r0, r0, #4
	b	.L1834
.L1835:
	cmp	r4, #16
	itete	eq
	addeq	r7, r7, #1
	addne	r2, r2, #1
	uxtheq	r7, r7
	uxthne	r2, r2
	b	.L1836
.L1839:
	strh	r4, [r0, #696]	@ movhi
	mov	r2, #256
	movs	r1, #255
	add	r0, r0, #416
	bl	ftl_memset
	ldr	r0, [r5]
	mov	r1, r4
	mov	r2, #4096
	add	r0, r0, #704
	bl	ftl_memset
	ldr	r3, [r5]
	lsrs	r2, r7, #14
	ubfx	r7, r7, #0, #14
	mov	r1, r4
	strh	r2, [r3, #694]	@ movhi
	movs	r2, #1
	strh	r2, [r3, #688]	@ movhi
	ldr	r2, .L1841+24
	strh	r7, [r3, #692]	@ movhi
	strh	r8, [r3, #416]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #698]	@ movhi
	ldrh	r2, [r6]
	ldr	r3, .L1841+28
	ldr	r6, .L1841+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r0, [r6]
	movs	r1, #2
	adds	r0, r0, #16
	bl	ftl_open_sblk_init
	ldr	r0, [r6]
	movs	r1, #3
	adds	r0, r0, #48
	bl	ftl_open_sblk_init
	ldr	r3, [r5]
	movs	r1, #255
	ldr	r0, [r6]
	ldrh	r2, [r3, #134]
	adds	r0, r0, #136
	strh	r4, [r0, #-12]	@ movhi
	strh	r4, [r0, #-16]	@ movhi
	strh	r2, [r0, #-10]	@ movhi
	movw	r2, #65535
	strh	r2, [r0, #-56]	@ movhi
	strh	r2, [r0, #-6]	@ movhi
	mov	r2, #-1
	strh	r4, [r0, #-14]	@ movhi
	str	r2, [r0, #408]
	strh	r2, [r3, #126]	@ movhi
	mov	r2, #256
	bl	ftl_memset
	ldr	r0, [r6]
	movs	r2, #128
	movs	r1, #255
	add	r0, r0, #392
	bl	ftl_memset
	ldr	r3, [r6]
	str	r4, [r3, #520]
	str	r4, [r3, #524]
	str	r4, [r3, #528]
	bl	ftl_ext_info_flush
	mov	r0, r4
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L1842:
	.align	2
.L1841:
	.word	.LANCHOR46
	.word	.LC68
	.word	.LANCHOR57
	.word	.LANCHOR54
	.word	.LANCHOR138
	.word	.LC0
	.word	.LANCHOR137
	.word	.LANCHOR56
	.word	.LANCHOR60
	.size	ftl_re_low_format_test, .-ftl_re_low_format_test
	.section	.text.ftl_prog_ppa_page,"ax",%progbits
	.align	1
	.global	ftl_prog_ppa_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_prog_ppa_page, %function
ftl_prog_ppa_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, lr}
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r1
	ubfx	r1, r0, #0, #21
	ubfx	r0, r0, #21, #3
	bl	ftl_prog_page
	add	sp, sp, #12
	@ sp needed
	ldr	pc, [sp], #4
	.size	ftl_prog_ppa_page, .-ftl_prog_ppa_page
	.section	.text.ftl_write_last_log_page,"ax",%progbits
	.align	1
	.global	ftl_write_last_log_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_last_log_page, %function
ftl_write_last_log_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r3, [r0, #6]
	cmp	r3, #1
	bne	.L1846
	ldr	r3, .L1848
	ldrh	r7, [r0, #12]
	ldr	r4, [r3]
	bl	ftl_get_new_free_page
	adds	r3, r0, #1
	mov	r6, r0
	beq	.L1847
	ldrh	r0, [r5]
	add	r4, r4, r7, lsl #2
	ldr	r5, .L1848+4
	bl	ftl_vpn_decrement
	ldr	r3, .L1848+8
	mov	r0, r4
	ldr	r2, .L1848+12
	str	r3, [r5]
	ldr	r3, .L1848+16
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r1, r3, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r3, .L1848+20
	mov	r2, r5
	str	r0, [r5, #4]
	mov	r1, r4
	mov	r0, r6
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_prog_ppa_page
.L1847:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L1846:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L1849:
	.align	2
.L1848:
	.word	.LANCHOR82
	.word	.LANCHOR121
	.word	-178307901
	.word	.LANCHOR69
	.word	.LANCHOR79
	.word	.LANCHOR45
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",%progbits
	.align	1
	.global	ftl_open_sblk_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1922
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	mov	r4, r0
	str	r1, [sp, #52]
	mov	r10, r3
	ldr	r2, [r3]
	tst	r2, #4096
	beq	.L1851
	ldrh	r1, [r0, #2]
	ldr	r0, .L1922+4
	bl	printf
.L1851:
	ldr	r3, [r10]
	lsls	r0, r3, #19
	bpl	.L1852
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldr	r0, .L1922+8
	bl	printf
.L1852:
	ldr	r3, [r10]
	lsls	r1, r3, #19
	bpl	.L1853
	ldrh	r1, [r4]
	ldr	r0, .L1922+12
	bl	printf
.L1853:
	ldr	r3, [r10]
	lsls	r2, r3, #19
	bpl	.L1854
	ldrh	r2, [r4, #18]
	ldrh	r1, [r4, #16]
	ldr	r0, .L1922+16
	bl	printf
.L1854:
	ldrh	r3, [r4, #10]
	movs	r0, #1
	strh	r3, [r4, #14]	@ movhi
	bl	buf_alloc
	ldrh	r3, [r4, #2]
	mov	r5, r0
	ldrb	fp, [r4, #5]	@ zero_extendqisi2
	str	r3, [sp, #44]
	movs	r3, #0
	str	r3, [sp, #48]
.L1855:
	ldr	r3, .L1922+20
	ldr	r2, [sp, #44]
	ldrh	r3, [r3]
	cmp	r3, r2
	bhi	.L1870
.L1858:
	ldrh	r3, [sp, #44]
	movs	r7, #0
	ldr	r6, .L1922+24
	mov	r2, r7
	ldrh	r0, [r4, #10]
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, [r6]
	strb	fp, [r4, #5]
.L1871:
	cmp	r2, r0
	bcc	.L1873
	ldr	r2, .L1922+20
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	ldr	r8, .L1922+72
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	subs	r3, r3, r0
	add	r7, r7, r3
	ldr	r3, [r10]
	uxth	r7, r7
	tst	r3, #4096
	beq	.L1874
	ldrh	r1, [r4]
	mov	r2, r7
	ldr	r3, [r8]
	ldr	r0, .L1922+28
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L1874:
	ldrh	r2, [r4]
	mov	r0, r5
	ldr	r3, [r8]
	ldr	fp, .L1922+76
	strh	r7, [r3, r2, lsl #1]	@ movhi
	movs	r7, #0
	bl	buf_free
.L1875:
	ldr	r3, .L1922+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r7, r3, lsl #1
	bcc	.L1878
	ldr	r3, .L1922+20
	ldrh	r2, [r4, #12]
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r3, [r3]
	mla	r3, r1, r3, r2
	ldr	r2, [r6]
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r2, r3, lsl #2]
	adds	r3, r3, #1
	beq	.L1879
	movw	r2, #811
	ldr	r1, .L1922+36
	ldr	r0, .L1922+40
	bl	printf
.L1880:
	b	.L1880
.L1870:
	ldrb	fp, [r4, #5]	@ zero_extendqisi2
.L1856:
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	cmp	r3, fp
	bhi	.L1869
	movs	r3, #0
	strb	r3, [r4, #5]
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #44]
	b	.L1855
.L1869:
	add	r3, fp, #8
	ldrh	r8, [r4, r3, lsl #1]
	movw	r3, #65535
	cmp	r8, r3
	beq	.L1857
	ldr	r3, .L1922+44
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	ldrh	r6, [r3]
	ldr	r3, [sp, #44]
	mla	r6, r8, r6, r3
	ldr	r3, .L1922+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r6
	bl	ftl_read_ppa_page
	cmp	r0, #512
	mov	r7, r0
	beq	.L1858
	ldr	r3, [r10]
	lsls	r3, r3, #19
	bpl	.L1859
	ldr	r2, [r5, #12]
	ldr	r3, [r5, #4]
	ldr	r1, [r2, #12]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	mov	r1, r8
	ldr	r2, [r2]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	ldr	r3, [r3]
	ldr	r2, [sp, #44]
	str	r0, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	ldr	r0, .L1922+52
	bl	printf
.L1859:
	ldr	r3, .L1922+56
	mov	r8, #1
	ldr	r2, [sp, #44]
	ldrh	r1, [r4, #10]
	strb	r8, [r3]
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mla	r2, r3, r2, fp
	cmp	r1, r2
	beq	.L1860
	movw	r2, #707
	ldr	r1, .L1922+36
	ldr	r0, .L1922+40
	bl	printf
.L1861:
	b	.L1861
.L1860:
	ldrh	r2, [r4, #6]
	add	r2, r2, r1
	ldr	r1, .L1922+20
	ldrh	r1, [r1]
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L1862
	mov	r2, #708
	ldr	r1, .L1922+36
	ldr	r0, .L1922+40
	bl	printf
.L1863:
	b	.L1863
.L1862:
	adds	r7, r7, #1
	beq	.L1865
	ldr	r7, [r5, #12]
	ldr	r0, [r7, #4]
	adds	r6, r0, #1
	beq	.L1865
	bl	lpa_hash_get_ppa
	ldr	r3, [sp, #52]
	mov	r6, r0
	cmp	r3, #0
	beq	.L1867
	ldr	r3, [r7, #8]
	cmp	r0, r3
	beq	.L1867
	adds	r1, r0, #1
	beq	.L1867
	ldr	r3, .L1922+60
	ldrh	r0, [r3]
	rsb	r3, r0, #21
	lsl	r8, r8, r3
	ldr	r3, .L1922+64
	lsr	r0, r6, r0
	add	r8, r8, #-1
	ldrb	r1, [r3]	@ zero_extendqisi2
	and	r0, r8, r0
	bl	__aeabi_uidiv
	ldr	r3, [sp, #52]
	uxth	r0, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1867
	ldr	r8, [r7]
	mov	r0, r6
	ldr	r7, .L1922+68
	ldr	r3, .L1922+48
	ldr	r1, [r5, #4]
	mov	r2, r7
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r3, [r7]
	cmp	r8, r3
	bhi	.L1867
	ldr	r3, [r5, #12]
	ldr	r0, [r3, #8]
	adds	r2, r0, #1
	beq	.L1865
	ldr	r3, .L1922+60
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r1, r2, #21
	lsls	r3, r3, r1
	lsrs	r0, r0, r2
	ldr	r2, .L1922+64
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L1865:
	ldrh	r3, [r4, #6]
	subs	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #10]
	adds	r3, r3, #1
	strh	r3, [r4, #10]	@ movhi
	movs	r3, #1
	str	r3, [sp, #48]
.L1857:
	add	fp, fp, #1
	uxth	fp, fp
	b	.L1856
.L1873:
	ldrh	r1, [r4, #12]
	add	r1, r1, r2
	adds	r2, r2, #1
	ldr	r1, [r3, r1, lsl #2]
	adds	r1, r1, #1
	itt	ne
	addne	r7, r7, #1
	uxthne	r7, r7
	b	.L1871
.L1923:
	.align	2
.L1922:
	.word	.LANCHOR22
	.word	.LC69
	.word	.LC70
	.word	.LC71
	.word	.LC72
	.word	.LANCHOR79
	.word	.LANCHOR82
	.word	.LC74
	.word	.LANCHOR69
	.word	.LANCHOR139
	.word	.LC0
	.word	.LANCHOR75
	.word	.LANCHOR45
	.word	.LC73
	.word	.LANCHOR133
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR130
	.word	.LANCHOR56
	.word	.LANCHOR46
.L1878:
	ldr	r3, [sp, #48]
	cbz	r3, .L1876
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bls	.L1876
	mov	r0, r4
	bl	ftl_get_new_free_page
	ldr	r3, [r10]
	mov	r8, r0
	lsls	r3, r3, #19
	bpl	.L1877
	mov	r1, r0
	ldr	r0, .L1924
	bl	printf
.L1877:
	ldr	r3, [fp]
	mov	r0, r8
	ldr	r2, [r5, #12]
	ldr	r1, [r5, #4]
	ldr	r3, [r3, #8]
	str	r3, [r2]
	mov	r3, #-1
	str	r3, [r2, #4]
	str	r3, [r2, #8]
	movs	r3, #0
	str	r3, [r2, #12]
	str	r3, [r1]
	ldr	r3, .L1924+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_prog_ppa_page
	ldrh	r0, [r4]
	bl	ftl_vpn_decrement
.L1876:
	adds	r7, r7, #1
	b	.L1875
.L1879:
	ldrh	r3, [r4, #6]
	cmp	r3, #1
	bne	.L1850
	mov	r0, r4
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	ftl_write_last_log_page
.L1867:
	ldr	r0, [r5, #12]
	ldr	r3, .L1924+8
	ldr	r2, [r0, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	bcs	.L1865
	ldr	r3, .L1924+12
	ldrb	r1, [r4, #9]	@ zero_extendqisi2
	ldrh	r2, [r4, #10]
	ldrh	r3, [r3]
	muls	r3, r1, r3
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L1865
	ldr	r3, .L1924+16
	ldr	r6, [r0]
	ldr	r3, [r3]
	ldr	r1, [r3, #8]
	cmp	r6, r1
	it	hi
	strhi	r6, [r3, #8]
	ldrh	r3, [r4, #12]
	ldr	r1, [r0, #8]
	ldr	r0, [r0, #4]
	add	r2, r2, r3
	uxth	r2, r2
	bl	lpa_hash_update_ppa
	b	.L1865
.L1850:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1925:
	.align	2
.L1924:
	.word	.LC75
	.word	.LANCHOR45
	.word	.LANCHOR47
	.word	.LANCHOR79
	.word	.LANCHOR46
	.size	ftl_open_sblk_recovery, .-ftl_open_sblk_recovery
	.section	.text.pm_write_page,"ax",%progbits
	.align	1
	.global	pm_write_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_write_page, %function
pm_write_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r7, .L1937
	mov	r8, r1
	mov	r6, r7
.L1932:
	ldr	r3, [r7]
	ldr	r2, [r3, #48]
	ldrh	r1, [r3, #696]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	ldr	r2, .L1937+4
	ldrh	r2, [r2]
	cmp	r1, r2
	bcs	.L1928
	ldrh	r2, [r3, #692]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1929
.L1928:
	bl	pm_alloc_new_blk
	movs	r0, #0
	bl	ftl_info_flush
.L1929:
	ldr	r2, [r6]
	movw	r1, #65535
	ldrh	r3, [r2, #692]
	cmp	r3, r1
	bne	.L1930
	movs	r2, #224
	ldr	r1, .L1937+8
	ldr	r0, .L1937+12
	bl	printf
.L1931:
	b	.L1931
.L1930:
	ldr	r1, .L1937+16
	ldrh	r2, [r2, #696]
	ldr	r10, .L1937+28
	ldrh	r5, [r1]
	movs	r1, #0
	ldr	r0, [r10]
	mla	r5, r3, r5, r2
	movs	r2, #64
	bl	ftl_memset
	ldr	r2, [r6]
	ldr	r3, [r10]
	ldrb	r0, [r2, #694]	@ zero_extendqisi2
	str	r4, [r3]
	ldr	r1, [r2, #48]
	ldr	r2, .L1937+20
	str	r1, [r3, #4]
	mov	r1, r5
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp]
	mov	r2, r8
	bl	ftl_prog_page
	ldr	r2, [r6]
	ldrh	r3, [r2, #696]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #1
	strh	r3, [r2, #696]	@ movhi
	beq	.L1932
	adds	r0, r0, #1
	bne	.L1933
.L1927:
	mov	r1, r5
	ldr	r0, .L1937+24
	bl	printf
	b	.L1932
.L1933:
	ldrh	r3, [r2, #698]
	movs	r0, #0
	cmp	r4, r3
	itt	cc
	addcc	r4, r4, #176
	strcc	r5, [r2, r4, lsl #2]
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1938:
	.align	2
.L1937:
	.word	.LANCHOR46
	.word	.LANCHOR79
	.word	.LANCHOR140
	.word	.LC0
	.word	.LANCHOR75
	.word	.LANCHOR45
	.word	.LC76
	.word	.LANCHOR141
	.size	pm_write_page, .-pm_write_page
	.section	.text.flash_info_flush,"ax",%progbits
	.align	1
	.global	flash_info_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_info_flush, %function
flash_info_flush:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #64
	ldr	r5, .L1947
	movs	r1, #0
	movs	r7, #0
	ldr	r6, .L1947+4
	ldr	r0, [r5]
	bl	ftl_memset
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L1947+8
	bl	rknand_print_hex
	ldr	r4, [r6]
	ldr	r1, [r4, #8]
	add	r0, r4, #16
	bl	js_hash
	str	r5, [sp, #8]
	ldr	r5, .L1947+12
	str	r0, [r4, #12]
	mov	r8, r5
.L1940:
	ldr	fp, .L1947+32
	ldrb	r10, [r5]	@ zero_extendqisi2
	ldrh	r4, [r5, #2]
	ldrh	r3, [fp]
	mov	r1, r10
	ldr	r0, .L1947+16
	mov	r2, r4
	str	r3, [sp, #12]
	bl	printf
	ldr	r2, .L1947+20
	ldrh	r0, [r5, #2]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r0, r2
	blt	.L1941
	ldr	r4, [r6]
	mov	r10, #0
	ldrb	r2, [r5]	@ zero_extendqisi2
	strh	r10, [r5, #2]	@ movhi
	ldr	r3, [r4, #4]
	mov	r0, r4
	ldr	r1, [r4, #8]
	adds	r3, r3, #1
	str	r3, [r4, #4]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	strb	r2, [r5, #1]
	ldrh	r2, [r4, #16]
	strb	r3, [r5]
	str	r3, [sp, #12]
	adds	r2, r2, #1
	strh	r2, [r0, #16]!	@ movhi
	bl	js_hash
	ldr	r3, [sp, #12]
	str	r0, [r4, #12]
	mov	r0, r10
	ldrh	r4, [fp]
	muls	r4, r3, r4
	mov	r1, r4
.L1946:
	bl	flash_erase_block
.L1942:
	ldr	r2, [r6]
	mov	r10, #1
	ldr	r3, [sp, #8]
	movs	r0, #0
	ldr	r1, [r2, #4]
	ldr	r3, [r3]
	str	r1, [r3]
	ldr	r1, .L1947+24
	str	r1, [r3, #4]
	movs	r1, #4
	stm	sp, {r1, r10}
	mov	r1, r4
	bl	flash_prog_page_en
	ldrh	r3, [r8, #2]
	adds	r0, r0, #1
	add	r3, r3, r10
	strh	r3, [r8, #2]	@ movhi
	bne	.L1943
	mov	r1, r4
	ldr	r0, .L1947+28
	bl	printf
	b	.L1940
.L1945:
	mov	r7, r10
	b	.L1940
.L1941:
	mla	r4, r10, r3, r4
	cmp	r0, #0
	bne	.L1942
	mov	r1, r4
	b	.L1946
.L1943:
	cmp	r7, #0
	beq	.L1945
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1948:
	.align	2
.L1947:
	.word	.LANCHOR116
	.word	.LANCHOR5
	.word	.LC77
	.word	.LANCHOR117
	.word	.LC78
	.word	.LANCHOR97
	.word	1398362953
	.word	.LC79
	.word	.LANCHOR13
	.size	flash_info_flush, .-flash_info_flush
	.section	.text.nand_flash_init,"ax",%progbits
	.align	1
	.global	nand_flash_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	nand_flash_init, %function
nand_flash_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r8, .L2005+140
	movs	r2, #2
	ldr	r3, .L2005
	ldr	r7, .L2005+4
	mov	r6, r8
	ldr	r4, .L2005+8
	strb	r2, [r3]
	bl	nandc_init
	str	r4, [r7]
.L1955:
	lsl	r10, r5, #3
	uxtb	r0, r5
	add	r1, r8, r10
	bl	flash_read_id
	cbnz	r5, .L1950
	ldrb	r3, [r8]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bls	.L1951
.L1953:
	mvn	r0, #1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1951:
	ldrb	r3, [r8, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1953
.L1950:
	ldrb	r3, [r6, r10]	@ zero_extendqisi2
	adds	r5, r5, #1
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r6, r10]
	cmp	r5, #4
	bne	.L1955
	ldr	r5, .L2005+12
	mov	r8, #0
	ldr	r10, .L2005+140
.L1958:
	ldrb	r2, [r5, #-1]	@ zero_extendqisi2
	mov	r1, r10
	mov	r0, r5
	lsl	fp, r8, #5
	bl	flash_mem_cmp8
	cmp	r0, #0
	bne	.L1956
	ldr	r5, .L2005+16
	ldr	r3, .L2005+20
	add	r5, r5, fp
	ldrb	r2, [r5, #22]	@ zero_extendqisi2
	mov	r1, r3
.L1957:
	lsl	ip, r0, #5
	ldrb	ip, [ip, r3]	@ zero_extendqisi2
	cmp	ip, r2
	beq	.L1959
	adds	r0, r0, #1
	cmp	r0, #4
	bne	.L1957
.L1959:
	add	r1, r1, r0, lsl #5
	movs	r2, #32
	ldr	r0, .L2005+24
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L2005+8
	bl	ftl_memcpy
	ldr	r2, .L2005+28
	ldrb	r3, [r2]	@ zero_extendqisi2
	mov	r8, r2
	cmp	r3, #8
	bhi	.L1960
	ldrb	r2, [r4, #20]	@ zero_extendqisi2
	cmp	r2, #60
	bls	.L1961
	movs	r2, #60
	strb	r2, [r4, #20]
.L1961:
	cmp	r3, #8
	bne	.L1960
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1960
	ldrb	r3, [r4, #28]	@ zero_extendqisi2
	cmp	r3, #2
	itt	eq
	moveq	r3, #0
	strbeq	r3, [r4, #28]
.L1960:
	mov	r0, #16384
	ldr	r6, .L2005+32
	bl	ftl_malloc
	ldr	r3, .L2005+36
	mov	r10, #0
	str	r0, [r3]
	mov	r0, #16384
	bl	ftl_malloc
	ldr	r3, .L2005+40
	str	r0, [r3]
	mov	r0, #2048
	bl	ftl_malloc
	str	r0, [r6]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L2005+44
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L2005+48
	str	r0, [r3]
	movs	r0, #64
	bl	ftl_malloc
	ldr	r3, .L2005+52
	str	r0, [r3]
	ldr	r3, .L2005+56
	strb	r10, [r3]
	bl	flash_die_info_init
	ldrb	r0, [r4, #18]	@ zero_extendqisi2
	bl	flash_lsb_page_tbl_build
	ldrb	r0, [r4, #20]	@ zero_extendqisi2
	bl	nandc_bch_sel
	ldr	r2, [r7]
	ldr	r7, .L2005+60
	ldrh	r3, [r2, #16]
	ubfx	r5, r3, #3, #1
	lsrs	r1, r3, #8
	and	r0, r1, #7
	strb	r0, [r7]
	ldr	r0, .L2005+64
	strb	r5, [r0]
	ubfx	r5, r3, #4, #1
	ldr	r0, .L2005+68
	strb	r5, [r0]
	ubfx	r5, r3, #12, #1
	ldr	r0, .L2005+72
	strb	r5, [r0]
	ubfx	r5, r3, #13, #1
	ldr	r0, .L2005+76
	ubfx	r3, r3, #14, #1
	strb	r5, [r0]
	ldr	r0, .L2005+80
	ldr	r5, .L2005+84
	strb	r3, [r0]
	movs	r0, #60
	ldrb	r3, [r2, #28]	@ zero_extendqisi2
	ldr	r2, .L2005+88
	str	r10, [r5]
	strb	r3, [r2]
	ldr	r2, .L2005+92
	strb	r0, [r2]
	ldrb	r0, [r8]	@ zero_extendqisi2
	cmp	r0, #9
	itt	eq
	moveq	r0, #70
	strbeq	r0, [r2]
	ldr	r2, .L2005+96
	ldrh	r0, [r4, #16]
	strb	r3, [r2]
	ldrb	r3, [r4, #19]	@ zero_extendqisi2
	tst	r0, #64
	ldr	r2, .L2005+100
	strb	r3, [r2]
	mov	r4, r2
	beq	.L1964
	sub	r2, r3, #17
	cmp	r2, #2
	bhi	.L1965
	ldr	r2, .L2005+104
	cmp	r3, #19
	ldr	r3, .L2005+108
	str	r2, [r5]
	ite	ne
	movne	r2, #7
	moveq	r2, #15
.L2003:
	strb	r2, [r3]
.L1964:
	ldr	r3, .L2005+112
	tst	r1, #1
	mov	r2, #0
	mov	r0, #4
	strb	r2, [r3]
	mov	r8, r3
	beq	.L1975
	bl	nandc_set_if_mode
	movs	r0, #1
	bl	flash_set_interface_mode
	movs	r0, #1
.L1975:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	adds	r2, r0, #1
	beq	.L1949
	ldrb	r3, [r4]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	itt	ls
	ldrls	r3, .L2005+116
	strls	r3, [r5]
	ldrb	r3, [r7]	@ zero_extendqisi2
	lsls	r3, r3, #29
	bmi	.L1978
.L1979:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1956:
	add	r8, r8, #1
	adds	r5, r5, #32
	cmp	r8, #24
	bne	.L1958
	b	.L1953
.L1965:
	cmp	r3, #33
	beq	.L1968
	sub	r2, r3, #65
	cmp	r2, #1
	bhi	.L1969
.L1968:
	ldr	r3, .L2005+120
	movs	r2, #4
	str	r3, [r5]
	ldr	r3, .L2005+124
	strb	r2, [r3]
.L2004:
	movs	r2, #7
	ldr	r3, .L2005+108
	b	.L2003
.L1969:
	sub	r2, r3, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L1970
	sub	r0, r3, #34
	cmp	r0, #1
	bhi	.L1971
.L1970:
	ldr	r0, .L2005+120
	cmp	r3, #35
	str	r0, [r5]
	ldr	r0, .L2005+108
	beq	.L1972
	cmp	r3, #68
	beq	.L1972
	movs	r3, #7
.L2002:
	cmp	r2, #1
	strb	r3, [r0]
	it	ls
	movls	r2, #4
	ldr	r3, .L2005+124
	it	hi
	movhi	r2, #5
	b	.L2003
.L1972:
	movs	r3, #17
	b	.L2002
.L1971:
	subs	r3, r3, #36
	cmp	r3, #1
	bhi	.L1964
	ldr	r3, .L2005+128
	str	r3, [r5]
	b	.L2004
.L1978:
	ldr	r3, [r6]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1979
	ldr	r2, .L2005+132
	movs	r0, #0
	ldr	r3, .L2005+136
	ldrh	r1, [r2]
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r1, r3, r1
	bl	flash_ddr_para_scan
	ldrb	r4, [r8]	@ zero_extendqisi2
	cmp	r4, #0
	bne	.L1979
	ldr	r3, [r6]
	strb	r4, [r3, #19]
	bl	flash_info_flush
	b	.L1979
.L1949:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2006:
	.align	2
.L2005:
	.word	.LANCHOR20
	.word	.LANCHOR34
	.word	.LANCHOR19
	.word	.LANCHOR142+1
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR103
	.word	.LANCHOR7
	.word	.LANCHOR5
	.word	.LANCHOR119
	.word	.LANCHOR111
	.word	.LANCHOR118
	.word	.LANCHOR112
	.word	.LANCHOR116
	.word	.LANCHOR123
	.word	.LANCHOR25
	.word	.LANCHOR144
	.word	.LANCHOR23
	.word	.LANCHOR66
	.word	.LANCHOR74
	.word	.LANCHOR12
	.word	.LANCHOR115
	.word	.LANCHOR11
	.word	.LANCHOR145
	.word	.LANCHOR146
	.word	.LANCHOR1
	.word	micron_read_retrial
	.word	.LANCHOR113
	.word	.LANCHOR35
	.word	hynix_read_retrial
	.word	toshiba_read_retrial
	.word	.LANCHOR4
	.word	toshiba_3d_read_retrial
	.word	.LANCHOR13
	.word	.LANCHOR117
	.word	.LANCHOR26
	.size	nand_flash_init, .-nand_flash_init
	.section	.text.ftl_sysblk_dump,"ax",%progbits
	.align	1
	.global	ftl_sysblk_dump
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sysblk_dump, %function
ftl_sysblk_dump:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r0
	sub	sp, sp, #48
	movs	r0, #1
	movs	r6, #0
	bl	buf_alloc
	ldr	r3, [r0, #4]
	mov	r4, r0
	mov	r5, r6
	str	r3, [sp, #44]
.L2008:
	ldr	r3, .L2015
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2010
	mov	r0, r4
	bl	buf_free
	cmp	r5, #0
	beq	.L2011
	movw	r2, #655
	ldr	r1, .L2015+4
	ldr	r0, .L2015+8
	bl	printf
.L2012:
	b	.L2012
.L2010:
	ldr	r3, .L2015+12
	uxth	r7, r6
	ldr	r2, [r4, #12]
	ldr	r1, [r4, #4]
	ldrh	r8, [r3]
	ldr	r3, .L2015+16
	mla	r8, fp, r8, r7
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r8
	bl	ftl_read_ppa_page
	ldr	r2, [r4, #12]
	mov	r10, r0
	ldr	r3, [r4, #4]
	ldr	r1, [r2, #12]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	mov	r1, fp
	ldr	r2, [r2]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	mov	r2, r7
	ldr	r3, [r3]
	str	r0, [sp]
	ldr	r0, .L2015+20
	str	r3, [sp, #4]
	mov	r3, r8
	bl	printf
	ldr	r1, [sp, #44]
	movs	r3, #32
	movs	r2, #4
	ldr	r0, .L2015+24
	add	r1, r1, #704
	bl	rknand_print_hex
	cmp	r10, #-1
	beq	.L2013
	cmp	r10, #512
	it	eq
	moveq	r5, #1
.L2009:
	adds	r6, r6, #1
	b	.L2008
.L2013:
	movs	r5, #1
	b	.L2009
.L2011:
	mov	r0, r5
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2016:
	.align	2
.L2015:
	.word	.LANCHOR79
	.word	.LANCHOR147
	.word	.LC0
	.word	.LANCHOR75
	.word	.LANCHOR45
	.word	.LC73
	.word	.LC80
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",%progbits
	.align	1
	.global	dump_ftl_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_ftl_info, %function
dump_ftl_info:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	ldr	r1, .L2018
	ldr	r5, .L2018+4
	ldrh	r3, [r1, #2]
	ldrb	r2, [r1, #1]	@ zero_extendqisi2
	ldr	r0, .L2018+8
	ldrb	r1, [r1]	@ zero_extendqisi2
	bl	printf
	ldr	r3, [r5]
	ldr	r4, .L2018+12
	ldr	r0, .L2018+16
	ldrh	r2, [r3, #140]
	ldrh	r1, [r3, #130]
	bl	printf
	ldr	r0, [r4]
	ldr	r7, .L2018+20
	ldrh	r6, [r0, #26]
	ldrb	r3, [r0, #21]	@ zero_extendqisi2
	ldrh	r2, [r0, #18]
	ldrh	r1, [r0, #16]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #22]
	str	r0, [sp]
	ldr	r0, .L2018+24
	bl	printf
	ldr	r0, [r4]
	ldrh	r6, [r0, #58]
	ldrb	r3, [r0, #53]	@ zero_extendqisi2
	ldrh	r2, [r0, #50]
	ldrh	r1, [r0, #48]
	str	r6, [sp, #4]
	ldrh	r0, [r0, #54]
	ldr	r6, .L2018+28
	str	r0, [sp]
	ldr	r0, .L2018+32
	bl	printf
	ldr	r0, [r4]
	ldrh	r4, [r0, #90]
	ldrb	r3, [r0, #85]	@ zero_extendqisi2
	ldrh	r2, [r0, #82]
	ldrh	r1, [r0, #80]
	str	r4, [sp, #4]
	ldrh	r0, [r0, #86]
	ldr	r4, .L2018+36
	str	r0, [sp]
	ldr	r0, .L2018+40
	bl	printf
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L2018+44
	ldr	r0, .L2018+48
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #4
	lsls	r3, r3, #1
	bl	rknand_print_hex
	ldr	r1, .L2018+52
	movs	r2, #2
	ldrh	r3, [r7]
	ldr	r0, .L2018+56
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, [r5]
	movs	r3, #32
	movs	r2, #4
	ldr	r0, .L2018+60
	add	r1, r1, #704
	bl	rknand_print_hex
	ldr	r1, .L2018+64
	movs	r2, #4
	ldrh	r3, [r7]
	ldr	r0, .L2018+68
	ldr	r1, [r1]
	bl	rknand_print_hex
	mov	r3, #256
	movs	r2, #2
	ldr	r1, .L2018+72
	ldr	r0, .L2018+76
	bl	rknand_print_hex
	ldrh	r2, [r6]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r1, .L2018+80
	ldr	r0, .L2018+84
	muls	r3, r2, r3
	ldr	r1, [r1]
	movs	r2, #2
	lsls	r3, r3, #1
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, lr}
	b	rknand_print_hex
.L2019:
	.align	2
.L2018:
	.word	.LANCHOR131
	.word	.LANCHOR46
	.word	.LC81
	.word	.LANCHOR60
	.word	.LC82
	.word	.LANCHOR54
	.word	.LC83
	.word	.LANCHOR79
	.word	.LC84
	.word	.LANCHOR69
	.word	.LC85
	.word	.LANCHOR82
	.word	.LC86
	.word	.LANCHOR56
	.word	.LC87
	.word	.LC80
	.word	.LANCHOR57
	.word	.LC88
	.word	.LANCHOR81
	.word	.LC89
	.word	.LANCHOR83
	.word	.LC90
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",%progbits
	.align	1
	.global	pm_ppa_update_check
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldr	r3, .L2027
	movs	r4, #1
	mov	r6, r1
	mov	r7, r2
	ldrh	r0, [r3]
	rsb	r3, r0, #21
	lsls	r4, r4, r3
	ldr	r3, .L2027+4
	lsr	r0, r2, r0
	subs	r4, r4, #1
	ldrb	r1, [r3]	@ zero_extendqisi2
	ands	r0, r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L2027+8
	uxth	r0, r0
	ldr	r3, [r3]
	add	r0, r3, r0, lsl #2
	ldrb	r1, [r0, #2]	@ zero_extendqisi2
	lsrs	r1, r1, #5
	cmp	r1, #1
	beq	.L2021
	cmp	r1, #7
	bne	.L2023
.L2021:
	mov	r3, r7
	mov	r2, r6
	mov	r1, r5
	ldr	r0, .L2027+12
	bl	printf
	bl	dump_ftl_info
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, pc}
.L2023:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2028:
	.align	2
.L2027:
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR57
	.word	.LC91
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.global	load_l2p_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #31
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	bls	.L2030
	movs	r2, #30
	ldr	r1, .L2039
	ldr	r0, .L2039+4
	bl	printf
.L2031:
	b	.L2031
.L2030:
	ldr	r10, .L2039+52
	ldr	r3, [r10]
	ldrh	r2, [r3, #698]
	cmp	r2, r0
	bcs	.L2032
	mov	r1, r0
	ldr	r0, .L2039+8
	bl	printf
	ldr	r3, .L2039+12
	movs	r1, #255
	ldrh	r2, [r3]
	movs	r3, #0
	ldr	r0, [r3, #4]
	bl	ftl_memset
	ldr	r3, [r10]
	ldrh	r3, [r3, #698]
	cmp	r3, r4
	bcs	.L2036
	movs	r2, #34
	ldr	r1, .L2039
	ldr	r0, .L2039+4
	bl	printf
.L2034:
	b	.L2034
.L2032:
	ldr	r5, .L2039+16
	add	r2, r0, #176
	ldr	r7, [r3, r2, lsl #2]
	mov	r8, #0
	strh	r0, [r5, r1, lsl #3]	@ movhi
	add	r5, r5, r1, lsl #3
	strh	r8, [r5, #2]	@ movhi
	cbnz	r7, .L2035
	ldr	r3, .L2039+12
	movs	r1, #255
	ldr	r0, [r5, #4]
	ldrh	r2, [r3]
	bl	ftl_memset
.L2036:
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2035:
	ldr	r6, .L2039+20
	mov	r0, r7
	ldr	r3, .L2039+24
	ldr	r1, [r5, #4]
	ldr	r2, [r6]
	ldrb	r3, [r3]	@ zero_extendqisi2
	bl	ftl_read_ppa_page
	ldr	r2, [r6]
	mov	r3, r0
	ldr	r2, [r2]
	cmp	r2, r4
	beq	.L2037
	str	r7, [sp]
	mov	r1, r4
	ldr	r0, .L2039+28
	bl	printf
	ldr	r1, [r10]
	movs	r2, #4
	ldr	r0, .L2039+32
	ldrh	r3, [r1, #698]
	add	r1, r1, #704
	bl	rknand_print_hex
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r5, #4]
	ldr	r0, .L2039+36
	bl	rknand_print_hex
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r6]
	ldr	r0, .L2039+40
	bl	rknand_print_hex
	ldr	r3, .L2039+44
	movs	r0, #1
	ldrh	r3, [r3]
	rsb	r2, r3, #21
	lsls	r0, r0, r2
	lsrs	r7, r7, r3
	ldr	r3, .L2039+48
	subs	r0, r0, #1
	ands	r0, r0, r7
	ldrb	r1, [r3]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	mov	r1, r8
	uxth	r0, r0
	bl	ftl_sblk_dump
.L2037:
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r4, r3
	beq	.L2036
	movs	r2, #55
	ldr	r1, .L2039
	ldr	r0, .L2039+4
	bl	printf
.L2038:
	b	.L2038
.L2040:
	.align	2
.L2039:
	.word	.LANCHOR148
	.word	.LC0
	.word	.LC92
	.word	.LANCHOR149
	.word	.LANCHOR93
	.word	.LANCHOR141
	.word	.LANCHOR45
	.word	.LC93
	.word	.LC94
	.word	.LC95
	.word	.LC96
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR46
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",%progbits
	.align	1
	.global	pm_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_gc, %function
pm_gc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r4, .L2054
	ldr	r5, .L2054+4
	ldr	r3, [r4]
	mov	r8, r4
	ldrh	r2, [r3, #688]
	ldrh	r3, [r5]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L2043
	bl	pm_free_sblk
	ldr	r2, [r4]
	ldrh	r3, [r5]
	ldrh	r1, [r2, #688]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L2043
	uxth	r0, r0
	movw	r7, #65535
	adds	r0, r0, #208
	ldrh	r6, [r2, r0, lsl #1]
	cmp	r6, r7
	bne	.L2045
	movs	r2, #127
	ldr	r1, .L2054+8
	ldr	r0, .L2054+12
	bl	printf
.L2046:
	b	.L2046
.L2045:
	ldr	r4, .L2054+16
	bl	pm_select_ram_region
	mov	r5, r0
	ldrh	r0, [r4, r0, lsl #3]
	cmp	r0, r7
	beq	.L2047
	add	r7, r4, r5, lsl #3
	ldr	r1, [r7, #4]
	cbz	r1, .L2047
	ldrsh	r3, [r7, #2]
	cmp	r3, #0
	bge	.L2047
	bl	pm_write_page
	ldrh	r3, [r7, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r7, #2]	@ movhi
.L2047:
	mov	fp, #0
.L2048:
	ldr	r1, [r8]
	uxth	r10, fp
	ldrh	r0, [r1, #698]
	cmp	r0, r10
	bhi	.L2050
	bl	pm_free_sblk
.L2043:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2050:
	ldr	r3, .L2054+20
	uxth	r7, fp
	add	ip, r7, #176
	ldrh	r0, [r3]
	ldr	r1, [r1, ip, lsl #2]
	ldr	r3, .L2054+24
	lsr	ip, r1, r0
	rsb	r1, r0, #21
	movs	r0, #1
	lsls	r0, r0, r1
	ldrb	r1, [r3]	@ zero_extendqisi2
	subs	r0, r0, #1
	and	r0, ip, r0
	bl	__aeabi_uidiv
	uxth	r0, r0
	cmp	r6, r0
	bne	.L2049
	mov	r1, r5
	mov	r0, r10
	bl	load_l2p_region
	add	r2, r4, r5, lsl #3
	mov	r0, r7
	ldr	r1, [r2, #4]
	bl	pm_write_page
.L2049:
	add	fp, fp, #1
	b	.L2048
.L2055:
	.align	2
.L2054:
	.word	.LANCHOR46
	.word	.LANCHOR101
	.word	.LANCHOR150
	.word	.LC0
	.word	.LANCHOR93
	.word	.LANCHOR71
	.word	.LANCHOR70
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",%progbits
	.align	1
	.global	pm_flush_id
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_flush_id, %function
pm_flush_id:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2061
	push	{r4, lr}
	add	r4, r3, r0, lsl #3
	ldrh	r0, [r3, r0, lsl #3]
	ldr	r1, [r4, #4]
	bl	pm_write_page
	ldrh	r3, [r4, #2]
	ubfx	r3, r3, #0, #15
	strh	r3, [r4, #2]	@ movhi
	ldr	r4, .L2061+4
	ldr	r3, [r4]
	cbz	r3, .L2057
	bl	pm_gc
	movs	r3, #0
	str	r3, [r4]
.L2057:
	movs	r0, #0
	pop	{r4, pc}
.L2062:
	.align	2
.L2061:
	.word	.LANCHOR93
	.word	.LANCHOR91
	.size	pm_flush_id, .-pm_flush_id
	.section	.text.pm_flush,"ax",%progbits
	.align	1
	.global	pm_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_flush, %function
pm_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r5, .L2067
.L2065:
	add	r3, r5, r4, lsl #3
	uxth	r0, r4
	ldrsh	r3, [r3, #2]
	cmp	r3, #0
	bge	.L2064
	bl	pm_flush_id
.L2064:
	adds	r4, r4, #1
	cmp	r4, #32
	bne	.L2065
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2068:
	.align	2
.L2067:
	.word	.LANCHOR93
	.size	pm_flush, .-pm_flush
	.section	.text.flt_sys_flush,"ax",%progbits
	.align	1
	.global	flt_sys_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flt_sys_flush, %function
flt_sys_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r0, #0
	pop	{r3, lr}
	b	ftl_info_flush
	.size	flt_sys_flush, .-flt_sys_flush
	.section	.text.rk_ftl_de_init,"ax",%progbits
	.align	1
	.global	rk_ftl_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	FlashDeInit
	bl	flt_sys_flush
	pop	{r3, lr}
	b	FlashDeInit
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.pm_init,"ax",%progbits
	.align	1
	.global	pm_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_init, %function
pm_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	ldr	r5, .L2088
	movs	r4, #0
	movs	r0, #64
	ldr	r3, .L2088+4
	ldr	r7, .L2088+8
	mov	r10, r5
	str	r4, [r3]
	bl	ftl_malloc
	str	r0, [r7]
.L2073:
	movw	r3, #65535
	adds	r6, r5, r4
	strh	r3, [r4, r5]	@ movhi
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	cmp	r8, #0
	beq	.L2072
	ldr	r3, .L2088+12
	ldrb	r0, [r3]	@ zero_extendqisi2
	lsls	r0, r0, #9
	bl	ftl_malloc
	str	r0, [r6, #4]
.L2072:
	adds	r4, r4, #8
	cmp	r4, #256
	bne	.L2073
	ldr	r3, [r10, #4]
	ldr	r4, .L2088+16
	ldr	r8, [r7]
	str	r3, [sp, #12]
	ldr	r3, [r4]
	ldr	r2, [sp, #12]
	ldrh	r1, [r3, #692]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	movs	r3, #4
	str	r3, [sp]
	mov	r3, r8
	bl	flash_get_last_written_page
	ldr	r1, [r4]
	mov	r5, r0
	ldrh	r2, [r1, #696]
	cmp	r2, r0
	bgt	.L2074
	mov	r3, r0
	ldrh	r1, [r1, #692]
	ldr	r0, .L2088+20
	bl	printf
	ldr	r3, [r4]
	ldrsh	r6, [r3, #696]
.L2075:
	cmp	r6, r5
	ble	.L2077
	ldr	r3, .L2088+24
	movs	r2, #1
	add	r5, r5, r2
	strb	r2, [r3]
	ldr	r3, [r4]
	strh	r5, [r3, #696]	@ movhi
	bl	pm_free_sblk
	ldr	r1, [r10, #4]
	mov	r0, #-1
	bl	pm_write_page
	ldr	r1, [r10, #4]
	mov	r0, #-1
	bl	pm_write_page
.L2074:
	bl	pm_free_sblk
	bl	pm_gc
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2077:
	ldr	r3, [r4]
	ldr	r2, .L2088+28
	ldrh	r7, [r3, #692]
	ldrh	r2, [r2]
	ldrb	r0, [r3, #694]	@ zero_extendqisi2
	ldr	r3, .L2088+12
	mla	r7, r2, r7, r6
	ldr	r2, [sp, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r7
	str	r3, [sp]
	mov	r3, r8
	bl	flash_read_page_en
	ldr	r3, [r4]
	mov	fp, r0
	ldr	r0, .L2088+32
	ldr	r2, [r3, #48]
	adds	r2, r2, #1
	str	r2, [r3, #48]
	mov	r2, r7
	ldrh	r3, [r3, #694]
	ldr	r1, [r8]
	bl	printf
	cmp	fp, #-1
	beq	.L2076
	cmp	fp, #512
	beq	.L2076
	ldr	r2, [r4]
	ldr	r3, [r8]
	ldrh	r1, [r2, #698]
	cmp	r3, r1
	itt	cc
	addcc	r3, r3, #176
	strcc	r7, [r2, r3, lsl #2]
.L2076:
	adds	r6, r6, #1
	sxth	r6, r6
	b	.L2075
.L2089:
	.align	2
.L2088:
	.word	.LANCHOR93
	.word	.LANCHOR91
	.word	.LANCHOR141
	.word	.LANCHOR45
	.word	.LANCHOR46
	.word	.LC97
	.word	.LANCHOR133
	.word	.LANCHOR75
	.word	.LC98
	.size	pm_init, .-pm_init
	.section	.text.pm_log2phys,"ax",%progbits
	.align	1
	.global	pm_log2phys
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	pm_log2phys, %function
pm_log2phys:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2104
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r1
	mov	r4, r0
	mov	r8, r2
	ldrb	r5, [r3]	@ zero_extendqisi2
	lsls	r1, r5, #7
	lsls	r5, r5, #7
	bl	__aeabi_uidiv
	ldr	r3, .L2104+4
	uxth	r10, r0
	mov	r6, r0
	smulbb	r5, r5, r10
	ldr	r2, [r3]
	subs	r5, r4, r5
	cmp	r4, r2
	uxth	r5, r5
	bcc	.L2091
	mov	r1, r4
	ldr	r0, .L2104+8
	bl	printf
	mov	r0, #-1
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2091:
	ldr	r2, .L2104+12
	movs	r3, #0
	mov	fp, r2
.L2097:
	add	r1, r2, r3, lsl #3
	uxth	r4, r3
	ldr	r1, [r1, #4]
	cbz	r1, .L2093
	ldrh	r1, [r2, r3, lsl #3]
	cmp	r1, r10
	bne	.L2093
.L2094:
	lsls	r4, r4, #3
	cmp	r8, #0
	bne	.L2095
	add	r3, fp, r4
	ldr	r3, [r3, #4]
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r7]
.L2096:
	add	r4, r4, fp
	movw	r2, #32767
	ldrh	r3, [r4, #2]
	ubfx	r1, r3, #0, #15
	cmp	r1, r2
	beq	.L2099
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
.L2099:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2095:
	add	r2, fp, r4
	ldr	r1, [r7]
	ldr	r3, [r2, #4]
	str	r1, [r3, r5, lsl #2]
	ldrh	r3, [r2, #2]
	mvn	r3, r3, lsl #17
	mvn	r3, r3, lsr #17
	strh	r3, [r2, #2]	@ movhi
	ldr	r3, .L2104+16
	strb	r6, [r3]
	b	.L2096
.L2093:
	adds	r3, r3, #1
	cmp	r3, #32
	bne	.L2097
	bl	pm_select_ram_region
	ldrh	r2, [fp, r0, lsl #3]
	movw	r3, #65535
	mov	r4, r0
	cmp	r2, r3
	beq	.L2098
	add	r3, fp, r0, lsl #3
	ldrsh	r3, [r3, #2]
	cmp	r3, #0
	bge	.L2098
	bl	pm_flush_id
.L2098:
	ldr	r3, .L2104+20
	mov	r1, r4
	mov	r0, r10
	strb	r4, [r3]
	bl	load_l2p_region
	b	.L2094
.L2105:
	.align	2
.L2104:
	.word	.LANCHOR45
	.word	.LANCHOR47
	.word	.LC99
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR151
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.ftl_read_ahead,"ax",%progbits
	.align	1
	.global	ftl_read_ahead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read_ahead, %function
ftl_read_ahead:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, lr}
	sub	sp, sp, #28
	ldr	r6, .L2119
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L2107
	movs	r0, #0
	bl	buf_alloc
	mov	r4, r0
	mov	r0, #-1
	cbz	r4, .L2106
	ldr	r5, [r6]
	str	r0, [r6]
	ldr	r7, [r4, #4]
	str	r5, [r4, #20]
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #20]
	adds	r0, r0, #1
	ldr	r6, [r4, #12]
	bne	.L2109
	movs	r2, #0
	add	r1, sp, #20
	mov	r0, r5
	bl	pm_log2phys
.L2109:
	ldr	r3, [sp, #20]
	str	r3, [r4, #24]
	str	r3, [r4, #28]
	adds	r3, r3, #1
	bne	.L2110
	ldr	r3, .L2119+4
	movs	r1, #0
	mov	r0, r7
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #9
	bl	ftl_memset
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #8
	strb	r3, [r4, #2]
.L2107:
	movs	r0, #0
.L2106:
	add	sp, sp, #28
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2110:
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r7, [r4, #36]
	cmp	r7, #256
	bne	.L2111
	ldr	r3, .L2119+8
	mov	r8, #1
	ldr	r0, [sp, #20]
	ldrh	r2, [r3]
	rsb	r3, r2, #21
	lsrs	r0, r0, r2
	lsl	r3, r8, r3
	ldr	r2, .L2119+12
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r2, [r4, #20]
	uxth	r1, r0
	mov	r10, r0
	ldr	r3, [r4, #24]
	ldr	r0, .L2119+16
	bl	printf
	movs	r2, #0
	mov	r1, r8
	uxth	r0, r10
	bl	gc_add_sblk
.L2111:
	ldr	r3, [r6, #4]
	cmp	r5, r3
	beq	.L2112
	ldr	r2, [r6, #12]
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L2119+20
	str	r2, [sp, #12]
	ldr	r2, [r6, #8]
	str	r3, [sp, #4]
	str	r2, [sp, #8]
	mov	r2, r5
	ldr	r3, [r6]
	str	r3, [sp]
	ldr	r3, [sp, #20]
	bl	printf
.L2112:
	ldr	r3, [r6, #4]
	cmp	r5, r3
	bne	.L2113
	adds	r7, r7, #1
	bne	.L2107
.L2113:
	movw	r2, #758
	ldr	r1, .L2119+24
	ldr	r0, .L2119+28
	bl	printf
.L2114:
	b	.L2114
.L2120:
	.align	2
.L2119:
	.word	.LANCHOR49
	.word	.LANCHOR45
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LC100
	.word	.LC101
	.word	.LANCHOR152
	.word	.LC0
	.size	ftl_read_ahead, .-ftl_read_ahead
	.section	.text.gc_update_l2p_map,"ax",%progbits
	.align	1
	.global	gc_update_l2p_map
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_update_l2p_map, %function
gc_update_l2p_map:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2138
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	sub	sp, sp, #24
	mov	r4, r5
	mov	r8, r5
	ldr	fp, [r3]
.L2122:
	ldr	r3, .L2138+4
	ldrh	r3, [r3]
	cmp	r4, r3
	bge	.L2132
	lsls	r3, r4, #1
	movs	r7, #0
	subs	r3, r3, #1
	str	r3, [sp, #8]
	b	.L2133
.L2129:
	ldr	r3, .L2138+8
	ldr	r3, [r3]
	ldr	r10, [r3, r8, lsl #2]
	cmp	r10, #-1
	beq	.L2123
	ldr	r2, .L2138+12
	mov	r0, r10
	ldr	r2, [r2]
	ldr	r3, [r2, r8, lsl #2]
	str	r3, [sp, #4]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #20]
	adds	r0, r0, #1
	bne	.L2124
	movs	r2, #0
	add	r1, sp, #20
	mov	r0, r10
	bl	pm_log2phys
.L2124:
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bne	.L2125
	ldr	r3, [sp, #12]
	ldr	r2, .L2138+16
	ldrh	r1, [r3, #96]
	ldrh	r2, [r2]
	ldr	r3, .L2138+20
	muls	r2, r1, r2
	ldrb	r1, [r3]	@ zero_extendqisi2
	cmp	r1, #3
	bne	.L2126
	add	r2, r2, r4
	orr	r2, r2, r6, lsl #24
.L2137:
	str	r2, [sp, #16]
	add	r1, sp, #16
	movs	r2, #1
	mov	r0, r10
	bl	pm_log2phys
	ldr	r3, .L2138+24
	adds	r5, r5, #1
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, [sp, #4]
	subs	r3, r3, #1
	lsrs	r2, r2, r0
	mov	r0, r2
	ldr	r2, .L2138+28
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
.L2125:
	add	r8, r8, #1
.L2123:
	adds	r6, r6, #1
.L2131:
	ldr	r3, .L2138+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r6, r3
	ble	.L2129
	adds	r7, r7, #1
.L2133:
	ldrb	r3, [fp, #89]	@ zero_extendqisi2
	cmp	r7, r3
	bge	.L2130
	add	r3, fp, r7, lsl #1
	movs	r6, #1
	str	r3, [sp, #12]
	b	.L2131
.L2126:
	cmp	r1, #2
	itett	eq
	ldreq	r3, [sp, #8]
	addne	r2, r2, r4
	addeq	r2, r2, r3
	addeq	r2, r2, r6
	it	eq
	orreq	r2, r2, #33554432
	b	.L2137
.L2130:
	adds	r4, r4, #1
	b	.L2122
.L2132:
	ldr	r3, .L2138+32
	ldrh	r2, [fp, #80]
	ldr	r3, [r3]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2139:
	.align	2
.L2138:
	.word	.LANCHOR60
	.word	.LANCHOR79
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR75
	.word	.LANCHOR64
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR56
	.size	gc_update_l2p_map, .-gc_update_l2p_map
	.section	.text.gc_update_l2p_map_new,"ax",%progbits
	.align	1
	.global	gc_update_l2p_map_new
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_update_l2p_map_new, %function
gc_update_l2p_map_new:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2177
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, .L2177+4
	ldr	r4, [r3]
	ldrh	r2, [r2]
	str	r3, [sp, #16]
	ldrb	r1, [r4, #89]	@ zero_extendqisi2
	muls	r2, r1, r2
	str	r2, [sp, #4]
	ldr	r2, .L2177+8
	ldr	r2, [r2]
	tst	r2, #256
	beq	.L2141
	ldrh	r1, [r4, #80]
	ldr	r0, .L2177+12
	bl	printf
.L2141:
	ldr	r3, .L2177+16
	movs	r7, #0
	ldr	r1, [sp, #4]
	mov	r5, r7
	ldrh	r2, [r4, #80]
	ldr	r3, [r3]
	subs	r1, r1, #1
	strh	r1, [r3, r2, lsl #1]	@ movhi
.L2142:
	ldr	r3, [sp, #4]
	cmp	r5, r3
	bne	.L2151
	ldr	r3, .L2177+8
	ldr	r5, .L2177+16
	ldr	r3, [r3]
	tst	r3, #256
	beq	.L2152
	ldr	r3, [sp, #16]
	ldrh	r0, [r4, #80]
	ldr	r2, [r5]
	ldr	r1, [r3]
	mov	r3, r7
	ldrh	r2, [r2, r0, lsl #1]
	ldrh	r1, [r1, #80]
	ldr	r0, .L2177+20
	bl	printf
.L2152:
	ldrh	r2, [r4, #80]
	ldr	r3, [r5]
	ldrh	r1, [r3, r2, lsl #1]
	cmp	r7, r1
	beq	.L2153
	mov	r2, #448
	ldr	r1, .L2177+24
	ldr	r0, .L2177+28
	bl	printf
.L2154:
	b	.L2154
.L2151:
	ldr	r3, .L2177+32
	lsl	r8, r5, #2
	ldr	r3, [r3]
	ldr	r6, [r3, r5, lsl #2]
	adds	r2, r6, #1
	beq	.L2143
	ldr	r3, .L2177+36
	mov	r0, r6
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp, #12]
	ldr	r3, .L2177+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2144
	mov	r3, r5
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L2177+40
	bl	printf
.L2144:
	ldr	fp, .L2177+32
	str	r5, [sp, #8]
.L2150:
	ldr	r3, [fp]
	ldr	r6, [r3, r8]
	adds	r0, r6, #1
	beq	.L2145
	ldr	r3, .L2177+36
	mov	r0, r6
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L2145
	ldr	r3, .L2177+44
	mov	r0, r6
	ldr	r3, [r3]
	ldr	r10, [r3, r8]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L2146
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r6
	bl	pm_log2phys
.L2146:
	ldr	r3, [sp, #28]
	cmp	r10, r3
	bne	.L2147
	ldr	r3, .L2177+48
	add	r1, sp, #32
	movs	r2, #1
	mov	r0, r6
	adds	r7, r7, #1
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	str	r3, [r1, #-8]!
	bl	pm_log2phys
	ldr	r3, .L2177+52
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, .L2177+56
	lsr	r0, r10, r0
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r3, r0
	mov	r0, r3
	str	r3, [sp, #20]
	bl	ftl_vpn_decrement
	ldrh	r2, [r4, #80]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	bne	.L2148
	ldr	r3, .L2177+8
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L2148
	ldr	r3, [sp, #28]
	mov	r2, r10
	mov	r1, r6
	ldr	r0, .L2177+60
	bl	printf
.L2148:
	ldr	r3, [fp]
	mov	r2, #-1
	str	r2, [r3, r8]
.L2145:
	ldr	r3, [sp, #8]
	add	r8, r8, #4
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bne	.L2150
.L2143:
	adds	r5, r5, #1
	b	.L2142
.L2147:
	ldr	r2, .L2177+8
	ldr	r2, [r2]
	lsls	r2, r2, #23
	bpl	.L2149
	mov	r2, r10
	mov	r1, r6
	ldr	r0, .L2177+64
	bl	printf
.L2149:
	ldrh	r0, [r4, #80]
	bl	ftl_vpn_decrement
	b	.L2148
.L2153:
	strh	r7, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2178:
	.align	2
.L2177:
	.word	.LANCHOR60
	.word	.LANCHOR68
	.word	.LANCHOR22
	.word	.LC102
	.word	.LANCHOR56
	.word	.LC106
	.word	.LANCHOR153
	.word	.LC0
	.word	.LANCHOR107
	.word	.LANCHOR45
	.word	.LC103
	.word	.LANCHOR108
	.word	.LANCHOR109
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LC104
	.word	.LC105
	.size	gc_update_l2p_map_new, .-gc_update_l2p_map_new
	.section	.text.gc_scan_src_blk_one_page,"ax",%progbits
	.align	1
	.global	gc_scan_src_blk_one_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_src_blk_one_page, %function
gc_scan_src_blk_one_page:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r0, #0
	ldr	r4, .L2214
	mov	r6, r0
	movw	r7, #65535
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	add	r2, r4, r3, lsl #1
	ldrh	r5, [r2, #36]
	ldr	r2, .L2214+4
	ldrb	r1, [r2]	@ zero_extendqisi2
	ldrh	r2, [r4, #2]
.L2180:
	cmp	r5, r7
	beq	.L2182
	cbz	r6, .L2183
	strb	r3, [r4, #4]
.L2183:
	cbz	r0, .L2184
	strh	r2, [r4, #2]	@ movhi
.L2184:
	ldr	r3, .L2214+8
	ldrh	r3, [r3]
	muls	r5, r3, r5
	ldr	r3, .L2214+12
	ldrb	r2, [r3]	@ zero_extendqisi2
	mov	r8, r3
	cmp	r2, #2
	bne	.L2185
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2185
	ldrh	r3, [r4, #2]
	add	r5, r5, r3, lsl #1
.L2186:
	ldrb	r3, [r4, #4]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r1, r3
	strb	r3, [r4, #4]
	bne	.L2187
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #4]
.L2187:
	ldr	r10, .L2214+16
	movs	r0, #1
	bl	buf_alloc
	movs	r6, #0
	mov	r7, r0
.L2197:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2188
	cmp	r6, #0
	beq	.L2189
.L2188:
	cmp	r3, r6
	bgt	.L2190
.L2198:
	mov	r0, r7
	bl	buf_free
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2182:
	adds	r3, r3, #1
	movs	r6, #1
	uxtb	r3, r3
	cmp	r3, r1
	itt	eq
	moveq	r3, #0
	addeq	r2, r2, #1
	add	r5, r4, r3, lsl #1
	itt	eq
	uxtheq	r2, r2
	moveq	r0, #1
	ldrh	r5, [r5, #36]
	b	.L2180
.L2185:
	ldrh	r3, [r4, #2]
	add	r5, r5, r3
	b	.L2186
.L2190:
	ldrb	r2, [r8]	@ zero_extendqisi2
	cmp	r2, #2
	bne	.L2191
	cbnz	r3, .L2191
	adds	r3, r6, r5
	orr	r3, r3, #33554432
.L2213:
	str	r3, [r7, #24]
	movs	r1, #1
	mov	r0, r7
	bl	sblk_read_page
	ldr	r3, [r7, #36]
	adds	r2, r3, #1
	beq	.L2194
	cmp	r3, #512
	beq	.L2194
	ldr	r3, [r7, #12]
	ldr	fp, [r3, #4]
	mov	r0, fp
	bl	lpa_hash_get_ppa
	str	r0, [sp, #4]
	adds	r0, r0, #1
	bne	.L2196
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, fp
	bl	pm_log2phys
.L2196:
	ldr	r3, [sp, #4]
	cmp	r5, r3
	bne	.L2194
	ldrh	r3, [r4, #20]
	ldr	r2, [r10]
	str	r5, [r2, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L2194:
	ldrh	r3, [r4, #22]
	adds	r3, r3, #1
	strh	r3, [r4, #22]	@ movhi
.L2189:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L2197
	b	.L2198
.L2191:
	orr	r3, r5, r6, lsl #24
	b	.L2213
.L2215:
	.align	2
.L2214:
	.word	.LANCHOR59
	.word	.LANCHOR69
	.word	.LANCHOR75
	.word	.LANCHOR64
	.word	.LANCHOR61
	.size	gc_scan_src_blk_one_page, .-gc_scan_src_blk_one_page
	.section	.text.gc_scan_static_data,"ax",%progbits
	.align	1
	.global	gc_scan_static_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_static_data, %function
gc_scan_static_data:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	ldr	r4, .L2234
	ldr	r3, [r4]
	ldr	r2, [r3, #544]
	adds	r2, r2, #1
	beq	.L2217
	ldr	r6, .L2234+4
	movs	r5, #11
	ldr	r7, .L2234+8
.L2226:
	ldr	r3, [r4]
	movs	r2, #0
	add	r1, sp, #4
	ldr	r0, [r3, #544]
	bl	pm_log2phys
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L2218
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #4]
	mov	r8, r0
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r8, #36]
	cmp	r3, #256
	bne	.L2219
	ldrh	r2, [r6]
	mov	r10, #1
	ldr	r0, [sp, #4]
	ldrb	r1, [r7]	@ zero_extendqisi2
	rsb	r3, r2, #21
	lsl	r3, r10, r3
	lsrs	r0, r0, r2
	subs	r3, r3, #1
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, r10
	uxth	r0, r0
	bl	gc_add_sblk
.L2219:
	ldr	r2, [r8, #12]
	ldr	r3, [r4]
	ldr	r2, [r2, #4]
	ldr	r3, [r3, #544]
	cmp	r2, r3
	beq	.L2220
	movw	r2, #1149
	ldr	r1, .L2234+12
	ldr	r0, .L2234+16
	bl	printf
.L2221:
	b	.L2221
.L2220:
	mov	r0, r8
	bl	buf_free
.L2218:
	ldr	r3, [r4]
	ldr	r1, .L2234+20
	ldr	r2, [r3, #544]
	ldr	r1, [r1]
	adds	r2, r2, #1
	cmp	r2, r1
	str	r2, [r3, #544]
	bcc	.L2222
	mov	r2, #-1
	str	r2, [r3, #544]
	ldr	r2, [r3, #548]
	adds	r2, r2, #1
	str	r2, [r3, #548]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
.L2216:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2222:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	bne	.L2216
	subs	r5, r5, #1
	uxth	r5, r5
	cmp	r5, #0
	bne	.L2226
	b	.L2216
.L2217:
	ldr	r2, .L2234+24
	ldr	r2, [r2]
	ldr	r1, [r2, #40]
	cmp	r1, #20480
	bls	.L2228
	ldr	r0, [r2, #44]
	add	r0, r0, r1, lsr #10
	ubfx	r1, r1, #0, #10
	str	r1, [r2, #40]
	str	r0, [r2, #44]
.L2228:
	ldr	r1, [r3, #536]
	ldr	r0, [r3, #12]
	add	r1, r1, #12910592
	add	r1, r1, #49408
	cmp	r0, r1
	ldr	r1, [r2, #44]
	bhi	.L2229
	ldr	r2, [r3, #540]
	add	r2, r2, #99840
	adds	r2, r2, #160
	cmp	r1, r2
	bls	.L2216
.L2229:
	movs	r2, #0
	str	r1, [r3, #540]
	str	r0, [r3, #536]
	str	r2, [r3, #544]
	b	.L2216
.L2235:
	.align	2
.L2234:
	.word	.LANCHOR60
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR154
	.word	.LC0
	.word	.LANCHOR47
	.word	.LANCHOR46
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",%progbits
	.align	1
	.global	ftl_sblk_dump
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	cmp	r0, r3
	sub	sp, sp, #120
	mov	r7, r0
	str	r1, [sp, #64]
	beq	.L2258
	ldr	r5, .L2286
	lsls	r4, r0, #2
	add	r1, sp, #104
	strh	r0, [sp, #88]	@ movhi
	ldr	r3, [r5]
	add	r3, r3, r4
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	and	r3, r3, #224
	cmp	r3, #160
	itet	eq
	ldreq	r3, .L2286+4
	movne	r3, #1
	ldrbeq	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #44]
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L2286+8
	uxtb	r0, r0
	movs	r2, #0
	strb	r0, [sp, #97]
	ldrh	r1, [r3]
	ldr	r3, .L2286+12
	strh	r2, [sp, #90]	@ movhi
	strb	r2, [sp, #93]
	ldr	r3, [r3]
	smulbb	r1, r1, r0
	strh	r2, [sp, #98]	@ movhi
	lsls	r6, r3, #19
	strh	r1, [sp, #94]	@ movhi
	bpl	.L2239
	ldr	r3, [r5]
	mov	r1, r7
	add	r3, r3, r4
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	str	r0, [sp]
	ldr	r3, [sp, #44]
	ldr	r0, .L2286+16
	lsrs	r2, r2, #5
	bl	printf
.L2239:
	movs	r6, #0
	movs	r0, #1
	bl	buf_alloc
	mov	fp, r6
	mov	r5, r0
	str	r6, [sp, #52]
	str	r6, [sp, #48]
.L2240:
	ldr	r3, .L2286+8
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bls	.L2255
	str	r3, [sp, #68]
	lsls	r3, r3, #1
	ldr	r8, .L2286+12
	subs	r3, r3, #1
	str	r3, [sp, #72]
	movs	r3, #0
	str	r3, [sp, #56]
	b	.L2256
.L2252:
	ldr	r3, [sp, #76]
	add	r2, sp, #120
	add	r3, r2, r3, lsl #1
	ldrh	r10, [r3, #-32]
	movw	r3, #65535
	cmp	r10, r3
	beq	.L2241
	ldr	r3, .L2286+20
	ldrh	r4, [r3]
	ldr	r3, [sp, #44]
	cmp	r3, #3
	mul	r4, r10, r4
	bne	.L2242
	ldr	r3, [sp, #40]
	uxtah	r4, r4, r6
.L2284:
	orr	r4, r4, r3, lsl #24
.L2243:
	movs	r1, #1
	str	r4, [r5, #24]
	mov	r0, r5
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	str	r3, [sp, #60]
	ldr	r3, [r8]
	lsls	r1, r3, #19
	bpl	.L2245
	ldr	r2, [r5, #12]
	ldr	r3, [r5, #4]
	ldr	r0, .L2286+24
	ldr	r1, [r2, #12]
	str	r1, [sp, #32]
	ldr	r1, [r2, #8]
	str	r1, [sp, #28]
	ldr	r1, [r2, #4]
	str	r1, [sp, #24]
	mov	r1, r10
	ldr	r2, [r2]
	str	r2, [sp, #20]
	ldr	r2, [r3, #12]
	str	r2, [sp, #16]
	ldr	r2, [r3, #8]
	str	r2, [sp, #12]
	ldr	r2, [r3, #4]
	str	r2, [sp, #8]
	ldr	r3, [r3]
	ldr	r2, [sp, #68]
	str	r3, [sp, #4]
	ldr	r3, [sp, #60]
	str	r3, [sp]
	mov	r3, r4
	bl	printf
.L2245:
	ldr	r3, [sp, #60]
	adds	r2, r3, #1
	beq	.L2260
	cmp	r3, #512
	ldr	r3, [sp, #48]
	it	eq
	moveq	r3, #1
.L2285:
	str	r3, [sp, #48]
	ldr	r3, [r5, #12]
	ldr	r10, [r3, #4]
	mov	r0, r10
	bl	lpa_hash_get_ppa
	str	r0, [sp, #84]
	adds	r0, r0, #1
	bne	.L2247
	movs	r2, #0
	add	r1, sp, #84
	mov	r0, r10
	bl	pm_log2phys
.L2247:
	ldr	r3, [sp, #84]
	cmp	r4, r3
	bne	.L2248
	ldr	r3, [sp, #52]
	adds	r3, r3, #1
	str	r3, [sp, #52]
	ldr	r3, [r8]
	lsls	r0, r3, #19
	bpl	.L2248
	ldr	r2, [r5, #12]
	mov	r1, r4
	ldr	r3, [sp, #52]
	ldr	r0, .L2286+28
	ldr	r2, [r2, #4]
	bl	printf
.L2248:
	ldr	r3, [sp, #64]
	cbz	r3, .L2249
	ldr	r2, [r3, fp, lsl #2]
	lsl	r4, fp, #2
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	cmp	r3, r2
	beq	.L2250
	ldr	r3, [r8]
	lsls	r1, r3, #19
	bpl	.L2250
	mov	r1, fp
	ldr	r0, .L2286+32
	bl	printf
.L2250:
	ldr	r3, [sp, #64]
	ldr	r2, [r5, #12]
	ldr	r3, [r3, r4]
	ldr	r2, [r2, #4]
	cmp	r2, r3
	beq	.L2249
	adds	r3, r3, #1
	beq	.L2249
	mov	r2, #616
	ldr	r1, .L2286+36
	ldr	r0, .L2286+40
	bl	printf
.L2251:
	b	.L2251
.L2242:
	ldr	r3, [sp, #44]
	cmp	r3, #2
	bne	.L2244
	ldr	r3, [sp, #72]
	add	r4, r4, r3
	ldr	r3, [sp, #40]
	add	r4, r4, r3
	ldr	r3, .L2286+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	b	.L2284
.L2244:
	uxtah	r4, r4, r6
	b	.L2243
.L2260:
	movs	r3, #1
	b	.L2285
.L2249:
	add	fp, fp, #1
.L2241:
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #40]
.L2254:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r3, r2
	bcs	.L2252
	ldr	r3, [sp, #56]
	adds	r3, r3, #1
	str	r3, [sp, #56]
.L2256:
	ldrb	r2, [sp, #97]	@ zero_extendqisi2
	ldrh	r3, [sp, #56]
	cmp	r2, r3
	bls	.L2253
	movs	r3, #1
	str	r3, [sp, #40]
	ldrh	r3, [sp, #56]
	adds	r3, r3, #8
	str	r3, [sp, #76]
	b	.L2254
.L2253:
	adds	r6, r6, #1
	b	.L2240
.L2255:
	mov	r0, r5
	bl	buf_free
	ldr	r3, .L2286+12
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2257
	ldr	r3, .L2286+44
	mov	r1, r7
	ldr	r0, .L2286+48
	ldr	r2, [r3]
	ldr	r3, [sp, #52]
	ldrh	r2, [r2, r7, lsl #1]
	bl	printf
.L2257:
	ldr	r0, [sp, #48]
.L2236:
	add	sp, sp, #120
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2258:
	movs	r0, #0
	b	.L2236
.L2287:
	.align	2
.L2286:
	.word	.LANCHOR57
	.word	.LANCHOR64
	.word	.LANCHOR79
	.word	.LANCHOR22
	.word	.LC107
	.word	.LANCHOR75
	.word	.LC73
	.word	.LC108
	.word	.LC109
	.word	.LANCHOR155
	.word	.LC0
	.word	.LANCHOR56
	.word	.LC110
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.gc_search_src_blk,"ax",%progbits
	.align	1
	.global	gc_search_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_search_src_blk, %function
gc_search_src_blk:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2360
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	str	r2, [sp, #12]
	mov	r7, r0
	mov	fp, r3
	ldr	r2, [r3]
	str	r1, [sp, #16]
	add	r1, r0, #60
	ldrh	r5, [r2, r1, lsl #1]
	cmp	r5, #0
	bne	.L2288
	ldr	r3, .L2360+4
	ldr	r6, .L2360+8
	ldr	r2, [r3]
	mov	r10, r3
	ldrh	r4, [r2, #134]
	ldr	r2, [r6]
	tst	r2, #256
	beq	.L2291
	mov	r1, r0
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #16]
	ldr	r0, .L2360+12
	bl	printf
.L2291:
	ldr	r3, [r6]
	lsls	r2, r3, #23
	bpl	.L2292
	ldr	r2, [fp]
	ldr	r1, [r10]
	ldr	r3, .L2360+16
	ldrh	r2, [r2, #126]
	ldrh	r1, [r1, #134]
	ldrh	r3, [r3]
	ldr	r0, .L2360+12
	bl	printf
.L2292:
	ldr	r3, [sp, #12]
	cmp	r3, #64
	bls	.L2293
	movw	r2, #1028
	ldr	r1, .L2360+20
	ldr	r0, .L2360+24
	bl	printf
.L2294:
	b	.L2294
.L2293:
	ldr	r3, .L2360+28
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L2360+32
	ldrh	r6, [r3]
	ldr	r3, .L2360+36
	ldrh	r3, [r3]
	smulbb	r6, r6, r2
	uxth	r6, r6
	smulbb	r3, r3, r2
	uxth	r3, r3
	str	r3, [sp, #8]
	ldr	r3, [r10]
	ldrh	r3, [r3, #134]
.L2357:
	str	r3, [sp, #4]
	ldr	r3, .L2360+40
	ldr	r0, [sp, #4]
	ldrh	r2, [r3]
	ldr	r3, [r10]
	ldrh	r3, [r3, #134]
	subs	r1, r2, r3
	cmp	r0, r1
	blt	.L2307
.L2304:
	ldr	r3, [r10]
	ldr	r2, [sp, #4]
	ldrh	r1, [r3, #134]
	ldr	r3, .L2360+40
	ldrh	r3, [r3]
	subs	r3, r3, r1
	cmp	r2, r3
	ldr	r2, .L2360+32
	ldr	r3, [fp]
	blt	.L2308
	strh	r1, [r3, #126]	@ movhi
	cmp	r7, #0
	bne	.L2309
	ldr	r3, .L2360+16
	ldrh	r2, [r2]
	ldrh	r1, [r3]
	rsb	r0, r2, r2, lsl #3
	cmp	r1, r6
	it	cc
	strhcc	r6, [r3]	@ movhi
	ldrh	r1, [r3]
	cmp	r1, r0, asr #3
	bge	.L2312
	add	r1, r1, r2, lsr #3
	strh	r1, [r3]	@ movhi
.L2312:
	ldr	r3, .L2360+8
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2318
	mov	r1, r5
	ldr	r0, .L2360+44
	bl	printf
.L2318:
	bl	print_ftl_debug_info
.L2288:
	mov	r0, r5
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2307:
	ldr	r1, [fp]
	ldrh	r4, [r1, #126]
	ldr	r1, [sp, #4]
	add	r4, r4, r1
	uxth	r4, r4
	cmp	r2, r4
	bhi	.L2296
	subs	r3, r3, r2
	add	r4, r4, r3
	uxth	r4, r4
	cmp	r2, r4
	bhi	.L2296
	movw	r2, #1038
	ldr	r1, .L2360+20
	ldr	r0, .L2360+24
	bl	printf
.L2297:
	b	.L2297
.L2296:
	ldr	r3, .L2360+48
	ldr	r3, [r3]
	add	r3, r3, r4, lsl #2
	ldrb	r8, [r3, #2]	@ zero_extendqisi2
	and	r8, r8, #224
	cmp	r8, #32
	beq	.L2298
	cmp	r8, #224
	beq	.L2298
	ldr	r3, .L2360+52
	cmp	r8, #0
	bne	.L2299
	lsls	r2, r4, #1
	str	r2, [sp, #20]
	ldr	r2, [r3]
	ldrh	r1, [r2, r4, lsl #1]
	cbz	r1, .L2300
	mov	r2, r4
	ldr	r0, .L2360+56
	str	r3, [sp, #20]
	bl	printf
	mov	r1, r8
	mov	r0, r4
	bl	ftl_sblk_dump
	ldr	r3, [sp, #20]
.L2300:
	ldr	r2, [r3]
	lsls	r3, r4, #1
	ldrh	r3, [r2, r3]
	cmp	r3, #0
	beq	.L2298
	movw	r2, #1047
	ldr	r1, .L2360+20
	ldr	r0, .L2360+24
	bl	printf
.L2301:
	b	.L2301
.L2299:
	ldr	r3, [r3]
	movw	r2, #65535
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, r2
	beq	.L2298
	ldr	r1, [sp, #16]
	cmp	r8, #160
	ite	ne
	movne	r2, #1
	moveq	r2, #2
	ands	r2, r2, r1
	cbnz	r7, .L2303
	cmp	r6, r3
	it	cs
	movcs	r6, r3
	cbz	r2, .L2298
	ldr	r2, .L2360+16
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L2298
	mov	r2, r7
	mov	r1, r7
	mov	r0, r4
	bl	gc_add_sblk
	cbz	r0, .L2298
.L2356:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L2305
.L2303:
	cbz	r2, .L2305
	cmp	r8, #160
	bne	.L2306
	ldr	r2, [sp, #8]
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	str	r2, [sp, #8]
	ldr	r2, .L2360+60
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L2305
.L2359:
	mov	r2, r7
	movs	r1, #0
	mov	r0, r4
	bl	gc_add_sblk
	cbz	r0, .L2305
	b	.L2356
.L2306:
	ldr	r2, .L2360+64
	cmp	r6, r3
	it	cs
	movcs	r6, r3
	ldrh	r2, [r2]
	cmp	r2, r3
	bls	.L2359
.L2305:
	ldr	r3, [sp, #12]
	cmp	r5, r3
	bhi	.L2304
.L2298:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	b	.L2357
.L2309:
	ldr	r3, .L2360+36
	ldrh	r1, [r3]
	ldr	r3, .L2360+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r3, r1, r3
	ldr	r1, [sp, #8]
	cmp	r1, r3
	ldr	r1, .L2360+60
	beq	.L2313
	ldrh	r0, [r1]
	ldr	r4, [sp, #8]
	cmp	r0, r4
	itt	cc
	ldrhcc	r0, [sp, #8]
	strhcc	r0, [r1]	@ movhi
.L2313:
	ldrh	r4, [r2]
	ldrh	r0, [r1]
	lsrs	r2, r4, #3
	subs	r3, r3, r2
	cmp	r0, r3
	itt	lt
	addlt	r0, r0, r2
	strhlt	r0, [r1]	@ movhi
	ldr	r1, .L2360+64
	ldrh	r3, [r1]
	cmp	r3, r4, lsr #1
	bls	.L2312
	subs	r3, r3, r2
	strh	r3, [r1]	@ movhi
	b	.L2312
.L2308:
	strh	r4, [r3, #126]	@ movhi
	cbnz	r7, .L2316
	ldrh	r1, [r2]
	ldr	r2, .L2360+16
	ldrh	r3, [r2]
	cmp	r3, r1, lsr #2
	bls	.L2312
	sub	r3, r3, r1, lsr #3
	strh	r3, [r2]	@ movhi
	b	.L2312
.L2316:
	ldr	r1, .L2360+60
	ldrh	r3, [r2]
	ldr	r0, .L2360+68
	ldrh	r2, [r1]
	ldrb	r0, [r0]	@ zero_extendqisi2
	cmp	r2, r3, lsr #1
	it	hi
	subhi	r2, r2, r3, lsr #3
	mul	r3, r3, r0
	it	hi
	strhhi	r2, [r1]	@ movhi
	ldr	r1, .L2360+64
	subs	r3, r3, #32
	ldrh	r2, [r1]
	cmp	r2, r3
	itt	lt
	addlt	r2, r2, #32
	strhlt	r2, [r1]	@ movhi
	b	.L2312
.L2361:
	.align	2
.L2360:
	.word	.LANCHOR60
	.word	.LANCHOR46
	.word	.LANCHOR22
	.word	.LC111
	.word	.LANCHOR58
	.word	.LANCHOR156
	.word	.LC0
	.word	.LANCHOR69
	.word	.LANCHOR79
	.word	.LANCHOR68
	.word	.LANCHOR54
	.word	.LC113
	.word	.LANCHOR57
	.word	.LANCHOR56
	.word	.LC112
	.word	.LANCHOR106
	.word	.LANCHOR105
	.word	.LANCHOR70
	.size	gc_search_src_blk, .-gc_search_src_blk
	.section	.text.ftl_read,"ax",%progbits
	.align	1
	.global	ftl_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read, %function
ftl_read:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	sub	sp, sp, #64
	mov	r7, r3
	cmp	r0, #0
	bne	.L2363
	ldr	r3, .L2395
	mov	r0, #24576
	ldr	r3, [r3]
.L2364:
	add	r2, r1, r10
	cmp	r3, r2
	bcc	.L2388
	ldr	r4, .L2395+4
	add	fp, r0, r1
	ldr	r5, .L2395+8
	mov	r0, fp
	ldr	r2, [r4]
	ldrb	r6, [r5]	@ zero_extendqisi2
	ldr	r3, [r2, #24]
	mov	r1, r6
	add	r3, r3, r10
	str	r3, [r2, #24]
	bl	__aeabi_uidiv
	add	r3, r10, fp
	str	r0, [sp, #28]
	mov	r1, r6
	subs	r0, r3, #1
	str	r3, [sp, #40]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #28]
	ldr	r6, [sp, #28]
	str	r0, [sp, #44]
	rsb	r3, r3, #1
	str	r5, [sp, #32]
	add	r3, r3, r0
	str	r4, [sp, #52]
	str	r3, [sp, #24]
	movs	r3, #0
	str	r3, [sp, #36]
.L2366:
	ldr	r3, [sp, #24]
	cbnz	r3, .L2386
	ldr	r0, [sp, #36]
.L2362:
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2363:
	cmp	r0, #3
	bhi	.L2388
	lsls	r0, r0, #13
	mov	r3, #8192
	b	.L2364
.L2386:
	ldr	r3, [sp, #32]
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #28]
	cmp	r6, r3
	uxth	r5, r1
	bne	.L2367
	mov	r0, fp
	bl	__aeabi_uidivmod
	uxth	r8, r1
	sub	r5, r5, r8
	uxth	r5, r5
	cmp	r10, r5
	bcs	.L2368
	uxth	r5, r10
.L2368:
	ldr	r2, .L2395+12
	movs	r3, #0
.L2371:
	ldr	r1, [r2, #20]
	cmp	r6, r1
	bne	.L2369
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r1, r1, #28
	bpl	.L2369
	ldr	r1, .L2395+12
	movs	r2, #48
	lsls	r5, r5, #9
	mov	r0, r7
	add	r7, r7, r5
	mla	r3, r2, r3, r1
	mov	r2, r5
	ldr	r1, [r3, #4]
	add	r1, r1, r8, lsl #9
	bl	ftl_memcpy
.L2370:
	ldr	r3, [sp, #24]
	adds	r6, r6, #1
	subs	r3, r3, #1
	str	r3, [sp, #24]
	b	.L2366
.L2367:
	ldr	r3, [sp, #44]
	mov	r8, #0
	cmp	r6, r3
	ittt	eq
	addeq	r5, fp, r10
	mlseq	r1, r6, r1, r5
	uxtbeq	r5, r1
	b	.L2368
.L2369:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L2371
	mov	r0, r6
	bl	lpa_hash_get_ppa
	str	r0, [sp, #60]
	adds	r0, r0, #1
	bne	.L2372
	movs	r2, #0
	add	r1, sp, #60
	mov	r0, r6
	bl	pm_log2phys
.L2372:
	ldr	r3, [sp, #60]
	adds	r3, r3, #1
	bne	.L2373
	movs	r4, #0
.L2374:
	ldr	r3, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcs	.L2370
	mla	r3, r3, r6, r4
	cmp	fp, r3
	bhi	.L2375
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bls	.L2375
	mov	r0, r7
	add	r7, r7, #512
	mov	r2, #512
	movs	r1, #0
	bl	ftl_memset
.L2375:
	adds	r4, r4, #1
	b	.L2374
.L2373:
	movs	r0, #0
	bl	buf_alloc
	mov	r4, r0
	cbnz	r0, .L2377
	bl	ftl_read_ahead
	b	.L2366
.L2377:
	ldr	r3, [sp, #52]
	movs	r1, #1
	ldr	r2, [r3]
	ldr	r3, [r2, #40]
	adds	r3, r3, #1
	str	r3, [r2, #40]
	ldr	r3, [sp, #60]
	str	r3, [r0, #24]
	str	r3, [r0, #28]
	ldr	r3, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r5
	it	eq
	streq	r7, [r0, #8]
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r2, r3, #1
	str	r3, [sp, #20]
	beq	.L2390
	cmp	r3, #256
	bne	.L2380
	ldr	r3, .L2395+16
	movs	r1, #1
	ldr	r0, [sp, #60]
	ldrh	r2, [r3]
	rsb	r3, r2, #21
	lsl	r3, r1, r3
	lsrs	r0, r0, r2
	ldr	r2, .L2395+20
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r2, [r4, #20]
	str	r0, [sp, #48]
	ldr	r3, [r4, #24]
	ldrh	r1, [sp, #48]
	ldr	r0, .L2395+24
	bl	printf
	movs	r2, #0
	movs	r1, #1
	ldrh	r0, [sp, #48]
	bl	gc_add_sblk
.L2380:
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #4]
	cmp	r6, r2
	beq	.L2381
	ldr	r0, [r3, #12]
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	str	r0, [sp, #12]
	ldr	r0, [r3, #8]
	str	r2, [sp, #4]
	mov	r2, r6
	str	r0, [sp, #8]
	ldr	r3, [r3]
	ldr	r0, .L2395+28
	str	r3, [sp]
	ldr	r3, [sp, #60]
	bl	printf
	ldr	r3, .L2395+16
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [sp, #60]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L2395+20
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L2381:
	ldr	r3, [r4, #12]
	ldr	r3, [r3, #4]
	cmp	r6, r3
	bne	.L2382
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	bne	.L2383
.L2382:
	movw	r2, #911
	ldr	r1, .L2395+32
	ldr	r0, .L2395+36
	bl	printf
.L2384:
	b	.L2384
.L2390:
	ldr	r3, [sp, #20]
	str	r3, [sp, #36]
	b	.L2380
.L2383:
	ldr	r3, [r4, #8]
	cbnz	r3, .L2385
	ldr	r1, [r4, #4]
	lsls	r2, r5, #9
	mov	r0, r7
	add	r1, r1, r8, lsl #9
	bl	ftl_memcpy
.L2385:
	mov	r0, r4
	add	r7, r7, r5, lsl #9
	bl	buf_free
	b	.L2370
.L2388:
	mov	r0, #-1
	b	.L2362
.L2396:
	.align	2
.L2395:
	.word	.LANCHOR52
	.word	.LANCHOR46
	.word	.LANCHOR45
	.word	.LANCHOR36
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LC114
	.word	.LC101
	.word	.LANCHOR157
	.word	.LC0
	.size	ftl_read, .-ftl_read
	.section	.text.FtlRead,"ax",%progbits
	.align	1
	.global	FtlRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlRead, %function
FtlRead:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	ftl_read
	.size	FtlRead, .-FtlRead
	.section	.text.StorageSysDataLoad,"ax",%progbits
	.align	1
	.global	StorageSysDataLoad
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r1
	mov	r5, r0
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	mov	r3, r4
	mov	r1, r5
	movs	r2, #1
	movs	r0, #2
	pop	{r4, r5, r6, lr}
	b	ftl_read
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.vpn_check,"ax",%progbits
	.align	1
	.global	vpn_check
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	vpn_check, %function
vpn_check:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
	ldr	r5, .L2430
	bl	dump_ftl_info
	ldr	r1, [r5]
	ldr	r0, .L2430+4
	ldr	r4, .L2430+8
	ldrh	r3, [r1, #80]
	ldrh	r2, [r1, #48]
	ldrh	r1, [r1, #16]
	bl	printf
	ldr	r3, [r5]
	ldr	r6, .L2430+12
	ldrh	r1, [r3, #16]
	ldrh	r2, [r3, #22]
	ldr	r3, [r4]
	ldrh	r3, [r3, r1, lsl #1]
	subs	r0, r3, r2
	str	r0, [sp]
	ldr	r0, .L2430+16
	bl	printf
	ldr	r3, [r5]
	movs	r5, #0
	ldrh	r1, [r3, #48]
	ldrh	r2, [r3, #54]
	ldr	r3, [r4]
	ldrh	r3, [r3, r1, lsl #1]
	subs	r0, r3, r2
	str	r0, [sp]
	ldr	r0, .L2430+20
	bl	printf
	mov	r2, #4352
	movs	r1, #0
	ldr	r0, .L2430+24
	bl	ftl_memset
.L2400:
	ldr	r3, .L2430+28
	ldr	r3, [r3]
	cmp	r5, r3
	bcc	.L2408
	ldr	r6, .L2430+12
	movs	r5, #0
	mov	r7, r6
.L2409:
	ldrh	r2, [r6]
	uxth	r3, r5
	cmp	r2, r3
	bhi	.L2411
	ldr	r8, .L2430+24
	movs	r6, #0
.L2412:
	ldrh	r2, [r7]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2417
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2408:
	mov	r0, r5
	bl	lpa_hash_get_ppa
	adds	r2, r0, #1
	str	r0, [sp, #12]
	bne	.L2401
	movs	r2, #0
	add	r1, sp, #12
	mov	r0, r5
	bl	pm_log2phys
.L2402:
	ldr	r7, [sp, #12]
	adds	r3, r7, #1
	beq	.L2404
	ldr	r3, .L2430+32
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, .L2430+36
	lsr	r0, r7, r0
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r3, [r6]
	uxth	r8, r0
	cmp	r3, r8
	mov	r3, r8
	bls	.L2405
	ldr	r1, .L2430+24
	ldrh	r2, [r1, r8, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r1, r8, lsl #1]	@ movhi
.L2406:
	ldrh	r3, [r6]
	cmp	r3, r8
	bhi	.L2404
	movw	r2, #1111
	ldr	r1, .L2430+40
	ldr	r0, .L2430+44
	bl	printf
.L2407:
	b	.L2407
.L2401:
	ldr	r3, .L2430+32
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r1, r2, #21
	lsls	r3, r3, r1
	lsrs	r0, r0, r2
	ldr	r2, .L2430+36
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r3, [r6]
	uxth	r0, r0
	cmp	r3, r0
	bhi	.L2402
	movw	r2, #1101
	ldr	r1, .L2430+40
	ldr	r0, .L2430+44
	bl	printf
.L2403:
	b	.L2403
.L2405:
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L2430+48
	bl	printf
	ldr	r3, .L2430+52
	movs	r2, #4
	ldr	r1, .L2430+56
	ldr	r0, .L2430+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r1, #4]
	lsls	r3, r3, #7
	bl	rknand_print_hex
	b	.L2406
.L2404:
	adds	r5, r5, #1
	b	.L2400
.L2411:
	ldr	r3, [r4]
	uxth	r1, r5
	ldr	r2, .L2430+24
	ldrh	r3, [r3, r1, lsl #1]
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r3, r2
	beq	.L2410
	ldr	r0, .L2430+64
	ldr	r0, [r0]
	add	r0, r0, r1, lsl #2
	ldrb	r0, [r0, #2]	@ zero_extendqisi2
	lsrs	r0, r0, #5
	str	r0, [sp]
	ldr	r0, .L2430+68
	bl	printf
.L2410:
	adds	r5, r5, #1
	b	.L2409
.L2417:
	ldr	r3, .L2430+64
	uxth	r5, r6
	ldr	r3, [r3]
	add	r3, r3, r5, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	tst	r3, #224
	bne	.L2413
	ldrh	r3, [r8, r5, lsl #1]
	cbnz	r3, .L2414
	ldr	r3, [r4]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2415
	mov	r1, r5
	ldr	r0, .L2430+72
	bl	printf
.L2415:
	ldr	r3, [r4]
	movs	r2, #0
	strh	r2, [r3, r5, lsl #1]	@ movhi
.L2414:
	ldr	r3, [r4]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2413
	ldrh	r3, [r8, r5, lsl #1]
	cbz	r3, .L2413
	movw	r2, #1143
	ldr	r1, .L2430+40
	ldr	r0, .L2430+44
	bl	printf
.L2416:
	b	.L2416
.L2413:
	adds	r6, r6, #1
	b	.L2412
.L2431:
	.align	2
.L2430:
	.word	.LANCHOR60
	.word	.LC115
	.word	.LANCHOR56
	.word	.LANCHOR54
	.word	.LC116
	.word	.LC117
	.word	check_vpc_tbl
	.word	.LANCHOR47
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR158
	.word	.LC0
	.word	.LC118
	.word	.LANCHOR45
	.word	.LANCHOR93
	.word	.LC119
	.word	.LANCHOR57
	.word	.LC120
	.word	.LC121
	.size	vpn_check, .-vpn_check
	.section	.text.ftl_info_check,"ax",%progbits
	.align	1
	.global	ftl_info_check
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_info_check, %function
ftl_info_check:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r3, .L2467
	mov	r8, r5
	mov	r10, r5
	mov	r6, r5
	ldr	fp, .L2467+44
	mov	r7, r5
	ldr	r2, [r3]
	str	r5, [sp, #4]
	str	r3, [sp, #8]
	ldrh	r4, [r2, #134]
.L2433:
	ldr	r2, .L2467+4
	ldrh	r2, [r2]
	cmp	r2, r4
	bhi	.L2448
	ldr	r3, [sp, #4]
	mov	r2, r6
	mov	r1, r7
	ldr	r0, .L2467+8
	bl	printf
	mov	r3, r5
	mov	r2, r8
	mov	r1, r10
	ldr	r0, .L2467+12
	bl	printf
	ldr	r3, [sp, #8]
	ldr	r1, [sp, #4]
	ldr	r3, [r3]
	ldrh	r2, [r3, #114]
	cmp	r2, r10
	ldrh	r2, [r3, #118]
	it	ne
	strhne	r10, [r3, #114]	@ movhi
	cmp	r2, r8
	ldrh	r2, [r3, #116]
	it	ne
	strhne	r8, [r3, #118]	@ movhi
	cmp	r2, r5
	ldrh	r2, [r3, #122]
	it	ne
	strhne	r5, [r3, #116]	@ movhi
	cmp	r2, r7
	ldrh	r2, [r3, #120]
	it	ne
	strhne	r7, [r3, #122]	@ movhi
	cmp	r2, r6
	ldrh	r2, [r3, #124]
	it	ne
	strhne	r6, [r3, #120]	@ movhi
	cmp	r2, r1
	itt	ne
	ldrhne	r2, [sp, #4]
	strhne	r2, [r3, #124]	@ movhi
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2448:
	ldr	r2, .L2467+16
	ldr	r3, [r2]
	add	r3, r3, r4, lsl #2
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	and	r1, r2, #224
	cmp	r1, #64
	bne	.L2434
	adds	r7, r7, #1
	uxth	r7, r7
.L2466:
	ldr	r2, [fp]
	ldrh	r1, [r2, r4, lsl #1]
	cmp	r1, #15
	bls	.L2440
	ldr	r2, .L2467+20
.L2463:
	ldrh	r0, [r2]
	ldr	r2, .L2467+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r0, r2
	cmp	r1, r2
	bne	.L2436
.L2440:
	movs	r2, #0
	movs	r1, #1
	mov	r0, r4
	bl	gc_add_sblk
.L2436:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2433
.L2434:
	cmp	r1, #96
	bne	.L2437
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	uxth	r3, r2
	str	r3, [sp, #4]
	b	.L2466
.L2437:
	cmp	r1, #160
	bne	.L2439
	ldr	r2, [fp]
	adds	r6, r6, #1
	uxth	r6, r6
	ldrh	r1, [r2, r4, lsl #1]
	cmp	r1, #15
	bls	.L2440
	ldr	r2, .L2467+28
	b	.L2463
.L2439:
	cmp	r1, #0
	bne	.L2436
	ands	r2, r2, #24
	bne	.L2441
	add	r10, r10, #1
	uxth	r10, r10
.L2442:
	lsls	r2, r4, #1
	str	r2, [sp, #12]
	ldr	r2, [fp]
	ldrh	r2, [r2, r4, lsl #1]
	cbz	r2, .L2444
	mov	r1, r4
	ldr	r0, .L2467+32
	str	r3, [sp, #12]
	bl	printf
	ldr	r3, [sp, #12]
	mov	r0, r4
	ldrb	r2, [r3, #2]	@ zero_extendqisi2
	lsls	r1, r2, #27
	ite	mi
	movmi	r1, #5
	movpl	r1, #2
	bfi	r2, r1, #5, #3
	movs	r1, #1
	strb	r2, [r3, #2]
	movs	r2, #0
	bl	gc_add_sblk
	bl	vpn_check
.L2444:
	ldr	r2, [fp]
	lsls	r3, r4, #1
	ldrh	r2, [r2, r3]
	cmp	r2, #0
	beq	.L2436
	movw	r2, #1202
	ldr	r1, .L2467+36
	ldr	r0, .L2467+40
	bl	printf
.L2447:
	b	.L2447
.L2441:
	cmp	r2, #16
	itete	eq
	addeq	r8, r8, #1
	addne	r5, r5, #1
	uxtheq	r8, r8
	uxthne	r5, r5
	b	.L2442
.L2468:
	.align	2
.L2467:
	.word	.LANCHOR46
	.word	.LANCHOR54
	.word	.LC123
	.word	.LC124
	.word	.LANCHOR57
	.word	.LANCHOR79
	.word	.LANCHOR69
	.word	.LANCHOR68
	.word	.LC122
	.word	.LANCHOR159
	.word	.LC0
	.word	.LANCHOR56
	.size	ftl_info_check, .-ftl_info_check
	.section	.text.gc_scan_src_blk,"ax",%progbits
	.align	1
	.global	gc_scan_src_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_scan_src_blk, %function
gc_scan_src_blk:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movw	r3, #65535
	ldr	r4, .L2511
	ldrh	r1, [r4]
	cmp	r1, r3
	bne	.L2470
	mov	r2, #880
	ldr	r1, .L2511+4
	ldr	r0, .L2511+8
	bl	printf
.L2471:
	b	.L2471
.L2470:
	ldr	r3, .L2511+12
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L2472
	ldr	r3, .L2511+16
	ldr	r0, .L2511+20
	ldr	r3, [r3]
	ldrh	r2, [r3, r1, lsl #1]
	bl	printf
.L2472:
	ldr	r1, .L2511+24
	ldrh	r0, [r4]
	bl	ftl_get_blk_list_in_sblk
	uxtb	r0, r0
	strb	r0, [r4, #5]
	cbnz	r0, .L2473
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
.L2469:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2473:
	ldr	r2, .L2511+28
	ldrh	r3, [r4]
	ldr	r2, [r2]
	add	r2, r2, r3, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r2, r2, #224
	cmp	r2, #32
	beq	.L2475
	cmp	r2, #224
	beq	.L2475
	cbz	r2, .L2476
	ldr	r1, .L2511+32
	ldr	r1, [r1]
	ldrh	r5, [r1, #16]
	cmp	r5, r3
	beq	.L2475
	ldrh	r5, [r1, #48]
	cmp	r5, r3
	beq	.L2475
	ldrh	r1, [r1, #80]
	cmp	r1, r3
	bne	.L2510
.L2475:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r4]	@ movhi
	strh	r0, [r4, #20]	@ movhi
	b	.L2469
.L2476:
	ldr	r2, .L2511+16
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cmp	r3, #0
	beq	.L2475
	mov	r2, #900
	ldr	r1, .L2511+4
	ldr	r0, .L2511+8
	bl	printf
.L2478:
	b	.L2478
.L2510:
	add	r0, r4, r0, lsl #1
	movw	r3, #65535
	ldrh	r7, [r0, #34]
	cmp	r7, r3
	bne	.L2479
	mov	r2, #908
	ldr	r1, .L2511+4
	ldr	r0, .L2511+8
	bl	printf
.L2480:
	b	.L2480
.L2479:
	ldr	r1, .L2511+36
	cmp	r2, #160
	ldr	r0, .L2511+40
	ldr	r8, .L2511+64
	ldrh	r3, [r1]
	mov	r10, r1
	ldrh	r0, [r0]
	add	r3, r3, #-1
	uxth	r3, r3
	mul	r7, r7, r0
	bne	.L2494
	ldr	r2, .L2511+44
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #2
	uxth	fp, r2
	orr	r7, r7, r2, lsl #24
	bne	.L2481
	ldrh	r3, [r8]
	mov	fp, #2
	subs	r3, r3, #1
	uxth	r3, r3
.L2481:
	orrs	r7, r7, r3
	strb	fp, [r4, #6]
	movs	r5, #0
	movs	r0, #1
	strh	r5, [r4, #2]	@ movhi
	strb	r5, [r4, #4]
	strh	r5, [r4, #22]	@ movhi
	bl	buf_alloc
	str	r7, [r0, #24]
	movs	r1, #1
	ldr	r7, .L2511+48
	mov	r6, r0
	bl	sblk_read_page
	ldrh	r3, [r8]
	movs	r1, #255
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r8, .L2511+68
	muls	r2, r3, r2
	ldr	r0, [r8]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, [r6, #36]
	strh	r5, [r4, #20]	@ movhi
	adds	r2, r3, #1
	bne	.L2482
.L2483:
	mov	r0, #-1
	b	.L2469
.L2494:
	mov	fp, #1
	b	.L2481
.L2482:
	cmp	r3, #512
	beq	.L2483
	ldr	r2, [r6, #12]
	ldr	r3, .L2511+52
	ldr	r2, [r2]
	str	r3, [sp, #4]
	cmp	r2, r3
	beq	.L2484
	mov	r1, r5
	ldrh	r0, [r4]
	bl	ftl_sblk_dump
	ldr	r2, [r6, #12]
	ldr	r3, [sp, #4]
	ldr	r2, [r2]
	cmp	r2, r3
	beq	.L2483
	movw	r2, #937
	ldr	r1, .L2511+4
	ldr	r0, .L2511+8
	bl	printf
.L2485:
	b	.L2485
.L2484:
	ldrb	r3, [r7]	@ zero_extendqisi2
	ldrh	r2, [r10]
	ldr	r7, [r6, #4]
	ldr	r10, .L2511+72
	smulbb	r3, r3, r2
	subs	r7, r7, #4
	smulbb	fp, r3, fp
	uxth	fp, fp
.L2486:
	cmp	r5, fp
	blt	.L2491
	ldr	r5, .L2511+16
	mov	r0, r6
	bl	buf_free
	ldrh	r1, [r4]
	ldr	r3, [r5]
	ldrh	r2, [r3, r1, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	beq	.L2492
	ldr	r0, .L2511+56
	bl	printf
.L2492:
	ldr	r3, [r5]
	ldrh	r2, [r4]
	ldrh	r2, [r3, r2, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	bcs	.L2493
	bl	vpn_check
.L2493:
	ldr	r3, [r5]
	ldrh	r1, [r4, #20]
	ldrh	r2, [r4]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #24]	@ movhi
	ldrh	r0, [r4, #20]
	b	.L2469
.L2491:
	ldr	r0, [r7, #4]!
	adds	r3, r0, #1
	beq	.L2488
	bl	lpa_hash_get_ppa
	str	r0, [sp, #12]
	adds	r0, r0, #1
	bne	.L2489
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r7]
	bl	pm_log2phys
.L2489:
	ldr	r2, [sp, #12]
	movs	r3, #1
	ldrh	r0, [r10]
	str	r2, [sp, #4]
	rsb	r1, r0, #21
	lsls	r3, r3, r1
	lsr	r0, r2, r0
	ldr	r2, .L2511+60
	subs	r3, r3, #1
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldrh	r3, [r4]
	ldr	r2, [sp, #4]
	cmp	r0, r3
	bne	.L2488
	ldrh	r3, [r4, #20]
	ldr	r1, [r8]
	str	r2, [r1, r3, lsl #2]
	adds	r3, r3, #1
	strh	r3, [r4, #20]	@ movhi
.L2488:
	adds	r5, r5, #1
	b	.L2486
.L2512:
	.align	2
.L2511:
	.word	.LANCHOR59
	.word	.LANCHOR160
	.word	.LC0
	.word	.LANCHOR22
	.word	.LANCHOR56
	.word	.LC125
	.word	.LANCHOR59+36
	.word	.LANCHOR57
	.word	.LANCHOR60
	.word	.LANCHOR79
	.word	.LANCHOR75
	.word	.LANCHOR64
	.word	.LANCHOR69
	.word	-178307901
	.word	.LC126
	.word	.LANCHOR70
	.word	.LANCHOR68
	.word	.LANCHOR61
	.word	.LANCHOR71
	.size	gc_scan_src_blk, .-gc_scan_src_blk
	.section	.text.ftl_scan_all_data,"ax",%progbits
	.align	1
	.global	ftl_scan_all_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r0, #0
	ldr	r8, .L2542+20
	sub	sp, sp, #40
	movs	r5, #0
	bl	buf_alloc
	movs	r1, #0
	mov	r4, r0
	ldr	r0, .L2542
	bl	printf
.L2514:
	ldr	r3, [r8]
	cmp	r5, r3
	bcc	.L2527
	mov	r0, r4
	bl	buf_free
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2527:
	mov	r3, #-1
	str	r3, [r4, #20]
	ubfx	r3, r5, #0, #12
	cbnz	r3, .L2515
	ldr	r2, [sp, #36]
	mov	r1, r5
	ldr	r0, .L2542+4
	bl	printf
.L2515:
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #36]
	adds	r0, r0, #1
	bne	.L2516
	movs	r2, #0
	add	r1, sp, #36
	mov	r0, r5
	bl	pm_log2phys
.L2516:
	ldr	r3, [sp, #36]
	str	r3, [r4, #24]
	str	r3, [r4, #28]
	adds	r3, r3, #1
	bne	.L2517
.L2519:
	adds	r5, r5, #1
	b	.L2514
.L2517:
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	ldr	r2, [r4, #12]
	cmp	r3, #256
	beq	.L2518
	adds	r0, r3, #1
	beq	.L2518
	ldr	r1, [r2, #4]
	cmp	r5, r1
	beq	.L2519
.L2518:
	ldr	r1, [r4, #4]
	ldr	r10, .L2542+24
	ldr	r7, .L2542+8
	ldr	r0, [r1, #4]
	str	r0, [sp, #20]
	ldr	r1, [r1]
	ldr	r0, .L2542+12
	str	r1, [sp, #16]
	ldr	r1, [r2, #12]
	str	r1, [sp, #12]
	ldr	r1, [r2, #8]
	str	r1, [sp, #8]
	ldr	r1, [r2, #4]
	str	r1, [sp, #4]
	mov	r1, r5
	ldr	r2, [r2]
	str	r2, [sp]
	ldr	r2, [r4, #24]
	bl	printf
	ldr	r2, [r4, #12]
	ldr	r3, [r2, #8]
	adds	r1, r3, #1
	bne	.L2520
.L2522:
	ldrb	r6, [r10]	@ zero_extendqisi2
	mov	r0, r5
	ldr	fp, .L2542+28
	lsls	r1, r6, #7
	bl	__aeabi_idiv
	uxth	r10, r0
	mov	r0, r5
	bl	lpa_hash_get_ppa
	lsls	r3, r6, #7
	str	r0, [sp]
	mov	r2, r10
	ldr	r0, .L2542+16
	subs	r3, r3, #1
	mov	r1, r5
	ands	r3, r3, r5
	movs	r6, #0
	uxth	r3, r3
	bl	printf
	movs	r2, #0
	add	r1, sp, #36
	mov	r0, r5
	bl	pm_log2phys
.L2521:
	adds	r3, r7, r6
	ldr	r1, [r3, #4]
	cbz	r1, .L2526
	ldrh	r3, [r7, r6]
	cmp	r3, r10
	bne	.L2526
	mov	r3, #4096
	movs	r2, #4
	mov	r0, fp
	bl	rknand_print_hex
.L2526:
	adds	r6, r6, #8
	cmp	r6, #256
	bne	.L2521
	b	.L2519
.L2520:
	ldr	r6, [r2, #4]
	ldr	r2, .L2542+20
	ldr	r2, [r2]
	cmp	r6, r2
	bcs	.L2522
	str	r3, [r4, #24]
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r2, [r4, #4]
	ldr	r3, [r4, #12]
	ldr	r0, .L2542+12
	ldr	r1, [r2, #4]
	str	r1, [sp, #20]
	mov	r1, r5
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, [r3, #12]
	str	r2, [sp, #12]
	ldr	r2, [r3, #8]
	str	r2, [sp, #8]
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldr	r3, [r4, #36]
	ldr	r2, [r4, #24]
	bl	printf
	mov	r0, r6
	bl	lpa_hash_get_ppa
	str	r0, [sp, #36]
	adds	r0, r0, #1
	bne	.L2523
	movs	r2, #0
	add	r1, sp, #36
	mov	r0, r6
	bl	pm_log2phys
.L2523:
	ldr	r3, [sp, #36]
	movs	r1, #1
	mov	r0, r4
	str	r3, [r4, #24]
	bl	sblk_read_page
	ldr	r2, [r4, #4]
	ldr	r3, [r4, #12]
	ldr	r0, .L2542+12
	ldr	r1, [r2, #4]
	str	r1, [sp, #20]
	mov	r1, r6
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, [r3, #12]
	str	r2, [sp, #12]
	ldr	r2, [r3, #8]
	str	r2, [sp, #8]
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldr	r2, [r4, #24]
	ldr	r3, [r4, #36]
	bl	printf
	ldrb	fp, [r10]	@ zero_extendqisi2
	mov	r0, r6
	lsl	r1, fp, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r0, [sp, #28]
	mov	r0, r6
	str	r3, [sp, #24]
	bl	lpa_hash_get_ppa
	lsl	r3, fp, #7
	ldr	r2, [sp, #28]
	ldr	fp, .L2542+32
	mov	r1, r6
	subs	r3, r3, #1
	str	r0, [sp]
	ands	r3, r3, r6
	ldr	r0, .L2542+16
	uxth	r3, r3
	uxth	r2, r2
	bl	printf
	mov	r0, r6
	movs	r6, #0
	movs	r2, #0
	add	r1, sp, #36
	bl	pm_log2phys
.L2525:
	adds	r3, r7, r6
	ldr	r1, [r3, #4]
	cbz	r1, .L2524
	ldrh	r3, [r7, r6]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bne	.L2524
	mov	r3, #4096
	movs	r2, #4
	mov	r0, fp
	bl	rknand_print_hex
.L2524:
	adds	r6, r6, #8
	cmp	r6, #256
	bne	.L2525
	b	.L2522
.L2543:
	.align	2
.L2542:
	.word	.LC127
	.word	.LC128
	.word	.LANCHOR93
	.word	.LC129
	.word	.LC130
	.word	.LANCHOR47
	.word	.LANCHOR45
	.word	.LC132
	.word	.LC131
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.gc_recovery,"ax",%progbits
	.align	1
	.global	gc_recovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_recovery, %function
gc_recovery:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r3, .L2603
	sub	sp, sp, #64
	ldr	r7, .L2603+4
	strb	r4, [r3]
	ldr	r3, .L2603+8
	ldr	r5, [r7]
	strb	r4, [r3]
	bl	gc_init
	ldrh	r6, [r5, #80]
	movw	r3, #65535
	cmp	r6, r3
	beq	.L2545
	ldr	r2, [r7]
	movs	r0, #1
	ldr	r6, .L2603+12
	strh	r3, [r2, #130]	@ movhi
	bl	buf_alloc
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	mov	r4, r0
	add	r3, r5, r3, lsl #1
	ldrh	r2, [r3, #94]
	ldr	r3, .L2603+16
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldrb	r2, [r6]	@ zero_extendqisi2
	cmp	r2, #3
	str	r3, [sp, #56]
	bne	.L2546
	ldr	r2, .L2603+20
	ldrh	r2, [r2]
	subs	r2, r2, #1
	add	r3, r3, r2
	orr	r3, r3, #50331648
.L2598:
	str	r3, [r4, #24]
.L2547:
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r2, r3, #1
	beq	.L2548
	cmp	r3, #512
	beq	.L2548
	ldr	r3, [r4, #12]
	ldr	r2, [r3]
	ldr	r3, .L2603+24
	cmp	r2, r3
	beq	.L2549
.L2548:
	mov	r0, r4
	bl	buf_free
	ldr	r2, [r4, #12]
	ldr	r3, [r4, #4]
	ldr	r0, .L2603+28
	ldr	r1, [r2, #12]
	str	r1, [sp, #24]
	ldr	r1, [r2, #8]
	str	r1, [sp, #20]
	ldr	r1, [r2, #4]
	str	r1, [sp, #16]
	ldr	r2, [r2]
	str	r2, [sp, #12]
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	ldr	r2, [r3, #8]
	str	r2, [sp, #4]
	ldr	r2, [r3, #4]
	str	r2, [sp]
	ldr	r2, [r4, #36]
	ldr	r3, [r3]
	ldr	r1, [r4, #24]
	movs	r4, #0
	bl	printf
	ldr	r3, .L2603+32
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldr	r3, [r7]
.L2602:
	ldrh	r2, [r5, #80]
	strh	r2, [r3, #130]	@ movhi
.L2550:
	mov	r2, r4
	ldrh	r1, [r5, #80]
	movw	r4, #65535
	ldr	r0, .L2603+36
	bl	printf
	strh	r4, [r5, #80]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, .L2603+4
	ldr	r2, [r3]
	ldrh	r0, [r2, #130]
	cmp	r0, r4
	mov	r4, r3
	beq	.L2579
	bl	ftl_free_sblk
.L2579:
	ldr	r3, .L2603+40
	movs	r0, #0
	ldr	r2, [r3]
	movw	r3, #65535
	strh	r3, [r2, #126]	@ movhi
	ldr	r2, [r4]
	strh	r3, [r2, #130]	@ movhi
	bl	ftl_info_flush
.L2544:
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2546:
	cmp	r2, #2
	bne	.L2547
	ldr	r2, .L2603+20
	ldrh	r2, [r2]
	add	r3, r3, r2, lsl #1
	subs	r3, r3, #1
	orr	r3, r3, #33554432
	b	.L2598
.L2549:
	ldr	r8, .L2603+68
	ldr	r7, .L2603+44
	ldr	fp, .L2603+56
	ldrh	r3, [r8]
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r1, [r4, #4]
	ldr	r0, [fp]
	ldr	r10, .L2603+60
	muls	r2, r3, r2
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldrh	r3, [r8]
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r1, [r4, #4]
	ldr	r0, [r10]
	muls	r2, r3, r2
	lsls	r2, r2, #2
	add	r1, r1, r2
	bl	ftl_memcpy
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldrh	r3, [r8]
	ldr	r1, [fp]
	ldr	r0, .L2603+48
	muls	r3, r2, r3
	movs	r2, #4
	bl	rknand_print_hex
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldrh	r3, [r8]
	ldr	r1, [r10]
	ldr	r0, .L2603+52
	muls	r3, r2, r3
	movs	r2, #4
	bl	rknand_print_hex
	ldr	r3, .L2603+20
	ldrh	fp, [r3]
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #2
	itt	eq
	moveq	r3, #1
	lsleq	fp, fp, #1
	str	r3, [sp, #44]
	movs	r3, #0
	mov	r10, r3
	str	r3, [sp, #36]
.L2553:
	ldr	r3, [sp, #36]
	cmp	r3, fp
	beq	.L2562
	mov	r8, #0
	b	.L2563
.L2559:
	ldr	r3, [sp, #40]
	ldrh	r2, [r3, #96]
	ldr	r3, .L2603+16
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L2603+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r3, [sp, #56]
	cmp	r2, #3
	bne	.L2554
	ldr	r2, [sp, #36]
	add	r3, r3, r2
	orr	r3, r3, r7, lsl #24
.L2600:
	str	r3, [r4, #24]
	movs	r1, #1
	mov	r0, r4
	bl	sblk_read_page
	ldr	r3, .L2603+56
	ldr	r2, [r4, #12]
	ldr	r3, [r3]
	ldr	r1, [r2, #4]
	ldr	r3, [r3, r6]
	cmp	r3, r1
	bne	.L2557
	ldr	r0, .L2603+60
	ldr	r0, [r0]
	ldr	ip, [r0, r6]
	ldr	r0, [r2, #8]
	cmp	ip, r0
	beq	.L2558
.L2557:
	ldr	r0, [r2, #12]
	str	r0, [sp, #16]
	ldr	r0, [r2, #8]
	str	r1, [sp, #8]
	str	r0, [sp, #12]
	ldr	r2, [r2]
	ldr	r0, .L2603+64
	str	r2, [sp, #4]
	ldr	r2, .L2603+60
	ldr	r2, [r2]
	ldr	r2, [r2, r6]
	str	r2, [sp]
	ldr	r2, [r4, #36]
	ldr	r1, [r4, #24]
	bl	printf
	ldr	r3, .L2603+56
	ldr	r3, [r3]
	ldr	r3, [r3, r6]
	adds	r3, r3, #1
	beq	.L2558
	mov	r0, r4
	movs	r4, #0
	bl	buf_free
	ldr	r3, .L2603+32
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2603+4
	ldr	r3, [r3]
	b	.L2602
.L2554:
	cmp	r2, #2
	ldr	r2, [sp, #36]
	itett	eq
	addeq	r2, r2, #-1
	addne	r3, r3, r2
	addeq	r3, r3, r2
	addeq	r3, r3, r7
	it	eq
	orreq	r3, r3, #33554432
	b	.L2600
.L2558:
	add	r10, r10, #1
	adds	r7, r7, #1
	adds	r6, r6, #4
.L2561:
	ldr	r3, [sp, #44]
	cmp	r3, r7
	bcs	.L2559
	add	r8, r8, #1
.L2563:
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	cmp	r8, r3
	bge	.L2560
	add	r3, r5, r8, lsl #1
	lsl	r6, r10, #2
	str	r3, [sp, #40]
	movs	r7, #1
	b	.L2561
.L2560:
	ldr	r3, [sp, #36]
	adds	r3, r3, #1
	str	r3, [sp, #36]
	b	.L2553
.L2562:
	mov	r0, r4
	movs	r4, #0
	bl	buf_free
	ldr	r3, .L2603+32
	mov	r6, r4
	ldr	r0, .L2603+68
	ldrh	r1, [r5, #80]
	ldr	r2, [r3]
	ldrh	r0, [r0]
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	str	r4, [sp, #40]
	smulbb	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
.L2564:
	ldr	r3, [sp, #36]
	cmp	r3, r6
	beq	.L2577
	mov	fp, #0
	b	.L2578
.L2604:
	.align	2
.L2603:
	.word	.LANCHOR67
	.word	.LANCHOR60
	.word	.LANCHOR104
	.word	.LANCHOR64
	.word	.LANCHOR75
	.word	.LANCHOR79
	.word	-178307901
	.word	.LC133
	.word	.LANCHOR56
	.word	.LC138
	.word	.LANCHOR46
	.word	.LANCHOR69
	.word	.LC134
	.word	.LC135
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LC136
	.word	.LANCHOR68
.L2574:
	ldr	r3, .L2605
	ldr	r2, [sp, #40]
	ldr	r3, [r3]
	ldr	r10, [r3, r2, lsl #2]
	cmp	r10, #-1
	beq	.L2565
	ldr	r3, .L2605+4
	mov	r0, r10
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	str	r3, [sp, #48]
	bl	lpa_hash_get_ppa
	str	r0, [sp, #60]
	adds	r0, r0, #1
	bne	.L2566
	movs	r2, #0
	add	r1, sp, #60
	mov	r0, r10
	bl	pm_log2phys
.L2566:
	ldr	r3, [sp, #52]
	ldrh	r2, [r3, #96]
	ldr	r3, .L2605+8
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L2605+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, #3
	bne	.L2567
	add	r3, r3, r6
	orr	r3, r3, r8, lsl #24
.L2601:
	str	r3, [sp, #56]
	movs	r2, #1
	ldr	r3, .L2605+16
	ldrh	r0, [r3]
	rsb	r3, r0, #21
	lsl	r3, r2, r3
	ldr	r2, [sp, #48]
	subs	r3, r3, #1
	lsr	r0, r2, r0
	ldr	r2, .L2605+20
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	ldr	r2, [sp, #48]
	mov	r7, r0
	ldr	r3, [sp, #60]
	cmp	r2, r3
	ldr	r2, [sp, #56]
	bne	.L2570
	mov	r1, r10
	ldr	r0, .L2605+24
	bl	pm_ppa_update_check
	cbz	r0, .L2571
.L2597:
	b	.L2597
.L2567:
	cmp	r2, #2
	itett	eq
	addeq	r2, r6, #-1
	addne	r3, r3, r6
	addeq	r3, r3, r2
	addeq	r3, r3, r8
	it	eq
	orreq	r3, r3, #33554432
	b	.L2601
.L2571:
	movs	r2, #1
	add	r1, sp, #56
	mov	r0, r10
	adds	r4, r4, #1
	bl	pm_log2phys
	uxth	r0, r7
	bl	ftl_vpn_decrement
.L2573:
	ldr	r3, [sp, #40]
	uxth	r7, r7
	adds	r3, r3, #1
	str	r3, [sp, #40]
	ldr	r3, .L2605+28
	ldr	r3, [r3]
	add	r3, r3, r7, lsl #2
	ldrb	r3, [r3, #2]	@ zero_extendqisi2
	ands	r3, r3, #224
	bne	.L2565
	ldr	r2, .L2605+32
	ldr	r2, [r2]
	ldrh	r1, [r2, r7, lsl #1]
	cbz	r1, .L2565
	strh	r3, [r2, r7, lsl #1]	@ movhi
.L2565:
	add	r8, r8, #1
.L2576:
	ldr	r3, [sp, #44]
	cmp	r3, r8
	bcs	.L2574
	add	fp, fp, #1
.L2578:
	ldrb	r3, [r5, #89]	@ zero_extendqisi2
	cmp	fp, r3
	bge	.L2575
	add	r3, r5, fp, lsl #1
	mov	r8, #1
	str	r3, [sp, #52]
	b	.L2576
.L2570:
	cmp	r3, r2
	it	eq
	addeq	r4, r4, #1
	b	.L2573
.L2575:
	adds	r6, r6, #1
	b	.L2564
.L2577:
	ldr	r3, .L2605+32
	ldrh	r2, [r5, #80]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	b	.L2550
.L2545:
	ldr	r3, [r7]
	ldrh	r3, [r3, #130]
	cmp	r3, r6
	beq	.L2544
	ldr	r5, .L2605+36
	ldr	r2, [r5]
	ldrh	r2, [r2, #126]
	cmp	r2, r3
	bne	.L2581
	bl	pm_flush
	ldr	r3, [r7]
	ldrh	r0, [r3, #130]
	bl	ftl_free_sblk
	ldr	r3, [r5]
	mov	r0, r4
	strh	r6, [r3, #126]	@ movhi
	bl	ftl_info_flush
.L2581:
	ldr	r3, [r7]
	movw	r2, #65535
	strh	r2, [r3, #130]	@ movhi
	b	.L2544
.L2606:
	.align	2
.L2605:
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR75
	.word	.LANCHOR64
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LC137
	.word	.LANCHOR57
	.word	.LANCHOR56
	.word	.LANCHOR46
	.size	gc_recovery, .-gc_recovery
	.section	.text.ftl_init,"ax",%progbits
	.align	1
	.global	ftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_init, %function
ftl_init:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #255
	ldr	r2, .L2619
	movs	r5, #0
	ldr	r6, .L2619+4
	strb	r3, [r2]
	ldr	r2, .L2619+8
	ldr	r1, .L2619+12
	ldr	r0, .L2619+16
	strb	r5, [r2]
	ldr	r2, .L2619+20
	ldr	r8, .L2619+144
	ldr	r7, .L2619+24
	strb	r3, [r2]
	mov	r2, #-1
	ldr	r3, .L2619+28
	strb	r5, [r3]
	ldr	r3, .L2619+32
	str	r2, [r3]
	bl	printf
	ldrb	r1, [r6, #12]	@ zero_extendqisi2
	ldr	r3, .L2619+36
	ldrb	r2, [r6, #9]	@ zero_extendqisi2
	ldrh	r10, [r6, #10]
	strb	r1, [r3]
	ldr	r3, .L2619+40
	mov	r0, r10
	str	r2, [sp, #4]
	strb	r2, [r3]
	ldr	r3, .L2619+44
	strh	r10, [r3]	@ movhi
	bl	__aeabi_idiv
	ldr	r1, .L2619+48
	mov	r3, r0
	strh	r0, [r8]	@ movhi
	ldr	r0, .L2619+52
	ldrb	r4, [r1]	@ zero_extendqisi2
	ldr	r1, .L2619+56
	ldr	r2, [sp, #4]
	ldr	ip, .L2619+148
	strb	r4, [r1]
	ldrb	r1, [r6, #13]	@ zero_extendqisi2
	lsl	fp, r2, #9
	ldrh	r6, [r6, #14]
	str	ip, [sp, #4]
	strb	r1, [r0]
	uxth	fp, fp
	smulbb	r4, r4, r1
	ldr	r1, .L2619+60
	ldr	r0, .L2619+64
	strh	r6, [ip]	@ movhi
	ldrh	lr, [r1]
	uxtb	r4, r4
	ldr	r1, .L2619+68
	strb	r4, [r7]
	strh	fp, [r0]	@ movhi
	strh	lr, [r1]	@ movhi
	movs	r1, #1
	str	r0, [sp, #8]
.L2608:
	cmp	lr, r1
	uxth	r0, r5
	add	r5, r5, #1
	bcs	.L2609
	mul	r10, r10, r2
	subs	r1, r0, #1
	ldr	r0, .L2619+72
	mov	r5, #1892352
	muls	r5, r4, r5
	str	r3, [sp, #12]
	strh	r1, [r0]	@ movhi
	mul	r1, r6, r10
	lsrs	r0, r1, #21
	muls	r1, r4, r1
	muls	r5, r0, r5
	ldr	r0, .L2619+76
	str	r5, [r0]
	add	r5, r5, #24576
	ldr	r0, .L2619+80
	str	r1, [r0]
	mov	r0, r5
	ldr	r1, .L2619+84
	str	r5, [r1]
	mov	r1, r2
	bl	__aeabi_uidiv
	ldr	r2, .L2619+88
	mov	r1, fp
	str	r0, [r2]
	add	r2, fp, #-1
	add	r0, r2, r0, lsl #2
	ldr	fp, .L2619+152
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	strh	r0, [fp]	@ movhi
	uxth	r0, r0
	lsls	r0, r0, #4
	mul	r1, r4, r3
	bl	__aeabi_idiv
	ldr	r3, .L2619+92
	mul	r1, r4, r10
	strh	r0, [r3]	@ movhi
	mov	r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L2619+96
	adds	r0, r0, #2
	ldr	r2, .L2619+100
	ldr	r5, .L2619+104
	strh	r0, [r3]	@ movhi
	add	r3, r6, r6, lsl #1
	lsrs	r6, r6, #4
	asrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
	ldr	r3, .L2619+108
	strh	r6, [r3]	@ movhi
	bl	buf_init
	ldrh	r3, [r8]
	ldrb	r0, [r7]	@ zero_extendqisi2
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L2619+112
	ldrb	r1, [r7]	@ zero_extendqisi2
	ldr	r2, .L2619+116
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r3, .L2619+120
	muls	r0, r1, r0
	ldr	r1, .L2619+124
	str	r2, [r3]
	add	r3, r2, r0, lsl #3
	str	r3, [r1]
	ldr	r1, [sp, #4]
	ldrh	r1, [r1]
	lsrs	r1, r1, #1
	add	r1, r1, r0, lsl #1
	ldr	r0, .L2619+128
	add	r1, r2, r1, lsl #2
	str	r1, [r5]
	bl	printf
	ldrh	r2, [r8]
	ldrb	r4, [r7]	@ zero_extendqisi2
	ldr	r3, [sp, #4]
	ldr	r0, .L2619+132
	ldrh	r3, [r3]
	muls	r4, r2, r4
	ldrh	r2, [fp]
	add	r4, r3, r4, lsl #2
	lsls	r6, r3, #2
	ldr	r3, [sp, #8]
	add	r6, r6, r2, lsl #2
	lsls	r4, r4, #1
	add	r6, r6, #704
	add	r4, r4, #600
	ldrh	r3, [r3]
	mov	r2, r6
	mov	r1, r4
	bl	printf
	ldr	r3, [sp, #8]
	ldrh	r3, [r3]
	cmp	r4, r3
	bhi	.L2610
	cmp	r6, r3
	bls	.L2611
.L2610:
.L2618:
	b	.L2618
.L2609:
	lsls	r1, r1, #1
	b	.L2608
.L2611:
	bl	sblk_init
	bl	ftl_info_blk_init
	adds	r3, r0, #1
	beq	.L2607
	bl	ftl_ext_info_init
	movs	r0, #1
	ldr	r4, .L2619+136
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	r0, [r5]
	movs	r1, #0
	adds	r0, r0, #16
	bl	ftl_open_sblk_recovery
	ldr	r0, [r5]
	add	r1, r0, #16
	adds	r0, r0, #48
	bl	ftl_open_sblk_recovery
	ldr	r2, [r4]
	ldr	r0, [r5]
	ldr	r3, [r2, #8]
	adds	r0, r0, #16
	adds	r3, r3, #16
	str	r3, [r2, #8]
	bl	ftl_info_data_recovery
	ldr	r0, [r5]
	adds	r0, r0, #48
	bl	ftl_info_data_recovery
	ldr	r0, [r5]
	adds	r0, r0, #80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	ftl_info_check
	bl	pm_flush
	movs	r0, #1
	bl	ftl_total_vpn_update
	ldr	r3, .L2619+140
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2613
	ldr	r2, [r4]
	ldr	r3, [r2, #68]
	adds	r3, r3, #1
	str	r3, [r2, #68]
.L2613:
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	movs	r0, #0
.L2607:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2620:
	.align	2
.L2619:
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR43
	.word	.LC139
	.word	.LC32
	.word	.LANCHOR127
	.word	.LANCHOR69
	.word	.LANCHOR89
	.word	.LANCHOR49
	.word	.LANCHOR64
	.word	.LANCHOR45
	.word	.LANCHOR68
	.word	.LANCHOR8
	.word	.LANCHOR70
	.word	.LANCHOR76
	.word	.LANCHOR13
	.word	.LANCHOR149
	.word	.LANCHOR75
	.word	.LANCHOR71
	.word	.LANCHOR52
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR47
	.word	.LANCHOR101
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR60
	.word	.LANCHOR165
	.word	.LANCHOR83
	.word	ftl_ext_info_data_buffer
	.word	.LANCHOR82
	.word	.LANCHOR56
	.word	.LC140
	.word	.LC141
	.word	.LANCHOR46
	.word	.LANCHOR133
	.word	.LANCHOR79
	.word	.LANCHOR54
	.word	.LANCHOR137
	.size	ftl_init, .-ftl_init
	.section	.text.rk_ftl_init,"ax",%progbits
	.align	1
	.global	rk_ftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_init, %function
rk_ftl_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	bl	nand_flash_init
	mov	r4, r0
	cbnz	r0, .L2622
	bl	ftl_init
	mov	r4, r0
.L2622:
	mov	r1, r4
	ldr	r0, .L2623
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2624:
	.align	2
.L2623:
	.word	.LC142
	.size	rk_ftl_init, .-rk_ftl_init
	.global	__aeabi_idivmod
	.section	.text.ftl_update_l2p_map,"ax",%progbits
	.align	1
	.global	ftl_update_l2p_map
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_update_l2p_map, %function
ftl_update_l2p_map:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2650
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrb	r7, [r0, #9]	@ zero_extendqisi2
	mov	r6, r0
	ldrh	r3, [r3]
	ldr	r2, .L2650+4
	muls	r7, r3, r7
	ldr	r4, [r2]
	ldrh	r3, [r0, #12]
	str	r2, [sp, #4]
	add	r4, r4, r3, lsl #2
	add	r3, r7, #1073741824
	subs	r3, r3, #1
	ldr	r3, [r4, r3, lsl #2]
	adds	r3, r3, #1
	bne	.L2626
	movs	r5, #0
	subs	r4, r4, #4
	mov	r10, r5
.L2627:
	cmp	r10, r7
	bne	.L2635
	ldr	r3, .L2650+8
	ldr	r4, .L2650+12
	ldr	r3, [r3]
	tst	r3, #4096
	beq	.L2636
	ldrh	r1, [r6]
	mov	r2, r5
	ldr	r3, [r4]
	ldr	r0, .L2650+16
	ldrh	r3, [r3, r1, lsl #1]
	bl	printf
.L2636:
	ldrh	r2, [r6]
	ldr	r3, [r4]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2626:
	movw	r2, #882
	ldr	r1, .L2650+20
	ldr	r0, .L2650+24
	bl	printf
.L2628:
	b	.L2628
.L2635:
	ldr	r8, [r4, #4]!
	cmp	r8, #-1
	beq	.L2629
	ldr	r3, .L2650+28
	mov	r0, r8
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	uxth	r3, r0
	str	r3, [sp]
	ldr	r3, .L2650+8
	ldr	r3, [r3]
	lsls	r2, r3, #19
	bpl	.L2630
	mov	r3, r10
	mov	r2, r8
	ldr	r1, [sp]
	ldr	r0, .L2650+32
	bl	printf
.L2630:
	mov	r8, r4
	mov	fp, r10
.L2634:
	ldr	r0, [r8]
	adds	r3, r0, #1
	beq	.L2631
	ldr	r3, .L2650+28
	ldrb	r1, [r3]	@ zero_extendqisi2
	lsls	r1, r1, #7
	bl	__aeabi_uidiv
	ldr	r3, [sp]
	uxth	r0, r0
	cmp	r3, r0
	bne	.L2631
	ldrb	r3, [r6, #9]	@ zero_extendqisi2
	mov	r0, fp
	mov	r1, r3
	str	r3, [sp, #12]
	bl	__aeabi_idivmod
	ldr	r3, .L2650+36
	adds	r1, r1, #8
	ldrh	r0, [r6, r1, lsl #1]
	ldrh	r2, [r3]
	ldr	r3, [sp, #12]
	muls	r2, r0, r2
	mov	r1, r3
	mov	r0, fp
	str	r2, [sp, #8]
	bl	__aeabi_idiv
	ldr	r2, [sp, #8]
	add	r2, r2, r0
	ldr	r0, .L2650+40
	str	r2, [sp, #20]
	ldr	r1, [r8]
	bl	pm_ppa_update_check
	cbz	r0, .L2632
	ldr	r1, [sp, #4]
	mov	r3, r7
	movs	r2, #4
	ldr	r0, .L2650+44
	ldr	r1, [r1]
	bl	rknand_print_hex
.L2633:
	b	.L2633
.L2632:
	adds	r5, r5, #1
	movs	r2, #1
	uxth	r5, r5
	add	r1, sp, #20
	ldr	r0, [r8]
	bl	pm_log2phys
	mov	r3, #-1
	str	r3, [r8]
.L2631:
	add	fp, fp, #1
	add	r8, r8, #4
	cmp	r7, fp
	bne	.L2634
.L2629:
	add	r10, r10, #1
	b	.L2627
.L2651:
	.align	2
.L2650:
	.word	.LANCHOR79
	.word	.LANCHOR82
	.word	.LANCHOR22
	.word	.LANCHOR56
	.word	.LC146
	.word	.LANCHOR166
	.word	.LC0
	.word	.LANCHOR45
	.word	.LC143
	.word	.LANCHOR75
	.word	.LC144
	.word	.LC145
	.size	ftl_update_l2p_map, .-ftl_update_l2p_map
	.section	.text.ftl_alloc_new_data_sblk,"ax",%progbits
	.align	1
	.global	ftl_alloc_new_data_sblk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_alloc_new_data_sblk, %function
ftl_alloc_new_data_sblk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r0
	bl	ftl_update_l2p_map
	bl	pm_flush
	ldr	r3, .L2655
	mov	r0, r4
	ldr	r1, [r3]
	adds	r1, r1, #16
	cmp	r4, r1
	ite	eq
	moveq	r1, #2
	movne	r1, #3
	bl	ftl_open_sblk_init
	bl	ftl_ext_info_flush
	movs	r0, #0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	movs	r0, #0
	pop	{r4, pc}
.L2656:
	.align	2
.L2655:
	.word	.LANCHOR60
	.size	ftl_alloc_new_data_sblk, .-ftl_alloc_new_data_sblk
	.section	.text.ftl_write_commit,"ax",%progbits
	.align	1
	.global	ftl_write_commit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write_commit, %function
ftl_write_commit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r8, .L2717+24
.L2658:
	ldr	r0, .L2717
	ldrb	r2, [r0]	@ zero_extendqisi2
	cmp	r2, #0
	beq	.L2660
	ldr	r4, .L2717+4
	movs	r1, #48
	subs	r2, r2, #1
	strb	r2, [r0]
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r2, .L2717+8
	str	r3, [sp, #16]
	add	r3, r3, r3, lsl #1
	ldr	r2, [r2]
	add	r3, r8, r3, lsl #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #16]
	muls	r1, r3, r1
	add	r3, r8, r1
	ldrb	r1, [r8, r1]	@ zero_extendqisi2
	ldr	r7, [r3, #20]
	strb	r1, [r4]
	cmp	r7, r2
	bcc	.L2662
	ldr	r0, [sp, #20]
	bl	buf_free
	mov	r0, #-1
.L2657:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2662:
	ldr	r2, [r3, #12]
	ldr	fp, [r3, #4]
	ldrb	r4, [r3, #41]	@ zero_extendqisi2
	ldrb	r3, [r3, #40]	@ zero_extendqisi2
	str	r2, [sp, #8]
	str	r3, [sp, #12]
	ldr	r3, .L2717+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2664
	ldr	r3, .L2717+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	add	r3, r8, r3, lsl #4
.L2665:
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #255
	bne	.L2666
	ldr	r2, [r3, #20]
	cmp	r7, r2
	bne	.L2664
	ldr	r0, [r3, #4]
	lsls	r4, r4, #9
	ldr	r3, [sp, #12]
	add	r1, fp, r4
	add	r0, r0, r4
	lsls	r2, r3, #9
	bl	ftl_memcpy
	ldr	r0, [sp, #20]
	bl	buf_free
	b	.L2658
.L2666:
	add	r2, r2, r2, lsl #1
	add	r3, r8, r2, lsl #4
	b	.L2665
.L2664:
	mov	r0, r7
	bl	lpa_hash_get_ppa
	str	r0, [sp, #28]
	adds	r0, r0, #1
	bne	.L2668
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r7
	bl	pm_log2phys
.L2668:
	ldr	r3, .L2717+20
	ldr	r2, .L2717+24
	ldr	r0, [r3]
	movs	r3, #0
.L2671:
	ldr	r1, [r2, #20]
	cmp	r7, r1
	bne	.L2669
	ldrb	r1, [r2, #2]	@ zero_extendqisi2
	lsls	r5, r1, #28
	bpl	.L2669
	movs	r2, #48
	bic	r1, r1, #8
	mla	r3, r2, r3, r8
	strb	r1, [r3, #2]
	ldr	r5, [r3, #4]
	ldr	r3, [r3, #24]
	str	r3, [sp, #28]
.L2670:
	ldr	r6, .L2717+28
	ldr	r2, [sp, #12]
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r2, r3
	bcc	.L2672
	add	r6, r0, #16
.L2716:
	mov	r10, #0
.L2673:
	ldrh	r3, [r6, #6]
	cbnz	r3, .L2688
	bl	ftl_flush
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L2688:
	mov	r0, r6
	ldr	r5, .L2717+12
	bl	ftl_get_new_free_page
	ldr	r2, [sp, #16]
	movs	r3, #48
	ldr	r4, [sp, #8]
	muls	r3, r2, r3
	add	r2, r8, r3
	ldr	r1, [r2, #16]
	str	r7, [r4, #4]
	str	r10, [r4, #12]
	str	r1, [r4]
	ldr	r1, [sp, #28]
	str	r1, [r4, #8]
	str	r1, [r2, #28]
	movs	r1, #255
	strb	r1, [r8, r3]
	ldrb	r3, [r2, #2]	@ zero_extendqisi2
	ldrh	r1, [r6, #12]
	str	r0, [r2, #24]
	orr	r3, r3, #10
	ldr	r0, .L2717+16
	strb	r3, [r2, #2]
	ldrh	r3, [r6, #10]
	add	r3, r3, r1
	ldr	r1, [sp, #20]
	subs	r3, r3, #1
	strh	r3, [r2, #32]	@ movhi
	bl	buf_add_tail
	ldrb	r3, [r5]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r2, .L2717+32
	adds	r3, r3, #1
	uxtb	r3, r3
	str	r1, [r2]
	ldrh	r2, [r6, #6]
	cmp	r3, #2
	strb	r3, [r5]
	bhi	.L2689
	cmp	r2, #1
	bne	.L2661
.L2689:
	ldr	r7, .L2717+16
	mov	ip, #48
	ldrb	r1, [r6, #5]	@ zero_extendqisi2
	ldrb	r0, [r7]	@ zero_extendqisi2
	cmp	r1, #0
	mov	r1, #0
	ite	ne
	movne	r4, #2
	moveq	r4, #1
	cmp	r2, #1
	it	eq
	moveq	r4, r3
	mov	r2, r0
.L2693:
	cmp	r1, r4
	bne	.L2694
	uxtb	r1, r1
	add	r0, r0, r0, lsl #1
	strb	r2, [r7]
	subs	r3, r3, r1
	add	r0, r8, r0, lsl #4
	strb	r3, [r5]
	bl	sblk_prog_page
	ldrh	r3, [r6, #6]
	cmp	r3, #1
	bne	.L2661
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	r0, r6
	bl	ftl_write_last_log_page
	mov	r0, r6
	bl	ftl_alloc_new_data_sblk
.L2661:
	ldr	r3, .L2717
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2658
.L2660:
	bl	ftl_write_completed
	movs	r0, #0
	b	.L2657
.L2669:
	adds	r3, r3, #1
	adds	r2, r2, #48
	cmp	r3, #32
	bne	.L2671
	movs	r5, #0
	b	.L2670
.L2672:
	cbz	r5, .L2674
	cbz	r4, .L2675
	lsls	r2, r4, #9
	mov	r1, r5
	mov	r0, fp
	bl	ftl_memcpy
.L2675:
	ldr	r2, [sp, #12]
	ldr	r3, .L2717+20
	add	r4, r4, r2
	ldrb	r2, [r6]	@ zero_extendqisi2
	ldr	r3, [r3]
	cmp	r4, r2
	bcc	.L2676
	add	r6, r3, #16
	b	.L2716
.L2676:
	lsls	r0, r4, #9
	subs	r2, r2, r4
	lsls	r2, r2, #9
	add	r6, r3, #48
	adds	r1, r5, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L2716
.L2674:
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	beq	.L2677
	movs	r0, #1
	bl	buf_alloc
	ldr	r3, [sp, #28]
	mov	r5, r0
	str	r7, [r0, #20]
	movs	r1, #1
	str	r3, [r0, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #12]
	ldr	r2, [r3, #12]
	ldr	r3, [r3, #4]
	add	r10, r2, #1
	cmp	r7, r3
	ldr	r3, [r5, #36]
	bne	.L2678
	adds	r2, r3, #1
	bne	.L2679
.L2678:
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	ldr	r2, [sp, #28]
	str	r3, [sp]
	mov	r3, r7
	ldr	r0, .L2717+36
	bl	printf
	movs	r3, #4
	ldr	r1, [r5, #12]
	mov	r2, r3
	ldr	r0, .L2717+40
	bl	rknand_print_hex
	ldr	r3, .L2717+44
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [sp, #28]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L2717+48
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L2679:
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	cmp	r7, r3
	bne	.L2680
	ldr	r3, [r5, #36]
	adds	r3, r3, #1
	bne	.L2681
.L2680:
	movw	r2, #445
	ldr	r1, .L2717+52
	ldr	r0, .L2717+56
	bl	printf
.L2682:
	b	.L2682
.L2718:
	.align	2
.L2717:
	.word	.LANCHOR43
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR89
	.word	.LANCHOR127
	.word	.LANCHOR60
	.word	.LANCHOR36
	.word	.LANCHOR45
	.word	.LANCHOR168
	.word	.LC147
	.word	.LC96
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR167
	.word	.LC0
.L2681:
	cbz	r4, .L2683
	ldr	r3, [sp, #28]
	lsls	r2, r4, #9
	adds	r3, r3, #1
	beq	.L2684
	ldr	r1, [r5, #4]
	mov	r0, fp
	bl	ftl_memcpy
.L2683:
	ldr	r2, [sp, #12]
	ldr	r3, .L2719
	add	r4, r4, r2
	ldr	r2, .L2719+4
	ldr	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r6, r3, #48
	cmp	r4, r2
	bcc	.L2685
	add	r6, r3, #16
.L2686:
	cmp	r5, #0
	beq	.L2673
	ldrb	r3, [r5, #2]	@ zero_extendqisi2
	mov	r1, r5
	ldr	r0, .L2719+8
	bic	r3, r3, #8
	strb	r3, [r5, #2]
	bl	buf_remove_buf
	mov	r0, r5
	bl	buf_free
	b	.L2673
.L2685:
	ldr	r3, [sp, #28]
	subs	r2, r2, r4
	lsls	r2, r2, #9
	lsls	r0, r4, #9
	adds	r3, r3, #1
	beq	.L2687
	ldr	r1, [r5, #4]
	add	r1, r1, r0
	add	r0, r0, fp
	bl	ftl_memcpy
	b	.L2686
.L2687:
	movs	r1, #0
	add	r0, r0, fp
	bl	ftl_memset
	b	.L2686
.L2694:
	mul	r2, ip, r2
	adds	r1, r1, #1
	ldrb	r2, [r8, r2]	@ zero_extendqisi2
	b	.L2693
.L2695:
	lsls	r2, r4, #9
	mov	r10, r5
.L2684:
	movs	r1, #0
	mov	r0, fp
	bl	ftl_memset
	b	.L2683
.L2677:
	cmp	r4, #0
	bne	.L2695
	mov	r10, r4
	mov	r5, r4
	b	.L2683
.L2720:
	.align	2
.L2719:
	.word	.LANCHOR60
	.word	.LANCHOR45
	.word	.LANCHOR51
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.ftl_discard,"ax",%progbits
	.align	1
	.global	ftl_discard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_discard, %function
ftl_discard:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r2
	sub	sp, sp, #32
	mov	r10, r3
	cmp	r0, #0
	bne	.L2722
	ldr	r3, .L2773
	mov	fp, #24576
	ldr	r3, [r3]
.L2723:
	adds	r2, r1, r5
	cmp	r3, r2
	bcc	.L2744
	ldr	r3, .L2773+4
	add	fp, fp, r1
	ldr	r3, [r3]
	lsls	r3, r3, #19
	bpl	.L2725
	mov	r1, r0
	str	r10, [sp]
	mov	r3, r5
	mov	r2, fp
	ldr	r0, .L2773+8
	bl	printf
.L2725:
	ldr	r6, .L2773+12
	mov	r0, fp
	ldr	r7, .L2773+16
	ldr	r3, [r6]
	ldrb	r8, [r7]	@ zero_extendqisi2
	ldr	r2, [r3, #8]
	mov	r1, r8
	str	r2, [sp, #12]
	adds	r2, r2, #1
	str	r2, [r3, #8]
	bl	__aeabi_uidiv
	mov	r1, r8
	mov	r4, r0
	mov	r0, fp
	bl	__aeabi_uidivmod
	mov	fp, r1
	cmp	r1, #0
	beq	.L2726
	sub	r3, r8, r1
	cmp	r3, r5
	it	cs
	movcs	r3, r5
	cmp	r10, #1
	mov	r8, r3
	uxth	r3, r3
	str	r3, [sp, #16]
	bhi	.L2728
	mov	r0, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L2729
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r4
	bl	pm_log2phys
.L2729:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L2728
	movs	r0, #0
	bl	buf_alloc
	mov	r3, r0
	cbz	r0, .L2728
	ldr	r2, [sp, #12]
	movs	r1, #0
	str	r4, [r0, #20]
	strb	fp, [r0, #41]
	str	r3, [sp, #20]
	strb	r8, [r3, #40]
	str	r2, [r0, #16]
	ldr	r3, [sp, #16]
	ldr	r0, [r0, #4]
	lsls	r2, r3, #9
	add	r0, r0, fp, lsl #9
	bl	ftl_memset
	ldr	r3, [sp, #20]
	mov	r0, r3
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	r2, [r6]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L2728:
	ldr	r3, [sp, #16]
	adds	r4, r4, #1
	subs	r5, r5, r3
.L2726:
	cbz	r5, .L2731
	bl	ftl_flush
.L2731:
	ldr	fp, .L2773+32
	mov	r3, #-1
	str	r3, [sp, #28]
.L2732:
	ldrb	r3, [r7]	@ zero_extendqisi2
	cmp	r5, r3
	bcs	.L2737
	cmp	r10, #1
	bls	.L2738
.L2739:
	movs	r0, #0
.L2721:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2722:
	cmp	r0, #3
	bhi	.L2744
	lsl	fp, r0, #13
	mov	r3, #8192
	b	.L2723
.L2737:
	mov	r0, r4
	bl	lpa_hash_get_ppa
	add	r1, sp, #32
	movs	r2, #0
	str	r0, [r1, #-8]!
	adds	r0, r0, #1
	mov	r0, r4
	beq	.L2733
	bl	pm_log2phys
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L2735
	movs	r2, #1
	add	r1, sp, #28
	mov	r0, r4
	bl	pm_log2phys
.L2772:
	ldr	r2, [r6]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
.L2735:
	ldrb	r3, [r7]	@ zero_extendqisi2
	adds	r4, r4, #1
	subs	r5, r5, r3
	b	.L2732
.L2733:
	bl	pm_log2phys
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L2735
	add	r1, sp, #28
	movs	r2, #1
	mov	r0, r4
	bl	pm_log2phys
	ldr	r3, .L2773+20
	ldrb	r1, [fp]	@ zero_extendqisi2
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [sp, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	uxth	r0, r0
	bl	ftl_vpn_decrement
	b	.L2772
.L2738:
	cmp	r5, #0
	beq	.L2739
	mov	r0, r4
	bl	lpa_hash_get_ppa
	str	r0, [sp, #24]
	adds	r0, r0, #1
	bne	.L2740
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r4
	bl	pm_log2phys
.L2740:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	beq	.L2739
	movs	r0, #0
	bl	buf_alloc
	mov	r10, r0
	cmp	r0, #0
	beq	.L2739
	ldr	r3, [sp, #12]
	str	r4, [r0, #20]
	movs	r4, #0
	strb	r4, [r0, #41]
	str	r3, [r0, #16]
	ldrb	r3, [r7]	@ zero_extendqisi2
	strb	r5, [r0, #40]
	cmp	r5, r3
	bcc	.L2741
	mov	r2, #1048
	ldr	r1, .L2773+24
	ldr	r0, .L2773+28
	bl	printf
.L2742:
	b	.L2742
.L2741:
	lsls	r2, r5, #9
	mov	r1, r4
	ldr	r0, [r0, #4]
	bl	ftl_memset
	mov	r0, r10
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	r2, [r6]
	ldr	r3, [r2, #76]
	adds	r3, r3, #1
	str	r3, [r2, #76]
	b	.L2739
.L2744:
	mov	r0, #-1
	b	.L2721
.L2774:
	.align	2
.L2773:
	.word	.LANCHOR52
	.word	.LANCHOR22
	.word	.LC148
	.word	.LANCHOR46
	.word	.LANCHOR45
	.word	.LANCHOR71
	.word	.LANCHOR169
	.word	.LC0
	.word	.LANCHOR70
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlDiscard,"ax",%progbits
	.align	1
	.global	FtlDiscard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlDiscard, %function
FtlDiscard:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r3, #0
	mov	r2, r1
	mov	r1, r0
	mov	r0, r3
	b	ftl_discard
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.gc_do_copy_back,"ax",%progbits
	.align	1
	.global	gc_do_copy_back
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2877
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #72
	ldrb	r0, [r3]	@ zero_extendqisi2
	cmp	r0, #0
	bne	.L2777
	bl	buf_alloc
	mov	r4, r0
	cmp	r0, #0
	beq	.L2776
	ldr	r6, .L2877+4
	ldrh	r2, [r6, #22]
	mov	r0, r2
	bl	gc_get_src_ppa_from_index
	movs	r1, #1
	adds	r2, r2, #1
	str	r0, [r4, #24]
	mov	r7, r0
	mov	r0, r4
	strh	r2, [r6, #22]	@ movhi
	bl	sblk_read_page
	ldr	r3, [r4, #36]
	adds	r0, r3, #1
	beq	.L2779
	cmp	r3, #512
	bne	.L2780
.L2779:
	ldr	r3, .L2877+8
	ldrh	r0, [r3]
	movs	r3, #1
	rsb	r2, r0, #21
	lsls	r3, r3, r2
	ldr	r2, .L2877+12
	lsr	r0, r7, r0
	subs	r3, r3, #1
	ldrb	r1, [r2]	@ zero_extendqisi2
	ands	r0, r0, r3
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
.L2780:
	ldr	r3, [r4, #36]
	adds	r1, r3, #1
	beq	.L2781
	cmp	r3, #512
	bne	.L2782
.L2781:
	mov	r2, #556
	ldr	r1, .L2877+16
	ldr	r0, .L2877+20
	bl	printf
.L2783:
	b	.L2783
.L2782:
	ldr	r3, [r4, #12]
	ldr	r5, [r3, #4]
	mov	r0, r5
	bl	lpa_hash_get_ppa
	str	r0, [sp, #48]
	adds	r0, r0, #1
	bne	.L2784
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r5
	bl	pm_log2phys
.L2784:
	ldr	r8, [sp, #48]
	cmp	r7, r8
	bne	.L2785
	ldr	r0, .L2877+24
	movs	r3, #0
.L2788:
	adds	r2, r0, r3
	ldr	r1, [r2, #20]
	cmp	r5, r1
	bne	.L2786
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	lsls	r2, r2, #30
	bpl	.L2786
	mov	r0, r4
	bl	buf_free
	ldr	r3, .L2877+28
	ldr	r3, [r3]
	lsls	r1, r3, #23
	bpl	.L2776
	ldrh	r3, [r6, #22]
	mov	r2, r7
	mov	r1, r5
	ldr	r0, .L2877+32
	bl	printf
.L2776:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2786:
	adds	r3, r3, #48
	cmp	r3, #1536
	bne	.L2788
	movs	r3, #0
	str	r5, [r4, #20]
	strb	r3, [r4, #41]
	ldr	r3, .L2877+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #40]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	orr	r3, r3, #10
	strb	r3, [r4, #2]
	ldr	r3, [r4, #12]
	ldr	r3, [r3]
	str	r3, [r4, #16]
	ldr	r3, .L2877+28
	ldr	r3, [r3]
	lsls	r2, r3, #23
	bpl	.L2789
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L2877+40
	bl	printf
.L2789:
	mov	r0, r4
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	ldr	r3, .L2877+44
	ldr	r2, [r3]
	ldr	r3, [r2, #60]
	adds	r3, r3, #1
	str	r3, [r2, #60]
	ldrh	r3, [r6, #24]
	adds	r3, r3, #1
	strh	r3, [r6, #24]	@ movhi
	b	.L2776
.L2785:
	ldr	r3, .L2877+28
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2790
	mov	r0, r5
	bl	lpa_hash_get_ppa
	ldrh	r3, [r6, #22]
	mov	r2, r8
	str	r7, [sp]
	mov	r1, r5
	str	r3, [sp, #4]
	mov	r3, r0
	ldr	r0, .L2877+40
	bl	printf
.L2790:
	mov	r0, r4
	bl	buf_free
	b	.L2776
.L2777:
	ldr	r3, .L2877+48
	ldr	r5, .L2877+4
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L2877+52
	ldrb	r8, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #28]
	cmp	r8, #3
	ldrb	r7, [r3, #89]	@ zero_extendqisi2
	bne	.L2791
	ldr	r3, .L2877+56
	ldrh	r4, [r5, #310]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2792
	add	r1, r7, r7, lsl #1
	mov	r0, r4
	bl	__aeabi_idiv
	uxth	r10, r0
	sub	r0, r7, r7, lsl #2
	str	r8, [sp, #32]
	smulbb	r0, r0, r10
	add	r0, r0, r4
	uxth	fp, r0
.L2793:
	ldr	r3, [sp, #32]
	muls	r3, r7, r3
	str	r3, [sp, #36]
	ldr	r3, .L2877+60
	ldrh	r1, [r3]
	ldr	r3, .L2877+64
	ldr	r8, [r3]
	muls	r1, r7, r1
	ldrh	r3, [r5, #20]
	movs	r7, #0
	str	r3, [sp, #40]
	subs	r1, r1, #1
	ldr	r3, .L2877+4
.L2796:
	ldr	r0, [sp, #36]
	uxth	r2, r7
	cmp	r2, r0
	blt	.L2798
.L2829:
	movs	r6, #1
	b	.L2794
.L2792:
	mov	r0, r4
	mov	r1, r7
	bl	__aeabi_idiv
	ldr	r3, .L2877+68
	str	r8, [sp, #32]
	ldrh	r6, [r3, r0, lsl #1]
	smulbb	r0, r0, r7
	subs	r0, r4, r0
	lsr	r10, r6, #3
	uxth	fp, r0
	mla	r4, r7, r10, fp
	and	r6, r6, #7
	cmp	r6, #1
	add	r4, r4, r4, lsl #1
	uxth	r4, r4
	beq	.L2793
.L2794:
	ldr	r3, .L2877+28
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L2799
	ldr	r3, .L2877+64
	mov	r2, r6
	str	r4, [sp, #8]
	mov	r1, r10
	ldr	r0, .L2877+72
	ldr	r3, [r3]
	ldr	r3, [r3, r4, lsl #2]
	str	r3, [sp, #4]
	ldrh	r3, [r5, #310]
	str	r3, [sp]
	mov	r3, fp
	bl	printf
.L2799:
	movs	r3, #0
.L2875:
	str	r3, [sp, #40]
	ldrh	r3, [sp, #40]
	mov	r8, r3
	str	r3, [sp, #36]
	ldr	r3, [sp, #28]
	ldrb	r2, [r3, #89]	@ zero_extendqisi2
	ldr	r3, [sp, #32]
	muls	r3, r2, r3
	cmp	r8, r3
	blt	.L2816
	ldr	r1, .L2877+52
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #3
	beq	.L2817
	movs	r0, #0
	subs	r3, r3, #1
.L2818:
	uxth	r1, r0
	adds	r0, r0, #1
	cmp	r1, r3
	blt	.L2824
	add	r1, sp, #72
	add	r3, r1, r3, lsl #2
	movs	r1, #255
	ldr	r3, [r3, #-24]
	strb	r1, [r3]
	ldrh	r3, [sp, #32]
	ldr	r0, [sp, #48]
	smulbb	r1, r3, r2
	uxtb	r1, r1
	bl	sblk_prog_page
	b	.L2823
.L2791:
	ldr	r3, .L2877+76
	mov	r1, r7
	ldrh	r4, [r5, #310]
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r4
	cbnz	r3, .L2795
	bl	__aeabi_idiv
	uxth	r10, r0
	movs	r3, #1
	smulbb	r0, r7, r10
	subs	r0, r4, r0
	uxth	fp, r0
.L2873:
	str	r3, [sp, #32]
	b	.L2793
.L2795:
	bl	__aeabi_idiv
	uxth	r10, r0
	movs	r3, #2
	smulbb	r0, r7, r10
	subs	r0, r4, r0
	uxth	fp, r0
	b	.L2873
.L2878:
	.align	2
.L2877:
	.word	.LANCHOR67
	.word	.LANCHOR59
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR170
	.word	.LC0
	.word	.LANCHOR36
	.word	.LANCHOR22
	.word	.LC149
	.word	.LANCHOR45
	.word	.LC150
	.word	.LANCHOR46
	.word	.LANCHOR60
	.word	.LANCHOR64
	.word	.LANCHOR66
	.word	.LANCHOR68
	.word	.LANCHOR108
	.word	.LANCHOR171
	.word	.LC151
	.word	.LANCHOR74
.L2798:
	add	r2, r2, r4
	cmp	r2, r1
	beq	.L2829
	ldr	r0, [r8, r2, lsl #2]
	adds	r0, r0, #1
	bne	.L2797
	ldrh	r6, [r3, #22]
	str	r3, [sp, #44]
	ldr	r3, [sp, #40]
	cmp	r6, r3
	bcs	.L2776
	mov	r0, r6
	adds	r6, r6, #1
	bl	gc_get_src_ppa_from_index
	ldr	r3, [sp, #44]
	strh	r6, [r3, #22]	@ movhi
	str	r0, [r8, r2, lsl #2]
.L2797:
	adds	r7, r7, #1
	b	.L2796
.L2816:
	ldr	r3, .L2879
	add	r7, r4, r8
	ldr	r3, [r3]
	ldrb	r3, [r3, r7]	@ zero_extendqisi2
	cmp	r3, #255
	bne	.L2801
	movs	r0, #0
	bl	buf_alloc
	mov	r5, r0
	cbnz	r0, .L2802
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	r0, r5
	bl	buf_alloc
	mov	r5, r0
	cmp	r0, #0
	beq	.L2776
.L2802:
	ldr	r3, .L2879
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	ldr	r3, [r3]
	strb	r2, [r3, r7]
	ldr	r2, .L2879+4
	strb	r6, [r5, #45]
	ldrb	r3, [r2, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r2, #7]
	ldr	r3, [sp, #36]
	add	r3, r3, r4
	strh	r3, [r5, #32]	@ movhi
	ldr	r3, .L2879+8
	ldrh	r2, [r3]
	ldr	r3, [sp, #28]
	ldrb	r3, [r3, #89]	@ zero_extendqisi2
	muls	r3, r2, r3
	subs	r3, r3, #1
	cmp	r7, r3
	bne	.L2803
	ldr	r3, .L2879+12
	ldr	r0, [r5, #4]
	ldr	r1, [r3]
	mov	r3, #-1
	str	r3, [r1, r7, lsl #2]
	ldr	r3, .L2879+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	muls	r2, r3, r2
	lsls	r2, r2, #2
	bl	ftl_memcpy
	ldr	r3, .L2879+8
	ldr	r2, .L2879+16
	ldr	r0, [r5, #4]
	ldrh	r3, [r3]
	ldrb	r2, [r2]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L2879+20
	ldr	r1, [r3]
	lsls	r2, r2, #2
	add	r0, r0, r2
	bl	ftl_memcpy
	ldr	r3, .L2879+24
	movs	r1, #0
	ldr	r0, [r5, #12]
	ldrb	r2, [r3]	@ zero_extendqisi2
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r3, [r5, #12]
	ldr	r2, .L2879+28
	ldr	r0, [r5, #4]
	str	r3, [sp, #44]
	str	r2, [r3]
	ldr	r3, .L2879+8
	ldrh	r2, [r3]
	ldr	r3, .L2879+16
	ldrb	r1, [r3]	@ zero_extendqisi2
	muls	r1, r2, r1
	lsls	r1, r1, #2
	bl	js_hash
	ldr	r2, .L2879+32
	ldr	r3, [sp, #44]
	ldr	r2, [r2]
	str	r0, [r3, #4]
	ldr	r2, [r2, #132]
.L2874:
	str	r2, [r3, #8]
.L2801:
	ldr	r3, .L2879
	ldr	r2, .L2879+36
	ldr	ip, [r3]
	add	r3, sp, #72
	add	r1, r3, r8, lsl #2
	ldrb	r5, [ip, r7]	@ zero_extendqisi2
	add	r3, r5, r5, lsl #1
	add	r3, r2, r3, lsl #4
	str	r3, [r1, #-24]
	movs	r3, #48
	mla	r2, r3, r5, r2
	movs	r3, #1
	strh	r3, [r2, #34]	@ movhi
	ldr	r3, .L2879+40
	strb	r6, [r2, #45]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L2811
	ldr	r3, [sp, #36]
	ldr	r0, .L2879+44
	umull	r0, r1, r3, r0
	ldr	r0, [sp, #28]
	lsrs	r3, r1, #1
	uxtah	r1, fp, r3
	add	r3, r3, r3, lsl #1
	add	r1, r0, r1, lsl #1
	ldrh	r0, [r1, #96]
	ldr	r1, .L2879+48
	ldrh	r1, [r1]
	muls	r1, r0, r1
	ldrh	r0, [r2, #32]
	orr	r1, r1, r10
	str	r1, [r2, #24]
	ldr	r2, .L2879+52
	ldr	lr, [r2]
	ldr	r2, [sp, #36]
	subs	r3, r2, r3
	lsls	r3, r3, #24
	add	r3, r3, #16777216
	orrs	r1, r1, r3
	str	r1, [lr, r0, lsl #2]
.L2812:
	ldr	r3, .L2879+56
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2815
	ldr	r3, .L2879+4
	movs	r2, #48
	ldr	r0, .L2879+60
	ldrb	r1, [r3, #6]	@ zero_extendqisi2
	ldr	r3, .L2879+36
	mla	r5, r2, r5, r3
	ldr	r2, .L2879+44
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #4]
	str	r3, [sp, #20]
	ldr	r3, [sp, #36]
	umull	r2, r3, r3, r2
	mov	r2, r6
	ubfx	r3, r3, #1, #16
	add	r3, r3, fp
	str	r3, [sp, #16]
	ldrb	r3, [r5, #1]	@ zero_extendqisi2
	str	r3, [sp, #12]
	ldrh	r3, [r5, #32]
	str	r3, [sp, #8]
	ldr	r3, [r5, #24]
	str	r3, [sp, #4]
	ldrb	r3, [ip, r7]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r1
	mov	r1, r8
	bl	printf
.L2815:
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	b	.L2875
.L2803:
	ldr	r3, .L2879+20
	movs	r1, #1
	mov	r0, r5
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	str	r3, [r5, #24]
	bl	sblk_read_page
	ldr	r3, [r5, #36]
	adds	r1, r3, #1
	beq	.L2804
	cmp	r3, #512
	bne	.L2808
.L2804:
	ldr	r3, .L2879+64
	ldrh	r2, [r3]
	movs	r3, #1
	rsb	r0, r2, #21
	lsls	r3, r3, r0
	ldr	r0, [r5, #24]
	subs	r3, r3, #1
	lsrs	r0, r0, r2
	ldr	r2, .L2879+68
	ands	r0, r0, r3
	ldrb	r1, [r2]	@ zero_extendqisi2
	bl	__aeabi_uidiv
	movs	r1, #0
	uxth	r0, r0
	bl	ftl_sblk_dump
	ldr	r3, [r5, #36]
	adds	r2, r3, #1
	beq	.L2806
	cmp	r3, #512
	bne	.L2808
.L2806:
	ldr	r3, [r5, #12]
	mov	r2, #-1
	str	r2, [r3, #4]
	ldr	r3, [r5, #36]
	cmp	r3, r2
	beq	.L2807
	cmp	r3, #512
	bne	.L2808
.L2807:
	movw	r2, #671
	ldr	r1, .L2879+72
	ldr	r0, .L2879+76
	bl	printf
.L2809:
	b	.L2809
.L2808:
	ldr	r3, [r5, #12]
	ldr	r2, .L2879+80
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	cmp	r1, r2
	itt	cs
	movcs	r2, #-1
	strcs	r2, [r3, #4]
	ldr	r2, .L2879+12
	ldr	r1, [r3, #4]
	ldr	r2, [r2]
	str	r1, [r2, r7, lsl #2]
	ldr	r2, [r5, #24]
	b	.L2874
.L2811:
	cmp	r3, #2
	bne	.L2813
	ldr	r3, .L2879+84
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2814
	ldr	r1, [sp, #28]
	add	r3, r8, fp
	add	r3, r1, r3, lsl #1
	ldr	r1, .L2879+48
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r10
.L2876:
	orr	r3, r3, #33554432
	str	r3, [r2, #24]
.L2813:
	ldr	r2, .L2879+36
	movs	r3, #48
	mla	r3, r3, r5, r2
	ldr	r2, [r3, #24]
	ldrh	r1, [r3, #32]
	ldr	r3, .L2879+52
	ldr	r3, [r3]
	str	r2, [r3, r1, lsl #2]
	b	.L2812
.L2814:
	ldr	r3, [sp, #36]
	ldr	r1, [sp, #28]
	add	r3, fp, r3, lsr #1
	add	r3, r1, r3, lsl #1
	ldr	r1, .L2879+48
	ldrh	r3, [r3, #96]
	ldrh	r1, [r1]
	mla	r3, r1, r3, r10
	ldr	r1, [sp, #36]
	and	r1, r1, #1
	add	r3, r3, r1
	b	.L2876
.L2880:
	.align	2
.L2879:
	.word	.LANCHOR65
	.word	.LANCHOR59
	.word	.LANCHOR68
	.word	.LANCHOR107
	.word	.LANCHOR69
	.word	.LANCHOR108
	.word	.LANCHOR45
	.word	-178307901
	.word	.LANCHOR60
	.word	.LANCHOR36
	.word	.LANCHOR64
	.word	-1431655765
	.word	.LANCHOR75
	.word	.LANCHOR109
	.word	.LANCHOR22
	.word	.LC152
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR170
	.word	.LC0
	.word	.LANCHOR47
	.word	.LANCHOR74
.L2817:
	ldr	r3, .L2881
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [sp, #48]
	cbz	r1, .L2819
	movs	r1, #0
.L2822:
	strb	r1, [r3, #44]
	add	r0, sp, #48
	add	r1, sp, #60
	bl	sblk_xlc_prog_pages
.L2823:
	ldr	r3, [sp, #28]
	ldr	r1, .L2881
	ldrb	r2, [r3, #89]	@ zero_extendqisi2
	ldrb	r1, [r1]	@ zero_extendqisi2
	uxth	r3, r2
	cmp	r1, #0
	beq	.L2825
	add	r3, r3, r3, lsl #1
.L2826:
	ldr	r1, .L2881+4
	ldr	r0, [r1]
	ldr	r1, [r0, #52]
	add	r1, r1, r3
	str	r1, [r0, #52]
	ldr	r1, .L2881+8
	ldrh	r0, [r1, #310]
	add	r3, r3, r0
	uxth	r3, r3
	strh	r3, [r1, #310]	@ movhi
	ldr	r1, .L2881+12
	ldrh	r1, [r1]
	muls	r2, r1, r2
	cmp	r3, r2
	itttt	ge
	ldrge	r3, .L2881+16
	movge	r2, #0
	ldrge	r3, [r3]
	strhge	r2, [r3, #86]	@ movhi
	bl	gc_write_completed
	b	.L2776
.L2819:
	cmp	r6, #1
	bne	.L2821
	movs	r1, #9
	b	.L2822
.L2821:
	cmp	r6, #2
	it	eq
	moveq	r1, #13
	b	.L2822
.L2824:
	add	r4, sp, #72
	add	r5, sp, #72
	add	r4, r4, r1, lsl #2
	add	r1, r5, r1, lsl #2
	ldr	r1, [r1, #-20]
	ldr	r4, [r4, #-24]
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	strb	r1, [r4]
	b	.L2818
.L2825:
	ldr	r1, .L2881+20
	ldrb	r1, [r1]	@ zero_extendqisi2
	cmp	r1, #0
	beq	.L2826
	lsls	r3, r3, #1
	uxth	r3, r3
	b	.L2826
.L2882:
	.align	2
.L2881:
	.word	.LANCHOR66
	.word	.LANCHOR46
	.word	.LANCHOR59
	.word	.LANCHOR68
	.word	.LANCHOR60
	.word	.LANCHOR74
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.do_gc,"ax",%progbits
	.align	1
	.global	do_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	do_gc, %function
do_gc:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r1, .L3019
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r5, .L3019+4
	mov	r10, r1
	ldr	r3, [r1]
	ldr	r7, .L3019+8
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldrh	r4, [r3, #116]
	ldrh	r6, [r3, #114]
	mov	r8, r7
	ldr	fp, [r7]
	add	r6, r6, r4
	uxth	r6, r6
	cmp	r2, #6
	bhi	.L2883
	tbh	[pc, r2, lsl #1]
.L2886:
	.2byte	(.L2885-.L2886)/2
	.2byte	(.L2887-.L2886)/2
	.2byte	(.L2888-.L2886)/2
	.2byte	(.L2889-.L2886)/2
	.2byte	(.L2890-.L2886)/2
	.2byte	(.L2891-.L2886)/2
	.2byte	(.L2892-.L2886)/2
	.p2align 1
.L2885:
	ldrh	r2, [r3, #118]
	ldrh	r1, [fp, #80]
	ldr	r7, .L3019+12
	add	r4, r4, r2
	movw	r2, #65535
	cmp	r1, r2
	uxth	r4, r4
	beq	.L2893
	ldr	r3, .L3019+16
	cmp	r4, #7
	ite	hi
	movhi	r8, #3
	movls	r8, #1
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2895
	ldrh	r3, [fp, #122]
	movw	r1, #1348
	ldrb	r2, [r7]	@ zero_extendqisi2
	ldr	r0, .L3019+20
	str	r3, [sp, #12]
	ldrh	r3, [fp, #120]
	str	r3, [sp, #8]
	ldrh	r3, [fp, #124]
	str	r4, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L2895:
	movs	r2, #1
	mov	r1, r8
	ldrb	r0, [r7]	@ zero_extendqisi2
	bl	gc_search_src_blk
	cmp	r0, #0
	ble	.L2883
.L2896:
	movs	r3, #1
.L3014:
	strb	r3, [r5]
	b	.L2883
.L2893:
	ldrh	r2, [r3, #122]
	cmp	r0, #1
	ldrh	r3, [r3, #124]
	str	r3, [sp, #16]
	bne	.L2897
	str	r2, [sp, #20]
	bl	gc_scan_static_data
	bl	gc_static_wearleveling
	ldr	r2, [sp, #20]
.L2897:
	ldr	r1, [r8]
	movs	r3, #1
	strb	r3, [r7]
	ldrh	fp, [r1, #124]
	cmp	fp, #0
	beq	.L2898
	strb	r3, [r5]
	movs	r2, #0
	ldr	r3, .L3019+16
	strb	r2, [r7]
	ldr	r3, [r3]
	lsls	r0, r3, #23
	bpl	.L2883
	ldrh	r3, [r1, #122]
	ldr	r0, .L3019+20
	str	r3, [sp, #12]
	ldrh	r3, [r1, #120]
	movw	r1, #1373
	stm	sp, {r4, fp}
	str	r3, [sp, #8]
	mov	r3, r6
	bl	printf
.L2883:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2898:
	cmp	r6, #47
	bhi	.L2900
	cmp	r4, #1
	bls	.L2901
	cmp	r4, #16
	bhi	.L2902
	ldr	r2, [r10]
	ldrh	r2, [r2, #120]
	cmp	r2, #127
	bhi	.L2903
.L2902:
	movs	r2, #16
	movs	r1, #3
.L3018:
	movs	r0, #1
.L3012:
	bl	gc_search_src_blk
	uxth	r0, r0
.L2904:
	cmp	r0, #0
	bne	.L2896
	b	.L2883
.L2903:
	movs	r2, #8
	movs	r1, #2
	b	.L3018
.L2901:
	ldr	r3, .L3019+16
	strb	fp, [r7]
	ldr	r3, [r3]
	lsls	r3, r3, #23
	bpl	.L2905
	ldrh	r3, [r1, #122]
	mov	r2, fp
	ldr	r0, .L3019+20
	str	r3, [sp, #12]
	ldrh	r3, [r1, #120]
	movw	r1, #1386
	stm	sp, {r4, fp}
	str	r3, [sp, #8]
	mov	r3, r6
	bl	printf
.L2905:
	cmp	r6, #16
	bls	.L2906
	movs	r2, #1
.L3017:
	movs	r1, #2
.L3011:
	ldrb	r0, [r7]	@ zero_extendqisi2
	b	.L3012
.L2906:
	movs	r2, #16
.L2920:
	movs	r1, #1
	b	.L3011
.L2900:
	ldr	r1, [sp, #16]
	cmp	r6, #127
	add	r2, r2, r1
	uxth	r2, r2
	str	r2, [sp, #16]
	bhi	.L2907
	subs	r2, r4, #2
	cmp	r2, #13
	bhi	.L2908
	movs	r2, #8
	movs	r1, #2
	mov	r0, r3
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #0
	bne	.L2896
.L2911:
	ldr	r3, .L3019+24
	ldr	fp, .L3019+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #2
	ldr	r3, .L3019+16
	bne	.L3009
	cmp	r4, #1
	mov	r2, #0
	strh	r2, [fp, #30]	@ movhi
	bls	.L2912
.L2915:
	ldr	r3, [r3]
	movs	r2, #1
	strb	r2, [r7]
	lsls	r0, r3, #23
	bpl	.L2914
	ldr	r3, [r8]
	ldr	r0, .L3019+20
	ldrh	r1, [r3, #122]
	str	r1, [sp, #12]
	ldrh	r1, [r3, #120]
	str	r1, [sp, #8]
	movw	r1, #1411
	ldrh	r3, [r3, #124]
	str	r4, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L2914:
	ldrh	r3, [fp, #30]
	movs	r2, #16
	movs	r1, #1
	ldrb	r0, [r7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strh	r3, [fp, #30]	@ movhi
	movs	r3, #0
	strh	r3, [fp, #28]	@ movhi
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #7
	bhi	.L2916
	cmp	r4, #31
	bls	.L2917
.L2916:
	ldr	r3, [r10]
	ldrh	r2, [r3, #120]
	ldr	r3, .L3019+28
	ldrh	r3, [r3]
	cmp	r2, r3
	bls	.L2904
.L2917:
	ldr	r3, [sp, #16]
	cmp	r3, #63
	bhi	.L2918
	movs	r2, #8
	b	.L3017
.L2908:
	ldr	r3, .L3019+32
	ldr	r2, [sp, #16]
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bcs	.L2911
	b	.L2883
.L3009:
	cmp	r4, #1
	bls	.L2912
	ldrh	r2, [fp, #30]
	cmp	r2, #3
	bls	.L2915
.L2912:
	ldr	r3, [r3]
	movs	r2, #0
	strh	r2, [fp, #30]	@ movhi
	strb	r2, [r7]
	lsls	r1, r3, #23
	bpl	.L2919
	ldr	r3, [r8]
	ldr	r0, .L3019+20
	ldrh	r1, [r3, #122]
	str	r1, [sp, #12]
	ldrh	r1, [r3, #120]
	str	r1, [sp, #8]
	movw	r1, #1426
	ldrh	r3, [r3, #124]
	str	r4, [sp]
	str	r3, [sp, #4]
	mov	r3, r6
	bl	printf
.L2919:
	ldr	r3, .L3019+32
	ldr	r2, [sp, #16]
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bls	.L2883
	cmp	r4, #31
	mov	r2, #16
	bhi	.L2920
	b	.L3013
.L2918:
	movs	r2, #16
.L3013:
	movs	r1, #3
	b	.L3011
.L2907:
	cmp	r6, #255
	bhi	.L2921
	ldr	r2, .L3019+32
	ldr	r1, [sp, #16]
	ldrh	r2, [r2]
	cmp	r1, r2
	bls	.L2921
	cmp	r1, r2, lsr #1
	bcc	.L2883
	movs	r2, #16
	mov	r1, r3
	mov	r0, fp
	strb	fp, [r7]
	str	r3, [sp, #16]
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #7
	bhi	.L2896
	cmp	r4, #4
	bls	.L2904
	ldr	r0, [r8]
	movs	r2, #128
	movs	r1, #255
	strh	fp, [r0, #120]	@ movhi
	adds	r0, r0, #136
	bl	ftl_memset
	ldr	r3, [sp, #16]
	strb	r3, [r7]
	ldr	r3, [r10]
	ldrh	r2, [r3, #120]
	ldr	r3, .L3019+28
	ldrh	r3, [r3]
	cmp	r2, r3
	bls	.L2923
	cmp	r4, #16
	bls	.L2924
.L2926:
	movs	r2, #8
	movs	r1, #2
.L3010:
	movs	r0, #1
	bl	gc_search_src_blk
	movs	r3, #1
	uxth	r0, r0
	strb	r3, [r5]
	b	.L2904
.L3020:
	.align	2
.L3019:
	.word	.LANCHOR46
	.word	.LANCHOR104
	.word	.LANCHOR60
	.word	.LANCHOR67
	.word	.LANCHOR22
	.word	.LC153
	.word	.LANCHOR64
	.word	.LANCHOR163
	.word	.LANCHOR165
	.word	.LANCHOR59
.L2923:
	cmp	r4, #32
	bls	.L2924
	movs	r2, #16
	movs	r1, #1
	b	.L3010
.L2924:
	cmp	r4, #7
	bls	.L2926
	movs	r2, #16
	movs	r1, #3
	b	.L3010
.L2921:
	subs	r4, r4, #2
	cmp	r4, #5
	bhi	.L2883
	ldr	r3, .L3021
	ldr	r2, [sp, #16]
	ldrh	r3, [r3]
	cmp	r2, r3, lsr #1
	bls	.L2883
	movs	r2, #16
	movs	r1, #2
	movs	r0, #1
	bl	gc_search_src_blk
	uxth	r0, r0
	cmp	r0, #15
	bhi	.L2896
	ldrb	r0, [r7]	@ zero_extendqisi2
	movs	r1, #0
	ldr	r3, [r8]
	add	r2, r0, #60
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r2, #128
	mla	r0, r2, r0, r3
	movs	r1, #255
	adds	r0, r0, #136
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	ftl_memset
.L2887:
	ldr	r4, .L3021+4
	movw	r3, #65535
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L2928
	bl	gc_get_src_blk
	strh	r0, [r4]	@ movhi
.L2928:
	ldrh	r3, [r4]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L2929
	ldrh	r1, [r4, #52]
	cbz	r1, .L2930
	ldr	r0, .L3021+8
	movs	r2, #0
.L2931:
	uxth	r4, r2
	cmp	r1, r4
	bhi	.L2932
.L2930:
	ldr	r2, .L3021+12
	ldr	r2, [r2]
	add	r2, r2, r3, lsl #2
	ldrb	r2, [r2, #2]	@ zero_extendqisi2
	and	r1, r2, #224
	cmp	r1, #224
	beq	.L2933
	tst	r2, #192
	bne	.L2934
.L2933:
	ldr	r2, .L3021+16
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cbz	r3, .L2935
	movw	r2, #1497
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
.L2936:
	b	.L2936
.L2932:
	ldrh	r4, [r0, #2]!
	adds	r2, r2, #1
	cmp	r4, r3
	bne	.L2931
.L2935:
	ldr	r3, .L3021+4
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L2883
.L2934:
	movs	r3, #2
	b	.L3014
.L2929:
	movs	r3, #0
	b	.L3014
.L2888:
	bl	gc_scan_src_blk
	adds	r0, r0, #1
	bne	.L2937
	movs	r3, #3
	b	.L3014
.L2937:
	ldr	r4, .L3021+4
	movw	r3, #65535
	ldrh	r0, [r4]
	cmp	r0, r3
	beq	.L2896
	ldrh	r3, [r4, #20]
	cbz	r3, .L2938
	movs	r3, #4
	strb	r3, [r5]
	movs	r3, #0
	strh	r3, [r4, #22]	@ movhi
	b	.L2883
.L2938:
	ldr	r6, .L3021+16
	movs	r3, #1
	strb	r3, [r5]
	ldr	r3, [r6]
	ldrh	r5, [r3, r0, lsl #1]
	cbz	r5, .L2939
	movw	r2, #1525
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
.L2940:
	b	.L2940
.L2939:
	bl	ftl_free_sblk
	ldr	r3, [r6]
	ldrh	r2, [r4]
	strh	r5, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	strh	r3, [r4, #26]	@ movhi
	bls	.L2935
	strh	r5, [r4, #26]	@ movhi
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	r0, r5
	bl	ftl_info_flush
	b	.L2935
.L2889:
	bl	gc_scan_src_blk_one_page
	ldr	r4, .L3021+4
	ldr	r3, .L3021+28
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2883
	ldrh	r3, [r4, #20]
	ldr	r2, .L3021+32
	cbz	r3, .L2941
	ldr	r2, [r2]
	movs	r1, #4
	strb	r1, [r5]
	movs	r1, #0
	strh	r1, [r4, #22]	@ movhi
	tst	r2, #256
	ldr	r5, .L3021+16
	beq	.L2942
	ldrh	r1, [r4]
	ldr	r2, [r5]
	ldr	r0, .L3021+36
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
.L2942:
	ldr	r3, [r5]
	ldrh	r2, [r4]
	ldrh	r2, [r3, r2, lsl #1]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	beq	.L2883
	movw	r2, #1555
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
.L2943:
	b	.L2943
.L2941:
	ldr	r3, .L3021+12
	ldrh	r1, [r4]
	ldr	r6, [r3]
	movs	r3, #1
	strb	r3, [r5]
	ldr	r3, [r2]
	add	r6, r6, r1, lsl #2
	lsls	r2, r3, #23
	bpl	.L2944
	ldrb	r2, [r6, #2]	@ zero_extendqisi2
	ldr	r0, .L3021+40
	lsrs	r2, r2, #5
	bl	printf
.L2944:
	ldrb	r3, [r6, #2]	@ zero_extendqisi2
	and	r2, r3, #224
	cmp	r2, #224
	beq	.L2945
	tst	r3, #192
	bne	.L2946
.L2945:
	movw	r2, #1565
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
.L2947:
	b	.L2947
.L2946:
	ldrh	r0, [r4]
	bl	ftl_free_sblk
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	ldrh	r3, [r4, #26]
	adds	r3, r3, #1
	uxth	r3, r3
	cmp	r3, #8
	strh	r3, [r4, #26]	@ movhi
	bls	.L2883
	movs	r3, #0
	strh	r3, [r4, #26]	@ movhi
.L3016:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	flt_sys_flush
.L2890:
	ldrh	r7, [fp, #80]
	movw	r3, #65535
	cmp	r7, r3
	bne	.L2948
	ldr	r3, .L3021+44
	ldrb	r4, [r3]	@ zero_extendqisi2
	cmp	r4, #1
	bne	.L2948
	bl	ftl_flush
	movs	r0, #5
	bl	ftl_alloc_sblk
	cmp	r0, r7
	mov	r5, r0
	bne	.L2949
	movw	r2, #1581
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
.L2950:
	b	.L2950
.L2949:
	mov	r1, r4
	movs	r4, #0
	bl	ftl_erase_sblk
	movs	r3, #5
	add	r1, fp, #96
	strb	r3, [fp, #84]
	mov	r0, r5
	bl	ftl_get_blk_list_in_sblk
	ldr	r3, .L3021+28
	uxtb	r0, r0
	ldr	r6, .L3021+48
	movs	r1, #255
	strb	r0, [fp, #89]
	ldrh	r3, [r3]
	strh	r5, [fp, #80]	@ movhi
	strh	r4, [fp, #82]	@ movhi
	strb	r4, [fp, #85]
	smulbb	r0, r3, r0
	strh	r4, [fp, #90]	@ movhi
	ldrb	r2, [r6]	@ zero_extendqisi2
	strh	r0, [fp, #86]	@ movhi
	ldr	fp, .L3021+64
	ldrh	r3, [fp]
	muls	r2, r3, r2
	ldr	r3, .L3021+52
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [fp]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3021+56
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r3, [fp]
	movs	r1, #255
	ldrb	r2, [r6]	@ zero_extendqisi2
	muls	r2, r3, r2
	ldr	r3, .L3021+60
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, [r8]
	strh	r7, [r3, #128]	@ movhi
	strh	r7, [r3, #130]	@ movhi
	str	r5, [r3, #132]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	r3, [r10]
	mov	r2, #-1
	mov	r0, r4
	strh	r5, [r3, #126]	@ movhi
	ldr	r3, .L3021+4
	strh	r4, [r3, #310]	@ movhi
	strh	r4, [r3, #52]	@ movhi
	strh	r4, [r3, #312]	@ movhi
	strh	r4, [r3, #314]	@ movhi
	str	r2, [r3, #316]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	ftl_info_flush
.L3022:
	.align	2
.L3021:
	.word	.LANCHOR165
	.word	.LANCHOR59
	.word	.LANCHOR59+52
	.word	.LANCHOR57
	.word	.LANCHOR56
	.word	.LANCHOR172
	.word	.LC0
	.word	.LANCHOR79
	.word	.LANCHOR22
	.word	.LC154
	.word	.LC155
	.word	.LANCHOR67
	.word	.LANCHOR69
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR65
	.word	.LANCHOR68
.L2948:
	cmp	r6, #31
	bls	.L2968
	cmp	r6, #63
	bls	.L2969
	cmp	r6, #127
	bls	.L2970
	cmp	r6, #255
	ite	hi
	movhi	r6, #1
	movls	r6, #2
.L2951:
	ldr	r7, .L3023
	ldr	r4, .L3023+4
.L2952:
	subs	r6, r6, #1
	uxtb	r6, r6
	cmp	r6, #255
	beq	.L2883
	bl	gc_do_copy_back
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbnz	r3, .L2953
	ldr	r3, .L3023+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #3
	bhi	.L2954
	bl	ftl_write_commit
.L2954:
	ldrh	r2, [r4, #22]
	ldrh	r3, [r4, #20]
	cmp	r2, r3
	bcc	.L2952
	movs	r3, #1
	strb	r3, [r5]
	bl	ftl_write_commit
	bl	ftl_flush
	ldr	r3, .L3023+12
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2956
	movw	r2, #1638
	ldr	r1, .L3023+16
	ldr	r0, .L3023+20
	bl	printf
.L2957:
	b	.L2957
.L2968:
	movs	r6, #9
	b	.L2951
.L2969:
	movs	r6, #5
	b	.L2951
.L2970:
	movs	r6, #3
	b	.L2951
.L2956:
	bl	ftl_free_sblk
.L3015:
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	b	.L2883
.L2953:
	ldrh	r3, [r4, #314]
	cbz	r3, .L2958
	ldr	r0, [r4, #316]
	movs	r6, #0
	strh	r6, [r4, #314]	@ movhi
	adds	r3, r0, #1
	beq	.L2959
	bl	ftl_mask_bad_block
.L2959:
	ldr	r3, [r8]
	str	r6, [r4, #316]
	strh	r6, [r4, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r0, [r4, #8]
	movw	r3, #65535
	ldr	r2, [r8]
	ldr	r1, [r10]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	cbz	r0, .L2960
	bl	buf_free
.L2960:
	movs	r6, #0
	str	r6, [r4, #8]
	bl	flt_sys_flush
	movw	r2, #1671
	ldr	r1, .L3023+16
	ldr	r0, .L3023+20
	strb	r6, [r5]
	bl	printf
.L2961:
	b	.L2961
.L2958:
	ldrh	r3, [fp, #86]
	ldrh	r2, [r4, #22]
	cmp	r3, #1
	ldrh	r3, [r4, #20]
	bls	.L2962
	cmp	r2, r3
	bcc	.L2952
	movs	r3, #1
	strb	r3, [r5]
	ldrh	r3, [r4, #52]
	adds	r2, r3, #1
	strh	r2, [r4, #52]	@ movhi
	add	r3, r4, r3, lsl #1
	ldrh	r2, [r4]
	strh	r2, [r3, #54]	@ movhi
	b	.L3015
.L2962:
	cmp	r2, r3
	mov	r1, #5
	strb	r1, [r5]
	bcc	.L2963
	ldrh	r3, [r4, #52]
	adds	r2, r3, #1
	strh	r2, [r4, #52]	@ movhi
	add	r3, r4, r3, lsl #1
	ldrh	r2, [r4]
	strh	r2, [r3, #54]	@ movhi
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
.L2963:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	r3, [r8]
	ldrh	r2, [fp, #80]
	strh	r2, [r3, #128]	@ movhi
	bl	pm_flush
	bl	ftl_ext_info_flush
	movs	r3, #0
	ldr	r2, .L3023+24
	strh	r3, [r4, #12]	@ movhi
	ldr	r3, .L3023+28
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, #2
	strh	r2, [r4, #16]	@ movhi
	strh	r3, [r4, #14]	@ movhi
	itttt	eq
	lsleq	r3, r3, #1
	strheq	r3, [r4, #14]	@ movhi
	moveq	r3, #1
	strheq	r3, [r4, #16]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #18]	@ movhi
	b	.L2883
.L2891:
	bl	gc_check_data_one_wl
	ldr	r4, .L3023+4
	mov	r6, r0
	cbz	r0, .L2966
	ldr	r3, [r7]
	movs	r6, #0
	strh	r6, [r4, #52]	@ movhi
	ldrh	r0, [r3, #80]
	bl	ftl_free_sblk
	ldr	r2, [r7]
	movw	r3, #65535
	ldr	r1, [r10]
	ldr	r0, [r4, #8]
	strh	r3, [r2, #80]	@ movhi
	strh	r3, [r1, #126]	@ movhi
	strh	r3, [r2, #130]	@ movhi
	bl	buf_free
	str	r6, [r4, #8]
	strb	r6, [r5]
	b	.L3016
.L2966:
	ldrh	r2, [r4, #12]
	ldrh	r3, [r4, #14]
	cmp	r2, r3
	bcc	.L2883
	movs	r3, #6
	ldr	r0, [r4, #8]
	strb	r3, [r5]
	bl	buf_free
	str	r6, [r4, #8]
	b	.L2883
.L2892:
	movw	r4, #65535
	bl	gc_update_l2p_map_new
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	r4, [fp, #80]	@ movhi
	bl	ftl_ext_info_flush
	ldr	r3, [r10]
	movs	r0, #0
	strh	r4, [r3, #126]	@ movhi
	bl	ftl_info_flush
	movs	r3, #0
	strb	r3, [r5]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	print_ftl_debug_info
.L3024:
	.align	2
.L3023:
	.word	.LANCHOR67
	.word	.LANCHOR59
	.word	.LANCHOR38
	.word	.LANCHOR56
	.word	.LANCHOR172
	.word	.LC0
	.word	.LANCHOR64
	.word	.LANCHOR79
	.size	do_gc, .-do_gc
	.section	.text.ftl_write,"ax",%progbits
	.align	1
	.global	ftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write, %function
ftl_write:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	mov	r10, r3
	cbnz	r0, .L3026
	mov	r0, #24576
	ldr	r3, .L3039
	ldr	r3, [r3]
.L3027:
	adds	r2, r1, r7
	cmp	r3, r2
	bcc	.L3038
	ldr	fp, .L3039+8
	adds	r5, r0, r1
	mov	r0, r5
	ldrb	r4, [fp]	@ zero_extendqisi2
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r8, r0
	subs	r0, r7, #1
	mov	r1, r4
	add	r0, r0, r5
	bl	__aeabi_uidiv
	sub	r4, r0, r8
	mov	r6, r8
	adds	r4, r4, #1
	str	r0, [sp, #4]
	str	fp, [sp, #8]
.L3029:
	cbnz	r4, .L3036
	bl	ftl_write_commit
	mov	r0, r4
	movs	r1, #1
	bl	do_gc
	mov	r0, r4
.L3025:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3026:
	cmp	r0, #3
	bhi	.L3038
	lsls	r0, r0, #13
	mov	r3, #8192
	b	.L3027
.L3036:
	movs	r0, #0
	bl	buf_alloc
	mov	fp, r0
	cbnz	r0, .L3030
	bl	ftl_write_commit
	b	.L3029
.L3030:
	mov	r3, #0
	cmp	r6, r8
	strb	r3, [r0, #41]
	ldr	r3, [sp, #8]
	ldrb	r2, [r3]	@ zero_extendqisi2
	strb	r2, [r0, #40]
	bne	.L3032
	mov	r1, r2
	mov	r0, r5
	str	r2, [sp, #12]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	uxtb	r1, r1
	strb	r1, [fp, #41]
	subs	r1, r2, r1
	uxtb	r1, r1
	cmp	r7, r1
	ite	cs
	strbcs	r1, [fp, #40]
	strbcc	r7, [fp, #40]
.L3034:
	ldrb	ip, [fp, #41]	@ zero_extendqisi2
	mov	r1, r10
	ldrb	r2, [fp, #40]	@ zero_extendqisi2
	subs	r4, r4, #1
	ldr	r0, [fp, #4]
	lsls	r2, r2, #9
	add	r0, r0, ip, lsl #9
	bl	ftl_memcpy
	ldr	r3, .L3039+4
	str	r6, [fp, #20]
	adds	r6, r6, #1
	ldr	r1, [r3]
	ldr	r2, [r1, #8]
	adds	r0, r2, #1
	str	r0, [r1, #8]
	mov	r0, fp
	str	r2, [fp, #16]
	bl	ftl_write_buf
	ldrb	r3, [fp, #40]	@ zero_extendqisi2
	add	r10, r10, r3, lsl #9
	b	.L3029
.L3032:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	itttt	eq
	smulbbeq	r2, r6, r2
	addeq	r1, r5, r7
	subeq	r2, r1, r2
	strbeq	r2, [r0, #40]
	b	.L3034
.L3038:
	mov	r0, #-1
	b	.L3025
.L3040:
	.align	2
.L3039:
	.word	.LANCHOR52
	.word	.LANCHOR46
	.word	.LANCHOR45
	.size	ftl_write, .-ftl_write
	.section	.text.FtlWrite,"ax",%progbits
	.align	1
	.global	FtlWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlWrite, %function
FtlWrite:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	ftl_write
	.size	FtlWrite, .-FtlWrite
	.section	.text.StorageSysDataStore,"ax",%progbits
	.align	1
	.global	StorageSysDataStore
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r1
	movs	r2, #1
	mov	r1, r0
	movs	r0, #2
	b	ftl_write
	.size	StorageSysDataStore, .-StorageSysDataStore
	.global	g_pm_spare
	.global	pm_gc_enable
	.global	pm_last_load_ram_id
	.global	pm_last_update_ram_id
	.global	pm_ram_info
	.global	sblk_gc_write_completed_queue_head
	.global	sblk_read_completed_queue_head
	.global	sblk_write_completed_queue_head
	.global	sblk_queue_head
	.global	ftl_low_format_cur_blk
	.global	ftl_power_lost_flag
	.global	ftl_vpn_update_count
	.global	ftl_sblk_vpn_update_id
	.global	ftl_sblk_lpa_tbl
	.global	ftl_sblk_vpn
	.global	gp_ftl_ext_info
	.global	gp_ftl_info
	.global	gp_blk_info
	.global	ftl_tmp_spare
	.global	ftl_info_spare
	.global	ftl_ext_info_data_buffer
	.global	ftl_info_data_buffer
	.global	ftl_tmp_buffer
	.global	g_ftl_info_blk
	.global	tlc_prog_order
	.global	gc_des_ppa_tbl
	.global	gc_valid_page_ppa
	.global	gc_page_buf_id
	.global	gc_pre_ppa_tbl
	.global	gc_lpa_tbl
	.global	g_gc_info
	.global	gc_slc_mode_vpn_th
	.global	gc_tlc_mode_tlc_vpn_th
	.global	gc_tlc_mode_slc_vpn_th
	.global	gc_state
	.global	gc_mode
	.global	check_vpc_tbl
	.global	p_read_ahead_ext_buf
	.global	read_ahead_lpa
	.global	write_commit_count
	.global	write_commit_head
	.global	write_buf_count
	.global	write_buf_head
	.global	ftl_flush_jiffies
	.global	lpa_hash
	.global	lpa_hash_index
	.global	_min_slc_super_block
	.global	_max_slc_super_block
	.global	_max_xlc_super_block
	.global	_c_max_pm_sblk
	.global	_c_ftl_pm_page_num
	.global	_c_totle_log_page
	.global	_c_totle_data_density
	.global	_c_user_data_density
	.global	_c_totle_phy_density
	.global	_c_ftl_block_addr_log2
	.global	_c_ftl_block_align_addr
	.global	_c_ftl_byte_pre_page
	.global	_c_ftl_nand_blks_per_die
	.global	_c_ftl_page_pre_slc_blk
	.global	_c_ftl_page_pre_blk
	.global	_c_ftl_blk_pre_plane
	.global	_c_ftl_nand_planes_num
	.global	_c_ftl_planes_per_die
	.global	_c_ftl_sec_per_page
	.global	_c_ftl_nand_die_num
	.global	_c_ftl_nand_type
	.global	zftl_debug
	.global	g_flash_blk_info
	.global	gp_flash_info
	.global	p_free_buf_head
	.global	free_buf_count
	.global	g_buf
	.global	g_nandc_v6_master_info
	.global	nandc_randomizer_en
	.global	nandc_hw_seed
	.global	fill_spare_size
	.global	g_nandc_ecc_bits
	.global	g_nandc_ver
	.global	gp_nandc
	.global	hy_f26_ref_value
	.global	sd15_tlc_rr
	.global	sd15_slc_rr
	.global	gNandParaInfo
	.global	NandFlashParaTbl
	.global	gpNandParaInfo
	.global	gNandOptPara
	.global	g_msb_page_tbl
	.global	g_lsb_page_tbl
	.global	g_die_addr
	.global	g_die_cs_idx
	.global	IDByte
	.global	flash_read_retry
	.global	g_maxRetryCount
	.global	g_maxRegNum
	.global	g_retryMode
	.global	g_flash_toggle_mode_en
	.global	g_flash_3d_mlc_flag
	.global	g_flash_3d_tlc_flag
	.global	g_flash_multi_page_prog_en
	.global	g_flash_multi_page_read_en
	.global	g_flash_interface_mode
	.global	g_idb_ecc_bits
	.global	g_idb_slc_mode_enable
	.global	g_slc_mode_addr2
	.global	g_slc_mode_enable
	.global	g_flash_cur_mode
	.global	g_flash_slc_mode
	.global	g_slc_page_num
	.global	g_totle_phy_block
	.global	g_block_align_addr
	.global	g_flash_reversd_blks
	.global	g_nand_max_die
	.global	g_flash_tmp_spare_buffer
	.global	g_flash_tmp_page_buffer
	.global	g_flash_sys_spare_buffer
	.global	g_flash_spare_buffer
	.global	g_flash_page_buffer
	.section	.bss.IDByte,"aw",%nobits
	.align	2
	.set	.LANCHOR26,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.space	32
	.section	.bss._c_ftl_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	_c_ftl_blk_pre_plane, %object
	.size	_c_ftl_blk_pre_plane, 2
_c_ftl_blk_pre_plane:
	.space	2
	.section	.bss._c_ftl_block_addr_log2,"aw",%nobits
	.align	1
	.set	.LANCHOR71,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.space	2
	.section	.bss._c_ftl_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR75,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.space	2
	.section	.bss._c_ftl_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR149,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.space	2
	.section	.bss._c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.type	_c_ftl_nand_blks_per_die, %object
	.size	_c_ftl_nand_blks_per_die, 2
_c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss._c_ftl_nand_die_num,"aw",%nobits
	.set	.LANCHOR76,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.space	1
	.section	.bss._c_ftl_nand_planes_num,"aw",%nobits
	.set	.LANCHOR69,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.space	1
	.section	.bss._c_ftl_nand_type,"aw",%nobits
	.set	.LANCHOR64,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.space	1
	.section	.bss._c_ftl_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.space	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.space	2
	.section	.bss._c_ftl_planes_per_die,"aw",%nobits
	.set	.LANCHOR70,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.space	1
	.section	.bss._c_ftl_pm_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.space	2
	.section	.bss._c_ftl_sec_per_page,"aw",%nobits
	.set	.LANCHOR45,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.space	1
	.section	.bss._c_max_pm_sblk,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.space	2
	.section	.bss._c_totle_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.space	4
	.section	.bss._c_totle_log_page,"aw",%nobits
	.align	2
	.set	.LANCHOR47,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.space	4
	.section	.bss._c_totle_phy_density,"aw",%nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.space	4
	.section	.bss._c_user_data_density,"aw",%nobits
	.align	2
	.set	.LANCHOR52,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.space	4
	.section	.bss._max_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR164,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.space	2
	.section	.bss._max_xlc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR163,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.space	2
	.section	.bss._min_slc_super_block,"aw",%nobits
	.align	1
	.set	.LANCHOR165,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.space	2
	.section	.bss.check_vpc_tbl,"aw",%nobits
	.align	1
	.type	check_vpc_tbl, %object
	.size	check_vpc_tbl, 4352
check_vpc_tbl:
	.space	4352
	.section	.bss.fill_spare_size,"aw",%nobits
	.align	1
	.set	.LANCHOR31,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.space	2
	.section	.bss.flash_read_retry,"aw",%nobits
	.align	2
	.set	.LANCHOR115,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 4
flash_read_retry:
	.space	4
	.section	.bss.free_buf_count,"aw",%nobits
	.set	.LANCHOR38,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.space	1
	.section	.bss.ftl_ext_info_data_buffer,"aw",%nobits
	.align	6
	.type	ftl_ext_info_data_buffer, %object
	.size	ftl_ext_info_data_buffer, 16384
ftl_ext_info_data_buffer:
	.space	16384
	.section	.bss.ftl_flush_jiffies,"aw",%nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	ftl_flush_jiffies, %object
	.size	ftl_flush_jiffies, 4
ftl_flush_jiffies:
	.space	4
	.section	.bss.ftl_info_data_buffer,"aw",%nobits
	.align	6
	.type	ftl_info_data_buffer, %object
	.size	ftl_info_data_buffer, 16384
ftl_info_data_buffer:
	.space	16384
	.section	.bss.ftl_info_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR130,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.space	256
	.section	.bss.ftl_low_format_cur_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.space	2
	.section	.bss.ftl_power_lost_flag,"aw",%nobits
	.set	.LANCHOR133,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.space	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR82,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 4
ftl_sblk_lpa_tbl:
	.space	4
	.section	.bss.ftl_sblk_vpn,"aw",%nobits
	.align	2
	.set	.LANCHOR56,. + 0
	.type	ftl_sblk_vpn, %object
	.size	ftl_sblk_vpn, 4
ftl_sblk_vpn:
	.space	4
	.section	.bss.ftl_sblk_vpn_update_id,"aw",%nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.space	2
	.section	.bss.ftl_tmp_buffer,"aw",%nobits
	.align	6
	.type	ftl_tmp_buffer, %object
	.size	ftl_tmp_buffer, 16384
ftl_tmp_buffer:
	.space	16384
	.section	.bss.ftl_tmp_spare,"aw",%nobits
	.align	6
	.set	.LANCHOR121,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.space	256
	.section	.bss.ftl_vpn_update_count,"aw",%nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	ftl_vpn_update_count, %object
	.size	ftl_vpn_update_count, 2
ftl_vpn_update_count:
	.space	2
	.section	.bss.gNandOptPara,"aw",%nobits
	.set	.LANCHOR103,. + 0
	.type	gNandOptPara, %object
	.size	gNandOptPara, 32
gNandOptPara:
	.space	32
	.section	.bss.g_block_align_addr,"aw",%nobits
	.align	1
	.set	.LANCHOR13,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.space	2
	.section	.bss.g_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR36,. + 0
	.type	g_buf, %object
	.size	g_buf, 1536
g_buf:
	.space	1536
	.section	.bss.g_die_addr,"aw",%nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.space	32
	.section	.bss.g_die_cs_idx,"aw",%nobits
	.align	2
	.set	.LANCHOR10,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.space	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",%nobits
	.set	.LANCHOR74,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.space	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",%nobits
	.set	.LANCHOR66,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.space	1
	.section	.bss.g_flash_blk_info,"aw",%nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.space	4
	.section	.bss.g_flash_cur_mode,"aw",%nobits
	.set	.LANCHOR20,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 1
g_flash_cur_mode:
	.space	1
	.section	.bss.g_flash_interface_mode,"aw",%nobits
	.set	.LANCHOR25,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.space	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",%nobits
	.set	.LANCHOR23,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.space	1
	.section	.bss.g_flash_multi_page_read_en,"aw",%nobits
	.set	.LANCHOR144,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.space	1
	.section	.bss.g_flash_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 4
g_flash_page_buffer:
	.space	4
	.section	.bss.g_flash_reversd_blks,"aw",%nobits
	.set	.LANCHOR123,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.space	1
	.section	.bss.g_flash_slc_mode,"aw",%nobits
	.set	.LANCHOR11,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.space	1
	.section	.bss.g_flash_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR118,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 4
g_flash_spare_buffer:
	.space	4
	.section	.bss.g_flash_sys_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR116,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 4
g_flash_sys_spare_buffer:
	.space	4
	.section	.bss.g_flash_tmp_page_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR111,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 4
g_flash_tmp_page_buffer:
	.space	4
	.section	.bss.g_flash_tmp_spare_buffer,"aw",%nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 4
g_flash_tmp_spare_buffer:
	.space	4
	.section	.bss.g_flash_toggle_mode_en,"aw",%nobits
	.set	.LANCHOR35,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.space	1
	.section	.bss.g_ftl_info_blk,"aw",%nobits
	.align	6
	.set	.LANCHOR131,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.space	4
	.section	.bss.g_gc_info,"aw",%nobits
	.align	2
	.set	.LANCHOR59,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 320
g_gc_info:
	.space	320
	.section	.bss.g_idb_ecc_bits,"aw",%nobits
	.set	.LANCHOR145,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.space	1
	.section	.bss.g_idb_slc_mode_enable,"aw",%nobits
	.set	.LANCHOR146,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.space	1
	.section	.bss.g_lsb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR14,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.space	512
	.section	.bss.g_maxRegNum,"aw",%nobits
	.set	.LANCHOR4,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.space	1
	.section	.bss.g_maxRetryCount,"aw",%nobits
	.set	.LANCHOR113,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_msb_page_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.space	1024
	.section	.bss.g_nand_max_die,"aw",%nobits
	.set	.LANCHOR8,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.space	1
	.section	.bss.g_nandc_ecc_bits,"aw",%nobits
	.set	.LANCHOR27,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.space	1
	.section	.bss.g_nandc_v6_master_info,"aw",%nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 28
g_nandc_v6_master_info:
	.space	28
	.section	.bss.g_nandc_ver,"aw",%nobits
	.set	.LANCHOR7,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.space	1
	.section	.bss.g_pm_spare,"aw",%nobits
	.align	2
	.set	.LANCHOR141,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 4
g_pm_spare:
	.space	4
	.section	.bss.g_retryMode,"aw",%nobits
	.set	.LANCHOR1,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.space	1
	.section	.bss.g_slc_mode_addr2,"aw",%nobits
	.set	.LANCHOR12,. + 0
	.type	g_slc_mode_addr2, %object
	.size	g_slc_mode_addr2, 1
g_slc_mode_addr2:
	.space	1
	.section	.bss.g_slc_mode_enable,"aw",%nobits
	.type	g_slc_mode_enable, %object
	.size	g_slc_mode_enable, 1
g_slc_mode_enable:
	.space	1
	.section	.bss.g_slc_page_num,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.space	2
	.section	.bss.g_totle_phy_block,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.space	2
	.section	.bss.gc_des_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR109,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 4
gc_des_ppa_tbl:
	.space	4
	.section	.bss.gc_lpa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR107,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 4
gc_lpa_tbl:
	.space	4
	.section	.bss.gc_mode,"aw",%nobits
	.set	.LANCHOR67,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.space	1
	.section	.bss.gc_page_buf_id,"aw",%nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 4
gc_page_buf_id:
	.space	4
	.section	.bss.gc_pre_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR108,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 4
gc_pre_ppa_tbl:
	.space	4
	.section	.bss.gc_slc_mode_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.space	2
	.section	.bss.gc_state,"aw",%nobits
	.set	.LANCHOR104,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.space	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.space	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",%nobits
	.align	1
	.set	.LANCHOR106,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.space	2
	.section	.bss.gc_valid_page_ppa,"aw",%nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 4
gc_valid_page_ppa:
	.space	4
	.section	.bss.gpNandParaInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR34,. + 0
	.type	gpNandParaInfo, %object
	.size	gpNandParaInfo, 4
gpNandParaInfo:
	.space	4
	.section	.bss.gp_blk_info,"aw",%nobits
	.align	2
	.set	.LANCHOR57,. + 0
	.type	gp_blk_info, %object
	.size	gp_blk_info, 4
gp_blk_info:
	.space	4
	.section	.bss.gp_flash_info,"aw",%nobits
	.align	2
	.set	.LANCHOR5,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 4
gp_flash_info:
	.space	4
	.section	.bss.gp_ftl_ext_info,"aw",%nobits
	.align	2
	.set	.LANCHOR60,. + 0
	.type	gp_ftl_ext_info, %object
	.size	gp_ftl_ext_info, 4
gp_ftl_ext_info:
	.space	4
	.section	.bss.gp_ftl_info,"aw",%nobits
	.align	2
	.set	.LANCHOR46,. + 0
	.type	gp_ftl_info, %object
	.size	gp_ftl_info, 4
gp_ftl_info:
	.space	4
	.section	.bss.gp_nandc,"aw",%nobits
	.align	2
	.set	.LANCHOR6,. + 0
	.type	gp_nandc, %object
	.size	gp_nandc, 4
gp_nandc:
	.space	4
	.section	.bss.lpa_hash,"aw",%nobits
	.align	1
	.set	.LANCHOR81,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.space	512
	.section	.bss.lpa_hash_index,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	lpa_hash_index, %object
	.size	lpa_hash_index, 4
lpa_hash_index:
	.space	4
	.section	.bss.nandc_hw_seed,"aw",%nobits
	.set	.LANCHOR28,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.space	1
	.section	.bss.nandc_randomizer_en,"aw",%nobits
	.set	.LANCHOR29,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.space	1
	.section	.bss.p_free_buf_head,"aw",%nobits
	.set	.LANCHOR37,. + 0
	.type	p_free_buf_head, %object
	.size	p_free_buf_head, 1
p_free_buf_head:
	.space	1
	.section	.bss.p_read_ahead_ext_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR50,. + 0
	.type	p_read_ahead_ext_buf, %object
	.size	p_read_ahead_ext_buf, 4
p_read_ahead_ext_buf:
	.space	4
	.section	.bss.pm_gc_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.space	4
	.section	.bss.pm_last_load_ram_id,"aw",%nobits
	.set	.LANCHOR151,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.space	1
	.section	.bss.pm_last_update_ram_id,"aw",%nobits
	.set	.LANCHOR94,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.space	1
	.section	.bss.pm_ram_info,"aw",%nobits
	.align	2
	.set	.LANCHOR93,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 256
pm_ram_info:
	.space	256
	.section	.bss.read_ahead_lpa,"aw",%nobits
	.align	2
	.set	.LANCHOR49,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.space	4
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR62,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.space	1
	.section	.bss.sblk_queue_head,"aw",%nobits
	.set	.LANCHOR90,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.space	1
	.section	.bss.sblk_read_completed_queue_head,"aw",%nobits
	.set	.LANCHOR51,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.space	1
	.section	.bss.sblk_write_completed_queue_head,"aw",%nobits
	.set	.LANCHOR88,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.space	1
	.section	.bss.write_buf_count,"aw",%nobits
	.set	.LANCHOR43,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.space	1
	.section	.bss.write_buf_head,"aw",%nobits
	.set	.LANCHOR42,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.space	1
	.section	.bss.write_commit_count,"aw",%nobits
	.set	.LANCHOR89,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.space	1
	.section	.bss.write_commit_head,"aw",%nobits
	.set	.LANCHOR127,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.space	1
	.section	.data.NandFlashParaTbl,"aw",%progbits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	NandFlashParaTbl, %object
	.size	NandFlashParaTbl, 768
NandFlashParaTbl:
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	758
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	60
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	1478
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-93
	.byte	118
	.byte	81
	.byte	1
	.byte	1
	.byte	32
	.short	384
	.byte	3
	.byte	2
	.short	1446
	.short	1497
	.byte	0
	.byte	36
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17857
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17857
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	17881
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
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
	.short	9695
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.short	512
	.byte	1
	.byte	-38
	.byte	-33
	.byte	0
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
	.short	512
	.byte	2
	.byte	0
	.byte	0
	.byte	0
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
	.short	256
	.byte	2
	.byte	0
	.byte	0
	.byte	0
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
	.short	512
	.byte	2
	.byte	0
	.byte	0
	.byte	0
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
	.short	512
	.byte	0
	.byte	0
	.byte	0
	.byte	0
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
	.byte	4
	.byte	0
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
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
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
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
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
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
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
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
	.short	256
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.data.NandOptPara,"aw",%progbits
	.set	.LANCHOR143,. + 0
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
	.section	.data.gNandParaInfo,"aw",%progbits
	.align	1
	.set	.LANCHOR19,. + 0
	.type	gNandParaInfo, %object
	.size	gNandParaInfo, 32
gNandParaInfo:
	.byte	6
	.byte	-104
	.byte	58
	.byte	-104
	.byte	-77
	.byte	118
	.byte	114
	.byte	1
	.byte	1
	.byte	32
	.short	768
	.byte	3
	.byte	2
	.short	758
	.short	5593
	.byte	0
	.byte	37
	.byte	60
	.byte	32
	.byte	2
	.byte	1
	.byte	4
	.byte	0
	.short	256
	.byte	1
	.byte	-94
	.byte	0
	.byte	0
	.section	.data.hy_f26_ref_value,"aw",%progbits
	.set	.LANCHOR110,. + 0
	.type	hy_f26_ref_value, %object
	.size	hy_f26_ref_value, 28
hy_f26_ref_value:
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
	.section	.data.sd15_slc_rr,"aw",%progbits
	.set	.LANCHOR18,. + 0
	.type	sd15_slc_rr, %object
	.size	sd15_slc_rr, 25
sd15_slc_rr:
	.byte	0
	.byte	8
	.byte	-8
	.byte	16
	.byte	-16
	.byte	24
	.byte	-24
	.byte	32
	.byte	-32
	.byte	32
	.byte	-40
	.byte	48
	.byte	-48
	.byte	56
	.byte	-56
	.byte	64
	.byte	-64
	.byte	72
	.byte	-72
	.byte	80
	.byte	-80
	.byte	88
	.byte	96
	.byte	104
	.byte	112
	.section	.data.sd15_tlc_rr,"aw",%progbits
	.set	.LANCHOR17,. + 0
	.type	sd15_tlc_rr, %object
	.size	sd15_tlc_rr, 329
sd15_tlc_rr:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	16
	.byte	8
	.byte	8
	.byte	0
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	0
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-32
	.byte	0
	.byte	8
	.byte	-8
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	0
	.byte	-16
	.byte	-24
	.byte	-16
	.byte	8
	.byte	8
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	0
	.byte	8
	.byte	8
	.byte	8
	.byte	8
	.byte	-8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	-16
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	0
	.byte	8
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-24
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-24
	.byte	-8
	.byte	8
	.byte	-8
	.byte	0
	.byte	-8
	.byte	8
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-8
	.byte	8
	.byte	-8
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-16
	.byte	8
	.byte	0
	.byte	8
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-16
	.byte	16
	.byte	0
	.byte	16
	.byte	0
	.byte	-8
	.byte	8
	.byte	0
	.byte	-24
	.byte	0
	.byte	-16
	.byte	-8
	.byte	-16
	.byte	-16
	.byte	-16
	.byte	-16
	.byte	0
	.byte	8
	.byte	-8
	.byte	-24
	.byte	0
	.byte	8
	.byte	8
	.byte	16
	.byte	16
	.byte	0
	.byte	8
	.byte	-8
	.byte	8
	.byte	16
	.byte	-8
	.byte	24
	.byte	0
	.byte	8
	.byte	-4
	.byte	0
	.byte	16
	.byte	8
	.byte	24
	.byte	8
	.byte	0
	.byte	-4
	.byte	-8
	.byte	24
	.byte	16
	.byte	16
	.byte	0
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	4
	.byte	0
	.byte	-4
	.byte	-4
	.byte	-4
	.byte	8
	.byte	8
	.byte	16
	.byte	0
	.byte	16
	.byte	-4
	.byte	16
	.byte	0
	.byte	16
	.byte	8
	.byte	0
	.byte	16
	.byte	-4
	.byte	16
	.byte	-8
	.byte	0
	.byte	0
	.byte	-8
	.byte	16
	.byte	-4
	.byte	16
	.byte	-16
	.byte	-8
	.byte	-8
	.byte	-8
	.byte	8
	.byte	-4
	.byte	8
	.byte	-24
	.byte	4
	.byte	-16
	.byte	0
	.byte	8
	.byte	0
	.byte	0
	.byte	-24
	.byte	8
	.byte	-16
	.byte	8
	.byte	0
	.byte	8
	.byte	-24
	.byte	-32
	.byte	16
	.byte	-24
	.byte	8
	.byte	-8
	.byte	8
	.byte	-24
	.byte	-32
	.byte	8
	.byte	0
	.byte	16
	.byte	0
	.byte	16
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	-8
	.byte	-16
	.byte	-8
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	8
	.byte	-24
	.byte	8
	.byte	0
	.byte	-32
	.byte	4
	.byte	0
	.byte	0
	.byte	-32
	.byte	-4
	.byte	0
	.byte	-24
	.byte	4
	.byte	0
	.byte	16
	.byte	-24
	.byte	16
	.byte	0
	.byte	-24
	.byte	-4
	.byte	0
	.byte	8
	.byte	-32
	.byte	8
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	-8
	.byte	0
	.byte	-8
	.byte	0
	.byte	0
	.byte	-4
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-8
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-16
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	-24
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-16
	.byte	0
	.byte	-16
	.byte	0
	.byte	0
	.byte	-24
	.byte	0
	.byte	-32
	.byte	0
	.byte	-32
	.byte	0
	.section	.data.tlc_prog_order,"aw",%progbits
	.align	1
	.set	.LANCHOR171,. + 0
	.type	tlc_prog_order, %object
	.size	tlc_prog_order, 768
tlc_prog_order:
	.short	1
	.short	9
	.short	2
	.short	17
	.short	10
	.short	3
	.short	25
	.short	18
	.short	11
	.short	33
	.short	26
	.short	19
	.short	41
	.short	34
	.short	27
	.short	49
	.short	42
	.short	35
	.short	57
	.short	50
	.short	43
	.short	65
	.short	58
	.short	51
	.short	73
	.short	66
	.short	59
	.short	81
	.short	74
	.short	67
	.short	89
	.short	82
	.short	75
	.short	97
	.short	90
	.short	83
	.short	105
	.short	98
	.short	91
	.short	113
	.short	106
	.short	99
	.short	121
	.short	114
	.short	107
	.short	129
	.short	122
	.short	115
	.short	137
	.short	130
	.short	123
	.short	145
	.short	138
	.short	131
	.short	153
	.short	146
	.short	139
	.short	161
	.short	154
	.short	147
	.short	169
	.short	162
	.short	155
	.short	177
	.short	170
	.short	163
	.short	185
	.short	178
	.short	171
	.short	193
	.short	186
	.short	179
	.short	201
	.short	194
	.short	187
	.short	209
	.short	202
	.short	195
	.short	217
	.short	210
	.short	203
	.short	225
	.short	218
	.short	211
	.short	233
	.short	226
	.short	219
	.short	241
	.short	234
	.short	227
	.short	249
	.short	242
	.short	235
	.short	257
	.short	250
	.short	243
	.short	265
	.short	258
	.short	251
	.short	273
	.short	266
	.short	259
	.short	281
	.short	274
	.short	267
	.short	289
	.short	282
	.short	275
	.short	297
	.short	290
	.short	283
	.short	305
	.short	298
	.short	291
	.short	313
	.short	306
	.short	299
	.short	321
	.short	314
	.short	307
	.short	329
	.short	322
	.short	315
	.short	337
	.short	330
	.short	323
	.short	345
	.short	338
	.short	331
	.short	353
	.short	346
	.short	339
	.short	361
	.short	354
	.short	347
	.short	369
	.short	362
	.short	355
	.short	377
	.short	370
	.short	363
	.short	385
	.short	378
	.short	371
	.short	393
	.short	386
	.short	379
	.short	401
	.short	394
	.short	387
	.short	409
	.short	402
	.short	395
	.short	417
	.short	410
	.short	403
	.short	425
	.short	418
	.short	411
	.short	433
	.short	426
	.short	419
	.short	441
	.short	434
	.short	427
	.short	449
	.short	442
	.short	435
	.short	457
	.short	450
	.short	443
	.short	465
	.short	458
	.short	451
	.short	473
	.short	466
	.short	459
	.short	481
	.short	474
	.short	467
	.short	489
	.short	482
	.short	475
	.short	497
	.short	490
	.short	483
	.short	505
	.short	498
	.short	491
	.short	513
	.short	506
	.short	499
	.short	521
	.short	514
	.short	507
	.short	529
	.short	522
	.short	515
	.short	537
	.short	530
	.short	523
	.short	545
	.short	538
	.short	531
	.short	553
	.short	546
	.short	539
	.short	561
	.short	554
	.short	547
	.short	569
	.short	562
	.short	555
	.short	577
	.short	570
	.short	563
	.short	585
	.short	578
	.short	571
	.short	593
	.short	586
	.short	579
	.short	601
	.short	594
	.short	587
	.short	609
	.short	602
	.short	595
	.short	617
	.short	610
	.short	603
	.short	625
	.short	618
	.short	611
	.short	633
	.short	626
	.short	619
	.short	641
	.short	634
	.short	627
	.short	649
	.short	642
	.short	635
	.short	657
	.short	650
	.short	643
	.short	665
	.short	658
	.short	651
	.short	673
	.short	666
	.short	659
	.short	681
	.short	674
	.short	667
	.short	689
	.short	682
	.short	675
	.short	697
	.short	690
	.short	683
	.short	705
	.short	698
	.short	691
	.short	713
	.short	706
	.short	699
	.short	721
	.short	714
	.short	707
	.short	729
	.short	722
	.short	715
	.short	737
	.short	730
	.short	723
	.short	745
	.short	738
	.short	731
	.short	753
	.short	746
	.short	739
	.short	761
	.short	754
	.short	747
	.short	769
	.short	762
	.short	755
	.short	777
	.short	770
	.short	763
	.short	785
	.short	778
	.short	771
	.short	793
	.short	786
	.short	779
	.short	801
	.short	794
	.short	787
	.short	809
	.short	802
	.short	795
	.short	817
	.short	810
	.short	803
	.short	825
	.short	818
	.short	811
	.short	833
	.short	826
	.short	819
	.short	841
	.short	834
	.short	827
	.short	849
	.short	842
	.short	835
	.short	857
	.short	850
	.short	843
	.short	865
	.short	858
	.short	851
	.short	873
	.short	866
	.short	859
	.short	881
	.short	874
	.short	867
	.short	889
	.short	882
	.short	875
	.short	897
	.short	890
	.short	883
	.short	905
	.short	898
	.short	891
	.short	913
	.short	906
	.short	899
	.short	921
	.short	914
	.short	907
	.short	929
	.short	922
	.short	915
	.short	937
	.short	930
	.short	923
	.short	945
	.short	938
	.short	931
	.short	953
	.short	946
	.short	939
	.short	961
	.short	954
	.short	947
	.short	969
	.short	962
	.short	955
	.short	977
	.short	970
	.short	963
	.short	985
	.short	978
	.short	971
	.short	993
	.short	986
	.short	979
	.short	1001
	.short	994
	.short	987
	.short	1009
	.short	1002
	.short	995
	.short	1017
	.short	1010
	.short	1003
	.short	1018
	.short	1011
	.short	1019
	.section	.data.zftl_debug,"aw",%progbits
	.align	2
	.set	.LANCHOR22,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.rodata.__func__.10178,"a",%progbits
	.set	.LANCHOR39,. + 0
	.type	__func__.10178, %object
	.size	__func__.10178, 13
__func__.10178:
	.ascii	"buf_add_tail\000"
	.section	.rodata.__func__.10191,"a",%progbits
	.set	.LANCHOR40,. + 0
	.type	__func__.10191, %object
	.size	__func__.10191, 10
__func__.10191:
	.ascii	"buf_alloc\000"
	.section	.rodata.__func__.10205,"a",%progbits
	.set	.LANCHOR41,. + 0
	.type	__func__.10205, %object
	.size	__func__.10205, 16
__func__.10205:
	.ascii	"buf_remove_free\000"
	.section	.rodata.__func__.10313,"a",%progbits
	.set	.LANCHOR100,. + 0
	.type	__func__.10313, %object
	.size	__func__.10313, 17
__func__.10313:
	.ascii	"lpa_rebuild_hash\000"
	.section	.rodata.__func__.10365,"a",%progbits
	.set	.LANCHOR167,. + 0
	.type	__func__.10365, %object
	.size	__func__.10365, 17
__func__.10365:
	.ascii	"ftl_write_commit\000"
	.section	.rodata.__func__.10376,"a",%progbits
	.set	.LANCHOR44,. + 0
	.type	__func__.10376, %object
	.size	__func__.10376, 14
__func__.10376:
	.ascii	"ftl_write_buf\000"
	.section	.rodata.__func__.10424,"a",%progbits
	.set	.LANCHOR152,. + 0
	.type	__func__.10424, %object
	.size	__func__.10424, 15
__func__.10424:
	.ascii	"ftl_read_ahead\000"
	.section	.rodata.__func__.10432,"a",%progbits
	.set	.LANCHOR48,. + 0
	.type	__func__.10432, %object
	.size	__func__.10432, 13
__func__.10432:
	.ascii	"ftl_read_buf\000"
	.section	.rodata.__func__.10470,"a",%progbits
	.set	.LANCHOR157,. + 0
	.type	__func__.10470, %object
	.size	__func__.10470, 9
__func__.10470:
	.ascii	"ftl_read\000"
	.section	.rodata.__func__.10496,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.10496, %object
	.size	__func__.10496, 12
__func__.10496:
	.ascii	"ftl_discard\000"
	.section	.rodata.__func__.10517,"a",%progbits
	.set	.LANCHOR158,. + 0
	.type	__func__.10517, %object
	.size	__func__.10517, 10
__func__.10517:
	.ascii	"vpn_check\000"
	.section	.rodata.__func__.10542,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.10542, %object
	.size	__func__.10542, 15
__func__.10542:
	.ascii	"ftl_info_check\000"
	.section	.rodata.__func__.10651,"a",%progbits
	.set	.LANCHOR55,. + 0
	.type	__func__.10651, %object
	.size	__func__.10651, 12
__func__.10651:
	.ascii	"gc_add_sblk\000"
	.section	.rodata.__func__.10694,"a",%progbits
	.set	.LANCHOR122,. + 0
	.type	__func__.10694, %object
	.size	__func__.10694, 21
__func__.10694:
	.ascii	"gc_check_data_one_wl\000"
	.section	.rodata.__func__.10728,"a",%progbits
	.set	.LANCHOR153,. + 0
	.type	__func__.10728, %object
	.size	__func__.10728, 22
__func__.10728:
	.ascii	"gc_update_l2p_map_new\000"
	.section	.rodata.__func__.10741,"a",%progbits
	.set	.LANCHOR63,. + 0
	.type	__func__.10741, %object
	.size	__func__.10741, 19
__func__.10741:
	.ascii	"gc_write_completed\000"
	.section	.rodata.__func__.10770,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.10770, %object
	.size	__func__.10770, 16
__func__.10770:
	.ascii	"gc_do_copy_back\000"
	.section	.rodata.__func__.10792,"a",%progbits
	.set	.LANCHOR73,. + 0
	.type	__func__.10792, %object
	.size	__func__.10792, 16
__func__.10792:
	.ascii	"gc_free_src_blk\000"
	.section	.rodata.__func__.10837,"a",%progbits
	.set	.LANCHOR160,. + 0
	.type	__func__.10837, %object
	.size	__func__.10837, 16
__func__.10837:
	.ascii	"gc_scan_src_blk\000"
	.section	.rodata.__func__.10869,"a",%progbits
	.set	.LANCHOR156,. + 0
	.type	__func__.10869, %object
	.size	__func__.10869, 18
__func__.10869:
	.ascii	"gc_search_src_blk\000"
	.section	.rodata.__func__.10885,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.10885, %object
	.size	__func__.10885, 20
__func__.10885:
	.ascii	"gc_scan_static_data\000"
	.section	.rodata.__func__.10946,"a",%progbits
	.set	.LANCHOR172,. + 0
	.type	__func__.10946, %object
	.size	__func__.10946, 6
__func__.10946:
	.ascii	"do_gc\000"
	.section	.rodata.__func__.11007,"a",%progbits
	.set	.LANCHOR132,. + 0
	.type	__func__.11007, %object
	.size	__func__.11007, 15
__func__.11007:
	.ascii	"ftl_info_flush\000"
	.section	.rodata.__func__.11056,"a",%progbits
	.set	.LANCHOR72,. + 0
	.type	__func__.11056, %object
	.size	__func__.11056, 14
__func__.11056:
	.ascii	"ftl_free_sblk\000"
	.section	.rodata.__func__.11088,"a",%progbits
	.set	.LANCHOR77,. + 0
	.type	__func__.11088, %object
	.size	__func__.11088, 18
__func__.11088:
	.ascii	"ftl_alloc_sys_blk\000"
	.section	.rodata.__func__.11098,"a",%progbits
	.set	.LANCHOR78,. + 0
	.type	__func__.11098, %object
	.size	__func__.11098, 17
__func__.11098:
	.ascii	"ftl_free_sys_blk\000"
	.section	.rodata.__func__.11132,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.11132, %object
	.size	__func__.11132, 14
__func__.11132:
	.ascii	"ftl_sblk_dump\000"
	.section	.rodata.__func__.11156,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.11156, %object
	.size	__func__.11156, 16
__func__.11156:
	.ascii	"ftl_sysblk_dump\000"
	.section	.rodata.__func__.11175,"a",%progbits
	.set	.LANCHOR139,. + 0
	.type	__func__.11175, %object
	.size	__func__.11175, 23
__func__.11175:
	.ascii	"ftl_open_sblk_recovery\000"
	.section	.rodata.__func__.11200,"a",%progbits
	.set	.LANCHOR80,. + 0
	.type	__func__.11200, %object
	.size	__func__.11200, 23
__func__.11200:
	.ascii	"ftl_get_ppa_from_index\000"
	.section	.rodata.__func__.11221,"a",%progbits
	.set	.LANCHOR166,. + 0
	.type	__func__.11221, %object
	.size	__func__.11221, 19
__func__.11221:
	.ascii	"ftl_update_l2p_map\000"
	.section	.rodata.__func__.11240,"a",%progbits
	.set	.LANCHOR84,. + 0
	.type	__func__.11240, %object
	.size	__func__.11240, 22
__func__.11240:
	.ascii	"ftl_get_new_free_page\000"
	.section	.rodata.__func__.11251,"a",%progbits
	.set	.LANCHOR85,. + 0
	.type	__func__.11251, %object
	.size	__func__.11251, 22
__func__.11251:
	.ascii	"ftl_ext_alloc_new_blk\000"
	.section	.rodata.__func__.11276,"a",%progbits
	.set	.LANCHOR134,. + 0
	.type	__func__.11276, %object
	.size	__func__.11276, 19
__func__.11276:
	.ascii	"ftl_ext_info_flush\000"
	.section	.rodata.__func__.11288,"a",%progbits
	.set	.LANCHOR135,. + 0
	.type	__func__.11288, %object
	.size	__func__.11288, 18
__func__.11288:
	.ascii	"ftl_ext_info_init\000"
	.section	.rodata.__func__.11333,"a",%progbits
	.set	.LANCHOR136,. + 0
	.type	__func__.11333, %object
	.size	__func__.11333, 15
__func__.11333:
	.ascii	"ftl_low_format\000"
	.section	.rodata.__func__.11377,"a",%progbits
	.set	.LANCHOR138,. + 0
	.type	__func__.11377, %object
	.size	__func__.11377, 23
__func__.11377:
	.ascii	"ftl_re_low_format_test\000"
	.section	.rodata.__func__.11387,"a",%progbits
	.set	.LANCHOR129,. + 0
	.type	__func__.11387, %object
	.size	__func__.11387, 14
__func__.11387:
	.ascii	"ftl_prog_page\000"
	.section	.rodata.__func__.11562,"a",%progbits
	.set	.LANCHOR126,. + 0
	.type	__func__.11562, %object
	.size	__func__.11562, 15
__func__.11562:
	.ascii	"sblk_prog_page\000"
	.section	.rodata.__func__.11621,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.11621, %object
	.size	__func__.11621, 16
__func__.11621:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.11635,"a",%progbits
	.set	.LANCHOR102,. + 0
	.type	__func__.11635, %object
	.size	__func__.11635, 13
__func__.11635:
	.ascii	"pm_free_sblk\000"
	.section	.rodata.__func__.11655,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.11655, %object
	.size	__func__.11655, 6
__func__.11655:
	.ascii	"pm_gc\000"
	.section	.rodata.__func__.11671,"a",%progbits
	.set	.LANCHOR92,. + 0
	.type	__func__.11671, %object
	.size	__func__.11671, 17
__func__.11671:
	.ascii	"pm_alloc_new_blk\000"
	.section	.rodata.__func__.11681,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.11681, %object
	.size	__func__.11681, 14
__func__.11681:
	.ascii	"pm_write_page\000"
	.section	.rodata.__func__.11699,"a",%progbits
	.set	.LANCHOR95,. + 0
	.type	__func__.11699, %object
	.size	__func__.11699, 21
__func__.11699:
	.ascii	"pm_select_ram_region\000"
	.section	.rodata.__func__.9485,"a",%progbits
	.set	.LANCHOR114,. + 0
	.type	__func__.9485, %object
	.size	__func__.9485, 19
__func__.9485:
	.ascii	"flash_read_page_en\000"
	.section	.rodata.__func__.9514,"a",%progbits
	.set	.LANCHOR128,. + 0
	.type	__func__.9514, %object
	.size	__func__.9514, 19
__func__.9514:
	.ascii	"flash_prog_page_en\000"
	.section	.rodata.__func__.9529,"a",%progbits
	.set	.LANCHOR21,. + 0
	.type	__func__.9529, %object
	.size	__func__.9529, 26
__func__.9529:
	.ascii	"flash_erase_duplane_block\000"
	.section	.rodata.__func__.9540,"a",%progbits
	.set	.LANCHOR24,. + 0
	.type	__func__.9540, %object
	.size	__func__.9540, 21
__func__.9540:
	.ascii	"flash_erase_block_en\000"
	.section	.rodata.__func__.9554,"a",%progbits
	.set	.LANCHOR9,. + 0
	.type	__func__.9554, %object
	.size	__func__.9554, 28
__func__.9554:
	.ascii	"flash_wait_device_ready_raw\000"
	.section	.rodata.__func__.9579,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.9579, %object
	.size	__func__.9579, 26
__func__.9579:
	.ascii	"flash_start_tlc_page_prog\000"
	.section	.rodata.__func__.9592,"a",%progbits
	.set	.LANCHOR125,. + 0
	.type	__func__.9592, %object
	.size	__func__.9592, 22
__func__.9592:
	.ascii	"flash_start_page_prog\000"
	.section	.rodata.__func__.9605,"a",%progbits
	.set	.LANCHOR33,. + 0
	.type	__func__.9605, %object
	.size	__func__.9605, 22
__func__.9605:
	.ascii	"flash_start_page_read\000"
	.section	.rodata.__func__.9620,"a",%progbits
	.set	.LANCHOR120,. + 0
	.type	__func__.9620, %object
	.size	__func__.9620, 25
__func__.9620:
	.ascii	"flash_complete_page_read\000"
	.section	.rodata.do_gc.str1.1,"aMS",%progbits,1
.LC153:
	.ascii	"gc %d: %d %d %d %d %d %d\012\000"
.LC154:
	.ascii	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\012"
	.ascii	"\000"
.LC155:
	.ascii	"gc free %x, %d\012\000"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",%progbits,1
.LC81:
	.ascii	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\012\000"
.LC82:
	.ascii	"ftl_ext_info_blk blk:0x%x, page:0x%x\012\000"
.LC83:
	.ascii	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC84:
	.ascii	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, pag"
	.ascii	"e_index:0x%x\012\000"
.LC85:
	.ascii	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page"
	.ascii	"_index:0x%x\012\000"
.LC86:
	.ascii	"lpa:\000"
.LC87:
	.ascii	"vpn:\000"
.LC88:
	.ascii	"sblk:\000"
.LC89:
	.ascii	"lpa_hash:\000"
.LC90:
	.ascii	"lpa_hash_index:\000"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",%progbits,1
.LC24:
	.ascii	"dump_sblk_queue: %d\012\000"
.LC25:
	.ascii	"buf id= %d state = %d ppa = %x\012\000"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",%progbits,1
.LC54:
	.ascii	"flash_complete_page_read %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_ddr_tunning_read.str1.1,"aMS",%progbits,1
.LC48:
	.ascii	"%d flash_ddr_tunning_read %x ecc=%d\012\000"
.LC49:
	.ascii	"sync para %d\012\000"
.LC50:
	.ascii	"DDR mode Read error %x %x\012\000"
	.section	.rodata.flash_erase_all.str1.1,"aMS",%progbits,1
.LC5:
	.ascii	"erase done: %x\012\000"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",%progbits,1
.LC3:
	.ascii	"flash_erase_block %x %x\012\000"
.LC4:
	.ascii	"flash_erase_block block = %x status = %x\012\000"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"flash_erase_duplane_block %x %x %x\012\000"
.LC2:
	.ascii	"flash_erase_duplane_block pageadd = %x status = %x\012"
	.ascii	"\000"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",%progbits,1
.LC53:
	.ascii	"no sys info %x\012\000"
	.section	.rodata.flash_info_flush.str1.1,"aMS",%progbits,1
.LC77:
	.ascii	"finfo:\000"
.LC78:
	.ascii	"flash_info_flush id = %x, page = %x\012\000"
.LC79:
	.ascii	"sys_info_flush error:%x\012\000"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",%progbits,1
.LC6:
	.ascii	"flash_mask_bad_block %d %d\012\000"
	.section	.rodata.flash_prog_page.str1.1,"aMS",%progbits,1
.LC57:
	.ascii	"flash_prog_page %x %x %x\012\000"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",%progbits,1
.LC59:
	.ascii	"flash_prog_page_en:%x %x\012\000"
.LC60:
	.ascii	"spare\000"
.LC61:
	.ascii	"data\000"
.LC62:
	.ascii	"write error: %x\012\000"
	.section	.rodata.flash_read_page.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"flash_read_page %x %x %x\012\000"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",%progbits,1
.LC51:
	.ascii	"flash_read_page_en %x %x\012\000"
.LC52:
	.ascii	"flash_read_page_en %x %x error_ecc %d %d\012\000"
	.section	.rodata.flash_wait_device_ready_raw.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",%progbits,1
.LC14:
	.ascii	"ftl_alloc_sblk %x, %d %d %d\012\000"
	.section	.rodata.ftl_discard.str1.1,"aMS",%progbits,1
.LC148:
	.ascii	"ftl_discard:(%x, %x, %x, %x)\012\000"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",%progbits,1
.LC65:
	.ascii	"%d %x @%d %x\012\000"
.LC66:
	.ascii	"ftl_info_blk_init %d %d %x\012\000"
	.section	.rodata.ftl_info_check.str1.1,"aMS",%progbits,1
.LC122:
	.ascii	"free blk vpn error: %x %x\012\000"
.LC123:
	.ascii	"data blk: %d %d %d\012\000"
.LC124:
	.ascii	"free blk: %d %d %d\012\000"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",%progbits,1
.LC64:
	.ascii	"g_ftl_info_blk blk = %x, page = %x version = %d\012"
	.ascii	"\000"
	.section	.rodata.ftl_init.str1.1,"aMS",%progbits,1
.LC139:
	.ascii	"FTL version: 6.0.3 20180211\000"
.LC140:
	.ascii	"gp_ftl_ext_info %p %p %p\012\000"
.LC141:
	.ascii	"flash info size: %d %d %d\012\000"
	.section	.rodata.ftl_low_format.str1.1,"aMS",%progbits,1
.LC67:
	.ascii	"low format %d %d %d %d\012\000"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",%progbits,1
.LC19:
	.ascii	"mask bad block:cs %x block: %x\012\000"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",%progbits,1
.LC69:
	.ascii	"saved_active_page  = %x\012\000"
.LC70:
	.ascii	"saved_active_plane = %x\012\000"
.LC71:
	.ascii	"sblk = %x\012\000"
.LC72:
	.ascii	"phy_blk = %x %x\012\000"
.LC73:
	.ascii	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x"
	.ascii	" %x %x, spare: %x %x %x %x\012\000"
.LC74:
	.ascii	"sblk = %x, vpn0 = %d, vpn1 = %d\012\000"
.LC75:
	.ascii	"dump write = %x\012\000"
	.section	.rodata.ftl_re_low_format_test.str1.1,"aMS",%progbits,1
.LC68:
	.ascii	"re low formaet %d\012\000"
	.section	.rodata.ftl_read.str1.1,"aMS",%progbits,1
.LC114:
	.ascii	"ftl_read refresh =%x, lpa = %x, ppa= %x\012\000"
	.section	.rodata.ftl_read_ahead.str1.1,"aMS",%progbits,1
.LC100:
	.ascii	"ftl_read_ahead refresh =%x, lpa = %x, ppa= %x\012\000"
.LC101:
	.ascii	"id=%d, lpa = %x, ppa = %x spare = %x %x %x %x\012\000"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",%progbits,1
.LC107:
	.ascii	"ftl_sblk_dump = %x %x %x %x\012\000"
.LC108:
	.ascii	"page_addr = %x, lpa=%x vpn = %d\012\000"
.LC109:
	.ascii	"index= %x, lpa=%x\012\000"
.LC110:
	.ascii	"block = %x, vpn=%x check vpn = %d\012\000"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",%progbits,1
.LC127:
	.ascii	"ftl_scan_all_data = %x\012\000"
.LC128:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC129:
	.ascii	"lba = %x,addr= %x, ststus = %x, spare= %x %x %x %x "
	.ascii	"data=%x %x\012\000"
.LC130:
	.ascii	"lba = %x, id= %x, index = %x hash ppa = %x\012\000"
.LC131:
	.ascii	"0pm:\000"
.LC132:
	.ascii	"1pm:\000"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",%progbits,1
.LC80:
	.ascii	"l2p:\000"
	.section	.rodata.ftl_test_block.str1.1,"aMS",%progbits,1
.LC63:
	.ascii	"low format %d\012\000"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",%progbits,1
.LC143:
	.ascii	"ftl_update_l2p_map: %x %x %x\012\000"
.LC144:
	.ascii	"ftl_update_l2p_map\000"
.LC145:
	.ascii	"lpa_tbl:\000"
.LC146:
	.ascii	"sblk %x vpn: %d %d\012\000"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",%progbits,1
.LC17:
	.ascii	"ftl_vpn_decrement %x = %d\012\000"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",%progbits,1
.LC147:
	.ascii	"%d read error: ppa:%x, lpa:%x, status:%x\012\000"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"ftl prog error =%x, lpa = %x, ppa= %x\012\000"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",%progbits,1
.LC7:
	.ascii	"gc_add_sblk = %d, %d, %d, %d, %d, %d\012\000"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",%progbits,1
.LC56:
	.ascii	"1ppa = %x, status = %x, %x %x spare: %x %x %x %x\012"
	.ascii	"\000"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",%progbits,1
.LC149:
	.ascii	"gc page in buf: lpa %x ppa = %x pageindex= %x\012\000"
.LC150:
	.ascii	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x "
	.ascii	"page_index= %d\012\000"
.LC151:
	.ascii	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\012\000"
.LC152:
	.ascii	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id "
	.ascii	"= %x plane = %x lpa=%x\012\000"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",%progbits,1
.LC15:
	.ascii	"gc_free_src_blk = %x, vpn = %d\012\000"
.LC16:
	.ascii	"gc_free_src_blk %x, %d\012\000"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",%progbits,1
.LC10:
	.ascii	"%d gc_free_temp_buf buf id= %x\012\000"
	.section	.rodata.gc_recovery.str1.1,"aMS",%progbits,1
.LC133:
	.ascii	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x "
	.ascii	"%x %x %x\012\000"
.LC134:
	.ascii	"gc_lpa:\000"
.LC135:
	.ascii	"gc_ppa:\000"
.LC136:
	.ascii	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\012"
	.ascii	"\000"
.LC137:
	.ascii	"gc_recovery\000"
.LC138:
	.ascii	"gc_recovery: %x vpn = %x\012\000"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",%progbits,1
.LC125:
	.ascii	"gc_scan_src_blk = %x, vpn = %d\012\000"
.LC126:
	.ascii	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\012\000"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",%progbits,1
.LC111:
	.ascii	"gc_search_src_blk = %d, %d, %d\012\000"
.LC112:
	.ascii	"vpn gc = %d, id = %d\012\000"
.LC113:
	.ascii	"gc_search_src_blk count= %d\012\000"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",%progbits,1
.LC11:
	.ascii	"gc_static_wearleveling: slc blk: %d, tlc blk: %d av"
	.ascii	"g slc ec: %d, avg tlc ec: %d \012\000"
.LC12:
	.ascii	"gc_static_wearleveling: min slc ec: %d, min tlc ec:"
	.ascii	" %d max slc ec: %d, max tlc ec: %d \012\000"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",%progbits,1
.LC102:
	.ascii	"gc_update_l2p_map_new sblk %x\012\000"
.LC103:
	.ascii	"gc_update_l2p_map_new: %x %x %x\012\000"
.LC104:
	.ascii	"0lpa: %x %x %x\012\000"
.LC105:
	.ascii	"lpa: %x %x %x\012\000"
.LC106:
	.ascii	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\012"
	.ascii	"\000"
	.section	.rodata.gc_write_completed.str1.1,"aMS",%progbits,1
.LC8:
	.ascii	"status: %x, ppa: %x\012\000"
.LC9:
	.ascii	"gc_write_completed: %x  %x  %x %x\012\000"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",%progbits,1
.LC33:
	.ascii	"otp error! %d\000"
.LC34:
	.ascii	"rr\000"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",%progbits,1
.LC47:
	.ascii	"hynix RR %d row=%x, count %d, status=%d\012\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC92:
	.ascii	"region_id = %d, pm_max_region = %d\012\000"
.LC93:
	.ascii	"load_l2p_region = %x,%x,%x, %x\012\000"
.LC94:
	.ascii	"pm_ppa:\000"
.LC95:
	.ascii	"data:\000"
.LC96:
	.ascii	"spare:\000"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",%progbits,1
.LC28:
	.ascii	"%s %d %d\012\000"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"micron %d row=%x,count %d,status=%d\012\000"
.LC43:
	.ascii	"micron RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.nandc_xfer.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"dqs data abort %x\012\000"
.LC40:
	.ascii	"xfer error %x\012\000"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",%progbits,1
.LC35:
	.ascii	"%d mtrans_cnt = %d page_num = %d\012\000"
.LC36:
	.ascii	"nandc:\000"
.LC37:
	.ascii	"%d flReg.d32=%x %x\012\000"
.LC38:
	.ascii	"nandc_xfer_done read error %x\012\000"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC26:
	.ascii	"blk %x is bad block\012\000"
.LC27:
	.ascii	"pm_alloc_new_blk: %x %x %x %x\012\000"
	.section	.rodata.pm_init.str1.1,"aMS",%progbits,1
.LC97:
	.ascii	"pm_init posr %x %x %x\012\000"
.LC98:
	.ascii	"pm_init recovery %x %x %x\012\000"
	.section	.rodata.pm_log2phys.str1.1,"aMS",%progbits,1
.LC99:
	.ascii	"pm_log2phys  lpn = %d, max lpn = %d\012\000"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",%progbits,1
.LC91:
	.ascii	"%s w error lpn = %x, max ppa = %d\012\000"
	.section	.rodata.pm_write_page.str1.1,"aMS",%progbits,1
.LC76:
	.ascii	"pm_write_page write error: %x\012\000"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",%progbits,1
.LC20:
	.ascii	"free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn:"
	.ascii	" s:%x t:%x\012\000"
.LC21:
	.ascii	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\012\000"
.LC22:
	.ascii	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\012\000"
.LC23:
	.ascii	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\012\000"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",%progbits,1
.LC13:
	.ascii	"gc: b:%x,p:%x,i:%x; free buf=%d %d\012\000"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"set buf %d,status = %x, ppa = %x lun state = %d\012"
	.ascii	"\000"
	.section	.rodata.random_seed,"a",%progbits
	.align	1
	.set	.LANCHOR32,. + 0
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
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC142:
	.ascii	"ftl_init %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC29:
	.ascii	"%s 0x%x:\000"
.LC30:
	.ascii	"%x \000"
.LC31:
	.ascii	"\000"
.LC32:
	.ascii	"%s\012\000"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",%progbits,1
.LC58:
	.ascii	"sblk_prog_page ppa = %x, count = %d\012\000"
	.section	.rodata.toshiba_15ref_value,"a",%progbits
	.set	.LANCHOR2,. + 0
	.type	toshiba_15ref_value, %object
	.size	toshiba_15ref_value, 95
toshiba_15ref_value:
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
	.section	.rodata.toshiba_3D_slc_value,"a",%progbits
	.set	.LANCHOR16,. + 0
	.type	toshiba_3D_slc_value, %object
	.size	toshiba_3D_slc_value, 11
toshiba_3D_slc_value:
	.byte	-117
	.byte	0
	.byte	-8
	.byte	8
	.byte	-16
	.byte	-24
	.byte	24
	.byte	-40
	.byte	40
	.byte	-56
	.byte	56
	.section	.rodata.toshiba_3D_tlc_value,"a",%progbits
	.set	.LANCHOR15,. + 0
	.type	toshiba_3D_tlc_value, %object
	.size	toshiba_3D_tlc_value, 399
toshiba_3D_tlc_value:
	.byte	-119
	.byte	-119
	.byte	-119
	.byte	-119
	.byte	-118
	.byte	-118
	.byte	-118
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-9
	.byte	-12
	.byte	-9
	.byte	-7
	.byte	-13
	.byte	-12
	.byte	-7
	.byte	5
	.byte	-2
	.byte	-1
	.byte	0
	.byte	-3
	.byte	-2
	.byte	6
	.byte	-6
	.byte	-15
	.byte	-15
	.byte	-2
	.byte	-12
	.byte	-16
	.byte	-6
	.byte	-2
	.byte	-19
	.byte	-19
	.byte	-6
	.byte	-4
	.byte	-12
	.byte	-14
	.byte	-2
	.byte	-11
	.byte	-23
	.byte	-34
	.byte	-4
	.byte	-20
	.byte	-22
	.byte	-2
	.byte	-7
	.byte	-31
	.byte	-30
	.byte	-12
	.byte	-20
	.byte	-18
	.byte	2
	.byte	-15
	.byte	-19
	.byte	-36
	.byte	-12
	.byte	-28
	.byte	-34
	.byte	-6
	.byte	-15
	.byte	-11
	.byte	2
	.byte	-12
	.byte	-8
	.byte	-2
	.byte	2
	.byte	-3
	.byte	-7
	.byte	-10
	.byte	-4
	.byte	-8
	.byte	-6
	.byte	-6
	.byte	-11
	.byte	-27
	.byte	-38
	.byte	-16
	.byte	-12
	.byte	-2
	.byte	2
	.byte	-7
	.byte	-31
	.byte	-22
	.byte	-4
	.byte	-16
	.byte	-22
	.byte	-7
	.byte	-31
	.byte	-23
	.byte	-22
	.byte	-28
	.byte	-28
	.byte	-26
	.byte	2
	.byte	-7
	.byte	-11
	.byte	-14
	.byte	-8
	.byte	-12
	.byte	-10
	.byte	-10
	.byte	-27
	.byte	-25
	.byte	-22
	.byte	-20
	.byte	-28
	.byte	-22
	.byte	-7
	.byte	-23
	.byte	-29
	.byte	-34
	.byte	-24
	.byte	-32
	.byte	-22
	.byte	-10
	.byte	-11
	.byte	-29
	.byte	-18
	.byte	-12
	.byte	-24
	.byte	-22
	.byte	6
	.byte	1
	.byte	-3
	.byte	-6
	.byte	0
	.byte	-4
	.byte	-2
	.byte	10
	.byte	-3
	.byte	-7
	.byte	-6
	.byte	4
	.byte	-4
	.byte	-2
	.byte	-10
	.byte	-23
	.byte	-39
	.byte	-22
	.byte	-19
	.byte	-24
	.byte	-18
	.byte	-14
	.byte	-23
	.byte	-29
	.byte	-30
	.byte	-15
	.byte	-30
	.byte	-30
	.byte	-7
	.byte	-27
	.byte	-35
	.byte	-26
	.byte	-15
	.byte	-24
	.byte	-26
	.byte	6
	.byte	-11
	.byte	5
	.byte	-2
	.byte	-16
	.byte	-16
	.byte	-2
	.byte	-2
	.byte	-15
	.byte	-15
	.byte	-20
	.byte	-8
	.byte	-16
	.byte	-18
	.byte	6
	.byte	5
	.byte	-15
	.byte	-2
	.byte	-24
	.byte	-28
	.byte	-22
	.byte	10
	.byte	-15
	.byte	-3
	.byte	-30
	.byte	-8
	.byte	-24
	.byte	-30
	.byte	-10
	.byte	-27
	.byte	-19
	.byte	-30
	.byte	-12
	.byte	-16
	.byte	-10
	.byte	14
	.byte	-19
	.byte	-3
	.byte	-30
	.byte	4
	.byte	4
	.byte	6
	.byte	2
	.byte	1
	.byte	-3
	.byte	-10
	.byte	-8
	.byte	-4
	.byte	-6
	.byte	-2
	.byte	-15
	.byte	-11
	.byte	-26
	.byte	-8
	.byte	-20
	.byte	-30
	.byte	6
	.byte	-19
	.byte	-3
	.byte	-46
	.byte	0
	.byte	0
	.byte	2
	.byte	6
	.byte	9
	.byte	5
	.byte	2
	.byte	4
	.byte	8
	.byte	6
	.byte	8
	.byte	9
	.byte	9
	.byte	6
	.byte	8
	.byte	8
	.byte	6
	.byte	10
	.byte	13
	.byte	9
	.byte	6
	.byte	8
	.byte	12
	.byte	10
	.byte	2
	.byte	5
	.byte	1
	.byte	-2
	.byte	0
	.byte	0
	.byte	6
	.byte	12
	.byte	1
	.byte	13
	.byte	2
	.byte	12
	.byte	12
	.byte	14
	.byte	-12
	.byte	-14
	.byte	-20
	.byte	-18
	.byte	-16
	.byte	-16
	.byte	-14
	.byte	-12
	.byte	-10
	.byte	-21
	.byte	-14
	.byte	-12
	.byte	-12
	.byte	-10
	.byte	-12
	.byte	-18
	.byte	-22
	.byte	-24
	.byte	-18
	.byte	-18
	.byte	-18
	.byte	-12
	.byte	-14
	.byte	-23
	.byte	-20
	.byte	-20
	.byte	-20
	.byte	-20
	.byte	-12
	.byte	-24
	.byte	-24
	.byte	-30
	.byte	-24
	.byte	-28
	.byte	-28
	.byte	-12
	.byte	-26
	.byte	-25
	.byte	-34
	.byte	-24
	.byte	-24
	.byte	-24
	.byte	-12
	.byte	-13
	.byte	-26
	.byte	-20
	.byte	-14
	.byte	-18
	.byte	-18
	.byte	-12
	.byte	-15
	.byte	-27
	.byte	-22
	.byte	-20
	.byte	-24
	.byte	-22
	.byte	-12
	.byte	-21
	.byte	-28
	.byte	-28
	.byte	-24
	.byte	-26
	.byte	-24
	.byte	20
	.byte	16
	.byte	6
	.byte	10
	.byte	16
	.byte	12
	.byte	12
	.byte	16
	.byte	16
	.byte	8
	.byte	8
	.byte	12
	.byte	12
	.byte	12
	.byte	18
	.byte	18
	.byte	10
	.byte	8
	.byte	14
	.byte	14
	.byte	14
	.byte	16
	.byte	14
	.byte	6
	.byte	6
	.byte	12
	.byte	14
	.byte	8
	.byte	20
	.byte	18
	.byte	8
	.byte	6
	.byte	14
	.byte	14
	.byte	10
	.byte	20
	.byte	20
	.byte	6
	.byte	10
	.byte	10
	.byte	12
	.byte	12
	.byte	10
	.byte	13
	.byte	5
	.byte	2
	.byte	14
	.byte	8
	.byte	6
	.byte	6
	.byte	13
	.byte	9
	.byte	4
	.byte	14
	.byte	10
	.byte	10
	.byte	10
	.byte	13
	.byte	9
	.byte	6
	.byte	8
	.byte	12
	.byte	10
	.byte	2
	.byte	5
	.byte	1
	.byte	-2
	.byte	0
	.byte	0
	.byte	6
	.byte	12
	.byte	1
	.byte	13
	.byte	2
	.byte	12
	.byte	12
	.byte	14
	.section	.rodata.toshiba_3d_read_retrial.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"toshiba SRR %d row=%x, status=%d\012\000"
.LC45:
	.ascii	"toshiba TRR %d row=%x, status=%d\012\000"
.LC46:
	.ascii	"toshiba RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.toshiba_A19ref_value,"a",%progbits
	.set	.LANCHOR0,. + 0
	.type	toshiba_A19ref_value, %object
	.size	toshiba_A19ref_value, 45
toshiba_A19ref_value:
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
	.section	.rodata.toshiba_ref_value,"a",%progbits
	.set	.LANCHOR3,. + 0
	.type	toshiba_ref_value, %object
	.size	toshiba_ref_value, 8
toshiba_ref_value:
	.byte	0
	.byte	4
	.byte	124
	.byte	120
	.byte	116
	.byte	8
	.byte	12
	.byte	112
	.section	.rodata.vpn_check.str1.1,"aMS",%progbits,1
.LC115:
	.ascii	"acblk = %x, tempblk = %x, gc_des = %x\012\000"
.LC116:
	.ascii	"acblk = %x, free page = %x, vpn = %x %x\012\000"
.LC117:
	.ascii	"tmp_blk = %x, free page = %x, vpn = %x %x\012\000"
.LC118:
	.ascii	"vpn_check lpa = %x, ppa = %x, blk = %x\012\000"
.LC119:
	.ascii	"l2p\000"
.LC120:
	.ascii	"vpn_check %x = c %x  s %x function: %x\012\000"
.LC121:
	.ascii	"vpn_check blk = %x fix vpc\012\000"
	.hidden	free
