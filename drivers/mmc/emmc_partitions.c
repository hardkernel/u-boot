#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <asm/arch/cpu_sdio.h>
#include <mmc.h>
#include <linux/err.h>
#include <emmc_partitions.h>
#include <partition_table.h>

#define		POR_BOOT_VALUE 0
#define		DTB_PART_SIZE	512*1024 //512K
#define DTB_ADDR_SIZE	(SZ_1M * 40)
struct mmc_partition_config * mmc_partition_config_of =NULL;
bool is_partition_checked = false;
#ifdef CONFIG_AML_NAND
unsigned device_boot_flag = (unsigned)_AML_DEVICE_BOOT_FLAG_DEFAULT;
#else
unsigned device_boot_flag = (unsigned)EMMC_BOOT_FLAG;
#endif
extern struct mmc *find_mmc_device_by_port (unsigned sdio_port);
extern int get_dtb_struct(struct mmc *mmc);
extern struct partitions *part_table;
extern int get_partition_from_dts(unsigned char * buffer);
#if 0
struct partitions part_table[MAX_PART_NUM]={
		{
			.name = "logo",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "recovery",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "dtb",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "tee",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "crypt",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "misc",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#ifdef CONFIG_INSTABOOT
		{
			.name = "instaboot",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#endif
		{
			.name = "boot",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "system",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "cache",
			.size = 512*SZ_1M,
			.mask_flags = STORE_CACHE,
		},
		{
			.name = "data",
			.size = NAND_PART_SIZE_FULL,
			.mask_flags = STORE_DATA,
		},
};
#endif

#ifndef CONFIG_AML_MMC_INHERENT_PART
struct partitions emmc_partition_table[]={
    PARTITION_ELEMENT(MMC_BOOT_NAME, MMC_BOOT_DEVICE_SIZE, 0),
    PARTITION_ELEMENT(MMC_RESERVED_NAME, MMC_RESERVED_SIZE, 0),
    /* prior partitions, same partition name with dts*/
    /* partition size will be overide by dts*/
    PARTITION_ELEMENT(MMC_CACHE_NAME, 0, 0),
    // PARTITION_ELEMENT(MMC_KEY_NAME, MMC_KEY_SIZE, 0),
    // PARTITION_ELEMENT(MMC_SECURE_NAME, MMC_SECURE_SIZE, 0),
    PARTITION_ELEMENT(MMC_ENV_NAME, MMC_ENV_SIZE, 0),
};

int get_emmc_partition_arraysize(void)
{
    return ARRAY_SIZE(emmc_partition_table);
}
#endif
void show_mmc_patition (struct partitions *part, int part_num)
{
    int i, cnt_stuff;

    printf("        name                        offset              size              flag\n");
    printf("===================================================================================\n");
	for (i=0; i < part_num ; i++) {
        printf("%4d: %s", i, part[i].name);
        cnt_stuff = sizeof(part[i].name) - strlen(part[i].name);
        if (cnt_stuff < 0) // something is wrong
            cnt_stuff = 0;
        cnt_stuff += 2;
        while (cnt_stuff--) {
            printf(" ");
        }
		printf("%18llx%18llx %18d\n", part[i].offset, part[i].size,part[i].mask_flags);
		// printf("mmc_device->offset : %llx",mmc_partition_config_of->partitions[i].offset);
		// printf("mmc_device->size : %llx",mmc_partition_config_of->partitions[i].size);
	}
}

static struct partitions* find_partition_by_name (struct partitions *part_tbl, int part_num, char *name)
{
    int i;

	for (i=0; i < part_num; i++) {
        if (!part_tbl[i].name || (part_tbl[i].name[0] == '\0'))
            break;

	    if (!strncmp(part_tbl[i].name, name, MAX_MMC_PART_NAME_LEN)) {
            return &(part_tbl[i]);
        }
	}

    return NULL;
}

struct partitions* find_mmc_partition_by_name (char *name)
{
    struct partitions *p=NULL;
    if (mmc_partition_config_of == NULL)
        return p;
    p = find_partition_by_name(mmc_partition_config_of->partitions, mmc_partition_config_of->part_num, name);
    if (!p)
        printf("Can not find partition name \"%s\"\n", name);

