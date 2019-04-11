/*
*  Copyright (c) 2014 MediaTek Inc.
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License version 2 as
*  published by the Free Software Foundation.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*  GNU General Public License for more details.
*/

/** steve wang 2015/11/26 */
//---------------------------------------------------------------------------
#include "LD_usbbt.h"
#include "LD_btmtk_usb.h"
#include "errno.h"

//- Local Configuration -----------------------------------------------------
#define LD_VERSION "1.2.0.1"

#define BUFFER_SIZE  (1024 * 4)     /* Size of RX Queue */
#define BT_SEND_HCI_CMD_BEFORE_SUSPEND 1
#define LD_SUPPORT_FW_DUMP 0
#define LD_BT_ALLOC_BUF 0
#define LD_NOT_FIX_BUILD_WARN 0

#define FIDX 0x5A   /* Unify WoBLE APCF Filtering Index */

#ifndef strtol
#define strtol simple_strtol
#endif

//---------------------------------------------------------------------------
static char driver_version[64] = { 0 };
static unsigned char probe_counter = 0;
static volatile int metaMode;
static volatile int metaCount;
/* 0: False; 1: True */
static int isbtready;
static int isUsbDisconnet;
static volatile int is_assert = 0;

//---------------------------------------------------------------------------
static inline int is_mt7630(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffff0000) == 0x76300000);
}

//---------------------------------------------------------------------------
static inline int is_mt7650(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffff0000) == 0x76500000);
}

//---------------------------------------------------------------------------
static inline int is_mt7632(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffff0000) == 0x76320000);
}

//---------------------------------------------------------------------------
static inline int is_mt7662(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffff0000) == 0x76620000);
}

//---------------------------------------------------------------------------
static inline int is_mt7662T(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffffffff) == 0x76620100);
}

//---------------------------------------------------------------------------
static inline int is_mt7632T(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffffffff) == 0x76320100);
}

//---------------------------------------------------------------------------
static inline int is_mt7668(struct LD_btmtk_usb_data *data)
{
    return ((data->chip_id & 0xffff) == 0x7668);
}

//---------------------------------------------------------------------------
static int btmtk_usb_io_read32(struct LD_btmtk_usb_data *data, u32 reg, u32 *val)
{
    u8 request = data->r_request;
    int ret;

    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_RX_EP, request,
            DEVICE_VENDOR_REQUEST_IN, 0, (u16)reg, data->io_buf, sizeof(u32),
            CONTROL_TIMEOUT_JIFFIES);

    if (ret < 0)
    {
        *val = 0xffffffff;
        usb_debug("error(%d), reg=%x, value=%x\n", ret, reg, *val);
        return ret;
    }

    os_memmove(val, data->io_buf, sizeof(u32));
    *val = le32_to_cpu(*val);
    return 0;
}

//---------------------------------------------------------------------------
static int btmtk_usb_io_read32_7668(struct LD_btmtk_usb_data *data, u32 reg, u32 *val)
{
    int ret = -1;
    __le16 reg_high;
    __le16 reg_low;

    reg_high = ((reg >> 16) & 0xFFFF);
    reg_low = (reg & 0xFFFF);

    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_RX_EP, 0x63,
            DEVICE_VENDOR_REQUEST_IN, reg_high, reg_low, data->io_buf, sizeof(u32),
            CONTROL_TIMEOUT_JIFFIES);
    if (ret < 0) {
        *val = 0xFFFFFFFF;
        usb_debug("error(%d), reg=%X, value=%X\n", ret, reg, *val);
        return ret;
    }

    os_memmove(val, data->io_buf, sizeof(u32));
    *val = le32_to_cpu(*val);
    return 0;
}

