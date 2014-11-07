#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <malloc.h>

#if defined(CONFIG_CMD_NET)
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/io.h>
#endif /*(CONFIG_CMD_NET)*/

#if defined(CONFIG_AML_I2C)
#include <aml_i2c.h>
#include <asm/arch/io.h>
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#endif

#if CONFIG_CMD_MMC
#include <mmc.h>
#include <asm/arch/sdio.h>
#include <asm/arch/romboot.h>
#endif

#if defined(CONFIG_FASTBOOT)
#include <fastboot.h>
#endif
#if defined(CONFIG_USB_GADGET_MASS_STORAGE)
#include <usb_mass_storage.h>
#endif

DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
#include <amlogic/battery_parameter.h>
/*
 * add board battery parameters, this is a backup option if uboot process
 * battery parameters failed, each board shoud use your own battery parameters
 */
int config_battery_rdc = 135;
struct battery_curve config_battery_curve[] = {
	/* ocv, charge, discharge */
	{3132,     0,      0},
	{3273,     0,      0},
	{3414,     0,      0},
	{3555,     0,      0},
	{3625,     1,      2},
	{3660,     2,      3},
	{3696,     3,     12},
	{3731,    10,     18},
	{3766,    15,     31},
	{3801,    22,     45},
	{3836,    40,     55},
	{3872,    55,     62},
	{3942,    68,     73},
	{4012,    79,     83},
	{4083,    88,     90},
	{4153,   100,    100},
};
#endif

#if defined(CONFIG_CMD_NET)
/*************************************************
 * Amlogic Ethernet controller operation
 *
 * Note: RTL8211F gbit_phy use RGMII interface
 *
 *************************************************/
static void setup_net_chip(void)
{
	eth_aml_reg0_t eth_reg0;
	/*m8b mac clock use externel phy clock(125m/25m/2.5m)
	  setup ethernet clk need calibrate to configre
	  setup ethernet pinmux use DIF_TTL_0N/P 1N/P 2N/P 3N/P 4N/P GPIOH(3-9) */
#ifdef RMII_PHY_INTERFACE
	/* setup ethernet pinmux use gpioz(5-14) */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6,0xff7f);
	eth_reg0.d32 = 0;
	eth_reg0.b.phy_intf_sel = 0;
	eth_reg0.b.data_endian = 0;
	eth_reg0.b.desc_endian = 0;
	eth_reg0.b.rx_clk_rmii_invert = 0;
	eth_reg0.b.rgmii_tx_clk_src = 0;
	eth_reg0.b.rgmii_tx_clk_phase = 0;
	eth_reg0.b.rgmii_tx_clk_ratio = 1;
	eth_reg0.b.phy_ref_clk_enable = 1;
	eth_reg0.b.clk_rmii_i_invert = 1;
	eth_reg0.b.clk_en = 1;
	eth_reg0.b.adj_enable = 1;
	eth_reg0.b.adj_setup = 0;
	eth_reg0.b.adj_delay = 18;
	eth_reg0.b.adj_skew = 0;
	eth_reg0.b.cali_start = 0;
	eth_reg0.b.cali_rise = 0;
	eth_reg0.b.cali_sel = 0;
	eth_reg0.b.rgmii_rx_reuse = 0;
	eth_reg0.b.eth_urgent = 0;
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, eth_reg0.d32 );//1          //rmii mode
#elif RGMII_PHY_INTERFACE
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x3f4f);
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_7, 0xf00000);
	eth_reg0.d32 = 0;
	eth_reg0.b.phy_intf_sel = 1;
	eth_reg0.b.data_endian = 0;
	eth_reg0.b.desc_endian = 0;
	eth_reg0.b.rx_clk_rmii_invert = 0;
	eth_reg0.b.rgmii_tx_clk_src = 0;
	eth_reg0.b.rgmii_tx_clk_phase = 0;
	eth_reg0.b.rgmii_tx_clk_ratio = 2;
	eth_reg0.b.phy_ref_clk_enable = 1;
	eth_reg0.b.clk_rmii_i_invert = 1;
	eth_reg0.b.clk_en = 1;
	eth_reg0.b.adj_enable = 1;
	eth_reg0.b.adj_setup = 1;
	eth_reg0.b.adj_delay = 4;
	eth_reg0.b.adj_skew = 0xc;
	eth_reg0.b.cali_start = 0;
	eth_reg0.b.cali_rise = 0;
	eth_reg0.b.cali_sel = 0;
	eth_reg0.b.rgmii_rx_reuse = 0;
	eth_reg0.b.eth_urgent = 0;
	WRITE_CBUS_REG(0x2050, eth_reg0.d32);// rgmii mode
	SET_CBUS_REG_MASK(0x10a5,1 << 27);
	WRITE_CBUS_REG(0x2050, 0x7d21);// rgmii mode
	SET_CBUS_REG_MASK(0x108a, 0xb803);
	SET_CBUS_REG_MASK(HHI_MPLL_CNTL9, (1638 << 0)
			| (0 << 14) | (1 << 15) | (1 << 14)
			| (5 << 16)
			| (0 << 25) | (0 << 26) | (0 << 30) | (0 << 31));
