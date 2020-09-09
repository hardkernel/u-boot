/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <adc.h>
#include <android_bootloader.h>
#include <android_image.h>
#include <boot_rkimg.h>
#include <bmp_layout.h>
#include <malloc.h>
#include <asm/io.h>
#include <asm/unaligned.h>
#include <dm/ofnode.h>
#include <linux/list.h>
#include <asm/arch/resource_img.h>

DECLARE_GLOBAL_DATA_PTR;

#define PART_RESOURCE			"resource"
#define RESOURCE_MAGIC			"RSCE"
#define RESOURCE_MAGIC_SIZE		4
#define RESOURCE_VERSION		0
#define CONTENT_VERSION			0
#define ENTRY_TAG			"ENTR"
#define ENTRY_TAG_SIZE			4
#define MAX_FILE_NAME_LEN		220
#define MAX_HASH_LEN			32
#define DTB_FILE			"rk-kernel.dtb"

/*
 *         resource image structure
 * ----------------------------------------------
 * |                                            |
 * |    header  (1 block)                       |
 * |                                            |
 * ---------------------------------------------|
 * |                      |                     |
 * |    entry0  (1 block) |                     |
 * |                      |                     |
 * ------------------------                     |
 * |                      |                     |
 * |    entry1  (1 block) | contents (n blocks) |
 * |                      |                     |
 * ------------------------                     |
 * |    ......            |                     |
 * ------------------------                     |
 * |                      |                     |
 * |    entryn  (1 block) |                     |
 * |                      |                     |
 * ----------------------------------------------
 * |                                            |
 * |    file0  (x blocks)                       |
 * |                                            |
 * ----------------------------------------------
 * |                                            |
 * |    file1  (y blocks)                       |
 * |                                            |
 * ----------------------------------------------
 * |                   ......                   |
 * |---------------------------------------------
 * |                                            |
 * |    filen  (z blocks)                       |
 * |                                            |
 * ----------------------------------------------
 */

/**
 * struct resource_image_header
 *
 * @magic: should be "RSCE"
 * @version: resource image version, current is 0
 * @c_version: content version, current is 0
 * @blks: the size of the header ( 1 block = 512 bytes)
 * @c_offset: contents offset(by block) in the image
 * @e_blks: the size(by block) of the entry in the contents
 * @e_num: numbers of the entrys.
 */

struct resource_img_hdr {
	char		magic[4];
	uint16_t	version;
	uint16_t	c_version;
	uint8_t		blks;
	uint8_t		c_offset;
	uint8_t		e_blks;
	uint32_t	e_nums;
};

struct resource_entry {
	char		tag[4];
	char		name[MAX_FILE_NAME_LEN];
	char		hash[MAX_HASH_LEN];
	uint32_t	hash_size;
	uint32_t	f_offset;	/* Sector offset */
	uint32_t	f_size;		/* Bytes */
};

struct resource_file {
	char		name[MAX_FILE_NAME_LEN];
	char		hash[MAX_HASH_LEN];
	uint32_t	hash_size;
	uint32_t	f_offset;	/* Sector offset */
	uint32_t	f_size;		/* Bytes */
	struct list_head link;
	/* Sector base of resource when ram=false, byte base when ram=true */
	uint32_t	rsce_base;
	bool		ram;
};

static LIST_HEAD(entrys_head);

int resource_image_check_header(void *rsce_hdr)
{
	struct resource_img_hdr *hdr = rsce_hdr;
	int ret;

	ret = memcmp(RESOURCE_MAGIC, hdr->magic, RESOURCE_MAGIC_SIZE);
	if (ret) {
		debug("bad resource image magic: %s\n",
		      hdr->magic ? hdr->magic : "none");
		ret = -EINVAL;
	}

	debug("resource image header:\n");
	debug("magic:%s\n", hdr->magic);
	debug("version:%d\n", hdr->version);
	debug("c_version:%d\n", hdr->c_version);
	debug("blks:%d\n", hdr->blks);
	debug("c_offset:%d\n", hdr->c_offset);
	debug("e_blks:%d\n", hdr->e_blks);
	debug("e_num:%d\n", hdr->e_nums);

	return ret;
}

