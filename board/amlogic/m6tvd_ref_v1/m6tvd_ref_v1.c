#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <malloc.h>
#include <mmc.h>


#if defined(CONFIG_CMD_NET)
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/io.h>
#endif /*(CONFIG_CMD_NET)*/

#include <version.h>
#include <timestamp.h>

#if defined(CONFIG_AML_I2C)
#include <aml_i2c.h>
#include <asm/arch/io.h>
#endif /*CONFIG_AML_I2C*/
#include <asm/arch/gpio.h>
#include <asm/arch/reboot.h>
#define reboot_mode *((volatile unsigned long*)0xc8100004)
DECLARE_GLOBAL_DATA_PTR;


#if defined(CONFIG_CMD_NET)

/*************************************************
  * Amlogic Ethernet controller operation
  *
  * Note: The LAN chip LAN8720 need to be reset
  *
  *************************************************/
static void setup_net_chip(void)
{
#ifdef CONFIG_NET_RGMII
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x309);
	/* setup ethernet pinmux */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x4007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x211);
#elif defined(CONFIG_NET_RMII_CLK_EXTERNAL)
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x130);
	/* setup ethernet pinmux */
	WRITE_CBUS_REG(PERIPHS_PIN_MUX_6, 0x8007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x241);
#else
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x702);
	/* setup ethernet pinmux */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x4007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x241);
#endif

	/* setup ethernet interrupt */
	SET_CBUS_REG_MASK(SYS_CPU_0_IRQ_IN0_INTR_MASK, 1 << 8);
	SET_CBUS_REG_MASK(SYS_CPU_0_IRQ_IN1_INTR_STAT, 1 << 8);

	/* hardware reset ethernet phy */
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO5_EN_N, 1 << 15);
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO5_O, 1 << 15);
	udelay(2000);
	SET_CBUS_REG_MASK(PREG_PAD_GPIO5_O, 1 << 15);
}
static void setup_internal_phy(void)
{
		printf("setup_internal_phy\n");
#if 0
		WRITE_CBUS_REG(0x1076, 0x00000113);
		WRITE_CBUS_REG(0x2032, 0x00000000);
		WRITE_CBUS_REG(0x2042, 0x4700b002);
		WRITE_CBUS_REG(0x2046, 0x89637989);
		WRITE_CBUS_REG(0x1102, 0x00000800);
		WRITE_CBUS_REG(0x103d, 0x10d396e1);
		//WRITE_CBUS_REG(0x103e, 0x45040828);
		//WRITE_CBUS_REG(0x103e, 0x45000828);
		WRITE_CBUS_REG(0x103c, 0x12848480);
		WRITE_CBUS_REG(0x103f, 0x3dea4000);
		WRITE_CBUS_REG(0x1040, 0x00000004);
		WRITE_CBUS_REG(0x1041, 0x0);
		WRITE_CBUS_REG(0x1042, 0x2a855008);
		WRITE_CBUS_REG(0x103e, 0x45040828);
		WRITE_CBUS_REG(0x103e, 0x45000828);
#elif 0
	WRITE_CBUS_REG(0x1076, 0x193);
	WRITE_CBUS_REG(0x2032, 0x00000000);
	WRITE_CBUS_REG(0x2042, 0x4100b000);
	WRITE_CBUS_REG(0x2046, 0x89637989);
	WRITE_CBUS_REG(0x1102, 0x800);
	WRITE_CBUS_REG(0x103d, 0x10d396e1);
	WRITE_CBUS_REG(0x103e, 0x45000828);
	WRITE_CBUS_REG(0x103c, 0x128484bf);
	WRITE_CBUS_REG(0x103f, 0x7bdea4000);
	WRITE_CBUS_REG(0x1040, 0xf);
	WRITE_CBUS_REG(0x1041, 0x0);
	WRITE_CBUS_REG(0x1042, 0x2a855008);
	WRITE_CBUS_REG(0x103e, 0x45040828);
	WRITE_CBUS_REG(0x103e, 0x45000828);
#else
	WRITE_CBUS_REG(0x1076, 0x00008d00);
	WRITE_CBUS_REG(0x2032, 0x3f000000);
	WRITE_CBUS_REG(0x2042, 0x47803442);
	WRITE_CBUS_REG(0x2046, 0x89637989);
	WRITE_CBUS_REG(0x1102, 0x00000800);
	WRITE_CBUS_REG(0x103d, 0x10d396e1);
	//WRITE_CBUS_REG(0x103e, 0x45040828);
	//WRITE_CBUS_REG(0x103e, 0x45000828);
	WRITE_CBUS_REG(0x103c, 0x12848485);
	WRITE_CBUS_REG(0x103f, 0x46ea4000);
	WRITE_CBUS_REG(0x1040, 0x00000001);
	WRITE_CBUS_REG(0x1041, 0x3000);
	WRITE_CBUS_REG(0x1042, 0x55055009);  
	WRITE_CBUS_REG(0x103e, 0x4504187d);
	WRITE_CBUS_REG(0x103e, 0x4500187d);
	WRITE_CBUS_REG(0x2042, 0x47802442);
	WRITE_CBUS_REG(0x2042, 0x47803442);


#endif
}
int board_eth_init(bd_t *bis)
{
    printf("board_eth_init\n");
    setup_net_chip();

    udelay(1000);

	extern int aml_eth_init(bd_t *bis);
    aml_eth_init(bis);

	return 0;
}
#endif /* (CONFIG_CMD_NET) */

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
/*following key value are test with board
  [M6_SKT_V_1.0 20120112]
  ref doc:
  1. M6_SKT_V1.pdf
*/
/* adc_init(&g_adc_info, ARRAY_SIZE(g_adc_info)); */
/*following is test code to test ADC & key pad*/
static int do_adc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if(argc > 2)
		goto usage;

	u32 nDelay = 0xffff;
	int nKeyVal = 0;
	int nCnt = 0;
	char *endp;
	int nMaxCnt;
	if(2 == argc)
		nMaxCnt	= simple_strtoul(argv[1], &endp, 10);
	else
		nMaxCnt = 10;

	saradc_enable();
	while(nCnt < nMaxCnt)
	{
		udelay(nDelay);
		nKeyVal = get_adc_sample(4);
		if(nKeyVal > 1000)
			continue;

		printf("SARADC CH-4 Get key : %d [%d]\n", nKeyVal,(100*nKeyVal)/1024);
		nCnt++;
	}
	saradc_disable();

	return 0;

