/***************************************************************************
 Title:      pcie.h

 Author:     augustine.jiang

 Created:    20:07:53 15/03/2017

 Description:

 Note:

 History:

***************************************************************************/
#ifndef PCIE__H
#define PCIE__H

#define PF0_TYPE1_HDR_BaseAddress 0x0

#define PF0_PM_CAP_BaseAddress 0x40

#define PF0_PCIE_CAP_BaseAddress 0x70

#define PF0_AER_CAP_BaseAddress 0x100

#define PF0_MSI_CAP_BaseAddress 0x50

#define PF0_DMA_CAP_BaseAddress 0x380000

#define PF0_ATU_CAP_BaseAddress 0x300000

#define PF0_PORT_BaseAddress 0x700


#define CX_NFUNC    1

#define PCIE_A_BASE_ADDR   0xf9800000
#define PCIE_B_BASE_ADDR   0xfa000000

#define EP_A_BASE_ADDR     (PCIE_A_BASE_ADDR+0x400000)
#define EP_B_BASE_ADDR     (PCIE_B_BASE_ADDR+0x400000)

#define PCIE_TLP_OFF_ADDR  0x00400000

#define EP_A_IO_BASE_ADDR        (0x8000)
#define EP_A_IO_LIMIT            (EP_A_IO_BASE_ADDR+0xff)
#define EP_A_MEM_BASE_ADDR       (0x200000)
#define EP_A_MEM_LIMIT           (EP_A_MEM_BASE_ADDR+0x6fffffff)
#define EP_A_PREF_MEM_BASE_ADDR  (0x800000)
#define EP_A_PREF_MEM_LIMIT      (EP_A_PREF_MEM_BASE_ADDR+0x7fffff)

#define EP_B_IO_BASE_ADDR        (0x8000)
#define EP_B_IO_LIMIT            (EP_B_IO_BASE_ADDR+0xff)
#define EP_B_MEM_BASE_ADDR       (0x200000)
#define EP_B_MEM_LIMIT           (EP_B_MEM_BASE_ADDR+0x6fffffff)
#define EP_B_PREF_MEM_BASE_ADDR  (0x800000)
#define EP_B_PREF_MEM_LIMIT      (EP_B_PREF_MEM_BASE_ADDR+0x7fffff)

#define PCIE_A_IO_BASE_ADDR        EP_A_IO_BASE_ADDR
#define PCIE_A_IO_LIMIT            EP_A_IO_LIMIT
#define PCIE_A_MEM_BASE_ADDR       EP_A_MEM_BASE_ADDR
#define PCIE_A_MEM_LIMIT           EP_A_MEM_LIMIT
#define PCIE_A_PREF_MEM_BASE_ADDR  EP_A_PREF_MEM_BASE_ADDR
#define PCIE_A_PREF_MEM_LIMIT      EP_A_PREF_MEM_LIMIT

#define PCIE_B_IO_BASE_ADDR        EP_B_IO_BASE_ADDR
#define PCIE_B_IO_LIMIT            EP_B_IO_LIMIT
#define PCIE_B_MEM_BASE_ADDR       EP_B_MEM_BASE_ADDR
#define PCIE_B_MEM_LIMIT           EP_B_MEM_LIMIT
#define PCIE_B_PREF_MEM_BASE_ADDR  EP_B_PREF_MEM_BASE_ADDR
#define PCIE_B_PREF_MEM_LIMIT      EP_B_PREF_MEM_LIMIT

#define OB_REQ_ADDR_OFFSET          0x100000

#define PCIE_A_USER_CFG_BASE_ADDR      0xff646000
#define PCIE_B_USER_CFG_BASE_ADDR      0xff648000
#define PCIE_A_USER_STATUS_BASE_ADDR   0xff646000
#define PCIE_B_USER_STATUS_BASE_ADDR   0xff648000


#define PCIE_A_HDR_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_TYPE1_HDR_BaseAddress)
#define PCIE_A_PM_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_PM_CAP_BaseAddress)
#define PCIE_A_PCIE_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_PCIE_CAP_BaseAddress)
#define PCIE_A_AER_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_AER_CAP_BaseAddress)
#define PCIE_A_MSI_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_MSI_CAP_BaseAddress)
#define PCIE_A_DMA_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_DMA_CAP_BaseAddress)
#define PCIE_A_ATU_CAP_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_ATU_CAP_BaseAddress)
#define PCIE_A_PORT_LOGIC_BASE_ADDR (PCIE_A_BASE_ADDR + PF0_PORT_BaseAddress)

#define PCIE_B_HDR_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_TYPE1_HDR_BaseAddress)
#define PCIE_B_PM_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_PM_CAP_BaseAddress)
#define PCIE_B_PCIE_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_PCIE_CAP_BaseAddress)
#define PCIE_B_AER_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_AER_CAP_BaseAddress)
#define PCIE_B_MSI_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_MSI_CAP_BaseAddress)
#define PCIE_B_DMA_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_DMA_CAP_BaseAddress)
#define PCIE_B_ATU_CAP_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_ATU_CAP_BaseAddress)
#define PCIE_B_PORT_LOGIC_BASE_ADDR (PCIE_B_BASE_ADDR + PF0_PORT_BaseAddress)

