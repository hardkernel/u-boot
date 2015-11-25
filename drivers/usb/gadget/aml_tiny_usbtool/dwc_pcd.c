
/*
 * drivers/usb/gadget/aml_tiny_usbtool/dwc_pcd.c
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

#include "platform.h"
#include "usb_ch9.h"
#include "dwc_pcd.h"
#include "dwc_pcd_irq.h"
#include <asm/arch/timer.h>


pcd_struct_t this_pcd;
dwc_ep_t g_dwc_eps[NUM_EP];

extern void _mdelay(unsigned long ms);

int dwc_core_init(void)
{

    int32_t         snpsid;

    snpsid = dwc_read_reg32(DWC_REG_GSNPSID);
    //printf("Value for SNPSID: 0x%08x\n", snpsid);
    if ((snpsid & 0xFFFFF000) != 0x4F543000) {
        ERR("Bad value for SNPSID: 0x%08x\n", snpsid);
        return -1;
    }

    ERR("dwc core init is ok!\n");// show printf is ok.
    /*
     * Disable the global interrupt until all the interrupt
     * handlers are installed.
     */
    gahbcfg_data_t  ahbcfg = {.d32 = 0 };
    ahbcfg.b.glblintrmsk = 1;   /* Enable interrupts bit */
    dwc_modify_reg32(DWC_REG_GAHBCFG, ahbcfg.d32, 0);
    /*
     * Initialize the DWC_otg core.
     */
    dwc_otg_core_init();

    dwc_modify_reg32(DWC_REG_DCTL,0,2);// Disconnect data line
    dwc_otg_pcd_init();
    dwc_modify_reg32(DWC_REG_DCTL,2,0);// Connect data line

    /*
     * Enable the global interrupt after all the interrupt
     * handlers are installed.
     */
    dwc_otg_enable_global_interrupts();

    return 0;
}

int
dwc_otg_irq(void)
{
	dwc_common_irq();
	dwc_pcd_irq();
	return 0;
}
void dwc_otg_pullup(int is_on)
{
	if (is_on)
		dwc_modify_reg32(DWC_REG_DCTL,2,0);// connect data line
    else dwc_modify_reg32(DWC_REG_DCTL,0,2);// disconnect data line
}
static void dwc_otg_core_init(void) //Elvis Fool, add 'static'
{
    gahbcfg_data_t  ahbcfg = {.d32 = 0 };
    gusbcfg_data_t  usbcfg = {.d32 = 0 };
 //   gi2cctl_data_t  i2cctl = {.d32 = 0 };
//    hcfg_data_t     hcfg;
#ifndef USE_FULL_SPEED
	usbcfg.d32 = dwc_read_reg32(DWC_REG_GUSBCFG);

	usbcfg.b.ulpi_ext_vbus_drv = 0;
	usbcfg.b.term_sel_dl_pulse = 0;
	dwc_write_reg32(DWC_REG_GUSBCFG,usbcfg.d32);
#endif
	/*
	* Reset the Controller
	*/
	dwc_otg_core_reset();

		usbcfg.d32 = dwc_read_reg32(DWC_REG_GUSBCFG);
	usbcfg.b.srpcap = 0;
	usbcfg.b.hnpcap = 0;
#ifdef USE_FULL_SPEED
	DBG("Core work on Full Speed\n");
	usbcfg.b.physel = 1;  // Work at full speed
	dwc_write_reg32(DWC_REG_GUSBCFG, usbcfg.d32);

	dwc_otg_core_reset();
/* for HOST
	hcfg.d32 = dwc_read_reg32(DWC_REG_ hcfg);
	hcfg.b.fslspclksel = val;
	dwc_write_reg32(&_core_if->host_if->host_global_regs->hcfg, hcfg.d32);
*/
// for Device
	dcfg_data_t     dcfg;
	dcfg.d32 = dwc_read_reg32(DWC_REG_DCFG);
	dcfg.b.devspd = 1;//Hi speed phy run at Full speed
	dwc_write_reg32(DWC_REG_DCFG, dcfg.d32);
#else
	DBG("Core work on High Speed\n");
	usbcfg.b.ulpi_utmi_sel = 1;
	usbcfg.b.phyif = 0; // 16 bit
	usbcfg.b.ddrsel = 0;
	dwc_write_reg32(DWC_REG_GUSBCFG, usbcfg.d32);

	dwc_otg_core_reset();
#endif
	ahbcfg.b.dmaenable = 0;
	dwc_write_reg32(DWC_REG_GAHBCFG, ahbcfg.d32);


    /*
     * Enable common interrupts
     */
    dwc_otg_enable_common_interrupts();

    /*
     * Do device or host intialization based on mode during PCD and HCD
     * initialization
     */
     if (dwc_read_reg32(DWC_REG_GINTSTS) & 0x1) {
          DBG("Host Mode\n");
          return ;
    } else {
        DBG("Device Mode\n");
        dwc_otg_core_dev_init();
    }

}

