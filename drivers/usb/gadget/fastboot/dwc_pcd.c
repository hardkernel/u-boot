/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * USB low level routines
 */
#include "usb_boot.h"
#include "usb_ch9.h"
#include "dwc_pcd.h"
#include "dwc_pcd_irq.h"
#include "platform.c"

gadget_wrapper_t gadget_wrapper;

static const struct usb_gadget_ops dwc_pcd_ops = {
	.get_frame		= NULL,
	.wakeup			= NULL,
	.set_selfpowered	= NULL,
};

#define USETW2(w, h, l) ((w)[0] = (u_int8_t)(l), (w)[1] = (u_int8_t)(h))
#define UCONSTW(x)      { (x) & 0xff, ((x) >> 8) & 0xff }
#define UCONSTDW(x)     { (x) & 0xff, ((x) >> 8) & 0xff, \
                          ((x) >> 16) & 0xff, ((x) >> 24) & 0xff }

#define UGETW(w) ((w)[0] | ((w)[1] << 8))
#define USETW(w, v) ((w)[0] = (u_int8_t)(v), (w)[1] = (u_int8_t)((v) >> 8))
#define UGETDW(w) ((w)[0] | ((w)[1] << 8) | ((w)[2] << 16) | ((w)[3] << 24))
#define USETDW(w, v) ((w)[0] = (u_int8_t)(v), \
                     (w)[1] = (u_int8_t)((v) >> 8), \
                     (w)[2] = (u_int8_t)((v) >> 16), \
                     (w)[3] = (u_int8_t)((v) >> 24))

#define UE_XFERTYPE     0x03
#define UE_CONTROL     0x00
#define UE_ISOCHRONOUS 0x01
#define UE_BULK        0x02
#define UE_INTERRUPT   0x03
#define UE_GET_XFERTYPE(a)      ((a) & UE_XFERTYPE)
#define UE_ISO_TYPE     0x0c
#define UE_ISO_ASYNC   0x04
#define UE_ISO_ADAPT   0x08
#define UE_ISO_SYNC    0x0c
#define UE_GET_ISO_TYPE(a)      ((a) & UE_ISO_TYPE)

#define UE_GET_DIR(a)   ((a) & 0x80)
#define UE_SET_DIR(a, d)        ((a) | (((d)&1) << 7))
#define UE_DIR_IN       0x80
#define UE_DIR_OUT      0x00
#define UE_ADDR         0x0f
#define UE_GET_ADDR(a)  ((a) & UE_ADDR)

static void dwc_otg_enable_dwc_interrupts(void)
{
	gintmsk_data_t intr_mask = {0};
	gahbcfg_data_t ahbcfg = {0};

	/* Clear any pending OTG Interrupts */
	dwc_write_reg32(DWC_REG_GOTGINT, 0xFFFFFFFF);
	/* Clear any pending interrupts */
	dwc_write_reg32(DWC_REG_GINTSTS, 0xFFFFFFFF);

	intr_mask.b.rxstsqlvl = 1;
	intr_mask.b.usbreset = 1;
	intr_mask.b.enumdone = 1;
	intr_mask.b.inepintr = 1;
	intr_mask.b.outepintr = 1;
	intr_mask.b.sofintr = 1;
	intr_mask.b.usbsuspend = 1;
	dwc_write_reg32(DWC_REG_GINTMSK, intr_mask.d32);

	/* Enable interrupts */
	ahbcfg.d32 = dwc_read_reg32(DWC_REG_GAHBCFG);
	ahbcfg.b.glblintrmsk = 1;
	dwc_write_reg32(DWC_REG_GAHBCFG, ahbcfg.d32);
}