usage:
	return cmd_usage(cmdtp);
}

U_BOOT_CMD(
	adc,	2,	1,	do_adc,
	"M6 ADC test",
	"[times] -  read `times' adc key through channel-4, default to read 10 times\n"
	"		10bit ADC. key value: min=0; max=1024\n"
	"		SKT BOARD #20: Key1=13 Key2=149 key3=274 key4=393 key5=514\n"
);

#endif //CONFIG_SARADC



extern  int mmc_device_partitions (struct mmc *mmc);
static int partition_set(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int ret = 0;

    struct mmc *mmc_ver; //struct mmc *mmc
    mmc_ver = find_mmc_device(1);
    if (mmc_ver) {
        ret = mmc_device_partitions(mmc_ver); // init eMMC/tSD
    }

    return 0;
}

U_BOOT_CMD(
	debug_mmcinfo,	2,	1,	partition_set,
	" M6TVD debug mmc info & check partition ",
	" if check erro, then write partition to emmc reveser partition \n"
	" usage: partition \n"
);

#if defined(CONFIG_AML_SUSPEND)
typedef struct {
    char name[32];
    unsigned bank;
    unsigned bit;
    gpio_mode_t mode;
    unsigned value;
    unsigned enable;
    unsigned keep_last;
} gpio_data_t;

#define MAX_GPIO 2

static gpio_data_t gpio_data[MAX_GPIO] = {
    // ----------------------------------- bl ----------------------------------
    {"GPIOX2 -- BL_EN",         GPIOX_bank_bit0_31(2),     GPIOX_bit_bit0_31(2),  GPIO_OUTPUT_MODE, 1, 1, 1},
    // ----------------------------------- panel ----------------------------------
    {"GPIOZ5 -- PANEL_PWR",     GPIOZ_bank_bit0_19(5),     GPIOZ_bit_bit0_19(5),  GPIO_OUTPUT_MODE, 1, 1, 1},
    // ----------------------------------- i2c ----------------------------------
    //{"GPIOZ6 -- iic",           GPIOZ_bank_bit0_19(6),     GPIOZ_bit_bit0_19(6),  GPIO_OUTPUT_MODE, 1, 1, 1},
    //{"GPIOZ7 -- iic",           GPIOZ_bank_bit0_19(7),     GPIOZ_bit_bit0_19(7),  GPIO_OUTPUT_MODE, 1, 1, 1},
};

