/* dwc controller pcd interrupt drivers  */
/*
 * (C) Copyright 2010 Amlogic, Inc
 *
 * Victor Wan, victor.wan@amlogic.com,
 * 2010-03-30 @ Shanghai
 *
 */
#include "platform.h"
#include "usb_ch9.h"
#include "dwc_pcd.h"
#include "dwc_pcd_irq.h"
//#define flush_cpu_cache()
extern void do_gadget_setup( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl);
extern void do_vendor_request( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl);
extern void do_vendor_out_complete( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl);
extern void do_bulk_complete( pcd_struct_t *_pcd);
extern void do_modify_memory(u16 opcode,char * inbuff);

static void ep0_out_start(void);
static int32_t ep0_complete_request( pcd_struct_t * pcd);
/**
 * This function starts the Zero-Length Packet for the IN status phase
 * of a 2 stage control transfer.
 */
static void do_setup_in_status_phase( pcd_struct_t *_pcd)
{
        dwc_ep_t *ep0 = &g_dwc_eps[0];
        if (_pcd->ep0state == EP0_STALL) {
                return;
        }

        _pcd->ep0state = EP0_STATUS;

        DBG( "EP0 IN ZLP\n");
        ep0->xfer_len = 0;
        ep0->xfer_count = 0;
        ep0->is_in = 1;

        dwc_otg_ep_start_transfer( ep0 );

        /* Prepare for more SETUP Packets */
        ep0_out_start();

}
/**
 * This function starts the Zero-Length Packet for the OUT status phase
 * of a 2 stage control transfer.
 */
static void do_setup_out_status_phase( pcd_struct_t *_pcd)
{
        dwc_ep_t *ep0 = &g_dwc_eps[0];
        if (_pcd->ep0state == EP0_STALL) {
                return;
        }
        _pcd->ep0state = EP0_STATUS;

        /* Prepare for more SETUP Packets */
        //ep0_out_start( GET_CORE_IF(_pcd), _pcd );

        DBG( "EP0 OUT ZLP\n");
        ep0->xfer_len = 0;
        ep0->xfer_count = 0;
        ep0->is_in = 0;
        dwc_otg_ep_start_transfer( ep0 );

        /* Prepare for more SETUP Packets */
        ep0_out_start( );

}

static void pcd_out_completed(pcd_struct_t *_pcd)
{
    if (_pcd->cmdtype.out_complete && _pcd->cmdtype.in_complete)
    {
        _pcd->cmdtype.setup_complete = _pcd->cmdtype.out_complete = _pcd->cmdtype.in_complete = 0;
        do_vendor_out_complete(_pcd,(struct usb_ctrlrequest*)&_pcd->setup_pkt);
    }
}

static void pcd_in_completed(pcd_struct_t *_pcd)
{
	do_vendor_in_complete(_pcd,(struct usb_ctrlrequest*)&_pcd->setup_pkt);
}


static void pcd_setup( pcd_struct_t *_pcd )
{

    struct usb_ctrlrequest	ctrl = _pcd->setup_pkt.req;
    dwc_ep_t	*ep0 = &g_dwc_eps[0];
    /*deptsiz0_data_t doeptsize0 = { 0};*/

    if (_pcd->request_enable == 0)
        return;

    //	_pcd->setup_pkt.d32[0] = 0;
    //	_pcd->setup_pkt.d32[1] = 0;
    _pcd->status = 0;
    _pcd->request_enable = 0;

    /*doeptsize0.d32 = dwc_read_reg32( DWC_REG_OUT_EP_TSIZE(0));*/

    if (ctrl.bRequestType & USB_DIR_IN) {
        ep0->is_in = 1;
        _pcd->ep0state = EP0_IN_DATA_PHASE;
    } else {
        ep0->is_in = 0;
        _pcd->ep0state = EP0_OUT_DATA_PHASE;
    }


    if ((ctrl.bRequestType & USB_TYPE_MASK) != USB_TYPE_STANDARD)
    {
        /* handle non-standard (class/vendor) requests in the gadget driver */
        //do_gadget_setup(_pcd, &ctrl );
        DBG("Vendor requset\n");
        do_vendor_request(_pcd, &ctrl );
        dwc_otg_ep_req_start(_pcd,0);
        return;
    }

    /** @todo NGS: Handle bad setup packet? */

    switch (ctrl.bRequest)
    {
        case USB_REQ_GET_STATUS:

            _pcd->status = 0;
            switch (ctrl.bRequestType & USB_RECIP_MASK) {

                case USB_RECIP_DEVICE:
                    _pcd->status = 0; /* Default Bus Powered, no Remote wakeup */
                    //_pcd->status |= 0x1; /* Self powered */
                    //_pcd->status |= 0x2;//_pcd->remote_wakeup_enable << 1;
                    break;

                case USB_RECIP_INTERFACE:
                    _pcd->status = 0;
                    break;
            }
            _pcd->buf = (char *)&_pcd->status;
            _pcd->length = 2;
            dwc_otg_ep_req_start(_pcd,0);
            break;
#if 0
        case USB_RECIP_INTERFACE:
            *status = 0;
            break;

        case USB_RECIP_ENDPOINT:
            ep = get_ep_by_addr(_pcd, ctrl.wIndex);
            if ( ep == 0 || ctrl.wLength > 2) {
                ep0_do_stall(_pcd, -EOPNOTSUPP);
                return;
            }
            /** @todo check for EP stall */
            *status = ep->stopped;
            break;
            _pcd->ep0_pending = 1;

            ep0->dwc_ep.start_xfer_buff = (uint8_t *)status;
            ep0->dwc_ep.xfer_buff = (uint8_t *)status;
            ep0->dwc_ep.dma_addr = _pcd->status_buf_dma_handle;
            ep0->dwc_ep.xfer_len = 2;
            ep0->dwc_ep.xfer_count = 0;
            ep0->dwc_ep.total_len = ep0->dwc_ep.xfer_len;
            dwc_otg_ep0_start_transfer( GET_CORE_IF(_pcd), &ep0->dwc_ep );
            break;

        case USB_REQ_CLEAR_FEATURE:
            do_clear_feature( _pcd );
            break;

        case USB_REQ_SET_FEATURE:
            do_set_feature( _pcd );
            break;
#endif
        case USB_REQ_SET_ADDRESS:
            if (ctrl.bRequestType == USB_RECIP_DEVICE)
            {
                dcfg_data_t dcfg = { 0 };

                printf("Set Addr %d\n",ctrl.wValue);
                dcfg.b.devaddr = ctrl.wValue;
                dwc_modify_reg32(DWC_REG_DCFG,0, dcfg.d32);
                do_setup_in_status_phase( _pcd );
                return;
            }
            break;

        case USB_REQ_SET_INTERFACE:
        case USB_REQ_SET_CONFIGURATION:
            _pcd->request_config = 1;   /* Configuration changed */
            do_gadget_setup(_pcd, &ctrl );
            dwc_otg_ep_req_start(_pcd,0);
            break;

        default:
            /* Call the Gadget Driver's setup functions */
            do_gadget_setup(_pcd, &ctrl );
            dwc_otg_ep_req_start(_pcd,0);
            break;
    }
}