#define EP_A_HDR_BASE_ADDR (EP_A_BASE_ADDR + PF0_TYPE1_HDR_BaseAddress)
#define EP_A_PM_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_PM_CAP_BaseAddress)
#define EP_A_PCIE_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_PCIE_CAP_BaseAddress)
#define EP_A_AER_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_AER_CAP_BaseAddress)
#define EP_A_L1SS_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_L1SUB_CAP_BaseAddress)
#define EP_A_MSI_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_MSI_CAP_BaseAddress)
#define EP_A_DMA_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_DMA_CAP_BaseAddress)
#define EP_A_ATU_CAP_BASE_ADDR (EP_A_BASE_ADDR + PF0_ATU_CAP_BaseAddress)
#define EP_A_PORT_LOGIC_BASE_ADDR (EP_A_BASE_ADDR + PF0_PORT_BaseAddress)

#define EP_B_HDR_BASE_ADDR (EP_B_BASE_ADDR + PF0_TYPE1_HDR_BaseAddress)
#define EP_B_PM_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_PM_CAP_BaseAddress)
#define EP_B_PCIE_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_PCIE_CAP_BaseAddress)
#define EP_B_AER_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_AER_CAP_BaseAddress)
#define EP_B_L1SS_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_L1SUB_CAP_BaseAddress)
#define EP_B_MSI_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_MSI_CAP_BaseAddress)
#define EP_B_DMA_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_DMA_CAP_BaseAddress)
#define EP_B_ATU_CAP_BASE_ADDR (EP_B_BASE_ADDR + PF0_ATU_CAP_BaseAddress)
#define EP_B_PORT_LOGIC_BASE_ADDR (EP_B_BASE_ADDR + PF0_PORT_BaseAddress)


#define    WAIT_LINKUP_TIMEOUT         500000

#define Wr_dword(addr, data) *(volatile uint32_t *)(u64)(addr)=(data)
#define Rd_dword(addr) *(volatile uint32_t *)(u64)(addr)

typedef enum {
    PCIE_A,
	PCIE_B
} e_pcieDev;

typedef enum {
  TYPE_MEM    = 0x00,
  TYPE_MEM_LK = 0x01,
  TYPE_IO     = 0x02,
  TYPE_CFG0   = 0x04,
  TYPE_CFG1   = 0x05,
  TYPE_MSG    = 0x10,
  TYPE_CPL    = 0x0a,
  TYPE_CPL_LK = 0x0b
} t_xcn_type;

enum pcie_data_rate {
	PCIE_GEN1,
	PCIE_GEN2,
	PCIE_GEN3,
	PCIE_GEN4
};

enum pcie_data_series {
	PCIE_RATEA_SERIES,
	PCIE_RATEB_SERIES
};

typedef struct pcie_user_cfg {
	volatile uint32_t   cfg0;
	volatile uint32_t   cfg1;
	volatile uint32_t   cfg2;
	volatile uint32_t   cfg3;
	volatile uint32_t   cfg4;
	volatile uint32_t   cfg5;
} t_pcie_user_cfg;


typedef struct pcie_user_status {
	volatile uint32_t   status0;
	volatile uint32_t   status1;
	volatile uint32_t   status2;
	volatile uint32_t   status3;
	volatile uint32_t   status4;
	volatile uint32_t   status5;
	volatile uint32_t   status6;
	volatile uint32_t   status7;
	volatile uint32_t   status8;
	volatile uint32_t   status9;
	volatile uint32_t   status10;
	volatile uint32_t   status11;
	volatile uint32_t   status12;
	volatile uint32_t   status13;
	volatile uint32_t   status14;
	volatile uint32_t   status15;
	volatile uint32_t   status16;
	volatile uint32_t   status17;
	volatile uint32_t   status18;
	volatile uint32_t   status19;
	volatile uint32_t   status20;
	volatile uint32_t   status21;
	volatile uint32_t   status22;
	volatile uint32_t   status23;
	volatile uint32_t   status24;
	volatile uint32_t   status25;
	volatile uint32_t   status26;
} t_pcie_user_status;

typedef struct pcie_cap_regs {
	volatile uint32_t   cap_id_pcie_next_cap_ptr_reg;
	volatile uint32_t   dev_cap_reg;
	volatile uint32_t   dev_ctrl_dev_stus_reg;
	volatile uint32_t   link_cap_reg;
	volatile uint32_t   link_ctrl_link_stus_reg;
	volatile uint32_t   slot_cap_reg;
	volatile uint32_t   slot_ctrl_slot_stus;
	volatile uint32_t   root_ctrl_root_cap_reg;
	volatile uint32_t   root_stus_reg;
	volatile uint32_t   dev_cap2_reg;
	volatile uint32_t   dev_ctrl2_dev_stus2;
	volatile uint32_t   link_cap2_reg;
	volatile uint32_t   link_ctrl2_link_stus2_reg;
} t_pcie_cap_regs;

