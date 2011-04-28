#include <config.h>
#include <asm/arch/io.h>
#include <asm/arch/sdio.h>

static struct aml_card_sd_info m1_sdio_ports[]={
    { .sdio_port=SDIO_PORT_A,.name="SDIO Port A"},
    { .sdio_port=SDIO_PORT_B,.name="SDIO Port B"},
    { .sdio_port=SDIO_PORT_C,.name="SDIO Port C"},
    { .sdio_port=SDIO_PORT_B1,.name="SDIO Port B1"}
};
struct aml_card_sd_info * cpu_sdio_get(unsigned port)
{
    if(port<SDIO_PORT_C+1)
        return &m1_sdio_ports[port];
    if(port==SDIO_PORT_B1)
        return &m1_sdio_ports[3];
    return NULL;
}

void  cpu_sdio_pwr_prepare(unsigned port)
{
    switch(port)
    {
        case SDIO_PORT_A://SDIOA,GPIOA_9~GPIOA_14
            clrbits_le32(P_PERIPHS_PIN_MUX_0,0x3f<<23);
            clrbits_le32(P_PREG_EGPIO_EN_N,(0x3f<<13));
            clrbits_le32(P_PREG_EGPIO_O,(0x3f<<13));
            ///@todo pull down these bits
            break;
        case SDIO_PORT_B://SDIOB,GPIOA_0~GPIOA_5
            //diable SDIO_B1
            clrbits_le32(P_PERIPHS_PIN_MUX_7,(0x3f<<24));
            clrbits_le32(P_PERIPHS_PIN_MUX_1,0x3f);
            clrbits_le32(P_PREG_EGPIO_EN_N,(0x3f<<4));
            clrbits_le32(P_PREG_EGPIO_O,(0x3f<<4));
            ///@todo pull down these bits
            break;
        case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
            clrbits_le32(P_PERIPHS_PIN_MUX_2,(0xf<<16)|(1<<12)|(1<<8));
            clrbits_le32(P_PREG_EGPIO_EN_N,(0x3f<<21));
            clrbits_le32(P_PREG_EGPIO_O,(0x3f<<21));
            ///@todo pull down these bits
            break;
        case SDIO_PORT_B1://SDIOB1 GPIOE_6~GPIOE_11
            // disable SPI and SDIO_B
            clrbits_le32(P_PERIPHS_PIN_MUX_1,( (1<<29) | (1<<27) | (1<<25) | (1<<23)|0x3f));
            clrbits_le32(P_PERIPHS_PIN_MUX_6,0x7fff);
            clrbits_le32(P_PERIPHS_PIN_MUX_7,(0x3f<<24));
            clrbits_le32(P_PREG_HGPIO_EN_N,(0x3f<<6));
            clrbits_le32(P_PREG_HGPIO_O,(0x3f<<6));
            
            ///@todo pull down these bits
            break;
        
    }
    
    /**
        do nothing here
    */
}
int cpu_sdio_init(unsigned port)
{
    switch(port)
    {
        case SDIO_PORT_A://SDIOA,GPIOA_9~GPIOA_14
            setbits_le32(P_PERIPHS_PIN_MUX_0,0x3f<<23);
            break;
        case SDIO_PORT_B://SDIOB,GPIOA_0~GPIOA_5
            //diable SDIO_B1
            clrbits_le32(P_PERIPHS_PIN_MUX_7,(0x3f<<24));
            setbits_le32(P_PERIPHS_PIN_MUX_1,0x3f);
            break;
        case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
            setbits_le32(P_PERIPHS_PIN_MUX_2,(0xf<<16)|(1<<12)|(1<<8));
            break;
        case SDIO_PORT_B1://SDIOB1 GPIOE_6~GPIOE_11
            // disable SPI and SDIO_B
            clrbits_le32(P_PERIPHS_PIN_MUX_1,( (1<<29) | (1<<27) | (1<<25) | (1<<23)|0x3f));
            clrbits_le32(P_PERIPHS_PIN_MUX_6,0x7fff);
            setbits_le32(P_PERIPHS_PIN_MUX_7,(0x3f<<24));
            break;
        default:
            return -1;
    }
    return 0;
}
/*
int sdio_read(unsigned por_config)
{
    unsigned SD_boot_type   ;  // bits [9:8]
    register int clock_27   = ((*P_ASSIST_HW_REV) & (1 << 12)) ? 1 : 0;
    SET_LOG(0xf200);

    switch(por_config)
    {
        case POR_SDIO_A_ENABLE://SDIOA,GPIOA_9~GPIOA_14
            *P_PREG_EGPIO_EN_N &=~(0x3f<<13);
            *P_PREG_EGPIO_O    &=~(0x3f<<13);
            (*P_PREG_JTAG_GPIO_ADDR)&= ~((1<<20)   // test_n_gpio_o
                           |(1<<16)); // test_n_gpio_en_n

            *P_PERIPHS_PIN_MUX_0|=0x3f<<23;
            SD_boot_type=0;
            break;
        case POR_SDIO_B_ENABLE://SDIOB,GPIOA_0~GPIOA_5
            *P_PREG_EGPIO_EN_N &=~(0x3f<<4);
            *P_PREG_EGPIO_O    &=~(0x3f<<4);

            (*P_PREG_JTAG_GPIO_ADDR)       &= ~((1<<20)   // test_n_gpio_o
                       |(1<<16)); // test_n_gpio_en_n
            //diable SDIO_B1
            *P_PERIPHS_PIN_MUX_7&=~(0x3f<<24);
            *P_PERIPHS_PIN_MUX_1|=0x3f;
            SD_boot_type=1;
            break;
        case POR_SDIO_C_ENABLE://SDIOC GPIOB_2~GPIOB_7
            *P_PREG_EGPIO_EN_N &=~(0x3f<<21);
            *P_PREG_EGPIO_O    &=~(0x3f<<21);
            (*P_PREG_JTAG_GPIO_ADDR)       &= ~((1<<20)   // test_n_gpio_o
                   |(1<<16)); // test_n_gpio_en_n

            *P_PERIPHS_PIN_MUX_2|=(0xf<<16)|(1<<12)|(1<<8);
            SD_boot_type=2;
            break;
        default://SDIOB1 GPIOE_6~GPIOE_11
            // disable SPI and SDIO_B
            (*P_PERIPHS_PIN_MUX_1)  &=~( (1<<29) | (1<<27) | (1<<25) | (1<<23)|0x3f);
            // disable NAND
            (*P_PERIPHS_PIN_MUX_6)  &=~(0x7fff);
            *P_PREG_HGPIO_EN_N &=~((0x3f<<6)|(3<<4));
            *P_PREG_HGPIO_O    &=~(0x3f<<6);
            *P_PREG_HGPIO_O    |=(3<<4);//deselect SPI and NAND
//            *P_PREG_JTAG_GPIO_ADDR &=~((1<<20)|(1<<16)); For iNand , CARD_EN is not needed .

            *P_PERIPHS_PIN_MUX_7|=(0x3f<<24);
            SD_boot_type=1;
            break;
    }
*/
