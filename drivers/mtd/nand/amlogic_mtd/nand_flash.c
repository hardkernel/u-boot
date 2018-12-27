#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
// #include <asm/reboot.h>
#include <asm/arch/clock.h>
#include <asm/cpu_id.h>

#include "aml_mtd.h"

extern struct hw_controller *controller;

#if 0
extern void test_timing(struct mtd_info *mtd, struct nand_chip *chip);
#endif

int nand_fbb_issue_flag;
struct aml_nand_flash_dev aml_nand_flash_ids[] = {
	{"B revision NAND 8GiB MT29F64G08CBABA",
		{NAND_MFR_MICRON, 0x64, 0x44, 0x4B, 0xA9},
		8192,
		8192,
		0x200000,
		744,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A revision NAND 2GiB H27UAG8T2A",
		{NAND_MFR_HYNIX, 0xd5, 0x94, 0x25, 0x44, 0x41},
		4096,
		2048,
		0x80000,
		224,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"A revision NAND 4GiB H27UBG8T2A",
		{NAND_MFR_HYNIX, 0xd7, 0x94, 0x9a, 0x74, 0x42},
		8192,
		4096,
		0x200000,
		448,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"B revision NAND 2GiB H27UAG8T2B",
		{NAND_MFR_HYNIX, 0xd5, 0x94, 0x9a, 0x74, 0x42},
		8192,
		2048,
		0x200000,
		448,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

#ifdef NEW_NAND_SUPPORT
	{"B revision 26nm NAND 4GiB H27UBG8T2B",
		{NAND_MFR_HYNIX, 0xd7, 0x94, 0xda, 0x74, 0xc3},
		8192,
		4096,
		0x200000,
		640,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE)},

	{"B revision 26nm NAND 8GiB H27UCG8T2M",
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xd2, 0x04, 0x43},
		8192,
		8192,
		0x200000,
		448,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"C revision 20nm NAND 4GiB H27UBG8T2C",
		{NAND_MFR_HYNIX, 0xd7, 0x94, 0x91, 0x60, 0x44},
		8192,
		4096,
		0x200000,
		640,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE)},

	{"A revision 20nm NAND 8GiB H27UCG8T2A",
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xda, 0x74, 0xc4},
		8192,
		8192,
		0x200000,
		640,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"B revision 20nm NAND 8GiB H27UCG8T2B",
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xeb, 0x74, 0x44},
		16384,
		8192,
		0x400000,
		1280,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE)},

	{"E revision 1ynm NAND 8GiB H27UCG8T2E",
		{NAND_MFR_HYNIX, 0xde, 0x14, 0xa7, 0x42, 0x4a},
		16384,
		8192,
		0x400000,
		1664,
		1,
		16,
		15,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE)},
#endif

#ifdef NEW_NAND_SUPPORT
	{"B revision NAND 8GiB MT29F64G08CBABA",
		{NAND_MFR_MICRON, 0x64, 0x44, 0x4B, 0xA9},
		8192,
		8192,
		0x200000,
		744,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"D revision NAND 4GiB MT29F32G08CBADA",
		{NAND_MFR_MICRON, 0x44, 0x44, 0x4B, 0xA9},
		8192,
		4096,
		0x200000,
		744,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"1 Generation NAND 8GiB JS29F64G08ACMF1",
		{NAND_MFR_INTEL, 0x88, 0x24, 0x4b, 0xA9,0x84},
		8192,
		8192,
		0x200000,
		448,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},
#endif
	{"SamSung NAND K9F4G08U0F 4Gb",
		{NAND_MFR_SAMSUNG, 0xdc, 0x10, 0x95, 0x56},
		2048,
		512,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"SamSung NAND k9f2g08u0d 2Gb",
		{NAND_MFR_SAMSUNG, 0xda, 0x10, 0x95, 0x46},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Dosilicon NAND FMND1GXXX3D 3.3V 1Gb",
		{NAND_MFR_DOSILICON, 0xf1, 0x80, 0x95},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Dosilicon NAND FMND1GXXX3D 1.8V 1Gb",
		{NAND_MFR_DOSILICON, 0xa1, 0x80, 0x15},
		2048,
		128,
		0x20000,
		64,
		1,
		30,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Dosilicon NAND FMND2GXXX3D 3.3V 2Gb",
		{NAND_MFR_DOSILICON, 0xda, 0x90, 0x95, 0x46},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Dosilicon NAND FMND2GXXX3D 1.8V 2Gb",
		{NAND_MFR_DOSILICON, 0xaa, 0x90, 0x15, 0x46},
		2048,
		256,
		0x20000,
		64,
		1,
		30,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"ATO NAND AFND1G08U3 1Gb",
		{NAND_MFR_ATO, 0xf1, 0x00, 0x1d},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"ATO NAND AFND2G08U3A 2Gb",
		{NAND_MFR_HYNIX, 0xda, 0x90, 0x95, 0x46, 0xad},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Zetta NAND ZDND2GXXXXX 2Gb",
		{NAND_MFR_ZETTA, 0xda, 0x90, 0x95, 0x46},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"A revision NAND 1GiB sF1G-A",
		{NAND_MFR_AMD, 0xf1, 0x80, 0x1d, 0x01,0xf1},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE )},

	{"A revision NAND 1GiB sF1G-A",
		{NAND_MFR_AMD, 0xf1, 0x0, 0x1d, 0x01,0xf1},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"AMD/Spansion Slc NAND 2Gib S34ML02G1(MLO2G100BH1OO)",
		{NAND_MFR_AMD, 0xda, 0x90, 0x95, 0x44, 0x01},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"AMD/Spansion Slc NAND 2Gib S34ML02G1(MLO2G200BH1OO)",
		{NAND_MFR_AMD, 0xda, 0x90, 0x95, 0x46, 0x01},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"AMD/Spansion Slc NAND 8Gib S34ML08G1",
		{NAND_MFR_AMD, 0xd3, 0xd1, 0x95, 0x58},
		2048,
		1024,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 1Gib W29N01HV ",
		{NAND_ID_WINBOND, 0xf1, 0x00, 0x95, 0x00, 0x00},
		2048,
		128,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 4Gib W29N04GV ",
		{NAND_ID_WINBOND, 0xdc, 0x90, 0x95, 0x54, 0x00},
		2048,
		512,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"A revision NAND 1Gib W29N01GV ",
		{NAND_ID_WINBOND, 0xf1, 0x80, 0x95, 0x00, 0x00},
		2048,
		128,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 2Gib W29N02GV ",
		{NAND_ID_WINBOND, 0xda, 0x90, 0x95, 0x04, 0x00},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 1GiB H27U1G8F2CTR ",
		{NAND_MFR_HYNIX, 0xf1, 0x80, 0x1d, 0xad, 0xf1},
		2048,
		128,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 4Gib EMST ",
		{NAND_ID_ESMT, 0xac, 0x90, 0x15, 0x54, 0x7f},
		2048,
		512,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 4Gib GD9FU1G8F2AMGI",
		{NAND_ID_ESMT, 0xf1, 0x80, 0x1d, 0x42, 0xc8},
		2048,
		128,
		0x20000,
		128,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"ESMT SLC 256MiB 3.3V 8-bit",
		{NAND_ID_ESMT, 0xda, 0x90, 0x95, 0x44, 0x7f},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"ESMT SLC 128MiB 3.3V 8-bit F59L1G81Lxxx",
		{NAND_ID_ESMT, 0xd1, 0x80, 0x95, 0x42, 0x7f},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"ESMT SLC 128MiB 3.3V 8-bit F59L1G81Mxxx",
		{NAND_ID_ESMT, 0xd1, 0x80, 0x95, 0x40, 0x7f},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 2Gib TC58BVG1S3HTA00 ",
		{NAND_MFR_TOSHIBA, 0xda, 0x90, 0x15, 0xF6},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 2Gib TC58NVG1S3HBAI4 ",
		{NAND_MFR_TOSHIBA, 0xda, 0x90, 0x15, 0x76},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 4Gib TH58NVG2S3HTA00 ",
		{NAND_MFR_TOSHIBA, 0xdc, 0x91, 0x15, 0x76},
		2048,
		512,
		0x20000,
		64,
		1,
		35, /* trc = 50, 20MHz max ! */
		10,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 4Gib TC58NVG2S0HTA00 ",
		{NAND_MFR_TOSHIBA, 0xdc, 0x90, 0x26, 0x76},
		4096,
		512,
		0x40000,
		256,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 4Gib TC58BVG2S0HTA00 ",
		{NAND_MFR_TOSHIBA, 0xdc, 0x90, 0x26, 0xF6},
		4096,
		512,
		0x40000,
		128,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"A revision NAND 1Gib TC58BVG0S3HTA00",
		{NAND_MFR_TOSHIBA, 0xf1, 0x80, 0x15, 0xf2},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},
	{"Slc NAND 1Gib MX30LF1G18AC ",
		{NAND_MFR_MACRONIX, 0xf1, 0x80, 0x95, 0x02},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},
	{"Slc NAND 2Gib MX30LF2G18AC ",
		{NAND_MFR_MACRONIX, 0xda, 0x90, 0x95, 0x06},
		2048,
		256,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"Slc NAND 4Gib MX30LF4G18AC ",
		{NAND_MFR_MACRONIX, 0xdc, 0x90, 0x95, 0x56},
		2048,
		512,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 128MB TC58NVG0S3HTA00 ",
		{NAND_MFR_TOSHIBA, 0xf1, 0x80, 0x15, 0x72},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"4Gib MT29F4G08ABAEA",
		{NAND_MFR_MICRON, 0xdc, 0x90, 0xA6, 0x54},
		4096,
		512,
		0x40000,
		224,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"4Gib MT29F4G08ABADA",
		{NAND_MFR_MICRON, 0xdc, 0x90, 0x95, 0x56},
		2048,
		512,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"A revision NAND 2Gib MT29F2G08-A",
		{NAND_MFR_MICRON, 0xda, 0x90, 0x95, 0x06},
		2048,
		256,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE )},

	{"A revision NAND 1GiB MT29F1G-A",
		{NAND_MFR_MICRON, 0xf1, 0x80, 0x95, 0x04},
		2048,
		128,
		0x20000,
		64,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE )},

	{"A revision NAND 2GiB MT29F16G08ABABA",
		{NAND_MFR_MICRON, 0x48, 0x00, 0x26, 0x89},
		4096,
		2048,
		0x80000,
		224,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE4 | NAND_ECC_BCH8_MODE)},

	{"A revision NAND 4GiB MT29F32G-A",
		{NAND_MFR_MICRON, 0xd7, 0x94, 0x3e, 0x84},
		4096,
		4096,
		0x80000,
		218,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"A revision NAND 16GiB MT29F128G-A",
		{NAND_MFR_MICRON, 0xd9, 0xd5, 0x3e, 0x88},
		4096,
		16384,
		0x80000,
		218,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"B revision NAND 4GiB MT29F32G-B",
		{NAND_MFR_MICRON, 0x68, 0x04, 0x46, 0x89},
		4096,
		4096,
		0x100000,
		224,
		1,
		20,
		15,
		4,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"B revision NAND 8GiB MT29F64G-B",
		{NAND_MFR_MICRON, 0x88, 0x05, 0xc6, 0x89},
		4096,
		8192,
		0x100000,
		224,
		1,
		20,
		15,
		4,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"C revision NAND 4GiB MT29F32G-C",
		{NAND_MFR_MICRON, 0x68, 0x04, 0x4a, 0xa9},
		4096,
		4096,
		0x100000,
		224,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"C revision NAND 8GiB MT29F64G-C",
		{NAND_MFR_MICRON, 0x88, 0x04, 0x4b, 0xa9},
		8192,
		8192,
		0x200000,
		448,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"C revision NAND 1GiB MT29F8G08ABABA",
		{NAND_MFR_MICRON, 0x38, 0x00, 0x26, 0x85},
		4096,
		1024,
		0x80000,
		224,
		1,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		|NAND_TWO_PLANE_MODE)},

	{"C revision NAND 32GiB MT29F256G-C",
		{NAND_MFR_MICRON, 0xa8, 0x05, 0xcb, 0xa9},
		8192,
		16384,
		0x200000,
		448,
		2,
		16,
		15,
		5,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE | NAND_INTERLEAVING_MODE)},

	{"1 Generation NAND 4GiB JS29F32G08AA-1",
		{NAND_MFR_INTEL, 0x68, 0x04, 0x46, 0xA9},
		4096,
		4096,
		0x100000,
		218,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"1 Generation NAND 8GiB JS29F64G08AA-1",
		{NAND_MFR_INTEL, 0x88, 0x24, 0x4b, 0xA9},
		8192,
		8192,
		0x200000,
		448,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"E serials NAND 2GiB TC58NVG4D2ETA00",
		{NAND_MFR_TOSHIBA, 0xD5, 0x94, 0x32, 0x76, 0x54},
		8192,
		2048,
		0x100000,
		376,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"E serials NAND 4GiB TC58NVG5D2ETA00",
		{NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x54},
		8192,
		4096,
		0x100000,
		376,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"F serials NAND 2GiB TC58NVG4D2FTA00",
		{NAND_MFR_TOSHIBA, 0xD5, 0x94, 0x32, 0x76, 0x55},
		8192,
		2076,
		0x100000,
		448,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"F serials NAND 4GiB TC58NVG5D2FTA00",
		{NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x55},
		8192,
		4096,
		0x100000,
		448,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"F serials NAND 8GiB TC58NVG6D2FTA00",
		{NAND_MFR_TOSHIBA, 0xDE, 0x94, 0x32, 0x76, 0x55},
		8192,
		8192,
		0x100000,
		448,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"F serials NAND 8GiB TH58NVG7D2FTA20",
		{NAND_MFR_TOSHIBA, 0xDE, 0x95, 0x32, 0x7a, 0x55},
		8192,
		8200,
		0x100000,
		448,
		2,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE | NAND_INTERLEAVING_MODE)},

