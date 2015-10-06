/*
 * URB OHCI HCD (Host Controller Driver) for USB on the S3C24XX.
 *
 * (C) Copyright 2003
 * Gary Jennejohn, DENX Software Engineering <gj@denx.de>
 *
 * Note: Much of this code has been derived from Linux 2.4
 * (C) Copyright 1999 Roman Weissgaerber <weissg@vienna.at>
 * (C) Copyright 2000-2002 David Brownell
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 */
/*
 * IMPORTANT NOTES
 * 1 - you MUST define LITTLEENDIAN in the configuration file for the
 *     board or this driver will NOT work!
 * 2 - this driver is intended for use with USB Mass Storage Devices
 *     (BBB) ONLY. There is NO support for Interrupt or Isochronous pipes!
 */

#include <common.h>

#ifdef CONFIG_USB_OHCI

#include <malloc.h>
#include <usb.h>

#include <asm/arch/cpu.h>

#include "usb_ohci.h"


#define OHCI_USE_NPS		/* force NoPowerSwitching mode */
#define OHCI_VERBOSE_DEBUG	/* not always helpful */


/* For initializing controller (mask in an HCFS mode too) */
#define	OHCI_CONTROL_INIT \
	(OHCI_CTRL_CBSR & 0x3) | OHCI_CTRL_IE | OHCI_CTRL_PLE

#define readl(a) (*((vu_long *)(a)))
#define writel(a, b) (*((vu_long *)(b)) = ((vu_long)a))

#define min_t(type,x,y) ({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })

#undef DEBUG_USB_OHCI
#ifdef DEBUG_USB_OHCI
#define dbg(format, arg...) printf("DEBUG: " format "\n", ## arg)
#else
#define dbg(format, arg...) do {} while(0)
#endif /* DEBUG_USB_OHCI */
#define err(format, arg...) printf("ERROR: " format "\n", ## arg)
#undef SHOW_INFO
#ifdef SHOW_INFO
#define info(format, arg...) printf("INFO: " format "\n", ## arg)
#else
#define info(format, arg...) do {} while(0)
#endif

#define m16_swap(x) le16_to_cpu(x)
#define m32_swap(x) le32_to_cpu(x)

/* global ohci_t */
static ohci_t gohci;
/* this must be aligned to a 256 byte boundary */
struct ohci_hcca ghcca[1];
/* a pointer to the aligned storage */
struct ohci_hcca *phcca;
/* this allocates EDs for all possible endpoints */
struct ohci_device ohci_dev;
/* urb_priv */
urb_priv_t urb_priv;
/* RHSC flag */
int got_rhsc;
/* device which was disconnected */
struct usb_device *devgone;

/*-------------------------------------------------------------------------*/

/* AMD-756 (D2 rev) reports corrupt register contents in some cases.
 * The erratum (#4) description is incorrect.  AMD's workaround waits
 * till some bits (mostly reserved) are clear; ok for all revs.
 */
#define OHCI_QUIRK_AMD756 0xabcd
#define read_roothub(hc, register, mask) ({ \
	u32 temp = readl (&hc->regs->roothub.register); \
	if (hc->flags & OHCI_QUIRK_AMD756) \
		while (temp & mask) \
			temp = readl (&hc->regs->roothub.register); \
	temp; })

 static inline u32 roothub_b (struct ohci *hc)
	{ return readl (&hc->regs->roothub.b); }
static inline u32 roothub_status (struct ohci *hc)
	{ return readl (&hc->regs->roothub.status); }


/* forward declaration */
static void
td_submit_job (struct usb_device * dev, unsigned long pipe, void * buffer,
	int transfer_len, struct devrequest * setup, urb_priv_t * urb, int interval);

/*-------------------------------------------------------------------------*
 * URB support functions
 *-------------------------------------------------------------------------*/

/* free HCD-private data associated with this URB */