/**
 * This function handles EP0 Control transfers.
 *
 * The state of the control tranfers are tracked in
 * <code>ep0state</code>.
 * is_in : 1 -- IN Trans
 * is_in : 0 -- OUT/SETUP Trans
 */
static void handle_ep0( int is_in )
{
	pcd_struct_t * _pcd = &this_pcd[0];//Oh, this_pcd
	dwc_ep_t * ep0 = &g_dwc_eps[0];

    switch (_pcd->ep0state)
    {
        case EP0_DISCONNECT:
            DBG("EP0 DISCONNECT\n");
            break;

        case EP0_IDLE:
            _pcd->request_config = 0;
            DBG("Enter PCD Setup()\n");
            pcd_setup( _pcd );
            break;

        case EP0_IN_DATA_PHASE:

            if (ep0->xfer_count < ep0->total_len) {
                DBG("FIX ME!! dwc_otg_ep0_continue_transfer!\n");
                //dwc_otg_ep0_continue_transfer ( GET_CORE_IF(_pcd), &ep0->dwc_ep );
            }
            else {
                ep0_complete_request( _pcd );
                pcd_in_completed(_pcd);/////////////
            }
            break;

        case EP0_OUT_DATA_PHASE:
            ep0_complete_request(_pcd );
            _pcd->cmdtype.in_complete = 1;
            pcd_out_completed(_pcd);
            break;


        case EP0_STATUS:

            ep0_complete_request( _pcd );
            _pcd->ep0state = EP0_IDLE;
            ep0->stopped = 1;
            ep0->is_in = 0;  /* OUT for next SETUP */

            break;

        case EP0_STALL:
            ERR("EP0 STALLed, should not get here pcd_setup()\n");
            break;
        }

    return ;
}

/**
 * This function completes the request for the 'BULK' EP.  If there are
 * additional requests for the EP in the queue they will be started.
 */
static void complete_ep( int ep_num,int is_in )
{
        deptsiz_data_t deptsiz;
        pcd_struct_t *pcd = &this_pcd[ep_num];
        dwc_ep_t *ep = &g_dwc_eps[ep_num];

	if (is_in)
    {
		pcd->xfer_len = ep->xfer_count;////////////////

		deptsiz.d32 = dwc_read_reg32(DWC_REG_IN_EP_TSIZE(ep_num));
		if (deptsiz.b.xfersize == 0 && deptsiz.b.pktcnt == 0 &&
                    ep->xfer_count == ep->xfer_len)
        {

			ep->start_xfer_buff = 0;
			ep->xfer_buff = 0;
			ep->xfer_len = 0;
		}
	}
	else
    {/* OUT Transfer */

		deptsiz.d32 = dwc_read_reg32(DWC_REG_OUT_EP_TSIZE(ep_num));

		pcd->xfer_len = ep->xfer_count;

		ep->start_xfer_buff = 0;
		ep->xfer_buff = 0;
		ep->xfer_len = 0;
	}

	do_bulk_complete(pcd);
}
/**
 * This function completes the ep0 control transfer.
 */
