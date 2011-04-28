#include <config.h>
#include <asm/arch/io.h>
#include <asm/arch/sdio.h>

static struct aml_card_sd_info m3_sdio_ports[]={
    { .sdio_port=SDIO_PORT_A,.name="SDIO Port A"},
    { .sdio_port=SDIO_PORT_B,.name="SDIO Port B"},
    { .sdio_port=SDIO_PORT_C,.name="SDIO Port C"},
    { .sdio_port=SDIO_PORT_XC_A,.name="SDIO Port XC-A"},
    { .sdio_port=SDIO_PORT_XC_B,.name="SDIO Port XC-B"},
    { .sdio_port=SDIO_PORT_XC_C,.name="SDIO Port XC-C"},
};
struct aml_card_sd_info * cpu_sdio_get(unsigned port)
{
    if(port<SDIO_PORT_C+1)
        return &m3_sdio_ports[port];
    return NULL;
}

void  cpu_sdio_pwr_prepare(unsigned port)
{
    switch(port)
    {
        case SDIO_PORT_A:
            clrbits_le32(P_PREG_PAD_GPIO4_EN_N,0x30f);
            clrbits_le32(P_PREG_PAD_GPIO4_O   ,0x30f);
            clrbits_le32(P_PERIPHS_PIN_MUX_8,0x3f);break;
        case SDIO_PORT_B:
            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,0x3f<<23);
            clrbits_le32(P_PREG_PAD_GPIO5_O   ,0x3f<<23);
            clrbits_le32(P_PERIPHS_PIN_MUX_2,0x3f<<10);break;
        case SDIO_PORT_C:
            //clrbits_le32(P_PREG_PAD_GPIO3_EN_N,0xc0f);
            //clrbits_le32(P_PREG_PAD_GPIO3_O   ,0xc0f);
            //clrbits_le32(P_PERIPHS_PIN_MUX_6,(0x3f<<24));break;
        case SDIO_PORT_XC_A:
            break;
        case SDIO_PORT_XC_B:
            break;
        case SDIO_PORT_XC_C:
            //clrbits_le32(P_PREG_PAD_GPIO3_EN_N,0xcff);
            //clrbits_le32(P_PREG_PAD_GPIO3_O   ,0xcff);
            //clrbits_le32(P_PERIPHS_PIN_MUX_4,(0xf<<26));
            //printf("inand sdio xc-c prepare\n");
            break;
    }
    
    /**
        do nothing here
    */
}
int cpu_sdio_init(unsigned port)
{
          
    //printf("inand sdio  port:%d\n",port);
    switch(port)
    {
        case SDIO_PORT_A:setbits_le32(P_PERIPHS_PIN_MUX_8,0x3f);break;
            
        case SDIO_PORT_B:        	
        	setbits_le32(P_PERIPHS_PIN_MUX_2,0x3f<<10);break;
        case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
            clrbits_le32(P_PERIPHS_PIN_MUX_2,(0x1f<<22));
            setbits_le32(P_PERIPHS_PIN_MUX_6,(0x3f<<26));
            //printf("inand sdio  port:%d\n",port);
            break;
        case SDIO_PORT_XC_A:
            #if 0
            //sdxc controller can't work
            clrbits_le32(P_PERIPHS_PIN_MUX_8,(0x3f<<0));
            clrbits_le32(P_PERIPHS_PIN_MUX_3,(0x0f<<27));
            clrbits_le32(P_PERIPHS_PIN_MUX_7,((0x3f<<18)|(0x7<<25)));
            //setbits_le32(P_PERIPHS_PIN_MUX_5,(0x1f<<10));//data 8 bit
            setbits_le32(P_PERIPHS_PIN_MUX_5,(0x1b<<10));//data 4 bit
            #endif
            break;
        case SDIO_PORT_XC_B:
            //sdxc controller can't work
            //setbits_le32(P_PERIPHS_PIN_MUX_2,(0xf<<4));
            break;
        case SDIO_PORT_XC_C:
            #if 0
            //sdxc controller can't work
            clrbits_le32(P_PERIPHS_PIN_MUX_6,(0x3f<<24));
            clrbits_le32(P_PERIPHS_PIN_MUX_2,((0x13<<22)|(0x3<<16)));
            setbits_le32(P_PERIPHS_PIN_MUX_4,(0x1f<<26));
            printf("inand sdio xc-c init\n");
            #endif
            break;
        default:
            return -1;
    }
    return 0;
}