/*
 * Amlogic A113 PCI Express Root-Complex driver
 *
 * Copyright (C) 2017 Yue Wang <yue.wang@amlogic.com>
 *
 * Based on Linux kernel driver:
 * pcie-amlogic.c:
 *
 */
#include <common.h>
#include <pci.h>
#include <asm/arch/clock.h>
#include <asm/gpio.h>
#include <asm/io.h>
#include <linux/sizes.h>
#include <errno.h>
#include "pcie_amlogic.h"
#include <asm/arch-axg/pci.h>

static t_pl_region_regs *pcieA_pl_region_regs =
	(t_pl_region_regs *)(PCIE_A_PORT_LOGIC_BASE_ADDR);
static t_pl_region_regs *pcieB_pl_region_regs =
	(t_pl_region_regs *)(PCIE_B_PORT_LOGIC_BASE_ADDR);
static t_pcie_user_cfg *pcieA_user_cfg =
	(t_pcie_user_cfg *)(PCIE_A_USER_CFG_BASE_ADDR);
static t_pcie_user_cfg *pcieB_user_cfg =
	(t_pcie_user_cfg *)(PCIE_B_USER_CFG_BASE_ADDR);
static t_pcie_user_status *pcieA_user_status  =
	(t_pcie_user_status *)(PCIE_A_USER_STATUS_BASE_ADDR);
static t_pcie_user_status *pcieB_user_status  =
	(t_pcie_user_status *)(PCIE_B_USER_STATUS_BASE_ADDR);
static t_pcie_cap_regs *pcieA_pcie_cap_regs  =
	(t_pcie_cap_regs *)(PCIE_A_PCIE_CAP_BASE_ADDR);
static t_pcie_cap_regs *pcieB_pcie_cap_regs  =
	(t_pcie_cap_regs *)(PCIE_B_PCIE_CAP_BASE_ADDR);
static t_type1_hdr_regs *pcieA_type1_hdr_regs =
	(t_type1_hdr_regs *)(PCIE_A_HDR_BASE_ADDR);
static t_type1_hdr_regs *pcieB_type1_hdr_regs =
	(t_type1_hdr_regs *)(PCIE_B_HDR_BASE_ADDR);

static u8 dw_pcie_iatu_unroll_enabled(e_pcieDev pcie_dev)
{
	u32 val;
	u64 amlogic_dbi_addr;

	if (pcie_dev == PCIE_A)
		amlogic_dbi_addr = AMLOGIC_PCIE_A_DBI_ADDR;
	else
		amlogic_dbi_addr = AMLOGIC_PCIE_B_DBI_ADDR;

	val = readl(amlogic_dbi_addr+PCIE_ATU_VIEWPORT);
	if (val == 0xffffffff)
		return 1;

	return 0;
}

static void dw_pcie_writel_unroll(e_pcieDev pcie_dev, u32 index, u32 reg,
				  u32 val)
{
	u32 offset = PCIE_GET_ATU_OUTB_UNR_REG_OFFSET(index);
	u64 amlogic_dbi_addr;

	if (pcie_dev == PCIE_A)
		amlogic_dbi_addr = AMLOGIC_PCIE_A_DBI_ADDR;
	else
		amlogic_dbi_addr = AMLOGIC_PCIE_B_DBI_ADDR;

	writel(val, amlogic_dbi_addr + offset + reg);
}

