/*
 * Amlogic SPI flash interface
 *
 * Copyright (C) 2011 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 * 
 *
 * Dedicated for Amlogic SPI controller use
 */

#include <common.h>
#include <malloc.h>
#include <asm/cache.h>      
#include "spi_flash_amlogic.h"

#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
#include "spi_secure_storage.h"
#endif
/*note: To use Amlogic SPI flash controller for SPI flash access 
         two macro CONFIG_CMD_SF & CONFIG_AML_MESON_1/2/3
         must be set to 1
         header file locate at:  \board\amlogic\configs\

backup PIN_MAX_1 value before claim bus for SPI controller
restore the original value after usage
note: following two functions for one SPI operation
      void spi_release_bus(struct spi_slave *slave)
      int spi_claim_bus(struct spi_slave *slave)

static u32 g_u32_PERIPHS_PIN_MUX_1_backup = 0;
*/

int spi_flash_cmd(struct spi_slave *spi, u32 cmd, void *response, size_t len)
{
	unsigned long flags = SPI_XFER_BEGIN;
	int ret;
	u32 var=cmd;	

	if (len == 0)
		flags |= SPI_XFER_END;
	
	flags|=SPI_XFER_CMD;

	ret = spi_xfer(spi, 4*8, (u8*)&var, NULL, flags);				

	if (ret) {
		debug("SF: Failed to send command %02x: %d\n", cmd, ret);
		return ret;
	}

	if (len){
		if((1<<SPI_FLASH_RDID)==cmd){
			flags=SPI_XFER_ID;			
		}
		else{
			if((1<<SPI_FLASH_RDSR)==cmd){
				flags=SPI_XFER_STATUS;				
			}
		}

		ret = spi_xfer(spi, len * 8, NULL, response, flags|SPI_XFER_END);

		if (ret){
			debug("SF: Failed to read response (%zu bytes): %d\n",
					len, ret);			
		}
	}
	return ret;
}

///////////////////////////////////////////////////////////////////////////////////////
//
// implementation of header file <project>\include\spi.h
//
//
struct aml_spi_slave {
	struct spi_slave slave;
	void * adr_base;
	u32    mode;
	u32    ctl;
};

static inline struct aml_spi_slave *to_aml_spi(struct spi_slave *slave){
	return container_of(slave, struct aml_spi_slave, slave);
}

__attribute__((weak)) int spi_cs_is_valid(unsigned int bus, unsigned int cs){return 0;}

__attribute__((weak)) void spi_cs_activate(struct spi_slave *slave) {}

__attribute__((weak)) void spi_cs_deactivate(struct spi_slave *slave){}

static void spi_initialize(void){ 
	writel(0xea949,P_SPI_FLASH_CTRL); //SPI clock-> system clock / 10
}

struct spi_slave *spi_setup_slave(unsigned int bus, unsigned int cs,
			unsigned int max_hz, unsigned int mode)
{
	struct aml_spi_slave * amls;
	amls = ( struct aml_spi_slave *)malloc(sizeof(struct aml_spi_slave));
	if (!amls)
		return NULL;

	spi_initialize(); 

	amls->slave.bus = bus;
	amls->slave.cs 	= cs;

#if defined(CONFIG_AML_MESON_1) || defined (CONFIG_AML_MESON_2)||defined(CONFIG_AML_MESON_3)
    amls->adr_base 	=(void*)0x40000000;
#elif defined(CONFIG_AML_MESON_A3)
	#error "please implement A3 SPI buffer address!"
#elif defined(CONFIG_AML_MESON_6) || defined(CONFIG_AML_MESON_8)
	amls->adr_base 	=(void*)0xCC000000;
#else
	#error "please define [CONFIG_AML_MESON_1/2/3/A2/A2/A1] for SPI controler base address setting!"
#endif

	amls->mode=mode;
	
	return &amls->slave;
}

void spi_free_slave(struct spi_slave *slave)
{
	struct aml_spi_slave *amls = to_aml_spi(slave);
	free(amls);
}

int spi_check_write_protect(void)
{
    writel(1<<SPI_FLASH_RDSR, P_SPI_FLASH_CMD);

    while(readl(P_SPI_FLASH_CMD)!=0);

    return (readl(P_SPI_FLASH_STATUS)&(0xf<<2)) == (0xf<<2)?1:0;
}

