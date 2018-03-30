/*
 * Amlogic Meson SPI communication controller(SPICC)
 *
 * Copyright (C) 2017 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 *
 */

#include <common.h>
#include <dm.h>
#include <asm/errno.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <asm/arch/secure_apb.h>
#include <spi.h>
#include <amlogic/spicc.h>
#include <dm/device-internal.h>
#include <dm/uclass-internal.h>
#include <dm/root.h>
#include <dm/lists.h>
#include <dm/util.h>

DECLARE_GLOBAL_DATA_PTR;

#ifndef BIT
#define BIT(nr)			(1UL << (nr))
#endif

#ifndef GENMASK
#define GENMASK(h, l) \
	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
#endif

#ifndef FIELD_PREP
#define FIELD_PREP(_mask, _val) \
	(((typeof(_mask))(_val) << (ffs(_mask) - 1)) & (_mask))
#endif

#ifndef FIELD_GET
#define FIELD_GET(_mask, _reg) \
	((typeof(_mask))(((_reg) & (_mask)) >> (ffs(_mask) - 1)))
#endif

#ifndef writel_bits
#define writel_bits(mask, val, addr) \
	writel((readl(addr) & ~(mask)) | (val), addr)
#endif

#define SPICC_DEFAULT_SPEED 3000000
#define SPICC_DEFAULT_MODE SPI_MODE_0
#define SPICC_DEFAULT_WORDLEN 8

#define SPICC_MAX_BURST	128
#define SPICC_FIFO_SIZE 16

/* Register Map */
#define SPICC_RXDATA	0x00

#define SPICC_TXDATA	0x04

#define SPICC_CONREG	0x08
#define SPICC_ENABLE		BIT(0)
#define SPICC_MODE_MASTER	BIT(1)
#define SPICC_XCH		BIT(2)
#define SPICC_SMC		BIT(3)
#define SPICC_POL		BIT(4)
#define SPICC_PHA		BIT(5)
#define SPICC_SSCTL		BIT(6)
#define SPICC_SSPOL		BIT(7)
#define SPICC_DRCTL_MASK	GENMASK(9, 8)
#define SPICC_DRCTL_IGNORE	0
#define SPICC_DRCTL_FALLING	1
#define SPICC_DRCTL_LOWLEVEL	2
#define SPICC_CS_MASK		GENMASK(13, 12)
#define SPICC_DATARATE_MASK	GENMASK(18, 16)
#define SPICC_DATARATE_DIV4	0
#define SPICC_DATARATE_DIV8	1
#define SPICC_DATARATE_DIV16	2
#define SPICC_DATARATE_DIV32	3
#define SPICC_BITLENGTH_MASK	GENMASK(24, 19)
#define SPICC_BURSTLENGTH_MASK	GENMASK(31, 25)

#define SPICC_INTREG	0x0c
#define SPICC_TE_EN	BIT(0) /* TX FIFO Empty Interrupt */
#define SPICC_TH_EN	BIT(1) /* TX FIFO Half-Full Interrupt */
#define SPICC_TF_EN	BIT(2) /* TX FIFO Full Interrupt */
#define SPICC_RR_EN	BIT(3) /* RX FIFO Ready Interrupt */
#define SPICC_RH_EN	BIT(4) /* RX FIFO Half-Full Interrupt */
#define SPICC_RF_EN	BIT(5) /* RX FIFO Full Interrupt */
#define SPICC_RO_EN	BIT(6) /* RX FIFO Overflow Interrupt */
#define SPICC_TC_EN	BIT(7) /* Transfert Complete Interrupt */

#define SPICC_DMAREG	0x10
#define SPICC_DMA_ENABLE		BIT(0)
#define SPICC_TXFIFO_THRESHOLD_MASK	GENMASK(5, 1)
#define SPICC_RXFIFO_THRESHOLD_MASK	GENMASK(10, 6)
#define SPICC_READ_BURST_MASK		GENMASK(14, 11)
#define SPICC_WRITE_BURST_MASK		GENMASK(18, 15)
#define SPICC_DMA_URGENT		BIT(19)
#define SPICC_DMA_THREADID_MASK		GENMASK(25, 20)
#define SPICC_DMA_BURSTNUM_MASK		GENMASK(31, 26)

