/*
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * fdisk command for U-boot
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <common.h>
#include <command.h>
#include <mmc.h>

#define		BLOCK_SIZE			512
#define		BLOCK_END			0xFFFFFFFF
#define		_10MB				(10*1024*1024)
#define		_100MB				(100*1024*1024)
#define		_8_4GB				(1023*254*63)
#define     _32GB               (32*1024*254*63)
#define     _1GB_BLOCK_CNT      (1024*1024*2)

#define     MB_SIZE                 (1024*1024)	
#define		SYSTEM_PART_SIZE	    (1024)
#define		USER_DATA_PART_SIZE	    (2048)
#define		USER_DATA_PART_SIZE_BIG	(26624)
#define		CACHE_PART_SIZE		    (128)
#define     FAT_PART_MAX_SIZE       (32768)

#define     FAT_PART_BLOCK_MAX      (64*1024*1024) // 32G block count

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
int calc_unit(unsigned long long length, SDInfo sdInfo)
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

	memcpy(result, (unsigned char *)&(partInfo.block_start), 4);
	result += 4;	
	
	memcpy(result, (unsigned char *)&(partInfo.block_count), 4);
}

/////////////////////////////////////////////////////////////////
void decode_partitionInfo(unsigned char *in, PartitionInfo *partInfo)
{
	partInfo->bootable	= *in;
	partInfo->partitionId	= *(in + 4); 

	memcpy((unsigned char *)&(partInfo->block_start), (in + 8), 4);
	memcpy((unsigned char *)&(partInfo->block_count), (in +12), 4);
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

//-----------------------------------------------------
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
//-----------------------------------------------------
        else
        {
                sdInfo->C_end = 1023;
                sdInfo->H_end = 254;
                sdInfo->S_end = 63;
        }

//-----------------------------------------------------
        sdInfo->C_start                 = 0;
        sdInfo->H_start                 = 1;
        sdInfo->S_start                 = 1;

        sdInfo->total_block_count       = block_count;
        sdInfo->available_block         = sdInfo->C_end * sdInfo->H_end * sdInfo->S_end;
        sdInfo->unit                    = sdInfo->H_end * sdInfo->S_end;
}

/////////////////////////////////////////////////////////////////
void make_partitionInfo(int LBA_start, int count, SDInfo sdInfo, PartitionInfo *partInfo)
{
        int             temp = 0;
        int             _10MB_unit;

        partInfo->block_start   = LBA_start;

//-----------------------------------------------------
        if (sdInfo.addr_mode == CHS_MODE)
        {
                partInfo->C_start       = partInfo->block_start / (sdInfo.H_end * sdInfo.S_end);
                temp                    = partInfo->block_start % (sdInfo.H_end * sdInfo.S_end);
                partInfo->H_start       = temp / sdInfo.S_end;
                partInfo->S_start       = temp % sdInfo.S_end + 1;

                if (count == BLOCK_END)
                {
                        _10MB_unit = calc_unit(CFG_PARTITION_START, sdInfo);
                        partInfo->block_end     = sdInfo.C_end * sdInfo.H_end * sdInfo.S_end - _10MB_unit - 1;
                        partInfo->block_count   = partInfo->block_end - partInfo->block_start + 1;

                        partInfo->C_end = partInfo->block_end / sdInfo.unit;
                        partInfo->H_end = sdInfo.H_end - 1;
                        partInfo->S_end = sdInfo.S_end;
                }
                else
                {
                        partInfo->block_count   = count;

                        partInfo->block_end     = partInfo->block_start + count - 1;
                        partInfo->C_end         = partInfo->block_end / sdInfo.unit;

                        temp                    = partInfo->block_end % sdInfo.unit;
                        partInfo->H_end         = temp / sdInfo.S_end;
                        partInfo->S_end         = temp % sdInfo.S_end + 1;
                }
        }
//-----------------------------------------------------
        else
        {
                partInfo->C_start       = 0;
                partInfo->H_start       = 1;
                partInfo->S_start       = 1;

                partInfo->C_end         = 1023;
                partInfo->H_end         = 254;
                partInfo->S_end         = 63;

                if (count == BLOCK_END)
                {
                        _10MB_unit = calc_unit(CFG_PARTITION_START, sdInfo);
                        partInfo->block_end     = sdInfo.total_block_count - _10MB_unit - 1;
                        partInfo->block_count   = partInfo->block_end - partInfo->block_start + 1;

                }
                else
                {
                        partInfo->block_count   = count;
                        partInfo->block_end     = partInfo->block_start + count - 1;
                }
        }
}

/////////////////////////////////////////////////////////////////
#define SKIP_SYSTEM_PART    1
#define SKIP_DATA_PART      2
#define SKIP_CACHE_PART     3
#define SKIP_FAT_PART       4

int make_mmc_partition(int total_block_count, unsigned char *mbr, int flag, char *argv[])
{
	int		block_start = 0, block_offset = 0, skip_part = 0;

    unsigned long long  part_size;

	SDInfo		sdInfo;
	PartitionInfo	partInfo[4];

///////////////////////////////////////////////////////////	
	memset((unsigned char *)&sdInfo, 0x00, sizeof(SDInfo));

///////////////////////////////////////////////////////////	
	get_SDInfo(total_block_count, &sdInfo);

///////////////////////////////////////////////////////////
// 반드시 Unit단위로 먼저 계산한다.
    part_size = CFG_PARTITION_START;
	block_start = calc_unit(part_size, sdInfo);
	
	// system partition calculate
    if (flag)   {
        if(!strncmp(&argv[3][0], "-1", 2))  {
            skip_part = SKIP_SYSTEM_PART;
            part_size = 0;
        }
        else    
            part_size = (unsigned long long)simple_strtoul(argv[3], NULL, 0)*1024*1024;
    }
    else
        part_size = (unsigned long long)SYSTEM_PART_SIZE * MB_SIZE;

    if(part_size)   {
    	block_offset = calc_unit(part_size, sdInfo);
    
    	partInfo[0].bootable	= 0x00;
    	partInfo[0].partitionId	= 0x83;
    
    	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[0]);
    }
///////////////////////////////////////////////////////////	

	// data partition calculate
    if (flag)   {
        if(!strncmp(&argv[4][0], "-1", 2))  {
            skip_part = SKIP_DATA_PART;
            part_size = 0;
        }
        else
            part_size = (unsigned long long)simple_strtoul(argv[4], NULL, 0)*1024*1024;
    }
    else 
        part_size = (unsigned long long)USER_DATA_PART_SIZE * MB_SIZE;

    if(part_size)   {
    	block_start += block_offset;
    
    	block_offset = calc_unit(part_size, sdInfo);
    	
    	partInfo[1].bootable	= 0x00;
    	partInfo[1].partitionId	= 0x83;
    
    	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[1]);
    }

///////////////////////////////////////////////////////////	

	// cache partition calculate
    if (flag)   {
        if(!strncmp(&argv[5][0], "-1", 2))  {
            skip_part = SKIP_CACHE_PART;
            part_size = 0;
        }
        else
            part_size = (unsigned long long)simple_strtoul(argv[5], NULL, 0)*1024*1024;
    }
    else
        part_size = (unsigned long long)CACHE_PART_SIZE * MB_SIZE;

    if(part_size)   {
    	block_start += block_offset;
    	
    	block_offset = calc_unit(part_size, sdInfo);
    
    	partInfo[2].bootable	= 0x00;
    	partInfo[2].partitionId	= 0x83;
    
    	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[2]);
    }

///////////////////////////////////////////////////////////	

	// fat partition calculate && skip partition calculate
    if (flag == 2)   {
        if(!strncmp(&argv[6][0], "-1", 2))  {
            skip_part = SKIP_FAT_PART;
            part_size = 0;
        }
        else
            part_size = (unsigned long long)simple_strtoul(argv[6], NULL, 0)*1024*1024;

        if(part_size)   {
        	block_start += block_offset;
        	
        	block_offset = calc_unit(part_size, sdInfo);
        
        	partInfo[3].bootable	= 0x00;
        	partInfo[3].partitionId	= 0x0C;
        
        	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[3]);
        }

        if(skip_part)   {
        	block_start += block_offset;
            block_offset = BLOCK_END;
            
        	partInfo[skip_part -1].bootable	= 0x00;
    
            if(skip_part == SKIP_FAT_PART)  
            	partInfo[skip_part -1].partitionId	= 0x0C;
            else
            	partInfo[skip_part -1].partitionId	= 0x83;
    
        	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[skip_part -1]);
        }
    }
    else    {
    	block_start += block_offset;
        block_offset = BLOCK_END;
    
    	partInfo[3].bootable	= 0x00;
    	partInfo[3].partitionId	= 0x0C;
    
    	make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[3]);
    }

///////////////////////////////////////////////////////////	
	memset(mbr, 0x00, sizeof(mbr));
	mbr[510] = 0x55; mbr[511] = 0xAA;
	
	encode_partitionInfo(partInfo[0], &mbr[0x1CE]);
	encode_partitionInfo(partInfo[1], &mbr[0x1DE]);
	encode_partitionInfo(partInfo[2], &mbr[0x1EE]);
	encode_partitionInfo(partInfo[3], &mbr[0x1BE]);
	
	return 0;
}

/////////////////////////////////////////////////////////////////
int get_mmc_block_count(char *device_name)
{
	int rv;
	struct mmc *mmc;
	int block_count = 0;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);
	
	mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		printf("mmc/sd device is NOT founded.\n");
		return -1;
	}	
	
	block_count = mmc->capacity * (mmc->read_bl_len / BLOCK_SIZE);
		
//	printf("block_count = %d\n", block_count);
	return block_count;
}

/////////////////////////////////////////////////////////////////
int get_mmc_mbr(char *device_name, unsigned char *mbr)
{
	int rv;
	struct mmc *mmc;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);
	
	mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		printf("mmc/sd device is NOT founded.\n");
		return -1;
	}	
	
	rv = mmc->block_dev.block_read(dev_num, 0, 1, mbr);

	if(rv == 1)
		return 0;
	else
		return -1; 
}

/////////////////////////////////////////////////////////////////
int put_mmc_mbr(unsigned char *mbr, char *device_name)
{
	int rv;
	struct mmc *mmc;
	int dev_num, err;

	dev_num = simple_strtoul(device_name, NULL, 0);
	
	mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		printf("mmc/sd device is NOT founded.\n");
		return -1;
	}	

	rv = mmc->block_dev.block_write(dev_num, 0, 1, mbr);

	mmc->ext_csd.boot_size_multi = 0;
	err = mmc_init(mmc);
	if (err) {
		printf("Card NOT detected or Init Failed!!\n");
		return err;
	}

	if(rv == 1)
		return 0;
	else
		return -1; 
}

/////////////////////////////////////////////////////////////////
int get_mmc_part_info(char *device_name, int part_num, unsigned long long *block_start, unsigned long long *block_count, unsigned char *part_Id)
{
	int		rv;
	PartitionInfo	partInfo;
	unsigned char	mbr[512];
	
	rv = get_mmc_mbr(device_name, mbr);
	if(rv !=0)
		return -1;
				
	switch(part_num)
	{
		case 1:
			decode_partitionInfo(&mbr[0x1BE], &partInfo);
			*block_start	= partInfo.block_start;	
			*block_count	= partInfo.block_count;	
			*part_Id 	= partInfo.partitionId;	
			break;
		case 2:
			decode_partitionInfo(&mbr[0x1CE], &partInfo);
			*block_start	= partInfo.block_start;	
			*block_count	= partInfo.block_count;	
			*part_Id 	= partInfo.partitionId;	
			break;
		
		case 3:
			decode_partitionInfo(&mbr[0x1DE], &partInfo);
			*block_start	= partInfo.block_start;	
			*block_count	= partInfo.block_count;	
			*part_Id 	= partInfo.partitionId;	
			break;
		case 4:
			decode_partitionInfo(&mbr[0x1EE], &partInfo);
			*block_start	= partInfo.block_start;	
			*block_count	= partInfo.block_count;	
			*part_Id 	= partInfo.partitionId;	
			break;
		default:
			return -1;
	}	

	return 0;
}

/////////////////////////////////////////////////////////////////
int print_mmc_part_info(int argc, char *argv[])
{
	int		rv;

	PartitionInfo	partInfo[4];
	
	rv = get_mmc_part_info(argv[2], 1, &(partInfo[0].block_start), &(partInfo[0].block_count),
			&(partInfo[0].partitionId) );
	
	rv = get_mmc_part_info(argv[2], 2, &(partInfo[1].block_start), &(partInfo[1].block_count),
			&(partInfo[1].partitionId) );

	rv = get_mmc_part_info(argv[2], 3, &(partInfo[2].block_start), &(partInfo[2].block_count),
			&(partInfo[2].partitionId) );

	rv = get_mmc_part_info(argv[2], 4, &(partInfo[3].block_start), &(partInfo[3].block_count),
			&(partInfo[3].partitionId) );

	printf("\n");	
	printf("partion #    size(MB)     block start #    block count    partition_Id \n");

	if ( (partInfo[0].block_start !=0) && (partInfo[0].block_count != 0) ) 
		printf("   1        %6d         %8d        %8d          0x%.2X \n",
			(partInfo[0].block_count / 2048), partInfo[0].block_start,
			partInfo[0].block_count, partInfo[0].partitionId);
	
	if ( (partInfo[1].block_start !=0) && (partInfo[1].block_count != 0) ) 
		printf("   2        %6d         %8d        %8d          0x%.2X \n",
			(partInfo[1].block_count / 2048), partInfo[1].block_start,
			partInfo[1].block_count, partInfo[1].partitionId);
	
	if ( (partInfo[2].block_start !=0) && (partInfo[2].block_count != 0) ) 
		printf("   3        %6d         %8d        %8d          0x%.2X \n",
			(partInfo[2].block_count / 2048), partInfo[2].block_start,
			partInfo[2].block_count, partInfo[2].partitionId);

	if ( (partInfo[3].block_start !=0) && (partInfo[3].block_count != 0) ) 
		printf("   4        %6d         %8d        %8d          0x%.2X \n",
			(partInfo[3].block_count / 2048), partInfo[3].block_start,
			partInfo[3].block_count, partInfo[3].partitionId);

	return 1;
}

/////////////////////////////////////////////////////////////////
int create_mmc_fdisk(int argc, char *argv[])
{
	int		rv;
	int		total_block_count;
	unsigned char	mbr[512], is_64Gmmc = 0;

	memset(mbr, 0x00, 512);
	
	total_block_count = get_mmc_block_count(argv[2]);
	if (total_block_count < 0)
		return -1;
	
	if(argc != 6)   {
    	is_64Gmmc = (total_block_count > FAT_PART_BLOCK_MAX) ? 1 : 0;
	}
	
	if(argc == 7)   {
	    int     part_info = 0, minus_part_info = 0;
	    for(part_info = 0; part_info < 4; part_info++)  {
	        if(!strncmp(&argv[3 + part_info][0], "-1", 2))     
	            minus_part_info++;
	    }

	    if(minus_part_info == 1)
        	make_mmc_partition(total_block_count, mbr, 2, argv);    // mtp used split
        else
        	make_mmc_partition(total_block_count, mbr, 0, argv);    // default split
	}
	else    {
    	make_mmc_partition(total_block_count, mbr, (argc==6?1:0), argv);
	}

	rv = put_mmc_mbr(mbr, argv[2]);
	if (rv != 0)
		return -1;
		
	printf("fdisk is completed\n");

	argv[1][1] = 'p';
	print_mmc_part_info(argc, argv);

    if(argc != 6)	if(is_64Gmmc)   return  1;

	return 0;
}

/////////////////////////////////////////////////////////////////
int do_fdisk(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	if ( argc == 3 || argc == 6 || argc == 7 )
	{
		if ( strcmp(argv[1], "-c") == 0 )
			return create_mmc_fdisk(argc, argv);

		else if ( strcmp(argv[1], "-p") == 0 )
			return print_mmc_part_info(argc, argv);
	}
	else
	{
		printf("Usage:\nfdisk <-p> <device_num>\n");
		printf("fdisk <-c> <device_num> [<sys. part size(MB)> <user data part size> <cache part size> <fat part size>]\n");
	}
	return 0;
}

U_BOOT_CMD(
	fdisk, 7, 0, do_fdisk,
	"fdisk\t- fdisk for sd/mmc.\n",
	"-c <device_num>\t- create partition.\n"
	"fdisk -p <device_num> [<sys. part size(MB)> <user data part size> <cache part size>]\t- print partition information\n"
);

int do_check_mmc_size(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    int total_block_count = 0;
    unsigned char   mmc_size[5];
    
    // file check & update
	setenv("mmc_size_gb", "0");

	if ( argc == 2 )
	{
    	total_block_count = get_mmc_block_count(argv[1]);
    	memset(mmc_size, 0x00, sizeof(mmc_size));

        if      (total_block_count > (100 * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 128);
        else if (total_block_count > (50  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 64);
        else if (total_block_count > (30  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 32);
        else if (total_block_count > (10  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 16);
        else if (total_block_count > (5   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 8);
        else if (total_block_count > (3   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 4);
        else if (total_block_count > (1   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 2);
        else                                                    sprintf(mmc_size, "%d", 1);

    	if (total_block_count < 0)  {
    	    printf("error total block count == 0\n");
    		return -1;
    	}
        setenv("mmc_size_gb", mmc_size);
	}
	else
	{
		printf("Usage:\ncheck_mmc_size <device_num>\n");
	}
	return 0;
}

U_BOOT_CMD(
	check_mmc_size, 2, 0, do_check_mmc_size,
	"check_mmc_size\t- mmc size check for sd/mmc.\n",
	"env mmc_size_gb = 1, 2, 4, 8, 16, 32, 64, 128.\n"
	"check_mmc_size <device_num>\n"
);

int do_check_64gb(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    int total_block_count = 0;
    
    // file check & update
	setenv("is64gb", "0");

	if ( argc == 2 )
	{
    	total_block_count = get_mmc_block_count(argv[1]);

    	if (total_block_count < 0)  {
    	    printf("error total block count == 0\n");
    		return -1;
    	}
    	if(total_block_count > FAT_PART_BLOCK_MAX)
    	    printf("SD/MMC Size > 32GB\n");
    	else    
    	    printf("SD/MMC Size <= 32GB\n");

        if(total_block_count > FAT_PART_BLOCK_MAX)	
            setenv("is64gb", "1");
        else
        	setenv("is64gb", "0");
	
        return  (total_block_count > FAT_PART_BLOCK_MAX) ? 0 : 1;
	}
	else
	{
		printf("Usage:\ncheck_64gb <device_num>\n");
	}
	return 0;
}

U_BOOT_CMD(
	check_64gb, 2, 0, do_check_64gb,
	"check_64gb\t- mmc total size check for sd/mmc.\n",
	"sd/mmc 64gb return true, else false.\n"
	"check_64gb <device_num>\n"
);

int do_get_mmc_block_count(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    int total_block_count = 0;
    unsigned char   blk_size[12];
    
    // file check & update
	setenv("mmc_block_count", "0");

	if ( argc == 2 )
	{
    	total_block_count = get_mmc_block_count(argv[1]);

        memset(blk_size, 0x00, sizeof(blk_size));
        
        sprintf(blk_size, "0x%08X", total_block_count);

        setenv("mmc_block_count", blk_size);
	}
	else
	{
		printf("Usage:\nget_mmc_block_count <device_num>\n");
	}
	return 0;
}

U_BOOT_CMD(
	get_mmc_block_count, 2, 0, do_get_mmc_block_count,
	"check_mmc_block_count\t - get mmc total block count for sd/mmc.\n",
	"sd/mmc size = mmc_block_count * 512.\n"
	"check_mmc_block_count <device_num>\n"
);

int do_check_value(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    int value = 0;

	if ( argc == 2 )
	{
    	value = simple_strtoul(argv[1], NULL, 0);
	    printf("Check Value = %d\n", value);
	    
	    return  (value != 0) ? 0 : 1;
	}
	else
	{
		printf("Usage:\ncheck_value <value>\n");
	}
	return 0;
}

U_BOOT_CMD(
	check_value, 2, 0, do_check_value,
	"check_value\t- value check.\n",
	"value is 1 then return true, else return false.\n"
	"check_value <value>\n"
);
