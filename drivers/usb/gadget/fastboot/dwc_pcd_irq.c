/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * USB low level irq routines
 */

#include "usb_boot.h"
#include "usb_ch9.h"
#include "dwc_pcd.h"
#include "dwc_pcd_irq.h"
#include "platform.h"

static void ep0_out_start(void);
static int ep0_complete_request( pcd_struct_t * pcd);

void dwc_otg_flush_fifo(const int _num)
{
	grstctl_t greset = {0};
	u32 count = 0;

	DBG("dwc_otg_flush_tx_fifo: %d\n", _num);
	greset.b.txfflsh = 1;
	greset.b.txfnum = _num;
	dwc_write_reg32(DWC_REG_GRSTCTL, greset.d32);
	do {
		greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
		if (++count > 10000)
			break;
	} while (1 == greset.b.txfflsh);
	/* Wait for 3 PHY Clocks*/
	udelay(1);

	if (!_num)
		return;

	greset.d32 = 0;
	count = 0;

	greset.b.rxfflsh = 1;
	dwc_write_reg32(DWC_REG_GRSTCTL, greset.d32);
	do {
		greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
		if (++count > 10000)
			break;
	} while (1 == greset.b.rxfflsh);
    /* Wait for 3 PHY Clocks*/
	udelay(1);
}

static void dwc_otg_ep_start_transfer(dwc_ep_t *_ep)
{
	depctl_data_t depctl;
	deptsiz_data_t deptsiz;
	u32 epctl_reg, epctltsize_reg;
	u32 ep_num = _ep->num;
	u32 is_in = _ep->is_in;
	u32 ep_mps = _ep->maxpacket;

    _ep->total_len = _ep->xfer_len;

	if (is_in) {
		epctl_reg = DWC_REG_IN_EP_REG(ep_num);
		epctltsize_reg = DWC_REG_IN_EP_TSIZE(ep_num);
	} else {
		epctl_reg = DWC_REG_OUT_EP_REG(ep_num);
		epctltsize_reg = DWC_REG_OUT_EP_TSIZE(ep_num);
	}

	depctl.d32 = dwc_read_reg32(epctl_reg);
	deptsiz.d32 = dwc_read_reg32(epctltsize_reg);

	/* Zero Length Packet? */
	if (0 == _ep->xfer_len) {
		deptsiz.b.xfersize = is_in ? 0 : ep_mps;
		deptsiz.b.pktcnt = 1;
	} else {
		deptsiz.b.pktcnt =
		(_ep->xfer_len + (ep_mps - 1)) /ep_mps;
		if (is_in && _ep->xfer_len < ep_mps)
			deptsiz.b.xfersize = _ep->xfer_len;
		else
			deptsiz.b.xfersize = _ep->xfer_len - _ep->xfer_count;
	}

	/* Fill size and count */
	dwc_write_reg32(epctltsize_reg, deptsiz.d32);

	/* IN endpoint */
	if (is_in) {
		gintmsk_data_t intr_mask = {0};

		/* First clear it from GINTSTS */
		intr_mask.b.nptxfempty = 1;
		dwc_modify_reg32(DWC_REG_GINTSTS, intr_mask.d32, 0);
		dwc_modify_reg32(DWC_REG_GINTMSK, intr_mask.d32, intr_mask.d32);
	}

	/* EP enable */
	depctl.b.cnak = 1;
	depctl.b.epena = 1;
	dwc_write_reg32 (epctl_reg, depctl.d32);
}

void dwc_otg_bulk_ep_activate(dwc_ep_t *ep)
{
	depctl_data_t depctl = {0};
	daint_data_t daintmsk = {0};
	u32 epctl;
	u32 ep_num = ep->num;

	if (ep->is_in) {
		epctl = DWC_REG_IN_EP_REG(ep_num);
		daintmsk.b.inep1 = 1;
	} else {
		epctl = DWC_REG_OUT_EP_REG(ep_num);
		daintmsk.b.outep1 = 1;
	}

	depctl.d32 = dwc_read_reg32(epctl);
	if (!depctl.b.usbactep) {
		depctl.b.mps = BULK_EP_MPS;
		depctl.b.eptype = 2;
		depctl.b.setd0pid = 1;
		depctl.b.txfnum = 0;
		depctl.b.usbactep = 1;

		dwc_write_reg32(epctl, depctl.d32);
	}

	dwc_modify_reg32(DWC_REG_DAINTMSK, 0, daintmsk.d32);

	return;
}

