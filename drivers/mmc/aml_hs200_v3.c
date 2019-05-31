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
#include <asm/arch/sd_emmc.h>
#include <asm/arch/secure_apb.h>
#include <emmc_partitions.h>
#include <asm/cpu_id.h>

#ifdef EMMC_DEBUG_ENABLE
	#define emmc_debug(a...) printf(a);
#else
	#define emmc_debug(a...)
#endif
#ifdef MMC_HS200_MODE
u64 align[10];

void print_all_reg(struct mmc *mmc) {
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	printf("sd_emmc_regs->gcfg is %x\n", sd_emmc_regs->gcfg);
	printf("sd_emmc_regs->gclock is %x\n", sd_emmc_regs->gclock);
	printf("sd_emmc_regs->gadjust is %x\n", sd_emmc_regs->gadjust);
	printf("sd_emmc_regs->gdelay is %x\n", sd_emmc_regs->gdelay);
	printf("sd_emmc_regs->gintf3 is %x\n", sd_emmc_regs->gintf3);
	return;
}

void reset_all_reg(struct mmc *mmc) {
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	void* buf;
	unsigned long  addr;
	int size;
	u64 writeval;
	unsigned long byte;

	sd_emmc_regs->gcfg = 0x4791;
	sd_emmc_regs->gclock = 0x1000204;
	sd_emmc_regs->gadjust = 0;
	sd_emmc_regs->gdelay = 0;
	sd_emmc_regs->gdelay1 = 0;
	sd_emmc_regs->gintf3 = 0;

	size = 4;
	byte = size;
	addr = 0xff63c25c;                       //add macro on board
	writeval = 0x080;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);
	return;
}

static int fbinary(u64 x)
{
	int i;
	for (i = 0; i < 64; i++) {
		if ((x >> i) & 0x1)
			return i;
	}
	return -1;
}


int aml_emmc_hs200_tl1(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 vclkc = sd_emmc_regs->gclock;
//	struct sd_emmc_clock *clkc = (struct sd_emmc_clock *)&vclkc;

	u32 clk_bak = 0;
	u32 delay2 = 0, count = 0;
	int i, err = 0;

	clk_bak = vclkc;
	clk_bak = 0x10000204;

	sd_emmc_regs->gclock = 0x10100004;

	printf("[%s][%d] clk config:0x%x\n",
		__func__, __LINE__, sd_emmc_regs->gclock);
	for (i = 0; i < 63; i++) {
		delay2 += (1 << 24);
		sd_emmc_regs->gdelay1 = delay2;
		err = emmc_eyetest_log(mmc, 9);
		if (err)
			continue;
		count = fbinary(align[9]);
		if (((count >= 10) && (count <= 22))
			|| ((count >= 43) && (count <= 56)))
			break;
	}
	if (i == 63)
		printf("[%s]no find cmd timing\n", __func__);
	aml_priv->cmd_c = (delay2 >> 24);
	sd_emmc_regs->gdelay1 = 0;
	sd_emmc_regs->gclock = clk_bak;
	printf("[%s][%d] clk config:0x%x\n",
		__func__, __LINE__, sd_emmc_regs->gclock);
	return 0;

}

void tl1_set_clock_src(void ) {
	void* buf;
	unsigned long  addr;
	int size;
	u64 writeval;
	unsigned long byte;

	size = 4;
	byte = size;
	addr = CLKSRC_BASE + 0x25c;
	writeval = 0xe80;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	size = 4;
	byte = size;
	addr = CLKSRC_BASE + 0x40;
	writeval = 0xd0020484;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x44;
	writeval = 0x0;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x48;
	writeval = 0x0;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x4c;
	writeval = 0x48681c00;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x50;
	writeval = 0x33771290;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x54;
	writeval = 0x39272000;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	addr = CLKSRC_BASE + 0x58;
	writeval = 0x56540000;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

}

