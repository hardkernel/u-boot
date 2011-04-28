/*
 * AMLOGIC Audio/Video streaming port driver.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 * Author:  zhou zhi<zhi.zhou@amlogic.com>
 *
 *
 *
 *
 * This is basic start codes for dsp arc
 */

.equ __MW__, 1
.equ __ARC600__, 1

 .ifndef __MW__ 
 #include <asm/system.h>
 #include <asm/entry.h>
 #include <asm/linkage.h>
 #include <asm/dsp_register.h>
 .else
  .macro  SAVE_CALLER_SAVED
    st.a    r0, [sp, -4]
    st.a    r1, [sp, -4]
    st.a    r2, [sp, -4]
    st.a    r3, [sp, -4]
    st.a    r4, [sp, -4]
    st.a    r5, [sp, -4]
    st.a    r6, [sp, -4]
    st.a    r7, [sp, -4]
    st.a    r8, [sp, -4]
    st.a    r9, [sp, -4]
    st.a    r10, [sp, -4]
    st.a    r11, [sp, -4]
    st.a    r12, [sp, -4]
    st.a    r13, [sp, -4]
    st.a    r14, [sp, -4]
    st.a    r15, [sp, -4]
    st.a    r16, [sp, -4]
    st.a    r17, [sp, -4]
    st.a    r18, [sp, -4]
    st.a    r19, [sp, -4]
    st.a    r20, [sp, -4]
    st.a    r21, [sp, -4]
    st.a    r22, [sp, -4]
    st.a    r23, [sp, -4]
    st.a    r24, [sp, -4]
.endm
.macro RESTORE_CALLER_SAVED
    ld.ab   r24, [sp, 4]
    ld.ab   r23, [sp, 4]
    ld.ab   r22, [sp, 4]
    ld.ab   r21, [sp, 4]
    ld.ab   r20, [sp, 4]
    ld.ab   r19, [sp, 4]
    ld.ab   r18, [sp, 4]
    ld.ab   r17, [sp, 4]
    ld.ab   r16, [sp, 4]
    ld.ab   r15, [sp, 4]
    ld.ab   r14, [sp, 4]
    ld.ab   r13, [sp, 4]
    ld.ab   r12, [sp, 4]
    ld.ab   r11, [sp, 4]
    ld.ab   r10, [sp, 4]
    ld.ab   r9, [sp, 4]
    ld.ab   r8, [sp, 4]
    ld.ab   r7, [sp, 4]
    ld.ab   r6, [sp, 4]
    ld.ab   r5, [sp, 4]
    ld.ab   r4, [sp, 4]
    ld.ab   r3, [sp, 4]
    ld.ab   r2, [sp, 4]
    ld.ab   r1, [sp, 4]
    ld.ab   r0, [sp, 4]
.endm
.equ AUX_IRQ_LV12, 0x43

.ifdef CACHELINE_64BYTE
.equ DSP_STACK_END ,  (0x100000 - 8192 + 64*4);
.equ DSP_GP_STACK_END ,(0x100000- 8192 + 64*6);
.equ DSP_SLEEP_STATUS,(0x100000- 8192 + 64*14);
.equ DSP_STATUS,(0x100000 - 8192 + 64*0);
.else
.equ DSP_STACK_END ,  0xff080 ;
.equ DSP_GP_STACK_END ,0xff0c0 ;
.equ DSP_SLEEP_STATUS,0xff1c0;
.equ DSP_STATUS,0xff000 ;
.endif

.equ DSP_STATUS_SLEEP,  0x534c4550 ;;SLEP

.endif 

.ifndef __MW__
    .section .text, "ax",@progbits
.else
    .section .text
    ;, "ax",@progbits
.endif
    .align 8 
    .type _start, @function
    .globl _start
_start:
j   _dsp_reset             ; 0x0,  restart vector
j   _dsp_mem_error             	; 0x8,  memory exception
j   _dsp_instruct_error           	; 0x10, instruction error
j   _timer0_irq;   ;;;ifdef A6 ,timer 0  L1
j   _isa_irq;   
j   _isa_irq   ;;isr irq
j   _isa_fiq ;;; isr fiq
.ifdef __ARC600__
j   _timer1_irq;	;;;time  1  L2
.endif
.rept   25
j   _dsp_exception               		; Reserved Exceptions
.endr
.rept   32
j   _dsp_exception               ; Reserved Exceptions
.endr



