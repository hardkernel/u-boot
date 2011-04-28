#include <common.h>
#include <command.h>
#include <asm/arch/register.h>
#include <asm/arch/reg_addr.h>
#include <asm/arch-m6/timer.h>




//#define POWER_KEYCODE 0x1fe718e
//#define POWER_FACTORY 0x86

#define REMOTE_STATUS_WAIT      0
#define REMOTE_STATUS_INTERVAL  1
#define REMOTE_STATUS_DATA      2
#define REMOTE_STATUS_FACTORY   3
#define REMOTE_STATUS_LEADER    4

#define REMOTE_STATUS_NUM       2

#define IO_CBUS_PHY_BASE                0xc1100000

unsigned int time_window[10];
unsigned int state;
unsigned int keycode;
unsigned int frame_bit_num = 32;
unsigned int bit_num = 1;
int bit;



static unsigned timerE_get()
{
    unsigned addr;
    addr=IO_CBUS_PHY_BASE+(ISA_TIMERE<<2);

    return (readl(addr)&0xffffff);
}

void init_custom_trigger(void)
{
    printf("ir init\n");
    
    int val = readl(P_AO_RTI_PIN_MUX_REG);
    writel((val  | (1<<0)), P_AO_RTI_PIN_MUX_REG);
    writel(0x8148, P_AO_IR_DEC_REG1);//use 1us
    writel(0xfa004, P_AO_IR_DEC_REG0);//5us
    time_window[0] = 0xa78;//1596/5  leader 13f             9+4.5
    time_window[1] = 0xaa0;//1596/5  leader
    time_window[2] = 0xcc;//1176/5  00      Bit_0 Min
    time_window[3] = 0xf6;//1420/5  01      Bit_0 Max
    time_window[4] = 0x1ac;//1764/5  10
    time_window[5] = 0x1d4;//2088/5   11
    
    
//    time_window[6] = 0x150;//1176/5  00
//    time_window[7] = 0x162;//1420/5  01
//    time_window[8] = 0x190;//1764/5  10
//    time_window[9] = 0x200;//2088/5   11
    state = REMOTE_STATUS_WAIT;
    // enable interrupt
    writel(readl(P_AO_IRQ_MASK_FIQ_SEL)|(1<<4), P_AO_IRQ_MASK_FIQ_SEL);
}

void ir_release(void)
{
    int val = 0;
    
    val = readl(P_AO_RTI_PIN_MUX_REG);
    writel((val  | (0<<0)), P_AO_RTI_PIN_MUX_REG);
    writel(readl(P_AO_IRQ_MASK_FIQ_SEL)|(1<<20), P_AO_IRQ_MASK_FIQ_SEL);
    writel(0, P_AO_IRQ_MASK_FIQ_SEL);
}



int read_key(void)
{
    unsigned int pluse;
    unsigned int i;
    // wait interrupt
    if(!(readl(P_AO_IRQ_STAT_CLR)&(1<<4)))
    {
        return 0;
    }
    pluse = (readl(P_AO_IR_DEC_REG1)>>16)&0x1fff;
    if(pluse > 0xd80 ) { // null
        state = REMOTE_STATUS_WAIT;
    }
    
    switch (state) {
        case REMOTE_STATUS_LEADER:
            if((pluse < time_window[1])&&(pluse > time_window[0]))
            {
                state = REMOTE_STATUS_DATA;
            }
            return 0;
        case REMOTE_STATUS_DATA:
            for(i=0; i<REMOTE_STATUS_NUM; i++) {
                if((pluse <= time_window[2*i+3])&&(pluse > time_window[2*i+2]))
                {
                    keycode |= i<<bit;
                    bit -= bit_num;
                    break;
                }
            }
            if(bit <0)
                bit = 0;
            if(i == REMOTE_STATUS_NUM)
                bit = 0;
            if(bit == 0) {
                state = REMOTE_STATUS_WAIT;
            }
            else
                return 0;
            break;
        case REMOTE_STATUS_WAIT:
        default:
             keycode = 0;
             bit = frame_bit_num;
             state = REMOTE_STATUS_LEADER;
             return 0;
    }
    printf("keycode = %x-- bit = %d\n",keycode,bit);
    return keycode;
}

static int do_irkey(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int key = 0;
    int time_out = 0;
    unsigned long time_base = 0;
    char *endp;

    if(argc < 3){
        goto usage;
    }

	key = simple_strtoul(argv[1], &endp, 0);
	if (*argv[1] == 0 || *endp != 0)
		goto usage;

	time_out = simple_strtoul(argv[2], &endp, 0);
	if (*argv[2] == 0 || *endp != 0)
		goto usage;	

    init_custom_trigger();    

    time_base = timerE_get();
    while(TIMERE_SUB(timerE_get(), time_base) < time_out)
    {
    	if(read_key() == key)
    	{
            printf("ok\n");
            ir_release();
            return 0;
        }
    }
	ir_release();
    return -1;
usage:
    puts("Usage: irkey key_value time_value \n");    
    return -1;
}

U_BOOT_CMD(
irkey, 3, 0, do_irkey,
"irkey key_value time_value",
"             - irkey key_value time_value\n"
);

