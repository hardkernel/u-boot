#include <common.h>
#include <linux/stddef.h>
#include <amlogic/hdmi.h>

#define CEA_DATA_BLOCK_COLLECTION_ADDR_1StP 0x04
#define VIDEO_TAG 0x40
#define AUDIO_TAG 0x20
#define VENDOR_TAG 0x60
#define SPEAKER_TAG 0x80

#define HDMI_EDID_BLOCK_TYPE_RESERVED	        0
#define HDMI_EDID_BLOCK_TYPE_AUDIO		1
#define HDMI_EDID_BLOCK_TYPE_VIDEO		2
#define HDMI_EDID_BLOCK_TYPE_VENDER	        3
#define HDMI_EDID_BLOCK_TYPE_SPEAKER	        4
#define HDMI_EDID_BLOCK_TYPE_VESA		5
#define HDMI_EDID_BLOCK_TYPE_RESERVED2	        6
#define HDMI_EDID_BLOCK_TYPE_EXTENDED_TAG       7

#define EXTENSION_VENDOR_SPECIFIC 0x1
#define EXTENSION_COLORMETRY_TAG 0x5
/* DRM stands for "Dynamic Range and Mastering " */
#define EXTENSION_DRM_TAG	0x6
/* Video Format Preference Data block */
#define EXTENSION_VFPDB_TAG	0xd
#define EXTENSION_Y420_VDB_TAG	0xe
#define EXTENSION_Y420_CMDB_TAG	0xf

#define EDID_DETAILED_TIMING_DES_BLOCK0_POS 0x36
#define EDID_DETAILED_TIMING_DES_BLOCK1_POS 0x48
#define EDID_DETAILED_TIMING_DES_BLOCK2_POS 0x5A
#define EDID_DETAILED_TIMING_DES_BLOCK3_POS 0x6C

/* EDID Descrptor Tag */
#define TAG_PRODUCT_SERIAL_NUMBER 0xFF
#define TAG_ALPHA_DATA_STRING 0xFE
#define TAG_RANGE_LIMITS 0xFD
#define TAG_DISPLAY_PRODUCT_NAME_STRING 0xFC /* MONITOR NAME */
#define TAG_COLOR_POINT_DATA 0xFB
#define TAG_STANDARD_TIMINGS 0xFA
#define TAG_DISPLAY_COLOR_MANAGEMENT 0xF9
#define TAG_CVT_TIMING_CODES 0xF8
#define TAG_ESTABLISHED_TIMING_III 0xF7
#define TAG_DUMMY_DES 0x10

/* retrun 1 valid edid */
static int check_dvi_hdmi_edid_valid(unsigned char *buf)
{
	unsigned int chksum = 0;
	unsigned int i = 0;

	/* check block 0 first 8 bytes */
	if ((buf[0] != 0) && (buf[7] != 0))
		return 0;
	for (i = 1; i < 7; i++) {
		if (buf[i] != 0xff)
			return 0;
	}

	/* check block 0 checksum */
	for (chksum = 0, i = 0; i < 0x80; i++)
		chksum += buf[i];
	if ((chksum & 0xff) != 0)
		return 0;

	if (buf[0x7e] == 0)/* check Extension flag at block 0 */
		return 1;
	/* check block 1 extension tag */
	else if (!((buf[0x80] == 0x2) || (buf[0x80] == 0xf0)))
		return 0;

	/* check block 1 checksum */
	for (chksum = 0, i = 0x80; i < 0x100; i++)
		chksum += buf[i];
	if ((chksum & 0xff) != 0)
		return 0;

	/* check block 2 checksum */
	if (buf[0x7e] > 1) {
		for (chksum = 0, i = 0x100; i < 0x180; i++)
			chksum += buf[i];
		if ((chksum & 0xff) != 0)
			return 0;
	}

	/* check block 3 checksum */
	if (buf[0x7e] > 2) {
		for (chksum = 0, i = 0x180; i < 0x200; i++)
			chksum += buf[i];
		if ((chksum & 0xff) != 0)
			return 0;
	}

	return 1;
}

static void dump_dtd_info(struct dtd *t)
{
	return; /* debug only */
	printk("%s[%d]\n", __func__, __LINE__);
#define PR(a) pr_info("%s %d\n", #a, t->a)
	PR(pixel_clock);
	PR(h_active);
	PR(h_blank);
	PR(v_active);
	PR(v_blank);
	PR(h_sync_offset);
	PR(h_sync);
	PR(v_sync_offset);
	PR(v_sync);
}

