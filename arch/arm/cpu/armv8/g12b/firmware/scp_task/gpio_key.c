/*
 * arch/arm/cpu/armv8/g12b/firmware/scp_task/gpio_key.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <gpio.h>
#include <aml_gpio.h>

#define PK(reg, bit)	((reg << 8) | bit)
#define PK_REG(value)	(value >> 8)

#define EE_OFFSET 12
#define GPIOAO(x) (x)
#define GPIOEE(x) (EE_OFFSET + x)

#define KERNEL_GPIO_OFFSET	399

static unsigned int g_bankindex;
static unsigned int g_offset;
static unsigned int g_active;

unsigned int gpio_wakeup_keyno;

/*
 * Support only default pull-up ports
 * on this version
 */
static struct gpio_array {
	unsigned int pin;
	unsigned int function;
} gpio_to_pin[] = {
	{
		.pin = (GPIOA_14 + EE_OFFSET),
		.function = PK(0xe, 14),
	},
	{
		.pin = (GPIOX_0 + EE_OFFSET),
		.function = PK(3, 0),
	},
	{
		.pin = (GPIOX_1 + EE_OFFSET),
		.function = PK(3, 1),
	},
	{
		.pin = (GPIOX_2 + EE_OFFSET),
		.function = PK(3, 2),
	},
	{
		.pin = (GPIOX_3 + EE_OFFSET),
		.function = PK(3, 3),
	},
	{
		.pin = (GPIOX_4 + EE_OFFSET),
		.function = PK(3, 4),
	},
	{
		.pin = (GPIOX_5 + EE_OFFSET),
		.function = PK(3, 5),
	},
	{
		.pin = (GPIOX_7 + EE_OFFSET),
		.function = PK(3, 7),
	},
	{
		.pin = (GPIOX_8 + EE_OFFSET),
		.function = PK(4, 8),
	},
	{
		.pin = (GPIOX_9 + EE_OFFSET),
		.function = PK(4, 9),
	},
	{
		.pin = (GPIOX_10 + EE_OFFSET),
		.function = PK(4, 10),
	},
	{
		.pin = (GPIOX_11 + EE_OFFSET),
		.function = PK(4, 11),
	},
	{
		.pin = (GPIOX_12 + EE_OFFSET),
		.function = PK(4, 12),
	},
	{
		.pin = (GPIOX_13 + EE_OFFSET),
		.function = PK(4, 13),
	},
	{
		.pin = (GPIOX_14 + EE_OFFSET),
		.function = PK(4, 14),
	},
	{
		.pin = (GPIOX_15 + EE_OFFSET),
		.function = PK(4, 15),
	},
	{
		.pin = (GPIOX_16 + EE_OFFSET),
		.function = PK(5, 16),
	},
	{
		.pin = (GPIOX_18 + EE_OFFSET),
		.function = PK(5, 18),
	},
};

#define BANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
{								\
	.name	= n,						\
	.first	= f,						\
	.last	= l,						\
	.regs	= {						\
		[REG_PULLEN]	= { (0xff634520 + (per<<2)), peb },			\
		[REG_PULL]	= { (0xff6344e8 + (pr<<2)), pb },			\
		[REG_DIR]	= { (0xff634440 + (dr<<2)), db },			\
		[REG_OUT]	= { (0xff634440 + (or<<2)), ob },			\
		[REG_IN]	= { (0xff634440 + (ir<<2)), ib },			\
	},							\
 }

static struct meson_bank mesong12b_banks[] = {
	/*   name    first         last
	 *   pullen  pull  dir  out  in  */
	BANK("GPIOA_", GPIOEE(GPIOA_0), GPIOEE(GPIOA_15),
	5, 0,  5,  0,  16,  0, 17, 0, 18, 0),
	BANK("GPIOX_", GPIOEE(GPIOX_0), GPIOEE(GPIOX_19),
	2, 0,  2,  0,  6,  0, 7, 0, 8, 0),
};

/* GPIOEE pin mux registers */
static unsigned long domain = 0xff6346c0;

/* active level - 0 : active low, 1 : active high */
static unsigned long active_tbl[] = {
	[0] = 0x00003FFF, /* GPIOA */
	[1] = 0x000A0040, /* GPIOX */
};

int clear_pinmux(unsigned int pin)
{
	unsigned int i;
	unsigned int reg = 0;
	unsigned int bit = 0;

	for (i = 0; i < ARRAY_SIZE(gpio_to_pin); i++) {
		if (gpio_to_pin[i].pin == pin) {
			reg = (PK_REG(gpio_to_pin[i].function) & 0xf);
			g_offset = (gpio_to_pin[i].function & 0xff);
			bit = ((g_offset % 8) * 4);
			aml_update_bits((domain + (reg << 2)), (0xf << bit), 0);
			break;
		}
	}

	if (i >= ARRAY_SIZE(gpio_to_pin))
		return 0;
	else
		return 1;
}

int init_gpio_key(void)
{
	unsigned int key_index;
	unsigned int reg, bit;
	struct meson_bank bank;

	if (!gpio_wakeup_keyno)
		return 0;

	key_index = gpio_wakeup_keyno - KERNEL_GPIO_OFFSET;
	if ((key_index >= (GPIOA_0 + EE_OFFSET))
		&& (key_index < (GPIOA_15 + EE_OFFSET))) {
		g_bankindex = 0;
	} else if ((key_index >= GPIOX_0 + EE_OFFSET)
		&& (key_index < (GPIOX_19 + EE_OFFSET))) {
		g_bankindex = 1;
	} else {
		uart_puts("WAKEUP GPIO FAIL - invalid key \n");
		uart_put_hex(key_index, 32);
		uart_puts("\n");
		return 0;
	}

	/* clear_pinmux */
	if (!clear_pinmux(key_index))
		return 0;

	/* active level */
	g_active = ((active_tbl[g_bankindex] >> g_offset) & 0x1);

	/* set as input port */
	bank = mesong12b_banks[g_bankindex];
	reg = bank.regs[REG_DIR].reg;
	bit = bank.regs[REG_DIR].bit + g_offset;
	aml_update_bits(reg, BIT(bit), BIT(bit));

	return 1;
}

int key_chattering(void)
{
	unsigned int count = 0;
	unsigned int key_pressed = 1;
	unsigned int reg, bit;
	unsigned int active_value;
	struct meson_bank bank = mesong12b_banks[g_bankindex];

	reg = bank.regs[REG_IN].reg;
	bit = bank.regs[REG_IN].bit + g_offset;

	if (g_active)
		active_value = (1 << bit);
	else
		active_value = 0;

	while (key_pressed) {
		_udelay(1000);

		if ((readl(reg) & (1 << bit)) == active_value)
			count++;
		else
			key_pressed = 0;

		if (count == 300)
			return 1;
	}

	return 0;
}

int gpio_detect_key(void)
{
	unsigned int reg, bit;
	unsigned int active_value;
	struct meson_bank bank = mesong12b_banks[g_bankindex];

	reg = bank.regs[REG_IN].reg;
	bit = bank.regs[REG_IN].bit + g_offset;

	if (g_active)
		active_value = (1 << bit);
	else
		active_value = 0;

	if ((readl(reg) & (1 << bit)) == active_value)
		if (key_chattering())
			return 1;

	return 0;
}
