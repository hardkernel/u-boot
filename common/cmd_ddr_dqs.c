#include <common.h>
//#include <asm/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/cpu.h>

/* for gxbaby(s905) use only */

//#define wr_reg(addr, data)				writel(data, addr)
//#define rd_reg(addr)					readl(addr)
#define readl(addr)			(unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
#define writel(data ,addr)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)

#define wr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rd_reg(addr)		(unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)

/* ddr regs */
#define DDR0_PUB_REG_BASE				(0xc8836000)
#define DDR0_PUB_PIR					(DDR0_PUB_REG_BASE+(0x01<<2))
#define DDR0_PUB_PGCR1					(DDR0_PUB_REG_BASE+(0x03<<2))
#define DDR0_PUB_ACLCDLR				(DDR0_PUB_REG_BASE+(0x0F<<2))
#define DDR0_PUB_DX0LCDLR1				(DDR0_PUB_REG_BASE+(0xAF<<2))
#define DDR0_PUB_DX1LCDLR1				(DDR0_PUB_REG_BASE+(0xCF<<2))

#define ACBDLR_MAX						0X1F
#define ACLCDLR_MAX						0XFF
#define DQBDLR_MAX						0X1F
#define DQLCDLR_MAX						0XFF
#define DXNGTR_MAX						0X7

#define WR_RD_ADJ_USE_ENV				1
#define WR_RD_ADJ_USE_UART_INPUT		2

#define OPEN_CHANNEL_A_PHY_CLK()		(writel((0), 0xc8836c00))
#define OPEN_CHANNEL_B_PHY_CLK()		(writel((0), 0xc8836c00))
#define CLOSE_CHANNEL_A_PHY_CLK()		(writel((5), 0xc8836c00))
#define CLOSE_CHANNEL_B_PHY_CLK()		(writel((5), 0xc8836c00))

int wr_adj_per[12]={
	100	,
	100 ,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
};
int rd_adj_per[12]={
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
};

#define CMD_ARGV_MAX		13
#define CMD_DQS_ADJ_MAX		6
//just tune for lcdlr
int do_ddr_dqs(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if (argc < CMD_ARGV_MAX) {
		//cmd_usage(cmdtp);
		return -1;
	}

	int i=0;
	char *endp;
	unsigned int wr_rd_adj_input_src=2;

	printf("\nEnter ddr_fine_tune_lcdlr_env  function\n");
#if 0
	printf("\nargc== 0x%08x, argv", argc);
	for (i = 0;i<argc;i++)
		printf("[%d]=%s, ",i,argv[i]);
#endif
	OPEN_CHANNEL_A_PHY_CLK();

	//wr_rd_adj_input_src = simple_strtoul(argv[1], &endp, 10);
	if (wr_rd_adj_input_src == WR_RD_ADJ_USE_UART_INPUT) {
		printf("\nTune ddr lcdlr use uart input\n");
		if (argc > CMD_ARGV_MAX)
			argc = CMD_ARGV_MAX;
		for (i = 1; i<argc; i++) {
			if (i<(1+CMD_DQS_ADJ_MAX))
				wr_adj_per[i-1]=simple_strtoul(argv[i], &endp, 10);
			else
				rd_adj_per[i-1-CMD_DQS_ADJ_MAX]=simple_strtoul(argv[i], &endp, 10);
		}
	}

#if 0
	if (wr_rd_adj_input_src == WR_RD_ADJ_USE_ENV) {
		printf("\nTune ddr lcdlr use uboot env\n");
		const char *s;
		int value=0;
		s = getenv("env_wr_lcdlr_pr");
		if (s) {
			printf("%s",s);
			value = simple_strtoul(s, &endp, 16);
			printf("%d",value);
		}
		s = getenv("env_rd_lcdlr_pr");

		if (s) {
			printf("%s",s);
		}

		if (argc>24+2)
			argc=24+2;
		for (i = 2;i<argc;i++) {
			if (i<(2+6))
				wr_adj_per[i-2]=simple_strtoul(argv[i], &endp, 16);
			else
				rd_adj_per[i-8]=simple_strtoul(argv[i], &endp, 16);
		}
	}
#endif

	printf(" wr_adj_per[]={");
	for (i = 0; i < CMD_DQS_ADJ_MAX; i++)
		printf("%04d, ", wr_adj_per[i]);
	printf("};\n");
	printf(" rd_adj_per[]={");
	for (i = 0; i < CMD_DQS_ADJ_MAX; i++)
		printf("%04d, ", rd_adj_per[i]);
	printf("};\n");

	wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))|(1<<29));
	wr_reg(DDR0_PUB_PGCR1, (rd_reg(DDR0_PUB_PGCR1))|(1<<26));

	int lcdlr_w=0,lcdlr_r=0;
	unsigned temp_reg=0;
	int temp_count=0;
	for (temp_count=0;temp_count<2;temp_count++) {
		temp_reg=(unsigned)(DDR0_PUB_ACLCDLR+(temp_count<<2));
		lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&ACLCDLR_MAX);
		lcdlr_w=lcdlr_w?lcdlr_w:1;
		lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
		if (temp_count == 1)
			lcdlr_w=lcdlr_w&ACBDLR_MAX;
		wr_reg(((uint64_t)(temp_reg)),((lcdlr_w)&ACLCDLR_MAX));
	}

	for (temp_count=2;temp_count<CMD_DQS_ADJ_MAX;temp_count++) {
		temp_reg=(unsigned)(DDR0_PUB_DX0LCDLR1+(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1)*(temp_count-2));
		lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&DQLCDLR_MAX);
		lcdlr_w=lcdlr_w?lcdlr_w:1;
		lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg)))>>8)&DQLCDLR_MAX);
		lcdlr_r=lcdlr_r?lcdlr_r:1;
		lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
		lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
		wr_reg(((uint64_t)(temp_reg)),(((lcdlr_r<<16)|(lcdlr_r<<8)|(lcdlr_w))));
	}