static void save_gpio(int port)
{
    gpio_data[port].mode = get_gpio_mode(gpio_data[port].bank, gpio_data[port].bit);
    if (gpio_data[port].mode==GPIO_OUTPUT_MODE)
    {
        if (gpio_data[port].enable){
            printf("%d---change %s output %d to input\n", port, gpio_data[port].name, gpio_data[port].value);
            gpio_data[port].value = get_gpio_val(gpio_data[port].bank, gpio_data[port].bit);
            set_gpio_mode(gpio_data[port].bank, gpio_data[port].bit, GPIO_INPUT_MODE);
        } else{
            printf("%d---no change %s output %d\n", port, gpio_data[port].name, gpio_data[port].value);
        }
    } else {
        printf("%d---%s input %d\n", port, gpio_data[port].name, gpio_data[port].mode);
    }
}

static void restore_gpio(int port)
{
    if ((gpio_data[port].mode==GPIO_OUTPUT_MODE)&&(gpio_data[port].enable))
    {
        set_gpio_val(gpio_data[port].bank, gpio_data[port].bit, gpio_data[port].value);
        set_gpio_mode(gpio_data[port].bank, gpio_data[port].bit, GPIO_OUTPUT_MODE);
        printf("%d---%s output %d\n", port, gpio_data[port].name, gpio_data[port].value);
    } else {
        printf("%d---%s output/input:%d, enable:%d\n", port, gpio_data[port].name, gpio_data[port].mode, gpio_data[port].value);
    }
}

typedef struct {
    char name[32];
    unsigned reg;
    unsigned bits;
    unsigned enable;
} pinmux_data_t;


#define MAX_PINMUX 10

pinmux_data_t pinmux_data[MAX_PINMUX] = {
    {"PERIPHS_PIN_MUX_0",         0, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_1",         1, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_2",         2, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_3",         3, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_4",         4, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_5",         5, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_6",         6, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_7",         7, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_8",         8, 0xffffffff,               1},
    {"PERIPHS_PIN_MUX_9",         9, 0xffffffff,               1},
};
#define MAX_INPUT_MODE 9
pinmux_data_t gpio_inputmode_data[MAX_INPUT_MODE] = {
    {"LCDGPIOA",         P_PREG_PAD_GPIO0_EN_N, 0x3fffffff,                 1},
    {"LCDGPIOB",         P_PREG_PAD_GPIO1_EN_N, 0x00ffffff,                 1},
    {"GPIOX0_12",        P_PREG_PAD_GPIO4_EN_N, 0x00001fff,                 1},
    {"BOOT0_17",         P_PREG_PAD_GPIO3_EN_N, 0x0003ffff,                 1},
    {"GPIOZ0_19",        P_PREG_PAD_GPIO6_EN_N, 0x000fffff,                 1},
    {"GPIOY0_27",        P_PREG_PAD_GPIO2_EN_N, 0x0fffffff,                 1},
    {"GPIOW0_19",        P_PREG_PAD_GPIO5_EN_N, 0x000fffff,                 1},
    {"CRAD0_8",          P_PREG_PAD_GPIO5_EN_N, 0xff000000,                 1},
    {"GPIOP6",           P_PREG_PAD_GPIO1_EN_N, 0x40000000,                 1},
};

#define MAX_RESUME_OUTPUT_MODE 1
pinmux_data_t gpio_outputmode_data[MAX_RESUME_OUTPUT_MODE] = {
    {"GPIOZ6_7",        P_PREG_PAD_GPIO6_EN_N, 0x000fff3f,                 1},
};
static unsigned pinmux_backup[10];

#define MAX_PADPULL 7

pinmux_data_t pad_pull[MAX_PADPULL] = {
    {"PAD_PULL_UP_REG0",         P_PAD_PULL_UP_REG0, 0xffffffff,               1},
    {"PAD_PULL_UP_REG1",         P_PAD_PULL_UP_REG1, 0x00000000,               1},
    {"PAD_PULL_UP_REG2",         P_PAD_PULL_UP_REG2, 0xffffffff,               1},
    {"PAD_PULL_UP_REG3",         P_PAD_PULL_UP_REG3, 0xffffffff,               1},
    {"PAD_PULL_UP_REG4",         P_PAD_PULL_UP_REG4, 0xffffffff,               1},
    {"PAD_PULL_UP_REG5",         P_PAD_PULL_UP_REG5, 0xffffffff,               1},
    {"PAD_PULL_UP_REG6",         P_PAD_PULL_UP_REG6, 0xffffffff,               1},
};

static unsigned pad_pull_backup[MAX_PADPULL];

