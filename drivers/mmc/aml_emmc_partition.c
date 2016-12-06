/*
 * Copyright 2016, Amlogic Inc
 * yonghui.yu
 *
 * Based vaguely on the Linux code
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>
#include <common.h>
#include <command.h>
#include <errno.h>
#include <mmc.h>
#include <part.h>
#include <malloc.h>
#include <linux/list.h>
#include <div64.h>
#include "mmc_private.h"
#include <emmc_partitions.h>
#include <asm/cpu_id.h>

#define CONFIG_PTBL_MBR	0
#define CONFIG_MPT_DEBUG 0

#define apt_err(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)

#define apt_wrn(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)
#if (CONFIG_MPT_DEBUG)
/* for detail debug info */
#define apt_info(fmt, ...) printf( "%s()-%d: " fmt , \
                  __func__, __LINE__, ##__VA_ARGS__)
#else
#define apt_info(fmt, ...)
#endif

/* creat MBR for emmc */
#define MAX_PNAME_LEN 	(16)
#define MAX_PART_COUNT	(32)

/*
  Global offset of reserved partition is 36MBytes
  since MMC_BOOT_PARTITION_RESERVED is 32MBytes and
  MMC_BOOT_DEVICE_SIZE is 4MBytes.
  MMC_RESERVED_SIZE is 64MBytes for now.
  layout detail inside reserved partition.
  0x000000 - 0x003fff: partition table
  0x004000 - 0x03ffff: storage key area	(16k offset & 256k size)
  0x400000 - 0x47ffff: dtb area  (4M offset & 512k size)
  0x480000 - 64MBytes: resv for other usage.
  ...
 */
#define RSV_DTB_OFFSET_GLB	(SZ_1M*40)
#define RSV_DTB_SIZE		(512*1024UL)
#define RSV_PTBL_OFFSET		(SZ_1M*0)
#define RSV_PTBL_SIZE		(16*1024UL)
#define RSV_SKEY_OFFSET		(16*1024UL)
#define RSV_SKEY_SIZE		(256*1024UL)
#define RSV_DTB_OFFSET		(SZ_1M*4)

/* virtual partitions which are in "reserved" */
#define MAX_MMC_VIRTUAL_PART_CNT	(5)


/* BinaryLayout of partition table stored in rsv area */
struct ptbl_rsv {
    char magic[4];				/* MPT */
    unsigned char version[12];	/* binary version */
    int count;	/* partition count in using */
    int checksum;
    struct partitions partitions[MAX_MMC_PART_NUM];
};

/* partition table for innor usage*/
struct _iptbl {
	struct partitions *partitions;
	int count;	/* partition count in use */
};

#ifdef CONFIG_AML_NAND
unsigned device_boot_flag = (unsigned)_AML_DEVICE_BOOT_FLAG_DEFAULT;
#else
unsigned device_boot_flag = (unsigned)EMMC_BOOT_FLAG;
#endif
bool is_partition_checked = false;

#ifndef CONFIG_AML_MMC_INHERENT_PART
/* fixme, name should be changed as aml_inherent_ptbl */
struct partitions emmc_partition_table[]={
    PARTITION_ELEMENT(MMC_BOOT_NAME, MMC_BOOT_DEVICE_SIZE, 0),
    PARTITION_ELEMENT(MMC_RESERVED_NAME, MMC_RESERVED_SIZE, 0),
    /* prior partitions, same partition name with dts*/
    /* partition size will be overide by dts*/
    PARTITION_ELEMENT(MMC_CACHE_NAME, 0, 0),
    PARTITION_ELEMENT(MMC_ENV_NAME, MMC_ENV_SIZE, 0),
};

int get_emmc_partition_arraysize(void)
{
    return ARRAY_SIZE(emmc_partition_table);
}
#endif

__weak void _dump_part_tbl(struct partitions *p, int count)
{
	int i = 0;
	apt_info("count %d\n", count);
	while (i < count) {
		printf("%02d %10s %016llx %016llx\n", i, p[i].name, p[i].offset, p[i].size);
		i++;
	}
	return;
}

