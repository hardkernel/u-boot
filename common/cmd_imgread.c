/*
 * \file        cmd_imgread.c
 * \brief       command to read the actual size of boot.img/recovery.img and logo.img
 *
 * \version     1.0.0
 * \date        2013/10/29
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic Inc.. All Rights Reserved.
 *
 */
#include <config.h>
#include <common.h>
#include <amlogic/storage_if.h>
#include <image.h>
#include <android_image.h>
#include <asm/arch/bl31_apis.h>
#include <asm/arch/secure_apb.h>
#include <libfdt.h>

typedef struct andr_img_hdr boot_img_hdr;

#define debugP(fmt...) //printf("[Dbg imgread]L%d:", __LINE__),printf(fmt)
#define errorP(fmt...) printf("Err imgread(L%d):", __LINE__),printf(fmt)
#define wrnP(fmt...)   printf("wrn:"fmt)
#define MsgP(fmt...)   printf("[imgread]"fmt)

#define IMG_PRELOAD_SZ  (1U<<20) //Total read 1M at first to read the image header
#define PIC_PRELOAD_SZ  (8U<<10) //Total read 4k at first to read the image header
#define RES_OLD_FMT_READ_SZ (8U<<20)

typedef struct __aml_enc_blk{
        unsigned int  nOffset;
        unsigned int  nRawLength;
        unsigned int  nSigLength;
        unsigned int  nAlignment;
        unsigned int  nTotalLength;
        unsigned char szPad[12];
        unsigned char szSHA2IMG[32];
        unsigned char szSHA2KeyID[32];
}t_aml_enc_blk;

#define AML_SECU_BOOT_IMG_HDR_MAGIC        "AMLSECU!"
#define AML_SECU_BOOT_IMG_HDR_MAGIC_SIZE   (8)
#define AML_SECU_BOOT_IMG_HDR_VESRION      (0x0905)

typedef struct {

        unsigned char magic[AML_SECU_BOOT_IMG_HDR_MAGIC_SIZE];//magic to identify whether it is a encrypted boot image

        unsigned int  version;                  //ersion for this header struct
        unsigned int  nBlkCnt;

        unsigned char szTimeStamp[16];

        t_aml_enc_blk   amlKernel;
        t_aml_enc_blk   amlRamdisk;
        t_aml_enc_blk   amlDTB;

}AmlEncryptBootImgInfo;

typedef struct _boot_img_hdr_secure_boot
{
    unsigned char           reserve4ImgHdr[1024];

    AmlEncryptBootImgInfo   encrypteImgInfo;

}AmlSecureBootImgHeader;

typedef struct{
    unsigned char           reserve4ImgHdr[2048];

    AmlEncryptBootImgInfo   encrypteImgInfo;

}AmlSecureBootImg9Header;


#define COMPILE_TYPE_ASSERT(expr, t)       typedef char t[(expr) ? 1 : -1]
COMPILE_TYPE_ASSERT(2048 >= sizeof(AmlSecureBootImgHeader), _cc);

static int is_secure_boot_enabled(void)
{
    const unsigned long cfg10 = readl(AO_SEC_SD_CFG10);
    return ( cfg10 & (0x1<< 4) );
}

static int is_andr_9_image(void* pBuffer)
{
    int nReturn = 0;

	if (!pBuffer)
        goto exit;

    struct andr_img_hdr *pAHdr = (struct andr_img_hdr*)(unsigned long)pBuffer;

	if (pAHdr->kernel_version)
        nReturn = 1;

exit:

    return nReturn;
}

typedef struct {
uint32_t magic;
uint32_t version;
uint32_t flags;
uint32_t img_version;
uint32_t img_size;
uint32_t img_offset;
uint8_t img_hash[32];
uint8_t reserved[200];
uint8_t rsa_sig[256];
} aml_boot_header_t;

