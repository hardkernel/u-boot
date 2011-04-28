
#define AML_DT_IND_LENGTH_V1		4	/*fixed*/
#define AML_DT_IND_LENGTH_V2		16	/*fixed*/

#define AML_DT_IND_LENGTH			16
#define AML_DT_ID_VARI_TOTAL		3	//Total 3 strings
#define AML_DT_EACH_ID_INT			(AML_DT_IND_LENGTH / 4)

/*Latest version: v2*/
#define AML_DT_VERSION_OFFSET		4
#define AML_DT_TOTAL_DTB_OFFSET		8
#define AML_DT_FIRST_DTB_OFFSET		12
//#define AML_DT_DTB_HEADER_SIZE	(8+(AML_DT_IND_LENGTH * AML_DT_ID_VARI_TOTAL))
#define AML_DT_DTB_DT_INFO_OFFSET	0
//#define AML_DT_DTB_OFFSET_OFFSET	(AML_DT_IND_LENGTH * AML_DT_ID_VARI_TOTAL)
//#define AML_DT_DTB_SIZE_OFFSET	16

#define AML_DT_UBOOT_ENV	"aml_dt"
#define DT_HEADER_MAGIC		0xedfe0dd0	/*header of dtb file*/
#define AML_DT_HEADER_MAGIC	0x5f4c4d41	/*"AML_", multi dtbs supported*/

#define readl(addr) (*(volatile unsigned int*)(addr))

unsigned int get_multi_dt_entry(unsigned int fdt_addr){
	unsigned int dt_magic = readl(fdt_addr);
	unsigned int dt_total = 0;
	unsigned int dt_tool_version = 0;
	/*printf("      Process device tree. dt magic: %x\n", dt_magic);*/
	if(dt_magic == DT_HEADER_MAGIC){/*normal dtb*/
		/*printf("      One dtb detected\n");*/
		return fdt_addr;
	}
	if(dt_magic == AML_DT_HEADER_MAGIC){/*multi dtb*/
		/*check and set aml_dt*/
		char *s;
		if ((s = getenv ("get_dt")) != NULL) {
			run_command(s, 0);
		}

		/*version control, compatible with v1*/
		dt_tool_version = readl(fdt_addr + AML_DT_VERSION_OFFSET);
		unsigned int aml_each_id_length;
		unsigned int aml_dtb_offset_offset;
		unsigned int aml_dtb_header_size;
		if(dt_tool_version == 1)
			aml_each_id_length = 4;
		else if(dt_tool_version == 2)
			aml_each_id_length = 16;

		aml_dtb_offset_offset = aml_each_id_length * AML_DT_ID_VARI_TOTAL;
		aml_dtb_header_size = 8+(aml_each_id_length * AML_DT_ID_VARI_TOTAL);
		printf("      Multi dtb tool version: v%d .\n", dt_tool_version);

		/*fdt_addr + 0x8: num of dtbs*/
		dt_total = readl(fdt_addr + AML_DT_TOTAL_DTB_OFFSET);
		printf("      Multi dtb detected, support %d dtbs.\n", dt_total);

		/*Get aml_dt and split to 3 strings*/
		int i = 0;
		unsigned char *aml_dt_buf;
		aml_dt_buf = (unsigned char *)malloc(sizeof(unsigned char)*64);
		memset(aml_dt_buf, 0, sizeof(aml_dt_buf));
		unsigned char *aml_dt = getenv(AML_DT_UBOOT_ENV);
		memcpy(aml_dt_buf, aml_dt, (strlen(aml_dt)>64?64:(strlen(aml_dt)+1)));
		unsigned int aml_dt_len = aml_dt_buf ? strlen(aml_dt_buf) : 0;
		if(aml_dt_len <= 0){
			printf("      Get env aml_dt failed!\n");
			return fdt_addr;
		}
		unsigned char *tokens[3] = {NULL, NULL, NULL};
		for(i = 0; i < AML_DT_ID_VARI_TOTAL; i++){
			tokens[i] = strsep(&aml_dt_buf, "_");
		}
		if(aml_dt_buf)
			free(aml_dt_buf);
		printf("        aml_dt soc: %s platform: %s variant: %s\n", tokens[0], tokens[1], tokens[2]);

		/*match and print result*/
		unsigned char **dt_info;
		dt_info = (unsigned char **)malloc(sizeof(unsigned char *)*AML_DT_ID_VARI_TOTAL);
		for(i = 0; i < AML_DT_ID_VARI_TOTAL; i++)
			dt_info[i] = (unsigned char *)malloc(sizeof(unsigned char)*aml_each_id_length);
		unsigned int dtb_match_num = 0xffff;
		unsigned int x = 0, y = 0; //loop counter
		unsigned int read_data;
		for(i = 0; i < dt_total; i++){
			for(x = 0; x < AML_DT_ID_VARI_TOTAL; x++){
				for(y = 0; y < aml_each_id_length; y+=4){
					read_data = (unsigned char *)readl(fdt_addr + AML_DT_FIRST_DTB_OFFSET + \
						 i * aml_dtb_header_size + AML_DT_DTB_DT_INFO_OFFSET + \
						 (x * aml_each_id_length) + y);
					dt_info[x][y+0] = (read_data >> 24) & 0xff;
					dt_info[x][y+1] = (read_data >> 16) & 0xff;
					dt_info[x][y+2] = (read_data >> 8) & 0xff;
					dt_info[x][y+3] = (read_data >> 0) & 0xff;
				}
			}
			if(dt_tool_version == 1)
				printf("        dtb %d soc: %0.4s   plat: %0.4s   vari: %0.4s\n", i, (char *)(dt_info[0]), (char *)(dt_info[1]), (char *)(dt_info[2]));
			else if(dt_tool_version == 2)
				printf("        dtb %d soc: %0.16s   plat: %0.16s   vari: %0.16s\n", i, (char *)(dt_info[0]), (char *)(dt_info[1]), (char *)(dt_info[2]));
			if(!strncmp(tokens[0], (char *)(dt_info[0]), strlen(tokens[0])) && \
				!strncmp(tokens[1], (char *)(dt_info[1]), strlen(tokens[1])) && \
				!strncmp(tokens[2], (char *)(dt_info[2]), strlen(tokens[2]))){
				//printf("Find match dtb\n");
				dtb_match_num = i;
			}
		}
		/*clean malloc memory*/
		for(i = 0; i < AML_DT_ID_VARI_TOTAL; i++){
			if(dt_info[i])
				free(dt_info[i]);
		}
		if(dt_info)
			free(dt_info);

		/*if find match dtb, return address, or else return main entrance address*/
		if(0xffff != dtb_match_num){
			printf("      Find match dtb: %d\n", dtb_match_num);
			/*this offset is based on dtb image package, so should add on base address*/
			return (fdt_addr + readl(fdt_addr + AML_DT_FIRST_DTB_OFFSET + \
				dtb_match_num * aml_dtb_header_size + aml_dtb_offset_offset));
		}
		else{
			printf("      Not match any dtb.\n");
			return fdt_addr;
		}
	}
}
