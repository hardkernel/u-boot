/***************************************************************************
  * Author:  Elvis Yu <elvis.yu@amlogic.com>
  *
  *Remark: copy from trunk by Hisun Bao 2011.07.22
  *
  ***************************************************************************
  */
  
#include <linux/types.h>
#include <linux/mtd/compat.h>
#include <asm-generic/errno.h>

#include <asm/arch/clock.h>
#include <asm/arch/i2c.h>
#include <asm/arch/io.h>

#include <aml_i2c.h>


#define AML_I2C_CTRL_CLK_DELAY_MASK    (0x3FF)
#define AML_I2C_SLAVE_ADDR_MASK        (0xFF)
#define AML_I2C_SLAVE_ADDR_MASK_7BIT   (0x7F)

#define AML_I2C_ASSERT(X)							\
do {												\
	if (unlikely(!(X))) {							\
		printf("\n");								\
		printf("CacheFiles: Assertion failed\n");	\
		BUG();										\
	}												\
} while (0)


#define AML_I2C_DBG(level,fmt,args... ) do { \
	if(g_aml_i2c_data.i2c_debug > level)	 \
		printf(fmt,##args); 				 \
}while(0)

static unsigned char g_bAmlogicI2CInitialized = 0; //I2C initialized flag

static struct aml_i2c g_aml_i2c_data = {
	.i2c_debug     = 0,
	.cur_slave_addr= 0,
	.wait_count    = 0,
	.wait_ack_interval = 0,
	.wait_read_interval= 0,
	.wait_xfer_interval= 0,
	.master_no = I2C_MASTER_B,
	.msg_flags = 0,
	.ops       = 0,
	.master_regs = 0,	
	.reg_base    = 0,
	.use_pio     = 0,
	.master_i2c_speed= 0,
};

static void aml_i2c_set_clk(struct aml_i2c *i2c) 
{	
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	unsigned int i2c_clock_set;
	unsigned int sys_clk;
	struct aml_i2c_reg_ctrl* ctrl;
	//have not thought about sleep mode, sleep mode is low system clock
	sys_clk = get_clk81();
	AML_I2C_DBG(1, "clk81 is 0x%x\n", sys_clk);

	i2c_clock_set = sys_clk / i2c->master_i2c_speed;

	AML_I2C_DBG(1, "i2c->master_i2c_speed is 0x%x\n", i2c->master_i2c_speed);
#if MESON_CPU_TYPE > MESON_CPU_TYPE_MESON8
	i2c_clock_set >>= 1;
	ctrl = (struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl);
	if (i2c_clock_set > 0xfff) i2c_clock_set = 0xfff;
	ctrl->clk_delay = i2c_clock_set & 0x3ff;
	ctrl->clk_delay_ext = i2c_clock_set >> 10;
	i2c->master_regs->i2c_slave_addr &= ~(0xfff<<16);
	i2c->master_regs->i2c_slave_addr |= (i2c_clock_set>>1)<<16;
	i2c->master_regs->i2c_slave_addr |= 1<<28;
	i2c->master_regs->i2c_slave_addr &= ~(0x3f<<8); //no filter on scl&sda
#else	
	i2c_clock_set >>= 2;

	AML_I2C_DBG(1, "i2c_clock_set is 0x%x\n", i2c_clock_set);
		
	ctrl = (struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl);
	ctrl->clk_delay = i2c_clock_set & AML_I2C_CTRL_CLK_DELAY_MASK;		
#endif
} 

static void aml_i2c_set_platform_data(struct aml_i2c *i2c, 
										struct aml_i2c_platform *plat)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	i2c->master_i2c_speed = plat->master_i2c_speed;
	i2c->wait_count = plat->wait_count;
	i2c->wait_ack_interval = plat->wait_ack_interval;
	i2c->wait_read_interval = plat->wait_read_interval;
	i2c->wait_xfer_interval = plat->wait_xfer_interval;

	if(I2C_MASTER_A == i2c->master_no){
		i2c->master_pinmux.scl_reg = plat->master_a_pinmux.scl_reg;
		i2c->master_pinmux.scl_bit = plat->master_a_pinmux.scl_bit;
		i2c->master_pinmux.sda_reg = plat->master_a_pinmux.sda_reg;
		i2c->master_pinmux.sda_bit = plat->master_a_pinmux.sda_bit;
	}
	else if(I2C_MASTER_B == i2c->master_no){
		i2c->master_pinmux.scl_reg = plat->master_b_pinmux.scl_reg;
		i2c->master_pinmux.scl_bit = plat->master_b_pinmux.scl_bit;
		i2c->master_pinmux.sda_reg = plat->master_b_pinmux.sda_reg;
		i2c->master_pinmux.sda_bit = plat->master_b_pinmux.sda_bit;
	}