static int _aml_get_secure_boot_kernel_size(const void* pLoadaddr, unsigned* pTotalEncKernelSz)
{
    const AmlEncryptBootImgInfo*  amlEncrypteBootimgInfo = 0;
    int rc = 0;
    unsigned secureKernelImgSz = 2048;
    unsigned int nBlkCnt = 0;
    const t_aml_enc_blk* pBlkInf = NULL;
    unsigned char *pAndHead = (unsigned char *)pLoadaddr;
    unsigned int isSecure = is_secure_boot_enabled();

    rc = __LINE__;

	if (!pLoadaddr || !pTotalEncKernelSz)
        return rc;

	if (isSecure)
    {
        ulong nCheckOffset;
        nCheckOffset = aml_sec_boot_check(AML_D_Q_IMG_SIG_HDR_SIZE,GXB_IMG_LOAD_ADDR,GXB_EFUSE_PATTERN_SIZE,GXB_IMG_DEC_ALL);
		if (AML_D_Q_IMG_SIG_HDR_SIZE == (nCheckOffset & 0xFFFF) &&
            ((nCheckOffset>>16) & 0xFFFF))
        {
            *pTotalEncKernelSz = (((aml_boot_header_t *)pLoadaddr)->img_size);
            return 0;
        }
    }

	if (is_andr_9_image(pAndHead))
    {
        secureKernelImgSz = 4096;
    }

    amlEncrypteBootimgInfo = (AmlEncryptBootImgInfo*)(pAndHead + (secureKernelImgSz>>1));

    nBlkCnt = amlEncrypteBootimgInfo->nBlkCnt;

    *pTotalEncKernelSz = 0;

    rc = memcmp(AML_SECU_BOOT_IMG_HDR_MAGIC, amlEncrypteBootimgInfo->magic, AML_SECU_BOOT_IMG_HDR_MAGIC_SIZE);
    if (rc) { // img NOT singed
        if (isSecure) {
            errorP("img NOT signed but secure boot enabled\n");
            return __LINE__;
        }
        *pTotalEncKernelSz = 0;
        return 0;
    } else { //img signed
            if (!isSecure) {
                    errorP("Img signed but secure boot NOT enabled\n");
                    return __LINE__;
            }
    }
    if (AML_SECU_BOOT_IMG_HDR_VESRION != amlEncrypteBootimgInfo->version) {
            errorP("magic ok but version err, err ver=0x%x\n", amlEncrypteBootimgInfo->version);
            return __LINE__;
    }
    MsgP("szTimeStamp[%s]\n", (char*)&amlEncrypteBootimgInfo->szTimeStamp);
    debugP("nBlkCnt=%d\n", nBlkCnt);

    for (pBlkInf = &amlEncrypteBootimgInfo->amlKernel;nBlkCnt--; ++pBlkInf)
    {
            const unsigned int thisBlkLen = pBlkInf->nTotalLength;
            debugP("thisBlkLen=0x%x\n", thisBlkLen);
            secureKernelImgSz += thisBlkLen;
    }

    *pTotalEncKernelSz = secureKernelImgSz;
    return 0;
}


