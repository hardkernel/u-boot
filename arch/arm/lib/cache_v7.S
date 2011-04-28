	.global   _invalidate_dcache 
	.global   _clean_dcache 
	.global   _clean_invd_dcache 
	.global   _invalidate_dcache_addr 
	.global   _invalidate_dcache_addr2
	.global   _clean_dcache_addr 
	.global   _clean_invd_dcache_addr 
	.global   _invalidate_icache 
@void _invalidate_dcache(void);
_invalidate_dcache:
    push    {r4,r5,r6,lr}
    MOV     r2,#0
    MOV     r3,#0x40000000
    MOV     r4,#0x80000000
    MOV     r5,#0xc0000000
    MOVEQ   r6,#0x2000
    MOVNE   r6,#0x4000
invalidate_loop:
    MCR     p15,0,r2,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r3,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r4,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r5,c7,c6,2  @ invalidate dcache by set / way
    ADD     r2,r2,#0x20
    ADD     r3,r3,#0x20
    ADD     r4,r4,#0x20
    ADD     r5,r5,#0x20
    CMP     r2,r6
    BNE     invalidate_loop
    DSB
    pop {r4, r5,r6, pc}

@void _clean_dcache(void);
_clean_dcache:
    push    {r4,r5,r6,lr}
    MOV     r2,#0
    MOV     r3,#0x40000000
    MOV     r4,#0x80000000
    MOV     r5,#0xc0000000
    MOVEQ   r6,#0x2000
    MOVNE   r6,#0x4000
clean_loop:
    MCR     p15,0,r2,c7,c10,2  @ invalidate dcache by set / way
    MCR     p15,0,r3,c7,c10,2  @ invalidate dcache by set / way
    MCR     p15,0,r4,c7,c10,2  @ invalidate dcache by set / way
    MCR     p15,0,r5,c7,c10,2  @ invalidate dcache by set / way
    ADD     r2,r2,#0x20
    ADD     r3,r3,#0x20
    ADD     r4,r4,#0x20
    ADD     r5,r5,#0x20
    CMP     r2,r6
    BNE     clean_loop
    DSB
    pop {r4, r5,r6, pc}

@void _clean_invd_dcache(void);
_clean_invd_dcache:
    push    {r4,r5,r6,lr}
    MOV     r2,#0
    MOV     r3,#0x40000000
    MOV     r4,#0x80000000
    MOV     r5,#0xc0000000
    MOVEQ   r6,#0x2000
    MOVNE   r6,#0x4000
clean_invd_loop:
    MCR     p15,0,r2,c7,c14,2  @ invalidate dcache by set / way
    MCR     p15,0,r3,c7,c14,2  @ invalidate dcache by set / way
    MCR     p15,0,r4,c7,c14,2  @ invalidate dcache by set / way
    MCR     p15,0,r5,c7,c14,2  @ invalidate dcache by set / way
    ADD     r2,r2,#0x20
    ADD     r3,r3,#0x20
    ADD     r4,r4,#0x20
    ADD     r5,r5,#0x20
    CMP     r2,r6
    BNE     clean_invd_loop
    DSB
    pop {r4, r5,r6, pc}


@void _clean_dcache_addr(unsigned long addr);
_clean_dcache_addr:
    push    {r4,r5,r6,lr}
    MCR     p15,0,r0,c7,c10,1  @ invalidate dcache by MVA to PoC 
    DSB
    pop {r4, r5,r6, pc}

@void _invalidate_dcache_addr2(unsigned long addr);
_invalidate_dcache_addr2:
    push    {r4,r5,r6,lr}
    MCR     p15,0,r0,c7,c6,1  @ invalidate dcache by MVA to PoC 
    pop {r4, r5,r6, pc}


@void _invalidate_dcache_addr(unsigned long addr);
_invalidate_dcache_addr:
    push    {r4,r5,r6,lr}
    MCR     p15,0,r0,c7,c6,1  @ invalidate dcache by MVA to PoC 
    DSB
    pop {r4, r5,r6, pc}

@void _clean_invd_dcache_addr(unsigned long addr);
_clean_invd_dcache_addr:
    push    {r4,r5,r6,lr}
    MCR     p15,0,r0,c7,c14,1  @ invalidate dcache by MVA to PoC 
    DSB
    pop {r4, r5,r6, pc}
  

@void _invalidate_icache(void);
_invalidate_icache:
    push    {r4, lr}
	MOV r0,#0
	MCR p15,0,r0,c7,c5,6 		@ Invalidate BTAC
	MCR p15,0,r0,c7,c5,0		@ Invalidate ICache
	DSB
    NOP
    NOP
    pop {r4, pc}