/**
 * This function initialized the PCD portion of the driver.
 *
 */
static int  dwc_otg_pcd_init(void)
{
        return 0;
}


/**
 * Do core a soft reset of the core.  Be careful with this because it
 * resets all the internal state machines of the core.
 */
static void dwc_otg_core_reset(void)		//Elvis Fool, add 'static'
{
    grstctl_t greset = {.d32 = 0 };
    int             count = 0;

    /*
     * Wait for AHB master IDLE state.
     */
    do {
        _udelay(10);
        greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
        if (++count > 100000) {
            //DBG("%s() HANG! AHB Idle GRSTCTL=%0x\n", dwc_otg_core_reset, greset.d32);
            return;
        }
    }
    while (greset.b.ahbidle == 0);

    /*
     * Core Soft Reset
     */
    count = 0;
    greset.b.csftrst = 1;
    dwc_write_reg32(DWC_REG_GRSTCTL, greset.d32);
    do {
        greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
        if (++count > 1000000) {
            //DBG("%s() HANG! Soft Reset GRSTCTL=%0x\n", dwc_otg_core_reset, greset.d32);
            break;
        }
    }
    while (greset.b.csftrst == 1);

    /*
     * Wait for 3 PHY Clocks
     */
    _mdelay(10);
}

static void dwc_otg_enable_common_interrupts(void)
{
        gintmsk_data_t intr_mask = { 0};
        /* Clear any pending OTG Interrupts */
        dwc_write_reg32(DWC_REG_GOTGINT, 0xFFFFFFFF);
        /* Clear any pending interrupts */
        dwc_write_reg32(DWC_REG_GINTSTS, 0xFFFFFFFF);
        /*
         * Enable the interrupts in the GINTMSK.
         */
        intr_mask.b.modemismatch = 1;
        intr_mask.b.otgintr = 1;
        intr_mask.b.rxstsqlvl = 1;
        intr_mask.b.conidstschng = 1;
        intr_mask.b.wkupintr = 1;
        intr_mask.b.disconnect = 1;
        intr_mask.b.usbsuspend = 1;
        intr_mask.b.sessreqintr = 1;
        dwc_write_reg32(DWC_REG_GINTMSK, intr_mask.d32);
}

/**
 * This function enables the Device mode interrupts.
 *
 * @param _core_if Programming view of DWC_otg controller
 */
static void dwc_otg_enable_device_interrupts(void)
{
        gintmsk_data_t intr_mask = {  0};

        /* Disable all interrupts. */
        dwc_write_reg32( DWC_REG_GINTMSK, 0);

        /* Clear any pending interrupts */
        dwc_write_reg32( DWC_REG_GINTSTS, 0xFFFFFFFF);

        /* Enable the common interrupts */
        dwc_otg_enable_common_interrupts( );

        /* Enable interrupts */
        intr_mask.b.usbreset = 1;
        intr_mask.b.enumdone = 1;
        intr_mask.b.epmismatch = 1;
        intr_mask.b.inepintr = 1;
        intr_mask.b.outepintr = 1;
        intr_mask.b.erlysuspend = 1;

        dwc_modify_reg32( DWC_REG_GINTMSK, intr_mask.d32, intr_mask.d32);

}
/**
 * This function enables the controller's Global Interrupt in the AHB Config
 * register.
 *
 * @param[in] _core_if Programming view of DWC_otg controller.
 */