int f_dwc_otg_ep_req_start(pcd_struct_t *pcd, u32 ep_num_1, u32 is_in,struct usb_request *req)
{
	dwc_ep_t *ep;
	int ep_num;
	struct usb_req_flag *req_flag = &gadget_wrapper.req_flag;

	if (ep_num_1 != 0)
		if (is_in)
			ep_num = ep_num_1;
		else {
			ep_num = ep_num_1+1;
		}
	else
		ep_num = ep_num_1;

	ep = &pcd->dwc_eps[ep_num].dwc_ep;

	ep->num = ep_num_1;
	ep->xfer_count = 0;
	ep->sent_zlp = 0;

	/* EP0 Transfer? */
	if (0 == ep_num) {
		switch (pcd->ep0state) {
		case EP0_IN_DATA_PHASE:
			break;
		case EP0_OUT_DATA_PHASE:
			if (req_flag->request_config | (0 == req->length)) {
				/* Work around for SetConfig cmd */
				/* Complete STATUS PHASE */
				ep->is_in = 1;
				pcd->ep0state = EP0_STATUS;
			}
			break;
		default:
			return -1;
		}

		ep->start_xfer_buff = (u8 *)req->buf;
		ep->xfer_buff = (u8 *)req->buf;
		ep->xfer_len = req->length;
		ep->total_len = ep->xfer_len;
		ep->maxpacket = 64;
	} else {
		/* Setup and start the Transfer for Bulk */
		ep->start_xfer_buff = (u8 *)req->buf;
		ep->xfer_buff = (u8 *)req->buf;
		ep->xfer_len = req->length;
		ep->total_len = ep->xfer_len;
		ep->maxpacket = BULK_EP_MPS;
		ep->is_in = (ep_num == BULK_IN_EP_NUM);
		dwc_otg_bulk_ep_activate(ep);
	}

	dwc_otg_ep_start_transfer(ep);

	return 0;
}

static void do_setup_status_phase(pcd_struct_t *_pcd, int is_in)
{
	dwc_ep_t *ep0 = &_pcd->dwc_eps[0].dwc_ep;

	if (_pcd->ep0state == EP0_STALL)
		return;

	_pcd->ep0state = EP0_STATUS;

	DBG( "EP0 IN ZLP\n");
	ep0->xfer_len = 0;
	ep0->xfer_count = 0;
	ep0->is_in = is_in;
	ep0->num = 0;

	dwc_otg_ep_start_transfer( ep0 );

	/* Prepare for more SETUP Packets */
	ep0_out_start();
}


static void pcd_setup(pcd_struct_t *_pcd)
{
	struct usb_ctrlrequest	ctrl = _pcd->setup_pkt.req;
	struct usb_request *req = &gadget_wrapper.req;
	struct usb_req_flag *req_flag = &gadget_wrapper.req_flag;
	struct usb_gadget_driver *driver = gadget_wrapper.driver;
	struct usb_gadget *gadget = &gadget_wrapper.gadget;
	dwc_ep_t	*ep0 = &_pcd->dwc_eps[0].dwc_ep;

	if (0 == req_flag->request_enable)
		return;

	_pcd->status = 0;
	req_flag->request_enable = 0;

	if (ctrl.bRequestType & USB_DIR_IN) {
		ep0->is_in = 1;
		_pcd->ep0state = EP0_IN_DATA_PHASE;
	} else {
		ep0->is_in = 0;
		_pcd->ep0state = EP0_OUT_DATA_PHASE;
	}

	if ((ctrl.bRequestType & USB_TYPE_MASK) != USB_TYPE_STANDARD) {
		/* handle non-standard (class/vendor) requests in the gadget driver */
		printf("Vendor requset\n");
		f_dwc_otg_ep_req_start(_pcd, 0, 1, req);
		return;
	}

	/** @todo NGS: Handle bad setup packet? */
	switch (ctrl.bRequest) {
	case USB_REQ_GET_STATUS:
		_pcd->status = 0;
		req->buf = (char *)&_pcd->status;
		req->length = 2;
		f_dwc_otg_ep_req_start(_pcd, 0, 1, req);
		break;
	case USB_REQ_SET_ADDRESS:
		if (USB_RECIP_DEVICE == ctrl.bRequestType) {
			dcfg_data_t dcfg = {0};
			dcfg.b.devaddr = ctrl.wValue;
			dwc_modify_reg32(DWC_REG_DCFG, 0, dcfg.d32);
			do_setup_status_phase(_pcd, 1);
		}
		break;
	case USB_REQ_SET_INTERFACE:
	case USB_REQ_SET_CONFIGURATION:
		/* Configuration changed */
		req_flag->request_config = 1;
	default:
		DBG("Call the Gadget Driver's setup functions\n");
		/* Call the Gadget Driver's setup functions */
		driver->setup(gadget, &ctrl);
		break;
	}

	return;
}