_dsp_reset:
;	mov r0,0xc8100004  ; M6 AO RTI STATUS REG1
;	mov r1,0x44535046
;	st.di r1,[r0]
	j dsp_cpu_reset

_dsp_mem_error:
.ifndef __ARC600__
  lr  r0, [icause2]
  mov r1, sp
.else
 mov r0,sp
.endif
 mov r5,sp
 mov r6,ilink1
 mov r7,ilink2
 mov r8,blink
 j dsp_mem_error
	
_dsp_instruct_error:
.ifndef __ARC600__
	lr  r0, [icause2]
  mov r1, sp
.else
	 mov  r0,sp
.endif
 mov r5,sp
 mov r6,ilink1
 mov r7,ilink2
 mov r8,blink
	j dsp_intstruct_error


_timer0_irq:
    SAVE_CALLER_SAVED
    st.a    r26, [sp, -4]   /* gp */
    st.a    fp, [sp, - 4]
    st.a    blink, [sp, -4]
    st.a    ilink1, [sp, -4]
    lr  r9, [status32_l1]
    st.a    r9, [sp, -4]
    st.a    lp_count, [sp, -4]
    lr  r9, [lp_end]
    st.a    r9, [sp, -4]
    lr  r9, [lp_start]
    st.a    r9, [sp, -4]
.ifndef __ARC600__
    lr  r9, [bta_l1]
    st.a    r9, [sp, -4]
.endif
        /* move sp to next free entry */
    sub sp, sp, 4
    mov r1, sp
.ifndef __ARC600__
    lr  r0, [icause1]
    and r0, r0, 0x1f
.else
    mov r0,0x3	
.endif
    bl dsp_irq_process    
    mov r8,0x1 /*clean irq status*/
    sr r8, [AUX_IRQ_LV12]
    
    add sp, sp, 4
    ld.ab   r9, [sp, 4]
.ifndef __ARC600__
    sr  r9, [bta_l1]
    ld.ab   r9, [sp, 4]
.endif
    sr  r9, [lp_start]
    ld.ab   r9, [sp, 4]
    sr  r9, [lp_end]
    ld.ab   r9, [sp, 4]
    mov lp_count, r9
    ld.ab   r9, [sp, 4]
    sr  r9, [status32_l1]
    ld.ab   r9, [sp, 4]
    mov  ilink1, r9
    ld.ab   blink, [sp, 4]
    ld.ab   fp, [sp, 4] 
    ld.ab   r26, [sp, 4]    /* gp */
   RESTORE_CALLER_SAVED
.ifndef __ARC600__
    rtie;
    nop
    nop
    j dsp_cpu_reset
.else
   jal.f [ilink1];
   nop
.endif
_timer1_irq:   ;;; IRQ L2
    SAVE_CALLER_SAVED
    st.a    r26, [sp, -4]   /* gp */
    st.a    fp, [sp, - 4]
    st.a    blink, [sp, -4]
    st.a    ilink2, [sp, -4]
    lr  r9, [status32_l2]
    st.a    r9, [sp, -4]
    st.a    lp_count, [sp, -4]
    lr  r9, [lp_end]
    st.a    r9, [sp, -4]
    lr  r9, [lp_start]
    st.a    r9, [sp, -4]
.ifndef __ARC600__
    lr  r9, [bta_l1]
    st.a    r9, [sp, -4]
.endif
        /* move sp to next free entry */
    sub sp, sp, 4
    mov r1, sp
.ifndef __ARC600__
    lr  r0, [icause1]
    and r0, r0, 0x1f
.else
    mov r0,0x7	 
.endif
    bl  dsp_irq_process
    mov r8,0x1 /*clean irq status*/
    sr r8, [AUX_IRQ_LV12]
    
    add sp, sp, 4
    ld.ab   r9, [sp, 4]
.ifndef __ARC600__
    sr  r9, [bta_l1]
    ld.ab   r9, [sp, 4]
