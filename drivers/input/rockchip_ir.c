/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <clk.h>
#include <common.h>
#include <dm.h>
#include <dm/pinctrl.h>
#include <errno.h>
#include <rc.h>
#include <rockchip_ir.h>
#include <irq-generic.h>
#include <irq-platform.h>

#include <linux/bitrev.h>
#include <linux/input.h>

#include <asm/arch/periph.h>
#include <asm/io.h>

DECLARE_GLOBAL_DATA_PTR;

static struct nec_dec nec;
static struct rc_map *rc_map;

static int rockchip_ir_get_keycode(struct udevice *dev)
{
	struct rockchip_ir_priv *priv = dev_get_priv(dev);

	return priv->keycode;
}

static int rockchip_ir_get_repeat(struct udevice *dev)
{
	struct rockchip_ir_priv *priv = dev_get_priv(dev);

	return priv->repeat;
}

static int ir_lookup_by_scancode(struct rockchip_ir_priv *priv,
				 u32 usercode,
				 u32 scancode)
{
	int i, j;

	for (i = 0; i < priv->num; i++) {
		if (rc_map[i].usercode == usercode)
			break;
	}
	for (j = 0; i < priv->num && j < rc_map[i].nbuttons; j++) {
		if (rc_map[i].scan[j].scancode == scancode) {
			if (priv->keycode == rc_map[i].scan[j].keycode)
				priv->repeat++;
			else
				priv->repeat = 0;
			priv->keycode = rc_map[i].scan[j].keycode;
			return 0;
		}
	}

	priv->keycode = KEY_RESERVED;
	priv->repeat = 0;

	return -1;
}

static int ir_parse_keys(struct udevice *dev)
{
	int i, j;
	int len;
	int ret;
	int subnode;
	int node = dev_of_offset(dev);
	const void *blob = gd->fdt_blob;

	i = 0;
	fdt_for_each_subnode(subnode, blob, node) {
		rc_map[i].usercode = fdtdec_get_uint(blob, subnode,
						     "rockchip,usercode",
						     1234u);
		if (rc_map[i].usercode == 1234u) {
			debug("missing usercode property in the dts\n");
			return -1;
		}
		debug("add new usercode:0x%x\n", rc_map[i].usercode);
		fdt_get_property(blob, subnode, "rockchip,key_table", &len);
		len /= sizeof(u32);
		debug("len:%d\n", len);
		rc_map[i].nbuttons = len / 2;
		ret = fdtdec_get_int_array(blob, subnode, "rockchip,key_table",
					   (u32 *)rc_map[i].scan, len);
		if (ret) {
			debug("missing key_table property in the dts\n");
			return -1;
		}
		for (j = 0; j < (len / 2); j++) {
			debug("[%d],usercode=0x%x scancode=0x%x keycode=0x%x\n",
			      i,
			      rc_map[i].usercode,
			      rc_map[i].scan[j].scancode,
			      rc_map[i].scan[j].keycode);
		}
		i++;
	}

	return 0;
}

/**
 * ir_nec_decode() - Decode one NEC pulse or space
 * @duration:   the struct ir_raw_event descriptor of the pulse/space
 */
static int ir_nec_decode(struct rockchip_ir_priv *priv, struct ir_raw_event *ev)
{
	int ret;
	u32 usercode;
	u32 scancode;
	u8 __maybe_unused address, not_address, command, not_command;
	struct nec_dec *data = &nec;

	debug("NEC decode started at state %d (%uus %s)\n",
	      data->state, TO_US(ev->duration), TO_STR(ev->pulse));

	switch (data->state) {
	case STATE_INACTIVE:
		if (!ev->pulse)
			break;

		if (!eq_margin(ev->duration, NEC_HEADER_PULSE, NEC_UNIT * 2))
			break;

		data->count = 0;
		data->state = STATE_HEADER_SPACE;
		return 0;

	case STATE_HEADER_SPACE:
		if (ev->pulse)
			break;

		if (eq_margin(ev->duration, NEC_HEADER_SPACE, NEC_UNIT)) {
			data->state = STATE_BIT_PULSE;
			return 0;
		}

		break;

	case STATE_BIT_PULSE:
		if (!ev->pulse)
			break;

		if (!eq_margin(ev->duration, NEC_BIT_PULSE, NEC_UNIT / 2))
			break;

		data->state = STATE_BIT_SPACE;
		return 0;

	case STATE_BIT_SPACE:
		if (ev->pulse)
			break;

		data->bits <<= 1;
		if (eq_margin(ev->duration, NEC_BIT_1_SPACE, NEC_UNIT / 2))
			data->bits |= 1;
		else if (!eq_margin(ev->duration, NEC_BIT_0_SPACE,
				    NEC_UNIT / 2))
			break;
		data->count++;

		if (data->count == NEC_NBITS) {
			address     = ((data->bits >> 24) & 0xff);
			not_address = ((data->bits >> 16) & 0xff);
			command	    = ((data->bits >>  8) & 0xff);
			not_command = ((data->bits >>  0) & 0xff);

			if ((command ^ not_command) != 0xff) {
				debug("NEC checksum error: received 0x%08x\n",
				      data->bits);
			}
			usercode = address << 8 | not_address;
			scancode = command << 8 | not_command;
			debug("raw usercode 0x%04x scancode 0x%04x\n",
			      usercode, scancode);
			/* change to dts format */
			usercode = bitrev16(usercode);
			scancode = (bitrev16(scancode) >> 8) & 0xFF;

			data->state = STATE_INACTIVE;
			ret = ir_lookup_by_scancode(priv, usercode, scancode);
			if (!ret)
				debug("keycode 0x%02x repeat 0x%x\n",
				      priv->keycode, priv->repeat);
			else
				debug("ir lookup by scancode failed\n");
		} else {
			data->state = STATE_BIT_PULSE;
		}

		return 0;
	}

	debug("NEC decode failed at count %d state %d (%uus %s)\n",
	      data->count, data->state, TO_US(ev->duration), TO_STR(ev->pulse));
	data->state = STATE_INACTIVE;

	return -1;
}

