#include <common.h>
#include <command.h>

#include "jdecHeader.h"

extern int DecompressImage(InputStructure*);
extern int CleanUp(InputStructure*);
extern int markerSKIP(unschar **);


int CleanUp(InputStructure *input) {
    // Prevents Memory leaks
    if ((input->flags & CC_MALLOC_RAW_DATA) && !input->rawData) {
        free(input->rawData);
    }
    if ((input->flags & CC_MALLOC_COMPONENT_ATTR) && !input->componentAttributes) {
        free(input->componentAttributes);
    }
    if ((input->flags & CC_MALLOC_STREAM_Y) && !input->out.streamY) {
        free(input->out.streamY);
    }
    if ((input->flags & CC_MALLOC_STREAM_U) && !input->out.streamU) {
        free(input->out.streamU);
    }
    if ((input->flags & CC_MALLOC_STREAM_V) && !input->out.streamV) {
        free(input->out.streamV);
    }

    return 0;
}

static int OutputFile(InputStructure *input, unsigned int addr) {
    char *data = (char *) addr;
    char *data_Y = (char *) input->out.streamY;
    char *data_u = (char *) input->out.streamU;
    char *data_v = (char *) input->out.streamV;

    uint i = 0, j = 0;
    char ppmarray[20] = { '\0' };
    uint width = input->inputAttributes[0], height = input->inputAttributes[1];

    width = ((width + input->scalefactor - 1) / input->scalefactor);
    height = ((height + input->scalefactor - 1) / input->scalefactor);

    for (j = 0; j < height * input->scalefactor; j += input->scalefactor) {
        for (i = 0; i < width * input->scalefactor; i += input->scalefactor) {
            *data++ = *(input->out.streamV + j * input->extwidth + i); //B
            *data++ = *(input->out.streamU + j * input->extwidth + i); //G
            *data++ = *(input->out.streamY + j * input->extwidth + i); //R
        }
    }
    return 0;
}

static int DNL(unschar **ipPtr, InputStructure *input) {
    // DNL Marker constitutes the height of the encoded image.
    int Length = 0;

    Length = (**ipPtr * 256) + (*((*ipPtr) + 1));
    (*ipPtr) += 2;
    assert(Length == 4);
    input->inputAttributes[1] = (**ipPtr * 256) + (*((*ipPtr) + 1)); // Height
    (*ipPtr) += 2;

    return 0;
}

static int checkhead(unschar *ipPtr)
{
	unsigned short *h = (unsigned short *)ipPtr;
	if(*h != 0xd8ff)
		return -1;
	return 0;

}

int markerSKIP(unschar **InPtr) {
    // Encountered a marker, Do nothing. Just Skip ahead.
    (*InPtr) += (256 * (**InPtr) + *(*InPtr + 1));
    return 0;
}