//---------------------------------------------------------------------------
static int btmtk_usb_io_write32(struct LD_btmtk_usb_data *data, u32 reg, u32 val)
{
    u16 value, index;
    u8 request = data->w_request;
    mtkbt_dev_t *udev = data->udev;
    int ret;

    index = (u16) reg;
    value = val & 0x0000ffff;

    ret = data->hcif->usb_control_msg(udev, MTKBT_CTRL_TX_EP, request, DEVICE_VENDOR_REQUEST_OUT,
              value, index, NULL, 0, CONTROL_TIMEOUT_JIFFIES);

    if (ret < 0)
    {
        usb_debug("error(%d), reg=%x, value=%x\n", ret, reg, val);
        return ret;
    }

    index = (u16) (reg + 2);
    value = (val & 0xffff0000) >> 16;

    ret = data->hcif->usb_control_msg(udev, MTKBT_CTRL_TX_EP, request, DEVICE_VENDOR_REQUEST_OUT,
                  value, index, NULL, 0, CONTROL_TIMEOUT_JIFFIES);

    if (ret < 0)
    {
        usb_debug("error(%d), reg=%x, value=%x\n", ret, reg, val);
        return ret;
    }
    if (ret > 0)
    {
        ret = 0;
    }
    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_wmt_cmd(struct LD_btmtk_usb_data *data, const u8 *cmd,
        const int cmd_len, const u8 *event, const int event_len, u32 delay, u8 retry)
{
    int ret = -1;
    BOOL check = FALSE;

    if (!data || !data->hcif || !data->io_buf || !cmd) {
        usb_debug("incorrect cmd pointer\n");
        return -1;
    }
    if (event != NULL && event_len > 0)
        check = TRUE;

    /* send WMT command */
    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_TX_EP, 0x01,
            DEVICE_CLASS_REQUEST_OUT, 0x30, 0x00, (void *)cmd, cmd_len,
            CONTROL_TIMEOUT_JIFFIES);
    if (ret < 0) {
        usb_debug("command send failed(%d)\n", ret);
        return ret;
    }

    if (event_len == -1) {
        /* If event_len is -1, DO NOT read event, since FW wouldn't feedback */
        return 0;
    }

retry_get:
    MTK_MDELAY(delay);

    /* check WMT event */
    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_RX_EP, 0x01,
            DEVICE_VENDOR_REQUEST_IN, 0x30, 0x00, data->io_buf, LD_BT_MAX_EVENT_SIZE,
            CONTROL_TIMEOUT_JIFFIES);
    if (ret < 0) {
        usb_debug("event get failed(%d)\n", ret);
        if (check == TRUE) return ret;
        else return 0;
    }

    if (check == TRUE) {
        if (ret >= event_len && memcmp(event, data->io_buf, event_len) == 0) {
            return ret;
        } else if (retry > 0) {
            usb_debug("retry to get event(%d)\n", retry);
            retry--;
            goto retry_get;
        } else {
            usb_debug("can't get expect event\n");
        }
    }
    return -1;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_hci_cmd(struct LD_btmtk_usb_data *data, const u8 *cmd,
        const int cmd_len, const u8 *event, const int event_len)
{
    /** @RETURN
     *     length if event compare successfully.,
     *     0 if doesn't check event.,
     *     < 0 if error.
     */
#define USB_CTRL_IO_TIMO    100
#define USB_INTR_MSG_TIMO   2000
    int ret = -1;
    int len = 0;
    int i = 0;
    u8 retry = 0;
    BOOL check = FALSE;

    if (!data || !data->hcif || !data->io_buf || !cmd) {
        usb_debug("incorrect cmd pointer\n");
        return -1;
    }
    if (event != NULL && event_len > 0)
        check = TRUE;

    /* send HCI command */
    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_TX_EP, 0,
            DEVICE_CLASS_REQUEST_OUT, 0, 0, (u8 *)cmd, cmd_len, USB_CTRL_IO_TIMO);
    if (ret < 0) {
        usb_debug("send command failed: %d\n", ret);
        return ret;
    }

    if (event_len == -1) {
        /* If event_len is -1, DO NOT read event, since FW wouldn't feedback */
        return 0;
    }

    /* check HCI event */
    do {
        ret = data->hcif->usb_interrupt_msg(data->udev, MTKBT_INTR_EP, data->io_buf,
                LD_BT_MAX_EVENT_SIZE, &len, USB_INTR_MSG_TIMO);
        if (ret < 0) {
            usb_debug("event get failed: %d\n", ret);
            if (check == TRUE) return ret;
            else return 0;
        }

        if (check == TRUE) {
            if (len >= event_len) {
                for (i = 0; i < event_len; i++) {
                    if (event[i] != data->io_buf[i])
                        break;
                }
            } else {
                usb_debug("event length is not match(%d/%d)\n", len, event_len);
            }
            if (i != event_len) {
                usb_debug("got unknown event(%d)\n", len);
            } else {
                return len; /* actually read length */
            }
            MTK_MDELAY(10);
            ++retry;
        }
        usb_debug("try get event again\n");
    } while (retry < 3);
    return -1;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_hci_suspend_cmd(struct LD_btmtk_usb_data *data)
{
    int ret = -1;
    /* mtkbt_dev_t *udev = data->udev; */
#if SUPPORT_HISENSE_WoBLE
    u8 cmd[] = {0xC9, 0xFC, 0x02, 0x01, 0x0D}; // for Hisense WoBLE

    usb_debug("issue wake up command for Hisense\n");
#else
    u8 cmd[] = {0xC9, 0xFC, 0x0D, 0x01, 0x0E, 0x00, 0x05, 0x43,
        0x52, 0x4B, 0x54, 0x4D, 0x20, 0x04, 0x32, 0x00};

    usb_debug("issue wake up command for '0E: MTK WoBLE Ver2'\n");
#endif

    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), NULL, -1);
    if (ret < 0) {
        usb_debug("error(%d)\n", ret);
        return ret;
    }
    usb_debug("send suspend cmd OK\n");
    return 0;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_hci_reset_cmd(struct LD_btmtk_usb_data *data)
{
    u8 cmd[] = { 0x03, 0x0C, 0x00 };
    u8 event[] = { 0x0E, 0x04, 0x01, 0x03, 0x0C, 0x00 };
    int ret = -1;

    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0) {
        usb_debug("failed(%d)\n", ret);
    } else {
        usb_debug("OK\n");
    }

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_hci_set_ce_cmd(struct LD_btmtk_usb_data *data)
{
    u8 cmd[] = { 0xD1, 0xFC, 0x04, 0x0C, 0x07, 0x41, 0x00 };
    u8 event[] = { 0x0E, 0x08, 0x01, 0xD1, 0xFC, 0x00 };
    int ret = -1;

    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0) {
        usb_debug("failed(%d)\n", ret);

    } else if (ret == sizeof(event) + 4) {
        if (data->io_buf[6] & 0x01) {
            usb_debug("warning, 0x41070c[0] is 1!\n");
            ret = 0;
        } else {
            u8 cmd2[11] = { 0xD0, 0xFC, 0x08, 0x0C, 0x07, 0x41, 0x00 };

            cmd2[7] = data->io_buf[6] | 0x01;
            cmd2[8] = data->io_buf[7];
            cmd2[9] = data->io_buf[8];
            cmd2[10] = data->io_buf[9];

            ret = btmtk_usb_send_hci_cmd(data, cmd2, sizeof(cmd2), NULL, 0);
            if (ret < 0) {
                usb_debug("write 0x41070C failed(%d)\n", ret);
            } else {
                usb_debug("OK");
                ret = 0;
            }
        }
    } else {
        usb_debug("failed, incorrect response length(%d)\n", ret);
        return -1;
    }

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_check_rom_patch_result_cmd(struct LD_btmtk_usb_data *data)
{
    /* Send HCI Reset */
    {
        int ret = 0;
        unsigned char buf[8] = { 0 };
        buf[0] = 0xD1;
        buf[1] = 0xFC;
        buf[2] = 0x04;
        buf[3] = 0x00;
        buf[4] = 0xE2;
        buf[5] = 0x40;
        buf[6] = 0x00;
        ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_TX_EP,0x0, DEVICE_CLASS_REQUEST_OUT,
                      0x00, 0x00, buf, 0x07, 100);
        if (ret < 0)
        {
            usb_debug("error1(%d)\n", ret);
            return ret;
        }
    }
    /* Get response of HCI reset */
    {
        int ret = 0;
        unsigned char buf[LD_BT_MAX_EVENT_SIZE] = { 0 };
        int actual_length = 0;
        ret = data->hcif->usb_interrupt_msg(data->udev, MTKBT_INTR_EP, buf, LD_BT_MAX_EVENT_SIZE,
                &actual_length, 2000);
        if (ret < 0)
        {
            usb_debug("error2(%d)\n", ret);
            return ret;
        }
        usb_debug("Check rom patch result : ");

        if (buf[6] == 0 && buf[7] == 0 && buf[8] == 0 && buf[9] == 0)
        {
            usb_debug("NG\n");
        }
        else
        {
            usb_debug("OK\n");
        }
    }
    return 0;
}

//---------------------------------------------------------------------------
static int btmtk_usb_switch_iobase(struct LD_btmtk_usb_data *data, int base)
{
    int ret = 0;

    switch (base)
    {
        case SYSCTL:
            data->w_request = 0x42;
            data->r_request = 0x47;
            break;
        case WLAN:
            data->w_request = 0x02;
            data->r_request = 0x07;
            break;

        default:
            return -EINVAL;
    }

    return ret;
}