#define SPICC_STATREG	0x14
#define SPICC_TE	BIT(0) /* TX FIFO Empty Interrupt */
#define SPICC_TH	BIT(1) /* TX FIFO Half-Full Interrupt */
#define SPICC_TF	BIT(2) /* TX FIFO Full Interrupt */
#define SPICC_RR	BIT(3) /* RX FIFO Ready Interrupt */
#define SPICC_RH	BIT(4) /* RX FIFO Half-Full Interrupt */
#define SPICC_RF	BIT(5) /* RX FIFO Full Interrupt */
#define SPICC_RO	BIT(6) /* RX FIFO Overflow Interrupt */
#define SPICC_TC	BIT(7) /* Transfert Complete Interrupt */

#define SPICC_PERIODREG	0x18
#define SPICC_PERIOD	GENMASK(14, 0)	/* Wait cycles */

#define SPICC_TESTREG	0x1c
#define SPICC_TXCNT_MASK	GENMASK(4, 0)	/* TX FIFO Counter */
#define SPICC_RXCNT_MASK	GENMASK(9, 5)	/* RX FIFO Counter */
#define SPICC_SMSTATUS_MASK	GENMASK(12, 10)	/* State Machine Status */
#define SPICC_LBC		BIT(14) /* Loop Back Control */
#define SPICC_SWAP		BIT(15) /* RX FIFO Data Swap */
#define SPICC_DLYCTL_MASK	GENMASK(21, 16) /* Delay Control */
#define SPICC_MO_DELAY_MASK	GENMASK(17, 16)
#define SPICC_MI_DELAY_MASK	GENMASK(17, 16)
#define SPICC_MI_CAPTURE_DELAY_MASK GENMASK(17, 16)

#define SPICC_TXFIFO_RST	BIT(22) /* TX FIFO Softreset */
#define SPICC_RXFIFO_RST	BIT(23) /* RX FIFO Softreset */

#define SPICC_DRADDR	0x20	/* Read Address of DMA */

#define SPICC_DWADDR	0x24	/* Write Address of DMA */

#define SPICC_ENH_CTL0	0x38	/* Enhanced Feature */
#define SPICC_ENH_CLK_CS_DELAY_MASK	GENMASK(15, 0)
#define SPICC_ENH_DATARATE_MASK		GENMASK(23, 16)
#define SPICC_ENH_DATARATE_EN		BIT(24)
#define SPICC_ENH_MOSI_OEN		BIT(25)
#define SPICC_ENH_CLK_OEN		BIT(26)
#define SPICC_ENH_CS_OEN		BIT(27)
#define SPICC_ENH_CLK_CS_DELAY_EN	BIT(28)
#define SPICC_ENH_MAIN_CLK_AO		BIT(29)

#define SPICC_ENH_CTL1	0x3c	/* Enhanced Feature */
#define SPICC_ENH_MI_CAPTURE_DELAY_EN	BIT(0)
#define SPICC_ENH_MI_CAPTURE_DELAY_MASK	GENMASK(9, 1)
#define SPICC_ENH_SI_CAPTURE_DELAY_EN	BIT(14)		/* slave mode */
#define SPICC_ENH_DELAY_EN		BIT(15)
#define SPICC_ENH_SI_DELAY_EN		BIT(16)		/* slave mode */
#define SPICC_ENH_SI_DELAY_MASK		GENMASK(19, 17)	/* slave mode */
#define SPICC_ENH_MI_DELAY_EN		BIT(20)
#define SPICC_ENH_MI_DELAY_MASK		GENMASK(23, 21)
#define SPICC_ENH_MO_DELAY_EN		BIT(24)
#define SPICC_ENH_MO_DELAY_MASK		GENMASK(27, 25)
#define SPICC_ENH_MO_OEN_DELAY_EN	BIT(28)
#define SPICC_ENH_MO_OEN_DELAY_MASK	GENMASK(31, 29)

#define SPICC_ENH_CTL2	0x40	/* Enhanced Feature */
#define SPICC_ENH_TI_DELAY_MASK		GENMASK(14, 0)
#define SPICC_ENH_TI_DELAY_EN		BIT(15)
#define SPICC_ENH_TT_DELAY_MASK		GENMASK(30, 16)
#define SPICC_ENH_TT_DELAY_EN		BIT(31)

#define SPICC_BURST_MAX	16
#define SPICC_FIFO_HALF 10