static struct partitions *_find_partition_by_name(struct partitions *tbl,
			int cnt, const char *name)
{
	int i = 0;
	struct partitions *part = NULL;

	while (i < cnt) {

		part = &tbl[i];
		if (!strcmp(name, part->name)) {
			apt_info("find %s @ tbl[%d]\n", name, i);
			break;
		}
		i++;
	};
	if (i == cnt) {
		part = NULL;
		apt_wrn("do not find match in table %s\n", name);
	}
	return part;
}

/* fixme, must called after offset was calculated. */
static ulong _get_inherent_offset(const char *name)
{
	struct partitions *part;

	part = _find_partition_by_name(emmc_partition_table,
			get_emmc_partition_arraysize(), name);
	if (NULL == part)
		return -1;
	else
		return part->offset;
}
/* partition table (Emmc Partition Table) */
struct _iptbl *p_iptbl_ept = NULL;

/* trans byte into lba manner for rsv area read/write */
static ulong _mmc_rsv_read(struct mmc *mmc, ulong offset, ulong size, void * buffer)
{
	lbaint_t _blk, _cnt;
	if (0 == size)
		return 0;

	_blk = offset / mmc->read_bl_len;
	_cnt = size / mmc->read_bl_len;
	_cnt = mmc->block_dev.block_read(mmc->block_dev.dev, _blk, _cnt, buffer);

	return (ulong)(_cnt * mmc->read_bl_len);
}

static ulong _mmc_rsv_write(struct mmc *mmc, ulong offset, ulong size, void * buffer)
{
	lbaint_t _blk, _cnt;
	if (0 == size)
		return 0;

	_blk = offset / mmc->read_bl_len;
	_cnt = size / mmc->read_bl_len;
	_cnt = mmc->block_dev.block_write(mmc->block_dev.dev, _blk, _cnt, buffer);

	return (ulong)(_cnt * mmc->read_bl_len);
}

static struct partitions * get_ptbl_from_dtb(struct mmc *mmc)
{
	struct partitions * ptbl = NULL;
	unsigned char * buffer = NULL;
	ulong ret, offset;

	/* try get dtb table from ddr, which may exsit while usb burning */
	if (NULL == get_partitions()) {
		/* if failed, try rsv dtb area then. */
		buffer = malloc(RSV_DTB_SIZE);
		if (NULL == buffer) {
			apt_err("Can not alloc enough buffer\n");
			goto _err;
		}
		offset = _get_inherent_offset(MMC_RESERVED_NAME) + RSV_DTB_OFFSET;
		ret = _mmc_rsv_read(mmc, offset, RSV_DTB_SIZE, buffer);
		if (ret != RSV_DTB_SIZE) {
			apt_err("Can not alloc enough buffer\n");
			goto _err1;
		}
		/* parse it */
		if (get_partition_from_dts(buffer)) {
			apt_err("get partition table from dts faild\n");
			goto _err1;
		}
		/* double check part_table(glb) */
		if (NULL == get_partitions()) {
			goto _err1;
		}
		apt_info("get partition table from dts successfully\n");

		free(buffer);
		buffer = NULL;
	}
	/* asign partition info to *ptbl */
	ptbl = get_partitions();
	return ptbl;
_err1:
	if (buffer)
		free(buffer);
_err:
	free (ptbl);
	return NULL;
}
static struct partitions *is_prio_partition(struct _iptbl *list, struct partitions *part)
{
	int i;
	struct partitions *plist = NULL;

	if (list->count == 0)
		goto _out;

	apt_info("count %d\n", list->count);
	for (i=0; i<list->count; i++) {
		plist = &list->partitions[i];
		apt_info("%d: %s, %s\n", i, part->name, plist->name);
		if (!strcmp(plist->name, part->name)) {
			apt_info("%s is prio in list[%d]\n", part->name, i);
			break;
		}
	}
	if (i == list->count)
		plist = NULL;
_out:
	return plist;
}

/*  calculate offset of each partitions.
	bottom is a flag for considering
 */
