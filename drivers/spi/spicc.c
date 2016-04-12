#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/clock.h>
#include <spi.h>
#include <malloc.h>
#include "spicc.h"

/**
 * struct spicc
 * @spi_slave: spi device on working.
 * @regs: the start register address of this SPICC controller.
 */
struct spicc {
	void __iomem *regs;
	int bits_per_word;
	int mode;
	int speed;
	struct spi_slave slave;
};

#define bits_desc(reg_offset, bits_offset, bits_len) \
	(((bits_len)<<24)|((bits_offset)<<16)|(reg_offset))
#define of_mem_offset(bd) ((bd)&0xffff)
#define of_bits_offset(bd) (((bd)>>16)&0xff)
#define of_bits_len(bd) (((bd)>>24)&0xff)

static void setb(
		void __iomem *mem_base,
		unsigned int bits_desc,
		unsigned int bits_val)
{
	unsigned int mem_offset, val;
	unsigned int bits_offset, bits_mask;

	mem_offset = of_mem_offset(bits_desc);
	bits_offset = of_bits_offset(bits_desc);
	bits_mask = (1L<<of_bits_len(bits_desc))-1;
	val = readl(mem_base+mem_offset);
	val &= ~(bits_mask << bits_offset);
	val |= (bits_val & bits_mask) << bits_offset;
	writel(val, mem_base+mem_offset);
}

static unsigned int getb(
		void __iomem *mem_base,
		unsigned int bits_desc)
{
	unsigned int mem_offset, val;
	unsigned int bits_offset, bits_mask;

	mem_offset = of_mem_offset(bits_desc);
	bits_offset = of_bits_offset(bits_desc);
	bits_mask = (1L<<of_bits_len(bits_desc))-1;
	val = readl(mem_base+mem_offset);
	return (val >> bits_offset) & bits_mask;
}

static inline void spicc_set_bit_width(struct spicc *spicc, u8 bw)
{
	setb(spicc->regs, CON_BITS_PER_WORD, bw-1);
	spicc->bits_per_word = bw;
}

static void spicc_set_mode(struct spicc *spicc, u8 mode)
{
	bool cpol = (mode & SPI_CPOL) ? 1:0;
	bool cpha = (mode & SPI_CPHA) ? 1:0;

	spicc->mode = mode;
	if (cpol) {
		//pullup GPIOH_7, GPIOH_8
		setbits_le32(P_PAD_PULL_UP_REG1, ((1<<28)|(1<<27)));
		setbits_le32(P_PAD_PULL_UP_EN_REG1, ((1<<28)|(1<<27)));
	}
	else {
		//pulldown GPIOH_7, GPIOH_8
		clrbits_le32(P_PAD_PULL_UP_REG1, ((1<<28)|(1<<27)));
		setbits_le32(P_PAD_PULL_UP_EN_REG1, ((1<<28)|(1<<27)));
	}
	setb(spicc->regs, CON_CLK_PHA, cpha);
	setb(spicc->regs, CON_CLK_POL, cpol);
	setb(spicc->regs, CON_DRCTL, 0);
}

static void spicc_set_clk(struct spicc *spicc, int speed)
{
	unsigned sys_clk_rate;
	unsigned div, mid_speed;

	if (!speed)
		return;

	spicc->speed = speed;
	sys_clk_rate = get_clk81();

	/* actually, speed = sys_clk_rate / 2^(conreg.data_rate_div+2) */
	mid_speed = (sys_clk_rate * 3) >> 4;
	for (div = 0; div < 7; div++) {
		if (speed >= mid_speed)
			break;
		mid_speed >>= 1;
	}
	printf("spicc: sys_clk=%d, div=%d\n", sys_clk_rate, div);
	setb(spicc->regs, CON_DATA_RATE_DIV, div);
}

static inline void spicc_set_txfifo(struct spicc *spicc, u32 dat)
{
	writel(dat, spicc->regs + SPICC_REG_TXDATA);
}

static inline u32 spicc_get_rxfifo(struct spicc *spicc)
{
	return readl(spicc->regs + SPICC_REG_RXDATA);
}

static inline void spicc_enable(struct spicc *spicc, bool en)
{
	setb(spicc->regs, CON_ENABLE, en);
}

static int spicc_wait_complete(struct spicc *spicc, int max)
{
	void __iomem *mem_base = spicc->regs;
	int i;

	for (i = 0; i < max; i++) {
		if (getb(mem_base, STA_RX_READY))
			return 0;
	}
	printf("spicc: timeout error\n");
	return -1;
}

