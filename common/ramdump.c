#include <common.h>
#include <asm/arch/bl31_apis.h>
#include <asm/reboot.h>
#include <asm/arch/secure_apb.h>
#include <ramdump.h>
#include <emmc_partitions.h>
#include <asm/cpu_id.h>

#define DEBUG_RAMDUMP	0

unsigned long ramdump_base = 0;
unsigned long ramdump_size = 0;
unsigned int get_reboot_mode(void)
{
	uint32_t reboot_mode_val = ((readl(AO_SEC_SD_CFG15) >> 12) & 0xf);

	return reboot_mode_val;
}

void ramdump_init(void)
{
	unsigned int data;

	ramdump_base = readl(P_AO_SEC_GP_CFG12);
	ramdump_size = readl(P_AO_SEC_GP_CFG13);

	data = readl(PREG_STICKY_REG8);
	writel(data & ~RAMDUMP_STICKY_DATA_MASK, PREG_STICKY_REG8);
	printf("%s, add:%lx, size:%lx\n", __func__, ramdump_base, ramdump_size);
}

/*
 * NOTE: this is a default impemention for writing compressed ramdump data
 * to /data/ partition for Android platform. You can read out dumpfile in
 * path /data/crashdump-1.bin when enter Android for crash analyze.
 * by default, /data/ partion for android is EXT4 fs.
 *
 * TODO:
 *    If you are using different fs or OS on your platform, implement compress
 *    data save command for your fs and OS in your board.c with same function
 *    name "ramdump_save_compress_data".
 */
__weak int ramdump_save_compress_data(void)
{
	int data_pid;
	char cmd[128] = {0};

	data_pid = get_partition_num_by_name("data");
	if (data_pid < 0) {
		printf("can't find data partition\n");
		return -1;
	}
	sprintf(cmd, "ext4write mmc 1:%x %lx /crashdump-1.bin %lx\n",
		data_pid, ramdump_base, ramdump_size);
	printf("CMD:%s\n", cmd);
	run_command(cmd, 1);
	return 0;
}

void check_ramdump(void)
{
	unsigned long size = 0;
	unsigned long addr = 0;
	char *env;
	int reboot_mode;

	env = getenv("ramdump_enable");
	if (env) {
		printf("%s,%s\n", __func__, env);
		if (!strcmp(env, "1")) {
			reboot_mode = get_reboot_mode();
			if ((reboot_mode == AMLOGIC_WATCHDOG_REBOOT ||
			     reboot_mode == AMLOGIC_KERNEL_PANIC)) {
				addr = ramdump_base;
				size = ramdump_size;
				printf("%s, addr:%lx, size:%lx\n",
					__func__, addr, size);
				if (addr && size)
					ramdump_save_compress_data();
			}
		}
	}
}