void spi_enable_write_protect(void)
{	
    unsigned char statusValue;
    int ret;

    statusValue = 0xf<<2;//all protect;
		
	/*write enable*/	
    writel(1<<SPI_FLASH_WREN, P_SPI_FLASH_CMD);
    while(readl(P_SPI_FLASH_CMD)!=0){
		do{
			writel(1<<SPI_FLASH_RDSR, P_SPI_FLASH_CMD);
			while(readl(P_SPI_FLASH_CMD)!=0);
			ret = readl(P_SPI_FLASH_STATUS);
  		}while (ret&1);
    }
		
    /*write status register*/
    writel(statusValue,P_SPI_FLASH_STATUS);
    writel(1<<SPI_FLASH_WRSR, P_SPI_FLASH_CMD);
    while(readl(P_SPI_FLASH_CMD)!=0){
		do{
			writel(1<<SPI_FLASH_RDSR, P_SPI_FLASH_CMD);
			while(readl(P_SPI_FLASH_CMD)!=0);
			ret = readl(P_SPI_FLASH_STATUS);
  		}while (ret&1);
    }
}

void spi_disable_write_protect(void)
{
    unsigned char statusValue;
    int ret, var;

    statusValue = 0;

    /*write enable*/ 
    var = 1 << SPI_FLASH_WREN;
    writel(var, P_SPI_FLASH_CMD);
    while(readl(P_SPI_FLASH_CMD)!=0);
    ret=1;
    while ((ret&1)==1){   	
        var=1<<SPI_FLASH_RDSR;
        writel(var, P_SPI_FLASH_CMD);
        while(readl(P_SPI_FLASH_CMD)!=0);
        ret = readl(P_SPI_FLASH_STATUS)&0xff;
    }

    /*write status register*/
    writel(statusValue,P_SPI_FLASH_STATUS);
    var = 1<<SPI_FLASH_WRSR;
    writel(var, P_SPI_FLASH_CMD);
    while(readl(P_SPI_FLASH_CMD)!=0);
    
    ret=1;
    while ( (ret&1)==1 ) {   	
        var=1<<SPI_FLASH_RDSR;
        writel(var, P_SPI_FLASH_CMD);
        while(readl(P_SPI_FLASH_CMD)!=0);
        ret = readl(P_SPI_FLASH_STATUS)&0xff;
    }  
}

int spi_claim_bus(struct spi_slave *slave)
{
	debug("%s: bus:%i cs:%i\n", __func__, slave->bus, slave->cs);

	//g_u32_PERIPHS_PIN_MUX_1_backup = READ_CBUS_REG(PERIPHS_PIN_MUX_1);

#ifdef CONFIG_AML_MESON_1
	//for MESON 1 @chip\m1\M1-Core-Pin-Mux.xls		
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6,((1<<1)|(1<<3)|(0x0F<<5)|(1<<16)|(1<<18)|(1<<19)));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_7,(1<<24));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_11,((1<<13)|(1<<15)));
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_1,( (1<<29) | (1<<27) | (1<<25) | (1<<23)));
	//CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6,0x7fff); by hisun 2011.07.01 PM17:32
	//check for multi define
	#if defined (CONFIG_AML_MESON_2) || defined(CONFIG_AML_MESON_3) || defined(CONFIG_AML_MESON_6)
		#error "Only one chip[CONFIG_AML_MESON_1/2/3/6] can be defined for SPI controller!"
	#endif