static int add_file_to_list(struct resource_entry *entry,
			    int rsce_base, bool ram)
{
	struct resource_file *file;

	if (memcmp(entry->tag, ENTRY_TAG, ENTRY_TAG_SIZE)) {
		printf("invalid entry tag\n");
		return -ENOENT;
	}

	file = malloc(sizeof(*file));
	if (!file) {
		printf("out of memory\n");
		return -ENOMEM;
	}

	strcpy(file->name, entry->name);
	file->rsce_base = rsce_base;
	file->f_offset = entry->f_offset;
	file->f_size = entry->f_size;
	file->hash_size = entry->hash_size;
	file->ram = ram;
	memcpy(file->hash, entry->hash, entry->hash_size);
	list_add_tail(&file->link, &entrys_head);

	debug("entry: %p, %18s, base: 0x%08x, offset: 0x%08x, size: 0x%08x\n",
	      entry, file->name, file->rsce_base, file->f_offset, file->f_size);

	return 0;
}

static int replace_resource_entry(const char *f_name, uint32_t base,
				  uint32_t f_offset, uint32_t f_size)
{
	struct resource_entry *entry;
	struct resource_file *file;
	struct list_head *node;

	if (!f_name || !f_size)
		return -EINVAL;

	entry = calloc(1, sizeof(*entry));
	if (!entry)
		return -ENOMEM;

	strcpy(entry->tag, ENTRY_TAG);
	strcpy(entry->name, f_name);
	entry->f_offset = f_offset;
	entry->f_size = f_size;
	entry->hash_size = 0;

	/* Delete exist entry, then add this new */
	list_for_each(node, &entrys_head) {
		file = list_entry(node, struct resource_file, link);
		if (!strcmp(file->name, entry->name)) {
			list_del(&file->link);
			free(file);
			break;
		}
	}

	add_file_to_list(entry, base, false);
	free(entry);

	return 0;
}

static int read_bmp(struct blk_desc *dev_desc, const char *name,
		    disk_partition_t *part, uint32_t offset,
		    uint32_t *size)
{
	struct bmp_header *header;
	u32 blk_start, blk_offset;
	u32 filesz;
	int ret;

	blk_offset = DIV_ROUND_UP(offset, dev_desc->blksz);
	blk_start = part->start + blk_offset;
	header = memalign(ARCH_DMA_MINALIGN, dev_desc->blksz);
	if (!header) {
		ret = -ENOMEM;
		goto out;
	}

	if (blk_dread(dev_desc, blk_start, 1, header) != 1) {
		ret = -EIO;
		goto out;
	}

	if (header->signature[0] != 'B' || header->signature[1] != 'M') {
		ret = -EINVAL;
		goto out;
	}

	filesz = get_unaligned_le32(&header->file_size);
	ret = replace_resource_entry(name, blk_start, blk_offset, filesz);
	if (!ret) {
		printf("LOGO: %s\n", name);
		if (size)
			*size = filesz;
	}
out:
	free(header);

	return ret;
}

/*
 * Add logo.bmp and logo_kernel.bmp from "logo" parititon
 *
 * Provide a "logo" partition for user to store logo.bmp and
 * logo_kernel.bmp, so that the user can update them from
 * kernel or user-space dynamically.
 *
 * "logo" partition layout, do not change order:
 *
 *   |----------------------| 0x00
 *   | raw logo.bmp	    |
 *   |----------------------| N*512-byte aligned
 *   | raw logo_kernel.bmp  |
 *   |----------------------|
 *
 * N: the sector count of logo.bmp
 */
