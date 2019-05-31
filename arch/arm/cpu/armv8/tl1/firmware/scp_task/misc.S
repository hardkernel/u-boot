.text

.syntax unified
.code 16

.global bss_init
.thumb_func

bss_init:
	mov r0, #0
	ldr r1, _bss_start
	ldr r2, _bss_end
bss_loop:
	cmp r1, r2
	it lt
	strlt r0, [r1], #4
	blt bss_loop
	bx lr

.align 2
_bss_start:
.long _bssstart
_bss_end:
.long _bssend