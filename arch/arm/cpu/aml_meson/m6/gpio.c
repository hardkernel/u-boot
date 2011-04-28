/*
Linux gpio.C

*/

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/gpio.h>
#include <amlogic/gpio.h>

struct gpio_addr
{
	unsigned long mode_addr;
	unsigned long out_addr;
	unsigned long in_addr;
};
static struct gpio_addr gpio_addrs[]=
{
    
    [PREG_PAD_GPIO0]={P_PREG_PAD_GPIO0_EN_N,P_PREG_PAD_GPIO0_O,P_PREG_PAD_GPIO0_I},
    [PREG_PAD_GPIO1]={P_PREG_PAD_GPIO1_EN_N,P_PREG_PAD_GPIO1_O,P_PREG_PAD_GPIO1_I},
    [PREG_PAD_GPIO2]={P_PREG_PAD_GPIO2_EN_N,P_PREG_PAD_GPIO2_O,P_PREG_PAD_GPIO2_I},
    [PREG_PAD_GPIO3]={P_PREG_PAD_GPIO3_EN_N,P_PREG_PAD_GPIO3_O,P_PREG_PAD_GPIO3_I},
    [PREG_PAD_GPIO4]={P_PREG_PAD_GPIO4_EN_N,P_PREG_PAD_GPIO4_O,P_PREG_PAD_GPIO4_I},
	[PREG_PAD_GPIO5]={P_PREG_PAD_GPIO5_EN_N,P_PREG_PAD_GPIO5_O,P_PREG_PAD_GPIO5_I},
    [PREG_PAD_GPIOAO] = {PREG_PAD_GPIO5_EN_N, PREG_PAD_GPIO5_O, PREG_PAD_GPIO5_I},
    [PREG_JTAG_GPIO]={PREG_JTAG_GPIO_ADDR,PREG_JTAG_GPIO_ADDR,PREG_JTAG_GPIO_ADDR},
};

int set_gpio_mode(gpio_bank_t bank,int bit,gpio_mode_t mode)
{
	unsigned long addr=gpio_addrs[bank].mode_addr;
	clrsetbits_le32(addr,1<<bit,mode<<bit);
	return 0;
}
gpio_mode_t get_gpio_mode(gpio_bank_t bank,int bit)
{
	unsigned long addr=gpio_addrs[bank].mode_addr;
    return (readl(addr)&(1<<bit))?(GPIO_INPUT_MODE):(GPIO_OUTPUT_MODE);
//	return (READ_CBUS_REG_BITS(addr,bit,1)>0)?(GPIO_INPUT_MODE):(GPIO_OUTPUT_MODE);
}


int set_gpio_val(gpio_bank_t bank,int bit,unsigned long val)
{
	unsigned long addr=gpio_addrs[bank].out_addr;
	val=val?1:0;
	clrsetbits_le32(addr,1<<bit,val<<bit);

	return 0;
}

unsigned long  get_gpio_val(gpio_bank_t bank,int bit)
{
	unsigned long addr=gpio_addrs[bank].in_addr;
	return (readl(addr)&(1<<bit))?1:0;
}