static int read_logo_bmps(struct blk_desc *dev_desc)
{
	disk_partition_t part;
	u32 filesz;

	if (part_get_info_by_name(dev_desc, PART_LOGO, &part) < 0)
		return -ENODEV;

	if (!read_bmp(dev_desc, "logo.bmp", &part, 0, &filesz))
		read_bmp(dev_desc, "logo_kernel.bmp", &part, filesz, NULL);

	return 0;
}

int resource_create_ram_list(struct blk_desc *dev_desc, void *rsce_hdr)
{
	struct resource_img_hdr *hdr = rsce_hdr;
	struct resource_entry *entry;
	int e_num, size;
	void *data;
	int ret = 0;

	if (resource_image_check_header(hdr)) {
		ret = -EINVAL;
		goto out;
	}

	data = (void *)((ulong)hdr + hdr->c_offset * dev_desc->blksz);
	for (e_num = 0; e_num < hdr->e_nums; e_num++) {
		size = e_num * hdr->e_blks * dev_desc->blksz;
		entry = (struct resource_entry *)(data + size);
		add_file_to_list(entry, (ulong)hdr, true);
	}
out:
	read_logo_bmps(dev_desc);

	return ret;
}

static int resource_create_list(struct blk_desc *dev_desc, int rsce_base)
{
	struct resource_img_hdr *hdr;
	struct resource_entry *entry;
	int blknum, e_num;
	void *data = NULL;
	int ret = 0;
	int size;

	hdr = memalign(ARCH_DMA_MINALIGN, dev_desc->blksz);
	if (!hdr)
		return -ENOMEM;

	if (blk_dread(dev_desc, rsce_base, 1, hdr) != 1) {
		printf("Failed to read resource hdr\n");
		ret = -EIO;
		goto err;
	}

	if (resource_image_check_header(hdr)) {
		if (fdt_check_header(hdr)) {
			printf("No valid resource or dtb file\n");
			ret = -EINVAL;
			goto err;
		} else {
			free(hdr);
			return replace_resource_entry(DTB_FILE, rsce_base,
						      0, fdt_totalsize(hdr));
		}
	}

	blknum = hdr->e_blks * hdr->e_nums;
	data = memalign(ARCH_DMA_MINALIGN, blknum * dev_desc->blksz);
	if (!data) {
		ret = -ENOMEM;
		goto err;
	}

	if (blk_dread(dev_desc, rsce_base + hdr->c_offset,
		      blknum, data) != blknum) {
		printf("Failed to read resource entries\n");
		ret = -EIO;
		goto err;
	}

	/*
	 * Add all file into resource file list, and load what we want from
	 * storage when we really need it.
	 */
	for (e_num = 0; e_num < hdr->e_nums; e_num++) {
		size = e_num * hdr->e_blks * dev_desc->blksz;
		entry = (struct resource_entry *)(data + size);
		add_file_to_list(entry, rsce_base, false);
	}

err:
	if (data)
		free(data);
	if (hdr)
		free(hdr);

	read_logo_bmps(dev_desc);

	return ret;
}

static int read_dtb_from_android(struct blk_desc *dev_desc,
				 struct andr_img_hdr *hdr,
				 ulong rsce_base)
{
	ulong dtb_offset = 0;
	ulong dtb_size = 0;

	if (!hdr || hdr->header_version <= 1) {
		return 0;
	} else if (hdr->header_version == 2) {
		dtb_offset += hdr->page_size;
		dtb_offset += ALIGN(hdr->kernel_size, hdr->page_size);
		dtb_offset += ALIGN(hdr->ramdisk_size, hdr->page_size);
		dtb_offset += ALIGN(hdr->recovery_dtbo_size, hdr->page_size) +
			      ALIGN(hdr->second_size, hdr->page_size);
		dtb_size = hdr->dtb_size;
	} else if (hdr->header_version == 3) {
		dtb_offset += ALIGN(VENDOR_BOOT_HDR_SIZE,
				    hdr->vendor_page_size) +
			      ALIGN(hdr->vendor_ramdisk_size,
				    hdr->vendor_page_size);
		dtb_size = hdr->dtb_size;
	}

	if (!dtb_size)
		return 0;

	/*
	 * boot_img_hdr_v2,3 feature.
	 *
	 * If dtb position is present, replace the old with new one if
	 * we don't need to verify DTB hash from resource.img file entry.
	 */
	dtb_offset = DIV_ROUND_UP(dtb_offset, dev_desc->blksz);
#ifndef CONFIG_ROCKCHIP_DTB_VERIFY
	if (replace_resource_entry(DTB_FILE, rsce_base, dtb_offset, dtb_size))
		printf("Failed to load dtb from v2 dtb position\n");
	else
#endif
		env_update("bootargs", "androidboot.dtb_idx=0");

	return 0;
}