static int do_image_read_dtb(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    boot_img_hdr *hdr_addr = NULL;
    const char* const partName = argv[1];
    unsigned char* loadaddr = 0;
    int nReturn = __LINE__;
    uint64_t lflashReadOff = 0;
    unsigned int nFlashLoadLen = 0;
    unsigned secureKernelImgSz = 0;
    const int preloadSz = 4096;

    if (2 < argc) {
        loadaddr = (unsigned char*)simple_strtoul(argv[2], NULL, 16);
    }
    else{
        loadaddr = (unsigned char*)simple_strtoul(getenv("loadaddr"), NULL, 16);
    }

    hdr_addr = (boot_img_hdr*)loadaddr;

    if (3 < argc) lflashReadOff = simple_strtoull(argv[3], NULL, 0) ;

    nFlashLoadLen = preloadSz;//head info is one page size == 2k
    debugP("sizeof preloadSz=%u\n", nFlashLoadLen);
    nReturn = store_read_ops((unsigned char*)partName, loadaddr, lflashReadOff, nFlashLoadLen );
    if (nReturn) {
        errorP("Fail to read 0x%xB from part[%s] at offset 0\n", nFlashLoadLen, partName);
        return __LINE__;
    }

    if (IMAGE_FORMAT_ANDROID != genimg_get_format(hdr_addr)) {
        errorP("Fmt unsupported! only support 0x%x\n", IMAGE_FORMAT_ANDROID);
        return __LINE__;
    }

    nReturn = _aml_get_secure_boot_kernel_size(loadaddr, &secureKernelImgSz);
    if (nReturn) {
        errorP("Fail in _aml_get_secure_boot_kernel_size, rc=%d\n", nReturn);
        return __LINE__;
    }

    const int pageSz = hdr_addr->page_size;
    /*lflashReadOff += secureKernelImgSz ? sizeof(AmlSecureBootImgHeader) : pageSz;*/
    lflashReadOff += pageSz;
    lflashReadOff += ALIGN(hdr_addr->kernel_size, pageSz);
    lflashReadOff += ALIGN(hdr_addr->ramdisk_size, pageSz);
    nFlashLoadLen  = ALIGN(hdr_addr->second_size, pageSz);

    debugP("lflashReadOff=0x%llx, nFlashLoadLen=0x%x\n", lflashReadOff, nFlashLoadLen);
    debugP("page sz %u\n", hdr_addr->page_size);
    if (!nFlashLoadLen) {
        errorP("NO second part in kernel image\n");
        return __LINE__;
    }
    unsigned char* dtImgAddr = (unsigned char*)loadaddr + lflashReadOff;
    nReturn = store_read_ops((unsigned char*)partName, dtImgAddr, lflashReadOff, nFlashLoadLen);
    if (nReturn) {
        errorP("Fail to read 0x%xB from part[%s] at offset 0x%x\n", nFlashLoadLen, partName, (unsigned int)lflashReadOff);
        return __LINE__;
    }

    if (secureKernelImgSz) {
        //because secure boot will use DMA which need disable MMU temp
        //here must update the cache, otherwise nand will fail (eMMC is OK)
        flush_cache((unsigned long)dtImgAddr,(unsigned long)nFlashLoadLen);

        nReturn = aml_sec_boot_check(AML_D_P_IMG_DECRYPT,(unsigned long)loadaddr,GXB_IMG_SIZE,GXB_IMG_DEC_DTB);
        if (nReturn) {
            errorP("\n[dtb]aml log : Sig Check is %d\n",nReturn);
            return __LINE__;
        }
        MsgP("Enc dtb sz 0x%x\n", nFlashLoadLen);
    }

    char* dtDestAddr = (char*)loadaddr;//simple_strtoull(getenv("dtb_mem_addr"), NULL, 0);
    unsigned long fdtAddr = (unsigned long)dtImgAddr;
#ifdef CONFIG_MULTI_DTB
    extern unsigned long get_multi_dt_entry(unsigned long fdt_addr);
    fdtAddr = get_multi_dt_entry((unsigned long)dtImgAddr);
    if (!fdtAddr) {
        errorP("Fail in fdt chk\n");
        return __LINE__;
    }
#endif// #ifdef CONFIG_MULTI_DTB
    nReturn = fdt_check_header((char*)fdtAddr);
    if (nReturn) {
        errorP("Fail in fdt check header\n");
        return CMD_RET_FAILURE;
    }
    const unsigned fdtsz    = fdt_totalsize((char*)fdtAddr);
    memmove(dtDestAddr, (char*)fdtAddr, fdtsz);

    return nReturn;
}