#else //else CONFIG_AML_MESON_1
	#ifdef CONFIG_AML_MESON_2
		//for MESON 2	
		CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,0x7fff);
		SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,( (1<<7) | (1<<8) | (1<<9) | (1<<10)|(1<<11)|(1<<12)));
		//check for multi define
		#if defined (CONFIG_AML_MESON_1) || defined(CONFIG_AML_MESON_3) || defined(CONFIG_AML_MESON_6)
			#error "Only one chip[CONFIG_AML_MESON_1/2/3/6] can be defined for SPI controller!"
		#endif
	#else //else for CONFIG_AML_MESON_2
		#ifdef CONFIG_AML_MESON_3
			//for MESON 3 @chip\AppNote-M3-CorePinMux.xlsx
			//BOOT_12-- SPI_NOR_D_A       -- NAND_ALE
			//BOOT_13-- SPI_NOR_Q_A       -- NAND_CLE
			//BOOT_14-- SPI_NOR_C_A       -- NAND_WEn_CLK
			//BOOT_17-- SPI_NOR_CS_n_A -- NAND_REn_WR
			CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,((1<<19)|(1<<20)|(1<<21)));
			CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<6)|(1<<7)|(1<<8)|(1<<9)));
			SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<0) | (1<<1) | (1<<2) | (1<<3)));
			//check for multi define
			#if defined (CONFIG_AML_MESON_1) || defined(CONFIG_AML_MESON_2) || defined(CONFIG_AML_MESON_6)
				#error "Only one chip[CONFIG_AML_MESON_1/2/3/6] can be defined for SPI controller!"
			#endif
		#else //else for CONFIG_AML_MESON_3

			#if defined(CONFIG_AML_MESON_6) || defined(CONFIG_AML_MESON_8)
				//for MESON 6 @AppNote-M6-CorePinMux.doc
				//BOOT_12-- SPI_NOR_D_A       -- NAND_ALE
				//BOOT_13-- SPI_NOR_Q_A       -- NAND_CLE
				//BOOT_14-- SPI_NOR_C_A       -- NAND_WEn_CLK
				//BOOT_17-- SPI_NOR_CS         -- NAND_REn_WR
				CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,((1<<19)|(1<<20)|(1<<21)));
				SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<0) | (1<<1) | (1<<2) | (1<<3)));
				//check for multi define
				#if defined (CONFIG_AML_MESON_1) || defined(CONFIG_AML_MESON_2) || defined(CONFIG_AML_MESON_3)
					#error "Only one chip[CONFIG_AML_MESON_1/2/3/6] can be defined for SPI controller!"
				#endif
			#else //else for CONFIG_AML_MESON_6
		
				#ifdef CONFIG_AML_MESON_A3
					//for MESON_A3
					// Disable NAND pin select just for safe or potential easy debug if system not switched off
					//            *P_PERIPHS_PIN_MUX_4 &= ~(0x3f<<14);
					//            
					//            // Enable SPI pin select
					//            *P_PERIPHS_PIN_MUX_6 |= (0x1<<28); // SPI CS
					//            *P_PERIPHS_PIN_MUX_5 |= (0x1f<<1); // other 5 SPI pins
					clrbits_le32(P_PERIPHS_PIN_MUX_4,0x3f<<14);
					setbits_le32(P_PERIPHS_PIN_MUX_6,1<<28);
					setbits_le32(P_PERIPHS_PIN_MUX_5,0x1f<<1);
					//check for multi define
					#if defined (CONFIG_AML_MESON_1)|| defined (CONFIG_AML_MESON_2) || defined(CONFIG_AML_MESON_3) || defined (CONFIG_AML_MESON_6)
						#error "Only one chip[CONFIG_AML_MESON_1/2/3/6/A2/A2/A1] can be defined for SPI controler!"
					#endif
				#else //else for CONFIG_AML_MESON_A3
					//Amlogic SPI controller need use pinmax setting
					#error "please define one chip[CONFIG_AML_MESON_1/2/3/6/A2/A2/A1] for SPI controller pinmax setting!"
				#endif //end for CONFIG_AML_MESON_A3	
			#endif //end for CONFIG_AML_MESON_6
		#endif //end for CONFIG_AML_MESON_3
	#endif //end for CONFIG_AML_MESON_2
#endif //end for CONFIG_AML_MESON_1

	return 0;
}