//---------------------------------------------------------------------------
static void btmtk_usb_cap_init(struct LD_btmtk_usb_data *data)
{
    btmtk_usb_io_read32(data, 0x00, &data->chip_id);
    if (data->chip_id == 0)
        btmtk_usb_io_read32_7668(data, 0x80000008, &data->chip_id);

    //usb_debug("chip id = %x\n", data->chip_id);

    if (is_mt7630(data) || is_mt7650(data)) {
        data->need_load_fw = 1;
        data->need_load_rom_patch = 0;
        data->fw_header_image = NULL;
        data->fw_bin_file_name = (unsigned char*)strdup("mtk/mt7650.bin");
        data->fw_len = 0;

    } else if (is_mt7662T(data) || is_mt7632T(data)) {
        usb_debug("btmtk:This is 7662T chip\n");
        data->need_load_fw = 0;
        data->need_load_rom_patch = 1;
        data->rom_patch_bin_file_name = os_kzalloc(32, MTK_GFP_ATOMIC);
        if (!data->rom_patch_bin_file_name) {
            usb_debug("Can't allocate memory (32)\n");
            return;
        }
        os_memcpy(data->rom_patch_bin_file_name, "mt7662t_patch_e1_hdr.bin", 24);
        data->rom_patch_offset = 0xBC000;
        data->rom_patch_len = 0;

    } else if (is_mt7632(data) || is_mt7662(data)) {
        usb_debug("btmtk:This is 7662 chip\n");
        data->need_load_fw = 0;
        data->need_load_rom_patch = 1;
        data->rom_patch_bin_file_name = os_kzalloc(32, MTK_GFP_ATOMIC);
        if (!data->rom_patch_bin_file_name) {
            usb_debug("Can't allocate memory (32)\n");
            return;
        }
        os_memcpy(data->rom_patch_bin_file_name, "mt7662_patch_e3_hdr.bin", 23);
        data->rom_patch_offset = 0x90000;
        data->rom_patch_len = 0;

    } else if (is_mt7668(data)) {
        unsigned int chip_ver = 0;

        data->need_load_fw = 0;
        data->need_load_rom_patch = 1;
        data->rom_patch_bin_file_name = os_kzalloc(32, MTK_GFP_ATOMIC);
        if (!data->rom_patch_bin_file_name) {
            usb_debug("Can't allocate memory (32)\n");
            return;
        }
        btmtk_usb_io_read32_7668(data, 0x80000000, &chip_ver);
        if (chip_ver == 0x8A00) {
            usb_debug("btmtk:This is 7668 E1 chip\n");
            os_memcpy(data->rom_patch_bin_file_name, "mt7668_patch_e1_hdr.bin", 23);
        } else if (chip_ver == 0x8B10) {
            usb_debug("btmtk:This is 7668 E2 chip\n");
            os_memcpy(data->rom_patch_bin_file_name, "mt7668_patch_e2_hdr.bin", 23);
        } else {
            usb_debug("btmtk: Can't recognize version 0x%04X\n", chip_ver);
            if (data->rom_patch_bin_file_name) os_kfree(data->rom_patch_bin_file_name);
        }
        data->chip_id |= chip_ver << 16;
        data->rom_patch_offset = 0x2000000;
        data->rom_patch_len = 0;

    } else {
        usb_debug("unknow chip(%x)\n", data->chip_id);
    }
}

#if CRC_CHECK
//---------------------------------------------------------------------------
static u16 checksume16(u8 *pData, int len)
{
    int sum = 0;

    while (len > 1)
    {
        sum += *((u16 *) pData);

        pData = pData + 2;

        if (sum & 0x80000000)
        {
            sum = (sum & 0xFFFF) + (sum >> 16);
        }
        len -= 2;
    }

    if (len)
        sum += *((u8 *) pData);

    while (sum >> 16)
    {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }

    return ~sum;
}

//---------------------------------------------------------------------------
static int btmtk_usb_chk_crc(struct LD_btmtk_usb_data *data, u32 checksum_len)
{
    int ret = 0;
    mtkbt_dev_t *udev = data->udev;

    usb_debug("\n");

    os_memmove(data->io_buf, &data->rom_patch_offset, 4);
    os_memmove(&data->io_buf[4], &checksum_len, 4);

    ret = data->hcif->usb_control_msg(udev, MTKBT_CTRL_TX_EP,0x1, DEVICE_VENDOR_REQUEST_OUT,
                  0x20, 0x00, data->io_buf, 8, CONTROL_TIMEOUT_JIFFIES);

    if (ret < 0)
    {
        usb_debug("error(%d)\n", ret);
    }

    return ret;
}

//---------------------------------------------------------------------------
static u16 btmtk_usb_get_crc(struct LD_btmtk_usb_data *data)
{
    int ret = 0;
    mtkbt_dev_t *udev = data->udev;
    u16 crc, count = 0;

    usb_debug("\n");

    while (1)
    {
        ret =
            data->hcif->usb_control_msg(udev, MTKBT_CTRL_RX_EP, 0x01, DEVICE_VENDOR_REQUEST_IN,
                    0x21, 0x00, data->io_buf, 2, CONTROL_TIMEOUT_JIFFIES);

        if (ret < 0)
        {
            crc = 0xFFFF;
            usb_debug("error(%d)\n", ret);
        }

        os_memmove(&crc, data->io_buf, 2);

        crc = le16_to_cpu(crc);

        if (crc != 0xFFFF)
            break;

        MTK_MDELAY(100);

        if (count++ > 100)
        {
            usb_debug("Query CRC over %d times\n", count);
            break;
        }
    }

    return crc;
}
#endif /* CRC_CHECK */

//---------------------------------------------------------------------------
static int btmtk_usb_send_wmt_reset_cmd(struct LD_btmtk_usb_data *data)
{
    /* reset command */
    u8 cmd[] = { 0x6F, 0xFC, 0x05, 0x01, 0x07, 0x01, 0x00, 0x04 };
    u8 event[] = { 0xE4, 0x05, 0x02, 0x07, 0x01, 0x00, 0x00 };
    int ret = -1;

    ret = btmtk_usb_send_wmt_cmd(data, cmd, sizeof(cmd), event, sizeof(event), 20, 0);
    if (ret < 0) {
        usb_debug("Check reset wmt result : NG\n");
    } else {
        usb_debug("Check reset wmt result : OK\n");
        ret = 0;
    }

    return ret;
}