typedef struct type1_hdr_regs {
	volatile uint32_t   dev_vend_reg;
	volatile uint32_t   stus_cmd_reg;
	volatile uint32_t   class_code_rev_id_reg;
	volatile uint32_t   bist_cache_size_reg;
	volatile uint32_t   base_addr0_reg;
	volatile uint32_t   base_addr1_reg;
	volatile uint32_t   sec_bus_reg;
	volatile uint32_t   io_limit_base_reg;
	volatile uint32_t   mem_limit_base_reg;
	volatile uint32_t   pref_mem_limit_base_reg;
	volatile uint32_t   pref_base_upper_reg;
	volatile uint32_t   pref_limit_upper_reg;
	volatile uint32_t   io_limit_base_upper_reg;
	volatile uint32_t   type1_cap_ptr_reg;
	volatile uint32_t   type1_exp_rom_base_reg;
	volatile uint32_t   bridge_ctrl_int_pin_int_line_reg;
} t_type1_hdr_regs;

#define   PORT_LOGIC_REGION_BASE                       0X700

typedef struct pl_region_regs {
	volatile uint32_t ack_latency_timer_off_reg;
	volatile uint32_t vendor_spec_dllp_off_reg;
	volatile uint32_t port_force_off_reg;
	volatile uint32_t ack_f_aspm_ctrl_off_reg;
	volatile uint32_t port_link_ctrl_off_reg;
	volatile uint32_t lane_skew_off_reg;
	volatile uint32_t timer_ctrl_max_func_num_off_reg;
	volatile uint32_t symbol_timer_filter_1_off_reg;
	volatile uint32_t filter_mask_2_off_reg;
	volatile uint32_t amba_mul_ob_decomp_np_sub_req_ctrl_off_reg;
	volatile uint32_t pl_debug0_off_reg;
	volatile uint32_t pl_debug1_off_reg;
	volatile uint32_t tx_p_fc_credit_status_off_reg;
	volatile uint32_t tx_np_fc_credit_status_off_reg;
	volatile uint32_t tx_cpl_fc_credit_status_off_reg;
	volatile uint32_t queue_status_off_reg;
	volatile uint32_t vc_tx_arbi_1_off_reg;
	volatile uint32_t vc_tx_arbi_2_off_reg;
	volatile uint32_t vc0_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc0_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc0_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc1_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc1_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc1_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc2_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc2_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc2_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc3_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc3_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc3_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc4_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc4_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc4_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc5_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc5_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc5_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc6_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc6_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc6_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc7_p_rx_q_ctrl_off_reg;
	volatile uint32_t vc7_np_rx_q_ctrl_off_reg;
	volatile uint32_t vc7_cpl_rx_q_ctrl_off_reg;
	volatile uint32_t vc0_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc0_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc0_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc1_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc1_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc1_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc2_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc2_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc2_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc3_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc3_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc3_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc4_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc4_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc4_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc5_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc5_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc5_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc6_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc6_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc6_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc7_p_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc7_np_buffer_depth_ctrl_off_reg;
	volatile uint32_t vc7_cpl_buffer_depth_ctrl_off_reg;
	volatile uint32_t res0;
	volatile uint32_t gen2_ctrl_off_reg;
	volatile uint32_t phy_status_off_reg;
	volatile uint32_t phy_control_off_reg;
	volatile uint32_t res1;
	volatile uint32_t trgt_map_ctrl_off_reg;
	volatile uint32_t msi_ctrl_addr_off_reg;
	volatile uint32_t msi_ctrl_upper_addr_off_reg;
	volatile uint32_t msi_ctrl_int_0_en_off_reg;
	volatile uint32_t msi_ctrl_int_0_mask_off_reg;
	volatile uint32_t msi_ctrl_int_0_status_off_reg;
	volatile uint32_t msi_ctrl_int_1_en_off_reg;
	volatile uint32_t msi_ctrl_int_1_mask_off_reg;
	volatile uint32_t msi_ctrl_int_1_status_off_reg;
	volatile uint32_t msi_ctrl_int_2_en_off_reg;
	volatile uint32_t msi_ctrl_int_2_mask_off_reg;
	volatile uint32_t msi_ctrl_int_2_status_off_reg;
	volatile uint32_t msi_ctrl_int_3_en_off_reg;
	volatile uint32_t msi_ctrl_int_3_mask_off_reg;
	volatile uint32_t msi_ctrl_int_3_status_off_reg;
	volatile uint32_t msi_ctrl_int_4_en_off_reg;
	volatile uint32_t msi_ctrl_int_4_mask_off_reg;
	volatile uint32_t msi_ctrl_int_4_status_off_reg;
	volatile uint32_t msi_ctrl_int_5_en_off_reg;
	volatile uint32_t msi_ctrl_int_5_mask_off_reg;
	volatile uint32_t msi_ctrl_int_5_status_off_reg;
	volatile uint32_t msi_ctrl_int_6_en_off_reg;
	volatile uint32_t msi_ctrl_int_6_mask_off_reg;
	volatile uint32_t msi_ctrl_int_6_status_off_reg;
	volatile uint32_t msi_ctrl_int_7_en_off_reg;
	volatile uint32_t msi_ctrl_int_7_mask_off_reg;
	volatile uint32_t msi_ctrl_int_7_status_off_reg;
	volatile uint32_t msi_gpio_io_off_reg;
	volatile uint32_t clock_gating_ctrl_off_reg;
	volatile uint32_t gen3_related_off_reg;
	volatile uint32_t gen3_eq_local_fs_lf_off_reg;
	volatile uint32_t gen3_eq_pset_coef_map_off_reg;
	volatile uint32_t gen3_eq_pset_index_off_reg;
	volatile uint32_t pf_hidden_off_reg;
	volatile uint32_t gen3_eq_coeff_legality_status_off_reg;
	volatile uint32_t gen3_eq_control_off_reg;
	volatile uint32_t gen3_eq_fb_mode_dir_change_off_reg;
	volatile uint32_t eq_status_off_reg;
	volatile uint32_t order_rule_ctrl_off_reg;
	volatile uint32_t pipe_loopback_control_off_reg;
	volatile uint32_t misc_control_1_off_reg;
	volatile uint32_t multi_lane_control_off_reg;
	volatile uint32_t phy_interop_ctrl_off_reg;
	volatile uint32_t trgt_cpl_lut_delete_entry_off_reg;
	volatile uint32_t link_flush_control_off_reg;
	volatile uint32_t amba_error_response_default_off_reg;
	volatile uint32_t amba_link_timeout_off_reg;
	volatile uint32_t amba_ordering_ctrl_off_reg;
	volatile uint32_t amba_ordrmgr_wdog_off_reg;
	volatile uint32_t coherency_control_1_off_reg;
	volatile uint32_t coherency_control_2_off_reg;
	volatile uint32_t coherency_control_3_off_reg;
	volatile uint32_t res111;
	volatile uint32_t axi_mstr_msg_addr_low_off_reg;
	volatile uint32_t axi_mstr_msg_addr_high_off_reg;
	volatile uint32_t pcie_version_number_off_reg;
	volatile uint32_t pcie_version_type_off_reg;
	volatile uint32_t iatu_viewport_off_reg;
	volatile uint32_t iatu_region_ctrl_1_viewport_off_reg;
	volatile uint32_t iatu_region_ctrl_2_viewport_off_reg;
	volatile uint32_t iatu_lwr_base_addr_viewport_off_reg;
	volatile uint32_t iatu_upper_base_addr_viewport_off_reg;
	volatile uint32_t iatu_limit_addr_viewport_off_reg;
	volatile uint32_t iatu_lwr_target_addr_viewport_off_reg;
	volatile uint32_t iatu_upper_target_addr_viewport_off_reg;
	volatile uint32_t iatu_region_ctrl_3_viewport_off_reg;
	volatile uint32_t iatu_uppr_limit_addr_viewport_off_reg;
	volatile uint32_t res2[2];
	volatile uint32_t interface_timer_control_off_reg;
	volatile uint32_t interface_timer_target_off_reg;
	volatile uint32_t interface_timer_status_off_reg;
	volatile uint32_t res3;
	volatile uint32_t msix_address_match_low_off_reg;
	volatile uint32_t msix_address_match_high_off_reg;
	volatile uint32_t msix_doorbell_off_reg;
	volatile uint32_t msix_ram_ctrl_off_reg;
	volatile uint32_t res4[8];
	volatile uint32_t dma_ctrl_data_arb_prior_viewport_off_reg;
	volatile uint32_t res5;
	volatile uint32_t dma_ctrl_viewport_off_reg;
	volatile uint32_t dma_write_engine_en_viewport_off_reg;
	volatile uint32_t dma_write_doorbell_viewport_off_reg;
	volatile uint32_t res6;
	volatile uint32_t dma_write_channel_arb_weight_low_viewport_off_reg;
	volatile uint32_t dma_write_channel_arb_weight_high_viewport_off_reg;
	volatile uint32_t res7[3];
	volatile uint32_t dma_read_engine_en_viewport_off_reg;
	volatile uint32_t dma_read_doorbell_viewport_off_reg;
	volatile uint32_t res8;
	volatile uint32_t dma_read_channel_arb_weight_low_viewport_off_reg;
	volatile uint32_t dma_read_channel_arb_weight_high_viewport_off_reg;
	volatile uint32_t res9[3];
	volatile uint32_t dma_write_int_status_viewport_off_reg;
	volatile uint32_t res10;
	volatile uint32_t dma_write_int_mask_viewport_off_reg;
	volatile uint32_t dma_write_int_clear_viewport_off_reg;
	volatile uint32_t dma_write_err_status_viewport_off_reg;
	volatile uint32_t dma_write_done_imwr_low_viewport_off_reg;
	volatile uint32_t dma_write_done_imwr_high_viewport_off_reg;
	volatile uint32_t dma_write_abort_imwr_low_viewport_off_reg;
	volatile uint32_t dma_write_abort_imwr_high_viewport_off_reg;
	volatile uint32_t dma_write_ch01_imwr_data_viewport_off_reg;
	volatile uint32_t dma_write_ch23_imwr_data_viewport_off_reg;
	volatile uint32_t dma_write_ch45_imwr_data_viewport_off_reg;
	volatile uint32_t dma_write_ch67_imwr_data_viewport_off_reg;
	volatile uint32_t res101[4];
	volatile uint32_t dma_write_linked_list_err_en_viewport_off_reg;
	volatile uint32_t res11[3];
	volatile uint32_t dma_read_int_status_viewport_off_reg;
	volatile uint32_t res12;
	volatile uint32_t dma_read_int_mask_viewport_off_reg;
	volatile uint32_t dma_read_int_clear_viewport_off_reg;
	volatile uint32_t res13;
	volatile uint32_t dma_read_err_status_low_viewport_off_reg;
	volatile uint32_t dma_read_err_status_high_viewport_off_reg;
	volatile uint32_t res14[2];
	volatile uint32_t dma_read_linked_list_err_en_viewport_off_reg;
	volatile uint32_t res15;
	volatile uint32_t dma_read_done_imwr_low_viewport_off_reg;
	volatile uint32_t dma_read_done_imwr_high_viewport_off_reg;
	volatile uint32_t dma_read_abort_imwr_low_viewport_off_reg;
	volatile uint32_t dma_read_abort_imwr_high_viewport_off_reg;
	volatile uint32_t dma_read_ch01_imwr_data_viewport_off_reg;
	volatile uint32_t dma_read_ch23_imwr_data_viewport_off_reg;
	volatile uint32_t dma_read_ch45_imwr_data_viewport_off_reg;
	volatile uint32_t dma_read_ch67_imwr_data_viewport_off_reg;
	volatile uint32_t res16[4];
	volatile uint32_t dma_viewport_sel_off_reg;
	volatile uint32_t dma_ch_control1_viewport_off_reg;
	volatile uint32_t dma_ch_control2_viewport_off_reg;
	volatile uint32_t dma_transfer_size_viewport_off_reg;
	volatile uint32_t dma_sar_low_viewport_off_reg;
	volatile uint32_t dma_sar_high_viewport_off_reg;
	volatile uint32_t dma_dar_low_viewport_off_reg;
	volatile uint32_t dma_dar_high_viewport_off_reg;
	volatile uint32_t dma_llp_low_viewport_off_reg;
	volatile uint32_t dma_llp_high_viewport_off_reg;
	volatile uint32_t res17[35];
	volatile uint32_t pl_chk_reg_control_status_off_reg;
	volatile uint32_t pl_chk_reg_start_end_off_reg;
	volatile uint32_t pl_chk_reg_err_addr_off_reg;
	volatile uint32_t pl_chk_reg_err_pf_vf_off_reg;
	volatile uint32_t pl_ltr_latency_off_reg;
	volatile uint32_t res18[3];
	volatile uint32_t aux_clk_freq_off_reg;
	volatile uint32_t l1_substates_off_reg;
	volatile uint32_t res19[2];
	volatile uint32_t dynamic_reconfig_ctrl_off_reg;
	volatile uint32_t pl_mpcie_ctrl_off_reg;
	volatile uint32_t pl_mpcie_lrc_rrc_init_sts_off_reg;
	volatile uint32_t pl_mpcie_link_sts_off_reg;
	volatile uint32_t pl_mpcie_lane_sts_off_reg;
	volatile uint32_t res20[3];
	volatile uint32_t phy_viewport_ctlsts_off_reg;
	volatile uint32_t phy_viewport_data_off_reg;
	volatile uint32_t res21[2];
	volatile uint32_t gen4_lane_margining_1_off_reg;
	volatile uint32_t gen4_lane_margining_2_off_reg;
	volatile uint32_t res22[30];
	volatile uint32_t rx_serialization_q_ctrl_off_reg;
} t_pl_region_regs;