static void Edid_DTD_parsing(struct rx_cap *pRXCap, unsigned char *data)
{
	struct hdmi_format_para *para = NULL;
	struct dtd *t = &pRXCap->dtd[pRXCap->dtd_idx];

	memset(t, 0, sizeof(struct dtd));
	t->pixel_clock = data[0] + (data[1] << 8);
	t->h_active = (((data[4] >> 4) & 0xf) << 8) + data[2];
	t->h_blank = ((data[4] & 0xf) << 8) + data[3];
	t->v_active = (((data[7] >> 4) & 0xf) << 8) + data[5];
	t->v_blank = ((data[7] & 0xf) << 8) + data[6];
	t->h_sync_offset = (((data[11] >> 6) & 0x3) << 8) + data[8];
	t->h_sync = (((data[11] >> 4) & 0x3) << 8) + data[9];
	t->v_sync_offset = (((data[11] >> 2) & 0x3) << 4) +
		((data[10] >> 4) & 0xf);
	t->v_sync = (((data[11] >> 0) & 0x3) << 4) + ((data[10] >> 0) & 0xf);
/*
 * Special handling of 1080i60hz, 1080i50hz
 */
	if ((t->pixel_clock == 7425) && (t->h_active == 1920) &&
		(t->v_active == 1080)) {
		t->v_active = t->v_active / 2;
		t->v_blank = t->v_blank / 2;
	}
/*
 * Special handling of 480i60hz, 576i50hz
 */
	if (((((t->flags) >> 1) & 0x3) == 0) && (t->h_active == 1440)) {
		if (t->pixel_clock == 2700) /* 576i50hz */
			goto next;
		if ((t->pixel_clock - 2700) < 10) /* 480i60hz */
			t->pixel_clock = 2702;
next:
		t->v_active = t->v_active / 2;
		t->v_blank = t->v_blank / 2;
	}
/*
 * call hdmi_match_dtd_paras() to check t is matched with VIC
 */
	para = hdmi_match_dtd_paras(t);
	if (para) {
		t->vic = para->vic;
		pRXCap->preferred_mode = pRXCap->dtd[0].vic; /* Select dtd0 */
		if (0) /* debug only */
			pr_info("hdmitx: get dtd%d vic: %d\n",
				pRXCap->dtd_idx, para->vic);
		pRXCap->dtd_idx++;
	} else
		dump_dtd_info(t);
}

/* parse Sink 4k2k information */
static void hdmitx_edid_4k2k_parse(struct rx_cap *pRXCap, unsigned char *dat,
	unsigned size)
{
	if ((size > 4) || (size == 0)) {
		return;
	}
	while (size--) {
		if (*dat == 1)
			pRXCap->VIC[pRXCap->VIC_count] = HDMI_3840x2160p30_16x9;
		else if (*dat == 2)
			pRXCap->VIC[pRXCap->VIC_count] = HDMI_3840x2160p25_16x9;
		else if (*dat == 3)
			pRXCap->VIC[pRXCap->VIC_count] = HDMI_3840x2160p24_16x9;
		else if (*dat == 4)
			pRXCap->VIC[pRXCap->VIC_count] = HDMI_4096x2160p24_256x135;
		else
			;
		dat++;
		pRXCap->VIC_count++;
	}
}

static void set_vsdb_dc_420_cap(struct rx_cap *pRXCap,
	unsigned char *edid_offset)
{
	pRXCap->dc_30bit_420 = !!(edid_offset[6] & (1 << 0));
	pRXCap->dc_36bit_420 = !!(edid_offset[6] & (1 << 1));
	pRXCap->dc_48bit_420 = !!(edid_offset[6] & (1 << 2));
}

static int Edid_ParsingY420VDBBlock(struct rx_cap *pRXCap,
	unsigned char *buf)
{
	unsigned char tag = 0, ext_tag = 0, data_end = 0;
	unsigned int pos = 0;
	int i = 0, found = 0;

	tag = (buf[pos] >> 5) & 0x7;
	data_end = (buf[pos] & 0x1f)+1;
	pos++;
	ext_tag = buf[pos];

	if ((tag != 0x7) || (ext_tag != 0xe))
		goto INVALID_Y420VDB;

	pos++;
	while (pos < data_end) {
		if (pRXCap->VIC_count < VIC_MAX_NUM) {
			for (i = 0; i < pRXCap->VIC_count; i++) {
				if (pRXCap->VIC[i] == buf[pos]) {
					pRXCap->VIC[i] =
					HDMITX_VIC420_OFFSET + buf[pos];
					found = 1;
					/* Here we do not break,because
						some EDID may have the same
						repeated VICs
					*/
				}
			}
			if (0 == found) {
				pRXCap->VIC[pRXCap->VIC_count] =
				HDMITX_VIC420_OFFSET + buf[pos];
				pRXCap->VIC_count++;
			}
		}
		pos++;
	}

	return 0;

INVALID_Y420VDB:
	pr_info("[%s] it's not a valid y420vdb!\n", __func__);
	return -1;
}