/* S905X */
#if 0
	for ( temp_count=6;temp_count<8;temp_count++) {
		temp_reg=(unsigned)(DDR1_PUB_ACLCDLR+((temp_count-6)<<2));

		lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&ACLCDLR_MAX);
		lcdlr_w=lcdlr_w?lcdlr_w:1;
		lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
		if (temp_count == 7)
			lcdlr_w=lcdlr_w&ACBDLR_MAX;
		wr_reg(((uint64_t)(temp_reg)),((lcdlr_w)&ACLCDLR_MAX));
	}

	for (temp_count=8;temp_count<12;temp_count++) {
		temp_reg=(unsigned)(DDR1_PUB_DX0LCDLR1+(DDR1_PUB_DX1LCDLR1-DDR1_PUB_DX0LCDLR1)*(temp_count-8));
		lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&0xff);
		lcdlr_w=lcdlr_w?lcdlr_w:1;
		lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg)))>>8)&0xff);
		lcdlr_r=lcdlr_r?lcdlr_r:1;
		lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
		lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
		wr_reg(((uint64_t)(temp_reg)),(((lcdlr_r<<16)|(lcdlr_r<<8)|(lcdlr_w))));
	}
#endif

	wr_reg(DDR0_PUB_PGCR1, (rd_reg(DDR0_PUB_PGCR1))&(~(1<<26)));
	wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))&(~(1<<29)));

#if 0
	wr_reg(DDR1_PUB_PGCR1, (rd_reg(DDR1_PUB_PGCR1))&(~(1<<26)));
	wr_reg(DDR1_PUB_PIR, (rd_reg(DDR1_PUB_PIR))&(~(1<<29)));
#endif

	printf("\nEnd of adjust lcdlr\n");

	CLOSE_CHANNEL_A_PHY_CLK();
	return 0;
}

U_BOOT_CMD(
	ddr_dqs,	CMD_ARGV_MAX,	1,	do_ddr_dqs,
	"tune ddr dqs in uboot...",
	"[wr0] [wr1] [wr2] [wr3] [wr4] [wr5] [rd0] [rd1] [rd2] [rd3] [rd4] [rd5]\n"
	);
