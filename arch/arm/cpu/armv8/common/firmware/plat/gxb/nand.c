/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic nand spl module
 * Author: nand team @amlogic.com
 * Created time: 2015.04.28
 *
 */

#include <config.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <io.h>
#include <platform_def.h>
#include <asm/arch/io.h>
#include <asm/arch/nand.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/romboot.h>
#include <arch_helpers.h>

//#define NFIO_LINE  do { printf("%s %d\n", __func__, __LINE__); } while(0);
#define NFIO_LINE

/* global */
nand_setup_t glb_setup; // 8 bytes

ext_info_t glb_ext_info = {
	.read_info = 0,
	.new_type = 0,
	.xlc = 0,
};

unsigned char page_list_hynix_1y[128] = {
	0x00, 0x01, 0x03, 0x05, 0x07, 0x09, 0x0b, 0x0d,
	0x0f, 0x11, 0x13, 0x15, 0x17, 0x19, 0x1b, 0x1d,
	0x1f, 0x21, 0x23, 0x25, 0x27, 0x29, 0x2b, 0x2d,
	0x2f, 0x31, 0x33, 0x35, 0x37, 0x39, 0x3b, 0x3d,

	0x3f, 0x41, 0x43, 0x45, 0x47, 0x49, 0x4b, 0x4d,
	0x4f, 0x51, 0x53, 0x55, 0x57, 0x59, 0x5b, 0x5d,
	0x5f, 0x61, 0x63, 0x65, 0x67, 0x69, 0x6b, 0x6d,
	0x6f, 0x71, 0x73, 0x75, 0x77, 0x79, 0x7b, 0x7d,

	0x7f, 0x81, 0x83, 0x85, 0x87, 0x89, 0x8b, 0x8d,
	0x8f, 0x91, 0x93, 0x95, 0x97, 0x99, 0x9b, 0x9d,
	0x9f, 0xa1, 0xA3, 0xA5, 0xA7, 0xA9, 0xAb, 0xAd,
	0xAf, 0xb1, 0xB3, 0xB5, 0xB7, 0xB9, 0xBb, 0xBd,

	0xBf, 0xc1, 0xC3, 0xC5, 0xC7, 0xC9, 0xCb, 0xCd,
	0xCf, 0xd1, 0xD3, 0xD5, 0xD7, 0xD9, 0xDb, 0xDd,
	0xDf, 0xe1, 0xE3, 0xE5, 0xE7, 0xE9, 0xEb, 0xEd,
	0xEf, 0xf1, 0xF3, 0xF5, 0xF7, 0xF9, 0xFb, 0xFd,
};

unsigned char page_list_hynix_2x[128] = {
	0x00, 0x01, 0x02, 0x03, 0x06, 0x07, 0x0A, 0x0B,
	0x0E, 0x0F, 0x12, 0x13, 0x16, 0x17, 0x1A, 0x1B,
	0x1E, 0x1F, 0x22, 0x23, 0x26, 0x27, 0x2A, 0x2B,
	0x2E, 0x2F, 0x32, 0x33, 0x36, 0x37, 0x3A, 0x3B,

	0x3E, 0x3F, 0x42, 0x43, 0x46, 0x47, 0x4A, 0x4B,
	0x4E, 0x4F, 0x52, 0x53, 0x56, 0x57, 0x5A, 0x5B,
	0x5E, 0x5F, 0x62, 0x63, 0x66, 0x67, 0x6A, 0x6B,
	0x6E, 0x6F, 0x72, 0x73, 0x76, 0x77, 0x7A, 0x7B,

	0x7E, 0x7F, 0x82, 0x83, 0x86, 0x87, 0x8A, 0x8B,
	0x8E, 0x8F, 0x92, 0x93, 0x96, 0x97, 0x9A, 0x9B,
	0x9E, 0x9F, 0xA2, 0xA3, 0xA6, 0xA7, 0xAA, 0xAB,
	0xAE, 0xAF, 0xB2, 0xB3, 0xB6, 0xB7, 0xBA, 0xBB,

	0xBE, 0xBF, 0xC2, 0xC3, 0xC6, 0xC7, 0xCA, 0xCB,
	0xCE, 0xCF, 0xD2, 0xD3, 0xD6, 0xD7, 0xDA, 0xDB,
	0xDE, 0xDF, 0xE2, 0xE3, 0xE6, 0xE7, 0xEA, 0xEB,
	0xEE, 0xEF, 0xF2, 0xF3, 0xF6, 0xF7, 0xFA, 0xFB,
};