union phy_r0 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_test_powerdown:1;
		unsigned phy_ref_use_pad:1;
		unsigned pipe_port_sel:2;
		unsigned pcs_common_clocks:1;
		unsigned reserved:27;
	} b;
};

union phy_r1 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_tx1_term_offset:5;
		unsigned phy_tx0_term_offset:5;
		unsigned phy_rx1_eq:3;
		unsigned phy_rx0_eq:3;
		unsigned phy_los_level:5;
		unsigned phy_los_bias:3;
		unsigned phy_ref_clkdiv2:1;
		unsigned phy_mpll_multiplier:7;
	} b;
};

union phy_r2 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned pcs_tx_deemph_gen2_6db:6;
		unsigned pcs_tx_deemph_gen2_3p5db:6;
		unsigned pcs_tx_deemph_gen1:6;
		unsigned phy_tx_vboost_lvl:3;
		unsigned reserved:11;
	} b;
};

union phy_r3 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned pcs_tx_swing_low:7;
		unsigned pcs_tx_swing_full:7;
		unsigned reserved:18;
	} b;
};

union phy_r4 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_cr_write:1;
		unsigned phy_cr_read:1;
		unsigned phy_cr_data_in:16;
		unsigned phy_cr_cap_data:1;
		unsigned phy_cr_cap_addr:1;
		unsigned reserved:12;
	} b;
};

