#include <common.h>
#include <malloc.h>
#include <errno.h>
#include <environment.h>
#include <fdt_support.h>
#include <libfdt.h>

DECLARE_GLOBAL_DATA_PTR;

int serial_set_pin_port(unsigned long port_base)
{
    //UART in "Always On Module"
    //GPIOAO_0==tx,GPIOAO_1==rx
    //setbits_le32(P_AO_RTI_PIN_MUX_REG,3<<11);
    return 0;
}

void reset_cpu(ulong addr)
{
}

int dram_init(void)
{
	gd->ram_size = PHYS_SDRAM_1_SIZE;
	return 0;
}
int board_init(void)
{
	return 0;
}

/* secondary_boot_func
 * this function should be write with asm, here, is is only for compiling pass
 * */
void secondary_boot_func(void)
{
}

int board_eth_init(bd_t *bis)
{
	int rc = 0;
	return rc;
}