static int do_image_read_kernel(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    unsigned    kernel_size;
    unsigned    ramdisk_size;
    boot_img_hdr *hdr_addr = NULL;
    int genFmt = 0;
    unsigned actualBootImgSz = 0;
    unsigned dtbSz = 0;
    const char* const partName = argv[1];
    unsigned char* loadaddr = 0;
    int rc = 0;
    uint64_t flashReadOff = 0;
    unsigned secureKernelImgSz = 0;

    if (2 < argc) {
        loadaddr = (unsigned char*)simple_strtoul(argv[2], NULL, 16);
    }
    else{
        loadaddr = (unsigned char*)simple_strtoul(getenv("loadaddr"), NULL, 16);
    }

    ulong nCheckOffset;
    nCheckOffset = aml_sec_boot_check(AML_D_Q_IMG_SIG_HDR_SIZE,GXB_IMG_LOAD_ADDR,GXB_EFUSE_PATTERN_SIZE,GXB_IMG_DEC_ALL);
	if (AML_D_Q_IMG_SIG_HDR_SIZE == (nCheckOffset & 0xFFFF))
        nCheckOffset = (nCheckOffset >> 16) & 0xFFFF;
    else
        nCheckOffset = 0;

    hdr_addr = (boot_img_hdr*)(loadaddr + nCheckOffset);

    if (3 < argc) flashReadOff = simple_strtoull(argv[3], NULL, 0) ;

    rc = store_read_ops((unsigned char*)partName, loadaddr, flashReadOff, IMG_PRELOAD_SZ);
    if (rc) {
        errorP("Fail to read 0x%xB from part[%s] at offset 0\n", IMG_PRELOAD_SZ, partName);
        return __LINE__;
    }
    flashReadOff += IMG_PRELOAD_SZ;

	if (!nCheckOffset)
    {
        genFmt = genimg_get_format(hdr_addr);
	    if (IMAGE_FORMAT_ANDROID != genFmt) {
            errorP("Fmt unsupported!genFmt 0x%x != 0x%x\n", genFmt, IMAGE_FORMAT_ANDROID);
            return __LINE__;
        }
    }

    //Check if encrypted image
    rc = _aml_get_secure_boot_kernel_size(loadaddr, &secureKernelImgSz);
    if (rc) {
            errorP("Fail in _aml_get_secure_boot_kernel_size, rc=%d\n", rc);
            return __LINE__;
    }
    if (secureKernelImgSz)
    {
        actualBootImgSz = secureKernelImgSz + nCheckOffset;
        MsgP("secureKernelImgSz=0x%x\n", actualBootImgSz);
    }
    else
    {
        kernel_size     =(hdr_addr->kernel_size + (hdr_addr->page_size-1)+hdr_addr->page_size)&(~(hdr_addr->page_size -1));
        ramdisk_size    =(hdr_addr->ramdisk_size + (hdr_addr->page_size-1))&(~(hdr_addr->page_size -1));
        dtbSz           = hdr_addr->second_size;
        actualBootImgSz = kernel_size + ramdisk_size + dtbSz;
        debugP("kernel_size 0x%x, page_size 0x%x, totalSz 0x%x\n", hdr_addr->kernel_size, hdr_addr->page_size, kernel_size);
        debugP("ramdisk_size 0x%x, totalSz 0x%x\n", hdr_addr->ramdisk_size, ramdisk_size);
        debugP("dtbSz 0x%x, Total actualBootImgSz 0x%x\n", dtbSz, actualBootImgSz);
    }

    if (actualBootImgSz > IMG_PRELOAD_SZ)
    {
        const unsigned leftSz = actualBootImgSz - IMG_PRELOAD_SZ;

        debugP("Left sz 0x%x\n", leftSz);
        rc = store_read_ops((unsigned char*)partName, loadaddr + IMG_PRELOAD_SZ, flashReadOff, leftSz);
        if (rc) {
            errorP("Fail to read 0x%xB from part[%s] at offset 0x%x\n", leftSz, partName, IMG_PRELOAD_SZ);
            return __LINE__;
        }
    }
    debugP("totalSz=0x%x\n", actualBootImgSz);

    //because secure boot will use DMA which need disable MMU temp
    //here must update the cache, otherwise nand will fail (eMMC is OK)
    flush_cache((unsigned long)loadaddr,(unsigned long)actualBootImgSz);

    return 0;
}