#define PRINT	printf
#if 0
static void _dump_mem_u8(uint8_t * buf, uint32_t len)
{
	uint32_t i;
	PRINT("%s, %p, %d", __func__, buf, len);
	for (i = 0; i < len/sizeof(uint8_t); i++) {

		if ( i % 16 == 0)
			PRINT("\n0x%p: ", buf+i);
		PRINT("%02x ", buf[i]);
	}
	PRINT("\n");
	return;
}
#endif //0

void nfio_pin_mux(void)
{
    *P_PAD_PULL_UP_EN_REG2 = 0xffff87ff;
    *P_PAD_PULL_UP_REG2 = 0xffff8700;
    *P_PERIPHS_PIN_MUX_4 = (1<<31) | (1<<30) | (0x3ff<<20);
}

uint32_t nfio_reset(void)
{
    uint32_t tmp;

    // Reset NAND controller
    (*P_NAND_CMD) = (1<<31);

    // Reset NAND
    (*P_NAND_CMD) = (CE0 | IDLE);
    (*P_NAND_CMD) = (CE0 | CLE | 0xff);
    (*P_NAND_CMD) = (CE0 | IDLE | 10);

    // nand cycle = 200ns.
    // Set time out 2^13* nand cycle, 1.7ms
    if ( glb_setup.cfg.b.no_rb ) { // without RB
        (*P_NAND_CMD) = (CE0 | CLE | 0x70);
        (*P_NAND_CMD) = (CE0 | IDLE | 2);
        (*P_NAND_CMD) = (IO6 | RB | 13);
    }
    else { // with RB
        *P_NAND_CMD = (CE0 | RB | 13);
    }

    (*P_NAND_CMD) = (CE0 | IDLE);
    (*P_NAND_CMD) = (CE0 | IDLE);

    // if NAND is not installed or Reset failed,
    // the RB time out is set.
    while (((tmp = (*P_NAND_CMD))>>22&0x1f) > 0) {
        if (tmp>>27&1) { // time out
            (*P_NAND_CMD) = (1<<31);
            return ERROR_NAND_TIMEOUT;
        }
    }

    return 0;
}

/*
 * read nand manufactor id into retry info.
 */
static uint16_t _read_id(void)
{
	uint16_t id;

	(*P_NAND_CMD) = (CE0 | IDLE);
	(*P_NAND_CMD) = (CE0 | CLE | 0x90);
	(*P_NAND_CMD) = (CE0 | IDLE | 3);
	(*P_NAND_CMD) = (CE0 | ALE | 0);
	(*P_NAND_CMD) = (CE0 | IDLE | 3);
	(*P_NAND_CMD) = (CE0 | DRD | 3);

	(*P_NAND_CMD) = (CE0 | IDLE);
	(*P_NAND_CMD) = (CE0 | IDLE);
	while (((*P_NAND_CMD)>>22&0x1f) > 0);

	id = (*P_NAND_BUF)&0xff;

	return id;
}