static void dw_pcie_prog_outbound_atu(e_pcieDev pcie_dev, int index,
		int type, u64 cpu_addr, u64 pci_addr, u32 size)
{
	u64 amlogic_dbi_addr;

	if (pcie_dev == PCIE_A)
		amlogic_dbi_addr = AMLOGIC_PCIE_A_DBI_ADDR;
	else
		amlogic_dbi_addr = AMLOGIC_PCIE_B_DBI_ADDR;

	if (iatu_unroll_enabled) {
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_LOWER_BASE,
			lower_32_bits(cpu_addr));
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_UPPER_BASE,
			upper_32_bits(cpu_addr));
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_LIMIT,
			lower_32_bits(size - 1));
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_LOWER_TARGET,
			lower_32_bits(pci_addr));
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_UPPER_TARGET,
			upper_32_bits(pci_addr));
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_REGION_CTRL1,
			type);
		dw_pcie_writel_unroll(pcie_dev, index, PCIE_ATU_UNR_REGION_CTRL2,
			PCIE_ATU_ENABLE);
	} else {
		writel(PCIE_ATU_REGION_OUTBOUND | index,
			amlogic_dbi_addr + PCIE_ATU_VIEWPORT);
		writel(lower_32_bits(cpu_addr),
			amlogic_dbi_addr + PCIE_ATU_LOWER_BASE);
		writel(upper_32_bits(cpu_addr),
			amlogic_dbi_addr + PCIE_ATU_UPPER_BASE);
		writel(lower_32_bits(cpu_addr + size - 1),
			amlogic_dbi_addr + PCIE_ATU_LIMIT);
		writel(lower_32_bits(pci_addr),
			amlogic_dbi_addr + PCIE_ATU_LOWER_TARGET);
		writel(upper_32_bits(pci_addr),
			amlogic_dbi_addr + PCIE_ATU_UPPER_TARGET);
		writel(type, amlogic_dbi_addr + PCIE_ATU_CR1);
		writel(PCIE_ATU_ENABLE, amlogic_dbi_addr + PCIE_ATU_CR2);
	}
}

/*
 * iATU region setup
 */
static int amlogic_pcie_regions_setup(e_pcieDev pcie_dev)
{
	u64 amlogic_dbi_addr;
	u32 high_2m_base_addr;
	u32 high_2m_limit;
	u64 target_base_addr;
	int type;

	if (pcie_dev == PCIE_A) {
		amlogic_dbi_addr = AMLOGIC_PCIE_A_DBI_ADDR;
		high_2m_base_addr = EP_A_BASE_ADDR + 0x200000;
		high_2m_limit     = high_2m_base_addr + 0x1fffff;
	} else {
		amlogic_dbi_addr = AMLOGIC_PCIE_B_DBI_ADDR;
		high_2m_base_addr = EP_B_BASE_ADDR + 0x200000;
		high_2m_limit     = high_2m_base_addr + 0x1fffff;
	}

	/* CMD reg:I/O space, MEM space, and Bus Master Enable */
	/* Set the CLASS_REV of RC CFG header to PCI_CLASS_BRIDGE_PCI */
	setbits_le32(amlogic_dbi_addr + PCI_CLASS_REVISION,
		     PCI_CLASS_BRIDGE_PCI << 16);

	iatu_unroll_enabled = dw_pcie_iatu_unroll_enabled(pcie_dev);

	target_base_addr  = high_2m_base_addr & 0x3fffff;
	type = PCIE_ATU_TYPE_MEM;
	if (type == PCIE_ATU_TYPE_CFG0 || type == PCIE_ATU_TYPE_CFG1) {
		target_base_addr  =   (0 & 0xff) << 24 |
							  (0 & 0x1F) << 19 |
							  (0 & 0x7) << 16;
	} else if (type == PCIE_ATU_TYPE_MEM)
		target_base_addr &= (~0xfff);

	dw_pcie_prog_outbound_atu(pcie_dev, PCIE_ATU_REGION_INDEX1,
					  PCIE_ATU_TYPE_MEM, high_2m_base_addr,
					  target_base_addr, high_2m_limit);

	return 0;
}