//---------------------------------------------------------------------------
static u16 btmtk_usb_get_rom_patch_result(struct LD_btmtk_usb_data *data)
{
    int ret = 0;

    ret = data->hcif->usb_control_msg(data->udev, MTKBT_CTRL_RX_EP, 0x01,
                  DEVICE_VENDOR_REQUEST_IN, 0x30, 0x00, data->io_buf, 7,
                  CONTROL_TIMEOUT_JIFFIES);

    if (ret < 0)
    {
        usb_debug("error(%d)\n", ret);
    }

    if (data->io_buf[0] == 0xe4 &&
        data->io_buf[1] == 0x05 &&
        data->io_buf[2] == 0x02 &&
        data->io_buf[3] == 0x01 &&
        data->io_buf[4] == 0x01 &&
        data->io_buf[5] == 0x00 &&
        data->io_buf[6] == 0x00)
    {
        //usb_debug("Get rom patch result : OK\n");
    }
    else
    {
        usb_debug("Get rom patch result : NG\n");
    }
    return ret;
}

//---------------------------------------------------------------------------
#define SHOW_FW_DETAILS(s)                                                  \
    usb_debug("%s = %c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c", s,                   \
            tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3],                 \
            tmp_str[4], tmp_str[5], tmp_str[6], tmp_str[7],                 \
            tmp_str[8], tmp_str[9], tmp_str[10], tmp_str[11],               \
            tmp_str[12], tmp_str[13], tmp_str[14], tmp_str[15])

//---------------------------------------------------------------------------
static int btmtk_usb_load_rom_patch(struct LD_btmtk_usb_data *data)
{
    u32 loop = 0;
    u32 value;
    s32 sent_len;
    int ret = 0;
    u32 patch_len = 0;
    u32 cur_len = 0;
    int real_len = 0;
    int first_block = 1;
    unsigned char phase;
    void *buf;
    char *pos;
    unsigned char *tmp_str;

    //usb_debug("begin\n");
load_patch_protect:
    btmtk_usb_switch_iobase(data, WLAN);
    btmtk_usb_io_read32(data, SEMAPHORE_03, &value);
    loop++;

    if ((value & 0x01) == 0x00)
    {
        if (loop < 1000)
        {
            MTK_MDELAY(1);
            goto load_patch_protect;
        }
        else
        {
            usb_debug("btmtk_usb_load_rom_patch ERR! Can't get semaphore! Continue\n");
        }
    }

    btmtk_usb_switch_iobase(data, SYSCTL);

    btmtk_usb_io_write32(data, 0x1c, 0x30);

    btmtk_usb_switch_iobase(data, WLAN);

    /* check ROM patch if upgrade */
    if ((MT_REV_GTE(data, mt7662, REV_MT76x2E3)) || (MT_REV_GTE(data, mt7632, REV_MT76x2E3)))
    {
        btmtk_usb_io_read32(data, CLOCK_CTL, &value);
        if ((value & 0x01) == 0x01)
        {
            usb_debug("btmtk_usb_load_rom_patch : no need to load rom patch\n");
            btmtk_usb_send_hci_reset_cmd(data);
            goto error;
        }
    }
    else
    {
        btmtk_usb_io_read32(data, COM_REG0, &value);
        if ((value & 0x02) == 0x02)
        {
            usb_debug("btmtk_usb_load_rom_patch : no need to load rom patch\n");
            btmtk_usb_send_hci_reset_cmd(data);
            goto error;
        }
    }

    buf = os_kzalloc(UPLOAD_PATCH_UNIT, MTK_GFP_ATOMIC);
    if (!buf)
    {
        ret = -ENOMEM;
        goto error;
    }

    pos = buf;

    LD_load_code_from_bin(&data->rom_patch, (char *)data->rom_patch_bin_file_name, NULL,
            data->udev, &data->rom_patch_len);

    if (!data->rom_patch)
    {
        usb_debug("please assign a rom patch(/system/etc/firmware/%s)or(/lib/firmware/%s)\n",
                data->rom_patch_bin_file_name,
                data->rom_patch_bin_file_name);
        ret = -1;
        goto error;
    }

    tmp_str = data->rom_patch;
    SHOW_FW_DETAILS("FW Version");
    SHOW_FW_DETAILS("build Time");

    tmp_str = data->rom_patch + 16;
    usb_debug("platform = %c%c%c%c\n", tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3]);

    tmp_str = data->rom_patch + 20;
    usb_debug("HW/SW version = %c%c%c%c\n", tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3]);

    tmp_str = data->rom_patch + 24;
    usb_debug("Patch version = %c%c%c%c\n", tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3]);

    usb_debug("\nloading rom patch...\n");

    cur_len = 0x00;
    patch_len = data->rom_patch_len - PATCH_INFO_SIZE;

    /* loading rom patch */
    while (1)
    {
        s32 sent_len_max = UPLOAD_PATCH_UNIT - PATCH_HEADER_SIZE;
        real_len = 0;
        sent_len =
            (patch_len - cur_len) >= sent_len_max ? sent_len_max : (patch_len - cur_len);

        //usb_debug("patch_len = %d\n", patch_len);
        //usb_debug("cur_len = %d\n", cur_len);
        //usb_debug("sent_len = %d\n", sent_len);

        if (sent_len > 0)
        {
            if (first_block == 1)
            {
                if (sent_len < sent_len_max)
                    phase = PATCH_PHASE3;
                else
                    phase = PATCH_PHASE1;
                first_block = 0;
            }
            else if (sent_len == sent_len_max)
            {
                if (patch_len - cur_len == sent_len_max)
                    phase = PATCH_PHASE3;
                else
                    phase = PATCH_PHASE2;
            }
            else
            {
                phase = PATCH_PHASE3;
            }

            /* prepare HCI header */
            pos[0] = 0x6F;
            pos[1] = 0xFC;
            pos[2] = (sent_len + 5) & 0xFF;
            pos[3] = ((sent_len + 5) >> 8) & 0xFF;

            /* prepare WMT header */
            pos[4] = 0x01;
            pos[5] = 0x01;
            pos[6] = (sent_len + 1) & 0xFF;
            pos[7] = ((sent_len + 1) >> 8) & 0xFF;

            pos[8] = phase;

            os_memcpy(&pos[9], data->rom_patch + PATCH_INFO_SIZE + cur_len, sent_len);

            //usb_debug("sent_len + PATCH_HEADER_SIZE = %d, phase = %d\n",
                   //sent_len + PATCH_HEADER_SIZE, phase);

            ret = data->hcif->usb_bulk_msg(data->udev, MTKBT_BULK_TX_EP, buf, sent_len + PATCH_HEADER_SIZE, &real_len, 0);

            if (ret)
            {
                usb_debug("upload rom_patch err: %d\n", ret);
                goto error;
            }

            MTK_MDELAY(1);

            cur_len += sent_len;

        }
        else
        {
            usb_debug("loading rom patch... Done\n");
            break;
        }
    }

    MTK_MDELAY(20);
    ret = btmtk_usb_get_rom_patch_result(data);
    MTK_MDELAY(20);

    /* Send Checksum request */
    #if CRC_CHECK
    int total_checksum = checksume16(data->rom_patch + PATCH_INFO_SIZE, patch_len);
    btmtk_usb_chk_crc(data, patch_len);
    MTK_MDELAY(20);
    if (total_checksum != btmtk_usb_get_crc(data))
    {
        usb_debug("checksum fail!, local(0x%x) <> fw(0x%x)\n", total_checksum,
               btmtk_usb_get_crc(data));
        ret = -1;
        goto error;
    }
    else
    {
        usb_debug("crc match!\n");
    }
    #endif
    MTK_MDELAY(20);
    /* send check rom patch result request */
    btmtk_usb_send_check_rom_patch_result_cmd(data);
    MTK_MDELAY(20);
    /* CHIP_RESET */
    ret = btmtk_usb_send_wmt_reset_cmd(data);
    MTK_MDELAY(20);
    /* BT_RESET */
    btmtk_usb_send_hci_reset_cmd(data);
    /* for WoBLE/WoW low power */
    btmtk_usb_send_hci_set_ce_cmd(data);

 error:
    btmtk_usb_io_write32(data, SEMAPHORE_03, 0x1);
    //usb_debug("end\n");
    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_wmt_power_on_cmd_7668(struct LD_btmtk_usb_data *data)
{
    u8 count = 0;                                           /* retry 3 times */
    u8 cmd[] = { 0x6F, 0xFC, 0x06, 0x01, 0x06, 0x02, 0x00, 0x00, 0x01 };
    u8 event[] = { 0xE4, 0x05, 0x02, 0x06, 0x01, 0x00 };    /* event[6] is key */
    int ret = -1;                                           /* if successful, 0 */

    do {
        ret = btmtk_usb_send_wmt_cmd(data, cmd, sizeof(cmd), event, sizeof(event), 100, 10);
        if (ret < 0) {
            usb_debug("failed(%d)\n", ret);
        } else if (ret == sizeof(event) + 1) {
            switch (data->io_buf[6]) {
            case 0:             /* successful */
                usb_debug("OK\n");
                ret = 0;
                break;
            case 2:             /* retry */
                usb_debug("Try again\n");
                continue;
            default:
                usb_debug("Unknown result: %02X\n", data->io_buf[6]);
                return -1;
            }
        } else {
            usb_debug("failed, incorrect response length(%d)\n", ret);
            return -1;
        }
    } while (++count < 3 && ret > 0);

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_hci_tci_set_sleep_cmd_7668(struct LD_btmtk_usb_data *data)
{
    u8 cmd[] = { 0x7A, 0xFC, 0x07, 0x05, 0x40, 0x06, 0x40, 0x06, 0x00, 0x00 };
    u8 event[] = { 0x0E, 0x04, 0x01, 0x7A, 0xFC, 0x00 };
    int ret = -1;                                   /* if successful, 0 */

    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0) {
        usb_debug("failed(%d)\n", ret);
    } else {
        usb_debug("OK\n");
        ret = 0;
    }

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_get_vendor_cap(struct LD_btmtk_usb_data *data)
{
    u8 cmd[] = { 0x53, 0xFD, 0x00 };
    u8 event[6] = { 0x0E, 0x12, 0x01, 0x53, 0xFD, 0x00, /* ... */ };
    int ret = -1;

    // TODO: should not compare whole event
    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0) {
        usb_debug("Failed(%d)\n", ret);
    } else {
        usb_debug("OK\n");
        ret = 0;
    }

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_send_read_bdaddr(struct LD_btmtk_usb_data *data)
{
    u8 cmd[] = { 0x09, 0x10, 0x00 };
    u8 event[] = { 0x0E, 0x0A, 0x01, 0x09, 0x10, 0x00, /* 6 bytes are BDADDR */ };
    int ret = -1;

    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0 || ret != 12 /* Event actual length */) {
        usb_debug("Failed(%d)\n", ret);
        return ret;
    }

    os_memcpy(data->local_addr, data->io_buf + 6, BD_ADDR_LEN);
    usb_debug("ADDR: %02X-%02X-%02X-%02X-%02X-%02X\n",
            data->local_addr[5], data->local_addr[4], data->local_addr[3],
            data->local_addr[2], data->local_addr[1], data->local_addr[0]);
    ret = 0;

    return ret;
}