static int32_t ep0_complete_request( pcd_struct_t * pcd)
{

    deptsiz0_data_t deptsiz;
    int is_last = 0;
    dwc_ep_t* ep = &g_dwc_eps[0];

    DBG("ep0_complete_request()\n");
    if (pcd->ep0state == EP0_STATUS)
    {
        is_last = 1;
    }
    else if (ep->xfer_len == 0)
    {
        ep->xfer_len = 0;
        ep->xfer_count = 0;
        ep->sent_zlp = 1;
        dwc_otg_ep_start_transfer( ep );
        return 1;
    }
    else if (ep->is_in)
    {
        deptsiz.d32 = dwc_read_reg32(DWC_REG_IN_EP_TSIZE(0) );
        if (deptsiz.b.xfersize == 0) {
            /* Is a Zero Len Packet needed? */
            do_setup_out_status_phase(pcd);
        }
    }
    else {
        /* ep0-OUT */
        do_setup_in_status_phase(pcd);
    }

    /* Complete the request */
    if (is_last) {
        ep->start_xfer_buff = 0;
        ep->xfer_buff = 0;
        ep->xfer_len = 0;
        return 1;
    }
    return 0;
}

/**
 * This function reads a packet from the Rx FIFO into the destination
 * buffer.  To read SETUP data use dwc_otg_read_setup_packet.
 *
 * @param _dest   Destination buffer for the packet.
 * @param _bytes  Number of bytes to copy to the destination.
 */