static void _set_retry(uint16_t id)
{
	switch (glb_setup.id) {
        case NAND_MFR_MICRON :
            glb_setup.max = 8;
            break;
        case NAND_MFR_TOSHIBA :
            glb_setup.max = 8;
            break;
        case NAND_MFR_SAMSUNG :
            glb_setup.max = 15;
            break;
        case NAND_MFR_SANDISK :
            glb_setup.max = 22;
            break;
        case NAND_MFR_HYNIX :
        case NAND_MFR_FUJITSU :
        case NAND_MFR_NATIONAL :
        case NAND_MFR_RENESAS :
        case NAND_MFR_STMICRO :
        case NAND_MFR_AMD :
        case NAND_MFR_INTEL :
            glb_setup.max = 0;
            break;
        default :
            glb_setup.max = 0;
            break;
	}
}
// toshiba retry ------------------------------------------
// 0    : pre condition + retry 0.
// 1~6  : valid retry, otherwise no action.
// 7, 0xff : exit, back to normal.
// loop from 0 to 7, total 8.
void read_retry_toshiba(uint32_t retry, uint32_t *cmd)
{
    unsigned char val[] = {
        0x04, 0x04, 0x7C, 0x7E,
        0x00, 0x7C, 0x78, 0x78,
        0x7C, 0x76, 0x74, 0x72,
        0x08, 0x08, 0x00, 0x00,
        0x0B, 0x7E, 0x76, 0x74,
        0x10, 0x76, 0x72, 0x70,
        0x02, 0x00, 0x7E, 0x7C,
        0x00, 0x00, 0x00, 0x00};
    uint32_t i, k, retry_val_idx;

    i = 0;
    if (retry == 7) retry = 0xff;
    retry_val_idx = retry == 0xff ? 7 : retry;

    if (retry_val_idx < 8) {
        // pre condition, send before first.
        if (retry == 0) {
            cmd[i++] = (CE0 | CLE | 0x5c);
            cmd[i++] = (CE0 | CLE | 0xc5);
            cmd[i++] = (CE0 | IDLE);
        }

        for (k=4; k<8; k++) {
            cmd[i++] = (CE0 | CLE  | 0x55);
            cmd[i++] = (CE0 | IDLE | 2);        //Tcalsv
            cmd[i++] = (CE0 | ALE  | k);
            cmd[i++] = (CE0 | IDLE | 2);        //Tcalsv
            cmd[i++] = (CE0 | DWR  | val[retry_val_idx*4 + k-4]);
            cmd[i++] = (CE0 | IDLE);
        }

        cmd[i++] = (CE0 | CLE  | 0x55);
        cmd[i++] = (CE0 | IDLE | 2);        //Tcalsv
        cmd[i++] = (CE0 | ALE  | 0xd);
        cmd[i++] = (CE0 | IDLE | 2);        //Tcalsv
        cmd[i++] = (CE0 | DWR  | 0);
        cmd[i++] = (CE0 | IDLE);

        if (retry == 6) {
            cmd[i++] = (CE0 | CLE | 0xb3);
            cmd[i++] = (CE0 | IDLE);
        }

        if (retry != 0xff) {
            cmd[i++] = (CE0 | CLE | 0x26);
            cmd[i++] = (CE0 | CLE | 0x5d);
            cmd[i++] = (CE0 | IDLE);
        }
    }

    // exit and check rb
    if (retry == 0xff) {
        cmd[i++] = (CE0 | CLE  | 0xff);
        cmd[i++] = (CE0 | IDLE | 2);        //Twb

        if (glb_setup.cfg.b.no_rb) {
            cmd[i++] = (CE0 | CLE  | 0x70);
            cmd[i++] = (CE0 | IDLE | 2);
            cmd[i++] = (IO6 | RB   | 13);
        }
        else{
            cmd[i++] = (CE0 | RB | 13);
        }
    }

    cmd[i] = 0;
}