union phy_r5 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_cr_data_out:16;
		unsigned phy_cr_ack:1;
		unsigned phy_bs_out:1;
		unsigned reserved:14;
	} b;
};

union phy_r6 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_bs_update_dr:1;
		unsigned phy_bs_shift_dr:1;
		unsigned phy_bs_preload:1;
		unsigned phy_bs_invert:1;
		unsigned phy_bs_init:1;
		unsigned phy_bs_in:1;
		unsigned phy_bs_highz:1;
		unsigned phy_bs_extest_ac:1;
		unsigned phy_bs_extest:1;
		unsigned phy_bs_clk:1;
		unsigned phy_bs_clamp:1;
		unsigned phy_bs_capture_dr:1;
		unsigned phy_acjt_level:5;
		unsigned reserved:15;
	} b;
};

struct pcie_phy_aml_regs {
	volatile uint32_t phy_r0;
	volatile uint32_t phy_r1;
	volatile uint32_t phy_r2;
	volatile uint32_t phy_r3;
	volatile uint32_t phy_r4;
	volatile uint32_t phy_r5;
};


union hc_r0 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned app_req_flush:1;
		unsigned app_xfer_pending:1;
		unsigned app_req_exit_l1:1;
		unsigned app_ready_entr_l23:1;
		unsigned app_req_entr_l1:1;
		unsigned app_init_rst:1;
		unsigned app_clk_req_n:1;
		unsigned app_ltssm_enable:1;
		unsigned sys_aux_pwr_det:1;
		unsigned restore_state_ack:1;
		unsigned save_state_ack:1;
		unsigned app_l1_pwr_off_en:1;
		unsigned apps_pm_xmt_turnoff:1;
		unsigned app_unlock_msg:1;
		unsigned sys_eml_interlock_engaged:1;
		unsigned sys_cmd_cpled_int:1;
		unsigned sys_pre_det_chged:1;
		unsigned sys_mrl_sensor_chged:1;
		unsigned sys_pwr_fault_det:1;
		unsigned sys_mrl_sensor_state:1;
		unsigned sys_pre_det_state:1;
		unsigned sys_atten_button_pressed:1;
		unsigned slv_armisc_info_atu_bypass:1;
		unsigned slv_awmisc_info_atu_bypass:1;
		unsigned reserved:8;
	} b;
};