static void dwc_otg_read_packet(uint8_t *_dest, uint16_t _bytes)	//Elvis Fool, add 'static'
{
	int i;
    /*const char* str =   (char*)_dest;*/
    uint32_t* pu32  = (uint32_t*)_dest;
    const unsigned lenIn32  = (_bytes>>2);
    const unsigned rest     = (_bytes & 3);

	/**
	 * @todo Account for the case where _dest is not dword aligned. This
	 * requires reading data from the FIFO into a uint32_t temp buffer,
	 * then moving it into the data buffer.
	 */
	//DBG("dwc_otg_read_packet() dest: %p, len: %d\n",_dest,_bytes);
    for (i = 0; i < lenIn32; ++i)
    {
        *pu32++ = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
    }
    if (rest)
    {
        const unsigned fifoVal  = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
        uint8_t*            pBufDst8    = (uint8_t*)pu32;
        const uint8_t*      pBufSrc8    = (const uint8_t*)&fifoVal;
        for (i = 0; i < rest; ++i)
        {
            *pBufDst8++ = *pBufSrc8++;
        }
    }

    /*
     *if(!strcmp("power", str))
     *    printf("%d>", _bytes),printf(str),printf("\n");
     */

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
void dwc_otg_ep_write_packet( dwc_ep_t *_ep)
{
	/**
	 * The buffer is padded to DWORD on a per packet basis in
	 * slave/dma mode if the MPS is not DWORD aligned.  The last
	 * packet, if short, is also padded to a multiple of DWORD.
	 *
	 * ep->xfer_buff always starts DWORD aligned in memory and is a
	 * multiple of DWORD in length
	 *
	 * ep->xfer_len can be any number of bytes
	 *
	 * ep->xfer_count is a multiple of ep->maxpacket until the last
	 *  packet
	 *
	 * FIFO access is DWORD */

	uint32_t i;
	uint32_t byte_count;
	uint32_t dword_count;
	uint32_t fifo;
    uint8_t *data_buff = _ep->xfer_buff;
    uint32_t temp_data ;

	//DBG("dwc_otg_ep_write_packet() : %d\n",_ep->xfer_len);
        if (_ep->xfer_count >= _ep->xfer_len) {
                //DWC_WARN("%s() No data for EP%d!!!\n", "dwc_otg_ep_write_packet", _ep->num);
                return;
        }

        /* Find the byte length of the packet either short packet or MPS */
        byte_count = _ep->xfer_len - _ep->xfer_count;
        if (byte_count > _ep->maxpacket) byte_count = _ep->maxpacket;

	/* Find the DWORD length, padded by extra bytes as neccessary if MPS
	 * is not a multiple of DWORD */
	dword_count =  (byte_count + 3) / 4;


       //fifo = _core_if->data_fifo[_ep->num];
     fifo = DWC_REG_DATA_FIFO(_ep->num);


	for (i=0; i<dword_count; i++) {
		temp_data =get_unaligned(data_buff);
		dwc_write_reg32( fifo, temp_data );
		data_buff += 4;
	}


	_ep->xfer_count += byte_count;
    _ep->xfer_buff += byte_count;

	flush_cpu_cache();

}
/**
 * This function reads a setup packet from the Rx FIFO into the destination
 * buffer.  This function is called from the Rx Status Queue Level (RxStsQLvl)
 * Interrupt routine when a SETUP packet has been received in Slave mode.
 *
 * @param _core_if Programming view of DWC_otg controller.
 * @param _dest Destination buffer for packet data.
 */
void dwc_otg_read_setup_packet(uint32_t *_dest)
{
	/* Get the 8 bytes of a setup transaction data */

	DBG("dwc_otg_read_setup_packet()\n");
	/* Pop 2 DWORDS off the receive data FIFO into memory */
	_dest[0] = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
	_dest[1] = dwc_read_reg32(DWC_REG_DATA_FIFO_START);
}



/**
 * handle the IN EP disable interrupt.
 */
static void handle_in_ep_disable_intr(uint32_t _epnum)
{
#if 0
        deptsiz_data_t dieptsiz = { 0 };
        dctl_data_t dctl = { 0 };
        depctl_data_t diepctl = { 0 };
        dwc_ep_t *ep = &g_dwc_eps[_epnum];

        if (ep->stopped) {
                /* Flush the Tx FIFO */
                /** @todo NGS: This is not the correct FIFO */
                dwc_otg_flush_tx_fifo( core_if, 0 );
                /* Clear the Global IN NP NAK */
                dctl.d32 = 0;
                dctl.b.cgnpinnak = 1;
                dwc_modify_reg32(&dev_if->in_ep_regs[_epnum]->diepctl,
                                 diepctl.d32, diepctl.d32);
                /* Restart the transaction */
                if (dieptsiz.b.pktcnt != 0 ||
                    dieptsiz.b.xfersize != 0) {
                        restart_transfer( _pcd, _epnum );
                }
        }
#endif
}

/**
 * Handler for the IN EP timeout handshake interrupt.
 */
static void handle_in_ep_timeout_intr(uint32_t _epnum)
{

        dctl_data_t dctl = { 0 };
        dwc_ep_t *ep = &g_dwc_eps[_epnum];

        gintmsk_data_t intr_mask = {0};


        /* Disable the NP Tx Fifo Empty Interrrupt */

	intr_mask.b.nptxfempty = 1;
	dwc_modify_reg32( DWC_REG_GINTMSK, intr_mask.d32, 0);
        /** @todo NGS Check EP type.
         * Implement for Periodic EPs */
        /*
         * Non-periodic EP
         */
        /* Enable the Global IN NAK Effective Interrupt */
        intr_mask.b.ginnakeff = 1;
        dwc_modify_reg32( DWC_REG_GINTMSK, 0, intr_mask.d32);

        /* Set Global IN NAK */
        dctl.b.sgnpinnak = 1;
        dwc_modify_reg32( DWC_REG_DCTL,dctl.d32, dctl.d32);

        ep->stopped = 1;

}

///////////////////////////////////////////////////////////////////////
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
int32_t dwc_otg_pcd_handle_rx_status_q_level_intr(void)
{
    gintmsk_data_t gintmask = { 0 };
    device_grxsts_data_t status;
    gintsts_data_t gintsts;
    dwc_ep_t *ep;


    DBG("dwc_otg_pcd_handle_rx_status_q_level_intr()\n");
    /* Disable the Rx Status Queue Level interrupt */
    gintmask.b.rxstsqlvl= 1;
    dwc_modify_reg32( DWC_REG_GINTMSK, gintmask.d32, 0);

    /* Get the Status from the top of the FIFO */
    status.d32 = dwc_read_reg32( DWC_REG_GRXSTSP);

    //DBG("rx status: ep%d, pktsts: %d\n",status.b.epnum,status.b.pktsts);

    /* Get pointer to EP structure */
    ep = &g_dwc_eps[status.b.epnum];

    switch (status.b.pktsts)
    {
        case DWC_DSTS_GOUT_NAK:
            DBG( "Global OUT NAK\n");
            break;

        case DWC_STS_DATA_UPDT:
            DBG( "OUT Data Packet\n");
            {
                if (status.b.bcnt && ep->xfer_buff)
                {
                    /** @todo NGS Check for buffer overflow? */
                    dwc_otg_read_packet( ep->xfer_buff,status.b.bcnt);
                    ep->xfer_count += status.b.bcnt;
                    ep->xfer_buff += status.b.bcnt;

                    if (!status.b.epnum)
                    {
                        /*const char* p = ep->xfer_buff - status.b.bcnt;*/
                        this_pcd[0].cmdtype.out_complete = 1;
                        /*
                         *if(!strcmp("power", p) || !strcmp("low_power", p)){
                         *    printf("%s, bcnt %d, cnt %d, %d\n", p, status.b.bcnt, ep->xfer_count, this_pcd.cmdtype.in_complete);
                         *}
                         */
                    }
                }
            }
            break;

        case DWC_STS_XFER_COMP:
            DBG("OUT Complete\n");
            break;

        case DWC_DSTS_SETUP_COMP:
            DBG("SETUP Complete\n");
            break;

        case DWC_DSTS_SETUP_UPDT:
            DBG("SETUP update\n");
            {
                static int _is_first_setup_out_in_cmd = 1;

                dwc_otg_read_setup_packet( this_pcd[0].setup_pkt.d32);
                this_pcd[0].request_enable = 1;
                ep->xfer_count += status.b.bcnt;

                DBG("set %d, %d\n", status.b.bcnt, ep->xfer_count);
                if (_is_first_setup_out_in_cmd) //first tplcmd/bulkcmd that in sequence 'setup + out + in'
                {
                    struct usb_ctrlrequest request = this_pcd[0].setup_pkt.req;
                    if ( USB_TYPE_VENDOR == (request.bRequestType & USB_TYPE_MASK) )
                    {
                        unsigned bRequest = request.bRequest;

                        if ((AM_REQ_WR_LARGE_MEM == bRequest) || (AM_REQ_RD_LARGE_MEM == bRequest)
                                ||(AM_REQ_TPL_CMD == bRequest) || (AM_REQ_TPL_STAT == bRequest)
                                || (AM_REQ_DOWNLOAD == bRequest) || (AM_REQ_BULKCMD == bRequest))
                        {
                            __udelay(20);//delay for first command that consisted of consecutive 'ep0 out', i.e. 'setup + out + in'
                            _is_first_setup_out_in_cmd = 0;
                        }
                    }
                }
            }
        break;

        default:
            //DBG( "Invalid Packet Status (0x%0x)\n", status.b.pktsts);
            break;

    }

    /* Enable the Rx Status Queue Level interrupt */
    dwc_modify_reg32( DWC_REG_GINTMSK, 0, gintmask.d32);
    /* Clear interrupt */
    gintsts.d32 = 0;
    gintsts.b.rxstsqlvl = 1;
    dwc_write_reg32 ( DWC_REG_GINTSTS, gintsts.d32);

    return 1;
}


/**
 * This interrupt occurs when the non-periodic Tx FIFO is half-empty.
 * The active request is checked for the next packet to be loaded into
 * the non-periodic Tx FIFO.
 */
int32_t dwc_otg_pcd_handle_np_tx_fifo_empty_intr(void)
{
        gnptxsts_data_t txstatus = {0};
        gintsts_data_t gintsts;

        int epnum = 0;
        dwc_ep_t *ep = 0;
        uint32_t len = 0;
        int dwords;
	 depctl_data_t depctl;

	DBG("dwc_otg_pcd_handle_np_tx_fifo_empty_intr()\n");
        /* Get the epnum from the IN Token Learning Queue. */
	for (epnum=0; epnum < NUM_EP; epnum++)
	{

		ep = &g_dwc_eps[epnum];


		/* IN endpoint ? */
		if (epnum && !ep->is_in ) {
			continue;
	        }
		depctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(epnum));
	       if (depctl.b.epena != 1)
			continue;

		 if (ep->type == DWC_OTG_EP_TYPE_INTR && ep->xfer_len == 0)
			continue;

		 flush_cpu_cache();

	        len = ep->xfer_len - ep->xfer_count;
	        if (len > ep->maxpacket) {
	                len = ep->maxpacket;
	        }
	        dwords = (len + 3)/4;

		 //DBG("nptx: write data to fifo, ep%d , size %d\n",epnum,len);
	        /* While there is space in the queue and space in the FIFO and
	         * More data to tranfer, Write packets to the Tx FIFO */
	        txstatus.d32 = dwc_read_reg32( DWC_REG_GNPTXSTS );
	        while  (txstatus.b.nptxqspcavail > 0 &&
	                txstatus.b.nptxfspcavail > dwords &&
	                ep->xfer_count < ep->xfer_len) {

			   flush_cpu_cache();

			   /* Write the FIFO */
	                dwc_otg_ep_write_packet( ep );

	                len = ep->xfer_len - ep->xfer_count;
	                if (len > ep->maxpacket) {
	                        len = ep->maxpacket;
	                }
	                dwords = (len + 3)/4;
			   flush_cpu_cache();
			   //txstatus.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
#if 1
			   /*
				  TODO:  Remove these code.
				  Because, if code break from "while"(Line427), an incomplete-in-trans will occour.
				  Then the tansfer will break.
			   */
			   int retry = 50000;	//retry times
			   while (retry--)
			   {
			       txstatus.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
				if(txstatus.b.nptxqspcavail > 0  || //txstatus.b.nptxfspcavail <= dwords ||
					ep->xfer_count >= ep->xfer_len)
					break;
				else
				{
					flush_cpu_cache();
				}

			   }
			   if (retry <= 0)
			   {
				//DWC_ERROR("TxFIFO FULL: Can't trans data to HOST !\n");
			   }

			   /* END todo */
#endif
	        }

	}

	/* Clear interrupt */
	gintsts.d32 = 0;
	gintsts.b.nptxfempty = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);

        return 1;
}
/**
 * Read the device status register and set the device speed in the
 * data structure.
 * Set up EP0 to receive SETUP packets by calling dwc_ep0_activate.
 */