#ifdef HAS_AO_MODULE
	else if(I2C_MASTER_AO == i2c->master_no){
		i2c->master_pinmux.scl_reg = plat->master_ao_pinmux.scl_reg;
		i2c->master_pinmux.scl_bit = plat->master_ao_pinmux.scl_bit;
		i2c->master_pinmux.sda_reg = plat->master_ao_pinmux.sda_reg;
		i2c->master_pinmux.sda_bit = plat->master_ao_pinmux.sda_bit;
	}
#endif	

}

static void aml_i2c_pinmux_master(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	unsigned int scl_pinmux;
	unsigned int sda_pinmux;
	
	scl_pinmux = readl(i2c->master_pinmux.scl_reg);
	scl_pinmux |= i2c->master_pinmux.scl_bit;
	writel(scl_pinmux, i2c->master_pinmux.scl_reg);
	
	sda_pinmux = readl(i2c->master_pinmux.sda_reg);
	sda_pinmux |= i2c->master_pinmux.sda_bit;
	writel(sda_pinmux, i2c->master_pinmux.sda_reg);
}

static void aml_i2c_dbg(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	struct aml_i2c_reg_ctrl* ctrl;

	if(i2c->i2c_debug == 0)
		return ;

	printf( "i2c_slave_addr:  0x%x\n", 
								i2c->master_regs->i2c_slave_addr);
	printf( "i2c_token_list_0:  0x%x\n", 
								i2c->master_regs->i2c_token_list_0);
	printf( "i2c_token_list_1:  0x%x\n", 
								i2c->master_regs->i2c_token_list_1);
	printf( "i2c_token_wdata_0:  0x%x\n", 
								i2c->master_regs->i2c_token_wdata_0);
	printf( "i2c_token_wdata_1:  0x%x\n", 
								i2c->master_regs->i2c_token_wdata_1);
	printf( "i2c_token_rdata_0:  0x%x\n", 
								i2c->master_regs->i2c_token_rdata_0);
	printf( "i2c_token_rdata_1:  0x%x\n", 
								i2c->master_regs->i2c_token_rdata_1);
	for(i=0; i<AML_I2C_MAX_TOKENS; i++)
		printf("token_tag[%d]  %d\n", i, i2c->token_tag[i]);
	
	ctrl = ((struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl));
	printf( "i2c_ctrl:  0x%x\n", i2c->master_regs->i2c_ctrl);
	printf( "ctrl.rdsda  0x%x\n", ctrl->rdsda);
	printf( "ctrl.rdscl  0x%x\n", ctrl->rdscl);
	printf( "ctrl.wrsda  0x%x\n", ctrl->wrsda);
	printf( "ctrl.wrscl  0x%x\n", ctrl->wrscl);
	printf( "ctrl.manual_en  0x%x\n", ctrl->manual_en);
	printf( "ctrl.clk_delay  0x%x\n", ctrl->clk_delay);
	printf( "ctrl.rd_data_cnt  0x%x\n", ctrl->rd_data_cnt);
	printf( "ctrl.cur_token  0x%x\n", ctrl->cur_token);
	printf( "ctrl.error  0x%x\n", ctrl->error);
	printf( "ctrl.status  0x%x\n", ctrl->status);
	printf( "ctrl.ack_ignore  0x%x\n", ctrl->ack_ignore);
	printf( "ctrl.start  0x%x\n", ctrl->start);
								
}

static void aml_i2c_clear_token_list(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	i2c->master_regs->i2c_token_list_0 = 0;
	i2c->master_regs->i2c_token_list_1 = 0;
	memset(i2c->token_tag, TOKEN_END, AML_I2C_MAX_TOKENS);
}