void spi_release_bus(struct spi_slave *slave)
{
	//why no A3?????
	debug("%s: bus:%i cs:%i\n", __func__, slave->bus, slave->cs);

#ifdef CONFIG_AML_MESON_1
	///for MESON 1 
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1,( (1<<29) | (1<<27) | (1<<25) | (1<<23)));
#else //else for CONFIG_AML_MESON_1
	#ifdef CONFIG_AML_MESON_2
		//for CONFIG_AML_MESON_2
		CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,( (1<<7) | (1<<8) | (1<<9) | (1<<10)|(1<<11)|(1<<12)));
	#else //else for CONFIG_AML_MESON_2
		#if defined(CONFIG_AML_MESON_3) || defined (CONFIG_AML_MESON_6)|| defined(CONFIG_AML_MESON_8)
			//for MESON 3 @chip\AppNote-M3-CorePinMux.xlsx
			//for MESON 6 @AppNote-M6-CorePinMux.doc
			CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<0)|(1<<1)|(1<<2)|(1<<3)));
		#else //else for CONFIG_AML_MESON_3
		//Amlogic SPI controller need use pinmax setting
		#error "please define CONFIG_AML_MESON_1 or others for SPI controller initialize!"
		#endif //end for CONFIG_AML_MESON_3
	#endif //end for CONFIG_AML_MESON_2
#endif //end for CONFIG_AML_MESON_1

	//WRITE_CBUS_REG(PERIPHS_PIN_MUX_1,g_u32_PERIPHS_PIN_MUX_1_backup);
}

//Only for Amlogic SPI controller
//note flag for cmd adr status data trans
//bitlen is byte*8  
int spi_xfer(struct spi_slave *slave, unsigned int bitlen,
			const void *dout, void *din, unsigned long flags)
{
	struct aml_spi_slave *as = to_aml_spi(slave);
	u32 len;
	u32 temp_len;
	u8  temp_data[4];
	u8  *buf = temp_data;
	int	ret = 0;
	const u8 *txp = (u8 *)dout;
	u8		 *rxp = (u8 *)din;
	u32		 value;
	int i,j;
	
	ret = 0;

	if (bitlen == 0)/* Finish any previously submitted transfers */
		goto out;    

	if (bitlen % 8){/* Errors always terminate an ongoing transfer*/
		flags |= SPI_XFER_END;
		goto out;
	}

	len = bitlen / 8; //convert to BYTE counter
	
	if (flags & SPI_XFER_BEGIN)
		spi_cs_activate(slave);

	//Set Address register of SPI controller
	if(flags&SPI_XFER_ADR){
		writel(*((u32*)txp), P_SPI_FLASH_ADDR);
		goto out;	
	}
	
	//Send command to device through SPI FLASH command register
	if(flags&SPI_XFER_CMD){

		if(*((u32*)dout)==(1<<SPI_FLASH_RDID)){
			/*only for RDID, clear the cache for a fresh load*/
			writel(0, P_SPI_FLASH_C0);			
		}
    	writel(*((u32*)txp), P_SPI_FLASH_CMD);
		while(readl(P_SPI_FLASH_CMD)!=0);
		goto out;
	}

	//Write data to SPI data cache for transfer
	//Then SPI controller will transfer them to SPI device with WREN(Writer enable) & PP(Page program)
	if((txp)&&(flags&SPI_XFER_WRITECACHE)){
		for( j=0;j<len;j+=4){
			writel(*(u32*)(txp+j), P_SPI_FLASH_C0+j);
		}		
		goto out;
	}	

	//for input to host
	//following code will use rxp
	if(!rxp)
		goto out;

	//Read status register
	if(flags&SPI_XFER_STATUS){	/*FIXME WRSTAUS	*/	
		
		value=readl(P_SPI_FLASH_STATUS)&0xffff;
		*rxp=value&0xff;
		*(rxp+1)=(value>>8)&0xff;
		goto out;
	}

	//Read vender & chip ID 
	if(flags&SPI_XFER_ID){		/*FIXME EON*/
	
		value=readl(P_SPI_FLASH_C0)&0xffffff;
		*rxp=value&0xff;
		*(rxp+1)=(value>>8)&0xff;
		*(rxp+2)=(value>>16)&0xff;
		goto out;
	}	
	
	//Load data from cache, SPI controller will auto send read read flash command and store data to address as->adr_base
	if(flags&SPI_XFER_COPY){
		SET_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); /*for AHB data bus request*/
	  	memcpy((unsigned char *)(rxp),(unsigned char *)((as->adr_base)+(*(u32*)txp)),bitlen/8);
		CLEAR_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); /*release AHB bus*/
		//printf("Hisun: XFER_COPY -> 0x%08X Bytes from 0x%08X to 0x%08X\n",bitlen/8,((as->adr_base)+(*(u32*)txp)),(rxp));
		goto out;
	}	
	
	//Load from SPI controller data cache
	if(flags&SPI_XFER_READCACHE){
		temp_len = len/4;
		for( i=0;i<temp_len*4;i+=4){		
			*(u32 *)(rxp+i)=readl(P_SPI_FLASH_C0+i);
		}	
		if(len%4){
			temp_len = len%4;
			*(u32 *)buf = readl(P_SPI_FLASH_C0+i);
			for(j=0;j<temp_len;j++){
				*(u8 *)(rxp+i+j)=*(buf+j);
			}
		}
		goto out;
	}	
	//note: from here to label "out:" any code without rxp usage  
	//      but rxp is not NULL will be pass
	//.....
		
