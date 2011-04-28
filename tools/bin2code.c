#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//extern bool gen_c_data(const char* szTable,const char* szbinfile,const char* szoutfile);
int main(int argc, char* argv[])
{
	if(argc != 4){
		printf(";======= help =========\n");
		printf("format: cmd <table name> <binary file> <output file>\n\n");
		return 0;
	}
	char* szTable =argv[1];
	char* szBinFile = argv[2];
	char* szOutFile = argv[3];
	char szline[512];
	FILE* fp1 = fopen(szBinFile,"rb+");
	FILE* fpout = fopen(szOutFile,"wb");
	if(fp1 == NULL || fpout == NULL)
	{
		printf("error - file open failed!\n");
	}
	else
	{
		int blocksize = 4*4;
		unsigned buff[4];
		int nreads;
		int withend = 0;
		sprintf(szline,"const unsigned %s[]={\n",szTable);
		fwrite(szline,strlen(szline),1,fpout);
		while((nreads = fread((void*)&buff,1,blocksize,fp1)) > 0)
		{
			if(nreads != blocksize)
			{
				sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x\n};\n",
					buff[0],buff[1],buff[2],buff[3]
					);
				fwrite(szline,strlen(szline),1,fpout);
				withend = 1;
			}
			else
			{
				sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x,\n",
					buff[0],buff[1],buff[2],buff[3]
					);
				fwrite(szline,strlen(szline),1,fpout);
			}
			memset((void*)buff,0,blocksize);
		}
		if(!withend)
		{
			sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x\n};\n",
					buff[0],buff[1],buff[2],buff[3]
					);
			fwrite(szline,strlen(szline),1,fpout);
		}
		printf("convert ok!\n");
	}
	if(fp1)
		fclose(fp1);
	if(fpout)
		fclose(fpout);
	fp1 = NULL;
	fpout = NULL;

/*	if(gen_c_data(lpszTable,lpszBinFile,lpszOutFile))
		printf("convert ok!\n");
	else
		printf("convert failed !!!!!!\n");
*/
	return 0;
}
/*
bool gen_c_data(char* szTable,char* szbinfile,char* szoutfile)
{
	bool bret = false;
	char szline[512];
	FILE* fp1 = fopen(szbinfile,"rb+");
	FILE* fpout = fopen(szoutfile,"wb");
	if(fp1 == NULL || fpout == NULL)
	{
		printf("error - file open failed!\n");
	}
	else
	{	
		int blocksize = 4*4;
		unsigned buff[4];
		int nreads;
		sprintf(szline,"static unsigned %s[]={\n",szTable);
		fwrite(szline,strlen(szline),1,fpout);
		bool bwithend = false;
		while((nreads = fread((void*)&buff,1,blocksize,fp1)) > 0)
		{
			if(nreads != blocksize)
			{
				sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x\n};\n",
					buff[0],buff[1],buff[2],buff[3]
					);
				fwrite(szline,strlen(szline),1,fpout);
				bwithend = true;
			}
			else
			{
				sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x,\n",
					buff[0],buff[1],buff[2],buff[3]
					);
				fwrite(szline,strlen(szline),1,fpout);
			}
			memset((void*)buff,0,blocksize);
		}
		if(!bwithend)
		{
			sprintf(szline,"\t0x%.8x , 0x%.8x , 0x%.8x , 0x%.8x\n};\n",
					buff[0],buff[1],buff[2],buff[3]
					);
			fwrite(szline,strlen(szline),1,fpout);
		}
		bret = true;
	}
	if(fp1)
		fclose(fp1);
	if(fpout)
		fclose(fpout);
	fp1 = NULL;
	fpout = NULL;
	return bret;
}
*/