/**
 * enable gpio edge interrupt
 *	
 * @param [in] pin  index number of the chip, start with 0 up to 255 
 * @param [in] flag rising(0) or falling(1) edge 
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
void gpio_enable_edge_int(int pin , int flag, int group)
{
	group &= 7;
	unsigned ireg = GPIO_INTR_GPIO_SEL0 + (group>>2);
	SET_CBUS_REG_MASK(ireg, pin<<((group&3)<<3));
	SET_CBUS_REG_MASK(GPIO_INTR_EDGE_POL, ((flag<<(16+group)) | (1<<group)));	
}
/**
 * enable gpio level interrupt
 *	
 * @param [in] pin  index number of the chip, start with 0 up to 255 
 * @param [in] flag high(0) or low(1) level 
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
void gpio_enable_level_int(int pin , int flag, int group)
{
	group &= 7;
	unsigned ireg = GPIO_INTR_GPIO_SEL0 + (group>>2);
	SET_CBUS_REG_MASK(ireg, pin<<((group&3)<<3));
	SET_CBUS_REG_MASK(GPIO_INTR_EDGE_POL, ((flag<<(16+group)) | (0<<group)));	
}

/**
 * enable gpio interrupt filter
 *
 * @param [in] filter from 0~7(*222ns)
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
void gpio_enable_int_filter(int filter, int group)
{
	group &= 7;
	unsigned ireg = GPIO_INTR_FILTER_SEL0;
	SET_CBUS_REG_MASK(ireg, filter<<(group<<2));
}

int gpio_is_valid(int number)
{
	return 1;
}

int gpio_request(unsigned gpio, const char *label)
{
	return 0;
}

void gpio_free(unsigned gpio)
{
}

int gpio_direction_input(unsigned gpio)
{
	gpio_bank_t bank = (gpio_bank_t)(gpio >> 16);
	int bit = gpio & 0xFFFF;
	set_gpio_mode(bank, bit, GPIO_INPUT_MODE);
	//printf( "set gpio%d.%d input\n", bank, bit);
	return 0;
}

int gpio_direction_output(unsigned gpio, int value)
{
	gpio_bank_t bank = (gpio_bank_t)(gpio >> 16);
	int bit = gpio & 0xFFFF;
	set_gpio_val(bank, bit, value?1:0);
	set_gpio_mode(bank, bit, GPIO_OUTPUT_MODE);
	//printf( "set gpio%d.%d output\n", bank, bit);
	return 0;
}

void gpio_set_value(unsigned gpio, int value)
{
	gpio_bank_t bank = (gpio_bank_t)(gpio >> 16);
	int bit = gpio & 0xFFFF;
	set_gpio_val(bank, bit, value?1:0);
}

int gpio_get_value(unsigned gpio)
{
	gpio_bank_t bank = (gpio_bank_t)(gpio >> 16);
	int bit = gpio & 0xFFFF;
	return (get_gpio_val(bank, bit));
}

unsigned p_gpio_oen_addr[]={
	P_PREG_PAD_GPIO0_EN_N,
	P_PREG_PAD_GPIO1_EN_N,
	P_PREG_PAD_GPIO2_EN_N,
	P_PREG_PAD_GPIO3_EN_N,
	P_PREG_PAD_GPIO4_EN_N,
	P_PREG_PAD_GPIO5_EN_N,
	P_PREG_PAD_GPIO6_EN_N,
	P_AO_GPIO_O_EN_N,
};
static unsigned p_gpio_output_addr[]={
	P_PREG_PAD_GPIO0_O,
	P_PREG_PAD_GPIO1_O,
	P_PREG_PAD_GPIO2_O,
	P_PREG_PAD_GPIO3_O,
	P_PREG_PAD_GPIO4_O,
	P_PREG_PAD_GPIO5_O,
	P_PREG_PAD_GPIO6_O,
	P_AO_GPIO_O_EN_N,
};
static unsigned p_gpio_input_addr[]={
	P_PREG_PAD_GPIO0_I,
	P_PREG_PAD_GPIO1_I,
	P_PREG_PAD_GPIO2_I,
	P_PREG_PAD_GPIO3_I,
	P_PREG_PAD_GPIO4_I,
	P_PREG_PAD_GPIO5_I,
	P_PREG_PAD_GPIO6_I,
	P_AO_GPIO_I,
};
unsigned p_pull_up_addr[]={
	P_PAD_PULL_UP_REG0,
	P_PAD_PULL_UP_REG1,
	P_PAD_PULL_UP_REG2,
	P_PAD_PULL_UP_REG3,
	P_PAD_PULL_UP_REG4,
	P_PAD_PULL_UP_REG5,
	P_PAD_PULL_UP_REG6,
};
unsigned int p_pin_mux_reg_addr[]=
{
	P_PERIPHS_PIN_MUX_0,
	P_PERIPHS_PIN_MUX_1,
	P_PERIPHS_PIN_MUX_2,
	P_PERIPHS_PIN_MUX_3,
	P_PERIPHS_PIN_MUX_4,
	P_PERIPHS_PIN_MUX_5,
	P_PERIPHS_PIN_MUX_6,
	P_PERIPHS_PIN_MUX_7,
	P_PERIPHS_PIN_MUX_8,
	P_PERIPHS_PIN_MUX_9,
	P_AO_RTI_PIN_MUX_REG,
};

extern int gpio_irq;
extern int gpio_flag;
#define NONE 0xffffffff
#define gpio_print(...) 
int gpio_debug=0;

//gpio subsystem set pictrl subsystem gpio owner
enum gpio_reg_type
{
	INPUT_REG,
	OUTPUT_REG,
	OUTPUTEN_REG
};

#define PIN_MAP(pin,reg,bit) \
{ \
	.num=pin, \
	.name=#pin, \
	.out_en_reg_bit=GPIO_REG_BIT(reg,bit), \
	.out_value_reg_bit=GPIO_REG_BIT(reg,bit), \
	.input_value_reg_bit=GPIO_REG_BIT(reg,bit), \
}
#define PIN_AOMAP(pin,en_reg,en_bit,out_reg,out_bit,in_reg,in_bit) \
{ \
	.num=pin, \
	.name=#pin, \
	.out_en_reg_bit=GPIO_REG_BIT(en_reg,en_bit), \
	.out_value_reg_bit=GPIO_REG_BIT(out_reg,out_bit), \
	.input_value_reg_bit=GPIO_REG_BIT(in_reg,in_bit), \
	.gpio_owner=NULL, \
}

#define P_PIN_MUX_REG(reg,bit) ((reg<<5)|bit)
static unsigned int gpio_to_pin[][5]={
	[GPIOZ_0]={P_PIN_MUX_REG(9,17),P_PIN_MUX_REG(9,18),NONE,NONE,NONE,},
	[GPIOZ_1]={P_PIN_MUX_REG(9,16),NONE,NONE,NONE,NONE,},
	[GPIOZ_2]={P_PIN_MUX_REG(9,15),NONE,NONE,NONE,NONE,},
	[GPIOZ_3]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_4]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_5]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_6]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_7]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_8]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_9]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOZ_10]={P_PIN_MUX_REG(9,14),NONE,NONE,NONE,NONE,},
	[GPIOZ_11]={P_PIN_MUX_REG(9,13),NONE,NONE,NONE,NONE,},
	[GPIOZ_12]={P_PIN_MUX_REG(9,12),NONE,NONE,NONE,NONE,},
	[GPIOE_0]={P_PIN_MUX_REG(9,11),NONE,NONE,NONE,NONE,},
	[GPIOE_1]={P_PIN_MUX_REG(9,10),P_PIN_MUX_REG(9,9),NONE,NONE,NONE,},
	[GPIOE_2]={P_PIN_MUX_REG(9,7),NONE,NONE,NONE,NONE,},
	[GPIOE_3]={P_PIN_MUX_REG(9,6),P_PIN_MUX_REG(9,5),NONE,NONE,NONE,},
	[GPIOE_4]={P_PIN_MUX_REG(9,4),NONE,NONE,NONE,NONE,},
	[GPIOE_5]={P_PIN_MUX_REG(9,21),P_PIN_MUX_REG(9,3),NONE,NONE,NONE,},
	[GPIOE_6]={P_PIN_MUX_REG(9,2),P_PIN_MUX_REG(9,20),NONE,NONE,NONE,},
	[GPIOE_7]={P_PIN_MUX_REG(9,19),P_PIN_MUX_REG(9,1),NONE,NONE,NONE,},
	[GPIOE_8]={P_PIN_MUX_REG(9,0),NONE,NONE,NONE,NONE,},
	[GPIOE_9]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOE_10]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOE_11]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOY_0]={P_PIN_MUX_REG(6,31),P_PIN_MUX_REG(6,30),NONE,NONE,NONE,},
	[GPIOY_1]={P_PIN_MUX_REG(6,18),NONE,NONE,NONE,NONE,},
	[GPIOY_2]={P_PIN_MUX_REG(6,17),NONE,NONE,NONE,NONE,},
	[GPIOY_3]={P_PIN_MUX_REG(6,16),NONE,NONE,NONE,NONE,},
	[GPIOY_4]={P_PIN_MUX_REG(6,15),NONE,NONE,NONE,NONE,},
	[GPIOY_5]={P_PIN_MUX_REG(6,14),NONE,NONE,NONE,NONE,},
	[GPIOY_6]={P_PIN_MUX_REG(6,13),NONE,NONE,NONE,NONE,},
	[GPIOY_7]={P_PIN_MUX_REG(6,12),NONE,NONE,NONE,NONE,},
	[GPIOY_8]={P_PIN_MUX_REG(6,11),NONE,NONE,NONE,NONE,},
	[GPIOY_9]={P_PIN_MUX_REG(6,10),NONE,NONE,NONE,NONE,},
	[GPIOY_10]={P_PIN_MUX_REG(6,9),NONE,NONE,NONE,NONE,},
	[GPIOY_11]={P_PIN_MUX_REG(6,8),NONE,NONE,NONE,NONE,},
	[GPIOY_12]={P_PIN_MUX_REG(6,7),NONE,NONE,NONE,NONE,},
	[GPIOY_13]={P_PIN_MUX_REG(6,6),NONE,NONE,NONE,NONE,},
	[GPIOY_14]={P_PIN_MUX_REG(6,5),NONE,NONE,NONE,NONE,},
	[GPIOY_15]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOX_0]={P_PIN_MUX_REG(8,5),P_PIN_MUX_REG(5,14),NONE,NONE,NONE,},
	[GPIOX_1]={P_PIN_MUX_REG(5,13),P_PIN_MUX_REG(8,4),NONE,NONE,NONE,},
	[GPIOX_2]={P_PIN_MUX_REG(8,3),P_PIN_MUX_REG(5,13),NONE,NONE,NONE,},
	[GPIOX_3]={P_PIN_MUX_REG(8,2),P_PIN_MUX_REG(5,13),NONE,NONE,NONE,},
	[GPIOX_4]={P_PIN_MUX_REG(5,12),P_PIN_MUX_REG(3,30),NONE,NONE,NONE,},
	[GPIOX_5]={P_PIN_MUX_REG(3,29),P_PIN_MUX_REG(5,12),NONE,NONE,NONE,},
	[GPIOX_6]={P_PIN_MUX_REG(5,12),P_PIN_MUX_REG(3,28),NONE,NONE,NONE,},
	[GPIOX_7]={P_PIN_MUX_REG(5,12),P_PIN_MUX_REG(3,27),NONE,NONE,NONE,},
	[GPIOX_8]={P_PIN_MUX_REG(8,1),P_PIN_MUX_REG(5,11),NONE,NONE,NONE,},
	[GPIOX_9]={P_PIN_MUX_REG(5,10),P_PIN_MUX_REG(8,0),NONE,NONE,NONE,},
	[GPIOX_10]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOX_11]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOX_12]={P_PIN_MUX_REG(3,21),NONE,NONE,NONE,NONE,},
	[GPIOX_13]={P_PIN_MUX_REG(4,13),NONE,NONE,NONE,NONE,},
	[GPIOX_14]={P_PIN_MUX_REG(4,12),NONE,NONE,NONE,NONE,},
	[GPIOX_15]={P_PIN_MUX_REG(4,11),NONE,NONE,NONE,NONE,},
	[GPIOX_16]={P_PIN_MUX_REG(4,10),NONE,NONE,NONE,NONE,},
	[GPIOX_17]={P_PIN_MUX_REG(8,27),P_PIN_MUX_REG(4,21),P_PIN_MUX_REG(4,25),P_PIN_MUX_REG(4,9),NONE,},
	[GPIOX_18]={P_PIN_MUX_REG(4,24),P_PIN_MUX_REG(8,30),P_PIN_MUX_REG(4,8),P_PIN_MUX_REG(8,26),P_PIN_MUX_REG(4,20),},
	[GPIOX_19]={P_PIN_MUX_REG(8,29),P_PIN_MUX_REG(4,19),P_PIN_MUX_REG(4,7),P_PIN_MUX_REG(8,25),P_PIN_MUX_REG(4,23),},
	[GPIOX_20]={P_PIN_MUX_REG(8,24),P_PIN_MUX_REG(4,6),P_PIN_MUX_REG(4,18),P_PIN_MUX_REG(4,22),P_PIN_MUX_REG(8,28),},
	[GPIOX_21]={P_PIN_MUX_REG(4,17),P_PIN_MUX_REG(4,3),NONE,NONE,NONE,},
	[GPIOX_22]={P_PIN_MUX_REG(4,16),P_PIN_MUX_REG(4,2),NONE,NONE,NONE,},
	[GPIOX_23]={P_PIN_MUX_REG(4,5),P_PIN_MUX_REG(4,15),P_PIN_MUX_REG(4,1),NONE,NONE,},
	[GPIOX_24]={P_PIN_MUX_REG(4,14),P_PIN_MUX_REG(4,4),P_PIN_MUX_REG(4,0),NONE,NONE,},
	[GPIOX_25]={P_PIN_MUX_REG(5,25),P_PIN_MUX_REG(5,27),NONE,NONE,NONE,},
	[GPIOX_26]={P_PIN_MUX_REG(5,24),P_PIN_MUX_REG(5,26),NONE,NONE,NONE,},
	[GPIOX_27]={P_PIN_MUX_REG(5,29),P_PIN_MUX_REG(5,31),NONE,NONE,NONE,},
	[GPIOX_28]={P_PIN_MUX_REG(5,30),P_PIN_MUX_REG(5,28),NONE,NONE,NONE,},
	[GPIOX_29]={P_PIN_MUX_REG(8,22),P_PIN_MUX_REG(8,20),P_PIN_MUX_REG(8,18),NONE,NONE,},
	[GPIOX_30]={P_PIN_MUX_REG(8,17),P_PIN_MUX_REG(8,19),P_PIN_MUX_REG(8,21),NONE,NONE,},
	[GPIOX_31]={P_PIN_MUX_REG(8,16),NONE,NONE,NONE,NONE,},
	[GPIOX_32]={P_PIN_MUX_REG(8,15),NONE,NONE,NONE,NONE,},
	[GPIOX_33]={P_PIN_MUX_REG(8,14),NONE,NONE,NONE,NONE,},
	[GPIOX_34]={P_PIN_MUX_REG(8,13),NONE,NONE,NONE,NONE,},
	[GPIOX_35]={P_PIN_MUX_REG(8,12),NONE,NONE,NONE,NONE,},
	[BOOT_0]={P_PIN_MUX_REG(4,30),P_PIN_MUX_REG(3,31),P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(6,29),NONE,},
	[BOOT_1]={P_PIN_MUX_REG(3,31),P_PIN_MUX_REG(4,29),P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(6,28),NONE,},
	[BOOT_2]={P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(6,27),P_PIN_MUX_REG(4,29),NONE,NONE,},
	[BOOT_3]={P_PIN_MUX_REG(4,29),P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(6,26),NONE,NONE,},
	[BOOT_4]={P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(4,28),NONE,NONE,NONE,},
	[BOOT_5]={P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(4,28),NONE,NONE,NONE,},
	[BOOT_6]={P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(4,28),NONE,NONE,NONE,},
	[BOOT_7]={P_PIN_MUX_REG(2,26),P_PIN_MUX_REG(4,28),NONE,NONE,NONE,},
	[BOOT_8]={P_PIN_MUX_REG(2,25),NONE,NONE,NONE,NONE,},
	[BOOT_9]={P_PIN_MUX_REG(2,24),NONE,NONE,NONE,NONE,},
	[BOOT_10]={P_PIN_MUX_REG(4,27),P_PIN_MUX_REG(2,23),P_PIN_MUX_REG(2,17),P_PIN_MUX_REG(6,25),NONE,},
	[BOOT_11]={P_PIN_MUX_REG(4,26),P_PIN_MUX_REG(6,24),P_PIN_MUX_REG(2,16),P_PIN_MUX_REG(2,22),NONE,},
	[BOOT_12]={P_PIN_MUX_REG(2,21),P_PIN_MUX_REG(5,1),NONE,NONE,NONE,},
	[BOOT_13]={P_PIN_MUX_REG(2,20),P_PIN_MUX_REG(5,3),NONE,NONE,NONE,},
	[BOOT_14]={P_PIN_MUX_REG(5,2),P_PIN_MUX_REG(2,19),NONE,NONE,NONE,},
	[BOOT_15]={P_PIN_MUX_REG(2,18),NONE,NONE,NONE,NONE,},
	[BOOT_16]={P_PIN_MUX_REG(2,27),NONE,NONE,NONE,NONE,},
	[BOOT_17]={P_PIN_MUX_REG(5,0),NONE,NONE,NONE,NONE,},
	[GPIOD_0]={P_PIN_MUX_REG(1,29),P_PIN_MUX_REG(2,2),NONE,NONE,NONE,},
	[GPIOD_1]={P_PIN_MUX_REG(1,28),P_PIN_MUX_REG(2,3),NONE,NONE,NONE,},
	[GPIOD_2]={P_PIN_MUX_REG(0,22),P_PIN_MUX_REG(1,19),NONE,NONE,NONE,},
	[GPIOD_3]={P_PIN_MUX_REG(0,23),P_PIN_MUX_REG(1,18),NONE,NONE,NONE,},
	[GPIOD_4]={P_PIN_MUX_REG(1,17),P_PIN_MUX_REG(0,24),NONE,NONE,NONE,},
	[GPIOD_5]={P_PIN_MUX_REG(0,25),P_PIN_MUX_REG(1,16),NONE,NONE,NONE,},
	[GPIOD_6]={P_PIN_MUX_REG(1,15),P_PIN_MUX_REG(0,26),NONE,NONE,NONE,},
	[GPIOD_7]={P_PIN_MUX_REG(0,27),P_PIN_MUX_REG(1,13),P_PIN_MUX_REG(1,11),P_PIN_MUX_REG(1,14),P_PIN_MUX_REG(1,12),},
	[GPIOD_8]={P_PIN_MUX_REG(1,20),P_PIN_MUX_REG(0,28),NONE,NONE,NONE,},
	[GPIOD_9]={P_PIN_MUX_REG(7,16),P_PIN_MUX_REG(0,29),P_PIN_MUX_REG(3,26),NONE,NONE,},
	[GPIOC_0]={P_PIN_MUX_REG(2,0),P_PIN_MUX_REG(1,27),P_PIN_MUX_REG(0,21),NONE,NONE,},
	[GPIOC_1]={P_PIN_MUX_REG(2,1),P_PIN_MUX_REG(1,26),P_PIN_MUX_REG(0,20),NONE,NONE,},
	[GPIOC_2]={P_PIN_MUX_REG(0,12),P_PIN_MUX_REG(1,9),NONE,NONE,NONE,},
	[GPIOC_3]={P_PIN_MUX_REG(0,13),P_PIN_MUX_REG(1,8),NONE,NONE,NONE,},
	[GPIOC_4]={P_PIN_MUX_REG(1,7),P_PIN_MUX_REG(0,14),NONE,NONE,NONE,},
	[GPIOC_5]={P_PIN_MUX_REG(0,15),P_PIN_MUX_REG(1,6),NONE,NONE,NONE,},
	[GPIOC_6]={P_PIN_MUX_REG(1,5),P_PIN_MUX_REG(0,16),NONE,NONE,NONE,},
	[GPIOC_7]={P_PIN_MUX_REG(1,4),P_PIN_MUX_REG(1,11),P_PIN_MUX_REG(1,2),P_PIN_MUX_REG(0,17),P_PIN_MUX_REG(1,3),},
	[GPIOC_8]={P_PIN_MUX_REG(0,18),P_PIN_MUX_REG(1,10),P_PIN_MUX_REG(3,23),NONE,NONE,},
	[GPIOC_9]={P_PIN_MUX_REG(3,24),P_PIN_MUX_REG(3,25),P_PIN_MUX_REG(7,17),P_PIN_MUX_REG(0,19),NONE,},
	[GPIOC_10]={P_PIN_MUX_REG(1,22),NONE,NONE,NONE,NONE,},
	[GPIOC_11]={P_PIN_MUX_REG(1,23),NONE,NONE,NONE,NONE,},
	[GPIOC_12]={P_PIN_MUX_REG(1,24),NONE,NONE,NONE,NONE,},
	[GPIOC_13]={P_PIN_MUX_REG(1,25),NONE,NONE,NONE,NONE,},
	[GPIOC_14]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOC_15]={P_PIN_MUX_REG(3,22),NONE,NONE,NONE,NONE,},
	[CARD_0]={P_PIN_MUX_REG(2,7),P_PIN_MUX_REG(2,15),NONE,NONE,NONE,},
	[CARD_1]={P_PIN_MUX_REG(2,6),P_PIN_MUX_REG(2,14),NONE,NONE,NONE,},
	[CARD_2]={P_PIN_MUX_REG(2,6),P_PIN_MUX_REG(2,13),NONE,NONE,NONE,},
	[CARD_3]={P_PIN_MUX_REG(2,12),P_PIN_MUX_REG(2,6),NONE,NONE,NONE,},
	[CARD_4]={P_PIN_MUX_REG(2,11),P_PIN_MUX_REG(2,5),NONE,NONE,NONE,},
	[CARD_5]={P_PIN_MUX_REG(2,4),P_PIN_MUX_REG(2,10),NONE,NONE,NONE,},
	[CARD_6]={NONE,NONE,NONE,NONE,NONE,},
	[CARD_7]={NONE,NONE,NONE,NONE,NONE,},
	[CARD_8]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOB_0]={P_PIN_MUX_REG(3,10),P_PIN_MUX_REG(0,1),NONE,NONE,NONE,},
	[GPIOB_1]={P_PIN_MUX_REG(0,0),P_PIN_MUX_REG(3,11),NONE,NONE,NONE,},
	[GPIOB_2]={P_PIN_MUX_REG(0,0),P_PIN_MUX_REG(3,11),NONE,NONE,NONE,},
	[GPIOB_3]={P_PIN_MUX_REG(3,11),P_PIN_MUX_REG(5,23),P_PIN_MUX_REG(0,0),NONE,NONE,},
	[GPIOB_4]={P_PIN_MUX_REG(5,22),P_PIN_MUX_REG(3,11),P_PIN_MUX_REG(0,0),NONE,NONE,},
	[GPIOB_5]={P_PIN_MUX_REG(0,0),P_PIN_MUX_REG(5,21),P_PIN_MUX_REG(3,11),NONE,NONE,},
	[GPIOB_6]={P_PIN_MUX_REG(3,11),P_PIN_MUX_REG(5,20),P_PIN_MUX_REG(0,0),NONE,NONE,},
	[GPIOB_7]={P_PIN_MUX_REG(5,19),P_PIN_MUX_REG(0,0),P_PIN_MUX_REG(3,11),NONE,NONE,},
	[GPIOB_8]={P_PIN_MUX_REG(3,9),P_PIN_MUX_REG(0,3),P_PIN_MUX_REG(5,18),NONE,NONE,},
	[GPIOB_9]={P_PIN_MUX_REG(5,17),P_PIN_MUX_REG(3,8),P_PIN_MUX_REG(0,3),NONE,NONE,},
	[GPIOB_10]={P_PIN_MUX_REG(0,2),P_PIN_MUX_REG(3,7),P_PIN_MUX_REG(5,16),NONE,NONE,},
	[GPIOB_11]={P_PIN_MUX_REG(5,17),P_PIN_MUX_REG(3,6),P_PIN_MUX_REG(0,2),NONE,NONE,},
	[GPIOB_12]={P_PIN_MUX_REG(3,17),P_PIN_MUX_REG(0,2),NONE,NONE,NONE,},
	[GPIOB_13]={P_PIN_MUX_REG(0,2),P_PIN_MUX_REG(3,16),NONE,NONE,NONE,},
	[GPIOB_14]={P_PIN_MUX_REG(3,15),P_PIN_MUX_REG(0,2),NONE,NONE,NONE,},
	[GPIOB_15]={P_PIN_MUX_REG(0,2),P_PIN_MUX_REG(3,14),NONE,NONE,NONE,},
	[GPIOB_16]={P_PIN_MUX_REG(3,13),P_PIN_MUX_REG(0,5),NONE,NONE,NONE,},
	[GPIOB_17]={P_PIN_MUX_REG(0,5),P_PIN_MUX_REG(3,12),NONE,NONE,NONE,},
	[GPIOB_18]={P_PIN_MUX_REG(3,12),P_PIN_MUX_REG(0,4),NONE,NONE,NONE,},
	[GPIOB_19]={P_PIN_MUX_REG(3,12),P_PIN_MUX_REG(0,4),NONE,NONE,NONE,},
	[GPIOB_20]={P_PIN_MUX_REG(3,12),P_PIN_MUX_REG(0,4),NONE,NONE,NONE,},
	[GPIOB_21]={P_PIN_MUX_REG(0,4),P_PIN_MUX_REG(3,12),NONE,NONE,NONE,},
	[GPIOB_22]={P_PIN_MUX_REG(0,4),P_PIN_MUX_REG(3,12),NONE,NONE,NONE,},
	[GPIOB_23]={P_PIN_MUX_REG(0,4),P_PIN_MUX_REG(3,12),NONE,NONE,NONE,},
	[GPIOA_0]={P_PIN_MUX_REG(3,4),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_1]={P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_2]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(3,5),NONE,NONE,NONE,},
	[GPIOA_3]={P_PIN_MUX_REG(6,23),P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(0,6),NONE,NONE,},
	[GPIOA_4]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(6,22),NONE,NONE,},
	[GPIOA_5]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(6,21),NONE,NONE,},
	[GPIOA_6]={P_PIN_MUX_REG(6,20),P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(0,6),NONE,NONE,},
	[GPIOA_7]={P_PIN_MUX_REG(3,5),P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(6,19),NONE,NONE,},
	[GPIOA_8]={P_PIN_MUX_REG(3,0),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_9]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(3,1),NONE,NONE,NONE,},
	[GPIOA_10]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(3,2),NONE,NONE,NONE,},
	[GPIOA_11]={P_PIN_MUX_REG(3,3),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_12]={P_PIN_MUX_REG(7,0),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_13]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,1),NONE,NONE,NONE,},
	[GPIOA_14]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,2),NONE,NONE,NONE,},
	[GPIOA_15]={P_PIN_MUX_REG(7,3),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_16]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,4),NONE,NONE,NONE,},
	[GPIOA_17]={P_PIN_MUX_REG(7,5),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_18]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,6),NONE,NONE,NONE,},
	[GPIOA_19]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,7),NONE,NONE,NONE,},
	[GPIOA_20]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,8),NONE,NONE,NONE,},
	[GPIOA_21]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,9),NONE,NONE,NONE,},
	[GPIOA_22]={P_PIN_MUX_REG(7,10),P_PIN_MUX_REG(0,6),NONE,NONE,NONE,},
	[GPIOA_23]={P_PIN_MUX_REG(0,6),P_PIN_MUX_REG(7,11),NONE,NONE,NONE,},
	[GPIOA_24]={P_PIN_MUX_REG(7,12),P_PIN_MUX_REG(0,7),NONE,NONE,NONE,},
	[GPIOA_25]={P_PIN_MUX_REG(7,13),P_PIN_MUX_REG(0,8),NONE,NONE,NONE,},
	[GPIOA_26]={P_PIN_MUX_REG(0,9),P_PIN_MUX_REG(7,14),NONE,NONE,NONE,},
	[GPIOA_27]={P_PIN_MUX_REG(7,15),P_PIN_MUX_REG(0,10),NONE,NONE,NONE,},
	[GPIOAO_0]={P_PIN_MUX_REG(10,12),NONE,NONE,NONE,NONE,},
	[GPIOAO_1]={P_PIN_MUX_REG(10,11),NONE,NONE,NONE,NONE,},
	[GPIOAO_2]={P_PIN_MUX_REG(10,26),P_PIN_MUX_REG(10,8),P_PIN_MUX_REG(10,10),P_PIN_MUX_REG(10,4),NONE,},
	[GPIOAO_3]={P_PIN_MUX_REG(10,9),P_PIN_MUX_REG(10,3),P_PIN_MUX_REG(10,25),P_PIN_MUX_REG(10,7),NONE,},
	[GPIOAO_4]={P_PIN_MUX_REG(10,2),P_PIN_MUX_REG(10,24),P_PIN_MUX_REG(10,6),NONE,NONE,},
	[GPIOAO_5]={P_PIN_MUX_REG(10,5),P_PIN_MUX_REG(10,23),P_PIN_MUX_REG(10,1),NONE,NONE,},
	[GPIOAO_6]={P_PIN_MUX_REG(10,19),P_PIN_MUX_REG(10,22),NONE,NONE,NONE,},
	[GPIOAO_7]={P_PIN_MUX_REG(10,0),NONE,NONE,NONE,NONE,},
	[GPIOAO_8]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOAO_9]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOAO_10]={NONE,NONE,NONE,NONE,NONE,},
	[GPIOAO_11]={P_PIN_MUX_REG(10,21),NONE,NONE,NONE,NONE,},
};
struct amlogic_gpio_desc amlogic_pins[]=
{
	PIN_MAP(GPIOZ_0,6,16),
	PIN_MAP(GPIOZ_1,6,17),
	PIN_MAP(GPIOZ_2,6,18),
	PIN_MAP(GPIOZ_3,6,19),
	PIN_MAP(GPIOZ_4,6,20),
	PIN_MAP(GPIOZ_5,6,21),
	PIN_MAP(GPIOZ_6,6,22),
	PIN_MAP(GPIOZ_7,6,23),
	PIN_MAP(GPIOZ_8,6,24),
	PIN_MAP(GPIOZ_9,6,25),
	PIN_MAP(GPIOZ_10,6,26),
	PIN_MAP(GPIOZ_11,6,27),
	PIN_MAP(GPIOZ_12,6,28),
	PIN_MAP(GPIOE_0,6,0),
	PIN_MAP(GPIOE_1,6,1),
	PIN_MAP(GPIOE_2,6,2),
	PIN_MAP(GPIOE_3,6,3),
	PIN_MAP(GPIOE_4,6,4),
	PIN_MAP(GPIOE_5,6,5),
	PIN_MAP(GPIOE_6,6,6),
	PIN_MAP(GPIOE_7,6,7),
	PIN_MAP(GPIOE_8,6,8),
	PIN_MAP(GPIOE_9,6,9),
	PIN_MAP(GPIOE_10,6,10),
	PIN_MAP(GPIOE_11,6,11),
	PIN_MAP(GPIOY_0,5,0),
	PIN_MAP(GPIOY_1,5,1),
	PIN_MAP(GPIOY_2,5,2),
	PIN_MAP(GPIOY_3,5,3),
	PIN_MAP(GPIOY_4,5,4),
	PIN_MAP(GPIOY_5,5,5),
	PIN_MAP(GPIOY_6,5,6),
	PIN_MAP(GPIOY_7,5,7),
	PIN_MAP(GPIOY_8,5,8),
	PIN_MAP(GPIOY_9,5,9),
	PIN_MAP(GPIOY_10,5,10),
	PIN_MAP(GPIOY_11,5,11),
	PIN_MAP(GPIOY_12,5,12),
	PIN_MAP(GPIOY_13,5,13),
	PIN_MAP(GPIOY_14,5,14),
	PIN_MAP(GPIOY_15,5,15),
	PIN_MAP(GPIOX_0,4,0),
	PIN_MAP(GPIOX_1,4,1),
	PIN_MAP(GPIOX_2,4,2),
	PIN_MAP(GPIOX_3,4,3),
	PIN_MAP(GPIOX_4,4,4),
	PIN_MAP(GPIOX_5,4,5),
	PIN_MAP(GPIOX_6,4,6),
	PIN_MAP(GPIOX_7,4,7),
	PIN_MAP(GPIOX_8,4,8),
	PIN_MAP(GPIOX_9,4,9),
	PIN_MAP(GPIOX_10,4,10),
	PIN_MAP(GPIOX_11,4,11),
	PIN_MAP(GPIOX_12,4,12),
	PIN_MAP(GPIOX_13,4,13),
	PIN_MAP(GPIOX_14,4,14),
	PIN_MAP(GPIOX_15,4,15),
	PIN_MAP(GPIOX_16,4,16),
	PIN_MAP(GPIOX_17,4,17),
	PIN_MAP(GPIOX_18,4,18),
	PIN_MAP(GPIOX_19,4,19),
	PIN_MAP(GPIOX_20,4,20),
	PIN_MAP(GPIOX_21,4,21),
	PIN_MAP(GPIOX_22,4,22),
	PIN_MAP(GPIOX_23,4,23),
	PIN_MAP(GPIOX_24,4,24),
	PIN_MAP(GPIOX_25,4,25),
	PIN_MAP(GPIOX_26,4,26),
	PIN_MAP(GPIOX_27,4,27),
	PIN_MAP(GPIOX_28,4,28),
	PIN_MAP(GPIOX_29,4,29),
	PIN_MAP(GPIOX_30,4,30),
	PIN_MAP(GPIOX_31,4,31),
	PIN_MAP(GPIOX_32,4,20),
	PIN_MAP(GPIOX_33,4,21),
	PIN_MAP(GPIOX_34,4,22),
	PIN_MAP(GPIOX_35,4,23),
	PIN_MAP(BOOT_0,3,0),
	PIN_MAP(BOOT_1,3,1),
	PIN_MAP(BOOT_2,3,2),
	PIN_MAP(BOOT_3,3,3),
	PIN_MAP(BOOT_4,3,4),
	PIN_MAP(BOOT_5,3,5),
	PIN_MAP(BOOT_6,3,6),
	PIN_MAP(BOOT_7,3,7),
	PIN_MAP(BOOT_8,3,8),
	PIN_MAP(BOOT_9,3,9),
	PIN_MAP(BOOT_10,3,10),
	PIN_MAP(BOOT_11,3,11),
	PIN_MAP(BOOT_12,3,12),
	PIN_MAP(BOOT_13,3,13),
	PIN_MAP(BOOT_14,3,14),
	PIN_MAP(BOOT_15,3,15),
	PIN_MAP(BOOT_16,3,16),
	PIN_MAP(BOOT_17,3,17),
	PIN_MAP(GPIOD_0,2,16),
	PIN_MAP(GPIOD_1,2,17),
	PIN_MAP(GPIOD_2,2,18),
	PIN_MAP(GPIOD_3,2,19),
	PIN_MAP(GPIOD_4,2,20),
	PIN_MAP(GPIOD_5,2,21),
	PIN_MAP(GPIOD_6,2,22),
	PIN_MAP(GPIOD_7,2,23),
	PIN_MAP(GPIOD_8,2,24),
	PIN_MAP(GPIOD_9,2,25),
	PIN_MAP(GPIOC_0,2,0),
	PIN_MAP(GPIOC_1,2,1),
	PIN_MAP(GPIOC_2,2,2),
	PIN_MAP(GPIOC_3,2,3),
	PIN_MAP(GPIOC_4,2,4),
	PIN_MAP(GPIOC_5,2,5),
	PIN_MAP(GPIOC_6,2,6),
	PIN_MAP(GPIOC_7,2,7),
	PIN_MAP(GPIOC_8,2,8),
	PIN_MAP(GPIOC_9,2,9),
	PIN_MAP(GPIOC_10,2,10),
	PIN_MAP(GPIOC_11,2,11),
	PIN_MAP(GPIOC_12,2,12),
	PIN_MAP(GPIOC_13,2,13),
	PIN_MAP(GPIOC_14,2,14),
	PIN_MAP(GPIOC_15,2,15),
	PIN_MAP(CARD_0,5,23),
	PIN_MAP(CARD_1,5,24),
	PIN_MAP(CARD_2,5,25),
	PIN_MAP(CARD_3,5,26),
	PIN_MAP(CARD_4,5,27),
	PIN_MAP(CARD_5,5,28),
	PIN_MAP(CARD_6,5,29),
	PIN_MAP(CARD_7,5,30),
	PIN_MAP(CARD_8,5,31),
	PIN_MAP(GPIOB_0,1,0),
	PIN_MAP(GPIOB_1,1,1),
	PIN_MAP(GPIOB_2,1,2),
	PIN_MAP(GPIOB_3,1,3),
	PIN_MAP(GPIOB_4,1,4),
	PIN_MAP(GPIOB_5,1,5),
	PIN_MAP(GPIOB_6,1,6),
	PIN_MAP(GPIOB_7,1,7),
	PIN_MAP(GPIOB_8,1,8),
	PIN_MAP(GPIOB_9,1,9),
	PIN_MAP(GPIOB_10,1,10),
	PIN_MAP(GPIOB_11,1,11),
	PIN_MAP(GPIOB_12,1,12),
	PIN_MAP(GPIOB_13,1,13),
	PIN_MAP(GPIOB_14,1,14),
	PIN_MAP(GPIOB_15,1,15),
	PIN_MAP(GPIOB_16,1,16),
	PIN_MAP(GPIOB_17,1,17),
	PIN_MAP(GPIOB_18,1,18),
	PIN_MAP(GPIOB_19,1,19),
	PIN_MAP(GPIOB_20,1,20),
	PIN_MAP(GPIOB_21,1,21),
	PIN_MAP(GPIOB_22,1,22),
	PIN_MAP(GPIOB_23,1,23),
	PIN_MAP(GPIOA_0,0,0),
	PIN_MAP(GPIOA_1,0,1),
	PIN_MAP(GPIOA_2,0,2),
	PIN_MAP(GPIOA_3,0,3),
	PIN_MAP(GPIOA_4,0,4),
	PIN_MAP(GPIOA_5,0,5),
	PIN_MAP(GPIOA_6,0,6),
	PIN_MAP(GPIOA_7,0,7),
	PIN_MAP(GPIOA_8,0,8),
	PIN_MAP(GPIOA_9,0,9),
	PIN_MAP(GPIOA_10,0,10),
	PIN_MAP(GPIOA_11,0,11),
	PIN_MAP(GPIOA_12,0,12),
	PIN_MAP(GPIOA_13,0,13),
	PIN_MAP(GPIOA_14,0,14),
	PIN_MAP(GPIOA_15,0,15),
	PIN_MAP(GPIOA_16,0,16),
	PIN_MAP(GPIOA_17,0,17),
	PIN_MAP(GPIOA_18,0,18),
	PIN_MAP(GPIOA_19,0,19),
	PIN_MAP(GPIOA_20,0,20),
	PIN_MAP(GPIOA_21,0,21),
	PIN_MAP(GPIOA_22,0,22),
	PIN_MAP(GPIOA_23,0,23),
	PIN_MAP(GPIOA_24,0,24),
	PIN_MAP(GPIOA_25,0,25),
	PIN_MAP(GPIOA_26,0,26),
	PIN_MAP(GPIOA_27,0,27),
	PIN_AOMAP(GPIOAO_0,7,0,7,16,7,0),
	PIN_AOMAP(GPIOAO_1,7,1,7,17,7,1),
	PIN_AOMAP(GPIOAO_2,7,2,7,18,7,2),
	PIN_AOMAP(GPIOAO_3,7,3,7,19,7,3),
	PIN_AOMAP(GPIOAO_4,7,4,7,20,7,4),
	PIN_AOMAP(GPIOAO_5,7,5,7,21,7,5),
	PIN_AOMAP(GPIOAO_6,7,6,7,22,7,6),
	PIN_AOMAP(GPIOAO_7,7,7,7,23,7,7),
	PIN_AOMAP(GPIOAO_8,7,8,7,24,7,8),
	PIN_AOMAP(GPIOAO_9,7,9,7,25,7,9),
	PIN_AOMAP(GPIOAO_10,7,10,7,26,7,10),
	PIN_AOMAP(GPIOAO_11,7,11,7,27,7,11),
};

int gpio_amlogic_requst(struct gpio_chip *chip,unsigned offset)
{
	int ret;
	unsigned int i,reg,bit;
	unsigned int *gpio_reg=&gpio_to_pin[offset][0];
	unsigned long flags;
		for(i=0;i<sizeof(gpio_to_pin[offset])/sizeof(gpio_to_pin[offset][0]);i++){
			if(gpio_reg[i]!=NONE)
			{
				reg=GPIO_REG(gpio_reg[i]);
				bit=GPIO_BIT(gpio_reg[i]);
				aml_clr_reg32_mask(p_pin_mux_reg_addr[reg],1<<bit);
				gpio_print("clr reg=%d,bit =%d\n",reg,bit);				
				if(gpio_debug)
					printf("clear pinmux reg%d[%d]=%d\n",reg,bit,aml_get_reg32_bits(p_pin_mux_reg_addr[reg],bit,1));
			}
		}
}
/* amlogic request gpio interface*/



