/* **************************************************************************
 *
 *  Copyright (C) 2011 AMLOGIC, INC.
 *
 *
 * remark: copy from @ trunk/drivers/usb/host  by Haixiang.Bao 2011.10.17
 *              haixiang.bao@amlogic.com
 *
 *
 ****************************************************************************/
#ifndef __DWC_OTG_HCD_H__
#define __DWC_OTG_HCD_H__
#include <asm/arch/io.h>

#define DWC_DRIVER_VERSION	"2.94 6-June-2012"
//#define DEBUG

/** When debug level has the DBG_CIL bit set, display CIL Debug messages. */
#define DBG_CIL		(0x2)
/** When debug level has the DBG_CILV bit set, display CIL Verbose debug
 * messages */
#define DBG_CILV	(0x20)
/**  When debug level has the DBG_PCD bit set, display PCD (Device) debug
 *  messages */
#define DBG_PCD		(0x4)	
/** When debug level has the DBG_PCDV set, display PCD (Device) Verbose debug
 * messages */
#define DBG_PCDV	(0x40)	
/** When debug level has the DBG_HCD bit set, display Host debug messages */
#define DBG_HCD		(0x8)	
/** When debug level has the DBG_HCDV bit set, display Verbose Host debug
 * messages */
#define DBG_HCDV	(0x80)
/** When debug level has the DBG_HCD_URB bit set, display enqueued URBs in host
 *  mode. */
#define DBG_HCD_URB	(0x800)

/** When debug level has any bit set, display debug messages */
#define DBG_ANY		(0xFF)

