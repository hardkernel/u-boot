/* usb pcd driver */
/*
 * (C) Copyright 2010 Amlogic, Inc
 *
 * Victor Wan, victor.wan@amlogic.com,
 * 2010-03-24 @ Shanghai
 *
 */
#include "../v2_burning_i.h"
#include "platform.h"
#include "usb_ch9.h"
#include "dwc_pcd.h"
#include "dwc_pcd_irq.h"
#include "usb_pcd.h"

#define COMPILE_TYPE_CHK(expr, t)       typedef char t[(expr) ? 1 : -1]

static int do_bulk_cmd(char* cmd);

#define DWC_BLK_MAX_LEN         0X1000
#define DWC_BLK_LEN(leftSz)     ((leftSz) >= DWC_BLK_MAX_LEN ? DWC_BLK_MAX_LEN : (leftSz >= BULK_EP_MPS ? BULK_EP_MPS : leftSz))//FIXME:block length 4K, can be 64K ???
#define DWC_BLK_NUM(totalTransLen)  ( (totalTransLen/DWC_BLK_MAX_LEN) + ( (totalTransLen & (DWC_BLK_MAX_LEN - 1)) + (BULK_EP_MPS - 1) )/BULK_EP_MPS )

#define DRIVER_VENDOR_ID	0x1B8E  //Amlogic's VerdorID
#define DRIVER_PRODUCT_ID	0xC003
#define DRIVER_VERSION       0x0100


#define STRING_MANUFACTURER	1
#define STRING_PRODUCT		2
#define STRING_SERIAL		3
#define STRING_CONFIG		4
#define STRING_INTERFACE	5
static const struct usb_device_descriptor
device_desc = {
	sizeof device_desc,		//__u8  bLength;
        USB_DT_DEVICE,			//__u8  bDescriptorType;
#ifdef USE_FULL_SPEED
        __constant_cpu_to_le16(0x0110),	//__u16 bcdUSB;
#else
		__constant_cpu_to_le16(0x0200),	//__u16 bcdUSB;
#endif
        USB_CLASS_PER_INTERFACE,	//__u8  bDeviceClass;
        0,				//__u8  bDeviceSubClass;
        0,				//__u8  bDeviceProtocol;
        64,				//__u8  bMaxPacketSize0;
        __constant_cpu_to_le16(DRIVER_VENDOR_ID),	//__u16 idVendor;
        __constant_cpu_to_le16(DRIVER_PRODUCT_ID),	//__u16 idProduct;
        __constant_cpu_to_le16(0x0007),	//__u16 bcdDevice;
        0/*STRING_MANUFACTURER*/,		//__u8  iManufacturer;
        0/*STRING_PRODUCT*/,			//__u8  iProduct;
        0/*STRING_SERIAL*/,			//__u8  iSerialNumber;
        1				//__u8  bNumConfigurations;
};

#define INTF_CONFIG_DESC_LEN  23
#define TOTAL_CONFIG_DESC_LEN	(INTF_CONFIG_DESC_LEN + USB_DT_CONFIG_SIZE)

#pragma pack(push, 1)
struct _ConfigDesTotal_s{
    struct usb_config_descriptor    configDesc;
    char                            intfDesc[INTF_CONFIG_DESC_LEN] ;
};
#pragma pack(pop)
COMPILE_TYPE_CHK(TOTAL_CONFIG_DESC_LEN == sizeof(struct _ConfigDesTotal_s), a);