static int amlogic_pcie_read_config
	(struct pci_controller *hose, pci_dev_t d, int where, u32 *val)
{
	int type;
	e_pcieDev pcie_dev = *(int *)hose->priv_data;
	u64 ep_type0_hdr_regs;
	u32 ep_cfg_base_addr;
	u32 ep_cfg_addr_limit;
	u64 target_base_addr;

	if (pcie_dev == PCIE_A) {
		ep_type0_hdr_regs  = EP_A_BASE_ADDR;
		ep_cfg_base_addr   = EP_A_BASE_ADDR;
		ep_cfg_addr_limit  = EP_A_BASE_ADDR + 0x1fffff;
	} else {
		ep_type0_hdr_regs  = EP_B_BASE_ADDR;
		ep_cfg_base_addr   = EP_B_BASE_ADDR;
		ep_cfg_addr_limit  = EP_B_BASE_ADDR + 0x1fffff;
	}

	target_base_addr  = ep_cfg_base_addr & 0x3fffff;
	type = TYPE_CFG0;

	if (type == TYPE_CFG0 || type == TYPE_CFG1) {
		target_base_addr = (0 & 0xff) << 24 |
							(0 & 0x1F) << 19 |
							(0 & 0x7) << 16;
	} else if (type == TYPE_MEM)
		target_base_addr &= (~0xfff);

	dw_pcie_prog_outbound_atu(pcie_dev, PCIE_ATU_REGION_INDEX0,
					type, ep_cfg_base_addr,
					target_base_addr, ep_cfg_addr_limit);

	*val = readl(ep_type0_hdr_regs + where);

	return 0;
}


static int amlogic_pcie_write_config(struct pci_controller *hose, pci_dev_t d,
			int where, u32 val)
{
	int type;
	e_pcieDev pcie_dev = *(int *)hose->priv_data;
	u64 ep_type0_hdr_regs;
	u32 ep_cfg_base_addr;
	u32 ep_cfg_addr_limit;
	u64 target_base_addr;

	if (pcie_dev == PCIE_A) {
		ep_type0_hdr_regs  = EP_A_BASE_ADDR;
		ep_cfg_base_addr   = EP_A_BASE_ADDR;
		ep_cfg_addr_limit  = EP_A_BASE_ADDR + 0x1fffff;
	} else {
		ep_type0_hdr_regs  = EP_B_BASE_ADDR;
		ep_cfg_base_addr   = EP_B_BASE_ADDR;
		ep_cfg_addr_limit  = EP_B_BASE_ADDR + 0x1fffff;
	}

	target_base_addr  = ep_cfg_base_addr & 0x3fffff;
	type = TYPE_CFG0;

	if (type == TYPE_CFG0 || type == TYPE_CFG1) {
		target_base_addr  = (0 & 0xff) << 24 |
							(0 & 0x1F) << 19 |
							(0 & 0x7) << 16;
	} else if (type == TYPE_MEM)
		target_base_addr &= (~0xfff);

	dw_pcie_prog_outbound_atu(pcie_dev, PCIE_ATU_REGION_INDEX0,
					type, ep_cfg_base_addr,
					target_base_addr, ep_cfg_addr_limit);

	writel(val, ep_type0_hdr_regs + where);
	return 0;
}

static void amlogic_pcie_init_PLL(e_pcieDev pcie_dev)
{
	if (pcie_dev == PCIE_A) {
		*PCIE_PHY_BASE = 0x1d;
		mdelay(1);
		*PCIE_PHY_BASE = 0x1c;
		mdelay(1);
		*P_RESET0_LEVEL &= ~((0x3<<6) | (0x3<<1));
		mdelay(1);
		*PCIE_CTRL_6 &= ~(0X3 << 3);
		*MIPI_CTRL &= ~((0x1 << 26) | (0x1 << 29));
		mdelay(1);

		*PCIE_CTRL_0 = 0x400106c8;
		*PCIE_CTRL_1 = 0x0084a2aa;
		*PCIE_CTRL_2 = 0xb75020be;
		*PCIE_CTRL_3 = 0x0a47488e;
		*PCIE_CTRL_4 = 0xc000004d;
		*PCIE_CTRL_5 = 0x00078000;
		*PCIE_CTRL_6 = 0x002323c6;
		mdelay(1);

		*P_RESET0_LEVEL |=	  (0x3<<6);
		mdelay(1);

		*CLK81_HIGH |= (0x1 << 26);
	}

	mdelay(1);
	if (pcie_dev == PCIE_A)
		*CLK81_LOW |= (0x1 << 16);
	else
		*CLK81_LOW |= (0x1 << 17);
	mdelay(1);

	if (pcie_dev == PCIE_A)
		*P_RESET0_LEVEL |=	  (0x1 << 1);
	else
		*P_RESET0_LEVEL |=	  (0x1 << 2);
	mdelay(1);

	if (pcie_dev == PCIE_A)
		*MIPI_CTRL |= ((0x1 << 26) | (0x1 << 29));
	mdelay(1);

	if (pcie_dev == PCIE_A)
		*PCIE_CTRL_6 |= (0x1 << 4);
	else
		*PCIE_CTRL_6 |= (0x1 << 3);
	mdelay(1);
}