/** All debug messages off */
#define DBG_OFF		0
//#define DEBUG
#undef DEBUG
#ifdef DEBUG
#define DBG(fmt, args...)	\
		printf("dwc_otg: %s: " fmt "\n" , __FUNCTION__ , ## args)

# define DWC_DEBUGPL(lvl, x...) do{printf( x ); }while(0)

#else
#define DBG(fmt, args...)	do {} while (0)
# define DWC_DEBUGPL(lvl, x...) do{}while(0)

#endif

#ifdef VERBOSE
#    define VDBG		DBG
#else
#    define VDBG(fmt, args...)	do {} while (0)
#endif

#define ERR(fmt, args...)	\
		printf("dwc_otg: %s: " fmt "\n" , __FUNCTION__ , ## args)
#define WARN(fmt, args...)	\
		printf("dwc_otg: %s: " fmt "\n" , __FUNCTION__ , ## args)
#define INFO(fmt, args...)	\
		printf("dwc_otg: " fmt "\n" , ## args)

/* ------------------------------------------------------------------------- */
/*
 * Reasons for halting a host channel.
 */
typedef enum dwc_otg_halt_status 
{
	DWC_OTG_HC_XFER_NO_HALT_STATUS,
	DWC_OTG_HC_XFER_COMPLETE,
	DWC_OTG_HC_XFER_URB_COMPLETE,
	DWC_OTG_HC_XFER_ACK,
	DWC_OTG_HC_XFER_NAK,
	DWC_OTG_HC_XFER_NYET,
	DWC_OTG_HC_XFER_STALL,
	DWC_OTG_HC_XFER_XACT_ERR,
	DWC_OTG_HC_XFER_FRAME_OVERRUN,
	DWC_OTG_HC_XFER_BABBLE_ERR,
	DWC_OTG_HC_XFER_DATA_TOGGLE_ERR,
	DWC_OTG_HC_XFER_AHB_ERR,
	DWC_OTG_HC_XFER_PERIODIC_INCOMPLETE,
	DWC_OTG_HC_XFER_URB_DEQUEUE
} dwc_otg_halt_status_e;

/**
 * Host channel descriptor. This structure represents the state of a single
 * host channel when acting in host mode. It contains the data items needed to
 * transfer packets to an endpoint via a host channel.
 */
typedef struct dwc_hc 
{
	/** Host channel number used for register address lookup */
	uint8_t	 hc_num;

	/** Device to access */
	unsigned dev_addr : 7;

	/** EP to access */
	unsigned ep_num : 4;

	/** EP direction. 0: OUT, 1: IN */
	unsigned ep_is_in : 1;

	/**
	 * EP speed.
	 * One of the following values:
	 *	- DWC_OTG_EP_SPEED_LOW
	 *	- DWC_OTG_EP_SPEED_FULL
	 *	- DWC_OTG_EP_SPEED_HIGH
	 */
	unsigned speed : 2;
#define DWC_OTG_EP_SPEED_LOW	0
#define DWC_OTG_EP_SPEED_FULL	1
#define DWC_OTG_EP_SPEED_HIGH	2	

	/**
	 * Endpoint type.
	 * One of the following values:
	 *	- DWC_OTG_EP_TYPE_CONTROL: 0
	 *	- DWC_OTG_EP_TYPE_ISOC: 1
	 *	- DWC_OTG_EP_TYPE_BULK: 2
	 *	- DWC_OTG_EP_TYPE_INTR: 3
	 */
	unsigned ep_type : 2;

	/** Max packet size in bytes */
	unsigned max_packet : 11;

	/**
	 * PID for initial transaction.
	 * 0: DATA0,<br>
	 * 1: DATA2,<br>
	 * 2: DATA1,<br>
	 * 3: MDATA (non-Control EP),
	 *	  SETUP (Control EP)
	 */
	unsigned data_pid_start : 2;
#define DWC_OTG_HC_PID_DATA0 0
#define DWC_OTG_HC_PID_DATA2 1
#define DWC_OTG_HC_PID_DATA1 2
#define DWC_OTG_HC_PID_MDATA 3
#define DWC_OTG_HC_PID_SETUP 3

	/** Number of periodic transactions per (micro)frame */
	unsigned multi_count: 2;

	/** @name Transfer State */
	/** @{ */

	/** Pointer to the current transfer buffer position. */
	uint8_t *xfer_buff;
	/** Total number of bytes to transfer. */
	uint32_t xfer_len;
	/** Number of bytes transferred so far. */
	uint32_t xfer_count;
	/** Packet count at start of transfer.*/
	uint16_t start_pkt_count;

	/**
	 * Flag to indicate whether the transfer has been started. Set to 1 if
	 * it has been started, 0 otherwise.
	 */
	uint8_t xfer_started;

	/**
	 * Set to 1 to indicate that a PING request should be issued on this
	 * channel. If 0, process normally.
	 */
	uint8_t do_ping;

	/**
	 * Set to 1 to indicate that the error count for this transaction is
	 * non-zero. Set to 0 if the error count is 0.
	 */
	uint8_t error_state;

	/**
	 * Set to 1 to indicate that this channel should be halted the next
	 * time a request is queued for the channel. This is necessary in
	 * slave mode if no request queue space is available when an attempt
	 * is made to halt the channel.
	 */
	uint8_t halt_on_queue;

	/**
	 * Set to 1 if the host channel has been halted, but the core is not
	 * finished flushing queued requests. Otherwise 0.
	 */
	uint8_t halt_pending;

	/**
	 * Reason for halting the host channel.
	 */
	dwc_otg_halt_status_e	halt_status;

	/*
	 * Split settings for the host channel
	 */
	uint8_t do_split;		   /**< Enable split for the channel */
	uint8_t complete_split;	   /**< Enable complete split */
	uint8_t hub_addr;		   /**< Address of high speed hub */

	uint8_t port_addr;		   /**< Port of the low/full speed device */
	/** Split transaction position 
	 * One of the following values:
	 *	  - DWC_HCSPLIT_XACTPOS_MID 
	 *	  - DWC_HCSPLIT_XACTPOS_BEGIN
	 *	  - DWC_HCSPLIT_XACTPOS_END
	 *	  - DWC_HCSPLIT_XACTPOS_ALL */
	uint8_t xact_pos;

	/** Set when the host channel does a short read. */
	uint8_t short_read;

	/**
	 * Number of requests issued for this channel since it was assigned to
	 * the current transfer (not counting PINGs).
	 */
	uint8_t requests;

	/**
	 * Queue Head for the transfer being processed by this channel.
	 */
	struct dwc_otg_qh *qh;

	/** @} */

	/** Entry in list of host channels. */
	struct list_head	hc_list_entry;
} dwc_hc_t;
#define DWC_OTG_CAP_PARAM_HNP_SRP_CAPABLE 0
#define DWC_OTG_CAP_PARAM_SRP_ONLY_CAPABLE 1
#define DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE 2

#define DWC_PHY_TYPE_PARAM_FS 0
#define DWC_PHY_TYPE_PARAM_UTMI 1
#define DWC_PHY_TYPE_PARAM_ULPI 2

#define DWC_SPEED_PARAM_HIGH 0
#define DWC_SPEED_PARAM_FULL 1
/**
 * The following parameters may be specified when starting the module. These
 * parameters define how the DWC_otg controller should be configured.
 */
typedef struct dwc_otg_core_params {
	int32_t opt;

	/**
	 * Specifies the OTG capabilities. The driver will automatically
	 * detect the value for this parameter if none is specified.
	 * 0 - HNP and SRP capable (default)
	 * 1 - SRP Only capable
	 * 2 - No HNP/SRP capable
	 */
	int32_t otg_cap;

	/**
	 * Specifies whether to use slave or DMA mode for accessing the data
	 * FIFOs. The driver will automatically detect the value for this
	 * parameter if none is specified.
	 * 0 - Slave
	 * 1 - DMA (default, if available)
	 */
	int32_t dma_enable;

	/**
	 * When DMA mode is enabled specifies whether to use address DMA or DMA 
	 * Descriptor mode for accessing the data FIFOs in device mode. The driver 
	 * will automatically detect the value for this if none is specified.
	 * 0 - address DMA
	 * 1 - DMA Descriptor(default, if available)
	 */
	int32_t dma_desc_enable;
	/** The DMA Burst size (applicable only for External DMA
	 * Mode). 1, 4, 8 16, 32, 64, 128, 256 (default 32)
	 */
	int32_t dma_burst_size;	/* Translate this to GAHBCFG values */

	/**
	 * Specifies the maximum speed of operation in host and device mode.
	 * The actual speed depends on the speed of the attached device and
	 * the value of phy_type. The actual speed depends on the speed of the
	 * attached device.
	 * 0 - High Speed (default)
	 * 1 - Full Speed
	 */
	int32_t speed;
	/** Specifies whether low power mode is supported when attached
	 *	to a Full Speed or Low Speed device in host mode.
	 * 0 - Don't support low power mode (default)
	 * 1 - Support low power mode
	 */
	int32_t host_support_fs_ls_low_power;

	/** Specifies the PHY clock rate in low power mode when connected to a
	 * Low Speed device in host mode. This parameter is applicable only if
	 * HOST_SUPPORT_FS_LS_LOW_POWER is enabled. If PHY_TYPE is set to FS
	 * then defaults to 6 MHZ otherwise 48 MHZ.
	 *
	 * 0 - 48 MHz
	 * 1 - 6 MHz
	 */
	int32_t host_ls_low_power_phy_clk;

	/**
	 * 0 - Use cC FIFO size parameters
	 * 1 - Allow dynamic FIFO sizing (default)
	 */
	int32_t enable_dynamic_fifo;

	/** Total number of 4-byte words in the data FIFO memory. This
	 * memory includes the Rx FIFO, non-periodic Tx FIFO, and periodic
	 * Tx FIFOs.
	 * 32 to 32768 (default 8192)
	 * Note: The total FIFO memory depth in the FPGA configuration is 8192.
	 */
	int32_t data_fifo_size;

	/** Number of 4-byte words in the Rx FIFO in device mode when dynamic
	 * FIFO sizing is enabled.
	 * 16 to 32768 (default 1064)
	 */
	int32_t dev_rx_fifo_size;

	/** Number of 4-byte words in the non-periodic Tx FIFO in device mode
	 * when dynamic FIFO sizing is enabled.
	 * 16 to 32768 (default 1024)
	 */
	int32_t dev_nperio_tx_fifo_size;

	/** Number of 4-byte words in each of the periodic Tx FIFOs in device
	 * mode when dynamic FIFO sizing is enabled.
	 * 4 to 768 (default 256)
	 */
	uint32_t dev_perio_tx_fifo_size[MAX_PERIO_FIFOS];

	/** Number of 4-byte words in the Rx FIFO in host mode when dynamic
	 * FIFO sizing is enabled.
	 * 16 to 32768 (default 1024)
	 */
	int32_t host_rx_fifo_size;

	/** Number of 4-byte words in the non-periodic Tx FIFO in host mode
	 * when Dynamic FIFO sizing is enabled in the core.
	 * 16 to 32768 (default 1024)
	 */
	int32_t host_nperio_tx_fifo_size;

	/** Number of 4-byte words in the host periodic Tx FIFO when dynamic
	 * FIFO sizing is enabled.
	 * 16 to 32768 (default 1024)
	 */
	int32_t host_perio_tx_fifo_size;

	/** The maximum transfer size supported in bytes.
	 * 2047 to 65,535  (default 65,535)
	 */
	int32_t max_transfer_size;

	/** The maximum number of packets in a transfer.
	 * 15 to 511  (default 511)
	 */
	int32_t max_packet_count;

	/** The number of host channel registers to use.
	 * 1 to 16 (default 12)
	 * Note: The FPGA configuration supports a maximum of 12 host channels.
	 */
	int32_t host_channels;

	/** The number of endpoints in addition to EP0 available for device
	 * mode operations.
	 * 1 to 15 (default 6 IN and OUT)
	 * Note: The FPGA configuration supports a maximum of 6 IN and OUT
	 * endpoints in addition to EP0.
	 */
	int32_t dev_endpoints;

		/**
		 * Specifies the type of PHY interface to use. By default, the driver
		 * will automatically detect the phy_type.
		 *
		 * 0 - Full Speed PHY
		 * 1 - UTMI+ (default)
		 * 2 - ULPI
		 */
	int32_t phy_type;

	/**
	 * Specifies the UTMI+ Data Width. This parameter is
	 * applicable for a PHY_TYPE of UTMI+ or ULPI. (For a ULPI
	 * PHY_TYPE, this parameter indicates the data width between
	 * the MAC and the ULPI Wrapper.) Also, this parameter is
	 * applicable only if the OTG_HSPHY_WIDTH cC parameter was set
	 * to "8 and 16 bits", meaning that the core has been
	 * configured to work at either data path width.
	 *
	 * 8 or 16 bits (default 16)
	 */
	int32_t phy_utmi_width;

	/**
	 * Specifies whether the ULPI operates at double or single
	 * data rate. This parameter is only applicable if PHY_TYPE is
	 * ULPI.
	 *
	 * 0 - single data rate ULPI interface with 8 bit wide data
	 * bus (default)
	 * 1 - double data rate ULPI interface with 4 bit wide data
	 * bus
	 */
	int32_t phy_ulpi_ddr;

	/**
	 * Specifies whether to use the internal or external supply to
	 * drive the vbus with a ULPI phy.
	 */
	int32_t phy_ulpi_ext_vbus;

	/**
	 * Specifies whether to use the I2Cinterface for full speed PHY. This
	 * parameter is only applicable if PHY_TYPE is FS.
	 * 0 - No (default)
	 * 1 - Yes
	 */
	int32_t i2c_enable;

	int32_t ulpi_fs_ls;

	int32_t ts_dline;

	/**
	 * Specifies whether dedicated transmit FIFOs are
	 * enabled for non periodic IN endpoints in device mode
	 * 0 - No
	 * 1 - Yes
	 */
	int32_t en_multiple_tx_fifo;

	/** Number of 4-byte words in each of the Tx FIFOs in device
	 * mode when dynamic FIFO sizing is enabled.
	 * 4 to 768 (default 256)
	 */
	uint32_t dev_tx_fifo_size[MAX_TX_FIFOS];

	/** Thresholding enable flag-
	 * bit 0 - enable non-ISO Tx thresholding
	 * bit 1 - enable ISO Tx thresholding
	 * bit 2 - enable Rx thresholding
	 */
	uint32_t thr_ctl;

	/** Thresholding length for Tx
	 *	FIFOs in 32 bit DWORDs
	 */
	uint32_t tx_thr_length;

	/** Thresholding length for Rx
	 *	FIFOs in 32 bit DWORDs
	 */
	uint32_t rx_thr_length;

	/**
	 * Specifies whether LPM (Link Power Management) support is enabled
	 */
	int32_t lpm_enable;

	/** Per Transfer Interrupt
	 *	mode enable flag
	 * 1 - Enabled
	 * 0 - Disabled
	 */
	int32_t pti_enable;

	/** Multi Processor Interrupt
	 *	mode enable flag
	 * 1 - Enabled
	 * 0 - Disabled
	 */
	int32_t mpi_enable;

	/** IS_USB Capability
	 * 1 - Enabled
	 * 0 - Disabled
	 */
	int32_t ic_usb_cap;

	/** AHB Threshold Ratio
	 * 2'b00 AHB Threshold = 	MAC Threshold
	 * 2'b01 AHB Threshold = 1/2 	MAC Threshold
	 * 2'b10 AHB Threshold = 1/4	MAC Threshold
	 * 2'b11 AHB Threshold = 1/8	MAC Threshold
	 */
	int32_t ahb_thr_ratio;

	/** ADP Support
	 * 1 - Enabled
	 * 0 - Disabled
	 */
	int32_t adp_supp_enable;

	/** HFIR Reload Control
	 * 0 - The HFIR cannot be reloaded dynamically.
	 * 1 - Allow dynamic reloading of the HFIR register during runtime.
	 */
	int32_t reload_ctl;

	/** DCFG: Enable device Out NAK 
	 * 0 - The core does not set NAK after Bulk Out transfer complete.
	 * 1 - The core sets NAK after Bulk OUT transfer complete.
	 */
	int32_t dev_out_nak;

	/** DCFG: Enable Continue on BNA 
	 * After receiving BNA interrupt the core disables the endpoint,when the
	 * endpoint is re-enabled by the application the core starts processing 
	 * 0 - from the DOEPDMA descriptor
	 * 1 - from the descriptor which received the BNA.
	 */
	int32_t cont_on_bna;

	/** GAHBCFG: AHB Single Support 
	 * This bit when programmed supports SINGLE transfers for remainder 
	 * data in a transfer for DMA mode of operation.
	 * 0 - in this case the remainder data will be sent using INCR burst size.
	 * 1 - in this case the remainder data will be sent using SINGLE burst size.
	 */
	int32_t ahb_single;

	/** Core Power down mode
	 * 0 - No Power Down is enabled
	 * 1 - Reserved
	 * 2 - Complete Power Down (Hibernation)
	 */
	int32_t power_down;

	/** OTG revision supported
	 * 0 - OTG 1.3 revision
	 * 1 - OTG 2.0 revision
	 */
	int32_t otg_ver;

} dwc_otg_core_params_t;
/**
 * The <code>dwc_otg_core_if</code> structure contains information needed to manage
 * the DWC_otg controller acting in either host or device mode. It
 * represents the programming view of the controller as a whole.
 */
typedef struct dwc_otg_core_if 
{
	/** Parameters that define how the core should be configured.*/
	dwc_otg_core_params_t	   *core_params;

	/** Core Global registers starting at offset 000h. */
	dwc_otg_core_global_regs_t *core_global_regs;
  
	/** Device-specific information */
	dwc_otg_dev_if_t		   *dev_if;
	/** Host-specific information */
	dwc_otg_host_if_t		   *host_if;

	/*
	 * Set to 1 if the core PHY interface bits in USBCFG have been
	 * initialized.
	 */
	uint8_t phy_init_done;

	/*
	 * SRP Success flag, set by srp success interrupt in FS I2C mode
	 */
	uint8_t srp_success;
	uint8_t srp_timer_started;

	/* Common configuration information */
	/** Power and Clock Gating Control Register */
	volatile uint32_t *pcgcctl;
#define DWC_OTG_PCGCCTL_OFFSET 0xE00

	/** Push/pop addresses for endpoints or host channels.*/
	uint32_t *data_fifo[MAX_EPS_CHANNELS];
#define DWC_OTG_DATA_FIFO_OFFSET 0x1000
#define DWC_OTG_DATA_FIFO_SIZE 0x1000

	/** Total RAM for FIFOs (Bytes) */
	uint16_t total_fifo_size;
	/** Size of Rx FIFO (Bytes) */
	uint16_t rx_fifo_size;
	/** Size of Non-periodic Tx FIFO (Bytes) */
	uint16_t nperio_tx_fifo_size;
		
		
	/** 1 if DMA is enabled, 0 otherwise. */
	uint8_t dma_enable;

	/** 1 if dedicated Tx FIFOs are enabled, 0 otherwise. */
	uint8_t en_multiple_tx_fifo;

	/** Set to 1 if multiple packets of a high-bandwidth transfer is in
	 * process of being queued */
	uint8_t queuing_high_bandwidth;

	/** Hardware Configuration -- stored here for convenience.*/
	hwcfg1_data_t hwcfg1;
	hwcfg2_data_t hwcfg2;
	hwcfg3_data_t hwcfg3;
	hwcfg4_data_t hwcfg4;

	/** The operational State, during transations
	 * (a_host>>a_peripherial and b_device=>b_host) this may not
	 * match the core but allows the software to determine
	 * transitions.
	 */
	uint8_t op_state;
		
	/**
	 * Set to 1 if the HCD needs to be restarted on a session request
	 * interrupt. This is required if no connector ID status change has
	 * occurred since the HCD was last disconnected.
	 */
	uint8_t restart_hcd_on_session_req;

	/** HCD callbacks */
	/** A-Device is a_host */
#define A_HOST		(1)
	/** A-Device is a_suspend */
#define A_SUSPEND	(2)
	/** A-Device is a_peripherial */
#define A_PERIPHERAL	(3)
	/** B-Device is operating as a Peripheral. */
#define B_PERIPHERAL	(4)
	/** B-Device is operating as a Host. */
#define B_HOST		(5)		   
#define DWC_OTG_MAX_TRANSFER_SIZE  0x10000
    char *temp_buffer;
    int transfer_size;
 
 	 /* Set VBus Power though GPIO */
	 void (* set_vbus_power)(char is_power_on);
    
#if 0
	/** HCD callbacks */
	struct dwc_otg_cil_callbacks *hcd_cb;
	/** PCD callbacks */
	struct dwc_otg_cil_callbacks *pcd_cb;		 
#endif
	/** Device mode Periodic Tx FIFO Mask */
	uint32_t p_tx_msk;
	/** Device mode Periodic Tx FIFO Mask */
	uint32_t tx_msk;

	uint32_t otg_ver;
#if 0	
#ifdef DEBUG
	uint32_t		start_hcchar_val[MAX_EPS_CHANNELS];

	hc_xfer_info_t		hc_xfer_info[MAX_EPS_CHANNELS];
	struct timer_list	hc_xfer_timer[MAX_EPS_CHANNELS];

	uint32_t		hfnum_7_samples;
	uint64_t		hfnum_7_frrem_accum;
	uint32_t		hfnum_0_samples;
	uint64_t		hfnum_0_frrem_accum;
	uint32_t		hfnum_other_samples;
	uint64_t		hfnum_other_frrem_accum;
#endif	
#endif

} dwc_otg_core_if_t;
/**
 * This structure is a wrapper that encapsulates the driver components used to
 * manage a single DWC_otg controller.
 */
typedef struct dwc_otg_device
{
	/** Base address returned from ioremap() */
	void *base;


	/** Pointer to the core interface structure. */
	dwc_otg_core_if_t *core_if;

	/** Register offset for Diagnostic API.*/
	uint32_t reg_offset;
		
	/** Pointer to the HCD structure. */
	struct dwc_otg_hcd *hcd;

	/** Flag to indicate whether the common IRQ handler is installed. */
	uint8_t common_irq_installed;
  
  int disabled;

	int index;
} dwc_otg_device_t;
/**
 * Reads the content of a register.
 *
 * @param _reg address of register to read.
 * @return contents of the register.
 *

 * Usage:<br>
 * <code>uint32_t dev_ctl = dwc_read_reg32(&dev_regs->dctl);</code> 
 */
static __inline__ uint32_t dwc_read_reg32( volatile uint32_t *_reg) 
{
        return readl(_reg);
};

/** 
 * Writes a register with a 32 bit value.
 *
 * @param _reg address of register to read.
 * @param _value to write to _reg.
 *
 * Usage:<br>
 * <code>dwc_write_reg32(&dev_regs->dctl, 0); </code>
 */
static __inline__ void dwc_write_reg32( volatile uint32_t *_reg, const uint32_t _value) 
{
        writel( _value, _reg );
};
static __inline__
 void dwc_modify_reg32( volatile uint32_t *_reg, const uint32_t _clear_mask, const uint32_t _set_mask) 
{
        writel( (readl(_reg) & ~_clear_mask) | _set_mask, _reg );  
};
/**
 * This function returns the mode of the operation, host or device.
 *
 * @return 0 - Device Mode, 1 - Host Mode 
 */
static inline uint32_t dwc_otg_mode(dwc_otg_core_if_t *_core_if) 
{
	return (dwc_read_reg32( &_core_if->core_global_regs->gintsts ) & 0x1);
}

static inline uint8_t dwc_otg_is_device_mode(dwc_otg_core_if_t *_core_if) 
{
	return (dwc_otg_mode(_core_if) != DWC_HOST_MODE);
}
static inline uint8_t dwc_otg_is_host_mode(dwc_otg_core_if_t *_core_if) 
{
	return (dwc_otg_mode(_core_if) == DWC_HOST_MODE);
}


/* --- USB HUB constants (not OHCI-specific; see hub.h) -------------------- */

/* destination of request */
#define RH_INTERFACE               0x01
#define RH_ENDPOINT                0x02
#define RH_OTHER                   0x03

#define RH_CLASS                   0x20
#define RH_VENDOR                  0x40

/* Requests: bRequest << 8 | bmRequestType */
#define RH_GET_STATUS           0x0080
#define RH_CLEAR_FEATURE        0x0100
#define RH_SET_FEATURE          0x0300
#define RH_SET_ADDRESS          0x0500
#define RH_GET_DESCRIPTOR       0x0680
#define RH_SET_DESCRIPTOR       0x0700
#define RH_GET_CONFIGURATION    0x0880
#define RH_SET_CONFIGURATION    0x0900
#define RH_GET_STATE            0x0280
#define RH_GET_INTERFACE        0x0A80
#define RH_SET_INTERFACE        0x0B00
#define RH_SYNC_FRAME           0x0C80
/* Our Vendor Specific Request */
#define RH_SET_EP               0x2000

/* Hub port features */
#define RH_PORT_CONNECTION         0x00
#define RH_PORT_ENABLE             0x01
#define RH_PORT_SUSPEND            0x02
#define RH_PORT_OVER_CURRENT       0x03
#define RH_PORT_RESET              0x04
#define RH_PORT_POWER              0x08
#define RH_PORT_LOW_SPEED          0x09

#define RH_C_PORT_CONNECTION       0x10
#define RH_C_PORT_ENABLE           0x11
#define RH_C_PORT_SUSPEND          0x12
#define RH_C_PORT_OVER_CURRENT     0x13
#define RH_C_PORT_RESET            0x14

/* Hub features */
#define RH_C_HUB_LOCAL_POWER       0x00
#define RH_C_HUB_OVER_CURRENT      0x01

#define RH_DEVICE_REMOTE_WAKEUP    0x00
#define RH_ENDPOINT_STALL          0x01

#define RH_ACK                     0x01
#define RH_REQ_ERR                 -1
#define RH_NACK                    0x00

#endif