#endif
	/* setup ethernet mode */
	CLEAR_CBUS_REG_MASK(HHI_MEM_PD_REG0, (1 << 3) | (1 << 2));
	/* hardware reset ethernet phy : gpioh_4 connect phyreset pin*/
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO3_EN_N, 1 << 23);
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO3_O, 1 << 23);
	udelay(2000);
	SET_CBUS_REG_MASK(PREG_PAD_GPIO3_O, 1 << 23);
}

int board_eth_init(bd_t *bis)
{
	setup_net_chip();
	udelay(1000);
	extern int aml_eth_init(bd_t *bis);
	aml_eth_init(bis);
	return 0;
}
#endif /* (CONFIG_CMD_NET) */

u32 get_board_rev(void)
{

	return 0x20;
}

#if CONFIG_CMD_MMC
static int  sdio_init(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                setbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 29);
                break;
        case SDIO_PORT_C:
                clrbits_le32(P_PAD_PULL_UP_REG3, 0xff << 0);
                break;
        }

        return cpu_sdio_init(port);
}

extern unsigned sdio_debug_1bit_flag;

static int  sdio_detect(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
#if 0   // FIXME: Card detect?
                int ret;
                setbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 29);
                ret = readl(P_PREG_PAD_GPIO5_I) & (1 << 29) ? 0 : 1;
#endif
                // If UART pinmux is set, debug board inserted
                if ((readl(P_PERIPHS_PIN_MUX_8) & (3<<9))) {
                        if (!(readl(P_PREG_PAD_GPIO0_I) & (1 << 22))) {
                                printf("sdio debug board detected, sd card with 1bit mode\n");
                                sdio_debug_1bit_flag = 1;
                        }
                        else {
                                printf("sdio debug board detected, no sd card in\n");
                                sdio_debug_1bit_flag = 0;
                                return 1;
                        }
                }

                break;
        case SDIO_PORT_C:
                break;
        }

        return 0;
}

static void sdio_pwr_prepare(unsigned port)
{
        cpu_sdio_pwr_prepare(port);
}

static void sdio_pwr_on(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                clrbits_le32(P_PREG_PAD_GPIO5_O, 1 << 31);      // CARD_8
                clrbits_le32(P_PREG_PAD_GPIO5_EN_N, 1 << 31);
                break;
        case SDIO_PORT_C:
                break;
        }
}
static void sdio_pwr_off(unsigned port)
{
        switch (port) {
        case SDIO_PORT_B:
                setbits_le32(P_PREG_PAD_GPIO5_O, (1 << 31));    // CARD_8
                clrbits_le32(P_PREG_PAD_GPIO5_EN_N, (1 << 31));
                break;
        case SDIO_PORT_C:
                break;
        }
}

#define NR_STORAGE      2

struct mmc mmc[NR_STORAGE];

struct aml_card_sd_info sdio_dev[NR_STORAGE] = {
        {
                .sdio_port = SDIO_PORT_B,
                .name = "SDCARD",
                .sdio_init = sdio_init,
                .sdio_detect = sdio_detect,
                .sdio_pwr_on = sdio_pwr_on,
                .sdio_pwr_off = sdio_pwr_off,
                .sdio_pwr_prepare = sdio_pwr_prepare,
        }, {
                .sdio_port = SDIO_PORT_C,
                .name = "eMMC",
                .sdio_init = sdio_init,
                .sdio_detect = sdio_detect,
                .sdio_pwr_on = sdio_pwr_on,
                .sdio_pwr_off = sdio_pwr_off,
                .sdio_pwr_prepare = sdio_pwr_prepare,
        },
};