static void dwc_otg_core_reset(void)
{
    grstctl_t greset = {0};
    u32 count = 0;

    /*
	* Wait for AHB master IDLE state.
	*/
    do {
        udelay(10);
        greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
        if (++count > 100000) {
            ERR("HANG! AHB Idle GRSTCTL=%0x\n", greset.d32);
            return;
        }
    } while (0 == greset.b.ahbidle);

    /*
	* Core Soft Reset
	*/
    count = 0;
    greset.b.csftrst = 1;
    dwc_write_reg32(DWC_REG_GRSTCTL, greset.d32);
    do {
        greset.d32 = dwc_read_reg32(DWC_REG_GRSTCTL);
        if (++count > 1000000) {
            ERR("HANG! Soft Reset GRSTCTL=%0x\n", greset.d32);
            break;
        }
    } while (1 == greset.b.csftrst);

	/*
	* Wait for 3 PHY Clocks
	*/
    wait_ms(10);
}

int f_dwc_core_init()
{
	gahbcfg_data_t	ahbcfg = {0};
	gusbcfg_data_t  usbcfg = {0};
	grstctl_t resetctl = {0};
	fifosize_data_t nptxfifosize;
	int i;

    DBG("\ndwc_otg core init enter!\n");

	f_set_usb_phy_config();

    if (0x4F543000 != (dwc_read_reg32(DWC_REG_GSNPSID) & 0xFFFFF000)) {
        ERR("Bad value for SNPSID\n");
        return -1;
    }

	dwc_otg_core_reset();

    /*
	* Initialize the DWC_otg core.
	*/
	usbcfg.d32 = dwc_read_reg32(DWC_REG_GUSBCFG);
	usbcfg.b.force_dev_mode = 1;
	dwc_write_reg32(DWC_REG_GUSBCFG, usbcfg.d32);

	ahbcfg.b.dmaenable = 0;
	dwc_write_reg32(DWC_REG_GAHBCFG, ahbcfg.d32);

    dwc_modify_reg32(DWC_REG_DCTL, 0, 2);
    dwc_modify_reg32(DWC_REG_DCTL, 2, 0);

	/*
	* Do device or host intialization based on mode during PCD and HCD
	* initialization
	*/
    if (dwc_read_reg32(DWC_REG_GINTSTS) & 0x1) {
		DBG("Host Mode\n");
		return -1;
    }

	DBG("Device Mode\n");
	/* Restart the Phy Clock */
	dwc_write_reg32(DWC_REG_PCGCCTL, 0);

	/* Configure data FIFO sizes */
	/* Rx FIFO */
	dwc_write_reg32(DWC_REG_GRXFSIZ, 256);

	/* Non-periodic Tx FIFO */
	nptxfifosize.b.depth = 512;
	nptxfifosize.b.startaddr = 256;
	dwc_write_reg32(DWC_REG_GNPTXFSIZ, nptxfifosize.d32);

	/* Flush the FIFOs */
	dwc_otg_flush_fifo(0x10);

	/* Flush the Learning Queue. */
	resetctl.b.intknqflsh = 1;
	dwc_write_reg32(DWC_REG_GRSTCTL, resetctl.d32);

	/* Clear all pending Device Interrupts */
	dwc_write_reg32(DWC_REG_DIEPMSK, 0);
	dwc_write_reg32(DWC_REG_DOEPMSK, 0);
	dwc_write_reg32(DWC_REG_DAINT, 0xFFFFFFFF);
	dwc_write_reg32(DWC_REG_DAINTMSK, 0);

	for (i = 0; i < NUM_EP; i++) {
		dwc_write_reg32(DWC_REG_IN_EP_REG(i), 0);
		dwc_write_reg32(DWC_REG_OUT_EP_REG(i), 0);

		/* Device IN/OUT Endpoint Transfer Size */
		dwc_write_reg32(DWC_REG_IN_EP_TSIZE(i), 0);
		dwc_write_reg32(DWC_REG_OUT_EP_TSIZE(i), 0);
	}

	dwc_otg_enable_dwc_interrupts();

    return 0;
}



int usb_pcd_irq_loop()
{
	return f_dwc_pcd_irq();
}

struct usb_gadget* usb_pcd_get_gadget()
{
	return &gadget_wrapper.gadget;
}

int pcd_queue(u32 ep_num, u32 is_in, struct usb_request *req)
{
	return f_dwc_otg_ep_req_start(&gadget_wrapper.pcd, ep_num, is_in, req);
}

