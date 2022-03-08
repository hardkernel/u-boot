/*
 * Copyright (c) 2022 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/hardware.h>
#include <asm/arch/grf_rv1106.h>
#include <asm/arch/ioc_rv1106.h>

DECLARE_GLOBAL_DATA_PTR;

#define PERI_SGRF_BASE			0xff070000
#define PERI_SGRF_FIREWALL_CON0		0x0020
#define PERI_SGRF_FIREWALL_CON1		0x0024
#define PERI_SGRF_FIREWALL_CON2		0x0028
#define PERI_SGRF_FIREWALL_CON3		0x002c
#define PERI_SGRF_FIREWALL_CON4		0x0030
#define PERI_SGRF_SOC_CON3		0x00bc

#define CORE_SGRF_BASE			0xff076000
#define CORE_SGRF_FIREWALL_CON0		0x0020
#define CORE_SGRF_FIREWALL_CON1		0x0024
#define CORE_SGRF_FIREWALL_CON2		0x0028
#define CORE_SGRF_FIREWALL_CON3		0x002c
#define CORE_SGRF_FIREWALL_CON4		0x0030
#define CORE_SGRF_CPU_CTRL_CON		0x0040
#define CORE_SGRF_HPMCU_BOOT_ADDR	0x0044

#define PMU_SGRF_BASE			0xff080000

#define FW_DDR_BASE			0xff900000
#define FW_DDR_MST3_REG			0x4c
#define FW_SHRM_BASE			0xff910000
#define FW_SHRM_MST1_REG		0x44

#define CORECRU_BASE			0xff3b8000
#define CORECRU_CORESOFTRST_CON01	0xa04

#define GPIO0_IOC_BASE			0xFF388000
#define GPIO1_IOC_BASE			0xFF538000
#define GPIO2_IOC_BASE			0xFF548000
#define GPIO3_IOC_BASE			0xFF558000
#define GPIO4_IOC_BASE			0xFF568000

#define GPIO3A_IOMUX_SEL_L		0x0040
#define GPIO3A_IOMUX_SEL_H		0x0044

/* uart0 iomux */
/* gpio0a0 */
#define UART0_RX_M0			1
#define UART0_RX_M0_OFFSET		0
#define UART0_RX_M0_ADDR		(GPIO1_IOC_BASE)
/* gpio0a1 */
#define UART0_TX_M0			1
#define UART0_TX_M0_OFFSET		4
#define UART0_TX_M0_ADDR		(GPIO1_IOC_BASE)

/* gpio2b0 */
#define UART0_RX_M1			1
#define UART0_RX_M1_OFFSET		0
#define UART0_RX_M1_ADDR		(GPIO2_IOC_BASE + 0x28)
/* gpio2b1 */
#define UART0_TX_M1			1
#define UART0_TX_M1_OFFSET		4
#define UART0_TX_M1_ADDR		(GPIO2_IOC_BASE + 0x28)

/* gpio4a0 */
#define UART0_RX_M2			3
#define UART0_RX_M2_OFFSET		0
#define UART0_RX_M2_ADDR		(GPIO4_IOC_BASE)
/* gpio4a1 */
#define UART0_TX_M2			3
#define UART0_TX_M2_OFFSET		4
#define UART0_TX_M2_ADDR		(GPIO4_IOC_BASE)

/* uart1 iomux */
/* gpio1a4 */
#define UART1_RX_M0			1
#define UART1_RX_M0_OFFSET		0
#define UART1_RX_M0_ADDR		(GPIO1_IOC_BASE + 0x4)
/* gpio1a3 */
#define UART1_TX_M0			1
#define UART1_TX_M0_OFFSET		12
#define UART1_TX_M0_ADDR		(GPIO1_IOC_BASE)

/* gpio2a5 */
#define UART1_RX_M1			4
#define UART1_RX_M1_OFFSET		4
#define UART1_RX_M1_ADDR		(GPIO2_IOC_BASE + 0x24)
/* gpio2a4 */
#define UART1_TX_M1			4
#define UART1_TX_M1_OFFSET		0
#define UART1_TX_M1_ADDR		(GPIO2_IOC_BASE + 0x24)

/* gpio4a7 */
#define UART1_RX_M2			3
#define UART1_RX_M2_OFFSET		12
#define UART1_RX_M2_ADDR		(GPIO4_IOC_BASE + 0x4)
/* gpio4a5 */
#define UART1_TX_M2			3
#define UART1_TX_M2_OFFSET		4
#define UART1_TX_M2_ADDR		(GPIO4_IOC_BASE + 0x4)

