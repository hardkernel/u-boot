/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * Copyright (C) 2018 Rockchip Electronics Co., Ltd
 */

#ifndef _ASM_ARCH_SDRAM_SHARE_H
#define _ASM_ARCH_SDRAM_SHARE_H

#define MHZ		1000000

struct sdram_cap_info {
	unsigned int rank;
	unsigned int col;
	/* 3:8bank, 2:4bank */
	unsigned int bk;
	/* channel buswidth, 2:32bit, 1:16bit, 0:8bit */
	unsigned int bw;
	/* die buswidth, 2:32bit, 1:16bit, 0:8bit */
	unsigned int dbw;
	unsigned int row_3_4;
	unsigned int cs0_row;
	unsigned int cs1_row;
	unsigned int cs0_high16bit_row;
	unsigned int cs1_high16bit_row;
	unsigned int ddrconfig;
};

struct sdram_base_params {
	unsigned int ddr_freq;
	unsigned int dramtype;
	unsigned int num_channels;
	unsigned int stride;
	unsigned int odt;
};

#ifdef CONFIG_SDRAM_COMMON_OSREG
/*
 * sys_reg bitfield struct
 * [31]		row_3_4_ch1
 * [30]		row_3_4_ch0
 * [29:28]	chinfo
 * [27]		rank_ch1
 * [26:25]	col_ch1
 * [24]		bk_ch1
 * [23:22]	cs0_row_ch1
 * [21:20]	cs1_row_ch1
 * [19:18]	bw_ch1
 * [17:16]	dbw_ch1;
 * [15:13]	ddrtype
 * [12]		channelnum
 * [11]		rank_ch0
 * [10:9]	col_ch0
 * [8]		bk_ch0
 * [7:6]	cs0_row_ch0
 * [5:4]	cs1_row_ch0
 * [3:2]	bw_ch0
 * [1:0]	dbw_ch0
 */

#define DDR_SYS_REG_VERSION		(0x2)
#define SYS_REG_ENC_ROW_3_4(n, ch)	((n) << (30 + (ch)))
#define SYS_REG_DEC_ROW_3_4(n, ch)	(((n) >> (30 + (ch))) & 0x1)
#define SYS_REG_ENC_CHINFO(ch)		(1 << (28 + (ch)))
#define SYS_REG_ENC_DDRTYPE(n)		((n) << 13)
#define SYS_REG_DEC_DDRTYPE(n)		(((n) >> 13) & 0x7)
#define SYS_REG_ENC_NUM_CH(n)		(((n) - 1) << 12)
#define SYS_REG_DEC_NUM_CH(n)		(1 + (((n) >> 12) & 0x1))
#define SYS_REG_ENC_RANK(n, ch)		(((n) - 1) << (11 + ((ch) * 16)))
#define SYS_REG_DEC_RANK(n, ch)		(1 + (((n) >> (11 + 16 * (ch))) & 0x1))
#define SYS_REG_ENC_COL(n, ch)		(((n) - 9) << (9 + ((ch) * 16)))
#define SYS_REG_DEC_COL(n, ch)		(9 + (((n) >> (9 + 16 * (ch))) & 0x3))
#define SYS_REG_ENC_BK(n, ch)		(((n) == 3 ? 0 : 1) << \
						(8 + ((ch) * 16)))
#define SYS_REG_DEC_BK(n, ch)		(3 - (((n) >> (8 + 16 * (ch))) & 0x1))
#define SYS_REG_ENC_BW(n, ch)		((2 >> (n)) << (2 + ((ch) * 16)))
#define SYS_REG_DEC_BW(n, ch)		(2 >> (((n) >> (2 + 16 * (ch))) & 0x3))
#define SYS_REG_ENC_DBW(n, ch)		((2 >> (n)) << (0 + ((ch) * 16)))
#define SYS_REG_DEC_DBW(n, ch)		(2 >> (((n) >> (0 + 16 * (ch))) & 0x3))
/* sys reg 3 */
#define SYS_REG_ENC_VERSION(n)		((n) << 28)
#define SYS_REG_DEC_VERSION(n)		(((n) >> 28) & 0xf)
#define SYS_REG_ENC_CS0_ROW(n, os_reg2, os_reg3, ch) do { \
			(os_reg2) |= (((n) - 13) & 0x3) << (6 + 16 * (ch)); \
			(os_reg3) |= ((((n) - 13) & 0x4) >> 2) << \
				     (5 + 2 * (ch)); \
		} while (0)

