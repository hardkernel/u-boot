#include <asm/io.h>
#include <common.h>
#include <command.h>
#include <asm/arch/secure_apb.h>
#include <asm/cpu_id.h>

#define KEY_PARAMS_NUM  10
#define OTHER_PARAMS_NUM 1

extern uint32_t get_time(void);

void init_custom_trigger(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXTVBB) {
		setbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 12); // SET IR_DEC_INPUT
	} else {
		setbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 0);  // SET IR_DEC_INPUT
		clrbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 21); //CLEAR IR_REMOTE_OUTPUT
	}
	writel((readl(P_AO_MF_IR_DEC_REG1) | (1 << 15)), P_AO_MF_IR_DEC_REG1);
}

void ir_release(void)
{
	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXTVBB) {
		clrbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 12);
	} else {
	    clrbits_le32(P_AO_RTI_PIN_MUX_REG, 1 << 0);
	}
}

uint32_t read_key(void)
{
	unsigned int keycode;

	if (!(readl(P_AO_MF_IR_DEC_STATUS) & (1<<3))) {
		return 0;
	}

	keycode = readl(P_AO_MF_IR_DEC_FRAME);

	printf("keycode = %x\n",keycode);
	return keycode;
}

static int do_irkey(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	uint32_t key_buf[KEY_PARAMS_NUM];
	uint32_t time_out = 0;
	uint32_t time_base = 0;
	uint32_t key;
	char *endp;
	char str[8];
	u8 i;

	/*at least set a key*/
	if (argc < 3)
		return -1;

	/*obtain timeout time*/
	time_out = simple_strtoul(argv[1], &endp, 0);
	printf("time_out = %x\n",time_out);
	if (*argv[1] == 0 || *endp != 0)
		return -1;

	/*obtain IR keys value which need to detect*/
	for (i=2; i<argc; i++) {
		key_buf[i-2] = simple_strtoul(argv[i], &endp, 0);
		printf("key[%d] = %x\n",i-2, key_buf[i-2]);
		if (*argv[i] == 0 || *endp != 0)
			return -1;
	}

	init_custom_trigger();

	time_base = get_time();

	while ((get_time() - time_base) < time_out)
	{
		key = read_key();
		for (i=2; i<argc; i++) {
			if (key == key_buf[i-2]) {
				sprintf(str, "0x%x", key);
				setenv("irkey_value",str);
				ir_release();
				return 0;
			}
		}
	}
	ir_release();
	return -1;
}
/*Maxium key arguments: 10*/
U_BOOT_CMD(
	irkey, (KEY_PARAMS_NUM + OTHER_PARAMS_NUM + 1), 0, do_irkey,
	"irkey <timeout> <key1> ...<keyN> - maximum value of N: 10",
	NULL
);