// sandisk retry ------------------------------------------
// 0    : activation + retry 0.
// 1~20 : valid retry, otherwise no action.
// 21, 0xff : exit
// loop from 0 to 21, total 22.
void read_retry_sandisk(uint32_t retry, uint32_t *cmd)
{
    uint32_t i, k;
    unsigned char val[] = {
        0x00, 0x00, 0x00,
        0xf0, 0xf0, 0xf0,
        0xef, 0xe0, 0xe0,
        0xdf, 0xd0, 0xd0,
        0x1e, 0xe0, 0x10,
        0x2e, 0xd0, 0x20,
        0x3d, 0xf0, 0x30,
        0xcd, 0xe0, 0xd0,
        0x0d, 0xd0, 0x10,
        0x01, 0x10, 0x20,
        0x12, 0x20, 0x20,
        0xb2, 0x10, 0xd0,
        0xa3, 0x20, 0xd0,
        0x9f, 0x00, 0xd0,
        0xbe, 0xf0, 0xc0,
        0xad, 0xc0, 0xc0,
        0x9f, 0xf0, 0xc0,
        0x01, 0x00, 0x00,
        0x02, 0x00, 0x00,
        0x0d, 0xb0, 0x00,
        0x0c, 0xa0, 0x00};

    i = 0;
    if (retry == 21) retry = 0xff;

    if (retry == 0) { // activation and init, entry 0.
        cmd[i++] = (CE0 | CLE | 0x3b);
        cmd[i++] = (CE0 | CLE | 0xb9);
        for (k=4; k<13; k++) {
            cmd[i++] = (CE0 | CLE | 0x54);
            cmd[i++] = (CE0 | ALE | k);
            cmd[i++] = (CE0 | DWR | 0);
        }
        cmd[i++] = (CE0 | CLE | 0xb6);
    }
    else if (retry < 21) { // entry: 1~20
        cmd[i++] = (CE0 | CLE | 0x3b);
        cmd[i++] = (CE0 | CLE | 0xb9);
        for (k=0; k<3; k++) {
            cmd[i++] = (CE0 | CLE | 0x54);
            cmd[i++] = (CE0 | ALE | (k==0?4:k==1?5:7));
            cmd[i++] = (CE0 | DWR | val[retry*3+k]);
        }
        cmd[i++] = (CE0 | CLE | 0xb6);
    }
    else if (retry == 255) {
        cmd[i++] = (CE0 | CLE | 0x3b);
        cmd[i++] = (CE0 | CLE | 0xb9);
        for (k=0; k<3; k++) {
            cmd[i++] = (CE0 | CLE | 0x54);
            cmd[i++] = (CE0 | ALE | (k==0?4:k==1?5:7));
            cmd[i++] = (CE0 | DWR | 0);
        }
        cmd[i++] = (CE0 | CLE | 0xd6);
    }
    cmd[i] = 0;
}

// micron retry ------------------------------------------
// 0    : disable
// 1~7  : valid retry, otherwise no action.
// 0xff : same as 0.
// loop from 0 to 7, total 8.
void read_retry_micron(uint32_t retry, uint32_t *cmd)
{
    uint32_t i;

    i = 0;
    if (retry == 0xff) retry = 0;

    if (retry < 8) {
        cmd[i++] = (CE0 | CLE  | 0xef);
        cmd[i++] = (CE0 | ALE  | 0x89);
        cmd[i++] = (CE0 | IDLE | 3);        //Tadl
        cmd[i++] = (CE0 | DWR  | retry);
        cmd[i++] = (CE0 | DWR  | 0);
        cmd[i++] = (CE0 | DWR  | 0);
        cmd[i++] = (CE0 | DWR  | 0);
        cmd[i++] = (CE0 | IDLE | 2);        //Twb

        //check rb for Tfeat
        if (glb_setup.cfg.b.no_rb) {
            cmd[i++] = (CE0 | CLE  | 0x70);
            cmd[i++] = (CE0 | IDLE | 2);
            cmd[i++] = (IO6 | RB   | 13);
        }
        else{
            cmd[i++] = (CE0 | RB | 13);
        }
    }

    cmd[i] = 0;
}

void read_retry_hynix(uint32_t retry, uint32_t *cmd)
{
    // use SLC mode.
}