static int spicc_hw_xfer(struct spicc *spicc, u8 *txp, u8 *rxp, int len)
{
	int num, i, j, bytes;
	unsigned int dat;

	bytes = ((spicc->bits_per_word - 1)>>3) + 1;
	len /= bytes;

	while (len > 0) {
		num = (len > SPICC_FIFO_SIZE) ? SPICC_FIFO_SIZE : len;
		for (i = 0; i < num; i++) {
			dat = 0;
			if (txp) {
				for (j = 0; j < bytes; j++) {
					dat <<= 8;
					dat += *txp++;
				}
			}
			spicc_set_txfifo(spicc, dat);
			/* printk("txdata[%d] = 0x%x\n", i, dat); */
		}

		for (i = 0; i < num; i++) {
			if (spicc_wait_complete(spicc, 1000))
				return -1;
			dat = spicc_get_rxfifo(spicc);
			/* printk("rxdata[%d] = 0x%x\n", i, dat); */
			if (rxp) {
				for (j = 0; j < bytes; j++) {
					*rxp++ = dat & 0xff;
					dat >>= 8;
				}
			}
		}
		len -= num;
	}
	return 0;
}

static void spicc_hw_init(struct spicc *spicc)
{
	void __iomem *mem_base = spicc->regs;

	setb(mem_base, CLK_FREE_EN, 1);
	setb(mem_base, CON_MODE, 1); /* 0-slave, 1-master */
	setb(mem_base, CON_XCH, 0);
	setb(mem_base, CON_SMC, 1); /* 0-dma, 1-pio */
	setb(mem_base, CON_SS_CTL, 1);
}

static inline struct spicc *to_spicc(struct spi_slave *slave)
{
	return container_of(slave, struct spicc, slave);
}


/********************************************************
	General SPI interface
********************************************************/
void spicc_cs_activate(struct spi_slave *slave)
{
	clrbits_le32(P_PREG_PAD_GPIO1_O, (1<<29));
	clrbits_le32(P_PREG_PAD_GPIO1_EN_N, (1<<29));
}

void spicc_cs_deactivate(struct spi_slave *slave)
{
	setbits_le32(P_PREG_PAD_GPIO1_O, (1<<29));
	clrbits_le32(P_PREG_PAD_GPIO1_EN_N, (1<<29));
}

struct spi_slave *spicc_setup_slave(unsigned int bus, unsigned int cs,
			unsigned int max_hz, unsigned int mode)
{
	struct spicc *spicc;

	spicc = spi_alloc_slave(struct spicc, bus, cs);
	if (!spicc)
		return NULL;

	spicc->regs = (void __iomem *)0xc1108d80;
	spicc_hw_init(spicc);
	spicc_set_bit_width(spicc, 8);
	spicc_set_clk(spicc, max_hz);
	spicc_set_mode(spicc, mode);

	return &spicc->slave;
}

void spicc_free_slave(struct spi_slave *slave)
{
	struct spicc *spicc = to_spicc(slave);

	free(spicc);
}

int spicc_claim_bus(struct spi_slave *slave)
{
	struct spicc *spicc = to_spicc(slave);

	/* Enable the SPI hardware */
	setbits_le32(P_PERIPHS_PIN_MUX_7, 0x70000);
	clrbits_le32(P_PERIPHS_PIN_MUX_7, 0x7f400028);
	spicc_enable(spicc, 1);
	return 0;
}

void spicc_release_bus(struct spi_slave *slave)
{
	struct spicc *spicc = to_spicc(slave);

	/* Disable the SPI hardware */
	spicc_enable(spicc, 0);
	clrbits_le32(P_PERIPHS_PIN_MUX_7,0x70000);
}

int spicc_xfer(struct spi_slave *slave, unsigned int bitlen,
		const void *dout, void *din, unsigned long flags)
{
	struct spicc *spicc = to_spicc(slave);
	unsigned int len;

	if (bitlen == 0)
		/* Finish any previously submitted transfers */
		goto out;

	if (bitlen % 8) {
		/* Errors always terminate an ongoing transfer */
		flags |= SPI_XFER_END;
		goto out;
	}

	len = bitlen / 8;

	if (flags & SPI_XFER_BEGIN) {
		spicc_cs_activate(slave);
	}
	spicc_hw_xfer(spicc, (u8 *)dout, (u8 *)din, len);

out:
	if (flags & SPI_XFER_END)
		spicc_cs_deactivate(slave);

	return 0;
}
