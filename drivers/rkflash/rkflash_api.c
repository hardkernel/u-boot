/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#include <common.h>
#include <dm.h>

#include "rkflash_api.h"
#include "rkflash_blk.h"

#ifdef CONFIG_RKSFC_NOR
int rksfc_nor_init(struct udevice *udev)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_init(p_dev);
}

u32 rksfc_nor_get_capacity(struct udevice *udev)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_get_capacity(p_dev);
}

int rksfc_nor_read(struct udevice *udev, u32 sec, u32 n_sec, void *p_data)
{
	u32 ret;
	u32 offset, count = 0;
	char *buf = (char *)p_data;
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	if (sec + n_sec - 1 < FLASH_VENDOR_PART_START ||
	    sec > FLASH_VENDOR_PART_END) {
		ret = snor_read(p_dev, sec, n_sec, p_data);
		if (ret != n_sec)
			return ret;
	} else {
		memset(p_data, 0, 512 * n_sec);
		if (sec < FLASH_VENDOR_PART_START) {
			count = FLASH_VENDOR_PART_START - sec;
			buf = (char *)p_data;
			ret = snor_read(p_dev, sec, count, buf);
			if (ret != count)
				return ret;
		}
		if ((sec + n_sec - 1) > FLASH_VENDOR_PART_END) {
			count = sec + n_sec - 1 - FLASH_VENDOR_PART_END;
			offset = FLASH_VENDOR_PART_END - sec + 1;
			buf = (char *)p_data + offset * 512;
			ret = snor_read(p_dev,
					FLASH_VENDOR_PART_END + 1,
					count, buf);
			if (ret != count)
				return ret;
		}
	}

	return n_sec;
}

/* Workaround for GPT not aligned program */
int rksfc_nor_simply_over_write(struct udevice *udev,
				u32 sec,
				u32 n_sec,
				const void *p_data)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;
	u8 *pbuf_temp;
	u32 addr_aligned, offset, remain;

	addr_aligned = sec / NOR_SECS_PAGE * NOR_SECS_PAGE;
	offset = sec - addr_aligned;
	remain = (offset + n_sec + NOR_SECS_PAGE - 1) / NOR_SECS_PAGE * NOR_SECS_PAGE;

	pbuf_temp = malloc(remain * 512);
	snor_read(p_dev, addr_aligned, remain, pbuf_temp);
	memcpy(pbuf_temp + offset * 512, p_data, n_sec * 512);
	snor_write(p_dev, addr_aligned, remain, pbuf_temp);
	free(pbuf_temp);

	return n_sec;
}

int rksfc_nor_write(struct udevice *udev,
		    u32 sec,
		    u32 n_sec,
		    const void *p_data)
{
	u32 ret;
	u32 offset, count = 0;
	char *buf = (char *)p_data;
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;
	u32 sfc_nor_density = rksfc_nor_get_capacity(udev);

	if (sec >= (sfc_nor_density - 33))
		return rksfc_nor_simply_over_write(udev, sec, n_sec, p_data);

	if (sec + n_sec - 1 < FLASH_VENDOR_PART_START ||
	    sec > FLASH_VENDOR_PART_END) {
		ret = snor_write(p_dev, sec, n_sec, (void *)p_data);
		if (ret != n_sec)
			return ret;
	} else {
		if (sec < FLASH_VENDOR_PART_START) {
			count = FLASH_VENDOR_PART_START - sec;
			buf = (char *)p_data;
			ret = snor_write(p_dev, sec, count, buf);
			if (ret != count)
				return ret;
		}
		if ((sec + n_sec - 1) > FLASH_VENDOR_PART_END) {
			count = sec + n_sec - 1 - FLASH_VENDOR_PART_END;
			offset = FLASH_VENDOR_PART_END - sec + 1;
			buf = (char *)p_data + offset * 512;
			ret = snor_write(p_dev,
					 FLASH_VENDOR_PART_END + 1,
					 count, buf);
			if (ret != count)
				return ret;
		}
	}

	return n_sec;
}

int rksfc_nor_vendor_read(struct blk_desc *dev_desc,
			  u32 sec,
			  u32 n_sec,
			  void *p_data)
{
	struct rkflash_info *priv = dev_get_priv(dev_desc->bdev->parent);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_read(p_dev, sec, n_sec, p_data);
}

int rksfc_nor_vendor_write(struct blk_desc *dev_desc,
			   u32 sec,
			   u32 n_sec,
			   void *p_data)
{
	struct rkflash_info *priv = dev_get_priv(dev_desc->bdev->parent);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_write(p_dev, sec, n_sec, p_data);
}

#endif

#ifdef CONFIG_RKSFC_NAND
int rksfc_nand_init(struct udevice *udev)
{
	int ret;

	ret = sfc_nand_init();
	if (ret) {
		return ret;
	} else {
		sfc_nand_ftl_ops_init();

		return sftl_init();
	}
}

int rksfc_nand_read(struct udevice *udev, u32 index, u32 count, void *buf)
{
	int ret;

	ret = sftl_read(index, count, (u8 *)buf);
	if (!ret)
		return count;
	else
		return -EIO;
}

int rksfc_nand_write(struct udevice *udev,
		     u32 index,
		     u32 count,
		     const void *buf)
{
	int ret;

	ret = sftl_write(index, count, (u8 *)buf);
	if (!ret)
		return count;
	else
		return -EIO;
}

u32 rksfc_nand_get_density(struct udevice *udev)
{
	return sftl_get_density();
}

int rksfc_nand_vendor_read(struct blk_desc *dev_desc,
			   u32 sec,
			   u32 n_sec,
			   void *p_data)
{
	int ret;

	ret = sftl_vendor_read(sec, n_sec, (u8 *)p_data);
	if (!ret)
		return n_sec;
	else
		return -EIO;
}

int rksfc_nand_vendor_write(struct blk_desc *dev_desc,
			    u32 sec,
			    u32 n_sec,
			    void *p_data)
{
	int ret;

	ret = sftl_vendor_write(sec, n_sec, (u8 *)p_data);
	if (!ret)
		return n_sec;
	else
		return -EIO;
}

#endif

#ifdef CONFIG_RKNANDC_NAND
int rknand_flash_init(struct udevice *udev)
{
	return sftl_init();
}

int rknand_flash_read(struct udevice *udev, u32 index, u32 count, void *buf)
{
	int ret;

	ret = sftl_read(index, count, (u8 *)buf);
	if (!ret)
		return count;
	else
		return -EIO;
}

int rknand_flash_write(struct udevice *udev,
		       u32 index,
		       u32 count,
		       const void *buf)
{
	int ret;

	ret = sftl_write(index, count, (u8 *)buf);
	if (!ret)
		return count;
	else
		return -EIO;
}

u32 rknand_flash_get_density(struct udevice *udev)
{
	return sftl_get_density();
}

int rknand_flash_vendor_read(struct blk_desc *dev_desc,
			     u32 sec,
			     u32 n_sec,
			     void *p_data)
{
	int ret;

	ret = sftl_vendor_read(sec, n_sec, (u8 *)p_data);
	if (!ret)
		return n_sec;
	else
		return -EIO;
}

int rknand_flash_vendor_write(struct blk_desc *dev_desc,
			      u32 sec,
			      u32 n_sec,
			      void *p_data)
{
	int ret;

	ret = sftl_vendor_write(sec, n_sec, (u8 *)p_data);
	if (!ret)
		return n_sec;
	else
		return -EIO;
}

#endif