static int get_resource_base_sector(struct blk_desc *dev_desc,
				    struct andr_img_hdr **ret_hdr)
{
	disk_partition_t part;
	int rsce_base = 0;
#ifdef CONFIG_ANDROID_BOOT_IMAGE
	struct andr_img_hdr *hdr;
	u32 os_ver = 0, os_lvl;

	/*
	 * Anyway, we must read android hdr firstly from boot partition to get
	 * the 'os_version' for android_bcb_msg_sector_offset(), in order to
	 * confirm BCB message offset of *MISC* partition.
	 */
	if (part_get_info_by_name(dev_desc, PART_BOOT, &part) < 0)
		goto resource_part;

	hdr = populate_andr_img_hdr(dev_desc, &part);
	if (hdr) {
		os_ver = hdr->os_version >> 11;
		os_lvl = hdr->os_version & ((1U << 11) - 1);
		if (os_ver)
			gd->bd->bi_andr_version = hdr->os_version;
	}

#ifndef CONFIG_ANDROID_AB
	/* Get boot mode from misc and read if recovery mode */
	if (rockchip_get_boot_mode() == BOOT_MODE_RECOVERY) {
		if (hdr)
			free(hdr);

		if (part_get_info_by_name(dev_desc, PART_RECOVERY, &part) < 0)
			goto resource_part;

		hdr = populate_andr_img_hdr(dev_desc, &part);
		if (!hdr)
			goto resource_part;
	}
#endif
	/* If Android v012, getting resource from second position ! */
	if (hdr) {
		if (os_ver)
			printf("Android %u.%u, Build %u.%u, v%d\n",
			       (os_ver >> 14) & 0x7F, (os_ver >> 7) & 0x7F,
			       (os_lvl >> 4) + 2000, os_lvl & 0x0F,
			       hdr->header_version);
		*ret_hdr = hdr;
		if (hdr->header_version < 3) {
			rsce_base = part.start * dev_desc->blksz;
			rsce_base += hdr->page_size;
			rsce_base += ALIGN(hdr->kernel_size, hdr->page_size);
			rsce_base += ALIGN(hdr->ramdisk_size, hdr->page_size);
			rsce_base = DIV_ROUND_UP(rsce_base, dev_desc->blksz);
			goto finish;
		}
	}
resource_part:
#endif
	/* resource partition */
	if (part_get_info_by_name(dev_desc, PART_RESOURCE, &part) < 0) {
		printf("No resource partition\n");
		return -ENODEV;
	} else {
		rsce_base = part.start;
	}
#ifdef CONFIG_ANDROID_BOOT_IMAGE
finish:
#endif
	printf("Found DTB in %s part\n", part.name);

	return rsce_base;
}

/*
 * There are: logo/battery pictures and dtb file in the resource image by default.
 *
 * This function does:
 *
 * 1. Get resource image base sector from: boot/recovery(AOSP) > resource(RK)
 * 2. Create resource files list(addition: add logo bmps)
 * 3. Add dtb from android v2 dtb pos, override the old one from resource file
 */