static void handle_ep0(void)
{
	pcd_struct_t * _pcd = &gadget_wrapper.pcd;
	dwc_ep_t * ep0 = &_pcd->dwc_eps[0].dwc_ep;
	struct usb_req_flag *req_flag = &gadget_wrapper.req_flag;

	switch (_pcd->ep0state) {
	case EP0_IDLE:
		req_flag->request_config = 0;
		pcd_setup(_pcd);
		break;

	case EP0_IN_DATA_PHASE:
		if (ep0->xfer_count < ep0->total_len)
			DBG("FIX ME!! dwc_otg_ep0_continue_transfer!\n");
		else
			ep0_complete_request(_pcd);

		break;

	case EP0_OUT_DATA_PHASE:
		ep0_complete_request(_pcd);
		break;

	case EP0_STATUS:
		ep0_complete_request(_pcd);
		/* OUT for next SETUP */
		_pcd->ep0state = EP0_IDLE;
		ep0->stopped = 1;
		ep0->is_in = 0;
		break;

	case EP0_STALL:
	case EP0_DISCONNECT:
	default:
		printf("EP0 state is %d, should not get here pcd_setup()\n", _pcd->ep0state);
		break;
    }

	return;
}

/**
 * This function completes the request for the EP.  If there are
 * additional requests for the EP in the queue they will be started.
 */
static void complete_ep(u32 ep_num, int is_in)
{
	deptsiz_data_t deptsiz;
	pcd_struct_t *pcd = &gadget_wrapper.pcd;
	dwc_ep_t * ep;
	u32 epnum = ep_num;

	if (ep_num) {
		if (!is_in)
			epnum = ep_num + 1;
	}

	ep = &pcd->dwc_eps[epnum].dwc_ep;

	if (is_in) {
		pcd->dwc_eps[epnum].req->actual = ep->xfer_len;
		deptsiz.d32 = dwc_read_reg32(DWC_REG_IN_EP_TSIZE(ep_num));
		if (deptsiz.b.xfersize == 0 && deptsiz.b.pktcnt == 0 &&
                    ep->xfer_count == ep->xfer_len) {
			ep->start_xfer_buff = 0;
			ep->xfer_buff = 0;
			ep->xfer_len = 0;
		}
		pcd->dwc_eps[epnum].req->status = 0;
	} else {
		deptsiz.d32 = dwc_read_reg32(DWC_REG_OUT_EP_TSIZE(ep_num));
		pcd->dwc_eps[epnum].req->actual = ep->xfer_count;
		ep->start_xfer_buff = 0;
		ep->xfer_buff = 0;
		ep->xfer_len = 0;
		pcd->dwc_eps[epnum].req->status = 0;
	}

	if (pcd->dwc_eps[epnum].req->complete) {
		pcd->dwc_eps[epnum].req->complete((struct usb_ep *)(pcd->dwc_eps[epnum].priv), pcd->dwc_eps[epnum].req);
	}
}
/**
 * This function completes the ep0 control transfer.
 */
static int ep0_complete_request(pcd_struct_t * pcd)
{
	deptsiz0_data_t deptsiz;
	dwc_ep_t* ep = &pcd->dwc_eps[0].dwc_ep;
	int ret = 0;

	if (EP0_STATUS == pcd->ep0state) {
		ep->start_xfer_buff = 0;
		ep->xfer_buff = 0;
		ep->xfer_len = 0;
		ep->num = 0;
		ret = 1;
	} else if (0 == ep->xfer_len) {
		ep->xfer_len = 0;
		ep->xfer_count = 0;
		ep->sent_zlp = 1;
		ep->num = 0;
		dwc_otg_ep_start_transfer(ep);
		ret = 1;
	} else if (ep->is_in) {
		deptsiz.d32 = dwc_read_reg32(DWC_REG_IN_EP_TSIZE(0));
		if (0 == deptsiz.b.xfersize) {
			/* Is a Zero Len Packet needed? */
			do_setup_status_phase(pcd, 0);
		}
	} else {
		/* ep0-OUT */
		do_setup_status_phase(pcd, 1);
	}

	return ret;
}
/**
 * This function reads a packet from the Rx FIFO into the destination
 * buffer.  To read SETUP data use dwc_otg_read_setup_packet.
 *
 * @param _dest   Destination buffer for the packet.
 * @param _bytes  Number of bytes to copy to the destination.
 */
static void dwc_otg_read_packet(u8 *_dest, u16 _bytes)
{
	int i;
	u8* pbyte = _dest;
	u32 buffer = 0;
	u64 t_64 = (u64)_dest;

	if (0 == (t_64 & 0x3))
		for (i = 0; i < _bytes; i += 4) {
			*(u32*)t_64 = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
			t_64 += 4;
		}
	else
		for (i = 0; i < _bytes; i++) {
			if (0 == (i % 4))
				buffer = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
			*(u8*)pbyte ++ = buffer;
		}

	return;
}

