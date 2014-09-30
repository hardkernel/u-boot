#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <nand.h>
#include <asm/arch/nand.h>
#include <common.h>
#include <linux/ctype.h>
#include <asm/byteorder.h>
#include <div64.h>
#include <linux/err.h>
#include <partition_table.h>

int info_disprotect = 0;

static inline int isstring(char *p)
{
        char *endptr = p;
        while (*endptr != '\0') {
                if (!(((*endptr >= '0') && (*endptr <= '9'))
                                        || ((*endptr >= 'a') && (*endptr <= 'f'))
                                        || ((*endptr >= 'A') && (*endptr <= 'F'))
                                        || (*endptr == 'x') || (*endptr == 'X'))) {
                        return 1;
                }
                endptr++;
        }

        return 0;
}

static inline int str2long(char *p, ulong *num)
{
        char *endptr;
        *num = simple_strtoul(p, &endptr, 16);
        return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static inline int str2longlong(char *p, unsigned long long *num)
{
        char *endptr;

        *num = simple_strtoull(p, &endptr, 16);
        if (*endptr != '\0') {
                switch(*endptr) {
                case 'g':
                case 'G':
                        *num <<= 10;
                case 'm':
                case 'M':
                        *num <<= 10;
                case 'k':
                case 'K':
                        *num <<= 10;
                        endptr++;
                        break;
                }
        }

        return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static int get_off_size(int argc, char *argv[],  loff_t *off, loff_t *size)
{
        if (argc >= 1) {
                if (!(str2longlong(argv[0], (unsigned long long*)off))) {
                        printf("'%s' is not a number\n", argv[0]);
                        return -1;
                }
        } else {
                *off = 0;
                *size = 0;
        }

        if (argc >= 2) {
                if (!(str2longlong(argv[1], (unsigned long long *)size))) {
                        printf("'%s' is not a number\n", argv[1]);
                        return -1;
                }
        } else {
                *size = 0;
        }

        store_dbg("offset 0x%llx, size 0x%llx", *off, *size);

        return 0;
}

int do_movi(cmd_tbl_t* cmdtp, int flag, int argc, char *argv[])
{
        int ret = 0;
        unsigned addr, offset, bytes;
        char *cmd, *s;
        char str[128];

        if (argc < 2)
                goto usage;

        cmd = argv[1];

        if (!strcmp(cmd, "read") || !strcmp(cmd, "write")) {
                if (isstring(argv[2])) {
                        unsigned bytes_kb;

                        if (argc < 5) {
                                goto usage;
                        }

                        if (0 > board_find_partition(argv[2],
                                                &offset, &bytes)) {
                                printf("Not able to find the partition, %s\n",
                                                argv[2]);
                                return 1;
                        }

                        addr = simple_strtoul(argv[4], NULL, 16);

                        if (argc >= 6) {
                                bytes = simple_strtoul(argv[5], NULL, 16);
                        }
                } else {
                        if (argc < 6)
                                goto usage;

                        offset = simple_strtoul(argv[2], NULL, 16);
                        bytes = simple_strtoul(argv[4], NULL, 16);
                        addr = simple_strtoul(argv[5], NULL, 16);
                }

                sprintf(str, "mmc %s %s 0x%08x 0x%08x 0x%08x",
                                cmd, argv[3], addr, offset,
                                (bytes + 511) / 512);

                ret = run_command(str, 0);
                if (ret != 0) {
                        printf("mmc cmd %s failed \n", cmd);
                }
        } else {
                goto usage;
        }

        return ret;

usage:
        cmd_usage(cmdtp);
        return 1;

}

U_BOOT_CMD(movi, 7, 0, do_movi,
        "movi\t- sd/mmc r/w sub system for ODROID-C board",
        "movi read <sector #> <device #> <bytes(hex)> <address>\n"
        "movi write <sector #> <device #> <bytes(hex)> <address>\n"
        "     - Read/write data from/to SDCARD or eMMC"
        "movi read <parition> <device #> <address> [bytes(hex)]\n"
        "movi write <parition> <device #> <address> [bytes(hex)]\n"
        "     - Read/write the particular partition from/to SDCARD or eMMC\n"
);