static void dwc_otg_enable_global_interrupts(void)
{
        gahbcfg_data_t ahbcfg = { 0};
        ahbcfg.b.glblintrmsk = 1; /* Enable interrupts */
        dwc_modify_reg32(DWC_REG_GAHBCFG, 0, ahbcfg.d32);
}


/**
 * This function initializes the DWC_otg controller registers for
 * device mode.
 *
 * @param _core_if Programming view of DWC_otg controller
 *
 */
static void dwc_otg_core_dev_init(void)
{
        dcfg_data_t dcfg = { 0};
        grstctl_t resetctl = { 0 };
        int i;
        fifosize_data_t nptxfifosize;

        /* Restart the Phy Clock */
        dwc_write_reg32(DWC_REG_PCGCCTL, 0);

        /* Device configuration register */
	dcfg.d32 = dwc_read_reg32(DWC_REG_DCFG);
#ifdef USE_FULL_SPEED
	dcfg.b.devspd = 1;//Hi speed phy run at Full speed
#else
	dcfg.b.devspd = 0;
#endif
	dcfg.b.perfrint = DWC_DCFG_FRAME_INTERVAL_80;
	dwc_write_reg32(DWC_REG_DCFG, dcfg.d32);

        /* Configure data FIFO sizes */

	/* Rx FIFO */
      dwc_write_reg32(DWC_REG_GRXFSIZ, 256 );
      //DBG("new grxfsiz=%08x\n",dwc_read_reg32(DWC_REG_GRXFSIZ));

	/* Non-periodic Tx FIFO */
      nptxfifosize.b.depth  = 256;
      nptxfifosize.b.startaddr = 256;
      dwc_write_reg32(DWC_REG_GNPTXFSIZ, nptxfifosize.d32 );
      //DBG("new gnptxfsiz=%08x\n",dwc_read_reg32(DWC_REG_GNPTXFSIZ));

        /* Flush the FIFOs */
      dwc_otg_flush_tx_fifo( 0x10); /* all Tx FIFOs */
      dwc_otg_flush_rx_fifo();

	/* Flush the Learning Queue. */
      resetctl.b.intknqflsh = 1;
      dwc_write_reg32( DWC_REG_GRSTCTL, resetctl.d32);

        /* Clear all pending Device Interrupts */
        dwc_write_reg32( DWC_REG_DIEPMSK, 0 );
        dwc_write_reg32( DWC_REG_DOEPMSK, 0 );
        dwc_write_reg32( DWC_REG_DAINT, 0xFFFFFFFF );
        dwc_write_reg32( DWC_REG_DAINTMSK, 0 );

        for (i=0; i < NUM_EP; i++) {
		depctl_data_t depctl;
		depctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(i));
		if (depctl.b.epena) {
			depctl.d32 = 0;
			depctl.b.epdis = 1;
			depctl.b.snak = 1;
		} else {
			depctl.d32 = 0;
		}
		dwc_write_reg32( DWC_REG_IN_EP_REG(i),depctl.d32);

		depctl.d32 = dwc_read_reg32(DWC_REG_OUT_EP_REG(i));
		if (depctl.b.epena) {
			depctl.d32 = 0;
			depctl.b.epdis = 1;
			depctl.b.snak = 1;
		} else {
			depctl.d32 = 0;
		}
		dwc_write_reg32( DWC_REG_OUT_EP_REG(i), depctl.d32);

		/* Device IN/OUT Endpoint Transfer Size */
		dwc_write_reg32(DWC_REG_IN_EP_TSIZE(i), 0);
		dwc_write_reg32(DWC_REG_OUT_EP_TSIZE(i), 0);
		/* Device IN/OUT Endpoint DMA Address Register */
		dwc_write_reg32( DWC_REG_IN_EP_DMA(i), 0);
		dwc_write_reg32( DWC_REG_OUT_EP_DMA(i), 0);
		/* Device IN/OUT Endpoint Interrupt Register */
		//dwc_write_reg32( DWC_REG_IN_EP_DMA(i), 0xFF);
		//dwc_write_reg32( DWC_REG_OUT_EP_INTR(i), 0xFF);
        }

        //dwc_otg_set_vbus_power(_core_if, 0); //Power off VBus

        dwc_otg_enable_device_interrupts();

	  //DBG("init gintmsk: 0x%x\n",dwc_read_reg32(DWC_REG_GINTMSK));
}
/**
 * Flush a Tx FIFO.
 *
 * @param _core_if Programming view of DWC_otg controller.
 * @param _num Tx FIFO to flush.
 */