#define spicc_info(fmt, args...) \
	printf("[info]%s: " fmt, __func__, ## args)

#define spicc_err(fmt, args...) \
	printf("[error]%s: " fmt, __func__, ## args)

//#define SPICC_DEBUG_EN
#ifdef SPICC_DEBUG_EN
#define spicc_dbg(fmt, args...) \
	printf("[debug]%s: " fmt, __func__, ## args)
#else
#define spicc_dbg(fmt, args...)
#endif

/*
 * @is_enhance (start from TXL/TXLX)
 * - Clock data rate divider; (replacement)
 * - CLK/MOSI/SS output enable;
 * - clk-cs delay: time delay from SS falling edge to the first CLK edge.
 * @is_enhance_1 (start from AXG)
 * - CTS_SPICC_CLK for new delay control;
 * - MOSI output delay; (replacement)
 * - MISO input delay; (replacement)
 * - MISO capture delay. (replacement)
 * @is_parent_clk (start from TXHD)
 * - More clock source selections: xtal/clk81/div4/div3/div2/div5/div7.
 * @fix_reset (start from TXHD)
 * - Fix the traditional bug of disable-and-reset.
  * @is_enhance_2 (start from G12A)
 * - tt delay: trailing time from the last CLK edge to the SS rising edge.
 * - ti delay: idling time between transfers.
 */
struct meson_spicc_data {
	unsigned int			max_speed_hz;
	bool				is_enhance;
	bool				is_enhance_1;
	bool				is_parent_clk;
	bool				is_enhance_2;
};

struct meson_spicc_device {
	void __iomem			*base;
	const struct meson_spicc_data	*data;
	int				num_chipselect;
	int				cs_gpios[CS_GPIO_MAX];
	unsigned int			speed;
	unsigned int			mode;
	unsigned int			wordlen;
	int				bytes_per_word;
	int				bit_offset;
	int				remain;
	const u8			*txp;
	u8				*rxp;
	int				burst_len;
};


static void spicc_main_clk_ao(struct meson_spicc_device *spicc, bool on)
{
	u32 regv;

	if (spicc->data->is_enhance) {
		regv = readl(spicc->base + SPICC_ENH_CTL0);
		if (on)
			regv |= SPICC_ENH_MAIN_CLK_AO;
		else
			regv &= ~SPICC_ENH_MAIN_CLK_AO;
		writel(regv, spicc->base + SPICC_ENH_CTL0);
	}
}

static void spicc_set_cs_delay(
		struct meson_spicc_device *spicc,
		int clk_cs_delay,
		int tt_delay,
		int ti_delay)
{
	u32 regv;

	if (spicc->data->is_enhance) {
		regv = readl(spicc->base + SPICC_ENH_CTL0);
		regv |= SPICC_ENH_MOSI_OEN |
			SPICC_ENH_CLK_OEN | SPICC_ENH_CS_OEN;
		regv &= ~(SPICC_ENH_CLK_CS_DELAY_EN
			| SPICC_ENH_CLK_CS_DELAY_MASK);
		if (clk_cs_delay) {
			regv |= SPICC_ENH_CLK_CS_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_CLK_CS_DELAY_MASK,
				clk_cs_delay);
		}
		writel(regv, spicc->base + SPICC_ENH_CTL0);
	}

	if (spicc->data->is_enhance_2) {
		regv = 0;
		if (tt_delay) {
			regv |= SPICC_ENH_TT_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_TT_DELAY_MASK, tt_delay);
		}
		if (ti_delay) {
			regv |= SPICC_ENH_TI_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_TI_DELAY_MASK, ti_delay);
		}
		writel(regv, spicc->base + SPICC_ENH_CTL2);
	}
}

static void spicc_set_io_delay(
		struct meson_spicc_device *spicc,
		int mo_delay,
		int mi_delay,
		int mi_capture_delay)
{
	u32 regv;

	if (spicc->data->is_enhance_1) {
		regv = readl(spicc->base + SPICC_ENH_CTL1);
		regv &= ~(SPICC_ENH_MO_DELAY_EN | SPICC_ENH_MO_DELAY_MASK);
		if (mo_delay) {
			regv |= SPICC_ENH_MO_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_MO_DELAY_MASK, mo_delay);
		}
		regv &= ~(SPICC_ENH_MI_DELAY_EN | SPICC_ENH_MI_DELAY_MASK);
		if (mi_delay) {
			regv |= SPICC_ENH_MI_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_MI_DELAY_MASK, mi_delay);
		}
		regv &= ~(SPICC_ENH_MI_CAPTURE_DELAY_EN
			| SPICC_ENH_MI_CAPTURE_DELAY_MASK);
		if (mi_capture_delay) {
			regv |= SPICC_ENH_MI_CAPTURE_DELAY_EN;
			regv |= FIELD_PREP(SPICC_ENH_MI_CAPTURE_DELAY_MASK,
				mi_capture_delay);
		}
		if (regv)
			regv |= SPICC_ENH_DELAY_EN;
		writel(regv, spicc->base + SPICC_ENH_CTL1);
	}
	else {
		/* TBD */
	}
}