#define AML_RES_IMG_VERSION_V1      (0x01)
#define AML_RES_IMG_VERSION_V2      (0x02)
#define AML_RES_IMG_V1_MAGIC_LEN    8
#define AML_RES_IMG_V1_MAGIC        "AML_RES!"//8 chars
#define AML_RES_IMG_ITEM_ALIGN_SZ   16
#define AML_RES_IMG_HEAD_SZ         (AML_RES_IMG_ITEM_ALIGN_SZ * 4)//64
#define AML_RES_ITEM_HEAD_SZ        (AML_RES_IMG_ITEM_ALIGN_SZ * 4)//64

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

#define LOGO_OLD_FMT_READ_SZ (8U<<20)//if logo format old, read 8M

static int img_res_check_log_header(const AmlResImgHead_t* pResImgHead)
{
    int rc = 0;

    rc = memcmp(pResImgHead->magic, AML_RES_IMG_V1_MAGIC, AML_RES_IMG_V1_MAGIC_LEN);
    if (rc) {
        debugP("Magic error for res\n");
        return 1;
    }
    if (AML_RES_IMG_VERSION_V2 != pResImgHead->version) {
        errorP("res version 0x%x != 0x%x\n", pResImgHead->version, AML_RES_IMG_VERSION_V2);
        return 2;
    }

    return 0;
}

static int do_image_read_res(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    const char* const partName = argv[1];
    unsigned char* loadaddr = 0;
    int rc = 0;
    AmlResImgHead_t* pResImgHead = NULL;
    unsigned totalSz    = 0;
    uint64_t flashReadOff = 0;

    if (2 < argc) {
        loadaddr = (unsigned char*)simple_strtoul(argv[2], NULL, 16);
    }
    else{
        loadaddr = (unsigned char*)simple_strtoul(getenv("loadaddr"), NULL, 16);
    }
    pResImgHead = (AmlResImgHead_t*)loadaddr;

    rc = store_read_ops((unsigned char*)partName, loadaddr, flashReadOff, IMG_PRELOAD_SZ);
    if (rc) {
        errorP("Fail to read 0x%xB from part[%s] at offset 0\n", IMG_PRELOAD_SZ, partName);
        return __LINE__;
    }
    flashReadOff = IMG_PRELOAD_SZ;

    if (img_res_check_log_header(pResImgHead)) {
        errorP("Logo header err.\n");
        return __LINE__;
    }

    //Read the actual size of the new version res imgae
    totalSz = pResImgHead->imgSz;
    if (totalSz > IMG_PRELOAD_SZ )
    {
        const unsigned leftSz = totalSz - flashReadOff;

        rc = store_read_ops((unsigned char*)partName, loadaddr + (unsigned)flashReadOff, flashReadOff, leftSz);
        if (rc) {
            errorP("Fail to read 0x%xB from part[%s] at offset 0x%x\n", leftSz, partName, IMG_PRELOAD_SZ);
            return __LINE__;
        }
    }
    debugP("totalSz=0x%x\n", totalSz);

    return 0;
}

#define IH_MAGIC	0x27051956	/* Image Magic Number		*/
#define IH_NMLEN		32	/* Image Name Length		*/

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

#define CONFIG_MAX_PIC_LEN (12 << 20)
static const unsigned char gzip_magic[] = { 0x1f, 0x8b };

//uncompress known format for 'imgread pic'
static int imgread_uncomp_pic(unsigned char* srcAddr, const unsigned srcSz,
        unsigned char* dstAddr, const unsigned dstBufSz, unsigned long* dstDatSz)
{
    /*debugP("srcAddr[%x, %x]\n", srcAddr[0], srcAddr[1]);*/
    if (!memcmp(srcAddr, gzip_magic, sizeof(gzip_magic)))
    {
        *dstDatSz = srcSz;
        return gunzip(dstAddr, dstBufSz, srcAddr, dstDatSz);
    }

    return 0;
}