int  clear_mio_mux_m6tv(unsigned mux_index, unsigned mux_mask)
{
    unsigned mux_reg[] = {PERIPHS_PIN_MUX_0, PERIPHS_PIN_MUX_1, PERIPHS_PIN_MUX_2,PERIPHS_PIN_MUX_3,
        PERIPHS_PIN_MUX_4,PERIPHS_PIN_MUX_5,PERIPHS_PIN_MUX_6,PERIPHS_PIN_MUX_7,PERIPHS_PIN_MUX_8,
        PERIPHS_PIN_MUX_9,PERIPHS_PIN_MUX_10,PERIPHS_PIN_MUX_11,PERIPHS_PIN_MUX_12};
    if (mux_index < 13) {
        CLEAR_CBUS_REG_MASK(mux_reg[mux_index], mux_mask);
        return 0;
    }
    return -1;
}

static void save_pinmux(void)
{
    int i;
    for (i=0;i<10;i++){
        pinmux_backup[i] = READ_CBUS_REG(PERIPHS_PIN_MUX_0+i);
        printf("--PERIPHS_PIN_MUX_%d = %x\n", i,pinmux_backup[i]);
    }
    for (i=0;i<MAX_PADPULL;i++){
        pad_pull_backup[i] = readl(pad_pull[i].reg);
        printf("--PAD_PULL_UP_REG%d = %x\n", i,pad_pull_backup[i]);
    }
    for (i=0;i<MAX_PINMUX;i++){
        if (pinmux_data[i].enable){
            printf("%s %x\n", pinmux_data[i].name, pinmux_data[i].bits);
            clear_mio_mux_m6tv(pinmux_data[i].reg, pinmux_data[i].bits);
        }
    }
    for (i=0;i<MAX_PADPULL;i++){
        if (pad_pull[i].enable){
            printf("%s %x\n", pad_pull[i].name, pad_pull[i].bits);
            writel(readl(pad_pull[i].reg) | pad_pull[i].bits,pad_pull[i].reg);
        }
    }
    for (i=0;i<MAX_INPUT_MODE;i++){
        if (gpio_inputmode_data[i].enable){
            printf("%s %x\n", gpio_inputmode_data[i].name, gpio_inputmode_data[i].bits);
            writel(readl(gpio_inputmode_data[i].reg) | gpio_inputmode_data[i].bits,gpio_inputmode_data[i].reg);
        }
    }
}

static void restore_pinmux(void)
{
    int i;
    /*for (i=0;i<MAX_RESUME_OUTPUT_MODE;i++){
        if (gpio_outputmode_data[i].enable){
            printk("%s %x\n", gpio_outputmode_data[i].name, gpio_outputmode_data[i].bits);
            writel(gpio_outputmode_data[i].reg, readl(gpio_outputmode_data[i].reg) & gpio_outputmode_data[i].bits);
        }
    }
    set_gpio_val(GPIOZ_bank_bit0_19(6), GPIOZ_bit_bit0_19(6), 1);
    set_gpio_mode(GPIOZ_bank_bit0_19(6), GPIOZ_bit_bit0_19(6), GPIO_OUTPUT_MODE);
    set_gpio_val(GPIOZ_bank_bit0_19(7), GPIOZ_bit_bit0_19(7), 1);
    set_gpio_mode(GPIOZ_bank_bit0_19(7), GPIOZ_bit_bit0_19(7), GPIO_OUTPUT_MODE);*/
    clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<19));
    setbits_le32(P_PREG_PAD_GPIO5_O,(1<<19));
    for (i=0;i<10;i++){
    	 printf("++PERIPHS_PIN_MUX_%d = %x\n", i,pinmux_backup[i]);
         WRITE_CBUS_REG(PERIPHS_PIN_MUX_0+i, pinmux_backup[i]);
     }
     for (i=0;i<MAX_PADPULL;i++){
    	 printf("++PAD_PULL_UP_REG%d = %x\n", i,pad_pull_backup[i]);
         writel(pad_pull_backup[i],pad_pull[i].reg);
     }
}

void m6tvdref_set_pinmux(int power_on)
{
    int i = 0;
    if (power_on) {
        restore_pinmux();
        for (i=0;i<MAX_GPIO;i++)
            restore_gpio(i);
        printf( "%s() Power ON\n", __FUNCTION__);
    } else {
        save_pinmux();
        for (i=0;i<MAX_GPIO;i++)
            save_gpio(i);
        printf( "%s() Power OFF\n", __FUNCTION__);
    }
}