void hs200_set_reg(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 clock = sd_emmc_regs->gclock;
	struct sd_emmc_clock *gclock = (struct sd_emmc_clock *) &clock;
	cpu_id_t cpu_id = get_cpu_id();
	u32 clock_bak  = sd_emmc_regs->gclock;

	void* buf;
	unsigned long  addr;
	int size;
	u64 writeval;
	unsigned long byte;


	sd_emmc_regs->gintf3 = 0x400000;
	gclock->core_phase = MMC_HS2_COPHASE;

	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1) {
		tl1_set_clock_src();
		sd_emmc_regs->gclock = 0x10100004;
		aml_emmc_hs200_tl1(mmc);
		size = 4;
		byte = size;
		addr = CLKSRC_BASE + 0x25c;
		writeval = 0x80;
		buf = map_sysmem(addr, byte);
		*((u32 *)buf) = (u32)writeval;
		unmap_sysmem(buf);

		sd_emmc_regs->gclock = clock_bak;
	}
	return ;
}

int mmc_set_hs200_mode(struct mmc *mmc)
{
	int err;

	print_all_reg(mmc);
	mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
			EXT_CSD_BUS_WIDTH, 2);

	mmc_set_bus_width(mmc, MMC_MODE_8BIT);

	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
			EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS200);
	if (err) {
		printf("mmc switch HS200 failed\n");
		return err;
	}
	mmc->tran_speed = 198000000;

	mmc_set_clock(mmc, mmc->tran_speed);

#ifdef MMC_HS400_MODE
	hs200_set_reg(mmc);
#else
	/*TODO add _aml_sd_ermmc_execute_tuning*/
	if (0)
		return err;
#endif

	return err;
}


static int emmc_send_deselect(struct mmc *mmc)
{
	struct mmc_cmd cmd = {0};
	u32 err = 0;

	cmd.cmdidx = MMC_CMD_SELECT_CARD;
	cmd.cmdarg = 0;
	cmd.resp_type = MMC_RSP_NONE;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err) {
		printf("[%s][%d] cmd:0x%x send error\n",
				__func__, __LINE__, cmd.cmdidx);
		return err;
	}
	return err;
}

static int emmc_send_select(struct mmc *mmc)
{
	struct mmc_cmd cmd = {0};
	u32 err = 0;

	cmd.cmdidx = MMC_CMD_SELECT_CARD;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = 1 << 16;
	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err) {
		printf("[%s][%d] cmd:0x%x send error\n",
				__func__, __LINE__, cmd.cmdidx);
		return err;
	}
	return err;
}

static int emmc_send_cid(struct mmc *mmc)
{
	struct mmc_cmd cmd = {0};
	u32 err = 0;

	cmd.cmdidx = MMC_CMD_SEND_CID;
	cmd.cmdarg = (1 << 16);
	cmd.resp_type = MMC_RSP_R2;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err) {
		printf("[%s][%d] cmd:0x%x send error\n",
				__func__, __LINE__, cmd.cmdidx);
		return err;
	}
	return err;
}

static int aml_sd_emmc_cmd_v3(struct mmc *mmc)
{
	int i;
	mmc_send_status(mmc, 1000);
	emmc_send_deselect(mmc);
	for (i = 0; i < 2; i++)
		emmc_send_cid(mmc);
	emmc_send_select(mmc);
	return 0;
}

static int emmc_detect_base_line(u64 *arr)
{
	u32 i = 0, first[10] = {0};
	u32  max = 0, l_max = 0xff;
	for (i = 0; i < 8; i++) {
		first[i] = fbinary(arr[i]);
		if (first[i] > max) {
			l_max = i;
			max = first[i];
		}
	}
	printf("%s [%d] detect line:%d, max: %u\n",
			__func__, __LINE__, l_max, max);
	return max;
}

