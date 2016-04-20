#include <common.h>
#include "platform.h"
#include "usb_pcd.h"

#include "usb_pcd.c"
#include "platform.c"
#include "dwc_pcd.c"
#include "dwc_pcd_irq.c"

DECLARE_GLOBAL_DATA_PTR;

int v2_usbburning(unsigned timeout)
{
        int cfg = EXT_CLOCK;

#if defined(CONFIG_SILENT_CONSOLE)
        gd->flags &= ~GD_FLG_SILENT;
#endif
        printf("InUsbBurn\n");
        set_usb_phy_config(cfg);
        usb_parameter_init(timeout);
        if (usb_pcd_init()) {
                /*printf("Fail in usb_pcd_init\n");*/
                return __LINE__;
        }

#if (MESON_CPU_TYPE_MESON8 <= MESON_CPU_TYPE)
        //AML_WATCH_DOG_DISABLE(); //disable watchdog
#endif// #if (MESON_CPU_TYPE_MESON8 <= MESON_CPU_TYPE)

        while (1)
        {
                //watchdog_clear();		//Elvis Fool
                if (usb_pcd_irq())
                        break;
        }
        return 0;
}

int do_v2_usbtool (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rc = 0;
    unsigned timeout            = (2 <= argc) ? simple_strtoul(argv[1], NULL, 0) : 0;
    //if get burning tool identify command in pcToolWaitTime, then auto jump into burning mode
    unsigned pcToolWaitTime     = (3 <= argc) ? simple_strtoul(argv[2], NULL, 0) : 0;

    optimus_work_mode_set(OPTIMUS_WORK_MODE_USB_UPDATE);
    setenv(_ENV_TIME_OUT_TO_AUTO_BURN, pcToolWaitTime ? argv[2] : "");

    rc = v2_usbburning(timeout);
    /*close_usb_phy_clock(0);*/

    return rc;
}


U_BOOT_CMD(
	update,	3,	0,	do_v2_usbtool,
	"Enter v2 usbburning mode",
	"usbburning timeout"
);

