#include "bmp.h"
#include "minui_log.h"

//#define BMP1_DISPLAY  1
static int BMP_to_ARGB8888(const GfxBitmap *Getmap, unsigned char *out_buffer)
{
	unsigned char* pGet;
	unsigned char* pPut;
	int i;
	int width;
	int height;

	if ((!Getmap) || (!Getmap->pStart) || (!out_buffer)) {
		ui_loge("BMP_to_ARGB8888 parameter err!\n");
		return -1;
	}

	pGet = Getmap->pStart;
	pPut = out_buffer;
	width = Getmap->wWidth;
	height = Getmap->wHeight;

	pGet += Getmap->wWidth * (Getmap->wHeight-1) * 4;

	for (i = 0; i < height; i++) {
		memcpy(pPut, pGet, width*4);
		pPut += width*4;
		pGet -= width*4;
	}

	return 0;
}

static int BMP24_to_ARGB8888(const GfxBitmap *Getmap, unsigned char *out_buffer)
{
	unsigned char* pGet ;
	unsigned char* pPut ;
	int i,j;
	int width;
	int height;
	int rowsize = 0;
	unsigned char* ptemp;

	if ((!Getmap) || (!Getmap->pStart) || (!out_buffer)) {
		ui_loge("BMP24_to_ARGB8888 parameter err!\n");
		return -1;
	}

	pGet = Getmap->pStart;
	pPut = out_buffer;
	width = Getmap->wWidth;
	height = Getmap->wHeight;
	rowsize = 4 * (int)((Getmap->wWidth*24+31)/32);
	pGet += rowsize * (Getmap->wHeight - 1);

	for (i = 0; i < height; i++) {
		ptemp = pGet;
		for (j = 0; j < width; j++) {
			*(pPut++) = *ptemp++ ;
			*(pPut++) = *ptemp++;
			*(pPut++) = *ptemp++;
			*(pPut++) = 0xFF;
		}
		pGet -= rowsize;
	}

	return 0;
}

static int BMP16_to_ARGB8888(const GfxBitmap *Getmap, unsigned char *out_buffer)
{
	unsigned char* pGet ;
	unsigned char* pPut ;
	int i,j;
	int width;
	int height;
	int rowsize = 0;
	unsigned char* ptemp;

	if ((!Getmap) || (!Getmap->pStart) || (!out_buffer)) {
		ui_loge("BMP24_to_ARGB8888 parameter err!\n");
		return -1;
	}

	pGet = Getmap->pStart;
	pPut = out_buffer;
	width = Getmap->wWidth;
	height = Getmap->wHeight;
	rowsize = 4 * (int)((Getmap->wWidth*16+31)/32);
	pGet += rowsize * (Getmap->wHeight - 1);

	for (i = 0; i < height; i++) {
		ptemp = pGet;
		for (j = 0; j < width; j++) {
			*(pPut++) = (*ptemp & 0x1F) << 3;
			*(pPut++) = (((*(ptemp + 1) & 0x7) << 3) | ((*ptemp & 0xE0) >> 5)) << 2;
			*(pPut++) = ((*(ptemp + 1)  & 0xF8) >> 3) << 3;
			*(pPut++) = 0xFF;
			ptemp += 2;
		}
		pGet -= rowsize;
	}

	return 0;
}

#ifdef BMP1_DISPLAY
static int BMP1_to_ARGB8888(const GfxBitmap *Getmap, unsigned char *out_buffer)
{
	unsigned char* pGet ;
	unsigned char* pPut ;
	unsigned char *pbmpbuf = NULL;
	int i,j;
	int rowsize = 0;
	int width;
	int height;
	unsigned int usForeColor;
	unsigned int usBackColor;

	if ((!Getmap) || (!Getmap->pStart) || (!out_buffer)) {
		ui_loge("BMP1_to_ARGB8888 parameter err!\n");
		return -1;
	}

	pGet = Getmap->pStart;
	pPut = out_buffer;

	width = Getmap->wWidth;
	height = Getmap->wHeight;
	usForeColor = Getmap->fgcolor;
	usBackColor = Getmap->bgcolor;
	rowsize = 4 * (int)((Getmap->wWidth+31)/32);
	pbmpbuf = Getmap->pStart + rowsize * (Getmap->wHeight - 1);
	pGet += Getmap->wWidth * Getmap->wHeight;
	for (i = 0; i < height; i ++) {
		for (j = 0; j < width; j++) {
			if (((0x01 << (7 - (j&0x07))) & pbmpbuf[j>>3]) != 0) {
				/* it is foreground */
				*(pPut++) = usForeColor & 0xFF;
				*(pPut++) = (usForeColor>>8) & 0xFF;
				*(pPut++) = (usForeColor>>16) & 0xFF;
				*(pPut++) = 0xFF;
			} else {
				/* it is background */
				*(pPut++) = usBackColor&0xFF;
				*(pPut++) = (usBackColor>>8)&0xFF;
				*(pPut++) = (usBackColor>>16)&0xFF;
				*(pPut++) = 0xFF;
			}
		}
		pbmpbuf -= rowsize;
	}
	return 0;
}
#endif