union hc_r1 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_atten_button_pressed_en:1;
		unsigned cfg_pwr_fault_det_en:1;
		unsigned cfg_mrl_sensor_chged_en:1;
		unsigned cfg_pre_det_chged_en:1;
		unsigned cfg_hp_int_en:1;
		unsigned cfg_cmd_cpled_int_en:1;
		unsigned cfg_dll_state_chged_en:1;
		unsigned cfg_hp_slot_ctrl_access:1;
		unsigned flush_done:1;
		unsigned wake:1;
		unsigned reserved:22;
	} b;
};

union hc_r2 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned rtlh_rfc_upd:1;
		unsigned cfg_eml_control:1;
		unsigned cfg_pcie_cap_int_msg_num:5;
		unsigned cfg_crs_sw_vis_en:1;
		unsigned cfg_pme_msi:1;
		unsigned cfg_pme_int:1;
		unsigned cfg_aer_int_msg_num:5;
		unsigned cfg_aer_rc_err_msi:1;
		unsigned cfg_aer_rc_err_int:1;
		unsigned cfg_sys_err_rc:1;
		unsigned cfg_pwr_ctrler_ctrl:1;
		unsigned cfg_atten_ind:1;
		unsigned cfg_pwr_ind:1;
		unsigned reserved:11;
	} b;
};

union hc_r3 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned rtlh_rfc_data:32;
	} b;
};

union hc_r4 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar0_start_low:32;
	} b;
};