/* uart2 iomux */
/* gpio3a3 */
#define UART2_RX_M0			2
#define UART2_RX_M0_OFFSET		12
#define UART2_RX_M0_ADDR		(GPIO3_IOC_BASE + 0x40)
/* gpio3a2 */
#define UART2_TX_M0			2
#define UART2_TX_M0_OFFSET		8
#define UART2_TX_M0_ADDR		(GPIO3_IOC_BASE + 0x40)

/* gpio1b3 */
#define UART2_RX_M1			2
#define UART2_RX_M1_OFFSET		12
#define UART2_RX_M1_ADDR		(GPIO1_IOC_BASE + 0x8)
/* gpio1b2 */
#define UART2_TX_M1			2
#define UART2_TX_M1_OFFSET		8
#define UART2_TX_M1_ADDR		(GPIO1_IOC_BASE + 0x8)

/* uart3 iomux */
/* gpio1a1 */
#define UART3_RX_M0			1
#define UART3_RX_M0_OFFSET		4
#define UART3_RX_M0_ADDR		(GPIO1_IOC_BASE)
/* gpio1a0 */
#define UART3_TX_M0			1
#define UART3_TX_M0_OFFSET		0
#define UART3_TX_M0_ADDR		(GPIO1_IOC_BASE)

/* gpio1d1 */
#define UART3_RX_M1			5
#define UART3_RX_M1_OFFSET		4
#define UART3_RX_M1_ADDR		(GPIO1_IOC_BASE + 0x18)
/* gpio1d0 */
#define UART3_TX_M1			5
#define UART3_TX_M1_OFFSET		0
#define UART3_TX_M1_ADDR		(GPIO2_IOC_BASE + 0x18)

/* uart4 iomux */
/* gpio1b0 */
#define UART4_RX_M0			1
#define UART4_RX_M0_OFFSET		0
#define UART4_RX_M0_ADDR		(GPIO1_IOC_BASE + 0x8)
/* gpio1b1 */
#define UART4_TX_M0			1
#define UART4_TX_M0_OFFSET		4
#define UART4_TX_M0_ADDR		(GPIO1_IOC_BASE + 0x8)

/* gpio1c4 */
#define UART4_RX_M1			4
#define UART4_RX_M1_OFFSET		0
#define UART4_RX_M1_ADDR		(GPIO1_IOC_BASE + 0x14)
/* gpio1c5 */
#define UART4_TX_M1			4
#define UART4_TX_M1_OFFSET		4
#define UART4_TX_M1_ADDR		(GPIO1_IOC_BASE + 0x14)

/* uart5 iomux */
/* gpio3a7 */
#define UART5_RX_M0			2
#define UART5_RX_M0_OFFSET		11
#define UART5_RX_M0_ADDR		(GPIO3_IOC_BASE + 0x44)
/* gpio3a6 */
#define UART5_TX_M0			1
#define UART5_TX_M0_OFFSET		8
#define UART5_TX_M0_ADDR		(GPIO1_IOC_BASE + 0x44)

/* gpio1d2 */
#define UART5_RX_M1			4
#define UART5_RX_M1_OFFSET		8
#define UART5_RX_M1_ADDR		(GPIO1_IOC_BASE + 0x18)
/* gpio1d3 */
#define UART5_TX_M1			4
#define UART5_TX_M1_OFFSET		12
#define UART5_TX_M1_ADDR		(GPIO1_IOC_BASE + 0x18)

/* gpio3d0 */
#define UART5_RX_M2			2
#define UART5_RX_M2_OFFSET		0
#define UART5_RX_M2_ADDR		(GPIO3_IOC_BASE + 0x58)
/* gpio3c7 */
#define UART5_TX_M2			2
#define UART5_TX_M2_OFFSET		12
#define UART5_TX_M2_ADDR		(GPIO4_IOC_BASE + 0x54)

#define set_uart_iomux(bits_offset, bits_val, addr) \
	writel(GENMASK(bits_offset + 19, bits_offset + 16) | (bits_val << bits_offset) , addr)