/**************** start all data align ********************/
static int emmc_all_data_line_alignment(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 delay1 = 0, delay2 = 0;
	int result;
	int temp = 0, base_line = 0, line_x = 0;

	base_line = emmc_detect_base_line(align);
	for (line_x = 0; line_x < 9; line_x++) {
		if (line_x == 8)
			continue;
		if (align[line_x] & 0xf)
			continue;
		temp = fbinary(align[line_x]);
		result = base_line - temp;
		emmc_debug("*****line_x: %d, result: %d\n",
				line_x, result);
	    if (line_x < 5)
			delay1 |= result << (6 * line_x);
	    else
			delay2 |= result << (6 * (line_x - 5));
	}
	sd_emmc_regs->gdelay += delay1;
	sd_emmc_regs->gdelay1 += delay2;
	emmc_debug("gdelay: 0x%x, gdelay1: 0x%x\n",
			sd_emmc_regs->gdelay, sd_emmc_regs->gdelay1);
	return 0;
}

int emmc_eyetest_log(struct mmc *mmc, u32 line_x)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	u32 adjust = sd_emmc_regs->gadjust;
	struct sd_emmc_adjust_v3 *gadjust =
		(struct sd_emmc_adjust_v3 *)&adjust;
	u32 eyetest_log = 0;
	struct eyetest_log *geyetest_log = (struct eyetest_log *)&(eyetest_log);
	u32 eyetest_out0 = 0, eyetest_out1 = 0;
	u32 intf3 = sd_emmc_regs->gintf3;
	struct intf3 *gintf3 = (struct intf3 *)&(intf3);
	/*u32 vcfg = sd_emmc_regs->gcfg;*/
	int retry = 3;
	u64 tmp = 0;
	unsigned long phy_addr = 0x1080000;
	void *addr =  (void*)phy_addr;
	int i;
	lbaint_t start = ((SZ_1M*(26+3))/ 512);

	/****** calculate  line_x ***************************/
	/******* init eyetest register ************************/
	/*emmc_dbg(AMLSD_DBG_V3, "delay1: 0x%x , delay2: 0x%x, line_x: %d\n",
	    sd_emmc_regs->gdelay, sd_emmc_regs->gdelay1, line_x);*/
	gadjust->cali_enable = 1;
	gadjust->cali_sel = line_x;
	sd_emmc_regs->gadjust = adjust;
	if (line_x < 9)
		gintf3->eyetest_exp = 7;
	else
		gintf3->eyetest_exp = 3;
RETRY:

	gintf3->eyetest_on = 1;
	sd_emmc_regs->gintf3 = intf3;
	/*emmc_dbg(AMLSD_DBG_V3, "intf3: 0x%x\n", sd_emmc_regs->intf3);*/

	/*****test start*************/
	udelay(5);
	if (line_x < 9)
		for (i = 0; i< 2; i++)
			mmc_bread(1, start, 256, addr);
	else
		aml_sd_emmc_cmd_v3(mmc);
	udelay(1);
	eyetest_log = sd_emmc_regs->geyetest_log;

	if (!(geyetest_log->eyetest_done & 0x1)) {
		printf("testint eyetest times: 0x%x, out: 0x%x, 0x%x\n",
				geyetest_log->eyetest_times,
				eyetest_out0, eyetest_out1);
		gintf3->eyetest_on = 0;
		sd_emmc_regs->gintf3 = intf3;
		retry--;

		if (retry == 0) {
			printf("[%s][%d] retry eyetest failed\n",
					__func__, __LINE__);
			return 1;
		}
		goto RETRY;
	}
	eyetest_out0 = sd_emmc_regs->geyetest_out0;
	eyetest_out1 = sd_emmc_regs->geyetest_out1;
	gintf3->eyetest_on = 0;
	sd_emmc_regs->gintf3 = intf3;
	/*if (vcfg & 0x4) {
		if (pdata->count > 32) {
			eyetest_out1 <<= (32 - (pdata->count - 32));
			eyetest_out1 >>= (32 - (pdata->count - 32));
		} else
			eyetest_out1 = 0x0;
	}*/
	align[line_x] = ((tmp | eyetest_out1) << 32) | eyetest_out0;
	printf("d1:0x%x,d2:0x%x,u64eyet:0x%016llx,l_x:%d\n",
			sd_emmc_regs->gdelay, sd_emmc_regs->gdelay1,
			align[line_x], line_x);
	return 0;
}