static int BMP1_to_ARGB8(const GfxBitmap *Getmap, unsigned char *out_buffer)
{
	unsigned char* pGet ;
	unsigned char* pPut ;
	unsigned char *pbmpbuf = NULL;
	int i,j;
	int rowsize = 0;
	int width;
	int height;

	if ((!Getmap) || (!Getmap->pStart) || (!out_buffer)) {
		ui_loge("BMP1_to_ARGB8888 parameter err!\n");
		return -1;
	}
	pGet = Getmap->pStart;
	pPut = out_buffer;

	width = Getmap->wWidth;
	height = Getmap->wHeight;
	rowsize = 4 * (int)((Getmap->wWidth+31)/32);
	pbmpbuf = Getmap->pStart + rowsize * (Getmap->wHeight - 1);
	ui_logd("width=%d,heigth=%d, rowsize=%d\n",width, height, rowsize);
	pGet += Getmap->wWidth * Getmap->wHeight;
	for (i = 0; i < height; i ++) {
		for (j = 0; j < width; j++) {
			if (((0x01 << (7 - (j&0x07))) & pbmpbuf[j>>3]) != 0) {
				/* it is foreground */
				*(pPut++) = 0xff;
			} else {
				/* it is background */
				*(pPut++) = 0x0;
			}
		}
		pbmpbuf -= rowsize;
	}
	return 0;
}

int load_bmp(BmpInfo_t *pbmpinfo, unsigned char *out_buffer)
{
	int iRet = 0;
	GfxBitmap tGfxBmp;

	if (pbmpinfo == NULL) {
		ui_loge("pbmpinfo is NULL.\n");
		return -1;
	}
	ui_logi("[disp_bmp]: pbmpinfo 0x%p, Width %d, Height %d!\n",
		pbmpinfo, pbmpinfo->width, pbmpinfo->height);
	memset(&tGfxBmp, 0, sizeof(tGfxBmp));
	tGfxBmp.bgcolor = pbmpinfo->bgcolor;
	tGfxBmp.fgcolor = pbmpinfo->fgcolor;
	tGfxBmp.pStart = pbmpinfo->bmpbuf;
	tGfxBmp.wHeight = pbmpinfo->height;
	tGfxBmp.wWidth = pbmpinfo->width;
	ui_logd("pbmpinfo->bmpformat=%d\n",pbmpinfo->bmpformat);
	switch (pbmpinfo->bmpformat) {
		case 1:
#ifdef BMP1_DISPLAY
			iRet = BMP1_to_ARGB8888(&tGfxBmp, out_buffer);
#else
			iRet = BMP1_to_ARGB8(&tGfxBmp, out_buffer);
#endif
			break;
		case 16:
			iRet = BMP16_to_ARGB8888(&tGfxBmp, out_buffer);
			break;
		case 24:
			iRet = BMP24_to_ARGB8888(&tGfxBmp, out_buffer);
			break;
		case 32:
			iRet = BMP_to_ARGB8888(&tGfxBmp, out_buffer);
			break;
	}
	return iRet;
}

long load_pic_from_partition(const char *pic_name)
{
	char str[128] = {0};
	int ret = 0;
	char *env = NULL;

	if (pic_name == NULL) {
		ui_loge("wrong pic_name.\n");
		return -1;
	}

	sprintf(str, "imgread pic logo %s $loadaddr", pic_name);
	ret = run_command(str, 0);
	if (ret != 0) {
		ui_loge("run_command fail.\n");
		return -2;
	}

	sprintf(str, "%s_offset", pic_name);
	env = getenv(str);
	if (env) {
		return simple_strtoul(env, NULL, 16);
	} else {
		ui_loge("getenv fail.\n");
		return -3;
	}
}
int read_bmp(const char *filename, BITMAPINFOHEADER *pstBmpInfoHeader, unsigned char **buffer)
{
	unsigned short bfType = 0x4d42;
	BITMAPFILEHEADER stBmpFileHeader = {0};
	BITMAPINFOHEADER stBmpInfoHeader = {0};
	unsigned char *data_buffer = NULL;
	long bmp_addr;

	bmp_addr = load_pic_from_partition(filename);
	if (bmp_addr < 0) {
		ui_loge("load_pic_from_partition fail.\n");
		return -1;
	}
	bfType = le16_to_cpu(*(unsigned short *)(bmp_addr));

	if (0x4d42 != bfType) {
		ui_loge("bfType=0x%x failed\n",bfType);
		return -1;
	}

	stBmpFileHeader  = *(BITMAPFILEHEADER *)(bmp_addr + sizeof(bfType));
	stBmpInfoHeader = *(BITMAPINFOHEADER *)(bmp_addr + sizeof(bfType) + sizeof(stBmpFileHeader));

	stBmpInfoHeader.biWidth     = le32_to_cpu(stBmpInfoHeader.biWidth);
	stBmpInfoHeader.biHeight    = le32_to_cpu(stBmpInfoHeader.biHeight);
	stBmpInfoHeader.biBitCount = le16_to_cpu(stBmpInfoHeader.biBitCount);
	stBmpFileHeader.bfSize        = le32_to_cpu(stBmpFileHeader.bfSize);
	stBmpFileHeader.bfOffBits    =  le32_to_cpu(stBmpFileHeader.bfOffBits);
	data_buffer = (unsigned char *)(bmp_addr + stBmpFileHeader.bfOffBits);
	memcpy(pstBmpInfoHeader, &stBmpInfoHeader, sizeof(stBmpInfoHeader));
	*buffer = data_buffer;
	ui_logd("bfSize=%d,bfOffBits=%d, data_buffer = 0x%p\n",stBmpFileHeader.bfSize,stBmpFileHeader.bfOffBits,data_buffer);
	ui_logd("BmpHeader:biWidth=%d, biHeight=%d,biBitCount=%d\n",
		stBmpInfoHeader.biWidth, stBmpInfoHeader.biHeight,stBmpInfoHeader.biBitCount);

	return 0;
}
