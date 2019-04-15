.text

.global bss_init


bss_init:
        /* Clear bss section */
        la a0, _bss_start
        la a1, _bss_end
        bgeu a0, a1, 2f
1:
        sw zero, (a0)
        addi a0, a0, 4
        bltu a0, a1, 1b
2:
        ret

.align 2
_bss_start:
.long _bssstart
_bss_end:
.long _bssend