out:
	if (flags & SPI_XFER_END) {
		
		spi_cs_deactivate(slave);
	}
	
	SET_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); /*for AHB data bus request*/
	return 0;
}

//from trunk\spi_flash_aml.c
static int spi_flash_addr_write(struct spi_slave *spi,  u32 addr){

	unsigned flags = SPI_XFER_END;
	u32 nAddress = addr;
	int ret;

	flags |= SPI_XFER_ADR;
	
	ret = spi_xfer(spi,4*8,&nAddress,NULL,flags);
	
	if(ret){	
		debug("SF: Faild to send addr(%zu bytes): %d\n",4,ret);
	}
	return ret;
}

int spi_flash_erase_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size)
{
	struct spi_slave * slave=flash->spi;
	size_t actual;	
	unsigned var;
	int nReturn = -1;		

	if (offset % sector_size || len % sector_size) {
		printf("SF: Erase offset/length not multiple of sector size!\n");
		return nReturn;
	}
	//close AHB bus before any APB bus operation
	CLEAR_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); 	

#ifdef SPI_WRITE_PROTECT
	spi_disable_write_protect();
#endif

	for (actual = 0; actual < len; actual+=sector_size) {
		
		debug("Erase:%x\n",actual);
			
		var=(offset+actual) & 0xffffff;
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
		if(flash->secure_protect){
			if((var >=flash->securestorage_info->start_pos)&&(var < flash->securestorage_info->end_pos)){
				//printf("addr: 0x%x \n",var);
				continue;
			}
		}
#endif
		spi_flash_addr_write(slave,var);
	
		//Trigger write enable command
		var=1<<SPI_FLASH_WREN;
		spi_flash_cmd(slave,var,NULL,0);	
		
		//Trigger sector erase command
		var=1<<SPI_FLASH_SE;		
		spi_flash_cmd(slave,var,NULL,0);	

		//debug for hangup
		//printf("PIN_MAX_REG0 = 0x%08X\n",READ_CBUS_REG(PERIPHS_PIN_MUX_1));

		nReturn=1;
  		while ( (nReturn&1)==1 ) { 	
			var=1<<SPI_FLASH_RDSR;
			spi_flash_cmd(slave,var,&nReturn,2);		//2 byte status				
  		}	
	}

	//reopen AHB bus after any APB bus operation
	SET_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); 

#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
	void secure_storage_spi_disable(void);
	secure_storage_spi_disable();
#endif
   return nReturn;	
}

//for CONFIG_SPI_FLASH_SPANSION no SE(0x20) command
//use Block erase 0xD8 command
int spi_flash_erase_be_amlogic(struct spi_flash *flash,u32 offset, size_t len, u32 sector_size)
{
	struct spi_slave * slave=flash->spi;
	size_t actual;	
	unsigned var;
	int nReturn = -1;		

	if (offset % sector_size || len % sector_size) {
		printf("SF: Erase offset/length not multiple of sector size!\n");
		return nReturn;
	}

	//close AHB bus before any APB bus operation
	CLEAR_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); 	

#ifdef SPI_WRITE_PROTECT
	spi_disable_write_protect();