#ifdef NEW_NAND_SUPPORT
	{"F serials NAND 4GiB TC58NVG5D2HTA00",
		{NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x56},
		8192,
		4096,
		0x100000,
		640,
		1,
		20,
		25,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"F serials NAND 8GiB TC58NVG6D2GTA00",
		{NAND_MFR_TOSHIBA, 0xDE, 0x94, 0x82, 0x76, 0x56},
		8192,
		8192,
		0x200000,
		640,
		1,
		20,
		25,
		0,
		/*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"F serials NAND 8GiB TC58TEG6DCJTA00",
		{NAND_MFR_TOSHIBA, 0xDE, 0x84, 0x93, 0x72, 0x57},
		16384,
		8192,
		0x400000,
		1280,
		1,
		20,
		25,
		0,
		 /*need readretry, disable two plane mode*/
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 4GiB TC58TEG5DCJTA00 ",
		{NAND_MFR_TOSHIBA, 0xD7, 0x84, 0x93, 0x72, 0x57},
		16384,
		4096,
		0x400000,
		1280,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 8GiB TC58TEG6DDKTA00 ",
		{NAND_MFR_TOSHIBA,
		0xDE,
		0x94,
		0x93,
		0x76,
		0x50},
		16384,
		8192,
		0x400000,
		1280,
		1,
		16,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 16GiB TC58TEG7DCJTA00 ",
		{NAND_MFR_TOSHIBA, 0x3a, 0x85, 0x93, 0x76, 0x57},
		16384,
		16384,
		0x400000,
		1280,
		2,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},
#endif
#ifdef NEW_NAND_SUPPORT
	{"A serials NAND 8GiB SDTNQGAMA-008G ",
		{NAND_MFR_SANDISK, 0xDE, 0x94, 0x93, 0x76, 0x57},
		16384,
		8192,
		0x400000,
		1280,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 4GiB SDTNQGAMA-004G ",
		{NAND_MFR_SANDISK, 0xD7, 0x84, 0x93, 0x72, 0x57},
		16384,
		4096,
		0x400000,
		1280,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 8GiB SDTNPMAHEM-008G ",
		{NAND_MFR_SANDISK, 0xDE, 0xA4, 0x82, 0x76, 0x56},
		8192,
		8192,
		0x200000,
		640,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"A serials NAND 8GiB SDTNRGAMA-008G ",
		{NAND_MFR_SANDISK, 0xDE, 0x94, 0x93, 0x76, 0x50},
		16384,
		8192,
		0x400000,
		1280,
		1,
		20,
		25,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

#endif
	{"M Generation NAND 4Gib K9F4G08U0D",
		{NAND_MFR_SAMSUNG, 0xDC, 0x10, 0x95, 0x54,0XEC,},
		2048,
		512,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"M Generation NAND 1Gib FS33ND01GS108TFI0",
		{NAND_MFR_SAMSUNG, 0xF1, 0x00, 0x95, 0x42},
		2048,
		128,
		0x20000,
		64,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"M Generation NAND 2GiB K9GAG08U0M",
		{NAND_MFR_SAMSUNG, 0xD5, 0x14, 0xb6, 0x74},
		4096,
		2048,
		0x80000,
		128,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)},

	{"5 Generation NAND 2GiB K9GAG08X0D",
		{NAND_MFR_SAMSUNG, 0xD5, 0x94, 0x29, 0x34, 0x41},
		4096,
		2048,
		0x80000,
		218,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"6 Generation NAND 2GiB K9GAG08U0E",
		{NAND_MFR_SAMSUNG, 0xD5, 0x84, 0x72, 0x50, 0x42},
		8192,
		2048,
		0x100000,
		436,
		1,
		25,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE)},

	{"7 Generation NAND 2GiB K9GAG08U0F",
		{NAND_MFR_SAMSUNG, 0xD5, 0x94, 0x76, 0x54, 0x43},
		8192,
		2048,
		0x100000,
		512,
		1,
		25,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"6 Generation NAND 4GiB K9LBG08U0E",
		{NAND_MFR_SAMSUNG, 0xD7, 0xC5, 0x72, 0x54, 0x42},
		8192,
		4096,
		0x100000,
		436,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"6 Generation NAND 8GiB K9HCG08U0E",
		{NAND_MFR_SAMSUNG, 0xDE, 0xC5, 0x72, 0x54, 0x42},
		8192,
		8192,
		0x100000,
		436,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH12_MODE
		| NAND_TWO_PLANE_MODE)},

	{"2 Generation NAND 4GiB K9GBG08U0A",
		{NAND_MFR_SAMSUNG, 0xD7, 0x94, 0x7a, 0x54, 0x43},
		8192,
		4152,
		0x100000,
		640,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE)},

	{"2 Generation NAND 8GiB K9LCG08U0A",
		{NAND_MFR_SAMSUNG, 0xDE, 0xD5, 0x7a, 0x58, 0x43},
		8192,
		8304,
		0x100000,
		640,
		2,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE
		| NAND_TWO_PLANE_MODE | NAND_INTERLEAVING_MODE)},