int dwc_otg_bind_gadget_driver(struct usb_gadget_driver *driver)
{
	gadget_wrapper.driver = driver;

	return 0;
}

static inline void usb_ep_set_maxpacket_limit(struct usb_ep *ep,
                                              unsigned maxpacket_limit)
{
	ep->maxpacket = maxpacket_limit;
}

static int ep_enable(struct usb_ep *usb_ep,
		     const struct usb_endpoint_descriptor *ep_desc)
{
	int num;
	int dir;
	dwc_ep_t *ep;
	const usb_endpoint_descriptor_t *desc;

	desc = (const usb_endpoint_descriptor_t *)ep_desc;

	if (!desc) {
		printf("ep_desc is NULL\n");
		return 0;
	}

	if (!usb_ep || !ep_desc || ep_desc->bDescriptorType != USB_DT_ENDPOINT) {
		printf("bad ep or descriptor\n");
		return -1;
	}
	if (usb_ep == &gadget_wrapper.ep0) {
		printf("bad ep(0)\n");
		return -1;
	}

	/* Check FIFO size? */
	if (!ep_desc->wMaxPacketSize) {
		printf("bad %s maxpacket\n", usb_ep->name);
		return -1;
	}

	if (!gadget_wrapper.driver ||
	    gadget_wrapper.gadget.speed == USB_SPEED_UNKNOWN) {
		printf("bogus device state\n");
		return -1;
	}

	num = UE_GET_ADDR(desc->bEndpointAddress);
	dir = UE_GET_DIR(desc->bEndpointAddress);

	if (dir == UE_DIR_IN) {
		ep = &gadget_wrapper.pcd.dwc_eps[num].dwc_ep;
		gadget_wrapper.pcd.dwc_eps[num].desc = desc;
		gadget_wrapper.pcd.dwc_eps[num].priv = (void *)usb_ep;
	} else {
		ep = &gadget_wrapper.pcd.dwc_eps[num+1].dwc_ep;
		gadget_wrapper.pcd.dwc_eps[num+1].desc = desc;
		gadget_wrapper.pcd.dwc_eps[num+1].priv = (void *)usb_ep;
	}
	dwc_otg_bulk_ep_activate(ep);

	usb_ep->maxpacket = le16_to_cpu(ep_desc->wMaxPacketSize);

	return 0;
}

static int ep_disable(struct usb_ep *usb_ep)
{
	int retval = 0;

	if (!usb_ep) {
		return -1;
	}

	return retval;
}

static struct usb_request *dwc_otg_pcd_alloc_request(struct usb_ep *ep,
						     gfp_t gfp_flags)
{
	struct usb_request *usb_req;

	if (0 == ep) {
		printf("Invalid EP!\n");
		return 0;
	}
	usb_req = kmalloc(sizeof(*usb_req), gfp_flags);
	if (0 == usb_req) {
		printf("request allocation failed!\n");
		return 0;
	}
	memset(usb_req, 0, sizeof(*usb_req));
	usb_req->dma = 0xffffffff;

	return usb_req;
}

static void dwc_otg_pcd_free_request(struct usb_ep *ep, struct usb_request *req)
{
	if (0 == ep || 0 == req) {
		printf(
			 "Invalid ep or req argument!\n");
		return;
	}

	kfree(req);
}

static dwc_otg_pcd_ep_t *get_ep_from_handle(pcd_struct_t *pcd, void *handle)
{
	int i;
	if (pcd->dwc_eps[0].priv == handle)
		return &pcd->dwc_eps[0];

	for (i = 1; i < 5; i++) {
		if (pcd->dwc_eps[i].priv == handle) {
			return &pcd->dwc_eps[i];
		}
	}

	return NULL;
}