#endif

	for (actual = 0; actual < len; actual+=sector_size) {
		
		debug("Erase:%x\n",actual);
			
		var=(offset+actual) & 0xffffff;
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
		if(flash->secure_protect){
			if((var >=flash->securestorage_info->start_pos)&&(var < flash->securestorage_info->end_pos)){
				//printf("addr: 0x%x \n",var);
				continue;
			}
		}
#endif
		spi_flash_addr_write(slave,var);
	
		//Trigger write enable command
		var=1<<SPI_FLASH_WREN;
		spi_flash_cmd(slave,var,NULL,0);	
		
		//Trigger sector erase command
		//for CONFIG_SPI_FLASH_SPANSION no SE(0x20) command	
		//use BE(0xD8) command
		var=1<<SPI_FLASH_BE;		
		
		spi_flash_cmd(slave,var,NULL,0);	

		//debug for hangup
		//printf("PIN_MAX_REG0 = 0x%08X\n",READ_CBUS_REG(PERIPHS_PIN_MUX_1));

		nReturn=1;
  		while ( (nReturn&1)==1 ) { 	
			var=1<<SPI_FLASH_RDSR;
			spi_flash_cmd(slave,var,&nReturn,2);		//2 byte status	
  		}	
	}

	//reopen AHB bus after any APB bus operation
	SET_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB); 
	
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
	void secure_storage_spi_disable(void);
	secure_storage_spi_disable();
#endif
   return nReturn;	
}

int spi_flash_write_amlogic(struct spi_flash *flash,u32 offset, size_t len, const void *buf){
	
	struct spi_slave *spi = flash->spi;
	u32 temp_addr   = offset;
    int temp_length = len;	
	unsigned flags;
	int nReturn = 0;

	if(!len)
		return nReturn;

	nReturn = 1;

#ifdef SPI_WRITE_PROTECT
	spi_disable_write_protect();
#endif


	//clean data cache
	//dcache_clean_range((u32)buf, len);
	dcache_flush();

	//close AHB bus before any APB bus operation
	CLEAR_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB);  	

	while(temp_length>0){
		
		flags=(temp_addr & 0xffffff)|( (temp_length>=32?32:temp_length) << SPI_FLASH_BYTES_LEN);
	#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
		if(flash->secure_protect){
			if((temp_addr>=flash->securestorage_info->start_pos) &&(temp_addr<flash->securestorage_info->end_pos)){
				temp_addr   += (temp_length>=32?32:temp_length);
				buf			+= (temp_length>=32?32:temp_length);
				temp_length -= (temp_length>=32?32:temp_length);	
				//printf("prohibit write,%s:%d\n",__func__,__LINE__);	 
				continue;
			}
		}
	#endif

		spi_flash_addr_write(spi, flags);
		
		flags=SPI_XFER_WRITECACHE;

		spi_xfer(spi,(temp_length>=32?32:temp_length)*8,buf,NULL,flags);	

		
		flags=(1<<SPI_FLASH_WREN);
		spi_flash_cmd(spi,flags,NULL,0);
		
		flags=(1<<SPI_FLASH_PP);
		spi_flash_cmd(spi,flags,NULL,0);
		
		
		 nReturn=1;
   		 while ( (nReturn&1) == 1 ){
      
			flags=1<<SPI_FLASH_RDSR;		
			spi_flash_cmd(spi,flags,&nReturn,2);		//2 byte status			
    	}	 	
		
        temp_addr   += (temp_length>=32?32:temp_length);
		buf			+= (temp_length>=32?32:temp_length);
		temp_length -= (temp_length>=32?32:temp_length);		 
	}	

	//reopen AHB bus after any APB bus operation
	SET_CBUS_REG_MASK(SPI_FLASH_CTRL, 1<<SPI_ENABLE_AHB);

#ifdef SPI_WRITE_PROTECT
    spi_enable_write_protect();
#endif

	//cache refresh
	dcache_flush();
	
	return nReturn;
}