//[imgread pic] logo bootup $loadaddr_misc
static int do_image_read_pic(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    const char* const partName = argv[1];
    unsigned char* loadaddr = 0;
    int rc = 0;
    const AmlResImgHead_t* pResImgHead = NULL;
    //unsigned totalSz    = 0;
    uint64_t flashReadOff = 0;
    const unsigned PreloadSz = PIC_PRELOAD_SZ;//preload 8k, 124-1 pic header, If you need pack more than 123 items,  fix this
    unsigned itemIndex = 0;
    const AmlResItemHead_t* pItem = NULL;
    const char* picName = argv[2];

    loadaddr = (unsigned char*)simple_strtoul(argc > 3 ? argv[3] : getenv("loadaddr_misc"), NULL, 16);

    pResImgHead = (AmlResImgHead_t*)loadaddr;

    debugP("to read pic (%s)\n", picName);
    rc = store_read_ops((unsigned char*)partName, loadaddr, flashReadOff, PreloadSz);
    if (rc) {
        errorP("Fail to read 0x%xB from part[%s] at offset 0\n", PreloadSz, partName);
        return __LINE__;
    }
    flashReadOff = PreloadSz;
    debugP("end read pic sz %d\n", PreloadSz);

    if (img_res_check_log_header(pResImgHead)) {
        errorP("Logo header err.\n");
        return __LINE__;
    }

    //correct bootup for mbox
    while (!strcmp("bootup", picName))
    {
            char* outputmode = getenv("outputmode");
            if (!outputmode)break;//not env outputmode

            rc = !strncmp("720", outputmode, 3) || !strncmp("576", outputmode, 3) || !strncmp("480", outputmode, 3);
            if (rc) {
                    picName = "bootup_720";
                    break;
            }

            picName = "bootup_1080";
            break;
    }

    pItem = (AmlResItemHead_t*)(pResImgHead + 1);
    for (itemIndex = 0; itemIndex < pResImgHead->imgItemNum; ++itemIndex, ++pItem)
    {
            if (IH_MAGIC != pItem->magic) {
                    errorP("item magic 0x%x != 0x%x\n", pItem->magic, IH_MAGIC);
                    return __LINE__;
            }
            if (!strcmp(picName, pItem->name) || !strcmp(argv[2], pItem->name))
            {
                    char env_name[IH_NMLEN*2];
                    char env_data[IH_NMLEN*2];
                    unsigned long picLoadAddr = (unsigned long)loadaddr + (unsigned)pItem->start;
                    int         itemSz      = pItem->size;
                    int         uncompSz    = 0;

                    if (pItem->start + itemSz > flashReadOff)
                    {
                        unsigned long rdOff = pItem->start;
                        unsigned long rdOffAlign = (rdOff >> 11) << 11;//align 2k page for mtd nand, 512 for emmc
                        rc = store_read_ops((unsigned char*)partName, (unsigned char *)((picLoadAddr>>11)<<11),
                                rdOffAlign, itemSz + (rdOff & 0x7ff) );
                        if (rc) {
                            errorP("Fail to read pic at offset 0x%x\n", pItem->start);
                            return __LINE__;
                        }
                        debugP("pic sz 0x%x\n", itemSz);
                    }

                    //uncompress supported format
                    unsigned long uncompLoadaddr = picLoadAddr + itemSz + 7;
                    uncompLoadaddr &= ~(0x7U);
                    rc = imgread_uncomp_pic((unsigned char*)picLoadAddr, itemSz, (unsigned char*)uncompLoadaddr,
                            CONFIG_MAX_PIC_LEN, (unsigned long*)&uncompSz);
                    if (rc) {
                        errorP("Fail in uncomp pic,rc[%d]\n", rc);
                        return __LINE__;
                    }
                    if (uncompSz) {
                        itemSz      = uncompSz;
                        picLoadAddr = uncompLoadaddr;
                    }

                    sprintf(env_name, "%s_offset", argv[2]);//be bootup_offset ,not bootup_720_offset
                    sprintf(env_data, "0x%lx", picLoadAddr);
                    setenv(env_name, env_data);

                    sprintf(env_name, "%s_size", argv[2]);
                    sprintf(env_data, "0x%x", itemSz);
                    setenv(env_name, env_data);

                    debugP("end read pic[%s]\n", picName);
                    return 0;//success
            }
    }

    return __LINE__;//fail
}