static void dwc_otg_flush_tx_fifo( const int _num ) 	//Elvis Fool, add 'static'
{
        grstctl_t greset = { 0};
        int count = 0;


	 DBG("dwc_otg_flush_tx_fifo: %d\n",_num);
        greset.b.txfflsh = 1;
        greset.b.txfnum = _num;
        dwc_write_reg32(DWC_REG_GRSTCTL, greset.d32 );

        do {
                greset.d32 = dwc_read_reg32( DWC_REG_GRSTCTL);
                if (++count > 10000) {
                       // ERR("%s() HANG! GRSTCTL=%0x GNPTXSTS=0x%08x\n",
                       //           "dwc_otg_flush_tx_fifo", greset.d32,
                       //           dwc_read_reg32( DWC_REG_GNPTXSTS));
                        break;
                }

        } while (greset.b.txfflsh == 1);
        /* Wait for 3 PHY Clocks*/
        _udelay(1);
}

/**
 * Flush Rx FIFO.
 *
 * @param _core_if Programming view of DWC_otg controller.
 */
static void dwc_otg_flush_rx_fifo(void)
{
        grstctl_t greset = { 0};
        int count = 0;

	  DBG("dwc_otg_flush_rx_fifo\n");
        greset.b.rxfflsh = 1;
        dwc_write_reg32( DWC_REG_GRSTCTL, greset.d32 );

        do {
                greset.d32 = dwc_read_reg32( DWC_REG_GRSTCTL);
                if (++count > 10000) {
                        //ERR("%s() HANG! GRSTCTL=%0x\n", "dwc_otg_flush_rx_fifo",
                        //         greset.d32);
                        break;
                }
        } while (greset.b.rxfflsh == 1);
        /* Wait for 3 PHY Clocks*/
        _udelay(1);
}
/**
 * This function does the setup for a data transfer for EP0 and starts
 * the transfer.  For an IN transfer, the packets will be loaded into
 * the appropriate Tx FIFO in the ISR. For OUT transfers, the packets are
 * unloaded from the Rx FIFO in the ISR.
 *
 * @param _core_if Programming view of DWC_otg controller.
 * @param _ep The EP0 data.
 */
 #if 0