union hc_r5 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar0_start_high:32;
	} b;
};

union hc_r6 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar0_limit_low:32;
	} b;
};

union hc_r7 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar0_limit_high:32;
	} b;
};

union hc_r8 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar1_start:32;
	} b;
};

union hc_r9 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_bar1_limit:32;
	} b;
};

union hc_r10 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_exp_rom_start:32;
	} b;
};

union hc_r11 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_exp_rom_limit:32;
	} b;
};

union hc_r12 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned radm_xfer_pending:1;
		unsigned edma_xfer_pending:1;
		unsigned brdg_dbi_xfer_pending:1;
		unsigned brdg_slv_xfer_pending:1;
		unsigned link_req_rst_not:1;
		unsigned smlh_req_rst_not:1;
		unsigned smlh_link_up:1;
		unsigned pm_curnt_state:3;
		unsigned smlh_ltssm_state:6;
		unsigned rdlh_link_up:1;
		unsigned reserved:15;
	} b;
};

union hc_r13 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_pbus_dev_num:5;
		unsigned cfg_pbus_num:8;
		unsigned pm_status:1;
		unsigned cfg_l1sub_en:1;
		unsigned pm_linkst_in_l1sub:1;
		unsigned pm_linkst_l2_exit:1;
		unsigned pm_linkst_in_l2:1;
		unsigned pm_linkst_in_l1:1;
		unsigned pm_linkst_in_l0s:1;
		unsigned pm_pme_en:1;
		unsigned aux_pm_en:1;
		unsigned pm_dstate:3;
		unsigned reserved:7;
	} b;
};


union hc_r14 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_max_rd_req_size:3;
		unsigned cfg_mem_space_en:1;
		unsigned cfg_rcb:1;
		unsigned cfg_max_payload_size:3;
		unsigned cfg_2nd_reset:1;
		unsigned cfg_subbus_num:8;
		unsigned cfg_2ndbus_num:8;
		unsigned cfg_bus_master_en:1;
		unsigned pm_xtlh_block_tlp:1;
		unsigned reserved:5;
	} b;
};

union hc_r15 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned trgt_lookup_empty:1;
		unsigned trgt_lookup_id:8;
		unsigned trgt_timeout_lookup_id:8;
		unsigned trgt_timeout_cpl_len:12;
		unsigned trgt_timeout_cpl_attr:2;
		unsigned trgt_timeout_cpl_tc:1;
	} b;
};

union hc_r16 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cfg_relax_order_en:1;
		unsigned cfg_no_snoop_en:1;
		unsigned cfg_int_disable:1;
		unsigned cfg_send_f_err:1;
		unsigned cfg_send_nf_err:1;
		unsigned cfg_send_cor_err:1;
		unsigned radm_timeout_cpl_tag:8;
		unsigned radm_timeout_cpl_len:12;
		unsigned radm_timeout_cpl_attr:2;
		unsigned radm_timeout_cpl_tc:3;
		unsigned radm_timeout_func_num:1;
	} b;
};

union hc_r17 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned phy_mac_rxdatavalid:1;
		unsigned mac_phy_txswing:1;
		unsigned mac_phy_txmargin:3;
		unsigned mac_phy_txdeemph:2;
		unsigned mac_phy_rate:1;
		unsigned mac_phy_rxstandby:1;
		unsigned mac_phy_pclk_rate:3;
		unsigned mac_phy_width:2;
		unsigned mac_phy_rxpolarity:1;
		unsigned mac_phy_txcompliance:1;
		unsigned mac_phy_txelecidle:1;
		unsigned mac_phy_txdetectrx_loopback:1;
		unsigned mac_phy_txdatavalid:1;
		unsigned mac_phy_elasticbuffermode:1;
		unsigned mac_phy_txdatak:2;
		unsigned phy_mac_rxstandbystatus:1;
		unsigned phy_mac_rxstatus:3;
		unsigned phy_mac_rxvalid:1;
		unsigned phy_mac_rxdatak:2;
		unsigned phy_mac_phystatus:1;
		unsigned phy_mac_rxelecidle:1;
		unsigned reserved:1;
	} b;
};

union hc_r18 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned msi_ctrl_io:32;
	} b;
};

union hc_r19 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned msi_ctrl_int_vec:8;
		unsigned reserved:24;
	} b;
};

union hc_r20 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cxpl_debug_info_low:32;
	} b;
};

union hc_r21 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cxpl_debug_info_high:32;
	} b;
};

union hc_r22 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned cxpl_debug_info_ei:16;
		unsigned reserved:16;
	} b;
};

union hc_r23 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned radm_vendor_msg:1;
		unsigned reserved:31;
	} b;
};

union hc_r24 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned radm_msg_payload_low:32;
	} b;
};

union hc_r25 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned radm_msg_payload_high:32;
	} b;
};