static void rockchip_ir_irq(int irq, void *data)
{
	u32 val;
	u32 cycle_hpr, cycle_lpr, cycle;
	struct ir_raw_event ev;
	struct rockchip_ir_priv *priv = (struct rockchip_ir_priv *)data;

	val = readl(priv->base + PWM_STA_REG(priv->id));
	cycle_hpr = readl(priv->base + PWM_HPR_REG);
	cycle_lpr = readl(priv->base + PWM_LPR_REG);
	if (val & PWM_CH_POL(priv->id)) {
		cycle = cycle_hpr;
		ev.pulse = 0;
	} else {
		cycle = cycle_lpr;
		ev.pulse = 1;
	}
	writel(PWM_CH_INT(priv->id),
	       priv->base + PWM_STA_REG(priv->id));
	ev.duration = cycle * priv->period;
	ir_nec_decode(priv, &ev);
}

static void rockchip_ir_hw_init(struct udevice *dev)
{
	unsigned long tmp;
	struct rockchip_ir_priv *priv = dev_get_priv(dev);

	/* Enable capture mode, non-scaled clock, prescale 1 */
	writel(REG_CTL_MD, priv->base + PWM_CTL_REG);

	/* Clear Interrupt Status */
	writel(PWM_CH_INT(priv->id),
	       priv->base + PWM_STA_REG(priv->id));

	/* Enable IRQ */
	writel(PWM_CH_INT(priv->id),
	       priv->base + PWM_INT_REG(priv->id));

	/* Enable IR Module */
	tmp = readl(priv->base + PWM_CTL_REG);
	writel(tmp | REG_CTL_EN, priv->base + PWM_CTL_REG);
}

static int rockchip_ir_ofdata_to_platdata(struct udevice *dev)
{
	int node = dev_of_offset(dev);
	const void *blob = gd->fdt_blob;
	struct rockchip_ir_priv *priv = dev_get_priv(dev);

	priv->num = fdtdec_get_child_count(blob, node);
	if (priv->num == 0) {
		debug("no ir map in dts\n");
		return -1;
	}
	priv->base = devfdt_get_addr(dev);
	priv->id = (priv->base >> 4) & 0xF;

	return 0;
}

static int rockchip_ir_probe(struct udevice *dev)
{
	int ret;
	struct clk clk;
	struct udevice *pinctrl;
	struct rockchip_ir_priv *priv = dev_get_priv(dev);

	rc_map = calloc(1, priv->num * sizeof(struct rc_map));
	if (!rc_map) {
		debug("%s: failed to calloc\n", __func__);
		return -EINVAL;
	}

	ret = ir_parse_keys(dev);
	if (ret) {
		debug("%s: failed to parse keys\n", __func__);
		return -EINVAL;
	}

	/*
	 * The PWM does not have decicated interrupt number in dts and can
	 * not get periph_id by pinctrl framework, so let's init then here.
	 */
	ret = uclass_get_device(UCLASS_PINCTRL, 0, &pinctrl);
	if (ret) {
		debug("%s: can't find pinctrl device\n", __func__);
		return -EINVAL;
	}

	ret = pinctrl_request_noflags(pinctrl, PERIPH_ID_PWM0 + priv->id);
	if (ret) {
		debug("%s pwm%d pinctrl init fail\n", __func__, priv->id);
		return -EINVAL;
	}

	ret = clk_get_by_index(dev, 0, &clk);
	if (ret) {
		debug("%s get clock fail!\n", __func__);
		return -EINVAL;
	}
	priv->freq = clk_get_rate(&clk);
	debug("%s pwm clk = %lu\n", __func__, priv->freq);
	priv->period = 1000000000 / priv->freq;

	irq_install_handler(IRQ_PWM,
			    (interrupt_handler_t *)rockchip_ir_irq, priv);
	irq_handler_enable(IRQ_PWM);

	rockchip_ir_hw_init(dev);

	return ret;
}

static const struct dm_rc_ops rockchip_ir_ops = {
	.get_keycode = rockchip_ir_get_keycode,
	.get_repeat = rockchip_ir_get_repeat,
};

static const struct udevice_id rockchip_ir_ids[] = {
	{ .compatible = "rockchip,remotectl-pwm" },
	{ }
};

U_BOOT_DRIVER(rockchip_ir) = {
	.name	= "rockchip_ir",
	.id	= UCLASS_RC,
	.of_match = rockchip_ir_ids,
	.ofdata_to_platdata     = rockchip_ir_ofdata_to_platdata,
	.probe = rockchip_ir_probe,
	.ops	= &rockchip_ir_ops,
	.priv_auto_alloc_size = sizeof(struct rockchip_ir_priv),
};
