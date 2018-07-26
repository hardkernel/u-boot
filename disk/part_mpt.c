#include <common.h>
#include <malloc.h>
#include <inttypes.h>
#include <storage.h>
#include <mmc.h>
#include <errno.h>

#define NR_MAX_PARTS		32

struct ptable_t {
    char magic[4];
    char version[12];
    int nr_parts;
    int checksum;
    struct partitions partitions[NR_MAX_PARTS];
};

#define MPT_MAGIC		"MPT"
#define MPT_VERSION		"01.00.00"

static u32 mpt_partition_checksum_v1(const struct partitions *part, int count)
{
	u32 sum = 0;

	while (count--) {
		u32 *p = (u32*)part;

		int j = sizeof(struct partitions) / sizeof(sum);
		for(; j > 0; j--)
			sum += *p++;
	}

	return sum;
}

static int is_mpt_valid(const struct ptable_t* mpt, int strict)
{
	if (strncmp(mpt->magic, MPT_MAGIC, strlen(MPT_MAGIC))
			|| strncmp(mpt->version, MPT_VERSION, strlen(MPT_VERSION))
			|| (mpt->nr_parts <= 0 || mpt->nr_parts > NR_MAX_PARTS))
		return 0;

	if (strict) {
		if (mpt->checksum != mpt_partition_checksum_v1(mpt->partitions,
					mpt->nr_parts))
			return 0;
	}

	return 1;
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

int mpt_write_partitions(struct mmc *mmc, struct partitions *partitions, int nr_parts)
{
	size_t size = (sizeof(struct ptable_t) + 511) / 512 * 512;
	int ret = 0;

	struct ptable_t *ptable = (struct ptable_t *)malloc(size);
	if (ptable == NULL)
		return -ENOMEM;

	memset(ptable, 0, size);

	strncpy(ptable->version, MPT_VERSION, strlen(MPT_VERSION));
	strncpy(ptable->magic, MPT_MAGIC, strlen(MPT_MAGIC));
	memcpy(ptable->partitions, partitions, sizeof(struct partitions) * nr_parts);
	ptable->checksum = mpt_partition_checksum_v1(partitions, nr_parts);
	ptable->nr_parts = nr_parts;

	/* write it to emmc. */
	if (_mmc_rsv_write(mmc, CONFIG_PTABLE_OFFSET, size, ptable) != size) {
		ret = -EIO;
		goto err_mpt_write;
	}

err_mpt_write:
	free(ptable);

	return ret;
}

int get_partition_info_mpt(block_dev_desc_t *dev_desc,
		int part_num, disk_partition_t *info)
{
	int ret = 0;

	if (!dev_desc || !info || ((part_num < 0) || (part_num > NR_MAX_PARTS)))
		return -EINVAL;

	size_t size = ROUND(sizeof(struct ptable_t), dev_desc->blksz);
	struct ptable_t *ptable = (struct ptable_t *)malloc(size);
	if (ptable == NULL)
		return -ENOMEM;

	memset(ptable, 0, size);

	lbaint_t blks = size / dev_desc->blksz;
	lbaint_t n = dev_desc->block_read(dev_desc->dev,
			CONFIG_PTABLE_OFFSET / dev_desc->blksz, blks, ptable);
	if (n != blks) {
		ret = -EIO;
		goto err_get_partition;
	}

	if (!is_mpt_valid(ptable, 1)) {
		ret = -EINVAL;
		goto err_get_partition;
	}

	struct partitions *part = &ptable->partitions[part_num];
	if (part->size == 0) {
		ret = -ENOENT;
		goto err_get_partition;
	}

	memset(info, 0, sizeof(disk_partition_t));
	strncpy((char*)info->name, part->name, sizeof(((disk_partition_t*)0)->name));
	info->start = part->offset;
	info->size = part->size;
	info->blksz = dev_desc->blksz;

err_get_partition:
	free(ptable);

	return ret;
}

int get_partition_info_mpt_by_name(block_dev_desc_t *dev_desc,
	const char *name, disk_partition_t *info)
{
	int ret;
	int i;

	for (i = 0; i < NR_MAX_PARTS; i++) {
		ret = get_partition_info_mpt(dev_desc, i, info);
		if (ret != 0)
			return ret;

		if (strcmp(name, (const char *)info->name) == 0)
			return 0;
	}

	return -ENOENT;
}

void print_part_mpt(block_dev_desc_t *dev_desc)
{
	disk_partition_t info;
	int ret;
	int i;

	for (i = 0; i < NR_MAX_PARTS; i++) {
		ret = get_partition_info_mpt(dev_desc, i, &info);
		if (ret != 0)
			break;

		printf("ptn %d name=%s start=" LBAFU " size=" LBAFU "\n",
				i, info.name, info.start, info.size);
	}
}

int test_part_mpt(block_dev_desc_t *dev_desc)
{
	ALLOC_CACHE_ALIGN_BUFFER(unsigned char, buffer, dev_desc->blksz);

	if (dev_desc->block_read(dev_desc->dev,
			CONFIG_PTABLE_OFFSET / dev_desc->blksz, 1, buffer) != 1)
		return -EINVAL;

	if (!is_mpt_valid((const struct ptable_t*)buffer, 0))
		return -EINVAL;

	return 0;
}
