#include <asm/io.h>
#include <common.h>
#include <command.h>
#include <asm/arch/secure_apb.h>

unsigned int keycode;

extern uint32_t get_time(void);

void init_custom_trigger(void)
{
    printf("ir init\n");

    setbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 0); // SET IR_DEC_INPUT
    clrbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 21); // CLEAR IR_REMOTE_OUTPU

    writel((readl(P_AO_MF_IR_DEC_REG1) | (1 << 15)), P_AO_MF_IR_DEC_REG1);
    //printf("P_AO_IR_DEC_REG0:%x, P_AO_IR_DEC_REG1:%x\n", readl(P_AO_IR_DEC_REG0),readl(P_AO_IR_DEC_REG1));
}

void ir_release(void)
{
    clrbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 0);
}

uint32_t read_key(void)
{
    if (!(readl(P_AO_MF_IR_DEC_STATUS) & (1<<3))) {
        return 0;
    }

    keycode = readl(P_AO_MF_IR_DEC_FRAME);

    printf("keycode = %x\n",keycode);
    return keycode;
}

static int do_irkey(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    uint32_t key = 0, key1 = 0, key2 = 0;
    uint32_t time_out = 0;
    uint32_t time_base = 0;
    char *endp;
    char str[8];

    if (argc < 4) {
        goto usage;
    }

   key1 = simple_strtoul(argv[1], &endp, 0);
   printf("key1 = %x\n",key1);
   if (*argv[1] == 0 || *endp != 0)
       goto usage;

   key2 = simple_strtoul(argv[2], &endp, 0);
   printf("key2 = %x\n",key2);
   if (*argv[2] == 0 || *endp != 0)
       goto usage;

   time_out = simple_strtoul(argv[3], &endp, 0);
   printf("time_out = %x\n",time_out);
   if (*argv[3] == 0 || *endp != 0)
       goto usage;

    init_custom_trigger();

    time_base = get_time();
    while ((get_time() - time_base) < time_out)
    {
       key = read_key();
       if (key == key1 || key == key2)
       {
            printf("ok\n");
            sprintf(str, "0x%x", key);
            setenv("irkey_value",str);
            ir_release();
            return 0;
        }
    }
   ir_release();
    return -1;
usage:
    puts("Usage: irkey key_value1 key_value2 time_value \n");
    return -1;
}

U_BOOT_CMD(
    irkey, 4, 0, do_irkey,
    "irkey key_value1 key_value2 time_value",
    ""
);