int32_t dwc_otg_pcd_handle_enum_done_intr(void)
{
	gintsts_data_t gintsts;
	gusbcfg_data_t gusbcfg;
	/*dsts_data_t dsts;*/
	depctl_data_t diepctl;
	depctl_data_t doepctl;
	dctl_data_t dctl ={0};

	DBG("SPEED ENUM\n");

	/* Read the Device Status and Endpoint 0 Control registers */
	/*dsts.d32 = dwc_read_reg32(DWC_REG_DSTS);*/
	diepctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(0) );
	doepctl.d32 = dwc_read_reg32(DWC_REG_OUT_EP_REG(0));

	/* Set the MPS of the IN EP based on the enumeration speed */
	diepctl.b.mps = DWC_DEP0CTL_MPS_64;
	dwc_write_reg32(DWC_REG_IN_EP_REG(0) , diepctl.d32);

	/* Enable OUT EP for receive */
	doepctl.b.epena = 1;
	dwc_write_reg32(DWC_REG_OUT_EP_REG(0), doepctl.d32);

	dctl.b.cgnpinnak = 1;
	dwc_modify_reg32(DWC_REG_DCTL, dctl.d32, dctl.d32);

        if (this_pcd[0].ep0state == EP0_DISCONNECT) {
				this_pcd[0].ep0state = EP0_IDLE;
		} else if (this_pcd[0].ep0state == EP0_STALL) {
				this_pcd[0].ep0state = EP0_IDLE;
        }

    this_pcd[0].ep0state = EP0_IDLE;


	/* Set USB turnaround time based on device speed and PHY interface. */
	gusbcfg.d32 = dwc_read_reg32(DWC_REG_GUSBCFG);