static void aml_i2c_set_token_list(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	unsigned int token_reg=0;
	
	for(i=0; i<AML_I2C_MAX_TOKENS; i++)
		token_reg |= i2c->token_tag[i]<<(i*4);

	i2c->master_regs->i2c_token_list_0=token_reg;
}

static void aml_i2c_hw_init(struct aml_i2c *i2c, unsigned int use_pio)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	struct aml_i2c_reg_ctrl* ctrl;

	aml_i2c_set_clk(i2c);

	/*manual mode*/
	if(use_pio){
		ctrl = (struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl);
		ctrl->manual_en = 1;
	}
}

static int aml_i2c_check_error(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	struct aml_i2c_reg_ctrl* ctrl;
	ctrl = (struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl);
	
	if(ctrl->error)
	{
		//printf( "ctrl.cur_token  0x%x\n", ctrl->cur_token);
		return -EIO;
	}
	else
		return 0;
}

/*poll status*/
static int aml_i2c_wait_ack(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	struct aml_i2c_reg_ctrl* ctrl;
	
	for(i=0; i<i2c->wait_count; i++) {
		udelay(i2c->wait_ack_interval);
		ctrl = (struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl);
		if(I2C_IDLE == ctrl->status)
			return aml_i2c_check_error(i2c);
	}

	return -ETIMEDOUT;			
}

static void aml_i2c_get_read_data(struct aml_i2c *i2c, unsigned char *buf, 
														size_t len)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	unsigned long rdata0 = i2c->master_regs->i2c_token_rdata_0;
	unsigned long rdata1 = i2c->master_regs->i2c_token_rdata_1;

	for(i=0; i< min_t(size_t, len, AML_I2C_MAX_TOKENS>>1); i++)
		*buf++ = (rdata0 >> (i*8)) & 0xff;

	for(; i< min_t(size_t, len, AML_I2C_MAX_TOKENS); i++) 
		*buf++ = (rdata1 >> ((i - (AML_I2C_MAX_TOKENS>>1))*8)) & 0xff;
}

static void aml_i2c_fill_data(struct aml_i2c *i2c, unsigned char *buf, 
							size_t len)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	unsigned int wdata0 = 0;
	unsigned int wdata1 = 0;

	for(i=0; i< min_t(size_t, len, AML_I2C_MAX_TOKENS>>1); i++)
		wdata0 |= (*buf++) << (i*8);

	for(; i< min_t(size_t, len, AML_I2C_MAX_TOKENS); i++)
		wdata1 |= (*buf++) << ((i - (AML_I2C_MAX_TOKENS>>1))*8); 

	i2c->master_regs->i2c_token_wdata_0 = wdata0;
	i2c->master_regs->i2c_token_wdata_1 = wdata1;
}

static void aml_i2c_xfer_prepare(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	aml_i2c_pinmux_master(i2c);
	aml_i2c_set_clk(i2c);
} 

static void aml_i2c_start_token_xfer(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);

	i2c->master_regs->i2c_ctrl &= ~1;  /*clear*/
	i2c->master_regs->i2c_ctrl |= 1;   /*set*/
	
	udelay(i2c->wait_xfer_interval);
}

/*Amlogic I2C controller will send write data with slave addr in the token list,
    and set addr into addr reg is enough*/
static int aml_i2c_do_address(struct aml_i2c *i2c, unsigned int addr)
{
    AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
    
    i2c->cur_slave_addr = addr & AML_I2C_SLAVE_ADDR_MASK_7BIT;
#if MESON_CPU_TYPE > MESON_CPU_TYPE_MESON8	
    i2c->master_regs->i2c_slave_addr &=(~AML_I2C_SLAVE_ADDR_MASK);

    i2c->master_regs->i2c_slave_addr |=(i2c->cur_slave_addr<<1);
#else
	i2c->master_regs->i2c_slave_addr = i2c->cur_slave_addr<<1;
#endif
    return 0;
}

static void aml_i2c_stop(struct aml_i2c *i2c)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	aml_i2c_clear_token_list(i2c);
	i2c->token_tag[0]=TOKEN_STOP;
	aml_i2c_set_token_list(i2c);
	aml_i2c_start_token_xfer(i2c);
	aml_i2c_wait_ack(i2c);
}

