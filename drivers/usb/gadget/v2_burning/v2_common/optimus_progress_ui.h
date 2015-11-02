/*
 * \file        optimus_progress_ui.h
 * \brief       interfaces of optimus_progress_ui.c
 *
 * \version     1.0.0
 * \date        2013/10/13
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic Inc.. All Rights Reserved.
 *
 */
#ifndef __OPTIMUS_PROGRESS_UI__
#define __OPTIMUS_PROGRESS_UI__

//after erase_bootloader, before store_init
#define UPGRADE_STEPS_AFTER_IMAGE_OPEN_OK               2//disk_initialed failed if hang up here
#define UPGRADE_STEPS_AFTER_DISK_INIT_OK                5//burn data parts failed if hang up in [6, 95]
#define UPGRADE_STPES_AFTER_BURN_DATA_PARTS_OK          95
#define UPGRADE_STEPS_AFTER_BURN_BOOTLOADER_OK          98

#define UPGRADE_STEPS_FOR_BURN_DATA_PARTS_IN_PKG(allInPkg)     \
    ((allInPkg) ? (UPGRADE_STPES_AFTER_BURN_DATA_PARTS_OK - UPGRADE_STEPS_AFTER_DISK_INIT_OK - 1) : (UPGRADE_STPES_AFTER_BURN_DATA_PARTS_OK - UPGRADE_STEPS_AFTER_DISK_INIT_OK - 10))

#if CONFIG_SD_BURNING_SUPPORT_UI
int show_logo_to_report_burning(void);//show bmp 'upgrade_upgrading'

int show_logo_to_report_burn_failed(void); //Display logo to report burning result is failed

int show_logo_to_report_burn_success(void);

__hdle optimus_progress_ui_request(const int totalPercents_f,       int startPercent,
                                 unsigned long bmpBarAddr,       int display_width,  int progressBarY_f );
__hdle optimus_progress_ui_request_for_sdc_burn(void);

int optimus_progress_ui_release(__hdle hUiPrgress);

int optimus_progress_ui_set_unfocus_bkg(__hdle hUiProgress, unsigned long unfocusBmpAddr);

int optimus_progress_ui_direct_update_progress(__hdle hUiProgress, const int percents);

int optimus_progress_ui_report_upgrade_stat(__hdle hUiProgress, const int isSuccess);

//smart mode with bytes
int optimus_progress_ui_set_smart_mode(__hdle hUiProgress, const u64 smartModeTotalBytes_f, const unsigned smartModePercents);
int optimus_progress_ui_update_by_bytes(__hdle hUiPrgress, const unsigned nBytes);

int optimus_progress_ui_printf(const char* fmt, ...);

int video_res_prepare_for_upgrade(HIMAGE hImg);

#else

#define video_res_prepare_for_upgrade(hImg) 0

#define show_logo_to_report_burning()

#define show_logo_to_report_burn_failed()   0

#define show_logo_to_report_burn_success()  0

#define optimus_progress_ui_request(totalPercents_f,startPercent, bmpBarAddr,display_width,progressBarY_f ) 1

#define optimus_progress_ui_request_for_sdc_burn() (void*)1

#define optimus_progress_ui_release(hUiPrgress)     do{}while(0)

#define optimus_progress_ui_set_unfocus_bkg(hUiProgress, unfocusBmpAddr)    0

#define optimus_progress_ui_direct_update_progress(a ...)   do{}while(0)

//smart mode with bytes
#define optimus_progress_ui_set_smart_mode(a ...)  0
#define optimus_progress_ui_update_by_bytes(hUiPrgress, nBytes) do{}while(0)

#define  optimus_progress_ui_report_upgrade_stat(a ...) do{}while(0)

#define optimus_progress_ui_printf(a ...) do{}while(0)

#endif//#if CONFIG_SD_BURNING_SUPPORT_UI

#endif//ifndef __OPTIMUS_PROGRESS_UI__