static int amlogic_pcie_init_dw(e_pcieDev pcie_dev)
{
	t_pl_region_regs  *pl_region_regs;
	t_type1_hdr_regs  *type1_hdr_regs;

	if (pcie_dev == PCIE_A) {
		pl_region_regs = pcieA_pl_region_regs;
		type1_hdr_regs = pcieA_type1_hdr_regs;
		pcieA_user_cfg->cfg0 |= (1<<7);
	} else {
		pl_region_regs = pcieB_pl_region_regs;
		type1_hdr_regs = pcieB_type1_hdr_regs;
		pcieB_user_cfg->cfg0 |= (1<<7);
	}

	pl_region_regs->port_link_ctrl_off_reg |= 1<<7;

	pl_region_regs->port_link_ctrl_off_reg &= ~(0x3f<<16);
	pl_region_regs->port_link_ctrl_off_reg |= 0x1<<16;

	pl_region_regs->gen2_ctrl_off_reg &= ~(0x1f<<8);
	pl_region_regs->gen2_ctrl_off_reg |= 0x1<<8;

	pl_region_regs->gen2_ctrl_off_reg |= (1<<17);

	type1_hdr_regs->base_addr0_reg = 0x0;
	type1_hdr_regs->base_addr1_reg = 0x0;

	return 0;
}

void amlogic_wait_linkup(e_pcieDev pcie_dev)
{
	t_pcie_user_status   *user_status;
	int   smlh_up = 0;
	int   rdlh_up = 0;
	int   ltssm_up = 0;
	int   speed_okay = 0;
	int   current_data_rate;
	int   cnt = 0;

	if (pcie_dev == PCIE_A)
		user_status = pcieA_user_status;
	else
		user_status = pcieB_user_status;

	while (smlh_up == 0 || rdlh_up == 0 ||
		ltssm_up == 0 || speed_okay == 0) {
		smlh_up = (user_status->status12 >> 6) & 0x1;
		rdlh_up = (user_status->status12 >> 16) & 0x1;
		ltssm_up = ((user_status->status12 >> 10)
			& 0x1f) == 0x11 ? 1 : 0;
		current_data_rate = (user_status->status17>> 7) & 0x1;

		if (current_data_rate == PCIE_GEN2 ||
			current_data_rate == PCIE_GEN1)
		speed_okay = 1;

		cnt++;

		if (cnt >= WAIT_LINKUP_TIMEOUT) {
			if (pcie_dev == PCIE_A)
				printf("Error:PCIE A Wait linkup timeout.\n");
			else
				printf("Error:PCIE B Wait linkup timeout.\n");
			return;
		}

		udelay(20);
	}

	if (pcie_dev == PCIE_A)
		printf("PCIE A linkup success\n");
	else
		printf("PCIE B linkup success\n");
}

void amlogic_set_max_payload(e_pcieDev pcie_dev, int size)
{
	int max_payload_size = 1;

	switch (size) {
	case 128:
		max_payload_size = 0;
		break;
	case 256:
		max_payload_size = 1;
		break;
	case 512:
		max_payload_size = 2;
		break;
	case 1024:
		max_payload_size = 3;
		break;
	case 2048:
		max_payload_size = 4;
		break;
	case 4096:
		max_payload_size = 5;
		break;
	}

	if (pcie_dev == PCIE_A) {
		pcieA_pcie_cap_regs->dev_ctrl_dev_stus_reg &= ~(0x7<<5);
		pcieA_pcie_cap_regs->dev_ctrl_dev_stus_reg |= (max_payload_size<<5);
	} else {
		pcieB_pcie_cap_regs->dev_ctrl_dev_stus_reg &= ~(0x7<<5);
		pcieB_pcie_cap_regs->dev_ctrl_dev_stus_reg |= (max_payload_size<<5);
	}
}