static int InitInput(InputStructure *input, AppArgs *args) {
    // Reset the input structure for smooth execution
    unschar *ipPtr = input->rawData;
    int count = 0, i = 0, noofScans = 0;
    int check;
    //int r = checkhead(ipPtr);

    input->eoi = 0;
    input->soi = 0;
    input->multiScan = 0;
    input->DNL = 0;
    input->scalefactor = args->scalefactor; //value = 1 //note modify

    /* Huffman DC, AC BITS and VAL Reset */
    for (count = 0; count < 2; count++) {
        for (i = 0; i < 16; i++) {
            input->dcCode.BITS[count][i] = 0;
            input->dcCode.VALUES[count][i] = 0;
            input->acCode.BITS[count][i] = 0;
        }
    }
    for (count = 0; count < 2; count++) {
        for (i = 0; i < MAXHUFFSIZE; i++) {
            input->acCode.VALUES[count][i] = 0;
        }
    }

    /*Output Stream Pointer Initialization*/
    input->out.indexY[0] = input->out.indexY[1] = 0;
    input->out.indexU[0] = input->out.indexU[1] = 0;
    input->out.indexV[0] = input->out.indexV[1] = 0;

    /*DNL Marker Support*/
    /*The height of an image is declared in the marker SOI. But it so happens sometimes in multi-scan images, the height is declared after the occurence of first scan under the marker DNL. Hence the correct height information is not known until the first scan is completely decoded. To avoid this wait we look in to the entire image ahead for DNL and extract the actual height of the image.*/
    while (noofScans < 2) {
        if (*ipPtr == 0xff) {
            // Stand Alone Marker(s)
            if ((*(ipPtr + 1) == 0x00) || ((*(ipPtr + 1) >= 0xd0) && (*(ipPtr + 1) <= 0xd8)))
                ipPtr += 2;
            // Stuff Byte
            else if (*(ipPtr + 1) == 0xff)
                ipPtr += 1;
            // EOI Marker
            else if (*(ipPtr + 1) == 0xd9)
                noofScans = 2;
            else {
                // DNL Marker
                if (*(ipPtr + 1) == 0xdc) {
                    ipPtr += 2;
                    DNL(&ipPtr, input);
                    input->DNL = 1;
                    noofScans = 2;
                } else {
                    // Start of Scan Marker
                    if (*(ipPtr + 1) == 0xda)
                        noofScans++;
                    ipPtr += 2;
                    markerSKIP(&ipPtr);
                }
            }
        } else{
            ipPtr++;
	    check ++;
	    if(check > 1000000 )
	    	return -1;
        }
    }
    return 0;
}

static int mmcFileRead(unsigned int addr, InputStructure *input) {
    input->rawData = (unschar*) addr;
    char cmd[20] = { 0 };
    sprintf(cmd, "mmc read 1 0x%x 4000 1000", addr);

    return 0;
}