// samsung retry ------------------------------------------
// 0    : disable
// 1~14 : valid retry, otherwise no action.
// 0xff : same as 0.
// loop from 0 to 14, total 15.
void read_retry_samsung(uint32_t retry, uint32_t *cmd)
{
    uint32_t i, k;
    unsigned char adr[] = {
        0xa7, 0xa4, 0xa5, 0xa6};
    unsigned char val[] = {
        0x00, 0x00, 0x00, 0x00,
        0x05, 0x0A, 0x00, 0x00,
        0x28, 0x00, 0xEC, 0xD8,
        0xED, 0xF5, 0xED, 0xE6,
        0x0A, 0x0F, 0x05, 0x00,
        0x0F, 0x0A, 0xFB, 0xEC,
        0xE8, 0xEF, 0xE8, 0xDC,
        0xF1, 0xFB, 0xFE, 0xF0,
        0x0A, 0x00, 0xFB, 0xEC,
        0xD0, 0xE2, 0xD0, 0xC2,
        0x14, 0x0F, 0xFB, 0xEC,
        0xE8, 0xFB, 0xE8, 0xDC,
        0x1E, 0x14, 0xFB, 0xEC,
        0xFB, 0xFF, 0xFB, 0xF8,
        0x07, 0x0C, 0x02, 0x00};

    i = 0;
    if (retry == 0xff) retry = 0;
    if (retry < 15) {
        for (k=0; k<4; k++) {
            cmd[i++] = (CE0 | CLE  | 0xa1);
            cmd[i++] = (CE0 | ALE  | 0);
            cmd[i++] = (CE0 | ALE  | adr[k]);
            cmd[i++] = (CE0 | IDLE | 2);        //Tadl
            cmd[i++] = (CE0 | DWR  | val[retry*4+k]);
            cmd[i++] = (CE0 | IDLE | 8);        //over 300ns before next cmd
        }
    }
    cmd[i] = 0;
}


void nfio_read_retry(uint32_t mode)
{
    static uint32_t retry = 0;
    uint32_t i, cmd[128];

    if (glb_setup.max == 0)
        return;

    switch (glb_setup.id) {
		case NAND_MFR_MICRON:
      NFIO_LINE
			read_retry_micron(retry, cmd);
			break;

		case NAND_MFR_TOSHIBA:
			read_retry_toshiba(retry, cmd);
			break;

		case NAND_MFR_HYNIX:
			read_retry_hynix(retry, cmd);
			break;

		case NAND_MFR_SAMSUNG:
			read_retry_samsung(retry, cmd);
			break;

		case NAND_MFR_SANDISK:
			read_retry_sandisk(retry, cmd);
			break;

		/* todo, add other read retry here! */
    }

    retry = retry+1 < glb_setup.max ? retry+1 : 0;

    i = 0;
    while (((*P_NAND_CMD)>>22&0x1f)<0x1f && cmd[i] != 0) {
        (*P_NAND_CMD) = cmd[i++];
    }
}