static int emmc_ds_data_alignment(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 delay1 = sd_emmc_regs->gdelay;
	u32 delay2 = sd_emmc_regs->gdelay1;
	int i, line_x, temp = 0;

	for (line_x = 0; line_x < 8; line_x++) {
		temp = fbinary(align[line_x]);
		if (temp <= 4)
			continue;
		for (i = 0; i < 64; i++) {
			emmc_debug("i = %d,delay1:0x%x,delay2:0x%x\n",
				i, sd_emmc_regs->gdelay,
				sd_emmc_regs->gdelay1);
			if (line_x < 5)
				delay1 += 1<<(6*line_x);
			else
				delay2 += 1<<(6*(line_x-5));
			/*delay1 += (1<<0)|(1<<6)|(1<<12)|(1<<18)|(1<<24);
			delay2 += (1<<0)|(1<<6)|(1<<12);*/
			sd_emmc_regs->gdelay = delay1;
			sd_emmc_regs->gdelay1 = delay2;
			emmc_eyetest_log(mmc, line_x);
			if (align[line_x] & 0xf0)
				break;
		}
		if (i == 64) {
			printf("%s [%d] Don't find line delay which aligned with DS\n",
				__func__, __LINE__);
			return 1;
		}
	}
	return 0;
}

static unsigned int get_emmc_cmd_win(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 delay2 = sd_emmc_regs->gdelay1;
	u32 max = 0, i, temp;
	u32 str[64] = {0};
	int best_start = -1, best_size = -1;
	int cur_start = -1, cur_size = 0;

	for (i = 0; i < 64; i++) {
		delay2 &= ~(0x3f << 24);
		delay2 |= (i << 24);
		sd_emmc_regs->gdelay1 = delay2;
		emmc_eyetest_log(mmc, 9);
		temp = fbinary(align[9]);
		str[i] = temp;
		if (max < temp)
			max = temp;
	}
	for (i = 0; i < 64; i++) {
		if (str[i] >= 4) {
			if (cur_start < 0)
				cur_start = i;
			cur_size++;
		} else {
			if (cur_start >= 0) {
				if (best_start < 0) {
					best_start = cur_start;
					best_size = cur_size;
				} else {
					if (best_size < cur_size) {
						best_start = cur_start;
						best_size = cur_size;
					}
				}
				cur_start = -1;
				cur_size = 0;
			}
		}
	}
	if (cur_start >= 0) {
		if (best_start < 0) {
			best_start = cur_start;
			best_size = cur_size;
		} else if (best_size < cur_size) {
			best_start = cur_start;
			best_size = cur_size;
		}
		cur_start = -1;
		cur_size = -1;
	}
	delay2 &= ~(0x3f << 24);
	delay2 |= ((best_start + (best_size * 3 / 4)) << 24);
	sd_emmc_regs->gdelay1 = delay2;
	emmc_eyetest_log(mmc, 9);
	return max;
}

/* first step*/
static int emmc_ds_core_align(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	u32 delay1 = sd_emmc_regs->gdelay;
	u32 delay2 = sd_emmc_regs->gdelay1;
	u32 delay2_bak = delay2;
	u32 count = 0, ds_count = 0, cmd_count = 0;
	ds_count = fbinary(align[8]);
	if (ds_count == 0)
		if ((align[8] & 0x1e0) == 0)
			goto out_cmd;
	emmc_debug("ds_count:%d,delay1:0x%x,delay2:0x%x\n",
			ds_count, sd_emmc_regs->gdelay, sd_emmc_regs->gdelay1);
	if (ds_count < 20) {
		delay2 += ((20 - ds_count) << 18);
		sd_emmc_regs->gdelay1 = delay2;
	} else
		sd_emmc_regs->gdelay1 += (1<<18);
	emmc_eyetest_log(mmc, 8);
	while (!(align[8] & 0xf)) {
		sd_emmc_regs->gdelay1 += (1<<18);
		emmc_eyetest_log(mmc, 8);
	}
	delay1 = sd_emmc_regs->gdelay;
	delay2 = sd_emmc_regs->gdelay1;
	count = ((delay2>>18) & 0x3f) - ((delay2_bak>>18) & 0x3f);

	delay1 += (count<<0)|(count<<6)|(count<<12)|(count<<18)|(count<<24);
	delay2 += (count<<0)|(count<<6)|(count<<12);

	sd_emmc_regs->gdelay = delay1;
	sd_emmc_regs->gdelay1 = delay2;
out_cmd:
	cmd_count = get_emmc_cmd_win(mmc);
	printf("ds_count %u, count: %d, cmd_count:%u\n", ds_count, count, cmd_count);

	return 0;
}