void dwc_otg_ep0_start_transfer(dwc_ep_t *_ep)
{
	depctl_data_t depctl;
	deptsiz0_data_t deptsiz;
        gintmsk_data_t intr_mask = { 0};

        _ep->total_len = _ep->xfer_len;

	//DBG("dwc_otg_ep0_start_transfer: xfer_len:%d\n",_ep->xfer_len);
	/* IN endpoint */
	if (_ep->is_in == 1) {
		gnptxsts_data_t tx_status = { 0};

		tx_status.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
		if (tx_status.b.nptxqspcavail == 0) {
			return;
		}

		depctl.d32 = dwc_read_reg32(DWC_REG_IN_EP_REG(0));
		deptsiz.d32 = dwc_read_reg32(DWC_REG_IN_EP_TSIZE(0));

		/* Zero Length Packet? */
		if (_ep->xfer_len == 0) {
			deptsiz.b.xfersize = 0;
			deptsiz.b.pktcnt = 1;
		} else {
			/* Program the transfer size and packet count
			*  as follows: xfersize = N * maxpacket +
			*  short_packet pktcnt = N + (short_packet
			*  exist ? 1 : 0)
			*/
			if (_ep->xfer_len > _ep->maxpacket) {
				_ep->xfer_len = _ep->maxpacket;
				deptsiz.b.xfersize = _ep->maxpacket;
			}
			else {
				deptsiz.b.xfersize = _ep->xfer_len;
			}
			deptsiz.b.pktcnt = 1;

		}
		dwc_write_reg32(DWC_REG_IN_EP_TSIZE(0), deptsiz.d32);
             //DBG( "IN len=%d  xfersize=%d pktcnt=%d [%08x]\n",
              //              _ep->xfer_len,deptsiz.b.xfersize, deptsiz.b.pktcnt, deptsiz.d32);


		flush_cpu_cache();

		/* EP enable, IN data in FIFO */
		depctl.b.cnak = 1;
		depctl.b.epena = 1;
		dwc_write_reg32(DWC_REG_IN_EP_REG(0), depctl.d32);

		/**
		 * Enable the Non-Periodic Tx FIFO empty interrupt, the
		 * data will be written into the fifo by the ISR.
		 */

		/* First clear it from GINTSTS */
		intr_mask.b.nptxfempty = 1;
		dwc_modify_reg32( DWC_REG_GINTSTS,intr_mask.d32, 0);
		dwc_modify_reg32( DWC_REG_GINTMSK,intr_mask.d32, intr_mask.d32);


	} else { /* OUT endpoint */

		depctl.d32 = dwc_read_reg32(DWC_REG_OUT_EP_REG(0));
		deptsiz.d32 = dwc_read_reg32(DWC_REG_OUT_EP_TSIZE(0));

		/* Program the transfer size and packet count as follows:
		*  xfersize = N * (maxpacket + 4 - (maxpacket % 4))
		*  pktcnt = N                                          */
#if 0
		if (_ep->xfer_len == 0) {
			/* Zero Length Packet */
			deptsiz.b.xfersize = _ep->maxpacket;
			deptsiz.b.pktcnt = 1;
		} else {
			deptsiz.b.pktcnt =
			(_ep->xfer_len + (_ep->maxpacket - 1)) /_ep->maxpacket;
			deptsiz.b.xfersize = deptsiz.b.pktcnt * _ep->maxpacket;
		}
#else   // ep0 pktcnt is 1 bit

		deptsiz.b.xfersize = _ep->maxpacket;
		deptsiz.b.pktcnt = 1;
		_udelay(1); // This is needed, don't know reason.
#endif


		dwc_write_reg32(DWC_REG_OUT_EP_TSIZE(0), deptsiz.d32);
             //DBG( "OUT len=%d  xfersize=%d pktcnt=%d\n",
             //               _ep->xfer_len,deptsiz.b.xfersize, deptsiz.b.pktcnt);


		/* EP enable */
		depctl.b.cnak = 1;
		depctl.b.epena = 1;
		dwc_write_reg32 (DWC_REG_OUT_EP_REG(0), depctl.d32);
	}

	flush_cpu_cache();
}
 #endif

