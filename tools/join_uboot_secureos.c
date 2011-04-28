#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <getopt.h>

#include <config.h>

#define READ_SIZE       32*1024     // Size for data reading
#if defined(CONFIG_M8) || defined(CONFIG_M8B)
#define SECURE_OS_SRAM_BASE (512+32)
#else
#define SECURE_OS_SRAM_BASE 32
#endif
#define SECURE_OS_OFFSET_POSITION_IN_SRAM (SECURE_OS_SRAM_BASE-4)
#define SECURE_OS_SIZE_POSITION_IN_SRAM   (SECURE_OS_SRAM_BASE-4-4)

static unsigned char buf[READ_SIZE];

void record_offset(unsigned int postion)
{
	unsigned int *pbuf;
	
	pbuf = (unsigned int*)&buf[READ_SIZE-SECURE_OS_OFFSET_POSITION_IN_SRAM];
	*pbuf = postion;
}

void record_size(unsigned int securesize)
{
	unsigned int *pbuf;
	pbuf = (unsigned int*)&buf[READ_SIZE-SECURE_OS_SIZE_POSITION_IN_SRAM];
	*pbuf = securesize;
}

int main(int argc,char * argv[])
{
	FILE * fp_uboot=NULL;
	FILE * fp_out=NULL;
	FILE * fp_secure=NULL;
    char * uboot_file=NULL;
    char * secure_file=NULL;
    char * out_file=NULL;
    unsigned int uboot_file_size=0, secure_file_size=0, num,postion,securesize, count;
	if(argc < 4){
		fprintf(stderr,"File parameter too few ");
		goto exit;
	}
	uboot_file = argv[1];
	secure_file = argv[2];
	out_file = argv[3];
	fp_uboot=fopen(uboot_file,"rb");
	if(!fp_uboot ){
		fprintf(stderr,"open file %s error \n",uboot_file);
		goto exit;
	}
	fp_secure=fopen(secure_file,"rb");
	if(!fp_secure){
		fprintf(stderr,"open file %s error \n",secure_file);
		goto exit;
	}
    fseek(fp_uboot, 0, 2);
    uboot_file_size = ftell(fp_uboot);
    rewind(fp_uboot);
    fseek(fp_secure, 0, 2);
    secure_file_size=ftell(fp_secure);
    rewind(fp_secure);    
    if(uboot_file_size < READ_SIZE){
		fprintf(stderr,"uboot file is %d smaller than  %d \n",uboot_file_size,READ_SIZE);
		goto exit;
	}

	fp_out=fopen(out_file,"wb");
	if(!fp_out){
		goto exit;
	}
	postion = ((uboot_file_size+15)>>4)<<4;
	fprintf(stderr,"postion:0x%x,uboot_file_size:0x%x\n",postion,uboot_file_size);
	securesize = ((secure_file_size+15)>>4)<<4;
	fprintf(stderr,"secure_file_size=0x%x\n",securesize);
	
	memset(buf,0,sizeof(buf));
	num=fread(buf,sizeof(buf[0]),sizeof(buf)/sizeof(buf[0]),fp_uboot);
	record_offset(postion);
	record_size(securesize);	
	fwrite(buf,sizeof(buf[0]),sizeof(buf)/sizeof(buf[0]),fp_out);
	while(!feof(fp_uboot))
	{
		count=fread(buf,sizeof(buf[0]),sizeof(buf),fp_uboot);
		fwrite(buf,sizeof(buf[0]),count,fp_out);
		num += count;
	}
	if(num < postion){
		memset(buf,0,sizeof(buf));
		fwrite(buf,sizeof(buf[0]),(postion-num),fp_out);
	}
	while(!feof(fp_secure))
	{
		count=fread(buf,sizeof(buf[0]),sizeof(buf),fp_secure);
		fwrite(buf,sizeof(buf[0]),count,fp_out);
		//num += count;
	}

exit:
	if(fp_uboot){
		fclose(fp_uboot);
	}
	else{
		fprintf(stderr,"File open error %s",uboot_file);
	}
	if(fp_secure){
		fclose(fp_secure);
	}
	else{
		fprintf(stderr,"File open error %s",secure_file);
	}
	if(fp_out){
		fclose(fp_out);
	}
	else{
		fprintf(stderr,"File create error %s",out_file);
	}
	return 0;
}