.endif
    sr  r9, [lp_start]
    ld.ab   r9, [sp, 4]
    sr  r9, [lp_end]
    ld.ab   r9, [sp, 4]
    mov lp_count, r9
    ld.ab   r9, [sp, 4]
    sr  r9, [status32_l2]
    ld.ab   r9, [sp, 4]
    mov  ilink2, r9
    ld.ab   blink, [sp, 4]
    ld.ab   fp, [sp, 4] 
    ld.ab   r26, [sp, 4]    /* gp */
   RESTORE_CALLER_SAVED
.ifndef __ARC600__
    rtie;
    nop
    nop
    j dsp_cpu_reset
.else
   jal.f [ilink2];
   nop
.endif

_isa_irq:
    SAVE_CALLER_SAVED
    st.a    r26, [sp, -4]   /* gp */
    st.a    fp, [sp, - 4]
    st.a    blink, [sp, -4]
    st.a    ilink1, [sp, -4]
    lr  r9, [status32_l1]
    st.a    r9, [sp, -4]
    st.a    lp_count, [sp, -4]
    lr  r9, [lp_end]
    st.a    r9, [sp, -4]
    lr  r9, [lp_start]
    st.a    r9, [sp, -4]
.ifndef __ARC600__
    lr  r9, [bta_l1]
    st.a    r9, [sp, -4]
.endif
        /* move sp to next free entry */
    sub sp, sp, 4
    mov r1, sp
.ifndef __ARC600__
    lr  r0, [icause1]
    and r0, r0, 0x1f
.else
    mov r0,0x5
;;; this code to judge if let the arc625 to sleep/wakeup
.ifdef __MESON6__
	mov r1, 0xc80101e0
.else
    mov r1,0xc1107de0 ;//mailbox2 interrupt status
.endif
 ;   ld.di r2,[r1]
 ;   breq r2,32,_sleep
 ;   breq r2,64,_wakeup
.endif	
    b start_irq   	
_sleep:
    mov r0, 0
    st	r0,[DSP_SLEEP_STATUS]
    mov r0,DSP_STATUS_SLEEP	
    st 	r0,[DSP_STATUS];;;now,tell arm side, arc is really sleeping. sp/gp buffer can be free now
   ;;  bl   dsp_irq_process
 ;;;disable timer 0,1 interupt
 ;    lr     r0,[0x11];
 ;   or    r0,r0,1
 ;   sr	    1,[0x11];disable icache
 ;   lr     r0,[0x48];
 ;   or    r0,r0,1
  ;  sr	    1,[0x48];disable dcache    
    lr r1,[0x22] ;;timer0
    and r1,r1,0xfe
    sr r1,[0x22]
    lr r1,[0x101];;timer1
    and r1,r1,0xfe
    sr r1,[0x101]
   ; flag 0;;disable interupt
    ;sleep
   ; nop
   ; nop
   ; nop
.ifndef __MESON6__
   mov r5,0xc1107de8
   mov r6,0x40
.else
   mov r5,0xc80101e8
   mov r6,0x40
.endif
   
RECHECK:   
   ld.di r7,[r5]
   and  r8,r7,r6
   brne r8,0x40,RECHECK
.if 0   
   mov r3,0xc1107de4
   mov r4,0xc1109854
   st.a  0x40,[r3]
   ld.di  r0,[r4]
   and   r0,r0,0xffbf
   st.a  r0,[r4]
.else   
  ;; bl   dsp_irq_process  ;;;????
.endif   
   and   r2,r7,0xffbf
   st.ab r2,[r5]	
   j    _dsp_reset
   nop
   nop
   nop
_wakeup:
  ;  bl dsp_irq_process	
    j   _dsp_reset
    b end   
start_irq:
    bl dsp_irq_process
    ld.di r0,[DSP_SLEEP_STATUS]
    breq r0,0x12345678,_sleep
end:    
    mov r8,0x1 /*clean irq status*/
    sr r8, [AUX_IRQ_LV12]
    
    add sp, sp, 4
    ld.ab   r9, [sp, 4]
.ifndef __ARC600__
    sr  r9, [bta_l1]
    ld.ab   r9, [sp, 4]
.endif
    sr  r9, [lp_start]
    ld.ab   r9, [sp, 4]
    sr  r9, [lp_end]
    ld.ab   r9, [sp, 4]
    mov lp_count, r9
    ld.ab   r9, [sp, 4]
    sr  r9, [status32_l1]
    ld.ab   r9, [sp, 4]
    mov  ilink1, r9
    ld.ab   blink, [sp, 4]
    ld.ab   fp, [sp, 4] 
    ld.ab   r26, [sp, 4]    /* gp */
   RESTORE_CALLER_SAVED