int board_mmc_init(bd_t *bis)
{
        /* FIXME: 0xd901ff00 is from bootrom code itself. It must be corrected
         * with specific address of SoC.
         */
        T_ROM_BOOT_RETURN_INFO *bootinfo = (T_ROM_BOOT_RETURN_INFO*)0xd901ff00;

        if (0 == bootinfo->boot_id) { // Boot from eMMC
                mmc[0].block_dev.if_type = IF_TYPE_MMC;
                mmc[1].block_dev.if_type = IF_TYPE_SD;

                sdio_register(&mmc[0], &sdio_dev[1]);
                sdio_register(&mmc[1], &sdio_dev[0]);
        } else { // Boot from SDCARD
                mmc[0].block_dev.if_type = IF_TYPE_SD;
                mmc[1].block_dev.if_type = IF_TYPE_MMC;

                sdio_register(&mmc[0], &sdio_dev[0]);
                sdio_register(&mmc[1], &sdio_dev[1]);
        }
}
#endif

#if CONFIG_AML_HDMI_TX
/*
 * Init hdmi related power configuration
 * Refer to your board SCH, power including HDMI5V, HDMI1.8V, AVDD18_HPLL, etc
 */
extern void hdmi_tx_power_init(void);
void hdmi_tx_power_init(void)
{
	//
	printf("hdmi tx power init\n");
}
#endif