//---------------------------------------------------------------------------
static int btmtk_usb_set_apcf(struct LD_btmtk_usb_data *data, BOOL bin_file)
{
    int i = 0, ret = -1;
    // Legacy RC pattern
    u8 manufacture_data[] = { 0x57, 0xFD, 0x27, 0x06, 0x00, FIDX,
        0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x43, 0x52, 0x4B, 0x54, 0x4D,   /* manufacturer data */
        0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF }; /* mask */
    u8 filter_cmd[] = { 0x57, 0xFD, 0x0A, 0x01, 0x00, FIDX, 0x20, 0x00,
        0x00, 0x00, 0x01, 0x80, 0x00 };
    u8 event[] = { 0x0E, 0x07, 0x01, 0x57, 0xFD, 0x00, /* ... */ };

    if (bin_file) {
        if (data->wake_dev_len) {
            /* wake_on_ble.conf using 90(0x5A-FIDX) as filter_index */
            u8 pos = 0;
            u8 broadcast_addr[] = { 0x57, 0xFD, 0x0A, 0x02, 0x00, FIDX,
                0x55, 0x44, 0x33, 0x22, 0x11, 0x00, // ADDRESS
                0x00 };  // 0: Public, 1: Random
            u8 adv_pattern[] = { 0x57, 0xFD, 0x15, 0x06, 0x00, FIDX,
                0x71, 0x01,                 // VID
                0x04, 0x11,                 // PID
                0x00, 0x00, 0x00, 0x00,     // IR key code
                0x00,                       // sequence number
                0xFF, 0xFF,                 // mask~
                0xFF, 0xFF,
                0x00, 0x00, 0x00, 0x00,
                0x00 };

            // BDADDR
            for (i = 0; i < data->wake_dev[1]; i++) {
                broadcast_addr[11] = data->wake_dev[2 + i * BD_ADDR_LEN + 0];
                broadcast_addr[10] = data->wake_dev[2 + i * BD_ADDR_LEN + 1];
                broadcast_addr[9] = data->wake_dev[2 + i * BD_ADDR_LEN + 2];
                broadcast_addr[8] = data->wake_dev[2 + i * BD_ADDR_LEN + 3];
                broadcast_addr[7] = data->wake_dev[2 + i * BD_ADDR_LEN + 4];
                broadcast_addr[6] = data->wake_dev[2 + i * BD_ADDR_LEN + 5];
                ret = btmtk_usb_send_hci_cmd(data, broadcast_addr, sizeof(broadcast_addr),
                        event, sizeof(event));
                if (ret < 0) {
                    usb_debug("Set broadcast address fail\n");
                    continue;
                }
                // mask broadcast address as a filter condition
                filter_cmd[6] = 0x21;
            }
            usb_debug("There are %d broadcast address filter(s) from %s\n", i, WAKE_DEV_RECORD);

            /** VID/PID in conf is LITTLE endian, but PID in ADV is BIG endian */
            pos = 2 + data->wake_dev[1] * 6;
            for (i = 0; i < data->wake_dev[pos]; i++) {
                adv_pattern[6] = data->wake_dev[pos + (i * 4) + 1];
                adv_pattern[7] = data->wake_dev[pos + (i * 4) + 2];
                adv_pattern[9] = data->wake_dev[pos + (i * 4) + 3];
                adv_pattern[8] = data->wake_dev[pos + (i * 4) + 4];
                ret = btmtk_usb_send_hci_cmd(data, adv_pattern, sizeof(adv_pattern),
                        event, sizeof(event));
                if (ret < 0) {
                    usb_debug("Set advertising patten fail\n");
                    return ret;
                }
            }
            usb_debug("There are %d manufacture data filter(s) from %s\n", i, WAKE_DEV_RECORD);

            // Filtering parameters
            ret = btmtk_usb_send_hci_cmd(data, filter_cmd, sizeof(filter_cmd),
                    event, sizeof(event));
            if (ret < 0) {
                usb_debug("Set filtering parm fail\n");
                return ret;
            }

        // if wake_on_ble.conf exist, no need use default woble_setting.bin
        } else {
            // woble_setting.bin
            usb_debug("Set APCF filter from woble_setting.bin\n");
            for (i = 0; i < APCF_SETTING_COUNT; i++) {
                if (!data->apcf_cmd[i].len)
                    continue;
                ret = btmtk_usb_send_hci_cmd(data, data->apcf_cmd[i].value, data->apcf_cmd[i].len,
                        event, sizeof(event));
                if (ret < 0) {
                    usb_debug("Set apcf_cmd[%d] data fail\n", i);
                    return ret;
                }
            }
        }

    } else {
        // Use default
        usb_debug("Using default APCF filter\n");
        os_memcpy(manufacture_data + 9, data->local_addr, BD_ADDR_LEN);
        ret = btmtk_usb_send_hci_cmd(data, manufacture_data,
                sizeof(manufacture_data), event, sizeof(event));
        if (ret < 0) {
            usb_debug("Set manufacture data fail\n");
            return ret;
        }

        ret = btmtk_usb_send_hci_cmd(data, filter_cmd, sizeof(filter_cmd),
                event, sizeof(event));
        if (ret < 0) {
            usb_debug("Set manufacture data fail\n");
            return ret;
        }
    }
    return 0;
}