static void urb_free_priv (urb_priv_t * urb)
{
	int		i;
	int		last;
	struct td	* td;

	last = urb->length - 1;
	if (last >= 0) {
		for (i = 0; i <= last; i++) {
			td = urb->td[i];
			if (td) {
				td->usb_dev = NULL;
				urb->td[i] = NULL;
			}
		}
	}
}

/*-------------------------------------------------------------------------*/

#ifdef DEBUG_USB_OHCI
static int sohci_get_current_frame_number (struct usb_device * dev);

/* debug| print the main components of an URB
 * small: 0) header + data packets 1) just header */

static void pkt_print (struct usb_device * dev, unsigned long pipe, void * buffer,
	int transfer_len, struct devrequest * setup, char * str, int small)
{
	urb_priv_t * purb = &urb_priv;

	dbg("%s URB:[%4x] dev:%2d,ep:%2d-%c,type:%s,len:%d/%d stat:%#lx",
			str,
			sohci_get_current_frame_number (dev),
			usb_pipedevice (pipe),
			usb_pipeendpoint (pipe),
			usb_pipeout (pipe)? 'O': 'I',
			usb_pipetype (pipe) < 2? (usb_pipeint (pipe)? "INTR": "ISOC"):
				(usb_pipecontrol (pipe)? "CTRL": "BULK"),
			purb->actual_length,
			transfer_len, dev->status);
#ifdef	OHCI_VERBOSE_DEBUG
	if (!small) {
		int i, len;

		if (usb_pipecontrol (pipe)) {
			printf (__FILE__ ": cmd(8):");
			for (i = 0; i < 8 ; i++)
				printf (" %02x", ((__u8 *) setup) [i]);
			printf ("\n");
		}
		if (transfer_len > 0 && buffer) {
			printf (__FILE__ ": data(%d/%d):",
				purb->actual_length,
				transfer_len);
			len = usb_pipeout (pipe)?
					transfer_len: purb->actual_length;
			for (i = 0; i < 16 && i < len; i++)
				printf (" %02x", ((__u8 *) buffer) [i]);
			printf ("%s\n", i < len? "...": "");
		}
	}
#endif
}

/* just for debugging; prints non-empty branches of the int ed tree inclusive iso eds*/
void ep_print_int_eds (ohci_t *ohci, char * str) {
	int i, j;
	 __u32 * ed_p;
	for (i= 0; i < 32; i++) {
		j = 5;
		ed_p = &(ohci->hcca->int_table [i]);
		if (*ed_p == 0)
		    continue;
		printf (__FILE__ ": %s branch int %2d(%2x):", str, i, i);
		while (*ed_p != 0 && j--) {
			ed_t *ed = (ed_t *)m32_swap(ed_p);
			printf (" ed: %4x;", ed->hwINFO);
			ed_p = &ed->hwNextED;
		}
		printf ("\n");
	}
}

static void ohci_dump_intr_mask (char *label, __u32 mask)
{
	dbg ("%s: 0x%08x%s%s%s%s%s%s%s%s%s",
		label,
		mask,
		(mask & OHCI_INTR_MIE) ? " MIE" : "",
		(mask & OHCI_INTR_OC) ? " OC" : "",
		(mask & OHCI_INTR_RHSC) ? " RHSC" : "",
		(mask & OHCI_INTR_FNO) ? " FNO" : "",
		(mask & OHCI_INTR_UE) ? " UE" : "",
		(mask & OHCI_INTR_RD) ? " RD" : "",
		(mask & OHCI_INTR_SF) ? " SF" : "",
		(mask & OHCI_INTR_WDH) ? " WDH" : "",
		(mask & OHCI_INTR_SO) ? " SO" : ""
		);
}

static void maybe_print_eds (char *label, __u32 value)
{
	ed_t *edp = (ed_t *)value;

	if (value) {
		dbg ("%s %08x", label, value);
		dbg ("%08x", edp->hwINFO);
		dbg ("%08x", edp->hwTailP);
		dbg ("%08x", edp->hwHeadP);
		dbg ("%08x", edp->hwNextED);
	}
}