static int _calculate_offset(struct mmc *mmc, struct _iptbl *itbl, u32 bottom)
{
	int i;
	struct partitions *part;
	ulong  gap = PARTITION_RESERVED;
	int ret = 0;

	if (itbl->count <= 0)
		return -1;
	part = itbl->partitions;
	part->offset = 0;
#if (CONFIG_MPT_DEBUG)
	_dump_part_tbl(part, itbl->count);
#endif
	if (!strcmp(part->name, "bootloader")) {
		gap = MMC_BOOT_PARTITION_RESERVED;
		if (!is_mainstorage_emmc())
			sprintf(part->name, "bootloadere");
	}
	for (i=1; i<itbl->count; i++) {
		/**/
		part[i].offset = part[i-1].offset + part[i-1].size + gap;

		/* check capicity overflow ?*/
		if (((part[i].offset + part[i].size) > mmc->capacity) ||
				(part[i].size == -1)) {

			part[i].size = mmc->capacity - part[i].offset;
			/* reserv space @ the bottom */
			if (bottom && (part[i].size > MMC_BOTTOM_RSV_SIZE)) {
				apt_info("reserv %d bytes at bottom\n", MMC_BOTTOM_RSV_SIZE);
				part[i].size -= MMC_BOTTOM_RSV_SIZE;
			}
			break;
		}
		gap = PARTITION_RESERVED;
	}
	if (i < (itbl->count - 1)) {
		apt_err("too large partition table for current emmc, overflow!\n");
		ret = -1;
	}
#if (CONFIG_MPT_DEBUG)
	_dump_part_tbl(part, itbl->count);
#endif
	return ret;
}

static int _get_version(unsigned char * s)
{
	int version = 0;
	if (!strcmp((char *)s, MMC_MPT_VERSION_2))
		version = 2;
	else if (!strcmp((char *)s, MMC_MPT_VERSION_1))
		version = 1;
	else
		version = -1;

	return version;
}

/*  calc checksum.
	there's a bug on v1 which did not calculate all the partitios.
 */
static int _calc_iptbl_check_v2(struct partitions * part, int count)
{
	int ret = 0, i;
	int size = count * sizeof(struct partitions) >> 2;
	int *buf = (int *)part;

	for (i = 0; i < size; i++)
		ret +=buf[i];

	return ret;
}

static int _calc_iptbl_check_v1(struct partitions *part, int count)
{
    int i, j;
	u32 checksum = 0, *p;

	for (i = 0; i < count; i++) {
		p = (u32*)part;
		/*BUG here, do not fix it!!*/
		for (j = sizeof(struct partitions)/sizeof(checksum); j > 0; j--) {
			checksum += *p;
			p++;
	    }
    }

	return checksum;
}

static int _calc_iptbl_check(struct partitions * part, int count, int version)
{
	if (1 == version)
		return _calc_iptbl_check_v1(part, count);
	else if (2 == version)
		return _calc_iptbl_check_v2(part, count);
	else
		return -1;
}


static struct _iptbl *compose_ept(struct _iptbl *dtb, struct _iptbl *inh)
{
	struct _iptbl *ept = NULL;
	struct partitions *partition = NULL;
	int i;
	struct partitions *dst;
	struct partitions *src;
	struct partitions *prio;
	/* overide inh info by dts */

	partition = malloc(sizeof(struct partitions)*MAX_PART_COUNT);
	if (NULL == partition) {
		apt_err("no enough memory for partitions\n");
		goto _out;
	}

	ept = malloc(sizeof(struct _iptbl));
	if (NULL == ept) {
		apt_err("no enough memory for ept\n");
		free(partition);
		goto _out;
	}
	memset(ept, 0, sizeof(struct _iptbl));
	memset(partition, 0, sizeof(struct partitions)*MAX_PART_COUNT);
	ept->partitions = partition;

	for (i=0; i<MAX_PART_COUNT; i++) {
		apt_info("i %d, ept->count %d\n", i, ept->count);
		dst = &partition[ept->count];
		src = (i < inh->count) ? &inh->partitions[i]:&dtb->partitions[i-inh->count];

		prio = is_prio_partition(ept, src);
		if (prio) {
			/* overide prio partition by new */
			apt_info("override %d: %s\n", ept->count, prio->name);
			//*prio = *src;
			dst = prio;
		} else
			ept->count ++;
		*dst = *src;
		if (-1 == src->size) {
			apt_info("break! %s\n", src->name);
			break;
		}
	}

_out:
	return ept;
}