static int aml_i2c_read(struct aml_i2c *i2c, unsigned char *buf, 
							size_t len) 
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	int ret;
	size_t rd_len;
	int tagnum=0;

	aml_i2c_clear_token_list(i2c);
	
	if(!(i2c->msg_flags & I2C_M_NOSTART)){
		i2c->token_tag[tagnum++]=TOKEN_START;
		i2c->token_tag[tagnum++]=TOKEN_SLAVE_ADDR_READ;

		aml_i2c_set_token_list(i2c);
		aml_i2c_dbg(i2c);
		aml_i2c_start_token_xfer(i2c);

		udelay(i2c->wait_ack_interval);
		
		ret = aml_i2c_wait_ack(i2c);
		if(ret<0)
			return ret;	
		aml_i2c_clear_token_list(i2c);
	}
	
	while(len){
		tagnum = 0;
		rd_len = min_t(size_t, len, AML_I2C_MAX_TOKENS);
		if(rd_len == 1)
			i2c->token_tag[tagnum++]=TOKEN_DATA_LAST;
		else{
			for(i=0; i<rd_len-1; i++)
				i2c->token_tag[tagnum++]=TOKEN_DATA;
			if(len > rd_len)
				i2c->token_tag[tagnum++]=TOKEN_DATA;
			else
				i2c->token_tag[tagnum++]=TOKEN_DATA_LAST;
		}
		aml_i2c_set_token_list(i2c);
		aml_i2c_dbg(i2c);
		aml_i2c_start_token_xfer(i2c);

		udelay(i2c->wait_ack_interval);
		
		ret = aml_i2c_wait_ack(i2c);
		if(ret<0)
			return ret;	
		
		aml_i2c_get_read_data(i2c, buf, rd_len);
		len -= rd_len;
		buf += rd_len;

		aml_i2c_dbg(i2c);
		udelay(i2c->wait_read_interval);
		aml_i2c_clear_token_list(i2c);
	}
	return 0;
}

static int aml_i2c_write(struct aml_i2c *i2c, unsigned char *buf, 
							size_t len) 
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int i;
	int ret;
	size_t wr_len;
	int tagnum=0;

	aml_i2c_clear_token_list(i2c);
	
	if(!(i2c->msg_flags & I2C_M_NOSTART)){
		i2c->token_tag[tagnum++]=TOKEN_START;
		i2c->token_tag[tagnum++]=TOKEN_SLAVE_ADDR_WRITE;
	}
	while(len){
		wr_len = min_t(size_t, len, AML_I2C_MAX_TOKENS-tagnum);
		for(i=0; i<wr_len; i++)
			i2c->token_tag[tagnum++]=TOKEN_DATA;
		
		aml_i2c_set_token_list(i2c);
		
		aml_i2c_fill_data(i2c, buf, wr_len);
		
		aml_i2c_dbg(i2c);
		aml_i2c_start_token_xfer(i2c);

		len -= wr_len;
		buf += wr_len;
		tagnum = 0;

		ret = aml_i2c_wait_ack(i2c);
		if(ret<0)
			return ret;
		
		aml_i2c_clear_token_list(i2c);
    	}
	return 0;
}

static struct aml_i2c_ops g_aml_i2c_m1_ops = {
	.xfer_prepare = aml_i2c_xfer_prepare,
	.read 		  = aml_i2c_read,
	.write 		  = aml_i2c_write,
	.do_address	  = aml_i2c_do_address,
	.stop		  = aml_i2c_stop,
};