static int init_resource_list(void)
{
	struct andr_img_hdr *hdr = NULL;
	struct blk_desc *dev_desc;
	int rsce_base;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("No dev_desc!\n");
		return -ENODEV;
	}

	rsce_base = get_resource_base_sector(dev_desc, &hdr);
	if (rsce_base > 0) {
		if (resource_create_list(dev_desc, rsce_base))
			printf("Failed to create resource list\n");
	}

	/* override the resource dtb with android dtb if need */
	return read_dtb_from_android(dev_desc, hdr, rsce_base);
}

static struct resource_file *get_file_info(const char *name)
{
	struct resource_file *file;
	struct list_head *node;

	if (list_empty(&entrys_head)) {
		if (init_resource_list())
			return NULL;
	}

	list_for_each(node, &entrys_head) {
		file = list_entry(node, struct resource_file, link);
		if (!strcmp(file->name, name))
			return file;
	}

	return NULL;
}

/*
 * read file from resource partition
 * @buf: destination buf to store file data;
 * @name: file name
 * @offset: blocks offset in the file, 1 block = 512 bytes
 * @len: the size(by bytes) of file to read.
 */
int rockchip_read_resource_file(void *buf, const char *name,
				int offset, int len)
{
	struct resource_file *file;
	struct blk_desc *dev_desc;
	int ret = 0;
	int blks;
	ulong src;

	file = get_file_info(name);
	if (!file) {
		printf("No file: %s\n", name);
		return -ENOENT;
	}

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("No dev_desc!\n");
		return -ENODEV;
	}

	if (len <= 0 || len > file->f_size)
		len = file->f_size;

	if (file->ram) {
		src = file->rsce_base +
			(file->f_offset + offset) * dev_desc->blksz;
		memcpy(buf, (char *)src, len);
		ret = len;
	} else {
		blks = DIV_ROUND_UP(len, dev_desc->blksz);
		ret = blk_dread(dev_desc,
				file->rsce_base + file->f_offset + offset,
				blks, buf);
		ret = (ret != blks) ? -EIO : len;
	}

	return ret;
}

#ifdef CONFIG_ROCKCHIP_HWID_DTB
#define is_digit(c)		((c) >= '0' && (c) <= '9')
#define is_abcd(c)		((c) >= 'a' && (c) <= 'd')
#define is_equal(c)		((c) == '=')

#define KEY_WORDS_ADC_CTRL	"#_"
#define KEY_WORDS_ADC_CH	"_ch"
#define KEY_WORDS_GPIO		"#gpio"
#define GPIO_SWPORT_DDR		0x04
#define GPIO_EXT_PORT		0x50
#define MAX_ADC_CH_NR		10
#define MAX_GPIO_NR		10

/*
 * How to make it works ?
 *
 * 1. pack dtb into rockchip resource.img, require:
 *    (1) file name end with ".dtb";
 *    (2) file name contains key words, like: ...#_[controller]_ch[channel]=[value]...dtb
 *	  @controller: adc controller name in dts, eg. "saradc", ...;
 *	  @channel: adc channel;
 *	  @value: adc value;
 *    eg: ...#_saradc_ch1=223#_saradc_ch2=650....dtb
 *
 * 2. U-Boot dtsi about adc controller node:
 *    (1) enable "u-boot,dm-pre-reloc;";
 *    (2) must set status "okay";
 */