union hc_r26 {
	/** raw register data */
	uint32_t d32;
	/** register bits */
	struct {
		unsigned radm_msg_req_id:16;
		unsigned reserved:16;
	} b;
};

struct pcie_hc_aml_regs {
	volatile uint32_t hc_r0;
	volatile uint32_t hc_r1;
	volatile uint32_t hc_r2;
	volatile uint32_t hc_r3;
	volatile uint32_t hc_r4;
	volatile uint32_t hc_r5;
	volatile uint32_t hc_r6;
	volatile uint32_t hc_r7;
	volatile uint32_t hc_r8;
	volatile uint32_t hc_r9;
	volatile uint32_t hc_r10;
	volatile uint32_t hc_r11;
	volatile uint32_t hc_r12;
	volatile uint32_t hc_r13;
	volatile uint32_t hc_r14;
	volatile uint32_t hc_r15;
	volatile uint32_t hc_r16;
	volatile uint32_t hc_r17;
	volatile uint32_t hc_r18;
	volatile uint32_t hc_r19;
	volatile uint32_t hc_r20;
	volatile uint32_t hc_r21;
	volatile uint32_t hc_r22;
	volatile uint32_t hc_r23;
	volatile uint32_t hc_r24;
	volatile uint32_t hc_r25;
	volatile uint32_t hc_r26;
};

u8	iatu_unroll_enabled;
int pcie_type = 0;

#define PCI_ACCESS_READ  0
#define PCI_ACCESS_WRITE 1

#define AMLOGIC_PCIE_A_DBI_ADDR	PCIE_A_BASE_ADDR
#define AMLOGIC_PCIE_B_DBI_ADDR	PCIE_B_BASE_ADDR

/* iATU registers */
#define PCIE_ATU_VIEWPORT		0x900
#define PCIE_ATU_REGION_INBOUND		(0x1 << 31)
#define PCIE_ATU_REGION_OUTBOUND	(0x0 << 31)
#define PCIE_ATU_REGION_INDEX1		(0x1 << 0)
#define PCIE_ATU_REGION_INDEX0		(0x0 << 0)
#define PCIE_ATU_CR1			0x904
#define PCIE_ATU_TYPE_MEM		(0x0 << 0)
#define PCIE_ATU_TYPE_IO		(0x2 << 0)
#define PCIE_ATU_TYPE_CFG0		(0x4 << 0)
#define PCIE_ATU_TYPE_CFG1		(0x5 << 0)
#define PCIE_ATU_CR2			0x908
#define PCIE_ATU_ENABLE			(0x1 << 31)
#define PCIE_ATU_BAR_MODE_ENABLE	(0x1 << 30)
#define PCIE_ATU_LOWER_BASE		0x90C
#define PCIE_ATU_UPPER_BASE		0x910
#define PCIE_ATU_LIMIT			0x914
#define PCIE_ATU_LOWER_TARGET		0x918
#define PCIE_ATU_BUS(x)			(((x) & 0xff) << 24)
#define PCIE_ATU_DEV(x)			(((x) & 0x1f) << 19)
#define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
#define PCIE_ATU_UPPER_TARGET		0x91C

#define PCIE_GET_ATU_OUTB_UNR_REG_OFFSET(region)  ((0x3 << 20) | (region << 9))
/*
 * iATU Unroll-specific register definitions
 * From 4.80 core version the address translation will be made by unroll
 */
#define PCIE_ATU_UNR_REGION_CTRL1	0x00
#define PCIE_ATU_UNR_REGION_CTRL2	0x04
#define PCIE_ATU_UNR_LOWER_BASE		0x08
#define PCIE_ATU_UNR_UPPER_BASE		0x0C
#define PCIE_ATU_UNR_LIMIT		0x10
#define PCIE_ATU_UNR_LOWER_TARGET	0x14
#define PCIE_ATU_UNR_UPPER_TARGET	0x18

#define LINK_WAIT_MAX_IATU_RETRIES	5

#define P_RESET0_LEVEL    (volatile uint32_t *)0xffd01080
#define PCIE_PHY_BASE    (volatile uint32_t *)0xff644000
#define PCIE_CTRL_0		(volatile uint32_t *)0xff63c0d8
#define PCIE_CTRL_1		(volatile uint32_t *)0xff63c0dc
#define PCIE_CTRL_2		(volatile uint32_t *)0xff63c0e0
#define PCIE_CTRL_3		(volatile uint32_t *)0xff63c0e4
#define PCIE_CTRL_4		(volatile uint32_t *)0xff63c0e8
#define PCIE_CTRL_5		(volatile uint32_t *)0xff63c0ec
#define PCIE_CTRL_6		(volatile uint32_t *)0xff63c0f0
#define MIPI_CTRL		(volatile uint32_t *)0xff63c000
#define CLK81_HIGH		(volatile uint32_t *)0xff63c144
#define CLK81_LOW		(volatile uint32_t *)0xff63c140

#endif