#ifdef NEW_NAND_SUPPORT
	{"2 Generation NAND 4GiB K9GBG08U0B",
		{NAND_MFR_SAMSUNG, 0xD7, 0x94, 0x7e, 0x64, 0x44},
		8192,
		4096,
		0x100000,
		640,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},

	{"2 Generation NAND 8GiB K9LCG08U0B",
		{NAND_MFR_SAMSUNG, 0xDE, 0xD5, 0x7e, 0x68, 0x44},
		8192,
		8192,
		0x100000,
		640,
		1,
		20,
		15,
		0,
		(NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE )},
#endif
	{NULL,}
};

int aml_nand_get_fbb_issue(void)
{
	return nand_fbb_issue_flag;
}

void aml_nand_check_fbb_issue(u8 *dev_id)
{
	int i, k;
	u8 samsung_nand_id[][MAX_ID_LEN] = {
		{NAND_MFR_SAMSUNG, 0xdc, 0x10, 0x95, 0x56},
		{NAND_MFR_SAMSUNG, 0xda, 0x10, 0x95, 0x46},
	};

	k = ARRAY_SIZE(samsung_nand_id);
	for (i = 0; i < k; i++) {
		if (!strncmp((char *)samsung_nand_id[i], (char *)dev_id,
			     strlen((const char *)samsung_nand_id[i])))
			nand_fbb_issue_flag = 1;
	}
}

//********************
#ifdef CONFIG_PARAMETER_PAGE
struct parameter_page para_page;

void aml_nand_read_parameter_page(struct mtd_info *mtd, int ce, char * buf)
{

	struct nand_chip *chip = mtd->priv;

	NFC_SEND_CMD(ce | CLE | 0xec);
	NFC_SEND_CMD(ce | ALE | 0x00);
	NFC_SEND_CMD(ce | IDLE | 5);

	signed long i,count;
	memset(buf,0,256);
	for (i=0,count=0;i<256 && count<256;i++)
	{
		*buf=chip->read_byte(mtd);
		if ((0 == i) && (0x4f != *buf))
		{
			i=-1;
			count++;
			continue;
		}

		buf++;
	}
}

void display_para_page(struct parameter_page para_page,unsigned long log_level)
{
	unsigned long i;
	signed long j;
	unsigned char* buf = (unsigned char*)&para_page;

	printk("\nNand parameter page: \n");

	if ((para_page.signature[0] != 0x4f)
		|| (para_page.signature[1] != 0x4e)
		|| (para_page.signature[2] != 0x46)
		|| (para_page.signature[3] != 0x49)) {
		printk("Wrong parameter page reading.\n");
		return;
	}

	if (1 == log_level) {
		printk("The parameter value is show as following list,"
			"please refer to ONFI SPEC for more infomation.\n");
		printk("index val index val index val index val ");
		for (i = 0; i < sizeof(para_page); i++, buf++) {
			if (!(i % 4))
				printf("\n");
			if (0 == i)
			printk("0~31 byte:Revision info and features blk:\n");
			else if(32 == i)
			printk("32~79 byte: Manufacturer info blk:\n");
			else if(80 == i)
			printk("80~127 byte: Memory organization blk:\n");
			else if(128 == i)
			printk("128~163 byte: Electrical parameters block:\n");
			else if(164 == i)
			printk("164~255 byte: Vendor block:\n");
			printk("%03d    0x%02x      ",i, *buf);

		}
	} else {
		printk("Manu info: ");
		for (j=0; j<12; j++)
			printk("%c", para_page.dev_manu[j]);
		printk("\n");

		printk("ONFI v");
		if (para_page.ver & 0x40)
			printk("3.0 ");
		if (para_page.ver & 0x20)
			printk("2.3 ");
		if (para_page.ver & 0x10)
			printk("2.2 ");
		if (para_page.ver & 0x08)
			printk("2.1 ");
		if (para_page.ver & 0x04)
			printk("2.0 ");
		if (para_page.ver & 0x02)
			printk("1.0");
		printk("\n");

		printk("Feature supprot: 0x%x\n",para_page.feature);

		printk("%d bytes per page.\n",para_page.data_bytes_perpage);
		printk("%d spare bytes per page.\n",
			para_page.spare_bytes_perpage);
		printk("%d pages per block.\n",para_page.pages_perblk);
		printk("%d blocks per LUN.\n",para_page.blks_perLUN);
		printk("%d LUNs.\n",para_page.num_LUN);
		para_page.num_addr_cycle;
		printk("Column address cycles %d, Row address cycles %d.\n",
			para_page.num_addr_cycle & 0xf0,
			para_page.num_addr_cycle & 0xf);
		printk("%d bits per cell.\n",para_page.bits_percell);

		printk("Bad blocks maximum per LUN: %d\n",
			para_page.max_badblk_perLUN);
		printk("%d bits ECC correctability.\n",
			para_page.bits_ECC_corretable);

		printk("Support time mode: ");
		for (j = 5; j >= 0; j--) {
			if (para_page.asy_time_mode & (1<<j))
				printk("%d ",j);
		}
	}
	printk("\nEnd of Nand parameter page.\n\n");
	return;
}
#endif //CONFIG_PARAMETER_PAGE


//*******************
uint8_t aml_nand_get_onfi_features(struct aml_nand_chip *aml_chip,
	uint8_t *buf, int addr)
{
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	int i, j;

	for (i=0; i<controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			aml_chip->aml_nand_select_chip(aml_chip, i);
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_GET_FEATURES, -1, -1, i);
			chip->cmd_ctrl(mtd, addr,
				NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
			NFC_SEND_CMD_IDLE(controller, 20);
			for (j = 0; j < 4; j++)
				buf[j] = chip->read_byte(mtd);
		}
	}
	return 0;
}

void aml_nand_set_onfi_features(struct aml_nand_chip *aml_chip,
	uint8_t *buf, int addr)
{
	int i, j;
	struct nand_chip *chip = &aml_chip->chip;
	struct mtd_info *mtd = &aml_chip->mtd;
	for (i=0; i<controller->chip_num; i++) {
		if (aml_chip->valid_chip[i]) {
			aml_chip->aml_nand_select_chip(aml_chip, i);
			aml_chip->aml_nand_command(aml_chip,
				NAND_CMD_SET_FEATURES, -1, -1, i);
			chip->cmd_ctrl(mtd, addr,
				NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
			NFC_SEND_CMD_IDLE(controller, 20);
			for (j=0; j<4; j++)
				aml_chip->aml_nand_write_byte(aml_chip, buf[j]);
			aml_chip->aml_nand_wait_devready(aml_chip, i);
		}
	}
}

static struct aml_nand_flash_dev *aml_nand_get_flash_type(struct mtd_info *mtd,
	struct nand_chip *chip,
	int busw, int *maf_id)
{
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_platform *plat = aml_chip->platform;
	struct aml_nand_flash_dev *type = NULL;
	int i, maf_idx;
	u8 dev_id[MAX_ID_LEN];

#ifdef NEW_NAND_SUPPORT
	struct new_tech_nand_t *nand_info;
	nand_info = &aml_chip->new_nand_info;
	u8 dev_id_hynix_26nm_8g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xd2, 0x04, 0x43};
	u8 dev_id_hynix_26nm_4g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xd7, 0x94, 0xda, 0x74, 0xc3};
	u8 dev_id_hynix_20nm_4g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xd7, 0x94, 0x91, 0x60, 0x44};
	u8 dev_id_hynix_20nm_8g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xda, 0x74, 0xc4};
	u8 dev_id_hynix_20nm_lga_8g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xde, 0x94, 0xeb, 0x74, 0x44};
	u8 dev_id_hynix_1ynm_8g[MAX_ID_LEN] =
		{NAND_MFR_HYNIX, 0xde, 0x14, 0xa7, 0x42, 0x4a};
	u8 dev_id_toshiba_24nm_4g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xD7, 0x94, 0x32, 0x76, 0x56};
	u8 dev_id_toshiba_24nm_8g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xDE, 0x94, 0x82, 0x76, 0x56};
	u8 dev_id_toshiba_19nm_8g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xDE, 0x84, 0x93, 0x72, 0x57};
	u8 dev_id_toshiba_19nm_4g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xD7, 0x84, 0x93, 0x72, 0x57};
	u8 dev_id_toshiba_a19nm_8g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xDe, 0x94, 0x93, 0x76, 0x50};
	u8 dev_id_toshiba_a19nm_4g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xD7, 0x84, 0x93, 0x72, 0x50};
	u8 dev_id_toshiba_19nm_16g[MAX_ID_LEN] =
		{NAND_MFR_TOSHIBA, 0xa3, 0x85, 0x93, 0x76, 0x57};
	u8 dev_id_samsung_2xnm_8g[MAX_ID_LEN] =
		{NAND_MFR_SAMSUNG, 0xDE, 0xD5, 0x7E, 0x68, 0x44};
	u8 dev_id_samsung_2xnm_4g[MAX_ID_LEN] =
		{NAND_MFR_SAMSUNG, 0xD7, 0x94, 0x7e, 0x64, 0x44};
	u8 dev_id_sandisk_19nm_8g[MAX_ID_LEN] =
		{NAND_MFR_SANDISK, 0xDE, 0x94, 0x93, 0x76, 0x57};
	u8 dev_id_sandisk_19nm_4g[MAX_ID_LEN] =
		{NAND_MFR_SANDISK, 0xD7, 0x84, 0x93, 0x72, 0x57};
	u8 dev_id_sandisk_24nm_8g[MAX_ID_LEN] =
		{NAND_MFR_SANDISK, 0xDE, 0xA4, 0x82, 0x76, 0x56};
	u8 dev_id_sandisk_a19nm_8g[MAX_ID_LEN] =
		{NAND_MFR_SANDISK, 0xDE, 0x94, 0x93, 0x76, 0x50};
	u8 dev_id_sandisk_a19nm_4g[MAX_ID_LEN] =
		{NAND_MFR_SANDISK, 0xD7, 0x84, 0x93, 0x72, 0x50};
	u8 dev_id_micron_20nm_8g[MAX_ID_LEN] =
		{NAND_MFR_MICRON, 0x64, 0x44, 0x4B, 0xA9};
	u8 dev_id_micron_20nm_4g[MAX_ID_LEN] =
		{NAND_MFR_MICRON, 0x44, 0x44, 0x4B, 0xA9};
	u8 dev_id_intel_20nm_8g[MAX_ID_LEN] =
		{NAND_MFR_INTEL, 0x88, 0x24, 0x4B, 0xA9,0x84};