/*General i2c master transfer*/
int aml_i2c_xfer(struct i2c_msg *msgs, 
							int num)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);

	if(0 == g_bAmlogicI2CInitialized){
		return -ENXIO; //device not initialized
		}

	struct aml_i2c *i2c = &g_aml_i2c_data;
	struct i2c_msg * p=0;
	unsigned int i;
	unsigned int ret=0;	
	
	i2c->ops->xfer_prepare(i2c);

	for (i = 0; !ret && i < num; i++) {
		p = &msgs[i];
		i2c->msg_flags = p->flags;
		ret = i2c->ops->do_address(i2c, p->addr);
		if (ret || !p->len)
		{
			continue;
		}
		if (p->flags & I2C_M_RD)
			ret = i2c->ops->read(i2c, p->buf, p->len);
		else
			ret = i2c->ops->write(i2c, p->buf, p->len);
	}
	
	i2c->ops->stop(i2c);

	
	if (p->flags & I2C_M_RD){
		AML_I2C_DBG(0, "read ");
	}
	else {
		AML_I2C_DBG(0, "write ");
	}
	for(i=0;i<p->len;i++)
		AML_I2C_DBG(0, "%x-",*(p->buf)++);
	AML_I2C_DBG(0, "\n");
	
	/* Return the number of messages processed, or the error code*/
	if (ret == 0)
		return num;
	else {
		printf("[aml_i2c_xfer] error ret = %d \t", ret);
		printf("i2c master %s current slave addr is 0x%x\n", 
						i2c->master_no?"a":"b", i2c->cur_slave_addr);
		return ret;
	}
}

/*General i2c master transfer 100k*/
int aml_i2c_xfer_slow(struct i2c_msg *msgs, 
							int num)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	struct aml_i2c *i2c = &g_aml_i2c_data;
	struct i2c_msg * p=0;
	unsigned int i;
	unsigned int ret=0;
	unsigned int last_speed = i2c->master_i2c_speed;
	

	i2c->master_i2c_speed = AML_I2C_SPPED_100K;/* change speed in i2c->lock*/
	i2c->ops->xfer_prepare(i2c);

	for (i = 0; !ret && i < num; i++) {
		p = &msgs[i];
		i2c->msg_flags = p->flags;
		//ret = i2c->ops->do_address(i2c, p->addr, p->buf, p->flags & I2C_M_RD, p->len);
		ret = i2c->ops->do_address(i2c, p->addr);
		if (ret || !p->len)
			continue;
		if (p->flags & I2C_M_RD)
			ret = i2c->ops->read(i2c, p->buf, p->len);
		else
			ret = i2c->ops->write(i2c, p->buf, p->len);
	}
	
	i2c->ops->stop(i2c);


	AML_I2C_DBG(0, "aml_i2c_xfer_slow");
	if (p->flags & I2C_M_RD){
		AML_I2C_DBG(0, "read ");
	}
	else {
		AML_I2C_DBG(0, "write ");
	}
	for(i=0;i<p->len;i++)
		AML_I2C_DBG(0, "%x-",*(p->buf)++);
	AML_I2C_DBG(0, "\n");
	
	i2c->master_i2c_speed = last_speed;
	/* Return the number of messages processed, or the error code*/
	if (ret == 0)
		return num;
	else {
		struct aml_i2c_reg_ctrl* ctrl;

		ctrl = ((struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl));
		//if(ctrl->cur_token == TOKEN_START)
			//printf("error addr\n");
		//else
			//printf("error data\n");
		return ret;
	}
}


/***************i2c class****************/

__attribute__((unused))  static ssize_t show_i2c_debug(void)
{
	struct aml_i2c *i2c = &g_aml_i2c_data;
	printf("i2c debug is 0x%x\n", i2c->i2c_debug);
	return 0;
}