/**
 * This function writes a packet into the Tx FIFO associated with the
 * EP.  For non-periodic EPs the non-periodic Tx FIFO is written.  For
 * periodic EPs the periodic Tx FIFO associated with the EP is written
 * with all packets for the next micro-frame.
 *
 * @param _core_if Programming view of DWC_otg controller.
 * @param _ep The EP to write packet for.
 * @param _dma Indicates if DMA is being used.
 */
static void dwc_otg_ep_write_packet(dwc_ep_t *_ep, u32 byte_count, u32 dword_count)
{
	u32 i;
	u32 fifo;
	u32 temp_data;
	u8 *data_buff = _ep->xfer_buff;
	u64 t_64 = (u64)_ep->xfer_buff;

	if (_ep->xfer_count >= _ep->xfer_len) {
		ERR("%s() No data for EP%d!!!\n", "dwc_otg_ep_write_packet", _ep->num);
		return;
	}

	fifo = DWC_REG_DATA_FIFO(_ep->num);

	if (t_64 & 0x3) {
		for (i = 0; i < dword_count; i++) {
			temp_data = get_unaligned(data_buff);
			dwc_write_reg32(fifo, temp_data);
			data_buff += 4;
		}
	} else {
		for (i = 0; i < dword_count; i++) {
			temp_data = *(u32*)t_64;
			dwc_write_reg32(fifo, temp_data);
			t_64 += 4;
		}
	}

	_ep->xfer_count += byte_count;
    _ep->xfer_buff += byte_count;

	flush_cpu_cache();

	return;
}
/**
 * This function reads a setup packet from the Rx FIFO into the destination
 * buffer.  This function is called from the Rx Status Queue Level (RxStsQLvl)
 * Interrupt routine when a SETUP packet has been received in Slave mode.
 *
 * @param _core_if Programming view of DWC_otg controller.
 * @param _dest Destination buffer for packet data.
 */
static void dwc_otg_read_setup_packet(u32 *_dest)
{
	/* Get the 8 bytes of a setup transaction data */
	/* Pop 2 DWORDS off the receive data FIFO into memory */
	_dest[0] = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
	_dest[1] = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
}

/**
 * Handler for the IN EP timeout handshake interrupt.
 */
static void handle_in_ep_timeout_intr(u32 _epnum)
{
	dctl_data_t dctl = {0};
	gintmsk_data_t intr_mask = {0};
	pcd_struct_t *pcd = &gadget_wrapper.pcd;
	dwc_ep_t * ep = &pcd->dwc_eps[_epnum].dwc_ep;

	/* Disable the NP Tx Fifo Empty Interrrupt */
	intr_mask.b.nptxfempty = 1;
	dwc_modify_reg32(DWC_REG_GINTMSK, intr_mask.d32, 0);

	/* Enable the Global IN NAK Effective Interrupt */
	intr_mask.b.ginnakeff = 1;
	dwc_modify_reg32(DWC_REG_GINTMSK, 0, intr_mask.d32);

	/* Set Global IN NAK */
	dctl.b.sgnpinnak = 1;
	dwc_modify_reg32(DWC_REG_DCTL,dctl.d32, dctl.d32);

	ep->stopped = 1;
}

/**
 * This function handles the Rx Status Queue Level Interrupt, which
 * indicates that there is a least one packet in the Rx FIFO.  The
 * packets are moved from the FIFO to memory, where they will be
 * processed when the Endpoint Interrupt Register indicates Transfer
 * Complete or SETUP Phase Done.
 *
 * Repeat the following until the Rx Status Queue is empty:
 *   -#	Read the Receive Status Pop Register (GRXSTSP) to get Packet
 *     	info
 *   -#	If Receive FIFO is empty then skip to step Clear the interrupt
 *     	and exit
 *   -#	If SETUP Packet call dwc_otg_read_setup_packet to copy the
 *   	SETUP data to the buffer
 *   -#	If OUT Data Packet call dwc_otg_read_packet to copy the data
 *     	to the destination buffer
 */

static void dwc_otg_pcd_handle_rx_status_q_level_intr(void)
{
	gintmsk_data_t gintmask = {0};
	gintsts_data_t gintsts = {0};
	dwc_ep_t *ep;
	pcd_struct_t *pcd = &gadget_wrapper.pcd;
	struct usb_req_flag *req_flag = &gadget_wrapper.req_flag;
	device_grxsts_data_t status;

	/* Disable the Rx Status Queue Level interrupt */
	gintmask.b.rxstsqlvl = 1;
	dwc_modify_reg32(DWC_REG_GINTMSK, gintmask.d32, 0);

	/* Get the Status from the top of the FIFO */
	status.d32 = dwc_read_reg32(DWC_REG_GRXSTSP);
	if (status.b.epnum != 0)
		status.b.epnum = 2;
	/* Get pointer to EP structure */
	ep = &pcd->dwc_eps[status.b.epnum].dwc_ep;

	switch (status.b.pktsts) {
	case DWC_STS_DATA_UPDT:
		if (status.b.bcnt && ep->xfer_buff) {
			/** @todo NGS Check for buffer overflow? */
			dwc_otg_read_packet(ep->xfer_buff, status.b.bcnt);
			ep->xfer_count += status.b.bcnt;
			ep->xfer_buff += status.b.bcnt;
		}

		break;

	case DWC_DSTS_SETUP_UPDT:
		dwc_otg_read_setup_packet(gadget_wrapper.pcd.setup_pkt.d32);
		req_flag->request_enable = 1;
		ep->xfer_count += status.b.bcnt;
		break;

	case DWC_DSTS_GOUT_NAK:
	case DWC_STS_XFER_COMP:
	case DWC_DSTS_SETUP_COMP:
	default:
		break;
	}


	/* Enable the Rx Status Queue Level interrupt */
	dwc_modify_reg32(DWC_REG_GINTMSK, 0, gintmask.d32);

	/* Clear interrupt */
	gintsts.b.rxstsqlvl = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);
}


