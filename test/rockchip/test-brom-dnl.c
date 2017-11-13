#include <common.h>
#include <asm/io.h>
#include <asm/arch/boot_mode.h>

int board_brom_dnl_test(int argc, char * const argv[])
{
	writel(BOOT_BROM_DOWNLOAD, CONFIG_ROCKCHIP_BOOT_MODE_REG);
	return do_reset(NULL, 0, 0, NULL);
}