__attribute__((unused))  static ssize_t show_i2c_info(void)
{
	struct aml_i2c *i2c = &g_aml_i2c_data;
	struct aml_i2c_reg_ctrl* ctrl;

	printf( "i2c master %s current slave addr is 0x%x\n", 
						i2c->master_no?"b":"a", i2c->cur_slave_addr);
	printf( "wait ack timeout is 0x%x\n", 
							i2c->wait_count * i2c->wait_ack_interval);
	printf( "master regs base is 0x%x \n", 
								(unsigned int)(i2c->master_regs));

	ctrl = ((struct aml_i2c_reg_ctrl*)&(i2c->master_regs->i2c_ctrl));
	printf( "i2c_ctrl:  0x%x\n", i2c->master_regs->i2c_ctrl);
	printf( "ctrl.rdsda  0x%x\n", ctrl->rdsda);
	printf( "ctrl.rdscl  0x%x\n", ctrl->rdscl);
	printf( "ctrl.wrsda  0x%x\n", ctrl->wrsda);
	printf( "ctrl.wrscl  0x%x\n", ctrl->wrscl);
	printf( "ctrl.manual_en  0x%x\n", ctrl->manual_en);
	printf( "ctrl.clk_delay  0x%x\n", ctrl->clk_delay);
	printf( "ctrl.rd_data_cnt  0x%x\n", ctrl->rd_data_cnt);
	printf( "ctrl.cur_token  0x%x\n", ctrl->cur_token);
	printf( "ctrl.error  0x%x\n", ctrl->error);
	printf( "ctrl.status  0x%x\n", ctrl->status);
	printf( "ctrl.ack_ignore  0x%x\n", ctrl->ack_ignore);
	printf( "ctrl.start  0x%x\n", ctrl->start);
	
	printf( "i2c_slave_addr:  0x%x\n", 
								i2c->master_regs->i2c_slave_addr);
	printf( "i2c_token_list_0:  0x%x\n", 
								i2c->master_regs->i2c_token_list_0);
	printf( "i2c_token_list_1:  0x%x\n", 
								i2c->master_regs->i2c_token_list_1);
	printf( "i2c_token_wdata_0:  0x%x\n", 
								i2c->master_regs->i2c_token_wdata_0);
	printf( "i2c_token_wdata_1:  0x%x\n", 
								i2c->master_regs->i2c_token_wdata_1);
	printf( "i2c_token_rdata_0:  0x%x\n", 
								i2c->master_regs->i2c_token_rdata_0);
	printf( "i2c_token_rdata_1:  0x%x\n", 
								i2c->master_regs->i2c_token_rdata_1);
								
	printf( "master pinmux\n");
	printf( "scl_reg:  0x%x\n", i2c->master_pinmux.scl_reg);
	printf( "scl_bit:  0x%x\n", i2c->master_pinmux.scl_bit);
	printf( "sda_reg:  0x%x\n", i2c->master_pinmux.sda_reg);
	printf( "sda_bit:  0x%x\n", i2c->master_pinmux.sda_bit);

	return 0;
}

__attribute__((unused))  static unsigned int aml_clock81_reading(void)
{
	AML_I2C_DBG(1, "FILE:%s:%d, FUNC:%s\n", __FILE__,__LINE__,__func__);
	int val;
	
	//val = READ_CBUS_REG(0x1070);
	val = READ_CBUS_REG(HHI_OTHER_PLL_CNTL);	
	printf( "HHI_OTHER_PLL_CNTL=%x\n", val);

	//val = READ_CBUS_REG(0x105d);
	val = READ_CBUS_REG(HHI_MPEG_CLK_CNTL);
	printf( "HHI_MPEG_CLK_CNTL=%x\n", val);
	
	return 148;
}


static const unsigned long g_aml_i2c_reg_start[] = {
    [0] = MESON_I2C_MASTER_A_START,/*master a*/
    [1] = MESON_I2C_MASTER_B_START,/*master b*/
    [2] = MESON_I2C_SLAVE_START,/*slave*/
#ifdef HAS_AO_MODULE
    [3] = MESON_I2C_MASTER_AO_START,/*master ao*/
#endif
};

static int __i2c_init_flag = 0;

int aml_i2c_init(void) 
{
	extern struct aml_i2c_platform g_aml_i2c_plat;
	
	struct aml_i2c_platform *plat = &g_aml_i2c_plat;
	struct aml_i2c *i2c = &g_aml_i2c_data;

    if (__i2c_init_flag) {
        return ;    
    }

	if(plat == NULL)
	{
	  printf("\nERROR! struct aml_i2c_platform *plat is a NULL pointer!\n");
	  return	-1;
	}

	i2c->ops = &g_aml_i2c_m1_ops;
	i2c->master_no = plat->master_no;
	i2c->use_pio = plat->use_pio;
	AML_I2C_ASSERT((i2c->master_no >= 0) && (i2c->master_no <= 3));

	/*master a or master b*/
	  if(i2c->master_no >= ARRAY_SIZE(g_aml_i2c_reg_start))
	{
	  printf("\nERROR!	overflow: i2c->master_no = %d\n", i2c->master_no);
	  return	-1;
	}

	i2c->master_regs = (struct aml_i2c_reg_master __iomem*)(g_aml_i2c_reg_start[i2c->master_no]);

	AML_I2C_ASSERT(i2c->master_regs);
	AML_I2C_ASSERT(plat);
	aml_i2c_set_platform_data(i2c, plat);

	aml_i2c_hw_init(i2c , i2c->use_pio);

	g_bAmlogicI2CInitialized = 1;

    __i2c_init_flag = 1;
	return 0;
}