void update_all_line_eyetest(struct mmc *mmc)
{
	int line_x;

	for (line_x = 0; line_x < 10; line_x++) {
		emmc_eyetest_log(mmc, line_x);
	}
}

static int mmc_read_single_block(struct mmc *mmc, void *dst, lbaint_t start)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int ret = 0, err = 0, err_flag = 0, retries = 0;

__RETRY:
	cmd.cmdidx = MMC_CMD_READ_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->read_bl_len;

	cmd.resp_type = MMC_RSP_R1;

	data.dest = dst;
	data.blocks = 1;
	data.blocksize = mmc->read_bl_len;
	data.flags = MMC_DATA_READ;

	ret = mmc_send_cmd(mmc, &cmd, &data);
	if (ret || err) {
		if (err_flag == 0) {
			err_flag = 1;
			retries = 5;
		}
		if (retries) {
			retries--;
			goto __RETRY;
		}
		return 0;
	}
	return 1;
}


void emmc_ds_manual_sht(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	u32 intf3 = sd_emmc_regs->gintf3;
	struct intf3 *gintf3 = (struct intf3 *)&(intf3);
	int i, cnt = 0;
	int match[64];
	int best_start = -1, best_size = -1;
	int cur_start = -1, cur_size = 0;
	int count;
	unsigned long phy_addr = 0x1080000;
	void * addr = (void*) phy_addr;
	lbaint_t start = ((SZ_1M*(36+3))/512);

	printf("sample result:");
	for (i = 0; i < 64; i++) {
		gintf3->ds_sht_m += 1;
		sd_emmc_regs->gintf3 = intf3;

		cnt = 0;
		for (count = 0; count < 256; count++) {
			udelay(100);
			if (mmc_read_single_block(mmc, addr, start))
				cnt++;
		}
		if (cnt == 256)
			printf("Y");
		else
			printf("N");

		if (cnt == 256)
			match[i] = 0;
		else
			match[i] = -1;
	}
	printf("\n");

	for (i = 0; i < 64; i++) {
		if (match[i] == 0) {
			if (cur_start < 0)
				cur_start = i;
			cur_size++;
		} else {
			if (cur_start >= 0) {
				if (best_start < 0) {
					best_start = cur_start;
					best_size = cur_size;
				} else {
					if (best_size < cur_size) {
						best_start = cur_start;
						best_size = cur_size;
					}
				}
				cur_start = -1;
				cur_size = 0;
			}
		}
	}
	if (cur_start >= 0) {
		if (best_start < 0) {
			best_start = cur_start;
			best_size = cur_size;
		} else if (best_size < cur_size) {
			best_start = cur_start;
			best_size = cur_size;
		}
		cur_start = -1;
		cur_size = -1;
	}

	gintf3->ds_sht_m = best_start + best_size / 2;
	sd_emmc_regs->gintf3 = intf3;
	printf("ds_sht:%u, window:%d, intf3:0x%x, clock:0x%x, cfg: 0x%x\n",
			gintf3->ds_sht_m, best_size,
			sd_emmc_regs->gintf3,
			sd_emmc_regs->gclock,
			sd_emmc_regs->gcfg);
	return;

}
static ulong mmc_write_single_blocks(struct mmc *mmc, lbaint_t start,
		const void *src)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int timeout = 1000;
	int ret;

	udelay(100);
	if ((start + 1) > mmc->block_dev.lba) {
		printf("MMC: block number 0x" LBAF " exceeds max(0x" LBAF ")\n",
		       start + 1, mmc->block_dev.lba);
		return 0;
	}

	cmd.cmdidx = MMC_CMD_WRITE_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->write_bl_len;

	cmd.resp_type = MMC_RSP_R1;

	data.src = src;
	data.blocks = 1;
	data.blocksize = mmc->write_bl_len;
	data.flags = MMC_DATA_WRITE;

	ret = mmc_send_cmd(mmc, &cmd, &data);
	if (ret) {
		goto _out;
	}