#endif
#ifdef CONFIG_SWITCH_BOOT_MODE
int switch_boot_mode(void)
{

#ifdef CONFIG_INTERNAL_PHY
	setup_internal_phy();
#endif
	printf("switch_boot_mode\n");
    u32 reboot_mode_current = reboot_mode;
	char *suspend = getenv("suspend");
	int ret0 = strcmp(suspend,"on");
	if (ret0 == 0){
		setenv("suspend","off");
		saveenv();
		printf("enter suspend = %s\n",suspend);
		run_command("suspend",0);
	}
    printf("reboot_mode_current=%x\n",reboot_mode_current);
    switch(reboot_mode_current)
	{
	case AMLOGIC_LOCK_REBOOT:
	{
		printf("AML suspend boot....\n");
		reboot_mode = 0;
		run_command("suspend",0);
	}
	case AMLOGIC_UPDATE_REBOOT:
	case AMLOGIC_FACTORY_RESET_REBOOT:
	{
	    run_command("run recoveryinand",0);
    	extern int aml_autoscript(void);
        aml_autoscript();
	}
	}

	unsigned int suspend_status_current2 = readl(P_AO_RTI_STATUS_REG2);
	char *suspend_str = getenv ("suspend");
	char *factory_standby_str = getenv ("factory_standby");
	printf("suspend = %s\n", suspend_str);
	printf("factory_standby = %s\n", factory_standby_str);
	printf("suspend_status_current2=0x%x\n",suspend_status_current2);

	if(!strcmp(factory_standby_str, "1"))
	{
		if(suspend_status_current2 == 0x1234abcd)
		{
			writel(0,P_AO_RTI_STATUS_REG2);
			run_command ("set suspend off", 0);
			run_command ("save", 0);
		}
		else
		{
			run_command ("suspend", 0);
		}
	}
	else
	{
		if(!strcmp(suspend_str, "on"))
 		{
			run_command ("set suspend done", 0);
			run_command ("save", 0);
			run_command ("suspend", 0);
		}
		else if(!strcmp(suspend_str, "done"))
		{
			if(suspend_status_current2 == 0x1234abcd)
			{
				writel(0,P_AO_RTI_STATUS_REG2);
				run_command ("set suspend off", 0);
				run_command ("save", 0);
			}
			else
			{
				run_command ("suspend", 0);
			}
		}
	}
    return 0;
}
#endif

u32 get_board_rev(void)
{
    /*
    @todo implement this function
    */
	return 0x20;
}

#if CONFIG_CMD_MMC
#include <mmc.h>
#include <asm/arch/sdio.h>
static int  sdio_init(unsigned port)
{
    //todo add card detect
//	setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
switch(port)
      {
            case SDIO_PORT_A:
                  break;
            case SDIO_PORT_B:
                  //todo add card detect
                  setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
                  break;
            case SDIO_PORT_C:
                  //enable pull up
                  clrbits_le32(P_PAD_PULL_UP_REG3, 0xf|(3<<10));
                  break;
            case SDIO_PORT_XC_A:
                  break;
            case SDIO_PORT_XC_B:
                  break;
            case SDIO_PORT_XC_C:
                  break;
            default:
                  break;
      }

      return cpu_sdio_init(port);

}
static int  sdio_detect(unsigned port)
{
	int ret;
      switch(port)
      {
            case SDIO_PORT_A:
                  break;
            case SDIO_PORT_B:
                  setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
                  ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
                  printf( " %s return %d\n",__func__,ret);
                  break;
            case SDIO_PORT_C:
                  break;
            case SDIO_PORT_XC_A:
                  break;
            case SDIO_PORT_XC_B:
                  break;
            case SDIO_PORT_XC_C:
                  break;
            default:
                  break;
      }

	return 0;
}
static void sdio_pwr_prepare(unsigned port)
{
	switch(port)
      {
            case SDIO_PORT_A:
                  break;
            case SDIO_PORT_B:
                  break;
            case SDIO_PORT_C:
                  break;
            case SDIO_PORT_XC_A:
                  break;
            case SDIO_PORT_XC_B:
                  break;
            case SDIO_PORT_XC_C:
                  break;
            default:
                  break;
      }

      cpu_sdio_pwr_prepare(port);
    /// @todo NOT FINISH
	///do nothing here
}
static void sdio_pwr_on(unsigned port)
{
	switch(port)
      {
            case SDIO_PORT_A:
                  break;
            case SDIO_PORT_B:
                  clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
                  clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
                  break;
            case SDIO_PORT_C:
                  break;
            case SDIO_PORT_XC_A:
                  break;
            case SDIO_PORT_XC_B:
                  break;
            case SDIO_PORT_XC_C:
                  break;
            default:
                  break;
      }
      return;

    /// @todo NOT FINISH
}
static void sdio_pwr_off(unsigned port)
{
	switch(port)
      {
            case SDIO_PORT_A:
                  break;
            case SDIO_PORT_B:
                  setbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
                  clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
                  break;
            case SDIO_PORT_C:
                  break;
            case SDIO_PORT_XC_A:
                  break;
            case SDIO_PORT_XC_B:
                  break;
            case SDIO_PORT_XC_C:
                  break;
            default:
                  break;
      }
      return;

	/// @todo NOT FINISH
}