static int Edid_ParsingY420CMDBBlock(struct rx_cap *pRXCap,
	unsigned char *buf)
{
	/* TODO */
	return 0;
}

static int Edid_Y420CMDB_PostProcess(struct rx_cap *pRXCap)
{
	/* TODO */
	return 0;
}

static int Edid_ParsingVFPDB(struct rx_cap *pRXCap, unsigned char *buf)
{
	unsigned int len = buf[0] & 0x1f;
	enum hdmi_vic svr = HDMI_unkown;

	if (buf[1] != EXTENSION_VFPDB_TAG)
		return 0;
	if (len < 2)
		return 0;

	svr = buf[2];
	if (((svr >= 1) && (svr <= 127)) ||
		((svr >= 193) && (svr <= 253))) {
		pRXCap->flag_vfpdb = 1;
		pRXCap->preferred_mode = svr;
		pr_info("preferred mode 0 srv %d\n", pRXCap->preferred_mode);
		return 1;
	}
	if ((svr >= 129) && (svr <= 144)) {
		pRXCap->flag_vfpdb = 1;
		pRXCap->preferred_mode = pRXCap->dtd[svr - 129].vic;
		pr_info("preferred mode 0 dtd %d\n", pRXCap->preferred_mode);
		return 1;
	}
	return 0;
}

static int hdmitx_edid_block_parse(struct rx_cap *pRXCap,
	unsigned char *BlockBuf)
{
	unsigned char offset, End;
	unsigned char count;
	unsigned char tag;
	int i, tmp, idx;
	unsigned char *vfpdb_offset = NULL;

	if (BlockBuf[0] != 0x02)
		return -1; /* not a CEA BLOCK. */
	End = BlockBuf[2]; /* CEA description. */
	pRXCap->native_Mode = BlockBuf[3];
	pRXCap->number_of_dtd += BlockBuf[3] & 0xf;
	/* bit 5 (YCBCR 4:4:4) = 1 if sink device supports YCBCR 4:4:4
	 * in addition to RGB;
	 * bit 4 (YCBCR 4:2:2) = 1 if sink device supports YCBCR 4:2:2
	 * in addition to RGB
	 */
	pRXCap->pref_colorspace = BlockBuf[3] & 0x30;

	pRXCap->native_VIC = 0xff;

	for (offset = 4 ; offset < End ; ) {
		tag = BlockBuf[offset] >> 5;
		count = BlockBuf[offset] & 0x1f;
		switch (tag) {
		case HDMI_EDID_BLOCK_TYPE_AUDIO:
			offset++;
			offset += count;
			break;

		case HDMI_EDID_BLOCK_TYPE_VIDEO:
			offset++;
			for (i = 0 ; i < count ; i++) {
				unsigned char VIC;
				VIC = BlockBuf[offset + i] & (~0x80);
				pRXCap->VIC[pRXCap->VIC_count] = VIC;
				if (BlockBuf[offset + i] & 0x80)
					pRXCap->native_VIC = VIC;
				pRXCap->VIC_count++;
			}
			offset += count;
			break;

		case HDMI_EDID_BLOCK_TYPE_VENDER:
			offset++;
			if ((BlockBuf[offset] == 0x03) &&
				(BlockBuf[offset+1] == 0x0c) &&
				(BlockBuf[offset+2] == 0x00))
				pRXCap->IEEEOUI = 0x000c03;
			else
				goto case_hf;
			pRXCap->ColorDeepSupport =
				(unsigned long)BlockBuf[offset+5];
			pRXCap->Max_TMDS_Clock1 =
				(unsigned long)BlockBuf[offset+6];
			if (count > 7) {
				tmp = BlockBuf[offset+7];
				idx = offset + 8;
				if (tmp & (1<<6))
					idx += 2;
				if (tmp & (1<<7))
					idx += 2;
				if (tmp & (1<<5)) {
					idx += 1;
					/* valid 4k */
					if (BlockBuf[idx] & 0xe0) {
						hdmitx_edid_4k2k_parse(
							pRXCap,
							&BlockBuf[idx + 1],
							BlockBuf[idx] >> 5);
					}
				}
			}
			goto case_next;
case_hf:
			if ((BlockBuf[offset] == 0xd8) &&
				(BlockBuf[offset+1] == 0x5d) &&
				(BlockBuf[offset+2] == 0xc4))
				pRXCap->HF_IEEEOUI = 0xd85dc4;
			pRXCap->Max_TMDS_Clock2 = BlockBuf[offset+4];
			pRXCap->scdc_present =
				!!(BlockBuf[offset+5] & (1 << 7));
			pRXCap->scdc_rr_capable =
				!!(BlockBuf[offset+5] & (1 << 6));
			pRXCap->lte_340mcsc_scramble =
				!!(BlockBuf[offset+5] & (1 << 3));
			set_vsdb_dc_420_cap(pRXCap,
				&BlockBuf[offset]);
case_next:
			offset += count; /* ignore the remaind. */
			break;

		case HDMI_EDID_BLOCK_TYPE_SPEAKER:
			offset++;
			offset += count;
			break;

		case HDMI_EDID_BLOCK_TYPE_VESA:
			offset++;
			offset += count;
			break;

		case HDMI_EDID_BLOCK_TYPE_EXTENDED_TAG:
			{
				unsigned char ext_tag = 0;

				ext_tag = BlockBuf[offset+1];
				switch (ext_tag) {
				case EXTENSION_VENDOR_SPECIFIC:
					break;
				case EXTENSION_COLORMETRY_TAG:
					pRXCap->colorimetry_data =
						BlockBuf[offset + 2];
					break;
				case EXTENSION_DRM_TAG:
					break;
				case EXTENSION_VFPDB_TAG:
/* Just record VFPDB offset address, call Edid_ParsingVFPDB() after DTD
 * parsing, in case that
 * SVR >=129 and SVR <=144, Interpret as the Kth DTD in the EDID,
 * where K = SVR – 128 (for K=1 to 16)
 */
					vfpdb_offset = &BlockBuf[offset];
					break;
				case EXTENSION_Y420_VDB_TAG:
					Edid_ParsingY420VDBBlock(pRXCap,
						&BlockBuf[offset]);
					break;
				case EXTENSION_Y420_CMDB_TAG:
					Edid_ParsingY420CMDBBlock(pRXCap,
						&BlockBuf[offset]);
					break;
				default:
					break;
				}
			}
			offset += count+1;
			break;

		case HDMI_EDID_BLOCK_TYPE_RESERVED:
			offset++;
			offset += count;
			break;

		case HDMI_EDID_BLOCK_TYPE_RESERVED2:
			offset++;
			offset += count;
			break;

		default:
			break;
		}
	}

	Edid_Y420CMDB_PostProcess(pRXCap);
	idx = BlockBuf[3] & 0xf;
	for (i = 0; i < idx; i++)
		Edid_DTD_parsing(pRXCap, &BlockBuf[BlockBuf[2] + i * 18]);
	if (vfpdb_offset)
		Edid_ParsingVFPDB(pRXCap, vfpdb_offset);

	return 0;
}