#if 0
	if (_pcd->gadget.speed == USB_SPEED_HIGH) {
		if (GET_CORE_IF(_pcd)->hwcfg2.b.hs_phy_type == DWC_HWCFG2_HS_PHY_TYPE_ULPI) {
			/* ULPI interface */
			gusbcfg.b.usbtrdtim = 9;
		}
		if (GET_CORE_IF(_pcd)->hwcfg2.b.hs_phy_type == DWC_HWCFG2_HS_PHY_TYPE_UTMI) {
			/* UTMI+ interface */
			if (GET_CORE_IF(_pcd)->core_params->phy_utmi_width == 16) {
				gusbcfg.b.usbtrdtim = 5;
			} else {
				gusbcfg.b.usbtrdtim = 9;
			}
		}
		if (GET_CORE_IF(_pcd)->hwcfg2.b.hs_phy_type == DWC_HWCFG2_HS_PHY_TYPE_UTMI_ULPI) {
			/* UTMI+  OR  ULPI interface */
			if (gusbcfg.b.ulpi_utmi_sel == 1) {
				/* ULPI interface */
				gusbcfg.b.usbtrdtim = 9;
			} else {
				/* UTMI+ interface */
				if (GET_CORE_IF(_pcd)->core_params->phy_utmi_width == 16) {
					gusbcfg.b.usbtrdtim = 5;
				} else {
					gusbcfg.b.usbtrdtim = 9;
				}
			}
		}
	} else {
		/* Full or low speed */
		gusbcfg.b.usbtrdtim = 9;
	}
#else
	/* Full or low speed */
	gusbcfg.b.usbtrdtim = 5;
#endif
	dwc_write_reg32(DWC_REG_GUSBCFG, gusbcfg.d32);

	/* Clear interrupt */
	gintsts.d32 = 0;
	gintsts.b.enumdone = 1;
	dwc_write_reg32(DWC_REG_GINTSTS,gintsts.d32 );
	return 1;
}
///////////////////////////////////////////////////////////////////
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
static int32_t dwc_otg_pcd_handle_out_ep_intr(void)
{
#define CLEAR_OUT_EP_INTR(__epnum,__intr) \
do { \
        doepint_data_t doepint = { 0 }; \
	doepint.b.__intr = 1; \
	dwc_write_reg32(DWC_REG_OUT_EP_INTR(__epnum), \
			doepint.d32); \
} while (0)

        uint32_t ep_intr;
        doepint_data_t doepint = { 0 };
        uint32_t epnum = 0;
//	 uint32_t epnum_trans = 0;
        gintsts_data_t gintsts;

        DBG( "dwc_otg_pcd_handle_out_ep_intr()\n" );

	/* Read in the device interrupt bits */
        ep_intr = (dwc_read_reg32(DWC_REG_DAINT) &
                dwc_read_reg32( DWC_REG_DAINTMSK));
        ep_intr =( (ep_intr & 0xffff0000) >> 16);

	/* Clear the OUTEPINT in GINTSTS */
	gintsts.d32 = 0;
	gintsts.b.outepintr = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);
	dwc_write_reg32(DWC_REG_DAINT, 0xFFFF0000 );

        while ( ep_intr ) {
            if (ep_intr&0x1) {
                    doepint.d32 = (dwc_read_reg32( DWC_REG_OUT_EP_INTR(epnum)) &
						dwc_read_reg32(DWC_REG_DOEPMSK));

                    /* Transfer complete */
			if ( doepint.b.xfercompl ) {
				DBG("EP%d OUT Xfer Complete\n", epnum);

				/* Clear the bit in DOEPINTn for this interrupt */
				CLEAR_OUT_EP_INTR(epnum,xfercompl);

				if (epnum == 0) {
					handle_ep0( 0 );
				} else {
					complete_ep( epnum,0 );
				}
                    }
                    /* Endpoint disable  */
                    if ( doepint.b.epdisabled ) {
                            DBG("EP%d OUT disabled\n", epnum);
				/* Clear the bit in DOEPINTn for this interrupt */
				CLEAR_OUT_EP_INTR(epnum,epdisabled);
                    }
                    /* AHB Error */
                    if ( doepint.b.ahberr ) {
                            DBG("EP%d OUT AHB Error\n", epnum);
				CLEAR_OUT_EP_INTR(epnum,ahberr);
                    }
                    /* Setup Phase Done (contorl EPs) */
                    if ( doepint.b.setup ) {
                            handle_ep0( 0 );
				CLEAR_OUT_EP_INTR(epnum,setup);
                    }
            }
		epnum++;
		ep_intr >>=1;
        }

        return 1;