static int ep_queue(struct usb_ep *usb_ep, struct usb_request *usb_req,
		    gfp_t gfp_flags)
{
	pcd_struct_t *pcd;
	struct dwc_otg_pcd_ep *ep = NULL;
	int retval = 0;

	if (!usb_req || !usb_req->complete || !usb_req->buf) {
		printf("bad params\n");
		return -1;
	}

	if (!usb_ep) {
		printf("bad ep\n");
		return -1;
	}

	pcd = &gadget_wrapper.pcd;
	if (!gadget_wrapper.driver ||
	    gadget_wrapper.gadget.speed == USB_SPEED_UNKNOWN) {
		printf("gadget.speed=%d\n",
			    gadget_wrapper.gadget.speed);
		printf("bogus device state\n");
		return -2;
	}

	usb_req->status = -EINPROGRESS;
	usb_req->actual = 0;

	ep = get_ep_from_handle(pcd, (void *)usb_ep);
		if (!ep || (!ep->desc && ep->dwc_ep.num != 0)) {
			printf("bad ep\n");
			return -1;
	}

	ep->req = usb_req;

	pcd_queue(ep->dwc_ep.num, ep->dwc_ep.is_in, usb_req);

	if (retval)
		return -3;

	return 0;
}

static int ep_dequeue(struct usb_ep *usb_ep, struct usb_request *usb_req)
{
	if (!usb_ep || !usb_req) {
		printf("bad argument\n");
		return -EINVAL;
	}
	if (!gadget_wrapper.driver ||
	    gadget_wrapper.gadget.speed == USB_SPEED_UNKNOWN) {
		printf("bogus device state\n");
		return -ESHUTDOWN;
	}

	return 0;
}

static int ep_halt(struct usb_ep *usb_ep, int value)
{
	int retval = 0;

	if (!usb_ep) {
		printf("bad ep\n");
		return -EINVAL;
	}

	return retval;
}


static struct usb_ep_ops dwc_otg_pcd_ep_ops = {
	.enable = ep_enable,
	.disable = ep_disable,
	.alloc_request = dwc_otg_pcd_alloc_request,
	.free_request = dwc_otg_pcd_free_request,
	.queue = ep_queue,
	.dequeue = ep_dequeue,
	.set_halt = ep_halt,

	.fifo_status = 0,
	.fifo_flush = 0,

};

void gadget_add_eps(gadget_wrapper_t *d)
{
	static const char *names[] = {
		"ep0",
		"ep1in",
		"ep1out",
	};
	int i;
	struct usb_ep *ep;
	int8_t dev_endpoints = 1;

	INIT_LIST_HEAD(&d->gadget.ep_list);
	d->gadget.ep0 = &d->ep0;
	d->gadget.speed = USB_SPEED_HIGH;

	INIT_LIST_HEAD(&d->gadget.ep0->ep_list);

	/**
	 * Initialize the EP0 structure.
	 */
	ep = &d->ep0;

	/* Init the usb_ep structure. */
	ep->name = names[0];
	ep->ops = (struct usb_ep_ops *)&dwc_otg_pcd_ep_ops;

	/**
	 * @todo NGS: What should the max packet size be set to
	 * here?  Before EP type is set?
	 */
	ep->maxpacket = 1024;
	d->pcd.dwc_eps[0].priv = (void *)ep;

	list_add_tail(&ep->ep_list, &d->gadget.ep_list);

	for (i = 0; i < (dev_endpoints); i++) {
		ep = &d->in_ep[i];

		/* Init the usb_ep structure. */
		ep->name = names[i+1];
		ep->ops = (struct usb_ep_ops *)&dwc_otg_pcd_ep_ops;

		/**
		 * @todo NGS: What should the max packet size be set to
		 * here?  Before EP type is set?
		 */
		ep->maxpacket = 512;
		usb_ep_set_maxpacket_limit(ep, 512);
		list_add_tail(&ep->ep_list, &d->gadget.ep_list);
	}

	for (i = 0; i < dev_endpoints; i++) {
		ep = &d->out_ep[i];

		/* Init the usb_ep structure. */
		ep->name = names[i+2];
		ep->ops = (struct usb_ep_ops *)&dwc_otg_pcd_ep_ops;

		/**
		 * @todo NGS: What should the max packet size be set to
		 * here?  Before EP type is set?
		 */
		ep->maxpacket = 512;
		usb_ep_set_maxpacket_limit(ep, 512);

		list_add_tail(&ep->ep_list, &d->gadget.ep_list);
	}

	/* remove ep0 from the list.  There is a ep0 pointer. */
	list_del_init(&d->ep0.ep_list);

	d->ep0.maxpacket = 64;
	usb_ep_set_maxpacket_limit(&d->ep0, 64);
}

