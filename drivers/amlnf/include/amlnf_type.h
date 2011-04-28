
#include "amlnf_cfg.h"

#ifdef AML_NAND_UBOOT
#include <common.h>
#include <environment.h>
#include <asm/io.h>
#include <malloc.h>
#include <linux/err.h>
#include <asm/cache.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/reboot.h>
#include <asm/arch/clock.h>
#include <linux/list.h>
#include <asm/sizes.h>
#include <amlogic/securitykey.h>
#else
#include <linux/module.h>
#include <linux/types.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/ioport.h>
#include <linux/platform_device.h>
#include <linux/delay.h>
#include <linux/dma-mapping.h>
#include <linux/clk.h>
#include <linux/slab.h>
#include<linux/delay.h>
#include <linux/cdev.h>
#include <linux/sched.h>
#include <linux/earlysuspend.h>
#include <mach/pinmux.h>
#include <linux/err.h>
#include <linux/io.h>
#include <linux/bitops.h>
#include <linux/crc32.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include <linux/reboot.h>
#include <asm/div64.h>	
#include <mach/clock.h>
#include <linux/list.h>
#include <asm/sizes.h>
#include <mach/am_regs.h>
#include <linux/kthread.h>
#include <linux/kmod.h>
#include <linux/blkdev.h>
#include <linux/blkpg.h>
#include <linux/freezer.h>
#include <linux/spinlock.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/mutex.h>


#endif


//#define aml_nftl_malloc(n)		kzalloc(n, GFP_KERNEL)
//#define aml_nftl_free			kfree


#ifdef AML_NAND_DBG
#define aml_nand_dbg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
				  __func__, __LINE__, ##__VA_ARGS__)

#define aml_nand_msg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
				  __func__, __LINE__, ##__VA_ARGS__)				  
#else
#define aml_nand_dbg(fmt, ...)
#define aml_nand_msg(fmt, ...) printk( fmt "\n",  ##__VA_ARGS__)
#endif

//typedef unsigned char         uchar;
typedef unsigned short        uint16;
typedef unsigned long         uint32;
typedef unsigned long long	uint64;
typedef long                  sint32;
typedef long long              sint64;
typedef short            	  sint16;



