/*
 * Command for img pack.
 *
 * Copyright (C) 2012 Amlogic.
 * Elvis Yu <elvis.yu@amlogic.com>
 */


#include <common.h>
#include <command.h>
#include <asm/types.h>

#define errorP(fmt...) printf("Err imgPack(L%d):", __LINE__),printf(fmt)
#define MsgP(fmt...)   printf("[ImgPck]"fmt)

#define IH_MAGIC	0x27051956	/* Image Magic Number		*/
#define IH_NMLEN		32	/* Image Name Length		*/

#define AML_RES_IMG_VERSION_V1      (0x01)
#define AML_RES_IMG_VERSION_V2      (0x02)
#define AML_RES_IMG_ITEM_ALIGN_SZ   16
#define AML_RES_IMG_VERSION         0x01
#define AML_RES_IMG_V1_MAGIC_LEN    8
#define AML_RES_IMG_V1_MAGIC        "AML_RES!"//8 chars
#define AML_RES_IMG_HEAD_SZ         (AML_RES_IMG_ITEM_ALIGN_SZ * 4)//64
#define AML_RES_ITEM_HEAD_SZ        (AML_RES_IMG_ITEM_ALIGN_SZ * 4)//64

#pragma pack(push, 1)
typedef struct pack_header{
	unsigned int 	magic;	/* Image Header Magic Number	*/
	unsigned int 	hcrc;	/* Image Header CRC Checksum	*/
	unsigned int	size;	/* Image Data Size		*/
	unsigned int	start;	/* item data offset in the image*/
	unsigned int	end;		/* Entry Point Address		*/
	unsigned int	next;	/* Next item head offset in the image*/
	unsigned int	dcrc;	/* Image Data CRC Checksum	*/
	unsigned char	index;		/* Operating System		*/
	unsigned char	nums;	/* CPU architecture		*/
	unsigned char   type;	/* Image Type			*/
	unsigned char 	comp;	/* Compression Type		*/
	char 	name[IH_NMLEN];	/* Image Name		*/
}AmlResItemHead_t;
#pragma pack(pop)

//typedef for amlogic resource image
#pragma pack(push, 4)
typedef struct {
    __u32   crc;    //crc32 value for the resouces image
    __s32   version;//current version is 0x01

    __u8    magic[AML_RES_IMG_V1_MAGIC_LEN];  //resources images magic

    __u32   imgSz;  //total image size in byte
    __u32   imgItemNum;//total item packed in the image

    __u32   alignSz;//AML_RES_IMG_ITEM_ALIGN_SZ
    __u8    reserv[AML_RES_IMG_HEAD_SZ - 8 * 3 - 4];

}AmlResImgHead_t;
#pragma pack(pop)
#define IH_MAGIC	0x27051956	/* Image Magic Number		*/
#define IH_NMLEN		32	/* Image Name Length		*/

static int _img_unpack_check_img_header(const AmlResImgHead_t* pImgHead, int* imgVersion, unsigned* imgHeadSz)
{
        int rc = 0;

        rc = memcmp(pImgHead->magic, AML_RES_IMG_V1_MAGIC, AML_RES_IMG_V1_MAGIC_LEN);
        if(rc) {
                const AmlResItemHead_t* pItemHead = (AmlResItemHead_t*)pImgHead;
                if(IH_MAGIC != pItemHead->magic){
                        errorP("magic of oldest img not item header!\n");
                        return __LINE__;
                }
                *imgVersion = 0;
                *imgHeadSz = 0;
        }
        else {
                if(AML_RES_IMG_VERSION_V2 < pImgHead->version){
                        errorP("res-img ver %d not supported\n", pImgHead->version);
                        return __LINE__;
                }
                *imgVersion = pImgHead->version;
                *imgHeadSz      = sizeof(AmlResImgHead_t);
                /*
                 *if(AML_RES_IMG_VERSION_V2 == pImgHead->version){
                 *        *imgHeadSz += pImgHead->imgItemNum * sizeof(AmlResItemHead_t);
                 *}
                 */
        }

        return 0;
}

static int do_unpackimg(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        void *addr;
        __u32 pos = 0;
        const AmlResItemHead_t *pack_header_p = NULL;
        char env_name[IH_NMLEN*2];
        char env_data[IH_NMLEN*2];
        AmlResImgHead_t* pImgHead = NULL;
        int rc = 0;
        int imgVersion = -1;

        if (argc < 2) {
                cmd_usage(cmdtp);
                return __LINE__;
        }
        addr = (void *)simple_strtoul (argv[1], NULL, 16);

        pImgHead = (AmlResImgHead_t*)addr;
        rc = _img_unpack_check_img_header(pImgHead, &imgVersion, &pos);
        if(rc){
                errorP("Err res header.\n");
                return __LINE__;
        }
        MsgP("ver=%d\n", imgVersion);

        do{
                pack_header_p = (AmlResItemHead_t*)(addr + pos);
                if(IH_MAGIC != pack_header_p->magic){
                        errorP("Item magic error.\n");
                        return __LINE__;
                }

                sprintf(env_name, "%s_offset", pack_header_p->name);
                sprintf(env_data, "0x%x", (unsigned int)(addr+pack_header_p->start));
                setenv(env_name, env_data);

                sprintf(env_name, "%s_size", pack_header_p->name);
                sprintf(env_data, "0x%x", pack_header_p->size);
                setenv(env_name, env_data);

        }while(pos = pack_header_p->next);

        return 0;
}

U_BOOT_CMD(
	unpackimg,	2,	0,	do_unpackimg,
	"unpack imgpack to single",
	"unpackimg <addr>		- open a imgpack in addr\n"
);

static int do_get_img_size(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	void *addr;
	__u32 pos;
	AmlResItemHead_t *pack_header_p;
	char env_name[IH_NMLEN*2];
	char env_data[IH_NMLEN*2];
	
	if (argc < 3)
	{
		cmd_usage(cmdtp);
		return -1;
	}
	//printf("############ do_get_img_size #############\n");
	addr = (void*)simple_strtoul (argv[1], NULL, 16);
	pos = 0;
	while(1)
	{
		pack_header_p = (AmlResItemHead_t *)(addr + pos);
		if(pack_header_p->magic != IH_MAGIC)
		{
			printf("wrong pack img!\n");
			return -1;
		}

		
		if(pack_header_p->next == 0)
		{
			sprintf(env_name, "%s", argv[2]);
			sprintf(env_data, "0x%x", pack_header_p->start + pack_header_p->size);
			setenv(env_name, env_data);
			saveenv();
			break;
		}
		else
		{
			pos = pack_header_p->next;
		}
	}
	return 0;
}

U_BOOT_CMD(
	get_img_size,	3,	0,	do_get_img_size,
	"get img size and save the result as a environment variable",
	"get_img_size <addr> <env>  - check the img in addr and save the total size to env\n"
);


