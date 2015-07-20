#include <stdint.h>
#include "ndma_utils.h"
#include <asm/arch/secure_apb.h>
#include <arch_helpers.h>

uint32_t    NDMA_table_ptr_start[4];
uint32_t    NDMA_table_ptr_curr[4];
uint32_t    NDMA_table_ptr_end[4];


#define NDMA_Wr(addr, data) *(volatile uint32_t *)(addr)=(data)
#define NDMA_Rd(addr)       *(volatile uint32_t *)(addr)
// --------------------------------------------
//          NDMA_set_table_position_secure
// --------------------------------------------
void    NDMA_set_table_position_secure( uint32_t thread_num, uint32_t table_start, uint32_t table_end )
{
    NDMA_table_ptr_start[thread_num]        = table_start;
    NDMA_table_ptr_curr[thread_num]         = table_start;
    NDMA_table_ptr_end[thread_num]          = table_end;
    switch ( thread_num ) {
        case 3: NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_START3, table_start );
                NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_END3, table_end );
                // Pulse thread init to register the new start/end locations
                NDMA_Wr( NDMA_THREAD_REG, NDMA_Rd(NDMA_THREAD_REG) | (1 << 27) );
                break;
        case 2: NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_START2, table_start );
                NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_END2, table_end );
                // Pulse thread init to register the new start/end locations
                NDMA_Wr( NDMA_THREAD_REG, NDMA_Rd(NDMA_THREAD_REG) | (1 << 26) );
                break;
        case 1: NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_START1, table_start );
                NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_END1, table_end );
                // Pulse thread init to register the new start/end locations
                NDMA_Wr( NDMA_THREAD_REG, NDMA_Rd(NDMA_THREAD_REG) | (1 << 25) );
                break;
        case 0: NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_START0, table_start );
                NDMA_Wr( SEC_SEC_BLKMV_THREAD_TABLE_END0, table_end );
                // Pulse thread init to register the new start/end locations
                NDMA_Wr( SEC_NDMA_THREAD_REG, NDMA_Rd(NDMA_THREAD_REG) | (1 << 24) );
                break;
    }
}


// --------------------------------------------
//              NDMA_start()
// --------------------------------------------
// Start the block move procedure
//
void    NDMA_start(uint32_t thread_num)
{
	NDMA_Wr(SEC_NDMA_CNTL_REG0,NDMA_Rd(SEC_NDMA_CNTL_REG0) | (1 << NDMA_ENABLE) );

   // NDMA_Wr(NDMA_CNTL_REG0,0xf8634000 );
    NDMA_Wr(SEC_NDMA_THREAD_REG,NDMA_Rd(SEC_NDMA_THREAD_REG)  | (1 << (thread_num + 8)) );
}
// --------------------------------------------
//              NDMA_wait_for_completion()
// --------------------------------------------
// Wait for all block moves to complete
//
void    NDMA_wait_for_completion(uint32_t thread_num)
{
    if ( !NDMA_table_ptr_start[thread_num] ) {  // there are no table entries
        return;
    }

    while ( (NDMA_Rd(SEC_NDMA_TABLE_ADD_REG) & (0xFF << (thread_num*8))) ) { }
}