/**
 * This interrupt occurs when the non-periodic Tx FIFO is half-empty.
 * The active request is checked for the next packet to be loaded into
 * the non-periodic Tx FIFO.
 */
static void dwc_otg_pcd_handle_np_tx_fifo_empty_intr(void)
{
	gnptxsts_data_t txstatus = {0};
	gintsts_data_t gintsts = {0};
	dwc_ep_t *ep = 0;
	depctl_data_t depctl;
	u32 len = 0;
	u32 dwords;
	u32 epnum = 0;
	pcd_struct_t *pcd = &gadget_wrapper.pcd;

    /* Get the epnum from the IN Token Learning Queue. */
	for (epnum = 0; epnum < NUM_EP; epnum++) {
		ep = &pcd->dwc_eps[epnum].dwc_ep;

		/* IN endpoint ? */
		if (epnum && !ep->is_in)
			continue;

		if (ep->type == DWC_OTG_EP_TYPE_INTR && ep->xfer_len == 0)
			continue;

		depctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(epnum));
		if (depctl.b.epena != 1)
			continue;

		flush_cpu_cache();

		/* While there is space in the queue and space in the FIFO and
		 * More data to tranfer, Write packets to the Tx FIFO */
		txstatus.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
		while  (/*txstatus.b.nptxqspcavail > 0 &&
			txstatus.b.nptxfspcavail > dwords &&*/
			ep->xfer_count < ep->xfer_len) {
				u32 retry = 1000000;

				len = ep->xfer_len - ep->xfer_count;
				if (len > ep->maxpacket)
					len = ep->maxpacket;

				dwords = (len + 3) >> 2;

				while (retry--) {
					txstatus.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
					if (txstatus.b.nptxqspcavail > 0 && txstatus.b.nptxfspcavail > dwords)
						break;
					else
						flush_cpu_cache();
				}
				if (0 == retry) {
					printf("TxFIFO FULL: Can't trans data to HOST !\n");
					break;
				}
				/* Write the FIFO */
				dwc_otg_ep_write_packet(ep, len, dwords);

				flush_cpu_cache();
			}

	}

	/* Clear interrupt */
	gintsts.b.nptxfempty = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);
}
/**
 * Read the device status register and set the device speed in the
 * data structure.
 * Set up EP0 to receive SETUP packets by calling dwc_ep0_activate.
 */
static void dwc_otg_pcd_handle_enum_done_intr(void)
{
	gintsts_data_t gintsts = {0};
	gusbcfg_data_t gusbcfg;
	depctl_data_t diepctl;
	depctl_data_t doepctl;
	dctl_data_t dctl = {0};

	printf("SPEED ENUM\n");

	gadget_wrapper.pcd.ep0state = EP0_IDLE;

	/* Set the MPS of the IN EP based on the enumeration speed */
	diepctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(0));
	diepctl.b.mps = DWC_DEP0CTL_MPS_64;
	dwc_write_reg32(DWC_REG_IN_EP_REG(0), diepctl.d32);

	/* Enable OUT EP for receive */
	doepctl.d32 = dwc_read_reg32(DWC_REG_OUT_EP_REG(0));
	doepctl.b.epena = 1;
	dwc_write_reg32(DWC_REG_OUT_EP_REG(0), doepctl.d32);

	dctl.b.cgnpinnak = 1;
	dwc_modify_reg32(DWC_REG_DCTL, dctl.d32, dctl.d32);

	/* high speed */
	gusbcfg.d32 = dwc_read_reg32(DWC_REG_GUSBCFG);
	gusbcfg.b.usbtrdtim = 5;
	dwc_write_reg32(DWC_REG_GUSBCFG, gusbcfg.d32);

	/* Clear interrupt */
	gintsts.d32 = 0;
	gintsts.b.enumdone = 1;
	dwc_write_reg32(DWC_REG_GINTSTS, gintsts.d32);
}


