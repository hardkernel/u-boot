/*
* (C) Copyright 2014 Hardkernel Co,.Ltd
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
#include <asm/arch/reg_addr.h>

#ifdef CONFIG_IR_REMOTE
//#define DEBUG_IR

#define msleep(a)       udelay(a * 1000)

#define IR_POWER_KEY            0xe51afb04
#define IR_MENU_KEY             0xac53fb04
#define IR_POWER_KEY_MASK       0xffffffff

#define CONFIG_END              0xffffffff

typedef struct reg_remote {
        int reg;
        unsigned int val;
} reg_remote;

typedef enum {
        DECODEMODE_NEC = 0,
        DECODEMODE_DUOKAN = 1,
        DECODEMODE_RCMM,
        DECODEMODE_SONYSIRC,
        DECODEMODE_SKIPLEADER,
        DECODEMODE_MITSUBISHI,
        DECODEMODE_THOMSON,
        DECODEMODE_TOSHIBA,
        DECODEMODE_RC5,
        DECODEMODE_RC6,
        DECODEMODE_COMCAST,
        DECODEMODE_SANYO,
        DECODEMODE_MAX
} ddmode_t;

/*
   bit0 = 1120/31.25 = 36
   bit1 = 2240 /31.25 = 72
   2500 /31.25  = 80
   ldr_idle = 4500  /31.25 =144
   ldr active = 9000 /31.25 = 288
   */
static const reg_remote RDECODEMODE_NEC[] = {
        {P_AO_MF_IR_DEC_LDR_ACTIVE,477<<16 |400<<0},
        {P_AO_MF_IR_DEC_LDR_IDLE, 248<<16 | 202<<0},
        {P_AO_MF_IR_DEC_LDR_REPEAT,130<<16 |110<<0},
        {P_AO_MF_IR_DEC_BIT_0,60<<16|48<<0 },
        {P_AO_MF_IR_DEC_REG0,3<<28|(0xFA0<<12)|0x13},
        {P_AO_MF_IR_DEC_STATUS,(111<<20)|(100<<10)},
        {P_AO_MF_IR_DEC_REG1,0x9f40},
        {P_AO_MF_IR_DEC_REG2,0x0},
        {P_AO_MF_IR_DEC_DURATN2,0},
        {P_AO_MF_IR_DEC_DURATN3,0},
        {CONFIG_END,            0 }
};

static const reg_remote RDECODEMODE_DUOKAN[] =
{
        {P_AO_MF_IR_DEC_LDR_ACTIVE,477<<16 | 400<<0}, // NEC leader 9500us,max 477: (477* timebase = 31.25) = 9540 ;min 400 = 8000us
        {P_AO_MF_IR_DEC_LDR_IDLE, 248<<16 | 202<<0}, // leader idle
        {P_AO_MF_IR_DEC_LDR_REPEAT,130<<16|110<<0},  // leader repeat
        {P_AO_MF_IR_DEC_BIT_0,60<<16|48<<0 }, // logic '0' or '00'
        {P_AO_MF_IR_DEC_REG0,3<<28|(0xFA0<<12)|0x13},  // sys clock boby time.base time = 20 body frame 108ms
        {P_AO_MF_IR_DEC_STATUS,(111<<20)|(100<<10)},  // logic '1' or '01'
        {P_AO_MF_IR_DEC_REG1,0x9f40}, // boby long decode (8-13)
        {P_AO_MF_IR_DEC_REG2,0x0},  // hard decode mode
        {P_AO_MF_IR_DEC_DURATN2,0},
        {P_AO_MF_IR_DEC_DURATN3,0},
        {CONFIG_END,            0      }
};

static const reg_remote *remoteregsTab[] =
{
        RDECODEMODE_NEC,
        RDECODEMODE_DUOKAN,
};

void setremotereg(const reg_remote *r)
{
        writel(r->val, r->reg);
#ifdef DEBUG_IR
        printf(">>>write[0x%x] = 0x%x\n",r->reg, r->val);
        msleep(50);
        printf("    read<<<<<< = 0x%x\n",readl(r->reg));
#endif
}

int     set_remote_mode(int mode)
{
        const reg_remote *reg;

        reg = remoteregsTab[mode];
        while (CONFIG_END != reg->reg) {
                setremotereg(reg++);
        }

        return 0;
}

void    board_ir_init(void)
{
        unsigned int status,data_value;
        int val = readl(P_AO_RTI_PIN_MUX_REG);

        writel((val | (1 << 0)), P_AO_RTI_PIN_MUX_REG);
        set_remote_mode(DECODEMODE_NEC);
        status = readl(P_AO_MF_IR_DEC_STATUS);
        data_value = readl(P_AO_MF_IR_DEC_FRAME);

        printf("IR init is done!\n");
}

int     checkRecoveryKey(void)
{
        unsigned int keycode;
        int i;

        for (i = 0; i < 1000000; i++) {
                if ((P_AO_MF_IR_DEC_STATUS >> 3) & 0x1) {
                        keycode = readl(P_AO_MF_IR_DEC_FRAME);
                }

                if (keycode == IR_MENU_KEY) {
                        return 1;
                }
        }

        return 0;
}

int     do_irdetect(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#ifdef DEBUG_IR
        int j;
        for (j = 0; j < 20; j++) {
                if (checkRecoveryKey()) {
                        printf("Detect Recovery Key ...\n");
                        return 0;
                }
                msleep(50);
                printf("No key !!!\n");
        }
#else
        if (checkRecoveryKey()) {
                return 0;
        }
#endif
        return 1;
}

U_BOOT_CMD(irdetect, 1, 1, do_irdetect,
                "Detect IR Key to start recovery system","[<string>]\n"
          );

#endif