static const struct _ConfigDesTotal_s _configDescTotal = {
    .configDesc     =
    {
        USB_DT_CONFIG_SIZE,		//__u8  bLength;
        USB_DT_CONFIG,			//__u8  bDescriptorType;
        TOTAL_CONFIG_DESC_LEN,				//__u16 wTotalLength;
        1,				//__u8  bNumInterfaces;
        1,			//__u8  bConfigurationValue;
        0,//STRING_CONFIG,			//__u8  iConfiguration;
        USB_CONFIG_ATT_ONE |
            USB_CONFIG_ATT_SELFPOWER,	//__u8  bmAttributes;
        1				//__u8  MaxPower;
    },

    .intfDesc       =
    {
        0x09,// length
        0x04,//USB_DT_INTERFACE
        0x00,//bInterfaceNumber
        0x00,//bAlternateSetting
        0x02,//bNumEndpoints
        0xFF,//bInterfaceClass, 0xFF =  USB_CLASS_VENDOR_SPEC
        0x00,//bInterfaceSubClass
        0x00,//bInterfaceProtocol
        0x00,//iInterface

        0x07,//Length
        0x05,//USB_DT_ENDPOINT
        0x80 | BULK_IN_EP_NUM,// 1 -- IN
        0x02,// Bulk
#ifndef USE_FULL_SPEED
	0x00,//
	0x02,// 64 bytes MPS
#else
	0x40,//
	0x00,// 64 bytes MPS
#endif
	0x00,

	0x07,//Length
	0x05,//USB_DT_ENDPOINT
	0x00 | BULK_OUT_EP_NUM,// 2 -- OUT
	0x02,// Bulk
#ifndef USE_FULL_SPEED
	0x00,//
	0x02,// 64 bytes MPS
#else
	0x40,//
	0x00,// 64 bytes MPS
#endif
        0x00
    }
};

/*static const struct usb_config_descriptor* config_desc = &_configDescTotal.configDesc;*/
/*static const unsigned char* intf_desc = &_configDescTotal.intfDesc;*/

#define DT_STRING_ID_LEN  4
static const  char dt_string_id[DT_STRING_ID_LEN]={
	DT_STRING_ID_LEN,
	USB_DT_STRING,
	0x09,
	0x04,
};
#define DT_STRING_VID_LEN 16
static const char dt_string_vid[DT_STRING_VID_LEN]=
{
	DT_STRING_VID_LEN,
	USB_DT_STRING,
	'A',
	0,
	'm',
	0,
	'l',
	0,
	'o',
	0,
	'g',
	0,
	'i',
	0,
	'c',
	0
};

#define _PLATFORM_CHIP_INDEX    '8'

#define DT_STRING_PID_LEN 16
static const char dt_string_pid[DT_STRING_PID_LEN]=
{
	DT_STRING_PID_LEN,
	USB_DT_STRING,
	'M',
	0,
    _PLATFORM_CHIP_INDEX,
	0,
	'-',
	0,
	'C',
	0,
	'H',
	0,
	'I',
	0,
	'P',
	0
};

#define DT_STRING_SERIAL_LEN	18
static const char dt_string_serial[DT_STRING_SERIAL_LEN]=
{
	DT_STRING_SERIAL_LEN,
	USB_DT_STRING,
	'2',
	0,
	'0',
	0,
	'1',
	0,
	'1',
	0,
	'0',
	0,
	'4',
	0,
	'0',
	0,
	'6',
	0
};

static char _resultInfo[AM_BULK_REPLY_LEN] = {0};
/*static char _bulkCmdBuf[AM_BULK_REPLY_LEN] = {0};*/
/*#define buff ((char*)PCD_BUFF)*/
static volatile char _pcd_buff[512] ;
#define buff _pcd_buff

int usb_pcd_init(void)
{
    flush_cache((unsigned long)buff, 512);
	return dwc_core_init();
}

static unsigned int need_check_timeout;
static unsigned int time_out_val;
static unsigned int _auto_burn_time_out_base = 0;

void usb_parameter_init(int time_out)
{
	need_check_timeout = 0;
	/* clear utimer */
	need_check_timeout=get_timer(need_check_timeout)?get_timer(need_check_timeout):1;
	if (time_out)
	{
		time_out_val = time_out; // wait PC GetDescriptor command for 1us changed by Elvis

	}
	else
	{
		time_out_val = USB_ROM_CONN_TIMEOUT; // wait PC GetDescriptor command
	}
    //printf("need_check_timeout %d, time_out_val %d, time_out %d\n", need_check_timeout, time_out_val, time_out);

    //Added by Sam Wu
    optimus_buf_manager_init(16*1024);
    optimus_download_init();
    return;
}

int usb_pcd_irq(void)
{
        if (need_check_timeout)
        {
                unsigned curTime = get_timer(need_check_timeout);
                if (curTime > time_out_val) {
                        dwc_otg_power_off_phy();
                        ERR("Try connect time out %u, %u, %u\n", curTime, time_out_val, need_check_timeout);
                        return 2;// return to other device boot
                }
        }
        if (_auto_burn_time_out_base) {
                unsigned waitIdentifyTime = get_timer(_auto_burn_time_out_base);
                unsigned timeout = simple_strtoul(getenv(_ENV_TIME_OUT_TO_AUTO_BURN), NULL, 0);
                if (waitIdentifyTime > timeout) {
                        ERR("waitIdentifyTime(%u) > timeout(%u)\n", waitIdentifyTime, timeout);
                        _auto_burn_time_out_base = 0;//clear it to allow enter burning next time
                        return __LINE__;
                }
        }

        return dwc_otg_irq();
}