static void spicc_reset_fifo(struct meson_spicc_device *spicc)
{
	u32 regv;

	regv = readl(spicc->base + SPICC_TESTREG);
	regv |= SPICC_TXFIFO_RST | SPICC_RXFIFO_RST;
	writel(regv, spicc->base + SPICC_TESTREG);

	udelay(1);
	while (FIELD_GET(SPICC_RH | SPICC_RR | SPICC_RF,
			readl(spicc->base + SPICC_STATREG)))
		regv = readl(spicc->base + SPICC_RXDATA);
}

static int spicc_wait_complete(struct meson_spicc_device *spicc, int us)
{
	u32 regv;

	while (us--) {
		regv = readl(spicc->base + SPICC_STATREG);
		if (regv & SPICC_TC) {
			/* set 1 to clear */
			regv |= SPICC_TC;
			writel(regv, spicc->base + SPICC_STATREG);
			return 0;
		}
		udelay(1);
	}
	return -ETIME;
}

static void spicc_pull_data(struct meson_spicc_device *spicc)
{
	int bytes = spicc->bytes_per_word;
	unsigned int dat = 0;
	int i;

	if (spicc->txp) {
		if (spicc->mode & SPI_LSB_FIRST)
			for (i = 0; i < bytes; i++) {
				dat <<= 8;
				dat += *spicc->txp++;
			}
		else
			for (i = 0; i < bytes; i++) {
				dat |= *spicc->txp << (i << 3);
				spicc->txp++;
			}
	}

	dat >>= spicc->bit_offset;
	writel(dat, spicc->base + SPICC_TXDATA);
}

static void spicc_pio_burst_send(struct meson_spicc_device *spicc)
{
	u32 regv;
	int i;

	if (spicc->remain <= 0)
		return;

	spicc->burst_len = min_t(size_t, spicc->remain, SPICC_FIFO_SIZE);
	for (i = 0; i < spicc->burst_len; i++)
		spicc_pull_data(spicc);

	regv = readl(spicc->base + SPICC_CONREG);
	regv &= ~SPICC_BURSTLENGTH_MASK;
	regv |= FIELD_PREP(SPICC_BURSTLENGTH_MASK, spicc->burst_len - 1);
	regv |= SPICC_XCH;
	writel(regv, spicc->base + SPICC_CONREG);
}

static void spicc_push_data(struct meson_spicc_device *spicc)
{
	int bytes = spicc->bytes_per_word;
	int i;
	u32 dat;

	dat = readl(spicc->base + SPICC_RXDATA);
	if (!spicc->rxp)
		return;

	dat <<= spicc->bit_offset;
	if (spicc->mode & SPI_LSB_FIRST)
		for (i = 0; i < bytes; i++)
			*spicc->rxp++ = dat >> ((bytes - i - 1) << 3);
	else
		for (i = 0; i < bytes; i++) {
			*spicc->rxp++ = dat & 0xff;
			dat >>= 8;
		}
}

static void spicc_pio_burst_recv(struct meson_spicc_device *spicc)
{
	int i;

	for (i = 0; i < spicc->burst_len; i++)
		spicc_push_data(spicc);
	spicc->remain -= spicc->burst_len;
}

static int spicc_cs_gpio_init(
			struct meson_spicc_device *spicc,
			struct spicc_platdata *plat)
{
	const char *name;
	int gpio;
	int i, ret = 0;

	spicc->num_chipselect = 0;
	for (i=0; i<CS_GPIO_MAX; i++)
		spicc->cs_gpios[i] = -1;