//---------------------------------------------------------------------------
static BOOL btmtk_usb_check_need_load_patch_7668(struct LD_btmtk_usb_data *data)
{
    /* TRUE: need load patch., FALSE: do not need */
    u8 cmd[] = { 0x6F, 0xFC, 0x05, 0x01, 0x17, 0x01, 0x00, 0x01 };
    u8 event[] = { 0xE4, 0x05, 0x02, 0x17, 0x01, 0x00, /* 0x02 */ };    /* event[6] is key */
    int ret = -1;

    ret = btmtk_usb_send_wmt_cmd(data, cmd, sizeof(cmd), event, sizeof(event), 20, 0);
    /* can't get correct event, need load patch */
    if (ret < 0) {
        usb_debug("check need load patch or not fail(%d)", ret);
        return TRUE;
    }

    if (ret == sizeof(event) + 1 && (data->io_buf[6] == 0x00 || data->io_buf[6] == 0x01))
        return FALSE;   /* Do not need */

    return TRUE;
}

//---------------------------------------------------------------------------
static int btmtk_usb_load_rom_patch_7668(struct LD_btmtk_usb_data *data)
{
    int ret = 0;
    int first_block = 1;
    int real_len = 0;
    void *buf = NULL;
    char *tmp_str = NULL;
    u8 *pos = NULL;
    u8 phase = 0;
    u32 cur_len = 0;
    u32 patch_len = 0;
    s32 sent_len = 0;

    //usb_debug("begin\n");
    if (btmtk_usb_check_need_load_patch_7668(data) == FALSE) {
        usb_debug("No need to load rom patch\n");
        return btmtk_usb_send_wmt_reset_cmd(data);
    }

    buf = os_kzalloc(UPLOAD_PATCH_UNIT, MTK_GFP_ATOMIC);
    if (!buf) {
        return -ENOMEM;
    }

    pos = buf;
    LD_load_code_from_bin(&data->rom_patch, (char *)data->rom_patch_bin_file_name, NULL,
            data->udev, &data->rom_patch_len);
    if (!data->rom_patch || !data->rom_patch_len) {
        usb_debug("please assign a rom patch(/system/etc/firmware/%s) or (/lib/firmware/%s)\n",
                data->rom_patch_bin_file_name, data->rom_patch_bin_file_name);
        return -1;
    }

    tmp_str = (char *)data->rom_patch;
    SHOW_FW_DETAILS("FW Version");
    SHOW_FW_DETAILS("build Time");

    tmp_str = (char *)data->rom_patch + 16;
    usb_debug("platform = %c%c%c%c\n", tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3]);

    tmp_str = (char *)data->rom_patch + 20;
    usb_debug("HW/SW version = %c%c%c%c\n", tmp_str[0], tmp_str[1], tmp_str[2], tmp_str[3]);

    tmp_str = (char *)data->rom_patch + 24;
    patch_len = data->rom_patch_len - PATCH_INFO_SIZE;
    //usb_debug("patch_len = %d\n", patch_len);
    usb_debug("loading rom patch...\n");

    /* loading rom patch */
    while (1) {
        s32 sent_len_max = UPLOAD_PATCH_UNIT - PATCH_HEADER_SIZE;

        real_len = 0;
        sent_len = (patch_len - cur_len) >= sent_len_max ? sent_len_max : (patch_len - cur_len);
        if (sent_len > 0) {
            if (first_block == 1) {
                if (sent_len < sent_len_max)
                    phase = PATCH_PHASE3;
                else
                    phase = PATCH_PHASE1;
                first_block = 0;
            } else if (sent_len == sent_len_max) {
                if (patch_len - cur_len == sent_len_max)
                    phase = PATCH_PHASE3;
                else
                    phase = PATCH_PHASE2;
            } else {
                phase = PATCH_PHASE3;
            }

            /* prepare HCI header */
            pos[0] = 0x6F;
            pos[1] = 0xFC;
            pos[2] = (sent_len + 5) & 0xFF;
            pos[3] = ((sent_len + 5) >> 8) & 0xFF;

            /* prepare WMT header */
            pos[4] = 0x01;
            pos[5] = 0x01;
            pos[6] = (sent_len + 1) & 0xFF;
            pos[7] = ((sent_len + 1) >> 8) & 0xFF;

            pos[8] = phase;

            os_memcpy(&pos[9], data->rom_patch + PATCH_INFO_SIZE + cur_len, sent_len);
            //usb_debug("sent_len = %d, cur_len = %d, phase = %d\n", sent_len, cur_len, phase);

            ret = data->hcif->usb_bulk_msg(data->udev, MTKBT_BULK_TX_EP, buf,
                    sent_len + PATCH_HEADER_SIZE, &real_len, 0);
            if (ret) {
                usb_debug("upload rom_patch err: %d\n", ret);
                return -1;
            }
            cur_len += sent_len;
            MTK_MDELAY(1);
            btmtk_usb_get_rom_patch_result(data);
            MTK_MDELAY(1);

        } else {
            usb_debug("loading rom patch... Done\n");
            break;
        }
        os_memset(buf, 0, UPLOAD_PATCH_UNIT);
    }
    MTK_MDELAY(20);
    /* CHIP_RESET */
    ret = btmtk_usb_send_wmt_reset_cmd(data);
    MTK_MDELAY(20);

    //usb_debug("end\n");
    return ret;
}