static int rockchip_read_dtb_by_adc(const char *file_name)
{
	static int cached_v[MAX_ADC_CH_NR];
	int offset_ctrl = strlen(KEY_WORDS_ADC_CTRL);
	int offset_ch = strlen(KEY_WORDS_ADC_CH);
	int ret, channel, len = 0, found = 0, margin = 30;
	char *stradc, *strch, *p;
	char adc_v_string[10];
	char dev_name[32];
	uint32_t raw_adc;
	ulong dtb_adc;

	debug("%s: %s\n", __func__, file_name);

	/* Invalid format ? */
	stradc = strstr(file_name, KEY_WORDS_ADC_CTRL);
	while (stradc) {
		debug("   - substr: %s\n", stradc);

		/* Parse controller name */
		strch = strstr(stradc, KEY_WORDS_ADC_CH);
		len = strch - (stradc + offset_ctrl);
		strlcpy(dev_name, stradc + offset_ctrl, len + 1);

		/* Parse adc channel */
		p = strch + offset_ch;
		if (is_digit(*p) && is_equal(*(p + 1))) {
			channel = *p - '0';
		} else {
			debug("   - invalid format: %s\n", stradc);
			return -EINVAL;
		}

		/*
		 * Read raw adc value
		 *
		 * It doesn't need to read adc value every loop, reading once
		 * is enough. We use cached_v[] to save what we have read, zero
		 * means not read before.
		 */
		if (cached_v[channel] == 0) {
			ret = adc_channel_single_shot(dev_name,
						      channel, &raw_adc);
			if (ret) {
				debug("   - failed to read adc, ret=%d\n", ret);
				return ret;
			}
			cached_v[channel] = raw_adc;
		}

		/* Parse dtb adc value */
		p = strch + offset_ch + 2;	/* 2: channel and '=' */
		while (*p && is_digit(*p)) {
			len++;
			p++;
		}
		strlcpy(adc_v_string, strch + offset_ch + 2, len + 1);
		dtb_adc = simple_strtoul(adc_v_string, NULL, 10);

		if (abs(dtb_adc - cached_v[channel]) <= margin) {
			found = 1;
			stradc = strstr(p, KEY_WORDS_ADC_CTRL);
		} else {
			found = 0;
			break;
		}

		debug("   - parse: controller=%s, channel=%d, dtb_adc=%ld, read=%d %s\n",
		      dev_name, channel, dtb_adc, cached_v[channel], found ? "(Y)" : "");
	}

	return found ? 0 : -ENOENT;
}

static int gpio_parse_base_address(fdt_addr_t *gpio_base_addr)
{
	static int initialized;
	ofnode parent, node;
	const char *name;
	int idx, nr = 0;

	if (initialized)
		return 0;

	parent = ofnode_path("/pinctrl");
	if (!ofnode_valid(parent)) {
		debug("   - Can't find pinctrl node\n");
		return -EINVAL;
	}

	ofnode_for_each_subnode(node, parent) {
		if (!ofnode_get_property(node, "gpio-controller", NULL)) {
			debug("   - Can't find gpio-controller\n");
			continue;
		}

		name = ofnode_get_name(node);
		if (!is_digit((char)*(name + 4))) {
			debug("   - bad gpio node name: %s\n", name);
			continue;
		}

		nr++;
		idx = *(name + 4) - '0';
		gpio_base_addr[idx] = ofnode_get_addr(node);
		debug("   - gpio%d: 0x%x\n", idx, (uint32_t)gpio_base_addr[idx]);
	}

	if (nr == 0) {
		debug("   - parse gpio address failed\n");
		return -EINVAL;
	}

	initialized = 1;

	return 0;
}

/*
 * How to make it works ?
 *
 * 1. pack dtb into rockchip resource.img, require:
 *    (1) file name end with ".dtb";
 *    (2) file name contains key words, like: ...#gpio[pin]=[value]...dtb
 *	  @pin: gpio name, eg. 0a2 means GPIO0A2;
 *	  @value: gpio level, 0 or 1;
 *    eg: ...#gpio0a6=1#gpio1c2=0....dtb
 *
 * 2. U-Boot dtsi about gpio node:
 *    (1) enable "u-boot,dm-pre-reloc;" for all gpio node;
 *    (2) set all gpio status "disabled"(Because we just want their property);
 */
