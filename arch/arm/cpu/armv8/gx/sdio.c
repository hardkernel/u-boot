#include <config.h>
#include <asm/io.h>
#include <asm/arch/cpu_sdio.h>


void  cpu_sd_emmc_pwr_prepare(unsigned port)
{
//    switch(port)
//    {
//        case SDIO_PORT_A:
//            clrbits_le32(P_PREG_PAD_GPIO4_EN_N,0x30f);
//            clrbits_le32(P_PREG_PAD_GPIO4_O   ,0x30f);
//            clrbits_le32(P_PERIPHS_PIN_MUX_8,0x3f);
//            break;
//        case SDIO_PORT_B:
//            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,0x3f<<23);
//            clrbits_le32(P_PREG_PAD_GPIO5_O   ,0x3f<<23);
//            clrbits_le32(P_PERIPHS_PIN_MUX_2,0x3f<<10);
//            break;
//        case SDIO_PORT_C:
//            //clrbits_le32(P_PREG_PAD_GPIO3_EN_N,0xc0f);
//            //clrbits_le32(P_PREG_PAD_GPIO3_O   ,0xc0f);
//            //clrbits_le32(P_PERIPHS_PIN_MUX_6,(0x3f<<24));break;
//            break;
//    }

    /**
        do nothing here
    */
}
int cpu_sd_emmc_init(unsigned port)
{

    //printf("inand sdio  port:%d\n",port);
    switch (port)
    {
        case SDIO_PORT_A:
			setbits_le32(P_PERIPHS_PIN_MUX_8,0x3f);
			break;

        case SDIO_PORT_B:
			setbits_le32(P_PERIPHS_PIN_MUX_2,0x3f<<10);
			break;
        case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
			clrbits_le32(P_PERIPHS_PIN_MUX_2,(0x1f<<22));
			setbits_le32(P_PERIPHS_PIN_MUX_4,(0x3<<18)|(3<<30));
            //printf("inand sdio  port:%d\n",port);
            break;
        default:
            return -1;
    }
    return 0;
}