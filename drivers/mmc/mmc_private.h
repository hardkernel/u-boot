/*
 * Copyright 2008,2010 Freescale Semiconductor, Inc
 * Andy Fleming
 *
 * Based (loosely) on the Linux code
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef _MMC_PRIVATE_H_
#define _MMC_PRIVATE_H_

#include <mmc.h>

#define SAMSUNG_MID           0x15
#define KINGSTON_MID          0x70
#define SAMSUNG_FFU_ADDR      0xc7810000
#define KINGSTON_FFU_ADDR     0x0000ffff

extern int mmc_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd,
			struct mmc_data *data);
extern int mmc_send_status(struct mmc *mmc, int timeout);
extern int mmc_set_blocklen(struct mmc *mmc, int len);
extern ulong mmc_ffu_write(int dev_num, lbaint_t start, lbaint_t blkcnt,
		const void *src);

#ifndef CONFIG_SPL_BUILD

extern unsigned long mmc_berase(int dev_num, lbaint_t start, lbaint_t blkcnt);

extern ulong mmc_bwrite(int dev_num, lbaint_t start, lbaint_t blkcnt,
		const void *src);

extern void print_all_reg(struct mmc *mmc);

extern int mmc_set_hs200_mode(struct mmc *mmc);

extern uint32_t mmc_set_hs400_mode(struct mmc *mmc);

extern void reset_all_reg(struct mmc *mmc);
#else /* CONFIG_SPL_BUILD */

/* SPL will never write or erase, declare dummies to reduce code size. */

static inline unsigned long mmc_berase(int dev_num, lbaint_t start,
		lbaint_t blkcnt)
{
	return 0;
}

static inline ulong mmc_bwrite(int dev_num, lbaint_t start, lbaint_t blkcnt,
		const void *src)
{
	return 0;
}

#endif /* CONFIG_SPL_BUILD */

#endif /* _MMC_PRIVATE_H_ */