void    NDMA_stop(uint32_t thread_num)
{
    NDMA_Wr(NDMA_THREAD_REG,NDMA_Rd(NDMA_THREAD_REG)  & ~(1 << (thread_num + 8)) );
    // If no threads enabled, then shut down the DMA engine completely
    if ( !(NDMA_Rd(NDMA_THREAD_REG) & (0xF << 8)) ) {
        NDMA_Wr(NDMA_CNTL_REG0,NDMA_Rd(NDMA_CNTL_REG0) & ~(1 << NDMA_ENABLE) );
    }
}
// --------------------------------------------
//          NDMA_add_descriptor_aes
// --------------------------------------------
// Simple add function for AES
void    NDMA_add_descriptor_aes(
uint32_t   thread_num,
uint32_t   irq,
uint32_t   cbc_enable,
uint32_t   cbc_reset,
uint32_t   encrypt,        // 0 = decrypt, 1 = encrypt
uint32_t   aes_type,       // 00 = 128, 01 = 192, 10 = 256
uint32_t   pre_endian,
uint32_t   post_endian,
uint32_t   bytes_to_move,
uint32_t   src_addr,
uint32_t   dest_addr,
uint32_t   ctr_endian,
uint32_t   ctr_limit )
{
    volatile uint32_t *p = (volatile uint32_t *)(unsigned long)NDMA_table_ptr_curr[thread_num];
    (*p++) =  (0x01 << 30)            |         // owned by CPU
              (0 << 27)               |
              (0 << 26)               |
              (0 << 25)               |
              (4 << 22)               |         // AES
              (irq  << 21)| (1<<8);
    (*p++) =  src_addr;
    (*p++) =  dest_addr;
    (*p++) =  bytes_to_move & 0x01FFFFFF;
    (*p++) =  0x00000000;  // no skip
    (*p++) =  0x00000000;  // no skip
    // Prepare the pointer for the next descriptor boundary
    // inline processing + bytes to move extension
    (*p++) =
              (ctr_endian  << 16)       |
              (ctr_limit   << 14)       |
              (cbc_enable  << 12)       |
              (cbc_reset   << 11)       |
              (encrypt     << 10)       |
              (aes_type    << 8)        |
              (post_endian << 4)        |
              (pre_endian  << 0);

    #if 0
    _clean_dcache_addr(NDMA_table_ptr_curr[thread_num]);
    _clean_invd_dcache_addr (NDMA_table_ptr_curr[thread_num]);
    _clean_dcache_addr(NDMA_table_ptr_curr[thread_num]+32);
    _clean_invd_dcache_addr (NDMA_table_ptr_curr[thread_num]+32);
	#endif

    if ( NDMA_table_ptr_curr[thread_num] == NDMA_table_ptr_end[thread_num] ) {
        NDMA_table_ptr_curr[thread_num] = NDMA_table_ptr_start[thread_num];
    } else {
        NDMA_table_ptr_curr[thread_num] += 32; // point to the next location (8-4 byte table entries)
    }
    NDMA_Wr( NDMA_TABLE_ADD_REG, (thread_num << 8) | (1 << 0) );
}

// --------------------------------------------
//          NDMA_add_descriptor_sha
// --------------------------------------------
// Simple add function for SHA
void    NDMA_add_descriptor_sha(
uint32_t   thread_num,
uint32_t   irq,
uint32_t   sha_mode,       // 1:sha1;2:sha2-256;3:sha2_224
uint32_t   pre_endian,
uint32_t   bytes_to_move,
uint32_t   src_addr,
uint32_t   last_block )
{
    volatile uint32_t *p = (volatile uint32_t *)(unsigned long)NDMA_table_ptr_curr[thread_num];
    (*p++) =  (0x01 << 30)            |         // owned by CPU
              (0 << 27)               |
              (0 << 26)               |
              (0 << 25)               |
              (5 << 22)               |         // SHA
              (irq  << 21) ;
    (*p++) =  src_addr;
    (*p++) =  0x00000000;
    (*p++) =  bytes_to_move & 0x01FFFFFF;
    (*p++) =  0x00000000;  // no skip
    (*p++) =  0x00000000;  // no skip
    // Prepare the pointer for the next descriptor boundary
    // inline processing + bytes to move extension
    (*p++) =  (sha_mode    << 8)        |
              (last_block  << 4)        |
              (pre_endian  << 0);

    #if 0
    _clean_dcache_addr(NDMA_table_ptr_curr[thread_num]);
    _clean_invd_dcache_addr (NDMA_table_ptr_curr[thread_num]);
    _clean_dcache_addr(NDMA_table_ptr_curr[thread_num]+32);
    _clean_invd_dcache_addr (NDMA_table_ptr_curr[thread_num]+32);
	#endif

    if ( NDMA_table_ptr_curr[thread_num] == NDMA_table_ptr_end[thread_num] ) {
        NDMA_table_ptr_curr[thread_num] = NDMA_table_ptr_start[thread_num];
    } else {
        NDMA_table_ptr_curr[thread_num] += 32; // point to the next location (8-4 byte table entries)
    }
    NDMA_Wr( SEC_NDMA_TABLE_ADD_REG, (thread_num << 8) | (1 << 0) );
}

