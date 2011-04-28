/*
 * Copyright 2000-2009
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <command.h>
#include <asm/arch/io.h>
#include <asm/arch/reg_addr.h>
#define         MODE_DELAYED_WAKE       0
#define         MODE_IRQ_DELAYED_WAKE   1
#define         MODE_IRQ_ONLY_WAKE      2
#define         MODE_CLK_MUX_CHANGE     3
#define P_HHI_SYS_CPU_AUTO_CLK0 (0xc1100000+(HHI_SYS_CPU_AUTO_CLK0<<2))
#define P_HHI_SYS_CPU_AUTO_CLK1 (0xc1100000+(HHI_SYS_CPU_AUTO_CLK1<<2))
#define P_GLOBAL_INTR_DISABLE            (0xc1100000+(0x2624<<2))            
static void    auto_clk_gating_setup(
unsigned long   sleep_dly_tb,
unsigned long   mode,
unsigned long   clear_fiq,
unsigned long   clear_irq,
unsigned long   start_delay,
unsigned long   clock_gate_dly,
unsigned long   sleep_time,
unsigned long   enable_delay,
unsigned long   clk_mux_dly,
unsigned long   clk_mux_dly_tb,
unsigned long   clk_mux_sel)
{
    writel(
       (sleep_dly_tb << 24)    |   // sleep timebase
                                    (sleep_time << 16)      |   // sleep time
									(clk_mux_sel << 6)      |   // clock mux select
                                    (clear_irq << 5)        |   // clear IRQ
                                    (clear_fiq << 4)        |   // clear FIQ
                                    (mode << 2),P_HHI_SYS_CPU_AUTO_CLK0);                // mode

    writel(  (clk_mux_dly_tb << 23)  |   // clock mux delay timebase
	                                (0 << 20)               |   // start delay timebase
	                                (clk_mux_dly << 16)     |   // clock mux delay
                                    (enable_delay << 12)    |   // enable delay
                                    (clock_gate_dly << 8)   |   // clock gate delay
                                    (start_delay << 0),P_HHI_SYS_CPU_AUTO_CLK1) ;         // start delay
                    
}
// ----------------------------------------------------
static void    auto_clk_gating_enable( unsigned long enable )
{
    // Enable the auto module
    clrsetbits_le32(P_HHI_SYS_CPU_AUTO_CLK0,1,enable);
    
}
// ----------------------------------------------------
static void    auto_clk_gating_start( )
{
    // Trigger the auto clock hardware
    setbits_le32(P_HHI_SYS_CPU_AUTO_CLK0,2);
    clrbits_le32(P_HHI_SYS_CPU_AUTO_CLK0,2);
}
int do_axi(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int r;
    static unsigned long clk_mux[]={0,0,1,0,2};
	r = 0;
	if (argc > 1)
    {
		r = simple_strtoul(argv[1], NULL, 10);
    };
    if(r>=2&&r<=4){
///        	 (*P_ISA_TIMER_MUX) = ((*P_ISA_TIMER_MUX) & ~(0xF << 0)) | (0 << 0);
    unsigned count=get_utimer(0);
            memcpy((void *)(0x82000000),(void *)(0x80000000),0x400000);
            
            printf("time offset %d \n",get_utimer(count));
    clrbits_le32(P_ISA_TIMER_MUX,0xf);
    // Set a long timer interrupt (not quite as long as the internal auto-clock delay)
    // since we are going to use one of these to wake up the ARC
    writel(1050,P_ISA_TIMERA);///delay 1050us
    writel(1000,P_ISA_TIMERB);///delay 1050us
    // Setup a TimerA interrupt 
    writel((1 << 11) | (1 << 10) | (1<<9),P_SYS_CPU_0_IRQ_IN0_INTR_STAT);// clear pending interrupts
    setbits_le32(P_SYS_CPU_0_IRQ_IN0_INTR_MASK,(1 << 11) | (1 << 10) );///|(1 << 9)
    

    
        auto_clk_gating_setup(  0,                      // select 1uS timebase
					                MODE_CLK_MUX_CHANGE,    // Set the mode 
					                1,                      // clear the FIQ global mask ////1
					                1,                      // don't clear the IRQ global mask
					                7,                      // 7us start delay
					                0,                      // 1uS clock gate delay
					                0,                      // Set the delay wakeup time (500us)
					                0,                      // 1uS enable delay 
					                0,                      //clock mux delay
					                0,                      //clock mux delay timebase   
					                clk_mux[r]);            //clock mux select  1:clk_div2


			// Set Global Interrupt disables in the isa module
            setbits_le32(P_GLOBAL_INTR_DISABLE,(1 << 1) | (1 << 0));
			//~ (*P_GLOBAL_INTR_DISABLE) |= ;

			// Enable the auto module
			auto_clk_gating_enable(1);
			// Trigger the auto clock hardware
			auto_clk_gating_start();

			printf("Into sleep\n");
			// _sleep();                 // ARC: Put the SYS_CPU into sleep mode (ARC)
            //~ asm volatile("cpsie ifa");
			asm volatile(" WFI");               // A9: Put the SYS_CPU into sleep mode (A9)
			//~ asm volatile("cpsid ifa");
            printf("Out of sleep\n");

			if( ((readl(P_GLOBAL_INTR_DISABLE)) & (0x3 << 0)) != 0x00 ) { 
                printf("fail %x\n",(readl(P_GLOBAL_INTR_DISABLE))); 
            }else{
                setbits_le32(P_GLOBAL_INTR_DISABLE,(1 << 1) | (1 << 0));
            }
            clrbits_le32(P_SYS_CPU_0_IRQ_IN0_INTR_MASK,(1 << 11) | (1 << 10) |(1 << 9));
            writel((1 << 11) | (1 << 10) | (1<<9),P_SYS_CPU_0_IRQ_IN0_INTR_STAT);// clear pending interrupts
            
            count=get_utimer(0);
            memcpy((void *)(0x82000000),(void *)(0x80000000),0x400000);
            
            printf("time offset %d \n",get_utimer(count));
    }
    printf("P_HHI_SYS_CPU_AUTO_CLK0=%x\tP_HHI_SYS_CPU_AUTO_CLK1=%x\n",readl(P_HHI_SYS_CPU_AUTO_CLK0),readl(P_HHI_SYS_CPU_AUTO_CLK1));
    

	return 0;
}

U_BOOT_CMD(
	axi,	2,	1,	do_axi,
	"axi [2|3|4]",
	""
);