void dwc_otg_ep_start_transfer(dwc_ep_t *_ep)
{
	depctl_data_t depctl;
	deptsiz_data_t deptsiz;
	int epctl_reg,epctltsize_reg;
	int ep_num = _ep->num;
	int is_in = _ep->is_in;
	int ep_mps = _ep->maxpacket;

	//DBG("dwc_otg_ep_start_transfer: xfer_len:%d\n",_ep->xfer_len);

        _ep->total_len = _ep->xfer_len;

	if (is_in) {
		epctl_reg = DWC_REG_IN_EP_REG(ep_num);
		epctltsize_reg = DWC_REG_IN_EP_TSIZE(ep_num);
	}else{
		epctl_reg = DWC_REG_OUT_EP_REG(ep_num);
		epctltsize_reg = DWC_REG_OUT_EP_TSIZE(ep_num);
	}

	depctl.d32 = dwc_read_reg32(epctl_reg);
	deptsiz.d32 = dwc_read_reg32(epctltsize_reg);

	/* Zero Length Packet? */
	if (_ep->xfer_len == 0) {
		deptsiz.b.xfersize = is_in?0:ep_mps;
		deptsiz.b.pktcnt = 1;
	} else {
		deptsiz.b.pktcnt =
		(_ep->xfer_len + (ep_mps - 1)) /ep_mps;
		if (is_in && _ep->xfer_len < ep_mps)
			deptsiz.b.xfersize = _ep->xfer_len;
		else
			deptsiz.b.xfersize = deptsiz.b.pktcnt * ep_mps;
	}

	/* Fill size and count */
	dwc_write_reg32(epctltsize_reg,deptsiz.d32);

	/* EP enable */
	depctl.b.cnak = 1;
	depctl.b.epena = 1;
	dwc_write_reg32 (epctl_reg, depctl.d32);

	/* IN endpoint */
	if (is_in) {
		gintmsk_data_t intr_mask = {0};
		//gnptxsts_data_t tx_status = { 0};

		//tx_status.d32 = dwc_read_reg32(DWC_REG_GNPTXSTS);
		//if (tx_status.b.nptxqspcavail == 0){
		//	return;
		//}

		/**
		 * Enable the Non-Periodic Tx FIFO empty interrupt, the
		 * data will be written into the fifo by the ISR.
		 */

		/* First clear it from GINTSTS */
		intr_mask.b.nptxfempty = 1;
		dwc_modify_reg32( DWC_REG_GINTSTS,intr_mask.d32, 0);
		dwc_modify_reg32( DWC_REG_GINTMSK,intr_mask.d32, intr_mask.d32);

	}

}
int dwc_otg_ep_req_start(pcd_struct_t *pcd,int ep_num)
{
	dwc_ep_t *ep = &g_dwc_eps[ep_num];

	ep->num = ep_num;
	//DBG("dwc_otg_ep_req_start: ep%d\n",ep_num);
        /* EP0 Transfer? */
	if (ep_num == 0) {
		//DBG("EP0 State: %d\n",pcd->ep0state);
		switch (pcd->ep0state) {
			case EP0_IN_DATA_PHASE:
				break;

			case EP0_OUT_DATA_PHASE:
				if (pcd->request_config) {
				        /* Work around for SetConfig cmd */
				        /* Complete STATUS PHASE */
				        ep->is_in = 1;
				        pcd->ep0state = EP0_STATUS;
				}
				else if(pcd->length == 0)
				{
				        /* Work around for MSC Reset cmd */
				        /* Complete STATUS PHASE */
				        ep->is_in = 1;
				        pcd->ep0state = EP0_STATUS;
				}
			break;

			default:
				return -1;
		}

		ep->start_xfer_buff = (uint8_t*)pcd->buf;
		ep->xfer_buff = (uint8_t*)pcd->buf;
		ep->xfer_len = pcd->length;
		ep->xfer_count = 0;
		ep->sent_zlp = 0;
		ep->total_len = ep->xfer_len;
		ep->maxpacket = 64;
		dwc_otg_ep_start_transfer( ep );

	} else {
		/* Setup and start the Transfer for Bulk */
		ep->start_xfer_buff = (uint8_t*)pcd->bulk_buf;
		ep->xfer_buff = (uint8_t*)pcd->bulk_buf;
		ep->xfer_len = pcd->bulk_len;
		ep->xfer_count = 0;
		ep->sent_zlp = 0;
		ep->total_len = ep->xfer_len;
		ep->maxpacket = BULK_EP_MPS;
		ep->is_in = (ep_num == BULK_IN_EP_NUM);
		dwc_otg_bulk_ep_activate( ep );
		dwc_otg_ep_start_transfer( ep );
	}

	return 0;

}

static void dwc_otg_bulk_ep_activate(dwc_ep_t *ep)
{
	depctl_data_t depctl = {0};
	daint_data_t daintmsk = {0};
	int epctl;
	int ep_num = ep->num;

	if (ep->is_in) {
		epctl = DWC_REG_IN_EP_REG(ep_num);
		daintmsk.ep.in = 1<<BULK_IN_EP_NUM; //ep1:BULK_IN
	}
	else{
		epctl = DWC_REG_OUT_EP_REG(ep_num);
		daintmsk.ep.out = 1<<BULK_OUT_EP_NUM;//ep2:BULK_OUT
	}

	depctl.d32 = dwc_read_reg32(epctl);
	if (!depctl.b.usbactep) {
		depctl.b.mps = BULK_EP_MPS;
		depctl.b.eptype = 2;//BULK_STYLE
		depctl.b.setd0pid = 1;
		depctl.b.txfnum = 0;   //Non-Periodic TxFIFO
		depctl.b.usbactep = 1;

		dwc_write_reg32(epctl, depctl.d32);
	}

	dwc_modify_reg32(DWC_REG_DAINTMSK, 0, daintmsk.d32);

	return;
}

void dwc_otg_power_off_phy(void)
{
	dwc_write_reg32(DWC_REG_PCGCCTL, 0xF);
}