/**
 * This interrupt indicates that an OUT EP has a pending Interrupt.
 * The sequence for handling the OUT EP interrupt is shown below:
 * -#	Read the Device All Endpoint Interrupt register
 * -#	Repeat the following for each OUT EP interrupt bit set (from
 *   	LSB to MSB).
 * -#	Read the Device Endpoint Interrupt (DOEPINTn) register
 * -#	If "Transfer Complete" call the request complete function
 * -#	If "Endpoint Disabled" complete the EP disable procedure.
 * -#	If "AHB Error Interrupt" log error
 * -#	If "Setup Phase Done" process Setup Packet (See Standard USB
 *   	Command Processing)
 */
static void dwc_otg_pcd_handle_out_ep_intr(void)
{
	u32 ep_intr;
	u32 epnum = 0;
	doepint_data_t doepint = {0};
	gintsts_data_t gintsts = {0};

	/* Read in the device interrupt bits */
	ep_intr = (dwc_read_reg32(DWC_REG_DAINT) &
			dwc_read_reg32(DWC_REG_DAINTMSK));
	ep_intr = ((ep_intr & 0xffff0000) >> 16);

	/* Clear the OUTEPINT in GINTSTS */
	gintsts.b.outepintr = 1;
	dwc_write_reg32(DWC_REG_GINTSTS, gintsts.d32);
	dwc_write_reg32(DWC_REG_DAINT, 0xFFFF0000);

	while (ep_intr) {
		if (ep_intr & 0x1) {
			doepint.d32 = (dwc_read_reg32(DWC_REG_OUT_EP_INTR(epnum)) &
				dwc_read_reg32(DWC_REG_DOEPMSK));

			/* Transfer complete */
			if (doepint.b.xfercompl) {
				/* Clear the bit in DOEPINTn for this interrupt */
				CLEAR_OUT_EP_INTR(epnum, xfercompl);
				if (0 == epnum) {
					CLEAR_OUT_EP_INTR(epnum, setup);
					doepint.b.setup = 0;
					handle_ep0();
				} else {
					complete_ep(epnum, 0);
				}
			}
			/* Endpoint disable  */
			if (doepint.b.epdisabled) {
				/* Clear the bit in DOEPINTn for this interrupt */
				CLEAR_OUT_EP_INTR(epnum, epdisabled);
			}
			/* AHB Error */
			if (doepint.b.ahberr) {
				CLEAR_OUT_EP_INTR(epnum, ahberr);
			}
			/* Setup Phase Done (contorl EPs) */
			if (doepint.b.setup) {
				handle_ep0();
				CLEAR_OUT_EP_INTR(epnum, setup);
			}
		}
		epnum++;
		ep_intr >>= 1;
	}
}

/**
 * This interrupt indicates that an IN EP has a pending Interrupt.
 * The sequence for handling the IN EP interrupt is shown below:
 * -#	Read the Device All Endpoint Interrupt register
 * -#	Repeat the following for each IN EP interrupt bit set (from
 *   	LSB to MSB).
 * -#	Read the Device Endpoint Interrupt (DIEPINTn) register
 * -#	If "Transfer Complete" call the request complete function
 * -#	If "Endpoint Disabled" complete the EP disable procedure.
 * -#	If "AHB Error Interrupt" log error
 * -#	If "Time-out Handshake" log error
 * -#	If "IN Token Received when TxFIFO Empty" write packet to Tx
 *   	FIFO.
 * -#	If "IN Token EP Mismatch" (disable, this is handled by EP
 *   	Mismatch Interrupt)
 */
