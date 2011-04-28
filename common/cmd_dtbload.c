/**
 * load dtb file to memory before some drivers initialization such as lcd driver
 * 20130710 by Cai Yun
 */
 
#include <common.h>
#include <command.h>
#include <libfdt.h>

int do_dtbload(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_OF_LIBFDT
    void    *hdr;
    void    *dest_addr;
    unsigned    offset1;
    unsigned    offset2;
    unsigned    fdt_addr;
    int ret;
    //char dest[11];

    if(NULL!= argv[1])
        hdr = simple_strtoul(argv[1],NULL,16);		
    else
        hdr = CONFIG_SYS_LOAD_ADDR;	

#if defined(CONFIG_ANDROID_IMG)	
    boot_img_hdr *hdr_addr = hdr;
#endif

    if((genimg_get_format(hdr)) == IMAGE_FORMAT_ANDROID)
    {
        offset1=(hdr_addr->kernel_size + (hdr_addr->page_size-1)+hdr_addr->page_size)&(~(hdr_addr->page_size -1));
        offset2=(hdr_addr->ramdisk_size + (hdr_addr->page_size-1))&(~(hdr_addr->page_size -1));
        fdt_addr = (void*)((unsigned)hdr_addr + offset1 + offset2);
        if(fdt_check_header((void*)fdt_addr) != 0){
            printf("image data is not a fdt\n");
            return -1;
        }
        else
        {
        /*    dest_addr = malloc(hdr_addr->second_size * sizeof(char));
            if(!dest_addr)
            {
                printf("Error: can not alloc memory %s %s\n",__FILE__,__func__);
                return -1;
            } */
#ifdef CONFIG_DTB_LOAD_ADDR
			dest_addr = CONFIG_DTB_LOAD_ADDR;
#else
			dest_addr = 0x0f000000;
#endif
            //sprintf(dest,"0x%x",dest_addr);
            //setenv("dtbaddr",dest);
            memcpy(dest_addr,fdt_addr,hdr_addr->second_size);
            if(fdt_check_header((void*)dest_addr)!= 0){
                printf("copy error: image data is not a fdt\n");
                return -1;
            }
            else
                printf("load dtb file to memory 0x%x\n",(void *)dest_addr);
        }
    }
#endif
    return 0;
}

int do_dtbinit(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_OF_LIBFDT
	int nodeoffset;
	char* str;
	char envstr[10];
	u32  dt_addr;
	
	if (getenv("dtbaddr") == NULL) {
#ifdef CONFIG_DTB_LOAD_ADDR
		dt_addr = CONFIG_DTB_LOAD_ADDR;
#else
		dt_addr = 0x0f000000;
#endif
	}
	else {
		dt_addr = simple_strtoul (getenv ("dtbaddr"), NULL, 16);
	}
	
	if(fdt_check_header((void*)dt_addr)!= 0){
        printf(" error: image data is not a fdt\n");
        return -1;
    }
		
	nodeoffset = fdt_path_offset(dt_addr, "/mesonfb");
	if(nodeoffset < 0) {
		printf(" dts: not find  node %s.\n",fdt_strerror(nodeoffset));
		return -1;
	}
	str = fdt_getprop(dt_addr, nodeoffset, "display_size_default", NULL);
	if(str == NULL){
		printf("faild to get resolution\n");
	}
	else {
		unsigned width = be32_to_cpup((u32*)str);
		sprintf(envstr, "%u", width);
		setenv("display_width", envstr);
		unsigned height  = be32_to_cpup((((u32*)str)+1));
		sprintf(envstr, "%u", height);
		setenv("display_height", envstr);
	}
#endif
	return 0;
}

U_BOOT_CMD(
    dtbload,	2,	2,	do_dtbload,
    "load binary dtb file from a dos filesystem",
    "<interface> [image_addr] \n"
    "    - find dtb binary image from memory at address 'image_addr' \n"
    "      and load dtb image to malloc address on 'interface'\n"
);
U_BOOT_CMD(
    dtbinit,	2,	2,	do_dtbinit,
    "init some env by reading dtb file",
    "<interface> [image_addr] \n"
);