	for (i=0; i<CS_GPIO_MAX; i++) {
		name = plat->cs_gpio_names[i];
		if (!name)
			break;
		else if (!strcmp(name, "no_cs")) {
			spicc->num_chipselect++;
			spicc_info("cs_gpio[%d]=no cs\n", i);
			break;
		}
		else {
#ifdef CONFIG_DM_GPIO
			ret = gpio_lookup_name(name, NULL, NULL,
					(unsigned int *)&gpio);
#else
			gpio = name_to_gpio(name);
#endif
			if (ret || (gpio < 0))
				return -EINVAL;

			if (gpio_request(gpio, "spicc_cs"))
				return -ENODEV;

			/* Usually, cs should be pulled up or down by
			 * resistor on board according to its cs-mode.
			 */
			gpio_direction_input(gpio);

			spicc->cs_gpios[i] = gpio;
			spicc->num_chipselect++;
			spicc_info("cs_gpio[%d]=%d\n", i, gpio);
		}
	}

	spicc_info("total (%d) slaves\n", spicc->num_chipselect);
	return spicc->num_chipselect ? 0 : -ENODEV;
}

static void spicc_chipselect(struct spi_slave *slave, bool select)
{
	struct meson_spicc_device *spicc;
	bool level = slave->mode & SPI_CS_HIGH;
	int cs_gpio;

	spicc = dev_get_priv(slave->dev->parent);

	if (slave->cs >= spicc->num_chipselect) {
		spicc_err("cs %d over\n", slave->cs);
		return;
	}
	if (!select)
		level = !level;

	cs_gpio = spicc->cs_gpios[slave->cs];
	if (cs_gpio >= 0) {
		gpio_direction_output(cs_gpio, level);
		spicc_dbg("set gpio_%d %d\n", cs_gpio, level);
	}
}

/* Compatibility function - to be removed */
void spi_cs_activate(struct spi_slave *slave)
{
	spicc_chipselect(slave, 1);
}

/* Compatibility function - to be removed */
void spi_cs_deactivate(struct spi_slave *slave)
{
	spicc_chipselect(slave, 0);
}

static int spicc_claim_bus(struct udevice *bus)
{
	return 0;
}

static int spicc_release_bus(struct udevice *bus)
{
	return 0;
}

static int spicc_set_speed(struct udevice *bus, uint hz)
{
	struct spicc_platdata *plat = dev_get_platdata(bus);
	struct meson_spicc_device *spicc = dev_get_priv(bus);
	u32 sys_clk_rate, div, mid;
	u32 regv;

	if (!hz || (hz == spicc->speed))
		return 0;
	spicc_dbg("to set speed %d\n", hz);
	spicc->speed = hz;

	sys_clk_rate = plat->clk_rate;
	if (spicc->data->is_enhance) {
		/* speed = sys_clk_rate / 2 / (div+1) */
		div = sys_clk_rate/hz;
		if (div < 2)
			div = 2;
		div = (div >> 1) - 1;
		if (div > 0xff)
			div = 0xff;
		regv = readl(spicc->base + SPICC_ENH_CTL0);
		regv &= ~SPICC_ENH_DATARATE_MASK;
		regv |= FIELD_PREP(SPICC_ENH_DATARATE_MASK, div);
		regv |= SPICC_ENH_DATARATE_EN;
		writel(regv, spicc->base + SPICC_ENH_CTL0);
		spicc_dbg("enhance div=%d\n", div);
	} else {
		/* speed = sys_clk_rate / 2^(div+2) */
		mid = (sys_clk_rate * 3) >> 4;
		for (div = 0; div < 7; div++) {
			if (hz >= mid)
				break;
			mid >>= 1;
		}
		regv = readl(spicc->base + SPICC_CONREG);
		regv &= ~SPICC_DATARATE_MASK;
		regv |= FIELD_PREP(SPICC_DATARATE_MASK, div);
		writel(regv, spicc->base + SPICC_CONREG);
		spicc_dbg("old div=%d\n", div);
	}
	return 0;
}

static int spicc_set_mode(struct udevice *bus, uint mode)
{
	struct meson_spicc_device *spicc = dev_get_priv(bus);
	u32 regv;

	if (mode == spicc->mode)
		return 0;
	spicc_dbg("to set mode 0x%x\n", mode);
	spicc->mode = mode;

	spicc_main_clk_ao(spicc, 1);
	regv = readl(spicc->base + SPICC_CONREG);

	if (mode & SPI_CPOL)
		regv |= SPICC_POL;
	else
		regv &= ~SPICC_POL;

	if (mode & SPI_CPHA)
		regv |= SPICC_PHA;
	else
		regv &= ~SPICC_PHA;

	if (mode & SPI_CS_HIGH)
		regv |= SPICC_SSPOL;
	else
		regv &= ~SPICC_SSPOL;

	writel(regv, spicc->base + SPICC_CONREG);

	/* Setup loopback */
	regv = readl(spicc->base + SPICC_TESTREG);

	if (mode & SPI_LOOP)
		regv |= SPICC_LBC;
	else
		regv &= ~SPICC_LBC;

	writel(regv, spicc->base + SPICC_TESTREG);
	spicc_main_clk_ao(spicc, 0);
	return 0;
}

