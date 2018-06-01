/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#include <blk.h>

#include "rkflash_debug.h"
#include "rkflash_blk.h"

void rkflash_print_hex(char *s, void *buf, u32 width, u32 len)
{
	u32 i, j;
	char *p8 = (char *)buf;
	short *p16 = (short *)buf;
	u32 *p32 = (u32 *)buf;

	j = 0;
	for (i = 0; i < len; i++) {
		if (j == 0)
			printf("%s 0x%x:", s, i * width);

		if (width == 4)
			printf("%x ", p32[i]);
		else if (width == 2)
			printf("%x ", p16[i]);
		else
			printf("%02x ", p8[i]);
		if (++j >= 16) {
			j = 0;
			printf("\n");
		}
	}
	printf("\n");
}

#if (BLK_STRESS_TEST_EN)
#define max_test_sector 64
static u8 pwrite[max_test_sector * 512];
static u8 pread[max_test_sector * 512];
static u32 *pwrite32;
void blk_stress_test(struct udevice *udev)
{
	struct blk_desc *block_dev = dev_get_uclass_platdata(udev);
	struct rkflash_info *priv = dev_get_priv(udev->parent);
	u16 i, j, loop = 0;
	u32 test_end_lba;
	u32 test_lba = 0;
	u16 test_sec_count = 1;
	u16 print_flag;

	if (!priv || !block_dev) {
		printf("device unknown\n");
		return;
	}

	test_end_lba = priv->density;
	pwrite32 = (u32 *)pwrite;
	for (i = 0; i < (max_test_sector * 512); i++)
		pwrite[i] = i;
	for (loop = 0; loop < 10; loop++) {
		printf("---------Test loop = %d---------\n", loop);
		printf("---------Test ftl write---------\n");
		test_sec_count = 1;
		printf("test_end_lba = %x\n", test_end_lba);
		printf("test_lba = %x\n", test_lba);
		for (test_lba = 0;
		     (test_lba + test_sec_count) < test_end_lba;) {
			pwrite32[0] = test_lba;
			blk_dwrite(block_dev, test_lba, test_sec_count, pwrite);
			blk_dread(block_dev, test_lba, test_sec_count, pread);
			for (j = 0; j < test_sec_count * 512; j++) {
				if (pwrite[j] != pread[j]) {
					rkflash_print_hex("w:",
							  pwrite,
							  4,
							  test_sec_count * 128);
					rkflash_print_hex("r:",
							  pread,
							  4,
							  test_sec_count * 128);
					printf("r=%x, n=%x, w=%x, r=%x\n",
					       test_lba,
					       j,
					       pwrite[j],
					       pread[j]);
					while (1)
						;
					break;
				}
			}
			print_flag = test_lba & 0x1FF;
			if (print_flag < test_sec_count)
				printf("test_lba = %x\n", test_lba);
			test_lba += test_sec_count;
			test_sec_count++;
			if (test_sec_count > max_test_sector)
				test_sec_count = 1;
		}
		printf("---------Test ftl check---------\n");

		test_sec_count = 1;
		for (test_lba = 0;
		     (test_lba + test_sec_count) < test_end_lba;) {
			pwrite32[0] = test_lba;
			blk_dread(block_dev, test_lba, test_sec_count, pread);
			print_flag = test_lba & 0x7FF;
			if (print_flag < test_sec_count)
				printf("test_lba = %x\n", test_lba);

			for (j = 0; j < test_sec_count * 512; j++) {
				if (pwrite[j] != pread[j]) {
					printf("r=%x, n=%x, w=%x, r=%x\n",
					       test_lba,
					       j,
					       pwrite[j],
					       pread[j]);
					/* while(1); */
					break;
				}
			}
			test_lba += test_sec_count;
			test_sec_count++;
			if (test_sec_count > max_test_sector)
				test_sec_count = 1;
		}
	}
	printf("---------Test end---------\n");
	/* while(1); */
}
#endif

void rkflash_test(struct udevice *udev)
{
#if (BLK_STRESS_TEST_EN)
	blk_stress_test(udev);
#endif
}