// read one page
uint32_t nfio_page_read(uint32_t src, uint32_t mem)
{
    uint32_t k, ecc_pages;
    uint32_t info;
    uint64_t mem_addr;
//    uint64_t src64 = (uint64_t) mem;
    uint32_t info_adr = NAND_INFO_BUF;	//use romboot's buffer.
	uint64_t info_adr64;
	uint64_t * p_info_buf;
	volatile uint64_t dma_done;

    // page size, unit: 8 bytes
    //ecc_mode   = glb_setup.cfg.b.cmd>>14&7;
    //short_mode = glb_setup.cfg.b.cmd>>13&1;
    //short_size = glb_setup.cfg.b.cmd>>6&0x7f;
    ecc_pages      = glb_setup.cfg.b.cmd&0x3f;

	NFIO_LINE
	info_adr64 = (uint64_t) info_adr;
	p_info_buf = (uint64_t *)info_adr64;

	memset(p_info_buf, 0, ecc_pages * INFO_BYTE_PER_ECCPAGE);
	flush_dcache_range((uint64_t)p_info_buf, (uint64_t)(ecc_pages * sizeof(uint64_t)));

    while (((*P_NAND_CMD)>>22&0x1f) > 0);
	NFIO_LINE

    // add A2H command for SLC read
    if ( glb_setup.cfg.b.a2 ) {
        (*P_NAND_CMD) = (CE0 | IDLE);
        (*P_NAND_CMD) = (CE0 | CLE | 0xa2);
        (*P_NAND_CMD) = (CE0 | IDLE);
    }
	NFIO_LINE
    // send cmds
    (*P_NAND_CMD) = CE0 | IDLE;
    (*P_NAND_CMD) = CE0 | CLE  | 0;
    (*P_NAND_CMD) = CE0 | ALE  | 0;
    if ( glb_setup.cfg.b.large_page ) {
		NFIO_LINE
        (*P_NAND_CMD) = CE0 | ALE  | 0;
    }
    (*P_NAND_CMD) = CE0 | ALE  | ((src)&0xff);
    (*P_NAND_CMD) = CE0 | ALE  | ((src>>8)&0xff);
    (*P_NAND_CMD) = CE0 | ALE  | 0;
    if ( glb_setup.cfg.b.large_page ) {
		NFIO_LINE
        (*P_NAND_CMD) = CE0 | CLE  | 0x30;
    }
	NFIO_LINE
    if ( glb_setup.cfg.b.no_rb ) { // without RB
		NFIO_LINE
        (*P_NAND_CMD) = CE0 | IDLE;
        (*P_NAND_CMD) = CE0 | CLE  | 0x70;
        (*P_NAND_CMD) = CE0 | IDLE | 2;
        (*P_NAND_CMD) = IO6 | RB | 13;
        (*P_NAND_CMD) = CE0 | IDLE | 2;
        (*P_NAND_CMD) = CE0 | CLE | 0;	//switch to read mode.
        (*P_NAND_CMD) = CE0 | IDLE | 2;
    }else{ // with RB
        (*P_NAND_CMD) = CE0 | IDLE | 40;
        (*P_NAND_CMD) = CE0 | RB | 13;
    }
	/* new way to set address. */
	(*P_NAND_CMD) = ADL | (mem & 0xFFFF);		//data address.
	(*P_NAND_CMD) = ADH | ((mem >> 16) & 0xFFFF);
	(*P_NAND_CMD) = AIL | (info_adr & 0xFFFF);	//set info address.
	(*P_NAND_CMD) = AIH | ((info_adr >> 16) & 0xFFFF);


	/* set seed, start dma*/
    (*P_NAND_CMD) = SEED | (0xc2 + (src&0x7fff));
	//printf("cmd 0x%x\n", glb_setup.cfg.b.cmd);
	//printf("P_NAND_CFG 0x%x\n", (*P_NAND_CFG));
    (*P_NAND_CMD) = glb_setup.cfg.b.cmd;

    (*P_NAND_CMD) = (CE0 | IDLE);
    (*P_NAND_CMD) = (CE0 | IDLE);
	NFIO_LINE
	/* wait I/F ready*/
	while (((*P_NAND_CMD)>>22&0x1f) > 0);
	NFIO_LINE
	/* wait info dma ready */
	do {
		inv_dcache_range((uint64_t)p_info_buf, (uint64_t)(ecc_pages * sizeof(uint64_t)));
		dma_done = p_info_buf[ecc_pages-1];
	} while (dma_done == 0);
	NFIO_LINE
    // random only, old oob!
    // blank page: ecc uncorr, zero_cnt<10.
    // ecc error: ecc uncorr, zero_cnt>10.
    // no magic: ecc OK, no magic word.
    // return the first error.
    for (k=0; k<ecc_pages; k++) {
		//printf("ecc page %d\n", k);
        mem_addr = info_adr;
        info = *(volatile uint32_t *)mem_addr;
        if ((info>>24 & 0x3f) == 0x3f) { // uncorrectable
            if ( glb_setup.cfg.b.a2 ) nfio_reset();

            // check blank page
            if ((info>>16&0x3f) < 0xa) {
				PRINT("blank @ page 0x%08x\n", src);
                return ERROR_NAND_BLANK_PAGE;
            }
            else {
				PRINT("ecc fail @ page 0x%08x\n", src);
                return ERROR_NAND_ECC;
            }
        }

        if (k == 0 && (info & 0xc000ffff) != 0xc000aa55) { //magic word error
			PRINT("magic fail @ page 0x%08x\n", src);
            return ERROR_NAND_MAGIC_WORD;
		}
        info_adr += 8;
    }
	NFIO_LINE
    return 0;
}