_out:
	/* Waiting for the ready status */
	if (mmc_send_status(mmc, timeout))
		return 0;
	if (ret)
		return 0;
	return 1;
}

int auto_set_tx_delay(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	u32 clock = sd_emmc_regs->gclock;
	struct sd_emmc_clock *gclock = (struct sd_emmc_clock *)&(clock);
	int i;
	int match[64];
	int best_start = -1, best_size = -1;
	int cur_start = -1, cur_size = 0;
	unsigned long phy_addr = 0x1080000;
	void * addr = (void*) phy_addr;
	lbaint_t start = ((SZ_1M*(36+3))/512);
	int success_count=0;
	int count;

	if (mmc_bread(1, start, 1, addr) != 1) {
		return 0;
	}

	gclock->tx_delay = 0;
	printf("tx sample result:");
	for (i = 0; i < 64; i++) {
		gclock->tx_delay = i;
		sd_emmc_regs->gclock = clock;
		success_count = 0;

		for (count = 0; count < 256; count++) {
			if (mmc_write_single_blocks(mmc, start, addr))
				success_count++;
		}
		if (success_count == 256)
			printf("Y");
		else
			printf("N");
		if (success_count == 256)
			match[i] = 0;
		else
			match[i] = -1;
	}
	printf("\n");
	for (i = 0; i < 64; i++) {
		if (match[i] == 0) {
			if (cur_start < 0)
				cur_start = i;
			cur_size++;
		} else {
			if (cur_start >= 0) {
				if (best_start < 0) {
					best_start = cur_start;
					best_size = cur_size;
				} else {
					if (best_size < cur_size) {
						best_start = cur_start;
						best_size = cur_size;
					}
				}
				cur_start = -1;
				cur_size = 0;
			}
		}
	}
	if (cur_start >= 0) {
		if (best_start < 0) {
			best_start = cur_start;
			best_size = cur_size;
		} else if (best_size < cur_size) {
			best_start = cur_start;
			best_size = cur_size;
		}
		cur_start = -1;
		cur_size = -1;
	}
	if (best_size == -1) {
		printf("meson-mmc: can not find tx_delay\n");
		return 0;
	}
	gclock->tx_delay = best_start + best_size / 2;
	sd_emmc_regs->gclock = clock;
	printf("meson-mmc: tx_delay:%u\n", gclock->tx_delay);
	return 0;
}

