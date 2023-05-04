/*
* Copyright (C) 2017 Amlogic, Inc. All rights reserved.
* *
This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
* *
This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
* *
You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
* *
Description:
*/

#ifndef _BMP_H_
#define _BMP_H_

typedef struct tagBITMAPFILEHEADER {
	unsigned int bfSize;
	unsigned int bfReserved1;
	unsigned int bfOffBits;
} BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER {
	unsigned int biSize;
	unsigned int biWidth;
	unsigned int biHeight;
	unsigned short biPlanes;
	unsigned short biBitCount;
	unsigned int biCompression;
	unsigned int biSizeImage;
	unsigned int biXPelsPerMeter;
	unsigned int biYPelsPerMeter;
	unsigned int biClrUsed;
	unsigned int biClrImportant;
} BITMAPINFOHEADER;

typedef struct
{
	unsigned short wWidth;  // in pixels
	unsigned short wHeight; // in pixels
	unsigned long bgcolor;  //background color, used in bmp 1
	unsigned long fgcolor;  //foreground color, used in bmp 1
	unsigned char *pStart;  // bitmap data pointer
}GfxBitmap;

typedef struct BmpInfo_t{
	unsigned int bmpformat;
	unsigned int bgcolor;
	unsigned int fgcolor;
	unsigned short width;
	unsigned short height;
	unsigned char *bmpbuf;
}BmpInfo_t, *pBmpInfo_t;

int read_bmp(const char *filename, BITMAPINFOHEADER *pstBmpInfoHeader, unsigned char **buffer);
int load_bmp(BmpInfo_t *pbmpinfo, unsigned char *out_buffer);
#endif