#endif
	//int tmp_id, tmp_manf;

	/* Send the command for reading device ID */
	chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);

	/* Read manufacturer and device IDs */
	for (i=0; i<MAX_ID_LEN; i++) {
		dev_id[i] = chip->read_byte(mtd);
	}
	*maf_id = dev_id[0];
	printk("NAND device id: %x %x %x %x %x %x \n",
	dev_id[0], dev_id[1], dev_id[2], dev_id[3], dev_id[4], dev_id[5]);

#if 0
	test_timing(mtd, chip);
#endif
	/* Lookup the flash id */
	for (i = 0; aml_nand_flash_ids[i].name != NULL; i++) {
		if (!strncmp((char*) aml_nand_flash_ids[i].id,
		(char*)dev_id, strlen((const char*)aml_nand_flash_ids[i].id))) {
			type = &aml_nand_flash_ids[i];
			break;
		}
	}

	if (!type) {
		if (plat->nand_flash_dev) {
			if (!strncmp((char*) plat->nand_flash_dev->id,
	(char*)dev_id, strlen((const char*)plat->nand_flash_dev->id)))
				type = plat->nand_flash_dev;
		}

		if (!type)
			return ERR_PTR(-ENODEV);
	}
	aml_nand_check_fbb_issue(dev_id);

