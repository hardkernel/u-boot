#ifndef __AMLOGIC_NAND_H_
#define __AMLOGIC_NAND_H_
#include <linux/types.h>
/* These struct will descriptor the Controller 's ability and interface */
typedef struct cntl_ecc_ability ecc_modes_t;
struct cntl_ecc_ability{
    u8*       name;
    unsigned  id:4;
    unsigned  user:1;
    unsigned  bits:7;
    unsigned  size:12; //base on 8
    unsigned  parity:8;
    unsigned  dma_key;  
};
typedef struct cntl_driver cntl_driver_t;

#define NF_CNTL_SUPPORT_RANDOMIZE           (1<<0)
#define NF_CNTL_SUPPORT_SHORTEN             (1<<1)
#define NF_CNTL_SUPPORT_SYNC                (1<<2)
#define NF_CNTL_RBIO                        (1<<3)
struct cntl_driver{
    u8*       name;
    u32       support;
    u32       fifo_max;
    ecc_modes_t * ecc;
    u16       t_rea;
    u16       t_rhoh;
    s32       (* cfg)(cntl_driver_t *);
    s32       (* cmd)(cntl_driver_t *,u8 cmd,u16 para);
    s32       (* select)(cntl_driver_t *,u8 ce);
    s32       (* rb)(cntl_driver_t *,u8 rbio,u32 time);
    s32       (* write)(cntl_driver_t *,unsigned dma_key,void * src ,void * info, unsigned size);
    s32       (* read) (cntl_driver_t *,unsigned dma_key,void * dest,void * info, unsigned size);
};





#endif // NAND_H_INCLUDED
