
/*
 * board/amlogic/txl_skt_v1/firmware/scp_task/pwr_ctrl.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
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

static int pwm_voltage_table_ee[][2] = {
	{ 0x1c0000,  810},
	{ 0x1b0001,  820},
	{ 0x1a0002,  830},
	{ 0x190003,  840},
	{ 0x180004,  850},
	{ 0x170005,  860},
	{ 0x160006,  870},
	{ 0x150007,  880},
	{ 0x140008,  890},
	{ 0x130009,  900},
	{ 0x12000a,  910},
	{ 0x11000b,  920},
	{ 0x10000c,  930},
	{ 0x0f000d,  940},
	{ 0x0e000e,  950},
	{ 0x0d000f,  960},
	{ 0x0c0010,  970},
	{ 0x0b0011,  980},
	{ 0x0a0012,  990},
	{ 0x090013, 1000},
	{ 0x080014, 1010},
	{ 0x070015, 1020},
	{ 0x060016, 1030},
	{ 0x050017, 1040},
	{ 0x040018, 1050},
	{ 0x030019, 1060},
	{ 0x02001a, 1070},
	{ 0x01001b, 1080},
	{ 0x00001c, 1090}
};

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#if 0

#define ON 1
#define OFF 0

static void power_switch_to_ee(unsigned int pwr_ctrl)
{
	if (pwr_ctrl == ON) {
		writel(readl(AO_RTI_PWR_CNTL_REG0) | (0x1 << 9), AO_RTI_PWR_CNTL_REG0);
		_udelay(1000);
		writel(readl(AO_RTI_PWR_CNTL_REG0)
			& (~((0x3 << 3) | (0x1 << 1))), AO_RTI_PWR_CNTL_REG0);
	} else {
		writel(readl(AO_RTI_PWR_CNTL_REG0)
		       | ((0x3 << 3) | (0x1 << 1)), AO_RTI_PWR_CNTL_REG0);

		writel(readl(AO_RTI_PWR_CNTL_REG0) & (~(0x1 << 9)),
		       AO_RTI_PWR_CNTL_REG0);

	}
}

#endif


static void set_vddee_voltage(unsigned int target_voltage)
{
	unsigned int to;

	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table_ee); to++) {
		if (pwm_voltage_table_ee[to][1] >= target_voltage) {
			break;
		}
	}

	if (to >= ARRAY_SIZE(pwm_voltage_table_ee)) {
		to = ARRAY_SIZE(pwm_voltage_table_ee) - 1;
	}

	writel(pwm_voltage_table_ee[to][0],AO_PWM_PWM_D);
}

static void power_off_at_24M(unsigned int suspend_from)
{
	/*set gpioao_13 low to power off vcc 5v*/
	writel(readl(AO_GPIO_O_EN_N) & (~(1 << 13)) & (~(1 << 29)), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PINMUX_REG1) & (~(0xf << 20)), AO_RTI_PINMUX_REG1);

	/*set gpioao_12 high to power off vcc 3.3v*/
	writel((readl(AO_GPIO_O_EN_N) & (~(1 << 12))) | (1 << 28), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PINMUX_REG1) & (~(0xf << 16)), AO_RTI_PINMUX_REG1);

	/*power off VDDCPU*/
	writel(readl(AO_GPIO_O_EN_N) & (~(1 << 31)), AO_GPIO_O_EN_N);

	/*pull down BT_EN*/
	writel(readl(PREG_PAD_GPIO2_O) & (~(1<<21)), PREG_PAD_GPIO2_O);
	writel(readl(PREG_PAD_GPIO2_EN_N) & (~(1<<21)), PREG_PAD_GPIO2_EN_N);
	writel(readl(PERIPHS_PIN_MUX_6) & (~(0xf<<20)),PERIPHS_PIN_MUX_6);

	/*step down ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_SLEEP_VOLTAGE);

/*
	uart_puts("81gate = 0x");
	uart_put_hex(readl(0xff63c140),32);
	uart_puts("\n");
	uart_puts("81gate = 0x");
	uart_put_hex(readl(0xff63c144),32);
	uart_puts("\n");
	uart_puts("81gate = 0x");
	uart_put_hex(readl(0xff63c148),32);
	uart_puts("\n");

	writel(0,0xff63c000);
	writel(0,0xff63c004);
	writel(0,0xff63c008);

	uart_puts("mipi = 0x");
	uart_put_hex(readl(0xff63c000),32);
	uart_puts("\n");
	uart_put_hex(readl(0xff63c004),32);
	uart_puts("\n");
	uart_put_hex(readl(0xff63c008),32);
	uart_puts("\n");

	uart_puts("PCIE_CML = 0x");
	uart_put_hex(readl(0xff63c0f0),32);
	uart_puts("\n");

	uart_puts("PCIE_PLL = 0x");
	uart_put_hex(readl(0xff63c0d8),32);
	uart_puts("\n");

	uart_puts("AO_SAR_CLK = 0x");
	uart_put_hex(readl(0xFF800090),32);
	uart_puts("\n");

	uart_puts("GP0_PLL = 0x");
	uart_put_hex(readl(HHI_GP0_PLL_CNTL),32);
	uart_puts("\n");
	uart_puts("MPLL = 0x");
	uart_put_hex(readl(HHI_MPLL_CNTL),32);
	uart_puts("\n");
	uart_puts("HIFI_PLL = 0x");
	uart_put_hex(readl(HHI_HIFI_PLL_CNTL),32);
	uart_puts("\n");
	writel(0,HHI_HIFI_PLL_CNTL2);
	writel(0,HHI_HIFI_PLL_CNTL);

	uart_puts("HHI_PLL6 = 0x");
	uart_put_hex(readl(HHI_MPLL_CNTL6),32);
	uart_puts("\n");

	uart_puts("SYS_PLL = 0x");
	uart_put_hex(readl(HHI_SYS_PLL_CNTL),32);
	uart_puts("\n");

	writel(0,0xff637000);
	writel(0,0xff637004);
	writel(0,0xff637008);
	writel(0,0xff63700c);
	writel(0,0xff637010);
	writel(0,0xff637014);
	writel(0,0xff637018);

	writel(0, HHI_MPLL_CNTL);
	writel(0, HHI_MPLL_CNTL2);
	writel(0, HHI_MPLL_CNTL3);
	writel(0, HHI_MPLL_CNTL4);
	writel(0, HHI_MPLL_CNTL5);
	writel(0, HHI_MPLL_CNTL6);
	writel(0, HHI_MPLL_CNTL7);
	writel(0, HHI_MPLL_CNTL8);
	writel(0, HHI_MPLL_CNTL9);
	writel(0, HHI_MPLL_CNTL10);
	writel(0, HHI_MPLL3_CNTL0);
	writel(0, HHI_MPLL3_CNTL1);

	writel(0, HHI_SYS_PLL_CNTL);
	writel(0, HHI_SYS_PLL_CNTL1);
	writel(0, HHI_SYS_PLL_CNTL2);
	writel(0, HHI_SYS_PLL_CNTL3);
	writel(0, HHI_SYS_PLL_CNTL4);
	writel(0, HHI_SYS_PLL_CNTL5);

	writel(0x088800e1,0xff63c140);
	writel(0xe0800000,0xff63c144);
	writel(0x44000006,0xff63c148);
*/
}