#define CONFIG_EMMC     1
//#define CONFIG_TSD      1
static void board_mmc_register(unsigned port)
{
    struct aml_card_sd_info *aml_priv=cpu_sdio_get(port);

    struct mmc *mmc = (struct mmc *)malloc(sizeof(struct mmc));
    if(aml_priv==NULL||mmc==NULL)
        return;
    aml_priv->sdio_init=sdio_init;
	aml_priv->sdio_detect=sdio_detect;
	aml_priv->sdio_pwr_off=sdio_pwr_off;
	aml_priv->sdio_pwr_on=sdio_pwr_on;
	aml_priv->sdio_pwr_prepare=sdio_pwr_prepare;
	sdio_register(mmc,aml_priv);
#if 0
  #ifdef CONFIG_TSD
	     if(mmc->block_dev.dev > 0)//tsd
	           mmc->block_dev.if_type = IF_TYPE_SD;
	 #else
	     if(mmc->block_dev.dev > 0)//emmc
	           mmc->block_dev.if_type = IF_TYPE_MMC;
	#endif
#endif

	mmc->block_dev.if_type = IF_TYPE_SD;
	//if(port == SDIO_PORT_C){
	//	mmc->block_dev.if_type = IF_TYPE_MMC;
	//}


#if 0
    strncpy(mmc->name,aml_priv->name,31);
    mmc->priv = aml_priv;
	aml_priv->removed_flag = 1;
	aml_priv->inited_flag = 0;
	aml_priv->sdio_init=sdio_init;
	aml_priv->sdio_detect=sdio_detect;
	aml_priv->sdio_pwr_off=sdio_pwr_off;
	aml_priv->sdio_pwr_on=sdio_pwr_on;
	aml_priv->sdio_pwr_prepare=sdio_pwr_prepare;
	mmc->send_cmd = aml_sd_send_cmd;
	mmc->set_ios = aml_sd_cfg_swth;
	mmc->init = aml_sd_init;
	mmc->rca = 1;
	mmc->voltages = MMC_VDD_33_34;
	mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_HS;
	//mmc->host_caps = MMC_MODE_4BIT;
	mmc->bus_width = 1;
	mmc->clock = 300000;
	mmc->f_min = 200000;
	mmc->f_max = 50000000;
	mmc_register(mmc);
#endif
}
int board_mmc_init(bd_t	*bis)
{
//board_mmc_register(SDIO_PORT_A);
	board_mmc_register(SDIO_PORT_B);
	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}
#endif

#ifdef CONFIG_AML_I2C
/*I2C module is board depend*/
static void board_i2c_set_pinmux(void){
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
    /*********************************************/
    /*                | I2C_Master_B        |I2C_Slave            |       */
    /*********************************************/
    /*                | I2C_SCK                | I2C_SCK_SLAVE  |      */
    /* GPIOX28  | [PIM_MUX5:30]     | [PIM_MUX5:28]   |     */
    /*********************************************/
    /*                | I2C_SDA                 | I2C_SDA_SLAVE  |     */
    /* GPIOX27  | [PIM_MUX5:31]     | [PIM_MUX5:29]   |     */
    /*********************************************/
	//Wr(PAD_PULL_UP_REG4,Rd(PAD_PULL_UP_REG4) | (1 << 27)| (1 << 28) );

	//disable all other pins which share with I2C_SDA_B & I2C_SCK_B
    clrbits_le32(MESON_I2C_MASTER_B_GPIOX_27_REG,((1<<28)|(1<<29)));
    //enable I2C MASTER B pins
	setbits_le32(MESON_I2C_MASTER_B_GPIOX_27_REG,
	(MESON_I2C_MASTER_B_GPIOX_27_BIT|MESON_I2C_MASTER_B_GPIOX_28_BIT));

    udelay(10000);

};
struct aml_i2c_platform g_aml_i2c_plat = {
    .wait_count         = 1000000,
    .wait_ack_interval  = 5,
    .wait_read_interval = 5,
    .wait_xfer_interval = 5,
    .master_no          = AML_I2C_MASTER_B,
    .use_pio            = 0,
    .master_i2c_speed   = AML_I2C_SPPED_400K,
    .master_b_pinmux = {
        .scl_reg    = MESON_I2C_MASTER_B_GPIOX_28_REG,
        .scl_bit    = MESON_I2C_MASTER_B_GPIOX_28_BIT,
        .sda_reg    = MESON_I2C_MASTER_B_GPIOX_27_REG,
        .sda_bit    = MESON_I2C_MASTER_B_GPIOX_27_BIT,
    }
};