static uint32_t page_2_addr(uint32_t page)
{
	uint32_t addr = page;
	uint32_t new_type = glb_ext_info.new_type;
	uint32_t page_per_blk = glb_ext_info.page_per_blk;

	if (new_type) {
		uint32_t blk_addr;
		//fixme , confirm the value of page_per_blk
		blk_addr = (page / page_per_blk) * page_per_blk;
		/* hynix */
		if (new_type < 10) {
			if (new_type == 6)
				addr = page_list_hynix_1y[page % page_per_blk] + blk_addr;
			else
				addr = page_list_hynix_2x[page % page_per_blk] + blk_addr;
		} else if (new_type == 40) {
			addr = (page % page_per_blk) * 2 + blk_addr;
		}
	}
	return addr;
}

// read multiple nand pages. fixme, may cause overflow...
uint32_t nfio_read(uint32_t src, uint32_t mem, uint32_t size)
{
    uint32_t ret;
    uint32_t ecc_mode, short_mode, short_size, ecc_pages, page_size;
	uint32_t page_base, page_addr, retry_cnt, read_size;

    // ecc page size, unit: 8 bytes
    ecc_mode   = glb_setup.cfg.b.cmd>>14&7;
    short_mode = glb_setup.cfg.b.cmd>>13&1;
    short_size = glb_setup.cfg.b.cmd>>6&0x7f;
    ecc_pages      = glb_setup.cfg.b.cmd&0x3f;

    page_size = (short_mode ? short_size : ecc_mode < 2 ? 64 : 128) * 8 * ecc_pages;
    NFIO_LINE
	flush_dcache_range((uint64_t)mem, (uint64_t)(size));
    // read one nand page per loop.
    for (read_size=0; read_size<size; read_size+=page_size) {
		page_addr = page_2_addr(src++);
		//printf("page_addr 0x%x\n", page_addr);
        retry_cnt = 0;

        do {
            for (page_base=0; page_base<0x400; page_base+=0x100) {
                NFIO_LINE
                ret = nfio_page_read(page_base + page_addr,
                                     mem + read_size);
                if (ret != ERROR_NAND_ECC) { // good, blank, no magic
                    break;
                }
            }

            // read retry
            if (ret == ERROR_NAND_ECC) {
                if (retry_cnt < glb_setup.max) {
                    retry_cnt++;
                    nfio_read_retry(1);
                }
                else
                    break;
            }
        } while (ret == ERROR_NAND_ECC);

        if (ret) return ret;
    }

    return 0;
}