int spi_flash_read_amlogic(struct spi_flash *flash,u32 offset, size_t len, void *buf){

	struct spi_slave *spi = flash->spi;
	u32 temp_addr = offset;
    int temp_length = len;	
	unsigned flags;	

	if(!len)
		return 0;	
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
	if(flash->secure_protect){
		if(((offset+len)>flash->securestorage_info->start_pos) &&((offset+len)<=flash->securestorage_info->end_pos)){
				//printf("prohibit read,%s:%d\n",__func__,__LINE__);
			return -1;
		}
		else if(((offset+len)>flash->securestorage_info->end_pos)
			&&(offset>=flash->securestorage_info->start_pos)
			&&(offset<flash->securestorage_info->end_pos)){
				//printf("prohibit read,%s:%d\n",__func__,__LINE__);
			return -1;
		}
		else if(((offset+len)>flash->securestorage_info->end_pos) 
			&&(offset < flash->securestorage_info->start_pos)
			&&(len>(flash->securestorage_info->start_pos-offset))){
				//printf("prohibit read,%s:%d\n",__func__,__LINE__);
			return -1;
		}
	}
#endif
	//invalid data cache
	//dcache_invalid_range((u32)buf,len);
	dcache_flush();

		
    /* 0x400000 ~ 0x7fffff */
    if(temp_addr + len > 0x400000 && temp_addr < 0x400000){
		//Read data from SPI controller from temp_addr to 0x3fffff
		//From 0x400000 to (temp_addr+len) need to set address and
		//load from cache with 32Bytes per package
		flags = SPI_XFER_END|SPI_XFER_COPY;
		spi_xfer(spi,(0x400000-temp_addr)*8,&temp_addr,buf,flags);
		buf += (0x400000-temp_addr);
		temp_length = len - (0x400000-temp_addr);
		temp_addr = 0x400000;
    }
    /* 0x000000 ~ 0x3fffff */
	else if(temp_addr < 0x400000){
	   flags=SPI_XFER_END|SPI_XFER_COPY;
       spi_xfer(spi,temp_length*8,&temp_addr,buf,flags);	  
	   return 0;
    }

	while(temp_length>0){
		//(byte counter << 24| 24bit device address) for SPI address register		
		flags=(temp_addr & 0xffffff)|( (temp_length>=32?32:temp_length) << SPI_FLASH_BYTES_LEN);	
		spi_flash_addr_write(spi, flags);	
		
		//trigger SPI flash read command
		flags=(1<<SPI_FLASH_READ);		
		spi_flash_cmd(spi,flags,NULL,0);
		
		//load data from SPI controller 32bytes data cache 
		flags=SPI_XFER_READCACHE;
		spi_xfer(spi,(temp_length>=32?32:temp_length)*8,NULL,buf,flags);	

		//adjust address, buffer & length
        temp_addr   += (temp_length>=32?32:temp_length);
		buf			+= (temp_length>=32?32:temp_length);	
		temp_length -= (temp_length>=32?32:temp_length);			
	}		

	//cache refresh
	dcache_flush();	
	return 0;	
}

void spi_flash_free(struct spi_flash *flash)
{
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
	spi_securestorage_free();
#endif
	spi_free_slave(flash->spi);
	free(flash);
}


/*
 * The following table holds all device probe functions
 *
 * shift:  number of continuation bytes before the ID
 * idcode: the expected IDCODE or 0xff for non JEDEC devices
 * probe:  the function to call
 *
 * Non JEDEC devices should be ordered in the table such that
 * the probe functions with best detection algorithms come first.
 *
 * Several matching entries are permitted, they will be tried
 * in sequence until a probe function returns non NULL.
 *
 * IDCODE_CONT_LEN may be redefined if a device needs to declare a
 * larger "shift" value.  IDCODE_PART_LEN generally shouldn't be
 * changed.  This is the max number of bytes probe functions may
 * examine when looking up part-specific identification info.
 *
 * Probe functions will be given the idcode buffer starting at their
 * manu id byte (the "idcode" in the table below).  In other words,
 * all of the continuation bytes will be skipped (the "shift" below).
 */