#undef CLEAR_OUT_EP_INTR
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
static int32_t dwc_otg_pcd_handle_in_ep_intr(void)
{
#define CLEAR_IN_EP_INTR(__epnum,__intr) \
do { \
        diepint_data_t diepint = { 0 }; \
	diepint.b.__intr = 1; \
	dwc_write_reg32(DWC_REG_IN_EP_INTR(__epnum), \
			diepint.d32); \
} while (0)

        diepint_data_t diepint = { 0 };
//        depctl_data_t diepctl = { 0 };
        uint32_t ep_intr;
        uint32_t epnum = 0;
        gintmsk_data_t intr_mask = {0};
        gintsts_data_t gintsts;

	 DBG( "dwc_otg_pcd_handle_in_ep_intr()\n" );

	/* Read in the device interrupt bits */
        ep_intr = (dwc_read_reg32(DWC_REG_DAINT) &
                dwc_read_reg32( DWC_REG_DAINTMSK));
        ep_intr =( (ep_intr & 0xffff) );


	/* Clear the INEPINT in GINTSTS */
	/* Clear all the interrupt bits for all IN endpoints in DAINT */
	gintsts.d32 = 0;
	gintsts.b.inepint = 1;
	dwc_write_reg32 (DWC_REG_GINTSTS, gintsts.d32);
	dwc_write_reg32(DWC_REG_DAINT, 0xFFFF );
	flush_cpu_cache();

	/* Service the Device IN interrupts for each endpoint */
        while ( ep_intr ) {
                if (ep_intr&0x1) {

                        diepint.d32 = (dwc_read_reg32( DWC_REG_IN_EP_INTR(epnum)) &
									dwc_read_reg32(DWC_REG_DAINTMSK));
                        /* Transfer complete */
                        if ( diepint.b.xfercompl ) {


                                /* Disable the NP Tx FIFO Empty
                                 * Interrrupt */
                                intr_mask.b.nptxfempty = 1;
                                dwc_modify_reg32( DWC_REG_GINTMSK, intr_mask.d32, 0);

                                /* Clear the bit in DIEPINTn for this interrupt */
                                CLEAR_IN_EP_INTR(epnum,xfercompl);

                                /* Complete the transfer */
					if (epnum == 0) {
						handle_ep0( 0 );
					} else {
						complete_ep( epnum,1 );
					}
                        }
                        /* Endpoint disable  */
                        if ( diepint.b.epdisabled ) {
                                handle_in_ep_disable_intr( epnum );

                                /* Clear the bit in DIEPINTn for this interrupt */
                                CLEAR_IN_EP_INTR(epnum,epdisabled);
                        }
                        /* AHB Error */
                        if ( diepint.b.ahberr ) {
				/* Clear the bit in DIEPINTn for this interrupt */
				CLEAR_IN_EP_INTR(epnum,ahberr);
                        }
                        /* TimeOUT Handshake (non-ISOC IN EPs) */
                        if ( diepint.b.timeout ) {
                                handle_in_ep_timeout_intr( epnum );

				CLEAR_IN_EP_INTR(epnum,timeout);
                        }
                        /** IN Token received with TxF Empty */
                        if (diepint.b.intktxfemp) {
                                DWN_MSG("diepint.b.intktxfemp\n");
#if 0
                                if (!ep->stopped && epnum != 0) {
                                        diepmsk_data_t diepmsk = { 0};
                                        diepmsk.b.intktxfemp = 1;
                                        dwc_modify_reg32( &dev_if->dev_global_regs->diepmsk, diepmsk.d32, 0 );
                                        start_next_request(ep);
                                }
#endif
				CLEAR_IN_EP_INTR(epnum,intktxfemp);
                        }
                        /** IN Token Received with EP mismatch */
                        if (diepint.b.intknepmis) {
                                DWN_MSG("intknepmis ep%d\n", epnum);
                                CLEAR_IN_EP_INTR(epnum,intknepmis);
                        }
                        /** IN Endpoint NAK Effective */
                        if (diepint.b.inepnakeff) {
				CLEAR_IN_EP_INTR(epnum,inepnakeff);
                        }
                }
                epnum++;
                ep_intr >>=1;
        }

        return 1;

#undef CLEAR_IN_EP_INTR
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
	deptsiz0_data_t doeptsize0 = { 0};
	depctl_data_t doepctl = { 0 };

	doeptsize0.b.supcnt = 3;
	doeptsize0.b.pktcnt = 1;
	doeptsize0.b.xfersize = 8*3;

	DBG("ep0_out_start()\n");
	dwc_write_reg32( DWC_REG_OUT_EP_TSIZE(0),doeptsize0.d32 );


	// EP enable
	doepctl.d32 = dwc_read_reg32(DWC_REG_OUT_EP_REG(0));
	doepctl.b.epena = 1;

	doepctl.d32 = 0x80008000;
	dwc_write_reg32(DWC_REG_OUT_EP_REG(0),doepctl.d32);

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
int32_t dwc_otg_pcd_handle_usb_reset_intr(void)
{

        depctl_data_t doepctl = { 0};
        daint_data_t daintmsk = { 0};
        doepmsk_data_t doepmsk = { 0};
        diepmsk_data_t diepmsk = { 0};
        dcfg_data_t dcfg = { 0 };
        depctl_data_t diepctl = { 0};
        depctl_data_t diepctl_rd = { 0};
        grstctl_t resetctl = { 0 };
        dctl_data_t dctl = { 0 };
        int i = 0;
        gintsts_data_t gintsts;


        DBG("\nUSB RESET\n");


        /* Clear the Remote Wakeup Signalling */
        dctl.b.rmtwkupsig = 1;
        dwc_modify_reg32( DWC_REG_DCTL,dctl.d32, 0 );

        /* Disable all active IN EPs */
        diepctl.b.epdis = 1;
        diepctl.b.snak = 1;
        for (i=0; i < NUM_EP; i++) {
                diepctl_rd.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(i));
                if (diepctl_rd.b.epena) {
                        dwc_write_reg32(DWC_REG_IN_EP_REG(i),diepctl.d32 );
                }
        }

        /* Set NAK for all OUT EPs */
        doepctl.b.snak = 1;
        for (i=0; i < NUM_EP; i++) {
                dwc_write_reg32(DWC_REG_OUT_EP_REG(i), doepctl.d32 );
        }

        /* Flush the NP Tx FIFO */
        dwc_otg_flush_tx_fifo( 0 );
        /* Flush the Learning Queue */
        resetctl.b.intknqflsh = 1;
        dwc_write_reg32( DWC_REG_GRSTCTL, resetctl.d32);

        daintmsk.b.inep0 = 1;
        daintmsk.b.outep0 = 1;
        dwc_write_reg32( DWC_REG_DAINTMSK, daintmsk.d32 );

        doepmsk.b.setup = 1;
        doepmsk.b.xfercompl = 1;
        doepmsk.b.ahberr = 1;
        doepmsk.b.epdisabled = 1;
        dwc_write_reg32( DWC_REG_DOEPMSK, doepmsk.d32 );

        diepmsk.b.xfercompl = 1;
        diepmsk.b.timeout = 1;
        diepmsk.b.epdisabled = 1;
        diepmsk.b.ahberr = 1;
        dwc_write_reg32( DWC_REG_DIEPMSK, diepmsk.d32 );
        /* Reset Device Address */
        dcfg.d32 = dwc_read_reg32( DWC_REG_DCFG);
        dcfg.b.devaddr = 0;
        dwc_write_reg32( DWC_REG_DCFG, dcfg.d32);

        /* setup EP0 to receive SETUP packets */
        ep0_out_start();

	/* Clear interrupt */
	gintsts.d32 = 0;
	gintsts.b.usbreset = 1;
	dwc_write_reg32 ( DWC_REG_GINTSTS, gintsts.d32);

	flush_cpu_cache();
        return 1;
}