#define set_uart_iomux_rx(ID, MODE) \
	set_uart_iomux(UART##ID##_RX_M##MODE##_OFFSET, UART##ID##_RX_M##MODE, UART##ID##_RX_M##MODE##_ADDR);
#define set_uart_iomux_tx(ID, MODE) \
	set_uart_iomux(UART##ID##_TX_M##MODE##_OFFSET, UART##ID##_TX_M##MODE, UART##ID##_TX_M##MODE##_ADDR);

void board_debug_uart_init(void)
{
/* UART 0 */
#if defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4a0000)

#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART0_M0 Switch iomux */
	set_uart_iomux_rx(0, 0);
	set_uart_iomux_tx(0, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART0_M1 Switch iomux */
	set_uart_iomux_rx(0, 1);
	set_uart_iomux_tx(0, 1);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 2)

	/* UART0_M2 Switch iomux */
	set_uart_iomux_rx(0, 2);
	set_uart_iomux_tx(0, 2);
#endif

/* UART 1 */
#elif defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4b0000)

#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART1_M0 Switch iomux */
	set_uart_iomux_rx(1, 0);
	set_uart_iomux_tx(1, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART1_M1 Switch iomux */
	set_uart_iomux_rx(1, 1);
	set_uart_iomux_tx(1, 1);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 2)

	/* UART1_M2 Switch iomux */
	set_uart_iomux_rx(1, 2);
	set_uart_iomux_tx(1, 2);
#endif
/* UART 2 */
#elif defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4c0000)

#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART2_M0 Switch iomux */
	set_uart_iomux_rx(2, 0);
	set_uart_iomux_tx(2, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART2_M1 Switch iomux */
	set_uart_iomux_rx(2, 1);
	set_uart_iomux_tx(2, 1);
#endif

/* UART 3 */
#elif defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4d0000)
#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART3_M0 Switch iomux */
	set_uart_iomux_rx(3, 0);
	set_uart_iomux_tx(3, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART3_M1 Switch iomux */
	set_uart_iomux_rx(3, 1);
	set_uart_iomux_tx(3, 1);
#endif
/* UART 4 */
#elif defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4e0000)
#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART4_M0 Switch iomux */
	set_uart_iomux_rx(4, 0);
	set_uart_iomux_tx(4, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART4_M1 Switch iomux */
	set_uart_iomux_rx(4, 1);
	set_uart_iomux_tx(4, 1);
#endif
/* UART 5 */
#elif defined(CONFIG_DEBUG_UART_BASE) && (CONFIG_DEBUG_UART_BASE == 0xff4f0000)
#if defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 0)

	/* UART5_M0 Switch iomux */
	set_uart_iomux_rx(5, 0);
	set_uart_iomux_tx(5, 0);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 1)

	/* UART5_M1 Switch iomux */
	set_uart_iomux_rx(5, 1);
	set_uart_iomux_tx(5, 1);
#elif defined(CONFIG_ROCKCHIP_UART_MUX_SEL_M) && \
	(CONFIG_ROCKCHIP_UART_MUX_SEL_M == 2)

	/* UART5_M2 Switch iomux */
	set_uart_iomux_rx(5, 2);
	set_uart_iomux_tx(5, 2);
#endif
#endif
}

int arch_cpu_init(void)
{
#ifdef CONFIG_SPL_BUILD
	/* Set all devices to Non-secure */
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON0);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON1);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON2);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON3);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON4);
	writel(0x000f0000, PERI_SGRF_BASE + PERI_SGRF_SOC_CON3);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON0);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON1);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON2);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON3);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON4);
	writel(0x00030002, CORE_SGRF_BASE + CORE_SGRF_CPU_CTRL_CON);
	writel(0x20000000, PMU_SGRF_BASE);

	/* Set the emmc to access secure area */
	writel(0xffff0000, FW_DDR_BASE + FW_DDR_MST3_REG);
	writel(0xff00ffff, FW_SHRM_BASE + FW_SHRM_MST1_REG);
#endif
	return 0;
}

#ifdef CONFIG_ROCKCHIP_IMAGE_TINY
	/* Set sdmmc0 iomux */
	writel(0xfff01110, GPIO3_IOC_BASE + GPIO3A_IOMUX_SEL_L);
	writel(0xffff1111, GPIO3_IOC_BASE + GPIO3A_IOMUX_SEL_H);
#endif

#ifdef CONFIG_SPL_BUILD
int spl_fit_standalone_release(char *id, uintptr_t entry_point)
{
	/* Reset the hp mcu */
	writel(0x1e001e, CORECRU_BASE + CORECRU_CORESOFTRST_CON01);
	/* set the mcu addr */
	writel(entry_point, CORE_SGRF_BASE + CORE_SGRF_HPMCU_BOOT_ADDR);
	/* release the mcu */
	writel(0x1e0000, CORECRU_BASE + CORECRU_CORESOFTRST_CON01);

	return 0;
}
#endif