static char * hcfs2string (int state)
{
	switch (state) {
		case OHCI_USB_RESET:	return "reset";
		case OHCI_USB_RESUME:	return "resume";
		case OHCI_USB_OPER:	return "operational";
		case OHCI_USB_SUSPEND:	return "suspend";
	}
	return "?";
}

/* dump control and status registers */
static void ohci_dump_status (ohci_t *controller)
{
	struct ohci_regs	*regs = controller->regs;
	__u32			temp;

	temp = readl (&regs->revision) & 0xff;
	if (temp != 0x10)
		dbg ("spec %d.%d", (temp >> 4), (temp & 0x0f));

	temp = readl (&regs->control);
	dbg ("control: 0x%08x%s%s%s HCFS=%s%s%s%s%s CBSR=%d", temp,
		(temp & OHCI_CTRL_RWE) ? " RWE" : "",
		(temp & OHCI_CTRL_RWC) ? " RWC" : "",
		(temp & OHCI_CTRL_IR) ? " IR" : "",
		hcfs2string (temp & OHCI_CTRL_HCFS),
		(temp & OHCI_CTRL_BLE) ? " BLE" : "",
		(temp & OHCI_CTRL_CLE) ? " CLE" : "",
		(temp & OHCI_CTRL_IE) ? " IE" : "",
		(temp & OHCI_CTRL_PLE) ? " PLE" : "",
		temp & OHCI_CTRL_CBSR
		);

	temp = readl (&regs->cmdstatus);
	dbg ("cmdstatus: 0x%08x SOC=%d%s%s%s%s", temp,
		(temp & OHCI_SOC) >> 16,
		(temp & OHCI_OCR) ? " OCR" : "",
		(temp & OHCI_BLF) ? " BLF" : "",
		(temp & OHCI_CLF) ? " CLF" : "",
		(temp & OHCI_HCR) ? " HCR" : ""
		);

	ohci_dump_intr_mask ("intrstatus", readl (&regs->intrstatus));
	ohci_dump_intr_mask ("intrenable", readl (&regs->intrenable));

	maybe_print_eds ("ed_periodcurrent", readl (&regs->ed_periodcurrent));

	maybe_print_eds ("ed_controlhead", readl (&regs->ed_controlhead));
	maybe_print_eds ("ed_controlcurrent", readl (&regs->ed_controlcurrent));

	maybe_print_eds ("ed_bulkhead", readl (&regs->ed_bulkhead));
	maybe_print_eds ("ed_bulkcurrent", readl (&regs->ed_bulkcurrent));

	maybe_print_eds ("donehead", readl (&regs->donehead));
}