int video_display_jpeg(void *decode_data_buf, InputStructure *input, int x, int y, int v_flip, int h_flip) {
    vidinfo_t * info = NULL;

#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif

#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

    int i, j, k;
    int dis_x, dis_y;
    int lcd_line_length;
    uchar *fb;
    unsigned long pic_w, pic_h, panel_w, panel_h;

    pic_w = input->inputAttributes[0];
    pic_h = input->inputAttributes[1];

  // pic_w = 1376;
  // pic_h = 768;

    panel_w = info->vl_col;
    panel_h = info->vl_row;

    lcd_line_length = (panel_w * NBITS(info->vl_bpix)) / 8;

    dis_x = x;
    if (dis_x < 0) {
        dis_x = (panel_w - pic_w) / 2;
    }

    dis_y = y;
    if (dis_y < 0) {
        dis_y = (panel_h - pic_h) / 2;
    }

    //printf("dis_x = %d, dis_y = %d\n", dis_x, dis_y);
    //printf("pic_w = %d, pic_h = %d\n", pic_w, pic_h);
   // printf("panel_w = %d, panel_h = %d\n", panel_w, panel_h);

    fb = (uchar *) (info->vd_base + (dis_y - 1) * lcd_line_length + dis_x * (LCD_BPP / 8));

    char *tmp_data_buf = (char *) decode_data_buf;
    char tmp_ch = 0;
    int tmp_src_ind = 0, tmp_dst_ind = 0;

    //printf("show jpeg step : 1\n");
    if (v_flip && !h_flip) {
        //printf("handle vertical flip\n");

        for (i = 0; i < pic_h / 2; i++) {
            for (j = 0; j < pic_w; j++) {
                tmp_src_ind = i * pic_w * 3 + j * 3;
                tmp_dst_ind = (pic_h - i - 1) * pic_w * 3 + j * 3;

                for (k = 0; k < 3; k++) {
                    tmp_ch = *(tmp_data_buf + tmp_dst_ind);
                    *(tmp_data_buf + tmp_dst_ind) = *(tmp_data_buf + tmp_src_ind);
                    *(tmp_data_buf + tmp_src_ind) = tmp_ch;

                    tmp_src_ind += 1;
                    tmp_dst_ind += 1;
                }
            }
        }
    }

    if (!v_flip && h_flip) {
        //printf("handle horizontal flip\n");

        for (i = 0; i < pic_h; i++) {
            for (j = 0; j < pic_w / 2; j++) {
                tmp_src_ind = i * pic_w * 3 + j * 3;
                tmp_dst_ind = i * pic_w * 3 + (pic_w - j - 1) * 3;

                for (k = 0; k < 3; k++) {
                    tmp_ch = *(tmp_data_buf + tmp_dst_ind);
                    *(tmp_data_buf + tmp_dst_ind) = *(tmp_data_buf + tmp_src_ind);
                    *(tmp_data_buf + tmp_src_ind) = tmp_ch;

                    tmp_src_ind += 1;
                    tmp_dst_ind += 1;
                }
            }
        }
    }

    if (v_flip && h_flip) {
        printf("handle vertical and horizontal flip\n");

        for (i = 0; i < pic_h / 2; i++) {
            for (j = 0; j < pic_w; j++) {
                tmp_src_ind = i * pic_w * 3 + j * 3;
                tmp_dst_ind = (pic_h - i - 1) * pic_w * 3 + (pic_w - j - 1) * 3;

                for (k = 0; k < 3; k++) {
                    tmp_ch = *(tmp_data_buf + tmp_dst_ind);
                    *(tmp_data_buf + tmp_dst_ind) = *(tmp_data_buf + tmp_src_ind);
                    *(tmp_data_buf + tmp_src_ind) = tmp_ch;

                    tmp_src_ind += 1;
                    tmp_dst_ind += 1;
                }
            }
        }
    }

    for (i = 0; i < pic_h; ++i) {
        for (j = 0; j < pic_w; j++) {
            *(fb++) = *tmp_data_buf++; // b
            *(fb++) = *tmp_data_buf++; // g
            *(fb++) = *tmp_data_buf++; // r
            *(fb++) = 0xff;
        }

        fb += (lcd_line_length - pic_w * 4);
    }

    //printf("show jpeg step : 2\n");
    char * osd = getenv("osd_reverse");//osd_reverse=all,true
    	if(!strcmp(osd,"all,true"))
	{
		WRITE_CBUS_REG_BITS(0x1A1B, 3, 28, 2);
	}
    flush_cache((unsigned long) info->vd_base, panel_w * panel_h * 4);
    return 0;
}


typedef struct {
	unsigned int src_width;
	unsigned int src_height;
	unsigned int dst_width;
	unsigned int dst_height;
}scale_info;


static int rgb_scale(ulong src_addr, ulong dst_addr,scale_info *rgb_info)
{

	int   nWidth   ,   nHeight	 ;
	int nNewWidth	 ,	 nNewHeight   ;  //
	int nNewWidthBit	 ,	 nWidthBit;
	float m_xscale,m_yscale;
	int i,j,x,y,oldoffset;
	char *pNewTmp = NULL;

    nWidth = rgb_info->src_width;
    nHeight = rgb_info->src_height;

	ulong src_width = rgb_info->src_width;
	ulong src_height = rgb_info->src_height;
	ulong  dst_width = rgb_info->dst_width;
	ulong dst_height = rgb_info->dst_height;

	m_xscale = (float)dst_width/(float)src_width;
	m_yscale = (float)dst_height/(float)src_height;

	nWidth = src_width;// 1920
	nHeight = src_height; //   1080
	nNewHeight = dst_height; // 768
	nNewWidth = dst_width; //1376

    char *pBuf_dst = (char *)dst_addr;
	char *pBuf = (char*) src_addr;
	nNewWidthBit = ( 4 - nNewWidth * 3 % 4 )%4 + nNewWidth * 3;

	for( i=0; i<nNewHeight; i++ )
	{
		pNewTmp = pBuf_dst + nNewWidthBit * i; // 24
		for( j=0; j<nNewWidth * 3; j += 3 )
		{
			x = (int) (j/m_xscale);
			y = (int) (i/m_yscale);
			oldoffset = (y*nWidth*3 + x) - (y*nWidth*3 + x)%3; //correct positon in 3 byte mode
			memcpy(pNewTmp+j, pBuf + oldoffset, 3);
		}
	}
	printf("rgb scale end \n");
	return 0;
}