/*****************************
 ** add by wch for cmd_i2c **
 ****************************/
/*
 * i2c read cmd
 */
int i2c_read(uchar chip, uint addr, int alen, uchar *buffer, int len)
{
	int ret;
	struct i2c_msg *msgs = {0};
    /*
	 * I2C data address within the chip.  This can be 1 or
	 * 2 bytes long.  Some day it might be 3 bytes long :-).
	 * here,if it has 2 bytes long at most.
	 */
	uint8_t devaddr[2];

	switch(alen)
	{
		case 0:							 //NO I2C data address within the chip.
			   puts ("'*.0' shows no i2c data or register address within the chip. \n");
     		   return -1;
			   break;
			   
		case 1:							 //I2C data address:1 byte long within the chip.
			   if(addr>0xff)
			   {
					puts ("'*.1' shows i2c data or register address 1 byte long within the chip. \n");
					return -1;
			   }
			   else
			   		devaddr[0] = addr & 0xff;
			   break;	
			   
		case 2:							 //I2C data address:2 bytes long within the chip.
			   if(addr>0xffff || addr<0x1ff)
			   {
					puts ("'*.2' shows i2c data or register address 2 bytes long within the chip. \n");
					return -1;
			   }
			   else
			   {
			   		devaddr[0] = addr & 0xff;
		       		devaddr[1] = (addr >> 8) & 0xff;
			   }
			   break;
			   
		case 3:							 //I2C data address:3 bytes long within the chip.
		                                 //Here,if it has 2 bytes long at most.
			   puts ("Here,we have set i2c data address or register address 2 bytes long at most.\n");
			   return -1;
			   break;
	}


	if(len==1)
	{
		struct i2c_msg msg[] = {
        	{
            	.addr = chip,
            	.flags = 0,
            	.len = alen,             //I2C data address length.
            	.buf = devaddr,
        	},
        	{
            	.addr = chip,
            	.flags = 1,
            	.len = 1,                //read 1 byte from I2C data address.
            	.buf = buffer,
        	}
    	};
		msgs = msg;
	}
	else if(len>1)
	{
		struct i2c_msg msg[] = {
        	{
            	.addr = chip,
            	.flags = 0,
            	.len = alen,             //I2C data address length.
            	.buf = devaddr,
        	},
        	{
            	.addr = chip,
            	.flags = 1,
            	.len = len,              //read len bytes from I2C data address.
            	.buf = buffer,
        	}
		};
		msgs = msg;
	}
	
	ret = aml_i2c_xfer(msgs, 2);
    if (ret < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
		return ret;
    }

/*	
	printf("chip=0x%x,addr=0x%x,alen=%d,len=%d",chip,addr,alen,len);
    for(ret=0;ret<len;ret++)
		printf(",buffer[%d]=0x%x",ret,*buffer++);
	printf("\n");
*/

	return 0;
}



/*
 * i2c write cmd
 */