static cmd_tbl_t cmd_imgread_sub[] = {
    U_BOOT_CMD_MKENT(kernel, 4, 0, do_image_read_kernel, "", ""),
    U_BOOT_CMD_MKENT(dtb,    4, 0, do_image_read_dtb, "", ""),
    U_BOOT_CMD_MKENT(res,    3, 0, do_image_read_res, "", ""),
    U_BOOT_CMD_MKENT(pic,    4, 0, do_image_read_pic, "", ""),
};

static int do_image_read(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_imgread_sub[0], ARRAY_SIZE(cmd_imgread_sub));

	if (c) {
		return	c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
   imgread,         //command name
   5,               //maxargs
   0,               //repeatable
   do_image_read,   //command function
   "Read the image from internal flash with actual size",           //description
   "    argv: <imageType> <part_name> <loadaddr> \n"   //usage
   "    - <image_type> Current support is kernel/res(ource).\n"
   "imgread kernel  --- Read image in fomart IMAGE_FORMAT_ANDROID\n"
   "imgread dtb     --- Read dtb in fomart IMAGE_FORMAT_ANDROID\n"
   "imgread res     --- Read image packed by 'Amlogic resource packer'\n"
   "imgread picture --- Read one picture from Amlogic logo"
   "    - e.g. \n"
   "        to read boot.img     from part boot     from flash: <imgread kernel boot loadaddr> \n"   //usage
   "        to read recovery.img from part recovery from flash: <imgread kernel recovery loadaddr $offset> \n"   //usage
   "        to read logo.img     from part logo     from flash: <imgread res    logo loadaddr> \n"   //usage
   "        to read one picture named 'bootup' from logo.img    from logo: <imgread pic logo bootup loadaddr> \n"   //usage
);

//[imgread pic] logo bootup $loadaddr_misc
static int do_unpackimg(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    unsigned char* loadaddr = 0;
    const AmlResImgHead_t* pResImgHead = NULL;
    unsigned itemIndex = 0;
    const AmlResItemHead_t* pItem = NULL;

    loadaddr = (unsigned char*)simple_strtoul(argc > 1 ? argv[1] : getenv("loadaddr_misc"), NULL, 16);

    pResImgHead = (AmlResImgHead_t*)loadaddr;

    if (img_res_check_log_header(pResImgHead)) {
        errorP("Logo header err.\n");
        return __LINE__;
    }

    pItem = (AmlResItemHead_t*)(pResImgHead + 1);
    for (itemIndex = 0; itemIndex < pResImgHead->imgItemNum; ++itemIndex, ++pItem)
    {
        if (IH_MAGIC != pItem->magic) {
            errorP("item magic 0x%x != 0x%x\n", pItem->magic, IH_MAGIC);
            return __LINE__;
        }
        char env_name[IH_NMLEN*2];
        char env_data[IH_NMLEN*2];
        unsigned long picLoadAddr = (unsigned long)loadaddr + (unsigned)pItem->start;

        sprintf(env_name, "%s_offset", pItem->name);//be bootup_offset ,not bootup_720_offset
        sprintf(env_data, "0x%lx", picLoadAddr);
        setenv(env_name, env_data);

        sprintf(env_name, "%s_size", pItem->name);
        sprintf(env_data, "0x%x", pItem->size);
        setenv(env_name, env_data);
    }

    return 0;//success
}

U_BOOT_CMD(
   unpackimg,           //command name
   2,                   //maxargs
   0,                   //repeatable
   do_unpackimg,   //command function
   "un pack logo image into pictures",           //description
   "    argv: unpackimg <imgLoadaddr> \n"   //usage
   "    un pack the logo image, which already loaded at <imgLoadaddr>.\n"
);

