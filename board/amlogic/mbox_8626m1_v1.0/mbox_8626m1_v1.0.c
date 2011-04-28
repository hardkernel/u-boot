#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>

DECLARE_GLOBAL_DATA_PTR;

int board_init(void)
{
	gd->bd->bi_arch_number=MACH_TYPE_MESON_8626M;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;
	return 0;
}