.ifndef __ARC600__
    rtie;
    nop
    nop
    j dsp_cpu_reset
.else
   jal.f [ilink1];
   nop		   
.endif

_isa_fiq:
    SAVE_CALLER_SAVED 
    st.a    r26, [sp, -4]   /* gp */
    st.a    fp, [sp, - 4]
    st.a    blink, [sp, -4]
    st.a    ilink2, [sp, -4]
    lr  r9, [status32_l2]
    st.a    r9, [sp, -4]
    st.a    lp_count, [sp, -4]
    lr  r9, [lp_end]
    st.a    r9, [sp, -4]
    lr  r9, [lp_start]
    st.a    r9, [sp, -4]
.ifndef __ARC600__
    lr  r9, [bta_l2]
    st.a    r9, [sp, -4]
.endif
        /* move sp to next free entry */
    sub sp, sp, 4
.ifndef __ARC600__
    lr  r0, [icause2]
    and r0, r0, 0x1f
.else
    mov r0,0x6
.endif
    mov r1, sp
    
    bl  dsp_irq_process

    mov r8,0x2 /*clean fiq status*/
    sr r8, [AUX_IRQ_LV12]

    
    add sp, sp, 4
    ld.ab   r9, [sp, 4]
.ifndef __ARC600__
    sr  r9, [bta_l2]
    ld.ab   r9, [sp, 4]
.endif
    sr  r9, [lp_start]
    ld.ab   r9, [sp, 4]
    sr  r9, [lp_end]
    ld.ab   r9, [sp, 4]
    mov lp_count, r9
    ld.ab   r9, [sp, 4]
    sr  r9, [status32_l2]
    ld.ab   r9, [sp, 4]
    mov  ilink2, r9
    ld.ab   blink, [sp, 4]
    ld.ab   fp, [sp, 4] 
    ld.ab   r26, [sp, 4]    /* gp */
   RESTORE_CALLER_SAVED 
.ifndef __ARC600__
   rtie;
   nop
   nop
   j dsp_cpu_reset
.else
   jal.f [ilink2];
   nop
.endif
_dsp_exception:
.ifndef __ARC600__
    lr  r0, [icause2]
    mov r1, sp
.else
    mov r0, sp
.endif
   j dsp_exceptions
   

.ifndef __MW__ 
    .globl SYMBOL_NAME(dsp_cpu_reset) 
    .align 4      
SYMBOL_NAME_LABEL(dsp_cpu_reset)
.else 
    .globl dsp_cpu_reset
    .type   dsp_cpu_reset, @function
    .align 4      
dsp_cpu_reset:
.endif 
    flag 		0;disable all interrupt
    lr     r0,[0x11];
    or    r0,r0,1
    sr	    1,[0x11];disable icache
   lr     r0,[0x48];
   or    r0,r0,1
   sr	    1,[0x48];disable dcache

.align 2048

.if 1
_dsp_clear_bss:
    mov r3,__dsp_bss
    mov r4,__dsp_bss_end
1:   
    st.ab 0, [r3,4]
    brlt   r3, r4, 1b
_bss_clear_end:
.endif
    ;;ld  r0,[DSP_STATUS]
    ;;mov r1,DSP_STATUS_RUNING
    ;;mov r2,DSP_STATUS_HALT	
    mov r0,0 
    mov fp,0
    ld.di r0,[DSP_STACK_END];
    sub	r0, r0, 4
    mov sp,r0
    ld.di r0,[DSP_GP_STACK_END];
    sub r0, r0, 4
    mov gp,r0

    
j __ecrypt_addr  
nop  
nop  
.align 16 
;    j 0x70717273       
;	j 0x74757677       
__efuse_magic__:
    .4byte 0
    .4byte 0x72737071
    .4byte 0
    .4byte 0x76777475

	j ___t1            
	j ___t2            
__ecrypt_addr:     

.ifdef ENABLE_FIRMWARE_ENCRYPT 
    bl decrypt
.endif
    
    bl  dsp_c_entry
    flag 1
    nop
    nop
    nop
    nop
    nop
    nop

	