/*
 * Parsing RAW EDID data from edid to pRXCap
 */
unsigned int hdmi_edid_parsing(unsigned char *EDID_buf, struct rx_cap *pRXCap)
{
	int i;
	int BlockCount = EDID_buf[126] + 1;
	int idx[4];

	/* Clear all parsing data */
	memset(pRXCap, 0, sizeof(struct rx_cap));
	pRXCap->IEEEOUI = 0x000c03; /* Default is HDMI device */

	/* If edid data corrupted, no parse */
	if (check_dvi_hdmi_edid_valid(EDID_buf) == 0)
		return 0;

	idx[0] = EDID_DETAILED_TIMING_DES_BLOCK0_POS;
	idx[1] = EDID_DETAILED_TIMING_DES_BLOCK1_POS;
	idx[2] = EDID_DETAILED_TIMING_DES_BLOCK2_POS;
	idx[3] = EDID_DETAILED_TIMING_DES_BLOCK3_POS;
	for (i = 0; i < 4; i++) {
		if ((EDID_buf[idx[i]]) && (EDID_buf[idx[i] + 1]))
			Edid_DTD_parsing(pRXCap, &EDID_buf[idx[i]]);
	}

	if (BlockCount == 1)
		pRXCap->IEEEOUI = 0;

	for (i = 1 ; i <= BlockCount ; i++) {
		if (EDID_buf[i*128+0] == 0x2)
			hdmitx_edid_block_parse(pRXCap, &(EDID_buf[i*128]));
	}

/*
 * Because DTDs are not able to represent some Video Formats, which can be
 * represented as SVDs and might be preferred by Sinks, the first DTD in the
 * base EDID data structure and the first SVD in the first CEA Extension can
 * differ. When the first DTD and SVD do not match and the total number of
 * DTDs defining Native Video Formats in the whole EDID is zero, the first
 * SVD shall take precedence.
 */
	if (!pRXCap->flag_vfpdb && (pRXCap->preferred_mode != pRXCap->VIC[0]) &&
		(pRXCap->number_of_dtd == 0)) {
		pr_info("hdmitx: edid: change preferred_mode from %d to %d\n",
			pRXCap->preferred_mode,	pRXCap->VIC[0]);
		pRXCap->preferred_mode = pRXCap->VIC[0];
	}

	return 1;
}