#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
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
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_b={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_B,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_h={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/
#ifdef CONFIG_IR_REMOTE
//#define DEBUG_IR

#define msleep(a) udelay(a * 1000)

#define IR_POWER_KEY    0xe51afb04
#define IR_MENU_KEY		0xac53fb04
#define IR_POWER_KEY_MASK 0xffffffff

typedef struct reg_remote
{
	int reg;
	unsigned int val;
}reg_remote;

typedef enum
{
	DECODEMODE_NEC = 0,
	DECODEMODE_DUOKAN = 1,
	DECODEMODE_RCMM ,
	DECODEMODE_SONYSIRC,
	DECODEMODE_SKIPLEADER ,
	DECODEMODE_MITSUBISHI,
	DECODEMODE_THOMSON,
	DECODEMODE_TOSHIBA,
	DECODEMODE_RC5,
	DECODEMODE_RC6,
	DECODEMODE_COMCAST,
	DECODEMODE_SANYO,
	DECODEMODE_MAX
}ddmode_t;
#define CONFIG_END 0xffffffff
/*
   bit0 = 1120/31.25 = 36
   bit1 = 2240 /31.25 = 72
   2500 /31.25  = 80
   ldr_idle = 4500  /31.25 =144
   ldr active = 9000 /31.25 = 288
 */
static const reg_remote RDECODEMODE_NEC[] ={
	{P_AO_MF_IR_DEC_LDR_ACTIVE,477<<16 |400<<0},
	{P_AO_MF_IR_DEC_LDR_IDLE, 248<<16 | 202<<0},
	{P_AO_MF_IR_DEC_LDR_REPEAT,130<<16 |110<<0},
	{P_AO_MF_IR_DEC_BIT_0,60<<16|48<<0 },
	{P_AO_MF_IR_DEC_REG0,3<<28|(0xFA0<<12)|0x13},
	{P_AO_MF_IR_DEC_STATUS,(111<<20)|(100<<10)},
	{P_AO_MF_IR_DEC_REG1,0x9f40},
	{P_AO_MF_IR_DEC_REG2,0x0},
	{P_AO_MF_IR_DEC_DURATN2,0},
	{P_AO_MF_IR_DEC_DURATN3,0},
	{CONFIG_END,            0 }
};
static const reg_remote RDECODEMODE_DUOKAN[] =
{
	{P_AO_MF_IR_DEC_LDR_ACTIVE,477<<16 | 400<<0}, // NEC leader 9500us,max 477: (477* timebase = 31.25) = 9540 ;min 400 = 8000us
	{P_AO_MF_IR_DEC_LDR_IDLE, 248<<16 | 202<<0}, // leader idle
	{P_AO_MF_IR_DEC_LDR_REPEAT,130<<16|110<<0},  // leader repeat
	{P_AO_MF_IR_DEC_BIT_0,60<<16|48<<0 }, // logic '0' or '00'
	{P_AO_MF_IR_DEC_REG0,3<<28|(0xFA0<<12)|0x13},  // sys clock boby time.base time = 20 body frame 108ms
	{P_AO_MF_IR_DEC_STATUS,(111<<20)|(100<<10)},  // logic '1' or '01'
	{P_AO_MF_IR_DEC_REG1,0x9f40}, // boby long decode (8-13)
	{P_AO_MF_IR_DEC_REG2,0x0},  // hard decode mode
	{P_AO_MF_IR_DEC_DURATN2,0},
	{P_AO_MF_IR_DEC_DURATN3,0},
	{CONFIG_END,            0      }
};

static const reg_remote *remoteregsTab[] =
{
	RDECODEMODE_NEC,
	RDECODEMODE_DUOKAN,
};

void setremotereg(const reg_remote *r)
{
	writel(r->val, r->reg);
#ifdef DEBUG_IR
	printf(">>>write[0x%x] = 0x%x\n",r->reg, r->val);
	msleep(50);
	printf("    read<<<<<< = 0x%x\n",readl(r->reg));
#endif
}

int	set_remote_mode(int mode)
{
	const reg_remote *reg;

	reg = remoteregsTab[mode];
	while (CONFIG_END != reg->reg) {
		setremotereg(reg++);
	}

	return 0;
}

void	board_ir_init(void)
{
	unsigned int status,data_value;
	int val = readl(P_AO_RTI_PIN_MUX_REG);

	writel((val | (1 << 0)), P_AO_RTI_PIN_MUX_REG);
	set_remote_mode(DECODEMODE_NEC);
	status = readl(P_AO_MF_IR_DEC_STATUS);
	data_value = readl(P_AO_MF_IR_DEC_FRAME);

	printf("IR init is done!\n");
}

int	checkRecoveryKey(void)
{
	unsigned int keycode;

	if ((P_AO_MF_IR_DEC_STATUS >> 3) & 0x1) {
		keycode = readl(P_AO_MF_IR_DEC_FRAME);
	}

	return (keycode == IR_MENU_KEY);
}

int	do_irdetect(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int i;
#ifdef DEBUG_IR
	int j;
#endif
	// board_ir_init();
#ifdef DEBUG_IR
	for (j = 0; j < 20; j++) {
#endif
		for (i = 0; i < 1000000; i++)
			if (checkRecoveryKey()) {
#ifdef DEBUG_IR
				printf("Detect Recovery Key ...\n");
#endif
				return 0;
			}
#ifdef DEBUG_IR
		msleep(50);
		printf("No key !!!\n");
	}
#endif
	return 1;
}

U_BOOT_CMD(irdetect, 1, 1, do_irdetect,
		"Detect IR Key to start recovery system","[<string>]\n"
);

#endif
#ifdef CONFIG_AML_I2C
/*I2C module is board depend*/
static void board_i2c_set_pinmux(void){
	/*@AML9726-MX-MAINBOARD_V1.0.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	/*********************************************/
	/*                | I2C_Master_AO        |I2C_Slave            |       */
	/*********************************************/
	/*                | I2C_SCK                | I2C_SCK_SLAVE  |      */
	/* GPIOAO_4  | [AO_PIN_MUX: 6]     | [AO_PIN_MUX: 2]   |     */
	/*********************************************/
	/*                | I2C_SDA                 | I2C_SDA_SLAVE  |     */
	/* GPIOAO_5  | [AO_PIN_MUX: 5]     | [AO_PIN_MUX: 1]   |     */
	/*********************************************/

	//disable all other pins which share with I2C_SDA_AO & I2C_SCK_AO
	clrbits_le32(P_AO_RTI_PIN_MUX_REG, ((1<<2)|(1<<24)|(1<<1)|(1<<23)));
	//enable I2C MASTER AO pins
	setbits_le32(P_AO_RTI_PIN_MUX_REG,
			(MESON_I2C_MASTER_AO_GPIOAO_4_BIT | MESON_I2C_MASTER_AO_GPIOAO_5_BIT));

	udelay(10000);

};

struct aml_i2c_platform g_aml_i2c_plat = {
	.wait_count         = 1000000,
	.wait_ack_interval  = 5,
	.wait_read_interval = 5,
	.wait_xfer_interval = 5,
	.master_no          = AML_I2C_MASTER_AO,
	.use_pio            = 0,
	.master_i2c_speed   = AML_I2C_SPPED_400K,
	.master_ao_pinmux = {
		.scl_reg    = MESON_I2C_MASTER_AO_GPIOAO_4_REG,
		.scl_bit    = MESON_I2C_MASTER_AO_GPIOAO_4_BIT,
		.sda_reg    = MESON_I2C_MASTER_AO_GPIOAO_5_REG,
		.sda_bit    = MESON_I2C_MASTER_AO_GPIOAO_5_BIT,
	}
};
#endif

#ifdef CONFIG_PLATFORM_HAS_PMU
static void board_pmu_init(void)
{
	struct aml_pmu_driver *driver = aml_pmu_get_driver();
	if (driver && driver->pmu_reg_write) {
		printf("%s, increase DCIN_OV_ADJ\n", __func__);
		driver->pmu_reg_write(0x0030, 0x18);
	}
	if (driver && driver->pmu_init) {
		driver->pmu_init();
	}
}
#endif

inline void key_init(void)
{
	setbits_le32(P_AO_GPIO_O_EN_N, (1 << 3));                           // GPIOAO_3 as power key input
	clrbits_le32(P_AO_RTI_PIN_MUX_REG, ((1 << 7)|(1 << 9)|(1 << 22)));  // clear pinmux as gpio function
	clrbits_le32(P_AO_RTI_PULL_UP_REG, (1 << 19));                      // disable pull up/down of gpio3, set to high-z
	setbits_le32(P_AO_RTI_PULL_UP_REG, 0x00070007);                     // pull up for gpio[0 - 2]
}

inline int get_key(void)
{
	return (readl(P_AO_GPIO_I) & (1 << 3)) ? 0 : 1;
}



static void board_i2c_init(void)
{
	//set I2C pinmux with PCB board layout
	/*@AML9726-MX-MAINBOARD_V1.0.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation
	/*M6 board*/
	//udelay(10000);

	udelay(10000);
#ifdef TEST_UBOOT_BOOT_SPEND_TIME
	unsigned int before_pmu_init =  get_utimer(0);
#endif

#ifdef CONFIG_PLATFORM_HAS_PMU
	board_pmu_init();
#endif
#ifdef TEST_UBOOT_BOOT_SPEND_TIME
	unsigned int after_pmu_init =  get_utimer(0);
	printf("\nPMU init time %d\n", after_pmu_init-before_pmu_init);
#endif
}

int serial_set_pin_port(unsigned port_base)
{
	// GPIOAO_0 : tx, GPIOAO_1 : rx
	setbits_le32(P_AO_RTI_PIN_MUX_REG, 3 << 11);
	return 0;
}

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
	board_usb_init(&g_usb_config_m6_skt_b,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_h,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/

	key_init();
	return 0;
}

#ifdef CONFIG_NAND_AML_M3 //temp test
//#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>


static struct aml_nand_platform aml_nand_mid_platform[] = {
#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE
	{
		.name = NAND_BOOT_NAME,
		.chip_enable_pad = AML_NAND_CE0,
		.ready_busy_pad = AML_NAND_CE0,
		.platform_nand_data = {
			.chip =  {
				.nr_chips = 1,
				.options = (NAND_TIMING_MODE5 | NAND_ECC_BCH60_1K_MODE),
			},
		},
		.rbpin_mode=1,
		.short_pgsz=384,
		.ran_mode=0,
		.T_REA = 20,
		.T_RHOH = 15,
	},
#endif
	{
		.name = NAND_NORMAL_NAME,
		.chip_enable_pad = (AML_NAND_CE0) | (AML_NAND_CE1 << 4),// | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
		.ready_busy_pad = (AML_NAND_CE0) | (AML_NAND_CE1 << 4),// | (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
		.platform_nand_data = {
			.chip =  {
				.nr_chips = 2,
				.options = (NAND_TIMING_MODE5 | NAND_ECC_BCH60_1K_MODE | NAND_TWO_PLANE_MODE),
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
	.dev_num = ARRAY_SIZE(aml_nand_mid_platform),
};
#endif

static int do_msr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	const char *cmd;

	/* need at least two arguments */
	if (argc > 2)
		goto usage;

	int nIndex = 0;
	int nCounter = 64;

	if( 2 == argc)
	{
		cmd = argv[1];
		char *endp;
		nIndex = simple_strtoul(argv[1], &endp, 10);
		if(nIndex < 0 || nIndex > 63)
			goto usage;
		nCounter = 1;
	}

	extern unsigned long    clk_util_clk_msr(unsigned long clk_mux);

	//printf("\n");
	for(;((nIndex < 64) && nCounter);nCounter--,nIndex++)
		printf("MSR clock[%d] = %dMHz\n",nIndex,clk_util_clk_msr(nIndex));

	return 0;

usage:
	return cmd_usage(cmdtp);
}

U_BOOT_CMD(
		msr,	2, 	1,	do_msr,
		"Meson msr sub-system",
		" [0...63] - measure clock frequency\n"
		"          - no clock index will measure all clock"
	  );

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
/*following key value are test with board
  [M6_SKT_V_1.0 20120112]
  ref doc:
  1. M6_SKT_V1.pdf
 */
/* adc_init(&g_adc_info, ARRAY_SIZE(g_adc_info)); */
/*following is test code to test ADC & key pad*/
static int do_adc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]) {
	if(argc > 2)
		goto usage;

	u32 nDelay = 0xffff;
	int nKeyVal = 0;
	int nCnt = 0;
	char *endp;
	int nMaxCnt;
	int adc_chan = 0; //m8 adc channel 0;m6 adc channel 4
	if(2 == argc)
		nMaxCnt	= simple_strtoul(argv[1], &endp, 10);
	else
		nMaxCnt = 10;

	saradc_enable();
	while(nCnt < nMaxCnt)
	{
		udelay(nDelay);
		nKeyVal = get_adc_sample(adc_chan);
		if(nKeyVal > 1021)
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

#ifdef CONFIG_AUTO_SET_MULTI_DT_ID
#if 0
#define debug_print printf
#else
#define debug_print
#endif
void board_dt_id_process(void)
{
	unsigned int mem_size = 0;
	int i;

	for(i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		mem_size += gd->bd->bi_dram[i].size;
	}

	mem_size = mem_size >> 20;	// MB

	unsigned char dt_name[64] = {0};

	strcat(dt_name, "m8b_m200_");  //please change this name when you add a new config
	debug_print("aml_dt: %s\n", getenv("aml_dt"));

	switch(mem_size){
	case 2048: //2GB
		strcat(dt_name, "2g");
		break;
	case 1024: //1GB
		strcat(dt_name, "1g");
		break;
	case 512: //512MB
		strcat(dt_name, "512m");
		break;
	case 256:
		strcat(dt_name, "256m");
		break;
	default:
		strcat(dt_name, "v1");
		break;
	}
	setenv("aml_dt", dt_name);
	debug_print("aml_dt: %s\n", getenv("aml_dt"));
}
#endif

#if defined(CONFIG_USB_GADGET_S3C_UDC_OTG)
#include <usb/s3c_udc.h>

#define OTG_PHY_CONFIG          0x0000
#define OTG_PHY_CTRL            0x0004
#define OTG_PHY_CTRL_POR        (1 << 15)
#define OTG_PHY_CTRL_FSEL(x)    ((x) << 22)
#define OTG_PHY_CTRL_CLKDET     (1 << 8)
#define OTG_PHY_ENDP_INTR       0x0008
#define OTG_PHY_ADP_BC          0x000c
#define OTG_PHY_DBG_UART        0x0010
#define OTG_PHY_TEST            0x0014
#define OTG_PHY_TUNE            0x0018

#define PREI_USB_PHY_REG_BASE   P_USB_ADDR0
#define DWC_REG_BASE            0xc9040000
#define DWC_REG_GSNPSID         0x040   /* Synopsys ID Register (Read Only). */

static int dwc_otg_start_clk(int on)
{
        if (on) {
                u32 temp;
                u32 snpsid;

                writel((1 << 2), P_RESET1_REGISTER);
                udelay(500);

                /* Power On Reset */
                temp = readl(PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);
                temp |= OTG_PHY_CTRL_FSEL(5) | OTG_PHY_CTRL_POR;
                writel(temp, PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);

                udelay(500);    // 500us

                temp &= ~OTG_PHY_CTRL_POR;
                writel(temp, PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);

                udelay(50000);  // 50ms

                /* USB OTG PHY does work? */
                temp = readl(PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);
                if (0 == (temp & OTG_PHY_CTRL_CLKDET)) {
                        printf("ERROR, usb phy clock is not detected!\n");
                }

                /* Check USB OTG ID, if it can work */
                snpsid = readl(DWC_REG_BASE + DWC_REG_GSNPSID);
                if (0x4f543000 != (snpsid & 0xfffff000)) {
                        printf("%s, Bad value for SNPSID: 0x%08x\n",
                                        __func__, snpsid);
                        return -1;
                }
        }

        return 0;
}

struct s3c_plat_otg_data s3c_otg_data = {
        .phy_control    = dwc_otg_start_clk,
        .regs_otg       = DWC_REG_BASE,
};
#endif

#if defined(BOARD_LATE_INIT)
int board_late_init(void)
{
        block_dev_desc_t *dev_desc;

        dev_desc = get_dev_by_name("mmc0");
        if (dev_desc) {
                printf("============================================================\n");
                dev_print(dev_desc);
                printf("------------------------------------------------------------\n");
                print_part_dos(dev_desc);
                printf("============================================================\n");
        }
}
#endif

#if defined(CONFIG_FASTBOOT)
/*
 * Partition table and management
 */
struct fbt_partition {
        const char *name;
        const char *type;
        unsigned size_kb;
};

struct fbt_partition sys_partitions[] = {
        {
                .name = "bootloader",
                .type = "raw",
                .size_kb = 512
        }, {
                .name = CONFIG_ENV_BLK_PARTITION,       /* "environment" */
                .type = "raw",
                .size_kb = CONFIG_ENV_SIZE / 1024
        }, {
                .name = CONFIG_INFO_PARTITION,          /* "device_info" */
                .type= "raw",
                .size_kb = 32
        }, {
                .name = "logo",
                .type = "raw",
                .size_kb = 32 * 1024
        }, {
                .name = "misc",
                .type = "raw",
                .size_kb = 2 * 1024
        }, {
                .name = "recovery",
                .type = "boot",
                .size_kb = 8 * 1024
        }, {
                .name = "boot",
                .type = "boot",
                .size_kb = 10 * 1024
        }, {
                .name = "efs",
                .type = "ext4",
                .size_kb = 6 * 1024
        }, {
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};

struct fbt_partition fbt_partitions[] = {
        {
                .name = "system",               /* 2nd primary partition */
                .type = "ext4",
                .size_kb = 1024 * 1024
        }, {
                .name = "userdata",             /* 2rd primary partition */
                .type = "ext4",
                .size_kb = 3 * 1024 * 1024,
        }, {
                .name = "cache",                /* 3rd parimary partition */
                .type = "ext4",
                .size_kb = 256 * 1024
        }, {
                .name = "fat",                  /* 1st primary partition */
                .type = "vfat",
                /* FIXME: MUST fit in remaind blocks after followed by this */
                .size_kb = 1024 * 1024,
        }, {
                .name = 0,
                .type = 0,
                .size_kb = 0
        },
};

static unsigned userptn_start_lba = 0;
static unsigned userptn_end_lba = 0;

void board_user_partition(unsigned *start, unsigned *end)
{
        *start = userptn_start_lba;
        *end = userptn_end_lba;
}

void board_print_partition(block_dev_desc_t *blkdev, disk_partition_t *ptn)
{
        u64 length = (u64)blkdev->blksz * ptn->size;

        if (length > (1024 * 1024))
                printf(" %8lu  %12llu(%7lluM)  %s\n",
                                ptn->start,
                                length, length / (1024*1024),
                                ptn->name);
        else
                printf(" %8lu  %12llu(%7lluK)  %s\n",
                                ptn->start,
                                length, length / 1024,
                                ptn->name);
}

int board_find_partition(const char *name, unsigned *start, unsigned *bytes)
{
        int n;
        unsigned next = 0;

        for (n = 0; sizeof(sys_partitions) / sizeof(sys_partitions[0]); n++) {
                struct fbt_partition *fbt = &sys_partitions[n];

                if (!fbt->name || !fbt->size_kb || !fbt->type)
                        break;

                if (!strcmp(name, fbt->name)) {
                        *start = next;
                        *bytes = fbt->size_kb * 1024;
                        return 0;
                }

                next += fbt->size_kb * 2;
        }

        return -EEXIST;
}

int board_fbt_load_ptbl()
{
        char *android_name[] = {
                "fat",
                "system",
                "userdata",
                "cache",
        };

        disk_partition_t ptn;
        int n;
        int res = -1;
        block_dev_desc_t *blkdev;
        unsigned next;

        blkdev = get_dev_by_name(FASTBOOT_BLKDEV);
        if (!blkdev) {
                printf("error getting device %s\n", FASTBOOT_BLKDEV);
                return -1;
        }

        if (!blkdev->lba) {
                printf("device %s has no space\n", FASTBOOT_BLKDEV);
                return -1;
        }

        init_part(blkdev);
        if (blkdev->part_type == PART_TYPE_UNKNOWN) {
                printf("unknown partition table on %s\n", FASTBOOT_BLKDEV);
                return -1;
        }

        printf("lba size = %lu\n", blkdev->blksz);
        printf("lba_start      partition_size          name\n");
        printf("=========  ======================  ==============\n");

        next = 0;
        for (n = 0; sizeof(sys_partitions) / sizeof(sys_partitions[0]); n++) {
                struct fbt_partition *fbt = &sys_partitions[n];

                if (!fbt->name || !fbt->size_kb || !fbt->type)
                        break;

                ptn.start = next;
                ptn.size = fbt->size_kb * 2;
                ptn.blksz = blkdev->blksz;
                strncpy(ptn.name, fbt->name, sizeof(ptn.name));
                strncpy(ptn.type, fbt->type, sizeof(ptn.type));

                fbt_add_ptn(&ptn);
                board_print_partition(blkdev, &ptn);

                next += ptn.size;
        }

        userptn_start_lba = next;
        userptn_end_lba = blkdev->lba - 1;

        for (n = CONFIG_MIN_PARTITION_NUM; n <= CONFIG_MAX_PARTITION_NUM; n++) {
                if (get_partition_info(blkdev, n, &ptn))
                        continue;       /* No partition <n> */
                if (!ptn.size || !ptn.blksz || !ptn.name[0])
                        continue;       /* Partition <n> is empty (or sick) */

                /* Rename the partition names on MBR to Android partition names */
                if ((n > 0) && (n <= (sizeof(android_name)
                                                / sizeof(android_name[0])))) {
                        strcpy(ptn.name, android_name[n - 1]);
                }

                fbt_add_ptn(&ptn);

                board_print_partition(blkdev, &ptn);

                if ((ptn.start < userptn_start_lba)
                                || (ptn.start + ptn.size  > userptn_end_lba)) {
                        printf("  ** Partition is not allocated properly!!! **\n");
                }

                res = 0;
        }

        printf("=========  ======================  ==============\n");

        return res;
}

int board_fbt_handle_flash(disk_partition_t *ptn,
                struct cmd_fastboot_interface *priv)
{
        if (!strcmp("bootloader", ptn->name)) {
                lbaint_t blkcnt = 1;
                char sector[512];
                int err = partition_read_blks(priv->dev_desc, ptn,
                                &blkcnt, sector);
                if (err) {
                        printf("failed to read MBR, error=%d\n", err);
                        return err;
                }

                memcpy(priv->transfer_buffer + 442,
                                &sector[442], sizeof(sector) - 442);
        }

        return 0;
}
#endif

#ifdef CONFIG_USB_GADGET_MASS_STORAGE
static int ums_read_sector(struct ums_device *ums_dev,
                ulong start, lbaint_t blkcnt, void *buf)
{
        if (ums_dev->mmc->block_dev.block_read(ums_dev->dev_num,
                                start + ums_dev->offset, blkcnt, buf) != blkcnt)
                return -1;

        return 0;
}

static int ums_write_sector(struct ums_device *ums_dev,
                ulong start, lbaint_t blkcnt, const void *buf)
{
        if (ums_dev->mmc->block_dev.block_write(ums_dev->dev_num,
                                start + ums_dev->offset, blkcnt, buf) != blkcnt)
                return -1;

        return 0;
}

static void ums_get_capacity(struct ums_device *ums_dev,
                long long int *capacity)
{
        long long int tmp_capacity;

        tmp_capacity = (long long int) ((ums_dev->offset + ums_dev->part_size)
                        * SECTOR_SIZE);
        *capacity = ums_dev->mmc->capacity - tmp_capacity;
}

static struct ums_board_info ums_board = {
        .read_sector = ums_read_sector,
        .write_sector = ums_write_sector,
        .get_capacity = ums_get_capacity,
        .name = "ODROID UMS Disk",
        .ums_dev = {
                .mmc = NULL,
                .dev_num = 0,
                .offset = 0,
                .part_size = 0.
        },
};

struct ums_board_info *board_ums_init(unsigned int dev_num,
                unsigned int offset, unsigned int part_size)
{
        struct mmc *mmc;

        mmc = find_mmc_device(dev_num);
        if (!mmc)
                return NULL;

        ums_board.ums_dev.mmc = mmc;
        ums_board.ums_dev.dev_num = dev_num;
        ums_board.ums_dev.offset = offset;
        ums_board.ums_dev.part_size = part_size;

        return &ums_board;
}
#endif