static void ohci_dump_roothub (ohci_t *controller, int verbose)
{
	__u32			temp, ndp, i;

	temp = roothub_a (controller);
	ndp = (temp & RH_A_NDP);

	if (verbose) {
		dbg ("roothub.a: %08x POTPGT=%d%s%s%s%s%s NDP=%d", temp,
			((temp & RH_A_POTPGT) >> 24) & 0xff,
			(temp & RH_A_NOCP) ? " NOCP" : "",
			(temp & RH_A_OCPM) ? " OCPM" : "",
			(temp & RH_A_DT) ? " DT" : "",
			(temp & RH_A_NPS) ? " NPS" : "",
			(temp & RH_A_PSM) ? " PSM" : "",
			ndp
			);
		temp = roothub_b (controller);
		dbg ("roothub.b: %08x PPCM=%04x DR=%04x",
			temp,
			(temp & RH_B_PPCM) >> 16,
			(temp & RH_B_DR)
			);
		temp = roothub_status (controller);
		dbg ("roothub.status: %08x%s%s%s%s%s%s",
			temp,
			(temp & RH_HS_CRWE) ? " CRWE" : "",
			(temp & RH_HS_OCIC) ? " OCIC" : "",
			(temp & RH_HS_LPSC) ? " LPSC" : "",
			(temp & RH_HS_DRWE) ? " DRWE" : "",
			(temp & RH_HS_OCI) ? " OCI" : "",
			(temp & RH_HS_LPS) ? " LPS" : ""
			);
	}

	for (i = 0; i < ndp; i++) {
		temp = roothub_portstatus (controller, i);
		dbg ("roothub.portstatus [%d] = 0x%08x%s%s%s%s%s%s%s%s%s%s%s%s",
			i,
			temp,
			(temp & RH_PS_PRSC) ? " PRSC" : "",
			(temp & RH_PS_OCIC) ? " OCIC" : "",
			(temp & RH_PS_PSSC) ? " PSSC" : "",
			(temp & RH_PS_PESC) ? " PESC" : "",
			(temp & RH_PS_CSC) ? " CSC" : "",

			(temp & RH_PS_LSDA) ? " LSDA" : "",
			(temp & RH_PS_PPS) ? " PPS" : "",
			(temp & RH_PS_PRS) ? " PRS" : "",
			(temp & RH_PS_POCI) ? " POCI" : "",
			(temp & RH_PS_PSS) ? " PSS" : "",

			(temp & RH_PS_PES) ? " PES" : "",
			(temp & RH_PS_CCS) ? " CCS" : ""
			);
	}
}

static void ohci_dump (ohci_t *controller, int verbose)
{
	dbg ("OHCI controller usb-%s state", controller->slot_name);

	/* dumps some of the state we know about */
	ohci_dump_status (controller);
	if (verbose)
		ep_print_int_eds (controller, "hcca");
	dbg ("hcca frame #%04x", controller->hcca->frame_no);
	ohci_dump_roothub (controller, 1);
}


#endif /* DEBUG_USB_OHCI */

/*-------------------------------------------------------------------------*
 * Interface functions (URB)
 *-------------------------------------------------------------------------*/

/* get a transfer request */

int sohci_submit_job(struct usb_device *dev, unsigned long pipe, void *buffer,
		int transfer_len, struct devrequest *setup, int interval)
{
	ohci_t *ohci;
	ed_t * ed;
	urb_priv_t *purb_priv;
	int i, size = 0;

	ohci = &gohci;

	/* when controller's hung, permit only roothub cleanup attempts
	 * such as powering down ports */
	if (ohci->disabled) {
		err("sohci_submit_job: EPIPE");
		return -1;
	}

	/* every endpoint has a ed, locate and fill it */
	if (!(ed = ep_add_ed (dev, pipe))) {
		err("sohci_submit_job: ENOMEM");
		return -1;
	}

	/* for the private part of the URB we need the number of TDs (size) */
	switch (usb_pipetype (pipe)) {
		case PIPE_BULK:	/* one TD for every 4096 Byte */
			size = (transfer_len - 1) / 4096 + 1;
			break;
		case PIPE_CONTROL: /* 1 TD for setup, 1 for ACK and 1 for every 4096 B */
			size = (transfer_len == 0)? 2:
						(transfer_len - 1) / 4096 + 3;
			break;
	}

	if (size >= (N_URB_TD - 1)) {
		err("need %d TDs, only have %d", size, N_URB_TD);
		return -1;
	}
	purb_priv = &urb_priv;
	purb_priv->pipe = pipe;

	/* fill the private part of the URB */
	purb_priv->length = size;
	purb_priv->ed = ed;
	purb_priv->actual_length = 0;

	/* allocate the TDs */
	/* note that td[0] was allocated in ep_add_ed */
	for (i = 0; i < size; i++) {
		purb_priv->td[i] = td_alloc (dev);
		if (!purb_priv->td[i]) {
			purb_priv->length = i;
			urb_free_priv (purb_priv);
			err("sohci_submit_job: ENOMEM");
			return -1;
		}
	}

	if (ed->state == ED_NEW || (ed->state & ED_DEL)) {
		urb_free_priv (purb_priv);
		err("sohci_submit_job: EINVAL");
		return -1;
	}

	/* link the ed into a chain if is not already */
	if (ed->state != ED_OPER)
		ep_link (ohci, ed);

	/* fill the TDs and link it to the ed */
	td_submit_job(dev, pipe, buffer, transfer_len, setup, purb_priv, interval);

	return 0;
}