unsigned int aml_sd_emmc_clktest(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	u32 intf3 = sd_emmc_regs->gintf3;
	struct intf3 *gintf3 = (struct intf3 *)&(intf3);
	u32 clktest = 0, delay_cell = 0, clktest_log = 0, count = 0;
	u32 vcfg = sd_emmc_regs->gcfg;

	int i = 0;
	unsigned int cycle = 0;

	sd_emmc_regs->gadjust = 0;

	/* one cycle = xxx(ps) */
	cycle = (1000000000 / mmc->clock) * 1000;
	vcfg &= ~(1 << 23);
	vcfg = 0x4896;

	sd_emmc_regs->gcfg = vcfg;
	sd_emmc_regs->gdelay = 0;
	sd_emmc_regs->gdelay1 = 0;

	gintf3->clktest_exp = 8;
	gintf3->clktest_on_m = 1;
	sd_emmc_regs->gintf3 = intf3;

	clktest_log = sd_emmc_regs->gclktest_log;
	clktest = sd_emmc_regs->gclktest_out;;
	while (!(clktest_log & 0x80000000)) {
		mdelay(1);
		i++;
		clktest_log = sd_emmc_regs->gclktest_log;
		clktest = sd_emmc_regs->gclktest_out;
		if (i > 4) {
			printf("[%s] [%d] emmc clktest error\n",
				__func__, __LINE__);
			break;
		}
	}
	if (clktest_log & 0x80000000) {
		clktest = sd_emmc_regs->gclktest_out;
		count = clktest / (1 << 8);
		if (vcfg & 0x4)
			delay_cell = ((cycle / 2) / count);
		else
			delay_cell = (cycle / count);
	}
	printf("%s [%d] clktest : %u, delay_cell: %d, count: %u\n",
		__func__, __LINE__, clktest, delay_cell, count);
	intf3 = sd_emmc_regs->gintf3;
	gintf3->clktest_on_m = 0;
	sd_emmc_regs->gintf3 = intf3;
	vcfg = sd_emmc_regs->gcfg;
	vcfg |= (1 << 23);
	sd_emmc_regs->gcfg = vcfg;
	return count;
}

static unsigned int tl1_emmc_line_timing(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 delay1 = 0, delay2 = 0, count = 12;

	delay1  = (count<<0)|(count<<6)|(count<<12)
		|(count<<18)|(count<<24);
	delay2 = (count<<0)|(count<<6)|(count<<12)
		|(aml_priv->cmd_c<<24);
	sd_emmc_regs->gdelay = delay1;
	sd_emmc_regs->gdelay1 = delay2;
	return 0;

}

static void set_emmc_reg_dir(struct mmc *mmc) {
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	sd_emmc_regs->gintf3 = 0x4140c8;
	sd_emmc_regs->gdelay = 0xc30c30c;
	sd_emmc_regs->gdelay1 =0x2500c30c;
	sd_emmc_regs->gclock = 0x10100002;
	sd_emmc_regs->gadjust = 0;
	sd_emmc_regs->gcfg = 0x804896;
	sd_emmc_regs->gstatus = 0x1ff0000;
	sd_emmc_regs->gstart = 0x5fc4c010;
}

static void aml_emmc_hs400_tl1(struct mmc *mmc)
{
	tl1_emmc_line_timing(mmc);
	emmc_ds_manual_sht(mmc);
	if (0)
		set_emmc_reg_dir(mmc);

}

static void aml_emmc_hs400_general(struct mmc *mmc) {
	update_all_line_eyetest(mmc);
	emmc_ds_core_align(mmc);
	update_all_line_eyetest(mmc);
	emmc_all_data_line_alignment(mmc);
	update_all_line_eyetest(mmc);
	emmc_ds_data_alignment(mmc);
	update_all_line_eyetest(mmc);
	emmc_ds_manual_sht(mmc);
}

int aml_post_hs400_timming(struct mmc *mmc)
{
	int i;

	cpu_id_t cpu_id = get_cpu_id();
	for (i = 0; i< 9; i++)
		align[i] = 0;
	mmc->refix = 1;
	aml_sd_emmc_clktest(mmc);
	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1)
		aml_emmc_hs400_tl1(mmc);
	else
		aml_emmc_hs400_general(mmc);

	auto_set_tx_delay(mmc);
	mmc->refix = 0;
	return 0;
}

void mmc_set_clock_phase(struct mmc *mmc, int hs_mode)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 clock = sd_emmc_regs->gclock;
	struct sd_emmc_clock *gclock = (struct sd_emmc_clock *) &clock;

	if (hs_mode) {
		gclock->core_phase = MMC_HS_COPHASE;
		sd_emmc_regs->gclock = clock;
	} else {
		gclock->core_phase = MMC_HS4_COPHASE;
		gclock->tx_delay = MMC_HS400_TXDELAY;
		sd_emmc_regs->gclock = clock;
	}
	return;
}