static struct ptbl_rsv * get_ptbl_rsv(struct mmc *mmc)
{
	struct ptbl_rsv * ptbl_rsv = NULL;
	uchar * buffer = NULL;
	ulong ret, size, offset;
	int checksum, version;

	size = (sizeof(struct ptbl_rsv) + 511) / 512 * 512;
	if (RSV_PTBL_SIZE < size) {
		apt_err("too much partitons\n");
		goto _err;
	}
	buffer = malloc(size);
	if (NULL == buffer) {
		apt_err("no enough memory for ptbl rsv\n");
		return NULL;
	}
	/* read it from emmc. */
	offset = _get_inherent_offset(MMC_RESERVED_NAME) + RSV_PTBL_OFFSET;
	ret = _mmc_rsv_read(mmc, offset, size, buffer);
	if (ret != size) {
		apt_err("read ptbl from rsv failed\n");
		goto _err;
	}

	ptbl_rsv = (struct ptbl_rsv *) buffer;
	apt_info("magic %s, version %s, checksum %x\n", ptbl_rsv->magic,
		ptbl_rsv->version, ptbl_rsv->checksum);
	/* fixme, check magic ?*/
	if (strcmp(ptbl_rsv->magic, MMC_PARTITIONS_MAGIC)) {
		apt_err("magic faild %s, %s\n", MMC_PARTITIONS_MAGIC, ptbl_rsv->magic);
		goto _err;
	}
	/* check version*/
	version = _get_version(ptbl_rsv->version);
	if (version < 0) {
		apt_err("version faild %s, %s\n", MMC_PARTITIONS_MAGIC, ptbl_rsv->magic);
		goto _err;
	}
	/* check sum */
	checksum = _calc_iptbl_check(ptbl_rsv->partitions, ptbl_rsv->count, version);
	if (checksum != ptbl_rsv->checksum) {
		apt_err("checksum faild 0x%x, 0x%x\n", ptbl_rsv->checksum, checksum);
		goto _err;
	}

	return ptbl_rsv;
_err:
	free (buffer);
	return NULL;
}


/* update partition tables from src
	if success, return 0;
	else, return 1
	*/
static int update_ptbl_rsv(struct mmc *mmc, struct _iptbl *src)
{
	struct ptbl_rsv *ptbl_rsv = NULL;
	uchar *buffer;
	ulong size, offset;
	int ret = 0, version;

	size = (sizeof(struct ptbl_rsv) + 511) / 512 * 512;
	buffer = malloc(size);
	if (NULL == buffer) {
		apt_err("no enough memory for ptbl rsv\n");
		return -1;
	}
	memset(buffer, 0 , size);
	/* version, magic and checksum */
	ptbl_rsv = (struct ptbl_rsv *) buffer;
	strcpy((char *)ptbl_rsv->version, MMC_MPT_VERSION);
	strcpy(ptbl_rsv->magic, MMC_PARTITIONS_MAGIC);
	ptbl_rsv->count = src->count;
	memcpy(ptbl_rsv->partitions, src->partitions,
		sizeof(struct partitions)*src->count);
	version = _get_version(ptbl_rsv->version);
	ptbl_rsv->checksum = _calc_iptbl_check(src->partitions, src->count, version);
	/* write it to emmc. */
	apt_info("magic %s, version %s, checksum %x\n", ptbl_rsv->magic, ptbl_rsv->version, ptbl_rsv->checksum);
	offset = _get_inherent_offset(MMC_RESERVED_NAME) + RSV_PTBL_OFFSET;
	if (_mmc_rsv_write(mmc, offset, size, buffer) != size) {
		apt_err("write ptbl to rsv failed\n");
		ret = -1;
		goto _err;
	}
_err:
	free (buffer);
	return ret;
}

static int _cmp_partition(struct partitions *dst, struct partitions *src, int overide)
{
	int ret = 0;

	if (strcmp(dst->name, src->name))
		ret = -2;
	if (dst->size != src->size)
		ret = -3;
	if (dst->offset != src->offset)
		ret = -4;
	if (dst->mask_flags != src->mask_flags)
		ret = -5;

	if (ret && (!overide)) {
		apt_err("name: %s<->%s\n", dst->name, src->name);
		apt_err("size: %llx<->%llx\n", dst->size, src->size);
		apt_err("offset: %llx<->%llx\n", dst->offset, src->offset);
		apt_err("mask: %08x<->%08x\n", dst->mask_flags, src->mask_flags);
	}

	if (overide) {
		*dst = *src;
		ret = 0;
	}

	return ret;
}