    return p;
}

// set partition info according to what get from the spl
int set_partition_info (struct partitions *src_tbl, int src_part_num,
        struct partitions *dst_tbl, int dst_part_num, char *name)
{
    struct partitions *src=NULL;
    struct partitions *dst=NULL;

    src = find_partition_by_name(src_tbl, src_part_num, name);
    if (!src)
        return -1; // error

    dst = find_partition_by_name(dst_tbl, dst_part_num, name);
    if (!src)
        return -1; // error

    dst->size = src->size;
    dst->mask_flags = src->mask_flags;

    return 0; // OK
}

/* overide partitons's size config by dts. */
int overide_emmc_partition_table(void)
{
    int i, ret = 0;

	for (i = 0; i < get_emmc_partition_arraysize(); i++) {
		if (0 == set_partition_info(part_table, MAX_MMC_PART_NUM,
			emmc_partition_table, get_emmc_partition_arraysize(),
            emmc_partition_table[i].name)) {
            printf("%s: overide %s \n", __func__, emmc_partition_table[i].name);
        }
    }

    return ret;
}

int is_in_emmc_partition_tbl(char * name)
{
    int ret = 1;
    struct partitions *part=NULL;

    part = find_partition_by_name(emmc_partition_table, get_emmc_partition_arraysize(), name);
    if (!part)
        ret = 0;

    return ret;
}

int mmc_get_partition_table (struct mmc *mmc)
{
    int i, resv_size, ret=0, part_num=0;
	struct partitions *part_ptr;

	mmc_partition_config_of = kmalloc((sizeof(struct mmc_partition_config)), 0);
	if (mmc_partition_config_of == NULL) {
		aml_mmc_dbg("malloc failed for mmc config!");
		ret = -1;
		goto exit_err;
	}

	memset(mmc_partition_config_of,0x0,(sizeof(struct mmc_partition_config)));
	part_ptr = mmc_partition_config_of->partitions;
	ret = get_dtb_struct(mmc);
	if (ret)
		goto exit_err;

	overide_emmc_partition_table();

	/* set inherent partitions info*/
	for (i=0; i < get_emmc_partition_arraysize(); i++) {
		strncpy(part_ptr[part_num].name, emmc_partition_table[i].name, MAX_MMC_PART_NAME_LEN);
		part_ptr[part_num].size = emmc_partition_table[i].size;
		part_ptr[part_num].mask_flags= emmc_partition_table[i].mask_flags;

        if (part_num == 0) { // first partition
            part_ptr[part_num].offset = 0;
        } else {
            if (!strncmp(part_ptr[part_num-1].name, MMC_BOOT_NAME, MAX_MMC_PART_NAME_LEN)) { // eMMC boot partition
                resv_size = MMC_BOOT_PARTITION_RESERVED;
                if ((device_boot_flag != EMMC_BOOT_FLAG)) {  //for spi boot case
                    part_ptr[part_num].name[strlen(MMC_BOOT_NAME)] = 'e';
                    part_ptr[part_num].name[strlen(MMC_BOOT_NAME)+1] = '\0';

                    printf("change MMC BOOT NAME into 'bootloadere' for none emmc boot case, POR_BOOT_VALUE=%d\n", POR_BOOT_VALUE);
                }
            } else {
                resv_size = PARTITION_RESERVED;
            }
            part_ptr[part_num].offset = part_ptr[part_num-1].offset
                + part_ptr[part_num-1].size + resv_size;
        }
		part_num++;
    }

	for (i=0; i < MAX_MMC_PART_NUM; i++) {
        //skip partitions already setted by emmc_partition_table.
		if (is_in_emmc_partition_tbl(part_table[i].name)) {
            printf("[%s] skip partition %s.\n", __FUNCTION__, part_table[i].name);
            continue;
        }

		strncpy(part_ptr[part_num].name, part_table[i].name, MAX_MMC_PART_NAME_LEN);
		part_ptr[part_num].size = part_table[i].size;
		part_ptr[part_num].mask_flags= part_table[i].mask_flags;
        part_ptr[part_num].offset = part_ptr[part_num-1].offset
            + part_ptr[part_num-1].size + PARTITION_RESERVED;

        // printf("*****************%d********************************\n", part_num);
        // printf("mmc_device->name : %s\n", part_ptr[part_num].name);
        // printf("mmc_device->offset : %llx\n", part_ptr[part_num].offset);
        // printf("mmc_device->size : %llx\n", part_ptr[part_num].size);

		if ((part_table[i].size == -1) || ((part_ptr[part_num].offset + part_ptr[part_num].size) > mmc->capacity)) {
            part_ptr[part_num].size = mmc->capacity - part_ptr[part_num].offset;
            part_ptr[part_num].size = (part_ptr[part_num].size > MMC_BOTTOM_RSV_SIZE) ?
                (part_ptr[part_num].size - MMC_BOTTOM_RSV_SIZE):part_ptr[part_num].size;
            //printf("mmc->capacity=%llx, mmc_device->size=%llx\n", mmc->capacity, part_ptr[part_num].size);
			break;
        }
		part_num++;
	}
	strncpy((char *)(mmc_partition_config_of->version), MMC_UBOOT_VERSION, MAX_MMC_PART_NAME_LEN);
	mmc_partition_config_of->part_num = part_num + 1;
	mmc_partition_config_of->private_data = mmc;

//    aml_mmc_msg("mmc_partition_config_of->part_num %d",mmc_partition_config_of->part_num);

	return ret;

exit_err:
	if (mmc_partition_config_of) {
		kfree(mmc_partition_config_of);
		mmc_partition_config_of = NULL;
        ret = -ENOMEM;
	}

	return ret;
}

int mmc_partition_tbl_checksum_calc (struct partitions *part, int part_num)
{
    int i, j;
	u32 checksum = 0, *p;

	for (i = 0; i < part_num; i++) {
		p = (u32*)part;
		for (j = sizeof(struct partitions)/sizeof(checksum); j > 0; j--) {
			checksum += *p;
			p++;
	    }
    }

	return checksum;
}

int mmc_write_partition_tbl (struct mmc *mmc, struct mmc_partition_config *mmc_cfg, struct mmc_partitions_fmt *pt_fmt)
{
    int ret=0, start_blk, size, blk_cnt=0;
    char *buf, *src;
    struct partitions *pp;

    buf = kmalloc(mmc->read_bl_len, 0); // size of a block
    if (buf == NULL) {
        aml_mmc_dbg("malloc failed for buffer!");
        ret = -ENOMEM;
        goto exit_err;
    }
    memset(pt_fmt, 0, sizeof(struct mmc_partitions_fmt));
    memset(buf, 0, mmc->read_bl_len);

    memcpy(pt_fmt->version, mmc_cfg->version, sizeof(pt_fmt->version));
    pt_fmt->part_num = mmc_cfg->part_num;
    memcpy(pt_fmt->partitions, mmc_cfg->partitions, MAX_MMC_PART_NUM*sizeof(mmc_cfg->partitions[0]));

    pt_fmt->checksum = mmc_partition_tbl_checksum_calc(pt_fmt->partitions, pt_fmt->part_num);
    strncpy(pt_fmt->magic, MMC_PARTITIONS_MAGIC, sizeof(pt_fmt->magic));


    pp = find_mmc_partition_by_name(MMC_RESERVED_NAME);
    if (!pp) {
        ret = -1;
        goto exit_err;
    }
    start_blk = pp->offset/mmc->read_bl_len;
    size = sizeof(struct mmc_partitions_fmt);
    src = (char *)pt_fmt;
    if (size >= mmc->read_bl_len) {
        blk_cnt = size / mmc->read_bl_len;
        printf("mmc write lba=%#x, blocks=%#x\n", start_blk, blk_cnt);
        ret = mmc->block_dev.block_write(mmc->block_dev.dev, start_blk, blk_cnt, src);
        if (ret == 0) { // error
            ret = -1;
            goto exit_err;
        }

        start_blk += blk_cnt;
        src += blk_cnt * mmc->read_bl_len;
        size -= blk_cnt * mmc->read_bl_len;
    }
    if (size > 0) { // the last block
        memcpy(buf, src, size);
        // buf[mmc->read_bl_len - 2] = 0x55;
        // buf[mmc->read_bl_len - 1] = 0xaa;

        printf("mmc write lba=%#x, blocks=%#x\n", start_blk, blk_cnt);
        ret = mmc->block_dev.block_write(mmc->block_dev.dev, start_blk, 1, buf);
        if (ret == 0) { // error
            ret = -1;
            goto exit_err;
        }
    }

    ret = 0; // everything is OK now

exit_err:
    if (buf) {
        kfree(buf);
    }

    printf("%s: mmc write partition %s!\n", __FUNCTION__, (ret==0)? "OK": "ERROR");

    return ret;
}

int mmc_read_partition_tbl (struct mmc *mmc, struct mmc_partitions_fmt *pt_fmt)
{
    int ret=0, start_blk, size, blk_cnt=0;
    char *buf, *dst;
	struct partitions *pp;

	buf = kmalloc(mmc->read_bl_len, 0); // size of a block
	if (buf == NULL) {
		aml_mmc_dbg("malloc failed for buffer!");
        ret = -ENOMEM;
		goto exit_err;
	}
	memset(pt_fmt, 0, sizeof(struct mmc_partitions_fmt));
	memset(buf, 0, mmc->read_bl_len);


    pp = find_mmc_partition_by_name(MMC_RESERVED_NAME);
    if (!pp) {
        ret = -1;
        goto exit_err;
    }
    start_blk = pp->offset/mmc->read_bl_len;
    size = sizeof(struct mmc_partitions_fmt);
    dst = (char *)pt_fmt;
    if (size >= mmc->read_bl_len) {
        blk_cnt = size / mmc->read_bl_len;
        printf("mmc read lba=%#x, blocks=%#x\n", start_blk, blk_cnt);
        ret = mmc->block_dev.block_read(mmc->block_dev.dev, start_blk, blk_cnt, dst);
        if (ret == 0) { // error
            ret = -1;
            goto exit_err;
        }

        start_blk += blk_cnt;
        dst += blk_cnt * mmc->read_bl_len;
        size -= blk_cnt * mmc->read_bl_len;
    }
    if (size > 0) { // the last block
        printf("mmc read lba=%#x, blocks=%#x\n", start_blk, blk_cnt);
        ret = mmc->block_dev.block_read(mmc->block_dev.dev, start_blk, 1, buf);
        if (ret == 0) { // error
            ret = -1;
            goto exit_err;
        }

        memcpy(dst, buf, size);
        // if ((buf[mmc->read_bl_len - 2] != 0x55) || (buf[mmc->read_bl_len - 1] != 0xaa)) { // error
            // ret = -1;
            // goto exit_err;
        // }
    }

	if ((strncmp(pt_fmt->magic, MMC_PARTITIONS_MAGIC, sizeof(pt_fmt->magic)) == 0) // the same
       && (pt_fmt->part_num > 0) && (pt_fmt->part_num <= MAX_MMC_PART_NUM)
       && (pt_fmt->checksum == mmc_partition_tbl_checksum_calc(pt_fmt->partitions, pt_fmt->part_num))) {
        ret = 0; // everything is OK now
	} else {
        ret = -1; // the partition infomation is invalid
    }

exit_err:
	if (buf) {
		kfree(buf);
	}

	printf("%s: mmc read partition %s!\n", __FUNCTION__, (ret==0)? "OK": "ERROR");

    return ret;
}

int mmc_partition_verify (struct mmc_partition_config * mmc_cfg, struct mmc_partitions_fmt *pt_fmt)
{
    int ret=0, i;
    struct partitions *pp1, *pp2;

    // printf("Partition table stored in eMMC/TSD: \n");
    // printf("magic: %s, version: %s, checksum=%#x\n",
            // pt_fmt->magic, pt_fmt->version, pt_fmt->checksum);
    // show_mmc_patition(pt_fmt->partitions, pt_fmt->part_num);

    // printf("Partition table get from SPL is : \n");
    // printf("version: %s\n", mmc_cfg->version);
    // show_mmc_patition(mmc_cfg->partitions, mmc_cfg->part_num);

    if ((strncmp((const char *)(mmc_cfg->version), (const char *)(pt_fmt->version), sizeof(pt_fmt->version)) == 0x00)
            && (mmc_cfg->part_num == pt_fmt->part_num)) {
        pp1 = mmc_cfg->partitions;
        pp2 = pt_fmt->partitions;
        for (i = 0; i < pt_fmt->part_num; i++) {
            if ((pp1[i].size != pp2[i].size)
                    || (pp1[i].offset != pp2[i].offset)
                    ||(pp1[i].mask_flags!= pp2[i].mask_flags)
                    || (strncmp(pp1[i].name, pp2[i].name, sizeof(pp1[i].name)) != 0x00)) {
                printf("%s: partition[%d] is different \n", __FUNCTION__, i);
                ret = -1;
                break;
            }
        }
    } else {
        printf("%s: version OR part_num is different!\n", __FUNCTION__);
        ret = -1;
    }

    return ret;
}

int mmc_device_init (struct mmc *mmc)
{
	int ret=0;
    struct mmc_partitions_fmt *pt_fmt;

	ret = mmc_get_partition_table(mmc);
    if (ret == 0) { // ok
        printf("Partition table get from SPL is : \n");
        show_mmc_patition(mmc_partition_config_of->partitions, mmc_partition_config_of->part_num);
    } else {
        printf("mmc get partition error!\n");
        return -1;
    }

    pt_fmt = kmalloc(sizeof(struct mmc_partitions_fmt), 0);
	if (pt_fmt == NULL) {
		aml_mmc_dbg("malloc failed for struct mmc_partitions_fmt!");
		return -ENOMEM;
	}

    ret = mmc_read_partition_tbl(mmc, pt_fmt);
    if (ret == 0) { // ok
        ret = mmc_partition_verify(mmc_partition_config_of, pt_fmt);
        if (ret == 0) { // ok
//            printf("Partition table verified OK !\n");
        } else {
            printf("Partition table verified ERROR!\n"
                    "Following is the partition table stored in eMMC/TSD: \n");
            show_mmc_patition(pt_fmt->partitions, pt_fmt->part_num);
        }
    }

    if (ret != 0) { // error happen
        ret = mmc_write_partition_tbl(mmc, mmc_partition_config_of, pt_fmt); // store mmc partition in tsd/emmc
    }

	if (pt_fmt) {
		kfree(pt_fmt);
	}

	return ret;
}


int find_dev_num_by_partition_name (char *name)
{
	int dev_num=-1;
	//struct mmc *mmc;

    if (!strncmp(name, MMC_CARD_PARTITION_NAME, sizeof(MMC_CARD_PARTITION_NAME))) { // card
       // port = SDIO_PORT_B;
        dev_num = 0;
    } else { // eMMC OR TSD
        if (find_mmc_partition_by_name(name)) { // partition name is valid
            //port = SDIO_PORT_C;
            dev_num = 1;
        } // else port=-1
    }

//    if (port > 0) {
//        mmc = find_mmc_device_by_port((unsigned)port);
//        if (!mmc) { // not found
//            dev_num = -1;
//        } else {
//            dev_num = mmc->block_dev.dev;
//        }
//    } else { // partition name is invalid
//        dev_num = -1;
//    }

    return dev_num;
}
extern int dtb_read(void *addr);
int get_dtb_struct(struct mmc *mmc)
{
    int ret=0;//, start_blk, size, blk_cnt=0;
    //unsigned char *dst = NULL;
    unsigned char *buffer = NULL;

    //Burning empty emmc flash, dtb downloaded from usb tool
    if (part_table) return 0;

    buffer = (unsigned char *)malloc(sizeof(unsigned char) * DTB_PART_SIZE);
    /* don't check the return of dtb_read */
    dtb_read(buffer);

    ret = get_partition_from_dts(buffer);
	if (ret) {
        printf("!!!!get dts FAILED\n");
        goto exit_err;
    }
    printf("%s: Get emmc dtb %s!\n", __FUNCTION__, (ret==0)? "OK": "ERROR");
exit_err:
	if (buffer)
        kfree(buffer);

    return ret;
}