static int spicc_set_wordlen(struct udevice *bus, uint wordlen)
{
	struct meson_spicc_device *spicc = dev_get_priv(bus);
	u32 regv;

	if (wordlen == spicc->wordlen)
		return 0;
	spicc_dbg("to set word width %d\n", wordlen);
	spicc->wordlen = wordlen;
	if (wordlen <= 8)
		spicc->bytes_per_word = 1;
	else if (wordlen <= 16)
		spicc->bytes_per_word = 2;
	else if (wordlen <= 32)
		spicc->bytes_per_word = 4;
	else
		spicc->bytes_per_word = 8;
	spicc->bit_offset = (spicc->bytes_per_word << 3) - wordlen;

	regv = readl(spicc->base + SPICC_CONREG);
	regv &= ~SPICC_BITLENGTH_MASK;
	regv |= FIELD_PREP(SPICC_BITLENGTH_MASK, wordlen - 1);
	writel(regv, spicc->base + SPICC_CONREG);
	return 0;
}

static int spicc_xfer(
		struct udevice *dev,
		unsigned int bitlen,
		const void *dout,
		void *din,
		unsigned long flags)
{
	struct udevice *bus = dev->parent;
	struct spi_slave *slave = dev_get_parentdata(dev);
	struct meson_spicc_device *spicc = dev_get_priv(bus);
	int ret = 0;

	spicc_dbg("slave %u:%u bitlen %u\n", bus->seq,
			spi_chip_select(dev), bitlen);

	spicc_set_wordlen(bus, slave->wordlen);
	if (bitlen % spicc->wordlen) {
		spicc_err("bitlen %d %d\n", bitlen, spicc->wordlen);
		return -EINVAL;
	}

	spicc_reset_fifo(spicc);
	spicc->remain = bitlen / spicc->wordlen;
	spicc->txp = (const u8 *)dout;
	spicc->rxp = (u8 *)din;

	if (flags & SPI_XFER_BEGIN)
		spicc_chipselect(slave, 1);

	while (spicc->remain) {
		spicc_pio_burst_send(spicc);
		ret = spicc_wait_complete(spicc, spicc->burst_len << 8);
		if (ret) {
			spicc_err("time expire\n");
			break;
		}
		spicc_pio_burst_recv(spicc);
	}

	if (ret || flags & SPI_XFER_END)
		spicc_chipselect(slave, 0);

	return ret;
}

#ifndef CONFIG_OF_CONTROL
static int spicc_check_compatible(struct udevice *bus, char *compatible)
{
	const struct udevice_id *of_match = bus->driver->of_match;

	while (of_match->compatible) {
		if (!strcmp(compatible, of_match->compatible)) {
			bus->of_id = of_match;
			return 0;
		}
		of_match++;
	}
	return -ENODEV;
}
#endif

static int spicc_probe(struct udevice *bus)
{
	struct spicc_platdata *plat = dev_get_platdata(bus);
	struct meson_spicc_device *spicc = dev_get_priv(bus);
	int ret = 0;

#ifndef CONFIG_OF_CONTROL
	ret = spicc_check_compatible(bus, plat->compatible);
	if (ret) {
		spicc_err("compatible match failed\n");
		return ret;
	}
#endif
	spicc->data = (struct meson_spicc_data *)dev_get_of_data(bus);
	spicc->base = plat->reg;
	spicc_info("%s @%p\n", plat->compatible, (void *)plat->reg);

	ret = spicc_cs_gpio_init(spicc, plat);
	if (ret) {
		spicc_err("lookup/request gpio failed(%d)\n", ret);
		return ret;
	}

#ifdef CONFIG_OF_CONTROL
	/* pinctrl and clk, TBD */
#else
	if (spicc->data->is_parent_clk && plat->clk_set_rate)
		plat->clk_set_rate(plat->clk_rate);

	if (plat->clk_enable)
		plat->clk_enable(1);

	if (plat->pinctrl_enable)
		plat->pinctrl_enable(1);
#endif

	/* Set master mode and enable controller */
	writel(SPICC_ENABLE | SPICC_MODE_MASTER, spicc->base + SPICC_CONREG);

	/* Disable all IRQs */
	writel(0, spicc->base + SPICC_INTREG);

	spicc_set_cs_delay(spicc, plat->clk_cs_delay,
			plat->tt_delay, plat->ti_delay);

	spicc_set_io_delay(spicc, plat->mo_delay,
			plat->mi_delay, plat->mi_capture_delay);

	spicc_set_speed(bus, SPICC_DEFAULT_SPEED);
	spicc_set_mode(bus, SPICC_DEFAULT_MODE);
	spicc_set_wordlen(bus, SPICC_DEFAULT_WORDLEN);

	return 0;
}

