#include <common.h>
#include <boot_rkimg.h>

static int do_setbootdev(cmd_tbl_t *cmdtp, int flag,
			int argc, char *const argv[])
{
	struct blk_desc *dev_desc;

	if (argc != 3)
		return CMD_RET_USAGE;

	dev_desc = blk_get_dev(argv[1], simple_strtoul(argv[2], NULL, 16));
	if (!dev_desc) {
		printf("%s: dev_desc is NULL.\n", __func__);
		return CMD_RET_FAILURE;
	}

	rockchip_set_bootdev(dev_desc);

	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	setbootdev, 3, 0, do_setbootdev,
	"Set bootting device descriptor",
	"<devtype> <devnum>"
);