/*-------------------------------------------------------------------------*/

#ifdef DEBUG_USB_OHCI
/* tell us the current USB frame number */

static int sohci_get_current_frame_number (struct usb_device *usb_dev)
{
	ohci_t *ohci = &gohci;

	return m16_swap (ohci->hcca->frame_no);
}
#endif

/*-------------------------------------------------------------------------*
 * ED handling functions
 *-------------------------------------------------------------------------*/

/* link an ed into one of the HC chains */

static int ep_link (ohci_t *ohci, ed_t *edi)
{
	volatile ed_t *ed = edi;

	ed->state = ED_OPER;

	switch (ed->type) {
	case PIPE_CONTROL:
		ed->hwNextED = 0;
		if (ohci->ed_controltail == NULL) {
			writel (ed, &ohci->regs->ed_controlhead);
		} else {
			ohci->ed_controltail->hwNextED = m32_swap (ed);
		}
		ed->ed_prev = ohci->ed_controltail;
		if (!ohci->ed_controltail && !ohci->ed_rm_list[0] &&
			!ohci->ed_rm_list[1] && !ohci->sleeping) {
			ohci->hc_control |= OHCI_CTRL_CLE;
			writel (ohci->hc_control, &ohci->regs->control);
		}
		ohci->ed_controltail = edi;
		break;

	case PIPE_BULK:
		ed->hwNextED = 0;
		if (ohci->ed_bulktail == NULL) {
			writel (ed, &ohci->regs->ed_bulkhead);
		} else {
			ohci->ed_bulktail->hwNextED = m32_swap (ed);
		}
		ed->ed_prev = ohci->ed_bulktail;
		if (!ohci->ed_bulktail && !ohci->ed_rm_list[0] &&
			!ohci->ed_rm_list[1] && !ohci->sleeping) {
			ohci->hc_control |= OHCI_CTRL_BLE;
			writel (ohci->hc_control, &ohci->regs->control);
		}
		ohci->ed_bulktail = edi;
		break;
	}
	return 0;
}

/*-------------------------------------------------------------------------*/

/* unlink an ed from one of the HC chains.
 * just the link to the ed is unlinked.
 * the link from the ed still points to another operational ed or 0
 * so the HC can eventually finish the processing of the unlinked ed */

/*-------------------------------------------------------------------------*/

/* add/reinit an endpoint; this should be done once at the usb_set_configuration command,
 * but the USB stack is a little bit stateless  so we do it at every transaction
 * if the state of the ed is ED_NEW then a dummy td is added and the state is changed to ED_UNLINK
 * in all other cases the state is left unchanged
 * the ed info fields are setted anyway even though most of them should not change */

