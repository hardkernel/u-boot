
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
#define debug_serial_puts(a) serial_puts(a)
#define debug_serial_put_hex(a, b) serial_put_hex(a, b)
#else
#define debug_serial_puts(a) ((void)0)
#define debug_serial_put_hex(a, b) ((void)0)
#endif

#ifdef CONFIG_DDR_SIZE_AUTO_DETECT
void ddr_size_detect(ddr_set_t * p_ddr_set) {
	/* Set max col, row, bank size */
	debug_serial_puts("DMC_DDR_CTRL: 0x");
	debug_serial_put_hex(rd_reg(DMC_DDR_CTRL), 32);
	debug_serial_puts("\n");
	wr_reg(DMC_DDR_CTRL, ((rd_reg(DMC_DDR_CTRL))&(~0x3F))|((5<<3)|5));
	debug_serial_puts("DMC_DDR_CTRL: 0x");
	debug_serial_put_hex(rd_reg(DMC_DDR_CTRL), 32);
	debug_serial_puts("\n");

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
		debug_serial_puts("size_loop1=0x");
		debug_serial_put_hex(size_loop, 32);
		debug_serial_puts("\n");
		wr_reg((unsigned long)DDR_SIZE_VERI_ADDR, 0);
		debug_serial_puts("write 0x");
		debug_serial_put_hex(write_addr, 32);
		debug_serial_puts("\n");
		wr_reg(write_addr, DDR_SIZE_PATTERN);
		_udelay(10);
		debug_serial_puts("rd_reg(0):0x");
		debug_serial_put_hex(rd_reg(DDR_SIZE_VERI_ADDR), 32);
		debug_serial_puts(", rd_reg(0x4<<size_loop):0x");
		debug_serial_put_hex(rd_reg(write_addr), 32);
		debug_serial_puts("\n");
		if (rd_reg(DDR_SIZE_VERI_ADDR) != 0) {
			debug_serial_puts("find match size1: 0x");
			debug_serial_put_hex(size_loop, 32);
			debug_serial_puts("\n");
			/* get correct ddr size */
			ddr_size = 1<<(size_loop+2);
			p_ddr_set->ddr_size = (ddr_size >> 20);
			/* set correct dmc cntl reg */
			if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK01_SAME) {
				/* config ddr size reg */
				ddr0_size = (p_ddr_set->ddr_size)>>6;
				ddr1_size_reg=0x7;
				debug_serial_puts("ddr0_size: 0x");
				debug_serial_put_hex(ddr0_size, 32);
				debug_serial_puts("\n");
				debug_serial_puts("ddr1_size: 0x");
				debug_serial_put_hex(ddr1_size, 32);
				debug_serial_puts("\n");
				while (!((ddr0_size>>=1)&0x1))
					ddr0_size_reg++;
			}
			else if (p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC) {
				/* config ddr size reg */
				ddr0_size = (p_ddr_set->ddr_size)>>7;
				ddr1_size = (p_ddr_set->ddr_size)>>7;
				debug_serial_puts("ddr0_size: 0x");
				debug_serial_put_hex(ddr0_size, 32);
				debug_serial_puts("\n");
				debug_serial_puts("ddr1_size: 0x");
				debug_serial_put_hex(ddr1_size, 32);
				debug_serial_puts("\n");
				while (!((ddr0_size>>=1)&0x1))
					ddr0_size_reg++;
				while (!((ddr1_size>>=1)&0x1))
					ddr1_size_reg++;
			}
			else {
				serial_puts("ddr size detect failed\n");
				reset_system();
			}
			break;
		}
	}
	debug_serial_puts("DMC_DDR_CTRL: 0x");
	debug_serial_put_hex(rd_reg(DMC_DDR_CTRL), 32);
	debug_serial_puts("\n");
	wr_reg(DMC_DDR_CTRL, ((rd_reg(DMC_DDR_CTRL))&(~0x3F))|(ddr1_size_reg<<3|ddr0_size_reg));
	debug_serial_puts("DMC_DDR_CTRL: 0x");
	debug_serial_put_hex(rd_reg(DMC_DDR_CTRL), 32);
	debug_serial_puts("\n");
	return;
}

#endif