#define I2C_ALC5631Q_ADDR   (0x1A)

void i2c_ALC5631Q_write(unsigned char reg, unsigned short val)
{
    unsigned char buff[3];
    buff[0] = reg;
    buff[1] = (val >> 8) & 0xFF; //MSB
	buff[2] = (val & 0xFF); //LSB

	struct i2c_msg msg[] = {
        {
        .addr  = I2C_ALC5631Q_ADDR,
        .flags = 0,
        .len   = 3,
        .buf   = buff,
        }
    };

    if (aml_i2c_xfer(msg, 1) < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }
}

unsigned short i2c_ALC5631Q_read(unsigned char reg)
{
    unsigned short val = 0;
    struct i2c_msg msgs[] = {
        {
            .addr = I2C_ALC5631Q_ADDR,
            .flags = 0,
            .len = 1,
            .buf = &reg,
        },
        {
            .addr = I2C_ALC5631Q_ADDR,
            .flags = I2C_M_RD,
            .len = 2,
            .buf = &val,
        },
    };

    if ( aml_i2c_xfer(msgs, 2)< 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }

	/*@ALC5631Q-VE DataSheet_0.91.pdf Page31*/
    return (val & 0xFF)<< 8 | ((val >> 8) & 0xFF);
}
void board_M6_SKT_V1_i2c_test(void)
{
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	/*@ALC5631Q-VE DataSheet_0.91.pdf*/
	int nMaxID = 0x20;
	int nIdx = 0;
	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump begin:\n");
	for(nIdx = 0;nIdx <= nMaxID;nIdx+=2)
		printf("Reg addr=0x%02x Val=0x%04x\n",
		nIdx,i2c_ALC5631Q_read(nIdx));

	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump end.\n\n");

	//try to write some reg
	/*
	i2c_ALC5631Q_write(0x02,0xAA55);
	i2c_ALC5631Q_write(0x04,0x0);

	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump begin:\n");
	for(nIdx = 0;nIdx <= nMaxID;nIdx+=2)
		printf("Reg addr=0x%02x Val=0x%04x\n",
		nIdx,i2c_ALC5631Q_read(nIdx));

	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump end.\n\n");
	*/

}

static void board_i2c_init(void)
{
	//set I2C pinmux with PCB board layout
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation
	/*M6 socket board*/
	board_M6_SKT_V1_i2c_test();
	//udelay(10000);

	udelay(10000);
}

//for sys_test only, not check yet
static struct i2c_board_info aml_i2c_info[] = {
    {
        I2C_BOARD_INFO("I2C ALC5631Q", 000),
        .device_init = board_i2c_init,
    },
};

struct aml_i2c_device aml_i2c_devices={
	.aml_i2c_boards = aml_i2c_info,
	.dev_num = sizeof(aml_i2c_info)/sizeof(struct i2c_board_info)
};
#endif /*CONFIG_AML_I2C*/

#if CONFIG_JERRY_NAND_TEST //temp test
#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>
static void claim_bus(uint32_t get)
{
	if(get==NAND_BUS_RELEASE)
	{
		NAND_IO_DISABLE(0);
	}else{
		NAND_IO_ENABLE(0);
	}
}
static struct aml_nand_platform nand_plat={
/*
		uint32_t        reg_base;
		    uint32_t        delay;
		    uint32_t        rbmod;
		    uint32_t        t_rea;
		    uint32_t        t_rhoh;
		    uint32_t        ce_num;
		    uint32_t        clk_src;
		    claim_bus_t     claim_bus;
*/
		.ce_num=4,
		.rbmod=1,
};
void    board_nand_init(void)
{
	nanddebug("NAND is inited\n");
	nand_probe(&nand_plat);
//	cntl_init(&nand_plat);
//	amlnand_probe();
}
#elif CONFIG_NAND_AML_M3 //temp test
//#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>