#ifdef NEW_NAND_SUPPORT
	memset(nand_info, 0, sizeof(struct new_tech_nand_t));
	if (!strncmp((char*)type->id, (char*) dev_id_hynix_26nm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info.type = HYNIX_26NM_8GB;
		aml_chip->ran_mode = 1;
		printk("aml_chip->hynix_new_nand_type =: %d \n",
			nand_info->type);

		//read retry
		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 6;

		nand_info->read_rety_info.reg_addr[0] = 0xAC;
		nand_info->read_rety_info.reg_addr[1] = 0xAD;
		nand_info->read_rety_info.reg_addr[2] = 0xAE;
		nand_info->read_rety_info.reg_addr[3] = 0xAF;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0x06;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0x06;

		nand_info->read_rety_info.reg_offset_value[0][1][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = -0x03;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = -0x07;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = -0x08;

		nand_info->read_rety_info.reg_offset_value[0][2][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = -0x06;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = -0x0D;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = -0x0F;

		nand_info->read_rety_info.reg_offset_value[0][3][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = -0x0B;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = -0x14;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = -0x17;

		nand_info->read_rety_info.reg_offset_value[0][4][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][4][1] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = -0x1A;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = -0x1E;

		nand_info->read_rety_info.reg_offset_value[0][5][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][5][1] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = -0x20;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = -0x25;

		nand_info->slc_program_info.reg_cnt = 5;

		nand_info->slc_program_info.reg_addr[0] = 0xA4;
		nand_info->slc_program_info.reg_addr[1] = 0xA5;
		nand_info->slc_program_info.reg_addr[2] = 0xB0;
		nand_info->slc_program_info.reg_addr[3] = 0xB1;
		nand_info->slc_program_info.reg_addr[4] = 0xC9;

		nand_info->slc_program_info.reg_offset_value[0] = 0x25;
		nand_info->slc_program_info.reg_offset_value[1] = 0x25;
		nand_info->slc_program_info.reg_offset_value[2] = 0x25;
		nand_info->slc_program_info.reg_offset_value[3] = 0x25;
		nand_info->slc_program_info.reg_offset_value[4] = 0x01;

		nand_info->read_rety_info.get_default_value =
			aml_nand_get_read_default_value_hynix;
		nand_info->read_rety_info.save_default_value =
			aml_nand_save_read_default_value_hynix;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_hynix;

		nand_info->slc_program_info.enter_enslc_mode =
			aml_nand_enter_enslc_mode_hynix;
		nand_info->slc_program_info.exit_enslc_mode =
			aml_nand_exit_enslc_mode_hynix;
		nand_info->slc_program_info.get_default_value =
			aml_nand_get_slc_default_value_hynix;
	} else  if(!strncmp((char*)type->id, (char*)dev_id_hynix_26nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info->type = HYNIX_26NM_4GB;
		aml_chip->ran_mode = 1;
		printk("aml_chip->hynix_new_nand_type =: %d \n", nand_info->type);

		//read retry
		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 6;

		nand_info->read_rety_info.reg_addr[0] = 0xA7;
		nand_info->read_rety_info.reg_addr[1] = 0xAD;
		nand_info->read_rety_info.reg_addr[2] = 0xAE;
		nand_info->read_rety_info.reg_addr[3] = 0xAF;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0x06;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0x06;

		nand_info->read_rety_info.reg_offset_value[0][1][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = -0x03;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = -0x07;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = -0x08;

		nand_info->read_rety_info.reg_offset_value[0][2][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = -0x06;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = -0x0D;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = -0x0F;

		nand_info->read_rety_info.reg_offset_value[0][3][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = -0x09;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = -0x14;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = -0x17;

		nand_info->read_rety_info.reg_offset_value[0][4][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][4][1] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = -0x1A;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = -0x1E;

		nand_info->read_rety_info.reg_offset_value[0][5][0] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][5][1] =
			READ_RETRY_ZERO;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = -0x20;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = -0x25;

		nand_info->slc_program_info.reg_cnt = 5;

		nand_info->slc_program_info.reg_addr[0] = 0xA0;
		nand_info->slc_program_info.reg_addr[1] = 0xA1;
		nand_info->slc_program_info.reg_addr[2] = 0xB0;
		nand_info->slc_program_info.reg_addr[3] = 0xB1;
		nand_info->slc_program_info.reg_addr[4] = 0xC9;

		nand_info->slc_program_info.reg_offset_value[0] = 0x26;
		nand_info->slc_program_info.reg_offset_value[1] = 0x26;
		nand_info->slc_program_info.reg_offset_value[2] = 0x26;
		nand_info->slc_program_info.reg_offset_value[3] = 0x26;
		nand_info->slc_program_info.reg_offset_value[4] = 0x01;

		nand_info->read_rety_info.get_default_value =
			aml_nand_get_read_default_value_hynix;
		nand_info->read_rety_info.save_default_value =
			aml_nand_save_read_default_value_hynix;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_hynix;

		nand_info->slc_program_info.enter_enslc_mode =
			aml_nand_enter_enslc_mode_hynix;
		nand_info->slc_program_info.exit_enslc_mode =
			aml_nand_exit_enslc_mode_hynix;
		nand_info->slc_program_info.get_default_value =
			aml_nand_get_slc_default_value_hynix;

	}
	else  if(!strncmp((char*)type->id, (char*)dev_id_hynix_20nm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info->type = HYNIX_20NM_8GB;
		aml_chip->ran_mode = 1;
		printk("aml_chip->hynix_new_nand_type =: %d \n",
			nand_info->type);

		//read retry
		nand_info->read_rety_info.reg_cnt = 8;
		nand_info->read_rety_info.retry_cnt = 7;

		nand_info->read_rety_info.reg_addr[0] = 0xCC;
		nand_info->read_rety_info.reg_addr[1] = 0xBF;
		nand_info->read_rety_info.reg_addr[2] = 0xAA;
		nand_info->read_rety_info.reg_addr[3] = 0xAB;
		nand_info->read_rety_info.reg_addr[4] = 0xCD;
		nand_info->read_rety_info.reg_addr[5] = 0xAD;
		nand_info->read_rety_info.reg_addr[6] = 0xAE;
		nand_info->read_rety_info.reg_addr[7] = 0xAF;

		nand_info->slc_program_info.reg_cnt = 4;

		nand_info->slc_program_info.reg_addr[0] = 0xB0;
		nand_info->slc_program_info.reg_addr[1] = 0xB1;
		nand_info->slc_program_info.reg_addr[2] = 0xA0;
		nand_info->slc_program_info.reg_addr[3] = 0xA1;

		nand_info->slc_program_info.reg_offset_value[0] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[1] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[2] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[3] = 0x0A;


		nand_info->read_rety_info.get_default_value =
			aml_nand_get_read_default_value_hynix;
		nand_info->read_rety_info.save_default_value =
			aml_nand_save_read_default_value_hynix;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_hynix;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_hynix;

		nand_info->slc_program_info.enter_enslc_mode =
			aml_nand_enter_enslc_mode_hynix;
		nand_info->slc_program_info.exit_enslc_mode =
			aml_nand_exit_enslc_mode_hynix;
		nand_info->slc_program_info.get_default_value =
			aml_nand_get_slc_default_value_hynix;

	} else if(!strncmp((char*)type->id, (char*)dev_id_hynix_20nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id))
		||(!strncmp((char*)type->id, (char*)dev_id_hynix_20nm_lga_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {

		nand_info->type = HYNIX_20NM_4GB;
		aml_chip->ran_mode = 1;
		printk("aml_chip->hynix_new_nand_type =: %d \n",
			nand_info->type);

		//read retry
		nand_info->read_rety_info.reg_cnt = 8;
		nand_info->read_rety_info.retry_cnt = 7;

		nand_info->read_rety_info.reg_addr[0] = 0xB0;
		nand_info->read_rety_info.reg_addr[1] = 0xB1;
		nand_info->read_rety_info.reg_addr[2] = 0xB2;
		nand_info->read_rety_info.reg_addr[3] = 0xB3;
		nand_info->read_rety_info.reg_addr[4] = 0xB4;
		nand_info->read_rety_info.reg_addr[5] = 0xB5;
		nand_info->read_rety_info.reg_addr[6] = 0xB6;
		nand_info->read_rety_info.reg_addr[7] = 0xB7;

		nand_info->slc_program_info.reg_cnt = 4;

		nand_info->slc_program_info.reg_addr[0] = 0xA0;
		nand_info->slc_program_info.reg_addr[1] = 0xA1;
		nand_info->slc_program_info.reg_addr[2] = 0xA7;
		nand_info->slc_program_info.reg_addr[3] = 0xA8;

		nand_info->slc_program_info.reg_offset_value[0] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[1] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[2] = 0x0A;
		nand_info->slc_program_info.reg_offset_value[3] = 0x0A;


		nand_info->read_rety_info.get_default_value =
			aml_nand_get_read_default_value_hynix;
		nand_info->read_rety_info.save_default_value =
			aml_nand_save_read_default_value_hynix;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_hynix;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_hynix;

		nand_info->slc_program_info.enter_enslc_mode =
			aml_nand_enter_enslc_mode_hynix;
		nand_info->slc_program_info.exit_enslc_mode =
			aml_nand_exit_enslc_mode_hynix;
		nand_info->slc_program_info.get_default_value =
			aml_nand_get_slc_default_value_hynix;

	} else  if(!strncmp((char*)type->id, (char*)dev_id_hynix_1ynm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info->type = HYNIX_1YNM_8GB;
		aml_chip->ran_mode = 1;
		printk("aml_chip->hynix_new_nand_type =: %d \n",
			nand_info->type);
		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 7;
		nand_info->read_rety_info.reg_addr[0] = 0x38;
		nand_info->read_rety_info.reg_addr[1] = 0x39;
		nand_info->read_rety_info.reg_addr[2] = 0x3a;
		nand_info->read_rety_info.reg_addr[3] = 0x3b;
		nand_info->read_rety_info.get_default_value =
			aml_nand_get_read_default_value_hynix;
		nand_info->read_rety_info.save_default_value =
			aml_nand_save_read_default_value_hynix;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_hynix;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_hynix;

	} else if((!strncmp((char*)type->id, (char*)dev_id_toshiba_24nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		||(!strncmp((char*)type->id, (char*)dev_id_toshiba_24nm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		|| (!strncmp((char*)type->id, (char*)dev_id_toshiba_19nm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		|| (!strncmp((char*)type->id,(char*)dev_id_toshiba_19nm_16g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		|| (!strncmp((char*)type->id, (char*)dev_id_toshiba_19nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {
		nand_info->type =  TOSHIBA_24NM;
		aml_chip->ran_mode = 1;

		nand_info->read_rety_info.reg_addr[0] = 0x04;
		nand_info->read_rety_info.reg_addr[1] = 0x05;
		nand_info->read_rety_info.reg_addr[2] = 0x06;
		nand_info->read_rety_info.reg_addr[3] = 0x07;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0;

		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = 0x04;

		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = 0x74;

		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = 0x08;

		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 6;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_toshiba;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_toshiba;

	} else if((!strncmp((char*)type->id, (char*)dev_id_toshiba_a19nm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		||(!strncmp((char*)type->id, (char*)dev_id_toshiba_a19nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {
		nand_info->type =  TOSHIBA_A19NM;
		aml_chip->ran_mode = 1;

		nand_info->read_rety_info.reg_addr[0] = 0x04;
		nand_info->read_rety_info.reg_addr[1] = 0x05;
		nand_info->read_rety_info.reg_addr[2] = 0x06;
		nand_info->read_rety_info.reg_addr[3] = 0x07;
		nand_info->read_rety_info.reg_addr[4] = 0x0d;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][4] = 0;

		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][4] = 0x0;

		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][2][4] = 0x0;

		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][3][4] = 0x0;

		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][4][4] = 0x0;

		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][5][4] = 0x0;

		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][6][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][6][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][6][3] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][6][4] = 0x0;

		nand_info->read_rety_info.reg_cnt = 5;
		nand_info->read_rety_info.retry_cnt = 7;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_toshiba;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_toshiba;

	} else  if((!strncmp((char*)type->id, (char*)dev_id_samsung_2xnm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		||(!strncmp((char*)type->id, (char*)dev_id_samsung_2xnm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {
		nand_info->type =  SUMSUNG_2XNM;
		aml_chip->ran_mode = 1;

		nand_info->read_rety_info.reg_addr[0] = 0xA7;
		nand_info->read_rety_info.reg_addr[1] = 0xA4;
		nand_info->read_rety_info.reg_addr[2] = 0xA5;
		nand_info->read_rety_info.reg_addr[3] = 0xA6;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0;

		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x05;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x28;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0xEc;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = 0xD8;

		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0xED;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0xF5;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0xED;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = 0xE6;

		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0x0F;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0x05;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x0F;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = 0xEC;

		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0XE8;
		nand_info->read_rety_info.reg_offset_value[0][6][1] = 0XEF;
		nand_info->read_rety_info.reg_offset_value[0][6][2] = 0XE8;
		nand_info->read_rety_info.reg_offset_value[0][6][3] = 0XDC;

		nand_info->read_rety_info.reg_offset_value[0][7][0] = 0xF1;
		nand_info->read_rety_info.reg_offset_value[0][7][1] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][7][2] = 0xFE;
		nand_info->read_rety_info.reg_offset_value[0][7][3] = 0xF0;

		nand_info->read_rety_info.reg_offset_value[0][8][0] = 0x0A;
		nand_info->read_rety_info.reg_offset_value[0][8][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][2] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][8][3] = 0xEC;

		nand_info->read_rety_info.reg_offset_value[0][9][0] = 0xD0;
		nand_info->read_rety_info.reg_offset_value[0][9][1] = 0xE2;
		nand_info->read_rety_info.reg_offset_value[0][9][2] = 0xD0;
		nand_info->read_rety_info.reg_offset_value[0][9][3] = 0xC2;

		nand_info->read_rety_info.reg_offset_value[0][10][0] = 0x14;
		nand_info->read_rety_info.reg_offset_value[0][10][1] = 0x0F;
		nand_info->read_rety_info.reg_offset_value[0][10][2] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][10][3] = 0xEC;

		nand_info->read_rety_info.reg_offset_value[0][11][0] = 0xE8;
		nand_info->read_rety_info.reg_offset_value[0][11][1] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][11][2] = 0xE8;
		nand_info->read_rety_info.reg_offset_value[0][11][3] = 0xDC;

		nand_info->read_rety_info.reg_offset_value[0][12][0] = 0X1E;
		nand_info->read_rety_info.reg_offset_value[0][12][1] = 0X14;
		nand_info->read_rety_info.reg_offset_value[0][12][2] = 0XFB;
		nand_info->read_rety_info.reg_offset_value[0][12][3] = 0XEC;

		nand_info->read_rety_info.reg_offset_value[0][13][0] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][13][1] = 0xFF;
		nand_info->read_rety_info.reg_offset_value[0][13][2] = 0xFB;
		nand_info->read_rety_info.reg_offset_value[0][13][3] = 0xF8;

		nand_info->read_rety_info.reg_offset_value[0][14][0] = 0x07;
		nand_info->read_rety_info.reg_offset_value[0][14][1] = 0x0C;
		nand_info->read_rety_info.reg_offset_value[0][14][2] = 0x02;
		nand_info->read_rety_info.reg_offset_value[0][14][3] = 0x00;


		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 15;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_samsung;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_samsung;

	} else  if(!strncmp((char*)type->id, (char*)dev_id_sandisk_24nm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info->type =  SANDISK_24NM;
		aml_chip->ran_mode = 1;
		nand_info->dynamic_read_info.dynamic_read_flag = 0; //DRF
		nand_info->dynamic_read_info.reg_addr_init[0] = 0x04;
		nand_info->dynamic_read_info.reg_addr_init[1] = 0x05;
		nand_info->dynamic_read_info.reg_addr_init[2] = 0x06;
		nand_info->dynamic_read_info.reg_addr_init[3] = 0x07;
		nand_info->dynamic_read_info.reg_addr_init[4] = 0x08;
		nand_info->dynamic_read_info.reg_addr_init[5] = 0x09;
		nand_info->dynamic_read_info.reg_addr_init[6] = 0x0a;
		nand_info->dynamic_read_info.reg_addr_init[7] = 0x0b;
		nand_info->dynamic_read_info.reg_addr_init[8] = 0x0c;
		nand_info->read_rety_info.reg_addr[0] = 0x04;
		nand_info->read_rety_info.reg_addr[1] = 0x05;
		nand_info->read_rety_info.reg_addr[2] = 0x07;
		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0xf0;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0;
		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0xe0;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0;
		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0xff;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0xf0;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0xf0;
		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0xee;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0xe0;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0xe0;
		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0xde;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0xd0;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0xd0;
		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0xcd;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0xc0;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0xc0;
		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x01;
		nand_info->read_rety_info.reg_offset_value[0][6][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][6][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][0] = 0x02;
		nand_info->read_rety_info.reg_offset_value[0][7][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][0] = 0x03;
		nand_info->read_rety_info.reg_offset_value[0][8][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][2] = 0x00;
		nand_info->read_rety_info.reg_cnt = 3;
		nand_info->read_rety_info.retry_cnt = 9;
		nand_info->dynamic_read_info.dynamic_read_init =
			aml_nand_dynamic_read_init;
		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_sandisk;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_dynamic_read_exit;

	} else  if(!strncmp((char*)type->id, (char*)dev_id_sandisk_a19nm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		nand_info->type =  SANDISK_A19NM;
		aml_chip->ran_mode = 1;
		nand_info->dynamic_read_info.dynamic_read_flag = 0; //DRF


		nand_info->read_rety_info.reg_addr[0] = 0x11;
		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 29;

		////////////lower page read ////////////////////////////////////
		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][6][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][6][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][6][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][7][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][7][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][8][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][8][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][9][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][9][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][9][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][9][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][10][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][10][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][10][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][10][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][11][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][11][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][11][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][11][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][12][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][12][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][12][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][12][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][13][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][13][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][13][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][13][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][14][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][14][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][14][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][14][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][15][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][15][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][15][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][15][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][16][0] = 0x10;
		nand_info->read_rety_info.reg_offset_value[0][16][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][16][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][16][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][17][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][17][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][17][2] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][17][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][18][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][18][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][18][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][18][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][19][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][19][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][19][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][19][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][20][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][20][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][20][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][20][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][21][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][21][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][21][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][21][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][22][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][22][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][22][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][22][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][23][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][23][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][23][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][23][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][24][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][24][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][24][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][24][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][25][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][25][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][25][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][25][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][26][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][26][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][26][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][26][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][27][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][27][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][27][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][27][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][28][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][28][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][28][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][28][3] = 0x00;

		/////////////////upper page read/////////////////////////////////
		nand_info->read_rety_info.reg_offset_value[1][0][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[1][1][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][3] = 0x04;

		nand_info->read_rety_info.reg_offset_value[1][2][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[1][3][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][3][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][3][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][3][3] = 0x08;

		nand_info->read_rety_info.reg_offset_value[1][4][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][4][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][4][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][4][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[1][5][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][5][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][5][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][5][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[1][6][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][6][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][6][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][6][3] = 0x04;

		nand_info->read_rety_info.reg_offset_value[1][7][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][7][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][7][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][7][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[1][8][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][8][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][8][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][8][3] = 0x74;

		nand_info->read_rety_info.reg_offset_value[1][9][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][9][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[1][9][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][9][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[1][10][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][10][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][10][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][10][3] =0x7c;

		nand_info->read_rety_info.reg_offset_value[1][11][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][11][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][11][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][11][3] =0x78;

		nand_info->read_rety_info.reg_offset_value[1][12][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][12][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][12][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][12][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][13][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][13][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][13][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][13][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][14][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][14][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][14][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][14][3] =0x00;

		nand_info->read_rety_info.reg_offset_value[1][15][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][15][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][15][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][15][3] =0x7c;

		nand_info->read_rety_info.reg_offset_value[1][16][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][16][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][16][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][16][3] =0x04;

		nand_info->read_rety_info.reg_offset_value[1][17][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][17][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][17][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][17][3] =0x7c;

		nand_info->read_rety_info.reg_offset_value[1][18][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][18][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][18][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][18][3] =0x78;

		nand_info->read_rety_info.reg_offset_value[1][19][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][19][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][19][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][19][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][20][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][20][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][20][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][20][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][21][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][21][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][21][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][21][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][22][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][22][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][22][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][22][3] =0x78;

		nand_info->read_rety_info.reg_offset_value[1][23][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][23][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][23][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][23][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][24][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][24][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][24][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][24][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][25][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][25][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][25][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][25][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][26][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][26][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][26][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][26][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][27][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][27][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][27][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][27][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][28][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][28][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][28][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][28][3] =0x6c;


		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handleA19_sandisk;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_A19_sandisk;

	} else if(!strncmp((char*)type->id, (char*)dev_id_sandisk_a19nm_4g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {

		nand_info->type =  SANDISK_A19NM_4G;
		aml_chip->ran_mode = 1;
		nand_info->dynamic_read_info.dynamic_read_flag = 0; //DRF


		nand_info->read_rety_info.reg_addr[0] = 0x11;
		nand_info->read_rety_info.reg_cnt = 4;
		nand_info->read_rety_info.retry_cnt = 30;

		////////////lower page read ////////////////////////////////////
		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][0][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][0][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][0][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][1][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][1][2] = 0x7C;
		nand_info->read_rety_info.reg_offset_value[0][1][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][2][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][2][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][2][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x08;
		nand_info->read_rety_info.reg_offset_value[0][3][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][3][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][3][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][4][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][4][2] = 0x7C;
		nand_info->read_rety_info.reg_offset_value[0][4][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[0][5][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][5][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][5][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][6][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][6][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][6][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][7][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][7][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][8][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][8][2] = 0x7C;
		nand_info->read_rety_info.reg_offset_value[0][8][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][9][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][9][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][9][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][9][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][10][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][10][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][10][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][10][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][11][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][11][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][11][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][11][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][12][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][12][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][12][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][12][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][13][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][13][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][13][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][13][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][14][0] = 0x0C;
		nand_info->read_rety_info.reg_offset_value[0][14][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][14][2] = 0x7C;
		nand_info->read_rety_info.reg_offset_value[0][14][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][15][0] = 0x0C;
		nand_info->read_rety_info.reg_offset_value[0][15][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][15][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][15][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][16][0] = 0x10;
		nand_info->read_rety_info.reg_offset_value[0][16][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][16][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][16][3] = 0x00;


		nand_info->read_rety_info.reg_offset_value[0][17][0] = 0x10;
		nand_info->read_rety_info.reg_offset_value[0][17][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][17][2] = 0x04;
		nand_info->read_rety_info.reg_offset_value[0][17][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][18][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][18][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][18][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][18][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][19][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][19][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][19][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][19][3] = 0x00;


		nand_info->read_rety_info.reg_offset_value[0][20][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][20][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][20][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][20][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][21][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][21][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][21][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][21][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][22][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][22][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][22][2] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][22][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][23][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][23][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][23][2] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][23][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][24][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][24][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][24][2] = 0x6C;
		nand_info->read_rety_info.reg_offset_value[0][24][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][25][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][25][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][25][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][25][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][26][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][26][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][26][2] = 0x70;
		nand_info->read_rety_info.reg_offset_value[0][26][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][27][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][27][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][27][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][27][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][28][0] = 0x78;
		nand_info->read_rety_info.reg_offset_value[0][28][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][28][2] = 0x68;
		nand_info->read_rety_info.reg_offset_value[0][28][3] = 0x00;

		nand_info->read_rety_info.reg_offset_value[0][29][0] = 0x74;
		nand_info->read_rety_info.reg_offset_value[0][29][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[0][29][2] = 0x6c;
		nand_info->read_rety_info.reg_offset_value[0][29][3] = 0x00;

		/////////////////upper page read///////////////////////////////
		nand_info->read_rety_info.reg_offset_value[1][0][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][0][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[1][1][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][1][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[1][2][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][1] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][3] = 0x74;

		nand_info->read_rety_info.reg_offset_value[1][3][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][3][1] = 0x7C;
		nand_info->read_rety_info.reg_offset_value[1][3][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][3][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[1][4][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][4][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][4][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][4][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[1][5][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][5][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][5][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][5][3] = 0x74;

		nand_info->read_rety_info.reg_offset_value[1][6][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][6][1] = 0x7c;
		nand_info->read_rety_info.reg_offset_value[1][6][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][6][3] = 0x70;

		nand_info->read_rety_info.reg_offset_value[1][7][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][7][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[1][7][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][7][3] = 0x7c;

		nand_info->read_rety_info.reg_offset_value[1][8][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][8][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[1][8][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][8][3] = 0x78;

		nand_info->read_rety_info.reg_offset_value[1][9][0] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][9][1] = 0x78;
		nand_info->read_rety_info.reg_offset_value[1][2][2] = 0x00;
		nand_info->read_rety_info.reg_offset_value[1][2][3] = 0x74;

		nand_info->read_rety_info.reg_offset_value[1][10][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][10][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][10][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][10][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][11][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][11][1] =0x78;
		nand_info->read_rety_info.reg_offset_value[1][11][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][11][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][12][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][12][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][12][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][12][3] =0x00;

		nand_info->read_rety_info.reg_offset_value[1][13][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][13][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][13][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][13][3] =0x7c;

		nand_info->read_rety_info.reg_offset_value[1][14][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][14][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][14][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][14][3] =0x78;

		nand_info->read_rety_info.reg_offset_value[1][15][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][15][1] =0x04;
		nand_info->read_rety_info.reg_offset_value[1][15][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][15][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][16][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][16][1] =0x08;
		nand_info->read_rety_info.reg_offset_value[1][16][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][16][3] =0x7c;

		nand_info->read_rety_info.reg_offset_value[1][17][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][17][1] =0x08;
		nand_info->read_rety_info.reg_offset_value[1][17][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][17][3] =0x00;

		nand_info->read_rety_info.reg_offset_value[1][18][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][18][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][18][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][18][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][19][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][19][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][19][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][19][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][20][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][20][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][20][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][20][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][21][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][21][1] =0x74;
		nand_info->read_rety_info.reg_offset_value[1][21][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][21][3] =0x68;

		nand_info->read_rety_info.reg_offset_value[1][22][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][22][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][22][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][22][3] =0x74;

		nand_info->read_rety_info.reg_offset_value[1][23][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][23][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][23][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][23][3] =0x70;

		nand_info->read_rety_info.reg_offset_value[1][24][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][24][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][24][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][24][3] =0x68;

		nand_info->read_rety_info.reg_offset_value[1][25][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][25][1] =0x70;
		nand_info->read_rety_info.reg_offset_value[1][25][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][25][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][26][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][26][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][26][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][26][3] =0x6c;

		nand_info->read_rety_info.reg_offset_value[1][27][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][27][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][27][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][27][3] =0x68;

		nand_info->read_rety_info.reg_offset_value[1][28][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][28][1] =0x6c;
		nand_info->read_rety_info.reg_offset_value[1][28][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][28][3] =0x64;

		nand_info->read_rety_info.reg_offset_value[1][29][0] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][29][1] =0x68;
		nand_info->read_rety_info.reg_offset_value[1][29][2] =0x00;
		nand_info->read_rety_info.reg_offset_value[1][29][3] =0x68;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handleA19_sandisk;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_A19_sandisk;

	}
	else  if((!strncmp((char*)type->id, (char*)dev_id_sandisk_19nm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		||(!strncmp((char*)type->id, (char*)dev_id_sandisk_19nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {
		nand_info->type =  SANDISK_19NM;
		aml_chip->ran_mode = 1;
		nand_info->dynamic_read_info.dynamic_read_flag = 0;

		nand_info->dynamic_read_info.slc_flag = 0;

		memset(&nand_info->dynamic_read_info.cur_case_num_lower_page[0],
			0, MAX_CHIP_NUM);
		memset(&nand_info->dynamic_read_info.cur_case_num_upper_page[0],
			0, MAX_CHIP_NUM);

		nand_info->dynamic_read_info.reg_addr_init[0] = 0x04;
		nand_info->dynamic_read_info.reg_addr_init[1] = 0x05;
		nand_info->dynamic_read_info.reg_addr_init[2] = 0x06;
		nand_info->dynamic_read_info.reg_addr_init[3] = 0x07;
		nand_info->dynamic_read_info.reg_addr_init[4] = 0x08;
		nand_info->dynamic_read_info.reg_addr_init[5] = 0x09;
		nand_info->dynamic_read_info.reg_addr_init[6] = 0x0a;
		nand_info->dynamic_read_info.reg_addr_init[7] = 0x0b;
		nand_info->dynamic_read_info.reg_addr_init[8] = 0x0c;

		nand_info->dynamic_read_info.reg_addr_lower_page[0] = 0x04;
		nand_info->dynamic_read_info.reg_addr_lower_page[1] = 0x05;
		nand_info->dynamic_read_info.reg_addr_lower_page[2] = 0x07;

		nand_info->dynamic_read_info.reg_addr_upper_page[0] = 0x04;
		nand_info->dynamic_read_info.reg_addr_upper_page[1] = 0x05;
		nand_info->dynamic_read_info.reg_addr_upper_page[2] = 0x07;

//lower_page
	//nand_info->dynamic_read_info.reg_offset_value_lower_page[0][0][0]=0x0;
	//nand_info->dynamic_read_info.reg_offset_value_lower_page[0][0][1]=0x0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[0][0] = 0xF0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[0][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[0][2] = 0xF0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[1][0] = 0xE0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[1][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[1][2] = 0xE0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[2][0] = 0xD0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[2][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[2][2] = 0xD0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[3][0] = 0x10;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[3][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[3][2] = 0x10;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[4][0] = 0x20;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[4][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[4][2] = 0x20;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[5][0] = 0x30;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[5][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[5][2] = 0x30;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[6][0] = 0xC0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[6][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[6][2] = 0xD0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[7][0] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[7][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[7][2] = 0x10;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[8][0] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[8][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[8][2] = 0x20;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[9][0] = 0x10;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[9][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[9][2] = 0x20;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[10][0] = 0xB0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[10][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[10][2] = 0xD0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[11][0] = 0xA0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[11][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[11][2] = 0xD0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[12][0] = 0x90;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[12][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[12][2] = 0xD0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[13][0] = 0xB0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[13][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[13][2] = 0xC0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[14][0] = 0xA0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[14][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[14][2] = 0xC0;

	nand_info->dynamic_read_info.reg_offset_value_lower_page[15][0] = 0x90;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[15][1] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_lower_page[15][2] = 0xC0;
//upper_page

	//nand_info->dynamic_read_info.reg_offset_value_upper_page[0][0][0]=0x0;
	//nand_info->dynamic_read_info.reg_offset_value_upper_page[0][0][1]=0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[0][0] = 0x0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[0][1] = 0xF0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[0][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[1][0] = 0xF;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[1][1] = 0xE0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[1][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[2][0] = 0xF;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[2][1] = 0xD0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[2][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[3][0] = 0xE;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[3][1] = 0xE0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[3][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[4][0] = 0xE;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[4][1] = 0xD0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[4][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[5][0] = 0xD;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[5][1] = 0xF0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[5][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[6][0] = 0xD;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[6][1] = 0xE0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[6][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[7][0] = 0xD;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[7][1] = 0xD0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[7][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[8][0] = 0x1;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[8][1] = 0x10;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[8][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[9][0] = 0x2;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[9][1] = 0x20;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[9][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[10][0] = 0x2;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[10][1] = 0x10;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[10][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[11][0] = 0x3;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[11][1] = 0x20;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[11][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[12][0] = 0xF;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[12][1] = 0x00;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[12][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[13][0] = 0xE;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[13][1] = 0xF0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[13][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[14][0] = 0xD;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[14][1] = 0xC0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[14][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[15][0] = 0xF;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[15][1] = 0xF0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[15][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[16][0] = 0x1;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[16][1] = 0x00;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[16][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[17][0] = 0x20;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[17][1] = 0x00;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[17][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[18][0] = 0xD;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[18][1] = 0xB0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[18][2] = 0x0;

	nand_info->dynamic_read_info.reg_offset_value_upper_page[19][0] = 0xC;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[19][1] = 0xA0;
	nand_info->dynamic_read_info.reg_offset_value_upper_page[19][2] = 0x0;

	nand_info->dynamic_read_info.dynamic_read_init =
		aml_nand_dynamic_read_init;
	nand_info->dynamic_read_info.dynamic_read_handle =
		aml_nand_dynamic_read_handle;
	nand_info->dynamic_read_info.dynamic_read_exit =
		aml_nand_dynamic_read_exit;
	nand_info->dynamic_read_info.enter_slc_mode =
		aml_nand_enter_slc_mode_sandisk;
	nand_info->dynamic_read_info.exit_slc_mode=
		aml_nand_exit_slc_mode_sandisk;

	} else  if((!strncmp((char*)type->id, (char*)dev_id_micron_20nm_8g,
			strlen((const char*)aml_nand_flash_ids[i].id)))
		||(!strncmp((char*)type->id, (char*)dev_id_micron_20nm_4g,
			strlen((const char*)aml_nand_flash_ids[i].id)))) {
		nand_info->type =  MICRON_20NM;
		aml_chip->ran_mode = 1;

		nand_info->read_rety_info.reg_addr[0] = 0x89;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0x1;
		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x2;
		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x3;
		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x4;
		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x5;
		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x6;
		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x7;


		nand_info->read_rety_info.reg_cnt = 1;
		nand_info->read_rety_info.retry_cnt = 7;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_micron;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_micron;
	} else if(!strncmp((char*)type->id, (char*)dev_id_intel_20nm_8g,
		strlen((const char*)aml_nand_flash_ids[i].id))) {
		aml_chip->ran_mode = 1;
#if 1
		nand_info->type =  INTEL_20NM;
		nand_info->read_rety_info.reg_addr[0] = 0x89;
		nand_info->read_rety_info.reg_addr[1] = 0x93;

		nand_info->read_rety_info.reg_offset_value[0][0][0] = 0x1;
		nand_info->read_rety_info.reg_offset_value[0][1][0] = 0x2;
		nand_info->read_rety_info.reg_offset_value[0][2][0] = 0x3;
		nand_info->read_rety_info.reg_offset_value[0][3][0] = 0x0;
		nand_info->read_rety_info.reg_offset_value[0][4][0] = 0x1;
		nand_info->read_rety_info.reg_offset_value[0][5][0] = 0x2;
		nand_info->read_rety_info.reg_offset_value[0][6][0] = 0x3;

		nand_info->read_rety_info.reg_cnt = 2;
		nand_info->read_rety_info.retry_cnt = 7;

		nand_info->read_rety_info.read_retry_handle =
			aml_nand_read_retry_handle_intel;
		nand_info->read_rety_info.read_retry_exit =
			aml_nand_read_retry_exit_intel;
#endif
}

#endif

#ifdef CONFIG_MTD_DEVICE
	//mtd->name = NULL;
	//if (!mtd->info)
		mtd->name = type->name;
#else
	if (!mtd->name)
		mtd->name = type->name;
#endif

	chip->chipsize = type->chipsize;
	chip->chipsize = chip->chipsize << 20;

	/* Newer devices have all the information in additional id bytes */
	if (!type->pagesize) {
		int extid;
		/* The 3rd id byte holds MLC / multichip data */
		//chip->cellinfo = chip->read_byte(mtd);
		/* The 4th id byte is the important one */
		extid = chip->read_byte(mtd);
		/* Calc pagesize */
		mtd->writesize = 1024 << (extid & 0x3);
		extid >>= 2;
		/* Calc oobsize */
		mtd->oobsize = (8 << (extid & 0x01)) * (mtd->writesize >> 9);
		extid >>= 2;
		/* Calc blocksize. Blocksize is multiples of 64KiB */
		mtd->erasesize = (64 * 1024) << (extid & 0x03);
		extid >>= 2;
		/* Get buswidth information */
		busw = (extid & 0x01) ? NAND_BUSWIDTH_16 : 0;

	} else {
		/*
		 * Old devices have chip data hardcoded in the device id table
		 */
		mtd->erasesize = type->erasesize;
		mtd->writesize = type->pagesize;
		mtd->oobsize = type->oobsize;
		busw = type->options & NAND_BUSW_OPTIONS_MASK;
	}

	/* Try to identify manufacturer */
	for (maf_idx = 0; nand_manuf_ids[maf_idx].id != 0x0; maf_idx++) {
		if (nand_manuf_ids[maf_idx].id == *maf_id)
			break;
	}

	/*
	 * Check, if buswidth is correct. Hardware drivers should set
	 * chip correct !
	 */
	if (busw != (chip->options & NAND_BUSWIDTH_16)) {
		printk(KERN_INFO "NAND device: Manufacturer ID:"
		       " 0x%02x, Chip ID: 0x%02x (%s %s)\n", *maf_id,
		       dev_id[0], nand_manuf_ids[maf_idx].name, mtd->name);
		printk(KERN_WARNING "NAND bus width %d instead %d bit\n",
		       (chip->options & NAND_BUSWIDTH_16) ? 16 : 8,
		       busw ? 16 : 8);
		return ERR_PTR(-EINVAL);
	}

	/* Calculate the address shift from the page size */
	chip->page_shift = ffs(mtd->writesize) - 1;
	/* Convert chipsize to number of pages per chip -1. */
	chip->pagemask = (chip->chipsize >> chip->page_shift) - 1;

	chip->bbt_erase_shift = chip->phys_erase_shift= ffs(mtd->erasesize) - 1;
	chip->chip_shift = ffs(chip->chipsize) - 1;

	/* Set the bad block position */
	chip->badblockpos = AML_BADBLK_POS;

	/* Get chip options, preserve non chip based options */
	//chip->options &= ~NAND_CHIPOPTIONS_MSK;
	//chip->options |= type->options & NAND_CHIPOPTIONS_MSK;

	/*
	 * Set chip as a default. Board drivers can override it, if necessary
	 */
	//chip->options |= NAND_NO_AUTOINCR;

	/* Check if chip is a not a samsung device. Do not clear the
	 * options for chips which are not having an extended id.
	 */
	//if (*maf_id != NAND_MFR_SAMSUNG && !type->pagesize)
		//chip->options &= ~NAND_SAMSUNG_LP_OPTIONS;

	printk(KERN_INFO "NAND device: Manufacturer ID:"
	       " 0x%02x, Chip ID: 0x%02x (%s %s)\n", *maf_id, dev_id[0],
	       nand_manuf_ids[maf_idx].name, type->name);

	return type;
}


static int aml_nand_scan_ident(struct mtd_info *mtd, int maxchips)
{
	int i, busw, nand_maf_id, valid_chip_num = 1;
	struct nand_chip *chip = mtd->priv;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	struct aml_nand_flash_dev *aml_type;
	struct aml_nand_platform *plat = aml_chip->platform;
	u8 dev_id[MAX_ID_LEN], onfi_features[4];
	unsigned temp_chip_shift;

	chip->cmdfunc = aml_nand_command;
	chip->waitfunc = aml_nand_wait;
	chip->erase_cmd = aml_nand_erase_cmd;
	chip->write_page = aml_nand_write_page;

	/* Get buswidth to select the correct functions */
	busw = chip->options & NAND_BUSWIDTH_16;

	/* Select the device */
	chip->select_chip(mtd, 0);

	//reset chip for some nand need reset after power up
	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
	aml_chip->aml_nand_wait_devready(aml_chip, 0);

	/* Read the flash type */
	aml_type = aml_nand_get_flash_type(mtd, chip, busw, &nand_maf_id);

	if (IS_ERR(aml_type)) {
		printk(KERN_WARNING "No NAND device found!!!\n");
		chip->select_chip(mtd, -1);
		return PTR_ERR(aml_type);
	}

	if (aml_type->erasesize < 0x40000) {
		aml_chip->keysize = aml_type->erasesize / 4;
		aml_chip->dtbsize = aml_type->erasesize;
	} else {
		/*
		fix size key/dtb!!!
		max key/dtb size is 256KB
		*/
		aml_chip->keysize = 0x40000;
		aml_chip->dtbsize = 0x40000;
	}

	chip->cmdfunc(mtd, NAND_CMD_READID, 0x20, -1);
	for (i=0; i<MAX_ID_LEN; i++) {
		dev_id[i] = chip->read_byte(mtd);
	}
	if (!memcmp((char*)dev_id, "ONFI", 4))
		aml_chip->onfi_mode = aml_type->onfi_mode;

	aml_chip->T_REA = aml_type->T_REA;
	aml_chip->T_RHOH = aml_type->T_RHOH;
	aml_chip->mfr_type = aml_type->id[0];
#ifdef CONFIG_PARAMETER_PAGE
	aml_nand_read_parameter_page(mtd, CE0, &para_page);
	display_para_page(para_page, 0);
#endif
	/* Check for a chip array */
	for (i = 1; i < maxchips; i++) {
		aml_chip->aml_nand_select_chip(aml_chip, i);
		chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
		aml_chip->aml_nand_wait_devready(aml_chip, i);

		/* Send the command for reading device ID */
		chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
		/* Read manufacturer and device IDs */

		if (nand_maf_id != chip->read_byte(mtd)
			|| aml_type->id[1] != chip->read_byte(mtd))
		//if (nand_maf_id != dev_id[0] || aml_type->id[1] != dev_id[1])
			aml_chip->valid_chip[i] = 0;
		else
			valid_chip_num ++;
	}

	if (i > 1) {
		printk(KERN_INFO "%d NAND chips detected\n", valid_chip_num);
		/*if ((aml_chip->valid_chip[1] == 0)
			&& (aml_chip->valid_chip[2] == 1)) {
			printk("ce1 and ce2 connected\n");
			aml_chip->chip_enable[2] =
			(aml_chip->chip_enable[1] & aml_chip->chip_enable[2]);
		}*/
	}

	/*
	 *fixit, Need to send dummy cmd for spansion(MLO2G100BH1OO) which is different
	 *from others.
	 */
	if (aml_chip->mfr_type  == NAND_MFR_AMD )
		chip->cmdfunc(mtd, 0x00, -1, -1);

	if (aml_chip->onfi_mode) {
		aml_nand_set_onfi_features(aml_chip,
			(uint8_t *)(&aml_chip->onfi_mode), ONFI_TIMING_ADDR);
		aml_nand_get_onfi_features(aml_chip,
			onfi_features, ONFI_TIMING_ADDR);
		if (onfi_features[0] != aml_chip->onfi_mode) {
			aml_chip->T_REA = DEFAULT_T_REA;
			aml_chip->T_RHOH = DEFAULT_T_RHOH;
			printk("onfi timing mode set failed: %x\n",
			onfi_features[0]);
		}
	}

	/* Store the number of chips and calc total size for mtd */
	chip->numchips = 1;
	if ((chip->chipsize >> 32) & 0xffffffff)
		chip->chip_shift =
		fls((unsigned)(chip->chipsize >> 32)) * valid_chip_num + 32 - 1;
	else
		chip->chip_shift =
		fls((unsigned)chip->chipsize) * valid_chip_num - 1;

	chip->pagemask =
		((chip->chipsize * valid_chip_num) >> chip->page_shift) - 1;
	chip->options &= ~NAND_CACHEPRG;
	aml_chip->internal_chipnr = aml_type->internal_chipnr;
	aml_chip->internal_page_nums = (chip->chipsize >> chip->page_shift);
	aml_chip->internal_page_nums /= aml_chip->internal_chipnr;
	aml_chip->internal_chip_shift =
		fls((unsigned)aml_chip->internal_page_nums) - 1;
	temp_chip_shift = ffs((unsigned)aml_chip->internal_page_nums) - 1;
	if (aml_chip->internal_chip_shift != temp_chip_shift) {
		aml_chip->internal_chip_shift += 1;
		chip->chip_shift += 1;
		chip->pagemask =
			((1 << (chip->chip_shift + 1)) >> chip->page_shift) - 1;
	}

	aml_chip->options = aml_type->options;
	aml_chip->page_size = aml_type->pagesize;
	aml_chip->block_size = aml_type->erasesize;
	aml_chip->oob_size = aml_type->oobsize;
	mtd->erasesize = valid_chip_num * aml_type->erasesize;
	mtd->writesize = valid_chip_num * aml_type->pagesize;
	mtd->oobsize = valid_chip_num * aml_type->oobsize;
	mtd->size = valid_chip_num * chip->chipsize;

	/* overide bootloader's size consdering info page */
	/* fixme, need -1 for each copies? */
	if (!strncmp((char*)plat->name,
		NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))
		mtd->size =  BOOT_TOTAL_PAGES * mtd->writesize;

	return 0;
}

int aml_nand_scan(struct mtd_info *mtd, int maxchips)
{
	int ret;

	ret = aml_nand_scan_ident(mtd, maxchips);
	if (!ret)
		ret = nand_scan_tail(mtd);
	return ret;
}



