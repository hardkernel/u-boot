#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif
/*
 * board/amlogic/gxtvbb_skt_v1/firmware/scp_task/pwr_ctrl.c
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

static void power_off_at_clk81(void)
{
}

static void power_on_at_clk81(unsigned int suspend_from)
{
}

static void power_off_at_24M(void)
{
}
static void power_on_at_24M(void)
{
}

static void power_off_at_32k(unsigned int suspend_from)
{
}
static void power_on_at_32k(unsigned int suspend_from)
{
}

static void wakeup_timer_setup(void)
{
	/* 1ms resolution*/
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value |= ((0x3<<0) | (0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
	writel(10, P_ISA_TIMERA);
}
static void wakeup_timer_clear(void)
{
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value &= ~((0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
}

static void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	p->gpio_info_count = 0;
	p->status = RESPONSE_OK;
	val = (AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC);

#ifdef CONFIG_CEC_WAKEUP
	if (suspend_from != SYS_POWEROFF)
		val |= CEC_WAKEUP_SRC;
#endif

	p->sources = val;

}
static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned time_out_ms = time_out*100;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */

	/* setup wakeup resources*/
	/*auto suspend: timerA 10ms resolution*/
	if (time_out_ms != 0)
		wakeup_timer_setup();

	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif

	/* *wakeup_en = 1;*/
	do {
#ifdef CONFIG_CEC_WAKEUP
		if (irq[IRQ_AO_CEC] == IRQ_AO_CEC_NUM) {
			irq[IRQ_AO_CEC] = 0xFFFFFFFF;
			if (suspend_from == SYS_POWEROFF)
				continue;
			if (cec_msg.log_addr) {
				if (hdmi_cec_func_config & 0x1) {
					cec_handler();
					if (cec_msg.cec_power == 0x1) {
						/*cec power key*/
						exit_reason = CEC_WAKEUP;
						break;
					}
				}
			} else if (hdmi_cec_func_config & 0x1)
				cec_node_init();
		}
#endif
		if (irq[IRQ_TIMERA] == IRQ_TIMERA_NUM) {
			irq[IRQ_TIMERA] = 0xFFFFFFFF;
			if (time_out_ms != 0)
				time_out_ms--;
			if (time_out_ms == 0) {
				wakeup_timer_clear();
				exit_reason = AUTO_WAKEUP;
			}
		}

		if (irq[IRQ_AO_IR_DEC] == IRQ_AO_IR_DEC_NUM) {
			irq[IRQ_AO_IR_DEC] = 0xFFFFFFFF;
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
		}

#ifdef CONFIG_BT_WAKEUP
		if (irq[IRQ_GPIO0] == IRQ_GPIO0_NUM) {
			irq[IRQ_GPIO0] = 0xFFFFFFFF;
			if (!(readl(PREG_PAD_GPIO4_EN_N)
			      & (0x01 << 20)) && (readl(PREG_PAD_GPIO4_O)
						  & (0x01 << 20)) &&
			    !(readl(PREG_PAD_GPIO4_I)
			      & (0x01 << 21)))
				exit_reason = BT_WAKEUP;
		}
#endif
#ifdef CONFIG_WIFI_WAKEUP
		if (irq[IRQ_GPIO1] == IRQ_GPIO1_NUM) {
			irq[IRQ_GPIO1] = 0xFFFFFFFF;
			if (suspend_from) {
				if (!(readl(PREG_PAD_GPIO4_EN_N)
				      & (0x01 << 6)) && (readl(PREG_PAD_GPIO4_O)
							 & (0x01 << 6)) &&
				    !(readl(PREG_PAD_GPIO4_I)
				      & (0x01 << 7)))
					exit_reason = WIFI_WAKEUP;
			}
		}
#endif
		if (exit_reason)
			break;
		else
			asm volatile("wfi");
	} while (1);

	wakeup_timer_clear();
	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_clk81 = power_off_at_clk81;
	pwr_op->power_on_at_clk81 = power_on_at_clk81;
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->power_off_at_32k = power_off_at_32k;
	pwr_op->power_on_at_32k = power_on_at_32k;

	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