void amlogic_set_max_rd_req_size(e_pcieDev pcie_dev, int size)
{
	int max_rd_req_size = 1;

	switch (size) {
	case 128:
		max_rd_req_size = 0;
		break;
	case 256:
		max_rd_req_size = 1;
		break;
	case 512:
		max_rd_req_size = 2;
		break;
	case 1024:
		max_rd_req_size = 3;
		break;
	case 2048:
		max_rd_req_size = 4;
		break;
	case 4096:
		max_rd_req_size = 5;
		break;
	}

	if (pcie_dev == PCIE_A) {
		pcieA_pcie_cap_regs->dev_ctrl_dev_stus_reg &= ~(0x7<<12);
		pcieA_pcie_cap_regs->dev_ctrl_dev_stus_reg |= (max_rd_req_size<<12);
	} else {
		pcieB_pcie_cap_regs->dev_ctrl_dev_stus_reg &= ~(0x7<<12);
		pcieB_pcie_cap_regs->dev_ctrl_dev_stus_reg |= (max_rd_req_size<<12);
	}
}

void amlogic_configure_dsp_memory_map(e_pcieDev pcie_dev)
{
	t_type1_hdr_regs  *type1_hdr_regs;
	u32 io_base_addr;
	u32 io_limit;
	u32 mem_base_addr;
	u32 mem_limit;
	u32 pref_mem_base_addr;
	u32 pref_mem_limit;

	if (pcie_dev == PCIE_A) {
		type1_hdr_regs      = pcieA_type1_hdr_regs;
		io_base_addr        = PCIE_A_IO_BASE_ADDR;
		io_limit            = PCIE_A_IO_LIMIT;
		mem_base_addr       = PCIE_A_MEM_BASE_ADDR;
		mem_limit           = PCIE_A_MEM_LIMIT;
		pref_mem_base_addr  = PCIE_A_PREF_MEM_BASE_ADDR;
		pref_mem_limit      = PCIE_A_PREF_MEM_LIMIT;
	} else {
		type1_hdr_regs      = pcieB_type1_hdr_regs;
		io_base_addr        = PCIE_B_IO_BASE_ADDR;
		io_limit            = PCIE_B_IO_LIMIT;
		mem_base_addr       = PCIE_B_MEM_BASE_ADDR;
		mem_limit           = PCIE_B_MEM_LIMIT;
		pref_mem_base_addr  = PCIE_B_PREF_MEM_BASE_ADDR;
		pref_mem_limit      = PCIE_B_PREF_MEM_LIMIT;
	}
	type1_hdr_regs->io_limit_base_reg = (((io_base_addr >> 12) & 0xF) << 4)
									| (1 << 0) | (1 << 8) |
									(((io_limit >> 12) & 0XF) << 12);

	type1_hdr_regs->io_limit_base_upper_reg = ((io_base_addr >> 16) & 0xFFFF)
								<< 0 | ((io_limit >> 16) & 0XFFFF) << 16;

	type1_hdr_regs->pref_mem_limit_base_reg = 0x00010001;
	type1_hdr_regs->pref_base_upper_reg	= 0;
	type1_hdr_regs->pref_limit_upper_reg = 0;
	type1_hdr_regs->pref_mem_limit_base_reg =
		((pref_mem_base_addr >> 20) & 0xFFF) << 4 |
		((pref_mem_limit >> 20) & 0xFFF) << 20;

	type1_hdr_regs->mem_limit_base_reg =
		((mem_base_addr >> 20) & 0xFFF) << 4 |
		((mem_limit >> 20) & 0xFFF) << 20;
}

void amlogic_enable_memory_space(e_pcieDev pcie_dev)
{
	t_type1_hdr_regs  *type1_hdr_regs;

	if (pcie_dev == PCIE_A)
		type1_hdr_regs = pcieA_type1_hdr_regs;
	else
		type1_hdr_regs = pcieB_type1_hdr_regs;

	type1_hdr_regs->stus_cmd_reg = 7;
}