#define SYS_REG_DEC_CS0_ROW(os_reg2, os_reg3, ch)	\
		((((((os_reg2) >> (6 + 16 * (ch)) & 0x3) | \
		 ((((os_reg3) >> (5 + 2 * (ch))) & 0x1) << 2)) + 1) & 0x7) + 12)

#define SYS_REG_ENC_CS1_ROW(n, os_reg2, os_reg3, ch) do { \
			(os_reg2) &= (~(0x3 << (4 + 16 * (ch)))); \
			(os_reg3) &= (~(0x1 << (4 + 2 * (ch)))); \
			(os_reg2) |= (((n) - 13) & 0x3) << (4 + 16 * (ch)); \
			(os_reg3) |= ((((n) - 13) & 0x4) >> 2) << \
				     (4 + 2 * (ch)); \
		} while (0)

#define SYS_REG_DEC_CS1_ROW(os_reg2, os_reg3, ch) \
		((((((os_reg2) >> (4 + 16 * (ch)) & 0x3) | \
		 ((((os_reg3) >> (4 + 2 * (ch))) & 0x1) << 2)) + 1) & 0x7) + 12)

#define SYS_REG_ENC_CS1_COL(n, ch)	(((n) - 9) << (0 + 2 * (ch)))
#define SYS_REG_DEC_CS1_COL(n, ch)	(9 + (((n) >> (0 + 2 * (ch))) & 0x3))

void sdram_org_config(struct sdram_cap_info *cap_info,
		      struct sdram_base_params *base,
		      u32 *p_os_reg2, u32 *p_os_reg3, u32 channel);
#endif

#if defined(CONFIG_SDRAM_COMMON_MSCH_PX30) || \
	defined(CONFIG_SDRAM_COMMON_MSCH_RK3399)
union noc_ddrtiminga0 {
	u32 d32;
	struct {
		unsigned acttoact : 6;
		unsigned reserved0 : 2;
		unsigned rdtomiss : 6;
		unsigned reserved1 : 2;
		unsigned wrtomiss : 6;
		unsigned reserved2 : 2;
		unsigned readlatency : 8;
	} b;
};

union noc_ddrtimingb0 {
	u32 d32;
	struct {
		unsigned rdtowr : 5;
		unsigned reserved0 : 3;
		unsigned wrtord : 5;
		unsigned reserved1 : 3;
		unsigned rrd : 4;
		unsigned reserved2 : 4;
		unsigned faw : 6;
		unsigned reserved3 : 2;
	} b;
};

union noc_ddrtimingc0 {
	u32 d32;
	struct {
		unsigned burstpenalty : 4;
		unsigned reserved0 : 4;
		unsigned wrtomwr : 6;
		unsigned reserved1 : 18;
	} b;
};

union noc_devtodev0 {
	u32 d32;
	struct {
		unsigned busrdtord : 3;
		unsigned reserved0 : 1;
		unsigned busrdtowr : 3;
		unsigned reserved1 : 1;
		unsigned buswrtord : 3;
		unsigned reserved2 : 1;
		unsigned buswrtowr : 3;
		unsigned reserved3 : 17;
	} b;
};

union noc_ddrmode {
	u32 d32;
	struct {
		unsigned autoprecharge : 1;
		unsigned bypassfiltering : 1;
		unsigned fawbank : 1;
		unsigned burstsize : 2;
		unsigned mwrsize : 2;
		unsigned reserved2 : 1;
		unsigned forceorder : 8;
		unsigned forceorderstate : 8;
		unsigned reserved3 : 8;
	} b;
};

