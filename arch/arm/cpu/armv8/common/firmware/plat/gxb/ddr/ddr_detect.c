
#define SIZE_16MB 0x01000000
#define DDR_SIZE_PATTERN 0xAABBCCDD
#define DDR_SIZE_VERI_ADDR SIZE_16MB

#define DDR_VERI_PATTERN_256M 0
#define DDR_VERI_PATTERN_512M 0
#define DDR_VERI_PATTERN_1024M 0xAC7E5AC0
#define DDR_VERI_PATTERN_2048M 0x1A182515

#define DDR_VERI_PATTERN_384M 0
#define DDR_VERI_PATTERN_768M 0
#define DDR_VERI_PATTERN_1536M 0
#define DDR_VERI_PATTERN_3072M 0

#define DDR_SIZE_LOOP_MAX 29

#ifndef DDR_DETECT_DEBUG
#define DDR_DETECT_DEBUG 0
#endif

#if DDR_DETECT_DEBUG
#define debug_print(...) printf(__VA_ARGS__)
#else
#define debug_print(...) ((void)0)
#endif

#ifdef CONFIG_DDR_SIZE_AUTO_DETECT
void ddr_size_detect(ddr_set_t * p_ddr_set) {
	/* Set max col, row, bank size */
	debug_print("DMC_DDR_CTRL: 0x%x\n", rd_reg(DMC_DDR_CTRL));
	wr_reg(DMC_DDR_CTRL, ((rd_reg(DMC_DDR_CTRL))&(~0x3F))|((5<<3)|5));
	debug_print("DMC_DDR_CTRL: 0x%x\n", rd_reg(DMC_DDR_CTRL));

	uint32_t size_loop=0;
	uint64_t write_addr=0;
	uint32_t ddr_size=0;
	uint32_t ddr0_size=0;
	uint32_t ddr1_size=0;
	uint32_t ddr0_size_reg=0;
	uint32_t ddr1_size_reg=0;

	//first detect aligned size
	for (size_loop=0; size_loop<=DDR_SIZE_LOOP_MAX; size_loop++) {
		write_addr = (uint32_t)((0x4<<size_loop)+DDR_SIZE_VERI_ADDR);
		debug_print("size_loop1=%d\n", size_loop);
		wr_reg((unsigned long)DDR_SIZE_VERI_ADDR, 0);
		debug_print("write 0x%x\n", write_addr);
		wr_reg(write_addr, DDR_SIZE_PATTERN);
		_udelay(10);
		debug_print("rd_reg(0):0x%x, rd_reg(0x4<<size_loop):0x%x\n", \
			rd_reg(DDR_SIZE_VERI_ADDR), rd_reg(write_addr));
		if (rd_reg(DDR_SIZE_VERI_ADDR) != 0) {
			debug_print("find match size1: 0x%x\n", size_loop);
			/* get correct ddr size */
			ddr_size = 1<<(size_loop+2);
			p_ddr_set->ddr_size = (ddr_size >> 20);
			/* set correct dmc cntl reg */
			if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK01_SAME) {
				/* config ddr size reg */
				ddr0_size = (p_ddr_set->ddr_size)>>6;
				ddr1_size_reg=0x7;
				debug_print("ddr0_size: 0x%x\n", ddr0_size);
				debug_print("ddr1_size: 0x%x\n", ddr1_size);
				while (!((ddr0_size>>=1)&0x1))
					ddr0_size_reg++;
			}
			else if (p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC) {
				/* config ddr size reg */
				ddr0_size = (p_ddr_set->ddr_size)>>7;
				ddr1_size = (p_ddr_set->ddr_size)>>7;
				debug_print("ddr0_size: 0x%x\n", ddr0_size);
				debug_print("ddr1_size: 0x%x\n", ddr1_size);
				while (!((ddr0_size>>=1)&0x1))
					ddr0_size_reg++;
				while (!((ddr1_size>>=1)&0x1))
					ddr1_size_reg++;
			}
			else {
				printf("ddr size detect failed\n");
				reset_system();
			}
			break;
		}
	}
	debug_print("DMC_DDR_CTRL: 0x%x\n", rd_reg(DMC_DDR_CTRL));
	wr_reg(DMC_DDR_CTRL, ((rd_reg(DMC_DDR_CTRL))&(~0x3F))|(ddr1_size_reg<<3|ddr0_size_reg));
	debug_print("DMC_DDR_CTRL: 0x%x\n", rd_reg(DMC_DDR_CTRL));
	return;
}

#endif