uint32_t nfio_init()
{
    uint32_t ret;
	nand_page0_t *page0	= (nand_page0_t *)NAND_PAGE0_BUF;
	nand_setup_t *nand_setup;
	ext_info_t * p_ext_info;

	nand_setup = &page0->nand_setup;
	p_ext_info = &page0->ext_info;
	//fixme, do not read back efuse 1st.
    //efuse_features_t *efuse;

    //efuse = efuse_features_get();

    // from default
    glb_setup.cfg.d32 = DEFAULT_ECC_MODE;
    glb_setup.cfg.b.active = 1;

    // from efuse
	glb_setup.cfg.b.no_rb = 1;	//defaut
    //glb_setup.cfg.b.sync_mode = efuse->tg_nd_bm_e ? 2 : 0;
	glb_setup.cfg.b.sync_mode = 0; //fixme,
    glb_setup.cfg.b.size = 0;
	NFIO_LINE
	// get pin
	nfio_pin_mux();

    // set clk to 24MHz
	(*P_CLK_CNTL) = ( 1<< 31 | 1<<28 | 1 << 21 | 2 << 8 | 1);
	/*
    clk.d32 = 0;
    clk.b.div = 1;
    clk.b.src = 0; // 24MHz
    clk.b.core_phase = 2;
    clk.b.nand = 1;
    clk.b.always_on = 1;
    sd_emmc_port->gclock = clk.d32;
	*/

    // nand cfg register:
    // sync[11:10] : 0:aync, 1:micron(started from sync, don't need to set),
    // 2: samsung/toshiba toggle, need to set when read.
    // Nand cycle = 200ns, timing at 3rd clock.
    (*P_NAND_CFG) =
        4 | (3<<5) // Please see main.c for detailed timing info
        |(glb_setup.cfg.b.sync_mode<<10) // async mode
        |(0<<12) // disable cmd_start
        |(0<<13) // disable cmd_auto
        |(0<<14) // disable apb_mode
        |(1<<31);// disable NAND bus gated clock.

    // reset
    ret = nfio_reset();
    if (ret) return ret;
    NFIO_LINE
    //read ID
	glb_setup.id = _read_id();
	printf("MID, %x\n", glb_setup.id);
    // set retry parameter.
	_set_retry(glb_setup.id);
    NFIO_LINE

	//_dump_mem_u8((uint8_t *)page0, 384);
	/* fixme, use the memory filled by romboot nfdrv.*/
#if 1
    ret = nfio_read(0, NAND_PAGE0_BUF, 384);
    if (ret == ERROR_NAND_ECC) {
        if (glb_setup.id == NAND_MFR_SANDISK) {
            glb_setup.cfg.b.a2 = 1;
            glb_setup.max = 0;
            ret = nfio_read(0, NAND_PAGE0_BUF, 384);
        }
        else if (glb_setup.cfg.b.sync_mode == 0 && (glb_setup.id == NAND_MFR_TOSHIBA ||
                                                  glb_setup.id == NAND_MFR_SAMSUNG)) {
            glb_setup.cfg.b.sync_mode = 2;
            (*P_NAND_CFG) |= (glb_setup.cfg.b.sync_mode<<10);
            *P_PAD_PULL_UP_REG2 &= ~(1<<15);
            ret = nfio_read(0, NAND_PAGE0_BUF, 384);
        }
    }
	/*fixme, */
 #if 0
    if ( efuse->disk_encry_e )
        boot_des_decrypt ((uint8_t *)NAND_PAGE0_BUF, (uint8_t *)NAND_PAGE0_BUF, 384);
 #endif //0
#endif
    // override
    glb_setup.cfg.d32 = nand_setup->cfg.d32; //get cfg!
    glb_setup.id      = nand_setup->id;
    glb_setup.max     = nand_setup->max;
    glb_setup.cfg.b.size = 0; // efuse size

	glb_ext_info.new_type = p_ext_info->new_type;
	glb_ext_info.page_per_blk = p_ext_info->page_per_blk;

	printf("cfg %x, new %x, pages %x\n", glb_setup.cfg.d32, glb_ext_info.new_type, glb_ext_info.page_per_blk);
	//override dbg ...
	// glb_setup.cfg.d32 = 0xeb8008;
	// glb_ext_info.new_type = 0x32;
	// glb_ext_info.page_per_blk = 0x100;
	NFIO_LINE

	return ret;
}

/*
  *interface for spl.
  *
  * src, offset bytes in storage
  * dst, ram address
  * size, reada bytes count.
  **/
uint32_t nf_read(uint32_t boot_device, uint32_t src, uint32_t des, uint32_t size)
{
	uint32_t _page_size, _page, _cnt;
	uint32_t ecc_mode, ecc_pages;
	uint32_t ret = 0;
	//uint64_t des64;

	ecc_mode   = glb_setup.cfg.b.cmd>>14&7;
    ecc_pages      = glb_setup.cfg.b.cmd&0x3f;
    _page_size = (ecc_mode < 2 ? 64 : 128) * 8 * ecc_pages;
	//printf("ecc_mode %d, ecc_pages %d, pagesize %d\n", ecc_mode, ecc_pages, _page_size);
	if (src % SRC_ALIGN_SIZE) {
		PRINT("%s(), unaligned src 0x%08x\n", __func__, src);
		ret = ERROR_NAND_UNALIGN_SRC;
		goto _out;
	}
	NFIO_LINE
	_page = src / _page_size;
	_cnt = size;
	//_cnt = size / _page_size;
	//_cnt = (size % _page_size == 0) ? _cnt : (_cnt+1);
	printf("_page_size %x, _cnt %x\n", _page_size, _cnt);
	ret = nfio_read(_page + 1, des, _cnt);	/*skip page0 */
	// des64 = (uint64_t) des;
	// _dump_mem_u8((uint8_t *)des64, size);
_out:
	return ret;
}