/* compare partition tables
	if same, do nothing then return 0;
	else, print the diff ones and return -x
	-1:count
	-2:name
	-3:size
	-4:offset
	*/
static int _cmp_ptbl(struct _iptbl * dst, struct _iptbl * src)
{
	int ret = 0, i = 0;
	struct partitions *dstp;
	struct partitions *srcp;

	if (dst->count != src->count) {
		apt_err("partition count is not same %d:%d\n", dst->count, src->count);
		ret = -1;
		goto _out;
	}

	while (i < dst->count) {
		dstp = &dst->partitions[i];
		srcp = &src->partitions[i];
		ret = _cmp_partition(dstp, srcp, 0);
		if (ret) {
			apt_err("partition %d has changed\n", i);
			break;
		}
		i++;
	}

_out:
	return ret;
}


/*  init devices for each partitions.
	returns 0 means ok.
			other means failure.
	*/
int mmc_device_init (struct mmc *mmc)
{
	int ret = 0;
	/* partition table from dtb */
	struct _iptbl iptbl_dtb;
	/* partition table from emmc rsv area */
	struct _iptbl iptbl_rsv;
	/* partition table from code */
	struct _iptbl iptbl_inh;
	/* partition table stored in emmc */
	struct ptbl_rsv *ptbl_rsv;
	int update = 1;

	/* calculate inherent offset */
	iptbl_inh.count = get_emmc_partition_arraysize();
	if (iptbl_inh.count) {
		iptbl_inh.partitions = emmc_partition_table;
		_calculate_offset(mmc, &iptbl_inh, 0);
	}
	apt_info("inh count %d\n",  iptbl_inh.count);
#if (CONFIG_MPT_DEBUG)
	_dump_part_tbl(iptbl_inh.partitions, iptbl_inh.count);
#endif
	/* get partition table from dtb(ddr or emmc) 1st */
	iptbl_dtb.partitions = get_ptbl_from_dtb(mmc);
	if (NULL == iptbl_dtb.partitions) {
		apt_err("get partition table from dtb failed\n");
		/* fixme, yyh */
		goto _out;
	}
	iptbl_dtb.count = get_partition_count();
	apt_info("dtb %p, count %d\n", iptbl_dtb.partitions, iptbl_dtb.count);
	if (iptbl_inh.count) {
		p_iptbl_ept = compose_ept(&iptbl_dtb, &iptbl_inh);
		if (NULL == p_iptbl_ept) {
			apt_err("compose partition table failed!\n");
			goto _out;
		}
		/* calculate offset infos. considering GAPs */
		if (_calculate_offset(mmc, p_iptbl_ept, 1)) {
			free(p_iptbl_ept);
			p_iptbl_ept = NULL;
			goto _out;
		}
	} else {
		/* report fail, because there is no reserved partitions */
		apt_err("compose partition table failed!\n");
		ret = -1;
		goto _out;
	}

	/* get partiton table from emmc rsv area */
	ptbl_rsv = get_ptbl_rsv(mmc);
	if (ptbl_rsv) {
		iptbl_rsv.partitions = ptbl_rsv->partitions;
		iptbl_rsv.count = ptbl_rsv->count;
		ret = _cmp_ptbl(p_iptbl_ept, &iptbl_rsv);
		if (!ret) {
			update = 0;
		}
		free(ptbl_rsv);
	}

	if (update) {
		ret = update_ptbl_rsv(mmc, p_iptbl_ept);
		/*fixme, comaptible for mbr&ebr */
	#if (CONFIG_PTBL_MBR)
		ret |= update_ptbl_mbr(p_iptbl_ept);
	#endif
	}
	/* init part again 	*/
	init_part(&mmc->block_dev);
_out:
	return ret;
}


struct partitions *find_mmc_partition_by_name (char *name)
{
	struct partitions *partition = NULL;