static int jpeg_display(ulong raw_data_buf, int x, int y, int v_flip, int h_flip) {
    unsigned int decode_data_buf, component_attr_buf,scaler_data_buf;
    unsigned int y_data_buf, u_data_buf, v_data_buf;

    // Input arguments are parsed and stored in the structure AppArgs
    AppArgs args = { NULL };
    // Input Structure contains the information necessary to perform decoding
    InputStructure input = { NULL };

    args.scalefactor = 1;

    input.flags = 0;
    input.componentAttributes = NULL;
    input.out.streamY = NULL;
    input.out.streamU = NULL;
    input.out.streamV = NULL;

    component_attr_buf = raw_data_buf + 2 * 1024 * 1024;
    y_data_buf = component_attr_buf + 1 * 1024 * 1024;
    u_data_buf = y_data_buf + 2 * 1024 * 1024;
    v_data_buf = u_data_buf + 2 * 1024 * 1024;
    decode_data_buf = v_data_buf + 2 * 1024 * 1024;
	scaler_data_buf = decode_data_buf + 10 * 1024*1024;

    input.rawData = (unschar*) raw_data_buf;
    input.componentAttributes = (unschar*) component_attr_buf;
    input.out.streamY = (unschar*) y_data_buf;
    input.out.streamU = (unschar*) u_data_buf;
    input.out.streamV = (unschar*) v_data_buf;
    //printf("#######Decompressjpg_logo########\n");
    int ret =InitInput(&input, &args);
    if(ret < 0){
    //	printf("#######check jpeg  head fail ########\n");
    	return 0;
    }

    // printf("#######InitInput########\n");
    ret = DecompressImage(&input);
    //printf("decpmpress fail; ret = %d \n",ret);

    OutputFile(&input, decode_data_buf);

     vidinfo_t * info = NULL;
	 scale_info rgb_info;

	//RGBScale((unsigned long * )scaler_data_buf,1376,768,(unsigned long *) decode_data_buf,1920,1080)
#if defined CONFIG_VIDEO_AMLLCD
		extern vidinfo_t panel_info;
		info = & panel_info;
#endif

	rgb_info.src_width = input.inputAttributes[0];
	rgb_info.src_height= input.inputAttributes[1];


	 rgb_info.dst_width= info->vl_col;//panel_w
	 rgb_info.dst_height = info->vl_row;//panel_h
	 int scale_flag = 0;
	if(rgb_info.dst_width < (rgb_info.src_width - 100))
		 scale_flag = 1;
	if(rgb_info.dst_height< (rgb_info.src_height - 50))
		 scale_flag = 1;

	// if(scale_flag == 1){
	// rgb_scale(decode_data_buf,scaler_data_buf,&rgb_info);

	 //	input.inputAttributes[0] = rgb_info.dst_width;
	 //	input.inputAttributes[1] = rgb_info.dst_height;
	 //}

	//video_display_jpeg(scaler_data_buf, &input, x, y, v_flip, h_flip);
    video_display_jpeg(decode_data_buf, &input, x, y, v_flip, h_flip);
   // printf("#######display jpeg logo########\n");
    CleanUp(&input);

    return 0;
}

