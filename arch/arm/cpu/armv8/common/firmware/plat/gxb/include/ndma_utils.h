
#ifndef NDMA_UTILS_H
#define NDMA_UTILS_H
void    NDMA_set_table_position( uint32_t thread_num, uint32_t table_start, uint32_t table_end );
void    NDMA_set_table_position_secure( uint32_t thread_num, uint32_t table_start, uint32_t table_end );
void    NDMA_start(uint32_t thread_num);
void    NDMA_stop(uint32_t thread_num);
void    NDMA_wait_for_completion(uint32_t thread_num);
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
								uint32_t   ctr_limit );


void    NDMA_add_descriptor_sha(
                                uint32_t   thread_num,
                                uint32_t   irq,
                                uint32_t   sha_type,       // 0 = sha1, 1 = sha2-224, 2 = sha2-256
                                uint32_t   pre_endian,
                                uint32_t   bytes_to_move,
                                uint32_t   src_addr,
                                uint32_t   last_block );
#endif