	if (NULL == p_iptbl_ept)
		goto _out;
	partition = p_iptbl_ept->partitions;
	partition = _find_partition_by_name(partition,
			p_iptbl_ept->count, name);
_out:
	return partition;
}

/*
 find virtual partition in inherent table.
*/
int find_virtual_partition_by_name (char *name, struct partitions *partition)
{
	int ret = 0;
	ulong offset;
	if (NULL == partition)
		return -1;

	offset = _get_inherent_offset(MMC_RESERVED_NAME);
	if (-1 == offset) {
		printf("%s(), can't find %s in inherent\n", __func__, MMC_RESERVED_NAME);
		return -1;
	}

	if (!strcmp(name, "dtb")) {
		strcpy(partition->name, name);
		partition->offset = offset + RSV_DTB_OFFSET;
		partition->size = RSV_DTB_SIZE;
	} else {
		printf("%s(), can't find %s\n", __func__, name);
		ret = -1;
	}

	return ret;
}

int find_dev_num_by_partition_name (char *name)
{
	int dev = -1;

	/* card */
	if (!strcmp(name, MMC_CARD_PARTITION_NAME)) {
		dev = 0;
    } else { /* eMMC OR TSD */
		/* partition name is valid */
		if (find_mmc_partition_by_name(name)) {
			dev = 1;
		}
	}
	return dev;
}

static inline uint64_t get_part_size(struct partitions *part, int num)
{
    return part[num].size;
}

static inline uint64_t get_part_offset(struct partitions *part, int num)
{
    return part[num].offset;
}

static inline char * get_part_name(struct partitions *part, int num)
{
    return (char *)part[num].name;
}

int get_part_info_from_tbl(block_dev_desc_t *dev_desc,
	int num, disk_partition_t *info)
{
    int ret = 0;
    struct partitions *part;

	if (NULL == p_iptbl_ept)
        return -1;
	if (num > (p_iptbl_ept->count-1))
        return -1;
    part = p_iptbl_ept->partitions;

    /*get partition info by index! */
    info->start = (lbaint_t)(get_part_offset(part, num)/dev_desc->blksz);
    info->size = (lbaint_t)(get_part_size(part, num)/dev_desc->blksz);
	info->blksz = dev_desc->blksz;
    strcpy((char *)info->name, get_part_name(part, num));

    return ret;
}
#if (CONFIG_MPT_DEBUG)
void show_partition_info(disk_partition_t *info)
{
	printf("----------%s----------\n", __func__);
	printf("name %s\n", info->name);
	printf("blksz " LBAFU "\n", info->blksz);
	printf("sart %ld\n", info->start);
	printf("size %ld\n", info->size);
	printf("----------end----------\n");
}
#endif

int get_part_info_by_name(block_dev_desc_t *dev_desc,
	const char *name, disk_partition_t *info)
{
	struct partitions *partition = NULL;
	struct partitions virtual;
	int ret = 0;
	cpu_id_t cpu_id = get_cpu_id();

	partition = find_mmc_partition_by_name((char *)name);
	if (partition) {
		info->start = (lbaint_t)(partition->offset/dev_desc->blksz);
		info->size = (lbaint_t)(partition->size/dev_desc->blksz);
		info->blksz = dev_desc->blksz;
		strcpy((char *)info->name, partition->name);
	} else if (!find_virtual_partition_by_name((char *)name, &virtual)) {
		/* try virtual partitions */
		printf("%s(), Got %s in virtual table\n", __func__, name);
		info->start = (lbaint_t)(virtual.offset/dev_desc->blksz);
		info->size = (lbaint_t)(virtual.size/dev_desc->blksz);
		info->blksz = dev_desc->blksz;
		strcpy((char *)info->name, virtual.name);
	} else {
		/* all partitions were tried, fail */
		ret = -1;
		goto _out;
	}
	/* for bootloader */
	if ((0 == info->start) && (cpu_id.family_id >= MESON_CPU_MAJOR_ID_GXL)) {
		info->start = 1;
		info->size -= 1;
	}

#if (CONFIG_MPT_DEBUG)
	show_partition_info(info);
#endif
_out:
	return ret;
}