//---------------------------------------------------------------------------
void btmtk_usb_woble_setting_parsing(struct LD_btmtk_usb_data *data, woble_setting_type type)
{
#define ONE_BYTE_HEX_MAX_LEN 8
    int i = 0;
    char *cmd = NULL;
    char *head = NULL;
    char *next_cmd = NULL;
    char prefix[32] = {0};
    u8 tmp_len = 0;
    u8 tmp[128] = {0};
    long int set_addr = 0;
    long int addr_pos = 0;

    switch (type) {
    case TYPE_APCF_CMD:
        cmd = "APCF";
        break;
    default:
        usb_debug("Incorrect Type\n");
        return;
    }

    for (i = 0; i < APCF_SETTING_COUNT; ++i) {
        snprintf(prefix, sizeof(prefix), "%s%02d:", cmd, i);
        head = strstr((char *)data->woble_setting, prefix);

        if (head) {
            head += strlen(prefix);  /* move to first numeral */
            next_cmd = strstr(head, ":");   // next command start position

            tmp_len = 0;
            memset(tmp, 0, sizeof(tmp));
            do {
                tmp[tmp_len++] = strtol(head, &head, 0);

                // for next one
                head = strstr(head, "0x");
                if (next_cmd && head > next_cmd)
                    break; // command end
            } while (tmp_len < sizeof(tmp));

            if (tmp_len) {
                int j = 0; // FOR DEBUG

                /* Save command */
                data->apcf_cmd[i].value = os_kzalloc(tmp_len, MTK_GFP_ATOMIC);
                os_memcpy(data->apcf_cmd[i].value, tmp, tmp_len);
                data->apcf_cmd[i].len = tmp_len;

                if (type == TYPE_APCF_CMD) {
                    /* Check need BD address or not */
                    snprintf(prefix, sizeof(prefix), "%s_ADD_MAC%02d:", cmd, i);
                    head = strstr((char *)data->woble_setting, prefix);
                    head += strlen(prefix);
                    set_addr = strtol(head, &head, 0);

                    if (set_addr == 1) {
                        snprintf(prefix, sizeof(prefix), "%s_ADD_MAC_LOCATION%02d:", cmd, i);
                        head = strstr((char *)data->woble_setting, prefix);
                        head += strlen(prefix);
                        addr_pos = strtol(head, &head, 0);

                        if (addr_pos)
                            os_memcpy(data->apcf_cmd[i].value + addr_pos,
                                    data->local_addr, BD_ADDR_LEN);
                    }
                }
                // FOR DEBUG
                usb_debug("Load for APCF settings only\n");
                usb_debug("%02X:", i);
                for (j = 0; j < data->apcf_cmd[i].len; j++)
                    printf(" %02X", data->apcf_cmd[i].value[j]);
                printf("\n");
            }
        }
    }
}

//---------------------------------------------------------------------------
int btmtk_usb_load_woble_setting(struct LD_btmtk_usb_data *data)
{
    int i = 0;
    BOOL woble_setting_bin = FALSE;
    BOOL wake_on_ble_conf = FALSE;

    if (!data)
        return -EINVAL;

    /* For woble_setting.bin */
    data->woble_setting = NULL;
    data->woble_setting_len = 0;

    LD_load_code_from_bin(&data->woble_setting, WOBLE_SETTING_FILE_NAME, NULL,
            data->udev, &data->woble_setting_len);
    if (data->woble_setting == NULL || data->woble_setting_len == 0) {
        usb_debug("Please make sure %s in the /system/etc(lib)/firmware\n",
                WOBLE_SETTING_FILE_NAME);
        woble_setting_bin = FALSE;
    } else {
        btmtk_usb_woble_setting_parsing(data, TYPE_APCF_CMD);
        for (i = 0; i < APCF_SETTING_COUNT; i++)
            if (data->apcf_cmd[i].len)
                break;
        if (i == APCF_SETTING_COUNT) {
            woble_setting_bin = FALSE;
            if (data->woble_setting) {
                data->woble_setting_len = 0;
                os_kfree(data->woble_setting);
                data->woble_setting = NULL;
            }
        } else {
            woble_setting_bin = TRUE;
        }
    }

    /* For wake_on_ble.conf */
    data->wake_dev = NULL;
    data->wake_dev_len = 0;

    LD_load_code_from_bin(&data->wake_dev, WAKE_DEV_RECORD, WAKE_DEV_RECORD_PATH,
            data->udev, &data->wake_dev_len);
    if (data->wake_dev == NULL || data->wake_dev_len == 0) {
        usb_debug("There is no DEVICE RECORD for wake-up\n");
        wake_on_ble_conf = FALSE;
    } else {
        // content check
        if (data->wake_dev[0] != data->wake_dev_len || data->wake_dev_len < 3) {
            usb_debug("Incorrect total length on %s\n", WAKE_DEV_RECORD);
            data->wake_dev_len = 0;
            os_kfree(data->wake_dev);
            data->wake_dev = NULL;
            wake_on_ble_conf = FALSE;
        } else {
            wake_on_ble_conf = TRUE;
        }
    }

    if (woble_setting_bin == FALSE && wake_on_ble_conf == FALSE)
        return -ENOENT;
    return 0;
}