static ed_t * ep_add_ed (struct usb_device *usb_dev, unsigned long pipe)
{
	td_t *td;
	ed_t *ed_ret;
	volatile ed_t *ed;

	ed = ed_ret = &ohci_dev.ed[(usb_pipeendpoint (pipe) << 1) |
			(usb_pipecontrol (pipe)? 0: usb_pipeout (pipe))];

	if ((ed->state & ED_DEL) || (ed->state & ED_URB_DEL)) {
		err("ep_add_ed: pending delete");
		/* pending delete request */
		return NULL;
	}

	if (ed->state == ED_NEW) {
		ed->hwINFO = m32_swap (OHCI_ED_SKIP); /* skip ed */
		/* dummy td; end of td list for ed */
		td = td_alloc (usb_dev);
		ed->hwTailP = m32_swap (td);
		ed->hwHeadP = ed->hwTailP;
		ed->state = ED_UNLINK;
		ed->type = usb_pipetype (pipe);
		ohci_dev.ed_cnt++;
	}

	ed->hwINFO = m32_swap (usb_pipedevice (pipe)
			| usb_pipeendpoint (pipe) << 7
			| (usb_pipeisoc (pipe)? 0x8000: 0)
			| (usb_pipecontrol (pipe)? 0: (usb_pipeout (pipe)? 0x800: 0x1000))
			| usb_pipeslow (pipe) << 13
			| usb_maxpacket (usb_dev, pipe) << 16);

	return ed_ret;
}

/*-------------------------------------------------------------------------*
 * TD handling functions
 *-------------------------------------------------------------------------*/

/* enqueue next TD for this URB (OHCI spec 5.2.8.2) */

static void td_fill (ohci_t *ohci, unsigned int info,
	void *data, int len,
	struct usb_device *dev, int index, urb_priv_t *urb_priv)
{
	volatile td_t  *td, *td_pt;
#ifdef OHCI_FILL_TRACE
	int i;
#endif

	if (index > urb_priv->length) {
		err("index > length");
		return;
	}
	/* use this td as the next dummy */
	td_pt = urb_priv->td [index];
	td_pt->hwNextTD = 0;

	/* fill the old dummy TD */
	td = urb_priv->td [index] = (td_t *)(m32_swap (urb_priv->ed->hwTailP) & ~0xf);

	td->ed = urb_priv->ed;
	td->next_dl_td = NULL;
	td->index = index;
	td->data = (__u32)data;
#ifdef OHCI_FILL_TRACE
	if ((usb_pipetype(urb_priv->pipe) == PIPE_BULK) && usb_pipeout(urb_priv->pipe)) {
		for (i = 0; i < len; i++)
		printf("td->data[%d] %#2x ",i, ((unsigned char *)td->data)[i]);
		printf("\n");
	}
#endif
	if (!len)
		data = 0;

	td->hwINFO = m32_swap (info);
	td->hwCBP = m32_swap (data);
	if (data)
		td->hwBE = m32_swap (data + len - 1);
	else
		td->hwBE = 0;
	td->hwNextTD = m32_swap (td_pt);
	td->hwPSW [0] = m16_swap (((__u32)data & 0x0FFF) | 0xE000);

	/* append to queue */
	td->ed->hwTailP = td->hwNextTD;
}

/*-------------------------------------------------------------------------*/