void start_bulk_transfer(pcd_struct_t *_pcd)
{
	_pcd->bulk_lock = 1; // TODO : add lock code.
	dwc_otg_ep_req_start(_pcd,_pcd->bulk_out?BULK_OUT_EP_NUM:BULK_IN_EP_NUM);
}
/**
 * This functions delegates the setup command to the gadget driver.
 */
void do_gadget_setup( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl)
{
	int			value;
	u16			w_index = ctrl->wIndex;
	u16			w_value = ctrl->wValue;
	u16			w_length = ctrl->wLength;

	/* usually this just stores reply data in the pre-allocated ep0 buffer,
	 * but config change events will also reconfigure hardware. */
	switch (ctrl->bRequest)
    {
	  case USB_REQ_GET_DESCRIPTOR:
          {
              if (ctrl->bRequestType != (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE))
                  break;
              //time_out_val = USB_ROM_DRIVER_TIMEOUT;// Wait SetConfig (PC install driver OK)
              /*need_check_timeout = 0;*/
              switch (w_value >> 8)
              {
                  case USB_DT_DEVICE:
                      DBG("get dev desc\n");
                      value = min(w_length, (u16) sizeof device_desc);
                      /*usb_memcpy(buff, (char*)&device_desc, value);*/
                      /*
                       *memcpy((void*)buff, &device_desc, value);
                       *_pcd->buf = buff;
                       */
                      _pcd->buf = (volatile char*)&device_desc;
                      _pcd->length = value;
                      break;
                  case USB_DT_DEVICE_QUALIFIER:
                      DBG("get dev qual\n");
                      break;
                  case USB_DT_OTHER_SPEED_CONFIG:
                      DBG("--get other speed configuration descriptor\n");
                      DBG("--other speed configuration descriptor length :%d\n", value);
                      break;
                  case USB_DT_CONFIG:
                      {
                          USB_DBG("--get configuration descriptor: size %d\n",w_length);
                          if (w_length > USB_DT_CONFIG_SIZE) {//request USB_DT_CONFIG_SIZE only
                              value = TOTAL_CONFIG_DESC_LEN;
                          }
                          else{
                              value = w_length;
                          }
                          _pcd->buf = (volatile char*)&_configDescTotal;
                          _pcd->length = value;
                          /*printf("--get configuration descriptor: size %d, ret length :%d\n\n", w_length, value);			*/
                          printf("Get DT cfg\n");

                      }
                      break;

                  case USB_DT_STRING:
                      {
                          const char* str = NULL;

                          /*DBG("--get string Desc: id %d\n", w_value & 0xff);*/
                          printf("Get str %x\n", w_value);
                          switch (w_value & 0xff)
                          {
                              case 0: // IDs
                                  /*usb_memcpy(buff,(void*)dt_string_id,DT_STRING_ID_LEN);*/
                                  str = dt_string_id;
                                  break;

                              case 1: // STRING_MANUFACTURER
                                  /*usb_memcpy(buff,(void*)dt_string_vid,DT_STRING_VID_LEN);*/
                                  str = dt_string_vid;
                                  break;

                              case 2://STRING_PRODUCT
                                  /*usb_memcpy(buff,(void*)dt_string_pid,DT_STRING_PID_LEN);*/
                                  str = dt_string_pid;
                                  break;

                              case 3://STRING_SERIAL
                                  /*usb_memcpy(buff,(void*)dt_string_serial,DT_STRING_SERIAL_LEN);*/
                                  str = dt_string_serial;
                                  break;

                              default:
                                  USB_ERR("Error string id!\n");
                                  /*buff[0] = 0;*/
                                  str = NULL;
                                  break;
                          }
                          _pcd->buf = (char*)str;
                          _pcd->length = str[0];
                          /*printf("--get str DESC: id %d ,return length %d\n", (w_value & 0xff), _pcd->length);*/
                      }
                      break;

              }

          }
          break;

      case USB_REQ_SET_CONFIGURATION:
          {
              if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_STANDARD |
                          USB_RECIP_DEVICE))
                  break;
              printf("set CFG\n");
              _pcd->buf = 0;
              _pcd->length = 0;
              _pcd->request_config = 1;   /* Configuration changed */
              need_check_timeout = 0;
              if (OPTIMUS_WORK_MODE_USB_UPDATE == optimus_work_mode_get()) {//not booting from usb
                      if (getenv(_ENV_TIME_OUT_TO_AUTO_BURN))_auto_burn_time_out_base = get_timer(0) ;
              }
          }
          break;

	case USB_REQ_GET_CONFIGURATION:
		if (ctrl->bRequestType != (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE))
			break;
		printf("get CFG\n");
		buff[0] = 1;
		_pcd->buf = buff;
		_pcd->length = 1;
		break;

	default:
		USB_ERR("--unknown control req %02x.%02x v%04x i%04x l%u\n",
			ctrl->bRequestType, ctrl->bRequest,
			w_value, w_index, w_length);
	}

	w_index = 0; //remove compile warning
	return ;
}