static int rockchip_read_dtb_by_gpio(const char *file_name)
{
	static uint32_t cached_v[MAX_GPIO_NR];
	fdt_addr_t gpio_base_addr[MAX_GPIO_NR];
	int ret, found = 0, offset = strlen(KEY_WORDS_GPIO);
	uint8_t port, pin, bank, lvl, val;
	char *strgpio, *p;
	uint32_t bit;

	debug("%s\n", file_name);

	/* Parse gpio address */
	memset(gpio_base_addr, 0, sizeof(gpio_base_addr));
	ret = gpio_parse_base_address(gpio_base_addr);
	if (ret) {
		debug("   - Can't parse gpio base address: %d\n", ret);
		return ret;
	}

	strgpio = strstr(file_name, KEY_WORDS_GPIO);
	while (strgpio) {
		debug("   - substr: %s\n", strgpio);

		p = strgpio + offset;

		/* Invalid format ? */
		if (!(is_digit(*(p + 0)) && is_abcd(*(p + 1)) &&
		      is_digit(*(p + 2)) && is_equal(*(p + 3)) &&
		      is_digit(*(p + 4)))) {
			debug("   - invalid format: %s\n", strgpio);
			return -EINVAL;
		}

		/* Read gpio value */
		port = *(p + 0) - '0';
		bank = *(p + 1) - 'a';
		pin  = *(p + 2) - '0';
		lvl  = *(p + 4) - '0';

		/*
		 * It doesn't need to read gpio value every loop, reading once
		 * is enough. We use cached_v[] to save what we have read, zero
		 * means not read before.
		 */
		if (cached_v[port] == 0) {
			if (!gpio_base_addr[port]) {
				debug("   - can't find gpio%d base address\n", port);
				return 0;
			}

			/* Input mode */
			val = readl(gpio_base_addr[port] + GPIO_SWPORT_DDR);
			val &= ~(1 << (bank * 8 + pin));
			writel(val, gpio_base_addr[port] + GPIO_SWPORT_DDR);

			cached_v[port] =
				readl(gpio_base_addr[port] + GPIO_EXT_PORT);
		}

		/* Verify result */
		bit = bank * 8 + pin;
		val = cached_v[port] & (1 << bit) ? 1 : 0;

		if (val == !!lvl) {
			found = 1;
			strgpio = strstr(p, KEY_WORDS_GPIO);
		} else {
			found = 0;
			break;
		}

		debug("   - parse: gpio%d%c%d=%d, read=%d %s\n",
		      port, bank + 'a', pin, lvl, val, found ? "(Y)" : "(N)");
	}

	return found ? 0 : -ENOENT;
}

/* Get according to hardware id(GPIO/ADC) */
static struct resource_file *rockchip_read_hwid_dtb(void)
{
	struct resource_file *file;
	struct list_head *node;

	if (list_empty(&entrys_head)) {
		if (init_resource_list())
			return NULL;
	}

	/* Find dtb file according to hardware id(GPIO/ADC) */
	list_for_each(node, &entrys_head) {
		file = list_entry(node, struct resource_file, link);
		if (!strstr(file->name, ".dtb"))
			continue;

		if (strstr(file->name, KEY_WORDS_ADC_CTRL) &&
		    strstr(file->name, KEY_WORDS_ADC_CH) &&
		    !rockchip_read_dtb_by_adc(file->name)) {
			return file;
		} else if (strstr(file->name, KEY_WORDS_GPIO) &&
			   !rockchip_read_dtb_by_gpio(file->name)) {
			return file;
		}
	}

	return NULL;
}
#endif

int rockchip_read_resource_dtb(void *fdt_addr, char **hash, int *hash_size)
{
	struct resource_file *file;
	int ret;

#ifdef CONFIG_ROCKCHIP_HWID_DTB
	file = rockchip_read_hwid_dtb();
	/* If dtbs matched hardware id(GPIO/ADC) not found, try the default */
	if (!file)
		file = get_file_info(DTB_FILE);
#else
	file = get_file_info(DTB_FILE);
#endif
	if (!file)
		return -ENODEV;

	ret = rockchip_read_resource_file(fdt_addr, file->name, 0, 0);
	if (ret < 0)
		return ret;

	if (fdt_check_header(fdt_addr))
		return -EBADF;

	*hash = file->hash;
	*hash_size = file->hash_size;
	printf("DTB: %s\n", file->name);

	return 0;
}