void mmc_set_txdelay(struct mmc *mmc, unsigned int tx_delay)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	sd_emmc_regs->gclock &= ~(0x1f << Cfg_tx_delay);
	sd_emmc_regs->gclock |= (tx_delay << Cfg_tx_delay);

	return;
}
void mmc_set_ddr_mode(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u8 clk_div;

	clk_div = 0x3f & sd_emmc_regs->gclock;
	if (clk_div & 1)
		 clk_div = (clk_div + 1) >> 1 ;
	else
		clk_div = clk_div >> 1;

	sd_emmc_regs->gclock &= ~(0x3f & sd_emmc_regs->gclock);
	sd_emmc_regs->gclock |= 0x3f & clk_div;

	sd_emmc_regs->gcfg |= 1 << 2;

	return;
}

void mmc_set_ds_enable(struct mmc *mmc)
{
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;

	sd_emmc_regs->gadjust |= 1 << 15;

	return ;
}

void mmc_select_clock_src(void )
{
	void* buf;
	unsigned long  addr;
	int size;
	u64 writeval;
	unsigned long byte;

	size = 4;
	byte = size;
	addr = CLKSRC_BASE + 0x25c;
	writeval = 0x680;
	buf = map_sysmem(addr, byte);
	*((u32 *)buf) = (u32)writeval;
	unmap_sysmem(buf);

	return;
}

void mmc_set_clock_div(struct mmc *mmc, u32 src_speed) {
	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	u32 clock = sd_emmc_regs->gclock;
	struct sd_emmc_clock *gclock = (struct sd_emmc_clock *) &clock;

	cpu_id_t cpu_id = get_cpu_id();

	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1) {
		gclock->div = 2;
		gclock->tx_delay = MMC_HS400_TXDELAY;
	} else {
		gclock->div = 1;
		gclock->tx_delay =12;//MMC_HS400_TXDELAY;
	}
	gclock->core_phase = MMC_HS4_COPHASE;
	gclock->src = 0;
	sd_emmc_regs->gclock = clock;

	return ;
}

/*
 * Function to enable HS400 mode
 * 1. Set the HS_TIMING on ext_csd 185 to 0x01
 * 2. Set the clock frequency to 52MHz
 * 3. Set the bus width to 8 bit DDR as supported by the target & host
 * 4. Set the HS_TIMING to 0x03
 * 5. Set the clock frequency to 200 MHZ
 */
uint32_t mmc_set_hs400_mode(struct mmc *mmc)
{
	uint32_t err;

	struct aml_card_sd_info *aml_priv = mmc->priv;
	struct sd_emmc_global_regs *sd_emmc_regs = aml_priv->sd_emmc_reg;
	cpu_id_t cpu_id = get_cpu_id();
	/* set HS_TIMING TO 0X01 */
	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
			EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS);

	if (err) {
		printf("Switch cmd returned failure %d\n", __LINE__);
		return err;
	}
	/* Set Clock @ 52MHZ */
	mmc_set_clock(mmc, 50000000);

	/* Set 8 bit DDR bus width */
	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
				      EXT_CSD_BUS_WIDTH, 6);

	if (err) {
		printf("Switch cmd returned failure %d\n", __LINE__);
		return err;
	}
	/* Setting HS400 in HS_TIMING using EXT_CSD (CMD6) */
	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
				      EXT_CSD_HS_TIMING, 19);

	if (err) {
		printf("Switch cmd returned failure %d\n", __LINE__);
		return err;
	}

	mmc_set_ddr_mode(mmc);
	mmc_set_ds_enable(mmc);

	mmc_set_clock_phase(mmc, 0);

	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1)
		tl1_set_clock_src();
	else
		mmc_select_clock_src();

	/* Set Clock @ 400 MHZ */
	mmc_set_clock(mmc, 200000000);

	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_TL1)
		mmc_set_clock_div(mmc, 792000000);
	else
		mmc_set_clock_div(mmc, 400000000);


	sd_emmc_regs->gadjust = 0x8000;
	aml_post_hs400_timming(mmc);

	return err;
}
#endif