/**
 * This functions delegates vendor ctrl request.
 */
void do_vendor_request( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl)
{
	unsigned long	        value =0;
	u16			w_index = ctrl->wIndex;
	u16			w_value = ctrl->wValue;
	u16			w_length = ctrl->wLength;

	switch (ctrl->bRequest)
    {
	  case AM_REQ_WRITE_MEM:
		if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		USB_DBG("--am req write memory\n");
		value = (w_value << 16) + w_index;
		USB_DBG("addr = 0x%08X, size = %d\n\n",value,w_length);
		_pcd->buf = (char *)value; // copy to dst memory directly
		_pcd->length = w_length;
		break;

	  case AM_REQ_READ_MEM:
		if (ctrl->bRequestType != (USB_DIR_IN | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		value = (w_value << 16) + w_index;

		/*usb_memcpy((char *)buff,(char*)value,w_length);*/
		memcpy((void*)buff,(void*)value,w_length);

		_pcd->buf = buff;
		_pcd->length = w_length;
		break;

	  case AM_REQ_READ_AUX:
		if (ctrl->bRequestType != (USB_DIR_IN | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		/*unsigned int data = 0;*/
		value = (w_value << 16) + w_index;

		//data = _lr(value);
		/**(unsigned int *)(unsigned)buff = data;*/
                memset((char*)buff, 0, sizeof(unsigned));

		_pcd->buf = buff;
		_pcd->length = w_length;
		break;

	  case AM_REQ_FILL_MEM:
	  case AM_REQ_WRITE_AUX:
	  case AM_REQ_MODIFY_MEM:
		if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		_pcd->buf = buff;
		_pcd->length = w_length;
		break;

	  case AM_REQ_RUN_IN_ADDR:
		if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		value = (w_value << 16) + w_index;
		USB_DBG("--am req run in addr %p\n\n",value);
		_pcd->buf = buff;
		_pcd->length = w_length;
		break;

	  case AM_REQ_WR_LARGE_MEM:
		value = 1;
	  case AM_REQ_RD_LARGE_MEM:
		USB_DBG("--am req large %s mem \n\n",value?"write":"read");

		_pcd->bulk_len = w_value;	// block length
		_pcd->bulk_num = w_index; // number of block
		_pcd->buf = buff;       //EP0 command data buffer
		_pcd->length = w_length; //EP0 command data length
         /*FIXME: cann't delay when writelargeMem, or it will fail??*/
        /*
         *printf("f(%s)L%d: bulk_len=0x%x, bulk_num=%d, bufAddr=0x%x, len=0x%x\n",
         *        __func__, __LINE__, _pcd->bulk_len, _pcd->bulk_num, _pcd->buf, _pcd->length);
         */
		break;

      case AM_REQ_DOWNLOAD:
        {
            value = 1;//is out
            _pcd->bulk_len  = w_value;//block length
            _pcd->bulk_num  = w_index;//how many times to transfer
            _pcd->buf       = buff;
            _pcd->length    = w_length;
        }
        break;

      case AM_REQ_UPLOAD:
        {
            _pcd->buf       = _resultInfo;
            _pcd->length    = w_length;//assert that lenght == 16 ????

            optimus_buf_manager_get_command_data_for_upload_transfer((u8*)_resultInfo, w_length);
        }
        break;


	  case AM_REQ_IDENTIFY_HOST:
        {
            static const char id[4] =
            {
                [0] = USB_ROM_VER_MAJOR,
                [1] = USB_ROM_VER_MINOR,
                [2] = USB_ROM_STAGE_MAJOR,
                [3] = USB_ROM_STAGE_MINOR,
            };

            _pcd->buf = (char*)id;
            _pcd->length = w_length;//FIXME:asset w_length == 4 ??
            _auto_burn_time_out_base = 0;//get burning tool identify command, so clear the timeout flag
            printf("\nID[%d]\n", _pcd->buf[3]);
        }
        break;

      case AM_REQ_BULKCMD://Added by Sam
        {
            _pcd->bulk_len = w_value;	// block length
            _pcd->bulk_num = w_index; // number of block
            _pcd->buf      = buff;       //EP0 command data buffer, out buffer after set_up command
            _pcd->length   = w_length; //EP0 command data length
            /*printf("blkc:len %d\n", _pcd->length);*/
            _pcd->cmdtype.setup_complete = 1;
        }
        break;

	  case AM_REQ_TPL_CMD:
        {
            _pcd->buf = buff;
            _pcd->length = w_length;
        }
        break;

	  case AM_REQ_TPL_STAT:
        {
            _pcd->buf = _resultInfo;
            _pcd->length = w_length;
        }
        break;

	  default:
		USB_ERR("--unknown vendor req %02x.%02x v%04x i%04x l%u\n",
			ctrl->bRequestType, ctrl->bRequest,
			w_value, w_index, w_length);
		break;
	}

	return;
}

/*
 * This function will be called after a whole SETUP-OUT-IN transfer.
 */
void do_vendor_out_complete( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl)
{
	unsigned long	        value = 0;
	u16			w_index = ctrl->wIndex;
	u16			w_value = ctrl->wValue;
	u16			w_length = ctrl->wLength;
	void (*fp)(void);
	volatile char * buf;

	//USB_DBG("do_vendor_out_complete(0x%x)\n", ctrl->bRequest);
	switch (ctrl->bRequest)
    {
	  case AM_REQ_WRITE_MEM:
		if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
			USB_DBG("--am req write memory completed\n\n");
		break;

	  case AM_REQ_FILL_MEM:
		buf = (char*)_pcd->buf;
		unsigned long addr,i;
		for (i = 0; i < _pcd->length; i+=8) {
			addr = *((unsigned int *)&buf[i]) ;
			value = *((unsigned int *)&buf[i+4]) ;
			*(unsigned int*)addr = value;
		}
		break;

	  case AM_REQ_WRITE_AUX:
		buf = _pcd->buf;
		unsigned int data =0;

		data = *((unsigned int *)&buf[0]) ; //reg value
		value = (w_value << 16) + w_index; //aux reg

                dwc_write_reg32(value, data);
		break;

	  case AM_REQ_MODIFY_MEM:
		do_modify_memory(w_value,(char*)_pcd->buf);
		break;

	  case AM_REQ_RUN_IN_ADDR:
		if (ctrl->bRequestType != (USB_DIR_OUT | USB_TYPE_VENDOR |
				USB_RECIP_DEVICE))
				break;
		value = (w_value << 16) + w_index;
		USB_DBG("run addr = 0x%08X\n",value);
		fp = (void(*)(void))value;
		dwc_otg_power_off_phy();
		fp();
		break;

	  case AM_REQ_WR_LARGE_MEM:
		value = 1; // is_out = 1
      case AM_REQ_RD_LARGE_MEM:
        {
            const unsigned* intBuf = (unsigned*)buff;
            _pcd->bulk_out = (char)value; // read or write
            _pcd->bulk_buf = (char*)(u64)intBuf[0];
            _pcd->bulk_data_len = intBuf[1]; // data length

            //added by Sam.Wu
            _pcd->bulk_xfer_len = 0;
            _pcd->xferNeedReply = 0;

            _pcd->bulk_len     = DWC_BLK_LEN(_pcd->bulk_data_len);
            _pcd->bulk_num      = DWC_BLK_NUM(_pcd->bulk_data_len);
            start_bulk_transfer(_pcd);
        }
        break;

      case AM_REQ_DOWNLOAD:
        value = 2;//2 to differ from write_large_mem
        {
            const unsigned* intBuf = (unsigned*)buff;
            unsigned isPktResended   = intBuf[0];
            unsigned sequenceNo = intBuf[2];
            _pcd->bulk_out      = value;
            _pcd->bulk_data_len = intBuf[1];
            _pcd->bulk_xfer_len = 0;
            _pcd->origiSum      = intBuf[3];
            _pcd->isPktResended = isPktResended;

            if (!isPktResended) //request next buffer slot only if transfer packet not re-sended packet
            {
                int ret = optimus_buf_manager_get_buf_for_bulk_transfer(&_pcd->bulk_buf, _pcd->bulk_data_len, sequenceNo, NULL);
                if (ret) _pcd->bulk_data_len = _pcd->bulk_len = _pcd->bulk_num = 0;
            }

            _pcd->sequenceNo = sequenceNo;

            _pcd->bulk_len     = DWC_BLK_LEN(_pcd->bulk_data_len);
            _pcd->bulk_num     = DWC_BLK_NUM(_pcd->bulk_data_len);
            _pcd->xferNeedReply= 1;///////
            start_bulk_transfer(_pcd);
        }
        break;

      case AM_REQ_UPLOAD:
        {
            //command foramt: [4-7]dataLen, other don't care now
            const u8* cmdData       = (const u8*)_resultInfo;
            const u32 sequenceNo    = *(unsigned*)(cmdData + 8);
            const u32 leftDataLen   = *(unsigned*)(cmdData + 4);
            int ret = 0;

            _pcd->bulk_out      = 0;
            _pcd->bulk_xfer_len = 0;
            _pcd->bulk_data_len = leftDataLen;

            _pcd->bulk_len     = DWC_BLK_LEN(leftDataLen);
            _pcd->bulk_num      = DWC_BLK_NUM(leftDataLen);

            ret = optimus_buf_manager_get_buf_for_bulk_transfer(&_pcd->bulk_buf, _pcd->bulk_data_len, sequenceNo, _resultInfo);
            if (ret) _pcd->bulk_data_len = _pcd->bulk_len = _pcd->bulk_num = 0;//respond 0 byte data to stop transfer

            DWN_DBG("up 0x:len %x, buf %p, bulk_num %d\n", _pcd->bulk_data_len, _pcd->bulk_buf, _pcd->bulk_num);
            _pcd->xferNeedReply= 1;///////
            start_bulk_transfer(_pcd);
        }
        break;


	  case AM_REQ_TPL_CMD:
		  /* this is an example for any command */
		if (!w_index) {/* assume subcode is 0 */
/*	???????????????????????????
			char dev[16] = {0};
			u64 offset = 0;
			u64 tmp = 0;
			u32 mem_addr = (*(unsigned int*)buff);
			offset |= (*(unsigned int*)&buff[16]);
			tmp = (*(unsigned int*)&buff[20]);
			offset |= (tmp << 32);

			u32 size = (*(unsigned int*)&buff[12]);
			usb_memcpy(dev,&buff[32],16);
			burn_board(dev, mem_addr, offset, size);
*/
		}
		else if(w_index == 1){
			char cmd[CMD_BUFF_SIZE];
			memcpy(cmd, (void*)buff, CMD_BUFF_SIZE);
			if (strncmp(cmd,"bootm",(sizeof("bootm")-1)) == 0) {
				dwc_otg_pullup(0);//disconnect
			}
            printf("tplcmd[%s]\n", cmd);
			optimus_working(cmd, _resultInfo);
		}
		break;

      case AM_REQ_BULKCMD:
        {
            do_bulk_cmd((char*)buff);
        }
        break;

	  default:
		USB_ERR("--unknown vendor req comp %02x.%02x v%04x i%04x l%u\n",
			ctrl->bRequestType, ctrl->bRequest,
			w_value, w_index, w_length);
	}
	w_length = 0;//remove compile warning
	return;
}

/*
 * This function will be called after a whole SETUP-IN-OUT transfer.
 */
void do_vendor_in_complete( pcd_struct_t *_pcd, struct usb_ctrlrequest * ctrl)
{
	u16			w_index = ctrl->wIndex;
	u16			w_value = ctrl->wValue;
	u16			w_length = ctrl->wLength;

	//USB_DBG("do_vendor_out_complete(0x%x)\n", ctrl->bRequest);
	switch (ctrl->bRequest)
    {
	  case AM_REQ_IDENTIFY_HOST:
	  case AM_REQ_TPL_STAT:
          break;

      case USB_REQ_GET_DESCRIPTOR:
          break;

      case AM_REQ_UPLOAD:
        {
            //command foramt: [4-7]dataLen, other don't care now
            const u8* cmdData       = (const u8*)_resultInfo;
            const u32 sequenceNo    = *(unsigned*)(cmdData + 8);
            const u32 leftDataLen   = *(unsigned*)(cmdData + 4);
            int ret = 0;

            _pcd->bulk_out      = 0;
            _pcd->bulk_xfer_len = 0;
            _pcd->bulk_data_len = leftDataLen;

            _pcd->bulk_len     = DWC_BLK_LEN(leftDataLen);
            _pcd->bulk_num      = DWC_BLK_NUM(leftDataLen);

            ret = optimus_buf_manager_get_buf_for_bulk_transfer(&_pcd->bulk_buf, _pcd->bulk_data_len, sequenceNo, _resultInfo);
            if (ret) _pcd->bulk_data_len = _pcd->bulk_len = _pcd->bulk_num = 0;//respond 0 byte data to stop transfer

            DWN_DBG("up 0x:len %x, buf %p, bulk_num %d\n", _pcd->bulk_data_len, _pcd->bulk_buf, _pcd->bulk_num);
            _pcd->xferNeedReply= 1;///////
            start_bulk_transfer(_pcd);
        }
        break;

	  default:
		USB_ERR("--unknown vendor req comp %02x.%02x v%04x i%04x l%u\n",
			ctrl->bRequestType, ctrl->bRequest,
			w_value, w_index, w_length);
	}
	w_length = 0;//remove compile warning
	return;
}


int bulk_transfer_reply(const pcd_struct_t* _pcd)
{
    static int _mediaErr = 0;
    static pcd_struct_t pcd;
    char* replyBuf = _resultInfo;
    const void* data    = _pcd->bulk_buf;
    const unsigned len  = _pcd->bulk_xfer_len;
    const unsigned sequenceNo = _pcd->sequenceNo;
    int isOut           = !_pcd->bulk_out;//handshake direction is opposite
    const u32 origiSum  = _pcd->origiSum;
    unsigned genSum = 0;
    int ret = 0;
    const int isPktResended = _pcd->isPktResended;

    dwc_otg_bulk_ep_enable(!isOut);//enable the bulk in ep first before optimus_working!!

    if(0 == _pcd->sequenceNo
            && !isPktResended)//media error can't resolved by reseneded, only memory(dram) error can
    {
        _mediaErr = 0;//set error none if download a new file
    }

    if (_mediaErr) {
        sprintf(replyBuf, "media error %d at seq %d, resend %d\n", _mediaErr, sequenceNo, isPktResended);
        DWN_ERR(replyBuf);
        ret = __LINE__;
    }
    else
    {
        genSum = add_sum(data, len);

        if (origiSum != genSum)
        {
            sprintf(replyBuf, "0x: genSum %x != org %x at seq %x, len %x, resend %d\n", genSum, origiSum, sequenceNo, len, isPktResended);
            DWN_ERR(replyBuf);
            ret = __LINE__;
        }
    }

    if (!ret) //add-sum checked ok and no media error
    {
        _mediaErr = optimus_buf_manager_report_transfer_complete(_pcd->bulk_xfer_len, replyBuf);
        if (_mediaErr) {
            sprintf(replyBuf, "media error %d at seq %d\n", _mediaErr, sequenceNo);
            DWN_ERR(replyBuf);
            ret = __LINE__;
        }
    }

    if (!ret)
    {
        memcpy(replyBuf, "OK!!", 4);
    }

    //PCD fields needed for reply
    //see implementation of dwc_otg_ep_req_start
    pcd.bulk_data_len = AM_BULK_REPLY_LEN;//total length <= 4k
    pcd.bulk_len      = DWC_BLK_LEN(pcd.bulk_data_len);//total length <= 4k
    pcd.bulk_num      = DWC_BLK_NUM(pcd.bulk_data_len);
    pcd.bulk_buf      = replyBuf;
    pcd.bulk_xfer_len = 0;

    DWN_DBG("replyBuf %s\n", replyBuf);
    dwc_otg_ep_req_start(&pcd,  isOut?BULK_OUT_EP_NUM:BULK_IN_EP_NUM);

    return ret;
}

/*
 * This function will be called after a whole bulk out transfer.
 * Attention That All bulk transfer will reach here after completed!!
 */
void do_bulk_complete( pcd_struct_t *_pcd)
{
	_pcd->bulk_lock = 0;
	_pcd->bulk_num--;
	/*_pcd->bulk_data_len -= _pcd->xfer_len;*/
    _pcd->bulk_xfer_len += _pcd->xfer_len;

    //open this debug info if see if _pcd->bulk_num is 0 has been reponsed! i.e, all data transfrred ended
    //if not bulk in tranferred, open in printf will let down the csw of mwrite(csw will be invalid transfer)
    DWN_DBG("left blk %d, this len 0x%x, bulk_xfer_len 0x%x\n", _pcd->bulk_num, _pcd->xfer_len, _pcd->bulk_xfer_len);

	if(_pcd->bulk_num > 0
            && _pcd->bulk_len)//if earlier packet length is 0, no next xfer here!!
	{
        const u32 leftDataLen = _pcd->bulk_data_len - _pcd->bulk_xfer_len;

        _pcd->bulk_len     = DWC_BLK_LEN(leftDataLen);

		/*_pcd->bulk_buf += _pcd->bulk_len;*/
		start_bulk_transfer(_pcd);

        return;/////////////////
	}

    if (this_pcd.xferNeedReply) //get download command and is out
    {
        this_pcd.xferNeedReply = 0;////

        if (2 == _pcd->bulk_out) //2 means download command 0x32, only this command need handshake??!!!!!
        {
            bulk_transfer_reply(_pcd);
            return;////////
        }

        if (!_pcd->bulk_out)
        {
            optimus_buf_manager_report_transfer_complete(_pcd->bulk_xfer_len, NULL);
        }
    }
}

static int bulk_cmd_reply(const char* replyBuf)
{
    static pcd_struct_t pcd;

    //PCD fields needed for reply
    //see implementation of dwc_otg_ep_req_start
    pcd.bulk_len      = AM_BULK_REPLY_LEN;
    pcd.bulk_buf      = (char*)replyBuf;
    pcd.bulk_xfer_len = 0;

	this_pcd.bulk_out = 0;//////////////////////////////OH NO!!!! I don't like the common pcd, FIXME to use various PCD !!
    this_pcd.xferNeedReply = 0;
    dwc_otg_ep_req_start(&pcd,  BULK_IN_EP_NUM);//bulk in to reply result, it is ALWAYS IN

    return 0;
}

static int do_bulk_cmd(char* cmd)
{
    int ret = 0;
    const int is_in = 1;

    ret = dwc_otg_bulk_ep_enable(is_in);//enable the bulk in ep first before optimus_working!!

	printf("BULKcmd[%s]\n", cmd);
    ret = optimus_working(cmd, _resultInfo);

    ret = bulk_cmd_reply(_resultInfo);

    return ret;
}

void do_modify_memory(u16 opcode, char *inbuff)
{
	unsigned int *mem,*mem2;
	unsigned int data,mask;

	mem = *(unsigned int**)&inbuff[0];
	data = *(unsigned int*)&inbuff[4];
	mask = *(unsigned int*)&inbuff[8];
	mem2= *(unsigned int**)&inbuff[12];

	switch (opcode) {
	  case 0: //*mem = data
		*mem = data;
		break;

	  case 1:// *mem = (data & mask)
		*mem = data & mask;
		break;

	  case 2:// *mem =(*mem | mask)
		*mem = *mem | mask;
		break;

	  case 3:// *mem = (data & (~mask))
		*mem =  (data & (~mask));
		break;

	  case 4:// *mem = (data & mask) |(*mem & ~mask)
		*mem = (data & mask) |(*mem & ~mask);
		break;

	  case 5:// *mem = *mem2
		*mem = *mem2;
		break;

	  case 6:// *mem = (*mem2 & mask)
		*mem = (*mem2 & mask);
		break;

	  case 7:// while(data--) {*mem++ = *mem2++}
		while (data--) {
			*mem++ = *mem2++;
		}
		break;

	  default:
		break;
	}

}