int i2c_write(unsigned char chip, unsigned int addr, int alen,unsigned char *buffer, int len)
{
	int ret;
	int length = 0;
	struct i2c_msg *msgs;
	uint8_t buff[3];

    /*
	 * I2C data address within the chip.  This can be 1 or
	 * 2 bytes long.  Some day it might be 3 bytes long :-).
	 * here,if it has 2 bytes long at most.
	 */
	uint8_t devaddr[2] = {0};

	switch(alen)                        
	{
		case 0:							//NO I2C data address within the chip.
			   puts ("'*.0' shows no i2c data or register address within the chip. \n");
			   return -1;
			   break;
			   
		case 1:							//I2C data address:1 byte long within the chip.
			   if(addr>0xff)
			   {
					puts ("'*.1' shows i2c data or register address 1 byte long within the chip. \n");
					return -1;
			   }
			   else
			   		devaddr[0] = addr & 0xff;
			   break;	
			   
		case 2:							//I2C data address:2 bytes long within the chip.
			   if(addr>0xffff || addr<0x1ff)
			   {
					puts ("'*.2' shows i2c data or register address 2 bytes long within the chip. \n");
					return -1;
			   }
			   else
			   {
			   		devaddr[0] = addr & 0xff;
		       		devaddr[1] = (addr >> 8) & 0xff;
			   }
			   break;
			   
		case 3:							//I2C data address:3 bytes long within the chip.
		                                //Here,if it has 2 bytes long at most.
			   puts ("Here,we have set i2c data address or register address 2 bytes long at most.\n");
			   return -1;
			   break;
	}

	if(len==1)
	{
		switch(alen)                        
		{
		   
			case 1:					
				   buff[0] = devaddr[0];
				   buff[1] = *buffer;
				   length = 2;
			       break;	
			   
			case 2:						
			       buff[0] = devaddr[0];
			       buff[1] = devaddr[1];
			       buff[2] = *buffer;
			       length = 3;
			       break;
			/*	   
			case 3:
				   //when i2c data address or register address 3 bytes long ,here should be completed.
				   break;
			*/

		}

    	struct i2c_msg msg[] = {
        	{
       	 	.addr = chip,
        	.flags = 0,
        	.len = length,
        	.buf = buff,
       		}
    	};
		msgs = msg;
	}
	else
	{
	    /*
		 * This section may be modified when len > 1.
	     */
		printf("I2C write data length is %d. \n",len);
		return -1;
	}
	
	ret = aml_i2c_xfer(msgs, 1);
    if (ret < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
		return ret;
    }

	return 0;
}



/*
 * i2c probe cmd
 * return 0:i2c probe ok, non 0:i2c probe failed.
 */
int i2c_probe(uchar chip)
{
	int ret;
    unsigned int addr=0x00;		//i2c data or register address
	struct aml_i2c *i2c = &g_aml_i2c_data;
	struct i2c_msg * p=0;

    struct i2c_msg msg[] = {
        	{
       	 	.addr = chip,
        	.flags = 0,			//write
        	.len = 1,
         	.buf = (unsigned char *)&addr,
       		}
    	};


	i2c->ops->xfer_prepare(i2c);

	
	p = &msg[0];
	i2c->msg_flags = p->flags;
	ret = i2c->ops->do_address(i2c, p->addr);

	if (p->flags & I2C_M_RD)
		ret = i2c->ops->read(i2c, p->buf, p->len);
	else
		ret = i2c->ops->write(i2c, p->buf, p->len);
	
	i2c->ops->stop(i2c);

	if(ret==0)
		return 0;          	 	//This chip valid. 
	else
		return ret;         	//This chip invalid.
}



/*
 * i2c reset cmd
 */
void i2c_init(int speed, int slaveaddr)
{ 
	#define AML_I2C_SPPED_400K 400000		 //The initial value of amlogic i2c speed           
	
	extern struct aml_i2c_platform g_aml_i2c_plat; 
    g_aml_i2c_plat.master_i2c_speed = AML_I2C_SPPED_400K; 
    aml_i2c_init();
}



/*
 * i2c speed cmd
 * get i2c speed
 */
unsigned int i2c_get_bus_speed(void)
{

	extern struct aml_i2c_platform g_aml_i2c_plat; 
	return g_aml_i2c_plat.master_i2c_speed;
}



/*
 * i2c speed xxx cmd
 * set i2c speed
 */
int i2c_set_bus_speed(unsigned int speed)
{
/*
#define AML_I2C_SPPED_50K			50000
#define AML_I2C_SPPED_100K			100000
#define AML_I2C_SPPED_200K			200000
#define AML_I2C_SPPED_300K			300000
#define AML_I2C_SPPED_400K			400000
*/
	extern struct aml_i2c_platform g_aml_i2c_plat; 

	if((speed==50000) || (speed==100000) || (speed==200000) || (speed==300000) || (speed==400000))
    {
    	g_aml_i2c_plat.master_i2c_speed = speed;  
    	aml_i2c_init();
		return 0;
	}
	else
	{
		printf("The I2C speed setting don't match,should choose:50000,100000,200000,300000 or 400000.\n");
		return -1;
	}
	
}