int gpio_amlogic_direction_input(struct gpio_chip *chip,unsigned offset)
{
	unsigned int reg,bit;
	unsigned long flags;
	
	reg=GPIO_REG(amlogic_pins[offset].out_en_reg_bit);
	bit=GPIO_BIT(amlogic_pins[offset].out_en_reg_bit);
	aml_set_reg32_mask(p_gpio_oen_addr[reg],1<<bit);
	
	if(gpio_debug)
		printf("set output en 0x%x[%d]=%d\n",p_gpio_oen_addr[reg],bit,aml_get_reg32_bits(p_gpio_oen_addr[reg],bit,1));
	return 0;
}

int gpio_amlogic_get(struct gpio_chip *chip,unsigned offset)
{
	unsigned int reg,bit,ret;
	unsigned long flags;
	
	reg=GPIO_REG(amlogic_pins[offset].input_value_reg_bit);
	bit=GPIO_BIT(amlogic_pins[offset].input_value_reg_bit);
	ret=aml_get_reg32_bits(p_gpio_input_addr[reg],bit,1);
	
	return ret;
}

int gpio_amlogic_direction_output(struct gpio_chip *chip,unsigned offset, int value)
{
	unsigned int reg,bit;
	unsigned long flags;
	
	if(value){
		reg=GPIO_REG(amlogic_pins[offset].out_value_reg_bit);
		bit=GPIO_BIT(amlogic_pins[offset].out_value_reg_bit);
		aml_set_reg32_mask(p_gpio_output_addr[reg],1<<bit);
		gpio_print("out reg=%x,value=%x\n",p_gpio_output_addr[reg],aml_read_reg32(p_gpio_output_addr[reg]));
	}
	else{
		reg=GPIO_REG(amlogic_pins[offset].out_value_reg_bit);
		bit=GPIO_BIT(amlogic_pins[offset].out_value_reg_bit);
		aml_clr_reg32_mask(p_gpio_output_addr[reg],1<<bit);
	}
	reg=GPIO_REG(amlogic_pins[offset].out_en_reg_bit);
	bit=GPIO_BIT(amlogic_pins[offset].out_en_reg_bit);
	aml_clr_reg32_mask(p_gpio_oen_addr[reg],1<<bit);
	if(gpio_debug){
		printf("set output en 0x%x[%d]=%d\n",p_gpio_oen_addr[reg],bit,aml_get_reg32_bits(p_gpio_oen_addr[reg],bit,1));
		printf("set output val 0x%x[%d]=%d\n",p_gpio_output_addr[reg],bit,aml_get_reg32_bits(p_gpio_oen_addr[reg],bit,1));
	}
	return 0;
}
void	gpio_amlogic_set(struct gpio_chip *chip,unsigned offset, int value)
{
	unsigned int reg,bit;
	unsigned long flags;
	
	reg=GPIO_REG(amlogic_pins[offset].out_value_reg_bit);
	bit=GPIO_BIT(amlogic_pins[offset].out_value_reg_bit);
	gpio_print("==%s==%d\n",__FUNCTION__,__LINE__);
	if(value)
		aml_set_reg32_mask(p_gpio_output_addr[reg],1<<bit);
	else
		aml_clr_reg32_mask(p_gpio_output_addr[reg],1<<bit);
	
}
int gpio_amlogic_name_to_num(const char *name)
{
	int i,tmp=100,num=0;
	int len=strlen(name);
	char *p=malloc(len+1);
	char *start=p;
	if(!p)
	{
		printf("%s:malloc error\n",__func__);
		return -1;
	}
	p=strcpy(p,name);
	for(i=0;i<len;p++,i++){		
		if(*p=='_'){
			*p='\0';
			tmp=i;
		}
		if(i>tmp&&*p>='0'&&*p<='9')
			num=num*10+*p-'0';
	}
	p=start;
	if(!strcmp(p,"GPIOZ"))
		num=num+0;
	else if(!strcmp(p,"GPIOE"))
		num=num+13;
	else if(!strcmp(p,"GPIOY"))
		num=num+25;
	else if(!strcmp(p,"GPIOX"))
		num=num+41;
	else if(!strcmp(p,"BOOT"))
		num=num+77;
	else if(!strcmp(p,"GPIOD"))
		num=num+95;
	else if(!strcmp(p,"GPIOC"))
		num=num+105;
	else if(!strcmp(p,"CARD"))
		num=num+121;
	else if(!strcmp(p,"GPIOB"))
		num=num+130;
	else if(!strcmp(p,"GPIOA"))
		num=num+154;
	else if(!strcmp(p,"GPIOAO"))
		num=num+182;
	else
		num= -1;	
	free(start);
	return num;
}
static int amlogic_pin_to_pullup(unsigned int pin ,unsigned int *reg,unsigned int *bit)
{
	if(pin<=GPIOZ_12)
	{
		*reg=6;
		*bit=pin;
	}
	else if (pin<=GPIOE_11)
	{
		*reg=6;
		*bit=pin-GPIOE_0+16;
	}
	else if(pin<=GPIOY_15)
	{
		*reg=5;
		*bit=pin-GPIOY_0+4;
	}
	else if(pin<=GPIOX_31)
	{
		*reg=4;
		*bit=pin-GPIOX_0;
	}
	else if(pin<=GPIOX_35)
	{
		*reg=5;
		*bit=pin-GPIOX_32;	
	}
	else if(pin<=BOOT_17)
	{
		*reg=3;
		*bit=pin-BOOT_0;
	}
	else if(pin<=GPIOD_9)
	{
		*reg=2;
		*bit=pin-GPIOD_0+16;
	}
	else if(pin<=GPIOC_15)
	{
		*reg=2;
		*bit=pin-GPIOC_0;
	}
	else if(pin<=CARD_8)
	{
		*reg=3;
		*bit=pin-CARD_0+20;
	}
	else if(pin<=GPIOB_23)
	{
		*reg=1;
		*bit=pin-GPIOB_0;
	}
	else if(pin<=GPIOA_27)
	{
		*reg=0;
		*bit=pin-GPIOA_0;
	}
	else
		return -1;
	return 0;
}
static int m6_set_pullup(unsigned int pin,unsigned int val,unsigned int pullupen)
{
	unsigned int reg=0,bit=0,ret;
	ret=amlogic_pin_to_pullup(pin,&reg,&bit);
	if(!ret)
	{
		if(val)
			aml_set_reg32_mask(p_pull_up_addr[reg],1<<bit);
		else
			aml_clr_reg32_mask(p_pull_up_addr[reg],1<<bit);
	}
	return ret;
}
static int m6_set_highz(unsigned int pin)
{
	m6_set_pullup(pin,0,0);
	gpio_amlogic_direction_input(NULL,pin);
	return 0;
}

struct gpio_chip amlogic_gpio_chip={
	.request=gpio_amlogic_requst,
	.direction_input=gpio_amlogic_direction_input,
	.get=gpio_amlogic_get,
	.direction_output=gpio_amlogic_direction_output,
	.set=gpio_amlogic_set,
	.name_to_pin=gpio_amlogic_name_to_num,
	.set_highz=m6_set_highz,
	.set_pullup=m6_set_pullup,
};