/* prepare all TDs of a transfer */
static void td_submit_job (struct usb_device *dev, unsigned long pipe, void *buffer,
	int transfer_len, struct devrequest *setup, urb_priv_t *urb, int interval)
{
	ohci_t *ohci = &gohci;
	int data_len = transfer_len;
	void *data;
	int cnt = 0;
	__u32 info = 0;
	unsigned int toggle = 0;

	/* OHCI handles the DATA-toggles itself, we just use the USB-toggle bits for reseting */
	if(usb_gettoggle(dev, usb_pipeendpoint(pipe), usb_pipeout(pipe))) {
		toggle = TD_T_TOGGLE;
	} else {
		toggle = TD_T_DATA0;
		usb_settoggle(dev, usb_pipeendpoint(pipe), usb_pipeout(pipe), 1);
	}
	urb->td_cnt = 0;
	if (data_len)
		data = buffer;
	else
		data = 0;

	switch (usb_pipetype (pipe)) {
	case PIPE_BULK:
		info = usb_pipeout (pipe)?
			TD_CC | TD_DP_OUT : TD_CC | TD_DP_IN ;
		while(data_len > 4096) {
			td_fill (ohci, info | (cnt? TD_T_TOGGLE:toggle), data, 4096, dev, cnt, urb);
			data += 4096; data_len -= 4096; cnt++;
		}
		info = usb_pipeout (pipe)?
			TD_CC | TD_DP_OUT : TD_CC | TD_R | TD_DP_IN ;
		td_fill (ohci, info | (cnt? TD_T_TOGGLE:toggle), data, data_len, dev, cnt, urb);
		cnt++;

		if (!ohci->sleeping)
			writel (OHCI_BLF, &ohci->regs->cmdstatus); /* start bulk list */
		break;

	case PIPE_CONTROL:
		info = TD_CC | TD_DP_SETUP | TD_T_DATA0;
		td_fill (ohci, info, setup, 8, dev, cnt++, urb);
		if (data_len > 0) {
			info = usb_pipeout (pipe)?
				TD_CC | TD_R | TD_DP_OUT | TD_T_DATA1 : TD_CC | TD_R | TD_DP_IN | TD_T_DATA1;
			/* NOTE:  mishandles transfers >8K, some >4K */
			td_fill (ohci, info, data, data_len, dev, cnt++, urb);
		}
		info = usb_pipeout (pipe)?
			TD_CC | TD_DP_IN | TD_T_DATA1: TD_CC | TD_DP_OUT | TD_T_DATA1;
		td_fill (ohci, info, data, 0, dev, cnt++, urb);
		if (!ohci->sleeping)
			writel (OHCI_CLF, &ohci->regs->cmdstatus); /* start Control list */
		break;
	}
	if (urb->length != cnt)
		dbg("TD LENGTH %d != CNT %d", urb->length, cnt);
}

/*-------------------------------------------------------------------------*
 * Done List handling functions
 *-------------------------------------------------------------------------*/
/* Hub class-specific descriptor is constructed dynamically */


/*-------------------------------------------------------------------------*/

#define OK(x) 			len = (x); break
#ifdef DEBUG_USB_OHCI
#define WR_RH_STAT(x) 		{info("WR:status %#8x", (x));writel((x), &gohci.regs->roothub.status);}
#define WR_RH_PORTSTAT(x) 	{info("WR:portstatus[%d] %#8x", wIndex-1, (x));writel((x), &gohci.regs->roothub.portstatus[wIndex-1]);}
#else
#define WR_RH_STAT(x) 		writel((x), &gohci.regs->roothub.status)
#define WR_RH_PORTSTAT(x) 	writel((x), &gohci.regs->roothub.portstatus[wIndex-1])
#endif
#define RD_RH_STAT		roothub_status(&gohci)
#define RD_RH_PORTSTAT		roothub_portstatus(&gohci,wIndex-1)

/* request to virtual root hub */

int rh_check_port_status(ohci_t *controller)
{
	return 0;
}

 /*-------------------------------------------------------------------------*/

/* common code for handling submit messages - used for all but root hub */
/* accesses. */
int submit_common_msg(struct usb_device *dev, unsigned long pipe, void *buffer,
		int transfer_len, struct devrequest *setup, int interval)
{
	return 0;
}

/* submit routines called from usb.c */
int submit_bulk_msg(struct usb_device *dev, unsigned long pipe, void *buffer,
		int transfer_len)
{
	info("submit_bulk_msg");
	return submit_common_msg(dev, pipe, buffer, transfer_len, NULL, 0);
}

int submit_control_msg(struct usb_device *dev, unsigned long pipe, void *buffer,
		int transfer_len, struct devrequest *setup)
{
	return 0;
}

int submit_int_msg(struct usb_device *dev, unsigned long pipe, void *buffer,
		int transfer_len, int interval)
{
	info("submit_int_msg");
	return -1;
}

/*-------------------------------------------------------------------------*
 * HC functions
 *-------------------------------------------------------------------------*/

/* reset the HC and BUS */
int usb_lowlevel_init(void)
{
	return 0;
}

int usb_lowlevel_stop(void)
{
	return 0;
}

#endif /* CONFIG_USB_OHCI */