#define IDCODE_CONT_LEN 0
#define IDCODE_PART_LEN 5
static const struct {
	const u8 shift;
	const u8 idcode;
	struct spi_flash *(*probe) (struct spi_slave *spi, u8 *idcode);
} g_flashes[] = {
	/* Keep it sorted by define name */
#ifdef CONFIG_SPI_FLASH_ATMEL
	{ 0, 0x1f, spi_flash_probe_atmel, },
#endif
#ifdef CONFIG_SPI_FLASH_EON
	{ 0, 0x1c, spi_flash_probe_eon, },
#endif
#ifdef CONFIG_SPI_FLASH_MACRONIX
	{ 0, 0xc2, spi_flash_probe_macronix, },
#endif
#ifdef CONFIG_SPI_FLASH_SPANSION
	{ 0, 0x01, spi_flash_probe_spansion, },
#endif
#ifdef CONFIG_SPI_FLASH_SST
	{ 0, 0xbf, spi_flash_probe_sst, },
#endif
#ifdef CONFIG_SPI_FLASH_STMICRO
	{ 0, 0x20, spi_flash_probe_stmicro, },
#endif
#ifdef CONFIG_SPI_FLASH_WINBOND
	{ 0, 0xef, spi_flash_probe_winbond, },
#endif
#ifdef CONFIG_SPI_FLASH_GIGADEVICE
	{ 0, 0xc8, spi_flash_probe_gigadevice, },
#endif
#ifdef CONFIG_SPI_FLASH_PMDEVICE
	{ 0, 0x7f, spi_flash_probe_pmdevice, },
#endif
#ifdef CONFIG_SPI_FRAM_RAMTRON
	{ 6, 0xc2, spi_fram_probe_ramtron, },
# undef IDCODE_CONT_LEN
# define IDCODE_CONT_LEN 6
#endif
	/* Keep it sorted by best detection */
#ifdef CONFIG_SPI_FLASH_STMICRO
	{ 0, 0xff, spi_flash_probe_stmicro, },
#endif
#ifdef CONFIG_SPI_FRAM_RAMTRON_NON_JEDEC
	{ 0, 0xff, spi_fram_probe_ramtron, },
#endif
};
#define IDCODE_LEN (IDCODE_CONT_LEN + IDCODE_PART_LEN)

struct spi_flash *spi_flash_probe(unsigned int bus, unsigned int cs,
		unsigned int max_hz, unsigned int spi_mode)
{
	struct spi_slave *spi;
	struct spi_flash *flash = NULL;
	int ret, i, shift;
	u8 idcode[IDCODE_LEN], *idp;

	spi = spi_setup_slave(bus, cs, max_hz, spi_mode);
	if (!spi) {
		printf("SF: Failed to set up slave\n");
		return NULL;
	}

	ret = spi_claim_bus(spi);
	if (ret) {
		debug("SF: Failed to claim SPI bus: %d\n", ret);
		goto err_claim_bus;
	}

	/* Read the ID codes */
	memset(idcode,0,sizeof(idcode));

	ret = spi_flash_cmd(spi, 1<<SPI_FLASH_RDID, idcode, sizeof(idcode));

	if (ret)
		goto err_read_id;

	/* count the number of continuation bytes */
	for (shift = 0, idp = idcode;
	     shift < IDCODE_CONT_LEN && *idp == 0x7f;
	     ++shift, ++idp)
		continue;

	/* search the table for matches in shift and id */
	for (i = 0; i < ARRAY_SIZE(g_flashes); ++i)
		if (g_flashes[i].shift == shift && g_flashes[i].idcode == *idp) {
			/* we have a match, call probe */
			flash = g_flashes[i].probe(spi, idp);
			if (flash)
				break;
		}

	if (!flash) {
		printf("SF: Unsupported manufacturer %02x\n", *idp);
		goto err_manufacturer_probe;
	}
	
#ifdef CONFIG_SPI_NOR_SECURE_STORAGE
	if(spi_securestorage_probe(flash)){
		printf("spi secure storage probe fail\n");
	}
#endif
#ifdef SPI_WRITE_PROTECT
        if(spi_check_write_protect())
             printf("\nSPI NOR Flash have write protect!!!\n");
        else{
             printf("\nSPI NOR Flash NO write protect!!!, So I will enable it...\n");
             spi_enable_write_protect();
            }
#endif

	spi_release_bus(spi);

	return flash;

err_manufacturer_probe:
err_read_id:
	spi_release_bus(spi);
err_claim_bus:
	spi_free_slave(spi);
	return NULL;
}