static void dwc_otg_pcd_init_ep(pcd_struct_t *pcd, dwc_otg_pcd_ep_t *pcd_ep,
				uint32_t is_in, uint32_t ep_num)
{
	/* Init EP structure */
	pcd_ep->desc = 0;
	pcd_ep->stopped = 1;
	pcd_ep->queue_sof = 0;

	/* Init DWC ep structure */
	pcd_ep->dwc_ep.is_in = is_in;
	pcd_ep->dwc_ep.num = ep_num;
	pcd_ep->dwc_ep.active = 0;
	pcd_ep->dwc_ep.tx_fifo_num = 0;
	/* Control until ep is actvated */
	pcd_ep->dwc_ep.type = DWC_OTG_EP_TYPE_CONTROL;
	pcd_ep->dwc_ep.maxpacket = 1024;
	pcd_ep->dwc_ep.dma_addr = 0;
	pcd_ep->dwc_ep.start_xfer_buff = 0;
	pcd_ep->dwc_ep.xfer_buff = 0;
	pcd_ep->dwc_ep.xfer_len = 0;
	pcd_ep->dwc_ep.xfer_count = 0;
	pcd_ep->dwc_ep.sent_zlp = 0;
	pcd_ep->dwc_ep.total_len = 0;
}


int f_usb_pcd_init()
{
	/**
	 *  Initialized the PCD portion of the driver.
	*/
	return f_dwc_core_init();
}

/*
  Register entry point for the peripheral controller driver.
*/
int usb_gadget_register_driver(struct usb_gadget_driver *driver)
{
	gadget_wrapper_t *dev = &gadget_wrapper;
	dwc_otg_pcd_ep_t *ep;
	int retval = 0;

	if (!driver
	    || (driver->speed != USB_SPEED_FULL
		&& driver->speed != USB_SPEED_HIGH)
	    || !driver->bind || !driver->disconnect || !driver->setup)
		return -EINVAL;
	if (!dev)
		return -ENODEV;
	if (dev->driver)
		return -EBUSY;

	/* first hook up the driver ... */
	dev->driver = driver;

	if (retval) { /* TODO */
		printf("target device_add failed, error %d\n", retval);
		return retval;
	}

	ep = &gadget_wrapper.pcd.dwc_eps[0];
	dwc_otg_pcd_init_ep(&gadget_wrapper.pcd, ep, 0, 0);

	ep = &gadget_wrapper.pcd.dwc_eps[1];
	dwc_otg_pcd_init_ep(&gadget_wrapper.pcd, ep, 1 /* IN */ , 1);

	ep = &gadget_wrapper.pcd.dwc_eps[2];
	dwc_otg_pcd_init_ep(&gadget_wrapper.pcd, ep, 0 /* OUT */ , 1);

	gadget_wrapper.pcd.dwc_eps[0].dwc_ep.maxpacket = 64;
	gadget_wrapper.pcd.dwc_eps[0].dwc_ep.type = DWC_OTG_EP_TYPE_CONTROL;
	gadget_wrapper.gadget.ops = &dwc_pcd_ops;

	gadget_add_eps(&gadget_wrapper);

	retval = driver->bind(&dev->gadget);
	if (retval) {
		dev->driver = 0;
		return retval;
	}

	f_usb_pcd_init();

	return 0;
}

int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
{
	gadget_wrapper_t *dev = &gadget_wrapper;

	if (!dev)
		return -ENODEV;
	if (!driver || driver != dev->driver)
		return -EINVAL;

	driver->unbind(&dev->gadget);

	dev->driver = NULL;

	return 0;
}

int usb_gadget_handle_interrupts(void)
{
	return usb_pcd_irq_loop();
}