static struct aml_nand_platform aml_nand_mid_platform[] = {
    {
        .name = NAND_BOOT_NAME,
        .chip_enable_pad = AML_NAND_CE0,
        .ready_busy_pad = AML_NAND_CE0,
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 1,
                .options = (NAND_TIMING_MODE5 | NAND_ECC_BCH30_1K_MODE),
            },
        },
        .rbpin_mode=1,
        .short_pgsz=384,
        .ran_mode=0,
        .T_REA = 20,
        .T_RHOH = 15,
    },
    {
        .name = NAND_NORMAL_NAME,
        .chip_enable_pad = (AML_NAND_CE0) ,  //| (AML_NAND_CE1 << 4) | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
        .ready_busy_pad = (AML_NAND_CE0) ,  //| (AML_NAND_CE0 << 4) | (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 1,
                .options = (NAND_TIMING_MODE5| NAND_ECC_BCH30_1K_MODE),
            },
        },
        .rbpin_mode = 1,
        .short_pgsz = 0,
        .ran_mode = 0,
        .T_REA = 20,
        .T_RHOH = 15,
    }

};

struct aml_nand_device aml_nand_mid_device = {
    .aml_nand_platform = aml_nand_mid_platform,
    .dev_num = 2,
};
#endif

#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
//@board schematic: m3_skt_v1.pdf
//@pinmax: AppNote-M3-CorePinMux.xlsx
//GPIOA_26 used to set VCCX2_EN: 0 to enable power and 1 to disable power
static void gpio_set_vbus_power(char is_power_on)
{
	if(is_power_on)
	{
		//@WA-AML8726-M3_REF_V1.0.pdf
	    //GPIOA_26 -- VCCX2_EN
		set_gpio_mode(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), 0);

		//@WA-AML8726-M3_REF_V1.0.pdf
		//GPIOD_9 -- USB_PWR_CTL
		set_gpio_mode(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), 1);

		udelay(100000);
	}
	else
	{
		set_gpio_mode(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), 0);

		set_gpio_mode(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), 1);
	}
}
static int usb_charging_detect_call_back(char bc_mode)
{
	switch(bc_mode){
		case BC_MODE_DCP:
		case BC_MODE_CDP:
			//Pull up chargging current > 500mA
			break;

		case BC_MODE_UNKNOWN:
		case BC_MODE_SDP:
		default:
			//Limit chargging current <= 500mA
			//Or detet dec-charger
			break;
	}
	return 0;
}
//note: try with some M3 pll but only following can work
//USB_PHY_CLOCK_SEL_M3_XTAL @ 1 (24MHz)
//USB_PHY_CLOCK_SEL_M3_XTAL_DIV2 @ 0 (12MHz)
//USB_PHY_CLOCK_SEL_M3_DDR_PLL @ 27(336MHz); @Rev2663 M3 SKT board DDR is 336MHz
//                                                            43 (528MHz); M3 SKT board DDR not stable for 528MHz
struct amlogic_usb_config g_usb_config_m6_skt_a={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_A,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_b={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_B,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_c={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_C,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_d={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_D,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_h={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_A,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/
#ifdef CONFIG_IR_REMOTE
void board_ir_init()
{
	writel(0x00005801,P_AO_RTI_PIN_MUX_REG);
	writel(0x30fa0013,P_AO_IR_DEC_REG0);
	writel(0x001ebe40,P_AO_IR_DEC_REG1);
	writel(0x01d801ac,P_AO_IR_DEC_LDR_ACTIVE);
	writel(0x00f800ca,P_AO_IR_DEC_LDR_IDLE);
	writel(0x0044002c,P_AO_IR_DEC_BIT_0);
	printf("IR init done!\n");

}
#endif
int board_init(void)
{
	gd->bd->bi_arch_number=MACH_TYPE_MESON6_SKT;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;
#if CONFIG_JERRY_NAND_TEST //temp test
    nand_init();

#endif

#ifdef CONFIG_AML_I2C
	board_i2c_init();
#endif /*CONFIG_AML_I2C*/
#ifdef CONFIG_IR_REMOTE
	board_ir_init();
#endif

#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt_a,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_b,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_c,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_d,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_h,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/


#ifdef CONFIG_M6_TEST_CPU_SWITCH
	extern int get_cup_id(void);
	printf("\n*************************************\n");
	printf("CPU switch : CPU #%d is running\n",get_cpu_id());
	printf("*************************************\n\n");
#endif //CONFIG_M6_TEST_CPU_SWITCH
	return 0;
}
#ifdef CONFIG_AML_TINY_USBTOOL
int usb_get_update_result(void)
{
    unsigned long upgrade_step;
    upgrade_step = simple_strtoul (getenv ("upgrade_step"), NULL, 16);
    printf("upgrade_step = %d\n", upgrade_step);
    if(upgrade_step == 1) {
        run_command("defenv", 1);
        run_command("setenv upgrade_step 2", 1);
        run_command("saveenv", 1);
        return 0;
    } else {
        return -1;
    }
}
#endif

inline int check_all_regulators(void)
{
    printf("Check all regulator\n");
    //return check_axp_regulator_for_m6_board();
}