static int do_jpeg_display(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[]) {
    ulong addr;
    int x = -1, y = -1;
    int v_flip = 0, h_flip = 0;

    switch (argc) {
    case 1: /* use load_addr as default address */
        addr = load_addr;
        break;
    case 2: /* use argument */
        addr = simple_strtoul(argv[1], NULL, 16);
        x = -1;
        y = -1;
        v_flip = 0;
        h_flip = 0;
        break;
    case 4:
        addr = simple_strtoul(argv[1], NULL, 16);
        x = simple_strtol(argv[2], NULL, 10);
        y = simple_strtol(argv[3], NULL, 10);
        v_flip = 0;
        h_flip = 0;
        break;
    case 5:
        addr = simple_strtoul(argv[1], NULL, 16);
        x = simple_strtol(argv[2], NULL, 10);
        y = simple_strtol(argv[3], NULL, 10);
        v_flip = simple_strtoul(argv[4], NULL, 10);
        break;
    case 6:
        addr = simple_strtoul(argv[1], NULL, 16);
        x = simple_strtol(argv[2], NULL, 10);
        y = simple_strtol(argv[3], NULL, 10);
        v_flip = simple_strtol(argv[4], NULL, 10);
        h_flip = simple_strtol(argv[5], NULL, 10);
        break;
    default:
        return cmd_usage(cmdtp);
    }

    return jpeg_display(addr, x, y, v_flip, h_flip);
}

static cmd_tbl_t cmd_jpeg_sub[] = {
//
        U_BOOT_CMD_MKENT(display, 7, 0, do_jpeg_display, "", ""),
//
        };

static int do_jpeg(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]) {
    cmd_tbl_t *c;

    /* Strip off leading 'jpeg' command argument */
    argc--;
    argv++;

    c = find_cmd_tbl(argv[0], &cmd_jpeg_sub[0], ARRAY_SIZE(cmd_jpeg_sub));

    if (c)
        return c->cmd(cmdtp, flag, argc, argv);
    else
        return cmd_usage(cmdtp);
}

U_BOOT_CMD(
        jpeg, 7, 1, do_jpeg,
        "manipulate jpeg image data",
        "jpeg display <imageAddr> [x y] - display image at x,y\n"
);

static int set_uboot_logo(void)
{
	int logo_part[] ={
		0x4000,//jpeg logo 1: offset 8M
		0x4800,//jpeg logo 2: offset 9M
		0x5000,//jpeg logo 3: offset 10M
		0x5800,//jpeg logo 4: offset 11M
		0x6000,
		0x6800,
		0x7000,
		0x7800,
    	};

	char *cur_index = getenv("logoindex");//lasylogo curlogo
	char *last_index = getenv("lastlogo");

	if(!strcmp(last_index,cur_index))
		return 0;

	if(!strcmp(cur_index,"bmp")){
	//printf("#######cur_index = bmp ################\n");
	 setenv("prepare","setubootlogo;mmc read 1 ${loadaddr} 4000 3500;video open");
	 setenv("ubootlogo","bmp display ${loadaddr}");
	 setenv("lastlogo","bmp");
	 saveenv();

	 return 0;

	}
	int index = simple_strtol(cur_index, NULL, 10);
	if(index < 0)
		return 0;
	if(index > 3)
		return 0;
	//unsigned int loadaddr = logo_part[index];
	//printf("#######cur_index = jpeg ################\n");
	char cmd[20]={0};
	sprintf(cmd,"0x%x",logo_part[index]);
	setenv("jpegaddr",cmd);
	setenv("logoaddr","82600000");
	setenv("prepare","setubootlogo;mmc read 1 ${logoaddr} ${jpegaddr} 800;video open");//for jpeg);
	setenv("ubootlogo","jpeg display ${logoaddr} -1 -1 0 0");
	sprintf(cmd,"%d",index);
	setenv("lastlogo",cmd);
	saveenv();

	return 0;

}

U_BOOT_CMD(
        setubootlogo, 2, 1, set_uboot_logo,
        "set uboot logo",
        "logoindex :bmp or jpeg 0 1 2 3 4 \n"
);




