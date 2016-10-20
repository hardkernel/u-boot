#include <common.h>
#include <malloc.h>
#include <linux/err.h>
#include <partition_table.h>
#include <libfdt.h>
#include <asm/arch/bl31_apis.h>


struct partitions_data{
	int nr;
	struct partitions *parts;
};

struct partitions *part_table = NULL;
static int parts_total_num;

int get_partitions_table(struct partitions **table)
{
	int ret = 0;
	if (part_table && parts_total_num) {
		*table = part_table;
		ret = parts_total_num;
	}
	return ret;
}

int get_partition_from_dts(unsigned char * buffer)
{
	char * dt_addr;
	int nodeoffset,poffset=0;
	int* parts_num;
	char propname[8];
	const uint32_t *phandle;
	const char* uname;
	const char* usize;
	const char* umask;
	int index;
	int ret = -1;

	if ( buffer == NULL)
		goto _err;

	flush_cache((unsigned long)buffer, AML_DTB_IMG_MAX_SZ);//flush or failed in usb booting
	ret = aml_sec_boot_check(AML_D_P_IMG_DECRYPT, (long unsigned)buffer, AML_DTB_IMG_MAX_SZ, 0);
    if (ret) {
		printf("Decrypt dtb: Sig Check %d\n",ret);
		return ret;
	}

#ifdef CONFIG_MULTI_DTB
	extern unsigned long get_multi_dt_entry(unsigned long fdt_addr);
	dt_addr = (char *)get_multi_dt_entry((unsigned long)buffer);
#else
	dt_addr = (char *)buffer;
#endif
	printf("start dts,buffer=%p,dt_addr=%p\n", buffer, dt_addr);
	ret = fdt_check_header(dt_addr);
	if ( ret < 0 )
	{
		printf("%s: %s\n",__func__,fdt_strerror(ret));
		goto _err;
	}
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
	}
	return 0;

_err:
	if (part_table != NULL) {
		free(part_table);
		part_table = NULL;
	}
	return ret;
}

