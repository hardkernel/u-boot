#include <common.h>
#include <malloc.h>
#include <linux/err.h>
#include <partition_table.h>
#include <libfdt.h>
#include <asm/arch/bl31_apis.h>
#include <asm/arch/secure_apb.h>

extern int is_dtb_encrypt(unsigned char *buffer);
#ifdef CONFIG_MULTI_DTB
	extern unsigned long get_multi_dt_entry(unsigned long fdt_addr);
#endif

struct partitions_data{
	int nr;
	struct partitions *parts;
};

struct partitions *part_table = NULL;
static int parts_total_num;
int has_boot_slot = 0;
int has_system_slot = 0;


int get_partitions_table(struct partitions **table)
{
	int ret = 0;
	if (part_table && parts_total_num) {
		*table = part_table;
		ret = parts_total_num;
	}
	return ret;
}
int get_partition_count(void)
{
	return parts_total_num;
}
struct partitions *get_partitions(void)
{
	return part_table;
}



void free_partitions(void)
{
	if (part_table)
		free(part_table);
	part_table = NULL;
}

static int is_secure_boot_enabled(void)
{
	const unsigned long cfg10 = readl(AO_SEC_SD_CFG10);
	return ( cfg10 & (0x1<< 4) );
}

/*
  return 0 if dts is valid
  other value are falure.
*/
int check_valid_dts(unsigned char *buffer)
{
	int ret = -__LINE__;
	char *dt_addr;
	/* fixme, a work around way */
	unsigned char *sbuffer = (unsigned char *)getenv_hex("loadaddr", CONFIG_DTB_MEM_ADDR + 0x100000);
	/* g12a merge to trunk, use trunk code */
	//unsigned char *sbuffer = (unsigned char *)0x1000000;
	if (is_secure_boot_enabled()) {

	if (is_dtb_encrypt(buffer)) {
		memcpy(sbuffer, buffer, AML_DTB_IMG_MAX_SZ);
		flush_cache((unsigned long)sbuffer, AML_DTB_IMG_MAX_SZ);
		ret = aml_sec_boot_check(AML_D_P_IMG_DECRYPT, (long unsigned)sbuffer, AML_DTB_IMG_MAX_SZ, 0);
		if (ret) {
			printf("\n %s() %d: Decrypt dtb: Sig Check %d\n", __func__, __LINE__, ret);
			return -__LINE__;
		}

		ulong nCheckOffset;
		nCheckOffset = aml_sec_boot_check(AML_D_Q_IMG_SIG_HDR_SIZE,GXB_IMG_LOAD_ADDR,GXB_EFUSE_PATTERN_SIZE,GXB_IMG_DEC_ALL);
		if (AML_D_Q_IMG_SIG_HDR_SIZE == (nCheckOffset & 0xFFFF))
			nCheckOffset = (nCheckOffset >> 16) & 0xFFFF;
		else
			nCheckOffset = 0;
		memcpy(buffer, sbuffer + nCheckOffset, AML_DTB_IMG_MAX_SZ);

	}

	}
#ifdef CONFIG_MULTI_DTB
	dt_addr = (char *)get_multi_dt_entry((unsigned long)buffer);
#else
	dt_addr = (char *)buffer;
#endif
	printf("start dts,buffer=%p,dt_addr=%p\n", buffer, dt_addr);
	ret = fdt_check_header(dt_addr);
	if ( ret < 0 )
		printf("%s: %s\n",__func__,fdt_strerror(ret));
	/* fixme, is it 0 when ok? */
	return ret;
}

int get_partition_from_dts(unsigned char *buffer)
{
	char *dt_addr;
	int nodeoffset,poffset=0;
	int *parts_num;
	char propname[8];
	const uint32_t *phandle;
	const char *uname;
	const char *usize;
	const char *umask;
	int index;
	int ret = -1;

	if ( buffer == NULL)
		goto _err;

	ret = check_valid_dts(buffer);
	printf("%s() %d: ret %d\n",__func__, __LINE__, ret);
	if ( ret < 0 )
	{
		printf("%s() %d: ret %d\n",__func__, __LINE__, ret);
		goto _err;
	}
#ifdef CONFIG_MULTI_DTB
	dt_addr = (char *)get_multi_dt_entry((unsigned long)buffer);
#else
	dt_addr = (char *)buffer;
#endif
	nodeoffset = fdt_path_offset(dt_addr, "/partitions");
	if (nodeoffset < 0)
	{
		printf("%s: not find /partitions node %s.\n",__func__,fdt_strerror(nodeoffset));
		ret = -1;
		goto _err;
	}
	parts_num = (int *)fdt_getprop(dt_addr, nodeoffset, "parts", NULL);
	printf("parts: %d\n",be32_to_cpup((u32*)parts_num));

	if (parts_num > 0)
	{
		part_table = (struct partitions *)malloc(sizeof(struct partitions)*(be32_to_cpup((u32*)parts_num)));
		if (!part_table) {
			printk("%s part_table alloc _err\n",__func__);
			//kfree(data);
			return -1;
		}
		memset(part_table, 0, sizeof(struct partitions)*(be32_to_cpup((u32*)parts_num)));
		parts_total_num = be32_to_cpup((u32*)parts_num);
	}
	for (index = 0; index < be32_to_cpup((u32*)parts_num); index++)
	{
		sprintf(propname,"part-%d", index);

		phandle = fdt_getprop(dt_addr, nodeoffset, propname, NULL);
		if (!phandle) {
			printf("don't find  match part-%d\n",index);
			goto _err;
		}
		if (phandle) {
			poffset = fdt_node_offset_by_phandle(dt_addr, be32_to_cpup((u32*)phandle));
			if (!poffset) {
				printf("%s:%d,can't find device node\n",__func__,__LINE__);
				goto _err;
			}
		}
		uname = fdt_getprop(dt_addr, poffset, "pname", NULL);
		//printf("%s:%d  uname: %s\n",__func__,__LINE__, uname);
		/* a string but not */
		usize = fdt_getprop(dt_addr, poffset, "size", NULL);
		//printf("%s:%d size: 0x%x  0x%x\n",__func__,__LINE__, be32_to_cpup((u32*)usize), be32_to_cpup((((u32*)usize)+1)));
		umask = fdt_getprop(dt_addr, poffset, "mask", NULL);
		//printf("%s:%d mask: 0x%x\n",__func__,__LINE__, be32_to_cpup((u32*)umask));
		/* fill parition table */
		if (uname != NULL)
			memcpy(part_table[index].name, uname, strlen(uname));
		part_table[index].size = ((unsigned long)be32_to_cpup((u32*)usize) << 32) | (unsigned long)be32_to_cpup((((u32*)usize)+1));
		part_table[index].mask_flags = be32_to_cpup((u32*)umask);
		printf("%02d:%10s\t%016llx %01x\n", index, uname, part_table[index].size, part_table[index].mask_flags);

		if (strcmp(uname, "boot_a") == 0) {
			has_boot_slot = 1;
			printf("set has_boot_slot = 1\n");
		}
		else if (strcmp(uname, "boot") == 0) {
			has_boot_slot = 0;
			printf("set has_boot_slot = 0\n");
		}
		if (strcmp(uname, "system_a") == 0)
			has_system_slot = 1;
		else if (strcmp(uname, "system") == 0)
			has_system_slot = 0;
	}
	return 0;

_err:
	if (part_table != NULL) {
		free(part_table);
		part_table = NULL;
	}
	return ret;
}