union noc_ddr4timing {
	u32 d32;
	struct {
		unsigned ccdl : 3;
		unsigned wrtordl : 5;
		unsigned rrdl : 4;
		unsigned reserved1 : 20;
	} b;
};
#endif

#ifdef CONFIG_SDRAM_COMMON_MSCH_PX30
struct msch_regs {
	u32 coreid;
	u32 revisionid;
	u32 deviceconf;
	u32 devicesize;
	u32 ddrtiminga0;
	u32 ddrtimingb0;
	u32 ddrtimingc0;
	u32 devtodev0;
	u32 reserved1[(0x110 - 0x20) / 4];
	u32 ddrmode;
	u32 ddr4timing;
	u32 reserved2[(0x1000 - 0x118) / 4];
	u32 agingx0;
	u32 reserved3[(0x1040 - 0x1004) / 4];
	u32 aging0;
	u32 aging1;
	u32 aging2;
	u32 aging3;
};

struct sdram_msch_timings {
	union noc_ddrtiminga0 ddrtiminga0;
	union noc_ddrtimingb0 ddrtimingb0;
	union noc_ddrtimingc0 ddrtimingc0;
	union noc_devtodev0 devtodev0;
	union noc_ddrmode ddrmode;
	union noc_ddr4timing ddr4timing;
	u32 agingx0;
};

void sdram_msch_config(struct msch_regs *msch,
		       struct sdram_msch_timings *noc_timings,
		       struct sdram_cap_info *cap_info,
		       struct sdram_base_params *base);
#endif

#ifdef CONFIG_SDRAM_COMMON_MSCH_RK3399
struct msch_regs {
	u32 coreid;
	u32 revisionid;
	u32 ddrconf;
	u32 ddrsize;
	union noc_ddrtiminga0 ddrtiminga0;
	union noc_ddrtimingb0 ddrtimingb0;
	union noc_ddrtimingc0 ddrtimingc0;
	union noc_devtodev0 devtodev0;
	u32 reserved0[(0x110 - 0x20) / 4];
	union noc_ddrmode ddrmode;
	u32 reserved1[(0x1000 - 0x114) / 4];
	u32 agingx0;
};

struct sdram_msch_timings {
	union noc_ddrtiminga0 ddrtiminga0;
	union noc_ddrtimingb0 ddrtimingb0;
	union noc_ddrtimingc0 ddrtimingc0;
	union noc_devtodev0 devtodev0;
	union noc_ddrmode ddrmode;
	u32 agingx0;
};

void sdram_msch_config(struct msch_regs *msch,
		       struct sdram_msch_timings *noc_timings);
#endif

#ifdef CONFIG_SDRAM_COMMON_CAP_DETECT

#define PATTERN				(0x5aa5f00f)

int sdram_detect_bw(struct sdram_cap_info *cap_info);
int sdram_detect_cs(struct sdram_cap_info *cap_info);
int sdram_detect_col(struct sdram_cap_info *cap_info,
		     u32 coltmp);
int sdram_detect_bank(struct sdram_cap_info *cap_info,
		      u32 coltmp, u32 bktmp);
int sdram_detect_bg(struct sdram_cap_info *cap_info,
		    u32 coltmp);
int sdram_detect_dbw(struct sdram_cap_info *cap_info, u32 dram_type);
int sdram_detect_row(struct sdram_cap_info *cap_info,
		     u32 coltmp, u32 bktmp, u32 rowtmp);
int sdram_detect_row_3_4(struct sdram_cap_info *cap_info,
			 u32 coltmp, u32 bktmp);
int sdram_detect_high_row(struct sdram_cap_info *cap_info);
int sdram_detect_cs1_row(struct sdram_cap_info *cap_info, u32 dram_type);
#endif

void sdram_print_dram_type(unsigned char dramtype);
void sdram_print_ddr_info(struct sdram_cap_info *cap_info,
			  struct sdram_base_params *base, u32 split);
u64 sdram_get_cs_cap(struct sdram_cap_info *cap_info, u32 cs, u32 dram_type);
void sdram_copy_to_reg(u32 *dest, const u32 *src, u32 n);

#endif