static int amlogic_pcie_link_up(e_pcieDev pcie_dev)
{
	amlogic_pcie_init_dw(pcie_dev);

	amlogic_set_max_payload(pcie_dev, 256);
	amlogic_set_max_rd_req_size(pcie_dev, 256);

	amlogic_pcie_regions_setup(pcie_dev);

	amlogic_configure_dsp_memory_map(pcie_dev);
	amlogic_enable_memory_space(pcie_dev);

	amlogic_pcie_init_reset_pin(pcie_dev);
	amlogic_wait_linkup(pcie_dev);

	return 0;
}

void amlogic_pcie_PLL_disable(void)
{
	amlogic_pcie_disable();

	*PCIE_PHY_BASE = 0x1d;

	mdelay(1);
	*P_RESET0_LEVEL &= ~((0x3<<6) | (0x3<<1));
	mdelay(1);

	*PCIE_CTRL_0 = 0x80000000;
	*PCIE_CTRL_1 = 0x0;
	*PCIE_CTRL_2 = 0x0;
	*PCIE_CTRL_3 = 0x0;
	*PCIE_CTRL_4 = 0x0;
	*PCIE_CTRL_5 = 0x0;
	*PCIE_CTRL_6 = 0x0;

	*CLK81_LOW &= ~(0x1 << 16);
	*CLK81_LOW &= ~(0x1 << 17);

	*MIPI_CTRL &= ~((0x1 << 26) | (0x1 << 29));
	*PCIE_CTRL_6 &= ~(0X3 << 3);
}

void amlogic_pcie_init(e_pcieDev pcie_dev)
{
	/* Static instance of the controller. */
	static struct pci_controller	pcc;
	struct pci_controller		*hose = &pcc;
	int ret;

	amlogic_pcie_init_PLL(pcie_dev);

	memset(&pcc, 0, sizeof(pcc));
	if (pcie_dev == PCIE_A) {
		/* PCI I/O space */
		pci_set_region(&hose->regions[0],
		       PCIE_A_IO_BASE_ADDR, PCIE_A_IO_BASE_ADDR,
		       0xff, PCI_REGION_IO);

		/* PCI memory space */
		pci_set_region(&hose->regions[1],
		       PCIE_A_MEM_BASE_ADDR, PCIE_A_MEM_BASE_ADDR,
		       0x6fffffff, PCI_REGION_MEM);

		/* System memory space */
		pci_set_region(&hose->regions[2],
		       EP_A_PREF_MEM_BASE_ADDR, EP_A_PREF_MEM_BASE_ADDR,
		       0x7fffff, PCI_REGION_MEM | PCI_REGION_SYS_MEMORY);
	} else {
		/* PCI I/O space */
		pci_set_region(&hose->regions[0],
		       PCIE_B_IO_BASE_ADDR, PCIE_B_IO_BASE_ADDR,
		       0xff, PCI_REGION_IO);

		/* PCI memory space */
		pci_set_region(&hose->regions[1],
		       PCIE_B_MEM_BASE_ADDR, PCIE_B_MEM_BASE_ADDR,
		       0x6fffffff, PCI_REGION_MEM);

		/* System memory space */
		pci_set_region(&hose->regions[2],
		       EP_B_PREF_MEM_BASE_ADDR, EP_B_PREF_MEM_BASE_ADDR,
		       0x7fffff, PCI_REGION_MEM | PCI_REGION_SYS_MEMORY);
	}

	hose->region_count = 3;
	pcie_type = pcie_dev;
	hose->priv_data = &pcie_type;

	pci_set_ops(hose,
		pci_hose_read_config_byte_via_dword,
		pci_hose_read_config_word_via_dword,
		amlogic_pcie_read_config,
		pci_hose_write_config_byte_via_dword,
		pci_hose_write_config_word_via_dword,
		amlogic_pcie_write_config);

	/* Start the controller. */
	ret = amlogic_pcie_link_up(pcie_dev);
	if (!ret) {
		pci_register_hose(hose);
		hose->last_busno = pci_hose_scan(hose);
	}
	if (pcie_dev == PCIE_B)
		amlogic_pcie_PLL_disable();
}

/* Probe function. */
void pci_init_board(void)
{
	amlogic_pcie_init(PCIE_A);
	amlogic_pcie_init(PCIE_B);
}