///////////////////////////////////////////////////////////////////
int dwc_common_irq(void)
{
	int ret = 0;
	gotgint_data_t gotgint;

	gotgint.d32 = dwc_read_reg32(DWC_REG_GOTGINT);
	if (gotgint.d32 == 0)
		return 0;
	if (gotgint.b.sesreqsucstschng) {
		ERR("Session Request Success Status Change\n");
	}
	if (gotgint.b.sesenddet) {
		ERR("Session End Detected, Line Disconected\n");
                cb_4_dis_connect_intr();
	}

	dwc_write_reg32(DWC_REG_GOTGINT,gotgint.d32); // clear intr

	return ret;
}

int dwc_pcd_irq(void)
{
	gintsts_data_t  gintr_status;
	gintsts_data_t  gintr_msk;

	gintr_msk.d32 = dwc_read_reg32(DWC_REG_GINTMSK);
	gintr_status.d32 = dwc_read_reg32(DWC_REG_GINTSTS);

	if ((gintr_status.d32 & gintr_msk.d32)== 0)
		return 0;

	DBG("irq gintmsk:  0x%08x\n",gintr_msk.d32);
	DBG("irq gintrsts: 0x%08x\n",gintr_status.d32);

	gintr_status.d32 = gintr_status.d32 & gintr_msk.d32;
	DBG("irq gintmsk & gintrsts = 0x%08x\n",gintr_status.d32);

    if (gintr_status.b.sofintr)
	{
        if (_sofintr_not_occur) {
			DWN_MSG("sof\n");
			_sofintr_not_occur = 0;
		}
	}

	if (gintr_status.b.rxstsqlvl) {
		dwc_otg_pcd_handle_rx_status_q_level_intr();
		pcd_out_completed(&this_pcd[0]);
	}
	if (gintr_status.b.nptxfempty) {
		dwc_otg_pcd_handle_np_tx_fifo_empty_intr( );
	}

	if (gintr_status.b.usbreset) {
	   dwc_otg_pcd_handle_usb_reset_intr( );
	}
	if (gintr_status.b.enumdone) {
	    dwc_otg_pcd_handle_enum_done_intr();
	}
	if (gintr_status.b.epmismatch) {
	    //dwc_otg_pcd_handle_ep_mismatch_intr( core_if );
	}
	if (gintr_status.b.inepint) {
	    dwc_otg_pcd_handle_in_ep_intr();
	}
	if (gintr_status.b.outepintr) {
	    dwc_otg_pcd_handle_out_ep_intr( );
	}

#if 0
    if (gintr_status.b.otgintr)
    {
        gotgint_data_t gotgint;

        gotgint.d32 = dwc_read_reg32(DWC_REG_GOTGINT);
        if (gotgint.b.sesenddet)
        {
            printf("dis-connect-intr\n");
            cb_4_dis_connect_intr();
        }
    }
#endif//#if 0

    dwc_write_reg32(DWC_REG_GINTSTS,gintr_status.d32);
    flush_cpu_cache();
	return 0;
}