#ifdef CONFIG_OF_CONTROL
static int spicc_ofdata_to_platdata(struct udevice *bus)
{
	struct spicc_platdata *plat = dev_get_platdata(bus);
	const void *blob = gd->fdt_blob;
	int node = bus->of_offset;

	plat->reg = fdtdec_get_addr(blob, node, "reg");
	spicc_info("reg=%p\n", (void *)plat->reg);
	return 0;
}
#endif

/* for m6/m8/gxbb/gxl/gxm/gxtvbb */
static const struct meson_spicc_data meson_spicc_gx_data = {
	.max_speed_hz	= 30000000,
	.is_enhance	= false,
	.is_enhance_1	= false,
	.is_parent_clk	= false,
	.is_enhance_2	= false,
};

/* for txl/txlx */
static const struct meson_spicc_data meson_spicc_txl_data = {
	.max_speed_hz	= 80000000,
	.is_enhance	= true,
	.is_enhance_1	= false,
	.is_parent_clk	= false,
	.is_enhance_2	= false,
};

/* for axg */
static const struct meson_spicc_data meson_spicc_axg_data = {
	.max_speed_hz	= 80000000,
	.is_enhance	= true,
	.is_enhance_1	= true,
	.is_parent_clk	= false,
	.is_enhance_2	= false,
};

/* for txhd */
static const struct meson_spicc_data meson_spicc_txhd_data = {
	.max_speed_hz	= 80000000,
	.is_enhance	= true,
	.is_enhance_1	= true,
	.is_parent_clk	 = true,
	.is_enhance_2	= false,
};

/* for g12a */
static const struct meson_spicc_data meson_spicc_g12a_data = {
	.max_speed_hz	= 80000000,
	.is_enhance	= true,
	.is_enhance_1	= true,
	.is_parent_clk	 = true,
	.is_enhance_2	= true,
};

static const struct udevice_id meson_spicc_of_match[] = {
	{
		.compatible	= "amlogic,meson-gx-spicc",
		.data		= (unsigned long)&meson_spicc_gx_data,
	},
	{
		.compatible	= "amlogic,meson-txl-spicc",
		.data		= (unsigned long)&meson_spicc_txl_data,
	},
	{
		.compatible	= "amlogic,meson-axg-spicc",
		.data		= (unsigned long)&meson_spicc_axg_data,
	},
	{
		.compatible	= "amlogic,meson-txhd-spicc",
		.data		= (unsigned long)&meson_spicc_txhd_data,
	},
	{
		.compatible	= "amlogic,meson-g12a-spicc",
		.data		= (unsigned long)&meson_spicc_g12a_data,
	},
	{ /* sentinel */ }
};

static const struct dm_spi_ops spicc_ops = {
	.claim_bus = spicc_claim_bus,
	.release_bus = spicc_release_bus,
	.xfer = spicc_xfer,
	.set_speed = spicc_set_speed,
	.set_mode = spicc_set_mode,
	.set_wordlen = spicc_set_wordlen,
};

U_BOOT_DRIVER(spicc) = {
	.name = "spicc",
	.id = UCLASS_SPI,
	.of_match = meson_spicc_of_match,
#ifdef CONFIG_OF_CONTROL
	.ofdata_to_platdata = spicc_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct spicc_platdata),
#endif
	.priv_auto_alloc_size = sizeof(struct meson_spicc_device),
	.per_child_auto_alloc_size = sizeof(struct spi_slave),
	.ops= &spicc_ops,
	.probe = spicc_probe,
};