static void power_on_at_24M(unsigned int suspend_from)
{
	/*step up ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_INIT_VOLTAGE);

	/*power on VDDCPU*/
	writel(readl(AO_GPIO_O_EN_N) | (1 << 31), AO_GPIO_O_EN_N);
	_udelay(100);

	/*set gpioao_12 low to power om vcc 3.3v*/
	writel(readl(AO_GPIO_O_EN_N) & (~(1 << 12)) & (~(1 << 28)), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PINMUX_REG1) & (~(0xf << 16)), AO_RTI_PINMUX_REG1);
	_udelay(200);

	/*set gpioao_13 high to power on vcc 5v*/
	writel((readl(AO_GPIO_O_EN_N) & (~(1 << 13))) | (1 << 29), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PINMUX_REG1) & (~(0xf << 20)), AO_RTI_PINMUX_REG1);
	_udelay(10000);
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;

	p->status = RESPONSE_OK;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC |
	       ETH_PHY_WAKEUP_SRC | BT_WAKEUP_SRC);

	p->sources = val;
	p->gpio_info_count = 0;
}
/*
static unsigned int mpeg_clk;
void clk81_switch_to_24M(int flag)//for 1M
{
	unsigned int val;
	if (flag) {
		//val = readl(HHI_MPEG_CLK_CNTL);
		//val = val | (0x1 << 8);
		uart_puts("val3 = 0x");
		uart_put_hex(mpeg_clk,32);
		uart_puts("ddddd\n");
		writel(mpeg_clk, HHI_MPEG_CLK_CNTL);
		uart_puts("val4 = 0x");
		uart_put_hex(readl(HHI_MPEG_CLK_CNTL),32);
		_udelay(100);
		uart_puts("val5 = 0x");
	} else{
		val = readl(HHI_MPEG_CLK_CNTL);
		mpeg_clk = val;
		uart_puts("val = 0x");
		uart_put_hex(val,32);
	//	val = (val & (~(1<<9)) & (~(0x7<<12)) & (~(1<<31)) & (~(0x7f<<0))) | (3<<7) | (0x0<<0);//1M
		val = (val & (~((1<<9) | (0x7<<12) | (1<<31) | (0x7f<<0)))) | (3<<7) | (0x17<<0);//12M
		uart_puts("val2 = 0x");
		uart_put_hex(val,32);
	//	val = val & (~(0x3<<8)) ;
		writel(val, HHI_MPEG_CLK_CNTL);
	//	writel(readl(HHI_MPEG_CLK_CNTL) | (1<<8), HHI_MPEG_CLK_CNTL);
		_udelay(100);
	}
}
*/
extern void __switch_idle_task(void);

static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
	unsigned char adc_key_cnt = 0;

	init_remote();
	saradc_enable();

	do {
		if (irq[IRQ_AO_IR_DEC] == IRQ_AO_IR_DEC_NUM) {
			irq[IRQ_AO_IR_DEC] = 0xFFFFFFFF;
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
		}

		if (irq[IRQ_ETH_PHY] == IRQ_ETH_PHY_NUM) {
			irq[IRQ_ETH_PHY] = 0xFFFFFFFF;
			exit_reason = ETH_PHY_WAKEUP;
		}

		if (irq[IRQ_VRTC] == IRQ_VRTC_NUM) {
			irq[IRQ_VRTC] = 0xFFFFFFFF;
			exit_reason = RTC_WAKEUP;
		}

		if (irq[IRQ_AO_TIMERA] == IRQ_AO_TIMERA_NUM) {
			irq[IRQ_AO_TIMERA] = 0xFFFFFFFF;
			if (check_adc_key_resume()) {
				adc_key_cnt++;
				/*using variable 'adc_key_cnt' to eliminate the dithering of the key*/
				if (2 == adc_key_cnt)
					exit_reason = POWER_KEY_WAKEUP;
			} else {
				adc_key_cnt = 0;
			}
		}

		if (exit_reason)
			break;
		else
			__switch_idle_task();
	} while (1);

	saradc_disable();

	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
