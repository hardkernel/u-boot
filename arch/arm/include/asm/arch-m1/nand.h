
#ifndef _ASM_NAND_H_INCLUDED
#define _ASM_NAND_H_INCLUDED
//This File only include the register define relative code 
//It should describe some 
#include "reg_addr.h"
#include "aml_nand.h"

#define NAND_IO_ENABLE(mode)        {               \
        SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x1f5); \
	    SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24))); \
	    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<29) | (1<<27) | (1<<25) | (1<<23))); \
	    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_7, ((1<<29) | (1<<28) | (1<<27) | (1<<26) | (1<<25) | (1<<24))); \
    }      
#define NAND_IO_DISABLE(mode) {                         \
        CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x7fff); \
	    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24)));    \
    }




#endif // NAND_H_INCLUDED