static void dwc_otg_pcd_handle_in_ep_intr(void)
{
	diepint_data_t diepint = {0};
	gintmsk_data_t intr_mask = {0};
	gintsts_data_t gintsts = {0};
	u32 ep_intr;
	u32 epnum = 0;

	/* Read in the device interrupt bits */
	ep_intr = dwc_read_reg32(DWC_REG_DAINT);

	ep_intr = (dwc_read_reg32(DWC_REG_DAINT) &
		dwc_read_reg32(DWC_REG_DAINTMSK));
	ep_intr =(ep_intr & 0xffff);

	/* Clear the INEPINT in GINTSTS */
	/* Clear all the interrupt bits for all IN endpoints in DAINT */
	gintsts.b.inepint = 1;
	dwc_write_reg32(DWC_REG_GINTSTS, gintsts.d32);
	dwc_write_reg32(DWC_REG_DAINT, 0xFFFF);
	flush_cpu_cache();

	/* Service the Device IN interrupts for each endpoint */
	while (ep_intr) {
		if (ep_intr & 0x1) {
			diepint.d32 = (dwc_read_reg32(DWC_REG_IN_EP_INTR(epnum)) &
				dwc_read_reg32(DWC_REG_DAINTMSK));

			/* Transfer complete */
			if (diepint.b.xfercompl) {
				/* Disable the NP Tx FIFO Empty Interrrupt  */
				intr_mask.b.nptxfempty = 1;
				dwc_modify_reg32(DWC_REG_GINTMSK, intr_mask.d32, 0);
				/* Clear the bit in DIEPINTn for this interrupt */
				CLEAR_IN_EP_INTR(epnum, xfercompl);
				/* Complete the transfer */
				if (0 == epnum) {
					handle_ep0();
				} else {
					complete_ep(epnum, 1);
					if (diepint.b.nak)
						CLEAR_IN_EP_INTR(epnum, nak);
				}
			}
			/* Endpoint disable  */
			if (diepint.b.epdisabled) {
				/* Clear the bit in DIEPINTn for this interrupt */
				CLEAR_IN_EP_INTR(epnum, epdisabled);
			}
			/* AHB Error */
			if (diepint.b.ahberr) {
				/* Clear the bit in DIEPINTn for this interrupt */
				CLEAR_IN_EP_INTR(epnum, ahberr);
			}
			/* TimeOUT Handshake (non-ISOC IN EPs) */
			if (diepint.b.timeout) {
				handle_in_ep_timeout_intr(epnum);
				CLEAR_IN_EP_INTR(epnum, timeout);
			}
			/** IN Token received with TxF Empty */
			if (diepint.b.intktxfemp) {
				CLEAR_IN_EP_INTR(epnum, intktxfemp);
			}
			/** IN Token Received with EP mismatch */
			if (diepint.b.intknepmis) {
				CLEAR_IN_EP_INTR(epnum, intknepmis);
			}
			/** IN Endpoint NAK Effective */
			if (diepint.b.inepnakeff) {
				CLEAR_IN_EP_INTR(epnum, inepnakeff);
			}
		}
		epnum++;
		ep_intr >>= 1;
	}
}
/**
 * This function configures EP0 to receive SETUP packets.
 *
 * @todo NGS: Update the comments from the HW FS.
 *
 *  -# Program the following fields in the endpoint specific registers
 *  for Control OUT EP 0, in order to receive a setup packet
 * 	- DOEPTSIZ0.Packet Count = 3 (To receive up to 3 back to back
 * 	  setup packets)
 *	- DOEPTSIZE0.Transfer Size = 24 Bytes (To receive up to 3 back
 *	  to back setup packets)
 *      - In DMA mode, DOEPDMA0 Register with a memory address to
 *        store any setup packets received
 *
 */
static void ep0_out_start(void)
{
	deptsiz0_data_t doeptsize0 = {0};
	depctl_data_t doepctl = {0};

	doeptsize0.b.supcnt = 3;
	doeptsize0.b.pktcnt = 1;
	doeptsize0.b.xfersize = 8*3;

	dwc_write_reg32(DWC_REG_OUT_EP_TSIZE(0), doeptsize0.d32);

	/*EP enable*/
	doepctl.d32 = 0;
	doepctl.b.epena = 1;
	dwc_modify_reg32(DWC_REG_OUT_EP_REG(0), 0, doepctl.d32);

	flush_cpu_cache();
}
/**
 * This interrupt occurs when a USB Reset is detected.  When the USB
 * Reset Interrupt occurs the device state is set to DEFAULT and the
 * EP0 state is set to IDLE.
 *  -#	Set the NAK bit for all OUT endpoints (DOEPCTLn.SNAK = 1)
 *  -#	Unmask the following interrupt bits
 *  	- DAINTMSK.INEP0 = 1 (Control 0 IN endpoint)
 * 	- DAINTMSK.OUTEP0 = 1 (Control 0 OUT endpoint)
 * 	- DOEPMSK.SETUP = 1
 * 	- DOEPMSK.XferCompl = 1
 * 	- DIEPMSK.XferCompl = 1
 *	- DIEPMSK.TimeOut = 1
 *  -# Program the following fields in the endpoint specific registers
 *  for Control OUT EP 0, in order to receive a setup packet
 * 	- DOEPTSIZ0.Packet Count = 3 (To receive up to 3 back to back
 * 	  setup packets)
 *	- DOEPTSIZE0.Transfer Size = 24 Bytes (To receive up to 3 back
 *	  to back setup packets)
 *      - In DMA mode, DOEPDMA0 Register with a memory address to
 *        store any setup packets received
 * At this point, all the required initialization, except for enabling
 * the control 0 OUT endpoint is done, for receiving SETUP packets.
 */
