/*
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define		BLOCK_SIZE			512
#define		BLOCK_END			0xFFFFFFFF
#define		_10MB				(10*1024*1024)
#define		_100MB				(100*1024*1024)
#define		_8_4GB				(1023*254*63)

#define		CHS_MODE			0
#define		LBA_MODE			!(CHS_MODE)	

typedef struct
{
	int		C_start;
	int		H_start;
	int		S_start;

	int		C_end;
	int		H_end;
	int		S_end;

	int		available_block;
	int		unit;
	int		total_block_count;
	int		addr_mode;	// LBA_MODE or CHS_MODE
} SDInfo;

typedef struct
{
	unsigned char bootable;
	unsigned char partitionId;

	int		C_start;
	int		H_start;
	int		S_start;

	int		C_end;
	int		H_end;
	int		S_end;

	int		block_start;
	int		block_count;
	int		block_end;
} PartitionInfo;

/////////////////////////////////////////////////////////////////
int calc_unit(int length, SDInfo sdInfo)
{
	if (sdInfo.addr_mode == CHS_MODE)
		return ( (length / BLOCK_SIZE / sdInfo.unit + 1 ) * sdInfo.unit);

	else
		return ( (length / BLOCK_SIZE) );
}

/////////////////////////////////////////////////////////////////
void encode_chs(int C, int H, int S, unsigned char *result)
{
	*result++ = (unsigned char) H;
	*result++ = (unsigned char) ( S + ((C & 0x00000300) >> 2) );
	*result   = (unsigned char) (C & 0x000000FF); 
}

/////////////////////////////////////////////////////////////////
void encode_partitionInfo(PartitionInfo partInfo, unsigned char *result)
{
	*result++ = partInfo.bootable;

	encode_chs(partInfo.C_start, partInfo.H_start, partInfo.S_start, result);
	result +=3;

	*result++ = partInfo.partitionId;

	encode_chs(partInfo.C_end, partInfo.H_end, partInfo.S_end, result);
	result += 3;

	*((int *)result) = partInfo.block_start;
	result += 4;	
	
	*((int *)result) = partInfo.block_count;
}

/////////////////////////////////////////////////////////////////
void get_SDInfo(int block_count, SDInfo *sdInfo)
{
	int C, H, S;

	int C_max = 1023, H_max = 255, S_max = 63;
	int H_start = 1, S_start = 1;
	int diff_min = 0, diff = 0;
	
	if(block_count >= _8_4GB)
		sdInfo->addr_mode = LBA_MODE;
	else
		sdInfo->addr_mode = CHS_MODE;

	if (sdInfo->addr_mode == CHS_MODE)
	{
		diff_min = C_max;

		for (H = H_start; H <= H_max; H++)
			for (S  = S_start; S <= S_max; S++)
			{
				C = block_count / (H * S);

				if ( (C <= C_max) )
				{
					diff = C_max - C;
					if (diff <= diff_min)
					{
						diff_min = diff;
						sdInfo->C_end = C;
						sdInfo->H_end = H;
						sdInfo->S_end = S;
					}
				}
			}
	}
	else
	{
		sdInfo->C_end = 1023;
		sdInfo->H_end = 254;
		sdInfo->S_end = 63;
	}

	sdInfo->C_start			= 0;
	sdInfo->H_start			= 1;
	sdInfo->S_start			= 1;

	sdInfo->total_block_count	= block_count;
	sdInfo->available_block		= sdInfo->C_end * sdInfo->H_end * sdInfo->S_end;
	sdInfo->unit			= sdInfo->H_end * sdInfo->S_end;
}

/////////////////////////////////////////////////////////////////
void make_partitionInfo(int LBA_start, int count, SDInfo sdInfo, PartitionInfo *partInfo)
{
	int		temp = 0;
	int		_10MB_unit;
	
	partInfo->block_start	= LBA_start;

	if (sdInfo.addr_mode == CHS_MODE)
	{
		partInfo->C_start	= partInfo->block_start / (sdInfo.H_end * sdInfo.S_end);
		temp			= partInfo->block_start % (sdInfo.H_end * sdInfo.S_end);
		partInfo->H_start	= temp / sdInfo.S_end;
		partInfo->S_start	= temp % sdInfo.S_end + 1;

		if (count == BLOCK_END)
		{
			_10MB_unit = calc_unit(_10MB, sdInfo);
			partInfo->block_end	= sdInfo.C_end * sdInfo.H_end * sdInfo.S_end - _10MB_unit - 1;
			partInfo->block_count	= partInfo->block_end - partInfo->block_start + 1;
	
			partInfo->C_end	= partInfo->block_end / sdInfo.unit;
			partInfo->H_end = sdInfo.H_end - 1;
			partInfo->S_end = sdInfo.S_end;
		}
		else
		{
			partInfo->block_count	= count;
	
			partInfo->block_end	= partInfo->block_start + count - 1;
			partInfo->C_end		= partInfo->block_end / sdInfo.unit;
	
			temp			= partInfo->block_end % sdInfo.unit;
			partInfo->H_end		= temp / sdInfo.S_end;
			partInfo->S_end		= temp % sdInfo.S_end + 1;
		}
	}
	else
	{
		partInfo->C_start	= 0;
		partInfo->H_start	= 1;
		partInfo->S_start	= 1;

		partInfo->C_end		= 1023;
		partInfo->H_end		= 254;
		partInfo->S_end		= 63;
	
		if (count == BLOCK_END)
		{
			_10MB_unit = calc_unit(_10MB, sdInfo);
			partInfo->block_end	= sdInfo.total_block_count - _10MB_unit - 1;
			partInfo->block_count	= partInfo->block_end - partInfo->block_start + 1;

		}
		else
		{
			partInfo->block_count	= count;
			partInfo->block_end	= partInfo->block_start + count - 1;
		}
	}
}

/////////////////////////////////////////////////////////////////
int get_sd_block_count(char *devicefile)
{
	FILE	*fp;
	char	buf[128];

	int	block_count = 0;
	int	nbytes = 0;

	char *t = "/sys/block/";
	char sd_size_file[64];

	strcpy(sd_size_file, t);
	strcat(sd_size_file, &devicefile[5]);
	strcat(sd_size_file, "/size");

	fp = fopen(sd_size_file, "rb");
	nbytes = fread(buf, 1, 128, fp);
	fclose(fp);

	block_count = atoi(buf);
	
	return block_count;
} 


/////////////////////////////////////////////////////////////////
int main(int argc, char *argv[])
{
	FILE		*fp;

	int		total_block_count;
	int		block_start = 0, block_offset = 0;

	SDInfo		sdInfo;
	PartitionInfo	partInfo[4];

	unsigned char	mbr[512];

	if (argc != 2)
	{
		printf("Usage: sd_fdisk <device_file>\n");
		return -1;
	}
///////////////////////////////////////////////////////////	
	memset((unsigned char *)&sdInfo, 0x00, sizeof(SDInfo));

///////////////////////////////////////////////////////////	
	total_block_count = get_sd_block_count(argv[1]);
	get_SDInfo(total_block_count, &sdInfo);
/*
///////////////////////////////////////////////////////////
// 반드시 Unit단위로 먼저 계산한다.
	block_start	= calc_unit(_10MB, sdInfo);
	block_offset	= calc_unit(_100MB, sdInfo);

///////////////////////////////////////////////////////////	
	partInfo[0].bootable	= 0x00;
	partInfo[0].partitionId	= 0x83;

	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[0]);

///////////////////////////////////////////////////////////	
	block_start += block_offset;
	
	partInfo[1].bootable	= 0x00;
	partInfo[1].partitionId	= 0x83;

	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[1]);

///////////////////////////////////////////////////////////	
	block_start += block_offset;
	partInfo[2].bootable	= 0x00;
	partInfo[2].partitionId	= 0x83;

	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[2]);
*/
///////////////////////////////////////////////////////////	
//	block_start += block_offset;
	block_start = calc_unit(_10MB, sdInfo);

	block_offset += BLOCK_END;
	partInfo[3].bootable	= 0x00;
	partInfo[3].partitionId	= 0x0C;

	make_partitionInfo(block_start, BLOCK_END, sdInfo, &partInfo[3]);

///////////////////////////////////////////////////////////	
	memset(mbr, 0x00, sizeof(mbr));
	mbr[510] = 0x55; mbr[511] = 0xAA;

//	encode_partitionInfo(partInfo[0], &mbr[0x1CE]);
//	encode_partitionInfo(partInfo[1], &mbr[0x1DE]);
//	encode_partitionInfo(partInfo[2], &mbr[0x1EE]);
	encode_partitionInfo(partInfo[3], &mbr[0x1BE]);
	
	fp = fopen("sd_mbr.dat", "wb");
	fwrite(mbr, 1, sizeof(mbr), fp);
	fclose(fp);

	return 0;
}