//---------------------------------------------------------------------------
int btmtk_usb_set_unify_woble(struct LD_btmtk_usb_data *data)
{
    int ret = -1;
    // Filter Index: 0x5B
    /*u8 cmd[] = { 0xC9, 0xFC, 0x1F, 0x01, 0x20, 0x02, 0x00, 0x01, 0x02, 0x01,
        0x01, 0x05, 0x10, 0x09, 0x00, 0xC0, 0x00, 0x02, 0x40, FIDX, 0x04,
        0x11, 0x12, 0x00, 0x00, 0x02, 0x42, 0x15, 0x02, 0x25, 0x00, 0x02,
        0x41, 0x19 };*/

    u8 cmd[] = { 0xC9, 0xFC, 0x14, 0x01, 0x20, 0x02, 0x00, 0x01,
			0x02, 0x01, 0x00, 0x05, 0x10, 0x01, 0x00, 0x40, 0x06,
			0x02, 0x40, 0x5A, 0x02, 0x41, 0x0F };
    u8 event[] = { 0xE6, 0x02, 0x08, 0x00 };

    usb_debug("%s: APCF filtering index: %d\n", __func__, FIDX);
    ret = btmtk_usb_send_hci_cmd(data, cmd, sizeof(cmd), event, sizeof(event));
    if (ret < 0)
        usb_debug("Failed(%d)\n", ret);
    return ret;
}

//---------------------------------------------------------------------------
void LD_btmtk_usb_SetWoble(mtkbt_dev_t *dev)
{
    struct LD_btmtk_usb_data *data = BT_INST(dev)->priv_data;
    int ret = -1;

    usb_debug("\n");
    if (!data) {
        usb_debug("btmtk data NULL!\n");
        return;
    }

    if (is_mt7668(data)) {
        /* Power on sequence */
        btmtk_usb_send_wmt_power_on_cmd_7668(data);
        btmtk_usb_send_hci_tci_set_sleep_cmd_7668(data);
        btmtk_usb_send_hci_reset_cmd(data);

        /* Unify WoBLE flow */
        btmtk_usb_get_vendor_cap(data);
        btmtk_usb_send_read_bdaddr(data);
        ret = btmtk_usb_load_woble_setting(data);
        if (ret) {
            usb_debug("Using lagecy WoBLE setting(%d)!!!\n", ret);
            btmtk_usb_set_apcf(data, FALSE);
        } else
            btmtk_usb_set_apcf(data, TRUE);
        btmtk_usb_set_unify_woble(data);
    } else {
        btmtk_usb_send_hci_suspend_cmd(data);
    }

    // Clean & free buffer
    if (data->woble_setting) {
        int i = 0;
        os_kfree(data->woble_setting);
        data->woble_setting = NULL;
        data->woble_setting_len = 0;
        for (i = 0; i < APCF_SETTING_COUNT; i++) {
            os_kfree(data->apcf_cmd[i].value);
            data->apcf_cmd[i].len = 0;
        }
    }
    if (data->wake_dev) {
        os_kfree(data->wake_dev);
        data->wake_dev = NULL;
        data->wake_dev_len = 0;
    }

    return;
}

//---------------------------------------------------------------------------
int LD_btmtk_usb_probe(mtkbt_dev_t *dev)
{
    struct LD_btmtk_usb_data *data;
    int  err = 0;

    usb_debug("=========================================\n");
    usb_debug("Mediatek Bluetooth USB driver ver %s\n", LD_VERSION);
    usb_debug("=========================================\n");
    os_memcpy(driver_version, LD_VERSION, sizeof(LD_VERSION));
    probe_counter++;
    isbtready = 0;
    is_assert = 0;
    //usb_debug("LD_btmtk_usb_probe begin\n");
    usb_debug("probe_counter = %d\n", probe_counter);

    data = (struct LD_btmtk_usb_data *)os_kzalloc(sizeof(*data), MTK_GFP_ATOMIC);
    if (!data) {
        usb_debug("[ERR] end Error 1\n");
        return -ENOMEM;
    }

    data->hcif = BT_INST(dev)->hci_if;

    data->cmdreq_type = USB_TYPE_CLASS;

    data->udev = dev;

    data->meta_tx = 0;

    data->io_buf = os_kmalloc(LD_BT_MAX_EVENT_SIZE, MTK_GFP_ATOMIC);

    btmtk_usb_switch_iobase(data, WLAN);

    /* clayton: according to the chip id, load f/w or rom patch */
    btmtk_usb_cap_init(data);

    if (data->need_load_rom_patch) {
        if (is_mt7668(data))
            err = btmtk_usb_load_rom_patch_7668(data);
        else
            err = btmtk_usb_load_rom_patch(data);
        //btmtk_usb_send_hci_suspend_cmd(data);
        if (err < 0) {
            if (data->io_buf) os_kfree(data->io_buf);
            if (data->rom_patch_bin_file_name) os_kfree(data->rom_patch_bin_file_name);
            os_kfree(data);
            usb_debug("[ERR] end Error 2\n");
            return err;
        }
    }

    // Clean & free buffer
    if (data->rom_patch_bin_file_name)
        os_kfree(data->rom_patch_bin_file_name);


    isUsbDisconnet = 0;
    BT_INST(dev)->priv_data = data;
    isbtready = 1;

    //usb_debug("btmtk_usb_probe end\n");
    return 0;
}

//---------------------------------------------------------------------------
void LD_btmtk_usb_disconnect(mtkbt_dev_t *dev)
{
    struct LD_btmtk_usb_data *data = BT_INST(dev)->priv_data;

    usb_debug("\n");

    if (!data)
        return;

    isbtready = 0;
    metaCount = 0;

    if (data->need_load_rom_patch)
        os_kfree(data->rom_patch);

    if (data->need_load_fw)
        os_kfree(data->fw_image);

    usb_debug("unregister bt irq\n");

    isUsbDisconnet = 1;
    usb_debug("btmtk: stop all URB\n");
    os_kfree(data->io_buf);
    os_kfree(data);
}

//---------------------------------------------------------------------------