static void dwc_otg_pcd_handle_usb_reset_intr(void)
{
	depctl_data_t doepctl = {0};
	daint_data_t daintmsk = {0};
	doepmsk_data_t doepmsk = {0};
	diepmsk_data_t diepmsk = {0};
	dcfg_data_t dcfg = {0};
	depctl_data_t diepctl = {0};
	depctl_data_t diepctl_rd = {0};
	grstctl_t resetctl = {0};
	dctl_data_t dctl = {0};
	gintsts_data_t gintsts = {0};
	int i = 0;

	printf("\nUSB RESET\n");

	/* Clear the Remote Wakeup Signalling */
	dctl.b.rmtwkupsig = 1;
	dwc_modify_reg32( DWC_REG_DCTL,dctl.d32, 0 );

	diepctl.b.epdis = 1;
	diepctl.b.snak = 1;
	doepctl.b.snak = 1;

	for (i = 0; i < NUM_EP; i++) {
		diepctl_rd.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(i));
		if (diepctl_rd.b.epena) {
			/* Disable all active IN EPs */
			dwc_write_reg32(DWC_REG_IN_EP_REG(i), diepctl.d32);
		}

		/* Set NAK for all OUT EPs */
		dwc_write_reg32(DWC_REG_OUT_EP_REG(i), doepctl.d32);
	}

	/* Flush the NP Tx FIFO */
	dwc_otg_flush_fifo(0);
	/* Flush the Learning Queue */
	resetctl.b.intknqflsh = 1;
	dwc_write_reg32(DWC_REG_GRSTCTL, resetctl.d32);

	daintmsk.b.inep0 = 1;
	daintmsk.b.outep0 = 1;
	dwc_write_reg32(DWC_REG_DAINTMSK, daintmsk.d32);

	doepmsk.b.setup = 1;
	doepmsk.b.xfercompl = 1;
	doepmsk.b.ahberr = 1;
	doepmsk.b.epdisabled = 1;
	dwc_write_reg32(DWC_REG_DOEPMSK, doepmsk.d32);

	diepmsk.b.xfercompl = 1;
	diepmsk.b.timeout = 1;
	diepmsk.b.epdisabled = 1;
	diepmsk.b.ahberr = 1;
	dwc_write_reg32(DWC_REG_DIEPMSK, diepmsk.d32);
	/* Reset Device Address */
	dcfg.d32 = dwc_read_reg32(DWC_REG_DCFG);
	dcfg.b.devaddr = 0;
	dwc_write_reg32(DWC_REG_DCFG, dcfg.d32);

	/* setup EP0 to receive SETUP packets */
	ep0_out_start();

	/* Clear interrupt */
	gintsts.b.usbreset = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);

	flush_cpu_cache();
}
/**
 * This interrupt indicates that SUSPEND state has been detected on
 * the USB.
 *
 * For HNP the USB Suspend interrupt signals the change from
 * "a_peripheral" to "a_host".
 *
 * When power management is enabled the core will be put in low power
 * mode.
 */
static void dwc_otg_handle_usb_suspend_intr(void)
{
	gintsts_data_t gintsts = {0};

	DBG("USB Suspend\n");

	/* Clear interrupt */
	gintsts.b.usbsuspend = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);
}

int f_dwc_pcd_irq(void)
{
	gintsts_data_t  gintr_status;
	gintsts_data_t  gintr_msk;
	gotgint_data_t  gotgint;
	int ret = 0;

	gintr_msk.d32 = dwc_read_reg32(DWC_REG_GINTMSK);
	gintr_status.d32 = dwc_read_reg32(DWC_REG_GINTSTS);

	gintr_status.d32 = gintr_status.d32 & gintr_msk.d32;

	if (gintr_status.d32 == 0)
		return ret;

	gotgint.d32 = dwc_read_reg32(DWC_REG_GOTGINT);

	if (gotgint.b.sesreqsucstschng)
		ERR("Session Request Success Status Change\n");
	else if (gotgint.b.sesenddet) {
		/*break to romboot*/
		ERR("Session End Detected\n");
		ret = 11;
	}

	/* clear intr */
	dwc_write_reg32(DWC_REG_GOTGINT, gotgint.d32);

	if (gintr_status.b.rxstsqlvl) {
	    dwc_otg_pcd_handle_rx_status_q_level_intr();
	}

	if (gintr_status.b.nptxfempty)
	    dwc_otg_pcd_handle_np_tx_fifo_empty_intr();

	if (gintr_status.b.usbreset)
		dwc_otg_pcd_handle_usb_reset_intr();

	if (gintr_status.b.usbsuspend)
		dwc_otg_handle_usb_suspend_intr();

	if (gintr_status.b.enumdone)
	    dwc_otg_pcd_handle_enum_done_intr();

	if (gintr_status.b.inepint)
	    dwc_otg_pcd_handle_in_ep_intr();

	if (gintr_status.b.outepintr)
	    dwc_otg_pcd_handle_out_ep_intr();

	dwc_write_reg32(DWC_REG_GINTSTS, gintr_status.d32);
	flush_cpu_cache();

	return ret;
}
